unit MultiBins;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IAeverButton, EPOSProc, StrUtil, ExtCtrls, TEditVal, DLLInc;

{$I EXDLLBT.INC}

type
  TfrmMultiBins = class(TForm)
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
    iStockFolio : integer;
    bRefund : boolean;
  end;

var
  frmMultiBins: TfrmMultiBins;

implementation
uses
  MiscUtil, mathutil, MultiBinPrc, TXLine, UseDLLU, EPOSKey, EPOSCnst, TXHead, GfxUtil;

{$R *.DFM}

procedure TfrmMultiBins.UpdateDisplay;
var
  iPos : integer;
begin

  rPicked := GetBinPicked(lstUsed.Items);
  {update labels}
  lPicked.Caption := 'Picked : ' + MoneyToStr(rPicked, TKSysRec.QuantityDP);
  lRemaining.Caption := 'Remaining : ' + MoneyToStr(rRequired - rPicked, TKSysRec.QuantityDP);

  {update buttons}
  btnAdd.Enabled := lstAvailable.ItemIndex <> -1;
  btnRemove.Enabled := lstUsed.ItemIndex <> -1;
  btnOK.Enabled := AllowedTo(atLeaveBinsOutstanding) or (rPicked = rRequired);

  lstUsedClick(lstUsed);
end;

procedure TfrmMultiBins.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmMultiBins.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TfrmMultiBins.MoveItem(Sender: TObject);
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
  iBatchPos := MoveBinItem(TWinControl(Sender).Tag = 1, lstUsed.Items, lstAvailable.Items, iListPos, rPicked, rRequired);
  lstFrom.ItemIndex := iListPos;

  {set selected position in To list}
  if iBatchPos = -1 then lstTo.itemindex := lstTo.count - 1
  else lstTo.itemindex := iBatchPos;

  UpdateDisplay;

  {set active control}
  if lstFrom.Items.count > 0 then ActiveControl := lstFrom
  else ActiveControl := lstTo;

end;

procedure TfrmMultiBins.btnOKClick(Sender: TObject);
begin
  if btnOK.Enabled then begin
    if AllowedTo(atLeaveBinsOutstanding) and (not zerofloat(rPicked - rRequired)) then
      begin
        if MyMsgBox('The amount of Bin numbers that you have input, do not match the amount needed.'
        + #13#13 + 'Do you wish to continue ?',mtConfirmation,[mbYes,mbNo],mbYes,'Bin Numbers') = mrYes
        then ModalResult := mrOK;
      end
    else ModalResult := mrOK;
  end;{if}
end;

procedure TfrmMultiBins.FormShow(Sender: TObject);
begin

  edBatchQty.displayformat := '#######0.' + StringOfChar('0',TKSysRec.QuantityDP); {cos this gets reset @ run-time - nice}

  lRequired.Caption := 'Required : ' + MoneyToStr(rRequired, TKSysRec.QuantityDP);

  if assigned(FrmTXLine) then
  begin
    BuildBinAvailableList(iStockFolio, bRefund, lstUsed.Items, FrmTXHeader.lvLines
    , FrmTXLine.FormMode, lstAvailable.Items);
  end else
  begin
    BuildBinAvailableList(iStockFolio, bRefund, lstUsed.Items, FrmTXHeader.lvLines
    , fmAdd, lstAvailable.Items);
  end;{if}

  {set list indexes}
  lstAvailable.itemindex := 0;
  lstUsed.itemindex := 0;

  UpdateDisplay;

  if bRefund then lNumUse.Caption := 'Bins To Un-Use :'
  else lNumUse.Caption := 'Bins To Use :';

end;

procedure TfrmMultiBins.FormDestroy(Sender: TObject);
var
  iPos : integer;
begin
  For iPos := 0 to (lstAvailable.Items.Count - 1) do lstAvailable.items.objects[iPos].free;
  For iPos := 0 to (lstUsed.Items.Count - 1) do lstUsed.items.objects[iPos].free;
end;

procedure TfrmMultiBins.Button1Click(Sender: TObject);
var
  iPos : integer;
begin
  showmessage(MoneyToStr((tBininfo(lstUsed.items.Objects[lstUsed.ItemIndex]).UsedElsewhere), TKSysRec.QuantityDP));
{  For iPos := 0 to lstAvailable.Items.Count -1 do begin
    with TBinInfo(lstAvailable.Items.Objects[iPos]) do begin
      if bBatch then begin
        showmessage('UsedInBatch : ' + IntToStr(UsedInBatch) + #13 + 'UsedInThisLine : '
        + IntToStr(UsedInThisLine));
      end;{if}
{    end;{with}
{  end;{for}
end;

procedure TfrmMultiBins.Button2Click(Sender: TObject);
var
  iPos : integer;
begin
  showmessage(MoneyToStr(tBininfo(lstAvailable.items.Objects[lstAvailable.ItemIndex]).UsedElsewhere, TKSysRec.QuantityDP));
end;

procedure TfrmMultiBins.lstUsedClick(Sender: TObject);
begin
  btnModBatch.Enabled := (lstUsed.ItemIndex > -1);
//  and (TBinInfo(lstUsed.Items.Objects[lstUsed.ItemIndex]).bBatch);

//  edBatchQty.Enabled := (lstUsed.ItemIndex > -1) and TBinInfo(lstUsed.Items.Objects[lstUsed.ItemIndex]).bBatch;
  edBatchQty.Enabled := (lstUsed.ItemIndex > -1);

  if (lstUsed.ItemIndex > -1) then begin
    with TBinInfo(lstUsed.Items.Objects[lstUsed.ItemIndex]) do begin
//      if TKBinRec.Sold then edBatchQty.Text := IntToStr(Round(TKBinRec.BuyQty - UsedInThisLine))
//      else edBatchQty.Text := IntToStr(UsedInThisLine);
      edBatchQty.Text := MoneyToStr(UsedInThisLine, TKSysRec.QuantityDP);
    end;{with}
  end;{if}
end;

procedure TfrmMultiBins.btnModBatchClick(Sender: TObject);
var
  iPos : integer;
  bFound : boolean;
  NewBinInfo, UsedBinInfo : TBinInfo;
  rNewQty : real;
begin

  UsedBinInfo := TBinInfo(lstUsed.Items.Objects[lstUsed.ItemIndex]);

  with UsedBinInfo, TKBinRec do begin

    rNewQty := StrTofloatDef(edBatchQty.Text, 0);
    if brSold then
      begin
        if (rNewQty <= 0) or (rNewQty > brQtyUsed) then begin
          {invalid value entered}
          lstUsedClick(lstUsed);
          exit;
        end;{if}
//        UsedInBatch := Round(QtyUsed - rNewQty);
        UsedInBatch := brQtyUsed - rNewQty;
      end
    else begin
//      if (rNewQty <= 0) or (rNewQty > Round(BuyQty - QtyUsed - UsedElsewhere)) then begin
      if (rNewQty <= 0) or (rNewQty > (brQty - brQtyUsed - UsedElsewhere)) then begin
        {invalid value entered}
        lstUsedClick(lstUsed);
        exit;
      end;{if}
//      UsedInBatch := Round(QtyUsed + rNewQty);
      UsedInBatch := brQtyUsed + rNewQty;
    end;{if}

    {set new used values}
    UsedInThisLine := rNewQty;

    {update description}
    lstUsed.items[lstUsed.itemindex] := GetBinDescription(UsedBinInfo, TRUE);
  end;{with}

  {search Available list for a line for this batch}
  bFound := FALSE;
  For iPos := 0 to lstAvailable.items.Count - 1 do begin
    with TBinInfo(lstAvailable.items.Objects[iPos]), TKBinRec do begin
      if (brBinCode = TBinInfo(lstUsed.Items.Objects[lstUsed.ItemIndex]).TKBinRec.brBinCode)
//      and (BatchNo = TBinInfo(lstUsed.Items.Objects[lstUsed.ItemIndex]).TKBinRec.BatchNo)
      and (brRecPos = TBinInfo(lstUsed.Items.Objects[lstUsed.ItemIndex]).TKBinRec.brRecPos)
      then begin

        {batch found}
        bFound := TRUE;

//        if ((not Sold) and (Round(BuyQty - QtyUsed - rNewQty - UsedElsewhere) = 0))
//        or (Sold and (Round(QtyUsed) = rNewQty)) then
        if ((not brSold) and ((brQty - brQtyUsed - rNewQty - UsedElsewhere) = 0))
        or (brSold and (brQtyUsed = rNewQty)) then
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
          if brSold then
            begin
//              UsedInBatch := Round(QtyUsed - rNewQty);
              UsedInBatch := brQtyUsed - rNewQty;
            end
          else begin
//            UsedInBatch := Round(QtyUsed + rNewQty + UsedElsewhere);
            UsedInBatch := brQtyUsed + rNewQty + UsedElsewhere;
          end;{if}

          UsedInThisLine := UsedInBatch;

          lstAvailable.items[iPos] := GetBinDescription(TBinInfo(lstAvailable.Items.Objects[iPos])
          , FALSE);
        end;{if}

      end;{if}
    end;{with}
  end;{for}

  {if this batch cannot be found in the available, but we need en entry, then add one}
  with UsedBinInfo, TKBinRec do begin
    if ((not bFound) and ((brQty - brQtyUsed - rNewQty) <> 0) and (not brSold))
    or ((not bFound) and (brQtyUsed <> rNewQty) and brSold) then begin
      NewBinInfo := TBinInfo.CreateFrom(TKBinRec, 0);
      with NewBinInfo, TKBinRec, lstAvailable do begin
        UsedElsewhere := UsedBinInfo.UsedElsewhere;

//        if Sold then UsedInBatch := Round(QtyUsed - rNewQty)
//        else UsedInBatch := Round(QtyUsed + rNewQty);
        if brSold then UsedInBatch := brQtyUsed - rNewQty
        else UsedInBatch := brQtyUsed + rNewQty;

        UsedInThisLine := UsedInBatch;
        Items.AddObject(GetBinDescription(NewBinInfo, FALSE), NewBinInfo);
        itemindex := items.Count - 1;
      end;{with}
    end;{if}
  end;{with}

  UpdateDisplay;

end;

procedure TfrmMultiBins.FormCreate(Sender: TObject);
begin
  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);
end;

end.
