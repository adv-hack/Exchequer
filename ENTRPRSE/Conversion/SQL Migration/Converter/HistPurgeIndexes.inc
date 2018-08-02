{SQL script to create indexes on HistPrge table}

'CREATE NONCLUSTERED INDEX [HISTORY_Index_CAA] ON [COMPANY].[HISTPRGE]                                               ' +
'(                                                                                                                 ' +
' [hiExCLass] ASC,                                                                                                 ' +
' [hiYear] ASC                                                                                                     ' +
')                                                                                                                 ' +
'INCLUDE (  [hiCode],                                                                                              ' +
' [hiCurrency],                                                                                                    ' +
' [hiPeriod],                                                                                                      ' +
' [PositionId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF,     ' +
'  ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY];                        ' +
'                                                                                                                  ' +
'ALTER INDEX [HISTORY_Index_CAA] ON [COMPANY].[HISTPRGE] DISABLE;                                                     ' +
'                                                                                                                  ' +
'CREATE UNIQUE NONCLUSTERED INDEX [HISTORY_Index_Identity] ON [COMPANY].[HISTPRGE]                                   ' +
'(                                                                                                                 ' +
' [PositionId] ASC                                                                                                 ' +
')WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ' +
'  ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];                                         ' +
'                                                                                                                  ' +
'ALTER INDEX [HISTORY_Index_Identity] ON [COMPANY].[HISTPRGE] DISABLE;                                                ' +
'                                                                                                                  ' +
'CREATE NONCLUSTERED INDEX [HISTORY_Index_OLE] ON [COMPANY].[HISTPRGE]                                               ' +
'(                                                                                                                 ' +
' [hiCode] ASC,                                                                                                    ' +
' [hiExCLass] ASC,                                                                                                 ' +
' [hiCurrency] ASC,                                                                                                ' +
' [hiYear] ASC,                                                                                                    ' +
' [hiPeriod] ASC                                                                                                   ' +
')                                                                                                                 ' +
'INCLUDE (  [hiBudget],                                                                                            ' +
' [hiRevisedBudget1],                                                                                              ' +
' [hiRevisedBudget2],                                                                                              ' +
' [hiRevisedBudget3],                                                                                              ' +
' [hiRevisedBudget4],                                                                                              ' +
' [hiRevisedBudget5],                                                                                              ' +
' [PositionId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF,     ' +
' ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY];                         ' +
'                                                                                                                  ' +
'ALTER INDEX [HISTORY_Index_OLE] ON [COMPANY].[HISTPRGE] DISABLE;                                                     ' +
'                                                                                                                  ' +
'SET ARITHABORT ON                                                                                                 ' +
'SET CONCAT_NULL_YIELDS_NULL ON                                                                                    ' +
'SET QUOTED_IDENTIFIER ON                                                                                          ' +
'SET ANSI_NULLS ON                                                                                                 ' +
'SET ANSI_PADDING ON                                                                                               ' +
'SET ANSI_WARNINGS ON                                                                                              ' +
'SET NUMERIC_ROUNDABORT OFF;                                                                                        ' +
'                                                                                                                  ' +
'CREATE UNIQUE NONCLUSTERED INDEX [HISTORY_Index0] ON [COMPANY].[HISTPRGE]                                           ' +
'(                                                                                                                 ' +
' [hiExCLass] ASC,                                                                                                 ' +
' [hiCodeComputed] ASC,                                                                                            ' +
' [hiCurrency] ASC,                                                                                                ' +
' [hiYear] ASC,                                                                                                    ' +
' [hiPeriod] ASC                                                                                                   ' +
')                                                                                                                 ' +
'INCLUDE (  [PositionId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF,' +
'   ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];                                        ' +
'                                                                                                                  ' +
'ALTER INDEX [HISTORY_Index0] ON [COMPANY].[HISTPRGE] DISABLE;                                                                ' +
'                                                                                                                  ' +
'CREATE UNIQUE CLUSTERED INDEX [HISTORY_IndexCandidate] ON [COMPANY].[HISTPRGE]                                      ' +
'(                                                                                                                 ' +
' [hiExCLass] ASC,                                                                                                 ' +
' [hiCodeComputed] ASC,                                                                                            ' +
' [hiCurrency] ASC,                                                                                                ' +
' [hiYear] ASC,                                                                                                    ' +
' [hiPeriod] ASC,                                                                                                  ' +
' [PositionId] ASC                                                                                                 ' +
')WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF,' +
'   ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY];                       ' +
'                                                                                                                  ' +
'CREATE NONCLUSTERED INDEX [HISTORY_IndexCandidate2] ON [COMPANY].[HISTPRGE]                                         ' +
'(                                                                                                                 ' +
' [hiExCLass] ASC,                                                                                                 ' +
' [hiCurrency] ASC,                                                                                                ' +
' [hiPeriod] ASC,                                                                                                  ' +
' [hiYear] ASC                                                                                                     ' +
')                                                                                                                 ' +
'INCLUDE (  [hiCodeComputed]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF,' +
' ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY];                         ' +
'                                                                                                                  ' +
'ALTER INDEX [HISTORY_IndexCandidate2] ON [COMPANY].[HISTPRGE] DISABLE;                                            ' +
'                                                                                                                  ' +
'CREATE NONCLUSTERED INDEX [idx_History_Employee] ON [COMPANY].[HISTPRGE]                                          ' +
'(                                                                                                                 ' +
' [hiExCLass] ASC,                                                                                                 ' +
' [hiCode] ASC                                                                                                     ' +
')                                                                                                                 ' +
'INCLUDE (  [hiCurrency],                                                                                          ' +
' [hiYear],                                                                                                        ' +
' [hiPeriod],                                                                                                      ' +
' [PositionId],                                                                                                    ' +
' [hiSales],                                                                                                       ' +
' [hiPurchases],                                                                                                   ' +
' [hiCleared],                                                                                                     ' +
' [hiBudget],                                                                                                      ' +
' [hiRevisedBudget1],                                                                                              ' +
' [hiRevisedBudget2],                                                                                              ' +
' [hiRevisedBudget3],                                                                                              ' +
' [hiRevisedBudget4],                                                                                              ' +
' [hiRevisedBudget5],                                                                                              ' +
' [hiValue1],                                                                                                      ' +
' [hiValue2],                                                                                                      ' +
' [hiValue3])                                                                                                      ' +
'WHERE ([hiExClass]=(92))                                                                                          ' +
'WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF,                   ' +
' ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];                                         ' +
'                                                                                                                  ' +
'ALTER INDEX [idx_History_Employee] ON [COMPANY].[HISTPRGE] DISABLE;                                               ' +
'                                                                                                                  ' +
'CREATE NONCLUSTERED INDEX [idx_History_JobActual] ON [COMPANY].[HISTPRGE]                                         ' +
'(                                                                                                                 ' +
' [hiExCLass] ASC,                                                                                                 ' +
' [hiCode] ASC                                                                                                     ' +
')                                                                                                                 ' +
'INCLUDE (  [hiCurrency],                                                                                          ' +
' [hiYear],                                                                                                        ' +
' [hiPeriod],                                                                                                      ' +
' [PositionId],                                                                                                    ' +
' [hiSales],                                                                                                       ' +
' [hiPurchases],                                                                                                   ' +
' [hiCleared],                                                                                                     ' +
' [hiBudget],                                                                                                      ' +
' [hiRevisedBudget1],                                                                                              ' +
' [hiRevisedBudget2],                                                                                              ' +
' [hiRevisedBudget3],                                                                                              ' +
' [hiRevisedBudget4],                                                                                              ' +
' [hiRevisedBudget5],                                                                                              ' +
' [hiValue1],                                                                                                      ' +
' [hiValue2],                                                                                                      ' +
' [hiValue3])                                                                                                      ' +
'WHERE ([hiExClass] IN ((74), (75)))                                                                               ' +
'WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF,                   ' +
' ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];                                         ' +
'                                                                                                                  ' +
'ALTER INDEX [idx_History_JobActual] ON [COMPANY].[HISTPRGE] DISABLE;                                              ' +
'                                                                                                                  ' +
'CREATE NONCLUSTERED INDEX [idx_History_JobCosting] ON [COMPANY].[HISTPRGE]                                        ' +
'(                                                                                                                 ' +
' [hiExCLass] ASC,                                                                                                 ' +
' [hiCode] ASC                                                                                                     ' +
')                                                                                                                 ' +
'INCLUDE (  [hiCurrency],                                                                                          ' +
' [hiYear],                                                                                                        ' +
' [hiPeriod],                                                                                                      ' +
' [PositionId],                                                                                                    ' +
' [hiSales],                                                                                                       ' +
' [hiPurchases],                                                                                                   ' +
' [hiCleared],                                                                                                     ' +
' [hiBudget],                                                                                                      ' +
' [hiRevisedBudget1],                                                                                              ' +
' [hiRevisedBudget2],                                                                                              ' +
' [hiRevisedBudget3],                                                                                              ' +
' [hiRevisedBudget4],                                                                                              ' +
' [hiRevisedBudget5],                                                                                              ' +
' [hiValue1],                                                                                                      ' +
' [hiValue2],                                                                                                      ' +
' [hiValue3])                                                                                                      ' +
'WHERE ([hiExClass]=(91))                                                                                          ' +
'WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,                                        ' +
' DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];                    ' +
'                                                                                                                  ' +
'ALTER INDEX [idx_History_JobCosting] ON [COMPANY].[HISTPRGE] DISABLE;                                             ' +
'                                                                                                                  ' +
'CREATE NONCLUSTERED INDEX [idx_History_Nominal] ON [COMPANY].[HISTPRGE]                                           ' +
'(                                                                                                                 ' +
' [hiExCLass] ASC,                                                                                                 ' +
' [hiCode] ASC                                                                                                     ' +
')                                                                                                                 ' +
'INCLUDE (  [hiCurrency],                                                                                          ' +
' [hiYear],                                                                                                        ' +
' [hiPeriod],                                                                                                      ' +
' [PositionId],                                                                                                    ' +
' [hiSales],                                                                                                       ' +
' [hiPurchases],                                                                                                   ' +
' [hiCleared],                                                                                                     ' +
' [hiBudget],                                                                                                      ' +
' [hiRevisedBudget1],                                                                                              ' +
' [hiRevisedBudget2],                                                                                              ' +
' [hiRevisedBudget3],                                                                                              ' +
' [hiRevisedBudget4],                                                                                              ' +
' [hiRevisedBudget5],                                                                                              ' +
' [hiValue1],                                                                                                      ' +
' [hiValue2],                                                                                                      ' +
' [hiValue3])                                                                                                      ' +
'WHERE ([hiExClass] IN ((65), (66), (67), (70), (72)))                                                             ' +
'WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF,                   ' +
' ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];                                         ' +
'                                                                                                                  ' +
'ALTER INDEX [idx_History_Nominal] ON [COMPANY].[HISTPRGE] DISABLE                                                 ' +
'                                                                                                                  ' +
'CREATE NONCLUSTERED INDEX [idx_History_Stock] ON [COMPANY].[HISTPRGE]                                             ' +
'(                                                                                                                 ' +
' [hiExCLass] ASC,                                                                                                 ' +
' [hiCode] ASC                                                                                                     ' +
')                                                                                                                 ' +
'INCLUDE (  [hiCurrency],                                                                                          ' +
' [hiYear],                                                                                                        ' +
' [hiPeriod],                                                                                                      ' +
' [PositionId],                                                                                                    ' +
' [hiSales],                                                                                                       ' +
' [hiPurchases],                                                                                                   ' +
' [hiCleared],                                                                                                     ' +
' [hiBudget],                                                                                                      ' +
' [hiRevisedBudget1],                                                                                              ' +
' [hiRevisedBudget2],                                                                                              ' +
' [hiRevisedBudget3],                                                                                              ' +
' [hiRevisedBudget4],                                                                                              ' +
' [hiRevisedBudget5],                                                                                              ' +
' [hiValue1],                                                                                                      ' +
' [hiValue2],                                                                                                      ' +
' [hiValue3])                                                                                                      ' +
'WHERE ([hiExClass] IN ((227), (230), (236), (239), (247), (248), (68), (71), (77), (80), (88)))                   ' +
'WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF,                   ' +
' ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];                                         ' +
'                                                                                                                  ' +
'ALTER INDEX [idx_History_Stock] ON [COMPANY].[HISTPRGE] DISABLE;                                                  ' +
'                                                                                                                  ' +
'CREATE NONCLUSTERED INDEX [idx_History_Trader] ON [COMPANY].[HISTPRGE]                                            ' +
'(                                                                                                                 ' +
' [hiExCLass] ASC,                                                                                                 ' +
' [hiCode] ASC                                                                                                     ' +
')                                                                                                                 ' +
'INCLUDE (  [hiCurrency],                                                                                          ' +
' [hiYear],                                                                                                        ' +
' [hiPeriod],                                                                                                      ' +
' [PositionId],                                                                                                    ' +
' [hiSales],                                                                                                       ' +
' [hiPurchases],                                                                                                   ' +
' [hiCleared],                                                                                                     ' +
' [hiBudget],                                                                                                      ' +
' [hiRevisedBudget1],                                                                                              ' +
' [hiRevisedBudget2],                                                                                              ' +
' [hiRevisedBudget3],                                                                                              ' +
' [hiRevisedBudget4],                                                                                              ' +
' [hiRevisedBudget5],                                                                                              ' +
' [hiValue1],                                                                                                      ' +
' [hiValue2],                                                                                                      ' +
' [hiValue3])                                                                                                      ' +
'WHERE ([hiExClass] IN ((85), (86), (87)))                                                                         ' +
'WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF,                   ' +
' ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];                                         ' +
'                                                                                                                  ' +
'ALTER INDEX [idx_History_Trader] ON [COMPANY].[HISTPRGE] DISABLE;                                                 ' +
'                                                                                                                  ' +
'CREATE NONCLUSTERED INDEX [idx_History_TraderStockAnalysis] ON [COMPANY].[HISTPRGE]                               ' +
'(                                                                                                                 ' +
' [hiExCLass] ASC,                                                                                                 ' +
' [hiCode] ASC                                                                                                     ' +
')                                                                                                                 ' +
'INCLUDE (  [hiCurrency],                                                                                          ' +
' [hiYear],                                                                                                        ' +
' [hiPeriod],                                                                                                      ' +
' [PositionId],                                                                                                    ' +
' [hiSales],                                                                                                       ' +
' [hiPurchases],                                                                                                   ' +
' [hiCleared],                                                                                                     ' +
' [hiBudget],                                                                                                      ' +
' [hiRevisedBudget1],                                                                                              ' +
' [hiRevisedBudget2],                                                                                              ' +
' [hiRevisedBudget3],                                                                                              ' +
' [hiRevisedBudget4],                                                                                              ' +
' [hiRevisedBudget5],                                                                                              ' +
' [hiValue1],                                                                                                      ' +
' [hiValue2],                                                                                                      ' +
' [hiValue3])                                                                                                      ' +
'WHERE ([hiExClass]=(69))                                                                                          ' +
'WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF,                   ' +
' ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];                                         ' +
'                                                                                                                  ' +
'ALTER INDEX [idx_History_TraderStockAnalysis] ON [COMPANY].[HISTPRGE] DISABLE;                                    ' +
'                                                                                                                  ' +
'CREATE NONCLUSTERED INDEX [idx_History_VAT] ON [COMPANY].[HISTPRGE]                                               ' +
'(                                                                                                                 ' +
' [hiExCLass] ASC,                                                                                                 ' +
' [hiCode] ASC                                                                                                     ' +
')                                                                                                                 ' +
'INCLUDE (  [hiCurrency],                                                                                          ' +
' [hiYear],                                                                                                        ' +
' [hiPeriod],                                                                                                      ' +
' [PositionId],                                                                                                    ' +
' [hiSales],                                                                                                       ' +
' [hiPurchases],                                                                                                   ' +
' [hiCleared],                                                                                                     ' +
' [hiBudget],                                                                                                      ' +
' [hiRevisedBudget1],                                                                                              ' +
' [hiRevisedBudget2],                                                                                              ' +
' [hiRevisedBudget3],                                                                                              ' +
' [hiRevisedBudget4],                                                                                              ' +
' [hiRevisedBudget5],                                                                                              ' +
' [hiValue1],                                                                                                      ' +
' [hiValue2],                                                                                                      ' +
' [hiValue3])                                                                                                      ' +
'WHERE ([hiExClass] IN ((73), (79)))                                                                               ' +
'WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF,                   ' +
' ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];                                         ' +
'                                                                                                                  ' +
'ALTER INDEX [idx_History_VAT] ON [COMPANY].[HISTPRGE] DISABLE;                                                    ';

