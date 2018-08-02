unit AnonymisationControlCentreF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, ExtCtrls, oAnonymisationDiaryObjIntf,
  oAnonymisationDiaryObjList, oAnonymisationDiaryObjDetail, GDPRConst,
  Saltxl1U, SalTxl3U, ActnList, EntWindowSettings, BTSupu1;

type
  TfrmAnonymisationControlCentre = class(TForm)
    PageControl1: TPageControl;
    tabshDue: TTabSheet;
    tabshPending: TTabSheet;
    lvOverdue: TListView;
    pmTagging: TPopupMenu;
    mnuTagAll1: TMenuItem;
    mnuUntagAll: TMenuItem;
    lvPending: TListView;
    pmSetup: TPopupMenu;
    pmoGDPRConfiguration: TMenuItem;
    pmoUserDefinedFieldsConfiguration: TMenuItem;
    pmReports: TPopupMenu;
    mnuCustInactivityRep: TMenuItem;
    mnuSupplierInactivityRep: TMenuItem;
    mnuEmployeeInactivityRep: TMenuItem;
    N1: TMenuItem;
    mnuAnonymisedCustRep: TMenuItem;
    mnuAnonymisedSuppliersRep: TMenuItem;
    mnuAnonymisedEmployeesRep: TMenuItem;
    btnClose: TButton;
    btnAnonymise: TButton;
    btnViewEntity: TButton;
    btnReports: TButton;
    btnUtilities: TButton;
    btnSetup: TButton;
    pnlCheckBox: TPanel;
    imgCheckBox: TImage;
    alMain: TActionList;
    actClose: TAction;
    actView: TAction;
    actAnonymise: TAction;
    actUtilities: TAction;
    actSetup: TAction;
    actReports: TAction;
    actProperties: TAction;
    pmMain: TPopupMenu;
    mnuView: TMenuItem;
    mnuAnonymise: TMenuItem;
    mnuSetup: TMenuItem;
    mnuUtilities: TMenuItem;
    N3: TMenuItem;
    mnuReports: TMenuItem;
    N4: TMenuItem;
    mnuProperties: TMenuItem;
    mnuSaveCoordinates: TMenuItem;
    actGDPRConfiguration: TAction;
    actUserDefinedFields: TAction;
    mnuGDPRConfiguration: TMenuItem;
    mnuUserDefinedFields: TMenuItem;
    actCustInactivityRep: TAction;
    actSupplierInactivityRep: TAction;
    actEmployeeInactivityRep: TAction;
    actAnonymisedCustRep: TAction;
    actAnonymisedSuppliersRep: TAction;
    actAnonymisedEmployeesRep: TAction;
    CustomerConsumerInactivity1: TMenuItem;
    SupplierInactivity1: TMenuItem;
    EmployeeInactivity1: TMenuItem;
    N2: TMenuItem;
    AnonymisedCustomersConsumers1: TMenuItem;
    Anonymise1: TMenuItem;
    AnonymisedEmployees1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure imgCheckBoxClick(Sender: TObject);
    procedure mnuTagAll1Click(Sender: TObject);
    procedure mnuUntagAllClick(Sender: TObject);
    
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);

    procedure actGDPRConfigurationExecute(Sender: TObject);
    procedure actUserDefinedFieldsExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actAnonymiseExecute(Sender: TObject);
    procedure actSetupExecute(Sender: TObject);
    procedure actReportsExecute(Sender: TObject);
    procedure actViewExecute(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure actPropertiesExecute(Sender: TObject);
    procedure lvPendingSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private declarations }
    FAnonDiaryListIntf: IAnonymisationDiaryDetailList;
    FSelectedAnonEntityCount: Integer;
    FDispCust: TFCustDisplay;
    {$IFDEF JC}
      FDispEmp: TFJobDisplay;
    {$ENDIF}
    FSettings: IWindowSettings;
    FOriginalListViewWindowProc: TWndMethod;
    procedure LoadList;
    procedure SetActionAccess;
    procedure SetActionEnabled;
    function GetSelectedCount: Integer;
    procedure DisplayAccount(ACustCode:String; AMode: Byte);
    procedure DisplayEmployee(AEmpCode:String; AMode: Byte);
    procedure SetTaggedState(ATagged : Boolean);
    //SSK 26/12/2017 ABSEXCH-19587: Implements Save Coordinates & Restore Coordinates
    procedure SaveCoordinates;
    procedure RestoreCoordinates;
    procedure ListViewWindowProcEx(var Message: TMessage);
	  //RB 26/12/2017 2018-R1 ABSEXCH-19586: User permission implementation related to Anonymisation Control Centre window
    Procedure WMAnonPermissionMsg(Var Message: TMessage); Message WM_AnonControlCentreMsg;
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

uses GDPRConfigF, //HV 16-11-2017 2018 R1, ABSEXCH-19345: GDPR Configuration Window
     UserFieldConfig, ETDateU, PWarnU, UA_Const, Btrvu2, BtKeys1U, GlobVar, Varconst,
     CommCtrl, BtSupu2;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.FormCreate(Sender: TObject);
begin
  // Redirect the list view's WindowProc so we can detect the checkbox being changed
  FOriginalListViewWindowProc := lvOverdue.WindowProc;
  lvOverdue.WindowProc := ListViewWindowProcEx;
  
  MDI_SetFormCoord(TForm(Self));
  Self.ClientHeight := 275;
  Self.ClientWidth := 799;
  PageControl1.ActivePage := tabshDue;
  FDispCust := nil;
  {$IFDEF JC}
    FDispEmp := nil;
  {$ENDIF}
  LoadList;
  SetActionAccess;
  FSelectedAnonEntityCount := 0;
  //SSK 26/12/2017 ABSEXCH-19587: Restore saved Coordinates
  RestoreCoordinates;
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.imgCheckBoxClick(Sender: TObject);
begin
  with imgCheckBox.ClientToScreen(Point(1, imgCheckBox.Height)) Do
    pmTagging.Popup(X,Y);
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.SetTaggedState(ATagged : Boolean);
var
  I : Integer;
  lPos : Integer;
begin
  lPos := 0;
  if lvOverDue.Items.Count = 0 then Exit;
  if Assigned(lvOverdue.Selected) then
    lPos := lvOverdue.Selected.Index;       // Store record position to be restore after the opration complete.
  try
    for I := 0 to lvOverdue.Items.Count -1 do
    begin
      lvOverdue.Items[I].Checked := ATagged;
    end;
    if ATagged then
      FSelectedAnonEntityCount := lvOverDue.Items.Count
    else
      FSelectedAnonEntityCount := 0;
  finally
    lvOverdue.ItemIndex := lPos;
    SetActionEnabled;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.mnuTagAll1Click(Sender: TObject);
begin
  SetTaggedState(True);
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.mnuUntagAllClick(Sender: TObject);
begin
  SetTaggedState(False);
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.LoadList;
var
  i: Integer;
  //-----------------------------
  procedure AppendDataIntoList(AView: TListView);
  begin
    with AView.Items.Add do
    begin
      Caption := POutDate(FAnonDiaryListIntf[i].adAnonymisationDate);
      SubItems.Add(AnonDiaryEntityTypeDesc[FAnonDiaryListIntf[i].adEntityType]);
      SubItems.Add(Trim(FAnonDiaryListIntf[i].adEntityCode));
      SubItems.Add(Trim(FAnonDiaryListIntf[i].adEntityName));
    end;
  end;
  //-----------------------------
begin
  FAnonDiaryListIntf := AnonymisationDiaryDetailList(True);
  if Assigned(FAnonDiaryListIntf) Then
  begin
    lvOverdue.WindowProc := FOriginalListViewWindowProc;
    lvOverdue.Clear;
    lvPending.Clear;
    try
      for I := 0 To (FAnonDiaryListIntf.Count - 1) Do
      begin
        if FAnonDiaryListIntf[i].adIsPending then
          AppendDataIntoList(lvPending)
        else
          AppendDataIntoList(lvOverdue)
      end;
    finally
      if (lvOverdue.Items.Count > 0) then
        lvOverdue.Items[0].Selected := True;
      lvOverdue.WindowProc := ListViewWindowProcEx;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.FormDestroy(Sender: TObject);
begin
  // SSK 22/12/2017 2018R1 ABSEXCH-19580 :
  SaveCoordinates;
  FSettings := nil;
  // Release the transaction list interface
  FAnonDiaryListIntf := NIL;
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.FormResize(Sender: TObject);
const
  BorderPix = 5;
begin
  // Align buttons to right border
  btnClose.Left := ClientWidth - BorderPix - btnClose.Width;
  btnViewEntity.Left := btnClose.Left;
  btnAnonymise.Left := btnClose.Left;
  btnReports.Left := btnClose.Left;
  btnUtilities.Left := btnClose.Left;
  btnSetup.Left := btnClose.Left;
    // Fit ListView in middle
  PageControl1.Top := BorderPix;
  PageControl1.Left := BorderPix;
  PageControl1.Width := btnClose.Left - BorderPix - PageControl1.Left;
  PageControl1.Height := ClientHeight - PageControl1.Top - BorderPix;
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.actGDPRConfigurationExecute(Sender: TObject);
var
  lfrmGDPRConfig: TfrmGDPRConfiguration;
begin
  lfrmGDPRConfig := TfrmGDPRConfiguration.Create(Self);
  try
    lfrmGDPRConfig.ShowModal;
  finally
    FreeAndNil(lfrmGDPRConfig);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.actUserDefinedFieldsExecute(Sender: TObject);
var
  i: integer;
  lCreateNew: boolean;
  lfrmUserFieldConfig: TFrm_UserFieldConfig;
begin
  lCreateNew := True;
  for i := 0 to Screen.FormCount - 1 do
  begin
    if (screen.Forms[i] is TFrm_UserFieldConfig) then
    begin
      lCreateNew := False;
      Break;
    end;
  end; 
  if lCreateNew then
  begin
    lfrmUserFieldConfig := TFrm_UserFieldConfig.Create(Self);
    lfrmUserFieldConfig.Show;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.actCloseExecute(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.actAnonymiseExecute(Sender: TObject);
begin
  if MessageDlg(Format(msgAnonymiseConfirmation, [IntToStr(GetSelectedCount)] ), mtConfirmation, [mbYes, mbNo], 0) =  mrYes then
  begin
    FAnonDiaryListIntf.Anonymise(Self);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.SetActionAccess;
begin
  actReports.Visible := False;
  actUtilities.Visible := False;
  actGDPRConfiguration.Visible := ChkAllowed_In(uaAccessToGDPRConfiguration);
  actUserDefinedFields.Visible := ChkAllowed_In(uaAccessCustomFields);
  SetActionEnabled;
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.SetActionEnabled;
begin
  actView.Enabled := ((PageControl1.ActivePage = tabshDue) and Assigned(lvOverdue.Selected)) or
                     ((PageControl1.ActivePage = tabshPending) and Assigned(lvPending.Selected));

  actAnonymise.Enabled := (PageControl1.ActivePage = tabshDue) and (GetSelectedCount > 0);

  actSetup.Enabled := actGDPRConfiguration.Visible or actUserDefinedFields.Visible;
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.actSetupExecute(Sender: TObject);
begin
  // Position menu directly below button - use the parent tabsheet to convert the button
  // position into screen co-ordinates
  with tabshDue.ClientToScreen(Point(btnSetup.Left, btnSetup.Top)) do
    pmSetup.PopUp(X+1, Y-9);
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.actReportsExecute(Sender: TObject);
begin
  // Position menu directly below button - use the parent tabsheet to convert the button
  // position into screen co-ordinates
  with tabshDue.ClientToScreen(Point(btnReports.Left, btnReports.Top)) do
    pmReports.PopUp(X+1, Y-9);
end;

//------------------------------------------------------------------------------
// SSK 21/12/2017 ABSEXCH-19490: Implements View Option for Selected Entity
procedure TfrmAnonymisationControlCentre.actViewExecute(Sender: TObject);
var
  lEntityType,
  lEntityCode: string;
begin
  if (PageControl1.ActivePage = tabshDue) and Assigned(lvOverdue.Selected) then
  begin
    lEntityType := UpperCase(lvOverdue.Selected.SubItems[0]);
    lEntityCode := lvOverdue.Selected.SubItems[1];
  end
  else if (PageControl1.ActivePage = tabshPending) and Assigned(lvPending.Selected) then
  begin
    lEntityType := UpperCase(lvPending.Selected.SubItems[0]);
    lEntityCode := lvPending.Selected.SubItems[1];
  end;

  if lEntityType = 'EMPLOYEE' then
    DisplayEmployee(lEntityCode, 2)
  else
    DisplayAccount(lEntityCode, 0);
end;

//------------------------------------------------------------------------------
//display the Trader window (Customer/Supplier)
procedure TfrmAnonymisationControlCentre.DisplayAccount(ACustCode:String; AMode: Byte);
var
  lKeyS: Str255;
  lStatus: Integer;
begin
  // Get the matching trader record using the Code index
  lKeyS := FullCustcode(ACustCode);
  lStatus := Find_Rec(B_GetEq, F[CustF], CustF, RecPtr[CustF]^, 0, lKeyS);
  if lStatus = 0 then
  begin
    try
      if not Assigned(FDispCust) then
        FDispCust := TFCustDisplay.Create(Self);
      FDispCust.Display_Trader(IsACust(Cust.CustSupp), 0, Inv);
    except
      FreeAndNil(FDispCust);
    end;   {try..}
  end;
end;

//------------------------------------------------------------------------------
//display the window for Employee
procedure TfrmAnonymisationControlCentre.DisplayEmployee(AEmpCode:String; AMode: Byte);
var
  lKeyS: Str255;
  lStatus: Integer;
begin
  {$IFDEF JC}
    lKeyS := PartCCKey(JARCode, JASubAry[3]) + AEmpCode;
    lStatus := Find_Rec(B_GetGEq, F[JMiscF], JMiscF, RecPtr[JMiscF]^, JMK, lKeyS);
    if lStatus = 0 then
    begin
      try
        if not Assigned(FDispEmp) then
          FDispEmp := TFJobDisplay.Create(Self);
        FDispEmp.Display_Employee(AMode,BOn);
      except
        FreeAndNil(FDispEmp);
      end; {try..}
    end;
  {$ENDIF}
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.PageControl1Change(Sender: TObject);
begin
  SetActionEnabled;
end;

//------------------------------------------------------------------------------

function TfrmAnonymisationControlCentre.GetSelectedCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  if not Assigned(FAnonDiaryListIntf) then Exit;

  for I := 0 to FAnonDiaryListIntf.Count-1 do
  begin
    if (not FAnonDiaryListIntf[i].adIsPending) and  FAnonDiaryListIntf[i].adSelected then
      Inc(Result);
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmAnonymisationControlCentre.RestoreCoordinates;
begin
  FSettings := GetWindowSettings(Self.Name);
  if Assigned(FSettings) then
  begin
    FSettings.LoadSettings;
    if (Not FSettings.UseDefaults) then
    begin
      FSettings.SettingsToWindow(Self);
      FSettings.SettingsToParent(Self);
      FSettings.SettingsToParent(lvOverdue);
      FSettings.SettingsToParent(lvPending);
    end;
  end;

end;
//------------------------------------------------------------------------------
procedure TfrmAnonymisationControlCentre.SaveCoordinates;
begin
  if Assigned(FSettings) then
  begin
    FSettings.WindowToSettings(Self);

    FSettings.ParentToSettings(lvOverdue, lvOverdue);
    FSettings.ParentToSettings(lvPending, lvPending);

    FSettings.SaveSettings(mnuSaveCoordinates.Checked);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.actPropertiesExecute(Sender: TObject);
begin
  if Assigned(FSettings) then
  begin
    if (PageControl1.ActivePage = tabshDue) then
      FSettings.Edit(lvOverdue, lvOverdue)
    else
      FSettings.Edit(lvPending, lvPending);
  end;

end;

//------------------------------------------------------------------------------
//RB 26/12/2017 2018-R1 ABSEXCH-19586: User permission implementation related to Anonymisation Control Centre window 
procedure TfrmAnonymisationControlCentre.WMAnonPermissionMsg(var Message: TMessage);
begin
  with Message do
  begin
    case WParam of
      1 : begin
            SetActionAccess;
          end;
      2 : begin
            LoadList;
          end;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.ListViewWindowProcEx(var Message: TMessage);
begin
  // Complicated Windows API/Messaging stuff to detect the clicking of a checkbox in a listview
  // row - copied from http://delphi.about.com/od/delphitips2007/qt/listviewchecked.htm
  if Message.Msg = CN_NOTIFY then
  begin
    if PNMHdr(Message.LParam)^.Code = LVN_ITEMCHANGED then
    begin
      with PNMListView(Message.LParam)^ do
      begin
        if (uChanged and LVIF_STATE) <> 0 then
        begin
          if ((uNewState and LVIS_STATEIMAGEMASK) shr 12) <> ((uOldState and LVIS_STATEIMAGEMASK) shr 12) then
          begin
            lvOverdue.Items[iItem].Selected := True;
            FAnonDiaryListIntf.AnonymisationDiaryObj[iItem].adSelected := lvOverdue.Items[iItem].Checked;
          end;
        end;
      end;
    end;
    //original ListView message handling
    FOriginalListViewWindowProc(Message);
    SetActionEnabled;
  end // if Message.Msg = CN_NOTIFY
  else
    FOriginalListViewWindowProc(Message); //original ListView message handling
end;

//------------------------------------------------------------------------------

procedure TfrmAnonymisationControlCentre.lvPendingSelectItem(
  Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  SetActionEnabled;
end;

//------------------------------------------------------------------------------

end.
