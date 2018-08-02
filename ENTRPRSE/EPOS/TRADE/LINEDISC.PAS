unit LineDisc;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IAeverButton, ExtCtrls, TEditVal;

type
  TFrmLineDiscount = class(TForm)
    Label3: TLabel;
    rbPercent: TRadioButton;
    rbAmount: TRadioButton;
    Shape2: TShape;
    lEdit: TLabel;
    btnCancel: TIAeverButton;
    edDiscount: TCurrencyEdit;
    rbOverride: TRadioButton;
    btnOK: TIAeverButton;
    Label1: TLabel;
    Label2: TLabel;
    lOverride: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rbPercentClick(Sender: TObject);
    procedure rbAmountClick(Sender: TObject);
    procedure rbOverrideClick(Sender: TObject);
    procedure edDiscountExit(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure lOverrideClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLineDiscount: TFrmLineDiscount;

implementation
uses
  EPOSKey, StrUtil, GfxUtil, EPOSCnst, EPOSProc, TXLine;

{$R *.DFM}

procedure TFrmLineDiscount.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TFrmLineDiscount.FormKeyDown(Sender: TObject; var Key: Word;
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
        VK_F4 : rbAmount.Checked := TRUE;
        VK_F6 : rbPercent.Checked := TRUE;
        VK_F8 : if rbOverride.Enabled then rbOverride.Checked := TRUE;
        VK_F9 : btnOKClick(btnOK);
        else Key := LocalKey;
      end;{case}
    end
  else Key := LocalKey;
end;

procedure TFrmLineDiscount.btnOKClick(Sender: TObject);
begin
  edDiscount.value := StrToFloatDef(edDiscount.text,0);

  if (not (rbOverride.Checked and (edDiscount.value = 0) and (not AllowedTo(atSetPriceToZero))))
  and (not (rbPercent.Checked and (edDiscount.value = 100) and (not AllowedTo(atSetPriceToZero))))
  and (not (rbAmount.Checked and (edDiscount.value = FrmTXLine.TXLineRec.rPreEPOSDiscount) and (not AllowedTo(atSetPriceToZero))))
  then begin
    ActiveControl := btnOK;
    ModalResult := mrOK;
  end;
end;

procedure TFrmLineDiscount.FormCreate(Sender: TObject);
begin
  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);
  edDiscount.displayformat := '#########0.00'; {cos this gets reset @ run-time - nice}
  edDiscount.displayformat := '#########0.' + StringOfChar('0',TKSysRec.PriceDP); {cos this gets reset @ run-time - nice}
end;

procedure TFrmLineDiscount.rbPercentClick(Sender: TObject);
begin
  lEdit.Caption := 'Percentage';
  edDiscount.displayformat := '#########0.00';
end;

procedure TFrmLineDiscount.rbAmountClick(Sender: TObject);
begin
  lEdit.Caption := 'Amount';
  edDiscount.displayformat := '#########0.' + StringOfChar('0',TKSysRec.PriceDP);
end;

procedure TFrmLineDiscount.rbOverrideClick(Sender: TObject);
begin
  lEdit.Caption := 'New Price';
  edDiscount.displayformat := '#########0.' + StringOfChar('0',TKSysRec.PriceDP);
end;

procedure TFrmLineDiscount.edDiscountExit(Sender: TObject);
begin
  if rbPercent.Checked and  (StrToFloatDef(edDiscount.text,0) > 100) then edDiscount.text := '100.00';
end;

procedure TFrmLineDiscount.Button2Click(Sender: TObject);
begin
  Color := clWhite;
end;

procedure TFrmLineDiscount.Label1Click(Sender: TObject);
begin
  rbAmount.Checked := TRUE;
  rbAmount.SetFocus;
end;

procedure TFrmLineDiscount.Label2Click(Sender: TObject);
begin
  rbPercent.Checked := TRUE;
  rbPercent.SetFocus;
end;

procedure TFrmLineDiscount.lOverrideClick(Sender: TObject);
begin
  rbOverride.Checked := TRUE;
  rbOverride.SetFocus;
end;

end.
