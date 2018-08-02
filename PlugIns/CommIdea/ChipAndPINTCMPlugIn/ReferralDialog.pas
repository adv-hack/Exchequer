unit ReferralDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IAeverButton;

type
  TfrmReferralDialog = class(TForm)
    Label1: TLabel;
    btnOK: TIAeverButton;
    btnCancel: TIAeverButton;
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
    procedure FormCreate(Sender: TObject);
    procedure edCodeChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmReferralDialog: TfrmReferralDialog;

implementation
uses
  GfxUtil, JPeg;

{$R *.dfm}

procedure TfrmReferralDialog.FormCreate(Sender: TObject);
var
  TmpJPEG : TJPEGImage;
  bitFormBackground : TBitmap;
begin
  if ColorMode(canvas) in [cm64Bit, cm32Bit, cm24Bit, cm16Bit] then begin
    {Load Background JPEG}
    TmpJPEG := TJPEGImage.Create;
    bitFormBackground := TBitmap.create;
    if LoadJPEGFromRes('FORMBAK2', TmpJPEG) then begin
      bitFormBackground.Assign(TmpJPEG);
      DrawFormBackground(self, bitFormBackground);
    end;{if}
    TmpJPEG.Free;
    bitFormBackground.Free;
  end;{if}
end;

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

end.
