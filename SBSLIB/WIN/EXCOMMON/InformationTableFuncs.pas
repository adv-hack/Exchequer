Unit InformationTableFuncs;

Interface

Uses Dialogs, SysUtils, StrUtils, VarConst, LicRec;

// Updates the ExchequerConfigurationInformation Module Release Code entries using
// the Global SyssMod^.ModuleRel record structure and saves any differences.
Procedure CheckModuleReleaseCodes (Const ReportError : Boolean = False);

{$IFDEF ENTER1}
  // Updates the ExchequerConfigurationInformation Stock and SPOP Code entries using
  // the compiler defs - only suitable for use within Enter1
  Procedure CheckExchequerModuleLevel (Const ReportError : Boolean = False);
{$ENDIF ENTER1}

// Called from the Installer and MCM to updates the ExchequerConfigurationInformation entries
// that require the Exchequer Licence file
Procedure CheckLicenceOnlyComponents (Const Licence : EntLicenceRecType; Const ReportError : Boolean = False);

Implementation

Uses oInformationTable, HelpSupU;

//=========================================================================

// Updates the ExchequerConfigurationInformation Module Release Code entries using
// the Global SyssMod^.ModuleRel record structure and saves any differences.
Procedure CheckModuleReleaseCodes (Const ReportError : Boolean = False);
Var
  Res : Integer;
Begin // CheckModuleReleaseCodes
  With ExchequerConfigurationInformation Do
  Begin
    //
    // Notes:
    //   1) ModRelMode (R&D\HelpSupU.pas) returns 1 for Full Release Codes and 2 for 30-day Release Codes, 0 for unlicensed
    //   2) Constants for the module release code indexes have been added into VarRec.pas to avoid magic numbers
    //

    eciTelesales := (ModRelMode(mrcTeleSales) > 0);
    // Note: Telesales overrides Account Stock Analysis
    eciAccountStockAnalysis := eciTelesales Or (ModRelMode(mrcAccountStockAnalysis) > 0);
    eciImporter := (ModRelMode(mrcImporter) > 0);
    eciJobCosting := (ModRelMode(mrcJobCosting) > 0);
    eciReportWriter := (ModRelMode(mrcReportWriter) > 0);
    eciToolkitRuntime := (ModRelMode(mrcToolkitRuntime) > 0);
    ecieBusiness := (ModRelMode(mrcEBusiness) > 0);
    eciPaperlessModule := (ModRelMode(mrcPaperless) > 0);
    eciOLESaveFunctions := (ModRelMode(mrcOLESave) > 0);
    eciCommitmentAccounting := (ModRelMode(mrcCommitmentAccounting) > 0);
    eciTradeCounter := (ModRelMode(mrcTradeCounter) > 0);
    eciStandardWorksOrderProcessing := (ModRelMode(mrcStdWOP) > 0);
    eciProfessionalWorksOrderProcessing := (ModRelMode(mrcProWOP) > 0);
    eciSentimail := (ModRelMode(mrcSentimail) > 0);
    eciEnhancedSecurity := (ModRelMode(mrcEnhancedSecurity) > 0);
    eciJobCostingCISRCT := (ModRelMode(mrcCISRCT) > 0);
    eciJobCostingAppsVals := (ModRelMode(mrcAppsVals) > 0);
    eciFullStock := (ModRelMode(mrcFullStock) > 0);
    eciVisualReportWriter := (ModRelMode(mrcVisualReportWriter) > 0);
    eciGoodsReturns := (ModRelMode(mrcGoodsReturns) > 0);
    ecieBanking := (ModRelMode(mrcEBanking) > 0);
    eciOutlookDynamicDashboard := (ModRelMode(mrcOutlookDD) > 0);

// The following are not Module Release Codes and cannot be set here:-
//
//    Property eciODBC : Boolean                        // Requires licence file
//    Property eciExchequerEdition : ShortString        // Requires licence file
//    Property eciStock : Boolean                       // Requires licence file or Enter1 only compiler defs
//    Property eciSPOP : Boolean                        // Requires licence file or Enter1 only compiler defs
//    Property eciCurrencyEdition : ShortString         // Requires licence file or Enter1 only compiler defs

    Res := Save;
    If ReportError And (Res <> 0) Then
      MessageDlg ('CheckModuleReleaseCodes: The following error occurred syncing the Module Release Codes - ' + IntToStr(Res) + ' - ' + LastErrorString,
                  mtError, [mbOK], 0);
  End; // With ExchequerConfigurationInformation
End; // CheckModuleReleaseCodes

//-------------------------------------------------------------------------

{$IFDEF ENTER1}
// Updates the ExchequerConfigurationInformation Stock and SPOP Code entries using
// the compiler defs - only suitable for use within Enter1
Procedure CheckExchequerModuleLevel (Const ReportError : Boolean = False);
Var
  Res : Integer;
Begin // CheckExchequerModuleLevel
  With ExchequerConfigurationInformation Do
  Begin
    eciStock := {$IFDEF STK}True{$ELSE}False{$ENDIF};
    eciSPOP := {$IFDEF SOP}True{$ELSE}False{$ENDIF};

    {$IFDEF MC_ON}
      eciCurrencyEdition := IfThen (EuroVers, CurrencyEditions[ccyEdEuro], CurrencyEditions[ccyEdGlobal]);
    {$ELSE}
      eciCurrencyEdition := CurrencyEditions[ccyEdProfessional];
    {$ENDIF MC_ON}

    Res := Save;
    If ReportError And (Res <> 0) Then
      MessageDlg ('CheckExchequerModuleLevel: The following error occurred syncing the Exchequer Modules - ' + IntToStr(Res) + ' - ' + LastErrorString,
                  mtError, [mbOK], 0);
  End; // With ExchequerConfigurationInformation
End; // CheckExchequerModuleLevel
{$ENDIF ENTER1}

//-------------------------------------------------------------------------

// Called from the Installer and MCM to updates the ExchequerConfigurationInformation entries
// that require the Exchequer Licence file
Procedure CheckLicenceOnlyComponents (Const Licence : EntLicenceRecType; Const ReportError : Boolean = False);
Var
  Res : Integer;
Begin // CheckLicenceOnlyComponents
  // Update the Information Table from the Exchequer Licence File
  With ExchequerConfigurationInformation Do
  Begin
    eciODBC := (Licence.licModules[modODBC] > 0);
    eciExchequerEdition := IfThen(Licence.licExchequerEdition = eeStandard, 'Standard', 'Small Business');
    eciStock := (Licence.licEntModVer > 0);
    eciSPOP := (Licence.licEntModVer = 2);
    Case Licence.licEntCVer Of
      0 : eciCurrencyEdition := CurrencyEditions[ccyEdProfessional];
      1 : eciCurrencyEdition := CurrencyEditions[ccyEdEuro];
      2 : eciCurrencyEdition := CurrencyEditions[ccyEdGlobal];
    End; // Case LicRec.licEntCVer

    Res := Save;
    If ReportError And (Res <> 0) Then
      MessageDlg ('CheckLicenceOnlyComponents: The following error occurred syncing the Exchequer Modules - ' + IntToStr(Res) + ' - ' + LastErrorString,
                  mtError, [mbOK], 0);
  End; // With ExchequerConfigurationInformation
End; // CheckLicenceOnlyComponents

//=========================================================================

End.
