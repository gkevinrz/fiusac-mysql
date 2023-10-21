# Creacion de carreras
CALL crearCarrera("ingeniería en ciencias y sistemas");
CALL crearCarrera("Ingeniería Civil");
CALL crearCarrera("Ingeniería Electrónica");
CALL crearCarrera("Ingeniería Eléctrica");
CALL crearCarrera("Ingeniería Industrial");
CALL crearCarrera("Ingeniería Mecánica");
CALL crearCarrera("Ingeniería de Alimentos");


/*----------------------------------------------------------------------------------------------------*/
# Creacion de estudiantes
call registrarEstudiante(201906558,'Eddy Fernando','Diaz Galindo','2002-10-16','ediaz3535@gmail.com'
                        ,35517835,'Guatemala City, GT', 1234567891234,1);

call registrarEstudiante(201801558,'Jose Eduardo','Avila Guzman','2001-01-16','jeaguzm@gmail.com'
                        ,55618865,'Guatemala City, GT', 2234567891234,2);

call registrarEstudiante(201702558,'Mariana Margarita','Gomez Carrillo','2000-05-10','mmmez@gmail.com'
                        ,45567831,'Guatemala City, GT', 3234567891234,3);

call registrarEstudiante(201603558,'Robin Omar','Buezo Biz','2000-04-30','robb1@gmail.com'
                        ,45618895,'Guatemala City, GT', 4234567891234,4);

call registrarEstudiante(201504558,'Julio Estuardo','Jerez Juarez','1995-10-16','jejez@gmail.com'
                        ,65517939,'Guatemala City, GT', 5234567891234,1);

call registrarEstudiante(201405558,'David Alejandro','Alonzo Jerez','1994-12-16','dalonz@gmail.com'
                        ,66557131,'Guatemala City, GT', 6234567891234,2);


/*  -------------------------------------------------------------------------------------------------*/
# Creacion de docentes

call registrarDocente(11101900,'Carlos Augusto','Morales Santacruz','1970-10-08','camsanta@gmail.com',
                    66443948,'Guatemala City, GT',7891234567891);

call registrarDocente(11101899,'Gabriel Estuardo', 'Solorzano Castellanos','1988-12-08','gabolor@gmail.com',
                    66334448,'Guatemala City, GT',8891234567891);

call registrarDocente(11101710,'Marlon Francisco','Orellana Lopez','1978-10-08','marisco@gmail.com',
                    55453648,'Guatemala City, GT',9991234567891);

call registrarDocente(11101600,'Armando','Fuentes Roca','1980-11-18','roquita@gmail.com',
                    36352141,'Guatemala City, GT',1891234567891);

call registrarDocente(11101501,'Alvaro Obrayan','Hernandez Garcia','1988-08-08','obragud@gmail.com',
                    55113228,'Guatemala City, GT',2893234567891); 



/*--------------------------------------------------------------------------------*/
# Crear curso
call crearCurso(101, 'Mate Basica 1',0,10,1, 0);
call crearCurso(107, 'Mate Intermedia 1',10,10,1,0);
call crearCurso(122, 'Mate Aplicada 4',4,4,0,0);
call crearCurso(150, 'Fisica 1',6,6,1,0);
call crearCurso(732, 'Estadistica 1',5,6,1,0);

call crearCurso(772, 'Estructura de datos',0,10,1,1);
call crearCurso(773, 'Manejo e implementacion de Archivos',20,4,1,1);
call crearCurso(964, 'Organizacion Computacional',4,5,1,1);
call crearCurso(795, 'Logica de Sistemas',0,5,1,1);
call crearCurso(796, 'Lenguajes Formales y De Programacion',0,8,1,1);

call crearCurso(550, 'Vias Terrestres 1',0,6,1,3);
call crearCurso(560, 'Vias Terrestres 2',0,6,0,3);
call crearCurso(570, 'Transportes',0,4,0,3);
call crearCurso(580, 'Ingenieria de Transito',0,4,0,3);
call crearCurso(460, 'Pavimentos',0,5,0,3);



/*------------------------------------------------------------------------------------------*/
# Habilitar Curso
CALL habilitarCurso(101,11101900,"1S","A",110);
CALL habilitarCurso(101,11101900,"2S","A",110);
CALL habilitarCurso(101,11101900,"VJ","Z",110);

CALL habilitarCurso(732,11101600,"2S","C",110);
CALL habilitarCurso(732,11101600,"1S","P",110);



# Agregar horario ----------------------------------------------------------------------------------------------

call agregarHorario(1,1,'07:00-09:00');
call agregarHorario(1,2,'10:00-10:50');
call agregarHorario(1,3,'07:00-09:00');
call agregarHorario(1,4,'07:00-09:00');
call agregarHorario(1,5,'07:00-09:00');
call agregarHorario(3,1,'17:00-19:00');

/*------------------------------------------------------------------------*/

# Asignar Curso -------------------------------------------------------------
CALL asignarCurso(
1001,"1S","A",201901331
);
CALL asignarCurso(
1000,"2S","A",201901336
);

CALL asignarCurso2(
1000,"VJ","V",201901336
);

/*--------------------------------------------------------------------------------------------------------------------------*/
#INSERT INTO habilitacion (ciclo,seccion,cupo_maximo,fecha_creacion,codigo,siif) VALUE ("VD","V",110,"2024-10-19",1001,2019);
#INSERT INTO habilitacion (ciclo,seccion,cupo_maximo,fecha_creacion,codigo,siif) VALUE ("VJ","V",110,"2024-10-19",1000,2019);

 
select * from carrera;	
select * from estudiante;
select * from curso;	
select * from habilitacion;	
select * from horario;	
select * from asignacion;	
select * from docente;	

describe curso;

drop table estudiante;
drop table horario;
drop table docente;
drop table curso;
drop table habilitacion;
drop table asignacion;


