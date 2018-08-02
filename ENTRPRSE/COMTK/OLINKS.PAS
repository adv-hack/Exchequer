unit oLinks;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarRec2U, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve,
     MiscFunc, BtrvU2, ExBtTH1U, GlobList;

type

  TLinks = class(TBtrieveFunctions, ILinks, IBrowseInfo)
  private
    FIntfType       : TInterfaceMode;
    function IsLetter : Boolean;
    procedure BlankData;
  protected
    FLinkRec : TBatchLinkRec;
    FOwnerCode : String;
    FOwnerFolio : longint;
    FAttachTo  : Char;
    function Get_lkType: TLinkType; safecall;
    function Get_lkDate: WideString; safecall;
    procedure Set_lkDate(const Value: WideString); safecall;
    function Get_lkTime: WideString; safecall;
    procedure Set_lkTime(const Value: WideString); safecall;
    function Get_lkUser: WideString; safecall;
    procedure Set_lkUser(const Value: WideString); safecall;
    function Get_lkFileName: WideString; safecall;
    procedure Set_lkFileName(const Value: WideString); safecall;
    function Get_lkDescription: WideString; safecall;
    procedure Set_lkDescription(const Value: WideString); safecall;
    function Get_lkObjectType: TLinkObjectType; safecall;
    procedure Set_lkObjectType(Value: TLinkObjectType); safecall;
    function Add: ILinks; safecall;
    function Save: Integer; safecall;
    function Update: ILinks; safecall;
    procedure Cancel; safecall;
    function Delete: Integer; safecall;

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    procedure SetSQLCaching(SubType : Char = ' '); override;
  public
    Constructor Create (Const IType         : TInterfaceMode;
                        Const BtrIntf       : TCtkTdPostExLocalPtr;
                        const AttachTo      : Char;
                        const AttachToRec   : String;
                        const AttachToFolio : longint);
    procedure InitNewLinks;
    Procedure LoadDetails (Const LinkDets : TBatchLinkRec; Const LockPos : LongInt);

    property OwnerType : Char read FAttachTo write FAttachTo;
    property OwnerCode : String read FOwnerCode write FOwnerCode;
    property OwnerFolio : longint read FOwnerFolio write FOwnerFolio;

  end;



implementation

uses
  Links, ComServ, oToolkit, DLLSK01U, DllErrU, BtsupU1, BtKeys1U, EtStrU, EtMiscU;


Constructor TLinks.Create (Const IType         : TInterfaceMode;
                           Const BtrIntf       : TCtkTdPostExLocalPtr;
                           const AttachTo      : Char;
                           const AttachToRec   : String;
                           const AttachToFolio : longint);
begin
  Inherited Create (ComServer.TypeLib, ILinks, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := MiscF;
  FIndex := 0;
  FAttachTo := AttachTo;
  FOwnerCode := AttachToRec;
  FOwnerFolio := AttachToFolio;
  FIntfType := IType;

  FObjectID := tkoLink;
end;



function TLinks.IsLetter : Boolean;
begin
  Result := FLinkRec.lkLetterLink = 'L';

end;

function TLinks.Get_lkType: TLinkType;
begin
  if FLinkRec.lkLetterLink = 'L' then
    Result := lkTypeLetter
  else
    Result := lkTypeLink;
end;

function TLinks.Get_lkDate: WideString;
begin
  Result := FLinkRec.lkDate;
end;

procedure TLinks.Set_lkDate(const Value: WideString);
begin
  FLinkRec.lkDate := Value;
end;

function TLinks.Get_lkTime: WideString;
begin
  Result := FLinkRec.lkTime;
end;

procedure TLinks.Set_lkTime(const Value: WideString);
begin
  FLinkRec.lkTime := Value;
end;

function TLinks.Get_lkUser: WideString;
begin
  Result := FLinkRec.lkUserCode;
end;

procedure TLinks.Set_lkUser(const Value: WideString);
begin
  FLinkRec.lkUserCode := Value;
end;

function TLinks.Get_lkFileName: WideString;
begin
  if IsLetter then
    Result := FLinkRec.lkLetterFileName
  else
    Result := FLinkRec.lkLinkFileName;
end;

procedure TLinks.Set_lkFileName(const Value: WideString);
begin
  if IsLetter then

  else
    FLinkRec.lkLinkFileName := Value;
end;

function TLinks.Get_lkDescription: WideString;
begin
  if IsLetter then
    Result := FLinkRec.lkLetterDescription
  else
    Result := FLinkRec.lkLinkDescription;
end;

procedure TLinks.Set_lkDescription(const Value: WideString);
begin
  if IsLetter then
    FLinkRec.lkLetterDescription := Value
  else
    FLinkRec.lkLinkDescription := Value;
end;

function TLinks.Get_lkObjectType: TLinkObjectType;
begin
  Result := TLinkObjectType(FLinkRec.lkLinkType);
end;

procedure TLinks.Set_lkObjectType(Value: TLinkObjectType);
begin
  if not IsLetter then
    FLinkRec.lkLinkType := Ord(Value);
end;

function TLinks.Add: ILinks;
var
  FLinksO : TLinks;
begin
  AuthoriseFunction(100, 'Add');

  FLinksO := TLinks.Create(imAdd, FBtrIntf, FAttachTo, FOwnerCode, FOwnerFolio);
  FLinksO.InitNewLinks;

  Result := FLinksO;
end;

function TLinks.Save: Integer;
Var
  SaveInfo     : TBtrieveFileSavePos;
  SaveInfo2    : TBtrieveFileSavePos;
  BtrOp, Res   : SmallInt;
begin
  AuthoriseFunction(102, 'Save');

  // Save Current Position in global customer file
  SaveMainPos(SaveInfo);

  If (FIntfType = imUpdate) Then Begin
    // Updating - Reposition on original Locked item
    Res := PositionOnLock;
    BtrOp := B_Update;
  End { If (FIntfType = imUpdate) }
  Else Begin
    // Adding - no need to do anything
    Res := 0;
    BtrOp := B_Insert;
  End; { Else }

  If (Res = 0) Then Begin
    // Add/Update Stock
    SaveExLocalPos(SaveInfo2);
    Res := Ex_StoreLink (@FLinkRec,           // P
                         SizeOf(FLinkRec),    // PSize
                         FIndex,                 // SearchPath
                         BtrOp);                 // SearchMode
    RestoreExLocalPos(SaveInfo2);
  End; { If (Res = 0) }

  // Restore original position in global customer file
  RestoreMainPos(SaveInfo);

  Result := Res;

  //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
  if Result = 0 then
    FIntfType := imClone;
end;

function TLinks.Update: ILinks;
Var
  FLinksO : TLinks;
  FuncRes   : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then
  begin
    // Create an update object
    FLinksO := TLinks.Create(imUpdate, FBtrIntf, FAttachTo, FOwnerCode, FOwnerFolio);

    FLinksO.LoadDetails(FLinkRec, LockPosition);
    LockCount := 0;
    LockPosition := 0;
    Result := FLinksO;
  end;
end;

procedure TLinks.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

Procedure TLinks.CopyDataRecord;
begin
  if FBtrIntf^.LMiscRecs^.btLetterRec.Version = DocWord95 then
    LetterToTKLetter(FBtrIntf^.LMiscRecs^.btLetterRec, FLinkRec)
  else
    LinkToTKLink(FBtrIntf^.LMiscRecs^.btLinkRec, FLinkRec);
  FLinkRec.lkAttachTo :=  FBtrIntf^.LMiscRecs^.SubType;
  if FLinkRec.lkAttachTo in ['C','S','E'] then
    FLinkRec.lkCode := FBtrIntf^.LMiscRecs^.btLetterRec.AccCode
  else
    FLinkRec.lkFolioKey := NomKeyFull(FBtrIntf^.LMiscRecs^.btLetterRec.AccCode);
end;

Function TLinks.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
var
  SearchMode : SmallInt;
  KeyS : Str255;
begin
  SearchMode := BtrOp;

  Case FAttachTo of
    'C',
    'S',
    'E'   : KeyS := SetKeyString(BtrOp, FullCustCode(FOwnerCode));
    'J',
    'K',
    'T'   : KeyS := SetKeyString(BtrOp, FullNomKey(FOwnerFolio));
  end;

  Case SearchMode of
    B_GetFirst  : begin
                    SearchMode := B_GetGEq;
                    KeyS := 'W' + FAttachTo + KeyS;
                  end;
    B_GetLast   : begin
                    SearchMode := B_GetLessEq;
                    KeyS := 'W' + FAttachTo + KeyS;
                  end;
  end;//case


  Result := FBtrIntf^.LFind_Rec(SearchMode, MiscF, 0, KeyS);

  FKeyString := KeyS;

  if Result = 0 then
  begin
    if (FBtrIntf^.LMiscRecs^.RecMfix = 'W') and (FBtrIntf^.LMiscRecs^.SubType = FAttachTo) then
    begin
      Case FAttachTo of
        'C','S',
        'E'   : if FOwnerCode = FBtrIntf^.LMiscRecs^.btLetterRec.AccCode then
                 Result := 0
                else
                  Result := 9;
        'J','K',
        'T'   : if FOwnerFolio = NomKeyFull(FBtrIntf^.LMiscRecs^.btLetterRec.AccCode) then
                  Result := 0
                else
                  Result := 9;
      end;

      if Result = 0 then
        CopyDataRecord;
    end
    else
      Result := 9;
  end;
end;

Function TLinks.AuthoriseFunction (Const FuncNo     : Byte;
                                     Const MethodName : String;
                                     Const AccessType : Byte = 0) : Boolean;
Begin { AuthoriseFunction }
  Case FuncNo Of
    // Step functions
    1..4      : Result := False;  { Not supported as CustF is shared file }

    5..99     : Result := (FIntfType = imGeneral);

    // .Add method
    100       : Result := (FIntfType = imGeneral);
    // .Update method
    101       : Result := (FIntfType = imGeneral);
    // .Save method
    102       : Result := (FIntfType In [imAdd, imUpdate]);
    // .Cancel method
    103       : Result := (FIntfType = imUpdate);
    // .Clone method
    104       : Result := (FIntfType = imGeneral);

  Else
    Result := False;
  End; { Case FuncNo }

  If (Not Result) Then Begin
    If (AccessType = 0) Then
      // Method
      Raise EInvalidMethod.Create ('The method ' + QuotedStr(MethodName) + ' is not available in this object')
    Else
      // Property
      Raise EInvalidMethod.Create ('The property ' + QuotedStr(MethodName) + ' is not available in this object');
  End; { If (Not Result) }
End; { AuthoriseFunction }


procedure TLinks.InitNewLinks;
begin
  FillChar(FLinkRec, SizeOf(FLinkRec), #0);
  FLinkRec.lkLetterLink := 'K'; //can't add letters
  FLinkRec.lkAttachTo := FAttachTo;
  FLinkRec.lkCode := FOwnerCode;
  FLinkRec.lkFolioKey := FOwnerFolio;
end;

Procedure TLinks.LoadDetails (Const LinkDets : TBatchLinkRec; Const LockPos : LongInt);
begin
  FLinkRec := LinkDets;

  LockCount := 1;
  LockPosition := LockPos;

end;

procedure TLinks.BlankData;
begin
  FillChar(FLinkRec, SizeOf(FLinkRec), #0);
end;

function TLinks.Delete: Integer;
var
  KeyS : PChar;
begin
  //Have to establish correct position in the global file and make sure it's not currently locked
  KeyS := StrAlloc(255);
  StrPCopy(KeyS, FOwnerCode);

  Result := Ex_GetLink(@FLinkRec, SizeOf(FLinkRec), KeyS, FIndex, B_GetEq, True);

  StrDispose(KeyS);

  If (Result = 0) Then
  Begin
    Result := Ex_DeleteLink(@FLinkRec, SizeOf(FLinkRec), FIndex);
    if Result = 0 then
      BlankData;
  end;

end;

//IBrowseInfo
function TLinks.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;




procedure TLinks.SetSQLCaching(SubType: Char);
begin
  inherited SetSQLCaching(FLinkRec.lkAttachTo);

end;

end.
