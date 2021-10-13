--------------------------------------------------------------------------------------------
-------                       5.2. DESPESAS POR UNIDADE GESTORA                        -----
--------------------------------------------------------------------------------------------


SELECT	z.[DESPESA POR UNIDADE GESTORA]
		,FORMAT (z.[2021],'C','PT-BR') AS '2021'
		,FORMAT (z.[2020],'C','PT-BR') AS '2020'
		,FORMAT (z.DIF,'C','PT-BR') AS 'DIF'
		,CONCAT (CAST(z.[DIF%] AS VARCHAR(10)),'%') AS 'DIF%'

FROM
(
SELECT		'TOTAL' AS 'DESPESA POR UNIDADE GESTORA'
			,ISNULL(SUM(d21.[2021]),0) AS '2021'
			,ISNULL(SUM(d20.[2020]),0) AS '2020'
			,ISNULL(SUM(d21.[2021]) - SUM(d20.[2020]),0) AS 'DIF'
			,ISNULL(SUM(d21.[2021] - d20.[2020])/SUM(d20.[2020])*100,0) AS 'DIF%'

	FROM (
		SELECT	UG
				,SUM(ValorPago - ValorPagoDevolvido) AS '2021'
		FROM Despesas
		WHERE DataMovimento BETWEEN '2021-01-01' AND '2021-07-31'
		GROUP BY UG) d21
	FULL OUTER JOIN
		(
		SELECT	UG
				,SUM(ValorPago - ValorPagoDevolvido) AS '2020'
		FROM Despesas
		WHERE DataMovimento BETWEEN '2020-01-01' AND '2020-07-31'
		GROUP BY UG) d20
	ON d21.UG = d20.UG
	LEFT JOIN UnidadesGestoras ug
	ON ug.UG = d21.UG AND ug.Exercicio = 2021
	
	WHERE ug.DescricaoUG <> 'INSTITUTO DE PREVIDENCIA E ASSISTENCIA' AND ug.DescricaoUG <> 'CAMARA MUNICIPAL DE ITABORAÍ'

UNION ALL

SELECT		ug.DescricaoUG AS 'DESPESA POR UNIDADE GESTORA'
			,ISNULL(d21.[2021],0) AS '2021'
			,ISNULL(d20.[2020],0) AS '2020'
			,ISNULL(d21.[2021] - d20.[2020],0) AS 'DIF'
			,ISNULL(IIF(d20.[2020]=0,0,(d21.[2021] - d20.[2020])/d20.[2020]*100),0) AS 'DIF%'

	FROM (
		SELECT	UG
				,SUM(ValorPago - ValorPagoDevolvido) AS '2021'		
		FROM Despesas
		WHERE DataMovimento BETWEEN '2021-01-01' AND '2021-07-31'
		GROUP BY UG) d21
	FULL OUTER JOIN
		(
		SELECT	UG
				,SUM(ValorPago - ValorPagoDevolvido) AS '2020'
		FROM Despesas
		WHERE DataMovimento BETWEEN '2020-01-01' AND '2020-07-31'
		GROUP BY UG) d20
	ON d21.UG = d20.UG
	LEFT JOIN UnidadesGestoras ug
	ON ug.UG = d21.UG AND ug.Exercicio = 2021
	
	WHERE ug.DescricaoUG <> 'INSTITUTO DE PREVIDENCIA E ASSISTENCIA' AND ug.DescricaoUG <> 'CAMARA MUNICIPAL DE ITABORAÍ'
	) z
ORDER BY z.DIF DESC