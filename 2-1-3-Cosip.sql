--------------------------------------------------------------------------------------------
-------                                 2.1.3. COSIP                                   -----
--------------------------------------------------------------------------------------------

SELECT co.Descricao AS "2.1.3 - COSIP"
	,FORMAT (a21.[2021],'C','PT-BR') AS "2021"
	,FORMAT (a20.[2020],'C','PT-BR') AS "2020"
	,FORMAT ((a21.[2021] - a20.[2020]),'C','PT-BR') AS "DIF"
	,CAST(CAST((a21.[2021] - a20.[2020]) / (a20.[2020])*100 AS DECIMAL(10,2)) AS VARCHAR(10)) +'%' AS "DIF%"
FROM 
		(SELECT Nivel4, SUM (ValorRealizado + ValorDeducao + ValorEstorno) AS "2021"
		FROM Receitas
		WHERE (DataMovimento BETWEEN '2021-01-01' AND '2021-07-31' AND CodigoOrcamentario='1240001100')
		GROUP BY Nivel4) a21
	FULL OUTER JOIN
		(SELECT Nivel4, SUM (ValorRealizado + ValorDeducao + ValorEstorno) AS "2020"
		FROM Receitas
		WHERE (DataMovimento BETWEEN '2020-01-01' AND '2020-07-31' AND CodigoOrcamentario='1240001100')
		GROUP BY Nivel4) a20
	ON a21.Nivel4 = a20.Nivel4
	LEFT JOIN
		CodigosOrcamentarios co
	ON a21.Nivel4 = co.CodigoOrcamentario OR a20.Nivel4 = co.CodigoOrcamentario
GROUP BY co.Descricao, a21.[2021],a20.[2020]