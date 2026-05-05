-- Criando o banco de dados
CREATE DATABASE IF NOT EXISTS EstiloUrbano;
USE EstiloUrbano;

-- 1. TABELA CLIENTE
CREATE TABLE Cliente (
    ID_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    CPF CHAR(11) UNIQUE NOT NULL,
    Data_Nascimento DATE,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefone VARCHAR(20),
    Data_Cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    Preferencias_Notificacao BOOLEAN DEFAULT TRUE
);

-- 2. TABELA ENDEREÇO (1 cliente pode ter vários endereços, mas a Mariana usa um)
CREATE TABLE Endereco (
    ID_Endereco INT AUTO_INCREMENT PRIMARY KEY,
    ID_Cliente INT,
    Rua VARCHAR(150) NOT NULL,
    Numero VARCHAR(10),
    Cidade VARCHAR(50) DEFAULT 'São Paulo',
    Estado CHAR(2) DEFAULT 'SP',
    CEP CHAR(8),
    Complemento VARCHAR(50),
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
);

-- 3. TABELA PRODUTO
CREATE TABLE Produto (
    ID_Produto INT AUTO_INCREMENT PRIMARY KEY,
    SKU VARCHAR(50) UNIQUE NOT NULL, -- Código único de estoque
    Nome_Produto VARCHAR(100) NOT NULL,
    Categoria VARCHAR(50), -- Ex: Social, Casual, Acessórios
    Tamanho VARCHAR(5),    -- Ex: P, M, G
    Cor VARCHAR(30),
    Preco DECIMAL(10, 2) NOT NULL,
    Estoque INT DEFAULT 0
);

-- 4. TABELA PEDIDO
CREATE TABLE Pedido (
    ID_Pedido INT AUTO_INCREMENT PRIMARY KEY,
    ID_Cliente INT,
    ID_Endereco_Entrega INT,
    Data_Pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    Valor_Total DECIMAL(10, 2) NOT NULL,
    Status_Pedido ENUM('Pendente', 'Pago', 'Enviado', 'Entregue', 'Cancelado'),
    Forma_Pagamento VARCHAR(50),
    Numero_Parcelas INT DEFAULT 1,
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),
    FOREIGN KEY (ID_Endereco_Entrega) REFERENCES Endereco(ID_Endereco)
);

-- 5. TABELA ITEM_PEDIDO (Tabela de ligação N para N)
CREATE TABLE Item_Pedido (
    ID_Item INT AUTO_INCREMENT PRIMARY KEY,
    ID_Pedido INT,
    ID_Produto INT,
    Quantidade INT NOT NULL,
    Preco_Unitario_Historico DECIMAL(10, 2) NOT NULL, -- Preço no dia da compra
    FOREIGN KEY (ID_Pedido) REFERENCES Pedido(ID_Pedido),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
);

-- 6. TABELA PROGRAMA_FIDELIDADE
CREATE TABLE Programa_Fidelidade (
    ID_Fidelidade INT AUTO_INCREMENT PRIMARY KEY,
    ID_Cliente INT,
    Pontos_Acumulados INT DEFAULT 0,
    Pontos_Utilizados INT DEFAULT 0,
    Nivel_Cliente VARCHAR(20), -- Ex: Bronze, Prata, Ouro
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
);

-- 7. TABELA TROCA_DEVOLUCAO (Para o caso da saia em Jan/2026)
CREATE TABLE Troca_Devolucao (
    ID_Troca INT AUTO_INCREMENT PRIMARY KEY,
    ID_Pedido INT,
    ID_Produto INT,
    Motivo TEXT,
    Codigo_Postagem VARCHAR(20),
    Data_Solicitacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status_Troca ENUM('Solicitada', 'Em Analise', 'Concluida', 'Recusada'),
    FOREIGN KEY (ID_Pedido) REFERENCES Pedido(ID_Pedido),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
);

-- 8. TABELA NAVEGACAO (Big Data/Comportamento)
CREATE TABLE Navegacao (
    ID_Navegacao INT AUTO_INCREMENT PRIMARY KEY,
    ID_Cliente INT,
    ID_Produto INT,
    Data_Visualizacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    Acao VARCHAR(50), -- Ex: 'Visualizou', 'Adicionou ao Carrinho'
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
);