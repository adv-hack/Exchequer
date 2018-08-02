unit BillSplt;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, TEditVal, Mask, EXWrap1u, GlobVar
  , VarConst, CardProc, NeilProc, BTList, SBSComp, BTKeys1u, BillDet, BTSupU1,
  Menus, BtrvU2, ETDateU, ETStrU, APIUtil, StrUtil, TCustom;

const
  OpMode = 2;
  RoundDecs = 2;

type
  TCardList  =  class(TMULCtrl)
    public
      ListExLocal : TdExLocalPtr;
      function SetCheckKey : Str255; override;
      function SetFilter : Str255; override;
      function OutLine(Col : Byte) : Str255; override;
  end;

  TFrmBillSplit = class(TForm)
    sbCards: TScrollBox;
    panCardNo: TSBSPanel;
    panName: TSBSPanel;
    panTitle: TSBSPanel;
    panCardNoTit: TSBSPanel;
    panNameTit: TSBSPanel;
    panDiscTit: TSBSPanel;
    panBalTit: TSBSPanel;
    panAmountTit: TSBSPanel;
    panDiscount: TSBSPanel;
    panBalance: TSBSPanel;
    panAmount: TSBSPanel;
    panScrollBar: TSBSPanel;
    panButtons: TSBSPanel;
    sbButtons: TScrollBox;
    btnDelete: TSBSButton;
    btnAdd: TSBSButton;
    btnEdit: TSBSButton;
    btnProcess: TSBSButton;
    btnLClose: TSBSButton;
    pmMain: TPopupMenu;
    sbHeader: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edComment: Text8Pt;
    lInvoiceNo: TLabel;
    lCardNo: TLabel;
    lName: TLabel;
    edAmount: TCurrencyEdit;
    lCardDisc: TLabel;
    lTotalAmount: TLabel;
    lUnallocated: TLabel;
    lTotalDisc: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure edAmountExit(Sender: TObject);
    procedure panNameTitMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure panNameTitMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure panCardNoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnProcessClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    FormStuff : TFormStuff;
    ExLocal : TdExLocal;
    bProcessed : boolean;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure WMCustGetRec(var message : TMessage); message WM_CustGetRec;
    procedure WMFormCloseMsg(var message : TMessage); message WM_FormCloseMsg;
    Procedure DeleteRecs (DelKey : String);
  public
    TotalBill,   { Total value of bill incl disc }
    CardAmount,  { Amount allocated to main card }
    TotalDebits, { Total of amounts allocated to cards }
    TotalDisc,   { Total discount on bill }
    CardDisc,    { Discount allocated to main card }
    TotDisc,     { unallocated discount }
    TotalVAT,    { Total VAT on bill }
    CardVAT,     { VAT allocated to main card }
    TotVat       { unallocated VAT } : Real;
    TotCardNo                                      : String [6];
    TotCardName                                    : String [30];
    InvOurRef, DefDescription                      : String [10];
    Procedure DisplayUnallocated;
    Function GetUnallocated : Real;
    { Public declarations }
  end;

{var
  FrmBillSplit: TFrmBillSplit;}

implementation

uses FuncDet, Reports;

{$R *.DFM}

function TCardList.SetCheckKey : Str255;
Begin
  Result := FullCustCode(Inv.CustCode);
End;

function TCardList.SetFilter  :  Str255;
begin
  Result := '';{must set this to '' for no filtering}
end;

function TCardList.OutLine(Col : Byte) : Str255;
Begin { DispLine }
  with Inv do begin
    if ListExLocal.LCust.CustCode <> Inv.FBookCust then begin
      ListExLocal.AssignFromGlobal(InvF);
      GetCustFromInv(ListExLocal^, TRUE);
    end;{if}

    case Col of
      0  : OutLine := ListExLocal.LCust.CustCode;  {Cust Code}
      1  : OutLine := CardFullName(ListExLocal.LCust, True, True);{Members Name}
      2  : OutLine := MoneyToStr(ListExLocal.LCust.CurrBalance); {Balance}
      3  : OutLine := MoneyToStr(InvNetVal); {Amount}
      4  : OutLine := MoneyToStr(DiscAmount); {Discount}
    else OutLine := '';
    end;{case}
  end;{with}
End;  { DispLine }

procedure TFrmBillSplit.FormCreate(Sender: TObject);
begin
  bProcessed := FALSE;
  ExLocal.Create;
  DeleteRecs (MainBillSplitK);
  DeleteRecs (BillSplitCreditKey);
  edAmount.displayformat := '#######0.00';
  with ExLocal do begin
    LCust := Cust;
    LInv := Inv;
    LGetRecAddr(CustF);
    LGetRecAddr(InvF);

    with LInv do begin
      lInvoiceNo.Caption := OurRef;
      lCardNo.Caption := LCust.CustCode;
      lName.Caption := CardFullName(LCust, True, True);
      lTotalDisc.Caption := MoneyToStr(DiscAmount);
      lTotalAmount.Caption := MoneyToStr(InvNetVal);

      { Initialise fields }
      InvOurRef      := '';
      TotCardNo      := LCust.CustCode;
      TotCardName    := '';
      DefDescription := '';
      TotalBill      := InvNetVal;
      TotalDebits    := 0;
      TotalDisc      := ABS(DiscAmount);
      CardAmount     := 0;
      CardDisc       := 0;
      TotalVAT       := InvVAT;
      CardVat        := 0;
      TotVat         := 0;
    end;{with}
  end;{with}


  FormStuff := TFormStuff.Create(1);

  {set default size}
  ClientHeight := 393;
  ClientWidth := 542;
  with FormStuff do begin
    {set up an array of columns}
    bFillList := TRUE;
    SetLength(aColumns[0],5);
    aColumns[0,0].ColPanel := panCardNo;
    aColumns[0,0].HeadPanel := panCardNoTit;
    aColumns[0,1].ColPanel := panName;
    aColumns[0,1].HeadPanel := panNameTit;
    aColumns[0,2].ColPanel := panBalance;
    aColumns[0,2].HeadPanel := panBalTit;
    aColumns[0,2].DecPlaces := 2;
    aColumns[0,3].ColPanel := panAmount;
    aColumns[0,3].HeadPanel := panAmountTit;
    aColumns[0,3].DecPlaces := 2;
    aColumns[0,4].ColPanel := panDiscount;
    aColumns[0,4].HeadPanel := panDiscTit;
    aColumns[0,4].DecPlaces := 2;

    aFileNos[0] := InvF;
    asbMain[0] := sbCards;
    acPrimeKeys[0] := 'A';
    apanTitle[0] := panTitle;
    asbButtons[0] := sbButtons;
    apanButtons[0] := panButtons;
    aMULCtrlO[0] := TCardList.Create(Self);{creates control object}
    (aMULCtrlO[0] as TCardList).ListExLocal := @ExLocal;
    apanScrollBar[0] := panScrollBar;
    aCaseSensSearch[0] := TRUE;
    aiKeys[0] := InvCustK;
    asStartKeys[0] := MainBillSplitK;

    ReadFormProperties(Self, FormStuff);
    aMULCtrlO[0].ReColorBar(panScrollBar.Font,$00004A4A);
    DoFormResize(Self, FormStuff);
  end;{with}

  DisplayUnallocated;
end;

Procedure TFrmBillSplit.DisplayUnallocated;
Begin
  { Display Unallocated }
  lUnallocated.Caption := MoneyToStr(GetUnallocated);

  { Display Card discount }
  lCardDisc.Caption := MoneyToStr(CardDisc);
End;

Function TFrmBillSplit.GetUnallocated : Real;
Begin
  GetUnallocated := Round_Up (TotalBill - CardAmount - TotalDebits, RoundDecs);
End;

procedure TFrmBillSplit.edAmountExit(Sender: TObject);
var
  iTotal, iNewTotal : double;
begin
  CardAmount := StrToFloat(edAmount.Text);
  If (CardAmount >= 0) then begin
    iTotal := Round(TotalBill * 100);
    iNewTotal := Round((CardAmount + TotalDebits) * 100);
    if (iTotal >= iNewTotal) then
      Begin
        TotDisc  := TotDisc - CardDisc;
        CardDisc := Round_Up ((CardAmount / TotalBill) * TotalDisc, 2);
        TotDisc  := TotDisc + CardDisc;

        TotVAT  := TotVAT - CardVAT;
        CardVAT := Round_Up ((CardAmount / TotalBill) * TotalVAT, 2);
        TotVAT  := TotVAT + CardVAT;

        DisplayUnallocated;

        btnProcess.Enabled := (PenceIt(TotalDebits + CardAmount) = PenceIt(TotalBill));
      end
    else ActiveControl := edAmount;
  end;{if}
end;

procedure TFrmBillSplit.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 330;
    ptMinTrackSize.Y := 307;
  end;{with}
  Message.Result := 0;
  inherited;
end;

procedure TFrmBillSplit.WMFormCloseMsg(var Message : TMessage);
{receive a message that a child window has closed}
begin
  with Message do begin
    case WParam of
      {Details Form Close}
      1 : {FrmBillSplitDetails := nil};

      {List Click (deferred from WMCustGetRec for mousey reasons)}
      1001 : begin
{        bValidLine := FormStuff.aMulCtrlO[0].ValidLine;
        if bValidLine then begin

          {Get local copy of global record}
{          ExLocal.AssignFromGlobal(CustF);
          ExLocal.LGetRecAddr(CustF);}

          {Update details window}
{          if (FrmBillSplitDetails <> nil) then begin
            with FrmFunctionDetails do begin
              if (not ExLocal.InAddEdit) then UpdateDetails(TRUE);
            end;{with}
{          end;{if}
{        end;{if}
      end;
    end;{case}
  end;{with}
  inherited;
end;

procedure TFrmBillSplit.WMCustGetRec(var Message  :  TMessage);
{Receive message that a List Action has occured}
begin
  with Message do begin
    case WParam of
      {List Double Click}
      0 : btnAddClick(btnEdit);

      {List Click}
      1 : PostMessage(Self.Handle,WM_FormCloseMsg,1001,0); {* This was placed here to stop the mouse up event from being corrupted *}

      {List Right Click}
      2 : begin
        {SaveOnExit.Checked := FormStuff.bStoreCoord;}
        pmMain.Popup(lParamLo,lParamHi);
      end;

      {Update List Item}
      200 : FormStuff.aMULCtrlO[0].AddNewRow(FormStuff.aMULCtrlO[0].MUListBoxes[0].Row,FALSE);

      {Re-Read List}
      201 : FormStuff.aMULCtrlO[0].InitPage;
    end;{case}
  end;{with}
  inherited;
end;

procedure TFrmBillSplit.panNameTitMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {depresses the column header}
  if (Sender is TSBSPanel) and (not TSBSPanel(Sender).ReadytoDrag) and (Button = MBLeft)
  then FormStuff.aMULCtrlO[0].VisiList.PrimeMove(Sender); {begin column drag/drop}
end;

procedure TFrmBillSplit.panNameTitMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  {visually moves column header to show the change about to be made (drag/drop}
  if (Sender is TSBSPanel) then FormStuff.aMULCtrlO[0].VisiList.MoveLabel(X,Y);
end;

procedure TFrmBillSplit.panCardNoMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TSBSPanel) then DoMoveAlignCols(TSBSPanel(Sender), FormStuff, 0);
end;

procedure TFrmBillSplit.FormResize(Sender: TObject);
begin
  sbHeader.Width := ClientWidth - 16;
  DoFormResize(Self, FormStuff);
end;

procedure TFrmBillSplit.FormDestroy(Sender: TObject);
begin
  FormStuff.Free;
  ExLocal.Destroy;
end;

procedure TFrmBillSplit.btnAddClick(Sender: TObject);
var
  FrmBillSplitDetails : TFrmBillSplitDetails;
  NewMode : TFormMode;
begin
  NewMode := TFormMode(TWinControl(Sender).Tag);
  if ((NewMode = fmAdd) and (PenceIt(TotalDebits + CardAmount) <> PenceIt(TotalBill)))
  or ((NewMode = fmEdit) and (FormStuff.aMulCtrlO[0].ValidLine)) then begin
    FrmBillSplitDetails := TFrmBillSplitDetails.Create(self);
    try
      FrmBillSplitDetails.FormMode := NewMode;
      if FrmBillSplitDetails.ShowModal = mrOK then begin
        DisplayUnallocated;
        FormStuff.aMULCtrlO[0].AddNewRow(FormStuff.aMULCtrlO[0].MUListBoxes[0].Row,FALSE);
        btnProcess.Enabled := (PenceIt(TotalDebits + CardAmount) = PenceIt(TotalBill));
      end;{if}
    finally
      FrmBillSplitDetails.Release;
    end;{try}
  end;{if}
end;

Procedure TFrmBillSplit.DeleteRecs(DelKey : String);
Var
  Key2F       : Str255;
  iStatus : smallint;
Begin { DeleteRecs }
  Key2F := DelKey;
  with ExLocal do begin
    iStatus := Find_Rec(B_GetGEq, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, Key2F);
    ExLocal.LGetRecAddr(InvF);
    While (iStatus = 0) And (LInv.CustCode = DelKey) Do Begin
      { Reget record an lock it }

      if LockRecord(InvF, InvCustK, ExLocal, TRUE) Then Begin
        { Delete Database }
        iStatus := Delete_Rec(F[InvF], InvF, InvCustK);

        { Report any btrieve problems }
        Report_BError(InvF, iStatus);
      End; { If }

      { Find next }
      iStatus := Find_Rec (B_GetGEq, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, Key2F);
      ExLocal.LGetRecAddr(InvF);
    End; { While }
  end;{if}
End;  { DeleteRecs }


procedure TFrmBillSplit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := FALSE;
  if bProcessed or (MsgBox('Are you sure you want to abort this bill splitting ?',mtConfirmation, [mbYes, mbNo]
  , mbNo, 'Abort ?') = mrYes) then begin
    CanClose := TRUE;

    if not bProcessed then begin
      DeleteRecs (MainBillSplitK);
      DeleteRecs (BillSplitCreditKey);
    end;{if}

    Application.ProcessMessages; {so it doesn't crash hideously !}
    with FormStuff do begin
      StoreFormProperties(Self, OpMode, bStoreCoord, bSetDefaults, bLastCoord
      , apanTitle, aMULCtrlO, acPrimeKeys);
    end;{with}
  end;{if}
  if bProcessed then ModalResult := mrOK; 
end;

procedure TFrmBillSplit.btnProcessClick(Sender: TObject);
Var
  TheKey : Str255;
  iStatus : smallint;
  iRecAddr : integer;
Begin
  if (MsgBox('Are you sure you want to process this bill split ?',mtConfirmation,[mbYes, mbNo]
  , mbNo, 'Process ?') = mrYes) then begin
    screen.cursor := crHourglass;

    bProcessed := TRUE;

    with ExLocal, LInv do begin

      {Create Implied}

      { Build key }
      Blank (TheKey, Sizeof(TheKey));
      TheKey := MainBillSplitK;
      iStatus := Find_Rec (B_GetGEq, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, TheKey);
      LGetRecAddr(InvF);

      While (iStatus = 0) And (LInv.CustCode = MainBillSplitK) Do begin

        if LockRecord(InvF, InvCustK, ExLocal, TRUE) then begin

          { need to update current invoice with transdesc }
          If TrimString(psRight, edComment.Text, ' ') = '' Then TransDesc := 'Credit to ' + TotCardNo
          Else TransDesc := edComment.Text;

          { Set amount as debit }
          InvNetVal  := -Abs (InvNetVal);
          SepDisc := True;

          iStatus := Put_Rec(F[InvF], InvF, LRecPtr[InvF]^, InvCustK);
          Report_BError(InvF, iStatus);
          LockRecord(InvF, InvCustK, ExLocal, FALSE)
        End; { If }

        { Check we got someone to credit }
        If (iStatus = 0) Then Begin

          { reset invoice description }
          If TrimString(psRight, edComment.Text, ' ') = '' Then TransDesc := 'Credit from ' + FBookCust
          Else TransDesc := edComment.Text;

          { Reset Cust code }
          CustCode := BillSplitCreditKey;
          FBookCust := TotCardNo;

          { set amount as credit }
          InvNetVal  := Abs(InvNetVal);
          DiscAmount := -DiscAmount;
          SepDisc    := True;

          { Add VAT paid back onto main card }
          InvVAT := -InvVAT;

          { Reset OurRef and FolioNum }
          {$IFDEF Ex_On}
            SetNextDocNos (LInv, TRUE);
          {$ELSE}
            FolioNum := Syss.Dummyfolio;
            Inc (Syss.Dummyfolio);
            PutMultiSys;
          {$ENDIF}


          { Store the position }
          GetPos(F[InvF], InvF, iRecAddr);

          { Insert new invoice }
          iStatus := Add_Rec(F[InvF], InvF, LRecPtr[InvF]^, InvCustK);

          { Report any btrieve problems }
          Report_BError(InvF, iStatus);

          {Go Back to previous pos}
          LSetDataRecOfs(InvF, iRecAddr);
          GetDirect (F[InvF], InvF, LRecPtr[InvF]^, InvCustK, 0);
        End; { If }

        { Try to get next record }
        iStatus := Find_Rec (B_GetNext, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, TheKey);
        LGetRecAddr(InvF);
      end;{while}

      {Print Report}
      ModReports.PrintBillSplit;
    end;{with}
    screen.cursor := crDefault;
    Close;
  end;{if}
End;

procedure TFrmBillSplit.btnDeleteClick(Sender: TObject);
var
  iStatus : smallint;
begin
  if FormStuff.aMulCtrlO[0].ValidLine and (msgBox('Are you sure you want to delete this card from this list ?',mtConfirmation
  ,[mbYes,mbNo],mbNo,'Delete Card') = mrYes) and LockRecord(CustF, CustCodeK
  , ExLocal, TRUE) then begin
    screen.cursor := crHourglass;
    {delete Card Record}
    ExLocal.AssignFromGlobal(InvF);
    ExLocal.LGetRecAddr(InvF);

    TotalDebits := Round_Up(TotalDebits - Inv.InvNetVal, RoundDecs);
    if LockRecord(InvF, InvCustK, ExLocal, TRUE) then iStatus := Delete_Rec(F[InvF],InvF,InvCustK);
    If (Status <> 0) Then TotalDebits := Round_Up(TotalDebits + Inv.InvNetVal, RoundDecs);
    Report_BError(InvF, iStatus);
    FormStuff.aMULCtrlO[0].InitPage;
    DisplayUnallocated;

    screen.cursor := crDefault;
  end;{if}
end;

end.
