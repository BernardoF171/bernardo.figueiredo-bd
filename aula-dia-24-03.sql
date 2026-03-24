Create database estadio;

create table torcedor(
	id_torcedor int auto_increment,
    cpf varchar(11) not null,
    nome varchar (255),
    sexo varchar (20),
    idade varchar (3),
    endereço varchar (255),
    email varchar (255),
    telefone varchar(12),
	data_cadastro datetime,
    primary key (id_torcedor)
);

create table estadio(
	id_estadio int (8) auto_increment,
    nome_estadio varchar (100),
    cidade_estadio varchar (50),
    estado varchar (2) not null,
    capacidade int not null,
    data_inauguraçao date,
    tipo_gramado varchar (20) not null,
    status_estadio varchar (20) not null,
    primary key (id_estadio)
    );
    
create table ingresso (
	id_ingresso int auto_increment,
    id_jogo int (10) not null,
    setor varchar (50) not null,
    preco decimal (8,2) not null,
    status_ingresso varchar (20) not null,
    data_compra datetime not null,
    primary key (id_ingresso),
    ALTER TABLE ingresso
  ADD CONSTRAINT fk_ingresso_jogo
  FOREIGN KEY (id_jogo) REFERENCES jogo(id_jogo)
);
    
create table jogo(
	id_jogo int auto_increment,
    time_casa int not null,
    time_visitante int not null,
    data_hora datetime not null,
    id_estadio int not null,
    placar_casa int,
    placar_visitante int,
    status_jogo varchar(20) not null,
    primary key (id_jogo),
    ALTER TABLE jogo
  ADD CONSTRAINT fk_jogo_estadio
  FOREIGN KEY (id_estadio) REFERENCES estadio(id_estadio),
  ALTER TABLE jogo
  ADD CONSTRAINT fk_jogo_time_casa
  FOREIGN KEY (time_casa) REFERENCES times(id_times),
  ALTER TABLE jogo
  ADD CONSTRAINT fk_jogo_time_visitante
  FOREIGN KEY (time_visitante) REFERENCES times(id_times)
);

create table times (
	id_times int auto_increment,
    nome varchar (100) not null,
    cidade varchar (50) not null,
    estado varchar (2) not null,
    data_fundacao date,
    tecnico varchar (100) not null,
    primary key (id_times)
);

create table setor(
	id_setor int auto_increment,
    nome varchar (50) not null,
    capacidade int not null,
    preco_base decimal (8,2) not null,
    id_estadio int not null,
    primary key (id_setor),
    ALTER TABLE setor
  ADD CONSTRAINT fk_setor_estadio
  FOREIGN KEY (id_estadio) REFERENCES estadio(id_estadio)

);

create table porta(
	id_portao int auto_increment,
    numero int not null,
    localizacao varchar (50) not null,
    id_setor int not null,
    primary key (id_portao),
    ALTER TABLE portao
  ADD CONSTRAINT fk_portao_setor
  FOREIGN KEY (id_setor) REFERENCES setor(id_setor)

);

create table lanchonete(
	id_lanchonete int auto_increment,
    nome varchar (100) not null,
    tipo varchar (50) not null,
    localizacao varchar (50) not null,
    id_estadio int not null,
    primary key (id_lanchonte),
    ALTER TABLE lanchonete
  ADD CONSTRAINT fk_lanchonete_estadio
  FOREIGN KEY (id_estadio) REFERENCES estadio(id_estadio)
);

create table estacionamento(
	id_estacionamento int auto_increment,
    capacidade_total int not null,
    vagas_disponiveis int not null,
    preco decimal (8,2) not null,
    id_estadio int not null,
    primary key (id_estacionamento),
    ALTER TABLE estacionamento
  ADD CONSTRAINT fk_estacionamento_estadio
  FOREIGN KEY (id_estadio) REFERENCES estadio(id_estadio)
);
    
    
    
    
    
    
    
    
    
    
    
    
    
insert into torcedor (cpf,nome,sexo,idade,endereço,email,telefone,data_cadastro) values
	('76584117105', 'jacinto leite','masculino','47', 'Rua Rego Barros, 69','jacintoleite@gmail.com','11978053741','2021-27-11 18:30:00'),
    ('48291756320', 'marcos silva','masculino','35', 'Av. Paulista, 1020','marcossilva@gmail.com','11987654321','2022-15-03 09:45:00'),
	('91327564018', 'ana souza','feminino','29', 'Rua das Flores, 88','anasouza@gmail.com','11976543210','2023-08-07 14:20:00'),
	('27461930587', 'carlos pereira','masculino','52', 'Rua Bela Vista, 210','carlosp@gmail.com','11965432109','2021-03-12 11:10:00'),
	('65820317495', 'juliana costa','feminino','41', 'Av. Brasil, 455','julianacosta@gmail.com','11954321098','2020-22-09 16:55:00');
	
	INSERT INTO estadio (nome_estadio, cidade_estadio, estado, capacidade, data_inauguraçao, tipo_gramado, status_estadio)
VALUES 
('Maracanã', 'Rio de Janeiro', 'RJ', 78838, '1950-06-16', 'Natural', 'Ativo'),
('Morumbi', 'São Paulo', 'SP', 66795, '1960-10-02', 'Natural', 'Ativo'),
('Mineirão', 'Belo Horizonte', 'MG', 61927, '1965-09-05', 'Natural', 'Ativo'),
('Arena Fonte Nova', 'Salvador', 'BA', 47907, '2013-04-07', 'Híbrido', 'Ativo'),
('Beira-Rio', 'Porto Alegre', 'RS', 50842, '1969-04-06', 'Natural', 'Ativo');

INSERT INTO times (nome, cidade, estado, data_fundacao, tecnico)
VALUES
('Flamengo', 'Rio de Janeiro', 'RJ', '1895-11-15', 'Tite'),
('São Paulo FC', 'São Paulo', 'SP', '1930-01-25', 'Thiago Carpini'),
('Atlético Mineiro', 'Belo Horizonte', 'MG', '1908-03-25', 'Felipão'),
('Bahia', 'Salvador', 'BA', '1931-01-01', 'Rogério Ceni'),
('Internacional', 'Porto Alegre', 'RS', '1909-04-04', 'Eduardo Coudet');

INSERT INTO jogo (time_casa, time_visitante, data_hora, id_estadio, placar_casa, placar_visitante, status_jogo)
VALUES
(1, 2, '2026-04-10 16:00:00', 1, 2, 1, 'Finalizado'),
(2, 3, '2026-04-15 18:30:00', 2, 1, 1, 'Finalizado'),
(3, 4, '2026-05-01 20:00:00', 3, NULL, NULL, 'Agendado'),
(4, 5, '2026-05-10 17:00:00', 4, NULL, NULL, 'Agendado'),
(5, 1, '2026-05-20 19:00:00', 5, NULL, NULL, 'Agendado');

INSERT INTO ingresso (id_jogo, setor, preco, status_ingresso, data_compra)
VALUES
(1, 'Arquibancada', 120.00, 'Vendido', '2026-03-20 14:30:00'),
(1, 'Camarote', 350.00, 'Disponível', '2026-03-21 10:00:00'),
(2, 'Arquibancada', 100.00, 'Vendido', '2026-03-22 11:00:00'),
(3, 'Cadeira', 150.00, 'Reservado', '2026-03-23 15:00:00'),
(4, 'VIP', 400.00, 'Disponível', '2026-03-24 09:00:00');

INSERT INTO setor (nome, capacidade, preco_base, id_estadio)
VALUES
('Arquibancada Norte', 20000, 100.00, 1),
('Arquibancada Sul', 18000, 90.00, 2),
('Cadeira Central', 15000, 150.00, 3),
('Camarote VIP', 5000, 300.00, 4),
('Arquibancada Leste', 12000, 110.00, 5);

INSERT INTO portao (numero, localizacao, id_setor)
VALUES
(1, 'Entrada Norte', 1),
(2, 'Entrada Sul', 2),
(3, 'Entrada Central', 3),
(4, 'Entrada VIP', 4),
(5, 'Entrada Leste', 5);

INSERT INTO lanchonete (nome, tipo, localizacao, id_estadio)
VALUES
('Lanche Bom', 'Fast Food', 'Setor Norte', 1),
('Snack SP', 'Lanches', 'Setor Sul', 2),
('Mineiro Grill', 'Churrasco', 'Área Central', 3),
('Bahia Food', 'Regional', 'Entrada Principal', 4),
('Sul Lanches', 'Fast Food', 'Arquibancada', 5);

INSERT INTO estacionamento (capacidade_total, vagas_disponiveis, preco, id_estadio)
VALUES
(1000, 250, 30.00, 1),
(800, 100, 40.00, 2),
(900, 300, 25.00, 3),
(700, 150, 35.00, 4),
(850, 200, 28.00, 5);


