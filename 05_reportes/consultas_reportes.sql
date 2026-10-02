USE TURISMOPERU_DJRL;
GO

-- 1. Total Clientes, Reservas e Ingresos (KPIs)
SELECT 
    (SELECT COUNT(*) FROM DJRL.cliente) AS TotalClientes,
    (SELECT COUNT(*) FROM DJRL.reserva) AS TotalReservas,
    (SELECT ISNULL(SUM(monto),0) FROM DJRL.pago) AS TotalIngresos,
    (SELECT ISNULL(AVG(monto),0) FROM DJRL.pago) AS TicketPromedio;
GO

-- 2. Reservas por Estado
SELECT estado, COUNT(*) AS Cantidad 
FROM DJRL.reserva 
GROUP BY estado;
GO

-- 3. Ingresos por Medio de Pago
SELECT medio_pago, SUM(monto) AS TotalIngresos 
FROM DJRL.pago 
GROUP BY medio_pago;
GO
