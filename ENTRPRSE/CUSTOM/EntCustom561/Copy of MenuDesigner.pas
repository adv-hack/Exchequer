unit MenuDesigner;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, ComCtrls, Menus, TEditVal, CheckLst, ExtCtrls, ImgList
  , uEntMenu, Enterprise01_TLB, ToolBTFiles, MiscUtil, Grids, ValEdit
  , uSettings, SystemSetup;

type
  TfrmMenuDesigner = class(TForm)
    panDetails: TPanel;
    Bevel4: TBevel;
    Bevel1: TBevel;
    lCaption: TLabel;
    lTarget: TLabel;
    lTargetType: Label8;
    lblTargType: Label8;
    lStartIn: TLabel;
    lParameters: TLabel;
    lSpecific: TLabel;
    Label6: TLabel;
    edCaption: TEdit;
    edPath: TEdit;
    edStart: TEdit;
    btnBrowseStart: TButton;
    edParams: TEdit;
    btnBrowseTarget: TButton;
    lbSpecificUsers: TCheckListBox;
    cbAllUsers: TCheckBox;
    rbAllCompanies: TRadioButton;
    rbThisCompany: TRadioButton;
    Bevel5: TBevel;
    ilTree: TImageList;
    panButtons: TPanel;
    btnAddSubmenu: TButton;
    btnClose: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnAddOption: TButton;
    btnPreview: TButton;
    btnSetup: TButton;
    btnAddReport: TButton;
    btnMoveUp: TButton;
    btnMoveDown: TButton;
    panTree: TPanel;
    bvTree: TBevel;
    tvMenu: TTreeView;
    cbHide: TCheckBox;
    bvDetails: TBevel;
    edHelpText: TEdit;
    lHelpText: TLabel;
    lbSpecificCompanies: TCheckListBox;
    cbAllCompanies: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    dlgOpen: TOpenDialog;
    btnAddSeparator: TButton;
    btnTest: TButton;
    Button1: TButton;
    Button2: TButton;
    pmPopupMenu: TPopupMenu;
    ExpandAll1: TMenuItem;
    CollapseAll1: TMenuItem;
    lbInfo: TListBox;
    N1: TMenuItem;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    Panel1: TPanel;
    procedure btnCloseClick(Sender: TObject);
    procedure tvMenuChange(Sender: TObject; Node: TTreeNode);
    procedure btnSetupClick(Sender: TObject);
    procedure rbAvailableClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure cbHideClick(Sender: TObject);
    procedure cbAllUsersClick(Sender: TObject);
    procedure cbAllCompaniesClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnBrowseTargetClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnMoveClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure tvMenuDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tvMenuDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvMenuExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvMenuCollapsed(Sender: TObject; Node: TTreeNode);
    procedure ExpandAll1Click(Sender: TObject);
    procedure CollapseAll1Click(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure edPathChange(Sender: TObject);
    procedure btnBrowseStartClick(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure SaveCoordinates1Click(Sender: TObject);
    procedure pmPopupMenuPopup(Sender: TObject);
  private
    { Private declarations }
    FOnUpdateTools : TNotifyEvent;
    FormMode : TFormMode;
    CurrentMenuItemRec : TMenuItemRec;
    sParentComponentName : string;
    ParentItem : TTreeNode;
    iAddPosition : integer;
    CurrentNode : TTreeNode;
    bRestore, bSaveCoordinates : boolean;
    procedure EnableDisable;
    procedure WMGetMinMaxInfo(var message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure MenuItemRec2Form(MenuItemRec : TMenuItemRec);
    function GetMenuItemFromForm : TMenuItemRec;
    function Validate(MenuItemRec : TMenuItemRec) : boolean;
    procedure HighlightItem(sComponentName : string);
    procedure RemoveAllCompanies(iItemFolioNo : integer);
    procedure RemoveAllUsers(iItemFolioNo : integer);
    procedure UpdateInfoPanel;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
  public
    Property OnUpdateTools : TNotifyEvent read FOnUpdateTools write FOnUpdateTools;
    procedure LoadEnterpriseMenu;
    procedure InitialiseForm;
  end;

var
  frmMenuDesigner: TfrmMenuDesigner;

implementation
uses
  Registry, APIUtil, ToolProc, StrUtil, EntMenuU, BTConst, BTUtil, FileUtil;

{$R *.dfm}

procedure TfrmMenuDesigner.LoadEnterpriseMenu;
var
  iLevel : integer;

  procedure LoadNodesFrom(MenuItems : TMenuItem; ParentItem : TTreeNode);
  var
    iIndex, iPos : integer;
    NewItem : TTreeNode;
    sCaption : string;
    MenuItemInfo : TMenuItemInfo;
  begin{LoadNodesFrom}
    inc(iLevel);
    For iPos := 0 to MenuItems.Count -1 do
    begin
      if not ((length(MenuItems[iPos].Name) > 3)
      and (UpperCase(Copy(MenuItems[iPos].Name,1,3)) = 'XXX')) then
      begin
        sCaption := RemoveAllChars(MenuItems[iPos].caption, '&');
        if sCaption = '-'
        then sCaption := SEPARATOR;
  //      else sCaption := sCaption + '(' + MenuItems[iPos].Name + ')';

        if (not cbHide.checked) or UserDefinedItem(MenuItems[iPos].Name)
        or (MenuItems[iPos].Count > 0) then
        begin
          MenuItemInfo := TMenuItemInfo.Create;
  //       MenuItemInfo.Position := iPos + 1;

          if UserDefinedItem(MenuItems[iPos].Name) then
          begin
            MenuItemInfo.MenuItemRec := GetMenuItemFromName(MenuItems[iPos].Name);
            sCaption := GetCaptionNameFrom(MenuItemInfo.MenuItemRec);
          end else
          begin
            FillChar(MenuItemInfo.MenuItemRec, SizeOf(MenuItemInfo.MenuItemRec), #0);
            MenuItemInfo.MenuItemRec.miComponentName := PadString(psRight, MenuItems[iPos].Name, ' ', 50);
            MenuItemInfo.MenuItemRec.miPosition := iPos + 1;

            if ParentItem <> nil
            then MenuItemInfo.MenuItemRec.miParentComponentName := TMenuItemInfo(ParentItem.Data).MenuItemRec.miComponentName;
          end;{if}

          if ParentItem = nil then
          begin
  //         MenuItemInfo.ParentComponentName := '';
            NewItem := tvMenu.Items.AddObject(ParentItem, sCaption, MenuItemInfo)
          end else
          begin
  //         MenuItemInfo.ParentComponentName := TMenuItemInfo(ParentItem.Data).MenuItemRec.miComponentName;
            NewItem := tvMenu.Items.AddChildObject(ParentItem, sCaption, MenuItemInfo);
          end;

          case GetUserDefinedItemType(MenuItems[iPos].Name) of
            IT_MenuItem : iIndex := II_UserOption;
            IT_Report  : iIndex := II_UserReport;
            IT_SubMenu : iIndex := II_UserMenu;
            IT_Separator : iIndex := II_Separator;
            else iIndex := II_EnterpriseOption;
          end;{case}

          if (MenuItems[iPos].Count > 0) and (iIndex <> II_UserMenu)
          then iIndex := II_EnterpriseMenu;

          NewItem.SelectedIndex := iIndex;
          NewItem.ImageIndex := iIndex;
        end;{if}
        LoadNodesFrom(MenuItems[iPos], NewItem);
      end;{if}
    end;{for}
  end;{LoadNodesFrom}

begin
//  NewItem := tvMenu.Items.Add(nil, EnterpriseMenu.Items[0].caption)
  iLevel := 0;
  tvMenu.Items.Clear;
  LoadNodesFrom(EnterpriseMenu.Items, nil);

  if tvMenu.Items.Count > 0
  then tvMenu.Selected := tvMenu.Items[0];

end;

procedure TfrmMenuDesigner.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMenuDesigner.tvMenuChange(Sender: TObject; Node: TTreeNode);
begin
  CurrentNode := Node;
  CurrentMenuItemRec := TMenuItemInfo(Node.Data).MenuItemRec;
  MenuItemRec2Form(CurrentMenuItemRec);
  EnableDisable;
  UpdateInfoPanel;
end;

procedure TfrmMenuDesigner.EnableDisable;
begin
  panDetails.visible := CurrentMenuItemRec.miItemType <> '';

  tvMenu.enabled := (FormMode = fmView);
  cbHide.Enabled := tvMenu.enabled;

  btnAddOption.Enabled := tvMenu.enabled and (not cbHide.Checked);
  btnAddReport.Enabled := btnAddOption.Enabled;
  btnAddSubMenu.Enabled := btnAddOption.Enabled;
  btnAddSeparator.Enabled := btnAddOption.Enabled;

  btnOK.Enabled := panDetails.visible and (FormMode in [fmAdd, fmEdit]);
  btnCancel.Enabled := btnOK.Enabled;

  btnEdit.Enabled := panDetails.visible and (FormMode = fmView) {and (CurrentMenuItemRec.miItemType <> IT_Separator)};
  btnDelete.Enabled := panDetails.visible and (FormMode = fmView) and (not cbHide.Checked);
  btnMoveUp.Enabled := btnDelete.Enabled;
  btnMoveDown.Enabled := btnDelete.Enabled;
  btnTest.Enabled := panDetails.visible and (FormMode = fmView)
  and (CurrentMenuItemRec.miItemType in [IT_MenuItem, IT_Report]);

  btnPreview.Enabled := tvMenu.enabled;
  btnSetup.Enabled := tvMenu.enabled;
  btnClose.Enabled := tvMenu.enabled;

  panDetails.Enabled := FormMode in [fmAdd, fmEdit];

  cbAllUsers.Visible := rbThisCompany.Checked;
  lbSpecificUsers.Visible := cbAllUsers.Visible;

  cbAllCompanies.Visible := not rbThisCompany.Checked;
  lbSpecificCompanies.Visible := cbAllCompanies.Visible;

  lbSpecificCompanies.Enabled := not cbAllCompanies.Checked;
  lbSpecificUsers.Enabled := not cbAllUsers.Checked;

  if rbThisCompany.Checked then
  begin
    lSpecific.Caption := 'Specific User Access';
  end else
  begin
    lSpecific.Caption := 'Specific Company Access';
  end;{if}
end;

procedure TfrmMenuDesigner.btnSetupClick(Sender: TObject);
var
  frmSystemSetup : TfrmSystemSetup;
begin
  frmSystemSetup := TfrmSystemSetup.Create(self);
  with frmSystemSetup do begin
    oSettings.ColorFieldsFrom(tvMenu, frmSystemSetup);
    showmodal;
    release;
  end;{with}
end;

procedure TfrmMenuDesigner.rbAvailableClick(Sender: TObject);
begin
  enableDisable;
{  cbAllUsers.Visible := rbThisCompany.Checked;
  lbSpecificUsers.Visible := cbAllUsers.Visible;

  cbAllCompanies.Visible := not rbThisCompany.Checked;
  lbSpecificCompanies.Visible := cbAllCompanies.Visible;

  if rbThisCompany.Checked then
  begin
    lSpecific.Caption := 'Specific User Access';
  end else
  begin
    lSpecific.Caption := 'Specific Company Access';
  end;{if}
end;

procedure TfrmMenuDesigner.FormCreate(Sender: TObject);
begin
  bRestore := FALSE;
  bSaveCoordinates := FALSE;

  FormMode := fmView;
  SetWindowLong(Handle, GWL_USERDATA, 1121);
//  ClientHeight := 425;
//  ClientWidth  := 750;
{  tvMenu.Anchors := [akLeft, akRight, akTop, akBottom];
  bvTree.Anchors := [akLeft, akRight, akTop, akBottom];
  cbHide.Anchors := [akLeft, akBottom];
  bvDetails.Anchors := [akLeft, akRight, akTop, akBottom];
  lbSpecificUsers.Anchors := [akLeft, akRight, akTop, akBottom];
  lbSpecificCompanies.Anchors := [akLeft, akRight, akTop, akBottom];
  btnClose.Anchors := [akLeft, akBottom];}
  LoadAllSettings;
//  ClientHeight := ClientHeight + 100;
  panDetails.Visible := FALSE;
end;

procedure TfrmMenuDesigner.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  { reload tools options }
  If Assigned (FOnUpdateTools) Then
    FOnUpdateTools(Self);
end;

procedure TfrmMenuDesigner.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
  { De-Allocate memory automatically }
  Action := caFree;
end;

procedure TfrmMenuDesigner.FormDestroy(Sender: TObject);
begin
  frmMenuDesigner := nil;
end;

procedure TfrmMenuDesigner.cbHideClick(Sender: TObject);
var
  sPrevSelComponentName : string;
begin
  sPrevSelComponentName := TMenuItemInfo(tvMenu.Selected.Data).MenuItemRec.miComponentName;
  If Assigned (FOnUpdateTools) Then FOnUpdateTools(Self);
  LoadEnterpriseMenu;
  HighlightItem(sPrevSelComponentName);
  if cbHide.Checked then tvMenu.DragMode := dmManual
  else tvMenu.DragMode := dmAutomatic;
end;

procedure TfrmMenuDesigner.HighlightItem(sComponentName : string);
var
  ToSelect : TTreeNode;
  iPos : integer;
begin
  ToSelect := tvMenu.Items[0];
  for iPos := 0 to tvMenu.Items.Count -1 do begin
    if TMenuItemInfo(tvMenu.Items[iPos].Data).MenuItemRec.miComponentName = sComponentName then
    begin
      ToSelect := tvMenu.Items[iPos];
      break;
    end;
  end;{for}
  tvMenu.Selected := ToSelect;
end;

procedure TfrmMenuDesigner.WMGetMinMaxInfo(var message: TWMGetMinMaxInfo);
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 600;
    ptMinTrackSize.Y := 420;
  end;{with}
  Message.Result := 0;
  inherited;
end;

procedure TfrmMenuDesigner.MenuItemRec2Form(MenuItemRec : TMenuItemRec);

  procedure GetAllCompanies;
  var
    iDashPos, iPos : integer;
    BTRec : TBTRec;
    LToolRec : TToolRec;
  begin{GetAllCompanies}
    // Uncheck All Companies
    For iPos := 0 to lbSpecificCompanies.Items.Count -1 do
    begin
      lbSpecificCompanies.Checked[iPos] := FALSE;
    end;{for}

    // first record
    BTRec.KeyS := RT_CompanyXRef + BTFullNomKey(MenuItemRec.miFolioNo);
    BTRec.Status := BTFindRecord(BT_GetGreaterOrEqual, FileVar[ToolF], LToolRec, BufferSize[ToolF]
    , cxIdxByFolioCode, BTRec.KeyS);
    while (BTRec.Status = 0) and (MenuItemRec.miFolioNo = LToolRec.CompanyXRef.cxItemFolio)
    and (LToolRec.RecordType = RT_CompanyXRef) do
    begin
      For iPos := 0 to lbSpecificCompanies.Items.Count -1 do
      begin
        // look for the company in the listbox
        iDashPos := Pos('-',lbSpecificCompanies.Items[iPos]);
        if iDashPos >= 1 then
        begin
          // tick the company found
          if Trim(LToolRec.CompanyXRef.cxCompanyCode) = Copy(lbSpecificCompanies.Items[iPos]
          , 1, iDashPos - 2) then lbSpecificCompanies.Checked[iPos] := TRUE;
        end;{if}
      end;{for}

      // next record
      BTRec.Status := BTFindRecord(BT_GetNext, FileVar[ToolF], LToolRec, BufferSize[ToolF]
      , cxIdxByFolioCode, BTRec.KeyS);
    end;{while}
  end;{GetAllCompanies}

  procedure GetAllUsers;
  var
    iPos : integer;
    BTRec : TBTRec;
    LToolRec : TToolRec;
  begin{GetAllUsers}
    // Uncheck All Users
    For iPos := 0 to lbSpecificUsers.Items.Count -1 do
    begin
      lbSpecificUsers.Checked[iPos] := FALSE;
    end;{for}

    // first record
    BTRec.KeyS := RT_UserXRef + BTFullNomKey(MenuItemRec.miFolioNo);
    BTRec.Status := BTFindRecord(BT_GetGreaterOrEqual, FileVar[ToolF], LToolRec, BufferSize[ToolF]
    , uxIdxByFolioName, BTRec.KeyS);
    while (BTRec.Status = 0) and (MenuItemRec.miFolioNo = LToolRec.UserXRef.uxItemFolio)
    and (LToolRec.RecordType = RT_UserXRef) do
    begin
      // tick the User found
      iPos := lbSpecificUsers.Items.IndexOf(trim(LToolRec.UserXRef.uxUserName));
      if iPos >= 0 then lbSpecificUsers.Checked[iPos] := TRUE;

      // next record
      BTRec.Status := BTFindRecord(BT_GetNext, FileVar[ToolF], LToolRec, BufferSize[ToolF]
      , uxIdxByFolioName, BTRec.KeyS);
    end;{while}
  end;{GetAllUsers}

begin
  case MenuItemRec.miItemType of
    IT_MenuItem : begin
      lTarget.Visible := TRUE;
      lTarget.Caption := 'Target';
      lStartIn.Visible := TRUE;
      lHelpText.Visible := TRUE;
      lCaption.Visible := TRUE;
    end;
    IT_SubMenu : begin
      lTarget.Visible := FALSE;
      lStartIn.Visible := FALSE;
      lHelpText.Visible := TRUE;
      lCaption.Visible := TRUE;
    end;
    IT_Report : begin
      lTarget.Visible := TRUE;
      lTarget.Caption := 'Report File';
      lStartIn.Visible := FALSE;
      lHelpText.Visible := TRUE;
      lCaption.Visible := TRUE;
    end;
    IT_Separator : begin
      lTarget.Visible := FALSE;
      lStartIn.Visible := FALSE;
      lHelpText.Visible := FALSE;
      lCaption.Visible := FALSE;
    end;
  end;{case}
  edPath.Visible := lTarget.Visible;
  btnBrowseTarget.Visible := lTarget.Visible;
  edStart.Visible := lStartIn.Visible;
  btnBrowseStart.Visible := lStartIn.Visible;
  lParameters.Visible := lStartIn.Visible;
  edParams.Visible := lStartIn.Visible;
  lTargetType.Visible := lStartIn.Visible;
  lblTargType.Visible := lStartIn.Visible;
  edHelpText.Visible := lHelpText.Visible;
  edCaption.Visible := lCaption.Visible;

  case MenuItemRec.miAvailability of
    AV_AllCompanies : rbAllCompanies.Checked := TRUE;
    AV_SpecificCompany : rbThisCompany.Checked := TRUE;
  end;{case}
  edCaption.Text := MenuItemRec.miDescription;
  edHelpText.Text := MenuItemRec.miHelpText;
  edPath.Text := MenuItemRec.miFilename;
  edStart.Text := MenuItemRec.miStartDir;
  edParams.Text := MenuItemRec.miParameters;
  cbAllUsers.Checked := MenuItemRec.miAllUsers;
  cbAllCompanies.Checked := MenuItemRec.miAllCompanies;

  GetAllCompanies;
  GetAllUsers;
end;

function TfrmMenuDesigner.GetMenuItemFromForm : TMenuItemRec;
begin
  Result := CurrentMenuItemRec;
  if rbAllCompanies.Checked then Result.miAvailability := AV_AllCompanies
  else
  begin
    Result.miAvailability := AV_SpecificCompany;
    Result.miCompany := sCurrentCompanyCode;
  end;{if}

  Result.miDescription := edCaption.Text;
  Result.miHelpText := edHelpText.Text;
  Result.miFilename := edPath.Text;
  Result.miStartDir := edStart.Text;
  Result.miParameters := edParams.Text;
  Result.miAllUsers := cbAllUsers.Checked;
  Result.miAllCompanies := cbAllCompanies.Checked;
end;


procedure TfrmMenuDesigner.cbAllUsersClick(Sender: TObject);
begin
  enableDisable;
end;

procedure TfrmMenuDesigner.InitialiseForm;
var
  iPos : integer;
begin
  LoadEnterpriseMenu;
  lbSpecificCompanies.Clear;
  For iPos := 0 to slCompanies.Count -1 do
  begin
    lbSpecificCompanies.Items.AddObject(TCompanyInfo(slCompanies.Objects[iPos]).CompanyRec.Code
    + ' - ' + TCompanyInfo(slCompanies.Objects[iPos]).CompanyRec.Name, TCompanyInfo(slCompanies.Objects[iPos]));
  end;{for}

  lbSpecificUsers.Clear;
  For iPos := 0 to slUsers.Count -1 do
  begin
    lbSpecificUsers.Items.Add(slUsers[iPos]);
  end;{for}
end;

procedure TfrmMenuDesigner.cbAllCompaniesClick(Sender: TObject);
begin
  enableDisable;
end;

procedure TfrmMenuDesigner.btnEditClick(Sender: TObject);
begin
  FormMode := fmEdit;
  EnableDisable;
  if edCaption.Visible then edCaption.SetFocus;
//  else rbAllCompanies.SetFocus;
end;

procedure TfrmMenuDesigner.btnAddClick(Sender: TObject);
var
  ToolRec : TToolRec;
  iStatus : integer;
  MenuItemInfo : TMenuItemInfo;
  NewItem : TTreeNode;
begin
  FillChar(CurrentMenuItemRec, SizeOf(CurrentMenuItemRec), #0);
  CurrentMenuItemRec.miAllCompanies := TRUE;
  CurrentMenuItemRec.miAllUsers := TRUE;

  if Sender = btnAddOption then CurrentMenuItemRec.miItemType := IT_MenuItem;
  if Sender = btnAddReport then CurrentMenuItemRec.miItemType := IT_Report;
  if Sender = btnAddSubmenu then CurrentMenuItemRec.miItemType := IT_SubMenu;
  if Sender = btnAddSeparator then CurrentMenuItemRec.miItemType := IT_Separator;

//  sParentComponentName := TMenuItemInfo(tvMenu.selected.Data).ParentComponentName;
  sParentComponentName := TMenuItemInfo(tvMenu.selected.Data).MenuItemRec.miParentComponentName;
  ParentItem := tvMenu.selected.Parent;

//  iAddPosition := TMenuItemInfo(tvMenu.selected.Data).Position;
  iAddPosition := TMenuItemInfo(tvMenu.selected.Data).MenuItemRec.miPosition;

  if tvMenu.selected.ImageIndex in [II_EnterpriseMenu, II_UserMenu
  , II_EnterpriseMenuOpen, II_UserMenuOpen] then
  begin
    case MsgBox('Do you wish your new item to be added inside the currently highlighted menu ?'
    , mtConfirmation, [mbYes, mbNo], mbYes, 'Add Item')
    of
      mrYes : begin
        sParentComponentName := TMenuItemInfo(tvMenu.selected.Data).MenuItemRec.miComponentName;
        ParentItem := tvMenu.selected;
        iAddPosition := 1;
      end;
{      mrNo : begin
        sParentComponentName := TMenuItemInfo(tvMenu.selected.Data).ParentComponentName;
        iAddPosition := TMenuItemInfo(tvMenu.selected.Data).Position;
      end;}
    end;{case}
  end else
  begin
  end;{if}

  if (sParentComponentName = '')
  and (CurrentMenuItemRec.miItemType in [IT_MenuItem, IT_Report, IT_Separator]) then
  begin
    MsgBox('Sorry. You cannot add an option, report or separator into the main menu.'
    , mtInformation, [mbOK], mbOK, 'Add Item');
  end
  else begin
    if CurrentMenuItemRec.miItemType = IT_Separator then
    begin
      // Add Separator

      // makes a "hole" in the positions for the new item to be added into
      InsertItemAt(iAddPosition, sParentComponentName);

      // fill new record's fields
      FillChar(ToolRec, SizeOf(ToolRec), #0);
      ToolRec.RecordType := RT_MenuItem;
//      ToolRec.DummyChar := IDX_DUMMY_CHAR;
      with ToolRec.MenuItem do
      begin
        miAllCompanies := TRUE;
        miAllUsers := TRUE;
        miItemType := IT_Separator;
        miFolioNo := GetNextFolioNo;
        miDescription := '-';
        miComponentName := GetComponentNameFrom('Separator', miItemType);
        miParentComponentName := sParentComponentName;
        miPosition := iAddPosition;
        SetMenuItemIndexes(ToolRec);
      end;{with}

      // add record into table
      iStatus := BTAddRecord(FileVar[ToolF], ToolRec, BufferSize[ToolF], miIdxByComponentName);
      BTShowError(iStatus, 'BTAddRecord', asAppDir + aFileNames[ToolF]);

      // create info object for the tree
      MenuItemInfo := TMenuItemInfo.Create;
      MenuItemInfo.MenuItemRec := ToolRec.MenuItem;

      // add new item into the tree
      if sParentComponentName = TMenuItemInfo(tvMenu.selected.Data).MenuItemRec.miComponentName then
      begin
        // Adding into a subfolder
        NewItem := tvMenu.Items.AddChildObjectFirst(tvMenu.Selected, SEPARATOR, MenuItemInfo);
      end else
      begin
        // Inserting an item
        NewItem := tvMenu.Items.InsertObject(tvMenu.Selected, SEPARATOR, MenuItemInfo);
      end;{if}

      // refreshes all the info objects in a parent node
      RefreshPositionsIn(ParentItem, tvMenu.Items);

      NewItem.SelectedIndex := II_Separator;
      NewItem.ImageIndex := II_Separator;

      // select new item
      tvMenu.Selected := NewItem;
    end else
    begin
      // Add Option / Report / SubMenu
      MenuItemRec2Form(CurrentMenuItemRec);
      FormMode := fmAdd;
      EnableDisable;
      edCaption.SetFocus;
    end;{if}
  end;{if}
end;

procedure TfrmMenuDesigner.RemoveAllCompanies(iItemFolioNo : integer);
var
  BTRec : TBTRec;
  LToolRec : TToolRec;
begin{RemoveAllCompanies}
  repeat
    // find record
    BTRec.KeyS := RT_CompanyXRef + BTFullNomKey(iItemFolioNo);
    BTRec.Status := BTFindRecord(BT_GetGreaterOrEqual, FileVar[ToolF], LToolRec, BufferSize[ToolF]
    , cxIdxByFolioCode, BTRec.KeyS);
    if (BTRec.Status = 0) and (iItemFolioNo = LToolRec.CompanyXRef.cxItemFolio)
    and (LToolRec.RecordType = RT_CompanyXRef) then
    begin
      // delete record
      BTRec.Status := BTDeleteRecord(FileVar[ToolF], LToolRec, BufferSize[ToolF], cxIdxByFolioCode);
      BTShowError(BTRec.Status, 'BTDeleteRecord', asAppDir + aFileNames[ToolF]);
    end;{if}
  until (BTRec.Status <> 0) or (iItemFolioNo <> LToolRec.CompanyXRef.cxItemFolio)
  or (LToolRec.RecordType <> RT_CompanyXRef);
end;{RemoveAllCompanies}

procedure TfrmMenuDesigner.RemoveAllUsers(iItemFolioNo : integer);
var
  BTRec : TBTRec;
  LToolRec : TToolRec;
begin{RemoveAllUsers}
  repeat
    // find record
    BTRec.KeyS := RT_UserXRef + BTFullNomKey(iItemFolioNo);
    BTRec.Status := BTFindRecord(BT_GetGreaterOrEqual, FileVar[ToolF], LToolRec, BufferSize[ToolF]
    , uxIdxByFolioName, BTRec.KeyS);
    if (BTRec.Status = 0) and (iItemFolioNo = LToolRec.UserXRef.uxItemFolio)
    and (LToolRec.RecordType = RT_UserXRef) then
    begin
      // delete record
      BTRec.Status := BTDeleteRecord(FileVar[ToolF], LToolRec, BufferSize[ToolF], uxIdxByFolioName);
      BTShowError(BTRec.Status, 'BTDeleteRecord', asAppDir + aFileNames[ToolF]);
    end;{if}
  until (BTRec.Status <> 0) or (iItemFolioNo <> LToolRec.CompanyXRef.cxItemFolio)
  or (LToolRec.RecordType <> RT_UserXRef);
end;{RemoveAllUsers}

procedure TfrmMenuDesigner.btnOKClick(Sender: TObject);
var
  MenuItemRec : TMenuItemRec;
  ToolRec : TToolRec;
  NewItem : TTreeNode;
//  iIndex, iStatus : LongInt;
  iIndex : LongInt;
  MenuItemInfo : TMenuItemInfo;

  procedure UpdateUsersCompanies(MenuItemRec : TMenuItemRec);

    procedure AddSelectedCompanies;
    var
      iPos : integer;
      BTRec : TBTRec;
      LToolRec : TToolRec;
    begin{AddSelectedCompanies}
      For iPos := 0 to lbSpecificCompanies.Items.Count -1 do
      begin
        if lbSpecificCompanies.Checked[iPos] then
        begin
          // Fill Company XRef record
          FillChar(LToolRec, SizeOf(LToolRec), #0);
          LToolRec.RecordType := RT_CompanyXRef;
          LToolRec.CompanyXRef.cxCompanyCode := PadString(psRight
          , Uppercase(Trim(lbSpecificCompanies.Items[iPos])), ' ', 6);
          LToolRec.CompanyXRef.cxItemFolio := MenuItemRec.miFolioNo;
//          LToolRec.DummyChar := IDX_DUMMY_CHAR;
          SetCompanyXRefIndexes(LToolRec);

          // Add Company XRef record
          BTRec.Status := BTAddRecord(FileVar[ToolF], LToolRec, BufferSize[ToolF], cxIdxByFolioCode);
          BTShowError(BTRec.Status, 'BTAddRecord', asAppDir + aFileNames[ToolF]);
        end;
      end;{for}
    end;{AddSelectedCompanies}

    procedure AddSelectedUsers;
    var
      iPos : integer;
      BTRec : TBTRec;
      LToolRec : TToolRec;
    begin{AddSelectedUsers}
      For iPos := 0 to lbSpecificUsers.Items.Count -1 do
      begin
        if lbSpecificUsers.Checked[iPos] then
        begin
          // Fill Company XRef record
          FillChar(LToolRec, SizeOf(LToolRec), #0);
          LToolRec.RecordType := RT_UserXRef;
          LToolRec.UserXRef.uxUserName := PadString(psRight
          , Uppercase(Trim(lbSpecificUsers.Items[iPos])), ' ', 10);
          LToolRec.UserXRef.uxItemFolio := MenuItemRec.miFolioNo;
//          LToolRec.DummyChar := IDX_DUMMY_CHAR;
          SetUserXRefIndexes(LToolRec);

          // Add Company XRef record
          BTRec.Status := BTAddRecord(FileVar[ToolF], LToolRec, BufferSize[ToolF], uxIdxByFolioName);
          BTShowError(BTRec.Status, 'BTAddRecord', asAppDir + aFileNames[ToolF]);
        end;
      end;{for}
    end;{AddSelectedUsers}

  begin{UpdateUsersCompanies}
    // remove companies / users
    RemoveAllCompanies(MenuItemRec.miFolioNo);
    RemoveAllUsers(MenuItemRec.miFolioNo);

    // add companies / users
    case MenuItemRec.miAvailability of
      AV_AllCompanies : if not MenuItemRec.miAllCompanies then AddSelectedCompanies;
      AV_SpecificCompany : if not MenuItemRec.miAllUsers then AddSelectedUsers;
    end;{case}
  end;{UpdateUsersCompanies}

var
  BTRec : TBTRec;
begin
  MenuItemRec := GetMenuItemFromForm;
  if Validate(MenuItemRec) then
  begin
    case FormMode of
      // Edit Existing
      fmEdit : begin

        // find record we are editing
        BTRec.KeyS := RT_MenuItem + BuildB50Index(MenuItemRec.miComponentName);
        BTRec.Status := BTFindRecord(BT_GetEqual, FileVar[ToolF], ToolRec, BufferSize[ToolF]
        , miIdxByComponentName, BTRec.KeyS);
        BTShowError(BTRec.Status, 'BTFindRecord', asAppDir + aFileNames[ToolF]);
        if BTRec.Status = 0 then
        begin

          // update record in table
          ToolRec.MenuItem := MenuItemRec;
          SetMenuItemIndexes(ToolRec);
          BTRec.Status := BTUpdateRecord(FileVar[ToolF], ToolRec, BufferSize[ToolF], miIdxByComponentName, BTRec.KeyS);
          BTShowError(BTRec.Status, 'BTUpdateRecord', asAppDir + aFileNames[ToolF]);
        end;

        // update tree object
        TMenuItemInfo(tvMenu.Selected.Data).MenuItemRec := MenuItemRec;
        tvMenu.Selected.Text := GetCaptionNameFrom(MenuItemRec);
      end;

      // Add New
      fmAdd : begin
        // makes a "hole" in the positions for the new item to be added into
        InsertItemAt(iAddPosition, sParentComponentName);

        // fill new record's fields
        ToolRec.RecordType := RT_MenuItem;
//        ToolRec.DummyChar := IDX_DUMMY_CHAR;
        with MenuItemRec do
        begin
          miFolioNo := GetNextFolioNo;
          miComponentName := GetComponentNameFrom(miDescription, miItemType);
          miParentComponentName := sParentComponentName;
          miPosition := iAddPosition;
        end;{with}

        // add record into table
        ToolRec.MenuItem := MenuItemRec;
        SetMenuItemIndexes(ToolRec);
        BTRec.Status := BTAddRecord(FileVar[ToolF], ToolRec, BufferSize[ToolF], miIdxByComponentName);
        BTShowError(BTRec.Status, 'BTAddRecord', asAppDir + aFileNames[ToolF]);

        // create info object for the tree
        MenuItemInfo := TMenuItemInfo.Create;
        MenuItemInfo.MenuItemRec := MenuItemRec;
//        MenuItemInfo.Position := iAddPosition;
//        MenuItemInfo.ParentComponentName := sParentComponentName;

        // add new item into the tree
        if sParentComponentName = TMenuItemInfo(tvMenu.selected.Data).MenuItemRec.miComponentName then
        begin
          // Adding into a subfolder
          NewItem := tvMenu.Items.AddChildObjectFirst(tvMenu.Selected, MenuItemRec.miDescription, MenuItemInfo);
        end else
        begin
          // Inserting an item
          NewItem := tvMenu.Items.InsertObject(tvMenu.Selected, MenuItemRec.miDescription, MenuItemInfo);
        end;{if}

        // refreshes all the info objects in a parent node
        RefreshPositionsIn(ParentItem, tvMenu.Items);

        // select new item
        tvMenu.Selected := NewItem;

        // figure out which icon to display against the new item in the tree
        case GetUserDefinedItemType(MenuItemRec.miComponentName) of
          IT_SubMenu : iIndex := II_UserMenu;
          IT_MenuItem : iIndex := II_UserOption;
          IT_Report : iIndex := II_UserReport;
        end;
        NewItem.SelectedIndex := iIndex;
        NewItem.ImageIndex := iIndex;
      end;
    end;{case}

    UpdateUsersCompanies(MenuItemRec);

    // return to viewmode
    FormMode := fmView;
    EnableDisable;
  end;
end;

function TfrmMenuDesigner.Validate(MenuItemRec : TMenuItemRec) : boolean;
var
  iError : integer;
begin
  iError := 0;

  // check directory exists
  if (not (MenuItemRec.miItemType in [IT_SubMenu, IT_Separator]))
  and (Trim(MenuItemRec.miStartDir) <> '')
  and (not DirectoryExists(MenuItemRec.miStartDir))
  then iError := 2;

  // check filename exists
  if (not (MenuItemRec.miItemType in [IT_SubMenu, IT_Separator]))
  and (not FileExists(MenuItemRec.miFilename))
  then iError := 1;

  case iError of
    1 : begin
      MsgBox('You have entered an invalid filename. Please enter a valid path and filename.'
      , mtError, [mbOK], mbOK, 'Validation Error');
      ActiveControl := edPath;
    end;
    2 : begin
      MsgBox('You have entered an invalid start dir. Please enter a valid path.'
      , mtError, [mbOK], mbOK, 'Validation Error');
      ActiveControl := edStart;
    end;
  end;{case}

  Result := iError = 0;
end;

procedure TfrmMenuDesigner.btnCancelClick(Sender: TObject);
begin
  tvMenuChange(tvMenu, tvMenu.Selected);
  FormMode := fmView;
  EnableDisable;
end;

procedure TfrmMenuDesigner.btnBrowseTargetClick(Sender: TObject);
begin
  if FileExists(edPath.Text) then dlgOpen.FileName := edPath.Text;
  if dlgOpen.Execute then
  begin
    edPath.Text := dlgOpen.FileName;
  end;
end;

procedure TfrmMenuDesigner.btnTestClick(Sender: TObject);
begin
  RunUserOption(CurrentMenuItemRec.miComponentName);
end;

procedure TfrmMenuDesigner.Button1Click(Sender: TObject);
begin
  lbInfo.Visible := not lbInfo.Visible;
{
  MsgBox(CurrentMenuItemRec.miComponentName + #13#13
  + CurrentMenuItemRec.miParentComponentName  + #13#13
  + 'Folio:' + IntToStr(CurrentMenuItemRec.miFolioNo)  + #13#13
  + 'Position:' + IntTostr(CurrentMenuItemRec.miPosition)
  ,mtInformation, [mbOK],mbOK,'ITEM INFO');}
end;

procedure TfrmMenuDesigner.btnMoveClick(Sender: TObject);
var
  KeyS : TStr255;
  iStatus : integer;
  ToolRec : TToolRec;
  MoveItem : TTreeNode;
  iMoveBy : integer;
begin
  iMoveBy := TWinControl(Sender).Tag;

  // find record we are editing
  KeyS := RT_MenuItem + BuildB50Index(CurrentMenuItemRec.miComponentName);
  iStatus := BTFindRecord(BT_GetEqual, FileVar[ToolF], ToolRec, BufferSize[ToolF]
  , miIdxByComponentName, KeyS);
  BTShowError(iStatus, 'BTFindRecord', asAppDir + aFileNames[ToolF]);
  if (iStatus = 0) then
  begin

    // get item we are swapping with
    MoveItem := GetNodeInParentAtPos(CurrentNode.Parent, ToolRec.MenuItem.miPosition + iMoveBy, tvMenu.Items);

    if MoveItem <> nil then
    begin

      // we have found an item to swap with
//      TMenuItemInfo(MoveItem.Data).Position := TMenuItemInfo(MoveItem.Data).Position - iMoveBy;

      // update Item that we are moving
      ToolRec.MenuItem.miPosition := ToolRec.MenuItem.miPosition + iMoveBy;
      SetMenuItemIndexes(ToolRec);
      iStatus := BTUpdateRecord(FileVar[ToolF], ToolRec, BufferSize[ToolF], miIdxByComponentName, KeyS);
      BTShowError(iStatus, 'BTUpdateRecord', asAppDir + aFileNames[ToolF]);

      // update current variable
      CurrentMenuItemRec := ToolRec.MenuItem;

      If UserDefinedItem(TMenuItemInfo(MoveItem.Data).MenuItemRec.miComponentName) then
      begin
        // Update item that we are swapping with

        // find record we are editing
        KeyS := RT_MenuItem + BuildB50Index(TMenuItemInfo(MoveItem.Data).MenuItemRec.miComponentName);
        iStatus := BTFindRecord(BT_GetEqual, FileVar[ToolF], ToolRec, BufferSize[ToolF]
        , miIdxByComponentName, KeyS);
        BTShowError(iStatus, 'BTFindRecord', asAppDir + aFileNames[ToolF]);
        if (iStatus = 0) then
        begin

          // update record in table
          ToolRec.MenuItem.miPosition := ToolRec.MenuItem.miPosition - iMoveBy;
          SetMenuItemIndexes(ToolRec);
          iStatus := BTUpdateRecord(FileVar[ToolF], ToolRec, BufferSize[ToolF], miIdxByComponentName, KeyS);
          BTShowError(iStatus, 'BTUpdateRecord', asAppDir + aFileNames[ToolF]);

          // update object on item
          TMenuItemInfo(MoveItem.Data).MenuItemRec := ToolRec.MenuItem;
        end;{if}
      end
      else begin
        TMenuItemInfo(MoveItem.Data).MenuItemRec.miPosition
        := TMenuItemInfo(MoveItem.Data).MenuItemRec.miPosition - iMoveBy;
      end;

      // swap items in the tree
      if iMoveBy = -1 then CurrentNode.MoveTo(MoveItem, naInsert)
      else MoveItem.MoveTo(CurrentNode, naInsert);

    end;{if}
  end;{if}

  // update tree object
  TMenuItemInfo(tvMenu.Selected.Data).MenuItemRec := CurrentMenuItemRec;
//  TMenuItemInfo(tvMenu.Selected.Data).Position := TMenuItemInfo(tvMenu.Selected.Data).Position + iMoveBy;
end;

procedure TfrmMenuDesigner.Button2Click(Sender: TObject);
var
  KeyS : TStr255;
  iStatus : integer;
  ToolRec : TToolRec;
begin
  // work out how many we need to update
  KeyS := RT_MenuItem;
  iStatus := BTFindRecord(BT_GetGreaterOrEqual, FileVar[ToolF], ToolRec, BufferSize[ToolF]
  , miIdxAddOrder, KeyS);
  while (iStatus = 0) and (ToolRec.RecordType = RT_MenuItem)
  and (ToolRec.MenuItem.miParentComponentName = sParentComponentName) do
  begin
//  AddLineToFile(

    iStatus := BTFindRecord(BT_GetNext, FileVar[ToolF], ToolRec, BufferSize[ToolF]
    , miIdxAddOrder, KeyS);
  end;{while}
end;

procedure TfrmMenuDesigner.tvMenuDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
{var
  MoveToNode : TTreeNode;}
begin
//  Caption := TMenuItem(Sender).Name + '/' + TMenuItem(Source).Name;
//  MoveToNode := tvMenu.GetNodeAt(X,Y);

  Accept := (not cbHide.Checked)
  and (CurrentMenuItemRec.miItemType in [IT_MenuItem, IT_Report, IT_SubMenu, IT_Separator]);
end;

procedure TfrmMenuDesigner.tvMenuDragDrop(Sender, Source: TObject; X,
  Y: Integer);
const
  DM_ABOVE_ITEM = 1;
  DM_INTO_FOLDER = 2;
  DM_ASK = 3;
var
  NewItem, OrigParentNode, MoveToNode : TTreeNode;
  OldMenuItemInfo : TMenuItemInfo;
  sOrigParentComponentName, OldText : string;
  dmMode, iDown : byte;

  function UpdateMovedRecord : boolean;
  var
    LToolRec : TToolRec;
    BTRec : TBTRec;
  begin{UpdateMovedRecord}
    Result := FALSE;
    // find record for the item we have just moved
    BTRec.KeyS := RT_MenuItem + BuildB50Index(TMenuItemInfo(CurrentNode.Data).MenuItemRec.miComponentName);
    BTRec.Status := BTFindRecord(BT_GetEqual, FileVar[ToolF], LToolRec, BufferSize[ToolF]
    , miIdxByComponentName, BTRec.KeyS);
    BTShowError(BTRec.Status, 'BTFindRecord', asAppDir + aFileNames[ToolF]);
    if BTRec.Status = 0 then
    begin
      // update record in table
      LToolRec.MenuItem := TMenuItemInfo(CurrentNode.Data).MenuItemRec;
      SetMenuItemIndexes(LToolRec);
      BTRec.Status := BTUpdateRecord(FileVar[ToolF], LToolRec, BufferSize[ToolF], miIdxByComponentName, BTRec.KeyS);
      BTShowError(BTRec.Status, 'BTUpdateRecord', asAppDir + aFileNames[ToolF]);
      Result := BTRec.Status = 0;
    end;{if}
  end;{UpdateMovedRecord}

  function NodeInNode(Node1, Node2 : TTreeNode) : boolean;
  begin{NodeInNode}
    if (Node2 = nil) or (Node1 = nil) then
    begin
      // no node to check - Node1 cannot be in Node2
      Result := FALSE;
      exit;
    end else
    begin
      if Node1 = Node2 then
      begin
        // the nodes are the same, so effectively are within each other !
        Result := TRUE;
        exit;
      end;{if}
    end;{if}

    if Node1.Parent = Node2 then Result := TRUE
    else Result := NodeInNode(Node1.Parent, Node2);
  end;{NodeInNode}

begin
  MoveToNode := tvMenu.GetNodeAt(X,Y);
  if (MoveToNode <> nil) and (tvMenu.Selected <> nil) then begin
//  MoveToNode.MoveTo(CurrentNode, naInsert);

   // Do not allow a folder to be put within itself
   if (CurrentNode.SelectedIndex in [II_UserMenu, II_UserMenuOpen])
   and NodeInNode(MoveToNode, CurrentNode) then Exit;

    // determine mode
    dmMode := DM_ABOVE_ITEM;
    if MoveToNode.SelectedIndex in [II_EnterpriseMenu, II_UserMenu
    , II_EnterpriseMenuOpen, II_UserMenuOpen]
    then begin
      if (trim(TMenuItemInfo(MoveToNode.Data).MenuItemRec.miParentComponentName) = '')
      and (not (CurrentNode.SelectedIndex in [II_UserMenu, II_UserMenuOpen]))
      then dmMode := DM_INTO_FOLDER
      else dmMode := DM_ASK;
    end;{if}

    // ask where to put the item you are moving
    if dmMode = DM_ASK then
    begin
      if MsgBox('Do you wish this item to be moved inside the selected menu ?'
      , mtConfirmation, [mbYes, mbNo], mbYes, 'Move Item') = mrYes
      then dmMode := DM_INTO_FOLDER
      else dmMode := DM_ABOVE_ITEM
    end;{if}

    if dmMode = DM_INTO_FOLDER then
    begin
      // move item into folder
{      iDown := 0;
      if (TMenuItemInfo(CurrentNode.Data).MenuItemRec.miParentComponentName
      = TMenuItemInfo(MoveToNode.Data).MenuItemRec.miParentComponentName)
      and (TMenuItemInfo(CurrentNode.Data).MenuItemRec.miPosition
      < (TMenuItemInfo(MoveToNode.Data).MenuItemRec.miPosition))
      then iDown := 1;}

      OrigParentNode := CurrentNode.Parent;

      CurrentNode.MoveTo(MoveToNode, naAddChild);

      sOrigParentComponentName := TMenuItemInfo(CurrentNode.Data).MenuItemRec.miParentComponentName;

      TMenuItemInfo(CurrentNode.Data).MenuItemRec.miParentComponentName
      := TMenuItemInfo(MoveToNode.Data).MenuItemRec.miComponentName;

      // re-jig the positions of all the other items in the removed item's parent
      DeleteItemAt(TMenuItemInfo(CurrentNode.Data).MenuItemRec.miPosition
      , sOrigParentComponentName);

      // re-jig the positions of all the other items in the removed item's parent
      TMenuItemInfo(CurrentNode.Data).MenuItemRec.miPosition := -1;

      if UpdateMovedRecord then
      begin

        // re-jig the positions of all the other items in the new parent item
{        InsertItemAt(MoveToNode.Count
        , TMenuItemInfo(MoveToNode.Parent.Data).MenuItemRec.miComponentName);}

        TMenuItemInfo(CurrentNode.Data).MenuItemRec.miPosition := MoveToNode.Count;

        if UpdateMovedRecord then
        begin
          // save old properties
  {        OldMenuItemInfo := TMenuItemInfo(CurrentNode.Data);
          OldText := CurrentNode.Text;

          // delete old node
          CurrentNode.Delete;

          // add item
          NewItem := tvMenu.Items.InsertObject(MoveToNode, OldText, OldMenuItemInfo);}

          // rejig object "position"s
          RefreshPositionsIn(OrigParentNode, tvMenu.Items);
          // refreshes all the info objects in a parent node
//          RefreshPositionsIn(MoveToNode.Parent, tvMenu.Items);
        end;{if}

        // select item
        tvMenuChange(tvMenu, tvMenu.selected);

      end;{if}
    end else
    begin
      // move item above selected item

      // do not allow options / reports / separators to be moved into the main menu
      if (not (CurrentNode.SelectedIndex in [II_UserMenu, II_UserMenuOpen]))
      and (trim(TMenuItemInfo(MoveToNode.Data).MenuItemRec.miParentComponentName) = '')
      then exit;

      // determine whether we are moving the item up or down
      iDown := 0;
      if (TMenuItemInfo(CurrentNode.Data).MenuItemRec.miParentComponentName
      = TMenuItemInfo(MoveToNode.Data).MenuItemRec.miParentComponentName)
      and (TMenuItemInfo(CurrentNode.Data).MenuItemRec.miPosition
      < (TMenuItemInfo(MoveToNode.Data).MenuItemRec.miPosition))
      then iDown := 1;

      OrigParentNode := CurrentNode.Parent;

      CurrentNode.MoveTo(MoveToNode, naInsert);

      sOrigParentComponentName := TMenuItemInfo(CurrentNode.Data).MenuItemRec.miParentComponentName;

      TMenuItemInfo(CurrentNode.Data).MenuItemRec.miParentComponentName
      := TMenuItemInfo(MoveToNode.Data).MenuItemRec.miParentComponentName;

      // re-jig the positions of all the other items in the removed item's parent
      DeleteItemAt(TMenuItemInfo(CurrentNode.Data).MenuItemRec.miPosition
      , sOrigParentComponentName);

      // re-jig the positions of all the other items in the removed item's parent
      TMenuItemInfo(CurrentNode.Data).MenuItemRec.miPosition := -1;

      if UpdateMovedRecord then
      begin

        // re-jig the positions of all the other items in the new parent item
        if MoveToNode.Parent = nil then
        begin
          InsertItemAt(TMenuItemInfo(MoveToNode.Data).MenuItemRec.miPosition -iDown
          , '');
        end else
        begin
          InsertItemAt(TMenuItemInfo(MoveToNode.Data).MenuItemRec.miPosition -iDown
          , TMenuItemInfo(MoveToNode.Parent.Data).MenuItemRec.miComponentName);
        end;{if}

        TMenuItemInfo(CurrentNode.Data).MenuItemRec.miPosition
        := TMenuItemInfo(MoveToNode.Data).MenuItemRec.miPosition -iDown;

        if UpdateMovedRecord then
        begin
          // save old properties
  {        OldMenuItemInfo := TMenuItemInfo(CurrentNode.Data);
          OldText := CurrentNode.Text;

          // delete old node
          CurrentNode.Delete;

          // add item
          NewItem := tvMenu.Items.InsertObject(MoveToNode, OldText, OldMenuItemInfo);}

          // rejig object "position"s
          RefreshPositionsIn(OrigParentNode, tvMenu.Items);
          // refreshes all the info objects in a parent node
          RefreshPositionsIn(MoveToNode.Parent, tvMenu.Items);
        end;{if}

        // select item
        tvMenuChange(tvMenu, tvMenu.selected);

      end;{if}
    end;{if}
  end;{if}
end;

procedure TfrmMenuDesigner.tvMenuExpanded(Sender: TObject;
  Node: TTreeNode);
begin
  if Node.SelectedIndex = II_UserMenu then
  begin
    Node.SelectedIndex := II_UserMenuOpen;
    Node.ImageIndex := II_UserMenuOpen;
  end;{if}

  if Node.SelectedIndex = II_EnterpriseMenu then
  begin
    Node.SelectedIndex := II_EnterpriseMenuOpen;
    Node.ImageIndex := II_EnterpriseMenuOpen;
  end;{if}
end;

procedure TfrmMenuDesigner.tvMenuCollapsed(Sender: TObject;
  Node: TTreeNode);
begin
  if Node.SelectedIndex = II_UserMenuOpen then
  begin
    Node.SelectedIndex := II_UserMenu;
    Node.ImageIndex := II_UserMenu;
  end;{if}

  if Node.SelectedIndex = II_EnterpriseMenuOpen then
  begin
    Node.SelectedIndex := II_EnterpriseMenu;
    Node.ImageIndex := II_EnterpriseMenu;
  end;{if}
end;

procedure TfrmMenuDesigner.ExpandAll1Click(Sender: TObject);
begin
  screen.Cursor := crHourglass;
  tvMenu.FullExpand;
  screen.Cursor := crDefault;
end;

procedure TfrmMenuDesigner.CollapseAll1Click(Sender: TObject);
begin
  screen.Cursor := crHourglass;
  tvMenu.FullCollapse;
  screen.Cursor := crDefault;
end;

procedure TfrmMenuDesigner.btnDeleteClick(Sender: TObject);
var
  LToolRec : TToolRec;
  BTRec : TBTRec;

  procedure DeleteAllMenuItemsIn(Node : TTreeNode);

    procedure DeleteItem(LNode : TTreeNode);
    begin{DeleteItem}
      // find record
      BTRec.KeyS := RT_MenuItem
      + BuildA10Index(BTFullNomKey(TMenuItemInfo(LNode.Data).MenuItemRec.miFolioNo)
      + IDX_DUMMY_CHAR);
      BTRec.Status := BTFindRecord(BT_GetEqual, FileVar[ToolF], LToolRec, BufferSize[ToolF]
      , miIdxByFolio, BTRec.KeyS);
      if (BTRec.Status = 0) then
      begin
        // delete record
        BTRec.Status := BTDeleteRecord(FileVar[ToolF], LToolRec, BufferSize[ToolF], miIdxByFolio);
        BTShowError(BTRec.Status, 'BTDeleteRecord', asAppDir + aFileNames[ToolF]);

        if (BTRec.Status = 0) then
        begin
          // delete all related records
          RemoveAllCompanies(TMenuItemInfo(LNode.Data).MenuItemRec.miFolioNo);
          RemoveAllUsers(TMenuItemInfo(LNode.Data).MenuItemRec.miFolioNo);

          // re-jig the positions of all the other items in the parent
          DeleteItemAt(TMenuItemInfo(LNode.Data).MenuItemRec.miPosition
          , TMenuItemInfo(LNode.Data).MenuItemRec.miParentComponentName);

          ParentItem := LNode.Parent;

          // update tree
          TMenuItemInfo(LNode.Data).Free;
          LNode.Delete;

          // rejig object "position"s
          RefreshPositionsIn(ParentItem, tvMenu.Items);

        end;{if}
      end;{if}
    end;{DeleteItem}

  begin{DeleteAllMenuItemsIn}
    While Node.Count > 0 do
    begin
      case TMenuItemInfo(Node.Item[0].Data).MenuItemRec.miItemType of
        IT_MenuItem, IT_Report, IT_Separator : DeleteItem(Node.Item[0]);
        IT_SubMenu : begin
          DeleteAllMenuItemsIn(Node.Item[0]);
        end;
      end;{case}
    end;{while}
    DeleteItem(Node);
  end;{DeleteAllMenuItemsIn}

var
  sMessage : string;

begin
  if TMenuItemInfo(CurrentNode.Data).MenuItemRec.miItemType = IT_SubMenu
  then sMessage := 'Are you sure you want to delete this menu ?'#13#13
  + 'Deleting this menu will also delete all items within it.'
  else sMessage := 'Are you sure you want to delete this item ?';

  if (MsgBox(sMessage,mtConfirmation,[mbYes, mbNo],mbNo, 'Delete Item') = mrYes) then
  begin
    DeleteAllMenuItemsIn(CurrentNode);

    // select item
    tvMenuChange(tvMenu, tvMenu.selected);
  end;{if}
end;

procedure TfrmMenuDesigner.UpdateInfoPanel;
begin
  lbInfo.Items.Clear;
  lbInfo.Items.Add('Comp: ' + CurrentMenuItemRec.miComponentName);
  lbInfo.Items.Add('ParComp: ' + CurrentMenuItemRec.miParentComponentName);
  lbInfo.Items.Add('Folio: ' + IntToStr(CurrentMenuItemRec.miFolioNo));
  lbInfo.Items.Add('Position: ' + IntTostr(CurrentMenuItemRec.miPosition));

{  MsgBox(CurrentMenuItemRec.miComponentName + #13#13
  + CurrentMenuItemRec.miParentComponentName  + #13#13
  + 'Folio:' + IntToStr(CurrentMenuItemRec.miFolioNo)  + #13#13
  + 'Position:' + IntTostr(CurrentMenuItemRec.miPosition)
  ,mtInformation, [mbOK],mbOK,'ITEM INFO');}
end;

procedure TfrmMenuDesigner.edPathChange(Sender: TObject);
Var
  RegO   : TRegistry;
  TmpStr : ShortString;
begin
  if (Trim(edStart.Text) = '') then edStart.Text := ExtractFilePath(edPath.Text);

  If FileExists (edPath.Text) Then Begin
    RegO := TRegistry.Create;
    Try
      RegO.RootKey := HKEY_CLASSES_ROOT;

      { Open association details for extension }
      If RegO.OpenKey(ExtractFileExt(edPath.Text), False) Then Begin
        { defaults are stored as null strings }
        If RegO.KeyExists('') Then Begin
          { Get redirection string and check it exists in the classes }
          TmpStr := RegO.ReadString('');

          { Close initial entry and open redirection entry }
          RegO.CloseKey;
          If RegO.KeyExists(TmpStr) Then Begin
            If RegO.OpenKey(TmpStr, False) Then Begin
              lblTargType.Caption := RegO.ReadString('');
            End { If }
            Else Begin
              lblTargType.Caption := TmpStr;
            End; { Else }
          End { If RegO.KeyExists(RegO.ReadString('')) }
          Else Begin
            lblTargType.Caption := TmpStr;
          End; { Else }
        End { If RegO.KeyExists(ExtractFileExt(edPath.Text)) }
        Else Begin
          lblTargType.Caption := 'Unknown';
        End; { Else }
      End { If RegObj.OpenKey(ExtractFileExt(edPath.Text)) }
      Else Begin
        lblTargType.Caption := 'Unknown';
      End; { Else }

      RegO.CloseKey;
    Finally
      RegO.Destroy;
    End;
  End { If FileExists (edPath.Text) }
  Else Begin
    { No valid file specified }
    lblTargType.Caption := '';
  End; { Else }
end;

procedure TfrmMenuDesigner.btnBrowseStartClick(Sender: TObject);
begin
  if FileExists(edStart.Text) then dlgOpen.FileName := edStart.Text;
  if dlgOpen.Execute then
  begin
    edStart.Text := ExtractFilePath(dlgOpen.FileName);
  end;{if}
end;

procedure TfrmMenuDesigner.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(nil, Self.Name, tvMenu) of
    mrOK : oSettings.ColorFieldsFrom(tvMenu, Self);
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
//      oSettings.RestoreListDefaults(mlProducts, Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmMenuDesigner.SaveCoordinates1Click(Sender: TObject);
begin
  bSaveCoordinates := not bSaveCoordinates;
  TMenuItem(Sender).Checked := bSaveCoordinates;
end;

procedure TfrmMenuDesigner.pmPopupMenuPopup(Sender: TObject);
begin
  SaveCoordinates1.Checked := bSaveCoordinates;
  ExpandAll1.enabled := tvMenu.Enabled;
  CollapseAll1.enabled := tvMenu.Enabled;
end;

procedure TfrmMenuDesigner.SaveAllSettings;
begin
  oSettings.SaveParentFromControl(tvMenu, Self.Name);
//  oSettings.SaveList(mlProducts, Self.Name);
  if bSaveCoordinates then oSettings.SaveForm(Self);
end;

procedure TfrmMenuDesigner.LoadAllSettings;
begin
  sMiscDirLocation := GetEnterpriseDirectory;
  oSettings.LoadForm(Self);
  oSettings.LoadParentToControl(Self.Name, Self.Name, tvMenu);
  oSettings.ColorFieldsFrom(tvMenu, Self);
//  oSettings.LoadList(mlProducts, Self.Name);
end;


end.
