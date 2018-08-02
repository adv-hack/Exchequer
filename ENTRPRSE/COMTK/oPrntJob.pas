unit oPrntJob;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},// COM Toolkit Type Library
     EnterpriseForms_TLB,      // Form Printing Toolkit Type Library
     oPrnters,                 // Printers Sub-Object (IPrinters)
     oFormLst,                 // Forms List Sub-Object (IPrintFormList)
     oTmpFile,                 // TempFile Sub-Object (IPrintTempFile)
     oPJEmail,                 // Email Info sub-object (IPrintJobEmailInfo)
     oPJFile,                  // File Info sub-object  (IPrintJobFileInfo)
     oPJFax,                   // Fax Sub-Objects  (IPrintJobFaxInfo)
     oDataLst;                 // CustomData Sub-Object  (IPrintJobDataList)

type
  TPrintJob = class(TAutoIntfObject, IPrintJob, IPrintJob2, IBrowseInfo)
  private
    // COM Toolkit Base Object
    FToolkit       : TObject;

    // Form printing Toolkit sub-object
    FPrintToolkitI : IEFPrintingToolkit;

    // SystemPrinters sub-object
    FPrintersO     : TPrinters;
    FPrintersI     : IPrinters;

    // Forms list sub object
    FFormsO        : TPrintFormList;
    FFormsI        : IPrintFormList;

    // Email Info sub-object
    FEmailInfoO    : TPrintJobEmailInfo;
    FEmailInfoI    : IPrintJobEmailInfo;

    // Fax Info sub-object
    FFaxInfoO      : TPrintJobFaxInfo;
    FFaxInfoI      : IPrintJobFaxinfo;

    // File Info sub-object
    FFileInfoO     : TPrintJobFileInfo;
    FFileInfoI     : IPrintJobFileinfo;

    // CustomData sub-ojject
    FCustomDataO   : TPrintJobDataList;
    FCustomDataI   : IPrintJobDataList;


    // Information on Data for Printing Routines
    FDefaultAcc : ShortString;           { Default Account Code for ImportDefaults }
    FDefMode    : TEFPrintFormMode;      { Mode of form }
    FImportDefs : TEFImportDefaultsType; { Sub-Type for ImportDefaults }
    FJobType    : TPrintJobType;         { Job Type - Form, Label, Label Run }
    FMainFNum   : Integer;               { Number of table driving file }
    FMainKPath  : Integer;               { key of table driving file}
    FMainKRef   : String;                { key to match for table }
    FTablFNum   : Integer;               { Number of table driving file }
    FTablKPath  : Integer;               { key of table driving file}
    FTablKRef   : String;
  protected
    // IPrintJob
    function Get_pjSystemPrinters: IPrinters; safecall;
    function Get_pjForms: IPrintFormList; safecall;
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
    function Get_pjStartLabelNo: Integer; safecall;
    procedure Set_pjStartLabelNo(Value: Integer); safecall;
    function Get_pjUserId: WideString; safecall;
    procedure Set_pjUserId(const Value: WideString); safecall;
    function Get_pjEmailInfo: IPrintJobEmailInfo; safecall;
    function Get_pjFaxInfo: IPrintJobFaxinfo; safecall;
    function Get_pjFileInfo: IPrintJobFileInfo; safecall;
    function Get_pjType: TPrintJobType; safecall;
    procedure ImportDefaults; safecall;
    function PrintToPrinter: Integer; safecall;
    function PrintToTempFile(Destination: TPrintDestination): IPrintTempFile; safecall;
    function GetFormInfo(const FormName: WideString): IFormDetails; safecall;
    function PrinterSetupDialog: WordBool; safecall;
    function Get_pjCustomData: IPrintJobDataList; safecall;

    // MH 18/02/2014 v7.0.9 ABSEXCH-14952: Added PrintJob Name property
    function Get_pjName: WideString; safecall;
    procedure Set_pjName(const Value: WideString); safecall;

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    // Local methods
    procedure InitObjs;
    procedure PrePrintStuff;
  public
    // Behind the scenes info for defining the print batch
    Property DefaultAcc : ShortString Read FDefaultAcc Write FDefaultAcc;
    Property FormDefMode : TEFPrintFormMode Read FDefMode;
    Property MainFileNum : Integer Read FMainFNum Write FMainFNum;
    Property MainKeyPath : Integer Read FMainKPath Write FMainKPath;
    Property MainKeyRef : String Read FMainKRef Write FMainKRef;
    Property TableFileNum : Integer Read FTablFNum Write FTablFNum;
    Property TableKeyPath : Integer Read FTablKPath Write FTablKPath;
    Property TableKeyRef : String Read FTablKRef Write FTablKRef;

    // PPublished to support internal usage of LastErrorString
    Property FormsToolkitI : IEFPrintingToolkit Read FPrintToolkitI;

    Constructor Create (Const Toolkit : TObject;
                        Const FormMode : TEFPrintFormMode;
                        Const ImportDefs : TEFImportDefaultsType;
                        Const JobType : TPrintJobType);
    Destructor Destroy; override;
  End; { TPrintJob }

implementation

uses ComServ,
     DateUtils,
     GlobVar,      // Exchequer Global Const/Type/Var
     oToolkit,     // Base COM Toolkit object
     oFormInf,     // Form Information sub-object (IFormDetails)
     Miscfunc,     // Miscellaneous Types and routines for COMTK
     DelTemp,      // Delete File List routines
     // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
     MadExcept,
     // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Modified printing to keep a pool of Forms Toolkit
     //                                           instances to improve printing speed
     oFormsToolkitPoolManager,
     LogUtil;

//-----------------------------------------------------------------------------

Constructor TPrintJob.Create (Const Toolkit : TObject;
                              Const FormMode : TEFPrintFormMode;
                              Const ImportDefs : TEFImportDefaultsType;
                              Const JobType : TPrintJobType);
Var
  Res : LongInt;
  Bored : Boolean;
  TimeOutTime : TDateTime;
Begin { Create }
  Inherited Create (ComServer.TypeLib, IPrintJob2);
  OutputDebug(Format('TPrintJob.Create. FormMode=%d; ImportDefs=%d; JobType=%d', [FormMode, ImportDefs, JobType]));
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    // Initialise all object references
    InitObjs;
    FDefMode := FormMode;
    FImportDefs := ImportDefs;
    FJobType := JobType;

    // Setup local reference to base Toolkit object
    FToolkit := Toolkit;

//    //PR 19/06/2008: Changed to keep trying to create PrintToolkit for 10 seconds before giving up
//    Bored := False;
//    TimeOutTime := IncSecond(Now, 10);  // Loop for 10 secs
//    FPrintToolkitI := nil;
//    Repeat
//      Try
//        FPrintToolkitI := CreateOleObject ('EnterpriseForms.PrintingToolkit') As IEFPrintingToolkit;
//      Except
//        FPrintToolkitI := NIL;
//      End; // Try..Except
//
//      if FPrintToolkitI = nil then
//      begin
//        Bored := (Now > TimeOutTime);
//        If (Not Bored) Then
//          Sleep(10);
//      end;{if}
//    Until Assigned(FPrintToolkitI) Or Bored;

    // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Modified printing to keep a pool of Forms Toolkit
    //                                           instances to improve printing speed
    FPrintToolkitI := FormsToolkitPoolManager.GetFormsToolkit;

    If Assigned(FPrintToolkitI) Then
    begin
      // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Modified printing to keep a pool of Forms Toolkit
      //                                           instances to improve printing speed
      If (FPrintToolkitI.Status = tkClosed) Then
      Begin
        // Setup Form Printing Toolkit Configuration based on current COM Toolkit configuration
        With FPrintToolkitI.Configuration, (FToolkit As TToolkit).ConfigI Do
        Begin
          // Path to Enterprise directory
          cfEnterpriseDirectory := EnterpriseDirectory;

          // Path to active data set
          cfDataDirectory := DataDirectory;

          // COM Toolkit will control the deletion of Temporary Files not the Forms Toolkit.
          cfDeleteTempFiles := False;
        End; // With FPrintToolkitI.Configuration, (FToolkit As TToolkit).ConfigI

        Res := FPrintToolkitI.OpenPrinting('Exchequer Enterprise COM Toolkit', 'EXENTCTK-0XFEQT-0KZND6');
      End // If (FPrintToolkitI.Status = tkClosed)
      Else
        // Forms Toolkit is already open
        Res := 0;

      If (Res = 0) Then
        FPrintToolkitI.PrintJob.Initialise (FDefMode)
      Else
        // Error Opening Data Set within the Forms Toolkit
        Raise EPrintError.Create (Format('Error %d initialising the Printing Toolkit', [Res]));
    end;
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
End; { Create }

//----------------------------------------

Destructor TPrintJob.Destroy;
Begin { Destroy }
  // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Return the Forms Toolkit instance to the pool to
  //                                           improve printing speed on future print jobs
  FormsToolkitPoolManager.ReturnToPool(FPrintToolkitI);

  InitObjs;

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

procedure TPrintJob.InitObjs;
begin
  // COM Toolkit Base Object
  FToolkit := NIL;

  // Form printing Toolkit sub-object
  FPrintToolkitI := NIL;

  // SystemPrinters sub-object
  FPrintersO := NIL;
  FPrintersI := NIL;

  // Forms list sub object
  FFormsO := NIL;
  FFormsI := NIL;

  // Email Info sub-object
  FEmailInfoO := NIL;
  FEmailInfoI := NIL;

  // Fax Info sub-object
  FFaxInfoO := NIL;
  FFaxInfoI := NIL;

  // File Info sub-object
  FFileInfoO := NIL;
  FFileInfoI := NIL;
end;

//-----------------------------------------------------------------------------

function TPrintJob.Get_pjForms: IPrintFormList;
begin
  If (Not Assigned(FFormsO)) Then Begin
    { Create and initialise the Forms list sub object }
    FFormsO := TPrintFormList.Create(Self, FPrintToolkitI.PrintJob.pjForms);

    FFormsI := FFormsO;
  End; { If (Not Assigned(FFormsO)) }

  Result := FFormsI;
end;

//----------------------------------------

function TPrintJob.Get_pjCopies: Integer;
begin
  Result := FPrintToolkitI.PrintJob.pjCopies;
end;

procedure TPrintJob.Set_pjCopies(Value: Integer);
begin
  FPrintToolkitI.PrintJob.pjCopies := Value;
end;

//----------------------------------------

function TPrintJob.Get_pjTestMode: WordBool;
begin
  Result := FPrintToolkitI.PrintJob.pjTestMode;
end;

procedure TPrintJob.Set_pjTestMode(Value: WordBool);
begin
  FPrintToolkitI.PrintJob.pjTestMode := Value;
end;

//----------------------------------------

function TPrintJob.Get_pjStartLabelNo: Integer;
begin
  Result := FPrintToolkitI.PrintJob.pjLabel1;
end;

procedure TPrintJob.Set_pjStartLabelNo(Value: Integer);
begin
  FPrintToolkitI.PrintJob.pjLabel1 := Value;
end;

//----------------------------------------

function TPrintJob.Get_pjPrinterIndex: Integer;
begin
  Result := FPrintToolkitI.PrintJob.pjPrinterIndex;
end;

procedure TPrintJob.Set_pjPrinterIndex(Value: Integer);
begin
  FPrintToolkitI.PrintJob.pjPrinterIndex := Value;
end;

//----------------------------------------

function TPrintJob.Get_pjPaperIndex: Integer;
begin
  Result := FPrintToolkitI.PrintJob.pjPaperIndex;
end;

procedure TPrintJob.Set_pjPaperIndex(Value: Integer);
begin
  FPrintToolkitI.PrintJob.pjPaperIndex := Value;
end;

//----------------------------------------

function TPrintJob.Get_pjBinIndex: Integer;
begin
  Result := FPrintToolkitI.PrintJob.pjBinIndex;
end;

procedure TPrintJob.Set_pjBinIndex(Value: Integer);
begin
  FPrintToolkitI.PrintJob.pjBinIndex := Value;
end;

//----------------------------------------

function TPrintJob.Get_pjUserId: WideString;
begin
  Result := FPrintToolkitI.PrintJob.pjUserId;
end;

procedure TPrintJob.Set_pjUserId(const Value: WideString);
begin
  FPrintToolkitI.PrintJob.pjUserId := Value;
end;

//----------------------------------------

function TPrintJob.Get_pjSystemPrinters: IPrinters;
begin
  If (Not Assigned(FPrintersO)) Then Begin
    { Create and initialise the Email Info sub-object }
    FPrintersO := TPrinters.Create(FPrintToolkitI.Printers);

    FPrintersI := FPrintersO;
  End; { If (Not Assigned(FPrintersO)) }

  Result := FPrintersI;
end;

//----------------------------------------

function TPrintJob.Get_pjEmailInfo: IPrintJobEmailInfo; 
begin
  If (Not Assigned(FEmailInfoO)) Then Begin
    { Create and initialise the Email Info sub-object }
    FEmailInfoO := TPrintJobEmailInfo.Create(Self, FPrintToolkitI.PrintJob.pjEmailInfo);

    FEmailInfoI := FEmailInfoO;
  End; { If (Not Assigned(FEmailInfoO)) }

  Result := FEmailInfoI;
end;

//----------------------------------------

function TPrintJob.Get_pjFaxInfo: IPrintJobFaxinfo;
begin
  If (Not Assigned(FFaxInfoO)) Then Begin
    { Create and initialise the Fax Info sub-object }
    FFaxInfoO := TPrintJobFaxInfo.Create(FPrintToolkitI.PrintJob.pjFaxInfo);

    FFaxInfoI := FFaxInfoO;
  End; { If (Not Assigned(FFaxInfoO)) }

  Result := FFaxInfoI;
end;

//----------------------------------------

function TPrintJob.Get_pjFileInfo: IPrintJobFileInfo;
begin
  If (Not Assigned(FFileInfoO)) Then Begin
    { Create and initialise the File Info sub-object }
    FFileInfoO := TPrintJobFileInfo.Create(FPrintToolkitI.PrintJob.pjFileInfo);

    FFileInfoI := FFileInfoO;
  End; { If (Not Assigned(FFileInfoO)) }

  Result := FFileInfoI;
end;

//-----------------------------------------------------------------------------

procedure TPrintJob.ImportDefaults;
begin
  With FPrintToolkitI.PrintJob.ImportDefaults Do Begin
    idType   := FImportDefs;
    idAcCode := FDefaultAcc;

    idMainFileNo    := FMainFNum;
    idMainIndexNo   := FMainKPath;
    idMainKeyString := FMainKRef;

    idTableFileNo    := FTablFNum;
    idTableIndexNo   := FTablKPath;
    idTableKeyString := FTablKRef;

    ImportDefaults;
  End; { With FPrintToolkitI.PrintJob.ImportDefaults }
end;

//-----------------------------------------------------------------------------

procedure TPrintJob.PrePrintStuff;
Var
  I : Integer;
Begin { PrePrintStuff }
  OutputDebug('TPrintJob.PrePrintStuff Start');
  // Check to see if a Temp DB needs to be built
  If Assigned(FCustomDataO) And ((FDefMode = fmPickListConsolidated) Or (FDefMode = fmCustomTradeHistory)) Then
  Begin
    // Build Temp DB for Consolidated Picking List (Id=1)
    With FPrintToolkitI.PrintJob.pjForms Do
      // Check that a form has been defined
      If (pfCount > 0) And (FCustomDataI.dlCount > 0) Then
        // Add the custom data into the first form - only one form supportable in this mode
        With pfForms[1] Do
          For I := 1 To FCustomDataI.dlCount Do
            With FCustomDataI.dlData[I] Do
              AddCustomData(ddFileNo, ddIndexNo, ddPosition, ddSortKey);
  End; // If Assigned(FCustomDataO) And ...
  OutputDebug('TPrintJob.PrePrintStuff End');
End; { PrePrintStuff }

//-----------------------------------------------------------------------------

function TPrintJob.PrintToPrinter: Integer;
begin
  OutputDebug('TPrintJob.PrintToPrinter Start');
  LastErDesc := '';

  PrePrintStuff;

  Result := FPrintToolkitI.PrintJob.PrintToPrinter;
  If (Result <> 0) Then
    LastErDesc := FPrintToolkitI.LastErrorString;
  OutputDebug('TPrintJob.PrintToPrinter End');
end;

//-----------------------------------------------------------------------------

function TPrintJob.PrintToTempFile(Destination: TPrintDestination): IPrintTempFile;
Var
  oFTKTempFile : IEFPrintTempFile;
  oTempFile : TPrintTempFile;
begin
  OutputDebug('TPrintJob.PrintToTempFile Start');
  // HM 15/04/03: Added handling of error strings    (b550.179)
  LastErDesc := '';

  PrePrintStuff;

  // Generate the TempFile within the Forms Toolkit
  oFTKTempFile := FPrintToolkitI.PrintJob.PrintToTempFile(Destination);

  // Create a COM Toolkit wrapper for it
  oTempFile := TPrintTempFile.Create(FPrintToolkitI, oFTKTempFile);

  // Return a reference to the interface for the CTK TempFile object
  Result := oTempFile;

  If (Result.pfStatus = 0) Then
    // Add the Temporary File into the list for deleting on shutown
    AddToDeleteList (Result.pfFileName)
  Else
    // HM 15/04/03: Added handling of error strings    (b550.179)
    LastErDesc := FPrintToolkitI.LastErrorString;

  OutputDebug('TPrintJob.PrintToTempFile End');
end;

//-----------------------------------------------------------------------------

function TPrintJob.Get_pjType: TPrintJobType;
begin
  Result := FJobType;
end;

//-----------------------------------------------------------------------------

function TPrintJob.GetFormInfo(const FormName: WideString): IFormDetails;
begin
  Result := TFormDetails.Create (FPrintToolkitI.Functions.fnGetFormInfo(FormName));
end;

//-----------------------------------------------------------------------------

function TPrintJob.PrinterSetupDialog: WordBool;
begin
  Result := FPrintToolkitI.PrintJob.PrinterSetupDialog;
end;

//-----------------------------------------------------------------------------

function TPrintJob.Get_pjCustomData: IPrintJobDataList;
begin { Get_pjCustomData }
  // Check the PrintJob Mode allows Custom Data to be specified
  If (FDefMode = fmPickListConsolidated) Or (FDefMode = fmCustomTradeHistory) Then
  Begin
    If (Not Assigned(FCustomDataO)) Then Begin
      { Create and initialise the CustomData sub-object }
      FCustomDataO := TPrintJobDataList.Create(Self, FDefMode);

      FCustomDataI := FCustomDataO;
    End; { If (Not Assigned(FCustomDataO)) }

    Result := FCustomDataI;
  End { If (FDefMode = fmPickListConsolidated) }
  Else
    Raise ENotSupported.Create ('CustomData is not available for this type of Print Job');
End; { Get_pjCustomData }

//-------------------------------------------------------------------------

//IBrowseInfo
function TPrintJob.Get_ibInterfaceMode: Integer;
begin
  Result := 16 + FDefMode;
end;

//-------------------------------------------------------------------------

// MH 18/02/2014 v7.0.9 ABSEXCH-14952: Added PrintJob Name property
function TPrintJob.Get_pjName: WideString;
Begin // Get_pjName
  Result := FPrintToolkitI.PrintJob.pjTitle;
End; // Get_pjName
procedure TPrintJob.Set_pjName(const Value: WideString);
Begin // Set_pjName
  FPrintToolkitI.PrintJob.pjTitle := Value;
End; // Set_pjName

//-------------------------------------------------------------------------

end.
