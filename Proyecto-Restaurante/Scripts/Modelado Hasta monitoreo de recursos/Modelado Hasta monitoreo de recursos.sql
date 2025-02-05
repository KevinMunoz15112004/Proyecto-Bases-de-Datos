CREATE DATABASE RestauranteDB;

USE RestauranteDB;

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

-- Registros Clientes
INSERT INTO Cliente (Nombre, Apellido, Correo, Edad) VALUES
('Juan', 'Pérez', 'juan.perez123@gmail.com', 28),
('María', 'González', 'maria.gonzalez456@gmail.com', 32),
('Carlos', 'Ramírez', 'carlos.ramirez789@gmail.com', 25),
('Ana', 'López', 'ana.lopez321@gmail.com', 30),
('Luis', 'Martínez', 'luis.martinez654@gmail.com', 29),
('Sofía', 'Hernández', 'sofia.hernandez987@gmail.com', 27),
('Pedro', 'Torres', 'pedro.torres741@gmail.com', 35),
('Elena', 'Díaz', 'elena.diaz852@gmail.com', 31),
('Javier', 'Vargas', 'javier.vargas963@gmail.com', 26),
('Andrea', 'Morales', 'andrea.morales147@gmail.com', 24),
('Ricardo', 'Ortega', 'ricardo.ortega258@gmail.com', 33),
('Gabriela', 'Rojas', 'gabriela.rojas369@gmail.com', 29),
('Fernando', 'Castro', 'fernando.castro753@gmail.com', 34),
('Daniela', 'Mendoza', 'daniela.mendoza159@gmail.com', 22);

-- Reservas
INSERT INTO Reserva (ClienteID, FechaReserva, Estado) VALUES
(1, '2025-02-01 19:00:00', 'Confirmado'),
(2, '2025-02-02 20:30:00', 'Cancelado'),
(3, '2025-02-03 18:45:00', 'Confirmado'),
(4, '2025-02-04 21:00:00', 'Confirmado'),
(5, '2025-02-05 19:15:00', 'Confirmado'),
(6, '2025-02-06 20:00:00', 'Cancelado'),
(7, '2025-02-07 18:30:00', 'Confirmado'),
(8, '2025-02-08 19:45:00', 'Confirmado'),
(9, '2025-02-09 20:15:00', 'Cancelado'),
(10, '2025-02-10 21:30:00', 'Confirmado'),
(11, '2025-02-11 19:00:00', 'Confirmado'),
(12, '2025-02-12 20:45:00', 'Cancelado');

-- Pagos

INSERT INTO Pago (ReservaID, Cantidad, MetodoPago) VALUES
(1, 45.50, 'Tarjeta'),
(3, 30.00, 'Efectivo'),
(4, 60.75, 'Tarjeta'),
(5, 25.20, 'Efectivo'),
(7, 80.00, 'Tarjeta'),
(8, 35.40, 'Efectivo'),
(10, 55.30, 'Tarjeta'),
(11, 40.00, 'Efectivo'),
(12, 70.50, 'Tarjeta'),
(9, 20.00, 'Efectivo'),
(6, 90.80, 'Tarjeta'),
(2, 65.25, 'Efectivo');

-- Seguridad

-- 1) Creamos los roles que luego seran asignados un usuarios
CREATE ROLE Administrador;
CREATE ROLE Usuario;
CREATE ROLE Auditor;

-- Asignamos todos los permisos al Administrador, permisos de escritura y consulta al usuario y permiso de leer datos a invitado
GRANT ALL PRIVILEGES ON Restaurante.* TO Administrador;

GRANT SELECT, INSERT, UPDATE ON RestauranteDB.Cliente TO Usuario;
GRANT SELECT, INSERT, UPDATE ON RestauranteDB.Reserva TO Usuario;
GRANT SELECT, INSERT, UPDATE ON RestauranteDB.Pago TO Usuario;
GRANT select, insert, update on RestauranteDB.Mesa TO Usuario;

GRANT SELECT ON RestauranteDB.Cliente TO Auditor;
GRANT SELECT ON RestauranteDB.Reserva TO Auditor;
GRANT SELECT ON RestauranteDB.Pago TO Auditor;
GRANT SELECT ON RestauranteDB.Mesa TO Auditor;

-- 2) Creamos los usuarios y asignamos roles
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin123';
CREATE USER 'empleado'@'localhost' IDENTIFIED BY 'empleado123';
CREATE USER 'auditor'@'localhost' IDENTIFIED BY 'auditor123';

GRANT Administrador TO 'admin'@'localhost';
GRANT Usuario TO 'empleado'@'localhost';
GRANT Auditor TO 'auditor'@'localhost';

-- 3) Aplicamos los roles a los usuarios creados
SET DEFAULT ROLE Administrador to 'admin'@'localhost';
SET DEFAULT ROLE Usuario to 'empleado'@'localhost';
SET DEFAULT ROLE Auditor to 'auditor'@'localhost';


-- Cifrado de datos
-- Se agrega una columna para almacenar datos en los cuales encriptar
alter table RestauranteDB.Pago add column Tarjeta VARBINARY(60);
update RestauranteDB.Pago set Tarjeta = AES_ENCRYPT('497845613287', 'uoiea987654') WHERE PagoID = 1;

-- Cifrado de contraseñas de usuarios
alter table RestauranteDB.Cliente add column Passwords VARBINARY(60);
update RestauranteDB.Cliente set Passwords = AES_ENCRYPT('bases2025A', 'abcd654321') WHERE ClienteID = 1;

SELECT Tarjeta FROM RestauranteDB.Pago WHERE PagoID = 1;

SELECT AES_DECRYPT(Tarjeta, 'uoiea987654') AS TarjetaDescifrada
FROM RestauranteDB.Pago
WHERE PagoID = 1;

-- convertir resultado a texto
SELECT CAST(AES_DECRYPT(Tarjeta, 'uoiea987654') AS CHAR) AS TarjetaDescifrada
FROM RestauranteDB.Pago
WHERE PagoID = 1;

SELECT Passwords FROM RestauranteDB.Cliente WHERE ClienteID = 1;

SELECT AES_DECRYPT(Passwords, 'abcd654321') AS PasswordDescifrada
FROM RestauranteDB.Cliente
WHERE ClienteID = 1;

SELECT CAST(AES_DECRYPT(Passwords, 'abcd654321') AS CHAR) AS PasswordDescifrada
FROM RestauranteDB.Cliente
WHERE ClienteID = 1;

-- auditoria
-- Desde los privilegios de administrador activamos los logs binario para auditoria
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
after update on RestauranteDB.Cliente
FOR EACH ROW
BEGIN
    INSERT INTO Restaurante_Auditoria (Usuario, Accion)
    VALUES (CURRENT_USER(), CONCAT('Actualización en ClienteID: ', OLD.ClienteID));
END $$
DELIMITER ;

-- Triggers

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

-- Monitorear el rendimiento

SHOW PROCESSLIST;
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;  -- Registra las consultas que duren más de 2 segundos

EXPLAIN SELECT * FROM RestauranteDB.Cliente WHERE Correo = 'example@gmail.com';


SHOW STATUS LIKE 'Handler%';  -- Para conocer cómo están manejando las operaciones de lectura/escritura


-- creación de índices

-- INDICES
-- índice en la columna ClienteID de la tabla Reserva

CREATE INDEX indice_cliente ON Reserva(ClienteID);

-- indice en la columna ReservaID de la tabla Pago
CREATE INDEX indice_pago ON Pago(ReservaID);

-- indice en la columna ReservaID de la tabla Mesa
CREATE INDEX indice_mesa ON Mesa(ReservaID);

-- optimizar índices


SHOW INDEX FROM RestauranteDB.Cliente;


DROP INDEX idx_cliente_name_email ON RestauranteDB.Cliente;


DROP INDEX indice_cliente ON RestauranteDB.Cliente;

CREATE INDEX idx_cliente_correo ON RestauranteDB.Cliente(Correo);

CREATE INDEX idx_cliente_name_email ON RestauranteDB.Cliente(Nombre, Correo);


