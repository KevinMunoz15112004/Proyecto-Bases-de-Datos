-- Cifrado de datos
-- Se agrega una columna para almacenar datos en los cuales encriptar
alter table Restaurante.Pago add column Tarjeta VARBINARY(60);
update Restaurante.Pago set TarjetaCifrada = AES_ENCRYPT('497845613287', 'uoiea987654') WHERE PagoID = 1;

-- Cifrado de contraseñas de usuarios
alter table Restaurante.Cliente add column Passwords VARBINARY(60);
update Restaurante.Cliente set PasswordCifrada = AES_ENCRYPT('bases2025A', 'abcd654321') WHERE ClienteID = 1;