# function para verificar correo valido en la facultad ----------------------------------------------------------
CREATE FUNCTION IF NOT EXISTS isValidEmail(i_email VARCHAR(50)) 
	RETURNS TINYINT DETERMINISTIC
	RETURN (SELECT i_email REGEXP '^[a-zA-Z0-9]+((\.[a-zA-Z0-9]+)|(\_[a-zA-Z0-9]+))?@[a-zA-Z]+(\.[a-zA-Z]+)+$');
	# 1 si es valido
    # 0 no es valido

# Function para verificar solo letras-------------------------------------------------------------------------------
CREATE FUNCTION IF NOT EXISTS onlyLetters(i_cadena VARCHAR(50) CHARACTER SET utf8mb4)
	RETURNS TINYINT DETERMINISTIC
    RETURN  (SELECT i_cadena REGEXP '^[a-zA-Zaáéíóú ]+$');
	# 1 solo letras
    # 0 no son solo letras
    
    
# Function validar solo positivos--------------------------------------------------------------------
CREATE FUNCTION IF NOT EXISTS isPositive(i_numero INTEGER)
	RETURNS TINYINT DETERMINISTIC
    RETURN SIGN(i_numero);
	# 0 si es 0
    # 1 si es sin signo
    #-1 con signo
    
    
 # Function verificar ciclo   
 CREATE FUNCTION IF NOT EXISTS verificarCiclo(i_ciclo VARCHAR(3))
	RETURNS TINYINT DETERMINISTIC
    RETURN (SELECT i_ciclo REGEXP '^VD|VJ|1S|2S$'); 
    
 # Function para verificar seccion valida   
 CREATE FUNCTION IF NOT EXISTS valoresSeccion(i_seccion CHAR(1))
	RETURNS TINYINT DETERMINISTIC
    RETURN (SELECT i_seccion REGEXP '^[A-Z]$'); 
    
    
# Function para verificar rango dia
 CREATE FUNCTION IF NOT EXISTS verificarDia(i_dia TINYINT)
	RETURNS TINYINT DETERMINISTIC
    RETURN (SELECT i_dia REGEXP '^[1-7]$'); 


# Function para verificar formato de horario
 CREATE FUNCTION IF NOT EXISTS verificarHorario(i_horario VARCHAR(15))
	RETURNS TINYINT DETERMINISTIC
    RETURN (SELECT i_horario REGEXP '^((2[0-3]:[0-5][0-9])|[0-1][0-9]:[0-5][0-9])-((2[0-3]:[0-5][0-9])|[0-1][0-9]:[0-5][0-9])$'); 

