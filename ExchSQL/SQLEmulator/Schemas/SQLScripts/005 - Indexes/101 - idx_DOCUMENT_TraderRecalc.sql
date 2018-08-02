/****** Object:  Index [idx_DOCUMENT_TraderRecalc]    Script Date: 23/03/2015 08:37:48 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') AND name = N'idx_DOCUMENT_TraderRecalc')
DROP INDEX [idx_DOCUMENT_TraderRecalc] ON [!ActiveSchema!].[DOCUMENT]
GO

/****** Object:  Index [idx_DOCUMENT_TraderRecalc]    Script Date: 23/03/2015 08:37:48 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') AND name = N'idx_DOCUMENT_TraderRecalc')
CREATE NONCLUSTERED INDEX [idx_DOCUMENT_TraderRecalc] ON [!ActiveSchema!].[DOCUMENT]
(
	[thNomAuto] ASC,
	[thDocType] ASC,
	[thAcCodeComputed] ASC
)
INCLUDE ( 	[thRunNo],
	[thCurrency],
	[thYear],
	[thPeriod],
	[thCompanyRate],
	[thDailyRate],
	[thNetValue],
	[thTotalVAT],
	[thSettleDiscAmount],
	[thTotalLineDiscount],
	[thSettleDiscTaken],
	[thVariance],
	[thTotalCost],
	[thRevalueAdj],
	[PostDiscAm],
	[thControlGL],
	[thCurrencyTriInvert]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


