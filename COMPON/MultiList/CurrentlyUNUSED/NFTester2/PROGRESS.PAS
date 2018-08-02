unit Progress;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ETStrU
  , MPComms, SaleItem, StdCtrls, ExtCtrls, ComCtrls, EXWrap1U, VarConst, Btrvu2
  , GlobVar, CardProc, NeilProc, BTSupU1, ETDateU, ExchLink, APIUtil, StrUtil;

Const
  CM_ToSplit  = 0;
  CM_ToNormal = 1;

  procedure ReprogramTills(Const bDoDetails, bDoBalances : Boolean; aiTillsToSendTo : array of byte
  ; iProgTillNo : byte);
  procedure ProcessFunctions(iCategory : integer);
  procedure ProcessBillSplit;
  procedure SuspendCards(iNewHoldMode : byte);
  procedure SetCreditOnCards(bSetTo : boolean);
  Procedure ConvertCardBalances(Const ConvMode : Byte);

type
  TFrmProgress = class(TForm)
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    Image1: TImage;
    Label2: TLabel;
    lStatus: TLabel;
    Label1: TLabel;
    lName: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    procedure WMGetMinMaxInfo(var message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
  public

  end;

  Procedure DownLoadItems(Const iSGroup, iEGroup, iSDept, iEDept, iSPlu
  , iEPlu : LongInt; FrmProgress : TForm = nil);

implementation

uses Comms, MainF;

{$R *.DFM}


procedure TFrmProgress.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  canclose := FALSE;
end;

procedure TFrmProgress.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 298;
    ptMinTrackSize.Y := 130;
    ptMaxTrackSize.X := 298;
    ptMaxTrackSize.Y := 130;
  end;{with}
  Message.Result := 0;
  inherited;
end;

procedure ReprogramTills(Const bDoDetails, bDoBalances : Boolean; aiTillsToSendTo : array of byte
; iProgTillNo : byte);
var
  ExLocal : TdExLocal;
  FrmProgress : TFrmProgress;
  MaxRec : TMaximumsRec;

  { reinitialise tills absolute numbers to 0 }
  Procedure ReprogDetails;
  Var
    BlankCust : CustRec;
    iStatus, iPos, iStartCard : Integer;
    KeyS : Str255;
    abDone : array of boolean;
    iTill : Byte;
    iArrayLength : smallint;
  Begin{ReprogDetails}
    TechSuppLog('Reprogram Tills - Reprog Details');

    FrmProgress.lStatus.Caption := 'Reprogramming Card Details';

    { Work out where to start }
    If (ECRTillType = TillType_MP2) then
      Begin
        If Syss.FourMbEproms Then iStartCard := MP2StartTrack4Mb
        Else iStartCard := MP2StartTrack;
{        ProgressBar1.Max := ProgressBar1.Max - iStartCard + 1;  { first X tracks are skipped }
      End { If }
    Else iStartCard := 1;

    {initialise array Holding which tillNos have been reprogrammed}
    iArrayLength := StrToInt(MaxRec.Guests) + 1;
{   v5.00.002
    If not Syss.FourMbEproms Then begin
      if syss.NGuest < iArrayLength then iArrayLength := syss.NGuest + 1;
    end;{if}
    setlength(abDone,iArrayLength);

    for iPos := 0 to High(abDone) do abDone[iPos] := FALSE;

    with ExLocal do begin
     { Get first card record }
      Blank(KeyS, SizeOf(KeyS));
      iStatus := Find_Rec (B_StepFirst, F[CustF], CustF, LRecPtr[CustF]^, CustCodeK, KeyS);
      LGetRecAddr(CustF);

      {Reprogram names on all cards}
      While (iStatus = 0) Do begin
        With LCust Do Begin
          FrmProgress.lName.Caption := CardFullName(LCust, True, True);

          if TillNo > (iArrayLength - 1) then MsgBox('The Track Number (' + IntToStr(TillNo) +
          ') for this card (' + Trim(CustCode) + ') is higher than the maximum allowed number ('
          + IntToStr(iArrayLength - 1) + ')' + #13#13 + 'This card will not be programmed.'
          ,mtError,[mbOK],mbOK,'Track Number')
          else begin
            abDone[TillNo] := TRUE;
            {if Cust should be programmed}
            If (TillNo <> 0) then Begin
              For iTill := Low(aiTillsToSendTo) to High(aiTillsToSendTo) do begin
                Cust2Till(LCust, aiTillsToSendTo[iTill]);
              end;{for}
            end; { If }
          end;{if}
        end; { With }

        { Get next record }
        iStatus := Find_Rec(B_StepNext, F[CustF], CustF, LRecPtr[CustF]^, CustCodeK, KeyS);
        LGetRecAddr(CustF);

        {Update Progress Bar}
        FrmProgress.ProgressBar1.Position := FrmProgress.ProgressBar1.Position + 1;
      end;{while}
    end;{with}

    {blank till records for all cards not already programmed}

    FrmProgress.lStatus.Caption := 'Blanking Till Records';
    FrmProgress.lName.Caption := '(none)';

    { Set up a blank cust to send }
    FillChar(BlankCust, sizeOf(BlankCust),#0);
    With BlankCust do Begin
      If Syss.FourMbEproms Then
        begin
          CustCode  := '99999';
          Company   := 'RESERVED';
        end
      else begin
        CustCode  := '0';
        Company   := '';
      end;{if}
      TillNo    := 0;
      FirstName := '';
      Title     := '';
    end; { With }

    For iPos := iStartCard to {StrToInt(MaxRec.Guests)}High(abDone) do begin
      if not abDone[iPos] then begin
        BlankCust.TillNo := iPos;
        {$IFDEF ECR_On}
          For iTill := Low(aiTillsToSendTo) to High(aiTillsToSendTo) do begin
            Cust2Till(BlankCust, aiTillsToSendTo[iTill]);
          end;{if}
        {$ENDIF}

        {Update Progress Bar}
        FrmProgress.ProgressBar1.Position := FrmProgress.ProgressBar1.Position + 1;
      end;{if}
    end;{for}
    if not bDoBalances then FrmProgress.ProgressBar1.Position := FrmProgress.ProgressBar1.Max;
  end;{ReprogDetails}

  { sends the card balances to the tills }
  Procedure SendBalances;
  Var
    KeyS                           : Str255;
    BestBalance : Real;
    iPos, iTill : Byte;
    iStatus : smallint;
    MemSalesRec : TMemSalesRec;
  Begin { SendBalances }
    {$IFDEF ECR_On}
      TechSuppLog('Reprogram Tills - Card Balances');

      FrmProgress.lStatus.Caption := 'Programming Balances';

      with ExLocal do begin
        { Get first card record }
        Blank (KeyS, SizeOf(KeyS));
        iStatus := Find_Rec (B_StepFirst, F[CustF], CustF, LRecPtr[CustF]^, CustCodeK, KeyS);
        LGetRecAddr(CustF);

        While (iStatus = 0) Do begin
          With LCust Do Begin

            {update progress window}
            FrmProgress.lName.Caption := CardFullName(LCust, True, True);

            { Check cust is supposed to be on tills }
            If (TillNo<>0) then Begin

              {get balance from specified till OR customer record}
              if iProgTillNo = 0 then BestBalance := CurrBalance
              else BestBalance := FrmComms.GetTillBalance(TillNo, iProgTillNo, TRUE);

              {set balance and wipe out sales details }
              For iPos := low(aiTillsToSendTo) to High(aiTillsToSendTo) do begin
                iTill := aiTillsToSendTo[iPos];

                with FrmComms do begin
                  { Get sales details from till}
                  if WaitForMemberInfo(iTill, TillNo, MemSalesRec) then begin

                    {blanks sales details including linked records}
                    SetMemberInfo(iTill, MemSalesRec, TRUE, TRUE);

                    {sets new balance for the 1st record}
                    SetBalance(iTill, PenceIt(BestBalance), TillNo, TRUE);
                  end;{if}
                end;{with}
              end;{for}
            end; { If }
          end; { With }

          { Get next record }
          iStatus := Find_Rec(B_StepNext, F[CustF], CustF, LRecPtr[CustF]^, CustCodeK, KeyS);
          LGetRecAddr(CustF);

          {Update Progress Bar}
          FrmProgress.ProgressBar1.Position := FrmProgress.ProgressBar1.Position + 1;
        end;{while}
      end;{With}
    {$ENDIF}
    FrmProgress.ProgressBar1.Position := FrmProgress.ProgressBar1.Max;
  End;  { SendBalances }

begin{ReprogramTills}
  screen.cursor := crHourglass;
  FrmComms.MPComms.ResetBigBadErrorCount;
  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,0);
  try
    FrmProgress := TFrmProgress.Create(application);
    with FrmProgress do begin
      Caption := 'Reprogramming Tills...';
      Show;

      { Calculate number of elements to do }
      ProgressBar1.Max := 0;
      MaxRec := FrmComms.GetMaxGuests(1, TRUE);
      if bDoDetails then begin
        ProgressBar1.Max := ProgressBar1.Max + StrToInt(MaxRec.Guests);
        {if Syss.FourMbEproms then ProgressBar1.Max := ProgressBar1.Max + StrToInt(MaxRec.Guests);
        else ProgressBar1.Max := ProgressBar1.Max + Syss.NGuest;}
      end;{if}

      If bDoBalances Then ProgressBar1.Max := ProgressBar1.Max + Used_Recs(F[CustF], CustF);
      ProgressBar1.Position := 0;

      ExLocal.Create;

      { program card details }
      If bDoDetails Then ReprogDetails;

      { program card balances }
      If bDoBalances Then SendBalances;

      ExLocal.Destroy;

      Close;
    end;{with}

  finally
    FrmProgress.Release;
  end;{try}

  screen.cursor := crDefault;
  MsgBox('Till Reprogramming Complete.',mtInformation,[mbOK],mbOK,'Till Reprogram');
  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,1);
end;


Procedure DownLoadItems(Const iSGroup, iEGroup, iSDept, iEDept, iSPlu
, iEPlu : LongInt; FrmProgress : TForm = nil);
var
  bEOD : boolean;

  ProgressBar1 : TProgressBar;
  lName, lStatus : TLabel;

  procedure FindComponents;
  var
    iComp : integer;
  begin{FindComponents}
    For iComp := 0 to FrmProgress.ComponentCount - 1 do begin
      if FrmProgress.Components[iComp] is TProgressBar
      then ProgressBar1 := TProgressBar(FrmProgress.Components[iComp]);

      if (FrmProgress.Components[iComp] is TLabel)
      and (TLabel(FrmProgress.Components[iComp]).name = 'lStatus')
      then lStatus := TLabel(FrmProgress.Components[iComp]);

      if (FrmProgress.Components[iComp] is TLabel)
      and (TLabel(FrmProgress.Components[iComp]).name = 'lName')
      then lName := TLabel(FrmProgress.Components[iComp]);
    end;{for}
  end;{FindComponents}


  { Download groups }
  Procedure Groups;
  Var
    I, Added, Updated          : Integer;
    DLStatus                   : Byte;
    sGroupName : string;
  Begin { Groups }
    Added   := 0;
    Updated := 0;

    For I := iSGroup To iEGroup Do begin
      ProgressBar1.Position := ProgressBar1.Position + 1;
      With GroupRec Do Begin
        { Get the PLU }
        sGroupName := DownLoadGroup(I, DLStatus);

        { Update status counts }
        Case DLStatus Of
          DLStatus_Added   : Inc (Added);
          DLStatus_Updated : Inc (Updated);
        End; { Case }

        { Update progress screen }
        if lStatus.Caption <> 'Uploading Group' then lStatus.Caption := 'Uploading Group';
        lName.Caption := sGroupName;
      End; { With }
    end;{for}
  End;{Groups}

  Procedure Depts;
  Var
    I, Added, Updated, Skipped   : Integer;
    DLStatus                               : Byte;
    sDeptName : string;
  Begin { Depts }
    Added   := 0;
    Updated := 0;
    Skipped := 0;

    For I := iSDept To iEDept Do begin
      ProgressBar1.Position := ProgressBar1.Position + 1;
      If (I <> 100) And (I <> 200) Then begin
        With ItemRec Do Begin
          { Get the dept }
          sDeptName := DownLoadDept(I, DLStatus);

          { Update status counts }
          Case DLStatus Of
            DLStatus_Added   : Inc (Added);
            DLStatus_Updated : Inc (Updated);
            DLStatus_Skipped : Inc (Skipped);
          End; { Case }

          { Update progress screen }
          if lStatus.Caption <> 'Uploading Department' then lStatus.Caption := 'Uploading Department';
          lName.Caption := sDeptName;
        End; { With }
      end;{if}
    end;{for}
  End;{Depts}

  Procedure PLU;
  Var
    I, Added, Updated, Skipped   : Integer;
    DLStatus                              : Byte;
    sPLUName : string;
  Begin{PLU}
    Added   := 0;
    Updated := 0;
    Skipped := 0;

    For I := iSPlu To iEPlu Do begin
      ProgressBar1.Position := ProgressBar1.Position + 1;
      With ItemRec Do Begin

        { Get the PLU }
        sPLUName := DownLoadPLU(I, DLStatus);

        { Update status counts }
        Case DLStatus Of
          DLStatus_Added   : Inc (Added);
          DLStatus_Updated : Inc (Updated);
          DLStatus_Skipped : Inc (Skipped);
        End; { Case }

        { Update progress screen }
        if lStatus.Caption <> 'Uploading PLU' then lStatus.Caption := 'Uploading PLU';
        lName.Caption := sPLUName;
      End; { With }
    end;{for}
  End;{PLU}

Begin{DoDownLoad}
  screen.cursor := crHourglass;

  bEOD := FrmProgress <> nil;

  if not bEOD then SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,0);
  try
    if not bEOD then FrmProgress := TFrmProgress.Create(application);
    with FrmProgress do begin
      FindComponents;
      if not bEOD then begin
        Caption := 'Uploading Items...';
        Show;

        ProgressBar1.Max := iEGroup + iEDept + iEPlu;
        ProgressBar1.Min := iSGroup + iSDept + iSPlu;
        ProgressBar1.Position := iSGroup + iSDept + iSPlu;
      end;{if}


      lStatus.Caption := 'Uploading Saleable Items';

      { Change to till 1 }
      If FrmComms.Till_Online (1) Then ;

      If (iSGroup > 0) And (iEGroup >= iSGroup) Then Groups;
      If (iSDept > 0) And (iEDept >= iSDept) Then Depts;
      If (iSPlu > 0) And (iEPlu >= iSPlu) Then PLU;

      if not bEOD then Close;
    end;{with}
  finally
    if not bEOD then FrmProgress.Release;
  end;{try}

  screen.cursor := crDefault;

  if not bEOD then begin
    MsgBox('Upload complete.',mtInformation,[mbOK],mbOK,'UpLoad');
    SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,5);
  end;{if}
End;{DoDownLoad }

procedure ProcessFunctions(iCategory : integer);
Var
  TheKey     : Str255;
  Abort, bSkipRecord, FoundDuds  : Boolean;
  ExLocal : TdExLocal;
  iNoOfRecordsToDo, iProcessed : integer;
  iStatus : smallint;
  FrmProgress : TFrmProgress;
begin
  Screen.Cursor := crHourglass;
  FrmComms.MPComms.ResetBigBadErrorCount;
  iProcessed := 0;
{  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,0);}
  FrmMain.FrmFunctionList.Enabled := FALSE;

  ExLocal.Create;
  ExLocal.LResetRec(InvF);

  { Build key }
  TheKey := 'FBK/';

  { Count No of functions to do }
  iStatus := Find_Rec(B_GetGEq, F[InvF], InvF, ExLocal.LRecPtr[InvF]^, InvOurRefK, TheKey);
  ExLocal.LGetRecAddr(InvF);
  iNoOfRecordsToDo := 0;
  While (iStatus = 0) And (ExLocal.LInv.CustCode = FuncKey) Do begin
    inc(iNoOfRecordsToDo);
    iStatus := Find_Rec (B_GetNext, F[InvF], InvF, ExLocal.LRecPtr[InvF]^, InvOurRefK, TheKey)
  end;{while}

  try
    FrmProgress := TFrmProgress.Create(application);
    with FrmProgress do begin
      Caption := 'Processing Functions...';
      Show;
      ProgressBar1.Position := 0;
      ProgressBar1.Max := iNoOfRecordsToDo;
    end;{with}

    { Build key }
    TheKey := 'FBK/';

    { Get first Function Booking Record record }
    iStatus := Find_Rec(B_GetGEq, F[InvF], InvF, ExLocal.LRecPtr[InvF]^, InvOurRefK, TheKey);
    ExLocal.LGetRecAddr(InvF);

    Abort     := False;
    FoundDuds := False;
    While (iStatus = 0) And (ExLocal.LInv.CustCode = FuncKey) And (Not Abort) Do begin
      bSkipRecord := FALSE;
      FrmProgress.lStatus.Caption := 'Processing Card';
      FrmProgress.lName.Caption := CardFullName(ExLocal.LCust, TRUE ,TRUE);

      With ExLocal, LInv do Begin
        TheKey := OurRef;
        { Display Card Number }

        If (GetCustFromInv(EXLocal, TRUE)) and ((LCust.CurrBalance < 0) Or LCust.AllowCredit) Then
          Begin
            { Reget record an lock it }

            if (iCategory = -1) or (iCategory = ExLocal.LInv.FBookCat) then
              begin
                If LockRecord(InvF, InvOurRefK, ExLocal, TRUE) Then Begin
                  { Reset Cust code }
                  CustCode := FBookCust;

                  { Reset Dates }
                  TransDate := Today;
                  DueDate   := Today;

                  { Set Amount to -ve }
                  If (InvNetVal > 0) Then
                    InvNetVal := -InvNetVal;

                  { Set discount }
                  If Syss.UseSplDisc Then Begin
                    { Show discount in incentive column }
                    SepDisc := True;

                    { Calculate discount }
                    {DiscAmount := Calc_InvDisc (Inv, Pro_RataDisc_NoLock (OInv, Inv, CustCode));}

                    { Calc any incentive due for item }
                    DiscAmount := 0.0;
                    If (Discount <> 0.0) Then
                      { HM 22/04/99: Modified to give discount if running credit system }
                      If (LCust.CurrBalance < 0.0) Or (LCust.AllowCredit And Syss.ODDisc) Then Begin
                        { Got some credit - so will be some discount }
                        If (LCust.CurrBalance < -ABS(InvNetVal)) Or (LCust.AllowCredit And Syss.ODDisc) Then
                          { Got enough credit to cover item }
                          DiscAmount := -Round_Up (((Discount / 100) * ABS(InvNetVal)), 2)
                        Else
                          { Got enough credit for part of the item }
                          DiscAmount := -Round_Up (((Discount / 100) * Abs(LCust.CurrBalance)), 2);
                      End; { if }
                  End; { If }

                  { Do VAT Stuff }
                  {If Syss.AdvVat Then
                    InvVAT := Calc_IncVAT (InvNetVal);}

                  { Reset OurRef and FolioNum }
                  {$IFDEF Ex_On}
                    SetNextDocNos(LInv, TRUE);
                  {$ELSE}
                    FolioNum := Syss.Dummyfolio;
                    Inc (Syss.Dummyfolio);
                    PutMultiSys;
                  {$ENDIF}

                  { Reset RunNo }
                  RunNo := 0;

                  { Update customer name
                  GotoXy (6, 7);
                  With cust Do
                    GenStr := FullOName('',FirstName, ChrisName, Company,Off) + ConstStr (' ', 30);
                  Write ('Customer:    ', GenStr);}

                  { Set previous balance to customers curr balance }
                  PrevBal := LCust.CurrBalance;

                  { Update Database }
                  iStatus := Put_Rec(F[InvF], InvF, LRecPtr[InvF]^, InvOurRefK);
                  inc(iProcessed);

                  { Report any btrieve problems }
                  Report_BError(InvF, iStatus);

                  If iStatus = 0 Then Begin
                    { Update customer balances }
                    UpdateBal(ExLocal, 0);

                    {$IFDEF Ex_On}
                      LInv.InvNetVal := LInv.InvNetVal * -1;
//                      If (Syss.VatMode = vmAdv) Then
//                        OExchequer.Control_SR(LInv, FALSE, 1, Nom_Sales)  {* Add NTxFR *}
//                      Else
//                        OExchequer.Control_NT(LInv, FALSE, Nom_Sales);    {* Add NTxFR *}
                    {$ENDIF}

                    { Check till balances match ok }
                    If Not CheckTillBals(LCust) Then
                      { PANIC - One or more balances dont match }
                      Abort := MsgBox('One or more balances do not match.' + CHR(13)
                      + 'Do you wish to stop processing the bookings ?',mtWarning,[mbYes,mbNo],mbYes
                      ,'Process Functions') = mrYes;
                  End; { If }
                End; { If }
              End { If }
            else bSkipRecord := TRUE;
          End
        Else begin
          FoundDuds := True;
          bSkipRecord := TRUE;
        end;{if}

        if bSkipRecord then iStatus := Find_Rec (B_GetNext, F[InvF], InvF, LRecPtr[InvF]^, InvOurRefK, TheKey)
        else iStatus := Find_Rec(B_GetGEq, F[InvF], InvF, LRecPtr[InvF]^, InvOurRefK, TheKey);
        LGetRecAddr(InvF);
      end; { With }
      FrmProgress.ProgressBar1.Position := FrmProgress.ProgressBar1.Position + 1;
    end;{while}
    FrmProgress.ProgressBar1.Position := FrmProgress.ProgressBar1.Max;
    FrmProgress.Close;
  finally
    FrmProgress.Release;
  end;{try}

  { Display message if we ignored any overdrawn cards }
  If FoundDuds Then MsgBox('Overdrawn cards were found and ignored.',mtWarning,[mbOK],mbOK
  ,'Process Functions');

  ExLocal.Destroy;

  Screen.Cursor := crDefault;
  MsgBox('Function processing complete.' + CHR(13) + CHR(13) + 'Functions Processed : '
  + IntToStr(iProcessed),mtInformation,[mbOK],mbOK,'Process Functions');
{  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,4);}
  FrmMain.FrmFunctionList.Enabled := TRUE;
end;

procedure ProcessBillSplit;
var
  TheKey : Str255;
  iNoOfRecordsToDo, iStatus : integer;
  Abort : boolean;
  ExLocal : TdExLocal;
  FrmProgress : TFrmProgress;
begin
  screen.cursor := crHourglass;
  FrmComms.MPComms.ResetBigBadErrorCount;
{  FrmMain.FrmBillSplit.Enabled := FALSE;}
  ExLocal.Create;
  with ExLocal do begin

    {Count Records}
    TheKey := MainBillSplitK;
    iStatus := Find_Rec (B_GetGEq, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, TheKey);
    LGetRecAddr(InvF);
    iNoOfRecordsToDo := 0;
    While (iStatus = 0) And ((LInv.CustCode = MainBillSplitK) Or (LInv.CustCode = BillSplitCreditKey)) Do begin
      inc(iNoOfRecordsToDo);
      iStatus := Find_Rec (B_GetNext, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, TheKey);
      LGetRecAddr(InvF);
    end;{while}

    try
      FrmProgress := TFrmProgress.Create(application);
      with FrmProgress do begin
        Caption := 'Processing Bill Split...';
        Show;
        ProgressBar1.Position := 0;
        ProgressBar1.Max := iNoOfRecordsToDo;
      end;{with}

      { Build key }
      TheKey := MainBillSplitK;

      { Get first MAINK record }
      iStatus := Find_Rec (B_GetGEq, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, TheKey);
      LGetRecAddr(InvF);
      Abort := False;

      While (iStatus = 0) And ((LInv.CustCode = MainBillSplitK) Or (LInv.CustCode = BillSplitCreditKey)) And (Not Abort) Do begin

        FrmProgress.lStatus.Caption := 'Processing Card';
        FrmProgress.lName.Caption := CardFullName(LCust, True, True);

        { get customer for curr balance }
        If GetCustFromInv(ExLocal, TRUE) Then
          Begin
            If LockRecord(InvF, InvCustK, ExLocal, TRUE) Then Begin
              with LInv do begin
                { Reset Dates }
                TransDate := Today;
                DueDate   := Today;

                If (CustCode = MainBillSplitK) Then
                  Begin
                    { Debit -Set Amount to -ve }
                    If (InvNetVal > 0) Then InvNetVal := -InvNetVal;
                  End { If }
                Else Begin
                  { Credit }
                  DiscAmount := ABS (DiscAmount);
                  SepDisc := False;
                End; { Else }

                { Reset Cust code }
                CustCode := FBookCust;

                { Reset OurRef and FolioNum }
                {$IFDEF Ex_On}
                  SetNextDocNos (LInv, TRUE);
                {$ELSE}
                  FolioNum := Syss.Dummyfolio;
                  Inc (Syss.Dummyfolio);
                  PutMultiSys;
                {$ENDIF}

                { Reset RunNo }
                RunNo := 0;

                { Set previous balance to customers curr balance }
                PrevBal := LCust.CurrBalance;

                { Update Database }
                iStatus := Put_Rec(F[InvF], InvF, LRecPtr[InvF]^, InvCustK);

                { Report any btrieve problems }
                Report_BError(InvF, iStatus);

                If iStatus = 0 Then Begin
                  { Update customer balances }
                  UpdateBal(ExLocal, 0);

                  { Check till balances match ok - nothing we can do here if they don't }
                  If CheckTillBals(LCust) Then ;
                End; { If }
              end;{with}
            End; { If }

            TheKey := MainBillSplitK;
            iStatus := Find_Rec (B_GetGEq, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, TheKey);
            LGetRecAddr(InvF);
          End { If }
        Else Begin
          { Try to get next record }
          iStatus := Find_Rec (B_GetNext, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, TheKey);
          LGetRecAddr(InvF);
        End; { Else }
        FrmProgress.ProgressBar1.Position := FrmProgress.ProgressBar1.Position + 1;
      End;{while}
    finally
      FrmProgress.Release;
    end;{try}
{    FrmMain.FrmBillSplit.Enabled := TRUE;}
  end;{with}
  ExLocal.Destroy;
  screen.cursor := crDefault;
end;

procedure SuspendCards(iNewHoldMode : byte);
var
  ExLocal : TdExLocal;
  iStatus : smallint;
  KeyS : str255;
  FrmProgress : TFrmProgress;
begin
  screen.cursor := crHourglass;
  FrmComms.MPComms.ResetBigBadErrorCount;
  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,0);
  ExLocal.Create;

  try
    FrmProgress := TFrmProgress.Create(application);
    with FrmProgress do begin
      case iNewHoldMode of
        0 : Caption := 'Clearing holds on all cards...';
        5 : Caption := 'Suspending all cards...';
      end;{case}

      Show;
      ProgressBar1.Position := 0;
      ProgressBar1.Max := Used_Recs(F[CustF], CustF);
      FrmProgress.lStatus.Caption := 'Processing Card';
      Refresh;
    end;{with}
    { Get first record }
    Blank(KeyS,SizeOf(KeyS));
    iStatus := Find_Rec (B_GetGEq, F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK,KeyS);
    ExLocal.LGetRecAddr(CustF);

    With ExLocal, LCust Do Begin
      While (iStatus = 0) do begin
        FrmProgress.lName.Caption := CardFullName(LCust, True, True);
        FrmProgress.lName.Refresh;

        DoHoldCard(ExLocal, iNewHoldMode, TRUE);

        { Get next record }
        iStatus := Find_Rec (B_GetGretr, F[CustF], CustF, LRecPtr[CustF]^, CustCodeK, KeyS);
        LGetRecAddr(CustF);
        FrmProgress.ProgressBar1.Position := FrmProgress.ProgressBar1.Position + 1;
      end;{while}
    end;{with}
  finally
    FrmProgress.Release;
  end;{try}
  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,1);

  ExLocal.Destroy; {destroy local record instance}
  screen.cursor := crDefault;
end;

procedure SetCreditOnCards(bSetTo : boolean);
var
  ExLocal : TdExLocal;
  iStatus : smallint;
  KeyS : str255;
  FrmProgress : TFrmProgress;
begin
  screen.cursor := crHourglass;
  FrmComms.MPComms.ResetBigBadErrorCount;
  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,0); {close open windows and grey out menus}
  ExLocal.Create;

  try
    FrmProgress := TFrmProgress.Create(application);
    with FrmProgress do begin
      Caption := 'Setting Credit Status...';
      Show;
      ProgressBar1.Position := 0;
      ProgressBar1.Max := Used_Recs(F[CustF], CustF);
      FrmProgress.lStatus.Caption := 'Processing Card';
      Refresh;
    end;{with}

    { Get first record }
    Blank(KeyS,SizeOf(KeyS));
    iStatus := Find_Rec (B_GetGEq, F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK,KeyS);
    ExLocal.LGetRecAddr(CustF);

    With ExLocal, LCust Do Begin
      While (iStatus = 0) do begin
        FrmProgress.lName.Caption := CardFullName(LCust, True, True);
        FrmProgress.lName.Refresh;

        ExLocal.LCust.AllowCredit := bSetTo;

        {Save record}
        iStatus := Put_Rec(F[CustF], CustF, LRecPtr[CustF]^, CustCodeK);
        LGetRecAddr(CustF);
        Report_BError(CustF,iStatus);

        { Get next record }
        iStatus := Find_Rec (B_GetGretr, F[CustF], CustF, LRecPtr[CustF]^, CustCodeK, KeyS);
        LGetRecAddr(CustF);
        FrmProgress.ProgressBar1.Position := FrmProgress.ProgressBar1.Position + 1;
      end;{while}
    end;{with}
  finally
    FrmProgress.Release;
  end;{try}
  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,1); {ungreys menus}

  ExLocal.Destroy; {destroy local record instance}
  screen.cursor := crDefault;
end;

{ Converts the card balances to and from Split Discounting }
Procedure ConvertCardBalances (Const ConvMode : Byte);
Const
  FNum    = CustF;
  KeyPath = CustCodeK;
Var
  OInv              : InvRec;
  KeyS              : Str255;
  ProgStr : String;
  iStatus, NumRecs, RecNum   : Integer;
  ChangeAmount      : Real;
  FrmProgress : TFrmProgress;
  ExLocal : TdExLocal;
  bAdjustMade : boolean;
Begin { ConvertCardBalances }
  If bgCommsWorking And (msgBox('Are you sure you want to convert the card balances ?',mtConfirmation
  ,[mbYes,mbNo],mbNo,'Convert Balances') = mrYes) then begin

    ExLocal.Create;

    try
      FrmProgress := TFrmProgress.Create(application);
      FrmProgress.ProgressBar1.Max := FrmProgress.ProgressBar1.Max + Used_Recs(F[CustF], CustF);
      FrmProgress.ProgressBar1.Position := 1;
      with FrmProgress do begin
        Caption := 'Converting Balances...';
        Show;
      end;{with}

      { Create window }
      FrmProgress.lStatus.caption := 'Converting Card Balance';

      If (ConvMode = CM_ToSplit) Then
//        AddLogMsg ('Convert Card Balances to Split Discounting')
        TechSuppLog('Convert Card Balances to Split Discounting')
      Else
//        AddLogMsg ('Convert Card Balances to Normal Discounting');
        TechSuppLog('Convert Card Balances to Normal Discounting');

  //    ProgStr := 'Converting Balances, please wait...';
  //    GotoXY (((StaW[3] - Length (ProgStr)) Div 2), 7);
//      Write (ProgStr);

      RecNum    := 1;
      NumRecs   := Used_Recs(F[Fnum], Fnum);

      { Get first record }
      Blank(KeyS,SizeOf(KeyS));
      iStatus := Find_Rec (B_GetGEq,F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath,KeyS);
      ExLocal.LGetRecAddr(CustF);

      While (iStatus = 0) do begin
        With ExLocal, LCust Do Begin
          { Update Key for this cust }
          KeyS := CustCode;

          { Set customer name into progress }
//          ProgStr := FullOName(Title,FirstName,ChrisName,Company,On);
          FrmProgress.lName.caption := CardFullName(ExLocal.LCust, True, True);

//          BlankStr := ConstStr (' ', ((StaW [3] - Length (ProgStr)) Div 2) - 1);
          {GotoXY (((StaW[3] - Length (ProgStr)) Div 2), 3);}
          {Write (ProgStr);}
//          WriteCtrPop (3, StaW, BlankStr + ProgStr + BlankStr);

          { Set Record Number into progress }
//          ProgStr := Form_Int (RecNum, 0) + ' of ' + Form_Int (NumRecs, 0);
  //        BlankStr := ConstStr (' ', ((StaW [3] - Length (ProgStr)) Div 2) - 1);
          {GotoXY (((StaW[3] - Length (ProgStr)) Div 2), 5);
          Write (ProgStr); }
//          WriteCtrPop (5, StaW, BlankStr + ProgStr + BlankStr);

          If (CurrBalance < 0.0) Then
            { Generate an invoice for the amount conversion }
            With LInv Do Begin
              { Initialise new invoice }
              LResetRec(InvF);

              InvDocHed := NMT;
              TransDate := Today;
              CustCode := ExLocal.LCust.CustCode;

              PayType:=PayTypes[1];

              { Using Incentive on receipts }
              If (ExLocal.LCust.LastDisc <> 0) And (Not Syss.UseMarkup) then
                Discount:=ExLocal.LCust.LastDisc
              else
                Discount:=Syss.Markup;

              PrevBal:=ExLocal.LCust.CurrBalance;

              OInv := LInv;

              bAdjustMade := FALSE;

              Case ConvMode Of
                { Converting to split discounts - need to take off any remaining incentive }
                CM_ToSplit  : begin
                  DiscAmount := -((Discount / 100) * ExLocal.LCust.CurrBalance);
                  bAdjustMade := TRUE;
                  TransDesc := 'Conversion to Split Discount';
                end;

                { Converting to normal incentive - need to add incentive for current balance }
                CM_ToNormal : begin
//                  DiscAmount := Calc_InvDisc (LInv, ExLocal.LCust.CurrBalance);
//                  DiscAmount := - Calc_InvDisc (LInv, ExLocal.LCust.CurrBalance);
                  InvNetVal := - Calc_InvDisc (LInv, ExLocal.LCust.CurrBalance);
                  bAdjustMade := TRUE;
                  TransDesc := 'Conversion from Split Discount';
                end;
              End; { Case }

              { Check there is an adjustment to be made }
              If bAdjustMade Then
                { Check all the tills are working }
                If FrmComms.Till_OnLine(0) then Begin
                  { Calc advance VAT stuff }
                  If (Syss.VatMode = vmAdv) then
                    With LInv do
                      InvVAT:=Calc_IncVAT(InvNetVal);

                  {$IFDEF Ex_On}
                    SetNextDocNos(LInv,TRUE);
                  {$ELSE}
                    LInv.FolioNum:=Syss.Dummyfolio;
                    Inc(Syss.DummyFolio);
                    PutMultiSys;
                  {$ENDIF}
{
                  Case ConvMode Of
                    CM_ToSplit  : TransDesc := 'Conversion to Split Discount';
                    CM_ToNormal : TransDesc := 'Conversion from Split Discount';
                  End; { Case }

                  { Add Invoice }
                  iStatus := Add_Rec (F[InvF], InvF, LRecPtr[InvF]^, InvCustK);
                  Report_BError(InvF, iStatus);

                  If (iStatus = 0) then Begin
//                    UpdateBal(Inv,0);
                    UpdateBal(ExLocal,0);

                    {$IFDEF Ex_On}
                      { Always use Nominal Transfer as theres not VAT implications }
//                    Control_NT(LInv, False, 0);  {* Add NTxFR *}
                    {$ENDIF}
                  End; { If }
                End { If }
                Else Begin
                  { Tills not working
                  PopUp(PopGenW);
                  WriteCtrPop(1,PopGenW, '** WARNING! **');
                  WriteCtrPop(3,PopGenW, 'The receipt has not been added to the system.');
                  WriteCtrPop(5,PopGenW, UserPrompt[09]);
                  Select('',[#32,Esc,F9],Ch);
                  RmWin;}
                  MsgBox('The receipt has not been added to the system.',mtError,[mbOK],mbOK,'Recept Adding Failed');
                End; { Else }
            End; { With }

          { Update progress }
          Inc (RecNum);

          { Get next record }
          iStatus := Find_Rec (B_GetGretr, F[Fnum], Fnum, LRecPtr[Fnum]^, Keypath, KeyS);
          LGetRecAddr(CustF);

          FrmProgress.ProgressBar1.StepIt;

        End; { With }
      end;{while}
    finally
      FrmProgress.Release;
    end;{try}

    ExLocal.Destroy;

    MsgBox('Balance Conversion Complete.',mtInformation,[mbOK],mbOK,'Convert Balances');

  End; { If }
End;  { ConvertCardBalances }

end.


