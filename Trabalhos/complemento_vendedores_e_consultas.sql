-- ============================================================
-- COMPLEMENTO DO BANCO: VENDEDORES
-- Execute este script DEPOIS de Cafeteria.sql
-- ============================================================

-- 1) Tabela de vendedores
CREATE TABLE vendedores (
    id_vendedor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- 2) Vínculo do pedido com o vendedor que atendeu
ALTER TABLE pedidos
ADD COLUMN id_vendedor INT REFERENCES vendedores(id_vendedor);

-- 3) Inserindo 4 vendedores fictícios
INSERT INTO vendedores (nome) VALUES
('Rafael Nunes'),
('Camila Duarte'),
('Thiago Rocha'),
('Juliana Prado');

-- 4) Distribuindo os 20 pedidos já existentes entre os 4 vendedores
--    (5 pedidos para cada, incluindo os 2 pedidos "Aberto")
UPDATE pedidos SET id_vendedor = 1 WHERE id_pedido IN (1, 5, 9, 13, 17);
UPDATE pedidos SET id_vendedor = 2 WHERE id_pedido IN (2, 6, 10, 14, 18);
UPDATE pedidos SET id_vendedor = 3 WHERE id_pedido IN (3, 7, 11, 15, 19);
UPDATE pedidos SET id_vendedor = 4 WHERE id_pedido IN (4, 8, 12, 16, 20);


-- ============================================================
-- AS 10 CONSULTAS FINAIS (todas funcionando com o banco completo)
-- ============================================================

-- 1. Quantidade de vendas por vendedor
SELECT 
    v.nome AS vendedor,
    COUNT(DISTINCT p.id_pedido) AS quantidade_vendas
FROM pedidos p
JOIN vendedores v ON p.id_vendedor = v.id_vendedor
WHERE p.status = 'Concluído'
GROUP BY v.nome
ORDER BY quantidade_vendas DESC;


-- 2. Faturamento por vendedor
SELECT 
    v.nome AS vendedor,
    SUM(pg.valor_total) AS faturamento
FROM pedidos p
JOIN vendedores v ON p.id_vendedor = v.id_vendedor
JOIN pagamentos pg ON p.id_pedido = pg.id_pedido
WHERE p.status = 'Concluído'
GROUP BY v.nome
ORDER BY faturamento DESC;


-- 3. Faturamento por produto
SELECT 
    pr.nome AS produto,
    SUM(ip.quantidade * ip.preco_unitario) AS faturamento
FROM itens_pedido ip
JOIN produtos pr ON ip.id_produto = pr.id_produto
JOIN pedidos p ON ip.id_pedido = p.id_pedido
WHERE p.status = 'Concluído'
GROUP BY pr.nome
ORDER BY faturamento DESC;


-- 4. Média de valor dos produtos
-- Geral:
SELECT AVG(preco) AS preco_medio_geral FROM produtos;

-- Por categoria:
SELECT categoria, AVG(preco) AS preco_medio
FROM produtos
GROUP BY categoria
ORDER BY preco_medio DESC;


-- 5. Ticket médio de cada vendedor
SELECT 
    v.nome AS vendedor,
    AVG(pg.valor_total) AS ticket_medio
FROM pedidos p
JOIN vendedores v ON p.id_vendedor = v.id_vendedor
JOIN pagamentos pg ON p.id_pedido = pg.id_pedido
WHERE p.status = 'Concluído'
GROUP BY v.nome
ORDER BY ticket_medio DESC;


-- 6. Produtos com mais de 5 unidades vendidas
SELECT 
    pr.nome AS produto,
    SUM(ip.quantidade) AS total_vendido
FROM itens_pedido ip
JOIN produtos pr ON ip.id_produto = pr.id_produto
JOIN pedidos p ON ip.id_pedido = p.id_pedido
WHERE p.status = 'Concluído'
GROUP BY pr.nome
HAVING SUM(ip.quantidade) > 5
ORDER BY total_vendido DESC;


-- 7. Vendedores com faturamento superior a R$ 2.000
SELECT 
    v.nome AS vendedor,
    SUM(pg.valor_total) AS faturamento
FROM pedidos p
JOIN vendedores v ON p.id_vendedor = v.id_vendedor
JOIN pagamentos pg ON p.id_pedido = pg.id_pedido
WHERE p.status = 'Concluído'
GROUP BY v.nome
HAVING SUM(pg.valor_total) > 2000
ORDER BY faturamento DESC;


-- 8. Total de vendas por dia
SELECT 
    DATE(p.data_pedido) AS dia,
    COUNT(DISTINCT p.id_pedido) AS total_pedidos,
    SUM(pg.valor_total) AS faturamento_dia
FROM pedidos p
JOIN pagamentos pg ON p.id_pedido = pg.id_pedido
WHERE p.status = 'Concluído'
GROUP BY DATE(p.data_pedido)
ORDER BY dia;


-- 9. Vendedor com maior faturamento
SELECT 
    v.nome AS vendedor,
    SUM(pg.valor_total) AS faturamento
FROM pedidos p
JOIN vendedores v ON p.id_vendedor = v.id_vendedor
JOIN pagamentos pg ON p.id_pedido = pg.id_pedido
WHERE p.status = 'Concluído'
GROUP BY v.nome
ORDER BY faturamento DESC
LIMIT 1;


-- 10. Produto mais vendido
SELECT 
    pr.nome AS produto,
    SUM(ip.quantidade) AS total_vendido
FROM itens_pedido ip
JOIN produtos pr ON ip.id_produto = pr.id_produto
JOIN pedidos p ON ip.id_pedido = p.id_pedido
WHERE p.status = 'Concluído'
GROUP BY pr.nome
ORDER BY total_vendido DESC
LIMIT 1;
