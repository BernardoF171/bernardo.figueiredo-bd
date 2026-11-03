-- =====================================================================
-- Consultas_relatorios.sql  (OPCIONAL)
-- TCC Rota Segura SP - consultas que alimentam o painel e os relatórios
-- (JOIN, GROUP BY, HAVING, subconsulta, LEFT JOIN, view e função de janela).
-- Rode depois de Dados_exemplo.sql.
-- =====================================================================

USE rota_segura_sp;

-- C1. Ranking de DPs no primeiro semestre de 2026 (INNER JOIN + GROUP BY)
SELECT  dp.numero AS dp, dp.nome AS distrito, COUNT(*) AS total
FROM    ocorrencias o
JOIN    locais l               ON l.id_local = o.id_local
JOIN    distritos_policiais dp ON dp.id_dp   = l.id_dp
WHERE   o.data_hora >= '2026-01-01' AND o.data_hora < '2026-07-01'
GROUP BY dp.id_dp, dp.numero, dp.nome
ORDER BY total DESC;

-- C2. Furtos x roubos por região (JOIN em 4 tabelas)
SELECT  dp.regiao,
        SUM(t.com_violencia = 0) AS furtos,
        SUM(t.com_violencia = 1) AS roubos,
        COUNT(*)                 AS total
FROM    ocorrencias o
JOIN    tipos_crime t          ON t.id_tipo  = o.id_tipo
JOIN    locais l               ON l.id_local = o.id_local
JOIN    distritos_policiais dp ON dp.id_dp   = l.id_dp
GROUP BY dp.regiao
ORDER BY total DESC;

-- C3. Ocorrências por período do dia (usa a função fn_periodo_do_dia)
SELECT  fn_periodo_do_dia(hora) AS periodo, COUNT(*) AS total
FROM    ocorrencias
GROUP BY periodo
ORDER BY FIELD(periodo, 'MADRUGADA','MANHA','TARDE','NOITE');

-- C4. Locais com 10 ou mais ocorrências (HAVING)
SELECT  l.nome AS local, l.tipo_local, COUNT(*) AS total
FROM    ocorrencias o
JOIN    locais l ON l.id_local = o.id_local
GROUP BY l.id_local, l.nome, l.tipo_local
HAVING  COUNT(*) >= 10
ORDER BY total DESC;

-- C5. Locais cadastrados que ainda não têm nenhuma ocorrência (LEFT JOIN)
SELECT  l.id_local, l.nome
FROM    locais l
LEFT JOIN ocorrencias o ON o.id_local = l.id_local
WHERE   o.id_ocorrencia IS NULL;

-- C6. DPs acima da média de ocorrências por DP (subconsulta)
SELECT  dp.numero, dp.nome, COUNT(*) AS total
FROM    ocorrencias o
JOIN    locais l               ON l.id_local = o.id_local
JOIN    distritos_policiais dp ON dp.id_dp   = l.id_dp
GROUP BY dp.id_dp, dp.numero, dp.nome
HAVING  COUNT(*) > (SELECT AVG(qtd) FROM (
                        SELECT COUNT(*) AS qtd
                        FROM ocorrencias o2
                        JOIN locais l2 ON l2.id_local = o2.id_local
                        GROUP BY l2.id_dp) AS x)
ORDER BY total DESC;

-- C7. Relatos aprovados, que o público pode ver (view; sem autor nem moderador)
SELECT * FROM vw_relatos_publicos;

-- C8. Relatos por situação de moderação
SELECT  status, COUNT(*) AS qtd FROM relatos GROUP BY status;

-- C9. Detalhe das ocorrências de um DP, usando a view
SELECT  data_hora, tipo_crime, local, numero_bo
FROM    vw_ocorrencias_detalhe
WHERE   numero_dp = 3
ORDER BY data_hora DESC
LIMIT 10;

-- C10. Conferência: o resumo mantido pelos triggers bate com a contagem real?
SELECT  (SELECT SUM(total) FROM estatistica_dp_mensal)  AS total_no_resumo,
        (SELECT COUNT(*)   FROM ocorrencias)            AS total_real;

-- C11. Chamadas das procedures
CALL sp_ranking_dp('2026-01-01', '2026-06-30', NULL, 5);
CALL sp_ocorrencias_por_horario('2026-01-01', '2026-06-30');
CALL sp_orientacoes_por_tipo(2, 'POS_OCORRENCIA');
CALL sp_variacao_mensal(2026);
