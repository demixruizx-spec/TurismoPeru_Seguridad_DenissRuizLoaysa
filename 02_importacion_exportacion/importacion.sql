USE TURISMOPERU_DJRL;
GO

-- 1. Crear la tabla staging
IF OBJECT_ID('DJRL.cliente_importacion', 'U') IS NOT NULL
    DROP TABLE DJRL.cliente_importacion;
GO

CREATE TABLE DJRL.cliente_importacion (
    Documento VARCHAR(20),
    Nombres VARCHAR(100),
    ApellidoPaterno VARCHAR(100),
    ApellidoMaterno VARCHAR(100)
);
GO

-- 2. Cargar los datos desde el archivo CSV
BULK INSERT DJRL.cliente_importacion
FROM 'C:\Users\HP\Documents\TurismoPeru_Seguridad_DenissRuizLoaysa\02_importacion_exportacion\datos\clientes.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001',
    FIRSTROW = 1
);
GO

-- 3. Identificar registros duplicados
SELECT Documento, COUNT(*) AS repeticiones
FROM DJRL.cliente_importacion
GROUP BY Documento
HAVING COUNT(*) > 1;
GO

-- 4. Insercion limpia descartando duplicados
WITH ClientesUnicos AS (
    SELECT Documento, Nombres, ApellidoPaterno, ApellidoMaterno,
           ROW_NUMBER() OVER(PARTITION BY Documento ORDER BY Documento) AS RowNum
    FROM DJRL.cliente_importacion
)
INSERT INTO DJRL.persona (numero_documento, nombres, apaterno, amaterno)
SELECT Documento, Nombres, ApellidoPaterno, ApellidoMaterno
FROM ClientesUnicos
WHERE RowNum = 1
  AND Documento NOT IN (SELECT numero_documento FROM DJRL.persona WHERE numero_documento IS NOT NULL);
GO
