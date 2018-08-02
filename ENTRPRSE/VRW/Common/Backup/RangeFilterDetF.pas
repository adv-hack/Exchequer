unit RangeFilterDetF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EnterToTab, StdCtrls, ExtCtrls, uMultiList, CtrlPrms, Mask,
  TEditVal;

Type
  TRangeFilter = Class(TObject)
  Private
    // Reference to parent multi-list and index of item with the list
    FRangeFilterList : TMultiList;

    // Datatype of source within the report
    FDataType : Byte;

    // Location of Range Filter within the Report
    FLocation : ShortString;

    // Pointer to range filter record within the DB Field Control or Report Header
    FRangeFilterAddr : PInputLineRecord;

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
  Public
    Property rfLocation : ShortString Read FLocation;
    Property rfDesc : ShortString Read GetDesc Write SetDesc;
    Property rfType : SmallInt Read GetType Write SetType;
    Property rfTypeString : ShortString Read GetTypeString;
    Property rfRangeFrom : ShortString Read GetRangeFrom Write SetRangeFrom;
    Property rfRangeFromString : ShortString Read GetRangeFromString;
    Property rfRangeTo : ShortString Read GetRangeTo Write SetRangeTo;
    Property rfRangeToString : ShortString Read GetRangeToString;
    Property rfAsk : Boolean Read GetAsk Write SetAsk;
    Property rfDataType : Byte Read FDataType;

    Constructor Create (Const Location : ShortString; Const DataType : Byte; Const RangeFilterAddr : PInputLineRecord);
    Procedure AddToList (RangeFilters: TMultiList);
    Procedure Clear;

    // Returns TRUE if the Range Start value <= Range End value
    Function CheckAscendingValues : Boolean;
  End; // TRangeFilter

  //=========================================================================

  TfrmRangeFilterDetail = class(TForm)
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
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbInputTypeClick(Sender: TObject);
    procedure OnExitLookup(Sender: TObject);
  private
    { Private declarations }
    FRangeFilter : TRangeFilter;
    FDesignTime : Boolean;
    FRWVersionNo : Byte;

    FLocation : ShortString;

    FRFType : Byte;

    // References to dynamically created controls for the From/To Range
    FromField, ToField : TWinControl;

    Procedure SetRangeFilter (Value : TRangeFilter);
    Procedure SetLocation (Value : ShortString);
    Procedure SetDesignTime (Value : Boolean);
  public
    { Public declarations }
    Property DesignTime : Boolean Read FDesignTime Write SetDesignTime;
    Property Location : ShortString Read FLocation Write SetLocation;
    Property RangeFilter : TRangeFilter Read FRangeFilter Write SetRangeFilter;
  end;

implementation

{$R *.dfm}

Uses VarConst, VarFPosU, ETDateU, BTSupU2, EntLicence, InvListU;

//=========================================================================

Constructor TRangeFilter.Create (Const Location : ShortString; Const DataType : Byte; Const RangeFilterAddr : PInputLineRecord);
Begin // Create
  Inherited Create;

  FDataType := DataType;
  FLocation := Location;
  FRangeFilterAddr := RangeFilterAddr;
End; // Create

//-------------------------------------------------------------------------

Procedure TRangeFilter.AddToList (RangeFilters: TMultiList);
Begin // AddToList
  FRangeFilterList := RangeFilters;

  If Assigned(FRangeFilterList) Then
  Begin
    FRangeFilterList.DesignColumns[0].Items.AddObject(rfLocation, Self);  // Location

    Try
      FRangeFilterList.DesignColumns[1].Items.Add(rfDesc);            // Description
      FRangeFilterList.DesignColumns[2].Items.Add(rfTypeString);      // Type
      FRangeFilterList.DesignColumns[3].Items.Add(rfRangeFromString); // Range From
      FRangeFilterList.DesignColumns[4].Items.Add(rfRangeToString);   // Range To

      If rfAsk Then
        FRangeFilterList.DesignColumns[5].Items.Add('Yes')       // Ask
      Else
        FRangeFilterList.DesignColumns[5].Items.Add('No');       // Ask
    Except
      On E:Exception Do
        FRangeFilterList.DesignColumns[1].Items.Add(E.Message);
    End; // Try..Except
  End; // If Assigned(FRangeFilterList)
End; // AddToList

//-------------------------------------------------------------------------

Procedure TRangeFilter.Clear;
Begin // Clear
  FillChar (FRangeFilterAddr^, SizeOf(FRangeFilterAddr^), #0);
End; // Clear

//-------------------------------------------------------------------------

Function TRangeFilter.GetDesc : ShortString;
Begin // GetType
  Result := FRangeFilterAddr^.ssDescription;
End; // GetType
Procedure TRangeFilter.SetDesc (Value : ShortString);
Begin // SetDesc
  FRangeFilterAddr^.ssDescription := Value;
  If Assigned(FRangeFilterList) Then
    FRangeFilterList.DesignColumns[1].Items[FRangeFilterList.DesignColumns[0].Items.IndexOf(FLocation)] := rfDesc;
End; // SetDesc

//------------------------------

Function TRangeFilter.GetType : SmallInt;
Begin // GetType
  Result := FRangeFilterAddr^.siType
End; // GetType
Procedure TRangeFilter.SetType (Value : SmallInt);
Begin // SetType
  FRangeFilterAddr^.siType := Value;
  If Assigned(FRangeFilterList) Then
    FRangeFilterList.DesignColumns[2].Items[FRangeFilterList.DesignColumns[0].Items.IndexOf(FLocation)] := rfTypeString;
End; // SetType

//------------------------------

Function TRangeFilter.GetTypeString : ShortString;
Begin // GetTypeString
  // MH 25/04/05: Added check as this was crsahing with a corrupted range filter
  If (FRangeFilterAddr^.siType >= Low(RepInpTypesL^)) And (FRangeFilterAddr^.siType <= High(RepInpTypesL^)) Then
    Result := RepInpTypesL^[FRangeFilterAddr^.siType]
  Else
    Result := 'Error: Invalid Type (' + IntToStr(FRangeFilterAddr^.siType) + ')';
End; // GetTypeString

//------------------------------

Function TRangeFilter.GetRangeFrom : ShortString;
Begin // GetType
  Result := FRangeFilterAddr^.ssFromValue;
End; // GetType
Procedure TRangeFilter.SetRangeFrom (Value : ShortString);
Begin // SetRangeFrom
  FRangeFilterAddr^.ssFromValue := Value;
  If Assigned(FRangeFilterList) Then
    FRangeFilterList.DesignColumns[3].Items[FRangeFilterList.DesignColumns[0].Items.IndexOf(FLocation)] := rfRangeFromString;
End; // SetRangeFrom

//------------------------------

// Returns a nicely formatted equivalent of the Range data
Function TRangeFilter.GetRangeString (RangeData : ShortString) : ShortString;
Begin // GetRangeString
  // Can't use trim as currencies are stored as binary
  If (Length(RangeData) > 0) Then
  Begin
    Case FRangeFilterAddr^.siType Of
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
    End; // Case FRangeFilterAddr^.siType
  End // If (Trim(RangeData) <> '')
  Else
    // MH 18/04/05: Added Else as was getting corrupted output with blank values
    Result := '';
End; // GetRangeString

// Returns a nicely formatted equivalent of the Range From data
Function TRangeFilter.GetRangeFromString : ShortString;
Begin // GetRangeFromString
  Result := GetRangeString (FRangeFilterAddr^.ssFromValue);
End; // GetRangeFromString

// Returns a nicely formatted equivalent of the Range To data
Function TRangeFilter.GetRangeToString : ShortString;
Begin // GetRangeToString
  Result := GetRangeString (FRangeFilterAddr^.ssToValue);
End; // GetRangeToString

//------------------------------

// Returns TRUE if the Range Start value <= Range End value
Function TRangeFilter.CheckAscendingValues : Boolean;
Var
  s1, s2 : ShortString;
  d1, d2 : Double;
Begin // CheckAscendingValues
  Case FRangeFilterAddr^.siType Of
    // Date - DDMMYYYY - Check as YYYYMMDD
    1  : Begin
           s1 := Copy(FRangeFilterAddr^.ssFromValue, 5, 4) + Copy (FRangeFilterAddr^.ssFromValue, 3, 2) + Copy (FRangeFilterAddr^.ssFromValue, 1, 2);
           s2 := Copy(FRangeFilterAddr^.ssToValue, 5, 4) + Copy (FRangeFilterAddr^.ssToValue, 3, 2) + Copy (FRangeFilterAddr^.ssToValue, 1, 2);
           Result := (s1 <= s2);
         End; // Date

    // Period - MMYYYY - Check as YYYYMM
    2  : Begin
           s1 := Copy (FRangeFilterAddr^.ssFromValue, 3, 4) + Copy(FRangeFilterAddr^.ssFromValue, 1, 2);
           s2 := Copy (FRangeFilterAddr^.ssToValue, 3, 4) + Copy(FRangeFilterAddr^.ssToValue, 1, 2);
           Result := (s1 <= s2);
         End; // Period

    // Value
    3  : Begin
           // Need to swap -ve sign to front and remove thousands separators before converting
           // to float and comparing
           s1 := FRangeFilterAddr^.ssFromValue;
           If (Pos ('-', s1) > 0) Then
           Begin
             Delete (s1, Pos ('-', s1), 1);
             s1 := '-' + s1;
           End; // If (Pos ('-', s1) > 0)
           While (Pos (ThousandSeparator, s1) > 0) Do
             Delete (s1, Pos (ThousandSeparator, s1), 1);
           d1 := StrToFloatDef(s1, 0.00);

           s2 := FRangeFilterAddr^.ssToValue;
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
    Result := (FRangeFilterAddr^.ssFromValue <= FRangeFilterAddr^.ssToValue);
  End; // Case FRangeFilterAddr^.siType
End; // CheckAscendingValues

//------------------------------

Function TRangeFilter.GetRangeTo : ShortString;
Begin // GetType
  Result := FRangeFilterAddr^.ssToValue;
End; // GetType
Procedure TRangeFilter.SetRangeTo (Value : ShortString);
Begin // SetRangeTo
  FRangeFilterAddr^.ssToValue := Value;
  If Assigned(FRangeFilterList) Then
    FRangeFilterList.DesignColumns[4].Items[FRangeFilterList.DesignColumns[0].Items.IndexOf(FLocation)] := rfRangeToString;
End; // SetRangeTo

//------------------------------

Function TRangeFilter.GetAsk : Boolean;
Begin // GetType
  Result := FRangeFilterAddr^.bAlwaysAsk;
End; // GetType
Procedure TRangeFilter.SetAsk (Value : Boolean);
Begin // SetAsk
  FRangeFilterAddr^.bAlwaysAsk := Value;
  If Assigned(FRangeFilterList) Then
  Begin
    If rfAsk Then
      FRangeFilterList.DesignColumns[5].Items[FRangeFilterList.DesignColumns[0].Items.IndexOf(FLocation)] := 'Yes'
    Else
      FRangeFilterList.DesignColumns[5].Items[FRangeFilterList.DesignColumns[0].Items.IndexOf(FLocation)] := 'No';
  End; // If Assigned(FRangeFilterList)
End; // SetAsk

//=========================================================================

procedure TfrmRangeFilterDetail.FormCreate(Sender: TObject);
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

//-------------------------------------------------------------------------

procedure TfrmRangeFilterDetail.btnOKClick(Sender: TObject);
Var
  sTo, sFrom : ShortString;
  OK : Boolean;
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
    FRangeFilter.rfDesc := Trim(edtRFDesc.Text);
    FRangeFilter.rfType := FRFType;
    FRangeFilter.rfAsk := chkRFAskUser.Checked;

    // Cache up the original values incase the validation fails
    sFrom := FRangeFilter.rfRangeFrom;
    sTo := FRangeFilter.rfRangeTo;

    If (FromField Is TMaskEdit) Then
    Begin
      // Date, Period
      FRangeFilter.rfRangeFrom := (FromField As TMaskEdit).Text;
      FRangeFilter.rfRangeTo := (ToField As TMaskEdit).Text;
    End // If (FromField Is TMaskEdit)
    Else If (FromField Is TEdit) Then
    Begin
      // ASCII, Document No, Cust/Supp, GLCode, Stock, DD/Dept, Loc, Job, Bin
      FRangeFilter.rfRangeFrom := (FromField As TEdit).Text;
      FRangeFilter.rfRangeTo := (ToField As TEdit).Text;
    End // If (FromField Is TEdit)
    Else If (FromField Is TSBSComboBox) Then
    Begin
      // Currency
      FRangeFilter.rfRangeFrom := Chr((FromField As TSBSComboBox).ItemIndex);
      FRangeFilter.rfRangeTo := Chr((ToField As TSBSComboBox).ItemIndex);
    End // If (FromField Is TSBSComboBox)
    Else If (FromField Is TCurrencyEdit) Then
    Begin
      // Value
      FRangeFilter.rfRangeFrom := (FromField As TCurrencyEdit).Text;
      FRangeFilter.rfRangeTo := (ToField As TCurrencyEdit).Text;
    End; // If (FromField Is TSBSComboBox)

    // Check that End >= Start unless blanks specified at design time
    If FRangeFilter.CheckAscendingValues Or (FDesignTime And ((FRangeFilter.rfRangeFrom = '') Or (FRangeFilter.rfRangeTo = ''))) Then
    Begin
      ModalResult := mrOK;
    End // If FRangeFilter.CheckAscendingValues Or (...
    Else
    Begin
      FRangeFilter.rfRangeFrom := sFrom;
      FRangeFilter.rfRangeTo := sTo;
      MessageDlg ('The Start value cannot be greater than the End value.', mtError, [mbOK], 0);
      If ToField.CanFocus Then ToField.SetFocus;
    end; // Else
  End; // If OK
end;

//-------------------------------------------------------------------------

Procedure TfrmRangeFilterDetail.SetRangeFilter (Value : TRangeFilter);
Var
  bAddType  : Boolean;
  iDataType : SmallInt;

  function AppropriateToField(const siInputType : SmallInt) : Boolean;
  begin
    Case FRangeFilter.rfDataType of
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
  FRangeFilter := Value;

  edtRFDesc.Text := FRangeFilter.rfDesc;

  // Load the input line type combo box only listing those applicable to the DB Fields data type
  If (FRangeFilter.rfDataType <> 255) Then
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

    If (FRangeFilter.rfType >= Low(RepInpTypesL^)) And (FRangeFilter.rfType <= High(RepInpTypesL^)) Then
    Begin
      // Try to select the correct item
      iDataType := cbInputType.Items.IndexOf(RepInpTypesL^[FRangeFilter.rfType]);
      If (iDataType >= 0) Then
      Begin
        cbInputType.ItemIndex := iDataType;
      End; // If (iDataType >= 0)
    End; // If (iDataType >= 0)
  End // If (FRangeFilter.rfDataType <> 255)
  Else
  Begin
    cbInputType.Items.Add(RepInpTypesL^[FRangeFilter.rfType]);
  End; // Else

  If (cbInputType.Items.Count = 1) Then
  Begin
    cbInputType.ItemIndex := 0;
    cbInputType.Enabled := False;
    cbInputType.Color := clBtnFace;
  End; // If (cbInputType.Items.Count = 1)
  cbInputTypeClick(Self);

  chkRFAskUser.Checked := FRangeFilter.rfAsk;

End; // SetRangeFilter

//------------------------------

Procedure TfrmRangeFilterDetail.SetDesignTime (Value : Boolean);
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

//------------------------------

Procedure TfrmRangeFilterDetail.SetLocation (Value : ShortString);
Begin // SetLocation
  FLocation := Value;
  Caption := 'Range Filter Detail - ' + FLocation;
End; // SetLocation

//-------------------------------------------------------------------------

procedure TfrmRangeFilterDetail.cbInputTypeClick(Sender: TObject);
var
  iInputType    : SmallInt;

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

  If (FRFType >= Low(RepInpTypesL^)) And (FRFType <= High(RepInpTypesL^)) Then
  Begin
    Case FRFType of
      1  : Begin // Date
             FromField := TEditDate.Create(Self);
             With FromField As TEditDate Do
             Begin
               Parent := pnlInputType;
               SetBounds (74, 60, 80, 22); // LTWH
               TabOrder := 2;
               Text := FRangeFilter.rfRangeFrom;
             End; // With FromField As TEditDate

             ToField := TEditDate.Create(Self);
             With ToField As TEditDate Do
             Begin
               Parent := pnlInputType;
               SetBounds (74, 86, 80, 22); // LTWH
               TabOrder := 3;
               Text := FRangeFilter.rfRangeTo;
             End; // With ToField As TEditDate
           End; // Date
      2  : Begin // Period
             FromField := TEditPeriod.Create(Self);
             With FromField As TEditPeriod Do
             Begin
               Parent := pnlInputType;
               SetBounds (74, 60, 80, 22); // LTWH
               TabOrder := 2;

               SetPeriod (FromField As TEditPeriod, FRangeFilter.rfRangeFrom);
             End; // With FromField As TEditPeriod

             ToField := TEditPeriod.Create(Self);
             With ToField As TEditPeriod Do
             Begin
               Parent := pnlInputType;
               SetBounds (74, 86, 80, 22); // LTWH
               TabOrder := 3;

               SetPeriod (ToField As TEditPeriod, FRangeFilter.rfRangeTo);
             End; // With ToField As TEditPeriod
           End; // Period
      3  : Begin // Value
             FromField := TCurrencyEdit.Create(Self);
             With FromField As TCurrencyEdit Do
             Begin
               Parent := pnlInputType;
               SetBounds (74, 60, 80, 22); // LTWH
               TabOrder := 2;
               Text := FRangeFilter.rfRangeFrom;
             End; // With FromField As TCurrencyEdit

             ToField := TCurrencyEdit.Create(Self);
             With ToField As TCurrencyEdit Do
             Begin
               Parent := pnlInputType;
               SetBounds (74, 86, 80, 22); // LTWH
               TabOrder := 3;
               Text := FRangeFilter.rfRangeTo;
             End; // With ToField As TCurrencyEdit
           End; // Value
      5  : Begin // Currency
             FromField := TSBSComboBox.Create(Self);
             With FromField As TSBSComboBox Do
             Begin
               Parent := pnlInputType;
               SetBounds (74, 60, 170, 22); // LTWH
               TabOrder := 2;

               Set_DefaultCurr(Items, True, True);
               If (Length(FRangeFilter.rfRangeFrom) > 0) Then
                 ItemIndex := Ord(FRangeFilter.rfRangeFrom[1])
               Else
                 ItemIndex := 0;
             End; // With FromField As TSBSComboBox

             ToField := TSBSComboBox.Create(Self);
             With ToField As TSBSComboBox Do
             Begin
               Parent := pnlInputType;
               SetBounds (74, 86, 170, 22); // LTWH
               TabOrder := 3;

               Set_DefaultCurr(Items, True, True);
               If (Length(FRangeFilter.rfRangeTo) > 0) Then
                 ItemIndex := Ord(FRangeFilter.rfRangeTo[1])
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
                 SetBounds (74, 60, 50, 22)  // LTWH
               Else If (FRFType In [4, 10]) Then
                 // ASCII, StockCode
                 SetBounds (74, 60, 160, 22) // LTWH
               Else If (FRFType In [7, 8]) Then
                 // Cust, Supp
                 SetBounds (74, 60, 70, 22) // LTWH
               Else
                 SetBounds (74, 60, 90, 22); // LTWH
               CharCase := ecUpperCase;
               TabOrder := 2;
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

               Text := Copy (FRangeFilter.rfRangeFrom, 1, MaxLength);

               If (FRFType In [7, 8, 9, 10, 11, 12, 13, 17]) Then
                 OnExit := OnExitLookup;
             End; // With FromField As TEdit

             ToField := TEdit.Create(Self);
             With ToField As TEdit Do
             Begin
               Parent := pnlInputType;
               SetBounds ((FromField As TEdit).Left, 86, (FromField As TEdit).Width, (FromField As TEdit).Height); // LTWH
               CharCase := ecUpperCase;
               MaxLength := (FromField As TEdit).MaxLength;
               TabOrder := (FromField As TEdit).TabOrder + 1;
               Tag := (FromField As TEdit).Tag;
               Text := Copy (FRangeFilter.rfRangeTo, 1, MaxLength);

               OnExit := (FromField As TEdit).OnExit;
             End; // With ToField As TEdit
           End;  // ASCII
    End; // Case FRFType
  End; // If (FRFType >= Low(RepInpTypesL^)) And (FRFType <= High(RepInpTypesL^))
end;

//-------------------------------------------------------------------------

procedure TfrmRangeFilterDetail.OnExitLookup(Sender: TObject);
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

//-------------------------------------------------------------------------

end.
