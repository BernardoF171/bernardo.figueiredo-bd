
CREATE DATABASE IF NOT EXISTS LojaVirtual;
USE LojaVirtual;

CREATE TABLE IF NOT EXISTS Cliente (
    ID_Cliente INT PRIMARY KEY,
    Nome VARCHAR(100),
    CPF VARCHAR(14),
    Data_Nascimento DATE,
    Email VARCHAR(100),
    Telefone VARCHAR(20),
    Data_Cadastro DATE,
    Preferencias_Notificacao BOOLEAN
);

CREATE TABLE IF NOT EXISTS Produto (
    ID_Produto INT PRIMARY KEY,
    Nome_Produto VARCHAR(100),
    Categoria VARCHAR(50),
    Tamanho VARCHAR(5),
    Cor VARCHAR(20),
    Preco DECIMAL(10,2),
    Estoque INT
);

CREATE TABLE IF NOT EXISTS Endereco (
    ID_Endereco INT PRIMARY KEY,
    ID_Cliente INT,
    Rua VARCHAR(100),
    Numero VARCHAR(10),
    Cidade VARCHAR(50),
    Estado VARCHAR(2),
    CEP VARCHAR(10),
    Complemento VARCHAR(50),
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
);

CREATE TABLE IF NOT EXISTS Pedido (
    ID_Pedido INT PRIMARY KEY,
    ID_Cliente INT,
    Data_Pedido DATE,
    Valor_Total DECIMAL(10,2),
    Status_Pedido VARCHAR(20),
    Forma_Pagamento VARCHAR(20),
    Numero_Parcelas INT,
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
);

CREATE TABLE IF NOT EXISTS Item_Pedido (
    ID_Item INT PRIMARY KEY,
    ID_Pedido INT,
    ID_Produto INT,
    Quantidade INT,
    Preco_Unitario DECIMAL(10,2),
    FOREIGN KEY (ID_Pedido) REFERENCES Pedido(ID_Pedido),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
);

CREATE TABLE IF NOT EXISTS Pagamento (
    ID_Pagamento INT PRIMARY KEY,
    ID_Pedido INT,
    Tipo_Pagamento VARCHAR(20),
    Status_Pagamento VARCHAR(20),
    Data_Pagamento DATE,
    FOREIGN KEY (ID_Pedido) REFERENCES Pedido(ID_Pedido)
);

CREATE TABLE IF NOT EXISTS Entrega (
    ID_Entrega INT PRIMARY KEY,
    ID_Pedido INT,
    Transportadora VARCHAR(50),
    Data_Envio DATE,
    Data_Entrega DATE,
    Status_Entrega VARCHAR(20),
    FOREIGN KEY (ID_Pedido) REFERENCES Pedido(ID_Pedido)
);

CREATE TABLE IF NOT EXISTS Troca_Devolucao (
    ID_Troca INT PRIMARY KEY,
    ID_Pedido INT,
    ID_Produto INT,
    Motivo VARCHAR(100),
    Data_Solicitacao DATE,
    Status VARCHAR(20),
    FOREIGN KEY (ID_Pedido) REFERENCES Pedido(ID_Pedido),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
);

CREATE TABLE IF NOT EXISTS Programa_Fidelidade (
    ID_Fidelidade INT PRIMARY KEY,
    ID_Cliente INT,
    Pontos_Acumulados INT,
    Pontos_Utilizados INT,
    Nivel_Cliente VARCHAR(20),
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
);

CREATE TABLE IF NOT EXISTS Atendimento (
    ID_Atendimento INT PRIMARY KEY,
    ID_Cliente INT,
    Data_Contato DATE,
    Canal VARCHAR(20),
    Assunto VARCHAR(100),
    Status VARCHAR(20),
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
);

CREATE TABLE IF NOT EXISTS Lista_Desejos (
    ID_Lista INT PRIMARY KEY,
    ID_Cliente INT,
    ID_Produto INT,
    Data_Adicao DATE,
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
);

CREATE TABLE IF NOT EXISTS Navegacao (
    ID_Navegacao INT PRIMARY KEY,
    ID_Cliente INT,
    ID_Produto INT,
    Data_Visualizacao DATE,
    Acao VARCHAR(30),
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
);


INSERT INTO Cliente VALUES (1, 'Ana Silva', '123.456.789-01', '1990-05-15', 'ana@email.com', '11999999999', '2026-01-01', 1),
                           (2, 'Bruno Souza', '234.567.890-12', '1985-08-20', 'bruno@email.com', '11988888888', '2026-01-05', 0),
                           (3, 'Carla Dias', '345.678.901-23', '1995-03-10', 'carla@email.com', '11977777777', '2026-02-10', 1),
                           (4, 'Daniel Lima', '456.789.012-34', '1988-12-05', 'daniel@email.com', '11966666666', '2026-02-15', 1),
                           (5, 'Elisa Reis', '567.890.123-45', '1992-07-22', 'elisa@email.com', '11955555555', '2026-03-01', 0);

INSERT INTO Produto VALUES (101, 'Camiseta Básica', 'Vestuário', 'M', 'Branca', 49.90, 100),
                           (102, 'Calça Jeans', 'Vestuário', '40', 'Azul', 159.90, 50),
                           (103, 'Tênis Running', 'Calçados', '38', 'Preto', 299.90, 30),
                           (104, 'Jaqueta Couro', 'Vestuário', 'G', 'Marrom', 450.00, 20),
                           (105, 'Meia Esportiva', 'Acessórios', 'Único', 'Cinza', 15.00, 200);

INSERT INTO Endereco VALUES (1, 1, 'Rua A', '10', 'São Paulo', 'SP', '01000-000', 'Casa'),
                            (2, 2, 'Rua B', '20', 'Rio de Janeiro', 'RJ', '20000-000', 'Apto 101'),
                            (3, 3, 'Rua C', '30', 'Curitiba', 'PR', '80000-000', 'Bloco B'),
                            (4, 4, 'Rua D', '40', 'Belo Horizonte', 'MG', '30000-000', 'Casa'),
                            (5, 5, 'Rua E', '50', 'Salvador', 'BA', '40000-000', 'Apto 202');

INSERT INTO Pedido VALUES (1001, 1, '2026-04-01', 49.90, 'Entregue', 'Pix', 1),
                          (1002, 2, '2026-04-02', 159.90, 'Processando', 'Cartão', 3),
                          (1003, 3, '2026-04-03', 299.90, 'Enviado', 'Cartão', 5),
                          (1004, 4, '2026-04-04', 450.00, 'Entregue', 'Boleto', 1),
                          (1005, 5, '2026-04-05', 30.00, 'Cancelado', 'Pix', 1);

INSERT INTO Item_Pedido VALUES (1, 1001, 101, 1, 49.90),
                               (2, 1002, 102, 1, 159.90),
                               (3, 1003, 103, 1, 299.90),
                               (4, 1004, 104, 1, 450.00),
                               (5, 1005, 105, 2, 15.00);

INSERT INTO Pagamento VALUES (1, 1001, 'Pix', 'Pago', '2026-04-01'),
                             (2, 1002, 'Cartão', 'Pendente', NULL),
                             (3, 1003, 'Cartão', 'Pago', '2026-04-03'),
                             (4, 1004, 'Boleto', 'Pago', '2026-04-04'),
                             (5, 1005, 'Pix', 'Cancelado', NULL);

INSERT INTO Entrega VALUES (1, 1001, 'Correios', '2026-04-01', '2026-04-05', 'Entregue'),
                           (2, 1002, 'Jadlog', '2026-04-02', NULL, 'Em transporte'),
                           (3, 1003, 'Correios', '2026-04-03', NULL, 'Em transporte'),
                           (4, 1004, 'Jadlog', '2026-04-04', '2026-04-07', 'Entregue'),
                           (5, 1005, 'Correios', NULL, NULL, 'Cancelado');

INSERT INTO Troca_Devolucao VALUES (1, 1005, 105, 'Produto com defeito', '2026-04-06', 'Aceito'),
                                   (2, 1001, 101, 'Tamanho errado', '2026-04-06', 'Pendente');

INSERT INTO Programa_Fidelidade VALUES (1, 1, 50, 0, 'Bronze'),
                                       (2, 2, 100, 50, 'Prata'),
                                       (3, 3, 200, 100, 'Ouro'),
                                       (4, 4, 300, 200, 'Ouro'),
                                       (5, 5, 10, 0, 'Bronze');

INSERT INTO Atendimento VALUES (1, 1, '2026-04-02', 'Chat', 'Dúvida sobre entrega', 'Resolvido'),
                               (2, 2, '2026-04-03', 'Email', 'Pagamento não confirmado', 'Em análise'),
                               (3, 3, '2026-04-04', 'Telefone', 'Troca de produto', 'Pendente'),
                               (4, 4, '2026-04-05', 'Chat', 'Elogio', 'Fechado'),
                               (5, 5, '2026-04-06', 'Chat', 'Cancelamento', 'Resolvido');

INSERT INTO Lista_Desejos VALUES (1, 1, 102, '2026-01-10'),
                                 (2, 2, 103, '2026-01-11'),
                                 (3, 3, 104, '2026-01-12'),
                                 (4, 4, 101, '2026-01-13'),
                                 (5, 5, 102, '2026-01-14');

INSERT INTO Navegacao VALUES (1, 1, 101, '2026-04-01', 'Visualizou'),
                             (2, 2, 102, '2026-04-02', 'Adicionou ao carrinho'),
                             (3, 3, 103, '2026-04-03', 'Visualizou'),
                             (4, 4, 104, '2026-04-04', 'Compra finalizada'),
                             (5, 5, 105, '2026-04-05', 'Visualizou');