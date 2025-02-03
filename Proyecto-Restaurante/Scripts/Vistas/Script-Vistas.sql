CREATE DATABASE Restaurante_Vistas;

USE Restaurante_Vistas;

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

-- VISTA

CREATE VIEW Vista_ClienteReservaMesa AS
SELECT 
    c.ClienteID,
    CONCAT(c.Nombre, ' ', c.Apellido) AS ClienteNombre,
    c.Correo AS ClienteCorreo,
    c.Edad AS ClienteEdad,
    r.ReservaID,
    r.FechaReserva,
    r.Estado AS ReservaEstado,
    m.MesaID,
    m.Capacidad AS MesaCapacidad,
    m.Estado AS MesaEstado
FROM Cliente c JOIN Reserva r ON c.ClienteID = r.ClienteID JOIN Mesa m ON r.ReservaID = m.ReservaID;

SELECT * FROM Vista_ClienteReservaMesa;




