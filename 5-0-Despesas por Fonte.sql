--------------------------------------------------------------------------------------------
-------                            5.0. DESPESAS POR FONTE                             -----
--------------------------------------------------------------------------------------------

	
SELECT	z.[DESPESA POR FONTE]
		,FORMAT (ISNULL(z.[2021],0),'C','PT-BR') AS '2021'
		,FORMAT (ISNULL(z.[2020],0),'C','PT-BR') AS '2020'
		,FORMAT (ISNULL(z.DIF,0),'C','PT-BR') AS 'DIF'
		,ISNULL(CAST (CAST(z.[DIF%] AS DECIMAL(10,2)) AS VARCHAR(10))+'%','-') AS 'DIF%'
FROM (
	SELECT	'TOTAL' AS 'DESPESA POR FONTE'
			,d21.[2021]
			,d20.[2020]
			,d21.[2021] - d20.[2020] AS 'DIF'
			,IIF(d20.[2020]=0,0,(d21.[2021] - d20.[2020])/(d20.[2020])*100) AS 'DIF%'
	FROM (
		SELECT	SUM(ValorPago - ValorPagoDevolvido) AS '2021'		
		FROM Despesas
		WHERE DataMovimento BETWEEN '2021-01-01' AND '2021-07-31'
		) d21
	FULL OUTER JOIN
		(
		SELECT	SUM(ValorPago - ValorPagoDevolvido) AS '2020'		
		FROM Despesas
		WHERE DataMovimento BETWEEN '2020-01-01' AND '2020-07-31'
		) d20
	ON 1=1

	
	UNION ALL
	
	SELECT	CONCAT (f.FonteRecurso,' - ',f.DescricaoFonteRecurso) AS 'DESPESA POR FONTE'
			,d21.[2021]
			,d20.[2020]
			,d21.[2021] - d20.[2020] AS 'DIF'
			,IIF(d20.[2020]=0,0,(d21.[2021] - d20.[2020])/d20.[2020]*100) AS 'DIF%'

	FROM (
		SELECT	FonteRecurso
				,SUM(ValorPago - ValorPagoDevolvido) AS '2021'		
		FROM Despesas
		WHERE DataMovimento BETWEEN '2021-01-01' AND '2021-07-31'
		GROUP BY FonteRecurso) d21
	FULL OUTER JOIN
		(
		SELECT	FonteRecurso
				,SUM(ValorPago - ValorPagoDevolvido) AS '2020'		
		FROM Despesas
		WHERE DataMovimento BETWEEN '2020-01-01' AND '2020-07-31'
		GROUP BY FonteRecurso) d20
	ON d21.FonteRecurso = d20.FonteRecurso
	LEFT JOIN
		FontesRecursos f
	ON d21.FonteRecurso = f.FonteRecurso AND f.Exercicio = 2021
) z
WHERE z.[DESPESA POR FONTE] <> ' - '
ORDER BY z.DIF DESC