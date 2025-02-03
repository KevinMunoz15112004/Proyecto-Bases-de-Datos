CREATE DATABASE Restaurante_Trigger;

USE Restaurante_Trigger;

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

CREATE TABLE CambiosReserva (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    ReservaID INT,
    ClienteID INT,
    FechaReserva TIMESTAMP,
    EstadoAnterior ENUM("Confirmado", "Cancelado"),
    EstadoNuevo ENUM("Confirmado", "Cancelado"),
    FechaCambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TipoCambio ENUM("Actualización", "Eliminación")
);

CREATE TABLE CambiosPago (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    PagoID INT,
    ReservaID INT,
    MontoAnterior DECIMAL(10, 2),
    MontoNuevo DECIMAL(10, 2),
    MetodoPagoAnterior ENUM("Tarjeta", "Efectivo"),
    MetodoPagoNuevo ENUM("Tarjeta", "Efectivo"),
    FechaCambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TipoCambio ENUM("Actualización", "Eliminación")
);

-- TRIGGER PARA VERIFICAR ACTUALIZACIONES EN LAS RESERVAS

DELIMITER $$

CREATE TRIGGER RegistroReservaUpdate
AFTER UPDATE ON Reserva
FOR EACH ROW
BEGIN
    INSERT INTO CambiosReserva(ReservaID, ClienteID, FechaReserva, EstadoAnterior, EstadoNuevo, TipoCambio)
    VALUES (OLD.ReservaID, OLD.ClienteID, OLD.FechaReserva, OLD.Estado, NEW.Estado, "Actualización");
END$$

DELIMITER ;

UPDATE Reserva SET Estado = "Confirmado" WHERE ReservaID = 16;
SELECT * FROM CambiosReserva;

-- TRIGGER PARA VERIFICAR ELIMINACIONES EN LAS RESERVAS

DELIMITER $$

CREATE TRIGGER RegistroReservaDelete
AFTER DELETE ON Reserva
FOR EACH ROW
BEGIN
    INSERT INTO CambiosReserva(ReservaID, ClienteID, FechaReserva, EstadoAnterior, EstadoNuevo, TipoCambio)
    VALUES (OLD.ReservaID, OLD.ClienteID, OLD.FechaReserva, OLD.Estado, NULL, "Eliminación");
END$$

DELIMITER ;

DELETE FROM Reserva WHERE ReservaID = 29;
SELECT * FROM CambiosReserva;

-- TRIGGER PARA VERIFICAR ACTUALIZACION EN LOS PAGOS

DELIMITER $$

CREATE TRIGGER RegistroPagoUpdate
AFTER UPDATE ON Pago
FOR EACH ROW
BEGIN
	INSERT INTO CambiosPago(PagoID, ReservaID, MontoAnterior, MontoNuevo, MetodoPagoAnterior, MetodoPagoNuevo, TipoCambio)
	VALUES (OLD.PagoID, OLD.ReservaID, OLD.Cantidad, NEW.Cantidad, OLD.MetodoPago, NEW.MetodoPago, "Actualización");
END $$

DELIMITER ;

UPDATE Pago SET Cantidad = 85.50, MetodoPago = "Efectivo" WHERE PagoID = 34;
SELECT * FROM CambiosPago;

-- TRIGGER PARA VERIFICAR ELIMINACIONES EN LOS PAGOS

DELIMITER $$

CREATE TRIGGER RegistroPagoDelete
AFTER DELETE ON Pago
FOR EACH ROW
BEGIN
    INSERT INTO CambiosPago(PagoID, ReservaID, MontoAnterior, MontoNuevo, MetodoPagoAnterior, MetodoPagoNuevo, TipoCambio)
    VALUES (OLD.PagoID, OLD.ReservaID, OLD.Cantidad, NULL, OLD.MetodoPago, NULL, "Eliminación");
END$$

DELIMITER ;

DELETE FROM Pago WHERE PagoID = 44;
SELECT * FROM CambiosPago;