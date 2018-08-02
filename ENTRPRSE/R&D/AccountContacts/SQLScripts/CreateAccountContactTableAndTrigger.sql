USE [DATABASE]
GO

/****** Object:  Table [COMPANY].[AccountContact]    Script Date: 14/01/2014 16:42:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [COMPANY].[AccountContact](
	[acoContactId] [int] IDENTITY(1,1) NOT NULL,
	[acoAccountCode] [varchar](10) NOT NULL,
	[acoContactName] [varchar](45) NOT NULL,
	[acoContactJobTitle] [varchar](30) NOT NULL,
	[acoContactPhoneNumber] [varchar](30) NOT NULL,
	[acoContactFaxNumber] [varchar](30) NOT NULL,
	[acoContactEmailAddress] [varchar](100) NOT NULL,
	[acoContactHasOwnAddress] [bit] NOT NULL,
	[acoContactAddress1] [varchar](30) NOT NULL,
	[acoContactAddress2] [varchar](30) NOT NULL,
	[acoContactAddress3] [varchar](30) NOT NULL,
	[acoContactAddress4] [varchar](30) NOT NULL,
	[acoContactAddress5] [varchar](30) NOT NULL,
	[acoContactPostCode] [varchar](30) NOT NULL,
	[acoDateModified] [datetime] NOT NULL,
	[acoDateCreated] [datetime] NOT NULL,
 CONSTRAINT [epk_AccountContact] PRIMARY KEY CLUSTERED 
(
	[acoContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [COMPANY].[AccountContact] ADD  CONSTRAINT [DF_AccountContact_modifiedDate]  DEFAULT (getdate()) FOR [acoDateModified]
GO

ALTER TABLE [COMPANY].[AccountContact] ADD  CONSTRAINT [DF_AccountContact_acoDateCreated]  DEFAULT (getdate()) FOR [acoDateCreated]
GO

ALTER TABLE [COMPANY].[AccountContact]  WITH CHECK ADD  CONSTRAINT [efk_CUSTSUPP_AccountContact] FOREIGN KEY([acoAccountCode])
REFERENCES [COMPANY].[CUSTSUPP] ([acCode])
GO

ALTER TABLE [COMPANY].[AccountContact] CHECK CONSTRAINT [efk_CUSTSUPP_AccountContact]
GO

//====================================================================


/****** Object:  Trigger [COMPANY].[etr_AccountContactUpdate]    Script Date: 14/01/2014 16:44:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [COMPANY].[etr_AccountContactUpdate]  
   ON  [COMPANY].[AccountContact]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   BEGIN TRY 
     UPDATE tb 
     SET acoDateModified = GETDATE() 
     FROM inserted i 
     JOIN [COMPANY].[AccountContact] tb ON i.acoContactId = tb.acoContactId
   END TRY 
   BEGIN CATCH 
     ROLLBACK 
   END CATCH 

END

GO


