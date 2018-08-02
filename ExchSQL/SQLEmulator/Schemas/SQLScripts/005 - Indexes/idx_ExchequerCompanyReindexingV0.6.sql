--/////////////////////////////////////////////////////////////////////////////
--// Filename		: idx_ExchequerCompanyReindexingV0.6.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to amend indexes
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

SET ARITHABORT ON
GO
SET CONCAT_NULL_YIELDS_NULL ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET ANSI_PADDING ON
GO
SET ANSI_WARNINGS ON
GO
SET NUMERIC_ROUNDABORT OFF
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[CUSTSUPP]') 
    AND name = N'CUSTSUPP_Index_Identity'
  )
BEGIN
	ALTER INDEX [CUSTSUPP_Index_Identity] ON [!ActiveSchema!].[CUSTSUPP] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[CUSTSUPP]') 
    AND name = N'CUSTSUPP_Index0'
  )
BEGIN
ALTER INDEX [CUSTSUPP_Index0] ON [!ActiveSchema!].[CUSTSUPP] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[CUSTSUPP]') 
    AND name = N'CUSTSUPP_Index1'
  )
BEGIN
ALTER INDEX [CUSTSUPP_Index1] ON [!ActiveSchema!].[CUSTSUPP] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[CUSTSUPP]') 
    AND name = N'CUSTSUPP_Index10'
  )
BEGIN
ALTER INDEX [CUSTSUPP_Index10] ON [!ActiveSchema!].[CUSTSUPP] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[CUSTSUPP]') 
    AND name = N'CUSTSUPP_Index11'
  )
BEGIN
ALTER INDEX [CUSTSUPP_Index11] ON [!ActiveSchema!].[CUSTSUPP] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[CUSTSUPP]') 
    AND name = N'CUSTSUPP_Index2'
  )
BEGIN
ALTER INDEX [CUSTSUPP_Index2] ON [!ActiveSchema!].[CUSTSUPP] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[CUSTSUPP]') 
    AND name = N'CUSTSUPP_Index3'
  )
BEGIN
ALTER INDEX [CUSTSUPP_Index3] ON [!ActiveSchema!].[CUSTSUPP] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[CUSTSUPP]') 
    AND name = N'CUSTSUPP_Index4'
  )
BEGIN
ALTER INDEX [CUSTSUPP_Index4] ON [!ActiveSchema!].[CUSTSUPP] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[CUSTSUPP]') 
    AND name = N'CUSTSUPP_Index5'
  )
BEGIN
ALTER INDEX [CUSTSUPP_Index5] ON [!ActiveSchema!].[CUSTSUPP] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[CUSTSUPP]') 
    AND name = N'CUSTSUPP_Index6'
  )
BEGIN
ALTER INDEX [CUSTSUPP_Index6] ON [!ActiveSchema!].[CUSTSUPP] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[CUSTSUPP]') 
    AND name = N'CUSTSUPP_Index7'
  )
BEGIN
ALTER INDEX [CUSTSUPP_Index7] ON [!ActiveSchema!].[CUSTSUPP] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[CUSTSUPP]') 
    AND name = N'CUSTSUPP_Index8'
  )
BEGIN
ALTER INDEX [CUSTSUPP_Index8] ON [!ActiveSchema!].[CUSTSUPP] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[CUSTSUPP]') 
    AND name = N'CUSTSUPP_Index9'
  )
BEGIN
ALTER INDEX [CUSTSUPP_Index9] ON [!ActiveSchema!].[CUSTSUPP] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DETAILS]') 
    AND name = N'DETAILS_Index_Identity'
  )
BEGIN
ALTER INDEX [DETAILS_Index_Identity] ON [!ActiveSchema!].[DETAILS] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DETAILS]') 
    AND name = N'DETAILS_Index0'
  )
BEGIN
ALTER INDEX [DETAILS_Index0] ON [!ActiveSchema!].[DETAILS] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DETAILS]') 
    AND name = N'DETAILS_Index1'
  )
BEGIN
ALTER INDEX [DETAILS_Index1] ON [!ActiveSchema!].[DETAILS] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DETAILS]') 
    AND name = N'DETAILS_Index2'
  )
BEGIN
ALTER INDEX [DETAILS_Index2] ON [!ActiveSchema!].[DETAILS] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DETAILS]') 
    AND name = N'DETAILS_Index3'
  )
BEGIN
ALTER INDEX [DETAILS_Index3] ON [!ActiveSchema!].[DETAILS] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DETAILS]') 
    AND name = N'DETAILS_Index4'
  )
BEGIN
ALTER INDEX [DETAILS_Index4] ON [!ActiveSchema!].[DETAILS] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DETAILS]') 
    AND name = N'DETAILS_Index5'
  )
BEGIN
ALTER INDEX [DETAILS_Index5] ON [!ActiveSchema!].[DETAILS] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DETAILS]') 
    AND name = N'DETAILS_Index6'
  )
BEGIN
ALTER INDEX [DETAILS_Index6] ON [!ActiveSchema!].[DETAILS] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DETAILS]') 
    AND name = N'DETAILS_Index7'
  )
BEGIN
ALTER INDEX [DETAILS_Index7] ON [!ActiveSchema!].[DETAILS] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DETAILS]') 
    AND name = N'DETAILS_Index8'
  )
BEGIN
ALTER INDEX [DETAILS_Index8] ON [!ActiveSchema!].[DETAILS] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') 
    AND name = N'DOCUMENT_Index_Identity'
  )
BEGIN
ALTER INDEX [DOCUMENT_Index_Identity] ON [!ActiveSchema!].[DOCUMENT] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') 
    AND name = N'DOCUMENT_Index0'
  )
BEGIN
ALTER INDEX [DOCUMENT_Index0] ON [!ActiveSchema!].[DOCUMENT] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') 
    AND name = N'DOCUMENT_Index1'
  )
BEGIN
ALTER INDEX [DOCUMENT_Index1] ON [!ActiveSchema!].[DOCUMENT] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') 
    AND name = N'DOCUMENT_Index10'
  )
BEGIN
ALTER INDEX [DOCUMENT_Index10] ON [!ActiveSchema!].[DOCUMENT] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') 
    AND name = N'DOCUMENT_Index11'
  )
BEGIN
ALTER INDEX [DOCUMENT_Index11] ON [!ActiveSchema!].[DOCUMENT] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') 
    AND name = N'DOCUMENT_Index12'
  )
BEGIN
ALTER INDEX [DOCUMENT_Index12] ON [!ActiveSchema!].[DOCUMENT] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') 
    AND name = N'DOCUMENT_Index13'
  )
BEGIN
ALTER INDEX [DOCUMENT_Index13] ON [!ActiveSchema!].[DOCUMENT] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') 
    AND name = N'DOCUMENT_Index2'
  )
BEGIN
ALTER INDEX [DOCUMENT_Index2] ON [!ActiveSchema!].[DOCUMENT] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') 
    AND name = N'DOCUMENT_Index3'
  )
BEGIN
ALTER INDEX [DOCUMENT_Index3] ON [!ActiveSchema!].[DOCUMENT] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') 
    AND name = N'DOCUMENT_Index4'
  )
BEGIN
ALTER INDEX [DOCUMENT_Index4] ON [!ActiveSchema!].[DOCUMENT] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') 
    AND name = N'DOCUMENT_Index5'
  )
BEGIN
ALTER INDEX [DOCUMENT_Index5] ON [!ActiveSchema!].[DOCUMENT] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') 
    AND name = N'DOCUMENT_Index6'
  )
BEGIN
ALTER INDEX [DOCUMENT_Index6] ON [!ActiveSchema!].[DOCUMENT] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') 
    AND name = N'DOCUMENT_Index7'
  )
BEGIN
ALTER INDEX [DOCUMENT_Index7] ON [!ActiveSchema!].[DOCUMENT] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') 
    AND name = N'DOCUMENT_Index8'
  )
BEGIN
ALTER INDEX [DOCUMENT_Index8] ON [!ActiveSchema!].[DOCUMENT] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') 
    AND name = N'DOCUMENT_Index9'
  )
BEGIN
ALTER INDEX [DOCUMENT_Index9] ON [!ActiveSchema!].[DOCUMENT] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDETL]') 
    AND name = N'EBUSDETL_Index_Identity'
  )
BEGIN
ALTER INDEX [EBUSDETL_Index_Identity] ON [!ActiveSchema!].[EBUSDETL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDETL]') 
    AND name = N'EBUSDETL_Index0'
  )
BEGIN
ALTER INDEX [EBUSDETL_Index0] ON [!ActiveSchema!].[EBUSDETL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDETL]') 
    AND name = N'EBUSDETL_Index1'
  )
BEGIN
ALTER INDEX [EBUSDETL_Index1] ON [!ActiveSchema!].[EBUSDETL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDETL]') 
    AND name = N'EBUSDETL_Index2'
  )
BEGIN
ALTER INDEX [EBUSDETL_Index2] ON [!ActiveSchema!].[EBUSDETL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDETL]') 
    AND name = N'EBUSDETL_Index3'
  )
BEGIN
ALTER INDEX [EBUSDETL_Index3] ON [!ActiveSchema!].[EBUSDETL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDETL]') 
    AND name = N'EBUSDETL_Index4'
  )
BEGIN
ALTER INDEX [EBUSDETL_Index4] ON [!ActiveSchema!].[EBUSDETL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDETL]') 
    AND name = N'EBUSDETL_Index5'
  )
BEGIN
ALTER INDEX [EBUSDETL_Index5] ON [!ActiveSchema!].[EBUSDETL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDETL]') 
    AND name = N'EBUSDETL_Index6'
  )
BEGIN
ALTER INDEX [EBUSDETL_Index6] ON [!ActiveSchema!].[EBUSDETL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDETL]') 
    AND name = N'EBUSDETL_Index7'
  )
BEGIN
ALTER INDEX [EBUSDETL_Index7] ON [!ActiveSchema!].[EBUSDETL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDETL]') 
    AND name = N'EBUSDETL_Index8'
  )
BEGIN
ALTER INDEX [EBUSDETL_Index8] ON [!ActiveSchema!].[EBUSDETL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDOC]') 
    AND name = N'EBUSDOC_Index_Identity'
  )
BEGIN
ALTER INDEX [EBUSDOC_Index_Identity] ON [!ActiveSchema!].[EBUSDOC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDOC]') 
    AND name = N'EBUSDOC_Index0'
  )
BEGIN
ALTER INDEX [EBUSDOC_Index0] ON [!ActiveSchema!].[EBUSDOC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDOC]') 
    AND name = N'EBUSDOC_Index1'
  )
BEGIN
ALTER INDEX [EBUSDOC_Index1] ON [!ActiveSchema!].[EBUSDOC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDOC]') 
    AND name = N'EBUSDOC_Index10'
  )
BEGIN
ALTER INDEX [EBUSDOC_Index10] ON [!ActiveSchema!].[EBUSDOC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDOC]') 
    AND name = N'EBUSDOC_Index11'
  )
BEGIN
ALTER INDEX [EBUSDOC_Index11] ON [!ActiveSchema!].[EBUSDOC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDOC]') 
    AND name = N'EBUSDOC_Index12'
  )
BEGIN
ALTER INDEX [EBUSDOC_Index12] ON [!ActiveSchema!].[EBUSDOC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDOC]') 
    AND name = N'EBUSDOC_Index13'
  )
BEGIN
ALTER INDEX [EBUSDOC_Index13] ON [!ActiveSchema!].[EBUSDOC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDOC]') 
    AND name = N'EBUSDOC_Index2'
  )
BEGIN
ALTER INDEX [EBUSDOC_Index2] ON [!ActiveSchema!].[EBUSDOC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDOC]') 
    AND name = N'EBUSDOC_Index3'
  )
BEGIN
ALTER INDEX [EBUSDOC_Index3] ON [!ActiveSchema!].[EBUSDOC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDOC]') 
    AND name = N'EBUSDOC_Index4'
  )
BEGIN
ALTER INDEX [EBUSDOC_Index4] ON [!ActiveSchema!].[EBUSDOC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDOC]') 
    AND name = N'EBUSDOC_Index5'
  )
BEGIN
ALTER INDEX [EBUSDOC_Index5] ON [!ActiveSchema!].[EBUSDOC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDOC]') 
    AND name = N'EBUSDOC_Index6'
  )
BEGIN
ALTER INDEX [EBUSDOC_Index6] ON [!ActiveSchema!].[EBUSDOC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDOC]') 
    AND name = N'EBUSDOC_Index7'
  )
BEGIN
ALTER INDEX [EBUSDOC_Index7] ON [!ActiveSchema!].[EBUSDOC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDOC]') 
    AND name = N'EBUSDOC_Index8'
  )
BEGIN
ALTER INDEX [EBUSDOC_Index8] ON [!ActiveSchema!].[EBUSDOC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EBUSDOC]') 
    AND name = N'EBUSDOC_Index9'
  )
BEGIN
ALTER INDEX [EBUSDOC_Index9] ON [!ActiveSchema!].[EBUSDOC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EXCHQCHK]') 
    AND name = N'EXCHQCHK_Index_Identity'
  )
BEGIN
ALTER INDEX [EXCHQCHK_Index_Identity] ON [!ActiveSchema!].[EXCHQCHK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EXCHQCHK]') 
    AND name = N'EXCHQCHK_Index1'
  )
BEGIN
ALTER INDEX [EXCHQCHK_Index1] ON [!ActiveSchema!].[EXCHQCHK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EXCHQNUM]') 
    AND name = N'EXCHQNUM_Index_Identity'
  )
BEGIN
ALTER INDEX [EXCHQNUM_Index_Identity] ON [!ActiveSchema!].[EXCHQNUM] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EXCHQNUM]') 
    AND name = N'EXCHQNUM_Index0'
  )
BEGIN
ALTER INDEX [EXCHQNUM_Index0] ON [!ActiveSchema!].[EXCHQNUM] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EXCHQSS]') 
    AND name = N'EXCHQSS_Index_Identity'
  )
BEGIN
ALTER INDEX [EXCHQSS_Index_Identity] ON [!ActiveSchema!].[EXCHQSS] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EXCHQSS]') 
    AND name = N'EXCHQSS_Index0'
  )
BEGIN
ALTER INDEX [EXCHQSS_Index0] ON [!ActiveSchema!].[EXCHQSS] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EXSTKCHK]') 
    AND name = N'EXSTKCHK_Index_Identity'
  )
BEGIN
ALTER INDEX [EXSTKCHK_Index_Identity] ON [!ActiveSchema!].[EXSTKCHK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EXSTKCHK]') 
    AND name = N'EXSTKCHK_Index1'
  )
BEGIN
ALTER INDEX [EXSTKCHK_Index1] ON [!ActiveSchema!].[EXSTKCHK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[EXSTKCHK]') 
    AND name = N'EXSTKCHK_Index2'
  )
BEGIN
ALTER INDEX [EXSTKCHK_Index2] ON [!ActiveSchema!].[EXSTKCHK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY]') 
    AND name = N'HISTORY_Index_Identity'
  )
BEGIN
ALTER INDEX [HISTORY_Index_Identity] ON [!ActiveSchema!].[HISTORY] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY]') 
    AND name = N'HISTORY_Index0'
  )
BEGIN
ALTER INDEX [HISTORY_Index0] ON [!ActiveSchema!].[HISTORY] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBCTRL]') 
    AND name = N'JOBCTRL_Index_Identity'
  )
BEGIN
ALTER INDEX [JOBCTRL_Index_Identity] ON [!ActiveSchema!].[JOBCTRL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBCTRL]') 
    AND name = N'JOBCTRL_Index0'
  )
BEGIN
ALTER INDEX [JOBCTRL_Index0] ON [!ActiveSchema!].[JOBCTRL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBCTRL]') 
    AND name = N'JOBCTRL_Index1'
  )
BEGIN
	CREATE UNIQUE CLUSTERED INDEX [JOBCTRL_Index1] ON [!ActiveSchema!].[JOBCTRL] 
	(
		[RecPfix] ASC,
		[SubType] ASC,
		[VarCode2Computed] ASC,
		[PositionId] ASC
	)WITH 
	( 
		PAD_INDEX  = OFF, 
		FILLFACTOR = 90,
		SORT_IN_TEMPDB = OFF,
		DROP_EXISTING = ON, 
		IGNORE_DUP_KEY = OFF, 
		ONLINE = OFF,
		ALLOW_ROW_LOCKS  = ON, 
		ALLOW_PAGE_LOCKS  = ON
	) ON [PRIMARY]
END
ELSE
BEGIN
	CREATE UNIQUE CLUSTERED INDEX [JOBCTRL_Index1] ON [!ActiveSchema!].[JOBCTRL] 
	(
		[RecPfix] ASC,
		[SubType] ASC,
		[VarCode2Computed] ASC,
		[PositionId] ASC
	)WITH 
	( 
		PAD_INDEX  = OFF, 
		FILLFACTOR = 90,
		SORT_IN_TEMPDB = OFF,
		DROP_EXISTING = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ONLINE = OFF,
		ALLOW_ROW_LOCKS  = ON, 
		ALLOW_PAGE_LOCKS  = ON
	) ON [PRIMARY]
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBDET]') 
    AND name = N'JOBDET_Index0'
  )
BEGIN
ALTER INDEX [JOBDET_Index0] ON [!ActiveSchema!].[JOBDET] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBDET]') 
    AND name = N'JOBDET_Index1'
  )
BEGIN
	CREATE UNIQUE CLUSTERED INDEX [JOBDET_Index1] ON [!ActiveSchema!].[JOBDET] 
	(
		[RecPfix] ASC,
		[SubType] ASC,
		[VarCode3Computed] ASC,
		[VarCode10Computed] ASC,
		[PositionId] ASC
	)WITH 
	(
		PAD_INDEX  = OFF,
		FILLFACTOR = 90, 
		STATISTICS_NORECOMPUTE  = OFF, 
		SORT_IN_TEMPDB = OFF, 
		IGNORE_DUP_KEY = OFF, 
		DROP_EXISTING = ON, 
		ONLINE = OFF, 
		ALLOW_ROW_LOCKS  = ON, 
		ALLOW_PAGE_LOCKS  = ON
	) ON [PRIMARY]
END
ELSE
BEGIN
	CREATE UNIQUE CLUSTERED INDEX [JOBDET_Index1] ON [!ActiveSchema!].[JOBDET] 
	(
		[RecPfix] ASC,
		[SubType] ASC,
		[VarCode3Computed] ASC,
		[VarCode10Computed] ASC,
		[PositionId] ASC
	)WITH 
	(
		PAD_INDEX  = OFF,
		FILLFACTOR = 90, 
		STATISTICS_NORECOMPUTE  = OFF, 
		SORT_IN_TEMPDB = OFF, 
		IGNORE_DUP_KEY = OFF, 
		DROP_EXISTING = OFF, 
		ONLINE = OFF, 
		ALLOW_ROW_LOCKS  = ON, 
		ALLOW_PAGE_LOCKS  = ON
	) ON [PRIMARY]
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBDET]') 
    AND name = N'JOBDET_Index2'
  )
BEGIN
ALTER INDEX [JOBDET_Index2] ON [!ActiveSchema!].[JOBDET] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBDET]') 
    AND name = N'JOBDET_Index3'
  )
BEGIN
ALTER INDEX [JOBDET_Index3] ON [!ActiveSchema!].[JOBDET] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBDET]') 
    AND name = N'JOBDET_Index4'
  )
BEGIN
ALTER INDEX [JOBDET_Index4] ON [!ActiveSchema!].[JOBDET] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBDET]') 
    AND name = N'JOBDET_Index5'
  )
BEGIN
ALTER INDEX [JOBDET_Index5] ON [!ActiveSchema!].[JOBDET] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBDET]') 
    AND name = N'JOBDET_Index6'
  )
BEGIN
ALTER INDEX [JOBDET_Index6] ON [!ActiveSchema!].[JOBDET] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBHEAD]') 
    AND name = N'JOBHEAD_Index_Identity'
  )
BEGIN
ALTER INDEX [JOBHEAD_Index_Identity] ON [!ActiveSchema!].[JOBHEAD] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBHEAD]') 
    AND name = N'JOBHEAD_Index0'
  )
BEGIN
	CREATE UNIQUE CLUSTERED INDEX [JOBHEAD_Index0] ON [!ActiveSchema!].[JOBHEAD] 
	(
		[JobCode] ASC
	)WITH 
	(
		PAD_INDEX  = OFF, 
		FILLFACTOR = 90, 
		STATISTICS_NORECOMPUTE  = OFF, 
		SORT_IN_TEMPDB = OFF, 
		IGNORE_DUP_KEY = OFF, 
		DROP_EXISTING = ON, 
		ONLINE = OFF, 
		ALLOW_ROW_LOCKS  = ON, 
		ALLOW_PAGE_LOCKS  = ON
	) ON [PRIMARY]
END
ELSE
BEGIN
	CREATE UNIQUE CLUSTERED INDEX [JOBHEAD_Index0] ON [!ActiveSchema!].[JOBHEAD] 
	(
		[JobCode] ASC
	)WITH 
	(
		PAD_INDEX  = OFF, 
		FILLFACTOR = 90, 
		STATISTICS_NORECOMPUTE  = OFF, 
		SORT_IN_TEMPDB = OFF, 
		IGNORE_DUP_KEY = OFF, 
		DROP_EXISTING = OFF, 
		ONLINE = OFF, 
		ALLOW_ROW_LOCKS  = ON, 
		ALLOW_PAGE_LOCKS  = ON
	) ON [PRIMARY]
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBHEAD]') 
    AND name = N'JOBHEAD_Index1'
  )
BEGIN
ALTER INDEX [JOBHEAD_Index1] ON [!ActiveSchema!].[JOBHEAD] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBHEAD]') 
    AND name = N'JOBHEAD_Index2'
  )
BEGIN
ALTER INDEX [JOBHEAD_Index2] ON [!ActiveSchema!].[JOBHEAD] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBHEAD]') 
    AND name = N'JOBHEAD_Index3'
  )
BEGIN
ALTER INDEX [JOBHEAD_Index3] ON [!ActiveSchema!].[JOBHEAD] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBHEAD]') 
    AND name = N'JOBHEAD_Index4'
  )
BEGIN
ALTER INDEX [JOBHEAD_Index4] ON [!ActiveSchema!].[JOBHEAD] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBHEAD]') 
    AND name = N'JOBHEAD_Index5'
  )
BEGIN
ALTER INDEX [JOBHEAD_Index5] ON [!ActiveSchema!].[JOBHEAD] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBHEAD]') 
    AND name = N'JOBHEAD_Index6'
  )
BEGIN
ALTER INDEX [JOBHEAD_Index6] ON [!ActiveSchema!].[JOBHEAD] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBHEAD]') 
    AND name = N'JOBHEAD_Index7'
  )
BEGIN
ALTER INDEX [JOBHEAD_Index7] ON [!ActiveSchema!].[JOBHEAD] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBMISC]') 
    AND name = N'JOBMISC_Index_Identity'
  )
BEGIN
ALTER INDEX [JOBMISC_Index_Identity] ON [!ActiveSchema!].[JOBMISC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBMISC]') 
    AND name = N'JOBMISC_Index0'
  )
BEGIN
ALTER INDEX [JOBMISC_Index0] ON [!ActiveSchema!].[JOBMISC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[JOBMISC]') 
    AND name = N'JOBMISC_Index1'
  )
BEGIN
ALTER INDEX [JOBMISC_Index1] ON [!ActiveSchema!].[JOBMISC] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[MLOCSTK]') 
    AND name = N'MLOCSTK_Index_Identity'
  )
BEGIN
ALTER INDEX [MLOCSTK_Index_Identity] ON [!ActiveSchema!].[MLOCSTK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[MLOCSTK]') 
    AND name = N'MLOCSTK_Index0'
  )
BEGIN
ALTER INDEX [MLOCSTK_Index0] ON [!ActiveSchema!].[MLOCSTK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[MLOCSTK]') 
    AND name = N'MLOCSTK_Index2'
  )
BEGIN
ALTER INDEX [MLOCSTK_Index2] ON [!ActiveSchema!].[MLOCSTK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[NOMINAL]') 
    AND name = N'NOMINAL_Index_Identity'
  )
BEGIN
ALTER INDEX [NOMINAL_Index_Identity] ON [!ActiveSchema!].[NOMINAL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[NOMINAL]') 
    AND name = N'NOMINAL_Index0'
  )
BEGIN
ALTER INDEX [NOMINAL_Index0] ON [!ActiveSchema!].[NOMINAL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[NOMINAL]') 
    AND name = N'NOMINAL_Index1'
  )
BEGIN
ALTER INDEX [NOMINAL_Index1] ON [!ActiveSchema!].[NOMINAL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[NOMINAL]') 
    AND name = N'NOMINAL_Index2'
  )
BEGIN
ALTER INDEX [NOMINAL_Index2] ON [!ActiveSchema!].[NOMINAL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[NOMINAL]') 
    AND name = N'NOMINAL_Index3'
  )
BEGIN
ALTER INDEX [NOMINAL_Index3] ON [!ActiveSchema!].[NOMINAL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[NOMINAL]') 
    AND name = N'NOMINAL_Index4'
  )
BEGIN
ALTER INDEX [NOMINAL_Index4] ON [!ActiveSchema!].[NOMINAL] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[NOMVIEW]') 
    AND name = N'NOMVIEW_Index_Identity'
  )
BEGIN
ALTER INDEX [NOMVIEW_Index_Identity] ON [!ActiveSchema!].[NOMVIEW] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[NOMVIEW]') 
    AND name = N'NOMVIEW_Index0'
  )
BEGIN
ALTER INDEX [NOMVIEW_Index0] ON [!ActiveSchema!].[NOMVIEW] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[NOMVIEW]') 
    AND name = N'NOMVIEW_Index1'
  )
BEGIN
ALTER INDEX [NOMVIEW_Index1] ON [!ActiveSchema!].[NOMVIEW] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[NOMVIEW]') 
    AND name = N'NOMVIEW_Index2'
  )
BEGIN
ALTER INDEX [NOMVIEW_Index2] ON [!ActiveSchema!].[NOMVIEW] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[NOMVIEW]') 
    AND name = N'NOMVIEW_Index3'
  )
BEGIN
ALTER INDEX [NOMVIEW_Index3] ON [!ActiveSchema!].[NOMVIEW] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[NOMVIEW]') 
    AND name = N'NOMVIEW_Index4'
  )
BEGIN
ALTER INDEX [NOMVIEW_Index4] ON [!ActiveSchema!].[NOMVIEW] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[SETTINGS]') 
    AND name = N'SETTINGS_Index_Identity'
  )
BEGIN
ALTER INDEX [SETTINGS_Index_Identity] ON [!ActiveSchema!].[SETTINGS] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[STOCK]') 
    AND name = N'STOCK_Index_Identity'
  )
BEGIN
ALTER INDEX [STOCK_Index_Identity] ON [!ActiveSchema!].[STOCK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[STOCK]') 
    AND name = N'STOCK_Index0'
  )
BEGIN
ALTER INDEX [STOCK_Index0] ON [!ActiveSchema!].[STOCK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[STOCK]') 
    AND name = N'STOCK_Index1'
  )
BEGIN
ALTER INDEX [STOCK_Index1] ON [!ActiveSchema!].[STOCK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[STOCK]') 
    AND name = N'STOCK_Index2'
  )
BEGIN
ALTER INDEX [STOCK_Index2] ON [!ActiveSchema!].[STOCK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[STOCK]') 
    AND name = N'STOCK_Index3'
  )
BEGIN
ALTER INDEX [STOCK_Index3] ON [!ActiveSchema!].[STOCK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[STOCK]') 
    AND name = N'STOCK_Index4'
  )
BEGIN
ALTER INDEX [STOCK_Index4] ON [!ActiveSchema!].[STOCK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[STOCK]') 
    AND name = N'STOCK_Index5'
  )
BEGIN
ALTER INDEX [STOCK_Index5] ON [!ActiveSchema!].[STOCK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[STOCK]') 
    AND name = N'STOCK_Index6'
  )
BEGIN
ALTER INDEX [STOCK_Index6] ON [!ActiveSchema!].[STOCK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[STOCK]') 
    AND name = N'STOCK_Index7'
  )
BEGIN
ALTER INDEX [STOCK_Index7] ON [!ActiveSchema!].[STOCK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO

IF EXISTS (
  SELECT 
    object_id
  FROM 
    sys.indexes 
  WHERE 
    object_id = OBJECT_ID(N'[!ActiveSchema!].[STOCK]') 
    AND name = N'STOCK_Index8'
  )
BEGIN
ALTER INDEX [STOCK_Index8] ON [!ActiveSchema!].[STOCK] REBUILD WITH ( FILLFACTOR = 90, PAD_INDEX  = OFF)
END
GO