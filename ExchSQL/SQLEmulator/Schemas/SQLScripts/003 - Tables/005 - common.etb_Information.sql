

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[etb_Information]') AND type in (N'U'))
BEGIN
CREATE TABLE [common].[etb_Information](
	[InformationId] [int] NOT NULL,
	[InformationName] [varchar](50) NOT NULL,
	[InformationValue] [varchar](50) NOT NULL,
    [DateModified] [datetime] NOT NULL CONSTRAINT [DF_DateModified]  DEFAULT (getdate()),
 CONSTRAINT [ipk_InformationId] PRIMARY KEY CLUSTERED 
(
	[InformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95) ON [PRIMARY],
 CONSTRAINT [ucn_InformationName] UNIQUE NONCLUSTERED 
(
	[InformationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]

-- Create Trigger for maintaining Date Modified

EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER common.etrg_InformationUpdate ON common.etb_Information
AFTER UPDATE
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;
  BEGIN TRY 
    UPDATE tb 
       SET DateModified = GETDATE() 
      FROM inserted i 
      JOIN [common].[etb_Information] tb ON i.InformationId = tb.InformationId
  END TRY 
  BEGIN CATCH 
    ROLLBACK 
  END CATCH

END'

END
GO

