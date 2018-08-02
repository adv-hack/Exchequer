unit RecInp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ExtCtrls, Enterprise04_TLB, TEditVal, Mask, BtSupU1, TransLst,    
  EnterToTab, BorBtns;

type
  TfrmBankRecInput = class(TForm)
    Panel2: TPanel;
    btnCancel: TSBSButton;
    btnOK: TSBSButton;
    pnlGLCode: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtStatementDate: TEditDate;
    Label6: TLabel;
    ceBalance: TCurrencyEdit;
    edtGLCode: Text8Pt;
    cbCurrency: TSBSComboBox;
    edtRef: Text8Pt;
    cbSequence: TSBSComboBox;
    chkUncleared: TBorCheck;
    Panel1: TPanel;
    chkUseReconDate: TBorCheck;
    edtReconDate: TEditDate;
    Label7: TLabel;
    cbGroupBy: TSBSComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtGLCodeExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cbCurrencyExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure chkUseReconDateClick(Sender: TObject);
  private
    { Private declarations }
    LocalListSettings : TRecListSettings;
    FCurrentStatement : IBankStatement;
    FirstTime,
    ReconcileObjectCreated : Boolean;
    procedure ShowTransList;
    procedure FindExistingReconcile;
    procedure LoadCurrencies;
    procedure EnableControls(Enable : Boolean);
  public
    { Public declarations }
    procedure SetGLCurrency(Curr : Integer);
    procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;
  end;

var
  frmBankRecInput: TfrmBankRecInput;

  procedure ReconcileBankAccount(GLCode : longint = 0);

  function BankReconciliationInProgress : Boolean; //PR: New function. Called when period change required

implementation

uses
  GlobVar, BankList, TkPickList04, BtKeys1U, BankDetl, StrUtils, ReconObj, ApiUtil, BtSupU2, SBSComp2,
  EtDateU, InvListU, VarConst, CurrncyU, SQLUtils, TranFile;

{$R *.dfm}
  procedure ReconcileBankAccount(GLCode : longint = 0);
  begin
    //PR: 24/02/2010 Don't allow another reconciliation to be launched if one is already in progress - causes crash
    if Assigned(frmTransList) then
    begin
      frmTranslist.BringToFront;
      msgBox('There is already a Bank Reconciliation in progress.'#10#10'Please store or cancel it before starting a new reconciliation.',
                    mtInformation, [mbOK], mbOK, 'Bank Reconciliation');
      Exit;
    end;

    if not Assigned(frmBankRecInput) then
    begin
      Screen.Cursor := crHourglass;
      Try
        StartToolkit(oRecToolkit, SetDrive);
        frmBankRecInput := TfrmBankRecInput.Create(Application.MainForm);
        with frmBankRecInput do
        Try
          if GLCode > 0 then
          begin
            edtGLCode.Text := IntToStr(GLCode);
            edtGLCodeExit(edtGLCode);
            pnlGLCode.Enabled := False;
          end;
        Except
          Free;
        End;
      Finally
        Screen.Cursor := crDefault;
      End;
    end
    else
      frmBankRecInput.BringToFront;
end;

//PR: 17/11/2010 Function returns true if a Bank Rec is currently being processed, or if an incomplete one has been saved.
function BankReconciliationInProgress : Boolean;
begin
  //Are we currently running one?
  Result := Assigned(frmBankRecInput) or Assigned(frmTransList);

  if not Result then
  begin
    //Check if we have any incomplete reconcilations saved
    Try
      Result := ReconcileObj.FindAnyExisting;
    Finally
      FreeReconcileObj;
    End;
  end;
end;
{ TfrmBankRecInput }

procedure TfrmBankRecInput.ShowTransList;
begin
  if not Assigned(frmTransList) then
  begin
    frmTransList := TfrmTransList.Create(Application.MainForm);
    with frmTransList do
    begin
      oGL := oRecToolkit.GeneralLedger.Clone;
      ListSettings := LocalListSettings;
      DoList;
    end;
  end
  else
    frmTransList.BringToFront;
end;



procedure TfrmBankRecInput.SetGLCurrency(Curr : Integer);
begin
 {$IFDEF MC_ON}
    cbCurrency.ItemIndex := Curr;
    cbCurrency.DroppedDown := False;
 {$ENDIF}
end;

procedure TfrmBankRecInput.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  LastValueObj.UpdateAllLastValuesFull(Self);
  Action := caFree;
end;

procedure TfrmBankRecInput.btnOKClick(Sender: TObject);
var
  sCurr : string;
begin
{$IFDEF MC_ON}
  if cbCurrency.ItemIndex < 0 then
  begin
//    msgBox('Please select a currency for the reconciliation', mtWarning, [mbOK], mbOK, 'Bank Reconciliation');
    ActiveControl := cbCurrency;
    cbCurrency.DroppedDown := True;
  end
  else
{$ENDIF}
  begin
    btnOK.Enabled := False;
    btnCancel.Enabled := False;
    pnlGLCode.Enabled := False;
    Panel2.Enabled := False;
    Panel1.Enabled := False;


    LocalListSettings.UnclearedOnly := chkUncleared.Checked;
    {$IFDEF MC_ON}
    LocalListSettings.WantedCurrency := cbCurrency.ItemIndex;
    {$ELSE}
    LocalListSettings.WantedCurrency := 0;
    {$ENDIF}
    LocalListSettings.StatBalance := ceBalance.Value;
    LocalListSettings.StatDate := edtStatementDate.DateValue;
    LocalListSettings.Ref := edtRef.Text;
  {  if LocalListSettings.WantedCurrency = 0 then
      sCurr := 'Consolidated'
    else
      sCurr := Trim(oRecToolkit.SystemSetup.ssCurrency[LocalListSettings.WantedCurrency].scDesc);}
    LocalListSettings.InitialSequence := cbSequence.ItemIndex;
    LocalListSettings.CurrName :=
       Trim(oRecToolkit.SystemSetup.ssCurrency[LocalListSettings.WantedCurrency].scDesc);
    LocalListSettings.MultiSelect := {chkMultiSelect.Checked} False;
    LocalListSettings.UseReconDate := chkUseReconDate.Checked;
    if LocalListSettings.UseReconDate then
      LocalListSettings.ReconDate := edtReconDate.DateValue;

    LocalListSettings.lsGroupBy := TGroupBy(cbGroupBy.ItemIndex);
//    FindExistingReconcile;
    Screen.Cursor := crHourglass;

    if chkUseReconDate.Checked then
      ReconcileObj.bnkHeader.brReconDate := edtReconDate.DateValue
    else  //PR: 13/07/2009 Change to use Statement Date rather than today's date
      ReconcileObj.bnkHeader.brReconDate := edtStatementDate.DateValue;
    ReconcileObj.bnkHeader.brReconRef := LocalListSettings.Ref;
    ReconcileObj.bnkHeader.brInitSeq := LocalListSettings.InitialSequence;
    ReconcileObj.bnkHeader.brCurrency := LocalListSettings.WantedCurrency;
    ReconcileObj.UnclearedOnly := chkUncleared.Checked;
    ReconcileObj.GroupBy := LocalListSettings.lsGroupBy;
    {SS 26/04/2016 2016-R2
    ABSEXCH-13211:Bank Rec Wizard - Ability to change Statement Date on previously stored incomplete Bank Reconciliation
	  -Save the statement date in to the database.}
    ReconcileObj.bnkHeader.brStatDate := LocalListSettings.StatDate;


    ReconcileObj.UpdateHeader;

    if SQLUtils.UsingSQL then
      AddBankScanSQL2Thread(Application.MainForm, LocalListSettings.WantedCurrency, StrToInt(edtGLCode.Text), Handle,
                       LocalListSettings)
    else
      AddBankScan2Thread(Application.MainForm, LocalListSettings.WantedCurrency, StrToInt(edtGLCode.Text), Handle,
                       LocalListSettings);
  end;
end;

procedure TfrmBankRecInput.btnCancelClick(Sender: TObject);
begin
  //We've already created the ReconcileObject, so need to release it
  //PR: 06/07/2009 Also need to delete the Reconcile Header
  //PR: 20/07/2009 If cancel clicked before we've exited the GL code edit, no ReconcileObject has been created.
  if ReconcileObjectCreated then
  begin
    ReconcileObj.Delete;
    FreeReconcileObj;
  end;
  Close;
end;


procedure TfrmBankRecInput.edtGLCodeExit(Sender: TObject);
var
  FoundCode  :  ShortString;
  FoundNom   :  LongInt;
  Found : Boolean;
  Res : longint;
  c : Integer;
begin
  if ActiveControl <> btnCancel then
  begin
    Found := False;
    FoundNom := 0;
    FoundCode := edtGLCode.Text;
    Val(FoundCode, FoundNom, c);
    if c = 0 then
    begin
      with oRecToolkit do
      begin
        Res := GeneralLedger.GetEqual(GeneralLedger.BuildCodeIndex(FoundNom));
        if Res = 0 then
        begin
          //HV 04/05/2016 2016-R2 ABSEXCH-2872: Introduce Validation of GL Codes on BRW (GL code having type A or B with class other than bank account should not get displayed under the list )
          Found := (GeneralLedger as IGeneralLedger2).glType in [glTypeProfitLoss, glTypeBalanceSheet];
          if Syss.UseGLClass then
            Found := Found and ((GeneralLedger as IGeneralLedger2).glClass = glcBankAccount);
        end;
      end;
    end;

    if Found or GetNom(Self, FoundCode, FoundNom, 11) then
    begin
      edtGLCode.Text := IntToStr(FoundNom);
      with oRecToolkit do
      begin
        if GeneralLedger.glCode <> FoundNom then
          Res := GeneralLedger.GetEqual(GeneralLedger.BuildCodeIndex(FoundNom));
        SetGLCurrency(GeneralLedger.glCurrency);
//        FindExistingReconcile;
        //PR: 27/01/2011 ABSEXCH-10769 Changed to run FindExistingReconcile after the edtGLCode OnExit event is complete. This prevents
        //one of the checkboxes having focus, which can lead to 'unable to focus disabled or invisible window' error.
        PostMessage(Self.Handle, WM_CUSTGETREC, 21, 0);
      end

    end
    else
      Activecontrol := edtGLCode;
  end;
end;

procedure TfrmBankRecInput.FormCreate(Sender: TObject);
begin
  FirstTime := True;
  {$IFNDEF MC_ON}
  cbCurrency.Visible := False;
  Label2.Visible := False;
  {$ENDIF}
  edtStatementDate.DateValue := FormatDateTime('yyyymmdd', SysUtils.Date);
  ceBalance.Value := 0;
  LastValueObj.GetAllLastValuesFull(Self);
  ReconcileObjectCreated := False;
end;

procedure TfrmBankRecInput.FormDestroy(Sender: TObject);
begin
  frmBankRecInput := nil;
end;

procedure TfrmBankRecInput.WMCustGetRec(var Message: TMessage);
begin
  //PR: 27/01/2011 ABSEXCH-10769 Changed to run FindExistingReconcile after the edtGLCode OnExit event is complete.
  if Message.WParam = 21 then
  begin
    FindExistingReconcile;
    EXIT;
  end;
  //PR: 13/03/2009 Added handling for Reconciliation Date Changes - Message.LParam now contains the number of
  //transaction lines that were found
  if chkUseReconDate.Checked and (Message.LParam = 0) then
  begin
    msgBox('No transaction lines were found for Reconciliation Date ' + POutDate(edtReconDate.DateValue) + '.', mtInformation, [mbOK], mbOK, Caption);

    //PR: 20/07/2009 Don't forget to delete empty table
    DeleteTable(FullTmpFileName);
    DeleteFile(ChangeFileExt(FullTmpFileName, '.tmp'));
    DeleteFile(ChangeFileExt(FullTmpFileName, '.lck'));

    pnlGLCode.Enabled := True;
    Panel2.Enabled := True;
    Panel1.Enabled := True;
    btnCancel.Enabled := True;
    btnOK.Enabled := True;
    Screen.Cursor := crDefault;
  end
  else
  begin
    ShowTransList;
    btnCancel.Enabled := True;
    Application.ProcessMessages;
    Close;
  end;
end;

procedure TfrmBankRecInput.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := btnCancel.Enabled;
end;

procedure TfrmBankRecInput.FindExistingReconcile;
var
  Res : Integer;
  Found : Boolean;
  bFindExisting : Boolean;
begin
  ReconcileObj.bnkHeader.brGLCode := StrToInt(edtGLCode.Text);
  ReconcileObj.bnkHeader.brStatDate := LocalListSettings.StatDate;
  ReconcileObj.bnkHeader.brStatRef := LocalListSettings.Ref;
  bFindExisting := ReconcileObj.FindExisting;
  if ReconcileObj.Cancel then
  begin
    PostMessage(Self.Handle, WM_Close, 0, 0);
    EXIT;
  end;
  if not bFindExisting then
  begin
    LocalListSettings.ExistingReconcile := False;
    ReconcileObj.bnkHeader.brGLCode := StrToInt(edtGLCode.Text);
    ReconcileObj.bnkHeader.brReconDate := Today;
    ReconcileObj.bnkHeader.brReconRef := LocalListSettings.Ref;
    ReconcileObj.bnkHeader.brInitSeq := LocalListSettings.InitialSequence;
    ReconcileObj.bnkHeader.brCurrency := LocalListSettings.WantedCurrency;
    ReconcileObj.GetNextFolio;
    Res := ReconcileObj.AddHeader;
    ReconcileObjectCreated := True;
  end
  else
  begin
    Try
      //PR: 27/01/2011 ABSEXCH-10769 Set edtRec as ActiveControl to prevent one of the BorCheck controls being active and causing
      //an 'unable to focus...' error if the user clicks on the form before it closes.
      edtRef.SetFocus;
      Application.ProcessMessages;
      chkUncleared.Checked := ReconcileObj.UnclearedOnly;
    Except
    //PR: 26/01/2011 ABSEXCH-10237 Uncleared only maps to a field which, Pre-6.3.1, was unpopulated. Opening a pre-631 reconciliation will
    //cause an EConvertError at this point. Check for that and inform the user that they need to start again.
      on E:EConvertError do
      begin
        msgBox('The reconciliation you are attempting to access was started using a previous version of the Bank Reconciliation Wizard.' +
              #10'To continue you must start a new reconciliation.' +
              #10#10'Please note: All transaction statuses set in the previous reconciliation will be reset.',
              mtWarning, [mbOK], mbOK, 'Bank Reconciliation Wizard');

        //PR: 15/04/2010 Ensure we get rid of existing reconcile as we cannot know whether it was uncleared only or not.
        ReconcileObj.FindExisting(False);
        PostMessage(Self.Handle, WM_Close, 0, 0);
        EXIT;
      end;
    End;

    if ValidDate(ReconcileObj.bnkHeader.brStatDate) then
      edtStatementDate.DateValue := ReconcileObj.bnkHeader.brStatDate;
    
    ceBalance.Value := ReconcileObj.bnkHeader.brStatBal;
    edtRef.Text := ReconcileObj.bnkHeader.brReconRef;

    //PR: 17/10/2011 Added GroupBy
    cbGroupBy.ItemIndex := Ord(ReconcileObj.GroupBy);

    LocalListSettings.ExistingReconcile := True;

    if (oRecToolkit.SystemSetup.ssReleaseCodes as ISystemSetupReleaseCodes4).rcEBanking <> rcDisabled then
    with oRecToolkit.Banking.BankAccount do
    begin

      Res := GetEqual(BuildGLCodeIndex(ReconcileObj.bnkHeader.brGLCode));
      if Res = 0 then
      begin
        baStatement.Index := bsIdxDateAndFolio;
        Res :=
          baStatement.GetEqual(baStatement.BuildDateAndFolioIndex(ReconcileObj.bnkHeader.brStatDate,
                                                                  ReconcileObj.bnkHeader.brStatFolio));


          if Res = 0 then
            CurrentStatement := baStatement
          else
            CurrentStatement := nil;
      end;
    end;
    //PR: 22/01/2010 Changed to close Input form if we're using a stored reconciliation - thie
    //prevents the user making changes to the settings which could screw things up.
    ReconcileObjectCreated := True;
    PostMessage(Self.Handle, WM_Close, 0, 0);
    btnOkClick(Self);
  end;

end;

procedure TfrmBankRecInput.cbCurrencyExit(Sender: TObject);
begin
  if cbCurrency.ItemIndex < 0 then
    edtGLCodeExit(Sender);
end;

procedure TfrmBankRecInput.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TfrmBankRecInput.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TfrmBankRecInput.LoadCurrencies;
var
  i : integer;
  NoOfCurrencies : Byte;

  function ReplacePoundSign(s : string) : string;
  begin
    Result := AnsiReplaceStr(s, #156, '£');
  end;

begin
 {$IFDEF MC_ON}
{  cbCurrency.Items.Clear;
  with oRecToolkit do
  begin
    if Enterprise.enCurrencyVersion = enEuro then
      NoOfCurrencies := 3
    else
      NoOfCurrencies := 90;
    for i := 0 to NoOfCurrencies - 1 do
    begin
      cbCurrency.Items.Add(ReplacePoundSign(SystemSetup.ssCurrency[i].scSymbol));
      cbCurrency.ItemsL.Add(ReplacePoundSign(SystemSetup.ssCurrency[i].scSymbol) + ' - ' +
          SystemSetup.ssCurrency[i].scDesc);
    end;
  end;}
    Set_DefaultCurr(cbCurrency.Items,BOn,BOff);
    Set_DefaultCurr(cbCurrency.ItemsL,BOn,BOn);

 {$ENDIF}
end;

procedure TfrmBankRecInput.FormActivate(Sender: TObject);
begin
  {$IFDEF MC_ON}
  if FirstTime then
  begin
    FirstTime := False;
    LoadCurrencies;
  end;
  {$ENDIF}
end;

procedure TfrmBankRecInput.EnableControls(Enable: Boolean);
begin
  edtStatementDate.Enabled := Enable;
  edtRef.Enabled := True;
  cbSequence.Enabled := Enable;
  ceBalance.Enabled := Enable;
  chkUncleared.Enabled := Enable;
  edtReconDate.Enabled := not Enable;
  cbGroupBy.Enabled := Enable;
  if not Enable then
    chkUncleared.Checked := False;
end;

procedure TfrmBankRecInput.chkUseReconDateClick(Sender: TObject);
begin
  EnableControls(not chkUseReconDate.Checked);
end;

Initialization
  frmBankRecInput := nil;
end.
