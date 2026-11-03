-- =====================================================================
-- Rota_Segura_SP.sql
-- TCC Etec - Técnico em Desenvolvimento de Sistemas
-- Tema: Rota Segura SP - registro e consulta de ocorrências de furto e
--       roubo de celular na cidade de São Paulo
-- SGBD: MySQL 8.0.16 ou superior (usa CHECK, colunas geradas e JSON)
--
-- Ordem de execução dos arquivos:
--   1) Rota_Segura_SP.sql       (este: estrutura + dados de referência)
--   2) Script_procedure.sql     (função e procedures)
--   3) Script_trigger.sql       (triggers)
--   4) Dados_exemplo.sql        (opcional: dados FICTÍCIOS para testes)
--   5) Consultas_relatorios.sql (opcional: consultas JOIN / GROUP BY)
-- =====================================================================

DROP DATABASE IF EXISTS rota_segura_sp;

CREATE DATABASE rota_segura_sp
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE rota_segura_sp;

-- ---------------------------------------------------------------------
-- 1. USUARIOS
--    Quem acessa o sistema. O relato colaborativo NÃO exige usuário
--    (pode ser anônimo); usuários cadastrados são cidadãos que querem
--    acompanhar seus relatos, moderadores e administradores.
-- ---------------------------------------------------------------------
CREATE TABLE usuarios (
    id_usuario   INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nome         VARCHAR(100)  NOT NULL,
    email        VARCHAR(120)  NOT NULL,
    senha_hash   VARCHAR(255)  NOT NULL COMMENT 'hash (bcrypt/argon2) gerado pela aplicação; nunca a senha pura',
    perfil       ENUM('CIDADAO','MODERADOR','ADMINISTRADOR') NOT NULL DEFAULT 'CIDADAO',
    ativo        TINYINT(1)    NOT NULL DEFAULT 1,
    criado_em    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_usuarios PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuarios_email UNIQUE (email)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 2. DISTRITOS_POLICIAIS
--    A SSP-SP divulga as estatísticas por distrito policial (DP), e não
--    por bairro exato. Por isso o DP é a unidade de agregação do painel.
-- ---------------------------------------------------------------------
CREATE TABLE distritos_policiais (
    id_dp    SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    numero   SMALLINT UNSIGNED NOT NULL COMMENT 'número oficial do DP (ex.: 14 = 14º DP)',
    nome     VARCHAR(80)       NOT NULL,
    regiao   ENUM('CENTRO','ZONA NORTE','ZONA SUL','ZONA LESTE','ZONA OESTE') NOT NULL,
    CONSTRAINT pk_distritos_policiais PRIMARY KEY (id_dp),
    CONSTRAINT uq_dp_numero UNIQUE (numero)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 3. LOCAIS
--    Pontos onde ocorrem os crimes ou onde há relatos (estações, vias,
--    terminais...). Cada local pertence a exatamente um DP.
-- ---------------------------------------------------------------------
CREATE TABLE locais (
    id_local    INT UNSIGNED      NOT NULL AUTO_INCREMENT,
    id_dp       SMALLINT UNSIGNED NOT NULL,
    nome        VARCHAR(120)      NOT NULL,
    tipo_local  ENUM('VIA_PUBLICA','ESTACAO_METRO_TREM','TERMINAL_ONIBUS',
                     'TRANSPORTE_COLETIVO','COMERCIO_SHOPPING',
                     'ESCOLA_UNIVERSIDADE','OUTRO') NOT NULL DEFAULT 'VIA_PUBLICA',
    logradouro  VARCHAR(150)      NULL,
    bairro      VARCHAR(80)       NOT NULL,
    latitude    DECIMAL(9,6)      NULL,
    longitude   DECIMAL(9,6)      NULL,
    CONSTRAINT pk_locais PRIMARY KEY (id_local),
    CONSTRAINT fk_locais_dp FOREIGN KEY (id_dp)
        REFERENCES distritos_policiais (id_dp)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    -- limites aproximados do município de São Paulo
    CONSTRAINT ck_locais_lat  CHECK (latitude  IS NULL OR latitude  BETWEEN -24.10 AND -23.30),
    CONSTRAINT ck_locais_lon  CHECK (longitude IS NULL OR longitude BETWEEN -46.90 AND -46.30),
    CONSTRAINT ck_locais_par  CHECK ((latitude IS NULL) = (longitude IS NULL)),
    INDEX idx_locais_dp (id_dp),
    INDEX idx_locais_bairro (bairro)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 4. TIPOS_CRIME
--    Furto (sem violência) x roubo (com violência ou grave ameaça).
-- ---------------------------------------------------------------------
CREATE TABLE tipos_crime (
    id_tipo       TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome          VARCHAR(60)      NOT NULL,
    descricao     VARCHAR(255)     NULL,
    artigo_cp     VARCHAR(20)      NULL COMMENT 'artigo do Código Penal (Decreto-Lei 2.848/1940)',
    com_violencia TINYINT(1)       NOT NULL DEFAULT 0,
    CONSTRAINT pk_tipos_crime PRIMARY KEY (id_tipo),
    CONSTRAINT uq_tipos_crime_nome UNIQUE (nome)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 5. OCORRENCIAS
--    Registros consolidados (dados oficiais da SSP-SP ou cadastro feito
--    por administrador). Alimentam o painel e as estatísticas.
-- ---------------------------------------------------------------------
CREATE TABLE ocorrencias (
    id_ocorrencia        BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_tipo              TINYINT UNSIGNED NOT NULL,
    id_local             INT UNSIGNED     NOT NULL,
    id_usuario_registro  INT UNSIGNED     NULL COMMENT 'quem cadastrou/importou; NULL = importação automática',
    data_hora            DATETIME         NOT NULL,
    hora                 TINYINT UNSIGNED GENERATED ALWAYS AS (HOUR(data_hora)) STORED,
    numero_bo            VARCHAR(30)      NULL COMMENT 'número do boletim de ocorrência (ex.: 000123/2026)',
    fonte                ENUM('SSP_SP','CADASTRO_MANUAL') NOT NULL DEFAULT 'SSP_SP',
    descricao            VARCHAR(255)     NULL,
    criado_em            DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_ocorrencias PRIMARY KEY (id_ocorrencia),
    CONSTRAINT uq_ocorrencias_bo UNIQUE (numero_bo),
    CONSTRAINT fk_ocorrencias_tipo FOREIGN KEY (id_tipo)
        REFERENCES tipos_crime (id_tipo)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ocorrencias_local FOREIGN KEY (id_local)
        REFERENCES locais (id_local)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ocorrencias_usuario FOREIGN KEY (id_usuario_registro)
        REFERENCES usuarios (id_usuario)
        ON UPDATE CASCADE ON DELETE SET NULL,
    INDEX idx_ocorrencias_data (data_hora),
    INDEX idx_ocorrencias_local (id_local),
    INDEX idx_ocorrencias_tipo_data (id_tipo, data_hora),
    INDEX idx_ocorrencias_hora (hora)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 6. RELATOS
--    Relato colaborativo e anônimo. NÃO substitui o boletim de
--    ocorrência e NÃO entra nas estatísticas oficiais. Só aparece
--    publicamente depois de aprovado por um moderador.
--    id_usuario NULL = relato anônimo. id_tipo NULL = "local
--    considerado inseguro", sem crime específico.
-- ---------------------------------------------------------------------
CREATE TABLE relatos (
    id_relato         INT UNSIGNED     NOT NULL AUTO_INCREMENT,
    id_usuario        INT UNSIGNED     NULL,
    id_local          INT UNSIGNED     NOT NULL,
    id_tipo           TINYINT UNSIGNED NULL,
    data_hora_fato    DATETIME         NOT NULL,
    descricao         VARCHAR(500)     NOT NULL,
    status            ENUM('PENDENTE','APROVADO','REJEITADO') NOT NULL DEFAULT 'PENDENTE',
    id_moderador      INT UNSIGNED     NULL,
    data_moderacao    DATETIME         NULL,
    motivo_moderacao  VARCHAR(255)     NULL,
    criado_em         DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_relatos PRIMARY KEY (id_relato),
    CONSTRAINT fk_relatos_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuarios (id_usuario)
        ON UPDATE CASCADE ON DELETE SET NULL,      -- ao excluir a conta, o relato vira anônimo
    CONSTRAINT fk_relatos_local FOREIGN KEY (id_local)
        REFERENCES locais (id_local)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_relatos_tipo FOREIGN KEY (id_tipo)
        REFERENCES tipos_crime (id_tipo)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_relatos_moderador FOREIGN KEY (id_moderador)
        REFERENCES usuarios (id_usuario)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT ck_relatos_descricao CHECK (CHAR_LENGTH(descricao) >= 10),
    INDEX idx_relatos_status (status),
    INDEX idx_relatos_local (id_local)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 7. ORIENTACOES
--    Conteúdo de prevenção e de providências pós-ocorrência.
-- ---------------------------------------------------------------------
CREATE TABLE orientacoes (
    id_orientacao  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    titulo         VARCHAR(120)      NOT NULL,
    conteudo       TEXT              NOT NULL,
    categoria      ENUM('PREVENCAO','POS_OCORRENCIA') NOT NULL,
    ordem          TINYINT UNSIGNED  NOT NULL DEFAULT 1 COMMENT 'ordem de exibição dentro da categoria',
    fonte          VARCHAR(150)      NULL,
    ativa          TINYINT(1)        NOT NULL DEFAULT 1,
    atualizado_em  DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_orientacoes PRIMARY KEY (id_orientacao),
    INDEX idx_orientacoes_categoria (categoria, ordem)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 8. TIPO_CRIME_ORIENTACAO  (relacionamento N:N)
--    Uma orientação pode valer para furto, roubo ou ambos.
-- ---------------------------------------------------------------------
CREATE TABLE tipo_crime_orientacao (
    id_tipo        TINYINT UNSIGNED  NOT NULL,
    id_orientacao  SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT pk_tipo_crime_orientacao PRIMARY KEY (id_tipo, id_orientacao),
    CONSTRAINT fk_tco_tipo FOREIGN KEY (id_tipo)
        REFERENCES tipos_crime (id_tipo)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_tco_orientacao FOREIGN KEY (id_orientacao)
        REFERENCES orientacoes (id_orientacao)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 9. ESTATISTICA_DP_MENSAL
--    Tabela de resumo (total por DP, mês e tipo). É mantida
--    automaticamente pelos triggers de OCORRENCIAS (ver
--    Script_trigger.sql) e alimenta o painel sem varrer a tabela toda.
-- ---------------------------------------------------------------------
CREATE TABLE estatistica_dp_mensal (
    id_dp    SMALLINT UNSIGNED NOT NULL,
    ano      SMALLINT UNSIGNED NOT NULL,
    mes      TINYINT UNSIGNED  NOT NULL,
    id_tipo  TINYINT UNSIGNED  NOT NULL,
    total    INT UNSIGNED      NOT NULL DEFAULT 0,
    CONSTRAINT pk_estatistica_dp_mensal PRIMARY KEY (id_dp, ano, mes, id_tipo),
    CONSTRAINT fk_est_dp FOREIGN KEY (id_dp)
        REFERENCES distritos_policiais (id_dp)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_est_tipo FOREIGN KEY (id_tipo)
        REFERENCES tipos_crime (id_tipo)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_est_mes CHECK (mes BETWEEN 1 AND 12)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 10. AUDITORIA_OCORRENCIAS
--     Histórico de inclusões, alterações e exclusões em OCORRENCIAS
--     (preenchido por triggers). Não tem FK de propósito: o histórico
--     deve sobreviver à exclusão da ocorrência.
-- ---------------------------------------------------------------------
CREATE TABLE auditoria_ocorrencias (
    id_auditoria      BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_ocorrencia     BIGINT UNSIGNED NOT NULL,
    acao              ENUM('INSERT','UPDATE','DELETE') NOT NULL,
    dados_anteriores  JSON            NULL,
    dados_novos       JSON            NULL,
    usuario_bd        VARCHAR(100)    NOT NULL,
    data_acao         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_auditoria_ocorrencias PRIMARY KEY (id_auditoria),
    INDEX idx_auditoria_ocorrencia (id_ocorrencia)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- VIEWS
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_ocorrencias_detalhe AS
SELECT  o.id_ocorrencia,
        o.data_hora,
        o.hora,
        t.nome        AS tipo_crime,
        t.com_violencia,
        l.nome        AS local,
        l.tipo_local,
        l.bairro,
        dp.numero     AS numero_dp,
        dp.nome       AS nome_dp,
        dp.regiao,
        o.numero_bo,
        o.fonte
FROM    ocorrencias o
JOIN    tipos_crime t          ON t.id_tipo  = o.id_tipo
JOIN    locais l               ON l.id_local = o.id_local
JOIN    distritos_policiais dp ON dp.id_dp   = l.id_dp;

CREATE OR REPLACE VIEW vw_relatos_publicos AS
SELECT  r.id_relato,
        r.data_hora_fato,
        l.nome  AS local,
        l.bairro,
        COALESCE(t.nome, 'Local considerado inseguro') AS tipo,
        r.descricao
FROM    relatos r
JOIN    locais l          ON l.id_local = r.id_local
LEFT JOIN tipos_crime t   ON t.id_tipo  = r.id_tipo
WHERE   r.status = 'APROVADO';          -- nunca expõe autor nem moderador

-- =====================================================================
-- DADOS DE REFERÊNCIA (necessários para o sistema funcionar)
-- =====================================================================

INSERT INTO tipos_crime (nome, descricao, artigo_cp, com_violencia) VALUES
('Furto de celular',  'Subtração do aparelho sem violência nem grave ameaça (descuido ou oportunidade).', 'Art. 155', 0),
('Roubo de celular',  'Subtração do aparelho mediante violência ou grave ameaça à pessoa.',               'Art. 157', 1);

-- Distritos policiais citados nas fontes da pesquisa (SSP-SP; Metrópoles).
-- A região é aproximada e serve apenas para agrupar o painel.
INSERT INTO distritos_policiais (numero, nome, regiao) VALUES
(3,   'Campos Elíseos',     'CENTRO'),
(4,   'Consolação',         'CENTRO'),
(5,   'Aclimação',          'CENTRO'),
(8,   'Brás',               'CENTRO'),
(11,  'Santo Amaro',        'ZONA SUL'),
(14,  'Pinheiros',          'ZONA OESTE'),
(15,  'Itaim Bibi',         'ZONA OESTE'),
(23,  'Perdizes',           'ZONA OESTE'),
(27,  'Campo Belo',         'ZONA SUL'),
(29,  'Vila Prudente',      'ZONA LESTE'),
(33,  'Pirituba',           'ZONA NORTE'),
(34,  'Morumbi',            'ZONA OESTE'),
(47,  'Capão Redondo',      'ZONA SUL'),
(58,  'Vila Formosa',       'ZONA LESTE'),
(78,  'Jardins',            'ZONA OESTE'),
(92,  'Parque Santo Antônio','ZONA SUL'),
(96,  'Monções/Brooklin',   'ZONA SUL'),
(98,  'Jardim Miriam',      'ZONA SUL'),
(102, 'Socorro',            'ZONA SUL');

-- Locais de exemplo (vinculação ao DP e coordenadas aproximadas, uso didático)
INSERT INTO locais (id_dp, nome, tipo_local, logradouro, bairro, latitude, longitude)
SELECT dp.id_dp, x.nome, x.tipo_local, x.logradouro, x.bairro, x.lat, x.lon
FROM (
    SELECT  3 AS dp, 'Estação da Luz'                 AS nome, 'ESTACAO_METRO_TREM' AS tipo_local, 'Praça da Luz'                    AS logradouro, 'Luz'            AS bairro, -23.536200 AS lat, -46.633500 AS lon
    UNION ALL SELECT 23, 'Estação Barra Funda',        'ESTACAO_METRO_TREM', 'Av. Rudge, 1000',                  'Barra Funda',    -23.526200, -46.667200
    UNION ALL SELECT  4, 'Estação Consolação (Metrô)', 'ESTACAO_METRO_TREM', 'Av. Paulista com R. da Consolação','Consolação',     -23.557800, -46.660300
    UNION ALL SELECT  4, 'Avenida Paulista (trecho Consolação)', 'VIA_PUBLICA', 'Av. Paulista',                  'Bela Vista',     -23.561400, -46.655900
    UNION ALL SELECT 14, 'Estação Pinheiros',          'ESTACAO_METRO_TREM', 'Av. Rebouças',                     'Pinheiros',      -23.566700, -46.691800
    UNION ALL SELECT 14, 'Largo da Batata',            'VIA_PUBLICA',        'Largo da Batata',                  'Pinheiros',      -23.567200, -46.696900
    UNION ALL SELECT 11, 'Terminal Santo Amaro',       'TERMINAL_ONIBUS',    'Praça Floriano Peixoto',           'Santo Amaro',    -23.653500, -46.709800
    UNION ALL SELECT  8, 'Estação Brás',               'ESTACAO_METRO_TREM', 'R. Domingos de Moraes, s/n',       'Brás',           -23.543900, -46.616200
    UNION ALL SELECT 78, 'Rua Oscar Freire',           'VIA_PUBLICA',        'R. Oscar Freire',                  'Jardins',        -23.562000, -46.669500
    UNION ALL SELECT 15, 'Av. Brigadeiro Faria Lima (Itaim)', 'VIA_PUBLICA', 'Av. Brig. Faria Lima',             'Itaim Bibi',     -23.585800, -46.683300
    UNION ALL SELECT 29, 'Estação Vila Prudente',      'ESTACAO_METRO_TREM', 'Av. Prof. Luiz Ignácio Anhaia Mello','Vila Prudente', -23.581800, -46.581800
    UNION ALL SELECT 47, 'Terminal Capão Redondo',     'TERMINAL_ONIBUS',    'Estrada de Itapecerica',           'Capão Redondo',  -23.660800, -46.771400
    UNION ALL SELECT 33, 'Terminal Pirituba',          'TERMINAL_ONIBUS',    'Av. Raimundo Pereira de Magalhães','Pirituba',       -23.484400, -46.727100
    UNION ALL SELECT 96, 'Av. Eng. Luís Carlos Berrini','VIA_PUBLICA',       'Av. Eng. Luís Carlos Berrini',     'Brooklin',       -23.612300, -46.698300
    UNION ALL SELECT 27, 'Av. Washington Luís (Campo Belo)', 'VIA_PUBLICA', 'Av. Washington Luís',               'Campo Belo',     -23.624700, -46.665300
) AS x
JOIN distritos_policiais dp ON dp.numero = x.dp;

-- Orientações de prevenção e pós-ocorrência.
-- Base: recomendações divulgadas pela SSP-SP e pelo aplicativo Celular Seguro (ver Parte 1, seção 5).
INSERT INTO orientacoes (titulo, conteudo, categoria, ordem, fonte) VALUES
('Bloqueie o aparelho imediatamente',
 'Peça à operadora o bloqueio da linha e do IMEI do aparelho, ou use o aplicativo Celular Seguro (governo federal) para bloquear o aparelho, a linha e o acesso a aplicativos bancários.',
 'POS_OCORRENCIA', 1, 'SSP-SP; Celular Seguro (Ministério da Justiça)'),
('Bloqueie cartões e aplicativos bancários',
 'Ligue para o banco, bloqueie cartões e troque as senhas de aplicativos financeiros, e-mail e redes sociais a partir de outro aparelho.',
 'POS_OCORRENCIA', 2, 'SSP-SP'),
('Avise familiares e amigos',
 'Informe contatos próximos que o número foi roubado ou furtado para evitar golpes feitos em seu nome.',
 'POS_OCORRENCIA', 3, 'SSP-SP'),
('Registre o boletim de ocorrência',
 'Registre o B.O. na Delegacia Eletrônica ou em um distrito policial. O B.O. é essencial para que o SP Mobile identifique e recupere o aparelho caso ele seja reativado.',
 'POS_OCORRENCIA', 4, 'SSP-SP'),
('Informe o IMEI no B.O.',
 'O IMEI está na caixa, na nota fiscal ou ao discar *#06#. Anote-o antes de qualquer ocorrência.',
 'POS_OCORRENCIA', 5, 'SSP-SP'),
('Cadastre-se no Celular Seguro antes de precisar',
 'Segundo o Ministério da Justiça, cerca de 80% das pessoas só se cadastram depois do crime. Cadastrar contatos de confiança antes agiliza o bloqueio.',
 'PREVENCAO', 1, 'Ministério da Justiça (via Olhar Digital, 24/12/2025)'),
('Atenção redobrada no fim da tarde e à noite',
 'Cerca de 4 em cada 10 roubos de celular no Brasil ocorrem entre 18h e 23h, com pico às 20h (Anuário Brasileiro de Segurança Pública 2026).',
 'PREVENCAO', 2, 'Fórum Brasileiro de Segurança Pública'),
('Cuidado em estações, terminais e vagões lotados',
 'No transporte público paulista, a maior parte dos casos é de furto (cerca de 89%), por descuido ou oportunidade. Mantenha o aparelho no bolso da frente ou na bolsa fechada.',
 'PREVENCAO', 3, 'Dado: SSP-SP (via BNews SP, 08/01/2026)'),
('Evite usar o celular na calçada, na porta de estações e ao descer do veículo',
 'Quem anda com o aparelho na mão é alvo fácil. Pare em local movimentado e iluminado ou entre em um estabelecimento para atender ou responder.',
 'PREVENCAO', 4, 'Boas práticas de segurança pessoal');

-- Vínculo N:N entre tipos de crime e orientações.
-- Nesta carga inicial todas as orientações valem para furto e roubo; o
-- administrador pode remover ou incluir vínculos depois.
INSERT INTO tipo_crime_orientacao (id_tipo, id_orientacao)
SELECT t.id_tipo, o.id_orientacao FROM tipos_crime t CROSS JOIN orientacoes o;

-- Usuários de demonstração (o hash é apenas ilustrativo: SHA-256 de 'demo123').
INSERT INTO usuarios (nome, email, senha_hash, perfil) VALUES
('Administrador Demo', 'admin@rotasegura.example',   SHA2('demo123', 256), 'ADMINISTRADOR'),
('Moderador Demo',     'moderador@rotasegura.example', SHA2('demo123', 256), 'MODERADOR'),
('Cidadão Demo',       'cidadao@rotasegura.example', SHA2('demo123', 256), 'CIDADAO');
