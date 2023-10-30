/*-------------------------------------------------------------------------------*/
# QUERY 1  (Consultar pensum ) 
# Listado de cursos de una carrera y area comun ---------------
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarPensum(
	IN i_id_carrera INTEGER UNSIGNED
)
	BEGIN 
		DECLARE existe_carrera TINYINT DEFAULT 1;
		SELECT EXISTS(SELECT id_carrera FROM carrera WHERE i_id_carrera=id_carrera) INTO existe_carrera;
        
        IF existe_carrera=1 THEN
			SELECT codigo AS 'Código del curso',
			nombre AS 'Nombre del curso',
			if(obligatorio=1,'Si','No') AS 'Obligatorio',
			creditos_necesarios AS 'Créditos necesarios'
			FROM curso
			WHERE i_id_carrera=id_carrera OR id_carrera=0;	  
		ELSE
			SELECT CONCAT("Carrera: codigo ",i_id_carrera," no existe") AS 'Error';
        END IF;
    END //
DELIMITER ;

CALL consultarPensum(1);



/*-------------------------------------------------------------------------------*/
# QUERY 2  (Consultar estudiante ) 
# Listado de informacion sobre estudiante
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarEstudiante(
	IN i_carnet BIGINT 
)
	BEGIN 
		DECLARE existe_carnet TINYINT DEFAULT 1;
		SELECT EXISTS(SELECT carnet FROM estudiante WHERE i_carnet=carnet) INTO existe_carnet;
        
        IF existe_carnet=1 THEN
			SELECT 
            carnet AS 'Carnet',
			CONCAT(nombres," ",apellidos) AS 'Nombre completo',
			DATE_FORMAT(fecha_nacimiento,'%d/%m/%Y') AS 'Fecha de nacimiento',
            correo AS 'Email', 
            telefono AS 'Teléfono',
            direccion AS 'Dirección',
            dpi AS 'DPI',
            (SELECT upper(c.nombre) FROM carrera c WHERE c.id_carrera=carrera) AS 'Carrera',
            creditos AS 'Cantidad de créditos'
            FROM estudiante	
			WHERE i_carnet=carnet; 
		ELSE
			SELECT CONCAT("Carnet: ",i_carnet," no existe") AS 'Error';
        END IF;
    END //
DELIMITER ;

call consultarEstudiante(201603558);




/*-------------------------------------------------------------------------------*/
# QUERY 3  Consultar Docente
# Informacion del docente
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarDocente(
	IN i_siif BIGINT 
)
	BEGIN 
		DECLARE existe_siif TINYINT DEFAULT 1;
		SELECT EXISTS(SELECT siif FROM docente WHERE i_siif=siif) INTO existe_siif;
        
        IF existe_siif=1 THEN
			SELECT 
            siif AS 'Registro SIIF',
			CONCAT(nombres," ",apellidos) AS 'Nombre completo',
			DATE_FORMAT(fecha_nacimiento,'%d/%m/%Y') AS 'Fecha de nacimiento',
            correo AS 'Email', 
            telefono AS 'Teléfono',
            direccion AS 'Dirección',
            dpi AS 'DPI'
            FROM docente	
			WHERE i_siif=siif; 
		ELSE
			SELECT CONCAT("Siif: ",i_siif," no existe") AS 'Error';
        END IF;
    END //
DELIMITER ;

call consultarDocente(2);


/*-------------------------------------------------------------------------------*/
# QUERY 4  Consultar estudiantes asignados
# listado de estudiantes asignados al curso y sección
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarAsignados(
	IN i_codigo_curso  INTEGER,   
	IN i_ciclo    VARCHAR(3),
	IN i_anio    INTEGER,
    IN i_seccion  CHAR(1)
)
	BEGIN 
		DECLARE existe_curso TINYINT DEFAULT 1;
		DECLARE f_ciclo_valido   TINYINT DEFAULT 1;   #bool-> formati ciclo valido
		DECLARE f_seccion_valida TINYINT DEFAULT 1; #bool-> formato seccion valido
		
		DECLARE id_habilitacion_hab INTEGER UNSIGNED; #guarda el id habilitacion

        SELECT EXISTS(SELECT codigo FROM curso WHERE i_codigo_curso=codigo) INTO existe_curso;
        
		# Verificar formato ciclo valido
		SELECT verificarCiclo(i_ciclo) INTO f_ciclo_valido;
		# Verificar formato seccion valida
		SELECT valoresSeccion(i_seccion) INTO f_seccion_valida;     
        
        IF existe_curso=1   AND f_ciclo_valido=1 AND f_seccion_valida=1 THEN
        
			SELECT id_habilitacion FROM habilitacion WHERE i_ciclo=ciclo AND i_seccion=seccion AND i_codigo_curso=codigo AND i_anio=YEAR(fecha_creacion) INTO id_habilitacion_hab;	
            
            SELECT est.carnet AS 'Carnet' ,CONCAT(est.nombres," ",est.apellidos) AS 'Nombre Completo', est.creditos AS 'Creditos'
            FROM estudiante est 
            INNER JOIN desasignacion ON est.carnet<>desasignacion.carnet AND desasignacion.id_habilitacion=id_habilitacion_hab
            INNER JOIN asignacion ON asignacion.carnet=est.carnet AND id_habilitacion_hab=asignacion.id_habilitacion;
	
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
CALL consultarAsignados(0006,"1S",2023,"A");


/*-------------------------------------------------------------------------------*/
# QUERY 5   Consultar aprobaciones
# Debe retornar el listado con el carnet del estudiante, y si aprobó o reprobó 
# el curso (nota de aprobación = 61)
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarAprobacion(
	IN i_codigo_curso  INTEGER,   
	IN i_ciclo    VARCHAR(3),
	IN i_anio    INTEGER,
    IN i_seccion  CHAR(1)
)
	BEGIN 
		DECLARE existe_curso TINYINT DEFAULT 1;
		DECLARE f_ciclo_valido   TINYINT DEFAULT 1;   #bool-> formati ciclo valido
		DECLARE f_seccion_valida TINYINT DEFAULT 1;   #bool-> formato seccion valido
		
		DECLARE id_habilitacion_hab INTEGER UNSIGNED; #guarda el id habilitacion

		# Verificar si existe curso
        SELECT EXISTS(SELECT codigo FROM curso WHERE i_codigo_curso=codigo) INTO existe_curso;
        
		# Verificar formato ciclo valido
		SELECT verificarCiclo(i_ciclo) INTO f_ciclo_valido;
		# Verificar formato seccion valida
		SELECT valoresSeccion(i_seccion) INTO f_seccion_valida;     
        
        IF existe_curso=1   AND f_ciclo_valido=1 AND f_seccion_valida=1 THEN
        
			SELECT id_habilitacion FROM habilitacion WHERE i_ciclo=ciclo AND i_seccion=seccion AND i_codigo_curso=codigo AND i_anio=YEAR(fecha_creacion) INTO id_habilitacion_hab;	
            
            SELECT nt.codigo AS 'Codigo de curso', est.carnet AS 'Carnet' ,CONCAT(est.nombres," ",est.apellidos) AS 'Nombre Completo',IF(nt.nota>=61,"APROBADO","DESAPROBADO") AS 'Estado'
            FROM estudiante est 
            INNER JOIN nota nt ON nt.carnet=est.carnet AND nt.id_habilitacion=id_habilitacion_hab;
	
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
CALL consultarAprobacion(0006,"1S",2023,"A");

/*-------------------------------------------------------------------------------*/
# QUERY 6
# Consultar actas 
# Debe retornar el listado de actas de un determinado curso y ordenarlo por 
# fecha y hora de generado
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarActas(
	IN i_codigo_curso  INTEGER
)
	BEGIN 
		DECLARE existe_curso TINYINT DEFAULT 1;
		DECLARE cantidad_asignados_habilitado SMALLINT UNSIGNED DEFAULT 0;

		# Verificar si existe curso
        SELECT EXISTS(SELECT codigo FROM curso WHERE i_codigo_curso=codigo) INTO existe_curso;
        IF existe_curso=1 THEN
			SELECT act.codigo AS 'Codigo de curso', 
					hab.seccion AS 'Seccion', 
                    IF(hab.ciclo="1S","PRIMER SEMESTRE",IF(hab.ciclo="2S","SEGUNDO SEMESTRE",IF(hab.ciclo="VJ","VACACIONES DE JUNIO",IF(hab.ciclo="VD","VACACIONES DE DICIEMBRE","ERR")))) AS 'Ciclo',
                    YEAR(DATE(act.fecha_hora)) AS 'Año',
					(SELECT COUNT(est.carnet)
					FROM estudiante est 
					INNER JOIN asignacion
                    ON asignacion.carnet=est.carnet AND asignacion.id_habilitacion=act.id_habilitacion AND est.carnet NOT IN (SELECT carnet FROM desasignacion WHERE id_habilitacion=act.id_habilitacion) ) AS 'Cantidad de estudiantes',
                    act.fecha_hora AS 'Fecha y hora de generacion'
			FROM acta act INNER JOIN habilitacion hab ON act.codigo=i_codigo_curso and act.id_habilitacion=hab.id_habilitacion ORDER BY act.fecha_hora DESC;
            
		ELSE
			SELECT CONCAT("Código de curso: ", i_codigo_curso," - este curso no existe") AS "Error";
        END IF;
    END //
DELIMITER ;
CALL consultarActas(101);
/*-------------------------------------------------------------------------------*/
# QUERY 7
# Consultar tasa de desasignación 
# Debe retornar el porcentaje de desasignación de un curso y sección
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarDesasignacion(
	IN i_codigo_curso  INTEGER,   
	IN i_ciclo    VARCHAR(3),
	IN i_anio    INTEGER,
    IN i_seccion  CHAR(1)
)
	BEGIN 
		DECLARE existe_curso TINYINT DEFAULT 1;
		DECLARE f_ciclo_valido   TINYINT DEFAULT 1;   #bool-> formati ciclo valido
		DECLARE f_seccion_valida TINYINT DEFAULT 1;   #bool-> formato seccion valido
		DECLARE asignadoss TINYINT DEFAULT 0;   #bool-> formato seccion valido
		DECLARE desasignadoss TINYINT DEFAULT 0;   #bool-> formato seccion valido

		DECLARE id_habilitacion_hab INTEGER UNSIGNED; #guarda el id habilitacion

		# Verificar si existe curso
        SELECT EXISTS(SELECT codigo FROM curso WHERE i_codigo_curso=codigo) INTO existe_curso;
        
		# Verificar formato ciclo valido
		SELECT verificarCiclo(i_ciclo) INTO f_ciclo_valido;
		# Verificar formato seccion valida
		SELECT valoresSeccion(i_seccion) INTO f_seccion_valida;     
        
        IF existe_curso=1   AND f_ciclo_valido=1 AND f_seccion_valida=1 THEN
			SELECT id_habilitacion FROM habilitacion WHERE i_ciclo=ciclo AND i_seccion=seccion AND i_codigo_curso=codigo AND i_anio=YEAR(fecha_creacion) INTO id_habilitacion_hab;	
		
			SELECT COUNT(est.carnet)
			FROM estudiante est 
			INNER JOIN asignacion
			ON asignacion.carnet=est.carnet AND asignacion.id_habilitacion=id_habilitacion_hab AND est.carnet NOT IN (SELECT carnet FROM desasignacion WHERE id_habilitacion=id_habilitacion_hab) INTO asignadoss;
		
        
			SELECT COUNT(est.carnet)
			FROM estudiante est 
			INNER JOIN desasignacion
			ON desasignacion.carnet=est.carnet AND desasignacion.id_habilitacion=id_habilitacion_hab  INTO desasignadoss;
          
			SELECT hab.codigo AS 'Codigo de curso', 
				   hab.seccion AS 'Seccion',
				   IF(hab.ciclo="1S","PRIMER SEMESTRE",IF(hab.ciclo="2S","SEGUNDO SEMESTRE",IF(hab.ciclo="VJ","VACACIONES DE JUNIO",IF(hab.ciclo="VD","VACACIONES DE DICIEMBRE","ERR")))) AS 'Ciclo',
					YEAR(hab.fecha_creacion) AS 'Año',
					(SELECT COUNT(est.carnet)
					FROM estudiante est 
					INNER JOIN asignacion
                    ON asignacion.carnet=est.carnet AND asignacion.id_habilitacion=id_habilitacion_hab AND est.carnet NOT IN (SELECT carnet FROM desasignacion WHERE id_habilitacion=id_habilitacion_hab) ) AS 'Cantidad de estudiantes asignados',
					
                    (SELECT COUNT(est.carnet)
					FROM estudiante est 
					INNER JOIN desasignacion
                    ON desasignacion.carnet=est.carnet AND desasignacion.id_habilitacion=id_habilitacion_hab) AS 'Cantidad de estudiantes desasignados',
						
					CONCAT(((desasignadoss/(desasignadoss+asignadoss))*100),"%") AS 'Porcentaje de desasignados'                    
					FROM habilitacion hab WHERE id_habilitacion_hab=hab.id_habilitacion;
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

CALL consultarDesasignacion(0006,"1S",2023,"A");