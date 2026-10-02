USE TURISMOPERU_DJRL;
GO

-- Prueba 1: Lectura permitida para turismo_analista
SELECT TOP 5 * FROM DJRL.cliente;
GO

-- Prueba 2: Modificacion rechazada para turismo_analista (Debe fallar con Msg 229)
INSERT INTO DJRL.pago (id_reserva, fecha_pago, monto, medio_pago)
VALUES (1, GETDATE(), 150.00, 'Tarjeta');
GO
