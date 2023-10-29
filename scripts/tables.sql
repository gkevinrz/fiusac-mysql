CREATE SCHEMA IF NOT EXISTS fiusac DEFAULT CHARACTER SET = utf8mb4;

USE fiusac;

# Table Carrera-------------------------------------------------------------
CREATE TABLE IF NOT EXISTS carrera(
id_carrera INTEGER UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(50) CHARACTER  SET utf8mb4 NOT NULL
);


# Table Estudiante------------------------------------------------------------
CREATE TABLE IF NOT EXISTS estudiante
(carnet BIGINT NOT NULL PRIMARY KEY,
 nombres VARCHAR(50) CHARACTER  SET utf8mb4 NOT NULL,
 apellidos VARCHAR(50) CHARACTER SET utf8mb4 NOT NULL,
 fecha_nacimiento DATE NOT NULL ,
 fecha_creacion DATE NOT NULL ,
 correo  VARCHAR(50) NOT NULL UNIQUE,
 telefono INTEGER NOT NULL,
 direccion VARCHAR(100) CHARACTER SET utf8mb4 NOT NULL,
 dpi BIGINT  NOT NULL UNIQUE,
 creditos SMALLINT NOT NULL DEFAULT 0,
 carrera INTEGER UNSIGNED NOT NULL,
 FOREIGN KEY (carrera) REFERENCES carrera (id_carrera)
 );


# Tabla Docente --------------------------------------------------
CREATE TABLE IF NOT EXISTS docente
(siif  INTEGER NOT NULL PRIMARY KEY,
 nombres VARCHAR(50) CHARACTER  SET utf8mb4 NOT NULL,
 apellidos VARCHAR(50) CHARACTER SET utf8mb4 NOT NULL,
 fecha_nacimiento DATE NOT NULL,
 fecha_creacion DATE NOT NULL,
 correo  VARCHAR(50) NOT NULL UNIQUE,
 telefono INTEGER NOT NULL,
 direccion VARCHAR(100) CHARACTER SET utf8mb4 NOT NULL,
 dpi BIGINT NOT NULL UNIQUE
 );
 
 # Tabla Curso --------------------------------------------------
CREATE TABLE IF NOT EXISTS curso
(codigo INTEGER NOT NULL PRIMARY KEY,
 nombre VARCHAR(50) CHARACTER  SET utf8mb4 NOT NULL,
 creditos_necesarios INTEGER  NOT NULL,
 creditos_otorga     INTEGER  NOT NULL ,
 obligatorio         TINYINT  NOT NULL,
 id_carrera  INTEGER UNSIGNED NOT NULL,
 FOREIGN KEY (id_carrera) REFERENCES carrera (id_carrera)
);

# Table Habilitacion------------------------------------------------------------
CREATE TABLE IF NOT EXISTS habilitacion
(id_habilitacion INTEGER UNSIGNED NOT NULL AUTO_INCREMENT  PRIMARY KEY,
 ciclo   VARCHAR(3) NOT NULL,
 seccion CHAR(1)    NOT NULL,
 cantidad_asignados SMALLINT NOT NULL DEFAULT 0,
 cupo_maximo SMALLINT NOT NULL,
 fecha_creacion DATE NOT NULL,
 codigo INTEGER NOT NULL,
 siif INTEGER NOT NULL,
 FOREIGN KEY (codigo) REFERENCES curso (codigo),
 FOREIGN KEY (siif) REFERENCES docente (siif)
);

# Tabla horario --------------------------------------------
CREATE TABLE IF NOT EXISTS horario
(id_horario INTEGER UNSIGNED NOT NULL AUTO_INCREMENT  PRIMARY KEY,
 id_habilitacion  INTEGER NOT NULL,
 dia TINYINT NOT NULL,
 horario VARCHAR(15) NOT NULL,
 FOREIGN KEY (id_habilitacion) REFERENCES habilitacion(id_habilitacion)
);

# Tabla asignacion --------------------------------------------
CREATE TABLE IF NOT EXISTS asignacion
(id_asignacion INTEGER UNSIGNED NOT NULL AUTO_INCREMENT  PRIMARY KEY,
 ciclo   VARCHAR(3) NOT NULL,
 seccion CHAR(1)    NOT NULL,
 codigo INTEGER UNSIGNED NOT NULL,
 carnet BIGINT UNSIGNED NOT NULL,
 id_habilitacion INTEGER UNSIGNED NOT NULL,
fecha_creacion DATE NOT NULL,
 FOREIGN KEY (codigo) REFERENCES curso (codigo),
 FOREIGN KEY (carnet) REFERENCES estudiante(carnet),
  FOREIGN KEY (id_habilitacion) REFERENCES habilitacion(id_habilitacion)
);
# Table desasignacion -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS desasignacion
(id_desasignacion INTEGER UNSIGNED NOT NULL AUTO_INCREMENT  PRIMARY KEY,
 ciclo   VARCHAR(3) NOT NULL,
 seccion CHAR(1)    NOT NULL,
 codigo INTEGER UNSIGNED NOT NULL,
 carnet BIGINT UNSIGNED NOT NULL,
 id_habilitacion INTEGER UNSIGNED NOT NULL,
 fecha_creacion DATE NOT NULL,
 FOREIGN KEY (codigo) REFERENCES curso (codigo),
 FOREIGN KEY (carnet) REFERENCES estudiante(carnet),
FOREIGN KEY (id_habilitacion) REFERENCES habilitacion(id_habilitacion)
);


 # Tabla Notas  --------------------------------------------------
CREATE TABLE IF NOT EXISTS nota
(id_nota INTEGER UNSIGNED NOT NULL  AUTO_INCREMENT PRIMARY KEY,
 codigo INTEGER UNSIGNED NOT NULL,
 carnet BIGINT UNSIGNED NOT NULL,
 ciclo VARCHAR(3) NOT NULL,
 seccion CHAR(1)    NOT NULL,
 nota SMALLINT NOT NULL,
 fecha_creacion DATE NOT NULL,
 id_habilitacion INTEGER UNSIGNED NOT NULL,
 FOREIGN KEY (codigo) REFERENCES curso (codigo),
 FOREIGN KEY (carnet) REFERENCES estudiante (carnet),
 FOREIGN KEY (id_habilitacion) REFERENCES habilitacion(id_habilitacion)

);
 # Tabla Acta --------------------------------------------------
CREATE TABLE IF NOT EXISTS acta
(id_acta INTEGER UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
codigo INTEGER UNSIGNED NOT NULL,
fecha_hora DATETIME NOT NULL,
ciclo VARCHAR(3) NOT NULL,
seccion CHAR(1)    NOT NULL,
id_habilitacion INTEGER UNSIGNED NOT NULL,
FOREIGN KEY (codigo) REFERENCES curso (codigo),
 FOREIGN KEY (id_habilitacion) REFERENCES habilitacion(id_habilitacion)

);
