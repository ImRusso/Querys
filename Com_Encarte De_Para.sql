
SELECT (E.SEQENCARTE) COD_ENCARTE,
       (E.DESCRICAO) DESCRICAO_ENCARTE,
       E.SEQPRODUTO PLU,
       E.DESCRICAOPRODUTO DESC_PRODUTO,
       (SUBSTR(E.EAN, 1, 200)) AS EAN,
       (E.PRECOATUAL) PRECO_ATUAL,
       (E.PRECOPROMOCIONAL) PRECO_PROMOC,
       (E.COMPRADOR) COMPRADOR,
       E.PAGINA NRO_PAG,
       NVL((P.NOMEPAGINA), 'PAGINA SEM DESC') PAGINA,
       (SUBSTR(E.LEGENDA, 1, 200)) OBS,
       (NVL((E.PRECOCARTAOPROPRIO), 0)) PRECO_CARTAO,
       NVL(PC.PRECOVALIDNORMAL, PC.PRECOBASENORMAL) PRECO_ATUAL,
       CASE
         WHEN :LS1 = 'Nagumo SP' THEN
          (SELECT PP.PRECOPROMOC
             FROM MRL_ENCARTEPRODUTOPRECO PP
            WHERE PP.SEQENCARTE = E.SEQENCARTE
              AND PP.SEQPRODUTO = E.SEQPRODUTO
              AND PP.NROAGRUPAMENTO = 2)
         WHEN :LS1 = 'Rio de Janeiro' THEN
          (SELECT PP.PRECOPROMOC
             FROM MRL_ENCARTEPRODUTOPRECO PP
            WHERE PP.SEQENCARTE = E.SEQENCARTE
              AND PP.SEQPRODUTO = E.SEQPRODUTO
              AND PP.NROAGRUPAMENTO = 3)
         WHEN :LS1 = 'Mixter' THEN
          (SELECT PP.PRECOPROMOC
             FROM MRL_ENCARTEPRODUTOPRECO PP
            WHERE PP.SEQENCARTE = E.SEQENCARTE
              AND PP.SEQPRODUTO = E.SEQPRODUTO
              AND PP.NROAGRUPAMENTO = 4)
         WHEN :LS1 = 'Hibrido' THEN
          (SELECT PP.PRECOPROMOC
             FROM MRL_ENCARTEPRODUTOPRECO PP
            WHERE PP.SEQENCARTE = E.SEQENCARTE
              AND PP.SEQPRODUTO = E.SEQPRODUTO
              AND PP.NROAGRUPAMENTO = 7)
       END PRECO_ENCARTE,
       CASE
         WHEN :LS1 = 'Nagumo SP' THEN
          (SELECT PP.PRECOCARTAO
             FROM MRL_ENCARTEPRODUTOPRECO PP
            WHERE PP.SEQENCARTE = E.SEQENCARTE
              AND PP.SEQPRODUTO = E.SEQPRODUTO
              AND PP.NROAGRUPAMENTO = 2)
         WHEN :LS1 = 'Rio de Janeiro' THEN
          (SELECT PP.PRECOCARTAO
             FROM MRL_ENCARTEPRODUTOPRECO PP
            WHERE PP.SEQENCARTE = E.SEQENCARTE
              AND PP.SEQPRODUTO = E.SEQPRODUTO
              AND PP.NROAGRUPAMENTO = 3)
       END PRECO_CARTAO

  FROM CONSINCO.NAGV_MRLV_ENCARTE E
  LEFT JOIN CONSINCO.MRL_ENCARTENOMEPAG P
    ON P.SEQENCARTE = E.SEQENCARTE
   AND P.NROPAGINA = E.PAGINA
 INNER JOIN CONSINCO.MRL_PRODEMPSEG PC
    ON PC.SEQPRODUTO = E.SEQPRODUTO
   AND PC.NROEMPRESA = DECODE(:LS1,
                              'Nagumo SP',
                              8,
                              'Mixter',
                              41,
                              'Hibrido',
                              54,
                              'Rio de Janeiro',
                              36)
   AND PC.QTDEMBALAGEM = 1
 WHERE E.SEQENCARTE = :NR1
   AND EXISTS (SELECT 1
          FROM CONSINCO.MRL_ENCARTEPRODUTO A
         WHERE A.SEQENCARTE = E.SEQENCARTE
           AND A.SEQPRODUTO = E.SEQPRODUTO
           AND A.NROPAGINA = E.PAGINA
           AND A.SEQORDEM = E.SEQORDEM)

 ORDER BY 9