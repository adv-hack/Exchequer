unit SortViewOptionsF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, uMultiList, Menus,
  BtrvU2, GlobVar, VarConst, VarSortV, SortViewU;

type
  // A class to allow us to attach a SortView ID to each line in the multilist.
  TSortViewIDWrapper = class(TObject)
  private
    FID: Integer;
  public
    constructor Create(FromID: Integer);
    property ID: Integer read FID write FID;
  end;

  TSortViewOptionsFrm = class(TForm)
    SortViewList: TMultiList;
    panButtons: TPanel;
    ApplyBtn: TButton;
    CloseBtn: TButton;
    AddBtn: TButton;
    EditBtn: TButton;
    CopyBtn: TButton;
    DeleteBtn: TButton;
    DefaultBtn: TButton;
    PopupMenu1: TPopupMenu;
    Apply1: TMenuItem;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Copy1: TMenuItem;
    Delete1: TMenuItem;
    N1: TMenuItem;
    Properties1: TMenuItem;
    N2: TMenuItem;
    SaveCoordinates1: TMenuItem;
    SetAsDefault1: TMenuItem;
    procedure CloseBtnClick(Sender: TObject);
    procedure SortViewListCellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure FormDestroy(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure EditBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure DefaultBtnClick(Sender: TObject);
    procedure SortViewListChangeSelection(Sender: TObject);
    procedure SortViewListRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FSortView: TBaseSortView;
    DoneRestore: Boolean;
    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;
    procedure ClearList;
    procedure FillList(SelectDefault: Boolean = False);
    procedure OnError(ErrorMsg: string; ErrorCode: Integer);
    function SyncRecordPosition: Boolean;
    procedure SetSortView(const Value: TBaseSortView);
    procedure ApplyPermissions;
    procedure AlignButtons;
    procedure SetColoursAndPositions (const Mode : Byte);
    procedure WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure UpdateSortViewForComboBox;
  public
    { Public declarations }
    property SortView: TBaseSortView read FSortView write SetSortView;
  end;

var
  SortViewOptionsFrm: TSortViewOptionsFrm;

implementation

{$R *.dfm}

uses PWarnU, uSettings, UA_Const, SortViewConfigurationF, BtSupu2;

// =============================================================================
// TSortViewIDWrapper
// =============================================================================

constructor TSortViewIDWrapper.Create(FromID: Integer);
begin
  inherited Create;
  FID := FromID;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TSortViewOptionsFrm
// =============================================================================

procedure TSortViewOptionsFrm.AddBtnClick(Sender: TObject);
var
  ConfigDlg: TSortViewConfigurationFrm;
  FuncRes: Integer;
begin
  FillChar(SortViewRec, SizeOf(SortViewRec), #0);
  SortViewRec.svrListType := FSortView.ListType;
  SortViewRec.svrSorts[1].svsAscending := True;
  SortViewRec.svrSorts[2].svsAscending := True;
  ConfigDlg := TSortViewConfigurationFrm.Create(nil);
  try
    ConfigDlg.SortView := FSortView;
    ConfigDlg.Mode := svmAdd;
    ConfigDlg.ShowModal;
    if ConfigDlg.ModalResult = mrOk then
    begin
      FuncRes := FSortView.Add;
      if (FuncRes <> 0) then
        OnError('Failed to add Sort View record', FuncRes)
      else
      begin
        FillList;
      end;
    end;
  finally
    ConfigDlg.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.AlignButtons;
var
  i: Integer;
  x, y, w, h: Integer;
  Buttons: array[1..5] of TButton;
begin
  Buttons[1] := AddBtn;
  Buttons[2] := EditBtn;
  Buttons[3] := CopyBtn;
  Buttons[4] := DeleteBtn;
  Buttons[5] := DefaultBtn;
  x := ApplyBtn.Left;
  y := ApplyBtn.Top + ApplyBtn.Height + 3;
  w := ApplyBtn.Width;
  h := ApplyBtn.Height;
  for i := 1 to 5 do
  begin
    if (Buttons[i].Visible) then
    begin
      Buttons[i].SetBounds(x, y, w, h);
      y := y + h + 3;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.ApplyBtnClick(Sender: TObject);
begin
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.ApplyPermissions;
begin
{
  PChkAllowed_In()
  uaAddSortView    = 590;
  uaEditSortView   = 591;
  uaDeleteSortView = 592;
}
  AddBtn.Visible := PChkAllowed_In(uaAddSortView);
  EditBtn.Visible := PChkAllowed_In(uaEditSortView);
  CopyBtn.Visible := PChkAllowed_In(uaAddSortView);
  DeleteBtn.Visible := PChkAllowed_In(uaDeleteSortView);

  Add1.Visible    := AddBtn.Visible;
  Edit1.Visible   := EditBtn.Visible;
  Copy1.Visible   := CopyBtn.Visible;
  Delete1.Visible := DeleteBtn.Visible;
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.ClearList;
var
  i: Integer;
begin
  for i := 0 to SortViewList.ItemsCount - 1 do
  begin
    if (SortViewList.DesignColumns[0].Items.Objects[i] <> nil) then
    begin
      SortViewList.DesignColumns[1].Items.Objects[i].Free;
      SortViewList.DesignColumns[1].Items.Objects[i] := nil;
    end;
  end;
  SortViewList.ClearItems;
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.CopyBtnClick(Sender: TObject);
var
  ConfigDlg: TSortViewConfigurationFrm;
  FuncRes: Integer;
begin
  SortViewRec.svrDescr := 'COPY: ' + SortViewRec.svrDescr;
  ConfigDlg := TSortViewConfigurationFrm.Create(nil);
  try
    ConfigDlg.SortView := FSortView;
    ConfigDlg.Mode := svmAdd;
    ConfigDlg.ShowModal;
    if ConfigDlg.ModalResult = mrOk then
    begin
      FuncRes := FSortView.Add;
      if (FuncRes <> 0) then
        OnError('Failed to add Sort View record', FuncRes)
      else
      begin
        FillList;
      end;
    end;
  finally
    ConfigDlg.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.DefaultBtnClick(Sender: TObject);
var
  FuncRes: Integer;
begin
  FuncRes := FSortView.UserDefaults.Update(EntryRec.Login, SortViewRec.svrListType, SortViewRec.svrViewId);
  if (FuncRes <> 0) then
    raise Exception.Create('Unable to save Default View setting, error #' + IntToStr(FuncRes))
  else
    FillList;
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.DeleteBtnClick(Sender: TObject);
var
  FuncRes: Integer;
begin
  if MessageDlg('Delete ' + Trim(SortViewRec.svrDescr), mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    FuncRes := FSortView.Delete;
    if (FuncRes <> 0) then
    begin
      OnError('Failed to delete Sort View record', FuncRes);
    end
    else
      FillList;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.EditBtnClick(Sender: TObject);
var
  ConfigDlg: TSortViewConfigurationFrm;
  FuncRes: Integer;
  Addr: LongInt;
begin
//  if SyncRecordPosition then
  begin
    ConfigDlg := TSortViewConfigurationFrm.Create(nil);
    try
      ConfigDlg.Mode := svmEdit;
      ConfigDlg.SetDisplayProperties(SortViewList.Font, SortViewList.Columns[0].Color);
      FuncRes := GetPos(F[SortViewF], SortViewF, Addr);
      if (FuncRes = 0) then
      begin
        Move(Addr, SortViewRec, SizeOf(Addr));
        FuncRes := GetDirect(F[SortViewF], SortViewF, RecPtr[SortViewF]^, SVViewK, B_SingNWLock);
        if (FuncRes = 0) then
        begin
          ConfigDlg.SortView := FSortView;
          ConfigDlg.ShowModal;
          if ConfigDlg.ModalResult = mrOk then
          begin
            FuncRes := FSortView.Update;
            if (FuncRes <> 0) then
              OnError('Failed to update Sort View record', FuncRes)
            else
            begin
              FillList;
            end;
          end
          else
            UnLockMultiSing(F[SortViewF], SortViewF, Addr);
        end
        else
          OnError('Could not lock record for editing.', FuncRes);
      end
      else
        OnError('Could not get record for editing.', FuncRes);
    finally
      ConfigDlg.Free;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.FillList(SelectDefault: Boolean);
var
  FuncRes: LongInt;
  IncludeRecord: Boolean;
  DefaultRow: Integer;

  // ...........................................................................
  function IsGlobal: Boolean;
  begin
    Result := (Trim(SortViewRec.svrUserId) = '');
  end;
  // ...........................................................................
  function OwnedByCurrentUser: Boolean;
  begin
    Result := (Trim(SortViewRec.svrUserId) = Trim(EntryRec.Login));
  end;
  // ...........................................................................
  function IsDefault: Boolean;
  begin
    Result := (FSortView.UserDefaults.DefaultView = SortViewRec.svrViewId);
  end;
  // ...........................................................................

begin
  ClearList;
  DefaultRow := -1;
  FuncRes := FSortView.Find(FSortView.ListTypeSearchKey);
  while ((FuncRes = 0) and (FSortView.ListType = SortViewRec.svrListType)) do
  begin
    IncludeRecord := True;

    if IsGlobal then
      SortViewList.DesignColumns[0].Items.AddObject('Global', TSortViewIDWrapper.Create(SortViewRec.svrViewId))
    else if OwnedByCurrentUser then
      SortViewList.DesignColumns[0].Items.AddObject('User', TSortViewIDWrapper.Create(SortViewRec.svrViewId))
    else
      IncludeRecord := False;

    if IncludeRecord then
    begin
      SortViewList.DesignColumns[1].Items.Add(SortViewRec.svrDescr);
      if IsDefault then
      begin
        SortViewList.DesignColumns[2].Items.Add('*');
        DefaultRow := SortViewList.ItemsCount - 1;
      end
      else
        SortViewList.DesignColumns[2].Items.Add('');
    end;

    FuncRes := FSortView.Next;
  end;
  //HV 26/04/2016 2016-R2 ABSEXCH-9497: Drop down list be added when Status is selected to avoid mis-typing the four valid options
  if SelectDefault Then
  begin
    FuncRes := FSortView.Find(FSortView.ListTypeSearchKey);
    while ((FuncRes = 0) and (FSortView.ListType = SortViewRec.svrListType)) do
    begin
      UpdateSortViewForComboBox;
      FuncRes := FSortView.Next;
    end;
  end;
  
  if (SortViewList.ItemsCount > 0) then
  begin
    if (SelectDefault and (DefaultRow > -1)) then
      SortViewList.Selected := DefaultRow
    else if (SortViewList.Selected > SortViewList.ItemsCount - 1) then
      SortViewList.Selected := SortViewList.ItemsCount -1
    else if (SortViewList.Selected < 0) then
      SortViewList.Selected := 0;
  end;
  SyncRecordPosition;
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  // Save colours/positions/sizes/etc.
  SetColoursAndPositions(1);
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.FormCreate(Sender: TObject);
begin
  ApplyPermissions;
  AlignButtons;
  // Load colours/positions/sizes/etc.
  DoneRestore := False;
  SetColoursAndPositions(0);
  MinSizeX := Width;
  MinSizeY := Height;
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.FormDestroy(Sender: TObject);
begin
  ClearList;
  FSortView := nil;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.FormResize(Sender: TObject);
begin
  LockWindowUpdate (Handle);

  // Resize/reposition the button containing the panels
  panButtons.Left := ClientWidth - panButtons.Width - 4;
  panButtons.Height := ClientHeight - 13;

  // Resize list component
  SortViewList.Height := panButtons.Height;
  SortViewList.Width := panButtons.Left - 14;

  LockWindowUpdate (0);
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.SortViewListCellPaint(Sender: TObject; ColumnIndex,
  RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
  var TextBrush: TBrush; var TextAlign: TAlignment);
var
  ViewID: Integer;
begin
  ViewID := (SortViewList.DesignColumns[0].Items.Objects[RowIndex] as TSortViewIDWrapper).ID;
  if (ViewID = FSortView.ActiveViewID) Then
    TextFont.Style := TextFont.Style + [fsBold];
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.SortViewListChangeSelection(Sender: TObject);
begin
  SyncRecordPosition;
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.SortViewListRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  if (EditBtn.Visible) then
    EditBtnClick(Sender);
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.OnError(ErrorMsg: string;
  ErrorCode: Integer);
begin
  MessageDlg(ErrorMsg + ', error #' + IntToStr(ErrorCode), mtError, [mbOk], 0);
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.SetSortView(const Value: TBaseSortView);
begin
  FSortView := Value;
  if (FSortView <> nil) then
  begin
    Caption := FSortView.ListDesc + ' - Sort View Options';
    FSortView.UserDefaults.FindDefault(EntryRec.Login, FSortView.ListType);
    FillList(True);
  end;
end;

// -----------------------------------------------------------------------------

function TSortViewOptionsFrm.SyncRecordPosition: Boolean;
var
  ViewID: Integer;
begin
  if (SortViewList.ItemsCount > 0) and (SortViewList.Selected > -1) then
  begin
    ViewID := (SortViewList.DesignColumns[0].Items.Objects[SortViewList.Selected] as TSortViewIDWrapper).ID;
    Result := (FSortView.FindByID(ViewID) = 0);
  end
  else
    Result := False;
  ApplyBtn.Enabled := Result;
  EditBtn.Enabled := Result;
  DeleteBtn.Enabled := Result;
  CopyBtn.Enabled := Result;
  DefaultBtn.Enabled := Result;
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.Properties1Click(Sender: TObject);
begin
  // Call the colours dialog
  case oSettings.Edit(SortViewList, self.Name, nil) Of
    mrOK             : ; // no other controls to colour
    mrRestoreDefaults: SetColoursAndPositions (2);
  End; // Case oSettings.Edit(...
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.SetColoursAndPositions(const Mode: Byte);
// Controls the loading/saving of the colours and positions
//
// Mode   0=Load Details, 1=Save Details, 2=Delete Details
var
  WantAutoSave: Boolean;
begin
  case Mode of
    0 : begin
          oSettings.LoadForm(self, WantAutoSave);
          SaveCoordinates1.Checked := WantAutoSave;
          oSettings.LoadList(SortViewList, self.Name);
        end;
    1 : if (not DoneRestore) Then
        begin
          // Only save the details if the user didn't select Restore Defaults
          oSettings.SaveForm(self, SaveCoordinates1.Checked);
          oSettings.SaveList(SortViewList, self.Name);
        end;
    2 : begin
          DoneRestore := True;
          oSettings.RestoreFormDefaults(self.Name);
          oSettings.RestoreListDefaults(SortViewList, self.Name);
          SaveCoordinates1.Checked := False;
        end;
  else
    raise Exception.Create ('TSortViewOptionsFrm.SetColoursAndPositions - Unknown Mode (' + IntToStr(Ord(Mode)) + ')');
  end;
end;

// -----------------------------------------------------------------------------

procedure TSortViewOptionsFrm.WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
begin
  with Msg.MinMaxInfo^ do
  begin
    ptMinTrackSize.X := MinSizeX;
    ptMinTrackSize.Y := MinSizeY;
  end;
  Msg.Result := 0;
  inherited;
end;

// -----------------------------------------------------------------------------
//HV 26/04/2016 2016-R2 ABSEXCH-9497: Drop down list be added when Status is selected to avoid mis-typing the four valid options
// Update existing Sort Views value in to SortView Records
procedure TSortViewOptionsFrm.UpdateSortViewForComboBox;
var
  i : Integer;
  ThisSet  :  TStrings;
  IsUpdateSortView: Boolean;
begin                                       
  IsUpdateSortView := False;
  //PL 04/01/2017 2017-R1 ABSEXCH-17809 : Default list values for Status field in Sort View of Trader > Ledger is not correct.
  if FSortView.ListType in[svltCustomer,svltSupplier,svltConsumer,svltCustLedger,svltSuppLedger,svltConsumerLedger] then
  begin
    for i := 1 to FSortView.FilterCount do
    begin
      if FSortView.Filters[i].svfEnabled then
      begin
        //PL 04/01/2017 2017-R1 ABSEXCH-17809 : Default list values for Status field in Sort View of Trader > Ledger is not correct.
        //Here FSortView.Filters[i].svfFieldId is '12' for Ledger.
        if (FSortView.Filters[i].svfFieldId = 9) and (FSortView.ListType in [svltCustomer,svltSupplier,svltConsumer,svltCustLedger,svltSuppLedger,svltConsumerLedger]) then // Customer Status field;
        begin
          ThisSet:= TStringList.Create;
          try
            //PL 04/01/2017 2017-R1 ABSEXCH-17809 : Default list values for Status field in Sort View of Trader > Ledger is not correct.
            if (FSortView.ListType in [svltCustomer,svltSupplier,svltConsumer]) then
              Set_DefaultAccStatus(ThisSet,BOff,BOff)
            else if (FSortView.ListType in [svltCustLedger,svltSuppLedger,svltConsumerLedger]) then
              Set_DefaultAccLedStatus(ThisSet,BOff,BOff);
            if ThisSet.IndexOf(SortView.Filters[i].svfValue) <> -1 then
            begin
              FSortView.Filters[i].svfValue :=  IntToStr(ThisSet.IndexOf(SortView.Filters[i].svfValue));
              IsUpdateSortView:= True;
            end;
          Finally
            FreeAndNil(ThisSet);
          end;
        end;
      end;
    end;
    if IsUpdateSortView then
    begin
      IsUpdateSortView := False;
      FSortView.Update;
    end;
  end;
end;

end.
