ALTER SESSION SET CURRENT_SCHEMA = CONSINCO; -- 01/05/22 31/08/22

SELECT /*+OPTIMIZER_FEATURES_ENABLE('11.2.0.4')*/    TO_CHAR(A.DTAENTRADASAIDA, 'DD/MM/YYYY') AS DTAENTSAIDA,
        A.NROEMPRESA,
       A.SEQPRODUTO,
       B.DESCCOMPLETA,
       (SELECT X.FANTASIA FROM GE_PESSOA X WHERE X.SEQPESSOA = (SELECT X.SEQFORNECEDOR FROM MAP_FAMFORNEC X WHERE X.SEQFAMILIA = B.SEQFAMILIA AND X.PRINCIPAL = 'S')) FORNECEDOR_PRINCIPAL,
       A.QTDLANCTO,CASE WHEN (SELECT PESAVEL FROM MAP_FAMILIA X WHERE X.SEQFAMILIA = B.SEQFAMILIA) = 'S' THEN 'KG' ELSE 'UN' END EMBALAGEM,
       TRUNC(NVL(DECODE('S',
                    'S',
                    FMRL_CUSTOULTENTRADASP(A.SEQPRODUTO,
                                           A.NROEMPRESA,
                                           'B',
                                           NULL),
                    (E.CMDIAVLRNF + E.CMDIAIPI + E.CMDIAICMSST +
                    E.CMDIADESPNF + E.CMDIADESPFORANF - E.CMDIADCTOFORANF)),
                    DECODE('S',
                    'S',
                    FMRL_CUSTOULTENTRADASP(A.SEQPRODUTOBASE,
                                           A.NROEMPRESA,
                                           'B',
                                           NULL),
                    (E.CMDIAVLRNF + E.CMDIAIPI + E.CMDIAICMSST +
                    E.CMDIADESPNF + E.CMDIADESPFORANF - E.CMDIADCTOFORANF))),
             2) AS CUSTO_UNI,
       F.LOCAL,
       DECODE(A.TIPLANCTO, 'S', 'SAIDA', 'ENTRADA') AS LANCTO,
       DECODE(D.TIPUSO,
              'I',
              DECODE(NVL(D.TIPCLASSINTERNO, 'N'),
                     'C',
                     'CONSUMO PRÓPRIO',
                     'P',
                     'PERDA OU QUEBRA',
                     'R',
                     'FURTO OU ROUBO',
                     'A',
                     'AVARIA',
                     'NORMAL'),
              NULL) AS TIPOLANCT, A.CODGERALOPER ||'-'|| D.DESCRICAO AS CGO, A.HISTORICO AS JUSTIFICATIVA,
       A.USULANCTO
  FROM MRL_LANCTOESTOQUE  A,
       MAP_PRODUTO        B,
       MAX_ATRIBUTOFIXO   C,
       MAX_CODGERALOPER   D,
       MRL_CUSTODIA       E,
       MRL_LOCAL          F,
       MRL_PRODUTOEMPRESA G
 WHERE A.SEQPRODUTO = B.SEQPRODUTO
   AND A.MOTIVOMOVTO = C.LISTA(+)
   AND D.CODGERALOPER = A.CODGERALOPER
   AND A.DTAENTRADASAIDA >= DATE '2022-05-01'
   AND A.DTAENTRADASAIDA <= DATE '2022-08-31'
   AND A.NROEMPRESA = E.NROEMPRESA
   AND A.DTAENTRADASAIDA = E.DTAENTRADASAIDA
   AND D.GERALTERACAOESTQ = 'S'
   AND (A.SEQPRODUTO = E.SEQPRODUTO OR A.SEQPRODUTOBASE = E.SEQPRODUTO)
   AND F.NROEMPRESA = A.NROEMPRESA
   AND G.NROEMPRESA = A.NROEMPRESA
   AND G.SEQPRODUTO = B.SEQPRODUTO
   AND A.LOCAL = F.SEQLOCAL
   AND F.LOCAL = 'LOJA'
   AND A.CODGERALOPER IN (SELECT CODGERALOPER FROM MAX_CODGERALOPER Z WHERE  NVL(TIPDOCFISCAL, 'X') NOT IN ('C') AND Z.GERALTERACAOESTQ = 'S')