-- PREPARE: consulta con 3 parametros, 3 JOIN, WHERE y HAVING
-- $1 = nombre del departamento (TEXT)
-- $2 = fecha minima del pedido (DATE)
-- $3 = monto minimo de ventas (NUMERIC)

PREPARE consulta_ventas_departamento (TEXT, DATE, NUMERIC) AS
SELECT
    d.nombre                              AS departamento,
    m.nombre                              AS municipio,
    a.nombre                              AS productor,
    COUNT(DISTINCT p.id_pedido)           AS total_pedidos,
    SUM(dp.cantidad)                      AS unidades_vendidas,
    SUM(dp.cantidad * dp.precio_unitario) AS ingresos_cop,
    AVG(dp.precio_unitario)               AS precio_promedio_cop
FROM apicultor a
JOIN municipio      m   ON m.id_municipio    = a.id_municipio
JOIN departamento   d   ON d.id_departamento = m.id_departamento
JOIN apiario        ap  ON ap.id_apicultor   = a.id_apicultor
JOIN cosecha        c   ON c.id_apiario      = ap.id_apiario
JOIN lote           l   ON l.id_cosecha      = c.id_cosecha
JOIN detalle_pedido dp  ON dp.id_lote        = l.id_lote
JOIN pedido         p   ON p.id_pedido       = dp.id_pedido
WHERE d.nombre = $1
  AND p.fecha >= $2
GROUP BY d.nombre, m.nombre, a.id_apicultor, a.nombre
HAVING SUM(dp.cantidad * dp.precio_unitario) > $3
ORDER BY ingresos_cop DESC;

-- EJECUCION 1: Antioquia, desde enero 2025, minimo $100.000

EXECUTE consulta_ventas_departamento('Antioquia', '2025-01-01', 100000);

-- EJECUCION 2: Boyaca, desde junio 2025, minimo $50.000

EXECUTE consulta_ventas_departamento('Boyacá', '2025-06-01', 50000);

-- EJECUCION 3: Valle del Cauca, desde enero 2025, minimo $200.000

EXECUTE consulta_ventas_departamento('Valle del Cauca', '2025-01-01', 200000);

DEALLOCATE consulta_ventas_departamento;