ALTER SESSION SET current_schema = CONSINCO;

-- Solic Demian

SELECT A.NROEMPRESA, G.FANTASIA, SUM(A.VVLRCTOLIQUIDO) CUSTO, SUM(A.VLROPERACAO) VENDA
  FROM FATOG_VENDADIA@CONSINCODW A INNER JOIN CONSINCO.GE_EMPRESA G ON A.NROEMPRESA = G.NROEMPRESA
  
 WHERE TRUNC(DTAOPERACAO) = '23-JAN-2023'
 AND A.NROEMPRESA < 300
 AND A.CODGERALOPER IN (37,48,123,610,615,613,810,916,910,911) -- Apenas CGOs de VENDA

GROUP BY A.NROEMPRESA, G.FANTASIA
ORDER BY A.NROEMPRESA 