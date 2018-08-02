unit ReferralDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmReferralDialog = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edCode: TEdit;
    Label3: TLabel;
    lPhoneNo: TLabel;
    Label4: TLabel;
    lMID: TLabel;
    Label6: TLabel;
    lCardNo: TLabel;
    Label8: TLabel;
    lStartDate: TLabel;
    Label10: TLabel;
    lExpiryDate: TLabel;
    Label12: TLabel;
    lIssueNo: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    procedure edCodeChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmReferralDialog: TfrmReferralDialog;

implementation

{$R *.dfm}

procedure TfrmReferralDialog.edCodeChange(Sender: TObject);
begin
  btnOK.enabled := Trim(edCode.Text) <> '';
end;

procedure TfrmReferralDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LocalKey : Word;
begin
  LocalKey := Key;
  Key := 0;

  {Trap function keys}
  If (LocalKey In [VK_F1..VK_F12]) and (Not (ssAlt In Shift)) then
    begin
      case LocalKey of
        VK_F9 : ModalResult := mrOK;
        else Key := LocalKey;
      end;{case}
    end
  else Key := LocalKey;
end;

procedure TfrmReferralDialog.btnOKClick(Sender: TObject);
begin
  btnOK.Enabled := FALSE; {.005} // To stop them from double clicking
end;

end.
