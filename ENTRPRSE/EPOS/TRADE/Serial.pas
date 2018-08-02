unit Serial;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IAeverButton, EPOSProc, StrUtil, ExtCtrls, TEditVal, DLLInc;

{$I EXDLLBT.INC}

type
  TFrmSerial = class(TForm)
    btnOK: TIAeverButton;
    btnCancel: TIAeverButton;
    lstAvailable: TListBox;
    btnRemove: TIAeverButton;
    btnAdd: TIAeverButton;
    lstUsed: TListBox;
    Label3: TLabel;
    panEditBatch: TPanel;
    btnModBatch: TButton;
    edBatchQty: TCurrencyEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    lRequired: TLabel;
    lPicked: TLabel;
    btnCustom1: TIAeverButton;
    btnCustom2: TIAeverButton;
    lNumUse: TLabel;
    lRemaining: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure MoveItem(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure lstUsedClick(Sender: TObject);
    procedure btnModBatchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure UpdateDisplay;
  public
    rPicked : real;
    rRequired : real;
    sStockCode : String20;
    bRefund : boolean;
  end;

var
  FrmSerial: TFrmSerial;

implementation
uses
  MiscUtil, mathutil, SerialPrc, TXLine, UseDLLU, EPOSKey, EPOSCnst, TXHead, GfxUtil;

{$R *.DFM}

procedure TFrmSerial.UpdateDisplay;
var
  iPos : integer;
begin

  rPicked := GetSerialPicked(lstUsed.Items);
  {update labels}
  lPicked.Caption := 'Picked : ' + MoneyToStr(rPicked, TKSysRec.QuantityDP);
  lRemaining.Caption := 'Remaining : ' + MoneyToStr(rRequired - rPicked, TKSysRec.QuantityDP);

  {update buttons}
  btnAdd.Enabled := lstAvailable.ItemIndex <> -1;
  btnRemove.Enabled := lstUsed.ItemIndex <> -1;
  btnOK.Enabled := AllowedTo(atLeaveSerialNosOutstanding) or (rPicked = rRequired);

  lstUsedClick(lstUsed);
end;

procedure TFrmSerial.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LocalKey : Word;
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
  LocalKey := Key;
  Key := 0;

  {trap function Keys}
  If (LocalKey In [VK_F1..VK_F12]) and (Not (ssAlt In Shift)) then
    begin
      case LocalKey of
//        VK_F1 : Application.HelpCommand(HELP_Finder,0);
        VK_F4 : MoveItem(btnRemove);
        VK_F5 : MoveItem(btnAdd);
        VK_F9 : btnOKClick(btnOK);
        else Key := LocalKey;
      end;{case}
    end
  else Key := LocalKey;
end;

procedure TFrmSerial.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TFrmSerial.MoveItem(Sender: TObject);
var
  iBatchPos, iListPos : integer;
  lstTo, lstFrom : TListBox;
begin

  case TWinControl(Sender).Tag of
    0 : begin {Remove}
      lstFrom := lstUsed;
      lstTo := lstAvailable;
    end;

    1 : begin {add}
      lstFrom := lstAvailable;
      lstTo := lstUsed;
    end;
  end;{case}

  iListPos := lstFrom.ItemIndex;
  iBatchPos := MoveSerialItem(TWinControl(Sender).Tag = 1, lstUsed.Items, lstAvailable.Items, iListPos, rPicked, rRequired);
  lstFrom.ItemIndex := iListPos;

  {set selected position in To list}
  if iBatchPos = -1 then lstTo.itemindex := lstTo.count - 1
  else lstTo.itemindex := iBatchPos;

  UpdateDisplay;

  {set active control}
  if lstFrom.Items.count > 0 then ActiveControl := lstFrom
  else ActiveControl := lstTo;

end;

procedure TFrmSerial.btnOKClick(Sender: TObject);
begin
  if btnOK.Enabled then begin
    if AllowedTo(atLeaveSerialNosOutstanding) and (not zerofloat(rPicked - rRequired)) then
      begin
        if MyMsgBox('The amount of serial numbers that you have input, do not match the amount needed.'
        + #13#13 + 'Do you wish to continue ?',mtConfirmation,[mbYes,mbNo],mbYes,'Serial Numbers') = mrYes
        then ModalResult := mrOK;
      end
    else ModalResult := mrOK;
  end;{if}
end;

procedure TFrmSerial.FormShow(Sender: TObject);
begin

  edBatchQty.displayformat := '#######0.' + StringOfChar('0',TKSysRec.QuantityDP); {cos this gets reset @ run-time - nice}

  lRequired.Caption := 'Required : ' + MoneyToStr(rRequired, TKSysRec.QuantityDP);

  if assigned(FrmTXLine) then
  begin
    BuildSerialAvailableList(sStockCode, bRefund, lstUsed.Items, FrmTXHeader.lvLines
    , FrmTXLine.FormMode, lstAvailable.Items);
  end else
  begin
    BuildSerialAvailableList(sStockCode, bRefund, lstUsed.Items, FrmTXHeader.lvLines
    , fmAdd, lstAvailable.Items);
  end;

  {set list indexes}
  lstAvailable.itemindex := 0;
  lstUsed.itemindex := 0;

  UpdateDisplay;

  if bRefund then lNumUse.Caption := 'Numbers To Un-Use :'
  else lNumUse.Caption := 'Numbers To Use :';

end;

procedure TFrmSerial.FormDestroy(Sender: TObject);
var
  iPos : integer;
begin
  For iPos := 0 to (lstAvailable.Items.Count - 1) do lstAvailable.items.objects[iPos].free;
  For iPos := 0 to (lstUsed.Items.Count - 1) do lstUsed.items.objects[iPos].free;
end;

procedure TFrmSerial.Button1Click(Sender: TObject);
var
  iPos : integer;
begin
  showmessage(MoneyToStr((tserialinfo(lstUsed.items.Objects[lstUsed.ItemIndex]).UsedElsewhere), TKSysRec.QuantityDP));
{  For iPos := 0 to lstAvailable.Items.Count -1 do begin
    with TSerialInfo(lstAvailable.Items.Objects[iPos]) do begin
      if bBatch then begin
        showmessage('UsedInBatch : ' + IntToStr(UsedInBatch) + #13 + 'UsedInThisLine : '
        + IntToStr(UsedInThisLine));
      end;{if}
{    end;{with}
{  end;{for}
end;

procedure TFrmSerial.Button2Click(Sender: TObject);
var
  iPos : integer;
begin
  showmessage(MoneyToStr(tserialinfo(lstAvailable.items.Objects[lstAvailable.ItemIndex]).UsedElsewhere, TKSysRec.QuantityDP));
end;

procedure TFrmSerial.lstUsedClick(Sender: TObject);
begin
  btnModBatch.Enabled := (lstUsed.ItemIndex > -1)
  and (TSerialInfo(lstUsed.Items.Objects[lstUsed.ItemIndex]).bBatch);

  edBatchQty.Enabled := (lstUsed.ItemIndex > -1) and TSerialInfo(lstUsed.Items.Objects[lstUsed.ItemIndex]).bBatch;

  if (lstUsed.ItemIndex > -1) then begin
    with TSerialInfo(lstUsed.Items.Objects[lstUsed.ItemIndex]) do begin
//      if TKSerialRec.Sold then edBatchQty.Text := IntToStr(Round(TKSerialRec.BuyQty - UsedInThisLine))
//      else edBatchQty.Text := IntToStr(UsedInThisLine);
      edBatchQty.Text := MoneyToStr(UsedInThisLine, TKSysRec.QuantityDP);
    end;{with}
  end;{if}
end;

procedure TFrmSerial.btnModBatchClick(Sender: TObject);
var
  iPos : integer;
  bFound : boolean;
  NewSerialInfo, UsedSerialInfo : TSerialInfo;
  rNewQty : real;
begin

  UsedSerialInfo := TSerialInfo(lstUsed.Items.Objects[lstUsed.ItemIndex]);

  with UsedSerialInfo, TKSerialRec do begin

    rNewQty := StrTofloatDef(edBatchQty.Text, 0);
    if Sold then
      begin
        if (rNewQty <= 0) or (rNewQty > QtyUsed) then begin
          {invalid value entered}
          lstUsedClick(lstUsed);
          exit;
        end;{if}
//        UsedInBatch := Round(QtyUsed - rNewQty);
        UsedInBatch := QtyUsed - rNewQty;
      end
    else begin
//      if (rNewQty <= 0) or (rNewQty > Round(BuyQty - QtyUsed - UsedElsewhere)) then begin
      if (rNewQty <= 0) or (rNewQty > (BuyQty - QtyUsed - UsedElsewhere)) then begin
        {invalid value entered}
        lstUsedClick(lstUsed);
        exit;
      end;{if}
//      UsedInBatch := Round(QtyUsed + rNewQty);
      UsedInBatch := QtyUsed + rNewQty;
    end;{if}

    {set new used values}
    UsedInThisLine := rNewQty;

    {update description}
    lstUsed.items[lstUsed.itemindex] := GetSerialDescription(UsedSerialInfo, TRUE);
  end;{with}

  {search Available list for a line for this batch}
  bFound := FALSE;
  For iPos := 0 to lstAvailable.items.Count - 1 do begin
    with TSerialInfo(lstAvailable.items.Objects[iPos]), TKSerialRec do begin
      if (SerialNo = TSerialInfo(lstUsed.Items.Objects[lstUsed.ItemIndex]).TKSerialRec.SerialNo)
      and (BatchNo = TSerialInfo(lstUsed.Items.Objects[lstUsed.ItemIndex]).TKSerialRec.BatchNo)
      and (RecPos = TSerialInfo(lstUsed.Items.Objects[lstUsed.ItemIndex]).TKSerialRec.RecPos)
      then begin

        {batch found}
        bFound := TRUE;

//        if ((not Sold) and (Round(BuyQty - QtyUsed - rNewQty - UsedElsewhere) = 0))
//        or (Sold and (Round(QtyUsed) = rNewQty)) then
        if ((not Sold) and ((BuyQty - QtyUsed - rNewQty - UsedElsewhere) = 0))
        or (Sold and (QtyUsed = rNewQty)) then
          begin
            {all of the batch has been moved to the Used list, so delete the entry in the Available list}
            Free;
            lstAvailable.items.Delete(iPos);
            if (iPos > (lstAvailable.items.Count - 1)) then lstAvailable.Itemindex := lstAvailable.items.Count - 1
            else lstAvailable.Itemindex := iPos;
            Break;
          end
        else begin
          {some of the batch is still available, so edit the quantity in the Available list}
          if Sold then
            begin
//              UsedInBatch := Round(QtyUsed - rNewQty);
              UsedInBatch := QtyUsed - rNewQty;
            end
          else begin
//            UsedInBatch := Round(QtyUsed + rNewQty + UsedElsewhere);
            UsedInBatch := QtyUsed + rNewQty + UsedElsewhere;
          end;{if}

          UsedInThisLine := UsedInBatch;

          lstAvailable.items[iPos] := GetSerialDescription(TSerialInfo(lstAvailable.Items.Objects[iPos])
          , FALSE);
        end;{if}

      end;{if}
    end;{with}
  end;{for}

  {if this batch cannot be found in the available, but we need en entry, then add one}
  with UsedSerialInfo, TKSerialRec do begin
    if ((not bFound) and ((BuyQty - QtyUsed - rNewQty) <> 0) and (not Sold))
    or ((not bFound) and (QtyUsed <> rNewQty) and Sold) then begin
      NewSerialInfo := TSerialInfo.CreateFrom(TKSerialRec, 0);
      with NewSerialInfo, TKSerialRec, lstAvailable do begin
        UsedElsewhere := UsedSerialInfo.UsedElsewhere;

//        if Sold then UsedInBatch := Round(QtyUsed - rNewQty)
//        else UsedInBatch := Round(QtyUsed + rNewQty);
        if Sold then UsedInBatch := QtyUsed - rNewQty
        else UsedInBatch := QtyUsed + rNewQty;

        UsedInThisLine := UsedInBatch;
        Items.AddObject(GetSerialDescription(NewSerialInfo, FALSE), NewSerialInfo);
        itemindex := items.Count - 1;
      end;{with}
    end;{if}
  end;{with}

  UpdateDisplay;

end;

procedure TFrmSerial.FormCreate(Sender: TObject);
begin
  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);
end;

end.
