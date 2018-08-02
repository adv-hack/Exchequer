unit CoDet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise01_TLB, Spin, StdCtrls, TCustom;

type
  TfrmCoDetails = class(TForm)
    GroupBox1: TGroupBox;
    SBSButton1: TSBSButton;
    btnCancel: TSBSButton;
    Label1: TLabel;
    cbCode: TComboBox;
    edtName: TEdit;
    edtPayID: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    SpinButton1: TSpinButton;
    Label4: TLabel;
    edtFileName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure cbCodeChange(Sender: TObject);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure edtFileNameExit(Sender: TObject);
    procedure SBSButton1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure FillCoList;
    function GetCoName : string;
    procedure IncPayID(Amt : integer);
  public
    { Public declarations }
    OK : Boolean;
    procedure DoCodeChange;
  end;

var
  frmCoDetails: TfrmCoDetails;

implementation

{$R *.dfm}
uses
  JcVar, JcFuncs;

procedure TfrmCoDetails.FillCoList;
var
  i : integer;
begin
  if Assigned(oToolkit) then
  with oToolkit do
  begin
    for i := 1 to Company.cmCount do
      cbCode.Items.Add(Company.cmCompany[i].coCode);
    cbCode.ItemIndex := 0;
    cbCodeChange(Self);
  end;
end;

function TfrmCoDetails.GetCoName : string;
var
  i : integer;
begin
  if Assigned(oToolkit) then
  with oToolkit do
  begin
    for i := 1 to Company.cmCount do
      if Trim(cbCode.Items[cbCode.ItemIndex]) = Trim(Company.cmCompany[i].coCode) then
      begin
        Result := Trim(Company.cmCompany[i].coName);
        Break;
      end;
  end;

end;

procedure TfrmCoDetails.FormCreate(Sender: TObject);
begin
  FillCoList;
end;

procedure TfrmCoDetails.cbCodeChange(Sender: TObject);
begin
  edtName.Text := GetCoName;
end;

procedure TfrmCoDetails.IncPayID(Amt : integer);
var
  i : integer;
begin
  i := StrToInt(edtPayID.Text);

  i := i + Amt;
  if i = 0 then
    i := 1;

  if i = 1000 then
    i := 999;

  if i < 10 then
   edtPayID.Text := '00' + IntToStr(i)
  else
  if i < 100 then
   edtPayID.Text := '0' + IntToStr(i)
  else
   edtPayID.Text := IntToStr(i);
end;

procedure TfrmCoDetails.SpinButton1DownClick(Sender: TObject);
begin
  IncPayID(-1);
end;

procedure TfrmCoDetails.SpinButton1UpClick(Sender: TObject);
begin
  IncPayID(1);
end;

procedure TfrmCoDetails.DoCodeChange;
begin
  cbCodeChange(Self);
end;

procedure TfrmCoDetails.edtFileNameExit(Sender: TObject);
begin
  if (ActiveControl <> btnCancel) and (Trim(edtFilename.Text) = '') then
  begin
    ShowMessage('You must specify a filename for export files');
    ActiveControl := edtFilename;
  end;
end;

procedure TfrmCoDetails.SBSButton1Click(Sender: TObject);
begin
  edtFilenameExit(nil);
  if ActiveControl <> edtFilename then
  begin
    OK := True;
    Close;
  end
end;

procedure TfrmCoDetails.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TfrmCoDetails.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

end.
