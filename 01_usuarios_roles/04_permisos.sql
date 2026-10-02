USE TURISMOPERU_DJRL;
GO

-- Permisos para rol_vendedor
GRANT SELECT, INSERT ON DJRL.cliente TO rol_vendedor;
GRANT SELECT, INSERT ON DJRL.reserva TO rol_vendedor;
GRANT SELECT ON DJRL.alojamiento TO rol_vendedor;
GRANT SELECT ON DJRL.habitacion TO rol_vendedor;

-- Denegar permisos de eliminacion explicitamente
DENY DELETE ON DJRL.cliente TO rol_vendedor;
DENY DELETE ON DJRL.reserva TO rol_vendedor;

-- Permisos solo lectura para rol_analista
GRANT SELECT ON DJRL.cliente TO rol_analista;
GRANT SELECT ON DJRL.reserva TO rol_analista;
GRANT SELECT ON DJRL.pago TO rol_analista;
GRANT SELECT ON DJRL.alojamiento TO rol_analista;
GRANT SELECT ON DJRL.habitacion TO rol_analista;
GRANT SELECT ON DJRL.paquete TO rol_analista;
GRANT SELECT ON DJRL.lugar_turistico TO rol_analista;

-- Denegar modificaciones para rol_analista
DENY INSERT, UPDATE, DELETE ON DJRL.cliente TO rol_analista;
DENY INSERT, UPDATE, DELETE ON DJRL.reserva TO rol_analista;
DENY INSERT, UPDATE, DELETE ON DJRL.pago TO rol_analista;
GO
