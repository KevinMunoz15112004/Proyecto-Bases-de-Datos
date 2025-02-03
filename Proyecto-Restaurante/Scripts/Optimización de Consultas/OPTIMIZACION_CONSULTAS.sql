-- PARTICIONES
-- Es necesario eliminar la tabla existente a particionar porque no se permite modificar la tabla y mucho menos particionarla
drop table Reservas;
-- Rehacemos otra tabla pero con la misma estructura
CREATE TABLE Reserva (
    ReservaID INT AUTO_INCREMENT,
    ClienteID INT NOT NULL,
    FechaReserva DATE NOT NULL,
    Estado ENUM("Confirmado", "Cancelado") NOT NULL,
    PRIMARY KEY (ReservaID, FechaReserva)-- La llave debe contener a la columna de particion
    )
PARTITION BY RANGE (YEAR(FechaReserva) * 100 + MONTH(FechaReserva)) (
    PARTITION part0 VALUES LESS THAN (202410), -- Particiones para meses anteriores a octubre 2024
    PARTITION part1 VALUES LESS THAN (202411), -- Para octubre 2024
    PARTITION part2 VALUES LESS THAN (202412), -- Para noviembre 2024
    PARTITION part3 VALUES LESS THAN (202501), -- Para diciembre 2024
    PARTITION part4 VALUES LESS THAN MAXVALUE  -- Para meses fuera del año 2024
);
-- Para poner en uso las particiones podemos insertar datos para ver su distribucion em las particiones
INSERT INTO Reserva (ClienteID, FechaReserva, Estado) VALUES
(1, '2023-09-15', 'Confirmado'), -- Irá a la partición part0
(2, '2023-10-01', 'Confirmado'), -- Irá a la partición part1
(3, '2023-11-10', 'Cancelado'),  -- Irá a la partición part2
(1, '2023-12-25', 'Confirmado'), -- Irá a la partición part3
(2, '2024-01-05', 'Cancelado');  -- Irá a la partición part4