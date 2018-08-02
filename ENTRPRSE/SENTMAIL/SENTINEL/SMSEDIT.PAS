unit smsedit;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmEditSMS = class(TForm)
    Panel1: TPanel;
    Label48: TLabel;
    edtSMSNumber: TEdit;
    Label49: TLabel;
    edtSMSName: TEdit;
    btnOK: TButton;
    Button2: TButton;
    btnDbField: TButton;
    procedure FormCreate(Sender: TObject);
    procedure edtSMSNumberEnter(Sender: TObject);
    procedure edtSMSNumberExit(Sender: TObject);
    procedure btnDbFieldClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    ActiveEdit : TEdit;
    procedure PutDBField(AMemo : TEdit);
    function SelectDBField : ShortString;
  public
    { Public declarations }
    procedure PutCaption(const s : String);
  end;

var
  frmEditSMS: TfrmEditSMS;

implementation

uses
  SelFld2, BtSupU2;

{$R *.DFM}

procedure TfrmEditSMS.PutDBField(AMemo : TEdit);
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

function TfrmEditSMS.SelectDBField : ShortString;
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
//      Free;
    End;
  end;
end;


procedure TfrmEditSMS.FormCreate(Sender: TObject);
begin
  ActiveEdit := edtSMSName;
  ClientHeight := 167;
  ClientWidth  := 264;
end;

procedure TfrmEditSMS.edtSMSNumberEnter(Sender: TObject);
begin
  ActiveEdit := edtSMSNumber;
end;

procedure TfrmEditSMS.edtSMSNumberExit(Sender: TObject);
begin
    if ActiveControl = btnOK then
    btnOK.Click;

end;

procedure TfrmEditSMS.btnDbFieldClick(Sender: TObject);
begin
  if Assigned (ActiveEdit) then
    PutDBField(ActiveEdit);

end;

procedure TfrmEditSMS.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);

end;

procedure TfrmEditSMS.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TfrmEditSMS.PutCaption(const s : String);
begin
  Caption := s;
end;

end.
