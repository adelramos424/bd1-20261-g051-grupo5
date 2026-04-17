--
-- Modificación de la Base de Datos
-- 

--
-- 1.1.- Agregar un campo a la tabla de "productor" de la red apicola
--

ALTER TABLE apicultor ADD COLUMN fecha_nacimiento DATE;

--
-- 1.2.- Modificar un campo de la tabla de "productor"
--

ALTER TABLE apicultor ALTER COLUMN telefono TYPE VARCHAR(20);

--
-- Gestionar una tabla "nueva"
-- 1.- "agregar" una nueva tabla a la base de datos que tenga relación con el sistema
-- 2.- Darle un nombre "coherente"
-- 3.- Agregar campos coherentes con la tabla
-- 4.- Realizar todas las operaciones que se solicitan a continuación
--

--
-- 1.3.1
-- Crear una tabla "nueva" de su iniciativa (una tabla coherente con el sistema con su nombre, no coloque "nueva" como nombre)
--

CREATE TABLE registro_sensor (
    id_registro SERIAL PRIMARY KEY,
    id_sensor INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--
-- 1.3.2
-- Agregar una clave primaria y otros 3 campos cualquiera a la tabla "nueva"
-- Mínimo un campo tipo texto y uno numérico
--

ALTER TABLE registro_sensor ADD COLUMN descripcion TEXT;
ALTER TABLE registro_sensor ADD COLUMN umbral_minimo DECIMAL(10,2);
ALTER TABLE registro_sensor ADD COLUMN unidad_medida VARCHAR(20);

--
-- 1.3.3
-- Quitar uno de los campos de la tabla "nueva"
--

ALTER TABLE registro_sensor DROP COLUMN umbral_minimo;

--
-- 1.3.4
-- Cambiar el nombre de la tabla "nueva" a otro nombre "otro_nombre"
-- Todas las operaciones siguientes se realizan sobre la tabla renombrada
--

ALTER TABLE registro_sensor RENAME TO historial_sensor;

--
-- 1.3.5 
-- Agregar un campo único a la tabla 
--

ALTER TABLE historial_sensor ADD COLUMN codigo_sensor VARCHAR(20) UNIQUE;

--
-- 1.3.6
-- Agregar 2 fechas de inicio y fin; y colocar un control de orden de fechas
--

ALTER TABLE historial_sensor ADD COLUMN fecha_inicio DATE;
ALTER TABLE historial_sensor ADD COLUMN fecha_fin DATE;
ALTER TABLE historial_sensor ADD CONSTRAINT chk_fechas CHECK (fecha_inicio <= fecha_fin);

--
-- 1.3.7
-- Agregar 1 campo entero y colocar un control para que no sea negativo
--

ALTER TABLE historial_sensor ADD COLUMN duracion_horas INT;
ALTER TABLE historial_sensor ADD CONSTRAINT chk_duracion CHECK (duracion_horas >= 0);

--
-- 1.3.8
-- Modificar el tamaño de un campo texto de la tabla renombra
--

ALTER TABLE historial_sensor ALTER COLUMN unidad_medida TYPE VARCHAR(50);

--
-- 1.3.7
-- Modificar el campo numeríco y colocar un control de rango 
--

ALTER TABLE historial_sensor ALTER COLUMN valor TYPE DECIMAL(12,2);
ALTER TABLE historial_sensor ADD CONSTRAINT chk_valor CHECK (valor BETWEEN 0 AND 100);

--
-- 1.3.8
-- Agregar un índice a la tabla (cualquier campo)
--

CREATE INDEX idx_historial_fecha ON historial_sensor(fecha_hora);

--
-- 1.3.9 
-- Eliminar una de las fechas
--

ALTER TABLE historial_sensor DROP COLUMN fecha_fin;