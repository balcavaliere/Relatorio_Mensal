--------------------------------------------------------------------------------------------
-------                        4.1. Receita por Fonte - JULHO                          -----
--------------------------------------------------------------------------------------------
SELECT	z.[4.1 RECEITA POR FONTE (JULHO)]
		,FORMAT (ISNULL(z.[2021],0),'C','PT-BR') AS '2021'
		,FORMAT (ISNULL(z.[2020],0),'C','PT-BR') AS '2020'
		,FORMAT (ISNULL(z.DIF,0),'C','PT-BR') AS 'DIF'
		,ISNULL(CAST (CAST (z.[DIF%] AS DECIMAL(10,2)) AS VARCHAR(10)) +'%','-') AS 'DIF%'
FROM (
/* INÍCIO TOTAL */
	SELECT	'TOTAL' AS '4.1 RECEITA POR FONTE (JULHO)'
			, t21.[2021]
			, t20.[2020]
			, t21.[2021]-t20.[2020] AS 'DIF'
			, (t21.[2021]-t20.[2020])/t20.[2020]*100 AS 'DIF%'
	FROM (
		SELECT SUM (ValorRealizado+ValorDeducao+ValorEstorno) AS '2021'
		FROM Receitas
		WHERE DataMovimento BETWEEN '2021-07-01' AND '2021-07-31') t21
	FULL OUTER JOIN
		(SELECT SUM (ValorRealizado+ValorDeducao+ValorEstorno) AS '2020'
		FROM Receitas
		WHERE DataMovimento BETWEEN '2020-07-01' AND '2020-07-31') t20
	ON 1=1
/* FIM TOTAL */
	
UNION ALL

/* INICIO TABELA PRINCIPAL */
	SELECT	CONCAT (f.FonteRecurso,' - ', f.DescricaoFonteRecurso) AS '4.1 RECEITA POR FONTE (JULHO)'
			,a21.[2021]
			,a20.[2020]
			,a21.[2021]-a20.[2020] AS 'DIF'
			,(a21.[2021]-a20.[2020])/a20.[2020]*100 AS 'DIF%'
	FROM (
		SELECT	 FonteRecurso
				, SUM(ValorRealizado + ValorDeducao + ValorEstorno) AS "2021"
		FROM Receitas
		WHERE DataMovimento BETWEEN '2021-07-01' AND '2021-07-31'
		GROUP BY FonteRecurso) a21
	FULL OUTER JOIN (
		SELECT	 FonteRecurso
				, SUM(ValorRealizado + ValorDeducao + ValorEstorno) AS "2020"
		FROM Receitas
		WHERE DataMovimento BETWEEN '2020-07-01' AND '2020-07-31'
		GROUP BY FonteRecurso) a20
	ON a21.FonteRecurso = a20.FonteRecurso
	LEFT JOIN
		FontesRecursos f
	ON f.FonteRecurso = a21.FonteRecurso AND f.Exercicio='2021'
/* FIM TABELA PRINCIPAL */
	) z
ORDER BY z.[2021] DESC