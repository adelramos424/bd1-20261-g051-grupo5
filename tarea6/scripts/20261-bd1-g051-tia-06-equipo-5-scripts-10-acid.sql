-- ATOMICIDAD: BEGIN + 2 UPDATE + ROLLBACK
-- Se muestra SELECT antes y despues para verificar
-- que ningun cambio persiste tras el ROLLBACK

SELECT id_producto, tipo_producto, precio
FROM producto
WHERE id_producto IN (100, 200);

SELECT id_mercado, nombre, descripcion
FROM mercado
WHERE id_mercado IN (1, 2);

BEGIN;

UPDATE producto
SET precio = 99999.00
WHERE id_producto = 100;

UPDATE mercado
SET descripcion = 'Descripcion temporal - NO CONFIRMAR'
WHERE id_mercado = 1;

SELECT id_producto, tipo_producto, precio
FROM producto
WHERE id_producto = 100;

SELECT id_mercado, nombre, descripcion
FROM mercado
WHERE id_mercado = 1;

ROLLBACK;

SELECT id_producto, tipo_producto, precio
FROM producto
WHERE id_producto IN (100, 200);

SELECT id_mercado, nombre, descripcion
FROM mercado
WHERE id_mercado IN (1, 2);

-- CONSISTENCIA: 3 operaciones que violan restricciones
-- Cada una se ejecuta por separado y muestra el error

INSERT INTO producto (id_producto, tipo_producto, descripcion, unidad, precio)
VALUES (100, 'Miel Duplicada', 'PK duplicada - debe fallar', '1 kg', 25000.00);

UPDATE producto
SET precio = -500.00
WHERE id_producto = 200;

DELETE FROM pedido
WHERE id_pedido = 1;

-- AISLAMIENTO: Caso hipotetico (no se ejecuta)
-- Sesion A: BEGIN -> UPDATE lote -> sin COMMIT aun
-- Sesion B: SELECT lote -> ve valor ORIGINAL (MVCC)
-- Sesion A: COMMIT
-- Sesion B: SELECT lote -> ahora ve el valor actualizado
-- Conclusion: PostgreSQL aísla transacciones concurrentes

-- DURABILIDAD: BEGIN + INSERT + COMMIT
-- SELECT antes (vacio) y despues (dato persistido)

CREATE TABLE IF NOT EXISTS prueba_durabilidad (
    id      SERIAL PRIMARY KEY,
    mensaje TEXT      NOT NULL,
    fecha   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM prueba_durabilidad;

BEGIN;

INSERT INTO prueba_durabilidad (mensaje)
VALUES ('Dato registrado con COMMIT - debe persistir siempre');

SELECT * FROM prueba_durabilidad;

COMMIT;

SELECT * FROM prueba_durabilidad;