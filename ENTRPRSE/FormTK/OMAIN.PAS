unit oMain;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Forms, SysUtils, EnterpriseForms_TLB, StdVcl, oConfig, oPrntJob,
  oPrinters, oFuncs, oFTKLic, PsAPI;

type
  // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Added Reset method
  TObjInitType = (itFull, itCloseTK, itReset);

  TEFPrintingToolkit = class(TAutoObject, IEFPrintingToolkit, IEFPrintingToolkit2)
  private
    FToolkitStatus : TEFToolkitStatus;
    // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Added system to detect and refresh stale System Setup data
    SystemSetupDataTimestamp : TDateTime;

    // Internal Licence Object
    FFTKLicence    : TFormsTKLicence;

    // Configuration Sub-object
    FConfigO       : TEFConfiguration;
    FConfigI       : IEFConfiguration;

    // Printers sub-object
    FPrintersO     : TEFPrinters;
    FPrintersI     : IEFPrinters;

    // PrintJob Sub-object
    FPrintJobO     : TEFPrintJob;
    FPrintJobI     : IEFPrintJob;

    // Functions Sub-object
    FFunctionsO    : TEFFunctions;
    FFunctionsI    : IEFFunctions;

    procedure InitObjs (Const InitType : TObjInitType);
  protected
    // IPrintingToolkit
    function ClosePrinting: Integer; safecall;
    function Get_Configuration: IEFConfiguration; safecall;
    function Get_Printers: IEFPrinters; safecall;
    function Get_PrintJob: IEFPrintJob; safecall;
    function Get_Version: WideString; safecall;
    function OpenPrinting(const ProductName: WideString; const LicenceNo: WideString): Integer; safecall;
    function Get_Status: TEFToolkitStatus; safecall;
    function Get_Functions: IEFFunctions; safecall;
    function Get_LastErrorString: WideString; safecall;

    // IEFPrintingToolkit2
    procedure Reset; safecall;
    function Get_MemoryUsage: Integer; safecall;

    // Local Methods
    Procedure FindEnterpriseDir;
    Procedure GetEnterpriseVer;
    Function OpenDataFiles : LongInt;
    function ValidProductLicence(const ProductName, LicenceNo: WideString): Integer;

    // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Split reading of System Setup details out to standalone
    // routine so that it can be re-used from Get_PrintJob if the data is stale
    procedure RefreshSystemSetup (Const FirstCall : Boolean);
  public
    procedure Initialize; override;
    Destructor Destroy; override;

    Property FTKLicence : TFormsTKLicence Read FFTKLicence;
    Property PrintersI : IEFPrinters Read FPrintersI;
    Property PrintJobI : IEFPrintJob Read Get_PrintJob;
    Property PrintJobO : TEFPrintJob Read FPrintJobO;
    Property Status : TEFToolkitStatus Read FToolkitStatus;
  end; { TEFPrintingToolkit }

implementation

uses ComServ, Dialogs, Registry, Windows, GlobVar, VarConst, GlobType, FormFile,
     MiscFunc, BtrvU2, BTSupU1, BTSupU2, PrnCodes, History, LicRec, EntLic, PrntForm,
     Controls, StdCtrls, ExtCtrls, DateUtils, VAOUtil, DataDict,
     // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
     MadExcept,
     CustomFieldsIntf,
     SQLUtils,
     ADOConnect,       // Global ADO Connection String
     LogUtil;


//-----------------------------------------------------------------------------

procedure TEFPrintingToolkit.Initialize;
begin { Initialize }
//ShowMessage ('TEFPrintingToolkit.Initialize.Start');
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    inherited Initialize;

//ShowMessage ('TEFPrintingToolkit.Initialize.1');
    FindEnterpriseDir;
    OutputDebug('TEFPrintingToolkit.Initialize Start ' + SystemInfo.EnterprisePath);
    // MH 24/04/2015 v7.0.14 ABSEXCH-16386: Copied ABSEXCH-16268 'Set the 8087 Control Word to disable Divide by Zero errors in printer drivers' in from v7.0.9
    OutputDebug('TEFPrintingToolkit.Initialize. Set8087CW');
    Set8087CW($133f);

    // Initialise the object references
    InitObjs (itFull);

//ShowMessage ('TEFPrintingToolkit.Initialize.2');
    FToolkitStatus := tkClosed;

    // Create the Forms Toolkit Licence Object
    OutputDebug('TEFPrintingToolkit.Initialize. Create Licence object');
    FFTKLicence := TFormsTKLicence.Create;

//ShowMessage ('TEFPrintingToolkit.Initialize.3');
    // Create the Printers object
    OutputDebug('TEFPrintingToolkit.Initialize. Create Printers object');
    FPrintersO := TEFPrinters.Create;
    FPrintersI := FPrintersO;

//ShowMessage ('TEFPrintingToolkit.Initialize.4');
    // Initialise the global Form Designer information
    FillChar (SystemInfo, SizeOf(SystemInfo), #0);
    With SystemInfo Do Begin
      ExVersionNo      := 11;
      MainForm         := Application.MainForm;
      AppHandle        := Application;
      ExDataPath       := '';;
      ControllerHandle := NIL;;
      DefaultFont      := NIL;;
      FormDesVer       := '';
      DebugOpen        := False;
      AppPrinter       := NIL;
    End; { With SystemInfo }

    // Initialise the global error string
    LastErDesc := '';

    // Setup Btrieve Owner name to allow data files to be opened in read/write mode
    AssignBOwner(ExBTOWNER);

//ShowMessage ('TEFPrintingToolkit.Initialize.5');
    // Find Exchequer directory
    //FindEnterpriseDir; //PR: 01/09/2016 Moved call to FindEnterpriseDir to start of routine as needed by debug log
    // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Added system to detect and refresh stale System Setup data
    SystemSetupDataTimestamp := EncodeDate(1900, 1, 1);

    OutputDebug('TEFPrintingToolkit.Initialize End');
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;

//ShowMessage ('TEFPrintingToolkit.Initialize.Finish');
end; { Initialize }

//-----------------------------------------

Destructor TEFPrintingToolkit.Destroy;
Begin { Destroy }
  If (FToolkitStatus = tkOpen) Then
    // shutdown Toolkit
    ClosePrinting;

  // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Moved from TEFPrintJob.Destroy to TEFPrintingToolkit.Destroy
  If SQLUtils.UsingSQL Then
    TerminateGlobalADOConnection;

  { Destroy sub-objects }
  InitObjs (itFull);

  // Destroy Forms Toolkit Licencing Object
  FreeAndNIL(FFTKLicence);

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

// MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Added Reset method
Procedure TEFPrintingToolkit.InitObjs (Const InitType : TObjInitType);
Begin { InitObjs }
  // Check for type of initialisaton - some objects should remain intact if only a Toolkit Close
  If (InitType = itFull) Then
  Begin
    // Configuration sub-object
    FConfigO := NIL;
    FConfigI := NIL;

    // Printers sub-object
    FPrintersO := NIL;
    FPrintersI := NIL;

    // Functions Sub-object
    FFunctionsO := NIL;
    FFunctionsI := NIL;
  End; // If (InitType = itFull)

  // Print Job sub-object
  FPrintJobO := Nil;
  FPrintJobI := Nil;
End; { InitObjs }

//-----------------------------------------------------------------------------

// Find Exchequer Programs directory and Company.Dat directory
Procedure TEFPrintingToolkit.FindEnterpriseDir;
//Var
//  FormTkDir, ErrStr : ShortString;
Begin { FindEnterpriseDir }
  SystemInfo.EnterprisePath := VAOInfo.vaoCompanyDir;

// HM 17/08/04: Modified for VAO compatibility
//  SystemInfo.EnterprisePath := '';
//
//  // Extract Form Toolkit Path
//  FormTkDir := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));
//
//  If ValidateEnterpriseDirectory (FormTkDir, ErrStr) Then Begin
//    // Enough files to make COM Tk happy
//    SystemInfo.EnterprisePath := FormTkDir;
//  End { If ValidateEnterpriseDirectory (FormTkDir, ErrStr) }
//  Else Begin
//    // No programs in Form TK dir - look for registered Exchequer dir in Registry
//    With TRegistry.Create Do
//      Try
//        Access := KEY_READ;
//        RootKey := HKEY_LOCAL_MACHINE;
//
//        If OpenKey('Software\Exchequer\Enterprise', False) Then Begin
//          { Key opened ok }
//          FormTKDir := IncludeTrailingBackslash (Trim(ReadString ('LastDir')));
//
//          If ValidateEnterpriseDirectory (FormTkDir, ErrStr) Then
//            // Enough files to make COM Tk happy
//            SystemInfo.EnterprisePath := FormTkDir;
//        End; { If OpenKey('Software\Exchequer\Enterprise', False) }
//      Finally
//        CloseKey;
//        Free;
//      End;
//  End; { Else }
End; { FindEnterpriseDir }

//-----------------------------------------------------------------------------

Procedure TEFPrintingToolkit.GetEnterpriseVer;
Var
  LicR : EntLicenceRecType;
Begin { GetEnterpriseVer }
  // Check to see if licence file exists - if not stay with 11 as version to prevent problems
  If FileExists(SystemInfo.EnterprisePath + EntLicFName) Then
    // Got Licence - read it
    If ReadEntLic (SystemInfo.EnterprisePath + EntLicFName, LicR) Then Begin
      // Calculate the Exchequer Version from the licencing information
      If (LicR.licEntCVer > 0) Then Begin
        // MC
        Case LicR.licEntModVer Of
          // MC only
          0 : SystemInfo.ExVersionNo := 7;
          // MC/Stk
          1 : SystemInfo.ExVersionNo := 8;
          // MC/SPOP
          2 : If (LicR.licModules[modJobCost] > 0) Then
                // MC/SPOP/JC
                SystemInfo.ExVersionNo := 11
              Else
                // MC/SPOP
                SystemInfo.ExVersionNo := 9;
        End; { Case licEntModVer }
      End { If (LicR.licEntCVer > 0) }
      Else Begin
        // Professional
        Case LicR.licEntModVer Of
          // SC only
          0 : SystemInfo.ExVersionNo := 3;
          // SC/Stk
          1 : SystemInfo.ExVersionNo := 4;
          // SC/SPOP
          2 : If (LicR.licModules[modJobCost] > 0) Then
                // SC/SPOP/JC
                SystemInfo.ExVersionNo := 6
              Else
                // SC/SPOP
                SystemInfo.ExVersionNo := 5;
        End; { Case licEntModVer }
      End; { Else }

      // Check for a Paperless Module release code
      eCommsModule := (LicR.licModules[modPaperless] > 0);

      // Check for a Enhanced Security release code
      EnSecurity := (LicR.licModules[modEnhSec] > 0);
    End; { If ReadEntLic }
End; { GetEnterpriseVer }

//-----------------------------------------------------------------------------

// Opens Exchequer and Form Designer data files
Function TEFPrintingToolkit.OpenDataFiles : LongInt;
var
  FileNo, NoTrys    : Byte;
  LStatus, SetAccel : SmallInt;
  FilePath          : ShortString;
begin
  Result := 0;
  // Set Accelerated mode if specified
  SetAccel:=-1*Ord(AccelMode);

  // Open Standard and Form Designer Data Files - FileNo 1-16 + 18 + 19
  // MH 10/11/06: Added 16 - NomView.Dat
  FileNo := 1;    // CustF - Cust\CustSupp.Dat
  While (FileNo <= 19) And (Result = 0) Do Begin
    // Check its a file we want to open
    If (FileNo In [1..16, 18, 19]) Then
    Begin
      // MH 01/05/07: Modified to always pickup Dictnary.Dat from main exchequer directory
      If (FileNo = DictF) Then
        FilePath := SystemInfo.EnterprisePath
      Else
        FilePath := SetDrive;

//  ShowMessage ('SystemInfo.EnterprisePath: ' + SystemInfo.EnterprisePath + #13 +
//               'VAOInfo.vaoCompanyDir: ' + VAOInfo.vaoCompanyDir + #13 +
//               'VAOInfo.vaoAppsDir: ' + VAOInfo.vaoAppsDir);

      // OK - try to open the file - allow 100 attampts
      NoTrys := 0;
      Repeat
        LStatus := Open_File (F[FileNo], FilePath+FileNames[FileNo], SetAccel);
        Inc (NoTrys);
      Until (LStatus = 0) Or (NoTrys > 100);

      If (LStatus <> 0) Then Begin
        // Display useful message
        LastErDesc := 'An error ' + IntToStr(LStatus) + ' occurred trying to open ' + QuotedStr(FilePath+FileNames[FileNo]);

        // MH 11/09/2015 2016R1 ABSEXCH-16847: Copied ABSEXCH-16828 mods to removed popup error message from v7.0.9
        //Application.MessageBox(PCHAR(LastErDesc), 'Error in OpenPrinting', MB_OK + MB_ICONERROR);

        // Return Btrieve Error
        Result := Status;

        // Break out of loop after first error }
        Break;
      End; { If (LStatus <> 0) }
    End; { If (FileNo In [1..15, 17..19]) }

    // Move to next file
    Inc(FileNo);
  End; { While (FileNo <= 19) And (Result = 0) }
end;

//-----------------------------------------------------------------------------

function TEFPrintingToolkit.ValidProductLicence(const ProductName, LicenceNo: WideString): Integer;
Begin { ValidProductLicence }
  Result := 0;

  Try
    // Prime Licencing Object with ProdName/LicNo
    FFTKLicence.ProductName := ProductName;
    FFTKLicence.LicenceNo := LicenceNo;         // <--- will raise exception if there are any probs

    // If it got this far the ProductName/LicenceNo are valid :-)
    With FFTKLicence Do Begin
      // Check Licence Version - its an easy mechanism to invalidate all licences should the system be hacked
      If (Version <> 1) Then Begin
        // Licence Expired
        Result := 1007;
        LastErDesc := 'The Forms Toolkit Product Licence is for a previous version of the Forms Toolkit';
      End; { If (Version <> 1) }

      If (Result = 0) Then Begin
        // Check for perpetual licence - if not then check Expiry Date
        If Not LicenceFlags [FlgIdxPerpetualLicence] Then
          If (CompareDate(ExpiryDate, Now) = -1) Then Begin
            // Licence Expired
            Result := 1006;
            LastErDesc := 'The Forms Toolkit Product Licence has Expired';
          End; { If (CompareDate(ExpiryDate, Now) = -1)  }
      End; { If (Result = 0) }

      If (Result = 0) Then Begin
        // Check for Demo Licence
        If LicenceFlags [FlgIdxDemoLicence] Then
          ForceDemoVer := True;
      End; { If (Result = 0) }
    End; { With FFTKLicence }
  Except
    On E:Exception Do Begin
      Result := 1005;
      If (Pos ('(E', E.Message) = 1) Then
        LastErDesc := 'Invalid Licence ' + Copy (E.Message, 1, 6)
      Else
        LastErDesc := E.Message;
    End; { On }
  End;
End;  { ValidProductLicence }

//-----------------------------------------------------------------------------

//     0    AOK
//  1001    Unknown Exception, see Error Text
//  1002    The Form Toolkit is already Open
//  1003    The Btrieve Database Engine cannot be loaded
//  1004    Invalid DataDirectory Path in Configuration Object
//  1005    Invalid Product Licence
//  1006    Product Licence Expired
//  1007    Product Licence is for a previous version of the Forms Toolkit
function TEFPrintingToolkit.OpenPrinting(const ProductName: WideString; const LicenceNo: WideString): Integer;
var
  ErrStr   : ShortString;
begin
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    // Re-Initialise the global error string
    LastErDesc := '';

    If (FToolkitStatus = tkClosed) Then
      Try
        // Validate ProductName/LicenceNo
        Result := ValidProductLicence(ProductName, LicenceNo);

        If (Result = 0) Then Begin
          // Check Btrieve is available
          If Check4BtrvOk Then Begin
            // Set path to Company Data Set
            SetDrive := SystemInfo.ExDataPath;
            If ValidateDataDirectory (SetDrive, ErrStr) Then Begin
              // Open all the standard Exchequer data files and the Form Designer files
              Result := OpenDataFiles;

              If (Result = 0) Then
              Begin
                //PR: 31/08/2016 ABSEXCH-16704 Create debug logging object
                OutputDebug('TEFPrintingToolkit.OpenPrinting');

                // MH 31/01/2014 v7.0.9: Noticed it was crashing with an error in the customer Fields object whilst debugging something else
                SetCustomFieldsPath(SetDrive);

                // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Split reading of System Setup details out to
                //                                           standalone routine so that it can be re-used
                //                                           from Get_PrintJob if the data is stale
                RefreshSystemSetup(True);

                // Load all the System Setup info
                //Init_AllSys;

                // Initialise global arrays
                //Init_STDVATList;
                //Init_STDCurrList;
                //Init_STDDocTList;
                {$IFDEF STK}
                  //Init_STDStkTList;
                  //Init_STDValList;
                {$ENDIF}

                // Setup Floating Point formatting strings
                //Set_SDefDecs;

                // Load DOS-type printer stuff
                InitPrnCodes;

                // Setup Exchequer Version from Licence details
                GetEnterpriseVer;

                // Setup Custom Fields object
                SetCustomFieldsPath(SetDrive);

                // Mark Form Printing Toolkit as Open
                FToolkitStatus := tkOpen;

              End; { If (Result = 0) }
            End { If Check4BtrvOk }
            Else Begin
              // Invalid Data Directory
              Result := 1004;
              LastErDesc := ErrStr;
            End; { If ValidateDataDirectory (SetDrive) }
          End { If Check4BtrvOk }
          Else Begin
            // Btrieve not available
            Result := 1003;
            LastErDesc := 'Btrieve Not Available';
          End; { Else }
        End; { If (Result = 0) }
      Except
        On E: Exception Do Begin
          LastErDesc := 'Exception: ' + E.Message;
          Result := 1001;
        End; { On }
      End
    Else Begin
      { Toolkit already open }
      Result := 1002;
      LastErDesc := 'The Form Toolkit is already open';
    End; { Else }
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
end;

//------------------------------

// MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Split reading of System Setup details out to standalone
// routine so that it can be re-used from Get_PrintJob if the data is stale
procedure TEFPrintingToolkit.RefreshSystemSetup (Const FirstCall : Boolean);
Begin // RefreshSystemSetup
  OutputDebug('TEFPrintingToolkit.RefreshSystemSetup Start');
  // Set the timestamp for the automatic refresh of stale data
  SystemSetupDataTimestamp := Now;

  // Load all the System Setup info
  Init_AllSys;

  // Initialise global arrays
  Init_STDVATList;
  Init_STDCurrList;
  Init_STDDocTList;
  {$IFDEF STK}
    If FirstCall Then
    Begin
      // Fixed data - don't need to refresh
      Init_STDStkTList;
      Init_STDValList;
    End; // If FirstCall
  {$ENDIF}

  // Setup Floating Point formatting strings
  Set_SDefDecs;
  OutputDebug('TEFPrintingToolkit.RefreshSystemSetup End');
End; // RefreshSystemSetup

//-----------------------------------------

function TEFPrintingToolkit.ClosePrinting: Integer;
begin
  OutputDebug('TEFPrintingToolkit.ClosePrinting Start');

  Result := 0;

  // Closedown the Custom Fields object
  ClearCustomFields;

  // Destroy any Btrieve using sub-objects
  InitObjs (itCloseTK);

  // Close Form Designer Data Files
  FF_CloseFiles (True);

  // change status
  FToolkitStatus := tkClosed;

  OutputDebug('TEFPrintingToolkit.ClosePrinting End');
end;

//-----------------------------------------------------------------------------

// MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Added Reset method
procedure TEFPrintingToolkit.Reset;
Begin // Reset
  // Destroy the PrintJob sub-object
  InitObjs (itReset);
End; // Reset

//-------------------------------------------------------------------------

function TEFPrintingToolkit.Get_Configuration: IEFConfiguration;
begin
  If (Not Assigned(FConfigO)) Then Begin
    // Create and initialise the Toolkit Configuration sub-object
    FConfigO := TEFConfiguration.Create(Self);

    FConfigI := FConfigO;
  End; { If (Not Assigned(FConfigO)) }

  Result := FConfigI;
end;

//-----------------------------------------------------------------------------

function TEFPrintingToolkit.Get_PrintJob: IEFPrintJob;
begin
  If (Not Assigned(FPrintJobO)) Then
  Begin
    // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Added check for stale data - data is considered
    //                                           potentially stale after 5 minutes and is reloaded
    //                                           to ensure the latest system setup flags, exchange
    //                                           rates, VAT rates, etc... are being used
    If (SystemSetupDataTimestamp < IncMinute(Now, -5)) Then
      RefreshSystemSetup (False);

    // Create and initialise the Print Job sub-object
    FPrintJobO := TEFPrintJob.Create(Self);

    FPrintJobI := FPrintJobO;
  End; { If (Not Assigned(FPrintJobO)) }

  Result := FPrintJobI;
end;

//-----------------------------------------------------------------------------

function TEFPrintingToolkit.Get_Version: WideString;
begin
  // Version Number and version history stored in History.Pas
  Result := FormTKVer;
end;

//-----------------------------------------------------------------------------

function TEFPrintingToolkit.Get_Status: TEFToolkitStatus;
begin
  Result := FToolkitStatus;
end;

//-----------------------------------------------------------------------------

function TEFPrintingToolkit.Get_Printers: IEFPrinters;
begin
  Result := FPrintersI;
end;

//-----------------------------------------------------------------------------

function TEFPrintingToolkit.Get_Functions: IEFFunctions;
begin
  If (Not Assigned(FFunctionsO)) Then Begin
    // Create and initialise the Functions sub-object
    FFunctionsO := TEFFunctions.Create;

    FFunctionsI := FFunctionsO;
  End; { If (Not Assigned(FFunctionsO)) }

  Result := FFunctionsI;
end;

//-----------------------------------------------------------------------------

function TEFPrintingToolkit.Get_LastErrorString: WideString;
begin
  Result := LastErDesc;
end;

//-----------------------------------------------------------------------------

function TEFPrintingToolkit.Get_MemoryUsage: Integer;
Var
  pmc: TProcessMemoryCounters;
Begin // Get_MemoryUsage
  pmc.cb := SizeOf(pmc) ;
  if GetProcessMemoryInfo(GetCurrentProcess, @pmc, SizeOf(pmc)) then
    Result := pmc.WorkingSetSize
  else
    Result := -1;
End; // Get_MemoryUsage

//=========================================================================

initialization
  TAutoObjectFactory.Create(ComServer, TEFPrintingToolkit, Class_PrintingToolkit,
    ciSingleInstance, tmApartment);
end.
