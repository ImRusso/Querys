ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT DISTINCT NOTA, SERIE, LOJA, PARCELA, CODIGO, RAZAO, CNPJ, DESCRICAO_DESPESA, 
       EMISSAO, ENTRADA, VENCIMENTO, TO_CHAR(VALOR, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALOR
       
  FROM (
  
SELECT A.NRONOTA NOTA,
       A.SERIE SERIE,
       A.NROEMPRESA LOJA,
       B.NROPARCELA PARCELA,
       A.SEQPESSOA CODIGO,
       D.NOMERAZAO RAZAO,
       LPAD(D.NROCGCCPF, 11, 0) || LPAD(D.DIGCGCCPF, 2, 0) CNPJ,
       A.CODHISTORICO COD_DESPESA,
      (SELECT XI.DESCRICAO FROM ABA_HISTORICO XI WHERE XI.SEQHISTORICO = A.CODHISTORICO) DESCRICAO_DESPESA,
       TO_CHAR(A.DTAEMISSAO,'DD-MM-YYYY') EMISSAO,
       TO_CHAR(A.DTAENTRADA,'DD-MM-YYYY') ENTRADA,
       TO_CHAR(B.DTAVENCTO,'DD-MM-YYYY') VENCIMENTO,
       C.VLRLANCAMENTO VALOR,
       (SELECT T.DESCRICAO FROM ABA_PLANOCONTA T INNER JOIN ABA_PLANOCONTACONFEMPRESA W ON (T.SEQPLANOCONTACONF = W.SEQPLANOCONTACONF ) 
                 WHERE C.CONTACREDITO = T.CONTA AND C.NROEMPRESA = W.NROEMPRESA) CREDITO,
        (SELECT T.DESCRICAO FROM ABA_PLANOCONTA T INNER JOIN ABA_PLANOCONTACONFEMPRESA W ON (T.SEQPLANOCONTACONF = W.SEQPLANOCONTACONF ) 
                 WHERE C.CONTADEBITO = T.CONTA AND C.NROEMPRESA = W.NROEMPRESA) DEBITO,
       C.CENTROCUSTODB C_RESULTADO,
        (SELECT X.DESCRICAO FROM ABA_CENTRORESULTADO X WHERE LPAD(X.CODREDUZIDO,6,0) = LPAD(C.CENTROCUSTODB,6,0)) C_RESULTADO_DESCRICAO
           FROM OR_NFDESPESA A INNER JOIN OR_NFVENCIMENTO B  ON (A.SEQNOTA = B.SEQNOTA) INNER JOIN OR_NFPLANILHALANCTO C  ON (A.SEQNOTA = C.SEQNOTA)
                                                                                        INNER JOIN GE_PESSOA D  ON (A.SEQPESSOA = D.SEQPESSOA)
 WHERE C.VLRLANCAMENTO <> 0
   AND A.DTAENTRADA > DATE '2024-01-01'
 ORDER BY 2 DESC
  
 ) WHERE C_RESULTADO_DESCRICAO LIKE '%_GUA%' AND LOJA = :LS1 ORDER BY VENCIMENTO DESC 