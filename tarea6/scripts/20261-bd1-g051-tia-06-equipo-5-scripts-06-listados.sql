-- 1. MUNICIPIOS
SELECT nom
FROM municipio
ORDER BY nom ASC;

-- 2. DEPARTAMENTOS CON MUNICIPIOS
SELECT dep.nom AS dep, mun.nom AS mun
FROM municipio mun
JOIN departamento dep ON mun.id_departamento = dep.id_departamento
ORDER BY dep.nom ASC, mun.nom ASC;

-- 3. MUNICIPIOS CON APICULTORES Y APIARIOS
SELECT mun.nom AS mun, api.nom AS api, ap.ubi AS apiario
FROM apiario ap
JOIN apicultor api ON ap.id_apicultor = api.id_apicultor
JOIN municipio mun ON ap.id_municipio = mun.id_municipio
ORDER BY mun.nom, api.nom;

-- 4. APICULTORES CON APIARIOS Y PRODUCTOS
SELECT api.nom AS api, ap.ubi AS apiario, pro.tip_pro AS producto
FROM apicultor api
JOIN apiario ap ON api.id_apicultor = ap.id_apicultor
JOIN apicultor_producto ap_p ON api.id_apicultor = ap_p.id_apicultor
JOIN producto pro ON ap_p.id_producto = pro.id_producto
ORDER BY api.nom, ap.ubi;

-- 5. PEDIDOS DE MEDELLÍN (id_municipio = 5)
SELECT 
    ped.id_ped AS id_ped,
    ped.fec AS fecha,
    api.nom AS pro,
    con.nom AS con,
    con.cor AS cor_con,
    pro.tip_pro AS pro,
    det.can AS can,
    det.pre_uni AS pre_uni
FROM pedido ped
JOIN consumidor con ON ped.id_consumidor = con.id_consumidor
JOIN detalle_pedido det ON ped.id_pedido = det.id_pedido
JOIN producto pro ON det.id_producto = pro.id_producto
JOIN apiario ap ON ped.id_mercado = ap.id_municipio
JOIN apicultor api ON ap.id_apicultor = api.id_apicultor
WHERE ap.id_municipio = 5
ORDER BY ped.fec DESC;