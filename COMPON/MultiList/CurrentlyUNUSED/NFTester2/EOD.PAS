unit Eod;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  VarConst, GlobVar, BTSupU1, BtrvU2, ETStrU, LinkList, ExWrap1U, MPComms, Progress
  , SysUtils, NeilProc, CardProc, ETDateU, Comms, SaleItem, ExchLink, ETMiscU, Forms
  , Controls, Messages, Windows, DuffTill, BTKeys1U, Dialogs, comctrls, stdctrls
  , APIUtil, UseDLLU, StrUtil, DLLProc;

  function EndOfDay(var NRunNo : LongInt; bAuto : boolean; FrmProgress : TForm) : integer;

implementation

uses
  MainF;

function EndOfDay(var NRunNo : LongInt; bAuto : boolean; FrmProgress : TForm) : integer;
const
  Fnum     = CustF;
  Keypath  = CustCodeK;
type
  GroupArrayType = array [1..16] of GroupRecType;
  AbsCheckListType = array [1..3000] of Byte;
var
  ItemIncentive, Credits, CreditIncentive, Debits, DebitIncentive, TillBalance, TBal, BallBal, GuBal,
  rTotalCardBalances, rDiscount, PostSpend, PostNet, PostVS, PostVAT : Real;
  ItemOrder, iMaxPLU, iStatus, InvFolioNum : Integer;
  GroupArray : ^GroupArrayType;
  KeyS, InvKey : Str255;
  iTillNo, GoodTill, Retries : Byte;
  LinkList_Sales, LinkList_Topups, LinkList_Voids : TLinkList_Sales;
  EODError : TextFile;
  AbsCheck : ^AbsCheckListType;
  Abort, Locked, EODErrorFound, Ok : boolean;
  ExLocal : TdExLocal;
  MemSalesRec : TMemSalesRec;
  ProgressBar1 : TProgressBar;
  lName, lStatus : TLabel;
  aTotalisers : array of TaTransInfo;
  TotTransRec : TTotTransRec;
  EODCnt : byte;

  {$IFDEF EODTRACE}
    WriteLog : Boolean;
  {$ENDIF}

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

  procedure DisplayProgress;
  { Displays EOD windows }
  var
    MaxRec : TMaximumsRec;
  begin
    with Syss do begin
      ProgressBar1.Max := Used_Recs(F[Fnum],Fnum) + (NoTills * 10);

      if EODDLoadPLU then begin
        MaxRec := FrmComms.GetMaxGuests(1, TRUE);
        iMaxPLU := StrToInt(MaxRec.PLU);
        ProgressBar1.Max := ProgressBar1.Max + iMaxPLU;
      end;{if}

      if EODTillReps then ProgressBar1.Max := ProgressBar1.Max + (NoTills * 20);
    end;{with}
    ProgressBar1.Position := 0;
  end;

  procedure DownloadTillInfo;
  { Retrieves and Consolidates various numbers in the till }
  const
    WantSet = [12..14, 23, 35, 38, 43..48, 50..54];
    DwMsgs = 'Downloading Till Totals: ';
    BlankStr = '       ';
  var
    EODInv       : ^EodInvRec;
    iPos, iStatus : smallint;
    iTillNo : byte;

    procedure SubtractTillTots(const StartNo, EndNo : LongInt);
    const
      FNum    = InvF;
      KeyPath = InvOurRefK;
    var
      TmpEodInv : ^EodInvRec;
      KeyS      : Str255;
      Tots      : EodNumsType;
      I         : LongInt;
      iStatus : smallint;
    begin
      New (TmpEodInv);
      if (EndNo >= StartNo) then begin
        { for each run number: }
        for I := StartNo to EndNo do begin
          { Get EOD inv record }
          KeyS := EODDocName + SetPadNo (IntToStr(I),6);
          iStatus := Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

          if (iStatus = 0) and (Inv.Source = isEodTot) then begin
            { move it into correct structure }
            Move (Inv, TmpEodInv^, SizeOf (TmpEodInv^));

            { Subtract previous EOD's totals off todays }
            for Tots := Low (EodInv^.EodNums) to High (EodInv^.EodNums) do EodInv^.EodNums[Tots]
            := EodInv^.EodNums[Tots] - TmpEodInv^.EodNums[Tots];
          end;{if}
        end; { for }
      end;{if}
      Dispose (TmpEodInv);
    end;{SubtractTillTots}

    function Iif (const BoolExpr : Boolean; const IntTrue, IntFalse : Integer) : Integer;
    begin { Iif }
      if BoolExpr then Iif := IntTrue
      else Iif := IntFalse;
    end;  { Iif }

  begin{DownloadTillInfo}

    { Init EOD Invoice }
    New(EODInv);
    FillChar (EodInv^, SizeOf (EodInv^), #0);

    with EODInv^ do begin
      { Initialise Index fields }
      CustCode  := EODInvCust;
      OurRef    := EODDocName + SetPadNo (IntToStr(NRunNo),6);
      FolioNum  := GetNextCount(FOL,TRUE,FALSE,0);
      TransDate := Today;
      RunNo     := -NRunNo;
      Source    := isEodTot;

      {get all the Transaction Data per till}
      lStatus.Caption := 'Reading Totalisers';
      setlength(aTotalisers, Syss.NoTills + 1);
      For iTillNo := 1 to Syss.NoTills do begin
        FrmComms.GetAllTransData(iTillNo, TRUE, aTotalisers[iTillNo]);
        ProgressBar1.Position := ProgressBar1.Position + 10;
      end;{for}

      {calculate Totals (held in aTotalisers[0])}
      setlength(aTotalisers[0], NO_OF_TOTALISERS + 1);
      For iTillNo := 1 to Syss.NoTills do begin
        if high(aTotalisers[iTillNo]) <> -1 then begin
          For iPos := 1 to NO_OF_TOTALISERS do begin
            if iTillNo = 1 then
              begin
                aTotalisers[0][iPos].Qty := aTotalisers[iTillNo][iPos].Qty;
                aTotalisers[0][iPos].Amount := aTotalisers[iTillNo][iPos].Amount;
              end
            else begin
              aTotalisers[0][iPos].Qty := aTotalisers[0][iPos].Qty + aTotalisers[iTillNo][iPos].Qty;
              aTotalisers[0][iPos].Amount := aTotalisers[0][iPos].Amount + aTotalisers[iTillNo][iPos].Amount;
            end;{if}
          end;{for}
        end;{if}
      end;{for}

      { HM 31/01/00: Added support for mods in 4Mb discount EPROM's }
      If Syss.FourMbEproms Then
        EODCnt := 32
      Else
        EODCnt := 22;

      { EOD Counter: 22 - -4 }
      { EOD Counter indicates whether a SAM Eod has been done }
      if (Trunc(aTotalisers[0][EODCnt].Amount) <> 0) then SubtractTillTots(Trunc(aTotalisers[0][EODCnt].Amount), Pred(NRunNo)){Remove previous balances from totals}
      else begin
        TotTransRec.Qty := 0;
        TotTransRec.Amount := NRunNo;
        FrmComms.SetTransInfo(0, EODCnt, TotTransRec, TRUE);
      end;{if}

      { Net Total: 23 - Net TL }
      EODNums[enNetTl] := EODNums[enNetTl] + aTotalisers[0][Iif (Syss.FourMbEproms, 27, 23)].Amount;

      { Cash In Drawer: 43 - CashDrw }
      EODNums[enCaid] := EODNums[enCaid] + aTotalisers[0][Iif (Syss.FourMbEproms, 48, 43)].Amount;

      { Cheque In Draw: 44 - ChekDrw }
      EODNums[enCQid] := EODNums[enCQid] + aTotalisers[0][Iif (Syss.FourMbEproms, 49, 44)].Amount;

      { Card1 In Draw: 45 - Crd1Drw }
      EODNums[enCd1] := EODNums[enCd1] + aTotalisers[0][Iif (Syss.FourMbEproms, 50, 45)].Amount;

      { Card2 In Draw: 46 - Crd2Drw }
      EODNums[enCd2] := EODNums[enCd2] + aTotalisers[0][Iif (Syss.FourMbEproms, 51, 46)].Amount;

      { Card3 In Draw: 47 - Crd3Drw }
      EODNums[enCd3] := EODNums[enCd3] + aTotalisers[0][Iif (Syss.FourMbEproms, 52, 47)].Amount;

      { Card4 In Draw: 48 - Crd4Drw }
      EODNums[enCd4] := EODNums[enCd4] + aTotalisers[0][Iif (Syss.FourMbEproms, 53, 48)].Amount;

      { Topups: 50 - Topups }
      EODNums[enTopup] := EODNums[enTopup] + aTotalisers[0][Iif (Syss.FourMbEproms, 55, 50)].Amount;

      if Syss.FourMbEproms then begin
        { 1 - Non Taxable }
        EODNums[enTaxAmt0] := EODNums[enTaxAmt0] + aTotalisers[0][1].Amount;

        { 19 - -1 Discount1}
        EODNums[enTax1] := EODNums[enTax1] + aTotalisers[0][19].Amount;

        { 20 - -2 Discount2}
        EODNums[enTax2] := EODNums[enTax2] + aTotalisers[0][20].Amount;

        { 21 - -3 Discount3}
        EODNums[enTax3] := EODNums[enTax3] + aTotalisers[0][21].Amount;

        { 22 - -4 Discount4}
        EODNums[enTax4] := EODNums[enTax4] + aTotalisers[0][22].Amount;

        { 23 - -5 - Discount5}
        EODNums[enTaxAmt1] := EODNums[enTaxAmt1] + aTotalisers[0][23].Amount;

        { 24 - -6 - Discount6}
        EODNums[enTaxAmt2] := EODNums[enTaxAmt2] + aTotalisers[0][24].Amount;

        { 25 - -7 - Discount7}
        EODNums[enTaxAmt3] := EODNums[enTaxAmt3] + aTotalisers[0][25].Amount;

        { 26 - -8 - Discount8}
        EODNums[enTaxAmt4] := EODNums[enTaxAmt4] + aTotalisers[0][26].Amount;
      end; { if }

(*      { Net Total: 23 - Net TL }
      lStatus.Caption := 'Reading Net Total';
      FrmComms.WaitForTransInfo(0, Iif (Syss.FourMbEproms, 27, 23), TotTransRec);
      EODNums[enNetTl] := EODNums[enNetTl] + TotTransRec.Amount;

      { Cash In Drawer: 43 - CashDrw }
      lStatus.Caption := 'Reading Cash In Drawer';
      FrmComms.WaitForTransInfo(0, Iif (Syss.FourMbEproms, 48, 43), TotTransRec);
      EODNums[enCaid] := EODNums[enCaid] + TotTransRec.Amount;
      ProgressBar1.Position := ProgressBar1.Position + 1;

      { Cheque In Draw: 44 - ChekDrw }
      lStatus.Caption := 'Reading Cheque In Drawer';
      FrmComms.WaitForTransInfo(0, Iif (Syss.FourMbEproms, 49, 44), TotTransRec);
      EODNums[enCQid] := EODNums[enCQid] + TotTransRec.Amount;

      { Card1 In Draw: 45 - Crd1Drw }
      lStatus.Caption := 'Reading Card1 In Drawer';
      FrmComms.WaitForTransInfo(0, Iif (Syss.FourMbEproms, 50, 45), TotTransRec);
      EODNums[enCd1] := EODNums[enCd1] + TotTransRec.Amount;
      ProgressBar1.Position := ProgressBar1.Position + 1;

      { Card2 In Draw: 46 - Crd2Drw }
      lStatus.Caption := 'Reading Card2 In Drawer';
      FrmComms.WaitForTransInfo(0, Iif (Syss.FourMbEproms, 51, 46), TotTransRec);
      EODNums[enCd2] := EODNums[enCd2] + TotTransRec.Amount;

      { Card3 In Draw: 47 - Crd3Drw }
      lStatus.Caption := 'Reading Card3 In Drawer';
      FrmComms.WaitForTransInfo(0, Iif (Syss.FourMbEproms, 52, 47), TotTransRec);
      EODNums[enCd3] := EODNums[enCd3] + TotTransRec.Amount;
      ProgressBar1.Position := ProgressBar1.Position + 1;

      { Card4 In Draw: 48 - Crd4Drw }
      lStatus.Caption := 'Reading Card4 In Drawer';
      FrmComms.WaitForTransInfo(0, Iif (Syss.FourMbEproms, 53, 48), TotTransRec);
      EODNums[enCd4] := EODNums[enCd4] + TotTransRec.Amount;

      { Topups: 50 - Topups }
      lStatus.Caption := 'Reading Topups';
      FrmComms.WaitForTransInfo(0, Iif (Syss.FourMbEproms, 55, 50), TotTransRec);
      EODNums[enTopup] := EODNums[enTopup] + TotTransRec.Amount;
      ProgressBar1.Position := ProgressBar1.Position + 1;

      if Syss.FourMbEproms then begin
        { 1 - Non Taxable }
        lStatus.Caption := 'Reading Non Taxable';
        FrmComms.WaitForTransInfo(0, 1, TotTransRec);
        EODNums[enTaxAmt0] := EODNums[enTaxAmt0] + TotTransRec.Amount;

        { 19 - -1 Discount1}
        lStatus.Caption := 'Reading Discount 1';
        FrmComms.WaitForTransInfo(0, 19, TotTransRec);
        EODNums[enTax1] := EODNums[enTax1] + TotTransRec.Amount;
        ProgressBar1.Position := ProgressBar1.Position + 1;

        { 20 - -2 Discount2}
        lStatus.Caption := 'Reading Discount 2';
        FrmComms.WaitForTransInfo(0, 20, TotTransRec);
        EODNums[enTax2] := EODNums[enTax2] + TotTransRec.Amount;

        { 21 - -3 Discount3}
        lStatus.Caption := 'Reading Discount 3';
        FrmComms.WaitForTransInfo(0, 21, TotTransRec);
        EODNums[enTax3] := EODNums[enTax3] + TotTransRec.Amount;
        ProgressBar1.Position := ProgressBar1.Position + 1;

        { 22 - -4 Discount4}
        lStatus.Caption := 'Reading Discount 4';
        FrmComms.WaitForTransInfo(0, 22, TotTransRec);
        EODNums[enTax3] := EODNums[enTax4] + TotTransRec.Amount;

        { 23 - -5 - Discount5}
        lStatus.Caption := 'Reading Discount 5';
        FrmComms.WaitForTransInfo(0, 23, TotTransRec);
        EODNums[enTaxAmt1] := EODNums[enTaxAmt1] + TotTransRec.Amount;
        ProgressBar1.Position := ProgressBar1.Position + 1;

        { 24 - -6 - Discount6}
        lStatus.Caption := 'Reading Discount 6';
        FrmComms.WaitForTransInfo(0, 24, TotTransRec);
        EODNums[enTaxAmt2] := EODNums[enTaxAmt2] + TotTransRec.Amount;

        { 25 - -7 - Discount7}
        lStatus.Caption := 'Reading Discount 7';
        FrmComms.WaitForTransInfo(0, 25, TotTransRec);
        EODNums[enTaxAmt3] := EODNums[enTaxAmt3] + TotTransRec.Amount;
        ProgressBar1.Position := ProgressBar1.Position + 1;

        { 26 - -8 - Discount8}
        lStatus.Caption := 'Reading Discount 8';
        FrmComms.WaitForTransInfo(0, 26, TotTransRec);
        EODNums[enTaxAmt4] := EODNums[enTaxAmt4] + TotTransRec.Amount;
      end; { if }*)
    end; { with }

    { Store Invoice }
    Move (EodInv^, Inv, SizeOf (EodInv^));
    iStatus := Add_Rec(F[InvF], InvF, RecPtr[InvF]^, 0);
    Report_BError (InvF, iStatus);

    Dispose(EODInv);

  end;{DownloadTillInfo}

  procedure LoadGroups;
  {Loads the groups into an array for lookup during spend processing}
  var
    I : Integer;
  begin{LoadGroups}
    lStatus.Caption := 'Reading Group Information';
    for I := Low(GroupArray^) to High(GroupArray^) do begin
      if GetGroupRec(I) then GroupArray^[I] := GroupRec
      else begin
        {Initialise as a dummy}
        with GroupArray^[I] do begin
          grArrayNo := I;
          grName := 'Unknown';
          grNumber := -1;
          grDiscount := 0.0;
        end; { with }
      end;{if}
    end;{for}
  end;{LoadGroups}

  function CheckSpends : Boolean;
  {Returns true if there has been a spend on this card}
  var
    bResult : Boolean;
  begin { CheckSpends }
    with EXLocal.LCust do begin
      if not Syss.UseMemBill then bResult := (TBal <> CurrBalance) or (BallBal + GuBal <> 0)
      else begin
        { Memory Billing }
        LinkList_Sales.GetFirst;
        LinkList_Topups.GetFirst;
        LinkList_Voids.GetFirst;

        bResult := LinkList_Sales.Found or LinkList_Topups.Found or LinkList_Voids.Found
        or (Round_Up(TBal,2) <> Round_Up(CurrBalance,2)) or (Round_Up(BallBal + GuBal,2) <> 0);
      end;{if}
    end;{with}
    CheckSpends := bResult;
  end;  { CheckSpends }

  procedure AddTopup(EODRunNo : LongInt; Topup : Real);
  const
    Fnum = InvF;
  var
    OInv             :  ^InvRec;
    iStatus : smallint;
  begin { AddTopup }
    if (Topup <> 0.0) then begin
      GetMem (OInv, SizeOf (OInv^));

      with Inv do begin
        { Initialise the entire record }
        ResetRec(Fnum);
        OInv^ := Inv;

        { Set specific fields }
        Source     := isEodTopup;
        CustCode   := EXLocal.LCust.CustCode;
        TransDate  := Today;
{        RunNo      := EODRunNo;}
        RunNo      := 0;
        if (Syss.VatMode = vmAdv) then InvDocHed := SRI else InvDocHed := NMT;
        InvNetVal  := {ABS (}Topup{)}; { Credits are +ve - NF: not any more #:) .037}
        PrevBal    := EXLocal.LCust.CurrBalance;
        PayType    := PayTypes[1]; { 'A' - Cash }
        TransDesc  := Syss.TopupDesc;

        {$IFDEF Ex_On}
          SetNextDocNos(Inv,TRUE);
        {$else}
          Inv.FolioNum := Syss.Dummyfolio;
          Inc (Syss.DummyFolio);
          PutMultiSys;
        {$ENDIF}

        if (not Syss.UseSplDisc) then begin
          { Incentives on topup - not sales }
          if (EXLocal.LCust.LastDisc <> 0) and (not Syss.UseMarkup) then Discount := EXLocal.LCust.LastDisc {Use last specified rate}
          else Discount := Syss.Markup;{Use default incentive rate}

          { Calculate actual incentive given }
          SepDisc := True;
          DiscAmount := Calc_InvDisc(Inv, Pro_RataDisc_NoLock(OInv^, Inv));
        end; { if }

        if (Syss.VatMode = vmAdv) then begin
          with Inv do begin
            { MH 12/6/96: Changed cos I think its wrong }
            {PostNet   := Round_Up(InvNetVal - DiscAmount, 2);}
            PostNet   := Round_Up(InvNetVal, 2);
            DiscSpent := DiscAmount;
            InvVAT    := Calc_IncVAT(PostNet);
            PostVAT   := InvVAT;
          end; { with }
        end;{if}

        { Add Topup Invoice }
        iStatus := Add_Rec(F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath);
        Report_BError (Fnum, iStatus);

        { Notify Exchequer }
//        if (Syss.VatMode = vmAdv) then OExchequer.Control_SR(Inv, FALSE, 1, Nom_Till_Deposit)
//        else OExchequer.Control_NT(Inv, FALSE, Nom_Till_Deposit);
      end; { with }

      FreeMem (OInv, SizeOf (OInv^));
    end;{ if }
  end;{AddTopup}

  procedure AddVoid (EODRunNo : LongInt; VoidAmt  : Real);
  const
    Fnum = InvF;
  var
    iStatus : smallint;
  begin { AddVoid }
    if (VoidAmt <> 0.0) then begin
      with Inv do begin
        { Initialise the entire record }
        ResetRec(Fnum);

        { Set specific fields }
        Source     := isEodVoid;
        CustCode   := EXLocal.LCust.CustCode;
        TransDate  := Today;
{        RunNo      := EODRunNo;}
        RunNo      := 0;
        {if Syss.AdvVAT then InvDocHed := SRI else InvDocHed := NMT;}
        InvDocHed := SOA;
        InvNetVal  := -ABS (VoidAmt); { Credits are -ve by SOA }
        PrevBal    := EXLocal.LCust.CurrBalance;
        PayType    := PayTypes[1]; { 'A' - Cash }
        TransDesc  := 'Voids from till';

        {$IFDEF Ex_On}
          SetNextDocNos(Inv, TRUE);
        {$else}
          Inv.FolioNum := Syss.Dummyfolio;
          Inc (Syss.DummyFolio);
          PutMultiSys;
        {$ENDIF}

        Discount   := 0.0;
        SepDisc    := False;
        DiscAmount := 0.0;

        if (Syss.VatMode = vmAdv) Then
          begin
            PostNet := InvNetVal;
            InvVAT  := Calc_IncVAT (InvNetVal);
            PostVAT := InvVAT;
          end { if }
        else begin
          PostNet := InvNetVal;
          PostVAT := InvVAT;
        end; { else }

        { Add Void Invoice }
        iStatus := Add_Rec(F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath);
        Report_BError (FNum, iStatus);
      end; { with }
    end;{if}
  end;  { AddVoid }

  procedure AddDiscount (EODRunNo : LongInt; DiscAmt  : Real; DiscRate : Real);
  const
    Fnum = InvF;
  var
    LocalInv         :  ^InvRec;
  begin { AddDiscount }
    if (DiscAmt <> 0.0) and Syss.UseSplDisc then begin
      New (LocalInv);
      LocalInv^ := Inv;

      with Inv do begin
        { Initialise the entire record }
        ResetRec(Fnum);

        { Set specific fields }
        CustCode   := EXLocal.LCust.CustCode;
        TransDate  := Today;
        RunNo      := 0;
{        RunNo      := EODRunNo;}
        InvDocHed  := NMT;
        InvNetVal  := ABS (DiscAmt); { Credits are +ve }
        PrevBal    := EXLocal.LCust.CurrBalance;
        PayType    := PayTypes[1]; { 'A' - Cash }
        TransDesc  := 'Discount on sales';

        {$IFDEF Ex_On}
          SetNextDocNos(Inv,TRUE);
        {$else}
          Inv.FolioNum := Syss.Dummyfolio;
          Inc (Syss.DummyFolio);
          PutMultiSys;
        {$ENDIF}

        Discount   := DiscRate;
        SepDisc    := True;
        DiscAmount := DiscAmt;

        { Notify Exchequer of discount given }
{        oEnterprise.AddNMTDiscount(Inv);}
{        NomRef := oEnterprise.DoPost(NOM_SALES, Inv.OurRef, 0, - DiscAmt
        , 'CS ' + GetTransDesc(Inv, InvNetVal) + ' ' + Trim(CustCode)
        , CardFullName(Cust, True, True) + ' ' + Trim(CustCode) + ' ' + GetTransDesc(Inv, InvNetVal));}

      end; { with }

      Inv := LocalInv^;
      Dispose (LocalInv);
    end; { if }
  end;  { AddDiscount }


  procedure AddDetailLine (    CardNo      : String;
                               Folio       : LongInt;
                               RunNo       : LongInt;
                               DetType     : Char;
                               DetNo       : LongInt;
                               DetName     : String;
                               DetQuantity : Real;
                               DetValue    : Real;
                               DetDRate    : Real;
                               DetDisc     : Real;
                           var ItemOrder   : Integer;
                               CurrBalance : Real);
  var
    iStatus : smallint;
  begin { AddDetailLine }
    with SalesDetRec do begin
      sdCard     := CardNo;
      sdFolioNum := Folio;
      sdRunNo    := RunNo;
      sdDate     := Today;
      sdType     := DetType;
      sdNumber   := DetNo;
      sdName     := DetName;
      sdQuantity := DetQuantity;
      sdValue    := DetValue;
      sdDiscRate := DetDRate;
      sdDiscount := DetDisc;
      sdOrder    := ItemOrder;
      sdPrevBal  := CurrBalance;
    end; { with }

    iStatus := Add_Rec (F [SalesDetF], SalesDetF, RecPtr [SalesDetF]^, KeyPath);
    Report_BError (SalesDetF, iStatus);

    { Increment order for next record }
    Inc (ItemOrder);
  end;  { AddDetailLine }


  procedure RepHed;
  begin { RepHed }
    if (not EODErrorFound) then begin
      EODErrorFound := True;

      { Write error log header }
      try
        Writeln (EODError);
        Writeln (EODError);
        Writeln (EODError, 'EOD Error Log: ', NRunNo:0);
        Writeln (EODError);
        Writeln (EODError, ConstStr('=', 80));
      except
        on E:Exception do showmessage('EOD - RepHed : ' + E.ClassName + ' - ' + E.Message);
      end;
    end; { if }
  end;  { RepHed }


  { Loads all the guest sales info into linked lists for processing }
  procedure LoadGuestSales;
  var
    rBal : Real;

    { Retrieves and sorts Guest Sales Data for card CardNo }
    procedure ProcessCard(CardNo : Integer);
    var
      CustR : ^CustRec;
      Rate : Real;
      I : Integer;

      procedure DecodeSalesInfo;
      var
        ErrFile : TextFile;
        sGenStr : Str255;
        GenLen : Byte;
        TempFlag, I, iUnits : Integer;
        TempFlagStr : String [2];
        NumStr : String [10];
      begin
        with MemSalesRec do begin
          {Calculate Deposits from Tax3 and Tax4:}

          {Pence in hundredths held in Tax4 Quantity}
          rDiscount := 0;
          Deposits := 0.0;
          GenLen := 4;
          sGenStr := '';
          Move(MemSalesRec.TaxData[4].Qty[1], sGenStr[1], GenLen);
          sGenStr[0]:= Char(Ord(GenLen));
          iUnits := IntStr(sGenStr);
          if (iUnits > 0) then Deposits := iUnits / 100;

          {Hundreds (of pounds) held in Tax3 Quantity}
          GenLen := 2; {Sizeof(GuestBal.Tax[3].Qty);}
          sGenStr := '';
          Move(MemSalesRec.TaxData[3].Qty[5], sGenStr[1], GenLen);
          sGenStr[0] := Char(Ord(GenLen));
          iUnits := IntStr(sGenStr);
          if (iUnits > 0) then Deposits := Deposits + (iUnits * 100);

          {NF: negative topups fix (.036)}
{          ShowMessage('TaxData[4].Qty,5,2 = ' + Copy(MemSalesRec.TaxData[4].Qty,5,2));
          ShowMessage('TaxData[4].Qty = ' + MemSalesRec.TaxData[4].Qty);
          ShowMessage('Deposits Before = ' + FloatToStr(Deposits));}
          Deposits := Deposits * CalcSign(Copy(MemSalesRec.TaxData[4].Qty,5,2));
{          ShowMessage('Deposits After = ' + FloatToStr(Deposits));}

          for I := Low(MemSalesRec.Transactions) to High(MemSalesRec.Transactions) do begin
            with Transactions[I] do begin
              { Flag }
              if (Flag[1] = ':') then
                begin
                  case Flag[2] of
                    '1' : TempFlag := 101;  { ':1' = void of 1/2 dept }
                    '2' : TempFlag := 102;  { ':2' = void of 1/2 plu }
//                    else TempFlag := 0;
                  end; { Case }
                end { if }
              else begin
                { not a special case - decrypt the number }
                Move (Flag[1], TempFlagStr[1], 2);
                TempFlagStr[0] := Chr(2);
                TempFlag := IntStr(TempFlagStr);
              end; { else }

              { Check its a dept /  plu }
              if TempFlag in [1, 2, 21, 22, 41, 42, 44, 61, 62, 81, 82, 101, 102] then
                begin
                  { Set type from flag }
                  NumStr := '';
                  Case TempFlag of
                    1, 21  : begin
                               itType := siType_Dept;
                               Move(Number[3], NumStr[1], 4);
                               NumStr[0] := Chr(4);
                             end;

                    2, 22  : begin
                               itType := siType_PLU;
                               Move(Number[1], NumStr[1], 6);
                               NumStr[0] := Chr(6);
                             end;

                    { Dept Sale or Void Dept in Non-Layaway }
                    41, 61 : begin
                               if (Sign[1] = '<') Then
                                 itType := siType_DeptVoid
                               else
                                 itType := siType_Dept;

                               Move(Number[3], NumStr[1], 4);
                               NumStr[0] := Chr(4);
                             end;
                    { PLU Sale or Void PLU in Non-Layaway }
                    42, 62 : begin
                               if (Sign[1] = '<') Then
                                 itType := siType_PLUVoid
                               else
                                 itType := siType_PLU;

                               Move(Number[1], NumStr[1], 6);
                               NumStr[0] := Chr(6);
                             end;

                    { Discounts given at till }
                    44     : begin
                               itType := siType_Discount;
                             end;

                    81, 101: begin
                               itType := siType_DeptVoid;
                               Move(Number[3], NumStr[1], 4);
                               NumStr[0] := Chr(4);
                             end;

                    82, 102: begin
                               itType := siType_PLUVoid;
                               Move(Number[1], NumStr[1], 6);
                               NumStr[0] := Chr(6);
                             end;
                  end; { Case }

                  { Item }
                  itNumber := IntStr (NumStr);

                  { Quantity }
                  itQuantity := TillStrToReal(MemSalesRec.Transactions[I].Qty, MemSalesRec.Transactions[I].Sign);{itQuantity := MPReal2Real(RealStr(NumStr), 0);}

                  { Amount }
                  itAmount := TillStrToReal(MemSalesRec.Transactions[I].Value, MemSalesRec.Transactions[I].Sign);{itAmount := MPReal2Real(RealStr(NumStr), (Ord(Sign[1]) - 48));}
                end
              else begin

                if TempFlag <> 0 then begin
                  { Cannot identify the item in question }
                  itType   := '?';
                  itNumber := TempFlag;
                end;{if}

                case TempFlag of
                  0, 88 : ; // do nothing

                  8 : begin // extra discount line (thermal)
                    rDiscount := rDiscount + TillStrToReal(Value, Sign);
                  end;

                  else begin { Check its not an empty line on an MP3 }
                    try
                      AssignFile(ErrFile, 'CommErr.Log');
                      ReWrite (ErrFile);
                      WriteLn (ErrFile, 'CommsErr');
                      Writeln (ErrFile);
                      Writeln (ErrFile, 'TempFlag: ', TempFlag);
                      Writeln (ErrFile);
                      Writeln (ErrFile, 'Flag:   ', Flag);
                      Writeln (ErrFile, 'Number: ', Number);
                      Writeln (ErrFile, 'Qty:    ', Qty);
                      Writeln (ErrFile, 'Value:  ', Value);
                      Writeln (ErrFile, 'Sign:   ', Sign);
                      CloseFile(ErrFile);
                    except
                      on E:Exception do showmessage('EOD - Cannot identify the item in question : ' + E.ClassName + ' - ' + E.Message);
                    end;
                  end;
                end;{case}

              end;{if}
            end; { with }
          end;{for}
        end;{with}
      end;{DecodeSalesInfo}

    begin { ProcessCard }
      GetMem (CustR, SizeOf(CustR^));
      CustR^ := EXLocal.LCust;
      CustR^.TillNo := CardNo;

      { Get guest sales info }
      if FrmComms.WaitForMemberInfo(GoodTill, CustR^.TillNo, MemSalesRec)
      then rBal := TillStrToReal(MemSalesRec.NewBalance.Value, MemSalesRec.NewBalance.Sign)
      else rBal := 0;

      DecodeSalesInfo;

      { Process any deposits made }
      if (MemSalesRec.Deposits <> 0.0) then LinkList_Topups.AddItem ('?', 1
      , 'Deposit', 1, MemSalesRec.Deposits, 0.0);

      { Process items sold }
      for I := Low(MemSalesRec.Transactions) to High(MemSalesRec.Transactions) do begin
        with MemSalesRec.Transactions[I] do begin
          if (TrackRef <> '')
          and (itType in [siType_Dept, siType_PLU, siType_DeptVoid, siType_PLUVoid]) then
            begin

              { Get info from Saleable items database }
              case itType of
                siType_Dept, siType_DeptVoid : GetDeptRec(itNumber);
                siType_PLU, siType_PLUVoid : GetPLURec(itNumber);
              end; { Case }

              with ItemRec do begin
                { Got PLU/Dept details - check for discount }
                Rate := 0.0;

                if Syss.UseSplDisc then begin
                  { Using discounts on sales }
                  if siOverride then Rate := siDiscount{ This item has its own rate }
                  else begin
                    { Uses Group Discount }
                    if (siGroup >= 1) and (siGroup <= 16) then Rate := GroupArray^ [siGroup].grDiscount;
                  end; { if }
                end;{if}

                { Got a valid item }
                if (itNumber = Syss.TopupDept) and (itType = siType_Dept) then LinkList_Topups.AddItem (itType
                , itNumber, siName, itQuantity, itAmount, Rate){ its a topup department }
                else begin
                  if (itType In [siType_DeptVoid, siType_PLUVoid]) then
                    begin
                      { VOID }
                      if (itQuantity <> 0.0) and (itAmount <> 0.0) then
                        LinkList_Voids.AddItem (itType, itNumber, siName, itQuantity, itAmount, Rate);
                    end { if }
                  else LinkList_Sales.AddItem (itType, itNumber, siName, itQuantity, itAmount, Rate);{Must be an ordinary sale then}
                end; { if }
              end; { with }
            end { if }
          else begin
            if (ItType = siType_Discount) or ((itType = '?') and (itNumber in [8, 10{, 88}])) then
              begin
                { Discount }
                { No processing to be done in this version }
              end { if }
            else begin
              { not a Sale, Void or Discount }
              if (ItType <> #0) then begin
                RepHed;
                try
                  Writeln (EODError, 'Unknown Transaction - Card: ', EXLocal.LCust.CustCode,'  Trans Id: ', itNumber);
                except
                  on E:Exception do showmessage('EOD - ProcessCard : ' + E.ClassName + ' - ' + E.Message);
                end;
              end; { if }
            end;{if}
          end;{if}
        end;{with}
      end;{for}
      FreeMem (CustR, SizeOf(CustR^));
    end;{ProcessCard}

  begin { LoadGuestSales }
    { Clear Linked Lists for new member}
    LinkList_Sales.Clear;
    LinkList_Topups.Clear;
    LinkList_Voids.Clear;

    ProcessCard (EXLocal.LCust.TillNo);
    TBal := rBal;

(*  NF: not needed as my new structure stores all the card details in one record structure
    { Check for secondary cards }
    while (ECRO.GuestLinkNo <> 0) do begin
      TmpTillNo := ECRO.GuestLinkNo;

      { Process secondary card }
      ProcessCard (TmpTillNo);
    end; { while } *)

    { Try to match voids against sales }
    LinkList_Voids.GetFirst;
    while LinkList_Voids.Found do begin
      with LinkList_Voids.CurrItem^ do begin
        if (itIncAmount > 0.0) then begin
          { Try to find matching sale }
          Case itType of
            siType_DeptVoid : LinkList_Sales.FindItem (siType_Dept, itNumber);
            siType_PLUVoid  : LinkList_Sales.FindItem (siType_PLU, itNumber);
          end; { Case }

          if LinkList_Sales.Found then begin
            { Found a suitable sale - check amounts }
            if (LinkList_Sales.CurrItem^.itIncAmount > 0.0) then begin
              if (LinkList_Sales.CurrItem^.itIncAmount >= itIncAmount) Then
                begin
                  { Can match off this void entirely }
                  LinkList_Sales.CurrItem^.itIncAmount := LinkList_Sales.CurrItem^.itIncAmount - itIncAmount;
                  itIncAmount := 0.0;
                end { if }
              else begin
                { can partially match off this void }
                LinkList_Sales.CurrItem^.itIncAmount := 0.0;
                itIncAmount := itIncAmount - LinkList_Sales.CurrItem^.itIncAmount;
              end; { else }
            end;{if}
          end;{if}
        end; { if }
      end;{with}
      LinkList_Voids.GetNext;
    end; { while }
  end;  { LoadGuestSales }


{$IFDEF CS}
  { Set flag in sys to do export to club }
  procedure SetSysFlag;
  begin
    if (not Syss.UpWrite) and (EXLocal.LCust.CSRecNo <> 0) then begin
      GlobLocked := TRUE;
      GetMultiSys(TRUE, GlobLocked);
      Syss.UpWrite := TRUE;
      PutMultiSys;
    end; { if }
  end;
{$ENDIF}


  { HM 08/12/97: Added to correctly update the spend/paid-in totals }
  procedure UpdCustForSpend;
  var
    Debits, CrInc, Credits, Balance, DrInc :  Real;
  begin
    { Get value of invoice broken down into category }
    CalcInvoiceCredits2 (Inv, Debits, DrInc, CrInc, Credits, Balance);

    with EXLocal.LCust do begin
      CPaid := Round_Up (CPaid + Round_Up (Credits, 2), 2);
      CSpent := Round_Up (CSpent + Round_Up (Debits, 2), 2);

      { Assign incentive where relevent }
      if (Credits <> 0.0) Then CPaid := Round_Up(CPaid  + Round_Up(CrInc, 2), 2);
      if (Debits <> 0.0) Then CSpent := Round_Up(CSpent - Round_Up(CrInc, 2) + Round_Up(DrInc, 2), 2);
    end; { with }
  end;{UpdCustForSpend}


  { HM 08/12/97: Added to check for duplicate ABS Numbers }
  procedure CheckAbsDupli;
  begin
    if (EXLocal.LCust.TillNo >= Low(AbsCheck^)) and (EXLocal.LCust.TillNo <= High(AbsCheck^)) then begin
      { Check we haven't already processed this absolute number }
      if (AbsCheck^[EXLocal.LCust.TillNo] > 0) Then begin
        try
          Writeln (EODError, 'Card ', EXLocal.LCust.CustCode,' has a duplicate ABS Number, '
          ,'please contact Technical Support');
        except
          on E:Exception do showmessage('EOD - CheckAbsDupli : ' + E.ClassName + ' - ' + E.Message);
        end;
      end;{if}

      { Mark Absolute number as processed }
      AbsCheck^[EXLocal.LCust.TillNo] := 1;
    end; { if }
  end;


  {$IFDEF EODTRACE}
    procedure InitTrace;
    begin { InitTrace }
      InitTracing(20000);
      WriteLog := False;
    end; { InitTrace }

    procedure WriteCardLog;
    var
      TestF      : Text;
      ErrLogName : String[20];
      IO         : Integer;
    begin { WriteCardLog }
      { An error has occurred - write log to file }
      ErrLogName := Strip('B', [#0, ' '], EXLocal.LCust.CustCode) + '.log';

      {$I-}
      { Check to see if log file already exists - if so delete it }
      Assign (TestF, ErrLogName);
      Reset  (TestF);

      IO := IOResult;

      if (IO = 0) then begin
        { Close file }
        Close (TestF);

        { Delete it }
        Erase (TestF);
      end; { if }
      {$I+}

      if WriteLog then
        begin
          DumpTrace (ErrLogName);
          InitTrace;
        end { if }
      else ClearTracing;{ no errors - Clear the log for the next card }
    end; { WriteCardLog }
  {$ENDIF}


  procedure DownloadTillSales;
  var
    iTillNo : byte;
    aPLURec : TaPLURecs;
    aHourSalesRecs : TaHourSalesRecs;
    aClerkData : TaClerkData;
    aClerkRec : TaClerkRec;
    aCashierSales : TaCashierSales;

    procedure AddPLUData;
    var
      iPos : integer;
    begin{AddPLUData}
      for iPos := 0 to high(aPLURec) do begin
        FillChar(TillSales,sizeof(TillSales),#0);

        with aPLURec[iPos], TillSales, tsPLU do begin
          GetPLURec(StrToInt(PLU));
          tsType := 'P';
          tpGroupNo := ItemRec.siGroup;
          tpPLUNo := StrToInt(PLU);
          tpRunNo := NRunNo;
          tpTillNo := iTillNo;
          tpQty := TillStrToReal(Qty, Sign);
          tpAmount := TillStrToReal(Amount, Sign);
          tpDescription := ItemRec.siName;
          tsIndex1 := FullNomKey(tpRunNo) + CHR(tpTillNo) + CHR(tpGroupNo) + SmallIntToKey(tpPLUNo);{RunNo, TillNo, GroupNo, PLUNo}
        end;{with}
        iStatus := Add_Rec(F[TillSalesF], TillSalesF, RecPtr[TillSalesF]^, tsMainK);
        Report_BError(TillSalesF,iStatus);
      end;{for}
    end;{AddPLUData}

    procedure AddHourlyData;
    var
      iPos : integer;
    begin{AddPLUData}
      for iPos := 0 to high(aHourSalesRecs) do begin
        FillChar(TillSales,sizeof(TillSales),#0);

        with aHourSalesRecs[iPos], TillSales, tsHourly do begin
          tsType := 'H';
          thHourNo := StrToInt(Hour);
          thRunNo := NRunNo;
          thTillNo := iTillNo;
          thQty := TillStrToReal(Qty, Sign);
          thAmount := TillStrToReal(Amount, Sign);
          tsIndex1 := FullNomKey(thRunNo) + CHR(thTillNo) + CHR(thHourNo);{RunNo, TillNo, HourNo}
        end;{with}
        iStatus := Add_Rec(F[TillSalesF], TillSalesF, RecPtr[TillSalesF]^, tsMainK);
        Report_BError(TillSalesF,iStatus);
      end;{for}
    end;{AddHourlyData}

    procedure AddClerkData;
    var
      iPos : integer;
      iType : byte;
    begin{AddPLUData}
      for iPos := 1 to high(aClerkData) do begin
        For iType := 1 to 24 do begin {0.63}
          if iType in StoredClerkDataTypes then begin
            if not ((aClerkData[iPos].aData[iType].Qty = '')
            and (aClerkData[iPos].aData[iType].Amount = '')) then begin
              FillChar(TillSales,sizeof(TillSales),#0);
              with aClerkData[iPos], aData[iType], TillSales, tsClerk do begin
                tsType := 'C';
                tcClerkNo := StrToInt(Clerk);
                tcRunNo := NRunNo;
                tcDataType := StrToInt(DataType);
                tcTillNo := iTillNo;
                tcQty := TillStrToReal(Qty, Sign);
                tcAmount := TillStrToReal(Amount, Sign);
                tcDescription := TClerkRec(aClerkRec[StrToInt(Clerk)]).Name;
                tsIndex1 := FullNomKey(tcRunNo) + CHR(tcTillNo) + CHR(tcClerkNo) + CHR(tcDataType);{RunNo, TillNo, ClerkNo, DataType}
              end;{with}
              iStatus := Add_Rec(F[TillSalesF], TillSalesF, RecPtr[TillSalesF]^, tsMainK);
              Report_BError(TillSalesF,iStatus);
            end;{if}
          end;{if}
        end;{for}
      end;{for}
    end;{AddClerkData}

    procedure AddCashierSales;
    var
      iPos : integer;
      iType : byte;
      CardRec : TCardRec;
    begin{AddPLUData}
      for iPos := 1 to 10 do begin
        FrmComms.GetCardInfo(iTillNo, iPos, CardRec);
        For iType := 1 to 15 do begin
          if iType in StoredClerkDataTypes then begin
            if not ((aCashierSales[iPos].aSalesLines[iType].Qty = '')
            and (aCashierSales[iPos].aSalesLines[iType].Amount = '')) then begin
              FillChar(TillSales,sizeof(TillSales),#0);
              with aCashierSales[iPos], aSalesLines[iType], TillSales, tsClerk do begin
                tsType := 'C';
                tcClerkNo := StrToInt(CashierNo);
                tcRunNo := NRunNo;
                tcDataType := StrToInt(DataType);
                tcTillNo := iTillNo;
                tcQty := TillStrToReal(Qty, Sign);
                tcAmount := TillStrToReal(Amount, Sign);

                tcDescription := CardRec.Name;

                tsIndex1 := FullNomKey(tcRunNo) + CHR(tcTillNo) + CHR(tcClerkNo) + CHR(tcDataType);{RunNo, TillNo, ClerkNo, DataType}
              end;{with}
              iStatus := Add_Rec(F[TillSalesF], TillSalesF, RecPtr[TillSalesF]^, tsMainK);
              Report_BError(TillSalesF,iStatus);
            end;{if}
          end;{if}
        end;{for}
      end;{for}
    end;{AddClerkData}

    procedure AddTotalisers;
    var
      iPos : smallint;
    begin
      for iPos := 1 to NO_OF_TOTALISERS do begin
        if (not ((aTotalisers[iTillNo][iPos].Qty = 0) and (aTotalisers[iTillNo][iPos].Amount = 0))) then begin
          FillChar(TillSales,sizeof(TillSales),#0);
          with aTotalisers[iTillNo][iPos], TillSales, tsTrans do begin
            tsType := 'T';
            ttTillNo := iTillNo;
            ttRunNo := NRunNo;
            ttTransNo := iPos;
            ttQty := Qty;
            ttAmount := Amount;
            tsIndex1 := FullNomKey(ttRunNo) + CHR(ttTransNo) + CHR(ttTillNo);{RunNo, TransNo, TillNo}
          end;{with}
          iStatus := Add_Rec(F[TillSalesF], TillSalesF, RecPtr[TillSalesF]^, tsMainK);
          Report_BError(TillSalesF,iStatus);
        end;{if}
      end;{for}
    end;

  begin{DownloadTillSales}

    lStatus.Caption := 'Clearing Totalisers';
    lStatus.Refresh;
    if not FrmComms.ClearTransactionData(aTotalisers)
    then begin
//      Writeln(EODError, 'ClearTransactionData=FALSE'); //Log Error ?;
      MsgBox('Warning !'#13#13'Your end of day has failed.'#13#13'Please contact technical support.'
      ,mtWarning,[mbOK],mbOK,'End Of Day Failure.');
      Abort := TRUE;
    end;{if}

//    lStatus.Caption := 'Clearing Totalisers';
//    lStatus.Refresh;
//    FrmComms.ClearTransactionData(aTotalisers);

    {Added in b000.854}
    if not Abort then begin
      if (not Syss.FourMbEproms) and Syss.EODTillReps then begin
        {zero Transaction Totaliser that holds the run no (22)}
        TotTransRec.Qty := 0;
        TotTransRec.Amount := 0;
        FrmComms.SetTransInfo(0, EODCnt, TotTransRec, TRUE);
      end;{if}


      For iTillNo := 1 to Syss.NoTills do begin

        {download PLU Sales from Till}
        lStatus.Caption := 'Reading PLU Sales Data';
        lStatus.Refresh;
        if FrmComms.GetPLUSales(iTillNo, TRUE, aPLURec) and (length(aPLURec) > 0) then begin
          AddPLUData;
          lStatus.Caption := 'Clearing PLU Sales Data';
          lStatus.Refresh;
          FrmComms.ClearPLUData(iTillNo, aPLURec);
          setlength(aPLURec,0);
        end;{if}
        ProgressBar1.Position := ProgressBar1.Position + 10;

        {download Hourly Sales from Till}
        lStatus.Caption := 'Reading Hourly Sales Data';
        lStatus.Refresh;
        if FrmComms.GetHourlySales(iTillNo, TRUE, aHourSalesRecs) and (length(aHourSalesRecs) > 0) then begin
          AddHourlyData;
          lStatus.Caption := 'Clearing Hourly Sales Data';
          lStatus.Refresh;
          FrmComms.ClearHourlyData(iTillNo, aHourSalesRecs);
          setlength(aHourSalesRecs,0);
        end;{if}
        ProgressBar1.Position := ProgressBar1.Position + 2;

        {download Clerk Data from Till}
        if Syss.FourMbEproms then
          begin
            lStatus.Caption := 'Reading Clerk Data';
            lStatus.Refresh;
            if FrmComms.GetClerkData(iTillNo, TRUE, aClerkData)
            and FrmComms.GetClerkRec(1, TRUE, aClerkRec) and (length(aClerkData) > 0)
            and (length(aClerkRec) > 0) then begin
              AddClerkData;
              lStatus.Caption := 'Clearing Clerk Data';
              lStatus.Refresh;
              FrmComms.ClearClerkData(iTillNo);
              setlength(aClerkData,0);
              setlength(aClerkRec,0);
            end;{if}
          end
        else begin
          lStatus.Caption := 'Reading Cashier Data';
          lStatus.Refresh;
          if FrmComms.GetCashierSales(iTillNo, aCashierSales) and (length(aCashierSales) > 0) then begin
            AddCashierSales;
            lStatus.Caption := 'Clearing Cashier Data';
            lStatus.Refresh;
            FrmComms.ClearCashierData(iTillNo, aCashierSales);
          end;{if}
        end;{if}
        ProgressBar1.Position := ProgressBar1.Position + 6;

        if high(aTotalisers[iTillNo]) <> -1 then AddTotalisers;
        ProgressBar1.Position := ProgressBar1.Position + 2;
      end;{for}
    end;{if}
  end;{DownloadTillSales}

  function AllNomsExist : boolean;
  const
    iNoOfNomsToCheck = 7;
    aNomsToCheck :  Array[1..iNoOfNomsToCheck] of Byte = (NOM_CARD, NOM_CASH, NOM_CORRECTION
    , NOM_FORFEIT, NOM_DISCOUNT, NOM_TILL_DEPOSIT, NOM_SALES);
  var
    GLCodeRec : TBatchNomRec;
    pKey : PChar;
    iPos, iStatus : SmallInt;
  begin
    Result := TRUE;
    pKey := StrAlloc(255);

    For iPos := 1 to iNoOfNomsToCheck do begin
      StrPCopy(pKey, IntToStr(Syss.CNoms[aNomsToCheck[iPos]]));
      iStatus := EX_GETGLACCOUNT(@GLCodeRec, SizeOf(GLCodeRec),pKey,0,B_GetEq,FALSE);
      if iStatus <> 0 then Result := FALSE;
    end;{for}

    StrDispose(pKey);
  end;

  function CCDeptOK : boolean;
  Var
    iPos, ExStat  :  Integer;
    pCode      :  PChar;
//    sDesc, sCCDept : string;
    MyCCDep        :  TBatchCCDEpRec;
    aCodes : Array[0..1] of string3;
  begin
    Result := TRUE;
    pCode := StrAlloc (255);
    aCodes[0] := Syss.DefaultCC;
    aCodes[1] := Syss.DefaultDept;

    For iPos := 0 to 1 do begin
      StrPCopy(pCode, aCodes[iPos]);
      ExStat := Ex_GetCCDep(@MyCCDep, SizeOf(MyCCDep), pCode, 0, B_GetEq, iPos, FALSE);
      if ExStat <> 0 then Result := FALSE;
    end;{for}

    StrDispose (pCode);
  end; {proc..}

  Procedure StoreCardBalancesTotal;
  begin{StoreCardBalancesTotal}
    FillChar(TillSales,sizeof(TillSales),#0);
    with TillSales, tsTrans do begin
      tsType := 'T';
      ttTillNo := 0;
      ttRunNo := NRunNo;
      ttTransNo := 1;
      ttQty := 0;
      ttAmount := rTotalCardBalances;
      tsIndex1 := FullNomKey(ttRunNo) + CHR(ttTransNo) + CHR(ttTillNo);{RunNo, TransNo, TillNo}
    end;{with}
    iStatus := Add_Rec(F[TillSalesF], TillSalesF, RecPtr[TillSalesF]^, tsMainK);
    Report_BError(TillSalesF,iStatus);
  end;{StoreCardBalancesTotal}

begin { EndofDay }

  if Syss.LinkToExch then begin
    if (not AllNomsExist) then begin
      MsgBox('One or more of the Nominal Codes defined in system setup do not exist.' + #13#13
      + 'You must set these up correctly in order to be able to do an End of Day.'
      ,mtWarning,[mbOK],mbOK,'Nominal Code Error');
      Exit;
    end;

    if oDll.TKSysRec.CCDepts and (not CCDeptOK) then begin
      MsgBox('Either your cost centre or department are not setup correctly in system setup.' + #13#13
      + 'You must set these both up correctly in order to be able to do an End of Day.'
      ,mtWarning,[mbOK],mbOK,'CC/Dept Error');
      Exit;
    end;
  end;{if}

  Screen.Cursor := crHourglass;
  FrmComms.MPComms.ResetBigBadErrorCount;

  if not bAuto then SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,0);

  bgShowErrors := not bAuto;
  TBal := 0;
  NRunNo := 0;
  GuBal := 0;
  PostSpend := 0;
  PostVAT := 0;
  PostNet := 0;
  PostVS := 0;
  GoodTill := 0;
  FrmComms.iGoodTill := 0;
  rTotalCardBalances := 0;

  { Initialise the duff till monitoring for and EOD }
  StartDuffTillList;

  if FrmProgress = nil then FrmProgress := TFrmProgress.Create(application);
  try
    FindComponents;
    with FrmProgress do begin
      if not bAuto then begin
        Caption := 'End Of Day Progress...';
        Show;
      end;{if}

      if (Addch<>Esc) then begin
        lStatus.Caption := 'Initialising';

        { Check tills are online }
        Abort := not FrmComms.Till_OnLine(0);

        if Abort then
          begin
            MsgBox('All the tills have not been found.' + #13#13
            + 'Please check that all your tills are switched on, and then run the End of Day again.'
            ,mtError,[mbOK],mbOK,'Till Communications Error');
          end
        else begin

          try
            AssignFile(EODError, 'EODERROR.LOG');
            ReWrite (EODError);
          except
            on E:Exception do showmessage('EOD - Open EODError : ' + E.ClassName + ' - ' + E.Message);
          end;{try}

          EODErrorFound := False;

          { Display Progress Window }
          DisplayProgress;

          { Get Run Number for this EOD }
          if (not Abort) Then NRunNo := Set_RunNo(TRUE);

          { Download Till Totals if MP2 till }
          if (not Abort) and (ECRTillType = TillType_MP2) Then DownloadTillInfo;

          {download all plu's}
          if Syss.EODDLoadPLU then DownloadItems(0, 0, 0, 0, 1, iMaxPLU, TFrmProgress(FrmProgress));

          {download SAM type stuff}
          if Syss.EODTillReps then DownloadTillSales;

          {blank the Totalisers Array}
          For iTillNo := 0 to Syss.NoTills do setlength(aTotalisers[iTillNo],0);
          setlength(aTotalisers,0);

          { Load Group Cache }
          GetMem (GroupArray, SizeOf (GroupArray^));
          if (not Abort) then LoadGroups;

          { Initialise Linked Lists }
          LinkList_Sales := TLinkList_Sales.Init;
          LinkList_Topups := TLinkList_Sales.Init;
          LinkList_Voids := TLinkList_Sales.Init;

          { Allocate memory for ABS Tracking list }
          New (AbsCheck);
          FillChar (AbsCheck^, SizeOf(AbsCheck^), #0);

          { Get first record }
          Blank(KeyS,SizeOf(KeyS));
          {iStatus := }Find_Rec (B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

          {Create Local Record}
          ExLocal.Create; {create local record instance}
          ExLocal.AssignFromGlobal(CustF); {makes a local copy of the global variable}
          ExLocal.LGetRecAddr(CustF);

          {$IFDEF EODTRACE}
            InitTrace;
          {$ENDIF}

          iStatus := 0;
          while (iStatus = 0) and (bgCommsWorking) and (not Abort) do begin
            with EXLocal.LCust do begin
              { Check card is registered on the till }
              if (TillNo > 0) then begin
                lStatus.Caption := 'Processing Member...';
                lName.Caption := CardFullName(EXLocal.LCust, True, True);

                { Lock Record }
                Ok := GetMultiRec(B_GetDirect,{B_MultLock}B_SingLock,KeyS,KeyPAth,Fnum,TRUE,GlobLocked);

                if Ok and (GlobLocked) then begin
                  { reset todays receipts to run no }
//                  Set_OSRec (NRunNo);

                  { Check the ABS number hasn't already been processed }
                  CheckAbsDupli;

                  { Get Best Balance from tills, and number of best till }
                  TBal := FrmComms.GetBestBalance(StrToIntDef(Trim(EXLocal.LCust.CustCode),-1), EXLocal.LCust.TillNo, TRUE);
                  if not CommsFailed then begin
                    GoodTill := FrmComms.iGoodTill;

                    { Get Pro Shop Balance }
                    BallBal := FrmComms.GetTillBalance(EXLocal.LCust.TillNo, Syss.ProTill, TRUE);{BallBal := GetProShopBalance(EXLocal.LCust);}

                    { Get Guest Till Balance }
                    GuBal := FrmComms.GetTillBalance(EXLocal.LCust.TillNo, Syss.GuestTill, TRUE);{GuBal := GetGuestBalance (EXLocal.LCust);}

                    if Syss.UseMemBill Then LoadGuestSales;{Memory Billing - Get Detail Items from best till}

                    { Check to see if card has been spent/credited }
                    if CheckSpends then
                      begin
                        TillBalance := CurrBalance; { Balance till thinks its got }

                        if Syss.UseMemBill then
                          begin
                            { Change flags }
                            PrevCBal  := TBal;
                            PrevBalls := BallBal;
                            PrevGBal  := GuBal;
                            EODFlg    := TRUE;


                            (******************************************************)
                            (* Process Top-Ups at the till                        *)
                            (******************************************************)

                            LinkList_Topups.GetFirst;
                            while LinkList_Topups.Found do begin
                              with LinkList_Topups.CurrItem^ do begin
                                if (itAmount <> 0.0) then begin
                                  { Generate an invoice for the topup }
                                  AddTopup (NRunNo, itAmount);

                                  { update customers current balance }
                                  with Inv do begin
{                                    Credits         := Round_Up (ABS (InvNetVal),  2);
                                    CreditIncentive := Round_Up (ABS (DiscAmount), 2);}

                                    {for negative topups : .037}

                                    {negates the sign if topup is +ve}
                                    {if InvNetVal >= 0 then }DiscAmount := DiscAmount * -1; {Changed again ! : .043}

                                    Credits         := Round_Up(InvNetVal, 2);
                                    CreditIncentive := Round_Up(DiscAmount, 2);

                                    CurrBalance     := Round_Up (CurrBalance - (Credits + CreditIncentive), 2);
                                    TillBalance     := Round_Up (TillBalance - Credits, 2);
                                    (* MH 22/05/96
                                    CPaid           := Round_Up (CPaid - (Credits + CreditIncentive), 2);
                                    *)
                                    CPaid           := Round_Up (CPaid + (Credits + CreditIncentive), 2);
                                  end; { with }

                                  { Update last used date on customer }
                                  EXLocal.LCust.OrdDate := Today;
                                end; { if }
                              end;{with}
                              { Get next topup }
                              LinkList_Topups.GetNext;
                            end;{While}


                            (******************************************************)
                            (* Process Voids                                      *)
                            (******************************************************)
                            LinkList_Voids.GetFirst;
                            if LinkList_Voids.Found then begin
                              { Calc Total voids }
                              Credits := 0.0;
                              while LinkList_Voids.Found do begin
                                with LinkList_Voids.CurrItem^ do begin
                                  if (itAmount <> 0.0) or (itQuantity <> 0.0) Then Credits := Credits + ABS(itAmount);
                                  LinkList_Voids.GetNext;
                                end; { with }
                              end;{while}

                              if (Credits <> 0.0) then begin
                                { Add Void Invoice }
                                AddVoid (NRunNo, Credits);
                                InvFolioNum := Inv.FolioNum;

                                { update advance vat }
                                if (Syss.VatMode = vmAdv) then begin
                                  PostSpend:=PostSpend+PostNet;
                                  PostVS:=PostVS+PostVAT;
                                end;{if}

                                { Add Items }
                                ItemOrder := 1;
                                LinkList_Voids.GetFirst;
                                while LinkList_Voids.Found do begin
                                  with LinkList_Voids.CurrItem^ do begin
                                    if (itAmount <> 0.0) or (itQuantity <> 0.0) then begin
                                      ItemIncentive := 0.0;  { Assume no discount given as this will always come out in cust. favour }
                                      itRate        := 0.0;
                                      itAmount      := -ABS(itAmount);

                                      Case itType of
                                        siType_DeptVoid : itType := siType_Dept;
                                        siType_PLUVoid  : itType := siType_PLU;
                                      end; { Case }

                                      { Add detail invoice }
                                      AddDetailLine (CustCode,
                                                     InvFolioNum,
                                                     NRunNo,
                                                     itType,
                                                     itNumber,
                                                     itName,
                                                     itQuantity,
                                                     itAmount,
                                                     itRate,
                                                     ItemIncentive,
                                                     ItemOrder,
                                                     CurrBalance);


                                      { update customer spend }
                                      CurrBalance := Round_Up (CurrBalance + itAmount, 2);
                                      CSpent      := Round_Up (CSpent + itAmount, 2);

                                      { Update last used date on customer }
                                      EXLocal.LCust.OrdDate := Today;
                                    end; { if }
                                  end;{with}
                                  { Get next topup }
                                  LinkList_Voids.GetNext;
                                end; { while }

                                { update customers current balance }
                                TillBalance := Round_Up (TillBalance - Credits, 2);
                              end; { if }
                            end; { if }


                            (******************************************************)
                            (* Process Spend                                      *)
                            (******************************************************)
                            Debits         := Round_Up (PrevCBal - TillBalance, 2);
                            DebitIncentive := 0.0;

                            { Add invoice for any remaining spend }
                            if (Debits <> 0.0) then begin
                              { add an invoice covering the total spend (less credit) without incentives }
                              AddInvoice(ExLocal, 0, {NRunNo,} Debits, PrevBalls, PrevGBal, PostNet, PostVAT, 0, isEodSpend);
                              InvFolioNum := Inv.FolioNum;

                              { Generate the invoice detail }
                              ItemOrder := 1;

                              LinkList_Sales.GetFirst;

                              while LinkList_Sales.Found do begin
                                with LinkList_Sales.CurrItem^ do begin
                                  if (itAmount <> 0.0) or (itQuantity <> 0.0) then begin
                                    ItemIncentive := 0.0;

                                    { calc any incentive for item }
                                    if (itRate <> 0.0) and (Syss.UseSplDisc) then begin
                                      if (CurrBalance < 0.0) or Syss.ODDisc then begin
                                        { Got some credit - so will be some discount }
                                        if (CurrBalance < -ABS(itIncAmount)) or Syss.ODDisc Then ItemIncentive
                                        := Round_Up (((itRate / 100) * itIncAmount), 2){ Got enough credit to cover item }
                                        else ItemIncentive := Round_Up (((itRate / 100) * Abs(CurrBalance)), 2);{ Got enough credit for part of the item }
                                      end;{if}
                                    end;{if}

                                    { Add detail invoice }
                                    AddDetailLine (CustCode,
                                                   InvFolioNum,
                                                   NRunNo,
                                                   itType,
                                                   itNumber,
                                                   itName,
                                                   itQuantity,
                                                   itAmount,
                                                   itRate,
                                                   ItemIncentive,
                                                   ItemOrder,
                                                   CurrBalance);


                                    { update customer spend }
                                    CurrBalance := Round_Up (CurrBalance + itAmount - ItemIncentive, 2);
                                    { HM 08/12/97: Don't do by items as screws up when items missing }
                                    {CSpent      := Round_Up (CSpent + itAmount - ItemIncentive, 2);}
                                    TillBalance := TillBalance + itAmount;

                                    { Accumulate incentives given on sales }
                                    DebitIncentive := DebitIncentive + ItemIncentive;

                                    { Update last used date on customer }
                                    EXLocal.LCust.OrdDate := Today;
                                  end; { if }
                                end;{with}
                                LinkList_Sales.GetNext;
                              end; { while }

                              { update vat on invoice }
                              Locked := False;

                              Retries := 10;
                              repeat
                                { get and lock invoice record }
                                InvKey := FullNomKey (InvFolionum);
                                if GetMultiRec(B_GetDirect, B_SingLock{B_MultLock}, InvKey, InvFolioK, InvF, FALSE, Locked) then ;

                                { Used one attempt }
                                Dec (Retries);
                              until Locked or (Retries = 0);

                              if Locked then begin
                                with Inv do begin
                                  Source := isEodSpend;
                                  if Syss.UseSplDisc and (Syss.VatMode = vmAdv) then begin
                                    {PostNet   := Round_Up (InvNetVal - DebitIncentive, 2);}
                                    PostNet   := Round_Up (InvNetVal, 2);
                                    DiscSpent := DebitIncentive;
                                    InvVAT    := Calc_IncVAT (PostNet);
                                    PostVAT   := InvVAT;
                                  end; { if }

                                  { update advance vat }
                                  if (Syss.VatMode = vmAdv) then begin
                                    PostSpend:=PostSpend+PostNet;
                                    PostVS:=PostVS+PostVAT;
                                  end;

                                  { Update main spend invoice with incentive given }
                                  SepDisc    := Syss.UseSplDisc;
                                  DiscAmount := DebitIncentive;

                                  { update invoice with incentive given }
                                  iStatus := Put_Rec (F[InvF], InvF, RecPtr[InvF]^, InvFolioK);
                                  Report_BError (InvF, iStatus);

                                  if Syss.UseSplDisc Then {AddDiscount (NRunNo, DebitIncentive
                                  , Round_Up(DebitIncentive/Debits, 2));};
                                end; { with }
                              end;{if}

                              { HM 08/12/97: Update Spend/Paid-In values for spend transaction }
                              UpdCustForSpend;
                            end; { if }


                            (******************************************************)
                            (* Check balance and update till(s)                   *)
                            (******************************************************)
                            if (Round_Up(TillBalance, 2) <> Round_Up(PrevCBal, 2)) then begin
                              { Some cash has gone walkabout, so we'd better tell them }

                              if (Round_Up(TillBalance + rDiscount, 2) <> Round_Up(PrevCBal, 2)) then begin
                                // only add to error log if discount amount does not reconcile the amount
                                RepHed;

                                try
                                  Writeln (EODError, 'Card: ', EXLocal.LCust.CustCode,
                                                   '  Till Balance: ', PrevCBal:-12:2,
                                                   '  Card with Items: ', TillBalance:-12:2);
                                except
                                  on E:Exception do showmessage('EOD - Check balance and update till(s) : ' + E.ClassName + ' - ' + E.Message);
                                end;{try}
                              end;{if}

                              { Correct the balance to match the difference }
                              CurrBalance := CurrBalance + (PrevCBal - TillBalance);

                              {$IFDEF EODTRACE}
                                { Write log file for customer to file }
                                WriteLog := True;
                              {$ENDIF}
                            end; { if }


                            (******************************************************)
                            (* Check that all voids have been allocated to sales  *)
                            (******************************************************)
                            LinkList_Voids.GetFirst;
                            while LinkList_Voids.Found do begin
                              with LinkList_Voids.CurrItem^ do begin
                                if (itIncAmount <> 0.0) then begin
                                  RepHed;
                                  try
                                    Writeln (EODError, 'Card: ', EXLocal.LCust.CustCode,'  Unsold Void: ', itName
                                    ,'  ', itIncAmount:-12:2);
                                  except
                                    on E:Exception do showmessage('EOD - Check that all voids have been allocated to sales : ' + E.ClassName + ' - ' + E.Message);
                                  end;
                                end; { if }
                              end;{with}
                              LinkList_Voids.GetNext;
                            end; { while }


                            { Update till with balance & Reset guest sale details }
                            MemSalesRec.NewBalance.Value := RealToTillStr(CurrBalance,10);
                            MemSalesRec.NewBalance.Sign := CalcSignBytes(Round(CurrBalance * 100));
                            FrmComms.SetMemberInfo(0, MemSalesRec, TRUE, TRUE);

                            (******************************************************)
                            (* Check for cards over the Credit Limit              *)
                            (******************************************************)
                            if (Hold = 1) and ((CurrBalance <= 0.0) or AllowCredit) then Cancel_Hold(ExLocal
                            , CustF, CustCodeK, FALSE){ On 'Over Credit Limit' hold, but in credit again }
                            else begin
                              if (Hold = 0) and ((CurrBalance > 0.0) and (not AllowCredit)) Then Set_CustHold(ExLocal
                              , 1, CustF, CustCodeK, FALSE){ not on hold, but balance now overdrawn }
                              else begin
                                {* Individually place on hold Proshop & reservations office *}
                                if ((BBallBal > DRLimit) and (BBallBal > Syss.DefDrLimit))
                                then Set_CustHold(ExLocal, 3, CustF, CustCodeK, FALSE);

                                if ((GuestBal > GuestLimit) and (GuestBal > Syss.DefGuLimit))
                                then Set_CustHold(ExLocal, 4, CustF, CustCodeK, FALSE);
                              end;{if}
                            end;{if}
                          end
                        else begin
                          { Change flags }
                          PrevCBal  := TBal;
                          PrevBalls := BallBal;
                          PrevGBal  := GuBal;
                          EODFlg    := TRUE;

                          { Normal Billing }
                          Debits := Round_Up (PrevCBal-CurrBalance, 2);
                          Gen_Inv(ExLocal, 0{NRunNo,}, Debits, PrevBalls, PrevGBal, PostNet, PostVAT, 0, isEodSpend);
                          if (Syss.VatMode = vmAdv) then begin
                            PostSpend:=PostSpend+PostNet;
                            PostVS:=PostVS+PostVAT;
                          end;{if}
                        end;{if}

                        { Update customer record }

                        {$IFDEF CS}
                          ChangeFlag := 3; { Set flag for exporting to club }

                          SetSysFlag;
                        {$ENDIF}
                        iStatus := Put_Rec(F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath);
                        Report_BError(Fnum, iStatus);

                        { Reset Pro Shop Balance }
                        if (BallBal<>0) and (Syss.ProTill<>0) then FrmComms.SetBalance(Syss.ProTill, 0, EXLocal.LCust.TillNo, TRUE);{PutECRBal(EXLocal.LCust,0,Syss.ProTill);}

                        { Reset Reservations Balance }
                        if (GuBal<>0) and (Syss.GuestTill<>0) then FrmComms.SetBalance(Syss.GuestTill, 0, EXLocal.LCust.TillNo, TRUE);{PutECRBal(EXLocal.LCust,0,Syss.GuestTill);}

                        { Reset Clerk No. }
                        {PutECRClrk(EXLocal.LCust,0,0);} { causes trouble with comms }
                      end { if }
                    else {iStatus:=}Find_Rec(B_Unlock,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS); { No spends - unlock record }

                    {$IFDEF EODTRACE}
                      WriteCardLog;
                    {$ENDIF}
                  end;{if not CommsFailed}

                  Set_OSRec (NRunNo);

                end; { if }

                rTotalCardBalances := rTotalCardBalances + Exlocal.LCust.CurrBalance;

              end; { with }

              { Update progress window }
              ProgressBar1.Position := ProgressBar1.Position + 1;

              { Get next record }
              iStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

              {Populate Local Record}
              ExLocal.AssignFromGlobal(CustF); {makes a local copy of the global variable}
              ExLocal.LGetRecAddr(CustF);
            end; { with }
          end;{while}

          StoreCardBalancesTotal;

          if EODErrorFound then begin
            try
              Writeln (EODError, ConstStr ('=', 80));
              Writeln (EODError);
              Writeln (EODError);
            except
              on E:Exception do showmessage('EOD - EODErrorFound : ' + E.ClassName + ' - ' + E.Message);
            end;
          end; { if }

          CloseFile(EODError);

          { De-Allocate memory for ABS Tracking list }
          Dispose (AbsCheck);

          { De-Initialise Linked Lists }
          LinkList_Sales.Done;
          LinkList_Topups.Done;
          LinkList_Voids.Done;

          FreeMem (GroupArray, SizeOf (GroupArray^));

          StopDuffTillList;

          if (not Abort) and (TAsyncOk) then begin
            {$IFDEF Ex_On}
//              if (Syss.VatMode = vmAdv) and (PostSpend + PostVS <> 0) then oExchequer.Control_SRF(NRunNo,PostSpend,PostVS,1);
            {$ENDIF}

            if (not bAuto) then {$IFNDEF CARDTK} PrintEODReports(NRunNo, NRunNo, TRUE, TRUE){$ENDIF};
          end;{if}

          ExLocal.Destroy; {destroy local record instance}
        end; {if Abort..}
      end;{if}

      lStatus.Caption := 'Waiting...';
      lName.Caption := '(None)';

      if not bAuto then Close;
    end;{with}
  finally
    if not bAuto then FrmProgress.Release;
  end;{try}

  { Stop the duff till monitoring for EOD }
{  StopDuffTillList;}

  if Abort then EndOfDay := -1
  else EndOfDay := NRunNo;
  bgShowErrors := TRUE;

  Screen.Cursor := crDefault;
  if (not bAuto) and (not Abort) then MsgBox('End of day Complete.',mtInformation,[mbOK],mbOK,'End Of Day');
  if not bAuto then SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,1);
end; { EndofDay }


end.
