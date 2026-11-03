-- =====================================================================
-- Script_trigger.sql
-- TCC Rota Segura SP - triggers com aplicação prática (MySQL 8.0)
-- Executar DEPOIS de Rota_Segura_SP.sql e Script_procedure.sql.
--
-- Triggers deste arquivo:
--   trg_usuarios_bi / trg_usuarios_bu   normaliza e valida e-mail (RN11)
--   trg_ocorrencias_bi                  data não futura, BO limpo (RN03)
--   trg_ocorrencias_ai                  resumo mensal + auditoria (RN10)
--   trg_ocorrencias_au                  ajusta resumo + auditoria  (RN10)
--   trg_ocorrencias_ad                  desconta do resumo + auditoria (RN10)
--   trg_relatos_bi                      anonimato e limpeza do texto (RN05, RN06)
--   trg_relatos_bu                      regras de moderação (RN06, RN07, RN09)
-- =====================================================================

USE rota_segura_sp;

DELIMITER $$

-- ---------------------------------------------------------------------
-- USUARIOS: e-mail em minúsculas, sem espaços e com formato mínimo válido
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_usuarios_bi$$
CREATE TRIGGER trg_usuarios_bi
BEFORE INSERT ON usuarios
FOR EACH ROW
BEGIN
    SET NEW.nome  = TRIM(NEW.nome);
    SET NEW.email = LOWER(TRIM(NEW.email));

    IF NEW.email NOT LIKE '_%@_%.__%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN11: e-mail em formato inválido.';
    END IF;
END$$

DROP TRIGGER IF EXISTS trg_usuarios_bu$$
CREATE TRIGGER trg_usuarios_bu
BEFORE UPDATE ON usuarios
FOR EACH ROW
BEGIN
    SET NEW.nome  = TRIM(NEW.nome);
    SET NEW.email = LOWER(TRIM(NEW.email));

    IF NEW.email NOT LIKE '_%@_%.__%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN11: e-mail em formato inválido.';
    END IF;
END$$

-- ---------------------------------------------------------------------
-- OCORRENCIAS - BEFORE INSERT
-- Bloqueia data futura e padroniza o número do BO (vazio vira NULL, para
-- que a restrição UNIQUE não trate "" como um valor repetido).
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_ocorrencias_bi$$
CREATE TRIGGER trg_ocorrencias_bi
BEFORE INSERT ON ocorrencias
FOR EACH ROW
BEGIN
    IF NEW.data_hora > NOW() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN03: a data/hora da ocorrência não pode estar no futuro.';
    END IF;

    SET NEW.numero_bo = NULLIF(TRIM(NEW.numero_bo), '');
END$$

-- ---------------------------------------------------------------------
-- OCORRENCIAS - AFTER INSERT
-- 1) soma 1 no resumo mensal do DP do local; 2) grava a auditoria.
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_ocorrencias_ai$$
CREATE TRIGGER trg_ocorrencias_ai
AFTER INSERT ON ocorrencias
FOR EACH ROW
BEGIN
    DECLARE v_dp SMALLINT UNSIGNED;

    SELECT id_dp INTO v_dp FROM locais WHERE id_local = NEW.id_local;

    INSERT INTO estatistica_dp_mensal (id_dp, ano, mes, id_tipo, total)
    VALUES (v_dp, YEAR(NEW.data_hora), MONTH(NEW.data_hora), NEW.id_tipo, 1)
    ON DUPLICATE KEY UPDATE total = total + 1;

    INSERT INTO auditoria_ocorrencias
           (id_ocorrencia, acao, dados_anteriores, dados_novos, usuario_bd)
    VALUES (NEW.id_ocorrencia, 'INSERT', NULL,
            JSON_OBJECT('id_tipo', NEW.id_tipo, 'id_local', NEW.id_local,
                        'data_hora', NEW.data_hora, 'numero_bo', NEW.numero_bo),
            CURRENT_USER());
END$$

-- ---------------------------------------------------------------------
-- OCORRENCIAS - AFTER UPDATE
-- Se mudou tipo, local ou data, desconta do grupo antigo e soma no novo.
-- Sempre registra o antes e o depois na auditoria.
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_ocorrencias_au$$
CREATE TRIGGER trg_ocorrencias_au
AFTER UPDATE ON ocorrencias
FOR EACH ROW
BEGIN
    DECLARE v_dp_antigo SMALLINT UNSIGNED;
    DECLARE v_dp_novo   SMALLINT UNSIGNED;

    IF OLD.id_tipo  <> NEW.id_tipo
       OR OLD.id_local <> NEW.id_local
       OR OLD.data_hora <> NEW.data_hora THEN

        SELECT id_dp INTO v_dp_antigo FROM locais WHERE id_local = OLD.id_local;
        SELECT id_dp INTO v_dp_novo   FROM locais WHERE id_local = NEW.id_local;

        UPDATE estatistica_dp_mensal
           SET total = GREATEST(total - 1, 0)
         WHERE id_dp = v_dp_antigo
           AND ano   = YEAR(OLD.data_hora)
           AND mes   = MONTH(OLD.data_hora)
           AND id_tipo = OLD.id_tipo;

        INSERT INTO estatistica_dp_mensal (id_dp, ano, mes, id_tipo, total)
        VALUES (v_dp_novo, YEAR(NEW.data_hora), MONTH(NEW.data_hora), NEW.id_tipo, 1)
        ON DUPLICATE KEY UPDATE total = total + 1;
    END IF;

    INSERT INTO auditoria_ocorrencias
           (id_ocorrencia, acao, dados_anteriores, dados_novos, usuario_bd)
    VALUES (NEW.id_ocorrencia, 'UPDATE',
            JSON_OBJECT('id_tipo', OLD.id_tipo, 'id_local', OLD.id_local,
                        'data_hora', OLD.data_hora, 'numero_bo', OLD.numero_bo),
            JSON_OBJECT('id_tipo', NEW.id_tipo, 'id_local', NEW.id_local,
                        'data_hora', NEW.data_hora, 'numero_bo', NEW.numero_bo),
            CURRENT_USER());
END$$

-- ---------------------------------------------------------------------
-- OCORRENCIAS - AFTER DELETE
-- Desconta do resumo e guarda na auditoria o que foi apagado.
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_ocorrencias_ad$$
CREATE TRIGGER trg_ocorrencias_ad
AFTER DELETE ON ocorrencias
FOR EACH ROW
BEGIN
    DECLARE v_dp SMALLINT UNSIGNED;

    SELECT id_dp INTO v_dp FROM locais WHERE id_local = OLD.id_local;

    UPDATE estatistica_dp_mensal
       SET total = GREATEST(total - 1, 0)
     WHERE id_dp = v_dp
       AND ano   = YEAR(OLD.data_hora)
       AND mes   = MONTH(OLD.data_hora)
       AND id_tipo = OLD.id_tipo;

    INSERT INTO auditoria_ocorrencias
           (id_ocorrencia, acao, dados_anteriores, dados_novos, usuario_bd)
    VALUES (OLD.id_ocorrencia, 'DELETE',
            JSON_OBJECT('id_tipo', OLD.id_tipo, 'id_local', OLD.id_local,
                        'data_hora', OLD.data_hora, 'numero_bo', OLD.numero_bo),
            NULL, CURRENT_USER());
END$$

-- ---------------------------------------------------------------------
-- RELATOS - BEFORE INSERT
-- Protege a privacidade: rejeita textos com e-mail ou sequência longa de
-- dígitos (telefone, CPF, RG...). Também força o status PENDENTE e limpa
-- campos de moderação, mesmo que a aplicação tente enviá-los.
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_relatos_bi$$
CREATE TRIGGER trg_relatos_bi
BEFORE INSERT ON relatos
FOR EACH ROW
BEGIN
    DECLARE v_sem_separadores VARCHAR(500);

    SET NEW.descricao = TRIM(NEW.descricao);

    IF NEW.data_hora_fato > NOW() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN03: a data/hora do fato não pode estar no futuro.';
    END IF;

    -- remove separadores comuns para pegar telefones como (11) 98888-7777
    SET v_sem_separadores = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                NEW.descricao, ' ', ''), '-', ''), '(', ''), ')', ''), '.', '');

    IF NEW.descricao LIKE '%@%' OR v_sem_separadores REGEXP '[0-9]{8,}' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN05: não informe dados pessoais (e-mail, telefone, CPF) no relato.';
    END IF;

    SET NEW.status           = 'PENDENTE';
    SET NEW.id_moderador     = NULL;
    SET NEW.data_moderacao   = NULL;
    SET NEW.motivo_moderacao = NULL;
END$$

-- ---------------------------------------------------------------------
-- RELATOS - BEFORE UPDATE
-- Regras da moderação: só PENDENTE muda de status; precisa de moderador
-- ativo; rejeição exige motivo; texto não pode ser alterado depois de
-- moderado; a data da moderação é preenchida automaticamente.
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_relatos_bu$$
CREATE TRIGGER trg_relatos_bu
BEFORE UPDATE ON relatos
FOR EACH ROW
BEGIN
    IF OLD.status <> 'PENDENTE' THEN
        IF NEW.status <> OLD.status THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN06: relato já moderado não pode mudar de status.';
        END IF;
        IF NEW.descricao <> OLD.descricao THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN06: o texto de um relato moderado não pode ser alterado.';
        END IF;
    END IF;

    IF OLD.status = 'PENDENTE' AND NEW.status <> 'PENDENTE' THEN

        IF NEW.id_moderador IS NULL OR NOT EXISTS (
               SELECT 1 FROM usuarios
                WHERE id_usuario = NEW.id_moderador
                  AND ativo = 1
                  AND perfil IN ('MODERADOR','ADMINISTRADOR')) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN07: apenas moderador ou administrador ativo pode moderar relatos.';
        END IF;

        IF NEW.status = 'REJEITADO' AND (NEW.motivo_moderacao IS NULL OR TRIM(NEW.motivo_moderacao) = '') THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN09: informe o motivo da rejeição.';
        END IF;

        SET NEW.data_moderacao = NOW();
    END IF;
END$$

DELIMITER ;

-- =====================================================================
-- TESTES SUGERIDOS (execute depois de Dados_exemplo.sql)
-- =====================================================================
-- 1) Data futura é bloqueada (RN03):
--    INSERT INTO ocorrencias (id_tipo, id_local, data_hora) VALUES (1, 1, '2099-01-01 10:00:00');
--
-- 2) Resumo mensal atualizado sozinho (RN10):
--    SELECT * FROM estatistica_dp_mensal WHERE id_dp = 1 AND ano = 2026;
--    INSERT INTO ocorrencias (id_tipo, id_local, data_hora) VALUES (1, 1, '2026-03-10 09:00:00');
--    SELECT * FROM estatistica_dp_mensal WHERE id_dp = 1 AND ano = 2026;
--
-- 3) Auditoria:
--    UPDATE ocorrencias SET id_tipo = 2 WHERE id_ocorrencia = 1;
--    SELECT * FROM auditoria_ocorrencias ORDER BY id_auditoria DESC LIMIT 3;
--
-- 4) Dado pessoal em relato é bloqueado (RN05):
--    INSERT INTO relatos (id_local, data_hora_fato, descricao)
--    VALUES (1, '2026-06-01 19:00:00', 'Me roubaram, ligue para (11) 98888-7777');
--
-- 5) Moderação sem motivo de rejeição (RN09):
--    (o relato 5 continua PENDENTE nos dados de exemplo)
--    UPDATE relatos SET status = 'REJEITADO', id_moderador = 2 WHERE id_relato = 5;
