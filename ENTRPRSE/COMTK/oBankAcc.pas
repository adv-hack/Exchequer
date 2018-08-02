unit oBankAcc;
{$WARN SYMBOL_PLATFORM OFF}
interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
      MiscFunc, oBtrieve, BtrvU2, GlobList, VarConst, Varrec2u, GlobVar, oBankSt;

type
  TBankProductProc = function (WhichOne : Word;
                               var ProductName : ShortString;
                               var DefPayFile  : ShortString;
                               var DefRecFile  : ShortString) : Boolean;
  TProductCountProc = function : SmallInt;
  TBankStatementProc = function (WhichOne : Word) : ShortString;

  TBankAccount = class(TBtrieveFunctions, IBankAccount, IBankAccount2, IBrowseInfo)
  private
    FBacsRec  : BACSDbRecType;

    FToolkit  : TObject;

    FIntfType : TInterfaceMode;

    FStatementO : TBankStatement;
    FStatementI : IBankStatement;
    function UseExCodes : Boolean;
  protected
    function Get_baGLCode: Integer; safecall;
    procedure Set_baGLCode(Value: Integer); safecall;
    function Get_baProduct: Integer; safecall;
    procedure Set_baProduct(Value: Integer); safecall;
    function Get_baOutputPath: WideString; safecall;
    procedure Set_baOutputPath(const Value: WideString); safecall;
    function Get_baPayFileName: WideString; safecall;
    procedure Set_baPayFileName(const Value: WideString); safecall;
    function Get_baRecFileName: WideString; safecall;
    procedure Set_baRecFileName(const Value: WideString); safecall;
    function Get_baStatementPath: WideString; safecall;
    procedure Set_baStatementPath(const Value: WideString); safecall;
    function Get_baSortCode: WideString; safecall;
    procedure Set_baSortCode(const Value: WideString); safecall;
    function Get_baAccountNo: WideString; safecall;
    procedure Set_baAccountNo(const Value: WideString); safecall;
    function Get_baProductString: WideString; safecall;
    function Get_baLastDate: WideString; safecall;
    procedure Set_baLastDate(const Value: WideString); safecall;
    function Get_baStatement: IBankStatement; safecall;
    function Get_Index: TBankAccountIndex; safecall;
    procedure Set_Index(Value: TBankAccountIndex); safecall;
    function Get_baUserID: WideString; safecall;
    procedure Set_baUserID(const Value: WideString); safecall;
    function Get_baReference: WideString; safecall;
    procedure Set_baReference(const Value: WideString); safecall;
    function Get_baOutputCurrency: Integer; safecall;
    procedure Set_baOutputCurrency(Value: Integer); safecall;

    //IBankAccount2
    function Get_baReceiptUserID: WideString; safecall;
    procedure Set_baReceiptUserID(const Value: WideString); safecall;

    function BuildGLCodeIndex(GLCode: Integer): WideString; safecall;

    function Add: IBankAccount; safecall;
    function Clone: IBankAccount; safecall;
    function Update: IBankAccount; safecall;

    function Save: Integer; safecall;

    procedure Cancel; safecall;
    function Delete: Integer; safecall;

    procedure InitObjects;
    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    Function TranslateIndex (Const IdxNo : SmallInt; Const FromTLB : Boolean) : SmallInt; OverRide;

    function ValidateSave : Integer;
  public
    Constructor Create (Const IType    : TInterfaceMode;
                        Const Toolkit  : TObject;
                        Const BtrIntf  : TCtkTdPostExLocalPtr);

    Destructor Destroy; override;
    Procedure LoadDetails (Const AccDets : BacsDbRecType; Const LockPos : LongInt);
    procedure CloneDetails (const AccDets : BacsDbRecType);
  end;

  Function CreateTBankAccount (Const Toolkit : TObject; Const ClientId : Integer) : TBankAccount;

  function GetBankProductCount : SmallInt;
  function BankProduct(WhichOne : Word;
              var ProductName : ShortString;
              var DefPayFile  : ShortString;
              var DefRecFile  : ShortString) : Boolean;
  function BankStatementFormat(WhichOne : Word) : ShortString;

  procedure FinalizeMultiBacs;


implementation

uses
  ComServ, BtKeys1U, EtStrU, FileUtil, BtSupU1, EncryptionUtils;

const
  UseExCodeSet = [41 {NACHA}];

var
  _BankProduct : TBankProductProc;
  _ProductCount : TProductCountProc;
  _StatementFormat : TBankStatementProc;
  LibHandle : THandle;
  LibLoaded : Boolean;



function LoadMultiBacs : Byte;
const
  DllName = 'TkMBacs';
var
  sPath : AnsiString;
begin
  Result := 0;
  if not LibLoaded then
  begin
    sPath := IncludeTrailingBackSlash(GetEnterpriseDirectory) + DllName;
    LibHandle := LoadLibrary(PChar(sPath));
    if (LibHandle > HInstance_Error) then
    begin
      LibLoaded := True;
      _BankProduct := GetProcAddress(LibHandle, 'BankProduct');
      _ProductCount := GetProcAddress(LibHandle, 'BankProductCount');
      _StatementFormat := GetProcAddress(LibHandle, 'BankStatementFormat');
      if not Assigned(_BankProduct) or not Assigned(_ProductCount) or not Assigned(_StatementFormat) then
        Result := 2;
    end
    else
      Result := 1;
  end;

  Case Result of
    0 : ;
    1 : raise Exception.Create('Unable to load MultiBacs.Dll');
    2 : raise Exception.Create('Invalid version of MultiBacs.Dll');
    else
      raise Exception.Create('Unknown error loading MultiBacs.Dll');
  end;

end;

function BankProduct(WhichOne : Word;
              var ProductName : ShortString;
              var DefPayFile  : ShortString;
              var DefRecFile  : ShortString) : Boolean;
var
  Res : Byte;
begin
  if LoadMultiBacs = 0 then
    Result := _BankProduct(WhichOne, ProductName, DefPayFile, DefRecFile)
  else
    Result := False;
end;

function GetBankProductCount : SmallInt;
begin
  if LoadMultiBacs = 0 then
    Result := _ProductCount
  else
    Result := 0;
end;

function BankStatementFormat(WhichOne : Word) : ShortString;
begin
  if LoadMultiBacs = 0 then
    Result := _StatementFormat(WhichOne)
  else
    Result := '';
end;


Function CreateTBankAccount (Const Toolkit : TObject; Const ClientId : Integer) : TBankAccount;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTAccount }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by object
  BtrIntf^.Open_System(MLocF, MLocF);


  // Create bas TAccount object
  Result := TBankAccount.Create(imGeneral, Toolkit, BtrIntf);
  if SQLBeingUsed then
    Result.SetFileNos([MLocF]);
End;

{ TBankAccount }

function TBankAccount.Add: IBankAccount;
Var
  AddO : TBankAccount;
begin { Add }
  AuthoriseFunction(100, 'Add');

  AddO := TBankAccount.Create(imAdd, FToolkit, FBtrIntf);
//  AddO.InitNewRecord;

  Result := AddO;
end;

function TBankAccount.AuthoriseFunction(const FuncNo: Byte;
  const MethodName: String; const AccessType: Byte = 0): Boolean;
begin
  Case FuncNo of
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
    // .Delete method
    105       : Result := (FIntfType = imGeneral);
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


end;

procedure TBankAccount.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

function TBankAccount.Delete: Integer;
begin
  AuthoriseFunction(105, 'Delete');

  Result := FBtrIntf.LDelete_Rec(MLocF, 0);
end;

function TBankAccount.Clone: IBankAccount;
Var
  FBankO : TBankAccount;
Begin { Clone }
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new Stock object and initialise
  FBankO := TBankAccount.Create(imClone, FToolkit, FBtrIntf);
  FBankO.CloneDetails(FBacsRec);

  Result := FBankO;
end;

procedure TBankAccount.CopyDataRecord;
begin
  Move(FBtrIntf^.LMLocCtrl^.BacsDbRec, FBacsRec, SizeOf(FBacsRec));
end;

function TBankAccount.Get_baAccountNo: WideString;
begin
  //PR: 09/09/2013 ABSEXCH-14598 Added encryption for SEPA
  Result := DecryptBankAccountCode(FBacsRec.brBankAccountCode);
end;

function TBankAccount.Get_baGLCode: Integer;
begin
  Result := FBacsRec.brAccNOM;
end;

function TBankAccount.Get_baOutputPath: WideString;
begin
  Result := FBacsRec.brPayPath;
end;

function TBankAccount.Get_baPayFileName: WideString;
begin
  Result := FBacsRec.brPayFileName;
end;

function TBankAccount.Get_baProduct: Integer;
begin
  Result := FBacsRec.brBankProd;
end;

function TBankAccount.Get_baRecFileName: WideString;
begin
  Result := FBacsRec.brRecFileName;
end;

function TBankAccount.Get_baSortCode: WideString;
begin
  //PR: 09/09/2013 ABSEXCH-14598 Added encryption for SEPA
  Result := DecryptBankSortCode(FBacsRec.brBankSortCode);
end;

function TBankAccount.Get_baStatementPath: WideString;
begin
  Result := FBacsRec.brStatPath;
end;

function TBankAccount.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;

function TBankAccount.GetDataRecord(const BtrOp: SmallInt;
  const SearchKey: String): Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS                  : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;
  With FBtrIntf^ Do Begin
    // General index including Location, StkLoc, AltStk, Telesales, etc... records

    BtrOpCode := BtrOp;
    if FIndex = 0 then
      KeyS := SetKeyString(BtrOp, LteBankRCode + BankAccountKey + LJVar(SearchKey + '!', 30))
    else
      KeyS := SetKeyString(BtrOp, LteBankRCode + BankAccountKey + LJVar(SearchKey, 10));

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      B_GetFirst   : Begin
                       KeyS := LteBankRCode + BankAccountKey + #0;
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       KeyS := LteBankRCode + BankAccountKey + #255;
                       BtrOpCode  := B_GetLessEq;
                       BtrOpCode2 := B_GetPrev;
                     End;

      // Looking for exact match - do it and finish
      B_GetEq      : Loop := False;
    Else
      Raise Exception.Create ('Invalid Btrieve Operation');
    End; { Case BtrOp}

    Repeat
      Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

      BtrOpCode := BtrOpCode2;
      
      //AP : 3/11/2016 : ABSEXCH-16305 GetNext returning Error 4 on Customer Object
      If ((LMLocCtrl.RecPFix <> LteBankRCode) Or (LMLocCtrl.SubType <> BankAccountKey)) and (BtrOp <> B_GetEq) Then
        // Not a CC/Dept record - abandon operation
        Result := 9;
    Until (Result <> 0) Or (Not Loop) Or ((LMLocCtrl.RecPFix = LteBankRCode) And (LMLocCtrl.SubType = BankAccountKey));

    FKeyString := KeyS;

    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LMLocCtrl.RecPFix = LteBankRCode) And (LMLocCtrl.SubType = BankAccountKey) Then
        // Convert to Toolkit structure
        CopyDataRecord
      Else
        Result := 4;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

 { If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (72, Result);}
end;

function TBankAccount.Save: Integer;
var
  SaveInfo     : TBtrieveFileSavePos;
  SaveInfo2    : TBtrieveFileSavePos;
  Res   : SmallInt;
begin
  AuthoriseFunction(102, 'Save');
  Result := ValidateSave;
  if Result = 0 then
  begin
    Move(FBacsRec, FBtrIntf^.LMLocCtrl^.BacsDbrec, SizeOf(FBacsRec));
    if FIntfType = imAdd then
    begin
      FBtrIntf^.LMLocCtrl.RecPfix := LteBankRCode;
      FBtrIntf^.LMLocCtrl.SubType := BankAccountKey;
      Result := FBtrIntf^.LAdd_Rec(FFileNo, FIndex);
    end
    else
    begin
      SaveMainPos(SaveInfo);
      SaveExLocalPos(SaveInfo2);
      Res := PositionOnLock;
      Result := Put_Rec(F[FFileNo],  FFileNo, FBtrIntf^.LMlocCtrl^, FIndex);
      RestoreExLocalPos(SaveInfo2);
      RestoreMainPos(SaveInfo);
    end;

    //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
    if Result = 0 then
      FIntfType := imClone;
  end;
end;

procedure TBankAccount.Set_baAccountNo(const Value: WideString);
begin
  //PR: 09/09/2013 ABSEXCH-14598 Added encryption for SEPA
  FBacsRec.brBankAccountCode := EncryptBankAccountCode(Value);
end;

procedure TBankAccount.Set_baGLCode(Value: Integer);
begin
  FBacsRec.brAccNOM := Value;
end;

procedure TBankAccount.Set_baOutputPath(const Value: WideString);
begin
  FBacsRec.brPayPath := Value;
end;

procedure TBankAccount.Set_baPayFileName(const Value: WideString);
begin
  FBacsRec.brPayFileName := Value;
end;

procedure TBankAccount.Set_baProduct(Value: Integer);
begin
  FBacsRec.brBankProd := Value;
end;

procedure TBankAccount.Set_baRecFileName(const Value: WideString);
begin
  FBacsRec.brRecFileName := Value;
end;

procedure TBankAccount.Set_baSortCode(const Value: WideString);
begin
  //PR: 09/09/2013 ABSEXCH-14598 Added encryption for SEPA
  FBacsRec.brBankSortCode := EncryptBankSortCode(Value);
end;

procedure TBankAccount.Set_baStatementPath(const Value: WideString);
begin
  FBacsRec.brStatPath := Value;
end;

function TBankAccount.TranslateIndex(const IdxNo: SmallInt;
  const FromTLB: Boolean): SmallInt;
begin
  Result := IdxNo;
end;

function TBankAccount.Update: IBankAccount;
Var
  FAccountO : TBankAccount;
  FuncRes   : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    FAccountO := TBankAccount.Create(imUpdate, FToolkit, FBtrIntf);

    // Pass current Account Record and Locking Details into sub-object
    FAccountO.LoadDetails(FBacsRec, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := FAccountO;
  End; { If (FuncRes = 0) }
end;

constructor TBankAccount.Create(const IType: TInterfaceMode;
  const Toolkit: TObject; const BtrIntf: TCtkTdPostExLocalPtr);
begin
  Inherited Create (ComServer.TypeLib, IBankAccount2, BtrIntf); //PR: 21/01/2011 ABSEXCH-10392

  // Initialise Btrieve Ancestor
  FFileNo := MlocF;
  FIndex := 0;
  // Initialise variables
  FillChar (FBacsRec, SizeOf(FBacsRec), #0);
  InitObjects;
  FIntfType := IType;
  FToolkit := Toolkit;

  FObjectID := tkoBankAccount;
end;

destructor TBankAccount.Destroy;
begin
  InitObjects;
  inherited;
end;

procedure TBankAccount.InitObjects;
begin
  FStatementO := nil;
  FStatementI := nil;
end;

function TBankAccount.ValidateSave: Integer;
var
  i : longint;
begin
  Result := 0;
  if (CheckRecExsists(Strip('R',[#0],FullNomKey(FBacsRec.brAccNOM)),NomF,NomCodeK)) then
  begin
    FBacsRec.brBACSCode1 := LJVar(ReverseFullNomKey(FBacsRec.brAccNOM) + '!', 30);
    i := FBacsRec.brBankProd;
    if (i >= 0) and (i <= GetBankProductCount) then
    begin
      FBacsRec.brBACSCode2 := LJVar(ReverseFullNomKey(i)+ '!', 45);

    end
    else
      Result := 30001;
  end
  else
    Result := 30000;

end;

function TBankAccount.BuildGLCodeIndex(GLCode: Integer): WideString;
begin
  Result := LJVar(ReverseFullNomKey(GLCode), 4);
end;

function TBankAccount.Get_baProductString: WideString;
var
  ProdString, PayFile, RecFile : ShortString;
begin
  if BankProduct(FBacsRec.brBankProd, ProdString, PayFile, RecFile) then
    Result := ProdString
  else
    Result := '';
end;

function TBankAccount.Get_baLastDate: WideString;
begin
  Result := FBacsRec.brLastUseDate;
end;

procedure TBankAccount.LoadDetails(const AccDets: BacsDbRecType;
  const LockPos: Integer);
begin
  FBacsRec := AccDets;

  LockCount := 1;
  LockPosition := LockPos;

end;

procedure ClearLibrary;
begin
  LibLoaded := False;
  _BankProduct := nil;
  _ProductCount := nil;
end;

function TBankAccount.Get_Index: TBankAccountIndex;
begin
  Result := Inherited Get_Index;
end;

procedure TBankAccount.Set_Index(Value: TBankAccountIndex);
begin
  Inherited Set_Index (Value);
end;

procedure TBankAccount.CloneDetails(const AccDets: BacsDbRecType);
begin
  FBacsRec := AccDets;
end;

procedure FinalizeMultiBacs;
begin
  if LibLoaded then
  begin
    ClearLibrary;
    FreeLibrary(LibHandle);
  end;
end;

function TBankAccount.Get_baStatement: IBankStatement;
begin
  if not Assigned(FStatementO) then
  begin
    FStatementO := CreateTBankStatement (FToolkit, 50);

    FStatementI := FStatementO;
  end;

  if Assigned(FStatementO) then
    FStatementO.GLCode := FBacsRec.brAccNOM;

  Result := FStatementI;

end;

function TBankAccount.Get_baUserID: WideString;
begin
  //PR: 16/08/2013 7.MRD Change to use new UserID field for SEPA
  Result := DecryptBankUserID(FBacsRec.brUserIDEx);
end;

procedure TBankAccount.Set_baUserID(const Value: WideString);
begin
  //PR: 16/08/2013 7.MRD Change to use new UserID field for SEPA
  FBacsRec.brUserIDEx := EncryptBankUserID(Value);
end;

function TBankAccount.Get_baReference: WideString;
begin
  Result := FBacsRec.brBankRef;
end;

procedure TBankAccount.Set_baReference(const Value: WideString);
begin
  FBacsRec.brBankRef := Value;
end;

procedure TBankAccount.Set_baLastDate(const Value: WideString);
begin
  FBacsRec.brLastUseDate := Value;
end;

function TBankAccount.Get_baOutputCurrency: Integer;
begin
   Result := FBacsRec.brCurrency;
end;

procedure TBankAccount.Set_baOutputCurrency(Value: Integer);
begin
  if (Value > 0) and (Value <= 90) then
    FBacsRec.brCurrency := Value
  else
    raise ERangeError('Invalid currency (' + IntToStr(Value) + ')');
end;

function TBankAccount.Get_baReceiptUserID: WideString;
begin
  //PR: 16/08/2013 7.MRD Change to use new UserID field for SEPA
  Result := DecryptBankUserID(FBacsRec.brUserID2Ex);
end;

procedure TBankAccount.Set_baReceiptUserID(const Value: WideString);
begin
  //PR: 16/08/2013 7.MRD Change to use new UserID field for SEPA
  FBacsRec.brUserID2Ex := EncryptBankUserID(Value);
end;

function TBankAccount.UseExCodes: Boolean;
begin
  Result := Pred(FBacsRec.brBankProd) in UseExCodeSet;
end;

Initialization
  ClearLibrary;

end.
