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
CREATE PROCEDURE IF NOT EXISTS registrarEstudiante(# FALTA VERIFICAR SI EXISTE CARRERA
	IN i_carnet BIGINT,
    IN i_nombres VARCHAR(50) CHARACTER SET utf8mb4,
    IN i_apellidos VARCHAR(50) CHARACTER SET utf8mb4 ,
    IN i_fecha_nacimiento VARCHAR(50),
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
            INSERT INTO estudiante (carnet,nombres,apellidos,fecha_nacimiento,fecha_creacion,correo,telefono,direccion,dpi,carrera) VALUE (i_carnet,i_nombres,i_apellidos,DATE_FORMAT(STR_TO_DATE(i_fecha_nacimiento,'%d-%m-%Y'), '%Y-%m-%d'),CURDATE(),i_correo,i_telefono,i_direccion,i_dpi,i_carrera);
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
	IN i_nombres VARCHAR(50) CHARACTER  SET utf8mb4,
	IN i_apellidos VARCHAR(50) CHARACTER  SET utf8mb4,
    IN i_fecha_nacimiento VARCHAR(50),
    IN i_correo VARCHAR(50),
    IN i_telefono INTEGER,
    IN i_direccion VARCHAR(100) CHARACTER SET utf8mb4,
    IN i_dpi BIGINT,
    IN i_siif INTEGER
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
    		

		INSERT INTO docente(siif,nombres,apellidos,fecha_nacimiento,fecha_creacion,correo,telefono,direccion,dpi) VALUE (i_siif,i_nombres,i_apellidos,DATE_FORMAT(STR_TO_DATE(i_fecha_nacimiento,'%d-%m-%Y'), '%Y-%m-%d'),CURDATE(),i_correo,i_telefono,i_direccion,i_dpi);
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
	IN i_id_carrera  INTEGER UNSIGNED,
	IN i_obligatorio         TINYINT 
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
CREATE PROCEDURE IF NOT EXISTS habilitarCurso( #VERIFICAR SI EXISTE DOCENTE
IN i_codigo	 INTEGER, 
IN i_ciclo  VARCHAR(3),
IN i_siif INTEGER,
IN i_cupo_maximo SMALLINT,
IN i_seccion  CHAR(1)
)
	BEGIN
		DECLARE existe_curso TINYINT DEFAULT 1;
		DECLARE existe_seccion TINYINT DEFAULT 0;
        
		DECLARE is_positive TINYINT DEFAULT 1;
		DECLARE ciclo_valido TINYINT DEFAULT 1;
		DECLARE seccion_valida TINYINT DEFAULT 1;

        # Verificar existe curso
		SELECT EXISTS(SELECT codigo FROM curso WHERE i_codigo=codigo) INTO existe_curso;
			
		#Verificar positivo
		SELECT isPositive(i_cupo_maximo) INTO is_positive;
	
		# Verificar formato ciclo valido
		SELECT verificarCiclo(i_ciclo) INTO ciclo_valido;
	
		# Verificar formato seccion valida
		SELECT valoresSeccion(i_seccion) INTO seccion_valida;

		#Verificar si existe Seccion 
		SELECT EXISTS(SELECT seccion FROM habilitacion WHERE i_seccion=seccion AND i_codigo=codigo AND i_ciclo=ciclo AND YEAR(CURDATE())=YEAR(fecha_creacion)) INTO existe_seccion;
			
		IF existe_curso=1 AND existe_seccion=0 AND is_positive=1 AND ciclo_valido=1 AND seccion_valida=1 THEN
        
			INSERT INTO habilitacion (ciclo,seccion,cupo_maximo,fecha_creacion,codigo,siif) VALUE (
            UPPER(i_ciclo),
            UPPER(i_seccion),
            i_cupo_maximo,
            CURDATE(),
            i_codigo,
            i_siif
            );
            SELECT "Se habilitó curso correctamente" AS "Respuesta";
            
		ELSE
			IF existe_curso=0 THEN
				SELECT CONCAT("Código de curso: ",i_codigo," - no existe") AS 'Error';
			ELSEIF existe_seccion=1 THEN
				SELECT CONCAT("Seccion: La sección ",UPPER(i_seccion)," ya existe") AS 'Error';
			ELSEIF (is_positive=0 OR is_positive=-1) THEN
				SELECT CONCAT("Cupo máximo: ",i_cupo_maximo," debe ser un numero mayor a 0") AS 'Error';
			ELSEIF ciclo_valido=0 THEN
				SELECT CONCAT("Ciclo: ",i_ciclo," - formato no válido") AS 'Error';
			ELSEIF seccion_valida=0 THEN
				SELECT CONCAT("Sección: ",i_seccion," - formato no válido") AS 'Error';
			END IF;			
        END IF;
	END //
	
DELIMITER ;

# Procedure para asignar horario--------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS agregarHorario(
	IN i_id_habilitacion INTEGER UNSIGNED,
    IN i_dia TINYINT,
    IN i_horario VARCHAR(15)
)
	BEGIN
		DECLARE existe_habilitado TINYINT DEFAULT 1;
        DECLARE rango_valido TINYINT DEFAULT 1;
        DECLARE dia_valido TINYINT DEFAULT 1;
		
        #Existe habilitado
		SELECT EXISTS(SELECT id_habilitacion FROM habilitacion WHERE id_habilitacion=i_id_habilitacion) INTO existe_habilitado;
			
		# Rango valido horario
        SELECT verificarHorario(i_horario) INTO  rango_valido;
        
        #Dias validos
		SELECT verificarDia(i_dia) INTO  dia_valido;
	
		IF existe_habilitado=1 AND rango_valido=1 AND dia_valido=1 THEN
			INSERT INTO horario (id_habilitacion,dia,horario) VALUE (i_id_habilitacion,i_dia,i_horario);
			SELECT CONCAT("Horario agregado correctamente") AS "Respuesta";
		ELSE
			IF existe_habilitado=0 THEN
				SELECT CONCAT("Curso habilitado: ", i_id_habilitacion," - este código no existe") AS "Error";
			ELSEIF dia_valido=0 THEN
				SELECT CONCAT("Dia: ", i_dia," - numero fuera del rango") AS "Error";
            ELSEIF  rango_valido=0 THEN
				SELECT CONCAT("Horario: ", i_horario," - formato incorrecto") AS "Error";
            END IF;
	
        END IF;
        
    END //
    
DELIMITER ;

# procedure para asignar curso-----------------------------------------------------------------------------------

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS asignarCurso(
	IN i_codigo_curso INTEGER,
    IN i_ciclo    VARCHAR(3),
    IN i_seccion  CHAR(1),
    IN i_carnet   BIGINT
)	
	BEGIN
	
        DECLARE existe_curso TINYINT DEFAULT 1;     # bool->  existe curso
		DECLARE existe_carnet TINYINT DEFAULT 1;     # bool->  existe curso
		DECLARE hay_cupo TINYINT DEFAULT 0; # bool
		DECLARE curso_comun_carrera TINYINT DEFAULT 1; # bool -> pertenece a carrera o area comun
		DECLARE creditos_validos TINYINT DEFAULT 1; # bool -> cumple con creditos	
        
        
		DECLARE f_ciclo_valido   TINYINT DEFAULT 1;   #bool-> formati ciclo valido
		DECLARE f_seccion_valida TINYINT DEFAULT 1; #bool-> formato seccion valido
		
        DECLARE id_habilitacion_asignacion INTEGER UNSIGNED; #guarda el id habilitacion
		DECLARE id_habilitacion_hab INTEGER UNSIGNED; #guarda el id habilitacion

        DECLARE existe_seccion TINYINT  DEFAULT 1; 
		DECLARE existe_ciclo TINYINT  DEFAULT 1;
		DECLARE existe_anio TINYINT  DEFAULT 1;

        
        DECLARE carnet_seccion_repetida TINYINT DEFAULT 1; # bool -> esta repetida
                
		# Verificiar que existe carnet
        SELECT EXISTS(SELECT carnet FROM estudiante WHERE i_carnet=carnet) INTO existe_carnet;
        
		# Verificiar que existe curso
        SELECT EXISTS(SELECT codigo FROM curso WHERE i_codigo_curso=codigo) INTO existe_curso;
		
        # Verificar formato ciclo valido
		SELECT verificarCiclo(i_ciclo) INTO f_ciclo_valido;
	
		# Verificar formato seccion valida
		SELECT valoresSeccion(i_seccion) INTO f_seccion_valida;         
		
	
		# Existe curso, es valido el formato de ciclo, es valido formato seccion
		IF existe_curso=1 AND f_ciclo_valido=1 AND f_seccion_valida=1 AND existe_carnet=1 THEN
			
			#verificar si hace match con seccion, ciclo y anio actual-> existe la seccion
			SELECT EXISTS(SELECT seccion  FROM habilitacion WHERE seccion=i_seccion AND i_codigo_curso=codigo AND  YEAR(CURDATE())=YEAR(fecha_creacion)) INTO existe_seccion;
			
            SELECT EXISTS(SELECT ciclo FROM habilitacion WHERE ciclo=i_ciclo AND i_codigo_curso=codigo  AND  YEAR(CURDATE())=YEAR(fecha_creacion)) INTO existe_ciclo;
			
            SELECT EXISTS(SELECT fecha_creacion FROM habilitacion WHERE YEAR(CURDATE())=YEAR(fecha_creacion) AND i_codigo_curso=codigo) INTO existe_anio;			
			
            
            #Verificar creditos
			SELECT if((SELECT creditos FROM estudiante WHERE carnet=i_carnet)>=(SELECT creditos_necesarios FROM curso WHERE codigo=i_codigo_curso),1,0) INTO creditos_validos;
			#Validar curso  carrera o area comun
			SELECT if((SELECT carrera FROM estudiante WHERE carnet=i_carnet)=(SELECT id_carrera FROM curso WHERE codigo=i_codigo_curso) OR (SELECT id_carrera FROM curso WHERE codigo=i_codigo_curso)=0,1,0) INTO curso_comun_carrera;

			IF existe_seccion=1 AND existe_ciclo=1 AND  existe_anio=1 THEN
				
                #Verificacion repitencia
                SELECT EXISTS(SELECT id_asignacion FROM asignacion INNER JOIN habilitacion ON i_carnet=asignacion.carnet AND i_codigo_curso=asignacion.codigo AND i_ciclo=asignacion.ciclo AND (asignacion.seccion<>i_seccion OR  asignacion.seccion=i_seccion ) AND YEAR(asignacion.fecha_creacion)=YEAR(CURDATE()) AND habilitacion.id_habilitacion=asignacion.id_habilitacion ) INTO carnet_seccion_repetida;
                #SELECT EXISTS(SELECT id_habilitacion FROM habilitacion INNER JOIN habilitacion ON i_carnet=asignacion.carnet AND i_codigo_curso=asignacion.codigo AND i_ciclo=asignacion.ciclo AND (asignacion.seccion<>i_seccion OR  asignacion.seccion=i_seccion ) AND YEAR(CURDATE())=YEAR(habilitacion.fecha_creacion) AND habilitacion.id_habilitacion<>asignacion.id_habilitacion ) INTO carnet_seccion_repetida;


                IF carnet_seccion_repetida=0 THEN
					SELECT IF((SELECT cantidad_asignados FROM habilitacion WHERE i_codigo_curso=codigo AND i_ciclo=ciclo AND i_seccion=seccion AND YEAR(CURDATE())=YEAR(fecha_creacion))=(SELECT cupo_maximo FROM habilitacion WHERE i_codigo_curso=codigo AND i_ciclo=ciclo AND i_seccion=seccion AND YEAR(CURDATE())=YEAR(fecha_creacion)),1,0) INTO hay_cupo;
                    # Validacion Cupo maximo,creditos necesarios, curso carrera o comun
					IF hay_cupo=0 AND  curso_comun_carrera=1 AND creditos_validos=1 THEN
						SELECT id_habilitacion FROM habilitacion WHERE ciclo=i_ciclo AND i_codigo_curso=codigo AND seccion=i_seccion AND YEAR(CURDATE())=YEAR(fecha_creacion) INTO id_habilitacion_asignacion;
						
                        INSERT INTO asignacion (ciclo,seccion,codigo,carnet,id_habilitacion,fecha_creacion)  VALUE (i_ciclo,i_seccion,i_codigo_curso,i_carnet,id_habilitacion_asignacion,CURDATE());	
						
                        UPDATE habilitacion SET cantidad_asignados=cantidad_asignados+1 WHERE ciclo=i_ciclo AND i_codigo_curso=codigo AND seccion=i_seccion AND YEAR(CURDATE())=YEAR(fecha_creacion);
                        SELECT "Estudiante asignado correctamente" AS "Respuesta";
                    ELSE
                    
						IF hay_cupo=1 THEN
							SELECT CONCAT("Cupo Máximo: Ya no hay cupo para el curso - ",i_codigo_curso) AS 'Error';
						ELSEIF curso_comun_carrera=0 THEN
							SELECT CONCAT("Carrera: Este curso no pertenece al área común o a la carrera - ",i_codigo_curso) AS 'Error';
						ELSEIF creditos_validos=0 THEN
							SELECT CONCAT("Créditos: No cumple con los créditos necesarios - ",i_codigo_curso) AS 'Error';
						END IF;
                        
                    END IF;
				ELSE
					SELECT CONCAT("Carnet: ", i_carnet ," - estudiante ya asignado a la misma u otra sección") AS "Error";
                END IF;
            ELSE
				# Errores de existencia
				IF existe_seccion=0  THEN
					SELECT CONCAT("Sección: ", i_seccion ," - esta sección no corresponde al curso") AS "Error";
				ELSEIF existe_carnet=0 THEN
					SELECT CONCAT("Carnet: ", i_carnet ," - no existe") AS "Error";
				ELSEIF existe_ciclo=0 THEN
					SELECT CONCAT("Ciclo: ",i_ciclo," - no corresponde al curso") AS 'Error';
				ELSEIF  existe_anio=0 THEN
					SELECT CONCAT("Año : ",i_seccion," - no corresponde al curso") AS 'Error';
				END IF;
            
			END IF;
            
		ELSE
			# Error curso no existe - Error formatos no validos
			IF existe_curso=0  THEN
				SELECT CONCAT("Código de curso: ", i_codigo_curso," - este curso no existe") AS "Error";
			ELSEIF f_ciclo_valido=0 THEN
				SELECT CONCAT("Ciclo: ",i_ciclo," - formato no válido") AS 'Error';
            ELSEIF  f_seccion_valida=0 THEN
				SELECT CONCAT("Sección: ",i_seccion," - formato no válido") AS 'Error';
            END IF;
		END IF;
	END //
    
DELIMITER ;
#--Procedure para verificar el año 2024 ------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS asignarCurso2(
	IN i_codigo_curso INTEGER,
    IN i_ciclo    VARCHAR(3),
    IN i_seccion  CHAR(1),
    IN i_carnet   BIGINT
)	
	BEGIN
	
        DECLARE existe_curso TINYINT DEFAULT 1;     # bool->  existe curso
		DECLARE existe_carnet TINYINT DEFAULT 1;     # bool->  existe curso
		DECLARE hay_cupo TINYINT DEFAULT 0; # bool
		DECLARE curso_comun_carrera TINYINT DEFAULT 1; # bool -> pertenece a carrera o area comun
		DECLARE creditos_validos TINYINT DEFAULT 1; # bool -> cumple con creditos	
        
        
		DECLARE f_ciclo_valido   TINYINT DEFAULT 1;   #bool-> formati ciclo valido
		DECLARE f_seccion_valida TINYINT DEFAULT 1; #bool-> formato seccion valido
		
        DECLARE id_habilitacion_asignacion INTEGER UNSIGNED; #guarda el id habilitacion
 
        DECLARE existe_seccion TINYINT  DEFAULT 1; 
		DECLARE existe_ciclo TINYINT  DEFAULT 1;
		DECLARE existe_anio TINYINT  DEFAULT 1;

        
        DECLARE carnet_seccion_repetida TINYINT DEFAULT 1; # bool -> esta repetida
                
		# Verificiar que existe carnet
        SELECT EXISTS(SELECT carnet FROM estudiante WHERE i_carnet=carnet) INTO existe_carnet;
        
		# Verificiar que existe curso
        SELECT EXISTS(SELECT codigo FROM curso WHERE i_codigo_curso=codigo) INTO existe_curso;
		
        # Verificar formato ciclo valido
		SELECT verificarCiclo(i_ciclo) INTO f_ciclo_valido;
	
		# Verificar formato seccion valida
		SELECT valoresSeccion(i_seccion) INTO f_seccion_valida;         
		
	
		# Existe curso, es valido el formato de ciclo, es valido formato seccion
		IF existe_curso=1 AND f_ciclo_valido=1 AND f_seccion_valida=1 AND existe_carnet=1 THEN
			
			#verificar si hace match con seccion, ciclo y anio actual-> existe la seccion
			SELECT EXISTS(SELECT seccion  FROM habilitacion WHERE seccion=i_seccion AND i_codigo_curso=codigo AND  2024=YEAR(fecha_creacion)) INTO existe_seccion;
			SELECT EXISTS(SELECT ciclo FROM habilitacion WHERE ciclo=i_ciclo AND i_codigo_curso=codigo  AND  2024=YEAR(fecha_creacion)) INTO existe_ciclo;
			SELECT EXISTS(SELECT fecha_creacion FROM habilitacion WHERE 2024=YEAR(fecha_creacion) AND i_codigo_curso=codigo) INTO existe_anio;			
			
            #Verificar creditos
			SELECT if((SELECT creditos FROM estudiante WHERE carnet=i_carnet)>=(SELECT creditos_necesarios FROM curso WHERE codigo=i_codigo_curso),1,0) INTO creditos_validos;
			#Validar curso  carrera o area comun
			SELECT if((SELECT carrera FROM estudiante WHERE carnet=i_carnet)=(SELECT id_carrera FROM curso WHERE codigo=i_codigo_curso) OR (SELECT id_carrera FROM curso WHERE codigo=i_codigo_curso)=0,1,0) INTO curso_comun_carrera;

			IF existe_seccion=1 AND existe_ciclo=1 AND  existe_anio=1 THEN
				
                #Verificacion repitencia
                SELECT EXISTS(SELECT id_asignacion FROM asignacion INNER JOIN habilitacion ON i_carnet=asignacion.carnet AND i_codigo_curso=asignacion.codigo AND i_ciclo=asignacion.ciclo AND (asignacion.seccion<>i_seccion OR  asignacion.seccion=i_seccion ) AND YEAR(asignacion.fecha_creacion)=2024 AND habilitacion.id_habilitacion=asignacion.id_habilitacion ) INTO carnet_seccion_repetida;


                IF carnet_seccion_repetida=0 THEN
					SELECT IF((SELECT cantidad_asignados FROM habilitacion WHERE i_codigo_curso=codigo AND i_ciclo=ciclo AND i_seccion=seccion AND 2024=YEAR(fecha_creacion))=(SELECT cupo_maximo FROM habilitacion WHERE i_codigo_curso=codigo AND i_ciclo=ciclo AND i_seccion=seccion AND 2024=YEAR(fecha_creacion)),1,0) INTO hay_cupo;
                    # Validacion Cupo maximo,creditos necesarios, curso carrera o comun
					IF hay_cupo=0 AND  curso_comun_carrera=1 AND creditos_validos=1 THEN
						SELECT id_habilitacion FROM habilitacion WHERE ciclo=i_ciclo AND i_codigo_curso=codigo AND seccion=i_seccion AND 2024=YEAR(fecha_creacion) INTO id_habilitacion_asignacion;
						INSERT INTO asignacion (ciclo,seccion,codigo,carnet,id_habilitacion,fecha_creacion)  VALUE (i_ciclo,i_seccion,i_codigo_curso,i_carnet,id_habilitacion_asignacion,"2024-10-23");	
						UPDATE habilitacion SET cantidad_asignados=cantidad_asignados+1 WHERE ciclo=i_ciclo AND i_codigo_curso=codigo AND seccion=i_seccion AND 2024=YEAR(fecha_creacion);
                        SELECT "Estudiante asignado correctamente" AS "Respuesta";
                    ELSE
                    
						IF hay_cupo=1 THEN
							SELECT CONCAT("Cupo Máximo: Ya no hay cupo para el curso - ",i_codigo_curso) AS 'Error';
						ELSEIF curso_comun_carrera=0 THEN
							SELECT CONCAT("Carrera: Este curso no pertenece al área común o a la carrera - ",i_codigo_curso) AS 'Error';
						ELSEIF creditos_validos=0 THEN
							SELECT CONCAT("Créditos: No cumple con los créditos necesarios - ",i_codigo_curso) AS 'Error';
						END IF;
                        
                    END IF;
				ELSE
					SELECT CONCAT("Carnet: ", i_carnet ," - estudiante ya asignado a la misma u otra sección") AS "Error";
                END IF;
            ELSE
				# Errores de existencia
				IF existe_seccion=0  THEN
					SELECT CONCAT("Sección: ", i_seccion ," - esta sección no corresponde al curso") AS "Error";
				ELSEIF existe_carnet=0 THEN
					SELECT CONCAT("Carnet: ", i_carnet ," - no existe") AS "Error";
				ELSEIF existe_ciclo=0 THEN
					SELECT CONCAT("Ciclo: ",i_ciclo," - no corresponde al curso") AS 'Error';
				ELSEIF  existe_anio=0 THEN
					SELECT CONCAT("Año : ",i_seccion," - no corresponde al curso") AS 'Error';
				END IF;
            
			END IF;
            
		ELSE
			# Error curso no existe - Error formatos no validos
			IF existe_curso=0  THEN
				SELECT CONCAT("Código de curso: ", i_codigo_curso," - este curso no existe") AS "Error";
			ELSEIF f_ciclo_valido=0 THEN
				SELECT CONCAT("Ciclo: ",i_ciclo," - formato no válido") AS 'Error';
            ELSEIF  f_seccion_valida=0 THEN
				SELECT CONCAT("Sección: ",i_seccion," - formato no válido") AS 'Error';
            END IF;
		END IF;
	END //
    
DELIMITER ;




# Procedure desasignacion de curso ------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS desasignarCurso(
	IN i_codigo_curso INTEGER,
    IN i_ciclo    VARCHAR(3),
    IN i_seccion  CHAR(1),
    IN i_carnet   BIGINT
)
	BEGIN
		DECLARE existe_curso TINYINT DEFAULT 1;     # bool->  existe curso
		DECLARE existe_carnet TINYINT DEFAULT 1;     # bool->  existe estudiante (carnet)
        
        DECLARE f_ciclo_valido   TINYINT DEFAULT 1;   #bool-> formati ciclo valido
		DECLARE f_seccion_valida TINYINT DEFAULT 1; #bool-> formato seccion valido
        
		DECLARE existe_seccion TINYINT  DEFAULT 1; 
		DECLARE existe_ciclo TINYINT  DEFAULT 1;
		DECLARE existe_anio TINYINT  DEFAULT 1;
	
        
        DECLARE desasignacion_repetida TINYINT DEFAULT 1; # bool -> esta repetida
		DECLARE esta_asignado TINYINT DEFAULT 1; # bool -> esta repetida

		DECLARE id_habilitacion_hab INTEGER UNSIGNED; #guarda el id habilitacion

        
        # Verificar que existe carnet
        SELECT EXISTS(SELECT carnet FROM estudiante WHERE i_carnet=carnet) INTO existe_carnet;
        
		# Verificiar que existe curso
        SELECT EXISTS(SELECT codigo FROM curso WHERE i_codigo_curso=codigo) INTO existe_curso;
		
        # Verificar formato ciclo valido
		SELECT verificarCiclo(i_ciclo) INTO f_ciclo_valido;
	
		# Verificar formato seccion valida
		SELECT valoresSeccion(i_seccion) INTO f_seccion_valida;         
        	
		# Existe curso, es valido el formato de ciclo, es valido formato seccion
		IF existe_curso=1 AND f_ciclo_valido=1 AND f_seccion_valida=1 AND existe_carnet=1 THEN
			#verificar si hace match con seccion, ciclo y anio actual-> existe la seccion
			SELECT EXISTS(SELECT seccion  FROM habilitacion WHERE seccion=i_seccion AND i_codigo_curso=codigo AND  YEAR(CURDATE())=YEAR(fecha_creacion)) INTO existe_seccion;	
            SELECT EXISTS(SELECT ciclo FROM habilitacion WHERE ciclo=i_ciclo AND i_codigo_curso=codigo  AND  YEAR(CURDATE())=YEAR(fecha_creacion)) INTO existe_ciclo;
            SELECT EXISTS(SELECT fecha_creacion FROM habilitacion WHERE YEAR(CURDATE())=YEAR(fecha_creacion) AND i_codigo_curso=codigo) INTO existe_anio;			
			
            IF existe_seccion=1 AND existe_ciclo=1 AND  existe_anio=1 THEN
                # Verificacion de si estaba asignado  
                
				SELECT id_habilitacion FROM habilitacion WHERE i_ciclo=ciclo AND i_seccion=seccion AND i_codigo_curso=codigo AND YEAR(CURDATE())=YEAR(fecha_creacion) INTO id_habilitacion_hab;
				
                SELECT EXISTS(SELECT carnet FROM asignacion WHERE i_carnet=carnet AND id_habilitacion=id_habilitacion_hab) INTO esta_asignado;
				SELECT EXISTS(SELECT carnet FROM desasignacion WHERE i_carnet=carnet AND id_habilitacion=id_habilitacion_hab) INTO desasignacion_repetida;

                IF esta_asignado=1 THEN
					IF desasignacion_repetida=0 THEN
                        INSERT INTO desasignacion(ciclo,seccion,codigo,carnet,id_habilitacion,fecha_creacion)  VALUE (i_ciclo,i_seccion,i_codigo_curso,i_carnet,id_habilitacion_hab,CURDATE());	
						SELECT CONCAT("Se desasignó el curso correctamente") AS "Error";
                    ELSE
						SELECT CONCAT("Codigo curso: ",i_codigo_curso ," - Este curso ya se desasignó") AS "Error";
                    END IF;
	
                ELSE
					SELECT CONCAT("Desasignacion: curso ", i_codigo_curso, " no está asignado - Seccion(",i_seccion,") - Año(",YEAR(CURDATE()),")") AS "Error";
                END IF;
                
            ELSE
				# Errores de existencia
				IF existe_seccion=0  THEN
					SELECT CONCAT("Sección: ", i_seccion ," - esta sección no corresponde al curso") AS "Error";
				ELSEIF existe_ciclo=0 THEN
					SELECT CONCAT("Ciclo: ",i_ciclo," - no corresponde al curso") AS 'Error';
				ELSEIF  existe_anio=0 THEN
					SELECT CONCAT("Año : ",i_seccion," - no corresponde al curso") AS 'Error';
				END IF;
            
			END IF;
			
		ELSE
			# Error curso no existe - Error formatos no validos
			IF existe_curso=0  THEN
				SELECT CONCAT("Código de curso: ", i_codigo_curso," - este curso no existe") AS "Error";
			ELSEIF f_ciclo_valido=0 THEN
				SELECT CONCAT("Ciclo: ",i_ciclo," - formato no válido") AS 'Error';
            ELSEIF  f_seccion_valida=0 THEN
				SELECT CONCAT("Sección: ",i_seccion," - formato no válido") AS 'Error';
			ELSEIF  existe_carnet=0 THEN
				SELECT CONCAT("Carnet: ", i_carnet," - este carnet no existe") AS "Error";
            END IF;
        
        END IF;
    END //
DELIMITER ;


#Procedure para subir notas --------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS ingresarNota(
	IN i_codigo_curso INTEGER,
    IN i_ciclo    VARCHAR(3),
    IN i_seccion  CHAR(1),
    IN i_carnet   BIGINT,
    IN i_nota DECIMAL (5,2)
)
	BEGIN
		DECLARE existe_curso TINYINT DEFAULT 1;     # bool->  existe curso
		DECLARE existe_carnet TINYINT DEFAULT 1;     # bool->  existe carnet
		DECLARE f_ciclo_valido   TINYINT DEFAULT 1;   #bool-> formati ciclo valido
		DECLARE f_seccion_valida TINYINT DEFAULT 1; #bool-> formato seccion valido
		DECLARE f_nota_positiva TINYINT DEFAULT 1; #bool-> formato nota valido

		DECLARE existe_seccion TINYINT  DEFAULT 1; 
		DECLARE existe_ciclo TINYINT  DEFAULT 1;
		DECLARE existe_anio TINYINT  DEFAULT 1;
        
		DECLARE esta_desasignado TINYINT  DEFAULT 1;
		DECLARE esta_asignado TINYINT  DEFAULT 1;

		DECLARE nota_repetida TINYINT  DEFAULT 1;
		DECLARE id_habilitacion_hab INTEGER UNSIGNED; #guarda el id habilitacion

		# Verificiar que existe carnet
        SELECT EXISTS(SELECT carnet FROM estudiante WHERE i_carnet=carnet) INTO existe_carnet;
        
		# Verificiar que existe curso
        SELECT EXISTS(SELECT codigo FROM curso WHERE i_codigo_curso=codigo) INTO existe_curso;
		
        # Verificar formato ciclo valido
		SELECT verificarCiclo(i_ciclo) INTO f_ciclo_valido;
	
		# Verificar formato seccion valida
		SELECT valoresSeccion(i_seccion) INTO f_seccion_valida;   
       
       
       # verificar nota positiva
		SELECT isPositive(i_nota) INTO f_nota_positiva;

		IF existe_curso=1 AND f_ciclo_valido=1 AND f_seccion_valida=1 AND existe_carnet=1 AND f_nota_positiva=1 THEN
			#verificar si hace match con seccion, ciclo y anio actual-> existe la seccion
			SELECT EXISTS(SELECT seccion  FROM habilitacion WHERE seccion=i_seccion AND i_codigo_curso=codigo AND  YEAR(CURDATE())=YEAR(fecha_creacion)) INTO existe_seccion;
            SELECT EXISTS(SELECT ciclo FROM habilitacion WHERE ciclo=i_ciclo AND i_codigo_curso=codigo  AND  YEAR(CURDATE())=YEAR(fecha_creacion)) INTO existe_ciclo;
            SELECT EXISTS(SELECT fecha_creacion FROM habilitacion WHERE YEAR(CURDATE())=YEAR(fecha_creacion) AND i_codigo_curso=codigo) INTO existe_anio;
            
            
			IF existe_seccion=1 AND existe_ciclo=1 AND  existe_anio=1 THEN
				# Verifiacion de repetido
				SELECT id_habilitacion FROM habilitacion WHERE i_ciclo=ciclo AND i_seccion=seccion AND i_codigo_curso=codigo AND YEAR(CURDATE())=YEAR(fecha_creacion) INTO id_habilitacion_hab;
							
                SELECT EXISTS(SELECT carnet FROM desasignacion WHERE i_carnet=carnet AND id_habilitacion=id_habilitacion_hab) INTO esta_desasignado;
				SELECT EXISTS(SELECT carnet FROM asignacion WHERE i_carnet=carnet AND id_habilitacion=id_habilitacion_hab) INTO esta_asignado;
                
                SELECT EXISTS(SELECT carnet FROM nota WHERE i_carnet=carnet AND id_habilitacion=id_habilitacion_hab) INTO nota_repetida;
				IF esta_desasignado=0 THEN
					IF esta_asignado=1 THEN
						IF nota_repetida=0 THEN
							INSERT INTO nota(codigo,carnet,ciclo,seccion,nota,fecha_creacion,id_habilitacion)  VALUE (i_codigo_curso,i_carnet,i_ciclo,i_seccion,ROUND(i_nota),CURDATE(),id_habilitacion_hab);	
							IF ROUND(i_nota)>=61 THEN
								UPDATE estudiante es INNER JOIN curso cur SET es.creditos=es.creditos+cur.creditos_otorga WHERE i_carnet=es.carnet AND i_codigo_curso=cur.codigo;
							END IF;
                            
							SELECT CONCAT("Se ingresó nota del curso correctamente") AS "Respuesta";
						ELSE
							SELECT CONCAT("Codigo curso: ",i_codigo_curso ," - ya se ingresó nota") AS "Error";
						END IF;
					
                    ELSE
						SELECT CONCAT("Estudiante: ",i_carnet ," - no está asignado al curso - ", i_codigo_curso, " - Seccion( ",i_seccion," ) - Año( ",YEAR(CURDATE())," )") AS "Error";
	
                    END IF;
	
                ELSE
					SELECT CONCAT("Ingreso nota: Carnet ", i_carnet, " está desasignado") AS "Error";
                END IF;
                
			ELSE
				# Errores de existencia
				IF existe_seccion=0  THEN
					SELECT CONCAT("Sección: ", i_seccion ," - esta sección no corresponde al curso") AS "Error";
				ELSEIF existe_ciclo=0 THEN
					SELECT CONCAT("Ciclo: ",i_ciclo," - no corresponde al curso") AS 'Error';
				ELSEIF  existe_anio=0 THEN
					SELECT CONCAT("Año : ",i_seccion," - no corresponde al curso") AS 'Error';
				END IF;
            
			END IF;
        
        ELSE
			# Error curso no existe - Error formatos no validos
			IF existe_curso=0  THEN
				SELECT CONCAT("Código de curso: ", i_codigo_curso," - este curso no existe") AS "Error";
			ELSEIF existe_carnet=0 THEN
				SELECT CONCAT("Carnet: ", i_carnet," - no existe") AS "Error";
            ELSEIF f_ciclo_valido=0 THEN
				SELECT CONCAT("Ciclo: ",i_ciclo," - formato no válido") AS 'Error';
            ELSEIF  f_seccion_valida=0 THEN
				SELECT CONCAT("Sección: ",i_seccion," - formato no válido") AS 'Error';
			ELSEIF  f_nota_positiva=-1 THEN
				SELECT CONCAT("Nota: ",i_nota," - debe ser positiva") AS 'Error';             
                
            END IF;
        END IF;

        
        
        
        
	END //

DELIMITER ;


# Procedure para generar acta ----------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS generarActa(
	IN i_codigo_curso INTEGER,
	IN i_ciclo VARCHAR(3),
    IN i_seccion CHAR(1)
)
	BEGIN
		DECLARE existe_curso TINYINT DEFAULT 1;     # bool->  existe curso
		DECLARE f_ciclo_valido   TINYINT DEFAULT 1;   #bool-> formati ciclo valido
		DECLARE f_seccion_valida TINYINT DEFAULT 1; #bool-> formato seccion valido
    
		DECLARE existe_seccion TINYINT  DEFAULT 1; 
		DECLARE existe_ciclo TINYINT  DEFAULT 1;
		DECLARE existe_anio TINYINT  DEFAULT 1;
		DECLARE id_habilitacion_hab INTEGER UNSIGNED; #guarda el id habilitacion
		DECLARE cantidad_asignados_habilitado SMALLINT UNSIGNED DEFAULT 0;
		DECLARE cantidad_notas_habilitado SMALLINT UNSIGNED DEFAULT 0;
		DECLARE hay_asignados SMALLINT UNSIGNED DEFAULT 0;
		DECLARE acta_repetida TINYINT  DEFAULT 1;

			
		SELECT EXISTS(SELECT codigo FROM curso WHERE i_codigo_curso=codigo) INTO existe_curso;

        # Verificar formato ciclo valido
		SELECT verificarCiclo(i_ciclo) INTO f_ciclo_valido;
		# Verificar formato seccion valida
		SELECT valoresSeccion(i_seccion) INTO f_seccion_valida;         
        
		IF existe_curso=1 AND f_ciclo_valido=1 AND f_seccion_valida=1 THEN
			#verificar si hace match con seccion, ciclo y anio actual-> existe la seccion
			SELECT EXISTS(SELECT seccion  FROM habilitacion WHERE seccion=i_seccion AND i_codigo_curso=codigo AND  YEAR(CURDATE())=YEAR(fecha_creacion)) INTO existe_seccion;
            SELECT EXISTS(SELECT ciclo FROM habilitacion WHERE ciclo=i_ciclo AND i_codigo_curso=codigo  AND  YEAR(CURDATE())=YEAR(fecha_creacion)) INTO existe_ciclo;
            SELECT EXISTS(SELECT fecha_creacion FROM habilitacion WHERE YEAR(CURDATE())=YEAR(fecha_creacion) AND i_codigo_curso=codigo) INTO existe_anio;
			
            IF existe_seccion=1 AND existe_ciclo=1 AND  existe_anio=1 THEN
				SELECT id_habilitacion FROM habilitacion WHERE i_ciclo=ciclo AND i_seccion=seccion AND i_codigo_curso=codigo AND YEAR(CURDATE())=YEAR(fecha_creacion) INTO id_habilitacion_hab;
				SELECT cantidad_asignados FROM habilitacion  WHERE id_habilitacion_hab=id_habilitacion INTO hay_asignados;
                
				SELECT COUNT(est.carnet)
				FROM estudiante est 
				INNER JOIN asignacion ON asignacion.carnet=est.carnet AND asignacion.id_habilitacion=id_habilitacion_hab AND est.carnet NOT IN (SELECT carnet FROM desasignacion WHERE id_habilitacion=id_habilitacion_hab) into cantidad_asignados_habilitado ;

                
                SELECT COUNT(nt.carnet) FROM nota nt  WHERE nt.id_habilitacion=id_habilitacion_hab INTO cantidad_notas_habilitado;
				
                SELECT EXISTS(SELECT id_acta FROM acta WHERE id_habilitacion=id_habilitacion_hab) INTO acta_repetida;

                IF hay_asignados>0 THEN
					IF acta_repetida=0 THEN
						IF cantidad_notas_habilitado=cantidad_asignados_habilitado THEN
							INSERT INTO acta (codigo,fecha_hora,ciclo,seccion,id_habilitacion) VALUE (i_codigo_curso,NOW(),i_ciclo,i_seccion,id_habilitacion_hab);
							SELECT CONCAT("Acta generada correctamente ( Año: ", YEAR(CURDATE()) ," Curso: ", i_codigo_curso," Seccion: ", i_seccion, " Ciclo: ", i_ciclo," )") AS 'Respuesta';
						ELSE
							SELECT CONCAT("Error: No se han ingresado todas las notas de los estudiantes") AS "Error";                
						END IF;
					ELSE
						SELECT CONCAT("Esta acta ya se generó ( Año: ", YEAR(CURDATE()) ," Curso: ", i_codigo_curso," Seccion: ", i_seccion, " Ciclo: ", i_ciclo," )") AS "Error";                
                    END IF;
                    
                    

                ELSE
					SELECT CONCAT("No hay estudiantes asignados para generar acta ( Año: ", YEAR(CURDATE()) ," Curso: ", i_codigo_curso," Seccion: ", i_seccion, " Ciclo: ", i_ciclo," )") AS "Error";                
                END IF;
            ELSE
				# Errores de existencia
				IF existe_seccion=0  THEN
					SELECT CONCAT("Sección: ", i_seccion ," - esta sección no corresponde al curso") AS "Error";
				ELSEIF existe_ciclo=0 THEN
					SELECT CONCAT("Ciclo: ",i_ciclo," - no corresponde al curso") AS 'Error';
				ELSEIF  existe_anio=0 THEN
					SELECT CONCAT("Año : ",i_seccion," - no corresponde al curso") AS 'Error';
				END IF;
                
			END IF;
        ELSE
			# Error curso no existe - Error formatos no validos
			IF existe_curso=0  THEN
				SELECT CONCAT("Código de curso: ", i_codigo_curso," - este curso no existe") AS "Error";
            ELSEIF f_ciclo_valido=0 THEN
				SELECT CONCAT("Ciclo: ",i_ciclo," - formato no válido") AS 'Error';
            ELSEIF  f_seccion_valida=0 THEN
				SELECT CONCAT("Sección: ",i_seccion," - formato no válido") AS 'Error';           
            END IF;        
        END IF;
    END //

DELIMITER ;