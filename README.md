# TurismoPeru_Seguridad_DenissRuizLoaysa

## 1. Descripción

Este proyecto implementa la administración y seguridad básica de la base de datos
de TurismoPeru (`TURISMOPERU_DJRL`, esquema `DJRL`). Trabajamos tres perfiles de
usuario (administrador, vendedor y analista) con permisos distintos, una estrategia
de importación de clientes con `bcp`, un backup en formato `.bacpac` y un reporte
analítico sobre clientes, reservas y pagos.

## 2. Tecnologías utilizadas

- SQL Server <versión> y SSMS
- bcp (utilidad de línea de comandos)
- Git y GitHub
- <Power BI Desktop / Python con pandas, pyodbc y matplotlib>

## 3. Requisitos

- SQL Server instalado y la base de datos `TURISMOPERU_DJRL` creada
- SSMS y bcp disponibles en el equipo
- Git
- <Power BI Desktop o Python 3.x>

## 4. Configuración

1. Clonar el repositorio.
2. Ejecutar los scripts de `01_usuarios_roles` en orden (01 a 04).
3. Cambiar las contraseñas de los logins por unas propias antes de ejecutar.
4. <Si es Python: copiar `.env.example` a `.env` y completar los datos de conexión.>

## 5. Estructura del proyecto

<pegar aquí el árbol de carpetas real de tu repo>

## 6. Scripts disponibles

| Script | Qué hace |
|---|---|
| `01_logins.sql` | Crea los tres logins con contraseña segura |
| `02_users.sql` | Crea los usuarios dentro de la base de datos |
| `03_roles.sql` | Crea `rol_vendedor` y `rol_analista` y asigna miembros |
| `04_permisos.sql` | Otorga y deniega permisos por rol |
| `importacion.sql` | Staging, validación, duplicados e inserción de clientes |
| `backup_full.sql` / `backup_diferencial.sql` | Respaldos completo y diferencial |
| `restauracion.sql` | Restauración en una base de prueba |
| `pruebas_permisos.sql` | Pruebas de seguridad de ambos roles |

## 7. Principio de mínimo privilegio

No es adecuado darle `db_owner` al vendedor ni al analista porque ese rol permite
hacer prácticamente todo en la base de datos: borrar tablas, modificar o eliminar
cualquier dato, cambiar permisos y hasta administrar usuarios. Un vendedor solo
necesita registrar y consultar clientes y reservas, y un analista solo necesita
leer datos. Si les damos más de lo necesario, un error o unas credenciales robadas
podrían destruir información crítica.

En las pruebas comprobamos que el analista puede hacer `SELECT` sobre `pago`, pero
SQL Server rechaza su `INSERT` (error 229). Lo mismo con el vendedor y el `DELETE`
sobre `cliente`.

## 8. Importación con bcp

<Explica con tus palabras: exportaste los CSV con bcp, creaste
`DJRL.cliente_importacion`, importaste, validaste, buscaste duplicados e insertaste
solo los válidos. Anota cuántos registros llegaron, cuántos eran inválidos, cuántos
duplicados y cuántos se insertaron. Usa `<TU_PASSWORD>` en los comandos.>

## 9. Procedimiento de restauración

1. Abrir `03_backups/restauracion.sql`.
2. Ejecutar `RESTORE FILELISTONLY` y ajustar los nombres lógicos de los archivos.
3. Ejecutar `RESTORE DATABASE` hacia una base de prueba.
4. Para el `.bacpac`: en SSMS, clic derecho en *Databases* → *Import Data-tier
   Application* y elegir `TurismoPeru_DJRL_Full.bacpac`.

## 10. Configuración del reporte

<Fuente de datos, cómo se conecta el reporte y qué hay que configurar para
abrirlo. Sin credenciales reales.>

## 11. Capturas de pantalla

![Permisos](evidencias/permisos.png)
![Backup](evidencias/backup.png)
![GitHub](evidencias/github.png)
![Reporte](evidencias/reporte.png)

## 12. Autor

Deniss Jesus Ruiz Loaysa. Escuela Profesional de Ingeniería de Sistemas,
Universidad Nacional de Cajamarca.