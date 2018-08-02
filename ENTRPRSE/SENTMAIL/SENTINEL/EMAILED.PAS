unit emailed;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmEmailEdit = class(TForm)
    Panel1: TPanel;
    Label16: TLabel;
    edtEmailAddress: TEdit;
    Label17: TLabel;
    edtEmailName: TEdit;
    btnOk: TButton;
    Button2: TButton;
    btnDBF: TButton;
    cbEmType: TComboBox;
    Label1: TLabel;
    procedure edtEmailNameEnter(Sender: TObject);
    procedure edtEmailAddressEnter(Sender: TObject);
    procedure btnDBFClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtEmailAddressChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    ActiveEdit : TEdit;
    procedure PutDBField(AMemo : TEdit);
    function SelectDBField : ShortString;
  public
    { Public declarations }
  end;

var
  frmEmailEdit: TfrmEmailEdit;

implementation

uses
  SelFld2, BtSupU2;

procedure TfrmEmailEdit.PutDBField(AMemo : TEdit);
var
  s : ShortString;
  p : PChar;
begin
  s := SelectDBField;
  if s <> '' then
  begin
    p := StrAlloc(Length(s) + 1);
    FillChar(p^, Length(s) + 1, #0);
    StrPCopy(p, s);

    AMemo.SetSelTextBuf(p);
  end;
  ActiveControl := AMemo;
end;

function TfrmEmailEdit.SelectDBField : ShortString;
begin
//  Result := '{DB Field}';
  with Form_SelectField2 do
  begin
    Try
      ShortCode := 'AC';
      PageControl1Change(nil);
      ShowModal;
      if OK then
        Result := 'DBF[' + Trim(ShortCode) + ']'
      else
        Result := '';
    Finally
 //     Free;
    End;
  end;
end;



{$R *.DFM}

procedure TfrmEmailEdit.edtEmailNameEnter(Sender: TObject);
begin
  ActiveEdit := edtEmailName;
end;

procedure TfrmEmailEdit.edtEmailAddressEnter(Sender: TObject);
begin
  ActiveEdit := edtEmailAddress;
end;

procedure TfrmEmailEdit.btnDBFClick(Sender: TObject);
begin
  if Assigned (ActiveEdit) then
    PutDBField(ActiveEdit);
end;

procedure TfrmEmailEdit.FormCreate(Sender: TObject);
begin
  ActiveEdit := edtEmailAddress;
  edtEmailAddressChange(Self);
end;

procedure TfrmEmailEdit.edtEmailAddressChange(Sender: TObject);
begin
  btnOK.Enabled := (Pos('@',edtEmailAddress.Text) > 0) or
                   (Pos('DBF[',edtEmailAddress.Text) > 0);
end;

procedure TfrmEmailEdit.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

end;

procedure TfrmEmailEdit.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

end.
