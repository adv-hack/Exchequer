unit deposit;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IAeverButton, TEditVal, ExtCtrls, StrUtil, EPOSProc;

type
  TFrmDeposit = class(TForm)
    btnOK: TIAeverButton;
    btnCancel: TIAeverButton;
    lTitle: TLabel;
    Panel1: TPanel;
    lDepM: TLabel;
    Shape1: TShape;
    edDeposit: TCurrencyEdit;
    lOSM: TLabel;
    lOSAmount: TLabel;
    lRemBal: TLabel;
    lRemaining: TLabel;
    cbCardRefund: TCheckBox;
    lCardRefund: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure edDepositChange(Sender: TObject);
    procedure lCardRefundClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Mode : TDPFormMode;
    rOSAmount : real;
  end;

var
  FrmDeposit: TFrmDeposit;

implementation
uses
  VarConst, EPOSKey, EPOSCnst, {NeilProc,} GfxUtil;

{$R *.DFM}

procedure TFrmDeposit.FormCreate(Sender: TObject);
begin
{  edDeposit.displayformat := '##0.00'; {cos this gets reset @ run-time - nice}
  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);
end;

procedure TFrmDeposit.FormKeyDown(Sender: TObject; var Key: Word;
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
        VK_F9 : btnOKClick(btnOK);
        else Key := LocalKey;
      end;{case}
    end
  else Key := LocalKey;
end;

procedure TFrmDeposit.btnOKClick(Sender: TObject);
begin
  if btnOK.Enabled then begin
    ActiveControl := btnOK;
    if (Mode = fmTakeDeposit) and (edDeposit.Value >= rOSAmount) then MyMsgBox('The amount you have entered is greater than, or equal to the full outstanding amount.'
    ,mtError,[mbOK],mbOK,'Invalid Amount') else begin
      if edDeposit.Value > 0 then begin
        ActiveControl := btnOK;
        ModalResult := mrOk;
      end;{if}
    end;{if}
  end;
end;

procedure TFrmDeposit.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TFrmDeposit.FormShow(Sender: TObject);
begin
  Case Mode of
    fmTakeDeposit : begin
      Caption := 'Take Deposit';
      lTitle.Caption := 'What amount are you going to take as a deposit ?';
      lOSAmount.Caption := sCurrencySym + ' ' + MoneyToStr(rOSAmount);
      lRemaining.Caption := sCurrencySym + ' ' + MoneyToStr(rOSAmount - edDeposit.Value);
      cbCardRefund.visible := FALSE;
      lCardRefund.visible := cbCardRefund.visible;
    end;

    fmOnAccount : begin
      Caption := 'On Account';
      lDepM.Caption := 'Amount';
      lTitle.Caption := 'What amount do you wish to take on account ?';
      lOSM.Visible := FALSE;
      lOSAmount.Visible := FALSE;
      lRemBal.Visible := FALSE;
      lRemaining.Visible := FALSE;
      cbCardRefund.visible := bCommideaPlugInRunning;
      lCardRefund.visible := cbCardRefund.visible;
    end;
  end;{case}
end;

procedure TFrmDeposit.edDepositChange(Sender: TObject);
var
  rValue : real;
begin
  rValue := StrToFloatDef(edDeposit.Text, 0);
  lRemaining.Caption := sCurrencySym + ' ' + MoneyToStr(rOSAmount - rValue);
end;

procedure TFrmDeposit.lCardRefundClick(Sender: TObject);
begin
  cbCardRefund.checked := not cbCardRefund.checked;
  cbCardRefund.SetFocus;
end;

end.
