-- CASO 1: Insertar y eliminar un producto ingresado por error

INSERT INTO producto (id_producto, tipo_producto, descripcion, unidad, precio)
VALUES (700, 'Hidromiel', 'Bebida fermentada de miel - no se comercializara todavia', '750 ml', 45000.00);

SELECT id_producto, tipo_producto, precio FROM producto WHERE id_producto = 700;

DELETE FROM producto WHERE id_producto = 700;

SELECT id_producto, tipo_producto FROM producto WHERE id_producto = 700;

-- CASO 2: Insertar y eliminar un apicultor ingresado por error

INSERT INTO apicultor (id_apicultor, id_municipio, nombre, descripcion, telefono, correo, fecha_nacimiento)
VALUES (101, 1, 'Carlos Prueba Eliminar', 'Apicultor de prueba - no continuara en la red', '3199999999', 'prueba.eliminar@redapicola.co', '1990-05-15');

SELECT id_apicultor, nombre, telefono FROM apicultor WHERE id_apicultor = 101;

DELETE FROM apicultor WHERE id_apicultor = 101;

SELECT id_apicultor, nombre FROM apicultor WHERE id_apicultor = 101;