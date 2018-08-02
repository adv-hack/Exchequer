unit frmVRWRangeFilterDetailsU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EnterToTab, StdCtrls, ExtCtrls, uMultiList, CtrlPrms, Mask,
  TEditVal, VRWReportIF;

Type
  TMultiListItem = Class(TObject)
  Private
    // Datatype of source within the report
    FDataType : Byte;

    // Location of Range Filter within the Report
    FLocation : ShortString;

    FOriginalName: ShortString;

    // Contents
    FContents: IVRWBaseInputField;

    Function GetDesc : ShortString;
    Procedure SetDesc (Value : ShortString);
    Function GetType : SmallInt;
    Procedure SetType (Value : SmallInt);
    Function GetTypeString : ShortString;
    Function GetRangeFrom : ShortString;
    Procedure SetRangeFrom (Value : ShortString);
    Function GetRangeFromString : ShortString;
    Function GetRangeTo : ShortString;
    Procedure SetRangeTo (Value : ShortString);
    Function GetRangeToString : ShortString;
    Function GetAsk : Boolean;
    Procedure SetAsk (Value : Boolean);

    // Returns a nicely formatted equivalent of the Range data
    Function GetRangeString (RangeData : ShortString) : ShortString;

    function GetName: ShortString;
    procedure SetName(const Value: ShortString);
  public
    // Reference to parent multi-list and index of item with the list
    FList : TMultiList;

    Property rfLocation : ShortString Read FLocation;
    property rfName: ShortString read GetName write SetName;
    Property rfDesc : ShortString Read GetDesc Write SetDesc;
    Property rfType : SmallInt Read GetType Write SetType;
    Property rfTypeString : ShortString Read GetTypeString;
    Property rfRangeFrom : ShortString Read GetRangeFrom Write SetRangeFrom;
    Property rfRangeFromString : ShortString Read GetRangeFromString;
    Property rfRangeTo : ShortString Read GetRangeTo Write SetRangeTo;
    Property rfRangeToString : ShortString Read GetRangeToString;
    Property rfAsk : Boolean Read GetAsk Write SetAsk;
    Property rfDataType : Byte Read FDataType;

    Procedure AddToList (TargetList: TMultiList);
    Procedure Clear;

    // Returns TRUE if the Range Start value <= Range End value
    Function CheckAscendingValues : Boolean;
  End; // TRangeFilter

  // ===========================================================================

  TRangeFilter = Class(TMultiListItem)
  public
    constructor Create (const Location : ShortString; const DataType : Byte;
      const RangeFilter: IVRWRangeFilter);
  end;

  // ===========================================================================

  TInputField = class(TMultiListItem)
  public
    constructor Create(Field: IVRWInputField);
  end;

  // ===========================================================================

  TfrmVRWRangeFilterDetails = class(TForm)
    pnlInputType: TPanel;
    lblInputType: TLabel;
    cbInputType: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    EnterToTab1: TEnterToTab;
    lblRFDesc: Label8;
    edtRFDesc: Text8Pt;
    lblRFFrom: Label8;
    lblRFTo: Label8;
    chkRFAskUser: TCheckBox;
    lblName: Label8;
    edtRFName: Text8Pt;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbInputTypeClick(Sender: TObject);
    procedure OnExitLookup(Sender: TObject);
  private
    { Private declarations }
    FItem : TMultiListItem;
    FDesignTime : Boolean;
    FRWVersionNo : Byte;

    FLocation : ShortString;

    FRFType : Byte;

    // References to dynamically created controls for the From/To Range
    FromField, ToField : TWinControl;

    Procedure SetItem (Value : TMultiListItem);
    Procedure SetLocation (Value : ShortString);
    Procedure SetDesignTime (Value : Boolean);
    function GetItemName: ShortString;
    procedure SetItemName(const Value: ShortString);
    procedure OnSelectDataType;
  public
    { Public declarations }
    Property DesignTime : Boolean Read FDesignTime Write SetDesignTime;
    Property Location : ShortString Read FLocation Write SetLocation;
    property ItemName: ShortString read GetItemName write SetItemName;
    Property Item : TMultiListItem Read FItem Write SetItem;
  end;

Function DisplayRangeFilter(Control: IVRWFieldControl) : Boolean;
Function DisplayInputField(Field: IVRWInputField): Boolean;

implementation

{$R *.dfm}

Uses VarConst, VarFPosU, ETDateU, BTSupU2, EntLicence, InvListU;

// =============================================================================

Function DisplayRangeFilter(Control: IVRWFieldControl) : Boolean;
var
  Dlg: TfrmVRWRangeFilterDetails;
  RangeFilter: TRangeFilter;
begin
  Dlg := TfrmVRWRangeFilterDetails.Create(nil);
  try
    RangeFilter := TRangeFilter.Create(
                     Control.vcFieldName,
                     Control.vcVarType,
                     Control.vcRangeFilter
                   );
    Dlg.Item := RangeFilter;
    Dlg.DesignTime  := True;
    Dlg.Location    := Control.vcFieldName;
    Result := (Dlg.ShowModal = mrOK);
    if (Result) then
      Control.vcRangeFilter.rfName := 'RF_' + Control.vcName;
  finally
    Dlg.Free;
  end;
end;

// =============================================================================

Function DisplayInputField(Field: IVRWInputField): Boolean;
var
  Dlg: TfrmVRWRangeFilterDetails;
  InternalField: TInputField;
begin
  Dlg := TfrmVRWRangeFilterDetails.Create(nil);
  try
    InternalField := TInputField.Create(Field);
    Dlg.Item := InternalField;
    Dlg.DesignTime  := True;
    Dlg.Location    := InternalField.rfLocation;
    Dlg.ItemName    := InternalField.rfName;
    Dlg.ActiveControl := Dlg.edtRFName;
    Dlg.Caption := 'Input Field';
    Dlg.lblName.Caption := 'Name';

    Result := (Dlg.ShowModal = mrOK);
//    if (Result) then
//      Control.vcRangeFilter.rfName := 'RF_' + Control.vcName;
  finally
    Dlg.Free;
  end;
end;

// =============================================================================
// TRangeFilter
// =============================================================================

constructor TRangeFilter.Create (Const Location : ShortString;
  const DataType : Byte; const RangeFilter: IVRWRangeFilter);
Begin // Create
  Inherited Create;
  FDataType := DataType;
  FLocation := Location;
  FOriginalName := Location;
  FContents := RangeFilter;
End; // Create

// =============================================================================
// TMultiListItem
// =============================================================================

Procedure TMultiListItem.AddToList(TargetList: TMultiList);
Begin // AddToList
  FList := TargetList;

  If Assigned(FList) Then
  Begin
    FList.DesignColumns[0].Items.AddObject(rfLocation, Self);  // Location
    Try
      FList.DesignColumns[1].Items.Add(rfDesc);            // Description
      FList.DesignColumns[2].Items.Add(rfTypeString);      // Type
      FList.DesignColumns[3].Items.Add(rfRangeFromString); // Range From
      FList.DesignColumns[4].Items.Add(rfRangeToString);   // Range To

      If rfAsk Then
        FList.DesignColumns[5].Items.Add('Yes')       // Ask
      Else
        FList.DesignColumns[5].Items.Add('No');       // Ask
    Except
      On E:Exception Do
        FList.DesignColumns[1].Items.Add(E.Message);
    End; // Try..Except
  End; // If Assigned(FList)
End; // AddToList

// -----------------------------------------------------------------------------

Procedure TMultiListItem.Clear;
Begin // Clear
  FContents.rfName := '';
  FContents.rfDescription := '';
  FContents.rfType := 0;
  FContents.rfAlwaysAsk := False;
  FContents.rfFromValue := '';
  FContents.rfToValue := '';
End; // Clear

// -----------------------------------------------------------------------------

Function TMultiListItem.GetDesc : ShortString;
Begin // GetType
  Result := FContents.rfDescription;
End; // GetType

// -----------------------------------------------------------------------------

Procedure TMultiListItem.SetDesc(Value : ShortString);
Begin // SetDesc
  FContents.rfDescription := Value;
  If Assigned(FList) Then
    FList.DesignColumns[1].Items[FList.DesignColumns[0].Items.IndexOf(FOriginalName)] := rfDesc;
End; // SetDesc

// -----------------------------------------------------------------------------

Function TMultiListItem.GetAsk: Boolean;
Begin // GetType
  Result := FContents.rfAlwaysAsk;
End; // GetType

// -----------------------------------------------------------------------------

function TMultiListItem.GetName: ShortString;
begin
  Result := FContents.rfName;
end;

// -----------------------------------------------------------------------------

Function TMultiListItem.GetRangeTo: ShortString;
Begin // GetType
  Result := FContents.rfToValue;
End; // GetType

// -----------------------------------------------------------------------------

Function TMultiListItem.GetType: SmallInt;
Begin // GetType
  Result := FContents.rfType
End; // GetType

// -----------------------------------------------------------------------------

Procedure TMultiListItem.SetType(Value : SmallInt);
Begin // SetType
  FContents.rfType := Value;
  If Assigned(FList) Then
    FList.DesignColumns[2].Items[FList.DesignColumns[0].Items.IndexOf(FOriginalName)] := rfTypeString;
End; // SetType

// -----------------------------------------------------------------------------

Function TMultiListItem.GetTypeString : ShortString;
Begin // GetTypeString
  // MH 25/04/05: Added check as this was crsahing with a corrupted range filter
  If (FContents.rfType >= Low(RepInpTypesL^)) And (FContents.rfType <= High(RepInpTypesL^)) Then
    Result := RepInpTypesL^[FContents.rfType]
  Else
    Result := 'Error: Invalid Type (' + IntToStr(FContents.rfType) + ')';
End; // GetTypeString

// -----------------------------------------------------------------------------

Function TMultiListItem.GetRangeFrom: ShortString;
Begin // GetType
  Result := FContents.rfFromValue;
End; // GetType

// -----------------------------------------------------------------------------

Procedure TMultiListItem.SetRangeFrom(Value : ShortString);
Begin // SetRangeFrom
  FContents.rfFromValue := Value;
  If Assigned(FList) Then
    FList.DesignColumns[3].Items[FList.DesignColumns[0].Items.IndexOf(FOriginalName)] := rfRangeFromString;
End; // SetRangeFrom

// -----------------------------------------------------------------------------

// Returns a nicely formatted equivalent of the Range data
Function TMultiListItem.GetRangeString(RangeData : ShortString) : ShortString;
Begin // GetRangeString
  // Can't use trim as currencies are stored as binary
  If (Length(RangeData) > 0) Then
  Begin
    Case FContents.rfType Of
      // Date - DDMMYYYY
      1  : Begin
             Result := POutDate(Copy(RangeData, 5, 4) + Copy (RangeData, 3, 2) + Copy (RangeData, 1, 2));

           End; // Date

      // Period - MMYYYY
      2  : Begin
             Result := Copy(RangeData, 1, 2) + '/' + Copy (RangeData, 3, 4);
           End; // Period

      // Currency
      5  : With SyssCurr^.Currencies[Ord(RangeData[1])] Do
             Result := SSymb + ' - ' + Desc;
    Else
      Result := RangeData;
    End; // Case FRangeFilter.rfType
  End // If (Trim(RangeData) <> '')
  Else
    // MH 18/04/05: Added Else as was getting corrupted output with blank values
    Result := '';
End; // GetRangeString

// -----------------------------------------------------------------------------

// Returns a nicely formatted equivalent of the Range From data
Function TMultiListItem.GetRangeFromString : ShortString;
Begin // GetRangeFromString
  Result := GetRangeString (FContents.rfFromValue);
End; // GetRangeFromString

// -----------------------------------------------------------------------------

// Returns a nicely formatted equivalent of the Range To data
Function TMultiListItem.GetRangeToString : ShortString;
Begin // GetRangeToString
  Result := GetRangeString (FContents.rfToValue);
End; // GetRangeToString

// -----------------------------------------------------------------------------

// Returns TRUE if the Range Start value <= Range End value
Function TMultiListItem.CheckAscendingValues : Boolean;
Var
  s1, s2 : ShortString;
  d1, d2 : Double;
Begin // CheckAscendingValues
  Case FContents.rfType Of
    // Date - DDMMYYYY - Check as YYYYMMDD
    1  : Begin
           s1 := Copy(FContents.rfFromValue, 5, 4) + Copy (FContents.rfFromValue, 3, 2) + Copy (FContents.rfFromValue, 1, 2);
           s2 := Copy(FContents.rfToValue, 5, 4) + Copy (FContents.rfToValue, 3, 2) + Copy (FContents.rfToValue, 1, 2);
           Result := (s1 <= s2);
         End; // Date

    // Period - MMYYYY - Check as YYYYMM
    2  : Begin
           s1 := Copy (FContents.rfFromValue, 3, 4) + Copy(FContents.rfFromValue, 1, 2);
           s2 := Copy (FContents.rfToValue, 3, 4) + Copy(FContents.rfToValue, 1, 2);
           Result := (s1 <= s2);
         End; // Period

    // Value
    3  : Begin
           // Need to swap -ve sign to front and remove thousands separators before converting
           // to float and comparing
           s1 := FContents.rfFromValue;
           If (Pos ('-', s1) > 0) Then
           Begin
             Delete (s1, Pos ('-', s1), 1);
             s1 := '-' + s1;
           End; // If (Pos ('-', s1) > 0)
           While (Pos (ThousandSeparator, s1) > 0) Do
             Delete (s1, Pos (ThousandSeparator, s1), 1);
           d1 := StrToFloatDef(s1, 0.00);

           s2 := FContents.rfToValue;
           If (Pos ('-', s2) > 0) Then
           Begin
             Delete (s2, Pos ('-', s2), 1);
             s2 := '-' + s2;
           End; // If (Pos ('-', s2) > 0)
           While (Pos (ThousandSeparator, s2) > 0) Do
             Delete (s2, Pos (ThousandSeparator, s2), 1);
           d2 := StrToFloatDef(s2, 0.00);

           Result := (d1 <= d2);
         End; // Value
  Else
    Result := (FContents.rfFromValue <= FContents.rfToValue);
  End; // Case FRangeFilter.rfType
End; // CheckAscendingValues

// -----------------------------------------------------------------------------

Procedure TMultiListItem.SetAsk(Value: Boolean);
Begin // SetAsk
  FContents.rfAlwaysAsk := Value;
  If Assigned(FList) Then
  Begin
    If rfAsk Then
      FList.DesignColumns[5].Items[FList.DesignColumns[0].Items.IndexOf(FOriginalName)] := 'Yes'
    Else
      FList.DesignColumns[5].Items[FList.DesignColumns[0].Items.IndexOf(FOriginalName)] := 'No';
  End; // If Assigned(FList)
End; // SetAsk

// -----------------------------------------------------------------------------

procedure TMultiListItem.SetName(const Value: ShortString);
begin
  if (FOriginalName = '') then
    FOriginalName := Value;
  FContents.rfName := Value;
  FLocation := Value;
end;

// -----------------------------------------------------------------------------

Procedure TMultiListItem.SetRangeTo(Value: ShortString);
Begin // SetRangeTo
  FContents.rfToValue := Value;
  If Assigned(FList) Then
    FList.DesignColumns[4].Items[FList.DesignColumns[0].Items.IndexOf(FOriginalName)] := rfRangeToString;
End; // SetRangeTo

// -----------------------------------------------------------------------------

// =============================================================================
// TInputField
// =============================================================================

constructor TInputField.Create(Field: IVRWInputField);
begin
  inherited Create;
  FDataType   := Field.rfType;
  FLocation   := Field.rfName;
  FOriginalName := Field.rfName;
  FContents   := Field;
end;

// -----------------------------------------------------------------------------

// =============================================================================

procedure TfrmVRWRangeFilterDetails.FormCreate(Sender: TObject);
begin
  // Work out the version of the RW
  if EnterpriseLicence.elIsMultiCcy then
  begin
    FRWVersionNo := 7;
    if (EnterpriseLicence.elModules[ModJobCost] <> mrNone) then
      FRWVersionNo := FRWVersionNo + 2;
  end
  else
  begin
    FRWVersionNo := 3;
    if (EnterpriseLicence.elModules[ModJobCost] <> mrNone) then
      FRWVersionNo := FRWVersionNo + 1;
  end;

  FRWVersionNo := FRWVersionNo + Byte(EnterpriseLicence.elModuleVersion);

  FDesignTime := True;
  FLocation := '';
  FRFType := 0;
end;

// -----------------------------------------------------------------------------

procedure TfrmVRWRangeFilterDetails.btnOKClick(Sender: TObject);
Var
  sTo, sFrom : ShortString;
  OK : Boolean;
  FromDate, ToDate: string;
begin
  // Move focus to OK button - some controls don't process the value
  // properly until they lose focus
  If btnOK.CanFocus Then btnOK.SetFocus;

  OK := (Trim(edtRFDesc.Text) <> '');
  If (Not OK) Then
  Begin
    MessageDlg ('The Description must be set', mtWarning, [mbOk], 0);
    If edtRFDesc.CanFocus Then edtRFDesc.SetFocus;
  End; // If (Not OK)

  If OK Then
  Begin
    // Update the Range filter
    FItem.rfName := Trim(edtRFName.Text);
    FItem.rfDesc := Trim(edtRFDesc.Text);
    FItem.rfType := FRFType;
    FItem.rfAsk := chkRFAskUser.Checked;

    // Cache up the original values incase the validation fails
    sFrom := FItem.rfRangeFrom;
    sTo := FItem.rfRangeTo;

    if (FromField is TEditDate) then
    begin
      // Date
      FromDate := (FromField As TEditDate).DateValue;
      ToDate := (ToField As TEditDate).DateValue;

      // Swap the date value from yyyymmdd into ddmmyyyy
      FItem.rfRangeFrom := Copy(FromDate, 7, 2) + Copy(FromDate, 5, 2) + Copy(FromDate, 1, 4);
      FItem.rfRangeTo := Copy(ToDate, 7, 2) + Copy(ToDate, 5, 2) + Copy(ToDate, 1, 4);

    end
    else If (FromField Is TMaskEdit) Then
    Begin
      // Date, Period
      FItem.rfRangeFrom := (FromField As TMaskEdit).Text;
      FItem.rfRangeTo := (ToField As TMaskEdit).Text;
    End // If (FromField Is TMaskEdit)
    Else If (FromField Is TEdit) Then
    Begin
      // ASCII, Document No, Cust/Supp, GLCode, Stock, DD/Dept, Loc, Job, Bin
      FItem.rfRangeFrom := (FromField As TEdit).Text;
      FItem.rfRangeTo := (ToField As TEdit).Text;
    End // If (FromField Is TEdit)
    Else If (FromField Is TSBSComboBox) Then
    Begin
      // Currency
      FItem.rfRangeFrom := Chr((FromField As TSBSComboBox).ItemIndex);
      FItem.rfRangeTo := Chr((ToField As TSBSComboBox).ItemIndex);
    End // If (FromField Is TSBSComboBox)
    Else If (FromField Is TCurrencyEdit) Then
    Begin
      // Value
      FItem.rfRangeFrom := (FromField As TCurrencyEdit).Text;
      FItem.rfRangeTo := (ToField As TCurrencyEdit).Text;
    End; // If (FromField Is TSBSComboBox)

    // Input fields only need to specify the Range From.
    if (FItem is TInputField) then
    begin
      ModalResult := mrOk;
    end
    // Check that End >= Start unless blanks specified at design time
    else if FItem.CheckAscendingValues Or (FDesignTime And ((FItem.rfRangeFrom = '') Or (FItem.rfRangeTo = ''))) Then
    Begin
      ModalResult := mrOK;
    End // If FRangeFilter.CheckAscendingValues Or (...
    Else
    Begin
      FItem.rfRangeFrom := sFrom;
      FItem.rfRangeTo := sTo;
      MessageDlg ('The Start value cannot be greater than the End value.', mtError, [mbOK], 0);
      If ToField.CanFocus Then ToField.SetFocus;
    end; // Else
  End; // If OK
end;

// -----------------------------------------------------------------------------

Procedure TfrmVRWRangeFilterDetails.SetItem (Value : TMultiListItem);
Var
  bAddType  : Boolean;
  iDataType : SmallInt;

  function AppropriateToField(const siInputType : SmallInt) : Boolean;
  begin
    if (FItem is TInputField) then
      Result := (siInputType in [1,3,4,6,7,8,9,10,11,12,13,14,15,16,17])
    else
    Case FItem.rfDataType of
      // None, just in case.
      0 : Result := FALSE;
      // string
      1  : Result := (siInputType in [4,6,7,8,9,10,11,12,13,14,15,16,17]);
      // real
      2  : Result := (siInputType in [3]);
      // double
      3  : Result := (siInputType in [3]);
      // date
      4  : Result := (siInputType in [1]);
      // char
      5  : Result := (siInputType in [4]);
      // longint
      6  : Result := (siInputType in [3,4]);
      // integer
      7  : Result := (siInputType in [3,4]);
      // byte
      8  : Result := (siInputType in [3,4]);
      // currency
      9  : Result := (siInputType in [5]);
      // period - HM 22/03/05: Changed so it only supports value as Period/Year
      // range filters don't work on a period field, e.g. THPERIOD, as there is
      // no year element.  Period Filters only apply to the period index.
      10 : Result := (siInputType in [3]);
      // Yes/No
      11 : Result := (siInputType in [4]);
      // Time
      12 : Result := (siInputType in [1]);
    Else
      // all others. In case it gets expanded and least we let them thru.
      Result := TRUE;
    End; // Case FRangeFilter.rfDataType
  end;

Begin // SetRangeFilter
  FItem := Value;

  edtRFDesc.Text := FItem.rfDesc;

  // Load the input line type combo box only listing those applicable to the DB Fields data type
  If (FItem.rfDataType <> 255) Then
  Begin
    cbInputType.Items.Clear;
    For iDataType := Low(RepInpTypesL^) to High(RepInpTypesL^) Do
    Begin
      Case iDataType of
        // Currency
        5   : bAddType := AppropriateToField(iDataType) and (FRWVersionNo >= 7);

        // Stock Code
        10  : bAddType := AppropriateToField(iDataType) and (FRWVersionNo in [2, 4..6, 8..11]);

        // Cost Centre Code, Department Code
        11,
        12  : bAddType := AppropriateToField(iDataType) and (FRWVersionNo >= 3);

        // Location Code
        13  : bAddType := AppropriateToField(iDataType) and (FRWVersionNo in [5, 6, 9, 11]);

        // Serial No.
        14  : bAddType := FALSE;

        // Batch No.
        15  : bAddType := FALSE;

        // Fixed Asset No.
        16  : bAddType := FALSE;

        // Job Code
        17  : bAddType := AppropriateToField(iDataType) and (FRWVersionNo in [6, 11]);
      Else
        bAddType := AppropriateToField(iDataType);
      End; // Case iDataType

      if bAddType then
        cbInputType.Items.Add(RepInpTypesL^[iDataType]);
    End; // For iDataType

    If (FItem.rfType >= Low(RepInpTypesL^)) And (FItem.rfType <= High(RepInpTypesL^)) Then
    Begin
      // Try to select the correct item
      iDataType := cbInputType.Items.IndexOf(RepInpTypesL^[FItem.rfType]);
      If (iDataType >= 0) Then
      Begin
        cbInputType.ItemIndex := iDataType;
      End; // If (iDataType >= 0)
    End; // If (iDataType >= 0)
  End // If (FRangeFilter.rfDataType <> 255)
  Else
  Begin
    if (FItem.rfType in [7, 8]) then
    begin
      cbInputType.Items.Add(RepInpTypesL^[7]);
      cbInputType.Items.Add(RepInpTypesL^[8]);
    end
    else
      cbInputType.Items.Add(RepInpTypesL^[FItem.rfType]);
    // Try to select the correct item
    iDataType := cbInputType.Items.IndexOf(RepInpTypesL^[FItem.rfType]);
    If (iDataType >= 0) Then
    Begin
      cbInputType.ItemIndex := iDataType;
    End; // If (iDataType >= 0)
  End; // Else

  If (cbInputType.Items.Count = 1) Then
  Begin
    cbInputType.ItemIndex := 0;
    cbInputType.Enabled := False;
    cbInputType.Color := clBtnFace;
  End; // If (cbInputType.Items.Count = 1)
  OnSelectDataType;
//  cbInputTypeClick(Self);

  chkRFAskUser.Checked := FItem.rfAsk;

End; // SetRangeFilter

// -----------------------------------------------------------------------------

Procedure TfrmVRWRangeFilterDetails.SetDesignTime (Value : Boolean);
Begin // SetDesignTime
  If (FDesignTime <> Value) Then
  Begin
    FDesignTime := Value;

    If (Not FDesignTime) Then
    Begin
      edtRFDesc.Enabled := False;
      edtRFDesc.Color := clBtnFace;

      cbInputType.Enabled := False;
      cbInputType.Color := clBtnFace;

      chkRFAskUser.Enabled := False;
    End; // If (Not FDesignTime)
  End; // If (FDesignTime <> Value)
End; // SetDesignTime

// -----------------------------------------------------------------------------

Procedure TfrmVRWRangeFilterDetails.SetLocation (Value : ShortString);
Begin // SetLocation
  FLocation := Value;
  lblName.Caption := 'Location';
  edtRFName.Text := FLocation;
  edtRFName.Enabled := False;
  edtRFName.Color := clBtnFace;
  Caption := 'Range Filter Detail - ' + FLocation;
End; // SetLocation

// -----------------------------------------------------------------------------

procedure TfrmVRWRangeFilterDetails.cbInputTypeClick(Sender: TObject);
begin
  OnSelectDataType;
end;

// -----------------------------------------------------------------------------

procedure TfrmVRWRangeFilterDetails.OnExitLookup(Sender: TObject);
var
  FoundCode   : String[20];
  FoundCode10 : string[10];
  FoundNom    : LongInt;
  FoundOk     : Boolean;
begin
  If (ActiveControl <> btnCancel) Then
  Begin
    With TEdit(Sender) Do
    Begin
      If (Trim(Text) <> '') Then
      Begin
        FoundCode := Copy(Text, 1, MaxLength);

        Case Tag Of
          // Customer / Supplier
          7, 8   : FoundOk := GetCust(Self, FoundCode, FoundCode, (Tag = 7), 0);

          // Nominal
          9      : Begin
                     FoundOk := GetNom(Self, FoundCode, FoundNom, 99);
                     If FoundOK Then FoundCode := IntToStr(FoundNom);
                   End; // Nominal

          // Stock
          10     : FoundOk := GetStock(Self, FoundCode, FoundCode, 99);

          // CC / Dept
          11, 12 : FoundOk := GetCCDep(Self, FoundCode, FoundCode, (FRFType = 11), 0);

          // Location
          13     : Begin
                     FoundOk := GetMLoc(Self, FoundCode, FoundCode10, '', 0);
                     If FoundOK Then FoundCode := FoundCode10;
                   End; // Nominal

          // Job
          17     : FoundOk := GetJob(Self, FoundCode, FoundCode, 0);
        Else
          FoundOK := True;
        End; // Case Tag

        if (not FoundOk) then
        begin
          if CanFocus then SetFocus;
        end
        else
          Text := FoundCode;
      end; // if (Trim(Text) <> '') then...
    End; // With TEdit(Sender)
  End; // If (ActiveControl <> btnCancel)
end;

// -----------------------------------------------------------------------------

function TfrmVRWRangeFilterDetails.GetItemName: ShortString;
begin
  Result := edtRFName.Text;
end;

// -----------------------------------------------------------------------------

procedure TfrmVRWRangeFilterDetails.SetItemName(const Value: ShortString);
begin
  edtRFName.Text := Value;
  edtRFName.Enabled := True;
  edtRFName.Color   := clWindow;
  FLocation := Value;
end;

// -----------------------------------------------------------------------------

procedure TfrmVRWRangeFilterDetails.OnSelectDataType;
var
  iInputType: SmallInt;
  X, Y: Integer;

  Procedure SetPeriod (PerField : TEditPeriod; PerText : ShortString);
  Var
    Pr, Yr          : Byte;
    iYr, Err1, Err2 : Integer;
  Begin // SetPeriod
    If (Length(PerText) = 6) Then
    Begin
      Val(Copy(PerText, 1, 2), Pr, Err1);
      Val(Copy(PerText, 3, 4), iYr, Err2);

      If (Err1 = 0) And (Err2 = 0) And (Pr In [0..99]) And (iYr >= 1900) And (iYr <= 2050) Then
      Begin
        Yr := iYr - 1900;
        PerField.InitPeriod (Pr, Yr, True, True);
      End; // If (Err1 = 0) And (Err2 = 0)
    End; // If (Length(PerText) = 6)
  End; // SetPeriod

begin
  // Identify the currently selected datatype
  For iInputType := Low(RepInpTypesL^) To High(RepInpTypesL^) Do
  Begin
    If (cbInputType.Text = RepInpTypesL^[iInputType]) Then
    Begin
      FRFType := iInputType;
      Break;
    End; // If (cbInputType.Text = RepInpTypesL^[iInputType])
  End; // For iInputType

  FItem.rfType := FRFType;
  
  // Remove any previous controls
  If Assigned(FromField) Then
  Begin
    FromField.Destroy;
    FromField := NIL;
  End; // If Assigned(FromField)
  If Assigned(ToField) Then
  Begin
    ToField.Destroy;
    ToField := NIL;
  End; // If Assigned(ToField)

  X := 74;
  Y := cbInputType.Top + cbInputType.Height + 4;

  If (FRFType >= Low(RepInpTypesL^)) And (FRFType <= High(RepInpTypesL^)) Then
  Begin
    Case FRFType of
      1  : Begin // Date
             FromField := TEditDate.Create(Self);
             With FromField As TEditDate Do
             Begin
               Parent := pnlInputType;
               SetBounds (X, Y, 80, 22); // LTWH
               TabOrder := 3;
               DateValue := Copy(FItem.rfRangeFrom, 5, 4) + Copy(FItem.rfRangeFrom, 3, 2) + Copy(FItem.rfRangeFrom, 1, 2);
             End; // With FromField As TEditDate

             Y := Y + 26;

             ToField := TEditDate.Create(Self);
             With ToField As TEditDate Do
             Begin
               Parent := pnlInputType;
               SetBounds (X, Y, 80, 22); // LTWH
               TabOrder := 4;
               DateValue := Copy(FItem.rfRangeTo, 5, 4) + Copy(FItem.rfRangeTo, 3, 2) + Copy(FItem.rfRangeTo, 1, 2);
             End; // With ToField As TEditDate
           End; // Date
      2  : Begin // Period
             FromField := TEditPeriod.Create(Self);
             With FromField As TEditPeriod Do
             Begin
               Parent := pnlInputType;
               SetBounds (X, Y, 80, 22); // LTWH
               TabOrder := 3;

               SetPeriod (FromField As TEditPeriod, FItem.rfRangeFrom);
             End; // With FromField As TEditPeriod

             Y := Y + 26;

             ToField := TEditPeriod.Create(Self);
             With ToField As TEditPeriod Do
             Begin
               Parent := pnlInputType;
               SetBounds (X, Y, 80, 22); // LTWH
               TabOrder := 4;

               SetPeriod (ToField As TEditPeriod, FItem.rfRangeTo);
             End; // With ToField As TEditPeriod
           End; // Period
      3  : Begin // Value
             FromField := TCurrencyEdit.Create(Self);
             With FromField As TCurrencyEdit Do
             Begin
               Parent := pnlInputType;
               SetBounds (X, Y, 80, 22); // LTWH
               TabOrder := 3;
//               Text := Trim(FRangeFilter.rfRangeFrom);
               Value := StrToFloatDef(FItem.rfRangeFrom, 0);
               if FItem.rfDataType = 10 then // Period
                 DecPlaces := 0;
             End; // With FromField As TCurrencyEdit

             Y := Y + 26;

             ToField := TCurrencyEdit.Create(Self);
             With ToField As TCurrencyEdit Do
             Begin
               Parent := pnlInputType;
               SetBounds (X, Y, 80, 22); // LTWH
               TabOrder := 4;
//               Text := Trim(FRangeFilter.rfRangeTo);
               Value := StrToFloatDef(FItem.rfRangeTo, 0);
               if FItem.rfDataType = 10 then // Period
                 DecPlaces := 0;
             End; // With ToField As TCurrencyEdit
           End; // Value
      5  : Begin // Currency
             FromField := TSBSComboBox.Create(Self);
             With FromField As TSBSComboBox Do
             Begin
               Parent := pnlInputType;
               SetBounds (X, Y, 170, 22); // LTWH
               TabOrder := 3;

               Set_DefaultCurr(Items, True, True);
               If (Length(FItem.rfRangeFrom) > 0) Then
                 ItemIndex := Ord(FItem.rfRangeFrom[1])
               Else
                 ItemIndex := 0;
             End; // With FromField As TSBSComboBox

             Y := Y + 26;

             ToField := TSBSComboBox.Create(Self);
             With ToField As TSBSComboBox Do
             Begin
               Parent := pnlInputType;
               SetBounds (X, Y, 170, 22); // LTWH
               TabOrder := 4;

               Set_DefaultCurr(Items, True, True);
               If (Length(FItem.rfRangeTo) > 0) Then
                 ItemIndex := Ord(FItem.rfRangeTo[1])
               Else
                 ItemIndex := 0;
             End; // With ToField As TSBSComboBox
           End; // Currency
      4,  // ASCII
      6,  // Document No.
      7,  // Customer Code
      8,  // Supplier Code
      9,  // Nominal Code
      10, // Stock Code
      11, // Cost Centre Code
      12, // Department Code
      13, // Location Code
      17, // Job Code
      18 : Begin // Bin Code
             FromField := TEdit.Create(Self);
             With FromField As TEdit Do
             Begin
               Parent := pnlInputType;
               If (FRFType In [11, 12, 13]) Then
                 // CC, Dept, Loc
                 SetBounds (X, Y, 50, 22)  // LTWH
               Else If (FRFType In [4, 10]) Then
                 // ASCII, StockCode
                 SetBounds (X, Y, 160, 22) // LTWH
               Else If (FRFType In [7, 8]) Then
                 // Cust, Supp
                 SetBounds (X, Y, 70, 22) // LTWH
               Else
                 SetBounds (X, Y, 90, 22); // LTWH
               CharCase := ecUpperCase;
               TabOrder := 3;
               Tag := FRFType;

               Case FRFType Of
                 4          : MaxLength := 20;
                 6          : MaxLength := 9;
                 7, 8       : MaxLength := 6;
                 9          : MaxLength := 9;
                 10         : MaxLength := 16;
                 11, 12, 13 : MaxLength := 3;
                 17, 18     : MaxLength := 10;
               End; // Case FRFType

               Text := Copy (FItem.rfRangeFrom, 1, MaxLength);

               If (FRFType In [7, 8, 9, 10, 11, 12, 13, 17]) Then
                 OnExit := OnExitLookup;
             End; // With FromField As TEdit

             Y := Y + 26;

             ToField := TEdit.Create(Self);
             With ToField As TEdit Do
             Begin
               Parent := pnlInputType;
               SetBounds ((FromField As TEdit).Left, Y, (FromField As TEdit).Width, (FromField As TEdit).Height); // LTWH
               CharCase := ecUpperCase;
               MaxLength := (FromField As TEdit).MaxLength;
               TabOrder := (FromField As TEdit).TabOrder + 1;
               Tag := (FromField As TEdit).Tag;
               Text := Copy (FItem.rfRangeTo, 1, MaxLength);

               OnExit := (FromField As TEdit).OnExit;
             End; // With ToField As TEdit
           End;  // ASCII
    End; // Case FRFType
  End; // If (FRFType >= Low(RepInpTypesL^)) And (FRFType <= High(RepInpTypesL^))
end;

// -----------------------------------------------------------------------------

end.

