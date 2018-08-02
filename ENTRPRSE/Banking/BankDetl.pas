unit BankDetl;

interface
{$WARN SYMBOL_PLATFORM OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ExtCtrls, uMultiList, Buttons, TEditVal,
  ComCtrls, EnterToTab, Enterprise04_TLB, uSettings, Menus, uExDatasets,
  uComTKDataset, uDBMultiList, BtSupU1, EnterpriseBeta_TLB;

const
  //Bank Detail modes
  bdmAdd = 0;
  bdmView = 1;
  bdmEdit = 2;
  bdmStatements = 3;
  bdmDelete = 4;
  bdmStatementsOnly = 5;

  MapDir = 'Bank\Maps\';

  MapSet = [5];

  WM_UpdateList = WM_User + 101;
  WM_LISTDBCLICK = WM_User + 102;

type

  TStatementPos = Class
    Position : longint;
  end;

  TfrmBankDetails = class(TForm)
    pgDetails: TPageControl;
    tabDefaults: TTabSheet;
    tabStatements: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
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
    EnterToTab1: TEnterToTab;
    edtGLCode: TEdit;
    pnlStatements: TPanel;
    btnClose2: TSBSButton;
    btnImport: TSBSButton;
    btnReconcile: TSBSButton;
    btnDelete: TSBSButton;
    btnPrint: TSBSButton;
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
    OpenDialog1: TOpenDialog;
    btnClose: TSBSButton;
    btnEdit: TSBSButton;
    btnAdd: TSBSButton;
    ctkStatements: TComTKDataset;
    mlStatements: TDBMultiList;
    edtRef: TEdit;
    Label9: TLabel;
    edtUserID: TEdit;
    Label10: TLabel;
    Label4: TLabel;
    edtRecUserID: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    procedure pgDetailsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnClose2Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtGLCodeExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure Properties2Click(Sender: TObject);
    procedure SBSButton7Click(Sender: TObject);
    procedure SBSButton6Click(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure ctkStatementsGetFieldValue(Sender: TObject; ID: IDispatch;
      FieldName: String; var FieldValue: String);
    procedure btnPrintClick(Sender: TObject);
    procedure ctkStatementsSelectRecord(Sender: TObject;
      SelectType: TSelectType; Address: Integer; ID: IDispatch);
    procedure btnReconcileClick(Sender: TObject);
    procedure mlStatementsAfterLoad(Sender: TObject);
    procedure ctkStatementsFilterRecord(Sender: TObject; ID: IDispatch;
      var Include: Boolean);
    procedure mlStatementsRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure mlStatementsColumnClick(Sender: TObject; ColIndex: Integer;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    oBankAccount : IBankAccount;
    oToolkit : IToolkit3;
    FOnFormClosed : TNotifyEvent;
    FMode : Byte;
    FParentHandle : HWND;  //handle of bank list form
    bRestore : Boolean;
    InitSize : TPoint;
    OK : Boolean;
    procedure LoadStatements;
    procedure ShowButtons(IsDefaults : Boolean);
    procedure WriteFields;
    procedure EnableEdits;
    function ShowGlDescription : String;
    function AccountAlreadyExists(const GLCode : string) : Boolean;
    function GetDirectory(const ExistingDir : string) : string;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
    function StatementTotal(oStatement : IBankStatement) : Double;
    procedure ClearFields;
    procedure SetBankAccount(AnAccount : IBankAccount);
    function MapFileExists : Boolean;
    procedure ShowTransList;
    function ProductToList(Index : integer) : integer;
  public
    { Public declarations }
    procedure SetFields;
    procedure ShowDelete;
    procedure SetCurrentStatement(const StatDate : string; StatFolio : longint);
    procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;
    property ParentHandle : HWND read FParentHandle write FParentHandle;
    property Toolkit : IToolkit3 read oToolkit write oToolkit;
    property Mode : Byte read FMode write FMode;
    property BankAccount : IBankAccount read oBankAccount write SetBankAccount;
    property OnFormClosed : TNotifyEvent read FOnFormClosed write FOnFormClosed;
  end;


  function GetGLCode(const AToolkit : IToolkit; const GLCode : string; AOwner : TForm; BanksOnly : Boolean = True) : IGeneralLedger;

var
  frmBankDetails: TfrmBankDetails;

implementation

{$R *.dfm}
uses
  GLList, BrwseDir, ApiUtil, FileUtil, ImpProgF, EtDateU, StatPrnt, VarRec2U, Varconst,
  BtKeys1U, TransLst, ReconObj, TranFile, PWarnU, InvListU;

var
  LocalListSettings : TRecListSettings;


function GetGLCode(const AToolkit : IToolkit; const GLCode : string; AOwner : TForm; BanksOnly : Boolean = True) : IGeneralLedger;
var
  FoundCode  :  ShortString;
  FoundNom   :  LongInt;
  Res : longint;
begin
  Result := nil;

  FoundNom := 0;
  FoundCode := GLCode;
  if GetNom(AOwner, FoundCode, FoundNom, 11) then
  begin
    Res := AToolkit.GeneralLedger.GetEqual(AToolkit.GeneralLedger.BuildCodeIndex(FoundNom));
    if Res = 0 then
       Result := AToolkit.GeneralLedger;
  end;

{  with AToolkit do
  begin
    if gl > 0 then
      Res := GeneralLedger.GetEqual(GeneralLedger.BuildCodeIndex(gl))
    else
      Res := 1;
    if (Res = 0) and (((GeneralLedger as IGeneralLedger2).glClass = glcBankAccount) or not BanksOnly) then
      Result := GeneralLedger
    else
    begin
      with TfrmGLList.Create(nil) do
      Try
        BankAcsOnly := BanksOnly;
        ctkGL.ToolkitObject := GeneralLedger as IBtrieveFunctions2;
        dmlGLCodes.Active := True;
        ShowModal;
        if ModalResult = mrOK then
          Result := ctkGL.GetRecord as IGeneralLedger;
      Finally
        Free;
      End;

    end;

  end; }

end;

{ TForm1 }

procedure TfrmBankDetails.ShowButtons(IsDefaults: Boolean);
begin
  pnlDefaults.Visible := IsDefaults;
  pnlStatements.Visible := not IsDefaults;
end;

procedure TfrmBankDetails.pgDetailsChange(Sender: TObject);
var
  IsDefaults : Boolean;
begin
  IsDefaults := pgDetails.ActivePage = tabDefaults;
  ShowButtons(IsDefaults);
  if IsDefaults then
    HelpContext := 1958
  else
    HelpContext := 1980;
  mlStatements.active := pgDetails.ActivePage <> tabDefaults;
  if (pgDetails.ActivePage = tabDefaults) and (FMode = bdmStatements) then
    FMode := bdmView
  else
  if (pgDetails.ActivePage = tabStatements) and (FMode = bdmView) then
    FMode := bdmStatements;

  btnClose.Cancel := IsDefaults and (FMode <> bdmEdit);
  btnCancel.Cancel := IsDefaults and (FMode = bdmEdit);
  btnClose2.Cancel := not IsDefaults;

{  if pgDetails.ActivePage = tabStatements then
    LoadStatements;}
end;

procedure TfrmBankDetails.FormCreate(Sender: TObject);
begin
  oSettings.EXEName := ExtractFilename(GetModuleName(HInstance));
  oSettings.UserName := Trim(UserProfile.Login);

  Height := 423;
  Width :=  471;
  bRestore := False;
  LoadAllSettings;
  InitSize.X := Width;
  InitSize.Y := Height;
  OK := False;
end;

procedure TfrmBankDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SendMessage(ParentHandle, WM_CustGetRec, 201, 0);
  if not bRestore then SaveAllSettings;
//  PostMessage(FParentHandle, WM_UpdateList, 0, 0);
  if Assigned(FOnFormClosed) then
    FOnFormClosed(Self);
  if (Mode = bdmEdit) and not OK then
    oBankAccount.Cancel;
  if Mode <> bdmDelete then
    oBankAccount := nil;
  Action := caFree;
end;

procedure TfrmBankDetails.btnClose2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmBankDetails.btnOKClick(Sender: TObject);
var
  Res, lp : longint;
begin

  if (Mode in [bdmAdd, bdmEdit]) then
  begin
    OK := True;
    if (Mode = bdmEdit) or not AccountAlreadyExists(edtGLCode.Text) then
    begin
      WriteFields;
      Res := oBankAccount.Save;
      if Res = 0 then
      begin
        oBankAccount := oToolkit.Banking.BankAccount;
        Res := oBankAccount.GetEqual(oBankAccount.BuildGLCodeIndex(StrToInt(edtGLCode.Text)));
        if (Mode = bdmAdd) and (Res = 0) then
          lp := oBankAccount.baGLCode
        else
          lp := 0;
        PostMessage(FParentHandle, WM_UpdateList, 0, lp);
        Mode := bdmView;
        EnableEdits;
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
  if Mode in [bdmAdd, bdmEdit] then
  begin
    if Mode = bdmEdit then
      oBankAccount.Cancel;
    oBankAccount := oToolkit.Banking.BankAccount;
    Mode := bdmView;
    EnableEdits;
    SetFields;
  end
  else
    Close;
end;

procedure TfrmBankDetails.WriteFields;
begin
  oBankAccount.baGLCode := StrToInt(edtGLCode.Text);
  oBankAccount.baProduct := Integer(cbProduct.Items.Objects[cbProduct.ItemIndex]);
  oBankAccount.baOutputPath := Trim(edtOutputPath.Text);
  oBankAccount.baPayFileName := Trim(edtPayFile.Text);
  oBankAccount.baRecFileName := Trim(edtRecFile.Text);
  oBankAccount.baStatementPath := Trim(edtStatementPath.Text);
  oBankAccount.baSortCode := Trim(edtSortCode.Text);
  oBankAccount.baAccountNo := Trim(edtAcNo.Text);
  oBankAccount.baReference := Trim(edtRef.Text);
  oBankAccount.baUserID := Trim(edtUserID.Text);
  (oBankAccount as IBankAccount2).baReceiptUserID := Trim(edtRecUserID.Text);
end;

procedure TfrmBankDetails.SetFields;
begin
//  tabStatements.TabVisible := tabStatements.Visible;
  if oBankAccount.baGLCode > 0 then
  begin
    edtGLCode.Text := IntToStr(oBankAccount.baGLCode);
    edtGLDesc.Text := ShowGLDescription;
  end;
  if oBankAccount.baProduct > 0 then
    cbProduct.ItemIndex := ProductToList(oBankAccount.baProduct)
  else
    cbProduct.ItemIndex := 0;
  edtOutputPath.Text := oBankAccount.baOutputPath;
  edtPayFile.Text := oBankAccount.baPayFileName;
  edtRecFile.Text := oBankAccount.baRecFileName;
  edtStatementPath.Text := oBankAccount.baStatementPath;

  edtSortCode.Text := oBankAccount.baSortCode;
  edtAcNo.Text := oBankAccount.baAccountNo;

  edtRef.Text := oBankAccount.baReference;
  edtUserID.Text := oBankAccount.baUserID;
  edtRecUserID.Text := (oBankAccount as IBankAccount2).baReceiptUserID;

  HelpContext := 1980;
  mlStatements.HelpContext := 1980;
  Case FMode of
    bdmAdd : Caption := 'Add Bank Account Record';
    bdmStatementsOnly : begin
                          Caption := 'Select Bank Statement';
                          btnClose2.Caption := '&OK';
                          HelpContext := 2021;
                          mlStatements.HelpContext := 2021;
                        end;
    else
      Caption := 'Bank Account Record - ' + ShowGLDescription;
  end;


  if fMode in [bdmStatements, bdmStatementsOnly] then
  begin
    pgDetails.ActivePage := TabStatements;
    if fMode = bdmStatementsOnly then
      TabDefaults.TabVisible := False;
  end
  else
  begin
    pgDetails.ActivePage := TabDefaults;
    ActiveControl := edtGLCode;
  end;
  EnableEdits;
  pgDetailsChange(pgDetails);
end;

procedure TfrmBankDetails.EnableEdits;
var
  i : integer;
  TurnOn : Boolean;
begin
  tabStatements.TabVisible := FMode in [bdmView, bdmStatements, bdmStatementsOnly];
  edtGLDesc.ReadOnly := True; //Always
  TurnOn := Mode in [bdmAdd, bdmEdit];
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TEdit then
      TEdit(Components[i]).ReadOnly := not TurnOn
    else
    if Components[i] is TSBSComboBox then
      TSBSComboBox(Components[i]).ReadOnly := not TurnOn;

  btnCancel.Enabled := TurnOn;
  btnOK.Enabled := TurnOn;
  btnEdit.Enabled := not TurnOn;
  btnAdd.Enabled := not TurnOn;
  btnImport.Enabled := MapFileExists;
  btnReconcile.Enabled := fMode = bdmStatementsOnly;

{  if fMode in [bdmStatements, bdmStatementsOnly] then
    ActiveControl := mlStatements;}
end;

function TfrmBankDetails.ShowGlDescription : string;
var
  Res : Integer;
  gl : longint;
  c  : integer;
begin
  Val(edtGLCode.Text, gl, c);
  if (c = 0) and (gl > 0) then
    with oToolkit do
    begin
      GeneralLedger.Index := glIdxCode;
      Res := GeneralLedger.GetEqual(GeneralLedger.BuildCodeIndex(gl));
      if Res = 0 then
        Result := Trim(GeneralLedger.glName);
    end;
end;

procedure TfrmBankDetails.edtGLCodeExit(Sender: TObject);
var
  oGL : IGeneralLedger;
  c : integer;
  gl : longint;
begin
  if (FMode in [bdmEdit, bdmAdd]) and (ActiveControl <> btnCancel) then
  begin
{    Val(edtGLCode.Text, gl, c);
    if c > 0 then
      gl := 0;}
    oGL := GetGLCode(oToolkit, edtGLCode.Text, Self, Syss.UseGLClass);
    if Assigned(oGL) then
    with oGL do
    begin
      edtGLCode.Text := IntToStr(glCode);
      edtGLDesc.Text := glName;
    end
    else
      ActiveControl := edtGLCode;

  end;
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

  GroupBox1.Width := pnlDefaults.Left - 7;
  GroupBox2.Width := pnlDefaults.Left - 7;
  GroupBox3.Width := pnlDefaults.Left - 7;


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
  oSettings.LoadList(mlStatements, Self.Name);
  oSettings.LoadParentToControl(Self.Name, Self.Name, edtGLCode);
  oSettings.ColorFieldsFrom(edtGLCode, Self);
end;

procedure TfrmBankDetails.SaveAllSettings;
begin
  oSettings.SaveList(mlStatements, Self.Name);
  oSettings.SaveParentFromControl(edtGLCode, Self.Name);
  if (SaveCoordinates1.Checked) or (SaveCoordinates2.Checked) then oSettings.SaveForm(Self);
end;



procedure TfrmBankDetails.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(mlStatements, Self.Name, edtGLCode) of
    mrOK : oSettings.ColorFieldsFrom(edtGLCode, Self);
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);

      //PR: 30/07/2012 ABSEXCH-12952 List defaults was missing.
      oSettings.RestoreListDefaults(mlStatements, Self.Name);
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
var
  Res : longint;
  StatementPos : TStatementPos;
begin
  mlStatements.RefreshDB;
end;

procedure TfrmBankDetails.SBSButton6Click(Sender: TObject);
begin
  edtOutputPath.Text := GetDirectory(edtOutputPath.Text);
end;

function TfrmBankDetails.StatementTotal(oStatement : IBankStatement): Double;
var
  Res : longint;
begin
  Result := 0;
  with oStatement do
  begin
    Res := bsStatementLine.GetFirst;

    while Res = 0 do
    begin
      Result := Result + bsStatementLine.bslValue;

      Res := bsStatementLine.GetNext;
    end;
  end;
end;

procedure TfrmBankDetails.btnImportClick(Sender: TObject);
begin
  with OpenDialog1 do
  begin
    InitialDir := oBankAccount.baStatementPath;
    if Execute then
    begin
      if not Assigned(frmImportStatement) then
        frmImportStatement := TfrmImportStatement.Create(Application);
      with frmImportStatement do
      begin
        BankAccount := oBankAccount;
        Toolkit := oToolkit;
        ProgressBar1.Position := 0;
        Filename := OpenDialog1.FileName;
        MapFilename := IncludeTrailingBackslash(GetEnterpriseDirectory) + MapDir +
                            {oBankAccount.baProductString}
                            oToolkit.Banking.BankProducts.bpStatementFormat[Integer(cbProduct.Items.Objects[cbProduct.ItemIndex])]
                                                    + '.map';
        Show;
        ShowProgress;
        LoadStatements;
      end;
    end;
  end;
end;


procedure TfrmBankDetails.btnCloseClick(Sender: TObject);
var
  Res : integer;
begin
  if Mode in [bdmAdd, bdmEdit] then
  begin
    Res := msgBox('Save changes to ' + Caption + '?', mtConfirmation, mbYesNoCancel, mbYes, 'Confirm');
    if Res = mrYes then
      btnOKClick(Self)
    else
    if Res = mrNo then
      Close;
  end
  else
    Close;
end;

procedure TfrmBankDetails.btnEditClick(Sender: TObject);
begin
  oBankAccount := oBankAccount.Update;
  Mode := bdmEdit;
  EnableEdits;
  ActiveControl := edtGLCode;
end;

procedure TfrmBankDetails.btnAddClick(Sender: TObject);
begin
  oBankAccount := oBankAccount.Add;
  Mode := bdmAdd;
  EnableEdits;
  ClearFields;
  Caption := 'Add Bank Account Record';
  ActiveControl := edtGLCode;
end;

procedure TfrmBankDetails.ClearFields;
var
  i : integer;
begin
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TEdit then
      with Components[i] as TEdit do
        Text := '';
  cbProduct.ItemIndex := 0;
end;


procedure TfrmBankDetails.btnDeleteClick(Sender: TObject);
begin
  oBankAccount.baStatement.Delete;
  LoadStatements;
end;

procedure TfrmBankDetails.ctkStatementsGetFieldValue(Sender: TObject;
  ID: IDispatch; FieldName: String; var FieldValue: String);
var
  StatementPos : TStatementPos;

  function StatString(Stat : TBankStatementStatus) : string;
  begin
    Case Stat of
      bssOpen       : Result := 'Open';
      bssInProgress : Result := 'In Progress';
      bssComplete   : Result := 'Complete';
    end;
  end;
begin
  with ID as IBankStatement do
  begin
    Case FieldName[1] of
      'D'  : begin
               FieldValue := POutDate(bsDate);
             end;
      'R'  : FieldValue := bsReference;
      'S'  : FieldValue := StatString(bsStatus);
      'B'  : FieldValue := ProcessValue(bsBalance, False);
      'F'  : FieldValue := IntToStr(bsFolio);
    end; //Case
  end;
end;

procedure TfrmBankDetails.SetBankAccount(AnAccount: IBankAccount);
var
  OldActive : Boolean;
begin
  OldActive := mlStatements.Active;
  oBankAccount := AnAccount;
  mlStatements.Active := False;
  ctkStatements.ToolkitObject := oBankAccount.baStatement as IDatabaseFunctions;
  mlStatements.Active := OldActive;
end;

function TfrmBankDetails.MapFileExists : Boolean;
var
  s : string;
begin
//  s := cbProduct.Items[cbProduct.ItemIndex];
  s := oToolkit.Banking.BankProducts.bpStatementFormat[Integer(cbProduct.Items.Objects[cbProduct.ItemIndex])];
  Result := FileExists(GetEnterpriseDirectory + MapDir + s + '.map');
end;

procedure TfrmBankDetails.btnPrintClick(Sender: TObject);
var
  HedRec : eBankHRecType;
  oStat : IBankStatement;
begin
  if mlStatements.Selected >= 0 then
  begin
    oStat := ctkStatements.GetRecord as IBankStatement;
    Try
      FillChar(HedRec, SizeOf(HedRec), 0);
      HedRec.ebAccNOM := oBankAccount.baGLCode;

      HedRec.ebStatRef := oStat.bsReference;
      HedRec.ebStatDate := oStat.bsDate;
      HedRec.ebIntRef := oStat.bsFolio;
      AddBankStatementRep2Thread(0, HedRec, edtGLDesc.Text, Self);
    Finally
      oStat := nil;
    End;
  end;
end;

procedure TfrmBankDetails.ctkStatementsSelectRecord(Sender: TObject;
  SelectType: TSelectType; Address: Integer; ID: IDispatch);
begin
  with ID as IBankStatement do
    btnReconcile.Enabled := bsStatus <> bssComplete;
end;

procedure TfrmBankDetails.btnReconcileClick(Sender: TObject);
var
  oStat : IBankStatement;
  Res : longint;
  bExisting : Boolean;
begin
  if (fMode = bdmStatementsOnly) and Assigned(frmTransList) then
  begin
    btnReconcile.Enabled := False;
    frmTransList.Reconcile(ctkStatements.GetRecord as IBankStatement);
  end
  else
  begin
    with oToolkit do
      Res := GeneralLedger.GetEqual(GeneralLedger.BuildCodeIndex(oBankAccount.baGLCode));
    oStat := ctkStatements.GetRecord as IBankStatement;
    LocalListSettings.StatDate := oStat.bsDate;
    LocalListSettings.Ref := oStat.bsReference;
    LocalListSettings.WantedCurrency := oToolkit.GeneralLedger.glCurrency;
    LocalListSettings.UnclearedOnly := True;
    LocalListSettings.InitialSequence := 0;
    LocalListSettings.StatBalance := oStat.bsBalance;
    LocalListSettings.AutoReconcile := True;

    ReconcileObj.bnkHeader.brGLCode := oToolkit.GeneralLedger.glCode;
    ReconcileObj.bnkHeader.brReconDate := Today;
    ReconcileObj.bnkHeader.brStatDate := oStat.bsDate;
    ReconcileObj.bnkHeader.brStatRef := LocalListSettings.Ref;
    bExisting :=  ReconcileObj.FindExisting;
    if ReconcileObj.Cancel then
      EXIT;
    if not bExisting then
    begin
      ReconcileObj.bnkHeader.brGLCode := oToolkit.GeneralLedger.glCode;
      ReconcileObj.bnkHeader.brReconDate := Today;
      ReconcileObj.bnkHeader.brStatDate := oStat.bsDate;
      ReconcileObj.bnkHeader.brReconRef := LocalListSettings.Ref;
      ReconcileObj.bnkHeader.brInitSeq := LocalListSettings.InitialSequence;
      ReconcileObj.bnkHeader.brCurrency := LocalListSettings.WantedCurrency;
      ReconcileObj.GetNextFolio;
      Res := ReconcileObj.AddHeader;
    end;

    CurrentStatement := oStat;

    Screen.Cursor := crHourglass;
    AddBankScan2Thread(Application.MainForm, LocalListSettings.WantedCurrency, StrToInt(edtGLCode.Text), Handle,
                       LocalListSettings);

  end;
end;

procedure TfrmBankDetails.SetCurrentStatement(const StatDate : string; StatFolio : longint);
var
  KeyS : string;
begin
  if (StatFolio <> 0) then
  begin
    KeyS := (ctkStatements.GetRecord as IBankStatement).BuildDateAndFolioIndex(StatDate, StatFolio);

    mlStatements.SearchColumn(4, True, KeyS);
  end;
end;

procedure TfrmBankDetails.mlStatementsAfterLoad(Sender: TObject);
begin
  if pgDetails.ActivePageIndex = 1 then
  begin
    btnDelete.Enabled := mlStatements.ItemsCount > 0;
    btnReconcile.Enabled := btnDelete.Enabled and
                             ChkAllowed_In(106) and ChkAllowed_In(196);
    btnPrint.Enabled := btnDelete.Enabled;
  end;
end;

procedure TfrmBankDetails.ctkStatementsFilterRecord(Sender: TObject;
  ID: IDispatch; var Include: Boolean);
begin
  with ID as IBankStatement do
    Include := (fMode <> bdmStatementsOnly) or (bsStatus <> bssComplete);
end;

procedure TfrmBankDetails.mlStatementsRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  if fMode = bdmStatementsOnly then
    Close;
end;

procedure TfrmBankDetails.ShowTransList;
begin
  oRecToolkit := oToolkit;
  if not Assigned(frmTransList) then
  begin
    frmTransList := TfrmTransList.Create(Application.MainForm);
    with frmTransList do
    begin
      oGL := oRecToolkit.GeneralLedger;
      ListSettings := LocalListSettings;
      DoList;
    end;
  end
  else
    frmTransList.BringToFront;
end;

procedure TfrmBankDetails.WMCustGetRec(var Message: TMessage);
begin
  ShowTransList;
end;

procedure TfrmBankDetails.mlStatementsColumnClick(Sender: TObject;
  ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  mlStatements.HelpContext := 1981 + ColIndex;
  if (FMode = bdmStatementsOnly) and (ColIndex = 0) then
    mlStatements.HelpContext := 2022;
end;

function TfrmBankDetails.ProductToList(Index: integer): integer;
var
  i : integer;
begin
  Result := -1;
  for i := 0 to cbProduct.Items.Count - 1 do
    if Integer(cbProduct.Items.Objects[i]) = Index then
    begin
      Result := i;
      Break;
    end;
end;

end.
