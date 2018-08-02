unit cardproc;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  VarConst, BtrvU2, BtSupU1, GlobVar, HelpSupU, StrUtil, EXWrap1U, Dialogs, NeilProc
  {$IFNDEF VECTRONDLL}
    , APIUtil, Windows, Forms, Controls, BTKeys1U, ETDateU, FileUtil, DuffTill, MPComms
  {$ENDIF}
  ;

type
  TFormMode = (fmView, fmEdit, fmAdd);

  function PutMultiSys(bUnLock : boolean = FALSE) : boolean;
  function GetMultiSys(bWait : boolean; var bLock : boolean) : boolean;
  procedure SetRelCode(iDays : integer);
  Function CardFullName(Const CustR : CustRec; Const Inits, Tit : Boolean) : ShortString;
  function CardInits(const CustR : CustRec) : ShortString;
  function Calc_IncVAT(OrigValue : Real) : Real;
  procedure SetNextDocNos(var InvR : InvRec; SetOn : Boolean);
  function AddRecord(FileNo : Byte; var AnExLocal : TdEXLocal): boolean;
  function LockRecord(FileNo, KeyNo : Byte; var AnExLocal : TdEXLocal; bLock : boolean) : boolean;
  function SaveRecord(FileNo : Byte; var AnExLocal : TdEXLocal): boolean;
  function Calc_InvDisc(InvR : InvRec; PRata : Real) : Real;
  Function Pro_RataDisc_NoLock (OInv,IInv : InvRec): Real;
  function Full_ITotal(InvR : InvRec) : Real;
  function ITotal(InvR  :  InvRec) : Real;
  function Pro_RataDisc_NoLock1(OInv, IInv : InvRec; LCust : CustRec) : Real;
  Procedure CalcInvoiceCredits2(TheInv : InvRec; Var Debits, DrInc, CrInc, Credits, Balance : Real);

  {$IFNDEF VECTRONDLL}
    Procedure CalcInvoiceCredits(TheInv : InvRec; var Debits, Incentive, Credits, Balance : Real);
    Procedure CalcCustBals(Var TheCust : CustRec; TheInv : InvRec);
    function Get_NextTillNo(bUpdate : boolean) : Integer;
    function BestTill(iCardNo, iABSNo : integer) : byte;
    function GetNameForTill(CustR : CustRec) : String12;
    function Cust2Till(CustR : CustRec; iTillNo : byte = 0) : boolean;
    function UpdateBal(var ExLocal : TdExLocal;const Mode : Byte) : boolean;
    function Round_Up(Num : Double; Dp : Integer) : Double;
    function TrueReal(RealN : Double; Dp : Byte) : Double;
    procedure DoHoldCard(var ExLocal : TdExLocal; iNewStatus : integer; bLockRecord : boolean);
    function Pro_RataDisc (OInv, IInv : InvRec; LCust : CustRec) : Real;
    Procedure TillCommsError;
    Function GetNextCount(DocHed : DocTypes; Increment, UpLast : Boolean;
    NewValue : Real) : LongInt;
    Function Set_RunNo(bInc : boolean) : LongInt;
    Procedure Set_OSRec(Var NRunNo    :  LongInt);
    Procedure AddInvoice(var ExLocal : TdExLocal; NRunNo : LongInt; DiffBal, BallBal, GBal : Real; Var PostNet
    , PostVAT : Real; Mode : Byte; InvSource : InvSourceType);
    Procedure Cancel_Hold(var ExLocal : TdExLocal; iFileNo, iKeyNo : integer; bDummy : boolean);
    Procedure Set_CustHold(var ExLocal : TdExLocal; iNewStatus, iFileNo, iKeyNo : integer; bDummy : boolean);
    Procedure Gen_Inv(var ExLocal : TdExLocal; NRunNo : LongInt; DiffBal, BallBal, GBal : Real; Var PostNet
    , PostVAT : Real; Mode : Byte; Source : InvSourceType);
    {$IFNDEF CARDTK}
      Procedure PrintEODReports(FRunNo, LRunNo : LongInt; bPrintEODLogs, bAskReset : boolean);
    {$ENDIF}
    function SetPadNo(sString : string; iNewLength : integer): string;
    procedure SetCommsWorking(bSetTo : boolean);
    function CheckABSFree : boolean;
    procedure PutECRBal(RCust : CustRec; rNewBalance : Real; iTillNo : byte);
    function GetCustFromInv(var EXLocal : TdExLocal; FuncBook : boolean) : boolean;
    Function GetLastRunNo : LongInt;
    Function SetAppName(DocHed  :  DocTypes; RBal    :  Real)  :  Str20;
    function CardExists(sCardNo : string) : boolean;
    function CheckTillBals(CustR : CustRec) : boolean;
    function GetTransDesc(const Doc : InvRec; rDebits : real) : ShortString;
    Procedure TechSuppLog(sLine : string);
    Procedure ChangeLinks(OCode, NCode : AnyStr; Fnum : Integer; KLen : Integer; KeyPth : Integer);
    Procedure RenumberFunctions(OldCardNo, NewCardNo : AnyStr);
    Procedure DeleteLinks(OCode : AnyStr; Fnum : Integer; KLen : Integer; KeyPth : Integer);
    function BoolStr(bBool : boolean) : string;
    function CommsFailed : boolean;
    Function IncBookCount : Boolean;
    Procedure DeletePrintFile (Const PrintFile : String);
  {$ENDIF}
type
  InvRecPtr = ^InvRec;

var
  aiLockPos : array[1..MaxFiles] of Integer;
  TStatus : smallint;
  Temp : InvRecPtr;

implementation
uses
  etStrU, DLLProc, etMiscU, SysUtils
  {$IFNDEF VECTRONDLL}
    ,Comms, ExchLink, Inifiles
    {$IFNDEF CARDTK}
      , MainF, Reports
    {$ENDIF}
  {$ENDIF}
  ;

function PutMultiSys(bUnLock : boolean = FALSE) : boolean;
{saves (and unlocks) the system setup record}
var
  iStatus : smallint;
begin
  with Syss do begin
    iStatus := Put_Rec(F[SysF], SysF, RecPtr[SysF]^,0);
    if bUnLock then begin
      {Unlock Sys Record}
      UnLockMultiSing(F[SysF], SysF, aiLockPos[SysF]); {do unlock}
    end;{if}
    Report_BError(SysF,iStatus);
  end;{with}
  PutMultiSys := iStatus = 0;
end;

function GetMultiSys(bWait : boolean; var bLock : boolean) : boolean;
{reads (and locks) the system setup record}
var
  sKey : str255;
  iStatus : smallint;
begin
  with Syss do begin
    sKey := '';
    if bLock then
      begin
        GetMultiRec(B_StepFirst,B_SingLock{B_MultLock},sKey,0,SysF,bWait,bLock);{Lock Record (Multi)}
        GetPos(F[SysF],SysF,aiLockPos[SysF]);
      end
    else begin
      iStatus := Find_Rec(b_StepFirst,F[SysF],SysF,RecPtr[SysF]^,0,sKey);
      Report_BError(SysF,iStatus);
    end;{if}
  end;{with}
  Result := bLock;
end;

procedure SetRelCode(iDays : integer);
begin
  with Syss do begin
    RelDate := CalcNewRelDate(iDays);

    {* Reset Security on all versions *}
    Blank (ExSecurity, Sizeof(ExSecurity));
    Blank (ExRelease,  Sizeof(ExRelease));

    SecSet := True;
  end;{with}
end;

function CardFullName(const CustR : CustRec; const Inits, Tit : Boolean) : ShortString;
begin
  with CustR do begin
    Result := '';

    if (Trim(Company) <> '') then Result := Result + Trim(Company) + ' ';

    if Inits then Result := Result + CardInits(CustR){ Add Initials to name }
    else begin
      if (Trim(ChrisName) <> '') then Result := Result + Trim(ChrisName) + ' '
      else Result := Result + Trim(FirstName) + ' ';
    end;{if}

    if Tit and (Trim(Title) <> '') then Result := Result + ' (' + Trim(Title) + ')';
  end;{with}
end;

function CardInits(const CustR : CustRec) : ShortString;
begin
  Result := RemoveAllChars(CustR.FirstName,' ');
end;

function Calc_IncVAT(OrigValue : Real) : Real;
begin
  Calc_IncVAT := Round_Up(Round_Up(((OrigValue * igStdVATRate) / (igStdVATRate + 1)),2),2);
end;

procedure SetNextDocNos(var InvR : InvRec; SetOn : Boolean);
begin
  with InvR do begin
    OurRef := oDLL.GetNextDocNo(InvDocHed, SetOn);
    FolioNum := oDLL.GetNextFolioNo(FOL, SetOn);
  end;{with}
end;

function AddRecord(FileNo : Byte; var AnExLocal : TdEXLocal): boolean;
var
  iStatus : smallint;
begin
  with AnExLocal do iStatus := Add_Rec(F[FileNo],FileNo,LRecPtr[FileNo]^
  ,CurrKeyPath^[FileNo]); {add new Record}
  Report_BError(FileNo,iStatus);
  Result := iStatus = 0;
end;

function LockRecord(FileNo, KeyNo : Byte; var AnExLocal : TdEXLocal; bLock : boolean) : boolean;
{Locks / Unlocks a record}
type
  TempRecType = Array[1..4096] of Byte;
var
  sKey : str255;
  iStatus : smallint;
  bLocked : boolean;
  TempRec : ^TempRecType;
begin
  with AnExLocal do begin
    if bLock then
      begin
        {Lock Record}
        aiLockPos[FileNo] := LastRecAddr[FileNo];
        sKey := '';
        LSetDataRecOfs(FileNo,LastRecAddr[FileNo]); {* Retrieve record by address Preserve position *}
        iStatus := GetDirect(F[FileNo],FileNo,LRecPtr[FileNo]^,KeyNo,0); {* Re-Establish Position *}
        Report_BError(FileNo,iStatus);
        LGetMultiRec(B_GetDirect,B_SingLock{B_MultLock},sKey,KeyNo,FileNo,FALSE,bLocked);{do lock & get record}
        LockRecord := bLocked;
      end
    else begin
      {Unlock Record}
      FillChar(sKey,sizeOf(sKey),#0);

{      LSetDataRecOfs(FileNo,aiLockPos[FileNo]); {* Retrieve record by address Preserve position *}
{      Result := Find_Rec(B_Unlock,F[FileNo],FileNo,LRecPtr[FileNo]^,KeyNo,sKey) = 0; {do unlock}

      New(TempRec);
      FillChar(TempRec^,sizeof(TempRec^),#0);
      Move(aiLockPos[FileNo],TempRec^,sizeof(aiLockPos[FileNo]));
      Result := Find_Rec(B_Unlock,F[FileNo],FileNo,TempRec,KeyNo,sKey) = 0; {do unlock}
      Dispose(TempRec);
    end;{if}
  end;{with}
end;

function SaveRecord(FileNo : Byte; var AnExLocal : TdEXLocal): boolean;
var
  TmpCust : CustRec;
  TmpInv : InvRec;
  TmpGroup : GroupRecType;
  TmpItem : ItemRecType;
  iStatus : smallint;
begin
  with AnExLocal do begin
    if (LastRecAddr[FileNo] <> 0) then begin {* Re-establish position prior to storing *}

      {save original record}
      case FileNo of
        CustF : TmpCust := LCust;
        InvF : TmpInv := LInv;
        GroupF : TmpGroup := LGroupRec;
        ItemF : TmpItem := LItemRec;
      else ShowMessage('Change SaveRecord to include this file.');
      end;

      LSetDataRecOfs(FileNo,LastRecAddr[FileNo]);
      GetDirect(F[FileNo],FileNo,LRecPtr[FileNo]^,CurrKeyPath^[FileNo],0); {* Re-Establish Position *}

      {restore original record}
      case FileNo of
        CustF : LCust := TmpCust;
        InvF : LInv := TmpInv;
        GroupF : LGroupRec := TmpGroup;
        ItemF : LItemRec := TmpItem;
      end;
    end;{if}
    iStatus := Put_Rec(F[FileNo],FileNo,LRecPtr[FileNo]^,CurrKeyPath^[FileNo]);{save changes to existing record}
    LGetRecAddr(FileNo);
    Report_BError(FileNo,iStatus);
  end;{with}
  Result := iStatus = 0;
end;

function Calc_InvDisc(InvR : InvRec; PRata : Real) : Real;
begin
  Calc_InvDisc :=(Round_Up(DivWChk((InvR.InvNetVal - PRata), 1 - Pcnt(InvR.Discount))
  ,2) - (InvR.InvNetVal - PRata)) * DocCnst[InvR.InvDocHed] * DocNotCnst;
end;

Function Pro_RataDisc_NoLock (OInv,IInv : InvRec): Real;
Var
  CustBal, Rnum  :  Real;
Begin { Pro_RataDisc_NoLock }
  If (Not Syss.ODDisc) Then Begin
    { No discount on overdrawn accounts }
{    CustBal := 0.0;}
    Rnum    := 0.0;

    With Cust Do Begin
      CustBal := (CurrBalance + (Full_ITotal(OInv)*DocNotCnst));

      If (CustBal > 0.0) then Begin
        { Got some cash, so there will be some discount/incentive }
        If (CustBal > IInv.InvNetVal) then Rnum := IInv.InvNetVal
        else Rnum := CustBal;
      End; { If }
    end;

    Pro_RataDisc_NoLock := Rnum;
  End { If }
  Else
    { Always give full discount, even if overdrawn }
    Pro_RataDisc_NoLock := 0.00;
End;  { Pro_RataDisc_NoLock }

function Full_ITotal(InvR : InvRec) : Real;
begin
  Full_Itotal := ITotal(InvR) * DocCnst[InvR.InvDocHed] * DocNotCnst;
end;

function ITotal(InvR : InvRec) : Real;
begin
  Itotal := Round_Up(InvR.InvNetVal - InvR.DiscAmount,2);
end;

function Pro_RataDisc_NoLock1(OInv, IInv : InvRec; LCust : CustRec) : Real;
var
  Rnum  :  Real;
  CustBal : integer;
begin
  if (not Syss.ODDisc) then
    begin
      { No discount on overdrawn accounts }
      Rnum := 0.0;

      with LCust do begin
        CustBal := PenceIt(CurrBalance);

        if (CustBal > 0) then begin
          { Got some cash, so there will be some discount/incentive }
          if (CustBal > PenceIt(IInv.InvNetVal)) then Rnum := IInv.InvNetVal
          else Rnum := CustBal / 100;
        end;{if}
      end;{with}
      Pro_RataDisc_NoLock1 := Rnum;
    end { If }
  else Pro_RataDisc_NoLock1 := 0.00; {Always give full discount, even if overdrawn}
end;

procedure CalcInvoiceCredits2 (TheInv : InvRec; var Debits, DrInc, CrInc, Credits, Balance : Real);
{ HM 05/12/97: Added because of problems with incentive on -ve receipts }
var
  Rnum : Real;
begin { CalcInvoiceCredits2 }
  Debits  := 0.0;
  DrInc   := 0.0;
  CrInc   := 0.0;
  Credits := 0.0;
  Balance := 0.0;

  with TheInv do begin
    { Sale or specified as a separate discount }
    Rnum := InvNetVal * DocCnst [InvDocHed] * DocNotCnst;
    CrInc := ABS(DiscAmount);

    if (Rnum < 0.0) then
      begin
        Debits  := 0.0;
        Credits := ABS(Rnum);

        if (Source = isBillSplit) then begin
          { Bill Splitting Credit - incentive needs to reduce amount }
          DrInc := CrInc;
          CrInc := 0;
        end;{if}
      end{if}
    else begin
      Debits  := ABS(Rnum);
      Credits := 0.0;

      {Bill Splitting Debit - incentive needs to reduce amount}
      if (InvDocHed = NMT) and (Source <> isBillSplit) then begin
        DrInc := CrInc;
        CrInc := 0;
      end;{if}
    end;{else }

    {Balance}
    Balance := PrevBal + Debits + DrInc - Credits - CrInc;
  end;{with}
end;

{$IFNDEF VECTRONDLL}
  procedure CalcInvoiceCredits(TheInv : InvRec; var Debits, Incentive, Credits, Balance : Real);
  var
    CrInc : Real;
  begin { CalcInvoiceCredits }
    { HM 05/12/97: Modified to call CalcInvoiceCredits2 }
    CalcInvoiceCredits2 (TheInv, Debits, Incentive, CrInc, Credits, Balance);
    Incentive := Abs(Incentive) + Abs(CrInc);
  end;  { CalcInvoiceCredits }

  procedure CalcCustBals(var TheCust : CustRec; TheInv : InvRec);
  { Update Customer record with transaction changes }
  var
    Debits, DrInc, CrInc, Credits, Balance, NewBal : Real;
  begin { CalcCustBals }
    {*****************************************************}
    {**  NOTE: Partially duplicated in the EOD process  **}
    {*****************************************************}

    with TheCust do begin
      { Get invoice amounts }
      CalcInvoiceCredits2 (TheInv, Debits, DrInc, CrInc, Credits, Balance);

      { HM 05/12/97: Modified to handle incentive on -ve receipts }
      NewBal := -Credits - CrInc + Debits + DrInc;

      { Update Customer Balance }
      CurrBalance := Round_Up (CurrBalance + Round_Up (NewBal, 2), 2);

      { Check for VOIDS }
      if (Pos ('Voids', TheInv.TransDesc) = 1) then CSpent := Round_Up (CSpent
      - Round_Up ((Credits), 2), 2) { VOID }
      else begin
        { HM 14/09/99: Added Checks for conversion transactions }
        if (Pos ('Conversion to Split Discount', TheInv.TransDesc) = 1) then CPaid := Round_Up (CPaid
        - Round_Up (DrInc, 2), 2) { Remove discount from Paid-Ins }
        else begin
          if (Pos ('Conversion from Split Discount', TheInv.TransDesc) = 1) Then CPaid := Round_Up (CPaid
          - Round_Up (DrInc, 2), 2) { Add discount to Paid-Ins }
          else begin
            { HM 22/03/99: Modified for Bill Splitting Credits }
  {.034}    if (TheInv.Source <> isBillSplit) then CPaid := Round_Up (CPaid + Round_Up (Credits, 2), 2)
            else CSpent := Round_Up (CSpent - Round_Up (Credits, 2), 2); { HM 22/03/99: Bill Splitting Credits reduce spend }

            CSpent := Round_Up (CSpent + Round_Up (Debits, 2), 2);

            { Assign incentive where relevent }
            if (Credits <> 0.0) then begin
              { HM 22/03/99: Modified for Bill Splitting Credits }
  {.034}      if (TheInv.Source <> isBillSplit) then CPaid := Round_Up (CPaid  + Round_Up (CrInc, 2), 2) { Normal trans }
              else CSpent := Round_Up (CSpent + Round_Up (DrInc, 2), 2); { HM 22/03/99: Bill Splitting Credits affect spend }
            end;{if}

            if (Debits <> 0.0) then CSpent := Round_Up (CSpent - Round_Up (CrInc, 2) + Round_Up (DrInc, 2), 2);
          end;{if}
        end;{if}
      end;{if}
    end;{with}
    {*****************************************************}
    {***                                               ***}
    {**  NOTE: Partially duplicated in the EOD process  **}
    {***                                               ***}
    {*****************************************************}
  end; { CalcCustBals }

  function Get_NextTillNo(bUpdate : boolean) : Integer;
  {Returns next available Track No. by checking expired members then next No}
  var
    KeyS : Str255;
    iRecAddress, iCustRecAddress, iPrevKey, iNewNumber : Integer;
    bLock, bLocked : boolean;
    iTill, iStatus : smallint;
    MemSalesRec : TMemSalesRec;
    Exlocal : TdExlocal;
  begin
    iNewNumber := -1;
    Exlocal.Create;
    with ExLocal do begin

      iPrevKey := GetPosKey;
      LPresrv_BTPos(CustF, iPrevKey, F[CustF], iCustRecAddress, FALSE, FALSE);

      KeyS := '';
      iStatus := Find_Rec(B_GetGEq,F[CustF],CustF,LRecPtr[CustF]^,CustAvalK,KeyS); {Find First Expired Member}

      if (iStatus = 0) and LGetMultiRec(B_GetDirect,B_SingLock,KeyS,CustAvalK,CustF,TRUE,bLocked)
      and (bLocked) and (LCust.TillNo <> 0) then begin
        {found an expired member}
        GetPos(F[CustF],CustF,iRecAddress);
        with LCust do begin
          iNewNumber := TillNo; {save number to be reused}
          if bUpdate then begin
            TillNo := 0; {so it will no longer be used}
            UseNext := FALSE; {set reused flag}
            Status := Put_Rec(F[CustF],CustF,LRecPtr[CustF]^,CustAvalK); {save record edits}
            UnLockMultiSing(F[CustF], CustF, iRecAddress); {do unlock}
            Report_BError(CustF, iStatus); {show error}
          end;{if}
        end;{with}
      end;{if}

      if iNewNumber = -1 then begin
        {no expired members to reuse - get a new one}
        GetMultiSys(TRUE, bLock);
        iNewNumber := Syss.NGuest; {use next free id}
        if bUpdate then begin
          Inc(Syss.NGuest);
          PutMultiSys(TRUE);
        end;{if}
      end;{if}

      { Initialise Balance for Track to zero }
      If (iNewNumber > 0) Then Begin
    {    AddLogMsg('Zero Till Track: ' + Form_Int(iNewNumber,0));}

        { Reprogram All Tills }
        for iTill := 1 to Syss.NoTills do begin

          if FrmComms.WaitForMemberInfo(iTill, iNewNumber, MemSalesRec) then begin

            {blank Balance record}
            with MemSalesRec.NewBalance do begin
              Covers := '0000';
              IV := '00';
              Value := '0000000000';
              Sign := '00';
            end;{with}

            {blanks sales details including linked records & Balance}
            FrmComms.SetMemberInfo(iTill, MemSalesRec, TRUE, TRUE);
          end;{if}
        end;{for}
      End; { If }

      Get_NextTillNo := iNewNumber;

      LPresrv_BTPos(CustF, iPrevKey, F[CustF], iCustRecAddress, TRUE, TRUE);

      Destroy;
    end;{with}
  end;

  function BestTill(iCardNo, iABSNo : integer) : byte;
  {Works out the best balance from all the till balances}
  {Note : you must have filled the agBalances array before calling this}
  var
    iBestScore, iTill1, iTill2 : byte;
  begin
    {Score tills on how many other tills they match}
    with Syss do begin
      for iTill1 := 1 to NoTills do begin
        for iTill2 := 1 to NoTills do begin
          if (iTill1 <> iTill2) then begin
            if (agBalances[iTill1].Balance = agBalances[iTill2].Balance) then inc(agBalances[iTill1].Score)
            else begin
              {only 2 tills so cannot tell which till is right, and which is wrong}
              if (NoTills = 2) and (iCardNo <> -1) then begin
                AddToDuffList (iTill1, iCardNo, iABSNo, agBalances[iTill1].Balance / 100, agBalances[iTill2].Balance / 100);
              end;
            end;{if}
          end;{if}
        end;{for}
      end;{for}

      {Find the highest score}
      iBestScore := 0;
      Result := 1;
      for iTill1 := 1 to NoTills do begin
        if agBalances[iTill1].Score > iBestScore then begin
          Result := iTill1;
          iBestScore := agBalances[iTill1].Score;
        end;{if}
      end;{for}

      {Add entries to duff till list for tills that do not agree with the taken balance}
      if (NoTills > 2) and (iCardNo <> -1) then begin
        for iTill1 := 1 to NoTills do begin
          if agBalances[iTill1].Score <> iBestScore then begin
            AddToDuffList(iTill1, iCardNo, iABSNo, agBalances[iTill1].Balance / 100, agBalances[Result].Balance / 100);
          end;{if}
        end;{for}
      end;{if}
    end;{with}
  end;

  function GetNameForTill(CustR : CustRec) : String12;
  {works out the card name to send to the till}
  begin
    with CustR do begin
      if (FirstName = '') or (FirstName = '                    ') then GetNameForTill := PadString(psRight,Company,' ',12)
      else GetNameForTill := PadString(psRight,(TrimString(psRight,FirstName,' ') + ' ' + TrimString(psRight,Company,' ')),' ',12);
    end;{with}
  end;

  function Cust2Till(CustR : CustRec; iTillNo : byte = 0) : boolean;
  {sends the customer details to all the tills}
  var
    CardInfo : TCardInfo;
    sCardNo : string6;
    bCommsOK : boolean;
  begin
    bCommsOK := FALSE;
    while not bCommsOK do begin
      with CustR do begin
        if Syss.UseIssueNumbers then
          begin
            {For GUI Tills}
            if Hold = 0 then
              begin
                sCardNo := PadString(psLeft,IntToStr(IssueNumber),'0',2)
                + PadString(psLeft,TrimString(psRight,CustCode,' '),'0',4);
              end
            else sCardNo := '999999';
          end
        else begin
          {For standard tills}
          if Hold = 0 then
            begin
              if Syss.FourMbEproms then sCardNo := '1'
              else sCardNo := '0';
              sCardNo := sCardNo + PadString(psLeft,TrimString(psRight,CustCode,' '),'0',5)
            end
          else sCardNo := '199999';
        end;{if}

        CardInfo := TCardInfo.CreateFrom(PadString(psLeft,IntToStr(TillNo),'0',6)
        ,GetNameForTill(CustR),sCardNo);
        bCommsOK := FrmComms.MPComms.DoCommand(cmdSetCardInfo, iTillNo, TillNo, -1, CardInfo);
      end;{with}
    end;{while}
  end;

  function Round_Up(Num : Double; Dp : Integer) : Double;
  var
    NumStr  :  string;
    Minus   :  Boolean;
    MinCnst :  Integer;
    TRnum   :  Double;
  begin
    MinCnst := 1;
    if (Num >= MinLInt) and (Num <= MaxLInt) then begin
      Minus := (Num < 0);
      if (Minus) then MinCnst := -1;
      TRnum := TrueReal((Num - Trunc(Num)),10); {* True Real introduced here because this subtraction causing 17.325-17
                                               to equal 0.32499999998, by using truereal here to 10 dec places this error
                                               is corrected *}
      Str(Trnum:1:11, NumStr);  {* Changed back from Succ(Dp) because -0.00499 to 2 dec was working out @ -0.005 *}
      if (Length(NumStr)>=Dp + (3 + Ord(Minus))) then begin
        if (IntStr(NumStr[Dp + (3 + Ord(Minus))]) = 5) then Num := Num
        + (DivWChk(0.1,Power(10,Dp)) * MinCnst);
      end;{if}
    end;{if}
    Round_Up := TrueReal(Num,Dp);
  end;

  function UpdateBal(var ExLocal : TdExLocal; const Mode : Byte) : boolean;
  { ======= Procedure to update the Account Balances =========== }
  var
    iResult, ResBal, ChkBal, NewBal, TBal, iDCnst : Integer;
    InvR : InvRec;
    TmpCust : CustRec;
    bLock : boolean;
  begin
    Result := TRUE;
    if (Mode = 0) then
      begin
        iDCnst := 1;
        InvR := ExLocal.LInv;
      end
    else begin
      iDCnst := -1;
      InvR := ExLocal.LastInv;
    end;{if}

    with ExLocal, InvR, LCust do begin
      if LockRecord(CustF, CustCodeK, EXLocal, TRUE) then
        begin
          {$IFDEF ECR_On}

            { HM 14/09/99: Rewrote to use global function for balance/spend calculations }
            TmpCust := LCust;
            with TmpCust do begin
              CSpent      := 0.00;
              CPaid       := 0.00;
              CurrBalance := 0.00;
              CalcCustBals(TmpCust, InvR);

              { Sign depending on operation }
              CSpent      := CSpent * iDCnst;
              CPaid       := CPaid * iDCnst;
              CurrBalance := CurrBalance * iDCnst;
            end; { With TmpCust }

            { Calculate balance change }
            NewBal := PenceIt(TmpCust.CurrBalance);

            if (FrmComms.Till_OnLine(0)) then
              begin
                PrevBal := Cust.CurrBalance; {NF : should this be LCust ??? - I Daren't change it !}

                FrmComms.WaitForBalance(0, TillNo, TBal);
                TBal := TBal + NewBal;
                ChkBal := TBal;

                if (bgCommsWorking) and (InvDocHed in [NMT,SRI]) then begin {* Only Update Till if a receipt *}
                  Repeat
                    iResult := mrCancel;
                    FrmComms.SetBalance(0, TBal, TillNo, TRUE);
                    FrmComms.WaitForBalance(0, TillNo, ResBal);
                    Result := (ChkBal = ResBal);
                    if (ChkBal <> ResBal) then begin
                      iResult := MsgBox('The tills have not accepted the balance correctly for '
                      + CardFullName(LCust, TRUE, TRUE) + #13 + #13
                      + #9 + 'Correct Balance : ' + PenceToStr(ChkBal) + #13
                      + #9 + 'Actual Balance : ' + PenceToStr(ResBal) + #13 + #13
                      + 'Your tills may not be operating correctly, and may need reseting.' + #13 + #13
                      + 'Do you wish to retry sending this balance to your tills ?'
                      ,mtWarning,[mbRetry, mbCancel],mbRetry,'Till Comms Error');
                    end;{if}
                  Until iResult <> mrRetry;
                end;{if}

                if (bgCommsWorking) then
                  begin
                    { Update balance on card record }
                    CurrBalance:=Round_Up(CurrBalance + (NewBal / 100),2);

                    { Update spends }
                    CSpent := CSpent + TmpCust.CSpent;
                    CPaid  := CPaid  + TmpCust.CPaid;

                    {update balls and stuff}
                    BBallBal := BBallBal + BBalls;
                    GuestBal := GuestBal + BGuestBal;

                    EODFlg := FALSE; {* Reset this after each update *}

                    { HM 29/01/99: Enabled memory for 0.0 as well }
                    LastDisc := Discount;

                    {$IFDEF CS}
                      ChangeFlag := 3;
                      if (not Syss.UpWrite) then begin
                        bLock := TRUE;
                        GlobLocked := GetMultiSys(TRUE, bLock);
                        Syss.UpWrite := TRUE;
                        PutMultiSys(TRUE);
                      end;{if}
                    {$ENDIF}
                  {$IFDEF ECR_On}

                    { Cancel Hold On Receipt if credit allowed or card in credit }
                    if (Hold = 1) and ((CurrBalance <= 0) or AllowCredit) then DoHoldCard(ExLocal,0,FALSE)
                    else begin
                      if (Hold = 0) and ((CurrBalance > 0) and (not AllowCredit)) then DoHoldCard(ExLocal,1,FALSE) {* Set Hold on +ve Balance *}
                      else begin
                        { Individually place on hold Proshop & reservations office *}
                        If ((BBallBal > DRLimit) and (BBallBal > Syss.DefDrLimit)) then DoHoldCard(ExLocal,3,FALSE);
                        If ((GuestBal > GuestLimit) and (GuestBal > Syss.DefGuLimit)) then DoHoldCard(ExLocal,4,FALSE);
                      end;{if}
                    end;{if}
                  {$ENDIF}
                  end
                else Result := FALSE;

                if (InvDocHed in [SOA]) and (TransDate > OrdDate) and (bgCommsWorking) then OrdDate := TransDate;
              end
            else begin
  {NF: SHOULD THIS BE HERE ???????????????}
  (*            if (SBSIn) then begin
                {* Force the balance thru here... *}
                CurrBalance := Round_Up(CurrBalance + (NewBal / 100),2);
                {$IFDEF CS}
                  ChangeFlag := 3;
                  if (not Syss.UpWrite) and (LCust.CSRecNo <> 0) then begin
                    bLock := TRUE;
                    GlobLocked := GetMultiSys(TRUE, bLock);
                    Syss.UpWrite := TRUE;
                    PutMultiSys(TRUE);
                  end;{if}
                {$ENDIF}
              end;{if}*)
              Result := FALSE;
            end;{if}
            if Result then Result := SaveRecord(CustF, ExLocal);
            LockRecord(CustF, CustCodeK, EXLocal, FALSE);
          {$ENDIF}
        end
      else Result := FALSE;
    end;{with}
  end;

  function TrueReal(RealN : Double; Dp : Byte) : Double;
  var
    TmpStr   :  string;
    Chk      :  Integer;
    TmpReal  :  Double;
  begin
    Str(RealN:1:Dp,TmpStr);
    Val(TmpStr, TmpReal, Chk);
    TrueReal := TmpReal;
  end;

  procedure DoHoldCard(var ExLocal : TdExLocal; iNewStatus : integer; bLockRecord : boolean);
  var
    iBalance : integer;
  begin
    with ExLocal, LCust do begin

      if (not bLockRecord) or (LockRecord(CustF, CustCodeK, EXLocal, TRUE)) then begin

{        if (iNewStatus = 0) and (LCust.TillNo = 0) then LCust.TillNo := Get_NextTillNo(TRUE);}

        if (iNewStatus = 2) then
          begin
            if LCust.TillNo = 0 then iBalance := 0
            else begin
              if FrmComms.WaitForBalance(0, TillNo, iBalance) then
                begin
                  if iBalance <> 0 then MsgBox('This membership cannot be expired as the balance is not zero.',mtInformation,[mbOK],mbOK,'Hold Card');
                end
              else iBalance := -1;
            end;{if}
          end
        else iBalance := 0;

        if iBalance = 0 then begin
          {change record}
          Hold := iNewStatus;
          UseNext := iNewStatus = 2;
          if (iNewStatus = 0) and (LCust.TillNo = 0) then LCust.TillNo := Get_NextTillNo(TRUE);

          {save changes}
          SaveRecord(CustF, ExLocal);
        end;{if}
      end;{if}
    end;{with}
    Cust2Till(ExLocal.LCust); {send customer details to till}
  end;

  function Pro_RataDisc (OInv, IInv : InvRec; LCust : CustRec) : Real;
  var
    RNum : Real;
    Locked : Boolean;
    KeyS : Str255;
  begin
    RNum := 0.0;
    Locked := FALSE;
    KeyS := LCust.CustCode;
    if GetMultiRec(B_GetEq,B_SingLock,KeyS,0,CustF,TRUE,Locked) and Locked then begin
      RNum :=  Pro_RataDisc_NoLock1(OInv, IInv, LCust);
      Find_Rec(B_Unlock,F[CustF],CustF,RecPtr[CustF]^,0,KeyS);
    end; {if}
    Pro_RataDisc := Rnum;
  end;

  procedure TillCommsError;
  begin
    MsgBox('Communications to the till are not currently working.' + CHR(13)
    + 'This operation cannot be performed.',mtWarning,[mbOK],mbOK,'Till Communications');
  end;

  Function GetNextCount(DocHed : DocTypes; Increment, UpLast : Boolean;
  NewValue : Real) : LongInt;
  begin
    Result := oDLL.GetNextFolioNo(DocHed, Increment or UpLast);
  end;

  Function Set_RunNo(bInc : boolean) : LongInt;
  { Function to Return Next RunNo }
  Begin
    {$IFDEF EX_On}
      Set_RunNo:=GetNextCount(SDN,bInc,FALSE,0);
    {$ELSE}
      Set_RunNo:=Syss.DummyFolio;
      Inc(Syss.DummyFolio);
      PutMultiSys;
    {$ENDIF}
  End;

  Procedure Set_OSRec(Var NRunNo    :  LongInt);
  Const
    Fnum = InvF;
    Keypath = InvRunNoK;
  Var
    KeyS  :  Str255;
    Ok : boolean;
    iStatus : smallint;

  Begin
    Blank(KeyS,Sizeof(KeyS));
    KeyS := FullNomKey(0);
    iStatus := Find_Rec(B_GetGEq, F[Fnum], Fnum,RecPtr[Fnum]^, Keypath, KeyS);
    While (iStatus = 0) and (Inv.RunNo=0) do begin
      With Inv do Begin
        Ok := GetMultiRec(B_GetDirect, B_SingLock, KeyS, KeyPAth, Fnum, FALSE, GlobLocked);
        If (Ok) and (GlobLocked) then Begin
          RunNo := NRunNo;

          {Post to Exchequer / Enterprise}
          if syss.LinkToExch then begin
            if Source in [isEodTopup, isUnknown]
            then NomRef := oEnterprise.PostTransaction(Inv);
          end;{if}

          iStatus := Put_Rec(F[Fnum], Fnum, RecPtr[Fnum]^, Keypath);
          Report_BError(FNum, iStatus);
        end;{if}
        KeyS := FullNomKey(0);
        iStatus := Find_Rec(B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
      end;{with}
    end; {While..}
  end; {Proc..}


  Procedure Cancel_Hold(var ExLocal : TdExLocal; iFileNo, iKeyNo : integer; bDummy : boolean);
  begin
    DoHoldCard(ExLocal, 0, FALSE);
  end;

  Procedure Set_CustHold(var ExLocal : TdExLocal; iNewStatus, iFileNo, iKeyNo : integer; bDummy : boolean);
  begin
    DoHoldCard(ExLocal, iNewStatus, FALSE);
  end;

  Procedure Gen_Inv(var ExLocal : TdExLocal; NRunNo : LongInt; DiffBal, BallBal, GBal : Real; Var PostNet
  , PostVAT : Real; Mode : Byte; Source : InvSourceType);
  Begin { Gen_Inv }
    AddInvoice(ExLocal, NRunNo, DiffBal, BallBal, GBal, PostNet, PostVAT, Mode, Source);
    UpDateBal(ExLocal,0);
  End;  { Gen_Inv }

  {$IFNDEF CARDTK}
    Procedure PrintEODReports(FRunNo, LRunNo : LongInt; bPrintEODLogs, bAskReset : boolean);
    var
      bAsk : boolean;
      FileInfo : TSearchRec;
      iStatus : smallint;
      Hold : THeldCards;
      TheIniFile : TIniFile;
    Begin { PrintEODReports }

      if LRunNo < FRunNo then LRunNo := FRunNo;
      If (FRunNo = 0) Then Begin
        { Default to last run number }
        FRunNo := GetLastRunNo;
        LRunNo := FRunNo;
      end;{if}

      with ModReports do begin
        bGotPrnInfo := FALSE;
        bConsolidate := TRUE;
        { Print the Duff Tills/Cards Report }
        If (Not Syss.HideEODLog) and bPrintEODLogs Then PrintEODLogs
        else begin
          if bPrintEODLogs then PrintDuffTillLog(TRUE);
        end;{if}

        { Check the print controller is active }
        If (FRunNo > 0) And (FRunNo <= LRunNo) Then Begin
          { Print the Member Balance Posting Report report }
          SetRunNumbers(FRunNo, LRunNo);
          PrintEODPosting(FALSE);

          Hold.OnlyShowHolds := TRUE;
          For iStatus := 1 to 10 do Hold.Status[iStatus] := iStatus in [hsOverLimit, hsOnHold];
          PrintCardsOnHold(Hold, TRUE);

          if Syss.PrnGrSales then PrintGroupSales;
        End; { If }

        {print Open Tables report}
        if Syss.EODShowTableRep then begin
          TheIniFile := TIniFile.Create(sEXEDir + 'FUNCBOOK.INI');
          with TheIniFile do begin
            SetRunNumbers(StrToIntDef(ReadString('OpenTablesReport','StartNo','1'), 1)
            , StrToIntDef(ReadString('OpenTablesReport','EndNo','50'), 50));
            PrintOpenTables(ReadString('OpenTablesReport','HideZeros','TRUE') = 'TRUE');
            Free;
          end;{with}
        end;{if}

        bConsolidate := FALSE;

      end;{with}

      if FileExists(sDuffTillLogFile) then
        begin
          bAsk := TRUE;
          FindFirst(sDuffTillLogFile, faAnyFile, FileInfo);
          if FileInfo.Size = 0 then bAsk := FALSE;
          SysUtils.FindClose(FileInfo);
        end
      else bAsk := FALSE;

      If bAsk and bAskReset and (MsgBox('Do you want to reset the Bad Till/Card Log ?',mtConfirmation,[mbYes,mbNo]
      ,mbYes,'Reset Log') = mrYes) then DeleteFile(sDuffTillLogFile);
    End;{ PrintEODReports }
  {$ENDIF}

  function SetPadNo(sString : string; iNewLength : integer): string;
  begin
    SetPadNo := PadString(psLeft, sString, '0', iNewLength);
  end;

  procedure SetCommsWorking(bSetTo : boolean);
  begin
    bgCommsWorking := bSetTo;
    TAsyncOk := bSetTo;
    {$IFNDEF CARDTK}
      if FrmMain <> nil then begin
        if igBaudRate = 19200 then FrmMain.lCommsStatus.Caption := '19200 / '
        else FrmMain.lCommsStatus.Caption := '9600 / ';

        if bSetTo then
          begin
            FrmMain.lCommsStatus.Caption := FrmMain.lCommsStatus.Caption + 'Live'
          end
        else begin
          FrmMain.lCommsStatus.Caption := FrmMain.lCommsStatus.Caption + 'Offline'
        end;{if}
        FrmMain.ApdStatusLight1.Visible := bSetTo;
        FrmComms.ApdSLController1.Monitoring := bSetTo;
      end;{if}
    {$ENDIF}
  end;

  function CheckABSFree : boolean;
  { Returns True if > 1 abs numbers are free, and displays warning messages when 50, 25, 10..1 abs are left      }
  var
    sCaption : string;
    iNumbersFree : Integer;
    bLock : boolean;
  Begin
    { Calculate the number of free card numbers left }
    bLock := FALSE;
    GetMultiSys(FALSE, bLock);
    iNumbersFree := (Syss.MaxGuest - Syss.NGuest) + 1;
    if (iNumbersFree < 0) then iNumbersFree := 0;
    CheckABSFree := (iNumbersFree > 0);

    if (iNumbersFree <= 50) {and (not SBSSpecialIn)} then begin
      if (iNumbersFree in [0..10, 15, 20, 25, 30, 40, 50]) then begin
        TechSuppLog('Free ABS Warning - ' + Form_Int(iNumbersFree,0) + ' Absolute Numbers Free');
        case iNumbersFree of
          0 : begin { Totally Stuffed - no card numbers available }
            sCaption := 'Your tills have run out of space to store additional cards.'
            + CHR(13) + 'Please call Technical Support immediately.'
            + CHR(13) + 'No cards can be added until this has been corrected.';
          end;

          1..50 : begin { Stuffing is imminent }
            sCaption := 'Your tills are running out of space to store additional cards.'
            + CHR(13) + 'Please call Technical Support immediately.'
            + CHR(13) + 'Only ' + IntToStr(iNumbersFree) + ' more card';
            if (iNumbersFree > 1) then sCaption := sCaption + 's';
            sCaption := sCaption + ' can be added.';
          end;
        end;{case}
        MsgBox(sCaption, mtWarning, [mbOK], mbOK, 'Till space warning');
      end;{if}
    end;{if}
  end;

  Procedure AddInvoice(var ExLocal : TdExLocal; NRunNo : LongInt; DiffBal, BallBal, GBal : Real; Var PostNet
  , PostVAT : Real; Mode : Byte; InvSource : InvSourceType);
  Const
    Fnum     =  InvF;
    Keypath  =  InvOurRefK;
  Var
    OInv  :  InvRec;
    iStatus : smallint;
  Begin { AddInvoice }
    PostNet:=0;
    PostVAT:=0;
    With Inv do Begin
      ResetRec(Fnum);
      Source := InvSource;
      OInv:=Inv;
      Case Mode of
        1,2 : begin
          If (Syss.VatMode = vmAdv) then InvDocHed:=NMT
          else InvDocHed:=SRI;
        end;{if}

        3,4 : InvDocHed := NMT;   { Club 2000 Import }

        { Club 2000 Renewal }
        11 : Begin
          InvDocHed := NMT;
          Mode := 1;
        End;

        else InvDocHed:=SOA;   { Eod }
      end; {Case..}

      TransDate := Today;
      CustCode:=ExLocal.LCust.CustCode;
      PrevBal:=ExLocal.LCust.CurrBalance;
      RunNo:=NRunNo;
      {$IFDEF Ex_On}
        SetNextDocNos(Inv,TRUE);
      {$ELSE}
        FolioNum:=Syss.Dummyfolio;
        Inc(Syss.DummyFolio);
        PutMultiSys;
        OurRef:=DocCodes[InvDocHed]+SetPAdNo(IntToStr(FolioNum),6);
      {$ENDIF}

      InvNetVal:=DiffBal;
      If (Mode In [1..4]) Then Begin
        If (Mode In [1, 2]) Then
          PayType:=PayTypes[2]  { Renewal }
        Else
          PayType:=PayTypes[1]; { Cash? }

        If (Not Syss.UseSplDisc) And (Not (Mode In [2, 4])) Then
          { Using Incentive on receipts }
          If (Cust.LastDisc <> 0) And (Not Syss.UseMarkup) then
            Discount:=Cust.LastDisc
          else
            Discount:=Syss.Markup
        Else
          { Using Split Disccounts - no incentive on receipts }
          { or no disccount allowed on the receipt            }
          Discount := 0.0;

        DiscAmount:=Calc_InvDisc(Inv,Pro_RataDisc(OInv,Inv,ExLocal.LCust));
      End { If }
      Else Begin
        BBalls:=BallBal;
        BGuestBal:=GBal;
        If (Syss.VatMode = vmAdv) Then Begin

          (* removed, as it is doing nothing !

          If (Syss.VatMode = vmAdv) Then Begin
            If (Not Syss.UseSplDisc) Then
              { Using Incentive on receipts }
              If (Cust.LastDisc <> 0) And (Not Syss.UseMarkup) then
                MDisc:=Cust.LastDisc
              else
                MDisc:=Syss.Markup
            Else
              { Using Split Disccounts - no incentive on receipts }
              MDisc := 0.0; *)

          PostNet:=Round_Up(InvNetVal,2);
          DiscSpent:=InvNetVal-PostNet;
          InvVAT:=Calc_IncVAT(PostNet);
          PostVAT:=InvVAT;
        End; { If }
      End; { Else }

      { Add Invoice }
      Temp := InvRecPtr(RecPtr[Fnum]);
      iStatus := Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);
      Report_BError(FNum, iStatus);
      ExLocal.LGetRecAddr(Fnum);
      ExLocal.AssignFromGlobal(Fnum);
    End; {With..}
  End;  { AddInvoice }

  procedure PutECRBal(RCust : CustRec; rNewBalance : Real; iTillNo : byte);
  begin
    FrmComms.SetBalance(iTillNo, Round(rNewBalance * 100), RCust.TillNo, TRUE);
  end;

  function GetCustFromInv(var EXLocal : TdExLocal; FuncBook : boolean) : boolean;
  const
    Keypath = CustCodeK;
  var
    KeyS : str255;
    iStatus : smallint;
  begin
    with ExLocal do begin
      if FuncBook then KeyS := PadString(psRight,LInv.FBookCust,' ',CardKeyLen)
      else KeyS := PadString(psRight,LInv.CustCode,' ',CardKeyLen);
      iStatus := Find_Rec(B_GetEq, F[CustF],CustF,LRecPtr[CustF]^,Keypath,KeyS);
      LGetRecAddr(CustF);
      Result := iStatus = 0;
      if iStatus <> 9 then Report_BError(CustF, iStatus);
    end;{with}
  end;

  Function GetLastRunNo : LongInt;
  { Function to return last used Run No }
  Begin
    {$IFDEF EX_On}
      GetLastRunNo := GetNextCount(SDN, FALSE, FALSE, 0) - 1;
    {$ELSE}
      GetLastRunNo := Syss.DummyFolio - 1;
    {$ENDIF}
  End;

  Function SetAppName(DocHed  :  DocTypes; RBal    :  Real)  :  Str20;
  { ===== Function to Return Appropriate paying in mode depandant on sign ===== }
  Var
    TName   :   Str20;
  Begin
    TName:=DocNames[DocHed];
    Case DocHed of
      NMT  :  If (RBal*DocCnst[DocHed]<=0) then TName:=DocNames[SOA];
      SOA  :  If (RBal*DocCnst[DocHed]>=0) then TName:=DocNames[NMT];
      SRI  :  If (RBal*DocCnst[DocHed]<=0) then TName:=DocNames[SOA];
    end; {Case..}
    SetAppName:=TName;
  end; {Func..}

  function CardExists(sCardNo : string) : boolean;
  var
    KeyS : Str255;
    iStatus : smallint;
  begin
    KeyS := PadString(psRight,sCardNo,' ',CardKeyLen);
    iStatus := Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyS);
    if iStatus <> 4 then Report_BError(CustF, iStatus);
    CardExists := iStatus = 0;
  end;

  function CheckTillBals(CustR : CustRec) : boolean;
  begin
    Result := FrmComms.CheckBalsSame(CustR.TillNo);
  end;

  function GetTransDesc(const Doc : InvRec; rDebits : real) : ShortString;
  var
    TName : Str20;
  begin
    if (rDebits = 0) then TName := 'Paid In'
    else TName := 'Spend';

    case Doc.Source of
      isUnknown    : ;
      isEodSpend   : ;
      isEodVoid    : TName := 'Voids';
      isEodTopup   : TName := 'Till Topup';
      isFuncBook   : TName := TName + ' (FB)';
      isBillSplit  : TName := TName + ' (BS)';
      isEodTot     : TName := 'EOD Totals';
    end;{case}
    Result := TName;
  end;

  Procedure TechSuppLog(sLine : string);
  begin
    try
      AddLineToFile(DateToStr(Date) + ' ' + TimeToStr(now) + ' ' + sLine, sTechSupportLogFile);
    except
      on E:Exception do showmessage('TechSuppLog (' + sLine + ') : ' + E.ClassName + ' - ' + E.Message);
    end;
  end;

  Procedure ChangeLinks(OCode, NCode : AnyStr; Fnum : Integer; KLen : Integer; KeyPth : Integer);
  Var
    KeyS   : AnyStr;
    bOk, Locked : Boolean;
    B_Func : Integer;
    iStatus : smallint;
    OCode2 : AnyStr;
  Begin{ChangeLinks}
    KeyS:=OCode;
    B_Func:=B_GetNext;
    iStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);
    While (CheckKey(OCode,KeyS,KLen,TRUE)) and (iStatus = 0) do begin
      bOk:=GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyPth,Fnum,TRUE,Locked);
      Case Fnum of
         InvF : Begin
           Inv.CustCode:=NCode;

           { Change links for sales details }
           OCode2 := FullNomKey(Inv.FolioNum) + #0#0#0#0;
           OCode2[0] := #4;
           ChangeLinks (oCode2, NCode, SalesDetF, 4, sdFolioK);

           B_Func:=B_GetGEq;  { Cannot get next as record has been moved in index }
         end;

        SalesDetF : Begin
          SalesDetRec.sdCard := NCode;
          B_Func:=B_GetNext; { Can get next record as index position is not changed }
        End;
      end;

      If (bOk) and (Locked) then iStatus := Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPth);
      If (Debug) then Status_Means(iStatus);
      iStatus := Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);
    end;
  end;

  Procedure RenumberFunctions(OldCardNo, NewCardNo : AnyStr);
  Var
    KeyS   : AnyStr;
    bOk, Locked : Boolean;
    B_Func : Integer;
    iStatus : smallint;
    OCode2 : AnyStr;
    ExLocal : TdExLocal;
  Begin{RenumberFunctions}

    ExLocal.Create;
    ExLocal.LResetRec(InvF);

    { Build key }
    FillChar(KeyS,SizeOf(KeyS),#0);
    KeyS := 'FBK/';

    { Get first Function Booking Record record }
    iStatus := Find_Rec(B_GetGEq, F[InvF], InvF, ExLocal.LRecPtr[InvF]^, InvOurRefK, KeyS);
    ExLocal.LGetRecAddr(InvF);

    While (iStatus = 0) And (ExLocal.LInv.CustCode = FuncKey) Do begin
      With ExLocal, LInv do Begin
        FillChar(KeyS,SizeOf(KeyS),#0);
        KeyS := OurRef;

        if Trim(FBookCust) = Trim(OldCardNo) then begin
          if LockRecord(InvF, InvOurRefK, ExLocal, TRUE) then begin
            LInv.FBookCust := NewCardNo;
            SaveRecord(InvF, ExLocal);
//Showmessage('Function booking record updated');
          end;{if}
        end;{if}

        // Next Record
        iStatus := Find_Rec(B_GetNext, F[InvF], InvF, LRecPtr[InvF]^, InvOurRefK, KeyS);
        LGetRecAddr(InvF);
      end; { With }
    end;{while}
    ExLocal.Destroy;
  end;{RenumberFunctions}

  Procedure DeleteLinks(OCode : AnyStr; Fnum : Integer; KLen : Integer; KeyPth : Integer);
  Var
    KeyS   : AnyStr;
    bOk, Locked : Boolean;
    B_Func : Integer;
    iStatus : smallint;
    OCode2 : AnyStr;
  Begin
    KeyS:=OCode;
    iStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);
    While (CheckKey(OCode,KeyS,KLen,TRUE)) and (iStatus = 0) do begin
      bOk:=GetMultiRec(B_GetDirect,B_SingLock{B_MultLock},KeyS,KeyPth,Fnum,TRUE,Locked);

      if Fnum = InvF then Begin
        { Change links for sales details }
        OCode2 := FullNomKey(Inv.FolioNum) + #0#0#0#0;
        OCode2[0] := #4;
        DeleteLinks (oCode2, SalesDetF, 4, sdFolioK);
      end;

      {delete record}
      If (bOk) and (Locked) then iStatus := Delete_Rec(F[FNum],FNum,KeyPth);
      Report_Berror(FNum, iStatus);

      { Cannot get next as record has been moved in index }
      B_Func:=B_GetGEq;

      iStatus := Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);
      If (Debug) then Status_Means(iStatus);
    end;
  end;

  function BoolStr(bBool : boolean) : string;
  begin
    if bBool then Result := 'TRUE'
    else Result := 'FALSE'
  end;

  function CommsFailed : boolean;
  begin
    Result := FrmComms.bFail;
  end;

  Function IncBookCount : Boolean;
  Var
    Locked     : Boolean;
  Begin{IncBookCount}
    Locked     := TRUE; { Take local copy so that if the const changes, I don't care }
    GetMultiSys (FALSE, Locked); { re-get the sys record and lock it }

    If Locked Then
      Begin
        {update book count}
        If (Syss.BookCount < 65535) Then Inc (Syss.BookCount)
        Else Syss.BookCount := 1;

        IncBookCount := PutMultiSys;{ update database }
      End { If }
    Else IncBookCount := False;
  end;{IncBookCount}

  Procedure DeletePrintFile(Const PrintFile : String);
  Begin
    If FileExists(PrintFile) Then Begin
      Try
        DeleteFile(PrintFile);
      Except
        MessageDlg('Error:' + CHR(13) + CHR(13) + 'An error has occured deleting the temporary file, '''
        + PrintFile + '''.', mtError, [mbOk], 0);
      End;{try}
    End; { If }
  End;
{$ENDIF}

end.


