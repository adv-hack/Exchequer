-- Target Table columns
DECLARE @srcIDCode varbinary(4)
      , @srcOpt varchar(1)
      , @srcOMonWk1 varbinary(7)
      , @srcPrinYr int
      , @srcFiltSNoBinLoc bit
      , @srcKeepBinHist bit
      , @srcUseBKTheme bit
      , @srcUserName varchar(45)
      , @srcAuditYr int
      , @srcAuditPr int
      , @srcSpare6 int
      , @srcManROCP bit
      , @srcVATCurr int
      , @srcNoCosDec int
      , @srcCurrBase int
      , @srcMuteBeep bit
      , @srcShowStkGP bit
      , @srcAutoValStk bit
      , @srcDelPickOnly bit
      , @srcUseMLoc bit
      , @srcEditSinSer bit
      , @srcWarnYRef bit
      , @srcUseLocDel bit
      , @srcPostCCNom bit
      , @srcAlTolVal float
      , @srcAlTolMode int
      , @srcDebtLMode int
      , @srcAutoGenVar bit
      , @srcAutoGenDisc bit
      , @srcUseModuleSec bit
      , @srcProtectPost bit
      , @srcUsePick4All bit
      , @srcBigStkTree bit
      , @srcBigJobTree bit
      , @srcShowQtySTree bit
      , @srcProtectYRef bit
      , @srcPurchUIDate bit
      , @srcUseUpliftNC bit
      , @srcUseWIss4All bit
      , @srcUseSTDWOP bit
      , @srcUseSalesAnal bit
      , @srcPostCCDCombo bit
      , @srcUseClassToolB bit
      , @srcWOPStkCopMode int
      , @srcUSRCntryCode varchar(3)
      , @srcNoNetDec int
      , @srcDebTrig varbinary(3)
      , @srcBKThemeNo int
      , @srcUseGLClass bit
      , @srcSpare4 varbinary(1)
      , @srcNoInvLines int
      , @srcWksODue int
      , @srcCPr int
      , @srcCYr int
      , @srcOAuditDate varchar(6)
      , @srcTradeTerm bit
      , @srcStaSepCr bit
      , @srcStaAgeMthd int
      , @srcStaUIDate bit
      , @srcSepRunPost bit
      , @srcQUAllocFlg bit
      , @srcDeadBOM bit
      , @srcAuthMode varchar(1)
      , @srcIntraStat bit
      , @srcAnalStkDesc bit
      , @srcAutoStkVal varchar(1)
      , @srcAutoBillUp bit
      , @srcAutoCQNo bit
      , @srcIncNotDue bit
      , @srcUseBatchTot bit
      , @srcUseStock bit
      , @srcAutoNotes bit
      , @srcHideMenuOpt bit
      , @srcUseCCDep bit
      , @srcNoHoldDisc bit
      , @srcAutoPrCalc bit
      , @srcStopBadDr bit
      , @srcUsePayIn bit
      , @srcUsePasswords bit
      , @srcPrintReciept bit
      , @srcExternCust bit
      , @srcNoQtyDec int
      , @srcExternSIN bit
      , @srcPrevPrOff bit
      , @srcDefPcDisc bit
      , @srcTradCodeNum bit
      , @srcUpBalOnPost bit
      , @srcShowInvDisc bit
      , @srcSepDiscounts bit
      , @srcUseCreditChk bit
      , @srcUseCRLimitChk bit
      , @srcAutoClearPay bit
      , @srcTotalConv varchar(1)
      , @srcDispPrAsMonths bit
      , @srcNomCtrlInVAT int
      , @srcNomCtrlOutVAT int
      , @srcNomCtrlDebtors int
      , @srcNomCtrlCreditors int
      , @srcNomCtrlDiscountGiven int
      , @srcNomCtrlDiscountTaken int
      , @srcNomCtrlLDiscGiven int
      , @srcNomCtrlLDiscTaken int
      , @srcNomCtrlProfitBF int
      , @srcNomCtrlCurrVar int
      , @srcNomCtrlUnRCurrVar int
      , @srcNomCtrlPLStart int
      , @srcNomCtrlPLEnd int
      , @srcNomCtrlFreightNC int
      , @srcNomCtrlSalesComm int
      , @srcNomCtrlPurchComm int
      , @srcNomCtrlRetSurcharge int
      , @srcNomCtrlSpare8 int
      , @srcNomCtrlSpare9 int
      , @srcNomCtrlSpare10 int
      , @srcNomCtrlSpare11 int
      , @srcNomCtrlSpare12 int
      , @srcNomCtrlSpare13 int
      , @srcNomCtrlSpare14 int
      , @srcDetailAddr1 varchar(30)
      , @srcDetailAddr2 varchar(30)
      , @srcDetailAddr3 varchar(30)
      , @srcDetailAddr4 varchar(30)
      , @srcDetailAddr5 varchar(30)
      , @srcDirectCust varchar(10)
      , @srcDirectSupp varchar(10)
      , @srcTermsofTrade1 varchar(80)
      , @srcTermsofTrade2 varchar(80)
      , @srcNomPayFrom int
      , @srcNomPayToo int
      , @srcSettleDisc float
      , @srcSettleDays int
      , @srcNeedBMUp bit
      , @srcIgnoreBDPW bit
      , @srcInpPack bit
      , @srcSpare32 bit
      , @srcVATCode varchar(1)
      , @srcPayTerms int
      , @srcOTrigDate varchar(6)
      , @srcStaAgeInt int
      , @srcQuoOwnDate bit
      , @srcFreeExAll bit
      , @srcDirOwnCount bit
      , @srcStaShowOS bit
      , @srcLiveCredS bit
      , @srcBatchPPY bit
      , @srcWarnJC bit
      , @srcTxLateCR bit
      , @srcConsvMem bit
      , @srcDefBankNom int
      , @srcUseDefBank bit
      , @srcHideExLogo bit
      , @srcAMMThread bit
      , @srcAMMPreview1 bit
      , @srcAMMPreview2 bit
      , @srcEntULogCount int
      , @srcDefSRCBankNom int
      , @srcSDNOwnDate bit
      , @srcEXISN varbinary(8)
      , @srcExDemoVer bit
      , @srcDupliVSec bit
      , @srcLastDaily int
      , @srcUserSort varchar(15)
      , @srcUserAcc varchar(20)
      , @srcUserRef varchar(28)
      , @srcSpareBits varbinary(31)
      , @srcGracePeriod int
      , @srcMonWk1 varchar(8)
      , @srcAuditDate varchar(8)
      , @srcTrigDate varchar(8)
      , @srcExUsrSec varbinary(28)
      , @srcUsrLogCount int
      , @srcBinMask varchar(10)
      , @srcSpare5a varchar(4)
      , @srcSpare6a varchar(18)
      , @srcUserBank varchar(25)
      , @srcExSec varbinary(28)
      , @srcLastExpFolio int
      , @srcDetailTel varchar(15)
      , @srcDetailFax varchar(15)
      , @srcUserVATReg varchar(30)
      , @srcEnableTTDDiscounts bit
      , @srcEnableVBDDiscounts bit
      , @srcEnableOverrideLocations bit
      , @srcIncludeVATInCommittedBalance bit
      , @srcVATStandardCode varchar(1)
      , @srcVATStandardDesc varchar(10)
      , @srcVATStandardRate float
      , @srcVATStandardSpare varbinary(1)
      , @srcVATStandardInclude bit
      , @srcVATStandardSpare2 varbinary(2)
      , @srcVATExemptCode varchar(1)
      , @srcVATExemptDesc varchar(10)
      , @srcVATExemptRate float
      , @srcVATExemptSpare varbinary(1)
      , @srcVATExemptInclude bit
      , @srcVATExemptSpare2 varbinary(2)
      , @srcVATZeroCode varchar(1)
      , @srcVATZeroDesc varchar(10)
      , @srcVATZeroRate float
      , @srcVATZeroSpare varbinary(1)
      , @srcVATZeroInclude bit
      , @srcVATZeroSpare2 varbinary(2)
      , @srcVATRate1Code varchar(1)
      , @srcVATRate1Desc varchar(10)
      , @srcVATRate1Rate float
      , @srcVATRate1Spare varbinary(1)
      , @srcVATRate1Include bit
      , @srcVATRate1Spare2 varbinary(2)
      , @srcVATRate2Code varchar(1)
      , @srcVATRate2Desc varchar(10)
      , @srcVATRate2Rate float
      , @srcVATRate2Spare varbinary(1)
      , @srcVATRate2Include bit
      , @srcVATRate2Spare2 varbinary(2)
      , @srcVATRate3Code varchar(1)
      , @srcVATRate3Desc varchar(10)
      , @srcVATRate3Rate float
      , @srcVATRate3Spare varbinary(1)
      , @srcVATRate3Include bit
      , @srcVATRate3Spare2 varbinary(2)
      , @srcVATRate4Code varchar(1)
      , @srcVATRate4Desc varchar(10)
      , @srcVATRate4Rate float
      , @srcVATRate4Spare varbinary(1)
      , @srcVATRate4Include bit
      , @srcVATRate4Spare2 varbinary(2)
      , @srcVATRate5Code varchar(1)
      , @srcVATRate5Desc varchar(10)
      , @srcVATRate5Rate float
      , @srcVATRate5Spare varbinary(1)
      , @srcVATRate5Include bit
      , @srcVATRate5Spare2 varbinary(2)
      , @srcVATRate6Code varchar(1)
      , @srcVATRate6Desc varchar(10)
      , @srcVATRate6Rate float
      , @srcVATRate6Spare varbinary(1)
      , @srcVATRate6Include bit
      , @srcVATRate6Spare2 varbinary(2)
      , @srcVATRate7Code varchar(1)
      , @srcVATRate7Desc varchar(10)
      , @srcVATRate7Rate float
      , @srcVATRate7Spare varbinary(1)
      , @srcVATRate7Include bit
      , @srcVATRate7Spare2 varbinary(2)
      , @srcVATRate8Code varchar(1)
      , @srcVATRate8Desc varchar(10)
      , @srcVATRate8Rate float
      , @srcVATRate8Spare varbinary(1)
      , @srcVATRate8Include bit
      , @srcVATRate8Spare2 varbinary(2)
      , @srcVATRate9Code varchar(1)
      , @srcVATRate9Desc varchar(10)
      , @srcVATRate9Rate float
      , @srcVATRate9Spare varbinary(1)
      , @srcVATRate9Include bit
      , @srcVATRate9Spare2 varbinary(2)
      , @srcVATRate10Code varchar(1)
      , @srcVATRate10Desc varchar(10)
      , @srcVATRate10Rate float
      , @srcVATRate10Spare varbinary(1)
      , @srcVATRate10Include bit
      , @srcVATRate10Spare2 varbinary(2)
      , @srcVATRate11Code varchar(1)
      , @srcVATRate11Desc varchar(10)
      , @srcVATRate11Rate float
      , @srcVATRate11Spare varbinary(1)
      , @srcVATRate11Include bit
      , @srcVATRate11Spare2 varbinary(2)
      , @srcVATRate12Code varchar(1)
      , @srcVATRate12Desc varchar(10)
      , @srcVATRate12Rate float
      , @srcVATRate12Spare varbinary(1)
      , @srcVATRate12Include bit
      , @srcVATRate12Spare2 varbinary(2)
      , @srcVATRate13Code varchar(1)
      , @srcVATRate13Desc varchar(10)
      , @srcVATRate13Rate float
      , @srcVATRate13Spare varbinary(1)
      , @srcVATRate13Include bit
      , @srcVATRate13Spare2 varbinary(2)
      , @srcVATRate14Code varchar(1)
      , @srcVATRate14Desc varchar(10)
      , @srcVATRate14Rate float
      , @srcVATRate14Spare varbinary(1)
      , @srcVATRate14Include bit
      , @srcVATRate14Spare2 varbinary(2)
      , @srcVATRate15Code varchar(1)
      , @srcVATRate15Desc varchar(10)
      , @srcVATRate15Rate float
      , @srcVATRate15Spare varbinary(1)
      , @srcVATRate15Include bit
      , @srcVATRate15Spare2 varbinary(2)
      , @srcVATRate16Code varchar(1)
      , @srcVATRate16Desc varchar(10)
      , @srcVATRate16Rate float
      , @srcVATRate16Spare varbinary(1)
      , @srcVATRate16Include bit
      , @srcVATRate16Spare2 varbinary(2)
      , @srcVATRate17Code varchar(1)
      , @srcVATRate17Desc varchar(10)
      , @srcVATRate17Rate float
      , @srcVATRate17Spare varbinary(1)
      , @srcVATRate17Include bit
      , @srcVATRate17Spare2 varbinary(2)
      , @srcVATRate18Code varchar(1)
      , @srcVATRate18Desc varchar(10)
      , @srcVATRate18Rate float
      , @srcVATRate18Spare varbinary(1)
      , @srcVATRate18Include bit
      , @srcVATRate18Spare2 varbinary(2)
      , @srcVATIAdjCode varchar(1)
      , @srcVATIAdjDesc varchar(10)
      , @srcVATIAdjRate float
      , @srcVATIAdjSpare varbinary(1)
      , @srcVATIAdjInclude bit
      , @srcVATIAdjSpare2 varbinary(2)
      , @srcVATOAdjCode varchar(1)
      , @srcVATOAdjDesc varchar(10)
      , @srcVATOAdjRate float
      , @srcVATOAdjSpare varbinary(1)
      , @srcVATOAdjInclude bit
      , @srcVATOAdjSpare2 varbinary(2)
      , @srcVATSpare8Code varchar(1)
      , @srcVATSpare8Desc varchar(10)
      , @srcVATSpare8Rate float
      , @srcVATSpare8Spare varbinary(1)
      , @srcVATSpare8Include bit
      , @srcVATSpare8Spare2 varbinary(2)
      , @srcHideUDF7 bit
      , @srcHideUDF8 bit
      , @srcHideUDF9 bit
      , @srcHideUDF10 bit
      , @srcHideUDF11 bit
      , @srcSpare2 varbinary(2)
      , @srcVATInterval int
      , @srcSpare3 varbinary(7)
      , @srcVATScheme varchar(1)
      , @srcOLastECSalesDate varchar(6)
      , @srcVATReturnDate varchar(8)
      , @srcLastECSalesDate varchar(8)
      , @srcCurrPeriod varchar(8)
      , @srcUDFCaption1 varchar(15)
      , @srcUDFCaption2 varchar(15)
      , @srcUDFCaption3 varchar(15)
      , @srcUDFCaption4 varchar(15)
      , @srcUDFCaption5 varchar(15)
      , @srcUDFCaption6 varchar(15)
      , @srcUDFCaption7 varchar(15)
      , @srcUDFCaption8 varchar(15)
      , @srcUDFCaption9 varchar(15)
      , @srcUDFCaption10 varchar(15)
      , @srcUDFCaption11 varchar(15)
      , @srcUDFCaption12 varchar(15)
      , @srcUDFCaption13 varchar(15)
      , @srcUDFCaption14 varchar(15)
      , @srcUDFCaption15 varchar(15)
      , @srcUDFCaption16 varchar(15)
      , @srcUDFCaption17 varchar(15)
      , @srcUDFCaption18 varchar(15)
      , @srcUDFCaption19 varchar(15)
      , @srcUDFCaption20 varchar(15)
      , @srcUDFCaption21 varchar(15)
      , @srcUDFCaption22 varchar(15)
      , @srcHideLType0 bit
      , @srcHideLType1 bit
      , @srcHideLType2 bit
      , @srcHideLType3 bit
      , @srcHideLType4 bit
      , @srcHideLType5 bit
      , @srcHideLType6 bit
      , @srcReportPrnN varchar(50)
      , @srcFormsPrnN varchar(50)
      , @srcEnableECServices bit
      , @srcECSalesThreshold float
      , @srcMainCurrency00ScreenSymbol varchar(3)
      , @srcMainCurrency00Desc varchar(11)
      , @srcMainCurrency00CompanyRate float
      , @srcMainCurrency00DailyRate float
      , @srcMainCurrency00PrintSymbol varchar(3)
      , @srcMainCurrency01ScreenSymbol varchar(3)
      , @srcMainCurrency01Desc varchar(11)
      , @srcMainCurrency01CompanyRate float
      , @srcMainCurrency01DailyRate float
      , @srcMainCurrency01PrintSymbol varchar(3)
      , @srcMainCurrency02ScreenSymbol varchar(3)
      , @srcMainCurrency02Desc varchar(11)
      , @srcMainCurrency02CompanyRate float
      , @srcMainCurrency02DailyRate float
      , @srcMainCurrency02PrintSymbol varchar(3)
      , @srcMainCurrency03ScreenSymbol varchar(3)
      , @srcMainCurrency03Desc varchar(11)
      , @srcMainCurrency03CompanyRate float
      , @srcMainCurrency03DailyRate float
      , @srcMainCurrency03PrintSymbol varchar(3)
      , @srcMainCurrency04ScreenSymbol varchar(3)
      , @srcMainCurrency04Desc varchar(11)
      , @srcMainCurrency04CompanyRate float
      , @srcMainCurrency04DailyRate float
      , @srcMainCurrency04PrintSymbol varchar(3)
      , @srcMainCurrency05ScreenSymbol varchar(3)
      , @srcMainCurrency05Desc varchar(11)
      , @srcMainCurrency05CompanyRate float
      , @srcMainCurrency05DailyRate float
      , @srcMainCurrency05PrintSymbol varchar(3)
      , @srcMainCurrency06ScreenSymbol varchar(3)
      , @srcMainCurrency06Desc varchar(11)
      , @srcMainCurrency06CompanyRate float
      , @srcMainCurrency06DailyRate float
      , @srcMainCurrency06PrintSymbol varchar(3)
      , @srcMainCurrency07ScreenSymbol varchar(3)
      , @srcMainCurrency07Desc varchar(11)
      , @srcMainCurrency07CompanyRate float
      , @srcMainCurrency07DailyRate float
      , @srcMainCurrency07PrintSymbol varchar(3)
      , @srcMainCurrency08ScreenSymbol varchar(3)
      , @srcMainCurrency08Desc varchar(11)
      , @srcMainCurrency08CompanyRate float
      , @srcMainCurrency08DailyRate float
      , @srcMainCurrency08PrintSymbol varchar(3)
      , @srcMainCurrency09ScreenSymbol varchar(3)
      , @srcMainCurrency09Desc varchar(11)
      , @srcMainCurrency09CompanyRate float
      , @srcMainCurrency09DailyRate float
      , @srcMainCurrency09PrintSymbol varchar(3)
      , @srcMainCurrency10ScreenSymbol varchar(3)
      , @srcMainCurrency10Desc varchar(11)
      , @srcMainCurrency10CompanyRate float
      , @srcMainCurrency10DailyRate float
      , @srcMainCurrency10PrintSymbol varchar(3)
      , @srcMainCurrency11ScreenSymbol varchar(3)
      , @srcMainCurrency11Desc varchar(11)
      , @srcMainCurrency11CompanyRate float
      , @srcMainCurrency11DailyRate float
      , @srcMainCurrency11PrintSymbol varchar(3)
      , @srcMainCurrency12ScreenSymbol varchar(3)
      , @srcMainCurrency12Desc varchar(11)
      , @srcMainCurrency12CompanyRate float
      , @srcMainCurrency12DailyRate float
      , @srcMainCurrency12PrintSymbol varchar(3)
      , @srcMainCurrency13ScreenSymbol varchar(3)
      , @srcMainCurrency13Desc varchar(11)
      , @srcMainCurrency13CompanyRate float
      , @srcMainCurrency13DailyRate float
      , @srcMainCurrency13PrintSymbol varchar(3)
      , @srcMainCurrency14ScreenSymbol varchar(3)
      , @srcMainCurrency14Desc varchar(11)
      , @srcMainCurrency14CompanyRate float
      , @srcMainCurrency14DailyRate float
      , @srcMainCurrency14PrintSymbol varchar(3)
      , @srcMainCurrency15ScreenSymbol varchar(3)
      , @srcMainCurrency15Desc varchar(11)
      , @srcMainCurrency15CompanyRate float
      , @srcMainCurrency15DailyRate float
      , @srcMainCurrency15PrintSymbol varchar(3)
      , @srcMainCurrency16ScreenSymbol varchar(3)
      , @srcMainCurrency16Desc varchar(11)
      , @srcMainCurrency16CompanyRate float
      , @srcMainCurrency16DailyRate float
      , @srcMainCurrency16PrintSymbol varchar(3)
      , @srcMainCurrency17ScreenSymbol varchar(3)
      , @srcMainCurrency17Desc varchar(11)
      , @srcMainCurrency17CompanyRate float
      , @srcMainCurrency17DailyRate float
      , @srcMainCurrency17PrintSymbol varchar(3)
      , @srcMainCurrency18ScreenSymbol varchar(3)
      , @srcMainCurrency18Desc varchar(11)
      , @srcMainCurrency18CompanyRate float
      , @srcMainCurrency18DailyRate float
      , @srcMainCurrency18PrintSymbol varchar(3)
      , @srcMainCurrency19ScreenSymbol varchar(3)
      , @srcMainCurrency19Desc varchar(11)
      , @srcMainCurrency19CompanyRate float
      , @srcMainCurrency19DailyRate float
      , @srcMainCurrency19PrintSymbol varchar(3)
      , @srcMainCurrency20ScreenSymbol varchar(3)
      , @srcMainCurrency20Desc varchar(11)
      , @srcMainCurrency20CompanyRate float
      , @srcMainCurrency20DailyRate float
      , @srcMainCurrency20PrintSymbol varchar(3)
      , @srcMainCurrency21ScreenSymbol varchar(3)
      , @srcMainCurrency21Desc varchar(11)
      , @srcMainCurrency21CompanyRate float
      , @srcMainCurrency21DailyRate float
      , @srcMainCurrency21PrintSymbol varchar(3)
      , @srcMainCurrency22ScreenSymbol varchar(3)
      , @srcMainCurrency22Desc varchar(11)
      , @srcMainCurrency22CompanyRate float
      , @srcMainCurrency22DailyRate float
      , @srcMainCurrency22PrintSymbol varchar(3)
      , @srcMainCurrency23ScreenSymbol varchar(3)
      , @srcMainCurrency23Desc varchar(11)
      , @srcMainCurrency23CompanyRate float
      , @srcMainCurrency23DailyRate float
      , @srcMainCurrency23PrintSymbol varchar(3)
      , @srcMainCurrency24ScreenSymbol varchar(3)
      , @srcMainCurrency24Desc varchar(11)
      , @srcMainCurrency24CompanyRate float
      , @srcMainCurrency24DailyRate float
      , @srcMainCurrency24PrintSymbol varchar(3)
      , @srcMainCurrency25ScreenSymbol varchar(3)
      , @srcMainCurrency25Desc varchar(11)
      , @srcMainCurrency25CompanyRate float
      , @srcMainCurrency25DailyRate float
      , @srcMainCurrency25PrintSymbol varchar(3)
      , @srcMainCurrency26ScreenSymbol varchar(3)
      , @srcMainCurrency26Desc varchar(11)
      , @srcMainCurrency26CompanyRate float
      , @srcMainCurrency26DailyRate float
      , @srcMainCurrency26PrintSymbol varchar(3)
      , @srcMainCurrency27ScreenSymbol varchar(3)
      , @srcMainCurrency27Desc varchar(11)
      , @srcMainCurrency27CompanyRate float
      , @srcMainCurrency27DailyRate float
      , @srcMainCurrency27PrintSymbol varchar(3)
      , @srcMainCurrency28ScreenSymbol varchar(3)
      , @srcMainCurrency28Desc varchar(11)
      , @srcMainCurrency28CompanyRate float
      , @srcMainCurrency28DailyRate float
      , @srcMainCurrency28PrintSymbol varchar(3)
      , @srcMainCurrency29ScreenSymbol varchar(3)
      , @srcMainCurrency29Desc varchar(11)
      , @srcMainCurrency29CompanyRate float
      , @srcMainCurrency29DailyRate float
      , @srcMainCurrency29PrintSymbol varchar(3)
      , @srcMainCurrency30ScreenSymbol varchar(3)
      , @srcMainCurrency30Desc varchar(11)
      , @srcMainCurrency30CompanyRate float
      , @srcMainCurrency30DailyRate float
      , @srcMainCurrency30PrintSymbol varchar(3)
      , @srcExtCurrency00ScreenSymbol varchar(3)
      , @srcExtCurrency00Desc varchar(11)
      , @srcExtCurrency00CompanyRate float
      , @srcExtCurrency00DailyRate float
      , @srcExtCurrency00PrintSymbol varchar(3)
      , @srcExtCurrency01ScreenSymbol varchar(3)
      , @srcExtCurrency01Desc varchar(11)
      , @srcExtCurrency01CompanyRate float
      , @srcExtCurrency01DailyRate float
      , @srcExtCurrency01PrintSymbol varchar(3)
      , @srcExtCurrency02ScreenSymbol varchar(3)
      , @srcExtCurrency02Desc varchar(11)
      , @srcExtCurrency02CompanyRate float
      , @srcExtCurrency02DailyRate float
      , @srcExtCurrency02PrintSymbol varchar(3)
      , @srcExtCurrency03ScreenSymbol varchar(3)
      , @srcExtCurrency03Desc varchar(11)
      , @srcExtCurrency03CompanyRate float
      , @srcExtCurrency03DailyRate float
      , @srcExtCurrency03PrintSymbol varchar(3)
      , @srcExtCurrency04ScreenSymbol varchar(3)
      , @srcExtCurrency04Desc varchar(11)
      , @srcExtCurrency04CompanyRate float
      , @srcExtCurrency04DailyRate float
      , @srcExtCurrency04PrintSymbol varchar(3)
      , @srcExtCurrency05ScreenSymbol varchar(3)
      , @srcExtCurrency05Desc varchar(11)
      , @srcExtCurrency05CompanyRate float
      , @srcExtCurrency05DailyRate float
      , @srcExtCurrency05PrintSymbol varchar(3)
      , @srcExtCurrency06ScreenSymbol varchar(3)
      , @srcExtCurrency06Desc varchar(11)
      , @srcExtCurrency06CompanyRate float
      , @srcExtCurrency06DailyRate float
      , @srcExtCurrency06PrintSymbol varchar(3)
      , @srcExtCurrency07ScreenSymbol varchar(3)
      , @srcExtCurrency07Desc varchar(11)
      , @srcExtCurrency07CompanyRate float
      , @srcExtCurrency07DailyRate float
      , @srcExtCurrency07PrintSymbol varchar(3)
      , @srcExtCurrency08ScreenSymbol varchar(3)
      , @srcExtCurrency08Desc varchar(11)
      , @srcExtCurrency08CompanyRate float
      , @srcExtCurrency08DailyRate float
      , @srcExtCurrency08PrintSymbol varchar(3)
      , @srcExtCurrency09ScreenSymbol varchar(3)
      , @srcExtCurrency09Desc varchar(11)
      , @srcExtCurrency09CompanyRate float
      , @srcExtCurrency09DailyRate float
      , @srcExtCurrency09PrintSymbol varchar(3)
      , @srcExtCurrency10ScreenSymbol varchar(3)
      , @srcExtCurrency10Desc varchar(11)
      , @srcExtCurrency10CompanyRate float
      , @srcExtCurrency10DailyRate float
      , @srcExtCurrency10PrintSymbol varchar(3)
      , @srcExtCurrency11ScreenSymbol varchar(3)
      , @srcExtCurrency11Desc varchar(11)
      , @srcExtCurrency11CompanyRate float
      , @srcExtCurrency11DailyRate float
      , @srcExtCurrency11PrintSymbol varchar(3)
      , @srcExtCurrency12ScreenSymbol varchar(3)
      , @srcExtCurrency12Desc varchar(11)
      , @srcExtCurrency12CompanyRate float
      , @srcExtCurrency12DailyRate float
      , @srcExtCurrency12PrintSymbol varchar(3)
      , @srcExtCurrency13ScreenSymbol varchar(3)
      , @srcExtCurrency13Desc varchar(11)
      , @srcExtCurrency13CompanyRate float
      , @srcExtCurrency13DailyRate float
      , @srcExtCurrency13PrintSymbol varchar(3)
      , @srcExtCurrency14ScreenSymbol varchar(3)
      , @srcExtCurrency14Desc varchar(11)
      , @srcExtCurrency14CompanyRate float
      , @srcExtCurrency14DailyRate float
      , @srcExtCurrency14PrintSymbol varchar(3)
      , @srcExtCurrency15ScreenSymbol varchar(3)
      , @srcExtCurrency15Desc varchar(11)
      , @srcExtCurrency15CompanyRate float
      , @srcExtCurrency15DailyRate float
      , @srcExtCurrency15PrintSymbol varchar(3)
      , @srcExtCurrency16ScreenSymbol varchar(3)
      , @srcExtCurrency16Desc varchar(11)
      , @srcExtCurrency16CompanyRate float
      , @srcExtCurrency16DailyRate float
      , @srcExtCurrency16PrintSymbol varchar(3)
      , @srcExtCurrency17ScreenSymbol varchar(3)
      , @srcExtCurrency17Desc varchar(11)
      , @srcExtCurrency17CompanyRate float
      , @srcExtCurrency17DailyRate float
      , @srcExtCurrency17PrintSymbol varchar(3)
      , @srcExtCurrency18ScreenSymbol varchar(3)
      , @srcExtCurrency18Desc varchar(11)
      , @srcExtCurrency18CompanyRate float
      , @srcExtCurrency18DailyRate float
      , @srcExtCurrency18PrintSymbol varchar(3)
      , @srcExtCurrency19ScreenSymbol varchar(3)
      , @srcExtCurrency19Desc varchar(11)
      , @srcExtCurrency19CompanyRate float
      , @srcExtCurrency19DailyRate float
      , @srcExtCurrency19PrintSymbol varchar(3)
      , @srcExtCurrency20ScreenSymbol varchar(3)
      , @srcExtCurrency20Desc varchar(11)
      , @srcExtCurrency20CompanyRate float
      , @srcExtCurrency20DailyRate float
      , @srcExtCurrency20PrintSymbol varchar(3)
      , @srcExtCurrency21ScreenSymbol varchar(3)
      , @srcExtCurrency21Desc varchar(11)
      , @srcExtCurrency21CompanyRate float
      , @srcExtCurrency21DailyRate float
      , @srcExtCurrency21PrintSymbol varchar(3)
      , @srcExtCurrency22ScreenSymbol varchar(3)
      , @srcExtCurrency22Desc varchar(11)
      , @srcExtCurrency22CompanyRate float
      , @srcExtCurrency22DailyRate float
      , @srcExtCurrency22PrintSymbol varchar(3)
      , @srcExtCurrency23ScreenSymbol varchar(3)
      , @srcExtCurrency23Desc varchar(11)
      , @srcExtCurrency23CompanyRate float
      , @srcExtCurrency23DailyRate float
      , @srcExtCurrency23PrintSymbol varchar(3)
      , @srcExtCurrency24ScreenSymbol varchar(3)
      , @srcExtCurrency24Desc varchar(11)
      , @srcExtCurrency24CompanyRate float
      , @srcExtCurrency24DailyRate float
      , @srcExtCurrency24PrintSymbol varchar(3)
      , @srcExtCurrency25ScreenSymbol varchar(3)
      , @srcExtCurrency25Desc varchar(11)
      , @srcExtCurrency25CompanyRate float
      , @srcExtCurrency25DailyRate float
      , @srcExtCurrency25PrintSymbol varchar(3)
      , @srcExtCurrency26ScreenSymbol varchar(3)
      , @srcExtCurrency26Desc varchar(11)
      , @srcExtCurrency26CompanyRate float
      , @srcExtCurrency26DailyRate float
      , @srcExtCurrency26PrintSymbol varchar(3)
      , @srcExtCurrency27ScreenSymbol varchar(3)
      , @srcExtCurrency27Desc varchar(11)
      , @srcExtCurrency27CompanyRate float
      , @srcExtCurrency27DailyRate float
      , @srcExtCurrency27PrintSymbol varchar(3)
      , @srcExtCurrency28ScreenSymbol varchar(3)
      , @srcExtCurrency28Desc varchar(11)
      , @srcExtCurrency28CompanyRate float
      , @srcExtCurrency28DailyRate float
      , @srcExtCurrency28PrintSymbol varchar(3)
      , @srcExtCurrency29ScreenSymbol varchar(3)
      , @srcExtCurrency29Desc varchar(11)
      , @srcExtCurrency29CompanyRate float
      , @srcExtCurrency29DailyRate float
      , @srcExtCurrency29PrintSymbol varchar(3)
      , @srcExtCurrency30ScreenSymbol varchar(3)
      , @srcExtCurrency30Desc varchar(11)
      , @srcExtCurrency30CompanyRate float
      , @srcExtCurrency30DailyRate float
      , @srcExtCurrency30PrintSymbol varchar(3)
      , @srcNames varbinary(900)
      , @srcOverheadGL int
      , @srcOverheadSpare int
      , @srcProductionGL int
      , @srcProductionSpare int
      , @srcSubContractGL int
      , @srcSubContractSpare int
      , @srcSpareGL1a int
      , @srcSpareGL1b int
      , @srcSpareGL2a int
      , @srcSpareGL2b int
      , @srcSpareGL3a int
      , @srcSpareGL3b int
      , @srcGenPPI bit
      , @srcPPIAcCode varchar(10)
      , @srcSummDesc00 varchar(20)
      , @srcSummDesc01 varchar(20)
      , @srcSummDesc02 varchar(20)
      , @srcSummDesc03 varchar(20)
      , @srcSummDesc04 varchar(20)
      , @srcSummDesc05 varchar(20)
      , @srcSummDesc06 varchar(20)
      , @srcSummDesc07 varchar(20)
      , @srcSummDesc08 varchar(20)
      , @srcSummDesc09 varchar(20)
      , @srcSummDesc10 varchar(20)
      , @srcSummDesc11 varchar(20)
      , @srcSummDesc12 varchar(20)
      , @srcSummDesc13 varchar(20)
      , @srcSummDesc14 varchar(20)
      , @srcSummDesc15 varchar(20)
      , @srcSummDesc16 varchar(20)
      , @srcSummDesc17 varchar(20)
      , @srcSummDesc18 varchar(20)
      , @srcSummDesc19 varchar(20)
      , @srcSummDesc20 varchar(20)
      , @srcPeriodBud bit
      , @srcJCChkACode1 varchar(10)
      , @srcJCChkACode2 varchar(10)
      , @srcJCChkACode3 varchar(10)
      , @srcJCChkACode4 varchar(10)
      , @srcJCChkACode5 varchar(10)
      , @srcJWKMthNo int
      , @srcJTSHNoF varchar(9)
      , @srcJTSHNoT varchar(9)
      , @srcJFName varchar(30)
      , @srcJCCommitPin bit
      , @srcJAInvDate bit
      , @srcJADelayCert bit
      , @srcPrimaryForm001 varchar(8)
      , @srcPrimaryForm002 varchar(8)
      , @srcPrimaryForm003 varchar(8)
      , @srcPrimaryForm004 varchar(8)
      , @srcPrimaryForm005 varchar(8)
      , @srcPrimaryForm006 varchar(8)
      , @srcPrimaryForm007 varchar(8)
      , @srcPrimaryForm008 varchar(8)
      , @srcPrimaryForm009 varchar(8)
      , @srcPrimaryForm010 varchar(8)
      , @srcPrimaryForm011 varchar(8)
      , @srcPrimaryForm012 varchar(8)
      , @srcPrimaryForm013 varchar(8)
      , @srcPrimaryForm014 varchar(8)
      , @srcPrimaryForm015 varchar(8)
      , @srcPrimaryForm016 varchar(8)
      , @srcPrimaryForm017 varchar(8)
      , @srcPrimaryForm018 varchar(8)
      , @srcPrimaryForm019 varchar(8)
      , @srcPrimaryForm020 varchar(8)
      , @srcPrimaryForm021 varchar(8)
      , @srcPrimaryForm022 varchar(8)
      , @srcPrimaryForm023 varchar(8)
      , @srcPrimaryForm024 varchar(8)
      , @srcPrimaryForm025 varchar(8)
      , @srcPrimaryForm026 varchar(8)
      , @srcPrimaryForm027 varchar(8)
      , @srcPrimaryForm028 varchar(8)
      , @srcPrimaryForm029 varchar(8)
      , @srcPrimaryForm030 varchar(8)
      , @srcPrimaryForm031 varchar(8)
      , @srcPrimaryForm032 varchar(8)
      , @srcPrimaryForm033 varchar(8)
      , @srcPrimaryForm034 varchar(8)
      , @srcPrimaryForm035 varchar(8)
      , @srcPrimaryForm036 varchar(8)
      , @srcPrimaryForm037 varchar(8)
      , @srcPrimaryForm038 varchar(8)
      , @srcPrimaryForm039 varchar(8)
      , @srcPrimaryForm040 varchar(8)
      , @srcPrimaryForm041 varchar(8)
      , @srcPrimaryForm042 varchar(8)
      , @srcPrimaryForm043 varchar(8)
      , @srcPrimaryForm044 varchar(8)
      , @srcPrimaryForm045 varchar(8)
      , @srcPrimaryForm046 varchar(8)
      , @srcPrimaryForm047 varchar(8)
      , @srcPrimaryForm048 varchar(8)
      , @srcPrimaryForm049 varchar(8)
      , @srcPrimaryForm050 varchar(8)
      , @srcPrimaryForm051 varchar(8)
      , @srcPrimaryForm052 varchar(8)
      , @srcPrimaryForm053 varchar(8)
      , @srcPrimaryForm054 varchar(8)
      , @srcPrimaryForm055 varchar(8)
      , @srcPrimaryForm056 varchar(8)
      , @srcPrimaryForm057 varchar(8)
      , @srcPrimaryForm058 varchar(8)
      , @srcPrimaryForm059 varchar(8)
      , @srcPrimaryForm060 varchar(8)
      , @srcPrimaryForm061 varchar(8)
      , @srcPrimaryForm062 varchar(8)
      , @srcPrimaryForm063 varchar(8)
      , @srcPrimaryForm064 varchar(8)
      , @srcPrimaryForm065 varchar(8)
      , @srcPrimaryForm066 varchar(8)
      , @srcPrimaryForm067 varchar(8)
      , @srcPrimaryForm068 varchar(8)
      , @srcPrimaryForm069 varchar(8)
      , @srcPrimaryForm070 varchar(8)
      , @srcPrimaryForm071 varchar(8)
      , @srcPrimaryForm072 varchar(8)
      , @srcPrimaryForm073 varchar(8)
      , @srcPrimaryForm074 varchar(8)
      , @srcPrimaryForm075 varchar(8)
      , @srcPrimaryForm076 varchar(8)
      , @srcPrimaryForm077 varchar(8)
      , @srcPrimaryForm078 varchar(8)
      , @srcPrimaryForm079 varchar(8)
      , @srcPrimaryForm080 varchar(8)
      , @srcPrimaryForm081 varchar(8)
      , @srcPrimaryForm082 varchar(8)
      , @srcPrimaryForm083 varchar(8)
      , @srcPrimaryForm084 varchar(8)
      , @srcPrimaryForm085 varchar(8)
      , @srcPrimaryForm086 varchar(8)
      , @srcPrimaryForm087 varchar(8)
      , @srcPrimaryForm088 varchar(8)
      , @srcPrimaryForm089 varchar(8)
      , @srcPrimaryForm090 varchar(8)
      , @srcPrimaryForm091 varchar(8)
      , @srcPrimaryForm092 varchar(8)
      , @srcPrimaryForm093 varchar(8)
      , @srcPrimaryForm094 varchar(8)
      , @srcPrimaryForm095 varchar(8)
      , @srcPrimaryForm096 varchar(8)
      , @srcPrimaryForm097 varchar(8)
      , @srcPrimaryForm098 varchar(8)
      , @srcPrimaryForm099 varchar(8)
      , @srcPrimaryForm100 varchar(8)
      , @srcPrimaryForm101 varchar(8)
      , @srcPrimaryForm102 varchar(8)
      , @srcPrimaryForm103 varchar(8)
      , @srcPrimaryForm104 varchar(8)
      , @srcPrimaryForm105 varchar(8)
      , @srcPrimaryForm106 varchar(8)
      , @srcPrimaryForm107 varchar(8)
      , @srcPrimaryForm108 varchar(8)
      , @srcPrimaryForm109 varchar(8)
      , @srcPrimaryForm110 varchar(8)
      , @srcPrimaryForm111 varchar(8)
      , @srcPrimaryForm112 varchar(8)
      , @srcPrimaryForm113 varchar(8)
      , @srcPrimaryForm114 varchar(8)
      , @srcPrimaryForm115 varchar(8)
      , @srcPrimaryForm116 varchar(8)
      , @srcPrimaryForm117 varchar(8)
      , @srcPrimaryForm118 varchar(8)
      , @srcPrimaryForm119 varchar(8)
      , @srcPrimaryForm120 varchar(8)
      , @srcDescr varchar(30)
      , @srcModuleSec varbinary(1410)
      , @srcGCR_triRates varbinary(248)
      , @srcGCR_triEuro varbinary(31)
      , @srcGCR_triInvert varbinary(31)
      , @srcGCR_triFloat varbinary(31)
      , @srcVEDIMethod int
      , @srcVVanMode int
      , @srcVEDIFACT int
      , @srcVVANCEId varchar(50)
      , @srcVVANUId varchar(50)
      , @srcVUseCRLF bit
      , @srcVTestMode bit
      , @srcVDirPAth varchar(150)
      , @srcVCompress bit
      , @srcVCEEmail varchar(255)
      , @srcVUEmail varchar(255)
      , @srcVEPriority int
      , @srcVESubject varchar(100)
      , @srcVSendEmail bit
      , @srcVIEECSLP varchar(2)
      , @srcEmName varchar(255)
      , @srcEmAddress varchar(255)
      , @srcEmSMTP varchar(255)
      , @srcEmPriority int
      , @srcEmUseMAPI bit
      , @srcFxUseMAPI int
      , @srcFaxPrnN varchar(50)
      , @srcEmailPrnN varchar(50)
      , @srcFxName varchar(40)
      , @srcFxPhone varchar(25)
      , @srcEmAttchMode int
      , @srcFaxDLLPath varchar(60)
      , @srcSpare varbinary(992)
      , @srcFCaptions varbinary(1600)
      , @srcFHide varbinary(100)
      , @srcCISConstructCode varchar(1)
      , @srcCISConstructDesc varchar(10)
      , @srcCISConstructRate float
      , @srcCISConstructGLCode int
      , @srcCISConstructDepartment varchar(3)
      , @srcCISConstructCostCentre varchar(3)
      , @srcCISConstructSpare varbinary(10)
      , @srcCISTechnicalCode varchar(1)
      , @srcCISTechnicalDesc varchar(10)
      , @srcCISTechnicalRate float
      , @srcCISTechnicalGLCode int
      , @srcCISTechnicalDepartment varchar(3)
      , @srcCISTechnicalCostCentre varchar(3)
      , @srcCISTechnicalSpare varbinary(10)
      , @srcCISRate1Code varchar(1)
      , @srcCISRate1Desc varchar(10)
      , @srcCISRate1Rate float
      , @srcCISRate1GLCode int
      , @srcCISRate1Department varchar(3)
      , @srcCISRate1CostCentre varchar(3)
      , @srcCISRate1Spare varbinary(10)
      , @srcCISRate2Code varchar(1)
      , @srcCISRate2Desc varchar(10)
      , @srcCISRate2Rate float
      , @srcCISRate2GLCode int
      , @srcCISRate2Department varchar(3)
      , @srcCISRate2CostCentre varchar(3)
      , @srcCISRate2Spare varbinary(10)
      , @srcCISRate3Code varchar(1)
      , @srcCISRate3Desc varchar(10)
      , @srcCISRate3Rate float
      , @srcCISRate3GLCode int
      , @srcCISRate3Department varchar(3)
      , @srcCISRate3CostCentre varchar(3)
      , @srcCISRate3Spare varbinary(10)
      , @srcCISRate4Code varchar(1)
      , @srcCISRate4Desc varchar(10)
      , @srcCISRate4Rate float
      , @srcCISRate4GLCode int
      , @srcCISRate4Department varchar(3)
      , @srcCISRate4CostCentre varchar(3)
      , @srcCISRate4Spare varbinary(10)
      , @srcCISRate5Code varchar(1)
      , @srcCISRate5Desc varchar(10)
      , @srcCISRate5Rate float
      , @srcCISRate5GLCode int
      , @srcCISRate5Department varchar(3)
      , @srcCISRate5CostCentre varchar(3)
      , @srcCISRate5Spare varbinary(10)
      , @srcCISRate6Code varchar(1)
      , @srcCISRate6Desc varchar(10)
      , @srcCISRate6Rate float
      , @srcCISRate6GLCode int
      , @srcCISRate6Department varchar(3)
      , @srcCISRate6CostCentre varchar(3)
      , @srcCISRate6Spare varbinary(10)
      , @srcCISRate7Code varchar(1)
      , @srcCISRate7Desc varchar(10)
      , @srcCISRate7Rate float
      , @srcCISRate7GLCode int
      , @srcCISRate7Department varchar(3)
      , @srcCISRate7CostCentre varchar(3)
      , @srcCISRate7Spare varbinary(10)
      , @srcCISRate8Code varchar(1)
      , @srcCISRate8Desc varchar(10)
      , @srcCISRate8Rate float
      , @srcCISRate8GLCode int
      , @srcCISRate8Department varchar(3)
      , @srcCISRate8CostCentre varchar(3)
      , @srcCISRate8Spare varbinary(10)
      , @srcCISRate9Code varchar(1)
      , @srcCISRate9Desc varchar(10)
      , @srcCISRate9Rate float
      , @srcCISRate9GLCode int
      , @srcCISRate9Department varchar(3)
      , @srcCISRate9CostCentre varchar(3)
      , @srcCISRate9Spare varbinary(10)
      , @srcCISInterval int
      , @srcCISAutoSetPr bit
      , @srcCISVATCode varchar(1)
      , @srcCISSpare3 varbinary(5)
      , @srcCISScheme varchar(1)
      , @srcCISReturnDate varchar(8)
      , @srcCISCurrPeriod varchar(8)
      , @srcCISLoaded bit
      , @srcCISTaxRef varchar(20)
      , @srcCISAggMode int
      , @srcCISSortMode int
      , @srcCISVFolio int
      , @srcCISVouchers varbinary(72)
      , @srcIVANMode int
      , @srcIVANIRId varchar(50)
      , @srcIVANUId varchar(50)
      , @srcIVANPw varchar(15)
      , @srcIIREDIRef varchar(35)
      , @srcIUseCRLF bit
      , @srcITestMode bit
      , @srcIDirPath varchar(150)
      , @srcIEDIMethod int
      , @srcISendEmail bit
      , @srcIEPriority int
      , @srcJCertNo varchar(20)
      , @srcJCertExpiry varchar(8)
      , @srcJCISType int
      , @srcCISCNINO varchar(20)
      , @srcCISCUTR varchar(20)
      , @srcCISACCONo varchar(20)
      , @srcIGWIRId varchar(50)
      , @srcIGWUId varchar(50)
      , @srcIGWTO varchar(15)
      , @srcIGWIRef varchar(35)
      , @srcIXMLDirPath varchar(150)
      , @srcIXTestMode bit
      , @srcIXConfEmp bit
      , @srcIXVerSub bit
      , @srcIXNoPay bit
      , @srcIGWTR varchar(10)
      , @srcIGSubType int

-- Target Table columns

      , @trgIDCode varbinary(4)
      , @trgOpt varchar(1)
      , @trgOMonWk1 varbinary(7)
      , @trgPrinYr int
      , @trgFiltSNoBinLoc bit
      , @trgKeepBinHist bit
      , @trgUseBKTheme bit
      , @trgUserName varchar(45)
      , @trgAuditYr int
      , @trgAuditPr int
      , @trgSpare6 int
      , @trgManROCP bit
      , @trgVATCurr int
      , @trgNoCosDec int
      , @trgCurrBase int
      , @trgMuteBeep bit
      , @trgShowStkGP bit
      , @trgAutoValStk bit
      , @trgDelPickOnly bit
      , @trgUseMLoc bit
      , @trgEditSinSer bit
      , @trgWarnYRef bit
      , @trgUseLocDel bit
      , @trgPostCCNom bit
      , @trgAlTolVal float
      , @trgAlTolMode int
      , @trgDebtLMode int
      , @trgAutoGenVar bit
      , @trgAutoGenDisc bit
      , @trgUseModuleSec bit
      , @trgProtectPost bit
      , @trgUsePick4All bit
      , @trgBigStkTree bit
      , @trgBigJobTree bit
      , @trgShowQtySTree bit
      , @trgProtectYRef bit
      , @trgPurchUIDate bit
      , @trgUseUpliftNC bit
      , @trgUseWIss4All bit
      , @trgUseSTDWOP bit
      , @trgUseSalesAnal bit
      , @trgPostCCDCombo bit
      , @trgUseClassToolB bit
      , @trgWOPStkCopMode int
      , @trgUSRCntryCode varchar(3)
      , @trgNoNetDec int
      , @trgDebTrig varbinary(3)
      , @trgBKThemeNo int
      , @trgUseGLClass bit
      , @trgSpare4 varbinary(1)
      , @trgNoInvLines int
      , @trgWksODue int
      , @trgCPr int
      , @trgCYr int
      , @trgOAuditDate varchar(6)
      , @trgTradeTerm bit
      , @trgStaSepCr bit
      , @trgStaAgeMthd int
      , @trgStaUIDate bit
      , @trgSepRunPost bit
      , @trgQUAllocFlg bit
      , @trgDeadBOM bit
      , @trgAuthMode varchar(1)
      , @trgIntraStat bit
      , @trgAnalStkDesc bit
      , @trgAutoStkVal varchar(1)
      , @trgAutoBillUp bit
      , @trgAutoCQNo bit
      , @trgIncNotDue bit
      , @trgUseBatchTot bit
      , @trgUseStock bit
      , @trgAutoNotes bit
      , @trgHideMenuOpt bit
      , @trgUseCCDep bit
      , @trgNoHoldDisc bit
      , @trgAutoPrCalc bit
      , @trgStopBadDr bit
      , @trgUsePayIn bit
      , @trgUsePasswords bit
      , @trgPrintReciept bit
      , @trgExternCust bit
      , @trgNoQtyDec int
      , @trgExternSIN bit
      , @trgPrevPrOff bit
      , @trgDefPcDisc bit
      , @trgTradCodeNum bit
      , @trgUpBalOnPost bit
      , @trgShowInvDisc bit
      , @trgSepDiscounts bit
      , @trgUseCreditChk bit
      , @trgUseCRLimitChk bit
      , @trgAutoClearPay bit
      , @trgTotalConv varchar(1)
      , @trgDispPrAsMonths bit
      , @trgNomCtrlInVAT int
      , @trgNomCtrlOutVAT int
      , @trgNomCtrlDebtors int
      , @trgNomCtrlCreditors int
      , @trgNomCtrlDiscountGiven int
      , @trgNomCtrlDiscountTaken int
      , @trgNomCtrlLDiscGiven int
      , @trgNomCtrlLDiscTaken int
      , @trgNomCtrlProfitBF int
      , @trgNomCtrlCurrVar int
      , @trgNomCtrlUnRCurrVar int
      , @trgNomCtrlPLStart int
      , @trgNomCtrlPLEnd int
      , @trgNomCtrlFreightNC int
      , @trgNomCtrlSalesComm int
      , @trgNomCtrlPurchComm int
      , @trgNomCtrlRetSurcharge int
      , @trgNomCtrlSpare8 int
      , @trgNomCtrlSpare9 int
      , @trgNomCtrlSpare10 int
      , @trgNomCtrlSpare11 int
      , @trgNomCtrlSpare12 int
      , @trgNomCtrlSpare13 int
      , @trgNomCtrlSpare14 int
      , @trgDetailAddr1 varchar(30)
      , @trgDetailAddr2 varchar(30)
      , @trgDetailAddr3 varchar(30)
      , @trgDetailAddr4 varchar(30)
      , @trgDetailAddr5 varchar(30)
      , @trgDirectCust varchar(10)
      , @trgDirectSupp varchar(10)
      , @trgTermsofTrade1 varchar(80)
      , @trgTermsofTrade2 varchar(80)
      , @trgNomPayFrom int
      , @trgNomPayToo int
      , @trgSettleDisc float
      , @trgSettleDays int
      , @trgNeedBMUp bit
      , @trgIgnoreBDPW bit
      , @trgInpPack bit
      , @trgSpare32 bit
      , @trgVATCode varchar(1)
      , @trgPayTerms int
      , @trgOTrigDate varchar(6)
      , @trgStaAgeInt int
      , @trgQuoOwnDate bit
      , @trgFreeExAll bit
      , @trgDirOwnCount bit
      , @trgStaShowOS bit
      , @trgLiveCredS bit
      , @trgBatchPPY bit
      , @trgWarnJC bit
      , @trgTxLateCR bit
      , @trgConsvMem bit
      , @trgDefBankNom int
      , @trgUseDefBank bit
      , @trgHideExLogo bit
      , @trgAMMThread bit
      , @trgAMMPreview1 bit
      , @trgAMMPreview2 bit
      , @trgEntULogCount int
      , @trgDefSRCBankNom int
      , @trgSDNOwnDate bit
      , @trgEXISN varbinary(8)
      , @trgExDemoVer bit
      , @trgDupliVSec bit
      , @trgLastDaily int
      , @trgUserSort varchar(15)
      , @trgUserAcc varchar(20)
      , @trgUserRef varchar(28)
      , @trgSpareBits varbinary(31)
      , @trgGracePeriod int
      , @trgMonWk1 varchar(8)
      , @trgAuditDate varchar(8)
      , @trgTrigDate varchar(8)
      , @trgExUsrSec varbinary(28)
      , @trgUsrLogCount int
      , @trgBinMask varchar(10)
      , @trgSpare5a varchar(4)
      , @trgSpare6a varchar(18)
      , @trgUserBank varchar(25)
      , @trgExSec varbinary(28)
      , @trgLastExpFolio int
      , @trgDetailTel varchar(15)
      , @trgDetailFax varchar(15)
      , @trgUserVATReg varchar(30)
      , @trgEnableTTDDiscounts bit
      , @trgEnableVBDDiscounts bit
      , @trgEnableOverrideLocations bit
      , @trgIncludeVATInCommittedBalance bit
      , @trgVATStandardCode varchar(1)
      , @trgVATStandardDesc varchar(10)
      , @trgVATStandardRate float
      , @trgVATStandardSpare varbinary(1)
      , @trgVATStandardInclude bit
      , @trgVATStandardSpare2 varbinary(2)
      , @trgVATExemptCode varchar(1)
      , @trgVATExemptDesc varchar(10)
      , @trgVATExemptRate float
      , @trgVATExemptSpare varbinary(1)
      , @trgVATExemptInclude bit
      , @trgVATExemptSpare2 varbinary(2)
      , @trgVATZeroCode varchar(1)
      , @trgVATZeroDesc varchar(10)
      , @trgVATZeroRate float
      , @trgVATZeroSpare varbinary(1)
      , @trgVATZeroInclude bit
      , @trgVATZeroSpare2 varbinary(2)
      , @trgVATRate1Code varchar(1)
      , @trgVATRate1Desc varchar(10)
      , @trgVATRate1Rate float
      , @trgVATRate1Spare varbinary(1)
      , @trgVATRate1Include bit
      , @trgVATRate1Spare2 varbinary(2)
      , @trgVATRate2Code varchar(1)
      , @trgVATRate2Desc varchar(10)
      , @trgVATRate2Rate float
      , @trgVATRate2Spare varbinary(1)
      , @trgVATRate2Include bit
      , @trgVATRate2Spare2 varbinary(2)
      , @trgVATRate3Code varchar(1)
      , @trgVATRate3Desc varchar(10)
      , @trgVATRate3Rate float
      , @trgVATRate3Spare varbinary(1)
      , @trgVATRate3Include bit
      , @trgVATRate3Spare2 varbinary(2)
      , @trgVATRate4Code varchar(1)
      , @trgVATRate4Desc varchar(10)
      , @trgVATRate4Rate float
      , @trgVATRate4Spare varbinary(1)
      , @trgVATRate4Include bit
      , @trgVATRate4Spare2 varbinary(2)
      , @trgVATRate5Code varchar(1)
      , @trgVATRate5Desc varchar(10)
      , @trgVATRate5Rate float
      , @trgVATRate5Spare varbinary(1)
      , @trgVATRate5Include bit
      , @trgVATRate5Spare2 varbinary(2)
      , @trgVATRate6Code varchar(1)
      , @trgVATRate6Desc varchar(10)
      , @trgVATRate6Rate float
      , @trgVATRate6Spare varbinary(1)
      , @trgVATRate6Include bit
      , @trgVATRate6Spare2 varbinary(2)
      , @trgVATRate7Code varchar(1)
      , @trgVATRate7Desc varchar(10)
      , @trgVATRate7Rate float
      , @trgVATRate7Spare varbinary(1)
      , @trgVATRate7Include bit
      , @trgVATRate7Spare2 varbinary(2)
      , @trgVATRate8Code varchar(1)
      , @trgVATRate8Desc varchar(10)
      , @trgVATRate8Rate float
      , @trgVATRate8Spare varbinary(1)
      , @trgVATRate8Include bit
      , @trgVATRate8Spare2 varbinary(2)
      , @trgVATRate9Code varchar(1)
      , @trgVATRate9Desc varchar(10)
      , @trgVATRate9Rate float
      , @trgVATRate9Spare varbinary(1)
      , @trgVATRate9Include bit
      , @trgVATRate9Spare2 varbinary(2)
      , @trgVATRate10Code varchar(1)
      , @trgVATRate10Desc varchar(10)
      , @trgVATRate10Rate float
      , @trgVATRate10Spare varbinary(1)
      , @trgVATRate10Include bit
      , @trgVATRate10Spare2 varbinary(2)
      , @trgVATRate11Code varchar(1)
      , @trgVATRate11Desc varchar(10)
      , @trgVATRate11Rate float
      , @trgVATRate11Spare varbinary(1)
      , @trgVATRate11Include bit
      , @trgVATRate11Spare2 varbinary(2)
      , @trgVATRate12Code varchar(1)
      , @trgVATRate12Desc varchar(10)
      , @trgVATRate12Rate float
      , @trgVATRate12Spare varbinary(1)
      , @trgVATRate12Include bit
      , @trgVATRate12Spare2 varbinary(2)
      , @trgVATRate13Code varchar(1)
      , @trgVATRate13Desc varchar(10)
      , @trgVATRate13Rate float
      , @trgVATRate13Spare varbinary(1)
      , @trgVATRate13Include bit
      , @trgVATRate13Spare2 varbinary(2)
      , @trgVATRate14Code varchar(1)
      , @trgVATRate14Desc varchar(10)
      , @trgVATRate14Rate float
      , @trgVATRate14Spare varbinary(1)
      , @trgVATRate14Include bit
      , @trgVATRate14Spare2 varbinary(2)
      , @trgVATRate15Code varchar(1)
      , @trgVATRate15Desc varchar(10)
      , @trgVATRate15Rate float
      , @trgVATRate15Spare varbinary(1)
      , @trgVATRate15Include bit
      , @trgVATRate15Spare2 varbinary(2)
      , @trgVATRate16Code varchar(1)
      , @trgVATRate16Desc varchar(10)
      , @trgVATRate16Rate float
      , @trgVATRate16Spare varbinary(1)
      , @trgVATRate16Include bit
      , @trgVATRate16Spare2 varbinary(2)
      , @trgVATRate17Code varchar(1)
      , @trgVATRate17Desc varchar(10)
      , @trgVATRate17Rate float
      , @trgVATRate17Spare varbinary(1)
      , @trgVATRate17Include bit
      , @trgVATRate17Spare2 varbinary(2)
      , @trgVATRate18Code varchar(1)
      , @trgVATRate18Desc varchar(10)
      , @trgVATRate18Rate float
      , @trgVATRate18Spare varbinary(1)
      , @trgVATRate18Include bit
      , @trgVATRate18Spare2 varbinary(2)
      , @trgVATIAdjCode varchar(1)
      , @trgVATIAdjDesc varchar(10)
      , @trgVATIAdjRate float
      , @trgVATIAdjSpare varbinary(1)
      , @trgVATIAdjInclude bit
      , @trgVATIAdjSpare2 varbinary(2)
      , @trgVATOAdjCode varchar(1)
      , @trgVATOAdjDesc varchar(10)
      , @trgVATOAdjRate float
      , @trgVATOAdjSpare varbinary(1)
      , @trgVATOAdjInclude bit
      , @trgVATOAdjSpare2 varbinary(2)
      , @trgVATSpare8Code varchar(1)
      , @trgVATSpare8Desc varchar(10)
      , @trgVATSpare8Rate float
      , @trgVATSpare8Spare varbinary(1)
      , @trgVATSpare8Include bit
      , @trgVATSpare8Spare2 varbinary(2)
      , @trgHideUDF7 bit
      , @trgHideUDF8 bit
      , @trgHideUDF9 bit
      , @trgHideUDF10 bit
      , @trgHideUDF11 bit
      , @trgSpare2 varbinary(2)
      , @trgVATInterval int
      , @trgSpare3 varbinary(7)
      , @trgVATScheme varchar(1)
      , @trgOLastECSalesDate varchar(6)
      , @trgVATReturnDate varchar(8)
      , @trgLastECSalesDate varchar(8)
      , @trgCurrPeriod varchar(8)
      , @trgUDFCaption1 varchar(15)
      , @trgUDFCaption2 varchar(15)
      , @trgUDFCaption3 varchar(15)
      , @trgUDFCaption4 varchar(15)
      , @trgUDFCaption5 varchar(15)
      , @trgUDFCaption6 varchar(15)
      , @trgUDFCaption7 varchar(15)
      , @trgUDFCaption8 varchar(15)
      , @trgUDFCaption9 varchar(15)
      , @trgUDFCaption10 varchar(15)
      , @trgUDFCaption11 varchar(15)
      , @trgUDFCaption12 varchar(15)
      , @trgUDFCaption13 varchar(15)
      , @trgUDFCaption14 varchar(15)
      , @trgUDFCaption15 varchar(15)
      , @trgUDFCaption16 varchar(15)
      , @trgUDFCaption17 varchar(15)
      , @trgUDFCaption18 varchar(15)
      , @trgUDFCaption19 varchar(15)
      , @trgUDFCaption20 varchar(15)
      , @trgUDFCaption21 varchar(15)
      , @trgUDFCaption22 varchar(15)
      , @trgHideLType0 bit
      , @trgHideLType1 bit
      , @trgHideLType2 bit
      , @trgHideLType3 bit
      , @trgHideLType4 bit
      , @trgHideLType5 bit
      , @trgHideLType6 bit
      , @trgReportPrnN varchar(50)
      , @trgFormsPrnN varchar(50)
      , @trgEnableECServices bit
      , @trgECSalesThreshold float
      , @trgMainCurrency00ScreenSymbol varchar(3)
      , @trgMainCurrency00Desc varchar(11)
      , @trgMainCurrency00CompanyRate float
      , @trgMainCurrency00DailyRate float
      , @trgMainCurrency00PrintSymbol varchar(3)
      , @trgMainCurrency01ScreenSymbol varchar(3)
      , @trgMainCurrency01Desc varchar(11)
      , @trgMainCurrency01CompanyRate float
      , @trgMainCurrency01DailyRate float
      , @trgMainCurrency01PrintSymbol varchar(3)
      , @trgMainCurrency02ScreenSymbol varchar(3)
      , @trgMainCurrency02Desc varchar(11)
      , @trgMainCurrency02CompanyRate float
      , @trgMainCurrency02DailyRate float
      , @trgMainCurrency02PrintSymbol varchar(3)
      , @trgMainCurrency03ScreenSymbol varchar(3)
      , @trgMainCurrency03Desc varchar(11)
      , @trgMainCurrency03CompanyRate float
      , @trgMainCurrency03DailyRate float
      , @trgMainCurrency03PrintSymbol varchar(3)
      , @trgMainCurrency04ScreenSymbol varchar(3)
      , @trgMainCurrency04Desc varchar(11)
      , @trgMainCurrency04CompanyRate float
      , @trgMainCurrency04DailyRate float
      , @trgMainCurrency04PrintSymbol varchar(3)
      , @trgMainCurrency05ScreenSymbol varchar(3)
      , @trgMainCurrency05Desc varchar(11)
      , @trgMainCurrency05CompanyRate float
      , @trgMainCurrency05DailyRate float
      , @trgMainCurrency05PrintSymbol varchar(3)
      , @trgMainCurrency06ScreenSymbol varchar(3)
      , @trgMainCurrency06Desc varchar(11)
      , @trgMainCurrency06CompanyRate float
      , @trgMainCurrency06DailyRate float
      , @trgMainCurrency06PrintSymbol varchar(3)
      , @trgMainCurrency07ScreenSymbol varchar(3)
      , @trgMainCurrency07Desc varchar(11)
      , @trgMainCurrency07CompanyRate float
      , @trgMainCurrency07DailyRate float
      , @trgMainCurrency07PrintSymbol varchar(3)
      , @trgMainCurrency08ScreenSymbol varchar(3)
      , @trgMainCurrency08Desc varchar(11)
      , @trgMainCurrency08CompanyRate float
      , @trgMainCurrency08DailyRate float
      , @trgMainCurrency08PrintSymbol varchar(3)
      , @trgMainCurrency09ScreenSymbol varchar(3)
      , @trgMainCurrency09Desc varchar(11)
      , @trgMainCurrency09CompanyRate float
      , @trgMainCurrency09DailyRate float
      , @trgMainCurrency09PrintSymbol varchar(3)
      , @trgMainCurrency10ScreenSymbol varchar(3)
      , @trgMainCurrency10Desc varchar(11)
      , @trgMainCurrency10CompanyRate float
      , @trgMainCurrency10DailyRate float
      , @trgMainCurrency10PrintSymbol varchar(3)
      , @trgMainCurrency11ScreenSymbol varchar(3)
      , @trgMainCurrency11Desc varchar(11)
      , @trgMainCurrency11CompanyRate float
      , @trgMainCurrency11DailyRate float
      , @trgMainCurrency11PrintSymbol varchar(3)
      , @trgMainCurrency12ScreenSymbol varchar(3)
      , @trgMainCurrency12Desc varchar(11)
      , @trgMainCurrency12CompanyRate float
      , @trgMainCurrency12DailyRate float
      , @trgMainCurrency12PrintSymbol varchar(3)
      , @trgMainCurrency13ScreenSymbol varchar(3)
      , @trgMainCurrency13Desc varchar(11)
      , @trgMainCurrency13CompanyRate float
      , @trgMainCurrency13DailyRate float
      , @trgMainCurrency13PrintSymbol varchar(3)
      , @trgMainCurrency14ScreenSymbol varchar(3)
      , @trgMainCurrency14Desc varchar(11)
      , @trgMainCurrency14CompanyRate float
      , @trgMainCurrency14DailyRate float
      , @trgMainCurrency14PrintSymbol varchar(3)
      , @trgMainCurrency15ScreenSymbol varchar(3)
      , @trgMainCurrency15Desc varchar(11)
      , @trgMainCurrency15CompanyRate float
      , @trgMainCurrency15DailyRate float
      , @trgMainCurrency15PrintSymbol varchar(3)
      , @trgMainCurrency16ScreenSymbol varchar(3)
      , @trgMainCurrency16Desc varchar(11)
      , @trgMainCurrency16CompanyRate float
      , @trgMainCurrency16DailyRate float
      , @trgMainCurrency16PrintSymbol varchar(3)
      , @trgMainCurrency17ScreenSymbol varchar(3)
      , @trgMainCurrency17Desc varchar(11)
      , @trgMainCurrency17CompanyRate float
      , @trgMainCurrency17DailyRate float
      , @trgMainCurrency17PrintSymbol varchar(3)
      , @trgMainCurrency18ScreenSymbol varchar(3)
      , @trgMainCurrency18Desc varchar(11)
      , @trgMainCurrency18CompanyRate float
      , @trgMainCurrency18DailyRate float
      , @trgMainCurrency18PrintSymbol varchar(3)
      , @trgMainCurrency19ScreenSymbol varchar(3)
      , @trgMainCurrency19Desc varchar(11)
      , @trgMainCurrency19CompanyRate float
      , @trgMainCurrency19DailyRate float
      , @trgMainCurrency19PrintSymbol varchar(3)
      , @trgMainCurrency20ScreenSymbol varchar(3)
      , @trgMainCurrency20Desc varchar(11)
      , @trgMainCurrency20CompanyRate float
      , @trgMainCurrency20DailyRate float
      , @trgMainCurrency20PrintSymbol varchar(3)
      , @trgMainCurrency21ScreenSymbol varchar(3)
      , @trgMainCurrency21Desc varchar(11)
      , @trgMainCurrency21CompanyRate float
      , @trgMainCurrency21DailyRate float
      , @trgMainCurrency21PrintSymbol varchar(3)
      , @trgMainCurrency22ScreenSymbol varchar(3)
      , @trgMainCurrency22Desc varchar(11)
      , @trgMainCurrency22CompanyRate float
      , @trgMainCurrency22DailyRate float
      , @trgMainCurrency22PrintSymbol varchar(3)
      , @trgMainCurrency23ScreenSymbol varchar(3)
      , @trgMainCurrency23Desc varchar(11)
      , @trgMainCurrency23CompanyRate float
      , @trgMainCurrency23DailyRate float
      , @trgMainCurrency23PrintSymbol varchar(3)
      , @trgMainCurrency24ScreenSymbol varchar(3)
      , @trgMainCurrency24Desc varchar(11)
      , @trgMainCurrency24CompanyRate float
      , @trgMainCurrency24DailyRate float
      , @trgMainCurrency24PrintSymbol varchar(3)
      , @trgMainCurrency25ScreenSymbol varchar(3)
      , @trgMainCurrency25Desc varchar(11)
      , @trgMainCurrency25CompanyRate float
      , @trgMainCurrency25DailyRate float
      , @trgMainCurrency25PrintSymbol varchar(3)
      , @trgMainCurrency26ScreenSymbol varchar(3)
      , @trgMainCurrency26Desc varchar(11)
      , @trgMainCurrency26CompanyRate float
      , @trgMainCurrency26DailyRate float
      , @trgMainCurrency26PrintSymbol varchar(3)
      , @trgMainCurrency27ScreenSymbol varchar(3)
      , @trgMainCurrency27Desc varchar(11)
      , @trgMainCurrency27CompanyRate float
      , @trgMainCurrency27DailyRate float
      , @trgMainCurrency27PrintSymbol varchar(3)
      , @trgMainCurrency28ScreenSymbol varchar(3)
      , @trgMainCurrency28Desc varchar(11)
      , @trgMainCurrency28CompanyRate float
      , @trgMainCurrency28DailyRate float
      , @trgMainCurrency28PrintSymbol varchar(3)
      , @trgMainCurrency29ScreenSymbol varchar(3)
      , @trgMainCurrency29Desc varchar(11)
      , @trgMainCurrency29CompanyRate float
      , @trgMainCurrency29DailyRate float
      , @trgMainCurrency29PrintSymbol varchar(3)
      , @trgMainCurrency30ScreenSymbol varchar(3)
      , @trgMainCurrency30Desc varchar(11)
      , @trgMainCurrency30CompanyRate float
      , @trgMainCurrency30DailyRate float
      , @trgMainCurrency30PrintSymbol varchar(3)
      , @trgExtCurrency00ScreenSymbol varchar(3)
      , @trgExtCurrency00Desc varchar(11)
      , @trgExtCurrency00CompanyRate float
      , @trgExtCurrency00DailyRate float
      , @trgExtCurrency00PrintSymbol varchar(3)
      , @trgExtCurrency01ScreenSymbol varchar(3)
      , @trgExtCurrency01Desc varchar(11)
      , @trgExtCurrency01CompanyRate float
      , @trgExtCurrency01DailyRate float
      , @trgExtCurrency01PrintSymbol varchar(3)
      , @trgExtCurrency02ScreenSymbol varchar(3)
      , @trgExtCurrency02Desc varchar(11)
      , @trgExtCurrency02CompanyRate float
      , @trgExtCurrency02DailyRate float
      , @trgExtCurrency02PrintSymbol varchar(3)
      , @trgExtCurrency03ScreenSymbol varchar(3)
      , @trgExtCurrency03Desc varchar(11)
      , @trgExtCurrency03CompanyRate float
      , @trgExtCurrency03DailyRate float
      , @trgExtCurrency03PrintSymbol varchar(3)
      , @trgExtCurrency04ScreenSymbol varchar(3)
      , @trgExtCurrency04Desc varchar(11)
      , @trgExtCurrency04CompanyRate float
      , @trgExtCurrency04DailyRate float
      , @trgExtCurrency04PrintSymbol varchar(3)
      , @trgExtCurrency05ScreenSymbol varchar(3)
      , @trgExtCurrency05Desc varchar(11)
      , @trgExtCurrency05CompanyRate float
      , @trgExtCurrency05DailyRate float
      , @trgExtCurrency05PrintSymbol varchar(3)
      , @trgExtCurrency06ScreenSymbol varchar(3)
      , @trgExtCurrency06Desc varchar(11)
      , @trgExtCurrency06CompanyRate float
      , @trgExtCurrency06DailyRate float
      , @trgExtCurrency06PrintSymbol varchar(3)
      , @trgExtCurrency07ScreenSymbol varchar(3)
      , @trgExtCurrency07Desc varchar(11)
      , @trgExtCurrency07CompanyRate float
      , @trgExtCurrency07DailyRate float
      , @trgExtCurrency07PrintSymbol varchar(3)
      , @trgExtCurrency08ScreenSymbol varchar(3)
      , @trgExtCurrency08Desc varchar(11)
      , @trgExtCurrency08CompanyRate float
      , @trgExtCurrency08DailyRate float
      , @trgExtCurrency08PrintSymbol varchar(3)
      , @trgExtCurrency09ScreenSymbol varchar(3)
      , @trgExtCurrency09Desc varchar(11)
      , @trgExtCurrency09CompanyRate float
      , @trgExtCurrency09DailyRate float
      , @trgExtCurrency09PrintSymbol varchar(3)
      , @trgExtCurrency10ScreenSymbol varchar(3)
      , @trgExtCurrency10Desc varchar(11)
      , @trgExtCurrency10CompanyRate float
      , @trgExtCurrency10DailyRate float
      , @trgExtCurrency10PrintSymbol varchar(3)
      , @trgExtCurrency11ScreenSymbol varchar(3)
      , @trgExtCurrency11Desc varchar(11)
      , @trgExtCurrency11CompanyRate float
      , @trgExtCurrency11DailyRate float
      , @trgExtCurrency11PrintSymbol varchar(3)
      , @trgExtCurrency12ScreenSymbol varchar(3)
      , @trgExtCurrency12Desc varchar(11)
      , @trgExtCurrency12CompanyRate float
      , @trgExtCurrency12DailyRate float
      , @trgExtCurrency12PrintSymbol varchar(3)
      , @trgExtCurrency13ScreenSymbol varchar(3)
      , @trgExtCurrency13Desc varchar(11)
      , @trgExtCurrency13CompanyRate float
      , @trgExtCurrency13DailyRate float
      , @trgExtCurrency13PrintSymbol varchar(3)
      , @trgExtCurrency14ScreenSymbol varchar(3)
      , @trgExtCurrency14Desc varchar(11)
      , @trgExtCurrency14CompanyRate float
      , @trgExtCurrency14DailyRate float
      , @trgExtCurrency14PrintSymbol varchar(3)
      , @trgExtCurrency15ScreenSymbol varchar(3)
      , @trgExtCurrency15Desc varchar(11)
      , @trgExtCurrency15CompanyRate float
      , @trgExtCurrency15DailyRate float
      , @trgExtCurrency15PrintSymbol varchar(3)
      , @trgExtCurrency16ScreenSymbol varchar(3)
      , @trgExtCurrency16Desc varchar(11)
      , @trgExtCurrency16CompanyRate float
      , @trgExtCurrency16DailyRate float
      , @trgExtCurrency16PrintSymbol varchar(3)
      , @trgExtCurrency17ScreenSymbol varchar(3)
      , @trgExtCurrency17Desc varchar(11)
      , @trgExtCurrency17CompanyRate float
      , @trgExtCurrency17DailyRate float
      , @trgExtCurrency17PrintSymbol varchar(3)
      , @trgExtCurrency18ScreenSymbol varchar(3)
      , @trgExtCurrency18Desc varchar(11)
      , @trgExtCurrency18CompanyRate float
      , @trgExtCurrency18DailyRate float
      , @trgExtCurrency18PrintSymbol varchar(3)
      , @trgExtCurrency19ScreenSymbol varchar(3)
      , @trgExtCurrency19Desc varchar(11)
      , @trgExtCurrency19CompanyRate float
      , @trgExtCurrency19DailyRate float
      , @trgExtCurrency19PrintSymbol varchar(3)
      , @trgExtCurrency20ScreenSymbol varchar(3)
      , @trgExtCurrency20Desc varchar(11)
      , @trgExtCurrency20CompanyRate float
      , @trgExtCurrency20DailyRate float
      , @trgExtCurrency20PrintSymbol varchar(3)
      , @trgExtCurrency21ScreenSymbol varchar(3)
      , @trgExtCurrency21Desc varchar(11)
      , @trgExtCurrency21CompanyRate float
      , @trgExtCurrency21DailyRate float
      , @trgExtCurrency21PrintSymbol varchar(3)
      , @trgExtCurrency22ScreenSymbol varchar(3)
      , @trgExtCurrency22Desc varchar(11)
      , @trgExtCurrency22CompanyRate float
      , @trgExtCurrency22DailyRate float
      , @trgExtCurrency22PrintSymbol varchar(3)
      , @trgExtCurrency23ScreenSymbol varchar(3)
      , @trgExtCurrency23Desc varchar(11)
      , @trgExtCurrency23CompanyRate float
      , @trgExtCurrency23DailyRate float
      , @trgExtCurrency23PrintSymbol varchar(3)
      , @trgExtCurrency24ScreenSymbol varchar(3)
      , @trgExtCurrency24Desc varchar(11)
      , @trgExtCurrency24CompanyRate float
      , @trgExtCurrency24DailyRate float
      , @trgExtCurrency24PrintSymbol varchar(3)
      , @trgExtCurrency25ScreenSymbol varchar(3)
      , @trgExtCurrency25Desc varchar(11)
      , @trgExtCurrency25CompanyRate float
      , @trgExtCurrency25DailyRate float
      , @trgExtCurrency25PrintSymbol varchar(3)
      , @trgExtCurrency26ScreenSymbol varchar(3)
      , @trgExtCurrency26Desc varchar(11)
      , @trgExtCurrency26CompanyRate float
      , @trgExtCurrency26DailyRate float
      , @trgExtCurrency26PrintSymbol varchar(3)
      , @trgExtCurrency27ScreenSymbol varchar(3)
      , @trgExtCurrency27Desc varchar(11)
      , @trgExtCurrency27CompanyRate float
      , @trgExtCurrency27DailyRate float
      , @trgExtCurrency27PrintSymbol varchar(3)
      , @trgExtCurrency28ScreenSymbol varchar(3)
      , @trgExtCurrency28Desc varchar(11)
      , @trgExtCurrency28CompanyRate float
      , @trgExtCurrency28DailyRate float
      , @trgExtCurrency28PrintSymbol varchar(3)
      , @trgExtCurrency29ScreenSymbol varchar(3)
      , @trgExtCurrency29Desc varchar(11)
      , @trgExtCurrency29CompanyRate float
      , @trgExtCurrency29DailyRate float
      , @trgExtCurrency29PrintSymbol varchar(3)
      , @trgExtCurrency30ScreenSymbol varchar(3)
      , @trgExtCurrency30Desc varchar(11)
      , @trgExtCurrency30CompanyRate float
      , @trgExtCurrency30DailyRate float
      , @trgExtCurrency30PrintSymbol varchar(3)
      , @trgNames varbinary(900)
      , @trgOverheadGL int
      , @trgOverheadSpare int
      , @trgProductionGL int
      , @trgProductionSpare int
      , @trgSubContractGL int
      , @trgSubContractSpare int
      , @trgSpareGL1a int
      , @trgSpareGL1b int
      , @trgSpareGL2a int
      , @trgSpareGL2b int
      , @trgSpareGL3a int
      , @trgSpareGL3b int
      , @trgGenPPI bit
      , @trgPPIAcCode varchar(10)
      , @trgSummDesc00 varchar(20)
      , @trgSummDesc01 varchar(20)
      , @trgSummDesc02 varchar(20)
      , @trgSummDesc03 varchar(20)
      , @trgSummDesc04 varchar(20)
      , @trgSummDesc05 varchar(20)
      , @trgSummDesc06 varchar(20)
      , @trgSummDesc07 varchar(20)
      , @trgSummDesc08 varchar(20)
      , @trgSummDesc09 varchar(20)
      , @trgSummDesc10 varchar(20)
      , @trgSummDesc11 varchar(20)
      , @trgSummDesc12 varchar(20)
      , @trgSummDesc13 varchar(20)
      , @trgSummDesc14 varchar(20)
      , @trgSummDesc15 varchar(20)
      , @trgSummDesc16 varchar(20)
      , @trgSummDesc17 varchar(20)
      , @trgSummDesc18 varchar(20)
      , @trgSummDesc19 varchar(20)
      , @trgSummDesc20 varchar(20)
      , @trgPeriodBud bit
      , @trgJCChkACode1 varchar(10)
      , @trgJCChkACode2 varchar(10)
      , @trgJCChkACode3 varchar(10)
      , @trgJCChkACode4 varchar(10)
      , @trgJCChkACode5 varchar(10)
      , @trgJWKMthNo int
      , @trgJTSHNoF varchar(9)
      , @trgJTSHNoT varchar(9)
      , @trgJFName varchar(30)
      , @trgJCCommitPin bit
      , @trgJAInvDate bit
      , @trgJADelayCert bit
      , @trgPrimaryForm001 varchar(8)
      , @trgPrimaryForm002 varchar(8)
      , @trgPrimaryForm003 varchar(8)
      , @trgPrimaryForm004 varchar(8)
      , @trgPrimaryForm005 varchar(8)
      , @trgPrimaryForm006 varchar(8)
      , @trgPrimaryForm007 varchar(8)
      , @trgPrimaryForm008 varchar(8)
      , @trgPrimaryForm009 varchar(8)
      , @trgPrimaryForm010 varchar(8)
      , @trgPrimaryForm011 varchar(8)
      , @trgPrimaryForm012 varchar(8)
      , @trgPrimaryForm013 varchar(8)
      , @trgPrimaryForm014 varchar(8)
      , @trgPrimaryForm015 varchar(8)
      , @trgPrimaryForm016 varchar(8)
      , @trgPrimaryForm017 varchar(8)
      , @trgPrimaryForm018 varchar(8)
      , @trgPrimaryForm019 varchar(8)
      , @trgPrimaryForm020 varchar(8)
      , @trgPrimaryForm021 varchar(8)
      , @trgPrimaryForm022 varchar(8)
      , @trgPrimaryForm023 varchar(8)
      , @trgPrimaryForm024 varchar(8)
      , @trgPrimaryForm025 varchar(8)
      , @trgPrimaryForm026 varchar(8)
      , @trgPrimaryForm027 varchar(8)
      , @trgPrimaryForm028 varchar(8)
      , @trgPrimaryForm029 varchar(8)
      , @trgPrimaryForm030 varchar(8)
      , @trgPrimaryForm031 varchar(8)
      , @trgPrimaryForm032 varchar(8)
      , @trgPrimaryForm033 varchar(8)
      , @trgPrimaryForm034 varchar(8)
      , @trgPrimaryForm035 varchar(8)
      , @trgPrimaryForm036 varchar(8)
      , @trgPrimaryForm037 varchar(8)
      , @trgPrimaryForm038 varchar(8)
      , @trgPrimaryForm039 varchar(8)
      , @trgPrimaryForm040 varchar(8)
      , @trgPrimaryForm041 varchar(8)
      , @trgPrimaryForm042 varchar(8)
      , @trgPrimaryForm043 varchar(8)
      , @trgPrimaryForm044 varchar(8)
      , @trgPrimaryForm045 varchar(8)
      , @trgPrimaryForm046 varchar(8)
      , @trgPrimaryForm047 varchar(8)
      , @trgPrimaryForm048 varchar(8)
      , @trgPrimaryForm049 varchar(8)
      , @trgPrimaryForm050 varchar(8)
      , @trgPrimaryForm051 varchar(8)
      , @trgPrimaryForm052 varchar(8)
      , @trgPrimaryForm053 varchar(8)
      , @trgPrimaryForm054 varchar(8)
      , @trgPrimaryForm055 varchar(8)
      , @trgPrimaryForm056 varchar(8)
      , @trgPrimaryForm057 varchar(8)
      , @trgPrimaryForm058 varchar(8)
      , @trgPrimaryForm059 varchar(8)
      , @trgPrimaryForm060 varchar(8)
      , @trgPrimaryForm061 varchar(8)
      , @trgPrimaryForm062 varchar(8)
      , @trgPrimaryForm063 varchar(8)
      , @trgPrimaryForm064 varchar(8)
      , @trgPrimaryForm065 varchar(8)
      , @trgPrimaryForm066 varchar(8)
      , @trgPrimaryForm067 varchar(8)
      , @trgPrimaryForm068 varchar(8)
      , @trgPrimaryForm069 varchar(8)
      , @trgPrimaryForm070 varchar(8)
      , @trgPrimaryForm071 varchar(8)
      , @trgPrimaryForm072 varchar(8)
      , @trgPrimaryForm073 varchar(8)
      , @trgPrimaryForm074 varchar(8)
      , @trgPrimaryForm075 varchar(8)
      , @trgPrimaryForm076 varchar(8)
      , @trgPrimaryForm077 varchar(8)
      , @trgPrimaryForm078 varchar(8)
      , @trgPrimaryForm079 varchar(8)
      , @trgPrimaryForm080 varchar(8)
      , @trgPrimaryForm081 varchar(8)
      , @trgPrimaryForm082 varchar(8)
      , @trgPrimaryForm083 varchar(8)
      , @trgPrimaryForm084 varchar(8)
      , @trgPrimaryForm085 varchar(8)
      , @trgPrimaryForm086 varchar(8)
      , @trgPrimaryForm087 varchar(8)
      , @trgPrimaryForm088 varchar(8)
      , @trgPrimaryForm089 varchar(8)
      , @trgPrimaryForm090 varchar(8)
      , @trgPrimaryForm091 varchar(8)
      , @trgPrimaryForm092 varchar(8)
      , @trgPrimaryForm093 varchar(8)
      , @trgPrimaryForm094 varchar(8)
      , @trgPrimaryForm095 varchar(8)
      , @trgPrimaryForm096 varchar(8)
      , @trgPrimaryForm097 varchar(8)
      , @trgPrimaryForm098 varchar(8)
      , @trgPrimaryForm099 varchar(8)
      , @trgPrimaryForm100 varchar(8)
      , @trgPrimaryForm101 varchar(8)
      , @trgPrimaryForm102 varchar(8)
      , @trgPrimaryForm103 varchar(8)
      , @trgPrimaryForm104 varchar(8)
      , @trgPrimaryForm105 varchar(8)
      , @trgPrimaryForm106 varchar(8)
      , @trgPrimaryForm107 varchar(8)
      , @trgPrimaryForm108 varchar(8)
      , @trgPrimaryForm109 varchar(8)
      , @trgPrimaryForm110 varchar(8)
      , @trgPrimaryForm111 varchar(8)
      , @trgPrimaryForm112 varchar(8)
      , @trgPrimaryForm113 varchar(8)
      , @trgPrimaryForm114 varchar(8)
      , @trgPrimaryForm115 varchar(8)
      , @trgPrimaryForm116 varchar(8)
      , @trgPrimaryForm117 varchar(8)
      , @trgPrimaryForm118 varchar(8)
      , @trgPrimaryForm119 varchar(8)
      , @trgPrimaryForm120 varchar(8)
      , @trgDescr varchar(30)
      , @trgModuleSec varbinary(1410)
      , @trgGCR_triRates varbinary(248)
      , @trgGCR_triEuro varbinary(31)
      , @trgGCR_triInvert varbinary(31)
      , @trgGCR_triFloat varbinary(31)
      , @trgVEDIMethod int
      , @trgVVanMode int
      , @trgVEDIFACT int
      , @trgVVANCEId varchar(50)
      , @trgVVANUId varchar(50)
      , @trgVUseCRLF bit
      , @trgVTestMode bit
      , @trgVDirPAth varchar(150)
      , @trgVCompress bit
      , @trgVCEEmail varchar(255)
      , @trgVUEmail varchar(255)
      , @trgVEPriority int
      , @trgVESubject varchar(100)
      , @trgVSendEmail bit
      , @trgVIEECSLP varchar(2)
      , @trgEmName varchar(255)
      , @trgEmAddress varchar(255)
      , @trgEmSMTP varchar(255)
      , @trgEmPriority int
      , @trgEmUseMAPI bit
      , @trgFxUseMAPI int
      , @trgFaxPrnN varchar(50)
      , @trgEmailPrnN varchar(50)
      , @trgFxName varchar(40)
      , @trgFxPhone varchar(25)
      , @trgEmAttchMode int
      , @trgFaxDLLPath varchar(60)
      , @trgSpare varbinary(992)
      , @trgFCaptions varbinary(1600)
      , @trgFHide varbinary(100)
      , @trgCISConstructCode varchar(1)
      , @trgCISConstructDesc varchar(10)
      , @trgCISConstructRate float
      , @trgCISConstructGLCode int
      , @trgCISConstructDepartment varchar(3)
      , @trgCISConstructCostCentre varchar(3)
      , @trgCISConstructSpare varbinary(10)
      , @trgCISTechnicalCode varchar(1)
      , @trgCISTechnicalDesc varchar(10)
      , @trgCISTechnicalRate float
      , @trgCISTechnicalGLCode int
      , @trgCISTechnicalDepartment varchar(3)
      , @trgCISTechnicalCostCentre varchar(3)
      , @trgCISTechnicalSpare varbinary(10)
      , @trgCISRate1Code varchar(1)
      , @trgCISRate1Desc varchar(10)
      , @trgCISRate1Rate float
      , @trgCISRate1GLCode int
      , @trgCISRate1Department varchar(3)
      , @trgCISRate1CostCentre varchar(3)
      , @trgCISRate1Spare varbinary(10)
      , @trgCISRate2Code varchar(1)
      , @trgCISRate2Desc varchar(10)
      , @trgCISRate2Rate float
      , @trgCISRate2GLCode int
      , @trgCISRate2Department varchar(3)
      , @trgCISRate2CostCentre varchar(3)
      , @trgCISRate2Spare varbinary(10)
      , @trgCISRate3Code varchar(1)
      , @trgCISRate3Desc varchar(10)
      , @trgCISRate3Rate float
      , @trgCISRate3GLCode int
      , @trgCISRate3Department varchar(3)
      , @trgCISRate3CostCentre varchar(3)
      , @trgCISRate3Spare varbinary(10)
      , @trgCISRate4Code varchar(1)
      , @trgCISRate4Desc varchar(10)
      , @trgCISRate4Rate float
      , @trgCISRate4GLCode int
      , @trgCISRate4Department varchar(3)
      , @trgCISRate4CostCentre varchar(3)
      , @trgCISRate4Spare varbinary(10)
      , @trgCISRate5Code varchar(1)
      , @trgCISRate5Desc varchar(10)
      , @trgCISRate5Rate float
      , @trgCISRate5GLCode int
      , @trgCISRate5Department varchar(3)
      , @trgCISRate5CostCentre varchar(3)
      , @trgCISRate5Spare varbinary(10)
      , @trgCISRate6Code varchar(1)
      , @trgCISRate6Desc varchar(10)
      , @trgCISRate6Rate float
      , @trgCISRate6GLCode int
      , @trgCISRate6Department varchar(3)
      , @trgCISRate6CostCentre varchar(3)
      , @trgCISRate6Spare varbinary(10)
      , @trgCISRate7Code varchar(1)
      , @trgCISRate7Desc varchar(10)
      , @trgCISRate7Rate float
      , @trgCISRate7GLCode int
      , @trgCISRate7Department varchar(3)
      , @trgCISRate7CostCentre varchar(3)
      , @trgCISRate7Spare varbinary(10)
      , @trgCISRate8Code varchar(1)
      , @trgCISRate8Desc varchar(10)
      , @trgCISRate8Rate float
      , @trgCISRate8GLCode int
      , @trgCISRate8Department varchar(3)
      , @trgCISRate8CostCentre varchar(3)
      , @trgCISRate8Spare varbinary(10)
      , @trgCISRate9Code varchar(1)
      , @trgCISRate9Desc varchar(10)
      , @trgCISRate9Rate float
      , @trgCISRate9GLCode int
      , @trgCISRate9Department varchar(3)
      , @trgCISRate9CostCentre varchar(3)
      , @trgCISRate9Spare varbinary(10)
      , @trgCISInterval int
      , @trgCISAutoSetPr bit
      , @trgCISVATCode varchar(1)
      , @trgCISSpare3 varbinary(5)
      , @trgCISScheme varchar(1)
      , @trgCISReturnDate varchar(8)
      , @trgCISCurrPeriod varchar(8)
      , @trgCISLoaded bit
      , @trgCISTaxRef varchar(20)
      , @trgCISAggMode int
      , @trgCISSortMode int
      , @trgCISVFolio int
      , @trgCISVouchers varbinary(72)
      , @trgIVANMode int
      , @trgIVANIRId varchar(50)
      , @trgIVANUId varchar(50)
      , @trgIVANPw varchar(15)
      , @trgIIREDIRef varchar(35)
      , @trgIUseCRLF bit
      , @trgITestMode bit
      , @trgIDirPath varchar(150)
      , @trgIEDIMethod int
      , @trgISendEmail bit
      , @trgIEPriority int
      , @trgJCertNo varchar(20)
      , @trgJCertExpiry varchar(8)
      , @trgJCISType int
      , @trgCISCNINO varchar(20)
      , @trgCISCUTR varchar(20)
      , @trgCISACCONo varchar(20)
      , @trgIGWIRId varchar(50)
      , @trgIGWUId varchar(50)
      , @trgIGWTO varchar(15)
      , @trgIGWIRef varchar(35)
      , @trgIXMLDirPath varchar(150)
      , @trgIXTestMode bit
      , @trgIXConfEmp bit
      , @trgIXVerSub bit
      , @trgIXNoPay bit
      , @trgIGWTR varchar(10)
      , @trgIGSubType int

DECLARE srcExchqSS CURSOR FOR SELECT IDCode
                                    , Opt
                                    , OMonWk1
                                    , PrinYr
                                    , FiltSNoBinLoc
                                    , KeepBinHist
                                    , UseBKTheme
                                    , UserName
                                    , AuditYr
                                    , AuditPr
                                    , Spare6
                                    , ManROCP
                                    , VATCurr
                                    , NoCosDec
                                    , CurrBase
                                    , MuteBeep
                                    , ShowStkGP
                                    , AutoValStk
                                    , DelPickOnly
                                    , UseMLoc
                                    , EditSinSer
                                    , WarnYRef
                                    , UseLocDel
                                    , PostCCNom
                                    , AlTolVal
                                    , AlTolMode
                                    , DebtLMode
                                    , AutoGenVar
                                    , AutoGenDisc
                                    , UseModuleSec
                                    , ProtectPost
                                    , UsePick4All
                                    , BigStkTree
                                    , BigJobTree
                                    , ShowQtySTree
                                    , ProtectYRef
                                    , PurchUIDate
                                    , UseUpliftNC
                                    , UseWIss4All
                                    , UseSTDWOP
                                    , UseSalesAnal
                                    , PostCCDCombo
                                    , UseClassToolB
                                    , WOPStkCopMode
                                    , USRCntryCode
                                    , NoNetDec
                                    , DebTrig
                                    , BKThemeNo
                                    , UseGLClass
                                    , Spare4
                                    , NoInvLines
                                    , WksODue
                                    , CPr
                                    , CYr
                                    , OAuditDate
                                    , TradeTerm
                                    , StaSepCr
                                    , StaAgeMthd
                                    , StaUIDate
                                    , SepRunPost
                                    , QUAllocFlg
                                    , DeadBOM
                                    , AuthMode
                                    , IntraStat
                                    , AnalStkDesc
                                    , AutoStkVal
                                    , AutoBillUp
                                    , AutoCQNo
                                    , IncNotDue
                                    , UseBatchTot
                                    , UseStock
                                    , AutoNotes
                                    , HideMenuOpt
                                    , UseCCDep
                                    , NoHoldDisc
                                    , AutoPrCalc
                                    , StopBadDr
                                    , UsePayIn
                                    , UsePasswords
                                    , PrintReciept
                                    , ExternCust
                                    , NoQtyDec
                                    , ExternSIN
                                    , PrevPrOff
                                    , DefPcDisc
                                    , TradCodeNum
                                    , UpBalOnPost
                                    , ShowInvDisc
                                    , SepDiscounts
                                    , UseCreditChk
                                    , UseCRLimitChk
                                    , AutoClearPay
                                    , TotalConv
                                    , DispPrAsMonths
                                    , NomCtrlInVAT
                                    , NomCtrlOutVAT
                                    , NomCtrlDebtors
                                    , NomCtrlCreditors
                                    , NomCtrlDiscountGiven
                                    , NomCtrlDiscountTaken
                                    , NomCtrlLDiscGiven
                                    , NomCtrlLDiscTaken
                                    , NomCtrlProfitBF
                                    , NomCtrlCurrVar
                                    , NomCtrlUnRCurrVar
                                    , NomCtrlPLStart
                                    , NomCtrlPLEnd
                                    , NomCtrlFreightNC
                                    , NomCtrlSalesComm
                                    , NomCtrlPurchComm
                                    , NomCtrlRetSurcharge
                                    , NomCtrlSpare8
                                    , NomCtrlSpare9
                                    , NomCtrlSpare10
                                    , NomCtrlSpare11
                                    , NomCtrlSpare12
                                    , NomCtrlSpare13
                                    , NomCtrlSpare14
                                    , DetailAddr1
                                    , DetailAddr2
                                    , DetailAddr3
                                    , DetailAddr4
                                    , DetailAddr5
                                    , DirectCust
                                    , DirectSupp
                                    , TermsofTrade1
                                    , TermsofTrade2
                                    , NomPayFrom
                                    , NomPayToo
                                    , SettleDisc
                                    , SettleDays
                                    , NeedBMUp
                                    , IgnoreBDPW
                                    , InpPack
                                    , Spare32
                                    , VATCode
                                    , PayTerms
                                    , OTrigDate
                                    , StaAgeInt
                                    , QuoOwnDate
                                    , FreeExAll
                                    , DirOwnCount
                                    , StaShowOS
                                    , LiveCredS
                                    , BatchPPY
                                    , WarnJC
                                    , TxLateCR
                                    , ConsvMem
                                    , DefBankNom
                                    , UseDefBank
                                    , HideExLogo
                                    , AMMThread
                                    , AMMPreview1
                                    , AMMPreview2
                                    , EntULogCount
                                    , DefSRCBankNom
                                    , SDNOwnDate
                                    , EXISN
                                    , ExDemoVer
                                    , DupliVSec
                                    , LastDaily
                                    , UserSort
                                    , UserAcc
                                    , UserRef
                                    , SpareBits
                                    , GracePeriod
                                    , MonWk1
                                    , AuditDate
                                    , TrigDate
                                    , ExUsrSec
                                    , UsrLogCount
                                    , BinMask
                                    , Spare5a
                                    , Spare6a
                                    , UserBank
                                    , ExSec
                                    , LastExpFolio
                                    , DetailTel
                                    , DetailFax
                                    , UserVATReg
                                    , EnableTTDDiscounts
                                    , EnableVBDDiscounts
                                    , EnableOverrideLocations
                                    , IncludeVATInCommittedBalance
                                    , VATStandardCode
                                    , VATStandardDesc
                                    , VATStandardRate
                                    , VATStandardSpare
                                    , VATStandardInclude
                                    , VATStandardSpare2
                                    , VATExemptCode
                                    , VATExemptDesc
                                    , VATExemptRate
                                    , VATExemptSpare
                                    , VATExemptInclude
                                    , VATExemptSpare2
                                    , VATZeroCode
                                    , VATZeroDesc
                                    , VATZeroRate
                                    , VATZeroSpare
                                    , VATZeroInclude
                                    , VATZeroSpare2
                                    , VATRate1Code
                                    , VATRate1Desc
                                    , VATRate1Rate
                                    , VATRate1Spare
                                    , VATRate1Include
                                    , VATRate1Spare2
                                    , VATRate2Code
                                    , VATRate2Desc
                                    , VATRate2Rate
                                    , VATRate2Spare
                                    , VATRate2Include
                                    , VATRate2Spare2
                                    , VATRate3Code
                                    , VATRate3Desc
                                    , VATRate3Rate
                                    , VATRate3Spare
                                    , VATRate3Include
                                    , VATRate3Spare2
                                    , VATRate4Code
                                    , VATRate4Desc
                                    , VATRate4Rate
                                    , VATRate4Spare
                                    , VATRate4Include
                                    , VATRate4Spare2
                                    , VATRate5Code
                                    , VATRate5Desc
                                    , VATRate5Rate
                                    , VATRate5Spare
                                    , VATRate5Include
                                    , VATRate5Spare2
                                    , VATRate6Code
                                    , VATRate6Desc
                                    , VATRate6Rate
                                    , VATRate6Spare
                                    , VATRate6Include
                                    , VATRate6Spare2
                                    , VATRate7Code
                                    , VATRate7Desc
                                    , VATRate7Rate
                                    , VATRate7Spare
                                    , VATRate7Include
                                    , VATRate7Spare2
                                    , VATRate8Code
                                    , VATRate8Desc
                                    , VATRate8Rate
                                    , VATRate8Spare
                                    , VATRate8Include
                                    , VATRate8Spare2
                                    , VATRate9Code
                                    , VATRate9Desc
                                    , VATRate9Rate
                                    , VATRate9Spare
                                    , VATRate9Include
                                    , VATRate9Spare2
                                    , VATRate10Code
                                    , VATRate10Desc
                                    , VATRate10Rate
                                    , VATRate10Spare
                                    , VATRate10Include
                                    , VATRate10Spare2
                                    , VATRate11Code
                                    , VATRate11Desc
                                    , VATRate11Rate
                                    , VATRate11Spare
                                    , VATRate11Include
                                    , VATRate11Spare2
                                    , VATRate12Code
                                    , VATRate12Desc
                                    , VATRate12Rate
                                    , VATRate12Spare
                                    , VATRate12Include
                                    , VATRate12Spare2
                                    , VATRate13Code
                                    , VATRate13Desc
                                    , VATRate13Rate
                                    , VATRate13Spare
                                    , VATRate13Include
                                    , VATRate13Spare2
                                    , VATRate14Code
                                    , VATRate14Desc
                                    , VATRate14Rate
                                    , VATRate14Spare
                                    , VATRate14Include
                                    , VATRate14Spare2
                                    , VATRate15Code
                                    , VATRate15Desc
                                    , VATRate15Rate
                                    , VATRate15Spare
                                    , VATRate15Include
                                    , VATRate15Spare2
                                    , VATRate16Code
                                    , VATRate16Desc
                                    , VATRate16Rate
                                    , VATRate16Spare
                                    , VATRate16Include
                                    , VATRate16Spare2
                                    , VATRate17Code
                                    , VATRate17Desc
                                    , VATRate17Rate
                                    , VATRate17Spare
                                    , VATRate17Include
                                    , VATRate17Spare2
                                    , VATRate18Code
                                    , VATRate18Desc
                                    , VATRate18Rate
                                    , VATRate18Spare
                                    , VATRate18Include
                                    , VATRate18Spare2
                                    , VATIAdjCode
                                    , VATIAdjDesc
                                    , VATIAdjRate
                                    , VATIAdjSpare
                                    , VATIAdjInclude
                                    , VATIAdjSpare2
                                    , VATOAdjCode
                                    , VATOAdjDesc
                                    , VATOAdjRate
                                    , VATOAdjSpare
                                    , VATOAdjInclude
                                    , VATOAdjSpare2
                                    , VATSpare8Code
                                    , VATSpare8Desc
                                    , VATSpare8Rate
                                    , VATSpare8Spare
                                    , VATSpare8Include
                                    , VATSpare8Spare2
                                    , HideUDF7
                                    , HideUDF8
                                    , HideUDF9
                                    , HideUDF10
                                    , HideUDF11
                                    , Spare2
                                    , VATInterval
                                    , Spare3
                                    , VATScheme
                                    , OLastECSalesDate
                                    , VATReturnDate
                                    , LastECSalesDate
                                    , CurrPeriod
                                    , UDFCaption1
                                    , UDFCaption2
                                    , UDFCaption3
                                    , UDFCaption4
                                    , UDFCaption5
                                    , UDFCaption6
                                    , UDFCaption7
                                    , UDFCaption8
                                    , UDFCaption9
                                    , UDFCaption10
                                    , UDFCaption11
                                    , UDFCaption12
                                    , UDFCaption13
                                    , UDFCaption14
                                    , UDFCaption15
                                    , UDFCaption16
                                    , UDFCaption17
                                    , UDFCaption18
                                    , UDFCaption19
                                    , UDFCaption20
                                    , UDFCaption21
                                    , UDFCaption22
                                    , HideLType0
                                    , HideLType1
                                    , HideLType2
                                    , HideLType3
                                    , HideLType4
                                    , HideLType5
                                    , HideLType6
                                    , ReportPrnN
                                    , FormsPrnN
                                    , EnableECServices
                                    , ECSalesThreshold
                                    , MainCurrency00ScreenSymbol
                                    , MainCurrency00Desc
                                    , MainCurrency00CompanyRate
                                    , MainCurrency00DailyRate
                                    , MainCurrency00PrintSymbol
                                    , MainCurrency01ScreenSymbol
                                    , MainCurrency01Desc
                                    , MainCurrency01CompanyRate
                                    , MainCurrency01DailyRate
                                    , MainCurrency01PrintSymbol
                                    , MainCurrency02ScreenSymbol
                                    , MainCurrency02Desc
                                    , MainCurrency02CompanyRate
                                    , MainCurrency02DailyRate
                                    , MainCurrency02PrintSymbol
                                    , MainCurrency03ScreenSymbol
                                    , MainCurrency03Desc
                                    , MainCurrency03CompanyRate
                                    , MainCurrency03DailyRate
                                    , MainCurrency03PrintSymbol
                                    , MainCurrency04ScreenSymbol
                                    , MainCurrency04Desc
                                    , MainCurrency04CompanyRate
                                    , MainCurrency04DailyRate
                                    , MainCurrency04PrintSymbol
                                    , MainCurrency05ScreenSymbol
                                    , MainCurrency05Desc
                                    , MainCurrency05CompanyRate
                                    , MainCurrency05DailyRate
                                    , MainCurrency05PrintSymbol
                                    , MainCurrency06ScreenSymbol
                                    , MainCurrency06Desc
                                    , MainCurrency06CompanyRate
                                    , MainCurrency06DailyRate
                                    , MainCurrency06PrintSymbol
                                    , MainCurrency07ScreenSymbol
                                    , MainCurrency07Desc
                                    , MainCurrency07CompanyRate
                                    , MainCurrency07DailyRate
                                    , MainCurrency07PrintSymbol
                                    , MainCurrency08ScreenSymbol
                                    , MainCurrency08Desc
                                    , MainCurrency08CompanyRate
                                    , MainCurrency08DailyRate
                                    , MainCurrency08PrintSymbol
                                    , MainCurrency09ScreenSymbol
                                    , MainCurrency09Desc
                                    , MainCurrency09CompanyRate
                                    , MainCurrency09DailyRate
                                    , MainCurrency09PrintSymbol
                                    , MainCurrency10ScreenSymbol
                                    , MainCurrency10Desc
                                    , MainCurrency10CompanyRate
                                    , MainCurrency10DailyRate
                                    , MainCurrency10PrintSymbol
                                    , MainCurrency11ScreenSymbol
                                    , MainCurrency11Desc
                                    , MainCurrency11CompanyRate
                                    , MainCurrency11DailyRate
                                    , MainCurrency11PrintSymbol
                                    , MainCurrency12ScreenSymbol
                                    , MainCurrency12Desc
                                    , MainCurrency12CompanyRate
                                    , MainCurrency12DailyRate
                                    , MainCurrency12PrintSymbol
                                    , MainCurrency13ScreenSymbol
                                    , MainCurrency13Desc
                                    , MainCurrency13CompanyRate
                                    , MainCurrency13DailyRate
                                    , MainCurrency13PrintSymbol
                                    , MainCurrency14ScreenSymbol
                                    , MainCurrency14Desc
                                    , MainCurrency14CompanyRate
                                    , MainCurrency14DailyRate
                                    , MainCurrency14PrintSymbol
                                    , MainCurrency15ScreenSymbol
                                    , MainCurrency15Desc
                                    , MainCurrency15CompanyRate
                                    , MainCurrency15DailyRate
                                    , MainCurrency15PrintSymbol
                                    , MainCurrency16ScreenSymbol
                                    , MainCurrency16Desc
                                    , MainCurrency16CompanyRate
                                    , MainCurrency16DailyRate
                                    , MainCurrency16PrintSymbol
                                    , MainCurrency17ScreenSymbol
                                    , MainCurrency17Desc
                                    , MainCurrency17CompanyRate
                                    , MainCurrency17DailyRate
                                    , MainCurrency17PrintSymbol
                                    , MainCurrency18ScreenSymbol
                                    , MainCurrency18Desc
                                    , MainCurrency18CompanyRate
                                    , MainCurrency18DailyRate
                                    , MainCurrency18PrintSymbol
                                    , MainCurrency19ScreenSymbol
                                    , MainCurrency19Desc
                                    , MainCurrency19CompanyRate
                                    , MainCurrency19DailyRate
                                    , MainCurrency19PrintSymbol
                                    , MainCurrency20ScreenSymbol
                                    , MainCurrency20Desc
                                    , MainCurrency20CompanyRate
                                    , MainCurrency20DailyRate
                                    , MainCurrency20PrintSymbol
                                    , MainCurrency21ScreenSymbol
                                    , MainCurrency21Desc
                                    , MainCurrency21CompanyRate
                                    , MainCurrency21DailyRate
                                    , MainCurrency21PrintSymbol
                                    , MainCurrency22ScreenSymbol
                                    , MainCurrency22Desc
                                    , MainCurrency22CompanyRate
                                    , MainCurrency22DailyRate
                                    , MainCurrency22PrintSymbol
                                    , MainCurrency23ScreenSymbol
                                    , MainCurrency23Desc
                                    , MainCurrency23CompanyRate
                                    , MainCurrency23DailyRate
                                    , MainCurrency23PrintSymbol
                                    , MainCurrency24ScreenSymbol
                                    , MainCurrency24Desc
                                    , MainCurrency24CompanyRate
                                    , MainCurrency24DailyRate
                                    , MainCurrency24PrintSymbol
                                    , MainCurrency25ScreenSymbol
                                    , MainCurrency25Desc
                                    , MainCurrency25CompanyRate
                                    , MainCurrency25DailyRate
                                    , MainCurrency25PrintSymbol
                                    , MainCurrency26ScreenSymbol
                                    , MainCurrency26Desc
                                    , MainCurrency26CompanyRate
                                    , MainCurrency26DailyRate
                                    , MainCurrency26PrintSymbol
                                    , MainCurrency27ScreenSymbol
                                    , MainCurrency27Desc
                                    , MainCurrency27CompanyRate
                                    , MainCurrency27DailyRate
                                    , MainCurrency27PrintSymbol
                                    , MainCurrency28ScreenSymbol
                                    , MainCurrency28Desc
                                    , MainCurrency28CompanyRate
                                    , MainCurrency28DailyRate
                                    , MainCurrency28PrintSymbol
                                    , MainCurrency29ScreenSymbol
                                    , MainCurrency29Desc
                                    , MainCurrency29CompanyRate
                                    , MainCurrency29DailyRate
                                    , MainCurrency29PrintSymbol
                                    , MainCurrency30ScreenSymbol
                                    , MainCurrency30Desc
                                    , MainCurrency30CompanyRate
                                    , MainCurrency30DailyRate
                                    , MainCurrency30PrintSymbol
                                    , ExtCurrency00ScreenSymbol
                                    , ExtCurrency00Desc
                                    , ExtCurrency00CompanyRate
                                    , ExtCurrency00DailyRate
                                    , ExtCurrency00PrintSymbol
                                    , ExtCurrency01ScreenSymbol
                                    , ExtCurrency01Desc
                                    , ExtCurrency01CompanyRate
                                    , ExtCurrency01DailyRate
                                    , ExtCurrency01PrintSymbol
                                    , ExtCurrency02ScreenSymbol
                                    , ExtCurrency02Desc
                                    , ExtCurrency02CompanyRate
                                    , ExtCurrency02DailyRate
                                    , ExtCurrency02PrintSymbol
                                    , ExtCurrency03ScreenSymbol
                                    , ExtCurrency03Desc
                                    , ExtCurrency03CompanyRate
                                    , ExtCurrency03DailyRate
                                    , ExtCurrency03PrintSymbol
                                    , ExtCurrency04ScreenSymbol
                                    , ExtCurrency04Desc
                                    , ExtCurrency04CompanyRate
                                    , ExtCurrency04DailyRate
                                    , ExtCurrency04PrintSymbol
                                    , ExtCurrency05ScreenSymbol
                                    , ExtCurrency05Desc
                                    , ExtCurrency05CompanyRate
                                    , ExtCurrency05DailyRate
                                    , ExtCurrency05PrintSymbol
                                    , ExtCurrency06ScreenSymbol
                                    , ExtCurrency06Desc
                                    , ExtCurrency06CompanyRate
                                    , ExtCurrency06DailyRate
                                    , ExtCurrency06PrintSymbol
                                    , ExtCurrency07ScreenSymbol
                                    , ExtCurrency07Desc
                                    , ExtCurrency07CompanyRate
                                    , ExtCurrency07DailyRate
                                    , ExtCurrency07PrintSymbol
                                    , ExtCurrency08ScreenSymbol
                                    , ExtCurrency08Desc
                                    , ExtCurrency08CompanyRate
                                    , ExtCurrency08DailyRate
                                    , ExtCurrency08PrintSymbol
                                    , ExtCurrency09ScreenSymbol
                                    , ExtCurrency09Desc
                                    , ExtCurrency09CompanyRate
                                    , ExtCurrency09DailyRate
                                    , ExtCurrency09PrintSymbol
                                    , ExtCurrency10ScreenSymbol
                                    , ExtCurrency10Desc
                                    , ExtCurrency10CompanyRate
                                    , ExtCurrency10DailyRate
                                    , ExtCurrency10PrintSymbol
                                    , ExtCurrency11ScreenSymbol
                                    , ExtCurrency11Desc
                                    , ExtCurrency11CompanyRate
                                    , ExtCurrency11DailyRate
                                    , ExtCurrency11PrintSymbol
                                    , ExtCurrency12ScreenSymbol
                                    , ExtCurrency12Desc
                                    , ExtCurrency12CompanyRate
                                    , ExtCurrency12DailyRate
                                    , ExtCurrency12PrintSymbol
                                    , ExtCurrency13ScreenSymbol
                                    , ExtCurrency13Desc
                                    , ExtCurrency13CompanyRate
                                    , ExtCurrency13DailyRate
                                    , ExtCurrency13PrintSymbol
                                    , ExtCurrency14ScreenSymbol
                                    , ExtCurrency14Desc
                                    , ExtCurrency14CompanyRate
                                    , ExtCurrency14DailyRate
                                    , ExtCurrency14PrintSymbol
                                    , ExtCurrency15ScreenSymbol
                                    , ExtCurrency15Desc
                                    , ExtCurrency15CompanyRate
                                    , ExtCurrency15DailyRate
                                    , ExtCurrency15PrintSymbol
                                    , ExtCurrency16ScreenSymbol
                                    , ExtCurrency16Desc
                                    , ExtCurrency16CompanyRate
                                    , ExtCurrency16DailyRate
                                    , ExtCurrency16PrintSymbol
                                    , ExtCurrency17ScreenSymbol
                                    , ExtCurrency17Desc
                                    , ExtCurrency17CompanyRate
                                    , ExtCurrency17DailyRate
                                    , ExtCurrency17PrintSymbol
                                    , ExtCurrency18ScreenSymbol
                                    , ExtCurrency18Desc
                                    , ExtCurrency18CompanyRate
                                    , ExtCurrency18DailyRate
                                    , ExtCurrency18PrintSymbol
                                    , ExtCurrency19ScreenSymbol
                                    , ExtCurrency19Desc
                                    , ExtCurrency19CompanyRate
                                    , ExtCurrency19DailyRate
                                    , ExtCurrency19PrintSymbol
                                    , ExtCurrency20ScreenSymbol
                                    , ExtCurrency20Desc
                                    , ExtCurrency20CompanyRate
                                    , ExtCurrency20DailyRate
                                    , ExtCurrency20PrintSymbol
                                    , ExtCurrency21ScreenSymbol
                                    , ExtCurrency21Desc
                                    , ExtCurrency21CompanyRate
                                    , ExtCurrency21DailyRate
                                    , ExtCurrency21PrintSymbol
                                    , ExtCurrency22ScreenSymbol
                                    , ExtCurrency22Desc
                                    , ExtCurrency22CompanyRate
                                    , ExtCurrency22DailyRate
                                    , ExtCurrency22PrintSymbol
                                    , ExtCurrency23ScreenSymbol
                                    , ExtCurrency23Desc
                                    , ExtCurrency23CompanyRate
                                    , ExtCurrency23DailyRate
                                    , ExtCurrency23PrintSymbol
                                    , ExtCurrency24ScreenSymbol
                                    , ExtCurrency24Desc
                                    , ExtCurrency24CompanyRate
                                    , ExtCurrency24DailyRate
                                    , ExtCurrency24PrintSymbol
                                    , ExtCurrency25ScreenSymbol
                                    , ExtCurrency25Desc
                                    , ExtCurrency25CompanyRate
                                    , ExtCurrency25DailyRate
                                    , ExtCurrency25PrintSymbol
                                    , ExtCurrency26ScreenSymbol
                                    , ExtCurrency26Desc
                                    , ExtCurrency26CompanyRate
                                    , ExtCurrency26DailyRate
                                    , ExtCurrency26PrintSymbol
                                    , ExtCurrency27ScreenSymbol
                                    , ExtCurrency27Desc
                                    , ExtCurrency27CompanyRate
                                    , ExtCurrency27DailyRate
                                    , ExtCurrency27PrintSymbol
                                    , ExtCurrency28ScreenSymbol
                                    , ExtCurrency28Desc
                                    , ExtCurrency28CompanyRate
                                    , ExtCurrency28DailyRate
                                    , ExtCurrency28PrintSymbol
                                    , ExtCurrency29ScreenSymbol
                                    , ExtCurrency29Desc
                                    , ExtCurrency29CompanyRate
                                    , ExtCurrency29DailyRate
                                    , ExtCurrency29PrintSymbol
                                    , ExtCurrency30ScreenSymbol
                                    , ExtCurrency30Desc
                                    , ExtCurrency30CompanyRate
                                    , ExtCurrency30DailyRate
                                    , ExtCurrency30PrintSymbol
                                    , Names
                                    , OverheadGL
                                    , OverheadSpare
                                    , ProductionGL
                                    , ProductionSpare
                                    , SubContractGL
                                    , SubContractSpare
                                    , SpareGL1a
                                    , SpareGL1b
                                    , SpareGL2a
                                    , SpareGL2b
                                    , SpareGL3a
                                    , SpareGL3b
                                    , GenPPI
                                    , PPIAcCode
                                    , SummDesc00
                                    , SummDesc01
                                    , SummDesc02
                                    , SummDesc03
                                    , SummDesc04
                                    , SummDesc05
                                    , SummDesc06
                                    , SummDesc07
                                    , SummDesc08
                                    , SummDesc09
                                    , SummDesc10
                                    , SummDesc11
                                    , SummDesc12
                                    , SummDesc13
                                    , SummDesc14
                                    , SummDesc15
                                    , SummDesc16
                                    , SummDesc17
                                    , SummDesc18
                                    , SummDesc19
                                    , SummDesc20
                                    , PeriodBud
                                    , JCChkACode1
                                    , JCChkACode2
                                    , JCChkACode3
                                    , JCChkACode4
                                    , JCChkACode5
                                    , JWKMthNo
                                    , JTSHNoF
                                    , JTSHNoT
                                    , JFName
                                    , JCCommitPin
                                    , JAInvDate
                                    , JADelayCert
                                    , PrimaryForm001
                                    , PrimaryForm002
                                    , PrimaryForm003
                                    , PrimaryForm004
                                    , PrimaryForm005
                                    , PrimaryForm006
                                    , PrimaryForm007
                                    , PrimaryForm008
                                    , PrimaryForm009
                                    , PrimaryForm010
                                    , PrimaryForm011
                                    , PrimaryForm012
                                    , PrimaryForm013
                                    , PrimaryForm014
                                    , PrimaryForm015
                                    , PrimaryForm016
                                    , PrimaryForm017
                                    , PrimaryForm018
                                    , PrimaryForm019
                                    , PrimaryForm020
                                    , PrimaryForm021
                                    , PrimaryForm022
                                    , PrimaryForm023
                                    , PrimaryForm024
                                    , PrimaryForm025
                                    , PrimaryForm026
                                    , PrimaryForm027
                                    , PrimaryForm028
                                    , PrimaryForm029
                                    , PrimaryForm030
                                    , PrimaryForm031
                                    , PrimaryForm032
                                    , PrimaryForm033
                                    , PrimaryForm034
                                    , PrimaryForm035
                                    , PrimaryForm036
                                    , PrimaryForm037
                                    , PrimaryForm038
                                    , PrimaryForm039
                                    , PrimaryForm040
                                    , PrimaryForm041
                                    , PrimaryForm042
                                    , PrimaryForm043
                                    , PrimaryForm044
                                    , PrimaryForm045
                                    , PrimaryForm046
                                    , PrimaryForm047
                                    , PrimaryForm048
                                    , PrimaryForm049
                                    , PrimaryForm050
                                    , PrimaryForm051
                                    , PrimaryForm052
                                    , PrimaryForm053
                                    , PrimaryForm054
                                    , PrimaryForm055
                                    , PrimaryForm056
                                    , PrimaryForm057
                                    , PrimaryForm058
                                    , PrimaryForm059
                                    , PrimaryForm060
                                    , PrimaryForm061
                                    , PrimaryForm062
                                    , PrimaryForm063
                                    , PrimaryForm064
                                    , PrimaryForm065
                                    , PrimaryForm066
                                    , PrimaryForm067
                                    , PrimaryForm068
                                    , PrimaryForm069
                                    , PrimaryForm070
                                    , PrimaryForm071
                                    , PrimaryForm072
                                    , PrimaryForm073
                                    , PrimaryForm074
                                    , PrimaryForm075
                                    , PrimaryForm076
                                    , PrimaryForm077
                                    , PrimaryForm078
                                    , PrimaryForm079
                                    , PrimaryForm080
                                    , PrimaryForm081
                                    , PrimaryForm082
                                    , PrimaryForm083
                                    , PrimaryForm084
                                    , PrimaryForm085
                                    , PrimaryForm086
                                    , PrimaryForm087
                                    , PrimaryForm088
                                    , PrimaryForm089
                                    , PrimaryForm090
                                    , PrimaryForm091
                                    , PrimaryForm092
                                    , PrimaryForm093
                                    , PrimaryForm094
                                    , PrimaryForm095
                                    , PrimaryForm096
                                    , PrimaryForm097
                                    , PrimaryForm098
                                    , PrimaryForm099
                                    , PrimaryForm100
                                    , PrimaryForm101
                                    , PrimaryForm102
                                    , PrimaryForm103
                                    , PrimaryForm104
                                    , PrimaryForm105
                                    , PrimaryForm106
                                    , PrimaryForm107
                                    , PrimaryForm108
                                    , PrimaryForm109
                                    , PrimaryForm110
                                    , PrimaryForm111
                                    , PrimaryForm112
                                    , PrimaryForm113
                                    , PrimaryForm114
                                    , PrimaryForm115
                                    , PrimaryForm116
                                    , PrimaryForm117
                                    , PrimaryForm118
                                    , PrimaryForm119
                                    , PrimaryForm120
                                    , Descr
                                    , ModuleSec
                                    , GCR_triRates
                                    , GCR_triEuro
                                    , GCR_triInvert
                                    , GCR_triFloat
                                    , VEDIMethod
                                    , VVanMode
                                    , VEDIFACT
                                    , VVANCEId
                                    , VVANUId
                                    , VUseCRLF
                                    , VTestMode
                                    , VDirPAth
                                    , VCompress
                                    , VCEEmail
                                    , VUEmail
                                    , VEPriority
                                    , VESubject
                                    , VSendEmail
                                    , VIEECSLP
                                    , EmName
                                    , EmAddress
                                    , EmSMTP
                                    , EmPriority
                                    , EmUseMAPI
                                    , FxUseMAPI
                                    , FaxPrnN
                                    , EmailPrnN
                                    , FxName
                                    , FxPhone
                                    , EmAttchMode
                                    , FaxDLLPath
                                    , Spare
                                    , FCaptions
                                    , FHide
                                    , CISConstructCode
                                    , CISConstructDesc
                                    , CISConstructRate
                                    , CISConstructGLCode
                                    , CISConstructDepartment
                                    , CISConstructCostCentre
                                    , CISConstructSpare
                                    , CISTechnicalCode
                                    , CISTechnicalDesc
                                    , CISTechnicalRate
                                    , CISTechnicalGLCode
                                    , CISTechnicalDepartment
                                    , CISTechnicalCostCentre
                                    , CISTechnicalSpare
                                    , CISRate1Code
                                    , CISRate1Desc
                                    , CISRate1Rate
                                    , CISRate1GLCode
                                    , CISRate1Department
                                    , CISRate1CostCentre
                                    , CISRate1Spare
                                    , CISRate2Code
                                    , CISRate2Desc
                                    , CISRate2Rate
                                    , CISRate2GLCode
                                    , CISRate2Department
                                    , CISRate2CostCentre
                                    , CISRate2Spare
                                    , CISRate3Code
                                    , CISRate3Desc
                                    , CISRate3Rate
                                    , CISRate3GLCode
                                    , CISRate3Department
                                    , CISRate3CostCentre
                                    , CISRate3Spare
                                    , CISRate4Code
                                    , CISRate4Desc
                                    , CISRate4Rate
                                    , CISRate4GLCode
                                    , CISRate4Department
                                    , CISRate4CostCentre
                                    , CISRate4Spare
                                    , CISRate5Code
                                    , CISRate5Desc
                                    , CISRate5Rate
                                    , CISRate5GLCode
                                    , CISRate5Department
                                    , CISRate5CostCentre
                                    , CISRate5Spare
                                    , CISRate6Code
                                    , CISRate6Desc
                                    , CISRate6Rate
                                    , CISRate6GLCode
                                    , CISRate6Department
                                    , CISRate6CostCentre
                                    , CISRate6Spare
                                    , CISRate7Code
                                    , CISRate7Desc
                                    , CISRate7Rate
                                    , CISRate7GLCode
                                    , CISRate7Department
                                    , CISRate7CostCentre
                                    , CISRate7Spare
                                    , CISRate8Code
                                    , CISRate8Desc
                                    , CISRate8Rate
                                    , CISRate8GLCode
                                    , CISRate8Department
                                    , CISRate8CostCentre
                                    , CISRate8Spare
                                    , CISRate9Code
                                    , CISRate9Desc
                                    , CISRate9Rate
                                    , CISRate9GLCode
                                    , CISRate9Department
                                    , CISRate9CostCentre
                                    , CISRate9Spare
                                    , CISInterval
                                    , CISAutoSetPr
                                    , CISVATCode
                                    , CISSpare3
                                    , CISScheme
                                    , CISReturnDate
                                    , CISCurrPeriod
                                    , CISLoaded
                                    , CISTaxRef
                                    , CISAggMode
                                    , CISSortMode
                                    , CISVFolio
                                    , CISVouchers
                                    , IVANMode
                                    , IVANIRId
                                    , IVANUId
                                    , IVANPw
                                    , IIREDIRef
                                    , IUseCRLF
                                    , ITestMode
                                    , IDirPath
                                    , IEDIMethod
                                    , ISendEmail
                                    , IEPriority
                                    , JCertNo
                                    , JCertExpiry
                                    , JCISType
                                    , CISCNINO
                                    , CISCUTR
                                    , CISACCONo
                                    , IGWIRId
                                    , IGWUId
                                    , IGWTO
                                    , IGWIRef
                                    , IXMLDirPath
                                    , IXTestMode
                                    , IXConfEmp
                                    , IXVerSub
                                    , IXNoPay
                                    , IGWTR
                                    , IGSubType
                               FROM   ConvMasterPR70.MAIN01.ExchqSS

OPEN srcExchqSS

FETCH NEXT FROM srcExchqSS INTO @srcIDCode
                               , @srcOpt
                               , @srcOMonWk1
                               , @srcPrinYr
                               , @srcFiltSNoBinLoc
                               , @srcKeepBinHist
                               , @srcUseBKTheme
                               , @srcUserName
                               , @srcAuditYr
                               , @srcAuditPr
                               , @srcSpare6
                               , @srcManROCP
                               , @srcVATCurr
                               , @srcNoCosDec
                               , @srcCurrBase
                               , @srcMuteBeep
                               , @srcShowStkGP
                               , @srcAutoValStk
                               , @srcDelPickOnly
                               , @srcUseMLoc
                               , @srcEditSinSer
                               , @srcWarnYRef
                               , @srcUseLocDel
                               , @srcPostCCNom
                               , @srcAlTolVal
                               , @srcAlTolMode
                               , @srcDebtLMode
                               , @srcAutoGenVar
                               , @srcAutoGenDisc
                               , @srcUseModuleSec
                               , @srcProtectPost
                               , @srcUsePick4All
                               , @srcBigStkTree
                               , @srcBigJobTree
                               , @srcShowQtySTree
                               , @srcProtectYRef
                               , @srcPurchUIDate
                               , @srcUseUpliftNC
                               , @srcUseWIss4All
                               , @srcUseSTDWOP
                               , @srcUseSalesAnal
                               , @srcPostCCDCombo
                               , @srcUseClassToolB
                               , @srcWOPStkCopMode
                               , @srcUSRCntryCode
                               , @srcNoNetDec
                               , @srcDebTrig
                               , @srcBKThemeNo
                               , @srcUseGLClass
                               , @srcSpare4
                               , @srcNoInvLines
                               , @srcWksODue
                               , @srcCPr
                               , @srcCYr
                               , @srcOAuditDate
                               , @srcTradeTerm
                               , @srcStaSepCr
                               , @srcStaAgeMthd
                               , @srcStaUIDate
                               , @srcSepRunPost
                               , @srcQUAllocFlg
                               , @srcDeadBOM
                               , @srcAuthMode
                               , @srcIntraStat
                               , @srcAnalStkDesc
                               , @srcAutoStkVal
                               , @srcAutoBillUp
                               , @srcAutoCQNo
                               , @srcIncNotDue
                               , @srcUseBatchTot
                               , @srcUseStock
                               , @srcAutoNotes
                               , @srcHideMenuOpt
                               , @srcUseCCDep
                               , @srcNoHoldDisc
                               , @srcAutoPrCalc
                               , @srcStopBadDr
                               , @srcUsePayIn
                               , @srcUsePasswords
                               , @srcPrintReciept
                               , @srcExternCust
                               , @srcNoQtyDec
                               , @srcExternSIN
                               , @srcPrevPrOff
                               , @srcDefPcDisc
                               , @srcTradCodeNum
                               , @srcUpBalOnPost
                               , @srcShowInvDisc
                               , @srcSepDiscounts
                               , @srcUseCreditChk
                               , @srcUseCRLimitChk
                               , @srcAutoClearPay
                               , @srcTotalConv
                               , @srcDispPrAsMonths
                               , @srcNomCtrlInVAT
                               , @srcNomCtrlOutVAT
                               , @srcNomCtrlDebtors
                               , @srcNomCtrlCreditors
                               , @srcNomCtrlDiscountGiven
                               , @srcNomCtrlDiscountTaken
                               , @srcNomCtrlLDiscGiven
                               , @srcNomCtrlLDiscTaken
                               , @srcNomCtrlProfitBF
                               , @srcNomCtrlCurrVar
                               , @srcNomCtrlUnRCurrVar
                               , @srcNomCtrlPLStart
                               , @srcNomCtrlPLEnd
                               , @srcNomCtrlFreightNC
                               , @srcNomCtrlSalesComm
                               , @srcNomCtrlPurchComm
                               , @srcNomCtrlRetSurcharge
                               , @srcNomCtrlSpare8
                               , @srcNomCtrlSpare9
                               , @srcNomCtrlSpare10
                               , @srcNomCtrlSpare11
                               , @srcNomCtrlSpare12
                               , @srcNomCtrlSpare13
                               , @srcNomCtrlSpare14
                               , @srcDetailAddr1
                               , @srcDetailAddr2
                               , @srcDetailAddr3
                               , @srcDetailAddr4
                               , @srcDetailAddr5
                               , @srcDirectCust
                               , @srcDirectSupp
                               , @srcTermsofTrade1
                               , @srcTermsofTrade2
                               , @srcNomPayFrom
                               , @srcNomPayToo
                               , @srcSettleDisc
                               , @srcSettleDays
                               , @srcNeedBMUp
                               , @srcIgnoreBDPW
                               , @srcInpPack
                               , @srcSpare32
                               , @srcVATCode
                               , @srcPayTerms
                               , @srcOTrigDate
                               , @srcStaAgeInt
                               , @srcQuoOwnDate
                               , @srcFreeExAll
                               , @srcDirOwnCount
                               , @srcStaShowOS
                               , @srcLiveCredS
                               , @srcBatchPPY
                               , @srcWarnJC
                               , @srcTxLateCR
                               , @srcConsvMem
                               , @srcDefBankNom
                               , @srcUseDefBank
                               , @srcHideExLogo
                               , @srcAMMThread
                               , @srcAMMPreview1
                               , @srcAMMPreview2
                               , @srcEntULogCount
                               , @srcDefSRCBankNom
                               , @srcSDNOwnDate
                               , @srcEXISN
                               , @srcExDemoVer
                               , @srcDupliVSec
                               , @srcLastDaily
                               , @srcUserSort
                               , @srcUserAcc
                               , @srcUserRef
                               , @srcSpareBits
                               , @srcGracePeriod
                               , @srcMonWk1
                               , @srcAuditDate
                               , @srcTrigDate
                               , @srcExUsrSec
                               , @srcUsrLogCount
                               , @srcBinMask
                               , @srcSpare5a
                               , @srcSpare6a
                               , @srcUserBank
                               , @srcExSec
                               , @srcLastExpFolio
                               , @srcDetailTel
                               , @srcDetailFax
                               , @srcUserVATReg
                               , @srcEnableTTDDiscounts
                               , @srcEnableVBDDiscounts
                               , @srcEnableOverrideLocations
                               , @srcIncludeVATInCommittedBalance
                               , @srcVATStandardCode
                               , @srcVATStandardDesc
                               , @srcVATStandardRate
                               , @srcVATStandardSpare
                               , @srcVATStandardInclude
                               , @srcVATStandardSpare2
                               , @srcVATExemptCode
                               , @srcVATExemptDesc
                               , @srcVATExemptRate
                               , @srcVATExemptSpare
                               , @srcVATExemptInclude
                               , @srcVATExemptSpare2
                               , @srcVATZeroCode
                               , @srcVATZeroDesc
                               , @srcVATZeroRate
                               , @srcVATZeroSpare
                               , @srcVATZeroInclude
                               , @srcVATZeroSpare2
                               , @srcVATRate1Code
                               , @srcVATRate1Desc
                               , @srcVATRate1Rate
                               , @srcVATRate1Spare
                               , @srcVATRate1Include
                               , @srcVATRate1Spare2
                               , @srcVATRate2Code
                               , @srcVATRate2Desc
                               , @srcVATRate2Rate
                               , @srcVATRate2Spare
                               , @srcVATRate2Include
                               , @srcVATRate2Spare2
                               , @srcVATRate3Code
                               , @srcVATRate3Desc
                               , @srcVATRate3Rate
                               , @srcVATRate3Spare
                               , @srcVATRate3Include
                               , @srcVATRate3Spare2
                               , @srcVATRate4Code
                               , @srcVATRate4Desc
                               , @srcVATRate4Rate
                               , @srcVATRate4Spare
                               , @srcVATRate4Include
                               , @srcVATRate4Spare2
                               , @srcVATRate5Code
                               , @srcVATRate5Desc
                               , @srcVATRate5Rate
                               , @srcVATRate5Spare
                               , @srcVATRate5Include
                               , @srcVATRate5Spare2
                               , @srcVATRate6Code
                               , @srcVATRate6Desc
                               , @srcVATRate6Rate
                               , @srcVATRate6Spare
                               , @srcVATRate6Include
                               , @srcVATRate6Spare2
                               , @srcVATRate7Code
                               , @srcVATRate7Desc
                               , @srcVATRate7Rate
                               , @srcVATRate7Spare
                               , @srcVATRate7Include
                               , @srcVATRate7Spare2
                               , @srcVATRate8Code
                               , @srcVATRate8Desc
                               , @srcVATRate8Rate
                               , @srcVATRate8Spare
                               , @srcVATRate8Include
                               , @srcVATRate8Spare2
                               , @srcVATRate9Code
                               , @srcVATRate9Desc
                               , @srcVATRate9Rate
                               , @srcVATRate9Spare
                               , @srcVATRate9Include
                               , @srcVATRate9Spare2
                               , @srcVATRate10Code
                               , @srcVATRate10Desc
                               , @srcVATRate10Rate
                               , @srcVATRate10Spare
                               , @srcVATRate10Include
                               , @srcVATRate10Spare2
                               , @srcVATRate11Code
                               , @srcVATRate11Desc
                               , @srcVATRate11Rate
                               , @srcVATRate11Spare
                               , @srcVATRate11Include
                               , @srcVATRate11Spare2
                               , @srcVATRate12Code
                               , @srcVATRate12Desc
                               , @srcVATRate12Rate
                               , @srcVATRate12Spare
                               , @srcVATRate12Include
                               , @srcVATRate12Spare2
                               , @srcVATRate13Code
                               , @srcVATRate13Desc
                               , @srcVATRate13Rate
                               , @srcVATRate13Spare
                               , @srcVATRate13Include
                               , @srcVATRate13Spare2
                               , @srcVATRate14Code
                               , @srcVATRate14Desc
                               , @srcVATRate14Rate
                               , @srcVATRate14Spare
                               , @srcVATRate14Include
                               , @srcVATRate14Spare2
                               , @srcVATRate15Code
                               , @srcVATRate15Desc
                               , @srcVATRate15Rate
                               , @srcVATRate15Spare
                               , @srcVATRate15Include
                               , @srcVATRate15Spare2
                               , @srcVATRate16Code
                               , @srcVATRate16Desc
                               , @srcVATRate16Rate
                               , @srcVATRate16Spare
                               , @srcVATRate16Include
                               , @srcVATRate16Spare2
                               , @srcVATRate17Code
                               , @srcVATRate17Desc
                               , @srcVATRate17Rate
                               , @srcVATRate17Spare
                               , @srcVATRate17Include
                               , @srcVATRate17Spare2
                               , @srcVATRate18Code
                               , @srcVATRate18Desc
                               , @srcVATRate18Rate
                               , @srcVATRate18Spare
                               , @srcVATRate18Include
                               , @srcVATRate18Spare2
                               , @srcVATIAdjCode
                               , @srcVATIAdjDesc
                               , @srcVATIAdjRate
                               , @srcVATIAdjSpare
                               , @srcVATIAdjInclude
                               , @srcVATIAdjSpare2
                               , @srcVATOAdjCode
                               , @srcVATOAdjDesc
                               , @srcVATOAdjRate
                               , @srcVATOAdjSpare
                               , @srcVATOAdjInclude
                               , @srcVATOAdjSpare2
                               , @srcVATSpare8Code
                               , @srcVATSpare8Desc
                               , @srcVATSpare8Rate
                               , @srcVATSpare8Spare
                               , @srcVATSpare8Include
                               , @srcVATSpare8Spare2
                               , @srcHideUDF7
                               , @srcHideUDF8
                               , @srcHideUDF9
                               , @srcHideUDF10
                               , @srcHideUDF11
                               , @srcSpare2
                               , @srcVATInterval
                               , @srcSpare3
                               , @srcVATScheme
                               , @srcOLastECSalesDate
                               , @srcVATReturnDate
                               , @srcLastECSalesDate
                               , @srcCurrPeriod
                               , @srcUDFCaption1
                               , @srcUDFCaption2
                               , @srcUDFCaption3
                               , @srcUDFCaption4
                               , @srcUDFCaption5
                               , @srcUDFCaption6
                               , @srcUDFCaption7
                               , @srcUDFCaption8
                               , @srcUDFCaption9
                               , @srcUDFCaption10
                               , @srcUDFCaption11
                               , @srcUDFCaption12
                               , @srcUDFCaption13
                               , @srcUDFCaption14
                               , @srcUDFCaption15
                               , @srcUDFCaption16
                               , @srcUDFCaption17
                               , @srcUDFCaption18
                               , @srcUDFCaption19
                               , @srcUDFCaption20
                               , @srcUDFCaption21
                               , @srcUDFCaption22
                               , @srcHideLType0
                               , @srcHideLType1
                               , @srcHideLType2
                               , @srcHideLType3
                               , @srcHideLType4
                               , @srcHideLType5
                               , @srcHideLType6
                               , @srcReportPrnN
                               , @srcFormsPrnN
                               , @srcEnableECServices
                               , @srcECSalesThreshold
                               , @srcMainCurrency00ScreenSymbol
                               , @srcMainCurrency00Desc
                               , @srcMainCurrency00CompanyRate
                               , @srcMainCurrency00DailyRate
                               , @srcMainCurrency00PrintSymbol
                               , @srcMainCurrency01ScreenSymbol
                               , @srcMainCurrency01Desc
                               , @srcMainCurrency01CompanyRate
                               , @srcMainCurrency01DailyRate
                               , @srcMainCurrency01PrintSymbol
                               , @srcMainCurrency02ScreenSymbol
                               , @srcMainCurrency02Desc
                               , @srcMainCurrency02CompanyRate
                               , @srcMainCurrency02DailyRate
                               , @srcMainCurrency02PrintSymbol
                               , @srcMainCurrency03ScreenSymbol
                               , @srcMainCurrency03Desc
                               , @srcMainCurrency03CompanyRate
                               , @srcMainCurrency03DailyRate
                               , @srcMainCurrency03PrintSymbol
                               , @srcMainCurrency04ScreenSymbol
                               , @srcMainCurrency04Desc
                               , @srcMainCurrency04CompanyRate
                               , @srcMainCurrency04DailyRate
                               , @srcMainCurrency04PrintSymbol
                               , @srcMainCurrency05ScreenSymbol
                               , @srcMainCurrency05Desc
                               , @srcMainCurrency05CompanyRate
                               , @srcMainCurrency05DailyRate
                               , @srcMainCurrency05PrintSymbol
                               , @srcMainCurrency06ScreenSymbol
                               , @srcMainCurrency06Desc
                               , @srcMainCurrency06CompanyRate
                               , @srcMainCurrency06DailyRate
                               , @srcMainCurrency06PrintSymbol
                               , @srcMainCurrency07ScreenSymbol
                               , @srcMainCurrency07Desc
                               , @srcMainCurrency07CompanyRate
                               , @srcMainCurrency07DailyRate
                               , @srcMainCurrency07PrintSymbol
                               , @srcMainCurrency08ScreenSymbol
                               , @srcMainCurrency08Desc
                               , @srcMainCurrency08CompanyRate
                               , @srcMainCurrency08DailyRate
                               , @srcMainCurrency08PrintSymbol
                               , @srcMainCurrency09ScreenSymbol
                               , @srcMainCurrency09Desc
                               , @srcMainCurrency09CompanyRate
                               , @srcMainCurrency09DailyRate
                               , @srcMainCurrency09PrintSymbol
                               , @srcMainCurrency10ScreenSymbol
                               , @srcMainCurrency10Desc
                               , @srcMainCurrency10CompanyRate
                               , @srcMainCurrency10DailyRate
                               , @srcMainCurrency10PrintSymbol
                               , @srcMainCurrency11ScreenSymbol
                               , @srcMainCurrency11Desc
                               , @srcMainCurrency11CompanyRate
                               , @srcMainCurrency11DailyRate
                               , @srcMainCurrency11PrintSymbol
                               , @srcMainCurrency12ScreenSymbol
                               , @srcMainCurrency12Desc
                               , @srcMainCurrency12CompanyRate
                               , @srcMainCurrency12DailyRate
                               , @srcMainCurrency12PrintSymbol
                               , @srcMainCurrency13ScreenSymbol
                               , @srcMainCurrency13Desc
                               , @srcMainCurrency13CompanyRate
                               , @srcMainCurrency13DailyRate
                               , @srcMainCurrency13PrintSymbol
                               , @srcMainCurrency14ScreenSymbol
                               , @srcMainCurrency14Desc
                               , @srcMainCurrency14CompanyRate
                               , @srcMainCurrency14DailyRate
                               , @srcMainCurrency14PrintSymbol
                               , @srcMainCurrency15ScreenSymbol
                               , @srcMainCurrency15Desc
                               , @srcMainCurrency15CompanyRate
                               , @srcMainCurrency15DailyRate
                               , @srcMainCurrency15PrintSymbol
                               , @srcMainCurrency16ScreenSymbol
                               , @srcMainCurrency16Desc
                               , @srcMainCurrency16CompanyRate
                               , @srcMainCurrency16DailyRate
                               , @srcMainCurrency16PrintSymbol
                               , @srcMainCurrency17ScreenSymbol
                               , @srcMainCurrency17Desc
                               , @srcMainCurrency17CompanyRate
                               , @srcMainCurrency17DailyRate
                               , @srcMainCurrency17PrintSymbol
                               , @srcMainCurrency18ScreenSymbol
                               , @srcMainCurrency18Desc
                               , @srcMainCurrency18CompanyRate
                               , @srcMainCurrency18DailyRate
                               , @srcMainCurrency18PrintSymbol
                               , @srcMainCurrency19ScreenSymbol
                               , @srcMainCurrency19Desc
                               , @srcMainCurrency19CompanyRate
                               , @srcMainCurrency19DailyRate
                               , @srcMainCurrency19PrintSymbol
                               , @srcMainCurrency20ScreenSymbol
                               , @srcMainCurrency20Desc
                               , @srcMainCurrency20CompanyRate
                               , @srcMainCurrency20DailyRate
                               , @srcMainCurrency20PrintSymbol
                               , @srcMainCurrency21ScreenSymbol
                               , @srcMainCurrency21Desc
                               , @srcMainCurrency21CompanyRate
                               , @srcMainCurrency21DailyRate
                               , @srcMainCurrency21PrintSymbol
                               , @srcMainCurrency22ScreenSymbol
                               , @srcMainCurrency22Desc
                               , @srcMainCurrency22CompanyRate
                               , @srcMainCurrency22DailyRate
                               , @srcMainCurrency22PrintSymbol
                               , @srcMainCurrency23ScreenSymbol
                               , @srcMainCurrency23Desc
                               , @srcMainCurrency23CompanyRate
                               , @srcMainCurrency23DailyRate
                               , @srcMainCurrency23PrintSymbol
                               , @srcMainCurrency24ScreenSymbol
                               , @srcMainCurrency24Desc
                               , @srcMainCurrency24CompanyRate
                               , @srcMainCurrency24DailyRate
                               , @srcMainCurrency24PrintSymbol
                               , @srcMainCurrency25ScreenSymbol
                               , @srcMainCurrency25Desc
                               , @srcMainCurrency25CompanyRate
                               , @srcMainCurrency25DailyRate
                               , @srcMainCurrency25PrintSymbol
                               , @srcMainCurrency26ScreenSymbol
                               , @srcMainCurrency26Desc
                               , @srcMainCurrency26CompanyRate
                               , @srcMainCurrency26DailyRate
                               , @srcMainCurrency26PrintSymbol
                               , @srcMainCurrency27ScreenSymbol
                               , @srcMainCurrency27Desc
                               , @srcMainCurrency27CompanyRate
                               , @srcMainCurrency27DailyRate
                               , @srcMainCurrency27PrintSymbol
                               , @srcMainCurrency28ScreenSymbol
                               , @srcMainCurrency28Desc
                               , @srcMainCurrency28CompanyRate
                               , @srcMainCurrency28DailyRate
                               , @srcMainCurrency28PrintSymbol
                               , @srcMainCurrency29ScreenSymbol
                               , @srcMainCurrency29Desc
                               , @srcMainCurrency29CompanyRate
                               , @srcMainCurrency29DailyRate
                               , @srcMainCurrency29PrintSymbol
                               , @srcMainCurrency30ScreenSymbol
                               , @srcMainCurrency30Desc
                               , @srcMainCurrency30CompanyRate
                               , @srcMainCurrency30DailyRate
                               , @srcMainCurrency30PrintSymbol
                               , @srcExtCurrency00ScreenSymbol
                               , @srcExtCurrency00Desc
                               , @srcExtCurrency00CompanyRate
                               , @srcExtCurrency00DailyRate
                               , @srcExtCurrency00PrintSymbol
                               , @srcExtCurrency01ScreenSymbol
                               , @srcExtCurrency01Desc
                               , @srcExtCurrency01CompanyRate
                               , @srcExtCurrency01DailyRate
                               , @srcExtCurrency01PrintSymbol
                               , @srcExtCurrency02ScreenSymbol
                               , @srcExtCurrency02Desc
                               , @srcExtCurrency02CompanyRate
                               , @srcExtCurrency02DailyRate
                               , @srcExtCurrency02PrintSymbol
                               , @srcExtCurrency03ScreenSymbol
                               , @srcExtCurrency03Desc
                               , @srcExtCurrency03CompanyRate
                               , @srcExtCurrency03DailyRate
                               , @srcExtCurrency03PrintSymbol
                               , @srcExtCurrency04ScreenSymbol
                               , @srcExtCurrency04Desc
                               , @srcExtCurrency04CompanyRate
                               , @srcExtCurrency04DailyRate
                               , @srcExtCurrency04PrintSymbol
                               , @srcExtCurrency05ScreenSymbol
                               , @srcExtCurrency05Desc
                               , @srcExtCurrency05CompanyRate
                               , @srcExtCurrency05DailyRate
                               , @srcExtCurrency05PrintSymbol
                               , @srcExtCurrency06ScreenSymbol
                               , @srcExtCurrency06Desc
                               , @srcExtCurrency06CompanyRate
                               , @srcExtCurrency06DailyRate
                               , @srcExtCurrency06PrintSymbol
                               , @srcExtCurrency07ScreenSymbol
                               , @srcExtCurrency07Desc
                               , @srcExtCurrency07CompanyRate
                               , @srcExtCurrency07DailyRate
                               , @srcExtCurrency07PrintSymbol
                               , @srcExtCurrency08ScreenSymbol
                               , @srcExtCurrency08Desc
                               , @srcExtCurrency08CompanyRate
                               , @srcExtCurrency08DailyRate
                               , @srcExtCurrency08PrintSymbol
                               , @srcExtCurrency09ScreenSymbol
                               , @srcExtCurrency09Desc
                               , @srcExtCurrency09CompanyRate
                               , @srcExtCurrency09DailyRate
                               , @srcExtCurrency09PrintSymbol
                               , @srcExtCurrency10ScreenSymbol
                               , @srcExtCurrency10Desc
                               , @srcExtCurrency10CompanyRate
                               , @srcExtCurrency10DailyRate
                               , @srcExtCurrency10PrintSymbol
                               , @srcExtCurrency11ScreenSymbol
                               , @srcExtCurrency11Desc
                               , @srcExtCurrency11CompanyRate
                               , @srcExtCurrency11DailyRate
                               , @srcExtCurrency11PrintSymbol
                               , @srcExtCurrency12ScreenSymbol
                               , @srcExtCurrency12Desc
                               , @srcExtCurrency12CompanyRate
                               , @srcExtCurrency12DailyRate
                               , @srcExtCurrency12PrintSymbol
                               , @srcExtCurrency13ScreenSymbol
                               , @srcExtCurrency13Desc
                               , @srcExtCurrency13CompanyRate
                               , @srcExtCurrency13DailyRate
                               , @srcExtCurrency13PrintSymbol
                               , @srcExtCurrency14ScreenSymbol
                               , @srcExtCurrency14Desc
                               , @srcExtCurrency14CompanyRate
                               , @srcExtCurrency14DailyRate
                               , @srcExtCurrency14PrintSymbol
                               , @srcExtCurrency15ScreenSymbol
                               , @srcExtCurrency15Desc
                               , @srcExtCurrency15CompanyRate
                               , @srcExtCurrency15DailyRate
                               , @srcExtCurrency15PrintSymbol
                               , @srcExtCurrency16ScreenSymbol
                               , @srcExtCurrency16Desc
                               , @srcExtCurrency16CompanyRate
                               , @srcExtCurrency16DailyRate
                               , @srcExtCurrency16PrintSymbol
                               , @srcExtCurrency17ScreenSymbol
                               , @srcExtCurrency17Desc
                               , @srcExtCurrency17CompanyRate
                               , @srcExtCurrency17DailyRate
                               , @srcExtCurrency17PrintSymbol
                               , @srcExtCurrency18ScreenSymbol
                               , @srcExtCurrency18Desc
                               , @srcExtCurrency18CompanyRate
                               , @srcExtCurrency18DailyRate
                               , @srcExtCurrency18PrintSymbol
                               , @srcExtCurrency19ScreenSymbol
                               , @srcExtCurrency19Desc
                               , @srcExtCurrency19CompanyRate
                               , @srcExtCurrency19DailyRate
                               , @srcExtCurrency19PrintSymbol
                               , @srcExtCurrency20ScreenSymbol
                               , @srcExtCurrency20Desc
                               , @srcExtCurrency20CompanyRate
                               , @srcExtCurrency20DailyRate
                               , @srcExtCurrency20PrintSymbol
                               , @srcExtCurrency21ScreenSymbol
                               , @srcExtCurrency21Desc
                               , @srcExtCurrency21CompanyRate
                               , @srcExtCurrency21DailyRate
                               , @srcExtCurrency21PrintSymbol
                               , @srcExtCurrency22ScreenSymbol
                               , @srcExtCurrency22Desc
                               , @srcExtCurrency22CompanyRate
                               , @srcExtCurrency22DailyRate
                               , @srcExtCurrency22PrintSymbol
                               , @srcExtCurrency23ScreenSymbol
                               , @srcExtCurrency23Desc
                               , @srcExtCurrency23CompanyRate
                               , @srcExtCurrency23DailyRate
                               , @srcExtCurrency23PrintSymbol
                               , @srcExtCurrency24ScreenSymbol
                               , @srcExtCurrency24Desc
                               , @srcExtCurrency24CompanyRate
                               , @srcExtCurrency24DailyRate
                               , @srcExtCurrency24PrintSymbol
                               , @srcExtCurrency25ScreenSymbol
                               , @srcExtCurrency25Desc
                               , @srcExtCurrency25CompanyRate
                               , @srcExtCurrency25DailyRate
                               , @srcExtCurrency25PrintSymbol
                               , @srcExtCurrency26ScreenSymbol
                               , @srcExtCurrency26Desc
                               , @srcExtCurrency26CompanyRate
                               , @srcExtCurrency26DailyRate
                               , @srcExtCurrency26PrintSymbol
                               , @srcExtCurrency27ScreenSymbol
                               , @srcExtCurrency27Desc
                               , @srcExtCurrency27CompanyRate
                               , @srcExtCurrency27DailyRate
                               , @srcExtCurrency27PrintSymbol
                               , @srcExtCurrency28ScreenSymbol
                               , @srcExtCurrency28Desc
                               , @srcExtCurrency28CompanyRate
                               , @srcExtCurrency28DailyRate
                               , @srcExtCurrency28PrintSymbol
                               , @srcExtCurrency29ScreenSymbol
                               , @srcExtCurrency29Desc
                               , @srcExtCurrency29CompanyRate
                               , @srcExtCurrency29DailyRate
                               , @srcExtCurrency29PrintSymbol
                               , @srcExtCurrency30ScreenSymbol
                               , @srcExtCurrency30Desc
                               , @srcExtCurrency30CompanyRate
                               , @srcExtCurrency30DailyRate
                               , @srcExtCurrency30PrintSymbol
                               , @srcNames
                               , @srcOverheadGL
                               , @srcOverheadSpare
                               , @srcProductionGL
                               , @srcProductionSpare
                               , @srcSubContractGL
                               , @srcSubContractSpare
                               , @srcSpareGL1a
                               , @srcSpareGL1b
                               , @srcSpareGL2a
                               , @srcSpareGL2b
                               , @srcSpareGL3a
                               , @srcSpareGL3b
                               , @srcGenPPI
                               , @srcPPIAcCode
                               , @srcSummDesc00
                               , @srcSummDesc01
                               , @srcSummDesc02
                               , @srcSummDesc03
                               , @srcSummDesc04
                               , @srcSummDesc05
                               , @srcSummDesc06
                               , @srcSummDesc07
                               , @srcSummDesc08
                               , @srcSummDesc09
                               , @srcSummDesc10
                               , @srcSummDesc11
                               , @srcSummDesc12
                               , @srcSummDesc13
                               , @srcSummDesc14
                               , @srcSummDesc15
                               , @srcSummDesc16
                               , @srcSummDesc17
                               , @srcSummDesc18
                               , @srcSummDesc19
                               , @srcSummDesc20
                               , @srcPeriodBud
                               , @srcJCChkACode1
                               , @srcJCChkACode2
                               , @srcJCChkACode3
                               , @srcJCChkACode4
                               , @srcJCChkACode5
                               , @srcJWKMthNo
                               , @srcJTSHNoF
                               , @srcJTSHNoT
                               , @srcJFName
                               , @srcJCCommitPin
                               , @srcJAInvDate
                               , @srcJADelayCert
                               , @srcPrimaryForm001
                               , @srcPrimaryForm002
                               , @srcPrimaryForm003
                               , @srcPrimaryForm004
                               , @srcPrimaryForm005
                               , @srcPrimaryForm006
                               , @srcPrimaryForm007
                               , @srcPrimaryForm008
                               , @srcPrimaryForm009
                               , @srcPrimaryForm010
                               , @srcPrimaryForm011
                               , @srcPrimaryForm012
                               , @srcPrimaryForm013
                               , @srcPrimaryForm014
                               , @srcPrimaryForm015
                               , @srcPrimaryForm016
                               , @srcPrimaryForm017
                               , @srcPrimaryForm018
                               , @srcPrimaryForm019
                               , @srcPrimaryForm020
                               , @srcPrimaryForm021
                               , @srcPrimaryForm022
                               , @srcPrimaryForm023
                               , @srcPrimaryForm024
                               , @srcPrimaryForm025
                               , @srcPrimaryForm026
                               , @srcPrimaryForm027
                               , @srcPrimaryForm028
                               , @srcPrimaryForm029
                               , @srcPrimaryForm030
                               , @srcPrimaryForm031
                               , @srcPrimaryForm032
                               , @srcPrimaryForm033
                               , @srcPrimaryForm034
                               , @srcPrimaryForm035
                               , @srcPrimaryForm036
                               , @srcPrimaryForm037
                               , @srcPrimaryForm038
                               , @srcPrimaryForm039
                               , @srcPrimaryForm040
                               , @srcPrimaryForm041
                               , @srcPrimaryForm042
                               , @srcPrimaryForm043
                               , @srcPrimaryForm044
                               , @srcPrimaryForm045
                               , @srcPrimaryForm046
                               , @srcPrimaryForm047
                               , @srcPrimaryForm048
                               , @srcPrimaryForm049
                               , @srcPrimaryForm050
                               , @srcPrimaryForm051
                               , @srcPrimaryForm052
                               , @srcPrimaryForm053
                               , @srcPrimaryForm054
                               , @srcPrimaryForm055
                               , @srcPrimaryForm056
                               , @srcPrimaryForm057
                               , @srcPrimaryForm058
                               , @srcPrimaryForm059
                               , @srcPrimaryForm060
                               , @srcPrimaryForm061
                               , @srcPrimaryForm062
                               , @srcPrimaryForm063
                               , @srcPrimaryForm064
                               , @srcPrimaryForm065
                               , @srcPrimaryForm066
                               , @srcPrimaryForm067
                               , @srcPrimaryForm068
                               , @srcPrimaryForm069
                               , @srcPrimaryForm070
                               , @srcPrimaryForm071
                               , @srcPrimaryForm072
                               , @srcPrimaryForm073
                               , @srcPrimaryForm074
                               , @srcPrimaryForm075
                               , @srcPrimaryForm076
                               , @srcPrimaryForm077
                               , @srcPrimaryForm078
                               , @srcPrimaryForm079
                               , @srcPrimaryForm080
                               , @srcPrimaryForm081
                               , @srcPrimaryForm082
                               , @srcPrimaryForm083
                               , @srcPrimaryForm084
                               , @srcPrimaryForm085
                               , @srcPrimaryForm086
                               , @srcPrimaryForm087
                               , @srcPrimaryForm088
                               , @srcPrimaryForm089
                               , @srcPrimaryForm090
                               , @srcPrimaryForm091
                               , @srcPrimaryForm092
                               , @srcPrimaryForm093
                               , @srcPrimaryForm094
                               , @srcPrimaryForm095
                               , @srcPrimaryForm096
                               , @srcPrimaryForm097
                               , @srcPrimaryForm098
                               , @srcPrimaryForm099
                               , @srcPrimaryForm100
                               , @srcPrimaryForm101
                               , @srcPrimaryForm102
                               , @srcPrimaryForm103
                               , @srcPrimaryForm104
                               , @srcPrimaryForm105
                               , @srcPrimaryForm106
                               , @srcPrimaryForm107
                               , @srcPrimaryForm108
                               , @srcPrimaryForm109
                               , @srcPrimaryForm110
                               , @srcPrimaryForm111
                               , @srcPrimaryForm112
                               , @srcPrimaryForm113
                               , @srcPrimaryForm114
                               , @srcPrimaryForm115
                               , @srcPrimaryForm116
                               , @srcPrimaryForm117
                               , @srcPrimaryForm118
                               , @srcPrimaryForm119
                               , @srcPrimaryForm120
                               , @srcDescr
                               , @srcModuleSec
                               , @srcGCR_triRates
                               , @srcGCR_triEuro
                               , @srcGCR_triInvert
                               , @srcGCR_triFloat
                               , @srcVEDIMethod
                               , @srcVVanMode
                               , @srcVEDIFACT
                               , @srcVVANCEId
                               , @srcVVANUId
                               , @srcVUseCRLF
                               , @srcVTestMode
                               , @srcVDirPAth
                               , @srcVCompress
                               , @srcVCEEmail
                               , @srcVUEmail
                               , @srcVEPriority
                               , @srcVESubject
                               , @srcVSendEmail
                               , @srcVIEECSLP
                               , @srcEmName
                               , @srcEmAddress
                               , @srcEmSMTP
                               , @srcEmPriority
                               , @srcEmUseMAPI
                               , @srcFxUseMAPI
                               , @srcFaxPrnN
                               , @srcEmailPrnN
                               , @srcFxName
                               , @srcFxPhone
                               , @srcEmAttchMode
                               , @srcFaxDLLPath
                               , @srcSpare
                               , @srcFCaptions
                               , @srcFHide
                               , @srcCISConstructCode
                               , @srcCISConstructDesc
                               , @srcCISConstructRate
                               , @srcCISConstructGLCode
                               , @srcCISConstructDepartment
                               , @srcCISConstructCostCentre
                               , @srcCISConstructSpare
                               , @srcCISTechnicalCode
                               , @srcCISTechnicalDesc
                               , @srcCISTechnicalRate
                               , @srcCISTechnicalGLCode
                               , @srcCISTechnicalDepartment
                               , @srcCISTechnicalCostCentre
                               , @srcCISTechnicalSpare
                               , @srcCISRate1Code
                               , @srcCISRate1Desc
                               , @srcCISRate1Rate
                               , @srcCISRate1GLCode
                               , @srcCISRate1Department
                               , @srcCISRate1CostCentre
                               , @srcCISRate1Spare
                               , @srcCISRate2Code
                               , @srcCISRate2Desc
                               , @srcCISRate2Rate
                               , @srcCISRate2GLCode
                               , @srcCISRate2Department
                               , @srcCISRate2CostCentre
                               , @srcCISRate2Spare
                               , @srcCISRate3Code
                               , @srcCISRate3Desc
                               , @srcCISRate3Rate
                               , @srcCISRate3GLCode
                               , @srcCISRate3Department
                               , @srcCISRate3CostCentre
                               , @srcCISRate3Spare
                               , @srcCISRate4Code
                               , @srcCISRate4Desc
                               , @srcCISRate4Rate
                               , @srcCISRate4GLCode
                               , @srcCISRate4Department
                               , @srcCISRate4CostCentre
                               , @srcCISRate4Spare
                               , @srcCISRate5Code
                               , @srcCISRate5Desc
                               , @srcCISRate5Rate
                               , @srcCISRate5GLCode
                               , @srcCISRate5Department
                               , @srcCISRate5CostCentre
                               , @srcCISRate5Spare
                               , @srcCISRate6Code
                               , @srcCISRate6Desc
                               , @srcCISRate6Rate
                               , @srcCISRate6GLCode
                               , @srcCISRate6Department
                               , @srcCISRate6CostCentre
                               , @srcCISRate6Spare
                               , @srcCISRate7Code
                               , @srcCISRate7Desc
                               , @srcCISRate7Rate
                               , @srcCISRate7GLCode
                               , @srcCISRate7Department
                               , @srcCISRate7CostCentre
                               , @srcCISRate7Spare
                               , @srcCISRate8Code
                               , @srcCISRate8Desc
                               , @srcCISRate8Rate
                               , @srcCISRate8GLCode
                               , @srcCISRate8Department
                               , @srcCISRate8CostCentre
                               , @srcCISRate8Spare
                               , @srcCISRate9Code
                               , @srcCISRate9Desc
                               , @srcCISRate9Rate
                               , @srcCISRate9GLCode
                               , @srcCISRate9Department
                               , @srcCISRate9CostCentre
                               , @srcCISRate9Spare
                               , @srcCISInterval
                               , @srcCISAutoSetPr
                               , @srcCISVATCode
                               , @srcCISSpare3
                               , @srcCISScheme
                               , @srcCISReturnDate
                               , @srcCISCurrPeriod
                               , @srcCISLoaded
                               , @srcCISTaxRef
                               , @srcCISAggMode
                               , @srcCISSortMode
                               , @srcCISVFolio
                               , @srcCISVouchers
                               , @srcIVANMode
                               , @srcIVANIRId
                               , @srcIVANUId
                               , @srcIVANPw
                               , @srcIIREDIRef
                               , @srcIUseCRLF
                               , @srcITestMode
                               , @srcIDirPath
                               , @srcIEDIMethod
                               , @srcISendEmail
                               , @srcIEPriority
                               , @srcJCertNo
                               , @srcJCertExpiry
                               , @srcJCISType
                               , @srcCISCNINO
                               , @srcCISCUTR
                               , @srcCISACCONo
                               , @srcIGWIRId
                               , @srcIGWUId
                               , @srcIGWTO
                               , @srcIGWIRef
                               , @srcIXMLDirPath
                               , @srcIXTestMode
                               , @srcIXConfEmp
                               , @srcIXVerSub
                               , @srcIXNoPay
                               , @srcIGWTR
                               , @srcIGSubType

WHILE @@FETCH_STATUS = 0
BEGIN
  -- Get Target Columns for same row
  SELECT @trgOpt = Opt
       , @trgOMonWk1 = OMonWk1
       , @trgPrinYr = PrinYr
       , @trgFiltSNoBinLoc = FiltSNoBinLoc
       , @trgKeepBinHist = KeepBinHist
       , @trgUseBKTheme = UseBKTheme
       , @trgUserName = UserName
       , @trgAuditYr = AuditYr
       , @trgAuditPr = AuditPr
       , @trgSpare6 = Spare6
       , @trgManROCP = ManROCP
       , @trgVATCurr = VATCurr
       , @trgNoCosDec = NoCosDec
       , @trgCurrBase = CurrBase
       , @trgMuteBeep = MuteBeep
       , @trgShowStkGP = ShowStkGP
       , @trgAutoValStk = AutoValStk
       , @trgDelPickOnly = DelPickOnly
       , @trgUseMLoc = UseMLoc
       , @trgEditSinSer = EditSinSer
       , @trgWarnYRef = WarnYRef
       , @trgUseLocDel = UseLocDel
       , @trgPostCCNom = PostCCNom
       , @trgAlTolVal = AlTolVal
       , @trgAlTolMode = AlTolMode
       , @trgDebtLMode = DebtLMode
       , @trgAutoGenVar = AutoGenVar
       , @trgAutoGenDisc = AutoGenDisc
       , @trgUseModuleSec = UseModuleSec
       , @trgProtectPost = ProtectPost
       , @trgUsePick4All = UsePick4All
       , @trgBigStkTree = BigStkTree
       , @trgBigJobTree = BigJobTree
       , @trgShowQtySTree = ShowQtySTree
       , @trgProtectYRef = ProtectYRef
       , @trgPurchUIDate = PurchUIDate
       , @trgUseUpliftNC = UseUpliftNC
       , @trgUseWIss4All = UseWIss4All
       , @trgUseSTDWOP = UseSTDWOP
       , @trgUseSalesAnal = UseSalesAnal
       , @trgPostCCDCombo = PostCCDCombo
       , @trgUseClassToolB = UseClassToolB
       , @trgWOPStkCopMode = WOPStkCopMode
       , @trgUSRCntryCode = USRCntryCode
       , @trgNoNetDec = NoNetDec
       , @trgDebTrig = DebTrig
       , @trgBKThemeNo = BKThemeNo
       , @trgUseGLClass = UseGLClass
       , @trgSpare4 = Spare4
       , @trgNoInvLines = NoInvLines
       , @trgWksODue = WksODue
       , @trgCPr = CPr
       , @trgCYr = CYr
       , @trgOAuditDate = OAuditDate
       , @trgTradeTerm = TradeTerm
       , @trgStaSepCr = StaSepCr
       , @trgStaAgeMthd = StaAgeMthd
       , @trgStaUIDate = StaUIDate
       , @trgSepRunPost = SepRunPost
       , @trgQUAllocFlg = QUAllocFlg
       , @trgDeadBOM = DeadBOM
       , @trgAuthMode = AuthMode
       , @trgIntraStat = IntraStat
       , @trgAnalStkDesc = AnalStkDesc
       , @trgAutoStkVal = AutoStkVal
       , @trgAutoBillUp = AutoBillUp
       , @trgAutoCQNo = AutoCQNo
       , @trgIncNotDue = IncNotDue
       , @trgUseBatchTot = UseBatchTot
       , @trgUseStock = UseStock
       , @trgAutoNotes = AutoNotes
       , @trgHideMenuOpt = HideMenuOpt
       , @trgUseCCDep = UseCCDep
       , @trgNoHoldDisc = NoHoldDisc
       , @trgAutoPrCalc = AutoPrCalc
       , @trgStopBadDr = StopBadDr
       , @trgUsePayIn = UsePayIn
       , @trgUsePasswords = UsePasswords
       , @trgPrintReciept = PrintReciept
       , @trgExternCust = ExternCust
       , @trgNoQtyDec = NoQtyDec
       , @trgExternSIN = ExternSIN
       , @trgPrevPrOff = PrevPrOff
       , @trgDefPcDisc = DefPcDisc
       , @trgTradCodeNum = TradCodeNum
       , @trgUpBalOnPost = UpBalOnPost
       , @trgShowInvDisc = ShowInvDisc
       , @trgSepDiscounts = SepDiscounts
       , @trgUseCreditChk = UseCreditChk
       , @trgUseCRLimitChk = UseCRLimitChk
       , @trgAutoClearPay = AutoClearPay
       , @trgTotalConv = TotalConv
       , @trgDispPrAsMonths = DispPrAsMonths
       , @trgNomCtrlInVAT = NomCtrlInVAT
       , @trgNomCtrlOutVAT = NomCtrlOutVAT
       , @trgNomCtrlDebtors = NomCtrlDebtors
       , @trgNomCtrlCreditors = NomCtrlCreditors
       , @trgNomCtrlDiscountGiven = NomCtrlDiscountGiven
       , @trgNomCtrlDiscountTaken = NomCtrlDiscountTaken
       , @trgNomCtrlLDiscGiven = NomCtrlLDiscGiven
       , @trgNomCtrlLDiscTaken = NomCtrlLDiscTaken
       , @trgNomCtrlProfitBF = NomCtrlProfitBF
       , @trgNomCtrlCurrVar = NomCtrlCurrVar
       , @trgNomCtrlUnRCurrVar = NomCtrlUnRCurrVar
       , @trgNomCtrlPLStart = NomCtrlPLStart
       , @trgNomCtrlPLEnd = NomCtrlPLEnd
       , @trgNomCtrlFreightNC = NomCtrlFreightNC
       , @trgNomCtrlSalesComm = NomCtrlSalesComm
       , @trgNomCtrlPurchComm = NomCtrlPurchComm
       , @trgNomCtrlRetSurcharge = NomCtrlRetSurcharge
       , @trgNomCtrlSpare8 = NomCtrlSpare8
       , @trgNomCtrlSpare9 = NomCtrlSpare9
       , @trgNomCtrlSpare10 = NomCtrlSpare10
       , @trgNomCtrlSpare11 = NomCtrlSpare11
       , @trgNomCtrlSpare12 = NomCtrlSpare12
       , @trgNomCtrlSpare13 = NomCtrlSpare13
       , @trgNomCtrlSpare14 = NomCtrlSpare14
       , @trgDetailAddr1 = DetailAddr1
       , @trgDetailAddr2 = DetailAddr2
       , @trgDetailAddr3 = DetailAddr3
       , @trgDetailAddr4 = DetailAddr4
       , @trgDetailAddr5 = DetailAddr5
       , @trgDirectCust = DirectCust
       , @trgDirectSupp = DirectSupp
       , @trgTermsofTrade1 = TermsofTrade1
       , @trgTermsofTrade2 = TermsofTrade2
       , @trgNomPayFrom = NomPayFrom
       , @trgNomPayToo = NomPayToo
       , @trgSettleDisc = SettleDisc
       , @trgSettleDays = SettleDays
       , @trgNeedBMUp = NeedBMUp
       , @trgIgnoreBDPW = IgnoreBDPW
       , @trgInpPack = InpPack
       , @trgSpare32 = Spare32
       , @trgVATCode = VATCode
       , @trgPayTerms = PayTerms
       , @trgOTrigDate = OTrigDate
       , @trgStaAgeInt = StaAgeInt
       , @trgQuoOwnDate = QuoOwnDate
       , @trgFreeExAll = FreeExAll
       , @trgDirOwnCount = DirOwnCount
       , @trgStaShowOS = StaShowOS
       , @trgLiveCredS = LiveCredS
       , @trgBatchPPY = BatchPPY
       , @trgWarnJC = WarnJC
       , @trgTxLateCR = TxLateCR
       , @trgConsvMem = ConsvMem
       , @trgDefBankNom = DefBankNom
       , @trgUseDefBank = UseDefBank
       , @trgHideExLogo = HideExLogo
       , @trgAMMThread = AMMThread
       , @trgAMMPreview1 = AMMPreview1
       , @trgAMMPreview2 = AMMPreview2
       , @trgEntULogCount = EntULogCount
       , @trgDefSRCBankNom = DefSRCBankNom
       , @trgSDNOwnDate = SDNOwnDate
       , @trgEXISN = EXISN
       , @trgExDemoVer = ExDemoVer
       , @trgDupliVSec = DupliVSec
       , @trgLastDaily = LastDaily
       , @trgUserSort = UserSort
       , @trgUserAcc = UserAcc
       , @trgUserRef = UserRef
       , @trgSpareBits = SpareBits
       , @trgGracePeriod = GracePeriod
       , @trgMonWk1 = MonWk1
       , @trgAuditDate = AuditDate
       , @trgTrigDate = TrigDate
       , @trgExUsrSec = ExUsrSec
       , @trgUsrLogCount = UsrLogCount
       , @trgBinMask = BinMask
       , @trgSpare5a = Spare5a
       , @trgSpare6a = Spare6a
       , @trgUserBank = UserBank
       , @trgExSec = ExSec
       , @trgLastExpFolio = LastExpFolio
       , @trgDetailTel = DetailTel
       , @trgDetailFax = DetailFax
       , @trgUserVATReg = UserVATReg
       , @trgEnableTTDDiscounts = EnableTTDDiscounts
       , @trgEnableVBDDiscounts = EnableVBDDiscounts
       , @trgEnableOverrideLocations = EnableOverrideLocations
       , @trgIncludeVATInCommittedBalance = IncludeVATInCommittedBalance
       , @trgVATStandardCode = VATStandardCode
       , @trgVATStandardDesc = VATStandardDesc
       , @trgVATStandardRate = VATStandardRate
       , @trgVATStandardSpare = VATStandardSpare
       , @trgVATStandardInclude = VATStandardInclude
       , @trgVATStandardSpare2 = VATStandardSpare2
       , @trgVATExemptCode = VATExemptCode
       , @trgVATExemptDesc = VATExemptDesc
       , @trgVATExemptRate = VATExemptRate
       , @trgVATExemptSpare = VATExemptSpare
       , @trgVATExemptInclude = VATExemptInclude
       , @trgVATExemptSpare2 = VATExemptSpare2
       , @trgVATZeroCode = VATZeroCode
       , @trgVATZeroDesc = VATZeroDesc
       , @trgVATZeroRate = VATZeroRate
       , @trgVATZeroSpare = VATZeroSpare
       , @trgVATZeroInclude = VATZeroInclude
       , @trgVATZeroSpare2 = VATZeroSpare2
       , @trgVATRate1Code = VATRate1Code
       , @trgVATRate1Desc = VATRate1Desc
       , @trgVATRate1Rate = VATRate1Rate
       , @trgVATRate1Spare = VATRate1Spare
       , @trgVATRate1Include = VATRate1Include
       , @trgVATRate1Spare2 = VATRate1Spare2
       , @trgVATRate2Code = VATRate2Code
       , @trgVATRate2Desc = VATRate2Desc
       , @trgVATRate2Rate = VATRate2Rate
       , @trgVATRate2Spare = VATRate2Spare
       , @trgVATRate2Include = VATRate2Include
       , @trgVATRate2Spare2 = VATRate2Spare2
       , @trgVATRate3Code = VATRate3Code
       , @trgVATRate3Desc = VATRate3Desc
       , @trgVATRate3Rate = VATRate3Rate
       , @trgVATRate3Spare = VATRate3Spare
       , @trgVATRate3Include = VATRate3Include
       , @trgVATRate3Spare2 = VATRate3Spare2
       , @trgVATRate4Code = VATRate4Code
       , @trgVATRate4Desc = VATRate4Desc
       , @trgVATRate4Rate = VATRate4Rate
       , @trgVATRate4Spare = VATRate4Spare
       , @trgVATRate4Include = VATRate4Include
       , @trgVATRate4Spare2 = VATRate4Spare2
       , @trgVATRate5Code = VATRate5Code
       , @trgVATRate5Desc = VATRate5Desc
       , @trgVATRate5Rate = VATRate5Rate
       , @trgVATRate5Spare = VATRate5Spare
       , @trgVATRate5Include = VATRate5Include
       , @trgVATRate5Spare2 = VATRate5Spare2
       , @trgVATRate6Code = VATRate6Code
       , @trgVATRate6Desc = VATRate6Desc
       , @trgVATRate6Rate = VATRate6Rate
       , @trgVATRate6Spare = VATRate6Spare
       , @trgVATRate6Include = VATRate6Include
       , @trgVATRate6Spare2 = VATRate6Spare2
       , @trgVATRate7Code = VATRate7Code
       , @trgVATRate7Desc = VATRate7Desc
       , @trgVATRate7Rate = VATRate7Rate
       , @trgVATRate7Spare = VATRate7Spare
       , @trgVATRate7Include = VATRate7Include
       , @trgVATRate7Spare2 = VATRate7Spare2
       , @trgVATRate8Code = VATRate8Code
       , @trgVATRate8Desc = VATRate8Desc
       , @trgVATRate8Rate = VATRate8Rate
       , @trgVATRate8Spare = VATRate8Spare
       , @trgVATRate8Include = VATRate8Include
       , @trgVATRate8Spare2 = VATRate8Spare2
       , @trgVATRate9Code = VATRate9Code
       , @trgVATRate9Desc = VATRate9Desc
       , @trgVATRate9Rate = VATRate9Rate
       , @trgVATRate9Spare = VATRate9Spare
       , @trgVATRate9Include = VATRate9Include
       , @trgVATRate9Spare2 = VATRate9Spare2
       , @trgVATRate10Code = VATRate10Code
       , @trgVATRate10Desc = VATRate10Desc
       , @trgVATRate10Rate = VATRate10Rate
       , @trgVATRate10Spare = VATRate10Spare
       , @trgVATRate10Include = VATRate10Include
       , @trgVATRate10Spare2 = VATRate10Spare2
       , @trgVATRate11Code = VATRate11Code
       , @trgVATRate11Desc = VATRate11Desc
       , @trgVATRate11Rate = VATRate11Rate
       , @trgVATRate11Spare = VATRate11Spare
       , @trgVATRate11Include = VATRate11Include
       , @trgVATRate11Spare2 = VATRate11Spare2
       , @trgVATRate12Code = VATRate12Code
       , @trgVATRate12Desc = VATRate12Desc
       , @trgVATRate12Rate = VATRate12Rate
       , @trgVATRate12Spare = VATRate12Spare
       , @trgVATRate12Include = VATRate12Include
       , @trgVATRate12Spare2 = VATRate12Spare2
       , @trgVATRate13Code = VATRate13Code
       , @trgVATRate13Desc = VATRate13Desc
       , @trgVATRate13Rate = VATRate13Rate
       , @trgVATRate13Spare = VATRate13Spare
       , @trgVATRate13Include = VATRate13Include
       , @trgVATRate13Spare2 = VATRate13Spare2
       , @trgVATRate14Code = VATRate14Code
       , @trgVATRate14Desc = VATRate14Desc
       , @trgVATRate14Rate = VATRate14Rate
       , @trgVATRate14Spare = VATRate14Spare
       , @trgVATRate14Include = VATRate14Include
       , @trgVATRate14Spare2 = VATRate14Spare2
       , @trgVATRate15Code = VATRate15Code
       , @trgVATRate15Desc = VATRate15Desc
       , @trgVATRate15Rate = VATRate15Rate
       , @trgVATRate15Spare = VATRate15Spare
       , @trgVATRate15Include = VATRate15Include
       , @trgVATRate15Spare2 = VATRate15Spare2
       , @trgVATRate16Code = VATRate16Code
       , @trgVATRate16Desc = VATRate16Desc
       , @trgVATRate16Rate = VATRate16Rate
       , @trgVATRate16Spare = VATRate16Spare
       , @trgVATRate16Include = VATRate16Include
       , @trgVATRate16Spare2 = VATRate16Spare2
       , @trgVATRate17Code = VATRate17Code
       , @trgVATRate17Desc = VATRate17Desc
       , @trgVATRate17Rate = VATRate17Rate
       , @trgVATRate17Spare = VATRate17Spare
       , @trgVATRate17Include = VATRate17Include
       , @trgVATRate17Spare2 = VATRate17Spare2
       , @trgVATRate18Code = VATRate18Code
       , @trgVATRate18Desc = VATRate18Desc
       , @trgVATRate18Rate = VATRate18Rate
       , @trgVATRate18Spare = VATRate18Spare
       , @trgVATRate18Include = VATRate18Include
       , @trgVATRate18Spare2 = VATRate18Spare2
       , @trgVATIAdjCode = VATIAdjCode
       , @trgVATIAdjDesc = VATIAdjDesc
       , @trgVATIAdjRate = VATIAdjRate
       , @trgVATIAdjSpare = VATIAdjSpare
       , @trgVATIAdjInclude = VATIAdjInclude
       , @trgVATIAdjSpare2 = VATIAdjSpare2
       , @trgVATOAdjCode = VATOAdjCode
       , @trgVATOAdjDesc = VATOAdjDesc
       , @trgVATOAdjRate = VATOAdjRate
       , @trgVATOAdjSpare = VATOAdjSpare
       , @trgVATOAdjInclude = VATOAdjInclude
       , @trgVATOAdjSpare2 = VATOAdjSpare2
       , @trgVATSpare8Code = VATSpare8Code
       , @trgVATSpare8Desc = VATSpare8Desc
       , @trgVATSpare8Rate = VATSpare8Rate
       , @trgVATSpare8Spare = VATSpare8Spare
       , @trgVATSpare8Include = VATSpare8Include
       , @trgVATSpare8Spare2 = VATSpare8Spare2
       , @trgHideUDF7 = HideUDF7
       , @trgHideUDF8 = HideUDF8
       , @trgHideUDF9 = HideUDF9
       , @trgHideUDF10 = HideUDF10
       , @trgHideUDF11 = HideUDF11
       , @trgSpare2 = Spare2
       , @trgVATInterval = VATInterval
       , @trgSpare3 = Spare3
       , @trgVATScheme = VATScheme
       , @trgOLastECSalesDate = OLastECSalesDate
       , @trgVATReturnDate = VATReturnDate
       , @trgLastECSalesDate = LastECSalesDate
       , @trgCurrPeriod = CurrPeriod
       , @trgUDFCaption1 = UDFCaption1
       , @trgUDFCaption2 = UDFCaption2
       , @trgUDFCaption3 = UDFCaption3
       , @trgUDFCaption4 = UDFCaption4
       , @trgUDFCaption5 = UDFCaption5
       , @trgUDFCaption6 = UDFCaption6
       , @trgUDFCaption7 = UDFCaption7
       , @trgUDFCaption8 = UDFCaption8
       , @trgUDFCaption9 = UDFCaption9
       , @trgUDFCaption10 = UDFCaption10
       , @trgUDFCaption11 = UDFCaption11
       , @trgUDFCaption12 = UDFCaption12
       , @trgUDFCaption13 = UDFCaption13
       , @trgUDFCaption14 = UDFCaption14
       , @trgUDFCaption15 = UDFCaption15
       , @trgUDFCaption16 = UDFCaption16
       , @trgUDFCaption17 = UDFCaption17
       , @trgUDFCaption18 = UDFCaption18
       , @trgUDFCaption19 = UDFCaption19
       , @trgUDFCaption20 = UDFCaption20
       , @trgUDFCaption21 = UDFCaption21
       , @trgUDFCaption22 = UDFCaption22
       , @trgHideLType0 = HideLType0
       , @trgHideLType1 = HideLType1
       , @trgHideLType2 = HideLType2
       , @trgHideLType3 = HideLType3
       , @trgHideLType4 = HideLType4
       , @trgHideLType5 = HideLType5
       , @trgHideLType6 = HideLType6
       , @trgReportPrnN = ReportPrnN
       , @trgFormsPrnN = FormsPrnN
       , @trgEnableECServices = EnableECServices
       , @trgECSalesThreshold = ECSalesThreshold
       , @trgMainCurrency00ScreenSymbol = MainCurrency00ScreenSymbol
       , @trgMainCurrency00Desc = MainCurrency00Desc
       , @trgMainCurrency00CompanyRate = MainCurrency00CompanyRate
       , @trgMainCurrency00DailyRate = MainCurrency00DailyRate
       , @trgMainCurrency00PrintSymbol = MainCurrency00PrintSymbol
       , @trgMainCurrency01ScreenSymbol = MainCurrency01ScreenSymbol
       , @trgMainCurrency01Desc = MainCurrency01Desc
       , @trgMainCurrency01CompanyRate = MainCurrency01CompanyRate
       , @trgMainCurrency01DailyRate = MainCurrency01DailyRate
       , @trgMainCurrency01PrintSymbol = MainCurrency01PrintSymbol
       , @trgMainCurrency02ScreenSymbol = MainCurrency02ScreenSymbol
       , @trgMainCurrency02Desc = MainCurrency02Desc
       , @trgMainCurrency02CompanyRate = MainCurrency02CompanyRate
       , @trgMainCurrency02DailyRate = MainCurrency02DailyRate
       , @trgMainCurrency02PrintSymbol = MainCurrency02PrintSymbol
       , @trgMainCurrency03ScreenSymbol = MainCurrency03ScreenSymbol
       , @trgMainCurrency03Desc = MainCurrency03Desc
       , @trgMainCurrency03CompanyRate = MainCurrency03CompanyRate
       , @trgMainCurrency03DailyRate = MainCurrency03DailyRate
       , @trgMainCurrency03PrintSymbol = MainCurrency03PrintSymbol
       , @trgMainCurrency04ScreenSymbol = MainCurrency04ScreenSymbol
       , @trgMainCurrency04Desc = MainCurrency04Desc
       , @trgMainCurrency04CompanyRate = MainCurrency04CompanyRate
       , @trgMainCurrency04DailyRate = MainCurrency04DailyRate
       , @trgMainCurrency04PrintSymbol = MainCurrency04PrintSymbol
       , @trgMainCurrency05ScreenSymbol = MainCurrency05ScreenSymbol
       , @trgMainCurrency05Desc = MainCurrency05Desc
       , @trgMainCurrency05CompanyRate = MainCurrency05CompanyRate
       , @trgMainCurrency05DailyRate = MainCurrency05DailyRate
       , @trgMainCurrency05PrintSymbol = MainCurrency05PrintSymbol
       , @trgMainCurrency06ScreenSymbol = MainCurrency06ScreenSymbol
       , @trgMainCurrency06Desc = MainCurrency06Desc
       , @trgMainCurrency06CompanyRate = MainCurrency06CompanyRate
       , @trgMainCurrency06DailyRate = MainCurrency06DailyRate
       , @trgMainCurrency06PrintSymbol = MainCurrency06PrintSymbol
       , @trgMainCurrency07ScreenSymbol = MainCurrency07ScreenSymbol
       , @trgMainCurrency07Desc = MainCurrency07Desc
       , @trgMainCurrency07CompanyRate = MainCurrency07CompanyRate
       , @trgMainCurrency07DailyRate = MainCurrency07DailyRate
       , @trgMainCurrency07PrintSymbol = MainCurrency07PrintSymbol
       , @trgMainCurrency08ScreenSymbol = MainCurrency08ScreenSymbol
       , @trgMainCurrency08Desc = MainCurrency08Desc
       , @trgMainCurrency08CompanyRate = MainCurrency08CompanyRate
       , @trgMainCurrency08DailyRate = MainCurrency08DailyRate
       , @trgMainCurrency08PrintSymbol = MainCurrency08PrintSymbol
       , @trgMainCurrency09ScreenSymbol = MainCurrency09ScreenSymbol
       , @trgMainCurrency09Desc = MainCurrency09Desc
       , @trgMainCurrency09CompanyRate = MainCurrency09CompanyRate
       , @trgMainCurrency09DailyRate = MainCurrency09DailyRate
       , @trgMainCurrency09PrintSymbol = MainCurrency09PrintSymbol
       , @trgMainCurrency10ScreenSymbol = MainCurrency10ScreenSymbol
       , @trgMainCurrency10Desc = MainCurrency10Desc
       , @trgMainCurrency10CompanyRate = MainCurrency10CompanyRate
       , @trgMainCurrency10DailyRate = MainCurrency10DailyRate
       , @trgMainCurrency10PrintSymbol = MainCurrency10PrintSymbol
       , @trgMainCurrency11ScreenSymbol = MainCurrency11ScreenSymbol
       , @trgMainCurrency11Desc = MainCurrency11Desc
       , @trgMainCurrency11CompanyRate = MainCurrency11CompanyRate
       , @trgMainCurrency11DailyRate = MainCurrency11DailyRate
       , @trgMainCurrency11PrintSymbol = MainCurrency11PrintSymbol
       , @trgMainCurrency12ScreenSymbol = MainCurrency12ScreenSymbol
       , @trgMainCurrency12Desc = MainCurrency12Desc
       , @trgMainCurrency12CompanyRate = MainCurrency12CompanyRate
       , @trgMainCurrency12DailyRate = MainCurrency12DailyRate
       , @trgMainCurrency12PrintSymbol = MainCurrency12PrintSymbol
       , @trgMainCurrency13ScreenSymbol = MainCurrency13ScreenSymbol
       , @trgMainCurrency13Desc = MainCurrency13Desc
       , @trgMainCurrency13CompanyRate = MainCurrency13CompanyRate
       , @trgMainCurrency13DailyRate = MainCurrency13DailyRate
       , @trgMainCurrency13PrintSymbol = MainCurrency13PrintSymbol
       , @trgMainCurrency14ScreenSymbol = MainCurrency14ScreenSymbol
       , @trgMainCurrency14Desc = MainCurrency14Desc
       , @trgMainCurrency14CompanyRate = MainCurrency14CompanyRate
       , @trgMainCurrency14DailyRate = MainCurrency14DailyRate
       , @trgMainCurrency14PrintSymbol = MainCurrency14PrintSymbol
       , @trgMainCurrency15ScreenSymbol = MainCurrency15ScreenSymbol
       , @trgMainCurrency15Desc = MainCurrency15Desc
       , @trgMainCurrency15CompanyRate = MainCurrency15CompanyRate
       , @trgMainCurrency15DailyRate = MainCurrency15DailyRate
       , @trgMainCurrency15PrintSymbol = MainCurrency15PrintSymbol
       , @trgMainCurrency16ScreenSymbol = MainCurrency16ScreenSymbol
       , @trgMainCurrency16Desc = MainCurrency16Desc
       , @trgMainCurrency16CompanyRate = MainCurrency16CompanyRate
       , @trgMainCurrency16DailyRate = MainCurrency16DailyRate
       , @trgMainCurrency16PrintSymbol = MainCurrency16PrintSymbol
       , @trgMainCurrency17ScreenSymbol = MainCurrency17ScreenSymbol
       , @trgMainCurrency17Desc = MainCurrency17Desc
       , @trgMainCurrency17CompanyRate = MainCurrency17CompanyRate
       , @trgMainCurrency17DailyRate = MainCurrency17DailyRate
       , @trgMainCurrency17PrintSymbol = MainCurrency17PrintSymbol
       , @trgMainCurrency18ScreenSymbol = MainCurrency18ScreenSymbol
       , @trgMainCurrency18Desc = MainCurrency18Desc
       , @trgMainCurrency18CompanyRate = MainCurrency18CompanyRate
       , @trgMainCurrency18DailyRate = MainCurrency18DailyRate
       , @trgMainCurrency18PrintSymbol = MainCurrency18PrintSymbol
       , @trgMainCurrency19ScreenSymbol = MainCurrency19ScreenSymbol
       , @trgMainCurrency19Desc = MainCurrency19Desc
       , @trgMainCurrency19CompanyRate = MainCurrency19CompanyRate
       , @trgMainCurrency19DailyRate = MainCurrency19DailyRate
       , @trgMainCurrency19PrintSymbol = MainCurrency19PrintSymbol
       , @trgMainCurrency20ScreenSymbol = MainCurrency20ScreenSymbol
       , @trgMainCurrency20Desc = MainCurrency20Desc
       , @trgMainCurrency20CompanyRate = MainCurrency20CompanyRate
       , @trgMainCurrency20DailyRate = MainCurrency20DailyRate
       , @trgMainCurrency20PrintSymbol = MainCurrency20PrintSymbol
       , @trgMainCurrency21ScreenSymbol = MainCurrency21ScreenSymbol
       , @trgMainCurrency21Desc = MainCurrency21Desc
       , @trgMainCurrency21CompanyRate = MainCurrency21CompanyRate
       , @trgMainCurrency21DailyRate = MainCurrency21DailyRate
       , @trgMainCurrency21PrintSymbol = MainCurrency21PrintSymbol
       , @trgMainCurrency22ScreenSymbol = MainCurrency22ScreenSymbol
       , @trgMainCurrency22Desc = MainCurrency22Desc
       , @trgMainCurrency22CompanyRate = MainCurrency22CompanyRate
       , @trgMainCurrency22DailyRate = MainCurrency22DailyRate
       , @trgMainCurrency22PrintSymbol = MainCurrency22PrintSymbol
       , @trgMainCurrency23ScreenSymbol = MainCurrency23ScreenSymbol
       , @trgMainCurrency23Desc = MainCurrency23Desc
       , @trgMainCurrency23CompanyRate = MainCurrency23CompanyRate
       , @trgMainCurrency23DailyRate = MainCurrency23DailyRate
       , @trgMainCurrency23PrintSymbol = MainCurrency23PrintSymbol
       , @trgMainCurrency24ScreenSymbol = MainCurrency24ScreenSymbol
       , @trgMainCurrency24Desc = MainCurrency24Desc
       , @trgMainCurrency24CompanyRate = MainCurrency24CompanyRate
       , @trgMainCurrency24DailyRate = MainCurrency24DailyRate
       , @trgMainCurrency24PrintSymbol = MainCurrency24PrintSymbol
       , @trgMainCurrency25ScreenSymbol = MainCurrency25ScreenSymbol
       , @trgMainCurrency25Desc = MainCurrency25Desc
       , @trgMainCurrency25CompanyRate = MainCurrency25CompanyRate
       , @trgMainCurrency25DailyRate = MainCurrency25DailyRate
       , @trgMainCurrency25PrintSymbol = MainCurrency25PrintSymbol
       , @trgMainCurrency26ScreenSymbol = MainCurrency26ScreenSymbol
       , @trgMainCurrency26Desc = MainCurrency26Desc
       , @trgMainCurrency26CompanyRate = MainCurrency26CompanyRate
       , @trgMainCurrency26DailyRate = MainCurrency26DailyRate
       , @trgMainCurrency26PrintSymbol = MainCurrency26PrintSymbol
       , @trgMainCurrency27ScreenSymbol = MainCurrency27ScreenSymbol
       , @trgMainCurrency27Desc = MainCurrency27Desc
       , @trgMainCurrency27CompanyRate = MainCurrency27CompanyRate
       , @trgMainCurrency27DailyRate = MainCurrency27DailyRate
       , @trgMainCurrency27PrintSymbol = MainCurrency27PrintSymbol
       , @trgMainCurrency28ScreenSymbol = MainCurrency28ScreenSymbol
       , @trgMainCurrency28Desc = MainCurrency28Desc
       , @trgMainCurrency28CompanyRate = MainCurrency28CompanyRate
       , @trgMainCurrency28DailyRate = MainCurrency28DailyRate
       , @trgMainCurrency28PrintSymbol = MainCurrency28PrintSymbol
       , @trgMainCurrency29ScreenSymbol = MainCurrency29ScreenSymbol
       , @trgMainCurrency29Desc = MainCurrency29Desc
       , @trgMainCurrency29CompanyRate = MainCurrency29CompanyRate
       , @trgMainCurrency29DailyRate = MainCurrency29DailyRate
       , @trgMainCurrency29PrintSymbol = MainCurrency29PrintSymbol
       , @trgMainCurrency30ScreenSymbol = MainCurrency30ScreenSymbol
       , @trgMainCurrency30Desc = MainCurrency30Desc
       , @trgMainCurrency30CompanyRate = MainCurrency30CompanyRate
       , @trgMainCurrency30DailyRate = MainCurrency30DailyRate
       , @trgMainCurrency30PrintSymbol = MainCurrency30PrintSymbol
       , @trgExtCurrency00ScreenSymbol = ExtCurrency00ScreenSymbol
       , @trgExtCurrency00Desc = ExtCurrency00Desc
       , @trgExtCurrency00CompanyRate = ExtCurrency00CompanyRate
       , @trgExtCurrency00DailyRate = ExtCurrency00DailyRate
       , @trgExtCurrency00PrintSymbol = ExtCurrency00PrintSymbol
       , @trgExtCurrency01ScreenSymbol = ExtCurrency01ScreenSymbol
       , @trgExtCurrency01Desc = ExtCurrency01Desc
       , @trgExtCurrency01CompanyRate = ExtCurrency01CompanyRate
       , @trgExtCurrency01DailyRate = ExtCurrency01DailyRate
       , @trgExtCurrency01PrintSymbol = ExtCurrency01PrintSymbol
       , @trgExtCurrency02ScreenSymbol = ExtCurrency02ScreenSymbol
       , @trgExtCurrency02Desc = ExtCurrency02Desc
       , @trgExtCurrency02CompanyRate = ExtCurrency02CompanyRate
       , @trgExtCurrency02DailyRate = ExtCurrency02DailyRate
       , @trgExtCurrency02PrintSymbol = ExtCurrency02PrintSymbol
       , @trgExtCurrency03ScreenSymbol = ExtCurrency03ScreenSymbol
       , @trgExtCurrency03Desc = ExtCurrency03Desc
       , @trgExtCurrency03CompanyRate = ExtCurrency03CompanyRate
       , @trgExtCurrency03DailyRate = ExtCurrency03DailyRate
       , @trgExtCurrency03PrintSymbol = ExtCurrency03PrintSymbol
       , @trgExtCurrency04ScreenSymbol = ExtCurrency04ScreenSymbol
       , @trgExtCurrency04Desc = ExtCurrency04Desc
       , @trgExtCurrency04CompanyRate = ExtCurrency04CompanyRate
       , @trgExtCurrency04DailyRate = ExtCurrency04DailyRate
       , @trgExtCurrency04PrintSymbol = ExtCurrency04PrintSymbol
       , @trgExtCurrency05ScreenSymbol = ExtCurrency05ScreenSymbol
       , @trgExtCurrency05Desc = ExtCurrency05Desc
       , @trgExtCurrency05CompanyRate = ExtCurrency05CompanyRate
       , @trgExtCurrency05DailyRate = ExtCurrency05DailyRate
       , @trgExtCurrency05PrintSymbol = ExtCurrency05PrintSymbol
       , @trgExtCurrency06ScreenSymbol = ExtCurrency06ScreenSymbol
       , @trgExtCurrency06Desc = ExtCurrency06Desc
       , @trgExtCurrency06CompanyRate = ExtCurrency06CompanyRate
       , @trgExtCurrency06DailyRate = ExtCurrency06DailyRate
       , @trgExtCurrency06PrintSymbol = ExtCurrency06PrintSymbol
       , @trgExtCurrency07ScreenSymbol = ExtCurrency07ScreenSymbol
       , @trgExtCurrency07Desc = ExtCurrency07Desc
       , @trgExtCurrency07CompanyRate = ExtCurrency07CompanyRate
       , @trgExtCurrency07DailyRate = ExtCurrency07DailyRate
       , @trgExtCurrency07PrintSymbol = ExtCurrency07PrintSymbol
       , @trgExtCurrency08ScreenSymbol = ExtCurrency08ScreenSymbol
       , @trgExtCurrency08Desc = ExtCurrency08Desc
       , @trgExtCurrency08CompanyRate = ExtCurrency08CompanyRate
       , @trgExtCurrency08DailyRate = ExtCurrency08DailyRate
       , @trgExtCurrency08PrintSymbol = ExtCurrency08PrintSymbol
       , @trgExtCurrency09ScreenSymbol = ExtCurrency09ScreenSymbol
       , @trgExtCurrency09Desc = ExtCurrency09Desc
       , @trgExtCurrency09CompanyRate = ExtCurrency09CompanyRate
       , @trgExtCurrency09DailyRate = ExtCurrency09DailyRate
       , @trgExtCurrency09PrintSymbol = ExtCurrency09PrintSymbol
       , @trgExtCurrency10ScreenSymbol = ExtCurrency10ScreenSymbol
       , @trgExtCurrency10Desc = ExtCurrency10Desc
       , @trgExtCurrency10CompanyRate = ExtCurrency10CompanyRate
       , @trgExtCurrency10DailyRate = ExtCurrency10DailyRate
       , @trgExtCurrency10PrintSymbol = ExtCurrency10PrintSymbol
       , @trgExtCurrency11ScreenSymbol = ExtCurrency11ScreenSymbol
       , @trgExtCurrency11Desc = ExtCurrency11Desc
       , @trgExtCurrency11CompanyRate = ExtCurrency11CompanyRate
       , @trgExtCurrency11DailyRate = ExtCurrency11DailyRate
       , @trgExtCurrency11PrintSymbol = ExtCurrency11PrintSymbol
       , @trgExtCurrency12ScreenSymbol = ExtCurrency12ScreenSymbol
       , @trgExtCurrency12Desc = ExtCurrency12Desc
       , @trgExtCurrency12CompanyRate = ExtCurrency12CompanyRate
       , @trgExtCurrency12DailyRate = ExtCurrency12DailyRate
       , @trgExtCurrency12PrintSymbol = ExtCurrency12PrintSymbol
       , @trgExtCurrency13ScreenSymbol = ExtCurrency13ScreenSymbol
       , @trgExtCurrency13Desc = ExtCurrency13Desc
       , @trgExtCurrency13CompanyRate = ExtCurrency13CompanyRate
       , @trgExtCurrency13DailyRate = ExtCurrency13DailyRate
       , @trgExtCurrency13PrintSymbol = ExtCurrency13PrintSymbol
       , @trgExtCurrency14ScreenSymbol = ExtCurrency14ScreenSymbol
       , @trgExtCurrency14Desc = ExtCurrency14Desc
       , @trgExtCurrency14CompanyRate = ExtCurrency14CompanyRate
       , @trgExtCurrency14DailyRate = ExtCurrency14DailyRate
       , @trgExtCurrency14PrintSymbol = ExtCurrency14PrintSymbol
       , @trgExtCurrency15ScreenSymbol = ExtCurrency15ScreenSymbol
       , @trgExtCurrency15Desc = ExtCurrency15Desc
       , @trgExtCurrency15CompanyRate = ExtCurrency15CompanyRate
       , @trgExtCurrency15DailyRate = ExtCurrency15DailyRate
       , @trgExtCurrency15PrintSymbol = ExtCurrency15PrintSymbol
       , @trgExtCurrency16ScreenSymbol = ExtCurrency16ScreenSymbol
       , @trgExtCurrency16Desc = ExtCurrency16Desc
       , @trgExtCurrency16CompanyRate = ExtCurrency16CompanyRate
       , @trgExtCurrency16DailyRate = ExtCurrency16DailyRate
       , @trgExtCurrency16PrintSymbol = ExtCurrency16PrintSymbol
       , @trgExtCurrency17ScreenSymbol = ExtCurrency17ScreenSymbol
       , @trgExtCurrency17Desc = ExtCurrency17Desc
       , @trgExtCurrency17CompanyRate = ExtCurrency17CompanyRate
       , @trgExtCurrency17DailyRate = ExtCurrency17DailyRate
       , @trgExtCurrency17PrintSymbol = ExtCurrency17PrintSymbol
       , @trgExtCurrency18ScreenSymbol = ExtCurrency18ScreenSymbol
       , @trgExtCurrency18Desc = ExtCurrency18Desc
       , @trgExtCurrency18CompanyRate = ExtCurrency18CompanyRate
       , @trgExtCurrency18DailyRate = ExtCurrency18DailyRate
       , @trgExtCurrency18PrintSymbol = ExtCurrency18PrintSymbol
       , @trgExtCurrency19ScreenSymbol = ExtCurrency19ScreenSymbol
       , @trgExtCurrency19Desc = ExtCurrency19Desc
       , @trgExtCurrency19CompanyRate = ExtCurrency19CompanyRate
       , @trgExtCurrency19DailyRate = ExtCurrency19DailyRate
       , @trgExtCurrency19PrintSymbol = ExtCurrency19PrintSymbol
       , @trgExtCurrency20ScreenSymbol = ExtCurrency20ScreenSymbol
       , @trgExtCurrency20Desc = ExtCurrency20Desc
       , @trgExtCurrency20CompanyRate = ExtCurrency20CompanyRate
       , @trgExtCurrency20DailyRate = ExtCurrency20DailyRate
       , @trgExtCurrency20PrintSymbol = ExtCurrency20PrintSymbol
       , @trgExtCurrency21ScreenSymbol = ExtCurrency21ScreenSymbol
       , @trgExtCurrency21Desc = ExtCurrency21Desc
       , @trgExtCurrency21CompanyRate = ExtCurrency21CompanyRate
       , @trgExtCurrency21DailyRate = ExtCurrency21DailyRate
       , @trgExtCurrency21PrintSymbol = ExtCurrency21PrintSymbol
       , @trgExtCurrency22ScreenSymbol = ExtCurrency22ScreenSymbol
       , @trgExtCurrency22Desc = ExtCurrency22Desc
       , @trgExtCurrency22CompanyRate = ExtCurrency22CompanyRate
       , @trgExtCurrency22DailyRate = ExtCurrency22DailyRate
       , @trgExtCurrency22PrintSymbol = ExtCurrency22PrintSymbol
       , @trgExtCurrency23ScreenSymbol = ExtCurrency23ScreenSymbol
       , @trgExtCurrency23Desc = ExtCurrency23Desc
       , @trgExtCurrency23CompanyRate = ExtCurrency23CompanyRate
       , @trgExtCurrency23DailyRate = ExtCurrency23DailyRate
       , @trgExtCurrency23PrintSymbol = ExtCurrency23PrintSymbol
       , @trgExtCurrency24ScreenSymbol = ExtCurrency24ScreenSymbol
       , @trgExtCurrency24Desc = ExtCurrency24Desc
       , @trgExtCurrency24CompanyRate = ExtCurrency24CompanyRate
       , @trgExtCurrency24DailyRate = ExtCurrency24DailyRate
       , @trgExtCurrency24PrintSymbol = ExtCurrency24PrintSymbol
       , @trgExtCurrency25ScreenSymbol = ExtCurrency25ScreenSymbol
       , @trgExtCurrency25Desc = ExtCurrency25Desc
       , @trgExtCurrency25CompanyRate = ExtCurrency25CompanyRate
       , @trgExtCurrency25DailyRate = ExtCurrency25DailyRate
       , @trgExtCurrency25PrintSymbol = ExtCurrency25PrintSymbol
       , @trgExtCurrency26ScreenSymbol = ExtCurrency26ScreenSymbol
       , @trgExtCurrency26Desc = ExtCurrency26Desc
       , @trgExtCurrency26CompanyRate = ExtCurrency26CompanyRate
       , @trgExtCurrency26DailyRate = ExtCurrency26DailyRate
       , @trgExtCurrency26PrintSymbol = ExtCurrency26PrintSymbol
       , @trgExtCurrency27ScreenSymbol = ExtCurrency27ScreenSymbol
       , @trgExtCurrency27Desc = ExtCurrency27Desc
       , @trgExtCurrency27CompanyRate = ExtCurrency27CompanyRate
       , @trgExtCurrency27DailyRate = ExtCurrency27DailyRate
       , @trgExtCurrency27PrintSymbol = ExtCurrency27PrintSymbol
       , @trgExtCurrency28ScreenSymbol = ExtCurrency28ScreenSymbol
       , @trgExtCurrency28Desc = ExtCurrency28Desc
       , @trgExtCurrency28CompanyRate = ExtCurrency28CompanyRate
       , @trgExtCurrency28DailyRate = ExtCurrency28DailyRate
       , @trgExtCurrency28PrintSymbol = ExtCurrency28PrintSymbol
       , @trgExtCurrency29ScreenSymbol = ExtCurrency29ScreenSymbol
       , @trgExtCurrency29Desc = ExtCurrency29Desc
       , @trgExtCurrency29CompanyRate = ExtCurrency29CompanyRate
       , @trgExtCurrency29DailyRate = ExtCurrency29DailyRate
       , @trgExtCurrency29PrintSymbol = ExtCurrency29PrintSymbol
       , @trgExtCurrency30ScreenSymbol = ExtCurrency30ScreenSymbol
       , @trgExtCurrency30Desc = ExtCurrency30Desc
       , @trgExtCurrency30CompanyRate = ExtCurrency30CompanyRate
       , @trgExtCurrency30DailyRate = ExtCurrency30DailyRate
       , @trgExtCurrency30PrintSymbol = ExtCurrency30PrintSymbol
       , @trgNames = Names
       , @trgOverheadGL = OverheadGL
       , @trgOverheadSpare = OverheadSpare
       , @trgProductionGL = ProductionGL
       , @trgProductionSpare = ProductionSpare
       , @trgSubContractGL = SubContractGL
       , @trgSubContractSpare = SubContractSpare
       , @trgSpareGL1a = SpareGL1a
       , @trgSpareGL1b = SpareGL1b
       , @trgSpareGL2a = SpareGL2a
       , @trgSpareGL2b = SpareGL2b
       , @trgSpareGL3a = SpareGL3a
       , @trgSpareGL3b = SpareGL3b
       , @trgGenPPI = GenPPI
       , @trgPPIAcCode = PPIAcCode
       , @trgSummDesc00 = SummDesc00
       , @trgSummDesc01 = SummDesc01
       , @trgSummDesc02 = SummDesc02
       , @trgSummDesc03 = SummDesc03
       , @trgSummDesc04 = SummDesc04
       , @trgSummDesc05 = SummDesc05
       , @trgSummDesc06 = SummDesc06
       , @trgSummDesc07 = SummDesc07
       , @trgSummDesc08 = SummDesc08
       , @trgSummDesc09 = SummDesc09
       , @trgSummDesc10 = SummDesc10
       , @trgSummDesc11 = SummDesc11
       , @trgSummDesc12 = SummDesc12
       , @trgSummDesc13 = SummDesc13
       , @trgSummDesc14 = SummDesc14
       , @trgSummDesc15 = SummDesc15
       , @trgSummDesc16 = SummDesc16
       , @trgSummDesc17 = SummDesc17
       , @trgSummDesc18 = SummDesc18
       , @trgSummDesc19 = SummDesc19
       , @trgSummDesc20 = SummDesc20
       , @trgPeriodBud = PeriodBud
       , @trgJCChkACode1 = JCChkACode1
       , @trgJCChkACode2 = JCChkACode2
       , @trgJCChkACode3 = JCChkACode3
       , @trgJCChkACode4 = JCChkACode4
       , @trgJCChkACode5 = JCChkACode5
       , @trgJWKMthNo = JWKMthNo
       , @trgJTSHNoF = JTSHNoF
       , @trgJTSHNoT = JTSHNoT
       , @trgJFName = JFName
       , @trgJCCommitPin = JCCommitPin
       , @trgJAInvDate = JAInvDate
       , @trgJADelayCert = JADelayCert
       , @trgPrimaryForm001 = PrimaryForm001
       , @trgPrimaryForm002 = PrimaryForm002
       , @trgPrimaryForm003 = PrimaryForm003
       , @trgPrimaryForm004 = PrimaryForm004
       , @trgPrimaryForm005 = PrimaryForm005
       , @trgPrimaryForm006 = PrimaryForm006
       , @trgPrimaryForm007 = PrimaryForm007
       , @trgPrimaryForm008 = PrimaryForm008
       , @trgPrimaryForm009 = PrimaryForm009
       , @trgPrimaryForm010 = PrimaryForm010
       , @trgPrimaryForm011 = PrimaryForm011
       , @trgPrimaryForm012 = PrimaryForm012
       , @trgPrimaryForm013 = PrimaryForm013
       , @trgPrimaryForm014 = PrimaryForm014
       , @trgPrimaryForm015 = PrimaryForm015
       , @trgPrimaryForm016 = PrimaryForm016
       , @trgPrimaryForm017 = PrimaryForm017
       , @trgPrimaryForm018 = PrimaryForm018
       , @trgPrimaryForm019 = PrimaryForm019
       , @trgPrimaryForm020 = PrimaryForm020
       , @trgPrimaryForm021 = PrimaryForm021
       , @trgPrimaryForm022 = PrimaryForm022
       , @trgPrimaryForm023 = PrimaryForm023
       , @trgPrimaryForm024 = PrimaryForm024
       , @trgPrimaryForm025 = PrimaryForm025
       , @trgPrimaryForm026 = PrimaryForm026
       , @trgPrimaryForm027 = PrimaryForm027
       , @trgPrimaryForm028 = PrimaryForm028
       , @trgPrimaryForm029 = PrimaryForm029
       , @trgPrimaryForm030 = PrimaryForm030
       , @trgPrimaryForm031 = PrimaryForm031
       , @trgPrimaryForm032 = PrimaryForm032
       , @trgPrimaryForm033 = PrimaryForm033
       , @trgPrimaryForm034 = PrimaryForm034
       , @trgPrimaryForm035 = PrimaryForm035
       , @trgPrimaryForm036 = PrimaryForm036
       , @trgPrimaryForm037 = PrimaryForm037
       , @trgPrimaryForm038 = PrimaryForm038
       , @trgPrimaryForm039 = PrimaryForm039
       , @trgPrimaryForm040 = PrimaryForm040
       , @trgPrimaryForm041 = PrimaryForm041
       , @trgPrimaryForm042 = PrimaryForm042
       , @trgPrimaryForm043 = PrimaryForm043
       , @trgPrimaryForm044 = PrimaryForm044
       , @trgPrimaryForm045 = PrimaryForm045
       , @trgPrimaryForm046 = PrimaryForm046
       , @trgPrimaryForm047 = PrimaryForm047
       , @trgPrimaryForm048 = PrimaryForm048
       , @trgPrimaryForm049 = PrimaryForm049
       , @trgPrimaryForm050 = PrimaryForm050
       , @trgPrimaryForm051 = PrimaryForm051
       , @trgPrimaryForm052 = PrimaryForm052
       , @trgPrimaryForm053 = PrimaryForm053
       , @trgPrimaryForm054 = PrimaryForm054
       , @trgPrimaryForm055 = PrimaryForm055
       , @trgPrimaryForm056 = PrimaryForm056
       , @trgPrimaryForm057 = PrimaryForm057
       , @trgPrimaryForm058 = PrimaryForm058
       , @trgPrimaryForm059 = PrimaryForm059
       , @trgPrimaryForm060 = PrimaryForm060
       , @trgPrimaryForm061 = PrimaryForm061
       , @trgPrimaryForm062 = PrimaryForm062
       , @trgPrimaryForm063 = PrimaryForm063
       , @trgPrimaryForm064 = PrimaryForm064
       , @trgPrimaryForm065 = PrimaryForm065
       , @trgPrimaryForm066 = PrimaryForm066
       , @trgPrimaryForm067 = PrimaryForm067
       , @trgPrimaryForm068 = PrimaryForm068
       , @trgPrimaryForm069 = PrimaryForm069
       , @trgPrimaryForm070 = PrimaryForm070
       , @trgPrimaryForm071 = PrimaryForm071
       , @trgPrimaryForm072 = PrimaryForm072
       , @trgPrimaryForm073 = PrimaryForm073
       , @trgPrimaryForm074 = PrimaryForm074
       , @trgPrimaryForm075 = PrimaryForm075
       , @trgPrimaryForm076 = PrimaryForm076
       , @trgPrimaryForm077 = PrimaryForm077
       , @trgPrimaryForm078 = PrimaryForm078
       , @trgPrimaryForm079 = PrimaryForm079
       , @trgPrimaryForm080 = PrimaryForm080
       , @trgPrimaryForm081 = PrimaryForm081
       , @trgPrimaryForm082 = PrimaryForm082
       , @trgPrimaryForm083 = PrimaryForm083
       , @trgPrimaryForm084 = PrimaryForm084
       , @trgPrimaryForm085 = PrimaryForm085
       , @trgPrimaryForm086 = PrimaryForm086
       , @trgPrimaryForm087 = PrimaryForm087
       , @trgPrimaryForm088 = PrimaryForm088
       , @trgPrimaryForm089 = PrimaryForm089
       , @trgPrimaryForm090 = PrimaryForm090
       , @trgPrimaryForm091 = PrimaryForm091
       , @trgPrimaryForm092 = PrimaryForm092
       , @trgPrimaryForm093 = PrimaryForm093
       , @trgPrimaryForm094 = PrimaryForm094
       , @trgPrimaryForm095 = PrimaryForm095
       , @trgPrimaryForm096 = PrimaryForm096
       , @trgPrimaryForm097 = PrimaryForm097
       , @trgPrimaryForm098 = PrimaryForm098
       , @trgPrimaryForm099 = PrimaryForm099
       , @trgPrimaryForm100 = PrimaryForm100
       , @trgPrimaryForm101 = PrimaryForm101
       , @trgPrimaryForm102 = PrimaryForm102
       , @trgPrimaryForm103 = PrimaryForm103
       , @trgPrimaryForm104 = PrimaryForm104
       , @trgPrimaryForm105 = PrimaryForm105
       , @trgPrimaryForm106 = PrimaryForm106
       , @trgPrimaryForm107 = PrimaryForm107
       , @trgPrimaryForm108 = PrimaryForm108
       , @trgPrimaryForm109 = PrimaryForm109
       , @trgPrimaryForm110 = PrimaryForm110
       , @trgPrimaryForm111 = PrimaryForm111
       , @trgPrimaryForm112 = PrimaryForm112
       , @trgPrimaryForm113 = PrimaryForm113
       , @trgPrimaryForm114 = PrimaryForm114
       , @trgPrimaryForm115 = PrimaryForm115
       , @trgPrimaryForm116 = PrimaryForm116
       , @trgPrimaryForm117 = PrimaryForm117
       , @trgPrimaryForm118 = PrimaryForm118
       , @trgPrimaryForm119 = PrimaryForm119
       , @trgPrimaryForm120 = PrimaryForm120
       , @trgDescr = Descr
       , @trgModuleSec = ModuleSec
       , @trgGCR_triRates = GCR_triRates
       , @trgGCR_triEuro = GCR_triEuro
       , @trgGCR_triInvert = GCR_triInvert
       , @trgGCR_triFloat = GCR_triFloat
       , @trgVEDIMethod = VEDIMethod
       , @trgVVanMode = VVanMode
       , @trgVEDIFACT = VEDIFACT
       , @trgVVANCEId = VVANCEId
       , @trgVVANUId = VVANUId
       , @trgVUseCRLF = VUseCRLF
       , @trgVTestMode = VTestMode
       , @trgVDirPAth = VDirPAth
       , @trgVCompress = VCompress
       , @trgVCEEmail = VCEEmail
       , @trgVUEmail = VUEmail
       , @trgVEPriority = VEPriority
       , @trgVESubject = VESubject
       , @trgVSendEmail = VSendEmail
       , @trgVIEECSLP = VIEECSLP
       , @trgEmName = EmName
       , @trgEmAddress = EmAddress
       , @trgEmSMTP = EmSMTP
       , @trgEmPriority = EmPriority
       , @trgEmUseMAPI = EmUseMAPI
       , @trgFxUseMAPI = FxUseMAPI
       , @trgFaxPrnN = FaxPrnN
       , @trgEmailPrnN = EmailPrnN
       , @trgFxName = FxName
       , @trgFxPhone = FxPhone
       , @trgEmAttchMode = EmAttchMode
       , @trgFaxDLLPath = FaxDLLPath
       , @trgSpare = Spare
       , @trgFCaptions = FCaptions
       , @trgFHide = FHide
       , @trgCISConstructCode = CISConstructCode
       , @trgCISConstructDesc = CISConstructDesc
       , @trgCISConstructRate = CISConstructRate
       , @trgCISConstructGLCode = CISConstructGLCode
       , @trgCISConstructDepartment = CISConstructDepartment
       , @trgCISConstructCostCentre = CISConstructCostCentre
       , @trgCISConstructSpare = CISConstructSpare
       , @trgCISTechnicalCode = CISTechnicalCode
       , @trgCISTechnicalDesc = CISTechnicalDesc
       , @trgCISTechnicalRate = CISTechnicalRate
       , @trgCISTechnicalGLCode = CISTechnicalGLCode
       , @trgCISTechnicalDepartment = CISTechnicalDepartment
       , @trgCISTechnicalCostCentre = CISTechnicalCostCentre
       , @trgCISTechnicalSpare = CISTechnicalSpare
       , @trgCISRate1Code = CISRate1Code
       , @trgCISRate1Desc = CISRate1Desc
       , @trgCISRate1Rate = CISRate1Rate
       , @trgCISRate1GLCode = CISRate1GLCode
       , @trgCISRate1Department = CISRate1Department
       , @trgCISRate1CostCentre = CISRate1CostCentre
       , @trgCISRate1Spare = CISRate1Spare
       , @trgCISRate2Code = CISRate2Code
       , @trgCISRate2Desc = CISRate2Desc
       , @trgCISRate2Rate = CISRate2Rate
       , @trgCISRate2GLCode = CISRate2GLCode
       , @trgCISRate2Department = CISRate2Department
       , @trgCISRate2CostCentre = CISRate2CostCentre
       , @trgCISRate2Spare = CISRate2Spare
       , @trgCISRate3Code = CISRate3Code
       , @trgCISRate3Desc = CISRate3Desc
       , @trgCISRate3Rate = CISRate3Rate
       , @trgCISRate3GLCode = CISRate3GLCode
       , @trgCISRate3Department = CISRate3Department
       , @trgCISRate3CostCentre = CISRate3CostCentre
       , @trgCISRate3Spare = CISRate3Spare
       , @trgCISRate4Code = CISRate4Code
       , @trgCISRate4Desc = CISRate4Desc
       , @trgCISRate4Rate = CISRate4Rate
       , @trgCISRate4GLCode = CISRate4GLCode
       , @trgCISRate4Department = CISRate4Department
       , @trgCISRate4CostCentre = CISRate4CostCentre
       , @trgCISRate4Spare = CISRate4Spare
       , @trgCISRate5Code = CISRate5Code
       , @trgCISRate5Desc = CISRate5Desc
       , @trgCISRate5Rate = CISRate5Rate
       , @trgCISRate5GLCode = CISRate5GLCode
       , @trgCISRate5Department = CISRate5Department
       , @trgCISRate5CostCentre = CISRate5CostCentre
       , @trgCISRate5Spare = CISRate5Spare
       , @trgCISRate6Code = CISRate6Code
       , @trgCISRate6Desc = CISRate6Desc
       , @trgCISRate6Rate = CISRate6Rate
       , @trgCISRate6GLCode = CISRate6GLCode
       , @trgCISRate6Department = CISRate6Department
       , @trgCISRate6CostCentre = CISRate6CostCentre
       , @trgCISRate6Spare = CISRate6Spare
       , @trgCISRate7Code = CISRate7Code
       , @trgCISRate7Desc = CISRate7Desc
       , @trgCISRate7Rate = CISRate7Rate
       , @trgCISRate7GLCode = CISRate7GLCode
       , @trgCISRate7Department = CISRate7Department
       , @trgCISRate7CostCentre = CISRate7CostCentre
       , @trgCISRate7Spare = CISRate7Spare
       , @trgCISRate8Code = CISRate8Code
       , @trgCISRate8Desc = CISRate8Desc
       , @trgCISRate8Rate = CISRate8Rate
       , @trgCISRate8GLCode = CISRate8GLCode
       , @trgCISRate8Department = CISRate8Department
       , @trgCISRate8CostCentre = CISRate8CostCentre
       , @trgCISRate8Spare = CISRate8Spare
       , @trgCISRate9Code = CISRate9Code
       , @trgCISRate9Desc = CISRate9Desc
       , @trgCISRate9Rate = CISRate9Rate
       , @trgCISRate9GLCode = CISRate9GLCode
       , @trgCISRate9Department = CISRate9Department
       , @trgCISRate9CostCentre = CISRate9CostCentre
       , @trgCISRate9Spare = CISRate9Spare
       , @trgCISInterval = CISInterval
       , @trgCISAutoSetPr = CISAutoSetPr
       , @trgCISVATCode = CISVATCode
       , @trgCISSpare3 = CISSpare3
       , @trgCISScheme = CISScheme
       , @trgCISReturnDate = CISReturnDate
       , @trgCISCurrPeriod = CISCurrPeriod
       , @trgCISLoaded = CISLoaded
       , @trgCISTaxRef = CISTaxRef
       , @trgCISAggMode = CISAggMode
       , @trgCISSortMode = CISSortMode
       , @trgCISVFolio = CISVFolio
       , @trgCISVouchers = CISVouchers
       , @trgIVANMode = IVANMode
       , @trgIVANIRId = IVANIRId
       , @trgIVANUId = IVANUId
       , @trgIVANPw = IVANPw
       , @trgIIREDIRef = IIREDIRef
       , @trgIUseCRLF = IUseCRLF
       , @trgITestMode = ITestMode
       , @trgIDirPath = IDirPath
       , @trgIEDIMethod = IEDIMethod
       , @trgISendEmail = ISendEmail
       , @trgIEPriority = IEPriority
       , @trgJCertNo = JCertNo
       , @trgJCertExpiry = JCertExpiry
       , @trgJCISType = JCISType
       , @trgCISCNINO = CISCNINO
       , @trgCISCUTR = CISCUTR
       , @trgCISACCONo = CISACCONo
       , @trgIGWIRId = IGWIRId
       , @trgIGWUId = IGWUId
       , @trgIGWTO = IGWTO
       , @trgIGWIRef = IGWIRef
       , @trgIXMLDirPath = IXMLDirPath
       , @trgIXTestMode = IXTestMode
       , @trgIXConfEmp = IXConfEmp
       , @trgIXVerSub = IXVerSub
       , @trgIXNoPay = IXNoPay
       , @trgIGWTR = IGWTR
       , @trgIGSubType = IGSubType
  FROM Exch70Conv.MAIN01.ExchqSS
  WHERE IDCode = @srcIDCode

  -- Compare columns
  IF (@srcOpt <> @trgOpt) Or ((@srcOpt IS NULL) And (@trgOpt IS NOT NULL)) Or ((@srcOpt IS NOT NULL) And (@trgOpt IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.Opt = ' + @srcOpt + ' / ' + @trgOpt
  END
  IF (@srcOMonWk1 <> @trgOMonWk1) Or ((@srcOMonWk1 IS NULL) And (@trgOMonWk1 IS NOT NULL)) Or ((@srcOMonWk1 IS NOT NULL) And (@trgOMonWk1 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.OMonWk1 is different'
  END
  IF (@srcPrinYr <> @trgPrinYr) Or ((@srcPrinYr IS NULL) And (@trgPrinYr IS NOT NULL)) Or ((@srcPrinYr IS NOT NULL) And (@trgPrinYr IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrinYr = ' + STR(@srcPrinYr) + ' / ' + STR(@trgPrinYr)
  END
  IF (@srcFiltSNoBinLoc <> @trgFiltSNoBinLoc) Or ((@srcFiltSNoBinLoc IS NULL) And (@trgFiltSNoBinLoc IS NOT NULL)) Or ((@srcFiltSNoBinLoc IS NOT NULL) And (@trgFiltSNoBinLoc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.FiltSNoBinLoc = ' + STR(@srcFiltSNoBinLoc) + ' / ' + STR(@trgFiltSNoBinLoc)
  END
  IF (@srcKeepBinHist <> @trgKeepBinHist) Or ((@srcKeepBinHist IS NULL) And (@trgKeepBinHist IS NOT NULL)) Or ((@srcKeepBinHist IS NOT NULL) And (@trgKeepBinHist IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.KeepBinHist = ' + STR(@srcKeepBinHist) + ' / ' + STR(@trgKeepBinHist)
  END
  IF (@srcUseBKTheme <> @trgUseBKTheme) Or ((@srcUseBKTheme IS NULL) And (@trgUseBKTheme IS NOT NULL)) Or ((@srcUseBKTheme IS NOT NULL) And (@trgUseBKTheme IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UseBKTheme = ' + STR(@srcUseBKTheme) + ' / ' + STR(@trgUseBKTheme)
  END
  IF (@srcUserName <> @trgUserName) Or ((@srcUserName IS NULL) And (@trgUserName IS NOT NULL)) Or ((@srcUserName IS NOT NULL) And (@trgUserName IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UserName = ' + @srcUserName + ' / ' + @trgUserName
  END
  IF (@srcAuditYr <> @trgAuditYr) Or ((@srcAuditYr IS NULL) And (@trgAuditYr IS NOT NULL)) Or ((@srcAuditYr IS NOT NULL) And (@trgAuditYr IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AuditYr = ' + STR(@srcAuditYr) + ' / ' + STR(@trgAuditYr)
  END
  IF (@srcAuditPr <> @trgAuditPr) Or ((@srcAuditPr IS NULL) And (@trgAuditPr IS NOT NULL)) Or ((@srcAuditPr IS NOT NULL) And (@trgAuditPr IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AuditPr = ' + STR(@srcAuditPr) + ' / ' + STR(@trgAuditPr)
  END
  IF (@srcSpare6 <> @trgSpare6) Or ((@srcSpare6 IS NULL) And (@trgSpare6 IS NOT NULL)) Or ((@srcSpare6 IS NOT NULL) And (@trgSpare6 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.Spare6 = ' + STR(@srcSpare6) + ' / ' + STR(@trgSpare6)
  END
  IF (@srcManROCP <> @trgManROCP) Or ((@srcManROCP IS NULL) And (@trgManROCP IS NOT NULL)) Or ((@srcManROCP IS NOT NULL) And (@trgManROCP IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ManROCP = ' + STR(@srcManROCP) + ' / ' + STR(@trgManROCP)
  END
  IF (@srcVATCurr <> @trgVATCurr) Or ((@srcVATCurr IS NULL) And (@trgVATCurr IS NOT NULL)) Or ((@srcVATCurr IS NOT NULL) And (@trgVATCurr IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATCurr = ' + STR(@srcVATCurr) + ' / ' + STR(@trgVATCurr)
  END
  IF (@srcNoCosDec <> @trgNoCosDec) Or ((@srcNoCosDec IS NULL) And (@trgNoCosDec IS NOT NULL)) Or ((@srcNoCosDec IS NOT NULL) And (@trgNoCosDec IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NoCosDec = ' + STR(@srcNoCosDec) + ' / ' + STR(@trgNoCosDec)
  END
  IF (@srcCurrBase <> @trgCurrBase) Or ((@srcCurrBase IS NULL) And (@trgCurrBase IS NOT NULL)) Or ((@srcCurrBase IS NOT NULL) And (@trgCurrBase IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CurrBase = ' + STR(@srcCurrBase) + ' / ' + STR(@trgCurrBase)
  END
  IF (@srcMuteBeep <> @trgMuteBeep) Or ((@srcMuteBeep IS NULL) And (@trgMuteBeep IS NOT NULL)) Or ((@srcMuteBeep IS NOT NULL) And (@trgMuteBeep IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MuteBeep = ' + STR(@srcMuteBeep) + ' / ' + STR(@trgMuteBeep)
  END
  IF (@srcShowStkGP <> @trgShowStkGP) Or ((@srcShowStkGP IS NULL) And (@trgShowStkGP IS NOT NULL)) Or ((@srcShowStkGP IS NOT NULL) And (@trgShowStkGP IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ShowStkGP = ' + STR(@srcShowStkGP) + ' / ' + STR(@trgShowStkGP)
  END
  IF (@srcAutoValStk <> @trgAutoValStk) Or ((@srcAutoValStk IS NULL) And (@trgAutoValStk IS NOT NULL)) Or ((@srcAutoValStk IS NOT NULL) And (@trgAutoValStk IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AutoValStk = ' + STR(@srcAutoValStk) + ' / ' + STR(@trgAutoValStk)
  END
  IF (@srcDelPickOnly <> @trgDelPickOnly) Or ((@srcDelPickOnly IS NULL) And (@trgDelPickOnly IS NOT NULL)) Or ((@srcDelPickOnly IS NOT NULL) And (@trgDelPickOnly IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DelPickOnly = ' + STR(@srcDelPickOnly) + ' / ' + STR(@trgDelPickOnly)
  END
  IF (@srcUseMLoc <> @trgUseMLoc) Or ((@srcUseMLoc IS NULL) And (@trgUseMLoc IS NOT NULL)) Or ((@srcUseMLoc IS NOT NULL) And (@trgUseMLoc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UseMLoc = ' + STR(@srcUseMLoc) + ' / ' + STR(@trgUseMLoc)
  END
  IF (@srcEditSinSer <> @trgEditSinSer) Or ((@srcEditSinSer IS NULL) And (@trgEditSinSer IS NOT NULL)) Or ((@srcEditSinSer IS NOT NULL) And (@trgEditSinSer IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.EditSinSer = ' + STR(@srcEditSinSer) + ' / ' + STR(@trgEditSinSer)
  END
  IF (@srcWarnYRef <> @trgWarnYRef) Or ((@srcWarnYRef IS NULL) And (@trgWarnYRef IS NOT NULL)) Or ((@srcWarnYRef IS NOT NULL) And (@trgWarnYRef IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.WarnYRef = ' + STR(@srcWarnYRef) + ' / ' + STR(@trgWarnYRef)
  END
  IF (@srcUseLocDel <> @trgUseLocDel) Or ((@srcUseLocDel IS NULL) And (@trgUseLocDel IS NOT NULL)) Or ((@srcUseLocDel IS NOT NULL) And (@trgUseLocDel IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UseLocDel = ' + STR(@srcUseLocDel) + ' / ' + STR(@trgUseLocDel)
  END
  IF (@srcPostCCNom <> @trgPostCCNom) Or ((@srcPostCCNom IS NULL) And (@trgPostCCNom IS NOT NULL)) Or ((@srcPostCCNom IS NOT NULL) And (@trgPostCCNom IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PostCCNom = ' + STR(@srcPostCCNom) + ' / ' + STR(@trgPostCCNom)
  END
  IF (@srcAlTolVal <> @trgAlTolVal) Or ((@srcAlTolVal IS NULL) And (@trgAlTolVal IS NOT NULL)) Or ((@srcAlTolVal IS NOT NULL) And (@trgAlTolVal IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AlTolVal = ' + @srcAlTolVal + ' / ' + @trgAlTolVal
  END
  IF (@srcAlTolMode <> @trgAlTolMode) Or ((@srcAlTolMode IS NULL) And (@trgAlTolMode IS NOT NULL)) Or ((@srcAlTolMode IS NOT NULL) And (@trgAlTolMode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AlTolMode = ' + STR(@srcAlTolMode) + ' / ' + STR(@trgAlTolMode)
  END
  IF (@srcDebtLMode <> @trgDebtLMode) Or ((@srcDebtLMode IS NULL) And (@trgDebtLMode IS NOT NULL)) Or ((@srcDebtLMode IS NOT NULL) And (@trgDebtLMode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DebtLMode = ' + STR(@srcDebtLMode) + ' / ' + STR(@trgDebtLMode)
  END
  IF (@srcAutoGenVar <> @trgAutoGenVar) Or ((@srcAutoGenVar IS NULL) And (@trgAutoGenVar IS NOT NULL)) Or ((@srcAutoGenVar IS NOT NULL) And (@trgAutoGenVar IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AutoGenVar = ' + STR(@srcAutoGenVar) + ' / ' + STR(@trgAutoGenVar)
  END
  IF (@srcAutoGenDisc <> @trgAutoGenDisc) Or ((@srcAutoGenDisc IS NULL) And (@trgAutoGenDisc IS NOT NULL)) Or ((@srcAutoGenDisc IS NOT NULL) And (@trgAutoGenDisc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AutoGenDisc = ' + STR(@srcAutoGenDisc) + ' / ' + STR(@trgAutoGenDisc)
  END
  IF (@srcUseModuleSec <> @trgUseModuleSec) Or ((@srcUseModuleSec IS NULL) And (@trgUseModuleSec IS NOT NULL)) Or ((@srcUseModuleSec IS NOT NULL) And (@trgUseModuleSec IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UseModuleSec = ' + STR(@srcUseModuleSec) + ' / ' + STR(@trgUseModuleSec)
  END
  IF (@srcProtectPost <> @trgProtectPost) Or ((@srcProtectPost IS NULL) And (@trgProtectPost IS NOT NULL)) Or ((@srcProtectPost IS NOT NULL) And (@trgProtectPost IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ProtectPost = ' + STR(@srcProtectPost) + ' / ' + STR(@trgProtectPost)
  END
  IF (@srcUsePick4All <> @trgUsePick4All) Or ((@srcUsePick4All IS NULL) And (@trgUsePick4All IS NOT NULL)) Or ((@srcUsePick4All IS NOT NULL) And (@trgUsePick4All IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UsePick4All = ' + STR(@srcUsePick4All) + ' / ' + STR(@trgUsePick4All)
  END
  IF (@srcBigStkTree <> @trgBigStkTree) Or ((@srcBigStkTree IS NULL) And (@trgBigStkTree IS NOT NULL)) Or ((@srcBigStkTree IS NOT NULL) And (@trgBigStkTree IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.BigStkTree = ' + STR(@srcBigStkTree) + ' / ' + STR(@trgBigStkTree)
  END
  IF (@srcBigJobTree <> @trgBigJobTree) Or ((@srcBigJobTree IS NULL) And (@trgBigJobTree IS NOT NULL)) Or ((@srcBigJobTree IS NOT NULL) And (@trgBigJobTree IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.BigJobTree = ' + STR(@srcBigJobTree) + ' / ' + STR(@trgBigJobTree)
  END
  IF (@srcShowQtySTree <> @trgShowQtySTree) Or ((@srcShowQtySTree IS NULL) And (@trgShowQtySTree IS NOT NULL)) Or ((@srcShowQtySTree IS NOT NULL) And (@trgShowQtySTree IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ShowQtySTree = ' + STR(@srcShowQtySTree) + ' / ' + STR(@trgShowQtySTree)
  END
  IF (@srcProtectYRef <> @trgProtectYRef) Or ((@srcProtectYRef IS NULL) And (@trgProtectYRef IS NOT NULL)) Or ((@srcProtectYRef IS NOT NULL) And (@trgProtectYRef IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ProtectYRef = ' + STR(@srcProtectYRef) + ' / ' + STR(@trgProtectYRef)
  END
  IF (@srcPurchUIDate <> @trgPurchUIDate) Or ((@srcPurchUIDate IS NULL) And (@trgPurchUIDate IS NOT NULL)) Or ((@srcPurchUIDate IS NOT NULL) And (@trgPurchUIDate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PurchUIDate = ' + STR(@srcPurchUIDate) + ' / ' + STR(@trgPurchUIDate)
  END
  IF (@srcUseUpliftNC <> @trgUseUpliftNC) Or ((@srcUseUpliftNC IS NULL) And (@trgUseUpliftNC IS NOT NULL)) Or ((@srcUseUpliftNC IS NOT NULL) And (@trgUseUpliftNC IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UseUpliftNC = ' + STR(@srcUseUpliftNC) + ' / ' + STR(@trgUseUpliftNC)
  END
  IF (@srcUseWIss4All <> @trgUseWIss4All) Or ((@srcUseWIss4All IS NULL) And (@trgUseWIss4All IS NOT NULL)) Or ((@srcUseWIss4All IS NOT NULL) And (@trgUseWIss4All IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UseWIss4All = ' + STR(@srcUseWIss4All) + ' / ' + STR(@trgUseWIss4All)
  END
  IF (@srcUseSTDWOP <> @trgUseSTDWOP) Or ((@srcUseSTDWOP IS NULL) And (@trgUseSTDWOP IS NOT NULL)) Or ((@srcUseSTDWOP IS NOT NULL) And (@trgUseSTDWOP IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UseSTDWOP = ' + STR(@srcUseSTDWOP) + ' / ' + STR(@trgUseSTDWOP)
  END
  IF (@srcUseSalesAnal <> @trgUseSalesAnal) Or ((@srcUseSalesAnal IS NULL) And (@trgUseSalesAnal IS NOT NULL)) Or ((@srcUseSalesAnal IS NOT NULL) And (@trgUseSalesAnal IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UseSalesAnal = ' + STR(@srcUseSalesAnal) + ' / ' + STR(@trgUseSalesAnal)
  END
  IF (@srcPostCCDCombo <> @trgPostCCDCombo) Or ((@srcPostCCDCombo IS NULL) And (@trgPostCCDCombo IS NOT NULL)) Or ((@srcPostCCDCombo IS NOT NULL) And (@trgPostCCDCombo IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PostCCDCombo = ' + STR(@srcPostCCDCombo) + ' / ' + STR(@trgPostCCDCombo)
  END
  IF (@srcUseClassToolB <> @trgUseClassToolB) Or ((@srcUseClassToolB IS NULL) And (@trgUseClassToolB IS NOT NULL)) Or ((@srcUseClassToolB IS NOT NULL) And (@trgUseClassToolB IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UseClassToolB = ' + STR(@srcUseClassToolB) + ' / ' + STR(@trgUseClassToolB)
  END
  IF (@srcWOPStkCopMode <> @trgWOPStkCopMode) Or ((@srcWOPStkCopMode IS NULL) And (@trgWOPStkCopMode IS NOT NULL)) Or ((@srcWOPStkCopMode IS NOT NULL) And (@trgWOPStkCopMode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.WOPStkCopMode = ' + STR(@srcWOPStkCopMode) + ' / ' + STR(@trgWOPStkCopMode)
  END
  IF (@srcUSRCntryCode <> @trgUSRCntryCode) Or ((@srcUSRCntryCode IS NULL) And (@trgUSRCntryCode IS NOT NULL)) Or ((@srcUSRCntryCode IS NOT NULL) And (@trgUSRCntryCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.USRCntryCode = ' + @srcUSRCntryCode + ' / ' + @trgUSRCntryCode
  END
  IF (@srcNoNetDec <> @trgNoNetDec) Or ((@srcNoNetDec IS NULL) And (@trgNoNetDec IS NOT NULL)) Or ((@srcNoNetDec IS NOT NULL) And (@trgNoNetDec IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NoNetDec = ' + STR(@srcNoNetDec) + ' / ' + STR(@trgNoNetDec)
  END
  IF (@srcDebTrig <> @trgDebTrig) Or ((@srcDebTrig IS NULL) And (@trgDebTrig IS NOT NULL)) Or ((@srcDebTrig IS NOT NULL) And (@trgDebTrig IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DebTrig is different'
  END
  IF (@srcBKThemeNo <> @trgBKThemeNo) Or ((@srcBKThemeNo IS NULL) And (@trgBKThemeNo IS NOT NULL)) Or ((@srcBKThemeNo IS NOT NULL) And (@trgBKThemeNo IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.BKThemeNo = ' + STR(@srcBKThemeNo) + ' / ' + STR(@trgBKThemeNo)
  END
  IF (@srcUseGLClass <> @trgUseGLClass) Or ((@srcUseGLClass IS NULL) And (@trgUseGLClass IS NOT NULL)) Or ((@srcUseGLClass IS NOT NULL) And (@trgUseGLClass IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UseGLClass = ' + STR(@srcUseGLClass) + ' / ' + STR(@trgUseGLClass)
  END
  IF (@srcSpare4 <> @trgSpare4) Or ((@srcSpare4 IS NULL) And (@trgSpare4 IS NOT NULL)) Or ((@srcSpare4 IS NOT NULL) And (@trgSpare4 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.Spare4 is different'
  END
  IF (@srcNoInvLines <> @trgNoInvLines) Or ((@srcNoInvLines IS NULL) And (@trgNoInvLines IS NOT NULL)) Or ((@srcNoInvLines IS NOT NULL) And (@trgNoInvLines IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NoInvLines = ' + STR(@srcNoInvLines) + ' / ' + STR(@trgNoInvLines)
  END
  IF (@srcWksODue <> @trgWksODue) Or ((@srcWksODue IS NULL) And (@trgWksODue IS NOT NULL)) Or ((@srcWksODue IS NOT NULL) And (@trgWksODue IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.WksODue = ' + STR(@srcWksODue) + ' / ' + STR(@trgWksODue)
  END
  IF (@srcCPr <> @trgCPr) Or ((@srcCPr IS NULL) And (@trgCPr IS NOT NULL)) Or ((@srcCPr IS NOT NULL) And (@trgCPr IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CPr = ' + STR(@srcCPr) + ' / ' + STR(@trgCPr)
  END
  IF (@srcCYr <> @trgCYr) Or ((@srcCYr IS NULL) And (@trgCYr IS NOT NULL)) Or ((@srcCYr IS NOT NULL) And (@trgCYr IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CYr = ' + STR(@srcCYr) + ' / ' + STR(@trgCYr)
  END
  IF (@srcOAuditDate <> @trgOAuditDate) Or ((@srcOAuditDate IS NULL) And (@trgOAuditDate IS NOT NULL)) Or ((@srcOAuditDate IS NOT NULL) And (@trgOAuditDate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.OAuditDate = ' + @srcOAuditDate + ' / ' + @trgOAuditDate
  END
  IF (@srcTradeTerm <> @trgTradeTerm) Or ((@srcTradeTerm IS NULL) And (@trgTradeTerm IS NOT NULL)) Or ((@srcTradeTerm IS NOT NULL) And (@trgTradeTerm IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.TradeTerm = ' + STR(@srcTradeTerm) + ' / ' + STR(@trgTradeTerm)
  END
  IF (@srcStaSepCr <> @trgStaSepCr) Or ((@srcStaSepCr IS NULL) And (@trgStaSepCr IS NOT NULL)) Or ((@srcStaSepCr IS NOT NULL) And (@trgStaSepCr IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.StaSepCr = ' + STR(@srcStaSepCr) + ' / ' + STR(@trgStaSepCr)
  END
  IF (@srcStaAgeMthd <> @trgStaAgeMthd) Or ((@srcStaAgeMthd IS NULL) And (@trgStaAgeMthd IS NOT NULL)) Or ((@srcStaAgeMthd IS NOT NULL) And (@trgStaAgeMthd IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.StaAgeMthd = ' + STR(@srcStaAgeMthd) + ' / ' + STR(@trgStaAgeMthd)
  END
  IF (@srcStaUIDate <> @trgStaUIDate) Or ((@srcStaUIDate IS NULL) And (@trgStaUIDate IS NOT NULL)) Or ((@srcStaUIDate IS NOT NULL) And (@trgStaUIDate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.StaUIDate = ' + STR(@srcStaUIDate) + ' / ' + STR(@trgStaUIDate)
  END
  IF (@srcSepRunPost <> @trgSepRunPost) Or ((@srcSepRunPost IS NULL) And (@trgSepRunPost IS NOT NULL)) Or ((@srcSepRunPost IS NOT NULL) And (@trgSepRunPost IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SepRunPost = ' + STR(@srcSepRunPost) + ' / ' + STR(@trgSepRunPost)
  END
  IF (@srcQUAllocFlg <> @trgQUAllocFlg) Or ((@srcQUAllocFlg IS NULL) And (@trgQUAllocFlg IS NOT NULL)) Or ((@srcQUAllocFlg IS NOT NULL) And (@trgQUAllocFlg IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.QUAllocFlg = ' + STR(@srcQUAllocFlg) + ' / ' + STR(@trgQUAllocFlg)
  END
  IF (@srcDeadBOM <> @trgDeadBOM) Or ((@srcDeadBOM IS NULL) And (@trgDeadBOM IS NOT NULL)) Or ((@srcDeadBOM IS NOT NULL) And (@trgDeadBOM IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DeadBOM = ' + STR(@srcDeadBOM) + ' / ' + STR(@trgDeadBOM)
  END
  IF (@srcAuthMode <> @trgAuthMode) Or ((@srcAuthMode IS NULL) And (@trgAuthMode IS NOT NULL)) Or ((@srcAuthMode IS NOT NULL) And (@trgAuthMode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AuthMode = ' + @srcAuthMode + ' / ' + @trgAuthMode
  END
  IF (@srcIntraStat <> @trgIntraStat) Or ((@srcIntraStat IS NULL) And (@trgIntraStat IS NOT NULL)) Or ((@srcIntraStat IS NOT NULL) And (@trgIntraStat IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IntraStat = ' + STR(@srcIntraStat) + ' / ' + STR(@trgIntraStat)
  END
  IF (@srcAnalStkDesc <> @trgAnalStkDesc) Or ((@srcAnalStkDesc IS NULL) And (@trgAnalStkDesc IS NOT NULL)) Or ((@srcAnalStkDesc IS NOT NULL) And (@trgAnalStkDesc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AnalStkDesc = ' + STR(@srcAnalStkDesc) + ' / ' + STR(@trgAnalStkDesc)
  END
  IF (@srcAutoStkVal <> @trgAutoStkVal) Or ((@srcAutoStkVal IS NULL) And (@trgAutoStkVal IS NOT NULL)) Or ((@srcAutoStkVal IS NOT NULL) And (@trgAutoStkVal IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AutoStkVal = ' + @srcAutoStkVal + ' / ' + @trgAutoStkVal
  END
  IF (@srcAutoBillUp <> @trgAutoBillUp) Or ((@srcAutoBillUp IS NULL) And (@trgAutoBillUp IS NOT NULL)) Or ((@srcAutoBillUp IS NOT NULL) And (@trgAutoBillUp IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AutoBillUp = ' + STR(@srcAutoBillUp) + ' / ' + STR(@trgAutoBillUp)
  END
  IF (@srcAutoCQNo <> @trgAutoCQNo) Or ((@srcAutoCQNo IS NULL) And (@trgAutoCQNo IS NOT NULL)) Or ((@srcAutoCQNo IS NOT NULL) And (@trgAutoCQNo IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AutoCQNo = ' + STR(@srcAutoCQNo) + ' / ' + STR(@trgAutoCQNo)
  END
  IF (@srcIncNotDue <> @trgIncNotDue) Or ((@srcIncNotDue IS NULL) And (@trgIncNotDue IS NOT NULL)) Or ((@srcIncNotDue IS NOT NULL) And (@trgIncNotDue IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IncNotDue = ' + STR(@srcIncNotDue) + ' / ' + STR(@trgIncNotDue)
  END
  IF (@srcUseBatchTot <> @trgUseBatchTot) Or ((@srcUseBatchTot IS NULL) And (@trgUseBatchTot IS NOT NULL)) Or ((@srcUseBatchTot IS NOT NULL) And (@trgUseBatchTot IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UseBatchTot = ' + STR(@srcUseBatchTot) + ' / ' + STR(@trgUseBatchTot)
  END
  IF (@srcUseStock <> @trgUseStock) Or ((@srcUseStock IS NULL) And (@trgUseStock IS NOT NULL)) Or ((@srcUseStock IS NOT NULL) And (@trgUseStock IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UseStock = ' + STR(@srcUseStock) + ' / ' + STR(@trgUseStock)
  END
  IF (@srcAutoNotes <> @trgAutoNotes) Or ((@srcAutoNotes IS NULL) And (@trgAutoNotes IS NOT NULL)) Or ((@srcAutoNotes IS NOT NULL) And (@trgAutoNotes IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AutoNotes = ' + STR(@srcAutoNotes) + ' / ' + STR(@trgAutoNotes)
  END
  IF (@srcHideMenuOpt <> @trgHideMenuOpt) Or ((@srcHideMenuOpt IS NULL) And (@trgHideMenuOpt IS NOT NULL)) Or ((@srcHideMenuOpt IS NOT NULL) And (@trgHideMenuOpt IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.HideMenuOpt = ' + STR(@srcHideMenuOpt) + ' / ' + STR(@trgHideMenuOpt)
  END
  IF (@srcUseCCDep <> @trgUseCCDep) Or ((@srcUseCCDep IS NULL) And (@trgUseCCDep IS NOT NULL)) Or ((@srcUseCCDep IS NOT NULL) And (@trgUseCCDep IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UseCCDep = ' + STR(@srcUseCCDep) + ' / ' + STR(@trgUseCCDep)
  END
  IF (@srcNoHoldDisc <> @trgNoHoldDisc) Or ((@srcNoHoldDisc IS NULL) And (@trgNoHoldDisc IS NOT NULL)) Or ((@srcNoHoldDisc IS NOT NULL) And (@trgNoHoldDisc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NoHoldDisc = ' + STR(@srcNoHoldDisc) + ' / ' + STR(@trgNoHoldDisc)
  END
  IF (@srcAutoPrCalc <> @trgAutoPrCalc) Or ((@srcAutoPrCalc IS NULL) And (@trgAutoPrCalc IS NOT NULL)) Or ((@srcAutoPrCalc IS NOT NULL) And (@trgAutoPrCalc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AutoPrCalc = ' + STR(@srcAutoPrCalc) + ' / ' + STR(@trgAutoPrCalc)
  END
  IF (@srcStopBadDr <> @trgStopBadDr) Or ((@srcStopBadDr IS NULL) And (@trgStopBadDr IS NOT NULL)) Or ((@srcStopBadDr IS NOT NULL) And (@trgStopBadDr IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.StopBadDr = ' + STR(@srcStopBadDr) + ' / ' + STR(@trgStopBadDr)
  END
  IF (@srcUsePayIn <> @trgUsePayIn) Or ((@srcUsePayIn IS NULL) And (@trgUsePayIn IS NOT NULL)) Or ((@srcUsePayIn IS NOT NULL) And (@trgUsePayIn IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UsePayIn = ' + STR(@srcUsePayIn) + ' / ' + STR(@trgUsePayIn)
  END
  IF (@srcUsePasswords <> @trgUsePasswords) Or ((@srcUsePasswords IS NULL) And (@trgUsePasswords IS NOT NULL)) Or ((@srcUsePasswords IS NOT NULL) And (@trgUsePasswords IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UsePasswords = ' + STR(@srcUsePasswords) + ' / ' + STR(@trgUsePasswords)
  END
  IF (@srcPrintReciept <> @trgPrintReciept) Or ((@srcPrintReciept IS NULL) And (@trgPrintReciept IS NOT NULL)) Or ((@srcPrintReciept IS NOT NULL) And (@trgPrintReciept IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrintReciept = ' + STR(@srcPrintReciept) + ' / ' + STR(@trgPrintReciept)
  END
  IF (@srcExternCust <> @trgExternCust) Or ((@srcExternCust IS NULL) And (@trgExternCust IS NOT NULL)) Or ((@srcExternCust IS NOT NULL) And (@trgExternCust IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExternCust = ' + STR(@srcExternCust) + ' / ' + STR(@trgExternCust)
  END
  IF (@srcNoQtyDec <> @trgNoQtyDec) Or ((@srcNoQtyDec IS NULL) And (@trgNoQtyDec IS NOT NULL)) Or ((@srcNoQtyDec IS NOT NULL) And (@trgNoQtyDec IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NoQtyDec = ' + STR(@srcNoQtyDec) + ' / ' + STR(@trgNoQtyDec)
  END
  IF (@srcExternSIN <> @trgExternSIN) Or ((@srcExternSIN IS NULL) And (@trgExternSIN IS NOT NULL)) Or ((@srcExternSIN IS NOT NULL) And (@trgExternSIN IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExternSIN = ' + STR(@srcExternSIN) + ' / ' + STR(@trgExternSIN)
  END
  IF (@srcPrevPrOff <> @trgPrevPrOff) Or ((@srcPrevPrOff IS NULL) And (@trgPrevPrOff IS NOT NULL)) Or ((@srcPrevPrOff IS NOT NULL) And (@trgPrevPrOff IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrevPrOff = ' + STR(@srcPrevPrOff) + ' / ' + STR(@trgPrevPrOff)
  END
  IF (@srcDefPcDisc <> @trgDefPcDisc) Or ((@srcDefPcDisc IS NULL) And (@trgDefPcDisc IS NOT NULL)) Or ((@srcDefPcDisc IS NOT NULL) And (@trgDefPcDisc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DefPcDisc = ' + STR(@srcDefPcDisc) + ' / ' + STR(@trgDefPcDisc)
  END
  IF (@srcTradCodeNum <> @trgTradCodeNum) Or ((@srcTradCodeNum IS NULL) And (@trgTradCodeNum IS NOT NULL)) Or ((@srcTradCodeNum IS NOT NULL) And (@trgTradCodeNum IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.TradCodeNum = ' + STR(@srcTradCodeNum) + ' / ' + STR(@trgTradCodeNum)
  END
  IF (@srcUpBalOnPost <> @trgUpBalOnPost) Or ((@srcUpBalOnPost IS NULL) And (@trgUpBalOnPost IS NOT NULL)) Or ((@srcUpBalOnPost IS NOT NULL) And (@trgUpBalOnPost IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UpBalOnPost = ' + STR(@srcUpBalOnPost) + ' / ' + STR(@trgUpBalOnPost)
  END
  IF (@srcShowInvDisc <> @trgShowInvDisc) Or ((@srcShowInvDisc IS NULL) And (@trgShowInvDisc IS NOT NULL)) Or ((@srcShowInvDisc IS NOT NULL) And (@trgShowInvDisc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ShowInvDisc = ' + STR(@srcShowInvDisc) + ' / ' + STR(@trgShowInvDisc)
  END
  IF (@srcSepDiscounts <> @trgSepDiscounts) Or ((@srcSepDiscounts IS NULL) And (@trgSepDiscounts IS NOT NULL)) Or ((@srcSepDiscounts IS NOT NULL) And (@trgSepDiscounts IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SepDiscounts = ' + STR(@srcSepDiscounts) + ' / ' + STR(@trgSepDiscounts)
  END
  IF (@srcUseCreditChk <> @trgUseCreditChk) Or ((@srcUseCreditChk IS NULL) And (@trgUseCreditChk IS NOT NULL)) Or ((@srcUseCreditChk IS NOT NULL) And (@trgUseCreditChk IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UseCreditChk = ' + STR(@srcUseCreditChk) + ' / ' + STR(@trgUseCreditChk)
  END
  IF (@srcUseCRLimitChk <> @trgUseCRLimitChk) Or ((@srcUseCRLimitChk IS NULL) And (@trgUseCRLimitChk IS NOT NULL)) Or ((@srcUseCRLimitChk IS NOT NULL) And (@trgUseCRLimitChk IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UseCRLimitChk = ' + STR(@srcUseCRLimitChk) + ' / ' + STR(@trgUseCRLimitChk)
  END
  IF (@srcAutoClearPay <> @trgAutoClearPay) Or ((@srcAutoClearPay IS NULL) And (@trgAutoClearPay IS NOT NULL)) Or ((@srcAutoClearPay IS NOT NULL) And (@trgAutoClearPay IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AutoClearPay = ' + STR(@srcAutoClearPay) + ' / ' + STR(@trgAutoClearPay)
  END
  IF (@srcTotalConv <> @trgTotalConv) Or ((@srcTotalConv IS NULL) And (@trgTotalConv IS NOT NULL)) Or ((@srcTotalConv IS NOT NULL) And (@trgTotalConv IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.TotalConv = ' + @srcTotalConv + ' / ' + @trgTotalConv
  END
  IF (@srcDispPrAsMonths <> @trgDispPrAsMonths) Or ((@srcDispPrAsMonths IS NULL) And (@trgDispPrAsMonths IS NOT NULL)) Or ((@srcDispPrAsMonths IS NOT NULL) And (@trgDispPrAsMonths IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DispPrAsMonths = ' + STR(@srcDispPrAsMonths) + ' / ' + STR(@trgDispPrAsMonths)
  END
  IF (@srcNomCtrlInVAT <> @trgNomCtrlInVAT) Or ((@srcNomCtrlInVAT IS NULL) And (@trgNomCtrlInVAT IS NOT NULL)) Or ((@srcNomCtrlInVAT IS NOT NULL) And (@trgNomCtrlInVAT IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlInVAT = ' + STR(@srcNomCtrlInVAT) + ' / ' + STR(@trgNomCtrlInVAT)
  END
  IF (@srcNomCtrlOutVAT <> @trgNomCtrlOutVAT) Or ((@srcNomCtrlOutVAT IS NULL) And (@trgNomCtrlOutVAT IS NOT NULL)) Or ((@srcNomCtrlOutVAT IS NOT NULL) And (@trgNomCtrlOutVAT IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlOutVAT = ' + STR(@srcNomCtrlOutVAT) + ' / ' + STR(@trgNomCtrlOutVAT)
  END
  IF (@srcNomCtrlDebtors <> @trgNomCtrlDebtors) Or ((@srcNomCtrlDebtors IS NULL) And (@trgNomCtrlDebtors IS NOT NULL)) Or ((@srcNomCtrlDebtors IS NOT NULL) And (@trgNomCtrlDebtors IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlDebtors = ' + STR(@srcNomCtrlDebtors) + ' / ' + STR(@trgNomCtrlDebtors)
  END
  IF (@srcNomCtrlCreditors <> @trgNomCtrlCreditors) Or ((@srcNomCtrlCreditors IS NULL) And (@trgNomCtrlCreditors IS NOT NULL)) Or ((@srcNomCtrlCreditors IS NOT NULL) And (@trgNomCtrlCreditors IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlCreditors = ' + STR(@srcNomCtrlCreditors) + ' / ' + STR(@trgNomCtrlCreditors)
  END
  IF (@srcNomCtrlDiscountGiven <> @trgNomCtrlDiscountGiven) Or ((@srcNomCtrlDiscountGiven IS NULL) And (@trgNomCtrlDiscountGiven IS NOT NULL)) Or ((@srcNomCtrlDiscountGiven IS NOT NULL) And (@trgNomCtrlDiscountGiven IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlDiscountGiven = ' + STR(@srcNomCtrlDiscountGiven) + ' / ' + STR(@trgNomCtrlDiscountGiven)
  END
  IF (@srcNomCtrlDiscountTaken <> @trgNomCtrlDiscountTaken) Or ((@srcNomCtrlDiscountTaken IS NULL) And (@trgNomCtrlDiscountTaken IS NOT NULL)) Or ((@srcNomCtrlDiscountTaken IS NOT NULL) And (@trgNomCtrlDiscountTaken IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlDiscountTaken = ' + STR(@srcNomCtrlDiscountTaken) + ' / ' + STR(@trgNomCtrlDiscountTaken)
  END
  IF (@srcNomCtrlLDiscGiven <> @trgNomCtrlLDiscGiven) Or ((@srcNomCtrlLDiscGiven IS NULL) And (@trgNomCtrlLDiscGiven IS NOT NULL)) Or ((@srcNomCtrlLDiscGiven IS NOT NULL) And (@trgNomCtrlLDiscGiven IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlLDiscGiven = ' + STR(@srcNomCtrlLDiscGiven) + ' / ' + STR(@trgNomCtrlLDiscGiven)
  END
  IF (@srcNomCtrlLDiscTaken <> @trgNomCtrlLDiscTaken) Or ((@srcNomCtrlLDiscTaken IS NULL) And (@trgNomCtrlLDiscTaken IS NOT NULL)) Or ((@srcNomCtrlLDiscTaken IS NOT NULL) And (@trgNomCtrlLDiscTaken IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlLDiscTaken = ' + STR(@srcNomCtrlLDiscTaken) + ' / ' + STR(@trgNomCtrlLDiscTaken)
  END
  IF (@srcNomCtrlProfitBF <> @trgNomCtrlProfitBF) Or ((@srcNomCtrlProfitBF IS NULL) And (@trgNomCtrlProfitBF IS NOT NULL)) Or ((@srcNomCtrlProfitBF IS NOT NULL) And (@trgNomCtrlProfitBF IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlProfitBF = ' + STR(@srcNomCtrlProfitBF) + ' / ' + STR(@trgNomCtrlProfitBF)
  END
  IF (@srcNomCtrlCurrVar <> @trgNomCtrlCurrVar) Or ((@srcNomCtrlCurrVar IS NULL) And (@trgNomCtrlCurrVar IS NOT NULL)) Or ((@srcNomCtrlCurrVar IS NOT NULL) And (@trgNomCtrlCurrVar IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlCurrVar = ' + STR(@srcNomCtrlCurrVar) + ' / ' + STR(@trgNomCtrlCurrVar)
  END
  IF (@srcNomCtrlUnRCurrVar <> @trgNomCtrlUnRCurrVar) Or ((@srcNomCtrlUnRCurrVar IS NULL) And (@trgNomCtrlUnRCurrVar IS NOT NULL)) Or ((@srcNomCtrlUnRCurrVar IS NOT NULL) And (@trgNomCtrlUnRCurrVar IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlUnRCurrVar = ' + STR(@srcNomCtrlUnRCurrVar) + ' / ' + STR(@trgNomCtrlUnRCurrVar)
  END
  IF (@srcNomCtrlPLStart <> @trgNomCtrlPLStart) Or ((@srcNomCtrlPLStart IS NULL) And (@trgNomCtrlPLStart IS NOT NULL)) Or ((@srcNomCtrlPLStart IS NOT NULL) And (@trgNomCtrlPLStart IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlPLStart = ' + STR(@srcNomCtrlPLStart) + ' / ' + STR(@trgNomCtrlPLStart)
  END
  IF (@srcNomCtrlPLEnd <> @trgNomCtrlPLEnd) Or ((@srcNomCtrlPLEnd IS NULL) And (@trgNomCtrlPLEnd IS NOT NULL)) Or ((@srcNomCtrlPLEnd IS NOT NULL) And (@trgNomCtrlPLEnd IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlPLEnd = ' + STR(@srcNomCtrlPLEnd) + ' / ' + STR(@trgNomCtrlPLEnd)
  END
  IF (@srcNomCtrlFreightNC <> @trgNomCtrlFreightNC) Or ((@srcNomCtrlFreightNC IS NULL) And (@trgNomCtrlFreightNC IS NOT NULL)) Or ((@srcNomCtrlFreightNC IS NOT NULL) And (@trgNomCtrlFreightNC IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlFreightNC = ' + STR(@srcNomCtrlFreightNC) + ' / ' + STR(@trgNomCtrlFreightNC)
  END
  IF (@srcNomCtrlSalesComm <> @trgNomCtrlSalesComm) Or ((@srcNomCtrlSalesComm IS NULL) And (@trgNomCtrlSalesComm IS NOT NULL)) Or ((@srcNomCtrlSalesComm IS NOT NULL) And (@trgNomCtrlSalesComm IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlSalesComm = ' + STR(@srcNomCtrlSalesComm) + ' / ' + STR(@trgNomCtrlSalesComm)
  END
  IF (@srcNomCtrlPurchComm <> @trgNomCtrlPurchComm) Or ((@srcNomCtrlPurchComm IS NULL) And (@trgNomCtrlPurchComm IS NOT NULL)) Or ((@srcNomCtrlPurchComm IS NOT NULL) And (@trgNomCtrlPurchComm IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlPurchComm = ' + STR(@srcNomCtrlPurchComm) + ' / ' + STR(@trgNomCtrlPurchComm)
  END
  IF (@srcNomCtrlRetSurcharge <> @trgNomCtrlRetSurcharge) Or ((@srcNomCtrlRetSurcharge IS NULL) And (@trgNomCtrlRetSurcharge IS NOT NULL)) Or ((@srcNomCtrlRetSurcharge IS NOT NULL) And (@trgNomCtrlRetSurcharge IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlRetSurcharge = ' + STR(@srcNomCtrlRetSurcharge) + ' / ' + STR(@trgNomCtrlRetSurcharge)
  END
  IF (@srcNomCtrlSpare8 <> @trgNomCtrlSpare8) Or ((@srcNomCtrlSpare8 IS NULL) And (@trgNomCtrlSpare8 IS NOT NULL)) Or ((@srcNomCtrlSpare8 IS NOT NULL) And (@trgNomCtrlSpare8 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlSpare8 = ' + STR(@srcNomCtrlSpare8) + ' / ' + STR(@trgNomCtrlSpare8)
  END
  IF (@srcNomCtrlSpare9 <> @trgNomCtrlSpare9) Or ((@srcNomCtrlSpare9 IS NULL) And (@trgNomCtrlSpare9 IS NOT NULL)) Or ((@srcNomCtrlSpare9 IS NOT NULL) And (@trgNomCtrlSpare9 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlSpare9 = ' + STR(@srcNomCtrlSpare9) + ' / ' + STR(@trgNomCtrlSpare9)
  END
  IF (@srcNomCtrlSpare10 <> @trgNomCtrlSpare10) Or ((@srcNomCtrlSpare10 IS NULL) And (@trgNomCtrlSpare10 IS NOT NULL)) Or ((@srcNomCtrlSpare10 IS NOT NULL) And (@trgNomCtrlSpare10 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlSpare10 = ' + STR(@srcNomCtrlSpare10) + ' / ' + STR(@trgNomCtrlSpare10)
  END
  IF (@srcNomCtrlSpare11 <> @trgNomCtrlSpare11) Or ((@srcNomCtrlSpare11 IS NULL) And (@trgNomCtrlSpare11 IS NOT NULL)) Or ((@srcNomCtrlSpare11 IS NOT NULL) And (@trgNomCtrlSpare11 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlSpare11 = ' + STR(@srcNomCtrlSpare11) + ' / ' + STR(@trgNomCtrlSpare11)
  END
  IF (@srcNomCtrlSpare12 <> @trgNomCtrlSpare12) Or ((@srcNomCtrlSpare12 IS NULL) And (@trgNomCtrlSpare12 IS NOT NULL)) Or ((@srcNomCtrlSpare12 IS NOT NULL) And (@trgNomCtrlSpare12 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlSpare12 = ' + STR(@srcNomCtrlSpare12) + ' / ' + STR(@trgNomCtrlSpare12)
  END
  IF (@srcNomCtrlSpare13 <> @trgNomCtrlSpare13) Or ((@srcNomCtrlSpare13 IS NULL) And (@trgNomCtrlSpare13 IS NOT NULL)) Or ((@srcNomCtrlSpare13 IS NOT NULL) And (@trgNomCtrlSpare13 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlSpare13 = ' + STR(@srcNomCtrlSpare13) + ' / ' + STR(@trgNomCtrlSpare13)
  END
  IF (@srcNomCtrlSpare14 <> @trgNomCtrlSpare14) Or ((@srcNomCtrlSpare14 IS NULL) And (@trgNomCtrlSpare14 IS NOT NULL)) Or ((@srcNomCtrlSpare14 IS NOT NULL) And (@trgNomCtrlSpare14 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomCtrlSpare14 = ' + STR(@srcNomCtrlSpare14) + ' / ' + STR(@trgNomCtrlSpare14)
  END
  IF (@srcDetailAddr1 <> @trgDetailAddr1) Or ((@srcDetailAddr1 IS NULL) And (@trgDetailAddr1 IS NOT NULL)) Or ((@srcDetailAddr1 IS NOT NULL) And (@trgDetailAddr1 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DetailAddr1 = ' + @srcDetailAddr1 + ' / ' + @trgDetailAddr1
  END
  IF (@srcDetailAddr2 <> @trgDetailAddr2) Or ((@srcDetailAddr2 IS NULL) And (@trgDetailAddr2 IS NOT NULL)) Or ((@srcDetailAddr2 IS NOT NULL) And (@trgDetailAddr2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DetailAddr2 = ' + @srcDetailAddr2 + ' / ' + @trgDetailAddr2
  END
  IF (@srcDetailAddr3 <> @trgDetailAddr3) Or ((@srcDetailAddr3 IS NULL) And (@trgDetailAddr3 IS NOT NULL)) Or ((@srcDetailAddr3 IS NOT NULL) And (@trgDetailAddr3 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DetailAddr3 = ' + @srcDetailAddr3 + ' / ' + @trgDetailAddr3
  END
  IF (@srcDetailAddr4 <> @trgDetailAddr4) Or ((@srcDetailAddr4 IS NULL) And (@trgDetailAddr4 IS NOT NULL)) Or ((@srcDetailAddr4 IS NOT NULL) And (@trgDetailAddr4 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DetailAddr4 = ' + @srcDetailAddr4 + ' / ' + @trgDetailAddr4
  END
  IF (@srcDetailAddr5 <> @trgDetailAddr5) Or ((@srcDetailAddr5 IS NULL) And (@trgDetailAddr5 IS NOT NULL)) Or ((@srcDetailAddr5 IS NOT NULL) And (@trgDetailAddr5 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DetailAddr5 = ' + @srcDetailAddr5 + ' / ' + @trgDetailAddr5
  END
  IF (@srcDirectCust <> @trgDirectCust) Or ((@srcDirectCust IS NULL) And (@trgDirectCust IS NOT NULL)) Or ((@srcDirectCust IS NOT NULL) And (@trgDirectCust IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DirectCust = ' + @srcDirectCust + ' / ' + @trgDirectCust
  END
  IF (@srcDirectSupp <> @trgDirectSupp) Or ((@srcDirectSupp IS NULL) And (@trgDirectSupp IS NOT NULL)) Or ((@srcDirectSupp IS NOT NULL) And (@trgDirectSupp IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DirectSupp = ' + @srcDirectSupp + ' / ' + @trgDirectSupp
  END
  IF (@srcTermsofTrade1 <> @trgTermsofTrade1) Or ((@srcTermsofTrade1 IS NULL) And (@trgTermsofTrade1 IS NOT NULL)) Or ((@srcTermsofTrade1 IS NOT NULL) And (@trgTermsofTrade1 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.TermsofTrade1 = ' + @srcTermsofTrade1 + ' / ' + @trgTermsofTrade1
  END
  IF (@srcTermsofTrade2 <> @trgTermsofTrade2) Or ((@srcTermsofTrade2 IS NULL) And (@trgTermsofTrade2 IS NOT NULL)) Or ((@srcTermsofTrade2 IS NOT NULL) And (@trgTermsofTrade2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.TermsofTrade2 = ' + @srcTermsofTrade2 + ' / ' + @trgTermsofTrade2
  END
  IF (@srcNomPayFrom <> @trgNomPayFrom) Or ((@srcNomPayFrom IS NULL) And (@trgNomPayFrom IS NOT NULL)) Or ((@srcNomPayFrom IS NOT NULL) And (@trgNomPayFrom IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomPayFrom = ' + STR(@srcNomPayFrom) + ' / ' + STR(@trgNomPayFrom)
  END
  IF (@srcNomPayToo <> @trgNomPayToo) Or ((@srcNomPayToo IS NULL) And (@trgNomPayToo IS NOT NULL)) Or ((@srcNomPayToo IS NOT NULL) And (@trgNomPayToo IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NomPayToo = ' + STR(@srcNomPayToo) + ' / ' + STR(@trgNomPayToo)
  END
  IF (@srcSettleDisc <> @trgSettleDisc) Or ((@srcSettleDisc IS NULL) And (@trgSettleDisc IS NOT NULL)) Or ((@srcSettleDisc IS NOT NULL) And (@trgSettleDisc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SettleDisc = ' + @srcSettleDisc + ' / ' + @trgSettleDisc
  END
  IF (@srcSettleDays <> @trgSettleDays) Or ((@srcSettleDays IS NULL) And (@trgSettleDays IS NOT NULL)) Or ((@srcSettleDays IS NOT NULL) And (@trgSettleDays IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SettleDays = ' + STR(@srcSettleDays) + ' / ' + STR(@trgSettleDays)
  END
  IF (@srcNeedBMUp <> @trgNeedBMUp) Or ((@srcNeedBMUp IS NULL) And (@trgNeedBMUp IS NOT NULL)) Or ((@srcNeedBMUp IS NOT NULL) And (@trgNeedBMUp IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.NeedBMUp = ' + STR(@srcNeedBMUp) + ' / ' + STR(@trgNeedBMUp)
  END
  IF (@srcIgnoreBDPW <> @trgIgnoreBDPW) Or ((@srcIgnoreBDPW IS NULL) And (@trgIgnoreBDPW IS NOT NULL)) Or ((@srcIgnoreBDPW IS NOT NULL) And (@trgIgnoreBDPW IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IgnoreBDPW = ' + STR(@srcIgnoreBDPW) + ' / ' + STR(@trgIgnoreBDPW)
  END
  IF (@srcInpPack <> @trgInpPack) Or ((@srcInpPack IS NULL) And (@trgInpPack IS NOT NULL)) Or ((@srcInpPack IS NOT NULL) And (@trgInpPack IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.InpPack = ' + STR(@srcInpPack) + ' / ' + STR(@trgInpPack)
  END
  IF (@srcSpare32 <> @trgSpare32) Or ((@srcSpare32 IS NULL) And (@trgSpare32 IS NOT NULL)) Or ((@srcSpare32 IS NOT NULL) And (@trgSpare32 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.Spare32 = ' + STR(@srcSpare32) + ' / ' + STR(@trgSpare32)
  END
  IF (@srcVATCode <> @trgVATCode) Or ((@srcVATCode IS NULL) And (@trgVATCode IS NOT NULL)) Or ((@srcVATCode IS NOT NULL) And (@trgVATCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATCode = ' + @srcVATCode + ' / ' + @trgVATCode
  END
  IF (@srcPayTerms <> @trgPayTerms) Or ((@srcPayTerms IS NULL) And (@trgPayTerms IS NOT NULL)) Or ((@srcPayTerms IS NOT NULL) And (@trgPayTerms IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PayTerms = ' + STR(@srcPayTerms) + ' / ' + STR(@trgPayTerms)
  END
  IF (@srcOTrigDate <> @trgOTrigDate) Or ((@srcOTrigDate IS NULL) And (@trgOTrigDate IS NOT NULL)) Or ((@srcOTrigDate IS NOT NULL) And (@trgOTrigDate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.OTrigDate = ' + @srcOTrigDate + ' / ' + @trgOTrigDate
  END
  IF (@srcStaAgeInt <> @trgStaAgeInt) Or ((@srcStaAgeInt IS NULL) And (@trgStaAgeInt IS NOT NULL)) Or ((@srcStaAgeInt IS NOT NULL) And (@trgStaAgeInt IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.StaAgeInt = ' + STR(@srcStaAgeInt) + ' / ' + STR(@trgStaAgeInt)
  END
  IF (@srcQuoOwnDate <> @trgQuoOwnDate) Or ((@srcQuoOwnDate IS NULL) And (@trgQuoOwnDate IS NOT NULL)) Or ((@srcQuoOwnDate IS NOT NULL) And (@trgQuoOwnDate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.QuoOwnDate = ' + STR(@srcQuoOwnDate) + ' / ' + STR(@trgQuoOwnDate)
  END
  IF (@srcFreeExAll <> @trgFreeExAll) Or ((@srcFreeExAll IS NULL) And (@trgFreeExAll IS NOT NULL)) Or ((@srcFreeExAll IS NOT NULL) And (@trgFreeExAll IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.FreeExAll = ' + STR(@srcFreeExAll) + ' / ' + STR(@trgFreeExAll)
  END
  IF (@srcDirOwnCount <> @trgDirOwnCount) Or ((@srcDirOwnCount IS NULL) And (@trgDirOwnCount IS NOT NULL)) Or ((@srcDirOwnCount IS NOT NULL) And (@trgDirOwnCount IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DirOwnCount = ' + STR(@srcDirOwnCount) + ' / ' + STR(@trgDirOwnCount)
  END
  IF (@srcStaShowOS <> @trgStaShowOS) Or ((@srcStaShowOS IS NULL) And (@trgStaShowOS IS NOT NULL)) Or ((@srcStaShowOS IS NOT NULL) And (@trgStaShowOS IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.StaShowOS = ' + STR(@srcStaShowOS) + ' / ' + STR(@trgStaShowOS)
  END
  IF (@srcLiveCredS <> @trgLiveCredS) Or ((@srcLiveCredS IS NULL) And (@trgLiveCredS IS NOT NULL)) Or ((@srcLiveCredS IS NOT NULL) And (@trgLiveCredS IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.LiveCredS = ' + STR(@srcLiveCredS) + ' / ' + STR(@trgLiveCredS)
  END
  IF (@srcBatchPPY <> @trgBatchPPY) Or ((@srcBatchPPY IS NULL) And (@trgBatchPPY IS NOT NULL)) Or ((@srcBatchPPY IS NOT NULL) And (@trgBatchPPY IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.BatchPPY = ' + STR(@srcBatchPPY) + ' / ' + STR(@trgBatchPPY)
  END
  IF (@srcWarnJC <> @trgWarnJC) Or ((@srcWarnJC IS NULL) And (@trgWarnJC IS NOT NULL)) Or ((@srcWarnJC IS NOT NULL) And (@trgWarnJC IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.WarnJC = ' + STR(@srcWarnJC) + ' / ' + STR(@trgWarnJC)
  END
  IF (@srcTxLateCR <> @trgTxLateCR) Or ((@srcTxLateCR IS NULL) And (@trgTxLateCR IS NOT NULL)) Or ((@srcTxLateCR IS NOT NULL) And (@trgTxLateCR IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.TxLateCR = ' + STR(@srcTxLateCR) + ' / ' + STR(@trgTxLateCR)
  END
  IF (@srcConsvMem <> @trgConsvMem) Or ((@srcConsvMem IS NULL) And (@trgConsvMem IS NOT NULL)) Or ((@srcConsvMem IS NOT NULL) And (@trgConsvMem IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ConsvMem = ' + STR(@srcConsvMem) + ' / ' + STR(@trgConsvMem)
  END
  IF (@srcDefBankNom <> @trgDefBankNom) Or ((@srcDefBankNom IS NULL) And (@trgDefBankNom IS NOT NULL)) Or ((@srcDefBankNom IS NOT NULL) And (@trgDefBankNom IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DefBankNom = ' + STR(@srcDefBankNom) + ' / ' + STR(@trgDefBankNom)
  END
  IF (@srcUseDefBank <> @trgUseDefBank) Or ((@srcUseDefBank IS NULL) And (@trgUseDefBank IS NOT NULL)) Or ((@srcUseDefBank IS NOT NULL) And (@trgUseDefBank IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UseDefBank = ' + STR(@srcUseDefBank) + ' / ' + STR(@trgUseDefBank)
  END
  IF (@srcHideExLogo <> @trgHideExLogo) Or ((@srcHideExLogo IS NULL) And (@trgHideExLogo IS NOT NULL)) Or ((@srcHideExLogo IS NOT NULL) And (@trgHideExLogo IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.HideExLogo = ' + STR(@srcHideExLogo) + ' / ' + STR(@trgHideExLogo)
  END
  IF (@srcAMMThread <> @trgAMMThread) Or ((@srcAMMThread IS NULL) And (@trgAMMThread IS NOT NULL)) Or ((@srcAMMThread IS NOT NULL) And (@trgAMMThread IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AMMThread = ' + STR(@srcAMMThread) + ' / ' + STR(@trgAMMThread)
  END
  IF (@srcAMMPreview1 <> @trgAMMPreview1) Or ((@srcAMMPreview1 IS NULL) And (@trgAMMPreview1 IS NOT NULL)) Or ((@srcAMMPreview1 IS NOT NULL) And (@trgAMMPreview1 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AMMPreview1 = ' + STR(@srcAMMPreview1) + ' / ' + STR(@trgAMMPreview1)
  END
  IF (@srcAMMPreview2 <> @trgAMMPreview2) Or ((@srcAMMPreview2 IS NULL) And (@trgAMMPreview2 IS NOT NULL)) Or ((@srcAMMPreview2 IS NOT NULL) And (@trgAMMPreview2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AMMPreview2 = ' + STR(@srcAMMPreview2) + ' / ' + STR(@trgAMMPreview2)
  END
  IF (@srcEntULogCount <> @trgEntULogCount) Or ((@srcEntULogCount IS NULL) And (@trgEntULogCount IS NOT NULL)) Or ((@srcEntULogCount IS NOT NULL) And (@trgEntULogCount IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.EntULogCount = ' + STR(@srcEntULogCount) + ' / ' + STR(@trgEntULogCount)
  END
  IF (@srcDefSRCBankNom <> @trgDefSRCBankNom) Or ((@srcDefSRCBankNom IS NULL) And (@trgDefSRCBankNom IS NOT NULL)) Or ((@srcDefSRCBankNom IS NOT NULL) And (@trgDefSRCBankNom IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DefSRCBankNom = ' + STR(@srcDefSRCBankNom) + ' / ' + STR(@trgDefSRCBankNom)
  END
  IF (@srcSDNOwnDate <> @trgSDNOwnDate) Or ((@srcSDNOwnDate IS NULL) And (@trgSDNOwnDate IS NOT NULL)) Or ((@srcSDNOwnDate IS NOT NULL) And (@trgSDNOwnDate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SDNOwnDate = ' + STR(@srcSDNOwnDate) + ' / ' + STR(@trgSDNOwnDate)
  END
  IF (@srcEXISN <> @trgEXISN) Or ((@srcEXISN IS NULL) And (@trgEXISN IS NOT NULL)) Or ((@srcEXISN IS NOT NULL) And (@trgEXISN IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.EXISN is different'
  END
  IF (@srcExDemoVer <> @trgExDemoVer) Or ((@srcExDemoVer IS NULL) And (@trgExDemoVer IS NOT NULL)) Or ((@srcExDemoVer IS NOT NULL) And (@trgExDemoVer IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExDemoVer = ' + STR(@srcExDemoVer) + ' / ' + STR(@trgExDemoVer)
  END
  IF (@srcDupliVSec <> @trgDupliVSec) Or ((@srcDupliVSec IS NULL) And (@trgDupliVSec IS NOT NULL)) Or ((@srcDupliVSec IS NOT NULL) And (@trgDupliVSec IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DupliVSec = ' + STR(@srcDupliVSec) + ' / ' + STR(@trgDupliVSec)
  END
  IF (@srcLastDaily <> @trgLastDaily) Or ((@srcLastDaily IS NULL) And (@trgLastDaily IS NOT NULL)) Or ((@srcLastDaily IS NOT NULL) And (@trgLastDaily IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.LastDaily = ' + STR(@srcLastDaily) + ' / ' + STR(@trgLastDaily)
  END
  IF (@srcUserSort <> @trgUserSort) Or ((@srcUserSort IS NULL) And (@trgUserSort IS NOT NULL)) Or ((@srcUserSort IS NOT NULL) And (@trgUserSort IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UserSort = ' + @srcUserSort + ' / ' + @trgUserSort
  END
  IF (@srcUserAcc <> @trgUserAcc) Or ((@srcUserAcc IS NULL) And (@trgUserAcc IS NOT NULL)) Or ((@srcUserAcc IS NOT NULL) And (@trgUserAcc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UserAcc = ' + @srcUserAcc + ' / ' + @trgUserAcc
  END
  IF (@srcUserRef <> @trgUserRef) Or ((@srcUserRef IS NULL) And (@trgUserRef IS NOT NULL)) Or ((@srcUserRef IS NOT NULL) And (@trgUserRef IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UserRef = ' + @srcUserRef + ' / ' + @trgUserRef
  END
  IF (@srcSpareBits <> @trgSpareBits) Or ((@srcSpareBits IS NULL) And (@trgSpareBits IS NOT NULL)) Or ((@srcSpareBits IS NOT NULL) And (@trgSpareBits IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SpareBits is different'
  END
  IF (@srcGracePeriod <> @trgGracePeriod) Or ((@srcGracePeriod IS NULL) And (@trgGracePeriod IS NOT NULL)) Or ((@srcGracePeriod IS NOT NULL) And (@trgGracePeriod IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.GracePeriod = ' + STR(@srcGracePeriod) + ' / ' + STR(@trgGracePeriod)
  END
  IF (@srcMonWk1 <> @trgMonWk1) Or ((@srcMonWk1 IS NULL) And (@trgMonWk1 IS NOT NULL)) Or ((@srcMonWk1 IS NOT NULL) And (@trgMonWk1 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MonWk1 = ' + @srcMonWk1 + ' / ' + @trgMonWk1
  END
  IF (@srcAuditDate <> @trgAuditDate) Or ((@srcAuditDate IS NULL) And (@trgAuditDate IS NOT NULL)) Or ((@srcAuditDate IS NOT NULL) And (@trgAuditDate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.AuditDate = ' + @srcAuditDate + ' / ' + @trgAuditDate
  END
  IF (@srcTrigDate <> @trgTrigDate) Or ((@srcTrigDate IS NULL) And (@trgTrigDate IS NOT NULL)) Or ((@srcTrigDate IS NOT NULL) And (@trgTrigDate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.TrigDate = ' + @srcTrigDate + ' / ' + @trgTrigDate
  END
  IF (@srcExUsrSec <> @trgExUsrSec) Or ((@srcExUsrSec IS NULL) And (@trgExUsrSec IS NOT NULL)) Or ((@srcExUsrSec IS NOT NULL) And (@trgExUsrSec IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExUsrSec is different'
  END
  IF (@srcUsrLogCount <> @trgUsrLogCount) Or ((@srcUsrLogCount IS NULL) And (@trgUsrLogCount IS NOT NULL)) Or ((@srcUsrLogCount IS NOT NULL) And (@trgUsrLogCount IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UsrLogCount = ' + STR(@srcUsrLogCount) + ' / ' + STR(@trgUsrLogCount)
  END
  IF (@srcBinMask <> @trgBinMask) Or ((@srcBinMask IS NULL) And (@trgBinMask IS NOT NULL)) Or ((@srcBinMask IS NOT NULL) And (@trgBinMask IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.BinMask = ' + @srcBinMask + ' / ' + @trgBinMask
  END
  IF (@srcSpare5a <> @trgSpare5a) Or ((@srcSpare5a IS NULL) And (@trgSpare5a IS NOT NULL)) Or ((@srcSpare5a IS NOT NULL) And (@trgSpare5a IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.Spare5a = ' + @srcSpare5a + ' / ' + @trgSpare5a
  END
  IF (@srcSpare6a <> @trgSpare6a) Or ((@srcSpare6a IS NULL) And (@trgSpare6a IS NOT NULL)) Or ((@srcSpare6a IS NOT NULL) And (@trgSpare6a IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.Spare6a = ' + @srcSpare6a + ' / ' + @trgSpare6a
  END
  IF (@srcUserBank <> @trgUserBank) Or ((@srcUserBank IS NULL) And (@trgUserBank IS NOT NULL)) Or ((@srcUserBank IS NOT NULL) And (@trgUserBank IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UserBank = ' + @srcUserBank + ' / ' + @trgUserBank
  END
  IF (@srcExSec <> @trgExSec) Or ((@srcExSec IS NULL) And (@trgExSec IS NOT NULL)) Or ((@srcExSec IS NOT NULL) And (@trgExSec IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExSec is different'
  END
  IF (@srcLastExpFolio <> @trgLastExpFolio) Or ((@srcLastExpFolio IS NULL) And (@trgLastExpFolio IS NOT NULL)) Or ((@srcLastExpFolio IS NOT NULL) And (@trgLastExpFolio IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.LastExpFolio = ' + STR(@srcLastExpFolio) + ' / ' + STR(@trgLastExpFolio)
  END
  IF (@srcDetailTel <> @trgDetailTel) Or ((@srcDetailTel IS NULL) And (@trgDetailTel IS NOT NULL)) Or ((@srcDetailTel IS NOT NULL) And (@trgDetailTel IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DetailTel = ' + @srcDetailTel + ' / ' + @trgDetailTel
  END
  IF (@srcDetailFax <> @trgDetailFax) Or ((@srcDetailFax IS NULL) And (@trgDetailFax IS NOT NULL)) Or ((@srcDetailFax IS NOT NULL) And (@trgDetailFax IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.DetailFax = ' + @srcDetailFax + ' / ' + @trgDetailFax
  END
  IF (@srcUserVATReg <> @trgUserVATReg) Or ((@srcUserVATReg IS NULL) And (@trgUserVATReg IS NOT NULL)) Or ((@srcUserVATReg IS NOT NULL) And (@trgUserVATReg IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UserVATReg = ' + @srcUserVATReg + ' / ' + @trgUserVATReg
  END
  IF (@srcEnableTTDDiscounts <> @trgEnableTTDDiscounts) Or ((@srcEnableTTDDiscounts IS NULL) And (@trgEnableTTDDiscounts IS NOT NULL)) Or ((@srcEnableTTDDiscounts IS NOT NULL) And (@trgEnableTTDDiscounts IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.EnableTTDDiscounts = ' + STR(@srcEnableTTDDiscounts) + ' / ' + STR(@trgEnableTTDDiscounts)
  END
  IF (@srcEnableVBDDiscounts <> @trgEnableVBDDiscounts) Or ((@srcEnableVBDDiscounts IS NULL) And (@trgEnableVBDDiscounts IS NOT NULL)) Or ((@srcEnableVBDDiscounts IS NOT NULL) And (@trgEnableVBDDiscounts IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.EnableVBDDiscounts = ' + STR(@srcEnableVBDDiscounts) + ' / ' + STR(@trgEnableVBDDiscounts)
  END
  IF (@srcEnableOverrideLocations <> @trgEnableOverrideLocations) Or ((@srcEnableOverrideLocations IS NULL) And (@trgEnableOverrideLocations IS NOT NULL)) Or ((@srcEnableOverrideLocations IS NOT NULL) And (@trgEnableOverrideLocations IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.EnableOverrideLocations = ' + STR(@srcEnableOverrideLocations) + ' / ' + STR(@trgEnableOverrideLocations)
  END
  IF (@srcIncludeVATInCommittedBalance <> @trgIncludeVATInCommittedBalance) Or ((@srcIncludeVATInCommittedBalance IS NULL) And (@trgIncludeVATInCommittedBalance IS NOT NULL)) Or ((@srcIncludeVATInCommittedBalance IS NOT NULL) And (@trgIncludeVATInCommittedBalance IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IncludeVATInCommittedBalance = ' + STR(@srcIncludeVATInCommittedBalance) + ' / ' + STR(@trgIncludeVATInCommittedBalance)
  END
  IF (@srcVATStandardCode <> @trgVATStandardCode) Or ((@srcVATStandardCode IS NULL) And (@trgVATStandardCode IS NOT NULL)) Or ((@srcVATStandardCode IS NOT NULL) And (@trgVATStandardCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATStandardCode = ' + @srcVATStandardCode + ' / ' + @trgVATStandardCode
  END
  IF (@srcVATStandardDesc <> @trgVATStandardDesc) Or ((@srcVATStandardDesc IS NULL) And (@trgVATStandardDesc IS NOT NULL)) Or ((@srcVATStandardDesc IS NOT NULL) And (@trgVATStandardDesc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATStandardDesc = ' + @srcVATStandardDesc + ' / ' + @trgVATStandardDesc
  END
  IF (@srcVATStandardRate <> @trgVATStandardRate) Or ((@srcVATStandardRate IS NULL) And (@trgVATStandardRate IS NOT NULL)) Or ((@srcVATStandardRate IS NOT NULL) And (@trgVATStandardRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATStandardRate = ' + @srcVATStandardRate + ' / ' + @trgVATStandardRate
  END
  IF (@srcVATStandardSpare <> @trgVATStandardSpare) Or ((@srcVATStandardSpare IS NULL) And (@trgVATStandardSpare IS NOT NULL)) Or ((@srcVATStandardSpare IS NOT NULL) And (@trgVATStandardSpare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATStandardSpare is different'
  END
  IF (@srcVATStandardInclude <> @trgVATStandardInclude) Or ((@srcVATStandardInclude IS NULL) And (@trgVATStandardInclude IS NOT NULL)) Or ((@srcVATStandardInclude IS NOT NULL) And (@trgVATStandardInclude IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATStandardInclude = ' + STR(@srcVATStandardInclude) + ' / ' + STR(@trgVATStandardInclude)
  END
  IF (@srcVATStandardSpare2 <> @trgVATStandardSpare2) Or ((@srcVATStandardSpare2 IS NULL) And (@trgVATStandardSpare2 IS NOT NULL)) Or ((@srcVATStandardSpare2 IS NOT NULL) And (@trgVATStandardSpare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATStandardSpare2 is different'
  END
  IF (@srcVATExemptCode <> @trgVATExemptCode) Or ((@srcVATExemptCode IS NULL) And (@trgVATExemptCode IS NOT NULL)) Or ((@srcVATExemptCode IS NOT NULL) And (@trgVATExemptCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATExemptCode = ' + @srcVATExemptCode + ' / ' + @trgVATExemptCode
  END
  IF (@srcVATExemptDesc <> @trgVATExemptDesc) Or ((@srcVATExemptDesc IS NULL) And (@trgVATExemptDesc IS NOT NULL)) Or ((@srcVATExemptDesc IS NOT NULL) And (@trgVATExemptDesc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATExemptDesc = ' + @srcVATExemptDesc + ' / ' + @trgVATExemptDesc
  END
  IF (@srcVATExemptRate <> @trgVATExemptRate) Or ((@srcVATExemptRate IS NULL) And (@trgVATExemptRate IS NOT NULL)) Or ((@srcVATExemptRate IS NOT NULL) And (@trgVATExemptRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATExemptRate = ' + @srcVATExemptRate + ' / ' + @trgVATExemptRate
  END
  IF (@srcVATExemptSpare <> @trgVATExemptSpare) Or ((@srcVATExemptSpare IS NULL) And (@trgVATExemptSpare IS NOT NULL)) Or ((@srcVATExemptSpare IS NOT NULL) And (@trgVATExemptSpare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATExemptSpare is different'
  END
  IF (@srcVATExemptInclude <> @trgVATExemptInclude) Or ((@srcVATExemptInclude IS NULL) And (@trgVATExemptInclude IS NOT NULL)) Or ((@srcVATExemptInclude IS NOT NULL) And (@trgVATExemptInclude IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATExemptInclude = ' + STR(@srcVATExemptInclude) + ' / ' + STR(@trgVATExemptInclude)
  END
  IF (@srcVATExemptSpare2 <> @trgVATExemptSpare2) Or ((@srcVATExemptSpare2 IS NULL) And (@trgVATExemptSpare2 IS NOT NULL)) Or ((@srcVATExemptSpare2 IS NOT NULL) And (@trgVATExemptSpare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATExemptSpare2 is different'
  END
  IF (@srcVATZeroCode <> @trgVATZeroCode) Or ((@srcVATZeroCode IS NULL) And (@trgVATZeroCode IS NOT NULL)) Or ((@srcVATZeroCode IS NOT NULL) And (@trgVATZeroCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATZeroCode = ' + @srcVATZeroCode + ' / ' + @trgVATZeroCode
  END
  IF (@srcVATZeroDesc <> @trgVATZeroDesc) Or ((@srcVATZeroDesc IS NULL) And (@trgVATZeroDesc IS NOT NULL)) Or ((@srcVATZeroDesc IS NOT NULL) And (@trgVATZeroDesc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATZeroDesc = ' + @srcVATZeroDesc + ' / ' + @trgVATZeroDesc
  END
  IF (@srcVATZeroRate <> @trgVATZeroRate) Or ((@srcVATZeroRate IS NULL) And (@trgVATZeroRate IS NOT NULL)) Or ((@srcVATZeroRate IS NOT NULL) And (@trgVATZeroRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATZeroRate = ' + @srcVATZeroRate + ' / ' + @trgVATZeroRate
  END
  IF (@srcVATZeroSpare <> @trgVATZeroSpare) Or ((@srcVATZeroSpare IS NULL) And (@trgVATZeroSpare IS NOT NULL)) Or ((@srcVATZeroSpare IS NOT NULL) And (@trgVATZeroSpare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATZeroSpare is different'
  END
  IF (@srcVATZeroInclude <> @trgVATZeroInclude) Or ((@srcVATZeroInclude IS NULL) And (@trgVATZeroInclude IS NOT NULL)) Or ((@srcVATZeroInclude IS NOT NULL) And (@trgVATZeroInclude IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATZeroInclude = ' + STR(@srcVATZeroInclude) + ' / ' + STR(@trgVATZeroInclude)
  END
  IF (@srcVATZeroSpare2 <> @trgVATZeroSpare2) Or ((@srcVATZeroSpare2 IS NULL) And (@trgVATZeroSpare2 IS NOT NULL)) Or ((@srcVATZeroSpare2 IS NOT NULL) And (@trgVATZeroSpare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATZeroSpare2 is different'
  END
  IF (@srcVATRate1Code <> @trgVATRate1Code) Or ((@srcVATRate1Code IS NULL) And (@trgVATRate1Code IS NOT NULL)) Or ((@srcVATRate1Code IS NOT NULL) And (@trgVATRate1Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate1Code = ' + @srcVATRate1Code + ' / ' + @trgVATRate1Code
  END
  IF (@srcVATRate1Desc <> @trgVATRate1Desc) Or ((@srcVATRate1Desc IS NULL) And (@trgVATRate1Desc IS NOT NULL)) Or ((@srcVATRate1Desc IS NOT NULL) And (@trgVATRate1Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate1Desc = ' + @srcVATRate1Desc + ' / ' + @trgVATRate1Desc
  END
  IF (@srcVATRate1Rate <> @trgVATRate1Rate) Or ((@srcVATRate1Rate IS NULL) And (@trgVATRate1Rate IS NOT NULL)) Or ((@srcVATRate1Rate IS NOT NULL) And (@trgVATRate1Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate1Rate = ' + @srcVATRate1Rate + ' / ' + @trgVATRate1Rate
  END
  IF (@srcVATRate1Spare <> @trgVATRate1Spare) Or ((@srcVATRate1Spare IS NULL) And (@trgVATRate1Spare IS NOT NULL)) Or ((@srcVATRate1Spare IS NOT NULL) And (@trgVATRate1Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate1Spare is different'
  END
  IF (@srcVATRate1Include <> @trgVATRate1Include) Or ((@srcVATRate1Include IS NULL) And (@trgVATRate1Include IS NOT NULL)) Or ((@srcVATRate1Include IS NOT NULL) And (@trgVATRate1Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate1Include = ' + STR(@srcVATRate1Include) + ' / ' + STR(@trgVATRate1Include)
  END
  IF (@srcVATRate1Spare2 <> @trgVATRate1Spare2) Or ((@srcVATRate1Spare2 IS NULL) And (@trgVATRate1Spare2 IS NOT NULL)) Or ((@srcVATRate1Spare2 IS NOT NULL) And (@trgVATRate1Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate1Spare2 is different'
  END
  IF (@srcVATRate2Code <> @trgVATRate2Code) Or ((@srcVATRate2Code IS NULL) And (@trgVATRate2Code IS NOT NULL)) Or ((@srcVATRate2Code IS NOT NULL) And (@trgVATRate2Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate2Code = ' + @srcVATRate2Code + ' / ' + @trgVATRate2Code
  END
  IF (@srcVATRate2Desc <> @trgVATRate2Desc) Or ((@srcVATRate2Desc IS NULL) And (@trgVATRate2Desc IS NOT NULL)) Or ((@srcVATRate2Desc IS NOT NULL) And (@trgVATRate2Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate2Desc = ' + @srcVATRate2Desc + ' / ' + @trgVATRate2Desc
  END
  IF (@srcVATRate2Rate <> @trgVATRate2Rate) Or ((@srcVATRate2Rate IS NULL) And (@trgVATRate2Rate IS NOT NULL)) Or ((@srcVATRate2Rate IS NOT NULL) And (@trgVATRate2Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate2Rate = ' + @srcVATRate2Rate + ' / ' + @trgVATRate2Rate
  END
  IF (@srcVATRate2Spare <> @trgVATRate2Spare) Or ((@srcVATRate2Spare IS NULL) And (@trgVATRate2Spare IS NOT NULL)) Or ((@srcVATRate2Spare IS NOT NULL) And (@trgVATRate2Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate2Spare is different'
  END
  IF (@srcVATRate2Include <> @trgVATRate2Include) Or ((@srcVATRate2Include IS NULL) And (@trgVATRate2Include IS NOT NULL)) Or ((@srcVATRate2Include IS NOT NULL) And (@trgVATRate2Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate2Include = ' + STR(@srcVATRate2Include) + ' / ' + STR(@trgVATRate2Include)
  END
  IF (@srcVATRate2Spare2 <> @trgVATRate2Spare2) Or ((@srcVATRate2Spare2 IS NULL) And (@trgVATRate2Spare2 IS NOT NULL)) Or ((@srcVATRate2Spare2 IS NOT NULL) And (@trgVATRate2Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate2Spare2 is different'
  END
  IF (@srcVATRate3Code <> @trgVATRate3Code) Or ((@srcVATRate3Code IS NULL) And (@trgVATRate3Code IS NOT NULL)) Or ((@srcVATRate3Code IS NOT NULL) And (@trgVATRate3Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate3Code = ' + @srcVATRate3Code + ' / ' + @trgVATRate3Code
  END
  IF (@srcVATRate3Desc <> @trgVATRate3Desc) Or ((@srcVATRate3Desc IS NULL) And (@trgVATRate3Desc IS NOT NULL)) Or ((@srcVATRate3Desc IS NOT NULL) And (@trgVATRate3Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate3Desc = ' + @srcVATRate3Desc + ' / ' + @trgVATRate3Desc
  END
  IF (@srcVATRate3Rate <> @trgVATRate3Rate) Or ((@srcVATRate3Rate IS NULL) And (@trgVATRate3Rate IS NOT NULL)) Or ((@srcVATRate3Rate IS NOT NULL) And (@trgVATRate3Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate3Rate = ' + @srcVATRate3Rate + ' / ' + @trgVATRate3Rate
  END
  IF (@srcVATRate3Spare <> @trgVATRate3Spare) Or ((@srcVATRate3Spare IS NULL) And (@trgVATRate3Spare IS NOT NULL)) Or ((@srcVATRate3Spare IS NOT NULL) And (@trgVATRate3Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate3Spare is different'
  END
  IF (@srcVATRate3Include <> @trgVATRate3Include) Or ((@srcVATRate3Include IS NULL) And (@trgVATRate3Include IS NOT NULL)) Or ((@srcVATRate3Include IS NOT NULL) And (@trgVATRate3Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate3Include = ' + STR(@srcVATRate3Include) + ' / ' + STR(@trgVATRate3Include)
  END
  IF (@srcVATRate3Spare2 <> @trgVATRate3Spare2) Or ((@srcVATRate3Spare2 IS NULL) And (@trgVATRate3Spare2 IS NOT NULL)) Or ((@srcVATRate3Spare2 IS NOT NULL) And (@trgVATRate3Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate3Spare2 is different'
  END
  IF (@srcVATRate4Code <> @trgVATRate4Code) Or ((@srcVATRate4Code IS NULL) And (@trgVATRate4Code IS NOT NULL)) Or ((@srcVATRate4Code IS NOT NULL) And (@trgVATRate4Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate4Code = ' + @srcVATRate4Code + ' / ' + @trgVATRate4Code
  END
  IF (@srcVATRate4Desc <> @trgVATRate4Desc) Or ((@srcVATRate4Desc IS NULL) And (@trgVATRate4Desc IS NOT NULL)) Or ((@srcVATRate4Desc IS NOT NULL) And (@trgVATRate4Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate4Desc = ' + @srcVATRate4Desc + ' / ' + @trgVATRate4Desc
  END
  IF (@srcVATRate4Rate <> @trgVATRate4Rate) Or ((@srcVATRate4Rate IS NULL) And (@trgVATRate4Rate IS NOT NULL)) Or ((@srcVATRate4Rate IS NOT NULL) And (@trgVATRate4Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate4Rate = ' + @srcVATRate4Rate + ' / ' + @trgVATRate4Rate
  END
  IF (@srcVATRate4Spare <> @trgVATRate4Spare) Or ((@srcVATRate4Spare IS NULL) And (@trgVATRate4Spare IS NOT NULL)) Or ((@srcVATRate4Spare IS NOT NULL) And (@trgVATRate4Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate4Spare is different'
  END
  IF (@srcVATRate4Include <> @trgVATRate4Include) Or ((@srcVATRate4Include IS NULL) And (@trgVATRate4Include IS NOT NULL)) Or ((@srcVATRate4Include IS NOT NULL) And (@trgVATRate4Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate4Include = ' + STR(@srcVATRate4Include) + ' / ' + STR(@trgVATRate4Include)
  END
  IF (@srcVATRate4Spare2 <> @trgVATRate4Spare2) Or ((@srcVATRate4Spare2 IS NULL) And (@trgVATRate4Spare2 IS NOT NULL)) Or ((@srcVATRate4Spare2 IS NOT NULL) And (@trgVATRate4Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate4Spare2 is different'
  END
  IF (@srcVATRate5Code <> @trgVATRate5Code) Or ((@srcVATRate5Code IS NULL) And (@trgVATRate5Code IS NOT NULL)) Or ((@srcVATRate5Code IS NOT NULL) And (@trgVATRate5Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate5Code = ' + @srcVATRate5Code + ' / ' + @trgVATRate5Code
  END
  IF (@srcVATRate5Desc <> @trgVATRate5Desc) Or ((@srcVATRate5Desc IS NULL) And (@trgVATRate5Desc IS NOT NULL)) Or ((@srcVATRate5Desc IS NOT NULL) And (@trgVATRate5Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate5Desc = ' + @srcVATRate5Desc + ' / ' + @trgVATRate5Desc
  END
  IF (@srcVATRate5Rate <> @trgVATRate5Rate) Or ((@srcVATRate5Rate IS NULL) And (@trgVATRate5Rate IS NOT NULL)) Or ((@srcVATRate5Rate IS NOT NULL) And (@trgVATRate5Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate5Rate = ' + @srcVATRate5Rate + ' / ' + @trgVATRate5Rate
  END
  IF (@srcVATRate5Spare <> @trgVATRate5Spare) Or ((@srcVATRate5Spare IS NULL) And (@trgVATRate5Spare IS NOT NULL)) Or ((@srcVATRate5Spare IS NOT NULL) And (@trgVATRate5Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate5Spare is different'
  END
  IF (@srcVATRate5Include <> @trgVATRate5Include) Or ((@srcVATRate5Include IS NULL) And (@trgVATRate5Include IS NOT NULL)) Or ((@srcVATRate5Include IS NOT NULL) And (@trgVATRate5Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate5Include = ' + STR(@srcVATRate5Include) + ' / ' + STR(@trgVATRate5Include)
  END
  IF (@srcVATRate5Spare2 <> @trgVATRate5Spare2) Or ((@srcVATRate5Spare2 IS NULL) And (@trgVATRate5Spare2 IS NOT NULL)) Or ((@srcVATRate5Spare2 IS NOT NULL) And (@trgVATRate5Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate5Spare2 is different'
  END
  IF (@srcVATRate6Code <> @trgVATRate6Code) Or ((@srcVATRate6Code IS NULL) And (@trgVATRate6Code IS NOT NULL)) Or ((@srcVATRate6Code IS NOT NULL) And (@trgVATRate6Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate6Code = ' + @srcVATRate6Code + ' / ' + @trgVATRate6Code
  END
  IF (@srcVATRate6Desc <> @trgVATRate6Desc) Or ((@srcVATRate6Desc IS NULL) And (@trgVATRate6Desc IS NOT NULL)) Or ((@srcVATRate6Desc IS NOT NULL) And (@trgVATRate6Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate6Desc = ' + @srcVATRate6Desc + ' / ' + @trgVATRate6Desc
  END
  IF (@srcVATRate6Rate <> @trgVATRate6Rate) Or ((@srcVATRate6Rate IS NULL) And (@trgVATRate6Rate IS NOT NULL)) Or ((@srcVATRate6Rate IS NOT NULL) And (@trgVATRate6Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate6Rate = ' + @srcVATRate6Rate + ' / ' + @trgVATRate6Rate
  END
  IF (@srcVATRate6Spare <> @trgVATRate6Spare) Or ((@srcVATRate6Spare IS NULL) And (@trgVATRate6Spare IS NOT NULL)) Or ((@srcVATRate6Spare IS NOT NULL) And (@trgVATRate6Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate6Spare is different'
  END
  IF (@srcVATRate6Include <> @trgVATRate6Include) Or ((@srcVATRate6Include IS NULL) And (@trgVATRate6Include IS NOT NULL)) Or ((@srcVATRate6Include IS NOT NULL) And (@trgVATRate6Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate6Include = ' + STR(@srcVATRate6Include) + ' / ' + STR(@trgVATRate6Include)
  END
  IF (@srcVATRate6Spare2 <> @trgVATRate6Spare2) Or ((@srcVATRate6Spare2 IS NULL) And (@trgVATRate6Spare2 IS NOT NULL)) Or ((@srcVATRate6Spare2 IS NOT NULL) And (@trgVATRate6Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate6Spare2 is different'
  END
  IF (@srcVATRate7Code <> @trgVATRate7Code) Or ((@srcVATRate7Code IS NULL) And (@trgVATRate7Code IS NOT NULL)) Or ((@srcVATRate7Code IS NOT NULL) And (@trgVATRate7Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate7Code = ' + @srcVATRate7Code + ' / ' + @trgVATRate7Code
  END
  IF (@srcVATRate7Desc <> @trgVATRate7Desc) Or ((@srcVATRate7Desc IS NULL) And (@trgVATRate7Desc IS NOT NULL)) Or ((@srcVATRate7Desc IS NOT NULL) And (@trgVATRate7Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate7Desc = ' + @srcVATRate7Desc + ' / ' + @trgVATRate7Desc
  END
  IF (@srcVATRate7Rate <> @trgVATRate7Rate) Or ((@srcVATRate7Rate IS NULL) And (@trgVATRate7Rate IS NOT NULL)) Or ((@srcVATRate7Rate IS NOT NULL) And (@trgVATRate7Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate7Rate = ' + @srcVATRate7Rate + ' / ' + @trgVATRate7Rate
  END
  IF (@srcVATRate7Spare <> @trgVATRate7Spare) Or ((@srcVATRate7Spare IS NULL) And (@trgVATRate7Spare IS NOT NULL)) Or ((@srcVATRate7Spare IS NOT NULL) And (@trgVATRate7Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate7Spare is different'
  END
  IF (@srcVATRate7Include <> @trgVATRate7Include) Or ((@srcVATRate7Include IS NULL) And (@trgVATRate7Include IS NOT NULL)) Or ((@srcVATRate7Include IS NOT NULL) And (@trgVATRate7Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate7Include = ' + STR(@srcVATRate7Include) + ' / ' + STR(@trgVATRate7Include)
  END
  IF (@srcVATRate7Spare2 <> @trgVATRate7Spare2) Or ((@srcVATRate7Spare2 IS NULL) And (@trgVATRate7Spare2 IS NOT NULL)) Or ((@srcVATRate7Spare2 IS NOT NULL) And (@trgVATRate7Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate7Spare2 is different'
  END
  IF (@srcVATRate8Code <> @trgVATRate8Code) Or ((@srcVATRate8Code IS NULL) And (@trgVATRate8Code IS NOT NULL)) Or ((@srcVATRate8Code IS NOT NULL) And (@trgVATRate8Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate8Code = ' + @srcVATRate8Code + ' / ' + @trgVATRate8Code
  END
  IF (@srcVATRate8Desc <> @trgVATRate8Desc) Or ((@srcVATRate8Desc IS NULL) And (@trgVATRate8Desc IS NOT NULL)) Or ((@srcVATRate8Desc IS NOT NULL) And (@trgVATRate8Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate8Desc = ' + @srcVATRate8Desc + ' / ' + @trgVATRate8Desc
  END
  IF (@srcVATRate8Rate <> @trgVATRate8Rate) Or ((@srcVATRate8Rate IS NULL) And (@trgVATRate8Rate IS NOT NULL)) Or ((@srcVATRate8Rate IS NOT NULL) And (@trgVATRate8Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate8Rate = ' + @srcVATRate8Rate + ' / ' + @trgVATRate8Rate
  END
  IF (@srcVATRate8Spare <> @trgVATRate8Spare) Or ((@srcVATRate8Spare IS NULL) And (@trgVATRate8Spare IS NOT NULL)) Or ((@srcVATRate8Spare IS NOT NULL) And (@trgVATRate8Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate8Spare is different'
  END
  IF (@srcVATRate8Include <> @trgVATRate8Include) Or ((@srcVATRate8Include IS NULL) And (@trgVATRate8Include IS NOT NULL)) Or ((@srcVATRate8Include IS NOT NULL) And (@trgVATRate8Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate8Include = ' + STR(@srcVATRate8Include) + ' / ' + STR(@trgVATRate8Include)
  END
  IF (@srcVATRate8Spare2 <> @trgVATRate8Spare2) Or ((@srcVATRate8Spare2 IS NULL) And (@trgVATRate8Spare2 IS NOT NULL)) Or ((@srcVATRate8Spare2 IS NOT NULL) And (@trgVATRate8Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate8Spare2 is different'
  END
  IF (@srcVATRate9Code <> @trgVATRate9Code) Or ((@srcVATRate9Code IS NULL) And (@trgVATRate9Code IS NOT NULL)) Or ((@srcVATRate9Code IS NOT NULL) And (@trgVATRate9Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate9Code = ' + @srcVATRate9Code + ' / ' + @trgVATRate9Code
  END
  IF (@srcVATRate9Desc <> @trgVATRate9Desc) Or ((@srcVATRate9Desc IS NULL) And (@trgVATRate9Desc IS NOT NULL)) Or ((@srcVATRate9Desc IS NOT NULL) And (@trgVATRate9Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate9Desc = ' + @srcVATRate9Desc + ' / ' + @trgVATRate9Desc
  END
  IF (@srcVATRate9Rate <> @trgVATRate9Rate) Or ((@srcVATRate9Rate IS NULL) And (@trgVATRate9Rate IS NOT NULL)) Or ((@srcVATRate9Rate IS NOT NULL) And (@trgVATRate9Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate9Rate = ' + @srcVATRate9Rate + ' / ' + @trgVATRate9Rate
  END
  IF (@srcVATRate9Spare <> @trgVATRate9Spare) Or ((@srcVATRate9Spare IS NULL) And (@trgVATRate9Spare IS NOT NULL)) Or ((@srcVATRate9Spare IS NOT NULL) And (@trgVATRate9Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate9Spare is different'
  END
  IF (@srcVATRate9Include <> @trgVATRate9Include) Or ((@srcVATRate9Include IS NULL) And (@trgVATRate9Include IS NOT NULL)) Or ((@srcVATRate9Include IS NOT NULL) And (@trgVATRate9Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate9Include = ' + STR(@srcVATRate9Include) + ' / ' + STR(@trgVATRate9Include)
  END
  IF (@srcVATRate9Spare2 <> @trgVATRate9Spare2) Or ((@srcVATRate9Spare2 IS NULL) And (@trgVATRate9Spare2 IS NOT NULL)) Or ((@srcVATRate9Spare2 IS NOT NULL) And (@trgVATRate9Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate9Spare2 is different'
  END
  IF (@srcVATRate10Code <> @trgVATRate10Code) Or ((@srcVATRate10Code IS NULL) And (@trgVATRate10Code IS NOT NULL)) Or ((@srcVATRate10Code IS NOT NULL) And (@trgVATRate10Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate10Code = ' + @srcVATRate10Code + ' / ' + @trgVATRate10Code
  END
  IF (@srcVATRate10Desc <> @trgVATRate10Desc) Or ((@srcVATRate10Desc IS NULL) And (@trgVATRate10Desc IS NOT NULL)) Or ((@srcVATRate10Desc IS NOT NULL) And (@trgVATRate10Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate10Desc = ' + @srcVATRate10Desc + ' / ' + @trgVATRate10Desc
  END
  IF (@srcVATRate10Rate <> @trgVATRate10Rate) Or ((@srcVATRate10Rate IS NULL) And (@trgVATRate10Rate IS NOT NULL)) Or ((@srcVATRate10Rate IS NOT NULL) And (@trgVATRate10Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate10Rate = ' + @srcVATRate10Rate + ' / ' + @trgVATRate10Rate
  END
  IF (@srcVATRate10Spare <> @trgVATRate10Spare) Or ((@srcVATRate10Spare IS NULL) And (@trgVATRate10Spare IS NOT NULL)) Or ((@srcVATRate10Spare IS NOT NULL) And (@trgVATRate10Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate10Spare is different'
  END
  IF (@srcVATRate10Include <> @trgVATRate10Include) Or ((@srcVATRate10Include IS NULL) And (@trgVATRate10Include IS NOT NULL)) Or ((@srcVATRate10Include IS NOT NULL) And (@trgVATRate10Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate10Include = ' + STR(@srcVATRate10Include) + ' / ' + STR(@trgVATRate10Include)
  END
  IF (@srcVATRate10Spare2 <> @trgVATRate10Spare2) Or ((@srcVATRate10Spare2 IS NULL) And (@trgVATRate10Spare2 IS NOT NULL)) Or ((@srcVATRate10Spare2 IS NOT NULL) And (@trgVATRate10Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate10Spare2 is different'
  END
  IF (@srcVATRate11Code <> @trgVATRate11Code) Or ((@srcVATRate11Code IS NULL) And (@trgVATRate11Code IS NOT NULL)) Or ((@srcVATRate11Code IS NOT NULL) And (@trgVATRate11Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate11Code = ' + @srcVATRate11Code + ' / ' + @trgVATRate11Code
  END
  IF (@srcVATRate11Desc <> @trgVATRate11Desc) Or ((@srcVATRate11Desc IS NULL) And (@trgVATRate11Desc IS NOT NULL)) Or ((@srcVATRate11Desc IS NOT NULL) And (@trgVATRate11Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate11Desc = ' + @srcVATRate11Desc + ' / ' + @trgVATRate11Desc
  END
  IF (@srcVATRate11Rate <> @trgVATRate11Rate) Or ((@srcVATRate11Rate IS NULL) And (@trgVATRate11Rate IS NOT NULL)) Or ((@srcVATRate11Rate IS NOT NULL) And (@trgVATRate11Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate11Rate = ' + @srcVATRate11Rate + ' / ' + @trgVATRate11Rate
  END
  IF (@srcVATRate11Spare <> @trgVATRate11Spare) Or ((@srcVATRate11Spare IS NULL) And (@trgVATRate11Spare IS NOT NULL)) Or ((@srcVATRate11Spare IS NOT NULL) And (@trgVATRate11Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate11Spare is different'
  END
  IF (@srcVATRate11Include <> @trgVATRate11Include) Or ((@srcVATRate11Include IS NULL) And (@trgVATRate11Include IS NOT NULL)) Or ((@srcVATRate11Include IS NOT NULL) And (@trgVATRate11Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate11Include = ' + STR(@srcVATRate11Include) + ' / ' + STR(@trgVATRate11Include)
  END
  IF (@srcVATRate11Spare2 <> @trgVATRate11Spare2) Or ((@srcVATRate11Spare2 IS NULL) And (@trgVATRate11Spare2 IS NOT NULL)) Or ((@srcVATRate11Spare2 IS NOT NULL) And (@trgVATRate11Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate11Spare2 is different'
  END
  IF (@srcVATRate12Code <> @trgVATRate12Code) Or ((@srcVATRate12Code IS NULL) And (@trgVATRate12Code IS NOT NULL)) Or ((@srcVATRate12Code IS NOT NULL) And (@trgVATRate12Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate12Code = ' + @srcVATRate12Code + ' / ' + @trgVATRate12Code
  END
  IF (@srcVATRate12Desc <> @trgVATRate12Desc) Or ((@srcVATRate12Desc IS NULL) And (@trgVATRate12Desc IS NOT NULL)) Or ((@srcVATRate12Desc IS NOT NULL) And (@trgVATRate12Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate12Desc = ' + @srcVATRate12Desc + ' / ' + @trgVATRate12Desc
  END
  IF (@srcVATRate12Rate <> @trgVATRate12Rate) Or ((@srcVATRate12Rate IS NULL) And (@trgVATRate12Rate IS NOT NULL)) Or ((@srcVATRate12Rate IS NOT NULL) And (@trgVATRate12Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate12Rate = ' + @srcVATRate12Rate + ' / ' + @trgVATRate12Rate
  END
  IF (@srcVATRate12Spare <> @trgVATRate12Spare) Or ((@srcVATRate12Spare IS NULL) And (@trgVATRate12Spare IS NOT NULL)) Or ((@srcVATRate12Spare IS NOT NULL) And (@trgVATRate12Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate12Spare is different'
  END
  IF (@srcVATRate12Include <> @trgVATRate12Include) Or ((@srcVATRate12Include IS NULL) And (@trgVATRate12Include IS NOT NULL)) Or ((@srcVATRate12Include IS NOT NULL) And (@trgVATRate12Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate12Include = ' + STR(@srcVATRate12Include) + ' / ' + STR(@trgVATRate12Include)
  END
  IF (@srcVATRate12Spare2 <> @trgVATRate12Spare2) Or ((@srcVATRate12Spare2 IS NULL) And (@trgVATRate12Spare2 IS NOT NULL)) Or ((@srcVATRate12Spare2 IS NOT NULL) And (@trgVATRate12Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate12Spare2 is different'
  END
  IF (@srcVATRate13Code <> @trgVATRate13Code) Or ((@srcVATRate13Code IS NULL) And (@trgVATRate13Code IS NOT NULL)) Or ((@srcVATRate13Code IS NOT NULL) And (@trgVATRate13Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate13Code = ' + @srcVATRate13Code + ' / ' + @trgVATRate13Code
  END
  IF (@srcVATRate13Desc <> @trgVATRate13Desc) Or ((@srcVATRate13Desc IS NULL) And (@trgVATRate13Desc IS NOT NULL)) Or ((@srcVATRate13Desc IS NOT NULL) And (@trgVATRate13Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate13Desc = ' + @srcVATRate13Desc + ' / ' + @trgVATRate13Desc
  END
  IF (@srcVATRate13Rate <> @trgVATRate13Rate) Or ((@srcVATRate13Rate IS NULL) And (@trgVATRate13Rate IS NOT NULL)) Or ((@srcVATRate13Rate IS NOT NULL) And (@trgVATRate13Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate13Rate = ' + @srcVATRate13Rate + ' / ' + @trgVATRate13Rate
  END
  IF (@srcVATRate13Spare <> @trgVATRate13Spare) Or ((@srcVATRate13Spare IS NULL) And (@trgVATRate13Spare IS NOT NULL)) Or ((@srcVATRate13Spare IS NOT NULL) And (@trgVATRate13Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate13Spare is different'
  END
  IF (@srcVATRate13Include <> @trgVATRate13Include) Or ((@srcVATRate13Include IS NULL) And (@trgVATRate13Include IS NOT NULL)) Or ((@srcVATRate13Include IS NOT NULL) And (@trgVATRate13Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate13Include = ' + STR(@srcVATRate13Include) + ' / ' + STR(@trgVATRate13Include)
  END
  IF (@srcVATRate13Spare2 <> @trgVATRate13Spare2) Or ((@srcVATRate13Spare2 IS NULL) And (@trgVATRate13Spare2 IS NOT NULL)) Or ((@srcVATRate13Spare2 IS NOT NULL) And (@trgVATRate13Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate13Spare2 is different'
  END
  IF (@srcVATRate14Code <> @trgVATRate14Code) Or ((@srcVATRate14Code IS NULL) And (@trgVATRate14Code IS NOT NULL)) Or ((@srcVATRate14Code IS NOT NULL) And (@trgVATRate14Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate14Code = ' + @srcVATRate14Code + ' / ' + @trgVATRate14Code
  END
  IF (@srcVATRate14Desc <> @trgVATRate14Desc) Or ((@srcVATRate14Desc IS NULL) And (@trgVATRate14Desc IS NOT NULL)) Or ((@srcVATRate14Desc IS NOT NULL) And (@trgVATRate14Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate14Desc = ' + @srcVATRate14Desc + ' / ' + @trgVATRate14Desc
  END
  IF (@srcVATRate14Rate <> @trgVATRate14Rate) Or ((@srcVATRate14Rate IS NULL) And (@trgVATRate14Rate IS NOT NULL)) Or ((@srcVATRate14Rate IS NOT NULL) And (@trgVATRate14Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate14Rate = ' + @srcVATRate14Rate + ' / ' + @trgVATRate14Rate
  END
  IF (@srcVATRate14Spare <> @trgVATRate14Spare) Or ((@srcVATRate14Spare IS NULL) And (@trgVATRate14Spare IS NOT NULL)) Or ((@srcVATRate14Spare IS NOT NULL) And (@trgVATRate14Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate14Spare is different'
  END
  IF (@srcVATRate14Include <> @trgVATRate14Include) Or ((@srcVATRate14Include IS NULL) And (@trgVATRate14Include IS NOT NULL)) Or ((@srcVATRate14Include IS NOT NULL) And (@trgVATRate14Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate14Include = ' + STR(@srcVATRate14Include) + ' / ' + STR(@trgVATRate14Include)
  END
  IF (@srcVATRate14Spare2 <> @trgVATRate14Spare2) Or ((@srcVATRate14Spare2 IS NULL) And (@trgVATRate14Spare2 IS NOT NULL)) Or ((@srcVATRate14Spare2 IS NOT NULL) And (@trgVATRate14Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate14Spare2 is different'
  END
  IF (@srcVATRate15Code <> @trgVATRate15Code) Or ((@srcVATRate15Code IS NULL) And (@trgVATRate15Code IS NOT NULL)) Or ((@srcVATRate15Code IS NOT NULL) And (@trgVATRate15Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate15Code = ' + @srcVATRate15Code + ' / ' + @trgVATRate15Code
  END
  IF (@srcVATRate15Desc <> @trgVATRate15Desc) Or ((@srcVATRate15Desc IS NULL) And (@trgVATRate15Desc IS NOT NULL)) Or ((@srcVATRate15Desc IS NOT NULL) And (@trgVATRate15Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate15Desc = ' + @srcVATRate15Desc + ' / ' + @trgVATRate15Desc
  END
  IF (@srcVATRate15Rate <> @trgVATRate15Rate) Or ((@srcVATRate15Rate IS NULL) And (@trgVATRate15Rate IS NOT NULL)) Or ((@srcVATRate15Rate IS NOT NULL) And (@trgVATRate15Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate15Rate = ' + @srcVATRate15Rate + ' / ' + @trgVATRate15Rate
  END
  IF (@srcVATRate15Spare <> @trgVATRate15Spare) Or ((@srcVATRate15Spare IS NULL) And (@trgVATRate15Spare IS NOT NULL)) Or ((@srcVATRate15Spare IS NOT NULL) And (@trgVATRate15Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate15Spare is different'
  END
  IF (@srcVATRate15Include <> @trgVATRate15Include) Or ((@srcVATRate15Include IS NULL) And (@trgVATRate15Include IS NOT NULL)) Or ((@srcVATRate15Include IS NOT NULL) And (@trgVATRate15Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate15Include = ' + STR(@srcVATRate15Include) + ' / ' + STR(@trgVATRate15Include)
  END
  IF (@srcVATRate15Spare2 <> @trgVATRate15Spare2) Or ((@srcVATRate15Spare2 IS NULL) And (@trgVATRate15Spare2 IS NOT NULL)) Or ((@srcVATRate15Spare2 IS NOT NULL) And (@trgVATRate15Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate15Spare2 is different'
  END
  IF (@srcVATRate16Code <> @trgVATRate16Code) Or ((@srcVATRate16Code IS NULL) And (@trgVATRate16Code IS NOT NULL)) Or ((@srcVATRate16Code IS NOT NULL) And (@trgVATRate16Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate16Code = ' + @srcVATRate16Code + ' / ' + @trgVATRate16Code
  END
  IF (@srcVATRate16Desc <> @trgVATRate16Desc) Or ((@srcVATRate16Desc IS NULL) And (@trgVATRate16Desc IS NOT NULL)) Or ((@srcVATRate16Desc IS NOT NULL) And (@trgVATRate16Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate16Desc = ' + @srcVATRate16Desc + ' / ' + @trgVATRate16Desc
  END
  IF (@srcVATRate16Rate <> @trgVATRate16Rate) Or ((@srcVATRate16Rate IS NULL) And (@trgVATRate16Rate IS NOT NULL)) Or ((@srcVATRate16Rate IS NOT NULL) And (@trgVATRate16Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate16Rate = ' + @srcVATRate16Rate + ' / ' + @trgVATRate16Rate
  END
  IF (@srcVATRate16Spare <> @trgVATRate16Spare) Or ((@srcVATRate16Spare IS NULL) And (@trgVATRate16Spare IS NOT NULL)) Or ((@srcVATRate16Spare IS NOT NULL) And (@trgVATRate16Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate16Spare is different'
  END
  IF (@srcVATRate16Include <> @trgVATRate16Include) Or ((@srcVATRate16Include IS NULL) And (@trgVATRate16Include IS NOT NULL)) Or ((@srcVATRate16Include IS NOT NULL) And (@trgVATRate16Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate16Include = ' + STR(@srcVATRate16Include) + ' / ' + STR(@trgVATRate16Include)
  END
  IF (@srcVATRate16Spare2 <> @trgVATRate16Spare2) Or ((@srcVATRate16Spare2 IS NULL) And (@trgVATRate16Spare2 IS NOT NULL)) Or ((@srcVATRate16Spare2 IS NOT NULL) And (@trgVATRate16Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate16Spare2 is different'
  END
  IF (@srcVATRate17Code <> @trgVATRate17Code) Or ((@srcVATRate17Code IS NULL) And (@trgVATRate17Code IS NOT NULL)) Or ((@srcVATRate17Code IS NOT NULL) And (@trgVATRate17Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate17Code = ' + @srcVATRate17Code + ' / ' + @trgVATRate17Code
  END
  IF (@srcVATRate17Desc <> @trgVATRate17Desc) Or ((@srcVATRate17Desc IS NULL) And (@trgVATRate17Desc IS NOT NULL)) Or ((@srcVATRate17Desc IS NOT NULL) And (@trgVATRate17Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate17Desc = ' + @srcVATRate17Desc + ' / ' + @trgVATRate17Desc
  END
  IF (@srcVATRate17Rate <> @trgVATRate17Rate) Or ((@srcVATRate17Rate IS NULL) And (@trgVATRate17Rate IS NOT NULL)) Or ((@srcVATRate17Rate IS NOT NULL) And (@trgVATRate17Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate17Rate = ' + @srcVATRate17Rate + ' / ' + @trgVATRate17Rate
  END
  IF (@srcVATRate17Spare <> @trgVATRate17Spare) Or ((@srcVATRate17Spare IS NULL) And (@trgVATRate17Spare IS NOT NULL)) Or ((@srcVATRate17Spare IS NOT NULL) And (@trgVATRate17Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate17Spare is different'
  END
  IF (@srcVATRate17Include <> @trgVATRate17Include) Or ((@srcVATRate17Include IS NULL) And (@trgVATRate17Include IS NOT NULL)) Or ((@srcVATRate17Include IS NOT NULL) And (@trgVATRate17Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate17Include = ' + STR(@srcVATRate17Include) + ' / ' + STR(@trgVATRate17Include)
  END
  IF (@srcVATRate17Spare2 <> @trgVATRate17Spare2) Or ((@srcVATRate17Spare2 IS NULL) And (@trgVATRate17Spare2 IS NOT NULL)) Or ((@srcVATRate17Spare2 IS NOT NULL) And (@trgVATRate17Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate17Spare2 is different'
  END
  IF (@srcVATRate18Code <> @trgVATRate18Code) Or ((@srcVATRate18Code IS NULL) And (@trgVATRate18Code IS NOT NULL)) Or ((@srcVATRate18Code IS NOT NULL) And (@trgVATRate18Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate18Code = ' + @srcVATRate18Code + ' / ' + @trgVATRate18Code
  END
  IF (@srcVATRate18Desc <> @trgVATRate18Desc) Or ((@srcVATRate18Desc IS NULL) And (@trgVATRate18Desc IS NOT NULL)) Or ((@srcVATRate18Desc IS NOT NULL) And (@trgVATRate18Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate18Desc = ' + @srcVATRate18Desc + ' / ' + @trgVATRate18Desc
  END
  IF (@srcVATRate18Rate <> @trgVATRate18Rate) Or ((@srcVATRate18Rate IS NULL) And (@trgVATRate18Rate IS NOT NULL)) Or ((@srcVATRate18Rate IS NOT NULL) And (@trgVATRate18Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate18Rate = ' + @srcVATRate18Rate + ' / ' + @trgVATRate18Rate
  END
  IF (@srcVATRate18Spare <> @trgVATRate18Spare) Or ((@srcVATRate18Spare IS NULL) And (@trgVATRate18Spare IS NOT NULL)) Or ((@srcVATRate18Spare IS NOT NULL) And (@trgVATRate18Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate18Spare is different'
  END
  IF (@srcVATRate18Include <> @trgVATRate18Include) Or ((@srcVATRate18Include IS NULL) And (@trgVATRate18Include IS NOT NULL)) Or ((@srcVATRate18Include IS NOT NULL) And (@trgVATRate18Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate18Include = ' + STR(@srcVATRate18Include) + ' / ' + STR(@trgVATRate18Include)
  END
  IF (@srcVATRate18Spare2 <> @trgVATRate18Spare2) Or ((@srcVATRate18Spare2 IS NULL) And (@trgVATRate18Spare2 IS NOT NULL)) Or ((@srcVATRate18Spare2 IS NOT NULL) And (@trgVATRate18Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATRate18Spare2 is different'
  END
  IF (@srcVATIAdjCode <> @trgVATIAdjCode) Or ((@srcVATIAdjCode IS NULL) And (@trgVATIAdjCode IS NOT NULL)) Or ((@srcVATIAdjCode IS NOT NULL) And (@trgVATIAdjCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATIAdjCode = ' + @srcVATIAdjCode + ' / ' + @trgVATIAdjCode
  END
  IF (@srcVATIAdjDesc <> @trgVATIAdjDesc) Or ((@srcVATIAdjDesc IS NULL) And (@trgVATIAdjDesc IS NOT NULL)) Or ((@srcVATIAdjDesc IS NOT NULL) And (@trgVATIAdjDesc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATIAdjDesc = ' + @srcVATIAdjDesc + ' / ' + @trgVATIAdjDesc
  END
  IF (@srcVATIAdjRate <> @trgVATIAdjRate) Or ((@srcVATIAdjRate IS NULL) And (@trgVATIAdjRate IS NOT NULL)) Or ((@srcVATIAdjRate IS NOT NULL) And (@trgVATIAdjRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATIAdjRate = ' + @srcVATIAdjRate + ' / ' + @trgVATIAdjRate
  END
  IF (@srcVATIAdjSpare <> @trgVATIAdjSpare) Or ((@srcVATIAdjSpare IS NULL) And (@trgVATIAdjSpare IS NOT NULL)) Or ((@srcVATIAdjSpare IS NOT NULL) And (@trgVATIAdjSpare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATIAdjSpare is different'
  END
  IF (@srcVATIAdjInclude <> @trgVATIAdjInclude) Or ((@srcVATIAdjInclude IS NULL) And (@trgVATIAdjInclude IS NOT NULL)) Or ((@srcVATIAdjInclude IS NOT NULL) And (@trgVATIAdjInclude IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATIAdjInclude = ' + STR(@srcVATIAdjInclude) + ' / ' + STR(@trgVATIAdjInclude)
  END
  IF (@srcVATIAdjSpare2 <> @trgVATIAdjSpare2) Or ((@srcVATIAdjSpare2 IS NULL) And (@trgVATIAdjSpare2 IS NOT NULL)) Or ((@srcVATIAdjSpare2 IS NOT NULL) And (@trgVATIAdjSpare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATIAdjSpare2 is different'
  END
  IF (@srcVATOAdjCode <> @trgVATOAdjCode) Or ((@srcVATOAdjCode IS NULL) And (@trgVATOAdjCode IS NOT NULL)) Or ((@srcVATOAdjCode IS NOT NULL) And (@trgVATOAdjCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATOAdjCode = ' + @srcVATOAdjCode + ' / ' + @trgVATOAdjCode
  END
  IF (@srcVATOAdjDesc <> @trgVATOAdjDesc) Or ((@srcVATOAdjDesc IS NULL) And (@trgVATOAdjDesc IS NOT NULL)) Or ((@srcVATOAdjDesc IS NOT NULL) And (@trgVATOAdjDesc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATOAdjDesc = ' + @srcVATOAdjDesc + ' / ' + @trgVATOAdjDesc
  END
  IF (@srcVATOAdjRate <> @trgVATOAdjRate) Or ((@srcVATOAdjRate IS NULL) And (@trgVATOAdjRate IS NOT NULL)) Or ((@srcVATOAdjRate IS NOT NULL) And (@trgVATOAdjRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATOAdjRate = ' + @srcVATOAdjRate + ' / ' + @trgVATOAdjRate
  END
  IF (@srcVATOAdjSpare <> @trgVATOAdjSpare) Or ((@srcVATOAdjSpare IS NULL) And (@trgVATOAdjSpare IS NOT NULL)) Or ((@srcVATOAdjSpare IS NOT NULL) And (@trgVATOAdjSpare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATOAdjSpare is different'
  END
  IF (@srcVATOAdjInclude <> @trgVATOAdjInclude) Or ((@srcVATOAdjInclude IS NULL) And (@trgVATOAdjInclude IS NOT NULL)) Or ((@srcVATOAdjInclude IS NOT NULL) And (@trgVATOAdjInclude IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATOAdjInclude = ' + STR(@srcVATOAdjInclude) + ' / ' + STR(@trgVATOAdjInclude)
  END
  IF (@srcVATOAdjSpare2 <> @trgVATOAdjSpare2) Or ((@srcVATOAdjSpare2 IS NULL) And (@trgVATOAdjSpare2 IS NOT NULL)) Or ((@srcVATOAdjSpare2 IS NOT NULL) And (@trgVATOAdjSpare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATOAdjSpare2 is different'
  END
  IF (@srcVATSpare8Code <> @trgVATSpare8Code) Or ((@srcVATSpare8Code IS NULL) And (@trgVATSpare8Code IS NOT NULL)) Or ((@srcVATSpare8Code IS NOT NULL) And (@trgVATSpare8Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATSpare8Code = ' + @srcVATSpare8Code + ' / ' + @trgVATSpare8Code
  END
  IF (@srcVATSpare8Desc <> @trgVATSpare8Desc) Or ((@srcVATSpare8Desc IS NULL) And (@trgVATSpare8Desc IS NOT NULL)) Or ((@srcVATSpare8Desc IS NOT NULL) And (@trgVATSpare8Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATSpare8Desc = ' + @srcVATSpare8Desc + ' / ' + @trgVATSpare8Desc
  END
  IF (@srcVATSpare8Rate <> @trgVATSpare8Rate) Or ((@srcVATSpare8Rate IS NULL) And (@trgVATSpare8Rate IS NOT NULL)) Or ((@srcVATSpare8Rate IS NOT NULL) And (@trgVATSpare8Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATSpare8Rate = ' + @srcVATSpare8Rate + ' / ' + @trgVATSpare8Rate
  END
  IF (@srcVATSpare8Spare <> @trgVATSpare8Spare) Or ((@srcVATSpare8Spare IS NULL) And (@trgVATSpare8Spare IS NOT NULL)) Or ((@srcVATSpare8Spare IS NOT NULL) And (@trgVATSpare8Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATSpare8Spare is different'
  END
  IF (@srcVATSpare8Include <> @trgVATSpare8Include) Or ((@srcVATSpare8Include IS NULL) And (@trgVATSpare8Include IS NOT NULL)) Or ((@srcVATSpare8Include IS NOT NULL) And (@trgVATSpare8Include IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATSpare8Include = ' + STR(@srcVATSpare8Include) + ' / ' + STR(@trgVATSpare8Include)
  END
  IF (@srcVATSpare8Spare2 <> @trgVATSpare8Spare2) Or ((@srcVATSpare8Spare2 IS NULL) And (@trgVATSpare8Spare2 IS NOT NULL)) Or ((@srcVATSpare8Spare2 IS NOT NULL) And (@trgVATSpare8Spare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATSpare8Spare2 is different'
  END
  IF (@srcHideUDF7 <> @trgHideUDF7) Or ((@srcHideUDF7 IS NULL) And (@trgHideUDF7 IS NOT NULL)) Or ((@srcHideUDF7 IS NOT NULL) And (@trgHideUDF7 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.HideUDF7 = ' + STR(@srcHideUDF7) + ' / ' + STR(@trgHideUDF7)
  END
  IF (@srcHideUDF8 <> @trgHideUDF8) Or ((@srcHideUDF8 IS NULL) And (@trgHideUDF8 IS NOT NULL)) Or ((@srcHideUDF8 IS NOT NULL) And (@trgHideUDF8 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.HideUDF8 = ' + STR(@srcHideUDF8) + ' / ' + STR(@trgHideUDF8)
  END
  IF (@srcHideUDF9 <> @trgHideUDF9) Or ((@srcHideUDF9 IS NULL) And (@trgHideUDF9 IS NOT NULL)) Or ((@srcHideUDF9 IS NOT NULL) And (@trgHideUDF9 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.HideUDF9 = ' + STR(@srcHideUDF9) + ' / ' + STR(@trgHideUDF9)
  END
  IF (@srcHideUDF10 <> @trgHideUDF10) Or ((@srcHideUDF10 IS NULL) And (@trgHideUDF10 IS NOT NULL)) Or ((@srcHideUDF10 IS NOT NULL) And (@trgHideUDF10 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.HideUDF10 = ' + STR(@srcHideUDF10) + ' / ' + STR(@trgHideUDF10)
  END
  IF (@srcHideUDF11 <> @trgHideUDF11) Or ((@srcHideUDF11 IS NULL) And (@trgHideUDF11 IS NOT NULL)) Or ((@srcHideUDF11 IS NOT NULL) And (@trgHideUDF11 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.HideUDF11 = ' + STR(@srcHideUDF11) + ' / ' + STR(@trgHideUDF11)
  END
  IF (@srcSpare2 <> @trgSpare2) Or ((@srcSpare2 IS NULL) And (@trgSpare2 IS NOT NULL)) Or ((@srcSpare2 IS NOT NULL) And (@trgSpare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.Spare2 is different'
  END
  IF (@srcVATInterval <> @trgVATInterval) Or ((@srcVATInterval IS NULL) And (@trgVATInterval IS NOT NULL)) Or ((@srcVATInterval IS NOT NULL) And (@trgVATInterval IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATInterval = ' + STR(@srcVATInterval) + ' / ' + STR(@trgVATInterval)
  END
  IF (@srcSpare3 <> @trgSpare3) Or ((@srcSpare3 IS NULL) And (@trgSpare3 IS NOT NULL)) Or ((@srcSpare3 IS NOT NULL) And (@trgSpare3 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.Spare3 is different'
  END
  IF (@srcVATScheme <> @trgVATScheme) Or ((@srcVATScheme IS NULL) And (@trgVATScheme IS NOT NULL)) Or ((@srcVATScheme IS NOT NULL) And (@trgVATScheme IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATScheme = ' + @srcVATScheme + ' / ' + @trgVATScheme
  END
  IF (@srcOLastECSalesDate <> @trgOLastECSalesDate) Or ((@srcOLastECSalesDate IS NULL) And (@trgOLastECSalesDate IS NOT NULL)) Or ((@srcOLastECSalesDate IS NOT NULL) And (@trgOLastECSalesDate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.OLastECSalesDate = ' + @srcOLastECSalesDate + ' / ' + @trgOLastECSalesDate
  END
  IF (@srcVATReturnDate <> @trgVATReturnDate) Or ((@srcVATReturnDate IS NULL) And (@trgVATReturnDate IS NOT NULL)) Or ((@srcVATReturnDate IS NOT NULL) And (@trgVATReturnDate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VATReturnDate = ' + @srcVATReturnDate + ' / ' + @trgVATReturnDate
  END
  IF (@srcLastECSalesDate <> @trgLastECSalesDate) Or ((@srcLastECSalesDate IS NULL) And (@trgLastECSalesDate IS NOT NULL)) Or ((@srcLastECSalesDate IS NOT NULL) And (@trgLastECSalesDate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.LastECSalesDate = ' + @srcLastECSalesDate + ' / ' + @trgLastECSalesDate
  END
  IF (@srcCurrPeriod <> @trgCurrPeriod) Or ((@srcCurrPeriod IS NULL) And (@trgCurrPeriod IS NOT NULL)) Or ((@srcCurrPeriod IS NOT NULL) And (@trgCurrPeriod IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CurrPeriod = ' + @srcCurrPeriod + ' / ' + @trgCurrPeriod
  END
  IF (@srcUDFCaption1 <> @trgUDFCaption1) Or ((@srcUDFCaption1 IS NULL) And (@trgUDFCaption1 IS NOT NULL)) Or ((@srcUDFCaption1 IS NOT NULL) And (@trgUDFCaption1 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption1 = ' + @srcUDFCaption1 + ' / ' + @trgUDFCaption1
  END
  IF (@srcUDFCaption2 <> @trgUDFCaption2) Or ((@srcUDFCaption2 IS NULL) And (@trgUDFCaption2 IS NOT NULL)) Or ((@srcUDFCaption2 IS NOT NULL) And (@trgUDFCaption2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption2 = ' + @srcUDFCaption2 + ' / ' + @trgUDFCaption2
  END
  IF (@srcUDFCaption3 <> @trgUDFCaption3) Or ((@srcUDFCaption3 IS NULL) And (@trgUDFCaption3 IS NOT NULL)) Or ((@srcUDFCaption3 IS NOT NULL) And (@trgUDFCaption3 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption3 = ' + @srcUDFCaption3 + ' / ' + @trgUDFCaption3
  END
  IF (@srcUDFCaption4 <> @trgUDFCaption4) Or ((@srcUDFCaption4 IS NULL) And (@trgUDFCaption4 IS NOT NULL)) Or ((@srcUDFCaption4 IS NOT NULL) And (@trgUDFCaption4 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption4 = ' + @srcUDFCaption4 + ' / ' + @trgUDFCaption4
  END
  IF (@srcUDFCaption5 <> @trgUDFCaption5) Or ((@srcUDFCaption5 IS NULL) And (@trgUDFCaption5 IS NOT NULL)) Or ((@srcUDFCaption5 IS NOT NULL) And (@trgUDFCaption5 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption5 = ' + @srcUDFCaption5 + ' / ' + @trgUDFCaption5
  END
  IF (@srcUDFCaption6 <> @trgUDFCaption6) Or ((@srcUDFCaption6 IS NULL) And (@trgUDFCaption6 IS NOT NULL)) Or ((@srcUDFCaption6 IS NOT NULL) And (@trgUDFCaption6 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption6 = ' + @srcUDFCaption6 + ' / ' + @trgUDFCaption6
  END
  IF (@srcUDFCaption7 <> @trgUDFCaption7) Or ((@srcUDFCaption7 IS NULL) And (@trgUDFCaption7 IS NOT NULL)) Or ((@srcUDFCaption7 IS NOT NULL) And (@trgUDFCaption7 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption7 = ' + @srcUDFCaption7 + ' / ' + @trgUDFCaption7
  END
  IF (@srcUDFCaption8 <> @trgUDFCaption8) Or ((@srcUDFCaption8 IS NULL) And (@trgUDFCaption8 IS NOT NULL)) Or ((@srcUDFCaption8 IS NOT NULL) And (@trgUDFCaption8 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption8 = ' + @srcUDFCaption8 + ' / ' + @trgUDFCaption8
  END
  IF (@srcUDFCaption9 <> @trgUDFCaption9) Or ((@srcUDFCaption9 IS NULL) And (@trgUDFCaption9 IS NOT NULL)) Or ((@srcUDFCaption9 IS NOT NULL) And (@trgUDFCaption9 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption9 = ' + @srcUDFCaption9 + ' / ' + @trgUDFCaption9
  END
  IF (@srcUDFCaption10 <> @trgUDFCaption10) Or ((@srcUDFCaption10 IS NULL) And (@trgUDFCaption10 IS NOT NULL)) Or ((@srcUDFCaption10 IS NOT NULL) And (@trgUDFCaption10 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption10 = ' + @srcUDFCaption10 + ' / ' + @trgUDFCaption10
  END
  IF (@srcUDFCaption11 <> @trgUDFCaption11) Or ((@srcUDFCaption11 IS NULL) And (@trgUDFCaption11 IS NOT NULL)) Or ((@srcUDFCaption11 IS NOT NULL) And (@trgUDFCaption11 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption11 = ' + @srcUDFCaption11 + ' / ' + @trgUDFCaption11
  END
  IF (@srcUDFCaption12 <> @trgUDFCaption12) Or ((@srcUDFCaption12 IS NULL) And (@trgUDFCaption12 IS NOT NULL)) Or ((@srcUDFCaption12 IS NOT NULL) And (@trgUDFCaption12 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption12 = ' + @srcUDFCaption12 + ' / ' + @trgUDFCaption12
  END
  IF (@srcUDFCaption13 <> @trgUDFCaption13) Or ((@srcUDFCaption13 IS NULL) And (@trgUDFCaption13 IS NOT NULL)) Or ((@srcUDFCaption13 IS NOT NULL) And (@trgUDFCaption13 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption13 = ' + @srcUDFCaption13 + ' / ' + @trgUDFCaption13
  END
  IF (@srcUDFCaption14 <> @trgUDFCaption14) Or ((@srcUDFCaption14 IS NULL) And (@trgUDFCaption14 IS NOT NULL)) Or ((@srcUDFCaption14 IS NOT NULL) And (@trgUDFCaption14 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption14 = ' + @srcUDFCaption14 + ' / ' + @trgUDFCaption14
  END
  IF (@srcUDFCaption15 <> @trgUDFCaption15) Or ((@srcUDFCaption15 IS NULL) And (@trgUDFCaption15 IS NOT NULL)) Or ((@srcUDFCaption15 IS NOT NULL) And (@trgUDFCaption15 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption15 = ' + @srcUDFCaption15 + ' / ' + @trgUDFCaption15
  END
  IF (@srcUDFCaption16 <> @trgUDFCaption16) Or ((@srcUDFCaption16 IS NULL) And (@trgUDFCaption16 IS NOT NULL)) Or ((@srcUDFCaption16 IS NOT NULL) And (@trgUDFCaption16 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption16 = ' + @srcUDFCaption16 + ' / ' + @trgUDFCaption16
  END
  IF (@srcUDFCaption17 <> @trgUDFCaption17) Or ((@srcUDFCaption17 IS NULL) And (@trgUDFCaption17 IS NOT NULL)) Or ((@srcUDFCaption17 IS NOT NULL) And (@trgUDFCaption17 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption17 = ' + @srcUDFCaption17 + ' / ' + @trgUDFCaption17
  END
  IF (@srcUDFCaption18 <> @trgUDFCaption18) Or ((@srcUDFCaption18 IS NULL) And (@trgUDFCaption18 IS NOT NULL)) Or ((@srcUDFCaption18 IS NOT NULL) And (@trgUDFCaption18 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption18 = ' + @srcUDFCaption18 + ' / ' + @trgUDFCaption18
  END
  IF (@srcUDFCaption19 <> @trgUDFCaption19) Or ((@srcUDFCaption19 IS NULL) And (@trgUDFCaption19 IS NOT NULL)) Or ((@srcUDFCaption19 IS NOT NULL) And (@trgUDFCaption19 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption19 = ' + @srcUDFCaption19 + ' / ' + @trgUDFCaption19
  END
  IF (@srcUDFCaption20 <> @trgUDFCaption20) Or ((@srcUDFCaption20 IS NULL) And (@trgUDFCaption20 IS NOT NULL)) Or ((@srcUDFCaption20 IS NOT NULL) And (@trgUDFCaption20 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption20 = ' + @srcUDFCaption20 + ' / ' + @trgUDFCaption20
  END
  IF (@srcUDFCaption21 <> @trgUDFCaption21) Or ((@srcUDFCaption21 IS NULL) And (@trgUDFCaption21 IS NOT NULL)) Or ((@srcUDFCaption21 IS NOT NULL) And (@trgUDFCaption21 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption21 = ' + @srcUDFCaption21 + ' / ' + @trgUDFCaption21
  END
  IF (@srcUDFCaption22 <> @trgUDFCaption22) Or ((@srcUDFCaption22 IS NULL) And (@trgUDFCaption22 IS NOT NULL)) Or ((@srcUDFCaption22 IS NOT NULL) And (@trgUDFCaption22 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.UDFCaption22 = ' + @srcUDFCaption22 + ' / ' + @trgUDFCaption22
  END
  IF (@srcHideLType0 <> @trgHideLType0) Or ((@srcHideLType0 IS NULL) And (@trgHideLType0 IS NOT NULL)) Or ((@srcHideLType0 IS NOT NULL) And (@trgHideLType0 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.HideLType0 = ' + STR(@srcHideLType0) + ' / ' + STR(@trgHideLType0)
  END
  IF (@srcHideLType1 <> @trgHideLType1) Or ((@srcHideLType1 IS NULL) And (@trgHideLType1 IS NOT NULL)) Or ((@srcHideLType1 IS NOT NULL) And (@trgHideLType1 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.HideLType1 = ' + STR(@srcHideLType1) + ' / ' + STR(@trgHideLType1)
  END
  IF (@srcHideLType2 <> @trgHideLType2) Or ((@srcHideLType2 IS NULL) And (@trgHideLType2 IS NOT NULL)) Or ((@srcHideLType2 IS NOT NULL) And (@trgHideLType2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.HideLType2 = ' + STR(@srcHideLType2) + ' / ' + STR(@trgHideLType2)
  END
  IF (@srcHideLType3 <> @trgHideLType3) Or ((@srcHideLType3 IS NULL) And (@trgHideLType3 IS NOT NULL)) Or ((@srcHideLType3 IS NOT NULL) And (@trgHideLType3 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.HideLType3 = ' + STR(@srcHideLType3) + ' / ' + STR(@trgHideLType3)
  END
  IF (@srcHideLType4 <> @trgHideLType4) Or ((@srcHideLType4 IS NULL) And (@trgHideLType4 IS NOT NULL)) Or ((@srcHideLType4 IS NOT NULL) And (@trgHideLType4 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.HideLType4 = ' + STR(@srcHideLType4) + ' / ' + STR(@trgHideLType4)
  END
  IF (@srcHideLType5 <> @trgHideLType5) Or ((@srcHideLType5 IS NULL) And (@trgHideLType5 IS NOT NULL)) Or ((@srcHideLType5 IS NOT NULL) And (@trgHideLType5 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.HideLType5 = ' + STR(@srcHideLType5) + ' / ' + STR(@trgHideLType5)
  END
  IF (@srcHideLType6 <> @trgHideLType6) Or ((@srcHideLType6 IS NULL) And (@trgHideLType6 IS NOT NULL)) Or ((@srcHideLType6 IS NOT NULL) And (@trgHideLType6 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.HideLType6 = ' + STR(@srcHideLType6) + ' / ' + STR(@trgHideLType6)
  END
  IF (@srcReportPrnN <> @trgReportPrnN) Or ((@srcReportPrnN IS NULL) And (@trgReportPrnN IS NOT NULL)) Or ((@srcReportPrnN IS NOT NULL) And (@trgReportPrnN IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ReportPrnN = ' + @srcReportPrnN + ' / ' + @trgReportPrnN
  END
  IF (@srcFormsPrnN <> @trgFormsPrnN) Or ((@srcFormsPrnN IS NULL) And (@trgFormsPrnN IS NOT NULL)) Or ((@srcFormsPrnN IS NOT NULL) And (@trgFormsPrnN IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.FormsPrnN = ' + @srcFormsPrnN + ' / ' + @trgFormsPrnN
  END
  IF (@srcEnableECServices <> @trgEnableECServices) Or ((@srcEnableECServices IS NULL) And (@trgEnableECServices IS NOT NULL)) Or ((@srcEnableECServices IS NOT NULL) And (@trgEnableECServices IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.EnableECServices = ' + STR(@srcEnableECServices) + ' / ' + STR(@trgEnableECServices)
  END
  IF (@srcECSalesThreshold <> @trgECSalesThreshold) Or ((@srcECSalesThreshold IS NULL) And (@trgECSalesThreshold IS NOT NULL)) Or ((@srcECSalesThreshold IS NOT NULL) And (@trgECSalesThreshold IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ECSalesThreshold = ' + @srcECSalesThreshold + ' / ' + @trgECSalesThreshold
  END
  IF (@srcMainCurrency00ScreenSymbol <> @trgMainCurrency00ScreenSymbol) Or ((@srcMainCurrency00ScreenSymbol IS NULL) And (@trgMainCurrency00ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency00ScreenSymbol IS NOT NULL) And (@trgMainCurrency00ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency00ScreenSymbol = ' + @srcMainCurrency00ScreenSymbol + ' / ' + @trgMainCurrency00ScreenSymbol
  END
  IF (@srcMainCurrency00Desc <> @trgMainCurrency00Desc) Or ((@srcMainCurrency00Desc IS NULL) And (@trgMainCurrency00Desc IS NOT NULL)) Or ((@srcMainCurrency00Desc IS NOT NULL) And (@trgMainCurrency00Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency00Desc = ' + @srcMainCurrency00Desc + ' / ' + @trgMainCurrency00Desc
  END
  IF (@srcMainCurrency00CompanyRate <> @trgMainCurrency00CompanyRate) Or ((@srcMainCurrency00CompanyRate IS NULL) And (@trgMainCurrency00CompanyRate IS NOT NULL)) Or ((@srcMainCurrency00CompanyRate IS NOT NULL) And (@trgMainCurrency00CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency00CompanyRate = ' + @srcMainCurrency00CompanyRate + ' / ' + @trgMainCurrency00CompanyRate
  END
  IF (@srcMainCurrency00DailyRate <> @trgMainCurrency00DailyRate) Or ((@srcMainCurrency00DailyRate IS NULL) And (@trgMainCurrency00DailyRate IS NOT NULL)) Or ((@srcMainCurrency00DailyRate IS NOT NULL) And (@trgMainCurrency00DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency00DailyRate = ' + @srcMainCurrency00DailyRate + ' / ' + @trgMainCurrency00DailyRate
  END
  IF (@srcMainCurrency00PrintSymbol <> @trgMainCurrency00PrintSymbol) Or ((@srcMainCurrency00PrintSymbol IS NULL) And (@trgMainCurrency00PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency00PrintSymbol IS NOT NULL) And (@trgMainCurrency00PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency00PrintSymbol = ' + @srcMainCurrency00PrintSymbol + ' / ' + @trgMainCurrency00PrintSymbol
  END
  IF (@srcMainCurrency01ScreenSymbol <> @trgMainCurrency01ScreenSymbol) Or ((@srcMainCurrency01ScreenSymbol IS NULL) And (@trgMainCurrency01ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency01ScreenSymbol IS NOT NULL) And (@trgMainCurrency01ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency01ScreenSymbol = ' + @srcMainCurrency01ScreenSymbol + ' / ' + @trgMainCurrency01ScreenSymbol
  END
  IF (@srcMainCurrency01Desc <> @trgMainCurrency01Desc) Or ((@srcMainCurrency01Desc IS NULL) And (@trgMainCurrency01Desc IS NOT NULL)) Or ((@srcMainCurrency01Desc IS NOT NULL) And (@trgMainCurrency01Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency01Desc = ' + @srcMainCurrency01Desc + ' / ' + @trgMainCurrency01Desc
  END
  IF (@srcMainCurrency01CompanyRate <> @trgMainCurrency01CompanyRate) Or ((@srcMainCurrency01CompanyRate IS NULL) And (@trgMainCurrency01CompanyRate IS NOT NULL)) Or ((@srcMainCurrency01CompanyRate IS NOT NULL) And (@trgMainCurrency01CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency01CompanyRate = ' + @srcMainCurrency01CompanyRate + ' / ' + @trgMainCurrency01CompanyRate
  END
  IF (@srcMainCurrency01DailyRate <> @trgMainCurrency01DailyRate) Or ((@srcMainCurrency01DailyRate IS NULL) And (@trgMainCurrency01DailyRate IS NOT NULL)) Or ((@srcMainCurrency01DailyRate IS NOT NULL) And (@trgMainCurrency01DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency01DailyRate = ' + @srcMainCurrency01DailyRate + ' / ' + @trgMainCurrency01DailyRate
  END
  IF (@srcMainCurrency01PrintSymbol <> @trgMainCurrency01PrintSymbol) Or ((@srcMainCurrency01PrintSymbol IS NULL) And (@trgMainCurrency01PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency01PrintSymbol IS NOT NULL) And (@trgMainCurrency01PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency01PrintSymbol = ' + @srcMainCurrency01PrintSymbol + ' / ' + @trgMainCurrency01PrintSymbol
  END
  IF (@srcMainCurrency02ScreenSymbol <> @trgMainCurrency02ScreenSymbol) Or ((@srcMainCurrency02ScreenSymbol IS NULL) And (@trgMainCurrency02ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency02ScreenSymbol IS NOT NULL) And (@trgMainCurrency02ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency02ScreenSymbol = ' + @srcMainCurrency02ScreenSymbol + ' / ' + @trgMainCurrency02ScreenSymbol
  END
  IF (@srcMainCurrency02Desc <> @trgMainCurrency02Desc) Or ((@srcMainCurrency02Desc IS NULL) And (@trgMainCurrency02Desc IS NOT NULL)) Or ((@srcMainCurrency02Desc IS NOT NULL) And (@trgMainCurrency02Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency02Desc = ' + @srcMainCurrency02Desc + ' / ' + @trgMainCurrency02Desc
  END
  IF (@srcMainCurrency02CompanyRate <> @trgMainCurrency02CompanyRate) Or ((@srcMainCurrency02CompanyRate IS NULL) And (@trgMainCurrency02CompanyRate IS NOT NULL)) Or ((@srcMainCurrency02CompanyRate IS NOT NULL) And (@trgMainCurrency02CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency02CompanyRate = ' + @srcMainCurrency02CompanyRate + ' / ' + @trgMainCurrency02CompanyRate
  END
  IF (@srcMainCurrency02DailyRate <> @trgMainCurrency02DailyRate) Or ((@srcMainCurrency02DailyRate IS NULL) And (@trgMainCurrency02DailyRate IS NOT NULL)) Or ((@srcMainCurrency02DailyRate IS NOT NULL) And (@trgMainCurrency02DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency02DailyRate = ' + @srcMainCurrency02DailyRate + ' / ' + @trgMainCurrency02DailyRate
  END
  IF (@srcMainCurrency02PrintSymbol <> @trgMainCurrency02PrintSymbol) Or ((@srcMainCurrency02PrintSymbol IS NULL) And (@trgMainCurrency02PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency02PrintSymbol IS NOT NULL) And (@trgMainCurrency02PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency02PrintSymbol = ' + @srcMainCurrency02PrintSymbol + ' / ' + @trgMainCurrency02PrintSymbol
  END
  IF (@srcMainCurrency03ScreenSymbol <> @trgMainCurrency03ScreenSymbol) Or ((@srcMainCurrency03ScreenSymbol IS NULL) And (@trgMainCurrency03ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency03ScreenSymbol IS NOT NULL) And (@trgMainCurrency03ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency03ScreenSymbol = ' + @srcMainCurrency03ScreenSymbol + ' / ' + @trgMainCurrency03ScreenSymbol
  END
  IF (@srcMainCurrency03Desc <> @trgMainCurrency03Desc) Or ((@srcMainCurrency03Desc IS NULL) And (@trgMainCurrency03Desc IS NOT NULL)) Or ((@srcMainCurrency03Desc IS NOT NULL) And (@trgMainCurrency03Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency03Desc = ' + @srcMainCurrency03Desc + ' / ' + @trgMainCurrency03Desc
  END
  IF (@srcMainCurrency03CompanyRate <> @trgMainCurrency03CompanyRate) Or ((@srcMainCurrency03CompanyRate IS NULL) And (@trgMainCurrency03CompanyRate IS NOT NULL)) Or ((@srcMainCurrency03CompanyRate IS NOT NULL) And (@trgMainCurrency03CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency03CompanyRate = ' + @srcMainCurrency03CompanyRate + ' / ' + @trgMainCurrency03CompanyRate
  END
  IF (@srcMainCurrency03DailyRate <> @trgMainCurrency03DailyRate) Or ((@srcMainCurrency03DailyRate IS NULL) And (@trgMainCurrency03DailyRate IS NOT NULL)) Or ((@srcMainCurrency03DailyRate IS NOT NULL) And (@trgMainCurrency03DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency03DailyRate = ' + @srcMainCurrency03DailyRate + ' / ' + @trgMainCurrency03DailyRate
  END
  IF (@srcMainCurrency03PrintSymbol <> @trgMainCurrency03PrintSymbol) Or ((@srcMainCurrency03PrintSymbol IS NULL) And (@trgMainCurrency03PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency03PrintSymbol IS NOT NULL) And (@trgMainCurrency03PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency03PrintSymbol = ' + @srcMainCurrency03PrintSymbol + ' / ' + @trgMainCurrency03PrintSymbol
  END
  IF (@srcMainCurrency04ScreenSymbol <> @trgMainCurrency04ScreenSymbol) Or ((@srcMainCurrency04ScreenSymbol IS NULL) And (@trgMainCurrency04ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency04ScreenSymbol IS NOT NULL) And (@trgMainCurrency04ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency04ScreenSymbol = ' + @srcMainCurrency04ScreenSymbol + ' / ' + @trgMainCurrency04ScreenSymbol
  END
  IF (@srcMainCurrency04Desc <> @trgMainCurrency04Desc) Or ((@srcMainCurrency04Desc IS NULL) And (@trgMainCurrency04Desc IS NOT NULL)) Or ((@srcMainCurrency04Desc IS NOT NULL) And (@trgMainCurrency04Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency04Desc = ' + @srcMainCurrency04Desc + ' / ' + @trgMainCurrency04Desc
  END
  IF (@srcMainCurrency04CompanyRate <> @trgMainCurrency04CompanyRate) Or ((@srcMainCurrency04CompanyRate IS NULL) And (@trgMainCurrency04CompanyRate IS NOT NULL)) Or ((@srcMainCurrency04CompanyRate IS NOT NULL) And (@trgMainCurrency04CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency04CompanyRate = ' + @srcMainCurrency04CompanyRate + ' / ' + @trgMainCurrency04CompanyRate
  END
  IF (@srcMainCurrency04DailyRate <> @trgMainCurrency04DailyRate) Or ((@srcMainCurrency04DailyRate IS NULL) And (@trgMainCurrency04DailyRate IS NOT NULL)) Or ((@srcMainCurrency04DailyRate IS NOT NULL) And (@trgMainCurrency04DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency04DailyRate = ' + @srcMainCurrency04DailyRate + ' / ' + @trgMainCurrency04DailyRate
  END
  IF (@srcMainCurrency04PrintSymbol <> @trgMainCurrency04PrintSymbol) Or ((@srcMainCurrency04PrintSymbol IS NULL) And (@trgMainCurrency04PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency04PrintSymbol IS NOT NULL) And (@trgMainCurrency04PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency04PrintSymbol = ' + @srcMainCurrency04PrintSymbol + ' / ' + @trgMainCurrency04PrintSymbol
  END
  IF (@srcMainCurrency05ScreenSymbol <> @trgMainCurrency05ScreenSymbol) Or ((@srcMainCurrency05ScreenSymbol IS NULL) And (@trgMainCurrency05ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency05ScreenSymbol IS NOT NULL) And (@trgMainCurrency05ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency05ScreenSymbol = ' + @srcMainCurrency05ScreenSymbol + ' / ' + @trgMainCurrency05ScreenSymbol
  END
  IF (@srcMainCurrency05Desc <> @trgMainCurrency05Desc) Or ((@srcMainCurrency05Desc IS NULL) And (@trgMainCurrency05Desc IS NOT NULL)) Or ((@srcMainCurrency05Desc IS NOT NULL) And (@trgMainCurrency05Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency05Desc = ' + @srcMainCurrency05Desc + ' / ' + @trgMainCurrency05Desc
  END
  IF (@srcMainCurrency05CompanyRate <> @trgMainCurrency05CompanyRate) Or ((@srcMainCurrency05CompanyRate IS NULL) And (@trgMainCurrency05CompanyRate IS NOT NULL)) Or ((@srcMainCurrency05CompanyRate IS NOT NULL) And (@trgMainCurrency05CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency05CompanyRate = ' + @srcMainCurrency05CompanyRate + ' / ' + @trgMainCurrency05CompanyRate
  END
  IF (@srcMainCurrency05DailyRate <> @trgMainCurrency05DailyRate) Or ((@srcMainCurrency05DailyRate IS NULL) And (@trgMainCurrency05DailyRate IS NOT NULL)) Or ((@srcMainCurrency05DailyRate IS NOT NULL) And (@trgMainCurrency05DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency05DailyRate = ' + @srcMainCurrency05DailyRate + ' / ' + @trgMainCurrency05DailyRate
  END
  IF (@srcMainCurrency05PrintSymbol <> @trgMainCurrency05PrintSymbol) Or ((@srcMainCurrency05PrintSymbol IS NULL) And (@trgMainCurrency05PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency05PrintSymbol IS NOT NULL) And (@trgMainCurrency05PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency05PrintSymbol = ' + @srcMainCurrency05PrintSymbol + ' / ' + @trgMainCurrency05PrintSymbol
  END
  IF (@srcMainCurrency06ScreenSymbol <> @trgMainCurrency06ScreenSymbol) Or ((@srcMainCurrency06ScreenSymbol IS NULL) And (@trgMainCurrency06ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency06ScreenSymbol IS NOT NULL) And (@trgMainCurrency06ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency06ScreenSymbol = ' + @srcMainCurrency06ScreenSymbol + ' / ' + @trgMainCurrency06ScreenSymbol
  END
  IF (@srcMainCurrency06Desc <> @trgMainCurrency06Desc) Or ((@srcMainCurrency06Desc IS NULL) And (@trgMainCurrency06Desc IS NOT NULL)) Or ((@srcMainCurrency06Desc IS NOT NULL) And (@trgMainCurrency06Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency06Desc = ' + @srcMainCurrency06Desc + ' / ' + @trgMainCurrency06Desc
  END
  IF (@srcMainCurrency06CompanyRate <> @trgMainCurrency06CompanyRate) Or ((@srcMainCurrency06CompanyRate IS NULL) And (@trgMainCurrency06CompanyRate IS NOT NULL)) Or ((@srcMainCurrency06CompanyRate IS NOT NULL) And (@trgMainCurrency06CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency06CompanyRate = ' + @srcMainCurrency06CompanyRate + ' / ' + @trgMainCurrency06CompanyRate
  END
  IF (@srcMainCurrency06DailyRate <> @trgMainCurrency06DailyRate) Or ((@srcMainCurrency06DailyRate IS NULL) And (@trgMainCurrency06DailyRate IS NOT NULL)) Or ((@srcMainCurrency06DailyRate IS NOT NULL) And (@trgMainCurrency06DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency06DailyRate = ' + @srcMainCurrency06DailyRate + ' / ' + @trgMainCurrency06DailyRate
  END
  IF (@srcMainCurrency06PrintSymbol <> @trgMainCurrency06PrintSymbol) Or ((@srcMainCurrency06PrintSymbol IS NULL) And (@trgMainCurrency06PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency06PrintSymbol IS NOT NULL) And (@trgMainCurrency06PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency06PrintSymbol = ' + @srcMainCurrency06PrintSymbol + ' / ' + @trgMainCurrency06PrintSymbol
  END
  IF (@srcMainCurrency07ScreenSymbol <> @trgMainCurrency07ScreenSymbol) Or ((@srcMainCurrency07ScreenSymbol IS NULL) And (@trgMainCurrency07ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency07ScreenSymbol IS NOT NULL) And (@trgMainCurrency07ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency07ScreenSymbol = ' + @srcMainCurrency07ScreenSymbol + ' / ' + @trgMainCurrency07ScreenSymbol
  END
  IF (@srcMainCurrency07Desc <> @trgMainCurrency07Desc) Or ((@srcMainCurrency07Desc IS NULL) And (@trgMainCurrency07Desc IS NOT NULL)) Or ((@srcMainCurrency07Desc IS NOT NULL) And (@trgMainCurrency07Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency07Desc = ' + @srcMainCurrency07Desc + ' / ' + @trgMainCurrency07Desc
  END
  IF (@srcMainCurrency07CompanyRate <> @trgMainCurrency07CompanyRate) Or ((@srcMainCurrency07CompanyRate IS NULL) And (@trgMainCurrency07CompanyRate IS NOT NULL)) Or ((@srcMainCurrency07CompanyRate IS NOT NULL) And (@trgMainCurrency07CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency07CompanyRate = ' + @srcMainCurrency07CompanyRate + ' / ' + @trgMainCurrency07CompanyRate
  END
  IF (@srcMainCurrency07DailyRate <> @trgMainCurrency07DailyRate) Or ((@srcMainCurrency07DailyRate IS NULL) And (@trgMainCurrency07DailyRate IS NOT NULL)) Or ((@srcMainCurrency07DailyRate IS NOT NULL) And (@trgMainCurrency07DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency07DailyRate = ' + @srcMainCurrency07DailyRate + ' / ' + @trgMainCurrency07DailyRate
  END
  IF (@srcMainCurrency07PrintSymbol <> @trgMainCurrency07PrintSymbol) Or ((@srcMainCurrency07PrintSymbol IS NULL) And (@trgMainCurrency07PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency07PrintSymbol IS NOT NULL) And (@trgMainCurrency07PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency07PrintSymbol = ' + @srcMainCurrency07PrintSymbol + ' / ' + @trgMainCurrency07PrintSymbol
  END
  IF (@srcMainCurrency08ScreenSymbol <> @trgMainCurrency08ScreenSymbol) Or ((@srcMainCurrency08ScreenSymbol IS NULL) And (@trgMainCurrency08ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency08ScreenSymbol IS NOT NULL) And (@trgMainCurrency08ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency08ScreenSymbol = ' + @srcMainCurrency08ScreenSymbol + ' / ' + @trgMainCurrency08ScreenSymbol
  END
  IF (@srcMainCurrency08Desc <> @trgMainCurrency08Desc) Or ((@srcMainCurrency08Desc IS NULL) And (@trgMainCurrency08Desc IS NOT NULL)) Or ((@srcMainCurrency08Desc IS NOT NULL) And (@trgMainCurrency08Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency08Desc = ' + @srcMainCurrency08Desc + ' / ' + @trgMainCurrency08Desc
  END
  IF (@srcMainCurrency08CompanyRate <> @trgMainCurrency08CompanyRate) Or ((@srcMainCurrency08CompanyRate IS NULL) And (@trgMainCurrency08CompanyRate IS NOT NULL)) Or ((@srcMainCurrency08CompanyRate IS NOT NULL) And (@trgMainCurrency08CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency08CompanyRate = ' + @srcMainCurrency08CompanyRate + ' / ' + @trgMainCurrency08CompanyRate
  END
  IF (@srcMainCurrency08DailyRate <> @trgMainCurrency08DailyRate) Or ((@srcMainCurrency08DailyRate IS NULL) And (@trgMainCurrency08DailyRate IS NOT NULL)) Or ((@srcMainCurrency08DailyRate IS NOT NULL) And (@trgMainCurrency08DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency08DailyRate = ' + @srcMainCurrency08DailyRate + ' / ' + @trgMainCurrency08DailyRate
  END
  IF (@srcMainCurrency08PrintSymbol <> @trgMainCurrency08PrintSymbol) Or ((@srcMainCurrency08PrintSymbol IS NULL) And (@trgMainCurrency08PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency08PrintSymbol IS NOT NULL) And (@trgMainCurrency08PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency08PrintSymbol = ' + @srcMainCurrency08PrintSymbol + ' / ' + @trgMainCurrency08PrintSymbol
  END
  IF (@srcMainCurrency09ScreenSymbol <> @trgMainCurrency09ScreenSymbol) Or ((@srcMainCurrency09ScreenSymbol IS NULL) And (@trgMainCurrency09ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency09ScreenSymbol IS NOT NULL) And (@trgMainCurrency09ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency09ScreenSymbol = ' + @srcMainCurrency09ScreenSymbol + ' / ' + @trgMainCurrency09ScreenSymbol
  END
  IF (@srcMainCurrency09Desc <> @trgMainCurrency09Desc) Or ((@srcMainCurrency09Desc IS NULL) And (@trgMainCurrency09Desc IS NOT NULL)) Or ((@srcMainCurrency09Desc IS NOT NULL) And (@trgMainCurrency09Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency09Desc = ' + @srcMainCurrency09Desc + ' / ' + @trgMainCurrency09Desc
  END
  IF (@srcMainCurrency09CompanyRate <> @trgMainCurrency09CompanyRate) Or ((@srcMainCurrency09CompanyRate IS NULL) And (@trgMainCurrency09CompanyRate IS NOT NULL)) Or ((@srcMainCurrency09CompanyRate IS NOT NULL) And (@trgMainCurrency09CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency09CompanyRate = ' + @srcMainCurrency09CompanyRate + ' / ' + @trgMainCurrency09CompanyRate
  END
  IF (@srcMainCurrency09DailyRate <> @trgMainCurrency09DailyRate) Or ((@srcMainCurrency09DailyRate IS NULL) And (@trgMainCurrency09DailyRate IS NOT NULL)) Or ((@srcMainCurrency09DailyRate IS NOT NULL) And (@trgMainCurrency09DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency09DailyRate = ' + @srcMainCurrency09DailyRate + ' / ' + @trgMainCurrency09DailyRate
  END
  IF (@srcMainCurrency09PrintSymbol <> @trgMainCurrency09PrintSymbol) Or ((@srcMainCurrency09PrintSymbol IS NULL) And (@trgMainCurrency09PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency09PrintSymbol IS NOT NULL) And (@trgMainCurrency09PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency09PrintSymbol = ' + @srcMainCurrency09PrintSymbol + ' / ' + @trgMainCurrency09PrintSymbol
  END
  IF (@srcMainCurrency10ScreenSymbol <> @trgMainCurrency10ScreenSymbol) Or ((@srcMainCurrency10ScreenSymbol IS NULL) And (@trgMainCurrency10ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency10ScreenSymbol IS NOT NULL) And (@trgMainCurrency10ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency10ScreenSymbol = ' + @srcMainCurrency10ScreenSymbol + ' / ' + @trgMainCurrency10ScreenSymbol
  END
  IF (@srcMainCurrency10Desc <> @trgMainCurrency10Desc) Or ((@srcMainCurrency10Desc IS NULL) And (@trgMainCurrency10Desc IS NOT NULL)) Or ((@srcMainCurrency10Desc IS NOT NULL) And (@trgMainCurrency10Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency10Desc = ' + @srcMainCurrency10Desc + ' / ' + @trgMainCurrency10Desc
  END
  IF (@srcMainCurrency10CompanyRate <> @trgMainCurrency10CompanyRate) Or ((@srcMainCurrency10CompanyRate IS NULL) And (@trgMainCurrency10CompanyRate IS NOT NULL)) Or ((@srcMainCurrency10CompanyRate IS NOT NULL) And (@trgMainCurrency10CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency10CompanyRate = ' + @srcMainCurrency10CompanyRate + ' / ' + @trgMainCurrency10CompanyRate
  END
  IF (@srcMainCurrency10DailyRate <> @trgMainCurrency10DailyRate) Or ((@srcMainCurrency10DailyRate IS NULL) And (@trgMainCurrency10DailyRate IS NOT NULL)) Or ((@srcMainCurrency10DailyRate IS NOT NULL) And (@trgMainCurrency10DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency10DailyRate = ' + @srcMainCurrency10DailyRate + ' / ' + @trgMainCurrency10DailyRate
  END
  IF (@srcMainCurrency10PrintSymbol <> @trgMainCurrency10PrintSymbol) Or ((@srcMainCurrency10PrintSymbol IS NULL) And (@trgMainCurrency10PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency10PrintSymbol IS NOT NULL) And (@trgMainCurrency10PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency10PrintSymbol = ' + @srcMainCurrency10PrintSymbol + ' / ' + @trgMainCurrency10PrintSymbol
  END
  IF (@srcMainCurrency11ScreenSymbol <> @trgMainCurrency11ScreenSymbol) Or ((@srcMainCurrency11ScreenSymbol IS NULL) And (@trgMainCurrency11ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency11ScreenSymbol IS NOT NULL) And (@trgMainCurrency11ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency11ScreenSymbol = ' + @srcMainCurrency11ScreenSymbol + ' / ' + @trgMainCurrency11ScreenSymbol
  END
  IF (@srcMainCurrency11Desc <> @trgMainCurrency11Desc) Or ((@srcMainCurrency11Desc IS NULL) And (@trgMainCurrency11Desc IS NOT NULL)) Or ((@srcMainCurrency11Desc IS NOT NULL) And (@trgMainCurrency11Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency11Desc = ' + @srcMainCurrency11Desc + ' / ' + @trgMainCurrency11Desc
  END
  IF (@srcMainCurrency11CompanyRate <> @trgMainCurrency11CompanyRate) Or ((@srcMainCurrency11CompanyRate IS NULL) And (@trgMainCurrency11CompanyRate IS NOT NULL)) Or ((@srcMainCurrency11CompanyRate IS NOT NULL) And (@trgMainCurrency11CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency11CompanyRate = ' + @srcMainCurrency11CompanyRate + ' / ' + @trgMainCurrency11CompanyRate
  END
  IF (@srcMainCurrency11DailyRate <> @trgMainCurrency11DailyRate) Or ((@srcMainCurrency11DailyRate IS NULL) And (@trgMainCurrency11DailyRate IS NOT NULL)) Or ((@srcMainCurrency11DailyRate IS NOT NULL) And (@trgMainCurrency11DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency11DailyRate = ' + @srcMainCurrency11DailyRate + ' / ' + @trgMainCurrency11DailyRate
  END
  IF (@srcMainCurrency11PrintSymbol <> @trgMainCurrency11PrintSymbol) Or ((@srcMainCurrency11PrintSymbol IS NULL) And (@trgMainCurrency11PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency11PrintSymbol IS NOT NULL) And (@trgMainCurrency11PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency11PrintSymbol = ' + @srcMainCurrency11PrintSymbol + ' / ' + @trgMainCurrency11PrintSymbol
  END
  IF (@srcMainCurrency12ScreenSymbol <> @trgMainCurrency12ScreenSymbol) Or ((@srcMainCurrency12ScreenSymbol IS NULL) And (@trgMainCurrency12ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency12ScreenSymbol IS NOT NULL) And (@trgMainCurrency12ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency12ScreenSymbol = ' + @srcMainCurrency12ScreenSymbol + ' / ' + @trgMainCurrency12ScreenSymbol
  END
  IF (@srcMainCurrency12Desc <> @trgMainCurrency12Desc) Or ((@srcMainCurrency12Desc IS NULL) And (@trgMainCurrency12Desc IS NOT NULL)) Or ((@srcMainCurrency12Desc IS NOT NULL) And (@trgMainCurrency12Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency12Desc = ' + @srcMainCurrency12Desc + ' / ' + @trgMainCurrency12Desc
  END
  IF (@srcMainCurrency12CompanyRate <> @trgMainCurrency12CompanyRate) Or ((@srcMainCurrency12CompanyRate IS NULL) And (@trgMainCurrency12CompanyRate IS NOT NULL)) Or ((@srcMainCurrency12CompanyRate IS NOT NULL) And (@trgMainCurrency12CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency12CompanyRate = ' + @srcMainCurrency12CompanyRate + ' / ' + @trgMainCurrency12CompanyRate
  END
  IF (@srcMainCurrency12DailyRate <> @trgMainCurrency12DailyRate) Or ((@srcMainCurrency12DailyRate IS NULL) And (@trgMainCurrency12DailyRate IS NOT NULL)) Or ((@srcMainCurrency12DailyRate IS NOT NULL) And (@trgMainCurrency12DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency12DailyRate = ' + @srcMainCurrency12DailyRate + ' / ' + @trgMainCurrency12DailyRate
  END
  IF (@srcMainCurrency12PrintSymbol <> @trgMainCurrency12PrintSymbol) Or ((@srcMainCurrency12PrintSymbol IS NULL) And (@trgMainCurrency12PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency12PrintSymbol IS NOT NULL) And (@trgMainCurrency12PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency12PrintSymbol = ' + @srcMainCurrency12PrintSymbol + ' / ' + @trgMainCurrency12PrintSymbol
  END
  IF (@srcMainCurrency13ScreenSymbol <> @trgMainCurrency13ScreenSymbol) Or ((@srcMainCurrency13ScreenSymbol IS NULL) And (@trgMainCurrency13ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency13ScreenSymbol IS NOT NULL) And (@trgMainCurrency13ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency13ScreenSymbol = ' + @srcMainCurrency13ScreenSymbol + ' / ' + @trgMainCurrency13ScreenSymbol
  END
  IF (@srcMainCurrency13Desc <> @trgMainCurrency13Desc) Or ((@srcMainCurrency13Desc IS NULL) And (@trgMainCurrency13Desc IS NOT NULL)) Or ((@srcMainCurrency13Desc IS NOT NULL) And (@trgMainCurrency13Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency13Desc = ' + @srcMainCurrency13Desc + ' / ' + @trgMainCurrency13Desc
  END
  IF (@srcMainCurrency13CompanyRate <> @trgMainCurrency13CompanyRate) Or ((@srcMainCurrency13CompanyRate IS NULL) And (@trgMainCurrency13CompanyRate IS NOT NULL)) Or ((@srcMainCurrency13CompanyRate IS NOT NULL) And (@trgMainCurrency13CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency13CompanyRate = ' + @srcMainCurrency13CompanyRate + ' / ' + @trgMainCurrency13CompanyRate
  END
  IF (@srcMainCurrency13DailyRate <> @trgMainCurrency13DailyRate) Or ((@srcMainCurrency13DailyRate IS NULL) And (@trgMainCurrency13DailyRate IS NOT NULL)) Or ((@srcMainCurrency13DailyRate IS NOT NULL) And (@trgMainCurrency13DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency13DailyRate = ' + @srcMainCurrency13DailyRate + ' / ' + @trgMainCurrency13DailyRate
  END
  IF (@srcMainCurrency13PrintSymbol <> @trgMainCurrency13PrintSymbol) Or ((@srcMainCurrency13PrintSymbol IS NULL) And (@trgMainCurrency13PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency13PrintSymbol IS NOT NULL) And (@trgMainCurrency13PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency13PrintSymbol = ' + @srcMainCurrency13PrintSymbol + ' / ' + @trgMainCurrency13PrintSymbol
  END
  IF (@srcMainCurrency14ScreenSymbol <> @trgMainCurrency14ScreenSymbol) Or ((@srcMainCurrency14ScreenSymbol IS NULL) And (@trgMainCurrency14ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency14ScreenSymbol IS NOT NULL) And (@trgMainCurrency14ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency14ScreenSymbol = ' + @srcMainCurrency14ScreenSymbol + ' / ' + @trgMainCurrency14ScreenSymbol
  END
  IF (@srcMainCurrency14Desc <> @trgMainCurrency14Desc) Or ((@srcMainCurrency14Desc IS NULL) And (@trgMainCurrency14Desc IS NOT NULL)) Or ((@srcMainCurrency14Desc IS NOT NULL) And (@trgMainCurrency14Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency14Desc = ' + @srcMainCurrency14Desc + ' / ' + @trgMainCurrency14Desc
  END
  IF (@srcMainCurrency14CompanyRate <> @trgMainCurrency14CompanyRate) Or ((@srcMainCurrency14CompanyRate IS NULL) And (@trgMainCurrency14CompanyRate IS NOT NULL)) Or ((@srcMainCurrency14CompanyRate IS NOT NULL) And (@trgMainCurrency14CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency14CompanyRate = ' + @srcMainCurrency14CompanyRate + ' / ' + @trgMainCurrency14CompanyRate
  END
  IF (@srcMainCurrency14DailyRate <> @trgMainCurrency14DailyRate) Or ((@srcMainCurrency14DailyRate IS NULL) And (@trgMainCurrency14DailyRate IS NOT NULL)) Or ((@srcMainCurrency14DailyRate IS NOT NULL) And (@trgMainCurrency14DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency14DailyRate = ' + @srcMainCurrency14DailyRate + ' / ' + @trgMainCurrency14DailyRate
  END
  IF (@srcMainCurrency14PrintSymbol <> @trgMainCurrency14PrintSymbol) Or ((@srcMainCurrency14PrintSymbol IS NULL) And (@trgMainCurrency14PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency14PrintSymbol IS NOT NULL) And (@trgMainCurrency14PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency14PrintSymbol = ' + @srcMainCurrency14PrintSymbol + ' / ' + @trgMainCurrency14PrintSymbol
  END
  IF (@srcMainCurrency15ScreenSymbol <> @trgMainCurrency15ScreenSymbol) Or ((@srcMainCurrency15ScreenSymbol IS NULL) And (@trgMainCurrency15ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency15ScreenSymbol IS NOT NULL) And (@trgMainCurrency15ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency15ScreenSymbol = ' + @srcMainCurrency15ScreenSymbol + ' / ' + @trgMainCurrency15ScreenSymbol
  END
  IF (@srcMainCurrency15Desc <> @trgMainCurrency15Desc) Or ((@srcMainCurrency15Desc IS NULL) And (@trgMainCurrency15Desc IS NOT NULL)) Or ((@srcMainCurrency15Desc IS NOT NULL) And (@trgMainCurrency15Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency15Desc = ' + @srcMainCurrency15Desc + ' / ' + @trgMainCurrency15Desc
  END
  IF (@srcMainCurrency15CompanyRate <> @trgMainCurrency15CompanyRate) Or ((@srcMainCurrency15CompanyRate IS NULL) And (@trgMainCurrency15CompanyRate IS NOT NULL)) Or ((@srcMainCurrency15CompanyRate IS NOT NULL) And (@trgMainCurrency15CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency15CompanyRate = ' + @srcMainCurrency15CompanyRate + ' / ' + @trgMainCurrency15CompanyRate
  END
  IF (@srcMainCurrency15DailyRate <> @trgMainCurrency15DailyRate) Or ((@srcMainCurrency15DailyRate IS NULL) And (@trgMainCurrency15DailyRate IS NOT NULL)) Or ((@srcMainCurrency15DailyRate IS NOT NULL) And (@trgMainCurrency15DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency15DailyRate = ' + @srcMainCurrency15DailyRate + ' / ' + @trgMainCurrency15DailyRate
  END
  IF (@srcMainCurrency15PrintSymbol <> @trgMainCurrency15PrintSymbol) Or ((@srcMainCurrency15PrintSymbol IS NULL) And (@trgMainCurrency15PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency15PrintSymbol IS NOT NULL) And (@trgMainCurrency15PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency15PrintSymbol = ' + @srcMainCurrency15PrintSymbol + ' / ' + @trgMainCurrency15PrintSymbol
  END
  IF (@srcMainCurrency16ScreenSymbol <> @trgMainCurrency16ScreenSymbol) Or ((@srcMainCurrency16ScreenSymbol IS NULL) And (@trgMainCurrency16ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency16ScreenSymbol IS NOT NULL) And (@trgMainCurrency16ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency16ScreenSymbol = ' + @srcMainCurrency16ScreenSymbol + ' / ' + @trgMainCurrency16ScreenSymbol
  END
  IF (@srcMainCurrency16Desc <> @trgMainCurrency16Desc) Or ((@srcMainCurrency16Desc IS NULL) And (@trgMainCurrency16Desc IS NOT NULL)) Or ((@srcMainCurrency16Desc IS NOT NULL) And (@trgMainCurrency16Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency16Desc = ' + @srcMainCurrency16Desc + ' / ' + @trgMainCurrency16Desc
  END
  IF (@srcMainCurrency16CompanyRate <> @trgMainCurrency16CompanyRate) Or ((@srcMainCurrency16CompanyRate IS NULL) And (@trgMainCurrency16CompanyRate IS NOT NULL)) Or ((@srcMainCurrency16CompanyRate IS NOT NULL) And (@trgMainCurrency16CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency16CompanyRate = ' + @srcMainCurrency16CompanyRate + ' / ' + @trgMainCurrency16CompanyRate
  END
  IF (@srcMainCurrency16DailyRate <> @trgMainCurrency16DailyRate) Or ((@srcMainCurrency16DailyRate IS NULL) And (@trgMainCurrency16DailyRate IS NOT NULL)) Or ((@srcMainCurrency16DailyRate IS NOT NULL) And (@trgMainCurrency16DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency16DailyRate = ' + @srcMainCurrency16DailyRate + ' / ' + @trgMainCurrency16DailyRate
  END
  IF (@srcMainCurrency16PrintSymbol <> @trgMainCurrency16PrintSymbol) Or ((@srcMainCurrency16PrintSymbol IS NULL) And (@trgMainCurrency16PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency16PrintSymbol IS NOT NULL) And (@trgMainCurrency16PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency16PrintSymbol = ' + @srcMainCurrency16PrintSymbol + ' / ' + @trgMainCurrency16PrintSymbol
  END
  IF (@srcMainCurrency17ScreenSymbol <> @trgMainCurrency17ScreenSymbol) Or ((@srcMainCurrency17ScreenSymbol IS NULL) And (@trgMainCurrency17ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency17ScreenSymbol IS NOT NULL) And (@trgMainCurrency17ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency17ScreenSymbol = ' + @srcMainCurrency17ScreenSymbol + ' / ' + @trgMainCurrency17ScreenSymbol
  END
  IF (@srcMainCurrency17Desc <> @trgMainCurrency17Desc) Or ((@srcMainCurrency17Desc IS NULL) And (@trgMainCurrency17Desc IS NOT NULL)) Or ((@srcMainCurrency17Desc IS NOT NULL) And (@trgMainCurrency17Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency17Desc = ' + @srcMainCurrency17Desc + ' / ' + @trgMainCurrency17Desc
  END
  IF (@srcMainCurrency17CompanyRate <> @trgMainCurrency17CompanyRate) Or ((@srcMainCurrency17CompanyRate IS NULL) And (@trgMainCurrency17CompanyRate IS NOT NULL)) Or ((@srcMainCurrency17CompanyRate IS NOT NULL) And (@trgMainCurrency17CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency17CompanyRate = ' + @srcMainCurrency17CompanyRate + ' / ' + @trgMainCurrency17CompanyRate
  END
  IF (@srcMainCurrency17DailyRate <> @trgMainCurrency17DailyRate) Or ((@srcMainCurrency17DailyRate IS NULL) And (@trgMainCurrency17DailyRate IS NOT NULL)) Or ((@srcMainCurrency17DailyRate IS NOT NULL) And (@trgMainCurrency17DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency17DailyRate = ' + @srcMainCurrency17DailyRate + ' / ' + @trgMainCurrency17DailyRate
  END
  IF (@srcMainCurrency17PrintSymbol <> @trgMainCurrency17PrintSymbol) Or ((@srcMainCurrency17PrintSymbol IS NULL) And (@trgMainCurrency17PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency17PrintSymbol IS NOT NULL) And (@trgMainCurrency17PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency17PrintSymbol = ' + @srcMainCurrency17PrintSymbol + ' / ' + @trgMainCurrency17PrintSymbol
  END
  IF (@srcMainCurrency18ScreenSymbol <> @trgMainCurrency18ScreenSymbol) Or ((@srcMainCurrency18ScreenSymbol IS NULL) And (@trgMainCurrency18ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency18ScreenSymbol IS NOT NULL) And (@trgMainCurrency18ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency18ScreenSymbol = ' + @srcMainCurrency18ScreenSymbol + ' / ' + @trgMainCurrency18ScreenSymbol
  END
  IF (@srcMainCurrency18Desc <> @trgMainCurrency18Desc) Or ((@srcMainCurrency18Desc IS NULL) And (@trgMainCurrency18Desc IS NOT NULL)) Or ((@srcMainCurrency18Desc IS NOT NULL) And (@trgMainCurrency18Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency18Desc = ' + @srcMainCurrency18Desc + ' / ' + @trgMainCurrency18Desc
  END
  IF (@srcMainCurrency18CompanyRate <> @trgMainCurrency18CompanyRate) Or ((@srcMainCurrency18CompanyRate IS NULL) And (@trgMainCurrency18CompanyRate IS NOT NULL)) Or ((@srcMainCurrency18CompanyRate IS NOT NULL) And (@trgMainCurrency18CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency18CompanyRate = ' + @srcMainCurrency18CompanyRate + ' / ' + @trgMainCurrency18CompanyRate
  END
  IF (@srcMainCurrency18DailyRate <> @trgMainCurrency18DailyRate) Or ((@srcMainCurrency18DailyRate IS NULL) And (@trgMainCurrency18DailyRate IS NOT NULL)) Or ((@srcMainCurrency18DailyRate IS NOT NULL) And (@trgMainCurrency18DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency18DailyRate = ' + @srcMainCurrency18DailyRate + ' / ' + @trgMainCurrency18DailyRate
  END
  IF (@srcMainCurrency18PrintSymbol <> @trgMainCurrency18PrintSymbol) Or ((@srcMainCurrency18PrintSymbol IS NULL) And (@trgMainCurrency18PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency18PrintSymbol IS NOT NULL) And (@trgMainCurrency18PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency18PrintSymbol = ' + @srcMainCurrency18PrintSymbol + ' / ' + @trgMainCurrency18PrintSymbol
  END
  IF (@srcMainCurrency19ScreenSymbol <> @trgMainCurrency19ScreenSymbol) Or ((@srcMainCurrency19ScreenSymbol IS NULL) And (@trgMainCurrency19ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency19ScreenSymbol IS NOT NULL) And (@trgMainCurrency19ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency19ScreenSymbol = ' + @srcMainCurrency19ScreenSymbol + ' / ' + @trgMainCurrency19ScreenSymbol
  END
  IF (@srcMainCurrency19Desc <> @trgMainCurrency19Desc) Or ((@srcMainCurrency19Desc IS NULL) And (@trgMainCurrency19Desc IS NOT NULL)) Or ((@srcMainCurrency19Desc IS NOT NULL) And (@trgMainCurrency19Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency19Desc = ' + @srcMainCurrency19Desc + ' / ' + @trgMainCurrency19Desc
  END
  IF (@srcMainCurrency19CompanyRate <> @trgMainCurrency19CompanyRate) Or ((@srcMainCurrency19CompanyRate IS NULL) And (@trgMainCurrency19CompanyRate IS NOT NULL)) Or ((@srcMainCurrency19CompanyRate IS NOT NULL) And (@trgMainCurrency19CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency19CompanyRate = ' + @srcMainCurrency19CompanyRate + ' / ' + @trgMainCurrency19CompanyRate
  END
  IF (@srcMainCurrency19DailyRate <> @trgMainCurrency19DailyRate) Or ((@srcMainCurrency19DailyRate IS NULL) And (@trgMainCurrency19DailyRate IS NOT NULL)) Or ((@srcMainCurrency19DailyRate IS NOT NULL) And (@trgMainCurrency19DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency19DailyRate = ' + @srcMainCurrency19DailyRate + ' / ' + @trgMainCurrency19DailyRate
  END
  IF (@srcMainCurrency19PrintSymbol <> @trgMainCurrency19PrintSymbol) Or ((@srcMainCurrency19PrintSymbol IS NULL) And (@trgMainCurrency19PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency19PrintSymbol IS NOT NULL) And (@trgMainCurrency19PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency19PrintSymbol = ' + @srcMainCurrency19PrintSymbol + ' / ' + @trgMainCurrency19PrintSymbol
  END
  IF (@srcMainCurrency20ScreenSymbol <> @trgMainCurrency20ScreenSymbol) Or ((@srcMainCurrency20ScreenSymbol IS NULL) And (@trgMainCurrency20ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency20ScreenSymbol IS NOT NULL) And (@trgMainCurrency20ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency20ScreenSymbol = ' + @srcMainCurrency20ScreenSymbol + ' / ' + @trgMainCurrency20ScreenSymbol
  END
  IF (@srcMainCurrency20Desc <> @trgMainCurrency20Desc) Or ((@srcMainCurrency20Desc IS NULL) And (@trgMainCurrency20Desc IS NOT NULL)) Or ((@srcMainCurrency20Desc IS NOT NULL) And (@trgMainCurrency20Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency20Desc = ' + @srcMainCurrency20Desc + ' / ' + @trgMainCurrency20Desc
  END
  IF (@srcMainCurrency20CompanyRate <> @trgMainCurrency20CompanyRate) Or ((@srcMainCurrency20CompanyRate IS NULL) And (@trgMainCurrency20CompanyRate IS NOT NULL)) Or ((@srcMainCurrency20CompanyRate IS NOT NULL) And (@trgMainCurrency20CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency20CompanyRate = ' + @srcMainCurrency20CompanyRate + ' / ' + @trgMainCurrency20CompanyRate
  END
  IF (@srcMainCurrency20DailyRate <> @trgMainCurrency20DailyRate) Or ((@srcMainCurrency20DailyRate IS NULL) And (@trgMainCurrency20DailyRate IS NOT NULL)) Or ((@srcMainCurrency20DailyRate IS NOT NULL) And (@trgMainCurrency20DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency20DailyRate = ' + @srcMainCurrency20DailyRate + ' / ' + @trgMainCurrency20DailyRate
  END
  IF (@srcMainCurrency20PrintSymbol <> @trgMainCurrency20PrintSymbol) Or ((@srcMainCurrency20PrintSymbol IS NULL) And (@trgMainCurrency20PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency20PrintSymbol IS NOT NULL) And (@trgMainCurrency20PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency20PrintSymbol = ' + @srcMainCurrency20PrintSymbol + ' / ' + @trgMainCurrency20PrintSymbol
  END
  IF (@srcMainCurrency21ScreenSymbol <> @trgMainCurrency21ScreenSymbol) Or ((@srcMainCurrency21ScreenSymbol IS NULL) And (@trgMainCurrency21ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency21ScreenSymbol IS NOT NULL) And (@trgMainCurrency21ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency21ScreenSymbol = ' + @srcMainCurrency21ScreenSymbol + ' / ' + @trgMainCurrency21ScreenSymbol
  END
  IF (@srcMainCurrency21Desc <> @trgMainCurrency21Desc) Or ((@srcMainCurrency21Desc IS NULL) And (@trgMainCurrency21Desc IS NOT NULL)) Or ((@srcMainCurrency21Desc IS NOT NULL) And (@trgMainCurrency21Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency21Desc = ' + @srcMainCurrency21Desc + ' / ' + @trgMainCurrency21Desc
  END
  IF (@srcMainCurrency21CompanyRate <> @trgMainCurrency21CompanyRate) Or ((@srcMainCurrency21CompanyRate IS NULL) And (@trgMainCurrency21CompanyRate IS NOT NULL)) Or ((@srcMainCurrency21CompanyRate IS NOT NULL) And (@trgMainCurrency21CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency21CompanyRate = ' + @srcMainCurrency21CompanyRate + ' / ' + @trgMainCurrency21CompanyRate
  END
  IF (@srcMainCurrency21DailyRate <> @trgMainCurrency21DailyRate) Or ((@srcMainCurrency21DailyRate IS NULL) And (@trgMainCurrency21DailyRate IS NOT NULL)) Or ((@srcMainCurrency21DailyRate IS NOT NULL) And (@trgMainCurrency21DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency21DailyRate = ' + @srcMainCurrency21DailyRate + ' / ' + @trgMainCurrency21DailyRate
  END
  IF (@srcMainCurrency21PrintSymbol <> @trgMainCurrency21PrintSymbol) Or ((@srcMainCurrency21PrintSymbol IS NULL) And (@trgMainCurrency21PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency21PrintSymbol IS NOT NULL) And (@trgMainCurrency21PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency21PrintSymbol = ' + @srcMainCurrency21PrintSymbol + ' / ' + @trgMainCurrency21PrintSymbol
  END
  IF (@srcMainCurrency22ScreenSymbol <> @trgMainCurrency22ScreenSymbol) Or ((@srcMainCurrency22ScreenSymbol IS NULL) And (@trgMainCurrency22ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency22ScreenSymbol IS NOT NULL) And (@trgMainCurrency22ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency22ScreenSymbol = ' + @srcMainCurrency22ScreenSymbol + ' / ' + @trgMainCurrency22ScreenSymbol
  END
  IF (@srcMainCurrency22Desc <> @trgMainCurrency22Desc) Or ((@srcMainCurrency22Desc IS NULL) And (@trgMainCurrency22Desc IS NOT NULL)) Or ((@srcMainCurrency22Desc IS NOT NULL) And (@trgMainCurrency22Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency22Desc = ' + @srcMainCurrency22Desc + ' / ' + @trgMainCurrency22Desc
  END
  IF (@srcMainCurrency22CompanyRate <> @trgMainCurrency22CompanyRate) Or ((@srcMainCurrency22CompanyRate IS NULL) And (@trgMainCurrency22CompanyRate IS NOT NULL)) Or ((@srcMainCurrency22CompanyRate IS NOT NULL) And (@trgMainCurrency22CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency22CompanyRate = ' + @srcMainCurrency22CompanyRate + ' / ' + @trgMainCurrency22CompanyRate
  END
  IF (@srcMainCurrency22DailyRate <> @trgMainCurrency22DailyRate) Or ((@srcMainCurrency22DailyRate IS NULL) And (@trgMainCurrency22DailyRate IS NOT NULL)) Or ((@srcMainCurrency22DailyRate IS NOT NULL) And (@trgMainCurrency22DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency22DailyRate = ' + @srcMainCurrency22DailyRate + ' / ' + @trgMainCurrency22DailyRate
  END
  IF (@srcMainCurrency22PrintSymbol <> @trgMainCurrency22PrintSymbol) Or ((@srcMainCurrency22PrintSymbol IS NULL) And (@trgMainCurrency22PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency22PrintSymbol IS NOT NULL) And (@trgMainCurrency22PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency22PrintSymbol = ' + @srcMainCurrency22PrintSymbol + ' / ' + @trgMainCurrency22PrintSymbol
  END
  IF (@srcMainCurrency23ScreenSymbol <> @trgMainCurrency23ScreenSymbol) Or ((@srcMainCurrency23ScreenSymbol IS NULL) And (@trgMainCurrency23ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency23ScreenSymbol IS NOT NULL) And (@trgMainCurrency23ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency23ScreenSymbol = ' + @srcMainCurrency23ScreenSymbol + ' / ' + @trgMainCurrency23ScreenSymbol
  END
  IF (@srcMainCurrency23Desc <> @trgMainCurrency23Desc) Or ((@srcMainCurrency23Desc IS NULL) And (@trgMainCurrency23Desc IS NOT NULL)) Or ((@srcMainCurrency23Desc IS NOT NULL) And (@trgMainCurrency23Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency23Desc = ' + @srcMainCurrency23Desc + ' / ' + @trgMainCurrency23Desc
  END
  IF (@srcMainCurrency23CompanyRate <> @trgMainCurrency23CompanyRate) Or ((@srcMainCurrency23CompanyRate IS NULL) And (@trgMainCurrency23CompanyRate IS NOT NULL)) Or ((@srcMainCurrency23CompanyRate IS NOT NULL) And (@trgMainCurrency23CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency23CompanyRate = ' + @srcMainCurrency23CompanyRate + ' / ' + @trgMainCurrency23CompanyRate
  END
  IF (@srcMainCurrency23DailyRate <> @trgMainCurrency23DailyRate) Or ((@srcMainCurrency23DailyRate IS NULL) And (@trgMainCurrency23DailyRate IS NOT NULL)) Or ((@srcMainCurrency23DailyRate IS NOT NULL) And (@trgMainCurrency23DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency23DailyRate = ' + @srcMainCurrency23DailyRate + ' / ' + @trgMainCurrency23DailyRate
  END
  IF (@srcMainCurrency23PrintSymbol <> @trgMainCurrency23PrintSymbol) Or ((@srcMainCurrency23PrintSymbol IS NULL) And (@trgMainCurrency23PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency23PrintSymbol IS NOT NULL) And (@trgMainCurrency23PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency23PrintSymbol = ' + @srcMainCurrency23PrintSymbol + ' / ' + @trgMainCurrency23PrintSymbol
  END
  IF (@srcMainCurrency24ScreenSymbol <> @trgMainCurrency24ScreenSymbol) Or ((@srcMainCurrency24ScreenSymbol IS NULL) And (@trgMainCurrency24ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency24ScreenSymbol IS NOT NULL) And (@trgMainCurrency24ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency24ScreenSymbol = ' + @srcMainCurrency24ScreenSymbol + ' / ' + @trgMainCurrency24ScreenSymbol
  END
  IF (@srcMainCurrency24Desc <> @trgMainCurrency24Desc) Or ((@srcMainCurrency24Desc IS NULL) And (@trgMainCurrency24Desc IS NOT NULL)) Or ((@srcMainCurrency24Desc IS NOT NULL) And (@trgMainCurrency24Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency24Desc = ' + @srcMainCurrency24Desc + ' / ' + @trgMainCurrency24Desc
  END
  IF (@srcMainCurrency24CompanyRate <> @trgMainCurrency24CompanyRate) Or ((@srcMainCurrency24CompanyRate IS NULL) And (@trgMainCurrency24CompanyRate IS NOT NULL)) Or ((@srcMainCurrency24CompanyRate IS NOT NULL) And (@trgMainCurrency24CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency24CompanyRate = ' + @srcMainCurrency24CompanyRate + ' / ' + @trgMainCurrency24CompanyRate
  END
  IF (@srcMainCurrency24DailyRate <> @trgMainCurrency24DailyRate) Or ((@srcMainCurrency24DailyRate IS NULL) And (@trgMainCurrency24DailyRate IS NOT NULL)) Or ((@srcMainCurrency24DailyRate IS NOT NULL) And (@trgMainCurrency24DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency24DailyRate = ' + @srcMainCurrency24DailyRate + ' / ' + @trgMainCurrency24DailyRate
  END
  IF (@srcMainCurrency24PrintSymbol <> @trgMainCurrency24PrintSymbol) Or ((@srcMainCurrency24PrintSymbol IS NULL) And (@trgMainCurrency24PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency24PrintSymbol IS NOT NULL) And (@trgMainCurrency24PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency24PrintSymbol = ' + @srcMainCurrency24PrintSymbol + ' / ' + @trgMainCurrency24PrintSymbol
  END
  IF (@srcMainCurrency25ScreenSymbol <> @trgMainCurrency25ScreenSymbol) Or ((@srcMainCurrency25ScreenSymbol IS NULL) And (@trgMainCurrency25ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency25ScreenSymbol IS NOT NULL) And (@trgMainCurrency25ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency25ScreenSymbol = ' + @srcMainCurrency25ScreenSymbol + ' / ' + @trgMainCurrency25ScreenSymbol
  END
  IF (@srcMainCurrency25Desc <> @trgMainCurrency25Desc) Or ((@srcMainCurrency25Desc IS NULL) And (@trgMainCurrency25Desc IS NOT NULL)) Or ((@srcMainCurrency25Desc IS NOT NULL) And (@trgMainCurrency25Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency25Desc = ' + @srcMainCurrency25Desc + ' / ' + @trgMainCurrency25Desc
  END
  IF (@srcMainCurrency25CompanyRate <> @trgMainCurrency25CompanyRate) Or ((@srcMainCurrency25CompanyRate IS NULL) And (@trgMainCurrency25CompanyRate IS NOT NULL)) Or ((@srcMainCurrency25CompanyRate IS NOT NULL) And (@trgMainCurrency25CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency25CompanyRate = ' + @srcMainCurrency25CompanyRate + ' / ' + @trgMainCurrency25CompanyRate
  END
  IF (@srcMainCurrency25DailyRate <> @trgMainCurrency25DailyRate) Or ((@srcMainCurrency25DailyRate IS NULL) And (@trgMainCurrency25DailyRate IS NOT NULL)) Or ((@srcMainCurrency25DailyRate IS NOT NULL) And (@trgMainCurrency25DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency25DailyRate = ' + @srcMainCurrency25DailyRate + ' / ' + @trgMainCurrency25DailyRate
  END
  IF (@srcMainCurrency25PrintSymbol <> @trgMainCurrency25PrintSymbol) Or ((@srcMainCurrency25PrintSymbol IS NULL) And (@trgMainCurrency25PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency25PrintSymbol IS NOT NULL) And (@trgMainCurrency25PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency25PrintSymbol = ' + @srcMainCurrency25PrintSymbol + ' / ' + @trgMainCurrency25PrintSymbol
  END
  IF (@srcMainCurrency26ScreenSymbol <> @trgMainCurrency26ScreenSymbol) Or ((@srcMainCurrency26ScreenSymbol IS NULL) And (@trgMainCurrency26ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency26ScreenSymbol IS NOT NULL) And (@trgMainCurrency26ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency26ScreenSymbol = ' + @srcMainCurrency26ScreenSymbol + ' / ' + @trgMainCurrency26ScreenSymbol
  END
  IF (@srcMainCurrency26Desc <> @trgMainCurrency26Desc) Or ((@srcMainCurrency26Desc IS NULL) And (@trgMainCurrency26Desc IS NOT NULL)) Or ((@srcMainCurrency26Desc IS NOT NULL) And (@trgMainCurrency26Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency26Desc = ' + @srcMainCurrency26Desc + ' / ' + @trgMainCurrency26Desc
  END
  IF (@srcMainCurrency26CompanyRate <> @trgMainCurrency26CompanyRate) Or ((@srcMainCurrency26CompanyRate IS NULL) And (@trgMainCurrency26CompanyRate IS NOT NULL)) Or ((@srcMainCurrency26CompanyRate IS NOT NULL) And (@trgMainCurrency26CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency26CompanyRate = ' + @srcMainCurrency26CompanyRate + ' / ' + @trgMainCurrency26CompanyRate
  END
  IF (@srcMainCurrency26DailyRate <> @trgMainCurrency26DailyRate) Or ((@srcMainCurrency26DailyRate IS NULL) And (@trgMainCurrency26DailyRate IS NOT NULL)) Or ((@srcMainCurrency26DailyRate IS NOT NULL) And (@trgMainCurrency26DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency26DailyRate = ' + @srcMainCurrency26DailyRate + ' / ' + @trgMainCurrency26DailyRate
  END
  IF (@srcMainCurrency26PrintSymbol <> @trgMainCurrency26PrintSymbol) Or ((@srcMainCurrency26PrintSymbol IS NULL) And (@trgMainCurrency26PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency26PrintSymbol IS NOT NULL) And (@trgMainCurrency26PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency26PrintSymbol = ' + @srcMainCurrency26PrintSymbol + ' / ' + @trgMainCurrency26PrintSymbol
  END
  IF (@srcMainCurrency27ScreenSymbol <> @trgMainCurrency27ScreenSymbol) Or ((@srcMainCurrency27ScreenSymbol IS NULL) And (@trgMainCurrency27ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency27ScreenSymbol IS NOT NULL) And (@trgMainCurrency27ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency27ScreenSymbol = ' + @srcMainCurrency27ScreenSymbol + ' / ' + @trgMainCurrency27ScreenSymbol
  END
  IF (@srcMainCurrency27Desc <> @trgMainCurrency27Desc) Or ((@srcMainCurrency27Desc IS NULL) And (@trgMainCurrency27Desc IS NOT NULL)) Or ((@srcMainCurrency27Desc IS NOT NULL) And (@trgMainCurrency27Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency27Desc = ' + @srcMainCurrency27Desc + ' / ' + @trgMainCurrency27Desc
  END
  IF (@srcMainCurrency27CompanyRate <> @trgMainCurrency27CompanyRate) Or ((@srcMainCurrency27CompanyRate IS NULL) And (@trgMainCurrency27CompanyRate IS NOT NULL)) Or ((@srcMainCurrency27CompanyRate IS NOT NULL) And (@trgMainCurrency27CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency27CompanyRate = ' + @srcMainCurrency27CompanyRate + ' / ' + @trgMainCurrency27CompanyRate
  END
  IF (@srcMainCurrency27DailyRate <> @trgMainCurrency27DailyRate) Or ((@srcMainCurrency27DailyRate IS NULL) And (@trgMainCurrency27DailyRate IS NOT NULL)) Or ((@srcMainCurrency27DailyRate IS NOT NULL) And (@trgMainCurrency27DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency27DailyRate = ' + @srcMainCurrency27DailyRate + ' / ' + @trgMainCurrency27DailyRate
  END
  IF (@srcMainCurrency27PrintSymbol <> @trgMainCurrency27PrintSymbol) Or ((@srcMainCurrency27PrintSymbol IS NULL) And (@trgMainCurrency27PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency27PrintSymbol IS NOT NULL) And (@trgMainCurrency27PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency27PrintSymbol = ' + @srcMainCurrency27PrintSymbol + ' / ' + @trgMainCurrency27PrintSymbol
  END
  IF (@srcMainCurrency28ScreenSymbol <> @trgMainCurrency28ScreenSymbol) Or ((@srcMainCurrency28ScreenSymbol IS NULL) And (@trgMainCurrency28ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency28ScreenSymbol IS NOT NULL) And (@trgMainCurrency28ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency28ScreenSymbol = ' + @srcMainCurrency28ScreenSymbol + ' / ' + @trgMainCurrency28ScreenSymbol
  END
  IF (@srcMainCurrency28Desc <> @trgMainCurrency28Desc) Or ((@srcMainCurrency28Desc IS NULL) And (@trgMainCurrency28Desc IS NOT NULL)) Or ((@srcMainCurrency28Desc IS NOT NULL) And (@trgMainCurrency28Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency28Desc = ' + @srcMainCurrency28Desc + ' / ' + @trgMainCurrency28Desc
  END
  IF (@srcMainCurrency28CompanyRate <> @trgMainCurrency28CompanyRate) Or ((@srcMainCurrency28CompanyRate IS NULL) And (@trgMainCurrency28CompanyRate IS NOT NULL)) Or ((@srcMainCurrency28CompanyRate IS NOT NULL) And (@trgMainCurrency28CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency28CompanyRate = ' + @srcMainCurrency28CompanyRate + ' / ' + @trgMainCurrency28CompanyRate
  END
  IF (@srcMainCurrency28DailyRate <> @trgMainCurrency28DailyRate) Or ((@srcMainCurrency28DailyRate IS NULL) And (@trgMainCurrency28DailyRate IS NOT NULL)) Or ((@srcMainCurrency28DailyRate IS NOT NULL) And (@trgMainCurrency28DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency28DailyRate = ' + @srcMainCurrency28DailyRate + ' / ' + @trgMainCurrency28DailyRate
  END
  IF (@srcMainCurrency28PrintSymbol <> @trgMainCurrency28PrintSymbol) Or ((@srcMainCurrency28PrintSymbol IS NULL) And (@trgMainCurrency28PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency28PrintSymbol IS NOT NULL) And (@trgMainCurrency28PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency28PrintSymbol = ' + @srcMainCurrency28PrintSymbol + ' / ' + @trgMainCurrency28PrintSymbol
  END
  IF (@srcMainCurrency29ScreenSymbol <> @trgMainCurrency29ScreenSymbol) Or ((@srcMainCurrency29ScreenSymbol IS NULL) And (@trgMainCurrency29ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency29ScreenSymbol IS NOT NULL) And (@trgMainCurrency29ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency29ScreenSymbol = ' + @srcMainCurrency29ScreenSymbol + ' / ' + @trgMainCurrency29ScreenSymbol
  END
  IF (@srcMainCurrency29Desc <> @trgMainCurrency29Desc) Or ((@srcMainCurrency29Desc IS NULL) And (@trgMainCurrency29Desc IS NOT NULL)) Or ((@srcMainCurrency29Desc IS NOT NULL) And (@trgMainCurrency29Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency29Desc = ' + @srcMainCurrency29Desc + ' / ' + @trgMainCurrency29Desc
  END
  IF (@srcMainCurrency29CompanyRate <> @trgMainCurrency29CompanyRate) Or ((@srcMainCurrency29CompanyRate IS NULL) And (@trgMainCurrency29CompanyRate IS NOT NULL)) Or ((@srcMainCurrency29CompanyRate IS NOT NULL) And (@trgMainCurrency29CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency29CompanyRate = ' + @srcMainCurrency29CompanyRate + ' / ' + @trgMainCurrency29CompanyRate
  END
  IF (@srcMainCurrency29DailyRate <> @trgMainCurrency29DailyRate) Or ((@srcMainCurrency29DailyRate IS NULL) And (@trgMainCurrency29DailyRate IS NOT NULL)) Or ((@srcMainCurrency29DailyRate IS NOT NULL) And (@trgMainCurrency29DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency29DailyRate = ' + @srcMainCurrency29DailyRate + ' / ' + @trgMainCurrency29DailyRate
  END
  IF (@srcMainCurrency29PrintSymbol <> @trgMainCurrency29PrintSymbol) Or ((@srcMainCurrency29PrintSymbol IS NULL) And (@trgMainCurrency29PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency29PrintSymbol IS NOT NULL) And (@trgMainCurrency29PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency29PrintSymbol = ' + @srcMainCurrency29PrintSymbol + ' / ' + @trgMainCurrency29PrintSymbol
  END
  IF (@srcMainCurrency30ScreenSymbol <> @trgMainCurrency30ScreenSymbol) Or ((@srcMainCurrency30ScreenSymbol IS NULL) And (@trgMainCurrency30ScreenSymbol IS NOT NULL)) Or ((@srcMainCurrency30ScreenSymbol IS NOT NULL) And (@trgMainCurrency30ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency30ScreenSymbol = ' + @srcMainCurrency30ScreenSymbol + ' / ' + @trgMainCurrency30ScreenSymbol
  END
  IF (@srcMainCurrency30Desc <> @trgMainCurrency30Desc) Or ((@srcMainCurrency30Desc IS NULL) And (@trgMainCurrency30Desc IS NOT NULL)) Or ((@srcMainCurrency30Desc IS NOT NULL) And (@trgMainCurrency30Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency30Desc = ' + @srcMainCurrency30Desc + ' / ' + @trgMainCurrency30Desc
  END
  IF (@srcMainCurrency30CompanyRate <> @trgMainCurrency30CompanyRate) Or ((@srcMainCurrency30CompanyRate IS NULL) And (@trgMainCurrency30CompanyRate IS NOT NULL)) Or ((@srcMainCurrency30CompanyRate IS NOT NULL) And (@trgMainCurrency30CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency30CompanyRate = ' + @srcMainCurrency30CompanyRate + ' / ' + @trgMainCurrency30CompanyRate
  END
  IF (@srcMainCurrency30DailyRate <> @trgMainCurrency30DailyRate) Or ((@srcMainCurrency30DailyRate IS NULL) And (@trgMainCurrency30DailyRate IS NOT NULL)) Or ((@srcMainCurrency30DailyRate IS NOT NULL) And (@trgMainCurrency30DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency30DailyRate = ' + @srcMainCurrency30DailyRate + ' / ' + @trgMainCurrency30DailyRate
  END
  IF (@srcMainCurrency30PrintSymbol <> @trgMainCurrency30PrintSymbol) Or ((@srcMainCurrency30PrintSymbol IS NULL) And (@trgMainCurrency30PrintSymbol IS NOT NULL)) Or ((@srcMainCurrency30PrintSymbol IS NOT NULL) And (@trgMainCurrency30PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.MainCurrency30PrintSymbol = ' + @srcMainCurrency30PrintSymbol + ' / ' + @trgMainCurrency30PrintSymbol
  END
  IF (@srcExtCurrency00ScreenSymbol <> @trgExtCurrency00ScreenSymbol) Or ((@srcExtCurrency00ScreenSymbol IS NULL) And (@trgExtCurrency00ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency00ScreenSymbol IS NOT NULL) And (@trgExtCurrency00ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency00ScreenSymbol = ' + @srcExtCurrency00ScreenSymbol + ' / ' + @trgExtCurrency00ScreenSymbol
  END
  IF (@srcExtCurrency00Desc <> @trgExtCurrency00Desc) Or ((@srcExtCurrency00Desc IS NULL) And (@trgExtCurrency00Desc IS NOT NULL)) Or ((@srcExtCurrency00Desc IS NOT NULL) And (@trgExtCurrency00Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency00Desc = ' + @srcExtCurrency00Desc + ' / ' + @trgExtCurrency00Desc
  END
  IF (@srcExtCurrency00CompanyRate <> @trgExtCurrency00CompanyRate) Or ((@srcExtCurrency00CompanyRate IS NULL) And (@trgExtCurrency00CompanyRate IS NOT NULL)) Or ((@srcExtCurrency00CompanyRate IS NOT NULL) And (@trgExtCurrency00CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency00CompanyRate = ' + @srcExtCurrency00CompanyRate + ' / ' + @trgExtCurrency00CompanyRate
  END
  IF (@srcExtCurrency00DailyRate <> @trgExtCurrency00DailyRate) Or ((@srcExtCurrency00DailyRate IS NULL) And (@trgExtCurrency00DailyRate IS NOT NULL)) Or ((@srcExtCurrency00DailyRate IS NOT NULL) And (@trgExtCurrency00DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency00DailyRate = ' + @srcExtCurrency00DailyRate + ' / ' + @trgExtCurrency00DailyRate
  END
  IF (@srcExtCurrency00PrintSymbol <> @trgExtCurrency00PrintSymbol) Or ((@srcExtCurrency00PrintSymbol IS NULL) And (@trgExtCurrency00PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency00PrintSymbol IS NOT NULL) And (@trgExtCurrency00PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency00PrintSymbol = ' + @srcExtCurrency00PrintSymbol + ' / ' + @trgExtCurrency00PrintSymbol
  END
  IF (@srcExtCurrency01ScreenSymbol <> @trgExtCurrency01ScreenSymbol) Or ((@srcExtCurrency01ScreenSymbol IS NULL) And (@trgExtCurrency01ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency01ScreenSymbol IS NOT NULL) And (@trgExtCurrency01ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency01ScreenSymbol = ' + @srcExtCurrency01ScreenSymbol + ' / ' + @trgExtCurrency01ScreenSymbol
  END
  IF (@srcExtCurrency01Desc <> @trgExtCurrency01Desc) Or ((@srcExtCurrency01Desc IS NULL) And (@trgExtCurrency01Desc IS NOT NULL)) Or ((@srcExtCurrency01Desc IS NOT NULL) And (@trgExtCurrency01Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency01Desc = ' + @srcExtCurrency01Desc + ' / ' + @trgExtCurrency01Desc
  END
  IF (@srcExtCurrency01CompanyRate <> @trgExtCurrency01CompanyRate) Or ((@srcExtCurrency01CompanyRate IS NULL) And (@trgExtCurrency01CompanyRate IS NOT NULL)) Or ((@srcExtCurrency01CompanyRate IS NOT NULL) And (@trgExtCurrency01CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency01CompanyRate = ' + @srcExtCurrency01CompanyRate + ' / ' + @trgExtCurrency01CompanyRate
  END
  IF (@srcExtCurrency01DailyRate <> @trgExtCurrency01DailyRate) Or ((@srcExtCurrency01DailyRate IS NULL) And (@trgExtCurrency01DailyRate IS NOT NULL)) Or ((@srcExtCurrency01DailyRate IS NOT NULL) And (@trgExtCurrency01DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency01DailyRate = ' + @srcExtCurrency01DailyRate + ' / ' + @trgExtCurrency01DailyRate
  END
  IF (@srcExtCurrency01PrintSymbol <> @trgExtCurrency01PrintSymbol) Or ((@srcExtCurrency01PrintSymbol IS NULL) And (@trgExtCurrency01PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency01PrintSymbol IS NOT NULL) And (@trgExtCurrency01PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency01PrintSymbol = ' + @srcExtCurrency01PrintSymbol + ' / ' + @trgExtCurrency01PrintSymbol
  END
  IF (@srcExtCurrency02ScreenSymbol <> @trgExtCurrency02ScreenSymbol) Or ((@srcExtCurrency02ScreenSymbol IS NULL) And (@trgExtCurrency02ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency02ScreenSymbol IS NOT NULL) And (@trgExtCurrency02ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency02ScreenSymbol = ' + @srcExtCurrency02ScreenSymbol + ' / ' + @trgExtCurrency02ScreenSymbol
  END
  IF (@srcExtCurrency02Desc <> @trgExtCurrency02Desc) Or ((@srcExtCurrency02Desc IS NULL) And (@trgExtCurrency02Desc IS NOT NULL)) Or ((@srcExtCurrency02Desc IS NOT NULL) And (@trgExtCurrency02Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency02Desc = ' + @srcExtCurrency02Desc + ' / ' + @trgExtCurrency02Desc
  END
  IF (@srcExtCurrency02CompanyRate <> @trgExtCurrency02CompanyRate) Or ((@srcExtCurrency02CompanyRate IS NULL) And (@trgExtCurrency02CompanyRate IS NOT NULL)) Or ((@srcExtCurrency02CompanyRate IS NOT NULL) And (@trgExtCurrency02CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency02CompanyRate = ' + @srcExtCurrency02CompanyRate + ' / ' + @trgExtCurrency02CompanyRate
  END
  IF (@srcExtCurrency02DailyRate <> @trgExtCurrency02DailyRate) Or ((@srcExtCurrency02DailyRate IS NULL) And (@trgExtCurrency02DailyRate IS NOT NULL)) Or ((@srcExtCurrency02DailyRate IS NOT NULL) And (@trgExtCurrency02DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency02DailyRate = ' + @srcExtCurrency02DailyRate + ' / ' + @trgExtCurrency02DailyRate
  END
  IF (@srcExtCurrency02PrintSymbol <> @trgExtCurrency02PrintSymbol) Or ((@srcExtCurrency02PrintSymbol IS NULL) And (@trgExtCurrency02PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency02PrintSymbol IS NOT NULL) And (@trgExtCurrency02PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency02PrintSymbol = ' + @srcExtCurrency02PrintSymbol + ' / ' + @trgExtCurrency02PrintSymbol
  END
  IF (@srcExtCurrency03ScreenSymbol <> @trgExtCurrency03ScreenSymbol) Or ((@srcExtCurrency03ScreenSymbol IS NULL) And (@trgExtCurrency03ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency03ScreenSymbol IS NOT NULL) And (@trgExtCurrency03ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency03ScreenSymbol = ' + @srcExtCurrency03ScreenSymbol + ' / ' + @trgExtCurrency03ScreenSymbol
  END
  IF (@srcExtCurrency03Desc <> @trgExtCurrency03Desc) Or ((@srcExtCurrency03Desc IS NULL) And (@trgExtCurrency03Desc IS NOT NULL)) Or ((@srcExtCurrency03Desc IS NOT NULL) And (@trgExtCurrency03Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency03Desc = ' + @srcExtCurrency03Desc + ' / ' + @trgExtCurrency03Desc
  END
  IF (@srcExtCurrency03CompanyRate <> @trgExtCurrency03CompanyRate) Or ((@srcExtCurrency03CompanyRate IS NULL) And (@trgExtCurrency03CompanyRate IS NOT NULL)) Or ((@srcExtCurrency03CompanyRate IS NOT NULL) And (@trgExtCurrency03CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency03CompanyRate = ' + @srcExtCurrency03CompanyRate + ' / ' + @trgExtCurrency03CompanyRate
  END
  IF (@srcExtCurrency03DailyRate <> @trgExtCurrency03DailyRate) Or ((@srcExtCurrency03DailyRate IS NULL) And (@trgExtCurrency03DailyRate IS NOT NULL)) Or ((@srcExtCurrency03DailyRate IS NOT NULL) And (@trgExtCurrency03DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency03DailyRate = ' + @srcExtCurrency03DailyRate + ' / ' + @trgExtCurrency03DailyRate
  END
  IF (@srcExtCurrency03PrintSymbol <> @trgExtCurrency03PrintSymbol) Or ((@srcExtCurrency03PrintSymbol IS NULL) And (@trgExtCurrency03PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency03PrintSymbol IS NOT NULL) And (@trgExtCurrency03PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency03PrintSymbol = ' + @srcExtCurrency03PrintSymbol + ' / ' + @trgExtCurrency03PrintSymbol
  END
  IF (@srcExtCurrency04ScreenSymbol <> @trgExtCurrency04ScreenSymbol) Or ((@srcExtCurrency04ScreenSymbol IS NULL) And (@trgExtCurrency04ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency04ScreenSymbol IS NOT NULL) And (@trgExtCurrency04ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency04ScreenSymbol = ' + @srcExtCurrency04ScreenSymbol + ' / ' + @trgExtCurrency04ScreenSymbol
  END
  IF (@srcExtCurrency04Desc <> @trgExtCurrency04Desc) Or ((@srcExtCurrency04Desc IS NULL) And (@trgExtCurrency04Desc IS NOT NULL)) Or ((@srcExtCurrency04Desc IS NOT NULL) And (@trgExtCurrency04Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency04Desc = ' + @srcExtCurrency04Desc + ' / ' + @trgExtCurrency04Desc
  END
  IF (@srcExtCurrency04CompanyRate <> @trgExtCurrency04CompanyRate) Or ((@srcExtCurrency04CompanyRate IS NULL) And (@trgExtCurrency04CompanyRate IS NOT NULL)) Or ((@srcExtCurrency04CompanyRate IS NOT NULL) And (@trgExtCurrency04CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency04CompanyRate = ' + @srcExtCurrency04CompanyRate + ' / ' + @trgExtCurrency04CompanyRate
  END
  IF (@srcExtCurrency04DailyRate <> @trgExtCurrency04DailyRate) Or ((@srcExtCurrency04DailyRate IS NULL) And (@trgExtCurrency04DailyRate IS NOT NULL)) Or ((@srcExtCurrency04DailyRate IS NOT NULL) And (@trgExtCurrency04DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency04DailyRate = ' + @srcExtCurrency04DailyRate + ' / ' + @trgExtCurrency04DailyRate
  END
  IF (@srcExtCurrency04PrintSymbol <> @trgExtCurrency04PrintSymbol) Or ((@srcExtCurrency04PrintSymbol IS NULL) And (@trgExtCurrency04PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency04PrintSymbol IS NOT NULL) And (@trgExtCurrency04PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency04PrintSymbol = ' + @srcExtCurrency04PrintSymbol + ' / ' + @trgExtCurrency04PrintSymbol
  END
  IF (@srcExtCurrency05ScreenSymbol <> @trgExtCurrency05ScreenSymbol) Or ((@srcExtCurrency05ScreenSymbol IS NULL) And (@trgExtCurrency05ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency05ScreenSymbol IS NOT NULL) And (@trgExtCurrency05ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency05ScreenSymbol = ' + @srcExtCurrency05ScreenSymbol + ' / ' + @trgExtCurrency05ScreenSymbol
  END
  IF (@srcExtCurrency05Desc <> @trgExtCurrency05Desc) Or ((@srcExtCurrency05Desc IS NULL) And (@trgExtCurrency05Desc IS NOT NULL)) Or ((@srcExtCurrency05Desc IS NOT NULL) And (@trgExtCurrency05Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency05Desc = ' + @srcExtCurrency05Desc + ' / ' + @trgExtCurrency05Desc
  END
  IF (@srcExtCurrency05CompanyRate <> @trgExtCurrency05CompanyRate) Or ((@srcExtCurrency05CompanyRate IS NULL) And (@trgExtCurrency05CompanyRate IS NOT NULL)) Or ((@srcExtCurrency05CompanyRate IS NOT NULL) And (@trgExtCurrency05CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency05CompanyRate = ' + @srcExtCurrency05CompanyRate + ' / ' + @trgExtCurrency05CompanyRate
  END
  IF (@srcExtCurrency05DailyRate <> @trgExtCurrency05DailyRate) Or ((@srcExtCurrency05DailyRate IS NULL) And (@trgExtCurrency05DailyRate IS NOT NULL)) Or ((@srcExtCurrency05DailyRate IS NOT NULL) And (@trgExtCurrency05DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency05DailyRate = ' + @srcExtCurrency05DailyRate + ' / ' + @trgExtCurrency05DailyRate
  END
  IF (@srcExtCurrency05PrintSymbol <> @trgExtCurrency05PrintSymbol) Or ((@srcExtCurrency05PrintSymbol IS NULL) And (@trgExtCurrency05PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency05PrintSymbol IS NOT NULL) And (@trgExtCurrency05PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency05PrintSymbol = ' + @srcExtCurrency05PrintSymbol + ' / ' + @trgExtCurrency05PrintSymbol
  END
  IF (@srcExtCurrency06ScreenSymbol <> @trgExtCurrency06ScreenSymbol) Or ((@srcExtCurrency06ScreenSymbol IS NULL) And (@trgExtCurrency06ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency06ScreenSymbol IS NOT NULL) And (@trgExtCurrency06ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency06ScreenSymbol = ' + @srcExtCurrency06ScreenSymbol + ' / ' + @trgExtCurrency06ScreenSymbol
  END
  IF (@srcExtCurrency06Desc <> @trgExtCurrency06Desc) Or ((@srcExtCurrency06Desc IS NULL) And (@trgExtCurrency06Desc IS NOT NULL)) Or ((@srcExtCurrency06Desc IS NOT NULL) And (@trgExtCurrency06Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency06Desc = ' + @srcExtCurrency06Desc + ' / ' + @trgExtCurrency06Desc
  END
  IF (@srcExtCurrency06CompanyRate <> @trgExtCurrency06CompanyRate) Or ((@srcExtCurrency06CompanyRate IS NULL) And (@trgExtCurrency06CompanyRate IS NOT NULL)) Or ((@srcExtCurrency06CompanyRate IS NOT NULL) And (@trgExtCurrency06CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency06CompanyRate = ' + @srcExtCurrency06CompanyRate + ' / ' + @trgExtCurrency06CompanyRate
  END
  IF (@srcExtCurrency06DailyRate <> @trgExtCurrency06DailyRate) Or ((@srcExtCurrency06DailyRate IS NULL) And (@trgExtCurrency06DailyRate IS NOT NULL)) Or ((@srcExtCurrency06DailyRate IS NOT NULL) And (@trgExtCurrency06DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency06DailyRate = ' + @srcExtCurrency06DailyRate + ' / ' + @trgExtCurrency06DailyRate
  END
  IF (@srcExtCurrency06PrintSymbol <> @trgExtCurrency06PrintSymbol) Or ((@srcExtCurrency06PrintSymbol IS NULL) And (@trgExtCurrency06PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency06PrintSymbol IS NOT NULL) And (@trgExtCurrency06PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency06PrintSymbol = ' + @srcExtCurrency06PrintSymbol + ' / ' + @trgExtCurrency06PrintSymbol
  END
  IF (@srcExtCurrency07ScreenSymbol <> @trgExtCurrency07ScreenSymbol) Or ((@srcExtCurrency07ScreenSymbol IS NULL) And (@trgExtCurrency07ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency07ScreenSymbol IS NOT NULL) And (@trgExtCurrency07ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency07ScreenSymbol = ' + @srcExtCurrency07ScreenSymbol + ' / ' + @trgExtCurrency07ScreenSymbol
  END
  IF (@srcExtCurrency07Desc <> @trgExtCurrency07Desc) Or ((@srcExtCurrency07Desc IS NULL) And (@trgExtCurrency07Desc IS NOT NULL)) Or ((@srcExtCurrency07Desc IS NOT NULL) And (@trgExtCurrency07Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency07Desc = ' + @srcExtCurrency07Desc + ' / ' + @trgExtCurrency07Desc
  END
  IF (@srcExtCurrency07CompanyRate <> @trgExtCurrency07CompanyRate) Or ((@srcExtCurrency07CompanyRate IS NULL) And (@trgExtCurrency07CompanyRate IS NOT NULL)) Or ((@srcExtCurrency07CompanyRate IS NOT NULL) And (@trgExtCurrency07CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency07CompanyRate = ' + @srcExtCurrency07CompanyRate + ' / ' + @trgExtCurrency07CompanyRate
  END
  IF (@srcExtCurrency07DailyRate <> @trgExtCurrency07DailyRate) Or ((@srcExtCurrency07DailyRate IS NULL) And (@trgExtCurrency07DailyRate IS NOT NULL)) Or ((@srcExtCurrency07DailyRate IS NOT NULL) And (@trgExtCurrency07DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency07DailyRate = ' + @srcExtCurrency07DailyRate + ' / ' + @trgExtCurrency07DailyRate
  END
  IF (@srcExtCurrency07PrintSymbol <> @trgExtCurrency07PrintSymbol) Or ((@srcExtCurrency07PrintSymbol IS NULL) And (@trgExtCurrency07PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency07PrintSymbol IS NOT NULL) And (@trgExtCurrency07PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency07PrintSymbol = ' + @srcExtCurrency07PrintSymbol + ' / ' + @trgExtCurrency07PrintSymbol
  END
  IF (@srcExtCurrency08ScreenSymbol <> @trgExtCurrency08ScreenSymbol) Or ((@srcExtCurrency08ScreenSymbol IS NULL) And (@trgExtCurrency08ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency08ScreenSymbol IS NOT NULL) And (@trgExtCurrency08ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency08ScreenSymbol = ' + @srcExtCurrency08ScreenSymbol + ' / ' + @trgExtCurrency08ScreenSymbol
  END
  IF (@srcExtCurrency08Desc <> @trgExtCurrency08Desc) Or ((@srcExtCurrency08Desc IS NULL) And (@trgExtCurrency08Desc IS NOT NULL)) Or ((@srcExtCurrency08Desc IS NOT NULL) And (@trgExtCurrency08Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency08Desc = ' + @srcExtCurrency08Desc + ' / ' + @trgExtCurrency08Desc
  END
  IF (@srcExtCurrency08CompanyRate <> @trgExtCurrency08CompanyRate) Or ((@srcExtCurrency08CompanyRate IS NULL) And (@trgExtCurrency08CompanyRate IS NOT NULL)) Or ((@srcExtCurrency08CompanyRate IS NOT NULL) And (@trgExtCurrency08CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency08CompanyRate = ' + @srcExtCurrency08CompanyRate + ' / ' + @trgExtCurrency08CompanyRate
  END
  IF (@srcExtCurrency08DailyRate <> @trgExtCurrency08DailyRate) Or ((@srcExtCurrency08DailyRate IS NULL) And (@trgExtCurrency08DailyRate IS NOT NULL)) Or ((@srcExtCurrency08DailyRate IS NOT NULL) And (@trgExtCurrency08DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency08DailyRate = ' + @srcExtCurrency08DailyRate + ' / ' + @trgExtCurrency08DailyRate
  END
  IF (@srcExtCurrency08PrintSymbol <> @trgExtCurrency08PrintSymbol) Or ((@srcExtCurrency08PrintSymbol IS NULL) And (@trgExtCurrency08PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency08PrintSymbol IS NOT NULL) And (@trgExtCurrency08PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency08PrintSymbol = ' + @srcExtCurrency08PrintSymbol + ' / ' + @trgExtCurrency08PrintSymbol
  END
  IF (@srcExtCurrency09ScreenSymbol <> @trgExtCurrency09ScreenSymbol) Or ((@srcExtCurrency09ScreenSymbol IS NULL) And (@trgExtCurrency09ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency09ScreenSymbol IS NOT NULL) And (@trgExtCurrency09ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency09ScreenSymbol = ' + @srcExtCurrency09ScreenSymbol + ' / ' + @trgExtCurrency09ScreenSymbol
  END
  IF (@srcExtCurrency09Desc <> @trgExtCurrency09Desc) Or ((@srcExtCurrency09Desc IS NULL) And (@trgExtCurrency09Desc IS NOT NULL)) Or ((@srcExtCurrency09Desc IS NOT NULL) And (@trgExtCurrency09Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency09Desc = ' + @srcExtCurrency09Desc + ' / ' + @trgExtCurrency09Desc
  END
  IF (@srcExtCurrency09CompanyRate <> @trgExtCurrency09CompanyRate) Or ((@srcExtCurrency09CompanyRate IS NULL) And (@trgExtCurrency09CompanyRate IS NOT NULL)) Or ((@srcExtCurrency09CompanyRate IS NOT NULL) And (@trgExtCurrency09CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency09CompanyRate = ' + @srcExtCurrency09CompanyRate + ' / ' + @trgExtCurrency09CompanyRate
  END
  IF (@srcExtCurrency09DailyRate <> @trgExtCurrency09DailyRate) Or ((@srcExtCurrency09DailyRate IS NULL) And (@trgExtCurrency09DailyRate IS NOT NULL)) Or ((@srcExtCurrency09DailyRate IS NOT NULL) And (@trgExtCurrency09DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency09DailyRate = ' + @srcExtCurrency09DailyRate + ' / ' + @trgExtCurrency09DailyRate
  END
  IF (@srcExtCurrency09PrintSymbol <> @trgExtCurrency09PrintSymbol) Or ((@srcExtCurrency09PrintSymbol IS NULL) And (@trgExtCurrency09PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency09PrintSymbol IS NOT NULL) And (@trgExtCurrency09PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency09PrintSymbol = ' + @srcExtCurrency09PrintSymbol + ' / ' + @trgExtCurrency09PrintSymbol
  END
  IF (@srcExtCurrency10ScreenSymbol <> @trgExtCurrency10ScreenSymbol) Or ((@srcExtCurrency10ScreenSymbol IS NULL) And (@trgExtCurrency10ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency10ScreenSymbol IS NOT NULL) And (@trgExtCurrency10ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency10ScreenSymbol = ' + @srcExtCurrency10ScreenSymbol + ' / ' + @trgExtCurrency10ScreenSymbol
  END
  IF (@srcExtCurrency10Desc <> @trgExtCurrency10Desc) Or ((@srcExtCurrency10Desc IS NULL) And (@trgExtCurrency10Desc IS NOT NULL)) Or ((@srcExtCurrency10Desc IS NOT NULL) And (@trgExtCurrency10Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency10Desc = ' + @srcExtCurrency10Desc + ' / ' + @trgExtCurrency10Desc
  END
  IF (@srcExtCurrency10CompanyRate <> @trgExtCurrency10CompanyRate) Or ((@srcExtCurrency10CompanyRate IS NULL) And (@trgExtCurrency10CompanyRate IS NOT NULL)) Or ((@srcExtCurrency10CompanyRate IS NOT NULL) And (@trgExtCurrency10CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency10CompanyRate = ' + @srcExtCurrency10CompanyRate + ' / ' + @trgExtCurrency10CompanyRate
  END
  IF (@srcExtCurrency10DailyRate <> @trgExtCurrency10DailyRate) Or ((@srcExtCurrency10DailyRate IS NULL) And (@trgExtCurrency10DailyRate IS NOT NULL)) Or ((@srcExtCurrency10DailyRate IS NOT NULL) And (@trgExtCurrency10DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency10DailyRate = ' + @srcExtCurrency10DailyRate + ' / ' + @trgExtCurrency10DailyRate
  END
  IF (@srcExtCurrency10PrintSymbol <> @trgExtCurrency10PrintSymbol) Or ((@srcExtCurrency10PrintSymbol IS NULL) And (@trgExtCurrency10PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency10PrintSymbol IS NOT NULL) And (@trgExtCurrency10PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency10PrintSymbol = ' + @srcExtCurrency10PrintSymbol + ' / ' + @trgExtCurrency10PrintSymbol
  END
  IF (@srcExtCurrency11ScreenSymbol <> @trgExtCurrency11ScreenSymbol) Or ((@srcExtCurrency11ScreenSymbol IS NULL) And (@trgExtCurrency11ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency11ScreenSymbol IS NOT NULL) And (@trgExtCurrency11ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency11ScreenSymbol = ' + @srcExtCurrency11ScreenSymbol + ' / ' + @trgExtCurrency11ScreenSymbol
  END
  IF (@srcExtCurrency11Desc <> @trgExtCurrency11Desc) Or ((@srcExtCurrency11Desc IS NULL) And (@trgExtCurrency11Desc IS NOT NULL)) Or ((@srcExtCurrency11Desc IS NOT NULL) And (@trgExtCurrency11Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency11Desc = ' + @srcExtCurrency11Desc + ' / ' + @trgExtCurrency11Desc
  END
  IF (@srcExtCurrency11CompanyRate <> @trgExtCurrency11CompanyRate) Or ((@srcExtCurrency11CompanyRate IS NULL) And (@trgExtCurrency11CompanyRate IS NOT NULL)) Or ((@srcExtCurrency11CompanyRate IS NOT NULL) And (@trgExtCurrency11CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency11CompanyRate = ' + @srcExtCurrency11CompanyRate + ' / ' + @trgExtCurrency11CompanyRate
  END
  IF (@srcExtCurrency11DailyRate <> @trgExtCurrency11DailyRate) Or ((@srcExtCurrency11DailyRate IS NULL) And (@trgExtCurrency11DailyRate IS NOT NULL)) Or ((@srcExtCurrency11DailyRate IS NOT NULL) And (@trgExtCurrency11DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency11DailyRate = ' + @srcExtCurrency11DailyRate + ' / ' + @trgExtCurrency11DailyRate
  END
  IF (@srcExtCurrency11PrintSymbol <> @trgExtCurrency11PrintSymbol) Or ((@srcExtCurrency11PrintSymbol IS NULL) And (@trgExtCurrency11PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency11PrintSymbol IS NOT NULL) And (@trgExtCurrency11PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency11PrintSymbol = ' + @srcExtCurrency11PrintSymbol + ' / ' + @trgExtCurrency11PrintSymbol
  END
  IF (@srcExtCurrency12ScreenSymbol <> @trgExtCurrency12ScreenSymbol) Or ((@srcExtCurrency12ScreenSymbol IS NULL) And (@trgExtCurrency12ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency12ScreenSymbol IS NOT NULL) And (@trgExtCurrency12ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency12ScreenSymbol = ' + @srcExtCurrency12ScreenSymbol + ' / ' + @trgExtCurrency12ScreenSymbol
  END
  IF (@srcExtCurrency12Desc <> @trgExtCurrency12Desc) Or ((@srcExtCurrency12Desc IS NULL) And (@trgExtCurrency12Desc IS NOT NULL)) Or ((@srcExtCurrency12Desc IS NOT NULL) And (@trgExtCurrency12Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency12Desc = ' + @srcExtCurrency12Desc + ' / ' + @trgExtCurrency12Desc
  END
  IF (@srcExtCurrency12CompanyRate <> @trgExtCurrency12CompanyRate) Or ((@srcExtCurrency12CompanyRate IS NULL) And (@trgExtCurrency12CompanyRate IS NOT NULL)) Or ((@srcExtCurrency12CompanyRate IS NOT NULL) And (@trgExtCurrency12CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency12CompanyRate = ' + @srcExtCurrency12CompanyRate + ' / ' + @trgExtCurrency12CompanyRate
  END
  IF (@srcExtCurrency12DailyRate <> @trgExtCurrency12DailyRate) Or ((@srcExtCurrency12DailyRate IS NULL) And (@trgExtCurrency12DailyRate IS NOT NULL)) Or ((@srcExtCurrency12DailyRate IS NOT NULL) And (@trgExtCurrency12DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency12DailyRate = ' + @srcExtCurrency12DailyRate + ' / ' + @trgExtCurrency12DailyRate
  END
  IF (@srcExtCurrency12PrintSymbol <> @trgExtCurrency12PrintSymbol) Or ((@srcExtCurrency12PrintSymbol IS NULL) And (@trgExtCurrency12PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency12PrintSymbol IS NOT NULL) And (@trgExtCurrency12PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency12PrintSymbol = ' + @srcExtCurrency12PrintSymbol + ' / ' + @trgExtCurrency12PrintSymbol
  END
  IF (@srcExtCurrency13ScreenSymbol <> @trgExtCurrency13ScreenSymbol) Or ((@srcExtCurrency13ScreenSymbol IS NULL) And (@trgExtCurrency13ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency13ScreenSymbol IS NOT NULL) And (@trgExtCurrency13ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency13ScreenSymbol = ' + @srcExtCurrency13ScreenSymbol + ' / ' + @trgExtCurrency13ScreenSymbol
  END
  IF (@srcExtCurrency13Desc <> @trgExtCurrency13Desc) Or ((@srcExtCurrency13Desc IS NULL) And (@trgExtCurrency13Desc IS NOT NULL)) Or ((@srcExtCurrency13Desc IS NOT NULL) And (@trgExtCurrency13Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency13Desc = ' + @srcExtCurrency13Desc + ' / ' + @trgExtCurrency13Desc
  END
  IF (@srcExtCurrency13CompanyRate <> @trgExtCurrency13CompanyRate) Or ((@srcExtCurrency13CompanyRate IS NULL) And (@trgExtCurrency13CompanyRate IS NOT NULL)) Or ((@srcExtCurrency13CompanyRate IS NOT NULL) And (@trgExtCurrency13CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency13CompanyRate = ' + @srcExtCurrency13CompanyRate + ' / ' + @trgExtCurrency13CompanyRate
  END
  IF (@srcExtCurrency13DailyRate <> @trgExtCurrency13DailyRate) Or ((@srcExtCurrency13DailyRate IS NULL) And (@trgExtCurrency13DailyRate IS NOT NULL)) Or ((@srcExtCurrency13DailyRate IS NOT NULL) And (@trgExtCurrency13DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency13DailyRate = ' + @srcExtCurrency13DailyRate + ' / ' + @trgExtCurrency13DailyRate
  END
  IF (@srcExtCurrency13PrintSymbol <> @trgExtCurrency13PrintSymbol) Or ((@srcExtCurrency13PrintSymbol IS NULL) And (@trgExtCurrency13PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency13PrintSymbol IS NOT NULL) And (@trgExtCurrency13PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency13PrintSymbol = ' + @srcExtCurrency13PrintSymbol + ' / ' + @trgExtCurrency13PrintSymbol
  END
  IF (@srcExtCurrency14ScreenSymbol <> @trgExtCurrency14ScreenSymbol) Or ((@srcExtCurrency14ScreenSymbol IS NULL) And (@trgExtCurrency14ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency14ScreenSymbol IS NOT NULL) And (@trgExtCurrency14ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency14ScreenSymbol = ' + @srcExtCurrency14ScreenSymbol + ' / ' + @trgExtCurrency14ScreenSymbol
  END
  IF (@srcExtCurrency14Desc <> @trgExtCurrency14Desc) Or ((@srcExtCurrency14Desc IS NULL) And (@trgExtCurrency14Desc IS NOT NULL)) Or ((@srcExtCurrency14Desc IS NOT NULL) And (@trgExtCurrency14Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency14Desc = ' + @srcExtCurrency14Desc + ' / ' + @trgExtCurrency14Desc
  END
  IF (@srcExtCurrency14CompanyRate <> @trgExtCurrency14CompanyRate) Or ((@srcExtCurrency14CompanyRate IS NULL) And (@trgExtCurrency14CompanyRate IS NOT NULL)) Or ((@srcExtCurrency14CompanyRate IS NOT NULL) And (@trgExtCurrency14CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency14CompanyRate = ' + @srcExtCurrency14CompanyRate + ' / ' + @trgExtCurrency14CompanyRate
  END
  IF (@srcExtCurrency14DailyRate <> @trgExtCurrency14DailyRate) Or ((@srcExtCurrency14DailyRate IS NULL) And (@trgExtCurrency14DailyRate IS NOT NULL)) Or ((@srcExtCurrency14DailyRate IS NOT NULL) And (@trgExtCurrency14DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency14DailyRate = ' + @srcExtCurrency14DailyRate + ' / ' + @trgExtCurrency14DailyRate
  END
  IF (@srcExtCurrency14PrintSymbol <> @trgExtCurrency14PrintSymbol) Or ((@srcExtCurrency14PrintSymbol IS NULL) And (@trgExtCurrency14PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency14PrintSymbol IS NOT NULL) And (@trgExtCurrency14PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency14PrintSymbol = ' + @srcExtCurrency14PrintSymbol + ' / ' + @trgExtCurrency14PrintSymbol
  END
  IF (@srcExtCurrency15ScreenSymbol <> @trgExtCurrency15ScreenSymbol) Or ((@srcExtCurrency15ScreenSymbol IS NULL) And (@trgExtCurrency15ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency15ScreenSymbol IS NOT NULL) And (@trgExtCurrency15ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency15ScreenSymbol = ' + @srcExtCurrency15ScreenSymbol + ' / ' + @trgExtCurrency15ScreenSymbol
  END
  IF (@srcExtCurrency15Desc <> @trgExtCurrency15Desc) Or ((@srcExtCurrency15Desc IS NULL) And (@trgExtCurrency15Desc IS NOT NULL)) Or ((@srcExtCurrency15Desc IS NOT NULL) And (@trgExtCurrency15Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency15Desc = ' + @srcExtCurrency15Desc + ' / ' + @trgExtCurrency15Desc
  END
  IF (@srcExtCurrency15CompanyRate <> @trgExtCurrency15CompanyRate) Or ((@srcExtCurrency15CompanyRate IS NULL) And (@trgExtCurrency15CompanyRate IS NOT NULL)) Or ((@srcExtCurrency15CompanyRate IS NOT NULL) And (@trgExtCurrency15CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency15CompanyRate = ' + @srcExtCurrency15CompanyRate + ' / ' + @trgExtCurrency15CompanyRate
  END
  IF (@srcExtCurrency15DailyRate <> @trgExtCurrency15DailyRate) Or ((@srcExtCurrency15DailyRate IS NULL) And (@trgExtCurrency15DailyRate IS NOT NULL)) Or ((@srcExtCurrency15DailyRate IS NOT NULL) And (@trgExtCurrency15DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency15DailyRate = ' + @srcExtCurrency15DailyRate + ' / ' + @trgExtCurrency15DailyRate
  END
  IF (@srcExtCurrency15PrintSymbol <> @trgExtCurrency15PrintSymbol) Or ((@srcExtCurrency15PrintSymbol IS NULL) And (@trgExtCurrency15PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency15PrintSymbol IS NOT NULL) And (@trgExtCurrency15PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency15PrintSymbol = ' + @srcExtCurrency15PrintSymbol + ' / ' + @trgExtCurrency15PrintSymbol
  END
  IF (@srcExtCurrency16ScreenSymbol <> @trgExtCurrency16ScreenSymbol) Or ((@srcExtCurrency16ScreenSymbol IS NULL) And (@trgExtCurrency16ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency16ScreenSymbol IS NOT NULL) And (@trgExtCurrency16ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency16ScreenSymbol = ' + @srcExtCurrency16ScreenSymbol + ' / ' + @trgExtCurrency16ScreenSymbol
  END
  IF (@srcExtCurrency16Desc <> @trgExtCurrency16Desc) Or ((@srcExtCurrency16Desc IS NULL) And (@trgExtCurrency16Desc IS NOT NULL)) Or ((@srcExtCurrency16Desc IS NOT NULL) And (@trgExtCurrency16Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency16Desc = ' + @srcExtCurrency16Desc + ' / ' + @trgExtCurrency16Desc
  END
  IF (@srcExtCurrency16CompanyRate <> @trgExtCurrency16CompanyRate) Or ((@srcExtCurrency16CompanyRate IS NULL) And (@trgExtCurrency16CompanyRate IS NOT NULL)) Or ((@srcExtCurrency16CompanyRate IS NOT NULL) And (@trgExtCurrency16CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency16CompanyRate = ' + @srcExtCurrency16CompanyRate + ' / ' + @trgExtCurrency16CompanyRate
  END
  IF (@srcExtCurrency16DailyRate <> @trgExtCurrency16DailyRate) Or ((@srcExtCurrency16DailyRate IS NULL) And (@trgExtCurrency16DailyRate IS NOT NULL)) Or ((@srcExtCurrency16DailyRate IS NOT NULL) And (@trgExtCurrency16DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency16DailyRate = ' + @srcExtCurrency16DailyRate + ' / ' + @trgExtCurrency16DailyRate
  END
  IF (@srcExtCurrency16PrintSymbol <> @trgExtCurrency16PrintSymbol) Or ((@srcExtCurrency16PrintSymbol IS NULL) And (@trgExtCurrency16PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency16PrintSymbol IS NOT NULL) And (@trgExtCurrency16PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency16PrintSymbol = ' + @srcExtCurrency16PrintSymbol + ' / ' + @trgExtCurrency16PrintSymbol
  END
  IF (@srcExtCurrency17ScreenSymbol <> @trgExtCurrency17ScreenSymbol) Or ((@srcExtCurrency17ScreenSymbol IS NULL) And (@trgExtCurrency17ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency17ScreenSymbol IS NOT NULL) And (@trgExtCurrency17ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency17ScreenSymbol = ' + @srcExtCurrency17ScreenSymbol + ' / ' + @trgExtCurrency17ScreenSymbol
  END
  IF (@srcExtCurrency17Desc <> @trgExtCurrency17Desc) Or ((@srcExtCurrency17Desc IS NULL) And (@trgExtCurrency17Desc IS NOT NULL)) Or ((@srcExtCurrency17Desc IS NOT NULL) And (@trgExtCurrency17Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency17Desc = ' + @srcExtCurrency17Desc + ' / ' + @trgExtCurrency17Desc
  END
  IF (@srcExtCurrency17CompanyRate <> @trgExtCurrency17CompanyRate) Or ((@srcExtCurrency17CompanyRate IS NULL) And (@trgExtCurrency17CompanyRate IS NOT NULL)) Or ((@srcExtCurrency17CompanyRate IS NOT NULL) And (@trgExtCurrency17CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency17CompanyRate = ' + @srcExtCurrency17CompanyRate + ' / ' + @trgExtCurrency17CompanyRate
  END
  IF (@srcExtCurrency17DailyRate <> @trgExtCurrency17DailyRate) Or ((@srcExtCurrency17DailyRate IS NULL) And (@trgExtCurrency17DailyRate IS NOT NULL)) Or ((@srcExtCurrency17DailyRate IS NOT NULL) And (@trgExtCurrency17DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency17DailyRate = ' + @srcExtCurrency17DailyRate + ' / ' + @trgExtCurrency17DailyRate
  END
  IF (@srcExtCurrency17PrintSymbol <> @trgExtCurrency17PrintSymbol) Or ((@srcExtCurrency17PrintSymbol IS NULL) And (@trgExtCurrency17PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency17PrintSymbol IS NOT NULL) And (@trgExtCurrency17PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency17PrintSymbol = ' + @srcExtCurrency17PrintSymbol + ' / ' + @trgExtCurrency17PrintSymbol
  END
  IF (@srcExtCurrency18ScreenSymbol <> @trgExtCurrency18ScreenSymbol) Or ((@srcExtCurrency18ScreenSymbol IS NULL) And (@trgExtCurrency18ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency18ScreenSymbol IS NOT NULL) And (@trgExtCurrency18ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency18ScreenSymbol = ' + @srcExtCurrency18ScreenSymbol + ' / ' + @trgExtCurrency18ScreenSymbol
  END
  IF (@srcExtCurrency18Desc <> @trgExtCurrency18Desc) Or ((@srcExtCurrency18Desc IS NULL) And (@trgExtCurrency18Desc IS NOT NULL)) Or ((@srcExtCurrency18Desc IS NOT NULL) And (@trgExtCurrency18Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency18Desc = ' + @srcExtCurrency18Desc + ' / ' + @trgExtCurrency18Desc
  END
  IF (@srcExtCurrency18CompanyRate <> @trgExtCurrency18CompanyRate) Or ((@srcExtCurrency18CompanyRate IS NULL) And (@trgExtCurrency18CompanyRate IS NOT NULL)) Or ((@srcExtCurrency18CompanyRate IS NOT NULL) And (@trgExtCurrency18CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency18CompanyRate = ' + @srcExtCurrency18CompanyRate + ' / ' + @trgExtCurrency18CompanyRate
  END
  IF (@srcExtCurrency18DailyRate <> @trgExtCurrency18DailyRate) Or ((@srcExtCurrency18DailyRate IS NULL) And (@trgExtCurrency18DailyRate IS NOT NULL)) Or ((@srcExtCurrency18DailyRate IS NOT NULL) And (@trgExtCurrency18DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency18DailyRate = ' + @srcExtCurrency18DailyRate + ' / ' + @trgExtCurrency18DailyRate
  END
  IF (@srcExtCurrency18PrintSymbol <> @trgExtCurrency18PrintSymbol) Or ((@srcExtCurrency18PrintSymbol IS NULL) And (@trgExtCurrency18PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency18PrintSymbol IS NOT NULL) And (@trgExtCurrency18PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency18PrintSymbol = ' + @srcExtCurrency18PrintSymbol + ' / ' + @trgExtCurrency18PrintSymbol
  END
  IF (@srcExtCurrency19ScreenSymbol <> @trgExtCurrency19ScreenSymbol) Or ((@srcExtCurrency19ScreenSymbol IS NULL) And (@trgExtCurrency19ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency19ScreenSymbol IS NOT NULL) And (@trgExtCurrency19ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency19ScreenSymbol = ' + @srcExtCurrency19ScreenSymbol + ' / ' + @trgExtCurrency19ScreenSymbol
  END
  IF (@srcExtCurrency19Desc <> @trgExtCurrency19Desc) Or ((@srcExtCurrency19Desc IS NULL) And (@trgExtCurrency19Desc IS NOT NULL)) Or ((@srcExtCurrency19Desc IS NOT NULL) And (@trgExtCurrency19Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency19Desc = ' + @srcExtCurrency19Desc + ' / ' + @trgExtCurrency19Desc
  END
  IF (@srcExtCurrency19CompanyRate <> @trgExtCurrency19CompanyRate) Or ((@srcExtCurrency19CompanyRate IS NULL) And (@trgExtCurrency19CompanyRate IS NOT NULL)) Or ((@srcExtCurrency19CompanyRate IS NOT NULL) And (@trgExtCurrency19CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency19CompanyRate = ' + @srcExtCurrency19CompanyRate + ' / ' + @trgExtCurrency19CompanyRate
  END
  IF (@srcExtCurrency19DailyRate <> @trgExtCurrency19DailyRate) Or ((@srcExtCurrency19DailyRate IS NULL) And (@trgExtCurrency19DailyRate IS NOT NULL)) Or ((@srcExtCurrency19DailyRate IS NOT NULL) And (@trgExtCurrency19DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency19DailyRate = ' + @srcExtCurrency19DailyRate + ' / ' + @trgExtCurrency19DailyRate
  END
  IF (@srcExtCurrency19PrintSymbol <> @trgExtCurrency19PrintSymbol) Or ((@srcExtCurrency19PrintSymbol IS NULL) And (@trgExtCurrency19PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency19PrintSymbol IS NOT NULL) And (@trgExtCurrency19PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency19PrintSymbol = ' + @srcExtCurrency19PrintSymbol + ' / ' + @trgExtCurrency19PrintSymbol
  END
  IF (@srcExtCurrency20ScreenSymbol <> @trgExtCurrency20ScreenSymbol) Or ((@srcExtCurrency20ScreenSymbol IS NULL) And (@trgExtCurrency20ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency20ScreenSymbol IS NOT NULL) And (@trgExtCurrency20ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency20ScreenSymbol = ' + @srcExtCurrency20ScreenSymbol + ' / ' + @trgExtCurrency20ScreenSymbol
  END
  IF (@srcExtCurrency20Desc <> @trgExtCurrency20Desc) Or ((@srcExtCurrency20Desc IS NULL) And (@trgExtCurrency20Desc IS NOT NULL)) Or ((@srcExtCurrency20Desc IS NOT NULL) And (@trgExtCurrency20Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency20Desc = ' + @srcExtCurrency20Desc + ' / ' + @trgExtCurrency20Desc
  END
  IF (@srcExtCurrency20CompanyRate <> @trgExtCurrency20CompanyRate) Or ((@srcExtCurrency20CompanyRate IS NULL) And (@trgExtCurrency20CompanyRate IS NOT NULL)) Or ((@srcExtCurrency20CompanyRate IS NOT NULL) And (@trgExtCurrency20CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency20CompanyRate = ' + @srcExtCurrency20CompanyRate + ' / ' + @trgExtCurrency20CompanyRate
  END
  IF (@srcExtCurrency20DailyRate <> @trgExtCurrency20DailyRate) Or ((@srcExtCurrency20DailyRate IS NULL) And (@trgExtCurrency20DailyRate IS NOT NULL)) Or ((@srcExtCurrency20DailyRate IS NOT NULL) And (@trgExtCurrency20DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency20DailyRate = ' + @srcExtCurrency20DailyRate + ' / ' + @trgExtCurrency20DailyRate
  END
  IF (@srcExtCurrency20PrintSymbol <> @trgExtCurrency20PrintSymbol) Or ((@srcExtCurrency20PrintSymbol IS NULL) And (@trgExtCurrency20PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency20PrintSymbol IS NOT NULL) And (@trgExtCurrency20PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency20PrintSymbol = ' + @srcExtCurrency20PrintSymbol + ' / ' + @trgExtCurrency20PrintSymbol
  END
  IF (@srcExtCurrency21ScreenSymbol <> @trgExtCurrency21ScreenSymbol) Or ((@srcExtCurrency21ScreenSymbol IS NULL) And (@trgExtCurrency21ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency21ScreenSymbol IS NOT NULL) And (@trgExtCurrency21ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency21ScreenSymbol = ' + @srcExtCurrency21ScreenSymbol + ' / ' + @trgExtCurrency21ScreenSymbol
  END
  IF (@srcExtCurrency21Desc <> @trgExtCurrency21Desc) Or ((@srcExtCurrency21Desc IS NULL) And (@trgExtCurrency21Desc IS NOT NULL)) Or ((@srcExtCurrency21Desc IS NOT NULL) And (@trgExtCurrency21Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency21Desc = ' + @srcExtCurrency21Desc + ' / ' + @trgExtCurrency21Desc
  END
  IF (@srcExtCurrency21CompanyRate <> @trgExtCurrency21CompanyRate) Or ((@srcExtCurrency21CompanyRate IS NULL) And (@trgExtCurrency21CompanyRate IS NOT NULL)) Or ((@srcExtCurrency21CompanyRate IS NOT NULL) And (@trgExtCurrency21CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency21CompanyRate = ' + @srcExtCurrency21CompanyRate + ' / ' + @trgExtCurrency21CompanyRate
  END
  IF (@srcExtCurrency21DailyRate <> @trgExtCurrency21DailyRate) Or ((@srcExtCurrency21DailyRate IS NULL) And (@trgExtCurrency21DailyRate IS NOT NULL)) Or ((@srcExtCurrency21DailyRate IS NOT NULL) And (@trgExtCurrency21DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency21DailyRate = ' + @srcExtCurrency21DailyRate + ' / ' + @trgExtCurrency21DailyRate
  END
  IF (@srcExtCurrency21PrintSymbol <> @trgExtCurrency21PrintSymbol) Or ((@srcExtCurrency21PrintSymbol IS NULL) And (@trgExtCurrency21PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency21PrintSymbol IS NOT NULL) And (@trgExtCurrency21PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency21PrintSymbol = ' + @srcExtCurrency21PrintSymbol + ' / ' + @trgExtCurrency21PrintSymbol
  END
  IF (@srcExtCurrency22ScreenSymbol <> @trgExtCurrency22ScreenSymbol) Or ((@srcExtCurrency22ScreenSymbol IS NULL) And (@trgExtCurrency22ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency22ScreenSymbol IS NOT NULL) And (@trgExtCurrency22ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency22ScreenSymbol = ' + @srcExtCurrency22ScreenSymbol + ' / ' + @trgExtCurrency22ScreenSymbol
  END
  IF (@srcExtCurrency22Desc <> @trgExtCurrency22Desc) Or ((@srcExtCurrency22Desc IS NULL) And (@trgExtCurrency22Desc IS NOT NULL)) Or ((@srcExtCurrency22Desc IS NOT NULL) And (@trgExtCurrency22Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency22Desc = ' + @srcExtCurrency22Desc + ' / ' + @trgExtCurrency22Desc
  END
  IF (@srcExtCurrency22CompanyRate <> @trgExtCurrency22CompanyRate) Or ((@srcExtCurrency22CompanyRate IS NULL) And (@trgExtCurrency22CompanyRate IS NOT NULL)) Or ((@srcExtCurrency22CompanyRate IS NOT NULL) And (@trgExtCurrency22CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency22CompanyRate = ' + @srcExtCurrency22CompanyRate + ' / ' + @trgExtCurrency22CompanyRate
  END
  IF (@srcExtCurrency22DailyRate <> @trgExtCurrency22DailyRate) Or ((@srcExtCurrency22DailyRate IS NULL) And (@trgExtCurrency22DailyRate IS NOT NULL)) Or ((@srcExtCurrency22DailyRate IS NOT NULL) And (@trgExtCurrency22DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency22DailyRate = ' + @srcExtCurrency22DailyRate + ' / ' + @trgExtCurrency22DailyRate
  END
  IF (@srcExtCurrency22PrintSymbol <> @trgExtCurrency22PrintSymbol) Or ((@srcExtCurrency22PrintSymbol IS NULL) And (@trgExtCurrency22PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency22PrintSymbol IS NOT NULL) And (@trgExtCurrency22PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency22PrintSymbol = ' + @srcExtCurrency22PrintSymbol + ' / ' + @trgExtCurrency22PrintSymbol
  END
  IF (@srcExtCurrency23ScreenSymbol <> @trgExtCurrency23ScreenSymbol) Or ((@srcExtCurrency23ScreenSymbol IS NULL) And (@trgExtCurrency23ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency23ScreenSymbol IS NOT NULL) And (@trgExtCurrency23ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency23ScreenSymbol = ' + @srcExtCurrency23ScreenSymbol + ' / ' + @trgExtCurrency23ScreenSymbol
  END
  IF (@srcExtCurrency23Desc <> @trgExtCurrency23Desc) Or ((@srcExtCurrency23Desc IS NULL) And (@trgExtCurrency23Desc IS NOT NULL)) Or ((@srcExtCurrency23Desc IS NOT NULL) And (@trgExtCurrency23Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency23Desc = ' + @srcExtCurrency23Desc + ' / ' + @trgExtCurrency23Desc
  END
  IF (@srcExtCurrency23CompanyRate <> @trgExtCurrency23CompanyRate) Or ((@srcExtCurrency23CompanyRate IS NULL) And (@trgExtCurrency23CompanyRate IS NOT NULL)) Or ((@srcExtCurrency23CompanyRate IS NOT NULL) And (@trgExtCurrency23CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency23CompanyRate = ' + @srcExtCurrency23CompanyRate + ' / ' + @trgExtCurrency23CompanyRate
  END
  IF (@srcExtCurrency23DailyRate <> @trgExtCurrency23DailyRate) Or ((@srcExtCurrency23DailyRate IS NULL) And (@trgExtCurrency23DailyRate IS NOT NULL)) Or ((@srcExtCurrency23DailyRate IS NOT NULL) And (@trgExtCurrency23DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency23DailyRate = ' + @srcExtCurrency23DailyRate + ' / ' + @trgExtCurrency23DailyRate
  END
  IF (@srcExtCurrency23PrintSymbol <> @trgExtCurrency23PrintSymbol) Or ((@srcExtCurrency23PrintSymbol IS NULL) And (@trgExtCurrency23PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency23PrintSymbol IS NOT NULL) And (@trgExtCurrency23PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency23PrintSymbol = ' + @srcExtCurrency23PrintSymbol + ' / ' + @trgExtCurrency23PrintSymbol
  END
  IF (@srcExtCurrency24ScreenSymbol <> @trgExtCurrency24ScreenSymbol) Or ((@srcExtCurrency24ScreenSymbol IS NULL) And (@trgExtCurrency24ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency24ScreenSymbol IS NOT NULL) And (@trgExtCurrency24ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency24ScreenSymbol = ' + @srcExtCurrency24ScreenSymbol + ' / ' + @trgExtCurrency24ScreenSymbol
  END
  IF (@srcExtCurrency24Desc <> @trgExtCurrency24Desc) Or ((@srcExtCurrency24Desc IS NULL) And (@trgExtCurrency24Desc IS NOT NULL)) Or ((@srcExtCurrency24Desc IS NOT NULL) And (@trgExtCurrency24Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency24Desc = ' + @srcExtCurrency24Desc + ' / ' + @trgExtCurrency24Desc
  END
  IF (@srcExtCurrency24CompanyRate <> @trgExtCurrency24CompanyRate) Or ((@srcExtCurrency24CompanyRate IS NULL) And (@trgExtCurrency24CompanyRate IS NOT NULL)) Or ((@srcExtCurrency24CompanyRate IS NOT NULL) And (@trgExtCurrency24CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency24CompanyRate = ' + @srcExtCurrency24CompanyRate + ' / ' + @trgExtCurrency24CompanyRate
  END
  IF (@srcExtCurrency24DailyRate <> @trgExtCurrency24DailyRate) Or ((@srcExtCurrency24DailyRate IS NULL) And (@trgExtCurrency24DailyRate IS NOT NULL)) Or ((@srcExtCurrency24DailyRate IS NOT NULL) And (@trgExtCurrency24DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency24DailyRate = ' + @srcExtCurrency24DailyRate + ' / ' + @trgExtCurrency24DailyRate
  END
  IF (@srcExtCurrency24PrintSymbol <> @trgExtCurrency24PrintSymbol) Or ((@srcExtCurrency24PrintSymbol IS NULL) And (@trgExtCurrency24PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency24PrintSymbol IS NOT NULL) And (@trgExtCurrency24PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency24PrintSymbol = ' + @srcExtCurrency24PrintSymbol + ' / ' + @trgExtCurrency24PrintSymbol
  END
  IF (@srcExtCurrency25ScreenSymbol <> @trgExtCurrency25ScreenSymbol) Or ((@srcExtCurrency25ScreenSymbol IS NULL) And (@trgExtCurrency25ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency25ScreenSymbol IS NOT NULL) And (@trgExtCurrency25ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency25ScreenSymbol = ' + @srcExtCurrency25ScreenSymbol + ' / ' + @trgExtCurrency25ScreenSymbol
  END
  IF (@srcExtCurrency25Desc <> @trgExtCurrency25Desc) Or ((@srcExtCurrency25Desc IS NULL) And (@trgExtCurrency25Desc IS NOT NULL)) Or ((@srcExtCurrency25Desc IS NOT NULL) And (@trgExtCurrency25Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency25Desc = ' + @srcExtCurrency25Desc + ' / ' + @trgExtCurrency25Desc
  END
  IF (@srcExtCurrency25CompanyRate <> @trgExtCurrency25CompanyRate) Or ((@srcExtCurrency25CompanyRate IS NULL) And (@trgExtCurrency25CompanyRate IS NOT NULL)) Or ((@srcExtCurrency25CompanyRate IS NOT NULL) And (@trgExtCurrency25CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency25CompanyRate = ' + @srcExtCurrency25CompanyRate + ' / ' + @trgExtCurrency25CompanyRate
  END
  IF (@srcExtCurrency25DailyRate <> @trgExtCurrency25DailyRate) Or ((@srcExtCurrency25DailyRate IS NULL) And (@trgExtCurrency25DailyRate IS NOT NULL)) Or ((@srcExtCurrency25DailyRate IS NOT NULL) And (@trgExtCurrency25DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency25DailyRate = ' + @srcExtCurrency25DailyRate + ' / ' + @trgExtCurrency25DailyRate
  END
  IF (@srcExtCurrency25PrintSymbol <> @trgExtCurrency25PrintSymbol) Or ((@srcExtCurrency25PrintSymbol IS NULL) And (@trgExtCurrency25PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency25PrintSymbol IS NOT NULL) And (@trgExtCurrency25PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency25PrintSymbol = ' + @srcExtCurrency25PrintSymbol + ' / ' + @trgExtCurrency25PrintSymbol
  END
  IF (@srcExtCurrency26ScreenSymbol <> @trgExtCurrency26ScreenSymbol) Or ((@srcExtCurrency26ScreenSymbol IS NULL) And (@trgExtCurrency26ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency26ScreenSymbol IS NOT NULL) And (@trgExtCurrency26ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency26ScreenSymbol = ' + @srcExtCurrency26ScreenSymbol + ' / ' + @trgExtCurrency26ScreenSymbol
  END
  IF (@srcExtCurrency26Desc <> @trgExtCurrency26Desc) Or ((@srcExtCurrency26Desc IS NULL) And (@trgExtCurrency26Desc IS NOT NULL)) Or ((@srcExtCurrency26Desc IS NOT NULL) And (@trgExtCurrency26Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency26Desc = ' + @srcExtCurrency26Desc + ' / ' + @trgExtCurrency26Desc
  END
  IF (@srcExtCurrency26CompanyRate <> @trgExtCurrency26CompanyRate) Or ((@srcExtCurrency26CompanyRate IS NULL) And (@trgExtCurrency26CompanyRate IS NOT NULL)) Or ((@srcExtCurrency26CompanyRate IS NOT NULL) And (@trgExtCurrency26CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency26CompanyRate = ' + @srcExtCurrency26CompanyRate + ' / ' + @trgExtCurrency26CompanyRate
  END
  IF (@srcExtCurrency26DailyRate <> @trgExtCurrency26DailyRate) Or ((@srcExtCurrency26DailyRate IS NULL) And (@trgExtCurrency26DailyRate IS NOT NULL)) Or ((@srcExtCurrency26DailyRate IS NOT NULL) And (@trgExtCurrency26DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency26DailyRate = ' + @srcExtCurrency26DailyRate + ' / ' + @trgExtCurrency26DailyRate
  END
  IF (@srcExtCurrency26PrintSymbol <> @trgExtCurrency26PrintSymbol) Or ((@srcExtCurrency26PrintSymbol IS NULL) And (@trgExtCurrency26PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency26PrintSymbol IS NOT NULL) And (@trgExtCurrency26PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency26PrintSymbol = ' + @srcExtCurrency26PrintSymbol + ' / ' + @trgExtCurrency26PrintSymbol
  END
  IF (@srcExtCurrency27ScreenSymbol <> @trgExtCurrency27ScreenSymbol) Or ((@srcExtCurrency27ScreenSymbol IS NULL) And (@trgExtCurrency27ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency27ScreenSymbol IS NOT NULL) And (@trgExtCurrency27ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency27ScreenSymbol = ' + @srcExtCurrency27ScreenSymbol + ' / ' + @trgExtCurrency27ScreenSymbol
  END
  IF (@srcExtCurrency27Desc <> @trgExtCurrency27Desc) Or ((@srcExtCurrency27Desc IS NULL) And (@trgExtCurrency27Desc IS NOT NULL)) Or ((@srcExtCurrency27Desc IS NOT NULL) And (@trgExtCurrency27Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency27Desc = ' + @srcExtCurrency27Desc + ' / ' + @trgExtCurrency27Desc
  END
  IF (@srcExtCurrency27CompanyRate <> @trgExtCurrency27CompanyRate) Or ((@srcExtCurrency27CompanyRate IS NULL) And (@trgExtCurrency27CompanyRate IS NOT NULL)) Or ((@srcExtCurrency27CompanyRate IS NOT NULL) And (@trgExtCurrency27CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency27CompanyRate = ' + @srcExtCurrency27CompanyRate + ' / ' + @trgExtCurrency27CompanyRate
  END
  IF (@srcExtCurrency27DailyRate <> @trgExtCurrency27DailyRate) Or ((@srcExtCurrency27DailyRate IS NULL) And (@trgExtCurrency27DailyRate IS NOT NULL)) Or ((@srcExtCurrency27DailyRate IS NOT NULL) And (@trgExtCurrency27DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency27DailyRate = ' + @srcExtCurrency27DailyRate + ' / ' + @trgExtCurrency27DailyRate
  END
  IF (@srcExtCurrency27PrintSymbol <> @trgExtCurrency27PrintSymbol) Or ((@srcExtCurrency27PrintSymbol IS NULL) And (@trgExtCurrency27PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency27PrintSymbol IS NOT NULL) And (@trgExtCurrency27PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency27PrintSymbol = ' + @srcExtCurrency27PrintSymbol + ' / ' + @trgExtCurrency27PrintSymbol
  END
  IF (@srcExtCurrency28ScreenSymbol <> @trgExtCurrency28ScreenSymbol) Or ((@srcExtCurrency28ScreenSymbol IS NULL) And (@trgExtCurrency28ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency28ScreenSymbol IS NOT NULL) And (@trgExtCurrency28ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency28ScreenSymbol = ' + @srcExtCurrency28ScreenSymbol + ' / ' + @trgExtCurrency28ScreenSymbol
  END
  IF (@srcExtCurrency28Desc <> @trgExtCurrency28Desc) Or ((@srcExtCurrency28Desc IS NULL) And (@trgExtCurrency28Desc IS NOT NULL)) Or ((@srcExtCurrency28Desc IS NOT NULL) And (@trgExtCurrency28Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency28Desc = ' + @srcExtCurrency28Desc + ' / ' + @trgExtCurrency28Desc
  END
  IF (@srcExtCurrency28CompanyRate <> @trgExtCurrency28CompanyRate) Or ((@srcExtCurrency28CompanyRate IS NULL) And (@trgExtCurrency28CompanyRate IS NOT NULL)) Or ((@srcExtCurrency28CompanyRate IS NOT NULL) And (@trgExtCurrency28CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency28CompanyRate = ' + @srcExtCurrency28CompanyRate + ' / ' + @trgExtCurrency28CompanyRate
  END
  IF (@srcExtCurrency28DailyRate <> @trgExtCurrency28DailyRate) Or ((@srcExtCurrency28DailyRate IS NULL) And (@trgExtCurrency28DailyRate IS NOT NULL)) Or ((@srcExtCurrency28DailyRate IS NOT NULL) And (@trgExtCurrency28DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency28DailyRate = ' + @srcExtCurrency28DailyRate + ' / ' + @trgExtCurrency28DailyRate
  END
  IF (@srcExtCurrency28PrintSymbol <> @trgExtCurrency28PrintSymbol) Or ((@srcExtCurrency28PrintSymbol IS NULL) And (@trgExtCurrency28PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency28PrintSymbol IS NOT NULL) And (@trgExtCurrency28PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency28PrintSymbol = ' + @srcExtCurrency28PrintSymbol + ' / ' + @trgExtCurrency28PrintSymbol
  END
  IF (@srcExtCurrency29ScreenSymbol <> @trgExtCurrency29ScreenSymbol) Or ((@srcExtCurrency29ScreenSymbol IS NULL) And (@trgExtCurrency29ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency29ScreenSymbol IS NOT NULL) And (@trgExtCurrency29ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency29ScreenSymbol = ' + @srcExtCurrency29ScreenSymbol + ' / ' + @trgExtCurrency29ScreenSymbol
  END
  IF (@srcExtCurrency29Desc <> @trgExtCurrency29Desc) Or ((@srcExtCurrency29Desc IS NULL) And (@trgExtCurrency29Desc IS NOT NULL)) Or ((@srcExtCurrency29Desc IS NOT NULL) And (@trgExtCurrency29Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency29Desc = ' + @srcExtCurrency29Desc + ' / ' + @trgExtCurrency29Desc
  END
  IF (@srcExtCurrency29CompanyRate <> @trgExtCurrency29CompanyRate) Or ((@srcExtCurrency29CompanyRate IS NULL) And (@trgExtCurrency29CompanyRate IS NOT NULL)) Or ((@srcExtCurrency29CompanyRate IS NOT NULL) And (@trgExtCurrency29CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency29CompanyRate = ' + @srcExtCurrency29CompanyRate + ' / ' + @trgExtCurrency29CompanyRate
  END
  IF (@srcExtCurrency29DailyRate <> @trgExtCurrency29DailyRate) Or ((@srcExtCurrency29DailyRate IS NULL) And (@trgExtCurrency29DailyRate IS NOT NULL)) Or ((@srcExtCurrency29DailyRate IS NOT NULL) And (@trgExtCurrency29DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency29DailyRate = ' + @srcExtCurrency29DailyRate + ' / ' + @trgExtCurrency29DailyRate
  END
  IF (@srcExtCurrency29PrintSymbol <> @trgExtCurrency29PrintSymbol) Or ((@srcExtCurrency29PrintSymbol IS NULL) And (@trgExtCurrency29PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency29PrintSymbol IS NOT NULL) And (@trgExtCurrency29PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency29PrintSymbol = ' + @srcExtCurrency29PrintSymbol + ' / ' + @trgExtCurrency29PrintSymbol
  END
  IF (@srcExtCurrency30ScreenSymbol <> @trgExtCurrency30ScreenSymbol) Or ((@srcExtCurrency30ScreenSymbol IS NULL) And (@trgExtCurrency30ScreenSymbol IS NOT NULL)) Or ((@srcExtCurrency30ScreenSymbol IS NOT NULL) And (@trgExtCurrency30ScreenSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency30ScreenSymbol = ' + @srcExtCurrency30ScreenSymbol + ' / ' + @trgExtCurrency30ScreenSymbol
  END
  IF (@srcExtCurrency30Desc <> @trgExtCurrency30Desc) Or ((@srcExtCurrency30Desc IS NULL) And (@trgExtCurrency30Desc IS NOT NULL)) Or ((@srcExtCurrency30Desc IS NOT NULL) And (@trgExtCurrency30Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency30Desc = ' + @srcExtCurrency30Desc + ' / ' + @trgExtCurrency30Desc
  END
  IF (@srcExtCurrency30CompanyRate <> @trgExtCurrency30CompanyRate) Or ((@srcExtCurrency30CompanyRate IS NULL) And (@trgExtCurrency30CompanyRate IS NOT NULL)) Or ((@srcExtCurrency30CompanyRate IS NOT NULL) And (@trgExtCurrency30CompanyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency30CompanyRate = ' + @srcExtCurrency30CompanyRate + ' / ' + @trgExtCurrency30CompanyRate
  END
  IF (@srcExtCurrency30DailyRate <> @trgExtCurrency30DailyRate) Or ((@srcExtCurrency30DailyRate IS NULL) And (@trgExtCurrency30DailyRate IS NOT NULL)) Or ((@srcExtCurrency30DailyRate IS NOT NULL) And (@trgExtCurrency30DailyRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency30DailyRate = ' + @srcExtCurrency30DailyRate + ' / ' + @trgExtCurrency30DailyRate
  END
  IF (@srcExtCurrency30PrintSymbol <> @trgExtCurrency30PrintSymbol) Or ((@srcExtCurrency30PrintSymbol IS NULL) And (@trgExtCurrency30PrintSymbol IS NOT NULL)) Or ((@srcExtCurrency30PrintSymbol IS NOT NULL) And (@trgExtCurrency30PrintSymbol IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ExtCurrency30PrintSymbol = ' + @srcExtCurrency30PrintSymbol + ' / ' + @trgExtCurrency30PrintSymbol
  END
  IF (@srcNames <> @trgNames) Or ((@srcNames IS NULL) And (@trgNames IS NOT NULL)) Or ((@srcNames IS NOT NULL) And (@trgNames IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.Names is different'
  END
  IF (@srcOverheadGL <> @trgOverheadGL) Or ((@srcOverheadGL IS NULL) And (@trgOverheadGL IS NOT NULL)) Or ((@srcOverheadGL IS NOT NULL) And (@trgOverheadGL IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.OverheadGL = ' + STR(@srcOverheadGL) + ' / ' + STR(@trgOverheadGL)
  END
  IF (@srcOverheadSpare <> @trgOverheadSpare) Or ((@srcOverheadSpare IS NULL) And (@trgOverheadSpare IS NOT NULL)) Or ((@srcOverheadSpare IS NOT NULL) And (@trgOverheadSpare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.OverheadSpare = ' + STR(@srcOverheadSpare) + ' / ' + STR(@trgOverheadSpare)
  END
  IF (@srcProductionGL <> @trgProductionGL) Or ((@srcProductionGL IS NULL) And (@trgProductionGL IS NOT NULL)) Or ((@srcProductionGL IS NOT NULL) And (@trgProductionGL IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ProductionGL = ' + STR(@srcProductionGL) + ' / ' + STR(@trgProductionGL)
  END
  IF (@srcProductionSpare <> @trgProductionSpare) Or ((@srcProductionSpare IS NULL) And (@trgProductionSpare IS NOT NULL)) Or ((@srcProductionSpare IS NOT NULL) And (@trgProductionSpare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ProductionSpare = ' + STR(@srcProductionSpare) + ' / ' + STR(@trgProductionSpare)
  END
  IF (@srcSubContractGL <> @trgSubContractGL) Or ((@srcSubContractGL IS NULL) And (@trgSubContractGL IS NOT NULL)) Or ((@srcSubContractGL IS NOT NULL) And (@trgSubContractGL IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SubContractGL = ' + STR(@srcSubContractGL) + ' / ' + STR(@trgSubContractGL)
  END
  IF (@srcSubContractSpare <> @trgSubContractSpare) Or ((@srcSubContractSpare IS NULL) And (@trgSubContractSpare IS NOT NULL)) Or ((@srcSubContractSpare IS NOT NULL) And (@trgSubContractSpare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SubContractSpare = ' + STR(@srcSubContractSpare) + ' / ' + STR(@trgSubContractSpare)
  END
  IF (@srcSpareGL1a <> @trgSpareGL1a) Or ((@srcSpareGL1a IS NULL) And (@trgSpareGL1a IS NOT NULL)) Or ((@srcSpareGL1a IS NOT NULL) And (@trgSpareGL1a IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SpareGL1a = ' + STR(@srcSpareGL1a) + ' / ' + STR(@trgSpareGL1a)
  END
  IF (@srcSpareGL1b <> @trgSpareGL1b) Or ((@srcSpareGL1b IS NULL) And (@trgSpareGL1b IS NOT NULL)) Or ((@srcSpareGL1b IS NOT NULL) And (@trgSpareGL1b IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SpareGL1b = ' + STR(@srcSpareGL1b) + ' / ' + STR(@trgSpareGL1b)
  END
  IF (@srcSpareGL2a <> @trgSpareGL2a) Or ((@srcSpareGL2a IS NULL) And (@trgSpareGL2a IS NOT NULL)) Or ((@srcSpareGL2a IS NOT NULL) And (@trgSpareGL2a IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SpareGL2a = ' + STR(@srcSpareGL2a) + ' / ' + STR(@trgSpareGL2a)
  END
  IF (@srcSpareGL2b <> @trgSpareGL2b) Or ((@srcSpareGL2b IS NULL) And (@trgSpareGL2b IS NOT NULL)) Or ((@srcSpareGL2b IS NOT NULL) And (@trgSpareGL2b IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SpareGL2b = ' + STR(@srcSpareGL2b) + ' / ' + STR(@trgSpareGL2b)
  END
  IF (@srcSpareGL3a <> @trgSpareGL3a) Or ((@srcSpareGL3a IS NULL) And (@trgSpareGL3a IS NOT NULL)) Or ((@srcSpareGL3a IS NOT NULL) And (@trgSpareGL3a IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SpareGL3a = ' + STR(@srcSpareGL3a) + ' / ' + STR(@trgSpareGL3a)
  END
  IF (@srcSpareGL3b <> @trgSpareGL3b) Or ((@srcSpareGL3b IS NULL) And (@trgSpareGL3b IS NOT NULL)) Or ((@srcSpareGL3b IS NOT NULL) And (@trgSpareGL3b IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SpareGL3b = ' + STR(@srcSpareGL3b) + ' / ' + STR(@trgSpareGL3b)
  END
  IF (@srcGenPPI <> @trgGenPPI) Or ((@srcGenPPI IS NULL) And (@trgGenPPI IS NOT NULL)) Or ((@srcGenPPI IS NOT NULL) And (@trgGenPPI IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.GenPPI = ' + STR(@srcGenPPI) + ' / ' + STR(@trgGenPPI)
  END
  IF (@srcPPIAcCode <> @trgPPIAcCode) Or ((@srcPPIAcCode IS NULL) And (@trgPPIAcCode IS NOT NULL)) Or ((@srcPPIAcCode IS NOT NULL) And (@trgPPIAcCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PPIAcCode = ' + @srcPPIAcCode + ' / ' + @trgPPIAcCode
  END
  IF (@srcSummDesc00 <> @trgSummDesc00) Or ((@srcSummDesc00 IS NULL) And (@trgSummDesc00 IS NOT NULL)) Or ((@srcSummDesc00 IS NOT NULL) And (@trgSummDesc00 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc00 = ' + @srcSummDesc00 + ' / ' + @trgSummDesc00
  END
  IF (@srcSummDesc01 <> @trgSummDesc01) Or ((@srcSummDesc01 IS NULL) And (@trgSummDesc01 IS NOT NULL)) Or ((@srcSummDesc01 IS NOT NULL) And (@trgSummDesc01 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc01 = ' + @srcSummDesc01 + ' / ' + @trgSummDesc01
  END
  IF (@srcSummDesc02 <> @trgSummDesc02) Or ((@srcSummDesc02 IS NULL) And (@trgSummDesc02 IS NOT NULL)) Or ((@srcSummDesc02 IS NOT NULL) And (@trgSummDesc02 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc02 = ' + @srcSummDesc02 + ' / ' + @trgSummDesc02
  END
  IF (@srcSummDesc03 <> @trgSummDesc03) Or ((@srcSummDesc03 IS NULL) And (@trgSummDesc03 IS NOT NULL)) Or ((@srcSummDesc03 IS NOT NULL) And (@trgSummDesc03 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc03 = ' + @srcSummDesc03 + ' / ' + @trgSummDesc03
  END
  IF (@srcSummDesc04 <> @trgSummDesc04) Or ((@srcSummDesc04 IS NULL) And (@trgSummDesc04 IS NOT NULL)) Or ((@srcSummDesc04 IS NOT NULL) And (@trgSummDesc04 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc04 = ' + @srcSummDesc04 + ' / ' + @trgSummDesc04
  END
  IF (@srcSummDesc05 <> @trgSummDesc05) Or ((@srcSummDesc05 IS NULL) And (@trgSummDesc05 IS NOT NULL)) Or ((@srcSummDesc05 IS NOT NULL) And (@trgSummDesc05 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc05 = ' + @srcSummDesc05 + ' / ' + @trgSummDesc05
  END
  IF (@srcSummDesc06 <> @trgSummDesc06) Or ((@srcSummDesc06 IS NULL) And (@trgSummDesc06 IS NOT NULL)) Or ((@srcSummDesc06 IS NOT NULL) And (@trgSummDesc06 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc06 = ' + @srcSummDesc06 + ' / ' + @trgSummDesc06
  END
  IF (@srcSummDesc07 <> @trgSummDesc07) Or ((@srcSummDesc07 IS NULL) And (@trgSummDesc07 IS NOT NULL)) Or ((@srcSummDesc07 IS NOT NULL) And (@trgSummDesc07 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc07 = ' + @srcSummDesc07 + ' / ' + @trgSummDesc07
  END
  IF (@srcSummDesc08 <> @trgSummDesc08) Or ((@srcSummDesc08 IS NULL) And (@trgSummDesc08 IS NOT NULL)) Or ((@srcSummDesc08 IS NOT NULL) And (@trgSummDesc08 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc08 = ' + @srcSummDesc08 + ' / ' + @trgSummDesc08
  END
  IF (@srcSummDesc09 <> @trgSummDesc09) Or ((@srcSummDesc09 IS NULL) And (@trgSummDesc09 IS NOT NULL)) Or ((@srcSummDesc09 IS NOT NULL) And (@trgSummDesc09 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc09 = ' + @srcSummDesc09 + ' / ' + @trgSummDesc09
  END
  IF (@srcSummDesc10 <> @trgSummDesc10) Or ((@srcSummDesc10 IS NULL) And (@trgSummDesc10 IS NOT NULL)) Or ((@srcSummDesc10 IS NOT NULL) And (@trgSummDesc10 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc10 = ' + @srcSummDesc10 + ' / ' + @trgSummDesc10
  END
  IF (@srcSummDesc11 <> @trgSummDesc11) Or ((@srcSummDesc11 IS NULL) And (@trgSummDesc11 IS NOT NULL)) Or ((@srcSummDesc11 IS NOT NULL) And (@trgSummDesc11 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc11 = ' + @srcSummDesc11 + ' / ' + @trgSummDesc11
  END
  IF (@srcSummDesc12 <> @trgSummDesc12) Or ((@srcSummDesc12 IS NULL) And (@trgSummDesc12 IS NOT NULL)) Or ((@srcSummDesc12 IS NOT NULL) And (@trgSummDesc12 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc12 = ' + @srcSummDesc12 + ' / ' + @trgSummDesc12
  END
  IF (@srcSummDesc13 <> @trgSummDesc13) Or ((@srcSummDesc13 IS NULL) And (@trgSummDesc13 IS NOT NULL)) Or ((@srcSummDesc13 IS NOT NULL) And (@trgSummDesc13 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc13 = ' + @srcSummDesc13 + ' / ' + @trgSummDesc13
  END
  IF (@srcSummDesc14 <> @trgSummDesc14) Or ((@srcSummDesc14 IS NULL) And (@trgSummDesc14 IS NOT NULL)) Or ((@srcSummDesc14 IS NOT NULL) And (@trgSummDesc14 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc14 = ' + @srcSummDesc14 + ' / ' + @trgSummDesc14
  END
  IF (@srcSummDesc15 <> @trgSummDesc15) Or ((@srcSummDesc15 IS NULL) And (@trgSummDesc15 IS NOT NULL)) Or ((@srcSummDesc15 IS NOT NULL) And (@trgSummDesc15 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc15 = ' + @srcSummDesc15 + ' / ' + @trgSummDesc15
  END
  IF (@srcSummDesc16 <> @trgSummDesc16) Or ((@srcSummDesc16 IS NULL) And (@trgSummDesc16 IS NOT NULL)) Or ((@srcSummDesc16 IS NOT NULL) And (@trgSummDesc16 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc16 = ' + @srcSummDesc16 + ' / ' + @trgSummDesc16
  END
  IF (@srcSummDesc17 <> @trgSummDesc17) Or ((@srcSummDesc17 IS NULL) And (@trgSummDesc17 IS NOT NULL)) Or ((@srcSummDesc17 IS NOT NULL) And (@trgSummDesc17 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc17 = ' + @srcSummDesc17 + ' / ' + @trgSummDesc17
  END
  IF (@srcSummDesc18 <> @trgSummDesc18) Or ((@srcSummDesc18 IS NULL) And (@trgSummDesc18 IS NOT NULL)) Or ((@srcSummDesc18 IS NOT NULL) And (@trgSummDesc18 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc18 = ' + @srcSummDesc18 + ' / ' + @trgSummDesc18
  END
  IF (@srcSummDesc19 <> @trgSummDesc19) Or ((@srcSummDesc19 IS NULL) And (@trgSummDesc19 IS NOT NULL)) Or ((@srcSummDesc19 IS NOT NULL) And (@trgSummDesc19 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc19 = ' + @srcSummDesc19 + ' / ' + @trgSummDesc19
  END
  IF (@srcSummDesc20 <> @trgSummDesc20) Or ((@srcSummDesc20 IS NULL) And (@trgSummDesc20 IS NOT NULL)) Or ((@srcSummDesc20 IS NOT NULL) And (@trgSummDesc20 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.SummDesc20 = ' + @srcSummDesc20 + ' / ' + @trgSummDesc20
  END
  IF (@srcPeriodBud <> @trgPeriodBud) Or ((@srcPeriodBud IS NULL) And (@trgPeriodBud IS NOT NULL)) Or ((@srcPeriodBud IS NOT NULL) And (@trgPeriodBud IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PeriodBud = ' + STR(@srcPeriodBud) + ' / ' + STR(@trgPeriodBud)
  END
  IF (@srcJCChkACode1 <> @trgJCChkACode1) Or ((@srcJCChkACode1 IS NULL) And (@trgJCChkACode1 IS NOT NULL)) Or ((@srcJCChkACode1 IS NOT NULL) And (@trgJCChkACode1 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.JCChkACode1 = ' + @srcJCChkACode1 + ' / ' + @trgJCChkACode1
  END
  IF (@srcJCChkACode2 <> @trgJCChkACode2) Or ((@srcJCChkACode2 IS NULL) And (@trgJCChkACode2 IS NOT NULL)) Or ((@srcJCChkACode2 IS NOT NULL) And (@trgJCChkACode2 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.JCChkACode2 = ' + @srcJCChkACode2 + ' / ' + @trgJCChkACode2
  END
  IF (@srcJCChkACode3 <> @trgJCChkACode3) Or ((@srcJCChkACode3 IS NULL) And (@trgJCChkACode3 IS NOT NULL)) Or ((@srcJCChkACode3 IS NOT NULL) And (@trgJCChkACode3 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.JCChkACode3 = ' + @srcJCChkACode3 + ' / ' + @trgJCChkACode3
  END
  IF (@srcJCChkACode4 <> @trgJCChkACode4) Or ((@srcJCChkACode4 IS NULL) And (@trgJCChkACode4 IS NOT NULL)) Or ((@srcJCChkACode4 IS NOT NULL) And (@trgJCChkACode4 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.JCChkACode4 = ' + @srcJCChkACode4 + ' / ' + @trgJCChkACode4
  END
  IF (@srcJCChkACode5 <> @trgJCChkACode5) Or ((@srcJCChkACode5 IS NULL) And (@trgJCChkACode5 IS NOT NULL)) Or ((@srcJCChkACode5 IS NOT NULL) And (@trgJCChkACode5 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.JCChkACode5 = ' + @srcJCChkACode5 + ' / ' + @trgJCChkACode5
  END
  IF (@srcJWKMthNo <> @trgJWKMthNo) Or ((@srcJWKMthNo IS NULL) And (@trgJWKMthNo IS NOT NULL)) Or ((@srcJWKMthNo IS NOT NULL) And (@trgJWKMthNo IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.JWKMthNo = ' + STR(@srcJWKMthNo) + ' / ' + STR(@trgJWKMthNo)
  END
  IF (@srcJTSHNoF <> @trgJTSHNoF) Or ((@srcJTSHNoF IS NULL) And (@trgJTSHNoF IS NOT NULL)) Or ((@srcJTSHNoF IS NOT NULL) And (@trgJTSHNoF IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.JTSHNoF = ' + @srcJTSHNoF + ' / ' + @trgJTSHNoF
  END
  IF (@srcJTSHNoT <> @trgJTSHNoT) Or ((@srcJTSHNoT IS NULL) And (@trgJTSHNoT IS NOT NULL)) Or ((@srcJTSHNoT IS NOT NULL) And (@trgJTSHNoT IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.JTSHNoT = ' + @srcJTSHNoT + ' / ' + @trgJTSHNoT
  END
  IF (@srcJFName <> @trgJFName) Or ((@srcJFName IS NULL) And (@trgJFName IS NOT NULL)) Or ((@srcJFName IS NOT NULL) And (@trgJFName IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.JFName = ' + @srcJFName + ' / ' + @trgJFName
  END
  IF (@srcJCCommitPin <> @trgJCCommitPin) Or ((@srcJCCommitPin IS NULL) And (@trgJCCommitPin IS NOT NULL)) Or ((@srcJCCommitPin IS NOT NULL) And (@trgJCCommitPin IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.JCCommitPin = ' + STR(@srcJCCommitPin) + ' / ' + STR(@trgJCCommitPin)
  END
  IF (@srcJAInvDate <> @trgJAInvDate) Or ((@srcJAInvDate IS NULL) And (@trgJAInvDate IS NOT NULL)) Or ((@srcJAInvDate IS NOT NULL) And (@trgJAInvDate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.JAInvDate = ' + STR(@srcJAInvDate) + ' / ' + STR(@trgJAInvDate)
  END
  IF (@srcJADelayCert <> @trgJADelayCert) Or ((@srcJADelayCert IS NULL) And (@trgJADelayCert IS NOT NULL)) Or ((@srcJADelayCert IS NOT NULL) And (@trgJADelayCert IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.JADelayCert = ' + STR(@srcJADelayCert) + ' / ' + STR(@trgJADelayCert)
  END
  IF (@srcPrimaryForm001 <> @trgPrimaryForm001) Or ((@srcPrimaryForm001 IS NULL) And (@trgPrimaryForm001 IS NOT NULL)) Or ((@srcPrimaryForm001 IS NOT NULL) And (@trgPrimaryForm001 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm001 = ' + @srcPrimaryForm001 + ' / ' + @trgPrimaryForm001
  END
  IF (@srcPrimaryForm002 <> @trgPrimaryForm002) Or ((@srcPrimaryForm002 IS NULL) And (@trgPrimaryForm002 IS NOT NULL)) Or ((@srcPrimaryForm002 IS NOT NULL) And (@trgPrimaryForm002 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm002 = ' + @srcPrimaryForm002 + ' / ' + @trgPrimaryForm002
  END
  IF (@srcPrimaryForm003 <> @trgPrimaryForm003) Or ((@srcPrimaryForm003 IS NULL) And (@trgPrimaryForm003 IS NOT NULL)) Or ((@srcPrimaryForm003 IS NOT NULL) And (@trgPrimaryForm003 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm003 = ' + @srcPrimaryForm003 + ' / ' + @trgPrimaryForm003
  END
  IF (@srcPrimaryForm004 <> @trgPrimaryForm004) Or ((@srcPrimaryForm004 IS NULL) And (@trgPrimaryForm004 IS NOT NULL)) Or ((@srcPrimaryForm004 IS NOT NULL) And (@trgPrimaryForm004 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm004 = ' + @srcPrimaryForm004 + ' / ' + @trgPrimaryForm004
  END
  IF (@srcPrimaryForm005 <> @trgPrimaryForm005) Or ((@srcPrimaryForm005 IS NULL) And (@trgPrimaryForm005 IS NOT NULL)) Or ((@srcPrimaryForm005 IS NOT NULL) And (@trgPrimaryForm005 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm005 = ' + @srcPrimaryForm005 + ' / ' + @trgPrimaryForm005
  END
  IF (@srcPrimaryForm006 <> @trgPrimaryForm006) Or ((@srcPrimaryForm006 IS NULL) And (@trgPrimaryForm006 IS NOT NULL)) Or ((@srcPrimaryForm006 IS NOT NULL) And (@trgPrimaryForm006 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm006 = ' + @srcPrimaryForm006 + ' / ' + @trgPrimaryForm006
  END
  IF (@srcPrimaryForm007 <> @trgPrimaryForm007) Or ((@srcPrimaryForm007 IS NULL) And (@trgPrimaryForm007 IS NOT NULL)) Or ((@srcPrimaryForm007 IS NOT NULL) And (@trgPrimaryForm007 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm007 = ' + @srcPrimaryForm007 + ' / ' + @trgPrimaryForm007
  END
  IF (@srcPrimaryForm008 <> @trgPrimaryForm008) Or ((@srcPrimaryForm008 IS NULL) And (@trgPrimaryForm008 IS NOT NULL)) Or ((@srcPrimaryForm008 IS NOT NULL) And (@trgPrimaryForm008 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm008 = ' + @srcPrimaryForm008 + ' / ' + @trgPrimaryForm008
  END
  IF (@srcPrimaryForm009 <> @trgPrimaryForm009) Or ((@srcPrimaryForm009 IS NULL) And (@trgPrimaryForm009 IS NOT NULL)) Or ((@srcPrimaryForm009 IS NOT NULL) And (@trgPrimaryForm009 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm009 = ' + @srcPrimaryForm009 + ' / ' + @trgPrimaryForm009
  END
  IF (@srcPrimaryForm010 <> @trgPrimaryForm010) Or ((@srcPrimaryForm010 IS NULL) And (@trgPrimaryForm010 IS NOT NULL)) Or ((@srcPrimaryForm010 IS NOT NULL) And (@trgPrimaryForm010 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm010 = ' + @srcPrimaryForm010 + ' / ' + @trgPrimaryForm010
  END
  IF (@srcPrimaryForm011 <> @trgPrimaryForm011) Or ((@srcPrimaryForm011 IS NULL) And (@trgPrimaryForm011 IS NOT NULL)) Or ((@srcPrimaryForm011 IS NOT NULL) And (@trgPrimaryForm011 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm011 = ' + @srcPrimaryForm011 + ' / ' + @trgPrimaryForm011
  END
  IF (@srcPrimaryForm012 <> @trgPrimaryForm012) Or ((@srcPrimaryForm012 IS NULL) And (@trgPrimaryForm012 IS NOT NULL)) Or ((@srcPrimaryForm012 IS NOT NULL) And (@trgPrimaryForm012 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm012 = ' + @srcPrimaryForm012 + ' / ' + @trgPrimaryForm012
  END
  IF (@srcPrimaryForm013 <> @trgPrimaryForm013) Or ((@srcPrimaryForm013 IS NULL) And (@trgPrimaryForm013 IS NOT NULL)) Or ((@srcPrimaryForm013 IS NOT NULL) And (@trgPrimaryForm013 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm013 = ' + @srcPrimaryForm013 + ' / ' + @trgPrimaryForm013
  END
  IF (@srcPrimaryForm014 <> @trgPrimaryForm014) Or ((@srcPrimaryForm014 IS NULL) And (@trgPrimaryForm014 IS NOT NULL)) Or ((@srcPrimaryForm014 IS NOT NULL) And (@trgPrimaryForm014 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm014 = ' + @srcPrimaryForm014 + ' / ' + @trgPrimaryForm014
  END
  IF (@srcPrimaryForm015 <> @trgPrimaryForm015) Or ((@srcPrimaryForm015 IS NULL) And (@trgPrimaryForm015 IS NOT NULL)) Or ((@srcPrimaryForm015 IS NOT NULL) And (@trgPrimaryForm015 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm015 = ' + @srcPrimaryForm015 + ' / ' + @trgPrimaryForm015
  END
  IF (@srcPrimaryForm016 <> @trgPrimaryForm016) Or ((@srcPrimaryForm016 IS NULL) And (@trgPrimaryForm016 IS NOT NULL)) Or ((@srcPrimaryForm016 IS NOT NULL) And (@trgPrimaryForm016 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm016 = ' + @srcPrimaryForm016 + ' / ' + @trgPrimaryForm016
  END
  IF (@srcPrimaryForm017 <> @trgPrimaryForm017) Or ((@srcPrimaryForm017 IS NULL) And (@trgPrimaryForm017 IS NOT NULL)) Or ((@srcPrimaryForm017 IS NOT NULL) And (@trgPrimaryForm017 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm017 = ' + @srcPrimaryForm017 + ' / ' + @trgPrimaryForm017
  END
  IF (@srcPrimaryForm018 <> @trgPrimaryForm018) Or ((@srcPrimaryForm018 IS NULL) And (@trgPrimaryForm018 IS NOT NULL)) Or ((@srcPrimaryForm018 IS NOT NULL) And (@trgPrimaryForm018 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm018 = ' + @srcPrimaryForm018 + ' / ' + @trgPrimaryForm018
  END
  IF (@srcPrimaryForm019 <> @trgPrimaryForm019) Or ((@srcPrimaryForm019 IS NULL) And (@trgPrimaryForm019 IS NOT NULL)) Or ((@srcPrimaryForm019 IS NOT NULL) And (@trgPrimaryForm019 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm019 = ' + @srcPrimaryForm019 + ' / ' + @trgPrimaryForm019
  END
  IF (@srcPrimaryForm020 <> @trgPrimaryForm020) Or ((@srcPrimaryForm020 IS NULL) And (@trgPrimaryForm020 IS NOT NULL)) Or ((@srcPrimaryForm020 IS NOT NULL) And (@trgPrimaryForm020 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm020 = ' + @srcPrimaryForm020 + ' / ' + @trgPrimaryForm020
  END
  IF (@srcPrimaryForm021 <> @trgPrimaryForm021) Or ((@srcPrimaryForm021 IS NULL) And (@trgPrimaryForm021 IS NOT NULL)) Or ((@srcPrimaryForm021 IS NOT NULL) And (@trgPrimaryForm021 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm021 = ' + @srcPrimaryForm021 + ' / ' + @trgPrimaryForm021
  END
  IF (@srcPrimaryForm022 <> @trgPrimaryForm022) Or ((@srcPrimaryForm022 IS NULL) And (@trgPrimaryForm022 IS NOT NULL)) Or ((@srcPrimaryForm022 IS NOT NULL) And (@trgPrimaryForm022 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm022 = ' + @srcPrimaryForm022 + ' / ' + @trgPrimaryForm022
  END
  IF (@srcPrimaryForm023 <> @trgPrimaryForm023) Or ((@srcPrimaryForm023 IS NULL) And (@trgPrimaryForm023 IS NOT NULL)) Or ((@srcPrimaryForm023 IS NOT NULL) And (@trgPrimaryForm023 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm023 = ' + @srcPrimaryForm023 + ' / ' + @trgPrimaryForm023
  END
  IF (@srcPrimaryForm024 <> @trgPrimaryForm024) Or ((@srcPrimaryForm024 IS NULL) And (@trgPrimaryForm024 IS NOT NULL)) Or ((@srcPrimaryForm024 IS NOT NULL) And (@trgPrimaryForm024 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm024 = ' + @srcPrimaryForm024 + ' / ' + @trgPrimaryForm024
  END
  IF (@srcPrimaryForm025 <> @trgPrimaryForm025) Or ((@srcPrimaryForm025 IS NULL) And (@trgPrimaryForm025 IS NOT NULL)) Or ((@srcPrimaryForm025 IS NOT NULL) And (@trgPrimaryForm025 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm025 = ' + @srcPrimaryForm025 + ' / ' + @trgPrimaryForm025
  END
  IF (@srcPrimaryForm026 <> @trgPrimaryForm026) Or ((@srcPrimaryForm026 IS NULL) And (@trgPrimaryForm026 IS NOT NULL)) Or ((@srcPrimaryForm026 IS NOT NULL) And (@trgPrimaryForm026 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm026 = ' + @srcPrimaryForm026 + ' / ' + @trgPrimaryForm026
  END
  IF (@srcPrimaryForm027 <> @trgPrimaryForm027) Or ((@srcPrimaryForm027 IS NULL) And (@trgPrimaryForm027 IS NOT NULL)) Or ((@srcPrimaryForm027 IS NOT NULL) And (@trgPrimaryForm027 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm027 = ' + @srcPrimaryForm027 + ' / ' + @trgPrimaryForm027
  END
  IF (@srcPrimaryForm028 <> @trgPrimaryForm028) Or ((@srcPrimaryForm028 IS NULL) And (@trgPrimaryForm028 IS NOT NULL)) Or ((@srcPrimaryForm028 IS NOT NULL) And (@trgPrimaryForm028 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm028 = ' + @srcPrimaryForm028 + ' / ' + @trgPrimaryForm028
  END
  IF (@srcPrimaryForm029 <> @trgPrimaryForm029) Or ((@srcPrimaryForm029 IS NULL) And (@trgPrimaryForm029 IS NOT NULL)) Or ((@srcPrimaryForm029 IS NOT NULL) And (@trgPrimaryForm029 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm029 = ' + @srcPrimaryForm029 + ' / ' + @trgPrimaryForm029
  END
  IF (@srcPrimaryForm030 <> @trgPrimaryForm030) Or ((@srcPrimaryForm030 IS NULL) And (@trgPrimaryForm030 IS NOT NULL)) Or ((@srcPrimaryForm030 IS NOT NULL) And (@trgPrimaryForm030 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm030 = ' + @srcPrimaryForm030 + ' / ' + @trgPrimaryForm030
  END
  IF (@srcPrimaryForm031 <> @trgPrimaryForm031) Or ((@srcPrimaryForm031 IS NULL) And (@trgPrimaryForm031 IS NOT NULL)) Or ((@srcPrimaryForm031 IS NOT NULL) And (@trgPrimaryForm031 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm031 = ' + @srcPrimaryForm031 + ' / ' + @trgPrimaryForm031
  END
  IF (@srcPrimaryForm032 <> @trgPrimaryForm032) Or ((@srcPrimaryForm032 IS NULL) And (@trgPrimaryForm032 IS NOT NULL)) Or ((@srcPrimaryForm032 IS NOT NULL) And (@trgPrimaryForm032 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm032 = ' + @srcPrimaryForm032 + ' / ' + @trgPrimaryForm032
  END
  IF (@srcPrimaryForm033 <> @trgPrimaryForm033) Or ((@srcPrimaryForm033 IS NULL) And (@trgPrimaryForm033 IS NOT NULL)) Or ((@srcPrimaryForm033 IS NOT NULL) And (@trgPrimaryForm033 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm033 = ' + @srcPrimaryForm033 + ' / ' + @trgPrimaryForm033
  END
  IF (@srcPrimaryForm034 <> @trgPrimaryForm034) Or ((@srcPrimaryForm034 IS NULL) And (@trgPrimaryForm034 IS NOT NULL)) Or ((@srcPrimaryForm034 IS NOT NULL) And (@trgPrimaryForm034 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm034 = ' + @srcPrimaryForm034 + ' / ' + @trgPrimaryForm034
  END
  IF (@srcPrimaryForm035 <> @trgPrimaryForm035) Or ((@srcPrimaryForm035 IS NULL) And (@trgPrimaryForm035 IS NOT NULL)) Or ((@srcPrimaryForm035 IS NOT NULL) And (@trgPrimaryForm035 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm035 = ' + @srcPrimaryForm035 + ' / ' + @trgPrimaryForm035
  END
  IF (@srcPrimaryForm036 <> @trgPrimaryForm036) Or ((@srcPrimaryForm036 IS NULL) And (@trgPrimaryForm036 IS NOT NULL)) Or ((@srcPrimaryForm036 IS NOT NULL) And (@trgPrimaryForm036 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm036 = ' + @srcPrimaryForm036 + ' / ' + @trgPrimaryForm036
  END
  IF (@srcPrimaryForm037 <> @trgPrimaryForm037) Or ((@srcPrimaryForm037 IS NULL) And (@trgPrimaryForm037 IS NOT NULL)) Or ((@srcPrimaryForm037 IS NOT NULL) And (@trgPrimaryForm037 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm037 = ' + @srcPrimaryForm037 + ' / ' + @trgPrimaryForm037
  END
  IF (@srcPrimaryForm038 <> @trgPrimaryForm038) Or ((@srcPrimaryForm038 IS NULL) And (@trgPrimaryForm038 IS NOT NULL)) Or ((@srcPrimaryForm038 IS NOT NULL) And (@trgPrimaryForm038 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm038 = ' + @srcPrimaryForm038 + ' / ' + @trgPrimaryForm038
  END
  IF (@srcPrimaryForm039 <> @trgPrimaryForm039) Or ((@srcPrimaryForm039 IS NULL) And (@trgPrimaryForm039 IS NOT NULL)) Or ((@srcPrimaryForm039 IS NOT NULL) And (@trgPrimaryForm039 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm039 = ' + @srcPrimaryForm039 + ' / ' + @trgPrimaryForm039
  END
  IF (@srcPrimaryForm040 <> @trgPrimaryForm040) Or ((@srcPrimaryForm040 IS NULL) And (@trgPrimaryForm040 IS NOT NULL)) Or ((@srcPrimaryForm040 IS NOT NULL) And (@trgPrimaryForm040 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm040 = ' + @srcPrimaryForm040 + ' / ' + @trgPrimaryForm040
  END
  IF (@srcPrimaryForm041 <> @trgPrimaryForm041) Or ((@srcPrimaryForm041 IS NULL) And (@trgPrimaryForm041 IS NOT NULL)) Or ((@srcPrimaryForm041 IS NOT NULL) And (@trgPrimaryForm041 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm041 = ' + @srcPrimaryForm041 + ' / ' + @trgPrimaryForm041
  END
  IF (@srcPrimaryForm042 <> @trgPrimaryForm042) Or ((@srcPrimaryForm042 IS NULL) And (@trgPrimaryForm042 IS NOT NULL)) Or ((@srcPrimaryForm042 IS NOT NULL) And (@trgPrimaryForm042 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm042 = ' + @srcPrimaryForm042 + ' / ' + @trgPrimaryForm042
  END
  IF (@srcPrimaryForm043 <> @trgPrimaryForm043) Or ((@srcPrimaryForm043 IS NULL) And (@trgPrimaryForm043 IS NOT NULL)) Or ((@srcPrimaryForm043 IS NOT NULL) And (@trgPrimaryForm043 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm043 = ' + @srcPrimaryForm043 + ' / ' + @trgPrimaryForm043
  END
  IF (@srcPrimaryForm044 <> @trgPrimaryForm044) Or ((@srcPrimaryForm044 IS NULL) And (@trgPrimaryForm044 IS NOT NULL)) Or ((@srcPrimaryForm044 IS NOT NULL) And (@trgPrimaryForm044 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm044 = ' + @srcPrimaryForm044 + ' / ' + @trgPrimaryForm044
  END
  IF (@srcPrimaryForm045 <> @trgPrimaryForm045) Or ((@srcPrimaryForm045 IS NULL) And (@trgPrimaryForm045 IS NOT NULL)) Or ((@srcPrimaryForm045 IS NOT NULL) And (@trgPrimaryForm045 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm045 = ' + @srcPrimaryForm045 + ' / ' + @trgPrimaryForm045
  END
  IF (@srcPrimaryForm046 <> @trgPrimaryForm046) Or ((@srcPrimaryForm046 IS NULL) And (@trgPrimaryForm046 IS NOT NULL)) Or ((@srcPrimaryForm046 IS NOT NULL) And (@trgPrimaryForm046 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm046 = ' + @srcPrimaryForm046 + ' / ' + @trgPrimaryForm046
  END
  IF (@srcPrimaryForm047 <> @trgPrimaryForm047) Or ((@srcPrimaryForm047 IS NULL) And (@trgPrimaryForm047 IS NOT NULL)) Or ((@srcPrimaryForm047 IS NOT NULL) And (@trgPrimaryForm047 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm047 = ' + @srcPrimaryForm047 + ' / ' + @trgPrimaryForm047
  END
  IF (@srcPrimaryForm048 <> @trgPrimaryForm048) Or ((@srcPrimaryForm048 IS NULL) And (@trgPrimaryForm048 IS NOT NULL)) Or ((@srcPrimaryForm048 IS NOT NULL) And (@trgPrimaryForm048 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm048 = ' + @srcPrimaryForm048 + ' / ' + @trgPrimaryForm048
  END
  IF (@srcPrimaryForm049 <> @trgPrimaryForm049) Or ((@srcPrimaryForm049 IS NULL) And (@trgPrimaryForm049 IS NOT NULL)) Or ((@srcPrimaryForm049 IS NOT NULL) And (@trgPrimaryForm049 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm049 = ' + @srcPrimaryForm049 + ' / ' + @trgPrimaryForm049
  END
  IF (@srcPrimaryForm050 <> @trgPrimaryForm050) Or ((@srcPrimaryForm050 IS NULL) And (@trgPrimaryForm050 IS NOT NULL)) Or ((@srcPrimaryForm050 IS NOT NULL) And (@trgPrimaryForm050 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm050 = ' + @srcPrimaryForm050 + ' / ' + @trgPrimaryForm050
  END
  IF (@srcPrimaryForm051 <> @trgPrimaryForm051) Or ((@srcPrimaryForm051 IS NULL) And (@trgPrimaryForm051 IS NOT NULL)) Or ((@srcPrimaryForm051 IS NOT NULL) And (@trgPrimaryForm051 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm051 = ' + @srcPrimaryForm051 + ' / ' + @trgPrimaryForm051
  END
  IF (@srcPrimaryForm052 <> @trgPrimaryForm052) Or ((@srcPrimaryForm052 IS NULL) And (@trgPrimaryForm052 IS NOT NULL)) Or ((@srcPrimaryForm052 IS NOT NULL) And (@trgPrimaryForm052 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm052 = ' + @srcPrimaryForm052 + ' / ' + @trgPrimaryForm052
  END
  IF (@srcPrimaryForm053 <> @trgPrimaryForm053) Or ((@srcPrimaryForm053 IS NULL) And (@trgPrimaryForm053 IS NOT NULL)) Or ((@srcPrimaryForm053 IS NOT NULL) And (@trgPrimaryForm053 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm053 = ' + @srcPrimaryForm053 + ' / ' + @trgPrimaryForm053
  END
  IF (@srcPrimaryForm054 <> @trgPrimaryForm054) Or ((@srcPrimaryForm054 IS NULL) And (@trgPrimaryForm054 IS NOT NULL)) Or ((@srcPrimaryForm054 IS NOT NULL) And (@trgPrimaryForm054 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm054 = ' + @srcPrimaryForm054 + ' / ' + @trgPrimaryForm054
  END
  IF (@srcPrimaryForm055 <> @trgPrimaryForm055) Or ((@srcPrimaryForm055 IS NULL) And (@trgPrimaryForm055 IS NOT NULL)) Or ((@srcPrimaryForm055 IS NOT NULL) And (@trgPrimaryForm055 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm055 = ' + @srcPrimaryForm055 + ' / ' + @trgPrimaryForm055
  END
  IF (@srcPrimaryForm056 <> @trgPrimaryForm056) Or ((@srcPrimaryForm056 IS NULL) And (@trgPrimaryForm056 IS NOT NULL)) Or ((@srcPrimaryForm056 IS NOT NULL) And (@trgPrimaryForm056 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm056 = ' + @srcPrimaryForm056 + ' / ' + @trgPrimaryForm056
  END
  IF (@srcPrimaryForm057 <> @trgPrimaryForm057) Or ((@srcPrimaryForm057 IS NULL) And (@trgPrimaryForm057 IS NOT NULL)) Or ((@srcPrimaryForm057 IS NOT NULL) And (@trgPrimaryForm057 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm057 = ' + @srcPrimaryForm057 + ' / ' + @trgPrimaryForm057
  END
  IF (@srcPrimaryForm058 <> @trgPrimaryForm058) Or ((@srcPrimaryForm058 IS NULL) And (@trgPrimaryForm058 IS NOT NULL)) Or ((@srcPrimaryForm058 IS NOT NULL) And (@trgPrimaryForm058 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm058 = ' + @srcPrimaryForm058 + ' / ' + @trgPrimaryForm058
  END
  IF (@srcPrimaryForm059 <> @trgPrimaryForm059) Or ((@srcPrimaryForm059 IS NULL) And (@trgPrimaryForm059 IS NOT NULL)) Or ((@srcPrimaryForm059 IS NOT NULL) And (@trgPrimaryForm059 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm059 = ' + @srcPrimaryForm059 + ' / ' + @trgPrimaryForm059
  END
  IF (@srcPrimaryForm060 <> @trgPrimaryForm060) Or ((@srcPrimaryForm060 IS NULL) And (@trgPrimaryForm060 IS NOT NULL)) Or ((@srcPrimaryForm060 IS NOT NULL) And (@trgPrimaryForm060 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm060 = ' + @srcPrimaryForm060 + ' / ' + @trgPrimaryForm060
  END
  IF (@srcPrimaryForm061 <> @trgPrimaryForm061) Or ((@srcPrimaryForm061 IS NULL) And (@trgPrimaryForm061 IS NOT NULL)) Or ((@srcPrimaryForm061 IS NOT NULL) And (@trgPrimaryForm061 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm061 = ' + @srcPrimaryForm061 + ' / ' + @trgPrimaryForm061
  END
  IF (@srcPrimaryForm062 <> @trgPrimaryForm062) Or ((@srcPrimaryForm062 IS NULL) And (@trgPrimaryForm062 IS NOT NULL)) Or ((@srcPrimaryForm062 IS NOT NULL) And (@trgPrimaryForm062 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm062 = ' + @srcPrimaryForm062 + ' / ' + @trgPrimaryForm062
  END
  IF (@srcPrimaryForm063 <> @trgPrimaryForm063) Or ((@srcPrimaryForm063 IS NULL) And (@trgPrimaryForm063 IS NOT NULL)) Or ((@srcPrimaryForm063 IS NOT NULL) And (@trgPrimaryForm063 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm063 = ' + @srcPrimaryForm063 + ' / ' + @trgPrimaryForm063
  END
  IF (@srcPrimaryForm064 <> @trgPrimaryForm064) Or ((@srcPrimaryForm064 IS NULL) And (@trgPrimaryForm064 IS NOT NULL)) Or ((@srcPrimaryForm064 IS NOT NULL) And (@trgPrimaryForm064 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm064 = ' + @srcPrimaryForm064 + ' / ' + @trgPrimaryForm064
  END
  IF (@srcPrimaryForm065 <> @trgPrimaryForm065) Or ((@srcPrimaryForm065 IS NULL) And (@trgPrimaryForm065 IS NOT NULL)) Or ((@srcPrimaryForm065 IS NOT NULL) And (@trgPrimaryForm065 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm065 = ' + @srcPrimaryForm065 + ' / ' + @trgPrimaryForm065
  END
  IF (@srcPrimaryForm066 <> @trgPrimaryForm066) Or ((@srcPrimaryForm066 IS NULL) And (@trgPrimaryForm066 IS NOT NULL)) Or ((@srcPrimaryForm066 IS NOT NULL) And (@trgPrimaryForm066 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm066 = ' + @srcPrimaryForm066 + ' / ' + @trgPrimaryForm066
  END
  IF (@srcPrimaryForm067 <> @trgPrimaryForm067) Or ((@srcPrimaryForm067 IS NULL) And (@trgPrimaryForm067 IS NOT NULL)) Or ((@srcPrimaryForm067 IS NOT NULL) And (@trgPrimaryForm067 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm067 = ' + @srcPrimaryForm067 + ' / ' + @trgPrimaryForm067
  END
  IF (@srcPrimaryForm068 <> @trgPrimaryForm068) Or ((@srcPrimaryForm068 IS NULL) And (@trgPrimaryForm068 IS NOT NULL)) Or ((@srcPrimaryForm068 IS NOT NULL) And (@trgPrimaryForm068 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm068 = ' + @srcPrimaryForm068 + ' / ' + @trgPrimaryForm068
  END
  IF (@srcPrimaryForm069 <> @trgPrimaryForm069) Or ((@srcPrimaryForm069 IS NULL) And (@trgPrimaryForm069 IS NOT NULL)) Or ((@srcPrimaryForm069 IS NOT NULL) And (@trgPrimaryForm069 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm069 = ' + @srcPrimaryForm069 + ' / ' + @trgPrimaryForm069
  END
  IF (@srcPrimaryForm070 <> @trgPrimaryForm070) Or ((@srcPrimaryForm070 IS NULL) And (@trgPrimaryForm070 IS NOT NULL)) Or ((@srcPrimaryForm070 IS NOT NULL) And (@trgPrimaryForm070 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm070 = ' + @srcPrimaryForm070 + ' / ' + @trgPrimaryForm070
  END
  IF (@srcPrimaryForm071 <> @trgPrimaryForm071) Or ((@srcPrimaryForm071 IS NULL) And (@trgPrimaryForm071 IS NOT NULL)) Or ((@srcPrimaryForm071 IS NOT NULL) And (@trgPrimaryForm071 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm071 = ' + @srcPrimaryForm071 + ' / ' + @trgPrimaryForm071
  END
  IF (@srcPrimaryForm072 <> @trgPrimaryForm072) Or ((@srcPrimaryForm072 IS NULL) And (@trgPrimaryForm072 IS NOT NULL)) Or ((@srcPrimaryForm072 IS NOT NULL) And (@trgPrimaryForm072 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm072 = ' + @srcPrimaryForm072 + ' / ' + @trgPrimaryForm072
  END
  IF (@srcPrimaryForm073 <> @trgPrimaryForm073) Or ((@srcPrimaryForm073 IS NULL) And (@trgPrimaryForm073 IS NOT NULL)) Or ((@srcPrimaryForm073 IS NOT NULL) And (@trgPrimaryForm073 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm073 = ' + @srcPrimaryForm073 + ' / ' + @trgPrimaryForm073
  END
  IF (@srcPrimaryForm074 <> @trgPrimaryForm074) Or ((@srcPrimaryForm074 IS NULL) And (@trgPrimaryForm074 IS NOT NULL)) Or ((@srcPrimaryForm074 IS NOT NULL) And (@trgPrimaryForm074 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm074 = ' + @srcPrimaryForm074 + ' / ' + @trgPrimaryForm074
  END
  IF (@srcPrimaryForm075 <> @trgPrimaryForm075) Or ((@srcPrimaryForm075 IS NULL) And (@trgPrimaryForm075 IS NOT NULL)) Or ((@srcPrimaryForm075 IS NOT NULL) And (@trgPrimaryForm075 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm075 = ' + @srcPrimaryForm075 + ' / ' + @trgPrimaryForm075
  END
  IF (@srcPrimaryForm076 <> @trgPrimaryForm076) Or ((@srcPrimaryForm076 IS NULL) And (@trgPrimaryForm076 IS NOT NULL)) Or ((@srcPrimaryForm076 IS NOT NULL) And (@trgPrimaryForm076 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm076 = ' + @srcPrimaryForm076 + ' / ' + @trgPrimaryForm076
  END
  IF (@srcPrimaryForm077 <> @trgPrimaryForm077) Or ((@srcPrimaryForm077 IS NULL) And (@trgPrimaryForm077 IS NOT NULL)) Or ((@srcPrimaryForm077 IS NOT NULL) And (@trgPrimaryForm077 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm077 = ' + @srcPrimaryForm077 + ' / ' + @trgPrimaryForm077
  END
  IF (@srcPrimaryForm078 <> @trgPrimaryForm078) Or ((@srcPrimaryForm078 IS NULL) And (@trgPrimaryForm078 IS NOT NULL)) Or ((@srcPrimaryForm078 IS NOT NULL) And (@trgPrimaryForm078 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm078 = ' + @srcPrimaryForm078 + ' / ' + @trgPrimaryForm078
  END
  IF (@srcPrimaryForm079 <> @trgPrimaryForm079) Or ((@srcPrimaryForm079 IS NULL) And (@trgPrimaryForm079 IS NOT NULL)) Or ((@srcPrimaryForm079 IS NOT NULL) And (@trgPrimaryForm079 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm079 = ' + @srcPrimaryForm079 + ' / ' + @trgPrimaryForm079
  END
  IF (@srcPrimaryForm080 <> @trgPrimaryForm080) Or ((@srcPrimaryForm080 IS NULL) And (@trgPrimaryForm080 IS NOT NULL)) Or ((@srcPrimaryForm080 IS NOT NULL) And (@trgPrimaryForm080 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm080 = ' + @srcPrimaryForm080 + ' / ' + @trgPrimaryForm080
  END
  IF (@srcPrimaryForm081 <> @trgPrimaryForm081) Or ((@srcPrimaryForm081 IS NULL) And (@trgPrimaryForm081 IS NOT NULL)) Or ((@srcPrimaryForm081 IS NOT NULL) And (@trgPrimaryForm081 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm081 = ' + @srcPrimaryForm081 + ' / ' + @trgPrimaryForm081
  END
  IF (@srcPrimaryForm082 <> @trgPrimaryForm082) Or ((@srcPrimaryForm082 IS NULL) And (@trgPrimaryForm082 IS NOT NULL)) Or ((@srcPrimaryForm082 IS NOT NULL) And (@trgPrimaryForm082 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm082 = ' + @srcPrimaryForm082 + ' / ' + @trgPrimaryForm082
  END
  IF (@srcPrimaryForm083 <> @trgPrimaryForm083) Or ((@srcPrimaryForm083 IS NULL) And (@trgPrimaryForm083 IS NOT NULL)) Or ((@srcPrimaryForm083 IS NOT NULL) And (@trgPrimaryForm083 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm083 = ' + @srcPrimaryForm083 + ' / ' + @trgPrimaryForm083
  END
  IF (@srcPrimaryForm084 <> @trgPrimaryForm084) Or ((@srcPrimaryForm084 IS NULL) And (@trgPrimaryForm084 IS NOT NULL)) Or ((@srcPrimaryForm084 IS NOT NULL) And (@trgPrimaryForm084 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm084 = ' + @srcPrimaryForm084 + ' / ' + @trgPrimaryForm084
  END
  IF (@srcPrimaryForm085 <> @trgPrimaryForm085) Or ((@srcPrimaryForm085 IS NULL) And (@trgPrimaryForm085 IS NOT NULL)) Or ((@srcPrimaryForm085 IS NOT NULL) And (@trgPrimaryForm085 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm085 = ' + @srcPrimaryForm085 + ' / ' + @trgPrimaryForm085
  END
  IF (@srcPrimaryForm086 <> @trgPrimaryForm086) Or ((@srcPrimaryForm086 IS NULL) And (@trgPrimaryForm086 IS NOT NULL)) Or ((@srcPrimaryForm086 IS NOT NULL) And (@trgPrimaryForm086 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm086 = ' + @srcPrimaryForm086 + ' / ' + @trgPrimaryForm086
  END
  IF (@srcPrimaryForm087 <> @trgPrimaryForm087) Or ((@srcPrimaryForm087 IS NULL) And (@trgPrimaryForm087 IS NOT NULL)) Or ((@srcPrimaryForm087 IS NOT NULL) And (@trgPrimaryForm087 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm087 = ' + @srcPrimaryForm087 + ' / ' + @trgPrimaryForm087
  END
  IF (@srcPrimaryForm088 <> @trgPrimaryForm088) Or ((@srcPrimaryForm088 IS NULL) And (@trgPrimaryForm088 IS NOT NULL)) Or ((@srcPrimaryForm088 IS NOT NULL) And (@trgPrimaryForm088 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm088 = ' + @srcPrimaryForm088 + ' / ' + @trgPrimaryForm088
  END
  IF (@srcPrimaryForm089 <> @trgPrimaryForm089) Or ((@srcPrimaryForm089 IS NULL) And (@trgPrimaryForm089 IS NOT NULL)) Or ((@srcPrimaryForm089 IS NOT NULL) And (@trgPrimaryForm089 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm089 = ' + @srcPrimaryForm089 + ' / ' + @trgPrimaryForm089
  END
  IF (@srcPrimaryForm090 <> @trgPrimaryForm090) Or ((@srcPrimaryForm090 IS NULL) And (@trgPrimaryForm090 IS NOT NULL)) Or ((@srcPrimaryForm090 IS NOT NULL) And (@trgPrimaryForm090 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm090 = ' + @srcPrimaryForm090 + ' / ' + @trgPrimaryForm090
  END
  IF (@srcPrimaryForm091 <> @trgPrimaryForm091) Or ((@srcPrimaryForm091 IS NULL) And (@trgPrimaryForm091 IS NOT NULL)) Or ((@srcPrimaryForm091 IS NOT NULL) And (@trgPrimaryForm091 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm091 = ' + @srcPrimaryForm091 + ' / ' + @trgPrimaryForm091
  END
  IF (@srcPrimaryForm092 <> @trgPrimaryForm092) Or ((@srcPrimaryForm092 IS NULL) And (@trgPrimaryForm092 IS NOT NULL)) Or ((@srcPrimaryForm092 IS NOT NULL) And (@trgPrimaryForm092 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm092 = ' + @srcPrimaryForm092 + ' / ' + @trgPrimaryForm092
  END
  IF (@srcPrimaryForm093 <> @trgPrimaryForm093) Or ((@srcPrimaryForm093 IS NULL) And (@trgPrimaryForm093 IS NOT NULL)) Or ((@srcPrimaryForm093 IS NOT NULL) And (@trgPrimaryForm093 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm093 = ' + @srcPrimaryForm093 + ' / ' + @trgPrimaryForm093
  END
  IF (@srcPrimaryForm094 <> @trgPrimaryForm094) Or ((@srcPrimaryForm094 IS NULL) And (@trgPrimaryForm094 IS NOT NULL)) Or ((@srcPrimaryForm094 IS NOT NULL) And (@trgPrimaryForm094 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm094 = ' + @srcPrimaryForm094 + ' / ' + @trgPrimaryForm094
  END
  IF (@srcPrimaryForm095 <> @trgPrimaryForm095) Or ((@srcPrimaryForm095 IS NULL) And (@trgPrimaryForm095 IS NOT NULL)) Or ((@srcPrimaryForm095 IS NOT NULL) And (@trgPrimaryForm095 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm095 = ' + @srcPrimaryForm095 + ' / ' + @trgPrimaryForm095
  END
  IF (@srcPrimaryForm096 <> @trgPrimaryForm096) Or ((@srcPrimaryForm096 IS NULL) And (@trgPrimaryForm096 IS NOT NULL)) Or ((@srcPrimaryForm096 IS NOT NULL) And (@trgPrimaryForm096 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm096 = ' + @srcPrimaryForm096 + ' / ' + @trgPrimaryForm096
  END
  IF (@srcPrimaryForm097 <> @trgPrimaryForm097) Or ((@srcPrimaryForm097 IS NULL) And (@trgPrimaryForm097 IS NOT NULL)) Or ((@srcPrimaryForm097 IS NOT NULL) And (@trgPrimaryForm097 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm097 = ' + @srcPrimaryForm097 + ' / ' + @trgPrimaryForm097
  END
  IF (@srcPrimaryForm098 <> @trgPrimaryForm098) Or ((@srcPrimaryForm098 IS NULL) And (@trgPrimaryForm098 IS NOT NULL)) Or ((@srcPrimaryForm098 IS NOT NULL) And (@trgPrimaryForm098 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm098 = ' + @srcPrimaryForm098 + ' / ' + @trgPrimaryForm098
  END
  IF (@srcPrimaryForm099 <> @trgPrimaryForm099) Or ((@srcPrimaryForm099 IS NULL) And (@trgPrimaryForm099 IS NOT NULL)) Or ((@srcPrimaryForm099 IS NOT NULL) And (@trgPrimaryForm099 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm099 = ' + @srcPrimaryForm099 + ' / ' + @trgPrimaryForm099
  END
  IF (@srcPrimaryForm100 <> @trgPrimaryForm100) Or ((@srcPrimaryForm100 IS NULL) And (@trgPrimaryForm100 IS NOT NULL)) Or ((@srcPrimaryForm100 IS NOT NULL) And (@trgPrimaryForm100 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm100 = ' + @srcPrimaryForm100 + ' / ' + @trgPrimaryForm100
  END
  IF (@srcPrimaryForm101 <> @trgPrimaryForm101) Or ((@srcPrimaryForm101 IS NULL) And (@trgPrimaryForm101 IS NOT NULL)) Or ((@srcPrimaryForm101 IS NOT NULL) And (@trgPrimaryForm101 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm101 = ' + @srcPrimaryForm101 + ' / ' + @trgPrimaryForm101
  END
  IF (@srcPrimaryForm102 <> @trgPrimaryForm102) Or ((@srcPrimaryForm102 IS NULL) And (@trgPrimaryForm102 IS NOT NULL)) Or ((@srcPrimaryForm102 IS NOT NULL) And (@trgPrimaryForm102 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm102 = ' + @srcPrimaryForm102 + ' / ' + @trgPrimaryForm102
  END
  IF (@srcPrimaryForm103 <> @trgPrimaryForm103) Or ((@srcPrimaryForm103 IS NULL) And (@trgPrimaryForm103 IS NOT NULL)) Or ((@srcPrimaryForm103 IS NOT NULL) And (@trgPrimaryForm103 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm103 = ' + @srcPrimaryForm103 + ' / ' + @trgPrimaryForm103
  END
  IF (@srcPrimaryForm104 <> @trgPrimaryForm104) Or ((@srcPrimaryForm104 IS NULL) And (@trgPrimaryForm104 IS NOT NULL)) Or ((@srcPrimaryForm104 IS NOT NULL) And (@trgPrimaryForm104 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm104 = ' + @srcPrimaryForm104 + ' / ' + @trgPrimaryForm104
  END
  IF (@srcPrimaryForm105 <> @trgPrimaryForm105) Or ((@srcPrimaryForm105 IS NULL) And (@trgPrimaryForm105 IS NOT NULL)) Or ((@srcPrimaryForm105 IS NOT NULL) And (@trgPrimaryForm105 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm105 = ' + @srcPrimaryForm105 + ' / ' + @trgPrimaryForm105
  END
  IF (@srcPrimaryForm106 <> @trgPrimaryForm106) Or ((@srcPrimaryForm106 IS NULL) And (@trgPrimaryForm106 IS NOT NULL)) Or ((@srcPrimaryForm106 IS NOT NULL) And (@trgPrimaryForm106 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm106 = ' + @srcPrimaryForm106 + ' / ' + @trgPrimaryForm106
  END
  IF (@srcPrimaryForm107 <> @trgPrimaryForm107) Or ((@srcPrimaryForm107 IS NULL) And (@trgPrimaryForm107 IS NOT NULL)) Or ((@srcPrimaryForm107 IS NOT NULL) And (@trgPrimaryForm107 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm107 = ' + @srcPrimaryForm107 + ' / ' + @trgPrimaryForm107
  END
  IF (@srcPrimaryForm108 <> @trgPrimaryForm108) Or ((@srcPrimaryForm108 IS NULL) And (@trgPrimaryForm108 IS NOT NULL)) Or ((@srcPrimaryForm108 IS NOT NULL) And (@trgPrimaryForm108 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm108 = ' + @srcPrimaryForm108 + ' / ' + @trgPrimaryForm108
  END
  IF (@srcPrimaryForm109 <> @trgPrimaryForm109) Or ((@srcPrimaryForm109 IS NULL) And (@trgPrimaryForm109 IS NOT NULL)) Or ((@srcPrimaryForm109 IS NOT NULL) And (@trgPrimaryForm109 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm109 = ' + @srcPrimaryForm109 + ' / ' + @trgPrimaryForm109
  END
  IF (@srcPrimaryForm110 <> @trgPrimaryForm110) Or ((@srcPrimaryForm110 IS NULL) And (@trgPrimaryForm110 IS NOT NULL)) Or ((@srcPrimaryForm110 IS NOT NULL) And (@trgPrimaryForm110 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm110 = ' + @srcPrimaryForm110 + ' / ' + @trgPrimaryForm110
  END
  IF (@srcPrimaryForm111 <> @trgPrimaryForm111) Or ((@srcPrimaryForm111 IS NULL) And (@trgPrimaryForm111 IS NOT NULL)) Or ((@srcPrimaryForm111 IS NOT NULL) And (@trgPrimaryForm111 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm111 = ' + @srcPrimaryForm111 + ' / ' + @trgPrimaryForm111
  END
  IF (@srcPrimaryForm112 <> @trgPrimaryForm112) Or ((@srcPrimaryForm112 IS NULL) And (@trgPrimaryForm112 IS NOT NULL)) Or ((@srcPrimaryForm112 IS NOT NULL) And (@trgPrimaryForm112 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm112 = ' + @srcPrimaryForm112 + ' / ' + @trgPrimaryForm112
  END
  IF (@srcPrimaryForm113 <> @trgPrimaryForm113) Or ((@srcPrimaryForm113 IS NULL) And (@trgPrimaryForm113 IS NOT NULL)) Or ((@srcPrimaryForm113 IS NOT NULL) And (@trgPrimaryForm113 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm113 = ' + @srcPrimaryForm113 + ' / ' + @trgPrimaryForm113
  END
  IF (@srcPrimaryForm114 <> @trgPrimaryForm114) Or ((@srcPrimaryForm114 IS NULL) And (@trgPrimaryForm114 IS NOT NULL)) Or ((@srcPrimaryForm114 IS NOT NULL) And (@trgPrimaryForm114 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm114 = ' + @srcPrimaryForm114 + ' / ' + @trgPrimaryForm114
  END
  IF (@srcPrimaryForm115 <> @trgPrimaryForm115) Or ((@srcPrimaryForm115 IS NULL) And (@trgPrimaryForm115 IS NOT NULL)) Or ((@srcPrimaryForm115 IS NOT NULL) And (@trgPrimaryForm115 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm115 = ' + @srcPrimaryForm115 + ' / ' + @trgPrimaryForm115
  END
  IF (@srcPrimaryForm116 <> @trgPrimaryForm116) Or ((@srcPrimaryForm116 IS NULL) And (@trgPrimaryForm116 IS NOT NULL)) Or ((@srcPrimaryForm116 IS NOT NULL) And (@trgPrimaryForm116 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm116 = ' + @srcPrimaryForm116 + ' / ' + @trgPrimaryForm116
  END
  IF (@srcPrimaryForm117 <> @trgPrimaryForm117) Or ((@srcPrimaryForm117 IS NULL) And (@trgPrimaryForm117 IS NOT NULL)) Or ((@srcPrimaryForm117 IS NOT NULL) And (@trgPrimaryForm117 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm117 = ' + @srcPrimaryForm117 + ' / ' + @trgPrimaryForm117
  END
  IF (@srcPrimaryForm118 <> @trgPrimaryForm118) Or ((@srcPrimaryForm118 IS NULL) And (@trgPrimaryForm118 IS NOT NULL)) Or ((@srcPrimaryForm118 IS NOT NULL) And (@trgPrimaryForm118 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm118 = ' + @srcPrimaryForm118 + ' / ' + @trgPrimaryForm118
  END
  IF (@srcPrimaryForm119 <> @trgPrimaryForm119) Or ((@srcPrimaryForm119 IS NULL) And (@trgPrimaryForm119 IS NOT NULL)) Or ((@srcPrimaryForm119 IS NOT NULL) And (@trgPrimaryForm119 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm119 = ' + @srcPrimaryForm119 + ' / ' + @trgPrimaryForm119
  END
  IF (@srcPrimaryForm120 <> @trgPrimaryForm120) Or ((@srcPrimaryForm120 IS NULL) And (@trgPrimaryForm120 IS NOT NULL)) Or ((@srcPrimaryForm120 IS NOT NULL) And (@trgPrimaryForm120 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.PrimaryForm120 = ' + @srcPrimaryForm120 + ' / ' + @trgPrimaryForm120
  END
  IF (@srcDescr <> @trgDescr) Or ((@srcDescr IS NULL) And (@trgDescr IS NOT NULL)) Or ((@srcDescr IS NOT NULL) And (@trgDescr IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.Descr = ' + @srcDescr + ' / ' + @trgDescr
  END
  IF (@srcModuleSec <> @trgModuleSec) Or ((@srcModuleSec IS NULL) And (@trgModuleSec IS NOT NULL)) Or ((@srcModuleSec IS NOT NULL) And (@trgModuleSec IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ModuleSec is different'
  END
  IF (@srcGCR_triRates <> @trgGCR_triRates) Or ((@srcGCR_triRates IS NULL) And (@trgGCR_triRates IS NOT NULL)) Or ((@srcGCR_triRates IS NOT NULL) And (@trgGCR_triRates IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.GCR_triRates is different'
  END
  IF (@srcGCR_triEuro <> @trgGCR_triEuro) Or ((@srcGCR_triEuro IS NULL) And (@trgGCR_triEuro IS NOT NULL)) Or ((@srcGCR_triEuro IS NOT NULL) And (@trgGCR_triEuro IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.GCR_triEuro is different'
  END
  IF (@srcGCR_triInvert <> @trgGCR_triInvert) Or ((@srcGCR_triInvert IS NULL) And (@trgGCR_triInvert IS NOT NULL)) Or ((@srcGCR_triInvert IS NOT NULL) And (@trgGCR_triInvert IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.GCR_triInvert is different'
  END
  IF (@srcGCR_triFloat <> @trgGCR_triFloat) Or ((@srcGCR_triFloat IS NULL) And (@trgGCR_triFloat IS NOT NULL)) Or ((@srcGCR_triFloat IS NOT NULL) And (@trgGCR_triFloat IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.GCR_triFloat is different'
  END
  IF (@srcVEDIMethod <> @trgVEDIMethod) Or ((@srcVEDIMethod IS NULL) And (@trgVEDIMethod IS NOT NULL)) Or ((@srcVEDIMethod IS NOT NULL) And (@trgVEDIMethod IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VEDIMethod = ' + STR(@srcVEDIMethod) + ' / ' + STR(@trgVEDIMethod)
  END
  IF (@srcVVanMode <> @trgVVanMode) Or ((@srcVVanMode IS NULL) And (@trgVVanMode IS NOT NULL)) Or ((@srcVVanMode IS NOT NULL) And (@trgVVanMode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VVanMode = ' + STR(@srcVVanMode) + ' / ' + STR(@trgVVanMode)
  END
  IF (@srcVEDIFACT <> @trgVEDIFACT) Or ((@srcVEDIFACT IS NULL) And (@trgVEDIFACT IS NOT NULL)) Or ((@srcVEDIFACT IS NOT NULL) And (@trgVEDIFACT IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VEDIFACT = ' + STR(@srcVEDIFACT) + ' / ' + STR(@trgVEDIFACT)
  END
  IF (@srcVVANCEId <> @trgVVANCEId) Or ((@srcVVANCEId IS NULL) And (@trgVVANCEId IS NOT NULL)) Or ((@srcVVANCEId IS NOT NULL) And (@trgVVANCEId IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VVANCEId = ' + @srcVVANCEId + ' / ' + @trgVVANCEId
  END
  IF (@srcVVANUId <> @trgVVANUId) Or ((@srcVVANUId IS NULL) And (@trgVVANUId IS NOT NULL)) Or ((@srcVVANUId IS NOT NULL) And (@trgVVANUId IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VVANUId = ' + @srcVVANUId + ' / ' + @trgVVANUId
  END
  IF (@srcVUseCRLF <> @trgVUseCRLF) Or ((@srcVUseCRLF IS NULL) And (@trgVUseCRLF IS NOT NULL)) Or ((@srcVUseCRLF IS NOT NULL) And (@trgVUseCRLF IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VUseCRLF = ' + STR(@srcVUseCRLF) + ' / ' + STR(@trgVUseCRLF)
  END
  IF (@srcVTestMode <> @trgVTestMode) Or ((@srcVTestMode IS NULL) And (@trgVTestMode IS NOT NULL)) Or ((@srcVTestMode IS NOT NULL) And (@trgVTestMode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VTestMode = ' + STR(@srcVTestMode) + ' / ' + STR(@trgVTestMode)
  END
  IF (@srcVDirPAth <> @trgVDirPAth) Or ((@srcVDirPAth IS NULL) And (@trgVDirPAth IS NOT NULL)) Or ((@srcVDirPAth IS NOT NULL) And (@trgVDirPAth IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VDirPAth = ' + @srcVDirPAth + ' / ' + @trgVDirPAth
  END
  IF (@srcVCompress <> @trgVCompress) Or ((@srcVCompress IS NULL) And (@trgVCompress IS NOT NULL)) Or ((@srcVCompress IS NOT NULL) And (@trgVCompress IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VCompress = ' + STR(@srcVCompress) + ' / ' + STR(@trgVCompress)
  END
  IF (@srcVCEEmail <> @trgVCEEmail) Or ((@srcVCEEmail IS NULL) And (@trgVCEEmail IS NOT NULL)) Or ((@srcVCEEmail IS NOT NULL) And (@trgVCEEmail IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VCEEmail = ' + @srcVCEEmail + ' / ' + @trgVCEEmail
  END
  IF (@srcVUEmail <> @trgVUEmail) Or ((@srcVUEmail IS NULL) And (@trgVUEmail IS NOT NULL)) Or ((@srcVUEmail IS NOT NULL) And (@trgVUEmail IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VUEmail = ' + @srcVUEmail + ' / ' + @trgVUEmail
  END
  IF (@srcVEPriority <> @trgVEPriority) Or ((@srcVEPriority IS NULL) And (@trgVEPriority IS NOT NULL)) Or ((@srcVEPriority IS NOT NULL) And (@trgVEPriority IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VEPriority = ' + STR(@srcVEPriority) + ' / ' + STR(@trgVEPriority)
  END
  IF (@srcVESubject <> @trgVESubject) Or ((@srcVESubject IS NULL) And (@trgVESubject IS NOT NULL)) Or ((@srcVESubject IS NOT NULL) And (@trgVESubject IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VESubject = ' + @srcVESubject + ' / ' + @trgVESubject
  END
  IF (@srcVSendEmail <> @trgVSendEmail) Or ((@srcVSendEmail IS NULL) And (@trgVSendEmail IS NOT NULL)) Or ((@srcVSendEmail IS NOT NULL) And (@trgVSendEmail IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VSendEmail = ' + STR(@srcVSendEmail) + ' / ' + STR(@trgVSendEmail)
  END
  IF (@srcVIEECSLP <> @trgVIEECSLP) Or ((@srcVIEECSLP IS NULL) And (@trgVIEECSLP IS NOT NULL)) Or ((@srcVIEECSLP IS NOT NULL) And (@trgVIEECSLP IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.VIEECSLP = ' + @srcVIEECSLP + ' / ' + @trgVIEECSLP
  END
  IF (@srcEmName <> @trgEmName) Or ((@srcEmName IS NULL) And (@trgEmName IS NOT NULL)) Or ((@srcEmName IS NOT NULL) And (@trgEmName IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.EmName = ' + @srcEmName + ' / ' + @trgEmName
  END
  IF (@srcEmAddress <> @trgEmAddress) Or ((@srcEmAddress IS NULL) And (@trgEmAddress IS NOT NULL)) Or ((@srcEmAddress IS NOT NULL) And (@trgEmAddress IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.EmAddress = ' + @srcEmAddress + ' / ' + @trgEmAddress
  END
  IF (@srcEmSMTP <> @trgEmSMTP) Or ((@srcEmSMTP IS NULL) And (@trgEmSMTP IS NOT NULL)) Or ((@srcEmSMTP IS NOT NULL) And (@trgEmSMTP IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.EmSMTP = ' + @srcEmSMTP + ' / ' + @trgEmSMTP
  END
  IF (@srcEmPriority <> @trgEmPriority) Or ((@srcEmPriority IS NULL) And (@trgEmPriority IS NOT NULL)) Or ((@srcEmPriority IS NOT NULL) And (@trgEmPriority IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.EmPriority = ' + STR(@srcEmPriority) + ' / ' + STR(@trgEmPriority)
  END
  IF (@srcEmUseMAPI <> @trgEmUseMAPI) Or ((@srcEmUseMAPI IS NULL) And (@trgEmUseMAPI IS NOT NULL)) Or ((@srcEmUseMAPI IS NOT NULL) And (@trgEmUseMAPI IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.EmUseMAPI = ' + STR(@srcEmUseMAPI) + ' / ' + STR(@trgEmUseMAPI)
  END
  IF (@srcFxUseMAPI <> @trgFxUseMAPI) Or ((@srcFxUseMAPI IS NULL) And (@trgFxUseMAPI IS NOT NULL)) Or ((@srcFxUseMAPI IS NOT NULL) And (@trgFxUseMAPI IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.FxUseMAPI = ' + STR(@srcFxUseMAPI) + ' / ' + STR(@trgFxUseMAPI)
  END
  IF (@srcFaxPrnN <> @trgFaxPrnN) Or ((@srcFaxPrnN IS NULL) And (@trgFaxPrnN IS NOT NULL)) Or ((@srcFaxPrnN IS NOT NULL) And (@trgFaxPrnN IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.FaxPrnN = ' + @srcFaxPrnN + ' / ' + @trgFaxPrnN
  END
  IF (@srcEmailPrnN <> @trgEmailPrnN) Or ((@srcEmailPrnN IS NULL) And (@trgEmailPrnN IS NOT NULL)) Or ((@srcEmailPrnN IS NOT NULL) And (@trgEmailPrnN IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.EmailPrnN = ' + @srcEmailPrnN + ' / ' + @trgEmailPrnN
  END
  IF (@srcFxName <> @trgFxName) Or ((@srcFxName IS NULL) And (@trgFxName IS NOT NULL)) Or ((@srcFxName IS NOT NULL) And (@trgFxName IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.FxName = ' + @srcFxName + ' / ' + @trgFxName
  END
  IF (@srcFxPhone <> @trgFxPhone) Or ((@srcFxPhone IS NULL) And (@trgFxPhone IS NOT NULL)) Or ((@srcFxPhone IS NOT NULL) And (@trgFxPhone IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.FxPhone = ' + @srcFxPhone + ' / ' + @trgFxPhone
  END
  IF (@srcEmAttchMode <> @trgEmAttchMode) Or ((@srcEmAttchMode IS NULL) And (@trgEmAttchMode IS NOT NULL)) Or ((@srcEmAttchMode IS NOT NULL) And (@trgEmAttchMode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.EmAttchMode = ' + STR(@srcEmAttchMode) + ' / ' + STR(@trgEmAttchMode)
  END
  IF (@srcFaxDLLPath <> @trgFaxDLLPath) Or ((@srcFaxDLLPath IS NULL) And (@trgFaxDLLPath IS NOT NULL)) Or ((@srcFaxDLLPath IS NOT NULL) And (@trgFaxDLLPath IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.FaxDLLPath = ' + @srcFaxDLLPath + ' / ' + @trgFaxDLLPath
  END
  IF (@srcSpare <> @trgSpare) Or ((@srcSpare IS NULL) And (@trgSpare IS NOT NULL)) Or ((@srcSpare IS NOT NULL) And (@trgSpare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.Spare is different'
  END
  IF (@srcFCaptions <> @trgFCaptions) Or ((@srcFCaptions IS NULL) And (@trgFCaptions IS NOT NULL)) Or ((@srcFCaptions IS NOT NULL) And (@trgFCaptions IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.FCaptions is different'
  END
  IF (@srcFHide <> @trgFHide) Or ((@srcFHide IS NULL) And (@trgFHide IS NOT NULL)) Or ((@srcFHide IS NOT NULL) And (@trgFHide IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.FHide is different'
  END
  IF (@srcCISConstructCode <> @trgCISConstructCode) Or ((@srcCISConstructCode IS NULL) And (@trgCISConstructCode IS NOT NULL)) Or ((@srcCISConstructCode IS NOT NULL) And (@trgCISConstructCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISConstructCode = ' + @srcCISConstructCode + ' / ' + @trgCISConstructCode
  END
  IF (@srcCISConstructDesc <> @trgCISConstructDesc) Or ((@srcCISConstructDesc IS NULL) And (@trgCISConstructDesc IS NOT NULL)) Or ((@srcCISConstructDesc IS NOT NULL) And (@trgCISConstructDesc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISConstructDesc = ' + @srcCISConstructDesc + ' / ' + @trgCISConstructDesc
  END
  IF (@srcCISConstructRate <> @trgCISConstructRate) Or ((@srcCISConstructRate IS NULL) And (@trgCISConstructRate IS NOT NULL)) Or ((@srcCISConstructRate IS NOT NULL) And (@trgCISConstructRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISConstructRate = ' + @srcCISConstructRate + ' / ' + @trgCISConstructRate
  END
  IF (@srcCISConstructGLCode <> @trgCISConstructGLCode) Or ((@srcCISConstructGLCode IS NULL) And (@trgCISConstructGLCode IS NOT NULL)) Or ((@srcCISConstructGLCode IS NOT NULL) And (@trgCISConstructGLCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISConstructGLCode = ' + STR(@srcCISConstructGLCode) + ' / ' + STR(@trgCISConstructGLCode)
  END
  IF (@srcCISConstructDepartment <> @trgCISConstructDepartment) Or ((@srcCISConstructDepartment IS NULL) And (@trgCISConstructDepartment IS NOT NULL)) Or ((@srcCISConstructDepartment IS NOT NULL) And (@trgCISConstructDepartment IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISConstructDepartment = ' + @srcCISConstructDepartment + ' / ' + @trgCISConstructDepartment
  END
  IF (@srcCISConstructCostCentre <> @trgCISConstructCostCentre) Or ((@srcCISConstructCostCentre IS NULL) And (@trgCISConstructCostCentre IS NOT NULL)) Or ((@srcCISConstructCostCentre IS NOT NULL) And (@trgCISConstructCostCentre IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISConstructCostCentre = ' + @srcCISConstructCostCentre + ' / ' + @trgCISConstructCostCentre
  END
  IF (@srcCISConstructSpare <> @trgCISConstructSpare) Or ((@srcCISConstructSpare IS NULL) And (@trgCISConstructSpare IS NOT NULL)) Or ((@srcCISConstructSpare IS NOT NULL) And (@trgCISConstructSpare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISConstructSpare is different'
  END
  IF (@srcCISTechnicalCode <> @trgCISTechnicalCode) Or ((@srcCISTechnicalCode IS NULL) And (@trgCISTechnicalCode IS NOT NULL)) Or ((@srcCISTechnicalCode IS NOT NULL) And (@trgCISTechnicalCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISTechnicalCode = ' + @srcCISTechnicalCode + ' / ' + @trgCISTechnicalCode
  END
  IF (@srcCISTechnicalDesc <> @trgCISTechnicalDesc) Or ((@srcCISTechnicalDesc IS NULL) And (@trgCISTechnicalDesc IS NOT NULL)) Or ((@srcCISTechnicalDesc IS NOT NULL) And (@trgCISTechnicalDesc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISTechnicalDesc = ' + @srcCISTechnicalDesc + ' / ' + @trgCISTechnicalDesc
  END
  IF (@srcCISTechnicalRate <> @trgCISTechnicalRate) Or ((@srcCISTechnicalRate IS NULL) And (@trgCISTechnicalRate IS NOT NULL)) Or ((@srcCISTechnicalRate IS NOT NULL) And (@trgCISTechnicalRate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISTechnicalRate = ' + @srcCISTechnicalRate + ' / ' + @trgCISTechnicalRate
  END
  IF (@srcCISTechnicalGLCode <> @trgCISTechnicalGLCode) Or ((@srcCISTechnicalGLCode IS NULL) And (@trgCISTechnicalGLCode IS NOT NULL)) Or ((@srcCISTechnicalGLCode IS NOT NULL) And (@trgCISTechnicalGLCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISTechnicalGLCode = ' + STR(@srcCISTechnicalGLCode) + ' / ' + STR(@trgCISTechnicalGLCode)
  END
  IF (@srcCISTechnicalDepartment <> @trgCISTechnicalDepartment) Or ((@srcCISTechnicalDepartment IS NULL) And (@trgCISTechnicalDepartment IS NOT NULL)) Or ((@srcCISTechnicalDepartment IS NOT NULL) And (@trgCISTechnicalDepartment IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISTechnicalDepartment = ' + @srcCISTechnicalDepartment + ' / ' + @trgCISTechnicalDepartment
  END
  IF (@srcCISTechnicalCostCentre <> @trgCISTechnicalCostCentre) Or ((@srcCISTechnicalCostCentre IS NULL) And (@trgCISTechnicalCostCentre IS NOT NULL)) Or ((@srcCISTechnicalCostCentre IS NOT NULL) And (@trgCISTechnicalCostCentre IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISTechnicalCostCentre = ' + @srcCISTechnicalCostCentre + ' / ' + @trgCISTechnicalCostCentre
  END
  IF (@srcCISTechnicalSpare <> @trgCISTechnicalSpare) Or ((@srcCISTechnicalSpare IS NULL) And (@trgCISTechnicalSpare IS NOT NULL)) Or ((@srcCISTechnicalSpare IS NOT NULL) And (@trgCISTechnicalSpare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISTechnicalSpare is different'
  END
  IF (@srcCISRate1Code <> @trgCISRate1Code) Or ((@srcCISRate1Code IS NULL) And (@trgCISRate1Code IS NOT NULL)) Or ((@srcCISRate1Code IS NOT NULL) And (@trgCISRate1Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate1Code = ' + @srcCISRate1Code + ' / ' + @trgCISRate1Code
  END
  IF (@srcCISRate1Desc <> @trgCISRate1Desc) Or ((@srcCISRate1Desc IS NULL) And (@trgCISRate1Desc IS NOT NULL)) Or ((@srcCISRate1Desc IS NOT NULL) And (@trgCISRate1Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate1Desc = ' + @srcCISRate1Desc + ' / ' + @trgCISRate1Desc
  END
  IF (@srcCISRate1Rate <> @trgCISRate1Rate) Or ((@srcCISRate1Rate IS NULL) And (@trgCISRate1Rate IS NOT NULL)) Or ((@srcCISRate1Rate IS NOT NULL) And (@trgCISRate1Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate1Rate = ' + @srcCISRate1Rate + ' / ' + @trgCISRate1Rate
  END
  IF (@srcCISRate1GLCode <> @trgCISRate1GLCode) Or ((@srcCISRate1GLCode IS NULL) And (@trgCISRate1GLCode IS NOT NULL)) Or ((@srcCISRate1GLCode IS NOT NULL) And (@trgCISRate1GLCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate1GLCode = ' + STR(@srcCISRate1GLCode) + ' / ' + STR(@trgCISRate1GLCode)
  END
  IF (@srcCISRate1Department <> @trgCISRate1Department) Or ((@srcCISRate1Department IS NULL) And (@trgCISRate1Department IS NOT NULL)) Or ((@srcCISRate1Department IS NOT NULL) And (@trgCISRate1Department IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate1Department = ' + @srcCISRate1Department + ' / ' + @trgCISRate1Department
  END
  IF (@srcCISRate1CostCentre <> @trgCISRate1CostCentre) Or ((@srcCISRate1CostCentre IS NULL) And (@trgCISRate1CostCentre IS NOT NULL)) Or ((@srcCISRate1CostCentre IS NOT NULL) And (@trgCISRate1CostCentre IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate1CostCentre = ' + @srcCISRate1CostCentre + ' / ' + @trgCISRate1CostCentre
  END
  IF (@srcCISRate1Spare <> @trgCISRate1Spare) Or ((@srcCISRate1Spare IS NULL) And (@trgCISRate1Spare IS NOT NULL)) Or ((@srcCISRate1Spare IS NOT NULL) And (@trgCISRate1Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate1Spare is different'
  END
  IF (@srcCISRate2Code <> @trgCISRate2Code) Or ((@srcCISRate2Code IS NULL) And (@trgCISRate2Code IS NOT NULL)) Or ((@srcCISRate2Code IS NOT NULL) And (@trgCISRate2Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate2Code = ' + @srcCISRate2Code + ' / ' + @trgCISRate2Code
  END
  IF (@srcCISRate2Desc <> @trgCISRate2Desc) Or ((@srcCISRate2Desc IS NULL) And (@trgCISRate2Desc IS NOT NULL)) Or ((@srcCISRate2Desc IS NOT NULL) And (@trgCISRate2Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate2Desc = ' + @srcCISRate2Desc + ' / ' + @trgCISRate2Desc
  END
  IF (@srcCISRate2Rate <> @trgCISRate2Rate) Or ((@srcCISRate2Rate IS NULL) And (@trgCISRate2Rate IS NOT NULL)) Or ((@srcCISRate2Rate IS NOT NULL) And (@trgCISRate2Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate2Rate = ' + @srcCISRate2Rate + ' / ' + @trgCISRate2Rate
  END
  IF (@srcCISRate2GLCode <> @trgCISRate2GLCode) Or ((@srcCISRate2GLCode IS NULL) And (@trgCISRate2GLCode IS NOT NULL)) Or ((@srcCISRate2GLCode IS NOT NULL) And (@trgCISRate2GLCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate2GLCode = ' + STR(@srcCISRate2GLCode) + ' / ' + STR(@trgCISRate2GLCode)
  END
  IF (@srcCISRate2Department <> @trgCISRate2Department) Or ((@srcCISRate2Department IS NULL) And (@trgCISRate2Department IS NOT NULL)) Or ((@srcCISRate2Department IS NOT NULL) And (@trgCISRate2Department IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate2Department = ' + @srcCISRate2Department + ' / ' + @trgCISRate2Department
  END
  IF (@srcCISRate2CostCentre <> @trgCISRate2CostCentre) Or ((@srcCISRate2CostCentre IS NULL) And (@trgCISRate2CostCentre IS NOT NULL)) Or ((@srcCISRate2CostCentre IS NOT NULL) And (@trgCISRate2CostCentre IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate2CostCentre = ' + @srcCISRate2CostCentre + ' / ' + @trgCISRate2CostCentre
  END
  IF (@srcCISRate2Spare <> @trgCISRate2Spare) Or ((@srcCISRate2Spare IS NULL) And (@trgCISRate2Spare IS NOT NULL)) Or ((@srcCISRate2Spare IS NOT NULL) And (@trgCISRate2Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate2Spare is different'
  END
  IF (@srcCISRate3Code <> @trgCISRate3Code) Or ((@srcCISRate3Code IS NULL) And (@trgCISRate3Code IS NOT NULL)) Or ((@srcCISRate3Code IS NOT NULL) And (@trgCISRate3Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate3Code = ' + @srcCISRate3Code + ' / ' + @trgCISRate3Code
  END
  IF (@srcCISRate3Desc <> @trgCISRate3Desc) Or ((@srcCISRate3Desc IS NULL) And (@trgCISRate3Desc IS NOT NULL)) Or ((@srcCISRate3Desc IS NOT NULL) And (@trgCISRate3Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate3Desc = ' + @srcCISRate3Desc + ' / ' + @trgCISRate3Desc
  END
  IF (@srcCISRate3Rate <> @trgCISRate3Rate) Or ((@srcCISRate3Rate IS NULL) And (@trgCISRate3Rate IS NOT NULL)) Or ((@srcCISRate3Rate IS NOT NULL) And (@trgCISRate3Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate3Rate = ' + @srcCISRate3Rate + ' / ' + @trgCISRate3Rate
  END
  IF (@srcCISRate3GLCode <> @trgCISRate3GLCode) Or ((@srcCISRate3GLCode IS NULL) And (@trgCISRate3GLCode IS NOT NULL)) Or ((@srcCISRate3GLCode IS NOT NULL) And (@trgCISRate3GLCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate3GLCode = ' + STR(@srcCISRate3GLCode) + ' / ' + STR(@trgCISRate3GLCode)
  END
  IF (@srcCISRate3Department <> @trgCISRate3Department) Or ((@srcCISRate3Department IS NULL) And (@trgCISRate3Department IS NOT NULL)) Or ((@srcCISRate3Department IS NOT NULL) And (@trgCISRate3Department IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate3Department = ' + @srcCISRate3Department + ' / ' + @trgCISRate3Department
  END
  IF (@srcCISRate3CostCentre <> @trgCISRate3CostCentre) Or ((@srcCISRate3CostCentre IS NULL) And (@trgCISRate3CostCentre IS NOT NULL)) Or ((@srcCISRate3CostCentre IS NOT NULL) And (@trgCISRate3CostCentre IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate3CostCentre = ' + @srcCISRate3CostCentre + ' / ' + @trgCISRate3CostCentre
  END
  IF (@srcCISRate3Spare <> @trgCISRate3Spare) Or ((@srcCISRate3Spare IS NULL) And (@trgCISRate3Spare IS NOT NULL)) Or ((@srcCISRate3Spare IS NOT NULL) And (@trgCISRate3Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate3Spare is different'
  END
  IF (@srcCISRate4Code <> @trgCISRate4Code) Or ((@srcCISRate4Code IS NULL) And (@trgCISRate4Code IS NOT NULL)) Or ((@srcCISRate4Code IS NOT NULL) And (@trgCISRate4Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate4Code = ' + @srcCISRate4Code + ' / ' + @trgCISRate4Code
  END
  IF (@srcCISRate4Desc <> @trgCISRate4Desc) Or ((@srcCISRate4Desc IS NULL) And (@trgCISRate4Desc IS NOT NULL)) Or ((@srcCISRate4Desc IS NOT NULL) And (@trgCISRate4Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate4Desc = ' + @srcCISRate4Desc + ' / ' + @trgCISRate4Desc
  END
  IF (@srcCISRate4Rate <> @trgCISRate4Rate) Or ((@srcCISRate4Rate IS NULL) And (@trgCISRate4Rate IS NOT NULL)) Or ((@srcCISRate4Rate IS NOT NULL) And (@trgCISRate4Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate4Rate = ' + @srcCISRate4Rate + ' / ' + @trgCISRate4Rate
  END
  IF (@srcCISRate4GLCode <> @trgCISRate4GLCode) Or ((@srcCISRate4GLCode IS NULL) And (@trgCISRate4GLCode IS NOT NULL)) Or ((@srcCISRate4GLCode IS NOT NULL) And (@trgCISRate4GLCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate4GLCode = ' + STR(@srcCISRate4GLCode) + ' / ' + STR(@trgCISRate4GLCode)
  END
  IF (@srcCISRate4Department <> @trgCISRate4Department) Or ((@srcCISRate4Department IS NULL) And (@trgCISRate4Department IS NOT NULL)) Or ((@srcCISRate4Department IS NOT NULL) And (@trgCISRate4Department IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate4Department = ' + @srcCISRate4Department + ' / ' + @trgCISRate4Department
  END
  IF (@srcCISRate4CostCentre <> @trgCISRate4CostCentre) Or ((@srcCISRate4CostCentre IS NULL) And (@trgCISRate4CostCentre IS NOT NULL)) Or ((@srcCISRate4CostCentre IS NOT NULL) And (@trgCISRate4CostCentre IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate4CostCentre = ' + @srcCISRate4CostCentre + ' / ' + @trgCISRate4CostCentre
  END
  IF (@srcCISRate4Spare <> @trgCISRate4Spare) Or ((@srcCISRate4Spare IS NULL) And (@trgCISRate4Spare IS NOT NULL)) Or ((@srcCISRate4Spare IS NOT NULL) And (@trgCISRate4Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate4Spare is different'
  END
  IF (@srcCISRate5Code <> @trgCISRate5Code) Or ((@srcCISRate5Code IS NULL) And (@trgCISRate5Code IS NOT NULL)) Or ((@srcCISRate5Code IS NOT NULL) And (@trgCISRate5Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate5Code = ' + @srcCISRate5Code + ' / ' + @trgCISRate5Code
  END
  IF (@srcCISRate5Desc <> @trgCISRate5Desc) Or ((@srcCISRate5Desc IS NULL) And (@trgCISRate5Desc IS NOT NULL)) Or ((@srcCISRate5Desc IS NOT NULL) And (@trgCISRate5Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate5Desc = ' + @srcCISRate5Desc + ' / ' + @trgCISRate5Desc
  END
  IF (@srcCISRate5Rate <> @trgCISRate5Rate) Or ((@srcCISRate5Rate IS NULL) And (@trgCISRate5Rate IS NOT NULL)) Or ((@srcCISRate5Rate IS NOT NULL) And (@trgCISRate5Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate5Rate = ' + @srcCISRate5Rate + ' / ' + @trgCISRate5Rate
  END
  IF (@srcCISRate5GLCode <> @trgCISRate5GLCode) Or ((@srcCISRate5GLCode IS NULL) And (@trgCISRate5GLCode IS NOT NULL)) Or ((@srcCISRate5GLCode IS NOT NULL) And (@trgCISRate5GLCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate5GLCode = ' + STR(@srcCISRate5GLCode) + ' / ' + STR(@trgCISRate5GLCode)
  END
  IF (@srcCISRate5Department <> @trgCISRate5Department) Or ((@srcCISRate5Department IS NULL) And (@trgCISRate5Department IS NOT NULL)) Or ((@srcCISRate5Department IS NOT NULL) And (@trgCISRate5Department IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate5Department = ' + @srcCISRate5Department + ' / ' + @trgCISRate5Department
  END
  IF (@srcCISRate5CostCentre <> @trgCISRate5CostCentre) Or ((@srcCISRate5CostCentre IS NULL) And (@trgCISRate5CostCentre IS NOT NULL)) Or ((@srcCISRate5CostCentre IS NOT NULL) And (@trgCISRate5CostCentre IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate5CostCentre = ' + @srcCISRate5CostCentre + ' / ' + @trgCISRate5CostCentre
  END
  IF (@srcCISRate5Spare <> @trgCISRate5Spare) Or ((@srcCISRate5Spare IS NULL) And (@trgCISRate5Spare IS NOT NULL)) Or ((@srcCISRate5Spare IS NOT NULL) And (@trgCISRate5Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate5Spare is different'
  END
  IF (@srcCISRate6Code <> @trgCISRate6Code) Or ((@srcCISRate6Code IS NULL) And (@trgCISRate6Code IS NOT NULL)) Or ((@srcCISRate6Code IS NOT NULL) And (@trgCISRate6Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate6Code = ' + @srcCISRate6Code + ' / ' + @trgCISRate6Code
  END
  IF (@srcCISRate6Desc <> @trgCISRate6Desc) Or ((@srcCISRate6Desc IS NULL) And (@trgCISRate6Desc IS NOT NULL)) Or ((@srcCISRate6Desc IS NOT NULL) And (@trgCISRate6Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate6Desc = ' + @srcCISRate6Desc + ' / ' + @trgCISRate6Desc
  END
  IF (@srcCISRate6Rate <> @trgCISRate6Rate) Or ((@srcCISRate6Rate IS NULL) And (@trgCISRate6Rate IS NOT NULL)) Or ((@srcCISRate6Rate IS NOT NULL) And (@trgCISRate6Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate6Rate = ' + @srcCISRate6Rate + ' / ' + @trgCISRate6Rate
  END
  IF (@srcCISRate6GLCode <> @trgCISRate6GLCode) Or ((@srcCISRate6GLCode IS NULL) And (@trgCISRate6GLCode IS NOT NULL)) Or ((@srcCISRate6GLCode IS NOT NULL) And (@trgCISRate6GLCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate6GLCode = ' + STR(@srcCISRate6GLCode) + ' / ' + STR(@trgCISRate6GLCode)
  END
  IF (@srcCISRate6Department <> @trgCISRate6Department) Or ((@srcCISRate6Department IS NULL) And (@trgCISRate6Department IS NOT NULL)) Or ((@srcCISRate6Department IS NOT NULL) And (@trgCISRate6Department IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate6Department = ' + @srcCISRate6Department + ' / ' + @trgCISRate6Department
  END
  IF (@srcCISRate6CostCentre <> @trgCISRate6CostCentre) Or ((@srcCISRate6CostCentre IS NULL) And (@trgCISRate6CostCentre IS NOT NULL)) Or ((@srcCISRate6CostCentre IS NOT NULL) And (@trgCISRate6CostCentre IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate6CostCentre = ' + @srcCISRate6CostCentre + ' / ' + @trgCISRate6CostCentre
  END
  IF (@srcCISRate6Spare <> @trgCISRate6Spare) Or ((@srcCISRate6Spare IS NULL) And (@trgCISRate6Spare IS NOT NULL)) Or ((@srcCISRate6Spare IS NOT NULL) And (@trgCISRate6Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate6Spare is different'
  END
  IF (@srcCISRate7Code <> @trgCISRate7Code) Or ((@srcCISRate7Code IS NULL) And (@trgCISRate7Code IS NOT NULL)) Or ((@srcCISRate7Code IS NOT NULL) And (@trgCISRate7Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate7Code = ' + @srcCISRate7Code + ' / ' + @trgCISRate7Code
  END
  IF (@srcCISRate7Desc <> @trgCISRate7Desc) Or ((@srcCISRate7Desc IS NULL) And (@trgCISRate7Desc IS NOT NULL)) Or ((@srcCISRate7Desc IS NOT NULL) And (@trgCISRate7Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate7Desc = ' + @srcCISRate7Desc + ' / ' + @trgCISRate7Desc
  END
  IF (@srcCISRate7Rate <> @trgCISRate7Rate) Or ((@srcCISRate7Rate IS NULL) And (@trgCISRate7Rate IS NOT NULL)) Or ((@srcCISRate7Rate IS NOT NULL) And (@trgCISRate7Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate7Rate = ' + @srcCISRate7Rate + ' / ' + @trgCISRate7Rate
  END
  IF (@srcCISRate7GLCode <> @trgCISRate7GLCode) Or ((@srcCISRate7GLCode IS NULL) And (@trgCISRate7GLCode IS NOT NULL)) Or ((@srcCISRate7GLCode IS NOT NULL) And (@trgCISRate7GLCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate7GLCode = ' + STR(@srcCISRate7GLCode) + ' / ' + STR(@trgCISRate7GLCode)
  END
  IF (@srcCISRate7Department <> @trgCISRate7Department) Or ((@srcCISRate7Department IS NULL) And (@trgCISRate7Department IS NOT NULL)) Or ((@srcCISRate7Department IS NOT NULL) And (@trgCISRate7Department IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate7Department = ' + @srcCISRate7Department + ' / ' + @trgCISRate7Department
  END
  IF (@srcCISRate7CostCentre <> @trgCISRate7CostCentre) Or ((@srcCISRate7CostCentre IS NULL) And (@trgCISRate7CostCentre IS NOT NULL)) Or ((@srcCISRate7CostCentre IS NOT NULL) And (@trgCISRate7CostCentre IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate7CostCentre = ' + @srcCISRate7CostCentre + ' / ' + @trgCISRate7CostCentre
  END
  IF (@srcCISRate7Spare <> @trgCISRate7Spare) Or ((@srcCISRate7Spare IS NULL) And (@trgCISRate7Spare IS NOT NULL)) Or ((@srcCISRate7Spare IS NOT NULL) And (@trgCISRate7Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate7Spare is different'
  END
  IF (@srcCISRate8Code <> @trgCISRate8Code) Or ((@srcCISRate8Code IS NULL) And (@trgCISRate8Code IS NOT NULL)) Or ((@srcCISRate8Code IS NOT NULL) And (@trgCISRate8Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate8Code = ' + @srcCISRate8Code + ' / ' + @trgCISRate8Code
  END
  IF (@srcCISRate8Desc <> @trgCISRate8Desc) Or ((@srcCISRate8Desc IS NULL) And (@trgCISRate8Desc IS NOT NULL)) Or ((@srcCISRate8Desc IS NOT NULL) And (@trgCISRate8Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate8Desc = ' + @srcCISRate8Desc + ' / ' + @trgCISRate8Desc
  END
  IF (@srcCISRate8Rate <> @trgCISRate8Rate) Or ((@srcCISRate8Rate IS NULL) And (@trgCISRate8Rate IS NOT NULL)) Or ((@srcCISRate8Rate IS NOT NULL) And (@trgCISRate8Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate8Rate = ' + @srcCISRate8Rate + ' / ' + @trgCISRate8Rate
  END
  IF (@srcCISRate8GLCode <> @trgCISRate8GLCode) Or ((@srcCISRate8GLCode IS NULL) And (@trgCISRate8GLCode IS NOT NULL)) Or ((@srcCISRate8GLCode IS NOT NULL) And (@trgCISRate8GLCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate8GLCode = ' + STR(@srcCISRate8GLCode) + ' / ' + STR(@trgCISRate8GLCode)
  END
  IF (@srcCISRate8Department <> @trgCISRate8Department) Or ((@srcCISRate8Department IS NULL) And (@trgCISRate8Department IS NOT NULL)) Or ((@srcCISRate8Department IS NOT NULL) And (@trgCISRate8Department IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate8Department = ' + @srcCISRate8Department + ' / ' + @trgCISRate8Department
  END
  IF (@srcCISRate8CostCentre <> @trgCISRate8CostCentre) Or ((@srcCISRate8CostCentre IS NULL) And (@trgCISRate8CostCentre IS NOT NULL)) Or ((@srcCISRate8CostCentre IS NOT NULL) And (@trgCISRate8CostCentre IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate8CostCentre = ' + @srcCISRate8CostCentre + ' / ' + @trgCISRate8CostCentre
  END
  IF (@srcCISRate8Spare <> @trgCISRate8Spare) Or ((@srcCISRate8Spare IS NULL) And (@trgCISRate8Spare IS NOT NULL)) Or ((@srcCISRate8Spare IS NOT NULL) And (@trgCISRate8Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate8Spare is different'
  END
  IF (@srcCISRate9Code <> @trgCISRate9Code) Or ((@srcCISRate9Code IS NULL) And (@trgCISRate9Code IS NOT NULL)) Or ((@srcCISRate9Code IS NOT NULL) And (@trgCISRate9Code IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate9Code = ' + @srcCISRate9Code + ' / ' + @trgCISRate9Code
  END
  IF (@srcCISRate9Desc <> @trgCISRate9Desc) Or ((@srcCISRate9Desc IS NULL) And (@trgCISRate9Desc IS NOT NULL)) Or ((@srcCISRate9Desc IS NOT NULL) And (@trgCISRate9Desc IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate9Desc = ' + @srcCISRate9Desc + ' / ' + @trgCISRate9Desc
  END
  IF (@srcCISRate9Rate <> @trgCISRate9Rate) Or ((@srcCISRate9Rate IS NULL) And (@trgCISRate9Rate IS NOT NULL)) Or ((@srcCISRate9Rate IS NOT NULL) And (@trgCISRate9Rate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate9Rate = ' + @srcCISRate9Rate + ' / ' + @trgCISRate9Rate
  END
  IF (@srcCISRate9GLCode <> @trgCISRate9GLCode) Or ((@srcCISRate9GLCode IS NULL) And (@trgCISRate9GLCode IS NOT NULL)) Or ((@srcCISRate9GLCode IS NOT NULL) And (@trgCISRate9GLCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate9GLCode = ' + STR(@srcCISRate9GLCode) + ' / ' + STR(@trgCISRate9GLCode)
  END
  IF (@srcCISRate9Department <> @trgCISRate9Department) Or ((@srcCISRate9Department IS NULL) And (@trgCISRate9Department IS NOT NULL)) Or ((@srcCISRate9Department IS NOT NULL) And (@trgCISRate9Department IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate9Department = ' + @srcCISRate9Department + ' / ' + @trgCISRate9Department
  END
  IF (@srcCISRate9CostCentre <> @trgCISRate9CostCentre) Or ((@srcCISRate9CostCentre IS NULL) And (@trgCISRate9CostCentre IS NOT NULL)) Or ((@srcCISRate9CostCentre IS NOT NULL) And (@trgCISRate9CostCentre IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate9CostCentre = ' + @srcCISRate9CostCentre + ' / ' + @trgCISRate9CostCentre
  END
  IF (@srcCISRate9Spare <> @trgCISRate9Spare) Or ((@srcCISRate9Spare IS NULL) And (@trgCISRate9Spare IS NOT NULL)) Or ((@srcCISRate9Spare IS NOT NULL) And (@trgCISRate9Spare IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISRate9Spare is different'
  END
  IF (@srcCISInterval <> @trgCISInterval) Or ((@srcCISInterval IS NULL) And (@trgCISInterval IS NOT NULL)) Or ((@srcCISInterval IS NOT NULL) And (@trgCISInterval IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISInterval = ' + STR(@srcCISInterval) + ' / ' + STR(@trgCISInterval)
  END
  IF (@srcCISAutoSetPr <> @trgCISAutoSetPr) Or ((@srcCISAutoSetPr IS NULL) And (@trgCISAutoSetPr IS NOT NULL)) Or ((@srcCISAutoSetPr IS NOT NULL) And (@trgCISAutoSetPr IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISAutoSetPr = ' + STR(@srcCISAutoSetPr) + ' / ' + STR(@trgCISAutoSetPr)
  END
  IF (@srcCISVATCode <> @trgCISVATCode) Or ((@srcCISVATCode IS NULL) And (@trgCISVATCode IS NOT NULL)) Or ((@srcCISVATCode IS NOT NULL) And (@trgCISVATCode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISVATCode = ' + @srcCISVATCode + ' / ' + @trgCISVATCode
  END
  IF (@srcCISSpare3 <> @trgCISSpare3) Or ((@srcCISSpare3 IS NULL) And (@trgCISSpare3 IS NOT NULL)) Or ((@srcCISSpare3 IS NOT NULL) And (@trgCISSpare3 IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISSpare3 is different'
  END
  IF (@srcCISScheme <> @trgCISScheme) Or ((@srcCISScheme IS NULL) And (@trgCISScheme IS NOT NULL)) Or ((@srcCISScheme IS NOT NULL) And (@trgCISScheme IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISScheme = ' + @srcCISScheme + ' / ' + @trgCISScheme
  END
  IF (@srcCISReturnDate <> @trgCISReturnDate) Or ((@srcCISReturnDate IS NULL) And (@trgCISReturnDate IS NOT NULL)) Or ((@srcCISReturnDate IS NOT NULL) And (@trgCISReturnDate IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISReturnDate = ' + @srcCISReturnDate + ' / ' + @trgCISReturnDate
  END
  IF (@srcCISCurrPeriod <> @trgCISCurrPeriod) Or ((@srcCISCurrPeriod IS NULL) And (@trgCISCurrPeriod IS NOT NULL)) Or ((@srcCISCurrPeriod IS NOT NULL) And (@trgCISCurrPeriod IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISCurrPeriod = ' + @srcCISCurrPeriod + ' / ' + @trgCISCurrPeriod
  END
  IF (@srcCISLoaded <> @trgCISLoaded) Or ((@srcCISLoaded IS NULL) And (@trgCISLoaded IS NOT NULL)) Or ((@srcCISLoaded IS NOT NULL) And (@trgCISLoaded IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISLoaded = ' + STR(@srcCISLoaded) + ' / ' + STR(@trgCISLoaded)
  END
  IF (@srcCISTaxRef <> @trgCISTaxRef) Or ((@srcCISTaxRef IS NULL) And (@trgCISTaxRef IS NOT NULL)) Or ((@srcCISTaxRef IS NOT NULL) And (@trgCISTaxRef IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISTaxRef = ' + @srcCISTaxRef + ' / ' + @trgCISTaxRef
  END
  IF (@srcCISAggMode <> @trgCISAggMode) Or ((@srcCISAggMode IS NULL) And (@trgCISAggMode IS NOT NULL)) Or ((@srcCISAggMode IS NOT NULL) And (@trgCISAggMode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISAggMode = ' + STR(@srcCISAggMode) + ' / ' + STR(@trgCISAggMode)
  END
  IF (@srcCISSortMode <> @trgCISSortMode) Or ((@srcCISSortMode IS NULL) And (@trgCISSortMode IS NOT NULL)) Or ((@srcCISSortMode IS NOT NULL) And (@trgCISSortMode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISSortMode = ' + STR(@srcCISSortMode) + ' / ' + STR(@trgCISSortMode)
  END
  IF (@srcCISVFolio <> @trgCISVFolio) Or ((@srcCISVFolio IS NULL) And (@trgCISVFolio IS NOT NULL)) Or ((@srcCISVFolio IS NOT NULL) And (@trgCISVFolio IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISVFolio = ' + STR(@srcCISVFolio) + ' / ' + STR(@trgCISVFolio)
  END
  IF (@srcCISVouchers <> @trgCISVouchers) Or ((@srcCISVouchers IS NULL) And (@trgCISVouchers IS NOT NULL)) Or ((@srcCISVouchers IS NOT NULL) And (@trgCISVouchers IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISVouchers is different'
  END
  IF (@srcIVANMode <> @trgIVANMode) Or ((@srcIVANMode IS NULL) And (@trgIVANMode IS NOT NULL)) Or ((@srcIVANMode IS NOT NULL) And (@trgIVANMode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IVANMode = ' + STR(@srcIVANMode) + ' / ' + STR(@trgIVANMode)
  END
  IF (@srcIVANIRId <> @trgIVANIRId) Or ((@srcIVANIRId IS NULL) And (@trgIVANIRId IS NOT NULL)) Or ((@srcIVANIRId IS NOT NULL) And (@trgIVANIRId IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IVANIRId = ' + @srcIVANIRId + ' / ' + @trgIVANIRId
  END
  IF (@srcIVANUId <> @trgIVANUId) Or ((@srcIVANUId IS NULL) And (@trgIVANUId IS NOT NULL)) Or ((@srcIVANUId IS NOT NULL) And (@trgIVANUId IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IVANUId = ' + @srcIVANUId + ' / ' + @trgIVANUId
  END
  IF (@srcIVANPw <> @trgIVANPw) Or ((@srcIVANPw IS NULL) And (@trgIVANPw IS NOT NULL)) Or ((@srcIVANPw IS NOT NULL) And (@trgIVANPw IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IVANPw = ' + @srcIVANPw + ' / ' + @trgIVANPw
  END
  IF (@srcIIREDIRef <> @trgIIREDIRef) Or ((@srcIIREDIRef IS NULL) And (@trgIIREDIRef IS NOT NULL)) Or ((@srcIIREDIRef IS NOT NULL) And (@trgIIREDIRef IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IIREDIRef = ' + @srcIIREDIRef + ' / ' + @trgIIREDIRef
  END
  IF (@srcIUseCRLF <> @trgIUseCRLF) Or ((@srcIUseCRLF IS NULL) And (@trgIUseCRLF IS NOT NULL)) Or ((@srcIUseCRLF IS NOT NULL) And (@trgIUseCRLF IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IUseCRLF = ' + STR(@srcIUseCRLF) + ' / ' + STR(@trgIUseCRLF)
  END
  IF (@srcITestMode <> @trgITestMode) Or ((@srcITestMode IS NULL) And (@trgITestMode IS NOT NULL)) Or ((@srcITestMode IS NOT NULL) And (@trgITestMode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ITestMode = ' + STR(@srcITestMode) + ' / ' + STR(@trgITestMode)
  END
  IF (@srcIDirPath <> @trgIDirPath) Or ((@srcIDirPath IS NULL) And (@trgIDirPath IS NOT NULL)) Or ((@srcIDirPath IS NOT NULL) And (@trgIDirPath IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IDirPath = ' + @srcIDirPath + ' / ' + @trgIDirPath
  END
  IF (@srcIEDIMethod <> @trgIEDIMethod) Or ((@srcIEDIMethod IS NULL) And (@trgIEDIMethod IS NOT NULL)) Or ((@srcIEDIMethod IS NOT NULL) And (@trgIEDIMethod IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IEDIMethod = ' + STR(@srcIEDIMethod) + ' / ' + STR(@trgIEDIMethod)
  END
  IF (@srcISendEmail <> @trgISendEmail) Or ((@srcISendEmail IS NULL) And (@trgISendEmail IS NOT NULL)) Or ((@srcISendEmail IS NOT NULL) And (@trgISendEmail IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.ISendEmail = ' + STR(@srcISendEmail) + ' / ' + STR(@trgISendEmail)
  END
  IF (@srcIEPriority <> @trgIEPriority) Or ((@srcIEPriority IS NULL) And (@trgIEPriority IS NOT NULL)) Or ((@srcIEPriority IS NOT NULL) And (@trgIEPriority IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IEPriority = ' + STR(@srcIEPriority) + ' / ' + STR(@trgIEPriority)
  END
  IF (@srcJCertNo <> @trgJCertNo) Or ((@srcJCertNo IS NULL) And (@trgJCertNo IS NOT NULL)) Or ((@srcJCertNo IS NOT NULL) And (@trgJCertNo IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.JCertNo = ' + @srcJCertNo + ' / ' + @trgJCertNo
  END
  IF (@srcJCertExpiry <> @trgJCertExpiry) Or ((@srcJCertExpiry IS NULL) And (@trgJCertExpiry IS NOT NULL)) Or ((@srcJCertExpiry IS NOT NULL) And (@trgJCertExpiry IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.JCertExpiry = ' + @srcJCertExpiry + ' / ' + @trgJCertExpiry
  END
  IF (@srcJCISType <> @trgJCISType) Or ((@srcJCISType IS NULL) And (@trgJCISType IS NOT NULL)) Or ((@srcJCISType IS NOT NULL) And (@trgJCISType IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.JCISType = ' + STR(@srcJCISType) + ' / ' + STR(@trgJCISType)
  END
  IF (@srcCISCNINO <> @trgCISCNINO) Or ((@srcCISCNINO IS NULL) And (@trgCISCNINO IS NOT NULL)) Or ((@srcCISCNINO IS NOT NULL) And (@trgCISCNINO IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISCNINO = ' + @srcCISCNINO + ' / ' + @trgCISCNINO
  END
  IF (@srcCISCUTR <> @trgCISCUTR) Or ((@srcCISCUTR IS NULL) And (@trgCISCUTR IS NOT NULL)) Or ((@srcCISCUTR IS NOT NULL) And (@trgCISCUTR IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISCUTR = ' + @srcCISCUTR + ' / ' + @trgCISCUTR
  END
  IF (@srcCISACCONo <> @trgCISACCONo) Or ((@srcCISACCONo IS NULL) And (@trgCISACCONo IS NOT NULL)) Or ((@srcCISACCONo IS NOT NULL) And (@trgCISACCONo IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.CISACCONo = ' + @srcCISACCONo + ' / ' + @trgCISACCONo
  END
  IF (@srcIGWIRId <> @trgIGWIRId) Or ((@srcIGWIRId IS NULL) And (@trgIGWIRId IS NOT NULL)) Or ((@srcIGWIRId IS NOT NULL) And (@trgIGWIRId IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IGWIRId = ' + @srcIGWIRId + ' / ' + @trgIGWIRId
  END
  IF (@srcIGWUId <> @trgIGWUId) Or ((@srcIGWUId IS NULL) And (@trgIGWUId IS NOT NULL)) Or ((@srcIGWUId IS NOT NULL) And (@trgIGWUId IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IGWUId = ' + @srcIGWUId + ' / ' + @trgIGWUId
  END
  IF (@srcIGWTO <> @trgIGWTO) Or ((@srcIGWTO IS NULL) And (@trgIGWTO IS NOT NULL)) Or ((@srcIGWTO IS NOT NULL) And (@trgIGWTO IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IGWTO = ' + @srcIGWTO + ' / ' + @trgIGWTO
  END
  IF (@srcIGWIRef <> @trgIGWIRef) Or ((@srcIGWIRef IS NULL) And (@trgIGWIRef IS NOT NULL)) Or ((@srcIGWIRef IS NOT NULL) And (@trgIGWIRef IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IGWIRef = ' + @srcIGWIRef + ' / ' + @trgIGWIRef
  END
  IF (@srcIXMLDirPath <> @trgIXMLDirPath) Or ((@srcIXMLDirPath IS NULL) And (@trgIXMLDirPath IS NOT NULL)) Or ((@srcIXMLDirPath IS NOT NULL) And (@trgIXMLDirPath IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IXMLDirPath = ' + @srcIXMLDirPath + ' / ' + @trgIXMLDirPath
  END
  IF (@srcIXTestMode <> @trgIXTestMode) Or ((@srcIXTestMode IS NULL) And (@trgIXTestMode IS NOT NULL)) Or ((@srcIXTestMode IS NOT NULL) And (@trgIXTestMode IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IXTestMode = ' + STR(@srcIXTestMode) + ' / ' + STR(@trgIXTestMode)
  END
  IF (@srcIXConfEmp <> @trgIXConfEmp) Or ((@srcIXConfEmp IS NULL) And (@trgIXConfEmp IS NOT NULL)) Or ((@srcIXConfEmp IS NOT NULL) And (@trgIXConfEmp IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IXConfEmp = ' + STR(@srcIXConfEmp) + ' / ' + STR(@trgIXConfEmp)
  END
  IF (@srcIXVerSub <> @trgIXVerSub) Or ((@srcIXVerSub IS NULL) And (@trgIXVerSub IS NOT NULL)) Or ((@srcIXVerSub IS NOT NULL) And (@trgIXVerSub IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IXVerSub = ' + STR(@srcIXVerSub) + ' / ' + STR(@trgIXVerSub)
  END
  IF (@srcIXNoPay <> @trgIXNoPay) Or ((@srcIXNoPay IS NULL) And (@trgIXNoPay IS NOT NULL)) Or ((@srcIXNoPay IS NOT NULL) And (@trgIXNoPay IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IXNoPay = ' + STR(@srcIXNoPay) + ' / ' + STR(@trgIXNoPay)
  END
  IF (@srcIGWTR <> @trgIGWTR) Or ((@srcIGWTR IS NULL) And (@trgIGWTR IS NOT NULL)) Or ((@srcIGWTR IS NOT NULL) And (@trgIGWTR IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IGWTR = ' + @srcIGWTR + ' / ' + @trgIGWTR
  END
  IF (@srcIGSubType <> @trgIGSubType) Or ((@srcIGSubType IS NULL) And (@trgIGSubType IS NOT NULL)) Or ((@srcIGSubType IS NOT NULL) And (@trgIGSubType IS NULL))
  BEGIN
    PRINT 'Code: ' + master.sys.fn_varbintohexstr(@srcIDCode) + '  ExchqSS.IGSubType = ' + STR(@srcIGSubType) + ' / ' + STR(@trgIGSubType)
  END
  FETCH NEXT FROM srcExchqSS INTO @srcIDCode
                                 , @srcOpt
                                 , @srcOMonWk1
                                 , @srcPrinYr
                                 , @srcFiltSNoBinLoc
                                 , @srcKeepBinHist
                                 , @srcUseBKTheme
                                 , @srcUserName
                                 , @srcAuditYr
                                 , @srcAuditPr
                                 , @srcSpare6
                                 , @srcManROCP
                                 , @srcVATCurr
                                 , @srcNoCosDec
                                 , @srcCurrBase
                                 , @srcMuteBeep
                                 , @srcShowStkGP
                                 , @srcAutoValStk
                                 , @srcDelPickOnly
                                 , @srcUseMLoc
                                 , @srcEditSinSer
                                 , @srcWarnYRef
                                 , @srcUseLocDel
                                 , @srcPostCCNom
                                 , @srcAlTolVal
                                 , @srcAlTolMode
                                 , @srcDebtLMode
                                 , @srcAutoGenVar
                                 , @srcAutoGenDisc
                                 , @srcUseModuleSec
                                 , @srcProtectPost
                                 , @srcUsePick4All
                                 , @srcBigStkTree
                                 , @srcBigJobTree
                                 , @srcShowQtySTree
                                 , @srcProtectYRef
                                 , @srcPurchUIDate
                                 , @srcUseUpliftNC
                                 , @srcUseWIss4All
                                 , @srcUseSTDWOP
                                 , @srcUseSalesAnal
                                 , @srcPostCCDCombo
                                 , @srcUseClassToolB
                                 , @srcWOPStkCopMode
                                 , @srcUSRCntryCode
                                 , @srcNoNetDec
                                 , @srcDebTrig
                                 , @srcBKThemeNo
                                 , @srcUseGLClass
                                 , @srcSpare4
                                 , @srcNoInvLines
                                 , @srcWksODue
                                 , @srcCPr
                                 , @srcCYr
                                 , @srcOAuditDate
                                 , @srcTradeTerm
                                 , @srcStaSepCr
                                 , @srcStaAgeMthd
                                 , @srcStaUIDate
                                 , @srcSepRunPost
                                 , @srcQUAllocFlg
                                 , @srcDeadBOM
                                 , @srcAuthMode
                                 , @srcIntraStat
                                 , @srcAnalStkDesc
                                 , @srcAutoStkVal
                                 , @srcAutoBillUp
                                 , @srcAutoCQNo
                                 , @srcIncNotDue
                                 , @srcUseBatchTot
                                 , @srcUseStock
                                 , @srcAutoNotes
                                 , @srcHideMenuOpt
                                 , @srcUseCCDep
                                 , @srcNoHoldDisc
                                 , @srcAutoPrCalc
                                 , @srcStopBadDr
                                 , @srcUsePayIn
                                 , @srcUsePasswords
                                 , @srcPrintReciept
                                 , @srcExternCust
                                 , @srcNoQtyDec
                                 , @srcExternSIN
                                 , @srcPrevPrOff
                                 , @srcDefPcDisc
                                 , @srcTradCodeNum
                                 , @srcUpBalOnPost
                                 , @srcShowInvDisc
                                 , @srcSepDiscounts
                                 , @srcUseCreditChk
                                 , @srcUseCRLimitChk
                                 , @srcAutoClearPay
                                 , @srcTotalConv
                                 , @srcDispPrAsMonths
                                 , @srcNomCtrlInVAT
                                 , @srcNomCtrlOutVAT
                                 , @srcNomCtrlDebtors
                                 , @srcNomCtrlCreditors
                                 , @srcNomCtrlDiscountGiven
                                 , @srcNomCtrlDiscountTaken
                                 , @srcNomCtrlLDiscGiven
                                 , @srcNomCtrlLDiscTaken
                                 , @srcNomCtrlProfitBF
                                 , @srcNomCtrlCurrVar
                                 , @srcNomCtrlUnRCurrVar
                                 , @srcNomCtrlPLStart
                                 , @srcNomCtrlPLEnd
                                 , @srcNomCtrlFreightNC
                                 , @srcNomCtrlSalesComm
                                 , @srcNomCtrlPurchComm
                                 , @srcNomCtrlRetSurcharge
                                 , @srcNomCtrlSpare8
                                 , @srcNomCtrlSpare9
                                 , @srcNomCtrlSpare10
                                 , @srcNomCtrlSpare11
                                 , @srcNomCtrlSpare12
                                 , @srcNomCtrlSpare13
                                 , @srcNomCtrlSpare14
                                 , @srcDetailAddr1
                                 , @srcDetailAddr2
                                 , @srcDetailAddr3
                                 , @srcDetailAddr4
                                 , @srcDetailAddr5
                                 , @srcDirectCust
                                 , @srcDirectSupp
                                 , @srcTermsofTrade1
                                 , @srcTermsofTrade2
                                 , @srcNomPayFrom
                                 , @srcNomPayToo
                                 , @srcSettleDisc
                                 , @srcSettleDays
                                 , @srcNeedBMUp
                                 , @srcIgnoreBDPW
                                 , @srcInpPack
                                 , @srcSpare32
                                 , @srcVATCode
                                 , @srcPayTerms
                                 , @srcOTrigDate
                                 , @srcStaAgeInt
                                 , @srcQuoOwnDate
                                 , @srcFreeExAll
                                 , @srcDirOwnCount
                                 , @srcStaShowOS
                                 , @srcLiveCredS
                                 , @srcBatchPPY
                                 , @srcWarnJC
                                 , @srcTxLateCR
                                 , @srcConsvMem
                                 , @srcDefBankNom
                                 , @srcUseDefBank
                                 , @srcHideExLogo
                                 , @srcAMMThread
                                 , @srcAMMPreview1
                                 , @srcAMMPreview2
                                 , @srcEntULogCount
                                 , @srcDefSRCBankNom
                                 , @srcSDNOwnDate
                                 , @srcEXISN
                                 , @srcExDemoVer
                                 , @srcDupliVSec
                                 , @srcLastDaily
                                 , @srcUserSort
                                 , @srcUserAcc
                                 , @srcUserRef
                                 , @srcSpareBits
                                 , @srcGracePeriod
                                 , @srcMonWk1
                                 , @srcAuditDate
                                 , @srcTrigDate
                                 , @srcExUsrSec
                                 , @srcUsrLogCount
                                 , @srcBinMask
                                 , @srcSpare5a
                                 , @srcSpare6a
                                 , @srcUserBank
                                 , @srcExSec
                                 , @srcLastExpFolio
                                 , @srcDetailTel
                                 , @srcDetailFax
                                 , @srcUserVATReg
                                 , @srcEnableTTDDiscounts
                                 , @srcEnableVBDDiscounts
                                 , @srcEnableOverrideLocations
                                 , @srcIncludeVATInCommittedBalance
                                 , @srcVATStandardCode
                                 , @srcVATStandardDesc
                                 , @srcVATStandardRate
                                 , @srcVATStandardSpare
                                 , @srcVATStandardInclude
                                 , @srcVATStandardSpare2
                                 , @srcVATExemptCode
                                 , @srcVATExemptDesc
                                 , @srcVATExemptRate
                                 , @srcVATExemptSpare
                                 , @srcVATExemptInclude
                                 , @srcVATExemptSpare2
                                 , @srcVATZeroCode
                                 , @srcVATZeroDesc
                                 , @srcVATZeroRate
                                 , @srcVATZeroSpare
                                 , @srcVATZeroInclude
                                 , @srcVATZeroSpare2
                                 , @srcVATRate1Code
                                 , @srcVATRate1Desc
                                 , @srcVATRate1Rate
                                 , @srcVATRate1Spare
                                 , @srcVATRate1Include
                                 , @srcVATRate1Spare2
                                 , @srcVATRate2Code
                                 , @srcVATRate2Desc
                                 , @srcVATRate2Rate
                                 , @srcVATRate2Spare
                                 , @srcVATRate2Include
                                 , @srcVATRate2Spare2
                                 , @srcVATRate3Code
                                 , @srcVATRate3Desc
                                 , @srcVATRate3Rate
                                 , @srcVATRate3Spare
                                 , @srcVATRate3Include
                                 , @srcVATRate3Spare2
                                 , @srcVATRate4Code
                                 , @srcVATRate4Desc
                                 , @srcVATRate4Rate
                                 , @srcVATRate4Spare
                                 , @srcVATRate4Include
                                 , @srcVATRate4Spare2
                                 , @srcVATRate5Code
                                 , @srcVATRate5Desc
                                 , @srcVATRate5Rate
                                 , @srcVATRate5Spare
                                 , @srcVATRate5Include
                                 , @srcVATRate5Spare2
                                 , @srcVATRate6Code
                                 , @srcVATRate6Desc
                                 , @srcVATRate6Rate
                                 , @srcVATRate6Spare
                                 , @srcVATRate6Include
                                 , @srcVATRate6Spare2
                                 , @srcVATRate7Code
                                 , @srcVATRate7Desc
                                 , @srcVATRate7Rate
                                 , @srcVATRate7Spare
                                 , @srcVATRate7Include
                                 , @srcVATRate7Spare2
                                 , @srcVATRate8Code
                                 , @srcVATRate8Desc
                                 , @srcVATRate8Rate
                                 , @srcVATRate8Spare
                                 , @srcVATRate8Include
                                 , @srcVATRate8Spare2
                                 , @srcVATRate9Code
                                 , @srcVATRate9Desc
                                 , @srcVATRate9Rate
                                 , @srcVATRate9Spare
                                 , @srcVATRate9Include
                                 , @srcVATRate9Spare2
                                 , @srcVATRate10Code
                                 , @srcVATRate10Desc
                                 , @srcVATRate10Rate
                                 , @srcVATRate10Spare
                                 , @srcVATRate10Include
                                 , @srcVATRate10Spare2
                                 , @srcVATRate11Code
                                 , @srcVATRate11Desc
                                 , @srcVATRate11Rate
                                 , @srcVATRate11Spare
                                 , @srcVATRate11Include
                                 , @srcVATRate11Spare2
                                 , @srcVATRate12Code
                                 , @srcVATRate12Desc
                                 , @srcVATRate12Rate
                                 , @srcVATRate12Spare
                                 , @srcVATRate12Include
                                 , @srcVATRate12Spare2
                                 , @srcVATRate13Code
                                 , @srcVATRate13Desc
                                 , @srcVATRate13Rate
                                 , @srcVATRate13Spare
                                 , @srcVATRate13Include
                                 , @srcVATRate13Spare2
                                 , @srcVATRate14Code
                                 , @srcVATRate14Desc
                                 , @srcVATRate14Rate
                                 , @srcVATRate14Spare
                                 , @srcVATRate14Include
                                 , @srcVATRate14Spare2
                                 , @srcVATRate15Code
                                 , @srcVATRate15Desc
                                 , @srcVATRate15Rate
                                 , @srcVATRate15Spare
                                 , @srcVATRate15Include
                                 , @srcVATRate15Spare2
                                 , @srcVATRate16Code
                                 , @srcVATRate16Desc
                                 , @srcVATRate16Rate
                                 , @srcVATRate16Spare
                                 , @srcVATRate16Include
                                 , @srcVATRate16Spare2
                                 , @srcVATRate17Code
                                 , @srcVATRate17Desc
                                 , @srcVATRate17Rate
                                 , @srcVATRate17Spare
                                 , @srcVATRate17Include
                                 , @srcVATRate17Spare2
                                 , @srcVATRate18Code
                                 , @srcVATRate18Desc
                                 , @srcVATRate18Rate
                                 , @srcVATRate18Spare
                                 , @srcVATRate18Include
                                 , @srcVATRate18Spare2
                                 , @srcVATIAdjCode
                                 , @srcVATIAdjDesc
                                 , @srcVATIAdjRate
                                 , @srcVATIAdjSpare
                                 , @srcVATIAdjInclude
                                 , @srcVATIAdjSpare2
                                 , @srcVATOAdjCode
                                 , @srcVATOAdjDesc
                                 , @srcVATOAdjRate
                                 , @srcVATOAdjSpare
                                 , @srcVATOAdjInclude
                                 , @srcVATOAdjSpare2
                                 , @srcVATSpare8Code
                                 , @srcVATSpare8Desc
                                 , @srcVATSpare8Rate
                                 , @srcVATSpare8Spare
                                 , @srcVATSpare8Include
                                 , @srcVATSpare8Spare2
                                 , @srcHideUDF7
                                 , @srcHideUDF8
                                 , @srcHideUDF9
                                 , @srcHideUDF10
                                 , @srcHideUDF11
                                 , @srcSpare2
                                 , @srcVATInterval
                                 , @srcSpare3
                                 , @srcVATScheme
                                 , @srcOLastECSalesDate
                                 , @srcVATReturnDate
                                 , @srcLastECSalesDate
                                 , @srcCurrPeriod
                                 , @srcUDFCaption1
                                 , @srcUDFCaption2
                                 , @srcUDFCaption3
                                 , @srcUDFCaption4
                                 , @srcUDFCaption5
                                 , @srcUDFCaption6
                                 , @srcUDFCaption7
                                 , @srcUDFCaption8
                                 , @srcUDFCaption9
                                 , @srcUDFCaption10
                                 , @srcUDFCaption11
                                 , @srcUDFCaption12
                                 , @srcUDFCaption13
                                 , @srcUDFCaption14
                                 , @srcUDFCaption15
                                 , @srcUDFCaption16
                                 , @srcUDFCaption17
                                 , @srcUDFCaption18
                                 , @srcUDFCaption19
                                 , @srcUDFCaption20
                                 , @srcUDFCaption21
                                 , @srcUDFCaption22
                                 , @srcHideLType0
                                 , @srcHideLType1
                                 , @srcHideLType2
                                 , @srcHideLType3
                                 , @srcHideLType4
                                 , @srcHideLType5
                                 , @srcHideLType6
                                 , @srcReportPrnN
                                 , @srcFormsPrnN
                                 , @srcEnableECServices
                                 , @srcECSalesThreshold
                                 , @srcMainCurrency00ScreenSymbol
                                 , @srcMainCurrency00Desc
                                 , @srcMainCurrency00CompanyRate
                                 , @srcMainCurrency00DailyRate
                                 , @srcMainCurrency00PrintSymbol
                                 , @srcMainCurrency01ScreenSymbol
                                 , @srcMainCurrency01Desc
                                 , @srcMainCurrency01CompanyRate
                                 , @srcMainCurrency01DailyRate
                                 , @srcMainCurrency01PrintSymbol
                                 , @srcMainCurrency02ScreenSymbol
                                 , @srcMainCurrency02Desc
                                 , @srcMainCurrency02CompanyRate
                                 , @srcMainCurrency02DailyRate
                                 , @srcMainCurrency02PrintSymbol
                                 , @srcMainCurrency03ScreenSymbol
                                 , @srcMainCurrency03Desc
                                 , @srcMainCurrency03CompanyRate
                                 , @srcMainCurrency03DailyRate
                                 , @srcMainCurrency03PrintSymbol
                                 , @srcMainCurrency04ScreenSymbol
                                 , @srcMainCurrency04Desc
                                 , @srcMainCurrency04CompanyRate
                                 , @srcMainCurrency04DailyRate
                                 , @srcMainCurrency04PrintSymbol
                                 , @srcMainCurrency05ScreenSymbol
                                 , @srcMainCurrency05Desc
                                 , @srcMainCurrency05CompanyRate
                                 , @srcMainCurrency05DailyRate
                                 , @srcMainCurrency05PrintSymbol
                                 , @srcMainCurrency06ScreenSymbol
                                 , @srcMainCurrency06Desc
                                 , @srcMainCurrency06CompanyRate
                                 , @srcMainCurrency06DailyRate
                                 , @srcMainCurrency06PrintSymbol
                                 , @srcMainCurrency07ScreenSymbol
                                 , @srcMainCurrency07Desc
                                 , @srcMainCurrency07CompanyRate
                                 , @srcMainCurrency07DailyRate
                                 , @srcMainCurrency07PrintSymbol
                                 , @srcMainCurrency08ScreenSymbol
                                 , @srcMainCurrency08Desc
                                 , @srcMainCurrency08CompanyRate
                                 , @srcMainCurrency08DailyRate
                                 , @srcMainCurrency08PrintSymbol
                                 , @srcMainCurrency09ScreenSymbol
                                 , @srcMainCurrency09Desc
                                 , @srcMainCurrency09CompanyRate
                                 , @srcMainCurrency09DailyRate
                                 , @srcMainCurrency09PrintSymbol
                                 , @srcMainCurrency10ScreenSymbol
                                 , @srcMainCurrency10Desc
                                 , @srcMainCurrency10CompanyRate
                                 , @srcMainCurrency10DailyRate
                                 , @srcMainCurrency10PrintSymbol
                                 , @srcMainCurrency11ScreenSymbol
                                 , @srcMainCurrency11Desc
                                 , @srcMainCurrency11CompanyRate
                                 , @srcMainCurrency11DailyRate
                                 , @srcMainCurrency11PrintSymbol
                                 , @srcMainCurrency12ScreenSymbol
                                 , @srcMainCurrency12Desc
                                 , @srcMainCurrency12CompanyRate
                                 , @srcMainCurrency12DailyRate
                                 , @srcMainCurrency12PrintSymbol
                                 , @srcMainCurrency13ScreenSymbol
                                 , @srcMainCurrency13Desc
                                 , @srcMainCurrency13CompanyRate
                                 , @srcMainCurrency13DailyRate
                                 , @srcMainCurrency13PrintSymbol
                                 , @srcMainCurrency14ScreenSymbol
                                 , @srcMainCurrency14Desc
                                 , @srcMainCurrency14CompanyRate
                                 , @srcMainCurrency14DailyRate
                                 , @srcMainCurrency14PrintSymbol
                                 , @srcMainCurrency15ScreenSymbol
                                 , @srcMainCurrency15Desc
                                 , @srcMainCurrency15CompanyRate
                                 , @srcMainCurrency15DailyRate
                                 , @srcMainCurrency15PrintSymbol
                                 , @srcMainCurrency16ScreenSymbol
                                 , @srcMainCurrency16Desc
                                 , @srcMainCurrency16CompanyRate
                                 , @srcMainCurrency16DailyRate
                                 , @srcMainCurrency16PrintSymbol
                                 , @srcMainCurrency17ScreenSymbol
                                 , @srcMainCurrency17Desc
                                 , @srcMainCurrency17CompanyRate
                                 , @srcMainCurrency17DailyRate
                                 , @srcMainCurrency17PrintSymbol
                                 , @srcMainCurrency18ScreenSymbol
                                 , @srcMainCurrency18Desc
                                 , @srcMainCurrency18CompanyRate
                                 , @srcMainCurrency18DailyRate
                                 , @srcMainCurrency18PrintSymbol
                                 , @srcMainCurrency19ScreenSymbol
                                 , @srcMainCurrency19Desc
                                 , @srcMainCurrency19CompanyRate
                                 , @srcMainCurrency19DailyRate
                                 , @srcMainCurrency19PrintSymbol
                                 , @srcMainCurrency20ScreenSymbol
                                 , @srcMainCurrency20Desc
                                 , @srcMainCurrency20CompanyRate
                                 , @srcMainCurrency20DailyRate
                                 , @srcMainCurrency20PrintSymbol
                                 , @srcMainCurrency21ScreenSymbol
                                 , @srcMainCurrency21Desc
                                 , @srcMainCurrency21CompanyRate
                                 , @srcMainCurrency21DailyRate
                                 , @srcMainCurrency21PrintSymbol
                                 , @srcMainCurrency22ScreenSymbol
                                 , @srcMainCurrency22Desc
                                 , @srcMainCurrency22CompanyRate
                                 , @srcMainCurrency22DailyRate
                                 , @srcMainCurrency22PrintSymbol
                                 , @srcMainCurrency23ScreenSymbol
                                 , @srcMainCurrency23Desc
                                 , @srcMainCurrency23CompanyRate
                                 , @srcMainCurrency23DailyRate
                                 , @srcMainCurrency23PrintSymbol
                                 , @srcMainCurrency24ScreenSymbol
                                 , @srcMainCurrency24Desc
                                 , @srcMainCurrency24CompanyRate
                                 , @srcMainCurrency24DailyRate
                                 , @srcMainCurrency24PrintSymbol
                                 , @srcMainCurrency25ScreenSymbol
                                 , @srcMainCurrency25Desc
                                 , @srcMainCurrency25CompanyRate
                                 , @srcMainCurrency25DailyRate
                                 , @srcMainCurrency25PrintSymbol
                                 , @srcMainCurrency26ScreenSymbol
                                 , @srcMainCurrency26Desc
                                 , @srcMainCurrency26CompanyRate
                                 , @srcMainCurrency26DailyRate
                                 , @srcMainCurrency26PrintSymbol
                                 , @srcMainCurrency27ScreenSymbol
                                 , @srcMainCurrency27Desc
                                 , @srcMainCurrency27CompanyRate
                                 , @srcMainCurrency27DailyRate
                                 , @srcMainCurrency27PrintSymbol
                                 , @srcMainCurrency28ScreenSymbol
                                 , @srcMainCurrency28Desc
                                 , @srcMainCurrency28CompanyRate
                                 , @srcMainCurrency28DailyRate
                                 , @srcMainCurrency28PrintSymbol
                                 , @srcMainCurrency29ScreenSymbol
                                 , @srcMainCurrency29Desc
                                 , @srcMainCurrency29CompanyRate
                                 , @srcMainCurrency29DailyRate
                                 , @srcMainCurrency29PrintSymbol
                                 , @srcMainCurrency30ScreenSymbol
                                 , @srcMainCurrency30Desc
                                 , @srcMainCurrency30CompanyRate
                                 , @srcMainCurrency30DailyRate
                                 , @srcMainCurrency30PrintSymbol
                                 , @srcExtCurrency00ScreenSymbol
                                 , @srcExtCurrency00Desc
                                 , @srcExtCurrency00CompanyRate
                                 , @srcExtCurrency00DailyRate
                                 , @srcExtCurrency00PrintSymbol
                                 , @srcExtCurrency01ScreenSymbol
                                 , @srcExtCurrency01Desc
                                 , @srcExtCurrency01CompanyRate
                                 , @srcExtCurrency01DailyRate
                                 , @srcExtCurrency01PrintSymbol
                                 , @srcExtCurrency02ScreenSymbol
                                 , @srcExtCurrency02Desc
                                 , @srcExtCurrency02CompanyRate
                                 , @srcExtCurrency02DailyRate
                                 , @srcExtCurrency02PrintSymbol
                                 , @srcExtCurrency03ScreenSymbol
                                 , @srcExtCurrency03Desc
                                 , @srcExtCurrency03CompanyRate
                                 , @srcExtCurrency03DailyRate
                                 , @srcExtCurrency03PrintSymbol
                                 , @srcExtCurrency04ScreenSymbol
                                 , @srcExtCurrency04Desc
                                 , @srcExtCurrency04CompanyRate
                                 , @srcExtCurrency04DailyRate
                                 , @srcExtCurrency04PrintSymbol
                                 , @srcExtCurrency05ScreenSymbol
                                 , @srcExtCurrency05Desc
                                 , @srcExtCurrency05CompanyRate
                                 , @srcExtCurrency05DailyRate
                                 , @srcExtCurrency05PrintSymbol
                                 , @srcExtCurrency06ScreenSymbol
                                 , @srcExtCurrency06Desc
                                 , @srcExtCurrency06CompanyRate
                                 , @srcExtCurrency06DailyRate
                                 , @srcExtCurrency06PrintSymbol
                                 , @srcExtCurrency07ScreenSymbol
                                 , @srcExtCurrency07Desc
                                 , @srcExtCurrency07CompanyRate
                                 , @srcExtCurrency07DailyRate
                                 , @srcExtCurrency07PrintSymbol
                                 , @srcExtCurrency08ScreenSymbol
                                 , @srcExtCurrency08Desc
                                 , @srcExtCurrency08CompanyRate
                                 , @srcExtCurrency08DailyRate
                                 , @srcExtCurrency08PrintSymbol
                                 , @srcExtCurrency09ScreenSymbol
                                 , @srcExtCurrency09Desc
                                 , @srcExtCurrency09CompanyRate
                                 , @srcExtCurrency09DailyRate
                                 , @srcExtCurrency09PrintSymbol
                                 , @srcExtCurrency10ScreenSymbol
                                 , @srcExtCurrency10Desc
                                 , @srcExtCurrency10CompanyRate
                                 , @srcExtCurrency10DailyRate
                                 , @srcExtCurrency10PrintSymbol
                                 , @srcExtCurrency11ScreenSymbol
                                 , @srcExtCurrency11Desc
                                 , @srcExtCurrency11CompanyRate
                                 , @srcExtCurrency11DailyRate
                                 , @srcExtCurrency11PrintSymbol
                                 , @srcExtCurrency12ScreenSymbol
                                 , @srcExtCurrency12Desc
                                 , @srcExtCurrency12CompanyRate
                                 , @srcExtCurrency12DailyRate
                                 , @srcExtCurrency12PrintSymbol
                                 , @srcExtCurrency13ScreenSymbol
                                 , @srcExtCurrency13Desc
                                 , @srcExtCurrency13CompanyRate
                                 , @srcExtCurrency13DailyRate
                                 , @srcExtCurrency13PrintSymbol
                                 , @srcExtCurrency14ScreenSymbol
                                 , @srcExtCurrency14Desc
                                 , @srcExtCurrency14CompanyRate
                                 , @srcExtCurrency14DailyRate
                                 , @srcExtCurrency14PrintSymbol
                                 , @srcExtCurrency15ScreenSymbol
                                 , @srcExtCurrency15Desc
                                 , @srcExtCurrency15CompanyRate
                                 , @srcExtCurrency15DailyRate
                                 , @srcExtCurrency15PrintSymbol
                                 , @srcExtCurrency16ScreenSymbol
                                 , @srcExtCurrency16Desc
                                 , @srcExtCurrency16CompanyRate
                                 , @srcExtCurrency16DailyRate
                                 , @srcExtCurrency16PrintSymbol
                                 , @srcExtCurrency17ScreenSymbol
                                 , @srcExtCurrency17Desc
                                 , @srcExtCurrency17CompanyRate
                                 , @srcExtCurrency17DailyRate
                                 , @srcExtCurrency17PrintSymbol
                                 , @srcExtCurrency18ScreenSymbol
                                 , @srcExtCurrency18Desc
                                 , @srcExtCurrency18CompanyRate
                                 , @srcExtCurrency18DailyRate
                                 , @srcExtCurrency18PrintSymbol
                                 , @srcExtCurrency19ScreenSymbol
                                 , @srcExtCurrency19Desc
                                 , @srcExtCurrency19CompanyRate
                                 , @srcExtCurrency19DailyRate
                                 , @srcExtCurrency19PrintSymbol
                                 , @srcExtCurrency20ScreenSymbol
                                 , @srcExtCurrency20Desc
                                 , @srcExtCurrency20CompanyRate
                                 , @srcExtCurrency20DailyRate
                                 , @srcExtCurrency20PrintSymbol
                                 , @srcExtCurrency21ScreenSymbol
                                 , @srcExtCurrency21Desc
                                 , @srcExtCurrency21CompanyRate
                                 , @srcExtCurrency21DailyRate
                                 , @srcExtCurrency21PrintSymbol
                                 , @srcExtCurrency22ScreenSymbol
                                 , @srcExtCurrency22Desc
                                 , @srcExtCurrency22CompanyRate
                                 , @srcExtCurrency22DailyRate
                                 , @srcExtCurrency22PrintSymbol
                                 , @srcExtCurrency23ScreenSymbol
                                 , @srcExtCurrency23Desc
                                 , @srcExtCurrency23CompanyRate
                                 , @srcExtCurrency23DailyRate
                                 , @srcExtCurrency23PrintSymbol
                                 , @srcExtCurrency24ScreenSymbol
                                 , @srcExtCurrency24Desc
                                 , @srcExtCurrency24CompanyRate
                                 , @srcExtCurrency24DailyRate
                                 , @srcExtCurrency24PrintSymbol
                                 , @srcExtCurrency25ScreenSymbol
                                 , @srcExtCurrency25Desc
                                 , @srcExtCurrency25CompanyRate
                                 , @srcExtCurrency25DailyRate
                                 , @srcExtCurrency25PrintSymbol
                                 , @srcExtCurrency26ScreenSymbol
                                 , @srcExtCurrency26Desc
                                 , @srcExtCurrency26CompanyRate
                                 , @srcExtCurrency26DailyRate
                                 , @srcExtCurrency26PrintSymbol
                                 , @srcExtCurrency27ScreenSymbol
                                 , @srcExtCurrency27Desc
                                 , @srcExtCurrency27CompanyRate
                                 , @srcExtCurrency27DailyRate
                                 , @srcExtCurrency27PrintSymbol
                                 , @srcExtCurrency28ScreenSymbol
                                 , @srcExtCurrency28Desc
                                 , @srcExtCurrency28CompanyRate
                                 , @srcExtCurrency28DailyRate
                                 , @srcExtCurrency28PrintSymbol
                                 , @srcExtCurrency29ScreenSymbol
                                 , @srcExtCurrency29Desc
                                 , @srcExtCurrency29CompanyRate
                                 , @srcExtCurrency29DailyRate
                                 , @srcExtCurrency29PrintSymbol
                                 , @srcExtCurrency30ScreenSymbol
                                 , @srcExtCurrency30Desc
                                 , @srcExtCurrency30CompanyRate
                                 , @srcExtCurrency30DailyRate
                                 , @srcExtCurrency30PrintSymbol
                                 , @srcNames
                                 , @srcOverheadGL
                                 , @srcOverheadSpare
                                 , @srcProductionGL
                                 , @srcProductionSpare
                                 , @srcSubContractGL
                                 , @srcSubContractSpare
                                 , @srcSpareGL1a
                                 , @srcSpareGL1b
                                 , @srcSpareGL2a
                                 , @srcSpareGL2b
                                 , @srcSpareGL3a
                                 , @srcSpareGL3b
                                 , @srcGenPPI
                                 , @srcPPIAcCode
                                 , @srcSummDesc00
                                 , @srcSummDesc01
                                 , @srcSummDesc02
                                 , @srcSummDesc03
                                 , @srcSummDesc04
                                 , @srcSummDesc05
                                 , @srcSummDesc06
                                 , @srcSummDesc07
                                 , @srcSummDesc08
                                 , @srcSummDesc09
                                 , @srcSummDesc10
                                 , @srcSummDesc11
                                 , @srcSummDesc12
                                 , @srcSummDesc13
                                 , @srcSummDesc14
                                 , @srcSummDesc15
                                 , @srcSummDesc16
                                 , @srcSummDesc17
                                 , @srcSummDesc18
                                 , @srcSummDesc19
                                 , @srcSummDesc20
                                 , @srcPeriodBud
                                 , @srcJCChkACode1
                                 , @srcJCChkACode2
                                 , @srcJCChkACode3
                                 , @srcJCChkACode4
                                 , @srcJCChkACode5
                                 , @srcJWKMthNo
                                 , @srcJTSHNoF
                                 , @srcJTSHNoT
                                 , @srcJFName
                                 , @srcJCCommitPin
                                 , @srcJAInvDate
                                 , @srcJADelayCert
                                 , @srcPrimaryForm001
                                 , @srcPrimaryForm002
                                 , @srcPrimaryForm003
                                 , @srcPrimaryForm004
                                 , @srcPrimaryForm005
                                 , @srcPrimaryForm006
                                 , @srcPrimaryForm007
                                 , @srcPrimaryForm008
                                 , @srcPrimaryForm009
                                 , @srcPrimaryForm010
                                 , @srcPrimaryForm011
                                 , @srcPrimaryForm012
                                 , @srcPrimaryForm013
                                 , @srcPrimaryForm014
                                 , @srcPrimaryForm015
                                 , @srcPrimaryForm016
                                 , @srcPrimaryForm017
                                 , @srcPrimaryForm018
                                 , @srcPrimaryForm019
                                 , @srcPrimaryForm020
                                 , @srcPrimaryForm021
                                 , @srcPrimaryForm022
                                 , @srcPrimaryForm023
                                 , @srcPrimaryForm024
                                 , @srcPrimaryForm025
                                 , @srcPrimaryForm026
                                 , @srcPrimaryForm027
                                 , @srcPrimaryForm028
                                 , @srcPrimaryForm029
                                 , @srcPrimaryForm030
                                 , @srcPrimaryForm031
                                 , @srcPrimaryForm032
                                 , @srcPrimaryForm033
                                 , @srcPrimaryForm034
                                 , @srcPrimaryForm035
                                 , @srcPrimaryForm036
                                 , @srcPrimaryForm037
                                 , @srcPrimaryForm038
                                 , @srcPrimaryForm039
                                 , @srcPrimaryForm040
                                 , @srcPrimaryForm041
                                 , @srcPrimaryForm042
                                 , @srcPrimaryForm043
                                 , @srcPrimaryForm044
                                 , @srcPrimaryForm045
                                 , @srcPrimaryForm046
                                 , @srcPrimaryForm047
                                 , @srcPrimaryForm048
                                 , @srcPrimaryForm049
                                 , @srcPrimaryForm050
                                 , @srcPrimaryForm051
                                 , @srcPrimaryForm052
                                 , @srcPrimaryForm053
                                 , @srcPrimaryForm054
                                 , @srcPrimaryForm055
                                 , @srcPrimaryForm056
                                 , @srcPrimaryForm057
                                 , @srcPrimaryForm058
                                 , @srcPrimaryForm059
                                 , @srcPrimaryForm060
                                 , @srcPrimaryForm061
                                 , @srcPrimaryForm062
                                 , @srcPrimaryForm063
                                 , @srcPrimaryForm064
                                 , @srcPrimaryForm065
                                 , @srcPrimaryForm066
                                 , @srcPrimaryForm067
                                 , @srcPrimaryForm068
                                 , @srcPrimaryForm069
                                 , @srcPrimaryForm070
                                 , @srcPrimaryForm071
                                 , @srcPrimaryForm072
                                 , @srcPrimaryForm073
                                 , @srcPrimaryForm074
                                 , @srcPrimaryForm075
                                 , @srcPrimaryForm076
                                 , @srcPrimaryForm077
                                 , @srcPrimaryForm078
                                 , @srcPrimaryForm079
                                 , @srcPrimaryForm080
                                 , @srcPrimaryForm081
                                 , @srcPrimaryForm082
                                 , @srcPrimaryForm083
                                 , @srcPrimaryForm084
                                 , @srcPrimaryForm085
                                 , @srcPrimaryForm086
                                 , @srcPrimaryForm087
                                 , @srcPrimaryForm088
                                 , @srcPrimaryForm089
                                 , @srcPrimaryForm090
                                 , @srcPrimaryForm091
                                 , @srcPrimaryForm092
                                 , @srcPrimaryForm093
                                 , @srcPrimaryForm094
                                 , @srcPrimaryForm095
                                 , @srcPrimaryForm096
                                 , @srcPrimaryForm097
                                 , @srcPrimaryForm098
                                 , @srcPrimaryForm099
                                 , @srcPrimaryForm100
                                 , @srcPrimaryForm101
                                 , @srcPrimaryForm102
                                 , @srcPrimaryForm103
                                 , @srcPrimaryForm104
                                 , @srcPrimaryForm105
                                 , @srcPrimaryForm106
                                 , @srcPrimaryForm107
                                 , @srcPrimaryForm108
                                 , @srcPrimaryForm109
                                 , @srcPrimaryForm110
                                 , @srcPrimaryForm111
                                 , @srcPrimaryForm112
                                 , @srcPrimaryForm113
                                 , @srcPrimaryForm114
                                 , @srcPrimaryForm115
                                 , @srcPrimaryForm116
                                 , @srcPrimaryForm117
                                 , @srcPrimaryForm118
                                 , @srcPrimaryForm119
                                 , @srcPrimaryForm120
                                 , @srcDescr
                                 , @srcModuleSec
                                 , @srcGCR_triRates
                                 , @srcGCR_triEuro
                                 , @srcGCR_triInvert
                                 , @srcGCR_triFloat
                                 , @srcVEDIMethod
                                 , @srcVVanMode
                                 , @srcVEDIFACT
                                 , @srcVVANCEId
                                 , @srcVVANUId
                                 , @srcVUseCRLF
                                 , @srcVTestMode
                                 , @srcVDirPAth
                                 , @srcVCompress
                                 , @srcVCEEmail
                                 , @srcVUEmail
                                 , @srcVEPriority
                                 , @srcVESubject
                                 , @srcVSendEmail
                                 , @srcVIEECSLP
                                 , @srcEmName
                                 , @srcEmAddress
                                 , @srcEmSMTP
                                 , @srcEmPriority
                                 , @srcEmUseMAPI
                                 , @srcFxUseMAPI
                                 , @srcFaxPrnN
                                 , @srcEmailPrnN
                                 , @srcFxName
                                 , @srcFxPhone
                                 , @srcEmAttchMode
                                 , @srcFaxDLLPath
                                 , @srcSpare
                                 , @srcFCaptions
                                 , @srcFHide
                                 , @srcCISConstructCode
                                 , @srcCISConstructDesc
                                 , @srcCISConstructRate
                                 , @srcCISConstructGLCode
                                 , @srcCISConstructDepartment
                                 , @srcCISConstructCostCentre
                                 , @srcCISConstructSpare
                                 , @srcCISTechnicalCode
                                 , @srcCISTechnicalDesc
                                 , @srcCISTechnicalRate
                                 , @srcCISTechnicalGLCode
                                 , @srcCISTechnicalDepartment
                                 , @srcCISTechnicalCostCentre
                                 , @srcCISTechnicalSpare
                                 , @srcCISRate1Code
                                 , @srcCISRate1Desc
                                 , @srcCISRate1Rate
                                 , @srcCISRate1GLCode
                                 , @srcCISRate1Department
                                 , @srcCISRate1CostCentre
                                 , @srcCISRate1Spare
                                 , @srcCISRate2Code
                                 , @srcCISRate2Desc
                                 , @srcCISRate2Rate
                                 , @srcCISRate2GLCode
                                 , @srcCISRate2Department
                                 , @srcCISRate2CostCentre
                                 , @srcCISRate2Spare
                                 , @srcCISRate3Code
                                 , @srcCISRate3Desc
                                 , @srcCISRate3Rate
                                 , @srcCISRate3GLCode
                                 , @srcCISRate3Department
                                 , @srcCISRate3CostCentre
                                 , @srcCISRate3Spare
                                 , @srcCISRate4Code
                                 , @srcCISRate4Desc
                                 , @srcCISRate4Rate
                                 , @srcCISRate4GLCode
                                 , @srcCISRate4Department
                                 , @srcCISRate4CostCentre
                                 , @srcCISRate4Spare
                                 , @srcCISRate5Code
                                 , @srcCISRate5Desc
                                 , @srcCISRate5Rate
                                 , @srcCISRate5GLCode
                                 , @srcCISRate5Department
                                 , @srcCISRate5CostCentre
                                 , @srcCISRate5Spare
                                 , @srcCISRate6Code
                                 , @srcCISRate6Desc
                                 , @srcCISRate6Rate
                                 , @srcCISRate6GLCode
                                 , @srcCISRate6Department
                                 , @srcCISRate6CostCentre
                                 , @srcCISRate6Spare
                                 , @srcCISRate7Code
                                 , @srcCISRate7Desc
                                 , @srcCISRate7Rate
                                 , @srcCISRate7GLCode
                                 , @srcCISRate7Department
                                 , @srcCISRate7CostCentre
                                 , @srcCISRate7Spare
                                 , @srcCISRate8Code
                                 , @srcCISRate8Desc
                                 , @srcCISRate8Rate
                                 , @srcCISRate8GLCode
                                 , @srcCISRate8Department
                                 , @srcCISRate8CostCentre
                                 , @srcCISRate8Spare
                                 , @srcCISRate9Code
                                 , @srcCISRate9Desc
                                 , @srcCISRate9Rate
                                 , @srcCISRate9GLCode
                                 , @srcCISRate9Department
                                 , @srcCISRate9CostCentre
                                 , @srcCISRate9Spare
                                 , @srcCISInterval
                                 , @srcCISAutoSetPr
                                 , @srcCISVATCode
                                 , @srcCISSpare3
                                 , @srcCISScheme
                                 , @srcCISReturnDate
                                 , @srcCISCurrPeriod
                                 , @srcCISLoaded
                                 , @srcCISTaxRef
                                 , @srcCISAggMode
                                 , @srcCISSortMode
                                 , @srcCISVFolio
                                 , @srcCISVouchers
                                 , @srcIVANMode
                                 , @srcIVANIRId
                                 , @srcIVANUId
                                 , @srcIVANPw
                                 , @srcIIREDIRef
                                 , @srcIUseCRLF
                                 , @srcITestMode
                                 , @srcIDirPath
                                 , @srcIEDIMethod
                                 , @srcISendEmail
                                 , @srcIEPriority
                                 , @srcJCertNo
                                 , @srcJCertExpiry
                                 , @srcJCISType
                                 , @srcCISCNINO
                                 , @srcCISCUTR
                                 , @srcCISACCONo
                                 , @srcIGWIRId
                                 , @srcIGWUId
                                 , @srcIGWTO
                                 , @srcIGWIRef
                                 , @srcIXMLDirPath
                                 , @srcIXTestMode
                                 , @srcIXConfEmp
                                 , @srcIXVerSub
                                 , @srcIXNoPay
                                 , @srcIGWTR
                                 , @srcIGSubType
  END

  CLOSE srcExchqSS
  DEALLOCATE srcExchqSS
