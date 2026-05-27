-- 1. PRODUCTO
INSERT INTO producto (id_producto, tipo_producto, descripcion, unidad, precio)
VALUES (700, 'Miel de Eucalipto', 'Miel monofloral de eucalipto con propiedades medicinales', '500 g', 22000);

-- 2. PRODUCTO
DELETE FROM producto
WHERE id_producto = 700;

-- 3. APICULTOR
INSERT INTO apicultor (id_municipio, nombre, descripcion, telefono, correo, fecha_nacimiento)
VALUES (5, 'Ricardo Perez', 'Apicultor nuevo en la red', '3112345678', 'ricardo.perez@apicola.co', '1985-06-15');

-- 4. APICULTOR
DELETE FROM apicultor
WHERE id_apicultor = (SELECT id_apicultor FROM apicultor WHERE correo = 'ricardo.perez@apicola.co');