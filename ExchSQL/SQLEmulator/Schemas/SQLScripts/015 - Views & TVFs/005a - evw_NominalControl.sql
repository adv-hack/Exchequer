
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_NominalControl]'))
DROP VIEW [!ActiveSchema!].evw_NominalControl
GO

CREATE VIEW !ActiveSchema!.evw_NominalControl WITH VIEW_METADATA
AS
SELECT Debtor                     = SS.NomCtrlDebtors
     , Creditor                   = SS.NomCtrlCreditors
     , PLStart                    = SS.NomCtrlPLStart
     , PLEnd                      = SS.NomCtrlPLEnd
     , ProfitBF                   = SS.NomCtrlProfitBF
     , DiscountGiven              = SS.NomCtrlDiscountGiven
     , DiscountTaken              = SS.NomCtrlDiscountTaken
     , LineDiscountGiven          = SS.NomCtrlLDiscGiven
     , LineDiscountTaken          = SS.NomCtrlLDiscTaken
     , InputVAT                   = SS.NomCtrlInVAT
     , OutputVAT                  = SS.NomCtrlOutVAT
     , FreightUplift              = SS.NomCtrlFreightNC
     , SalesCommitment            = SS.NomCtrlSalesComm
     , PurchaseCommitment         = SS.NomCtrlPurchComm
     , CurrencyVariance           = SS.NomCtrlCurrVar
     , UnrealisedCurrencyVariance = SS.NomCtrlUnRCurrVar

FROM  !ActiveSchema!.EXCHQSS SS
WHERE common.GetString(IDCode, 1) = 'SYS'

GO