DROP DATABASE IF EXISTS concessionaria;
CREATE DATABASE IF NOT EXISTS concessionaria;
USE concessionaria;


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
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo)
        ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE manutencao (
    id_manutencao INT PRIMARY KEY AUTO_INCREMENT,
    id_veiculo INT NOT NULL,
    id_cliente INT NOT NULL,
    id_contrato INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    tipo_manutencao VARCHAR(30),
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato)
        ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE multa (
    id_multa INT PRIMARY KEY AUTO_INCREMENT,
    desc_multa VARCHAR(50),
    id_veiculo INT NOT NULL,
    id_contrato INT NOT NULL,
    valor_multa DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato)
        ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE reserva (
    id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    data_res DATE NOT NULL,
    id_veiculo INT NOT NULL,
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
        ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE pagamento (
    id_pag INT PRIMARY KEY AUTO_INCREMENT,
    estado VARCHAR(20),
    valor DECIMAL(10,2) NOT NULL,
    id_cliente INT NOT NULL,
    id_contrato INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato)
        ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE devolucao (
    id_devolucao INT PRIMARY KEY AUTO_INCREMENT,
    km_final DECIMAL(10,2) NOT NULL,
    danos_ident VARCHAR(50),
    valor_adic DECIMAL(10,2),
    id_cliente INT NOT NULL,
    id_contrato INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato)
        ON DELETE CASCADE ON UPDATE CASCADE
);



INSERT INTO cliente (nome, cpf, email, endereco, data_nascimento) VALUES 
('Fernanda Alves','123456789-00','fernanda.alves@gmail.com','Rua Azul-120','1999-03-11'),
('João Pedro','987654321-55','joaopedro@gmail.com','Av. Central-890','1975-07-07'),
('Amanda Ribeiro','741852963-22','amanda.ribeiro@gmail.com','Rua Verde-45','2001-09-01'),
('Bruno Martins','369258147-11','bruno.m@gmail.com','Travessa Norte-77','1985-02-05'),
('Patricia Lima','159753486-99','patricia.lima@gmail.com','Av. Sul-300','2004-06-21');

INSERT INTO empresa (nome,endereco,email,telefone) VALUES
('AutoFast Locadora','Av. Brasil, 2000','contato@autofast.com','(11)9999-1111'),
('DriveNow','Rua Augusta, 500','suporte@drivenow.com','(21)8888-2222'),
('SpeedCar','Av. Industrial, 300','vendas@speedcar.com','(31)7777-3333'),
('Premium Wheels','Alameda Santos, 150','contato@premium.com','(11)6666-4444'),
('Green Mobility','Rua Verde, 50','eco@greenmob.com','(41)5555-5555');

INSERT INTO veiculo (id_empresa, valor, quilometragem) VALUES
(1,60000.00,20000.00),
(2,80000.00,10000.00),
(3,120000.00,30000.00),
(4,200000.00,5000.00),
(5,90000.00,15000.00);

INSERT INTO contrato (id_cliente, id_veiculo, data_devolucao, valor, quilometragem_inicial) VALUES 
(1,2,'2024-07-10',1500.00,10000.00),
(2,1,'2024-07-15',1100.00,20000.00),
(3,3,'2024-07-20',2500.00,30000.00),
(4,5,'2024-07-25',1800.00,15000.00),
(5,4,'2024-07-30',3200.00,5000.00);

INSERT INTO manutencao (id_veiculo, id_cliente, id_contrato, valor, tipo_manutencao) VALUES
(2,1,1,200.00,'Revisão Geral'),
(1,2,2,180.00,'Troca de Óleo'),
(3,3,3,600.00,'Freios');

INSERT INTO multa (desc_multa, id_veiculo, id_contrato, valor_multa) VALUES
('Uso de Celular',2,1,195.23),
('Excesso de Velocidade',1,2,293.47),
('Direção Perigosa',3,3,880.41);

INSERT INTO reserva (data_res, id_veiculo, id_cliente) VALUES
('2024-09-01',3,1),
('2024-09-05',2,2),
('2024-09-10',5,4);

INSERT INTO pagamento (estado, valor, id_cliente, id_contrato) VALUES
('Pago',1500.00,1,1),
('Pendente',1100.00,2,2),
('Pago',2500.00,3,3),
('Cancelado',1800.00,4,4),
('Pago',3200.00,5,5);

INSERT INTO devolucao (km_final, danos_ident, valor_adic, id_cliente, id_contrato) VALUES
(10200.00,'Nenhum',0.00,1,1),
(20500.00,'Risco leve',120.00,2,2),
(30500.00,'Nenhum',0.00,3,3),
(15200.00,'Sujeira interna',60.00,4,4),
(5500.00,'Nenhum',0.00,5,5);