ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT DISTINCT X.NROEMPRESA LOJA, DESCRICAO MOTIVO,
       COALESCE(M1.COMPRADOR,
       (SELECT M2.COMPRADOR FROM MAX_COMPRADOR M2 WHERE M2.SEQCOMPRADOR = (
               SELECT MAX(SEQCOMPRADOR) FROM MAP_FAMDIVISAO C WHERE C.SEQFAMILIA = (
                      SELECT SEQFAMILIA FROM MAP_PRODUTO PR WHERE PR.SEQPRODUTO = (
                             SELECT MAX(SEQPRODUTO) FROM (SELECT SEQPRODUTO FROM MLF_AUXNFITEM XX WHERE XX.SEQAUXNOTAFISCAL = X.SEQAUXNOTAFISCAL
                                                          UNION ALL
                                                          SELECT SEQPRODUTO FROM MLF_NFITEM YY WHERE YY.SEQNF = X.SEQAUXNOTAFISCAL
                                                          UNION ALL
                                                          SELECT SEQPRODUTO FROM MFL_DFITEM ZZ WHERE ZZ.SEQNF = X.SEQAUXNOTAFISCAL)))))) COMPRADOR, 
       X.SEQPESSOA||' - '||NOMERAZAO FORNECEDOR, X.SEQPRODUTO PLU, X.NUMERONF, TO_CHAR(X.DATALOG, 'DD/MM/YYYY') DTALOG
       
  FROM NAGT_INCONSISTRECEBTO_LOG X INNER JOIN GE_PESSOA G ON G.SEQPESSOA = X.SEQPESSOA
                                   LEFT JOIN  MSU_PSITEMRECEBIDO P ON P.SEQAUXNOTAFISCAL = X.SEQAUXNOTAFISCAL AND P.SEQPESSOA = X.SEQPESSOA AND P.NROEMPRESA = X.NROEMPRESA
                                   LEFT JOIN  MSU_PEDIDOSUPRIM  PS ON PS.NROPEDIDOSUPRIM = P.NROPEDIDOSUPRIM AND PS.NROEMPRESA = P.NROEMPRESA 
                                   LEFT JOIN  MAX_COMPRADOR     M1 ON M1.SEQCOMPRADOR    = PS.SEQCOMPRADOR
                                   LEFT JOIN  MAP_PRODUTO       PR ON PR.SEQPRODUTO      = X.SEQPRODUTO

 WHERE 1=1
   AND X.CODINCONSIST IN (5,6,7,8,11,12,42,139)
   AND X.TIPOINCONSIST = 'N'
   AND X.SEQAUXNFITEM  = 0
                                   
  ORDER BY X.NROEMPRESA, NUMERONF, X.SEQPRODUTO, 2 
  
