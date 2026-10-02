USE master;
GO

-- Creacion de Logins a nivel de servidor
IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'turismo_admin')
    CREATE LOGIN turismo_admin WITH PASSWORD = 'Adm!n_Turismo#2026', CHECK_POLICY = OFF;

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'turismo_vendedor')
    CREATE LOGIN turismo_vendedor WITH PASSWORD = 'Vend_Turismo#2026', CHECK_POLICY = OFF;

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'turismo_analista')
    CREATE LOGIN turismo_analista WITH PASSWORD = 'Anal_Turismo#2026', CHECK_POLICY = OFF;
GO
