
/****** Object:  View [common].[evw_LockingInformation]    Script Date: 07/12/2016 08:50:21 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_LockingInformation]'))
DROP VIEW [common].[evw_LockingInformation]
GO

/****** Object:  View [common].[evw_LockingInformation]    Script Date: 07/12/2016 08:50:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_LockingInformation]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [common].[evw_LockingInformation]
AS
SELECT SessionID    = s.Session_id,
       ResourceType = l.resource_type,   
       DatabaseName = DB_NAME(l.resource_database_id),
       ObjectName   = CASE
                      WHEN l.resource_type = ''OBJECT'' THEN OBJECT_SCHEMA_NAME(l.resource_associated_entity_id) + ''.'' + OBJECT_NAME(l.resource_associated_entity_id)
                      ELSE OBJECT_SCHEMA_NAME(sp.object_id) + ''.'' + OBJECT_NAME(sp.object_id)
                      END,
       RequestMode  = l.request_mode,
       RequestType  = l.request_type,
       LoginTime    = login_time,
       HostName     = host_name,
       Application  = program_name,
       ClientInterfaceName = client_interface_name,
       LoginName           = login_name,
       NTDomain            = nt_domain,
       NTUserName          = nt_user_name,
       SessionStatus       = s.status,
       last_request_start_time,
       last_request_end_time,
       s.logical_reads,
       s.reads,
       RequestStatus       = l.request_status,
       RequestOwnerType    = l.request_owner_type,
       ObjectId            = a.objectid,
       --ObjectName          = OBJECT_SCHEMA_NAME(a.objectid) + ''.'' + OBJECT_NAME(a.objectid),
       dbid,
       a.number,
       a.encrypted ,
       a.blocking_session_id,
       a.text       
FROM sys.dm_tran_locks l
LEFT JOIN sys.partitions sp ON l.resource_associated_entity_id = sp.hobt_id
JOIN sys.dm_exec_sessions s ON l.request_session_id = s.session_id
LEFT JOIN   
        ( SELECT  *
          FROM    sys.dm_exec_requests r
          CROSS APPLY sys.dm_exec_sql_text(sql_handle)
        ) a ON s.session_id = a.session_id
WHERE  s.session_id > 50
--AND    l.resource_type <> ''DATABASE''' 
GO


