unit oSurveyDataset;

interface

Uses Classes, Forms, SysUtils, oSurveyDataFile;


Type
  TDataFileCheckMode = (
                         dfcmSystem,
                         dfcmCompany,
                         dfcmHistoryPurge,
                         dfcmEBusinessSystem,  // e-Business files in main directory
                         dfcmEBusinessCompany, // e-Business files in company directories
                         dfcmTradeSystem,      // Trade Counter files in main directory
                         dfcmTradeCompany,     // Trade Counter files in company directories
                         dfcmFaxing,
                         dfcmImporter,
                         dfcmJobCard,         // JobCard data files
                         dfcmRepWrt,
                         dfcmSchedulerSystem,
                         dfcmSchedulerCompany,
                         dfcmSentimailSystem,
                         dfcmSentimailCompany,
                         dfcmVRW,
                         dfcmAuthorisePlugIn,
                         dfcmCCDeptPlugIn,
                         dfcmContactsPlugIn,
                         dfcmPromptPayPlugIn,
                         dfcmSalesCommPlugIn,
                         dfcmUserFieldsPlugIn,
                         dfcmVATPeriodPlugIn
                        );

  TDataFileInfo = Record
    Filename : ShortString;
    CheckMode : TDataFileCheckMode;
  End; // TDataFileInfo

Const
  ExchequerDataFiles : Array [1..64] Of TDataFileInfo =
                         (
                           (Filename:'CCDept.Dat'; CheckMode:dfcmCCDeptPlugIn),
                           (Filename:'Company.Dat'; CheckMode:dfcmSystem),
                           (Filename:'Contact.Dat'; CheckMode:dfcmContactsPlugIn),
                           (Filename:'Ebus.Dat'; CheckMode:dfcmEBusinessSystem),
                           (Filename:'ExchqSS.Dat'; CheckMode:dfcmCompany),
                           (Filename:'ExchqNum.Dat'; CheckMode:dfcmCompany),
                           (Filename:'Groups.Dat'; CheckMode:dfcmSystem),
                           (Filename:'GroupUsr.Dat'; CheckMode:dfcmSystem),
                           (Filename:'GroupCmp.Dat'; CheckMode:dfcmSystem),
                           (Filename:'SchedCfg.Dat'; CheckMode:dfcmSchedulerSystem),
                           (Filename:'SentSys.Dat'; CheckMode:dfcmSentimailSystem),
                           (Filename:'Tools.Dat'; CheckMode:dfcmSystem),
                           (Filename:'UDEntity.Dat'; CheckMode:dfcmUserFieldsPlugIn),
                           (Filename:'UDField.Dat'; CheckMode:dfcmUserFieldsPlugIn),
                           (Filename:'UDItem.Dat'; CheckMode:dfcmUserFieldsPlugIn),
                           (Filename:'Cust\CustSupp.Dat'; CheckMode:dfcmCompany),
                           (Filename:'Ebus\EbusDetl.Dat'; CheckMode:dfcmEBusinessCompany),
                           (Filename:'Ebus\EbusDoc.Dat'; CheckMode:dfcmEBusinessCompany),
                           (Filename:'Ebus\EbusLkup.Dat'; CheckMode:dfcmEBusinessCompany),
                           (Filename:'Ebus\EbusNote.Dat'; CheckMode:dfcmEBusinessCompany),
                           (Filename:'FaxSrv\Faxes.Dat'; CheckMode:dfcmFaxing),
                           (Filename:'Forms\Paprsize.Dat'; CheckMode:dfcmCompany),
                           (Filename:'JC\EmpPay.Dat'; CheckMode:dfcmJobCard),
                           (Filename:'JC\MCPay.Dat'; CheckMode:dfcmJobCard),
                           (Filename:'Jobs\JobCtrl.Dat'; CheckMode:dfcmCompany),
                           (Filename:'Jobs\JobDet.Dat'; CheckMode:dfcmCompany),
                           (Filename:'Jobs\JobHead.Dat'; CheckMode:dfcmCompany),
                           (Filename:'Jobs\JobMisc.Dat'; CheckMode:dfcmCompany),
                           (Filename:'Misc\ExchqChk.Dat'; CheckMode:dfcmCompany),
                           (Filename:'Misc\ExStkChk.Dat'; CheckMode:dfcmCompany),
                           (Filename:'Misc\ImportJob.Dat'; CheckMode:dfcmImporter),
                           (Filename:'Misc\Settings.Dat'; CheckMode:dfcmCompany),
                           (Filename:'PromPay\PPCust.Dat'; CheckMode:dfcmPromptPayPlugIn),
                           (Filename:'PromPay\PPDebt.Dat'; CheckMode:dfcmPromptPayPlugIn),
                           (Filename:'PromPay\PPSetup.Dat'; CheckMode:dfcmPromptPayPlugIn),
                           (Filename:'Reports\Reports.Dat'; CheckMode:dfcmRepWrt),
                           (Filename:'Reports\VRWSec.Dat'; CheckMode:dfcmVRW),
                           (Filename:'Reports\VRWTree.Dat'; CheckMode:dfcmVRW),
                           (Filename:'SalesCom\Commssn.Dat'; CheckMode:dfcmSalesCommPlugIn),
                           (Filename:'SalesCom\SaleCode.Dat'; CheckMode:dfcmSalesCommPlugIn),
                           (Filename:'SalesCom\SCType.Dat'; CheckMode:dfcmSalesCommPlugIn),
                           (Filename:'Schedule\Schedule.Dat'; CheckMode:dfcmSchedulerCompany),
                           (Filename:'Smail\Sent.Dat'; CheckMode:dfcmSentimailCompany),
                           (Filename:'Smail\SentLine.Dat'; CheckMode:dfcmSentimailCompany),
                           (Filename:'Stock\MLocStk.Dat'; CheckMode:dfcmCompany),
                           (Filename:'Stock\Stock.Dat'; CheckMode:dfcmCompany),
                           (Filename:'Trade\LBin.Dat'; CheckMode:dfcmTradeCompany),
                           (Filename:'Trade\LHeader.Dat'; CheckMode:dfcmTradeCompany),
                           (Filename:'Trade\LLines.Dat'; CheckMode:dfcmTradeCompany),
                           (Filename:'Trade\LSerial.Dat'; CheckMode:dfcmTradeCompany),
                           (Filename:'Trade\TillName.Dat'; CheckMode:dfcmTradeSystem),
                           (Filename:'Trans\Details.Dat'; CheckMode:dfcmCompany),
                           (Filename:'Trans\Document.Dat'; CheckMode:dfcmCompany),
                           (Filename:'Trans\History.Dat'; CheckMode:dfcmCompany),
                           (Filename:'Trans\HistPrge.Dat'; CheckMode:dfcmHistoryPurge),
                           (Filename:'Trans\Nominal.Dat'; CheckMode:dfcmCompany),
                           (Filename:'Trans\NomView.Dat'; CheckMode:dfcmCompany),
                           (Filename:'VatPer\VATOpt.Dat'; CheckMode:dfcmVATPeriodPlugIn),
                           (Filename:'VatPer\VATPrd.Dat'; CheckMode:dfcmVATPeriodPlugIn),
                           (Filename:'Workflow\PAAuth.Dat'; CheckMode:dfcmAuthorisePlugIn),
                           (Filename:'Workflow\PAComp.Dat'; CheckMode:dfcmAuthorisePlugIn),
                           (Filename:'Workflow\PAEAR.Dat'; CheckMode:dfcmAuthorisePlugIn),
                           (Filename:'Workflow\PAGlobal.Dat'; CheckMode:dfcmAuthorisePlugIn),
                           (Filename:'Workflow\PAUser.Dat'; CheckMode:dfcmAuthorisePlugIn)
                        );

Type
  TExchequerDataSet = Class(TObject)
  Private
    FCode         : ShortString;
    FCompanyName  : ShortString;
    FPath         : ShortString;
    FDataFiles    : TList;

    Function GetCompFileCount : SmallInt;
    Function GetCompFiles (Index : SmallInt) : TExchequerDataFile;
    Function GetTotalFileSize : Int64;
  Protected
  Public
    Property compCode : ShortString Read FCode;
    Property compName : ShortString Read FCompanyName;
    Property compPath : ShortString Read FPath;

    Property CompFileCount : SmallInt Read GetCompFileCount;
    Property CompFiles [Index : SmallInt] : TExchequerDataFile Read GetCompFiles;

    Property TotalFileSize : Int64 Read GetTotalFileSize;

    Constructor Create (Const mcmCode, mcmCompany, mcmPath : ShortString);
    Destructor Destroy; Override;

    Procedure CheckBtrFiles;
  End; { TExchequerDataSet }


implementation

Uses oSurveyStore;

//=========================================================================

Constructor TExchequerDataSet.Create (Const mcmCode, mcmCompany, mcmPath : ShortString);
Begin { Create }
  Inherited Create;

  FDataFiles := TList.Create;

  // Copy details from MCM into local properties
  FCode := UpperCase(Trim(mcmCode));
  FCompanyName := Trim(mcmCompany);
  FPath := IncludeTrailingPathDelimiter(Trim(mcmPath));

  // Check Btrieve File versions
  CheckBtrFiles;
End; { Create }

//---------------------------------------

Destructor TExchequerDataSet.Destroy;
Var
  oDataFile : TExchequerDataFile;
Begin { Destroy }
  While (FDataFiles.Count > 0) Do
  Begin
    oDataFile := FDataFiles.Items[0];
    oDataFile.Free;

    FDataFiles.Delete(0);
  End; // While (FDataFiles.Count > 0)

  FreeAndNIL(FDataFiles);

  inherited;
End;

//--------------------------------------------------------------------------

Function TExchequerDataSet.GetCompFileCount : SmallInt;
Begin // GetCompFileCount
  Result := FDataFiles.Count;
End; // GetCompFileCount

//------------------------------

Function TExchequerDataSet.GetCompFiles (Index : SmallInt) : TExchequerDataFile;
Begin // GetCompFiles
  If (Index >= 0) And (Index < FDataFiles.Count) Then
    Result := TExchequerDataFile(FDataFiles.Items[Index])
  Else
    Raise Exception.Create ('TExchequerDataSet.GetCompFiles: Invalid Index');
End; // GetCompFiles

//--------------------------------------------------------------------------

Function TExchequerDataSet.GetTotalFileSize : Int64;
Var
  I : SmallInt;
Begin // GetTotalFileSize
  Result := 0;
  For I := 0 To (FDataFiles.Count - 1) Do
  Begin
    Result := Result + TExchequerDataFile(FDataFiles.Items[I]).dfFileSize;
  End; // For I
End; // GetTotalFileSize

//--------------------------------------------------------------------------

// Analyses the Company Data Path to determine the status
Procedure TExchequerDataSet.CheckBtrFiles;
Var
  sSystemDir : ShortString;
  bIsSystemDir, PerformCheck : Boolean;
  I : SmallInt;
Begin { CheckBtrFiles }
  sSystemDir := ExtractFilePath(Application.ExeName);

  For I := Low(ExchequerDataFiles) To High(ExchequerDataFiles) Do
  Begin
    // If the file is missing check to see whether it should be there
    If (Not FileExists(FPath + ExchequerDataFiles[I].Filename)) Then
    Begin
      bIsSystemDir := FileExists(FPath + 'Entrprse.Dat') Or FileExists(FPath + 'Company.Dat') Or (FileExists(FPath + 'Enter1.Exe'));

      Case ExchequerDataFiles[I].CheckMode Of
        // Core Data files in main company directory only
        dfcmSystem            : PerformCheck := bIsSystemDir;
        // Core Data files in all companies
        dfcmCompany           : PerformCheck := True;
        // Purged History file - only present if a purge has been done
        dfcmHistoryPurge      : PerformCheck := False;
        // e-Business data files in main directory - check for presence of e-Business Admin
        dfcmEBusinessSystem   : PerformCheck := bIsSystemDir And FileExists(sSystemDir + 'EBUSADMN.EXE');
        // e-Business data files in company directories - check for presence of e-Business Admin
        dfcmEBusinessCompany  : PerformCheck := FileExists(sSystemDir + 'EBUSADMN.EXE');
        // Exchequer Fax Server
        dfcmFaxing            : PerformCheck := bIsSystemDir And DirectoryExists(sSystemDir + 'FaxSrv');
        // Importer Data Files
        dfcmImporter          : PerformCheck := bIsSystemDir And FileExists(sSystemDir + 'Import\Importer.Exe');
        // JobCard data files
        dfcmJobCard           : PerformCheck := bIsSystemDir And FileExists(sSystemDir + 'JobCard.Exe');
        // Windows Report Writer data files
        dfcmRepWrt            : PerformCheck := FileExists(sSystemDir + 'EnRepWrt.Exe');
        // Scheduler files in main directory
        dfcmSchedulerSystem   : PerformCheck := bIsSystemDir And FileExists(sSystemDir + 'SchedEng.Exe');
        // Scheduler files in company directories
        dfcmSchedulerCompany  : PerformCheck := FileExists(sSystemDir + 'SchedEng.Exe');
        // Sentimail data files in main company directory
        dfcmSentimailSystem   : PerformCheck := bIsSystemDir And FileExists(sSystemDir + 'SentAdmn.Exe');
        // Sentimail data files in company directory
        dfcmSentimailCompany  : PerformCheck := FileExists(sSystemDir + 'SentAdmn.Exe');
        // Trade Counter files in main directory
        dfcmTradeSystem       : PerformCheck := bIsSystemDir And DirectoryExists(sSystemDir + 'Trade');
        // Trade Counter files in company directories
        dfcmTradeCompany      : PerformCheck := DirectoryExists(sSystemDir + 'Trade');
        // Visual Report Writer data files
        dfcmVRW               : PerformCheck := FileExists(sSystemDir + 'EntRW.Exe');

        // Misc Plug-Ins
        dfcmAuthorisePlugIn   : PerformCheck := bIsSystemDir And FileExists(sSystemDir + 'EXPAADMN.exe');
        dfcmCCDeptPlugIn      : PerformCheck := FileExists(sSystemDir + 'CCDEPT.exe');
        dfcmContactsPlugIn    : PerformCheck := bIsSystemDir And FileExists(sSystemDir + 'CONTACTS.dll');
        dfcmPromptPayPlugIn   : PerformCheck := FileExists(sSystemDir + 'PPayAdm.exe');
        dfcmSalesCommPlugIn   : PerformCheck := FileExists(sSystemDir + 'SCOMADM.exe');
        dfcmUserFieldsPlugIn  : PerformCheck := FileExists(sSystemDir + 'USERHADM.EXE');
        dfcmVATPeriodPlugIn   : PerformCheck := FileExists(sSystemDir + 'VATPRD.dll');
      Else
        PerformCheck := True;
      End // Case ExchequerDataFiles[I].CheckMode
    End // If (Not FileExists(FCompPath + ExchequerDataFiles[I].Filename)
    Else
      // Always check the file if it is present
      PerformCheck := True;

    If PerformCheck Then
      FDataFiles.Add(TExchequerDataFile.Create(Self, ExchequerDataFiles[I].Filename));
  End; // For I
End; { CheckBtrFiles }

//--------------------------------------------------------------------------

end.

