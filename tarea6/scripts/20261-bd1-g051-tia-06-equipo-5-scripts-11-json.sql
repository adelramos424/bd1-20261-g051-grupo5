-- 1. INSERT
INSERT INTO apiario (id_apicultor, id_municipio, ubicacion, ubicacion_geografica)
VALUES (
    1,
    5,
    'Vereda El Chuscal, Santa Barbara',
    '{
        "coordenadas": {
            "latitud": 5.8674,
            "longitud": -75.5744
        },
        "altitud_msnm": 1850,
        "region": {
            "pais": "Colombia",
            "departamento": "Antioquia",
            "municipio": "Santa Barbara",
            "vereda": "El Chuscal"
        },
        "tipo_zona": "rural",
        "condiciones_ambientales": {
            "flora_dominante": ["aguacate", "helechos", "bromelia"],
            "fuente_agua_cercana": true
        }
    }'::jsonb
);

-- 2. SELECT
SELECT id_apiario, ubicacion, ubicacion_geografica
FROM apiario
WHERE ubicacion_geografica->>'altitud_msnm' = '1850';

-- 3. UPDATE (cambiar altitud de 1850 a 1900)
UPDATE apiario
SET ubicacion_geografica = jsonb_set(
    ubicacion_geografica,
    '{altitud_msnm}',
    '1900'
)
WHERE ubicacion_geografica->>'altitud_msnm' = '1850';

-- VERIFICACION DEL UPDATE
SELECT id_apiario, ubicacion, ubicacion_geografica->>'altitud_msnm' AS altitud
FROM apiario
WHERE ubicacion_geografica->>'altitud_msnm' = '1900';