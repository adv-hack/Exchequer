unit MessagesConfigForm;

{******************************************************************************}
{* The following change has been made to the TMS Components to draw a box     *}
{* around a flat TColumnComboBox:-                                            *}
{* In AdvCombo.pas, procedure TAdvCustomCombo.DrawControlBorder(DC: HDC);

    if FFlat and (FFlatLineColor <> clNone) then
    begin
      OldPen := SelectObject(DC,CreatePen( PS_SOLID,1,ColorToRGB(FFlatLineColor)));
      MovetoEx(DC,ARect.Left - 2,Height - 1,nil);
      LineTo(DC,ARect.Right - 18 ,Height - 1);
      LineTo(DC,ARect.Right - 18, 0);            // ***BJH***
      LineTo(DC, 0, 0);                          // ***BJH***
      LineTo(DC, 0, Height - 1);                 // ***BJH***
      DeleteObject(SelectObject(DC,OldPen));
    end;


{* The following change has been made to the TVirtualStringTree component to  *}
{* prevent OleInitialize from being called:-
{* In VirtualTrees.pas, procedure InitializeGlobalStructures;

  // Initialize OLE subsystem for drag'n drop and clipboard operations.
  {$IFNDEF BJHDISABLEOLE}                        // ***BJH***
{  NeedToUnitialize := Succeeded(OleInitialize(nil));
  {$ENDIF}                                       // ***BJH***


{* The project must be compiled with TMSDISABLEOLE and BJHDISABLEOLE defined.
{* There appears to be a problem with the OLE subsystem not unloading which in
{* turn prevents the Outlook process from terminating even though the UI closes.
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, AdvMenus,
  AdvMenuStylers, GradientLabel, AdvGlowButton, AdvSpin, htmlbtns, Mask,
  AdvOfficePager, AdvPanel, AdvOfficePagerStylers, AdvCombo, ColCombo,
  rtflabel, ComObj, ActiveX, AdvEdit, adxAddin, Outlook2000, VirtualTrees,
  ImgList, KPICommon;

type
  TfrmConfigureMessages = class(TForm)
    advPanel: TAdvPanel;
    btnSave: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    ofConfig: TAdvOfficePager;
    ofpCustSupp: TAdvOfficePage;
    gbFilters: TGroupBox;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    pnlRounded: TPanel;
    pgStyler: TAdvOfficePagerOfficeStyler;
    Label1: TLabel;
    VST: TVirtualStringTree;
    ImageList: TImageList;
    procedure advPanelDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure VSTGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure VSTGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure btnSaveClick(Sender: TObject);
  private
    FTreeLevel: integer;
    OL: outlook2000.TOutlookApplication;
    NS: NameSpace;
    FFolderList: TStringList;
    FSelectedFolders: TStringList;
    procedure MakeRounded(Control: TWinControl);
    procedure SetHost(Value: HWND);
    procedure GetFolderInfo(const CurFolder: MapiFolder);
    function  MailBoxFolder(const AFolder: MAPIFolder): MAPIFolder;
    function  MailBoxName(const AFolder: MAPIFolder): WideString;
  public
    destructor destroy; override;
    procedure Startup;
    property  SelectedFolders: TStringList read FSelectedFolders;
  protected
  end;

implementation

uses CommCtrl, Contnrs;

{$R *.dfm}

Type
  TSortData = Class(TObject)
  Private
    FFolder: MAPIFolder;
    FName: WideString;
    FSortKey: WideString;
    FLevel: integer;
  Public
    Property Name: WideString Read FName;  {* DATA FIELDS REQUIRED FOR OR AFTER THE SORT *}
    Property Level: integer Read FLevel;
    property SortKey: WideString read FSortKey;
    property Folder: MAPIFolder read FFolder;

    Constructor Create(Folder: MAPIFolder; Level: integer);
  End;

type
  PNodeData = ^TNodeData;
  TNodeData = record
    Caption:    WideString;
    Level:      Integer;
    ImageIndex: integer;
  end;

const
  NODEDATASIZE = SizeOf(TNodeData);

destructor TfrmConfigureMessages.destroy;
begin
  if assigned(FSelectedFolders) then
    FreeAndNil(FSelectedFolders);
  inherited destroy;
end;

procedure TfrmConfigureMessages.FormCreate(Sender: TObject);
begin
  // Centre - can't use poScreenCentre because of Host property not working
  Self.Top := (Screen.Height - - Self.Height) Div 2;
  Self.Left := (Screen.Width - Self.Width) Div 2;
  MakeRounded(self);
  MakeRounded(pnlRounded);
  MakeRounded(advPanel);
  FSelectedFolders := TStringList.create;
end;

Procedure TfrmConfigureMessages.SetHost (Value : HWND);
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

  function TfrmConfigureMessages.MailBoxName(const AFolder: MAPIFolder): WideString;
  var
    IDisp: IDispatch;
    Folder: MAPIFolder;
  begin
    Result := '';
    try
      Folder := AFolder;
      while Assigned(Folder) do begin
        Result := Folder.Name;
        IDisp := Folder.Parent;
        IDisp.QueryInterface(IID_MAPIFolder, Folder);
      end;
    except
      // mailbox permissions
    end;
  end;

procedure TfrmConfigureMessages.Startup;

  procedure ConvertToHighColor(ImageList: TImageList);
  // To show smooth images we have to convert the image list from 16 colors to high color.
  var
    IL: TImageList;
  begin
    // Have to create a temporary copy of the given list, because the list is cleared on handle creation.
    IL := TImageList.Create(nil);
    IL.Assign(ImageList);

    with ImageList do
      Handle := ImageList_Create(Width, Height, ILC_COLOR16 or ILC_MASK, Count, AllocBy);
    ImageList.Assign(IL);
    IL.Free;
  end;

  function GetImageIndex(FolderName: WideString): integer;
  const
    FolderNames: array[1..6] of string = ('calendar', 'contacts', 'inbox', 'journal', 'notes', 'tasks');
  var
    i: integer;
  begin
    result := 3; // default standard folder icon
    if pos('mailbox', LowerCase(FolderName)) = 1 then
      result := 0
    else
     for i := low(FolderNames) to high(FolderNames) do
       if SameText(FolderName, FolderNames[i]) then
         result := i;
  end;

  procedure BuildTree;
  var
    i: integer;
    NodeData:  PNodeData;
    NewNode:   PVirtualNode;
    NodeLevel: integer;
    ParentNodes: array of PVirtualNode;
  begin
    NodeLevel := -1;
    for i := 0 to FFolderList.Count - 1 do
      if integer(FFolderList.Objects[i]) > NodeLevel then begin
        NodeLevel := integer(FFolderList.Objects[i]);
        SetLength(ParentNodes, NodeLevel + 2);  // set length to accommodate deepest level + 1
      end;
    for i := 0 to FFolderList.Count - 1 do begin
      NodeLevel := integer(FFolderList.Objects[i]);

      NewNode := vst.AddChild(ParentNodes[NodeLevel]);
      ParentNodes[NodeLevel + 1] := NewNode;

      NodeData := VST.GetNodeData(NewNode);
      if assigned(NodeData) then
        with NodeData^ do begin
          Caption    := FFolderList.Strings[i];
          Level      := NodeLevel;
          ImageIndex := GetImageIndex(Caption);

          with NewNode^ do
            if Level > 0 then begin
              CheckType := ctCheckBox;
              if FSelectedFolders.IndexOf(Caption) <> -1 then
                CheckState := csCheckedNormal;
            end;
        end;

    end; // for
    if length(ParentNodes) > 0 then
      vst.Expanded[ParentNodes[1]] := true;
  end;
begin
  lblInfo.Caption := self.Caption;
  FTreeLevel := 0;
  vst.NodeDataSize := NODEDATASIZE;
  ConvertToHighColor(ImageList);
  OL  := TOutlookApplication.Create(nil);
  NS  := OL.GetNamespace('MAPI');
  FFolderList := TStringList.Create;
  try
    FFolderList.AddObject(MailBoxFolder(NS.GetDefaultFolder(olFolderInbox)).Name, TObject(0)); // name and tree level
    GetFolderInfo(MailBoxFolder(NS.GetDefaultFolder(olFolderInbox)));                          // recurse thru mailbox adding folders
    BuildTree;                                                                                 // create tree from list of folders.
  finally
    FFolderList.free;
    NS := nil;
    OL := nil;
  end;
end;

procedure TfrmConfigureMessages.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end;
end;

procedure TfrmConfigureMessages.FormActivate(Sender: TObject);
begin
  ofpCustSupp.SetFocus;
end;

procedure TfrmConfigureMessages.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmConfigureMessages.MakeRounded(Control: TWinControl);
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

function TfrmConfigureMessages.MailBoxFolder(const AFolder: MAPIFolder): MAPIFolder;
var
  IDisp: IDispatch;
  Folder: MAPIFolder;
begin
  Result := nil;
  try
    Folder := AFolder;
    while Assigned(Folder) do begin
      result := folder;
      IDisp  := Folder.Parent;
      IDisp.QueryInterface(IID_MAPIFolder, Folder);
    end;
  except
    // mailbox permissions
  end;
end;

function SortObjects (Item1, Item2: Pointer) : Integer;
Var
  Obj1, Obj2 : TSortData;
Begin
  Obj1 := TSortData(Item1);
  Obj2 := TSortData(Item2);

  result := StrComp(pchar(obj1.SortKey), pchar(obj2.SortKey));
End;

procedure TfrmConfigureMessages.advPanelDblClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, 0, false);
end;

procedure TfrmConfigureMessages.GetFolderInfo(const CurFolder: MapiFolder);
var
  i: integer;
  Folders: TObjectList;
begin
  inc(FTreeLevel);                                          // increment global level variable
  Folders := TObjectList.Create(true);
  for i:= 1 to CurFolder.Folders.Count do begin             // store node data
    Folders.Add(TSortData.Create(CurFolder.Folders.Item(i), FTreeLevel));
  end;
  Folders.Sort(SortObjects);

  try
    if Folders.Count > 0 then                                // check for subfolders
      for i:= 0 to Folders.Count - 1 do begin                // store node data
        with TSortData(Folders[i]) do begin
          FFolderList.AddObject(Name, TObject(Level));
          GetFolderInfo(Folder);                             // recurse
        end;
      end;
//    if CurFolder.Folders.Count > 0 then                         // check for subfolders
//      for i:= 1 to CurFolder.Folders.Count do begin             // store node data
//        FFolderList.AddObject(CurFolder.Folders.Item(i).Name, TObject(FTreeLevel));
//        GetFolderInfo(CurFolder.Folders.Item(i));               // recurse
//      end;
  finally
    FreeAndNil(Folders);
  end;
  dec(FTreeLevel);                                              // decrement global level variable
end;

procedure TfrmConfigureMessages.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  NodeData: PNodeData;
begin
  NodeData := vst.GetNodeData(Node);
  if assigned(NodeData) then
    CellText := NodeData.Caption
  else
    CellText := 'Outlook Folder';
end;

procedure TfrmConfigureMessages.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfrmConfigureMessages.VSTGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
                                               var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData: PNodeData;
begin
  Ghosted    := false;
  NodeData := vst.GetNodeData(Node);
  if assigned(NodeData) then
    ImageIndex := NodeData.ImageIndex;
end;

procedure TfrmConfigureMessages.btnSaveClick(Sender: TObject);
var
  Node: PVirtualNode;
  NodeData: PNodeData;
begin
  FSelectedFolders.Clear;
  Node := vst.GetFirstNoInit;
  while assigned(Node) do begin
    if Node.CheckState in [csCheckedNormal, csCheckedPressed] then begin
      NodeData := vst.GetNodeData(Node);
      if assigned(NodeData) then
        FSelectedFolders.Add(NodeData.Caption);
    end;
    Node := vst.GetNextNoInit(Node);
  end;
end;

{ TSortData }

constructor TSortData.Create(Folder: MAPIFolder;  Level: integer);
begin
  FFolder  := Folder;
  FName    := Folder.Name;
  FLevel   := Level;
  FSortKey := FName;
end;

initialization

finalization

end.
