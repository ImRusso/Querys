SELECT DISTINCT X.SEQGERCOMPRA NROLOTE,
       TO_CHAR(X.DTAHORINCLUSAO, 'DD/MM/YYYY') DTA_INCLUSAO,
       TO_CHAR(DTAGERPEDIDO, 'DD/MM/YYYY') DTA_FATURAMENTO,
       X.USUINCLUSAO, 
       COMPRADOR,
       FO.SEQFORNECEDOR||' - '||NOMERAZAO FORNEC,
       XI.NROEMPRESA EMP_DESTINO, XI.SEQPRODUTO PLU,
       NVL(NULLIF(QTDPEDIDA,0), XI.QTDTRANSF) QUANTIDADE_UNI,
       CASE WHEN X.TIPOLOTE = 'T' THEN ROUND(SUM(SR.VLRUNITARIO * CASE WHEN QTDPEDIDA > 0 THEN QTDPEDIDA ELSE XI.QTDTRANSF END) OVER (PARTITION BY X.SEQGERCOMPRA),2) ELSE
       ROUND(SUM(TFVLRCUSTOBRUTO * CASE WHEN QTDPEDIDA > 0 THEN QTDPEDIDA ELSE XI.QTDTRANSF END) OVER (PARTITION BY X.SEQGERCOMPRA),2) END VALOR_TOT_LOTE,
       CASE WHEN X.TIPOLOTE = 'T' THEN ROUND(SUM(SR.VLRUNITARIO * CASE WHEN QTDPEDIDA > 0 THEN QTDPEDIDA ELSE XI.QTDTRANSF END) OVER (PARTITION BY S.NROPEDIDOSUPRIM),2) ELSE
       ROUND(SUM(TFVLRCUSTOBRUTO * CASE WHEN QTDPEDIDA > 0 THEN QTDPEDIDA ELSE XI.QTDTRANSF END) OVER (PARTITION BY SR.NROPEDIDOSUPRIM, XI.NROEMPRESA),2) END VALOR_TOT_PED_EMP,
       CASE WHEN X.TIPOLOTE = 'T' THEN ROUND(SR.VLRUNITARIO,2) ELSE
       ROUND(TFVLRCUSTOBRUTO,2) END VALOR_ITEM_UNITARIO,
       CASE WHEN X.TIPOLOTE = 'T' THEN ROUND(SR.VLRUNITARIO * CASE WHEN QTDPEDIDA > 0 THEN QTDPEDIDA ELSE XI.QTDTRANSF END,2) ELSE
       ROUND(TFVLRCUSTOBRUTO * NVL(NULLIF(QTDPEDIDA,0), XI.QTDTRANSF),2) END VALOR_ITEM_TOTAL,
       TO_CHAR(F.DTAHORLANCTO, 'DD/MM/YYYY') DTA_ENTREGA,
       
       DECODE(X.TIPOLOTE, 'B', 'Bonif. Incidência Custo',
                          'E', 'Bonif. Sem Incid. Custo',
                          'C', 'Compra',
                          'F', 'Cotação',
                          'M', 'Modelo de Compra',
                          'O', 'Modelo de Cotação',
                          'T', 'Transferência Interna',
                          'A', 'Abastecimento Automatico') TIPO_LOTE,
                          
       CASE WHEN NVL(NULLIF(QTDPEDIDA,0), XI.QTDTRANSF) = 0 THEN NULL ELSE S.NROPEDIDOSUPRIM END  NRO_PEDIDO
         
  FROM CONSINCO.MAC_GERCOMPRA X INNER JOIN CONSINCO.MAC_GERCOMPRAITEM XI ON X.SEQGERCOMPRA = XI.SEQGERCOMPRA
                       INNER JOIN MAC_GERCOMPRAFORN FO ON FO.SEQGERCOMPRA = X.SEQGERCOMPRA
                       INNER JOIN GE_PESSOA GE ON GE.SEQPESSOA = FO.SEQFORNECEDOR
                       INNER JOIN CONSINCO.MAP_PRODUTO P ON P.SEQPRODUTO = XI.SEQPRODUTO
                       LEFT JOIN CONSINCO.MSU_PEDIDOSUPRIM S ON S.SEQGERCOMPRA = X.SEQGERCOMPRA AND S.NROEMPRESA = XI.NROEMPRESA
                       LEFT JOIN CONSINCO.MSU_PSITEMRECEBIDO SI ON SI.NROPEDIDOSUPRIM = S.NROPEDIDOSUPRIM AND SI.NROEMPRESA = S.NROEMPRESA AND SI.SEQPRODUTO = XI.SEQPRODUTO AND QTDCANCELADA = 0
                       LEFT JOIN CONSINCO.MSU_PSITEMRECEBER  SR ON SR.NROPEDIDOSUPRIM = S.NROPEDIDOSUPRIM AND SR.NROEMPRESA = S.NROEMPRESA AND SR.SEQPRODUTO = XI.SEQPRODUTO
                       LEFT JOIN MLF_NOTAFISCAL F ON F.SEQAUXNOTAFISCAL = SI.SEQAUXNOTAFISCAL
                       
INNER JOIN MAX_COMPRADOR CC ON CC.SEQCOMPRADOR = X.SEQCOMPRADOR
 WHERE 1=1
   AND XI.SITUACAOITEM != 'C'
   AND X.DTAHORINCLUSAO BETWEEN :DT1 AND :DT2
   AND COMPRADOR IN (#LS1)
   AND NVL(NULLIF(QTDPEDIDA,0), XI.QTDTRANSF) > 0

ORDER BY 1, XI.NROEMPRESA