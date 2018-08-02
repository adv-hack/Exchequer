unit Admin;

{ nfrewer440 16:57 09/07/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, ComCtrls, ExtCtrls, Menus, uMultiList, SysSetup
  , uDBMultiList, CommDet, ImgList, uExDatasets, uBtrieveDataset
  , VarConst, GlobVar, FileUtil, BtrvU2, APIUtil, SComProc, StrUtil
  , MiscUtil, TKPickList, COMObj, Enterprise01_TLB, uComTKDataset, RepWiz
  , Reports, TEditVal, uSettings, Key, BTUtil;

const
  sPlugInName = 'Exchequer Sales Commission Plug-In';
  {$IFDEF EX600}
    sVersionNo = '020';
  {$ELSE}
    sVersionNo = 'v5.71.019';
  {$ENDIF}

type
  TCompanyInfo = Class
    CompanyRec : TCompanyRec;
  end;{with}

{  TContactRecType = Record
    coCompany    : String[6];     // Enterprise Company Code
    coAccount    : String[10];    // Enterprise Parent Account Code

    coCode       : String[20];    // Unique Contact Code
    coTitle      : String[10];    // Title - 'Mr', 'Mrs', 'Miss', 'Ms',etc…
    coFirstName  : String[30];    // Christian Name - 'Mark', 'Kevin', etc…
    coSurname    : String[30];
    coPosition   : String[30];    // Job Title
    coSalutation : String[20];    // Method Of Address - 'Jon', 'Mr Frewer'
    coContactNo  : String[30];    // Telephone Number
    coDate       : String[8];     // Added Date in YYYYMMDD format
    coFaxNumber  : String[30];    // Fax Number
    coEmailAddr  : String[100];   // Email Address
    coAddress1   : String[35];    // Delivery Address #1
    coAddress2   : String[35];    // Delivery Address #2
    coAddress3   : String[35];    // Delivery Address #3
    coAddress4   : String[35];    // Delivery Address #4
    coPostCode   : String[10];    // PostCode

    coSpare      : Array [1..512] Of Char;
  End; { ContactRecType }

  TSCTypeInfo = Class
    iFolioNo : integer;
  end;

  TFrmAdmin = class(TForm)
    pcSCDetails: TPageControl;
    tsDetails: TTabSheet;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnClose: TButton;
    tsCommission: TTabSheet;
    btnCopy: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Print1: TMenuItem;
    Exit1: TMenuItem;
    SalesCommissionReport1: TMenuItem;
    N1: TMenuItem;
    SystemSetup1: TMenuItem;
    btnCAdd: TButton;
    btnCEdit: TButton;
    btnCDelete: TButton;
    btnCCopy: TButton;
    mlCommission: TDBMultiList;
    mlSalesCodes: TDBMultiList;
    ilSmallScroll: TImageList;
    bdsSalesCodes: TBtrieveDataset;
    Utilities1: TMenuItem;
    ExportDatabase1: TMenuItem;
    SCTypeDat1: TMenuItem;
    byFolioNo1: TMenuItem;
    byDescription1: TMenuItem;
    bdsCommission: TBtrieveDataset;
    CommssnDat1: TMenuItem;
    SaleCode1: TMenuItem;
    pmCommission: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    Copy1: TMenuItem;
    pmSalesCode: TPopupMenu;
    Add2: TMenuItem;
    Edit2: TMenuItem;
    Delete2: TMenuItem;
    Copy2: TMenuItem;
    Print2: TMenuItem;
    SalesCodeRecord1: TMenuItem;
    cmbCompany: TComboBox;
    ScrollBox1: TScrollBox;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edCommission: TCurrencyEdit;
    cmbCommissionType: TComboBox;
    rbMargin: TRadioButton;
    rbValue: TRadioButton;
    cmbSCType: TComboBox;
    edDescription: TEdit;
    edSalesCode: TEdit;
    cbActive: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    lSupplierName: TLabel;
    lGLName: TLabel;
    lCCName: TLabel;
    lDepartmentName: TLabel;
    Bevel2: TBevel;
    lCurrency: TLabel;
    lDept: TLabel;
    lCC: TLabel;
    lGLCode: TLabel;
    Label10: TLabel;
    Label4: TLabel;
    edSupplierCode: TEdit;
    edGLCode: TEdit;
    edCC: TEdit;
    edDept: TEdit;
    cmbCurrency: TComboBox;
    btnFindDept: TButton;
    btnFindCC: TButton;
    btnFindGLCode: TButton;
    btnFindSupplier: TButton;
    N2: TMenuItem;
    Properties1: TMenuItem;
    N3: TMenuItem;
    Properties2: TMenuItem;
    SaveCoordinates1: TMenuItem;
    pmMain: TPopupMenu;
    properties3: TMenuItem;
    SaveCoordinates2: TMenuItem;
    SaveCoordinates3: TMenuItem;
    cmFolioIdx1: TMenuItem;
    cmSalesCodeIdx1: TMenuItem;
    cmReportIdx1: TMenuItem;
    cmProductIdx1: TMenuItem;
    cmProdGroupIdx1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    procedure btnCloseClick(Sender: TObject);
    procedure SystemSetup1Click(Sender: TObject);
    procedure btnCAddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bdsSalesCodesGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure btnAddClick(Sender: TObject);
    procedure ExportSCType(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure bdsSalesCodesSelectRecord(Sender: TObject;
      SelectType: TSelectType; Address: Integer; PData: Pointer);
//    procedure mlSalesCodesSortColumn(Sender: TObject; ColIndex: Integer; SortAsc: Boolean);
    procedure btnEditClick(Sender: TObject);
    procedure mlSalesCodesRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edSalesCodeExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edSupplierCodeChange(Sender: TObject);
    procedure edSupplierCodeExit(Sender: TObject);
    procedure btnFindGLCodeClick(Sender: TObject);
    procedure edGLCodeChange(Sender: TObject);
    procedure btnFindSupplierClick(Sender: TObject);
    procedure bdsContactsGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
//    procedure DBMultiList1SortColumn(Sender: TObject; ColIndex: Integer; SortAsc: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DBMultiList1Navigate(Sender: TObject; var Allow: Boolean;
      NewSelected: Integer);
    procedure DBMultiList1AfterNavigate(Sender: TObject);
    procedure bdsContactsSelectRecord(Sender: TObject;
      SelectType: TSelectType; Address: Integer; PData: Pointer);
    procedure ctkTransactionsGetFieldValue(Sender: TObject; ID: IDispatch;
      FieldName: String; var FieldValue: String);
    procedure mlTransactionsAfterNavigate(Sender: TObject);
    procedure ctkTransactionsSelectRecord(Sender: TObject;
      SelectType: TSelectType; Address: Integer; ID: IDispatch);
    procedure btnFindCCClick(Sender: TObject);
    procedure edCCChange(Sender: TObject);
    procedure edDeptChange(Sender: TObject);
    procedure btnFindDeptClick(Sender: TObject);
    procedure edCCExit(Sender: TObject);
    procedure edDeptExit(Sender: TObject);
    procedure mlSalesCodesScrollButtonKeyPress(Key: Char);
    procedure bdsCommissionGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure bdsCommissionFilterRecord(Sender: TObject; PData: Pointer;
      var Include: Boolean);
    procedure mlSalesCodesChangeSelection(Sender: TObject);
    procedure mlCommissionSortColumn(Sender: TObject; ColIndex: Integer;
      SortAsc: Boolean);
    procedure CommssnDat1Click(Sender: TObject);
    procedure mlCommissionAfterLoad(Sender: TObject);
    procedure btnCDeleteClick(Sender: TObject);
    procedure SalesCommissionReport1Click(Sender: TObject);
    procedure mlCommissionRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnCopyClick(Sender: TObject);
    procedure mlSalesCodesAfterLoad(Sender: TObject);
    procedure SaleCode1Click(Sender: TObject);
    procedure cmbCompanyChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pmSalesCodePopup(Sender: TObject);
    procedure SaveCoordinates1Click(Sender: TObject);
    procedure SaveCoordinates2Click(Sender: TObject);
    procedure pmMainPopup(Sender: TObject);
    procedure properties3Click(Sender: TObject);
    procedure SaveCoordinates3Click(Sender: TObject);
    procedure pmCommissionPopup(Sender: TObject);
    procedure Properties2Click(Sender: TObject);
    procedure SalesCodeRecord1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Print2Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    iCopy, iCurrentSCFolio : integer;
    FormMode : TFormMode;
    bSaveCoordinates, bRestore : boolean;
//    LSalesCodeRec : TSalesCodeRec;
//    procedure WMDoSomething(var Message : TMessage); message WM_DO_SOMETHING;
    procedure SalesCode2Screen(SalesCodeRec : TSalesCodeRec);
    procedure Screen2SalesCode(var SalesCodeRec : TSalesCodeRec);
    procedure EnableDisable;
    procedure FillSCTCombo;
    procedure SelectSCTWithFolio(iFolioNo : integer);
    Procedure WMGetMinMaxInfo (Var Message : TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
  public
    { Public declarations }
  end;

var
  FrmAdmin: TFrmAdmin;

implementation

uses
  SecCodes, PISecure, ETStrU, ExchequerRelease;

{$R *.dfm}

procedure TFrmAdmin.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmAdmin.SystemSetup1Click(Sender: TObject);
var
  pRecord : pointer;
begin
  with TfrmSystemSetup.Create(self) do begin
    ShowModal;
    Release;

    FillSCTCombo;
    pRecord := bdsSalesCodes.GetRecord;
    if pRecord <> nil then SalesCode2Screen(TSalesCodeRec(pRecord^));
    EnableDisable;
  end;{with}
end;

procedure TFrmAdmin.btnCAddClick(Sender: TObject);
var
  FrmCommissionDetails : TFrmCommissionDetails;
begin
  Screen.Cursor := crHourglass;
  FrmCommissionDetails := TFrmCommissionDetails.Create(Self);
  with FrmCommissionDetails do begin
    sSCFolioFNK := bdsCommission.SearchKey;
    case TWinControl(Sender).Tag of
      // Add
      1 : begin
        FillChar(CommissionDetails, SizeOf(CommissionDetails), #0);
        CommissionDetails.cmSalesCodeFolioNo := iCurrentSCFolio;
        CommissionDetails.cmCommission := StrToFloatDef(self.edCommission.Text, 0);
        CommissionDetails.cmCommissionType := self.cmbCommissionType.ItemIndex;
        CommissionDetails.cmCommissionBasis := Ord(self.rbMargin.Checked);
        FormMode := fmAdd;
      end;

      // Edit
      2 : begin
        CommissionDetails := TCommissionRec(bdsCommission.GetRecord^);
        FormMode := fmEdit;
        iRecPos := bdsCommission.GetRecordPosition;
      end;

      // Copy
      3 : begin
        CommissionDetails := TCommissionRec(bdsCommission.GetRecord^);
        FormMode := fmAdd;
      end;
    end;{case}

    cbCurrencyBased.Enabled := oToolkit.SystemSetup.ssCurrencyVersion <> enProfessional;

    Screen.Cursor := crDefault;
    if Showmodal = mrOK then begin
      mlCommission.RefreshDB;
      mlCommission.SearchColumn(10, TRUE, IntToStr(CommissionDetails.cmFolioNo));
      mlCommission.SortColIndex := 9;
    end;
    Release;
  end;{with}
end;

procedure TFrmAdmin.FillSCTCombo;
var
  KeyS : str255;
  iStatus : integer;
  SalesCodeTypeRec : TSalesCodeTypeRec;
  SCTypeInfo : TSCTypeInfo;

  procedure AddItem;
  begin{AddItem}
    SCTypeInfo := TSCTypeInfo.Create;
    SCTypeInfo.iFolioNo := SalesCodeTypeRec.sctFolioNo;
    cmbSCType.Items.AddObject(SalesCodeTypeRec.sctDescription, SCTypeInfo);
  end;{AddItem}

begin
  ClearList(cmbSCType.Items);
  FillChar(KeyS, SizeOf(KeyS), #0);
  iStatus := Find_Rec(B_GetFirst, F[SalesCodeTypeF], SalesCodeTypeF, SalesCodeTypeRec, sctDescriptionIdx, KeyS);
  While (iStatus = 0) do begin
    AddItem;
    iStatus := Find_Rec(B_GetNext, F[SalesCodeTypeF], SalesCodeTypeF, SalesCodeTypeRec, sctDescriptionIdx, KeyS);
  end;{while}
end;

procedure TFrmAdmin.FormShow(Sender: TObject);
begin
  if oToolkit <> nil then begin
    pcSCDetails.ActivePage := tsDetails;
    FormMode := fmView;
//    FillSCTCombo;
//    FillCurrencyCombo(cmbCurrency);
  end;{if}
//  EnableDisable;
//  mlCommission.Active := TRUE;

//  mlTransactions.Dataset := ctkTransactions;
//  ctkTransactions.ToolkitObject := oToolkit.Transaction as IBtrieveFunctions;
//  ctkTransactions.ToolkitObject := oToolkit.Supplier as IBtrieveFunctions;

end;

procedure TFrmAdmin.EnableDisable;
begin
  btnAdd.Enabled := (FormMode = fmView) and (cmbSCType.Items.Count > 0);
  btnEdit.Enabled := (mlSalesCodes.Itemscount > 0) and (FormMode = fmView);
  btnDelete.Enabled := btnEdit.Enabled;
//  btnFind.Enabled := btnEdit.Enabled;
  btnCopy.Enabled := btnEdit.Enabled;
//  btnPrint.Enabled := btnEdit.Enabled;
  Add2.Enabled :=  btnAdd.Enabled;
  Edit2.Enabled :=  btnEdit.Enabled;
  Delete2.Enabled :=  btnDelete.Enabled;
  Copy2.Enabled :=  btnCopy.Enabled;
//  Find1.Enabled :=  btnFind.Enabled;
  Print2.Enabled :=  btnEdit.Enabled;
  SalesCodeRecord1.enabled := Print2.Enabled;

  mlCommission.Enabled := (mlSalesCodes.Itemscount > 0) and (FormMode = fmView);
  btnCAdd.Enabled := mlCommission.Enabled;
  btnCEdit.Enabled := btnCAdd.Enabled and (mlCommission.Itemscount > 0);
  btnCDelete.Enabled := btnCEdit.Enabled;
//  btnCFind.Enabled := btnCEdit.Enabled;
  btnCCopy.Enabled := btnCEdit.Enabled;

  Add1.Enabled :=  btnCAdd.Enabled;
  Edit1.Enabled :=  btnCEdit.Enabled;
  Delete1.Enabled :=  btnCDelete.Enabled;
  Copy1.Enabled :=  btnCCopy.Enabled;

  btnOK.Enabled := FormMode in [fmAdd, fmEdit];
  btnCancel.Enabled := FormMode in [fmAdd, fmEdit];

  tsDetails.Enabled := FormMode in [fmAdd, fmEdit];
  btnClose.Enabled := FormMode = fmView;
  mlSalesCodes.Enabled := FormMode = fmView;
  cmbCompany.Enabled := FormMode = fmView;

  File1.Enabled := FormMode = fmView;
  Print1.Enabled := FormMode = fmView;
  Utilities1.Enabled := FormMode = fmView;

  lGLCode.Enabled := lSupplierName.Caption <> '';
  lCC.Enabled := (lSupplierName.Caption <> '') and oToolkit.SystemSetup.ssUseCCDept;
  lDept.Enabled := lCC.Enabled;
  lCurrency.Enabled := lGLCode.Enabled;

  edGLCode.Enabled := lGLCode.Enabled;
  edCC.Enabled := lCC.Enabled;
  edDept.Enabled := lDept.Enabled;
  cmbCurrency.Enabled := (lSupplierName.Caption <> '')
  and (oToolkit.SystemSetup.ssCurrencyVersion <> enProfessional);

  btnFindGLCode.Enabled := lGLCode.Enabled;
  btnFindCC.Enabled := lCC.Enabled;
  btnFindDept.Enabled := lDept.Enabled;
//  btnFindCurrency.Enabled := lSupplierName.Caption <> '';

  tsCommission.TabVisible := FormMode = fmView;
end;

procedure TFrmAdmin.bdsSalesCodesGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
  with TSalesCodeRec(PData^) do begin
    case FieldName[1] of
      'C' : FieldValue := scSalesCode;
      'D' : FieldValue := scDescription;
    end
  end;
end;

procedure TFrmAdmin.btnAddClick(Sender: TObject);
var
  SalesCodeRec  : TSalesCodeRec;
begin
  FillChar(SalesCodeRec,SizeOf(SalesCodeRec),#0);
  SalesCodeRec.scStatus := 1;
  FormMode := fmAdd;
  EnableDisable;
  SalesCode2Screen(SalesCodeRec);
  cmbSCType.ItemIndex := 0;
  pcSCDetails.ActivePage := tsDetails;
  ActiveControl := edSalesCode;
end;

procedure TFrmAdmin.SalesCode2Screen(SalesCodeRec : TSalesCodeRec);
begin
  with SalesCodeRec do begin
    edSalesCode.Text := scSalesCode;
    cbActive.Checked := scStatus = 1;
    edDescription.Text := scDescription;
    SelectSCTWithFolio(SalesCodeRec.scSalesCodeType);
    case scDefCommissionBasis of
      0 : rbValue.Checked := TRUE;
      1 : rbMargin.Checked := TRUE;
//      2 : rbQuantity.Checked := TRUE;
    end;{case}
    edSupplierCode.Text := scEntSupplierCode;
    edGLCode.Text := IntToStr(scEntGLCode);
    edCC.Text := scEntCostCentre;
    edDept.Text := scEntDepartment;
    if (oToolkit.SystemSetup.ssCurrencyVersion <> enProfessional)
    then cmbCurrency.ItemIndex := scEntInvCurrency - 1;
    edCommission.Text := FloatToStrF(scDefCommission, ffFixed, 15, oToolkit.SystemSetup.ssSalesDecimals);
    cmbCommissionType.ItemIndex := scDefCommissionType;
  end;{with}
  mlCommission.RefreshDB;
end;

procedure TFrmAdmin.Screen2SalesCode(var SalesCodeRec : TSalesCodeRec);
begin
  with SalesCodeRec do begin
    scSalesCode := PadString(psRight,Trim(edSalesCode.Text),' ',10);
    scStatus := ord(cbActive.Checked);
    scDescription := PadString(psRight,Trim(edDescription.Text),' ',60);
    SalesCodeRec.scSalesCodeType := TSCTypeInfo(cmbSCType.Items.Objects[cmbSCType.ItemIndex]).iFolioNo;
    if rbValue.Checked then scDefCommissionBasis := 0;
    if rbMargin.Checked then scDefCommissionBasis := 1;
    scEntSupplierCode := PadString(psRight, Trim(edSupplierCode.Text), ' ', SizeOf(scEntSupplierCode));
    scEntGLCode := StrToIntDef(edGLCode.Text,0);
    scEntCostCentre := (edCC.Text);
    scEntDepartment := edDept.Text;
    if (oToolkit.SystemSetup.ssCurrencyVersion <> enProfessional)
    then scEntInvCurrency := cmbCurrency.ItemIndex + 1;
    scDummyChar := IDX_DUMMY_CHAR;
    scDefCommission := StrToFloatDef(edCommission.Text, 0);
    scDefCommissionType := cmbCommissionType.ItemIndex;
  end;{with}
end;

procedure TFrmAdmin.ExportSCType(Sender: TObject);
var
  KeyS : str255;
  SalesCodeTypeRec  : TSalesCodeTypeRec;
  i, iStatus : integer;
  sKey : string;
const
  sFileName = 'SalesCom\SCType.TXT';
begin
  DeleteFile(sFileName);
  FillChar(KeyS, SizeOf(KeyS), #0);
  iStatus := Find_Rec(B_GetFirst, F[SalesCodeTypeF], SalesCodeTypeF, SalesCodeTypeRec, TWinControl(Sender).Tag, KeyS);
  while iStatus = 0 do begin
    sKey := '';
    For i := 1 to Length(KeyS) do sKey := sKey + '#'+IntToStr(Ord(KeyS[i]));

    AddLineToFile(IntToStr(SalesCodeTypeRec.sctFolioNo) + ' '
    + SalesCodeTypeRec.sctDescription + ' '
    + SalesCodeTypeRec.sctDummyChar + ' '
    + sKey
    , sFileName);
    iStatus := Find_Rec(B_GetNext, F[SalesCodeTypeF], SalesCodeTypeF, SalesCodeTypeRec, TWinControl(Sender).Tag, KeyS);
  end;{while}
  ShowMessage('File Export Completed (' + sFileName + ')');
end;

procedure TFrmAdmin.btnCancelClick(Sender: TObject);
var
  LSalesCodeRec : TSalesCodeRec;
  pRecord : pointer;
begin
//  mlSalesCodes.OnClick(mlSalesCodes);
//  mlSalesCodes.OnRowClick
//  mlSalesCodes.RefreshKey := mlSalesCodes.RefreshKey;

//  mlSalesCodes.RefreshDB;
//  mlSalesCodes.SortColumn(0,TRUE);

  iCopy := 0;

  pRecord := bdsSalesCodes.GetRecord;
  if pRecord <> nil then begin
    LSalesCodeRec := TSalesCodeRec(pRecord^);
    if mlSalesCodes.Itemscount = 0
    then FillChar(LSalesCodeRec, SizeOf(LSalesCodeRec), #0);

    SalesCode2Screen(LSalesCodeRec);
  end;{if}
  FormMode := fmView;
  EnableDisable;
end;

procedure TFrmAdmin.btnOKClick(Sender: TObject);
var
  KeyS : Str255;
  LSalesCodeRec, SalesCodeRec : TSalesCodeRec;
  iNewFolio, iStatus : integer;
  CommissionRec : TCommissionRec;

  function ValidateRecord : boolean;
  var
    sError : string;
  begin{ValidateRecord}
    sError := '';

    if Trim(edSalesCode.Text) = '' then sError := 'Sales Code'
    else begin
      if Trim(edDescription.Text) = '' then sError := 'Description'
      else begin
        if StrToFloat(Trim(edCommission.Text)) <= 0 then sError := 'Commission'
        else begin
          if lSupplierName.caption = '' then
            begin
              edSupplierCode.Text := '';
              edGLCode.Text := '';
              edCC.Text := '';
              edDept.Text := '';
              cmbCurrency.itemindex := -1;
            end
          else begin
            // since the supplier code is set, validate the other enterprise fields
            if lGLName.Caption = '' then sError := 'GL Code'
            else begin
              if (lCCName.Caption = '') and oToolkit.SystemSetup.ssUseCCDept
              then sError := 'Cost Centre'
              else begin
                if (lDepartmentName.Caption = '') and oToolkit.SystemSetup.ssUseCCDept
                then sError := 'Department'
                else begin
                  if (oToolkit.SystemSetup.ssCurrencyVersion <> enProfessional)
                  and (cmbCurrency.ItemIndex = -1)
                  then sError := 'Currency'
                  else begin
                    // check GLCode Currency Matches Currency Picked
                    if (oToolkit.SystemSetup.ssCurrencyVersion <> enProfessional)
                    and (oToolkit.GeneralLedger.glCurrency <> 0)
                    and (oToolkit.GeneralLedger.glCurrency <> cmbCurrency.ItemIndex + 1)
                    then begin
                      MsgBox('The GL Code Currency and the Currency picked do not match.'
                      + #13#13 + 'Please correct one of these fields.', mtError,[mbOK],mbOK,'Validation Error');
                      sError := 'x';
                      ActiveControl := cmbCurrency;
                    end;{if}
                  end;
                end;{if}
              end;{if}
            end;{if}
          end;{if}
        end;{if}
      end;{if}
    end;{if}

    if sError <> '' then begin
      case sError[4] of
        'a' : ActiveControl := edDept;
        'c' : ActiveControl := edDescription;
        't' : ActiveControl := edCC;
        'e' : ActiveControl := edSalesCode;
        'r' : ActiveControl := cmbCurrency;
        'C' : ActiveControl := edGLCode;
        'm' : ActiveControl := edCommission;
      end;{case}

      if sError[4] in ['e','c','C','t','a','r','m']
      then MsgBox('You have entered an invalid value in the following field : '
      + #13#13 + sError, mtError,[mbOK],mbOK,'Validation Error');
    end;{if}

    Result := sError = '';
  end;{ValidateRecord}

begin
  if ValidateRecord then begin

    Case FormMode of
      fmAdd : begin
        FillChar(SalesCodeRec,SizeOf(SalesCodeRec),#0);
        Screen2SalesCode(SalesCodeRec);
        SalesCodeRec.scFolioNo := GetNextFolio(SalesCodeF);
        iStatus := Add_Rec(F[SalesCodeF], SalesCodeF, SalesCodeRec, 0);
        if iStatus = 5 then MsgBox('You already have a Sales Code with the given code'
        , mtInformation, [mbOK], mbOK, 'Add Duplicate Sales Code')
        else ShowBTError(iStatus, 'Add_Rec', FileNames[SalesCodeF]);

        if (iStatus = 0) and (iCopy > 0) then begin
          // Copy commission matrix from copied record

          // get new folio no for commission record
          iNewFolio := GetNextFolio(CommissionF);

          // get first commission record that matches
          FillChar(KeyS,SizeOf(KeyS),#0);
          KeyS := BTFullNomKey(iCopy);
          iStatus := Find_Rec(B_GetGEq, F[CommissionF], CommissionF, CommissionRec, cmSalesCodeIdx, KeyS);
          while (iStatus = 0) and (CommissionRec.cmSalesCodeFolioNo = iCopy) do begin

            // copy commission record
            CommissionRec.cmFolioNo := iNewFolio;
            CommissionRec.cmSalesCodeFolioNo := SalesCodeRec.scFolioNo;
            iStatus := Add_Rec(F[CommissionF], CommissionF, CommissionRec, cmSalesCodeIdx);
            ShowBTError(iStatus, 'Add_Rec', FileNames[CommissionF]);

            // Get Next Record
            iStatus := Find_Rec(B_GetNext, F[CommissionF], CommissionF, CommissionRec, cmSalesCodeIdx, KeyS);
            inc(iNewFolio);
          end;{while}

          iCopy := 0;
          iStatus := 0
        end;{if}
      end;

      fmEdit : begin

        LSalesCodeRec := TSalesCodeRec(bdsSalesCodes.GetRecord^);

        // get record with the new code
        KeyS := PadString(psRight,Trim(edSalesCode.Text),' ',10);
        iStatus := Find_Rec(B_GetEq, F[SalesCodeF], SalesCodeF, SalesCodeRec, scCodeIdx, KeyS);
        if (iStatus = 0) and (SalesCodeRec.scFolioNo <> LSalesCodeRec.scFolioNo) then
          begin
            MsgBox('You already have a Sales Code with the given code'
            , mtInformation, [mbOK], mbOK, 'Edit Duplicate Sales Code');
            iStatus := 5;
          end
        else begin
          // get original record
          KeyS := mlSalesCodes.FullNomKey(LSalesCodeRec.scFolioNo) + IDX_DUMMY_CHAR;
          iStatus := Find_Rec(B_GetEq, F[SalesCodeF], SalesCodeF, SalesCodeRec, scFolioIdx, KeyS);
          if iStatus = 0 then
            begin
              // store update to record
              Screen2SalesCode(SalesCodeRec);
              iStatus := Put_Rec(F[SalesCodeF], SalesCodeF, SalesCodeRec, sctFolioIdx);
              ShowBTError(iStatus, 'Put_Rec', FileNames[SalesCodeF]);
            end
          else ShowBTError(iStatus, 'Find_Rec', FileNames[SalesCodeF]);
        end;
      end;

    end;{case}

    if iStatus = 0 then begin
      FormMode := fmView;
      EnableDisable;
      mlSalesCodes.RefreshDB;
//      mlSalesCodes.SearchColumn(0, TRUE, Trim(SalesCodeRec.scSalesCode));
    end;{if}
  end;{if}
end;

procedure TFrmAdmin.bdsSalesCodesSelectRecord(Sender: TObject;
  SelectType: TSelectType; Address: Integer; PData: Pointer);
begin
//  LSalesCodeRec := TSalesCodeRec(PData^);
  
end;
{
procedure TFrmAdmin.mlSalesCodesSortColumn(Sender: TObject;
  ColIndex: Integer; SortAsc: Boolean);
begin
  bdsSalesCodes.SearchIndex := ColIndex + 1;
  bdsSalesCodes.SearchDataType := mlSalesCodes.Columns[ColIndex].DataType;
end;
}
procedure TFrmAdmin.btnEditClick(Sender: TObject);
begin
  SalesCode2Screen(TSalesCodeRec(bdsSalesCodes.GetRecord^));
  FormMode := fmEdit;
  EnableDisable;
  pcSCDetails.ActivePage := tsDetails;
  ActiveControl := edSalesCode;
end;

procedure TFrmAdmin.mlSalesCodesRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
//  PostMessage(Self.Handle,WM_DO_SOMETHING,0,1);
  btnEditClick(btnEdit);
end;
{
procedure TFrmAdmin.WMDoSomething(var Message: TMessage);
begin
  case Message.LParam of
    1 : btnEditClick(btnEdit);
  end;
end;
}
procedure TFrmAdmin.btnDeleteClick(Sender: TObject);
var
  KeyS : str255;
  iStatus : integer;
  LSalesCodeRec, SalesCodeRec : TSalesCodeRec;
  CommissionRec : TCommissionRec;
begin
  LSalesCodeRec := TSalesCodeRec(bdsSalesCodes.GetRecord^);
  if LSalesCodeRec.scStatus <> 0 then
    begin
      MsgBox('You cannot delete this Sales Code as it is currently active'
      , mtInformation,[mbOK],mbOK,'Delete Sales Code');
    end
  else begin
    if MsgBox('Are you sure you want to delete the following Sales Code : '#13#13#9
    + mlSalesCodes.Columns[0].Items[mlSalesCodes.Selected]
    , mtConfirmation,[mbYes,mbNo],mbNo,'Delete Sales Code') = mrYes then begin

      // Delete Commission records
      FillChar(KeyS,SizeOf(KeyS),#0);
      KeyS := BTFullNomKey(LSalesCodeRec.scFolioNo);
      iStatus := Find_Rec(B_GetGEq, F[CommissionF], CommissionF, CommissionRec, cmSalesCodeIdx, KeyS);
      while (iStatus = 0) and (CommissionRec.cmSalesCodeFolioNo = LSalesCodeRec.scFolioNo) do begin

        iStatus := Delete_Rec(F[CommissionF], CommissionF, cmSalesCodeIdx);
        ShowBTError(iStatus, 'Delete_Rec', FileNames[CommissionF]);

        // Get Next Record to delete
        iStatus := Find_Rec(B_GetGEq, F[CommissionF], CommissionF, CommissionRec, cmSalesCodeIdx, KeyS);
      end;{while}

      // Delete Sales Code
      KeyS := mlSalesCodes.FullNomKey(LSalesCodeRec.scFolioNo) + IDX_DUMMY_CHAR;
      iStatus := Find_Rec(B_GetEq, F[SalesCodeF], SalesCodeF, SalesCodeRec, sctFolioIdx, KeyS);
      if iStatus = 0 then begin
        iStatus := Delete_Rec(F[SalesCodeF],SalesCodeF,sctFolioIdx);
        if iStatus = 0 then begin
          mlSalesCodes.RefreshDB;

          if mlSalesCodes.Itemscount = 0 then begin
            FillChar(SalesCodeRec,SizeOf(SalesCodeRec),#0);
            SalesCode2Screen(SalesCodeRec);
          end;{if}

        end;{if}
        ShowBTError(iStatus, 'Delete_Rec', FileNames[SalesCodeF]);
      end;{if}
    end;{if}
  end;{if}
end;

procedure TFrmAdmin.FormDestroy(Sender: TObject);
begin
  ClearList(cmbSCType.Items);

  If Assigned(oToolkit) Then Begin
    // Close COM Toolkit and remove reference
    oToolkit.CloseToolkit;
    oToolkit := NIL;
  End; { If Assigned(oToolkit) }
end;

procedure TFrmAdmin.SelectSCTWithFolio(iFolioNo : integer);
var
  iPos : integer;
begin
  For iPos := 0 to cmbSCType.Items.Count - 1 do begin
    if TSCTypeInfo(cmbSCType.Items.Objects[iPos]).iFolioNo = iFolioNo then begin
      cmbSCType.ItemIndex := iPos;
      Exit;
    end;{if}
  end;{for}
end;

procedure TFrmAdmin.edSalesCodeExit(Sender: TObject);
begin
  edSalesCode.text := UpperCase(edSalesCode.text);
end;

procedure TFrmAdmin.FormCreate(Sender: TObject);

  procedure InitToolkit;
  var
    a, b, c : LongInt;
    iPos : integer;
    CompanyInfo : TCompanyInfo;
  begin{InitToolkit}
    // Create COM Toolkit object
    oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

    // Check it created OK
    If Assigned(oToolkit) Then Begin

      EncodeOpCode(97, a, b, c);
      oToolkit.Configuration.SetDebugMode(a, b, c);

      oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;

      For iPos := 1 to oToolkit.Company.cmCount do begin
        CompanyInfo := TCompanyInfo.Create;
        CompanyInfo.CompanyRec.Path := Trim(oToolkit.Company.cmCompany[iPos].coPath);
        CompanyInfo.CompanyRec.Name := Trim(oToolkit.Company.cmCompany[iPos].coName);
        CompanyInfo.CompanyRec.Code := Trim(oToolkit.Company.cmCompany[iPos].coCode);
        cmbCompany.Items.AddObject(oToolkit.Company.cmCompany[iPos].coName, CompanyInfo);
      end;{for}

      cmbCompany.ItemIndex := 0;
      cmbCompanyChange(cmbCompany);

    End { If Assigned(oToolkit) }
    Else
      // Failed to create COM Object
      ShowMessage ('Cannot create COM Toolkit instance');
  end;{InitToolkit}

begin{FormCreate}

  LoadAllSettings;

  bSaveCoordinates := FALSE;
  bRestore := FALSE;
  iCopy := 0;
  oToolkit := nil;

  //Check Plug-In Security
  if PICheckSecurity('EXCHSALCOM000017', 'g$faa0,bv56fgdff', sPlugInName, '', stSystemOnly, ptStandaloneEXE, ExtractFileName(Application.EXEName))
  then InitToolkit;

//  ctkTransactions.ToolkitObject := oToolkit.Transaction as IBtrieveFunctions;
//  mlTransactions.Active := TRUE;
end;

procedure TFrmAdmin.edSupplierCodeChange(Sender: TObject);
begin
  with oToolkit.Supplier do begin
    Index := acIdxCode;
    if GetEqual(BuildCodeIndex(edSupplierCode.text)) = 0
    then lSupplierName.Caption := acCompany
    else lSupplierName.Caption := '';
    EnableDisable;
  end;{with}
end;

procedure TFrmAdmin.edSupplierCodeExit(Sender: TObject);
begin
  edSupplierCode.text := UpperCase(edSupplierCode.text);
end;

procedure TFrmAdmin.btnFindGLCodeClick(Sender: TObject);
var
  oGLCode : IGeneralLedger;
  iGLCode : integer;
begin
  with TfrmTKPickList.CreateWith(self, oToolkit) do begin
    mlList.Columns[0].DataType := dtInteger;
    plType := plGLCode;
    iGLCode := StrToIntDef(edGLCode.Text,0);

    if (iGLCode = 0) and (edGLCode.Text <> '0') then
      begin
        sFind := edGLCode.Text;
        iSearchCol := 1;
      end
    else begin
      sFind := mlList.FullNomKey(iGLCode);
      iSearchCol := 0;
    end;{if}
    mlList.Columns[1].IndexNo := 1;

//    sFind := edGLCode.Text;
    if showmodal = mrOK then begin
      oGLCode := ctkDataSet.GetRecord as IGeneralLedger;
      edGLCode.Text := IntToStr(oGLCode.glCode);
    end;
    release;
  end;{with}
end;

procedure TFrmAdmin.edGLCodeChange(Sender: TObject);
begin
//  if oToolkit <> nil then begin
    with oToolkit.GeneralLedger do begin
      Index := glIdxCode;
      if (GetEqual(BuildCodeIndex(StrToIntDef(edGLCode.text, 0))) = 0)
      and (glType in [glTypeProfitLoss, glTypeBalanceSheet])
      then lGLName.Caption := glName
      else lGLName.Caption := '';
      EnableDisable;
    end;{with}
//  end;{if}
end;

procedure TFrmAdmin.btnFindSupplierClick(Sender: TObject);
var
  oSupplier : IAccount;
begin
  with TfrmTKPickList.CreateWith(self, oToolkit) do begin
    plType := plSupplier;
    sFind := edSupplierCode.Text;
    iSearchCol := 0;
    mlList.Columns[1].IndexNo := 1;
    if showmodal = mrOK then begin
      oSupplier := ctkDataSet.GetRecord as IAccount;
      edSupplierCode.Text := oSupplier.acCode;
    end;{if}
    release;
  end;{with}
end;

procedure TFrmAdmin.bdsContactsGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
{  with TContactRecType(PData^) do begin
    case FieldName[1] of
      'N' : FieldValue := Trim(coFirstName) + ' ' + Trim(coSurname);
      'C' : FieldValue := Trim(coAccount);
    end;
  end;}
end;
{
procedure TFrmAdmin.DBMultiList1SortColumn(Sender: TObject;
  ColIndex: Integer; SortAsc: Boolean);
begin
  BtrieveDataset1.SearchIndex := ColIndex;
  BtrieveDataset1.SearchDataType := DBMultiList1.Columns[ColIndex].DataType;
end;
}
procedure TFrmAdmin.Button1Click(Sender: TObject);
{var
 AFileVar : FileVar;
 ptr : Pointer;
 SKey : str255;}
begin
mlCommission.RefreshDB;
{  GetMem(ptr, 255);
  SKey := StringOfChar(#255,255);
  if Open_File(AFileVar, 'SCType.dat', 0) = 0 then begin
    showmessage(IntToStr(Find_Rec(11, AFileVar, 1, ptr^, 0, SKey)));
    Close_File(AFileVar);
  end;{if}
//  FreeMem(ptr);
end;

procedure TFrmAdmin.Button2Click(Sender: TObject);
begin
//  button2.Caption := IntToStr(DBMultiList1.SortColIndex);
//  ctkTransactions.ToolkitObject := oToolkit.Transaction as IBtrieveFunctions;
  showmessage(oToolkit.Transaction.BuildAccountIndex('aaa'));
end;

procedure TFrmAdmin.Button3Click(Sender: TObject);
begin
//  mlSalesCodes.Active := not mlSalesCodes.Active;
//  DBMultiList1.Active := not DBMultiList1.Active;
//  DBMultiList1.SortColIndex := 0;
//  if DBMultiList1.SortAsc then button3.caption := 'TRUE'
//  else button3.caption := 'FALSE';
end;

procedure TFrmAdmin.DBMultiList1Navigate(Sender: TObject;
  var Allow: Boolean; NewSelected: Integer);
begin
{  with TContactRecType(bdsContacts.GetRecord^) do begin
    lName.Caption := Trim(coFirstName) + ' ' + Trim(coSurname);
    lAccountCode.Caption := Trim(coAccount);
  end;}
//  lName.Caption := 'xx';
end;

procedure TFrmAdmin.DBMultiList1AfterNavigate(Sender: TObject);
begin
//  with TContactRecType(bdsContacts.GetRecord^) do begin
//    lName.Caption := Trim(coFirstName) + ' ' + Trim(coSurname);
//    lAccountCode.Caption := Trim(coAccount);
//  end;
end;

procedure TFrmAdmin.bdsContactsSelectRecord(Sender: TObject;
  SelectType: TSelectType; Address: Integer; PData: Pointer);
begin
{  with TContactRecType(PData^) do begin
//    lName.Caption := Trim(coFirstName) + ' ' + Trim(coSurname);
//    lAccountCode.Caption := Trim(coAccount);
  end;}
end;

procedure TFrmAdmin.ctkTransactionsGetFieldValue(Sender: TObject;
  ID: IDispatch; FieldName: String; var FieldValue: String);
begin
  with ID as ITransaction do begin
    case FieldName[1] of
      'O' : FieldValue := thOurRef;
      'A' : FieldValue := thAcCode;
    end;{case}
  end;{with}
end;

procedure TFrmAdmin.mlTransactionsAfterNavigate(Sender: TObject);
begin
{  with ctkTransactions.GetRecord as ITransaction do begin
    lOurRef.Caption := thOurRef;
    lAccountCode.Caption := thAcCode;
  end;}
end;

procedure TFrmAdmin.ctkTransactionsSelectRecord(Sender: TObject;
  SelectType: TSelectType; Address: Integer; ID: IDispatch);
begin
{  with ID as ITransaction do begin
    lOurRef.Caption := thOurRef;
    lAccountCode.Caption := thAcCode;
  end;}
end;

procedure TFrmAdmin.btnFindCCClick(Sender: TObject);
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

procedure TFrmAdmin.edCCChange(Sender: TObject);
begin
  with oToolkit.CostCentre do begin
    Index := cdIdxCode;
    if GetEqual(BuildCodeIndex(edCC.text)) = 0
    then lCCName.Caption := cdName
    else lCCName.Caption := '';
    EnableDisable;
  end;{with}
end;

procedure TFrmAdmin.edDeptChange(Sender: TObject);
begin
  with oToolkit.Department do begin
    Index := cdIdxCode;
    if GetEqual(BuildCodeIndex(edDept.text)) = 0
    then lDepartmentName.Caption := cdName
    else lDepartmentName.Caption := '';
    EnableDisable;
  end;{with}
end;

procedure TFrmAdmin.btnFindDeptClick(Sender: TObject);
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

procedure TFrmAdmin.edCCExit(Sender: TObject);
begin
  edCC.text := UpperCase(edCC.text);
end;

procedure TFrmAdmin.edDeptExit(Sender: TObject);
begin
  edDept.text := UpperCase(edDept.text);
end;

procedure TFrmAdmin.mlSalesCodesScrollButtonKeyPress(Key: Char);
begin
  Case Ord(Key) of
    27 : btnCancelClick(btnCancel); //ESC
  end;{case}
end;

procedure TFrmAdmin.bdsCommissionGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
  with TCommissionRec(PData^) do begin
    case FieldName[1] of
      'C' : FieldValue := cmCustCode;

      'P' : begin
        case TcommissionType(cmBy) of
          ctCustomer : FieldValue := '';
          ctCustomerProduct : FieldValue := cmProductCode;
          ctCustomerPGroup : FieldValue := cmPGroupCode;
          ctProduct : FieldValue := cmProductCode;
          ctPGroup : FieldValue := cmPGroupCode;
        end;{case}
      end;

      'F' : begin
        if cmByQty then FieldValue := FloatToStrF(cmQtyFrom, ffFixed, 15, oToolkit.SystemSetup.ssQtyDecimals)
        else FieldValue := '';
      end;

      'T' : begin
        if cmByQty then FieldValue := FloatToStrF(cmQtyTo, ffFixed, 15, oToolkit.SystemSetup.ssQtyDecimals)
        else FieldValue := '';
      end;

      'Y' : begin
        if cmByCurrency then FieldValue := IntToStr(cmCurrency)
        else FieldValue := '';
      end;

      'S' : begin
        if cmByDate then FieldValue := Str8ToScreenDate(cmStartDate)
        else FieldValue := '';
      end;

      'E' : begin
        if cmByDate then FieldValue := Str8ToScreenDate(cmEndDate)
        else FieldValue := '';
      end;

      'M' : begin
        case cmCommissionType of
          0 : FieldValue := FloatToStrF(cmCommission, ffFixed, 15
          , oToolkit.SystemSetup.ssSalesDecimals) + ' %';
          1 : FieldValue := FloatToStrF(cmCommission, ffFixed, 15
          , oToolkit.SystemSetup.ssSalesDecimals);
        end;{case}
      end;

      'B' : begin
        case cmCommissionBasis of
          0 : FieldValue := 'Value';
          1 : FieldValue := 'Margin';
        end;{case}
      end;

      'L' : begin
        FieldValue := IntToStr(cmFolioNo);
      end;
    end;{case}
  end;{with}
end;

procedure TFrmAdmin.bdsCommissionFilterRecord(Sender: TObject;
  PData: Pointer; var Include: Boolean);
begin
{  with TCommissionRec(PData^) do begin
    Include := cmSalesCodeFolioNo = iCurrentSCFolio;
  end;}
end;

procedure TFrmAdmin.mlSalesCodesChangeSelection(Sender: TObject);
var
  LSC : TSalesCodeRec;
begin
  if oToolkit <> nil then begin
    LSC := TSalesCodeRec(bdsSalesCodes.GetRecord^);
    iCurrentSCFolio := LSC.scFolioNo;
    bdsCommission.SearchKey := mlCommission.FullNomKey(iCurrentSCFolio);
    SalesCode2Screen(LSC);
    EnableDisable;
  end;{if}
end;

procedure TFrmAdmin.mlCommissionSortColumn(Sender: TObject;
  ColIndex: Integer; SortAsc: Boolean);
begin
// showmessage('ColIndex : ' + IntToStr(ColIndex) + #13 + 'SortAsc : ' + IntToStr(Ord(SortAsc)));
end;

procedure TFrmAdmin.CommssnDat1Click(Sender: TObject);
var
  KeyS : str255;
  CommissionRec  : TCommissionRec;
  i, iStatus : integer;
  sKey : string;
const
  sFileName = 'SalesCom\Commssn.TXT';
begin
  DeleteFile(sFileName);
  FillChar(KeyS, SizeOf(KeyS), #0);
  iStatus := Find_Rec(B_GetFirst, F[CommissionF], CommissionF, CommissionRec, TWinControl(Sender).Tag, KeyS);
  while iStatus = 0 do begin
    sKey := '';
    For i := 1 to Length(KeyS) do sKey := sKey + '#'+IntToStr(Ord(KeyS[i]));


    with CommissionRec do begin
      AddLineToFile(sKey + ' '
      + IntToStr(cmFolioNo) + ' '
      + IntToStr(cmSalesCodeFolioNo) + ' '
      + IntToStr(cmBy) + ' '
      + cmCustCode + ' '
      + cmProductCode + ' '
      + cmPGroupCode + ' '
      + IntToStr(Ord(cmByQty)) + ' '
      + MoneyToStr(cmQtyFrom) + ' '
      + MoneyToStr(cmQtyTo) + ' '
      + IntToStr(Ord(cmByCurrency)) + ' '
      + IntToStr(cmCurrency) + ' '
      + IntToStr(Ord(cmByDate)) + ' '
      + cmStartDate + ' '
      + cmEndDate + ' '
      + IntToStr(cmCommissionBasis) + ' '
      + FloatToStr(cmCommission) + ' '
      + IntToStr(cmCommissionType) + ' '
      + cmDummyChar
      , sFileName);
    end;{with}

    iStatus := Find_Rec(B_GetNext, F[CommissionF], CommissionF, CommissionRec, TWinControl(Sender).Tag, KeyS);
  end;{while}
  ShowMessage('File Export Completed (' + sFileName + ')');
end;

procedure TFrmAdmin.mlCommissionAfterLoad(Sender: TObject);
begin
  EnableDisable;
end;

procedure TFrmAdmin.btnCDeleteClick(Sender: TObject);
var
  iStatus : integer;
  LCommissionRec, CommissionRec : TCommissionRec;
begin
  LCommissionRec := TCommissionRec(bdsCommission.GetRecord^);
  if MsgBox('Are you sure you want to delete this commission line ?'
  , mtConfirmation,[mbYes,mbNo],mbNo,'Delete Commission Line') = mrYes then begin

    // Get Commission Record
    move(bdsCommission.GetRecordPosition, CommissionRec,sizeof(longint));
    iStatus := GetDirect(F[CommissionF], CommissionF, CommissionRec, cmSalesCodeIdx, B_SingLock + B_SingNWLock);
    if iStatus = 0 then
      begin
        iStatus := Delete_Rec(F[CommissionF], CommissionF, cmSalesCodeIdx);
        if iStatus = 0 then mlCommission.RefreshDB;
        ShowBTError(iStatus, 'Delete_Rec', FileNames[CommissionF]);
      end
    else ;//ShowBTError(iStatus, 'GetDirect', FileNames[CommissionF]);
  end;{if}
end;

procedure TFrmAdmin.SalesCommissionReport1Click(Sender: TObject);
begin
  Screen.Cursor := crHourglass;
  with TfrmRepWizard.create(self) do begin
    Screen.Cursor := crDefault;
    showmodal;
    Release;
  end;{with}
end;

procedure TFrmAdmin.mlCommissionRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnCAddClick(btnCEdit);
end;

procedure TFrmAdmin.btnCopyClick(Sender: TObject);
var
  SalesCodeRec  : TSalesCodeRec;
begin
  FormMode := fmAdd;
  EnableDisable;
  SalesCodeRec := TSalesCodeRec(bdsSalesCodes.GetRecord^);
  iCopy := SalesCodeRec.scFolioNo;
  SalesCodeRec.scSalesCode := '';
  SalesCode2Screen(SalesCodeRec);
  pcSCDetails.ActivePage := tsDetails;
  ActiveControl := edSalesCode;
end;

procedure TFrmAdmin.mlSalesCodesAfterLoad(Sender: TObject);
begin
  EnableDisable;
end;

procedure TFrmAdmin.SaleCode1Click(Sender: TObject);
var
  KeyS : str255;
  SalesCodeRec  : TSalesCodeRec;
  iStatus : integer;
const
  sFileName = 'SalesCom\SaleCode.TXT';
begin
  DeleteFile(sFileName);
  FillChar(KeyS, SizeOf(KeyS), #0);
  iStatus := Find_Rec(B_GetFirst, F[SalesCodeF], SalesCodeF, SalesCodeRec, TWinControl(Sender).Tag, KeyS);
  while iStatus = 0 do begin
    with SalesCodeRec do begin
      AddLineToFile(IntToStr(scFolioNo) + ' '
      + scSalesCode + ' '
      + scDescription + ' '
      + IntToStr(scSalesCodeType) + ' '
      + IntToStr(scDefCommissionBasis) + ' '
      + IntToStr(scStatus) + ' '
      + scEntSupplierCode + ' '
      + IntToStr(scEntGLCode) + ' '
      + scEntCostCentre + ' '
      + scEntDepartment + ' '
      + IntToStr(scEntInvCurrency) + ' '
      + FloatToStr(scDefCommission) + ' '
      + IntToStr(scDefCommissionType) + ' '
      + scDummyChar
      , sFileName);
    end;{with}
    iStatus := Find_Rec(B_GetNext, F[SalesCodeF], SalesCodeF, SalesCodeRec, TWinControl(Sender).Tag, KeyS);
  end;{while}
  ShowMessage('File Export Completed (' + sFileName + ')');
end;

procedure TFrmAdmin.cmbCompanyChange(Sender: TObject);
var
  FuncRes : integer;
  SalesCodeRec : TSalesCodeRec;
begin
  Screen.Cursor := crHourglass;
  if (oToolkit.Status = tkOpen) Then begin
    // Close all
    oToolkit.CloseToolkit;
    CloseFiles;
    mlSalesCodes.Active := FALSE;
    mlCommission.Active := FALSE;
  end;{if}

  With oToolkit Do Begin
    // Open Default Company
    CompanyRec := TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec;
    oToolkit.Configuration.DataDirectory := CompanyRec.Path;

    OpenFiles;
    FuncRes := OpenToolkit;

    // Check it opened OK
    If (FuncRes = 0) then
    begin
      edCommission.displayformat := '######0.' + StringOfChar('#', oToolkit.SystemSetup.ssSalesDecimals);
//      OpenFiles; // moved for SQL fix

      FillCurrencyCombo(cmbCurrency);

      // blank details tab;
      FillChar(SalesCodeRec,SizeOf(SalesCodeRec), #0);
      SalesCode2Screen(SalesCodeRec);

      FillSCTCombo;

      // Set datapaths, reopen lists
      bdsSalesCodes.FileName := FileNames[SalesCodeF];
      bdsCommission.FileName := FileNames[CommissionF];
      mlSalesCodes.Active := TRUE;
      mlCommission.Active := TRUE;

    end
    else begin
      // Error opening Toolkit - display error
      ShowMessage ('The following error occured opening the Toolkit:-'#13#13
      + QuotedStr(oToolkit.LastErrorString));
    end;{if}

  End; { With OToolkit }
  Screen.Cursor := crDefault;
end;

procedure TFrmAdmin.FormActivate(Sender: TObject);
begin
  if oToolkit = nil then close;
end;

procedure TFrmAdmin.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  With Message.MinMaxInfo^ Do Begin
    ptMinTrackSize.X:=457;
    ptMinTrackSize.Y:=263;
  End; { With Message }
end;

procedure TFrmAdmin.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(mlSalesCodes, Self.Name, nil) of
    mrRestoreDefaults : begin
      oSettings.RestoreListDefaults(mlSalesCodes, Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TFrmAdmin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
end;

procedure TFrmAdmin.SaveAllSettings;
begin
  oSettings.SaveParentFromControl(cmbCompany, Self.Name);
  oSettings.SaveList(mlSalesCodes, Self.Name);
  oSettings.SaveList(mlCommission, Self.Name);
  if bSaveCoordinates then oSettings.SaveForm(Self);
end;

procedure TFrmAdmin.pmSalesCodePopup(Sender: TObject);
begin
  SaveCoordinates1.checked := bSaveCoordinates;
end;

procedure TFrmAdmin.SaveCoordinates1Click(Sender: TObject);
begin
  bSaveCoordinates := not SaveCoordinates1.checked;
end;

procedure TFrmAdmin.LoadAllSettings;
begin
  sMiscDirLocation := GetEnterpriseDirectory;
  oSettings.LoadForm(Self);
  oSettings.LoadParentToControl(Self.Name, Self.Name, cmbCompany);
  oSettings.ColorFieldsFrom(cmbCompany, Self);
  oSettings.LoadList(mlSalesCodes, Self.Name);
  oSettings.LoadList(mlCommission, Self.Name);
end;

procedure TFrmAdmin.SaveCoordinates2Click(Sender: TObject);
begin
  bSaveCoordinates := not SaveCoordinates1.checked;
end;

procedure TFrmAdmin.pmMainPopup(Sender: TObject);
begin
  SaveCoordinates2.checked := bSaveCoordinates;
end;

procedure TFrmAdmin.properties3Click(Sender: TObject);
begin
  case oSettings.Edit(nil, Self.Name, cmbCompany) of
    mrOK : oSettings.ColorFieldsFrom(cmbCompany, Self);
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TFrmAdmin.SaveCoordinates3Click(Sender: TObject);
begin
  bSaveCoordinates := not SaveCoordinates3.checked;
end;

procedure TFrmAdmin.pmCommissionPopup(Sender: TObject);
begin
  SaveCoordinates3.checked := bSaveCoordinates;
end;

procedure TFrmAdmin.Properties2Click(Sender: TObject);
begin
  case oSettings.Edit(mlCommission, Self.Name, nil) of
    mrRestoreDefaults : begin
      oSettings.RestoreListDefaults(mlCommission, Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TFrmAdmin.SalesCodeRecord1Click(Sender: TObject);
begin
  ModReports.PrintSalesCodeDetails(TSalesCodeRec(bdsSalesCodes.GetRecord^));
end;

procedure TFrmAdmin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TFrmAdmin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TFrmAdmin.Print2Click(Sender: TObject);
begin
  SalesCodeRecord1Click(nil);
end;

procedure TFrmAdmin.About1Click(Sender: TObject);
begin
  MessageDlg(sPlugInName + ' Configuration' + #13#13 +
             ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + #13#13 +
             DoubleAmpers(GetCopyrightMessage) + #13 +
             'All rights reserved.', mtInformation, [mbOk], 0);
end;

procedure TFrmAdmin.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmAdmin.FormResize(Sender: TObject);
begin
  btnAdd.Top := ClientHeight - 27;
  btnEdit.Top := btnAdd.Top;
  btnDelete.Top := btnAdd.Top;
  btnCopy.Top := btnAdd.Top;
  btnClose.Top := btnAdd.Top;
  btnClose.Left := ClientWidth - 89;

  pcSCDetails.Width := ClientWidth - 256;
  pcSCDetails.Height := ClientHeight - 45;

  mlSalesCodes.Height := ClientHeight - 77;

end;

end.
