unit Test;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CCDeptU, APIUtil, ExtCtrls, EnterToTab;

type
  TfrmTest = class(TForm)
    Label1: TLabel;
    edCC: TEdit;
    Label2: TLabel;
    edDept: TEdit;
    btnTest: TButton;
    btnClose: TButton;
    edGLCode: TEdit;
    lGLCode: TLabel;
    lVAT: TLabel;
    cmbVAT: TComboBox;
    Bevel1: TBevel;
    EnterToTab1: TEnterToTab;
    procedure btnCloseClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    sDataPath : string;
  end;

var
  frmTest: TfrmTest;

  procedure DisplayMessage(const sMessage : string);

implementation
uses
  BTFile;

{$R *.DFM}

procedure TfrmTest.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTest.btnTestClick(Sender: TObject);
var
  iGLCode : integer;
  cVATCode : char;
begin
  if Trim(edGLCode.Text) = '' then iGLCode := 0
  else iGLCode := StrToInt(edGLCode.Text);

  if bUseVAT then cVATCode := GetVATCode(cmbVAT)
  else cVATCode := #0;

  if CCDeptValid(edCC.Text, edDept.Text, cVATCode, iGLCode, sDataPath, 1, DisplayMessage, FALSE)
  then MessageDlg('Input is valid',mtinformation,[mbOK],0);
end;

procedure DisplayMessage(const sMessage : string);
begin
  MsgBox(sMessage, mtWarning, [mbOK], mbOK, 'Test Input');
end;


procedure TfrmTest.FormCreate(Sender: TObject);
begin
  if bUseVAT then
  begin
    FillVATCombo(cmbVAT);
    cmbVAT.Items.Delete(0); // Delete wildcard option
    cmbVAT.ItemIndex := 0;
  end;{if}

  cmbVAT.Enabled := bUseVAT;
  lVAT.Enabled := bUseVAT;

  edGLCode.Enabled := bUseGLs;
  lGLCode.Enabled := bUseGLs;
end;

end.
