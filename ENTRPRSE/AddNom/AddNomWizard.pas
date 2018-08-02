unit AddNomWizard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , AddNomPROC, Dialogs, ExtCtrls, StdCtrls, Grids, NomLine, EnterToTab
  , uExDatasets, TKPickList04, ComCtrls, NumEdit, Mask, TEditVal, Enterprise04_TLB
  , EXWrap1U, Menus, BorBtns, StrUtil;

const
  TOT_NET_AMOUNT = 1;
  TOT_VAT_AMOUNT = 2;
  TOT_GROSS_AMOUNT = 3;

  FIELD_EXIT = 0;
  FIELD_ENTER = 1;

type
  TNomType = (ttPayment, ttReceipt, ttTransfer, ttStandard);

  TfrmAddNomWizard = class(TForm)
    btnNext: TButton;
    btnBack: TButton;
    btnCancel: TButton;
    nbPages: TNotebook;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    sbLines: TScrollBox;
    HeaderControl1: THeaderControl;
    edBankAccount: TEdit;
    lBankAccount: TLabel;
    lDate: TLabel;
    edPY: TEditPeriod;
    Label7: TLabel;
    edReference: TEdit;
    lPY: TLabel;
    Label9: TLabel;
    lCCHeader: TLabel;
    edCC: TEdit;
    edDept: TEdit;
    lDeptHeader: TLabel;
    lCurrency: TLabel;
    lCurrencyRate: TLabel;
    edCurrencyRate: TNumEdit;
    lStartDate: TLabel;
    edStartPY: TEditPeriod;
    lIncPeriods: TLabel;
    edIncPeriods: TNumEdit;
    lEndDate: TLabel;
    lEndPY: TLabel;
    edEndPY: TEditPeriod;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lIncDays: TLabel;
    edIncDays: TNumEdit;
    lStartPY: TLabel;
    lBankTo: TLabel;
    edBankTo: TEdit;
    cmbCurrency: TComboBox;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    rbStandard: TBorRadio;
    rbTransfer: TBorRadio;
    rbReceipt: TBorRadio;
    rbPayment: TBorRadio;
    cbDateKeepDate: TBorCheckEx;
    cbPYKeepDate: TBorCheckEx;
    cbAutoCreate: TBorCheckEx;
    rbDate: TBorRadio;
    rbPY: TBorRadio;
    Panel1: TPanel;
    lBankAccountH: TLabel;
    edBankAccountH: TEdit;
    lBankToH: TLabel;
    edBankToH: TEdit;
    lDatePYH: TLabel;
    Label15: TLabel;
    edReferenceH: TEdit;
    lCurrencyH: TLabel;
    lCurrencyRateH: TLabel;
    edCurrencyRateH: TNumEdit;
    lBank1Desc: TLabel;
    lBank2Desc: TLabel;
    edPYH: TEditPeriod;
    edTransferValue: TNumEdit;
    edTransferDesc: TEdit;
    lTransferValue: TLabel;
    lTransferDesc: TLabel;
    lCurrencyTit: TLabel;
    cbRecurring: TBorCheckEx;
    Panel2: TPanel;
    Label5: TLabel;
    edTotNetAmount: TNumEdit;
    edTotVatAmount: TNumEdit;
    edTotGrossAmount: TNumEdit;
    panBitmap: TPanel;
    Image1: TImage;
    Shape1: TShape;
    Panel3: TPanel;
    Image2: TImage;
    Shape6: TShape;
    Panel4: TPanel;
    Image3: TImage;
    Shape7: TShape;
    Panel5: TPanel;
    edCCDesc: TEdit;
    edDeptDesc: TEdit;
    Panel6: TPanel;
    edBankAccountDesc: TEdit;
    edBankToDesc: TEdit;
    bvCurrency: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    bvTransfer: TBevel;
    lTransferDetails: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    lStandard: TLabel;
    Label13: TLabel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    Label1: TLabel;
    lStep1: TLabel;
    lStep2: TLabel;
    lStep4: TLabel;
    Bevel8: TBevel;
    lStep5: TLabel;
    Bevel9: TBevel;
    edDate: TEditDate;
    edDateH: TEditDate;
    edStartDate: TEditDate;
    edEndDate: TEditDate;
    edCurrencyH: TEdit;
    edPayInRef: TEdit;
    lPayInRef: TLabel;
    lPayInRefH: TLabel;
    edPayInRefH: TEdit;
    Label6: TLabel;
    edNomDesc: TEdit;
    grpUDF: TGroupBox;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    UDF5L: Label8;
    UDF7L: Label8;
    UDF9L: Label8;
    UDF6L: Label8;
    UDF8L: Label8;
    UDF10L: Label8;
    UDF11L: Label8;
    UDF12L: Label8;
    THUD1F: Text8Pt;
    THUD3F: Text8Pt;
    THUD4F: Text8Pt;
    THUD2F: Text8Pt;
    THUD5F: Text8Pt;
    THUD7F: Text8Pt;
    THUD9F: Text8Pt;
    THUD6F: Text8Pt;
    THUD8F: Text8Pt;
    THUD10F: Text8Pt;
    THUD11F: Text8Pt;
    THUD12F: Text8Pt;
    lStep3: Label8;
    Image4: TImage;
    Shape8: TShape;
    Shape9: TShape;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ChangeAutoMode(Sender: TObject);
    procedure TXTypeChange(Sender: TObject);
    procedure nbPagesPageChanged(Sender: TObject);
    procedure edBankAccountExit(Sender: TObject);
    procedure FieldExit(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure cmbCurrencyChange(Sender: TObject);
    function edPYShowPeriod(Sender: TObject; const EPr: Byte): String;
    function edPYConvDate(Sender: TObject; const IDate: String;
      const Date2Pr: Boolean): String;
    procedure edDateExit(Sender: TObject);
    procedure edTransferValueExit(Sender: TObject);
    procedure cbRecurringClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FieldEnter(Sender: TObject);
    procedure edCurrencyRateExit(Sender: TObject);
    procedure THUD1FExit(Sender: TObject);
    procedure THUD1FEntHookEvent(Sender: TObject);
  private
    bMultiCurrency, bOK : boolean;
    lstLines : TList;
    slVATCodes : TStringList;
    NomType : TNomType;
    aValidation : array [1..TH_NO_OF_FIELDS_TO_VALIDATE] of ValidationRec;
    aTotals : array [TOT_NET_AMOUNT..TOT_GROSS_AMOUNT] of Real;
    iNoOfSteps, iStep, iNOMFolio : integer;
    bIgnoreExits : boolean;
    iNoOfUdf: integer;  //SSK 27/07/2016 2016-R3 ABSEXCH-10038: added new variable to determine if the UDFs are to be input

    procedure AddNewLine;
    procedure EnableDisable;
    procedure FrameAddNewLine(Sender: TObject);
    procedure RecalcTotals(Sender: TObject);
    procedure ManufactureComTKTX(Sender: TObject);
    procedure DoTidyUp;
    Procedure TabToControl(bTabToNext : boolean);
    Procedure MoveUpDownGrid(bUp : boolean);
    procedure SendDefaultCC(Sender: TObject);
    procedure SendDefaultDept(Sender: TObject);
    procedure SendGLCurrency(Sender: TObject);
    function CreateNOM : boolean;
    function PopulateNOM(var oNOM : ITransaction15; bSkipBlankLines : boolean) : boolean;
    procedure ExitCCValidate(Sender: TObject);
    procedure ExitDeptValidate(Sender: TObject);
    procedure SetStepCaptions;
    Procedure WMMyEnterExit(Var msg:TMessage); message WM_MyEnterExit;
    Procedure WMMyChangeField(Var msg:TMessage); message WM_MyChangeField;
    procedure SetUDFields;  //SSK 27/07/2016 2016-R3 ABSEXCH-10038: function copied from NomTfr2U.pas to show/hide UDFs
    procedure ValidateUDFFields(Sender: TObject);  //SSK 27/07/2016 2016-R3 ABSEXCH-10038: function will validate UDFs as per UDF Plugins
    procedure SetFocusToVisibleUDF(const UDFEdits : Array of Text8Pt);  //SSK 03/08/2016 2016-R3 ABSEXCH-10038: function will set focus to next visible
  protected
    procedure ValidateNominalHeaderTotal(aNOM : ITransaction15); {SS:21/12/2016:ABSEXCH-12255}
    procedure AddCurrVarianceBalanceLine(aNOM : ITransaction15; aVariance : Real); {SS:21/12/2016:ABSEXCH-12255}
  public
    hNomDaybookHandle : HWnd;
    procedure SetNomType(NomType : TNomType; bRecurring : boolean);
  end;

var
  frmAddNomWizard: TfrmAddNomWizard;

  procedure ShowAddNomWizard(hParent : THandle; NomType : TNomType = ttPayment; bRecurring : boolean = FALSE);

implementation

{$R *.dfm}

uses
  CustIntU, EtMiscU, SysU1, VarConst, Event1U, ComnU2, GlobVar, APIUtil
  , KeyUtils, MiscUtil, PassWR2U, VarRec2U, MathUtil, BTSupU1, CustWinU
  , AddNomWizCustom, DateUtils, AuditNotes, BtKeys1U, Btrvu2,
  CustomFieldsIntf, //SSK 27/07/2016 2016-R3 ABSEXCH-10038: Required unit
  //PR: 01/12/2011 ABSEXCH-12224
  EnterpriseBeta_TLB;

procedure ShowAddNomWizard(hParent : THandle; NomType : TNomType = ttPayment; bRecurring : boolean = FALSE);
begin
  // Open COM Toolkit
  StartToolkit(SetDrive);
  //PR: 01/12/2011 ABSEXCH-12224 Set toolkit user id, so that the audit note added when the transaction is created in the toolkit looks
  //exactly like those created in Exchequer.
  with oToolkit.Configuration as IBetaConfig do
    UserID := EntryRec^.Login;
  // Show Add nom Wizard
  if frmAddNomWizard = nil then
  begin
    frmAddNomWizard := TfrmAddNomWizard.Create(Application.MainForm);
    if hParent = 0
    then frmAddNomWizard.SetNomType(NomType, bRecurring);
  end else
  begin
    frmAddNomWizard.BringToFront;
  end;{if}

  // used for sending messages to the Nominal Daybook
  if hParent <> 0
  then frmAddNomWizard.hNomDaybookHandle := hParent;
end;

procedure TfrmAddNomWizard.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  // Close/Free MDI Child
  Action := caFree;
end;

procedure TfrmAddNomWizard.btnBackClick(Sender: TObject);
begin
  // Goto Previous Page
  nbPages.PageIndex := nbPages.PageIndex -1;
  dec(iStep);

  // Changes the "Step x of y" captions
  SetStepCaptions;

  // Skip Auto Settings if not Recurring transaction

  //SSK 27/07/2016 2016-R3 ABSEXCH-10038: added to implement proper sequence
  if (nbPages.PageIndex = 3) and (not cbRecurring.checked) then
  begin
    nbPages.PageIndex := nbPages.PageIndex - 1;
  end;{if}

  //SSK 27/07/2016 2016-R3 ABSEXCH-10038: skip UDF page if no of UDF fields is 0
  if (nbPages.PageIndex = 2) and (iNoOfUdf=0) then
  begin
    nbPages.PageIndex := nbPages.PageIndex - 1;
  end;{if}

  // Grey In/Out Controls
  EnableDisable;
end;

procedure TfrmAddNomWizard.btnNextClick(Sender: TObject);

  Function ValidateFields : boolean;
  var
    iLine, iPos : integer;
    ErrorControl : TWinControl;
    sField : string;
  begin{ValidateFields}
    // Validate Currency Rate
    aValidation[edCurrencyRate.Tag].FieldOK := (not edCurrencyRate.Visible)
    or (not edCurrencyRate.Enabled) or (not ZeroFloat(edCurrencyRate.Value)
    and (not (edCurrencyRate.Value > MAX_VALUE)));

    Result := TRUE;
    case nbPages.PageIndex of
      1 : begin
        For iPos := 1 to TH_NO_OF_FIELDS_TO_VALIDATE do
        begin
          if (iPos = F_BANK_TO) and (NomType <> ttTransfer)
          or (iPos = F_TRANSFER_VALUE) and (NomType <> ttTransfer) then
          begin
            // Skip Validation
          end else
          begin
            if aValidation[iPos].FieldControl.Enabled // only validate enabled fields
            and aValidation[iPos].FieldControl.Visible then // only validate visible fields
            begin
              if aValidation[iPos].FieldOK then
              begin
                // Colour Field to default colour
//                TEdit(aValidation[iPos].FieldControl).Color := clWindow;
                ColorEditBox(TEdit(aValidation[iPos].FieldControl), clWhite);
                // CA 03/08/2012 ABSEXCH-12952 - Rebranding / UI Update
                TEdit(aValidation[iPos].FieldControl).Font.Color := clNavy;
              end else
              begin
                // Work out error text
                if (NomType = ttTransfer) and (iPos = F_BANK_TO) and
                (Trim(edBankAccount.Text) = Trim(edBankTo.Text))
                then sField := 'Bank To (Bank From and Bank To are the same GL Code)'
                else sField := aValidation[iPos].Description;

                // Show Error
                MsgBox('An invalid value has been enter in the following field : '
                + #13#13#9 + sField + #13#13
                + 'Please enter a valid value into this field'
                ,mtError,[mbOK],mbOK,'Validation Error');
//                TEdit(aValidation[iPos].FieldControl).Color := ERROR_COLOR; // Colour Field to error colour
                ColorEditBox(TEdit(aValidation[iPos].FieldControl), ERROR_COLOR);
                ActiveControl := aValidation[iPos].FieldControl; // Place cursor in error field
                Result := FALSE;
                Exit;
              end;{if}
            end;{if}
          end;{if}
        end;{for}
      end;

      3: begin
        // Validate Lines
        For iLine := 0 to lstLines.count-1 do
        begin
          ErrorControl := TfNomLine(lstLines[iLine]).Validate; // Validate Line
          if ErrorControl <> nil then
          begin
            // Show Error
            MsgBox('An invalid value has been enter in the following field : '
            + #13#13#9 + TfNomLine(lstLines[iLine]).aLineValidation[ErrorControl.Tag].Description + #13#13
            + 'Please enter a valid value into this field'
            ,mtError,[mbOK],mbOK,'Validation Error');
            TfNomLine(lstLines[iLine]).FocusControlWithTag(ErrorControl.Tag); // Focus control with error
            Result := FALSE;
            Exit;
          end;
        end;{for}
      end;
    end;{case}
  end;{ValidateFields}

var
  iPage, iPos : integer;

begin
  if btnNext.Caption = '&Finish' then
  begin
    // Finish button pressed
    if ValidateFields then // Validate Fields on Current Page
    begin
      // OK Lets Create the NOM
      if CreateNOM then
      begin
        // Remember Fields for next time
        aPreviousField[F_BANK_ACCOUNT] := Trim(edBankAccount.Text);
        aPreviousField[F_BANK_TO] := Trim(edBankTo.Text);
        aPreviousField[F_COSTCENTRE] := Trim(edCC.Text);
        aPreviousField[F_DEPARTMENT] := Trim(edDept.Text);
        aPreviousField[F_TRANSFER_VALUE] := Trim(edTransferValue.Text);
        aPreviousField[F_DESCRIPTION] := Trim(edReference.Text);
        aPreviousField[F_CURRENCY_RATE] := Trim(edCurrencyRate.Text);
        aPreviousField[F_PAY_IN_REF] := Trim(edPayInRef.Text);
        // Close form
        bOK := TRUE;
        Close;
      end;{if}
    end;{if}
  end else
  begin
    // Next Button Pressed
    if NomType = ttStandard then
    begin
      // Standard Journal selected
      if hNomDaybookHandle <> 0 then
      begin
        if cbRecurring.Checked
        then PostMessage(hNomDaybookHandle, WM_CustGetRec, 30000, 1)  // Should open the normal Add Nom dialog for an Auto
        else PostMessage(hNomDaybookHandle, WM_CustGetRec, 30000, 0);  // Should open the normal Add Nom dialog
        bOK := TRUE;
        Close;
      end;{if}
    end else
    begin
      if ValidateFields then // Validate Fields on Current Page
      begin
        // Goto Next Page
        nbPages.PageIndex := nbPages.PageIndex +1;
        inc(iStep);

        // Changes the "Step x of y" captions
        SetStepCaptions;

        //SSK 27/07/2016 2016-R3 ABSEXCH-10038: skip UDF page if number of UDF fields is 0
        if (nbPages.PageIndex = 2) and (iNoOfUdf=0)  then
        begin
          if (cbRecurring.checked) then
            nbPages.PageIndex := nbPages.PageIndex + 1
          else
            nbPages.PageIndex := nbPages.PageIndex + 2;
        end;

		// Skip Auto Settings if not Recurring transaction
        if (nbPages.PageIndex = 3) and {(TXType <> ttRecurring)} (not cbRecurring.checked) then
        begin
          nbPages.PageIndex := nbPages.PageIndex + 1;
        end;{if}

        // Grey In/Out Controls
        EnableDisable;
      end;{if}
    end;{if}
  end;{if}
end;

function TfrmAddNomWizard.CreateNOM : boolean;
var
  oNOM : ITransaction15;
  iStatus : integer;
  ExLocal: TdExLocal;
  NOMKey: Integer;
  KeyS: Str255;
  PwrdPosition: LongInt;
  InvPosition: LongInt;

  function CustomValidateLines : integer;
  var
    iLine : integer;
  begin{CustomValidateLines}
    Result := 0;
    For iLine := 1 to oNOM.thLines.thLineCount do
    begin
      if not ExecuteTXHook(oNOM, iLine, wiTransLine, hiLineValidation)
      then begin
        Result := iLine;
        break;
      end;{if}
    end;{for}
  end;{CustomValidateLines}

  // CJS 2014-05-06 - ABSEXCH-14076 - After Store Line Hook point on NOM lines
  function CustomAfterSaveLines : integer;
  var
    iLine : integer;
  begin{CustomAfterSaveLines}
    Result := 0;
    For iLine := 1 to oNOM.thLines.thLineCount do
      ExecuteTXHook(oNOM, iLine, wiTransLine, hiAfterSaveTXLine);
  end;{CustomAfterSaveLines}

  function GetLineDesc(iLine : integer) : string;
  begin{GetLineDesc}
    if iLine = oNOM.thLines.thLineCount
    then Result := 'the auto-balancing line'
    else Result := 'line ' + IntToStr(iStatus);
  end;{GetLineDesc}

begin
  Result := FALSE;

  // Populates a ComTK Transaction from the screen controls
  PopulateNom(oNOM, TRUE);

  // Validate Transaction Lines Hook
  iStatus := CustomValidateLines;
  if iStatus = 0 then
  begin
    // Validate Transaction Hook
    if ExecuteTXHook(oNOM, 1, wiTransaction, hiValidateTX) then
    begin
      // Save NOM
      {SS:21/12/2016:ABSEXCH-12255
      - Validate header total,If varinace found in header total then add a transaction line to adjust the variance.}
      ValidateNominalHeaderTotal(oNOM);

      //GS 19/09/2011 ABSEXCH-11741: deleted an orphan 'open com object browser' method call
      iStatus := oNOM.Save(TRUE);

     //PR: 01/12/2011 ABSEXCH-12224 The transaction is added in the toolkit, so removed Gareth's code below to avoid getting two audit notes.
      //GS 02/11/2011 add an audit note to the created transaction header
(*    if iStatus = 0 then
      begin
        try
          //create local record obj
          ExLocal.Create;
          //store the position of global files that we will be using
          GetPos(F[InvF], InvF, InvPosition);
          GetPos(F[PwrdF], PwrdF, PwrdPosition);

          //search for the TX record we have just created; store it in the local object
          KeyS := FullNomKey(oNOM.thFolioNum);
          iStatus := Find_Rec (B_GetEq, F[InvF], InvF, ExLocal.LRecPtr[InvF]^, InvFolioK, KeyS);

          //if found, add the audit note
          if iStatus = 0 then
          begin
            TAuditNote.WriteAuditNote(anTransaction, anCreate, ExLocal);
          end;

          //restore the positions of the files that we have interacted with
          SetDataRecOfs(InvF, InvPosition);
          SetDataRecOfs(PwrdF, PwrdPosition);
          GetDirect(F[InvF], InvF, RecPtr[InvF]^, InvCustK , 0);
          GetDirect(F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK , 0);
        finally
          //cleanup local record object
          ExLocal.Destroy;
        end;
      end;
*)
      if iStatus = 0 then
      begin
        // OK
        iNOMFolio := oNOM.thFolioNum;

        // CJS 2014-05-06 - ABSEXCH-14076 - After Store Line Hook point on NOM lines
        CustomAfterSaveLines;

        // After Store Transaction Hook
        ExecuteTXHook(oNOM, 1, wiTransaction, hiAfterSaveTX);

        // NOM Created OK
        Result := TRUE;
      end else
      begin
        // Error
        MsgBox('Error occurred when saving NOM : Error ' + IntToStr(iStatus) + #13#13
        + QuotedStr(Trim(oToolkit.LastErrorString)), mtError, [mbOK], mbOK, 'oNOM.Save');
      end;{if}
    end;{if}
  end else
  begin
    // Customisation Line Validation Error
    MsgBox('The validation of ' + GetLineDesc(iStatus)
    + ', via an external hook, has failed.'#13#13
    + 'You must ammend this line, in order to be able to save the transaction.'
    , mtWarning, [mbOK], mbOK, 'External Line Validation Failed');
  end;{if}

  // Clear Up
  oNOM := nil;
end;

function TfrmAddNomWizard.PopulateNOM(var oNOM : ITransaction15; bSkipBlankLines : boolean) : boolean;
// Populates a ComTK Transaction from the screen controls

  Procedure PopulateLineDefaults({var} oLine : ITransactionLine);
  begin{PopulateLineDefaults}
    oLine.ImportDefaults;

    // MH 13/05/2010 v6.4 ABSEXCH-3003: Removed setting of header currency and exchange rates as screwing up VAT Return
//    oLine.tlCurrency := oNOM.thCurrency;
//    oLine.tlDailyRate := oNOM.thDailyRate;
//    oLine.tlCompanyRate := oNOM.thCompanyRate;
    if bMultiCurrency then
    begin
      oLine.tlCurrency := TCurrencyInfo(cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]).CurrencyNo;

      // Copy in default exchange rates
      With oToolkit.SystemSetup.ssCurrency[oLine.tlCurrency] Do
      Begin
        oLine.tlCompanyRate := scCompanyRate;
        oLine.tlDailyRate := scDailyRate;
      End; // With oToolkit.SystemSetup.ssCurrency[oLine.tlCurrency]

      // Overwrite appropriate rate with that specified by the user
      case oToolkit.SystemSetup.ssCurrencyRateType of
        rtCompany : oLine.tlCompanyRate := edCurrencyRate.Value;
        rtDaily : oLine.tlDailyRate := edCurrencyRate.Value;
      end;{case}
    End // if bMultiCurrency
    else
      oLine.tlCurrency := 0;

    oLine.tlCostCentre := edCC.Text;
    oLine.tlDepartment := edDept.Text;
  end;{PopulateLineDefaults}

var
  oNOMLine : ITransactionLine;
  iMultiplier, iStatus, iLine : integer;
  rCalculatedVatAmount : real;
  rLineVATAmount : real;  // NF: 08/01/2008
  rVATRateLine : double; // NF: 21/01/2008
  sLastDesc : string; //PR: 22/04/2013 ABSEXCH-6794

begin
  Result := FALSE;

  // Set Header Defaults
  oNOM := oToolkit.Transaction.Add(dtNMT) as ITransaction15;
  oNOM.ImportDefaults;

//  oNOM.thOperator := Userprofile.Login;
  oNOM.thOperator := EntryRec.Login;
  oNOM.thOriginator := oNOM.thOperator; //HV 12/07/2016 2016-R3 ABSEXCH-15510: Transaction Originator is not stamped on NOMs created with the Standard Journal turned off
  oNOM.thLongYourRef := edReference.Text;
  oNom.thManualVAT := FALSE;
  oNOM.thTransDate := MaskDateToStr8(edDate.Text);
  oNOM.thPeriod := edPY.EPeriod;
  oNOM.thYear := edPY.EYear;
 
  // SSK 27/07/2016 2016-R3 ABSEXCH-10038: fill UDF values from Controls 
   oNOM.thUserField1 := THUd1F.Text;
   oNOM.thUserField2 := THUd2F.Text;
   oNOM.thUserField3 := THUd3F.Text;
   oNOM.thUserField4 := THUd4F.Text;
   oNOM.thUserField5 := THUd5F.Text;
   oNOM.thUserField6 := THUd6F.Text;
   oNOM.thUserField7 := THUd7F.Text;
   oNOM.thUserField8 := THUd8F.Text;
   oNOM.thUserField9 := THUd9F.Text;
   oNOM.thUserField10 := THUd10F.Text;
   oNOM.thUserField11 := THUd11F.Text;
   oNOM.thUserField12 := THUd12F.Text;

  oNOM.thTotalVAT := 0; // NF: 08/01/2008

  // MH 13/05/2010 v6.4 ABSEXCH-3003: Removed setting of header currency and exchange rates as screwing up VAT Return
  if bMultiCurrency then oNOM.thCurrency := 1 //TCurrencyInfo(cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]).CurrencyNo
  else oNOM.thCurrency := 0;

//  case oToolkit.SystemSetup.ssCurrencyRateType of
//    rtCompany : oNOM.thCompanyRate := edCurrencyRate.Value;
//    rtDaily : oNOM.thDailyRate := edCurrencyRate.Value;
//  end;{case}

  case NomType of
    ttPayment, ttReceipt : begin

      // Payment / Receipt Lines

      // Set VATIO, and credit/debit multiplier
      if NomType = ttPayment then
      begin
        iMultiplier := 1;
//        ((oNom as ITransaction4).thAsNom as ITransactionAsNOM2).tnVATIO := vioOutput;
        ((oNom as ITransaction4).thAsNom as ITransactionAsNOM2).tnVATIO := vioInput;
      end else
      begin
        iMultiplier := -1;
//        ((oNom as ITransaction4).thAsNom as ITransactionAsNOM2).tnVATIO := vioInput;
        ((oNom as ITransaction4).thAsNom as ITransactionAsNOM2).tnVATIO := vioOutput;
      end;{if}

      // NF: 08/01/2008 - Fixed in v6
      // Problem : NOMs with any manual VAT that are added by the add nom wizard seem fine. But when they are posted, the values are not posted to the correct GL Codes.
      // Solution : When Manual VAT is set, populate the thTotalVAT value and the thVATAnalysis array. This should fix this problem.
      // Note : We only pouplate these 2 VAT fields if it is not manual vat. This is because prior to this version they were always zero, and we don't want to rock the boat.

      // Work out if the NOM is going to be manual VAT (we need to know this, so that later, we know whether to add up the VAT totals or not).
      For iLine := 0 to lstLines.count-1 do
      begin
        if TfNomLine(lstLines[iLine]).BlankLine and bSkipBlankLines then
        begin
          // Skip Blank Lines
        end else
        begin
          rLineVATAmount := TfNomLine(lstLines[iLine]).edVATAmount.Value * iMultiplier;

          // VAT - Manual Auto or N/A ?
          rCalculatedVATAmount := Round_Up(TfNomLine(lstLines[iLine]).edNetAmount.Value
          * TVATInfo(TfNomLine(lstLines[iLine]).cmbVatCode.Items.Objects[TfNomLine(lstLines[iLine]).cmbVatCode.Itemindex]).rRate, 2);

          if not (ZeroFloat(ABS(rLineVATAmount) - ABS(rCalculatedVATAmount))) then
          begin
            oNom.thManualVAT := TRUE;
          end;{if}
        end;{if}
      end;{for}


      // Add Lines
      For iLine := 0 to lstLines.count-1 do
      begin

        if not (TfNomLine(lstLines[iLine]).BlankLine and bSkipBlankLines) then
        begin
          // Add Line
          oNOMLine := oNOM.thLines.Add;
          PopulateLineDefaults(oNOMLine);
          oNOMLine.tlGLCode := StrToIntDef(TfNomLine(lstLines[iLine]).edGLCode.Text, 0);
          oNOMLine.tlCostCentre := TfNomLine(lstLines[iLine]).edCC.Text;
          oNOMLine.tlDepartment := TfNomLine(lstLines[iLine]).edDept.Text;
          oNOMLine.tlDescr := TfNomLine(lstLines[iLine]).edDesc.Text;
          oNOMLine.tlNetValue := TfNomLine(lstLines[iLine]).edNetAmount.Value * iMultiplier;
          oNOMLine.tlStockCode := edPayInRef.Text;

          // Inclusive VAT ?

          if TfNomLine(lstLines[iLine]).bVATInclusive then
          begin
            oNOMLine.tlVATCode := 'M';
            oNOMLine.tlInclusiveVATCode := TfNomLine(lstLines[iLine]).InclusiveVATCode;
            //GS 04/08/2011 ABSEXCH-10825:
            //modified the "vat inc value" so it is multiplied by "iMultiplier"; adjusting its signage depending on whether
            //this TX is a payment or a recipt. corrects the "error 30109 when saving NOM" when using the inclusive VAT code
            (oNOMLine as ITransactionLine4).tlVATIncValue := TfNomLine(lstLines[iLine]).rOrigIncValue * iMultiplier;
          end else
          begin
            oNOMLine.tlVATCode := TVATInfo(TfNomLine(lstLines[iLine]).cmbVATCode.Items.Objects[TfNomLine(lstLines[iLine]).cmbVATCode.ItemIndex]).cCode;
          end;{if}

          oNOMLine.tlVATAmount := TfNomLine(lstLines[iLine]).edVATAmount.Value * iMultiplier;

          // VAT - Manual Auto or N/A ?
//          rCalculatedVATAmount := Round_Up(TfNomLine(lstLines[iLine]).edNetAmount.Value
//          * TVATInfo(TfNomLine(lstLines[iLine]).cmbVatCode.Items.Objects[TfNomLine(lstLines[iLine]).cmbVatCode.Itemindex]).rRate, 2);

          // NF: 21/01/2008
          // Fix for 2177.40 standard VAT - VAT was coming out as 381.04, should be 381.05
          rVATRateLine := TrueReal(TVATInfo(TfNomLine(lstLines[iLine]).cmbVatCode.Items.Objects[TfNomLine(lstLines[iLine]).cmbVatCode.Itemindex]).rRate, 10);
          rCalculatedVATAmount := Round_Up(TfNomLine(lstLines[iLine]).edNetAmount.Value * rVATRateLine, 2);

          if ZeroFloat(ABS(oNOMLine.tlVATAmount) - ABS(rCalculatedVatAmount)) then
          begin
            if TfNomLine(lstLines[iLine]).cmbVatCode.ItemIndex = 0
            then ((oNOMLine as ITransactionLine4).tlAsNOM as ITransactionLineAsNom2).tlnNomVatType  := nlvNA
            else ((oNOMLine as ITransactionLine4).tlAsNOM as ITransactionLineAsNom2).tlnNomVatType  := nlvAuto;
          end else
          begin
            ((oNOMLine as ITransactionLine4).tlAsNOM as ITransactionLineAsNom2).tlnNomVatType  := nlvManual;
            oNom.thManualVAT := TRUE;
          end;{if}

          // NF: 08/01/2008 - Fixed in v6
          // Problem : NOMs with any manual VAT that are added by the add nom wizard seem fine. But when they are posted, the values are not posted to the correct GL Codes.
          // Solution : When Manual VAT is set, populate the thTotalVAT value and the thVATAnalysis array. This should fix this problem.
          // Note : We only pouplate these 2 VAT fields if it is manual vat. This is because prior to this version they were always zero, and we don't want to rock the boat.

          // Increment Total VAT and VAT Analysis Array
          if oNom.thManualVAT then
          begin
            // MH 07/07/2014 v7.0.11 ABSEXCH-12347: Added check that the VAT Code is set otherwise it crashes in the COM Toolkit
            If (oNOMLine.tlVATCode <> #0) Then
            Begin
              oNom.thTotalVAT := oNom.thTotalVAT + oNOMLine.tlVATAmount;
              oNom.thVATAnalysis[oNOMLine.tlVATCode] := oNom.thVATAnalysis[oNOMLine.tlVATCode] + oNOMLine.tlVATAmount;
            End; // If (oNOMLine.tlVATCode <> #0)
          end;{if}

          //PR: 22/04/2013 ABSEXCH-6794 Store description of line. If more than one line then use last line.
          if Trim(oNOMLine.tlDescr) <> '' then
            sLastDesc := Trim(oNOMLine.tlDescr);


          // Save Line
          oNOMLine.Save;
          oNOMLine := nil;
        end;{if}
      end;{for}

      // Add Balancing Line
      oNOMLine := oNOM.thLines.Add;
      PopulateLineDefaults(oNOMLine);
      oNOMLine.tlGLCode := StrToIntDef(edBankAccount.Text,0);

      //PR: 22/04/2013 ABSEXCH-6794 Change description on balancing line to use 'Auto' + description of last line
      if Trim(sLastDesc) = '' then
        oNOMLine.tlDescr := 'Auto-Balance'
      else
        oNOMLine.tlDescr := 'Auto ' + sLastDesc;
      oNOMLine.tlNetValue := edTotGrossAmount.Value * iMultiplier * -1;
      oNOMLine.tlStockCode := edPayInRef.Text;
      oNOMLine.Save;
      oNOMLine := nil;
    end;

    ttTransfer : begin
      // Line #1 - Debit Bank Account
      oNOMLine := oNOM.thLines.Add;
      PopulateLineDefaults(oNOMLine);
      oNOMLine.tlGLCode := StrToIntDef(edBankAccount.Text,0);
      oNOMLine.tlDescr := edTransferDesc.Text;
//      oNOMLine.tlNetValue := edTransferValue.Value;
      oNOMLine.tlNetValue := - edTransferValue.Value; // NF: 20/07/06 - Reported as a bug (FR0331)
      oNOMLine.Save;
      oNOMLine := nil;

      // Line #2 - Credit Bank To Account
      oNOMLine := oNOM.thLines.Add;
      PopulateLineDefaults(oNOMLine);
      oNOMLine.tlGLCode := StrToIntDef(edBankTo.Text,0);
      oNOMLine.tlDescr := edTransferDesc.Text;
//      oNOMLine.tlNetValue := - edTransferValue.Value;
      oNOMLine.tlNetValue := edTransferValue.Value; // NF: 20/07/06 -  Reported as a bug (FR0331)
      oNOMLine.Save;
      oNOMLine := nil;
    end;
  end;{case}

  // Add Auto properties
  if cbRecurring.checked then
  begin

    with (oNOM as ITransaction4), (thAutoSettings as IAutoTransactionSettings2) do
    begin
      atAutoTransaction := TRUE;

      // always set all these properties, as they are all shown on screen, despite which type of auto it is.
      atStartDate := MaskDateToStr8(edStartDate.Text);
      atEndDate := MaskDateToStr8(edEndDate.Text);
      atStartPeriod := edStartPY.EPeriod;
      atStartYear := edStartPY.EYear;
      atEndPeriod := edEndPY.EPeriod;
      atEndYear := edEndPY.EYear;

      if rbDate.Checked then
      begin
        // By Date
        atIncrementType := aiDays;
        atIncrement := Trunc(edIncDays.value);
        atKeepDate := cbDateKeepDate.checked;
      end else
      begin
        // By Period
        atIncrementType := aiPeriods;
        atIncrement := Trunc(edIncPeriods.value);
        atKeepDate := cbPYKeepDate.checked;
      end;{if}

      atAutoCreateOnPost := cbAutoCreate.Checked;
    end;{with}
  end;{if}
end;

procedure TfrmAddNomWizard.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAddNomWizard.FormCreate(Sender: TObject);

  procedure CreateVATCodeList;
  Const
    aVATCodes : Array [1..21] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');
  var
    iPos : smallint;
    sPos : string;
  begin{CreateVATCodeList}
    slVATCodes := TStringList.Create;

    // Add N/A
    slVATCodes.AddObject('N/A',TVATInfo.Create(0, #0));

    For iPos := Low(aVATCodes) To High(aVATCodes) Do begin
      // Add VAT Code
      sPos := aVATCodes[iPos];
      slVATCodes.AddObject(oToolkit.SystemSetup.ssVATRates[sPos].svDesc + ' ('
      + oToolkit.SystemSetup.ssVATRates[sPos].svCode + ')'
      ,TVATInfo.Create(oToolkit.SystemSetup.ssVATRates[sPos].svRate
      , WideCharToChar(oToolkit.SystemSetup.ssVATRates[sPos].svCode[1])));
    end;{for}


    // Add Special VAT Codes
    slVATCodes.AddObject('Inclusive (I)',TVATInfo.Create(0, 'I'));


  end;{CreateVATCodeList}

var
  iPeriod, iYear : byte;
  iPos : integer;

begin
  // Initialise
  bIgnoreExits := TRUE;
  bOK := FALSE;
  iNOMFolio := 0;
  iNoOfSteps := 3;

  // Set MultiCurrency Flag based on compiler directive
  bMultiCurrency := FALSE;
  {$IFDEF MC_On}
    bMultiCurrency := TRUE;
  {$ENDIF}

  // Initialise Validation Array
  For iPos := 1 to TH_NO_OF_FIELDS_TO_VALIDATE do
  begin
    aValidation[iPos].FieldOK := FALSE;

    case iPos of
      F_BANK_ACCOUNT : begin
        aValidation[iPos].FieldControl := edBankAccount;
        aValidation[iPos].Description := 'Bank Account';
      end;
      F_BANK_TO : begin
        aValidation[iPos].FieldControl := edBankTo;
        aValidation[iPos].Description := 'Bank To';
      end;
      F_COSTCENTRE : begin
        aValidation[iPos].FieldControl := edCC;
        aValidation[iPos].Description := 'Cost Centre';
      end;
      F_DEPARTMENT : begin
        aValidation[iPos].FieldControl := edDept;
        aValidation[iPos].Description := 'Department';
      end;
      F_TRANSFER_VALUE : begin
        aValidation[iPos].FieldControl := edTransferValue;
        aValidation[iPos].Description := 'Transfer Value';
      end;
      F_CURRENCY_RATE : begin
        aValidation[iPos].FieldControl := edCurrencyRate;
        aValidation[iPos].Description := 'Currency Rate';
      end;
    end;{case}
  end;{for}

  SetUDFields; //SSK 27/07/2016 2016-R3 ABSEXCH-10038: Enable / visible required UDF fields
  // Default to first page
  nbPages.PageIndex := 0;
  iStep := 1;

  // Changes the "Step x of y" captions
  SetStepCaptions;

  // Populate Currencies
  if bMultiCurrency then
  begin
    FillCurrencyCombo(cmbCurrency, 1);
    cmbCurrencyChange(cmbCurrency);
  end;{if}
//  cmbCurrencyH.Items := cmbCurrency.Items;

  // Create lines list, holds references to the frames holding the transaction lines
  lstLines := TList.Create;

  // Creates the list of VAT Codes for copying to each line / frame
  CreateVATCodeList;

  // Adds One Line to the grid
  AddNewLine;

  // Set Defaults
  edTotNetAmount.Value := 0;
  edTotVATAmount.Value := 0;
  edTotGrossAmount.Value := 0;

  // Initialise Date / Period Year Fields
  edDate.Text := DateToMaskDate(SysUtils.Date);
  iPeriod := GetLocalPr(0).CPr;
  iYear := GetLocalPr(0).CYr;
  edPY.InitPeriod(iPeriod,iYear,TRUE,TRUE);
  edDateExit(edDate);

  // Initialise Date / Period Year Fields for Auto TXs
  edStartDate.Text := DateToMaskDate(SysUtils.Date);
  edEndDate.Text := PadString(psLeft, IntToStr(DayOfTheMonth(SysUtils.Date)), '0', 2)
  + PadString(psLeft, IntToStr(MonthOfTheYear(SysUtils.Date)), '0', 2)
  + IntToStr(CurrentYear+3); // '31122049';
  Date2Pr(DateToStr8(SysUtils.Date), iPeriod, iYear, nil);
  edStartPY.InitPeriod(iPeriod,iYear,TRUE,TRUE);

//  iYear := 149;
//  iPeriod := oToolkit.SystemSetup.ssPeriodsInYear;
  iYear := iYear + 3;
  edEndPY.InitPeriod(iPeriod,iYear,TRUE,TRUE);

  // Initialise CC / Dept Fields
  edCC.Text := UserProfile.CCDep[TRUE];
  if trim(edCC.Text) <> '' then ExitCCValidate(edCC);
  edDept.Text := UserProfile.CCDep[FALSE];
  if trim(edDept.Text) <> '' then ExitDeptValidate(edDept);

  // Read in Previous Entries
//  edBankAccount.Text := sLastBankAccount;
//  if trim(edBankAccount.Text) <> '' then edBankAccountExit(edBankAccount);

  // Set Bank Account field to normal color, so it doesn;t look funny
//  edBankAccount.Color := clWindow;
  ColorEditBox(edBankAccount, clWhite);
  // CA 03/08/2012 ABSEXCH-12952 - Rebranding / UI Update
  edBankAccount.Font.Color := clNavy;
end;

procedure TfrmAddNomWizard.Button2Click(Sender: TObject);
begin
  AddNewLine;
end;

procedure TfrmAddNomWizard.AddNewLine;
var
  fNewLine : TfNomLine;
begin
  // Create new Frame
  fNewLine := TfNomLine.Create(self);

  // Add reference to frame into array, so we can reference all the frames
  lstLines.Add(fNewLine);

  with fNewLine do
  begin
    // Set Properties
    Name := Name + IntToStr(lstLines.Count);
    Parent := sbLines; // Makes it visible
    Top := (Height * (lstLines.Count -1) + 1) - sbLines.VertScrollBar.ScrollPos;
    Left := 1;
    Tag := lstLines.Count -1;

    // Set Events used to pass info between the form and the frame
    OnAddNewLine := FrameAddNewLine;
    OnRecalcTotals := RecalcTotals;
    OnGetDefaultCC := SendDefaultCC;
    OnGetDefaultDept := SendDefaultDept;
    OnGetGLCurrency := SendGLCurrency;
    OnManufactureComTKTX := ManufactureComTKTX;

    // Initialise Frame (there is no OnCreate event)
    Initialise;

    // Set VatCode to list on form
    cmbVatCode.Items := slVATCodes;
    cmbVatCode.ItemIndex := 0;

  end;{with}
end;

procedure TfrmAddNomWizard.EnableDisable;
// Greys In/Out Controls
// Makes Controls Visible/Invisible
// Changes Captions
begin

  // Set Button Captions
  btnNext.Caption := '&Next  >>'; // other pages
  btnNext.HelpContext := 2068;

  if nbPages.PageIndex = (nbPages.Pages.Count -1) then
  begin
    btnNext.Caption := '&Finish'; // last page
    btnNext.HelpContext := 2069;
  end;{if}
  
  //SSK 27/07/2016 2016-R3 ABSEXCH-10038: need to check for Bank Transfer
  if NomType = ttTransfer then
  begin
    if (nbPages.PageIndex = 1) and (iNoOfUdf = 0) and (not cbRecurring.checked) then
    begin
      btnNext.Caption := '&Finish'; // last page
      btnNext.HelpContext := 2069;
    end;
  end;

  if (nbPages.PageIndex = 2) and ((iNoOfUdf = 0) or (NomType = ttTransfer)) and (not cbRecurring.checked) then
  begin
    btnNext.Caption := '&Finish'; // last page
    btnNext.HelpContext := 2069;
  end;{if}

  //SSK 27/07/2016 2016-R3 ABSEXCH-10038: pageindex changed from 2 to 3
  if (nbPages.PageIndex = 3) and (NomType = ttTransfer) and (cbRecurring.checked) then
  begin
    btnNext.Caption := '&Finish'; // last page
    btnNext.HelpContext := 2069;
  end;{if}

  // Enable / Disable Main Buttons
  if nbPages.PageIndex = 0
  then btnBack.Enabled := FALSE;

  if nbPages.PageIndex > 0
  then btnBack.Enabled := TRUE;

  // Enable / Disable CC/Dept fields depending on the System setup switch
  lCCHeader.Enabled := oToolkit.SystemSetup.ssUseCCDept;
  lDeptHeader.Enabled := lCCHeader.Enabled;
  edCC.Enabled := lCCHeader.Enabled;
  edDept.Enabled := lCCHeader.Enabled;
  edCCDesc.Enabled := lCCHeader.Enabled;
  edDeptDesc.Enabled := lCCHeader.Enabled;

  // enable disable Currency fields depending on compiler directives and EuroVers
  lCurrency.visible := bMultiCurrency;
  cmbCurrency.visible := lCurrency.visible;
  lCurrencyRate.visible := lCurrency.visible;
  edCurrencyRate.visible := lCurrency.visible;
  lCurrencyH.visible := lCurrency.visible;
//  cmbCurrencyH.visible := lCurrency.visible;
  edCurrencyH.visible := lCurrency.visible;
  lCurrencyRateH.visible := lCurrency.visible;
  edCurrencyRateH.visible := lCurrency.visible;
  lCurrencyTit.visible := lCurrency.visible;
//  bvCurrency.visible := lCurrency.visible;

  // Disable Currency rate, if base rate selected
  lCurrencyRate.enabled := cmbCurrency.visible and (cmbCurrency.ItemIndex > 0);
  edCurrencyRate.enabled := lCurrencyRate.enabled;

  // Enable / Disable Fields for transfers
  lBankTo.Visible := NomType = ttTransfer;
  edBankTo.Visible := lBankTo.Visible;
  edBankToDesc.Visible := lBankTo.Visible;
  lBankToH.Visible := lBankTo.Visible;
  edBankToH.Visible := lBankTo.Visible;
  lBank2Desc.Visible := lBankTo.Visible;

  edPayInRefH.visible := not lBankTo.Visible;
  lPayInRefH.visible := edPayInRefH.visible;

  // Enable / Disable Fields for Recurring Noms
  lDate.Visible := (not cbRecurring.checked);
  edDate.Visible := lDate.Visible;
  lPY.Visible := lDate.Visible;
  edPY.Visible := lDate.Visible;

  // Show Date of Period/Year on header
  if (cbRecurring.checked) and rbPY.Checked then
  begin
    lDatePYH.Caption := 'Period / Year :';
    edDateH.Visible := FALSE;
    edPYH.Visible := TRUE;
  end else
  begin
    lDatePYH.Caption := 'Date :';
    edDateH.Visible := TRUE;
    edPYH.Visible := FALSE;
  end;{if}

  // Display Special Transfer Fields ?
  lTransferValue.visible := (NomType = ttTransfer);
  edTransferValue.visible := lTransferValue.visible;
  lTransferDesc.visible := lTransferValue.visible;
  edTransferDesc.visible := lTransferValue.visible;
  lTransferDetails.visible := lTransferValue.visible;
  bvTransfer.visible := lTransferValue.visible;

  edPayInRef.visible := not lTransferValue.visible;
  lPayInRef.visible := edPayInRef.visible;

  // Set Width of bank Desc, so it doesn't clash with bank to fields (when visible)
  if lBankTo.Visible then lBank1Desc.Width := 129
  else lBank1Desc.Width := 449;

  // Value of TX must be non-zero to be able to store it
  // Disable Finish button if TX Value is Zero, and we are on the last page
 
  //SSK 27/07/2016 2016-R3 ABSEXCH-10038: pageindex changed from 3 to 4
  btnNext.Enabled := not ((nbPages.PageIndex = 4) and ZeroFloat(edTotGrossAmount.Value));

end;

procedure TfrmAddNomWizard.FrameAddNewLine(Sender: TObject);
// Callback Proc to add new line
begin
  if (Sender as TfNomLine).Tag = (lstLines.Count -1) then
  begin
    AddNewLine;
    ActiveControl := TfNomLine(lstLines[lstLines.Count -1]).edDesc;
  end;{if}
end;

procedure TfrmAddNomWizard.RecalcTotals(Sender: TObject);
// Callback Proc to Recalc the form totals
var
  iPos : integer;
begin
  // Zero Totals
  For iPos := TOT_NET_AMOUNT to TOT_GROSS_AMOUNT
  do aTotals[iPos] := 0;

  // Add up all the lines
  For iPos := 0 to lstLines.Count -1 do
  begin
    aTotals[TOT_NET_AMOUNT] := aTotals[TOT_NET_AMOUNT]
    + TfNomLine(lstLines[iPos]).edNetAmount.Value;

    aTotals[TOT_VAT_AMOUNT] := aTotals[TOT_VAT_AMOUNT]
    + TfNomLine(lstLines[iPos]).edVATAmount.Value;

    aTotals[TOT_GROSS_AMOUNT] := aTotals[TOT_GROSS_AMOUNT]
    + StrToFloatDef(TfNomLine(lstLines[iPos]).lGrossAmount.Caption, 0);
  end;{for}

  // Round 'em off
  edTotNetAmount.Value := Round_Up(aTotals[TOT_NET_AMOUNT], 2);
  edTotVATAmount.Value := Round_Up(aTotals[TOT_VAT_AMOUNT], 2);
  edTotGrossAmount.Value := Round_Up(aTotals[TOT_GROSS_AMOUNT], 2);

  // Greys In/Out Controls
  EnableDisable;
end;

procedure TfrmAddNomWizard.DoTidyUp;
begin
  // Highlight New Nom in daybook
  if bOK and (hNomDaybookHandle <> 0)
  then PostMessage(hNomDaybookHandle, WM_FormCloseMsg, 129, iNOMFolio);

  // Clear Up Lines List
  if lstLines <> nil then
  begin
    ClearList(lstLines);
    lstLines.Free;
    lstLines := nil;
  end;{if}

  // Clear Up Vatcodes list
  if slVATCodes <> nil then
  begin
    ClearList(slVATCodes);
    slVATCodes.Free;
    slVATCodes := nil;
  end;{if}

  // Clear Up Toolkit
  if oToolkit <> nil then
  begin
    oToolkit.CloseToolkit;
    oToolkit := nil;
  end;{if}

//  bFormActive := FALSE;
  frmAddNomWizard := nil;
end;


procedure TfrmAddNomWizard.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  // Are you sure ?
  if not bOK then
  begin
    CanClose := MsgBox('Are you sure you want to cancel the Add Journal Wizard ?'
    ,mtConfirmation, [mbYes, mbNo], mbNo, 'Add Journal Wizard') = mrYes;
  end;{if}

  if CanClose then DoTidyUp;
end;

procedure TfrmAddNomWizard.ChangeAutoMode(Sender: TObject);
// When changing the mode of an auto TX
begin
  // Enable Disable Date Fields
  lStartDate.enabled := rbDate.checked;
  edStartDate.enabled := lStartDate.enabled;
  lIncDays.enabled := lStartDate.enabled;
  edIncDays.enabled := lStartDate.enabled;
  cbDateKeepDate.enabled := lStartDate.enabled;
  lEndDate.enabled := lStartDate.enabled;
  edEndDate.enabled := lStartDate.enabled;

  // Enable Disable Period Fields
  lStartPY.enabled := not lStartDate.enabled;
  edStartPY.enabled := lStartPY.enabled;
  lIncPeriods.enabled := lStartPY.enabled;
  edIncPeriods.enabled := lStartPY.enabled;
  cbPYKeepDate.enabled := lStartPY.enabled;
  lEndPY.enabled := lStartPY.enabled;
  edEndPY.enabled := lStartPY.enabled;

  // Colour The Checkboxes manually, cos ELs Checkboxes don't work properly
  if cbPYKeepDate.enabled then cbPYKeepDate.Font.Color := Font.Color
  else cbPYKeepDate.Font.Color := clGrayText;

  ColorEditBox(edBankAccount, clWhite);
  // CA 03/08/2012 ABSEXCH-12952 - Rebranding / UI Update
  edBankAccount.Font.Color := clNavy;

  cbPYKeepDate.Repaint;

  if cbDateKeepDate.enabled then cbDateKeepDate.Font.Color := Font.Color
  else cbDateKeepDate.Font.Color := clGrayText;
  cbDateKeepDate.Repaint;
end;

procedure TfrmAddNomWizard.TXTypeChange(Sender: TObject);
begin
  // Set NomType, so we know the type of TX we are dealing with
  if rbPayment.Checked then NomType := ttPayment;
  if rbReceipt.Checked then NomType := ttReceipt;
  if rbTransfer.Checked then NomType := ttTransfer;
  if rbStandard.Checked then NomType := ttStandard;

  // Changes the "Step x of y" captions
  SetStepCaptions;
end;

procedure TfrmAddNomWizard.nbPagesPageChanged(Sender: TObject);
var
  bFound : boolean;
  iStatus : integer;
  iPeriod, iYear : byte;
begin
  // Greys In/Out Controls
  EnableDisable;

  // Change bank account descriptions for transfers
  if NomType = ttTransfer then
  begin
    lBankAccount.Caption := 'Bank From :';
    aValidation[F_BANK_ACCOUNT].Description := 'Bank From';
  end else
  begin
    lBankAccount.Caption := 'Bank Account :';
    aValidation[F_BANK_ACCOUNT].Description := 'Bank Account';
  end;{if}
  lBankAccountH.Caption := lBankAccount.Caption;

  // Copy Values from Bank Account page to header of nom lines page
  edBankAccountH.Text := edBankAccount.Text;
  edBankAccountH.Hint := edBankAccount.Hint;
  lBank1Desc.Caption := edBankAccountDesc.Text;
  lBank2Desc.Caption := edBankToDesc.Text;
  edBankToH.Text := edBankTo.Text;
  edBankToH.Hint := edBankTo.Hint;

  // Set Header Date/Period/Year
  if (cbRecurring.checked) then
  begin
    // Get Header Date/Period/Year from the Auto parameters
    edDateH.Text := edStartDate.Text;
    iPeriod := edPY.EPeriod;
    iYear := edPY.EYear;
    edPYH.InitPeriod(iPeriod, iYear, TRUE, TRUE);
  end else
  begin
    // Get Header Date from the normal Date
    edDateH.Text := edDate.Text;
  end;{if}

  // Set other header fields
  edReferenceH.Text := edReference.Text;
  edPayInRefH.Text := edPayInRef.Text;
//  cmbCurrencyH.ItemIndex := cmbCurrency.ItemIndex;
  edCurrencyH.Text := cmbCurrency.Text;
  edCurrencyRateH.Value := edCurrencyRate.Value;

  // Set Active control to the best control on the new page
  case nbPages.PageIndex of

    0: begin // Page : Transaction Type
      if rbPayment.Checked then ActiveControl := rbPayment;
      if rbReceipt.Checked then ActiveControl := rbReceipt;
      if rbTransfer.Checked then ActiveControl := rbTransfer;
      if rbStandard.Checked then ActiveControl := rbStandard;
    end;

    1: begin // Page : Tranaction Header and Defaults
      if cmbCurrency.visible then ActiveControl := cmbCurrency
      else ActiveControl := edBankAccount;

      if (oToolkit.SystemSetup as ISystemSetup5).ssEnforceGLClasses then
      begin
        // Search for Bank Accounts
        bFound := FALSE;
        iStatus := oToolkit.GeneralLedger.GetFirst;
        while (iStatus = 0) and (not bFound) do
        begin
          if (oToolkit.GeneralLedger as IGeneralLedger2).glClass = glcBankAccount
          then bFound := TRUE;
          iStatus := oToolkit.GeneralLedger.GetNext;
        end;{while}

        // No Bank Accounts Error Message
        if (not bFound)
        then MsgBox('You currently have no bank accounts setup on your system.'#13#13
        + 'To rectify this problem you need to set the "Class" of your bank account GL Codes to "Bank Account"'
        , mtWarning, [mbOK], mbOK, 'No Bank Accounts');
      end;{if}

      // NF: 15/03/2007 - Change caption for 5.71.001 (FR0180)
      if NomType = ttPayment then lPayInRef.Caption := 'Chq No./Ref No. :'
      else lPayInRef.Caption := 'Pay In Ref :';
    end;

    //SSK 27/07/2016 2016-R3 ABSEXCH-10038: added new step in Add Nom Wizard for entering UDF for Nom headers
    2: begin // Page : UDF Fields
       if iNoOfUdf>0 then
         SetFocusToVisibleUDF([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F]);
   end;

    3: begin // Page : Recurring TX Fields
      if rbDate.Checked then ActiveControl := rbDate
      else ActiveControl := rbPY;
    end;

    4: begin // Page : Tranaction Lines
      TfNomLine(lstLines[lstLines.Count-1]).FocusControlWithTag(1);
    end;
  end;{case}
end;

procedure TfrmAddNomWizard.edBankAccountExit(Sender: TObject);
var
  oGL : IGeneralLedger2;
  iGLCode : integer;
begin
  // Validate GL Code
  if bMultiCurrency then oGL := ValidateGLCode(TEdit(Sender)
  , TCurrencyInfo(cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]).CurrencyNo
  , (oToolkit.SystemSetup as ISystemSetup5).ssEnforceGLClasses) // Returns GL, if Valid
  else oGL := ValidateGLCode(TEdit(Sender), -1, (oToolkit.SystemSetup as ISystemSetup5).ssEnforceGLClasses); // Returns GL, if Valid

  if oGL = nil then
  begin
    if (ActiveControl <> btnCancel) and (ActiveControl <> btnBack) then // Do not popup list if we are not continuing
    begin
      // Popup List
      with TfrmTKPickList.CreateWith(self, oToolkit) do begin

        // Set List Properties
        mlList.Columns[0].DataType := dtInteger;
        plType := plGLCode;

        // only show GLCodes of the correct class (if enforced)
        if (oToolkit.SystemSetup as ISystemSetup5).ssEnforceGLClasses
        then iGLIncludeClass := glcBankAccount;

        bRestrictList := TRUE;
        bAutoSelectIfOnlyOne := TRUE;
        bShowMessageIfEmpty := TRUE;
        if bMultiCurrency
        then iGLCurrency := TCurrencyInfo(cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]).CurrencyNo;
        iGLCode := StrToIntDef(TEdit(Sender).Text,0);

        if (iGLCode = 0) and (TEdit(Sender).Text <> '0') then
          begin
            // Search for GL Code by name
            sFind := TEdit(Sender).Text;
            iSearchCol := 1;
          end
        else begin
          // Search for GL Code by number
          sFind := mlList.FullNomKey(iGLCode);
          iSearchCol := 0;
        end;{if}

        mlList.Columns[1].IndexNo := 1;

        // Show Pick List
        if showmodal = mrOK then
        begin
          // Get Selected GL Code
          oGL := ctkDataSet.GetRecord as IGeneralLedger2;
          if oGL <> nil
          then TEdit(Sender).Text := IntToStr(oGL.glCode);
        end;{if}
        Release;

        // Validated the selected GL Code
        if bMultiCurrency then oGL := ValidateGLCode(TEdit(Sender)
        , TCurrencyInfo(cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]).CurrencyNo
        , (oToolkit.SystemSetup as ISystemSetup5).ssEnforceGLClasses)
        else oGL := ValidateGLCode(TEdit(Sender), -1, (oToolkit.SystemSetup as ISystemSetup5).ssEnforceGLClasses);

      end;{with}
    end;{if}
  end;{if}

  // Set Validation Status
  aValidation[TWincontrol(Sender).Tag].FieldOK := oGL <> nil;

  // Make sure that the 2 bank accounts are not the same for Transfers
  if (NomType = ttTransfer) and (edBankAccount.Text = edBankTo.Text)
  and (aValidation[TWincontrol(Sender).Tag].FieldOK) then
  begin
    aValidation[edBankTo.Tag].FieldOK := FALSE;
  end;{if}

  // Update GL Description
  if (TWincontrol(Sender).Name = 'edBankAccount')
  then edBankAccountDesc.Text := TEdit(Sender).Hint;

  if (TWincontrol(Sender).Name = 'edBankTo')
  then edBankToDesc.Text := TEdit(Sender).Hint;
end;

procedure TfrmAddNomWizard.FieldExit(Sender: TObject);
begin
  // Use a message to handle the field exit events,
  // as it stops problems when using customisation
  if not bIgnoreExits then PostMessage(Handle, WM_MyEnterExit, TWinControl(Sender).Tag, FIELD_EXIT);
end;

procedure TfrmAddNomWizard.ExitCCValidate(Sender: TObject);
// In External procedure ,so we can call it without the customisation going off
var
  oCC : ICCDept2;
begin
  // Validate CC
  oCC := ValidateCostCentre(TEdit(Sender));

  if oCC = nil then
  begin
    if (ActiveControl <> btnCancel) and (ActiveControl <> btnBack) then  // Only popup list if continuing
    begin
      with TfrmTKPickList.CreateWith(self, oToolkit) do begin
        // Set Form Properies
        plType := plCC;
        sFind := edCC.Text;
        iSearchCol := 0;
        mlList.Columns[1].IndexNo := 1;
        bRestrictList := TRUE;
        bAutoSelectIfOnlyOne := TRUE;
        bShowMessageIfEmpty := TRUE;

        // Show Form
        if showmodal = mrOK then
        begin
          // Get Selected CC
          oCC := ctkDataSet.GetRecord as ICCDept2;
          edCC.Text := oCC.cdCode;
        end;{if}
        release;

        // Validate Selected CC
        oCC := ValidateCostCentre(edCC);
      end;{with}
    end;{if}
  end;{if}

  // Set Validation Status
  aValidation[TWincontrol(Sender).Tag].FieldOK := oCC <> nil;

  // Set Description
  edCCDesc.Text := edCC.Hint;
end;

procedure TfrmAddNomWizard.ExitDeptValidate(Sender: TObject);
// In External procedure ,so we can call it without the customisation going off
var
  oDept : ICCDept2;
begin
  // Validate Dept
  oDept := ValidateDepartment(TEdit(Sender));
  if oDept = nil then
  begin
    if (ActiveControl <> btnCancel) and (ActiveControl <> btnBack) then // Only Popup list if continuing
    begin
      with TfrmTKPickList.CreateWith(self, oToolkit) do begin
        // Set Form Properties
        plType := plDept;
        sFind := edDept.Text;
        iSearchCol := 0;
        mlList.Columns[1].IndexNo := 1;
        bRestrictList := TRUE;
        bAutoSelectIfOnlyOne := TRUE;
        bShowMessageIfEmpty := TRUE;

        // Show Form
        if showmodal = mrOK then
        begin
          // Get Selected Dept
          oDept := ctkDataSet.GetRecord as ICCDept2;
          edDept.Text := oDept.cdCode;
        end;{if}
        release;

        // Validate selected Dept
        oDept := ValidateDepartment(TEdit(Sender));
      end;{with}
    end;{if}
  end;{if}

  // Set Validation Status
  aValidation[TWincontrol(Sender).Tag].FieldOK := oDept <> nil;

  // Set Dept Description
  edDeptDesc.Text := TEdit(Sender).Hint;
end;


Procedure TfrmAddNomWizard.TabToControl(bTabToNext : boolean);
var
  lstTabOrder : TList;

  Function FindTabControl(iStartPos, iEndPos : integer) : TWinControl;
  var
    iInc, iPos : integer;
  begin{FindTabControl}
    Result := nil;

    // Defines which way to go through the list of controls
    if iStartPos < iEndPos then iInc := 1
    else iInc := -1;

    // Set Start
    iPos := iStartPos;

    // Go through Controls
    While (iPos <> iEndPos) do
    begin
      // Check Control
      if (TWinControl(lstTabOrder[iPos]).parent is TForm)
      and TWinControl(lstTabOrder[iPos]).TabStop
      and TWinControl(lstTabOrder[iPos]).Enabled then
      begin
        // Found Control to tab to
        Result := TWinControl(lstTabOrder[iPos]);
        Exit;
      end;{if}

      // Next / Previous Control
      iPos := iPos + iInc;
    end;{while}
  end;{FindTabControl}

var
  iPos : integer;
  NewActiveControl : TWinControl;

begin{TabToControl}

  // Initialise
  NewActiveControl := nil;
  lstTabOrder := TList.Create;
  GetTabOrderList(lstTabOrder);

  // Go through the tab order list
  For iPos := 0 to lstTabOrder.Count -1
  do begin
    if TWinControl(lstTabOrder[iPos]).Name = 'sbLines' then
    begin
      if bTabToNext then
      begin
        // Find Next Tab Control
        NewActiveControl := FindTabControl(iPos+1, lstTabOrder.Count -1);
        if NewActiveControl = nil then NewActiveControl := FindTabControl(0, iPos-1);
      end else
      begin
        // Find Previous Tab Control
        NewActiveControl := FindTabControl(iPos-1, 0);
        if NewActiveControl = nil then NewActiveControl := FindTabControl(lstTabOrder.Count -1, iPos+1);
      end;{if}

      // Set Active Control
      if NewActiveControl <> nil then
      begin
        ActiveControl := NewActiveControl;
        break;
      end;{if}

    end;{if}
  end;{for}

  // Clear Up
  lstTabOrder.Free;
end;{TabToControl}

Procedure TfrmAddNomWizard.MoveUpDownGrid(bUp : boolean);
var
  iCurrentLine : integer;
begin{MoveUpDownGrid}
  // Get Current line index from control's parent(the frame)'s Tag
  iCurrentLine := TWinControl(ActiveControl.Parent).Tag;

  // Focus New Control
  if bUp then TfNomLine(lstLines[iCurrentLine-1]).FocusControlWithTag(ActiveControl.Tag)
  else TfNomLine(lstLines[iCurrentLine+1]).FocusControlWithTag(ActiveControl.Tag)
end;{MoveUpDownGrid}

procedure TfrmAddNomWizard.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
// Use this Event to trap Keys, as not all keys get trapped in other events
var
  iPos, iPrevLine : integer;
  NewMsg : TWMKey;

  Procedure TabToNextControl;
  begin{TabToNextControl}
    FillChar(NewMsg, SizeOf(NewMsg), #0);
    NewMsg.CharCode := VK_RETURN;
    FormShortCut(NewMsg, Handled);
  end;{TabToNextControl}

begin
  if ActiveControl <> nil then
  begin

    case Msg.CharCode of

      // TAB pressed
      VK_TAB : begin
        // Make sure the frame knows that the last control movement was a tab
        if (ActiveControl.Parent is TfNomLine)
        then (ActiveControl.Parent as TfNomLine).Tabbed := TRUE;
      end;

      // Return / Enter pressed
      VK_RETURN : begin
        if not (ActiveControl is TButton) then
        begin
          // Replace Enter with Tab
          if ReplaceEntersForControl(ActiveControl) then
          begin
            PostMessage(Handle,wm_NextDlgCtl,0,0); // Tab to Next control
            if (ActiveControl is TEditPeriod) then Handled := TRUE; // This stops the Mask edit validation happening (on #13), which crashes the app
          end;{if}
        end;{if}

        // Make sure the frame knows that the last control movement was a tab
        if (ActiveControl.Parent is TfNomLine)
        then (ActiveControl.Parent as TfNomLine).Tabbed := TRUE;

      end;

      // Up, Down, Left, Right pressed
      VK_LEFT..VK_DOWN : begin
        if (ActiveControl.Parent is TfNomLine) then
        begin
          // Grid Left, Right, Up, Down
          case Msg.CharCode of

            VK_LEFT : (ActiveControl.Parent as TfNomLine).CursorLeft;

            VK_UP : begin
              if (ActiveControl is TCustomEdit) then
              begin
                if (ActiveControl.Parent as TfNomLine).Tag = 0 then
                begin
                  // First Line - Tab to previous control
                  TabToControl(FALSE);
                end else
                begin
                  // Go to edit field above current edit field
                  MoveUpDownGrid(TRUE);
                end;{if}
              end;{if}
            end;

            VK_RIGHT : (ActiveControl.Parent as TfNomLine).CursorRight;

            VK_DOWN : begin
              if (ActiveControl is TCustomEdit) then
              begin
                if (ActiveControl.Parent as TfNomLine).Tag = (lstLines.Count -1) then
                begin
                  // Last Line - Tab to next control
                  TabToControl(TRUE);
                end else
                begin
                  // Go to edit field below current edit field
                  MoveUpDownGrid(FALSE);
                end;{if}
              end;{if}
            end;

          end;{case}
        end else
        begin
          // Re-route Up Down Left Right on the appropriate controls
          if (not (ActiveControl is TRadioButton))
          and (not (ActiveControl is TBorRadio))
          and (not (ActiveControl is TBorCheck))
          and (not ((ActiveControl is TComboBox){ and (Msg.CharCode in [VK_UP, VK_DOWN])}))
          and (not (ActiveControl is TButton))
          and (not (ActiveControl is TDateTimePicker))
          and (not ((ActiveControl is TEditDate) and (Msg.CharCode in [VK_LEFT, VK_RIGHT])))
          and (not ((ActiveControl is TEdit) and (Msg.CharCode in [VK_LEFT, VK_RIGHT])))
          and (not ((ActiveControl is TEditPeriod) and (Msg.CharCode in [VK_LEFT, VK_RIGHT])))
          then
          begin
            // Tab to Next / Previous control
            PostMessage(Handle,wm_NextDlgCtl,Ord(Msg.CharCode in [VK_LEFT, VK_UP]),0);
          end;{if}
        end;{if}
      end;

      VK_F9 : begin
        // In grid, copy data from previous line, and tab to next control
        if (ActiveControl.Parent is TfNomLine) then
        begin
          iPrevLine := (ActiveControl.Parent as TfNomLine).Tag -1;
          if iPrevLine >= 0 then
          begin
            if ActiveControl.Tag = TAG_VAT_CODE then
            begin
              // Copy VAT Rate from previous line
              TComboBox(ActiveControl).ItemIndex := TComboBox(TfNomLine(lstLines[iPrevLine])
              .GetControlWithTag(ActiveControl.Tag)).ItemIndex;
            end else
            begin
              // Copy Text from previous line
              TEdit(ActiveControl).Text := TEdit(TfNomLine(lstLines[iPrevLine])
              .GetControlWithTag(ActiveControl.Tag)).Text;
            end;{if}

            TabToNextControl;

            // Tab to next control
{            FillChar(NewMsg, SizeOf(NewMsg), #0);
            NewMsg.CharCode := VK_RETURN;
            FormShortCut(NewMsg, Handled);}
          end;{if}
        end else
        begin
          // Read in Previous Entry

{  if ActiveControl.Tag > 0 then
  begin
    For iPos := 0 to nbPages.ControlCount -1 do
    begin
      if TWinControl(nbPages.Controls[iPos]).Tag = ActiveControl.Tag
      then begin}
          if ActiveControl.Tag > 0 then
          begin
            if Trim(aPreviousField[ActiveControl.Tag]) <> '' then
            begin
              TEdit(ActiveControl).Text := aPreviousField[ActiveControl.Tag];
              TabToNextControl;
            end;{if}
//            TEdit(ActiveControl).OnExit(ActiveControl);
          end;{if}
{      end;{if}
{    end;{for}
{  end;{if}

(*          case ActiveControl.Tag of
            F_BANK_ACCOUNT : begin
              // Read in Previous Bank Account
              edBankAccount.Text := aPreviousField[F_BANK_ACCOUNT];
              if trim(edBankAccount.Text) <> '' then
              begin
                edBankAccountExit(edBankAccount);
                TabToNextControl;
              end;{if}
            end;
            F_BANK_TO :;
            F_COSTCENTRE :;
            F_DEPARTMENT :;
            F_TRANSFER_VALUE :;
            F_DESCRIPTION :;
            F_CURRENCY_RATE :;
          end;{case}*)
        end;{if}
      end;
    end;{case}
  end;{if}
end;

procedure TfrmAddNomWizard.cmbCurrencyChange(Sender: TObject);
var
  iLine : integer;
begin
  if not bMultiCurrency then exit;

  // Set Currency Rate
  if cmbCurrency.ItemIndex >= 0
  then edCurrencyRate.Value := TCurrencyInfo(cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]).Rate;

  // Greys In/Out Controls
  EnableDisable;

  // New Currency - We must validate all GL Codes with this new currency
  with TCurrencyInfo(cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]) do
  begin
    // Validate Header GL Codes
    aValidation[edBankAccount.Tag].FieldOK := ValidateGLCode(edBankAccount, CurrencyNo
    , (oToolkit.SystemSetup as ISystemSetup5).ssEnforceGLClasses) <> nil;
    if (NomType = ttTransfer)
    then aValidation[edBankto.Tag].FieldOK := ValidateGLCode(edBankto, CurrencyNo
    , (oToolkit.SystemSetup as ISystemSetup5).ssEnforceGLClasses) <> nil;

    // Validate all lines
    if lstLines <> nil then
    begin
      For iLine := 0 to lstLines.count-1
      do TfNomLine(lstLines[iLine]).Validate;
    end;{if}
  end;{with}
end;

function TfrmAddNomWizard.edPYShowPeriod(Sender: TObject;
  const EPr: Byte): String;
begin
  // EL Function
  Result:=PPr_Pr(EPr);
end;

function TfrmAddNomWizard.edPYConvDate(Sender: TObject;
  const IDate: String; const Date2Pr: Boolean): String;
begin
  // EL Function
  Result:=ConvInpPr(IDate,Date2Pr,nil);
end;

procedure TfrmAddNomWizard.edDateExit(Sender: TObject);
var
  iPeriod, iYear : byte;
begin
  // EL Functions
  If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
  With edPY do
  Begin
    Date2Pr(MaskDateToStr8(edDate.Text), iPeriod, iYear, nil);
    InitPeriod(iPeriod, iYear,TRUE,TRUE);
  end;{with}
end;

procedure TfrmAddNomWizard.SendDefaultCC(Sender: TObject);
// Callback Proc that sends the default CC to the frame
begin
  if Trim(TEdit(Sender).Text) = ''
  then TEdit(Sender).Text := edCC.Text;
end;

procedure TfrmAddNomWizard.SendGLCurrency(Sender: TObject);
// Callback Proc that sends the current currency to the frame
begin
  if bMultiCurrency then TfNomLine(Sender).GLCurrency := TCurrencyInfo(cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]).CurrencyNo
  else TfNomLine(Sender).GLCurrency := 0;
end;

procedure TfrmAddNomWizard.SendDefaultDept(Sender: TObject);
// Callback Proc that sends the default dept to the frame
begin
  if Trim(TEdit(Sender).Text) = ''
  then TEdit(Sender).Text := edDept.Text;
end;

procedure TfrmAddNomWizard.edTransferValueExit(Sender: TObject);
begin
  // Validates the Value of the transfer (must be non-zero and not too big)
  aValidation[TWincontrol(Sender).Tag].FieldOK := (TNumEdit(Sender).Value > 0)
  and (TNumEdit(Sender).Value <= MAX_VALUE);

//  if aValidation[TWincontrol(Sender).Tag].FieldOK
//  then TEdit(aValidation[TWincontrol(Sender).Tag].FieldControl).Color := clWindow
//  else TEdit(aValidation[TWincontrol(Sender).Tag].FieldControl).Color := ERROR_COLOR;
  if aValidation[TWincontrol(Sender).Tag].FieldOK
  then
     Begin
        ColorEditBox(TEdit(aValidation[TWincontrol(Sender).Tag].FieldControl), clWhite);
        // CA 03/08/2012 ABSEXCH-12952 - Rebranding / UI Update
        TEdit(aValidation[TWincontrol(Sender).Tag].FieldControl).Font.Color := clNavy;
     End
  else ColorEditBox(TEdit(aValidation[TWincontrol(Sender).Tag].FieldControl), ERROR_COLOR);
end;

procedure TfrmAddNomWizard.ManufactureComTKTX(Sender: TObject);
// Callback Proc that sends an ITransaction object to the frame (for customisation)
begin
  // Populates a ComTK Transaction from the screen controls
  PopulateNom(TfNomLine(Sender).oComTKTX, FALSE);  
end;

procedure TfrmAddNomWizard.SetStepCaptions;
// Set the "Step X of X" captions at the top of all the pages
begin
  // No of steps determined by the type of transaction we are creating.
  case NomType of
    ttPayment, ttReceipt : begin
                             //SSK 27/07/2016 2016-R3 ABSEXCH-10038: necessary to display proper step caption
                             if cbRecurring.Checked then
                               iNoOfSteps := 5
                             else
                               iNoOfSteps := 4;
                             if iNoOfUdf = 0 then
                               iNoOfSteps := iNoOfSteps - 1;
                           end;
    ttTransfer : begin
                   //SSK 27/07/2016 2016-R3 ABSEXCH-10038: necessary to display proper step caption
                   if cbRecurring.Checked then
                     iNoOfSteps := 4
                   else
                     iNoOfSteps := 3;
                   if iNoOfUdf = 0 then
                     iNoOfSteps := iNoOfSteps - 1;
                 end;
    ttStandard : iNoOfSteps := 1;
  end;{case}

  // Set all captions to the same, you only see the current page's one anyway
  lStep1.Caption := 'Step ' + IntToStr(iStep) + ' of ' + IntToStr(iNoOfSteps);
  lStep2.Caption := lStep1.Caption;
  lStep3.Caption := lStep1.Caption;
  lStep4.Caption := lStep1.Caption;
  lStep5.Caption := lStep1.Caption;
end;

procedure TfrmAddNomWizard.cbRecurringClick(Sender: TObject);
begin
  // Changes the "Step x of y" captions
  SetStepCaptions;
end;

procedure TfrmAddNomWizard.FormShow(Sender: TObject);
begin
  // Centre Wizard
  Top := Round(((TForm(Owner).ClientHeight - 30{rough toolbar height} - 16{rough Status bar height}) - Height) / 2);
  Left := Round((TForm(Owner).ClientWidth - Width) / 2);

  bIgnoreExits := FALSE;
end;

procedure TfrmAddNomWizard.WMMyEnterExit(var msg:TMessage);
// Message Handler for the OnEnter/OnExit Messages we are posting
// Doing it this way stops problems when using customisation
var
  oNOM : ITransaction15;
  oNOMLine : ITransactionLine;
  iPos : integer;
begin
  bIgnoreExits := TRUE;
  if ActiveControl <> btnCancel then begin
    case msg.LParam of
      FIELD_ENTER : begin
        // Enter Field
        case msg.WParam of

          F_DESCRIPTION : begin // Customisation - Enter Description;

            // Populates a ComTK Transaction from the screen controls
            PopulateNOM(oNOM, TRUE);

            oNOM.thLongYourRef := edReference.Text;
            if ExecuteTXHook(oNOM, 1, wiTransaction, hiEnterDescription)
            then edReference.Text := oNOM.thLongYourRef;
            oNOM := nil;
          end;

          F_CURRENCY_RATE : begin // Customisation - Enter Currency Rate

            // Only applies to Daily Rate
            if oToolkit.SystemSetup.ssCurrencyRateType = rtDaily then
            begin
              // Populates a ComTK Transaction from the screen controls
              PopulateNOM(oNOM, TRUE);

              oNOM.thDailyRate := edCurrencyRate.Value;
              if ExecuteTXHook(oNOM, 1, wiTransaction, hiEnterDailyRate)
              then edCurrencyRate.Value := oNOM.thDailyRate;
              oNOM := nil;
            end;{if}
          end;

        end;{case}
      end;

      FIELD_EXIT : begin
        // Exit Field
        case msg.WParam of

          F_DESCRIPTION : begin // Customisation - Exit Description;

            // Populates a ComTK Transaction from the screen controls
            PopulateNOM(oNOM, TRUE);

            oNOM.thLongYourRef := edReference.Text;
            if ExecuteTXHook(oNOM, 1, wiTransaction, hiExitDescription)
            then edReference.Text := oNOM.thLongYourRef;
            oNOM := nil;
          end;

          F_COSTCENTRE : begin // Customisation - Exit Cost Centre;

            // Populates a ComTK Transaction from the screen controls
            PopulateNOM(oNOM, TRUE);

            oNOMLine := oNOM.thLines.Add;
            oNOMLine.tlCostCentre := edCC.Text;
            oNOMLine.Save;
            oNOMLine := nil;
            if ExecuteTXHook(oNOM, 1, wiTransLine, hiExitCostCentre)
            then edCC.Text := oNOM.thLines[1].tlCostCentre;
            oNOM := nil;

            // Validate Contacts of field
            ExitCCValidate(edCC);
          end;

          F_DEPARTMENT : begin // Customisation - Exit Department;

            // Populates a ComTK Transaction from the screen controls
            PopulateNOM(oNOM, TRUE);

            oNOMLine := oNOM.thLines.Add;
            oNOMLine.tlDepartment := edDept.Text;
            oNOMLine.Save;
            oNOMLine := nil;
            if ExecuteTXHook(oNOM, 1, wiTransLine, hiExitDepartment)
            then edDept.Text := oNOM.thLines[1].tlDepartment;
            oNOM := nil;

            // Validate Contacts of field
            ExitDeptValidate(edDept);
          end;

        end;{case}
      end;

      DELETE_LINE : begin
        // Delete Line
        if msg.WParam = 0 then
        begin
          // First Line, We can't really delete it, so we'll clear it
          TfNomLine(lstLines[msg.WParam]).ResetLine;
        end else
        begin
          // Delete Line
          TfNomLine(lstLines[msg.WParam]).Free;
          lstLines.Delete(msg.WParam);

          // Rejig List
          For iPos := msg.WParam to lstLines.Count-1 do
          begin
            TfNomLine(lstLines[iPos]).Tag := iPos;
            TfNomLine(lstLines[iPos]).Name := 'NomLine' + IntToStr(iPos + 1);
            TfNomLine(lstLines[iPos]).Top := TfNomLine(lstLines[iPos]).Top
            - TfNomLine(lstLines[iPos]).Height;
          end;{for}

          RecalcTotals(nil);
        end;{if}
      end;

    end;{case}
  end;{if}
  bIgnoreExits := FALSE;
end;

procedure TfrmAddNomWizard.WMMyChangeField(Var msg:TMessage);
begin
  edNomDesc.Text := TfNomLine(lstLines[msg.WParam]).edGLCode.Hint;
end;

procedure TfrmAddNomWizard.FieldEnter(Sender: TObject);
begin
  // Use a message to handle the field enter events,
  // as it stops problems when using customisation
  if not bIgnoreExits then PostMessage(Handle, WM_MyEnterExit, TWinControl(Sender).Tag, FIELD_ENTER);
end;

procedure TfrmAddNomWizard.edCurrencyRateExit(Sender: TObject);
begin
  aValidation[edCurrencyRate.Tag].FieldOK := (not edCurrencyRate.Visible)
  or (not edCurrencyRate.Enabled) or (not ZeroFloat(edCurrencyRate.Value)
  and (not (edCurrencyRate.Value > MAX_VALUE)));

//  if aValidation[TWincontrol(Sender).Tag].FieldOK
//  then TEdit(aValidation[TWincontrol(Sender).Tag].FieldControl).Color := clWindow
//  else TEdit(aValidation[TWincontrol(Sender).Tag].FieldControl).Color := ERROR_COLOR;
  if aValidation[TWincontrol(Sender).Tag].FieldOK
  then
     Begin
        ColorEditBox(TEdit(aValidation[TWincontrol(Sender).Tag].FieldControl), clWhite);
        // CA 03/08/2012 ABSEXCH-12952 - Rebranding / UI Update
        TEdit(aValidation[TWincontrol(Sender).Tag].FieldControl).Font.Color := clNavy;
     End
  else ColorEditBox(TEdit(aValidation[TWincontrol(Sender).Tag].FieldControl), ERROR_COLOR);
end;

procedure TfrmAddNomWizard.SetNomType(NomType: TNomType;
  bRecurring: boolean);
begin
  case NomType of
    ttPayment : rbPayment.Checked := TRUE;
    ttReceipt : rbReceipt.Checked := TRUE;
    ttTransfer : rbTransfer.Checked := TRUE;
  end;
  cbRecurring.Checked := bRecurring;
  rbStandard.Visible := FALSE;
  lStandard.Visible := FALSE;

  btnNextClick(btnNext);
end;

//SSK 27/07/2016 2016-R3 ABSEXCH-10038: show/hide UDFs and determine no of UDFs visible
procedure TfrmAddNomWizard.SetUDFields;
begin
  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L, UDF11L, UDF12L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F],
             cfNOMHeader);

  iNoOfUdf := NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F]);
end;

procedure TfrmAddNomWizard.THUD1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>btncancel) (*and (ActiveControl<>ClsN1Btn)*) then
  Begin
    Text8pt(Sender).ExecuteHookMsg;
  end;
end;

procedure TfrmAddNomWizard.THUD1FEntHookEvent(Sender: TObject);
begin
   ValidateUDFFields(Sender);
end;

procedure TfrmAddNomWizard.ValidateUDFFields(Sender: TObject);
Var
  CUUDEvent : Byte;
  Result    : LongInt;
  ExLocal   : TdExLocal;
  oNOM      : ITransaction15;
  sHead, 
  sLine     : WideString;
begin

  ExLocal.Create;

  // Populates a ComTK Transaction from the screen controls
  PopulateNOM(oNOM, TRUE);

  // Gets a string containing the Inv record for this ITransaction Object
  with oNOM as IToolkitRecord do
  begin
    sHead := ConvertData(GetData);
  end;{with}

  // Moves the string InvRec into an actual InvRec record
  if Length(sHead) > 0 then
    Move(sHead[1], ExLocal.LInv, SizeOf(ExLocal.LInv));


  CUUDEvent := 0;
  {$IFDEF CU}
  If (Sender is Text8Pt)then
  begin
    With (Sender as Text8pt) do
    Begin
      If (Not ReadOnly) then
      Begin
        If (Sender=THUD1F) then
        Begin
          ExLocal.LInv.DocUser1:=Text;
          CUUDEvent:=1;
        end
        else
          If (Sender=THUD2F) then
          Begin
            ExLocal.LInv.DocUser2:=Text;
            CUUDEvent:=2;
          end
          else
            If (Sender=THUD3F) then
            Begin
              ExLocal.LInv.DocUser3:=Text;
              CUUDEvent:=3;
            end
            else
              If (Sender=THUD4F) then
              Begin
                ExLocal.LInv.DocUser4:=Text;
                CUUDEvent:=4;
              end
              else
                If (Sender=THUD5F) then
                Begin
                  ExLocal.LInv.DocUser5:=Text;
                  CUUDEvent:=(211 - 60);
                end
                else
                  If (Sender=THUD6F) then
                  Begin
                    ExLocal.LInv.DocUser6:=Text;
                    CUUDEvent:=(212 - 60);
                  end
                  else
                    If (Sender=THUD7F) then
                    Begin
                      ExLocal.LInv.DocUser7:=Text;
                      CUUDEvent:=(213 - 60);
                    end
                    else
                      If (Sender=THUD8F) then
                      Begin
                        ExLocal.LInv.DocUser8:=Text;
                        CUUDEvent:=(214 - 60);
                      end
                      else
                        If (Sender=THUD9F) then
                        Begin
                          ExLocal.LInv.DocUser9:=Text;
                          CUUDEvent:=(215 - 60);
                        end
                        else
                          If (Sender=THUD10F) then
                          Begin
                            ExLocal.LInv.DocUser10:=Text;
                            CUUDEvent:=(216 - 60);
                          end
                          else
                            If (Sender=THUD11F) then
                            Begin
                              ExLocal.LInv.thUserField11:=Text;
                              CUUDEvent:=(217 - 60);
                            end
                            else
                              If (Sender=THUD12F) then
                              Begin
                                ExLocal.LInv.thUserField12:=Text;
                                CUUDEvent:=(218 - 60);
                              end;


        Result := IntExitHook(2000,60+CUUDEvent,-1,ExLocal);

        If (Result=0) then
          SetFocus
        else
          With ExLocal do
          If (Result=1) then
          Begin
            Case CUUDEvent of
              1  :  Text:=LInv.DocUser1;
              2  :  Text:=LInv.DocUser2;
              3  :  Text:=LInv.DocUser3;
              4  :  Text:=LInv.DocUser4;
              (211 - 60) :  Text:=LInv.DocUser5;
              (212 - 60) :  Text:=LInv.DocUser6;
              (213 - 60) :  Text:=LInv.DocUser7;
              (214 - 60) :  Text:=LInv.DocUser8;
              (215 - 60) :  Text:=LInv.DocUser9;
              (216 - 60) :  Text:=LInv.DocUser10;
              (217 - 60) :  Text:=LInv.thUserField11;
              (218 - 60) :  Text:=LInv.thUserField12;

              120  :  Text:=LInv.YourRef;
            end; {Case..}
          end;
      end;
    end; {With..}
  end;
  {$ELSE}
  CUUDEvent:=0;

  {$ENDIF}

  // Clear up
  ExLocal.Destroy;
end;

procedure TfrmAddNomWizard.SetFocusToVisibleUDF(const UDFEdits: array of Text8Pt);

var
  iLine : integer;
  HighestVisible : TWinControl;
  iCurrentHighTabOrder : integer;
begin

  iCurrentHighTabOrder := -1;

  for iLine := Low(UDFEdits) to High(UDFEdits) do
  begin
    if (UDFEdits[iLine].TabOrder > iCurrentHighTabOrder) and (UDFEdits[iLine].Visible) then
    begin
      HighestVisible := UDFEdits[iLine];
      break;
    end;
  end;

  if Assigned(HighestVisible) then
    ActiveControl := HighestVisible;
end;

{SS:21/12/2016:ABSEXCH-12255
-Validate header total,If varinace found in header total then add a transaction line to adjust the variance.}
procedure TfrmAddNomWizard.ValidateNominalHeaderTotal(aNOM : ITransaction15);
var
  lVariance : Double;
begin
  // Check total net value of nominal header is zero or not.
  aNom.UpdateTotals;

  {SS:06/04/2016 2017-R1:ABSEXCH-18508:Line totals do not balance with transaction total error when adding NOMs with VAT through Add NOM wizard.
   - Before adding Currency Variance BalanceLine, VAT needs to be calculated with the Netvalue.}
  lVariance := oToolkit.Functions.entRound(aNom.thNetValue + aNom.thTotalVAT, 2);
  if lVariance  <> 0.00 then
    // Add a transaction line to adjust 0.01 variance.
    AddCurrVarianceBalanceLine(aNOM,lVariance);
end;


{SS:21/12/2016:ABSEXCH-12255
-Add transaction line with varinace value and base currency.}
procedure TfrmAddNomWizard.AddCurrVarianceBalanceLine(aNOM : ITransaction15; aVariance : Real);
var
  lNOMLine : ITransactionLine;
  sLastDesc : string;
begin 
  lNOMLine := aNOM.thLines.Add;
  
  try
    lNOMLine.ImportDefaults;

     with oToolkit.SystemSetup.ssCurrency[lNOMLine.tlCurrency] Do
     begin
      lNOMLine.tlCompanyRate := scCompanyRate;
      lNOMLine.tlDailyRate := scDailyRate;
     end; // With oToolkit.SystemSetup.ssCurrency[oLine.tlCurrency]

    //Suspended GL code = 990
    lNOMLine.tlGLCode := Syss.NomCtrlCodes[UnRCurrVar];

    sLastDesc := Trim(lNOMLine.tlDescr);

    if Trim(sLastDesc) = '' then
      lNOMLine.tlDescr := 'Auto-Balance Variance'
    else
      lNOMLine.tlDescr := 'Auto ' + sLastDesc;

    lNOMLine.tlNetValue := AVariance *-1;
    //lNOMLine.tlStockCode := edPayInRef.Text;

    lNOMLine.tlCostCentre := edCC.Text;
    lNOMLine.tlDepartment := edDept.Text;

    lNOMLine.Save;
  finally
    lNOMLine := nil;
  end;
end;


initialization
  frmAddNomWizard := nil;


end.

