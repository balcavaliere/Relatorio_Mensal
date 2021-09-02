--------------------------------------------------------------------------------------------
-------                             2.1.4. TRANSFERÊNCIAS                              -----
--------------------------------------------------------------------------------------------
SELECT z.[2.1.4 - TRANSFERÊNCIAS]
	,FORMAT(z.[2021],'c','pt-br') AS "2021"
	,FORMAT(z.[2020],'c','pt-br') AS "2020"
	,FORMAT(z.DIF,'c','pt-br') AS "DIF"
	,CAST(CAST(z.[DIF%] AS DECIMAL(10,2)) AS VARCHAR(10))+'%' AS "DIF%"
FROM(
/* TOTAL INÍCIO */
	SELECT 
		'TOTAL' AS "2.1.4 - TRANSFERÊNCIAS"
		,a21.[2021]
		,a20.[2020]
		,a21.[2021]-a20.[2020] AS "DIF"
		,IIF(a20.[2020]=0,0,(a21.[2021]-a20.[2020])/a20.[2020]*100) AS "DIF%"
	FROM
		(SELECT Nivel2, SUM(ValorRealizado + ValorDeducao + ValorEstorno) AS "2021"
		FROM Receitas
		WHERE DataMovimento BETWEEN '2021-01-01' AND '2021-07-31' AND Nivel2='1700000000'
		GROUP BY Nivel2) a21
	FULL OUTER JOIN
		(SELECT Nivel2, SUM(ValorRealizado + ValorDeducao + ValorEstorno) AS "2020"
		FROM Receitas
		WHERE DataMovimento BETWEEN '2020-01-01' AND '2020-07-31' AND Nivel2='1700000000'
		GROUP BY Nivel2) a20
	ON a21.Nivel2 = a20.Nivel2
	GROUP BY a21.[2021], a20.[2020]
/* TOTAL FIM */

UNION ALL

/* TABELA INÍCIO */
	SELECT 
		co.Descricao AS "2.1.4 - TRANSFERÊNCIAS"
		,a21.[2021]
		,a20.[2020]
		,a21.[2021]-a20.[2020] AS "DIF"
		,IIF(a20.[2020]=0,0,(a21.[2021]-a20.[2020])/a20.[2020]*100) AS "DIF%"
	FROM
		(SELECT Nivel3, SUM(ValorRealizado + ValorDeducao + ValorEstorno) AS "2021"
		FROM Receitas
		WHERE DataMovimento BETWEEN '2021-01-01' AND '2021-07-31' AND Nivel2='1700000000'
		GROUP BY Nivel3) a21
	FULL OUTER JOIN
		(SELECT Nivel3, SUM(ValorRealizado + ValorDeducao + ValorEstorno) AS "2020"
		FROM Receitas
		WHERE DataMovimento BETWEEN '2020-01-01' AND '2020-07-31' AND Nivel2='1700000000'
		GROUP BY Nivel3) a20
	ON a21.Nivel3 = a20.Nivel3
	INNER JOIN 
		CodigosOrcamentarios co
	ON (co.CodigoOrcamentario=a21.Nivel3 AND co.Exercicio=2021) OR (co.CodigoOrcamentario=a20.Nivel3 AND co.Exercicio=2020)
	GROUP BY co.Descricao, a21.[2021], a20.[2020]

/* TABELA FIM */
)z
ORDER BY z.[2021] DESC