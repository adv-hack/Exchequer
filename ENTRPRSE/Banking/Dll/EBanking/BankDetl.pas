unit BankDetl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ExtCtrls, uMultiList, Buttons, TEditVal,
  ComCtrls, EnterToTab, Enterprise01_TLB;

const
  //Bank Detail modes
  bdmAdd = 0;
  bdmView = 1;
  bdmEdit = 2;
  bdmStatements = 3;

  WM_UpdateList = WM_User + 101;

type

  TNotifyResultProc = procedure (Sender : TObject; bResult : Boolean) of Object;

  TfrmBankDetails = class(TForm)
    PageControl1: TPageControl;
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
    btnOutPathBrowse: TSpeedButton;
    Label8: TLabel;
    btnStatementBrowse: TSpeedButton;
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
    procedure PageControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SBSButton1Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtGLCodeExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnOutPathBrowseClick(Sender: TObject);
    procedure btnStatementBrowseClick(Sender: TObject);
  private
    { Private declarations }
    OK : Boolean;
    oBankAccount : IBankAccount;
    oToolkit : IToolkit3;
    FOnFormClosed : TNotifyResultProc;
    FMode : Byte;
    FParentHandle : HWND;  //handle of bank list form
    bChangeMessaging : Boolean;
    procedure ShowButtons(IsDefaults : Boolean);
    procedure WriteFields;
    procedure EnableEdits;
    procedure ShowGlDescription;
    function GetGLCode : Boolean;
    function AccountAlreadyExists(const GLCode : string) : Boolean;
    function GetDirectory(const ExistingDir : string) : string;
  public
    { Public declarations }
    procedure SetFields;
    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
    procedure WMKeyDown(Var Message  :  TMessage); Message WM_KeyDown;
    property ParentHandle : HWND read FParentHandle write FParentHandle;
    property Toolkit : IToolkit3 read oToolkit write oToolkit;
    property Mode : Byte read FMode write FMode;
    property BankAccount : IBankAccount read oBankAccount write oBankAccount;
    property OnFormClosed : TNotifyResultProc read FOnFormClosed write FOnFormClosed;
  end;

var
  frmBankDetails: TfrmBankDetails;

implementation

{$R *.dfm}
uses
  GLList, BrwseDir;

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
      //FormDeactivate(Self);
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

procedure TfrmBankDetails.PageControl1Change(Sender: TObject);
begin
  ShowButtons(PageControl1.ActivePage = tabDefaults);
end;

procedure TfrmBankDetails.FormCreate(Sender: TObject);
begin
  Height := 419;
  Width :=  481;
  OK := False;
  bChangeMessaging := True;
end;

procedure TfrmBankDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  if Assigned(FOnFormClosed) then
    FOnFormClosed(Self, OK);
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
      begin
        OK := True;
        PostMessage(FParentHandle, WM_UpdateList, 0, 0);
        Close;
      end
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
  OK := False;
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
  if oBankAccount.baGLCode > 0 then
  begin
    edtGLCode.Text := IntToStr(oBankAccount.baGLCode);
    ShowGLDescription;
  end;
  if oBankAccount.baProduct > 0 then
    cbProduct.ItemIndex := oBankAccount.baProduct - 1
  else
    cbProduct.ItemIndex := 0;
  edtOutputPath.Text := oBankAccount.baOutputPath;
  edtPayFile.Text := oBankAccount.baPayFileName;
  edtRecFile.Text := oBankAccount.baRecFileName;
  edtStatementPath.Text := oBankAccount.baStatementPath;

  EnableEdits;
  ActiveControl := edtGLCode;
end;

procedure TfrmBankDetails.EnableEdits;
var
  i : integer;
  TurnOn : Boolean;
begin
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
  edtGLDesc.ReadOnly := True; //Always

end;

procedure TfrmBankDetails.ShowGlDescription;
var
  Res : Integer;
begin
  with oToolkit do
  begin
    GeneralLedger.Index := glIdxCode;
    Res := GeneralLedger.GetEqual(GeneralLedger.BuildCodeIndex(StrToInt(edtGLCode.Text)));
    if Res = 0 then
      edtGLDesc.Text := Trim(GeneralLedger.glName);
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
  pnlDefaults.Left := PageControl1.Width - pnlDefaults.Width - 10;
  pnlDefaults.Height := PageControl1.Height - 32;

  pnlStatements.Left := pnlDefaults.Left;
  pnlStatements.Height := pnlDefaults.Height;

  mlStatements.Width := pnlDefaults.Left - 13;
  mlStatements.Height := pnlDefaults.Height;

end;

procedure TfrmBankDetails.WMSysCommand(var Message: TMessage);
begin
  With Message do
    Case WParam of

      SC_Maximize  :  Begin
                        {Self.Height:=InitSize.Y;
                        Self.Width:=InitSize.X;}

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

procedure TfrmBankDetails.btnOutPathBrowseClick(Sender: TObject);
begin
  edtOutputPath.Text := GetDirectory(edtOutputPath.Text);
end;

procedure TfrmBankDetails.btnStatementBrowseClick(Sender: TObject);
begin
  edtStatementPath.Text := GetDirectory(edtStatementPath.Text);
end;

end.
