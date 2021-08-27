--------------------------------------------------------------------------------------------
-------                            1.1. ARRECADAÇÃO COMPARATIVA                        -----
--------------------------------------------------------------------------------------------

SELECT z.[RECEITA POR FONTE]
, FORMAT (z.[2021],'C','PT-BR') AS "2021"
, FORMAT (z.[2020],'C','PT-BR') AS "2020"
, FORMAT (z.DIF, 'C', 'PT-BR') AS "DIF"
, ISNULL (CAST(CAST (z.[DIF %] AS DECIMAL(10,2)) AS VARCHAR(50)) + '%', '-') AS "DIF %" 

FROM (
SELECT /* TOTAL INICIO */
'TOTAL' AS "RECEITA POR FONTE"
, SUM(a21.[Arrecadação 2021]) AS "2021"
, SUM(a20.[Arrecadação 2020]) AS "2020"
, SUM(a21.[Arrecadação 2021] - a20.[Arrecadação 2020]) AS "DIF"
, (SUM(a21.[Arrecadação 2021]) - SUM(a20.[Arrecadação 2020])) / (SUM(a20.[Arrecadação 2020])) * 100 AS "DIF %"
FROM (/* Arrecadação JAN a JUL 2021 */
SELECT 
r.FonteRecurso
, SUM(r.ValorRealizado + r.ValorDeducao + r.ValorEstorno) AS "Arrecadação 2021"
FROM Receitas r
WHERE r.DataMovimento BETWEEN '2021-01-01' AND '2021-07-31'
GROUP BY r.FonteRecurso) a21

FULL OUTER JOIN (/* Arrecadação JAN a JUL 2020 */
SELECT 
r.FonteRecurso
, SUM(r.ValorRealizado + r.ValorDeducao + r.ValorEstorno) AS "Arrecadação 2020"
FROM Receitas r
WHERE r.DataMovimento BETWEEN '2020-01-01' AND '2020-07-31'
GROUP BY r.FonteRecurso) a20
ON a21.FonteRecurso = a20.FonteRecurso /* TOTAL FIM */

UNION ALL

SELECT fc.Fonte AS "RECEITA POR FONTE"/* RECEITA POR FONTE INICIO */
, ISNULL(a21.[Arrecadação 2021],0) AS "2021"
, ISNULL(a20.[Arrecadação 2020],0) AS "2020"
, ISNULL(a21.[Arrecadação 2021],0) - ISNULL(a20.[Arrecadação 2020],0) AS "DIF"
, (a21.[Arrecadação 2021] - a20.[Arrecadação 2020]) / (a20.[Arrecadação 2020]) * 100 AS "DIF %"
FROM ( /* Arrecadação JAN a JUL 2021 */
SELECT 
r.FonteRecurso
, SUM(r.ValorRealizado + r.ValorDeducao + r.ValorEstorno) AS "Arrecadação 2021"
FROM Receitas r
WHERE r.DataMovimento BETWEEN '2021-01-01' AND '2021-07-31'
GROUP BY r.FonteRecurso) a21

FULL OUTER JOIN (/* Arrecadação JAN a JUL 2020 */
SELECT 
r.FonteRecurso
, SUM(r.ValorRealizado + r.ValorDeducao + r.ValorEstorno) AS "Arrecadação 2020"
FROM Receitas r
WHERE r.DataMovimento BETWEEN '2020-01-01' AND '2020-07-31'
GROUP BY r.FonteRecurso) a20
ON a21.FonteRecurso = a20.FonteRecurso

LEFT JOIN (/* Fonte recurso concatenada */
SELECT FonteRecurso
, CONCAT(f.FonteRecurso,' - ', f.DescricaoFonteRecurso) AS "Fonte"
FROM FontesRecursos f
WHERE Exercicio = 2021) fc
ON fc.FonteRecurso = a21.FonteRecurso /* RECEITA POR FONTE FIM */

) z

ORDER BY z.[2021] DESC