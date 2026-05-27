-- 1. AGRUPAR PRODUCTORES POR DEPARTAMENTO Y MUNICIPIO
SELECT dep.nom AS dep, mun.nom AS mun, COUNT(api.id_apicultor) AS tot_pro
FROM apicultor api
JOIN municipio mun ON api.id_municipio = mun.id_municipio
JOIN departamento dep ON mun.id_departamento = dep.id_departamento
GROUP BY dep.nom, mun.nom
ORDER BY dep.nom, mun.nom;

-- 2. AGRUPAR CONSUMIDORES POR DEPARTAMENTO Y MUNICIPIO
SELECT dep.nom AS dep, mun.nom AS mun, COUNT(con.id_consumidor) AS tot_con
FROM consumidor con
JOIN municipio mun ON con.id_municipio = mun.id_municipio
JOIN departamento dep ON mun.id_departamento = dep.id_departamento
GROUP BY dep.nom, mun.nom
ORDER BY dep.nom, mun.nom;

-- 3. AGRUPAR PRODUCTORES DE UN DEPARTAMENTO POR MUNICIPIO Y APIARIOS
SELECT mun.nom AS mun, api.nom AS api, COUNT(ap.id_apiario) AS tot_api
FROM apiario ap
JOIN apicultor api ON ap.id_apicultor = api.id_apicultor
JOIN municipio mun ON ap.id_municipio = mun.id_municipio
WHERE mun.id_departamento = 1
GROUP BY mun.nom, api.nom
ORDER BY mun.nom, tot_api DESC;

-- 4. AGRUPAR PEDIDOS DE UN DEPARTAMENTO POR MUNICIPIO Y APIARIO
SELECT mun.nom AS mun, api.nom AS api, SUM(det.can * det.pre_uni) AS tot_cop
FROM pedido ped
JOIN detalle_pedido det ON ped.id_pedido = det.id_pedido
JOIN consumidor con ON ped.id_consumidor = con.id_consumidor
JOIN municipio mun ON con.id_municipio = mun.id_municipio
JOIN apiario ap ON ped.id_mercado = ap.id_municipio
JOIN apicultor api ON ap.id_apicultor = api.id_apicultor
WHERE mun.id_departamento = 1
GROUP BY mun.nom, api.nom
HAVING SUM(det.can * det.pre_uni) > 100000
ORDER BY tot_cop DESC;

-- 5. AGRUPAR PRODUCTOS PEDIDOS POR DEPARTAMENTO Y MUNICIPIO
SELECT dep.nom AS dep, mun.nom AS mun, pro.tip_pro AS pro, SUM(det.can) AS tot_ped
FROM detalle_pedido det
JOIN pedido ped ON det.id_pedido = ped.id_pedido
JOIN consumidor con ON ped.id_consumidor = con.id_consumidor
JOIN municipio mun ON con.id_municipio = mun.id_municipio
JOIN departamento dep ON mun.id_departamento = dep.id_departamento
JOIN producto pro ON det.id_producto = pro.id_producto
GROUP BY dep.nom, mun.nom, pro.tip_pro
ORDER BY tot_ped DESC;

--Adicionales

-- 1. PRODUCTOR QUE MÁS RECIBIÓ PEDIDOS
SELECT api.nom AS pro, COUNT(ped.id_pedido) AS tot_ped
FROM pedido ped
JOIN detalle_pedido det ON ped.id_pedido = det.id_pedido
JOIN apiario ap ON ped.id_mercado = ap.id_municipio
JOIN apicultor api ON ap.id_apicultor = api.id_apicultor
GROUP BY api.nom
ORDER BY tot_ped DESC
LIMIT 1;

-- 2. DEPARTAMENTO CON MÁS Y MENOS PEDIDOS
SELECT dep.nom AS dep, COUNT(ped.id_pedido) AS tot_ped
FROM pedido ped
JOIN consumidor con ON ped.id_consumidor = con.id_consumidor
JOIN municipio mun ON con.id_municipio = mun.id_municipio
JOIN departamento dep ON mun.id_departamento = dep.id_departamento
GROUP BY dep.nom
ORDER BY tot_ped DESC;

-- 3. PRODUCTO QUE RECIBIÓ MENOS PEDIDOS
SELECT pro.tip_pro AS pro, SUM(det.can) AS tot_ped
FROM detalle_pedido det
JOIN producto pro ON det.id_producto = pro.id_producto
GROUP BY pro.tip_pro
ORDER BY tot_ped ASC
LIMIT 1;

-- 4. MUNICIPIO CON MAYOR MONTO (COP) DE PEDIDOS
SELECT mun.nom AS mun, SUM(det.can * det.pre_uni) AS tot_cop
FROM detalle_pedido det
JOIN pedido ped ON det.id_pedido = ped.id_pedido
JOIN consumidor con ON ped.id_consumidor = con.id_consumidor
JOIN municipio mun ON con.id_municipio = mun.id_municipio
GROUP BY mun.nom
ORDER BY tot_cop DESC
LIMIT 1;