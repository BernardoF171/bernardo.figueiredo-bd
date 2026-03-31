drop database if exists concessionaria;
CREATE DATABASE IF NOT EXISTS concessionaria;
USE concessionaria;


CREATE TABLE Empresa (
    id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(40) NOT NULL,
    endereco VARCHAR(40),
    email VARCHAR(50),
    telefone VARCHAR(20)
);


CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    cpf VARCHAR(14) NOT NULL UNIQUE, 
    nome VARCHAR(40) NOT NULL,
    email VARCHAR(50),
    endereco VARCHAR(40),
    idade INT 
);


CREATE TABLE Veiculos (
    id_veiculo INT PRIMARY KEY AUTO_INCREMENT,
    id_empresa INT,
    valor DECIMAL(10, 2),
    quilometragem DECIMAL(10, 2),
    CONSTRAINT fk_veiculo_empresa FOREIGN KEY (id_empresa) REFERENCES Empresa(id_empresa)
);


CREATE TABLE Contrato (
    id_contrato INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    id_veiculo INT,
    data_devolucao DATE, 
    valor DECIMAL(10, 2),
    quilometragem_inicial DECIMAL(10, 2),
    CONSTRAINT fk_contrato_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_contrato_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id_veiculo)
);


CREATE TABLE Manutencao (
    id_manutencao INT PRIMARY KEY AUTO_INCREMENT,
    id_veiculo INT,
    id_cliente INT,
    id_contrato INT,
    valor DECIMAL(10, 2),
    tipo_manutencao VARCHAR(20),
    CONSTRAINT fk_manutencao_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id_veiculo),
    CONSTRAINT fk_manutencao_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_manutencao_contrato FOREIGN KEY (id_contrato) REFERENCES Contrato(id_contrato)
);


CREATE TABLE multa (
    id_multa INT PRIMARY KEY AUTO_INCREMENT,
    desc_multa VARCHAR(50),
    id_veiculo INT,
    id_contrato INT,
    valor_multa DECIMAL(10,2),
    CONSTRAINT fk_multa_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id_veiculo),
    CONSTRAINT fk_multa_contrato FOREIGN KEY (id_contrato) REFERENCES Contrato(id_contrato)
);


CREATE TABLE reserva (
    id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    data_res DATE,
    id_veiculo INT,
    id_cliente INT,
    CONSTRAINT fk_reserva_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id_veiculo),
    CONSTRAINT fk_reserva_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);


CREATE TABLE pagamento (
    id_pag INT PRIMARY KEY AUTO_INCREMENT,
    estado VARCHAR(20),
    valor DECIMAL(10,2),
    id_cliente INT,
    CONSTRAINT fk_pagamento_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);


CREATE TABLE devolucao (
    id_devolucao INT PRIMARY KEY AUTO_INCREMENT,
    km_final VARCHAR(20),
    danos_ident VARCHAR(50),
    valor_adic DECIMAL(10,2),
    id_cliente INT,
    CONSTRAINT fk_devolucao_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);



INSERT INTO Cliente (nome, cpf, email , endereco, idade) VALUES 
('Fernanda Alves' , '123456789-00' , 'fernanda.alves@gmail.com' , 'Rua Azul-120',29),
('João Pedro' , '987654321-55' , 'joaopedro@gmail.com' , 'Av. Central-890',31),
('Amanda Ribeiro', '741852963-22' , 'amanda.ribeiro@gmail.com' , 'Rua Verde-45',26),
('Bruno Martins' , '369258147-11' , 'bruno.m@gmail.com' , 'Travessa Norte-77',38),
('Patricia Lima', '159753486-99' , 'patricia.lima@gmail.com','Av. Sul-300',44);

INSERT INTO Empresa (nome,endereco,email,telefone) VALUES
('AutoFast Locadora', 'Av. Brasil, 2000', 'contato@autofast.com', '(11) 9999-1111'),
('DriveNow', 'Rua Augusta, 500', 'suporte@drivenow.com', '(21) 8888-2222'),
('SpeedCar', 'Av. Industrial, 300', 'vendas@speedcar.com', '(31) 7777-3333'),
('Premium Wheels', 'Alameda Santos, 150', 'contato@premium.com', '(11) 6666-4444'),
('Green Mobility', 'Rua Verde, 50', 'eco@greenmob.com', '(41) 5555-5555');

INSERT INTO Veiculos (id_empresa, valor, quilometragem) VALUES
(1, 60000.00, 20000.00),
(2, 80000.00, 10000.00),
(3, 120000.00, 30000.00),
(4, 200000.00, 5000.00),
(5, 90000.00, 15000.00);

INSERT INTO Contrato (id_cliente, id_veiculo, data_devolucao, valor, quilometragem_inicial) VALUES 
(1, 2, '2024-07-10', 1500.00, 10000.00),
(2, 1, '2024-07-15', 1100.00, 20000.00),
(3, 3, '2024-07-20', 2500.00, 30000.00),
(4, 5, '2024-07-25', 1800.00, 15000.00),
(5, 4, '2024-07-30', 3200.00, 5000.00);

INSERT INTO Manutencao (id_veiculo, id_cliente, id_contrato, valor, tipo_manutencao) VALUES
(2, 1, 1, 200.00, 'Revisão Geral'),
(1, 2, 2, 180.00, 'Troca de Óleo'),
(3, 3, 3, 600.00, 'Freios');

INSERT INTO multa (desc_multa, id_veiculo, id_contrato, valor_multa) VALUES
('Uso de Celular', 2, 1, 195.23),
('Excesso de Velocidade', 1, 2, 293.47),
('Direção Perigosa', 3, 3, 880.41);

INSERT INTO reserva (data_res, id_veiculo, id_cliente) VALUES
('2024-09-01', 3, 1),
('2024-09-05', 2, 2),
('2024-09-10', 5, 4);

INSERT INTO pagamento (estado, valor, id_cliente) VALUES
('Pago', 1500.00, 1),
('Pendente', 1100.00, 2),
('Pago', 2500.00, 3),
('Cancelado', 1800.00, 4),
('Pago', 3200.00, 5);

INSERT INTO devolucao (km_final, danos_ident, valor_adic, id_cliente) VALUES
('10200.00', 'Nenhum', 0.00, 1),
('20500.00', 'Risco leve', 120.00, 2),
('30500.00', 'Nenhum', 0.00, 3),
('15200.00', 'Sujeira interna', 60.00, 4),
('5500.00', 'Nenhum', 0.00, 5);