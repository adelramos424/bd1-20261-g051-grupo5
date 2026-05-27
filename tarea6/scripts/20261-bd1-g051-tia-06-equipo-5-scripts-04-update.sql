-- 1. MERCADO
UPDATE mercado
SET nombre = 'Mercado Campesino Santa Elena'
WHERE id_mercado = 1;

-- 2. MERCADO
UPDATE mercado
SET tipo_mercado = 'Híbrido'
WHERE id_mercado = 5;

-- 3. MERCADO
UPDATE mercado
SET descripcion = 'Mercado campesino con productos apícolas y venta en línea'
WHERE nombre LIKE '%Fusagasugá%';

-- 4. PRODUCTO
UPDATE producto
SET precio = 28000
WHERE id_producto = 100;

-- 5. PRODUCTO
UPDATE producto
SET precio = 18000
WHERE id_producto = 200;

-- 6. PRODUCTO
UPDATE producto
SET precio = 32000
WHERE id_producto = 300;