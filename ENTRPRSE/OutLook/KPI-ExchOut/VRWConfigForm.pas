unit VRWConfigForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, AdvOfficePager,
  AdvOfficePagerStylers, AdvEdit, AdvCombo, ColCombo, Mask, AdvSpin,
  AdvGlowButton, AdvPanel, Enterprise01_TLB, ComObj, ActiveX, KPICommon;

type
  TfrmConfigureVRW = class(TForm)
    advPanel: TAdvPanel;
    btnSave: TAdvGlowButton;
    AdvGlowButton1: TAdvGlowButton;
    ofConfig: TAdvOfficePager;
    ofpReports: TAdvOfficePage;
    Label3: TLabel;
    lblPort: TLabel;
    seRows: TAdvSpinEdit;
    ccbCompany: TColumnComboBox;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    pnlRounded: TPanel;
    pgStyler: TAdvOfficePagerOfficeStyler;
    ReportsGrp: TGroupBox;
    ReportListPnl: TPanel;
    ReportList: TListView;
    AddButton: TAdvGlowButton;
    RemoveButton: TAdvGlowButton;
    MoveUpButton: TAdvGlowButton;
    MoveDownButton: TAdvGlowButton;
    ReportListLbl: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure seRowsChange(Sender: TObject);
    procedure ccbCompanyChange(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure advPanelDblClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddButtonClick(Sender: TObject);
    procedure RemoveButtonClick(Sender: TObject);
    procedure MoveUpButtonClick(Sender: TObject);
    procedure MoveDownButtonClick(Sender: TObject);
  private
    FCanClose: boolean;
    FCompany: ShortString;
    FDataPath: string;
    FHasChanged: Boolean;
    FDataRows: WideString;
    FLoggedIn: Boolean;
    FUserID: string;
    Function  GetCompany : ShortString;
    Procedure SetCompany (Value : ShortString);
    Procedure SetHost (Value : HWND);
    Function  GetRows : SmallInt;
    Procedure SetRows (Value : SmallInt);
    procedure MakeRounded(Control: TWinControl);
    procedure PopulateCompanyList;
    procedure PopulateLists;
    procedure SetHasChanged(const Value: Boolean);
    property HasChanged: Boolean read FHasChanged write SetHasChanged;
    procedure SetDataRows(const Value: WideString);
    procedure SetLoggedIn(const Value: Boolean);
    function ReportInstalled(const Code: string): Boolean;
    procedure SetUserID(const Value: string);
  public
    { Public declarations }
    Property Company : ShortString Read GetCompany Write SetCompany;
    Property Host : HWND Write SetHost;
    Property Rows : SmallInt Read GetRows Write SetRows;
    Property DataRows: WideString read FDataRows write SetDataRows;
    Property DataPath: string read FDataPath write FDataPath;
    Property LoggedIn: Boolean read FLoggedIn write SetLoggedIn;
    Property UserID: string read FUserID write SetUserID;
    procedure Startup;
  end;

implementation

{$R *.dfm}

uses VRWSelectForm, gmXML;

//=========================================================================

procedure TfrmConfigureVRW.FormCreate(Sender: TObject);
begin
  // Centre - can't use poScreenCentre because of Host property not working
//  Self.Top := (Screen.Height - - Self.Height) Div 2;
//  Self.Left := (Screen.Width - Self.Width) Div 2;
  MakeRounded(self);
  MakeRounded(pnlRounded);
  MakeRounded(advPanel);
  PopulateCompanyList;
  FHasChanged := False;
end;

//------------------------------------------------------------------------------

function TfrmConfigureVRW.GetCompany: ShortString;
begin
  Result := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 0];
end;
procedure TfrmConfigureVRW.SetCompany(Value: ShortString);
begin
  FCompany := Value;
end;

//------------------------------

Procedure TfrmConfigureVRW.SetHost (Value : HWND);
Var
  lpRect: TRect;
Begin // SetHost
  If (Value <> 0) Then
  Begin
    // Get the host window position and centre the login dialog over it
    If GetWindowRect(Value, lpRect) Then
    Begin
      // Top = Top of Host + (0.5 * Host Height) - (0.5 * Self Height)
      Self.Top := lpRect.Top + ((lpRect.Bottom - lpRect.Top - Self.Height) Div 2);

      // Left = Left of Host + (0.5 * Host Width) - (0.5 * Self Width)
      Self.Left := lpRect.Left + ((lpRect.Right - lpRect.Left - Self.Width) Div 2);

      // Make sure it is still fully on the screen
      If (Self.Top < 0) Then Self.Top := 0;
      If ((Self.Top + Self.Height) > Screen.Height) Then Self.Top := Screen.Height - Self.Height;
      If (Self.Left < 0) Then Self.Left := 0;
      If ((Self.Left + Self.Width) > Screen.Width) Then Self.Left := Screen.Width - Self.Width;
    End; // If GetWindowRect(Value, lpRect)
  End; // If (Value <> 0)
End; // SetHost

//------------------------------

function TfrmConfigureVRW.GetRows: SmallInt;
begin
  Result := seRows.Value;
end;
procedure TfrmConfigureVRW.SetRows(Value: SmallInt);
begin
  seRows.Value := Value;
end;

//-------------------------------------------------------------------------

procedure TfrmConfigureVRW.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end;
end;

procedure TfrmConfigureVRW.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmConfigureVRW.MakeRounded(Control: TWinControl);
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

procedure TfrmConfigureVRW.FormActivate(Sender: TObject);
begin
  ofpReports.SetFocus;
end;

procedure TfrmConfigureVRW.Startup;
begin
  PopulateLists;
  HasChanged := False;
end;

procedure TfrmConfigureVRW.PopulateLists;
begin
  PopulateCompanyList;
end;

procedure TfrmConfigureVRW.PopulateCompanyList;
var
  toolkit: IToolkit;
  i : SmallInt;
begin
  ccbCompany.ComboItems.Clear;
  toolkit := CoToolkit.Create;
  if assigned(toolkit) then
  try
    if (Toolkit.Company.cmCount > 0) then
      with Toolkit.Company do
        for i := 1 to cmCount do
          if DirectoryExists(cmCompany[i].coPath) then
             with ccbCompany.ComboItems.Add do
             begin
                strings.Add(trim(cmCompany[i].coCode));
                strings.Add(trim(cmCompany[i].coName));
                strings.Add(trim(cmCompany[i].coPath));
             end;
    ccbCompany.ItemIndex := ccbCompany.ComboItems.IndexInColumnOf(0, FCompany);
  finally
    toolkit := nil;
  end;
  if (ccbCompany.ItemIndex <> -1) then
  begin
    FDataPath := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 2];
  end;
end;

procedure TfrmConfigureVRW.seRowsChange(Sender: TObject);
begin
  HasChanged := true;
  if seRows.Value < 1 then // if you set a MinVal you must also set MaxValue (and MinVal = 0 means no minimum)
    seRows.Value := 1;     // so need to control minimum value manually
end;

procedure TfrmConfigureVRW.ccbCompanyChange(Sender: TObject);
begin
  if (FCompany <> ccbCompany.ColumnItems[ccbCompany.ItemIndex, 0]) then
  begin
    HasChanged := true;
    FDataPath := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 2];
    DataRows := '<Data></Data>';
  end;
end;

procedure TfrmConfigureVRW.AdvGlowButton1Click(Sender: TObject);
begin
  FCanClose := True;
  if FHasChanged then
    if MessageDlg('Are you sure you want to cancel your changes ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      FCanClose := False;
end;

procedure TfrmConfigureVRW.advPanelDblClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, 0, false);
end;

procedure TfrmConfigureVRW.btnSaveClick(Sender: TObject);
begin
  FCanClose := true;
end;

procedure TfrmConfigureVRW.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FCanClose then
    action := caFree
  else
    action := caNone;
end;

procedure TfrmConfigureVRW.AddButtonClick(Sender: TObject);
var
  frmSelectReport : TfrmSelectVRW;
begin // Configure
  frmSelectReport := TfrmSelectVRW.Create(NIL);
  try
    with frmSelectReport do
    begin
      Host     := self.Handle;
      Caption  := 'Select Report';
      DataPath := FDataPath;
    end;
    if (frmSelectReport.ShowModal = mrOK) and
       (frmSelectReport.SelectedReport <> nil) Then
    begin
      if not ReportInstalled(frmSelectReport.SelectedReport.ReportRec.sCode) then
      begin
        with ReportList.Items.Add do
        begin
          Caption := frmSelectReport.SelectedReport.ReportRec.sCode;
          SubItems.Add(frmSelectReport.SelectedReport.ReportRec.sName);
        end;
        HasChanged := true;
      end;
    end;
  finally
    FreeAndNIL(frmSelectReport);
  end;
end;

procedure TfrmConfigureVRW.SetHasChanged(const Value: Boolean);
begin
  FHasChanged := Value;
  btnSave.Enabled := Value;
end;

procedure TfrmConfigureVRW.SetDataRows(const Value: WideString);
var
  XML: TgmXML;
  DataNode : TGmXmlNode;
  Row: Integer;
begin
  FDataRows := Value;
  ReportList.Clear;
  XML := TgmXML.Create(nil);
  try
    XML.Text := FDataRows;
    DataNode := XML.Nodes.NodeByName['Data'];
    if assigned(DataNode) then
    begin
      FDataRows := '<Data>';
      for Row := 0 to DataNode.Children.Count - 1 do
      begin
        with ReportList.Items.Add do
        begin
          Caption := DataNode.Children[Row].Children[0].AsString;
          SubItems.Add(DataNode.Children[Row].Children[1].AsString);
        end;
      end;
      FDataRows := FDataRows + '</Data>';
    end;
  finally
    XML.Free;
  end;
end;

procedure TfrmConfigureVRW.SetLoggedIn(const Value: Boolean);
begin
  FLoggedIn := Value;
  ReportListPnl.Visible := FLoggedIn;
  if FLoggedIn then
    ReportListPnl.Top := 16
  else
    ReportListPnl.Top := 48;
end;

procedure TfrmConfigureVRW.RemoveButtonClick(Sender: TObject);
begin
  if ReportList.Selected <> nil then
  begin
    ReportList.Items.Delete(ReportList.Selected.Index);
    HasChanged := True;
  end;
end;

procedure TfrmConfigureVRW.MoveUpButtonClick(Sender: TObject);
var
  Item: TListItem;
  Index: Integer;
begin
  if ReportList.Selected <> nil then
  begin
    if ReportList.Selected.Index > 0 then
    begin
      Index := ReportList.Selected.Index;
      // Take a temporary copy of the selected item.
      Item := TListItem.Create(ReportList.Items);
      try
        Item.Assign(ReportList.Items.Item[Index]);
        // Copy the prior item in the list into the position of the selected item
        ReportList.Items.Item[Index] := ReportList.Items.Item[Index - 1];
        // Copy the saved item into the prior position in the list
        ReportList.Items.Item[Index - 1].Assign(Item);
        ReportList.Selected := ReportList.Items.Item[Index - 1];
      finally
        Item.Free;
        HasChanged := True;
      end;
    end;
  end;
end;

procedure TfrmConfigureVRW.MoveDownButtonClick(Sender: TObject);
var
  Item: TListItem;
  Index: Integer;
begin
  if ReportList.Selected <> nil then
  begin
    if ReportList.Selected.Index < ReportList.Items.Count - 1 then
    begin
      Index := ReportList.Selected.Index;
      // Take a temporary copy of the selected item.
      Item := TListItem.Create(ReportList.Items);
      try
        Item.Assign(ReportList.Items.Item[Index]);
        // Copy the next item in the list into the position of the selected item
        ReportList.Items.Item[Index] := ReportList.Items.Item[Index + 1];
        // Copy the saved item into the next position in the list
        ReportList.Items.Item[Index + 1].Assign(Item);
        ReportList.Selected := ReportList.Items.Item[Index + 1];
      finally
        Item.Free;
        HasChanged := True;
      end;
    end;
  end;
end;

function TfrmConfigureVRW.ReportInstalled(const Code: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to ReportList.Items.Count - 1 do
  begin
    if (ReportList.Items[i].Caption = Code) then
    begin
      Result := True;
      break;
    end;
  end;
end;

procedure TfrmConfigureVRW.SetUserID(const Value: string);
begin
  FUserID   := Value;
  KPIUserID := Value;
end;

end.
