-- =====================================================================
-- Script_procedure.sql
-- TCC Rota Segura SP - função e procedures (MySQL 8.0)
-- Executar DEPOIS de Rota_Segura_SP.sql.
-- Erros de regra de negócio usam SIGNAL SQLSTATE '45000' com mensagem
-- iniciada pelo código da regra (RN01, RN02...), descrito no TCC.
-- =====================================================================

USE rota_segura_sp;

DELIMITER $$

-- ---------------------------------------------------------------------
-- FUNÇÃO fn_periodo_do_dia
-- Converte uma hora (0-23) no período do dia usado no painel.
-- ---------------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_periodo_do_dia$$
CREATE FUNCTION fn_periodo_do_dia(p_hora TINYINT UNSIGNED)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    RETURN CASE
        WHEN p_hora BETWEEN 0  AND 5  THEN 'MADRUGADA'
        WHEN p_hora BETWEEN 6  AND 11 THEN 'MANHA'
        WHEN p_hora BETWEEN 12 AND 17 THEN 'TARDE'
        ELSE 'NOITE'                                  -- 18h às 23h
    END;
END$$

-- ---------------------------------------------------------------------
-- PROCEDURE 1: sp_registrar_ocorrencia
-- Registra uma ocorrência validando tipo, local e quem está cadastrando.
-- Usa transação: se qualquer passo falhar (inclusive uma regra de
-- trigger), tudo é desfeito com ROLLBACK e o erro é repassado.
-- Regras: RN01 (tipo e local existem), RN08 (só moderador/administrador
-- ativo cadastra manualmente).
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_registrar_ocorrencia$$
CREATE PROCEDURE sp_registrar_ocorrencia(
    IN  p_id_tipo             TINYINT UNSIGNED,
    IN  p_id_local            INT UNSIGNED,
    IN  p_data_hora           DATETIME,
    IN  p_numero_bo           VARCHAR(30),
    IN  p_descricao           VARCHAR(255),
    IN  p_id_usuario_registro INT UNSIGNED,
    OUT p_id_ocorrencia       BIGINT UNSIGNED
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;                       -- devolve o erro original ao chamador
    END;

    START TRANSACTION;

    IF NOT EXISTS (SELECT 1 FROM tipos_crime WHERE id_tipo = p_id_tipo) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN01: tipo de crime inexistente.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM locais WHERE id_local = p_id_local) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN01: local inexistente.';
    END IF;

    IF p_id_usuario_registro IS NOT NULL AND NOT EXISTS (
           SELECT 1 FROM usuarios
            WHERE id_usuario = p_id_usuario_registro
              AND ativo = 1
              AND perfil IN ('MODERADOR','ADMINISTRADOR')) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN08: apenas moderador ou administrador ativo pode cadastrar ocorrências.';
    END IF;

    INSERT INTO ocorrencias
           (id_tipo, id_local, id_usuario_registro, data_hora, numero_bo, fonte, descricao)
    VALUES (p_id_tipo, p_id_local, p_id_usuario_registro, p_data_hora, p_numero_bo,
            IF(p_id_usuario_registro IS NULL, 'SSP_SP', 'CADASTRO_MANUAL'), p_descricao);

    SET p_id_ocorrencia = LAST_INSERT_ID();

    COMMIT;
END$$

-- ---------------------------------------------------------------------
-- PROCEDURE 2: sp_registrar_relato
-- Cadastra um relato colaborativo. p_id_usuario NULL = relato anônimo.
-- O relato sempre nasce PENDENTE (o trigger também garante isso).
-- Regras: RN05 (anonimato), RN06 (moderação), RN01.
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_registrar_relato$$
CREATE PROCEDURE sp_registrar_relato(
    IN  p_id_usuario     INT UNSIGNED,
    IN  p_id_local       INT UNSIGNED,
    IN  p_id_tipo        TINYINT UNSIGNED,      -- NULL = local considerado inseguro
    IN  p_data_hora_fato DATETIME,
    IN  p_descricao      VARCHAR(500),
    OUT p_id_relato      INT UNSIGNED
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM locais WHERE id_local = p_id_local) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN01: local inexistente.';
    END IF;

    IF p_id_tipo IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tipos_crime WHERE id_tipo = p_id_tipo) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN01: tipo de crime inexistente.';
    END IF;

    IF p_id_usuario IS NOT NULL AND NOT EXISTS (
           SELECT 1 FROM usuarios WHERE id_usuario = p_id_usuario AND ativo = 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN05: usuário inexistente ou inativo (use NULL para relato anônimo).';
    END IF;

    INSERT INTO relatos (id_usuario, id_local, id_tipo, data_hora_fato, descricao)
    VALUES (p_id_usuario, p_id_local, p_id_tipo, p_data_hora_fato, p_descricao);

    SET p_id_relato = LAST_INSERT_ID();
END$$

-- ---------------------------------------------------------------------
-- PROCEDURE 3: sp_moderar_relato
-- Aprova ou rejeita um relato pendente. Transação com ROLLBACK.
-- Regras: RN06 (só PENDENTE pode ser moderado), RN07 (só moderador ou
-- administrador ativo), RN09 (rejeição exige motivo).
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_moderar_relato$$
CREATE PROCEDURE sp_moderar_relato(
    IN p_id_relato    INT UNSIGNED,
    IN p_id_moderador INT UNSIGNED,
    IN p_decisao      VARCHAR(10),            -- 'APROVADO' ou 'REJEITADO'
    IN p_motivo       VARCHAR(255)
)
BEGIN
    DECLARE v_status_atual VARCHAR(10);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT status INTO v_status_atual
      FROM relatos
     WHERE id_relato = p_id_relato
       FOR UPDATE;                            -- trava a linha durante a decisão

    IF v_status_atual IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN06: relato inexistente.';
    END IF;

    IF p_decisao NOT IN ('APROVADO','REJEITADO') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN06: decisão deve ser APROVADO ou REJEITADO.';
    END IF;

    IF v_status_atual <> 'PENDENTE' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN06: o relato já foi moderado.';
    END IF;

    UPDATE relatos
       SET status           = p_decisao,
           id_moderador     = p_id_moderador,
           motivo_moderacao = p_motivo
     WHERE id_relato = p_id_relato;           -- o trigger valida moderador e motivo

    COMMIT;
END$$

-- ---------------------------------------------------------------------
-- PROCEDURE 4: sp_ranking_dp
-- Ranking de distritos policiais por período e tipo (JOIN + GROUP BY).
-- p_id_tipo NULL = todos os tipos. Mostra também furtos x roubos e o
-- percentual de cada DP no total do período.
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_ranking_dp$$
CREATE PROCEDURE sp_ranking_dp(
    IN p_data_ini DATE,
    IN p_data_fim DATE,
    IN p_id_tipo  TINYINT UNSIGNED,
    IN p_limite   INT
)
BEGIN
    IF p_data_fim < p_data_ini THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Período inválido: data final menor que a inicial.';
    END IF;

    SELECT  dp.numero                                   AS numero_dp,
            dp.nome                                     AS distrito,
            dp.regiao,
            COUNT(*)                                    AS total,
            SUM(t.com_violencia = 0)                    AS furtos,
            SUM(t.com_violencia = 1)                    AS roubos,
            ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_do_total
    FROM    ocorrencias o
    JOIN    tipos_crime t          ON t.id_tipo  = o.id_tipo
    JOIN    locais l               ON l.id_local = o.id_local
    JOIN    distritos_policiais dp ON dp.id_dp   = l.id_dp
    WHERE   o.data_hora >= p_data_ini
      AND   o.data_hora <  DATE_ADD(p_data_fim, INTERVAL 1 DAY)
      AND   (p_id_tipo IS NULL OR o.id_tipo = p_id_tipo)
    GROUP BY dp.id_dp, dp.numero, dp.nome, dp.regiao
    ORDER BY total DESC, dp.numero
    LIMIT p_limite;
END$$

-- ---------------------------------------------------------------------
-- PROCEDURE 5: sp_ocorrencias_por_horario
-- Alimenta o gráfico "ocorrências por horário" do painel.
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_ocorrencias_por_horario$$
CREATE PROCEDURE sp_ocorrencias_por_horario(
    IN p_data_ini DATE,
    IN p_data_fim DATE
)
BEGIN
    SELECT  o.hora,
            fn_periodo_do_dia(o.hora)  AS periodo,
            COUNT(*)                   AS total,
            SUM(t.com_violencia = 0)   AS furtos,
            SUM(t.com_violencia = 1)   AS roubos
    FROM    ocorrencias o
    JOIN    tipos_crime t ON t.id_tipo = o.id_tipo
    WHERE   o.data_hora >= p_data_ini
      AND   o.data_hora <  DATE_ADD(p_data_fim, INTERVAL 1 DAY)
    GROUP BY o.hora
    ORDER BY o.hora;
END$$

-- ---------------------------------------------------------------------
-- PROCEDURE 6: sp_orientacoes_por_tipo
-- Lista as orientações ativas para um tipo de crime (relacionamento
-- N:N). p_categoria NULL = prevenção e pós-ocorrência.
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_orientacoes_por_tipo$$
CREATE PROCEDURE sp_orientacoes_por_tipo(
    IN p_id_tipo   TINYINT UNSIGNED,
    IN p_categoria VARCHAR(15)
)
BEGIN
    SELECT  o.categoria,
            o.ordem,
            o.titulo,
            o.conteudo,
            o.fonte
    FROM    orientacoes o
    JOIN    tipo_crime_orientacao tco ON tco.id_orientacao = o.id_orientacao
    WHERE   tco.id_tipo = p_id_tipo
      AND   o.ativa = 1
      AND   (p_categoria IS NULL OR o.categoria = p_categoria)
    ORDER BY o.categoria DESC, o.ordem;       -- POS_OCORRENCIA antes de PREVENCAO
END$$

-- ---------------------------------------------------------------------
-- PROCEDURE 7: sp_variacao_mensal
-- Total por mês do ano e variação percentual sobre o mês anterior
-- (usa a tabela de resumo e a função de janela LAG).
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_variacao_mensal$$
CREATE PROCEDURE sp_variacao_mensal(IN p_ano SMALLINT UNSIGNED)
BEGIN
    SELECT  m.mes,
            m.total,
            LAG(m.total) OVER (ORDER BY m.mes) AS mes_anterior,
            ROUND(100 * (m.total - LAG(m.total) OVER (ORDER BY m.mes))
                      / NULLIF(LAG(m.total) OVER (ORDER BY m.mes), 0), 1) AS variacao_pct
    FROM   (SELECT mes, SUM(total) AS total
              FROM estatistica_dp_mensal
             WHERE ano = p_ano
             GROUP BY mes) AS m
    ORDER BY m.mes;
END$$

-- ---------------------------------------------------------------------
-- PROCEDURE 8: sp_recalcular_estatistica
-- Reconstrói a tabela de resumo de um ano a partir de OCORRENCIAS.
-- Serve para conferir/corrigir o que os triggers mantêm em tempo real.
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_recalcular_estatistica$$
CREATE PROCEDURE sp_recalcular_estatistica(IN p_ano SMALLINT UNSIGNED)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    DELETE FROM estatistica_dp_mensal WHERE ano = p_ano;

    INSERT INTO estatistica_dp_mensal (id_dp, ano, mes, id_tipo, total)
    SELECT  l.id_dp, YEAR(o.data_hora), MONTH(o.data_hora), o.id_tipo, COUNT(*)
    FROM    ocorrencias o
    JOIN    locais l ON l.id_local = o.id_local
    WHERE   o.data_hora >= MAKEDATE(p_ano, 1)
      AND   o.data_hora <  MAKEDATE(p_ano + 1, 1)
    GROUP BY l.id_dp, YEAR(o.data_hora), MONTH(o.data_hora), o.id_tipo;

    COMMIT;
END$$

DELIMITER ;

-- =====================================================================
-- EXEMPLOS DE CHAMADA (rode depois de carregar Script_trigger.sql e
-- Dados_exemplo.sql). IDs de usuário: 1 = administrador, 2 = moderador,
-- 3 = cidadão.
-- =====================================================================
-- CALL sp_registrar_ocorrencia(2, 1, '2026-06-05 20:10:00', '000777/2026', 'Roubo na saída da estação', 1, @id);
-- SELECT @id AS id_ocorrencia_criada;
--
-- CALL sp_registrar_relato(NULL, 3, 1, '2026-06-06 18:45:00', 'Aparelho levado do bolso no vagão lotado, horário de pico.', @id_relato);
-- CALL sp_moderar_relato(@id_relato, 2, 'APROVADO', NULL);
--
-- CALL sp_ranking_dp('2026-01-01', '2026-06-30', NULL, 5);
-- CALL sp_ocorrencias_por_horario('2026-01-01', '2026-06-30');
-- CALL sp_orientacoes_por_tipo(2, 'POS_OCORRENCIA');
-- CALL sp_variacao_mensal(2026);
-- CALL sp_recalcular_estatistica(2026);
