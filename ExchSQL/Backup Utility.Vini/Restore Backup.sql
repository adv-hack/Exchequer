/* 'USE master' is purely to ensure that we do not hold open
   the database that we want to restore to. */
USE master
GO

RESTORE DATABASE [EXCHTEST] 
FROM DISK = '\\csdev\c$\Backups\Test.bak'
WITH 
FILE = 1,
MOVE 'Exchequer' TO 'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\EXCHTEST.mdf',
MOVE 'Exchequer_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\EXCHTEST.ldf',
REPLACE
GO

USE EXCHTEST
GO