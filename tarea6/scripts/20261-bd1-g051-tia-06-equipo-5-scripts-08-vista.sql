-- VISTA: RESUMEN DE VENTAS POR PRODUCTOR
CREATE OR REPLACE VIEW vw_ven_pro AS
SELECT 
    api.nom AS pro,
    mun.nom AS mun,
    COUNT(DISTINCT ped.id_pedido) AS tot_ped,
    SUM(det.can * det.pre_uni) AS tot_ven
FROM pedido ped
JOIN detalle_pedido det ON ped.id_pedido = det.id_pedido
JOIN consumidor con ON ped.id_consumidor = con.id_consumidor
JOIN municipio mun ON con.id_municipio = mun.id_municipio
JOIN apiario ap ON ped.id_mercado = ap.id_municipio
JOIN apicultor api ON ap.id_apicultor = api.id_apicultor
WHERE ped.fec >= '2025-01-01'
GROUP BY api.nom, mun.nom
HAVING SUM(det.can * det.pre_uni) > 50000
ORDER BY tot_ven DESC;

SELECT * FROM vw_ven_pro;