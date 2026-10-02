# TurismoPeru_Seguridad_DenissRuizLoaysa

## 1. Descripción

Este proyecto implementa la administración y seguridad básica de la base de datos
de TurismoPeru (`TURISMOPERU_DJRL`, esquema `DJRL`). Trabajamos tres perfiles de
usuario (administrador, vendedor y analista) con permisos distintos, una estrategia
de importación de clientes con `bcp`, un backup en formato `.bacpac` y un reporte
analítico automatizado sobre clientes, reservas y pagos.

## 2. Tecnologías utilizadas

- SQL Server 2022 / Express y SSMS
- bcp (utilidad de línea de comandos de SQL Server)
- Git y GitHub
- Python 3.x con pandas, pyodbc, matplotlib y python-dotenv

## 3. Requisitos

- SQL Server instalado y la base de datos `TURISMOPERU_DJRL` creada.
- SSMS y la herramienta `bcp` disponibles en el PATH del sistema.
- Git instalado.
- Python 3.10+ con los paquetes instalados: `pip install pandas pyodbc matplotlib python-dotenv`.

## 4. Configuración

1. Clonar el repositorio:
   ```bash
   git clone [https://github.com/TU_USUARIO/TurismoPeru_Seguridad_DenissRuizLoaysa.git](https://github.com/TU_USUARIO/TurismoPeru_Seguridad_DenissRuizLoaysa.git)
   cd TurismoPeru_Seguridad_DenissRuizLoaysa
## 5. TurismoPeru_Seguridad_DenissRuizLoaysa/
├── .env.example
├── .gitignore
├── README.md
├── 01_usuarios_roles/
│   ├── 01_logins.sql
│   ├── 02_users.sql
│   ├── 03_roles.sql
│   └── 04_permisos.sql
├── 02_importacion_bcp/
│   └── importacion.sql
├── 03_backups/
│   ├── backup_full.sql
│   ├── backup_diferencial.sql
│   └── restauracion.sql
├── 04_pruebas_seguridad/
│   └── pruebas_permisos.sql
├── 05_reportes/
│   └── python/
│       └── app.py
└── evidencias/
    ├── 01_reservas_por_estado.png
    ├── 02_ingresos_por_medio_pago.png
    ├── 03_reservas_por_periodo.png
    ├── 04_top10_clientes_reservas.png
    ├── 05_ingresos_por_cliente.png
    ├── Importacion.png
    ├── reporte_ingresos.png
    ├── reporte_reservas.png
    └── Validacion.png

## 6. Scripts disponiblesScript
Qué hace01_logins.sqlCrea los tres logins del servidor (turismo_admin, turismo_vendedor, turismo_analista).02_users.sqlCrea los usuarios asociados dentro de la base de datos TURISMOPERU_DJRL.03_roles.sqlCrea rol_vendedor y rol_analista y asigna sus miembros correspondientes.04_permisos.sqlOtorga y deniega permisos de granularidad fina por cada rol.importacion.sqlCrea la tabla de staging, importa masivamente con BCP, valida registros y realiza la inserción de duplicados/nuevos.backup_full.sql / backup_diferencial.sqlGenera respaldos completo y diferencial de la base de datos.restauracion.sqlValida la estructura lógica y restaura la base de datos en un entorno de pruebas.pruebas_permisos.sqlPruebas de verificación de seguridad y simulación de accesos denegados.app.pyLee datos mediante pyodbc con .env y genera los 5 gráficos analíticos en la carpeta evidencias/.
## 7. Principio de mínimo privilegioNo es adecuado darle db_owner al vendedor ni al analista porque ese rol otorga control total sobre el esquema y los datos:
 permite eliminar tablas, alterar la estructura de la base de datos, modificar permisos o administrar otros usuarios. Un vendedor solo requiere registrar y consultar clientes y reservas, mientras que un analista únicamente necesita lectura para generar reportes. Otorgar privilegios excesivos expone la base de datos a destrucción inadvertida o acceso no autorizado en caso de una fuga de credenciales.En las pruebas realizadas en pruebas_permisos.sql se comprobó que el usuario turismo_analista puede realizar consultas SELECT sobre DJRL.pago, pero SQL Server rechaza inmediatamente cualquier intromisión de escritura INSERT (Error 229). Del mismo modo, el usuario turismo_vendedor tiene bloqueada la ejecución de sentencias DELETE sobre la tabla DJRL.cliente.
 ## 8. Importación con bcpPara realizar la carga masiva de clientes se utilizó la herramienta de línea de comandos bcp. 
 Primero se exportaron los registros en formato CSV y se creó la tabla staging DJRL.cliente_importacion. Posteriormente se ejecutó la importación masiva y se realizaron validaciones mediante SQL para filtrar campos vacíos y evitar registros duplicados por número de documento de identidad antes de insertar en la tabla principal DJRL.cliente.Comando de importación utilizado:Bashbcp TURISMOPERU_DJRL.DJRL.cliente_importacion in "clientes_nuevos.csv" -c -t"," -r"\n" -S ESPACEESM -U turismo_admin -P <TU_PASSWORD>
## 9. Procedimiento de restauraciónAbrir 
el script 03_backups/restauracion.sql en SSMS.Ejecutar RESTORE FILELISTONLY FROM DISK = '...' para inspeccionar los nombres lógicos de los archivos .mdf y .ldf.Ejecutar el comando RESTORE DATABASE TURISMOPERU_TEST redireccionando los datos con las cláusulas MOVE ... TO ....Para la restauración mediante .bacpac: en SSMS, hacer clic derecho sobre Databases → Import Data-tier Application y seleccionar el archivo TurismoPeru_DJRL_Full.bacpac.
## 10. Configuración del reporte
El módulo analítico está desarrollado en Python 3 (05_reportes/python/app.py). Utiliza pyodbc para conectarse a la base de datos SQL Server mediante credenciales seguras cargadas dinámicamente desde el archivo .env.Para ejecutar el reporte:Asegurarse de tener creado el archivo .env configurado con las variables requeridas (DB_SERVER, DB_DATABASE, DB_USER, DB_PASSWORD).Ejecutar el comando:Bashpython 05_reportes/python/app.py
El script generará automáticamente los 5 gráficos estadísticos en formato PNG dentro de la carpeta evidencias/.
## 11. Capturas de pantallaGráficos 
Analíticos GeneradosEvidencias de Operación
## 12. Autor
Deniss Jesus Ruiz LoaysaEscuela Profesional de Ingeniería de SistemasUniversidad Nacional de Cajamarca
