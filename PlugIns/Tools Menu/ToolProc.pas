unit ToolProc;

interface
uses
  RptEngDll, VRWReportIF, ComCtrls, Classes, SysUtils, BTUtil, BTConst
  , DataModule, Enterprise01_TLB, ToolBTFiles, Menus, Dialogs, FileUtil
  , ADODB;

type
  TCompanyRec = Record
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;

  TCompanyInfo = Class
    CompanyRec : TCompanyRec;
  end;{with}

  TMenuItemInfo = Class
    MenuItemRec : TMenuItemRec;
//    ParentComponentName : string[50];
//    Position : integer;
  end;

  function GetNextFolioNo : integer;
  function GetComponentNameFrom(sDesc : string; cType : char) : string;
  function GetMenuItemInMenu(Menu : TMenuItem; sName : string): TMenuItem;
  function UserDefinedItem(sName : string) : boolean;
  function GetUserDefinedItemType(sName : string) : char;
  function GetMenuItemFromName(sName : string) : TMenuItemRec;
  function GetCaptionNameFrom(MenuItemRec : TMenuItemRec) : string;
  procedure InitToolkit(sPath : string);
  Procedure RunUserOption(sName : string);
  procedure InsertItemAt(iNewPosition : integer; sParentComponentName : string);
  procedure DeleteItemAt(iPosition : integer; sParentComponentName : string);
  function GetNodeInParentAtPos(ParentNode : TTreeNode; iPosition : integer; AllNodes : TTreeNodes) : TTreeNode;
  procedure RefreshPositionsIn(ParentItem : TTreeNode; AllNodes : TTreeNodes);
//  procedure GetAllUsersFromTK;
  procedure FillCompanyListSQL(sPath : string);

var
  oToolkit : IToolkit;
  slUsers, slCompanies : TStringList;
  EnterpriseMenu : TMainMenu;
//  CurrentCompanyRec : TCompanyRec;
  sCurrentUserName : string;
  bSQL : boolean;
  SQLDataModule : TSQLDataModule;

const
  SEPARATOR = '------------------------------';

  II_Separator = 2;
  II_EnterpriseOption = 1;
  II_UserOption = 2;
  II_UserReport = 3;
  II_EnterpriseMenu = 4;
  II_UserMenu = 5;
  II_EnterpriseMenuOpen = 6;
  II_UserMenuOpen = 7;

implementation
uses
  Windows, ShellAPI, Forms, SecCodes, ComObj, StrUtil, APIUtil
  {$IFNDEF REMOVE_VRW}
    , ReportProgress, MenuManager
  {$ENDIF}
  ;

(*
function GetNextFolioNo : integer;
var
  KeyS : TStr255;
  ToolRec : TToolRec;
  iStatus, iNextFolio : LongInt;

begin
  FillChar(KeyS, SizeOf(KeyS), #0);
  iNextFolio := 1;

  // get last record
  KeyS := RT_MenuItem + BTFullNomKey(999999999);
  iStatus := BTFindRecord(BT_GetLessOrEqual, FileVar[ToolF], ToolRec, BufferSize[ToolF]
  , miIdxByFolio, KeyS);
  if iStatus = 0 then iNextFolio := ToolRec.MenuItem.miFolioNo + 1;

  // show error
  if not (iStatus in [0,4,9])
  then BTShowError(iStatus, 'BTFindRecord', asAppDir + aFileNames[ToolF]);

  Result := iNextFolio;
end;
*)
function GetNextFolioNo : integer;
var
  KeyS : TStr255;
  ToolRec : TToolRec;
  iStatus, iNextFolio : LongInt;
begin
  FillChar(KeyS, SizeOf(KeyS), #0);
  iNextFolio := 1;

  // get last record
{  KeyS := RT_MenuItem + BTFullNomKey(999999999);
  iStatus := BTFindRecord(BT_GetLessOrEqual, FileVar[ToolF], ToolRec, BufferSize[ToolF]
  , miIdxByFolio, KeyS);
  if iStatus = 0 then iNextFolio := ToolRec.MenuItem.miFolioNo + 1;}

  // NF: 09/10/2007 (.137) Yes I know it's not very efficient, but this was falling foul of
  // fullnomkey issues when the folio number went over 96. Without redesigning the database
  // , this is the only safe way to get this routine working.

  // get first MenuItem record
  KeyS := RT_MenuItem;
  iStatus := BTFindRecord(BT_GetGreaterOrEqual, FileVar[ToolF], ToolRec, BufferSize[ToolF]
  , miIdxByFolio, KeyS);
  while (iStatus = 0) and (ToolRec.RecordType = RT_MenuItem) do
  begin
    if iNextFolio < ToolRec.MenuItem.miFolioNo
    then iNextFolio := ToolRec.MenuItem.miFolioNo;
    iStatus := BTFindRecord(BT_GetNext, FileVar[ToolF], ToolRec, BufferSize[ToolF]
    , miIdxByFolio, KeyS);
  end;{while}

  // show error
{  if not (iStatus in [0,4,9])
  then BTShowError(iStatus, 'BTFindRecord', asAppDir + aFileNames[ToolF]);}

  Result := iNextFolio + 1;
end;

function GetComponentNameFrom(sDesc : string; cType : char) : string;
var
  BTRec : TBTRec;
  iNo : integer;
  LToolRec : TToolRec;
  sOrigDesc : string;
begin
  sDesc := RemoveAllCharsExcept(sDesc, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_1234567890');
  sDesc := 'UT' + cType + '_' + Copy(sDesc,1,40);
  sDesc := PadString(psRight, sDesc, ' ', 50);
  sOrigDesc := sDesc;

  iNo := 0;
  repeat
    inc(iNo);
    // find record we are editing
    BTRec.KeyS := RT_MenuItem + BuildB50Index(sDesc);
    BTRec.Status := BTFindRecord(BT_GetEqual, FileVar[ToolF], LToolRec, BufferSize[ToolF]
    , miIdxByComponentName, BTRec.KeyS);
    if BTRec.Status = 0 then sDesc := PadString(psRight, Trim(sOrigDesc) + IntToStr(iNo), ' ', 50);
  until BTRec.Status <> 0;

  Result := sDesc;
end;

function GetMenuItemInMenu(Menu : TMenuItem; sName : string): TMenuItem;
var
  I: Integer;
begin
  sName := Trim(sName);
  Result := nil;

  for I := 0 to Menu.Count - 1 do
  begin

    if Menu.Count > 0 then Result := GetMenuItemInMenu(Menu.Items[I], sName);
    if (Result <> nil) then Break;

    if AnsiSameText(sName, Menu.Items[I].Name) then
    begin
      Result := Menu.Items[I];
      Break;
    end;
  end;{for}
end;

function UserDefinedItem(sName : string) : boolean;
begin
  Result := (Length(sName) >= 4) and (Copy(sName, 1, 2) = 'UT')
  and (sName[3] in [IT_MenuItem, IT_SubMenu, IT_Report, IT_Separator])
  and (Copy(sName, 4, 1) = '_');
end;

function GetUserDefinedItemType(sName : string) : char;
begin
  Result := ' ';
  if (Length(sName) >= 4) and (Copy(sName, 1, 2) = 'UT')
  then Result := sName[3];
end;

function GetMenuItemFromName(sName : string) : TMenuItemRec;
var
  KeyS : TStr255;
  ToolRec : TToolRec;
  iStatus : LongInt;
begin
  FillChar(Result, SizeOf(Result), #0);
  sName := PadString(psRight, sName, ' ', 50);
  KeyS := RT_MenuItem + BuildB50Index(sName);
  iStatus := BTFindRecord(BT_GetEqual, FileVar[ToolF], ToolRec, BufferSize[ToolF]
  , miIdxByComponentName, KeyS);
  if iStatus = 0 then Result := ToolRec.MenuItem;
end;

function GetCaptionNameFrom(MenuItemRec : TMenuItemRec) : string;
begin
  if MenuItemRec.miDescription = '-' then Result := SEPARATOR
  else Result := MenuItemRec.miDescription;
end;

procedure InitToolkit(sPath : string);

  procedure GetAllUsersFromTK;
  var
    iStatus : integer;
  begin{GetAllUsersFromTK}
    // Create COM Toolkit object
  //  InitToolkit(CurrentCompanyRec.Path);

  //DebugToFile('Before Get All Users');
    slUsers.Clear;
    with (oToolkit as IToolkit2).UserProfile do
    begin
      Index := usIdxLogin;
      iStatus := GetFirst;
      while (iStatus = 0) do
      begin
        slUsers.Add(upUserID);
        iStatus := GetNext;
      end;{while}
    end;{with}
  //DebugToFile('After Get All Users');

  //  oToolkit := nil;
  end;{GetAllUsersFromTK}

var
  a, b, c : LongInt;
  iStatus, iPos : integer;
  CompanyInfo : TCompanyInfo;

begin{InitToolkit}
  slUsers := TStringList.Create;
  slCompanies := TStringList.Create;

  // Create COM Toolkit object
  oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

  // Check it created OK
  If Assigned(oToolkit) Then Begin

    EncodeOpCode(97, a, b, c);
    oToolkit.Configuration.SetDebugMode(a, b, c);

    oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;

    // NF: 21/04/2008 Changed to use a "with" - due to the way the toolkit was written, this gives a massive performance improvement
    with oToolkit.Company do
    begin
      For iPos := 1 to {oToolkit.Company.}cmCount do begin
        CompanyInfo := TCompanyInfo.Create;
        CompanyInfo.CompanyRec.Path := Trim({oToolkit.Company.}cmCompany[iPos].coPath);
        CompanyInfo.CompanyRec.Name := Trim({oToolkit.Company.}cmCompany[iPos].coName);
        CompanyInfo.CompanyRec.Code := Trim({oToolkit.Company.}cmCompany[iPos].coCode);
        slCompanies.AddObject({oToolkit.Company.}cmCompany[iPos].coName, CompanyInfo);
      end;{for}
    end;{with}

    oToolkit.Configuration.DataDirectory := sPath;
    iStatus := oToolkit.OpenToolkit;
    if iStatus = 0 then
    begin
      GetAllUsersFromTK;
    end else
    begin
      ShowMessage('oToolkit.OpenToolkit failed with the result : ' + IntToStr(iStatus));
    end;{if}
  End { If Assigned(oToolkit) }
  Else
    // Failed to create COM Object
    ShowMessage('Cannot create COM Toolkit instance');
end;{InitToolkit}

procedure FillCompanyListSQL(sPath : string);
var
  iStatus, iPos : integer;
  CompanyInfo : TCompanyInfo;

  procedure GetAllUsersFromSQL;
  var
    iStatus : integer;
    qUsers : TADOQuery;
  begin{GetAllUsersFromSQL}
    // SQL Optimisation
    slUsers.Clear;
    qUsers := SQLDataModule.SQLGetUserList;

    qUsers.First;
    while not qUsers.Eof do
    begin
      slUsers.Add(Trim(qUsers.FieldByName('UserID').AsString));

      //Next Record
      qUsers.Next;
    end;{while}
  end;{GetAllUsersFromSQL}

var
  qCompanyList : TADOQuery;

begin{FillCompanyListSQL}
  // SQL Optimisation

  slUsers := TStringList.Create;
  slCompanies := TStringList.Create;

  qCompanyList := SQLDataModule.SQLGetCompanyList;

  qCompanyList.First;
  while not qCompanyList.Eof do
  begin
    CompanyInfo := TCompanyInfo.Create;
    CompanyInfo.CompanyRec.Path := Trim(qCompanyList.FieldByName('CompanyPath').AsString);
    CompanyInfo.CompanyRec.Name := qCompanyList.FieldByName('CompanyName').AsString;
    CompanyInfo.CompanyRec.Code := qCompanyList.FieldByName('CompanyCode').AsString;
    slCompanies.AddObject(CompanyInfo.CompanyRec.Name, CompanyInfo);

    // Next Record
    qCompanyList.Next;
  end;{while}
  qCompanyList.Close;

  GetAllUsersFromSQL;
end;{FillCompanyListSQL}

Procedure RunUserOption(sName : string);
var
  {sUserID,} FPath                 : ShortString;
  cmdFile, cmdPath, cmdParams : PChar;
  Flags                       : SmallInt;
  iStatus : integer;
  KeyS : TStr255;
  ToolRec : TToolRec;
  oReport : IVRWReport;

{$IFNDEF REMOVE_VRW}
  frmReportProgress : TfrmReportProgress;
{$ENDIF}

  bResult : boolean;

  function GetParameters(sParameters : string) : string;
  const
    COMPANY_DATA_DIR = '%COMPANYDATADIR%';
    EXCHEQUER_DIR = '%EXCHEQUERDIR%';
    USER_NAME = '%USERNAME%';
  begin{GetParameters}
//    sParameters := StringReplace(sParameters, COMPANY_DATA_DIR, CurrentCompanyRec.Path
//    , [rfReplaceAll, rfIgnoreCase]);
    sParameters := StringReplace(sParameters, COMPANY_DATA_DIR, asCompanyPath
    , [rfReplaceAll, rfIgnoreCase]);
    
    sParameters := StringReplace(sParameters, EXCHEQUER_DIR, ExtractFilePath(Application.ExeName)
    , [rfReplaceAll, rfIgnoreCase]);
    sParameters := StringReplace(sParameters, USER_NAME, sCurrentUserName
    , [rfReplaceAll, rfIgnoreCase]);
    Result := sParameters;
  end;{GetParameters}

Begin{RunUserOption}
  OpenFiles(TRUE);
  sName := PadString(psRight, sName, ' ', 50);
  KeyS := RT_MenuItem + BuildB50Index(sName);
  iStatus := BTFindRecord(BT_GetEqual, FileVar[ToolF], ToolRec, BufferSize[ToolF]
  , miIdxByComponentName, KeyS);
  if (iStatus = 0) then
  begin
    case ToolRec.MenuItem.miItemType of
      // Run Option
      IT_MenuItem : begin

        if FileExists(ToolRec.MenuItem.miFilename) then
        begin

          cmdFile   := StrAlloc(255);
          cmdPath   := StrAlloc(255);
          cmdParams := StrAlloc(255);

          FPath := ExpandFileName(ToolRec.MenuItem.miStartDir);

          {If (FPath = '.\') Then
            FPath := ExtractFilePath(Application.ExeName);}

          StrPCopy (cmdFile, ToolRec.MenuItem.miFilename);
          StrPCopy (cmdParams, GetParameters(ToolRec.MenuItem.miParameters));
          StrPCopy (cmdPath, FPath);

          Flags := SW_SHOWNORMAL;

          ShellExecute (Application.MainForm.Handle, NIL, cmdFile, cmdParams, cmdPath, Flags);

          StrDispose(cmdFile);
          StrDispose(cmdPath);
          StrDispose(cmdParams);
        end else
        begin
          MsgBox('The file specified, "' + ToolRec.MenuItem.miFilename
          + '" does not exist.', mtError,[mbOK], mbOK, 'File does not exist');
        end;{if}
      end;

      // RUN REPORT
      IT_Report : begin
      {$IFNDEF REMOVE_VRW}

        if RWMenuManager.mmVRWAvailable then
        begin
          frmReportProgress := TfrmReportProgress.Create(application.MainForm);

          try
            frmReportProgress.lReport.Caption := ToolRec.MenuItem.miFilename;
            frmReportProgress.UpdateStatus('Initialising report engine');
            oReport := GetVRWReport;

//            oReport.VRDataPath := CurrentCompanyRec.Path;
            oReport.VRDataPath := asCompanyPath;

            oReport.VROnPrintRecord := frmReportProgress.OnReportProgress;
            InitPreview(Application, Screen);
            frmReportProgress.UpdateStatus('Loading Report');

//            oReport.Read(CurrentCompanyRec.Path + 'REPORTS\' + ToolRec.MenuItem.miFilename + '.ERF');
            oReport.Read(asCompanyPath + 'REPORTS\' + ToolRec.MenuItem.miFilename + '.ERF');

            if oReport.CheckSecurity(sCurrentUserName) then
            begin
              frmReportProgress.UpdateStatus('Printing Report');
              oReport.Print('', FALSE);
            end;{if}

            oReport := nil;
          finally
            frmReportProgress.Release;
          end;
        end else
        begin
          MsgBox('Sorry. The Visual Report Writer is not licenced for your use.'
          , mtInformation, [mbOK], mbOK, 'Access Denied');
        end;{if}
      {$ENDIF}
      end;
    end;{case}
  end;{if}
End;

procedure InsertItemAt(iNewPosition : integer; sParentComponentName : string);
var
  KeyS : TStr255;
 { iNoToDo,} iStatus : integer;
  ToolRec : TToolRec;
{  slDone : TStringList;
  bDone, bModified : boolean;}
begin
//PR: 25/09/2014 ABSEXCH-15589 Rewrote routine to avoid clunkiness which seems to cause SQL caching issue.
//                             The routine now starts with the last record by position for the current parent and
//                             moves down, incrementing each position by 1 until it reaches iNewPosition
(*
  slDone := TStringList.Create;

  // work out how many we need to update
  iNoToDo := 0;
  KeyS := RT_MenuItem + BuildC60Index(sParentComponentName + BTFullNomKey(1) + IDX_DUMMY_CHAR);
  iStatus := BTFindRecord(BT_GetGreaterOrEqual, FileVar[ToolF], ToolRec, BufferSize[ToolF]
  , miIdxAddOrder, KeyS);
  while (iStatus = 0) and (ToolRec.RecordType = RT_MenuItem)
  and (ToolRec.MenuItem.miParentComponentName = sParentComponentName) do
  begin
    if (ToolRec.MenuItem.miPosition >= iNewPosition) then inc(iNoToDo);
    iStatus := BTFindRecord(BT_GetNext, FileVar[ToolF], ToolRec, BufferSize[ToolF]
    , miIdxAddOrder, KeyS);
  end;{while}

  // keep updating until we have done them all
  repeat

    // get first record with the defined parent
    KeyS := RT_MenuItem + BuildC60Index(sParentComponentName + BTFullNomKey(1) + IDX_DUMMY_CHAR);
    iStatus := BTFindRecord(BT_GetGreaterOrEqual, FileVar[ToolF], ToolRec, BufferSize[ToolF]
    , miIdxAddOrder, KeyS);

    bModified := FALSE;
    while (iStatus = 0) and (ToolRec.RecordType = RT_MenuItem)
    and (ToolRec.MenuItem.miParentComponentName = sParentComponentName)
    and (bModified = FALSE) do
    begin
      bDone := slDone.IndexOf(IntToStr(ToolRec.MenuItem.miFolioNo)) >= 0;
      if (ToolRec.MenuItem.miPosition >= iNewPosition) and (not bDone) then
      begin
        ToolRec.MenuItem.miPosition := ToolRec.MenuItem.miPosition + 1;
        SetMenuItemIndexes(ToolRec);
        iStatus := BTUpdateRecord(FileVar[ToolF], ToolRec, BufferSize[ToolF], miIdxAddOrder, KeyS);
        BTShowError(iStatus, 'BTUpdateRecord', asAppDir + aFileNames[ToolF]);
        slDone.Add(IntToStr(ToolRec.MenuItem.miFolioNo));
        bModified := TRUE;
      end;{if}

      if not bModified then
      begin
        iStatus := BTFindRecord(BT_GetNext, FileVar[ToolF], ToolRec, BufferSize[ToolF]
        , miIdxAddOrder, KeyS);
      end;{if}
    end;{while}
  until slDone.Count = iNoToDo;
*)

  //Find last record for this parent
  KeyS := RT_MenuItem + BuildC60Index(sParentComponentName + BTFullNomKey(MaxInt) + IDX_DUMMY_CHAR);
  iStatus := BTFindRecord(BT_GetLessOrEqual, FileVar[ToolF], ToolRec, BufferSize[ToolF]
  , miIdxAddOrder, KeyS);

  while (iStatus = 0) and (ToolRec.RecordType = RT_MenuItem)
  and (ToolRec.MenuItem.miParentComponentName = sParentComponentName) and
      (ToolRec.MenuItem.miPosition >= iNewPosition) do
  begin
    //Increment position
    ToolRec.MenuItem.miPosition := ToolRec.MenuItem.miPosition + 1;

    //Populate index field
    SetMenuItemIndexes(ToolRec);

    //Update record and display any error
    iStatus := BTUpdateRecord(FileVar[ToolF], ToolRec, BufferSize[ToolF], miIdxAddOrder, KeyS);
    BTShowError(iStatus, 'BTUpdateRecord', asAppDir + aFileNames[ToolF]);

    //Find previous record for parent
    iStatus := BTFindRecord(BT_GetPrevious, FileVar[ToolF], ToolRec, BufferSize[ToolF]
    , miIdxAddOrder, KeyS);
  end;{while}

end;

procedure DeleteItemAt(iPosition : integer; sParentComponentName : string);
var
  KeyS : TStr255;
{  iNoToDo,} iStatus : integer;
  ToolRec : TToolRec;
{  slDone : TStringList;
  bDone, bModified : boolean;}
begin
//PR: 25/09/2014 ABSEXCH-15589 Rewrote routine to avoid clunkiness which seems to cause SQL caching issue.
//                             The routine now starts with the record in iNewPosition and moves up, decrementing each
//                             position by 1 until it reaches the end of the records with this parent.
(*  slDone := TStringList.Create;

  // work out how many we need to update
  iNoToDo := 0;
  KeyS := RT_MenuItem + BuildC60Index(sParentComponentName + BTFullNomKey(1) + IDX_DUMMY_CHAR);
  iStatus := BTFindRecord(BT_GetGreaterOrEqual, FileVar[ToolF], ToolRec, BufferSize[ToolF]
  , miIdxAddOrder, KeyS);
  while (iStatus = 0) and (ToolRec.RecordType = RT_MenuItem)
  and (ToolRec.MenuItem.miParentComponentName = sParentComponentName) do
  begin
    if (ToolRec.MenuItem.miPosition > iPosition) then inc(iNoToDo);
    iStatus := BTFindRecord(BT_GetNext, FileVar[ToolF], ToolRec, BufferSize[ToolF]
    , miIdxAddOrder, KeyS);
  end;{while}

  // keep updating until we have done them all
  repeat

    // get first record with the defined parent
    KeyS := RT_MenuItem + BuildC60Index(sParentComponentName + BTFullNomKey(1) + IDX_DUMMY_CHAR);
    iStatus := BTFindRecord(BT_GetGreaterOrEqual, FileVar[ToolF], ToolRec, BufferSize[ToolF]
    , miIdxAddOrder, KeyS);

    bModified := FALSE;
    while (iStatus = 0) and (ToolRec.RecordType = RT_MenuItem)
    and (ToolRec.MenuItem.miParentComponentName = sParentComponentName)
    and (bModified = FALSE) do
    begin
      bDone := slDone.IndexOf(IntToStr(ToolRec.MenuItem.miFolioNo)) >= 0;
      if (ToolRec.MenuItem.miPosition > iPosition) and (not bDone) then
      begin
        ToolRec.MenuItem.miPosition := ToolRec.MenuItem.miPosition - 1;
        SetMenuItemIndexes(ToolRec);
        iStatus := BTUpdateRecord(FileVar[ToolF], ToolRec, BufferSize[ToolF], miIdxAddOrder, KeyS);
        BTShowError(iStatus, 'BTUpdateRecord', asAppDir + aFileNames[ToolF]);
        slDone.Add(IntToStr(ToolRec.MenuItem.miFolioNo));
        bModified := TRUE;
      end;{if}

      if not bModified then
      begin
        iStatus := BTFindRecord(BT_GetNext, FileVar[ToolF], ToolRec, BufferSize[ToolF]
        , miIdxAddOrder, KeyS);
      end;{if}
    end;{while}
  until slDone.Count = iNoToDo;

*)

  //Find record at iNewPosition for this parent
  KeyS := RT_MenuItem + BuildC60Index(sParentComponentName + BTFullNomKey(iPosition) + IDX_DUMMY_CHAR);
  iStatus := BTFindRecord(BT_GetGreaterOrEqual, FileVar[ToolF], ToolRec, BufferSize[ToolF]
  , miIdxAddOrder, KeyS);


  while (iStatus = 0) and (ToolRec.RecordType = RT_MenuItem)
  and (ToolRec.MenuItem.miParentComponentName = sParentComponentName) do
  begin
    //Decrement position
    ToolRec.MenuItem.miPosition := ToolRec.MenuItem.miPosition - 1;

    //Populate index field
    SetMenuItemIndexes(ToolRec);

    //Update record and display error
    iStatus := BTUpdateRecord(FileVar[ToolF], ToolRec, BufferSize[ToolF], miIdxAddOrder, KeyS);
    BTShowError(iStatus, 'BTUpdateRecord', asAppDir + aFileNames[ToolF]);

    //Get next record
    iStatus := BTFindRecord(BT_GetNext, FileVar[ToolF], ToolRec, BufferSize[ToolF]
    , miIdxAddOrder, KeyS);
  end;{while}

end;


function GetNodeInParentAtPos(ParentNode : TTreeNode; iPosition : integer; AllNodes : TTreeNodes) : TTreeNode;
var
  iPos : integer;
begin
  Result := nil;
  if ParentNode = nil then
  begin
    For iPos := 0 to AllNodes.Count-1 do
    begin
      if AllNodes[iPos].Level = 0
      then begin
        if TMenuItemInfo(AllNodes[iPos].Data).MenuItemRec.miPosition = iPosition
        then Result := AllNodes[iPos];
      end;{if}
    end;{for}
  end else
  begin
    For iPos := 0 to ParentNode.Count-1 do begin
  //    if TMenuItemInfo(ParentNode[ipos].Data).Position = iPosition
      if TMenuItemInfo(ParentNode[ipos].Data).MenuItemRec.miPosition = iPosition
      then Result := ParentNode[ipos];
    end;{for}
  end;{if}
end;

procedure RefreshPositionsIn(ParentItem : TTreeNode; AllNodes : TTreeNodes);
var
  iPos, iNewPos : integer;
begin
  if ParentItem = nil then
  begin
    iNewPos := 1;
    For iPos := 0 to AllNodes.Count-1 do
    begin
      if AllNodes[iPos].Level = 0
      then begin
        TMenuItemInfo(AllNodes[iPos].Data).MenuItemRec.miPosition := iNewPos;
        inc(iNewPos);
      end;{if}
    end;{for}
  end else
  begin
    For iPos := 0 to ParentItem.Count-1 do
    begin
      TMenuItemInfo(ParentItem.Item[iPos].Data).MenuItemRec.miPosition := iPos + 1;
    end;{for}
  end;{if}
end;

end.
