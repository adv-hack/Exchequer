unit SettDisc;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IAeverButton, ExtCtrls, TEditVal;

type
  TFrmSettlement = class(TForm)
    edSettlement: TCurrencyEdit;
    Label1: TLabel;
    Shape1: TShape;
    btnOK: TIAeverButton;
    btnCancel: TIAeverButton;
    Label2: TLabel;
    Label3: TLabel;
    edSettDiscDays: TCurrencyEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSettlement: TFrmSettlement;

implementation
uses
  EPOSKey, EPOSProc, EPOSCnst, GfxUtil;

{$R *.DFM}

procedure TFrmSettlement.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TFrmSettlement.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TFrmSettlement.btnOKClick(Sender: TObject);
begin
  ActiveControl := btnOK;

  if (edSettlement.Value > 100) or (edSettlement.Value < 0) then
    begin
      MyMsgBox('You have entered an invalid Settlement Discount amount.' + #13#13 +
      'Please enter a valid amount.',mtInformation,[mbOK],mbOK,'Settlement Discount');
      ActiveControl := edSettlement;
    end
  else begin
    if (edSettDiscDays.Value < 0) or (edSettDiscDays.Value > 255) then
      begin
        MyMsgBox('You have entered an invalid amount of Settlement Days.' + #13#13 +
        'Please enter a valid amount.',mtInformation,[mbOK],mbOK,'Settlement Days');
        ActiveControl := edSettDiscDays;
      end
    else ModalResult := mrOk;
  end;{if}
end;

procedure TFrmSettlement.FormCreate(Sender: TObject);
begin
  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);
  edSettlement.displayformat := '##0.00'; {cos this gets reset @ run-time - nice}
  edSettDiscDays.displayformat := '###0' {cos this gets reset @ run-time - nice}
end;

end.
