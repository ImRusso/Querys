SELECT * FROM ( 

SELECT X.NROEMPRESA LOJA,
       X.CNPJ_EMP CNPJ,
       X.DTAENTRADA,
       X.DTAVENCIMENTO,
       X.NRONOTA NF,
       X.NOMERAZAO RAZAO,
       X.COD_NAT_REND COD_REND,
       TO_CHAR(X.VALOR_NF_COMISSAO, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALOR_NF,
       TO_CHAR(X.VALOR_PARC, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALOR_PARC,
       TO_CHAR(CASE WHEN TO_DATE(VENC_IRRF, 'DD/MM/YYYY') BETWEEN :DT1 AND :DT2 THEN X.IRRF       ELSE NULL END, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') IR,
       CASE WHEN TO_DATE(VENC_IRRF, 'DD/MM/YYYY') BETWEEN :DT1 AND :DT2 THEN X.VENC_IRRF  ELSE NULL END VENC_IR,
       TO_CHAR(CASE WHEN TO_DATE(VENC_PCC,  'DD/MM/YYYY') BETWEEN :DT1 AND :DT2 THEN X.TOTAL_PCC  ELSE NULL END, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') PCC,
       CASE WHEN TO_DATE(VENC_PCC,  'DD/MM/YYYY') BETWEEN :DT1 AND :DT2 THEN X.VENC_PCC   ELSE NULL END VENC_PCC

FROM CONSINCO.NAGV_ITWORKS_REINF_IR_PCC X

 WHERE (TO_DATE(VENC_IRRF, 'DD/MM/YYYY') BETWEEN :DT1 AND :DT2 OR  TO_DATE(VENC_PCC, 'DD/MM/YYYY') BETWEEN :DT1 AND :DT2)
   AND LPAD(NROEMPRESA,3,0) IN (#LS1) 
   AND LPAD(NROEMPRESA,3,0) IN (SELECT NROEMPRESA FROM CONSINCO.GE_EMPRESA X WHERE X.MATRIZ IN (#LS2))
   
ORDER BY 1,4)

  UNION ALL

SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL FROM DUAL

  UNION ALL

SELECT NULL, NULL, NULL, NULL, NULL, 'TOTAL', NULL, 
       TO_CHAR(SUM(VALOR_NF),   'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.'''),
       TO_CHAR(SUM(VALOR_PARC), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.'''),
       TO_CHAR(SUM(IR),         'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.'''), NULL, 
       TO_CHAR(SUM(PCC),        'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.'''), NULL 
  FROM ( 
SELECT SUM(X.VALOR_NF_COMISSAO) VALOR_NF,
       SUM(X.VALOR_PARC) VALOR_PARC, 
       CASE WHEN TO_DATE(VENC_IRRF, 'DD/MM/YYYY') BETWEEN :DT1 AND :DT2 THEN SUM(X.IRRF)       ELSE NULL END IR, 
       CASE WHEN TO_DATE(VENC_PCC,  'DD/MM/YYYY') BETWEEN :DT1 AND :DT2 THEN SUM(X.TOTAL_PCC)  ELSE NULL END PCC

FROM CONSINCO.NAGV_ITWORKS_REINF_IR_PCC X

 WHERE (TO_DATE(VENC_IRRF, 'DD/MM/YYYY') BETWEEN :DT1 AND :DT2 OR  TO_DATE(VENC_PCC, 'DD/MM/YYYY') BETWEEN :DT1 AND :DT2)
   AND LPAD(NROEMPRESA,3,0) IN (#LS1) 
   AND LPAD(NROEMPRESA,3,0) IN (SELECT NROEMPRESA FROM CONSINCO.GE_EMPRESA X WHERE X.MATRIZ IN (#LS2))
   
   GROUP BY TO_DATE(VENC_IRRF, 'DD/MM/YYYY'), TO_DATE(VENC_PCC,  'DD/MM/YYYY'))
  