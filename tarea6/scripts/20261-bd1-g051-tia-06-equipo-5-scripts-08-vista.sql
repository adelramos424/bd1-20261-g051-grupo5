-- CREACION DE LA VISTA
-- 3 JOIN + WHERE + HAVING + funciones de agregacion

CREATE OR REPLACE VIEW vista_ventas_productor AS
SELECT
    d.nombre                              AS departamento,
    m.nombre                              AS municipio,
    a.id_apicultor,
    a.nombre                              AS productor,
    COUNT(DISTINCT p.id_pedido)           AS total_pedidos,
    SUM(dp.cantidad)                      AS unidades_vendidas,
    SUM(dp.cantidad * dp.precio_unitario) AS ingresos_cop,
    AVG(dp.precio_unitario)               AS precio_promedio_cop,
    MIN(dp.precio_unitario)               AS precio_min_cop,
    MAX(dp.precio_unitario)               AS precio_max_cop
FROM apicultor a
JOIN municipio      m   ON m.id_municipio    = a.id_municipio
JOIN departamento   d   ON d.id_departamento = m.id_departamento
JOIN apiario        ap  ON ap.id_apicultor   = a.id_apicultor
JOIN cosecha        c   ON c.id_apiario      = ap.id_apiario
JOIN lote           l   ON l.id_cosecha      = c.id_cosecha
JOIN detalle_pedido dp  ON dp.id_lote        = l.id_lote
JOIN pedido         p   ON p.id_pedido       = dp.id_pedido
WHERE p.fecha >= '2025-01-01'
GROUP BY d.nombre, m.nombre, a.id_apicultor, a.nombre
HAVING SUM(dp.cantidad * dp.precio_unitario) > 0
ORDER BY ingresos_cop DESC;

-- USO 1: Consultar toda la vista

SELECT * FROM vista_ventas_productor;

-- USO 2: Filtrar la vista por departamento

SELECT *
FROM vista_ventas_productor
WHERE departamento = 'Antioquia'
ORDER BY ingresos_cop DESC;

-- USO 3: Agrupar la vista por departamento con totales

SELECT
    departamento,
    COUNT(id_apicultor)    AS total_productores,
    SUM(total_pedidos)     AS total_pedidos,
    SUM(ingresos_cop)      AS ingresos_totales_cop,
    AVG(precio_promedio_cop) AS precio_promedio_general
FROM vista_ventas_productor
GROUP BY departamento
ORDER BY ingresos_totales_cop DESC;