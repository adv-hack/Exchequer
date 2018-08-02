unit AdmninF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IniFiles;

type
  TfrmMultiBacAdmin = class(TForm)
    Panel1: TPanel;
    cbGL: TComboBox;
    edtSort: TEdit;
    edtAC: TEdit;
    edtRef: TEdit;
    edtPayF: TEdit;
    edtRecF: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Button1: TButton;
    btnSave: TButton;
    Button5: TButton;
    cbType: TComboBox;
    lblMod: TLabel;
    edtGL: TEdit;
    btnCancel: TButton;
    btnConfigure: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cbGLChange(Sender: TObject);
    procedure edtSortChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure edtGLExit(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnConfigureClick(Sender: TObject);
  private
    { Private declarations }
    TheIni : TIniFile;
    FChanged, FClosing : Boolean;
    OldGL : integer;
    procedure ClearEdits;
    function ReadOneBacs : Boolean;
    function WriteOneBacs : Boolean;
    procedure ReadGLs;
    procedure LoadBacsTypes;
    procedure SetChanged(Value : Boolean);
    procedure ConfigureBacs(WhichBacs : Integer);
    procedure ConfigureABN;
  public
    { Public declarations }
    property DataChanged : Boolean write SetChanged;
  end;

var
  frmMultiBacAdmin: TfrmMultiBacAdmin;

implementation

{$R *.dfm}
uses
  FileUtil, BacConst, ConfigF, AIBConfg, BIConfig, IDConfig, AuConfig, AbnConfg;


const
  MB_INIFILENAME = 'MBacs.ini';

  GL_CODE = 'GL CODE ';

  BANK_SORT = 'BANK_SORT';
  BANK_ACC = 'BANK_ACC';
  BANK_REF = 'BANK_REF';
  BACS_TYPE = 'BACS_TYPE';
  PAY_FILE = 'PAY_FILE';
  REC_FILE = 'REC_FILE';

  ConfigSet = [exAIB, exBnkIre, exIdeal, exNatWest, exAbnAmro];


procedure TfrmMultiBacAdmin.ClearEdits;
var
  i : integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TEdit then
      TEdit(Components[i]).Text := ''
    else
    if Components[i] is TComboBox then
      TComboBox(Components[i]).ItemIndex := -1;
  end;
end;


procedure TfrmMultiBacAdmin.FormCreate(Sender: TObject);
begin
  FChanged := False;
  FClosing := False;
  ClearEdits;
  TheIni := TIniFile.Create(GetEnterpriseDirectory + MB_INIFILENAME);
  LoadBacsTypes;
  ReadGLs;
end;

function TfrmMultiBacAdmin.ReadOneBacs : Boolean;
var
  ThisSection : string;
begin
  if cbGL.ItemIndex > - 1 then
    ThisSection := GL_CODE + cbGL.Items[cbGL.ItemIndex]
  else
    ThisSection := '';

  with TheIni do
  begin
    Result := SectionExists(ThisSection);

    if Result then
    begin

      edtSort.Text := ReadString(ThisSection, BANK_SORT, '');
      edtAC.Text := ReadString(ThisSection, BANK_ACC, '');
      edtRef.Text := ReadString(ThisSection, BANK_REF, '');

      cbType.ItemIndex := ReadInteger(ThisSection, BACS_TYPE, -1);

      edtPayF.Text := ReadString(ThisSection, PAY_FILE, '');
      edtRecF.Text := ReadString(ThisSection, REC_FILE, '');

      cbTypeChange(nil);
      DataChanged := False;
      

    end;
  end;
end;

function TfrmMultiBacAdmin.WriteOneBacs : Boolean;
var
  ThisSection : string;
begin
  if cbGL.ItemIndex > - 1 then
    ThisSection := GL_CODE + cbGL.Items[cbGL.ItemIndex]
  else
    ThisSection := '';

  if ThisSection <> '' then
  with TheIni do
  begin
    begin
      Try
        WriteString(ThisSection, BANK_SORT, Trim(edtSort.Text));
        WriteString(ThisSection, BANK_ACC, Trim(edtAC.Text));
        WriteString(ThisSection, BANK_REF, Trim(edtRef.Text));

        WriteInteger(ThisSection, BACS_TYPE, cbType.ItemIndex);

        WriteString(ThisSection, PAY_FILE, Trim(edtPayF.Text));
        WriteString(ThisSection, REC_FILE, Trim(edtRecF.Text));
        Result := True;
      Except
        on E : Exception do
        begin
          Result := False;
          ShowMessage('Exception: ' + E.Message + ' when writing to file');
        end;
      End;
    end;
  end
  else
  begin
    ShowMessage('No GL Code specified');
    Result := False;
  end;
end;

procedure TfrmMultiBacAdmin.ReadGLs;
var
  AList : TstringList;
  i : integer;
  s : string;
begin
  AList := TStringList.Create;
  Try
    Try
      AList.LoadFromFile(GetEnterpriseDirectory + MB_INIFILENAME);
    Except
    End;

    if AList.Count > 0 then
    begin
      cbGL.Clear;

      for i := 0 to AList.Count - 1 do
      begin
        if Pos('[GL CODE', AList[i]) = 1 then
        begin
          s := Trim(Copy(AList[i], 10, 10));
          if s[Length(s)] = ']' then
            Delete(s, Length(s), 1);
          cbGL.Items.Add(s);
        end;
      end;
      cbGL.ItemIndex := 0;
      FChanged := False;
      cbGLChange(nil);
    end;

  Finally
    AList.Free;
  End;

end;

procedure TfrmMultiBacAdmin.cbGLChange(Sender: TObject);
begin
  if FChanged then
    if MessageDlg('Do you want to save changes?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
       btnSaveClick(Self);

  if not FClosing then
    ReadOneBacs;
end;

procedure TfrmMultiBacAdmin.LoadBacsTypes;
var
  i : integer;
begin
  cbType.Clear;
  for i := 0 to KnownBacsTypes - 2 do
    cbType.Items.Add(BacsShortDescriptions[i]);
end;

procedure TfrmMultiBacAdmin.edtSortChange(Sender: TObject);
begin
  DataChanged := True;
end;

procedure TfrmMultiBacAdmin.btnSaveClick(Sender: TObject);
begin
  if WriteOneBacs then
    DataChanged := False;
end;

procedure TfrmMultiBacAdmin.Button5Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMultiBacAdmin.SetChanged(Value : Boolean);
begin
  if Value then
    lblMod.Caption := 'Data modified'
  else
    lblMod.Caption := '';

  FChanged := Value;
end;

procedure TfrmMultiBacAdmin.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  FClosing := True;
  cbGLChange(nil);
end;

procedure TfrmMultiBacAdmin.Button1Click(Sender: TObject);
begin
  OldGL := cbGL.ItemIndex;
  ClearEdits;
  edtGL.Left := cbGL.Left;
  edtGL.Top := cbGL.Top;
  edtGL.Visible := True;
  btnCancel.enabled := True;
  ActiveControl := edtGL;
end;

procedure TfrmMultiBacAdmin.edtGLExit(Sender: TObject);
var
  i : longint;
begin
  if ActiveControl <> btnCancel then
  Try
    i := StrToInt(edtGL.Text);
    if cbGL.Items.IndexOf(edtGL.Text) > -1 then
    begin
      ShowMessage('GL Code ' + QuotedStr(edtGL.Text) + ' already exists');
      ActiveControl := edtGL;
    end
    else
    begin
      cbGL.Items.Add(edtGL.Text);
      edtGL.Visible := False;
      cbGL.ItemIndex := cbGL.Items.IndexOf(edtGL.Text);
      edtGL.Text := '';
    end;
  Except
    ShowMessage('GL code must be a number');
    ActiveControl := edtGL;
  End;
end;

procedure TfrmMultiBacAdmin.cbTypeChange(Sender: TObject);
begin
  cbType.Hint := cbType.Items[cbType.ItemIndex];
  edtSortChange(Sender);
  btnConfigure.enabled := cbType.ItemIndex in ConfigSet;
end;

procedure TfrmMultiBacAdmin.btnCancelClick(Sender: TObject);
begin
  DataChanged := False;
  cbGL.ItemIndex := OldGL;
  cbGLChange(nil);
  edtGL.Visible := False;
  edtGL.Text := '';
  btnCancel.enabled := False;
end;

procedure TfrmMultiBacAdmin.btnConfigureClick(Sender: TObject);
begin
  Case cbType.ItemIndex of
    exAIB,
    exBnkIre,
    exIdeal,
    exNatwest  : ConfigureBacs(cbType.ItemIndex);
    exAbnAmro : ConfigureABN;
  end;
end;

procedure TfrmMultiBacAdmin.ConfigureBacs(WhichBacs : Integer);
var
  AForm : TfrmBacsConfig;
begin
  Case WhichBacs of
     exAIB      : AForm := TfrmAibConfig.Create(Self);
     exBnkIre   : AForm := TfrmBIConfig.Create(Self);
     exIdeal    : AForm := TfrmIdealConfig.Create(Self);
     exNatwest  : AForm := TfrmAutopayConfig.Create(Self);
     else
       AForm := nil;
  end;

  if Assigned(AForm) then
  Try
    AForm.ShowModal;
  Finally
    AForm.Free;
  End;
end;

procedure TfrmMultiBacAdmin.ConfigureABN;
begin
  with TfrmAbnConfig.Create(Self) do
  Try
    ShowModal;
  Finally
    Free;
  End;

end;


end.
