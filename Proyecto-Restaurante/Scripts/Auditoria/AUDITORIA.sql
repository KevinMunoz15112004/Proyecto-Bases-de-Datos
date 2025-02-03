-- Desde los provilegios de administrador activamos los logs binario para auditoria
set global log_bin = "ON";

-- Se crea una tabla adicional para almacenar el registro de actualizacion
create table Restaurante_Auditoria (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Usuario VARCHAR(50),
    Accion VARCHAR(255),
    Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Proceso para crear el registro de actualizacion a los datos mediante un trigger
DELIMITER $$
create trigger log_cliente_actualizar 
after update on Restaurante.Cliente
FOR EACH ROW
BEGIN
    INSERT INTO Restaurante_Auditoria (Usuario, Accion)
    VALUES (CURRENT_USER(), CONCAT('Actualización en ClienteID: ', OLD.ClienteID));
END $$
DELIMITER ;
