unit CustDet;

{ nfrewer440 17:10 08/12/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TKPickList, StdCtrls, PPayProc, Enterprise01_TLB, TEditVal, uExDatasets,
  uSettings, ExtCtrls, BTFile, APiUtil, StrUtil, Menus, BTConst, BTUtil, Key;

type
  TfrmCustDetails = class(TForm)
    btnCancel: TButton;
    btnOK: TButton;
    panCustomer: TPanel;
    Bevel3: TBevel;
    cbInclude: TCheckBox;
    edCustCode: TEdit;
    btnFindCust: TButton;
    lCustName: TLabel;
    lCustCode: TLabel;
    panDebt: TPanel;
    lDebtGLCode: TLabel;
    edDebtGLCode: TEdit;
    btnFindDebtGLCode: TButton;
    lDebtGLName: TLabel;
    Bevel2: TBevel;
    lDebtColl: TLabel;
    cmbDebtBasis: TComboBox;
    cbSyncGLs: TCheckBox;
    panOther: TPanel;
    edDefInterestRate: TCurrencyEdit;
    edMinValue: TCurrencyEdit;
    lIntGLCode: TLabel;
    edIntGLCode: TEdit;
    btnFindIntGLCode: TButton;
    lIntGLName: TLabel;
    lCC: TLabel;
    edCC: TEdit;
    btnFindCC: TButton;
    lCCName: TLabel;
    lDepartmentName: TLabel;
    btnFindDept: TButton;
    edDept: TEdit;
    lDept: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    lVariance: TLabel;
    cmbSign: TComboBox;
    edInterestVariance: TCurrencyEdit;
    Label5: TLabel;
    lPercent: TLabel;
    lEffective: TLabel;
    lEffectiveInterest: TLabel;
    Bevel4: TBevel;
    edCreditDays: TCurrencyEdit;
    Label1: TLabel;
    pmMain: TPopupMenu;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    procedure edCustCodeChange(Sender: TObject);
    procedure edCustCodeExit(Sender: TObject);
    procedure btnFindCustClick(Sender: TObject);
    procedure btnFindIntGLCodeClick(Sender: TObject);
    procedure edIntGLCodeChange(Sender: TObject);
    procedure edDebtGLCodeChange(Sender: TObject);
    procedure btnFindDebtGLCodeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edInterestVarianceChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cmbDebtBasisChange(Sender: TObject);
    procedure cbSyncGLsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edCCChange(Sender: TObject);
    procedure edDeptChange(Sender: TObject);
    procedure edCCExit(Sender: TObject);
    procedure edDeptExit(Sender: TObject);
    procedure btnFindCCClick(Sender: TObject);
    procedure btnFindDeptClick(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edIntGLCodeExit(Sender: TObject);
  private
    { Private declarations }
    bRestore : boolean;
    procedure EnableDisable;
    procedure PPCustRec2Form;
    procedure Form2PPCustRec;
    procedure LoadAllSettings;
    procedure SaveAllSettings;
  public
    LPPCustRec : TPPCustRec;
    bAdd, bDefault : boolean;
    rDefaultRate : real;
  end;

var
  frmCustDetails: TfrmCustDetails;

implementation

{$R *.dfm}

procedure TfrmCustDetails.edCustCodeChange(Sender: TObject);
begin
  with oToolkit.Customer do begin
    Index := acIdxCode;
    if GetEqual(BuildCodeIndex(edCustCode.text)) = 0
    then lCustName.Caption := acCompany
    else lCustName.Caption := '';
    EnableDisable;
  end;{with}
end;

procedure TfrmCustDetails.edCustCodeExit(Sender: TObject);
begin
  edCustCode.text := UpperCase(edCustCode.text);
  if trim(lCustName.Caption) = '' then btnFindCustClick(nil);
end;

procedure TfrmCustDetails.btnFindCustClick(Sender: TObject);
var
  oCustomer : IAccount;
  frmTKPickList : TfrmTKPickList;
begin
  frmTKPickList := TfrmTKPickList.CreateWith(self, oToolkit);
  with frmTKPickList do begin
    plType := plCustomer;
    sFind := edCustCode.Text;
    iSearchCol := 0;
    mlList.Columns[1].IndexNo := 1;
    if showmodal = mrOK then begin
      oCustomer := ctkDataSet.GetRecord as IAccount;
      edCustCode.Text := oCustomer.acCode;
    end;{if}
    release;
  end;{with}
end;

procedure TfrmCustDetails.btnFindIntGLCodeClick(Sender: TObject);
var
  oGLCode : IGeneralLedger;
  iGLCode : integer;
begin
  with TfrmTKPickList.CreateWith(self, oToolkit) do begin
    mlList.Columns[0].DataType := dtInteger;
    plType := plGLCode;
    iGLCode := StrToIntDef(edIntGLCode.Text,0);

    if (iGLCode = 0) and (edIntGLCode.Text <> '0') then
      begin
        sFind := edIntGLCode.Text;
        iSearchCol := 1;
      end
    else begin
      sFind := mlList.FullNomKey(iGLCode);
      iSearchCol := 0;
    end;{if}
    mlList.Columns[1].IndexNo := 1;

//    sFind := edIntGLCode.Text;
    if showmodal = mrOK then begin
      oGLCode := ctkDataSet.GetRecord as IGeneralLedger;
      edIntGLCode.Text := IntToStr(oGLCode.glCode);
      cbSyncGLsClick(nil);
    end;
    release;
  end;{with}
end;

procedure TfrmCustDetails.edIntGLCodeChange(Sender: TObject);
begin
//  if oToolkit <> nil then begin
    with oToolkit.GeneralLedger do begin
      Index := glIdxCode;
      if (GetEqual(BuildCodeIndex(StrToIntDef(edIntGLCode.text, 0))) = 0)
      and (glType in [glTypeProfitLoss, glTypeBalanceSheet]) then
      begin
        lIntGLName.Caption := glName;
        cbSyncGLsClick(nil);
      end else
      begin
        lIntGLName.Caption := '';
      end;
//      EnableDisable;
    end;{with}
//  end;{if}
end;

procedure TfrmCustDetails.edDebtGLCodeChange(Sender: TObject);
begin
//  if oToolkit <> nil then begin
    with oToolkit.GeneralLedger do begin
      Index := glIdxCode;
      if (GetEqual(BuildCodeIndex(StrToIntDef(edDebtGLCode.text, 0))) = 0)
      and (glType in [glTypeProfitLoss, glTypeBalanceSheet])
      then lDebtGLName.Caption := glName
      else lDebtGLName.Caption := '';
//      EnableDisable;
    end;{with}
//  end;{if}
end;

procedure TfrmCustDetails.btnFindDebtGLCodeClick(Sender: TObject);
var
  oGLCode : IGeneralLedger;
  iGLCode : integer;
begin
  with TfrmTKPickList.CreateWith(self, oToolkit) do begin
    mlList.Columns[0].DataType := dtInteger;
    plType := plGLCode;
    iGLCode := StrToIntDef(edDebtGLCode.Text,0);

    if (iGLCode = 0) and (edDebtGLCode.Text <> '0') then
      begin
        sFind := edDebtGLCode.Text;
        iSearchCol := 1;
      end
    else begin
      sFind := mlList.FullNomKey(iGLCode);
      iSearchCol := 0;
    end;{if}
    mlList.Columns[1].IndexNo := 1;

//    sFind := edDebtGLCode.Text;
    if showmodal = mrOK then begin
      oGLCode := ctkDataSet.GetRecord as IGeneralLedger;
      edDebtGLCode.Text := IntToStr(oGLCode.glCode);
    end;
    release;
  end;{with}
end;

procedure TfrmCustDetails.FormCreate(Sender: TObject);
begin
  LoadAllSettings;
  edMinValue.displayformat := '######0.' + StringOfChar('0', oToolkit.SystemSetup.ssSalesDecimals);
  edDefInterestRate.displayformat := '######0.00';
  edInterestVariance.displayformat := '######0.00';
  edCreditDays.displayformat := '######0';
end;

procedure TfrmCustDetails.edInterestVarianceChange(Sender: TObject);
begin
  lEffectiveInterest.Caption := Format('%9.2f', [
  StrToFloatDef(edDefInterestRate.Text,0)
  + (StrToFloatDef(edInterestVariance.Text,0) * ((cmbSign.ItemIndex * -2) + 1))]);
end;

procedure TfrmCustDetails.btnOKClick(Sender: TObject);

  function ValidateRecord : boolean;
  var
    iStatus, iError : integer;
    sError : string;
    KeyS : TStr255;
    PPCustRec : TPPCustRec;
  begin
    iError := 0;
    // Cust Code
    if (not bDefault) and (Trim(lCustName.caption) = '') then iError := 1
    else begin

      if bAdd then
      begin
        KeyS := PadString(psRight,Trim(edCustCode.Text), ' ', 6);
        iStatus := BTFindRecord(B_GetEq, ppFileVar[ppCustF], PPCustRec, ppBufferSize[ppCustF]
        , ppcCustIdx, KeyS);
        if iStatus = 0 then begin
          MsgBox('You have already stored a record for the following customer code :'#13#13
          + edCustCode.Text + #13#13 + 'Please pick a different Customer Code.'
          , mtError, [mbOK], mbOK, 'Validation Error');
          iError := -1;
        end;{if}
      end;{if}

      if iError = 0 then begin
        // default interest rate
        if (StrToFloatDef(edDefInterestRate.Text, 0) > 100)
        or (StrToFloatDef(edDefInterestRate.Text, 0) < 0)
        then iError := 2
        else begin
          if (StrToFloatDef(lEffectiveInterest.Caption,0) < 0)
          or (StrToFloatDef(lEffectiveInterest.Caption,0) > 100)
          then iError := 3
          else begin
            if (lIntGLName.Caption = '') then iError := 4
            else begin
              if oToolkit.SystemSetup.ssUseCCDept and (lCCName.Caption = '') then iError := 5
              else begin
                if oToolkit.SystemSetup.ssUseCCDept and (lDepartmentName.Caption = '') then iError := 6
                else begin
                  if (lDebtGLName.Caption = '') and (cmbDebtBasis.ItemIndex > 0)
                  then iError := 7
                end;{if}
              end;{if}
            end;{if}
          end;{if}
        end;{if}
      end;{if}
    end;{if}

    case iError of
      1 : begin
        sError := 'Customer Code';
        ActiveControl := edCustCode;
      end;

      2 : begin
        sError := 'Default Interest Rate';
        ActiveControl := edDefInterestRate;
      end;

      3 : begin
        sError := 'Interest Rate Variance';
        ActiveControl := edInterestVariance;
      end;

      4 : begin
        sError := 'Interest GL Code';
        ActiveControl := edIntGLCode;
      end;

      5 : begin
        sError := 'Cost Centre';
        ActiveControl := edCC;
      end;

      6 : begin
        sError := 'Department';
        ActiveControl := edDept;
      end;

      7 : begin
        sError := 'Debt Charge GL Code';
        ActiveControl := edDebtGLCode;
      end;
    end;{case}

    if iError > 0 then MsgBox('Please Enter a valid value into the following field :'#13#13
    + sError, mtError, [mbOK], mbOK, 'Validation Error')
    else Form2PPCustRec;

    Result := iError = 0;
  end;

begin
  if ValidateRecord then ModalResult := mrOK;
end;

procedure TfrmCustDetails.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmCustDetails.EnableDisable;
begin
  lCustCode.Enabled := (not bDefault);
  edCustCode.Enabled := (not bDefault) and bAdd;
  btnFindCust.Enabled := (not bDefault) and bAdd;
  lCustName.Enabled := (not bDefault);
  panCustomer.Visible := not bDefault;

  cbInclude.Enabled := not bDefault;

  edDefInterestRate.Enabled := bDefault;

  lVariance.Enabled := not bDefault;
  cmbSign.Enabled := lVariance.Enabled;
  edInterestVariance.Enabled := lVariance.Enabled;
  lPercent.Enabled := lVariance.Enabled;
  lEffective.Enabled := lVariance.Enabled;
  lEffectiveInterest.Enabled := lVariance.Enabled;

  lCC.Enabled := oToolkit.SystemSetup.ssUseCCDept;
  edCC.Enabled := lCC.Enabled;
  btnFindCC.Enabled := lCC.Enabled;
  lCCName.Enabled := lCC.Enabled;

  lDept.Enabled := lCC.Enabled;
  edDept.Enabled := lDept.Enabled;
  btnFindDept.Enabled := lDept.Enabled;
  lDepartmentName.Enabled := lDept.Enabled;

//  lDebtColl.Enabled := (not bDefault);
//  cmbDebtBasis.Enabled := (not bDefault);

  cbSyncGLs.Enabled := {lDebtColl.Enabled and} (cmbDebtBasis.ItemIndex > 0);

  lDebtGLCode.Enabled := cbSyncGLs.Enabled ;
  edDebtGLCode.Enabled := cbSyncGLs.Enabled and (not cbSyncGLs.checked);
  btnFindDebtGLCode.Enabled := cbSyncGLs.Enabled and (not cbSyncGLs.checked);
  lDebtGLName.Enabled := cbSyncGLs.Enabled;
//panDebt.Visible := not bDefault;
end;

procedure TfrmCustDetails.cmbDebtBasisChange(Sender: TObject);
begin
  EnableDisable;
end;

procedure TfrmCustDetails.cbSyncGLsClick(Sender: TObject);
begin
  EnableDisable;
  if cbSyncGLs.Checked then edDebtGLCode.Text := edIntGLCode.Text;
end;

procedure TfrmCustDetails.FormShow(Sender: TObject);
begin
  bRestore := FALSE;
  if bDefault then begin
    Caption := 'Default Details';
    panOther.Top := 8;
    panDebt.Top := 223;
    Height := 385;
    if bAdd then FillChar(LPPCustRec,SizeOf(LPPCustRec),#0);
  end;

  PPCustRec2Form;
  enableDisable;
end;

procedure TfrmCustDetails.PPCustRec2Form;
begin
  with LPPCustRec do begin
    edCustCode.Text := ppcCustCode;
    cbInclude.checked := ppcActive;
    edMinValue.Value := ppcMinInvoiceValue;
    edDefInterestRate.Value := rDefaultRate;
    cmbSign.ItemIndex := Ord(ppcInterestVariance < 0);
    edInterestVariance.Value := ABS(ppcInterestVariance);
    edIntGLCode.Text := IntToStr(LPPCustRec.ppcInterestGLCode);
    edCC.Text := LPPCustRec.ppcCostCentre;
    edDept.Text := LPPCustRec.ppcDepartment;
    cmbDebtBasis.ItemIndex := LPPCustRec.ppcDebitChargeBasis;
    cbSyncGLs.checked := LPPCustRec.ppcSyncGLCodes;
    edDebtGLCode.Text := IntToStr(LPPCustRec.ppcDebtChargeGLCode);
    edCreditDays.Value := LPPCustRec.ppcCreditDaysOffset;
  end;{with}
end;

procedure TfrmCustDetails.Form2PPCustRec;
begin
  FillChar(LPPCustRec,SizeOf(LPPCustRec),#0);
  with LPPCustRec do begin
    if bDefault then
    begin
      ppcCustCode := PPC_DEFAULT_RECORD;
      ppcDefaultRate := StrToFloatDef(edDefInterestRate.Text, 0);
//      ppcActive := FALSE;
    end else
    begin
      ppcCustCode := PadString(psRight, edCustCode.Text, ' ', SizeOf(ppcCustCode) -1);
      ppcActive := cbInclude.checked;
      ppcInterestVariance := StrToFloatDef(edInterestVariance.Text, 0) * ((cmbSign.ItemIndex * -2) + 1);
    end;

    ppcMinInvoiceValue := StrToFloatDef(edMinValue.Text, 0);
    ppcInterestGLCode := StrToIntDef(edIntGLCode.Text, 0);
    ppcCostCentre := edCC.Text;
    ppcDepartment := edDept.Text;
    ppcCreditDaysOffset := StrToIntDef(edCreditDays.Text, 0);

    ppcDebitChargeBasis := cmbDebtBasis.ItemIndex;
    ppcSyncGLCodes := cbSyncGLs.checked;
    ppcDebtChargeGLCode := StrToIntDef(edDebtGLCode.Text, 0);

    ppcDummyChar := IDX_DUMMY_CHAR;

  end;{with}
end;

procedure TfrmCustDetails.edCCChange(Sender: TObject);
begin
  with oToolkit.CostCentre do begin
    Index := cdIdxCode;
    if GetEqual(BuildCodeIndex(edCC.text)) = 0
    then lCCName.Caption := cdName
    else lCCName.Caption := '';
    EnableDisable;
  end;{with}
end;

procedure TfrmCustDetails.edDeptChange(Sender: TObject);
begin
  with oToolkit.Department do begin
    Index := cdIdxCode;
    if GetEqual(BuildCodeIndex(edDept.text)) = 0
    then lDepartmentName.Caption := cdName
    else lDepartmentName.Caption := '';
    EnableDisable;
  end;{with}
end;

procedure TfrmCustDetails.edCCExit(Sender: TObject);
begin
  edCC.text := UpperCase(edCC.text);
end;

procedure TfrmCustDetails.edDeptExit(Sender: TObject);
begin
  edDept.text := UpperCase(edDept.text);
end;

procedure TfrmCustDetails.btnFindCCClick(Sender: TObject);
var
  oCC : ICCDept;
begin
  with TfrmTKPickList.CreateWith(self, oToolkit) do begin
    plType := plCC;
    sFind := edCC.Text;
    iSearchCol := 0;
    mlList.Columns[1].IndexNo := 1;
    if showmodal = mrOK then begin
      oCC := ctkDataSet.GetRecord as ICCDept;
      edCC.Text := oCC.cdCode;
    end;{if}
    release;
  end;{with}
end;

procedure TfrmCustDetails.btnFindDeptClick(Sender: TObject);
var
  oDept : ICCDept;
begin
  with TfrmTKPickList.CreateWith(self, oToolkit) do begin
    plType := plDept;
    sFind := edDept.Text;
    iSearchCol := 0;
    mlList.Columns[1].IndexNo := 1;
    if showmodal = mrOK then begin
      oDept := ctkDataSet.GetRecord as ICCDept;
      edDept.Text := oDept.cdCode;
    end;{if}
    release;
  end;{with}
end;

procedure TfrmCustDetails.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(nil, Self.Name, edCustCode) of
    mrOK : oSettings.ColorFieldsFrom(edCustCode, Self);
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmCustDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
end;

procedure TfrmCustDetails.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadParentToControl(Self.Name, Self.Name, edCustCode);
  oSettings.ColorFieldsFrom(edCustCode, Self);
end;

procedure TfrmCustDetails.SaveAllSettings;
begin
  oSettings.SaveParentFromControl(edCustCode, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;


procedure TfrmCustDetails.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TfrmCustDetails.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TfrmCustDetails.edIntGLCodeExit(Sender: TObject);
begin
  if trim(lIntGLName.Caption) = '' then btnFindIntGLCodeClick(nil);
end;

end.
