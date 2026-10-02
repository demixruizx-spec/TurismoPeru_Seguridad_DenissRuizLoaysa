# TurismoPeru_Seguridad_DenissRuizLoaysa
## 02. Importación y Exportación de Datos (BCP y Staging)

Para la carga masiva de clientes desde el archivo `clientes.csv`, se implementó una estrategia en 5 etapas utilizando una tabla de staging (`DJRL.cliente_importacion`):

1. **Creación de Tabla Staging:** Se diseñó la tabla `DJRL.cliente_importacion` con campos de tipo text/varchar para evitar fallos por conversión de formatos en la carga inicial.
2. **Carga Masiva con BULK INSERT:** Se ejecutó el comando `BULK INSERT` utilizando UTF-8 (`CODEPAGE = '65001'`) y delimitador de campos por punto y coma (`;`).
3. **Validación e Identificación de Duplicados:** Se ejecutaron consultas `GROUP BY Documento HAVING COUNT(*) > 1` para auditoría de registros duplicados en el archivo original.
4. **Depuración mediante Funciones de Ventana:** Mediante `ROW_NUMBER() OVER(PARTITION BY Documento ORDER BY Documento)`, se filtraron los registros descartando repeticiones (`RowNum = 1`).
5. **Inserción a Tabla Definitiva:** Se insertaron los datos validados en la tabla final `DJRL.persona`, asegurando que no existieran previamente en el sistema mediante la cláusula `NOT IN`.