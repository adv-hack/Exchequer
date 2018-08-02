--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ReindexEntireDatabase.sql
--// Author		: James Waygood
--// Date		: 16th Sep 2009
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to call the SP to reindex all the tables in the database
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON
 
 EXEC Common.isp_RebuildIndexes

SET NOCOUNT OFF
