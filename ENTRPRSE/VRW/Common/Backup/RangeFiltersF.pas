unit RangeFiltersF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ExtCtrls, uMultiList, CtrlPrms, EnterToTab,
  RangeFilterDetF;

type
  TRangeFilterListMode = (rflmDesigntime, rflmPrintTime);

  TfrmRangeFilters = class(TForm)
    mulRangeFilters: TMultiList;
    btnClose: TSBSButton;
    btnEdit: TSBSButton;
    btnDelete: TSBSButton;
    EnterToTab1: TEnterToTab;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure mulRangeFiltersRowDblClick(Sender: TObject;
      RowIndex: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FDialogMode : TRangeFilterListMode;

    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    Procedure SetDialogMode (Value : TRangeFilterListMode);

    // Control the minimum size that the form can resize to - works better than constraints
    procedure WMGetMinMaxInfo(var message  :  TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
  public
    { Public declarations }
    Property DialogMode : TRangeFilterListMode Read FDialogMode Write SetDialogMode;

    Procedure AddRangeFilter(Const RFLoc : ShortString; Const DataType : Byte; Const RangeFilterAddr : PInputLineRecord);
  end;

// Returns True if the range filter is set
Function RangeFilterSet(Const RangeFilterAddr : PInputLineRecord) : Boolean;

implementation

{$R *.dfm}

Uses VarFPosU;

//=========================================================================

Function RangeFilterSet(Const RangeFilterAddr : PInputLineRecord) : Boolean;
Begin // RangeFilterSet
  Result := (Trim(RangeFilterAddr^.ssDescription) <> '') Or
            (Trim(RangeFilterAddr^.ssFromValue) <> '') Or
            (Trim(RangeFilterAddr^.ssToValue) <> '');
End; // RangeFilterSet

//=========================================================================

procedure TfrmRangeFilters.FormCreate(Sender: TObject);
begin
  ClientHeight := 164;
  ClientWidth := 710;

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := (Width - ClientWidth) + 500;        // take border sizing &
  MinSizeY := (Height - ClientHeight) + 136;      // captions into account

  FDialogMode := rflmDesigntime;
end;

//------------------------------

procedure TfrmRangeFilters.FormDestroy(Sender: TObject);
begin
  // Clear out the list of Range filter objects
end;

//-------------------------------------------------------------------------

// Control the minimum size that the form can resize to - works better than constraints
procedure TfrmRangeFilters.WMGetMinMaxInfo(var message : TWMGetMinMaxInfo);
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

procedure TfrmRangeFilters.FormResize(Sender: TObject);
begin
  btnClose.Left := ClientWidth - 5 - btnClose.Width;
  btnEdit.Left := btnClose.Left;
  btnDelete.Left := btnClose.Left;

  mulRangeFilters.Width := btnClose.Left - mulRangeFilters.Left - 5;
  mulRangeFilters.Height := ClientHeight - 10;
end;

//-------------------------------------------------------------------------

Procedure TfrmRangeFilters.AddRangeFilter(Const RFLoc : ShortString; Const DataType : Byte; Const RangeFilterAddr : PInputLineRecord);
Begin // AddRangeFilter
  // Create a Range filter detail object and add it into the multilist
  TRangeFilter.Create (RFLoc, DataType, RangeFilterAddr).AddToList(mulRangeFilters);
End; // AddRangeFilter

//-------------------------------------------------------------------------

procedure TfrmRangeFilters.mulRangeFiltersRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  btnEditClick(Sender);
end;

procedure TfrmRangeFilters.btnEditClick(Sender: TObject);
begin
  If (mulRangeFilters.Selected >= 0) And (mulRangeFilters.Selected < mulRangeFilters.DesignColumns[0].Items.Count) Then
  Begin
    With TfrmRangeFilterDetail.Create(Self) Do
    Begin
      Try
        // Setup a reference to the Range Filter object to allow direct updating from the OK button
        RangeFilter := TRangeFilter(mulRangeFilters.DesignColumns[0].Items.Objects[mulRangeFilters.Selected]);

        // If runtime we can only change the From/To range
        DesignTime := (FDialogMode = rflmDesigntime);

        // Add Location into Caption
        Location := mulRangeFilters.DesignColumns[0].Items[mulRangeFilters.Selected];

        ShowModal;
      Finally
        Free;
      End; // Try..Finally
    End; // With TfrmRangeFilterDetail.Create(Self)
  End; // If (mulRangeFilters.Selected >= 0) And (mulRangeFilters.Selected < mulRangeFilters.DesignColumns[0].Items.Count)
end;

//-------------------------------------------------------------------------

procedure TfrmRangeFilters.btnDeleteClick(Sender: TObject);
Var
  oRangeFilter : TRangeFilter;
begin
  If (mulRangeFilters.Selected >= 0) And (mulRangeFilters.Selected < mulRangeFilters.DesignColumns[0].Items.Count) Then
  Begin
    If (MessageDlg ('Are you sure you want to delete the Range Filter for ' + QuotedStr(mulRangeFilters.DesignColumns[0].Items[mulRangeFilters.Selected]) + '?',
                    mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
    Begin
      oRangeFilter := TRangeFilter(mulRangeFilters.DesignColumns[0].Items.Objects[mulRangeFilters.Selected]);
      oRangeFilter.Clear;
      oRangeFilter.Free;

      mulRangeFilters.DeleteRow(mulRangeFilters.Selected);
    End; // If (MessageDlg (...
  End; // If (mulRangeFilters.Selected >= 0) And (mulRangeFilters.Selected < mulRangeFilters.DesignColumns[0].Items.Count)
end;

//-------------------------------------------------------------------------

Procedure TfrmRangeFilters.SetDialogMode (Value : TRangeFilterListMode);
Begin // SetDialogMode
  FDialogMode := Value;

  // MH 18/04/05: Change caption to Continue when printing - Close is misleading
  If (FDialogMode = rflmPrintTime) Then
  Begin
    btnClose.Caption := '&Continue';
  End; // If (FDialogMode = rflmPrintTime)

  btnDelete.Visible := (FDialogMode = rflmDesigntime);
End; // SetDialogMode

//-------------------------------------------------------------------------

// MH 18/04/05: Changed the close button to check range filters aren't blank when
// printing the report as it doesn't work.
procedure TfrmRangeFilters.btnCloseClick(Sender: TObject);
Var
  oRangeFilter : TRangeFilter;
  I            : SmallInt;
  OK           : Boolean;
begin
  If (FDialogMode = rflmPrintTime) Then
  Begin
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
  End // If (FDialogMode = rflmPrintTime)
  Else
    ModalResult := mrOK;
end;

//-------------------------------------------------------------------------

end.
