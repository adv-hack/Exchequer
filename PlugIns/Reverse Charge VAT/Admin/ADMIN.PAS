unit ADMIN;

{ nfrewer440 17:10 08/12/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, uExDatasets, uBtrieveDataset, ExtCtrls, uMultiList
  , Math, uDBMultiList, Menus, StrUtil, uSettings, Enterprise01_TLB, APIUtil
  , RVProc, ComCtrls, TEditVal, EnterToTab;

const
  sPlugInName = 'Reverse Charge VAT Administration';
  {$IFDEF EX600}
    sVersionNo = '007';
  {$ELSE}
    sVersionNo = 'v5.71.006';
  {$ENDIF}

type
  TfrmAdmin = class(TForm)
    btnClose: TButton;
    cmbCompany: TComboBox;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Exit1: TMenuItem;
    EnterToTab1: TEnterToTab;
    btnSave: TButton;
    Label26: TLabel;
    edValue: TCurrencyEdit;
    Label36: TLabel;
    Label34: TLabel;
    edCC: TEdit;
    edDept: TEdit;
    btnFindDept: TButton;
    btnFindCC: TButton;
    Bevel1: TBevel;
    lDeptName: TLabel;
    lCC: TLabel;
    Label2: TLabel;
    rbProdVATCode: TRadioButton;
    cmbProdVATCode: TComboBox;
    rbProdUDF: TRadioButton;
    Label3: TLabel;
    edProdUDF: TEdit;
    Label4: TLabel;
    cmbRCSLUDF: TComboBox;
    Label7: TLabel;
    edCustomer: TEdit;
    btnFindCustomer: TButton;
    lCustomerName: TLabel;
    Bevel2: TBevel;
    Bevel4: TBevel;
    Label9: TLabel;
    cmbVATReturn: TComboBox;
    Bevel5: TBevel;
    cmbProdUDF: TComboBox;
    panConsumerRetailer: TPanel;
    Label5: TLabel;
    rbCustAccType: TRadioButton;
    edAccType: TEdit;
    rbCustUDF: TRadioButton;
    edCustUDF: TEdit;
    Label6: TLabel;
    Bevel3: TBevel;
    cmbCustUDF: TComboBox;
    lGLCode: TLabel;
    edGLCode: TEdit;
    btnFindGLCode: TButton;
    lGLName: TLabel;
    Label8: TLabel;
    edSupplier: TEdit;
    btnFindSupplier: TButton;
    lSupplierName: TLabel;
    procedure FormCreate(Sender: TObject);
//    procedure Properties1Click(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cmbCompanyChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure edDeptChange(Sender: TObject);
    procedure btnFindDeptClick(Sender: TObject);
    procedure edCCChange(Sender: TObject);
    procedure btnFindCCClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnSaveClick(Sender: TObject);
    procedure SomethingsChanged(Sender: TObject);
    procedure edCustomerChange(Sender: TObject);
    procedure btnFindCustomerClick(Sender: TObject);
    procedure edGLCodeChange(Sender: TObject);
    procedure btnFindGLCodeClick(Sender: TObject);
    procedure edSupplierChange(Sender: TObject);
    procedure btnFindSupplierClick(Sender: TObject);
  private
    Parameters : TParameters;
    bCustOK, bCCOK, bGLOK, bDeptOK, bChanged, bRestore : boolean;
    procedure EnableDisable;
    Procedure WMGetMinMaxInfo (Var Message : TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
//    procedure LoadAllSettings;
//    procedure SaveAllSettings;
    procedure SetDecimalPlaces;
    procedure SetChanged(bSetTo : boolean);
    function SaveSetup : boolean;
    procedure Parameters2Form(LParameters : TParameters);
  public
    sCustCode : string;
  end;

var
  frmAdmin: TfrmAdmin;

implementation
uses
  Inifiles, CTKUtil, PIUtils, TKPickList, BrwseDir, FileUtil, PISecure, SecCodes, ComObj,
  ETStrU, ExchequerRelease;

{$R *.dfm}

procedure TfrmAdmin.FormCreate(Sender: TObject);

  procedure InitToolkit;
  var
    a, b, c : LongInt;
    iSelectIndex, iPos : integer;
    CompanyInfo : TCompanyInfo;
  begin{InitToolkit}
    // Create COM Toolkit object
    oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

    // Check it created OK
    If Assigned(oToolkit) Then Begin

      EncodeOpCode(97, a, b, c);
      oToolkit.Configuration.SetDebugMode(a, b, c);
      oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;

      iSelectIndex := 0;
      For iPos := 1 to oToolkit.Company.cmCount do begin
        CompanyInfo := TCompanyInfo.Create;
        CompanyInfo.CompanyRec.Path := Trim(oToolkit.Company.cmCompany[iPos].coPath);
        CompanyInfo.CompanyRec.Name := Trim(oToolkit.Company.cmCompany[iPos].coName);
        CompanyInfo.CompanyRec.Code := Trim(oToolkit.Company.cmCompany[iPos].coCode);
        cmbCompany.Items.AddObject(oToolkit.Company.cmCompany[iPos].coName, CompanyInfo);

        if oToolkit.Enterprise.enRunning
        and ((uppercase(CompanyInfo.CompanyRec.Path)) = (uppercase(Trim(oToolkit.Enterprise.enCompanyPath))))
        then iSelectIndex := iPos -1;
      end;{for}

      cmbCompany.ItemIndex := iSelectIndex;
      cmbCompanyChange(cmbCompany);

    End { If Assigned(oToolkit) }
    Else
      // Failed to create COM Object
      ShowMessage ('Cannot create COM Toolkit instance');
  end;{InitToolkit}

begin{FormCreate}

  Caption := sPlugInName;
//  sDataPath := IncludeTrailingBackslash(ParamStr(1));

//  LoadAllSettings;

  bRestore := FALSE;
  bDeptOK := FALSE;
  bCustOK := FALSE;
  bCCOK := FALSE;
  bGLOK := FALSE;
  bChanged := FALSE;

  oToolkit := nil;

  //Check Plug-In Security
  if PICheckSecurity(sSystemCode, sSecurityCode, sGlobalBespokeName, '', stSystemOnly
  , ptStandaloneEXE, ExtractFileName(Application.EXEName))
  then InitToolkit;

  SetChanged(FALSE);
  EnableDisable;
end;

procedure TfrmAdmin.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  With Message.MinMaxInfo^ Do Begin
    ptMinTrackSize.X:=350;
    ptMinTrackSize.Y:=250;
  End; { With Message }
end;
{
procedure TfrmAdmin.SaveAllSettings;
begin
  oSettings.SaveParentFromControl(cmbCompany, Self.Name);
//  oSettings.SaveList(mlDiscounts, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;

procedure TfrmAdmin.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(nil, Self.Name, cmbCompany) of
    mrOK : begin
      oSettings.ColorFieldsFrom(cmbCompany, Self);
    end;

    mrRestoreDefaults : begin
      oSettings.RestoreFormDefaults(Self.Name);
//      oSettings.RestoreListDefaults(mlDiscounts, Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
{end;

procedure TfrmAdmin.LoadAllSettings;
begin
  sMiscDirLocation := GetEnterpriseDirectory;
  oSettings.LoadForm(Self);
  oSettings.LoadParentToControl(Self.Name, Self.Name, cmbCompany);
  oSettings.ColorFieldsFrom(cmbCompany, Self);
//  oSettings.LoadList(mlDiscounts, Self.Name);
end;
}

procedure TfrmAdmin.EnableDisable;
begin
  cmbProdVATCode.Enabled := rbProdVATCode.Checked;
  cmbProdUDF.Enabled := rbProdUDF.Checked;
  edProdUDF.Enabled := rbProdUDF.Checked;

  edAccType.Enabled := rbCustAccType.Checked;
  cmbCustUDF.Enabled := rbCustUDF.Checked;
  edCustUDF.Enabled := rbCustUDF.Checked;

  btnSave.Enabled := bChanged;
  cmbCompany.Enabled := not bChanged;
end;

procedure TfrmAdmin.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAdmin.FormResize(Sender: TObject);
begin
//  cmbCompany.Width := ClientWidth - 160;
//  btnClose.Top := ClientHeight - 29;
//  btnClose.Left := ClientWidth - 88;
end;

procedure TfrmAdmin.cmbCompanyChange(Sender: TObject);
var
  FuncRes : integer;
begin
  Screen.Cursor := crHourglass;
  if (oToolkit.Status = tkOpen) Then begin
{    if MsgBox('Do you want to save any changes that you have made to the Setup ?'
    ,mtConfirmation, [mbYes, mbNo], mbYes, 'Save Changes') = mrYes then
    begin
      if not SaveSetup then exit;
    end;}

    // Close all
    oToolkit.CloseToolkit;
//    CloseFiles;
//    mlDiscounts.Active := FALSE;
  end;{if}

  With oToolkit Do Begin
    // Open Default Company
    CompanyRec := TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec;
    oToolkit.Configuration.DataDirectory := CompanyRec.Path;

    FuncRes := OpenToolkit;

    // Check it opened OK
    If (FuncRes = 0) then
    begin
//      edCommission.displayformat := '######0.' + StringOfChar('#', oToolkit.SystemSetup.ssSalesDecimals);
//      OpenFiles;

      SetDecimalPlaces;

      FillVATCombo(oToolkit, cmbVATReturn);
      FillVATCombo(oToolkit, cmbProdVATCode);

      Parameters := GetParameters(CompanyRec.Path);
      Parameters2Form(Parameters);


//      LoadSetupParams(SetupRec);
//      SetupRec2Form(SetupRec);
//      LoadPaths;

      // Set datapaths, reopen lists
//      bdsDiscounts.FileName := CompanyRec.Path + btFileName[btDiscountF];
//      mlDiscounts.Active := TRUE;

    end
    else begin
      // Error opening Toolkit - display error
      ShowMessage ('The following error occurred opening the Toolkit:-'#13#13
      + QuotedStr(oToolkit.LastErrorString));
    end;{if}

  End; { With OToolkit }
  SetChanged(FALSE);
  Screen.Cursor := crDefault;
end;


procedure TfrmAdmin.FormDestroy(Sender: TObject);
begin
  If Assigned(oToolkit) Then Begin
    // Close COM Toolkit and remove reference
    oToolkit.CloseToolkit;
    oToolkit := NIL;
  End; { If Assigned(oToolkit) }
end;

procedure TfrmAdmin.FormActivate(Sender: TObject);
begin
  if oToolkit = nil then close;
end;

procedure TfrmAdmin.About1Click(Sender: TObject);
begin
  MessageDlg(sPlugInName + #13#13 +
             ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + #13#13 +
             DoubleAmpers(GetCopyrightMessage) + #13 +
             'All rights reserved.', mtInformation, [mbOk], 0);
end;

procedure TfrmAdmin.Exit1Click(Sender: TObject);
begin
  Close;
end;


procedure TfrmAdmin.edDeptChange(Sender: TObject);
begin
  with oToolkit.Department do
  begin
    Index := cdIdxCode;
    if GetEqual(BuildCodeIndex(TEdit(Sender).text)) = 0 then
    begin
      lDeptName.Caption := cdName;
      bDeptOK := TRUE;
    end else
    begin
      lDeptName.Caption := '';
      bDeptOK := FALSE;
    end;{if}
  end;{with}
  SetChanged(TRUE);
end;

procedure TfrmAdmin.btnFindDeptClick(Sender: TObject);
var
  oDept : ICCDept;
begin
  with TfrmTKPickList.CreateWith(self, oToolkit) do
  begin
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

procedure TfrmAdmin.SetDecimalPlaces;
begin
  edValue.displayformat := '####0';
end;

procedure TfrmAdmin.edCCChange(Sender: TObject);
begin
  with oToolkit.CostCentre do
  begin
    Index := cdIdxCode;
    if GetEqual(BuildCodeIndex(TEdit(Sender).text)) = 0 then
    begin
      lCC.Caption := cdName;
      bCCOK := TRUE;
    end else
    begin
      lCC.Caption := '';
      bCCOK := FALSE;
    end;{if}
  end;{with}
  SetChanged(TRUE);
end;

procedure TfrmAdmin.btnFindCCClick(Sender: TObject);
var
  oCC : ICCDept;
begin
  with TfrmTKPickList.CreateWith(self, oToolkit) do
  begin
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

function TfrmAdmin.SaveSetup : boolean;

  function ValidateSetup : boolean;
  var
    iError : integer;
    sError : string;
  begin
    iError := 0;

    if rbProdUDF.Checked and (Trim(edProdUDF.Text) = '') then iError := 5;
    if rbCustAccType.Checked and (Trim(edAccType.Text) = '') then iError := 6;
    if rbCustUDF.Checked and (Trim(edCustUDF.Text) = '') then iError := 7;
//    if not bGLOK then iError := 8;
    if not bCustOK then iError := 4;
    if not bDeptOK then iError := 1;
    if not bCCOK then iError := 2;
    if StrToFloatDef(edValue.Text, 0) < 0 then iError := 3;

    case iError of
      1 : begin
        sError := 'You have entered an invalid Department code.';
        ActiveControl := edDept;
      end;

      2 : begin
        sError := 'You have entered an invalid Cost Centre code.';
        ActiveControl := edCC;
      end;

      3 : begin
        sError := 'You have entered an invalid De Minimus Value.';
        ActiveControl := edValue;
      end;

      4 : begin
        sError := 'You have entered an invalid Customer Code.';
        ActiveControl := edCustomer;
      end;

      5 : begin
        sError := 'You have entered an invalid Product UDF Value.';
        ActiveControl := edProdUDF;
      end;

      6 : begin
        sError := 'You have entered an invalid Account Type.';
        ActiveControl := edAccType;
      end;

      7 : begin
        sError := 'You have entered an invalid Customer UDF Value.';
        ActiveControl := edCustUDF;
      end;

{      8 : begin
        sError := 'You have entered an invalid GL Code.';
        ActiveControl := edGLCode;
      end;}
    end;

    if iError > 0 then
    begin
      MsgBox('Validation Error :' + #13#13 + sError, mtError, [mbOK], mbOK, 'Validation Error');
    end;

    Result := iError = 0;
  end;

  procedure SaveParameters;
  var
    sINIFilename : string;
    INIFile : TInifile;
  begin{SaveParameters}
    sINIFilename := Trim(CompanyRec.Path) + sINIFile;
    INIFile := TInifile.Create(sINIFilename);

    INIFile.WriteString('Settings', 'DeMinimus', edValue.Text);
    INIFile.WriteInteger('Settings', 'RCSLUDF', cmbRCSLUDF.ItemIndex + 1);
    INIFile.WriteString('Settings', 'VATReturnVATCode', TVATInfo(cmbVATReturn.Items.Objects[cmbVATReturn.ItemIndex]).cCode);
    INIFile.WriteString('Settings', 'CC', edCC.Text);
    INIFile.WriteString('Settings', 'Dept', edDept.Text);
    INIFile.WriteString('Settings', 'Customer', edCustomer.Text);
    INIFile.WriteString('Settings', 'Supplier', edSupplier.Text);
//    INIFile.WriteInteger('Settings', 'SRIGLCode', StrToIntDef(edGLCode.Text, 0));

    if rbProdVATCode.Checked then INIFile.WriteString('Settings', 'ProductMode', 'VAT')
    else INIFile.WriteString('Settings', 'ProductMode', 'UDF');
    INIFile.WriteString('Settings', 'ProdVATCode', TVATInfo(cmbProdVATCode.Items.Objects[cmbProdVATCode.ItemIndex]).cCode);
    INIFile.WriteInteger('Settings', 'ProdUDF', cmbProdUDF.ItemIndex + 1);
    INIFile.WriteString('Settings', 'ProdUDFValue', edProdUDF.Text);

    if rbCustAccType.Checked then INIFile.WriteString('Settings', 'CustomerMode', 'Type')
    else INIFile.WriteString('Settings', 'CustomerMode', 'UDF');
    INIFile.WriteString('Settings', 'CustAccType', edAccType.Text);
    INIFile.WriteInteger('Settings', 'CustUDF', cmbCustUDF.ItemIndex + 1);
    INIFile.WriteString('Settings', 'CustUDFValue', edCustUDF.Text);

    INIFile.Free;
  end;{SaveParameters}

begin
  Result := ValidateSetup;
  if Result then
  begin
    SaveParameters;
    SetChanged(FALSE);
  end;
end;

procedure TfrmAdmin.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if oToolkit <> nil then
  begin
//    if not bRestore then SaveAllSettings;

    if bChanged and (MsgBox('Do you want to save any changes that you have made to the Setup ?'
    ,mtConfirmation, [mbYes, mbNo], mbYes, 'Save Changes') = mrYes) then
    begin
      CanClose := SaveSetup;
    end else
    begin
      CanClose := TRUE;
    end;
  end;{if}
end;

procedure TfrmAdmin.btnSaveClick(Sender: TObject);
begin
  SaveSetup;
end;

procedure TfrmAdmin.SomethingsChanged(Sender: TObject);
begin
  SetChanged(TRUE);
end;

procedure TfrmAdmin.SetChanged(bSetTo: boolean);
begin
  bChanged := bSetTo;
  EnableDisable;
end;

procedure TfrmAdmin.edCustomerChange(Sender: TObject);
begin
  with oToolkit.Customer do begin
    Index := acIdxCode;
    if GetEqual(BuildCodeIndex(edCustomer.text)) = 0 then
    begin
      bCustOK := TRUE;
      lCustomerName.Caption := acCompany;
    end else
    begin
      bCustOK := FALSE;
      lCustomerName.Caption := '';
    end;{if}
  end;{with}
  SetChanged(TRUE);
end;

procedure TfrmAdmin.btnFindCustomerClick(Sender: TObject);
var
  oCustomer : IAccount;
begin
  with TfrmTKPickList.CreateWith(self, oToolkit) do
  begin
    plType := plCustomer;
    sFind := edCustomer.Text;
    iSearchCol := 0;
    mlList.Columns[1].IndexNo := 1;
    if showmodal = mrOK then
    begin
      oCustomer := ctkDataSet.GetRecord as IAccount;
      with oCustomer do
      begin
        edCustomer.Text := acCode;
      end;
    end;{if}
    release;
  end;{with}
end;

procedure TfrmAdmin.edGLCodeChange(Sender: TObject);
begin
  with oToolkit.GeneralLedger do begin
    Index := glIdxCode;
    if (GetEqual(BuildCodeIndex(StrToIntDef(edGLCode.text, 0))) = 0)
    and (glType in [glTypeProfitLoss, glTypeBalanceSheet]) then
    begin
      lGLName.Caption := glName;
      bGLOK := TRUE;
    end else
    begin
      lGLName.Caption := '';
      bGLOK := FALSE;
    end;
    EnableDisable;
  end;{with}
  SetChanged(TRUE);
end;

procedure TfrmAdmin.btnFindGLCodeClick(Sender: TObject);
var
  oGLCode : IGeneralLedger;
  iGLCode : integer;
begin
  with TfrmTKPickList.CreateWith(self, oToolkit) do
  begin
    mlList.Columns[0].DataType := dtInteger;
    plType := plGLCode;
    iGLCode := StrToIntDef(edGLCode.Text,0);

    if (iGLCode = 0) and (edGLCode.Text <> '0') then
    begin
      sFind := edGLCode.Text;
      iSearchCol := 1;
    end else
    begin
      sFind := mlList.FullNomKey(iGLCode);
      iSearchCol := 0;
    end;{if}
    mlList.Columns[1].IndexNo := 1;

//    sFind := edGLCode.Text;
    if showmodal = mrOK then
    begin
      oGLCode := ctkDataSet.GetRecord as IGeneralLedger;
      edGLCode.Text := IntToStr(oGLCode.glCode);
    end;
    release;
  end;{with}
end;

procedure TfrmAdmin.edSupplierChange(Sender: TObject);
begin
  with oToolkit.Supplier do begin
    Index := acIdxCode;
    if GetEqual(BuildCodeIndex(edSupplier.text)) = 0 then
    begin
      bCustOK := TRUE;
      lSupplierName.Caption := acCompany;
    end else
    begin
      bCustOK := FALSE;
      lSupplierName.Caption := '';
    end;{if}
  end;{with}
  SetChanged(TRUE);
end;

procedure TfrmAdmin.btnFindSupplierClick(Sender: TObject);
var
  oSupplier : IAccount;
begin
  with TfrmTKPickList.CreateWith(self, oToolkit) do
  begin
    plType := plSupplier;
    sFind := edSupplier.Text;
    iSearchCol := 0;
    mlList.Columns[1].IndexNo := 1;
    if showmodal = mrOK then
    begin
      oSupplier := ctkDataSet.GetRecord as IAccount;
      with oSupplier do
      begin
        edSupplier.Text := acCode;
      end;
    end;{if}
    release;
  end;{with}
end;

procedure TfrmAdmin.Parameters2Form(LParameters : TParameters);
begin{SaveParameters}
  edValue.Value := LParameters.iValue;
  cmbRCSLUDF.ItemIndex := LParameters.iRCSLUDF-1;
  SelectVATCode(cmbVATReturn, LParameters.sVATReturn);
  edCC.Text := LParameters.sCC;
  edDept.Text := LParameters.sDept;
  edCustomer.Text := LParameters.sCustomer;
  edSupplier.Text := LParameters.sSupplier;
//    edGLCode.Text := IntToStr(LParameters.iSRIGLCode);

  case LParameters.ProductMode of
    pmVAT : rbProdVATCode.Checked := TRUE;
    pmUDF : rbProdUDF.Checked := TRUE;
  end;{case}

  SelectVATCode(cmbProdVATCode, LParameters.sProdVATCode);
  cmbProdUDF.ItemIndex := LParameters.iProdUDF-1;
  edProdUDF.Text := LParameters.sProdUDFValue;

  case LParameters.CustomerMode of
    cmAccType : rbCustAccType.Checked := TRUE;
    cmUDF :  rbCustUDF.Checked := TRUE;
  end;{case}

  edAccType.Text := LParameters.sAccType;
  cmbCustUDF.ItemIndex := LParameters.iCustUDF-1;
  edCustUDF.Text := LParameters.sCustUDFValue;
end;{LoadParameters}


end.
