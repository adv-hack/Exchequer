--/////////////////////////////////////////////////////////////////////////////
--// Filename		: GrantExecUsers.sql
--// Author		: James Waygood
--// Date		: 18 July 2014
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script for the 7.0.11 release
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	18th July 2014:	File Creation - James Waygood
--//	2	20th May 2015:	Added Schema Check	
--/////////////////////////////////////////////////////////////////////////////

DECLARE @name nvarchar(128)
DECLARE @schema nvarchar(128)

DECLARE procCursor CURSOR FOR select sp.name 
from sys.database_principals sp
join sys.sysusers su on sp.sid = su.sid
where default_schema_name is not null and (default_schema_name NOT IN ('dbo','guest','common') and default_schema_name IN (select name from sys.schemas))


OPEN procCursor
FETCH NEXT FROM procCursor INTO @name

WHILE  @@FETCH_STATUS = 0
BEGIN  

	DECLARE procCursor2 CURSOR FOR select distinct default_schema_name from sys.database_principals where name = @name or default_schema_name = 'common' 
	OPEN procCursor2
	FETCH NEXT FROM procCursor2 INTO @schema

	WHILE  @@FETCH_STATUS = 0
	BEGIN  
		EXEC ('grant execute on schema ::[' + @schema + '] TO [' + @name + ']')
		FETCH NEXT FROM procCursor2 INTO @schema
	END

	CLOSE procCursor2
	DEALLOCATE procCursor2

    FETCH NEXT FROM procCursor INTO @name
END

CLOSE procCursor
DEALLOCATE procCursor
GO