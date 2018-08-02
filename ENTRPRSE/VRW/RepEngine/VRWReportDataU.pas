unit VRWReportDataU;
{
  Visual Report Writer Report Data Reader classes.

  TVRWReportData reads and writes records in the VRWReports.DAT Btrieve data
  file. The records are mapped as a tree-structure, which this class
  understands and has methods to deal with (such as MoveUp and MoveDown, which
  move entries within the tree-structure).

  NOTES
  -----
  TVRWReportData uses multiple record locks (to allow MoveUp and MoveDown,
  which involve editing two records at the same time), so any locked records
  are not automatically unlocked when saved, and have to be explicitly unlocked
  in the Save method.

  When an Update instance is created, the current record is immediately locked
  and the position is noted. Before saving, the position is restored. This means
  that if the update instance moves away from the original record, it will be
  moved back to the original record when the Save method is called.

  This class uses the Report Engine Manager to control the opening of files,
  and must be created using an instance of the Report Engine Manager. Normally
  instances of this class should be obtained using the VRWReportData property
  of the Report Engine Manager:

    VRWReportData := oRepEngineManager.VRWReportData;
}
interface

uses SysUtils, Controls, Classes, GlobVar, VarConst, BtrvU2, VRWReportDataIF,
  RepTreeIF, oRepEngineManager, SavePos, Dialogs;

type
  TMoveChild = (mcUp, mcDown);
  // See VRWRepTreeIF.pas for interface details
  TVRWReportData = class(TInterfacedObject, IVRWReportData)
  private
    // Active index
    FIndex: Integer;
    // Editing mode: View, Add, or Update. The Add and Update modes are only
    // available through the descendant class, TVRWReportDataEditor.
    FMode: TVRWReportDataMode;
    // Reference to IRepEngineManager, which controls opening and closing of
    // data files.
    FRepManager: IRepEngineManager;
    // Record structure to hold details of current record in data file.
    FVRWReportDataRec: TVRWReportDataRec;
    // Only look for reports that this user is able to 'see'
    // if this string is empty then return all the reports in the tree
    FUserID : ShortString;
    // Access rights
    FCanEdit: Boolean;
    FCanView: Boolean;
    FShowHiddenRecords: Boolean;

    // --- Implementation of IVRWReportData interface -------------------------

    // General properties
    function GetDatapath: ShortString;
    procedure SetDatapath(const Datapath : ShortString);
    function GetIndex: Integer;
    procedure SetIndex(const Value: Integer);
    function GetUserID: ShortString;
    procedure SetUserID(const Value: ShortString);
    function GetCanView: Boolean;
    function GetCanEdit: Boolean;
    function GetShowHiddenRecords: Boolean;
    procedure SetShowHiddenRecords(const Value: Boolean);

    // Properties mapping to data fields
    // (see IVRWReportData in VRWRepTreeIF.pas for details of properties)
    function GetRtNodeType: char;
    function GetRtRepName: str50;
    function GetRtRepDesc: str255;
    function GetRtParentName: str50;
    function GetRtFileName: str80;
    function GetRtLastRun: TDateTime;
    function GetRtLastRunUser: str10;
    function GetRtPositionNumber: LongInt;

    // --- Private support routines -------------------------------------------

    // Property access
    function GetMode: TVRWReportDataMode;

    // General methods
    function GetRecord(const Key: ShortString;
                       const BtrOp: SmallInt): LongInt;

    { Deletes all the user security for the specified report }
    function DeleteSecurity(ReportName: ShortString): LongInt;

    { Returns True if the current record is visible to the user under the
      security settings and the ShowHiddenRecords property. }
    function IsVisibleToUser: Boolean;

    { Moves a child record up or down (within the child records for the
      parent). }
    function MoveChild(Direction: TMoveChild): LongInt;

    { Moves a record to a different parent. The Position Number must already
      have been set appropriately for the new parent (i.e. there must be no
      other records with the order number against this parent). }
    function MoveToParent(ParentName: string; PositionNumber: LongInt): LongInt;

    { Returns an unused position number against this parent record (i.e. a
      position number which is not currently used by any of the child records
      against this parent). }
    function FindUnusedPositionNumber(ParentName: string): Integer;

    { Swap the positions of two child records. The order of child records is
      determined by the rtPositionNumber field -- this function simply swaps the
      value of this field between the records. }
    function SwapChildRecords(Record1, Record2: IVRWReportDataEditor): LongInt;

    // --- Implementation of IVRWReportDataDebug interface -------------------
    procedure DumpReportSecurity;
    procedure DumpReportTree;

  protected

    { Attempts to lock the current record, returning 0 if successful. Also
      returns the record position in LockPosition -- this is required when
      unlocking a record. }
    function WaitForLock(var LockPosition: LongInt): LongInt;

  public
    constructor Create(RepManager: IRepEngineManager);
    destructor Destroy; override;

    // --- Implementation of IVRWReportData interface -------------------------
    // (see IVRWReportData in VRWReportDataIF.pas for details of methods)
    function Add: IVRWReportDataEditor;
    function BuildFileNameIndex(const FileName: string): str80;
    function BuildRepNameIndex(const RepName: string): str50;
    function BuildParentNameIndex(const ParentName: string;
      PositionNumber: Integer = -1): string;
    function CanPrint(const ReportName: ShortString; var NodeDesc,
      FileName: ShortString; ForToolsMenu: Boolean = False): Boolean;
    function CheckUserPermissions(const ReportName: ShortString;
      var CanEdit: boolean): boolean;
    procedure ClearFields;
    function CopyReport(const ToFileName, NewReportName, NewReportDesc: string): LongInt;
    function Delete(const ReportName: string): LongInt;
    function FileNameExists(const FileName: string): Boolean;
    function FindByFileName(const FileName: string): LongInt;
    function FindByName(const ReportName: string): LongInt;
    function FindByParent(const ParentName: string; PositionNumber: Integer = 0): LongInt;
    function GetEqual(const Key: ShortString): LongInt;
    function GetFirst: LongInt;
    function GetGreaterThanOrEqual(const Key: ShortString): LongInt;
    function GetLast: LongInt;
    function GetLastChild(const ParentName: string): LongInt;
    function GetNext: LongInt;
    function GetPrevious: LongInt;
    function GetFirstChild(const ParentName: string): LongInt;
    function GetNextChild: LongInt;
    function GetPreviousChild: LongInt;
    function GetSecurity(const ReportName: ShortString): IReportSecurity;
    function InsertAt(ParentName: string; PositionNumber: Integer): LongInt;
    function IsUnique(const ParentName: string;
      PositionNumber: Integer): Boolean;
    function MakeUniqueReportName(const ReportName: ShortString): ShortString;
    function MakeUniqueFileName(const FileName: ShortString): ShortString;
    function MoveUp: LongInt;
    function MoveDown: LongInt;
    function MoveTo(TargetName: string): LongInt;
    function Read: LongInt;
    function ReportExists(const ReportName: string): Boolean;
    function RestorePosition(const RecordPosition: LongInt): LongInt;
    function SavePosition(var RecordPosition: LongInt): LongInt;
    function Update: IVRWReportDataEditor;

    // --- Properties ---------------------------------------------------------
    // Mode (rtmView, rtmAdd, rtmUpdate)
    property Mode: TVRWReportDataMode read GetMode;

  end;

  TVRWReportDataEditor = class(TVRWReportData, IVRWReportDataEditor)
  private
    // --- Private support fields ---------------------------------------------
    FLockPosition: LongInt;
    FIsLocked: Boolean;

    // --- Implementation of IVRWReportData interface -------------------------

    // General properties
    function GetIsLocked: Boolean;

    // Properties mapping to data fields
    // (see IVRWReportData in VRWReportDataIF.pas for details of properties)
    procedure SetRtNodeType(const Value: Char);
    procedure SetRtRepName(const Value: str50);
    procedure SetRtRepDesc(const Value: str255);
    procedure SetRtParentName(const Value: str50);
    procedure SetRtFileName(const Value: str80);
    procedure SetRtLastRun(const Value: TDateTime);
    procedure SetRtLastRunUser(const Value: str10);
    procedure SetRtPositionNumber(const Value: LongInt);

    // --- Private support routines -------------------------------------------

    { Initialises the fields for a new record }
    procedure InitialiseNewReport;

    { Copies the fields from the supplied record. This is used by the Update
      to copy the fields from the record which is being updated. }
    procedure CopyFromExistingReport(ReportInfo: IVRWReportData);

    { Locks the current record. Note that although multiple record-locking is
      used, each Update instance can only lock one record (to lock multiple
      records requires an Update instance for each record). }
    function Lock: LongInt;

    { Releases the lock on the current record. }
    procedure Unlock;

  public
    constructor Create(RepManager: IRepEngineManager;
      Mode: TVRWReportDataMode; ReportInfo: IVRWReportData = nil);
    destructor Destroy; override;

    // --- Implementation of IVRWReportDataEditor interface -----------------
    function Save: LongInt;
  end;

implementation

uses Math, StrUtil, BTSupU1, oRepTreeSecurity, VRWReportIF, SysU2;

const
  // Flag used by GetRecord to indicate that a record was found, but the user
  // does not have viewing rights for it.
  RECORD_IS_HIDDEN = -1;

{ TVRWReportData }

function TVRWReportData.Add: IVRWReportDataEditor;
{ Returns an editable version of the report tree object, for adding new
  records. The returned object must subsequently either be saved (Add.Save) or
  cancelled (Add.Cancel) }
begin
  Result := TVRWReportDataEditor.Create(FRepManager, rtmAdd);
end;

function TVRWReportData.BuildFileNameIndex(const FileName: string): str80;
begin
  Result := PadString(psRight, FileName, ' ', 80);
end;

function TVRWReportData.BuildParentNameIndex(const ParentName: string;
  PositionNumber: Integer): string;
begin
  Result := PadString(psRight, ParentName, ' ', 50);
  if (PositionNumber > -1) then
    Result := Result + IntToByteStr(PositionNumber);
end;

function TVRWReportData.BuildRepNameIndex(const RepName: string): str50;
begin
  Result := PadString(psRight, RepName, ' ', 50);
end;

function TVRWReportData.CanPrint(const ReportName: ShortString;
  var NodeDesc, FileName: ShortString; ForToolsMenu: Boolean): Boolean;
{ Returns True if the user has rights to print the specified report. If so, it
  also returns the description and file name for the report }

  function CheckParentAccess(ParentName: ShortString): Boolean;
  var
    oRepSecurity: IReportSecurity;
    iUserIdx: SmallInt;
  begin
    Result := False;
    if (Trim(ParentName) = '') then
      { Found the root, user must have access }
      Result := True
    else
    begin
      if FindByName(ParentName) = 0 then
      begin
        oRepSecurity := GetReportSecurity (ParentName);
        try
          iUserIdx := oRepSecurity.IndexOf (FUserId);
          if (iUserIdx >= 0) then
          begin
            // Extract the users permission from the list
            Result := (oRepSecurity.rsPermittedUsers[iUserIdx].ursPermission <> rptHidden);
            if Result then
              Result := CheckParentAccess(FVRWReportDataRec.rtParentName);
          end;
        finally
          oRepSecurity := nil;
        end;
      end
      else
        raise Exception.Create('Group ' + ParentName + ' not found for report');
    end;
  end;

var
  oRepSecurity : IReportSecurity;
  iUserIdx     : SmallInt;
begin
  try
    oRepSecurity := GetReportSecurity (ReportName);
    try
      NodeDesc := Trim(oRepSecurity.rsReportDesc);
      FileName := Trim(oRepSecurity.rsReportFile);

      iUserIdx := oRepSecurity.IndexOf (FUserId);
      if (iUserIdx >= 0) then
      begin
        // Extract the users permission from the list
        Result := (oRepSecurity.rsPermittedUsers[iUserIdx].ursPermission <> rptHidden);
        // If the user appears to have access, and this function has been
        // called (indirectly) by the Tools menu, we need to check the parent
        // group(s), to make sure that they are not hidden. (This is not a
        // possible situation from the Report Tree, because if the group is
        // hidden, the user won't be able to see the report anyway, but it
        // *is* possible if the report is called from the Tools menu).
        if Result and ForToolsMenu then
        begin
          FindByName(ReportName);
          Result := CheckParentAccess(FVRWReportDataRec.rtParentName);
        end;
      end
      else
      begin
        // User not listed in security dialog so definately can't print
  {***
    Does this contradict the rule that if there are no permissions set for
    the user, they have full access?
  ***}
        Result := False;
      end; // Else
    finally
      oRepSecurity := NIL;
    end; // Try..Finally
  except
    on Exception do
    begin
      Result := False;
      NodeDesc := '';
      FileName := '';
    end;
  end;
end;

function TVRWReportData.CheckUserPermissions(const ReportName: ShortString;
  var CanEdit: boolean): boolean;
var
  RepPermissions: TReportPermissionType;
begin
  if GetUserPermissions(ReportName, FUserId, RepPermissions) Then
  begin
    // Permissions defined
    Result  := (RepPermissions <> rptHidden);
    CanEdit := (RepPermissions = rptShowEdit);
  end
  else
  begin
    // No permissions defined - default to full access
    Result := True;
    CanEdit := True;
  end;
end;

procedure TVRWReportData.ClearFields;
begin
  FillChar(FVRWReportDataRec, SizeOf(FVRWReportDataRec), #0);
end;

function TVRWReportData.CopyReport(const ToFileName,
  NewReportName, NewReportDesc: string): LongInt;
var
  Source, Destination : TFileStream;
  FromFileName: string;
  Adder: IVRWReportDataEditor;
  Report: IVRWReport;
begin
  { Copy the details of the current record, and add them as a new record }
  Adder := Add;
  Adder.rtNodeType    := GetRtNodeType;
  Adder.rtRepName     := NewReportName;
  Adder.rtRepDesc     := NewReportDesc;
  Adder.rtParentName  := GetRtParentName;
  Adder.rtFileName    := ToFileName;
  Adder.rtLastRun     := 0;
  Adder.rtLastRunUser := '';
  Result := Adder.Save;
  Adder := nil;
  if (Result = 0) then
  begin
    { Copy the actual report files }
    FromFileName := GetRtFileName;
    Source := TFileStream.Create( SetDrive + 'REPORTS\' + FromFileName, fmOpenRead );
    try
      Destination := TFileStream.Create( SetDrive + 'REPORTS\' + ToFileName, fmOpenWrite or fmCreate );
      try
        Destination.CopyFrom(Source, Source.Size ) ;
      finally
        Destination.Free;
      end;
    finally
      Source.Free;
    end;
    { Synchronise the report names }
    Report := RepEngineManager.VRWReport;
    try
      Report.Read(SetDrive + 'REPORTS\' + ToFileName);
      Report.vrFilename := SetDrive + 'REPORTS\' + ToFileName;
      Report.vrName := NewReportName;
      Report.vrDescription := NewReportDesc;
      Report.Write(True);
    finally
      Report := nil;
    end;
  end;
end;

constructor TVRWReportData.Create(RepManager: IRepEngineManager);
begin
  inherited Create;
  { Store a reference to the RepEngineManager object, this will hold
    the data files open until all references have been removed. }
  FRepManager := RepManager;
  FMode := rtmView;
  FShowHiddenRecords := False;
end;

function TVRWReportData.Delete(const ReportName: string): LongInt;
{ Deletes the specified report, deleting both the record in the data file,
  and the report file itself.

  If the report is actually a folder/group heading, all its child records (and
  associated report files) are also deleted. This facility is not actually used
  in the current report tree, which does not allow users to delete folders
  which still have entries in them, but it has been left for possible future
  use }
var
  ParentRecord: LongInt;
  ChildRecords: array of LongInt;
  FileName, ErrorMsg: string;
  IsLocked: Boolean;
  LastError: LongInt;
  OriginalHiddenRecordsFlag: Boolean;

  function LockParentRecord: Boolean;
  begin
    LastError := FindByName(ReportName);
    Result := (LastError = 0);
    if Result then
    begin
      LastError := WaitForLock(ParentRecord);
      Result := (LastError = 0);
    end;
  end;

  function LockChildRecords: Boolean;
  var
    Res: LongInt;
    RecordPosition: LongInt;
  begin
    Result := True;
    { Find the first child record }
    Res := FindByParent(ReportName);
    LastError := Res;
    { Attempt to lock this and all subsequent child records }
    while (Res = 0) do
    begin
      Res := WaitForLock(RecordPosition);
      if (Res <> 0) then
      begin
        LastError := Res;
        Result := False;
        Break;
      end
      else
      begin
        { Lock succeeded. Store the record position in case we need to unlock
          it later }
        SetLength(ChildRecords, Length(ChildRecords) + 1);
        ChildRecords[Length(ChildRecords) - 1] := RecordPosition;
      end;
      Res := GetNextChild;
    end;
  end;

  function DeleteChildRecords: Boolean;
{*** BUG:
  If any of the child records are folders, this function will not
  delete the records inside the folder. If the report tree is changed
  to allow non-empty folders to be deleted, this bug will have to be
  fixed. It has not been fixed for now, because the recursive deletion
  which the fix would require would mean re-designing and re-writing most
  of the Delete code.
***}
  begin
    Result := True;
    { Keep searching for child records and deleting them until no more are
      found }
    while (FindByParent(ReportName) = 0) do
    begin
      try
        LastError := DeleteSecurity(ReportName);
        if (LastError = 0) then
          LastError := Delete_Rec(F[VRWReportDataF], VRWReportDataF, FIndex);
      except
        on E:Exception do
        begin
          ShowMessage('Failed to delete record. ' + E.Message);
          Result := False;
        end;
      end;
    end;
  end;

  function DeleteParentRecord: Boolean;
  begin
    Result := True;
    { Find the main record again, and delete it }
    if (FindByName(ReportName) = 0) then
    begin
      try
        LastError := DeleteSecurity(ReportName);
        if (LastError = 0) then
          LastError := Delete_Rec(F[VRWReportDataF], VRWReportDataF, FIndex);
      except
        on E:Exception do
        begin
          ShowMessage('Failed to delete record. ' + E.Message);
          Result := False;
        end;
      end;
    end;
  end;

  function ReleaseLocks: Boolean;
  var
    Entry: Integer;
  begin
    Result := True;
    try
      { Release the parent record }
      LastError := UnlockMultiSing(F[VRWReportDataF], VRWReportDataF, ParentRecord);
    except
      { Note the fact that the release failed, but carry on anyway -- try to
        release as many locks as possible }
      on E:Exception do
      begin
        Result := False;
        ErrorMsg := E.Message;
      end;
    end;
    { Release the child records }
    for Entry := Low(ChildRecords) to High(ChildRecords) do
    begin
      try
        LastError := UnlockMultiSing(F[VRWReportDataF], VRWReportDataF, ChildRecords[Entry]);
      except
        { Note the fact that the release failed, but carry on anyway -- try to
          release as many locks as possible }
        on E:Exception do
        begin
          if (ErrorMsg = '') then
            ErrorMsg := E.Message;
          Result := False;
        end;
      end;
    end;
  end;

begin
  { Store the ShowHiddenRecords flag, and switch to show all records -- if we
    are deleting a folder, we must find and delete *all* the records, regardless
    of whether or not the current user has viewing rights to any of them. }
  OriginalHiddenRecordsFlag := FShowHiddenRecords;
  FShowHiddenRecords := True;
  { Find the record and lock it }
  IsLocked := LockParentRecord;
  { Store the filename }
  FileName := '';
  if IsLocked then
    if (GetRtNodeType = 'R') then
      FileName := Trim(GetRtFileName);
  { Lock any child records }
  if IsLocked and LockChildRecords then
  begin
    { Start a transaction }
    Ctrl_BTrans(B_BeginTrans);
    { Delete the records }
    if DeleteChildRecords and DeleteParentRecord then
    begin
      { Delete the report file }
      if (FileName <> '') then
        if FileExists(SetDrive + 'REPORTS\' + FileName) then
          DeleteFile(SetDrive + 'REPORTS\' + FileName);
      { Commit transaction }
      Ctrl_BTrans(B_EndTrans);
    end
    else
    begin
      { If the delete fails, some records might have been left locked, so
        try to unlock them now }
      if not ReleaseLocks then
      begin
        ShowMessage('Some records could not be unlocked after a ' +
                    'failed deletion' + #13#10#13#10 +
                    ErrorMsg);
      end;
      { Roll back transaction }
      Ctrl_BTrans(B_AbortTrans);
    end;
  end;
  FShowHiddenRecords := OriginalHiddenRecordsFlag;
  Result := LastError;
end;

function TVRWReportData.DeleteSecurity(ReportName: ShortString): LongInt;
{ Deletes all the security records associated with the specified report. This
  is used when deleting a report. }
var
  Key: ShortString;
  Res, DeleteRes: LongInt;
  RecFound, RecLocked: Boolean;
begin
  Result := 0;
  with TBtrieveSavePosition.Create do
  begin
    try
      // Save the current position in the file for the current key
      SaveDataBlock (@RTSecurity, SizeOf(RTSecurity));
      SaveFilePosition (RTSecurityF, GetPosKey);
      // Find and delete the records
      Key := BuildRepNameIndex(ReportName);
      repeat
        { Find the first security record for the report }
        Res := Find_Rec(B_GetGEq, F[RTSecurityF], RTSecurityF, RecPtr[RTSecurityF]^, RTSecReportIdx, Key);
        { Delete the security records until no more can be found for this
          report }
        if (Trim(RTSecurity.rtsTreeCode) = Trim(ReportName)) then
        begin
          RecFound := GetMultiRec(B_GetDirect, B_SingLock, Key, RTSecReportIdx, RTSecurityF, True, RecLocked);
          if (RecFound and RecLocked) then
          begin
            DeleteRes := Delete_Rec(F[RTSecurityF], RTSecurityF, RTSecUserIdx);
            if (DeleteRes <> 0) then
            begin
              MessageDlg ('Error ' + IntToStr(DeleteRes) +
                          ' occurred deleting the security for ' +
                          Trim(ReportName) +
                          ', please notify your Technical Support',
                          mtError, [mbOK], 0);
              Res := DeleteRes;
              Result := DeleteRes;
            end;
          end;
          if (Res = 0) then
            Res := Find_Rec(B_GetGEq, F[RTSecurityF], RTSecurityF, RecPtr[RTSecurityF]^, RTSecReportIdx, Key);
        end
        else
          Res := 9; // End of file
      until (Res <> 0);
      // Restore position in file
      RestoreSavedPosition;
      RestoreDataBlock (@RTSecurity);
    finally
      Free;
    end; // Try..Finally
  end; // With TBtrieveSavePosition.Create
end;

destructor TVRWReportData.Destroy;
begin
  { Remove the reference to the RepEngineManager object allowing the
    data files to be closed if no other references are in existence. }
  FRepManager := nil;
  inherited;
end;

procedure TVRWReportData.DumpReportSecurity;
var
  sKey    : ShortString;
  lStatus : SmallInt;
begin // DumpReportSecurity
  with TStringList.Create Do
  begin
    try
      Add ('"RepCode","UserCode","Permission"');

      lStatus := Find_Rec(B_GetFirst, F[RTSecurityF], RTSecurityF, RecPtr[RTSecurityF]^, RTSecUserIdx, sKey);
      while (lStatus = 0) do
      begin
        Add ('"' + Trim(RTSecurity.rtsTreeCode) + '","' +
                   Trim(RTSecurity.rtsUserCode) + '","' +
                   IntToStr(Ord(RTSecurity.rtsSecurity)) + '"');

        lStatus := Find_Rec(B_GetNext, F[RTSecurityF], RTSecurityF, RecPtr[RTSecurityF]^, RTSecUserIdx, sKey);
      end; // While (lStatus = 0)

      // Save to disc
      with TOpenDialog.Create(nil) do
      begin
        try
          Filter := 'CSV files (*.csv)|*.CSV|All files (*.*)|*.*';
          DefaultExt := 'CSV';

          if Execute Then
            SaveToFile(FileName);
        finally
          Free;
        end; // Try..Finally
      end; // With TOpenDialog.Create
    finally
      Free;
    end; // Try..Finally
  end; // With TStringList.Create
end;

procedure TVRWReportData.DumpReportTree;
var
  sKey    : ShortString;
  lStatus : SmallInt;
begin
  with TStringList.Create Do
  begin
    try
      Add ('"Type","ParentId","RepName","RepDesc","ERF Filename","Last Run"');

      lStatus := Find_Rec(B_GetFirst, F[VRWReportDataF], VRWReportDataF, RecPtr[VRWReportDataF]^, rtIdxRepName, sKey);
      While (lStatus = 0) Do
      Begin
        Add ('"' + VRWReportDataRec.rtNodeType + '","' +
                   QuotedStr(VRWReportDataRec.rtParentName) + '","' +
                   QuotedStr(VRWReportDataRec.rtRepName) + '","' +
                   VRWReportDataRec.rtRepDesc + '","' +
                   VRWReportDataRec.rtFileName + '","' +
                   VRWReportDataRec.rtLastRunUser + '"');

        lStatus := Find_Rec(B_GetNext, F[VRWReportDataF], VRWReportDataF, RecPtr[VRWReportDataF]^, rtIdxRepName, sKey);
      End;

      // Save to disc
      With TOpenDialog.Create(NIL) Do
      Begin
        Try
          Filter := 'CSV files (*.csv)|*.CSV|All files (*.*)|*.*';
          DefaultExt := 'CSV';

          If Execute Then
          Begin
            SaveToFile(FileName);
          End; // If Execute
        Finally
          Free;
        End; // Try..Finally
      End; // With TOpenDialog.Create
    Finally
      Free;
    End; // Try..Finally
  End; // With TStringList.Create
end;

function TVRWReportData.FileNameExists(const FileName: string): Boolean;
var
  StoredPosition, StoredIndex: LongInt;
  Res: LongInt;
  StoredRec: TVRWReportDataRec;
  OriginalHiddenRecordsFlag: Boolean;
begin
  { We must check against all records, even those which the user does not have
    viewing rights for }
  OriginalHiddenRecordsFlag := FShowHiddenRecords;
  FShowHiddenRecords := True;
  { Store the current data file position and data }
  SavePosition(StoredPosition);
  StoredIndex := FIndex;
  StoredRec   := FVRWReportDataRec;
  try
    Res := FindByFileName(FileName);
    Result := (Res = 0);
  finally
    { Restore the data and the original position in the data file }
    SetIndex(StoredIndex);
    RestorePosition(StoredPosition);
    FVRWReportDataRec := StoredRec;
    { Reset the ShowHiddenRecords flag to its original value }
    FShowHiddenRecords := OriginalHiddenRecordsFlag;
  end;
end;

function TVRWReportData.FindByFileName(const FileName: string): LongInt;
var
  SearchKey: string;
  StoredIndex: Integer;
begin
  StoredIndex := FIndex;

  SetIndex(rtIdxFileName);
  SearchKey := BuildFileNameIndex(FileName);
  Result := GetEqual(SearchKey);

  FIndex := StoredIndex;

  if (Result = 0) then
    Read;
end;

function TVRWReportData.FindByName(const ReportName: string): LongInt;
var
  SearchKey: string;
  StoredIndex: Integer;
begin
  StoredIndex := FIndex;

  SetIndex(rtIdxRepName);
  SearchKey := BuildRepNameIndex(ReportName);
  Result := GetEqual(SearchKey);

  FIndex := StoredIndex;

  if (Result = 0) then
    Read;
end;

function TVRWReportData.FindByParent(const ParentName: string;
  PositionNumber: Integer): LongInt;
var
  SearchKey: string;
  StoredIndex: Integer;
begin
  StoredIndex := FIndex;

  SetIndex(rtIdxParentName);
  SearchKey := BuildParentNameIndex(ParentName, PositionNumber);
  { If a position number was specified, find the record which matches the
    position number }
  if (PositionNumber > 0) then
    Result := GetEqual(SearchKey)
  else
  begin
    { If no position number was specified, locate the first record against
      the specified parent }
    Result := GetGreaterThanOrEqual(SearchKey);
    if (Result = 0) then
    begin
      if (Trim(FVRWReportDataRec.rtParentName) <> Trim(ParentName)) then
        Result := 4;  // Record not found;
    end;
  end;

  FIndex := StoredIndex;

  if (Result = 0) then
    Read;
end;

function TVRWReportData.FindUnusedPositionNumber(ParentName: string): Integer;
var
  StoredPosition, StoredIndex: LongInt;
  Res: LongInt;
  StoredRec: TVRWReportDataRec;
  OriginalHiddenRecordsFlag: Boolean;
begin
  { We must check against all records, even those which the user does not have
    viewing rights for }
  OriginalHiddenRecordsFlag := FShowHiddenRecords;
  FShowHiddenRecords := True;
  { Store the current data file position and data }
  SavePosition(StoredPosition);
  StoredIndex := FIndex;
  StoredRec   := FVRWReportDataRec;
  try
    Res := GetLastChild(ParentName);
    if (Res = 0) then
      Result := FVRWReportDataRec.rtPositionNumber + 1
    else
      Result := 1;
  finally
    { Restore the data and the original position in the data file }
    SetIndex(StoredIndex);
    RestorePosition(StoredPosition);
    FVRWReportDataRec := StoredRec;
    { Reset the ShowHiddenRecords flag to its original value }
    FShowHiddenRecords := OriginalHiddenRecordsFlag;
  end;
end;

function TVRWReportData.GetCanEdit: Boolean;
begin
  Result := FCanEdit;
end;

function TVRWReportData.GetCanView: Boolean;
begin
  Result := FCanView;
end;

function TVRWReportData.GetDatapath: ShortString;
begin
  { Get the datapath as stored in the Report Engine Manager. }
  Result := FRepManager.DataDirectory;
end;

function TVRWReportData.GetEqual(const Key: ShortString): LongInt;
begin
  Result := GetRecord(Key, B_GetEq);
end;

function TVRWReportData.GetFirst: LongInt;
begin
  Result := GetRecord('', B_GetFirst);
  while (Result = RECORD_IS_HIDDEN) do
    Result := GetRecord('', B_GetNext);
end;

function TVRWReportData.GetFirstChild(const ParentName: string): LongInt;
var
  SearchKey: string;
begin
  SetIndex(rtIdxParentName);
  SearchKey := BuildParentNameIndex(ParentName);
  Result := GetRecord(SearchKey, B_GetGEq);
  while (Result = RECORD_IS_HIDDEN) do
    Result := GetRecord('', B_GetNext);
  { If we have gone past the last child record against this parent, return an
    end-of-file value. }
  if (Result = 0) and (SearchKey <> GetRtParentName) then
    Result := 9;
end;

function TVRWReportData.GetGreaterThanOrEqual(
  const Key: ShortString): LongInt;
begin
  Result := GetRecord(Key, B_GetGEq);
  while (Result = RECORD_IS_HIDDEN) do
    Result := GetRecord('', B_GetNext);
end;

function TVRWReportData.GetIndex: Integer;
begin
  Result := FIndex;
end;

function TVRWReportData.GetLast: LongInt;
begin
  Result := GetRecord('', B_GetLast);
  while (Result = RECORD_IS_HIDDEN) do
    Result := GetRecord('', B_GetPrev);
end;

function TVRWReportData.GetLastChild(const ParentName: string): LongInt;
var
  SearchKey: string;
  OriginalParentName: string;
begin
  SetIndex(rtIdxParentName);
  OriginalParentName := PadString(psRight, ParentName, ' ', 50);
  SearchKey := BuildParentNameIndex(ParentName, 65535);
  Result := GetRecord(SearchKey, B_GetLessEq);
  while (Result = RECORD_IS_HIDDEN) do
    Result := GetRecord('', B_GetPrev);
  { If we have gone past the first child record against this parent, return an
    end-of-file value. }
//  if (Result = 0) and (SearchKey <> ParentName) then
  if (Result = 0) and (GetRtParentName <> OriginalParentName) then
    Result := 9;
end;

function TVRWReportData.GetMode: TVRWReportDataMode;
begin
  Result := FMode;
end;

function TVRWReportData.GetNext: LongInt;
begin
  repeat
    Result := GetRecord('', B_GetNext);
  until not (Result = RECORD_IS_HIDDEN);
end;

function TVRWReportData.GetNextChild: LongInt;
var
  ParentKey: string;
begin
  SetIndex(rtIdxParentName);
  { Get the parent name of the current record }
  ParentKey := BuildParentNameIndex(GetRtParentName);
  { Move to the next record }
  repeat
    Result := GetRecord('', B_GetNext);
  until not (Result = RECORD_IS_HIDDEN);
  { If we have gone past the last child record against the parent, return an
    end-of-file value. }
  if (Result = 0) and (ParentKey <> GetRtParentName) then
    Result := 9;
end;

function TVRWReportData.GetPrevious: LongInt;
begin
  repeat
    Result := GetRecord('', B_GetPrev);
  until not (Result = RECORD_IS_HIDDEN);
end;

function TVRWReportData.GetPreviousChild: LongInt;
var
  ParentKey: string;
begin
  SetIndex(rtIdxParentName);
  { Get the parent name of the current record }
  ParentKey := BuildParentNameIndex(GetRtParentName);
  repeat
    Result := GetRecord('', B_GetPrev);
  until not (Result = RECORD_IS_HIDDEN);
  { If we have gone past the first child record against the parent, return an
    end-of-file value. }
  if (Result = 0) and (ParentKey <> GetRtParentName) then
    Result := 9;
end;

function TVRWReportData.GetRecord(const Key: ShortString;
  const BtrOp: SmallInt): LongInt;
var
  SearchKey: ShortString;
begin
  Result := -1;
  if Assigned(FRepManager) and (FRepManager.DataDirectory <> '') then
  begin
    SearchKey := Key;
    { Locate the record in the Reports Tree file. If this succeeds, the field
      values will be in the internal FVRWReportDataRec record. }
    Result := Find_Rec(BtrOp,
                       F[VRWReportDataF],
                       VRWReportDataF,
                       FVRWReportDataRec,
                       FIndex,
                       SearchKey);
    if (Result = 0) then
      FCanView := CheckUserPermissions(FVRWReportDataRec.rtRepName, FCanEdit);
    if (Result = 0) and not IsVisibleToUser then
      // Record exists, but user does not have view rights.
      Result := RECORD_IS_HIDDEN;
  end;
end;

function TVRWReportData.GetRtFileName: str80;
begin
  Result := FVRWReportDataRec.rtFileName;
end;

function TVRWReportData.GetRtLastRun: TDateTime;
begin
  Result := FVRWReportDataRec.rtLastRun;
end;

function TVRWReportData.GetRtLastRunUser: str10;
begin
  Result := FVRWReportDataRec.rtLastRunUser;
end;

function TVRWReportData.GetRtNodeType: char;
begin
  Result := FVRWReportDataRec.rtNodeType;
end;

function TVRWReportData.GetRtParentName: str50;
begin
  Result := FVRWReportDataRec.rtParentName;
end;

function TVRWReportData.GetRtPositionNumber: LongInt;
begin
  Result := FVRWReportDataRec.rtPositionNumber;
end;

function TVRWReportData.GetRtRepDesc: str255;
begin
  Result := FVRWReportDataRec.rtRepDesc;
end;

function TVRWReportData.GetRtRepName: str50;
begin
  Result := FVRWReportDataRec.rtRepName;
end;

function TVRWReportData.GetSecurity(
  const ReportName: ShortString): IReportSecurity;
begin
  Result := GetReportSecurity(ReportName);
end;

function TVRWReportData.GetShowHiddenRecords: Boolean;
begin
  Result := FShowHiddenRecords;
end;

function TVRWReportData.GetUserID: ShortString;
begin
  Result := FUserID;
end;

function TVRWReportData.InsertAt(ParentName: string;
  PositionNumber: Integer): LongInt;
var
  InitialPositionNumber: Integer;
  OriginalHiddenRecordsFlag: Boolean;
begin
  { Find the next unused order number against this folder... }
  InitialPositionNumber := FindUnusedPositionNumber(ParentName);
  { ...and move the record. }
  Result := MoveToParent(ParentName, InitialPositionNumber);
  { Read the new details. }
  Read;
  { Now compare the initial position number with the required position
    number, and move the record up or down as required until the
    position numbers match.

    [ NOTE: this might seem inefficient, but inserting a record at a specific
      position number requires us to change the position numbers of other
      records, which is all that MoveUp and MoveDown do anyway. ]
  }
  if (InitialPositionNumber <> PositionNumber) then
  begin
    OriginalHiddenRecordsFlag := FShowHiddenRecords;
    FShowHiddenRecords := True;
    if (PositionNumber < InitialPositionNumber) then
    begin
      while (FVRWReportDataRec.rtPositionNumber > PositionNumber) and
            (Result = 0) do
        Result := MoveUp;
    end
    else
    begin
      while (FVRWReportDataRec.rtPositionNumber < PositionNumber) and
            (Result = 0) do
        Result := MoveDown;
    end;
    FShowHiddenRecords := False;
  end;
end;

function TVRWReportData.IsUnique(const ParentName: string;
  PositionNumber: Integer): Boolean;
{ Returns True if there are no records which have the combined Parent Name
  and Position Number }
var
  StoredPosition, StoredIndex: LongInt;
  Res: LongInt;
  StoredRec: TVRWReportDataRec;
  OriginalHiddenRecordsFlag: Boolean;
begin
  { We must check against all records, even those which the user does not have
    viewing rights for }
  OriginalHiddenRecordsFlag := FShowHiddenRecords;
  FShowHiddenRecords := True;
  { Store the current data file position and data }
  SavePosition(StoredPosition);
  StoredIndex := FIndex;
  StoredRec   := FVRWReportDataRec;
  try
    Res := FindByParent(ParentName, PositionNumber);
    Result := (Res <> 0);
  finally
    { Restore the original position }
    SetIndex(StoredIndex);
    RestorePosition(StoredPosition);
    FVRWReportDataRec := StoredRec;
    { Reset the ShowHiddenRecords flag to its original value }
    FShowHiddenRecords := OriginalHiddenRecordsFlag;
  end;
end;

function TVRWReportData.IsVisibleToUser: Boolean;
{ Returns True if the current user has view rights for the current record. If
  the ShowHiddenRecords flag is set to True this function will always return
  True. }
var
  CanEdit: Boolean;
begin
  if FShowHiddenRecords then
    Result := True
  else
    Result := CheckUserPermissions(GetRtRepName, CanEdit);
end;

function TVRWReportData.MakeUniqueFileName(
  const FileName: ShortString): ShortString;
var
  BaseFileName, NewFileName: ShortString;
  ExtNumber, CharPos: Integer;
  Extension: string;
begin
  { Check that the file name is not already unique. If it is, we don't
    need to change it }
  if not FileNameExists(FileName) then
  begin
    Result := FileName;
    Exit;
  end;

  { Split the file name into the base name and the extension }
  CharPos := Pos('.', FileName);
  if (CharPos = 0) then
    CharPos := Length(FileName) + 1;
  Extension := Copy(FileName, CharPos + 1, Length(FileName));
  BaseFileName  := Trim(Copy(FileName, 1, CharPos - 1));

  { Remove any numeric digits from the end of the supplied file name, to
    create a base file name }
  while ((BaseFileName[Length(BaseFileName)] in ['0'..'9']) and
         (Length(BaseFileName) > 0)) do
    System.Delete(BaseFileName, Length(BaseFileName), 1);

  { Set an 'ExtNumber' counter -- this will be converted to a string and
    added to the end of the base file name }
  ExtNumber := 0;

  repeat
    { Increment the 'ExtNumber' counter each time that we find a File
      already existing against the new File name }
    ExtNumber := ExtNumber + 1;

    { Construct the full File name }
    NewFileName := Format(BaseFileName + ' %.3d.' + Extension, [ExtNumber]);
  until not FileNameExists(NewFileName);

  Result := NewFileName;
end;

function TVRWReportData.MakeUniqueReportName(
  const ReportName: ShortString): ShortString;
var
  BaseReportName, NewReportName, BaseNumberStr: ShortString;
  ExtNumber: Integer;
begin
  { Check that the report name is not already unique. If it is, we don't
    need to change it }
  if not ReportExists(ReportName) then
  begin
    Result := ReportName;
    Exit;
  end;

  { Remove and store any numeric digits from the end of the supplied report
    name, to create a base report name and a starting extension. }
  BaseNumberStr  := '';
  BaseReportName := ReportName;
  while ((BaseReportName[Length(BaseReportName)] in ['0'..'9']) and
         (Length(BaseReportName) > 0)) do
  begin
    BaseNumberStr := BaseReportName[Length(BaseReportName)] + BaseNumberStr;
    System.Delete(BaseReportName, Length(BaseReportName), 1);
  end;

  { Set an 'ExtNumber' counter -- this will be converted to a string and
    added to the end of the base report name. If a number was found at the
    end of the supplied report name, use this number as the starting point
    for the name extension. }
  if (BaseNumberStr <> '') then
    ExtNumber := StrToIntDef(BaseNumberStr, 0)
  else
    ExtNumber := 0;

  repeat
    { Increment the 'ExtNumber' counter each time that we find a report
      already existing against the new report name }
    ExtNumber := ExtNumber + 1;

    { Construct the full report name }
    NewReportName := BaseReportName + IntToStr(ExtNumber);
  until not ReportExists(NewReportName);

  Result := NewReportName;
end;

function TVRWReportData.MoveChild(Direction: TMoveChild): LongInt;
var
  StoredPosition: Integer;
  CurrentUpdater, NextUpdater: IVRWReportDataEditor;
begin
  { Save the current position }
  SavePosition(StoredPosition);
  { Create an Update object for the current record. }
  CurrentUpdater := Update;
  try
    { Go to the next record, and create an Update object for it. }
    case Direction of
      mcUp:   Result := GetPreviousChild;
      mcDown: Result := GetNextChild;
    else
      Result := -99;  // Should never happen -- there are only two possible
                      // values for Direction.
    end;
    if (Result = 0) then
    begin
      NextUpdater := Update;
      { Swap the order numbers, and save the records. }
      Result := SwapChildRecords(CurrentUpdater, NextUpdater);
    end;
  finally
    CurrentUpdater := nil;
    NextUpdater    := nil;
    { Restore the original record position }
    RestorePosition(StoredPosition);
    Read;
  end;
end;

function TVRWReportData.MoveDown: LongInt;
begin
  Result := MoveChild(mcDown);
end;

function TVRWReportData.MoveTo(TargetName: string): LongInt;
var
  Res, StoredPosition, StoredIndex: LongInt;
  PositionNumber: Integer;
  TargetRec: TVRWReportDataRec;
  IsRoot: Boolean;

  function FindTargetRecord: Boolean;
  begin
    { Find the target record and read the details. }
    SavePosition(StoredPosition);
    StoredIndex := FIndex;
    try
      Res := FindByName(TargetName);
      if (Res = 0) then
      begin
        TargetRec := FVRWReportDataRec;
        Result := True;
      end
      else
        Result := False;
    finally
      SetIndex(StoredIndex);
      RestorePosition(StoredPosition);
      Read;
    end;
  end;

begin
  IsRoot := (Trim(TargetName) = '');
  if IsRoot or FindTargetRecord then
  begin
    { If TargetName references a folder: }
    if IsRoot or (TargetRec.rtNodeType = 'H') then
    begin
      { If TargetName is the same as ParentName, do not move the record (i.e.
        do not move the record back into the same folder) }
      if (not IsRoot) and
         (TargetRec.rtRepName = FVRWReportDataRec.rtParentName) then
      begin
        Result := 0;
        Exit;
      end;
      { Otherwise, find the next unused order number against this folder... }
      PositionNumber := FindUnusedPositionNumber(TargetName);
      { ...and move the record. }
      Result := MoveToParent(TargetName, PositionNumber);
    end
    else
    begin
      { Add the node as a sibling. }
      PositionNumber := FindUnusedPositionNumber(TargetRec.rtRepName);
      { ...and move the record. }
      Result := MoveToParent(TargetRec.rtParentName, PositionNumber);
      if (Result = 0) then
        while (FVRWReportDataRec.rtPositionNumber > TargetRec.rtPositionNumber) do
          Result := MoveUp;
    end;
  end
  else
    Result := 4;  // Btrieve error: record not found
end;

function TVRWReportData.MoveToParent(ParentName: string;
  PositionNumber: Integer): LongInt;
var
  Updater: IVRWReportDataEditor;
begin
  Updater := Update;
  Updater.rtParentName  := ParentName;
  Updater.rtPositionNumber := PositionNumber;
  Result := Updater.Save;
  Updater := nil;
end;

function TVRWReportData.MoveUp: LongInt;
begin
  Result := MoveChild(mcUp);
end;

function TVRWReportData.Read: LongInt;
var
  RecordPos: LongInt;
begin
  { Get the current record number into RecordPos. }
  Result := GetPos(F[VRWReportDataF], VRWReportDataF, RecordPos);
  if (Result = 0) then
  begin
    { Use GetDirect to force a re-read of the data into the internal record. }
    Move(RecordPos, FVRWReportDataRec, SizeOf(RecordPos));
    Result := GetDirect(F[VRWReportDataF],
                        VRWReportDataF,
                        FVRWReportDataRec,
                        FIndex, 0);
  end;
end;

function TVRWReportData.ReportExists(const ReportName: string): Boolean;
var
  StoredPosition, StoredIndex: LongInt;
  Res: LongInt;
  StoredRec: TVRWReportDataRec;
  OriginalHiddenRecordsFlag: Boolean;
begin
  { We must check against all records, even those which the user does not have
    viewing rights for }
  OriginalHiddenRecordsFlag := FShowHiddenRecords;
  FShowHiddenRecords := True;
  { Store the current data file position and data }
  SavePosition(StoredPosition);
  StoredIndex := FIndex;
  StoredRec   := FVRWReportDataRec;
  try
    Res := FindByName(ReportName);
    Result := (Res = 0);
  finally
    { Restore the data and the data file position }
    SetIndex(StoredIndex);
    RestorePosition(StoredPosition);
    FVRWReportDataRec := StoredRec;
    { Reset the ShowHiddenRecords flag to its original value }
    FShowHiddenRecords := OriginalHiddenRecordsFlag;
  end;
end;

function TVRWReportData.RestorePosition(const RecordPosition: LongInt): LongInt;
var
  KeyPos: longint;
begin
  KeyPos := RecordPosition;
  Result := Presrv_BTPos(VRWReportDataF, FIndex, F[VRWReportDataF], KeyPos, True, False);
end;

function TVRWReportData.SavePosition(var RecordPosition: LongInt): LongInt;
begin
  Result := Presrv_BTPos(VRWReportDataF, FIndex, F[VRWReportDataF], RecordPosition, False, False);
end;

procedure TVRWReportData.SetDatapath(const Datapath: ShortString);
begin
  { Pass the datapath on to the Report Engine Manager. }
  FRepManager.DataDirectory := IncludeTrailingPathDelimiter(Datapath);
end;

procedure TVRWReportData.SetIndex(const Value: Integer);
var
  RecordPos: LongInt;
begin
  if (Value <> FIndex) then
  begin
    { Save the current position in the data file. }
    RecordPos := GetPos(F[VRWReportDataF], VRWReportDataF, RecordPos);
    { Change the index. }
    FIndex := Value;
    { Restore the position, using the current index. }
    Btrvu2.GetDirect(F[VRWReportDataF], VRWReportDataF, FVRWReportDataRec, FIndex, 0);
  end;
end;

procedure TVRWReportData.SetShowHiddenRecords(const Value: Boolean);
begin
  FShowHiddenRecords := Value;
end;

procedure TVRWReportData.SetUserID(const Value: ShortString);
begin
  FUserID := Value;

  // MH 31/03/2011 v6.7 ABSEXCH-10689: Modified to load user permissions
  //EntryRec^.Login := Value; // Populate SYSLUSER field
  If Not GetLogInRec(Value) Then
    EntryRec^.Login := 'UNKNOWN';
end;

function TVRWReportData.SwapChildRecords(Record1,
  Record2: IVRWReportDataEditor): LongInt;

  function SaveBoth: LongInt;
  var
    Res1, Res2: LongInt;
  begin
    Result := 0;
    Ctrl_BTrans(B_BeginTrans);
    try
      Res1 := Record1.Save;
      Res2 := Record2.Save;
      if ((Res1 + Res2) = 0) then
        { Successful save of both records -- commit the transaction }
        Ctrl_BTrans(B_EndTrans)
      else
      begin
        { One or other save failed }
        Result := Max(Res1, Res2);
        { Roll back the transaction }
        Ctrl_BTrans(B_AbortTrans);
      end;
    except
      on Exception do
      begin
        Ctrl_BTrans(B_AbortTrans);
        raise;
      end;
    end;
  end;

var
  PositionNumber1, PositionNumber2: Integer;
begin
  { Read the order numbers... }
  PositionNumber1 := Record1.rtPositionNumber;
  PositionNumber2 := Record2.rtPositionNumber;
  { ...and write them into the opposite records. }
  Record1.rtPositionNumber := PositionNumber2;
  Record2.rtPositionNumber := PositionNumber1;
  { Save the records. }
  Result := SaveBoth;
end;

function TVRWReportData.Update: IVRWReportDataEditor;
begin
  Result := TVRWReportDataEditor.Create(FRepManager, rtmUpdate, self);
end;

function TVRWReportData.WaitForLock(var LockPosition: LongInt): LongInt;
const
  Msg = 'Record is locked by another user';
begin
  Result := GetPos(F[VRWReportDataF], VRWReportDataF, LockPosition);
  if (Result <> 0) then
    ShowMessage('Unable to locate record for locking')
  else
  repeat
    Move(LockPosition, FVRWReportDataRec, SizeOf(LockPosition));
    Result := GetDirect(F[VRWReportDataF],
                        VRWReportDataF,
                        FVRWReportDataRec,
                        FIndex,
                        B_MultNWLock);
    if (Result = 84) then
    begin
      { Record is locked. }
      if (MessageDlg(Msg, mtWarning, [mbRetry, mbCancel], 0) = mrCancel) then
        Exit;
    end
    else if (Result <> 0) then
      { Some other error occurred -- exit straight away. }
      Exit;
  until (Result = 0);
end;

{ TVRWReportDataEditor }

procedure TVRWReportDataEditor.CopyFromExistingReport(
  ReportInfo: IVRWReportData);
begin
  SetRtNodeType(ReportInfo.rtNodeType);
  SetRtRepName(ReportInfo.rtRepName);
  SetRtRepDesc(ReportInfo.rtRepDesc);
  SetRtParentName(ReportInfo.rtParentName);
  SetRtFileName(ReportInfo.rtFileName);
  SetRtLastRun(ReportInfo.rtLastRun);
  SetRtLastRunUser(ReportInfo.rtLastRunUser);
  SetRtPositionNumber(ReportInfo.rtPositionNumber);
end;

constructor TVRWReportDataEditor.Create(RepManager: IRepEngineManager;
  Mode: TVRWReportDataMode; ReportInfo: IVRWReportData);
begin
  inherited Create(RepManager);
  { Store a reference to the RepEngineManager object, this will hold
    the data files open until all references have been removed. }
  FRepManager := RepManager;
  { Set up the object according to the requested mode: add or update. 'Add'
    will clear all the fields. 'Update' will copy the fields from the passed
    in report tree details, and will lock the record. }
  FMode := Mode;
  FIsLocked := False;
  if (Mode = rtmAdd) then
    InitialiseNewReport
  else
  begin
    SetIndex(ReportInfo.Index);
    Lock;
    CopyFromExistingReport(ReportInfo);
  end;
end;

destructor TVRWReportDataEditor.Destroy;
begin
  if FIsLocked then
    Unlock;
  inherited;
end;

function TVRWReportDataEditor.GetIsLocked: Boolean;
begin
  Result := FIsLocked;
end;

procedure TVRWReportDataEditor.InitialiseNewReport;
begin
  ClearFields;
  { Clear the string fields -- the Set methods will pad them to the correct
    number of spaces, so that any fields which are left empty and are required
    by indexes will be padded correctly. }
  SetRtRepName('');
  SetRtRepDesc('');
  SetRtParentName('');
  SetRtFileName('');
  SetRtLastRunUser('');
end;

function TVRWReportDataEditor.Lock: LongInt;
begin
  if (not FIsLocked) then
  begin
    Result := WaitForLock(FLockPosition);
    FIsLocked := (Result = 0);
  end
  else
    Result := 0;  // Record is already locked
end;

function TVRWReportDataEditor.Save: LongInt;
var
  PositionNumber: Integer;
begin
  Result := -1;
  case Mode of
    rtmAdd:
      begin
        { Every child record has a position number that specifies the order in
          which the child records should appear. For the current parent record,
          find a position which is not currently used by any of its child
          records. }
        PositionNumber := FindUnusedPositionNumber(GetRtParentName);
        SetRtPositionNumber(PositionNumber);
        Result := Add_Rec(F[VRWReportDataF],
                          VRWReportDataF,
                          FVRWReportDataRec,
                          FIndex);
      end;
    rtmUpdate:
      begin
        if FIsLocked then
        begin
          { Make sure we are on the locked record, then save it. }
          RestorePosition(FLockPosition);
          Result := Put_Rec(F[VRWReportDataF],
                            VRWReportDataF,
                            FVRWReportDataRec,
                            FIndex);
          { Release record lock. }
          Unlock;
        end;
      end;
  end;
end;

procedure TVRWReportDataEditor.SetRtFileName(const Value: str80);
begin
  FVRWReportDataRec.rtFileName := PadString(psRight, Value, ' ', 80);
end;

procedure TVRWReportDataEditor.SetRtLastRun(const Value: TDateTime);
begin
  FVRWReportDataRec.rtLastRun := Value;
end;

procedure TVRWReportDataEditor.SetRtLastRunUser(const Value: str10);
begin
  FVRWReportDataRec.rtLastRunUser := PadString(psRight, Value, ' ', 10);
end;

procedure TVRWReportDataEditor.SetRtNodeType(const Value: Char);
begin
  FVRWReportDataRec.rtNodeType := Value;
end;

procedure TVRWReportDataEditor.SetRtParentName(const Value: str50);
begin
  FVRWReportDataRec.rtParentName := PadString(psRight, Value, ' ', 50);
end;

procedure TVRWReportDataEditor.SetRtPositionNumber(const Value: Integer);
begin
  FVRWReportDataRec.rtPositionNumber := Value;
end;

procedure TVRWReportDataEditor.SetRtRepDesc(const Value: str255);
begin
  FVRWReportDataRec.rtRepDesc := PadString(psRight, Value, ' ', 255);
end;

procedure TVRWReportDataEditor.SetRtRepName(const Value: str50);
begin
  FVRWReportDataRec.rtRepName := PadString(psRight, Value, ' ', 50);
end;

procedure TVRWReportDataEditor.Unlock;
begin
  UnlockMultiSing(F[VRWReportDataF], VRWReportDataF, FLockPosition);
end;

end.


