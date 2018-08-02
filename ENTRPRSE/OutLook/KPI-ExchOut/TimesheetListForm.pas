unit TimesheetListForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, ExtCtrls, TDaybookTotalsClass, ComObj, Activex, Enterprise01_TLB,
  CTKUtil, AdvGlowButton, AdvCombo, ColCombo, AdvOfficePager,
  AdvOfficePagerStylers, KPICommon, TimesheetEntryForm, TTimesheetDataClass, TTimesheetIniClass,
  Menus, PrntDlgF;

type
  TfrmTimesheetList = class(TForm)
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePage: TAdvOfficePage;
    btnClose: TAdvGlowButton;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    pnlRounded: TPanel;
    OfficeStyler: TAdvOfficePagerOfficeStyler;
    pnlDLLDetails: TPanel;
    lbOurRef: TListBox;
    Label1: TLabel;
    lbDescription: TListBox;
    lbDate: TListBox;
    lbQtyHrs: TListBox;
    lbCharge: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblCharge: TLabel;
    ScrollBar: TScrollBar;
    btnAddNewTimesheet: TAdvGlowButton;
    PopupMenu: TPopupMenu;
    miPrintTimesheet: TMenuItem;
    procedure btnAddNewTimesheetClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbChargeDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure lbOurRefClick(Sender: TObject);
    procedure lbOurRefDblClick(Sender: TObject);
    procedure lbQtyHrsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure pnlDLLDetailsClick(Sender: TObject);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure miPrintTimesheetClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure ScrollBarChange(Sender: TObject);
  private
    FTLAList:  TTLAList;
    FTLAix:    integer;
    FDataPath: ShortString;
    FCurrency: integer;
    FPrevCurr: integer;
    FEmployeeID: ShortString;
    FEmployeeName: ShortString;
    FTimesheetData: TTimesheetData;
    FShowChargeColumn: boolean;
    FShowCostColumn: boolean;
    FOperator: string;
    procedure BeginUpdate;
    procedure DisplayTimesheetData;
    procedure ChangeCaption(ANewCaption: string);
    procedure MakeRounded(Control: TWinControl);
    procedure PrintTimesheet;
    procedure Startup;
    procedure DoScrollBars(SetScrollBar: boolean);
    procedure EndUpdate;
  public
    destructor Destroy; override;
  end;

procedure ShowTimesheetListForm(ADataPath: ShortString; AnEmployeeID: ShortString; AnEmployeeName: string; AnOperator: string);

implementation

{$R *.dfm}

var
  frmTimesheetList: TfrmTimesheetList;

procedure ShowTimesheetListForm(ADataPath: ShortString; AnEmployeeID: ShortString; AnEmployeeName: string; AnOperator: string);
begin
  Screen.Cursor := crHourGlass;
  try
    if frmTimesheetList = nil then
      frmTimesheetList := TfrmTimesheetList.Create(nil);
    with frmTimesheetList do begin
      if trim(ADataPath) <> '' then
        FDataPath     := ADataPath;
      FEmployeeID     := AnEmployeeID;
      FEmployeeName   := AnEmployeeName;
      FOperator       := AnOperator;
      ChangeCaption(format('Timesheets [%s: %s]', [FEmployeeID, FEmployeeName]));
      Startup;
      Screen.Cursor := crDefault;
      ShowModal;
      free;
      frmTimesheetList := nil;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmTimesheetList.btnAddNewTimesheetClick(Sender: TObject);
begin
  screen.Cursor := crHourGlass;
  try
    with TfrmEnterTimesheets.create(FDataPath, FEmployeeID, FEmployeeName, '', FOperator) do begin
      Startup;
      if ShowModal = mrOK then // the user used the Save button to close the data entry form
        self.Startup;          // reload the timesheet list
      screen.Cursor := crDefault;
      free;
    end;
  finally
    screen.Cursor := crDefault;                       
  end;
end;

procedure TfrmTimesheetList.ChangeCaption(ANewCaption: string);
begin
  caption := ANewCaption;
  lblInfo.Caption := ANewCaption;
end;

procedure TfrmTimesheetList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action    := caFree;
  frmTimesheetList := nil;
end;

procedure TfrmTimesheetList.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmTimesheetList.FormCreate(Sender: TObject);
begin
  AdvOfficePage.TabVisible := false;
  MakeRounded(self);
  MakeRounded(pnlRounded);
end;

procedure TfrmTimesheetList.lbOurRefClick(Sender: TObject);
var
  ix: integer;
begin
  ix := TListBox(Sender).ItemIndex;
  BeginUpdate;
  lbOurRef.ItemIndex      := ix;
  lbDescription.ItemIndex := ix;
  lbDate.ItemIndex        := ix;
  lbQtyHrs.ItemIndex      := ix;
  lbCharge.ItemIndex      := ix;
  ScrollBar.Position      := ix;
  DoScrollBars(false);
  EndUpdate;
end;

procedure TfrmTimesheetList.lbOurRefDblClick(Sender: TObject);
begin
  lbOurRefClick(Sender);
  screen.Cursor := crHourGlass;
  try
    with TfrmEnterTimesheets.create(FDataPath, FEmployeeID, FEmployeeName, lbOurRef.Items[lbOurRef.ItemIndex], FOperator) do begin
      Startup;
      screen.Cursor := crDefault;
      if ShowModal = mrOK then // the user used the Save button to close the data entry form
        self.Startup;          // reload the timesheet list
      free;
    end;
  finally
    screen.Cursor := crDefault;
  end;
end;

procedure TfrmTimesheetList.MakeRounded(Control: TWinControl);
var
  R: TRect;
  Rgn: HRGN;
begin
  with Control do
  begin
    R := ClientRect;
    rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, 20, 20);
    Perform(EM_GETRECT, 0, lParam(@r));
    InflateRect(r, -5, -5);
    Perform(EM_SETRECTNP, 0, lParam(@r));
    SetWindowRgn(Handle, rgn, True);
    Invalidate;
  end;
end;

procedure TfrmTimesheetList.pnlDLLDetailsClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, pnlDLLDetails.Color, true);
end;

procedure TfrmTimesheetList.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmTimesheetList.Startup;
begin
  if FTimesheetData <> nil then begin
    FTimesheetData.Free;
    FTimesheetData := nil;
  end;
  FTimesheetData := TTimesheetData.Create(FDataPath, FEmployeeID);
  TimesheetSettings.Free;  // v13 *** this needs to recreate the object to pick up changes made by someone else
  TimesheetSettings(FDataPath).EmpCode := FEmployeeID;
  FShowChargeColumn := TimesheetSettings.ShowTotalCharge;
  FShowCostColumn   := TimesheetSettings.ShowTotalCost;
  if FShowCostColumn then
    lblCharge.Caption := 'Cost'
  else
  if not FShowChargeColumn then
    lblCharge.Caption := '';
  DisplayTimesheetData;
end;

destructor TfrmTimesheetList.Destroy;
begin
  if FTimesheetData <> nil then
    FTimesheetData.Free;
  inherited;
end;

procedure TfrmTimesheetList.BeginUpdate;
begin
 lbOurRef.Items.BeginUpdate;
 lbDescription.Items.BeginUpdate;
 lbDate.Items.BeginUpdate;
 lbQtyHrs.Items.BeginUpdate;
 lbCharge.Items.BeginUpdate;
end;

procedure TfrmTimesheetList.DoScrollBars(SetScrollBar: boolean);
var
  min, max: integer;
begin
  if SetScrollBar then begin
    GetScrollRange(lbOurRef.Handle, SB_VERT, min, max);
    Scrollbar.Min := min;
    Scrollbar.Max := max;
    Scrollbar.Position := 0;
    ScrollBar.Enabled := Max > 0;
  end;
  SetScrollRange(lbOurRef.Handle, SB_VERT,0,0,True);
  SetScrollRange(lbDescription.Handle, SB_VERT,0,0,True);
  SetScrollRange(lbDate.Handle, SB_VERT,0,0,True);
  SetScrollRange(lbQtyHrs.Handle, SB_VERT,0,0,True);
  SetScrollRange(lbCharge.Handle, SB_VERT,0,0,True);
end;

procedure TfrmTimesheetList.DisplayTimesheetData;
var
  Timesheet: TTimesheet;
begin
  lbOurRef.Clear; lbDescription.Clear; lbDate.Clear; lbQtyHrs.Clear; lbCharge.Clear;
  Timesheet := FTimesheetData.FirstTimesheet;
  while Timesheet <> nil do begin
    with Timesheet do begin
      lbOurRef.Items.Add(OurRef);
      lbDescription.Items.Add(Description);
      lbDate.Items.Add(format(' %s/%s/%s', [copy(TransDate, 7, 2), copy(TransDate, 5, 2), copy(TransDate, 1, 4)]));
      lbQtyHrs.Items.Add(format('%.*f', [FTimesheetData.QtyDecimals, TotalQtyHrs]));
      if FShowChargeColumn then
        lbCharge.Items.Add(format('%s %f', [GCurrencySymbols[0], TotalCharge]))
      else
      if FShowCostColumn then
        lbCharge.Items.Add(format('%s %f', [GCurrencySymbols[0], TotalCost]));
    end;
    Timesheet := FTimesheetData.NextTimesheet;
  end;
  DoScrollBars(true);
end;

procedure TfrmTimesheetList.EndUpdate;
begin
 lbOurRef.Items.EndUpdate;
 lbDescription.Items.EndUpdate;
 lbDate.Items.EndUpdate;
 lbQtyHrs.Items.EndUpdate;
 lbCharge.Items.EndUpdate;
end;

procedure TfrmTimesheetList.lbChargeDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
// right-justify each item in the listbox
begin
  lbCharge.Canvas.FillRect(Rect);
  if index >= 0 then
    if Length(lbCharge.Items[index]) > 0 then begin
      DrawText(lbCharge.Canvas.handle, PChar(lbCharge.Items[index] + ' '), Length(lbCharge.Items[index]) + 1, Rect,
                DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_RIGHT);
    end;
end;

procedure TfrmTimesheetList.lbQtyHrsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
// right-justify each item in the listbox
begin
  lbQtyHrs.Canvas.FillRect(Rect);
  if index >= 0 then
    if Length(lbQtyHrs.Items[index]) > 0 then begin
      DrawText(lbQtyHrs.Canvas.handle, PChar(lbQtyHrs.Items[index] + ' '), Length(lbQtyHrs.Items[index]) + 1, Rect,
                DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_RIGHT);
    end;
end;

procedure TfrmTimesheetList.miPrintTimesheetClick(Sender: TObject);
begin
  PrintTimesheet;
end;

procedure TfrmTimesheetList.PopupMenuPopup(Sender: TObject);
begin
  miPrintTimesheet.Enabled := lbOurRef.ItemIndex <> -1;
end;

procedure TfrmTimesheetList.PrintTimesheet;
var
  lToolkit: IToolkit;
  oPrintJob : IPrintJob;
  Res       : LongInt;
begin
  if lbOurRef.ItemIndex = -1 then EXIT;
  screen.Cursor := crHourGlass;
  try
    lToolkit := OpenToolkit(FDataPath, true);
    if lToolkit <> nil then begin
      try
        With lToolkit, Transaction Do Begin
          // Find specified Transaction
          Index := thIdxOurRef;
          Res := GetEqual(BuildOurRefIndex(lbOurRef.Items[lbOurRef.ItemIndex]));
          If (Res = 0) Then Begin
            // Got Transaction - Setup reference to descendant object and
            // Use the print method to print it directly to printer using
            // the default settings
            oPrintJob := (Transaction As ITransaction2).Print(thpmDefault);
            Try
              // Import the default settings for this Print Job
              oPrintJob.ImportDefaults;

              // Create the Print To Dialog and
              With TfrmPrintDlg.Create(Self) Do
                Try
                  // Pass the PrintJob object into the dialog
                  SetPrinterObject (oPrintJob, 'Print ' + thOurRef);
                  Toolkit := lToolkit;

                  // Display the Print To dialog
                  ShowModal;
                Finally
                  Free;
                End; // Try
            Finally
              oPrintJob := NIL;
            End // Try
          End // If (Res = 0)
          Else
            ShowMessage ('Error ' + IntToStr(Res) + ' was returned attempting to find the specified transaction');
        End; // With oToolkit.Transaction
      finally
        lToolkit.CloseToolkit;
      end;
    end;
  finally
    screen.Cursor := crDefault;
  end;
end;

procedure TfrmTimesheetList.ScrollBarChange(Sender: TObject);
begin
  BeginUpdate;
  lbOurRef.ItemIndex      := ScrollBar.Position;
  lbDescription.ItemIndex := ScrollBar.Position;
  lbDate.ItemIndex        := ScrollBar.Position;
  lbQtyHrs.ItemIndex      := ScrollBar.Position;
  lbCharge.ItemIndex      := ScrollBar.Position;
  DoScrollBars(false);
  EndUpdate;
end;

initialization
  frmTimesheetList := nil;

{  frmTimesheetList := TfrmTimesheetList.Create(nil); // this gets called when Outlook creates the KPI Host and the KPI Host creates this COM object.
                                       // Outlook destroys and re-creates the KPI Host several times
                                       // E.g. This unit gets Finalized and Re-Initialized if you are viewing Outlook Today and
                                       // open and close the Outlook options dialog.
                                       // Initialization of this unit occurs before TDayBookTotals.Initialize gets called.
}

finalization
  if assigned(frmTimesheetList) then begin
    frmTimesheetList.free;
    frmTimesheetList := nil;
  end;

end.
