-- JOINS
-- información de reservas con detalles del cliente
explain
select 
    C.Nombre, 
    C.Apellido, 
    R.FechaReserva, 
    R.Estado
from
    Reserva R
join 
    Cliente C ON R.ClienteID = C.ClienteID;
-- Obtener detalles de pagos con información de la reserva y el cliente
explain
select
    C.Nombre, 
    C.Apellido, 
    R.FechaReserva, 
    P.Cantidad, 
    P.MetodoPago
from 
    Pago P
join 
    Reserva R ON P.ReservaID = R.ReservaID
join 
    Cliente C ON R.ClienteID = C.ClienteID;
    
-- información de mesas con detalles de la reserva y el cliente
explain
select 
    C.Nombre, 
    C.Apellido, 
    R.FechaReserva, 
    M.Capacidad, 
    M.Estado
from 
    Mesa M
join 
    Reserva R ON M.ReservaID = R.ReservaID
join 
    Cliente C ON R.ClienteID = C.ClienteID;