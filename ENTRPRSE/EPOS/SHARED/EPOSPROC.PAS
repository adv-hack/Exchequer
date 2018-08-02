unit EPOSProc;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  Forms, Windows, Controls, StrUtil, UseDLLU, VarConst, TKUtil, EPOSCnst
  , Dialogs, Classes, StdCtrls, graphics, ExtCtrls, {NeilProc,} BTSupU1
  , VarRec2U, etStrU, DLLInc, ComCtrls, GlobVar, MiscUtil, LicRec, EntLic;

{$I EXDLLBT.INC}

const
  MAX_NO_COMPANIES = 40;
  SET_TO_TX_FOLIO_NO_ON_STORE = -1999999999;

type
  PStringList = ^TStringList;

  TDPFormMode = (fmTakeDeposit, fmOnAccount);

  TItemInfo = Class
    ID : Integer
  end;{TItemInfo}

  TCompanies = Array[1..MAX_NO_COMPANIES] of TCompanyType;
  PCompanies = ^TCompanies;

  TCompanyInfo = Class
    CompanyRec : TCompanyType;
  end;


  TVATInfo = class
    rRate : real;
    cCode : char;
    constructor create(Rate : real; Code : Char);
  end;

  TPriceRec = Record{.166}
    NetPrice : real;
    VATAmount : real;
    Price : real;
    Quantity : real;
    TotalPrice : real;
  end;

  TTKPayLines = Array[1..10] of TBatchTLRec;

  pTKTLRec = ^TBatchTLRec;


  function BarCodeKeyPress(Sender: TObject; var Key: Char; TheActiveControl : TWinControl
  ; TheHandle: THandle; var bBarCode : boolean; var sBarCode : string; bDoSomething : boolean) : boolean;
  function TPayedByToText(PayedBy : TPayedBy; iLCardType : integer) : string;
  function MyMsgBox(scaption: string; etype: TMsgDlgType; sButtons: TMsgDlgButtons;
  eDefault: TmsgDlgBtn; stitle: string; iHelpContext : integer = 0): byte;
  Procedure OpenCashDrawer(iComPort, iBaudRate : integer; sKickOutCodes : string);
  Function AllowedTo(DoIt : TAllowedTo) : boolean;
  function CheckSecurity(iAreaCode : LongInt)  : boolean;
  function GetVatRateFromCode(cVATCode : Char) : Real;
  procedure FillVATCombo(cmbVATRate : TComboBox);
  Procedure HighlightVATRate(cVATCode : char; cmbVATRate : TComboBox);
  Function CreditCheck(TheCust : CustRec; rExtraAmount : real) : boolean;
  procedure FillCompanyCombo(cmbCompany : TComboBox);
  procedure FillCompanyList(Companies : TStringList);
  procedure NegateTKTXHeader(var TheTKTXHeader : TBatchTHRec);
  procedure NegateTKTLines(var TheTKTLines : TBatchLinesRec; TheTKTXHeader : TBatchTHRec);
  function OpenLayawayFiles(bCloseFiles : boolean) : integer;
  procedure GetLocationRec(sLocation : string);
  procedure GetUserProfileRec(sUser : string);
  Function Get_PWDefaults(PLogin  :  String10)  :  tPassDefType;
  Function GetProfileCCDep(CustCC,CustDep  :  String5; StkCCDep
  , InpCCDep : CCDepType; ProtectInp : Byte) : CCDepType;
  function DoesUserExist(asUser, asCompPath : ANSIString; bOpenCloseDLL : boolean = FALSE) : boolean;
  procedure FillStandardTXHead(var TheTKTXHeader : TBatchTHRec);
  Function VatCharToIdx(VATChar : Char) : SmallInt;
  function WordBoolOrd(TheWordBool : WordBool) : byte;
  function GetStockFolioFromCode(sStockCode : string) : integer;
  function AddressBlank(Address : AddrTyp) : boolean;
  function IsEnterprisePro : boolean;
  function OverrideTKIniFile : boolean;
  Function CheckStock(TKStockRec : TBatchSKRec; TKStockLocRec : TBatchSLRec; rLineQty : real) : boolean;
  procedure ShowStockWarning(var bContinue : boolean; sExtraText : string = '');

var
//  TXRec : TTXRec;
  TKSysRec : TBatchSysRec;
  TKLocationRecord : TBatchMLocRec;            {* Multi Location Stock *}
  TKUserProfileRec : TUserProfileType;
  TKPayLines : TTKPayLines;
  bMultiCurr : boolean;

const
  mbWriteOff = mbAbort;
  mbLeaveOutstanding = mbRetry;
  mrWriteOff = mrAbort;
  mrLeaveOutstanding = mrRetry;

implementation
uses
{$IFDEF TCCU}  // Trade Counter Customisation
  CustIntU, EnterpriseTrade_TLB,
{$ENDIF}
  EPOSKey, EPOSMess, SysUtils, AdPort, MathUtil, APIUtil, Messages, JPeg, BtrvU2
  , BTKeys1U, LicUtil, ETMiscU;

{TVATInfo}

constructor TVATInfo.Create(Rate : real; Code : Char);
begin
  inherited create;
  rRate := Rate;
  cCode := Code;
end;



function BarCodeKeyPress(Sender: TObject; var Key: Char; TheActiveControl : TWinControl
; TheHandle: THandle; var bBarCode : boolean; var sBarCode : string; bDoSomething : boolean) : boolean;
{Handles the possible input of a barcode}
{Barcode reader must be setup to send : [STX]BARCODE[ETX]}
const
  STX = #2;
  ETX = #3;
begin
  Result := FALSE;
  if Key = STX then
    begin
      bBarCode := TRUE;
      sBarCode := '';
    end
  else begin
    if bBarCode then
      begin
        if Key = ETX then
          begin
            bBarCode := FALSE;
            if bDoSomething then Result := TRUE;
          end
        else sBarCode := sBarCode + Key;
        Key := #0
      end
    else GlobFormKeyPress(Sender, Key, TheActiveControl, TheHandle);
  end;{if}
end;

function TPayedByToText(PayedBy : TPayedBy; iLCardType : integer) : string;
{converts a TPayedBy variable into a description of the payment}
begin
  case PayedBy of
    pbCash : Result := 'Cash Payment';
    pbCard : begin
      if iLCardType = -1 then Result := 'Card Payment'
      else Result := 'Card Payment (' + SetupRecord.CreditCards[iLCardType].Desc + ')';
    end;
    pbCheque : Result := 'Cheque Payment';
    pbAccount : Result := 'Account Payment';
  end;{case}
end;

function MyMsgBox(scaption: string; etype: TMsgDlgType; sButtons: TMsgDlgButtons;
eDefault: TmsgDlgBtn; stitle: string; iHelpContext : integer = 0): byte;
{my own MsgBox}
begin
  with TFrmMessageBox.Create(scaption, sButtons, eDefault, stitle, etype, iHelpContext) do begin
    try
      Result := showmodal;
    finally
      Release;
    end;{try}
  end;{with}
end;

Procedure OpenCashDrawer(iComPort, iBaudRate : integer; sKickOutCodes : string);
var
  iStartPos, iEndPos : integer;
  TheCOMPort : TApdComPort;
begin
  try
    TheCOMPort := TApdComPort.Create(nil);
    with TheCOMPort do begin
      {set com port settings}
      ComNumber := iComPort;

      case iBaudRate of
        0 : Baud := 9600;
        1 : Baud := 19200;
        2 : Baud := 38400;
        3 : Baud := 57600;
        4 : Baud := 115200;
      end;{case}

      Open := TRUE;
  {    Output := #27#112#0#5#50;}

      {extracts each esc code from the string and sends it to the com port}
      {string needs to be like this "123 34 212 67"}
      iEndPos := 0;
      Repeat
       iStartPos := iEndPos + 1;
       iEndPos := Pos(' ',Copy(sKickOutCodes, iStartPos,SizeOf(sKickOutCodes))) + iStartPos - 1;

       {send esc codes}
       if iEndPos <= iStartPos then Output := CHR(StrToIntDef(Copy(sKickOutCodes,iStartPos,length(sKickOutCodes)),0))
       else Output := CHR(StrToIntDef(Copy(sKickOutCodes,iStartPos,iEndPos - iStartPos),0));

      Until iEndPos <= iStartPos;

      Open := FALSE;
      Free;
    end;{with}
  except
    on E : Exception do begin
      MsgBox('Could not open cash drawer.'#13#13 + E.Message, mtError,[mbOK],mbOK,'COM Port Error');
    end;{on}
  end;{try}
end;

Function AllowedTo(DoIt : TAllowedTo) : boolean;
var
  sMessage : string;
begin
  if not aAllowedTo[DoIt] then begin
    case DoIt of
      atRunTradeCounter : sMessage := 'go any further.';
      atEnterNegQty : sMessage := 'enter negative quantities.';
      atEnterNegValue : sMessage := 'enter negative values.';
      atAccessAdmin : sMessage := 'access the administrator program.';
      atSetPriceToZero : sMessage := 'set the price of a stock item to zero.';
      atNegativeStock : sMessage := 'have negative stock.';
      atSellAtLessThanCost : sMessage := 'sell stock items at less than cost.';
      else sMessage := '';
    end;{case}

    {ShowMessage}
    if sMessage <> '' then begin
      sMessage := 'Your access rights for the Trade Counter Module do not allow you to ' + sMessage + #13#13
      + 'Please contact your system administrator.';
      MyMsgBox(sMessage, mtInformation, [mbOK],mbOK,'Security Check');
    end;{if}
  end;{if}
  Result := aAllowedTo[DoIt];
end;

function CheckSecurity(iAreaCode : LongInt) : boolean;
var
  iStatus : integer;
  iSecurityResult : smallint;
  pUserName : PChar;
begin
  pUserName := StrAlloc(255);
  StrPCopy(pUserName,sUserName);
  iStatus := EX_CHECKSECURITY(pUserName, iAreaCode, iSecurityResult);
  ShowTKError('EX_CHECKSECURITY', 134, iStatus);
  Result := (iStatus = 0) and (iSecurityResult = 1);
  StrDispose(pUserName);
end;{CheckSecurity}

procedure FillVATCombo(cmbVATRate : TComboBox);
Const
  VATCodeList : Array [1..21] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');
var
  iStatus, iPos : smallint;
  TKVATRec : TBatchVATRec;
begin
  For iPos := Low(VATCodeList) To High(VatCodeList) Do begin
    TKVATRec.VATCode := VATCodeList[iPos];
    iStatus := Ex_GetVatRate(@TKVATRec, SizeOf(TKVATRec));
    if iStatus = 0 then cmbVATRate.Items.AddObject(TKVATRec.VATDesc + ' (' + TKVATRec.VATCode + ')'
    ,TVATInfo.Create(TKVATRec.VATRate, TKVATRec.VATCode));
    ShowTKError('Ex_GetVatRate', 81, iStatus);
  end;{for}
  if cmbVATRate.Items.Count > 0 then cmbVATRate.ItemIndex := 0;
end;

function GetVatRateFromCode(cVATCode : Char) : Real;{.166}
Const
  VATCodeList : Array [1..21] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');
var
  iStatus, iPos : smallint;
  TKVATRec : TBatchVATRec;
begin
  TKVATRec.VATCode := cVATCode;
  iStatus := Ex_GetVatRate(@TKVATRec, SizeOf(TKVATRec));
  if iStatus = 0 then Result := TKVATRec.VATRate;
  ShowTKError('Ex_GetVatRate', 81, iStatus);
end;

Procedure HighlightVATRate(cVATCode : char; cmbVATRate : TComboBox);
var
  iPos : integer;
begin
  For iPos := 0 to cmbVATRate.Items.Count - 1 do begin
    if TVATInfo(cmbVATRate.Items.Objects[iPos]).cCode = cVATCode then cmbVATRate.ItemIndex := iPos;
  end;{for}
end;

Function CreditCheck(TheCust : CustRec; rExtraAmount : real) : boolean;
Var
  iStatus : SmallInt;
  KeyS : Str255;
  TKBalanceRec : THistoryBalRec;
  pCustCode : PChar;
  rBalance : Real;
  sMessage : string;
  bShowWarning : boolean;
Begin

  with TheCust, TKSysRec do begin

    If UseCrLimitChk or UseCreditChk then begin

      sMessage := '';

      bShowWarning := rExtraAmount = 0;

      { if necessary, substitute Head-Office account }
      if Trim(SOPInvCode) <> '' then begin
        KeyS := SOPInvCode;
        iStatus := Find_Rec(B_GetGEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyS);
        if (iStatus = 0) and (Trim(Cust.CustCode) = Trim(SOPInvCode)) then TheCust := Cust;
      end;{if}

      { Add on any extra amount for the current TX to the current balance (from toolkit)}
      FillChar(TKBalanceRec, sizeOf(TKBalanceRec),#0);
      with TKBalanceRec do begin
        Period := 'YTD';
        pCustCode := StrAlloc(255);
        StrPCopy(pCustCode,CustCode);
        iStatus := Ex_GetAccountBalance(@TKBalanceRec, sizeof(TKBalanceRec), pCustCode, 0);
        StrDispose(pCustCode);
        ShowTKError('Ex_GetAccountBalance', 6, iStatus);

//        rBalance := Value + rExtraAmount;
        rBalance := Value + rExtraAmount + TKBalanceRec.CommitVal;{.200}

      end;{with}

      {if balance is over credit limit show warning}
      If UseCrLimitChk and (CreditLimit <> 0) and ((rBalance * TradeConst[IsACust(CustSupp)]) > CreditLimit)
      then sMessage := 'over their credit limit.'
      else begin
        {if credit is too old then  show warning}
        If UseCreditChk and (CreditStatus >= WksODue) then sMessage := 'a bad debtor.';
      end;

      if (sMessage <> '') and bShowWarning then MyMsgBox('Warning :' + #13#13 + 'This customer is '
      + sMessage, mtWarning, [mbOK], mbOK, 'Credit Checking');

      Result := sMessage = '';
    end;{if}
  end;{with}
end;

procedure FillCompanyCombo(cmbCompany : TComboBox);
begin
  FillCompanyList(TStringList(cmbCompany.Items));
  if cmbCompany.Items.Count > 0 then begin
    cmbCompany.ItemIndex := 0;
    if cmbCompany.Items.Count = 1 then cmbCompany.Enabled := FALSE;
  end;{if}
end;

procedure FillCompanyList(Companies : TStringList);
var
  CompanyInfo : TCompanyInfo;
  sCompanyPath : string;
  pCompanyPath : PChar;
  hEntCompDLL : THandle;
  GetCompany : function(COMPDIR : PCHAR; PARRAY : POINTER; VAR PARRAYSIZE : LONGINT) : SMALLINT; stdCall;
  CompArray : PCompanies;
  iStatus, i, ArrayItems : integer;
begin
  {Fill Company Combo}
  hEntCompDLL := LoadLibrary('EntComp.dll');
  if hEntCompDLL > HInstance_Error then GetCompany := GetProcAddress(hEntCompDLL, 'EX_GETCOMPANY');
  if Assigned(GetCompany) then begin
    new(CompArray);
    ArrayItems := SizeOf(CompArray^);

    pCompanyPath := StrAlloc(255);
    sCompanyPath := GetMultiCompDir;

//sCompanyPath := 'c:\excheqr\';

    StrPCopy(pCompanyPath,sCompanyPath);
//Showmessage(quotedStr(pCompanyPath));
//Showmessage(IntToStr(ArrayItems));
//Showmessage('b4');
    iStatus := GetCompany(pCompanyPath, CompArray, ArrayItems);
//Showmessage('AFTER');
    StrDispose(pCompanyPath);

    if iStatus = 0 then
      begin
        for i := 1 to ArrayItems do begin
          CompanyInfo := TCompanyInfo.create;
          CompanyInfo.CompanyRec := CompArray^[i];
          Companies.AddObject(CompArray^[i].CompName + ' (' + CompArray^[i].CompCode + ')', CompanyInfo);
        end;{for}
      end
    else ShowMessage('Error - EX_GETCOMPANY : ' + IntToStr(iStatus));
    dispose(CompArray);
  end;{if}
  FreeLibrary(hEntCompDLL);
end;


procedure NegateTKTXHeader(var TheTKTXHeader : TBatchTHRec);
var
  iPos : integer;
begin{NegateTKTXHeader}
  with TheTKTXHeader do begin
    For iPos := 0 to 20 do InvVatAnal[iPos] := InvVatAnal[iPos] * -1;
    InvNetVal := InvNetVal * -1;
    InvVat := InvVat * -1;
    DiscSetl := DiscSetl * -1;
    DiscSetAm := DiscSetAm * -1;
    DiscAmount := DiscAmount * -1;
    Settled := Settled * -1;
    BDiscount := BDiscount * -1;
  end;{with}
end;{NegateTKTXHeader}

procedure NegateTKTLines(var TheTKTLines : TBatchLinesRec; TheTKTXHeader : TBatchTHRec);
var
  iLine : integer;
begin{NegateTKTLines}
  For iLine := 1 to TheTKTXHeader.LineCount do begin
    with TheTKTLines[iLine] do begin
      if not payment then Qty := Qty * -1;
      if payment then NetValue := NetValue * -1;
      if not payment then VAT := VAT * -1;
      QtyPick := QtyPick * -1;
    end;{with}
  end;{for}
end;{NegateTKTLines}

function OpenLayawayFiles(bCloseFiles : boolean) : integer;
begin
  Result := 0;

  // close layaway files
  if bCloseFiles then begin
    Result := Close_File(F[LayHeadF]);
    if Result = 0 then Result := Close_File(F[LayLineF])
    else Report_BError(LayHeadF,Result);
    if Result = 0 then Result := Close_File(F[LaySerialF])
    else Report_BError(LayLineF,Result);
    if Result = 0 then Result := Close_File(F[LayBinF])
    else Report_BError(LaySerialF,Result);
    if Result <> 0 then Report_BError(LayBinF,Result);
  end;{if}

//  Make_File(F[LayBinF],sCurrCompPath + FileNames[LayBinF],FileSpecOfs[LayBinF]^
//  ,FileSpecLen[LayBinF]);

  // open current company's layaway files
  if Result = 0 then
  begin
    Result := Open_File(F[LayHeadF], sCurrCompPath + FileNames[LayHeadF], 0);
    if Result = 0 then
    begin
      Result := Open_File(F[LayLineF], sCurrCompPath + FileNames[LayLineF], 0);
      if Result = 0 then
      begin
        Result := Open_File(F[LaySerialF], sCurrCompPath + FileNames[LaySerialF], 0);
        if Result = 0 then
        begin
          Result := Open_File(F[LayBinF], sCurrCompPath + FileNames[LayBinF], 0);
          Report_BError(LayBinF,Result);
          if Result <> 0 then
          begin
            Report_BError(LayBinF,Result);
          end;
        end else
        begin
          Report_BError(LaySerialF,Result);
        end;{if}
      end else
      begin
        Report_BError(LayLineF,Result);
      end;{if}
    end else
    begin
//      Result := Make_File(F[LayHeadF], sCurrCompPath + FileNames[LayHeadF]
//      , FileSpecOfs[LayHeadF]^, FileSpecLen[LayHeadF]);
      Report_BError(LayHeadF,Result);
    end;{if}
{  end else
  begin
    Report_BError(LayHeadF,Result);}
  end;{if}
end;{OpenLayawayFiles}


procedure GetLocationRec(sLocation : string);
Var
  iStatus  :  Integer;
  PCLoc   :  PChar;
  SearchPath : SmallInt;
begin
  if TKSysRec.MultiLocn = 0 then FillChar(TKLocationRecord, sizeOf(TKLocationRecord),#0)
  else begin

    SearchPath:=0;

    TKLocationRecord.loCode:=sLocation;

    {* allocate memory buffer for PC Location as String 255 *}
    PCLoc := StrAlloc (255);

    {* assign Location Code into PC *}
    StrPCopy(PCLoc, TKLocationRecord.loCode);

    {* Find by using DLL function  *}
    iStatus := Ex_GetLocation(@TKLocationRecord,SizeOf(TKLocationRecord),PCLoc,SearchPath,B_GetEq,False);
    ShowTKError('Ex_GetLocation', 72, iStatus);

    {* dispose allocated buffer of PC *}
    StrDispose(PCLoc);
  end;{if}
end;

procedure GetUserProfileRec(sUser : string);
Var
  iStatus :  Integer;
  PCUserID   :  PChar;
begin
  TKUserProfileRec.upUserId := sUser;

  {* allocate memory buffer for PC User as String 255 *}
  PCUserID := StrAlloc (255);

  {* assign User ID into PC *}
  StrPCopy(PCUserID, TKUserProfileRec.upUserId);

  {* Find by using DLL function  *}
  iStatus := Ex_GetUserProfile(@TKUserProfileRec,SizeOf(TKUserProfileRec),PCUserID,B_GetEq);
  ShowTKError('Ex_GetUserProfile', 500, iStatus);

  {* dispose allocated buffer of PC *}
  StrDispose(PCUserID);
end;


Function Get_PWDefaults(PLogin  :  String10)  :  tPassDefType;
Const
  Fnum     =  MLocF;
  Keypath  =  MLK;
Var
  Mbret  :  Word;
  KeyS, KeyChk :  Str255;
  B_Func :  Integer;
  LOk, LLocked :  Boolean;
Begin
  // for getting User Profile Info
  Status := Open_File(F[MLocF], sCurrCompPath + FileNames[MLocF], 0);
  Report_BError(MLocF,Status);

  Blank(Result,Sizeof(Result));
  KeyChk:=FullPWordKey(PassUCode,'D',PLogin);
  KeyS:=KeyChk;

  Begin
    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (StatusOk) then
      Result:=MLocCtrl^.PassDefRec;

    Result.Loaded:=StatusOk;

  end; {With..}

  Close_File(F[MLocF]); // for getting User Profile Info

end;

Function GetProfileCCDep(CustCC,CustDep : String5; StkCCDep, InpCCDep : CCDepType
; ProtectInp : Byte) : CCDepType;
Begin
  Result:=InpCCDep;

  With UserProfile^ do
  Begin
    Case CCDepRule of

      1  :  Begin {Account, Stock, Opo}
              If (ProtectInp=1) then
              Begin
                If (EmptyKeyS(Result[BOn],CCKeyLen,BOff)) then
                  Result[BOn]:=CustCC;

                If (EmptyKeyS(Result[BOff],CCKeyLen,BOff)) then
                  Result[BOff]:=CustDep;
              end
              else
              Begin
                Result[BOn]:=CustCC;
                Result[BOff]:=CustDep;
              end;

              If (EmptyKeyS(Result[BOn],CCKeyLen,BOff)) then
                Result[BOn]:=StkCCDep[BOn];

              If (EmptyKeyS(Result[BOff],CCKeyLen,BOff)) then
                Result[BOff]:=StkCCDep[BOff];

              If (EmptyKeyS(Result[BOn],CCKeyLen,BOff)) then
                Result[BOn]:=CCDep[BOn];

              If (EmptyKeyS(Result[BOff],CCKeyLen,BOff)) then
                Result[BOff]:=CCDep[BOff];
            end;

      2  :  Begin {Opo, Account, Stock }
              If (ProtectInp=1) then
              Begin
                If (EmptyKeyS(Result[BOn],CCKeyLen,BOff)) then
                  Result[BOn]:=CCDep[BOn];

                If (EmptyKeyS(Result[BOff],CCKeyLen,BOff)) then
                  Result[BOff]:=CCDep[BOff];
              end
              else
              Begin
                Result:=CCDep;
              end;

              If (EmptyKeyS(Result[BOn],CCKeyLen,BOff)) then
                Result[BOn]:=CustCC;

              If (EmptyKeyS(Result[BOff],CCKeyLen,BOff)) then
                Result[BOff]:=CustDep;


              If (EmptyKeyS(Result[BOn],CCKeyLen,BOff)) then
                Result[BOn]:=StkCCDep[BOn];

              If (EmptyKeyS(Result[BOff],CCKeyLen,BOff)) then
                Result[BOff]:=StkCCDep[BOff];

            end;

      3  :  Begin {Opo, Stock, Account }
              If (ProtectInp=1) then
              Begin
                If (EmptyKeyS(Result[BOn],CCKeyLen,BOff)) then
                  Result[BOn]:=CCDep[BOn];

                If (EmptyKeyS(Result[BOff],CCKeyLen,BOff)) then
                  Result[BOff]:=CCDep[BOff];
              end
              else
              Begin
                Result:=CCDep;
              end;


              If (EmptyKeyS(Result[BOn],CCKeyLen,BOff)) then
                Result[BOn]:=StkCCDep[BOn];

              If (EmptyKeyS(Result[BOff],CCKeyLen,BOff)) then
                Result[BOff]:=StkCCDep[BOff];

              If (EmptyKeyS(Result[BOn],CCKeyLen,BOff)) then
                Result[BOn]:=CustCC;

              If (EmptyKeyS(Result[BOff],CCKeyLen,BOff)) then
                Result[BOff]:=CustDep;

            end;

      else  Begin {Stock, Account, Opo}
              If (ProtectInp=1) then
              Begin
                If (EmptyKeyS(Result[BOn],CCKeyLen,BOff)) then
                  Result[BOn]:=StkCCDep[BOn];

                If (EmptyKeyS(Result[BOff],CCKeyLen,BOff)) then
                  Result[BOff]:=StkCCDep[BOff];

              end
              else
              Begin
                Result:=StkCCDep;
              end;


              If (EmptyKeyS(Result[BOn],CCKeyLen,BOff)) then
                Result[BOn]:=CustCC;

              If (EmptyKeyS(Result[BOff],CCKeyLen,BOff)) then
                Result[BOff]:=CustDep;

              If (EmptyKeyS(Result[BOn],CCKeyLen,BOff)) then
                Result[BOn]:=CCDep[BOn];

              If (EmptyKeyS(Result[BOff],CCKeyLen,BOff)) then
                Result[BOff]:=CCDep[BOff];
            end;
    end; {Case..}


  end; {With..}
end;

function DoesUserExist(asUser, asCompPath : ANSIString; bOpenCloseDLL : boolean = FALSE) : boolean;
var
  bMultiCurr : boolean;
  iStatus : integer;

  Procedure CheckPassword;
  begin
    iStatus := EX_CHECKPASSWORD(PChar(ANSIUpperCase(asUser)), '');
    Result := (iStatus = 30002) or (iStatus = 0);
    case iStatus of
      30001, 30002 : ;

      else begin
        ShowTKError('EX_CHECKPASSWORD', 120, iStatus); {other error}
      end;
    end;{case}
  end;{CheckPassword}

begin
  if not bOpenCloseDLL then CheckPassword
  else begin

    {OpenDLL}
    iStatus := SetToolkitPath(PChar(asCompPath));
    if iStatus = 0 then
      begin

        {set multicurrency dependant on what files exist}
        if FileExists(asCompPath + '\DEFMC044.SYS') then
          begin
            bMultiCurr := TRUE;
          end
        else begin
          if FileExists(asCompPath + '\DEFPF044.SYS') then
            begin
              bMultiCurr := FALSE;
            end
          else begin
            {neither file exists : there is something wrong}
            MsgBox('Neither of the files DEFMC044.SYS or DEFPF044.SYS exist in the directory : '
            + asCompPath + '.' + #13 + #13 + 'This is not a valid exchequer system path.'
            ,mtError,[mbOk],mbOK,'Currency Detection Error');
            iStatus := -1;
          end;{if}
        end;{if}

        if iStatus = 0 then begin
          iStatus := Ex_InitDLLPath(Pchar(asCompPath),bMultiCurr);
          if iStatus = 0 then
            begin
              iStatus := Ex_InitDLL;
              if iStatus = 0 then
                begin
                  CheckPassword;
                  Ex_CloseData;
                end
              else begin
                MyMsgBox('The DLL Toolkit failed to open with the error code : ' + IntToStr(iStatus),mtError
                ,[mbOK],mbOK,'Toolkit Open Error');
              end;{if}
            end
          else begin
            MyMsgBox('The DLL Toolkit path was not set with the error code : ' + IntToStr(iStatus),mtError
            ,[mbOK],mbOK,'Toolkit InitPath Error');
          end;{if}
        end;{if}
      end
    else begin
      MyMsgBox('Unable to change the path of the DLL Toolkit - error code : ' + IntToStr(iStatus),mtError
      ,[mbOK],mbOK,'Toolkit Path Error');
    end;{if}
    screen.cursor := crDefault;
  end;{if}

end;{DoesUserExist}



procedure FillStandardTXHead(var TheTKTXHeader : TBatchTHRec);
begin
  with TheTKTXHeader do begin
    TransDate := DateTimeAsLongDate(SysUtils.Date);
    DueDate := TransDate;
    AcPr := TKSysRec.ExPr;
    AcYr := TKSysRec.ExYr;
    Currency := SetupRecord.TillCurrency;
    CoRate := 1; {Toolkit will deal with this later}
    VatRate := 1; {Toolkit will deal with this later}
    DocUser4 := 'EPOS' + PadString(psLeft,IntToStr(iTillNo),'0',2) + ':' + sTillName;
    Opname := sUserName;
    AllocStat := 'C';

    // CJS 2013-11-05 - MRD2.6.44 - Support for Transaction Originator
    thOriginator := sUsername;

    case SetupRecord.TransactionType of
      TX_SINs : TransDocHed := 'SIN';
      TX_PICKED_SORs, TX_UNPICKED_SORs : TransDocHed := 'SOR';
    end;{case}

  end;{with}
end;{with}

Function VatCharToIdx(VATChar : Char) : SmallInt;
// Converts an String containing a VAT Code into an Toolkit VAT array index
Var
  I       : Integer;
Const
  THVATCode :  Array[0..20] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9'
  ,'T','X','B','C','F','G','R','W','Y');
Begin { VatCharToIdx }
  Result := -1;

  // Run through list of valid VAT Codes to identify index
  For I := Low(THVatCode) To High(THVatCode) Do
    If (THVatCode[I] = VATChar) Then Begin
      Result := I;
      Break;
    End; { If (THVatCode[I] = VATChar) }

  // Raise exception if invalid
  If (Result = -1) Then
    Raise Exception.Create ('Invalid ' + sVATText + ' Code ' + QuotedStr(VATChar));
End; { VatCharToIdx }

function WordBoolOrd(TheWordBool : WordBool) : byte;
begin
  if TheWordBool then Result := 1
  else Result := 0;
end;

function GetStockFolioFromCode(sStockCode : string) : integer;
var
  LTKStockRec : TBatchSkRec;
  iStatus : integer;
begin
  Result := 0;
  iStatus := Ex_GetStock(@LTKStockRec, SizeOf(LTKStockRec), PChar(sStockCode), 0, B_GetEq, FALSE);
  if iStatus = 0 then Result := LTKStockRec.StockFolio;
end;

function AddressBlank(Address : AddrTyp) : boolean;
begin
  Result := (Trim(Address[1]) = '') and (Trim(Address[2]) = '') and (Trim(Address[3]) = '')
  and (Trim(Address[4]) = '') and (Trim(Address[5]) = '');
end;

function IsEnterprisePro : boolean;
var
  LicenceInfo : EntLicenceRecType;
  LicencePath : shortstring;
begin{IsEnterprisePro}
  LicencePath := GetMultiCompDir + EntLicFName;
  if ReadEntLic(LicencePath, LicenceInfo) then Result := LicenceInfo.licEntCVer = 0
  else Result := FALSE;
end;{IsEnterprisePro}

function OverrideTKIniFile : boolean;
var
  iStatus : smallint;

  function OverrideSetting(Setting, Value : PChar) : boolean;
  begin
    Result := TRUE;
    iStatus := Ex_OverrideIni(Setting, Value);
    if iStatus <> 0 then Result := FALSE;
    ShowTKError('Ex_OverrideIni', 129, iStatus);
  end;{OverrideSetting}

begin{OverrideTKIniFile}
  Result := TRUE;

  {get setting from enterprise system setup}
  if TKSysRec.CalPrFromDate then
    begin
      if not OverrideSetting('Auto_Set_Period', 'ON') then Result := FALSE;
    end
  else begin
    if not OverrideSetting('Auto_Set_Period', 'OFF') then Result := FALSE;
  end;

  if Result and (not OverrideSetting('Auto_Set_Stock_Cost', 'ON')) then Result := FALSE;
  if Result and (not OverrideSetting('Deduct_BOM_Stock', 'ON')) then Result := FALSE;
  if Result and (not OverrideSetting('Deduct_MultiLoc_Stock', 'ON')) then Result := FALSE;
  if Result and (not OverrideSetting('Overwrite_Trans_No', 'ON')) then Result := FALSE;
  if Result and (not OverrideSetting('Use_Ex_Currency', 'ON')) then Result := FALSE;
  if Result and (not OverrideSetting('Allow_Trans_Edit', 'ON')) then Result := FALSE;
  if Result and (not OverrideSetting('Update_Account_Bal', 'ON')) then Result := FALSE;
  if Result and (not OverrideSetting('Update_Stock_Levels', 'ON')) then Result := FALSE;
  if Result and (not OverrideSetting('Ignore_JobCost_Validation', 'OFF')) then Result := FALSE;
  if Result and (not OverrideSetting('Overwrite_Note_Pad', 'OFF')) then Result := FALSE;
end;{OverrideTKIniFile}

Function CheckStock(TKStockRec : TBatchSKRec; TKStockLocRec : TBatchSLRec; rLineQty : real) : boolean;

  Function CheckStockLevel(LStockrec : TBatchSkRec; LStockLocRec : TBatchSLRec; rQty : real) : boolean;
  begin{CheckStockLevel}
    Result := TRUE;

    // NOT Multi Location Stock
    if ((TKSysRec.MultiLocn = 0)
    and ((LStockrec.QtyInStock - Lstockrec.QtyPicked - Lstockrec.QtyPickWOR) < rQty))
    then Result := FALSE;

    // Multi Location Stock
    if ((TKSysRec.MultiLocn > 0)
    and ((LStockLocRec.lsQtyInStock - LStockLocRec.lsQtyPicked - LStockLocRec.lsQtyPickWOR) < rQty))
    then Result := FALSE;
  end;{CheckStockLevel}

var
  BOMLinesRec : TBatchBOMLinesRec;
  LStockRec : TBatchSkRec;
  LStockLocRec : TBatchSLRec;
  asStockCode, asDefStockLocation, asCompStockCode : ANSIString;
  iStatus, iComp : integer;
  bBOMStockLevelOK : boolean;

begin{CheckStock}
  Result := TRUE;

  // v6.50.314 12/11/2010 Fix for https://jira.iris.co.uk/browse/ABSEXCH-10477
  // Do not check non-stock items
  if Trim(TKStockRec.StockCode) = '' then exit;

  asDefStockLocation := SetupRecord.DefStockLocation;

  if (TKStockRec.stocktype <> 'D') then
  begin

    // Is it a BOM ?
    if (TKStockRec.StockType = 'M') {and TKStockRec.ShowAsKit} then
    begin

      // Get Stock Record for the BOM
      asCompStockCode := TKStockRec.StockCode;
      iStatus := EX_GETSTOCK(@LStockRec, SizeOf(LStockRec), PChar(asCompStockCode)
      , 0, B_GetEq, FALSE);

      if iStatus = 0 then
      begin

        // Get Stock Location Record for the BOM
        iStatus := EX_GETSTOCKLOC(@LStockLocRec, SizeOf(LStockLocRec)
        , PChar(asCompStockCode), PChar(asDefStockLocation), FALSE);

        if (iStatus = 4) then
        begin
          // There are no stock location records for this item
          FillChar(LStockLocRec, SizeOf(LStockLocRec), #0);
        end else
        begin
          ShowTKError('EX_GETSTOCKLOC', 70, iStatus);
        end;{if}

        // Check Stock Level of BOM itself
        bBOMStockLevelOK := CheckStockLevel(LStockRec, LStockLocRec, rLineQty);
        if bBOMStockLevelOK then exit;  // Stock Level of BOM is OK so we're alright

        if TKSysRec.DeductBOMComponents then
        begin

          // Check Stock levels for all the components in this BOM, since the BOM is not in stock
          asStockCode := TKStockRec.StockCode;

          // get the components for this BOM
          if EX_GETSTOCKBOM(@BOMLinesRec, SizeOf(BOMLinesRec), PChar(asStockCode), 0) = 0 then
          begin

            // go through all the components
            For iComp := 1 to 500 do
            begin
              asCompStockCode := BOMLinesRec[iComp].StockCode;

              // stop when you find a blank stock code
              if trim(asCompStockCode) = '' then exit;

              // Get Stock Record for this component
              iStatus := EX_GETSTOCK(@LStockRec, SizeOf(LStockRec), PChar(asCompStockCode)
              , 0, B_GetEq, FALSE);
              if iStatus = 0 then
              begin
                // Get Stock Location Record for this component
                iStatus := EX_GETSTOCKLOC(@LStockLocRec, SizeOf(LStockLocRec)
                , PChar(asCompStockCode), PChar(asDefStockLocation), FALSE);

                if (iStatus = 4) then
                begin
                  // There are no stock location records for this item
                  FillChar(LStockLocRec, SizeOf(LStockLocRec), #0);
                end else
                begin
                  ShowTKError('EX_GETSTOCKLOC', 70, iStatus);
                end;{if}

              end else
              begin
                // Stock Record Not found
                if (iStatus = 4) then FillChar(LStockRec, SizeOf(LStockRec), #0)  // No Stock Record - this should never happen
                else ShowTKError('EX_GETSTOCK', 80, iStatus);
              end;{if}

              Result := CheckStock(LStockRec, LStockLocRec, rLineQty * BOMLinesRec[iComp].QtyUsed);

              // quit if any component is not in stock
              if Result = FALSE then exit;

            end;{for}
          end;{if}
        end else
        begin
          Result := bBOMStockLevelOK;
        end;{if}
      end else
      begin
        // Stock Record Not found
        if (iStatus = 4) then FillChar(LStockRec, SizeOf(LStockRec), #0)  // No Stock Record - this should never happen
        else ShowTKError('EX_GETSTOCK', 80, iStatus);
      end;{if}
    end else
    begin
      // Not a BOM so just check the stock level of the Stock item
      Result := CheckStockLevel(TKStockRec, TKStockLocRec, rLineQty);
    end;{if}
  end;{if}
end;{CheckStock}

// v6.40.311
// https://jira.iris.co.uk/browse/ABSEXCH-9892
// https://jira.iris.co.uk/browse/ABSEXCH-7881
// No longer shows a warning for unpicked SORs, if you are allowed negative stock.
procedure ShowStockWarning(var bContinue : boolean; sExtraText : string = '');
var
  bNegStockAllowed : boolean;
begin{ShowStockWarning}
  bNegStockAllowed := aAllowedTo[atNegativeStock]; // Does not show message

  // Show Warning, if negative stock not allowed
  if not bNegStockAllowed then
  begin
    MyMsgBox('There is not enough stock to cover the quantity that you have entered.'
    + #13#13 + sExtraText, mtInformation,[mbOK],mbOK,'Stock Level Warning');
  end;{if}

  if (SetupRecord.TransactionType = TX_UNPICKED_SORs) then
  begin
    // Unpicked SORs
    bContinue := TRUE; // always allow user to continue
  end
  else
  begin
    // Picked SORs or SINs/SRIs
    bContinue := bNegStockAllowed; // do not allow user to continue, if Neg stock not allowed
  end;{if}

//  Result := bContinue;
end;{ShowStockWarning}



end.
