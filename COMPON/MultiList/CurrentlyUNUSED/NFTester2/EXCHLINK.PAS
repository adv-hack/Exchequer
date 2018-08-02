unit ExchLink;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  DllProc, VarConst, GlobVar, Dialogs, CardProc, StrUtil, SysUtils, NeilPRoc
  , BTSupU1, BtrvU2, UseDllU, ExWrap1U;

{$I EXDLLBT.INC}

type
 TOEnterprise = Class
   function PostTransaction(PostInv : InvRec) : string10;
   Function DoPost(iNomType : integer; sNomRef : string10; rValue, rDiscount : real; sHeaderDesc, sDesc : string) : string10;
   procedure Control_SR(GInv : InvRec; Edit : Boolean; Mode : Byte; OverRideType : Byte);
   procedure Control_NT(GInv : InvRec; Edit : Boolean; OverrideType : Byte);
   Procedure AddNMTDiscount (GInv : InvRec);
   Procedure Create_NTHed(Var Abort,InitBo : Boolean;
   NTitle : Str80; GInv : InvRec; NewRec : Boolean);
   Procedure Control_SRF(PostNo : LongInt; SRFNET, SRFVAT : Real; Mode : Byte);
   Procedure AddNMTZero (GInv : InvRec);
 end;

var
  oEnterprise : TOEnterprise;

implementation



{TOEnterprise}

procedure TOEnterprise.Control_SR(GInv : InvRec; Edit : Boolean; Mode : Byte; OverRideType : Byte);
{var
  InitBo, Abort : Boolean;
  MNCode : LongInt;
  GenStr, KeyS : Str255;}
begin

{  if (LoginMode = lmDebug) and (Syss.LinkToExch) then ShowMessage('Control_SR');}


(*  Abort := FALSE;
  InitBo := FALSE;
  GenStr := '';
  if (Edit) then Abort := not Find_NT(GInv);
  if (not Abort) then begin
    Create_SRHed(Abort,InitBo,GInv,1,not Edit,Mode,(Ginv.PayType=PayTypes[2]));
    if (OverRideType <> 0) then MNCode := Syss.CNoms[OverrideType]
    else MNCode:=Syss.CNoms[Char2PayType(Ginv.PayType)];

    GenStr:=GInv.TransDesc;
    If (GenStr<>'') then GenStr:=GenStr+', ';

    with Cust do GenStr:=GenStr+Strip('B',[#32],FullOName('',FirstName,ChrisName,Company,On)+' - '+CustCode)
    + ' ('+Form_Real(GInv.InvNetVal,0,2)+'+'+Form_Real(GInv.Discount,0,2)+'%)';

    if (GInv.PayType<>PayTypes[2]) then
      begin
        {* BR Transfer *}
        Add_SRLines(1,ITotalLVD(GInv),Syss.CNoms[BRNomCode],GenStr,Abort,Off);

        {* Bank Transfer *}
        Add_SRLines(RecieptCode,GInv.InvNetVal,MNCode,GInv.TransDesc,Abort,Off);

        If (Ginv.DiscAmount<>0) then Add_SRLines(RecieptCode,GInv.DiscAmount
        * DocNotCnst,Syss.CNoms[DisNomCode],GInv.TransDesc,Abort,Off);
      end
    else begin  {* Subs Renewal, transfer already taken place at payment stage force a zero thru just to complete doc *}
      {* BR Transfer *}
      {* Bank Transfer *}
    end;{if}
  end;{if}*)
end;

procedure TOEnterprise.Control_NT(GInv : InvRec; Edit : Boolean; OverrideType : Byte);
{var
  InitBo, Abort : Boolean;
  MNCode : LongInt;
  GenStr, KeyS : Str255;}
begin

{ if (LoginMode = lmDebug) and (Syss.LinkToExch) then ShowMessage('Control_NT');}

(*  Abort := FALSE;
  InitBo := FALSE;
  GenStr := '';

  if (Edit) then Abort := not Find_NT(GInv);

  if (not Abort) then begin
    Create_NTHed(Abort,InitBo,'B/R Receipt',GInv,not Edit);
    if (OverrideType <> 0) then MNCode := Syss.CNoms[OverrideType]
    else MNCode := Syss.CNoms[Char2PayType(Ginv.PayType)];

    GenStr:=GInv.TransDesc;
    if (GenStr <> '') then GenStr := GenStr + ', ';

    with Cust do GenStr:=GenStr+FullOName('',FirstName,ChrisName,Company,On)+' - '+CustCode
    + ' ('+PPR(GInv.Discount,Fpos[RDisNo])+')';

    if (GInv.PayType<>PayTypes[2]) then
      begin
        {* BR Transfer *}
        Add_NTLines(0,Full_ITotal(GInv),Syss.CNoms[BRNomCode],MNCode,GenStr,Abort,Off);

        {* Bank Transfer *}
        Add_NTLines(0,(GInv.InvNetVal*DocCnst[GInv.InvDocHed]),MNCode,MNCode,GenStr,Abort,Off);

        {* Discount Transfer *}
        If (Ginv.DiscAmount<>0) then Add_NTLines(0,(GInv.DiscAmount*DocCnst[GInv.InvDocHed])
        *DocNotCnst,Syss.CNoms[DisNomCode],MNCode,GenStr,Abort,Off);
      end
    else begin  {* Subs Renewal, transfer already taken place at payment stage force a zero thru just to complete doc *}
      {* BR Transfer *}
      Add_NTLines(0,0,Syss.CNoms[BRNomCode],MNCode,GenStr,Abort,Off);

      {* Bank Transfer *}
      Add_NTLines(0,0,MNCode,MNCode,GenStr,Abort,Off);
    end;{if}
  end;{if}*)
end; {Proc..}

Procedure TOEnterprise.AddNMTDiscount(GInv : InvRec);
Var
  InitBo, Abort  : Boolean;
  GenStr, KeyS   : Str255;
Begin { AddNMTDiscount }

{  if (LoginMode = lmDebug) and (Syss.LinkToExch) then ShowMessage('AddNMTDiscount');}


(*  Abort := FALSE;
  InitBo := FALSE;

  GenStr:='';

  If (Not Abort) then Begin
    Create_NTHed(Abort, InitBo, 'B/R Receipt', GInv, True);

    GenStr := GInv.TransDesc;

    If (GenStr <> '') then
      GenStr := GenStr + ', ';

    With Cust do
      GenStr:=GenStr+FullOName('',FirstName,ChrisName,Company,TRUE)+' - '+CustCode+
              ' ('+PPR(GInv.Discount,Fpos[RDisNo])+')';

    If (Ginv.DiscAmount <> 0) then Begin
      { Discount Transfer }
      Add_NTLines (0,
                   (GInv.DiscAmount*DocCnst[GInv.InvDocHed])*DocNotCnst,
                   Syss.CNoms[BrNomCode],
                   Syss.CNoms[DisNomCode],
                   GenStr,
                   Abort,
                   Off);

      Add_NTLines (0,
                   -(GInv.DiscAmount*DocCnst[GInv.InvDocHed])*DocNotCnst,
                   Syss.CNoms[DisNomCode],
                   Syss.CNoms[BrNomCode],
                   GenStr,
                   Abort,
                   Off);
    end;
  end;*)
end; {Proc..}


Procedure TOEnterprise.Create_NTHed(Var Abort,InitBo : Boolean;
NTitle : Str80; GInv : InvRec; NewRec : Boolean);
{Const
  Fnum    =  EInvF;
  Keypath =  EInvOurRefK;}
Begin

{  if (LoginMode = lmDebug) and (Syss.LinkToExch) then ShowMessage('Create_NTHed');}

(*  If (NewRec) then ResetRec(Fnum);
  With EInv do Begin
    NomAuto := TRUE;
    InvDocHed := NMT;
    TransDate := GInv.TransDate;
    AcPr := Fin_Pr(TransDate);
    AcYr := Fin_Yr(TransDate);
    Currency := 0;
    TransDesc := NTitle;
    CXrate := SyssCurr.Currencies[Currency].CRates;
    InvDocHed := DocTypes(Ord(InvDocHed)+2);
    OurRef := GInv.OurRef;
    FolioNum := GInv.FolioNum;
    ExternalDoc := TRUE;
    If (NewRec) then iStatus := Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath)
    else iStatus := Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);
    Report_BError(iStatus);
    Abort := Not iStatus = 0;
    InitBo := TRUE;
  end; {With..}*)
end; {Proc..}

Procedure TOEnterprise.Control_SRF(PostNo : LongInt; SRFNET, SRFVAT : Real; Mode : Byte);
Var
  InitBo,Abort    :  Boolean;
  MNCode   :  LongInt;
  GenStr, KeyS     :  Str255;
Begin

{  if (LoginMode = lmDebug) and (Syss.LinkToExch) then ShowMessage('Control_SRF');}

  (*  Abort:=Off;  InitBo:=Off;
  If (Not Abort) then Begin
    Create_SRFHed(Abort,InitBo,SRFVAT,1,PostNo);
    GenStr:='Advanced VAT Credit on Sales of '+Form_Real(SRFNet,0,2);
    Add_SRLines(1,0,Syss.CNoms[BRNomCode],GenStr,Abort,Off);
    GenStr:='Run '+Form_Int(PostNo,0);

    {* BR Transfer *}
    Add_SRLines(RecieptCode,SRFVAT,Syss.CNoms[BRNomCode],GenStr,Abort,Off);
  end;*)
end; {Proc..}


Procedure TOEnterprise.AddNMTZero(GInv : InvRec);
{Adds the NOM for Zeroing/Initialising Balances}
Var
  InitBo, Abort  : Boolean;
  GenStr, KeyS   : Str255;
  MNCode         : LongInt;
Begin { AddNMTZero }

{  if (LoginMode = lmDebug) and (Syss.LinkToExch) then ShowMessage('AddNMTZero');}

{  Abort:=Off;
  InitBo:= Off;

  GenStr:='';

  If (Not Abort) then Begin
    Create_NTHed(Abort, InitBo, 'B/R Receipt', GInv, True);

    GenStr := GInv.TransDesc;

    If (GenStr <> '') then
      GenStr := GenStr + ', ';

    With Cust do
      GenStr:=GenStr+FullOName('',FirstName,ChrisName,Company,On)+' - '+CustCode+
              ' ('+PPR(GInv.Discount,Fpos[RDisNo])+')';

    Add_NTLines (0,
                 Full_ITotal(GInv),
                 Syss.CNoms[Nom_CardAccount],
                 Syss.CNoms[Nom_Corrections],
                 GenStr,
                 Abort,
                 True);
  End; { If }
end; { AddNMTZero }

Function TOEnterprise.PostTransaction(PostInv : InvRec) : string10;
var
  cPayType : Char;
  iCustRecAddress, iPrevKey, iStatus, iNomType : integer;
  ExLocal : TdExLocal;
  KeyS : str255;
  rDebits, rIncentive, rCredits, rBalance : real;
begin
  with PostInv do begin
    if Source in [isUnknown, isEodTopup, isFuncBook, isEODSpend] then begin
      if (Source = isUnknown) and (PayType = PAYTYPE_RENEWAL) then Exit
      else begin
        if Source = isFuncBook then cPayType := TYPE_FUNCTION_BOOKING
        else cPayType := PayType;

        with Syss do begin
          case cPayType of
            PAYTYPE_CASH : iNomType := NOM_CASH;
            PAYTYPE_CORRECTION : iNomType := NOM_CORRECTION;
            PAYTYPE_FORFEIT : iNomType := NOM_FORFEIT;
            #0, TYPE_FUNCTION_BOOKING : iNomType := NOM_SALES;
          end;{case}
        end;{with}

        {Get Card Record}
        ExLocal.Create;
        with ExLocal do begin
          iPrevKey := GetPosKey;
          LPresrv_BTPos(CustF, iPrevKey, F[CustF], iCustRecAddress, FALSE, FALSE);

          KeyS := CustCode;
          iStatus := Find_Rec(B_GetGEq, F[CustF],CustF,LRecPtr[CustF]^,CustCodeK,KeyS);
          LGetRecAddr(CustF);
          if iStatus <> 9 then Report_BError(CustF, iStatus);

          CalcInvoiceCredits(PostInv, rDebits, rIncentive, rCredits, rBalance);

          {Post TX}

          if Source = isEODSpend then begin
            PostInv.OurRef := '';
            PostInv.InvNetVal := 0;
          end;{if}

{          Result := DoPost(iNomType, PostInv.OurRef, PostInv.InvNetVal, (PostInv.DiscAmount * -1)
          , 'CS ' + GetTransDesc(PostInv, rDebits) + ' ' + Trim(CustCode)
          , CardFullName(LCust, True, True) + ' ' + Trim(CustCode) + ' ' + GetTransDesc(PostInv, rDebits));}

          Result := DoPost(iNomType, PostInv.OurRef, PostInv.InvNetVal * -1, PostInv.DiscAmount
          , 'CS ' + GetTransDesc(PostInv, rDebits) + ' ' + Trim(CustCode)
          , CardFullName(LCust, True, True) + ' ' + Trim(CustCode) + ' ' + GetTransDesc(PostInv, rDebits));

          LPresrv_BTPos(CustF, iPrevKey, F[CustF], iCustRecAddress, TRUE, TRUE);

          Destroy;
        end;{with}
      end;
    end;{if}
  end;{with}
end;

Function TOEnterprise.DoPost(iNomType : integer; sNomRef : string10; rValue, rDiscount : real; sHeaderDesc, sDesc : string) : string10;
var
  MyTrans      : ^TBatchTHRec;
  MyTransLines : ^TBatchLinesRec;
  iStatus : smallint;

  function GetNextDocNo(DocType : string) : string;
  var
    Doc : array[0..255] of char;
    NextNo : array[0..255] of char;
    Res : integer;
  begin
    StrPCopy(Doc, DocType);
    Res := EX_GETNEXTTRANSNO(Doc, NextNo, true);
    if Res = 0 then
      Result := string(NextNo)
    else
      Result := '';
  end;

begin
{  MembersAccount := rValue + rDiscount;
  CNoms[iNomType] := - rValue;
  Discount := -
   rDiscount;}

{  ShowMessage('iNomType : ' + IntToStr(iNomType) + #13#13
  + 'CNoms[iNomType] :' + IntToStr(Syss.CNoms[iNomType]) + #13#13
  + 'rValue : ' + MoneyToStr(rValue) + #13#13
  + 'rDiscount : ' + MoneyToStr(rDiscount));}

  GetMem(MyTrans,      SizeOf (MyTrans^));
  GetMem(MyTransLines, SizeOf (MyTransLines^));

  FillChar(MyTrans^, SizeOf(MyTrans^), #0);
  FillChar(MyTransLines^, SizeOf(MyTransLines^), #0);

  if (Trim(sNomRef) = '') then sNomRef := GetNextDocNo('NOM');

  // Set transaction header fields
  with MyTrans^ do begin
    OurRef      := sNomRef;
    TransDate   := DateToStr8(now);
    DueDate := TransDate;
    Currency    := 0;
    AcYr        := 0;
    AcPr        := 0;
    CoRate      := 1.0;
    VATRate     := 1.0;
    YourRef     := '';
    LongYrRef   := sHeaderDesc;
    TransDocHed := 'NOM';
    OpName      := 'WinCard';

    LineCount := 3;
  end;

  {Set TX Lines}

  // Line 1 - Account = members card account
  with MyTransLines^[1] do
  begin
    TransRefNo  := sNomRef;
    Currency    := MyTrans^.Currency; // Currency number
    CoRate      := MyTrans^.CoRate;   // Company exchange rate
    VATRate     := MyTrans^.VATRate;  // Daily exchange rate
    LineDate    := MyTrans^.TransDate;
    Qty         := 1;
    QtyMul      := 1.0;
//    VATCode     := 'S';   // Avoid error 30107
    Desc        := sDesc;
    if oDll.TKSysRec.CCDepts then begin
      CC := Syss.DefaultCC;
      Dep := Syss.DefaultDept;
    end;{if}

    LineNo := 1;
    NomCode     := Syss.CNoms[NOM_CARD];
    NetValue    := rValue + rDiscount;
  end;

  // Line 2 - Account = Type passed in
  MyTransLines^[2] := MyTransLines^[1];
  with MyTransLines^[2] do begin
    LineNo := 2;
    NomCode := Syss.CNoms[iNomType];
    NetValue := - rValue;
  end;{with}

  // Line 3 - Account = Discount Account
  MyTransLines^[3] := MyTransLines^[1];
  with MyTransLines^[3] do begin
    LineNo := 3;
    NomCode := Syss.CNoms[NOM_DISCOUNT];
    NetValue := - rDiscount;
    Desc := Desc{ + ' (' + MoneyToStr(rDiscount) + ')'};
  end;{with}

  if sNomRef = '' then ShowMessage('Could not generate transaction number')
  else begin
    iStatus := Ex_StoreTrans(MyTrans, MyTransLines, SizeOf(MyTrans^), SizeOf(MyTransLines^), 0, B_Insert);
    if iStatus <> 0 then ShowMessage('Ex_StoreTrans called, Status ' + IntToStr(iStatus));
  end;

  Result := sNomRef;

  if Assigned(MyTrans) then FreeMem(MyTrans, SizeOf(MyTrans^));
  if Assigned(MyTransLines) then FreeMem(MyTransLines, SizeOf (MyTransLines^));

end;

end.
