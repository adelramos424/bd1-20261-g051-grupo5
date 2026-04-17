CREATE TABLE apicultor (
	id_apicultor INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	descripcion VARCHAR(MAX) NULL,
	telefono VARCHAR(15) NOT NULL UNIQUE,
	correo VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE apiario (
	id_apiario INT IDENTITY(1,1) PRIMARY KEY,
	id_apicultor INT NOT NULL,
	ubicacion VARCHAR(50) NOT NULL
	FOREIGN KEY (id_apicultor) REFERENCES apicultor(id_apicultor)
);

CREATE TABLE producto (
	id_producto INT IDENTITY(1,1) PRIMARY KEY,
	tipo_producto VARCHAR(50) NOT NULL,
	descripcion VARCHAR(MAX) NULL
);

CREATE TABLE cosecha (
	id_cosecha INT IDENTITY(1,1) PRIMARY KEY,
	id_apiario INT NOT NULL,
	fecha DATE NOT NULL
	FOREIGN KEY (id_apiario) REFERENCES apiario(id_apiario)
);

CREATE TABLE lote (
	id_lote INT IDENTITY(1,1) PRIMARY KEY,
	id_cosecha  INT NOT NULL,
	cantidad INT NOT NULL,
	fecha_produccion DATE NOT NULL
	FOREIGN KEY (id_cosecha) REFERENCES cosecha(id_cosecha)
);

CREATE TABLE consumidor (
	id_consumidor INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(80) NOT NULL,
	correo VARCHAR(100) NOT NULL UNIQUE,
	telefono VARCHAR(15) NOT NULL UNIQUE,
	direccion VARCHAR(100) NOT NULL
);

CREATE TABLE comunidad (
    id_comunidad INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(MAX) NULL,
    fecha_creacion DATE NOT NULL
);

CREATE TABLE pedido (
	id_pedido INT IDENTITY(1,1) PRIMARY KEY,
	id_consumidor INT NOT NULL,
	fecha DATE NOT NULL,
	FOREIGN KEY (id_consumidor) REFERENCES consumidor(id_consumidor)
);

CREATE TABLE detalle_pedido (
	id_pedido INT NOT NULL,
	id_lote INT NOT NULL,
	cantidad INT NOT NULL,
	PRIMARY KEY (id_pedido, id_lote),
	FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
	FOREIGN KEY (id_lote) REFERENCES lote(id_lote)
);

CREATE TABLE sensor (
	id_sensor INT IDENTITY(1,1) PRIMARY KEY,
	tipo_sensor VARCHAR(50) NOT NULL
);

CREATE TABLE medicion_ambiental (
	id_medicion INT IDENTITY(1,1) PRIMARY KEY,
	id_sensor INT NOT NULL,
	temperatura DECIMAL(5,2) NOT NULL,
	humedad DECIMAL(5,2) NOT NULL,
	fecha_hora DATETIME NOT NULL,
	FOREIGN KEY (id_sensor) REFERENCES sensor(id_sensor) 
);

CREATE table alerta (
	id_alerta INT IDENTITY(1,1) PRIMARY KEY,
	id_medicion INT NOT NULL,
	tipo_alerta VARCHAR(30) NOT NULL,
	mensaje VARCHAR(MAX) NOT NULL,
	fecha DATETIME NOT NULL,
	estado VARCHAR(30) NOT NULL,
	CONSTRAINT CHK_alerta_tipo CHECK (tipo_alerta IN ('temperatura_alta', 'temperatura_baja', 'humedad_alta', 'humedad_baja')),
	CONSTRAINT CHK_alerta_estado CHECK (estado IN ('activa', 'resuelta'))
);

CREATE TABLE entidad_financiera (
    	id_entidad_financiera INT IDENTITY(1,1) PRIMARY KEY,
    	nombre VARCHAR(100) NOT NULL,
    	tipo_entidad VARCHAR(100) NOT NULL,
    	telefono VARCHAR(15) NOT NULL UNIQUE,
    	correo VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE entidad_reguladora (
    	id_entidad_reguladora INT IDENTITY(1,1) PRIMARY KEY,
    	nombre VARCHAR(100) NOT NULL,
    	pais VARCHAR(100) NOT NULL,
    	telefono VARCHAR(15) NOT NULL UNIQUE,
    	correo VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE cooperativa (
    	id_cooperativa INT IDENTITY(1,1) PRIMARY KEY,
    	nombre VARCHAR(100) NOT NULL,
    	direccion VARCHAR(100) NOT NULL,
    	telefono VARCHAR(15) NOT NULL UNIQUE,
    	fecha_creacion DATE NOT NULL
);

CREATE TABLE certificacion (
    	id_certificacion INT IDENTITY(1,1) PRIMARY KEY,
    	id_entidad_reguladora INT NOT NULL,
    	descripcion VARCHAR(MAX) NULL,
    	fecha_emision DATE NULL,
    	fecha_vencimiento DATE NULL,
    	tipo_certificacion VARCHAR(100) NULL,
    	FOREIGN KEY (id_entidad_reguladora) REFERENCES entidad_reguladora(id_entidad_reguladora)
);

CREATE TABLE registro_clinico (
    	id_registro INT IDENTITY(1,1) PRIMARY KEY,
    	id_apiario INT NOT NULL,
    	descripcion VARCHAR(MAX) NULL,
    	fecha_registro DATE NULL,
    	tratamiento VARCHAR(MAX) NULL,
    	FOREIGN KEY (id_apiario) REFERENCES apiario(id_apiario)
);

CREATE TABLE intercambio (
    	id_intercambio INT IDENTITY(1,1) PRIMARY KEY,
    	fecha DATE NOT NULL,
    	descripcion VARCHAR(MAX) NULL,
    	estado_intercambio VARCHAR(30) NULL,
    	lugar VARCHAR(100) NULL,
    	CONSTRAINT CHK_intercambio_estado CHECK (estado_intercambio IN ('pendiente', 'completado', 'cancelado'))
);

CREATE TABLE detalle_intercambio (
    	id_detalle_intercambio INT IDENTITY(1,1) PRIMARY KEY,
    	id_intercambio INT NOT NULL,
    	producto VARCHAR(50) NOT NULL,
    	cantidad INT NOT NULL,
    	FOREIGN KEY (id_intercambio) REFERENCES intercambio(id_intercambio)
);

CREATE TABLE mercado (
    	id_mercado INT IDENTITY(1,1) PRIMARY KEY,
    	nombre VARCHAR(100) NOT NULL,
    	descripcion VARCHAR(MAX) NULL,
    	tipo_mercado VARCHAR(100) NULL
);

CREATE TABLE gestion (
   	id_gestion INT IDENTITY(1,1) PRIMARY KEY,
    	id_apicultor INT NOT NULL,
    	descripcion VARCHAR(MAX) NULL,
    	fecha DATE NOT NULL,
    	estado_gestion VARCHAR(50) NOT NULL,
    	FOREIGN KEY (id_apicultor) REFERENCES apicultor(id_apicultor)
);

CREATE TABLE empleo (
    	id_empleo INT IDENTITY(1,1) PRIMARY KEY,
    	id_apicultor INT NOT NULL,
    	titulo VARCHAR(100) NOT NULL,
    	descripcion VARCHAR(MAX) NULL,
    	fecha_publicacion DATE NOT NULL,
    	FOREIGN KEY (id_apicultor) REFERENCES apicultor(id_apicultor)
);

CREATE TABLE investigacion (
    	id_investigacion INT IDENTITY(1,1) PRIMARY KEY,
    	id_entidad_financiera INT NOT NULL,
    	titulo VARCHAR(100) NOT NULL,
    	descripcion VARCHAR(MAX) NULL,
    	fecha DATE NOT NULL,
    	FOREIGN KEY (id_entidad_financiera) REFERENCES entidad_financiera(id_entidad_financiera)
);

CREATE TABLE evento (
    	id_evento INT IDENTITY(1,1) PRIMARY KEY,
    	id_investigacion INT NOT NULL,
    	nombre VARCHAR(50) NOT NULL,
    	fecha DATE NOT NULL,
    	ubicacion VARCHAR(50) NOT NULL,
    	FOREIGN KEY (id_investigacion) REFERENCES investigacion(id_investigacion)
);

CREATE TABLE apicultor_intercambio (
    	id_apicultor INT NOT NULL,
    	id_intercambio INT NOT NULL,
    	PRIMARY KEY (id_apicultor, id_intercambio),
    	FOREIGN KEY (id_apicultor) REFERENCES apicultor(id_apicultor),
    	FOREIGN KEY (id_intercambio) REFERENCES intercambio(id_intercambio)
);

CREATE TABLE apicultor_comunidad (
    	id_apicultor INT NOT NULL,
    	id_comunidad INT NOT NULL,
    	PRIMARY KEY (id_apicultor, id_comunidad),
    	FOREIGN KEY (id_apicultor) REFERENCES apicultor(id_apicultor),
    	FOREIGN KEY (id_comunidad) REFERENCES comunidad(id_comunidad)
);

CREATE TABLE evento_apicultor (
    	id_evento INT NOT NULL,
    	id_apicultor INT NOT NULL,
    	PRIMARY KEY (id_evento, id_apicultor),
    	FOREIGN KEY (id_evento) REFERENCES evento(id_evento),
    	FOREIGN KEY (id_apicultor) REFERENCES apicultor(id_apicultor)
);

CREATE TABLE cooperativa_financiera (
    	id_cooperativa INT NOT NULL,
    	id_entidad_financiera INT NOT NULL,
    	PRIMARY KEY (id_cooperativa, id_entidad_financiera),
    	FOREIGN KEY (id_cooperativa) REFERENCES cooperativa(id_cooperativa),
    	FOREIGN KEY (id_entidad_financiera) REFERENCES entidad_financiera(id_entidad_financiera)
);

CREATE TABLE lote_producto (
    	id_lote INT NOT NULL,
    	id_producto INT NOT NULL,
    	PRIMARY KEY (id_lote, id_producto),
    	FOREIGN KEY (id_lote) REFERENCES lote(id_lote),
    	FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);