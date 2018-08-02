unit PIITreeF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, PIIScannerIntf, VirtualTrees, ExtCtrls, Saltxl1U,
  ExWrap1U, EntWindowSettings, Menus;

type
  TfrmPIITree = class(TForm)
    vstPII: TVirtualStringTree;
    Label1: TLabel;
    pnlButtons: TPanel;
    btnClose: TSBSButton;
    btnPrint: TSBSButton;
    btnExport: TSBSButton;
    btnCloseEntity: TSBSButton;
    btnEdit: TSBSButton;
    btnDelete: TSBSButton;
    btnOpen: TSBSButton;
    btnPrintLink: TSBSButton;
    BottomPanel: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    SaveDialog1: TSaveDialog;
    PopupMenu1: TPopupMenu;
    PrintReport1: TMenuItem;
    Export1: TMenuItem;
    N1: TMenuItem;
    Properties1: TMenuItem;
    N2: TMenuItem;
    StoreCoordinates1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure vstPIIGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vstPIIInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure FormCreate(Sender: TObject);
    procedure vstPIIPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure btnCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure StoreCoordinates1Click(Sender: TObject);
  private
    { Private declarations }
    oScanner : IPIIScanner;
    RootNode : PVirtualNode;
    DispCust     :  TFCustDisplay;
    FExLocal : TdExLocal;
    WindowSettings: IWindowSettings;
    StoreCoord : Boolean;
    NeedCUpdate : Boolean;
    procedure LoadItems(const ItemList : IPIIInfoList; ANode : PVirtualNode);
    procedure EditAccount(const KeyString : string);
    procedure EditTrans(const OurRef : string);
  public
    { Public declarations }
    ScanType : TPIIScanType;
    constructor CreateWithScanType(AOwner : TComponent; AScanType : TPIIScanType;
                                   const ACaption : string;
                                   const ExLocal : TdExLocal);
  end;

var
  frmPIITree: TfrmPIITree;

implementation

uses
  oPIIScanner, PIIFieldNumbers, VarConst, Custr3u, BtSupU1, Tranl1U, PIIProgressF,
  APIUtil, PIITreePrint, StrUtils;

type
  PVTNodeData = ^TVTNodeData;
  TVTNodeData = Record
    Index : Integer;  //Index in Scanner Tree
    InfoItem : IPIIInfoItem;
  end;


{$R *.dfm}

procedure TfrmPIITree.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  oScanner := nil;

  WindowSettings.WindowToSettings(self);
  WindowSettings.ParentToSettings(vstPII, vstPII);
  WindowSettings.SaveSettings(StoreCoord);
end;

procedure TfrmPIITree.LoadItems(const ItemList : IPIIInfoList; ANode : PVirtualNode);
var
  Node : PVirtualNode;
  Data, LocalData : PVTNodeData;
  ThisItem : IPIIInfoItem;
  i : Integer;
begin
  for i := 0 to ItemList.Count - 1 do
  begin
    ThisItem := ItemList[i];
    if IncludeInTree(ThisItem.FieldType) then
    begin
      New(LocalData);
      LocalData.Index := ThisItem.Index;
      Node := vstPII.AddChild(ANode);
      Data := vstPII.GetNodeData(Node);
      Data^ := LocalData^;
      if ThisItem.HasChildren then
      begin
        LoadItems(ThisItem.Children, Node);
      end;
    end;
  end;
end;

procedure TfrmPIITree.vstPIIGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data : PVTNodeData;
begin
  CellText := '';

  Data := Sender.GetNodeData(Node);
  CellText := oScanner.PIIList[Data.Index].DisplayText;
end;

procedure TfrmPIITree.vstPIIInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Data : PVTNodeData;
begin
  if ParentNode = nil then
  begin
    RootNode := Node;
    Data := vstPII.GetNodeData(Node);
    Data.Index := 0;
    if oScanner.PIITree.HasChildren then
    begin
      LoadItems(oScanner.PIITree.Children, Node);
      vstPII.FullExpand(nil);
    end;
  end;
end;

procedure TfrmPIITree.FormCreate(Sender: TObject);
var
  ProgressForm : TfrmPIIProgress;
begin
  ClientHeight := 624;
  ClientWidth := 1048;


  //PR: 25/01/2018 ABSEXCH-16942 Hide Edit, Delete, etc buttons as they
  //won't be implemented in first phase of GDPR
  btnEdit.Visible := False;
  btnOpen.Visible := False;
  btnDelete.Visible := False;
  btnPrintLink.Visible := False;
  btnCloseEntity.Visible := False;

  Top := Application.MainForm.ClientHeight - Height - 10;

  WindowSettings := EntWindowSettings.GetWindowSettings(self.Name);
  WindowSettings.LoadSettings;
  WindowSettings.SettingsToWindow(self);
  WindowSettings.SettingsToParent(vstPII);

  vstPII.RootNodeCount := 1;
  vstPII.NodeDataSize := SizeOf(TVTNodeData);

  if ScanType = pstTrader then
    oScanner := GetPIIScanner(Self, FExLocal.LCust)
  else
    oScanner := GetPIIScanner(Self, FExLocal.LJobMisc.EmplRec);

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Try
    if Assigned(oScanner) then
    begin
      ProgressForm := TfrmPIIProgress.Create(Application.Mainform);
      oScanner.Execute;
      while not oScanner.ScanComplete do
        Application.ProcessMessages;
      PostMessage(ProgressForm.Handle, WM_CLOSE, 0, 0);
    end;
  Finally
    Screen.Cursor := crDefault;
  End;
  FormResize(Self);
end;

procedure TfrmPIITree.vstPIIPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  Data : PVTNodeData;
  Header : IPIIInfoHeader;
begin
  Data := Sender.GetNodeData(Node);
  if oScanner.PIIList[Data.Index].ItemType = itHeader then
    TargetCanvas.Font.Style := [fsBold]
  else
    TargetCanvas.Font.Style := [];
end;

constructor TfrmPIITree.CreateWithScanType(AOwner: TComponent;
  AScanType: TPIIScanType; const ACaption : string;
                                   const ExLocal : TdExLocal);
begin
  ScanType := AScanType;
  inherited Create(AOwner);
  Caption := 'PII Information for ' + ACaption;
  FExLocal := ExLocal;
end;

procedure TfrmPIITree.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPIITree.FormResize(Sender: TObject);
begin
  if ClientWidth < 542 then
    ClientWidth := 542;

  if ClientHeight < 292 then
    ClientHeight := 292;

  vstPII.Width := ClientWidth - vstPII.Left - pnlButtons.Width;
  vstPII.Height := ClientHeight - vstPII.Top - BottomPanel.Height;
end;

//Edit/Delete functionality to be completed if time allows 

procedure TfrmPIITree.btnEditClick(Sender: TObject);
var
  ParentData,
  NodeData : PVTNodeData;
  CompanyString : string;
  ThisItem : IPIIInfoItem;
  HeaderItem : IPIIInfoHeader;
begin
(*  if Assigned(vstPII.FocusedNode) then
  begin
    //Get data for selected item
    NodeData := vstPII.GetNodeData(vstPII.FocusedNode);

    ThisItem := oScanner.PIIList[NodeData.Index];
    if ThisItem.ItemType <> itHeader then
    begin
      ParentData := vstPII.GetNodeData(vstPII.FocusedNode.Parent);
      HeaderItem := oScanner.PIIList[ParentData.Index] as IPIIInfoHeader;
    end
    else
      HeaderItem := ThisItem as IPIIInfoHeader;

    Case HeaderItem.FieldType of
       PIIAccount : EditAccount(HeaderItem.KeyString);
       PIITransaction : EditTrans(HeaderItem.KeyString);
    end;
  end; *)
end;

procedure TfrmPIITree.EditAccount(const KeyString: string);
var
  CustRecForm : TCustRec3;
Begin
(*  CustRecForm:=TCustRec3.Create(Self);
  Global_GetMainRec(CustF,KeyString);
  with CustRecForm do
  begin
    ExLocal.LGetMainRecPos(CustF, KeyString);

    ShowLink;
    EditAccount(True);
  end; *)
end;

procedure TfrmPIITree.EditTrans(const OurRef: string);
var
  DispTrans : TFInvDisplay;
  DisplayOptions : TransactionDisplayOptionsSet;
begin
(*    DispTrans:=TFInvDisplay.Create(Self);

    try
      CheckRecExsists(OurRef, InvF, InvOurRefK);

      //If posted then need to set options to allow posted edit
      if Inv.RunNo <> 0 then
        DisplayOptions := [GDPR_AllowPostedEdit]
      else
        DisplayOptions := [];

      With DispTrans do
      Begin
        LastDocHed:= Inv.InvDocHed;
        DocRunRef:= OurRef;
        DocHistRunNo := Inv.RunNo;

        Display_Trans(2, Inv.FolioNum, True, True, DisplayOptions);

      end; {with..}

    except

      DispTrans.Free;

    end;
*)
end;

procedure TfrmPIITree.btnExportClick(Sender: TObject);
var
  PrintNotes : Boolean;
begin
  PrintNotes := msgBox('Do you want to include notes on the report?', mtConfirmation, [mbYes, mbNo],
                      mbYes, 'Print PII Report') = mrYes;
  if SaveDialog1.Execute then
  begin
    oScanner.WriteToXML(SaveDialog1.Filename, PrintNotes);
    msgbox('Report written to ' + SaveDialog1.Filename, mtInformation, [mbOK],
           mbOK, 'Export PII Report');
  end;
end;

procedure TfrmPIITree.btnPrintClick(Sender: TObject);
var
  PrintNotes : Boolean;
begin
  PrintNotes := msgBox('Do you want to include notes on the report?', mtConfirmation, [mbYes, mbNo],
                      mbYes, 'Print PII Report') = mrYes;
  AddPIIPrintToQueue(Self, oScanner, PrintNotes,
                    IfThen(ScanType = pstEmployee, Trim(JobMisc.EmplRec.EmpName),
                     Trim(Cust.Company)));
end;

procedure TfrmPIITree.Properties1Click(Sender: TObject);
begin
  if Assigned(WindowSettings) then
    if WindowSettings.Edit(vstPII, vstPII) = mrOK then
      NeedCUpdate := True;
  
end;

procedure TfrmPIITree.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordinates1.Checked:=StoreCoord;
end;

procedure TfrmPIITree.StoreCoordinates1Click(Sender: TObject);
begin
  StoreCoord := Not StoreCoord;
  NeedCUpdate := True;
end;

end.
