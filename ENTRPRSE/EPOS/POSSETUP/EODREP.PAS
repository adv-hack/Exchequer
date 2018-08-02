unit EODRep;

{ nfrewer440 16:26 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, CheckLst, RPFiler, RPDefine, RPBase,
  VarConst, RPCanvas, RPFPrint, PrntDlg, Scrtch1u, PSProc, MiscUtil;

{$I EXCHDLL.INC}

const
  SEC_ORDERS = 1;
  SEC_INVOICES = 2;
  SEC_CREDITS = 3;
  SEC_RECEIPTS = 4;

  iProcessID = 1; {Unique Process ID for this report}

type
  ENoUnique = class(Exception);

  T4Totals = Array [SEC_ORDERS..SEC_RECEIPTS] of IDetail;

  TTXType = (ttSOR, ttSIN, ttSRI, ttSRC, ttSRF, ttSCR);

  TLineInfo = class
    StockCode : string[16];
    Desc : string[60];
    Qty : real;
    NetValue : real;
    Discount : real;
    VAT : real;
    MoneyInTheBank : real;
    CostPrice : real;
    Margin : real;
    GP : real;
    DocPRef : string[10];
    TXType : TTXType;
    TotalOS : real;
    SettDiscAmount : real;
    Payment : char;
    Section : byte;
    TillNo : shortint;
    TillName : string[30];
    Operator : string[10];
    Consolidate : boolean;
  end;

  TTenderTotals = record
    Cash : Real;
    Card : Real;
    Cheque : Real;
//    WrittenOff : Real;
    WrittenOff : Real;  {Re-instated for .281}
//    LeftOnAccount : Real;
//    SettlementDiscount : Real;
    Total : Real;
  end;

  TfrmEODReport = class(TForm)
    edStartDate: TDateTimePicker;
    Label1: TLabel;
    edEndDate: TDateTimePicker;
    Label2: TLabel;
    Bevel2: TBevel;
    Label5: TLabel;
    Bevel4: TBevel;
    lstTills: TCheckListBox;
    Bevel5: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    Label6: TLabel;
    cbShowMargin: TCheckBox;
    cbSummary: TCheckBox;
    btnAll: TButton;
    Label3: TLabel;
    cbConsolidate: TCheckBox;
    edStartTime: TDateTimePicker;
    edEndTime: TDateTimePicker;
    TheReport: TReportFiler;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure TheReportBeforePrint(Sender: TObject);
    procedure TheReportNewPage(Sender: TObject);
    procedure TheReportPrint(Sender: TObject);
    procedure cbSummaryClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    oScratch : ScratchFile;
    Procedure PrintLines(slLines : TStringList);
  public
    { Public declarations }
  end;

{var
  frmEODReport: TfrmEODReport;}

implementation
uses
  GlobVar, BtrvU2, BtKeys1U, BTSupU1, StrUtil, TillName, RPDevice, EPOSComn
  , DLLInt, RepUtil, EPOSCnst, {NeilProc,} MiscU, ComnU2, MathUtil, UseDLLU, CurrncyU, APIUtil;

{$R *.DFM}

procedure TfrmEODReport.FormCreate(Sender: TObject);
var
  oTillInfo : TTillInfo;
  iPos : integer;
begin
  edStartDate.Date := SysUtils.Date;
  edEndDate.Date := SysUtils.Date;

  {load Tills List}
  oTillInfo := TTillInfo.Load(FALSE);
  For iPos := 0 to oTillInfo.Names.Count - 1 do begin
    if ((TTillObject(oTillInfo.Names.Objects[iPos]).CompanyCode = CurrCompanyRec.CompCode)
    or (TTillObject(oTillInfo.Names.Objects[iPos]).CompanyCode = ''))
    and (Trim(oTillInfo.Names[iPos]) <> '')
    then begin
      // Add Till to list
      lstTills.Items.Add(IntToStr(iPos + 1) + ' - ' + oTillInfo.Names[iPos])
    end;{if}
  end;{for}
  oTillInfo.Unload;

  btnAllClick(nil);
  OpenDLL(sGlobalCompanyPath);
end;

procedure TfrmEODReport.btnOKClick(Sender: TObject);
var
  iLineStatus, iTHIndex, iTLIndex, iStatus : smallint;
  sKey : Str255;
  iLinesInScratch, iPos, FVar, iTillNo, iRecAddress : LongInt;
  TillsToReportOn : set of 1..99;
  RepFName, BaseDir : string;
  PrnInfo : TSBSPrintSetupInfo;
  rTotalOS : real;
  dInvDateTime, dEndDateTime, dStartDateTime : TDateTime;
  sAdditionalInfo : string[100];
  bFirstLine : boolean;
  LTKTXHeader : TBatchTHRec;
  LTKTLines : TBatchLinesRec;
  pOurRef : PChar;

  function SINHasNoMatchingSOR : boolean;
  var
    TKMatchRec : TBatchMatchRec;
    pOurRef : PChar;
    iStatus : integer;
  begin{SINHasNoMatchingSOR}
    Result := TRUE;

    if (ID.IdDocHed <> SIN) then exit;

    pOurRef := StrAlloc(255);
    StrPCopy(pOurRef, ID.DocPRef);

    // get payments from all SRC transactions that are matched to our TX
    iStatus := Ex_GetMatch(@TKMatchRec, SizeOf(TKMatchRec),pOurRef,0,B_GetGEq,FALSE);

    while (iStatus = 0) and (Result = TRUE) and (TKMatchRec.DebitRef = ID.DocPRef) do
    begin

      // Only for financial matching
      if (TKMatchRec.MatchType = 'O') and (Copy(TKMatchRec.CreditRef,1,3) = 'SOR')
      then Result := FALSE;

      {Get Next Match}
      iStatus := Ex_GetMatch(@TKMatchRec, SizeOf(TKMatchRec),pOurRef,0,B_GetNext,FALSE);
    end;{while}

    StrDispose(pOurRef);
  end;{SINHasNoMatchingSOR}

begin

  Screen.Cursor := crHourglass;
  oScratch.Init(iProcessID);

  {builds a [Set] of tills to report on}
  TillsToReportOn := [];
  For iPos := 0 to lstTills.Items.Count - 1 do begin
    if lstTills.Checked[iPos]
    then TillsToReportOn := TillsToReportOn + [StrToInt(Trim(Copy(lstTills.Items[iPos],1,2)))];
  end;{for}

  dStartDateTime := Trunc(edStartDate.Date) + edStartTime.Time - Trunc(edStartTime.Time);
  dEndDateTime := Trunc(edEndDate.Date) + edEndTime.Time - Trunc(edEndTime.Time);

  {Builds the scratch file}
  iLinesInScratch := 0;
  iTHIndex := InvDateK; {trans date order}
  iTLIndex := IdFolioK; {folio number order}
//  sKey := DateTimeAsLongDate(edStartDate.Date);
  sKey := DateTimeAsLongDate(Trunc(edStartDate.Date));

  iStatus := Find_Rec(B_GetGEq, F[InvF], InvF,RecPtr[InvF]^, iTHIndex, sKey);
  While (iStatus = 0) and (ToDateTime(Inv.TransDate) <= Trunc(edEndDate.Date)) do begin
    if (copy(Inv.DocUser4,1,4) = 'EPOS') then begin
      // EPOS TX
      dInvDateTime := Str8ToDate(Inv.TransDate) + Str6ToTime(Inv.TimeCreate);
      if ((dInvDateTime >= dStartDateTime) and (dInvDateTime <= dEndDateTime))
      or (Trim(Inv.TimeCreate) = '') then
      begin
        // Within time range (or no time set)
        iTillNo := StrToIntDef(copy(Inv.DocUser4, 5, 2), 0);
        if iTillNo in TillsToReportOn then begin
          {get transaction lines}
          bFirstLine := TRUE;
          sKey := FullNomKey(Inv.Folionum);
          iLineStatus := Find_Rec(B_GetGEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, iTLIndex, sKey);
          while (iLineStatus = 0) and (Inv.Folionum = ID.FolioRef) do begin
            if (not ((ID.StockCode = '') and (ID.Qty = 0)))
            and (ID.IdDocHed in [SRF,SCR,SIN,SOR,SRI,SRC])
            and (SINHasNoMatchingSOR) then
            begin

              FillChar(sAdditionalInfo,Sizeof(sAdditionalInfo),#0);
              sAdditionalInfo := PadString(psRight,copy(Inv.DocUser4, 8, 23),' ',30) + Chr(Ord(Inv.DiscTaken));
              if bFirstLine then begin
                {Get Outstanding amount on TX}

                if ID.IdDocHed in [SRF,SCR] then
                  begin
                    if ID.IdDocHed = SRF then
                    begin
                      Inv.Settled := Inv.Settled * -1;
                    end;{if}
                    if ID.Payment = 'Y' then rTotalOS := TotalOS(Inv) * -1
                    else rTotalOS := 0;
                  end
                else begin
                  if ID.Payment = 'N' then rTotalOS := TotalOS(Inv)
                  else rTotalOS := 0;

                  {.206}
                  if (ID.IdDocHed = SRC) and (copy(Inv.YourRef,1,3) = 'SOR')
                  then rTotalOS := rTotalOS - Inv.InvNetVal;
                end;{if}

                Move(rTotalOS, sAdditionalInfo[32], Sizeof(rTotalOS));
                if Inv.DiscTaken then Move(Inv.DiscSetAm, sAdditionalInfo[40], Sizeof(Inv.DiscSetAm));
                Move(Inv.DiscSetl, sAdditionalInfo[48], Sizeof(Inv.DiscSetl));

                sAdditionalInfo[0] := Chr(Sizeof(sAdditionalInfo));
                bFirstLine := FALSE;
              end;{if}

              {add to scratch}
              {Status := }GetPos(F[IdetailF], IdetailF, iRecAddress); {gets the record address}
              oScratch.Add_Scratch(IdetailF, iTLIndex, iRecAddress, FullNomKey(iTillNo)
              + PadString(psRight,Uppercase(Inv.OpName),' ',10) + ID.StockCode
              ,  sAdditionalInfo); {adds ref into scratch file}
              inc(iLinesInScratch);
            end;{if}
            iLineStatus := Find_Rec(B_GetNext, F[IdetailF], IdetailF, RecPtr[IdetailF]^, iTLIndex, sKey);
          end;{while}
        end;{if}
      end;{if}
    end;{if}
    iStatus := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, iTHIndex, sKey);
  end;{while}

  PrnInfo := RpDev.SBSSetupInfo;
  if iLinesInScratch = 0 then
    begin
      MsgBox('There are currently no transactions in the range selected.',mtInformation,[mbOK],mbOK,'End Of Day Report');
    end
  else begin
    if SelectPrinter(PrnInfo) then begin

      { Generate Unique Filename for report file }
      FVar := 0;
      BaseDir := GetEXEDir;
      Repeat
        RepFName := BaseDir + '!REP' + IntToStr(FVar) + '.SWP';
        Inc (FVar);
      Until (Not FileExists (RepFName)) Or (FVar > 9999);
      If (FVar > 9999) Then Raise ENoUnique.Create('Cannot Find Unique Filename');

      RpDev.SetPrnSetup(PrnInfo);

      {creates the temporary file}
      with TheReport do begin
        FileName := RepFName;
        PrinterIndex := RpDev.DeviceIndex;
        Copies := PrnInfo.NoCopies;
        Execute;
      end;{with}

      PrintFileTo(PrnInfo, RepFName, 'EOD Report'); {Asks SBSFORM.DLL to print the created file - Please}

      DeletePrintFile(RepFName);
      ModalResult := mrOK;
    end;{if}
  end;{if}
  Screen.Cursor := crDefault;

  oScratch.Done;
end;

procedure TfrmEODReport.btnAllClick(Sender: TObject);
var
  bNewState : boolean;
  iPos : integer;
begin
  bNewState := btnAll.Caption = '&Select All';

  For iPos := 0 to lstTills.Items.Count - 1 do lstTills.Checked[iPos] := bNewState;

  if bNewState then btnAll.Caption := 'De&select All'
  else btnAll.Caption := '&Select All';
end;

procedure TfrmEODReport.TheReportBeforePrint(Sender: TObject);
begin
  SetDefaultMargins(TheReport, poLandscape);
end;

procedure TfrmEODReport.TheReportNewPage(Sender: TObject);
var
  CurrRec : ^TBatchCurrRec;
  sHeader, sRange, sTitle : string;
begin
  with TheReport do begin
    ClearTabs;
    SetTab(MarginLeft + 2, pjLeft, 2, 4, 0, 0);
    SetTab(NA, pjLeft, 40, 4, 0, 0);    {Stock Code}
    SetTab(NA, pjLeft, 70, 4, 0, 0);    {Description}
    SetTab(NA, pjRight, 15, 4, 0, 0);   {Quantity}
    SetTab(NA, pjRight, 20, 4, 0, 0);   {Price}
    SetTab(NA, pjRight, 20, 4, 0, 0);   {Discount}
    SetTab(NA, pjRight, 20, 4, 0, 0);   {VAT Amount}
    SetTab(NA, pjRight, 20, 4, 0, 0);   {Total}
    if cbShowMargin.Checked then begin
      SetTab(NA, pjRight, 20, 4, 0, 0);   {Cost}
      SetTab(NA, pjRight, 20, 4, 0, 0);   {Margin}
      SetTab(NA, pjRight, 15, 4, 0, 0);   {GP}
    end;{if}
    SetTab(NA, pjLeft, 20, 4, 0, 0);    {Doc No.}

    {Get Currency Name}
    new(CurrRec);
    status := EX_GETCURRENCY(CurrRec, SizeOf(CurrRec^), SetupRecord.TillCurrency);

    if cbSummary.Checked then sTitle := 'End Of Day Summary Report (' + CurrRec.Name + ')'
    else sTitle := 'End Of Day Report (' + CurrRec.Name + ')';

    sRange := 'Date / Time Range : ' + DateToStr(edStartDate.Date) + ' ' + TimeToStr(edStartTime.Time)
    + ' - ' + DateToStr(edEndDate.Date) + ' ' + TimeToStr(edEndTime.Time);

    sHeader := #9#9 + 'Stock Code' + #9 + 'Description' + #9 + 'Quantity' + #9
    + 'Price' + #9 + 'Discount' + #9 + sVATText + ' Amt.' + #9 + 'Total' + #9;

    if cbShowMargin.Checked then
      begin
        SetStandardHeader(TheReport, sTitle, sRange, sHeader + 'Cost' + #9 + 'Margin'
        + #9 + 'GP %' + #9 + 'Doc. No.');
      end
    else begin
      SetStandardHeader(TheReport, sTitle, sRange, sHeader + 'Doc. No.');
    end;{if}

    dispose(CurrRec);
  end;{with}
  SetRepFont(TheReport, fnMainText, 9);
end;

procedure TfrmEODReport.TheReportPrint(Sender: TObject);
Var
  iStatus : smallint;
  iTillNo : integer;
  sCheck, sKey : Str255;
  sOperator : string;
  bSettDiscTaken : boolean;
  rSettDiscAmount, rTotalOS : real;
  slLines : TStringList;

  procedure AddStockLine;

    function GetTXTypeFromOurRef(sOurRef : string) : TTXType;
    begin{GetTXTypeFromOurRef}
      if Copy(sOurRef,1,3) = 'SOR' then Result := ttSOR;
      if Copy(sOurRef,1,3) = 'SIN' then Result := ttSIN;
      if Copy(sOurRef,1,3) = 'SRI' then Result := ttSRI;
      if Copy(sOurRef,1,3) = 'SRC' then Result := ttSRC;
      if Copy(sOurRef,1,3) = 'SRF' then Result := ttSRF;
      if Copy(sOurRef,1,3) = 'SCR' then Result := ttSCR
    end;{GetTXTypeFromOurRef}

  var
    LineInfo : TLineInfo;
    rAfterDisc, rBeforeDisc, rGP, rMargin, rMoneyInTheBank : real;

    Function BuildSLKey : string;
    begin{BuildSLKey}
      Result := PadString(psLeft, IntToStr(LineInfo.TillNo), '0', 4)
      + PadString(psRight, LineInfo.Operator, ' ', 10)
      + IntToStr(LineInfo.Section)
      + PadString(psRight, LineInfo.Desc, ' ', 60)
      + PadString(psRight, LineInfo.StockCode, ' ', 16);
    end;{BuildSLKey}

    procedure PopulateLineInfo;
    begin{PopulateLineInfo}
      with ID do begin
        LineInfo.StockCode := StockCode;
        LineInfo.Desc := Desc;
        LineInfo.Qty := Qty;
        LineInfo.NetValue := NetValue;
        LineInfo.Discount := Discount;
        LineInfo.VAT := VAT;
        LineInfo.MoneyInTheBank := rMoneyInTheBank;
        LineInfo.CostPrice := CostPrice;
        LineInfo.Margin := rMargin;
        LineInfo.GP := rGP;
        LineInfo.DocPRef := DocPRef;
        LineInfo.TotalOS := rTotalOS;
        LineInfo.SettDiscAmount := rSettDiscAmount;
        LineInfo.Payment := payment;
        LineInfo.TillNo := iTillNo;
        LineInfo.TillName := Trim(Copy(RepScr^.KeyStr,1,30));
        LineInfo.Operator := sOperator;
        LineInfo.TXType := GetTXTypeFromOurRef(DocPRef);
      end;{with}
    end;{PopulateLineInfo}

  begin{AddStockLine}
    with ID do begin

      if ((Trim(StockCode) = '') and ZeroFloat(Qty) and ZeroFloat(NetValue)) // additional desc lines ?
      or (ID.Discount3Type = 255) // Discount Lines
      then Exit;

      if ID.IdDocHed in [SRF,SCR] then begin
        case ID.Payment of
          'N' : begin
            ID.Payment := 'Y';
            ID.NetValue := ID.NetValue * -1;
//            ID.Discount := ID.Discount * -1;{.253}
  //        ID.StockCode := 'DONOTPRINTTHISLINE';
          end;

          'Y' : begin
            ID.Payment := 'N';
            ID.Qty := ID.Qty * -1;
            ID.VAT := ID.VAT * -1;
            ID.NetValue := ID.NetValue * -1;
            ID.Discount := ID.Discount * -1;{.204}
          end;
        end;{case}
      end;{if}

      ID.UsePack := FALSE; {not a consolidated line}

      if ID.Payment = 'N' then begin
        rBeforeDisc := DetLTotal(ID, FALSE, FALSE, 0) * DocCnst[ID.IDDocHed];
        rAfterDisc := DetLTotal(ID, TRUE, FALSE, 0{bSettDiscTaken, rSettDiscPercent}) * DocCnst[ID.IDDocHed];

        with ID do begin
          NetValue := rBeforeDisc;
          Discount := rBeforeDisc - rAfterDisc;
          if IdDocHed in [SRF,SCR] then Discount := Discount * -1;
        end;{with}
      end;{if}
  {    if StockID.Qty < 0 then StockID.CostPrice := StockID.CostPrice * -1;}
      ID.CostPrice := ID.CostPrice * ID.Qty;


      {for consolidated lines}
//      if Consolidated then DocPRef := '-';

      {Work out Margin and GP}
      rMoneyInTheBank := NetValue + VAT - Discount;
      rMargin := rMoneyInTheBank - VAT - CostPrice;
      rGP := SafeDiv(rMargin, rMoneyInTheBank - VAT) * 100;

      LineInfo := TLineInfo.Create;
      PopulateLineInfo;

      case LineInfo.TXType of
        ttSOR : LineInfo.Section := SEC_ORDERS;
        ttSIN : LineInfo.Section := SEC_INVOICES;
        ttSRI : begin
          if LineInfo.Payment = 'Y' then
          begin
            // for receipts section
            LineInfo.Section := SEC_RECEIPTS;
          end else
          begin
            // for invoices section
            LineInfo.Section := SEC_INVOICES;
          end;{if}
        end;
        ttSCR : LineInfo.Section := SEC_CREDITS;
        ttSRC : LineInfo.Section := SEC_RECEIPTS;
        ttSRF : begin
          if LineInfo.Payment = 'Y' then LineInfo.Section := SEC_RECEIPTS
          else LineInfo.Section := SEC_CREDITS;
        end;
      end;

      slLines.AddObject(BuildSLKey, LineInfo);
    end;{if}
  end;{AddStockLine}

  procedure GetRecord;
  begin{GetRecord}
    if (iStatus <> 9) and CheckKey(sCheck, sKey, length(sCheck), TRUE) then
    begin
      oScratch.Get_Scratch(RepScr^);
      sOperator := Copy(RepScr^.AccessK,9,10);
      Move(RepScr^.AccessK[5],iTillNo,4);
      bSettDiscTaken := Copy(RepScr^.KeyStr,31,1) = Chr(1);
    end;
  end;{GetRecord}

Begin{TheReportPrint}

  With TheReport Do Begin

    slLines := TStringList.Create;


    {Print Records from scratch file}
    sCheck := fullNomKey(iProcessID);
    sKey := sCheck;

    {Get First Record and Set line details}
    iStatus := Find_Rec(B_GetGEq, F[oScratch.SFNum], oScratch.SFNum, RecPtr[oScratch.SFNum]^
    , oScratch.SKeypath,sKey);
    GetRecord;

    While (iStatus = 0) and CheckKey(sCheck, sKey, length(sCheck), TRUE) do begin

      {Get "Left on account" amount from the spare Key string of the scratch file}
      Move(RepScr^.KeyStr[32],rTotalOS,sizeof(rTotalOS));

      {Get "Settlement Discount Amount " amount from the spare Key string of the scratch file}
      Move(RepScr^.KeyStr[40],rSettDiscAmount,sizeof(rSettDiscAmount));

      AddStockLine;

      {Next Record}
      iStatus := Find_Rec(B_GetNext, F[oScratch.SFNum], oScratch.SFNum, RecPtr[oScratch.SFNum]^
      , oScratch.SKeypath,sKey);
      GetRecord;

    end;{while}

    PrintLines(slLines);
    ClearList(slLines);
    slLines.Free;

  end;{with}
end;

procedure TfrmEODReport.cbSummaryClick(Sender: TObject);
begin
  cbConsolidate.Enabled := not cbSummary.Checked;
end;

procedure TfrmEODReport.FormDestroy(Sender: TObject);
begin
  Ex_CloseData;
end;

procedure TfrmEODReport.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  If (Key = VK_F1) and (Not (ssAlt In Shift)) then Application.HelpCommand(HELP_Finder,0);
end;

Procedure TfrmEODReport.PrintLines(slLines : TStringList);
var
  PrevLineInfo, NextLineInfo, CurrentLineInfo : TLineInfo;
  SectionTotals, OperatorTotals : Idetail;
  GrandTotals, TillTotals : T4Totals;
  GrandTenderTotals, TillTenderTotals : TTenderTotals;
  iPos, iNoOfTillsDone : integer;

  procedure PrintLine(sDesc : string; rQty, rNetValue, rDiscount, rVAT, rMoneyInTheBank
  , rCostPrice, rMargin, rGP : real; sDocRef : string; bBlankIfZero : boolean);

    function GetGP : string;
    begin{GetGP}
      if ZeroFloat(rGP) and bBlankIfZero then Result := ''
      else begin
        Result := FormatFloat('##0.0%', rGP)
      end;{if}
    end;{GetGP}

  begin{PrintLine}

    If ZeroFloat(rQty) and ZeroFloat(rNetValue) and ZeroFloat(rDiscount)
    and ZeroFloat(rVAT) and ZeroFloat(rMoneyInTheBank) and ZeroFloat(rCostPrice)
    then exit;

    with TheReport do begin
      if cbShowMargin.Checked then
      begin
        Print(sDesc
        + #9 + MoneyToStr(rQty, 2, bBlankIfZero)
        + #9 + MoneyToStr(rNetValue, 2, bBlankIfZero)
        + #9 + MoneyToStr(rDiscount, 2, bBlankIfZero)
        + #9 + MoneyToStr(rVAT, 2, bBlankIfZero)
        + #9 + MoneyToStr(rMoneyInTheBank, 2, bBlankIfZero)
        + #9 + MoneyToStr(rCostPrice, 2, bBlankIfZero)
        + #9 + MoneyToStr(rMargin, 2, bBlankIfZero)
        + #9 + GetGP
        + #9 + sDocRef);
      end else
      begin
        Print(sDesc
        + #9 + MoneyToStr(rQty, 2, bBlankIfZero)
        + #9 + MoneyToStr(rNetValue, 2, bBlankIfZero)
        + #9 + MoneyToStr(rDiscount, 2, bBlankIfZero)
        + #9 + MoneyToStr(rVAT, 2, bBlankIfZero)
        + #9 + MoneyToStr(rMoneyInTheBank, 2, bBlankIfZero)
        + #9 + sDocRef);
      end;{if}
    end;{with}
    EndOfPageLine(TheReport);
  end;{PrintLine}

  procedure PrintTotals(Totals : IDetail; sTitle : string; bCRLF, bLine : boolean; iSection : byte);
  var
    rGP, rMargin, rMoneyInTheBank : real;
  begin
    with TheReport, Totals do begin

      // position
      if bCRLF then
      begin
        if not bLine then CRLF;
      end else
      begin
        if bLine then UpOneLine(TheReport);
      end;{if}

      // draw line
      if bLine then DrawHorzLine(TheReport, dlThin, MarginLeft + 45, MarginLeft + 263);

      // print title of total
//      Print(#9#9#9 + sTitle);

      {Work out Margin and GP}
      rMoneyInTheBank := NetValue + VAT - Discount;
      rMargin := rMoneyInTheBank - VAT - CostPrice;
      rGP := SafeDiv(rMargin, rMoneyInTheBank - VAT) * 100;

      // blank out figures we don't want to see 
      case iSection of
        SEC_ORDERS : ;
        SEC_INVOICES : ;
        SEC_CREDITS : ;
        SEC_RECEIPTS : begin
          Qty := 0;
          NetValue := 0;
          rMargin := 0;
          rGP := 0;
        end;
      end;{case}

      // Print Total
      SetRepFont(TheReport, fnSubTotal, 9);
      PrintLine(#9#9#9 + sTitle, Qty, NetValue, Discount, VAT, rMoneyInTheBank, CostPrice
      ,rMargin, rGP, '', iSection = SEC_RECEIPTS);

    end;{with}
  end;{PrintTotals}

  function GetSectionHeader(iSection : byte) : string;
  begin{GetSectionHeader}
    case iSection of
      SEC_ORDERS : Result := 'Sales Orders';
      SEC_INVOICES : Result := 'Invoices';
      SEC_CREDITS : Result := 'Credits';
      SEC_RECEIPTS : Result := 'Receipts';
      else Result := 'UNDEFINED SECTION';
    end;{case}
  end;{GetSectionHeader}

  procedure Print4Totals(Totals : T4Totals; sTitle : string);
  var
    rGP, rMargin, rMoneyInTheBank : real;
    iTot : integer;
  begin
    For iTot := SEC_ORDERS to SEC_RECEIPTS do
    begin
      PrintTotals(Totals[iTot], 'Total ' + GetSectionHeader(iTot) + sTitle, FALSE, FALSE, iTot);
    end;{for}

    TheReport.CRLF;
  end;{PrintTotals}

  procedure PrintTenderDetails(bGrand : boolean; TenderTotals : TTenderTotals; sExtraText : string
  ; IDTotals : T4Totals);
  var
    rImbalance : real;
  begin
    SetRepFont(TheReport, fnMainText, 9);
    with TheReport do begin
//      PrintEOPLn(#9#9 + 'Taken on Account' + #9#9 + MoneyToStr((IDTotals[1].CostApport)), TheReport);
//      PrintEOPLn('', TheReport);

      PrintEOPLn(#9#9 + 'Tender Details -' + #9 + 'Cash : ' + #9 + MoneyToStr((TenderTotals.Cash)), TheReport);
      PrintEOPLn(#9#9 + sExtraText + #9 + 'Card : ' + #9 + MoneyToStr((TenderTotals.Card)), TheReport);
      PrintEOPLn(#9#9#9 + 'Cheque : ' + #9 + MoneyToStr((TenderTotals.Cheque)), TheReport);
//      PrintEOPLn(#9#9#9 + 'Written-off : ' + #9 + MoneyToStr((TenderTotals.WrittenOff)), TheReport);
      PrintEOPLn(#9#9#9 + 'Written-off : ' + #9 + MoneyToStr((TenderTotals.WrittenOff)), TheReport); {Re-instated for .281}
//      PrintEOPLn(#9#9#9 + 'Settlement Discount : ' + #9 + MoneyToStr((TenderTotals.SettlementDiscount)), TheReport);
//      PrintEOPLn(#9#9#9 + 'Left on Account : ' + #9 + MoneyToStr((TenderTotals.LeftOnAccount)), TheReport);
      UpOneLine(TheReport);
      DrawHorzLine(TheReport, dlThin, MarginLeft + 45, MarginLeft + 128);
      Print(#9#9#9 + 'Total : ' + #9 + MoneyToStr((TenderTotals.Total)));

{      with IDTotals[1] do begin
        rImbalance := TenderTotals.Total - NetValue - VAT + Discount - CostApport;
        if ZeroFloat(rImbalance) then EndOfPageLine(TheReport)
        else begin
          PrintEOPLn(#9#9#9 + 'Tender Imbalance : ' + MoneyToStr(rImbalance), TheReport);
        end;{if}
{      end;{with}

      EndOfPageLine(TheReport);
      EndOfPageLine(TheReport);
    end;{with}
  end;{PrintTenderDetails}

  procedure PrintAllTotals;
  begin{PrintAllTotals}
    {Print Section Totals}
    if (CurrentLineInfo.Section <> NextLineInfo.Section)
    or (CurrentLineInfo.Operator <> NextLineInfo.Operator)
    or (CurrentLineInfo.TillNo <> NextLineInfo.TillNo) then
    begin
      PrintTotals(SectionTotals, 'Section Totals (' + GetSectionHeader(CurrentLineInfo.Section) + ') : '
      , FALSE, not cbSummary.Checked, CurrentLineInfo.Section);
      if not cbSummary.Checked then EndOfPageLine(TheReport);
      FillChar(SectionTotals,sizeof(SectionTotals),#0);{clear operator totals}
    end;{if}

    {Print Operator Totals}
{    if (CurrentLineInfo.Operator <> NextLineInfo.Operator) then
    begin
      PrintTotals(OperatorTotals, 'Operator Totals (' + Trim(CurrentLineInfo.Operator) + ') : ', FALSE, FALSE);
      FillChar(OperatorTotals,sizeof(OperatorTotals),#0);{clear operator totals}
{    end;{if}

    {Print Till Totals}
    if (CurrentLineInfo.TillNo <> NextLineInfo.TillNo) then
    begin
      if cbSummary.Checked then EndOfPageLine(TheReport);
      Print4Totals(TillTotals, ' (' + CurrentLineInfo.TillName + ') : ');
      PrintTenderDetails(FALSE, TillTenderTotals, '(' + CurrentLineInfo.TillName + ')', TillTotals);
      FillChar(TillTenderTotals,sizeof(TillTenderTotals),#0);{clear tender totals}
    end;{if}

  end;{PrintAllTotals}

  procedure PrintStockLine(TheLineInfo : TLineInfo);

    Procedure AddTotals(var TotalsRec : IDetail);
    begin
      with TotalsRec do begin
        Qty := Qty + TheLineInfo.Qty;
        NetValue := NetValue + TheLineInfo.NetValue;
        Discount := Discount + TheLineInfo.Discount;
        VAT := VAT + TheLineInfo.VAT;
        CostPrice := CostPrice + TheLineInfo.CostPrice;
      end;{with}
    end;{AddTotals}

    Procedure Add4Totals(var Totals : T4Totals);
    var
      iTot : integer;
    begin
      For iTot := SEC_ORDERS to SEC_RECEIPTS do AddTotals(Totals[iTot]);
    end;{AddTotals}

  var
    rGP, rMargin, rMoneyInTheBank : real;

  begin{PrintStockLine}
    with TheReport, TheLineInfo do begin

      {for consolidated lines}
      if Consolidate then DocPRef := '-';

      {Work out Margin and GP}
      rMoneyInTheBank := NetValue + VAT - Discount;
      rMargin := rMoneyInTheBank - VAT - CostPrice;
      rGP := SafeDiv(rMargin, rMoneyInTheBank - VAT) * 100;

      if (not cbConsolidate.checked)
      or (((TheLineInfo.StockCode <> NextLineInfo.StockCode) and (TheLineInfo.Desc <> NextLineInfo.Desc))
      or (Section = SEC_RECEIPTS)) then
      begin
        // Increment Totals
        AddTotals(SectionTotals);
        AddTotals(OperatorTotals);
        AddTotals(TillTotals[TheLineInfo.Section]);
        AddTotals(GrandTotals[TheLineInfo.Section]);
      end;

      // blank out figures we don't want to see 
      case Section of
        SEC_ORDERS : ;
        SEC_INVOICES : ;
        SEC_CREDITS : ;
        SEC_RECEIPTS : begin
          Qty := 0;
          NetValue := 0;
          rMargin := 0;
          rGP := 0;
        end;
      end;{case}

      if cbConsolidate.checked
      and ((TheLineInfo.StockCode = NextLineInfo.StockCode) and (TheLineInfo.Desc = NextLineInfo.Desc))
      and (Section <> SEC_RECEIPTS) then
      begin
        NextLineInfo.Qty := NextLineInfo.Qty + TheLineInfo.Qty;
        NextLineInfo.NetValue := NextLineInfo.NetValue + TheLineInfo.NetValue;
        NextLineInfo.Discount := NextLineInfo.Discount + TheLineInfo.Discount;
        NextLineInfo.VAT := NextLineInfo.VAT + TheLineInfo.VAT;
        NextLineInfo.CostPrice := NextLineInfo.CostPrice + TheLineInfo.CostPrice;
        NextLineInfo.DocPRef := '-';
      end else
      begin
        SetRepFont(TheReport, fnMainText, 9);
        if not cbSummary.Checked then begin
          PrintLine(#9#9 + StockCode + #9 + Desc, Qty, NetValue, Discount, VAT, rMoneyInTheBank
          , CostPrice, rMargin, rGP, DocPRef, Section = SEC_RECEIPTS);
        end;{if}
      end;{if}
    end;{with}

  end;{PrintStockLine}

  procedure AddTenderTotals(var TenderTotals : TTenderTotals);
  begin{AddTenderTotals}
    if Copy(CurrentLineInfo.Desc,1,4) = 'Cash' then TenderTotals.Cash := TenderTotals.Cash + CurrentLineInfo.NetValue
    else if Copy(CurrentLineInfo.Desc,1,4) = 'Card' then TenderTotals.Card := TenderTotals.Card + CurrentLineInfo.NetValue
    else if Copy(CurrentLineInfo.Desc,1,6) = 'Cheque' then TenderTotals.Cheque := TenderTotals.Cheque + CurrentLineInfo.NetValue
//    else if Copy(ID.Desc,1,20) = 'Discount (write-off)' then TenderTotals.WrittenOff := TenderTotals.WrittenOff + ID.NetValue;
    else if Copy(CurrentLineInfo.Desc,1,20) = 'Discount (write-off)' then TenderTotals.WrittenOff := TenderTotals.WrittenOff + CurrentLineInfo.NetValue;{Re-instated for .281}

    TenderTotals.Total := TenderTotals.Total + CurrentLineInfo.NetValue;
  end;{AddTenderTotals}

  procedure PrintTitles;
  begin{PrintTitles}
    {Print Till Name Title}
    with TheReport do begin
      if CurrentLineInfo.TillNo <> PrevLineInfo.TillNo then begin
        CRLF;
        SetRepFont(TheReport, fnSectionHeader, 9);
        PrintLn(CurrentLineInfo.TillName);
        inc(iNoOfTillsDone);
        FillChar(OperatorTotals,sizeof(OperatorTotals),#0);{clear operator totals}
        FillChar(TillTotals,sizeof(TillTotals),#0);{clear tender totals}
      end;{if}

      {Print Operator Name Title}
      if CurrentLineInfo.Operator <> PrevLineInfo.Operator then begin
        CRLF;
        SetRepFont(TheReport, fnSectionHeader, 9);
        PrintLn(#9 + 'Operator : ' + Trim(CurrentLineInfo.Operator));
      end;{if}

      // print section title
      if ((CurrentLineInfo.Section <> PrevLineInfo.Section)
      or (CurrentLineInfo.Operator <> PrevLineInfo.Operator)
      or (CurrentLineInfo.TillNo <> PrevLineInfo.TillNo))
      and (not cbSummary.Checked) then
      begin
        SetRepFont(TheReport, fnColHeader, 9);
//        CRLF;
        PrintLn(#9#9#9 + GetSectionHeader(CurrentLineInfo.Section));
      end;{if}
    end;{with}
  end;{PrintTitles}

  function ConsolidateLines(LI, NextLI : TLineInfo) : boolean;
  begin{ConsolidateLines}
    Result := TRUE;
    if LI.TXType in [ttSRF,ttSCR] then Result := FALSE;
  end;{ConsolidateLines}
  
begin
  {Initialise}
  iNoOfTillsDone := 0;

  FillChar(TillTenderTotals,sizeof(TillTenderTotals),#0);
  FillChar(GrandTenderTotals,sizeof(GrandTenderTotals),#0);

  FillChar(SectionTotals,sizeof(OperatorTotals),#0);
  FillChar(OperatorTotals,sizeof(OperatorTotals),#0);
  FillChar(TillTotals,sizeof(TillTotals),#0);
  FillChar(GrandTotals,sizeof(GrandTotals),#0);

  slLines.Sort;

  // go through all lines in the string list
  For iPos := 0 to slLines.Count -1 do
  begin

    // get the Line Info for the current line
    CurrentLineInfo := TLineInfo(slLines.Objects[iPos]);

    // get the Line Info for the next line
    if iPos = slLines.Count -1 then
    begin
      NextLineInfo := TLineInfo.Create;
      NextLineInfo.StockCode := 'd$897%!Fy^&ehc,a';
      NextLineInfo.Operator := 'd$897%!Fy^';
      NextLineInfo.TillNo := -1;
      NextLineInfo.Payment := 'X';
    end else
    begin
      NextLineInfo := TLineInfo(slLines.Objects[iPos +1]);
    end;{if}

    // get the Line Info for the Previous line
    if iPos = 0 then
    begin
      PrevLineInfo := TLineInfo.Create;
      PrevLineInfo.StockCode := 'd$897%!Fy^&ehc,a';
      PrevLineInfo.Operator := 'd$897%!Fy^';
      PrevLineInfo.TillNo := -1;
      PrevLineInfo.Payment := 'X';
    end else
    begin
      PrevLineInfo := TLineInfo(slLines.Objects[iPos -1]);
    end;{if}

    With CurrentLineInfo do begin

      {Get "Left on account" amount }
//      TillTenderTotals.LeftOnAccount := TillTenderTotals.LeftOnAccount + TotalOS;
//      TillTenderTotals.Total := TillTenderTotals.Total + TotalOS;
//      GrandTenderTotals.LeftOnAccount := GrandTenderTotals.LeftOnAccount + TotalOS;
//      GrandTenderTotals.Total := GrandTenderTotals.Total + TotalOS;

      {Get "Settlement Discount Amount}
//      TillTenderTotals.SettlementDiscount := TillTenderTotals.SettlementDiscount + SettDiscAmount;
//      TillTenderTotals.Total := TillTenderTotals.Total + SettDiscAmount;
//      GrandTenderTotals.SettlementDiscount := GrandTenderTotals.SettlementDiscount + SettDiscAmount;
//      GrandTenderTotals.Total := GrandTenderTotals.Total + SettDiscAmount;

      {Increment tender totals}
      if Payment = 'Y' then begin
        AddTenderTotals(TillTenderTotals);
        AddTenderTotals(GrandTenderTotals);
      end;{if}

      PrintTitles;

      {Print record}
      SetRepFont(TheReport, fnMainText, 9);
      PrintStockLine(CurrentLineInfo);

(*      if (StockCode = NextLineInfo.StockCode) and (ConsolidateLines(TLineInfo(slLines.Objects[iPos])
      , NextLineInfo)) {.203} then
        begin
          if Payment = 'N' then
          begin
            if cbConsolidate.Checked then
              begin
                {Consolidate stock line totals}
                rBeforeDisc := DetLTotal(ID,FALSE,FALSE, 0.0) * DocCnst[ID.IDDocHed];
                rAfterDisc := DetLTotal(ID,TRUE,FALSE,0{bSettDiscTaken, rSettDiscPercent}) * DocCnst[ID.IDDocHed];

//                  with StockID do begin
                  Qty := Qty + ID.Qty;

                  NetValue := NetValue + rBeforeDisc;
                  Discount := Discount + (rBeforeDisc - rAfterDisc);

                  VAT := VAT + ID.VAT;

{                      if Qty = 0 then CostPrice := 0
                  else }CostPrice := CostPrice + InvLCost(ID);

                  Consolidate := TRUE; {set for a consolidated line}
//                  end;{with}
              end
            else
          end else begin
            // CostApport holds the "Taken On Account" value
            if Copy(ID.DocPRef,1,3) = 'SRC'
            then TillTotals.CostApport := TillTotals.CostApport + ID.NetValue;
          end;{if}
        end
      else PrintStockLine(TLineInfo(slLines.Objects[iPos]));*)

    end;{with}

    PrintAllTotals;

    if iPos = 0 then PrevLineInfo.Free;

  end;{for}

  {Print Grand Totals}
  if iNoOfTillsDone > 1 then
  begin
    EndOfPageLine(TheReport);
    Print4Totals(GrandTotals, ' (all tills) : ');
    PrintTenderDetails(TRUE, GrandTenderTotals, '(Totals)', GrandTotals);
  end;{if}

  // Tidy Up
  NextLineInfo.Free;
end;





end.
