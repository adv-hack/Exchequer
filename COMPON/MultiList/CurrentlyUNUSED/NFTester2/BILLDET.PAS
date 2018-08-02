unit Billdet;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, BTSupU1, TEditVal, Mask, ExtCtrls, ComCtrls, NeilProc,
  SBSPanel, BorBtns, ExWrap1U, VarConst, ETStrU, AdPacket, OoMisc, AdPort,
  MPComms, BTList, SBSComp, GlobVar, ETDateU, CardProc, BTKeys1U, BTrvU2
  ,TXDetail, Menus, IniFiles, StrUtil, TCustom;

type
  TFrmBillSplitDetails = class(TForm)
    btnDOK: TSBSButton;
    btnDCancel: TSBSButton;
    lName: TLabel;
    edCardNo: Text8Pt;
    Label14: TLabel;
    Label5: TLabel;
    Label15: TLabel;
    lCurrentBalance: TLabel;
    edCardAmount: TCurrencyEdit;
    Label18: TLabel;
    lDiscount: TLabel;
    lDiscAmount: TLabel;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure btnDCloseClick(Sender: TObject);
    procedure btnDCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edCardNoExit(Sender: TObject);
    procedure edCardAmountExit(Sender: TObject);
    procedure btnDOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    OrigVal, OrigVat, OrigDisc : Real;
    function SaveCardDetails : boolean;
    Procedure Form2Bill;
    procedure Bill2Form;
    procedure FillCustDetails(CustR : CustRec);
  public
    FormMode : TFormMode;
    ExLocal : TdExLocal;
  end;

implementation

uses Cardlist, Comms, FindCard, BillSplt, MainF;

{$R *.DFM}


{TFrmCardDetails}

procedure TFrmBillSplitDetails.FormCreate(Sender: TObject);
begin
  edCardAmount.displayformat := '#######0.00';

  ExLocal.Create; {create local record instance for independant data manipulation}

  {set default size}
  ClientHeight := 192;
  ClientWidth := 280;
end;

procedure TFrmBillSplitDetails.btnDCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmBillSplitDetails.btnDCancelClick(Sender: TObject);
begin
  if (FormMode = fmEdit) then LockRecord(InvF, InvCustK, ExLocal, FALSE);
end;


procedure TFrmBillSplitDetails.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;
end;

function TFrmBillSplitDetails.SaveCardDetails : boolean;
begin
  Form2Bill;
  with ExLocal, LInv do begin
    if not CardExists(edCardNo.Text) then
      begin
        MessageDlg('You have not picked a valid card',mtWarning,[mbOk],0);
        Result := FALSE;
      end
    else begin
      if StrToFloat(edCardAmount.Text) <= 0 then
        begin
          MessageDlg('You need to input a positive amount.',mtWarning,[mbOk],0);
          Result := FALSE;
        end
      else begin
        Result := TRUE;
        {save record}
        case FormMode of
          fmEdit : begin
            SaveRecord(InvF, ExLocal);
            LockRecord(InvF, InvCustK, ExLocal, FALSE);
            with FrmMain.FrmBillSplit do begin
              TotalDebits := Round_Up (TotalDebits + InvNetVal - OrigVal, RoundDecs);
              TotDisc     := Round_Up (TotDisc + Discount - OrigDisc, RoundDecs);
            end;{with}
          end;

          fmAdd : begin
            Source := isBillSplit;
            CustCode := MainBillSplitK;
            OurRef := 'BSP/' + SetPadNo(Form_Int(Syss.BookCount, 0), 6);
            FolioNum := -Syss.BookCount;
            RunNo := -1;

            ILineCount := 1;
            TransDate := Today;

            { Invoice Header }
            If (Syss.VatMode = vmAdv) Then InvDocHed := SRI
            Else InvDocHed := NMT;

            { Payment Type }
            PayType := PayTypes [4]; { Forfeit }

            AddRecord(InvF, ExLocal);{Write to database}

            IncBookCount;

            with FrmMain.FrmBillSplit do begin
              TotalDebits := Round_Up (TotalDebits + InvNetVal, RoundDecs);
              TotDisc     := Round_Up (TotDisc + Discount, RoundDecs);
            end;{with}
          end;
        end;{case}
      end;{if}
    end;{if}
  end;{with}
end;

procedure TFrmBillSplitDetails.Form2Bill;
{Copies the values on the screen into the local record instance}
begin
  with ExLocal, LInv do begin
    if FormMode = fmAdd then LResetRec(InvF);
    CustCode := MainBillSplitK;
    FBookCust := PadString(psRight, edCardNo.Text, ' ', CardKeyLen);
    InvNetVal := StrToFloat(edCardAmount.Text);
    DiscAmount := StrToFloat(lDiscAmount.Caption);
  end;{with}
end;

procedure TFrmBillSplitDetails.Bill2Form;
{fills controls from local record instance}
begin
  with ExLocal, LInv do begin
    if CustCode <> '' then begin
      GetCustFromInv(ExLocal, TRUE);
      FillCustDetails(LCust);
    end;{if}
    edCardAmount.Text := MoneyToStr(InvNetVal);
    lDiscAmount.Caption := MoneyToStr(DiscAmount);
  end;{with}
end;

procedure TFrmBillSplitDetails.edCardNoExit(Sender: TObject);
begin
  if (ActiveControl <> btnDCancel) then begin
    if CardExists(edCardNo.Text) then FillCustDetails(Cust){found}
    else FillCustDetails(DoFindCard(UpperCase(edCardNo.Text)));{not found}
  end;{if}
end;

procedure TFrmBillSplitDetails.FillCustDetails(CustR : CustRec);
begin
  with CustR do begin
    if CustCode <> '' then begin
      edCardNo.Text := CustCode;
      lName.Caption := CardFullName(CustR, True, True);{Members Name}
      lCurrentBalance.Caption := MoneyToStr(CurrBalance);
      if CustR.CurrBalance > 0 then lCurrentBalance.Font.Color := clRed
      else lCurrentBalance.Font.Color := $00004A4A;
    end;{if}
  end;{with}
end;

procedure TFrmBillSplitDetails.edCardAmountExit(Sender: TObject);
begin
  if ActiveControl <> btnDCancel then begin
    with FrmMain.FrmBillSplit, ExLocal, LInv do begin
      InvNetVal := Round_Up(StrToFloat(TrimString(psRight, edCardAmount.Text, ' ')), RoundDecs);
      { Check amount is > 0, and it is <= amount to be allocated }
      If (InvNetVal > 0) And (Round_Up(Round_Up(GetUnallocated,RoundDecs)
      + Round_Up(OrigVal,RoundDecs),RoundDecs) >= Round_Up(InvNetVal,2)) Then
        Begin
          { Calculate Discount }
          DiscAmount := Round_Up ((InvNetVal / TotalBill) * TotalDisc, 2);

          If (Round((TotDisc + DiscAmount - OrigDisc) * 100) > Round(TotalDisc * 100)) Then DiscAmount := (TotDisc + DiscAmount - OrigDisc);

          { Calculate VAT }
          InvVAT := Round_Up ((InvNetVal / TotalBill) * TotalVAT, 2);
          If ((TotVAT + InvVAT - OrigVAT) > TotalVAT) Then InvVAT := (TotVAT + InvVAT - OrigVAT);
          lDiscAmount.Caption := MoneyToStr(DiscAmount);
        end
      else Self.ActiveControl := edCardAmount;
    end;{with}
  end;{if}
end;

procedure TFrmBillSplitDetails.btnDOKClick(Sender: TObject);
begin
  SaveCardDetails;
end;

procedure TFrmBillSplitDetails.FormShow(Sender: TObject);
begin
  case FormMode of
    fmAdd : begin
      OrigVal  := 0;
      OrigDisc := 0;
      OrigVat  := 0;
    end;{if}

    fmEdit : begin
      ExLocal.AssignFromGlobal(InvF);
      ExLocal.LGetRecAddr(InvF);
      if LockRecord(InvF, InvCustK, ExLocal, TRUE) then Bill2Form;
      OrigVal  := Round_Up(Inv.InvNetVal, RoundDecs);
      OrigDisc := Round_Up(Inv.DiscAmount, RoundDecs);
      OrigVat  := Round_Up(Inv.InvVat, RoundDecs);
    end;
  end;{if}
end;

end.

