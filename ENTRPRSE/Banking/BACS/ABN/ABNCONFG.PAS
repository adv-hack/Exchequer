unit abnconfg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, IniFiles;

type
  TfrmAbnConfig = class(TForm)
    PageControl1: TPageControl;
    btnSave: TButton;
    btnAdd: TButton;
    Button3: TButton;
    tabControl: TTabSheet;
    tabBanks: TTabSheet;
    GroupBox1: TGroupBox;
    spDomestic: TSpeedButton;
    edtDomesticPay: TLabeledEdit;
    edtDomesticDir: TLabeledEdit;
    GroupBox2: TGroupBox;
    edtForeignPay: TLabeledEdit;
    edtForeignDir: TLabeledEdit;
    GroupBox3: TGroupBox;
    edtPayDesc: TEdit;
    Panel1: TPanel;
    edtGL: TLabeledEdit;
    edtSwift: TLabeledEdit;
    edtBankName: TLabeledEdit;
    edtBankCountry: TLabeledEdit;
    edtISOCountry: TLabeledEdit;
    edtISOCurr: TLabeledEdit;
    edtBankAc: TLabeledEdit;
    edtExchangeCode: TLabeledEdit;
    Label1: TLabel;
    cbBanks: TComboBox;
    spForeign: TSpeedButton;
    edtTown: TLabeledEdit;
    procedure PageControl1Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure spDomesticClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbBanksChange(Sender: TObject);
    procedure edtDomesticPayChange(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    IniFileName : string;
    IniFile : TIniFile;
    FModified : boolean;
    procedure ReadControls;
    procedure WriteControls;

    procedure ReadBanks;

    procedure ReadOneBank;
    procedure WriteOneBank;
  public
    { Public declarations }
  end;

var
  frmAbnConfig: TfrmAbnConfig;

implementation

{$R *.dfm}
uses
  BrwseDir, FileUtil;

procedure TfrmAbnConfig.PageControl1Change(Sender: TObject);
var
  WhichPage : integer;
begin
  btnAdd.Visible := PageControl1.ActivePageIndex = 1;
  if FModified then
  begin
    if Sender <> nil then
      WhichPage := PageControl1.ActivePageIndex
    else
      WhichPage := 2;
    if MessageDlg('Do you want to save your changes?',
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      Case WhichPage of
        0  : WriteOneBank;
        1  : WriteControls;
        2  : begin
                WriteControls;
                WriteOneBank;
             end;
      end;
  end;
end;

procedure TfrmAbnConfig.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbnConfig.spDomesticClick(Sender: TObject);
begin
  with TBrowseDirDialog.Create do
  Try
    KeepCurrDir := False;
    AddBackSlash := False;
    Case TSpeedButton(Sender).Tag of
      0  :  Directory  := edtDomesticDir.Text;
      1  :  Directory := edtForeignDir.Text;
    end;
    if Execute then
      Case TSpeedButton(Sender).Tag of
        0  :  edtDomesticDir.Text := Directory;
        1  :  edtForeignDir.Text := Directory;
      end;
  Finally
    Free;
  End;

end;

procedure TfrmAbnConfig.ReadControls;
begin
  edtDomesticPay.Text := IniFile.ReadString('CONTROL', 'DOMESTIC_PAYMENT_GL', '');
  edtDomesticDir.Text := IniFile.ReadString('CONTROL', 'DOMESTIC_DIR', '');

  edtForeignPay.Text := IniFile.ReadString('CONTROL', 'FOREIGN_PAYMENT_GL', '');
  edtForeignDir.Text := IniFile.ReadString('CONTROL', 'FOREIGN_DIR', '');

  edtPayDesc.Text := IniFile.ReadString('CONTROL', 'PAYMENT_DESC', '');
end;

procedure TfrmAbnConfig.WriteControls;
begin
  IniFile.WriteString('CONTROL', 'DOMESTIC_PAYMENT_GL', edtDomesticPay.Text);
  IniFile.WriteString('CONTROL', 'DOMESTIC_DIR', IncludeTrailingBackslash(edtDomesticDir.Text));

  IniFile.WriteString('CONTROL', 'FOREIGN_PAYMENT_GL', edtForeignPay.Text);
  IniFile.WriteString('CONTROL', 'FOREIGN_DIR', IncludeTrailingBackslash(edtForeignDir.Text));

  IniFile.WriteString('CONTROL', 'PAYMENT_DESC', edtPayDesc.Text);

  FModified := False;
end;

procedure TfrmAbnConfig.ReadBanks;
var
  AList : TStringList;
  i : integer;
  s : string;
begin
  AList := TStringList.Create;
  Try
    Try
      AList.LoadFromFile(IniFileName);
      for i := 0 to AList.Count -1 do
      begin
        s := UpperCase(Trim(AList[i]));
        if Pos('[BANK', s) = 1 then
        begin
          if s[Length(s)] = ']' then
            Delete(s, Length(s), 1);
          cbBanks.Items.Add(Copy(s, 6, Length(s)));
        end;
      end;
    Except
    End;
  Finally
    AList.Free;
  End;

end;

procedure TfrmAbnConfig.WriteOneBank;
var
  Section : String;
  TempI : integer;
begin
  Try
    TempI := StrToInt(cbBanks.Items[cbBanks.ItemIndex]);
  Except
    cbBanks.Items[cbBanks.ItemIndex] := '1';
  End;
  Section := 'BANK' + cbBanks.Items[cbBanks.ItemIndex];



  with IniFile do
  begin
    WriteString(Section, 'ENT_GL_CODE', edtGL.Text);
    WriteString(Section, 'SWIFT_CODE', edtSwift.Text);

    WriteString(Section, 'BANK_NAME', edtBankName.Text);
    WriteString(Section, 'BANK_TOWN', edtTown.Text);
    WriteString(Section, 'BANK_COUNTRY', edtBankCountry.Text);

    WriteString(Section, 'BANK_ISO_COUNTRY', edtISOCountry.Text);
    WriteString(Section, 'BANK_ISO_CURRENCY', edtISOCurr.Text);

    WriteString(Section, 'BANK_ACCOUNT_NO', edtBankAc.Text);
    WriteString(Section, 'BANK_EXCHANGE_CODE', edtExchangeCode.Text);
  end;
  FModified := False;
end;

procedure TfrmAbnConfig.ReadOneBank;
var
  Section : String;
begin
  Section := 'BANK' + cbBanks.Items[cbBanks.ItemIndex];

  with IniFile do
  begin
    edtGL.Text := ReadString(Section, 'ENT_GL_CODE', '');
    edtSwift.Text := ReadString(Section, 'SWIFT_CODE', '');

    edtBankName.Text := ReadString(Section, 'BANK_NAME', '');
    edtTown.Text := ReadString(Section, 'BANK_TOWN', '');
    edtBankCountry.Text := ReadString(Section, 'BANK_COUNTRY', '');

    edtISOCountry.Text := ReadString(Section, 'BANK_ISO_COUNTRY', '');
    edtISOCurr.Text := ReadString(Section, 'BANK_ISO_CURRENCY', '');

    edtBankAc.Text := ReadString(Section, 'BANK_ACCOUNT_NO', '');
    edtExchangeCode.Text := ReadString(Section, 'BANK_EXCHANGE_CODE', '');
  end;

end;

procedure TfrmAbnConfig.FormCreate(Sender: TObject);
begin
  IniFileName := GetEnterpriseDirectory + 'ENTABNHK.INI';
  ReadBanks;

  IniFile := TIniFile.Create(IniFileName);
  ReadControls;

  cbBanks.ItemIndex := 0;
  cbBanksChange(nil);

  FModified := False;
end;

procedure TfrmAbnConfig.cbBanksChange(Sender: TObject);
begin
  ReadOneBank;
end;

procedure TfrmAbnConfig.edtDomesticPayChange(Sender: TObject);
begin
  FModified := True;
end;

procedure TfrmAbnConfig.btnAddClick(Sender: TObject);
var
  i : integer;
begin
  Try
    i := StrToInt(cbBanks.Items[cbBanks.Items.Count - 1]);
  Except
    i := 0;
  End;
  inc(i);
  cbBanks.Items.Add(IntToStr(i));
  cbBanks.ItemIndex := cbBanks.Items.Count - 1;
  cbBanksChange(nil);
end;

procedure TfrmAbnConfig.btnSaveClick(Sender: TObject);
begin
  Case PageControl1.ActivePageIndex of
    0  : WriteControls;
    1  : WriteOneBank;
  end;

end;

procedure TfrmAbnConfig.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  Res : integer;
begin
  if FModified then
    Res := MessageDlg('Do you want to save your changes?',
                    mtConfirmation, mbYesNoCancel, 0)
  else
    Res := mrNo;

  if Res = mrCancel then
    CanClose := False
  else
  if Res = mrYes then
    btnSaveClick(Self);
end;

end.
