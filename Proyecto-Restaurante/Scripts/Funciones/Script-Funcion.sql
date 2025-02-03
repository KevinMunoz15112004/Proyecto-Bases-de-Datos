CREATE DATABASE Restaurante_Funcion;

USE Restaurante_Funcion;

CREATE TABLE Cliente(
	ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Correo VARCHAR(100) UNIQUE NOT NULL,
    Edad INT NOT NULL
);

CREATE TABLE Reserva(
	ReservaID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT NOT NULL,
    FechaReserva TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Estado ENUM("Confirmado", "Cancelado") NOT NULL,
    CONSTRAINT fk_cliente_reserva FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID) 
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Pago(
	PagoID INT AUTO_INCREMENT PRIMARY KEY,
    ReservaID INT NOT NULL,
    Cantidad DECIMAL(10, 2) NOT NULL,
    MetodoPago ENUM("Tarjeta", "Efectivo") NOT NULL,
    CONSTRAINT fk_pago_reserva FOREIGN KEY (ReservaID) REFERENCES Reserva(ReservaID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Mesa(
	MesaID INT AUTO_INCREMENT PRIMARY KEY,
    ReservaID INT NOT NULL,
    Capacidad INT NOT NULL,
    Estado ENUM("Libre", "Ocupado") NOT NULL,
    CONSTRAINT fk_mesa_reserva FOREIGN KEY (ReservaID) REFERENCES Reserva(ReservaID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- FUNCION

DELIMITER $$

CREATE FUNCTION TotalReservasPorCliente(p_ClienteID INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_reservas INT;

    SELECT COUNT(*) INTO total_reservas FROM Reserva WHERE ClienteID = p_ClienteID;
    RETURN total_reservas;
    
END$$

DELIMITER ;

SELECT TotalReservasPorCliente(5) AS NumeroReservas;



