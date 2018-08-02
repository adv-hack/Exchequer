unit TestDLLForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IRISLicenceDLL;

type

  TForm7 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    edtPlainLicenceFile: TEdit;
    Label2: TLabel;
    edtEncryptedLicenceFile: TEdit;
    Label3: TLabel;
    btnEncryptFile: TButton;
    btnDecryptFile: TButton;
    btnWriteAccData: TButton;
    Memo: TMemo;
    Label4: TLabel;
    edtAcceptanceFile: TEdit;
    btnReadAccData: TButton;
    procedure btnDecryptFileClick(Sender: TObject);
    procedure btnEncryptFileClick(Sender: TObject);
    procedure btnReadAccDataClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnWriteAccDataClick(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

{$R *.dfm}

procedure TForm7.btnDecryptFileClick(Sender: TObject);
begin
  with TIRISLicence.Create('') do begin
    LoadDLL('');
    DecryptLicenceFile(pchar(edtEncryptedLicenceFile.Text), pchar(edtPlainLicenceFile.Text));
    free;
  end;
end;

procedure TForm7.btnEncryptFileClick(Sender: TObject);
begin
  with TIRISLicence.Create('') do begin
    LoadDLL('');
    EncryptLicenceFile(pchar(edtPlainLicenceFile.Text), pchar(edtEncryptedLicenceFile.text));
    free;
  end;
end;

procedure TForm7.btnReadAccDataClick(Sender: TObject);
begin
  with TIRISLicence.Create('') do begin
    LoadDLL('');
    Memo.Text := ReadAcceptanceData(pchar(edtAcceptanceFile.Text));
    free;
  end;
end;

procedure TForm7.Button1Click(Sender: TObject);
var
  res: integer;
  il: TIRISLicence;
begin
  il := TIRISLicence.Create('');
  if il <> nil then
    with il do begin
      if LoadDLL('') > 0 then begin
        if ShowLicence(pchar(edtEncryptedLicenceFile.text)) = -1 then
          label1.Caption := 'User declined the licence'
        else
          Label1.Caption := 'User accepted the licence';
      end;
      free;
    end;
end;

procedure TForm7.btnWriteAccDataClick(Sender: TObject);
begin
  with TIRISLicence.Create('') do begin
    LoadDLL('');
    WriteAcceptanceData(pchar(edtAcceptanceFile.Text), pchar(memo.Text));
    free;
  end;
end;

end.
