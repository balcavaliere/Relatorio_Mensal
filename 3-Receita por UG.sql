--------------------------------------------------------------------------------------------
-------                        3. Receita por Unidade Gestora                          -----
--------------------------------------------------------------------------------------------

SELECT	z.[3. RECEITA UNIDADE GESTORA] AS '3. RECEITA UNIDADE GESTORA'
		, FORMAT(z.[2021],'C','PT-BR') AS "2021"
		, FORMAT(z.[2020],'C','PT-BR') AS "2020"
		, FORMAT(z.DIF,'C','PT-BR') AS 'DIF'
		, CAST(CAST(z.[DIF%] AS DECIMAL(10,2)) AS VARCHAR(10)) + '%' AS 'DIF%'
FROM (

/* INÍCIO TOTAL */
	SELECT	'TOTAL' AS '3. RECEITA UNIDADE GESTORA'
			, t21.[2021]
			, t20.[2020]
			, t21.[2021]-t20.[2020] AS 'DIF'
			, (t21.[2021]-t20.[2020])/t20.[2020]*100 AS 'DIF%'
	FROM (
		SELECT SUM (ValorRealizado+ValorDeducao+ValorEstorno) AS '2021'
		FROM Receitas
		WHERE DataMovimento BETWEEN '2021-01-01' AND '2021-07-31' AND UG<>'3') t21
	FULL OUTER JOIN
		(SELECT SUM (ValorRealizado+ValorDeducao+ValorEstorno) AS '2020'
		FROM Receitas
		WHERE DataMovimento BETWEEN '2020-01-01' AND '2020-07-31' AND UG<>'3') t20
	ON 1=1
/* FIM TOTAL */
	
UNION ALL

/* INICIO TABELA PRINCIPAL */
	SELECT	ug.DescricaoUG AS '3. RECEITA UNIDADE GESTORA'
			,ug21.[2021]
			,ug20.[2020]
			,ug21.[2021]-ug20.[2020] AS 'DIF'
			,(ug21.[2021]-ug20.[2020])/ug20.[2020]*100 AS 'DIF%'
	FROM (
		SELECT	 UG
				, SUM(ValorRealizado + ValorDeducao + ValorEstorno) AS "2021"
		FROM Receitas
		WHERE DataMovimento BETWEEN '2021-01-01' AND '2021-07-31' AND UG<>'3'
		GROUP BY UG) ug21
	FULL OUTER JOIN (
		SELECT	 UG
				, SUM(ValorRealizado + ValorDeducao + ValorEstorno) AS "2020"
		FROM Receitas
		WHERE DataMovimento BETWEEN '2020-01-01' AND '2020-07-31' AND UG<>'3'
		GROUP BY UG) ug20
	ON ug21.UG=ug20.UG
	LEFT JOIN
		UnidadesGestoras ug
	ON ug.UG = ug21.UG AND ug.Exercicio='2021'
/* FIM TABELA PRINCIPAL */

)z
ORDER BY z.[2021] DESC