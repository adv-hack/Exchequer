--/////////////////////////////////////////////////////////////////////////////
--// Filename		: itr_UpdateAcLastUsed.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to remove itr_UpdateAcLastUsed trigger
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[itr_UpdateAcLastUsed]'))
DROP TRIGGER [!ActiveSchema!].[itr_UpdateAcLastUsed]
GO