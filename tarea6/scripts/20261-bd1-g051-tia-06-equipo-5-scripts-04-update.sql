-- UPDATE 

UPDATE mercado
SET descripcion = 'Reubicado - nueva direccion: Cll 10 #5-20, Centro'
WHERE id_mercado = 1;

UPDATE mercado
SET descripcion = 'Reubicado - nueva direccion: Cra 8 #12-45, El Carmen'
WHERE id_mercado = 6;

UPDATE mercado
SET descripcion = 'Reubicado - nueva direccion: Av. 19 #32-10, Zona Industrial'
WHERE id_mercado = 11;

UPDATE producto
SET precio = 27000.00
WHERE id_producto = 100;

UPDATE producto
SET precio = 22500.00
WHERE id_producto = 200;

UPDATE producto
SET precio = 38000.00
WHERE id_producto = 300;

SELECT id_producto, tipo_producto, precio FROM producto WHERE id_producto IN (100, 200, 300);
SELECT id_mercado, nombre, descripcion FROM mercado WHERE id_mercado IN (1, 6, 11);