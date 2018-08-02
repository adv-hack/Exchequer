unit frmVRWRangeFiltersU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ExtCtrls, uMultiList, CtrlPrms, EnterToTab,
  VRWReportIF, frmVRWRangeFilterDetailsU, GlobalTypes;

type
  TRangeFilterListMode = (rflmDesigntime, rflmPrintTime);
  TRangeFilterDisplayMode = (rfdmRangeFilters, rfdmInputFields, rfdmBoth);

  TfrmVRWRangeFilters = class(TForm)
    mulRangeFilters: TMultiList;
    EnterToTab1: TEnterToTab;
    btnPrint: TSBSButton;
    btnClose: TSBSButton;
    btnEdit: TSBSButton;
    btnDelete: TSBSButton;
    btnAdd: TSBSButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure mulRangeFiltersRowDblClick(Sender: TObject;
      RowIndex: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure mulRangeFiltersChangeSelection(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
    FDialogMode : TRangeFilterListMode;
    FDisplayMode: TRangeFilterDisplayMode;
    FReport: IVRWReport3;

    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    Procedure SetDialogMode (Value : TRangeFilterListMode);

    // Control the minimum size that the form can resize to - works better than constraints
    procedure WMGetMinMaxInfo(var message  :  TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    function GetCount: Integer;
    procedure SetDisplayMode(const Value: TRangeFilterDisplayMode);

    // Returns True if formulas or selection criteria in the report hold
    // references to the specified Input Line. This is for validation when the
    // the user tries to delete an Input Line.
    function HasInputLineReferences(InputLineName: ShortString; Strings: TStrings): Boolean;
  public
    { Public declarations }
    procedure AddRangeFilter(const RFLoc : ShortString; const DataType : Byte;
      const RangeFilter : IVRWRangeFilter);

    procedure AddInputField(const InputField: IVRWInputField);

    { Returns the number of range filters added to the dialog. }
    property Count: Integer read GetCount;

    property DialogMode : TRangeFilterListMode Read FDialogMode Write SetDialogMode;

    property DisplayMode: TRangeFilterDisplayMode read FDisplayMode write SetDisplayMode;

    property Report: IVRWReport3 read FReport write FReport;
  end;

// Returns True if the range filter is set
function RangeFilterSet(const RangeFilter: IVRWRangeFilter) : Boolean;
procedure DisplayRangeFilters(Report: IVRWReport3;
                              Mode: TRangeFilterListMode = rflmPrintTime;
                              DisplayMode: TRangeFilterDisplayMode = rfdmRangeFilters);

implementation

{$R *.dfm}

Uses VarFPosU;

//=========================================================================

function RangeFilterSet(const RangeFilter: IVRWRangeFilter) : Boolean;
begin // RangeFilterSet
  Result := (Trim(RangeFilter.rfDescription) <> '') or
            (Trim(RangeFilter.rfFromValue) <> '') or
            (Trim(RangeFilter.rfToValue) <> '');
end; // RangeFilterSet

//=========================================================================

procedure DisplayRangeFilters(Report: IVRWReport3; Mode: TRangeFilterListMode;
  DisplayMode: TRangeFilterDisplayMode);
var
  Control: IVRWControl;
  Entry: Integer;
  RFDlg: TfrmVRWRangeFilters;
  RangeFilter: IVRWRangeFilter;
  InputField: IVRWInputField;
  Item: TInputField;
begin
  RFDlg := TfrmVRWRangeFilters.Create(nil);
  RFDlg.DialogMode  := Mode;
  RFDlg.DisplayMode := DisplayMode;
  RFDlg.Report := Report as IVRWReport3;
  if (DisplayMode = rfdmInputFields) then
    RFDlg.btnAdd.Enabled := True;

  RangeFilter := Report.vrRangeFilter;
  try

    if (DisplayMode in [rfdmRangeFilters, rfdmBoth]) then
    begin
      if RangeFilterSet(RangeFilter) and
         (RangeFilter.rfAlwaysAsk or (Mode = rflmDesigntime)) then
        RFDlg.AddRangeFilter('Index Filter', 255, RangeFilter);
      for Entry := 0 to Report.vrControls.clCount - 1 do
      begin
        Control := Report.vrControls.clItems[Entry];
        { Only field controls can have a range filter }
        if Supports(Control, IVRWFieldControl) then
        with Control as IVRWFieldControl do
        begin
          { Does this control have a Range Filter? }
          if RangeFilterSet(vcRangeFilter) then
          begin
            { If so, add it to the Range Filter form's list }
            RFDlg.AddRangeFilter(vcFieldName, vcVarType, vcRangeFilter);
          end;
        end;  // if Supports(...
        Control := nil;
      end;  // for Entry...
    end;

    if (DisplayMode in [rfdmInputFields, rfdmBoth]) then
    begin
      for Entry := 0 to (Report as IVRWReport3).vrInputFields.rfCount - 1 do
      begin
        InputField := (Report as IVRWReport3).vrInputFields.rfItems[Entry];
        RFDlg.AddInputField(InputField);
        InputField := nil;
      end;  // for Entry...
    end;

    case DisplayMode of
      rfdmRangeFilters:
        begin
          RFDlg.mulRangeFilters.DesignColumns[0].Caption := 'Location';
          RFDlg.Caption := 'Range Filters';
        end;
      rfdmInputFields:
        begin
          RFDlg.mulRangeFilters.DesignColumns[0].Caption := 'Name';
          RFDlg.Caption := 'Input Fields';
        end;
      rfdmBoth:
        begin
          RFDlg.mulRangeFilters.DesignColumns[0].Caption := 'Name/Location';
          RFDlg.Caption := 'Range Filters and Input Fields';
        end;
    end;

    if (RFDlg.Count > 0) or (DisplayMode in [rfdmInputFields, rfdmBoth]) then
    begin
      RFDlg.ShowModal;
      if (RFDlg.ModalResult = mrOk) then
      begin
        if (DisplayMode in [rfdmInputFields, rfdmBoth]) then
        begin
          Report.vrInputFields.Clear;
          for Entry := 0 to RFDlg.Count - 1 do
          begin
            if (RFDlg.mulRangeFilters.DesignColumns[0].Items.Objects[Entry] is TInputField) then
            begin
              Item := TInputField(RFDlg.mulRangeFilters.DesignColumns[0].Items.Objects[Entry]);
              InputField := Report.vrInputFields.Add;
              InputField.rfId := Entry + 1;
              InputField.rfName := Item.rfName;
              InputField.rfDescription := Item.rfDesc;
              InputField.rfType := Item.rfType;
              InputField.rfAlwaysAsk := Item.rfAsk;
              InputField.rfFromValue := Item.rfRangeFrom;
              InputField.rfToValue := Item.rfRangeTo;
            end;
          end;
        end;
      end;
    end
    else
    begin
      case DisplayMode of
        rfdmRangeFilters: ShowMessage('No range filters have been set for this report');
        rfdmBoth: ShowMessage('No range filters or input fields have been set for this report');
      end;
    end;

  finally
    RangeFilter := nil;
    RFDlg.Free;
  end;
end;

//=========================================================================

procedure TfrmVRWRangeFilters.FormCreate(Sender: TObject);
begin
  ClientHeight := 164;
  ClientWidth := 710;

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := (Width - ClientWidth) + 500;        // take border sizing &
  MinSizeY := (Height - ClientHeight) + 136;      // captions into account

  FDialogMode := rflmDesigntime;
end;

//------------------------------

procedure TfrmVRWRangeFilters.FormDestroy(Sender: TObject);
begin
  // Clear out the list of Range filter objects
end;

//-------------------------------------------------------------------------

// Control the minimum size that the form can resize to - works better than constraints
procedure TfrmVRWRangeFilters.WMGetMinMaxInfo(var message : TWMGetMinMaxInfo);
begin // WMGetMinMaxInfo
  with message.MinMaxInfo^ do
  begin
    ptMinTrackSize.X:=MinSizeX;
    ptMinTrackSize.Y:=MinSizeY;
  end; // with message.MinMaxInfo^

  message.Result:=0;

  Inherited;
end; // WMGetMinMaxInfo

//------------------------------

procedure TfrmVRWRangeFilters.FormResize(Sender: TObject);
begin
  btnClose.Left := ClientWidth - 5 - btnClose.Width;
  btnEdit.Left := btnClose.Left;
  btnDelete.Left := btnClose.Left;
  btnAdd.Left := btnClose.Left;

  mulRangeFilters.Width := btnClose.Left - mulRangeFilters.Left - 5;
  mulRangeFilters.Height := ClientHeight - 10;
end;

//-------------------------------------------------------------------------

procedure TfrmVRWRangeFilters.AddRangeFilter(const RFLoc : ShortString;
  const DataType : Byte; const RangeFilter : IVRWRangeFilter);
Begin // AddRangeFilter
  // Create a Range filter detail object and add it into the multilist
  TRangeFilter.Create(RFLoc, DataType, RangeFilter).AddToList(mulRangeFilters);
End; // AddRangeFilter

//-------------------------------------------------------------------------

procedure TfrmVRWRangeFilters.AddInputField(
  const InputField: IVRWInputField);
var
  Field: TInputField;
begin
  Field := TInputField.Create(InputField);
  Field.AddToList(mulRangeFilters);
  if (Field.FList = nil) then
    ShowMessage('List not assigned');
//  TInputField.Create(InputField).AddToList(mulRangeFilters);
end;

//-------------------------------------------------------------------------

procedure TfrmVRWRangeFilters.mulRangeFiltersRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  btnEditClick(Sender);
end;

//-------------------------------------------------------------------------

procedure TfrmVRWRangeFilters.btnEditClick(Sender: TObject);
begin
  If (mulRangeFilters.Selected >= 0) And (mulRangeFilters.Selected < mulRangeFilters.DesignColumns[0].Items.Count) Then
  Begin
    With TfrmVRWRangeFilterDetails.Create(Self) Do
    Begin
      Try
        if (mulRangeFilters.DesignColumns[0].Items.Objects[mulRangeFilters.Selected] is TRangeFilter) then
        begin
          // Setup a reference to the Range Filter object to allow direct updating from the OK button
          Item := TRangeFilter(mulRangeFilters.DesignColumns[0].Items.Objects[mulRangeFilters.Selected]);
          mulRangeFilters.DesignColumns[0].Caption := 'Location';

          // If runtime we can only change the From/To range
          DesignTime := (FDialogMode = rflmDesigntime);

          // Add Location into Caption
          Location := mulRangeFilters.DesignColumns[0].Items[mulRangeFilters.Selected];
        end
        else
        begin
          Item := TInputField(mulRangeFilters.DesignColumns[0].Items.Objects[mulRangeFilters.Selected]);
          mulRangeFilters.DesignColumns[0].Caption := 'Name';
          ItemName := TInputField(mulRangeFilters.DesignColumns[0].Items.Objects[mulRangeFilters.Selected]).rfName;
          Caption  := 'Input Field';
          DesignTime := (FDialogMode = rflmDesignTime);
        end;
        ShowModal;
        if (ModalResult = mrOk) and (mulRangeFilters.DesignColumns[0].Items.Objects[mulRangeFilters.Selected] is TInputField) then
        begin
          mulRangeFilters.DesignColumns[0].Items[mulRangeFilters.Selected] := TInputField(mulRangeFilters.DesignColumns[0].Items.Objects[mulRangeFilters.Selected]).rfName;
          mulRangeFilters.DesignColumns[1].Items[mulRangeFilters.Selected] := TInputField(mulRangeFilters.DesignColumns[0].Items.Objects[mulRangeFilters.Selected]).rfDesc;
        end;
      Finally
        Free;
      End; // Try..Finally
    End; // With TfrmRangeFilterDetail.Create(Self)
  End; // If (mulRangeFilters.Selected >= 0) And (mulRangeFilters.Selected < mulRangeFilters.DesignColumns[0].Items.Count)
end;

//-------------------------------------------------------------------------

procedure TfrmVRWRangeFilters.btnDeleteClick(Sender: TObject);

Var
  oRangeFilter : TRangeFilter;
  Msg: string;
  HasReferences: Boolean;
  References: TStringList;
begin
  References := TStringList.Create;
  try
    If (mulRangeFilters.Selected >= 0) And (mulRangeFilters.Selected < mulRangeFilters.DesignColumns[0].Items.Count) Then
    Begin
      if (mulRangeFilters.DesignColumns[0].Items.Objects[mulRangeFilters.Selected] is TRangeFilter) then
      begin
        Msg := 'Are you sure you want to delete the Range Filter for ' + QuotedStr(mulRangeFilters.DesignColumns[0].Items[mulRangeFilters.Selected]) + '?';
        HasReferences := False;
      end
      else
      begin
        Msg := 'Are you sure you want to delete the Input Field ' + QuotedStr(mulRangeFilters.DesignColumns[0].Items[mulRangeFilters.Selected]) + '?';
        HasReferences := HasInputLineReferences(mulRangeFilters.DesignColumns[0].Items[mulRangeFilters.Selected], References);
      end;
      if HasReferences then
      begin
        MessageDlg('The report contains other references to this Input Line. ' +
                   'These must be changed before the Input Line can be ' +
                   'deleted: ' + #13#10#13#10 +
                   References.Text, mtWarning, [mbOk], 0);
      end
      else If (MessageDlg (Msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
      Begin
        oRangeFilter := TRangeFilter(mulRangeFilters.DesignColumns[0].Items.Objects[mulRangeFilters.Selected]);
        oRangeFilter.Clear;
        oRangeFilter.Free;

        mulRangeFilters.DeleteRow(mulRangeFilters.Selected);
      End; // If (MessageDlg (...
    End; // If (mulRangeFilters.Selected >= 0) And (mulRangeFilters.Selected < mulRangeFilters.DesignColumns[0].Items.Count)
  finally
    References.Free;
  end;
end;

//-------------------------------------------------------------------------

Procedure TfrmVRWRangeFilters.SetDialogMode (Value : TRangeFilterListMode);
var
  Y: Integer;
Begin // SetDialogMode
  FDialogMode := Value;

  if (FDialogMode = rflmPrintTime) then
  begin
    btnPrint.Visible := True;
    Y := btnPrint.Top + btnPrint.Height + 8;
    btnClose.Caption := '&Cancel';
  end  // If (FDialogMode = rflmPrintTime)
  else
  begin
    btnPrint.Visible := False;
    Y := btnPrint.Top;
    btnClose.Caption := '&Close';
  end;

  btnClose.Top := Y;
  Y := Y + btnClose.Height + 8;
  btnAdd.Top := Y;
  Y := Y + btnAdd.Height + 8;
  btnEdit.Top := Y;
  Y := Y + btnEdit.Height + 8;
  btnDelete.Top := Y;
  
  btnDelete.Visible := (FDialogMode = rflmDesigntime);
End; // SetDialogMode

//-------------------------------------------------------------------------

procedure TfrmVRWRangeFilters.SetDisplayMode(
  const Value: TRangeFilterDisplayMode);
begin
  FDisplayMode := Value;
end;

//-------------------------------------------------------------------------

procedure TfrmVRWRangeFilters.btnCloseClick(Sender: TObject);
begin
  If (FDialogMode = rflmPrintTime) Then
    ModalResult := mrCancel
  else
    ModalResult := mrOk;
end;

//-------------------------------------------------------------------------

function TfrmVRWRangeFilters.GetCount: Integer;
begin
  Result := mulRangeFilters.DesignColumns[0].Items.Count;
end;

//-------------------------------------------------------------------------

procedure TfrmVRWRangeFilters.mulRangeFiltersChangeSelection(
  Sender: TObject);
begin
  btnEdit.Enabled := (mulRangeFilters.Selected <> -1);
  btnDelete.Enabled := (mulRangeFilters.Selected <> -1);
end;

//-------------------------------------------------------------------------

procedure TfrmVRWRangeFilters.btnPrintClick(Sender: TObject);
var
  oRangeFilter : TRangeFilter;
  I            : SmallInt;
  OK           : Boolean;
begin
  OK := True;
  If (mulRangeFilters.DesignColumns[0].Items.Count > 0) Then
  Begin
    For I := 0 To (mulRangeFilters.DesignColumns[0].Items.Count - 1) Do
    Begin
      // Setup a reference to the Range Filter object to allow direct updating from the OK button
      oRangeFilter := TRangeFilter(mulRangeFilters.DesignColumns[0].Items.Objects[I]);

      If (oRangeFilter.rfRangeFrom = '') Or (oRangeFilter.rfRangeTo = '') Then
      Begin
        MessageDlg ('One or more Range Filters have not had their Start or End values defined, ' +
                    'these must be defined before the report can be printed.', mtError, [mbOK], 0);
        mulRangeFilters.Selected := I;
        OK := False;
        Break;
      End // If (oRangeFilter.rfRangeFrom = '') Or (oRangeFilter.rfRangeTo = '')
      Else If (Not oRangeFilter.CheckAscendingValues) Then
      Begin
        mulRangeFilters.Selected := I;
        MessageDlg ('The selected Range Filter has a Start value defined which is greater than the End value.',
                    mtError, [mbOK], 0);
        OK := False;
        Break;
      End; // If (Not oRangeFilter.CheckAscendingValues)
    End; // For I
  End; // If (mulRangeFilters.DesignColumns[0].Items.Count > 0)

  If OK Then ModalResult := mrOK;
end;

//-------------------------------------------------------------------------

procedure TfrmVRWRangeFilters.btnAddClick(Sender: TObject);
var
  InputField: IVRWInputField;
  Item: TInputField;
begin
  InputField := FReport.vrInputFields.Add;
  InputField.rfType := 4;
  AddInputField(InputField);
  mulRangeFilters.Selected := mulRangeFilters.ItemsCount - 1;
  if not DisplayInputField(InputField) then
  begin
    Item := TInputField(mulRangeFilters.DesignColumns[0].Items.Objects[mulRangeFilters.Selected]);
    Item.Clear;
    Item.Free;
    mulRangeFilters.DeleteRow(mulRangeFilters.Selected);
  end
  else
  begin
    Item := TInputField(mulRangeFilters.DesignColumns[0].Items.Objects[mulRangeFilters.Selected]);
    mulRangeFilters.DesignColumns[0].Items[mulRangeFilters.Selected] := InputField.rfName;
    mulRangeFilters.DesignColumns[1].Items[mulRangeFilters.Selected] := InputField.rfDescription;
    mulRangeFilters.DesignColumns[2].Items[mulRangeFilters.Selected] := Item.rfTypeString;
    mulRangeFilters.DesignColumns[3].Items[mulRangeFilters.Selected] := InputField.rfFromValue;
    mulRangeFilters.DesignColumns[4].Items[mulRangeFilters.Selected] := InputField.rfToValue;
    if InputField.rfAlwaysAsk then
      mulRangeFilters.DesignColumns[5].Items[mulRangeFilters.Selected] := 'Yes'
    Else
      mulRangeFilters.DesignColumns[5].Items[mulRangeFilters.Selected] := 'No';
  end;
end;

//-------------------------------------------------------------------------

function TfrmVRWRangeFilters.HasInputLineReferences(
  InputLineName: ShortString; Strings: TStrings): Boolean;
var
  ControlNo: Integer;
  FmlControl: IVRWFormulaControl;
  StdControl: IVRWControl;
  DbfControl: IVRWFieldControl;
  SearchFor, Definition: ShortString;
  StartPos: Integer;
begin
  Result := False;
  Strings.Clear;
  SearchFor := 'INP[' + UpperCase(InputLineName);
  with FReport do
    for ControlNo := 0 to vrControls.clCount - 1 do
    begin
      { Check formulae }
      if Supports(vrControls.clItems[ControlNo], IVRWFormulaControl) then
      begin
        FmlControl := vrControls.clItems[ControlNo] as IVRWFormulaControl;
        try
          Definition := Uppercase(FmlControl.vcFormulaDefinition);
          if Pos(SearchFor, Definition) <> 0 then
          begin
            Strings.Add(#9 + 'Formula: ' + #9 + #9 + FmlControl.vcFormulaName);
            Result := True;
          end;
        finally
          FmlControl := nil;
        end;
      end;
      { Check Selection Criteria }
      if Supports(vrControls.clItems[ControlNo], IVRWFieldControl) then
      begin
        DbfControl := vrControls.clItems[ControlNo] as IVRWFieldControl;
        try
          Definition := Uppercase(DbfControl.vcSelectCriteria);
          if Pos(SearchFor, Definition) <> 0 then
          begin
            Strings.Add(#9 + 'Selection Criteria for: ' + #9 + DbfControl.vcFieldName);
            Result := True;
          end;
        finally
          DbfControl := nil;
        end;
      end;
      { Check PrintIf statements }
      if Supports(vrControls.clItems[ControlNo], IVRWControl) then
      begin
        StdControl := vrControls.clItems[ControlNo] as IVRWControl;
        try
          Definition := Uppercase(StdControl.vcPrintIf);
          if Pos(SearchFor, Definition) <> 0 then
          begin
            Strings.Add(#9 + 'Print If for: ' + #9 + #9 + StdControl.vcName);
            Result := True;
          end;
        finally
          StdControl := nil;
        end;
      end;
    end;
end;

end.
