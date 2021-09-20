--------------------------------------------------------------------------------------------
-------                            5.1. DESPESAS POR ORGÃO                             -----
--------------------------------------------------------------------------------------------

SELECT	z.[DESPESA POR ORGÃO]
		,FORMAT (ISNULL(z.[2021],0),'C','PT-BR') AS '2021'
		,FORMAT (ISNULL(z.[2020],0),'C','PT-BR') AS '2020'
		,FORMAT (ISNULL(z.DIF,0),'C','PT-BR') AS 'DIF'
		,CONCAT (CAST(ISNULL (z.[DIF%],0) AS VARCHAR(10)),'%') AS 'DIF%'

FROM
(
SELECT		'TOTAL' AS 'DESPESA POR ORGÃO'
			,SUM(d21.[2021]) AS '2021'
			,SUM(d20.[2020]) AS '2020'
			,SUM(d21.[2021]) - SUM(d20.[2020]) AS 'DIF'
			,SUM(d21.[2021] - d20.[2020])/SUM(d20.[2020])*100 AS 'DIF%'

	FROM (
		SELECT	Orgao
				,SUM(ValorPago - ValorPagoDevolvido) AS '2021'		
		FROM Despesas
		WHERE DataMovimento BETWEEN '2021-01-01' AND '2021-07-31'
		GROUP BY Orgao) d21
	FULL OUTER JOIN
		(
		SELECT	Orgao
				,SUM(ValorPago - ValorPagoDevolvido) AS '2020'		
		FROM Despesas
		WHERE DataMovimento BETWEEN '2020-01-01' AND '2020-07-31'
		GROUP BY Orgao) d20
	ON d21.Orgao = d20.Orgao
	LEFT JOIN (
		SELECT DISTINCT Orgao, DescricaoOrgao
		FROM SubUnidades
		WHERE Exercicio = 2021
		) su
	ON su.Orgao = d21.Orgao
	
	WHERE su.DescricaoOrgao <> 'ITAPREVI' AND su.DescricaoOrgao <> 'CAMARA MUNICIPAL DE ITABORAI'

UNION ALL

SELECT		su.DescricaoOrgao AS 'DESPESA POR ORGÃO'
			,d21.[2021] AS '2021'
			,d20.[2020] AS '2020'
			,d21.[2021] - d20.[2020] AS 'DIF'
			,IIF(d20.[2020]=0,0,(d21.[2021] - d20.[2020])/d20.[2020]*100) AS 'DIF%'

	FROM (
		SELECT	Orgao
				,SUM(ValorPago - ValorPagoDevolvido) AS '2021'		
		FROM Despesas
		WHERE DataMovimento BETWEEN '2021-01-01' AND '2021-07-31'
		GROUP BY Orgao) d21
	FULL OUTER JOIN
		(
		SELECT	Orgao
				,SUM(ValorPago - ValorPagoDevolvido) AS '2020'		
		FROM Despesas
		WHERE DataMovimento BETWEEN '2020-01-01' AND '2020-07-31'
		GROUP BY Orgao) d20
	ON d21.Orgao = d20.Orgao
	LEFT JOIN (
		SELECT DISTINCT Orgao, DescricaoOrgao
		FROM SubUnidades
		WHERE Exercicio = 2021
		) su
	ON su.Orgao = d21.Orgao
	
	WHERE su.DescricaoOrgao <> 'ITAPREVI' AND su.DescricaoOrgao <> 'CAMARA MUNICIPAL DE ITABORAI'
	) z