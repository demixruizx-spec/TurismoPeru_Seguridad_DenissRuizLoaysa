USE TURISMOPERU_DJRL;
GO

-- Creacion de Roles de Base de Datos
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'rol_vendedor' AND type = 'R')
    CREATE ROLE rol_vendedor;

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'rol_analista' AND type = 'R')
    CREATE ROLE rol_analista;
GO

-- Asignar usuarios a sus respectivos roles
ALTER ROLE rol_vendedor ADD MEMBER turismo_vendedor;
ALTER ROLE rol_analista ADD MEMBER turismo_analista;
GO
