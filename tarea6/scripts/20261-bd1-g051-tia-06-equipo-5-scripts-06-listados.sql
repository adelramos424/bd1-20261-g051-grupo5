-- CONSULTA 1: Municipios en orden alfabetico (sin JOIN)

SELECT id_municipio, nombre
FROM municipio
ORDER BY nombre ASC;

-- CONSULTA 2: Departamentos con sus municipios (1 JOIN)

SELECT
    d.nombre AS departamento,
    m.nombre AS municipio
FROM departamento d
JOIN municipio m ON m.id_departamento = d.id_departamento
ORDER BY d.nombre ASC, m.nombre ASC;

-- CONSULTA 3: Municipios con sus apicultores y apiarios (2 JOIN)

SELECT
    m.nombre     AS municipio,
    a.nombre     AS apicultor,
    ap.ubicacion AS apiario
FROM municipio m
JOIN apicultor a  ON a.id_municipio  = m.id_municipio
JOIN apiario   ap ON ap.id_apicultor = a.id_apicultor
ORDER BY m.nombre ASC, a.nombre ASC;

-- CONSULTA 4: Apicultores con sus apiarios y productos (3 JOIN)

SELECT
    a.nombre        AS apicultor,
    ap.ubicacion    AS apiario,
    p.tipo_producto AS producto,
    p.precio        AS precio_cop
FROM apicultor a
JOIN apiario       ap ON ap.id_apicultor = a.id_apicultor
JOIN cosecha       c  ON c.id_apiario    = ap.id_apiario
JOIN lote          l  ON l.id_cosecha    = c.id_cosecha
JOIN lote_producto lp ON lp.id_lote      = l.id_lote
JOIN producto      p  ON p.id_producto   = lp.id_producto
ORDER BY a.nombre ASC, p.tipo_producto ASC;

-- CONSULTA 5: Pedidos del municipio Medellin (Santa Elena) con productor y consumidor (3 JOIN)

SELECT
    p.id_pedido,
    p.fecha              AS fecha_pedido,
    cons.id_consumidor,
    cons.nombre          AS consumidor,
    ap.id_apicultor      AS id_productor,
    ap.nombre            AS productor,
    pr.tipo_producto     AS producto,
    dp.cantidad,
    dp.precio_unitario   AS precio_venta_cop
FROM pedido p
JOIN consumidor     cons ON cons.id_consumidor = p.id_consumidor
JOIN mercado        mer  ON mer.id_mercado     = p.id_mercado
JOIN detalle_pedido dp   ON dp.id_pedido       = p.id_pedido
JOIN lote           l    ON l.id_lote          = dp.id_lote
JOIN cosecha        c    ON c.id_cosecha       = l.id_cosecha
JOIN apiario        api  ON api.id_apiario     = c.id_apiario
JOIN apicultor      ap   ON ap.id_apicultor    = api.id_apicultor
JOIN producto       pr   ON pr.id_producto     = dp.id_producto
WHERE mer.id_municipio = 5
ORDER BY p.fecha DESC;