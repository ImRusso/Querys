SELECT X.SEQPRODUTO COD_NAGUMO, Z.CODACESSO COD_REF_FORNEC, DESCCOMPLETA, FA.CODNBMSH COD_NCM
  FROM MAP_PRODUTO X INNER JOIN MAP_PRODCODIGO Z ON X.SEQPRODUTO = Z.SEQPRODUTO
                     INNER JOIN MAP_FAMILIA FA   ON FA.SEQFAMILIA = X.SEQFAMILIA
       AND Z.TIPCODIGO = 'F'
       AND EXISTS (SELECT 1
          FROM MAP_FAMFORNEC F
         WHERE SEQFORNECEDOR = 2653529
               AND F.SEQFAMILIA = X.SEQFAMILIA)

ORDER BY DESCCOMPLETA
