# function para verificar correo valido en la facultad ----------------------------------------------------------
CREATE FUNCTION IF NOT EXISTS isValidEmail(i_email VARCHAR(50)) 
	RETURNS TINYINT DETERMINISTIC
	RETURN (SELECT i_email REGEXP '^[a-zA-Z0-9]+((\.[a-zA-Z0-9]+)|(\_[a-zA-Z0-9]+))?@[a-zA-Z]+(\.[a-zA-Z]+)+$');
	# 1 si es valido
    # 0 no es valido
#----------------------------------------------------------------------------------------------------------------	

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