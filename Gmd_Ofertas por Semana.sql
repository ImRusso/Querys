-- Marcio S | Ofertas QS

ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT 'TOTAL' EMP, 'Mes: '||06||' - Ano: 2024' Periodo,

                   ROUND(AVG(NAGF_BUSCAQTDITENSPROMOC_SM(06,2024,EMP.NROEMPRESA,1))) PRIM_SEMANA,
                   ROUND(AVG(NAGF_BUSCAQTDITENSPROMOC_SM(06,2024,EMP.NROEMPRESA,2))) SEG_SEMANA,
                   ROUND(AVG(NAGF_BUSCAQTDITENSPROMOC_SM(06,2024,EMP.NROEMPRESA,3))) TER_SEMANA,
                   ROUND(AVG(NAGF_BUSCAQTDITENSPROMOC_SM(06,2024,EMP.NROEMPRESA,4))) QUAR_SEMANA
                   
  FROM MAX_EMPRESA EMP WHERE NROEMPRESA < 100

UNION ALL

SELECT 'TOTAL' EMP, 'Mes: '||07||' - Ano: 2024' Periodo,

                   ROUND(AVG(NAGF_BUSCAQTDITENSPROMOC_SM(07,2024,EMP.NROEMPRESA,1))) PRIM_SEMANA,
                   ROUND(AVG(NAGF_BUSCAQTDITENSPROMOC_SM(07,2024,EMP.NROEMPRESA,2))) SEG_SEMANA,
                   ROUND(AVG(NAGF_BUSCAQTDITENSPROMOC_SM(07,2024,EMP.NROEMPRESA,3))) TER_SEMANA,
                   ROUND(AVG(NAGF_BUSCAQTDITENSPROMOC_SM(07,2024,EMP.NROEMPRESA,4))) QUAR_SEMANA
                   
  FROM MAX_EMPRESA EMP WHERE NROEMPRESA < 100
  
-- Abaixo é por Loja
  
UNION ALL

SELECT NULL, NULL, NULL, NULL, NULL, NULL FROM DUAL

UNION ALL


SELECT TO_CHAR(NROEMPRESA), 'Mes: '||07||' - Ano: 2024' Periodo,

                   NAGF_BUSCAQTDITENSPROMOC_SM(07,2024,EMP.NROEMPRESA,1) PRIM_SEMANA,
                   NAGF_BUSCAQTDITENSPROMOC_SM(07,2024,EMP.NROEMPRESA,2) SEG_SEMANA,
                   NAGF_BUSCAQTDITENSPROMOC_SM(07,2024,EMP.NROEMPRESA,3) TER_SEMANA,
                   NAGF_BUSCAQTDITENSPROMOC_SM(07,2024,EMP.NROEMPRESA,4) QUAR_SEMANA
                   
  FROM MAX_EMPRESA EMP WHERE NROEMPRESA < 100
  
  