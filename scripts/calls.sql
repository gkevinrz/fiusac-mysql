# Creacion de carreras
CALL crearCarrera(
"ingeniería en ciencias y sistemas"
);
# Creacion de estudiantes
CALL registrarEstudiante(
201901336,"Renato","Astling","2023-02-25","rastt.12@gnu.org",58373328,"2 4th Point",3097828252563,9
);
# Creacion de docentes
CALL registrarDocente(
202003791,"Profesor ","Enriquez","2023-02-25","ras2tt.12@gnu.org",58373321,"2 4th Point",3097328252565
);

# Crear curso
CALL crearCurso(
1000,"Compiladores 2",10,10,1,0
);
# Habilitar Curso


select * from curso;	
describe curso;
drop table docente;
