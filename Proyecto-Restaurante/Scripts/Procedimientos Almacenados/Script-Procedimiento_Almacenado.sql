CREATE DATABASE Restaurante_Triggers_Procedimientos_Vistas_Funciones;

USE Restaurante_Triggers_Procedimientos_Vistas_Funciones;

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


-- PROCEDIMIENTO ALMACENADO

DELIMITER $$

CREATE PROCEDURE CalcularPrecioTotal(
    IN p_ReservaID INT,
    IN p_DescuentoPorc DECIMAL(10, 2),
    IN p_CargoAdicional DECIMAL(10, 2) 
)
BEGIN
    DECLARE v_Cantidad DECIMAL(10, 2);
    DECLARE v_PrecioFinal DECIMAL(10, 2);

    SELECT SUM(Cantidad) INTO v_Cantidad FROM Pago WHERE ReservaID = p_ReservaID;

    SET v_PrecioFinal = v_Cantidad - (v_Cantidad * p_DescuentoPorc / 100) + p_CargoAdicional;

    SELECT p_ReservaID AS ReservaID, v_Cantidad AS PrecioBase, p_DescuentoPorc AS Descuento,
    p_CargoAdicional AS CargoAdicional, v_PrecioFinal AS PrecioFinal;
    
END $$

DELIMITER ;


-- En caso de haber algun descuento o cargo adicional
CALL CalcularPrecioTotal(1, 20, 1.50);

-- En caso de no haber ninguno
CALL CalcularPrecioTotal(1, 0, 0);






