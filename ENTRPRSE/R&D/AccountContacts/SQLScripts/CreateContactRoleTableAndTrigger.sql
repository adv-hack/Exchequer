USE [DATABASE]
GO

/****** Object:  Table [COMPANY].[ContactRole]    Script Date: 14/01/2014 16:53:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [COMPANY].[ContactRole](
	[crRoleId] [int] IDENTITY(1,1) NOT NULL,
	[crRoleDescription] [varchar](50) NOT NULL,
	[crRoleAppliesToCustomer] [bit] NOT NULL,
	[crRoleAppliesToSupplier] [bit] NOT NULL,
	[crDateModified] [datetime] NOT NULL,
	[crDateCreated] [datetime] NOT NULL,
 CONSTRAINT [epk_ContactRole] PRIMARY KEY CLUSTERED 
(
	[crRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [COMPANY].[ContactRole] ADD  CONSTRAINT [DF_ContactRole_crDateModified]  DEFAULT (getdate()) FOR [crDateModified]
GO

ALTER TABLE [COMPANY].[ContactRole] ADD  CONSTRAINT [DF_ContactRole_crDateCreated]  DEFAULT (getdate()) FOR [crDateCreated]
GO


/****** Object:  Trigger [COMPANY].[etr_ContactRoleUpdate]    Script Date: 14/01/2014 16:53:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [COMPANY].[etr_ContactRoleUpdate]  ON [COMPANY].[ContactRole]
    FOR UPDATE
AS
BEGIN 
   SET NOCOUNT ON;
   BEGIN TRY 
     UPDATE tb 
     SET crDateModified = GETDATE() 
     FROM inserted i 
     JOIN [COMPANY].[ContactRole] tb ON i.crRoleId = tb.crRoleId
   END TRY 
   BEGIN CATCH 
     ROLLBACK 
   END CATCH 
 END

GO


