USE [DATABASE]
GO

/****** Object:  Table [COMPANY].[AccountContactRole]    Script Date: 14/01/2014 16:51:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [COMPANY].[AccountContactRole](
	[acrAccountContactRoleId] [int] IDENTITY(1,1) NOT NULL,
	[acrContactId] [int] NOT NULL,
	[acrRoleId] [int] NOT NULL,
	[acrDateCreated] [datetime] NOT NULL,
 CONSTRAINT [epk_AccountContactRole] PRIMARY KEY CLUSTERED 
(
	[acrAccountContactRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [COMPANY].[AccountContactRole] ADD  CONSTRAINT [DF_AccountContactRole_acrDateCreated]  DEFAULT (getdate()) FOR [acrDateCreated]
GO

ALTER TABLE [COMPANY].[AccountContactRole]  WITH CHECK ADD  CONSTRAINT [efk_AccountContact_AccountContactRole] FOREIGN KEY([acrContactId])
REFERENCES [COMPANY].[AccountContact] ([acoContactId])
GO

ALTER TABLE [COMPANY].[AccountContactRole] CHECK CONSTRAINT [efk_AccountContact_AccountContactRole]
GO

ALTER TABLE [COMPANY].[AccountContactRole]  WITH CHECK ADD  CONSTRAINT [efk_ContactRole_AccountContactRole] FOREIGN KEY([acrRoleId])
REFERENCES [COMPANY].[ContactRole] ([crRoleId])
GO

ALTER TABLE [COMPANY].[AccountContactRole] CHECK CONSTRAINT [efk_ContactRole_AccountContactRole]
GO


