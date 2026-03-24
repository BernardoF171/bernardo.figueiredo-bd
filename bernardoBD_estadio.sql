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
    primary key (id_ingresso)
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
    primary key (id_jogo)
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
    primary key (id_setor)
);

create table porta(
	id_portao int auto_increment,
    numero int not null,
    localizacao varchar (50) not null,
    id_setor int not null,
    primary key (id_portao)
);

create table lanchonete(
	id_lanchonete int auto_increment,
    nome varchar (100) not null,
    tipo varchar (50) not null,
    localizacao varchar (50) not null,
    id_estadio int not null,
    primary key (id_lanchonte)
);

create table estacionamento(
	id_estacionamento int auto_increment,
    capacidade_total int not null,
    vagas_disponiveis int not null,
    preco decimal (8,2) not null,
    id_estadio int not null,
    primary key (id_estacionamento)
);
    
    
    
    
    
    
    
    
    
    
    
    
    
insert into torcedor (cpf,nome,sexo,idade,endereço,email,telefone,data_cadastro) values
	('76584117105', 'jacinto leite','masculino','47', 'Rua Rego Barros, 69','jacintoleite@gmail.com','11978053741','2021-27-11 18:30:00'),
    ('48291756320', 'marcos silva','masculino','35', 'Av. Paulista, 1020','marcossilva@gmail.com','11987654321','2022-15-03 09:45:00'),
	('91327564018', 'ana souza','feminino','29', 'Rua das Flores, 88','anasouza@gmail.com','11976543210','2023-08-07 14:20:00'),
	('27461930587', 'carlos pereira','masculino','52', 'Rua Bela Vista, 210','carlosp@gmail.com','11965432109','2021-03-12 11:10:00'),
	('65820317495', 'juliana costa','feminino','41', 'Av. Brasil, 455','julianacosta@gmail.com','11954321098','2020-22-09 16:55:00');


