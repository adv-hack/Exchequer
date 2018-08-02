unit reppass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type


  TfrmRepPass = class(TForm)
    Panel1: TPanel;
    btnOK: TButton;
    Button2: TButton;
    edtPassword: TEdit;
    Label1: TLabel;
    lblGrp: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function GetReportPassword(const GrpName : string; const Pword : String) : Boolean;

var
  frmRepPass: TfrmRepPass;

implementation

uses
  Crypto;

{$R *.dfm}

  function GetReportPassword(const GrpName : string; const Pword : String) : Boolean;
  var
    TempStr : ShortString;
  begin
    with TfrmRepPass.Create(nil) do
    Try
      lblGrp.Caption := GrpName;
      ShowModal;
      if ModalResult = mrOK then
      begin
        TempStr := edtPassword.Text;
        Result := EncodeKey(11837, TempStr) = PWord;
        if not Result then
          ShowMessage('Password incorrect');
      end
      else
        Result := False;
    Finally
      Free;
    End;
  end;





end.
