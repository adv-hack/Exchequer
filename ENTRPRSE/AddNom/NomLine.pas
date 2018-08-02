unit NomLine;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , Enterprise04_TLB, AddNomProc, StdCtrls, TEditVal, Mask, ExtCtrls, NumEdit,
  Menus;

const
  TAG_DESC = 1;
  TAG_GL_CODE = 2;
  TAG_CC = 3;
  TAG_DEPT = 4;
  TAG_NET_AMOUNT = 5;
  TAG_VAT_CODE = 6;
  TAG_VAT_AMOUNT = 7;
  TL_NO_OF_FIELDS_TO_VALIDATE = 7;

  DELETE_LINE = 2;
  WM_MyEnterExit = WM_USER + 1001;
  WM_MyChangeField = WM_USER + 1002;

type
  TfNomLine = class(TFrame)
    edDesc: TEdit;
    edGLCode: TEdit;
    edCC: TEdit;
    edDept: TEdit;
    Shape1: TShape;
    Shape2: TShape;
    _CC: TShape;
    _Dept: TShape;
    Shape5: TShape;
    Shape6: TShape;
    lGrossAmount: TLabel;
    cmbVATCode: TComboBox;
    edNetAmount: TNumEdit;
    edVATAmount: TNumEdit;
    pmLine: TPopupMenu;
    DeleteLine1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    N1: TMenuItem;
    Undo1: TMenuItem;
    N2: TMenuItem;
    procedure EditEnter(Sender: TObject);
    procedure edGLCodeExit(Sender: TObject);
    procedure edFieldExit(Sender: TObject);
    procedure edCCEnter(Sender: TObject);
    procedure edDeptEnter(Sender: TObject);
    procedure AmountChanged(Sender: TObject);
    procedure cmbVATCodeExit(Sender: TObject);
    procedure edNetAmountChange(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure pmLinePopup(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure DeleteLine1Click(Sender: TObject);
  private
    iNoOfDecs : integer;
    PreviousControl : TWinControl;
    OwnerForm : TForm;
    bVATCodeManuallyChanged, bVATInclusiveCalculated : boolean;
    bIgnoreExits : boolean;
    FOrgNetAmount : real;
    procedure CalculateLine(bUpdateVATAmount : boolean);
    Procedure WMMyEnterExit(Var msg:TMessage); message WM_MyEnterExit;
  public
    bVATInclusive, Tabbed : boolean;
    OnGetGLCurrency, OnGetDefaultCC, OnGetDefaultDept, OnAddNewLine
    , OnRecalcTotals, OnManufactureComTKTX : TNotifyEvent;
    aLineValidation : array [1..TL_NO_OF_FIELDS_TO_VALIDATE] of ValidationRec;
    GLCurrency : integer;
    InclusiveVATCode : char;
    rOrigIncValue : real;
    oComTKTX : ITransaction15;
    procedure Initialise;
    procedure CursorRight;
    procedure CursorLeft;
    procedure FocusControlWithTag(iTag : integer);
    function GetControlWithTag(iTag: integer) : TWinControl;
    function Validate : TWinControl;
    function BlankLine : boolean;
    Procedure ResetLine;
  end;

implementation
uses
  ETMiscU, MathUtil, GfxUtil, StrUtil, uExDatasets, IncVATRate, TKPickList04
  , CustWinU, AddNomWizCustom;

{$R *.dfm}

{ TfNomLine }

procedure TfNomLine.CursorRight;
// Decides what to do when cursor right is pressed on a field
var
  CurrActiveControl : TWinControl;
  bPostMessage : boolean;
begin
  CurrActiveControl := OwnerForm.ActiveControl;

  if CurrActiveControl <> edVATAmount then  // Ignore Last field on line
  begin
    bPostMessage := FALSE;

    if (CurrActiveControl is TCustomEdit) then
    begin
      // if cursor is at the end of the current edit field, Tab to next control
      if ((CurrActiveControl as TCustomEdit).SelStart
      + (CurrActiveControl as TCustomEdit).SelLength)
      = length((CurrActiveControl as TCustomEdit).text)
      then bPostMessage := TRUE;
    end else
    begin
      // Allow combos to have their own behaviour
      if (CurrActiveControl is TComboBox)
      then bPostMessage := FALSE
      else  bPostMessage := TRUE;
    end;{if}

    if bPostMessage
    then PostMessage(OwnerForm.Handle,wm_NextDlgCtl,0,0); // Tab to next control
  end;{if}
end;

procedure TfNomLine.CursorLeft;
var
  CurrActiveControl : TWinControl;
  bPostMessage : boolean;
begin
  CurrActiveControl := OwnerForm.ActiveControl;

  if CurrActiveControl <> edDesc then  // Ignore first field on line
  begin
    bPostMessage := FALSE;

    if (CurrActiveControl is TCustomEdit) then
    begin
      // if the cursor is at the beginning of the edit field, Tab to the previous control
      if ((CurrActiveControl as TCustomEdit).SelStart = 0)
      then bPostMessage := TRUE;
    end else
    begin
      // Allow combos to have their own behaviour
      if (CurrActiveControl is TComboBox)
      then bPostMessage := FALSE
      else  bPostMessage := TRUE;
    end;{if}

    if bPostMessage
    then PostMessage(OwnerForm.Handle,wm_NextDlgCtl,1,0);  // Tab to the previous control
  end;{if}
end;

procedure TfNomLine.EditEnter(Sender: TObject);
begin
  // Use a message to handle the field enter events,
  // as it stops problems when using customisation
  if not bIgnoreExits then PostMessage(Handle, WM_MyEnterExit,TWinControl(Sender).Tag, 1);

  if not Tabbed then
  begin
    if (Sender is TCustomEdit) then
    begin
      if TWinControl(Sender).TabOrder > PreviousControl.TabOrder then
      begin
        // Previous control is BEFORE the active control
        // put cursor at begining of edit box
        (Sender as TCustomEdit).SelStart := 0;
      end else
      begin
        // Previous control is AFTER the active control
        // put cursor at the end of edit box
        (Sender as TCustomEdit).SelStart := Length((Sender as TCustomEdit).text);
      end;
      (Sender as TCustomEdit).SelLength := 0;    // don't select any text
    end;{if}
  end;{if}

  PreviousControl := TWinControl(Sender); // keep track of previous control
//  Tabbed := FALSE;  // Reset Tabbed property
end;

procedure TfNomLine.Initialise;
// Alway call this after creating a frame - there is no OnCreate event
var
  iPos : integer;
begin
  bVATCodeManuallyChanged := TRUE;
  bIgnoreExits := TRUE;
  iNoOfDecs := 2;  // values on noms are always to 2 deimal places

  // Set defaults
  PreviousControl := edDesc;
  Tabbed := TRUE;
  edNetAmount.Value := 0;
  edVATAmount.Value := 0;
  lGrossAmount.Caption := MoneyToStr(0, iNoOfDecs);
  GLCurrency := glccyANY_CURRENCY;
  OwnerForm := (Self.Owner as TForm);
  bVATInclusive := FALSE;
  bVATInclusiveCalculated := FALSE;
  rOrigIncValue := 0;
  InclusiveVATCode := #0;

  // initialise validation
  For iPos := 1 to TL_NO_OF_FIELDS_TO_VALIDATE do
  begin
    // Only Set FieldOK to FALSE if it is a field to be validated
    aLineValidation[iPos].FieldOK := iPos in [TAG_DESC, TAG_VAT_CODE, TAG_NET_AMOUNT, TAG_VAT_AMOUNT];

    case iPos of
      TAG_DESC : aLineValidation[iPos].Description := 'Narrative';
      TAG_GL_CODE : aLineValidation[iPos].Description := 'Nominal';
      TAG_CC : aLineValidation[iPos].Description := 'Cost Centre';
      TAG_DEPT : aLineValidation[iPos].Description := 'Department';
      TAG_VAT_CODE : aLineValidation[iPos].Description := 'VAT Code';
      TAG_NET_AMOUNT : aLineValidation[iPos].Description := 'Net Amount';
      TAG_VAT_AMOUNT : aLineValidation[iPos].Description := 'VAT Amount';
    end;
  end;{for}

  // Disable CC / Dept if they are switched off
  edCC.Enabled := oToolkit.SystemSetup.ssUseCCDept;
  edDept.Enabled := edCC.Enabled;
  if not edCC.Enabled then _CC.Pen.Color := LightenColor(clSilver, 50);
  if not edDept.Enabled then _Dept.Pen.Color := LightenColor(clSilver, 50);

  bIgnoreExits := FALSE;
end;

procedure TfNomLine.FocusControlWithTag(iTag: integer);
// Find control with tag, and make it active
var
  iPos : integer;
begin
  For iPos := 0 to ControlCount -1 do
  begin
    if (iTag = TWinControl(Controls[iPos]).Tag) and TWinControl(Controls[iPos]).Enabled 
    then OwnerForm.ActiveControl := TWinControl(Controls[iPos]);
  end;{for}
end;

function TfNomLine.GetControlWithTag(iTag: integer) : TWinControl;
// Find control with tag, and returns the control
var
  iPos : integer;
begin
  For iPos := 0 to ControlCount -1 do
  begin
    if iTag = TWinControl(Controls[iPos]).Tag
    then Result := TWinControl(Controls[iPos]);
  end;{for}
end;

procedure TfNomLine.CalculateLine(bUpdateVATAmount : boolean);
var
  iPos : integer;
//  rVAT : real;
  rVAT : double; // NF: 16/01/2008
  rVATRateLine : double; // NF: 16/01/2008
begin
  if cmbVatCode.Itemindex >= 0 then
  begin
    // Calculate Values
    if bUpdateVATAmount then
    begin
      if bVATInclusive then
      begin
        if not bVATInclusiveCalculated
        then edVatAmount.Value := Round_Up(rOrigIncValue - edNetAmount.Value, 2);

        //Set to TRUE, so it only does this once;
        bVATInclusiveCalculated := TRUE;
      end else
      begin
//        rVAT := edNetAmount.Value * TVATInfo(cmbVatCode.Items.Objects[cmbVatCode.Itemindex]).rRate;
//        edVATAmount.Value := Round_Up(rVAT, 2);

        // NF: 16/01/2008
        // Fix for 2177.40 standard VAT - VAT was coming out as 381.04, should be 381.05
        rVATRateLine := TrueReal(TVATInfo(cmbVatCode.Items.Objects[cmbVatCode.Itemindex]).rRate,10);
        rVAT := Round_Up(edNetAmount.Value * rVATRateLine, 2);
        edVATAmount.Value := Round_Up(rVAT, 2);
      end;{if}

      if cmbVATCode.ItemIndex > 0 then
      begin
        // Customisation - VAT Calculation
        OnManufactureComTKTX(Self);
        if ExecuteTXHook(oComTKTX, Tag+1, wiMisc+1, hiVATCalculation) then
        begin
          For iPos := 0 to cmbVATCode.Items.Count-1 do
          begin
            if TVATInfo(cmbVatCode.Items.Objects[iPos]).cCode
            = oComTKTX.thLines[Tag+1].tlVATCode then
            begin
              bVATCodeManuallyChanged := FALSE;
              cmbVatCode.ItemIndex := iPos;
              bVATCodeManuallyChanged := TRUE;
              break;
            end;
          end;{for}
          edVATAmount.Value := oComTKTX.thLines[Tag+1].tlVATAmount;
          rOrigIncValue := (oComTKTX.thLines[Tag+1] as ITransactionLine3).tlVATIncValue;
        end;
        oComTKTX := nil;
      end;{if}
    end;{if}

    lGrossAmount.Caption := MoneyToStr(edNetAmount.Value + edVatAmount.Value, iNoOfDecs);

    // Calculate Totals
    OnRecalcTotals(self);
  end;{if}
end;

procedure TfNomLine.edGLCodeExit(Sender: TObject);
var
  oGL : IGeneralLedger;
  iGLCode : integer;
begin

  // Get Currency, for validating GL Codes
  OnGetGLCurrency(self);

  oGL := ValidateGLCode(TEdit(Sender), GLCurrency, FALSE);
  if oGL = nil then
  begin
    if TWinControl(OwnerForm.ActiveControl).Tag >= 0 then  // Only popup list if we are continuing
    begin
      with TfrmTKPickList.CreateWith(self, oToolkit) do begin

        // Set Form Properties
        mlList.Columns[0].DataType := dtInteger;
        plType := plGLCode;
        iGLCode := StrToIntDef(edGLCode.Text,0);
        iGLCurrency := GLCurrency;
        bRestrictList := TRUE;
        bAutoSelectIfOnlyOne := TRUE;
        bShowMessageIfEmpty := TRUE;

        if (iGLCode = 0) and (edGLCode.Text <> '0') then
        begin
          // Search for GL by Description
          sFind := edGLCode.Text;
          iSearchCol := 1;
        end else
        begin
          // Search for GL by Number
          sFind := mlList.FullNomKey(iGLCode);
          iSearchCol := 0;
        end;{if}
        mlList.Columns[1].IndexNo := 1;

        // Show Popup List
        if showmodal = mrOK then begin
          // GL Selected
          oGL := ctkDataSet.GetRecord as IGeneralLedger;
          edGLCode.Text := IntToStr(oGL.glCode);
        end;
        release;

        // Validate Selected GL
        oGL := ValidateGLCode(TEdit(Sender), GLCurrency, FALSE);

      end;{with}
    end;{if}
  end;{if}

  // Set Validation Status
  aLineValidation[TWincontrol(Sender).Tag].FieldOK := oGL <> nil;
end;

procedure TfNomLine.edFieldExit(Sender: TObject);
begin
  // Use a message to handle the field exit events,
  // as it stops problems when using customisation
  if not bIgnoreExits then PostMessage(Handle, WM_MyEnterExit, TWinControl(Sender).Tag, 0);
end;

procedure TfNomLine.edCCEnter(Sender: TObject);
begin
  EditEnter(Sender);
  OnGetDefaultCC(Sender);
end;

procedure TfNomLine.edDeptEnter(Sender: TObject);
begin
  EditEnter(Sender);
  OnGetDefaultDept(Sender);
end;

function TfNomLine.Validate : TWinControl;
var
  iPos, iField : integer;
begin
  if BlankLine then
  begin
    // Skip Validation of Blank Lines
  end else
  begin
    // Validate All Fields
    OnGetGLCurrency(self);
    aLineValidation[edGLCode.Tag].FieldOK := ValidateGLCode(edGLCode, GLCurrency, FALSE) <> nil;

    if edCC.Enabled then aLineValidation[edCC.Tag].FieldOK := ValidateCostCentre(edCC) <> nil
    else aLineValidation[edCC.Tag].FieldOK := TRUE;

    if edDept.Enabled then aLineValidation[edDept.Tag].FieldOK := ValidateDepartment(edDept) <> nil
    else aLineValidation[edDept.Tag].FieldOK := TRUE;

    Result := nil;

    // Check all fields to see if they have passed their validation
    For iField := 1 to TL_NO_OF_FIELDS_TO_VALIDATE do
    begin
      if not aLineValidation[iField].FieldOK then
      begin
        // Find control
        For iPos := 0 to ControlCount -1 do
        begin
          if iField = TWinControl(Controls[iPos]).Tag
          then begin
            // Return a ref to the Control that failed the validation
            Result := TWinControl(Controls[iPos]);
            Exit;
          end;{if}
        end;{for}
      end;{if}
    end;{for}
  end;{if}
end;

function TfNomLine.BlankLine: boolean;
// Checks to see if the line is said to be a "blank line"
begin
  Result := (ZeroFloat(edNetAmount.Value)) and (ZeroFloat(edVATAmount.Value));
end;

procedure TfNomLine.AmountChanged(Sender: TObject);
begin
  if (TWinControl(Sender).tag = TAG_VAT_CODE) and bVATCodeManuallyChanged
  then InclusiveVATCode := #0; // Resets Inclusive VAT Code, so you can pick a new one.

  if cmbVatCode.Itemindex >= 0 then
  begin
    if TVATInfo(cmbVatCode.Items.Objects[cmbVatCode.Itemindex]).cCode <> 'I' // SSK 19/06/2017 2017-R1 ABSEXCH-13530
    then bVATInclusive := FALSE;
  end;{if}

  CalculateLine(TWinControl(Sender).Tag <> TAG_VAT_AMOUNT);
  edVATAmount.Enabled := cmbVATCode.ItemIndex > 0;
end;

procedure TfNomLine.cmbVATCodeExit(Sender: TObject);

  // NF: 09/01/2008 - Fixed problem with Manual VAT in v6
  // We have modified the user interface, so that storing transactions with a VAT code of M is not possible (unless it is a VAT inclusive line).

(*
  Function GetIncVatRate(Manual : boolean) : real;
  begin{GetIncVatRate}
   with TfrmIncVatRate.Create(self) do
    begin
      // Copy the VAT Codes from the VAT Codes on the line
      cmbIncVATCode.Items := cmbVATCode.Items;

      bManual := Manual;

      // Delete items (N/A, inclusive and manual)
      cmbIncVATCode.Items.Delete(0);
      cmbIncVATCode.Items.Delete(cmbIncVATCode.Items.Count-1);
      cmbIncVATCode.Items.Delete(cmbIncVATCode.Items.Count-1);

      // select first vat code
      cmbIncVATCode.ItemIndex := 0;

      // Ask for VAT Rate to use for Inclusive VAT
      Showmodal;

      InclusiveVATCode := TVATInfo(cmbIncVATCode.Items.Objects[cmbIncVATCode.ItemIndex]).cCode;
      Result := TVATInfo(cmbIncVATCode.Items.Objects[cmbIncVATCode.ItemIndex]).rRate;

    end;{with}
  end;{GetIncVatRate}
*)
  Function GetIncVatRate(Manual : boolean; var iIndex : integer) : real;
  begin{GetIncVatRate}
   with TfrmIncVatRate.Create(self) do
    begin
      // Copy the VAT Codes from the VAT Codes on the line
      cmbIncVATCode.Items := cmbVATCode.Items;

      bManual := Manual;

      // Delete items (N/A, inclusive and manual)
      cmbIncVATCode.Items.Delete(0);
      cmbIncVATCode.Items.Delete(cmbIncVATCode.Items.Count-1);
      cmbIncVATCode.Items.Delete(cmbIncVATCode.Items.Count-1);

      // select first vat code
      cmbIncVATCode.ItemIndex := 0;

      // Ask for VAT Rate to use for Inclusive VAT
      Showmodal;

      InclusiveVATCode := TVATInfo(cmbIncVATCode.Items.Objects[cmbIncVATCode.ItemIndex]).cCode;
      Result := TVATInfo(cmbIncVATCode.Items.Objects[cmbIncVATCode.ItemIndex]).rRate;
      iIndex := cmbIncVATCode.ItemIndex;

    end;{with}
  end;{GetIncVatRate}

var
  rIncVatRate : real;
  iIndex : integer; // NF: 09/01/2008
  bManual : boolean; // NF: 09/01/2008
  mbRet : Word;   // SSK 20/06/2017 2017-R2 ABSEXCH-13530

begin

  bManual := FALSE; // NF: 09/01/2008

  if (TVATInfo(cmbVatCode.Items.Objects[cmbVatCode.Itemindex]).cCode in ['I', 'M']) then
  begin
    if (InclusiveVATCode = #0) then
    begin
      // Oh my god, it's inclusive VAT
      bVATInclusive := TRUE;
      bVATInclusiveCalculated := FALSE;

      // SSK 20/06/2017 2017-R2 ABSEXCH-13530: bring up the message for vatcode 'I'
      mbRet := MessageDlg('Please ensure the Net Amount is correct before applying' + #13 +
        'an update to the Inclusive VAT(I) code', mtWarning, [mbOk, mbCancel], 0);

      if (mbRet = mrOk) then
      begin

        // Set manual vat rate, and set manual vat
        rIncVatRate := GetIncVatRate((TVATInfo(cmbVatCode.Items.Objects[cmbVatCode.Itemindex]).cCode = 'M'), iIndex);
        bManual := (TVATInfo(cmbVatCode.Items.Objects[cmbVatCode.Itemindex]).cCode = 'M');

        if bManual then
        begin
          // Manual VAT
          cmbVatCode.ItemIndex := iIndex + 1; // Set Standard Rate VAT
          InclusiveVATCode := #0;
          bVATCodeManuallyChanged := FALSE;
        end
        else
        begin
          // Inclusive VAT
          TVATInfo(cmbVatCode.Items.Objects[cmbVatCode.Items.count-1]).rRate := rIncVatRate;
          bVATCodeManuallyChanged := FALSE;
          cmbVatCode.ItemIndex := cmbVatCode.Items.count-1;

          // Calculate new value
          rOrigIncValue := edNetAmount.Value;
          edNetAmount.Value := Round_Up(edNetAmount.Value * (1 / (1 + rIncVatRate)),2);
        end;{if}

        AmountChanged(Sender);
        bVATCodeManuallyChanged := TRUE;

      end
      else
      begin
        cmbVatCode.ItemIndex := 0;
        cmbVatCode.SetFocus;
      end;

    end;
  end
  else
  begin
    InclusiveVATCode := #0;
  end;{if}

  if TVATInfo(cmbVatCode.Items.Objects[cmbVatCode.Itemindex]).cCode <>  'I'   // SSK 19/06/2017 2017-R1 ABSEXCH-13530
  then bVATInclusive := FALSE;

  // NF: 09/01/2008 - Fixed problem with Manual VAT in v6
  // We have modified the user interface, so that storing transactions with a VAT code of M is not possible (unless it is a VAT inclusive line).

  // Use a message to handle the field exit events,
  // as it stops problems when using customisation

//  if not bIgnoreExits then PostMessage(Handle, WM_MyEnterExit, TWinControl(Sender).Tag, 0);

  if not bIgnoreExits then
  begin
    PostMessage(Handle, WM_MyEnterExit, TWinControl(Sender).Tag, 0);
    if bManual then
    begin
      PostMessage(OwnerForm.Handle,wm_NextDlgCtl,1,0); // Tab to previous control
    end;{if}
  end;{if}
end;

procedure TfNomLine.edNetAmountChange(Sender: TObject);
begin
  AmountChanged(Sender);
end;

procedure TfNomLine.WMMyEnterExit(var msg: TMessage);
// Message Handler for the OnEnter/OnExit Messages we are posting
// Doing it this way stops problems when using customisation
var
  oDept : ICCDept;
  oCC : ICCDept;
  oNom : ITransaction;   
begin
  // Send Change Field message. This is so we can show the GL Name on the main form
  PostMessage(OwnerForm.Handle,WM_MyChangeField,Self.Tag,0);

  bIgnoreExits := TRUE;  // Ignore exits whilst we are handling the current event

  if msg.LParam = 1 then
  begin
    // On Enter events
    case msg.WParam of

      // Enter Net Value
      TAG_NET_AMOUNT : begin
        // Customisation - Enter Net Value;
        OnManufactureComTKTX(Self);
        ExecuteTXHook(oComTKTX, Tag+1, wiTransLine, hiEnterNetValue);
        oComTKTX := nil;
      end;

    end;{case}
  end else
  begin
    // On Exit events
    case msg.WParam of
      // Exit CC
      TAG_CC : begin
        // Customisation - Exit CostCentre;
        OnManufactureComTKTX(Self);
        if ExecuteTXHook(oComTKTX, Tag+1, wiTransLine, hiExitCostCentre)
        then edCC.Text := oComTKTX.thLines[Tag+1].tlCostCentre;
        oComTKTX := nil;

        // Validate CC
        oCC := ValidateCostCentre(edCC);
        if oCC = nil then
        begin
          if TWinControl(OwnerForm.ActiveControl).Tag >= 0 then  // Only Popup list, when we are continuing
          begin
            with TfrmTKPickList.CreateWith(self, oToolkit) do
            begin

              // Set Form Defaults
              plType := plCC;
              sFind := edCC.Text;
              iSearchCol := 0;
              mlList.Columns[1].IndexNo := 1;
              bRestrictList := TRUE;
              bAutoSelectIfOnlyOne := TRUE;
              bShowMessageIfEmpty := TRUE;

              // Show List
              if showmodal = mrOK then
              begin
                // Get Selected CC
                oCC := ctkDataSet.GetRecord as ICCDept;
                edCC.Text := oCC.cdCode;
              end;{if}
              release;

              // Validate Selected CC
              oCC := ValidateCostCentre(edCC);

            end;{with}
          end;{if}
        end;{if}

        // Set Validation Status
        aLineValidation[edCC.Tag].FieldOK := oCC <> nil;
      end;

      // Exit Dept
      TAG_DEPT : begin
        // Customisation - Exit Department;
        OnManufactureComTKTX(Self);
        if ExecuteTXHook(oComTKTX, Tag+1, wiTransLine, hiExitDepartment)
        then edDept.Text := oComTKTX.thLines[Tag+1].tlDepartment;
        oComTKTX := nil;

        oDept := ValidateDepartment(edDept);
        if oDept = nil then
        begin
          if TWinControl(OwnerForm.ActiveControl).Tag >= 0 then // Only popup list if we are continuing
          begin
            with TfrmTKPickList.CreateWith(self, oToolkit) do
            begin

              // Set Form Properties
              plType := plDept;
              sFind := edDept.Text;
              iSearchCol := 0;
              mlList.Columns[1].IndexNo := 1;
              bRestrictList := TRUE;
              bAutoSelectIfOnlyOne := TRUE;
              bShowMessageIfEmpty := TRUE;

              // Show List
              if showmodal = mrOK then
              begin
                // Get Selected Dept
                oDept := ctkDataSet.GetRecord as ICCDept;
                edDept.Text := oDept.cdCode;
              end;{if}
              release;

              // Validate Selected Dept
              oDept := ValidateDepartment(edDept);
            end;{with}
          end;{if}
        end;{if}

        // Set Validation Status
        aLineValidation[edDept.Tag].FieldOK := oDept <> nil;
      end;

      // Exit Net Value
      TAG_NET_AMOUNT : begin
        // Customisation - Exit Net Value;
        OnManufactureComTKTX(Self);
        if ExecuteTXHook(oComTKTX, Tag+1, wiTransLine, hiExitNetValue) then
        begin
          edNetAmount.Value := oComTKTX.thLines[Tag+1].tlNetValue;
        end;{if}
        oComTKTX := nil;

        // Make sure the line hasn't exceeded the maximum value
        aLineValidation[TAG_NET_AMOUNT].FieldOK := edNetAmount.Value <= MAX_VALUE;
        if aLineValidation[TAG_NET_AMOUNT].FieldOK
//        then edNetAmount.Color := clWindow
//        else edNetAmount.Color := ERROR_COLOR; // Colour Field to error colour
        then ColorEditBox(edNetAmount, clWindow)
        else ColorEditBox(edNetAmount, ERROR_COLOR); // Colour Field to error colour


      end;

      TAG_VAT_CODE : begin
        // Add new line when tabbing off of Net Amount
        if Tabbed then
        begin
          if TWinControl(OwnerForm.ActiveControl).Tag <> TAG_NET_AMOUNT
          then OnAddNewLine(self);
        end;{if}
      end;
    end;{case}
  end;{if}

  bIgnoreExits := FALSE;
  Tabbed := FALSE;  // Reset Tabbed property
end;

procedure TfNomLine.Cut1Click(Sender: TObject);
begin
  (OwnerForm.ActiveControl as TEdit).CutToClipboard;
end;

procedure TfNomLine.pmLinePopup(Sender: TObject);
begin
  Cut1.Enabled := OwnerForm.ActiveControl is TEdit;
  Copy1.Enabled := OwnerForm.ActiveControl is TEdit;
  Paste1.Enabled := OwnerForm.ActiveControl is TEdit;
  Delete1.Enabled := OwnerForm.ActiveControl is TEdit;
  Undo1.Enabled := OwnerForm.ActiveControl is TEdit;
end;

procedure TfNomLine.Undo1Click(Sender: TObject);
begin
  (OwnerForm.ActiveControl as TEdit).Undo;
end;

procedure TfNomLine.Copy1Click(Sender: TObject);
begin
  (OwnerForm.ActiveControl as TEdit).CopyToClipboard;
end;

procedure TfNomLine.Paste1Click(Sender: TObject);
begin
  (OwnerForm.ActiveControl as TEdit).PasteFromClipboard;
end;

procedure TfNomLine.Delete1Click(Sender: TObject);
begin
  (OwnerForm.ActiveControl as TEdit).ClearSelection;
end;

procedure TfNomLine.DeleteLine1Click(Sender: TObject);
begin
  if not bIgnoreExits then PostMessage(OwnerForm.Handle, WM_MyEnterExit, Self.Tag, DELETE_LINE);
end;

procedure TfNomLine.ResetLine;
begin
  edDesc.text := '';
  edGLCode.text := '';
  edCC.text := '';
  edDept.text := '';
  edNetAmount.text := '';
  cmbVATCode.ItemIndex := 0;
  edVATAmount.Value := 0;
  lGrossAmount.Caption := MoneyToStr(0, iNoOfDecs);
end;

end.

