-- QRP https://github.com/Giulianogms/QRPs/blob/main/RelGNREv2.QRP

SELECT NOTA,
       TO_CHAR(LOJA) EMPRESA,
       FORNECEDOR,
       MES,
       ANO,
       UF,
       DTAENTRADA,
       DTAEMISSAO,
       CODRECEITA,
       VALORRECOLHIDO,TO_CHAR(:DT1,'DD/MM/YYYY') AS INICIO,TO_CHAR(:DT2,'DD/MM/YYYY') AS FIM, 
       CASE WHEN NOTA IS NULL THEN 0 ELSE COUNT(1) END QTD, A.NROEMPRESA EMP2

FROM GE_EMPRESA A LEFT JOIN ( SELECT B.NUMERONF NOTA,
       B.NROEMPRESA LOJA,
       D.NOMERAZAO FORNECEDOR,
       A.MES MES,
       A.ANO ANO,
       A.UF UF,
       TO_CHAR(B.DTAENTRADA, 'DD/MM/YYYY') DTAENTRADA,
       TO_CHAR(B.DTAEMISSAO, 'DD/MM/YYYY') DTAEMISSAO,  
       TO_CHAR(A.CODRECEITA) CODRECEITA,
       TO_CHAR(SUM(A.VLRRECOLHIDO), 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''')  VALORRECOLHIDO
  FROM CONSINCO.MLF_GNRE A, CONSINCO.MLF_NOTAFISCAL B, CONSINCO.MAX_EMPRESA X, CONSINCO.GE_PESSOA D
 WHERE A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL
   AND B.NROEMPRESA = X.NROEMPRESA
   AND B.SEQPESSOA = D.SEQPESSOA
   AND X.NOMEREDUZIDO IN (#LS1)
   AND B.DTAENTRADA BETWEEN :DT1 AND :DT2
 GROUP BY B.NUMERONF,
       B.NROEMPRESA,
       D.NOMERAZAO,
       A.MES,
       A.ANO,
       A.UF,
       B.DTAENTRADA,
       B.DTAEMISSAO,
       A.CODRECEITA) X ON A.NROEMPRESA = X.LOJA 
WHERE A.NROEMPRESA IN (SELECT NROEMPRESA FROM GE_EMPRESA WHERE NOMEREDUZIDO IN (#LS1))
       
GROUP BY NOTA,
       A.NROEMPRESA,
       TO_CHAR(LOJA), 
       FORNECEDOR,
       MES,
       ANO,
       UF,
       DTAENTRADA,
       DTAEMISSAO,
       CODRECEITA,
       VALORRECOLHIDO,TO_CHAR(:DT1,'DD/MM/YYYY'),TO_CHAR(:DT2,'DD/MM/YYYY')

ORDER BY FORNECEDOR, NOTA; 