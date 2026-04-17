--
-- Scripts de Modificación de la Base de Datos - SGBD PostgreSQL
-- Todas las instrucciones se deben realizar en secuencia sin errores
-- Probar los scripts en detalle
--

--
-- Modificación de la Base de Datos
-- 


--
-- 1.- DATOS SEMI-ESTRUCTURADOS PARA DATOS IOT (Sensores)
-- Gestionar el campo "datos_ambientales" en cualquier tabla que considere adecuada o
-- Si es necesario, crear una nueva
-- 1.- "agregar" un campo tipo JSON o JSONB
-- 2.- Agregar un par de registros
-- 3.- Consultar la información agregada
-- 4.- Describir el campo y explicar su propósito
--

-- 1.0 Insertar un sensor de prueba (para evitar error de FOREIGN KEY)
INSERT INTO sensor (tipo_sensor) VALUES ('sensor_iot_temperatura_humedad');

-- 1.1 Agregar campo tipo JSONB a la tabla medicion_ambiental
ALTER TABLE medicion_ambiental ADD COLUMN datos_ambientales JSONB;

-- 1.2 Agregar un par de registros
INSERT INTO medicion_ambiental (id_sensor, temperatura, humedad, fecha_hora, datos_ambientales)
VALUES (
    1, 
    28.5, 
    72.0, 
    CURRENT_TIMESTAMP,
    '{
        "temperatura_externa": 26.2,
        "humedad_suelo": 45,
        "velocidad_viento_kmh": 12.3,
        "presion_atmosferica_hpa": 1013,
        "alertas": ["viento_moderado"]
    }'
);

INSERT INTO medicion_ambiental (id_sensor, temperatura, humedad, fecha_hora, datos_ambientales)
VALUES (
    1, 
    30.2, 
    68.5, 
    CURRENT_TIMESTAMP,
    '{
        "temperatura_externa": 32.1,
        "humedad_suelo": 38,
        "velocidad_viento_kmh": 8.7,
        "presion_atmosferica_hpa": 1010,
        "alertas": ["temperatura_alta"]
    }'
);

-- 1.3 Consultar la información agregada
SELECT 
    id_medicion, 
    temperatura, 
    humedad, 
    fecha_hora,
    datos_ambientales->>'temperatura_externa' AS temperatura_externa,
    datos_ambientales->>'velocidad_viento_kmh' AS velocidad_viento,
    datos_ambientales->'alertas' AS alertas
FROM medicion_ambiental
WHERE datos_ambientales IS NOT NULL;

-- 1.4 Describir el campo y explicar su propósito
-- Campo: datos_ambientales (tipo JSONB) en tabla medicion_ambiental
-- Propósito: Almacenar datos variables de sensores IoT que pueden cambiar con el tiempo.
--            Permite registrar temperatura externa, humedad del suelo, velocidad del viento,
--            presión atmosférica y alertas sin modificar la estructura de la tabla.
-- Por qué JSONB: Es más rápido para consultas que JSON y permite indexar.


--
-- 2.- DATOS SEMI-ESTRUCTURADOS (PARA BIG DATA o IOT)
-- Gestionar un nuevo campo "nombre_campo" (de su propia creación) en cualquier tabla (de las existentes) que considere adecuada
-- 1.- "agregar" un campo tipo JSON o JSONB
-- 2.- Agregar un par de registros de información
-- 3.- Consultar la información agregada
-- 4.- Describir el campo y explicar su propósito
--

-- 2.0 Insertar un apicultor de prueba (para evitar error de FOREIGN KEY en apiario)
INSERT INTO apicultor (nombre, telefono, correo) 
VALUES ('Apicultor Prueba', '3001234567', 'prueba@apicola.com')
ON CONFLICT (correo) DO NOTHING;

-- 2.1 Agregar campo tipo JSONB a la tabla apiario (nombre_campo = ubicacion_geografica)
ALTER TABLE apiario ADD COLUMN ubicacion_geografica JSONB;

-- 2.2 Agregar un par de registros de información
INSERT INTO apiario (id_apicultor, ubicacion, ubicacion_geografica)
VALUES (
    (SELECT id_apicultor FROM apicultor LIMIT 1),
    'Vereda Santa Elena, Medellín',
    '{
        "coordenadas": {
            "latitud": 6.25184,
            "longitud": -75.56359
        },
        "altitud_msnm": 1550,
        "region": {
            "pais": "Colombia",
            "departamento": "Antioquia",
            "municipio": "Medellin",
            "vereda": "Santa Elena"
        },
        "tipo_zona": "rural",
        "condiciones_ambientales": {
            "flora_dominante": ["eucalipto", "cafe"],
            "fuente_agua_cercana": true
        }
    }'
);

INSERT INTO apiario (id_apicultor, ubicacion, ubicacion_geografica)
VALUES (
    (SELECT id_apicultor FROM apicultor LIMIT 1),
    'Usme, Bogotá',
    '{
        "coordenadas": {
            "latitud": 4.7110,
            "longitud": -74.0721
        },
        "altitud_msnm": 2600,
        "region": {
            "pais": "Colombia",
            "departamento": "Cundinamarca",
            "municipio": "Bogota",
            "vereda": "Usme"
        },
        "tipo_zona": "periurbana",
        "condiciones_ambientales": {
            "flora_dominante": ["pino", "acacia"],
            "fuente_agua_cercana": false
        }
    }'
);

-- 2.3 Consultar la información agregada
SELECT 
    id_apiario,
    ubicacion,
    ubicacion_geografica->'coordenadas'->>'latitud' AS latitud,
    ubicacion_geografica->'coordenadas'->>'longitud' AS longitud,
    ubicacion_geografica->'region'->>'departamento' AS departamento,
    ubicacion_geografica->>'tipo_zona' AS tipo_zona,
    ubicacion_geografica->'condiciones_ambientales'->>'fuente_agua_cercana' AS fuente_agua
FROM apiario
WHERE ubicacion_geografica IS NOT NULL;

-- 2.4 Describir el campo y explicar su propósito
-- Campo: ubicacion_geografica (tipo JSONB) en tabla apiario
-- Propósito: Almacenar información geográfica jerárquica y variable de cada apiario.
--            Incluye coordenadas, altitud, región (país, departamento, municipio, vereda),
--            tipo de zona y condiciones ambientales (flora dominante, fuentes de agua).
-- Por qué JSONB: La ubicación no es solo latitud/longitud. Puede incluir información anidada
--                y características variables. JSONB permite esta flexibilidad sin necesidad
--                de múltiples tablas o columnas. Es ideal para Big Data e IoT porque los
--                datos pueden variar entre diferentes apiarios sin modificar el esquema.