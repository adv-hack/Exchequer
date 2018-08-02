unit oPrntJob;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     RpDevice,
     oFormLst,                 // TEFPrintFormsList object
     oPJEmail,                 // TEFPrintJobEmailInfo object
     oPJFile,                  // TEFPrintJobFileInfo object
     oPJFax,                   // TEFPrintJobFaxInfo object
     oImpDefs,                 // TEFImportDefaults object
     EnterpriseForms_TLB;      // Forms Toolkit Type Library

type
  TEFPrintJob = class(TAutoIntfObject, IEFPrintJob)
  private
    FPrintToolkit   : TObject;

    // FormMode of Batch for validation purposes
    FPrintMode      : TEFPrintFormMode;

    // FormsList Sub-object
    FFormsListO     : TEFPrintFormsList;
    FFormsListI     : IEFPrintFormsList;

    // EmailInfo sub-object
    FEmailInfoO     : TEFPrintJobEmailInfo;
    FEmailInfoI     : IEFPrintJobEmailInfo;

    // FaxInfo sub-object
    FFaxInfoO       : TEFPrintJobFaxInfo;
    FFaxInfoI       : IEFPrintJobFaxInfo;

    // FileInfo sub-object
    FFileInfoO      : TEFPrintJobFileInfo;
    FFileInfoI      : IEFPrintJobFileInfo;
  protected
    // IEFPrintJob
    function Get_pjForms: IEFPrintFormsList; safecall;
    function Get_pjPrinterIndex: Integer; safecall;
    procedure Set_pjPrinterIndex(Value: Integer); safecall;
    function Get_pjPaperIndex: Integer; safecall;
    procedure Set_pjPaperIndex(Value: Integer); safecall;
    function Get_pjBinIndex: Integer; safecall;
    procedure Set_pjBinIndex(Value: Integer); safecall;
    function Get_pjCopies: Integer; safecall;
    procedure Set_pjCopies(Value: Integer); safecall;
    function Get_pjTestMode: WordBool; safecall;
    procedure Set_pjTestMode(Value: WordBool); safecall;
    function Get_pjLabel1: Integer; safecall;
    procedure Set_pjLabel1(Value: Integer); safecall;
    function Get_pjUserId: WideString; safecall;
    procedure Set_pjUserId(const Value: WideString); safecall;
    function Get_pjEmailInfo: IEFPrintJobEmailInfo; safecall;
    function Get_pjFaxInfo: IEFPrintJobFaxInfo; safecall;
    function Get_pjFileInfo: IEFPrintJobFileInfo; safecall;
    function Get_pjTitle: WideString; safecall;
    procedure Set_pjTitle(const Value: WideString); safecall;
    function Get_pjMode: TEFPrintFormMode; safecall;
    procedure Initialise(FormMode: TEFPrintFormMode); safecall;
    function PrinterSetupDialog: WordBool; safecall;
    function PrintToPrinter: Integer; safecall;
    function PrintToTempFile(Destination: TEFTempFileDestination): IEFPrintTempFile; safecall;
    function ImportDefaults: IEFImportDefaults; safecall;

    // Local methods
    function CheckJobInfo (Const Destination : TEFTempFileDestination) : Integer;
    function PrintBatch (Const Destination : TEFTempFileDestination;
                         Const WantPreview : Boolean;
                         Const pData       : Pointer) : Integer;
  public
    PrintJobSetupInfo : TSBSPrintSetupInfo;
    prnSupportsBins   : Boolean;
    prnSupportsPapers : Boolean;

    Property FDefPrintMode : TEFPrintFormMode Read FPrintMode;
    Property FormsListI : IEFPrintFormsList Read Get_pjForms;
    Property FormsListO : TEFPrintFormsList Read FFormsListO;

    Constructor Create (Const PrintToolkit : TObject);
    Destructor Destroy; override;

    Function IsLabel : Boolean;
  End; { TEFPrintJob }

  //-----------------------------

  // Checks the Paperless Module licence to determine if the user is licenced
  // to use those sections classified as parts of the Paperless Module
  Procedure CheckPaperlessLicence;

implementation

uses ComServ,
     oMain,            // Main Form Toolkit Object
     MiscFunc,         // Miscellaneous Functions / Types / Constants for the Form TK
     GlobVar,          // Exchequer Global Types/Const/Var
     VarConst,         // Exchequer Global Types/Const/Var
     VarRec2U,         // Additional Exchequer Global Types/Const/Var
     BtrvU2,           // Btrieve routines
     GlobType,         // Form Designer Types
     PrintU,           // Form Designer Batch Printing Routines
     BTKeys1U,         // Exchequer Key building routines
     ETStrU,           // Exchequer String functions
     ETMiscU,          // Exchequer Misc functions
     PrntForm,         // Form Designer Form Printing Routines
     Register,        // FormDes routines for accessing EFD Files
     oTmpFile,         // Contains the TEFPrintTempFile class which implements IEFPrintTempFile
     SQLUtils,
     // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
     MadExcept,
     ADOConnect,       // Global ADO Conenction String
     LogUtil;


//-----------------------------------------------------------------------------

// Checks the Paperless Module licence to determine if the user is licenced
// to use those sections classified as parts of the Paperless Module
Procedure CheckPaperlessLicence;
Begin { CheckPaperlessLicence }
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    If (Not eCommsModule) Then
      Raise ELicenceViolation.Create ('The part of the Printing Toolkit is only available to licenced users of the Paperless Module');
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
End; { CheckPaperlessLicence }

//-----------------------------------------------------------------------------

Constructor TEFPrintJob.Create (Const PrintToolkit : TObject);
Begin { Create }
  OutputDebug('TEFPrintJob.Create Start');
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    Inherited Create (ComServer.TypeLib, IEFPrintJob);
//ShowMessage ('TEFPrintJob.Create.1');

    // MH 31/01/2014 ABSEXCH-14974: Added support for Ledger Multi-Contacts in SQL Edition
    If SQLUtils.UsingSQL And (Not Assigned(GlobalADOConnection)) Then
    begin
      InitialiseGlobalADOConnection (SetDrive);
      OutputDebug('TEFPrintJob.Create GlobalADOConnection initialised');
    end;


    FPrintToolkit := PrintToolkit;

    // Create and initialise the Forms List sub-object
    FFormsListO := TEFPrintFormsList.Create(Self);
    FFormsListI := FFormsListO;
    OutputDebug('TEFPrintJob.Create FormsList created');
//ShowMessage ('TEFPrintJob.Create.2');

    // Create and initialise the Email Info sub-object
    FEmailInfoO := TEFPrintJobEmailInfo.Create(Self);
    FEmailInfoI := FEmailInfoO;
    OutputDebug('TEFPrintJob.Create EmailInfo object created');

//ShowMessage ('TEFPrintJob.Create.3');
    // Create and initialise the Fax Info sub-object
    FFaxInfoO := TEFPrintJobFaxInfo.Create(Self);
    FFaxInfoI := FFaxInfoO;
    OutputDebug('TEFPrintJob.Create FaxInfo object created');

//ShowMessage ('TEFPrintJob.Create.4');
    // Create and initialise the File Info sub-object
    FFileInfoO := TEFPrintJobFileInfo.Create(Self);
    FFileInfoI := FFileInfoO;
    OutputDebug('TEFPrintJob.Create FileInfo object created');

//ShowMessage ('TEFPrintJob.Create.5');

    // Initialise the Print Job settings
    Initialise (GlobType.fmAllDocs);
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
  OutputDebug ('TEFPrintJob.Create End');
End; { Create }

//----------------------------------------

Destructor TEFPrintJob.Destroy;
Begin { Destroy }
  // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Moved from TEFPrintJob.Destroy to TEFPrintingToolkit.Destroy
//  // MH 31/01/2014 ABSEXCH-14974: Added support for Ledger Multi-Contacts in SQL Edition
//  If SQLUtils.UsingSQL Then
//    TerminateGlobalADOConnection;

  FPrintToolkit := Nil;

  // Set the Forms List sub-object to NIL to destroy it
  FFormsListO := NIL;
  FFormsListI := NIL;

  // Set the Email Info sub-object to NIL to destroy it
  FEmailInfoO := NIL;
  FEmailInfoI := NIL;

  // Set the Fax Info sub-object to NIL to destroy it
  FFaxInfoO := NIL;
  FFaxInfoI := NIL;

  // Set the File Info sub-object to NIL to destroy it
  FFileInfoO := NIL;
  FFileInfoI := NIL;

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

procedure TEFPrintJob.Initialise(FormMode: TEFPrintFormMode);
begin
  // Store FormMode for validation purposes
  FPrintMode := FormMode;

  // Setup default printer and initialise PrintJobSetupInfo with default printer settings
  RpDev.DeviceIndex := -1;
  Set_pjPrinterIndex(RpDev.DeviceIndex + 1);

  // Set default settings
  FillChar (PrintJobSetupInfo, SizeOf(PrintJobSetupInfo), #0);
  With PrintJobSetupInfo Do Begin
    // Copies of form to print
    NoCopies      := 1;

    // Label number of first available label
    pbLabel1      := 1;

    // Print Job title shown in printers list and used by Exchequer Faxing
    feJobtitle    := 'Exchequer Print Job';
  End; { With }

  // Clear out any pre-existing print jobs -----------------------
  If Assigned(FFormsListO) Then
    FFormsListO.Initialise;

  // Initialise local settings within sub-objects
  FEmailInfoO.Initialise;
  FFaxInfoO.Initialise;
  FFileInfoO.Initialise;
end;

//-----------------------------------------------------------------------------

// Checks the Print Job information prior to starting the job
function TEFPrintJob.CheckJobInfo (Const Destination : TEFTempFileDestination) : Integer;
Var
  KeyS    : Str255;
  lStatus : SmallInt;
Begin { CheckJobInfo }
  Result := 0;

  // Copies
  If (PrintJobSetupInfo.NoCopies <= 0) Or (PrintJobSetupInfo.NoCopies > 255) Then
    // Copies set to an invalid value
    Result := 2001;

    // Label1
  If (Result = 0) And IsLabel And ((PrintJobSetupInfo.pbLabel1 <= 0) Or (PrintJobSetupInfo.pbLabel1 > 255)) Then
    // Label1 set to an invalid value
    Result := 2002;

  // UserId
  If (Result = 0) And (Trim(PrintJobSetupInfo.feUserId) <> '') Then Begin
    // User Id set - validate it
    KeyS := PassUCode + C0 + LJVar(PrintJobSetupInfo.feUserId, 10);
    lStatus := Find_Rec (B_GetEq, F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK, KeyS);
    If (LStatus <> 0) Then
      // Invalid User Id
      Result := 2003;
  End; { If (Result = 0) And (Trim(PrintJobSetupInfo.feUserId) <> '') }

  // Email Print Jobs
  If (Result = 0) And (Destination = tfdEmail) Then
    Result := FEmailInfoO.CheckJobInfo;

  // Fax Print Jobs
  If (Result = 0) And (Destination = tfdFax) Then
    Result := FFaxInfoO.CheckJobInfo;
End; { CheckJobInfo }

//-----------------------------------------------------------------------------

//    0   AOK
// 1000   Unknown Exception - Check LastErrorString
// 1001   Unknown Error initialising the Print Batch
// 1002   Unknown Error adding a form into the Print Batch
// 1003   Unknown Error printing the Print Batch
//
// 1100   No forms specified in pfForms
// 2000+  See CheckJobInfo
function TEFPrintJob.PrintBatch (Const Destination : TEFTempFileDestination;
                                 Const WantPreview : Boolean;
                                 Const pData       : Pointer) : Integer;
Var
  PrBatch : PrintBatchRecType;
  I       : SmallInt;
begin
  LastErDesc := '';

  // Checks the Print Job information prior to starting the job
  Result := CheckJobInfo (Destination);

  If (Result = 0) Then
    Try
      // Perform any required validation

      // Clear out any pre-existing details
      If PrintBatch_ClearBatch Then Begin
        If (FFormsListO.Count > 0) Then Begin
          // Build up the list of jobs from the Forms List sub-object
          For I := 0 To Pred(FFormsListO.Count) Do Begin
            // Extract Form Details from Forms List
            PrBatch := FFormsListO.GetFormDets(I);

            // Update with details from global settings
            With PrBatch Do Begin
              pbTestMode := PrintJobSetupInfo.TestMode;
              pbLabel1 := PrintJobSetupInfo.pbLabel1;

              // Enable/Disable label mode as applicable
              If (I = 0) Then
                PrintJobSetupInfo.LabelMode := (pbDefMode = GlobType.fmLabel) Or
                                               (pbDefMode = GlobType.fmSerialLabel);

              If (pbDefMode = GlobType.fmSerialLabel) Then
                // Setup pointer to additional data - free'd automatically within printing routines
                pbRepInfo.RepPtr := FFormsListO.GetSerialPtr(I);

              If (I = 0) And (pbDefMode = GlobType.fmPickLstCons) Then
                // Setup Temp DB containing lines for the table
                pbRepInfo.SFName := FFormsListO.BuildTempDB(0, 1);

              If (I = 0) And (pbDefMode = GlobType.fmCustomTradingHistory) Then
                // Setup Temp DB containing lines for the table
                pbRepInfo.SFName := FFormsListO.BuildTempDB(0, 2001);
           End; { With PrBatch }

            // Add Form Details into Print Batch for printing
            If (Not PrintBatch_AddJob (PrBatch)) Then Begin
              // Unknown error adding details
              Result := 1002;
              LastErDesc := 'Error ' + IntToStr(Result) + ' in IEFPrintJob.PrintBatch adding Form ' + IntToStr(I + 1) + ' into the Print Job';
              Break;
            End; { If (Not PrintBatch_AddJob (PrBatch)) }
          End; { For I }

          If (Result = 0) Then Begin
            // Setup the print job info depending on the output destination
            With PrintJobSetupInfo Do Begin
              Case Destination Of
                tfdPrinter : Begin
                               fePrintMethod := 0;
                             End;
                tfdEmail   : Begin
                               fePrintMethod := 2;
                             End;
                tfdFax     : Begin
                               fePrintMethod := 1;
                             End;
              Else
                Raise Exception.Create ('');
              End; { Else }
              Preview := WantPreview;

              // Need to code support for this when required
              ChequeMode := False;

              // Setup data pointer for returning info from printer routines
              feDataPtr := pData;
            End; { With PrintJobSetupInfo }

            If (Not PrintBatch_Print ('WinTitle', PrintJobSetupInfo)) Then
              Result := 1003;
          End; { If (Result = 0) }
        End { If (FFormsListO.Count > 0) }
        Else Begin
          // No forms specified in Forms List
          Result := 1100;
          LastErDesc := 'No Form Details have been specified for the Print Job';
        End; { Else }
      End { If PrintBatch_ClearBatch }
      Else
        // Error re-initialising the PrintBatch
        Result := 1001;
    Except
      On E:Exception Do Begin
        Result := 1000;
        LastErDesc := E.Message;
      End; { On E:Exception }
    End;

  If (Result <> 0) And (LastErDesc = '') Then
    LastErDesc := 'Error ' + IntToStr(Result) + ' in IEFPrintJob.PrintBatch';
end;

//-----------------------------------------------------------------------------

function TEFPrintJob.PrintToPrinter: Integer;
begin
  OutputDebug('TEFPrintJob.PrintToPrinter Start');
  // MH 24/04/2015 v7.0.14 ABSEXCH-16386: Copied ABSEXCH-16268 'Set the 8087 Control Word to disable Divide by Zero errors in printer drivers' in from v7.0.9
  Set8087CW($133f);

  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    Result := PrintBatch(tfdPrinter,False, NIL);
    OutputDebug('TEFPrintJob.PrintToPrinter PrintBatch returned ' + IntToStr(Result));

  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
  OutputDebug('TEFPrintJob.PrintToPrinter End');
end;

function TEFPrintJob.PrintToTempFile(Destination: TEFTempFileDestination): IEFPrintTempFile;
Var
  TempFileO : TEFPrintTempFile;
  pFTKData  : pFormToolkitData;
  Res       : LongInt;
begin
  // MH 24/04/2015 v7.0.14 ABSEXCH-16386: Copied ABSEXCH-16268 'Set the 8087 Control Word to disable Divide by Zero errors in printer drivers' in from v7.0.9
  Set8087CW($133f);

  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    // Check licencing limitations for paperless module
    If (Destination In [tfdEmail, tfdFax])  Then
      CheckPaperlessLicence;

    New(pFTKData);
    Try
      // Update the PrintJobSetupInfo structure with destination specific info
      Case Destination Of
        tfdPrinter : ;  // N/A

        tfdEmail   : FEmailInfoO.UpdatePrnSetup;

        tfdFax     : FFaxInfoO.UpdatePrnSetup(pFTKData);
      End; { Case Destination }

      // Print the PrintJob to the specified destination with the Preview mode flag set to prevent
      // A) it being sent to the printer and B) notes being added for statements/debt chase letters etc...
      Res := PrintBatch(Destination, True, pFTKData);

      // Create a temporarfy file object
      TempFileO := TEFPrintTempFile.Create (Destination, PrintJobSetupInfo, pFTKData^, Res);

      // Return an interface reference to the temporary file object
      Result := TempFileO;
    Finally
      Dispose(pFTKData);
    end;
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
end;

//-----------------------------------------------------------------------------

function TEFPrintJob.Get_pjForms: IEFPrintFormsList;
begin
  Result := FFormsListI;
end;

//-----------------------------------------------------------------------------

function TEFPrintJob.PrinterSetupDialog: WordBool;
begin
  // Set flag to force PrinterSetupdialog to be parented by the active application
  UseGetForeground := True;

  // Setup Printer details as specified in PrintJob before calling dialog
  RpDev.SetPrnSetup(PrintJobSetupInfo);

  // Display Print Setup dialog for active printer
  Result := RpDev.PrinterSetupDialog;

  If Result Then
    // Update PrinterIndex/BinIndex/PaperIndex/...
    PrintJobSetupInfo := RpDev.SBSSetupInfo2(PrintJobSetupInfo);
end;

//-----------------------------------------------------------------------------

function TEFPrintJob.Get_pjPrinterIndex: Integer;
begin
  Result := PrintJobSetupInfo.DevIdx + 1;
end;

procedure TEFPrintJob.Set_pjPrinterIndex(Value: Integer);
begin
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    If (Value > 0) And (Value <= RPDev.Printers.Count) Then
      With RpDev, PrintJobSetupInfo Do Begin
        // Redirect RpDev to specified printer
        DeviceIndex := Value - 1;
        DevIdx := DeviceIndex;

        // Check that Papers are supported - if so extract details from RpDev
        prnSupportsPapers := ((DevMode.dmFields And DM_PAPERSIZE) = DM_PAPERSIZE);
        If prnSupportsPapers Then Begin
          FormNo   := DevMode.dmPaperSize;
          FormName := WalkList(Papers, FormNo);
        End { If (RpDev.DevMode.dmFields And DM_PAPERSIZE) = DM_PAPERSIZE) }
        Else Begin
          FormNo   := 0;
          FormName := '';
        End; { Else }

        // Check that Bins are supported - if so extract details from RpDev
        prnSupportsBins := ((DevMode.dmFields And DM_DEFAULTSOURCE) = DM_DEFAULTSOURCE);
        If prnSupportsBins Then Begin
          BinNo    := DevMode.dmDefaultSource;
          BinName  := WalkList(RpDev.Bins, BinNo);
        End { If ((DevMode.dmFields And DM_DEFAULTSOURCE) = DM_DEFAULTSOURCE) }
        Else Begin
          BinNo    := 0;
          BinName  := '';
        End; { Else }
      End { With PrintJobSetupInfo }
    Else
      Raise EInvalidIndex.Create ('Invalid Printer Index (' + IntToStr(Value) + ')');
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging    
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
end;

//-----------------------------------------------------------------------------

function TEFPrintJob.Get_pjPaperIndex: Integer;
begin
  If prnSupportsPapers Then
    // Lookup Form within the printers Papers array and return the index
    Result := RpDev.WalkListIdx(RpDev.Papers, PrintJobSetupInfo.FormNo) + 1
  Else
    // Paper not Supported
    Result := 0;
end;

procedure TEFPrintJob.Set_pjPaperIndex(Value: Integer);
begin
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    With PrintJobSetupInfo Do Begin
      If prnSupportsPapers Then Begin
        If (Value > 0) And (Value <= RPDev.Papers.Count) Then Begin
          FormName := RpDev.Papers[Value - 1];
          FormNo   := LongInt(RpDev.Papers.Objects[Value - 1]);
        End { If (Value > 0) And (Value <= RPDev.Papers.Count) }
        Else
          Raise EInvalidIndex.Create ('Invalid Paper Index (' + IntToStr(Value) + ')');
      End { If prnSupportsPapers }
      Else Begin
        FormNo   := 0;
        FormName := '';
      End; { Else }
    End; { With PrintJobSetupInfo }
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
end;

//-----------------------------------------------------------------------------

function TEFPrintJob.Get_pjBinIndex: Integer;
begin
  If prnSupportsBins Then
    // Lookup Form within the printers Papers array and return the index
    Result := RpDev.WalkListIdx(RpDev.Bins, PrintJobSetupInfo.BinNo) + 1
  Else
    // Bins not Supported
    Result := 0;
end;

procedure TEFPrintJob.Set_pjBinIndex(Value: Integer);
begin
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    With PrintJobSetupInfo Do Begin
      // MH 16/05/2016 2016-R2 ABSEXCH-17041: The "Send To OneNote" printer driver lies to us and tells
      // us that it Supports Bins and that the Default Bin is bin number 1 - but the Bins list is
      // empty, causing the check to fail and the invalid index exception to be raised.
      // Checking for entries in the Bins list as well as the SupportsBins flag works around this.
      If prnSupportsBins And (RPDev.Bins.Count > 0) Then
      Begin
        If (Value > 0) And (Value <= RPDev.Bins.Count) Then Begin
          BinName := RpDev.Bins[Value - 1];
          BinNo   := LongInt(RpDev.Bins.Objects[Value - 1]);
        End { If (Value > 0) And (Value <= RPDev.Bins.Count) }
        Else
          Raise EInvalidIndex.Create ('Invalid Bin Index (' + IntToStr(Value) + ')');
      End { If prnSupportsBins }
      Else Begin
        BinNo   := 0;
        BinName := '';
      End; { Else }
    End; { With PrintJobSetupInfo }
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
end;

//-----------------------------------------------------------------------------

function TEFPrintJob.Get_pjCopies: Integer;
begin
  Result := PrintJobSetupInfo.NoCopies;
end;

procedure TEFPrintJob.Set_pjCopies(Value: Integer);
begin
  If (Value >= 0) And (Value <= 32000) Then
    PrintJobSetupInfo.NoCopies := Value
  Else
    Raise EValidation.Create ('Invalid value for pjCopies (' + IntToStr(Value) + '), valid range is 1 to 32000 copies');
end;

//-----------------------------------------------------------------------------

function TEFPrintJob.Get_pjLabel1: Integer;
begin
  Result := PrintJobSetupInfo.pbLabel1;
end;

procedure TEFPrintJob.Set_pjLabel1(Value: Integer);
begin
  If (Value >= 1) And (Value <= 999) Then
    PrintJobSetupInfo.pbLabel1 := Value
  Else
    Raise EValidation.Create ('Invalid value for pjLabel1 (' + IntToStr(Value) + '), valid range is 1 to 999');
end;

//-----------------------------------------------------------------------------

function TEFPrintJob.Get_pjTestMode: WordBool;
begin
  Result := PrintJobSetupInfo.TestMode;
end;

procedure TEFPrintJob.Set_pjTestMode(Value: WordBool);
begin
  PrintJobSetupInfo.TestMode := Value;
end;

//-----------------------------------------------------------------------------

function TEFPrintJob.Get_pjUserId: WideString;
begin
  Result := PrintJobSetupInfo.feUserId;
end;

procedure TEFPrintJob.Set_pjUserId(const Value: WideString);
begin
  PrintJobSetupInfo.feUserId := LJVar(Trim(UpperCase(Value)),LoginKeyLen);
end;

//-----------------------------------------------------------------------------

function TEFPrintJob.Get_pjEmailInfo: IEFPrintJobEmailInfo;
begin
  // Check licencing limitations for paperless module
  CheckPaperlessLicence;

  Result := FEmailInfoI;
end;

//-----------------------------------------------------------------------------

function TEFPrintJob.Get_pjFaxInfo: IEFPrintJobFaxInfo;
begin
  // Check licencing limitations for paperless module
  CheckPaperlessLicence;

  Result := FFaxInfoI;
end;

//-----------------------------------------------------------------------------

function TEFPrintJob.Get_pjFileInfo: IEFPrintJobFileInfo;
begin
  // Check licencing limitations for paperless module
  CheckPaperlessLicence;

  Result := FFileInfoI;
end;

//-----------------------------------------------------------------------------

function TEFPrintJob.Get_pjTitle: WideString;
begin
  Result := PrintJobSetupInfo.feJobTitle;
end;

procedure TEFPrintJob.Set_pjTitle(const Value: WideString);
begin
  PrintJobSetupInfo.feJobTitle := Value;
end;

//-----------------------------------------------------------------------------

function TEFPrintJob.Get_pjMode: TEFPrintFormMode;
begin
  Result := FPrintMode;
end;

//-----------------------------------------------------------------------------

function TEFPrintJob.ImportDefaults: IEFImportDefaults;
begin
  Result := TEFImportDefaults.Create(FPrintToolkit);
end;

//-----------------------------------------------------------------------------

Function TEFPrintJob.IsLabel : Boolean;
Begin { IsLabel }
  Result := (FPrintMode = EnterpriseForms_TLB.fmLabel) Or
            (FPrintMode = EnterpriseForms_TLB.fmSerialLabel);
End; { IsLabel }

//-----------------------------------------------------------------------------

end.

