--------------------------------------------------------------------------------------------
-------                        4.1 Receita por Fonte - JULHO                           -----
--------------------------------------------------------------------------------------------




/* INICIO TABELA PRINCIPAL */
	SELECT	CONCAT (f.FonteRecurso,' - ', f.DescricaoFonteRecurso) AS '4.1 RECEITA POR FONTE'
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