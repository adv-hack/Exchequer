unit oMatch;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarRec2U, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve,
     MiscFunc, BtrvU2, ExBTTH1U, GlobList, EnterpriseBeta_TLB;

type
  TMatching = class(TBtrieveFunctions, IMatching, IMatching2, IBetaMatching)
  private
    // Note: All properties protected to allow descendants access
    FAllowOverSettling : WordBool;
    FMatchRec  : MatchPayType;

    FDocRef    : ShortString;

    FIntfType  : TInterfaceMode;
    FToolkit   : TObject;
    FSearchType : TMatchingSearchType;
    procedure InitObjects;
    procedure SetType(AType : TMatchingSubType);
  protected
    // IMatching
    function  Get_maDocRef: WideString; safecall;
    procedure Set_maDocRef(const Value: WideString); safecall;
    function  Get_maPayRef: WideString; safecall;
    procedure Set_maPayRef(const Value: WideString); safecall;
    function  Get_maType: TMatchingSubType; safecall;
    function  Get_maDocCurrency: SmallInt; safecall;
    procedure Set_maDocCurrency(Value: SmallInt); safecall;
    function  Get_maDocValue: Double; safecall;
    procedure Set_maDocValue(Value: Double); safecall;
    function  Get_maPayCurrency: SmallInt; safecall;
    procedure Set_maPayCurrency(Value: SmallInt); safecall;
    function  Get_maPayValue: Double; safecall;
    procedure Set_maPayValue(Value: Double); safecall;
    function  Get_maBaseValue: Double; safecall;
    procedure Set_maBaseValue(Value: Double); safecall;
    function  Get_maDocYourRef: WideString; safecall;
    function Get_maAllowOversettling: WordBool; safecall;
    procedure Set_maAllowOversettling(Value: WordBool); safecall;

    function  Add: IMatching; safecall;
    function  Save: Integer; safecall;

    //IMatching2 methods
    function AddCustom(MatchType: TMatchingSubType): IMatching2; safecall;
    function Delete: Integer; safecall;
    function Get_maCustomRef: WideString; safecall;
    procedure Set_maCustomRef(const Value: WideString); safecall;
    function Get_maSearchType: TMatchingSearchType; safecall;
    procedure Set_maSearchType(Value: TMatchingSearchType); safecall;

    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;

    //PR: 22/02/2010 Added new functions to deal with SQL Caching in redirect tables
    function LoadTheCache : Integer; override;
    function GetRedirectedDataRec(const BtrOp : SmallInt; const SearchKey : string) : Integer;

    // Local methods
    ///PL 06/01/2017 2017-R1 ABSEXCH-16606 : IMatching2.AddCustomMatching Doesn't Default the Transaction Details
    procedure InitNew(const Docref : ShortString);
    function TranslateSearchType : Char;
    procedure SetSQLCaching(SubType : Char = ' '); override;
  public
    Constructor Create (Const IType    : TInterfaceMode;
                        Const Toolkit  : TObject;
                        Const BtrIntf  : TCtkTdPostExLocalPtr);
    Constructor CreateAsClone(const AMatchRec  : MatchPayType;
                              Const Toolkit  : TObject;
                              Const BtrIntf  : TCtkTdPostExLocalPtr);

    Destructor Destroy; override;

    Procedure SetStartKey (Const DocRef : ShortString; Const UseIdx0 : Boolean);
  End; { TMatching }


Function CreateTMatching (Const ClientId       : Integer;
                          Const Toolkit        : TObject) : TMatching;


implementation

uses ComServ, oToolkit, DLLSK01U, DllErrU, BtsupU1, BtKeys1U, EtStrU, Math, SQLStructuresU, TKSQL;

{-------------------------------------------------------------------------------------------------}

Function CreateTMatching (Const ClientId       : Integer;
                          Const Toolkit        : TObject) : TMatching;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTMatching }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by Stock-Location object
  BtrIntf^.Open_System(PwrdF, PwrdF);
  BtrIntf^.Open_System(InvF, InvF);

  // Create base TStockLocation object
  Result := TMatching.Create(imGeneral, Toolkit, BtrIntf);

  if SQLBeingUsed then
    Result.SetFileNos([InvF, PwrdF]);

End; { CreateTMatching }

{-------------------------------------------------------------------------------------------------}

Constructor TMatching.Create (Const IType    : TInterfaceMode;
                              Const Toolkit  : TObject;
                              Const BtrIntf  : TCtkTdPostExLocalPtr);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IMatching2, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := PwrdF;

  // Initialise variables
  FillChar (FMatchRec, SizeOf(FMatchRec), #0);
  InitObjects;
  FDocRef := #0;

  // Setup object type and link to main toolkit object
  FIntfType := IType;
  FToolkit := Toolkit;

  FObjectID := tkoMatching;

  FSearchType := maSearchTypeFinancial;
End; { Create }

{-----------------------------------------}

Destructor TMatching.Destroy;
Begin { Destroy }
  { Destroy sub-ojects }
  InitObjects;

  If (FIntfType = imGeneral) Then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

Procedure TMatching.InitObjects;
Begin { InitObjects }

  FToolkit := Nil;
End; { InitObjects }

{-----------------------------------------}

Procedure TMatching.SetStartKey (Const DocRef : ShortString; Const UseIdx0 : Boolean);
begin
  If (FDocRef <> DocRef) Then Begin
    // Take copy of active document reference
    FDocRef := DocRef;
    FSQLParentKey := FDocRef;
    // set correct index for document
    If UseIdx0 Then
      Set_Index(0)
    Else
      Set_Index(1);

    // Reset current matching record
    FillChar (FMatchRec, SizeOf(FMatchRec), #0);
  End; { If (FDocRef <> DocRef) }
end;

{-----------------------------------------}

Procedure TMatching.CopyDataRecord;
Begin { CopyDataRecord }
  FMatchRec := FBtrIntf^.LPassword.MatchPayRec;
End; { CopyDataRecord }

{-----------------------------------------}

Function TMatching.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
const
{PR 11/03/08 Index 1 in PWordF contains the first byte of SettledVal, so we need to check only the first 12 chars.
 We can use the same length for Index 0, as this should also be an OurRef}
  KeyLen = 12;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS, KeyChk          : Str255;
  Loop                  : Boolean;
  ThisMatchCode         : Char;
  LengthToCheck         : Integer;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';

  if UsingRedirectCache then
    Result := GetRedirectedDataRec(BtrOp, SearchKey)
  else
  begin
    ThisMatchCode := TranslateSearchType;

    With FBtrIntf^ Do Begin
      // General shared index including Passwords, Notes, Matching, BOM, BACS, etc... records

      BtrOpCode := BtrOp;
      KeyS := SetKeyString(BtrOp, MatchTCode + {MatchSCode}ThisMatchCode + FDocRef);
      KeyChk := KeyS;

      LengthToCheck := Min(Length(KeyChk), KeyLen);

      Loop := True;
      Case BtrOp of
        // Moving forward through file
        B_GetFirst   : Begin
                         BtrOpCode  := B_GetGEq;
                         BtrOpCode2 := B_GetNext;
                       End;

        B_GetNext    : BtrOpCode2 := B_GetNext;

        // Moving backward through file
        B_GetPrev    : BtrOpCode2 := B_GetPrev;

        B_GetLast    : Begin
                         BtrOpCode  := B_GetLessEq;
                         BtrOpCode2 := B_GetPrev;
                       End;
      Else
        Raise Exception.Create ('Invalid Btrieve Operation');
      End; { Case BtrOp}

      Repeat
        Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

        BtrOpCode := BtrOpCode2;

        //AP : 3/11/2016 : ABSEXCH-16305 GetNext returning Error 4 on Customer Object
        If (Not CheckKey(KeyS, KeyChk, LengthToCheck, True)) and (BtrOp <> B_GetEq) Then
          // Not a Matching record - abandon operation
          Result := 9;
      Until (Result <> 0) Or (Not Loop) Or CheckKey(KeyS, KeyChk, LengthToCheck, True);

      FKeyString := KeyS;

      If (Result = 0) Then Begin
        // check correct record type was returned
        If (LPassword.RecPFix = MatchTCode) And (LPassword.SubType = {MatchSCode} ThisMatchCode) Then
          // Take local Copy
          CopyDataRecord
        Else
          Result := 4;
      End; { If (Result = 0) }
    End; { With FBtrIntf^ }
  end;

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (75, Result);
End; { GetDataRecord }

{-----------------------------------------}

// Used by TBtrieveFunctions ancestor to authorise exceution of a function
// see original definition of AuthoriseFunction in oBtrieve.Pas for a
// definition of the parameters
Function TMatching.AuthoriseFunction (Const FuncNo     : Byte;
                                      Const MethodName : String;
                                      Const AccessType : Byte = 0) : Boolean;
Begin { AuthoriseFunction }
  Case FuncNo Of
    1..99     : Result := (FIntfType = imGeneral);

    // .Add method
    100       : Result := (FIntfType = imGeneral);
    // .Save method
    102       : Result := (FIntfType In [imAdd, imUpdate]);
    // .Delete method
    103       : Result := (FIntfType = imGeneral);
    // .AddCustom method
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

{-----------------------------------------}

function TMatching.Get_maType: TMatchingSubType;
begin
{  If (FMatchRec.MatchType = 'O') Then
    // SPOP
    Result := maTypeSPOP
  Else
    Result := maTypeFinancial;}
  Case FMatchRec.MatchType of
    'A'  : Result := maTypeFinancial;
    'O'  : Result := maTypeSPOP;
    'C'  : Result := maTypeCIS;
    '0'  : Result := maTypeCostApportionment;
    '1'  : Result := maTypeUser1;
    '2'  : Result := maTypeUser2;
    '3'  : Result := maTypeUser3;
    '4'  : Result := maTypeUser4;
  end;
end;

{-----------------------------------------}

function TMatching.Get_maBaseValue: Double;
begin
  Result := FMatchRec.SettledVal;
end;

procedure TMatching.Set_maBaseValue(Value: Double);
begin
  FMatchRec.SettledVal := Value;
end;

{-----------------------------------------}

function TMatching.Get_maDocCurrency: Smallint;
begin
  Result := FMatchRec.MCurrency;
end;

procedure TMatching.Set_maDocCurrency(Value: Smallint);
begin
  FMatchRec.MCurrency := ValidateCurrencyNo (Value);
end;

{-----------------------------------------}

function TMatching.Get_maDocRef: WideString;
begin
  Result := FMatchRec.DocCode;
end;

procedure TMatching.Set_maDocRef(const Value: WideString);
begin
  FMatchRec.DocCode := Value;
end;

{-----------------------------------------}

function TMatching.Get_maDocValue: Double;
begin
  Result := FMatchRec.OwnCVal;
end;

procedure TMatching.Set_maDocValue(Value: Double);
begin
  FMatchRec.OwnCVal := Value;
end;

{-----------------------------------------}

function TMatching.Get_maPayCurrency: Smallint;
begin
  Result := FMatchRec.RCurrency;
end;

procedure TMatching.Set_maPayCurrency(Value: Smallint);
begin
  FMatchRec.RCurrency := ValidateCurrencyNo (Value);
end;

{-----------------------------------------}

function TMatching.Get_maPayValue: Double;
begin
  Result := FMatchRec.RecOwnCVal;
end;

procedure TMatching.Set_maPayValue(Value: Double);
begin
  FMatchRec.RecOwnCVal := Value;
end;

{-----------------------------------------}

function TMatching.Get_maPayRef: WideString;
begin
  Result := FMatchRec.PayRef;
end;

procedure TMatching.Set_maPayRef(const Value: WideString);
begin
  FMatchRec.PayRef := Value;
end;

{-----------------------------------------}

function TMatching.Get_maDocYourRef: WideString;
begin
  Result := FMatchRec.AltRef;
end;

{-----------------------------------------}
//PL 06/01/2017 2017-R1 ABSEXCH-16606 : IMatching2.AddCustomMatching Doesn't Default the Transaction Details
procedure TMatching.InitNew(const Docref : ShortString);
var
  Result : Integer ;
   KeyS : Str255;
begin
  FillChar (FMatchRec, SizeOf(FMatchRec), #0);
  begin
    //Find transactions and update
    with FBtrIntf^ do
    begin
      KeyS := Docref;
      Result := LFind_Rec(B_GetEq, InvF, InvOurRefK, KeyS);
      if Result = 0 then
      begin
        with FMatchRec, FBtrIntf^.LInv Do
        begin
           MatchType := 'A'; // Financial
          if InvDocHed in [SRC,PPY] then
          begin
            PayRef := OurRef ;
            RCurrency := Currency;
            RecOwnCVal := InvNetVal ;
          end
          else
          begin
            DocCode := OurRef;
            MCurrency := Currency;
            OwnCVal := InvNetVal;
          end;


        end; { With FMatchRec, FBtrIntf^.LInv }
      end
      else
      begin
        LastErDesc := Ex_ErrorDescription (75, Result);
      end;
    end;
  end;
end;

{-----------------------------------------}

function TMatching.Add: IMatching;
Var
  MatchO  : TMatching;
begin
  AuthoriseFunction(100, 'Add');

  // Create a new Transaction object
  MatchO := TMatching.Create(imAdd, FToolkit, FBtrIntf);
  //PL 06/01/2017 2017-R1 ABSEXCH-16606 : IMatching2.AddCustomMatching Doesn't Default the Transaction Details
  MatchO.InitNew(FDocRef);

  Result := MatchO;
end;

{-----------------------------------------}

function TMatching.Save: Integer;
Var
  SaveInfo : TBtrieveSavePosType;
  TkMatch  : TBatchMatchRec;
begin { Save }
  AuthoriseFunction(102, 'Save');

  // Save current file positions in main files
  SaveInfo := SaveSystemFilePos ([]);

  FillChar (TkMatch, SizeOf (TkMatch), #0);
  With TkMatch Do Begin
    DebitRef  := FMatchRec.DocCode;
    CreditRef := FMatchRec.PayRef;
    DebitCr   := FMatchRec.MCurrency;
    CreditCr  := FMatchRec.RCurrency;
    DebitVal  := FMatchRec.OwnCVal;
    CreditVal := FMatchRec.RecOwnCVal;
    BaseVal   := FMatchRec.SettledVal;
{$IFDEF EN550CIS}
    MatchType := FMatchRec.MatchType;
    CustomRef := FMatchRec.AltRef;
{$ENDIF}
    AllowOverSettling := FAllowOversettling;

  End; { With TkMatch }

  Result := Ex_StoreMatch(@TkMatch, SizeOf(TkMatch), FIndex, B_Insert);

  // Restore original file positions
  RestoreSystemFilePos (SaveInfo);
End; { Save }

{-----------------------------------------}
function TMatching.AddCustom(MatchType: TMatchingSubType): IMatching2;
var
  MatchO : TMatching;
begin
  AuthoriseFunction(104, 'AddCustom');

  if MatchType in [maTypeUser1..maTypeUser4, maTypeCostApportionment] then
  begin
  // Create a new Transaction object
    MatchO := TMatching.Create(imAdd, FToolkit, FBtrIntf);
    //PL 06/01/2017 2017-R1 ABSEXCH-16606 : IMatching2.AddCustomMatching Doesn't Default the Transaction Details
    MatchO.InitNew(FDocRef);
    MatchO.SetType(MatchType);

    Result := MatchO;
  end
  else
    raise Exception.Create('Invalid Custom Matching Type');
end;


function TMatching.Delete: Integer;
var
  RecordCorrect : Boolean;
  CheckChar : Char;

  function UpdateTrans(const s : string) : Integer;
  var
    KeyS : Str255;
    Locked, LockOK : Boolean;
    Res : Integer;
    TmpCSettled : Double;
    Sgn : Integer;
  begin
    //Find transactions and update
    with FBtrIntf^ do
    begin
      KeyS := s;
      Result := LFind_Rec(B_GetEq, InvF, InvOurRefK, KeyS);
      if Result = 0 then
      begin
        if LInv.ReValueAdj > 0 then
          Result := 30002;
      end;

      if Result = 0 then
      begin
        LockOK := LGetMultiRec(B_GetDirect,B_SingLock,KeyS,InvOurRefK,InvF,BOn,Locked);
        if LockOK then
        begin
          if LInv.InvDocHed in SalesSplit then
            Sgn := -1
          else
            Sgn := 1;
          LInv.Settled := LInv.Settled - (FMatchRec.SettledVal * DocCnst[LInv.InvDocHed] * Sgn);

          with TToolkit(FToolkit) do
            TmpCSettled := FuncsI.entConvertAmount(FMatchRec.SettledVal, 0, LInv.Currency, 0)
                                  * DocCnst[LInv.InvDocHed] * Sgn;
          LInv.CurrSettled := LInv.CurrSettled - TmpCSettled;
          LInv.AllocStat := LInv.CustSupp;
          Result := LPut_Rec(InvF, InvOurRefK);

        end
        else
          Result := 84;
      end;
    end;
  end;

begin
  AuthoriseFunction(103, 'Delete');
  LastErDesc := '';

  if FMatchRec.MatchType = 'A' then
    CheckChar := 'P'
  else
    CheckChar := FMatchRec.MatchType;

  with fBtrIntf^ do
  begin
    RecordCorrect := (LPassword.RecPFix = MatchTCode) and (LPassword.SubType = CheckChar) and
                     (Trim(LPassword.MatchPayRec.DocCode) = Trim(FMatchRec.DocCode)) and
                     (Trim(LPassword.MatchPayRec.PayRef) = Trim(FMatchRec.PayRef)) and
                     (LPassword.MatchPayRec.MCurrency = FMatchRec.MCurrency) and
                     (LPassword.MatchPayRec.RCurrency = FMatchRec.RCurrency) and
                     (LPassword.MatchPayRec.OwnCVal = FMatchRec.OwnCVal) and
                     (LPassword.MatchPayRec.RecOwnCVal = FMatchRec.RecOwnCVal) and
                     (LPassword.MatchPayRec.SettledVal = FMatchRec.SettledVal);

    if RecordCorrect then
    begin

      if FMatchRec.MatchType = 'A' then
      begin //financial matching - need to update transactions
        Result := UpdateTrans(FMatchRec.DocCode);
        if Result = 0 then
          Result := UpdateTrans(FMatchRec.PayRef)
        else
          Result := Result + 31000;

        if Result = 0 then
        begin
          Result := LDelete_Rec(FFileNo, FIndex);
          if Result <> 0 then
          Result := Result + 32000;
        end;
      end
      else //custom matching - simply delete
        Result := LDelete_Rec(FFileNo, FIndex);
    end
    else
      Result := 30001;

  end;

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (171, Result);

end;

procedure TMatching.SetType(AType : TMatchingSubType);
begin
  Case AType of
    maTypeFinancial : begin
                        FMatchRec.MatchType := 'A';
                        FSearchType := maSearchTypeFinancial;
                      end;
    maTypeSPOP      : begin
                        FMatchRec.MatchType := 'O';
                        FSearchType := maSearchTypeFinancial;
                      end;
    maTypeCIS       : begin
                        FMatchRec.MatchType := 'C';
                        FSearchType := maSearchTypeCIS;
                      end;
    maTypeCostApportionment
                    : begin
                        FMatchRec.MatchType := '0';
                        FSearchType := maSearchTypeCostApportionment;
                      end;
    maTypeUser1     : begin
                        FMatchRec.MatchType := '1';
                        FSearchType := maSearchTypeUser1;
                      end;
    maTypeUser2     : begin
                        FMatchRec.MatchType := '2';
                        FSearchType := maSearchTypeUser2;
                      end;
    maTypeUser3     : begin
                        FMatchRec.MatchType := '3';
                        FSearchType := maSearchTypeUser3;
                      end;

    maTypeUser4     : begin
                        FMatchRec.MatchType := '4';
                        FSearchType := maSearchTypeUser4;
                      end;
  end;
end;

function TMatching.Get_maCustomRef: WideString;
begin
  Result := FMatchRec.AltRef;
end;

procedure TMatching.Set_maCustomRef(const Value: WideString);
begin
  FMatchRec.AltRef := Value;
end;

function TMatching.Get_maSearchType: TMatchingSearchType;
begin
  Result := FSearchType;
end;

procedure TMatching.Set_maSearchType(Value: TMatchingSearchType);
begin
  FSearchType := Value;
end;

function TMatching.TranslateSearchType : Char;
begin
  Case FSearchType of
    maSearchTypeFinancial,
    maSearchTypeSPOP      : Result := 'P';
    maSearchTypeCIS       : Result := 'C';
    maSearchTypeCostApportionment : Result := '0';
    maSearchTypeUser1     : Result := '1';
    maSearchTypeUser2     : Result := '2';
    maSearchTypeUser3     : Result := '3';
    maSearchTypeUser4     : Result := '4';
    else
      Result := 'P';
  end
end;




function TMatching.Get_maAllowOversettling: WordBool;
begin
  Result := FAllowOverSettling;
end;

procedure TMatching.Set_maAllowOversettling(Value: WordBool);
begin
  FAllowOverSettling := Value;
end;

procedure TMatching.SetSQLCaching(SubType: Char);
begin
  inherited SetSQLCaching(TranslateSearchType);

end;

function TMatching.GetRedirectedDataRec(const BtrOp: SmallInt;
  const SearchKey: string): Integer;
var
  DataRec : TFinancialMatchingRec;
  sKey : Str255;
begin
  sKey := SetKeyString(BtrOp, FDocRef + SearchKey);
  Result := FSQLRedirect.GetData(BtrOp, FIndex, sKey, @DataRec, SizeOf(DataRec));

  if Result = 0 then
  begin
    FBtrIntf^.LPassword.RecPfix := MatchTCode;
    FBtrIntf^.LPassword.SubType := TranslateSearchType;
    FBtrIntf^.LPassword.MatchPayRec.DocCode    := DataRec.DocCode;
    FBtrIntf^.LPassword.MatchPayRec.PayRef     := DataRec.PayRef;
    FBtrIntf^.LPassword.MatchPayRec.SettledVal := DataRec.SettledVal;
    FBtrIntf^.LPassword.MatchPayRec.OwnCVal    := DataRec.OwnCVal;
    FBtrIntf^.LPassword.MatchPayRec.MCurrency  := DataRec.MCurrency;
    FBtrIntf^.LPassword.MatchPayRec.MatchType  := DataRec.MatchType;
    FBtrIntf^.LPassword.MatchPayRec.OldAltRef  := DataRec.OldAltRef;
    FBtrIntf^.LPassword.MatchPayRec.RCurrency  := DataRec.RCurrency;
    FBtrIntf^.LPassword.MatchPayRec.RecOwnCVal := DataRec.RecOwnCVal;
    FBtrIntf^.LPassword.MatchPayRec.AltRef     := DataRec.AltRef;

    CopyDataRecord;

    FKeyString := sKey;
  end;
end;

function TMatching.LoadTheCache: Integer;
var
  DefaultWhere : string;
begin
  Result := 0;
  if not (FSearchType in [maSearchTypeFinancial, maSearchTypeSPOP]) then
    Result := inherited LoadTheCache
  else
  begin
    if not UsingRedirectCache then
    begin
      FRecordSubtype := 'P';
      FSQLRedirect := TSQLRedirect.Create;
      FSQLRedirect.FileNo := F_FINANCIAL_MATCHING;
      FSQLRedirect.WhereClause := FullQuery;;
      FSQLRedirect.FieldList := FColumns;
      FSQLRedirect.ClientID := FBtrIntf^.ExClientID;
      Result := FSQLRedirect.Open;
    end
  end;

end;

constructor TMatching.CreateAsClone(const AMatchRec: MatchPayType;
  const Toolkit: TObject; const BtrIntf: TCtkTdPostExLocalPtr);
begin
  Create(imClone, Toolkit, BtrIntf);

  FMatchRec := AMatchRec;
end;

end.
