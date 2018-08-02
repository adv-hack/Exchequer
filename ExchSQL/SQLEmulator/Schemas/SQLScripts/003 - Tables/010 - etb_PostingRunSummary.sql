

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[etb_PostingRunSummary]') AND type in (N'U'))
BEGIN
CREATE TABLE [!ActiveSchema!].[etb_PostingRunSummary](
	[PostingRunSummaryId] [int] IDENTITY(1,1) NOT NULL,
	[RunNo] [int] NOT NULL,
	[PostAnalysisType] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
        [BFwdAmount] [float] NOT NULL,
	[PostAmount] [float] NOT NULL,
	[DateModified] [datetime] NOT NULL,
 CONSTRAINT [ipk_PostingRunSummary] PRIMARY KEY CLUSTERED 
(
	[PostingRunSummaryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [!ActiveSchema!].[etb_PostingRunSummary] ADD  CONSTRAINT [DF_etb_PostingRunSummary_PostAmount]  DEFAULT ((0)) FOR [PostAmount]
ALTER TABLE [!ActiveSchema!].[etb_PostingRunSummary] ADD  CONSTRAINT [DF_etb_PostingRunSummary_BFwdAmount]  DEFAULT ((0)) FOR [BFwdAmount]
ALTER TABLE [!ActiveSchema!].[etb_PostingRunSummary] ADD  CONSTRAINT [DF_etb_PostingRunSummary_DateModified]  DEFAULT (getdate()) FOR [DateModified]


CREATE NONCLUSTERED INDEX idx_PostingRunSummary_RunNo ON [!ActiveSchema!].etb_PostingRunSummary
	(
	RunNo,
	PostAnalysisType
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


-- Create Trigger for maintaining Date Modified

EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER !ActiveSchema!.etrg_PostingRunSummaryUpdate ON !ActiveSchema!.etb_PostingRunSummary
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
      JOIN [!ActiveSchema!].[etb_PostingRunSummary] tb ON i.PostingRunSummaryId = tb.PostingRunSummaryId
  END TRY 
  BEGIN CATCH 
    ROLLBACK 
  END CATCH

END'

END
GO

