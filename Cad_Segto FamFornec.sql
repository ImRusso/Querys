ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT X.SEQFAMILIA COD_FAM, FAMILIA, X.NROSEGFORNEC NRO_SEGFORNEC, DESCRICAO DESC_SEGFORNEC

  FROM MAP_FAMFORNEC X INNER JOIN MAP_FAMILIA F ON X.SEQFAMILIA = F.SEQFAMILIA
                       INNER JOIN MAF_SEGTOFORNEC S ON S.NROSEGFORNEC = X.NROSEGFORNEC
                       
 WHERE 1=1 
 
 ORDER BY 2