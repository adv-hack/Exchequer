unit FaxStat;

{ nfrewer440 10:19 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Buttons, SBSPanel, ExtCtrls, Grids, Outline, DirOutln, StdCtrls,
  VarConst, FaxUtils, AdFax, AdTapi, OoMisc, AdPort, {AdModem,} Menus,
  AdFStat, TEditVal, FaxClass, ImgList, APIUtil, BTSupU1, ActnList
  ,ViewMain, ViewOld, ChangeNo, FileUtil;

type
  TFaxInfo = Class
    FaxFile : string;
    constructor Create(sFileName : string);
  end;{TFaxInfo}

  TfrmFaxStatus = class(TForm)
    imgFolders: TImageList;
    pnlClient: TSBSPanel;
    lvwFaxQueue: TListView;
    pnlLeft: TSBSPanel;
    mnuFaxQueue: TPopupMenu;
    mnuPopupDelete: TMenuItem;
    mnuPopupChangePriority1: TMenuItem;
    mnuPopupChangePriority2: TMenuItem;
    mnuPopupChangePriority3: TMenuItem;
    mnuSeparator: TMenuItem;
    mnuPopupSelectAll: TMenuItem;
    tvwFaxDirs: TTreeView;
    sbrDescription: TStatusBar;
    sbrCurFaxDirectory: TStatusBar;
    ViewFax2: TMenuItem;
    ActionList1: TActionList;
    View1: TAction;
    N1: TMenuItem;
    ChangeFaxNo1: TMenuItem;
    Hold1: TMenuItem;
    ilFaxes: TImageList;
    Delete1: TAction;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure tvwFaxDirsCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure lvwFaxQueueKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mnuPopupSelectAllClick(Sender: TObject);
    procedure ChangePriorityClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure tvwFaxDirsChange(Sender: TObject; Node: TTreeNode);
    procedure mnuFaxQueuePopup(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure View1Execute(Sender: TObject);
    procedure Hold1Click(Sender: TObject);
    procedure Delete1Execute(Sender: TObject);
    procedure ChangeFaxNo1Click(Sender: TObject);
    procedure lvwFaxQueueKeyPress(Sender: TObject; var Key: Char);
    procedure tvwFaxDirsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvwFaxDirsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvwFaxQueueStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure lvwFaxQueueChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lvwFaxQueueColumnClick(Sender: TObject; Column: TListColumn);
  private
    fFaxListStatus : TFaxStatus;
    bListIsFilling, bEnabledPopup : boolean;
    sFaxServerRoot, sFaxSubDir : string;
    aColWidths : array[0..5] of integer;


    procedure InitialiseTreeView;
    procedure DeleteAPFFile(APFName : string);
    procedure UpdateListView(NewStatus : TFaxStatus);
    procedure RefreshListViewColumns;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    function HoldFax(APFName : string; bHold : boolean) : boolean;
    procedure AfterServerParamsRead;
    procedure CheckCols;
    function AllSelectedFilesExist : boolean;
    procedure StoreColWidths;
    procedure ShowOldFax(const AFilename : string);
  public
    procedure RefreshListView;
end;

{var}

implementation

uses
  UFaxBtrv, AdExcept, GlobVar, BtrvU2, RPDevice, Main;

{$R *.DFM}
(*{$R FOLDER.RES}  // Folder images for the TreeView*)

type
  TMasterSource = (msrBtrieve, msrFaxFiles);


{TFaxInfo}
constructor TFaxInfo.Create(sFileName : string);
begin
  inherited create;
  FaxFile := sFileName;
end;

procedure TfrmFaxStatus.RefreshListView;
var
  FillFaxStatus : TFaxStatus;
  iNoOfFaxes : integer;

  procedure ReadFaxInfo;
  // Action : Displays all the faxes in a particular directory determined by fFaxListStatus
  //          into the list view
    procedure ProcessFaxInfo(APFName : string);
    var
      Details : PFaxDetails;
      NewItem : TListItem;
      FoundFaxInfo : boolean;
    begin{ProcessFaxInfo}
      new(Details);
      FillChar(Details^,SizeOf(Details^),#0);
      FoundFaxInfo := FindFaxDetails(APFName,'A',Details);
      with Details^, lvwFaxQueue do begin
        if FoundFaxInfo and (not Details^.FaxCancel) and ((UpperCase(FaxUserName)
        = UpperCase(sFilter)) or ((AppMode = amAdmin) and (sFilter = 'All Users')))
        then begin
          inc(iNoOfFaxes);
          NewItem := Items.Add;
          with NewItem do begin
            if FoundFaxInfo then Caption := FaxUserDesc
            else Caption := '*** UNKNOWN ***';

            Data := TFaxInfo.Create(ExtractFileName(APFName));
            if FoundFaxInfo then begin
              SubItems.Add(FaxNumber);
              SubItems.Add(FaxSenderName);
              SubItems.Add(FaxRecipientName);
            end;{if}

            if fFaxListStatus in [fxsArchive, fxsFail] then SubItems.Add(DateTimeToStr(FaxFinishTime));
            if fFaxListStatus = fxsFail then SubItems.Add(ErrorMsg(FaxErrorCode));

            if (FileGetAttr(APFName) and faHidden) <> 0 then ImageIndex := 3
            else if FaxHold then ImageIndex := 2
                 else if (FaxBusyRetries > 0) then ImageIndex := 1
                      else ImageIndex := 0;

          end; // with
        end; // with
      end;{with}
      dispose(Details);
      sbrCurFaxDirectory.SimpleText := 'Contents of ' + tvwFaxDirs.Selected.Text + ' (' + IntToStr(iNoOfFaxes) + ' Fax';
      if iNoOfFaxes = 1 then sbrCurFaxDirectory.SimpleText := sbrCurFaxDirectory.SimpleText + ')'
      else sbrCurFaxDirectory.SimpleText := sbrCurFaxDirectory.SimpleText + 'es)';
    end;{ProcessFaxInfo}
  var
    SearchRec : TSearchRec;
    OK : boolean;
  {  slFiles : TStringList;
    iPos : integer;}
  begin{ReadFaxInfo}
    iNoOfFaxes := 0;
    OK := FindFirst(IncludeTrailingBackslash(fFaxDirs[fFaxListStatus])+ '*' + FIND_EXT
    , faAnyFile, SearchRec) = 0;
    while OK and (fFaxListStatus = FillFaxStatus) do begin
      ProcessFaxInfo(IncludeTrailingBackslash(fFaxDirs[fFaxListStatus]) + SearchRec.Name);
      OK := FindNext(SearchRec) = 0;
      Application.ProcessMessages;
    end;{while}
    FindClose(SearchRec);

  (*  slFiles := TStringList.Create;

    ShowMessage('1');
    OK := FindFirst(IncludeTrailingBackslash(fFaxDirs[fFaxListStatus])+ '*' + APF_EXT
    , faAnyFile, SearchRec) = 0;
    while OK do begin
      slFiles.Add(IncludeTrailingBackslash(fFaxDirs[fFaxListStatus]) + SearchRec.Name);
      OK := FindNext(SearchRec) = 0;
    end;{while}
    ShowMessage('2');

    For iPos := 0 to (slFiles.Count - 1) do begin
      ProcessFaxInfo(slFiles[iPos]);
      OK := FindNext(SearchRec) = 0;
    end;{for}
    ShowMessage('3');

    FindClose(SearchRec);*)
  end;{ReadFaxInfo}

begin{RefreshListView}
  bListIsFilling := TRUE;
  FillFaxStatus := TFaxStatus(tvwFaxDirs.Selected.Data);
  tvwFaxDirs.Items.item[0].text := 'Faxes for ' + sFilter;
  tvwFaxDirs.Refresh;
  with lvwFaxQueue do begin
    Items.BeginUpdate;
    Items.Clear;
    Items.EndUpdate;

    RefreshListViewColumns;
    if fFaxListStatus <> fxsUnknown then
      begin
        ReadFaxInfo;
{        sbrCurFaxDirectory.SimpleText := 'Contents of ' + tvwFaxDirs.Selected.Text;}
      end
    else sbrCurFaxDirectory.SimpleText := '';
    CheckCols;
  end;{with}
  bListIsFilling := FALSE;
end;


{TfrmFaxStatus}
procedure TfrmFaxStatus.InitialiseTreeView;
// Action : Populates tree view tvwFaxDirs with fax sub directory names from fFaxDirs
var
  NewNode, CurTreeNode : TTreeNode;
  i : TKnownFaxStatus;
  j : integer;
  TreeViewEnabled : boolean;
begin
  with tvwFaxDirs, Items do
  begin
    // Use pointer to store the enumerated type each directory represents
{    AddObject(tvwFaxDirs.Selected, LastSubDir(fCurFaxParams^.FaxServerRoot), Pointer(fxsUnknown));}
    AddObject(tvwFaxDirs.Selected, LastSubDir(sFaxServerRoot), Pointer(fxsUnknown));

    TreeViewEnabled := false;
    CurTreeNode := Items[0];
    for i := Low(TKnownFaxStatus) to High(TKnownFaxStatus) do begin
      if fFaxDirs[i] <> '' then begin
        TreeViewEnabled := true;
        NewNode := AddChildObject(CurTreeNode, LastSubDir(fFaxDirs[i]), Pointer(i));
      end;{if}
    end;{for}

    Items[0].ImageIndex := 2;
    for j := 1 to pred(Items.Count) do Items[j].SelectedIndex := 2;
    FullExpand;
  end; // with
  tvwFaxDirs.Enabled := TreeViewEnabled;
end; // TfrmFaxStatus.InitialiseTreeView

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.tvwFaxDirsCollapsing(Sender: TObject;
  Node: TTreeNode; var AllowCollapse: Boolean);
begin
  AllowCollapse := false;
end;

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.RefreshListViewColumns;
type
  TStatusColumns = record
    Caption : string;
    Width : TWidth;
  end;

const
  LAST_FIXED_COLUMN = 3;  // All status queues share columns 0 to 3
  FIXED_COLS : array[0..LAST_FIXED_COLUMN] of TStatusColumns =
    ((Caption : 'Document'; Width : ColumnHeaderWidth),
    (Caption : 'Fax Number'; Width : 90),
    (Caption : 'Sender'; Width : ColumnHeaderWidth),
    (Caption : 'Recipient'; Width : ColumnHeaderWidth));

var
  i : byte;
  NewColumn : TListColumn;

begin
  with lvwFaxQueue.Columns do begin
    BeginUpdate;
    Clear;
    if fFaxListStatus <> fxsUnknown then begin
      for i := 0 to LAST_FIXED_COLUMN do begin
        NewColumn := Add;
        NewColumn.Caption := FIXED_COLS[i].Caption;
        NewColumn.Width := aColWidths[i];
      end;{for}
    end;{if}

    case fFaxListStatus of
      fxsArchive : begin
        NewColumn := Add;
        NewColumn.Caption := 'Finished at';
        NewColumn.Width := aColWidths[4];
      end;{if}

      fxsFail : begin
        NewColumn := Add;
        NewColumn.Caption := 'Failed at';
        NewColumn.Width := aColWidths[4];

        NewColumn := Add;
        NewColumn.Caption := 'Error';
        NewColumn.Width := aColWidths[5];
      end;
    end;{case}

    EndUpdate;
  end; // with
end; // RefreshListViewColumns

//-----------------------------------------------------------------------

{procedure TfrmFaxStatus.RefreshListView;
begin
end; // TfrmFaxStatus.RefreshListView}

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.FormCreate(Sender: TObject);
begin
  // Loads folder bitmaps from FOLDER.RES - resource compiled from FldrShut.BMP &
  // FldrOpen.BMP in Delphi's Images\Buttons directory
  // Image 0 = coloured closed folder
  // Image 2 = coloured open folder

  sFaxServerRoot := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));

  aColWidths[0] := 150;
  aColWidths[1] := 100;
  aColWidths[2] := 100;
  aColWidths[3] := 100;
  aColWidths[4] := 120;
  aColWidths[5] := 150;

{ imgFolders.ResourceLoad(rtBitmap,'FLDRSHUT', clPurple);
  imgFolders.ResourceLoad(rtBitmap,'FLDROPEN', clPurple);}

  tvwFaxDirs.Enabled := false;
  AfterServerParamsRead;

end; // TfrmFaxStatus.FormCreate

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.lvwFaxQueueKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    vk_Delete : if lvwFaxQueue.SelCount > 0 then Delete1Execute(Self);
    vk_F5 : begin
      StoreColWidths;
      RefreshListView;
    end;
  end;{case}
end;

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.DeleteAPFFile(APFName : string);
// Pre    : APFName = Fully qualified name of APF file
// Action : Deletes physical APF file and associated Btrieve record
var
  LockPos : longint;
  CurFaxDetails : PFaxDetails;
begin
  DeleteFile(APFName);

  new(CurFaxDetails);
  if FindAndLockFaxDetails(APFName, 'A', CurFaxDetails, LockPos) then DeleteFaxDetails('A');
  dispose(CurFaxDetails);
end; // TfrmFaxStatus.DeleteAPFFile

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.mnuPopupSelectAllClick(Sender: TObject);
var
  i : integer;
begin
  with lvwFaxQueue do begin
    Items.BeginUpdate;
    for i := 0 to Items.Count -1 do begin
      Items[i].Selected := true;
      Items[i].Update;
    end;{for}
    Items.EndUpdate;
    Refresh;
  end;{with}
end;

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.ChangePriorityClick(Sender: TObject);
// Action : Calls UpdateListView with the appropriate new status to change to
var
  NewStatus : TFaxStatus;
begin
  if AllSelectedFilesExist then
    begin
      if Sender = mnuPopupChangePriority1 then
        begin
          case fFaxListStatus of
            fxsNormal, fxsOffpeak, fxsArchive, fxsFail : NewStatus := fxsUrgent;
            fxsUrgent : NewStatus := fxsNormal;
          end;{case}
        end
      else begin
        if Sender = mnuPopupChangePriority2 then
          begin
            case fFaxListStatus of
              fxsNormal, fxsUrgent : NewStatus := fxsOffpeak;
              fxsOffpeak, fxsArchive, fxsFail : NewStatus := fxsNormal;
            end;{case}
          end
        else begin
          if Sender = mnuPopupChangePriority3 then NewStatus := fxsOffPeak;
        end;{if}
      end;{if}
      UpdateListView(NewStatus);
    end
  else RefreshListView;
end; // TfrmFaxStatus.ChangePriorityClick

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.UpdateListView(NewStatus : TFaxStatus);
// Action : Iterates through all faxes selected in the list view.
//          If NewStatus = fxsUnknown they are deleted, otherwise they are
//          moved to the new directory that represents that status.
var
  CurFaxDetails : PFaxDetails;
  LockPos, Posn : integer;
  APFName : string;
  bRefresh : boolean;
begin
  bRefresh := FALSE;
  with lvwFaxQueue do begin
    Posn := 0;
    while Posn < Items.Count do begin
      if Items[Posn].Selected then
        begin
          APFName := IncludeTrailingBackslash(fFaxDirs[fFaxListStatus])+ TFaxInfo(Items[Posn].Data).FaxFile;
          if FileExists(APFName) and ((FileGetAttr(APFName) and faHidden) = 0) then
            begin
              if NewStatus = fxsUnknown then DeleteAPFFile(APFName)
              else begin
                if fFaxDirs[NewStatus] <> '' then begin

                  {moves the APF file}
                  RenameFile(APFName,IncludeTrailingBackslash(fFaxDirs[NewStatus])+ExtractFileName(APFName));

                  {takes off any busy retries if you have just moved a fax to urgent}
                  if NewStatus = fxsUrgent then begin
                    new(CurFaxDetails);
                    if FindAndLockFaxDetails(APFName, 'A', CurFaxDetails, LockPos) then begin
                      CurFaxDetails^.FaxBusyRetries := 0;
                      UpdateFaxDetails('A', CurFaxDetails, LockPos);
                    end;{if}
                    dispose(CurFaxDetails);
                  end;{if}

                end;{if}
              end;{if}
              TFaxInfo(Items[Posn].Data).Free;
              Items[Posn].Delete;
            end
          else bRefresh := TRUE;
        end
      else inc(Posn);
    end;{while}
  end; // with
  if bRefresh then RefreshListView;
end; // TfrmFaxStatus.UpdateListView

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.mnuExitClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.tvwFaxDirsChange(Sender: TObject; Node: TTreeNode);
begin
  sbrCurFaxDirectory.SimpleText := '';
  fFaxListStatus := TFaxStatus(tvwFaxDirs.Selected.Data);
  if lvwFaxQueue.items.count > 0 then StoreColWidths;
  RefreshListView;
end;

procedure TfrmFaxStatus.mnuFaxQueuePopup(Sender: TObject);
var
  First2Visible, LastVisible, SeparatorVisible : boolean;
  Caption1, Caption2, Caption3 : string;
  i : integer;
begin
  ViewFax2.Visible := bEnabledPopup;
  mnuPopupDelete.Visible := bEnabledPopup;
  mnuPopupChangePriority1.Visible := bEnabledPopup;
  mnuPopupChangePriority2.Visible := bEnabledPopup;
  mnuPopupChangePriority3.Visible := bEnabledPopup;
  Hold1.Visible := bEnabledPopup;
  mnuPopupSelectAll.Visible := bEnabledPopup;
  ChangefaxNo1.Visible := bEnabledPopup;

  if not bEnabledPopup then Exit;

  mnuPopupDelete.Visible := TRUE;
  mnuPopupSelectAll.Visible := TRUE;
  ViewFax2.Visible := TRUE;

  if fFaxListStatus = fxsUnknown then
    begin
      mnuFaxQueue.AutoPopup := false;
      exit;
    end
  else mnuFaxQueue.AutoPopup := true;

  Hold1.Visible := TRUE;
  ChangeFaxNo1.Visible := TRUE;
  First2Visible := true;
  LastVisible := false;
  SeparatorVisible := true;
  Caption3 := '';
  case fFaxListStatus of
    fxsUrgent : begin
      Caption1 := 'Move to &Normal';
      Caption2 := 'Move to &Off peak';
    end;

    fxsNormal : begin
      Caption1 := 'Move to &Urgent';
      Caption2 := 'Move to &Off peak';
    end;

    fxsOffpeak : begin
      Caption1 := 'Move to &Urgent';
      Caption2 := 'Move to &Normal';
    end;

    fxsFail, fxsArchive : begin
      Caption1 := 'Move to &Urgent';
      Caption2 := 'Move to &Normal';
      Caption3 := 'Move to &Off peak';
      Hold1.Visible := FALSE;
      ChangeFaxNo1.Visible := FALSE;
      LastVisible := true;
    end;

    else begin
      Caption1 := '';
      Caption2 := '';
      First2Visible := false;
      SeparatorVisible := false;
    end;
  end; // case

  with mnuFaxQueue do begin
    for i := 0 to Items.Count -1 do begin
      if Items[i] = mnuPopupChangePriority1 then
        begin
          Items[i].Caption := Caption1;
          Items[i].Visible := First2Visible;
        end
      else begin
        if Items[i] = mnuPopupChangePriority2 then
          begin
            Items[i].Caption := Caption2;
            Items[i].Visible := First2Visible;
          end
        else begin
          if Items[i] = mnuPopupChangePriority3 then
            begin
              Items[i].Caption := Caption3;
              Items[i].Visible := LastVisible;
            end
          else begin
            if Items[i] = mnuSeparator then Items[i].Visible := SeparatorVisible;
          end;{if}
        end;{if}
      end;{if}
    end;{for}
  end;{with}

  with lvwFaxQueue do begin
    ViewFax2.Enabled := Selected <> nil;
    mnuPopupDelete.Enabled := Selected <> nil;
    mnuPopupChangePriority1.Enabled := Selected <> nil;
    mnuPopupChangePriority2.Enabled := Selected <> nil;
    mnuPopupChangePriority3.Enabled := Selected <> nil;
    Hold1.Enabled := Selected <> nil;
    mnuPopupSelectAll.Enabled := (Items.Count > 0)
    and (Items.Count <> SelCount);
    if Selected <> nil then begin
      if (Selected.ImageIndex = 2) then Hold1.Caption := '&Resume'
      else Hold1.Caption := '&Hold';
    end;{if}
    ChangefaxNo1.Enabled := SelCount = 1;
  end;{with}
end;

procedure TfrmFaxStatus.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
  SendMessage(TForm(Owner).Handle,WM_FormCloseMsg,1,0);
end;

procedure TfrmFaxStatus.View1Execute(Sender: TObject);
var
  iItem : integer;
  bRefresh : boolean;
begin
  Screen.Cursor := crHourglass;
  bRefresh := FALSE;
  with lvwFaxQueue do begin
    For iItem := 0 to (Items.Count - 1) do begin
      if Items[iItem].Selected then begin
        sDocName := Items[iItem].Caption;
        sFileName := sFaxSubDir + tvwFaxDirs.Selected.text + '\' + TFaxInfo(Items[iItem].Data).FaxFile;
        if FileExists(sFileName) and ((FileGetAttr(sFileName) and faHidden) = 0)
        then
        begin
          if UpperCase(ExtractFileExt(sFilename)) = OLD_APF_EXT then
             frmViewOldFax := TfrmViewOldFax.Create(Self)
          else
          begin
            frmViewFax := TfrmViewFax.Create(Self);
            frmViewFax.OpenFile(sFilename);
          end;
        end
        else bRefresh := TRUE;
      end;{if}
    end;{for}
  end;{with}
  if bRefresh then RefreshListView;
  Screen.Cursor := crDefault;
end;

procedure TfrmFaxStatus.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 300;
    ptMinTrackSize.Y := 200;
  end;{with}
  Message.Result := 0;
  inherited;
end;

procedure TfrmFaxStatus.Hold1Click(Sender: TObject);
var
  Posn : integer;
  bRefresh, bBusyRetry, bHold : boolean;
  sFile : string;
begin
  bRefresh := FALSE;
  with lvwFaxQueue do begin
    Posn := 0;
    if Selected <> nil then bHold := Selected.ImageIndex <> 2;
    while Posn < Items.Count do begin
      if Items[Posn].Selected then begin
        sFile := IncludeTrailingBackslash(fFaxDirs[fFaxListStatus]) + TFaxInfo(Items[Posn].Data).FaxFile;
        if FileExists(sFile) and ((FileGetAttr(sFile) and faHidden) = 0) then
          begin
            bBusyRetry := HoldFax(sFile, bHold);
            if bHold then Items[Posn].ImageIndex := 2
            else begin
              if bBusyRetry then Items[Posn].ImageIndex := 1
              else Items[Posn].ImageIndex := 0;
            end;{if}
          end
        else bRefresh := TRUE;
      end;{if}
      inc(Posn);
    end;{while}
  end; // with
  if bRefresh then RefreshListView;
end;

procedure TfrmFaxStatus.Delete1Execute(Sender: TObject);
var
  sMessage : string;
begin
  if AllSelectedFilesExist then
    begin
      if lvwFaxQueue.SelCount > 1 then sMessage := 'Are you sure you want to delete these faxes ?'
      else sMessage := 'Are you sure you want to delete this fax ?';
      if (msgBox(sMessage, mtConfirmation, [mbYes, mbNo], mbNo, 'Delete Fax') = mrYes)
      then UpdateListView(fxsUnknown);
    end
  else RefreshListView;
end;

function TfrmFaxStatus.HoldFax(APFName : string; bHold : boolean): boolean;
var
  LockPos : longint;
  CurFaxDetails : PFaxDetails;
begin
  new(CurFaxDetails);
  if FindAndLockFaxDetails(APFName, 'A', CurFaxDetails, LockPos) then begin
    CurFaxDetails.FaxHold := bHold;
    UpdateFaxDetails('A', CurFaxDetails, LockPos);
  end;{if}
  Result := CurFaxDetails^.FaxBusyRetries > 0;
  dispose(CurFaxDetails);
end;


procedure TfrmFaxStatus.ChangeFaxNo1Click(Sender: TObject);
var
  frmChangeNo : TfrmChangeNo;
  LockPos : longint;
  CurFaxDetails : PFaxDetails;
  sFile : string;
begin
  sFile := IncludeTrailingBackslash(fFaxDirs[fFaxListStatus]) + TFaxInfo(lvwFaxQueue.Selected.Data).FaxFile;
  if FileExists(sFile) and ((FileGetAttr(sFile) and faHidden) = 0) then
    begin
      try
        frmChangeNo := TfrmChangeNo.Create(Self);
        with frmChangeNo do begin
          EdFaxNo.Text := lvwFaxQueue.Selected.SubItems[0];
          if frmChangeNo.ShowModal = mrOK then begin
            new(CurFaxDetails);
            if FindAndLockFaxDetails(sFile, 'A', CurFaxDetails, LockPos) then begin
              CurFaxDetails.FaxNumber := EdFaxNo.Text;
              UpdateFaxDetails('A', CurFaxDetails, LockPos);
            end;{if}
            dispose(CurFaxDetails);
            lvwFaxQueue.Selected.SubItems[0] := EdFaxNo.Text;
          end;{if}
        end;{with}
      finally
        frmChangeNo.Release;
      end;{try}
    end
  else RefreshListView;
end;

procedure TfrmFaxStatus.AfterServerParamsRead;
// Action : Set properties of components on the form that are dependent on
//          fax set-up parameters
{  procedure SetFaxDirectories;
  // Post : fFaxDirs is populated with the fully qualified paths of all the
  //        sub-directories that physically exist below the fax root directory
  var
    SearchRec : TSearchRec;
    i : TKnownFaxStatus;
    sSubDir : string;
  begin
    FillChar(fFaxDirs,SizeOf(fFaxDirs),#0);
    for i := Low(TKnownFaxStatus) to High(TKnownFaxStatus) do begin
      sFaxSubDir := IncludeTrailingBackslash(fCurFaxParams^.FaxServerRoot);
      sFaxSubDir := sFaxServerRoot;

      sSubDir := sFaxSubDir + fCurFaxParams^.FaxSubDirs[i];
      if FindFirst(sSubDir, faDirectory, SearchRec) = 0 then fFaxDirs[i] := sSubDir;
      FindClose(SearchRec);
    end;{for}
{  end; // TfrmFaxStatus.SetFaxDirectories}
begin
  with fCurFaxParams^ do begin
    SetFaxDirectories(fFaxDirs, sFaxServerRoot);
    tvwFaxDirs.Items.Clear;
    InitialiseTreeView;
    fFaxListStatus := fxsUnknown;
{    RefreshListView;}
    tvwFaxDirs.Selected := tvwFaxDirs.Items[2];
  end; // with
end; // TfrmFaxStatus.ServerParamsOK


procedure TfrmFaxStatus.CheckCols;
var
  iCol : shortint;
begin
{  with lvwFaxQueue do begin
    for iCol := 0 to Columns.Count - 1 do begin
      iMinWidth := stringwidth(Column[iCol].Caption) + 15;
      Column[iCol].MinWidth := iMinWidth;
      Column[iCol].Width := ColumnTextWidth;
      Column[iCol].Width := ColumnHeaderWidth;
    end;{for}
{  end;{with}

  with lvwFaxQueue do begin
    for iCol := 0 to Columns.Count - 1 do begin
      Column[iCol].MinWidth := 50;
      Column[iCol].Width := aColWidths[iCol];
    end;{for}
  end;{with}
end;

procedure TfrmFaxStatus.lvwFaxQueueKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #1 then mnuPopupSelectAllClick(Self);
end;

procedure TfrmFaxStatus.tvwFaxDirsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  if (TFaxStatus(tvwFaxDirs.DropTarget.Data) = fxsUrgent)
  or ((fFaxListStatus = fxsUrgent) and (TFaxStatus(tvwFaxDirs.DropTarget.Data) = fxsNormal))
  then ChangePriorityClick(mnuPopupChangePriority1);

  if ((fFaxListStatus <> fxsUrgent) and (TFaxStatus(tvwFaxDirs.DropTarget.Data) = fxsNormal))
  or ((fFaxListStatus in [fxsUrgent, fxsNormal]) and (TFaxStatus(tvwFaxDirs.DropTarget.Data) = fxsOffPeak))
  then ChangePriorityClick(mnuPopupChangePriority2);

  if (fFaxListStatus in [fxsFail, fxsArchive])
  and (TFaxStatus(tvwFaxDirs.DropTarget.Data) = fxsOffPeak)
  then ChangePriorityClick(mnuPopupChangePriority3);
end;

procedure TfrmFaxStatus.tvwFaxDirsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := bEnabledPopup and (tvwFaxDirs.DropTarget <> nil) and
  (tvwFaxDirs.Selected <> tvwFaxDirs.DropTarget)
  and (TFaxStatus(tvwFaxDirs.DropTarget.Data) in [fxsNormal, fxsUrgent, fxsOffPeak]);
end;

procedure TfrmFaxStatus.lvwFaxQueueStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  with Sender as TListView do begin
    if SelCount > 1 then DragCursor := crMultiDrag
    else DragCursor := crDrag;
  end;{with}
end;

procedure TfrmFaxStatus.lvwFaxQueueChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  iPos : integer;
begin
  bEnabledPopup := (lvwFaxQueue.Selected <> nil);
  if bEnabledPopup then begin
    For iPos := 0 to (lvwFaxQueue.Items.Count - 1) do begin
      if (lvwFaxQueue.Items[iPos].ImageIndex = 3)
      and lvwFaxQueue.Items[iPos].Selected then bEnabledPopup := FALSE;
    end;{for}
  end;{if}
end;

function TfrmFaxStatus.AllSelectedFilesExist : boolean;
var
  iPos : integer;
  sFile : string;
begin
  Result := TRUE;
  for iPos := 0 to (lvwFaxQueue.Items.Count - 1) do begin
    sFile := IncludeTrailingBackslash(fFaxDirs[fFaxListStatus]) + TFaxInfo(lvwFaxQueue.Items[iPos].Data).FaxFile;
    if lvwFaxQueue.Items[ipos].Selected and ((not FileExists(sFile)) or ((FileGetAttr(sFile) and faHidden) <> 0)) then begin
      Result := FALSE;
      Break;
    end;{if}
  end;{for}
end;

procedure TfrmFaxStatus.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if bListIsFilling then CanClose := FALSE;
end;

procedure TfrmFaxStatus.lvwFaxQueueColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  showmessage('X');
end;

procedure TfrmFaxStatus.StoreColWidths;
var
  iCol : smallint;
begin
  with lvwFaxQueue do begin
    for iCol := 0 to Columns.Count - 1 do aColWidths[iCol] := Column[iCol].Width;
  end;{with}
end;

procedure TfrmFaxStatus.ShowOldFax(const AFilename: string);
begin
  RunApp(ExtractFilePath(Application.ExeName) + 'ViewFax.exe ' + AFilename, False);
end;

end.

