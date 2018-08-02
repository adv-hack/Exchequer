unit ctrlDBFieldProperties;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, TEditVal, Mask, Spin,
  VRWReportIF,
  DesignerTypes,    // Common designer types and interfaces
  ctrlDBField, TCustom, RWOpenF, EnterToTab
  ;

type
  TDBFieldPropertiesMode = (dpmAdd, dpmEdit);

  TfrmDBFieldProperties = class(TForm)
    GroupBox1: TGroupBox;
    Label81: Label8;
    edtFieldCode: Text8Pt;
    Label82: Label8;
    lblFieldDesc: Label8;
    Label84: Label8;
    btnSelectField: TSBSButton;
    lblFieldType: Label8;
    edtPeriod: TEdit;
    edtYear: TEdit;
    cbCurrency: TComboBox;
    lblPeriodYear: Label8;
    lblCurrency: Label8;
    GroupBox2: TGroupBox;
    lblFieldFormat: TLabel;
    cbAlignment: TComboBox;
    chkBlankOnZero: TCheckBox;
    lblDecPlaces: TLabel;
    chkPrintField: TCheckBox;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    GroupBox3: TGroupBox;
    lblFontExample: TLabel;
    btnChangeFont: TSBSButton;
    FontDialog1: TFontDialog;
    EnterToTab1: TEnterToTab;
    chkPercentage: TCheckBox;
    edtDecs: TEdit;
    udDecs: TUpDown;
    lblInputLink: Label8;
    cbInputLink: TComboBox;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edtFieldCodeExit(Sender: TObject);
    procedure btnChangeFontClick(Sender: TObject);
    procedure btnSelectFieldClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FMode : TDBFieldPropertiesMode;
    FDBFieldControl : TVRWDBFieldControl;
    FDictRec : DataDictRec;
    FOriginalField: ShortString;

    Procedure DispFieldInfo;
    Procedure SetDBFieldControl (Value : TVRWDBFieldControl);
  public
    { Public declarations }
    Property DBFieldControl : TVRWDBFieldControl Read FDBFieldControl Write SetDBFieldControl;

    Constructor Create (AOwner: TComponent; Mode : TDBFieldPropertiesMode); Reintroduce;
  end;



// Adds a DB Field control into the specified region at the specified region client co-ords
Function AddDBFieldControl(Const Region : TWinControl; Const X, Y : Integer) : Boolean;

// Displays the properties dialog for the passed DB Field Control, returns TRUE
// if the user Saved the changes or FALSE if they cancelled the dialog
Function DisplayDBFieldOptions (DesignerControl : TVRWDBFieldControl;
  TheForm: TForm = nil) : Boolean;

implementation

{$R *.dfm}

uses
  GlobVar, VarConst, VarFPosU, Btsupu2,
  EntLicence, DDFuncs, GlobalTypes,
  DesignerUtil, Region, SelectDBFieldF, ctrlDrag, CtrlPrms;

//=========================================================================

// Adds a DB Field control into the specified region at the specified region client co-ords
Function AddDBFieldControl(Const Region : TWinControl; Const X, Y : Integer) : Boolean;
Var
  frmDBFieldProperties : TfrmDBFieldProperties;
  NewDBFieldIntf       : IVRWFieldControl;
Begin // AddDBFieldControl
  frmDBFieldProperties := TfrmDBFieldProperties.Create(Application.MainForm, dpmAdd);
  Try
    // Centre the window over the mouse click
    With Region.ClientToScreen(Point(X,Y)) Do CentreOverCoords (frmDBFieldProperties, X, Y);

    // Create new text object in RepEngine.Dll
    NewDBFieldIntf := TRegion(Region).reRegionDets.rgControls.Add(TRegion(Region).reRegionDets.RgReport, ctField) As IVRWFieldControl;

    // Create a new hidden wrapper control for the designer - setup minimum basic info
    frmDBFieldProperties.DBFieldControl := TVRWDBFieldControl.Create (TRegion(Region).reManager, NewDBFieldIntf);
    frmDBFieldProperties.DBFieldControl.Visible := False;
    frmDBFieldProperties.DBFieldControl.ParentRegion := TRegion(Region);
    frmDBFieldProperties.DBFieldControl.SetBounds (X, Y, 90, 21); // LTWH

    Result := (frmDBFieldProperties.ShowModal = mrOK);
    If Result Then
    Begin
      // Need to size intelligently according to the DB Field info and position according to the grid
      frmDBFieldProperties.DBFieldControl.CalcInitialSize (StringOfChar('S', NewDBFieldIntf.vcVarLen));
      frmDBFieldProperties.DBFieldControl.SnapToGrid;

      // Select the control
      TRegion(Region).reManager.SelectControl(frmDBFieldProperties.DBFieldControl, False);

      // Finally, show the control
      frmDBFieldProperties.DBFieldControl.Visible := True;
    End // If Result
    Else
    Begin
      // Cancelled - remove control and destroy RepEngine object
      frmDBFieldProperties.DBFieldControl.Free;
      frmDBFieldProperties.DBFieldControl := NIL;
      TRegion(Region).reRegionDets.rgControls.Delete(NewDBFieldIntf.vcName);
    End; // Else
  Finally
    NewDBFieldIntf := NIL;
    FreeAndNIL(frmDBFieldProperties);
  End; // Try..Finally
End; // AddDBFieldControl

//-------------------------------------------------------------------------

// Displays the properties dialog for the passed DB Field Control, returns TRUE
// if the user Saved the changes or FALSE if they cancelled the dialog
Function DisplayDBFieldOptions (DesignerControl : TVRWDBFieldControl;
  TheForm: TForm) : Boolean;
Var
  frmDBFieldProperties : TfrmDBFieldProperties;
Begin // DisplayDBFieldOptions
  frmDBFieldProperties := TfrmDBFieldProperties.Create(Application.MainForm, dpmEdit);
  Try
    if TheForm <> nil then
      CentreOverForm(frmDBFieldProperties, TheForm)
    else
      CentreOverControl (frmDBFieldProperties, DesignerControl);
    frmDBFieldProperties.DBFieldControl := DesignerControl;
    Result := (frmDBFieldProperties.ShowModal = mrOK);
    If Result Then // DesignerControl.Invalidate;
      DesignerControl.ParentRegion.reManager.UpdateRegionSorts;
  Finally
    FreeAndNIL(frmDBFieldProperties);
  End; // Try..Finally
End; // DisplayDBFieldOptions

//=========================================================================

Constructor TfrmDBFieldProperties.Create (AOwner: TComponent; Mode : TDBFieldPropertiesMode);
Begin // Create
  Inherited Create(AOwner);

  FMode := Mode;

  FOriginalField := Chr(255);

  cbCurrency.Visible := EnterpriseLicence.elIsMultiCcy;
  if cbCurrency.Visible then
    Set_DefaultCurr(cbCurrency.Items, TRUE, TRUE)
  else
    lblCurrency.Visible := False;
End; // Create

//-------------------------------------------------------------------------

procedure TfrmDBFieldProperties.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  If (ModalResult = mrOK) Then
  Begin
    if (Trim(FDictRec.DataVarRec.VarName) = '') then
    begin
      CanClose := False;
      edtFieldCode.SetFocus;
      ShowMessage('No valid field specified');      
    end;
    With FDBFieldControl, DBFieldDets Do
    Begin
      vcFieldName := FDictRec.DataVarRec.VarName;

      vcPeriod := edtPeriod.Text;
      vcYear := edtYear.Text;
      If cbCurrency.Visible And cbCurrency.Enabled Then
        vcCurrency := cbCurrency.ItemIndex
      Else
        vcCurrency := 0;

      Case cbAlignment.ItemIndex Of
        0 : vcFieldFormat := 'L';
        1 : vcFieldFormat := 'C';
        2 : vcFieldFormat := 'R';
      Else
        vcFieldFormat := 'L';
      End; // Case cbAlignment.ItemIndex

      vcVarNoDecs := udDecs.Position;

      If chkBlankOnZero.Checked Then vcFieldFormat := vcFieldFormat + 'B';

      if chkPercentage.Checked then
        vcFieldFormat := vcFieldFormat + '%';

      vcPrintField := chkPrintField.Checked;

      // Duplicate fields from dictionary record - don't know why!
      vcVarNo := FDictRec.DataVarRec.VarNo;
      vcVarLen := FDictRec.DataVarRec.VarLen;
      vcVarDesc := FDictRec.DataVarRec.VarDesc;
      vcVarType := FDictRec.DataVarRec.VarType;


    (*
      property vcSortOrder: ShortString
        read GetVcSortOrder
        write SetVcSortOrder;

      property vcSelectCriteria: ShortString
        read GetVcSelectCriteria
        write SetVcSelectCriteria;

      property vcSubTotal: Boolean
        read GetVcSubTotal
        write SetVcSubTotal;

      property vcPageBreak: Boolean
        read GetVcPageBreak
        write SetVcPageBreak;

      property vcRecalcBreak: Boolean
        read GetVcRecalcBreak
        write SetVcRecalcBreak;

      property vcSelectSummary: Boolean
        read GetVcSelectSummary
        write SetVcSelectSummary;

      property vcInputLine : TInputLineRecord
        read GetVcInputLine
        write SetVcInputLine;

      property vcVarNoDecs: Byte
        read GetVcVarNoDecs
        write SetVcVarNoDecs;

      property vcParsedInputLine: ShortString
        read GetVcParsedInputLine
        write SetVcParsedInputLine;

      property vcFieldIdx: SmallInt
        read GetVcFieldIdx
        write SetVcFieldIdx;

      property vcRangeFilter: IVRWRangeFilter
        read GetVcRangeFilter;
      *)

      // Update the font, also causes a repaint and sets the changed flag
      UpdateFont(lblFontExample.Font);
    End; // With FDBFieldControl
  End; // If (ModalResult = mrOK)
end;

//------------------------------

Procedure TfrmDBFieldProperties.SetDBFieldControl (Value : TVRWDBFieldControl);
Begin // SetDBFieldControl
  FDBFieldControl := Value;

  If Assigned(Value) Then
  Begin
    With FDBFieldControl.DBFieldDets Do
    Begin
      If GetDDField (vcFieldName, FDictRec) Then
      Begin

        DispFieldInfo;

        edtPeriod.Text := vcPeriod;
        edtYear.Text := vcYear;
        If cbCurrency.Visible And cbCurrency.Enabled And (vcCurrency < cbCurrency.Items.Count) Then
          cbCurrency.ItemIndex := vcCurrency
        Else
          cbCurrency.ItemIndex := -1;

        If (Pos('R', UpperCase(vcFieldFormat)) > 0) Then
          cbAlignment.ItemIndex := 2
        Else If (Pos('C', UpperCase(vcFieldFormat)) > 0) Then
          cbAlignment.ItemIndex := 1
        Else
          cbAlignment.ItemIndex := 0;
        udDecs.Position := vcVarNoDecs;

        chkBlankOnZero.Checked := (Pos('B', UpperCase(vcFieldFormat)) > 0);
        chkPrintField.Checked := vcPrintField;

        if vcVarType in [2, 3] then
          chkPercentage.Checked := (Pos('%', vcFieldFormat) > 0)
        else
        begin
          chkPercentage.Checked := False;
          chkPercentage.Enabled := False;
        end;

      End; // If GetDDField (edtFieldCode.Text, FDictRec)

      CopyIFontToFont (FDBFieldControl.ControlDets.vcFont, lblFontExample.Font);
    End; // With FDBFieldControl.DBFieldDets
  End; // If Assigned(Value)
End; // SetDBFieldControl

//-------------------------------------------------------------------------

procedure TfrmDBFieldProperties.edtFieldCodeExit(Sender: TObject);
begin
  If GetDDField (edtFieldCode.Text, FDictRec) Then
  Begin
    DispFieldInfo;
  End // If GetDDField (edtFieldCode.Text, FDictRec)
  Else
  Begin
    { Not a valid field }
    lblFieldType.Caption := '';
  End; { Else }
end;

//------------------------------

Procedure TfrmDBFieldProperties.DispFieldInfo;
var
  i: Integer;
Begin // DispFieldInfo

  if (FOriginalField <> Trim(edtFieldCode.Text)) then
  begin
    // Update the field code in case it was matched on a partial code
    edtFieldCode.Text := Trim(FDictRec.DataVarRec.VarName);

    FOriginalField := Trim(edtFieldCode.Text);

    lblFieldDesc.Caption := Trim(FDictRec.DataVarRec.VarDesc);

    // Check the type and setup the fields appropriately
    If (FDictRec.DataVarRec.VarType <> 0) Then
    Begin
      lblFieldType.Caption := DataTypesL^[FDictRec.DataVarRec.VarType];

      lblPeriodYear.Enabled := FDictRec.DataVarRec.PrSel;
      edtPeriod.Enabled := lblPeriodYear.Enabled;
      edtYear.Enabled := lblPeriodYear.Enabled;
      lblCurrency.Enabled := lblPeriodYear.Enabled;
      cbCurrency.Enabled := lblPeriodYear.Enabled;
      if cbCurrency.Enabled then
        cbCurrency.ItemIndex := 0;

      edtDecs.Enabled := (FDictRec.DataVarRec.VarType In [2, 3]);
      lblDecPlaces.Enabled := edtDecs.Enabled;
      udDecs.Enabled := edtDecs.Enabled;
      chkBlankOnZero.Enabled := edtDecs.Enabled;

      If (FDictRec.DataVarRec.VarType = 1) Then
      Begin
       // Its a String - add length
        lblFieldType.Caption := lblFieldType.Caption + IntToStr (FDictRec.DataVarRec.VarLen);
      End; // If (FDictRec.DataVarRec.VarType = 1)

      If (FDictRec.DataVarRec.VarType In [2, 3]) Then
      Begin
        // Its changed and its a floating point number

        // Check if its a special decs job
        If FDictRec.DataVarRec.VarDec Then
          Case FDictRec.DataVarRec.VarDecType of
            1 : udDecs.Position := Syss.NoCosDec;
            2 : udDecs.Position := Syss.NoNetDec;
            3 : udDecs.Position := Syss.NoQtyDec;
          End {Case..}
        Else
          udDecs.Position := FDictRec.DataVarRec.VarNoDec;

        // Set to right justified
        cbAlignment.ItemIndex := 2;
      End; // If (FDictRec.DataVarRec.VarType In [2, 3]) And Changed

      { Search for any Input Fields that are valid for the selected field, and
        add them to the Input Link combo-box. }
      cbInputLink.Clear;
      with (DBFieldControl.ControlDets.vcReport as IVRWReport3) do
      begin
        for i := 0 to vrInputFields.rfCount - 1 do
        begin
          if vrInputFields.rfItems[i].rfType = FDictRec.DataVarRec.InputType then
          begin
            cbInputLink.Items.Add(vrInputFields.rfItems[i].rfName);
            if (vrInputFields.rfItems[i].rfName = DBFieldControl.DBFieldDets.vcInputLine.rfName) then
              cbInputLink.ItemIndex := i;
          end;
        end;
      end;
      cbInputLink.Enabled := (cbInputLink.Items.Count > 0);
      lblInputLink.Enabled := (cbInputLink.Items.Count > 0);
    End; // If (FDictRec.DataVarRec.VarType <> 0)
  end;
End; // DispFieldInfo

//-------------------------------------------------------------------------

procedure TfrmDBFieldProperties.btnChangeFontClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(lblFontExample.Font);
  If FontDialog1.Execute Then
  Begin
    lblFontExample.Font.Assign(FontDialog1.Font);
  End; // If FontDialog1.Execute
end;

//------------------------------

procedure TfrmDBFieldProperties.btnSelectFieldClick(Sender: TObject);
Var
  frmSelectDBField : TfrmSelectDBField;
begin
//  frmSelectDBField := TfrmSelectDBField.Create(FDBFieldControl.ParentRegion.reManager.rmDesignerForm);
  frmSelectDBField := TfrmSelectDBField.Create(nil);
  Try
    // Disable multi-select
    frmSelectDBField.AllowMultiSelect := True;

    // Set the current field/file to be auto-selected
    frmSelectDBField.AutoSelectField := Uppercase(Trim(edtFieldCode.Text));

    // Link the report detail to DB Field dialog - if the file has changed
    // this will cause the cache'd list to be updated
    frmSelectDBField.ReportFile := FDBFieldControl.ParentRegion.reManager.rmReport.vrMainFileNum;

    If (frmSelectDBField.ShowModal = mrOK) Then
    Begin
      edtFieldCode.Text := frmSelectDBField.DBMultiList1.DesignColumns[0].Items[frmSelectDBField.DBMultiList1.Selected];
      edtFieldCodeExit(Sender);
    End; // If (frmSelectDBField.ShowModal = mrOK)
  Finally
    FreeAndNIL(frmSelectDBField);
  End; // Try..Finally
end;

//-------------------------------------------------------------------------
procedure TfrmDBFieldProperties.btnOKClick(Sender: TObject);
var
  InputField: IVRWInputField;
  i: Integer;
  Report: IVRWReport3;
  InputLine: IVRWInputField;
begin
  if cbInputLink.ItemIndex > -1 then
  begin
    Report := (DBFieldControl.ControlDets.vcReport as IVRWReport3);
    for i := 0 to Report.vrInputFields.rfCount - 1 do
    begin
      if (Report.vrInputFields.rfItems[i].rfName = cbInputLink.Items[cbInputLink.ItemIndex]) then
      begin
        InputField := Report.vrInputFields.rfItems[i];
        InputLine  := DBFieldControl.DBFieldDets.vcInputLine;
        InputLine.rfID := InputField.rfID;
        InputLine.rfName := InputField.rfName;
        InputLine.rfDescription := InputField.rfDescription;
        InputLine.rfType := InputField.rfType;
        InputLine.rfAlwaysAsk := InputField.rfAlwaysAsk;
        InputLine.rfFromValue := InputField.rfFromValue;
        InputLine.rfToValue := InputField.rfToValue;
      end;
    end;
  end;
end;

end.

