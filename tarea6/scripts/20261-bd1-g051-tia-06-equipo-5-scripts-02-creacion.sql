CREATE TABLE departamento (
    id_departamento SERIAL PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE comunidad (
    id_comunidad   SERIAL PRIMARY KEY,
    nombre         VARCHAR(50)  NOT NULL,
    descripcion    TEXT         NULL,
    fecha_creacion DATE         NOT NULL
);

CREATE TABLE sensor (
    id_sensor   SERIAL PRIMARY KEY,
    tipo_sensor VARCHAR(50) NOT NULL
);

CREATE TABLE entidad_financiera (
    id_entidad_financiera SERIAL PRIMARY KEY,
    nombre                VARCHAR(100) NOT NULL,
    tipo_entidad          VARCHAR(100) NOT NULL,
    telefono              VARCHAR(15)  NOT NULL UNIQUE,
    correo                VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE entidad_reguladora (
    id_entidad_reguladora SERIAL PRIMARY KEY,
    nombre                VARCHAR(100) NOT NULL,
    pais                  VARCHAR(100) NOT NULL,
    telefono              VARCHAR(15)  NOT NULL UNIQUE,
    correo                VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE cooperativa (
    id_cooperativa SERIAL PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    direccion      VARCHAR(100) NOT NULL,
    telefono       VARCHAR(15)  NOT NULL UNIQUE,
    fecha_creacion DATE         NOT NULL
);

CREATE TABLE intercambio (
    id_intercambio     SERIAL PRIMARY KEY,
    fecha              DATE        NOT NULL,
    descripcion        TEXT        NULL,
    estado_intercambio VARCHAR(30) NULL,
    lugar              VARCHAR(100) NULL,
    CONSTRAINT chk_intercambio_estado CHECK (estado_intercambio IN ('pendiente', 'completado', 'cancelado'))
);

CREATE TABLE producto (
    id_producto   INT          PRIMARY KEY,
    tipo_producto VARCHAR(50)  NOT NULL,
    descripcion   TEXT         NULL,
    unidad        VARCHAR(50)  NOT NULL,
    precio        DECIMAL(10,2) NOT NULL CHECK (precio >= 0)
);

CREATE TABLE municipio (
    id_municipio    SERIAL PRIMARY KEY,
    id_departamento INT          NOT NULL,
    nombre          VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);

CREATE TABLE certificacion (
    id_certificacion      SERIAL PRIMARY KEY,
    id_entidad_reguladora INT          NOT NULL,
    descripcion           TEXT         NULL,
    fecha_emision         DATE         NULL,
    fecha_vencimiento     DATE         NULL,
    tipo_certificacion    VARCHAR(100) NULL,
    FOREIGN KEY (id_entidad_reguladora) REFERENCES entidad_reguladora(id_entidad_reguladora)
);

CREATE TABLE investigacion (
    id_investigacion      SERIAL PRIMARY KEY,
    id_entidad_financiera INT          NOT NULL,
    titulo                VARCHAR(100) NOT NULL,
    descripcion           TEXT         NULL,
    fecha                 DATE         NOT NULL,
    FOREIGN KEY (id_entidad_financiera) REFERENCES entidad_financiera(id_entidad_financiera)
);

CREATE TABLE detalle_intercambio (
    id_detalle_intercambio SERIAL PRIMARY KEY,
    id_intercambio         INT         NOT NULL,
    producto               VARCHAR(50) NOT NULL,
    cantidad               INT         NOT NULL CHECK (cantidad > 0),
    FOREIGN KEY (id_intercambio) REFERENCES intercambio(id_intercambio)
);

CREATE TABLE cooperativa_financiera (
    id_cooperativa        INT NOT NULL,
    id_entidad_financiera INT NOT NULL,
    PRIMARY KEY (id_cooperativa, id_entidad_financiera),
    FOREIGN KEY (id_cooperativa)        REFERENCES cooperativa(id_cooperativa),
    FOREIGN KEY (id_entidad_financiera) REFERENCES entidad_financiera(id_entidad_financiera)
);

CREATE TABLE apicultor (
    id_apicultor     SERIAL PRIMARY KEY,
    id_municipio     INT         NOT NULL,
    nombre           VARCHAR(80) NOT NULL,
    descripcion      TEXT        NULL,
    telefono         VARCHAR(20) NOT NULL UNIQUE,
    correo           VARCHAR(100) NOT NULL UNIQUE,
    fecha_nacimiento DATE        NULL,
    FOREIGN KEY (id_municipio) REFERENCES municipio(id_municipio)
);

CREATE TABLE consumidor (
    id_consumidor SERIAL PRIMARY KEY,
    id_municipio  INT          NOT NULL,
    nombre        VARCHAR(80)  NOT NULL,
    correo        VARCHAR(100) NOT NULL UNIQUE,
    telefono      VARCHAR(15)  NOT NULL UNIQUE,
    direccion     VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_municipio) REFERENCES municipio(id_municipio)
);

CREATE TABLE mercado (
    id_mercado   SERIAL PRIMARY KEY,
    id_municipio INT          NOT NULL UNIQUE,
    nombre       VARCHAR(100) NOT NULL,
    descripcion  TEXT         NULL,
    tipo_mercado VARCHAR(30)  NULL,
    CONSTRAINT chk_mercado_tipo CHECK (tipo_mercado IN ('Físico', 'Virtual', 'Híbrido')),
    FOREIGN KEY (id_municipio) REFERENCES municipio(id_municipio)
);

CREATE TABLE evento (
    id_evento        SERIAL PRIMARY KEY,
    id_investigacion INT         NOT NULL,
    nombre           VARCHAR(100) NOT NULL,
    fecha            DATE         NOT NULL,
    ubicacion        VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_investigacion) REFERENCES investigacion(id_investigacion)
);

CREATE TABLE historial_sensor (
    id_registro    SERIAL PRIMARY KEY,
    id_sensor      INT            NOT NULL,
    valor          DECIMAL(12,2)  NOT NULL,
    fecha_hora     TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    descripcion    TEXT           NULL,
    unidad_medida  VARCHAR(50)    NULL,
    codigo_sensor  VARCHAR(20)    UNIQUE,
    fecha_inicio   DATE           NULL,
    duracion_horas INT            NULL,
    CONSTRAINT chk_duracion CHECK (duracion_horas >= 0),
    CONSTRAINT chk_valor    CHECK (valor BETWEEN 0 AND 100),
    FOREIGN KEY (id_sensor) REFERENCES sensor(id_sensor)
);

CREATE TABLE apiario (
    id_apiario           SERIAL PRIMARY KEY,
    id_apicultor         INT          NOT NULL,
    id_municipio         INT          NOT NULL,
    ubicacion            VARCHAR(100) NOT NULL,
    ubicacion_geografica JSONB        NULL,
    FOREIGN KEY (id_apicultor) REFERENCES apicultor(id_apicultor),
    FOREIGN KEY (id_municipio) REFERENCES municipio(id_municipio)
);

CREATE TABLE gestion (
    id_gestion    SERIAL PRIMARY KEY,
    id_apicultor  INT         NOT NULL,
    descripcion   TEXT        NULL,
    fecha         DATE        NOT NULL,
    estado_gestion VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_apicultor) REFERENCES apicultor(id_apicultor)
);

CREATE TABLE empleo (
    id_empleo         SERIAL PRIMARY KEY,
    id_apicultor      INT          NOT NULL,
    titulo            VARCHAR(100) NOT NULL,
    descripcion       TEXT         NULL,
    fecha_publicacion DATE         NOT NULL,
    FOREIGN KEY (id_apicultor) REFERENCES apicultor(id_apicultor)
);

CREATE TABLE apicultor_intercambio (
    id_apicultor   INT NOT NULL,
    id_intercambio INT NOT NULL,
    PRIMARY KEY (id_apicultor, id_intercambio),
    FOREIGN KEY (id_apicultor)   REFERENCES apicultor(id_apicultor),
    FOREIGN KEY (id_intercambio) REFERENCES intercambio(id_intercambio)
);

CREATE TABLE apicultor_comunidad (
    id_apicultor INT NOT NULL,
    id_comunidad INT NOT NULL,
    PRIMARY KEY (id_apicultor, id_comunidad),
    FOREIGN KEY (id_apicultor) REFERENCES apicultor(id_apicultor),
    FOREIGN KEY (id_comunidad) REFERENCES comunidad(id_comunidad)
);

CREATE TABLE apicultor_cooperativa (
    id_apicultor   INT  NOT NULL,
    id_cooperativa INT  NOT NULL,
    fecha_ingreso  DATE NOT NULL,
    PRIMARY KEY (id_apicultor, id_cooperativa),
    FOREIGN KEY (id_apicultor)   REFERENCES apicultor(id_apicultor),
    FOREIGN KEY (id_cooperativa) REFERENCES cooperativa(id_cooperativa)
);

CREATE TABLE evento_apicultor (
    id_evento    INT NOT NULL,
    id_apicultor INT NOT NULL,
    PRIMARY KEY (id_evento, id_apicultor),
    FOREIGN KEY (id_evento)    REFERENCES evento(id_evento),
    FOREIGN KEY (id_apicultor) REFERENCES apicultor(id_apicultor)
);

CREATE TABLE pedido (
    id_pedido     SERIAL PRIMARY KEY,
    id_consumidor INT  NOT NULL,
    id_mercado    INT  NOT NULL,
    fecha         DATE NOT NULL,
    FOREIGN KEY (id_consumidor) REFERENCES consumidor(id_consumidor),
    FOREIGN KEY (id_mercado)    REFERENCES mercado(id_mercado)
);

CREATE TABLE cosecha (
    id_cosecha SERIAL PRIMARY KEY,
    id_apiario INT  NOT NULL,
    fecha      DATE NOT NULL,
    FOREIGN KEY (id_apiario) REFERENCES apiario(id_apiario)
);

CREATE TABLE registro_clinico (
    id_registro   SERIAL PRIMARY KEY,
    id_apiario    INT  NOT NULL,
    descripcion   TEXT NULL,
    fecha_registro DATE NULL,
    tratamiento   TEXT NULL,
    FOREIGN KEY (id_apiario) REFERENCES apiario(id_apiario)
);

CREATE TABLE medicion_ambiental (
    id_medicion     SERIAL PRIMARY KEY,
    id_sensor       INT           NOT NULL,
    id_apiario      INT           NOT NULL,
    temperatura     DECIMAL(5,2)  NOT NULL,
    humedad         DECIMAL(5,2)  NOT NULL,
    fecha_hora      TIMESTAMP     NOT NULL,
    datos_ambientales JSONB       NULL,
    FOREIGN KEY (id_sensor)  REFERENCES sensor(id_sensor),
    FOREIGN KEY (id_apiario) REFERENCES apiario(id_apiario)
);

CREATE TABLE lote (
    id_lote           SERIAL PRIMARY KEY,
    id_cosecha        INT           NOT NULL,
    cantidad          INT           NOT NULL CHECK (cantidad > 0),
    fecha_produccion  DATE          NOT NULL,
    costo_produccion  DECIMAL(10,2) NOT NULL DEFAULT 0.00 CHECK (costo_produccion >= 0),
    FOREIGN KEY (id_cosecha) REFERENCES cosecha(id_cosecha)
);

CREATE TABLE alerta (
    id_alerta   SERIAL PRIMARY KEY,
    id_medicion INT         NOT NULL,
    tipo_alerta VARCHAR(30) NOT NULL,
    mensaje     TEXT        NOT NULL,
    fecha       TIMESTAMP   NOT NULL,
    estado      VARCHAR(30) NOT NULL,
    CONSTRAINT chk_alerta_tipo   CHECK (tipo_alerta IN ('temperatura_alta', 'temperatura_baja', 'humedad_alta', 'humedad_baja')),
    CONSTRAINT chk_alerta_estado CHECK (estado IN ('activa', 'resuelta')),
    FOREIGN KEY (id_medicion) REFERENCES medicion_ambiental(id_medicion)
);

CREATE TABLE lote_producto (
    id_lote     INT NOT NULL,
    id_producto INT NOT NULL,
    PRIMARY KEY (id_lote, id_producto),
    FOREIGN KEY (id_lote)     REFERENCES lote(id_lote),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE detalle_pedido (
    id_detalle      SERIAL        PRIMARY KEY,
    id_pedido       INT           NOT NULL,
    id_lote         INT           NOT NULL,
    id_producto     INT           NOT NULL,
    cantidad        INT           NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
    FOREIGN KEY (id_pedido)   REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_lote)     REFERENCES lote(id_lote),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);