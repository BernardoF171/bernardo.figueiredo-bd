DROP DATABASE IF EXISTS concessionaria;
CREATE DATABASE concessionaria;
USE concessionaria;

-- ================= TABELAS =================

CREATE TABLE empresa (
    id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(40) NOT NULL,
    endereco VARCHAR(40),
    email VARCHAR(50),
    telefone VARCHAR(20)
);

CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    nome VARCHAR(40) NOT NULL,
    email VARCHAR(50),
    endereco VARCHAR(40),
    data_nascimento DATE NOT NULL
);

CREATE TABLE veiculo (
    id_veiculo INT PRIMARY KEY AUTO_INCREMENT,
    id_empresa INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    quilometragem DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE contrato (
    id_contrato INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_veiculo INT NOT NULL,
    data_devolucao DATE,
    valor DECIMAL(10,2) NOT NULL,
    quilometragem_inicial DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo)
);

CREATE TABLE manutencao (
    id_manutencao INT PRIMARY KEY AUTO_INCREMENT,
    id_veiculo INT NOT NULL,
    id_cliente INT NOT NULL,
    id_contrato INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    tipo_manutencao VARCHAR(30),
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato)
);

CREATE TABLE multa (
    id_multa INT PRIMARY KEY AUTO_INCREMENT,
    desc_multa VARCHAR(50),
    id_veiculo INT NOT NULL,
    id_contrato INT NOT NULL,
    valor_multa DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),
    FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato)
);

CREATE TABLE reserva (
    id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    data_res DATE NOT NULL,
    id_veiculo INT NOT NULL,
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE pagamento (
    id_pag INT PRIMARY KEY AUTO_INCREMENT,
    estado VARCHAR(20),
    valor DECIMAL(10,2) NOT NULL,
    id_cliente INT NOT NULL,
    id_contrato INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato)
);

CREATE TABLE devolucao (
    id_devolucao INT PRIMARY KEY AUTO_INCREMENT,
    km_final DECIMAL(10,2) NOT NULL,
    danos_ident VARCHAR(50),
    valor_adic DECIMAL(10,2),
    id_cliente INT NOT NULL,
    id_contrato INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato)
);

-- ================= CONSULTAS =================

-- Veículos com mais de 15.000 km
SELECT COUNT(*) 
FROM veiculo
WHERE quilometragem > 15000;

-- Média de valor por empresa
SELECT id_empresa, AVG(valor) AS media_valor
FROM veiculo
GROUP BY id_empresa;

-- Clientes com contratos acima de 2000
SELECT c.nome, ct.valor
FROM cliente c
JOIN contrato ct ON c.id_cliente = ct.id_cliente
WHERE ct.valor > 2000;

-- Contratos com devolução após 20/07/2024
SELECT COUNT(*)
FROM contrato
WHERE data_devolucao > '2024-07-20';

-- Cliente com mais contratos
SELECT c.nome, COUNT(*) AS total_contratos
FROM cliente c
JOIN contrato ct ON c.id_cliente = ct.id_cliente
GROUP BY c.nome
ORDER BY total_contratos DESC
LIMIT 1;

-- Veículos com mais de uma manutenção
SELECT id_veiculo
FROM manutencao
GROUP BY id_veiculo
HAVING COUNT(*) > 1;

-- Total gasto em manutenção por veículo
SELECT id_veiculo, SUM(valor) AS total
FROM manutencao
GROUP BY id_veiculo;

-- Clientes com pagamento pendente
SELECT DISTINCT c.nome
FROM cliente c
JOIN pagamento p ON c.id_cliente = p.id_cliente
WHERE p.estado = 'Pendente';

-- Cliente com maior valor em multas
SELECT c.nome, SUM(m.valor_multa) AS total
FROM cliente c
JOIN contrato ct ON c.id_cliente = ct.id_cliente
JOIN multa m ON ct.id_contrato = m.id_contrato
GROUP BY c.nome
ORDER BY total DESC
LIMIT 1;

-- Veículos por empresa
SELECT id_empresa, COUNT(*) AS total
FROM veiculo
GROUP BY id_empresa;

-- Empresa com veículo mais caro
SELECT e.nome, v.valor
FROM empresa e
JOIN veiculo v ON e.id_empresa = v.id_empresa
ORDER BY v.valor DESC
LIMIT 1;

-- Clientes com reserva mas sem contrato
SELECT c.nome
FROM cliente c
JOIN reserva r ON c.id_cliente = r.id_cliente
LEFT JOIN contrato ct ON c.id_cliente = ct.id_cliente
WHERE ct.id_contrato IS NULL;

-- Total recebido (pagos)
SELECT SUM(valor) AS total_recebido
FROM pagamento
WHERE estado = 'Pago';

-- Devoluções com valor adicional > 50
SELECT *
FROM devolucao
WHERE valor_adic > 50;

-- KM percorrido
SELECT c.nome,
       d.km_final - ct.quilometragem_inicial AS km_percorrido
FROM cliente c
JOIN contrato ct ON c.id_cliente = ct.id_cliente
JOIN devolucao d ON ct.id_contrato = d.id_contrato;

-- Contratos com veículos acima de 20.000 km
SELECT ct.*
FROM contrato ct
JOIN veiculo v ON ct.id_veiculo = v.id_veiculo
WHERE v.quilometragem > 20000;

-- Cliente mais jovem com contrato
SELECT c.nome, c.data_nascimento
FROM cliente c
JOIN contrato ct ON c.id_cliente = ct.id_cliente
ORDER BY c.data_nascimento DESC
LIMIT 1;

-- Veículos com contrato, multa e manutenção
SELECT DISTINCT v.id_veiculo
FROM veiculo v
JOIN contrato ct ON v.id_veiculo = ct.id_veiculo
JOIN multa m ON ct.id_contrato = m.id_contrato
JOIN manutencao mn ON v.id_veiculo = mn.id_veiculo;