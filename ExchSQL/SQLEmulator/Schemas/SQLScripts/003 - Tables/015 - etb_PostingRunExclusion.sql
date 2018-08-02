

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[etb_PostingRunExclusion]') AND type in (N'U'))
BEGIN
CREATE TABLE [!ActiveSchema!].[etb_PostingRunExclusion](
	[PostingRunExclusionId] [int] IDENTITY(1,1) NOT NULL,
	[RunNo] [int] NOT NULL,
	[OurReference] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
        [ExclusionReason] [varchar](255) NOT NULL,
	[DateModified] [datetime] NOT NULL,
        [ExchequerLogonId] [varchar](50) NOT NULL,
 CONSTRAINT [ipk_PostingRunExclusion] PRIMARY KEY CLUSTERED 
(
	[PostingRunExclusionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [!ActiveSchema!].[etb_PostingRunExclusion] ADD  CONSTRAINT [DF_etb_PostingRunExclusion_ExchequerLogonId]  DEFAULT (('')) FOR [ExchequerLogonId]
ALTER TABLE [!ActiveSchema!].[etb_PostingRunExclusion] ADD  CONSTRAINT [DF_etb_PostingRunExclusion_DateModified]  DEFAULT (getdate()) FOR [DateModified]


CREATE NONCLUSTERED INDEX [idx_PostingRunExclusion_RunNo] ON [!ActiveSchema!].[etb_PostingRunExclusion] 
(
	[RunNo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


-- Create Trigger for maintaining Date Modified

EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER !ActiveSchema!.etrg_PostingRunExclusionUpdate ON !ActiveSchema!.etb_PostingRunExclusion
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
      JOIN [!ActiveSchema!].[etb_PostingRunExclusion] tb ON i.PostingRunExclusionId = tb.PostingRunExclusionId
  END TRY 
  BEGIN CATCH 
    ROLLBACK 
  END CATCH

END'

END
GO

