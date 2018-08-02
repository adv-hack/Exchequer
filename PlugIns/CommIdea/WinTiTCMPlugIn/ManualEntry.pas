unit ManualEntry;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IAeverButton, ExtCtrls;

type
  TfrmManualEntry = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Shape1: TShape;
    Label4: TLabel;
    edExpiryDate: TEdit;
    edStartDate: TEdit;
    edCardNo: TEdit;
    edIssueNumber: TEdit;
    btnOK: TIAeverButton;
    btnCancel: TIAeverButton;
    Label5: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Label6: TLabel;
    edSecurityNumber: TEdit;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmManualEntry: TfrmManualEntry;

implementation
uses
  GfxUtil, JPeg; 

{$R *.dfm}

procedure TfrmManualEntry.FormCreate(Sender: TObject);
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

procedure TfrmManualEntry.Button1Click(Sender: TObject);
begin
  edCardNo.Text := '4929123123123';
  edStartDate.Text := '';
  edExpiryDate.Text := '1210';
  edIssueNumber.Text := '';
end;

procedure TfrmManualEntry.Button2Click(Sender: TObject);
begin
  edCardNo.Text := '4000000000000002';
  edStartDate.Text := '';
  edExpiryDate.Text := '1210';
  edIssueNumber.Text := '';
end;

procedure TfrmManualEntry.Button3Click(Sender: TObject);
begin
  edCardNo.Text := '4000000000000002';
  edStartDate.Text := '';
  edExpiryDate.Text := '1210';
  edIssueNumber.Text := '';
end;

procedure TfrmManualEntry.Button4Click(Sender: TObject);
begin
  edCardNo.Text := '6767051323183400359';
  edStartDate.Text := '';
  edExpiryDate.Text := '12/10';
  edIssueNumber.Text := '0';
end;

procedure TfrmManualEntry.Button5Click(Sender: TObject);
begin
  edCardNo.Text := '6759820000000019';
  edStartDate.Text := '12/01';
  edExpiryDate.Text := '12/10';
  edIssueNumber.Text := '';
end;

procedure TfrmManualEntry.Button6Click(Sender: TObject);
begin
  edCardNo.Text := '5301250070000191';
  edStartDate.Text := '';
  edExpiryDate.Text := '12/10';
  edIssueNumber.Text := '';
end;

procedure TfrmManualEntry.Button7Click(Sender: TObject);
begin
  edCardNo.Text := '6767051323183400359';
  edStartDate.Text := '';
  edExpiryDate.Text := '12/10';
  edIssueNumber.Text := '1';
end;

procedure TfrmManualEntry.Button8Click(Sender: TObject);
begin
  edCardNo.Text := '4917480000000008';
  edStartDate.Text := '';
  edExpiryDate.Text := '12/10';
  edIssueNumber.Text := '';
end;

procedure TfrmManualEntry.Button9Click(Sender: TObject);
begin
  edCardNo.Text := '4929321321321';
  edStartDate.Text := '';
  edExpiryDate.Text := '12/10';
  edIssueNumber.Text := '';
end;

procedure TfrmManualEntry.Button10Click(Sender: TObject);
begin
  edCardNo.Text := '5301250070000191';
  edStartDate.Text := '';
  edExpiryDate.Text := '12/10';
  edIssueNumber.Text := '';
end;

procedure TfrmManualEntry.Button11Click(Sender: TObject);
begin
  edCardNo.Text := '4012001038488884';
  edStartDate.Text := '';
  edExpiryDate.Text := '12/10';
  edIssueNumber.Text := '';
end;

procedure TfrmManualEntry.Button12Click(Sender: TObject);
begin
  edCardNo.Text := '5453010000074468';
  edStartDate.Text := '';
  edExpiryDate.Text := '12/10';
  edIssueNumber.Text := '';
end;

procedure TfrmManualEntry.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmManualEntry.Button13Click(Sender: TObject);
begin
  edCardNo.Text := '4012001037141112';
  edStartDate.Text := '';
  edExpiryDate.Text := '12/10';
  edIssueNumber.Text := '';
end;

procedure TfrmManualEntry.Button14Click(Sender: TObject);
begin
  edCardNo.Text := '454420650001014345';
  edStartDate.Text := '';
  edExpiryDate.Text := '12/10';
  edIssueNumber.Text := '';
end;

procedure TfrmManualEntry.Button15Click(Sender: TObject);
begin
  edCardNo.Text := '4544206500010262';
  edStartDate.Text := '';
  edExpiryDate.Text := '12/10';
  edIssueNumber.Text := '';
end;

procedure TfrmManualEntry.Button16Click(Sender: TObject);
begin
  edCardNo.Text := '4539785000002517';
  edStartDate.Text := '';
  edExpiryDate.Text := '12/10';
  edIssueNumber.Text := '';
end;

end.