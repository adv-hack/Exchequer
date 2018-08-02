unit oRepEngineManager;

interface

Uses Windows, Classes, RepTreeIF, RepEngIF, VRWReportDataIF, VRWReportIF,
  VRWConverterIF;

Type
  // Generic interface for objects which implement a specific import type
  IRepEngineManager = Interface
    ['{C01B7002-943A-442A-85EE-286BBAAAFD01}']

    // --- Internal Methods to implement Public Properties ---
    Function GetDataDirectory : ShortString;
    Procedure SetDataDirectory (Value : ShortString);
//    Function GetReportEngine : IReport_Interface;
    Function GetReportTree : IReportTree_Interface;
    function GetVRWReportData: IVRWReportData;
    function GetVRWReport: IVRWReport;
    function GetVRWConverter: IVRWConverter;

    // ------------------ Public Properties ------------------
    Property DataDirectory : ShortString Read GetDataDirectory Write SetDataDirectory;
//    Property ReportEngine : IReport_Interface Read GetReportEngine;
    Property ReportTree : IReportTree_Interface Read GetReportTree;
    property VRWReportData: IVRWReportData read GetVRWReportData;
    property VRWReport: IVRWReport read GetVRWReport;
    property VRWConverter: IVRWConverter read GetVRWConverter;

    // ------------------- Public Methods --------------------
    procedure SuppressVRWImport;

  End; // IRepEngineManager

procedure KeepResponding;
function RepEngineManager : IRepEngineManager;

implementation

Uses Dialogs, SysUtils, GlobVar, VarConst, BtrvU2, oRepTree, RptPersist,
     BTSupU1, BTSupU2, EntLicence, {oRepEngine, }RWOpenF, History, APIUtil,
     VRWReportDataU, VRWReportU, VRWConverterU,
{$IFDEF EXSQL}
     SQLUtils,
{$ENDIF}
{$IFDEF EX600}
     FileUtil,
{$ENDIF}
     ShellApi,

     //PR: 03/02/2014 ABSEXCH-19474
     AccountContactVar,

     OrderPaymentsVar,
     ADOConnect;

Type
  TRepEngineManager = Class(TInterfacedObject, IRepEngineManager)
  Private
    ImportRequired: Boolean;
    ImportAllowed: Boolean;
    Procedure CheckTree;
    Procedure CheckTreeSecurity;
    procedure CheckVRWTree;
    Procedure CloseDataFiles;
    Procedure ErrorLog (Const Msg : ShortString);

    // IRepEngineManager
    Function GetDataDirectory : ShortString;
    Procedure SetDataDirectory (Value : ShortString);
//    Function GetReportEngine : IReport_Interface;
    Function GetReportTree : IReportTree_Interface;
    function GetVRWReportData: IVRWReportData;
    function GetVRWReport: IVRWReport;
    function GetVRWConverter: IVRWConverter;
  Public
    constructor Create;
    destructor Destroy; Override;
    procedure SuppressVRWImport;
  End; // TRepEngineManager

Var
  lRepEngineManager : TRepEngineManager;
  // Random number in range 1-999 used to group log files for a session together
  iUser : SmallInt;
  FilesOpen: Boolean;
  LastPeekMessageTime: Cardinal = 0;

//=========================================================================

procedure KeepResponding;
{ Call this procedure to prevent Windows from reporting the app as 'not
  responding' if it is doing a lengthy process }
var
  Msg: TMsg;
begin
  if GetTickCount <> LastPeekMessageTime then
  begin
    PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE);
    LastPeekMessageTime := GetTickCount;
  end;
end;

//=========================================================================

Function RepEngineManager : IRepEngineManager;
Begin // RepEngineManager
  If (Not Assigned(lRepEngineManager)) Then
  Begin
    lRepEngineManager := TRepEngineManager.Create;
  End; // If (Not Assigned(lRepEngineManager))

  Result := lRepEngineManager;
End; // RepEngineManager

//=========================================================================

Constructor TRepEngineManager.Create;
Begin // Create
  Inherited Create;
  ImportRequired := False;
  ImportAllowed  := True;
  SetDrive := '';
End; // Create

//------------------------------

Destructor TRepEngineManager.Destroy;
Begin // Destroy
  // Reset the local object reference so it can't be accidentally used
  // whilst the object is destroying or afterit has finished destroying
  lRepEngineManager := NIL;

  // Close any open data files
  CloseDataFiles;

  Inherited Destroy;
End; // Destroy

//------------------------------

Procedure TRepEngineManager.CloseDataFiles;
Var
  iFile : Byte;
Begin // CloseDataFiles
  For iFile := 1 To 20 Do
  Begin
    If (iFile In [1..15, DictF, ReportTreeF..RTSecurityF]) Then
    Begin
      // Close the Report Tree Security data file
      Close_File(F[iFile]);
    End; // If (iFile In [1..15, DictF, ReportTreeF..RTSecurityF])
  End; // For iFile
End; // CloseDataFiles

//-------------------------------------------------------------------------

Function TRepEngineManager.GetDataDirectory : ShortString;
Begin // GetDataDirectory
  Result := SetDrive;
End; // GetDataDirectory
Procedure TRepEngineManager.SetDataDirectory (Value : ShortString);
var
  Importer: IReportTreeConverter;
Begin // SetDataDirectory
  If (Value <> SetDrive) Then
  Begin
    // Close any open data files - don't want to start losing file handles
    if FilesOpen then
      CloseDataFiles;

    SetDrive := Value;

    // Check the VRW specific files exist - create if missing
    CheckTree;
    CheckTreeSecurity;
    CheckVRWTree;

    // Open Data Files
    Open_System(1,15);                      // Standard Enterprise files
    Open_System(25,25);                      // Standard Enterprise files

    //PR: 13/02/2012 Open Qty Break file ABSEXCH-9795
    Open_System(26,26);

    //PR: 03/02/2014 Open AccountContact files
    Open_System(AccountContactF, AccountContactRoleF);

    //PR: 14/10/2014 Order Payments
    Open_System(OrderPaymentsF, OrderPaymentsF);


    If SQLUtils.UsingSQL Then
      InitialiseGlobalADOConnection(SetDrive);


{$IFDEF EX600}

    { Open DICTNARY.DAT in the main company }
    SetDrive := GetEnterpriseDirectory;
    try
      Open_System(DictF,DictF);               // Data Dictionary
    finally
      SetDrive := Value;
    end;
    Open_System(RTSecurityF,VRWReportDataF);   // Report Tree, Tree Security

{$ELSE}
    Open_System(DictF,DictF);               // Data Dictionary
    Open_System(ReportTreeF,VRWReportDataF);   // Report Tree, Tree Security
{$ENDIF}

    FilesOpen := True;
    
    if ImportRequired and ImportAllowed then
    begin
      Importer := (GetReportTree as IReportTreeConverter);
      try
        Importer.Import;
      finally
        Importer := nil
      end;
      // Import report details from old style report tree.
//      (GetReportTree as IReportTreeConverter).Import;
    end;

    // Load System Setup vars
    Set_SDefDecs;
    Init_AllSys;
    Init_STDCurrList;

    // Set global licencing vars
    With EnterpriseLicence Do
    Begin
      // Generate the Version Id Number for the Report Writer to identify Data
      // Dictionary fields
      // 1   STD
      // 2   STD+STK
      // 3   Prof
      // 4   Prof+STK
      // 5   Prof+SPOP
      // 6   Prof+SPOP+JC
      // 7   MC
      // 8   MC+STK
      // 9   MC+SPOP
      // 10  *** Not Used ***
      // 11  MC+SPOP+JC
      If elIsMultiCcy Then
      Begin
        If (elModules[ModJobCost] <> mrNone) Then
          ExVersionNo := 11
        Else
          ExVersionNo := 7 + Ord(elModuleVersion);
      End // If elIsMultiCcy
      Else
      Begin
        If (elModules[ModJobCost] <> mrNone) Then
          ExVersionNo := 6
        Else
          ExVersionNo := 3 + Ord(elModuleVersion);
      End; // Else

      ExMultiCcy  := elIsMultiCcy;

      EuroVers := (elCurrencyVersion = cvEuro);

      RepWrtOn := (elModules[modVisualRW] <> mrNone);
      JBCostOn := (elModules[modJobCost] <> mrNone);
      TeleSModule := (elModules[modTeleSale] <> mrNone);
      eCommsModule := (elModules[modPaperless] <> mrNone);
      eBusModule := (elModules[modEBus] <> mrNone);
      CommitAct := (elModules[modCommit] <> mrNone);
      AnalCuStk := (elModules[modAccStk] <> mrNone);
      FullWOP := (elModules[modProWOP] <> mrNone);
      STDWOP := (elModules[modStdWOP] <> mrNone);
      WOPOn := FullWOP Or STDWOP;
      FullStkSysOn := (elModules[modFullStock] <> mrNone);
      CISOn := (elModules[modCISRCT] <> mrNone);
      EnSecurity := (elModules[modEnhSec] <> mrNone);
    End; // With EnterpriseLicence
  End; // If (Value <> SetDrive)
End; // SetDataDirectory

//-------------------------------------------------------------------------

Procedure TRepEngineManager.ErrorLog (Const Msg : ShortString);
Var
  sLogDir, sFileName : ShortString;
  iFile              : SmallInt;
Begin // ErrorLog
  // Check the Logs directory exists
  sLogDir := IncludeTrailingPathDelimiter(SetDrive) + 'Logs\';
  If (Not DirectoryExists(sLogDir)) Then
  Begin
    ForceDirectories (sLogDir);
  End; // If (Not DirectoryExists(sLogDir))

  // Generate a unique filename within the directory
  For iFile := 1 To 9999 Do
  Begin
    sFileName := 'E' + IntToStr(iUser) + IntToStr(iFile) + '.Log';
    If (Not FileExists(sLogDir + sFileName)) Then
    Begin
      With TStringList.Create Do
      Begin
        Try
          Add ('Exchequer Visual Report Writer Engine ' + RepEngineVer);
          Add (FormatDateTime ('DD/MM/YY - HH:MM:SS', Now) +
                     '    Computer: ' +  WinGetComputerName +
                     '    User: ' +  WinGetUserName);
          Add ('---------------------------------------------------------------');
          Add (Msg);

          SaveToFile (sLogDir + sFileName);
        Finally
          Free;
        End; // Try..Finally
      End; // With TStringList.Create
      Break;
    End; // With TStringList.Create
  End; // For iFile
End; // ErrorLog


//-------------------------------------------------------------------------

Procedure TRepEngineManager.CheckTree;
Var
  iStatus : SmallInt;
  i: Integer;
  ErrorList: TStringList;
  Filename: string;

  //------------------------------

  Procedure BuildReportFileList;
  var
    rSearchRec    : TSearchRec;
    ReportPersist : TReportPersistor;
    lResult       : LongInt;
  begin
    lResult := FindFirst(SetDrive + 'REPORTS\' + '*.ERF', faAnyFile, rSearchRec);
    Try
      While (lResult = 0) Do
      Begin
        ReportPersist := TReportPersistor.Create(rSearchRec.Name, SetDrive + 'REPORTS\' );
        Try
          ReportPersist.ReadReportFile;

          FillChar (ReportTreeRec, SizeOf(ReportTreeRec), #0);
          With ReportTreeRec Do
          Begin
            ReportTreeRec.DiskFileName := rSearchRec.Name;
            ReportTreeRec.ReportName := ReportPersist.ReportName;
            ReportTreeRec.ReportDesc := ReportPersist.ReportDescription;

            BranchType := 'R';
            ParentID := FullNodeIDKey('0');
            ChildID := FullNodeIDKey('0');
            LastRunDetails := '';
          End; // With ReportTreeRec
          Add_Rec(F[ReportTreeF],ReportTreeF,RecPtr[ReportTreeF]^,TreeParentIDK);
        Finally
          ReportPersist.Free;
        End; // Try..Finally

        lResult := FindNext(rSearchRec);
      End; // While (lResult = 0)
    Finally
      FindClose(rSearchRec);
    End; // Try..Finally
  end; // BuildReportFileList

  //------------------------------

  Procedure BuildVRWReportFileList;
  var
    rSearchRec    : TSearchRec;
    ReportPersist : TReportPersistor;
    lResult       : LongInt;
    Report        : IVRWReport;
  begin
    lResult := FindFirst(SetDrive + 'REPORTS\' + '*.ERF', faAnyFile, rSearchRec);
    Report := GetVRWReport;
    Try
      While (lResult = 0) Do
      Begin
        try
          Report.Read(SetDrive + 'REPORTS\' + rSearchRec.Name);

          ReportTreeRec.DiskFileName := rSearchRec.Name;
          ReportTreeRec.ReportName := Report.vrName;
          ReportTreeRec.ReportDesc := Report.vrDescription;

          ReportTreeRec.BranchType := 'R';
          ReportTreeRec.ParentID := FullNodeIDKey('0');
          ReportTreeRec.ChildID := FullNodeIDKey('0');
          ReportTreeRec.LastRunDetails := '';

          Add_Rec(F[ReportTreeF],ReportTreeF,RecPtr[ReportTreeF]^,TreeParentIDK)
        except
          on E:Exception do
            ErrorList.Add('Could not import ' + rSearchRec.Name + ' ' + E.Message);
        end;
        lResult := FindNext(rSearchRec);
      End; // While (lResult = 0)
    Finally
      Report := nil;
      FindClose(rSearchRec);
    End; // Try..Finally
  end; // BuildReportFileList

  //------------------------------

Begin // CheckTree
{$IFDEF EXSQL}
  if (not SQLUtils.TableExists(SetDrive + FileNames[ReportTreeF])) then
{$ELSE}
  If (Not FileExists(SetDrive + FileNames[ReportTreeF])) Then
{$ENDIF}
  Begin
    iStatus := Make_File(F[ReportTreeF], SetDrive + FileNames[ReportTreeF], FileSpecOfs[ReportTreeF]^, FileSpecLen[ReportTreeF]);
    If (iStatus = 0) Then
    Begin
      ErrorList := TStringList.Create;
      try
        // Import existing reports
        Open_System(ReportTreeF, ReportTreeF);
        Try
          BuildVRWReportFileList;
        Finally
          Close_File(F[ReportTreeF]);
        End; // Try..Finally

        // Write Log File as this is a security loophole
        ErrorLog ('Report Tree Data File Missing - New File Created');
        if (ErrorList.Count > 0) then
        begin
          Filename := SetDrive + 'REPORTS\Error.txt';
          ErrorList.SaveToFile(Filename);
          ShellExecute(0, 'open', PChar(Filename), '', '', SW_NORMAL);
        end;
      finally
        ErrorList.Free;
      end;
    End // If (iStatus = 0)
    Else
      MessageDlg ('An error ' + IntToStr(iStatus) + ' occurred while creating the Report Tree data file, ' +
                  SetDrive + FileNames[ReportTreeF] + ', ' +
                  'please notify your technical support', mtError, [mbOK], 0);
  End; // If (Not FileExists(FDataSetPath + FileNames[ReportTreeF]))
End; // CheckTree

//------------------------------

Procedure TRepEngineManager.CheckTreeSecurity;
Var
  iStatus : SmallInt;
Begin // CheckTreeSecurity
{$IFDEF EXSQL}
  if (not SQLUtils.TableExists(SetDrive + FileNames[RTSecurityF])) then
{$ELSE}
  If (Not FileExists(SetDrive + FileNames[RTSecurityF])) Then
{$ENDIF}
  Begin
    iStatus := Make_File(F[RTSecurityF], SetDrive + FileNames[RTSecurityF], FileSpecOfs[RTSecurityF]^, FileSpecLen[RTSecurityF]);
    If (iStatus = 0) Then
    Begin
      // Write Log File as this is a security loopwhole
      ErrorLog ('Report Tree Security Data File Missing - New File Created');
    End // If (iStatus = 0)
    Else
      MessageDlg ('An error ' + IntToStr(iStatus) + ' occurred while creating the Report Tree Security data file, ' +
                  'please notify your technical support', mtError, [mbOK], 0);
  End; // If (Not FileExists(FDataSetPath + FileNames[RTSecurityF]))
End; // CheckTreeSecurity

//-------------------------------------------------------------------------
{
Function TRepEngineManager.GetReportEngine : IReport_Interface;
Begin // GetReportEngine
  // Pass this instance into the TReportEngine object as an IRepEngineManager
  // interface causing the reference count to be incremented.  When all
  // reference counts are removed this object will be destroyed closing
  // the data files.
  Result := TReportEngine.Create(Self);
End; // GetReportEngine
}
//-------------------------------------------------------------------------

Function TRepEngineManager.GetReportTree : IReportTree_Interface;
Begin // GetReportTree
  // Pass this instance into the TReportTree object as an IRepEngineManager
  // interface causing the reference count to be incremented.  When all
  // reference counts are removed this object will be destroyed closing
  // the data files.
  Result := TReportTree.Create(Self);
End; // GetReportTree

function TRepEngineManager.GetVRWReportData: IVRWReportData;
begin
  // Pass this instance into the TVRWReportData object as an IRepEngineManager
  // interface causing the reference count to be incremented.  When all
  // reference counts are removed this object will be destroyed closing
  // the data files.
  Result := TVRWReportData.Create(self);
end;

function TRepEngineManager.GetVRWReport: IVRWReport;
begin
  Result := TVRWReport.Create(self);
end;

//-------------------------------------------------------------------------

procedure TRepEngineManager.CheckVRWTree;
Var
  iStatus : SmallInt;
Begin // CheckVRWTree
{$IFDEF EXSQL}
  if (not SQLUtils.TableExists(SetDrive + FileNames[VRWReportDataF])) then
{$ELSE}
  If (Not FileExists(SetDrive + FileNames[VRWReportDataF])) Then
{$ENDIF}
  Begin
    iStatus := Make_File(F[VRWReportDataF], SetDrive + FileNames[VRWReportDataF], FileSpecOfs[VRWReportDataF]^, FileSpecLen[VRWReportDataF]);
    If (iStatus = 0) Then
    Begin
      ImportRequired := True;
      // Write Log File as this is a security loopwhole
      ErrorLog ('VRW Report Tree Data File Missing - New File Created');
    End // If (iStatus = 0)
    Else
      MessageDlg ('An error ' + IntToStr(iStatus) + ' occurred while creating the VRW Report Tree data file, ' +
                  'please notify your technical support', mtError, [mbOK], 0);
  End; // If (Not FileExists(FDataSetPath + FileNames[VRWReportData]))
end;

procedure TRepEngineManager.SuppressVRWImport;
begin
  ImportAllowed := False;
end;

function TRepEngineManager.GetVRWConverter: IVRWConverter;
begin
  Result := TVRWConverter.Create;
end;

Initialization
  Randomize;
  iUser := Random(998) + 1;  // Generate random Id in range 1-999
  FilesOpen := False;
end.
