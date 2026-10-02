USE TURISMOPERU_DJRL;
GO

-- Creacion de Usuarios dentro de la base de datos
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'turismo_admin')
    CREATE USER turismo_admin FOR LOGIN turismo_admin;

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'turismo_vendedor')
    CREATE USER turismo_vendedor FOR LOGIN turismo_vendedor;

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'turismo_analista')
    CREATE USER turismo_analista FOR LOGIN turismo_analista;
GO

-- Asignar rol db_owner unicamente a turismo_admin
ALTER ROLE db_owner ADD MEMBER turismo_admin;
GO
