

/****** Object:  View [!ActiveSchema!].[evw_SystemSettings]    Script Date: 12/12/2014 11:10:13 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_SystemSettings]'))
DROP VIEW [!ActiveSchema!].evw_SystemSettings
GO

CREATE VIEW [!ActiveSchema!].evw_SystemSettings
AS
SELECT CompanyCode                          = REPLACE(REPLACE('[!ActiveSchema!]', '[',''), ']', '')
     , CompanyName                          = UserName
     , CompanyAddressLine1                  = DetailAddr1
     , CompanyAddressLine2                  = DetailAddr2
     , CompanyAddressLine3                  = DetailAddr3
     , CompanyAddressLine4                  = DetailAddr4
     , CompanyAddressLine5                  = DetailAddr5
     , CompanyPhoneno                       = DetailTel
     , CompanyFaxNo                         = DetailFax
     , UpdateBalanceOnPost                  = UpBalOnPost
     , IncludeVATInCommittedBalance
     , AgeingMode                           = DebtLMode
     , AgePurchasesByInvoiceDate            = PurchUIDate
     , AgeSalesByInvoiceDate                = StaUIDate
     , CurrencyConsolidationMethod          = TotalConv
     , UseCompanyRate                       = CASE WHEN TotalConv = 'C' THEN 1 ELSE 0 END
     , UseDailyRate                         = CASE WHEN TotalConv = 'V' THEN 1 ELSE 0 END
     , DebtorControlNominalCode             = NomCtrlDebtors
     , CreditorControlNominalCode           = NomCtrlCreditors
     , PLStartControlNominalCode            = NomCtrlPLStart
     , PLEndControlNominalCode              = NomCtrlPLEnd
     , ProfitBFControlNominalCode           = NomCtrlProfitBF
     , LineDiscountGivenControlNominalCode  = NomCtrlLDiscGiven
     , LineDiscountTakenControlNominalCode  = NomCtrlLDiscTaken
     , NoOfDPNet                            = NoNetDec
     , NoOfDPCost                           = NoCosDec
     , NoOfDPQuantity                       = NoQtyDec
     , UseSeparateDiscounts                 = SepDiscounts
     , CurrentExchequerYear                 = CYr
     , CurrentYear                          = 1900 + Cyr
     , CurrentPeriod                        = CPr
     , CurrentPeriodKey                     = ((1900 + Cyr) * 1000) + CPr
     , NoOfPeriodsInYear                    = PrinYr
     , SystemStartDate                      = CONVERT(DATE, MonWk1, 121)
     , AuditYear                            = CASE
                                              WHEN SS.AuditYr > 50 THEN (1900 + SS.AuditYr)
                                              ELSE 0
                                              END
     , AuditExchequerYear                   = SS.AuditYr
     , AuditPeriod                          = SS.AuditPr
     , AuditPeriodKey                       = (CASE
                                               WHEN SS.AuditYr > 50 THEN (1900 + SS.AuditYr)
                                               ELSE 0
                                               END * 1000) + SS.AuditPr
     , AuditDate                            = SS.AuditDate
     , UseCostCentreAndDepartments          = SS.UseCCDep
     , PostToCostCentreOrDepartment         = SS.PostCCNom
     , PostToCostCentreAndDepartment        = SS.PostCCDCombo
     , BudgetByCostCentreOrDepartment       = SS.PostCCNom
     , BudgetByCostCentreAndDepartment      = SS.PostCCDCombo
     , ProtectYourReference                 = SS.ProtectYRef
     , VATCurrency                          = SS.VATCurr
     , DeductBOMComponents                  = SS.DeadBOM
     , AllocateStockWhenPicked              = SS.UseWIss4All
     , FreeStockExcludesSalesOrders         = SS.FreeExAll
     , OrdersToAllocateStockWhenPicked      = SS.UsePick4All
     , DeliverPickedItemsOnly               = SS.DelPickOnly
     , UseMultiLocations                    = SS.UseMLoc
     , AllowPostToPreviousPeriods           = ~(SS.PrevPrOff)
     , AuthorisationMode                    = SS.AuthMode
     , IntrastatEnabled                     = SS.Intrastat
     , CurrentCountryCode                   = SS.USRCntryCode
     , AutoPostUplift                       = SS.UseUpliftNC
     , UseSalesReceiptPayInReference        = SS.UsePayIn
     , LiveStockCOSValuation                = SS.AutoValStk

FROM   !ActiveSchema!.EXCHQSS SS
WHERE   common.GetString(IDCode, 1) = 'SYS'

GO