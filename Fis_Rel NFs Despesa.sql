SELECT A.NROEMPRESA EMPRESA, A.NRONOTA, C.NROPARCELA, 
       SUBSTR(B.NOMERAZAO, 0,35) NOMERAZAO, 
       LPAD(B.NROCGCCPF,12,0)||LPAD(B.DIGCGCCPF,2,0) CNPJ,
       TO_CHAR(A.DTAEMISSAO,'DD/MM/YYYY') EMISSAO, 
       TO_CHAR(A.DTAENTRADA,'DD/MM/YYYY') ENTRADA,  
       TO_CHAR(C.DTAVENCTO, 'DD/MM/YYYY') VENCIMENTO, 
       TO_CHAR(C.VALOR, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALOR,
       TO_CHAR((SELECT SUM(C.VALOR) 
        FROM CONSINCO.OR_NFDESPESA A INNER JOIN CONSINCO.GE_PESSOA       B ON A.SEQPESSOA = B.SEQPESSOA
                                     INNER JOIN CONSINCO.OR_NFVENCIMENTO C ON A.SEQNOTA = C.SEQNOTA
                             
       WHERE A.DTAENTRADA BETWEEN :DT1 AND :DT2
       AND A.CODHISTORICO = :NR1
       AND A.NROEMPRESA IN (#LS1)), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALOR_TOTAL,
        TO_CHAR(:DT1, 'DD/MM/YYYY') DT1,TO_CHAR(:DT2, 'DD/MM/YYYY') DT2, A.CODHISTORICO COD_NAT

FROM CONSINCO.OR_NFDESPESA A INNER JOIN CONSINCO.GE_PESSOA       B ON A.SEQPESSOA = B.SEQPESSOA
                             INNER JOIN CONSINCO.OR_NFVENCIMENTO C ON A.SEQNOTA = C.SEQNOTA
                             
WHERE A.DTAENTRADA BETWEEN :DT1 AND :DT2
  AND A.CODHISTORICO = :NR1
  AND A.NROEMPRESA IN (#LS1)