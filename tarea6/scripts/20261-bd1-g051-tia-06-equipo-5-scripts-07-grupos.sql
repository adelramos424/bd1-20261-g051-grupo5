-- CONSULTA 1: Productores agrupados por departamento y municipio

SELECT
    d.nombre              AS departamento,
    m.nombre              AS municipio,
    COUNT(a.id_apicultor) AS total_productores
FROM departamento d
JOIN municipio m ON m.id_departamento = d.id_departamento
JOIN apicultor a ON a.id_municipio    = m.id_municipio
GROUP BY d.nombre, m.nombre
ORDER BY d.nombre ASC, m.nombre ASC;

-- CONSULTA 2: Consumidores agrupados por departamento y municipio

SELECT
    d.nombre              AS departamento,
    m.nombre              AS municipio,
    COUNT(c.id_consumidor) AS total_consumidores
FROM departamento d
JOIN municipio  m ON m.id_departamento = d.id_departamento
JOIN consumidor c ON c.id_municipio    = m.id_municipio
GROUP BY d.nombre, m.nombre
ORDER BY d.nombre ASC, m.nombre ASC;

-- CONSULTA 3: Productores de Antioquia por municipio y apiarios

SELECT
    m.nombre             AS municipio,
    a.nombre             AS productor,
    COUNT(ap.id_apiario) AS total_apiarios
FROM departamento d
JOIN municipio m  ON m.id_departamento = d.id_departamento
JOIN apicultor a  ON a.id_municipio    = m.id_municipio
JOIN apiario   ap ON ap.id_apicultor   = a.id_apicultor
WHERE d.nombre = 'Antioquia'
GROUP BY m.nombre, a.id_apicultor, a.nombre
ORDER BY m.nombre ASC, total_apiarios DESC;

-- CONSULTA 4: Pedidos de Antioquia por municipio y apiario
--             con total en COP y HAVING

SELECT
    m.nombre                              AS municipio,
    ap.ubicacion                          AS apiario,
    COUNT(DISTINCT p.id_pedido)           AS total_pedidos,
    SUM(dp.cantidad * dp.precio_unitario) AS total_cop,
    AVG(dp.precio_unitario)               AS precio_promedio_cop
FROM departamento d
JOIN municipio      m   ON m.id_departamento = d.id_departamento
JOIN mercado        mer ON mer.id_municipio  = m.id_municipio
JOIN pedido         p   ON p.id_mercado      = mer.id_mercado
JOIN detalle_pedido dp  ON dp.id_pedido      = p.id_pedido
JOIN lote           l   ON l.id_lote         = dp.id_lote
JOIN cosecha        c   ON c.id_cosecha      = l.id_cosecha
JOIN apiario        ap  ON ap.id_apiario     = c.id_apiario
WHERE d.nombre = 'Antioquia'
GROUP BY m.nombre, ap.id_apiario, ap.ubicacion
HAVING SUM(dp.cantidad * dp.precio_unitario) > 500000
ORDER BY total_cop DESC;

-- CONSULTA 5: Productos pedidos en todos los departamentos
--             de mayor a menor cantidad

SELECT
    pr.tipo_producto          AS producto,
    d.nombre                  AS departamento,
    m.nombre                  AS municipio,
    COUNT(dp.id_detalle)      AS veces_pedido,
    SUM(dp.cantidad)          AS unidades_totales
FROM producto pr
JOIN detalle_pedido dp  ON dp.id_producto    = pr.id_producto
JOIN pedido         p   ON p.id_pedido       = dp.id_pedido
JOIN mercado        mer ON mer.id_mercado    = p.id_mercado
JOIN municipio      m   ON m.id_municipio   = mer.id_municipio
JOIN departamento   d   ON d.id_departamento = m.id_departamento
GROUP BY pr.id_producto, pr.tipo_producto, d.nombre, m.nombre
ORDER BY veces_pedido DESC;

-- PREGUNTA: Productor que mas recibio pedidos

SELECT
    a.nombre                      AS productor,
    COUNT(DISTINCT p.id_pedido)   AS total_pedidos
FROM apicultor a
JOIN apiario        ap ON ap.id_apicultor = a.id_apicultor
JOIN cosecha        c  ON c.id_apiario    = ap.id_apiario
JOIN lote           l  ON l.id_cosecha    = c.id_cosecha
JOIN detalle_pedido dp ON dp.id_lote      = l.id_lote
JOIN pedido         p  ON p.id_pedido     = dp.id_pedido
GROUP BY a.id_apicultor, a.nombre
ORDER BY total_pedidos DESC
LIMIT 1;

-- PREGUNTA: Departamento con mas y menos pedidos

SELECT
    d.nombre                      AS departamento,
    COUNT(DISTINCT p.id_pedido)   AS total_pedidos
FROM departamento d
JOIN municipio m   ON m.id_departamento = d.id_departamento
JOIN mercado   mer ON mer.id_municipio  = m.id_municipio
JOIN pedido    p   ON p.id_mercado      = mer.id_mercado
GROUP BY d.nombre
ORDER BY total_pedidos DESC;

-- PREGUNTA: Producto con menos pedidos

SELECT
    pr.tipo_producto          AS producto,
    COUNT(dp.id_detalle)      AS veces_pedido
FROM producto pr
LEFT JOIN detalle_pedido dp ON dp.id_producto = pr.id_producto
GROUP BY pr.id_producto, pr.tipo_producto
ORDER BY veces_pedido ASC
LIMIT 1;

-- PREGUNTA: Municipio con mayor monto en COP

SELECT
    m.nombre                              AS municipio,
    d.nombre                              AS departamento,
    SUM(dp.cantidad * dp.precio_unitario) AS total_cop
FROM municipio m
JOIN departamento   d   ON d.id_departamento = m.id_departamento
JOIN mercado        mer ON mer.id_municipio  = m.id_municipio
JOIN pedido         p   ON p.id_mercado      = mer.id_mercado
JOIN detalle_pedido dp  ON dp.id_pedido      = p.id_pedido
GROUP BY m.nombre, d.nombre
ORDER BY total_cop DESC
LIMIT 1;