-- INSERCION de un dato JSONB en la tabla apiario

INSERT INTO apiario (id_apiario, id_apicultor, id_municipio, ubicacion, ubicacion_geografica)
VALUES (
    201,
    1,
    5,
    'Apiario Vereda La Esperanza - Medellin',
    '{
        "coordenadas": {
            "latitud": 6.28400,
            "longitud": -75.57200
        },
        "altitud_msnm": 1720,
        "region": {
            "pais": "Colombia",
            "departamento": "Antioquia",
            "municipio": "Medellin",
            "vereda": "La Esperanza"
        },
        "tipo_zona": "rural",
        "condiciones_ambientales": {
            "flora_dominante": ["eucalipto", "cafe", "aguacate"],
            "fuente_agua_cercana": true
        }
    }'
);

-- CONSULTA 1: Ver el JSON completo del apiario insertado

SELECT id_apiario, ubicacion, ubicacion_geografica
FROM apiario
WHERE id_apiario = 201;

-- CONSULTA 2: Extraer campos individuales del JSON

SELECT
    id_apiario,
    ubicacion,
    ubicacion_geografica ->> 'tipo_zona'                    AS tipo_zona,
    ubicacion_geografica ->> 'altitud_msnm'                 AS altitud_msnm,
    ubicacion_geografica -> 'coordenadas' ->> 'latitud'     AS latitud,
    ubicacion_geografica -> 'coordenadas' ->> 'longitud'    AS longitud,
    ubicacion_geografica -> 'region' ->> 'vereda'           AS vereda
FROM apiario
WHERE id_apiario = 201;

-- ACTUALIZACION de un campo dentro del JSONB
-- Se cambia la altitud usando jsonb_set

UPDATE apiario
SET ubicacion_geografica = jsonb_set(
    ubicacion_geografica,
    '{altitud_msnm}',
    '1850'
)
WHERE id_apiario = 201;

-- CONSULTA 3: Verificar que el campo se actualizo

SELECT
    id_apiario,
    ubicacion_geografica ->> 'altitud_msnm' AS altitud_actualizada
FROM apiario
WHERE id_apiario = 201;