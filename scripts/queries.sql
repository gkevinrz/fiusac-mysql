
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

# QUERY 3  Consultar Docente
# Informacion del docente

