unit LicForm;
{Program for creating encrypted SMS account files for Sentimail sms access, and
for maintaining a csv file of account details

The file structure is: Exchequer Account Code for the Customer,
                       Customer's email address,
                       Customer's ESN,
                       User ID for sms-wap,
                       Password for sms-wap}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, LicRec, Menus;

const
  DemoUser = 'rutp5072';

type
  TfrmSmsAccounts = class(TForm)
    Panel1: TPanel;
    btnCreate: TButton;
    edtUser: TEdit;
    edtPW: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    SaveDialog1: TSaveDialog;
    btnRead: TButton;
    OpenDialog1: TOpenDialog;
    edtEmail: TEdit;
    cbAc: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    btnAdd: TButton;
    btnSave: TButton;
    edtAc: TEdit;
    btnEdit: TButton;
    btnCancel: TButton;
    btnDel: TButton;
    Label5: TLabel;
    meESN1: TMaskEdit;
    Bevel1: TBevel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    CreateACFile1: TMenuItem;
    ReadACFile1: TMenuItem;
    Record1: TMenuItem;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Cancel1: TMenuItem;
    Save1: TMenuItem;
    Delete1: TMenuItem;
    Reports1: TMenuItem;
    CheckSMSCredits1: TMenuItem;
    CheckSMSCreditsforAllAccounts1: TMenuItem;
    procedure btnCreateClick(Sender: TObject);
    procedure btnReadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure cbAcChange(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure meESN1Exit(Sender: TObject);
    procedure CheckSMSCredits1Click(Sender: TObject);
    procedure CheckSMSCreditsforAllAccounts1Click(Sender: TObject);
  private
    { Private declarations }
    FCSVFile : string;
    FList, FLineList : TStringList;
    CurrentItem : integer;
    IsAdd : Boolean;
    EsnAry : ESNByteArrayType;
    DemoFlag : Byte;
    function AccountCode(Ac : integer) : string;
    function EmailAdd(Ac : integer) : string;
    function UserName(Ac : integer) : string;
    function Password(Ac : integer) : string;
    function GetESN(Ac : Integer) : string;
    function CSText(s : string; Ac : integer) : string;
    procedure ClearEdits;
    procedure ListToForm;
    procedure FormToList;
    function ESNString : string;
    procedure StringToESN(const s : STring);
    function LocalESNString(Ary : ESNByteArrayType) : string;
    procedure SetControls(Sender : TObject);
    function DemoOK : Boolean;
  public
    { Public declarations }
  end;

var
  frmSmsAccounts: TfrmSmsAccounts;

implementation

{$R *.dfm}
uses
  SmsLic, LWCust, ESNImpU, LicFuncu, ComObj, AcForm, RegUtil, EntLic;

procedure TfrmSmsAccounts.btnCreateClick(Sender: TObject);
{write encrypted file}
var
  OK2Write : Boolean;
begin
  OK2Write := True;
  meESN1Exit(Self);
  if (Trim(edtUser.Text) <> '') and (Trim(edtPW.Text) <> '') then
  begin
    if (Trim(edtUser.Text) = DemoUser) then
      OK2Write := DemoOK;

    if OK2Write and SaveDialog1.Execute then
    begin
      with TSmsWapLicence.create do
      Try
        FileName := SaveDialog1.FileName;
        UserName := Trim(edtUser.Text);
        Password := Trim(edtPW.Text);
        ESN := ESNString;
        if not WriteFile then
          ShowMessage('Unable to write file ' + FileName);
      Finally
        Free;
      End;
    end;
  end
  else
    ShowMessage('UserName or Password cannot be left blank');

end;

procedure TfrmSmsAccounts.btnReadClick(Sender: TObject);
{read encrypted file}
begin
  edtUser.Text := '';
  edtPW.Text := '';
  if OpenDialog1.Execute then
  begin
    with TSmsWapLicence.create do
    Try
      FileName := OpenDialog1.FileName;
      if ReadFile = 0 then
      begin
        edtUser.Text := UserName;
        edtPW.Text := Password;
        StringToESN(ESN);
      end
      else
        ShowMessage('Unable to read file ' + FileName);
    Finally
      Free;
    End;
  end;

end;

procedure TfrmSmsAccounts.FormCreate(Sender: TObject);
var
  i : integer;
begin
  FCsvFile := ExtractFilePath(Application.ExeName) + 'SmsAcc.csv';
  FList := TStringList.Create;
  FList.Sorted := True;
  {Load list from file and fill combo box items}
  FLineList := TStringList.Create;
  Try
    FList.LoadFromFile(FCsvFile);
  Except
    ShowMessage('Unable to read file: ' + QuotedStr(FCsvFile));
  End;
  for i := 0 to FList.Count - 1 do
    cbAc.Items.Add(AccountCode(i));
  cbAc.ItemIndex := 0;
  CurrentItem := 0;
  cbAcChange(Self);
  SetControls(nil);
end;

function TfrmSmsAccounts.AccountCode(Ac : integer) : string;
begin
  Result := CSText(FList[Ac], 0);
end;

function TfrmSmsAccounts.EmailAdd(Ac : integer) : string;
begin
  Result := CSText(FList[Ac], 1);

end;

function TfrmSmsAccounts.UserName(Ac : integer) : string;
begin
  Result := CSText(FList[Ac], 2);

end;

function TfrmSmsAccounts.Password(Ac : integer) : string;
begin
  Result := CSText(FList[Ac], 3);

end;

function TfrmSmsAccounts.GetESN(Ac : Integer) : string;
begin
  Result := CSText(FList[Ac], 4);

end;

function TfrmSmsAccounts.CSText(s : string; Ac : integer) : string;
begin
  FLineList.Clear;
  FLineList.CommaText := s;
  Try
    Result := FLineList[Ac];
  Except
    ShowMessage('Invalid line: ' + s);
  End;
end;



procedure TfrmSmsAccounts.FormDestroy(Sender: TObject);
begin
  FList.Free;
  FLineList.Free;
end;

procedure TfrmSmsAccounts.btnSaveClick(Sender: TObject);
var
  i : integer;
begin
  SetControls(Sender);
  if not IsAdd then
  begin
    FList.Delete(CurrentItem);
    cbAc.Items[CurrentItem] := edtAc.Text;
  end;
  FormToList;
  FList.SaveToFile(FCSVFile);
  cbAc.Items.Clear;
  for i := 0 to FList.Count - 1 do
    cbAc.Items.Add(AccountCode(i));

  cbAc.ItemIndex := CurrentItem;
end;

procedure TfrmSmsAccounts.ClearEdits;
begin
  edtAc.text := '';
  edtEmail.Text := '';
  edtUser.Text := '';
  edtPw.Text := '';
  meESN1.Text := '';
end;

procedure TfrmSmsAccounts.btnAddClick(Sender: TObject);
begin
  SetControls(Sender);
  IsAdd := True;
  ClearEdits;
  ActiveControl := edtAc;
end;

procedure TfrmSmsAccounts.ListToForm;
begin
  cbAc.ItemIndex := cbAc.Items.IndexOf(AccountCode(CurrentItem));
  edtEmail.Text := EmailAdd(CurrentItem);
  edtUser.Text := UserName(CurrentItem);
  edtPw.Text := Password(CurrentItem);
  meESN1.Text := GetESN(CurrentItem);
end;

procedure TfrmSmsAccounts.FormToList;
begin
  CurrentItem := FList.Add(edtAc.Text + ',' + edtEmail.Text + ',' + edtUser.Text + ',' +
                   edtPW.Text + ',' + meESN1.Text);
end;


procedure TfrmSmsAccounts.cbAcChange(Sender: TObject);
begin
  CurrentItem := cbAc.ItemIndex;
  edtAc.Text := cbAc.Items[CurrentItem];
  ListToForm;
end;

procedure TfrmSmsAccounts.btnEditClick(Sender: TObject);
begin
  SetControls(Sender);
  IsAdd := False;
  edtAc.Text := cbAc.Items[cbAc.itemIndex];
end;

procedure TfrmSmsAccounts.btnCancelClick(Sender: TObject);
begin
  SetControls(Sender);
  cbAcChange(nil);
end;

procedure TfrmSmsAccounts.btnDelClick(Sender: TObject);
begin
  FList.Delete(CurrentItem);
  FList.SaveToFile(FCsvFile);
  cbAc.Items.Delete(CurrentItem);
  if CurrentItem >= FList.Count then
    CurrentItem := FList.Count - 1;
  ListToForm;
end;

function TfrmSmsAccounts.ESNString : string;
begin
  Try
    Result := Char(EsnAry[1]) +
              Char(EsnAry[2]) +
              Char(EsnAry[3]) +
              Char(EsnAry[4]) +
              Char(EsnAry[5]) +
              Char(EsnAry[6]) +
              #0#0;
  Except
    Result := '';
  End;
end;



procedure TfrmSmsAccounts.meESN1Exit(Sender: TObject);
begin
  meESN1.Enabled := True;
  ProcessESN7Str(EsnAry, DemoFlag, meESN1);
  meESN1.Enabled := False;
end;

procedure TfrmSmsAccounts.StringToESN(const s : STring);
var
  i : integer;
begin
  FillChar(EsnAry, SizeOf(EsnAry), #0);
  for i := 1 to 6 do
    EsnAry[i] := Ord(s[i]);

  meESN1.Text := ESN2ByteToStr(EsnAry);
end;

procedure TfrmSmsAccounts.CheckSMSCredits1Click(Sender: TObject);
var
  V : Variant;
  LRec : EntLicenceRecType;
begin
  ShowMessage('Not implemented yet');
{
  if ReadEntLic(GetComObjectDir('EnterpriseSMS.SMSSender') + 'Entrprse.dat', LRec) then
  begin

    with TSmsWapLicence.create do
    Try
      FileName := GetComObjectDir('EnterpriseSMS.SMSSender') + 'smail.dat';
      UserName := Trim(edtUser.Text);
      Password := Trim(edtPW.Text);
      ESN := LocalESNString(LRec.licISN);
      if not WriteFile then
        ShowMessage('Unable to write file ' + FileName);
    Finally
      Free;
    End;
    V := CreateOLEObject('EnterpriseSMS.SMSSender');
    Try
      with  TfrmAccount.Create(nil) do
      Try
        SMSSender := V;
        ShowModal;
      Finally
        Free;
      End;
    Finally
      V := Unassigned;
    End;
  end
  else
    ShowMessage('Can''t read Entrprse.dat');
}
end;

function TfrmSmsAccounts.LocalESNString(Ary : ESNByteArrayType) : string;
begin
  Try
    Result := Char(Ary[1]) +
              Char(Ary[2]) +
              Char(Ary[3]) +
              Char(Ary[4]) +
              Char(Ary[5]) +
              Char(Ary[6]) +
              #0#0;
  Except
    Result := '';
  End;
end;

procedure TfrmSmsAccounts.SetControls(Sender : TObject);
var
  InEdit : Boolean;
  i : integer;
begin
  InEdit := (Sender = btnAdd) or (Sender = btnEdit) or (Sender = Add1) or (Sender = Edit1);

  btnAdd.Enabled := not InEdit;
  btnEdit.Enabled := not InEdit;
  btnDel.Enabled := not InEdit;

  btnSave.Enabled := InEdit;
  btnCancel.Enabled := InEdit;


  Add1.Enabled := not InEdit;
  Edit1.Enabled := not InEdit;
  Delete1.Enabled := not InEdit;

  Save1.Enabled := InEdit;
  Cancel1.Enabled := InEdit;

  edtAc.Visible := InEdit;

  cbAc.Enabled := not InEdit;

  for i := 0 to Panel1.ControlCount - 1 do
    if Panel1.Controls[i] is TCustomEdit then
      TEdit(Panel1.Controls[i]).Enabled := InEdit;


end;

procedure TfrmSmsAccounts.CheckSMSCreditsforAllAccounts1Click(
  Sender: TObject);
begin
  ShowMessage('Function not implemented yet');
end;

function TfrmSmsAccounts.DemoOK : Boolean;
var
  DFlag : Byte;
begin
  DFlag := DemoFlag;
  Result := licDecodeDemoFlag(ESNAry, DFlag);

  if Result then
  begin
    Result := Result and (DFlag = 1);
    if not Result then
      ShowMessage('Not a demo system');
  end
  else
    ShowMessage('Invalid ESN DemoFlag');
end;

end.
