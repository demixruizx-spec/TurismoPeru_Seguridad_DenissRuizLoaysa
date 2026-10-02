USE master;
GO

BACKUP DATABASE TURISMOPERU_DJRL
TO DISK = 'C:\BackupsTurismo\TurismoPeru_DJRL_Diff.bak'
WITH DIFFERENTIAL, INIT, NAME = 'Backup diferencial TurismoPeru', STATS = 10;
GO
