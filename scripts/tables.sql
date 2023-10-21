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


 # Tabla Acta --------------------------------------------------
CREATE TABLE IF NOT EXISTS acta
(id_acta INTEGER UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
codigo INTEGER UNSIGNED NOT NULL,
fecha_hora DATETIME NOT NULL,
ciclo VARCHAR(3) NOT NULL,
seccion CHAR(1)    NOT NULL,
FOREIGN KEY (codigo) REFERENCES curso (codigo)
);


 # Tabla Notas  --------------------------------------------------
CREATE TABLE IF NOT EXISTS nota
(id_nota INTEGER UNSIGNED NOT NULL  AUTO_INCREMENT PRIMARY KEY,
 codigo INTEGER UNSIGNED NOT NULL,
 carnet BIGINT UNSIGNED NOT NULL,
 anio DATE NOT NULL,
 ciclo VARCHAR(3) NOT NULL,
 seccion CHAR(1)    NOT NULL,
 nota SMALLINT UNSIGNED NOT NULL,
 FOREIGN KEY (codigo) REFERENCES curso (codigo),
  FOREIGN KEY (carnet) REFERENCES estudiante (carnet)
);


  # Tabla asignacion --------------------------------------------
CREATE TABLE IF NOT EXISTS asignacion
(id_asignacion INTEGER UNSIGNED NOT NULL AUTO_INCREMENT  PRIMARY KEY,
 ciclo   VARCHAR(3) NOT NULL,
 seccion CHAR(1)    NOT NULL,
 codigo INTEGER UNSIGNED NOT NULL,
 carnet BIGINT UNSIGNED NOT NULL,
 id_habilitacion INTEGER UNSIGNED NOT NULL,
 FOREIGN KEY (codigo) REFERENCES curso (codigo),
 FOREIGN KEY (carnet) REFERENCES estudiante(carnet),
  FOREIGN KEY (id_habilitacion) REFERENCES habilitacion(id_habilitacion)
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

show tables;
SELECT * FROM estudiante;
INSERT INTO carrera (nombre) VALUE ('Ingeniería en Ciencias y Sistemas');	
#-------------------------------------------------------------------
describe curso;
SELECT * FROM curso;
INSERT INTO curso VALUES
(10,"IO2",30,10,0,1),
(11,"COMPI 2",60,20,1,1);
#---------------------------------------------------------------
describe docente;
SELECT * FROM docente;

INSERT INTO docente VALUES

(201907371,"Julie","Fredi","2023-06-26","jfretdi6@photobucket.com",55792116,"53922 Waubesa Center",3072061889948),
(201904842,"Bette","Eglington","2023-04-17","besglington7@loc.gov",44342211,"482 Oak Valley Terrace",3076193512650);
#----------------------------
describe habilitacion;
SELECT * FROM habilitacion;
INSERT INTO habilitacion (ciclo,seccion,cantidad_asignados,cupo_maximo,fecha_creacion,codigo,siif) VALUES
("VD","A",1,10,"2023-06-26",10,201907371),
("VD","B",1,10,"2023-06-27",11,201904842);
#------------------------------------------------------------
describe asignacion;
SELECT * FROM asignacion;

INSERT INTO asignacion (ciclo,seccion,codigo,carnet) VALUES
("VD","A",10,201907374),
("VD","B",11,201904845);






		# CREATE PROCEDURE Get_Products()
       #BEGIN
       #SELECT *  FROM products;
      # END //
#mysql> DELIMITER ;
#mysql> call get_products;