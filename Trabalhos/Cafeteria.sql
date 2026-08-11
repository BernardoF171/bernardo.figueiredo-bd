-- Criação do Banco de Dados
-- CREATE DATABASE cafeteria_db;
-- \c cafeteria_db;

-- 1. Criação das Tabelas
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    data_cadastro DATE DEFAULT CURRENT_DATE
);

CREATE TABLE produtos (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    estoque INT NOT NULL DEFAULT 0
);

CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'Aberto', -- Aberto, Concluído, Cancelado
    id_cliente INT REFERENCES clientes(id_cliente)
);

CREATE TABLE itens_pedido (
    id_pedido INT REFERENCES pedidos(id_pedido),
    id_produto INT REFERENCES produtos(id_produto),
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto)
);

CREATE TABLE pagamentos (
    id_pagamento SERIAL PRIMARY KEY,
    id_pedido INT UNIQUE REFERENCES pedidos(id_pedido),
    forma_pagamento VARCHAR(50) NOT NULL, -- PIX, Cartão de Crédito, Dinheiro
    valor_total DECIMAL(10, 2) NOT NULL,
    data_pagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Criação de ÍNDICES (Otimização)
CREATE INDEX idx_pedidos_data ON pedidos(data_pedido);
CREATE INDEX idx_produtos_categoria ON produtos(categoria);

-- 3. Criação de VIEW (Painel de Gestão)
CREATE VIEW vw_resumo_vendas_diarias AS
SELECT 
    DATE(p.data_pedido) AS data_venda,
    COUNT(DISTINCT p.id_pedido) AS total_pedidos,
    SUM(pg.valor_total) AS faturamento_diario,
    COUNT(ip.id_produto) AS total_itens_vendidos
FROM pedidos p
LEFT JOIN pagamentos pg ON p.id_pedido = pg.id_pedido
LEFT JOIN itens_pedido ip ON p.id_pedido = ip.id_pedido
WHERE p.status = 'Concluído'
GROUP BY DATE(p.data_pedido);

-- 4. Criação de FUNCTION (Calcular total do pedido)
CREATE OR REPLACE FUNCTION fn_calcular_total_pedido(p_id_pedido INT)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_total DECIMAL(10,2);
BEGIN
    SELECT COALESCE(SUM(quantidade * preco_unitario), 0)
    INTO v_total
    FROM itens_pedido
    WHERE id_pedido = p_id_pedido;
    
    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

-- 5. Criação de TRIGGER (Baixa automática de estoque)
CREATE OR REPLACE FUNCTION fn_atualizar_estoque()
RETURNS TRIGGER AS $$
BEGIN
    -- Reduz o estoque do produto baseado na quantidade inserida no item do pedido
    UPDATE produtos
    SET estoque = estoque - NEW.quantidade
    WHERE id_produto = NEW.id_produto;
    
    -- Impede a venda se o estoque ficar negativo (Regra extra de segurança)
    IF (SELECT estoque FROM produtos WHERE id_produto = NEW.id_produto) < 0 THEN
        RAISE EXCEPTION 'Estoque insuficiente para o produto %', NEW.id_produto;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualizar_estoque
AFTER INSERT ON itens_pedido
FOR EACH ROW
EXECUTE FUNCTION fn_atualizar_estoque();

-- Inserindo 20 Clientes
INSERT INTO clientes (nome, email, telefone, data_cadastro) VALUES
('Ana Silva', 'ana.silva@email.com', '11987654321', '2023-01-10'),
('Carlos Souza', 'carlos.souza@email.com', '11987654322', '2023-01-12'),
('Beatriz Costa', 'beatriz.costa@email.com', '11987654323', '2023-02-15'),
('Daniel Oliveira', 'daniel.oliveira@email.com', '11987654324', '2023-02-20'),
('Eduarda Lima', 'eduarda.lima@email.com', '11987654325', '2023-03-05'),
('Felipe Santos', 'felipe.santos@email.com', '11987654326', '2023-03-10'),
('Gabriela Mendes', 'gabriela.mendes@email.com', '11987654327', '2023-04-01'),
('Henrique Alves', 'henrique.alves@email.com', '11987654328', '2023-04-12'),
('Isabela Rocha', 'isabela.rocha@email.com', '11987654329', '2023-05-08'),
('João Pereira', 'joao.pereira@email.com', '11987654330', '2023-05-22'),
('Karina Martins', 'karina.martins@email.com', '11987654331', '2023-06-14'),
('Lucas Fernandes', 'lucas.fernandes@email.com', '11987654332', '2023-06-30'),
('Mariana Ribeiro', 'mariana.ribeiro@email.com', '11987654333', '2023-07-11'),
('Nicolas Gomes', 'nicolas.gomes@email.com', '11987654334', '2023-07-25'),
('Olivia Pinto', 'olivia.pinto@email.com', '11987654335', '2023-08-04'),
('Pedro Carvalho', 'pedro.carvalho@email.com', '11987654336', '2023-08-18'),
('Quintino Barros', 'quintino.barros@email.com', '11987654337', '2023-09-02'),
('Rafaela Moraes', 'rafaela.moraes@email.com', '11987654338', '2023-09-15'),
('Samuel Dias', 'samuel.dias@email.com', '11987654339', '2023-10-01'),
('Tatiana Vieira', 'tatiana.vieira@email.com', '11987654340', '2023-10-20');

-- Inserindo 20 Produtos
INSERT INTO produtos (nome, descricao, preco, categoria, estoque) VALUES
('Café Expresso', 'Café puro tradicional', 5.00, 'Café', 100),
('Cappuccino', 'Café, leite vaporizado e chocolate', 8.50, 'Café', 100),
('Latte', 'Café com bastante leite', 7.50, 'Café', 100),
('Mocha', 'Café, leite e calda de chocolate', 9.00, 'Café', 100),
('Macchiato', 'Café com mancha de espuma de leite', 6.50, 'Café', 100),
('Pão de Queijo', 'Porção com 5 unidades pequenas', 6.00, 'Salgado', 50),
('Coxinha de Frango', 'Coxinha frita na hora', 7.00, 'Salgado', 50),
('Empada de Palmito', 'Empada de massa podre', 6.50, 'Salgado', 50),
('Croissant de Queijo', 'Croissant amanteigado', 8.00, 'Salgado', 50),
('Sanduíche Natural', 'Frango com cenoura e maionese', 10.00, 'Salgado', 30),
('Bolo de Cenoura', 'Fatia com cobertura de chocolate', 7.00, 'Doce', 40),
('Brownie', 'Brownie de chocolate meio amargo', 8.50, 'Doce', 40),
('Cheesecake de Frutas Vermelhas', 'Fatia tradicional', 12.00, 'Doce', 30),
('Torta de Limão', 'Fatia de torta doce', 9.00, 'Doce', 30),
('Brigadeiro', 'Unidade grande', 4.00, 'Doce', 60),
('Frappuccino de Caramelo', 'Café gelado batido', 14.00, 'Bebida Gelada', 40),
('Soda Italiana de Maçã Verde', 'Água com gás e xarope', 10.00, 'Bebida Gelada', 50),
('Chá Gelado de Pêssego', 'Copo 400ml', 8.00, 'Bebida Gelada', 50),
('Suco de Laranja', 'Suco natural 400ml', 7.50, 'Bebida Gelada', 50),
('Água Mineral', 'Sem gás 500ml', 3.50, 'Bebida Gelada', 100);

-- Inserindo 20 Pedidos
INSERT INTO pedidos (data_pedido, status, id_cliente) VALUES
('2023-11-01 08:30:00', 'Concluído', 1),
('2023-11-01 09:15:00', 'Concluído', 2),
('2023-11-02 10:00:00', 'Concluído', 3),
('2023-11-02 14:20:00', 'Concluído', 4),
('2023-11-03 15:45:00', 'Concluído', 5),
('2023-11-03 16:10:00', 'Concluído', 6),
('2023-11-04 08:00:00', 'Concluído', 7),
('2023-11-04 09:30:00', 'Concluído', 8),
('2023-11-05 11:15:00', 'Concluído', 9),
('2023-11-05 13:40:00', 'Concluído', 10),
('2023-11-06 14:50:00', 'Concluído', 11),
('2023-11-06 16:30:00', 'Concluído', 12),
('2023-11-07 17:10:00', 'Concluído', 1),
('2023-11-07 18:00:00', 'Concluído', 2),
('2023-11-08 08:45:00', 'Concluído', 15),
('2023-11-08 09:20:00', 'Concluído', 16),
('2023-11-09 10:30:00', 'Concluído', 17),
('2023-11-09 11:45:00', 'Concluído', 18),
('2023-11-10 12:00:00', 'Aberto', 19),
('2023-11-10 12:15:00', 'Aberto', 20);

-- Inserindo 25 Itens de Pedido
-- (Ao rodar isso, a TRIGGER de baixar estoque já será ativada e abaterá dos produtos!)
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 2, 5.00), (1, 6, 1, 6.00),     -- Pedido 1
(2, 2, 1, 8.50), (2, 9, 1, 8.00),     -- Pedido 2
(3, 16, 1, 14.00), (3, 12, 1, 8.50),  -- Pedido 3
(4, 3, 1, 7.50),                      -- Pedido 4
(5, 4, 1, 9.00), (5, 7, 2, 7.00),     -- Pedido 5
(6, 19, 1, 7.50),                     -- Pedido 6
(7, 1, 1, 5.00), (7, 11, 1, 7.00),    -- Pedido 7
(8, 2, 2, 8.50),                      -- Pedido 8
(9, 17, 1, 10.00), (9, 10, 1, 10.00), -- Pedido 9
(10, 5, 1, 6.50),                     -- Pedido 10
(11, 13, 1, 12.00), (11, 1, 1, 5.00), -- Pedido 11
(12, 18, 1, 8.00),                    -- Pedido 12
(13, 3, 1, 7.50), (13, 15, 2, 4.00),  -- Pedido 13
(14, 16, 2, 14.00),                   -- Pedido 14
(15, 14, 1, 9.00), (15, 20, 1, 3.50), -- Pedido 15
(16, 8, 1, 6.50),                     -- Pedido 16
(17, 9, 1, 8.00),                     -- Pedido 17
(18, 1, 1, 5.00),                     -- Pedido 18
(19, 2, 1, 8.50), (19, 11, 1, 7.00),  -- Pedido 19 (Aberto)
(20, 10, 2, 10.00);                   -- Pedido 20 (Aberto)

-- Inserindo 18 Pagamentos (apenas para pedidos concluídos)
INSERT INTO pagamentos (id_pedido, forma_pagamento, valor_total, data_pagamento) VALUES
(1, 'PIX', 16.00, '2023-11-01 08:35:00'),
(2, 'Cartão de Crédito', 16.50, '2023-11-01 09:20:00'),
(3, 'Cartão de Débito', 22.50, '2023-11-02 10:05:00'),
(4, 'Dinheiro', 7.50, '2023-11-02 14:22:00'),
(5, 'PIX', 23.00, '2023-11-03 15:50:00'),
(6, 'Cartão de Crédito', 7.50, '2023-11-03 16:15:00'),
(7, 'Dinheiro', 12.00, '2023-11-04 08:10:00'),
(8, 'PIX', 17.00, '2023-11-04 09:35:00'),
(9, 'Cartão de Débito', 20.00, '2023-11-05 11:20:00'),
(10, 'PIX', 6.50, '2023-11-05 13:42:00'),
(11, 'Cartão de Crédito', 17.00, '2023-11-06 14:55:00'),
(12, 'Dinheiro', 8.00, '2023-11-06 16:35:00'),
(13, 'PIX', 15.50, '2023-11-07 17:15:00'),
(14, 'Cartão de Crédito', 28.00, '2023-11-07 18:05:00'),
(15, 'Cartão de Débito', 12.50, '2023-11-08 08:50:00'),
(16, 'PIX', 6.50, '2023-11-08 09:25:00'),
(17, 'Dinheiro', 8.00, '2023-11-09 10:35:00'),
(18, 'Cartão de Crédito', 5.00, '2023-11-09 11:50:00');

SELECT 
    p.id_pedido, 
    c.nome AS cliente, 
    p.data_pedido, 
    p.status 
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
ORDER BY p.data_pedido DESC;

SELECT 
    pr.nome AS produto, 
    pr.categoria, 
    ip.quantidade, 
    ip.preco_unitario, 
    (ip.quantidade * ip.preco_unitario) AS subtotal
FROM itens_pedido ip
JOIN produtos pr ON ip.id_produto = pr.id_produto
WHERE ip.id_pedido = 1;

SELECT 
    pr.categoria, 
    SUM(ip.quantidade) AS total_vendido, 
    SUM(ip.quantidade * ip.preco_unitario) AS faturamento_bruto
FROM itens_pedido ip
JOIN produtos pr ON ip.id_produto = pr.id_produto
JOIN pedidos p ON ip.id_pedido = p.id_pedido
WHERE p.status = 'Concluído'
GROUP BY pr.categoria
ORDER BY faturamento_bruto DESC;

SELECT 
    p.id_pedido, 
    c.nome, 
    p.data_pedido, 
    fn_calcular_total_pedido(p.id_pedido) AS valor_a_pagar
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
LEFT JOIN pagamentos pg ON p.id_pedido = pg.id_pedido
WHERE pg.id_pagamento IS NULL;

SELECT 
    p.id_pedido, 
    p.data_pedido, 
    pr.nome AS produto, 
    ip.quantidade, 
    pg.valor_total AS valor_pago
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN itens_pedido ip ON p.id_pedido = ip.id_pedido
JOIN produtos pr ON ip.id_produto = pr.id_produto
LEFT JOIN pagamentos pg ON p.id_pedido = pg.id_pedido
WHERE c.nome = 'Ana Silva';

-- Útil para o departamento de compras entender o que precisa de mais reposição.
SELECT 
    pr.nome, 
    pr.categoria, 
    SUM(ip.quantidade) AS quantidade_total,
    pr.estoque AS estoque_atual
FROM itens_pedido ip
JOIN produtos pr ON ip.id_produto = pr.id_produto
GROUP BY pr.nome, pr.categoria, pr.estoque
ORDER BY quantidade_total DESC
LIMIT 5;

-- Identifica clientes para ações de marketing e descontos.
SELECT 
    c.nome, 
    c.email, 
    COUNT(p.id_pedido) AS numero_de_pedidos,
    SUM(pg.valor_total) AS total_gasto
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
JOIN pagamentos pg ON p.id_pedido = pg.id_pedido
WHERE p.status = 'Concluído'
GROUP BY c.id_cliente, c.nome, c.email
ORDER BY numero_de_pedidos DESC, total_gasto DESC
LIMIT 5;