unit ReconObj;

interface

uses
  ExBtTh1U, BtrvU2, VarConst, ExWrap1U, Classes, BtSupU1, Varrec2u, GlobVar, TranFile,
   Enterprise04_TLB;

const
  BankRecHeadKey  = '1';
  BankRecLineKey  = '2';
  BankAccountKey  = '3';
  BankStatHeadKey = '4';
  BankStatLineKey = '5';

  cidBankRec1 = 63;
  cidBankRec2 = 64;

  iCleared  = 1;
  iMatch    = 8;
  iTag      = 16;
  iComplete = 32;




Type
  TGroupBy = (gbRefAndDate, gbRefOnly);  //PR: 14/10/2011  Added functionality to select how lines are grouped.

  PStatementLineRec = ^TStatementLineRec;
  TStatementLineRec = Record
    slDate : String[8];
    slLineNo : longint;
    //PR: 20/09/2016 ABSEXCH-12513 Changed slPayRef from 16 to 60 chars as it may need to be matched agains TempTransDetails.btdDesc
    slPayRef : String[60];
    slValue : Double;
    slStatFolio : longint;
  end;

  TReconStatus = Class
    rStatus : Byte;
    rStatLine : longint;
  end;

  TBankReconciliation = Class
  private
    FSQLInsertList : TStringList;
    FCompanyCode : string;
    FExLocal, FStoredExLocal : TdPostExLocalPtr;
    FFolio : longint;
    FReconList : TStringList;
    FKeyS : Str255;
    CacheID : longint;
    FHeaderAddress : longint;
    FReconciledAmount : Double;
    FNoUpdate : Boolean;
    FCancel : Boolean;
    FCacheAdds : Boolean;
    procedure SetExLocal(const Value: TdPostExLocalPtr);
    procedure SetReconciledAmount(const Value: Double);
    procedure SetNoUpdate(const Value: Boolean);
    function GetReconciledAmountSQL : Double;
    function GetUnclearedOnly: Boolean;
    procedure SetUnclearedOnly(const Value: Boolean);
    function GetGroupBy: TGroupBy;
    procedure SetGroupBy(const Value: TGroupBy);
    function FindSelf : Integer;
  public
    bnkHeader : BnkRHRecType;
    bnkDetail : BnkRDRecType;
    WasExistingReconcile, IsCheck : Boolean;
//    ReconciledAmount : Double;
    MatchedAmount : Double;
    function AddHeader : Integer;
    function AddLine : Integer;
    function UpdateHeader(bStoreRec : Boolean = True) : Integer;
    procedure UpdateLine;
    function Delete : Integer;
    function FindExisting(ShowDialog : Boolean = True) : Boolean;
    function FindAnyExisting : Boolean;
    function FindLine(const SearchKey : string; Index : Integer) : Integer;
    function FindGroupMatch(const PayInRef : string; const sDate : string;  LineKey : string = '') : Boolean;
    function FindGroupMatchForStatement(const PayInRef : string; const iLineNo : Integer;  LineKey : string = '') : Boolean;
    procedure GetNextFolio;
    function GetNextFolioF : longint;
    procedure AddMatch(const StatementLine : IBankStatementLine;
                             TransDetails : TTempTransDetails); overload;
    procedure AddMatch(const StatementLine : TStatementLineRec;
                             TransDetails : TTempTransDetails); overload;
    procedure AddMatch(const StatementLine : IBankStatementLine;
                                     Trans : ITransaction); overload;
    procedure AddMatchDetails(TransDetails : TTempTransDetails);
    procedure AddTag(TransDetails : TTempTransDetails);
    procedure DeleteTag(TransDetails : TTempTransDetails);
    function FindTag(TransDetails : TTempTransDetails) : Boolean;
    procedure DeleteAllTags;
    constructor Create(Cid : Integer);
    destructor Destroy; override;
    procedure SetLineStatus(Stat : Byte);
    function SaveToList : TList;
    procedure LoadFromList(const AList : TList);
    function FindByRef(const ARef : string; GLCode : longint; var HedRec : BnkRHRecType) : Integer;
    function FindByFolio(BankRec : BnkRHRecType) : Integer;
    procedure DeleteMatch(const SearchKey : string; const sDate : string; IsGroup : Boolean);
    procedure DeleteAllGroupLines;
    procedure LoadReconciledAmount;
    procedure UpdateLinesWithNewUser(const  sPrevUser : string; NewFolio : longint);
    function StatusSign(NewStatus : Byte) : Integer;
    procedure SetClearedRec(TransDetails : TTempTransDetails);


    function FindStatusFromList(const SearchKey : string) : Integer;
    function FindStatLineFromList(const SearchKey : string) : Integer;
    function FindTagFromList(TransDetails : TTempTransDetails) : Boolean;
    function BuildTagKey(RDRec : BnkRDRecType) : string;

    function GetFirstLine : Integer;
    function GetNextLine : Integer;
    function LineRef : String;
    procedure CloseSession;
    procedure RestoreExLocal;

    procedure ProcessCurrentRecord;
    procedure InsertCachedAddsToTable;

    procedure AddClearedRec(TransDetails : TTempTransDetails);
    procedure RemoveClearedRec(TransDetails : TTempTransDetails);
    procedure UpdateClearedRec(TransDetails : TTempTransDetails);
    //PR: 17/10/2011 With ability to match on Date and Referece, or Reference only we need to check GroupBy every time we try to match dates
    function GroupDateMatches(const ADate1, ADate2 : string) : Boolean;



    property ExLocal : TdPostExLocalPtr read FExLocal write SetExLocal;
    property ReconciledAmount : Double read FReconciledAmount write SetReconciledAmount;
    property NoUpdate : Boolean read FNoUpdate write SetNoUpdate;
    property Cancel : Boolean read FCancel;
    property CacheAdds : Boolean read FCacheAdds write FCacheAdds;
    property CompanyCode : string read FCompanyCode write FCompanyCode;
    property UnclearedOnly : Boolean read GetUnclearedOnly write SetUnclearedOnly;

    property GroupBy : TGroupBy read GetGroupBy write SetGroupBy;
  end;

  function ReconcileObj : TBankReconciliation;

  procedure FreeReconcileObj;

  function BuildTransLineIndex(const UserID : string; GLCode, Folio,
              TransFolio, LineNo : longint) : Str255;

  function BuildLineIndex(const UserID : string; GLCode, Folio, LineNo : longint) : Str255;


  function BuildHeadRefIndex(const UserID : string; GLCode : longint; const Ref : string) : Str255;
  function BuildHeadUserIndex(const UserID : string; GLCode : longint) : Str255;

  //PR: 06/07/2017 ABSEXCH-12358 v2017 R2 Make function public to allow use from Statement Report
  function BuildHeadFolioIndex(const UserID : string; GLCode, Folio : longint) : Str255;


  function GetUserID : string;



var
  oRecToolkit : IToolkit3;




implementation

{ TBankReconciliation }
uses
  SysUtils, BtKeys1U, EtStrU, Existng, Forms, EtDateU, Dialogs, SQLUtils, SQLFields, ApiUtil, Controls, CtkUtil04,
  SQLQueries, SQLCallerU;

var
  BankReconObj : TBankReconciliation;


function GetUserID : string;
begin
  if UserProfile^.Loaded then
    Result := Trim(UserProfile^.Login)
  else
    Result := Trim(EntryRec^.Login);
end;

function BuildHeadRefIndex(const UserID : string; GLCode : longint; const Ref : string) : Str255;
begin
  Result := FullNomKey(GLCode) + LJVar(UserID, 10) +
                LJVar(Ref, 20);
end;

function BuildHeadUserIndex(const UserID : string; GLCode : longint) : Str255;
begin
  Result := FullNomKey(GLCode) + LJVar(UserID, 10);
end;


function BuildHeadDateIndex(const UserID : string; GLCode : longint; const Ref : string) : Str255;
begin
  Result := FullNomKey(GLCode) + LJVar(UserID, 10) +
                LJVar(Ref, 8);
end;

function BuildHeadFolioIndex(const UserID : string; GLCode, Folio : longint) : Str255;
begin
  //PR: 04/07/2017 ABSEXCH-12358 v2017 R2 Using the FullNomKey of the bank folio was causing problems
  //searching in that index, so the FullNomKey is now a hex representation
  //The conversion is done in GeUpgrde
  Result := FullNomKey(GLCode) + LJVar(UserID, 10) +
                IntToHex(Folio, 8) + StringOfChar(#0, 9);
end;

//Index 0 for lines - folio no + LineNo
function BuildLineIndex(const UserID : string; GLCode, Folio, LineNo : longint) : Str255;
begin
  Result := FullNomKey(GLCode) + LJVar(UserID, 10) + FullNomKey(Folio) + FullNomKey(LineNo) + '!';
end;

//Index 1 for lines - folio no + Trans Folio No + Trans Line No
function BuildTransLineIndex(const UserID : string; GLCode, Folio,
              TransFolio, LineNo : longint) : Str255;
begin
  Result := FullNomKey(GLCode) + LJVar(UserID, 10) + FullNomKey(Folio) +
               FullNomKey(TransFolio) + FullNomKey(LineNo) + '!';
end;

//Index 2 for statements - folio no + Stat No
function BuildStatLineIndex(const UserID : string; GLCode, Folio, StatNo : longint) : Str255;
begin
  Result := FullNomKey(GLCode) + LJVar(UserID, 10) + FullNomKey(Folio) +
               FullNomKey(MaxInt) + FullNomKey(StatNo) + '!';
end;

function ReconcileObj : TBankReconciliation;
begin
  if not Assigned(BankReconObj) then
    BankReconObj := TBankReconciliation.Create(cidBankRec2);

  Result := BankReconObj;
end;

function TBankReconciliation.AddHeader: Integer;
var
  KeyS : Str255;
begin
  FFolio := bnkHeader.brIntRef;
  FExLocal^.LMLocCtrl^.RecPfix := LteBankRCode;
  FExLocal^.LMLocCtrl^.SubType  := BankRecHeadKey;
  //Fill index fields
  bnkHeader.brBnkCode1 :=
     BuildHeadRefIndex(bnkHeader.brUserId, bnkHeader.brGLCode, bnkHeader.brReconRef);
  bnkHeader.brBnkCode2 :=
     BuildHeadDateIndex(bnkHeader.brUserId, bnkHeader.brGLCode, bnkHeader.brStatDate);
  bnkHeader.brBnkCode3 :=
     BuildHeadFolioIndex(bnkHeader.brUserId, bnkHeader.brGLCode, bnkHeader.brIntRef);
  bnkHeader.brStatus := bssInProgress;


  Move(bnkHeader, FExLocal^.LMLocCtrl^.BnkRHRec, SizeOf(bnkHeader));
  Result := FExLocal^.LAdd_Rec(MLocF, 0);
  if Result = 0 then //Get position for when we need to delete/update
    FExLocal^.LGetPos(MLocF, FHeaderAddress);
  ReconciledAmount := 0;
  MatchedAmount := 0;
end;

function TBankReconciliation.AddLine: Integer;
begin
  FExLocal^.LMLocCtrl^.RecPfix := LteBankRCode;
  FExLocal^.LMLocCtrl^.SubType  := BankRecLineKey;
  bnkDetail.brBnkDCode1 := BuildLineIndex(bnkHeader.brUserId, bnkHeader.brGLCode,
                                            bnkHeader.brIntRef, bnkDetail.brLineNo);
  bnkDetail.brBnkDCode2 := BuildTransLineIndex(bnkHeader.brUserId, bnkHeader.brGLCode, bnkHeader.brIntRef,
                                                bnkDetail.brFolioLink, bnkDetail.brLineNo);
  bnkDetail.brBnkDCode3 := BuildStatLineIndex(bnkHeader.brUserId, bnkHeader.brGLCode,
                                            bnkHeader.brIntRef, bnkDetail.brStatLine);
  bnkDetail.brFolioLink := bnkHeader.brIntRef;
  bnkDetail.brNomCode := bnkHeader.brGLCode;
  {$IFDEF PRDEBUG}
  with TStringList.Create do
  Try
    Add(VarBin(@bnkDetail.brBnkDCode2[0], Length(bnkDetail.brBnkDCode2) + 1));
    SaveToFile('c:\AddLine.txt');
  Finally
    Free;
  End;
  {$ENDIF}

  Move(bnkDetail, FExLocal^.LMLocCtrl^.BnkRDRec, SizeOf(bnkDetail));
  Result := FExLocal^.LAdd_Rec(MLocF, 0);
end;


procedure TBankReconciliation.AddMatch(
  const StatementLine: IBankStatementLine;
  TransDetails: TTempTransDetails);
begin
  //PR: 26/08/2009 FillChar was in AddMatchDetails, so overwriting LineNo & Date
  FillChar(bnkDetail, SizeOf(bnkDetail), 0);
  bnkDetail.brStatLine := StatementLine.bslLineNo;
  bnkDetail.brLineDate := StatementLine.bslLineDate;
  AddMatchDetails(TransDetails);
  AddLine;
end;

procedure TBankReconciliation.AddMatch(
  const StatementLine: TStatementLineRec; TransDetails: TTempTransDetails);
begin
  //PR: 26/08/2009 FillChar was in AddMatchDetails, so overwriting LineNo & Date
  FillChar(bnkDetail, SizeOf(bnkDetail), 0);
  bnkDetail.brStatLine := StatementLine.slLineNo;
  bnkDetail.brLineDate := StatementLine.slDate;
  AddMatchDetails(TransDetails);
  AddLine;
end;

constructor TBankReconciliation.Create(Cid : Integer);
begin
  inherited Create;
  FReconList := TStringList.Create;
  FillChar(bnkHeader, SizeOf(bnkHeader), 0);
  bnkHeader.brUserId := GetUserID;
  New(FExLocal, Create(Cid));
  FExLocal^.Open_System(MLocF, MLocF);
  WasExistingReconcile := False;
  ReconciledAmount := 0;
  MatchedAmount := 0;
  FNoUpdate := False;
  FCancel := False;
  FCacheAdds := False;
  FSQLInsertList := TStringList.Create;
  if not Assigned(oRecToolkit) then
    oRecToolkit := CreateToolkitWithBackDoor as IToolkit3;
  FCompanyCode := CompanyCodeFromPath(oRecToolkit as IToolkit, SetDrive);
end;

function TBankReconciliation.Delete: Integer;
var
  KeyS, KeyChk : Str255;
  SQLDelete : string;
begin

  Result := FindSelf;

  if (Result = 0) {and (Copy(KeyS, 1, Length(KeyChk)) = Copy(KeyChk, 1, Length(KeyChk)))} then
  //Delete header
    Result := FExLocal^.LDelete_Rec(MLocF, 0)
  else
  if not (Result in [0, 4, 9]) then
    raise Exception.Create('Unable to delete reconciliation header record. Btrieve error: ' + IntToStr(Result));

  if not SQLUtils.UsingSQL then
  begin
    KeyS := LteBankRCode + BankRecLineKey + BuildLineIndex(bnkHeader.brUserId, bnkHeader.brGLCode,
                                                           bnkHeader.brIntRef, 0);
    KeyChk := KeyS;

    Result := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 0, KeyS);


    while (Result = 0) and (Copy(KeyS, 1, 20) = Copy(KeyChk, 1, 20)) do
    begin
      Result := FExLocal^.LDelete_Rec(MLocF, 0);

      if Result <> 0 then
        raise Exception.Create('Unable to delete reconciliation line record. Btrieve error: ' + IntToStr(Result));

      Result := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 0, KeyS);
    end;
  end
  else
  begin
    KeyS := BuildLineIndex(bnkHeader.brUserId, bnkHeader.brGLCode, bnkHeader.brIntRef, 0);
    KeyS := VarBin(@KeyS[0], 19);
    KeyS[4] := '7';  //Change length byte
    SQLDelete := Format(SQL_MLOC_DELETE, [FCompanyCode, KeyS]);
    Try
      Result := SQLUtils.ExecSQLEx(SQLDelete, SetDrive, I_TIMEOUT);
      if Result <> 0 then
        raise Exception.Create(SQLUtils.LastSQLError);
    Except
      On E:Exception do
      begin
      {$IFDEF PRDEBUG}
      with TStringList.Create do
      Try
        Add(LastSQLError);
        Add(SQLDelete);
      Finally
        SaveToFile('c:\ReconObj_Delete.txt');
        Free;
      End;
    {$ELSE}
      RaiseSQLError('TReconcileObject.Delete',E.Message, SQLDelete);
    {$ENDIF}
      end;
    End;
  end;

end;

destructor TBankReconciliation.Destroy;
var
  i : integer;
begin
  if Assigned(FReconList) then
  begin
    for i := FReconList.Count - 1 downto 1 do
      if Assigned(FReconList.Objects[i]) then
        FReconList.Objects[i].Free;
    FReconList.Free;
  end;
  FExLocal^.Close_Files;
  Dispose(FExLocal, Destroy);
  if Assigned(FSQLInsertList) then
    FSQLInsertList.Free;
  inherited;
end;

function TBankReconciliation.FindExisting(ShowDialog : Boolean = True): Boolean;
var
  KeyS, KeyChk : Str255;
  Res : integer;
  Found : Boolean;
  sUserID, sPrevUserID : string;
  bInProgress, bOKToContinue, bNewUser : Boolean;
  NewFolio : longint;
  WhereClause, Columns : string;
  SQLRes, CacheId : Integer;

  procedure DeleteAllIncomplete;
  begin
    Found := False;
    Res := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 1, KeyS);
    while (Res = 0) and CheckKey(KeyS, KeyChk, Length(KeyChk), True) do
    begin
      Found := (Res = 0) and CheckKey(KeyS, KeyChk, Length(KeyChk), True) and
                (FExLocal^.LMLocCtrl^.BnkRHRec.brStatus <> bssComplete) ;
      if Found then
      begin
        Delete;
        Res := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 1, KeyS);
      end
      else
        Res := FExLocal^.LFind_Rec(B_GetNext, MLocF, 1, KeyS)
    end;
  end;

begin
  SQLRes := 0;
  WasExistingReconcile := False;
  FCancel := False;
  Result := False;
{  KeyS := LteBankRCode + BankRecHeadKey +
             BuildHeadDateIndex(bnkHeader.brUserId, bnkHeader.brGLCode, bnkHeader.brStatDate);}
{  KeyS := LteBankRCode + BankRecHeadKey +
             BuildHeadUserIndex(bnkHeader.brUserId, bnkHeader.brGLCode);}
  KeyS := LteBankRCode + BankRecHeadKey + FullNomKey(bnkHeader.brGLCode);

  KeyChk := KeyS;
  Found := False;
  if SQLUtils.UsingSQL then
  begin
    Columns := 'RecPFix,SubType,varCode1,varCode2,varCode3,brStatus,brBankUserID,brReconDate';
    WhereClause := 'RecPFix = ''K'' AND SubType = ''1'' AND brGLCode = ' + IntToStr(bnkHeader.brGLCode) +
                   ' AND brStatus < 2';
    SQLRes := CreateCustomPrefillCache('MLocStk', WhereClause, Columns, CacheId, FExLocal^.ExClientID);
    if SQLRes = 0 then
      UseCustomPrefillCache(CacheId, FExLocal^.ExClientID);
  end;
  Res := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 1, KeyS);
  while (Res = 0) and CheckKey(KeyS, KeyChk, Length(KeyChk), True) and not Found do
  begin
    Found := (Res = 0) and CheckKey(KeyS, KeyChk, Length(KeyChk), True) and
              (FExLocal^.LMLocCtrl^.BnkRHRec.brStatus <> bssComplete) ;
    if not Found then
    begin
      if SQLUtils.UsingSQL and (SQLRes = 0) then
        UseCustomPrefillCache(CacheId, FExLocal^.ExClientID);
      Res := FExLocal^.LFind_Rec(B_GetNext, MLocF, 1, KeyS);
    end;
  end;

  if SQLUtils.UsingSQL  and (SQLRes = 0) then
    DropCustomPrefillCache(CacheId);

  if Found then
  begin
    FExLocal^.LGetPos(MLocF, FHeaderAddress);
    if not ShowDialog then
    begin
      DeleteAllIncomplete;
    end
    else
    begin
     {Check User on stored rec against current user - if same then show standard dialog. If different then check Status (stored or InProgress)
      If Stored then show standard dialog (slightly modified), else show new dialog}
      if Trim(FExLocal^.LMLocCtrl^.BnkRHRec.brUserID) = Trim(bnkHeader.brUserId) then
        sUserID := ''
      else
        sUserID := 'User ' + Trim(FExLocal^.LMLocCtrl^.BnkRHRec.brUserID);

      if sUserID <> '' then
        bInProgress := FExLocal^.LMLocCtrl^.BnkRHRec.brStatus = bssInProgress
      else
        bInProgress := False;

      if bInProgress then
      begin
        bOKToContinue :=
                msgBox( 'A reconciliation for this Bank GL Code is currently in progress by user ' + Trim(FExLocal^.LMLocCtrl^.BnkRHRec.brUserID) + '.'#10#10 +
               'If you are sure that this reconciliation is not currently running then click OK to continue,'#10 +
               'otherwise click Cancel.', mtWarning,
               [mbOK, mbCancel], mbCancel, 'Bank Reconciliation Wizard') = mrOK;
      end
      else
        bOKToContinue := True;

      if bOKtoContinue then
      with TfrmIncomplete.Create(Application) do
      Try
        SetDateLabel(POutDate(FExLocal^.LMLocCtrl^.BnkRHRec.brReconDate), sUserID);
        ShowModal;
        bNewUser := sUserID <> '';
        sUserID := bnkHeader.brUserID;
        Move(FExLocal^.LMlocCtrl^.BnkRHRec, bnkHeader, SizeOf(bnkHeader));
        if rbStart.Checked then
        begin
          WasExistingReconcile := False;
          Result := False;
          DeleteAllIncomplete;
          bnkHeader.brUserID := sUserID;
  //        FillChar(bnkHeader, SizeOf(bnkHeader), 0);
        end
        else
        begin
          sPrevUserID := bnkHeader.brUserID;  //Set sPrevUserID to user in file
          bnkHeader.brUserID := sUserID;
          if bNewUser then
          begin
            NewFolio := GetNextFolioF;
            UpdateLinesWithNewUser(sPrevUserID, NewFolio);
          end;
          WasExistingReconcile := True;
          LoadReconciledAmount;
{          if bNewUser then
            bnkHeader.brIntRef := NewFolio;}
          Result := True;
        end;
      Finally
        Free;
      End
      else
        FCancel := True;
      end;
  end;
end;

function TBankReconciliation.FindGroupMatch(
  const PayInRef: string; const sDate : string; LineKey : string = ''): Boolean;
var
  KeyS, KeyChk : Str255;
  Res : Integer;
  Found : Boolean;
  sRef : string;
  RefLen : Integer;
begin
  Found := False;
  if Trim(PayInRef) <> '' then
  begin
    sRef := PayInRef;
    RefLen := 10;
  end
  else
  begin
    sRef := LineKey;
    RefLen := 8;
  end;

  if sRef <> '' then
  begin
    //Search through the group match records to see if this ref exists
    KeyS := LteBankRCode + BankRecLineKey + FullNomKey(bnkHeader.brGLCode) + LJVar(bnkHeader.brUserId, 10) +
               FullNomKey(bnkHeader.brIntRef) + FullNomKey(MaxInt) + FullNomKey(0) + '!';
    KeyChk := KeyS;
    Res := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 1, KeyS);

    while (Res = 0) and CheckKey(KeyS, KeyChk, 24, True) and not Found do
    begin
      Found := (Res = 0) and CheckKey(KeyS, KeyChk, 24, True) and
         CheckKey(FExLocal^.LMLocCtrl^.BnkRDRec.brPayRef, sRef, {Length(sRef)}RefLen, True) and
          GroupDateMatches(FExLocal^.LMLocCtrl^.BnkRDRec.brLineDate, sDate) and
         (FExLocal^.LMLocCtrl^.BnkRDRec.brLineStatus = iMatch);

      if not Found then
        Res := FExLocal^.LFind_Rec(B_GetNext, MLocF, 1, KeyS);

    end;

    if Found then
      Move(FExLocal^.LMLocCtrl^.BnkRDRec, bnkDetail, SizeOf(bnkDetail));
  end;
  
  Result := Found;
end;

function TBankReconciliation.FindLine(const SearchKey: string;
  Index: Integer): Integer;
var
  KeyS, KeyChk : Str255;
  Res : Integer;
begin
  KeyS := LteBankRCode + BankRecLineKey + FullNomKey(bnkHeader.brGLCode) + LJVar(bnkHeader.brUserId, 10) +
             FullNomKey(bnkHeader.brIntRef) +  SearchKey + '!';
  KeyChk := KeyS;
  {$IFDEF PRDEBUG}
  with TStringList.Create do
  Try
    Add(VarBin(@KeyS[0], Length(KeyS) + 1));
    SaveToFile('c:\FindLine.txt');
  Finally
    Free;
  End;
  {$ENDIF}
  Res := FExLocal^.LFind_Rec(B_GetEq, MLocF, Index, KeyS);
  if Res = 0 then
    Move(FExLocal^.LMLocCtrl^.BnkRDRec, bnkDetail, SizeOf(bnkDetail));

  Result := Res;
end;

procedure TBankReconciliation.GetNextFolio;
var
  Res, Folio : Integer;
  KeyS, KeyChk : Str255;
begin
  KeyS := LteBankRCode + BankRecHeadKey + BuildHeadFolioIndex(bnkHeader.brUserId,
                              bnkHeader.brGLCode, MaxInt);
  KeyChk := KeyS;
  Res := FExLocal^.LFind_Rec(B_GetLessEq, MLocF, 2, KeyS);
  if (Res = 0) and CheckKey(KeyS, KeyChk, 16, True) then
    Folio := FExLocal^.LMLocCtrl^.BnkRHRec.brIntRef
  else
    Folio := 0;
  Inc(Folio);
  bnkHeader.brIntRef := Folio;

end;

procedure TBankReconciliation.LoadFromList(const AList: TList);

var
  i, Res : integer;
  pLineRec : ^BnkRDRecType;

begin
  FExLocal^.LMLocCtrl.RecPfix := LteBankRCode;
  FExLocal^.LMLocCtrl.SubType := BankRecLineKey;
  for i := 0 to AList.Count - 1 do
  begin
    pLineRec := AList.Items[i];
    Move(pLineRec^, FExLocal^.LMLocCtrl^.BnkRDRec, SizeOf(pLineRec^));
    Res := FExLocal^.LAdd_Rec(MLocF, 0);
    if Res <> 0 then
      showMessage(IntToStr(Res));
  end;
end;

function TBankReconciliation.SaveToList: TList;
var
  pLineRec : ^BnkRDRecType;
  KeyS, KeyChk : Str255;
  Res : Integer;
begin
  Result := TList.Create;
  KeyS := LteBankRCode + BankRecLineKey + BuildLineIndex(bnkHeader.brUserId, bnkHeader.brGLCode,
                                                         bnkHeader.brIntRef, 0);
  if KeyS[Length(KeyS)] = '!' then
    System.Delete(KeyS, Length(KeyS), 1);
  KeyChk := KeyS;

  Res := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 0, KeyS);


  while (Res = 0) and (Copy(KeyS, 1, 20) = Copy(KeyChk, 1, 20)) do
  begin
    New(pLineRec);
    Move(FExLocal^.LMLocCtrl^.BnkRDRec, pLineRec^, SizeOf(pLineRec^));
    Result.Add(pLineRec);
    Res := FExLocal^.LFind_Rec(B_GetNext, MLocF, 0, KeyS);
  end;
  DeleteAllTags;
end;

procedure TBankReconciliation.SetLineStatus(Stat : Byte);
begin

end;

procedure TBankReconciliation.AddMatchDetails(
  TransDetails: TTempTransDetails);
begin
  DeleteTag(TransDetails);
  bnkDetail.brStatline := TransDetails.btdStatLine;
  bnkDetail.brFolioLink := TransDetails.btdFolioRef;
  bnkDetail.brLineNo := TransDetails.btdLineNo;
  bnkDetail.brLineStatus := TransDetails.btdStatus;
  if Trim(TransDetails.btdPayInRef) <> '' then
    bnkDetail.brPayRef := Trim(TransDetails.btdPayInRef)
  else
    bnkDetail.brPayRef := TransDetails.btdFullPayInRef;
  bnkDetail.brMatchRef := TransDetails.btdOurRef;
  bnkDetail.brCustCode := TransDetails.btdAcCode;
  bnkDetail.brValue := TransDetails.btdAmount;
  //PR: 23/07/2009 Set line date to date of transaction line
  bnkDetail.brLineDate := TransDetails.btdDate;
  if Trim(bnkDetail.brLineDate) = '' then
    bnkDetail.brLineDate := bnkHeader.brReconDate;
  //PR: 21/07/2009 Add check for cleared status - if adding cancelled or returned don't increase reconciled amount.
  //PR: 02/09/2009 - need to include Matched status (8) in check
  if not NoUpdate and (TransDetails.btdStatus in [1, 8]) then
    ReconciledAmount := ReconciledAmount + bnkDetail.brValue;
end;

function TBankReconciliation.UpdateHeader(bStoreRec : Boolean = True): Integer;
var
  Res : Integer;
  KeyS, KeyChk : Str255;
begin
  //Reposition on header record
  FExLocal^.LastRecAddr[MLocF] := FHeaderAddress;
  Result := FExLocal^.LGetDirectRec(MLocF, 0);

{  KeyS := LteBankRCode + BankRecHeadKey +
//             BuildHeadUserIndex(bnkHeader.brUserId, bnkHeader.brGLCode);
            BuildHeadRefIndex(bnkHeader.brUserId, bnkHeader.brGLCode, bnkHeader.brReconRef);

  KeyChk := KeyS;
  Result := FExLocal^.LFind_Rec(B_GetEq, MLocF, 0, KeyS);}

  if (Result = 0) {and CheckKey(KeyS, KeyChk, Length(KeyChk), True)} then
  begin
    bnkHeader.brBnkCode1 :=
      BuildHeadRefIndex(bnkHeader.brUserId, bnkHeader.brGLCode, bnkHeader.brReconRef);
    bnkHeader.brBnkCode2 :=
       BuildHeadDateIndex(bnkHeader.brUserId, bnkHeader.brGLCode, bnkHeader.brStatDate);
    bnkHeader.brBnkCode3 :=
       BuildHeadFolioIndex(bnkHeader.brUserId, bnkHeader.brGLCode, bnkHeader.brIntRef);
    if bStoreRec then
    begin
      Move(bnkHeader, FExLocal^.LMLocCtrl^.BnkRHRec, SizeOf(bnkHeader));
      Result := FExLocal^.LPut_Rec(MLocF, 0);
    end
    else
      Result := 0;
  end;
end;

procedure TBankReconciliation.UpdateLine;

  function ReplaceUser(const s : string) : string;
  begin
    //PR: 05/08/2009 Added IntRef (FolioLink) to replace.
    Result := s;
    System.Delete(Result, 5, 14);
    Insert(LJVar(bnkHeader.brUserId, 10) + FullNomKey(bnkHeader.brIntRef), Result, 5);
  end;

begin
  FExLocal^.LMLocCtrl^.BnkRDRec.brBnkDCode1 := BuildLineIndex(bnkHeader.brUserId, bnkHeader.brGLCode,
                                            bnkHeader.brIntRef, FExLocal^.LMLocCtrl^.BnkRDRec.brLineNo);
{  FExLocal^.LMLocCtrl^.BnkRDRec.brBnkDCode2 := BuildTransLineIndex(bnkHeader.brUserId, bnkHeader.brGLCode, bnkHeader.brIntRef,
                                                FExLocal^.LMLocCtrl^.BnkRDRec.brFolioLink, FExLocal^.LMLocCtrl^.BnkRDRec.brLineNo);}

  FExLocal^.LMLocCtrl^.BnkRDRec.brBnkDCode2 := ReplaceUser(FExLocal^.LMLocCtrl^.BnkRDRec.brBnkDCode2);
  FExLocal^.LMLocCtrl^.BnkRDRec.brBnkDCode3 := BuildStatLineIndex(bnkHeader.brUserId, bnkHeader.brGLCode,
                                            bnkHeader.brIntRef, FExLocal^.LMLocCtrl^.BnkRDRec.brStatLine);
end;



function TBankReconciliation.FindByRef(const ARef: string; GLCode: Integer;
  var HedRec: BnkRHRecType): Integer;
var
  KeyS : Str255;
begin
  KeyS := LteBankRCode + BankRecHeadKey + BuildHeadRefIndex(GetUserID, GLCode, ARef);
  if FExLocal^.LCheckRecExsists(KeyS, MLocF, 0) then
  begin
    Move(FExLocal^.LMLocCtrl^.BnkRHRec, HedRec, SizeOf(HedRec));
    Result := 0;
  end
  else
    Result := 4;
end;

procedure TBankReconciliation.DeleteMatch(const SearchKey: string; const sDate : string;
  IsGroup: Boolean);
begin
  if not IsGroup then
  begin
    While FindLine(SearchKey, 2) = 0 do
    begin
      if Trim(FExLocal^.LMlocCtrl^.BnkRDRec.brMatchRef) <> 'RUN' then
        ReconciledAmount := ReconciledAmount - FExLocal^.LMlocCtrl^.BnkRDRec.brValue;
      FExLocal^.LDelete_Rec(MLocF, 2);
    end;
  end
  else
  begin
    if FindGroupMatch(SearchKey, sDate) then
    begin
      //ReconciledAmount := ReconciledAmount - FExLocal^.LMlocCtrl^.BnkRDRec.brValue;
      FExLocal^.LDelete_Rec(MLocF, 2);
    end;
  end;
end;

procedure TBankReconciliation.DeleteAllGroupLines;
var
  KeyS, KeyChk : Str255;
  Res, Res1 : Integer;
begin
  KeyS := LteBankRCode + BankRecLineKey + FullNomKey(bnkHeader.brGLCode) + LJVar(bnkHeader.brUserId, 10) +
             FullNomKey(bnkHeader.brIntRef) + FullNomKey(MaxInt) + FullNomKey(0) + '!';
  KeyChk := KeyS;
  Res := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 1, KeyS);

  while (Res = 0) and CheckKey(KeyS, KeyChk, 24, True) do
  begin
    Res1 := FExLocal^.LDelete_Rec(MLocF, 1);

    Res := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 1, KeyS);
  end;

end;

procedure TBankReconciliation.AddClearedRec(
  TransDetails: TTempTransDetails);
begin
  AddMatchDetails(TransDetails);
  AddLine;
end;

procedure TBankReconciliation.RemoveClearedRec(
  TransDetails: TTempTransDetails);
begin
//  if TransDetails.btdDocType <> 'RUN' then
  if not NoUpdate then
    ReconciledAmount := ReconciledAmount + (TransDetails.btdAmount * StatusSign(TransDetails.btdStatus and 3));
  FExLocal^.LDelete_Rec(MLocF, 1);
end;

procedure TBankReconciliation.AddTag(TransDetails: TTempTransDetails);
var
  Res : integer;
begin
  FillChar(bnkDetail, SizeOf(BnkDetail), 0);
  bnkDetail.brFolioLink := MaxInt - 1;
  bnkDetail.brLineNo := TransDetails.btdLineNo;
  bnkDetail.brPayRef := TransDetails.btdLineKey;
  bnkDetail.brStatId := 'TAG';
  bnkDetail.brCustCode := TransDetails.btdDocType;
  Res := AddLine;
  if Res <> 0 then
    ShowMessage(IntToStr(Res));
end;

procedure TBankReconciliation.DeleteAllTags;
var
  KeyS, KeyChk : Str255;
  Res : Integer;
begin
  KeyS := LteBankRCode + BankRecLineKey + FullNomKey(bnkHeader.brGLCode) + LJVar(bnkHeader.brUserId, 10) +
             FullNomKey(bnkHeader.brIntRef) + FullNomKey(MaxInt - 1) + FullNomKey(0);
  KeyChk := KeyS;
  Res := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 1, KeyS);

  while (Res = 0) and CheckKey(KeyS, KeyChk, 24, True) and (Trim(FExLocal^.LMLocCtrl^.BnkRDRec.brStatId) = 'TAG') do
  begin
    FExLocal^.LDelete_Rec(MLocF, 1);

    Res := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 1, KeyS);

  end;

end;

function TBankReconciliation.FindTag(
  TransDetails: TTempTransDetails): Boolean;
var
  KeyS, KeyChk : Str255;
  Res : Integer;
  Found : Boolean;
begin
//Search through the tag records to see if this ref exists
  Found := False;
  KeyS := LteBankRCode + BankRecLineKey + FullNomKey(bnkHeader.brGLCode) + LJVar(bnkHeader.brUserId, 10) +
             FullNomKey(bnkHeader.brIntRef) + FullNomKey(MaxInt-1) + FullNomKey(0);
  KeyChk := KeyS;
  Res := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 1, KeyS);

  while (Res = 0) and CheckKey(KeyS, KeyChk, 24, True) and
        (Trim(FExLocal^.LMLocCtrl^.BnkRDRec.brStatId) = 'TAG') and not Found do
  begin
    Found := (Res = 0) and CheckKey(KeyS, KeyChk, 24, True) and
       (Trim(FExLocal^.LMLocCtrl^.BnkRDRec.brStatId) = 'TAG') and
       (Trim(FExLocal^.LMLocCtrl^.BnkRDRec.brCustCode) = TransDetails.btdDocType) and
       (Copy(FExLocal^.LMLocCtrl^.BnkRDRec.brPayRef, 1, 8) = TransDetails.btdLineKey);

    if not Found then
      Res := FExLocal^.LFind_Rec(B_GetNext, MLocF, 1, KeyS);

  end;

{  if Found then
    Move(FExLocal^.LMLocCtrl^.BnkRDRec, bnkDetail, SizeOf(bnkDetail));}

  Result := Found;
end;

procedure TBankReconciliation.DeleteTag(TransDetails: TTempTransDetails);
var
  KeyS, KeyChk : Str255;
  Res : Integer;
  Found : Boolean;
begin
  Found := False;
  KeyS := LteBankRCode + BankRecLineKey + FullNomKey(bnkHeader.brGLCode) + LJVar(bnkHeader.brUserId, 10) +
             FullNomKey(bnkHeader.brIntRef) + FullNomKey(MaxInt-1) + FullNomKey(0) + '!';
  KeyChk := KeyS;
  Res := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 1, KeyS);

  while (Res = 0) and CheckKey(KeyS, KeyChk, 24, True) and
        (Trim(FExLocal^.LMLocCtrl^.BnkRDRec.brStatId) = 'TAG') and not Found do
  begin
    Found := (Res = 0) and CheckKey(KeyS, KeyChk, 24, True) and
       (Trim(FExLocal^.LMLocCtrl^.BnkRDRec.brStatId) = 'TAG') and
       (Copy(FExLocal^.LMLocCtrl^.BnkRDRec.brPayRef, 1, 8) = TransDetails.btdLineKey);

    if Found then
      FExLocal^.LDelete_Rec(MLocF, 1)
    else
      Res := FExLocal^.LFind_Rec(B_GetNext, MLocF, 1, KeyS);

  end;
end;

procedure FreeReconcileObj;
begin
  FreeAndNil(BankReconObj);
end;

function TBankReconciliation.FindByFolio(BankRec : BnkRHRecType): Integer;
var
  KeyS : Str255;
begin
  KeyS := LteBankRCode + BankRecHeadKey + BuildHeadFolioIndex(BankRec.brUserId, BankRec.brGLCode, BankRec.brIntRef);
  Result := FExLocal^.LFind_Rec(B_GetEq, MLocF, 2, KeyS);
  if Result = 0 then
  begin
    FExLocal^.LGetRecAddr(MLocF);
    Move(FExLocal^.LMLocCtrl^.BnkRHRec, bnkHeader, SizeOf(bnkHeader));
    FHeaderAddress := FExLocal^.LastRecAddr[MLocF];
  end;
end;

procedure TBankReconciliation.AddMatch(
  const StatementLine: IBankStatementLine; Trans: ITransaction);
begin
  bnkDetail.brLineDate := StatementLine.bslLineDate;
  bnkDetail.brLineNo := Trans.thLines[1].tlABSLineNo;
  bnkDetail.brStatLine := StatementLine.bslLineNo;

  bnkDetail.brFolioLink := Trans.thFolioNum;
  bnkDetail.brLineStatus := iComplete;
  bnkDetail.brPayRef := (Trans.thLines[1] as ITransactionLine2).tlAsNom.tlnDescription;
  bnkDetail.brMatchRef := Trans.thOurRef;
  bnkDetail.brValue := StatementLine.bslValue;
  ReconciledAmount := ReconciledAmount + bnkDetail.brValue;
  AddLine;
end;



procedure TBankReconciliation.LoadReconciledAmount;
var
  KeyS, KeyChk, sTag : Str255;
  Res : Integer;
  ReconStat : TReconStatus;
begin
  if SQLUtils.UsingSQL then
    ReconciledAmount := GetReconciledAmountSQL
  else
  begin
    ReconciledAmount := 0;
    KeyS := LteBankRCode + BankRecLineKey + BuildLineIndex(bnkHeader.brUserId, bnkHeader.brGLCode,
                                                           bnkHeader.brIntRef, 0);
    KeyChk := KeyS;

    Res := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 0, KeyS);


    while (Res = 0) and (Copy(KeyS, 1, 20) = Copy(KeyChk, 1, 20)) do
    begin
      //PR: 16/07/2009 Don't add value of Group records as it will double up the reconciled amount
      if (FExLocal^.LMLocCtrl^.BnkRDRec.brMatchRef <> 'RUN') and
       (FExLocal^.LMLocCtrl^.BnkRDRec.brLineStatus in [1, iMatch]) then
        ReconciledAmount := ReconciledAmount + FExLocal^.LMLocCtrl^.BnkRDRec.brValue;
      if FExLocal^.LMLocCtrl^.BnkRDRec.brStatID = 'TAG' then
      begin
        sTag := BuildTagKey(FExLocal^.LMLocCtrl^.BnkRDRec);
        FReconList.Add(sTag);
      end
      else
      begin
        ReconStat := TReconStatus.Create;
        ReconStat.rStatus := FExLocal^.LMLocCtrl^.BnkRDRec.brLineStatus;
        ReconStat.rStatLine := FExLocal^.LMLocCtrl^.BnkRDRec.brStatLine;
        FReconList.AddObject(FExLocal^.LMLocCtrl^.BnkRDRec.brBnkDCode2, ReconStat);
      end;

      //PR: This was in the else clause above, so if a tagged record was found GetNext was never called and the same record was added until
      //we ran out of memory.
      Res := FExLocal^.LFind_Rec(B_GetNext, MLocF, 0, KeyS);
    end;
  end;
end;

function TBankReconciliation.FindStatusFromList(
  const SearchKey: string): Integer;
var
  KeyS : string;
  i : integer;
begin
  Result := -1;
  KeyS := {LteBankRCode + BankRecLineKey + }FullNomKey(bnkHeader.brGLCode) + LJVar(bnkHeader.brUserId, 10) +
             FullNomKey(bnkHeader.brIntRef) +  SearchKey + '!';

  i := FReconList.IndexOf(KeyS);
  if i >=0 then
  begin
    Result := TReconStatus(FReconList.Objects[i]).rStatus;
  end;
end;

function TBankReconciliation.FindStatLineFromList(
  const SearchKey: string): Integer;
var
  KeyS : string;
  i : integer;
begin
  Result := 0;
  KeyS := {LteBankRCode + BankRecLineKey + }FullNomKey(bnkHeader.brGLCode) + LJVar(bnkHeader.brUserId, 10) +
             FullNomKey(bnkHeader.brIntRef) +  SearchKey + '!';

  i := FReconList.IndexOf(KeyS);
  if i >=0 then
  begin
    Result := TReconStatus(FReconList.Objects[i]).rStatLine;
  end;
end;


function TBankReconciliation.BuildTagKey(
  RDRec : BnkRDRecType): string;
begin
  Result := RDRec.brCustCode + LJVar(RDRec.brPayRef, 8);
end;

function TBankReconciliation.FindTagFromList(
  TransDetails: TTempTransDetails): Boolean;
var
  KeyS : string;
begin
  KeyS :=  TransDetails.btdDocType + LJVar(TransDetails.btdLineKey, 8);

  Result := FReconList.IndexOf(KeyS) >= 0;
end;

function TBankReconciliation.GetFirstLine: Integer;
var
  KeyChk : Str255;
  WhereClause, Columns : AnsiString;
  Res : Integer;
begin
  if UsingSQL then
  begin
{    WhereClause := GetDBColumnName('MLocStk.dat', 'rec_pfix', '') + ' = ' + QuotedStr(LteBankRCode) + ' AND ' +
                   GetDBColumnName('MLocStk.dat', 'sub_type', '') + ' = ' + QuotedStr(BankRecLineKey) + ' AND ' +
                   GetDBColumnName('MLocStk.dat', 'br_nom_code', 'K2') + ' = ' + IntToStr(bnkHeader.brGLCode) + ' AND ' +
                   GetDBColumnName('MLocStk.dat', 'br_bank_user_id', 'K2') + ' = ' + QuotedStr(bnkHeader.brUserId) + ' AND ' +
                   GetDBColumnName('MLocStk.dat', 'br_int_ref', 'K2') + ' = ' + IntToStr(bnkHeader.brIntRef);
    Columns := GetAllBnkRHRecFields;
    Res := CreateCustomPrefillCache(SetDrive + Filenames[MLocF], WhereClause, Columns, CacheID, @FExLocal.ExClientId);
    UseCustomPrefillCache(CacheID, @FExLocal.ExClientId);}
  end;
  FKeyS := LteBankRCode + BankRecLineKey + FullNomKey(bnkHeader.brGLCode) + LJVar(bnkHeader.brUserId, 10) +
             FullNomKey(bnkHeader.brIntRef);
  KeyChk := FKeyS;
  Result := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 1, FKeyS);
  if (Result = 0) and (Copy(FKeyS, 1, Length(KeyChk)) = Copy(KeyChk, 1, Length(KeyChk))) then
    Move(FExLocal^.LMLocCtrl^.BnkRDRec, bnkDetail, SizeOf(bnkDetail))
  else
    Result := 9;
end;

function TBankReconciliation.GetNextLine: Integer;
var
  KeyChk : Str255;
begin
  KeyChk := LteBankRCode + BankRecLineKey + FullNomKey(bnkHeader.brGLCode) + LJVar(bnkHeader.brUserId, 10) +
             FullNomKey(bnkHeader.brIntRef);
{  if UsingSQL then
    UseCustomPrefillCache(CacheID, @FExLocal.ExClientId);}
  Result := FExLocal^.LFind_Rec(B_GetNext, MLocF, 1, FKeyS);
  if (Result = 0) and (Copy(FKeyS, 1, Length(KeyChk)) = Copy(KeyChk, 1, Length(KeyChk))) then
    Move(FExLocal^.LMLocCtrl^.BnkRDRec, bnkDetail, SizeOf(bnkDetail))
  else
  begin
    Result := 9;
{    if UsingSQL then
      DropCustomPrefillCache(CacheID, @FExLocal.ExClientId);}
  end;
end;

function TBankReconciliation.LineRef: String;
begin
  Result := Copy(bnkDetail.brBnkDCode2, 19, 8);
end;

procedure TBankReconciliation.CloseSession;
begin
{  if UsingSQL then
    CloseClientIDSession(FExLocal.ExClientID, False);}
end;

procedure TBankReconciliation.RestoreExLocal;
begin
  FExLocal := FStoredExLocal;
  FStoredExLocal := nil;
end;

procedure TBankReconciliation.SetExLocal(const Value: TdPostExLocalPtr);
begin
  if not Assigned(FStoredExLocal) then
    FStoredExLocal := FExLocal;
  FExLocal := Value;
end;

procedure TBankReconciliation.SetReconciledAmount(const Value: Double);
begin
  FReconciledAmount := Value;
end;

procedure TBankReconciliation.SetClearedRec(
  TransDetails: TTempTransDetails);
begin
  //PR: 23/07/2009 Changed so that ReconciledAmount is only ever updated by itemised lines.
  if TransDetails.btdDocType = 'RUN' then
    FNoUpdate := True;
  Try
    if not FCacheAdds and (FindLine(TransDetails.btdLineKey, 1) = 0) then
    begin
      if ((TransDetails.btdStatus and 3) = 0) and ((TransDetails.btdDocType <> 'RUN') or (TransDetails.btdNumberCleared = 0)) then
        RemoveClearedRec(TransDetails)
      else
        UpdateClearedRec(TransDetails);
    end
    else
    if TransDetails.btdStatus <> 0 then
      AddClearedRec(TransDetails);
  Finally
    if TransDetails.btdDocType = 'RUN' then
      FNoUpdate := False;
  End;
end;


procedure TBankReconciliation.UpdateLinesWithNewUser(const  sPrevUser : string; NewFolio : longint);
var
  KeyS, KeyChk : Str255;
  Res : Integer;

begin
  KeyS := LteBankRCode + BankRecLineKey + BuildLineIndex(sPrevUser, bnkHeader.brGLCode,
                                                         bnkHeader.brIntRef, 0);
  //PR: 05/08/2009 Need to set IntRef to new folio so that keys are built correctly in UpdateLine.
  bnkHeader.brIntRef := NewFolio;
  KeyChk := KeyS;

  Res := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 0, KeyS);

  while (Res = 0) and (Copy(KeyS, 1, 20) = Copy(KeyChk, 1, 20)) do
  begin
    UpdateLine;
    FExLocal^.LMLocCtrl^.BnkRDRec.brFolioLink := NewFolio;
    Res := FExLocal^.LPut_Rec(MLocF, 0);
    if Res = 0 then
      Res := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 0, KeyS);
  end;
  UpdateHeader(False);
end;

procedure TBankReconciliation.UpdateClearedRec(
  TransDetails: TTempTransDetails);
begin
//  if TransDetails.btdDocType <> 'RUN' then
  if not NoUpdate then
    ReconciledAmount := ReconciledAmount + (TransDetails.btdAmount * StatusSign(TransDetails.btdStatus and 3));
  FExLocal^.LMLocCtrl^.BnkRDRec.brLineStatus := TransDetails.btdStatus;
  FExLocal^.LPut_Rec(MLocF, 1);
end;

function TBankReconciliation.StatusSign(NewStatus : Byte): Integer;
const
  Signs : Array [0..3, 0..3] of Integer = (               //Rows are New Status, Columns are Existing Status
                                            (0, -1, 0, 0),
                                            (1,  0, 1, 1),
                                            (0, -1, 0, 0),
                                            (0, -1, 0, 0)
                                          );
var
  CurrentStatus : Byte;
begin
  CurrentStatus := 3 and FExLocal^.LMLocCtrl^.BnkRDRec.brLineStatus;

  Result := Signs[NewStatus, CurrentStatus];
end;





procedure TBankReconciliation.SetNoUpdate(const Value: Boolean);
begin
  FNoUpdate := Value;
end;

function TBankReconciliation.GetNextFolioF: longint;
var
  Res, Folio : Integer;
  KeyS, KeyChk : Str255;
begin
  KeyS := LteBankRCode + BankRecHeadKey + BuildHeadFolioIndex(bnkHeader.brUserId,
                              bnkHeader.brGLCode, MaxInt);
  KeyChk := KeyS;
  Res := FExLocal^.LFind_Rec(B_GetLessEq, MLocF, 2, KeyS);
  if (Res = 0) and CheckKey(KeyS, KeyChk, 16, True) then
    Folio := FExLocal^.LMLocCtrl^.BnkRHRec.brIntRef
  else
    Folio := 0;
  Inc(Folio);

  Result := Folio;
end;


function TBankReconciliation.FindGroupMatchForStatement(
  const PayInRef: string; const iLineNo : Integer; LineKey: string): Boolean;
var
  KeyS, KeyChk : Str255;
  Res : Integer;
  Found : Boolean;
  sRef : string;
  RefLen : Integer;
begin
  Found := False;
  if Trim(PayInRef) <> '' then
  begin
    sRef := PayInRef;
    RefLen := 10;
  end
  else
  begin
    sRef := LineKey;
    RefLen := 8;
  end;

  if sRef <> '' then
  begin
    //Search through the group match records to see if this ref exists
    KeyS := LteBankRCode + BankRecLineKey + FullNomKey(bnkHeader.brGLCode) + LJVar(bnkHeader.brUserId, 10) +
               FullNomKey(bnkHeader.brIntRef) + FullNomKey(MaxInt) + FullNomKey(0) + '!';
    KeyChk := KeyS;
    Res := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 1, KeyS);

    while (Res = 0) and CheckKey(KeyS, KeyChk, 24, True) and not Found do
    begin
      Found := (Res = 0) and CheckKey(KeyS, KeyChk, 24, True) and
         CheckKey(FExLocal^.LMLocCtrl^.BnkRDRec.brPayRef, sRef, {Length(sRef)}RefLen, True) and
          (FExLocal^.LMLocCtrl^.BnkRDRec.brStatLine = iLineNo) and
         (FExLocal^.LMLocCtrl^.BnkRDRec.brLineStatus = iMatch);

      if not Found then
        Res := FExLocal^.LFind_Rec(B_GetNext, MLocF, 1, KeyS);

    end;

    if Found then
      Move(FExLocal^.LMLocCtrl^.BnkRDRec, bnkDetail, SizeOf(bnkDetail));
  end;
  
  Result := Found;
end;

procedure TBankReconciliation.ProcessCurrentRecord;
var
  s : string;
begin
{  with bnkDetail do
    s := Format(S_MLOC_INSERT, [FCompanyCode,
                                VarBin(@brBnkDCode1[0], Length(brBnkDCode1) + 1),
                                VarBin(@brBnkDCode2[0], Length(brBnkDCode2) + 1),
                                VarBin(@brBnkDCode3[0], Length(brBnkDCode3) + 1),
                                VarBin(@brPayRef[0], Length(brPayRef) + 1),
                                brLineDate,
                                brMatchRef,
                                brValue,
                                brLineNo,
                                brStatLine,
                                brCustCode,
                                brFolioLink,
                                brLineStatus]);
  FSQLInsertList.Add(s);}
end;

procedure TBankReconciliation.InsertCachedAddsToTable;
var
  Res : Integer;
  i : Integer;

begin
{  Res := SQLUtils.ExecSQL(FSQLInsertList.Text, SetDrive);
  if Res <> 0 then
    raise Exception.Create(SQLUtils.LastSQLError); }
{  Try
    FSQLInsertList.SaveToFile('c:\ReconObj_sqlQuery.txt');
    Res := SQLUtils.ExecSQL(FSQLInsertList.Text, SetDrive);
    if Res <> 0 then
      raise Exception.Create(SQLUtils.LastSQLError);
  Except
    On E:Exception do
    begin
      with TStringList.Create do
      Try
        Add(E.Message);
      Finally
        SaveToFile('c:\ReconObj_sqlerror.txt');
        Free;
      End;
    end;
  End;}
  i := 0;
  Res := 0;
  while (Res = 0) and (i < FSQLInsertList.Count) do
  begin
    Res := SQLUtils.ExecSQLEx(FSQLInsertList[i], SetDrive, I_TIMEOUT);
    if Res <> 0 then
    with TStringList.Create do
    Try
      Add(LastSQLError);
      Add(FSQLInsertList[i]);
    Finally
//      SaveToFile('c:\ReconObj_sqlerror' + IntToStr(i) + '.txt');
      Free;
    End;
    inc(i);
  end;
end;

function TBankReconciliation.GetReconciledAmountSQL: Double;
var
  V : Variant;
  Res : Integer;
  sQuery : String;
begin
  //GS: 29/02/2012 ABSEXCH-11785 : added formatting checks to certain string arguments
  //(to check for quote chars that could break SQLs interpretation)
  //user IDs can potentially contain ['] chars; so preform a format check
  sQuery := Format(SQL_SUM_RECONCILED_MLOC, [bnkHeader.brGLCode, LJVar(TSQLCaller.CompatibilityFormat(bnkHeader.brUserID), 10), bnkHeader.brIntRef ]);
  Res := SQLUtils.SQLFetch(sQuery, 'RecAmount', SetDrive, V);
  if Res = 0 then
    Result := V
  else
    Result := 0;


end;

function TBankReconciliation.GetUnclearedOnly: Boolean;
begin
  Result := StrToBool(bnkHeader.brBankAcc);
end;

procedure TBankReconciliation.SetUnclearedOnly(const Value: Boolean);
begin
  bnkHeader.brBankAcc := BoolToStr(Value);
end;

//Returns true if an incomplete reconciliation is found for any GL Code.
function TBankReconciliation.FindAnyExisting: Boolean;
var
  KeyS, KeyChk : Str255;
  Res : integer;
  WhereClause, Columns : string;
  SQLRes, CacheId : Integer;
begin
  Result := False;
  SQLRes := 0;
  
  KeyS := LteBankRCode + BankRecHeadKey;
  KeyChk := KeyS;

  if SQLUtils.UsingSQL then
  begin
    Columns := 'RecPFix,SubType,varCode1,varCode2,varCode3,brStatus,brBankUserID,brReconDate';
    WhereClause := 'RecPFix = ''K'' AND SubType = ''1''' +
                   ' AND brStatus < 2';
    SQLRes := CreateCustomPrefillCache('MLocStk', WhereClause, Columns, CacheId, FExLocal^.ExClientID);
    if SQLRes = 0 then
      UseCustomPrefillCache(CacheId, FExLocal^.ExClientID);
  end;

  Try
    Res := FExLocal^.LFind_Rec(B_GetGEq, MLocF, 1, KeyS);

    while (Res = 0) and CheckKey(KeyS, KeyChk, Length(KeyChk), True) and not Result do
    begin
      Result := (Res = 0) and CheckKey(KeyS, KeyChk, Length(KeyChk), True) and
                (FExLocal^.LMLocCtrl^.BnkRHRec.brStatus <> bssComplete) ;

      if not Result then
      begin
        if SQLUtils.UsingSQL and (SQLRes = 0) then
          UseCustomPrefillCache(CacheId, FExLocal^.ExClientID);
        Res := FExLocal^.LFind_Rec(B_GetNext, MLocF, 1, KeyS);
      end;
    end;

  Finally
    if SQLUtils.UsingSQL  and (SQLRes = 0) then
      DropCustomPrefillCache(CacheId);
  End;

  
end;

function TBankReconciliation.GetGroupBy: TGroupBy;
begin
  Result := TGroupBy(bnkHeader.brGroupBy);
end;

procedure TBankReconciliation.SetGroupBy(const Value: TGroupBy);
begin
  bnkHeader.brGroupBy := Ord(Value);
end;

function TBankReconciliation.GroupDateMatches(const ADate1,
  ADate2: string): Boolean;
begin
  Result := (GroupBy = gbRefOnly) or (ADate1 = ADate2);
end;

function TBankReconciliation.FindSelf: Integer;
var
  KeyS : Str255;
  KeyChk : Str255;
begin
  Keys := LteBankRCode + BankRecHeadKey + BuildHeadFolioIndex(bnkHeader.brUserId, bnkHeader.brGLCode, bnkHeader.brIntRef);
  Result := FExLocal^.LFind_Rec(B_GetEq, MLocF, 2, KeyS);
end;

Initialization
  BankReconObj := nil;

end.
