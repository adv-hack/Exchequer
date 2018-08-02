unit BankDetl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ExtCtrls, uMultiList, Buttons, TEditVal,
  ComCtrls, EnterToTab, Enterprise01_TLB, uSettings, Menus;

const
  //Bank Detail modes
  bdmAdd = 0;
  bdmView = 1;
  bdmEdit = 2;
  bdmStatements = 3;
  bdmDelete = 4;

  WM_UpdateList = WM_User + 102;

type


  TfrmBankDetails = class(TForm)
    pgDetails: TPageControl;
    tabDefaults: TTabSheet;
    tabStatements: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cbProduct: TSBSComboBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edtGLDesc: TEdit;
    edtSortCode: TEdit;
    edtAcNo: TEdit;
    edtPayFile: TEdit;
    edtRecFile: TEdit;
    edtOutputPath: TEdit;
    edtStatementPath: TEdit;
    mlStatements: TMultiList;
    EnterToTab1: TEnterToTab;
    edtGLCode: TEdit;
    pnlStatements: TPanel;
    SBSButton1: TSBSButton;
    SBSButton2: TSBSButton;
    SBSButton3: TSBSButton;
    SBSButton4: TSBSButton;
    SBSButton5: TSBSButton;
    pnlDefaults: TPanel;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    PopupMenu1: TPopupMenu;
    Properties1: TMenuItem;
    N1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    PopupMenu2: TPopupMenu;
    Properties2: TMenuItem;
    N2: TMenuItem;
    SaveCoordinates2: TMenuItem;
    Import1: TMenuItem;
    Reconcile1: TMenuItem;
    Delete1: TMenuItem;
    Print1: TMenuItem;
    N3: TMenuItem;
    SBSButton6: TSBSButton;
    SBSButton7: TSBSButton;
    procedure pgDetailsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SBSButton1Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtGLCodeExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure Properties2Click(Sender: TObject);
    procedure SBSButton7Click(Sender: TObject);
    procedure SBSButton6Click(Sender: TObject);
  private
    { Private declarations }
    oBankAccount : IBankAccount;
    oToolkit : IToolkit3;
    FOnFormClosed : TNotifyEvent;
    FMode : Byte;
    FParentHandle : HWND;  //handle of bank list form
    bRestore : Boolean;
    InitSize : TPoint;
    procedure LoadStatements;
    procedure ShowButtons(IsDefaults : Boolean);
    procedure WriteFields;
    procedure EnableEdits;
    function ShowGlDescription : String;
    function GetGLCode : Boolean;
    function AccountAlreadyExists(const GLCode : string) : Boolean;
    function GetDirectory(const ExistingDir : string) : string;
    procedure SaveAllSettings;
    procedure LoadAllSettings;

  public
    { Public declarations }
    procedure SetFields;
    procedure ShowDelete;
    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
    procedure WMKeyDown(Var Message  :  TMessage); Message WM_KeyDown;
    property ParentHandle : HWND read FParentHandle write FParentHandle;
    property Toolkit : IToolkit3 read oToolkit write oToolkit;
    property Mode : Byte read FMode write FMode;
    property BankAccount : IBankAccount read oBankAccount write oBankAccount;
    property OnFormClosed : TNotifyEvent read FOnFormClosed write FOnFormClosed;
  end;

var
  frmBankDetails: TfrmBankDetails;

implementation

{$R *.dfm}
uses
  GLList, BrwseDir, ApiUtil;

function TfrmBankDetails.GetGLCode : Boolean;
var
  Res : longint;
  gl : longint;
  c : Integer;
begin
  with oToolkit do
  begin
    Val(edtGLCode.Text, gl, c);
    if c = 0 then
      Res := GeneralLedger.GetEqual(GeneralLedger.BuildCodeIndex(gl))
    else
      Res := 1;
    Result := Res = 0;
    if Result then
      edtGLDesc.Text := Trim(GeneralLedger.glName)
    else
    begin
      with TfrmGLList.Create(nil) do
      Try
        ctkGL.ToolkitObject := GeneralLedger as IBtrieveFunctions2;
        dmlGLCodes.Active := True;
        ShowModal;
        Result := ModalResult = mrOK;
        if Result then
        with ctkGL.GetRecord as IGeneralLedger do
        begin
          edtGLCode.Text := IntToStr(glCode);
          edtGLDesc.Text := glName;
        end;
      Finally
        Free;
      End;

    end;

  end;

end;

{ TForm1 }

procedure TfrmBankDetails.ShowButtons(IsDefaults: Boolean);
begin
  pnlDefaults.Visible := IsDefaults;
  pnlStatements.Visible := not IsDefaults;
end;

procedure TfrmBankDetails.pgDetailsChange(Sender: TObject);
begin
  ShowButtons(pgDetails.ActivePage = tabDefaults);
  if pgDetails.ActivePage = tabStatements then
    LoadStatements;
end;

procedure TfrmBankDetails.FormCreate(Sender: TObject);
begin
  Height := 347;
  Width :=  471;
  bRestore := False;
  LoadAllSettings;
  InitSize.X := Width;
  InitSize.Y := Height;
end;

procedure TfrmBankDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
  PostMessage(FParentHandle, WM_UpdateList, 0, 0);
  if Assigned(FOnFormClosed) then
    FOnFormClosed(Self);
  if Mode <> bdmDelete then
    oBankAccount := nil;
  Action := caFree;
end;

procedure TfrmBankDetails.SBSButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmBankDetails.btnOKClick(Sender: TObject);
var
  Res : longint;
begin

  if (Mode in [bdmAdd, bdmEdit]) then
  begin
    if (Mode = bdmEdit) or not AccountAlreadyExists(edtGLCode.Text) then
    begin
      WriteFields;
      Res := oBankAccount.Save;
      if Res = 0 then
        Close
      else
        ShowMessage('Error occurred saving the Bank Account: ' + IntToStr(Res));
    end
    else
    begin
      ShowMessage('Bank Account ' + Trim(edtGLCode.Text) + ' already exists');
      ActiveControl := edtGLCode;
    end;
  end
  else
    Close;
end;

procedure TfrmBankDetails.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmBankDetails.WriteFields;
begin
  oBankAccount.baGLCode := StrToInt(edtGLCode.Text);
  oBankAccount.baProduct := cbProduct.ItemIndex + 1;
  oBankAccount.baOutputPath := Trim(edtOutputPath.Text);
  oBankAccount.baPayFileName := Trim(edtPayFile.Text);
  oBankAccount.baRecFileName := Trim(edtRecFile.Text);
  oBankAccount.baStatementPath := Trim(edtStatementPath.Text);
end;

procedure TfrmBankDetails.SetFields;
begin
  tabStatements.TabVisible := FMode in [bdmView, bdmStatements];
//  tabStatements.TabVisible := tabStatements.Visible;
  if oBankAccount.baGLCode > 0 then
  begin
    edtGLCode.Text := IntToStr(oBankAccount.baGLCode);
    edtGLDesc.Text := ShowGLDescription;
  end;
  if oBankAccount.baProduct > 0 then
    cbProduct.ItemIndex := oBankAccount.baProduct - 1
  else
    cbProduct.ItemIndex := 0;
  edtOutputPath.Text := oBankAccount.baOutputPath;
  edtPayFile.Text := oBankAccount.baPayFileName;
  edtRecFile.Text := oBankAccount.baRecFileName;
  edtStatementPath.Text := oBankAccount.baStatementPath;

  Case FMode of
    bdmAdd : Caption := 'Add Bank Account Record';
    else
      Caption := 'Bank Account Record - ' + ShowGLDescription;
  end;


  if fMode = bdmStatements then
  begin
    pgDetails.ActivePage := TabStatements;
  end
  else
  begin
    EnableEdits;
    ActiveControl := edtGLCode;
    pgDetails.ActivePage := TabDefaults;
  end;
  pgDetailsChange(pgDetails);
end;

procedure TfrmBankDetails.EnableEdits;
var
  i : integer;
  TurnOn : Boolean;
begin
  edtGLDesc.ReadOnly := True; //Always
  TurnOn := Mode in [bdmAdd, bdmEdit];
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TEdit then
      TEdit(Components[i]).ReadOnly := not TurnOn
    else
    if Components[i] is TSBSComboBox then
      TSBSComboBox(Components[i]).ReadOnly := not TurnOn;

  btnCancel.Visible := TurnOn;
  if TurnOn then
    btnOK.Caption := '&OK'
  else
    btnOk.Caption := 'Close';

end;

function TfrmBankDetails.ShowGlDescription : string;
var
  Res : Integer;
begin
  with oToolkit do
  begin
    GeneralLedger.Index := glIdxCode;
    Res := GeneralLedger.GetEqual(GeneralLedger.BuildCodeIndex(StrToInt(edtGLCode.Text)));
    if Res = 0 then
      Result := Trim(GeneralLedger.glName);
  end;
end;

procedure TfrmBankDetails.edtGLCodeExit(Sender: TObject);
begin
  if (ActiveControl <> btnCancel) and not GetGLCode then
    ActiveControl := edtGLCode;
end;

function TfrmBankDetails.AccountAlreadyExists(
  const GLCode: string): Boolean;
var
  gl : longint;
  c  : integer;
begin
  with oToolkit.Banking do
  begin
    Val(GLCode, gl, c);
    Result := (c = 0) and (BankAccount.GetEqual(BankAccount.BuildGLCodeIndex(gl)) = 0);
  end;
end;

procedure TfrmBankDetails.FormResize(Sender: TObject);
begin
  pnlDefaults.Left := pgDetails.Width - pnlDefaults.Width - 10;
  pnlDefaults.Height := pgDetails.Height - 32;

  pnlStatements.Left := pnlDefaults.Left;
  pnlStatements.Height := pnlDefaults.Height;

  mlStatements.Width := pnlDefaults.Left - 4;
  mlStatements.Height := pnlDefaults.Height;

end;

procedure TfrmBankDetails.WMSysCommand(var Message: TMessage);
begin
  With Message do
    Case WParam of

      SC_Maximize  :  Begin
                        Self.Height:=InitSize.Y;
                        Self.Width:=InitSize.X;

                       { Self.ClientHeight:=InitSize.Y;
                        Self.ClientWidth:=InitSize.X;}

                        WParam:=0;
                      end;

    end; {Case..}

  Inherited;
end;

procedure TfrmBankDetails.WMKeyDown(var Message: TMessage);
begin
end;

function TfrmBankDetails.GetDirectory(const ExistingDir: string): string;
begin
  with TBrowseDirDialog.Create do
  Try
    Directory := ExistingDir;
    if Execute then
      Result := Directory
    else
      Result := ExistingDir;
  Finally
    Free;
  End;
end;

procedure TfrmBankDetails.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadParentToControl(Self.Name, Self.Name, edtGLCode);
  oSettings.ColorFieldsFrom(edtGLCode, Self);
  oSettings.LoadList(mlStatements, Self.Name);
end;

procedure TfrmBankDetails.SaveAllSettings;
begin
  oSettings.SaveList(mlStatements, Self.Name);
  oSettings.SaveParentFromControl(edtGLCode, Self.Name);
  if (SaveCoordinates1.Checked) or (SaveCoordinates2.Checked) then oSettings.SaveForm(Self);
end;



procedure TfrmBankDetails.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(nil, Self.Name, edtGLCode) of
    mrOK : oSettings.ColorFieldsFrom(edtGLCode, Self);
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmBankDetails.Properties2Click(Sender: TObject);
begin
  case oSettings.Edit(mlStatements, Self.Name, nil) of
{    mrOK : oSettings.ColorFieldsFrom(cmbCompany, Self);}
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      oSettings.RestoreListDefaults(mlStatements, Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmBankDetails.SBSButton7Click(Sender: TObject);
begin
  edtStatementPath.Text := GetDirectory(edtStatementPath.Text);
end;

procedure TfrmBankDetails.ShowDelete;
var
  Res : longint;
begin
  if FMode = bdmDelete then
  begin
    pgDetails.ActivePageIndex := 0;
    if msgBox('Please confirm you wish'#10'to delete this Bank Account record', mtConfirmation, [mbYes, mbNo],
                 mbYes, 'Confirm') = mrYes then
    begin
      Res := oBankAccount.Delete;

      if Res = 0 then
        Close
      else
        ShowMessage('Unable to delete record. Error ' + IntToStr(Res));

    end;
  end;
end;

procedure TfrmBankDetails.LoadStatements;
begin
//TODO
end;

procedure TfrmBankDetails.SBSButton6Click(Sender: TObject);
begin
  edtOutputPath.Text := GetDirectory(edtOutputPath.Text);
end;

end.
