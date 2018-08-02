unit RptTree;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, IniFiles, Grids, Menus,
  GlobalTypes, RptEngDll, RepTreeIF, RepEngIF, // my own
  VRWReportIF, VRWReportDataIF, // revised report tree
  RptDesignerF,                 // revised Report Designer
  RptWizardTypes,
  COMObj, Enterprise01_TLB, EnterToTab, VirtualTrees, ImgList,
  ActnList, TCustom, Buttons
{$IFDEF DEBUGON}
  , DbgWin2
{$ENDIF}
  ;

const
  WM_PrintProgress = WM_USER + $101;
  WM_InPrint       = WM_USER + $103;

type
  TfrmReportTree = class(TForm)
    pnlButtons: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnClose: TButton;
    btnPrint: TButton;
    btnFind: TButton;
    btnCopy: TButton;
    pmTreeMenu: TPopupMenu;
    miAdd: TMenuItem;
    miEdit: TMenuItem;
    miFind: TMenuItem;
    miPrint: TMenuItem;
    miCopy: TMenuItem;
    submiExpand: TMenuItem;
    submiCollapse: TMenuItem;
    N1: TMenuItem;
    miExpandThisLevel: TMenuItem;
    miExpandAllLevels: TMenuItem;
    miExpandEntireTree: TMenuItem;
    miCollapseThisLevel: TMenuItem;
    miCollapseEntireTree: TMenuItem;
    N2: TMenuItem;
    miSaveCoordinates: TMenuItem;
    N3: TMenuItem;
    btnMove: TButton;
    muMainMenu: TMainMenu;
    FileMenu: TMenuItem;
    FileHelp: TMenuItem;
    HelpAbout: TMenuItem;
    miFileExit: TMenuItem;
    miMove: TMenuItem;
    pnlProgressBar: TPanel;
    miDeleteReport: TMenuItem;
    miFileSecurity: TMenuItem;
    miConvertReport: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    miAddReport: TMenuItem;
    miEditReport: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    miFindReport: TMenuItem;
    miCopyReport: TMenuItem;
    N8: TMenuItem;
    miPrintReport: TMenuItem;
    N9: TMenuItem;
    miReportDispProps: TMenuItem;
    miImportReport: TMenuItem;
    dlgImportReport: TOpenDialog;
    HelpContents1: TMenuItem;
    N10: TMenuItem;
    SearchforHelpOn1: TMenuItem;
    HowtoUseHelp1: TMenuItem;
    mnuDebug: TMenuItem;
    miReportDump: TMenuItem;
    DumpVRWSECDATtoFile1: TMenuItem;
    Moveup1: TMenuItem;
    Movedown1: TMenuItem;
    VRWReportTree: TVirtualStringTree;
    Images: TImageList;
    ActionList: TActionList;
    actAdd: TAction;
    actEdit: TAction;
    actDelete: TAction;
    actPrint: TAction;
    actFind: TAction;
    actCopy: TAction;
    actConvert: TAction;
    actImport: TAction;
    actSecurity: TAction;
    actDisplayProperties: TAction;
    actClose: TAction;
    actLift: TAction;
    actDrop: TAction;
    actMoveUp: TAction;
    actMoveDown: TAction;
    actCollapseTree: TAction;
    actCollapseLevel: TAction;
    actExpandTree: TAction;
    actExpandLevel: TAction;
    actExpandAll: TAction;
    pnlHeading: TPanel;
    pnlLastRun: TPanel;
    btnCancelPrint: TSBSButton;
    actCancelPrint: TAction;
    actReportProperties: TAction;
    Properties1: TMenuItem;
    actCancelDrop: TAction;
    btnCancelDrop: TSBSButton;
    Canceldrop1: TMenuItem;
    actPrintReport: TAction;
    pbLabel: TStaticText;
    pbReportProgress: TProgressBar;
    actDefaultPosition: TAction;
    RestoreDefaultPosition1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);

    procedure ClearVRWRec(var VRWRec: TVRWReportDataRec);
    procedure PopulateVRWRec(var VRWRec: TVRWReportDataRec);
    procedure HelpAboutClick(Sender: TObject);
    procedure HelpContents1Click(Sender: TObject);
    procedure SearchforHelpOn1Click(Sender: TObject);
    procedure HowtoUseHelp1Click(Sender: TObject);
    procedure miReportDumpClick(Sender: TObject);
    procedure DumpVRWSECDATtoFile1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PrepareDesignWindow(frmDesignWindow: TfrmReportDesigner);

    { ActionList event handlers }
    procedure actAddExecute(Sender: TObject);
    procedure actCancelDropExecute(Sender: TObject);
    procedure actCancelPrintExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actCollapseLevelExecute(Sender: TObject);
    procedure actCollapseTreeExecute(Sender: TObject);
    procedure actConvertExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actDisplayPropertiesExecute(Sender: TObject);
    procedure actDropExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actExpandAllExecute(Sender: TObject);
    procedure actExpandLevelExecute(Sender: TObject);
    procedure actExpandTreeExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actImportExecute(Sender: TObject);
    procedure actLiftExecute(Sender: TObject);
    procedure actMoveDownExecute(Sender: TObject);
    procedure actMoveUpExecute(Sender: TObject);
    procedure actPrintReportExecute(Sender: TObject);
    procedure actReportPropertiesExecute(Sender: TObject);
    procedure actSecurityExecute(Sender: TObject);

    { VRWReportTree event handlers }
    procedure VRWReportTreeChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode);

    procedure VRWReportTreeDblClick(Sender: TObject);

    procedure VRWReportTreeGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);

    procedure VRWReportTreeGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);

    procedure VRWReportTreePaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);

    procedure VRWReportTreeCollapsed(Sender: TBaseVirtualTree;
      Node: PVirtualNode);

    { Callback routines from the report wizard (TfrmDesignWindow) }
    procedure AfterPrintReport(UserName: ShortString;
      var FunctionResult: LongInt);

    procedure OnAddGroupHeading(Params: TReportWizardParams;
      ParentName, FileName: string; var FunctionResult: LongInt);

    procedure OnSaveReport(Params: TReportWizardParams;
      ParentName, FileName: string; var FunctionResult: LongInt);

    procedure OnValidateReportName(const ReportName: ShortString;
      var IsValid: Boolean);

    { Callback routines from the report }
    procedure OnPrintRecord(Count, Total: integer; var Abort: Boolean);
    procedure OnFirstPass(Count, Total: integer; var Abort: Boolean);
    procedure OnSecondPass(Count, Total: integer; var Abort: Boolean);
    procedure actDefaultPositionExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  private
    { Private declarations }

    { For Move and Drop, stores the the node which has been selected
      for moving. }
    NodeToMove: PVirtualNode;

    { There doesn't seem to be a reliable way of determining the root node
      of the Virtual Tree, so the root node will be stored in this variable
      instead }
    RootNode: PVirtualNode;

    { Flag to indicate that the tree view is currently being populated }
    Populating: Boolean;

    { Flat to indicate that a report is currently being printed }
    Printing: Boolean;

    { Flag to indicate that the user has clicked the 'Cancel' button while
      printing a report }
    CancelPrint: Boolean;

// removed but may need it.
//    FUserList : TStringList;

    HighlightedItem : LongInt;

    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    VRWReportData: IVRWReportData;

    DoneRestore : Boolean;

//    procedure RefreshReportTree;

    function CanDropHere(TargetNode: PVirtualNode): Boolean;
    procedure CheckFolderContents(Node: PVirtualNode);
    function Confirm(Msg: string): Boolean;
    function IsRootNode(Node: PVirtualNode): Boolean;
    procedure RefreshVRWReportData;
    function SyncData(Node: PVirtualNode): Boolean;
    function UpdateData(VRWRec: TVRWReportDataRec): LongInt;
    procedure UpdateDisplay;
    procedure MoveNode(SourceNode, TargetNode: PVirtualNode);
    function FindNodeByName(NodeName: string): PVirtualNode;
    function IsEmptyFolder(Node: PVirtualNode): Boolean;

    procedure ReadRptDisplayProps(var FontList : TStringList);

    procedure ShowProgressMonitor(siPercentComplete : SmallInt; var AAbort : Boolean);

    procedure PrintProgress(var Msg: TMessage); message WM_PrintProgress;

    // Controls the loading/saving of the colours and positions
    //
    // Mode   0=Load Details, 1=Save Details, 2=Delete Details
    procedure SetColoursUndPositions (Const Mode : Byte);

    // Control the minimum size that the form can resize to - works better than constraints
    procedure WMGetMinMaxInfo(var message  :  TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
  public
    { Public declarations }
    sReportPath : TFileName;
    sReportFileName : TFileName;

    FChildID,
    FParentID : string[4{ID_LGTH}];

  end;

var
  frmReportTree: TfrmReportTree;

implementation

{$R *.dfm}
{$R ENTRW.Man.Res}

{$WARN UNIT_DEPRECATED OFF}
uses
  OutLine, // Delphi
  ETStrU, BtrvU2, BTSupU1, BTSupU2, VarConst, // exchequer
  CTKUtil, History, AboutF, IIFFuncs,
  TreeSecurity, RptTreeEdt, CtrlPrms, // my own
  uSettings,          // Colour/Position editing and saving routines
  RptDisp, RptCopy,
  ConvertOldRepF,    // Report Tree for converting the Windows Report Writer reports
  VRWConverterIF,
  FindReportF,       // Find Report dialog off the Report Tree
  EntLicence,
  RptWizardF, DesignerUtil,
{$IFDEF EXSQL}
  SQLUtils, ADOConnect,
{$ENDIF}
  frmRptTreePropertiesU; // my own
{$WARN UNIT_DEPRECATED ON}

// === ActionList event handlers ===============================================

procedure TfrmReportTree.actAddExecute(Sender: TObject);
{ Creates a new report or folder.

  If the currently highlighted selection is a folder, the new report or folder
  will be placed inside the selected folder (i.e. as a child node). If the
  currently highlighted selection is a report, the new report or folder will
  be placed in the same folder as the selection. }
var
  frmRepWizard: TfrmRepWizard;
  frmReportDesigner : TfrmReportDesigner;
  NewReportDets : TReportWizardParams;
  FunctionResult: Integer;
  DoAdd         : Boolean;
  ParentReport: string;
  VRWRec: ^TVRWReportDataRec;
begin
  if (VRWReportTree.FocusedNode <> nil) then
  begin
    VRWRec := VRWReportTree.GetNodeData(VRWReportTree.FocusedNode);
    if (VRWRec^.rtNodeType = 'H') then
    begin
      { Current node is a folder -- make it the parent of the new
        report/folder. The root of the tree is a dummy entry, use a blank
        parent code instead. }
      if (VRWReportTree.FocusedNode.Parent = nil) then
        ParentReport := ''
      else
        ParentReport := Trim(VRWRec^.rtRepName);
    end
    else
      { Current node is a report -- use its parent as the parent of the new
        report/folder }
      ParentReport := Trim(VRWRec^.rtParentName);
  end
  else
  begin
    { No currently selected node. Attach the report/folder to the root. }
    ParentReport := '';
  end;

  // Display the Add Report/Group Wizard
  NewReportDets := TReportWizardParams.Create;
  Try
    frmRepWizard := TfrmRepWizard.Create(Self);
    Try
      // Setup callbacks for validation
      frmRepWizard.OnValidateReportName := OnValidateReportName;
      frmRepWizard.WizardReport := NewReportDets;
      DoAdd := (frmRepWizard.ShowModal = mrOK);
    Finally
      frmRepWizard.Free;
    End; // Try..Finally

    If DoAdd Then
    Begin
      // Add Group into Report Tree or display Report Designer
      If (NewReportDets.wrType = wrtGroup) Then
      Begin
        OnAddGroupHeading(NewReportDets, ParentReport, '', FunctionResult);
      End // If (NewReportDets.wrType = wrtGroup)
      Else
      Begin
        frmReportDesigner := TfrmReportDesigner.Create(Self);
        Try
          frmReportDesigner.rdTreeParent := ParentReport;
          frmReportDesigner.OnSaveReport := OnSaveReport;
          frmReportDesigner.AfterPrintReport := AfterPrintReport;
          frmReportDesigner.CreateNewReport(NewReportDets);

          CentreOverCoords (frmReportDesigner, Left + (Width Div 2), Top + (Height Div 2));

          frmReportDesigner.ShowModal;
        Finally
          FreeAndNIL(frmReportDesigner);
        End; // Try..Finally
      End; // Else
    End; // If DoAdd
  Finally
    FreeAndNIL(NewReportDets);
  End; // Try..Finally
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actCancelDropExecute(Sender: TObject);
begin
  if (VRWReportTree.FocusedNode <> nil) and
     (NodeToMove <> nil) then
  begin
    btnMove.Action := actLift;
    actCancelDrop.Visible := False;
    miMove.Action  := actLift;
    NodeToMove := nil;
    UpdateDisplay;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actCancelPrintExecute(Sender: TObject);
begin
  if Confirm('Cancel this print?') then
    CancelPrint := True;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actCloseExecute(Sender: TObject);
begin
  Close;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actCollapseLevelExecute(Sender: TObject);
begin
  VRWReportTree.FullCollapse(VRWReportTree.FocusedNode);
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actCollapseTreeExecute(Sender: TObject);
var
  Node: PVirtualNode;
begin
  VRWReportTree.FullCollapse;
  { Move the focus to the root node }
  Node := VRWReportTree.GetFirst;
  VRWReportTree.FocusedNode := Node;
  VRWReportTree.Selected[Node] := True;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actConvertExecute(Sender: TObject);
{ Converts an old-style report to the new style, and adds it to the report
  tree. }
var
  frmConvertReport: TfrmConvertReport;
  Node: PVirtualNode;
  VRWRec: ^TVRWReportDataRec;
  ParentName: string;
  BaseFileName: string;
  ConvertedReport: IVRWReport;
  frmReportDesigner : TfrmReportDesigner;
begin
  Node := VRWReportTree.FocusedNode;
  if (Node = nil) then
  begin
    ShowMessage('There is no tree location selected for the report');
    Exit;
  end;
  if (Node.ChildCount = 0) then
    Node := Node.Parent;
  VRWRec := VRWReportTree.GetNodeData(Node);
  ParentName := Trim(VRWRec^.rtRepName);
  frmConvertReport := TfrmConvertReport.Create(Self);
  with frmConvertReport do
  begin
    try
      if (ShowModal = mrOK) then
        if assigned(Report) then
        begin
          ConvertedReport := ConvertOldReport(Report);
          if Assigned(ConvertedReport) then
          { Display report for editing }
          begin
            { Make sure the report has a unique name and filename. }
            ConvertedReport.vrName := VRWReportData.MakeUniqueReportName(ConvertedReport.vrName);
            BaseFileName := VRWReportData.MakeUniqueFileName(ExtractFileName(ConvertedReport.vrFilename + '.ERF'));
            ConvertedReport.vrFilename := GReportPath + 'REPORTS\' + BaseFileName;
            frmReportDesigner := TfrmReportDesigner.Create(self);
            try
              PrepareDesignWindow(frmReportDesigner);
              with frmReportDesigner do
              begin
                rdTreeParent := ParentName;
                OnSaveReport := self.OnSaveReport;
                AssignReport(ConvertedReport);
//                rdReportFileName := GReportPath + 'REPORTS\' + ConvertedReport.vrFilename;
//                TreeMode := TREE_IMPORT_REPORT;
//                sTreeChildID := trim(ConvertedReport.vrName);
//                sTreeParentID := ParentName;
//                sReportPathFileName := Report.rdReportHeader.LastPath;
//                sReportFileName := trim(Report.rdReportHeader.RepName);
//                oImportedReport := Report;

                CentreOverCoords (frmReportDesigner, Self.Left + (Self.Width Div 2), Self.Top + (Self.Height Div 2));

                ShowModal;
              end;
            finally
              frmReportDesigner.Free;
            end;
          end;
        end; // if assigned(Report) then...
    finally
      Free;
    end; // try...finally
  end; // with frmConvertReport do...
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actCopyExecute(Sender: TObject);
var
  ParentNode, Node: PVirtualNode;
  VRWRec, NewVRWRec: ^TVRWReportDataRec;
  SuggestedName, NewFileName: ShortString;
  frmCopyReport: TfrmCopyReport;
  Res: LongInt;
  Done: Boolean;
begin
  Node := VRWReportTree.FocusedNode;
  if (Node = nil) then
    Exit;

  VRWRec := VRWReportTree.GetNodeData(Node);
  SyncData(Node);

  { Get a unique report name }
  SuggestedName := VRWReportData.MakeUniqueReportName(Trim(VRWRec^.rtRepName));

  // Popup dialog box to user with suggested name.
  frmCopyReport := TfrmCopyReport.Create(Self);
  try
    with frmCopyReport do
    begin
      lbledtReportName.Text := SuggestedName;
      lbledtReportDesc.Text := VRWRec^.rtRepDesc;
      Done := False;
      while not Done do
      begin
        if (ShowModal = mrOK) then
        begin
          if VRWReportData.ReportExists(lblEdtReportName.Text) then
            ShowMessage('A report already exists against this name')
          else
          begin
            { Copy the report, using the new filename }
            NewFileName := lblEdtReportName.Text + '.ERF';
            Res := VRWReportData.CopyReport(
                     NewFileName,
                     trim(lbledtReportName.Text),
                     trim(lbledtReportDesc.Text)
                   );
            if (Res = 0) then
            begin
              { Find the record which has just been added }
              VRWReportData.FindByName(lblEdtReportName.Text);
              { Locate the tree node matching the parent name... }
              ParentNode := FindNodeByName(VRWRec^.rtParentName);
              if (ParentNode <> nil) then
              begin
                { ...and add a new node under this parent }
                Node := VRWReportTree.AddChild(ParentNode);
                NewVRWRec := VRWReportTree.GetNodeData(Node);
                NewVRWRec^.rtNodeType       := 'R';
                NewVRWRec^.rtRepName        := Trim(VRWReportData.rtRepName);
                NewVRWRec^.rtRepDesc        := Trim(VRWReportData.rtRepDesc);
                NewVRWRec^.rtParentName     := Trim(VRWReportData.rtParentName);
                NewVRWRec^.rtFileName       := Trim(VRWReportData.rtFileName);
                NewVRWRec^.rtLastRun        := VRWReportData.rtLastRun;
                NewVRWRec^.rtLastRunUser    := Trim(VRWReportData.rtLastRunUser);
                NewVRWRec^.rtPositionNumber := VRWReportData.rtPositionNumber;
                NewVRWRec^.rtAllowEdit      := True;
                NewVRWRec^.rtFileExists     := True;
                { Tidy folder contents }
                CheckFolderContents(ParentNode);
                { Focus the new node }
                VRWReportTree.Selected[Node] := True;
                VRWReportTree.FocusedNode := Node;
              end
              else
                { Should never happen }
                ShowMessage('Failed to find node for ' + VRWReportData.rtParentName);
            end
            else
              ShowMessage('Could not copy report, error ' + IntToStr(Res));
            Done := True;
          end;
        end
        else
          Done := True;
      end;
    end;
  finally
    frmCopyReport.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actDefaultPositionExecute(Sender: TObject);
begin
  SetColoursUndPositions(2);
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actDeleteExecute(Sender: TObject);
var
  VRWRec: ^TVRWReportDataRec;
  Node, ParentNode: PVirtualNode;
  CanContinue: Boolean;
  ReportName: ShortString;
const
  MSG_DELETE_REPORT =
    'This will delete the entry in the report tree, and the report file ' +
    'itself. Once deleted, this report CANNOT be retrieved. Are you sure?';
  MSG_DELETE_EMPTY_FOLDER =
    'Are you sure that you wish to delete this empty folder?';
  MSG_DELETE_FOLDER =
    'This will delete this heading and all the reports within this ' +
    'heading. Once deleted, these reports CANNOT be retrieved. Are you sure?';
begin
  Node := VRWReportTree.FocusedNode;
  if (Node = nil) or (Node.Parent = nil) then
    Exit;

  VRWRec := VRWReportTree.GetNodeData(Node);

  if (VRWRec^.rtNodeType = 'R') then
  begin // REPORTS
    CanContinue := Confirm(MSG_DELETE_REPORT);
  end
  else
  begin // HEADINGS
    if IsEmptyFolder(Node) then
      CanContinue := Confirm(MSG_DELETE_EMPTY_FOLDER)
    else
      CanContinue := Confirm(MSG_DELETE_FOLDER);
  end;
  if CanContinue then
  begin
    ParentNode := Node.Parent;
    ReportName := Trim(VRWRec^.rtRepName);
    { Delete the data file record and the actual report file }
    VRWReportData.Delete(Trim(VRWRec^.rtRepName));
    { Delete the tree node }
    VRWReportTree.DeleteNode(Node);
    { Tidy up the folder which contained this report or subfolder }
    if (ParentNode <> nil) then
      CheckFolderContents(ParentNode);
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actDisplayPropertiesExecute(Sender: TObject);
begin
  with TfrmReportDispProps.Create(Self) do
  try
    ShowModal;
    if ModalResult = mrOk then
      SetColoursUndPositions(0);
    SetColoursUndPositions(3);
  finally
    Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actDropExecute(Sender: TObject);
{ Moves a previously 'lifted' report and inserts it at the currently selected
  position in the tree. }
begin
  if (VRWReportTree.FocusedNode <> nil) and
     (NodeToMove <> nil) then
  begin
    MoveNode(NodeToMove, VRWReportTree.FocusedNode);
    btnMove.Action := actLift;
    actCancelDrop.Visible := False;
    miMove.Action  := actLift;
    UpdateDisplay;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actEditExecute(Sender: TObject);
var
  frmReportDesigner : TfrmReportDesigner;
  frmHeaderEdit     : TfrmHeaderEdit;
  VRWRec            : ^TVRWReportDataRec;
begin
  if VRWReportTree.FocusedNode = nil then
    Exit;

  { Get the data from the node, and check that it is valid for editing }
  VRWRec := VRWReportTree.GetNodeData(VRWReportTree.FocusedNode);
  if (not VRWRec.rtFileExists) and (VRWRec.rtNodeType = 'R') then
  begin
    ShowMessage('File ' + VRWReportData.Datapath + 'REPORTS\' +
                          VRWRec.rtFileName + ' not found');
    Exit;
  end;

  { Make sure we are on the right record in the data file }
  SyncData(VRWReportTree.FocusedNode);
  if (Assigned(VRWRec)) then
  begin
    if (VRWRec^.rtAllowEdit) then
    begin
      { Edit Report }
      If (VRWRec^.rtNodeType = 'R') Then
      begin
        // Report
        frmReportDesigner := TfrmReportDesigner.Create(Self);
        Try
          frmReportDesigner.rdTreeParent := VRWRec^.rtParentName;
          frmReportDesigner.OnSaveReport := OnSaveReport;
          frmReportDesigner.AfterPrintReport := AfterPrintReport;
          frmReportDesigner.rdReportFileName := GReportPath + 'REPORTS\' + VRWRec^.rtFileName;
          frmReportDesigner.UserID := GReportUser;

          CentreOverCoords (frmReportDesigner, Left + (Width Div 2), Top + (Height Div 2));

          frmReportDesigner.ShowModal;
        Finally
          FreeAndNIL(frmReportDesigner);
        End; // Try..Finally
      End // If (VRWRec^.rtNodeType = 'R')
      Else
      Begin
        // Group
        frmHeaderEdit := TfrmHeaderEdit.Create(Self);
        With frmHeaderEdit Do
        Begin
          Try
            { Copy the details from the node to the editor dialog. }
            lbledtHeading.Text := Trim(VRWRec^.rtRepName);
            memNodeDescription.Text := Trim(VRWRec^.rtRepDesc);
            { Display the dialog, and read the results }
            if (ShowModal = mrOK) then
            begin
              VRWRec^.rtRepName := Trim(lblEdtHeading.Text);
              VRWRec^.rtRepDesc := memNodeDescription.Text;
              { Write the details to the data file. }
              UpdateData(VRWRec^);
              { Force a redisplay, to show the changed text }
              VRWReportTree.RepaintNode(VRWReportTree.FocusedNode);
            end;
          Finally
            Free;
          End; // Try..Finally
        End; // with frmHeaderEdit
      End; // Else
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actExpandAllExecute(Sender: TObject);
begin
  VRWReportTree.FullExpand(VRWReportTree.FocusedNode);
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actExpandLevelExecute(Sender: TObject);
begin
  if not VRWReportTree.Expanded[VRWReportTree.FocusedNode] then
    VRWReportTree.ToggleNode(VRWReportTree.FocusedNode);
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actExpandTreeExecute(Sender: TObject);
begin
  VRWReportTree.FullExpand;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actFindExecute(Sender: TObject);
begin
  FindReport(self, VRWReportTree);
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actImportExecute(Sender: TObject);
{ Imports an existing report file into the tree, copying the file into the
  main Reports folder at the same time. }
var
  ssReportName,
  ssReportDesc,
  ssFileName,
  ssFilePath,
  ssFullFilePathName : ShortString;
  Params: TReportWizardParams;
  Res: LongInt;
  ParentNode: PVirtualNode;
  ParentName: string;
  VRWRec: ^TVRWReportDataRec;
  Report: IVRWReport;
  Done, CanContinue: Boolean;
  frmCopyReport: TfrmCopyReport;
begin
  if dlgImportReport.Execute then
  begin
    CanContinue := True;

    ssFullFilePathName := dlgImportReport.FileName;

    ssFileName := ExtractFileName(ssFullFilePathName);
    ssFilePath := ExtractFilePath(ssFullFilePathName);

    { Open the file, and read the report name and description }
    ssReportName := ssFileName;
    while (Length(ssReportName) > 0) and (ssReportName[Length(ssReportName)] <> '.') do
      Delete(ssReportName, Length(ssReportName), 1);
    if (Length(ssReportName) > 0) then
      Delete(ssReportName, Length(ssReportName), 1);

    { Open the file, update the report name, and save it to the new
      location }
    Report := GetVRWReport as IVRWReport;
    try
      Report.Read(ssFullFilePathName);
      Report.vrName := ssReportName;
      ssReportDesc := Report.vrDescription;

      { Make sure we have a unique report name }
      ssReportName := VRWReportData.MakeUniqueReportName(Trim(ssReportName));

      { Display the Copy dialog to allow the user to change the report name
        and description }
      frmCopyReport := TfrmCopyReport.Create(nil);
      try
        frmCopyReport.Mode := crmImport;
        Done := False;
        frmCopyReport.lbledtReportName.Text := ssReportName;
        frmCopyReport.lbledtReportDesc.Text := Report.vrDescription;
        while not Done do
        begin
          frmCopyReport.ShowModal;
          if frmCopyReport.ModalResult = mrOk then
          begin
            if VRWReportData.ReportExists(frmCopyReport.lblEdtReportName.Text) then
              ShowMessage('A report already exists against this name')
            else
            begin
              Report.vrName     := frmCopyReport.lblEdtReportName.Text;
              Report.vrDescription := frmCopyReport.lbledtReportDesc.Text;
              Report.vrFileName := GReportPath + 'REPORTS\' + Report.vrName + '.ERF';
              ssReportName      := Report.vrName;
              ssReportDesc      := Report.vrDescription;
              ssFileName        := Report.vrName + '.ERF';
              Report.Write;
              Done := True;
            end;
          end
          else
          begin
            Done := True;
            CanContinue := False;
          end;
        end;
      finally
        frmCopyReport.Free;
      end;

    finally
      Report := nil;
    end;

    if CanContinue then
    begin
      { Get the details of the folder that this file will be imported to }
      ParentNode := VRWReportTree.FocusedNode;
      if (ParentNode = nil) then
        ParentNode := VRWReportTree.GetFirst;
      { If the current node is a report, use its parent }
      if (ParentNode.ChildCount = 0) then
        ParentNode := ParentNode.Parent;
      VRWRec := VRWReportTree.GetNodeData(ParentNode);
      ParentName := Trim(VRWRec^.rtRepName);

      Params := TReportWizardParams.Create;

      Params.wrReportName := ssReportName;
      Params.wrReportDesc := ssReportDesc;

      OnSaveReport(Params, ParentName, ssFileName, Res);
    end;

  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actLiftExecute(Sender: TObject);
{ 'Lifts' a report, ready for it to be moved to another location in the
  tree. }
begin
  if (VRWReportTree.FocusedNode <> nil) then
  begin
    NodeToMove := VRWReportTree.FocusedNode;
    btnMove.Action := actDrop;
    actCancelDrop.Visible := True;
    miMove.Action  := actDrop;
    UpdateDisplay;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actMoveDownExecute(Sender: TObject);
{ Moves the currently selected node down within the group/folder }
var
  Res: LongInt;
  SourceNode, TargetNode: PVirtualNode;
  VRWRec: ^TVRWReportDataRec;
begin
  if (VRWReportTree.FocusedNode = nil) then
    Exit;
  SourceNode := VRWReportTree.FocusedNode;
  { The root cannot be moved }
  if (SourceNode.Parent = nil) then
    Exit
  else
    SourceNode := VRWReportTree.FocusedNode;
  { Make sure the ReportTree object is on the correct record for the current
    node. }
  if SyncData(SourceNode) then
  begin
    { Move the report record. }
    Res := VRWReportData.MoveDown;
    if (Res = 0) then
    begin
      TargetNode := VRWReportTree.GetNextSibling(SourceNode);
      { Move the tree nodes }
      VRWReportTree.MoveTo(SourceNode, TargetNode, amInsertAfter, False);
      { Re-read the details from the data file -- moving the record will have
        changed the Order Number in the data file, but the node data will still
        have the original value. }
      SyncData(SourceNode);
      VRWRec := VRWReportTree.GetNodeData(SourceNode);
      PopulateVRWRec(VRWRec^);

      SyncData(TargetNode);
      VRWRec := VRWReportTree.GetNodeData(TargetNode);
      PopulateVRWRec(VRWRec^);

      VRWReportTree.ScrollIntoView(SourceNode, False);
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actMoveUpExecute(Sender: TObject);
{ Moves the currently selected node up within the group }
var
  Res: LongInt;
  SourceNode, TargetNode: PVirtualNode;
  VRWRec: ^TVRWReportDataRec;
begin
  if (VRWReportTree.FocusedNode = nil) then
    Exit;
  SourceNode := VRWReportTree.FocusedNode;
  { The root cannot be moved }
  if (SourceNode.Parent = nil) then
    Exit
  else
    SourceNode := VRWReportTree.FocusedNode;
  { Make sure the ReportTree object is on the correct record for the current
    node. }
  if SyncData(SourceNode) then
  begin
    { Move the report record. }
    Res := VRWReportData.MoveUp;
    if (Res = 0) then
    begin
      TargetNode := VRWReportTree.GetPreviousSibling(SourceNode);
      { Move the tree nodes }
      VRWReportTree.MoveTo(SourceNode, TargetNode, amInsertBefore, False);
      { Re-read the details from the data file -- moving the record will have
        changed the Position Number in the data file, but the node data will
        still have the original value. }
      SyncData(SourceNode);
      VRWRec := VRWReportTree.GetNodeData(SourceNode);
      PopulateVRWRec(VRWRec^);

      SyncData(TargetNode);
      VRWRec := VRWReportTree.GetNodeData(TargetNode);
      PopulateVRWRec(VRWRec^);

      VRWReportTree.ScrollIntoView(SourceNode, False);
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actPrintReportExecute(Sender: TObject);
var
  Report: IVRWReport2;
  Node: PVirtualNode;
  VRWRec: ^TVRWReportDataRec;
  ReportDesc, ReportFile: ShortString;
  FuncRes: Integer;
begin
  Node := VRWReportTree.FocusedNode;
  if (Node = nil) then
    Exit;
  VRWRec := VRWReportTree.GetNodeData(Node);
  if VRWReportData.CanPrint(Trim(VRWRec^.rtRepName), ReportDesc, ReportFile) then
  begin
    Report := GetVRWReport as IVRWReport2;
    try
      Printing := True;
      UpdateDisplay;
      actCancelPrint.Enabled := True;
      Report.vrOnPrintRecord := OnPrintRecord;
      Report.vrOnFirstPass   := OnFirstPass;
      Report.vrOnSecondPass  := OnSecondPass;
      Report.vrUserID        := GReportUser;
      if Report.Print(GReportPath + 'REPORTS\' + VRWRec^.rtFileName) then
        AfterPrintReport(GReportUser, FuncRes);
    finally
      Report := nil;
      pbLabel.Caption := '';
      actCancelPrint.Enabled := False;
      CancelPrint := False;
      Printing := False;
      UpdateDisplay;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actReportPropertiesExecute(Sender: TObject);
var
  VRWRec: ^TVRWReportDataRec;
  PropertyDlg: TfrmRptTreeProperties;
begin
  if (VRWReportTree.FocusedNode <> nil) then
  begin
    VRWRec := VRWReportTree.GetNodeData(VRWReportTree.FocusedNode);
    PropertyDlg := TfrmRptTreeProperties.Create(nil);
    try
      // ABSEXCH-17754: Changed colour scheme from pick/purple to light grey/dark grey
	  PropertyDlg.Init(VRWRec^, pnlHeading.Font.Color, pnlHeading.Color);
      PropertyDlg.ShowModal;
    finally
      PropertyDlg.Free;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.actSecurityExecute(Sender: TObject);
var
  VRWRec: ^TVRWReportDataRec;
  ParentNode: PVirtualNode;
begin
  if (VRWReportTree.FocusedNode <> nil) and
     (VRWReportTree.FocusedNode.Parent <> nil) then
  begin
    ParentNode := VRWReportTree.FocusedNode.Parent;
    VRWRec := VRWReportTree.GetNodeData(VRWReportTree.FocusedNode);
    SyncData(VRWReportTree.FocusedNode);
    if DisplayUserSecurity (VRWReportData.GetSecurity(Trim(VRWRec^.rtRepName))) then
    begin
      { If we now can't find the current report in the data, it must mean that
        the user has (rather foolishly!) just denied themselves all access to
        this report, so remove the report from the tree. }
      if not SyncData(VRWReportTree.FocusedNode) then
        VRWReportTree.DeleteNode(VRWReportTree.FocusedNode)
      else
        { Otherwise, make sure that the Allow Edit flag reflects any changes
          to the user's access rights }
        VRWRec^.rtAllowEdit := VRWReportData.CanEdit;
      UpdateDisplay;
      CheckFolderContents(ParentNode);
    end;
  end;
end;
// === End of ActionList event handlers ========================================

procedure TfrmReportTree.FormCreate(Sender: TObject);
var
  ///frmDemoWarn: TfrmDemoWarn;
  siCmdParamIdx, siCmdParamCount : SmallInt;
//  miDebugMenuItem : TMenuItem;
  FileSearchRec : TSearchRec;
  ToolkitRes : Integer;
  oToolkit : IToolkit2;
begin
  Caption := Application.Title;
  Populating := False;
  Printing := False;
  CancelPrint := False;
  actCancelPrint.Enabled := False;

  Init_AllSys;      // Sets up the SyssCurr structure with the currency symbols for each currency code.
  Init_STDCurrList; // in BTSupU2.Pas, called to setup the currency list, built using the content of SyssCurr.
  InitPreview(Application, Screen);

  Application.ShowHint := TRUE;

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := (Width - ClientWidth) + 500;        // take border sizing &
  MinSizeY := (Height - ClientHeight) + 237;      // captions into account

  MinSizeX := Width;
  MinSizeY := Height;

  HighlightedItem := 0;

  btnMove.Width := btnClose.Width;

  pbReportProgress.Top := 4;

//  pnlProgressBar.Width := VRWReportTree.Width;

  VRWReportData := GetVRWReportData as IVRWReportData;
  VRWReportData.ShowHiddenRecords := False;

  siCmdParamCount := ParamCount;
  siCmdParamIdx := 1;
  while (siCmdParamIdx <= siCmdParamCount) do
  begin
    if (UpperCase(ParamStr(siCmdParamIdx)) = '/DIR:') then
    begin
      GReportPath := ParamStr(siCmdParamIdx + 1);
      if (GReportPath[Length(GReportPath)] <> '\') then
        GReportPath := GReportPath + '\';
      VRWReportData.Datapath := GReportPath;
      // MH 27/04/05: Fixed as didn't work under Local Program Files
      uSettings.sMiscDirLocation := GReportPath;
    end;

    if (UpperCase(ParamStr(siCmdParamIdx)) = '/USER:') then
    begin
      GReportUser := UpperCase(ParamStr(siCmdParamIdx + 1));
      VRWReportData.UserID := GReportUser;
      EntryRec^.Login := GReportUser; // Populates SYSLUSER field
    end;

    if (UpperCase(ParamStr(siCmdParamIdx)) = '/DEBUG') then
      GRWDebug := TRUE;

    if (UpperCase(ParamStr(siCmdParamIdx)) = '/' + SECURITY_PARAMETER) then
      GRWSecurityOK := TRUE;

    inc(siCmdParamIdx);
  end;

  if GRWDebug then
  begin
    N2.Visible := True;
    actReportProperties.Visible := True;
  end;
  //TW 09/08/2011: Added connection initialiser for entwindowsetting compatability.
  //PR: 23/08/2011: Add check that we're using MS-SQL version - if not, call gives an access violation.
  if SQLUtils.UsingSQL then
    InitialiseGlobalADOConnection(GReportPath);

  // HM 01/03/05: Modified to use COMTK backdoor to avoid requirement for runtime licence
  oToolkit := OpenToolkit(GReportPath, True) as IToolkit2;
  Try
    // Check the COMTK has created and opened OK
    If Assigned(oToolkit) Then
    begin
      EnterpriseDPs.siCostDecimals := oToolkit.SystemSetup.ssCostDecimals;
      EnterpriseDPs.siQtyDecimals := oToolkit.SystemSetup.ssQtyDecimals;
      EnterpriseDPs.siSalesDecimals := oToolkit.SystemSetup.ssSalesDecimals;

      // HM 01/03/05: Added check on Visual Report Writer module release code - requires
      // the updated v5.61 COMTK
      If Supports(oToolkit.SystemSetup.ssReleaseCodes, ISystemSetupReleaseCodes2) Then
      Begin
        With (oToolkit.SystemSetup.ssReleaseCodes As ISystemSetupReleaseCodes2) Do
        Begin
          If (rcVisualReportWriter = rcDisabled) Then
          Begin
            MessageDlg('This Company Dataset does not have a licence to run the Visual Report Writer', mtError, [mbOK], 0);
            GRWSecurityOK := False;
          End; // If (rcVisualReportWriter = rcDisabled)
        End; // With (oToolkit.SystemSetup.ssReleaseCodes As ISystemSetupReleaseCodes2)
      End // If Supports(oToolkit.SystemSetup.ssReleaseCodes, ISystemSetupReleaseCodes2)
      Else
      Begin
        MessageDlg('The Visual Report Writer requires a later version of the COM Toolkit, please contact your Technical Support', mtError, [mbOK], 0);
        GRWSecurityOK := False;
      End; // Else

      If GRWSecurityOK Then
      Begin
        // Check the users permissions to run the Report Writer
        If (UpperCase(Trim(GReportUser)) <> 'SYSTEM') Then
        Begin
          With oToolkit.UserProfile Do
          Begin
            // HM 01/03/05: Rewrote this section as Andy was just doing GetFirst/GetNext until
            // he found the correct user - he really should be shot for some of this code!
            Index := usIdxLogin;
            ToolkitRes := GetEqual(BuildUserIDIndex(GReportUser));
            If (ToolkitRes = 0) Then
            Begin
              // Got User
              If (upSecurityFlags[193] = srNoAccess) Then
              Begin
                // User does not have permission to run the Report Writers
                MessageDlg('The current user is not allowed to run the Visual Report Writer', mtError, [mbOK], 0);
                GRWSecurityOK := False;
              End; // If (upSecurityFlags[193] = srNoAccess)

              miFileSecurity.Visible := (upSecurityFlags[520] = srAccess);
            End // If (ToolkitRes = 0)
            Else
            Begin
              MessageDlg('The current user is not allowed to run the Visual Report Writer', mtError, [mbOK], 0);
              GRWSecurityOK := False;
            End; // Else
          End; // With oToolkit.UserProfile
        End // If (UpperCase(Trim(GReportUser)) <> 'SYSTEM')
        Else
        Begin
          // SYSTEM
          miFileSecurity.Visible := True;
        End; // Else
      End; // If GRWSecurityOK

      oToolkit.CloseToolkit;
    End; // If Assigned(oToolkit)
  Finally
    oToolkit := nil;
  End; // Try..Finally

  If GRWSecurityOK Then
  Begin
    // HM 01/03/05: Auto-create the SWAP directory if missing as otherwise you
    // get exceptions editing or printing reports.
    If (Trim(GReportPath) <> '') And (Not DirectoryExists(GReportPath + 'SWAP\')) Then
    Begin
      If (Not ForceDirectories (GReportPath + 'SWAP\')) Then
      Begin
        // display an error message if the user cannot auto-create the directory
        MessageDlg('The SWAP directory is missing on this Company Dataset and is required for the Visual ' +
                   'Report Writer to function correctly, please notify your Technical Support',
                   mtError, [mbOK], 0);
        GRWSecurityOK := False;
      End; // If (Not ForceDirectories (GReportPath + 'SWAP\'))
    End; // If (Trim(GReportPath) <> '') And (Not DirectoryExists(GReportPath))

    // clean up any TMP files left over.
{
    if (FindFirst(GReportPath + 'SWAP\' + '*.TMP', faAnyFile, FileSearchRec) = 0) then
    try
      repeat
        if (UpperCase(ExtractFileExt(ExtractFileName(FileSearchRec.Name))) = '.TMP') then
          DeleteFile(GReportPath + 'SWAP\' + FileSearchRec.Name);
      until (FindNext(FileSearchRec) <> 0);
    finally
      FindClose(FileSearchRec);
    end;
}
    FRegionFontList := TStringList.Create;
    ReadRptDisplayProps(FRegionFontList);

    if (GRWDebug) then
    begin
      self.Caption := self.Caption + ' (' + GReportUser + ')';
    end;

    // Menu shortcuts - can't set ALT shortcuts at design-time
    actAdd.ShortCut := TextToShortCut('Alt+A');
    actEdit.ShortCut := TextToShortCut('Alt+E');
    actPrintReport.ShortCut := TextToShortCut('Alt+P');
    actFind.ShortCut := TextToShortCut('Alt+N');
    actCopy.ShortCut := TextToShortCut('Alt+C');
    actClose.ShortCut := TextToShortCut('Alt+F4');

    if (GReportUser = 'SYSTEM') then
    begin
      actAdd.Enabled := False;
      actConvert.Enabled := False;
      actImport.Enabled := False;
      actReportProperties.Enabled := False;
      actDisplayProperties.Enabled := False;
    end;

    // Load colours/positions/sizes/etc...
    DoneRestore := False;
    SetColoursUndPositions (0);
    SetColoursUndPositions (3);

  End; // If GRWSecurityOK

  { Hide 'Convert report' menu from IAO and SQL version}
  if (EnterpriseLicence.elProductType in [ptLITECust, ptLITEAcct])
     {$IFDEF EXSQL} or SQLUtils.UsingSQL {$ENDIF} then
  begin
    miConvertReport.Visible := False;
  end;

  { Set Tag to 1010, so window can be ID'd uniquely }
// MH 10/08/07: Added SetWindowLong to allow Enter1 to identify the VRW, the call does appear
//              to work although it generates error 1447.
//              NOTE: Doesn't work if at top of FormCreate
//SetLastError(0);
//ShowMessage(IntToStr(GetLastError));
  SetWindowLong (Self.Handle, GWL_USERDATA, 1010);
//ShowMessage(IntToStr(GetLastError));
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClosePreviewWindows;
  // Save colours/positions/sizes/etc...
  SetColoursUndPositions (1);
  
  //TW 09/08/2011: Added for entwindowsettings compatibility.
  TerminateGlobalADOConnection;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.FormResize(Sender: TObject);
begin
  pnlProgressBar.Top := ClientHeight - pnlProgressBar.Height - 4;

  VRWReportTree.Width := ClientWidth - pnlButtons.Width - 12;

  pnlButtons.Left := ClientWidth - pnlButtons.Width - 4;
  pnlButtons.Height := ClientHeight - pnlProgressBar.Height -
                       (7 + pnlButtons.Top);

  pnlProgressBar.Width := VRWReportTree.Width + pnlButtons.Width + 4;

  VRWReportTree.Height := ClientHeight - pnlProgressBar.Height -
                          (7 + VRWReportTree.Top);

  pnlLastRun.Width := pnlButtons.Left - pnlLastRun.Left - 4;

  VRWReportTree.Header.Columns[0].Width := VRWReportTree.Width - 170;
  VRWReportTree.Header.Columns[0].Width :=
    VRWReportTree.Width -
      (VRWReportTree.Header.Columns[1].Width + GetSystemMetrics(SM_CYHSCROLL) + 3);


end;

// -----------------------------------------------------------------------------

// Control the minimum size that the form can resize to - works better than constraints
procedure TfrmReportTree.WMGetMinMaxInfo(var message : TWMGetMinMaxInfo);
begin // WMGetMinMaxInfo
  with message.MinMaxInfo^ do
  begin
    ptMinTrackSize.X:=MinSizeX;
    ptMinTrackSize.Y:=MinSizeY;
  end; // with message.MinMaxInfo^

  message.Result:=0;

  Inherited;
end; // WMGetMinMaxInfo

// -----------------------------------------------------------------------------

procedure TfrmReportTree.ReadRptDisplayProps(var FontList : TStringList);
var
  fDisplayProps : file;
  BannerColour : TColor;
  RegionFont : TFont;
  pFontParams : PFontRec;
  pFontName : PChar;
  Idx : SmallInt;
begin
  if FileExists(GReportPath + 'REPORTS\' + 'ERWDISP.DAT') then
  begin
    AssignFile(fDisplayProps, GReportPath + 'REPORTS\' + 'ERWDISP.DAT');
    Reset(fDisplayProps, 1);

    BlockRead(fDisplayProps, BannerColour, SizeOf(TColor));

    BlockRead(fDisplayProps, BannerColour, SizeOf(TColor));

    GetMem(pFontParams, SizeOf(TFontRec));
    pFontName := StrAlloc(FONT_NAME_SIZE + 1);
    FillChar(pFontName^, FONT_NAME_SIZE, chr(0));

    for Idx := 1 to 7 do
    begin
      RegionFont := TFont.Create;
      BlockRead(fDisplayProps, pFontParams^, SizeOf(TFontRec));
      BlockRead(fDisplayProps, pFontName^, FONT_NAME_SIZE);

      with pFontParams^ do
      begin
        RegionFont.Color := Colour;
        RegionFont.Height := Height;
        RegionFont.Pitch := Pitch;
        RegionFont.Size := Size;
        RegionFont.Style := Style;
      end;
      RegionFont.Name := StrPas(pFontName);

      if (Idx <= 5) then
        FontList.AddObject(aRegionNames[Idx], RegionFont)
      else
      begin
        case Idx of
          6 : FontList.AddObject('SECTION_HEADER', RegionFont);
          7 : FontList.AddObject('SECTION_FOOTER', RegionFont);
        end; // case RegionIdx of...
      end;
    end; // for Idx := 1 to 7 do...

    FreeMem(pFontParams);
    StrDispose(pFontName);

    CloseFile(fDisplayProps);
  end // if FileExists(...) then...
  else
  begin
    for Idx := 1 to 7 do
    begin
      RegionFont := TFont.Create;
      if (Idx <= 5) then
        FontList.AddObject(aRegionNames[Idx], RegionFont)
      else
      begin
        case Idx of
          6 : FontList.AddObject('SECTION_HEADER', RegionFont);
          7 : FontList.AddObject('SECTION_FOOTER', RegionFont);
        end; // case RegionIdx of...
      end;
    end; // for Idx := 1 to 7 do...
  end; // if FileExists(...) then...else...
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.RefreshVRWReportData;
var
  VRWRec: ^TVRWReportDataRec;

  procedure LoadVirtualChildNodes(Parent: PVirtualNode; ParentName: ShortString);
  var
    VRWRec: ^TVRWReportDataRec;
    RecordPosition: LongInt;
    Res: LongInt;
    GrandChildNode, ChildNode: PVirtualNode;
  begin
    with VRWReportData do
    begin
      { Step through all the child records against the specified parent }
      Res := GetFirstChild(ParentName);
      while (Res = 0) do
      begin
        { Add a child node, and store the data against it }
        ChildNode := VRWReportTree.AddChild(Parent);
        VRWRec := VRWReportTree.GetNodeData(ChildNode);
        PopulateVRWRec(VRWRec^);
        { If this record also has children, recursively process them }
        if (VRWReportData.rtNodeType = 'H') Then
        begin
          { Heading - load sub-items }
          SavePosition(RecordPosition);
          try
            LoadVirtualChildNodes(ChildNode, Trim(VRWReportData.rtRepName));
            RestorePosition(RecordPosition);
            Read;
            { Add an 'Empty Folder' item if no sub-items were loaded }
            if ChildNode.ChildCount = 0 then
            begin
              GrandChildNode := VRWReportTree.AddChild(ChildNode);
              VRWRec := VRWReportTree.GetNodeData(GrandChildNode);
              FillChar(VRWRec^, Sizeof(VRWRec^), 0);
              with VRWRec^ do
              begin
                rtNodeType := 'R';
                rtParentName := trim(VRWReportData.rtRepName);
                rtRepName := 'Empty Folder';
                rtFileExists := True; // To suppress 'file not found' message
              end;
            end;
          finally
//            RestorePosition(RecordPosition);
//            Read;
          end;
        end;
        Res := GetNextChild;
      end;
    end;
  end;

begin
  Populating := True;

  try
    VRWReportTree.Clear;

    { Add top level item to tree, as a root for all the other items }
    VRWReportTree.NodeDataSize := SizeOf(VRWRec^);
    RootNode := VRWReportTree.AddChild(nil);
    VRWRec := VRWReportTree.GetNodeData(RootNode);
    VRWRec.rtNodeType := 'H';
    VRWRec.rtRepName := 'REPORTS';
    VRWRec.rtFileExists := True; // To suppress 'file not found' message

    { Load the tree from the reports data file }
    VRWReportData.Index := 1;
    LoadVirtualChildNodes(RootNode, '');

    { Expand and select the root node ('REPORTS') }
    VRWReportTree.Expanded[RootNode] := True;
    VRWReportTree.FocusedNode := RootNode;
    VRWReportTree.Selected[RootNode] := True;
    CheckFolderContents(RootNode);
  finally
    Populating := False;
    UpdateDisplay;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.FormDestroy(Sender: TObject);
//var
//  FileSearchRec : TSearchRec;
begin
  // MH 13/03/2012 v6.10 ABSEXCH-11937: As reports are now stashed locally in Windows\Temp folder
  // rather than uploading them to the network Exchequer\Swap folder and because my code isn't rubbish
  // the deletion of rogue temporary files is no longer required
  (****
  // clean up any TMP and EDF files left over. Bit of a sleigh hammer method but it works.
  if (FindFirst(GReportPath + 'SWAP\' + 'ERW*.TMP', faAnyFile, FileSearchRec) = 0) then
  begin
    repeat
      if (UpperCase(ExtractFileExt(ExtractFileName(FileSearchRec.Name))) = '.TMP') then
        DeleteFile(GReportPath + 'SWAP\' + FileSearchRec.Name);
    until (FindNext(FileSearchRec) <> 0);

    FindClose(FileSearchRec);
  end;
  ****)

{
  if (FindFirst(GReportPath + 'SWAP\' + '*.EDF', faAnyFile, FileSearchRec) = 0) then
  begin
    repeat
      if (UpperCase(ExtractFileExt(ExtractFileName(FileSearchRec.Name))) = '.EDF') then
        DeleteFile(GReportPath + 'SWAP\' + FileSearchRec.Name);
    until (FindNext(FileSearchRec) <> 0);

    FindClose(FileSearchRec);
  end;
}
  if Assigned(FRegionFontList) then
  begin
    while (FRegionFontList.Count > 0) do
    begin
      TFont(FRegionFontList.Objects[0]).Free;
      FRegionFontList.Delete(0);
    end;
    FRegionFontList.Free;
    FRegionFontList := nil;
  end;

  VRWReportData := nil;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.FormShow(Sender: TObject);
begin
  { Populate the tree view }
  RefreshVRWReportData;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.FormActivate(Sender: TObject);
begin
  if (not GRWSecurityOK) then
    Close;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.ShowProgressMonitor(siPercentComplete : SmallInt; var AAbort : Boolean);
begin
  pbReportProgress.Position := siPercentComplete;
  if CancelPrint then
    AAbort := True;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.HelpAboutClick(Sender: TObject);
begin
  TAboutFrm.Create(Application.MainForm).ShowModal;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.PrintProgress(var Msg: TMessage);
begin
  with Msg do
  begin
    { Mode passes in WParam }
    case WParam of
      { Clear Progress }
      0 : { N/A };

      { Set Progress percentage }
      1 : { N/A };

      { Set HWnd }
      2 : { N/A };

      { Set InPrint Flag }
      3 : { N/A };

      { Check InPrint Flag }
      4 : SendMessage(LParam, WM_InPrint, Ord(False), 0);
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.HelpContents1Click(Sender: TObject);
begin
  Application.HelpCommand(15, 0);
//  WinHelp(self.Handle, PChar(self.HelpFile), HELP_COMMAND, 'Contents()')
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.SearchforHelpOn1Click(Sender: TObject);
const
  EmptyString: PChar = '';
begin
  Application.HelpCommand(HELP_PARTIALKEY, Longint(EmptyString));
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.HowtoUseHelp1Click(Sender: TObject);
begin
//  Application.HelpCommand(HELP_HELPONHELP, 0);
  Application.HelpCommand(3, 0);
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.miReportDumpClick(Sender: TObject);
begin
  VRWReportData.DumpReportTree;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.DumpVRWSECDATtoFile1Click(Sender: TObject);
begin
  VRWReportData.DumpReportSecurity;
end;

// -----------------------------------------------------------------------------

// Controls the loading/saving of the colours and positions
//
// Mode   0=Load Details, 1=Save Details, 2=Delete Details
procedure TfrmReportTree.SetColoursUndPositions (Const Mode : Byte);
Var
  WantAutoSave : Boolean;
  FBannerColor, FBannerFontColor: TColor;
Begin // SetColoursUndPositions
  Case Mode Of
    0 : Begin
          oSettings.LoadForm (Self, WantAutoSave);
          miSaveCoordinates.Checked := WantAutoSave;
          //oSettings.LoadList (mulCompanyList, Self.Name);
        End;
    1 : If (Not DoneRestore) Then
        Begin
          // Only save the details if the user didn't select Restore Defaults
          oSettings.SaveForm (Self, miSaveCoordinates.Checked);
          //oSettings.SaveList (mulCompanyList, Self.Name);
        End; // If (Not DoneRestore)
    2 : Begin
          DoneRestore := True;
          oSettings.RestoreFormDefaults (Self.Name);
//          oSettings.RestoreListDefaults (mulCompanyList, Self.Name);
          miSaveCoordinates.Checked := False;
        End;
    3:
      begin
        With TIniFile.Create(GReportPath + 'REPORTS\' + ChangeFileExt(ExtractFileName(Application.ExeName), '.DAT')) Do
        Begin
          Try
            // Colours
            // MH 17/10/2016 2017-R1 ABSEXCH-17754: New colour scheme for VRW
            FBannerColor := ReadInteger(EntryRec^.Login, 'BannerColour', DefaultBackgroundColour);
            FBannerFontColor := ReadInteger(EntryRec^.Login, 'BannerFontColour', DefaultFontColour);
            pnlHeading.Color := FBannerColor;
            pnlHeading.Font.Color := FBannerFontColor;
            pnlLastRun.Color := FBannerColor;
            pnlLastRun.Font.Color := FBannerFontColor;
            pnlButtons.Color := FBannerColor;
            pnlProgressBar.Color := FBannerColor;
          finally
            Free;
          end;
        end; // with TIniFile.Create...
      end;
  Else
    Raise Exception.Create ('TfrmReportTree.SetColoursUndPositions - Unknown Mode (' + IntToStr(Ord(Mode)) + ')');
  End; // Case Mode
End; // SetColoursUndPositions

// -----------------------------------------------------------------------------

function TfrmReportTree.Confirm(Msg: string): Boolean;
begin
  Result := (MessageDlg(Msg, mtWarning, [mbYes, mbNo], 0) = mrYes);
end;

// -----------------------------------------------------------------------------

function TfrmReportTree.SyncData(Node: PVirtualNode): Boolean;
{ Ensures that the report tree data file is on the record that matches the
  specified node. }
var
  Res: LongInt;
  VRWRec: ^TVRWReportDataRec;
begin
  Result := False;
  if (Node <> nil) then
  begin
    { Read the details attached to the tree node... }
    VRWRec := VRWReportTree.GetNodeData(Node);
    { ...and search for the matching record in the data file }
    Res := VRWReportData.FindByName(Trim(VRWRec^.rtRepName));
    if (Res = 0) then
      Result := True
    else
      { Possibly the report has just been hidden as a result of security
        changes. Ignore the error (but return False) }
      ;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.MoveNode(SourceNode, TargetNode: PVirtualNode);
var
  SourceVRWRec, TargetVRWRec: ^TVRWReportDataRec;
  OriginalParentNode, NewParentNode: PVirtualNode;
  TargetIsRoot: Boolean;
  TargetName: string;
begin
  { Get the details of the node which will be moved }
  SourceVRWRec := VRWReportTree.GetNodeData(SourceNode);
  OriginalParentNode := SourceNode.Parent;
  { Get the details of the node at the position which it will be moved to }
  TargetVRWRec := VRWReportTree.GetNodeData(TargetNode);
  { Make sure the ReportTree object is on the correct record for the source
    node. }
  if SyncData(SourceNode) then
  begin
    TargetIsRoot := IsRootNode(TargetNode);
    { Only move the node if it is going to a different folder. }
    if (Trim(SourceVRWRec.rtParentName) <> Trim(TargetVRWRec.rtRepName)) then
    begin
      if (TargetVRWRec.rtNodeType = 'H') then
      begin
        NewParentNode := TargetNode;
        if TargetIsRoot then
          TargetName := ''
        else
          TargetName := Trim(TargetVRWRec.rtRepName);
        { Move the report record, making it the first child record against the
          target record. }
        VRWReportData.InsertAt(TargetName, 1);
        { Move the node, also making it the first child record. }
        VRWReportTree.MoveTo(SourceNode, TargetNode, amAddChildFirst, False)
      end
      else
      begin
        NewParentNode := TargetNode.Parent;
        { Move the report record, inserting it at the location currently occupied
          by the target (which will move down to make room). }
        VRWReportData.InsertAt(TargetVRWRec.rtParentName, TargetVRWRec.rtPositionNumber);
        { Move the node to the matching location in the tree. }
        VRWReportTree.MoveTo(SourceNode, TargetNode, amInsertBefore, False);
      end;
      { Re-read the details from the data file -- moving the record will have
        changed the Position Number in the data file, but the node data will
        still have the original Position Number. }
      SyncData(SourceNode);
      SourceVRWRec := VRWReportTree.GetNodeData(SourceNode);
      PopulateVRWRec(SourceVRWRec^);
      { Tidy up the folders }
      if (OriginalParentNode <> nil) then
        CheckFolderContents(OriginalParentNode);
      if (NewParentNode <> nil) then
        CheckFolderContents(NewParentNode);
      { Make sure the moved node is visible and selected at its new location. }
      VRWReportTree.FocusedNode := SourceNode;
      VRWReportTree.Selected[SourceNode] := True;
    end;
  end { if SyncData... }
  else
    ShowMessage('Could not locate correct record for "' +
                SourceVRWRec.rtRepName + '". Abandoning move.');
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.VRWReportTreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);

  function GetReportCaption(VRWRec: TVRWReportDataRec): ShortString;
  { Returns the report name and report description in one string,
    unless they are the same or the description is empty, in which
    case only the report name is returned.

    Also attaches the 'file not found' message if the report file
    cannot be found in the Reports directory. }
  begin
    Result := Trim(VRWRec.rtRepName);
    if (Trim(VRWRec.rtRepDesc) <> '') and
       (Trim(VRWRec.rtRepDesc) <> Trim(VRWRec.rtRepName)) then
      Result := Result + ' - ' +
                Trim(VRWRec.rtRepDesc);
    if not VRWRec.rtFileExists then
      Result := Result + ' (* File not found *)';
  end;

{ Called whenever the tree needs to display the text for a node. }
var
  VRWRec: ^TVRWReportDataRec;
begin
  VRWRec := VRWReportTree.GetNodeData(Node);
  if Assigned(VRWRec) then
  begin
    { Column 0: Report Name }
    if Column = 0 then
    begin
      CellText := GetReportCaption(VRWRec^);
    end
    { Column 1: Last run date and user }
    else if (VRWRec^.rtLastRun <> 0) then
      CellText := DateToStr(VRWRec^.rtLastRun) + ' by ' +
                  VRWRec^.rtLastRunUser
    else
      CellText := '';
  end
  else
    CellText := 'not assigned';
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.VRWReportTreeGetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
{ Called whenever the tree needs to display the bitmap (folder or report) for
  a node. }
var
  VRWRec: ^TVRWReportDataRec;
begin
  if (Column = 0) then
  begin
    VRWRec := VRWReportTree.GetNodeData(Node);
    if Assigned(VRWRec) then
    begin
      if VRWRec^.rtNodeType = 'H' then
        ImageIndex := 0   // Folder
      else if Lowercase(Trim(VRWRec^.rtRepName)) = 'empty folder' then
      begin
        ImageIndex := 1;  // Empty folder
        Ghosted    := True;
      end
      else
        ImageIndex := 1;  // Report
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.VRWReportTreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  VRWRec: ^TVRWReportDataRec;
begin
  VRWRec := VRWReportTree.GetNodeData(Node);
  if Assigned(VRWRec) then
  begin
    { Column 0: Report Name }
    if Column = 0 then
    begin
      if (not VRWRec^.rtFileExists) then
        TargetCanvas.Font.Color := clRed;
    end
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.ClearVRWRec(var VRWRec: TVRWReportDataRec);
begin
  FillChar(VRWRec, Sizeof(VRWRec), 0);
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.PopulateVRWRec(var VRWRec: TVRWReportDataRec);
{ Fills the supplied report data record with details read from the current
  record in the data file. }
begin
  ClearVRWRec(VRWRec);

  // Code of Parent in Report Tree
  VRWRec.rtParentName := Trim(VRWReportData.rtParentName);

  // Item Type - 'H'=Group Heading (Folder), 'R'=Report
  VRWRec.rtNodeType := VRWReportData.rtNodeType;

  // Report Name/Code
  VRWRec.rtRepName := Trim(VRWReportData.rtRepName);

  // Report Description
  VRWRec.rtRepDesc := Trim(VRWReportData.rtRepDesc);

  // Last Run Date and User
  VRWRec.rtLastRun := VRWReportData.rtLastRun;
  VRWRec.rtLastRunUser := VRWReportData.rtLastRunUser;

  // Position number (position within group/folder)
  VRWRec.rtPositionNumber := VRWReportData.rtPositionNumber;

  // Filename
  VRWRec.rtFileName := Trim(VRWReportData.rtFileName);

  // Security
  VRWRec.rtAllowEdit := VRWReportData.CanEdit;

  // Report file exists
  if (VRWRec.rtNodeType = 'R') and
     (Lowercase(Trim(VRWRec.rtRepName)) <> 'empty folder') then
    VRWRec.rtFileExists :=
      FileExists(VRWReportData.Datapath + 'REPORTS\' + VRWRec.rtFileName)
  else
    VRWRec.rtFileExists := True; // To suppress 'file not found' message for
                                 // folders and 'empty folder' reports

end;

// -----------------------------------------------------------------------------

function TfrmReportTree.UpdateData(VRWRec: TVRWReportDataRec): LongInt;
{ Writes the supplied details into the record associated with the current node
  in the tree. }
var
  Node: PVirtualNode;
  Update: IVRWReportDataEditor;
begin
  Node := VRWReportTree.FocusedNode;
  if (Node <> nil) then
  begin
    { Make sure we are on the right record in the data file }
    SyncData(Node);
    Update := VRWReportData.Update;
    try
      Update.rtNodeType       := VRWRec.rtNodeType;
      Update.rtRepName        := Trim(VRWRec.rtRepName);
      Update.rtRepDesc        := VRWRec.rtRepDesc;
      Update.rtParentName     := VRWRec.rtParentName;
      Update.rtFileName       := VRWRec.rtFileName;
      Update.rtLastRun        := VRWRec.rtLastRun;
      Update.rtLastRunUser    := VRWRec.rtLastRunUser;
      Update.rtPositionNumber := VRWRec.rtPositionNumber;
      Result := Update.Save;
    finally
      Update := nil;
    end;
  end
  else
    Result := 4;  // Record not found
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.OnAddGroupHeading(Params: TReportWizardParams;
  ParentName, FileName: string; var FunctionResult: Integer);
{ Called by the report wizard when a new group heading (folder) is created }
var
  Add: IVRWReportDataEditor;
  VRWRec: ^TVRWReportDataRec;
  Node, ParentNode: PVirtualNode;
begin
  Add := VRWReportData.Add;
  Node := nil;
  try
    { Add a record to the data file }
    Add.rtNodeType   := 'H';
    Add.rtRepName    := Params.wrReportName;
    Add.rtRepDesc    := Params.wrReportDesc;
    if (ParentName = 'REPORTS') then
      Add.rtParentName := ''
    else
      Add.rtParentName := ParentName;
    Add.rtFileName   := Params.wrReportName;
    FunctionResult := Add.Save;
    if (FunctionResult = 0) then
    begin
      { Locate the tree node matching the parent name... }
      ParentNode := FindNodeByName(ParentName);
      if (ParentNode <> nil) then
      begin
        { ...and add a new node under this parent }
        Node := VRWReportTree.AddChild(ParentNode);
        VRWRec := VRWReportTree.GetNodeData(Node);
        VRWRec^.rtNodeType       := Add.rtNodeType;
        VRWRec^.rtRepName        := Add.rtRepName;
        VRWRec^.rtRepDesc        := Add.rtRepDesc;
        VRWRec^.rtParentName     := Add.rtParentName;
        VRWRec^.rtFileName       := Add.rtFileName;
        VRWRec^.rtLastRun        := Add.rtLastRun;
        VRWRec^.rtLastRunUser    := Add.rtLastRunUser;
        VRWRec^.rtPositionNumber := Add.rtPositionNumber;
        VRWRec^.rtAllowEdit      := True;
        VRWRec^.rtFileExists     := True; // To suppress 'file not found' message
        SyncData(Node);
        CheckFolderContents(Node);
        SyncData(ParentNode);
        CheckFolderContents(ParentNode);
        VRWReportTree.FullyVisible[Node] := True;
        VRWReportTree.Selected[Node] := True;
      end
      else
        { Should never happen }
        ShowMessage('Failed to find node for ' + ParentName);
    end
    else
      ShowMessage('Could not add heading, error ' +
                  IntToStr(FunctionResult));
  finally
    Add := nil;
  end;
  if (Node <> nil) then
  begin
    VRWReportTree.SetFocus;
    VRWReportTree.FocusedNode := Node;
    VRWReportTree.Selected[Node] := True;
    UpdateDisplay;
  end
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.OnSaveReport(Params: TReportWizardParams;
  ParentName, FileName: string; var FunctionResult: Integer);
{ Called by the report wizard when a report is saved, so that the report tree
  details can be saved, and the report tree updated.

  This can be called either for saving a new report, or for saving changes to
  an existing report. It assumes that the report name (which acts as the unique
  identifier for the report) has not been changed.

  It also assumes that if a report is edited, the correct node in the report
  tree is currently selected. }
var
  Add, Update: IVRWReportDataEditor;
  VRWRec: ^TVRWReportDataRec;
  ParentNode, Node: PVirtualNode;
begin
  Node := nil;
  if (Uppercase(Trim(ParentName)) = 'REPORTS') then
    ParentName := '';
  if VRWReportData.ReportExists(Params.wrReportName) then
  { Report found -- update the existing details }
  begin
    Node := VRWReportTree.FocusedNode;
    if (Node <> nil) then
    begin
      VRWRec := VRWReportTree.GetNodeData(Node);
      if (Trim(VRWRec.rtRepName) <> Params.wrReportName) then
      begin
        { The current node does not contain the edited report. This really
          should not happen, and indicates either a bug in the program, or
          a corrupted report data file. }
        raise Exception.Create('A report was found against ' +
                               Params.wrReportName +
                               ' but the current node is for report ' +
                               VRWRec.rtRepName);
      end;
      { Make sure we are on the right record in the data file }
      SyncData(Node);
      Update := VRWReportData.Update;
      Update.rtNodeType   := 'R';
      Update.rtRepDesc    := Params.wrReportDesc;
      FunctionResult := Update.Save;
      { Update the node details }
      VRWReportData.Read;
      VRWRec := VRWReportTree.GetNodeData(Node);
      PopulateVRWRec(VRWRec^);
    end
    else
      FunctionResult := 4;  // Btrieve error 4 -- record not found
  end
  else
  { Report not found -- must be saving a new report }
  begin
    Add := VRWReportData.Add;
    try
      Add.rtNodeType   := 'R';
      Add.rtRepName    := Params.wrReportName;
      Add.rtRepDesc    := Params.wrReportDesc;
      Add.rtParentName := ParentName;
      Add.rtFileName   := FileName;
      if Params.wrWasPrinted then
      begin
        Add.rtLastRun := Now;
        Add.rtLastRunUser := GReportUser;
      end;
      FunctionResult := Add.Save;
      if (FunctionResult = 0) then
      begin
        { Locate the tree node matching the parent name... }
        ParentNode := FindNodeByName(ParentName);
        if (ParentNode <> nil) then
        begin
          { ...and add a new node under this parent }
          Node := VRWReportTree.AddChild(ParentNode);
          VRWRec := VRWReportTree.GetNodeData(Node);
          VRWRec^.rtNodeType       := Add.rtNodeType;
          VRWRec^.rtRepName        := Trim(Add.rtRepName);
          VRWRec^.rtRepDesc        := Trim(Add.rtRepDesc);
          VRWRec^.rtParentName     := Trim(Add.rtParentName);
          VRWRec^.rtFileName       := Trim(Add.rtFileName);
          VRWRec^.rtLastRun        := Add.rtLastRun;
          VRWRec^.rtLastRunUser    := Trim(Add.rtLastRunUser);
          VRWRec^.rtPositionNumber := Add.rtPositionNumber;
          VRWRec^.rtAllowEdit      := True;
          VRWRec^.rtFileExists     := True; // Report has just been created, so
                                            // the report file must exist
          { Tidy folder contents }
          CheckFolderContents(ParentNode);
        end
        else
          { Should never happen }
          ShowMessage('Failed to find node for ' + ParentName);
      end
      else
        ShowMessage('Could not add report to tree, error ' +
                    IntToStr(FunctionResult));
    finally
      Add := nil;
    end;
  end;
  if (Node <> nil) then
  begin
    VRWReportTree.SetFocus;
    VRWReportTree.FocusedNode := Node;
    VRWReportTree.Selected[Node] := True;
    UpdateDisplay;
  end
end;

// -----------------------------------------------------------------------------

function TfrmReportTree.FindNodeByName(NodeName: string): PVirtualNode;
{ Searches the tree for a node with the specified name. Returns nil if a node
  cannot be found. }

  function SearchChildNodes(ParentNode: PVirtualNode): PVirtualNode;
  var
    VRWRec: ^TVRWReportDataRec;
    Node: PVirtualNode;
  begin
    Result := VRWReportTree.GetFirstChild(ParentNode);
    while (Result <> nil) do
    begin
      VRWRec := VRWReportTree.GetNodeData(Result);
      if (Trim(VRWRec^.rtRepName) = Trim(NodeName)) then
        { Found matching node, exit loop }
        Break;
      { Recursively search any child nodes of the current node }
      if (Result.ChildCount > 0) then
      begin
        Node := SearchChildNodes(Result);
        if (Node <> nil) then
        begin
          { Found a matching node, exit loop }
          Result := Node;
          Break;
        end;
      end;
      Result := VRWReportTree.GetNextSibling(Result);
    end;
  end;

begin
  if (Trim(Uppercase(NodeName)) = 'REPORTS') or
     (Trim(Uppercase(NodeName)) = '') then
    Result := VRWReportTree.GetFirst
  else
    Result := SearchChildNodes(VRWReportTree.GetFirst);
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.AfterPrintReport(UserName: ShortString;
  var FunctionResult: Integer);
{ Called by the report wizard after printing a report, so that the report tree
  and details can be updated. }
var
  VRWRec: ^TVRWReportDataRec;
  Node: PVirtualNode;
begin
  Node := VRWReportTree.FocusedNode;
  if (Node <> nil) then
  begin
    { Make sure we are on the right record in the data file }
    SyncData(Node);
    { Retrieve and update the details }
    VRWRec := VRWReportTree.GetNodeData(Node);
    if (VRWRec^.rtNodeType = 'R') then
    begin
      if (UserName <> '') then
        VRWRec.rtLastRunUser := UserName
      else
        VRWRec.rtLastRunUser := GReportUser;
      VRWRec.rtLastRun     := Now;
      { Write the details back to the data file }
      FunctionResult := UpdateData(VRWRec^);
    end;
  end
  else
    { Should only happen if a report is printed before it is saved into
      the Report Tree, so ignore it. }
    ;
//    ShowMessage('Could not find report entry to update');
end;

// -----------------------------------------------------------------------------

function TfrmReportTree.IsEmptyFolder(Node: PVirtualNode): Boolean;
var
  VRWRec: ^TVRWReportDataRec;
  ChildNode: PVirtualNode;
begin
  ChildNode := VRWReportTree.GetFirstChild(Node);
  if (ChildNode <> nil) then
  begin
    VRWRec := VRWReportTree.GetNodeData(ChildNode);
    Result := (Lowercase(Trim(VRWRec^.rtRepName)) = 'empty folder');
  end
  else
    { Node has no child records. Should never happen (there should at least
      be an 'empty folder' node), but handle it anyway }
    Result := False;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.UpdateDisplay;
{ Enables and disables controls as appropriate for the current selection in the
  report tree }
var
  Node: PVirtualNode;
  VRWRec: ^TVRWReportDataRec;
  IsRoot, IsFolder, IsDummy, IsEmpty, IsReport: Boolean;
  IsPresent, IsSystemUser: Boolean;
begin
  if Populating then
    Exit;
  { Fetch the details of the currently selected node, if any }
  Node := VRWReportTree.FocusedNode;
  IsRoot := IsRootNode(Node);
  if (Node <> nil) and (not IsRoot) and (not Printing) then
  begin
    VRWRec := VRWReportTree.GetNodeData(Node);
    { Node is a folder }
    IsFolder := (VRWRec^.rtNodeType = 'H');
    { Node is an empty folder }
    IsEmpty := IsEmptyFolder(Node);
    { Node is an 'empty folder' report (i.e. not a real report) }
    IsDummy  := (VRWRec^.rtNodeType = 'R') and
                (Lowercase(Trim(VRWRec^.rtRepName)) = 'empty folder');
    { Node is an actual report }
    IsReport := (VRWRec^.rtNodeType = 'R') and not IsDummy;
    { Current user is SYSTEM, and has limited access }
    IsSystemUser := (GReportUser = 'SYSTEM');
    IsPresent := False;
    if IsReport then
    begin
      IsPresent :=
        FileExists(VRWReportData.Datapath + 'REPORTS\' + VRWRec^.rtFileName);
      VRWRec^.rtFileExists := IsPresent;
    end;
    { Set the state of the action-list objects }
    actEdit.Enabled           := (IsPresent or IsFolder) and VRWRec^.rtAllowEdit and (not IsDummy) and (not IsSystemUser);
    actCollapseLevel.Enabled  := IsFolder;
    actDelete.Enabled         := VRWRec^.rtAllowEdit and (IsReport or IsEmpty) and (not IsSystemUser);
    actExpandAll.Enabled      := IsFolder;
    actExpandLevel.Enabled    := IsFolder;
    actPrintReport.Enabled    := IsReport and IsPresent and (not IsSystemUser);
    actCopy.Enabled           := IsReport and IsPresent and VRWRec^.rtAllowEdit and (not IsSystemUser);
    actLift.Enabled           := VRWRec^.rtAllowEdit and not IsDummy and (not IsSystemUser);
    actDrop.Enabled           := CanDropHere(Node) and (not IsSystemUser);
    actMoveUp.Enabled         := VRWRec^.rtAllowEdit and not IsDummy and (not IsSystemUser);
    actMoveDown.Enabled       := VRWRec^.rtAllowEdit and not IsDummy and (not IsSystemUser);
    actSecurity.Enabled       := not IsDummy;
    actAdd.Enabled            := True;
    actFind.Enabled           := True;
    actConvert.Enabled        := True;
    actImport.Enabled         := True;
    actDisplayProperties.Enabled := True;
  end
  else
  begin
    actCollapseLevel.Enabled  := IsRoot;
    actEdit.Enabled           := False;
    actExpandAll.Enabled      := IsRoot;
    actExpandLevel.Enabled    := IsRoot;
    actDelete.Enabled         := False;
    actPrintReport.Enabled    := False;
    actCopy.Enabled           := False;
    actLift.Enabled           := False;
    actDrop.Enabled           := IsRoot;
    actMoveUp.Enabled         := False;
    actMoveDown.Enabled       := False;
    actSecurity.Enabled       := False;
    if Printing then
    begin
      actAdd.Enabled     := False;
      actFind.Enabled    := False;
      actConvert.Enabled := False;
      actImport.Enabled  := False;
      actDisplayProperties.Enabled := False;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.VRWReportTreeChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  UpdateDisplay;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.CheckFolderContents(Node: PVirtualNode);
{ Checks the folder to make sure it has at least one child node, and to make
  sure that if it has more than one child, no 'empty folder' reports have been
  left in it. }
var
  VRWRec: ^TVRWReportDataRec;
  ChildNode: PVirtualNode;
begin
  if (Node.ChildCount = 0) then
  { No child nodes. Create an 'empty folder' node }
  begin
    ChildNode := VRWReportTree.AddChild(Node);
    VRWRec := VRWReportTree.GetNodeData(ChildNode);
    FillChar(VRWRec^, Sizeof(VRWRec^), 0);
    with VRWRec^ do
    begin
      rtNodeType := 'R';
      rtParentName := Trim(VRWReportData.rtRepName);
      rtRepName := 'Empty Folder';
      rtFileExists := True; // To suppress 'file not found' message
    end;
    VRWReportTree.FullExpand(Node);
  end
  else if (Node.ChildCount > 1) then
  { More than one child node. Check for 'empty folder' entry and delete it
    if found. }
  begin
    ChildNode := VRWReportTree.GetFirstChild(Node);
    while (ChildNode <> nil) do
    begin
      VRWRec := VRWReportTree.GetNodeData(ChildNode);
      if (VRWRec^.rtNodeType = 'R') and
         (Lowercase(Trim(VRWRec^.rtRepName)) = 'empty folder') then
      begin
        VRWReportTree.DeleteNode(ChildNode);
        Break;
      end;
      ChildNode := VRWReportTree.GetNextSibling(ChildNode);
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TfrmReportTree.CanDropHere(TargetNode: PVirtualNode): Boolean;
{ Checks that the currently selected 'move' node (if any) can safely be dropped
  at the location indicated by TargetNode. Basically avoids copying a folder
  into itself or one of its sub-folders. See UpdateDisplay(). }
begin
  if (NodeToMove = nil) then
    { There is no node waiting to be dropped }
    Result := False
  else if (NodeToMove.ChildCount = 0) then
    { If the source (NodeToMove) is a report, there is no problem }
    Result := True
  else
  begin
    { If the target is a report, then find the folder it is in }
    if (TargetNode.ChildCount = 0) then
      TargetNode := TargetNode.Parent;
    { Now, walk up the parents of the target node, making sure that none of
      them are the same as the source node. If they are, we are trying to drop
      the source into either itself or one of its sub-folders. }
    Result := True;
    while (TargetNode <> nil) do
    begin
      if (TargetNode = NodeToMove) then
      begin
        Result := False;
        Break;
      end;
      TargetNode := TargetNode.Parent;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TfrmReportTree.IsRootNode(Node: PVirtualNode): Boolean;
{ Returns True if the specified node is actually the root node of the tree.
  Uses the RootNode property, because the obvious ways of checking (using
  ReportTree.GetFirst or checking for a nil parent) do not seem to work --
  probably needs further investigation. }
begin
  Result := (RootNode = Node);
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.VRWReportTreeCollapsed(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
{ If the user collapses a node, make sure that the node becomes selected
  (otherwise it is possible to leave the selection on a hidden node) }
begin
  VRWReportTree.FocusedNode := Node;
  VRWReportTree.Selected[Node] := True;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.OnValidateReportName(
  const ReportName: ShortString; var IsValid: Boolean);
begin
  IsValid := not VRWReportData.ReportExists(ReportName);
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.PrepareDesignWindow(
  frmDesignWindow: TfrmReportDesigner);
begin
//  frmDesignWindow.OnAddGroupHeading    := OnAddGroupHeading;
//  frmDesignWindow.OnSaveReport         := OnSaveReport;
//  frmDesignWindow.AfterPrintReport     := AfterPrintReport;
//  frmDesignWindow.OnValidateReportName := OnValidateReportName;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.OnFirstPass(Count, Total: integer;
  var Abort: Boolean);
begin
  pbLabel.Caption := ' Gathering data';
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.OnPrintRecord(Count, Total: integer;
  var Abort: Boolean);
var
  Position: Integer;
  Units: Double;
begin
  if (Total > 0) then
  begin
    Units := 100.00 / Total;
    Position := Trunc(Units * Count);
  end
  else
    Position := 0;
  pbReportProgress.Position := Position;
  if CancelPrint then
    Abort := True;
  Application.ProcessMessages;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.OnSecondPass(Count, Total: integer;
  var Abort: Boolean);
begin
  pbLabel.Caption := ' Printing report';
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if Printing then
    if Confirm('Cancel this print?') then
      CancelPrint := True
    else
      CanClose := False;
end;

// -----------------------------------------------------------------------------

procedure TfrmReportTree.VRWReportTreeDblClick(Sender: TObject);
var
  Node               : PVirtualNode;
  VRWRec             : ^TVRWReportDataRec;
begin
  Node := VRWReportTree.FocusedNode;
  if (Node <> nil) then
  begin
    VRWRec := VRWReportTree.GetNodeData(Node);
    if VRWRec^.rtNodeType = 'R' then
      actEdit.Execute;
  end;
end;

// -----------------------------------------------------------------------------

end.

