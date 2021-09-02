--------------------------------------------------------------------------------------------
-------                                 2.1.2. TAXAS                                   -----
--------------------------------------------------------------------------------------------

SELECT z.[2.1.2 - TAXAS]
	,FORMAT (z.[2021],'C', 'PT-BR')AS "2021"
	,FORMAT (z.[2020],'C', 'PT-BR')AS "2020"
	,FORMAT (z.DIF,'C', 'PT-BR') AS "DIF"
	,CAST(CAST (z.[DIF%] AS DECIMAL(10,2)) AS VARCHAR(10))+'%' AS "DIF%"
FROM (

/* TOTAL INICIO */
SELECT 'TOTAL' AS "2.1.2 - TAXAS"
	,SUM(a21.[2021]) AS "2021"
	,SUM(a20.[2020]) AS "2020"
	,SUM((a21.[2021] - a20.[2020])) AS "DIF"
	,SUM((a21.[2021] - a20.[2020])) / SUM(a20.[2020])*100 AS "DIF%"
FROM 
		(SELECT Nivel4, SUM (ValorRealizado + ValorDeducao + ValorEstorno) AS "2021"
		FROM Receitas
		WHERE (DataMovimento BETWEEN '2021-01-01' AND '2021-07-31' AND CodigoOrcamentario IN ('1122011110','1121041100','1121260000','1121011107','1121011106','1121011118','1121011108', '1121011102', '1121011101', '1121011103', '1121011109' , '1122011101'))
		GROUP BY Nivel4) a21
	FULL OUTER JOIN
		(SELECT Nivel4, SUM (ValorRealizado + ValorDeducao + ValorEstorno) AS "2020"
		FROM Receitas
		WHERE (DataMovimento BETWEEN '2020-01-01' AND '2020-07-31' AND CodigoOrcamentario IN ('1122011110','1121041100','1121260000','1121011107','1121011106','1121011118','1121011108', '1121011102', '1121011101', '1121011103', '1121011109' , '1122011101'))
		GROUP BY Nivel4) a20
	ON a21.Nivel4 = a20.Nivel4
/* TOTAL FIM */

UNION ALL

/* TABELA INICIO */
SELECT co.Descricao AS "2.1.2 - TAXAS"
	,a21.[2021]
	,a20.[2020]
	,(a21.[2021] - a20.[2020]) AS "DIF"
	,(a21.[2021] - a20.[2020]) / (a20.[2020])*100 AS "DIF%"
FROM 
		(SELECT Nivel4, SUM (ValorRealizado + ValorDeducao + ValorEstorno) AS "2021"
		FROM Receitas
		WHERE (DataMovimento BETWEEN '2021-01-01' AND '2021-07-31' AND CodigoOrcamentario IN ('1122011110','1121041100','1121260000','1121011107','1121011106','1121011118','1121011108', '1121011102', '1121011101', '1121011103', '1121011109' , '1122011101'))
		GROUP BY Nivel4) a21
	FULL OUTER JOIN
		(SELECT Nivel4, SUM (ValorRealizado + ValorDeducao + ValorEstorno) AS "2020"
		FROM Receitas
		WHERE (DataMovimento BETWEEN '2020-01-01' AND '2020-07-31' AND CodigoOrcamentario IN ('1122011110','1121041100','1121260000','1121011107','1121011106','1121011118','1121011108', '1121011102', '1121011101', '1121011103', '1121011109' , '1122011101'))
		GROUP BY Nivel4) a20
	ON a21.Nivel4 = a20.Nivel4
	LEFT JOIN
		CodigosOrcamentarios co
	ON a21.Nivel4 = co.CodigoOrcamentario OR a20.Nivel4 = co.CodigoOrcamentario
GROUP BY co.Descricao, a21.[2021],a20.[2020]
/* TABELA FIM */

) z