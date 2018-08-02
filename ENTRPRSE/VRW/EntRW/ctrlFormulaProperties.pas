unit ctrlFormulaProperties;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, // delphi
  Controls, Forms, Dialogs, Buttons, StdCtrls, ComCtrls, ExtCtrls, // delphi
  VRWReportIF,
  DesignerTypes,    // Common designer types and interfaces
  Region, RptWizardTypes,
  ctrlDrag, ctrlDBField, ctrlFormula, ImgList, ToolWin, Spin, TEditVal,
  TCustom, Mask, EnterToTab, ThemeMgr;

type
  TVRWFunction = class(TCollectionItem)
  private
    FIsString: Boolean;
    FCategory: ShortString;
    FCaption: ShortString;
    FDescription: ShortString;
    FTemplate: ShortString;
    FData: IInterface;
    procedure SetCaption(const Value: ShortString);
    procedure SetCategory(const Value: ShortString);
    procedure SetDescription(const Value: ShortString);
    procedure SetIsString(const Value: Boolean);
    procedure SetTemplate(const Value: ShortString);
    procedure SetData(const Value: IInterface);
  public
    property Category: ShortString read FCategory write SetCategory;
    property Caption: ShortString read FCaption write SetCaption;
    property Description: ShortString read FDescription write SetDescription;
    property Template: ShortString read FTemplate write SetTemplate;
    property IsString: Boolean read FIsString write SetIsString;
    property Data: IInterface read FData write SetData;
  end;

  TVRWFunctionList = class(TCollection)
  private
    function GetFunction(Category, Caption: ShortString): TVRWFunction;
    function GetItem(Index: Integer): TVRWFunction;
    procedure SetFunction(Category, Caption: ShortString;
      const Value: TVRWFunction);
    procedure SetItem(Index: Integer; const Value: TVRWFunction);
  public
    constructor Create;
    function Add(Category, Caption, Description, Template: ShortString;
      IsString: Boolean): TVRWFunction;
    property Items[Index: Integer]: TVRWFunction read GetItem write SetItem;
    property Functions[Category, Caption: ShortString]: TVRWFunction read GetFunction write SetFunction;
  end;

  TFormulaPropertiesMode = (fpmFormula, fpmPrintIf, fpmSelectionCriteria);

  TFunctionGroup = ( NONE, DBFIELD_GROUP, FORMULA_GROUP, OPERATORS_GROUP, STRING_GROUP, NUMERIC_GROUP, OTHER_GROUP, INPUT_FIELD_GROUP );

  TSelectDefinition = ( NO_DEFINITION, SELECTION_CRITERIA, PRINT_IF_CRITERIA, FORMULA_DEFINE );

  TfrmFormulaProperties = class(TForm)
    PageControl1: TPageControl;
    tabshFormula: TTabSheet;
    tabshMisc: TTabSheet;
    Label1: TLabel;
    memFormulaDisplay: TMemo;
    Panel2: TPanel;
    Bevel1: TBevel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    lvFunctionList: TListView;
    btnAddToFormula: TButton;
    btnCheckFormula: TButton;
    imglstButtonIcons: TImageList;
    GroupBox2: TGroupBox;
    lblFieldFormat: TLabel;
    lblDecPlaces: TLabel;
    cbAlignment: TComboBox;
    chkBlankOnZero: TCheckBox;
    chkPrintField: TCheckBox;
    edtDecimalPlaces: Text8Pt;
    udDecimalPlaces: TSBSUpDown;
    GroupBox3: TGroupBox;
    lblFontExample: TLabel;
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    Label81: Label8;
    Label82: Label8;
    edtFormulaName: Text8Pt;
    memFormulaComments: TMemo;
    btnFont: TButton;
    GroupBox4: TGroupBox;
    Label86: Label8;
    lblCurrency: Label8;
    edtPeriod: TEdit;
    edtYear: TEdit;
    cbCurrency: TComboBox;
    FontDialog1: TFontDialog;
    EnterToTab1: TEnterToTab;
    chkPercentage: TCheckBox;
    ThemeManager1: TThemeManager;
    chkStringFormula: TCheckBox;
    ToolButton7: TToolButton;

    procedure sbNumericFunctionsClick(Sender: TObject);
    procedure sbStringFunctionsClick(Sender: TObject);
    procedure sbOperatorFunctionsClick(Sender: TObject);
    procedure sbOtherFunctionsClick(Sender: TObject);
    procedure sbPickDBFieldClick(Sender: TObject);
    procedure sbPickFormulaClick(Sender: TObject);
    procedure sbInputFieldsClick(Sender: TObject);
    procedure lvFunctionListDblClick(Sender: TObject);
    procedure btnCheckFormulaClick(Sender: TObject);
    procedure memFormulaDisplayClick(Sender: TObject);
    procedure memFormulaDisplayKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lvFunctionListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure edtFormulaNameKeyPress(Sender: TObject; var Key: Char);
    procedure memFormulaDisplayChange(Sender: TObject);
    procedure chkStringFormulaClick(Sender: TObject);
  private
    { Private declarations }
    siFormulaHotSpot : SmallInt;

    FormulaOK : boolean;

    FunctionGroup : TFunctionGroup;

    FDefinitionType : TSelectDefinition;

    FunctionList: TVRWFunctionList;

    procedure InsertIntoFormula(Category: ShortString);

    procedure PopulateFunctionList;

    procedure PopulateDBFieldFunctions;
    procedure PopulateFormulaFunctions;
    procedure PopulateNumericFunctions;
    procedure PopulateOperatorFunctions;
    procedure PopulateOtherFunctions;
    procedure PopulateStringFunctions;
    procedure PopulateInputFields;

    procedure PopulateListView(ForCategory: ShortString);
    function GetFinalDefinition: ShortString;
    function GetIsStringFormula: Boolean;
    procedure SetIsStringFormula(const Value: Boolean);

    //function TotallingType : TTotalType;
  public
    { Public declarations }
    FMode : TFormulaPropertiesMode;
    FControl : TBaseDragControl;

    FWizard : TReportWizardParams;
    FField : TDBFieldColumn;

    //ReportRegion : TRWRegion;
    ReportFormulaName : ShortString;
    function ValidateFormula: Boolean;
  published
    //property FormulaType : TTotalType read TotallingType;
    property DefinitionType : TSelectDefinition write FDefinitionType;
    property FinalDefinition: ShortString read GetFinalDefinition;
    property IsStringFormula: Boolean
      read GetIsStringFormula
      write SetIsStringFormula;

    Procedure SetFormulaMode (Const FormulaControl : TVRWFormulaControl);
    Procedure SetPrintIfMode (Const Control : TBaseDragControl);
    Procedure SetSelectionCriterionMode(Const DBFieldControl : TVRWDBFieldControl);
    Procedure SetWizardMode(Const WizardReport : TReportWizardParams; Const DBField : TDBFieldColumn);
  end;


// Adds a Formula control into the specified region at the specified region client co-ords
Function AddFormulaControl(Const Region : TWinControl; Const X, Y : Integer) : Boolean;

// Displays the properties dialog for the passed Formula Control, returns TRUE
// if the user Saved the changes or FALSE if they cancelled the dialog
Function DisplayFormulaOptions (DesignerControl : TVRWFormulaControl;
  TheForm: TForm = nil) : Boolean;

// Displays the Print If dialog for the passed Control, returns TRUE if the user Saved
// the changes or FALSE if they cancelled the dialog
Function DisplayPrintIfOptions (DesignerControl : TBaseDragControl) : Boolean;

// Displays the DB Field's Selection Criteria dialog for the passed Control, returns
// TRUE if the user Saved the changes or FALSE if they cancelled the dialog
Function DisplaySelectionCriterion (DBFieldControl : TVRWDBFieldControl) : Boolean;

// Displays the Print If dialog for the specified DBField for the Add Report Wizard
Function DisplayWizardFilter (Const WizardReport : TReportWizardParams; Const DBField : TDBFieldColumn) : Boolean;


implementation

{$R *.dfm}

uses
  Menus, // delphi
  VarConst, GlobVar, Btsupu2, EntLicence, DesignerUtil,
  GlobalTypes, RwOpenF; // my own


const
  // HM 07/03/05: Changed to TAB from '#' as that is a valid character in the Name
  DB_FIELD_DELIMITER = #9;
  //FORMULA_DELIMITER = '#';

  DB_FIELD_TAG = 'DBF';
  FORMULA_FIELD_TAG = 'FML';
  RANGE_FILTER_TAG = 'RF';

type
  TStringFunctions  = ( BEGINS_WITH, ENDS_WITH, CONTAINS, SUB_TEXT, TRIM_STRING, ADD_SPACE );

  TOperatorFunctions  = ( ADD, SUBTRACT, MULTIPLY, DIVIDE, GREATER_THAN, LESS_THAN, AND_OPERATOR, OR_OPERATOR, NOT_EQUALS, EQUALS );

  TNumericFunctions  = ( MIN, MAX, ROUND, TRUNC );

  TOtherFunctions  = (NUMBER_TO_TEXT,
                      TEXT_TO_NUMBER,
                      DATE_TO_TEXT,
                      DATE_TO_NUMBER,
                      IF_FUNC,
                      INFO_DATE,
                      INFO_TIME,
                      INFO_FIRSTPAGE,
                      INFO_CURRENTPAGE,
                      INFO_LASTPAGE,
                      INFO_TOTALPAGES,
                      TOTAL_RECORDS,
                      COUNT_RECORDS );

const
  aStringKeywords : array[BEGINS_WITH..ADD_SPACE] of string = ('BeginsWith','EndsWith','Contains','SubString','Trim','+ <SPACE> +');
  aOperatorKeywords : array[ADD..EQUALS] of string = ('+','-','*','/','>','<','AND','OR','<>','=');
  aNumericKeywords : array[MIN..TRUNC] of string = ('Min','Max','Round','Trunc');
  aOtherKeywords : array[NUMBER_TO_TEXT..COUNT_RECORDS] of string =
    ('NumberToText',
     'TextToNumber',
     'DateToText',
     'DateToNumber',
     'If',
     'Info[DATE]',
     'Info[TIME]',
     'Info[FIRSTPAGE]',
     'Info[CURRENTPAGE]',
     'Info[LASTPAGE]',
     'Info[TOTALPAGES]',
     'TotalField',
     'CountField');

//=========================================================================

// Adds a Formula control into the specified region at the specified region client co-ords
Function AddFormulaControl(Const Region : TWinControl; Const X, Y : Integer) : Boolean;
Var
  frmFormulaProperties : TfrmFormulaProperties;
  FormulaControl       : TVRWFormulaControl;
  NewFormulaIntf       : IVRWFormulaControl;
Begin // AddFormulaControl
  frmFormulaProperties := TfrmFormulaProperties.Create(Application.MainForm);
  Try
    // Centre the window over the mouse click
    With Region.ClientToScreen(Point(X,Y)) Do CentreOverCoords (frmFormulaProperties, X, Y);

    // Create new text object in RepEngine.Dll
    NewFormulaIntf := TRegion(Region).reRegionDets.rgControls.Add(TRegion(Region).reRegionDets.RgReport, ctFormula) As IVRWFormulaControl;

    // Create a new hidden wrapper control for the designer - setup minimum basic info
    FormulaControl := TVRWFormulaControl.Create (TRegion(Region).reManager, NewFormulaIntf);
    FormulaControl.Visible := False;
    FormulaControl.ParentRegion := TRegion(Region);
    FormulaControl.SetBounds (X, Y, 90, 21); // LTWH

    frmFormulaProperties.SetFormulaMode (FormulaControl);

    Result := (frmFormulaProperties.ShowModal = mrOK);
    If Result Then
    Begin
      // Need to size intelligently and position according to the grid
      FormulaControl.CalcInitialSize ('9,999,999.99-');
      FormulaControl.SnapToGrid;

      // Select the control
      TRegion(Region).reManager.SelectControl(FormulaControl, False);

      // Finally, show the control
      FormulaControl.Visible := True;
    End // If Result
    Else
    Begin
      // Cancelled - remove control and destroy RepEngine object
      FormulaControl.Free;
      TRegion(Region).reRegionDets.rgControls.Delete(NewFormulaIntf.vcName);
    End; // Else
  Finally
    NewFormulaIntf := NIL;
    FreeAndNIL(frmFormulaProperties);
  End; // Try..Finally
End; // AddFormulaControl

//-------------------------------------------------------------------------

// Displays the properties dialog for the passed Formula Control, returns TRUE
// if the user Saved the changes or FALSE if they cancelled the dialog
Function DisplayFormulaOptions (DesignerControl : TVRWFormulaControl;
  TheForm: TForm) : Boolean;
Var
  frmFormulaProperties : TfrmFormulaProperties;
Begin // DisplayDBFieldOptions
  frmFormulaProperties := TfrmFormulaProperties.Create(Application.MainForm);
  Try
    if TheForm <> nil then
      CentreOverForm(frmFormulaProperties, TheForm)
    else
      CentreOverControl (frmFormulaProperties, DesignerControl);
    frmFormulaProperties.SetFormulaMode (DesignerControl);
    Result := (frmFormulaProperties.ShowModal = mrOK);
  Finally
    FreeAndNIL(frmFormulaProperties);
  End; // Try..Finally
End; // DisplayDBFieldOptions

//-------------------------------------------------------------------------

// Displays the DB Field's Selection Criteria dialog for the passed Control, returns
// TRUE if the user Saved the changes or FALSE if they cancelled the dialog
Function DisplaySelectionCriterion (DBFieldControl : TVRWDBFieldControl) : Boolean;
Var
  frmFormulaProperties : TfrmFormulaProperties;
Begin // DisplaySelectionCriterion
  frmFormulaProperties := TfrmFormulaProperties.Create(Application.MainForm);
  Try
    CentreOverControl (frmFormulaProperties, DBFieldControl);

    frmFormulaProperties.Caption := 'Data Selection Criteria - ' + Trim(DBFieldControl.DBFieldDets.vcFieldName);

    frmFormulaProperties.SetSelectionCriterionMode(DBFieldControl);

    Result := (frmFormulaProperties.ShowModal = mrOK);
  Finally
    FreeAndNIL(frmFormulaProperties);
  End; // Try..Finally
End; // DisplaySelectionCriterion

//-------------------------------------------------------------------------

// Displays the Print If dialog for the passed Control, returns TRUE if the user Saved
// the changes or FALSE if they cancelled the dialog
Function DisplayPrintIfOptions (DesignerControl : TBaseDragControl) : Boolean;
Var
  frmFormulaProperties : TfrmFormulaProperties;
Begin // DisplayPrintIfOptions
  frmFormulaProperties := TfrmFormulaProperties.Create(Application.MainForm);
  Try
    CentreOverControl (frmFormulaProperties, DesignerControl);
//    frmFormulaProperties.DBFieldControl := DesignerControl;

    If (DesignerControl Is TVRWFormulaControl) Then
      frmFormulaProperties.Caption := 'Print If Properties - ' + TVRWFormulaControl(DesignerControl).FormulaDets.vcFormulaName
    Else If (DesignerControl Is TVRWDBFieldControl) Then
      frmFormulaProperties.Caption := 'Print If Properties - ' + Trim(TVRWDBFieldControl(DesignerControl).DBFieldDets.vcFieldName)
    Else
      frmFormulaProperties.Caption := 'Print If Properties';

    frmFormulaProperties.SetPrintIfMode(DesignerControl);

    Result := (frmFormulaProperties.ShowModal = mrOK);
  Finally
    FreeAndNIL(frmFormulaProperties);
  End; // Try..Finally
End; // DisplayPrintIfOptions

//-------------------------------------------------------------------------

// Displays the Print If dialog for the specified DBField for the Add Report Wizard
Function DisplayWizardFilter (Const WizardReport : TReportWizardParams; Const DBField : TDBFieldColumn) : Boolean;
Var
  frmFormulaProperties : TfrmFormulaProperties;
Begin // DisplayPrintIfOptions
  frmFormulaProperties := TfrmFormulaProperties.Create(Application.MainForm);
  Try

    frmFormulaProperties.Caption := 'Field Filter Properties - ' + Trim(DBField.DictRec.VarName);

    frmFormulaProperties.SetWizardMode(WizardReport, DBField);

    Result := (frmFormulaProperties.ShowModal = mrOK);
  Finally
    FreeAndNIL(frmFormulaProperties);
  End; // Try..Finally
End; // DisplayPrintIfOptions

//=========================================================================

procedure TfrmFormulaProperties.FormCreate(Sender: TObject);
begin
  FDefinitionType := NO_DEFINITION;
  FunctionGroup := NONE;
  //ReportRegion := nil;
  ReportFormulaName := '';
  siFormulaHotSpot := 0;
  FormulaOK := TRUE;

  cbCurrency.Visible := EnterpriseLicence.elIsMultiCcy;
  lblCurrency.Visible := cbCurrency.Visible;
  if cbCurrency.Visible then
    Set_DefaultCurr(cbCurrency.Items, TRUE, TRUE);

  FunctionList := TVRWFunctionList.Create;
End; // FormCreate

//-------------------------------------------------------------------------

procedure TfrmFormulaProperties.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  iRegion, iControl : SmallInt;
  oControl          : TBaseDragControl;
begin
  If (ModalResult = mrOK) Then
  Begin
    if (Trim(memFormulaDisplay.Text) <> '') and (not ValidateFormula) then
    begin
      CanClose := False;
      Exit;
    end;
    If (FMode = fpmFormula) Then
    Begin
      // Validate name
      CanClose := (Trim(edtFormulaName.Text) <> '');
      If CanClose Then
      Begin
        // Check the name doesn't already exist on a different control - this must be done by
        // going through the controls on each region component - can't use the list of controls
        // on Chris's IVRWReport object as Delphi is changing the interface reference somehow so
        // I can't match two interfaces together as the addresses are different.
        With FControl.ParentRegion.reManager Do
        Begin
          // Run through each TRegion
          If (rmRegions.Count > 0) Then
          Begin
            For iRegion := 0 To (rmRegions.Count - 1) Do
            Begin
              With TRegion(rmRegions[iRegion]) Do
              Begin
                // Run through the controls within the TRegion
                If (reRegionControls.Count > 0) Then
                Begin
                  For iControl := 0 To (reRegionControls.Count - 1) Do
                  Begin
                    // For formula controls other than the one being added/edited check the name
                    oControl := TBaseDragControl(reRegionControls.Items[iControl]);
                    If (oControl Is TVRWFormulaControl) And (oControl <> FControl) Then
                    Begin
                      If Uppercase(TVRWFormulaControl(oControl).FormulaDets.vcFormulaName) = Uppercase(Trim(edtFormulaName.Text)) Then
                      Begin
                        MessageDlg('Another Formula already exists with this Name', mtError, [mbOK], 0);
                        If edtFormulaName.CanFocus Then edtFormulaName.SetFocus;
                        CanClose := False;
                        Break;
                      End; // If (TVRWFormulaControl(oControl).FormulaDets.vcFormulaName = Trim(edtFormulaName.Text))
                    End; // If (oControl Is TVRWFormulaControl) And (oControl <> FControl)
                  End; // For iControl
                End; // If (reRegionControls.Count > 0)
              End; // With TRegion(rmRegions[iRegion])

              If (Not CanClose) Then Break;
            End; // For iRegion
          End; // If (rmRegions.Count > 0)
        End; // With FControl.ParentRegion.reManager
      End // If CanClose
      Else
      Begin
        PageControl1.ActivePage := tabshMisc;
        If edtFormulaName.CanFocus Then edtFormulaName.SetFocus;
        MessageDlg('The Formula Name must be set', mtError, [mbOK], 0);
      End; // Else
    End; // If (FMode = fpmFormula)

    If CanClose Then
    Begin
      FreeAndNil(FunctionList);
      If (FMode = fpmFormula) Then
      Begin
        With TVRWFormulaControl(FControl) Do
        Begin
          FormulaDets.vcFormulaName := Trim(edtFormulaName.Text);
          FormulaDets.vcComments := Trim(memFormulaComments.Text);

          FormulaDets.vcPeriod := edtPeriod.Text;
          FormulaDets.vcYear := edtYear.Text;
          If cbCurrency.Visible Then
            FormulaDets.vcCurrency := cbCurrency.ItemIndex
          Else
            FormulaDets.vcCurrency := 0;

          Case cbAlignment.ItemIndex Of
            0 : FormulaDets.vcFieldFormat := 'L';
            1 : FormulaDets.vcFieldFormat := 'C';
            2 : FormulaDets.vcFieldFormat := 'R';
          Else
            FormulaDets.vcFieldFormat := 'L';
          End; // Case cbAlignment.ItemIndex

          FormulaDets.vcDecimalPlaces := udDecimalPlaces.Position;

          If chkBlankOnZero.Checked Then FormulaDets.vcFieldFormat := FormulaDets.vcFieldFormat + 'B';

          if chkPercentage.Checked then
            FormulaDets.vcFieldFormat := FormulaDets.vcFieldFormat + '%';

          FormulaDets.vcPrintField := chkPrintField.Checked;

          FormulaDets.vcFormulaDefinition := FinalDefinition;

          // Update the font, also causes a repaint and sets the changed flag
          UpdateFont(lblFontExample.Font);
        End; // With TVRWFormulaControl(FControl).FormulaDets
      End // If (FMode = fpmFormula)
      Else If (FMode = fpmPrintIf) Then
      Begin
        FControl.ControlDets.vcPrintIf := memFormulaDisplay.Text;
      End // If (FMode = fpmPrintIf)
      Else If (FMode = fpmSelectionCriteria) Then
      Begin
        If Assigned(FControl) Then
        Begin
          // Record Selection Criterion
          TVRWDBFieldControl(FControl).DBFieldDets.vcSelectCriteria := memFormulaDisplay.Text;
        End // If Assigned(FControl)
        Else If Assigned(FField) Then
        Begin
          FField.Filter := memFormulaDisplay.Text;
        End; // If Assigned(FField)
      End // If (FMode = fpmSelectionCriteria)
      Else
        Raise Exception.Create ('TfrmFormulaProperties.FormCloseQuery: Unhandled mode (' + IntToStr(Ord(FMode)) + ')');
    End; // If CanClose
  End; // If (ModalResult = mrOK)
end;

//-------------------------------------------------------------------------

function TfrmFormulaProperties.GetFinalDefinition: ShortString;
begin
  Result := memFormulaDisplay.Text;
  if IsStringFormula then
    Result := '"' + Result;
end;

//-------------------------------------------------------------------------

function TfrmFormulaProperties.GetIsStringFormula: Boolean;
begin
  Result := chkStringFormula.Checked;
end;

//-------------------------------------------------------------------------

procedure TfrmFormulaProperties.SetIsStringFormula(const Value: Boolean);
begin
  chkStringFormula.Checked := Value;
end;

//-------------------------------------------------------------------------

Procedure TfrmFormulaProperties.SetFormulaMode (Const FormulaControl : TVRWFormulaControl);
Begin // SetFormulaMode
  FControl := FormulaControl;
  FWizard := NIL;
  FField := NIL;
  If Assigned(FControl) Then
  Begin
    FMode := fpmFormula;

    PageControl1.ActivePage := tabshFormula;
    PageControl1Change(Self);
    self.HelpContext := PageControl1.ActivePage.HelpContext;
    chkStringFormula.Visible := True;

    With TVRWFormulaControl(FControl) Do
    Begin
      edtFormulaName.Text := FormulaDets.vcFormulaName;
      memFormulaComments.Text := FormulaDets.vcComments;

      edtPeriod.Text := FormulaDets.vcPeriod;
      edtYear.Text := FormulaDets.vcYear;
      If cbCurrency.Visible And (FormulaDets.vcCurrency < cbCurrency.Items.Count) Then
        cbCurrency.ItemIndex := FormulaDets.vcCurrency
      Else
        cbCurrency.ItemIndex := -1;

      If (Pos('R', UpperCase(FormulaDets.vcFieldFormat)) > 0) Then
        cbAlignment.ItemIndex := 2
      Else If (Pos('C', UpperCase(FormulaDets.vcFieldFormat)) > 0) Then
        cbAlignment.ItemIndex := 1
      Else
        cbAlignment.ItemIndex := 0;
      udDecimalPlaces.Position := FormulaDets.vcDecimalPlaces;
      chkBlankOnZero.Checked := (Pos('B', UpperCase(FormulaDets.vcFieldFormat)) > 0);
      chkPrintField.Checked := FormulaDets.vcPrintField;

      chkPercentage.Checked := (Pos('%', FormulaDets.vcFieldFormat) > 0);

      CopyIFontToFont (FormulaDets.vcFont, lblFontExample.Font);

      if (Copy(FormulaDets.vcFormulaDefinition, 1, 1) = '"') then
      begin
        memFormulaDisplay.Text :=
          Copy(FormulaDets.vcFormulaDefinition, 2,
               Length(FormulaDets.vcFormulaDefinition));
        chkStringFormula.Checked := True;
      end
      else
      begin
        memFormulaDisplay.Text := FormulaDets.vcFormulaDefinition;
        chkStringFormula.Checked := False;
      end;
    End; // With TVRWFormulaControl(FControl)

    ActiveControl := memFormulaDisplay;

    PopulateFormulaFunctions;
    PopulateNumericFunctions;
    PopulateOperatorFunctions;
    PopulateOtherFunctions;
    PopulateStringFunctions;
    PopulateInputFields;
    // Load the list of DB Fields
    PopulateDBFieldFunctions;
    sbPickDBFieldClick(Self);
  End; // If Assigned(FControl)
End; // SetFormulaMode

//------------------------------

Procedure TfrmFormulaProperties.SetPrintIfMode (Const Control : TBaseDragControl);
Begin // SetPrintIfMode
  FControl := Control;
  FWizard := NIL;
  FField := NIL;
  If Assigned(FControl) Then
  Begin
    FMode := fpmPrintIf;

    tabshMisc.TabVisible := False;
    PageControl1.ActivePage := tabshFormula;
    PageControl1Change(Self);

    chkStringFormula.Visible := False;

    PageControl1.ActivePage.HelpContext := 104;
    self.HelpContext := 104;

    memFormulaDisplay.Text := FControl.ControlDets.vcPrintIf;

    PopulateFormulaFunctions;
    PopulateNumericFunctions;
    PopulateOperatorFunctions;
    PopulateOtherFunctions;
    PopulateStringFunctions;
    PopulateInputFields;
    // Load the list of DB Fields
    PopulateDBFieldFunctions;
    sbPickDBFieldClick(Self);
  End; // If Assigned(FControl)
End; // SetPrintIfMode

//------------------------------

Procedure TfrmFormulaProperties.SetSelectionCriterionMode(Const DBFieldControl : TVRWDBFieldControl);
Begin // SetSelectionCriterionMode
  FControl := DBFieldControl;
  FWizard := NIL;
  FField := NIL;
  If Assigned(FControl) Then
  Begin
    FMode := fpmSelectionCriteria;

    tabshMisc.TabVisible := False;
    PageControl1.ActivePage := tabshFormula;
    PageControl1Change(Self);

    chkStringFormula.Visible := False;

    PageControl1.ActivePage.HelpContext := 19;
    self.HelpContext := 19;

    memFormulaDisplay.Text := DBFieldControl.DBFieldDets.vcSelectCriteria;

    PopulateFormulaFunctions;
    PopulateNumericFunctions;
    PopulateOperatorFunctions;
    PopulateOtherFunctions;
    PopulateStringFunctions;
    PopulateInputFields;
    // Load the list of DB Fields
    PopulateDBFieldFunctions;
    sbPickDBFieldClick(Self);
  End; // If Assigned(FControl)
End; // SetSelectionCriterionMode

//------------------------------

Procedure TfrmFormulaProperties.SetWizardMode(Const WizardReport : TReportWizardParams; Const DBField : TDBFieldColumn);
Begin // SetSelectionCriterionMode
  FControl := NIL;
  FWizard := WizardReport;
  FField := DBField;
  If Assigned(FWizard) And Assigned(FField) Then
  Begin
    FMode := fpmSelectionCriteria;

    tabshMisc.TabVisible := False;
    PageControl1.ActivePage := tabshFormula;
    PageControl1Change(Self);
    PageControl1.ActivePage.HelpContext := 15065;
    self.HelpContext := 15065;

    chkStringFormula.Visible := False;

    memFormulaDisplay.Text := FField.Filter;

    PopulateFunctionList;

    sbPickDBFieldClick(Self);
  End; // If Assigned(FWizard) And Assigned(FField)
End; // SetSelectionCriterionMode

//-------------------------------------------------------------------------

procedure TfrmFormulaProperties.sbPickDBFieldClick(Sender: TObject);
begin
  FunctionGroup := DBFIELD_GROUP;
  lvFunctionList.Columns[0].Caption := 'Fields';
  PopulateListView('DBField');
end;

//------------------------------

procedure TfrmFormulaProperties.sbPickFormulaClick(Sender: TObject);
begin
  FunctionGroup := FORMULA_GROUP;
  lvFunctionList.Columns[0].Caption := 'Formulae';
  PopulateListView('Formula');
end;

//-------------------------------------------------------------------------

procedure TfrmFormulaProperties.sbNumericFunctionsClick(Sender: TObject);
begin
  FunctionGroup := NUMERIC_GROUP;
  lvFunctionList.Columns[0].Caption := 'Functions';
  PopulateListView('Numeric');
end;

procedure TfrmFormulaProperties.sbStringFunctionsClick(Sender: TObject);
begin
  FunctionGroup := STRING_GROUP;
  lvFunctionList.Columns[0].Caption := 'Functions';
  PopulateListView('String');
end;

procedure TfrmFormulaProperties.sbOperatorFunctionsClick(Sender: TObject);
begin
  FunctionGroup := OPERATORS_GROUP;
  lvFunctionList.Columns[0].Caption := 'Functions';
  PopulateListView('Operator');
end;

procedure TfrmFormulaProperties.sbOtherFunctionsClick(Sender: TObject);
begin
  FunctionGroup := OTHER_GROUP;
  lvFunctionList.Columns[0].Caption := 'Functions';
  PopulateListView('Other');
end;

procedure TfrmFormulaProperties.sbInputFieldsClick(Sender: TObject);
begin
  FunctionGroup := INPUT_FIELD_GROUP;
  lvFunctionList.Columns[0].Caption := 'Fields';
  PopulateListView('Input Field');
end;

procedure TfrmFormulaProperties.lvFunctionListDblClick(Sender: TObject);
begin
  with lvFunctionList do
  begin
    if assigned(ItemFocused) then
      case FunctionGroup of
        OPERATORS_GROUP: InsertIntoFormula('Operator');
        STRING_GROUP:    InsertIntoFormula('String');
        NUMERIC_GROUP:   InsertIntoFormula('Numeric');
        OTHER_GROUP:     InsertIntoFormula('Other');
        DBFIELD_GROUP:   InsertIntoFormula('DBField');
        FORMULA_GROUP:   InsertIntoFormula('Formula');
        INPUT_FIELD_GROUP: InsertIntoFormula('Input Field');
      end; // case FunctionGroup of...
  end; // with Sender as TListView do...
  if memFormulaDisplay.CanFocus then
    memFormulaDisplay.SetFocus;
end;

procedure TfrmFormulaProperties.btnCheckFormulaClick(Sender: TObject);
begin
  ValidateFormula;
end;

procedure TfrmFormulaProperties.InsertIntoFormula(Category: ShortString);
{ Inserts the currently selected function into the formula, at the current
  cursor position. If there is highlighted text in the formula, it will be
  deleted and replaced with the function. }
var
  ssFormulaText : ShortString;
  Item: TListItem;
  FunctionItem: TVRWFunction;
  CharPos: Integer;
  HotSpotStart, HotSpotLength: Integer;
begin
  // Get the current formula text
  ssFormulaText := memFormulaDisplay.Text;
  // Find the cursor position
  HotSpotStart := memFormulaDisplay.SelStart;
  // Remove any currently selected text
  HotSpotLength := memFormulaDisplay.SelLength;
  if memFormulaDisplay.SelLength > 0 then
    Delete(ssFormulaText, HotSpotStart + 1, HotSpotLength);
  HotSpotLength := 0;

  // Get the function details
  Item := lvFunctionList.ItemFocused;
  FunctionItem := FunctionList.Functions[Category, Item.Caption];
  if (FunctionItem <> nil) then
  begin
    // Insert the function template at the cursor position
    Insert(FunctionItem.Template, ssFormulaText, HotSpotStart + 1);
    // Look for the cursor position markers in the newly added text, and
    // highlight the text between them
    CharPos := Pos('|', ssFormulaText);
    if (CharPos > 0) then
    begin
      HotSpotStart := CharPos - 1;
      Delete(ssFormulaText, CharPos, 1);
      CharPos := Pos('|', ssFormulaText);
      if (CharPos > 0) then
      begin
        Delete(ssFormulaText, CharPos, 1);
        memFormulaDisplay.SelStart := HotSpotStart;
        HotSpotLength := (CharPos - HotSpotStart) - 1;
      end;
    end
    else
      // No cursor position markers. Just put the cursor at the end of the
      // newly added text
      Inc(HotSpotStart, Length(FunctionItem.Template));

    // Copy the text back into the memo edit box
    memFormulaDisplay.Text := ssFormulaText;

    // If the function is a string, make sure the '"' string marker is
    // prepended to the formula
    if (FunctionItem.IsString) and (FMode = fpmFormula) then
      IsStringFormula := True;

    // Set the cursor position and selected text in the memo box
    memFormulaDisplay.SelStart := HotSpotStart;
    memFormulaDisplay.SelLength := HotSpotLength;
  end; // if (FunctionItem <> nil...
end;

procedure TfrmFormulaProperties.lvFunctionListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    lvFunctionListDblClick(Self);
end;

procedure TfrmFormulaProperties.memFormulaDisplayClick(Sender: TObject);
begin
  siFormulaHotSpot := memFormulaDisplay.SelStart;
end;

procedure TfrmFormulaProperties.memFormulaDisplayKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
{ OBSOLETE }
begin
  case Key of
    VK_BACK  : Dec(siFormulaHotSpot); // back space key
    VK_LEFT  : Inc(siFormulaHotSpot); // left arrow key
    VK_RIGHT : Dec(siFormulaHotSpot); // right arrow key
    VK_END   : siFormulaHotSpot := Length(memFormulaDisplay.Text);
    VK_HOME  : siFormulaHotSpot := 0;
    else
      Inc(siFormulaHotSpot);
  end; // case Key of...
end;

procedure TfrmFormulaProperties.PopulateDBFieldFunctions;
var
  pDBFData : TDBFieldColumn;
  I : SmallInt;
begin
  if Assigned(FControl) then
  begin
    with FControl.ParentRegion.reManager.rmReport.vrControls do
    begin
      if (clCount > 0) then
      begin
        for I := 0 To (clCount - 1) do
        begin
          if (clItems[I].vcType = ctField) and
             (not clItems[I].vcDeleted) then
          begin
            FunctionList.Add(
              'DBField',
              (clItems[I] As IVRWFieldControl).vcFieldName,
              (clItems[I] As IVRWFieldControl).vcVarDesc,
              'DBF[' + Trim((clItems[I] As IVRWFieldControl).vcFieldName) + ']',
              False
            );
          end; // If (clItems[I].vcType = ctField)
        end; // For I
      end; // If (clCount > 0)
    end; // With FControl.ParentRegion.reManager.rmReport.vrControls
  end // If Assigned(FControl)
  else if Assigned(FWizard) and Assigned(FField) then
  Begin
    If (FWizard.wrDBFieldList.Count > 0) Then
    Begin
      For I := 0 To (FWizard.wrDBFieldList.Count - 1) Do
      Begin
        pDBFData := TDBFieldColumn(FWizard.wrDBFieldList[I]);
        FunctionList.Add(
          'DBField',
          pDBFData.DictRec.VarName,
          pDBFData.DictRec.VarDesc,
          'DBF[' + pDBFData.DictRec.VarName + ']',
          False
        );
      End; // For I
    End; // If (FWizard.wrDBFieldList.Count > 0)
  End; // If Assigned(FWizard) And Assigned(FField)
end;

procedure TfrmFormulaProperties.PopulateFormulaFunctions;
var
  I : SmallInt;
begin
  If Assigned(FControl) Then
  Begin
    With FControl.ParentRegion.reManager.rmReport.vrControls Do
    Begin
      If (clCount > 0) Then
      Begin
        For I := 0 To (clCount - 1) Do
        Begin
          If (clItems[I].vcType = ctFormula) Then
          Begin
            FunctionList.Add(
              'Formula',
              (clItems[I] As IVRWFormulaControl).vcFormulaName,
              (clItems[I] As IVRWFormulaControl).vcFormulaDefinition,
              'FML[' + (clItems[I] As IVRWFormulaControl).vcFormulaName + ']',
              (clItems[I] As IVRWFormulaControl).vcFormulaDefinition[1] = '"'
            );
          End; // If (clItems[I].vcType = ctFormula)
        End; // For I
      End; // If (clCount > 0)
    End; // With FControl.ParentRegion.reManager.rmReport.vrControls
  End; // If Assigned(FControl)
end;

procedure TfrmFormulaProperties.PopulateInputFields;
var
  i: Integer;
  Item: IVRWInputField;
const
  STRING_TYPES = [1, 4, 6, 7, 8, 10, 11, 12, 13, 17, 18];
begin
  if Assigned(FControl) then
  begin
    with FControl.ParentRegion.reManager.rmReport as IVRWReport3 do
    begin
      for i := 0 to vrInputFields.rfCount - 1 do
      begin
        Item := vrInputFields.rfItems[i];
        FunctionList.Add(
          'Input Field',
          Item.rfName,
          'FROM: "' + Item.rfFromValue + '" TO: "' + Item.rfToValue + '"',
          'INP[' + Item.rfName + ']',
          Item.rfType in STRING_TYPES
        ).Data := Item;
      end;
    end;
  end;
end;

procedure TfrmFormulaProperties.PopulateFunctionList;
begin
  FunctionList.Clear;
  PopulateFormulaFunctions;
  PopulateNumericFunctions;
  PopulateOperatorFunctions;
  PopulateOtherFunctions;
  PopulateStringFunctions;
  PopulateDBFieldFunctions;
  PopulateInputFields;
end;

procedure TfrmFormulaProperties.PopulateListView(ForCategory: ShortString);
var
  Entry: Integer;
  Item: TListItem;
begin
  lvFunctionList.Items.Clear;
  ForCategory := Lowercase(Trim(ForCategory));
  for Entry := 0 to FunctionList.Count - 1 do
  begin
    if Lowercase(FunctionList.Items[Entry].Category) = ForCategory then
    begin
      Item := lvFunctionList.Items.Add;
      Item.Caption := FunctionList.Items[Entry].Caption;
      Item.SubItems.Add(FunctionList.Items[Entry].Description);
    end;
  end;
end;

procedure TfrmFormulaProperties.PopulateNumericFunctions;
begin
  FunctionList.Add(
    'Numeric',
    'Min',
    'Finds the minimum value of two values',
    'Min(|<value1>|,<value2>)',
    False
  );
  FunctionList.Add(
    'Numeric',
    'Max',
    'Finds the maximum value of two values',
    'Max(|<value1>|,<value2>)',
    False
  );
  FunctionList.Add(
    'Numeric',
    'Round',
    'Round value to number of decimal places',
    'Round(|<value>|,<decimal places>)',
    False
  );
  FunctionList.Add(
    'Numeric',
    'Trunc',
    'Round decimal value to whole value',
    'Trunc(|<value>|)',
    False
  );
end;

procedure TfrmFormulaProperties.PopulateOperatorFunctions;
begin
  FunctionList.Add(
    'Operator',
    'Add',
    'Adds two numeric values together',
    ' + ',
    False
  );

  FunctionList.Add(
    'Operator',
    'Subtract',
    'Subtract one numeric value from another',
    ' - ',
    False
  );

  FunctionList.Add(
    'Operator',
    'Multiply',
    'Multiplies two numeric values together',
    ' * ',
    False
  );

  FunctionList.Add(
    'Operator',
    'Divide',
    'Divide one numeric value into another',
    ' / ',
    False
  );

  FunctionList.Add(
    'Operator',
    'Greater than',
    'True if first value is greater than second value',
    ' > ',
    False
  );

  FunctionList.Add(
    'Operator',
    'Less than',
    'True if first value is less than second value',
    ' < ',
    False
  );

  FunctionList.Add(
    'Operator',
    'AND',
    'True if both values are true',
    ' AND ',
    False
  );

  FunctionList.Add(
    'Operator',
    'OR',
    'True one or other value is true',
    ' OR ',
    False
  );

  FunctionList.Add(
    'Operator',
    'Not equal',
    'True if both values are not equal',
    ' <> ',
    False
  );

  FunctionList.Add(
    'Operator',
    'Equal',
    'True if both values are equal',
    ' = ',
    False
  );

end;

procedure TfrmFormulaProperties.PopulateOtherFunctions;
begin
  FunctionList.Add(
    'Other',
    'Number to Text',
    'Converts a numeric value to text',
    'NumberToText(|<number>|,<format>)',
    True
  );

  FunctionList.Add(
    'Other',
    'Text to Number',
    'Converts a text value to a number',
    'TextToNumber(|<text>|)',
    False
  );

  FunctionList.Add(
    'Other',
    'Date to Text',
    'Converts a date to text',
    'DateToText(|<date>|,<format>)',
    True
  );

  FunctionList.Add(
    'Other',
    'Date to Number',
    'Converts a date to the number of days since 1/1/1900',
    'DateToNumber(|<date>|)',
    False
  );

  FunctionList.Add(
    'Other',
    'If',
    'Evaluates an expression, and returns a true or false value',
    'If(|<expression>|,<ifTrue>,<ifFalse>)',
    False
  );

  FunctionList.Add(
    'Other',
    'Date',
    'Returns the current date, as a string',
    'Info[DATE]',
    True
  );

  FunctionList.Add(
    'Other',
    'Time',
    'Returns the current time, as a string',
    'Info[TIME]',
    True
  );

  FunctionList.Add(
    'Other',
    'Report Name',
    'Returns the report name',
    'Info[REPORTNAME]',
    True
  );

  FunctionList.Add(
    'Other',
    'Report Description',
    'Returns the report description',
    'Info[REPORTDESC]',
    True
  );

  FunctionList.Add(
    'Other',
    'First page',
    'Returns the first page number, as a string',
    'Info[FIRSTPAGE]',
    True
  );

  FunctionList.Add(
    'Other',
    'Current page',
    'Returns the current page number, as a string',
    'Info[CURRENTPAGE]',
    True
  );

  FunctionList.Add(
    'Other',
    'Last page',
    'Returns the last page number, as a string',
    'Info[LASTPAGE]',
    True
  );

  FunctionList.Add(
    'Other',
    'Total pages',
    'Returns the total number of pages, as a string',
    'Info[TOTALPAGES]',
    True
  );

  FunctionList.Add(
    'Other',
    'Total field',
    'Totals the value of the selected field',
    'TotalField(|<field>|)',
    False
  );

  FunctionList.Add(
    'Other',
    'Count field',
    'Counts the number of rows for the selected field',
    'CountField(|<field>|)',
    False
  );

end;

procedure TfrmFormulaProperties.PopulateStringFunctions;
begin

  FunctionList.Add(
    'String',
    'Begins with',
    'True if text begins with substring',
    ' BeginsWith |<text>|',
    False
  );

  FunctionList.Add(
    'String',
    'Ends with',
    'True if text ends with substring',
    ' EndsWith |<text>|',
    False
  );

  FunctionList.Add(
    'String',
    'Contains',
    'True if text contains substring',
    ' Contains |<text>|',
    False
  );

  FunctionList.Add(
    'String',
    'Substring',
    'Extract substring from text',
    'Substring(|<text>|,|<start>|,|<length>|)',
    True
  );

  FunctionList.Add(
    'String',
    'Trim',
    'Removes leading and trailing spaces from text',
    'Trim(|<text>|)',
    True
  );
end;

procedure TfrmFormulaProperties.btnFontClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(lblFontExample.Font);
  If FontDialog1.Execute Then
  Begin
    lblFontExample.Font.Assign(FontDialog1.Font);
  End; // If FontDialog1.Execute
end;

procedure TfrmFormulaProperties.PageControl1Change(Sender: TObject);
begin
  self.HelpContext := PageControl1.ActivePage.HelpContext;
  btnFont.Visible := (PageControl1.ActivePage = tabshMisc);
end;

function TfrmFormulaProperties.ValidateFormula: Boolean;
var
  Report: IVRWReport;
  ErrorStr: string;
  Formula: ShortString;
begin
  Result := True;
  Formula := FinalDefinition;
  if (FControl <> nil) then
  begin
    Report := FControl.ControlDets.vcReport;
    if Report <> nil then
    try
      if (FMode in [fpmSelectionCriteria, fpmPrintIf]) then
      begin
        ErrorStr := Trim(Report.ValidateSelectionCriteria(Formula));
      end
      else
        ErrorStr := Trim(Report.ValidateFormula(Formula));
      if (ErrorStr <> '') then
      begin
        ShowMessage('Invalid formula: ' + ErrorStr);
        Result := False;
      end;
    finally
      Report := nil;
    end;
  end;
end;

procedure TfrmFormulaProperties.edtFormulaNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  If (Not (Key In [#8, #9, #10, #13, '0'..'9', 'A'..'Z', 'a'..'z'])) Then
  Begin
    Key := #0;
  End; // If (Not (Key In [#8, #9, #10, #13, '0'..'9', 'A'..'Z', 'a'..'z']))
end;

procedure TfrmFormulaProperties.memFormulaDisplayChange(Sender: TObject);
begin
  chkStringFormula.Enabled := True;
  if (Trim(memFormulaDisplay.Text) = '') then
    chkStringFormula.Checked := False
  else if (Trim(memFormulaDisplay.Text)[1] = '"') then
  begin
    chkStringFormula.Checked := True;
    chkStringFormula.Enabled := False;
  end;
end;

procedure TfrmFormulaProperties.chkStringFormulaClick(Sender: TObject);
begin
  if (chkStringFormula.Checked) then
    cbAlignment.ItemIndex := 0;
  chkBlankOnZero.Enabled := not chkStringFormula.Checked;
  chkPercentage.Enabled := not chkStringFormula.Checked;
end;

{ TVRWFunction }

procedure TVRWFunction.SetCaption(const Value: ShortString);
begin
  FCaption := Value;
end;

procedure TVRWFunction.SetCategory(const Value: ShortString);
begin
  FCategory := Value;
end;

procedure TVRWFunction.SetData(const Value: IInterface);
begin
  FData := Value;
end;

procedure TVRWFunction.SetDescription(const Value: ShortString);
begin
  FDescription := Value;
end;

procedure TVRWFunction.SetIsString(const Value: Boolean);
begin
  FIsString := Value;
end;

procedure TVRWFunction.SetTemplate(const Value: ShortString);
begin
  FTemplate := Value;
end;

{ TVRWFunctionList }

function TVRWFunctionList.Add(Category, Caption, Description,
  Template: ShortString; IsString: Boolean): TVRWFunction;
begin
  Result := TVRWFunction(inherited Add);
  Result.Category    := Trim(Category);
  Result.Caption     := Trim(Caption);
  Result.Description := Trim(Description);
  Result.Template    := Template;
  Result.IsString    := IsString;
end;

constructor TVRWFunctionList.Create;
begin
  inherited Create(TVRWFunction);
end;

function TVRWFunctionList.GetFunction(Category,
  Caption: ShortString): TVRWFunction;
var
  Entry: Integer;
begin
  Result := nil;
  Category := Lowercase(Category);
  Caption  := Lowercase(Caption);
  for Entry := 0 to Count - 1 do
  begin
    if (Lowercase(Items[Entry].Category) = Category) and
       (Lowercase(Items[Entry].Caption)  = Caption)  then
    begin
      Result := Items[Entry];
      Break;
    end;
  end;
end;

function TVRWFunctionList.GetItem(Index: Integer): TVRWFunction;
begin
  Result := TVRWFunction(inherited GetItem(Index));
end;

procedure TVRWFunctionList.SetFunction(Category, Caption: ShortString;
  const Value: TVRWFunction);
var
  Entry: Integer;
begin
  Category := Lowercase(Category);
  Caption  := Lowercase(Caption);
  for Entry := 0 to Count - 1 do
  begin
    if (Lowercase(Items[Entry].Category) = Category) and
       (Lowercase(Items[Entry].Caption)  = Caption)  then
    begin
      Items[Entry].Description := Value.Description;
      Items[Entry].Template    := Value.Template;
      Items[Entry].IsString    := Value.IsString;
      Break;
    end;
  end;
end;

procedure TVRWFunctionList.SetItem(Index: Integer;
  const Value: TVRWFunction);
begin
  inherited SetItem(Index, Value);
end;

end.
