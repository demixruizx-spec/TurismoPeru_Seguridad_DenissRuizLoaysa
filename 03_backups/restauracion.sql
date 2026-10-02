USE master;
GO

-- Ver los nombres logicos de los archivos del backup
RESTORE FILELISTONLY
FROM DISK = 'C:\BackupsTurismo\TurismoPeru_DJRL_Full.bak';
GO

-- Restaurar como una copia
RESTORE DATABASE TURISMOPERU_DJRL_Restaurada
FROM DISK = 'C:\BackupsTurismo\TurismoPeru_DJRL_Full.bak'
WITH MOVE 'TURISMOPERU_DJRL'     TO 'C:\BackupsTurismo\TurismoPeru_DJRL_Restaurada.mdf',
     MOVE 'TURISMOPERU_DJRL_log' TO 'C:\BackupsTurismo\TurismoPeru_DJRL_Restaurada.ldf',
     STATS = 10;
GO
