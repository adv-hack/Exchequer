unit SortViewConfigurationF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, VarSortV, SortViewU, Contnrs, TEditVal;

type
  TSortViewMode = (svmUnknown, svmAdd, svmEdit);
  TSortViewFilterControl = record
    CheckBox: TCheckBox;
    FieldCombo: TComboBox;
    CompareTypeCombo: TComboBox;
    CompareValueEdit: TEdit;
    CompareValueCombo: TSBSComboBox;
  end;
  TSortViewConfigurationFrm = class(TForm)
    OkBtn: TButton;
    CancelBtn: TButton;
    Label2: TLabel;
    edtSortViewDescr: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label6: TLabel;
    lstPrimarySortOrder: TComboBox;
    chkSecondarySort: TCheckBox;
    lstSecondarySortOrder: TComboBox;
    lstPrimarySortField: TComboBox;
    lstSecondarySortField: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    chkFilter1: TCheckBox;
    { Note: the lstFilter[n]Field and lstFilter[n]CompareType combo-boxes have
      their tag property set to their position in the FilterControls array. This
      is important for some event-handlers attached to the various filter
      controls. }
    lstFilter1Field: TComboBox;
    lstFilter1CompareType: TComboBox;
    lstFilter1CompareValue: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    chkFilter2: TCheckBox;
    lstFilter2Field: TComboBox;
    lstFilter2CompareType: TComboBox;
    lstFilter2CompareValue: TEdit;
    chkFilter3: TCheckBox;
    lstFilter3Field: TComboBox;
    lstFilter3CompareType: TComboBox;
    lstFilter3CompareValue: TEdit;
    chkFilter4: TCheckBox;
    lstFilter4Field: TComboBox;
    lstFilter4CompareType: TComboBox;
    lstFilter4CompareValue: TEdit;
    lstSaveOptions: TComboBox;
    HelpBtn: TButton;
    lstFilter1CompareComboValue: TSBSComboBox;
    lstFilter2CompareComboValue: TSBSComboBox;
    lstFilter3CompareComboValue: TSBSComboBox;
    lstFilter4CompareComboValue: TSBSComboBox;
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure CheckDisplay(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstFilterCompareTypeDropDown(Sender: TObject);
    procedure lstFilterFieldSelect(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);    
  private
    { Private declarations }
    FSortView: TBaseSortView;
    EditControls: TObjectList;
    FilterControls: array[1..8] of TSortViewFilterControl;
    FMode: TSortViewMode;    
    procedure SetSortView(const Value: TBaseSortView);
    procedure UpdateDisplay;
    procedure UpdateSortView;
    procedure UpdateState;
    procedure SetupComparisonTypeList(ListNumber: Integer);
    procedure UpdateComparisonTypeList(ListNumber: Integer);
    procedure SetComparisonComboVisible;
    procedure InitCurrencyControl;
    function CompareValueComboVisible(AFilterField: String): Boolean;
    procedure InitDropDownControl(AValue: String);
    procedure InitStockTypeControl;
    function GetSortCompareValue(AFilterField: String; AItemIndex:Integer): String;
    function GetCompareValueIndex(AFilterField, AValue: String): Integer;
    Function GetStockTypeIndex(VM : Char): Integer;
    procedure InitAccStatusControl; //HV 19/04/2016 2016-R2 ABSEXCH-9497: Drop down list be added when Status is selected to avoid mis-typing the three valid options
    procedure InitAccLedStatusControl;//PL 04/01/2017 2017-R1 ABSEXCH-17809 : Default list values for Status field in Sort View of Trader > Ledger is not correct.
  public
    { Public declarations }
    procedure SetDisplayProperties(SourceFont: TFont; SourceColour: TColor);
    property SortView: TBaseSortView read FSortView write SetSortView;
    property Mode: TSortViewMode read FMode write FMode;
  end;

var
  SortViewConfigurationFrm: TSortViewConfigurationFrm;

implementation

{$R *.dfm}

uses VarConst, ThemeFix, BtSupu2, GlobVar;

Const
  //HV 12/04/2016 2016-R2 ABSEXCH-9505: Stock List Sort Views - add the ability to sort by stock type with dropdown	
  IdxStockType  :  Array[0..2] of Char = (StkStkCode,StkDescCode,StkBillCode);

procedure TSortViewConfigurationFrm.CheckDisplay(Sender: TObject);
var
  i: Integer;
begin
  if (Sender = chkSecondarySort) then
  begin
    FSortView.Sorts[2].svsEnabled := chkSecondarySort.Checked;
    //TG 10/03/2016 2016-R2 ABSEXCH-14583  in purchase and sales transaction sort view secoundary option not saving,implemented in all the other windows too.
    if (chkSecondarySort.Checked) then
    begin
      if (lstSecondarySortField.ItemIndex = -1) then
        lstSecondarySortField.ItemIndex := 0;
    end
    else
      lstSecondarySortField.ItemIndex := -1;
    UpdateState;
  end
  else
  begin
    for i := Low(FilterControls) to High(FilterControls) do
    begin
      if (FilterControls[i].CheckBox <> nil) and
         (FilterControls[i].CheckBox = Sender) then
      begin
        FSortView.Filters[i].svfEnabled := FilterControls[i].CheckBox.Checked;
        UpdateState;
        break;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSortViewConfigurationFrm.FormCreate(Sender: TObject);
begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  // HV 08/04/2016 2016-R2 ABSEXCH-15408: Added code related to ComboBox for Compare value
  ApplyThemeFix (Self);

  EditControls := TObjectList.Create;
  EditControls.OwnsObjects := False;

  EditControls.Add(lstFilter1Field);
  EditControls.Add(lstFilter2Field);
  EditControls.Add(lstFilter3Field);
  EditControls.Add(lstFilter4Field);
  EditControls.Add(lstFilter1CompareType);
  EditControls.Add(lstFilter2CompareType);
  EditControls.Add(lstFilter3CompareType);
  EditControls.Add(lstFilter4CompareType);
  EditControls.Add(lstFilter1CompareValue);
  EditControls.Add(lstFilter2CompareValue);
  EditControls.Add(lstFilter3CompareValue);
  EditControls.Add(lstFilter4CompareValue);
  EditControls.Add(lstPrimarySortField);
  EditControls.Add(lstPrimarySortOrder);
  EditControls.Add(lstSecondarySortField);
  EditControls.Add(lstSecondarySortOrder);
  EditControls.Add(lstSaveOptions);
  EditControls.Add(edtSortViewDescr);
  EditControls.Add(lstFilter1CompareComboValue);
  EditControls.Add(lstFilter2CompareComboValue);
  EditControls.Add(lstFilter3CompareComboValue);
  EditControls.Add(lstFilter4CompareComboValue);

  FilterControls[1].CheckBox := chkFilter1;
  FilterControls[1].FieldCombo := lstFilter1Field;
  FilterControls[1].CompareTypeCombo := lstFilter1CompareType;
  FilterControls[1].CompareValueEdit := lstFilter1CompareValue;
  FilterControls[1].CompareValueCombo := lstFilter1CompareComboValue;

  FilterControls[2].CheckBox := chkFilter2;
  FilterControls[2].FieldCombo := lstFilter2Field;
  FilterControls[2].CompareTypeCombo := lstFilter2CompareType;
  FilterControls[2].CompareValueEdit := lstFilter2CompareValue;
  FilterControls[2].CompareValueCombo := lstFilter2CompareComboValue;

  FilterControls[3].CheckBox := chkFilter3;
  FilterControls[3].FieldCombo := lstFilter3Field;
  FilterControls[3].CompareTypeCombo := lstFilter3CompareType;
  FilterControls[3].CompareValueEdit := lstFilter3CompareValue;
  FilterControls[3].CompareValueCombo := lstFilter3CompareComboValue;

  FilterControls[4].CheckBox := chkFilter4;
  FilterControls[4].FieldCombo := lstFilter4Field;
  FilterControls[4].CompareTypeCombo := lstFilter4CompareType;
  FilterControls[4].CompareValueEdit := lstFilter4CompareValue;
  FilterControls[4].CompareValueCombo := lstFilter4CompareComboValue;
end;

// -----------------------------------------------------------------------------

procedure TSortViewConfigurationFrm.FormDestroy(Sender: TObject);
begin
  EditControls.Free;
end;

// -----------------------------------------------------------------------------

procedure TSortViewConfigurationFrm.lstFilterCompareTypeDropDown(
  Sender: TObject);
begin
  UpdateSortView;
  if (Sender is TComboBox) then
    with (Sender as TComboBox) do
      SetupComparisonTypeList(Tag);
end;

// -----------------------------------------------------------------------------

procedure TSortViewConfigurationFrm.lstFilterFieldSelect(Sender: TObject);
begin
  UpdateSortView;
  if (Sender is TComboBox) then
  begin
    with (Sender as TComboBox) do
      UpdateComparisonTypeList(Tag);
     SetComparisonComboVisible; //HV 08/04/2016 2016-R2 ABSEXCH-15408: Added code related to ComboBox for Compare value
  end;
end;

// -----------------------------------------------------------------------------

procedure TSortViewConfigurationFrm.OkBtnClick(Sender: TObject);
var
  ValidationResult: TSortViewValidationErrorType;
begin
  UpdateSortView;
  case Mode of
    svmAdd: ValidationResult := SortView.ValidateForAdd;
    svmEdit: ValidationResult := SortView.ValidateForEdit(SortViewRec.svrViewID);
  else
    raise Exception.Create('Sort View Configuration dialog has not been assigned a valid mode');
  end;
  if (ValidationResult <> svveOk) then
  begin
    ShowMessage(SortViewValidationErrorMsg[ValidationResult])
  end
  else
    ModalResult := mrOk;
end;

// -----------------------------------------------------------------------------

procedure TSortViewConfigurationFrm.SetDisplayProperties(SourceFont: TFont;
  SourceColour: TColor);
var
  Ctrl: Integer;
begin
  for Ctrl := 0 to EditControls.Count - 1 do
  begin
    if (EditControls[Ctrl] is TEdit) then
    begin
      TEdit(EditControls[Ctrl]).Font.Color := SourceFont.Color;
      TEdit(EditControls[Ctrl]).Font.Name  := SourceFont.Name;
      TEdit(EditControls[Ctrl]).Font.Style := SourceFont.Style;
      TEdit(EditControls[Ctrl]).Color      := SourceColour;
    end
    else if (EditControls[Ctrl] is TComboBox) then
    begin
      TComboBox(EditControls[Ctrl]).Font.Color := SourceFont.Color;
      TComboBox(EditControls[Ctrl]).Font.Name  := SourceFont.Name;
      TComboBox(EditControls[Ctrl]).Font.Style := SourceFont.Style;
      TComboBox(EditControls[Ctrl]).Color      := SourceColour;
    end
    else if (EditControls[Ctrl] is TSBSComboBox) then     //HV 08/04/2016 2016-R2 ABSEXCH-15408: Added code related to ComboBox for Compare value
    begin
      TSBSComboBox(EditControls[Ctrl]).Font.Color := SourceFont.Color;
      TSBSComboBox(EditControls[Ctrl]).Font.Name  := SourceFont.Name;
      TSBSComboBox(EditControls[Ctrl]).Font.Style := SourceFont.Style;
      TSBSComboBox(EditControls[Ctrl]).Color      := SourceColour;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSortViewConfigurationFrm.SetSortView(const Value: TBaseSortView);
var
  i: Integer;
begin
  FSortView := Value;
  if (FSortView <> nil) then
  begin
    Caption := FSortView.ListDesc + ' - Sort View Configuration';
    SortView.PopulateSortFields(lstPrimarySortField.Items);
    SortView.PopulateSortFields(lstSecondarySortField.Items);
    for i := 1 to SortView.FilterCount do
    begin
      if (FilterControls[i].CheckBox <> nil) then
        SortView.PopulateFilterFields(FilterControls[i].FieldCombo.Items);
    end;
    UpdateDisplay;
    UpdateState;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSortViewConfigurationFrm.SetupComparisonTypeList(ListNumber: Integer);
begin
  FilterControls[ListNumber].CompareTypeCombo.Items.Clear;
  FilterControls[ListNumber].CompareTypeCombo.Items.Add('Equals');
  FilterControls[ListNumber].CompareTypeCombo.Items.Add('Not Equals');
  FilterControls[ListNumber].CompareTypeCombo.Items.Add('Less Than');
  FilterControls[ListNumber].CompareTypeCombo.Items.Add('Less Than or Equals');
  FilterControls[ListNumber].CompareTypeCombo.Items.Add('Greater Than');
  FilterControls[ListNumber].CompareTypeCombo.Items.Add('Greater Than or Equals');
  if SortView.FilterDataType[SortView.Filters[ListNumber].svfFieldId] = fdtString then
  begin
    FilterControls[ListNumber].CompareTypeCombo.Items.Add('Starts With');
    FilterControls[ListNumber].CompareTypeCombo.Items.Add('Contains');
  end;
end;

// -----------------------------------------------------------------------------

procedure TSortViewConfigurationFrm.UpdateComparisonTypeList(
  ListNumber: Integer);
begin
  if SortView.FilterDataType[SortView.Filters[ListNumber].svfFieldId] = fdtFloat then
  begin
    { If the current Comparison Type is 'Starts with' or 'Contains' we need
      to clear it, because these are not valid for floating point values. }
    if FilterControls[ListNumber].CompareTypeCombo.ItemIndex > 5 then
      FilterControls[ListNumber].CompareTypeCombo.ItemIndex := -1;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSortViewConfigurationFrm.UpdateDisplay;
var
  i: Integer;
begin
  edtSortViewDescr.Text := Trim(SortView.SortViewDesc);
  lstPrimarySortField.ItemIndex := SortView.Sorts[1].svsFieldId;
  lstSecondarySortField.ItemIndex := SortView.Sorts[2].svsFieldId;
  chkSecondarySort.Checked := SortView.Sorts[2].svsEnabled;
  for i := 1 to SortView.FilterCount do
  begin
    if (FilterControls[i].CheckBox <> nil) then
    begin
      if SortView.Filters[i].svfEnabled then
      begin
        FilterControls[i].CheckBox.Checked := True;
        FilterControls[i].FieldCombo.ItemIndex := SortView.GetListIndexFromFieldID(SortView.Filters[i].svfFieldId);
        FilterControls[i].CompareTypeCombo.ItemIndex := Ord(SortView.Filters[i].svfComparison);
        //HV 08/04/2016 2016-R2 ABSEXCH-15408: Added code related to ComboBox for Compare value
        if CompareValueComboVisible(FilterControls[i].FieldCombo.Text) then
        begin
    		  //HV 12/04/2016 2016-R2 ABSEXCH-9505: Stock List Sort Views - add the ability to sort by stock type with dropdown
          InitDropDownControl(FilterControls[i].FieldCombo.Text);
          try
            FilterControls[i].CompareValueCombo.ItemIndex := GetCompareValueIndex(FilterControls[i].FieldCombo.Text, SortView.Filters[i].svfValue);
          except
            FilterControls[i].CompareValueCombo.ItemIndex := FilterControls[i].CompareValueCombo.Items.IndexOf(SortView.Filters[i].svfValue);
          end;
        end
        else
          FilterControls[i].CompareValueEdit.Text := SortView.Filters[i].svfValue
      end
      else
      begin
        FilterControls[i].CheckBox.Checked := False;
      end;
    end;
  end;
  if (SortView.Sorts[1].svsAscending) then
    lstPrimarySortOrder.ItemIndex := 0
  else
    lstPrimarySortOrder.ItemIndex := 1;
  if (SortView.Sorts[2].svsAscending) then
    lstSecondarySortOrder.ItemIndex := 0
  else
    lstSecondarySortOrder.ItemIndex := 1;
  if (Trim(SortView.UserID) = '') then
    lstSaveOptions.ItemIndex := 1
  else
    lstSaveOptions.ItemIndex := 0;
end;

// -----------------------------------------------------------------------------

procedure TSortViewConfigurationFrm.UpdateSortView;
var
  i: Integer;
  FloatStr: string;
  LCompareValue: string;
begin
  for i := 1 to SortView.FilterCount do
  begin
    if (FilterControls[i].CheckBox <> nil) then
    begin
      LCompareValue:='';
      if FilterControls[i].CheckBox.Checked then
      begin
        SortView.Filters[i].svfEnabled := FilterControls[i].CheckBox.Checked;
        SortView.Filters[i].svfFieldId := SortView.GetFieldIDFromListIndex(FilterControls[i].FieldCombo.ItemIndex);
        SortView.Filters[i].svfComparison := TSortViewFilterComparisonType(FilterControls[i].CompareTypeCombo.ItemIndex);
        //HV 08/04/2016 2016-R2 ABSEXCH-15408: Added code related to ComboBox for Compare value
        if FilterControls[i].CompareValueEdit.Visible then
          LCompareValue := FilterControls[i].CompareValueEdit.Text
        else if FilterControls[i].CompareValueCombo.Visible then
          LCompareValue := GetSortCompareValue(FilterControls[i].FieldCombo.Text, FilterControls[i].CompareValueCombo.ItemIndex);

        SortView.Filters[i].svfValue := LCompareValue;
        FloatStr := Trim(LCompareValue);
        if (Copy(FloatStr, Length(FloatStr), 1) = '-') then
          FloatStr := '-' + Copy(FloatStr, 1, Length(FloatStr) - 1);
        SortView.Filters[i].svfValue := FloatStr;

        if FilterControls[i].CompareValueEdit.Visible then     
          FilterControls[i].CompareValueEdit.Text := FloatStr;
      end
      else
      begin
        SortView.Filters[i].svfEnabled := False;
        SortView.Filters[i].svfFieldId := -1;
        SortView.Filters[i].svfComparison := svfcEqual;
        SortView.Filters[i].svfValue := '';
      end;
    end;
  end;
  SortView.SortViewDesc := edtSortViewDescr.Text;
  SortView.Sorts[1].svsEnabled := True;
  SortView.Sorts[1].svsFieldId := lstPrimarySortField.ItemIndex;
  SortView.Sorts[1].svsAscending := (lstPrimarySortOrder.ItemIndex = 0);

  SortView.Sorts[2].svsEnabled := chkSecondarySort.Checked;
  if SortView.Sorts[2].svsEnabled then
    SortView.Sorts[2].svsFieldId := lstSecondarySortField.ItemIndex
  else
    SortView.Sorts[2].svsFieldId := -1;
  SortView.Sorts[2].svsAscending := (lstSecondarySortOrder.ItemIndex = 0);

  if (lstSaveOptions.ItemIndex = 0) then
    SortView.UserID := FullUserIDKey(EntryRec.Login)
  else
    SortView.UserID := '';

end;

// -----------------------------------------------------------------------------

procedure TSortViewConfigurationFrm.UpdateState;
var
  i: Integer;
begin
  for i := 1 to SortView.FilterCount do
  begin
    if (FilterControls[i].CheckBox <> nil) then
    begin
      if SortView.Filters[i].svfEnabled then
      begin
        FilterControls[i].FieldCombo.Enabled := True;
        FilterControls[i].CompareTypeCombo.Enabled := True;
        FilterControls[i].CompareValueEdit.Enabled := True;
        FilterControls[i].CompareValueCombo.Enabled := True;
      end
      else
      begin
        FilterControls[i].FieldCombo.Enabled := False;
        FilterControls[i].CompareTypeCombo.Enabled := False;
        FilterControls[i].CompareValueEdit.Enabled := False;
        FilterControls[i].CompareValueCombo.Enabled := False;
      end;
    end;
  end;
  lstSecondarySortField.Enabled := chkSecondarySort.Checked;
  lstSecondarySortOrder.Enabled := chkSecondarySort.Checked;
  SetComparisonComboVisible;
end;

procedure TSortViewConfigurationFrm.HelpBtnClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,Self.HelpContext);
end;

//HV 08/04/2016 2016-R2 ABSEXCH-15408: Added code related to ComboBox for Compare value
procedure TSortViewConfigurationFrm.InitCurrencyControl;
var
  Ctrl: Integer;
begin
  for Ctrl := 0 to EditControls.Count - 1 do
  begin
    if (EditControls[Ctrl] is TSBSComboBox) and (TSBSComboBox(EditControls[Ctrl]).Itemindex = -1) then
    begin
      Set_DefaultCurr(TSBSComboBox(EditControls[Ctrl]).Items,BOff,BOff, False);
      Set_DefaultCurr(TSBSComboBox(EditControls[Ctrl]).ItemsL,BOff,BOn, False);
    end;
  end;
end;

procedure TSortViewConfigurationFrm.SetComparisonComboVisible;
var
  i: Integer;
begin
  for i := 1 to SortView.FilterCount do
  begin
    if (FilterControls[i].CheckBox <> nil) then
    begin
      if SortView.Filters[i].svfEnabled then
      begin
        if CompareValueComboVisible(FilterControls[i].FieldCombo.Text) then
        begin
          FilterControls[i].CompareValueCombo.Visible := True;
          FilterControls[i].CompareValueEdit.Visible := False;
    		  //HV 12/04/2016 2016-R2 ABSEXCH-9505: Stock List Sort Views - add the ability to sort by stock type with dropdown
          InitDropDownControl(FilterControls[i].FieldCombo.Text);
        end
        else
        begin
          FilterControls[i].CompareValueEdit.Visible := True;
          FilterControls[i].CompareValueCombo.Visible := False;
        end;
      end
    end;
  end;
end;

function TSortViewConfigurationFrm.CompareValueComboVisible(
  AFilterField: String): Boolean;
var
  i: Integer;
begin
  CompareValueComboVisible:=False;
  for i:= Ord(Low(CompareValueComboForFilterField)) to Ord(High(CompareValueComboForFilterField)) do
  begin
    if CompareValueComboForFilterField[i] = AFilterField then
    begin
      CompareValueComboVisible:= True;
      Break;
    end;
  end;
end;

//HV 12/04/2016 2016-R2 ABSEXCH-9505: Stock List Sort Views - add the ability to sort by stock type with dropdown
// Stock Type value append in to dropdown control
procedure TSortViewConfigurationFrm.InitStockTypeControl;
var
  Ctrl: Integer;
begin
{$IFDEF STK}
  for Ctrl := 0 to EditControls.Count - 1 do
  begin
    if (EditControls[Ctrl] is TSBSComboBox) and (TSBSComboBox(EditControls[Ctrl]).Itemindex = -1) then
    begin
      Set_DefaultStkT(TSBSComboBox(EditControls[Ctrl]).Items,BOff,BOff,True);
      Set_DefaultStkT(TSBSComboBox(EditControls[Ctrl]).ItemsL,BOff,BOff,True);
    end;
  end;
{$ENDIF}
end;

//Init Dropdown control based on selected filter field Value
procedure TSortViewConfigurationFrm.InitDropDownControl(AValue: String);
begin
  if AValue = CompareValueComboForFilterField[0] then
    InitCurrencyControl
  else if AValue = CompareValueComboForFilterField[1] then
    InitStockTypeControl
  //PL 04/01/2017 2017-R1 ABSEXCH-17809 : Default list values for Status field in Sort View of Trader > Ledger is not correct.
  else if ((AValue = CompareValueComboForFilterField[2]) and (FSortView.ListType in [svltCustomer,svltSupplier,svltConsumer])) then
    InitAccStatusControl
  else if ((AValue = CompareValueComboForFilterField[2]) and (FSortView.ListType in [svltCustLedger,svltSuppLedger,svltConsumerLedger])) then
    InitAccLedStatusControl;
end;

//Store SortView value from dropdown itemindex
function TSortViewConfigurationFrm.GetSortCompareValue(
  AFilterField: String; AItemIndex: Integer): String;
begin
  GetSortCompareValue:='-1';
  if AFilterField = CompareValueComboForFilterField[0] then
    GetSortCompareValue:=IntToStr(Succ(AItemIndex))
  else if (AFilterField = CompareValueComboForFilterField[1]) and (AItemIndex <> -1) then
    GetSortCompareValue:=IdxStockType[AItemIndex]
  else if AFilterField = CompareValueComboForFilterField[2] then
    GetSortCompareValue:=IntToStr(AItemIndex);
end;

//Restore Itemindex in dropdown from SortView
function TSortViewConfigurationFrm.GetCompareValueIndex(AFilterField,
  AValue: String): Integer;
begin
  GetCompareValueIndex:=-1;
  if AFilterField = CompareValueComboForFilterField[0] then
    GetCompareValueIndex:=Pred(StrToInt(AValue))
  else if AFilterField = CompareValueComboForFilterField[1] then
    GetCompareValueIndex:= GetStockTypeIndex(AValue[1])
  else if AFilterField = CompareValueComboForFilterField[2] then
    GetCompareValueIndex:=StrToInt(AValue)
end;

// Get Stock Type dropdown itemindex from stock type code
function TSortViewConfigurationFrm.GetStockTypeIndex(VM: Char): Integer;
begin
  Result:=-1;
  If (VM=StkStkCode) then
    Result:=0
  else If (VM=StkDescCode) then
    Result:=1
  else If (VM=StkBillCode) then
    Result:=2;
end;

//HV 19/04/2016 2016-R2 ABSEXCH-9497: Drop down list be added when Status is selected to avoid mis-typing the three valid options
// Cust/Supp Account Status value append in to dropdown control
procedure TSortViewConfigurationFrm.InitAccStatusControl;
var
  Ctrl: Integer;
begin
  for Ctrl := 0 to EditControls.Count - 1 do
  begin
    if (EditControls[Ctrl] is TSBSComboBox) and (TSBSComboBox(EditControls[Ctrl]).Itemindex = -1) then
    begin
      Set_DefaultAccStatus(TSBSComboBox(EditControls[Ctrl]).Items,BOff,BOff);
      Set_DefaultAccStatus(TSBSComboBox(EditControls[Ctrl]).ItemsL,BOff,BOff);
    end;
  end;
end;

//PL 04/01/2017 2017-R1 ABSEXCH-17809 : Default list values for Status field in Sort View of Trader > Ledger is not correct.
procedure TSortViewConfigurationFrm.InitAccLedStatusControl;
var
  Ctrl: Integer;
begin
  for Ctrl := 0 to EditControls.Count - 1 do
  begin
    if (EditControls[Ctrl] is TSBSComboBox) and (TSBSComboBox(EditControls[Ctrl]).Itemindex = -1) then
    begin
      Set_DefaultAccLedStatus(TSBSComboBox(EditControls[Ctrl]).Items,BOff,BOff);
      Set_DefaultAccLedStatus(TSBSComboBox(EditControls[Ctrl]).ItemsL,BOff,BOff);
    end;
  end;
end;  
end.

