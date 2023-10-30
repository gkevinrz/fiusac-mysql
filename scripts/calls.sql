# Creacion de carreras
CALL crearCarrera('Ingenieria Civil');       -- 1  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Industrial');  -- 2  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Sistemas');    -- 3  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Electronica'); -- 4  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Mecanica');    -- 5  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Mecatronica'); -- 6  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Quimica');     -- 7  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Ambiental');   -- 8  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Materiales');  -- 9  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
CALL crearCarrera('Ingenieria Textil');      -- 10 VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE

/*----------------------------------------------------------------------------------------------------*/
#Creacion Docentes
CALL registrarDocente('Docente1','Apellido1','30-10-1999','aadf@ingenieria.usac.edu.gt',12345678,'direccion',12345678910,1);
CALL registrarDocente('Docente2','Apellido2','20-11-1999','docente2@ingenieria.usac.edu.gt',12345678,'direcciondocente2',12345678911,2);
CALL registrarDocente('Docente3','Apellido3','20-12-1980','docente3@ingenieria.usac.edu.gt',12345678,'direcciondocente3',12345678912,3);
CALL registrarDocente('Docente4','Apellido4','20-11-1981','docente4@ingenieria.usac.edu.gt',12345678,'direcciondocente4',12345678913,4);
CALL registrarDocente('Docente5','Apellido5','20-09-1982','docente5@ingenieria.usac.edu.gt',12345678,'direcciondocente5',12345678914,5);

/*--------------------------------------------------------------------------------*/
# Registro estudiantes
-- SISTEMAS
CALL registrarEstudiante(202000001,'Estudiante de','Sistemas Uno','30-10-1999','sistemasuno@gmail.com',12345678,'direccion estudiantes sistemas 1',337859510101,3);
CALL registrarEstudiante(202000002,'Estudiante de','Sistemas Dos','3-5-2000','sistemasdos@gmail.com',12345678,'direccion estudiantes sistemas 2',32781580101,3);
CALL registrarEstudiante(202000003,'Estudiante de','Sistemas Tres','3-5-2002','sistemastres@gmail.com',12345678,'direccion estudiantes sistemas 3',32791580101,3);
-- CIVIL
CALL registrarEstudiante(202100001,'Estudiante de','Civil Uno','3-5-1990','civiluno@gmail.com',12345678,'direccion de estudiante civil 1',3182781580101,1);
CALL registrarEstudiante(202100002,'Estudiante de','Civil Dos','03-08-1998','civildos@gmail.com',12345678,'direccion de estudiante civil 2',3181781580101,1);
-- INDUSTRIAL
CALL registrarEstudiante(202200001,'Estudiante de','Industrial Uno','30-10-1999','industrialuno@gmail.com',12345678,'direccion de estudiante industrial 1',3878168901,2);
CALL registrarEstudiante(202200002,'Estudiante de','Industrial Dos','20-10-1994','industrialdos@gmail.com',89765432,'direccion de estudiante industrial 2',29781580101,2);
-- ELECTRONICA
CALL registrarEstudiante(202300001, 'Estudiante de','Electronica Uno','20-10-2005','electronicauno@gmail.com',89765432,'direccion de estudiante electronica 1',29761580101,4);
CALL registrarEstudiante(202300002, 'Estudiante de','Electronica Dos', '01-01-2008','electronicados@gmail.com',12345678,'direccion de estudiante electronica 2',387916890101,4);
-- ESTUDIANTES RANDOM
CALL registrarEstudiante(201710160, 'ESTUDIANTE','SISTEMAS RANDOM','20-08-1994','estudiasist@gmail.com',89765432,'direccionestudisist random',29791580101,3);
CALL registrarEstudiante(201710161, 'ESTUDIANTE','CIVIL RANDOM','20-08-1995','estudiacivl@gmail.com',89765432,'direccionestudicivl random',30791580101,1);
/*------------------------------------------------------------------------*/

-- aqui se debe de agregar el AREA COMUN a carrera
-- Insertar el registro con id 0
INSERT INTO carrera (id_carrera,nombre) VALUES (0,'Area Comun');
UPDATE carrera SET id_carrera = 0 WHERE id_carrera = LAST_INSERT_ID();


/*---------------------------------------------------------------------------*/
# Crear curso
-- AREA COMUN
CALL crearCurso(0006,'Idioma Tecnico 1',0,7,0,false); 
CALL crearCurso(0007,'Idioma Tecnico 2',0,7,0,false);
CALL crearCurso(101,'MB 1',0,7,0,true); 
CALL crearCurso(103,'MB 2',0,7,0,true); 
CALL crearCurso(017,'SOCIAL HUMANISTICA 1',0,4,0,true); 
CALL crearCurso(019,'SOCIAL HUMANISTICA 2',0,4,0,true); 
CALL crearCurso(348,'QUIMICA GENERAL',0,3,0,true); 
CALL crearCurso(349,'QUIMICA GENERAL LABORATORIO',0,1,0,true);
-- INGENIERIA EN SISTEMAS
CALL crearCurso(777,'Compiladores 1',80,4,3,true); 
CALL crearCurso(770,'INTR. A la Programacion y computacion 1',0,4,3,true); 
CALL crearCurso(960,'MATE COMPUTO 1',33,5,3,true); 
CALL crearCurso(795,'lOGICA DE SISTEMAS',33,2,3,true);
CALL crearCurso(796,'LENGUAJES FORMALES Y DE PROGRAMACIÓN',0,3,3,TRUE);
-- INGENIERIA INDUSTRIAL
CALL crearCurso(123,'Curso Industrial 1',0,4,2,true); 
CALL crearCurso(124,'Curso Industrial 2',0,4,2,true);
CALL crearCurso(125,'Curso Industrial enseñar a pensar',10,2,2,false);
CALL crearCurso(126,'Curso Industrial ENSEÑAR A DIBUJAR',2,4,2,true);
CALL crearCurso(127,'Curso Industrial 3',8,4,2,true);
-- INGENIERIA CIVIL
CALL crearCurso(321,'Curso Civil 1',0,4,1,true);
CALL crearCurso(322,'Curso Civil 2',4,4,1,true);
CALL crearCurso(323,'Curso Civil 3',8,4,1,true);
CALL crearCurso(324,'Curso Civil 4',12,4,1,true);
CALL crearCurso(325,'Curso Civil 5',16,4,1,false);
CALL crearCurso(0250,'Mecanica de Fluidos',0,5,1,true);
-- INGENIERIA ELECTRONICA
CALL crearCurso(421,'Curso Electronica 1',0,4,4,true);
CALL crearCurso(422,'Curso Electronica 2',4,4,4,true);
CALL crearCurso(423,'Curso Electronica 3',8,4,4,false);
CALL crearCurso(424,'Curso Electronica 4',12,4,4,true);
CALL crearCurso(425,'Curso Electronica 5',16,4,4,true);



/*------------------------------------------------------------------------------------------*/
# Habilitar Curso

-- IDIOMA TECNICO -----------------------------------------------------------
CALL habilitarCurso(0006,"1S",1,110,"A");
CALL habilitarCurso(0006,"VJ",1,110,"P");
CALL habilitarCurso(0006,"2S",1,110,"A");
CALL habilitarCurso(0006,"2S",1,110,"B");

CALL habilitarCurso(101,"1S",2,110,"C");




# Agregar horario ----------------------------------------------------------------------------------------------
/* ------IDIOMA TECNICO HORARIO -------------------------------------*/

call agregarHorario(1,1,'07:00-09:00');
call agregarHorario(1,2,'10:00-10:50');
call agregarHorario(1,3,'07:00-09:00');
call agregarHorario(1,4,'07:00-09:00');
call agregarHorario(1,5,'07:00-09:00');

call agregarHorario(2,1,'17:00-19:00');
call agregarHorario(2,2,'17:00-19:00');
call agregarHorario(2,3,'17:00-19:00');
call agregarHorario(2,4,'17:00-19:00');
call agregarHorario(2,5,'17:00-19:00');


call agregarHorario(3,1,'07:00-09:00');
call agregarHorario(3,2,'10:00-10:50');
call agregarHorario(3,3,'07:00-09:00');
call agregarHorario(3,4,'07:00-09:00');
call agregarHorario(3,5,'07:00-09:00');

call agregarHorario(4,1,'07:00-09:00');
call agregarHorario(4,2,'10:00-10:50');
call agregarHorario(4,3,'07:00-09:00');
call agregarHorario(4,4,'07:00-09:00');
call agregarHorario(4,5,'07:00-09:00');


call agregarHorario(5,1,'07:00-09:00');
call agregarHorario(5,2,'10:00-10:50');
call agregarHorario(5,3,'07:00-09:00');
call agregarHorario(5,4,'07:00-09:00');
call agregarHorario(5,5,'07:00-09:00');


/* -----------------------------------------*/

# Asignar Curso -------------------------------------------------------------

CALL asignarCurso(0006,"1S","A",202000001);
CALL asignarCurso(0006,"1S","A",202000002);
CALL asignarCurso(0006,"1S","A",202000003);
CALL asignarCurso(0006,"1S","A",202100001);
CALL asignarCurso(0006,"1S","A",202200001);

CALL asignarCurso(0006,"2S","A",201710161);
CALL asignarCurso(0006,"2S","A",201710160);
CALL asignarCurso(0006,"2S","A",202300002);
CALL asignarCurso(0006,"2S","A",202300001);
CALL asignarCurso(0006,"2S","A",202200001);


CALL asignarCurso(101,"1S","C",202100002);

#Prueba año 2024
CALL asignarCurso2(101,"1S","A",201906558);


/* Desasignacion de cursos -----------------------------------------------*/
CALL desasignarCurso(0006,"1S","B",202000001);
SELECT COUNT(asg.carnet) FROM asignacion asg INNER JOIN desasignacion dsg WHERE asg.carnet<>dsg.carnet AND  asg.id_habilitacion=1 AND dsg.id_habilitacion=1;




/* Ingreso de notas ------------------------------------------------------------------------*/
CALL ingresarNota(0006,"1S","A",202000002,60.5);
CALL ingresarNota(0006,"1S","A",202000003,98.5);
CALL ingresarNota(0006,"1S","A",202100001,98.5);
CALL ingresarNota(0006,"1S","A",202200001,45.43);

CALL ingresarNota(0006,"2S","A",201710161,60.5);
CALL ingresarNota(0006,"2S","A",201710160,98.5);
CALL ingresarNota(0006,"2S","A",202300002,98.5);
CALL ingresarNota(0006,"2S","A",202300001,45.43);
CALL ingresarNota(0006,"2S","A",202200001,100);

CALL ingresarNota(101,"1S","C",202100002,60.5);

/* Generar Acta -----------------------------------------------------------------------*/
				SELECT COUNT(est.carnet)
				FROM estudiante est 
				INNER JOIN asignacion ON asignacion.carnet=est.carnet AND asignacion.id_habilitacion=1 AND est.carnet NOT IN (SELECT carnet FROM desasignacion WHERE id_habilitacion=3);
			


CALL generarActa(0006,"1S","A");
CALL generarActa(0006,"2S","A");
CALL generarActa(101,"1S","C");


SELECT COUNT(asg.carnet) FROM asignacion asg INNER JOIN desasignacion dsg WHERE asg.carnet<>dsg.carnet AND  asg.id_habilitacion=id_habilitacion_hab AND dsg.id_habilitacion=id_habilitacion_hab INTO cantidad_asignados_habilitado;

SELECT COUNT(nt.carnet) FROM nota nt  WHERE nt.id_habilitacion=1;
SELECT COUNT(asg.carnet) FROM asignacion asg INNER JOIN desasignacion dsg WHERE asg.carnet<>dsg.carnet AND  asg.id_habilitacion=1 AND dsg.id_habilitacion=1;



SELECT COUNT(asg.carnet) FROM asignacion asg INNER JOIN desasignacion dsg WHERE asg.carnet<>dsg.carnet AND asg.id_habilitacion=3 AND dsg.id_habilitacion=3;

/*------------------------------------------------EXTRAS--------------------------------------------------------------------------*/
INSERT INTO habilitacion (ciclo,seccion,cupo_maximo,fecha_creacion,codigo,siif) VALUE ("1S","A",110,"2024-10-19",101,11101600);
 SELECT DATE_FORMAT(STR_TO_DATE('30-10-1999','%d-%m-%Y'), '%Y-%m-%d');
select * from carrera;	
select * from estudiante;
select * from curso;	
select * from docente;	
            SELECT est.carnet AS 'Carnet' ,CONCAT(est.nombres," ",est.apellidos) AS 'Nombre Completo', est.creditos AS 'Creditos'
            FROM estudiante est 
            INNER JOIN desasignacion ON est.carnet<>desasignacion.carnet AND desasignacion.id_habilitacion=2
            INNER JOIN asignacion ON asignacion.carnet=est.carnet AND 2=asignacion.id_habilitacion;


select * from habilitacion;	
select * from horario;	
select * from asignacion;	
select * from desasignacion;	
select * from nota;	
select * from acta;	

drop table estudiante;
drop table carrera;
drop table horario;
drop table docente;
drop table curso;
drop table habilitacion;
drop table asignacion;
drop table desasignacion;
drop table nota;
drop table acta;

