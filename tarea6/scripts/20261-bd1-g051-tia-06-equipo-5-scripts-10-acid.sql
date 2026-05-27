-- 1. ATOMICIDAD
-- ANTES
SELECT id_apicultor, nombre, telefono FROM apicultor WHERE id_apicultor = 1;
SELECT id_mercado, nombre, tipo_mercado FROM mercado WHERE id_mercado = 1;

BEGIN;
    UPDATE apicultor SET telefono = '3119999999' WHERE id_apicultor = 1;
    UPDATE mercado SET tipo_mercado = 'Virtual' WHERE id_mercado = 1;
ROLLBACK;

-- DESPUES
SELECT id_apicultor, nombre, telefono FROM apicultor WHERE id_apicultor = 1;
SELECT id_mercado, nombre, tipo_mercado FROM mercado WHERE id_mercado = 1;


-- 2. CONSISTENCIA
-- INSERT (PK duplicada)
INSERT INTO producto (id_producto, tipo_producto, descripcion, unidad, precio)
VALUES (100, 'Miel duplicada', 'Error', '1 kg', 25000);

-- UPDATE (CHECK constraint violado)
UPDATE producto SET precio = -5000 WHERE id_producto = 100;

-- DELETE (FK constraint - eliminar cabecera sin detalle)
DELETE FROM pedido WHERE id_pedido = 1;


-- 3. AISLAMIENTO
-- CASO HIPOTETICO: 
-- SESION A: BEGIN; UPDATE apicultor SET nombre = 'Nuevo Nombre' WHERE id_apicultor = 1;
-- SESION B: SELECT nombre FROM apicultor WHERE id_apicultor = 1;
-- SESION B seguira viendo el nombre original hasta que SESION A haga COMMIT


-- 4. DURABILIDAD
-- ANTES
SELECT id_apicultor, nombre, telefono FROM apicultor WHERE id_apicultor = 2;

BEGIN;
    UPDATE apicultor SET telefono = '3228888888' WHERE id_apicultor = 2;
COMMIT;

-- DESPUES
SELECT id_apicultor, nombre, telefono FROM apicultor WHERE id_apicultor = 2;