unit VRWSelectForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, AdvOfficePager,
  AdvOfficePagerStylers, AdvEdit, AdvCombo, ColCombo, Mask, AdvSpin,
  AdvGlowButton, AdvPanel, Enterprise01_TLB, ComObj, ActiveX, KPICommon,
  ImgList, VRWCOM_TLB;

type
  TfrmSelectVRW = class(TForm)
    advPanel: TAdvPanel;
    OkButton: TAdvGlowButton;
    AdvGlowButton1: TAdvGlowButton;
    ofConfig: TAdvOfficePager;
    ofpReports: TAdvOfficePage;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    pnlRounded: TPanel;
    pgStyler: TAdvOfficePagerOfficeStyler;
    ReportsGrp: TGroupBox;
    ReportTree: TTreeView;
    ilTree: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure advPanelDblClick(Sender: TObject);
    procedure ReportTreeChange(Sender: TObject; Node: TTreeNode);
    procedure FormDestroy(Sender: TObject);
    procedure ReportTreeDblClick(Sender: TObject);
  private
    FDataPath: string;
    FSelectedReport: TReportInfo;
    oReportTreeData : IReportTree;
    TreeNodeType, TreeNodeName, TreeNodeDesc,
    TreeNodeParent, TreeNodeChild, FileName, LastRun : WideString;
    AllowEdit : WordBool;
    sPrevCode : string;
    procedure ClearTree;
    Procedure SetHost (Value : HWND);
    procedure MakeRounded(Control: TWinControl);
    procedure FillReportTree(const ParentID : ShortString; Node : TTreeNode);
    function GetDataPath: ShortString;
    procedure SetDataPath(const Value: ShortString);
  public
    { Public declarations }
    property DataPath: ShortString read GetDataPath write SetDataPath;
    property SelectedReport: TReportInfo read FSelectedReport;
    Property Host : HWND Write SetHost;
  end;

implementation

{$R *.dfm}

var
  CurrentCompanyRec : TCompanyRec;

//function GetReportTree : IReportTree_Interface; external 'REPENGINE.DLL';

//=========================================================================

procedure TfrmSelectVRW.FormCreate(Sender: TObject);
begin
  // Centre - can't use poScreenCentre because of Host property not working
//  Self.Top := (Screen.Height - - Self.Height) Div 2;
//  Self.Left := (Screen.Width - Self.Width) Div 2;
  MakeRounded(self);
  MakeRounded(pnlRounded);
  MakeRounded(advPanel);
  FSelectedReport := nil;
end;

//------------------------------------------------------------------------------

procedure TfrmSelectVRW.FormDestroy(Sender: TObject);
begin
  ClearTree;
end;

//------------------------------------------------------------------------------

procedure TfrmSelectVRW.ClearTree;
var
  iPos: integer;
begin
  ReportTree.FullCollapse;
  for iPos := 0 to ReportTree.Items.Count - 1 do
    TObject(ReportTree.Items[iPos].Data).Free;
  ReportTree.Items.Clear;
end;

//------------------------------------------------------------------------------

procedure TfrmSelectVRW.FillReportTree(const ParentID: ShortString;
  Node: TTreeNode);
var
  Res, Res1 : SmallInt;
  i : integer;
  ThisGroup : ShortString;
  FilePos : longint;
  ThisNode : TTreeNode;
  LocalParentID : ShortString;
  ReportInfo : TReportInfo;
begin
//  if Node = nil then
  if (oReportTreeData = nil) then
  begin
    oReportTreeData := CreateOLEObject('VRWCOM.ReportTree') as IReportTree;
    oReportTreeData.Datapath := FDataPath;
    oReportTreeData.UserID   := KPIUserID;
    Res := oReportTreeData.GetFirstReport(TreeNodeType, TreeNodeName, TreeNodeDesc,
                    TreeNodeParent, TreeNodeChild, FileName, LastRun, AllowEdit);
  end
  else
    Res := 0;

  if Res = 0 then
  begin
    LocalParentID := ParentID;
    AllowEdit := False;
    Res := oReportTreeData.GetGEqual(LocalParentID, TreeNodeType, TreeNodeName, TreeNodeDesc,
                        TreeNodeParent, TreeNodeChild, FileName, LastRun, AllowEdit);
    while (Res = 0) and (Trim(LocalParentID) = Trim(TreeNodeParent)) do
    begin

      ThisNode := ReportTree.Items.AddChild(Node,TreeNodeName + ' - ' + TreeNodeDesc);

      // Create and add Object to hold info
      ReportInfo := TReportInfo.Create;
      With ReportInfo.ReportRec do
      begin
        cNodeType := TreeNodeType[1];
        sCode := TreeNodeName;
        sName := TreeNodeDesc;
        sFileName := FileName;
        sLastRun := LastRun;
        bAllowEdit := AllowEdit;
      end;{with}
      ThisNode.Data := ReportInfo;

      // select node
      if (sPrevCode = TreeNodeName) then ReportTree.Selected := ThisNode;

      if TreeNodeType = 'H' then
      begin
        Res1 := oReportTreeData.SavePosition(FilePos);
        FillReportTree(TreeNodeChild, ThisNode);
        Res1 := oReportTreeData.RestorePosition(FilePos);

        // Folder Icon
        ThisNode.ImageIndex := 0;
        ThisNode.SelectedIndex := 0;
      end else
      begin
        // Document Icon
        ThisNode.ImageIndex := 2;
        ThisNode.SelectedIndex := 2;
      end;

      Res := oReportTreeData.GetNext(TreeNodeType, TreeNodeName, TreeNodeDesc
      , TreeNodeParent, TreeNodeChild, FileName, LastRun, AllowEdit);
    end;{while}

    if Node = nil then oReportTreeData := nil;
  end;
end;

//------------------------------------------------------------------------------

Procedure TfrmSelectVRW.SetHost (Value : HWND);
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

procedure TfrmSelectVRW.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end;
end;

procedure TfrmSelectVRW.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmSelectVRW.MakeRounded(Control: TWinControl);
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

procedure TfrmSelectVRW.FormActivate(Sender: TObject);
begin
  ofpReports.SetFocus;
end;

procedure TfrmSelectVRW.advPanelDblClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, 0, false);
end;

function TfrmSelectVRW.GetDataPath: ShortString;
begin
  Result := FDataPath;
end;

procedure TfrmSelectVRW.SetDataPath(const Value: ShortString);
begin
  FDataPath := Value;
  FillReportTree('0', nil);
end;

procedure TfrmSelectVRW.ReportTreeChange(Sender: TObject; Node: TTreeNode);
var
  ReportInfo: TReportInfo;
begin
  ReportInfo := TReportInfo(Node.Data);
  if ReportInfo.ReportRec.cNodeType = 'H' then
  begin
    OKButton.Enabled := False;
    FSelectedReport := nil;
  end
  else
  begin
    OKButton.Enabled := True;
    FSelectedReport := ReportInfo;
  end;
end;

procedure TfrmSelectVRW.ReportTreeDblClick(Sender: TObject);
begin
  if (OKButton.Enabled) then
    ModalResult := mrOk;
end;

end.
