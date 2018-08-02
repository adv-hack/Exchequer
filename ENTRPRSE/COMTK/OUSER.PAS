unit oUser;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, {$IFNDEF WANTEXE04}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve,
     MiscFunc, BtrvU2, ExBtTh1U, VarRec2U, GlobList;

const
  ExtEmailSig = '.TXT';
  ExtFaxSig   = '.TX2';
  upPrefix = 'D';

type
  //PR: 12/08/2011 Added IUserProfile2 with upShowGLCodesInTree property (ABSEXCH-7994)
  //PR: 17/07/2012 ABSEXCH-12452 Added IUserProfile3 with upShowProductTypesInTree and upShowStockCodesInTree
  //PR: 01/09/2017 ABSEXCH-18857 Added IUserProfile4 with upUserStatus and upWindowsID
  TUserProfile = class(TBtrieveFunctions, IUserProfile, IUserProfile2, IUserProfile3, IUserProfile4, IUserProfile5)
  protected
    // Note: All properties protected to allow descendants access
    FUserRec  : tPassDefType;
    FEmailSig, FFaxSig : TStringList;
    FIntfType : TInterfaceMode;
    FToolkit : TObject;
    //Interface methods
    function Get_upUserID: WideString; safecall;
    function Get_upName: WideString; safecall;
    function Get_upPWordExpiryMode: TPasswordExpiryType; safecall;
    function Get_upPWordExpiryDays: Integer; safecall;
    function Get_upPWordExpiryDate: WideString; safecall;
    function Get_upLockOutMins: Integer; safecall;
    function Get_upEmail: WideString; safecall;
    function Get_upDefSRICust: WideString; safecall;
    function Get_upDefPPISupp: WideString; safecall;
    function Get_upMaxSalesAuth: Double; safecall;
    function Get_upMaxPurchAuth: Double; safecall;
    function Get_upDefSalesBankGL: Integer; safecall;
    function Get_upDefPurchBankGL: Integer; safecall;
    function Get_upReportPrinter: WideString; safecall;
    function Get_upFormPrinter: WideString; safecall;
    function Get_upEmailSignature: WideString; safecall;
    function Get_upFaxSignature: WideString; safecall;
    function Get_upCCDeptRule: TPriorityRuleType; safecall;
    function Get_upDefCostCentre: WideString; safecall;
    function Get_upDefDepartment: WideString; safecall;
    function Get_upDefLocation: WideString; safecall;
    function Get_upDefLocRule: TPriorityRuleType; safecall;
    function Get_upSecurityFlags(Index: Integer): TSecurityResultType; safecall;

    //IUserProfile2
    function Get_upShowGLCodesInTree: WordBool; safecall;

    //PR: 17/07/2012 ABSEXCH-12452 IUserProfile3
    function Get_upShowProductTypesInTree: WordBool; safecall;
    function Get_upShowStockCodesInTree: WordBool; safecall;

    //PR: 01/09/2017 ABSEXCH-18857 IUserProfile4
    function Get_upUserStatus: TUserStatusType; safecall;
    function Get_upWindowsUserID: WideString; safecall;

    //AP: 21/11/2017 ABSEXCH-19404 IUserProfile5
    function  Get_upHighlightPIIFields: WordBool; safecall;
    function  Get_upHighlightPIIColour: Integer; safecall;
    
    function  Get_Index: TUserIndexType; safecall;
    procedure Set_Index(Value: TUserIndexType); safecall;

    function BuildUserIDIndex(const UserID : WideString) : WideString; safecall;
    function Clone: IUserProfile; safecall;

    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;

    procedure LoadSig(WhichSig : SmallInt);

    function Link_PWDefaults(PLogin  :  Str10; Var NewRec : integer)  :  tPassDefType;


  public
    ObjDescr : ShortString;

    Constructor Create (Const IType    : TInterfaceMode;
                        Const Toolkit  : TObject;
                        Const BtrIntf  : TCtkTdPostExLocalPtr);

    Destructor Destroy; override;
    procedure CloneDetails(Details : tPassDefType; EmailSig, FaxSig : PChar);

  End; { TUser}


Function CreateTUserProfile (Const Toolkit  : TObject; Const ClientId : Integer) : TUserProfile;

implementation

uses ComServ, DLL01U, DllErrU, BtKeys1U, EtStrU, Security;

{-------------------------------------------------------------------------------------------------}

Function CreateTUserProfile (Const Toolkit  : TObject; Const ClientId : Integer) : TUserProfile;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTAccount }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by TUser object
  BtrIntf^.Open_System(MLocF,  MLocF);
  BtrIntf^.Open_System(PWrdF,  PWrdF);

  // Create bas TAccount object
  Result := TUserProfile.Create(imGeneral, Toolkit, BtrIntf);

  if SQLBeingUsed then
    Result.SetFileNos([MLocF, PwrdF]);

End; { CreateTAccount }

{-------------------------------------------------------------------------------------------------}

Constructor TUserProfile.Create (Const IType    : TInterfaceMode;
                          Const Toolkit  : TObject;
                          Const BtrIntf  : TCtkTdPostExLocalPtr);
begin
  //PR: 17/07/2012 ABSEXCH-12452 Change to IUserProfile3
  //PR: 04/09/2017 ABSEXCH-18857 Change to IUserProfile4
  //AP: 22/12/2017 ABSEXCH-19404 Change to IUserProfile5
  Inherited Create (ComServer.TypeLib, IUserProfile5, BtrIntf);

//  LogF.AddLogMessage ('IUser', 'Create');

  // Initialise Btrieve Ancestor
  FFileNo := PWrdF;


   FillChar(FUserRec, SizeOf(FUserRec), #0);

   FEmailSig := TStringList.Create;
   FFaxSig := TStringList.Create;
   FIntfType := IType;
   FToolkit := Toolkit;
   FObjectID := tkoUserProfile;
end;

Destructor TUserProfile.Destroy;
begin
  FEmailSig.Free;
  FFaxSig.Free;


  If (FIntfType = imGeneral) Then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;
end;

function  TUserProfile.Get_upUserID: WideString;
begin
  Result := Trim(FUserRec.Login);
end;

function  TUserProfile.Get_upName: WideString;
begin
  Result := Trim(FUserRec.UserName);
end;

function  TUserProfile.Get_upPWordExpiryDate: WideString;
begin
  Result := FUserRec.PWExpDate;
end;

function  TUserProfile.Get_upEmail: WideString;
begin
  Result := Trim(FUserRec.emailAddr);
end;

function  TUserProfile.Get_upDefSRICust: WideString;
begin
  Result := Trim(FUserRec.DirCust);
end;

function  TUserProfile.Get_upDefPPISupp: WideString;
begin
  Result := Trim(FUserRec.DirSupp);
end;

function  TUserProfile.Get_upPWordExpiryDays : Integer;
begin
  Result := FUserRec.PWExPDays;
end;

function  TUserProfile.Get_upLockOutMins : Integer;
begin
  Result := FUserRec.PWTimeOut;
end;

function  TUserProfile.Get_upDefSalesBankGL : Integer;
begin
  Result := FUserRec.SalesBank;
end;

function  TUserProfile.Get_upDefPurchBankGL : Integer;
begin
  Result := FUserRec.PurchBank;
end;

function  TUserProfile.Get_upReportPrinter: WideString;
begin
  Result := Trim(FUserRec.ReportPrn);
end;

function  TUserProfile.Get_upFormPrinter: WideString;
begin
  Result := Trim(FUserRec.FormPrn);
end;

function  TUserProfile.Get_upEmailSignature: WideString;
begin
  Result := FEmailSig.Text;
end;

function  TUserProfile.Get_upFaxSignature: WideString;
begin
  Result := FFaxSig.Text;
end;

function  TUserProfile.Get_upPWordExpiryMode : TPasswordExpiryType;
begin
  Result := TPasswordExpiryType(FUserRec.PWExpMode);
end;

function  TUserProfile.Get_upMaxSalesAuth : Double;
begin
  Result := FUserRec.MaxSalesA;
end;

function  TUserProfile.Get_upMaxPurchAuth : Double;
begin
  Result := FUserRec.MaxPurchA;
end;

function  TUserProfile.Get_upCCDeptRule: TPriorityRuleType;
begin
  Result := TPriorityRuleType(FUserRec.CCDepRule);
end;

function  TUserProfile.Get_upDefCostCentre: WideString;
begin
  Result := FUserRec.ccDep[True];
end;

function  TUserProfile.Get_upDefDepartment: WideString;
begin
  Result := FUserRec.CCDep[False];
end;

function  TUserProfile.Get_upDefLocation: WideString;
begin
  Result := FUserRec.Loc;
end;

function  TUserProfile.Get_upDefLocRule: TPriorityRuleType;
begin
  Result := TPriorityRuleType(FUserRec.LocRule);
end;

function  TUserProfile.Get_upSecurityFlags(Index: Integer): TSecurityResultType;
var
  TempRes, SecRes : SmallInt;
  PLogin : PChar;
begin
  PLogin := StrAlloc(255);
  StrPCopy(PLogin, FUserRec.Login);

  TempRes := Ex_CheckSecurity(PLogin, Index, SecRes);
  StrDispose(PLogin);
  if TempRes = 0 then
    Result := TSecurityResultType(SecRes)
  else
  if TempRes = 1001 then
    raise ERangeError.Create('Index out of range checking security: ' + IntToStr(Index))
  else
    raise Exception.Create('Error ' + IntToStr(TempRes) + ' occurred while checking security');

end;

function  TUserProfile.Get_Index: TUserIndexType;
begin
  Result := TUserIndexType(FIndex);
end;

procedure TUserProfile.Set_Index(Value: TUserIndexType);
begin
  FIndex := Ord(Value);
end;

function TUserProfile.BuildUserIDIndex(const UserID : WideString) : WideString;
begin
  Result := LJVar(UpperCase(UserID), 10);
end;

procedure TUserProfile.LoadSig(WhichSig : SmallInt);
var
  FileName : string;
  Sig      : TStringList;
begin
  FileName := SetDrive + 'DOCMASTR\' + Get_upUserID;

  Try
// HM 13/12/04: Rewrote to suppress exceptions
//    if WhichSig = 0 then
//      FEmailSig.LoadFromFile(FileName + ExtEmailSig)
//    else
//      FFaxSig.LoadFromFile(FileName + ExtFaxSig);

    if WhichSig = 0 then
    begin
      Sig := FEmailSig;
      FileName := FileName + ExtEmailSig;
    End // if WhichSig = 0
    else
    Begin
      Sig := FFaxSig;
      FileName := FileName + ExtFaxSig;
    End; // Else

    If FileExists(FileName) Then
      Sig.LoadFromFile(FileName)
    Else
      Sig.Clear;
  Except
  End;
end;

Function TUserProfile.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS                  : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  BtrOpCode2 := 0;
  Result := 0;
  LastErDesc := '';
    With FBtrIntf^ Do
    Begin

      Loop := True;
      Case BtrOp of
        // Moving forward through file
        B_GetGEq,
        B_GetGretr,
        B_GetNext,
        B_GetFirst   : BtrOpCode2 := B_GetNext;

        // Moving backward through file
        B_GetLess,
        B_GetLessEq,
        B_GetPrev,
        B_GetLast    : BtrOpCode2 := B_GetPrev;

        // Looking for exact match - do it and finish
        B_GetEq      : Loop := False;
      Else
        Raise Exception.Create ('Invalid Btrieve Operation');
      End; { Case BtrOp}

      BtrOpCode := BtrOp;

      if BtrOpCode = B_GetFirst then
      begin
        KeyS :=  PassUCode+#0 + #0;
        BtrOpCode := B_GetGEq;
      end
      else
      if BtrOpCode = B_GetLast then
      begin
        KeyS :=  PassUCode+#0 + #255;
        BtrOpCode := B_GetLessEq;
      end
      else
        KeyS := SetKeyString(BtrOp, PassUCode+#0 + SearchKey);

      Repeat
        Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

        if (Result = 0) and
           ((LPassWord.RecPfix <> PassUCode) or (LPassWord.SubType <> #0)) then
             Result := 9;

        BtrOpCode := BtrOpCode2;
      Until (Result <> 0) Or (Not Loop) Or ((LPassWord.RecPfix = PassUCode) and (LPassWord.SubType = #0));
      FKeyString := KeyS;

    If (Result = 0) Then Begin
      // check correct record type was returned
      If ((LPassWord.RecPfix = PassUCode) and (LPassWord.SubType = #0)) Then
        // Convert to Toolkit structure
        CopyDataRecord
      Else
        Result := 4;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (500, Result);
End; { GetDataRecord }

procedure TUserProfile.CopyDataRecord;
var
  Res : integer;
begin
  FillChar(FUserRec, SizeOf(FUserRec), #0);
  FEmailSig.Clear;
  FFaxSig.Clear;
  FUserRec := Link_PWDefaults(FBtrIntf^.LPassword.PassEntryRec.Login, Res);

  if Res = 0 then
  begin
    LoadSig(0);
    LoadSig(1);
  end
  else
  begin
    FUserRec.Login := FBtrIntf^.LPassword.PassEntryRec.Login;
  end;
end;

Function TUserProfile.AuthoriseFunction (Const FuncNo     : Byte;
                                         Const MethodName : String;
                                         Const AccessType : Byte = 0) : Boolean;
Begin { AuthoriseFunction }
  Result := False;
  Case FuncNo Of
    1..99     : Result := (FIntfType = imGeneral);

    // .Clone method
    104       : Result := (FIntfType = imGeneral);
  end;

  If (Not Result) Then Begin
    If (AccessType = 0) Then
      // Method
      Raise EInvalidMethod.Create ('The method ' + QuotedStr(MethodName) + ' is not available in this object')
    Else
      // Property
      Raise EInvalidMethod.Create ('The property ' + QuotedStr(MethodName) + ' is not available in this object');
  End; { If (Not Result) }
End; { AuthoriseFunction }


Function TUserProfile.Link_PWDefaults(PLogin  :  Str10; Var NewRec : integer)  :  tPassDefType;
Const
  Fnum     =  MLocF;
  Keypath  =  MLK;

Var
  Mbret  :  Word;

  KeyS,
  KeyChk :  Str255;

  B_Func :  Integer;

  LOk,
  LLocked
         :  Boolean;

  Res : SmallInt;

Begin
  Blank(Result,Sizeof(Result));

  KeyChk:=FullPWordKey(PassUCode,'D',PLogin);

  KeyS:=KeyChk;

  With FBtrIntf^ do
  Begin
    Res:= LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

    NewRec:=Res;
    If (Res = 0 ) then
      Result:=LMLocCtrl^.PassDefRec;
  end; {With..}
end;

procedure TUserProfile.CloneDetails(Details : tPassDefType; EmailSig, FaxSig : PChar);
begin
  Try
    FUserRec := Details;
    FEmailSig.SetText(EmailSig);
    FFaxSig.SetText(FaxSig);
  Finally
    StrDispose(EmailSig);
    StrDispose(FaxSig);
  End;
end;

function TUserProfile.Clone: IUserProfile;
var
  UserO : TUserProfile;
begin
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  UserO := TUserProfile.Create(imClone, FToolkit, FBtrIntf);

  UserO.CloneDetails(FUserRec, FEmailSig.GetText, FFaxSig.GetText);

  Result := UserO;
end;

function TUserProfile.Get_upShowGLCodesInTree: WordBool;
begin
  Result := FUserRec.ShowGLCodes;
end;

//PR: 17/07/2012 ABSEXCH-12452
function TUserProfile.Get_upShowProductTypesInTree: WordBool;
begin
  Result := FUserRec.ShowProductType;
end;

//PR: 17/07/2012 ABSEXCH-12452
function TUserProfile.Get_upShowStockCodesInTree: WordBool;
begin
  Result := FUserRec.ShowStockCode;
end;

function TUserProfile.Get_upUserStatus: TUserStatusType;
begin
  Result := TUserStatusType(FUserRec.UserStatus);
end;

function TUserProfile.Get_upWindowsUserID: WideString;
begin
  Result := Trim(FUserRec.WindowUserID);
end;

//AP: 21/11/2017 ABSEXCH-19404 IUserProfile5
function TUserProfile.Get_upHighlightPIIFields: WordBool;
begin
  Result := FUserRec.HighlightPIIFields;
end;

function TUserProfile.Get_upHighlightPIIColour: Integer;
begin
  Result := FUserRec.HighlightPIIColour;
end;

end.
