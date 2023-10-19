# Procedure para crear carrera --------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS crearCarrera(
	IN i_nombre VARCHAR(50) CHARACTER SET utf8mb4
	)
    
	BEGIN
		DECLARE existe_carrera TINYINT DEFAULT 0;
        
 		IF onlyLetters(i_nombre)<>0 THEN
			SELECT EXISTS(SELECT nombre FROM carrera WHERE nombre=i_nombre) INTO existe_carrera;
            
			IF existe_carrera=1 THEN
				SELECT CONCAT(i_nombre," ya existe") AS 'Error';
			ELSE
				INSERT INTO carrera (nombre) VALUE (i_nombre);
                SELECT CONCAT(i_nombre," agregada con éxito") AS 'Respuesta';
			
            END IF;
        ELSE
			SELECT "Solo se aceptan letras" AS 'Error';
        END IF;
 
	END //
DELIMITER ;

# Procedure para registro de estudiante -----------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS registrarEstudiante(
	IN i_carnet BIGINT,
    IN i_nombres VARCHAR(50) CHARACTER SET utf8mb4,
    IN i_apellidos VARCHAR(50) CHARACTER SET utf8mb4 ,
    IN i_fecha_nacimiento DATE,
    IN i_correo VARCHAR(50),
    IN i_telefono INTEGER,
    IN i_direccion VARCHAR(100) CHARACTER SET utf8mb4,
    IN i_dpi BIGINT,
    IN i_carrera INTEGER UNSIGNED 
    )
		
	BEGIN
		DECLARE existe_dpi TINYINT DEFAULT 0;
        DECLARE existe_correo TINYINT DEFAULT 0;
		DECLARE existe_carnet TINYINT DEFAULT 0;

        # Verificar si existen uniques fields	
		SELECT EXISTS(SELECT dpi FROM estudiante WHERE i_dpi=dpi) INTO existe_dpi;
		SELECT EXISTS(SELECT correo FROM estudiante WHERE i_correo=correo) INTO existe_correo;
		SELECT EXISTS(SELECT carnet FROM estudiante WHERE i_carnet=carnet) INTO existe_carnet;

		IF isValidEmail(i_correo)<>0 AND existe_dpi=0 AND existe_correo=0 AND existe_carnet=0 THEN
            INSERT INTO estudiante (carnet,nombres,apellidos,fecha_nacimiento,fecha_creacion,correo,telefono,direccion,dpi,carrera) VALUE (i_carnet,i_nombres,i_apellidos,i_fecha_nacimiento,CURDATE(),i_correo,i_telefono,i_direccion,i_dpi,i_carrera);
			SELECT CONCAT("Estudiante creado correctamente") AS 'Respuesta';
        ELSE
			IF existe_carnet=1 THEN
				SELECT CONCAT("Carnet: ",i_carnet," ya existe") AS 'Error';
            ELSEIF existe_dpi=1 THEN
				SELECT CONCAT("DPI: ",i_dpi," ya existe") AS 'Error';
			ELSEIF existe_correo=1 THEN
				SELECT CONCAT("Email: ",i_correo," ya existe") AS 'Error';
            ELSE 
				SELECT CONCAT(i_correo,"no es valido") AS 'Error';
            END IF;
        END IF;
    END //
DELIMITER ;

# Procedure para creacion de docente---------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS registrarDocente(
    IN i_siif INTEGER,
	IN i_nombres VARCHAR(50) CHARACTER  SET utf8mb4,
    IN i_apellidos VARCHAR(50) CHARACTER  SET utf8mb4,
    IN i_fecha_nacimiento DATE,
    IN i_correo VARCHAR(50),
    IN i_telefono INTEGER,
    IN i_direccion VARCHAR(100) CHARACTER SET utf8mb4,
    IN i_dpi BIGINT
)
	BEGIN
  
    DECLARE existe_correo TINYINT DEFAULT 0;
    DECLARE existe_dpi TINYINT DEFAULT 0;
    DECLARE existe_siif TINYINT DEFAULT 0;
    # Verificar si existe siif,correo y dpi
    
    SELECT EXISTS(SELECT siif FROM docente WHERE i_siif=siif) INTO existe_siif;
    SELECT EXISTS(SELECT dpi FROM docente WHERE dpi=i_dpi) INTO existe_dpi;
    SELECT EXISTS(SELECT correo FROM docente WHERE correo=i_correo) INTO existe_correo;

	IF isValidEmail(i_correo)<>0 AND existe_dpi=0 AND existe_correo=0 AND existe_siif=0 THEN
		INSERT INTO docente(siif,nombres,apellidos,fecha_nacimiento,fecha_creacion,correo,telefono,direccion,dpi) VALUE (i_siif,i_nombres,i_apellidos,i_fecha_nacimiento,CURDATE(),i_correo,i_telefono,i_direccion,i_dpi);
		SELECT CONCAT("Docente creado correctamente") AS 'Respuesta';
	ELSE
		IF existe_siif=1 THEN
			SELECT CONCAT("Siif: ",i_siif," ya existe") AS 'Error';
		ELSEIF existe_dpi=1 THEN
			SELECT CONCAT("DPI: ",i_dpi," ya existe") AS 'Error';
		ELSEIF existe_correo=1 THEN
			SELECT CONCAT("Email: ",i_correo," ya existe") AS 'Error';
		ELSE 
			SELECT CONCAT(i_correo,"no es valido") AS 'Error';
		END IF;		
    END IF;
    END //
DELIMITER ;


# Procedure para crear curso------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS crearCurso(
	IN i_codigo  INTEGER,
	IN i_nombre VARCHAR(50) CHARACTER  SET utf8mb4,
    IN i_creditos_necesarios INTEGER ,
    IN i_creditos_otorga     INTEGER ,
    IN i_obligatorio         TINYINT ,
	IN i_id_carrera  INTEGER UNSIGNED
)
	BEGIN
        DECLARE existe_curso TINYINT DEFAULT 0;
		DECLARE is_0_positive TINYINT DEFAULT 1;
		DECLARE is_positive_creditos TINYINT DEFAULT 1;
        DECLARE existe_carrera TINYINT DEFAULT 1;

		# Verificar codigo repetido
		SELECT EXISTS(SELECT codigo FROM curso WHERE i_codigo=codigo) INTO existe_curso;

		# Verificar creditos necesarios-> 0 | entero postiivo        
		SELECT isPositive(i_creditos_necesarios) INTO is_0_positive;
        
		# Verificar creditos otorga -> entero postivo
        SELECT isPositive(i_creditos_otorga) INTO is_positive_creditos;
        
        # verificar si existe carrera
        SELECT EXISTS(SELECT id_carrera FROM carrera WHERE id_carrera=i_id_carrera OR i_id_carrera=0) INTO  existe_carrera;

	
		IF existe_curso=0 AND (is_0_positive=1 OR is_0_positive=0) AND is_positive_creditos=1 AND existe_carrera=1 THEN
			INSERT INTO curso VALUE (i_codigo,i_nombre,i_creditos_necesarios,i_creditos_otorga,i_obligatorio,i_id_carrera);
			SELECT "Curso creado correctamente" AS 'respuesta';
		ELSE
			IF existe_curso=1 THEN
				SELECT CONCAT("Codigo: ",i_codigo," ya existe") AS 'Error';
			ELSEIF is_0_positive=-1 THEN
				SELECT CONCAT("Creditos necesarios: ",i_creditos_necesarios," debe ser positivo") AS 'Error';
			ELSEIF is_positive_creditos=-1 THEN
				SELECT CONCAT("Créditos que otorga: ",i_creditos_otorga," debe ser positivo") AS 'Error';
			ELSEIF existe_carrera=0 THEN
				SELECT CONCAT("Carrera: ",i_id_carrera," no existe") AS 'Error';
			END IF;
        END IF;
    
    END //
DELIMITER ;

# Procedure para habilitar curso------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS habilitarCurso(
IN i_codigo	 INTEGER, 
IN i_siif INTEGER,
IN i_ciclo  VARCHAR(3),
IN i_seccion  CHAR(1),
IN i_cupo_maximo SMALLINT 
)

	BEGIN
            DECLARE existe_curso TINYINT DEFAULT 1;
			# Verificar existe curso
			SELECT EXISTS(SELECT codigo FROM curso WHERE i_codigo=codigo) INTO existe_curso;
			
    
	END //
	
DELIMITER ;

#
