-- INDICES
-- índice en la columna ClienteID de la tabla Reserva
CREATE INDEX indice_cliente ON Reserva(ClienteID);

-- indice en la columna ReservaID de la tabla Pago
CREATE INDEX indice_pago ON Pago(ReservaID);

-- indice en la columna ReservaID de la tabla Mesa
CREATE INDEX indice_mesa ON Mesa(ReservaID);
