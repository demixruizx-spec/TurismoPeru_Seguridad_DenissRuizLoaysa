USE master;
GO

BACKUP DATABASE TURISMOPERU_DJRL
TO DISK = 'C:\BackupsTurismo\TurismoPeru_DJRL_Full.bak'
WITH INIT, NAME = 'Backup completo TurismoPeru', STATS = 10;
GO
