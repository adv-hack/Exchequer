unit expform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ExtCtrls, Mask, TEditVal, ANIMATE;

type
  TfrmExport = class(TForm)
    Panel1: TPanel;
    SBSButton1: TSBSButton;
    btnCancel: TSBSButton;
    edtTSFrom: TEdit;
    edtTSTo: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    chkPosted: TCheckBox;
    Label7: TLabel;
    edtEmp: TEdit;
    edtWk: TEdit;
    edtPy: TEditPeriod;
    chkUseLineRates: TCheckBox;
    chkAllowExported: TCheckBox;
    chkExcludeSubs: TCheckBox;
    chkLineFromAnal: TCheckBox;
    procedure edtEmpExit(Sender: TObject);
    procedure edtWkChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FCompanyCode : string;
    procedure EnableEdit(TheEdit : TEdit; Enable : Boolean);
    procedure SetEdits(Emp, Wk, Ts, Py : Boolean);
  public
    { Public declarations }
    property CompanyCode : string read FCompanyCode write FCompanyCode;
  end;

var
  frmExport: TfrmExport;

implementation

{$R *.dfm}
uses
  emplkup, JcVar, JcFuncs;


procedure TfrmExport.edtEmpExit(Sender: TObject);
begin
  if (ActiveControl <> btnCancel) and
     (Trim(edtEmp.Text) <> '') then
       CheckEmpCode(Sender as TEdit, FCompanyCode);
end;

procedure TfrmExport.EnableEdit(TheEdit : TEdit; Enable : Boolean);
begin
  TheEdit.Enabled := Enable;
  if Enable then
  begin
    TheEdit.Color := clWindow;
    ActiveControl := TheEdit;
  end
  else
    TheEdit.Color := clBtnFace;
end;

procedure TfrmExport.SetEdits(Emp, Wk, Ts, Py : Boolean);
begin
{  EnableEdit(edtEmp, Emp);
  EnableEdit(edtWk, Wk);
  EnableEdit(edtTSTo, Ts);
  EnableEdit(edtTSFrom, Ts);
  EnableEdit(edtYear, Py);
  EnableEdit(edtPeriod, Py);}
end;

procedure TfrmExport.edtWkChange(Sender: TObject);
var
  s : string;
  i : integer;
begin
  s := edtWk.Text;
  if Length(s) > 2 then
    Delete(s, 3, Length(s));
  if Length(s) > 0 then
  begin
    for i := 1 to Length(s) do
    begin
      if not (s[i] in ['0'..'9']) then
      begin
//        ShowMessage('Week/Month must be a number between 0 and 99');
        Delete(s, i, 1);
      end;
    end;
  end;
  edtWk.Text := s;
end;

procedure TfrmExport.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TfrmExport.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

end.
