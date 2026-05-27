-- PREPARE: ANALISIS DE VENTAS POR PRODUCTOR
PREPARE ana_ven_pro(DATE, NUMERIC, NUMERIC) AS
SELECT 
    api.nom AS pro,
    COUNT(DISTINCT ped.id_pedido) AS tot_ped,
    SUM(det.can * det.pre_uni) AS tot_ven
FROM pedido ped
JOIN detalle_pedido det ON ped.id_pedido = det.id_pedido
JOIN consumidor con ON ped.id_consumidor = con.id_consumidor
JOIN apiario ap ON ped.id_mercado = ap.id_municipio
JOIN apicultor api ON ap.id_apicultor = api.id_apicultor
WHERE ped.fec >= $1
  AND (det.can * det.pre_uni) >= $2
GROUP BY api.nom
HAVING SUM(det.can * det.pre_uni) >= $3
ORDER BY tot_ven DESC;

-- EJECUTAR: Productores con pedidos desde enero 2025, pedido mínimo $5000, ventas totales mínimas $100000
EXECUTE ana_ven_pro('2025-01-01', 5000, 100000);

-- EJECUTAR: Productores con pedidos desde marzo 2025, pedido mínimo $10000, ventas totales mínimas $200000
EXECUTE ana_ven_pro('2025-03-01', 10000, 200000);

-- EJECUTAR: Productores con pedidos desde junio 2025, pedido mínimo $20000, ventas totales mínimas $50000
EXECUTE ana_ven_pro('2025-06-01', 20000, 50000);