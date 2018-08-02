

/****** Object:  Index [idx_History_JobActual]    Script Date: 12/12/2014 09:12:51 ******/
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY]') AND name = N'idx_History_JobActual')
DROP INDEX [idx_History_JobActual] ON [!ActiveSchema!].[HISTORY]
GO

CREATE NONCLUSTERED INDEX [idx_History_JobActual] ON [!ActiveSchema!].[HISTORY]
(
	[hiExCLass] ASC,
	[hiCode] ASC
)
INCLUDE ( 	[hiCurrency],
	[hiYear],
	[hiPeriod],
	[PositionId],
	[hiSales],
	[hiPurchases],
	[hiCleared],
	[hiBudget],
	[hiRevisedBudget1],
	[hiRevisedBudget2],
	[hiRevisedBudget3],
	[hiRevisedBudget4],
	[hiRevisedBudget5],
	[hiValue1],
	[hiValue2],
	[hiValue3]) 
WHERE ([hiExClass] IN ((74), (75)) )
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [idx_History_JobCosting]    Script Date: 12/12/2014 09:12:51 ******/
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY]') AND name = N'idx_History_JobCosting')
DROP INDEX [idx_History_JobCosting] ON [!ActiveSchema!].[HISTORY]
GO

CREATE NONCLUSTERED INDEX [idx_History_JobCosting] ON [!ActiveSchema!].[HISTORY]
(
	[hiExCLass] ASC,
	[hiCode] ASC
)
INCLUDE ( 	[hiCurrency],
	[hiYear],
	[hiPeriod],
	[PositionId],
	[hiSales],
	[hiPurchases],
	[hiCleared],
	[hiBudget],
	[hiRevisedBudget1],
	[hiRevisedBudget2],
	[hiRevisedBudget3],
	[hiRevisedBudget4],
	[hiRevisedBudget5],
	[hiValue1],
	[hiValue2],
	[hiValue3]) 
WHERE ([hiExClass] IN ((91)) )
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



/****** Object:  Index [idx_History_Job]    Script Date: 12/12/2014 09:12:51 ******/
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY]') AND name = N'idx_History_Employee')
DROP INDEX [idx_History_Employee] ON [!ActiveSchema!].[HISTORY]
GO

CREATE NONCLUSTERED INDEX [idx_History_Employee] ON [!ActiveSchema!].[HISTORY]
(
	[hiExCLass] ASC,
	[hiCode] ASC
)
INCLUDE ([hiCurrency],
	[hiYear],
	[hiPeriod],
	[PositionId],
	[hiSales],
	[hiPurchases],
	[hiCleared],
	[hiBudget],
	[hiRevisedBudget1],
	[hiRevisedBudget2],
	[hiRevisedBudget3],
	[hiRevisedBudget4],
	[hiRevisedBudget5],
	[hiValue1],
	[hiValue2],
	[hiValue3]) 
WHERE ([hiExClass] IN ((92)))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [idx_History_Trader]    Script Date: 12/12/2014 09:12:51 ******/
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY]') AND name = N'idx_History_Trader')
DROP INDEX [idx_History_Trader] ON [!ActiveSchema!].[HISTORY]
GO

CREATE NONCLUSTERED INDEX [idx_History_Trader] ON [!ActiveSchema!].[HISTORY]
(
	[hiExCLass] ASC,
	[hiCode] ASC
)
INCLUDE ([hiCurrency],
	[hiYear],
	[hiPeriod],
	[PositionId],
	[hiSales],
	[hiPurchases],
	[hiCleared],
	[hiBudget],
	[hiRevisedBudget1],
	[hiRevisedBudget2],
	[hiRevisedBudget3],
	[hiRevisedBudget4],
	[hiRevisedBudget5],
	[hiValue1],
	[hiValue2],
	[hiValue3]) 
WHERE ([hiExClass] IN ((85),(86),(87) ))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [idx_History_VAT]    Script Date: 12/12/2014 09:12:51 ******/
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY]') AND name = N'idx_History_VAT')
DROP INDEX [idx_History_VAT] ON [!ActiveSchema!].[HISTORY]
GO

CREATE NONCLUSTERED INDEX [idx_History_VAT] ON [!ActiveSchema!].[HISTORY]
(
	[hiExCLass] ASC,
	[hiCode] ASC
)
INCLUDE ([hiCurrency],
	[hiYear],
	[hiPeriod],
	[PositionId],
	[hiSales],
	[hiPurchases],
	[hiCleared],
	[hiBudget],
	[hiRevisedBudget1],
	[hiRevisedBudget2],
	[hiRevisedBudget3],
	[hiRevisedBudget4],
	[hiRevisedBudget5],
	[hiValue1],
	[hiValue2],
	[hiValue3]) 
WHERE ([hiExClass] IN ((73),(79)))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [idx_History_Nominal]    Script Date: 12/12/2014 09:12:51 ******/
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY]') AND name = N'idx_History_Nominal')
DROP INDEX [idx_History_Nominal] ON [!ActiveSchema!].[HISTORY]
GO

CREATE NONCLUSTERED INDEX [idx_History_Nominal] ON [!ActiveSchema!].[HISTORY]
(
	[hiExCLass] ASC,
	[hiCode] ASC
)
INCLUDE ([hiCurrency],
	[hiYear],
	[hiPeriod],
	[PositionId],
	[hiSales],
	[hiPurchases],
	[hiCleared],
	[hiBudget],
	[hiRevisedBudget1],
	[hiRevisedBudget2],
	[hiRevisedBudget3],
	[hiRevisedBudget4],
	[hiRevisedBudget5],
	[hiValue1],
	[hiValue2],
	[hiValue3]) 
WHERE ([hiExClass] IN ((65),(66),(67),(70),(72)))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [idx_History_Stock]    Script Date: 12/12/2014 09:12:51 ******/
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY]') AND name = N'idx_History_Stock')
DROP INDEX [idx_History_Stock] ON [!ActiveSchema!].[HISTORY]
GO

CREATE NONCLUSTERED INDEX [idx_History_Stock] ON [!ActiveSchema!].[HISTORY]
(
	[hiExCLass] ASC,
	[hiCode] ASC
)
INCLUDE ([hiCurrency],
	[hiYear],
	[hiPeriod],
	[PositionId],
	[hiSales],
	[hiPurchases],
	[hiCleared],
	[hiBudget],
	[hiRevisedBudget1],
	[hiRevisedBudget2],
	[hiRevisedBudget3],
	[hiRevisedBudget4],
	[hiRevisedBudget5],
	[hiValue1],
	[hiValue2],
	[hiValue3]) 
WHERE ([hiExClass] IN ((227),(230),(236),(239),(247),(248),(68),(71),(77),(80),(88) ))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [idx_History_TraderStockAnalysis]    Script Date: 12/12/2014 09:12:51 ******/
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY]') AND name = N'idx_History_TraderStockAnalysis')
DROP INDEX [idx_History_TraderStockAnalysis] ON [!ActiveSchema!].[HISTORY]
GO

CREATE NONCLUSTERED INDEX [idx_History_TraderStockAnalysis] ON [!ActiveSchema!].[HISTORY]
(
	[hiExCLass] ASC,
	[hiCode] ASC
)
INCLUDE ([hiCurrency],
	[hiYear],
	[hiPeriod],
	[PositionId],
	[hiSales],
	[hiPurchases],
	[hiCleared],
	[hiBudget],
	[hiRevisedBudget1],
	[hiRevisedBudget2],
	[hiRevisedBudget3],
	[hiRevisedBudget4],
	[hiRevisedBudget5],
	[hiValue1],
	[hiValue2],
	[hiValue3]) 
WHERE ([hiExClass] IN ((69)))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO