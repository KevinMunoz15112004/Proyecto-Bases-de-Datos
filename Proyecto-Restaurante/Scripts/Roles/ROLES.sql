-- 1) Creamos los roles que luego seran asignados un usuarios
CREATE ROLE Administrador;
CREATE ROLE Usuario;
CREATE ROLE Auditor;

-- Asignamos todos los permisos al Administrador, permisos de escritura y consulta al usuario y permiso de leer datos a invitado
GRANT ALL PRIVILEGES ON Restaurante.* TO Administrador;

GRANT SELECT, INSERT, UPDATE ON Restaurante.Cliente TO Usuario;
GRANT SELECT, INSERT, UPDATE ON Restaurante.Reserva TO Usuario;
GRANT SELECT, INSERT, UPDATE ON Restaurante.Pago TO Usuario;
GRANT select, insert, update on Restaurante.Mesa TO Usuario;

GRANT SELECT ON Restaurante.Cliente TO Auditor;
GRANT SELECT ON Restaurante.Reserva TO Auditor;
GRANT SELECT ON Restaurante.Pago TO Auditor;
GRANT SELECT ON Restaurante.Mesa TO Auditor;
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


