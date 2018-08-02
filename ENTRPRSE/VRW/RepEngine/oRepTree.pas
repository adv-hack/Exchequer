Unit oRepTree;

Interface

Uses Windows, Classes, Dialogs, SysUtils, ShellAPI,
     GlobVar, VarConst, BtrvU2, RepTreeIF, oRepEngineManager,
     VRWReportDataIF;

Type
  IReportTreeConverter = Interface
  ['{3DAB9679-11C2-42A9-AF40-3D4E312969A9}']
    { Main entry point -- imports a report tree file from the old format }
    procedure Import;
    { Property access }
    function GetHasImportErrors: Boolean;
    { Properties }
    property HasImportErrors: Boolean
      read GetHasImportErrors;
  end;

  TReportTree = class (TInterfacedObject,
                       IReportTree_Interface,
                       IRWReportTree_Interface,
                       IReportTreeConverter,
                       IReportTreeDebug )
  private

    { Internal object for accessing the Report Tree data. The methods in the
      TReportTree class will map down into calls to methods in this object.

      This is to maintain backwards compatibility. The TReportTree class has
      now been superceded by TVRWReportData. }
    FReportData: IVRWReportData;

    // only look for reports that this user is able to 'see'
    // if this string is empty then return all the reports in the tree
    FUserID : ShortString;

    FTreeNodeName,
    FTreeNodeDesc : ShortString;

    ssKeyS : ShortString;

    slFilesToDelete : TStringList;

    FKeyPath : Integer;

    // Log file, currently used only for reporting import errors
    FLog: TStringList;
    FHasImportErrors: Boolean;

    // Reference to RepEngineManager object used to control the closing of
    // the data files.
    FRepManager : IRepEngineManager;

    // Checks the users permissions to see the report, returns TRUE if the user
    // can see the report.  CanEdit is set depending on whether the user is allowed
    // to edit the report
    function CheckUserFile(const ssReportID : ShortString; var CanEdit : boolean) : boolean;

    procedure DeleteBranch(const ssBranchID : ShortString);

    // Generic access function called by GetFirstReport, etc...
    function GetRecord(const Key : shortstring;
                       Const BtrOp : SmallInt;
                       var   TreeNodeType, TreeNodeName, TreeNodeDesc,
                             TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
                       var AllowEditReport : boolean ) : LongInt;

    // Reads the report details from the current record. All fields except
    // TreeNodeParent will be blank if the report file cannot be found.
    procedure ReadRecord(var TreeNodeType, TreeNodeName, TreeNodeDesc,
                             TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
                         var AllowEditReport : boolean);
  protected
    // IReportTree_Interface ------------------------------------------------
    procedure SetDataPath(const DataPath : ShortString);
    function GetTreeSecurity : ShortString;
    procedure SetTreeSecurity(const UserID : ShortString);
    function GetFirstReport(var TreeNodeType, TreeNodeName, TreeNodeDesc,
                                TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
                            var AllowEditReport : boolean) : LongInt; stdcall;
    function GetNextReport(var TreeNodeType, TreeNodeName, TreeNodeDesc,
                                TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
                           var AllowEditReport : boolean) : LongInt; stdcall;
    function GetNext(var TreeNodeType, TreeNodeName, TreeNodeDesc,
                         TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
                     var AllowEditReport : boolean) : LongInt; stdcall;
    function GetGEqual(const Key : ShortString;
                         var TreeNodeType, TreeNodeName, TreeNodeDesc,
                             TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
                         var AllowEditReport : boolean) : LongInt; stdcall;
    function RestorePosition(const iPos : longint) : Longint; stdcall;
    function SavePosition(var iPos : longint) : Longint; stdcall;

    // IRWReportTree_Interface ----------------------------------------------
    function GetNodeName : ShortString;
    procedure SetNodeName(const ssNodeName : ShortString);
    function GetNodeDescription : ShortString;
    function AddTreeNode(const TreeNodeType, TreeNodeName, TreeNodeDesc,
                               TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString) : LongInt; stdcall;
    function EditTreeNode(const TreeNodeType, TreeNodeName, TreeNodeDesc,
                               TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString) : LongInt; stdcall;
    function CopyTreeNode(const TreeNodeType, TreeNodeName, TreeNodeDesc,
                               TreeNodeParent, TreeNodeChild,
                               OldFileName, NewFileName, LastRun : ShortString) : LongInt; stdcall;
    function DeleteTreeNode(const TreeNodeType, TreeNodeName : ShortString) : LongInt; stdcall;

    // Used by the Report Engine to get the report details for printing, returns
    // TRUE if the user is allowed to print the report
    Function GetReportForPrinting(Const NodeName : ShortString; Var NodeDesc, FileName : ShortString) : Boolean;

    // Returns a security object for the specified report
    Function GetSecurity(Const ReportCode : ShortString) : IReportSecurity;

    // IReportTreeDebug -----------------------------------------------------
    Procedure DumpReportSecurity;
    Procedure DumpReportTree;

    // IReportTreeConverter -------------------------------------------------
    procedure Import;
    function GetHasImportErrors: Boolean;
  public
//    property CompanyDataSetPath : ShortString write SetDataPath;
//    property ReportTreeSecurity : ShortString read GetTreeSecurity write SetTreeSecurity;
//
//    property NodeName : ShortString read GetNodeName write SetNodeName;
//    property NodeDescription : ShortString read GetNodeDescription;

    Constructor Create (RepManager : IRepEngineManager);
    Destructor Destroy; override;

    function FindRecordName(RecordID: ShortString): ShortString;
    procedure ParseLastRun(const LastRunDetails: ShortString;
                           var LastRunDate: TDateTime;
                           var LastRunUser: ShortString);
    // Import support routines
    function GetImportRecord(const Key: ShortString; BtrOp: SmallInt): LongInt;
    function GetFirstForImport: LongInt;
    function GetNextForImport: LongInt;
    function SaveImportPosition(var iPos: LongInt;
      var SaveRec: TReportTreeFRec): LongInt;
    function RestoreImportPosition(var iPos: LongInt;
      var SaveRec: TReportTreeFRec): LongInt;
    function ValidateImport(DataHandler: IVRWReportData;
      RecordDetails: IVRWReportDataEditor): Boolean;
    function IsOwnParent(ReportData: IVRWReportData): Boolean;
    procedure OnImportError(ErrorMsg: string);
    procedure ClearLog;
    procedure AddToLog(LogMsg: string);
    procedure ShowLog;
  end;


Implementation

uses
  RptPersist, oRepTreeSecurity, SavePos, StrUtil;

//=========================================================================

constructor TReportTree.Create (RepManager : IRepEngineManager);
begin
  inherited Create;

  // Store a reference to the RepEngineManager object, this will hold
  // the data files open until all references have been removed
  FRepManager := RepManager;
  FReportData := FRepManager.VRWReportData;
  FReportData.Index := rtIdxParentName;
  FUserID := '';
  FLog := TStringList.Create;
end;

//------------------------------

destructor TReportTree.Destroy;
begin // Destroy
  // Remove the reference to the IVRWReportData instance.
  FReportData := nil;

  // Remove the reference to the RepEngineManager object allowing the
  // data files to be closed if no other references are in existence
  FRepManager := nil;

  // Remove the log string-list
  FLog.Free;

  inherited Destroy;
end; // Destroy

//-------------------------------------------------------------------------

procedure TReportTree.SetDataPath(const DataPath : ShortString);
begin
  FReportData.Datapath := DataPath;
end;

//------------------------------

function TReportTree.GetTreeSecurity : ShortString;
begin
  Result := FReportData.UserID;
end;

procedure TReportTree.SetTreeSecurity(const UserID : ShortString);
begin
  FReportData.UserID := USerID;
end;

//------------------------------

function TReportTree.GetNodeName : ShortString;
begin
  Result := FReportData.rtRepName;
end;

procedure TReportTree.SetNodeName(const ssNodeName : ShortString);
begin
  raise Exception.Create('Report name (NodeName) is read-only');
//  FTreeNodeName := ssNodeName;
end;

function TReportTree.GetNodeDescription : ShortString;
begin
  Result := FReportData.rtRepDesc;
end;

//-------------------------------------------------------------------------

procedure TReportTree.ReadRecord(var TreeNodeType, TreeNodeName,
  TreeNodeDesc, TreeNodeParent, TreeNodeChild, FileName,
  LastRun: ShortString; var AllowEditReport: boolean);
begin
  TreeNodeType := Trim(FReportData.rtNodeType);
  TreeNodeName := Trim(FReportData.rtRepName);
  TreeNodeDesc := Trim(FReportData.rtRepDesc);
  TreeNodeChild  := Trim(FReportData.rtRepName);
  if (Trim(FReportData.rtParentName) = '') then
    TreeNodeParent := '0'
  else
    TreeNodeParent := Trim(FReportData.rtParentName);
  FileName := Trim(FReportData.rtFileName);
  if (FReportData.rtLastRun = 0) then
    LastRun := ''
  else
    LastRun := DateToStr(FReportData.rtLastRun) + ' by ' +
               FReportData.rtLastRunUser;
  AllowEditReport := FReportData.CanEdit;
end;

function TReportTree.GetRecord(const Key : shortstring;
                               Const BtrOp : SmallInt;
                               var   TreeNodeType, TreeNodeName, TreeNodeDesc,
                                     TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
                                 var AllowEditReport : boolean ) : LongInt;
{*** OBSOLETE ***}
var
  CanEditReport,
  RecordToReturn : boolean;
  lBtrvError : LongInt;
begin
  lBtrvError := -1;
  If Assigned (FRepManager) And (FRepManager.DataDirectory <> '') Then
  Begin
    ssKeyS := Key;
    // read record from report names file.
    lBtrvError := Find_Rec(BtrOp, F[ReportTreeF], ReportTreeF, RecPtr[ReportTreeF]^, TreeParentIDK, ssKeyS);

    RecordToReturn := FALSE;
    if (lBtrvError = 0) then
    begin
      With ReportTreeRec Do
      Begin
        FTreeNodeName := trim(ReportName);
        FTreeNodeDesc := trim(ReportDesc);
        TreeNodeParent := trim(ParentID);

        // Check recport security for user
        If CheckUserFile(FTreeNodeName, CanEditReport) Then
        begin
          TreeNodeType := BranchType[1];
          TreeNodeName := trim(ReportName);
          TreeNodeDesc := trim(ReportDesc);
          //TreeNodeParent := trim(ParentID);
          TreeNodeChild := trim(ChildID);
          FileName := trim(DiskFileName);
          LastRun := trim(LastRunDetails);

          AllowEditReport := CanEditReport;

          RecordToReturn := TRUE;
        End; // If CheckUserFile(FTreeNodeName, CanEditReport)
      End; // With ReportTreeRec
    end; // while ((lBtrvError = 0) and (not(RecordToReturn))) do...

    if RecordToReturn then
      Result := 0
    else
    begin
      TreeNodeType := '';
      TreeNodeName := '';
      TreeNodeDesc := '';
      //TreeNodeParent := '';
      TreeNodeChild := '';
      FileName := '';
      LastRun := '';
      AllowEditReport := FALSE;

      Result := lBtrvError;
    end;
  End // If Assigned (FRepManager) And (FRepManager.DataDirectory <> '')
  Else
    Result := lBtrvError;
end;

//------------------------------

function TReportTree.GetFirstReport(var TreeNodeType, TreeNodeName, TreeNodeDesc,
                                        TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
                                    var AllowEditReport : boolean ) : LongInt;
Begin // GetFirstReport
  Result := FReportData.GetFirst;
  TreeNodeType := FReportData.rtNodeType;
  TreeNodeName := Trim(FReportData.rtRepName);
  TreeNodeDesc := Trim(FReportData.rtRepDesc);
  TreeNodeParent := Trim(FReportData.rtParentName);
  TreeNodeChild  := Trim(FReportData.rtRepName);
  FileName := Trim(FReportData.rtFileName);
  if (FReportData.rtLastRun = 0) then
    LastRun := ''
  else
    LastRun := DateToStr(FReportData.rtLastRun) + ' by ' +
               Trim(FReportData.rtLastRunUser);
  AllowEditReport := FReportData.CanEdit;
End; // GetFirstReport

//------------------------------

function TReportTree.GetNextReport(var TreeNodeType, TreeNodeName, TreeNodeDesc,
                                       TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
                                   var AllowEditReport : boolean ) : LongInt;
begin
  Result := FReportData.GetFirst;
  TreeNodeType := FReportData.rtNodeType;
  TreeNodeName := Trim(FReportData.rtRepName);
  TreeNodeDesc := Trim(FReportData.rtRepDesc);
  TreeNodeParent := Trim(FReportData.rtParentName);
  TreeNodeChild  := Trim(FReportData.rtRepName);
  FileName := Trim(FReportData.rtFileName);
  if (FReportData.rtLastRun = 0) then
    LastRun := ''
  else
    LastRun := DateToStr(FReportData.rtLastRun) + ' by ' +
               FReportData.rtLastRunUser;
  AllowEditReport := FReportData.CanEdit;
end;

//------------------------------

function TReportTree.GetNext(var TreeNodeType, TreeNodeName, TreeNodeDesc,
                                 TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
                             var AllowEditReport : boolean ) : LongInt;
begin
  Result := FReportData.GetNext;
  ReadRecord(TreeNodeType, TreeNodeName, TreeNodeDesc, TreeNodeParent,
             TreeNodeChild, FileName, LastRun, AllowEditReport);
end;

//------------------------------

function TReportTree.GetGEqual(const Key : shortstring;
                                 var TreeNodeType, TreeNodeName, TreeNodeDesc,
                                     TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
                                 var AllowEditReport : boolean ) : LongInt;
var
  SearchKey: ShortString;
begin // GetGEqual
  if (Key = '0') then
    SearchKey := ''
  else
    SearchKey := Key;
  Result := FReportData.GetGreaterThanOrEqual(SearchKey);
  ReadRecord(TreeNodeType, TreeNodeName, TreeNodeDesc, TreeNodeParent,
             TreeNodeChild, FileName, LastRun, AllowEditReport);
end; // GetGEqual

//-------------------------------------------------------------------------

function TReportTree.SavePosition(var iPos : longint) : Longint;
begin
  Result := FReportData.SavePosition(iPos);
end;

//------------------------------

function TReportTree.RestorePosition(const iPos : longint) : Longint;
begin
  Result := FReportData.RestorePosition(iPos);
end;

//-------------------------------------------------------------------------

// Checks the users permissions to see the report, returns TRUE if the user
// can see the report.  CanEdit is set depending on whether the user is allowed
// to edit the report
function TReportTree.CheckUserFile(const ssReportID: ShortString;
  var CanEdit: Boolean): Boolean;
begin
  Result := FReportData.CheckUserPermissions(ssReportID, CanEdit);
end;

//-------------------------------------------------------------------------

function TReportTree.AddTreeNode(const TreeNodeType, TreeNodeName, TreeNodeDesc,
                                    TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString) : LongInt;
var
  Add: IVRWReportDataEditor;
  LastRunDate: TDateTime;
  LastRunUser: ShortString;
begin
  Add := FReportData.Add;
  Add.rtNodeType := TreeNodeType[1];
  Add.rtRepName  := Trim(TreeNodeName);
  Add.rtRepDesc  := Trim(TreeNodeDesc);
  Add.rtParentName := Trim(TreeNodeParent);
  Add.rtFileName   := Trim(FileName);

  ParseLastRun(LastRun, LastRunDate, LastRunUser);

  Add.rtLastRun     := LastRunDate;
  Add.rtLastRunUser := Trim(LastRunUser);

  Result := Add.Save;
end;

function TReportTree.CopyTreeNode(const TreeNodeType, TreeNodeName, TreeNodeDesc,
                                        TreeNodeParent, TreeNodeChild,
                                        OldFileName, NewFileName, LastRun : ShortString) : LongInt;
begin
  Result := FReportData.CopyReport(NewFileName, TreeNodeName, TreeNodeDesc);
end;

function TReportTree.EditTreeNode(const TreeNodeType, TreeNodeName, TreeNodeDesc,
                                     TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString) : LongInt;
var
  lBtrvError : LongInt;
  ssKeyS : ShortString;

  Update: IVRWReportDataEditor;
  LastRunDate: TDateTime;
  LastRunUser: ShortString;
begin
  Result := 0;
  if FReportData.FindByName(TreeNodeName) = 0 then
  begin
    Update := FReportData.Update;
    Update.rtNodeType := TreeNodeType[1];
    Update.rtRepName  := Trim(TreeNodeName);
    if (Trim(TreeNodeDesc) <> '') then
      Update.rtRepDesc := Trim(TreeNodeDesc);
    Update.rtParentName := Trim(TreeNodeParent);
    Update.rtFileName   := Trim(FileName);

    ParseLastRun(LastRun, LastRunDate, LastRunUser);

    Update.rtLastRun     := LastRunDate;
    Update.rtLastRunUser := LastRunUser;

    Result := Update.Save;
  end;
end;

function TReportTree.DeleteTreeNode(const TreeNodeType, TreeNodeName : ShortString) : LongInt;
begin
  Result := FReportData.Delete(TreeNodeName);
end;

procedure TReportTree.DeleteBranch(const ssBranchID : ShortString);
{*** OBSOLETE ***}
var
  lBtrvError : LongInt;
  ssKeyS : ShortString;
  ssChildID : ShortString;
begin
  lBtrvError := 0;
  ssKeyS := '';

  lBtrvError := Find_Rec(B_GetFirst, F[ReportTreeF], ReportTreeF, RecPtr[ReportTreeF]^, TreeParentIDK, ssKeyS);
  while ((lBtrvError = 0) and (trim(ReportTreeRec.ParentID) <> trim(ssBranchID))) do
    lBtrvError := Find_Rec(B_GetNext, F[ReportTreeF], ReportTreeF, RecPtr[ReportTreeF]^, TreeParentIDK, ssKeyS);

  while ((lBtrvError = 0) and (trim(ReportTreeRec.ParentID) = trim(ssBranchID))) do
  begin
    ssChildID := ReportTreeRec.ChildID;
    if (trim(ssChildID) <> '0') then
      DeleteBranch(ssChildID);

    if (lBtrvError = 0) then
    begin
      if (UpperCase(ReportTreeRec.BranchType[1]) = 'R') then
        if (trim(ReportTreeRec.DiskFileName) <> '') then
          slFilesToDelete.Add(ReportTreeRec.DiskFileName);
      lBtrvError := Delete_Rec(F[ReportTreeF], ReportTreeF, TreeParentIDK);
    end;

    lBtrvError := Find_Rec(B_GetFirst, F[ReportTreeF], ReportTreeF, RecPtr[ReportTreeF]^, TreeParentIDK, ssKeyS);
    while ((lBtrvError = 0) and (trim(ReportTreeRec.ParentID) <> trim(ssBranchID))) do
      lBtrvError := Find_Rec(B_GetNext, F[ReportTreeF], ReportTreeF, RecPtr[ReportTreeF]^, TreeParentIDK, ssKeyS);
  end;

  // reached the end of the file, could be that this is a 'lone' header, best check.
  if (lBtrvError = 9) then
  begin
    ssKeyS := '';
    lBtrvError := Find_Rec(B_GetFirst, F[ReportTreeF], ReportTreeF, RecPtr[ReportTreeF]^, TreeParentIDK, ssKeyS);
    while ((lBtrvError = 0) and (trim(ReportTreeRec.ChildID) <> trim(ssBranchID))) do
      lBtrvError := Find_Rec(B_GetNext, F[ReportTreeF], ReportTreeF, RecPtr[ReportTreeF]^, TreeParentIDK, ssKeyS);
    if ((lBtrvError = 0) and (trim(ReportTreeRec.ChildID) = trim(ssBranchID))) then
      if (UpperCase(ReportTreeRec.BranchType[1]) = 'H') then
        lBtrvError := Delete_Rec(F[ReportTreeF], ReportTreeF, TreeParentIDK);
  end // if (lBtrvError = 9) then...
  else
  begin
    if ((lBtrvError = 0) and (trim(ReportTreeRec.ParentID) = trim(ssBranchID))) then
     if (UpperCase(ReportTreeRec.BranchType[1]) = 'H') then
       lBtrvError := Delete_Rec(F[ReportTreeF], ReportTreeF, TreeParentIDK);
  end; // if (lBtrvError = 9) then...else...

end;

//-------------------------------------------------------------------------

procedure TReportTree.DumpReportSecurity;
begin // DumpReportSecurity
  FReportData.DumpReportSecurity;
end; // DumpReportSecurity

//-------------------------------------------------------------------------

procedure TReportTree.DumpReportTree;
begin // DumpReportTree
  FReportData.DumpReportTree;
end; // DumpReportTree

//-------------------------------------------------------------------------

// Returns a security object for the specified report
function TReportTree.GetSecurity(const ReportCode: ShortString): IReportSecurity;
begin // GetSecurity
  Result := FReportData.GetSecurity(ReportCode);
end; // GetSecurity

//-------------------------------------------------------------------------

// Used by the Report Engine to get the report details for printing, returns
// TRUE if the user is allowed to print the report
function TReportTree.GetReportForPrinting(const NodeName: ShortString;
  var NodeDesc, FileName: ShortString) : Boolean;
begin // GetReportForPrinting
  Result := FReportData.CanPrint(NodeName, NodeDesc, FileName);
end; // GetReportForPrinting

//-------------------------------------------------------------------------

procedure TReportTree.Import;
var
  Res: LongInt;
  oVRWReportData: IVRWReportData;
  oAdd: IVRWReportDataEditor;
  RecordPosition: LongInt;
  ReportName, ParentName: string;
  LastRunDate: TDateTime;
  LastRunUser: ShortString;
  PositionNumber: Integer;
begin
  ClearLog;
  FHasImportErrors := False;
  { Create TVRWReportData instance }
  oVRWReportData := RepEngineManager.VRWReportData;
  try
    { For each report: }
    Res := GetFirstForImport;
    while (Res = 0) do
    begin
      { Find the parent record, if any, and read the name. The record name is
        used as part of the unique identifier for the new version. }
      if (Trim(ReportTreeRec.ParentID) <> '0') and
         (Trim(ReportTreeRec.ParentID) <> '') then
      begin
        ParentName := FindRecordName(Trim(ReportTreeRec.ParentID));
        if (ParentName = '') then
        begin
          OnImportError('No parent found for ' + Trim(ReportTreeRec.ReportName) +
                        ', added report to root instead');
          FHasImportErrors := True;
        end;
      end
      else
        ParentName := '';
      ParentName := PadString(psRight, ParentName, ' ', 50);
      { Find an used order number against this parent record (i.e. an order
        number which is not currently used by any of the child records against
        this parent). }
      PositionNumber := 0;
      repeat
        PositionNumber := PositionNumber + 1;
      until oVRWReportData.IsUnique(ParentName, PositionNumber);
      { Add a TVRWReportData record }
      oAdd := oVRWReportData.Add;
      try
        { Copy and convert the details into the new record }
        oAdd.rtNodeType    := ReportTreeRec.BranchType[1];
        ReportName := Trim(ReportTreeRec.ReportName);
        if (ReportName = '') then
        begin
          ReportName := Trim(ReportTreeRec.DiskFileName);
          ReportName := StringReplace(ReportName, '.ERF', '', [rfReplaceAll]);
          OnImportError('No report name assigned for ' + Trim(ReportTreeRec.DiskFileName) +
                        ', created default report name');
          FHasImportErrors := True;
        end;
        oAdd.rtRepName     := oVRWReportData.MakeUniqueReportName(ReportName);
        oAdd.rtRepDesc     := ReportTreeRec.ReportDesc;
        oAdd.rtParentName  := ParentName;
        if (Trim(ReportTreeRec.DiskFileName) = '') then
          oAdd.rtFileName := ReportTreeRec.ReportName
        else
          oAdd.rtFileName := ReportTreeRec.DiskFileName;

        ParseLastRun(ReportTreeRec.LastRunDetails, LastRunDate, LastRunUser);

        oAdd.rtLastRun     := LastRunDate;
        oAdd.rtLastRunUser := LastRunUser;
        oAdd.rtPositionNumber := PositionNumber;

        if ValidateImport(oVRWReportData, oAdd) then
        begin
          { Save the record }
          Res := oAdd.Save;
          if (Res <> 0) then
          begin
            AddToLog(
              'Import failed on ' + Trim(ReportTreeRec.ReportName) +
              ' with Btrieve error ' + IntToStr(Res)
            );
            FHasImportErrors := True;
          end;
        end;
      finally
        oAdd := nil;
      end;
      { Get next report }
      Res := GetNextForImport;
    end;
    { Now check for corrupted branches (where a record has been made the child
      of itself or one of its children) }
    Res := oVRWReportData.GetFirst;
    while (Res = 0) do
    begin
      if (oVRWReportData.rtNodeType = 'H') and
         (IsOwnParent(oVRWReportData)) then
      begin
        oVRWReportData.MoveTo('');
        OnImportError('Corrupted section of report tree found under ' +
                      Trim(oVRWReportData.rtRepName) +
                      '. Moved to root of tree');
        FHasImportErrors := True;
      end;
      Res := oVRWReportData.GetNext;
    end;
    if FHasImportErrors then
      ShowLog;
  finally
    oVRWReportData := nil;
  end;
end;

function TReportTree.FindRecordName(RecordID: ShortString): ShortString;
var
  RecordPosition: LongInt;
  Res: LongInt;
  SearchKey: string;
  SaveRec: TReportTreeFRec;
begin
  Result := StringOfChar(' ', 50);
  SaveImportPosition(RecordPosition, SaveRec);
  SearchKey := RecordID;
  Res := GetFirstForImport;
  while (Res = 0) do
  begin
    { TreeNodeChild is the ID of the record, and should match the ID that we
      are searching for. }
    if (Trim(ReportTreeRec.ChildID) = SearchKey) then
    begin
      Result := Trim(ReportTreeRec.ReportName);
      Break;
    end;
    Res := GetNextForImport;
  end;
  RestoreImportPosition(RecordPosition, SaveRec);
end;

procedure TReportTree.ParseLastRun(const LastRunDetails: ShortString;
  var LastRunDate: TDateTime; var LastRunUser: ShortString);
var
  DividerPos: Integer;
  DateStr, User: string;
begin
  DividerPos := Pos(' by ', LastRunDetails);
  if (DividerPos = 0) then
  begin
    LastRunDate := 0;
    LastRunUser := '';
  end
  else
  begin
    DateStr := Copy(LastRunDetails, 1, DividerPos - 1);
    LastRunDate := StrToDateDef(DateStr, Now);
    LastRunUser := Copy(LastRunDetails, DividerPos + 4, Length(LastRunDetails));
  end;
end;

function TReportTree.GetFirstForImport: LongInt;
begin
  Result := GetImportRecord ('', B_GetFirst);
end;

function TReportTree.GetImportRecord(const Key: ShortString;
  BtrOp: SmallInt): LongInt;
var
  RecordToReturn : boolean;
  lBtrvError : LongInt;
begin
  lBtrvError := -1;
  If Assigned (FRepManager) And (FRepManager.DataDirectory <> '') Then
  Begin
    ssKeyS := Key;
    // read record from report names file.
    lBtrvError := Find_Rec(BtrOp, F[ReportTreeF], ReportTreeF, RecPtr[ReportTreeF]^, TreeParentIDK, ssKeyS);
  End; // If Assigned (FRepManager) And (FRepManager.DataDirectory <> '')
  Result := lBtrvError;
end;

function TReportTree.GetNextForImport: LongInt;
begin
  Result := GetImportRecord ('', B_GetNext);
end;

function TReportTree.RestoreImportPosition(var iPos: Integer;
  var SaveRec: TReportTreeFRec): LongInt;
var
  KeyPos : longint;
begin
  KeyPos := iPos;
  Result := Presrv_BTPos(ReportTreeF, FKeyPath, F[ReportTreeF], KeyPos, True, False);
  ReportTreeRec := SaveRec;
end;

function TReportTree.SaveImportPosition(var iPos: Integer;
  var SaveRec: TReportTreeFRec): LongInt;
begin
  FKeyPath := GetPosKey;
  Result := Presrv_BTPos(ReportTreeF, FKeyPath, F[ReportTreeF], iPos, False, False);
  SaveRec := ReportTreeRec;
end;

function TReportTree.ValidateImport(DataHandler: IVRWReportData;
  RecordDetails: IVRWReportDataEditor): Boolean;
{ Validates the supplied record, correcting any details that might cause
  problems -- checks for duplicate report names, duplicate file names. Returns
  false if it finds problems which cannot be corrected. }
var
  OriginalReportName, NewReportName: string;
  OriginalFileName, NewFileName: string;
  Source, Destination: TFileStream;
begin
  Result := True;
  OriginalReportName := RecordDetails.rtRepName;
  { Report name must be unique }
  RecordDetails.rtRepName :=
    DataHandler.MakeUniqueReportName(RecordDetails.rtRepName);
  NewReportName := RecordDetails.rtRepName;

//  if (NewReportName <> OriginalReportName) then
//    OnImportError('Duplicate report ' + OriginalReportName +
//                  ' renamed to ' + NewReportName);

  { File name must be unique. If a new file name is created, make a copy the
    old report file using the new file name. }
  OriginalFileName := Trim(RecordDetails.rtFileName);
  RecordDetails.rtFileName :=
    DataHandler.MakeUniqueFileName(RecordDetails.rtFileName);
  NewFileName := Trim(RecordDetails.rtFileName);
  if (RecordDetails.rtNodeType = 'R') and
     (NewFileName <> OriginalFileName) then
  begin
    OriginalFileName := SetDrive + 'REPORTS\' + OriginalFileName;
    NewFileName      := SetDrive + 'REPORTS\' + NewFileName;
    try
      Source := TFileStream.Create(OriginalFileName, fmOpenRead );
      try
        Destination := TFileStream.Create(NewFileName, fmOpenWrite or fmCreate );
        try
          Destination.CopyFrom(Source, Source.Size ) ;
        finally
          Destination.Free;
        end;
      finally
        Source.Free;
      end;

//      OnImportError('Duplicate report file ' + OriginalFileName +
//                    ' renamed to ' + NewFileName);
//      FHasImportErrors := True;

    except
      on E:Exception do
      begin
        OnImportError('Import failed on ' + RecordDetails.rtRepName + ' : ' +
                      E.Message);
        FHasImportErrors := True;
      end;
    end;
  end;
  if (RecordDetails.rtNodeType = 'R') and
     (not FileExists(SetDrive + 'REPORTS\' + Trim(RecordDetails.rtFileName))) then
  begin
    OnImportError('Report file ' + SetDrive + 'REPORTS\' + Trim(RecordDetails.rtFileName) +
                  ' not found');
    FHasImportErrors := True;
  end;
end;

procedure TReportTree.OnImportError(ErrorMsg: string);
begin
  AddToLog(ErrorMsg);
  AddToLog(StringOfChar('_', 80));
end;

procedure TReportTree.ClearLog;
begin
  FLog.Clear;
end;

procedure TReportTree.AddToLog(LogMsg: string);
begin
  FLog.Add(LogMsg);
end;

procedure TReportTree.ShowLog;
var
  FileName: string;
begin
  FileName := SetDrive + 'REPORTS\LOG.TXT';
  FLog.SaveToFile(FileName);
  ShellExecute(0, 'open', 'notepad.exe', PChar(Filename), nil, SW_SHOW);
end;

function TReportTree.GetHasImportErrors: Boolean;
begin
  Result := FHasImportErrors;
end;

function TReportTree.IsOwnParent(ReportData: IVRWReportData): Boolean;
{ Returns true if the current record is found to be its own parent }
var
  StoredPosition, StoredIndex: LongInt;
  Res: LongInt;
  StoredRec: TVRWReportDataRec;
  ReportName, ParentName: ShortString;
begin
  Res := 0;
  Result := False;
  { Save the current position }
  ReportData.SavePosition(StoredPosition);
  StoredIndex := ReportData.Index;
  try
    { Record the current report name and parent name }
    ReportName := Uppercase(Trim(ReportData.rtRepName));
    ParentName := Uppercase(Trim(ReportData.rtParentName));
    { Walk up the tree until we either find the root, or a record whose parent
      is the current report (in which case the report is its own parent) }
    repeat
      if (ParentName = '') then
      { Root found. All ok. }
      begin
        Result := False;
        Break;
      end
      else if (ReportName = ParentName) then
      { Recursive link found. }
      begin
        Result := True;
        Break;
      end;
      { Go to the parent record... }
      Res := ReportData.FindByName(ParentName);
      { ...and read its parent name }
      if (Res = 0) then
        ParentName := Uppercase(Trim(ReportData.rtParentName));
    until (Res <> 0);
  finally
    { Restore the original position }
    ReportData.Index := StoredIndex;
    ReportData.RestorePosition(StoredPosition);
    ReportData.Read;
  end;
end;

end.
