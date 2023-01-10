USE SQLWEEKRECIFE
GO


SELECT COUNT(1) TOTAL 
FROM dbo.TB_CANDIDATO

-----------------------------------------------------------------------------

SELECT CD_CARGO, COUNT(1) TOTAL 
FROM dbo.TB_CANDIDATO
GROUP BY CD_CARGO
ORDER BY 1

