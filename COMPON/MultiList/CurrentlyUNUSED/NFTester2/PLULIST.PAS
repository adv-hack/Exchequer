unit PLUList;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, PLUDet, ExtCtrls
  , SBSPanel, StdCtrls, SBSComp, VarConst, ExWrap1U, Progress, GlobVar, btSupU2, btSupU1, CardDet
  , ETStrU, ActnList, Menus, aPIUtil, AdPacket, OoMisc, AdPort, MPComms, MiscUtil, BTList, BtrvU2
  , CardProc, Comms, FuncDet, ProcFunc, TEditVal, BTKeys1U, TCustom, NeilProc;

type
  TDiscountInfo = class
    Percent : Real;
  end;{TDiscountInfo}

  TItemList  =  class(TMULCtrl)
    public
      iGroupNo : integer;
      function SetCheckKey : Str255; override;
      function SetFilter : Str255; override;
  {    function Ok2Del: Boolean; override;}
      function OutLine(Col : Byte) : Str255; override;
  end;

  TFrmPLUList = class(TForm)
    sbMain: TScrollBox;
    panNumber: TSBSPanel;
    panName: TSBSPanel;
    panTitle: TSBSPanel;
    panNumberTitle: TSBSPanel;
    panNameTitle: TSBSPanel;
    panScrollBar: TSBSPanel;
    panButtons: TSBSPanel;
    pmMain: TPopupMenu;
    Edit1: TMenuItem;
    ListProperties1: TMenuItem;
    ActionList1: TActionList;
    EditCard: TAction;
    ShowDetails1: TMenuItem;
    ShowDetails: TAction;
    MoveAlignCols: TAction;
    HeadersMouseDown: TAction;
    HeadersMouseMove: TAction;
    SaveOnExit: TMenuItem;
    panDiscountTitle: TSBSPanel;
    panDiscount: TSBSPanel;
    panOverride: TSBSPanel;
    panOverrideTitle: TSBSPanel;
    panType: TSBSPanel;
    panTypeTitle: TSBSPanel;
    Action1: TAction;
    btnClose: TSBSButton;
    N2: TMenuItem;
    btnEdit: TSBSButton;
    btnShowDetails: TSBSButton;
    btnUpload: TSBSButton;
    btnPrint: TSBSButton;
    panGroupDetails: TPanel;
    sbGroupDisc: TScrollBox;
    Label2: TLabel;
    cbGroup: TComboBox;
    Label1: TLabel;
    edGroupDisc: TCurrencyEdit;
    btnEditOK: TButton;
    pmDownload: TPopupMenu;
    AllItems1: TMenuItem;
    Groups1: TMenuItem;
    DepartmentRange1: TMenuItem;
    PLURange1: TMenuItem;
    btnDelete: TSBSButton;
    btnDeleteGroup: TSBSButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ShowDetailsExecute(Sender: TObject);
    procedure MoveAlignColsExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HeadersMouseDownExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HeadersMouseMoveExecute(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
    procedure ListProperties1Click(Sender: TObject);
    procedure pmMainPopup(Sender: TObject);
    procedure SaveOnExitClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure cbGroupChange(Sender: TObject);
    procedure btnEditOKClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
    procedure AllItems1Click(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnDeleteGroupClick(Sender: TObject);
  private
    FormStuff : TFormStuff;
    ExLocal : TdExLocal;
    FrmPLUDetails : TFrmPLUDetails;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure WMFormCloseMsg(var Message : TMessage); message WM_FormCloseMsg;
    procedure WMCustGetRec(var Message : TMessage); message WM_CustGetRec;
    Procedure FillGroupList;
  public
  end;

const
  OpMode = 2;
  DefClientHeight = 345;
  DefClientWidth  = 529;

{var
  FrmCardList: TFrmCardList2;}

implementation


uses FindDlg, Reports, RunRange;

{$R *.DFM}


{TItemList}

function TItemList.SetCheckKey : Str255;
begin
  SetCheckKey := FullNomKey(ItemRec.siGroup);
end;

function TItemList.SetFilter  :  Str255;
begin
  Result := FuncKey;
end;

function TItemList.OutLine(Col : Byte) : Str255;
{defines which fields go in which columns}
begin
  case Col of
    0  : begin
      case ItemRec.siType of
        'P' : OutLine := 'PLU';
        'D' : OutLine := 'Dept.';
      end;{case}
    end;

    1  : OutLine := IntToStr(ItemRec.siNumber);
    2  : OutLine := ItemRec.siName;

    3  : begin
      if ItemRec.siOverRide then OutLine := 'Yes'
      else OutLine := 'No';
    end;

    4  : begin
      if ItemRec.siOverRide then OutLine := MoneyToStr(ItemRec.siDiscount) {Discount}
      else OutLine := '';
    end;
  else OutLine := '';
  end;{case}
end;


{TFrmCardList}

procedure TFrmPLUList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FrmPLUDetails <> nil then FrmPLUDetails.Close;

  Application.ProcessMessages; {so it doesn't crash hideously !}
  with FormStuff do begin
    StoreFormProperties(Self, OpMode, bStoreCoord, bSetDefaults, bLastCoord
    , apanTitle, aMULCtrlO, acPrimeKeys);
  end;{with}
  SendMessage(TForm(Owner).Handle,WM_FormCloseMsg,5,0);
  action := caFree;
end;

procedure TFrmPLUList.FormCreate(Sender: TObject);
var
  bLock : boolean;
begin
  bLock := FALSE;
  GetMultiSys(FALSE,bLock);
  btnEdit.Enabled := Syss.UseSplDisc;
  Edit1.Enabled := Syss.UseSplDisc;

  ExLocal.Create;
  FormStuff := TFormStuff.Create(1);

  {set default size}
  ClientHeight := DefClientHeight;
  ClientWidth := DefClientWidth;

  with FormStuff do begin
    {set up an array of columns}
    bFillList := FALSE;
    SetLength(aColumns[0],5);
    aColumns[0,0].ColPanel := panType;
    aColumns[0,0].HeadPanel := panTypeTitle;
    aColumns[0,1].ColPanel := panNumber;
    aColumns[0,1].HeadPanel := panNumberTitle;
    aColumns[0,2].ColPanel := panName;
    aColumns[0,2].HeadPanel := panNameTitle;
    aColumns[0,3].ColPanel := panOverride;
    aColumns[0,3].HeadPanel := panOverrideTitle;
    aColumns[0,4].ColPanel := panDiscount;
    aColumns[0,4].HeadPanel := panDiscountTitle;
    aColumns[0,4].DecPlaces := 2;


    aFileNos[0] := ItemF;
    asbMain[0] := sbMain;
    acPrimeKeys[0] := 'A';
    apanTitle[0] := panTitle;
    asbButtons[0] := nil;
    apanButtons[0] := panButtons;
    aMULCtrlO[0] := TItemList.Create(Self);{creates control object}
    TItemList(aMULCtrlO[0]).iGroupNo := 1;

    apanScrollBar[0] := panScrollBar;
    aCaseSensSearch[0] := TRUE;
    aiKeys[0] := siGroupK;
    asStartKeys[0] := FullNomKey(TItemList(aMULCtrlO[0]).iGroupNo){ + CHR(0) + FullNomKey(0)};
{    asEndKeys[0] := FullNomKey(TItemList(aMULCtrlO[0]).iGroupNo) + CHR(255) + FullNomKey(MAXLONGINT);}

    ReadFormProperties(Self, FormStuff);
    aMULCtrlO[0].ReColorBar(panScrollBar.Font,$00535300);
    DoFormResize(Self, FormStuff);
  end;{with}

  btnDelete.Visible := LoginMode in [{lmUser,} lmDebug];
  btnDeleteGroup.Visible := LoginMode in [{lmUser,} lmDebug];

  FillGroupList;
  cbGroupChange(Self);
  btnEditOK.Enabled := cbGroup.ItemIndex > -1;
end;

procedure TFrmPLUList.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 363;
    ptMinTrackSize.Y := 221;
  end;{with}
  Message.Result := 0;
  inherited;
end;

procedure TFrmPLUList.WMFormCloseMsg(var Message : TMessage);
{receive a message that a child window has closed}
var
  bValidLine : boolean;
begin
  with Message do begin
    case WParam of
      {Details Form Close}
      1 : FrmPLUDetails := nil;

      {List Click (deferred from WMCustGetRec for mousey reasons)}
      1001 : begin
        bValidLine := FormStuff.aMulCtrlO[0].ValidLine;
        if bValidLine then begin

          {Get local copy of global record}
          ExLocal.AssignFromGlobal(ItemF);
          ExLocal.LGetRecAddr(ItemF);

          {Update details window}
          if (FrmPLUDetails <> nil) then begin
            with FrmPLUDetails do begin
              if (not ExLocal.InAddEdit) then UpdateDetails(TRUE);
            end;{with}
          end;{if}
        end;{if}
      end;
    end;{case}
  end;{with}
  inherited;
end;

procedure TFrmPLUList.WMCustGetRec(var Message  :  TMessage);
{Receive message that a List Action has occured}
begin
  with Message do begin
    case WParam of
      {List Double Click}
      0 : ShowDetailsExecute(Self);

      {List Click}
      1 : PostMessage(Self.Handle,WM_FormCloseMsg,1001,0); {* This was placed here to stop the mouse up event from being corrupted *}

      {List Right Click}
      2 : begin
        {SaveOnExit.Checked := FormStuff.bStoreCoord;}
        pmMain.Popup(lParamLo,lParamHi);
      end;

      {Update List Item}
      200 : FormStuff.aMULCtrlO[0].AddNewRow(FormStuff.aMULCtrlO[0].MUListBoxes[0].Row,FALSE);
    end;{case}
  end;{with}
  inherited;
end;

procedure TFrmPLUList.ShowDetailsExecute(Sender: TObject);
var
  fmFormMode : TFormMode;
begin
  fmFormMode := TFormMode(TWinControl(Sender).Tag);
  if (fmFormMode = fmAdd) or FormStuff.aMulCtrlO[0].ValidLine then begin {check for bug in first item of list !}

    if FrmPLUDetails = nil then FrmPLUDetails := TFrmPLUDetails.Create(self);

    with FrmPLUDetails do begin
      if not ExLocal.InAddEdit then begin
        if fmFormMode <> fmAdd then UpdateDetails(TRUE);
        if SetFormMode(fmFormMode) then Show
        else TillCommsError;
      end;{if}
    end;{with}
  end;{if}
end;

procedure TFrmPLUList.HeadersMouseDownExecute(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {depresses the column header}
  if (Sender is TSBSPanel) and (not TSBSPanel(Sender).ReadytoDrag) and (Button = MBLeft)
  then FormStuff.aMULCtrlO[0].VisiList.PrimeMove(Sender); {begin column drag/drop}
end;

procedure TFrmPLUList.HeadersMouseMoveExecute(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  {visually moves column header to show the change about to be made (drag/drop}
  if (Sender is TSBSPanel) then FormStuff.aMULCtrlO[0].VisiList.MoveLabel(X,Y);
end;

procedure TFrmPLUList.MoveAlignColsExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TSBSPanel) then DoMoveAlignCols(TSBSPanel(Sender), FormStuff, 0);
end;

procedure TFrmPLUList.ListProperties1Click(Sender: TObject);
{Change List Colours}
begin
{  ListProperties(Self, MULCtrlO, bSetDefaults, 'Card List Properties');}
end;

procedure TFrmPLUList.pmMainPopup(Sender: TObject);
var
  bValidLine : boolean;
begin
  {greys in / out the menu items as appropriate}
  bValidLine := FormStuff.aMulCtrlO[0].ValidLine;
  SaveOnExit.Checked := FormStuff.bStoreCoord;
  ShowDetails1.Enabled := bValidLine;
  Edit1.Enabled := bValidLine and Syss.UseSplDisc;
end;

procedure TFrmPLUList.SaveOnExitClick(Sender: TObject);
begin
  FormStuff.bStoreCoord := not FormStuff.bStoreCoord;
end;

procedure TFrmPLUList.FormResize(Sender: TObject);
begin
  DoFormResize(Self, FormStuff);
  panGroupDetails.Width := ClientWidth - 16;
  sbGroupDisc.VertScrollBar.Position := 1000;
end;

procedure TFrmPLUList.FormDestroy(Sender: TObject);
begin
  FormStuff.Free;
  ClearList(cbGroup.Items);
  ExLocal.Destroy;
end;

procedure TFrmPLUList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

Procedure TFrmPLUList.FillGroupList;
const
  Fnum = GroupF;
  Keypath = GrArrayK;
var
  KeyS : str255;
  ExLocal : TdExlocal;
  iStatus : smallint;
  DiscountInfo : TDiscountInfo;
begin
  ClearList(cbGroup.Items);

  ExLocal.Create;

  { Get first record }
  Blank(KeyS,SizeOf(KeyS));
  iStatus := Find_Rec (B_GetGEq, F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath,KeyS);
  ExLocal.LGetRecAddr(FNum);

  While iStatus = 0 do begin
    With ExLocal, LGroupRec Do Begin
      DiscountInfo := TDiscountInfo.Create;
      DiscountInfo.Percent := LGroupRec.grDiscount;
      cbGroup.Items.AddObject(IntToStr(LGroupRec.grArrayNo) + '. ' + LGroupRec.grName, DiscountInfo);
      iStatus := Find_Rec (B_GetNext, F[Fnum], Fnum, LRecPtr[Fnum]^, Keypath, KeyS);
      LGetRecAddr(FNum);
    end;{with}
  end;{while}
  ExLocal.Destroy; {destroy local record instance}

  if cbGroup.Items.Count > 0 then begin
    cbGroup.ItemIndex := 0;
    edGroupDisc.Text := MoneyToStr(TDiscountInfo(cbGroup.Items.Objects[cbGroup.ItemIndex]).Percent);
  end;{if}
end;


procedure TFrmPLUList.cbGroupChange(Sender: TObject);
var
  KeyS : str255;
  iStatus : smallint;
begin
  if cbGroup.ItemIndex > -1 then begin
    with FormStuff do begin
      TItemList(aMULCtrlO[0]).iGroupNo := cbGroup.ItemIndex + 1;
      asStartKeys[0] := FullNomKey(TItemList(aMULCtrlO[0]).iGroupNo);

      aMULCtrlO[0].StartList(ItemF,aiKeys[0],asStartKeys[0],'','',Length(asStartKeys[0]), FALSE);

      aMULCtrlO[0].InitPage;
      edGroupDisc.Text := MoneyToStr(TDiscountInfo(cbGroup.Items.Objects[cbGroup.ItemIndex]).Percent);
    end;{with}

    {store group in global record}
    KeyS := FullNomKey(cbGroup.ItemIndex + 1);
    iStatus := Find_Rec(B_GetEq,F[GroupF],GroupF,RecPtr[GroupF]^,GrArrayK,KeyS);
    Report_BError(GroupF, iStatus);
  end;{if}
end;

procedure TFrmPLUList.btnEditOKClick(Sender: TObject);
var
  bSave : boolean;
  iStatus : smallint;
  KeyS : str255;
begin
  bSave := btnEditOK.Caption = '&Save';

  edGroupDisc.ReadOnly := bSave;
  panButtons.Enabled := bSave;
  cbGroup.Enabled := bSave;

  if bSave then
    begin
      ExLocal.Create;
      with ExLocal do begin
        KeyS := FullNomKey(cbGroup.ItemIndex + 1);
        iStatus := Find_Rec(B_GetEq,F[GroupF],GroupF,LRecPtr[GroupF]^,GrArrayK,KeyS);
        LGetRecAddr(GroupF);
        if iStatus = 0 then
          begin
            if StrToFloat(edGroupDisc.Text) < 0 then
              begin
                MessageDlg('You need to input a discount amount that is greater than or equal to zero.'
                ,mtWarning,[mbOk],0);
                edGroupDisc.ReadOnly := FALSE;
                panButtons.Enabled := FALSE;
                cbGroup.Enabled := FALSE;
              end
            else begin
              {save new discount}
              LockRecord(GroupF, GrArrayK, ExLocal, TRUE);
              LGroupRec.grDiscount := StrToFloat(edGroupDisc.Text);
              SaveRecord(GroupF, ExLocal);
              LockRecord(GroupF, GrArrayK, ExLocal, FALSE);

              {update list Object}
              TDiscountInfo(cbGroup.Items.Objects[cbGroup.ItemIndex]).Percent := LGroupRec.grDiscount;

              {change button caption}
              btnEditOK.Caption := 'Edit &Discount';
            end;{if}
          end
        else Report_BError(GroupF, iStatus);
      end;{with}
      ExLocal.Destroy;
    end
  else begin
    btnEditOK.Caption := '&Save';
    ActiveControl := edGroupDisc;
  end;
end;

procedure TFrmPLUList.btnPrintClick(Sender: TObject);
begin
  ModReports.PrintPLUList;
end;

procedure TFrmPLUList.btnUploadClick(Sender: TObject);
begin
  pmDownload.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TFrmPLUList.AllItems1Click(Sender: TObject);
var
  MaxRec : TMaximumsRec;
  FrmRunNoRange : TFrmRunNoRange;
  iMode : byte;
  sMessage : string;
begin
  iMode := TMenuItem(Sender).Tag;

  sMessage := 'Are you sure you want to upload ';
  case iMode of
    1 : sMessage := sMessage + 'all items ?';
    2 : sMessage := sMessage + 'all groups ?';
    3 : sMessage := sMessage + 'a department range ?';
    4 : sMessage := sMessage + 'a PLU range ?';
  end;{case}

  if ((iMode in [1,2]) and (MsgBox(sMessage, mtConfirmation, [mbYes, mbNo], mbNo
  , 'Upload') = mrYes)) or (iMode in [3,4]) then begin
    MaxRec := FrmComms.GetMaxGuests(1, TRUE);

    case iMode of
      1 : DownLoadItems(1, 16, 1, StrToInt(MaxRec.Departments), 1, StrToInt(MaxRec.PLU));
      2 : DownLoadItems(1, 16, 0, 0, 0, 0);

      3, 4 : begin
        FrmRunNoRange := TFrmRunNoRange.Create(Application);
        try
          with FrmRunNoRange do begin
            case iMode of
              3 : begin
                RangeFormMode := fmDownLoadDepts;
                iStart := 1;
                iEnd := StrToInt(MaxRec.Departments);
                if ShowModal = mrOK then DownLoadItems(0, 0, iStart, iEnd, 0, 0);
              end;

              4 :  begin
                RangeFormMode := fmDownLoadPLUs;
                iStart := 1;
                iEnd := StrToInt(MaxRec.PLU);
                if ShowModal = mrOK then DownLoadItems(0, 0, 0, 0, iStart, iEnd);
              end;
            end;{case}
          end;{with}
        finally
          FrmRunNoRange.Release;
        end;{try}
      end;
    end;{case}
  end;{if}
end;

procedure TFrmPLUList.btnDeleteClick(Sender: TObject);
var
  iStatus : smallint;
begin
  if (FormStuff.aMulCtrlO[0].ValidLine) and (msgBox('Are you sure you want to delete this item ?',mtWarning
  ,[mbYes,mbNo],mbNo,'Delete Item') = mrYes) then begin
    ExLocal.AssignFromGlobal(ItemF);
    if LockRecord(ItemF, siTypeK, ExLocal, TRUE) then begin
      iStatus := Delete_Rec(F[ItemF],ItemF,siTypeK);
      Report_Berror(ItemF, iStatus);
    end;{if}
    cbGroupChange(Self);
  end;{if}
end;

procedure TFrmPLUList.FormActivate(Sender: TObject);
begin
  btnUpload.Enabled := bgCommsWorking;
end;

procedure TFrmPLUList.btnDeleteGroupClick(Sender: TObject);
var
//  ExLocal : TdExlocal;
  iStatus, iFolioNo : integer;
  KeyS : Str255;
begin
  if (msgBox('Are you sure you want to delete the current Group ?',mtWarning
  ,[mbYes,mbNo],mbNo,'Delete Group') = mrYes) then begin

//    iFolioNo := Inv.FolioNum;
//    ExLocal.Create;

    with ExLocal do begin

      // Get record
      Blank(KeyS,SizeOf(KeyS));
      KeyS := FullNomKey(TItemList(FormStuff.aMULCtrlO[0]).iGroupNo);
      iStatus := Find_Rec (B_GetGEq, F[GroupF],GroupF,LRecPtr[GroupF]^,GrNumberK,KeyS);
      ExLocal.LGetRecAddr(GroupF);

      if (iStatus = 0) and (ExLocal.LGroupRec.grNumber = TItemList(FormStuff.aMULCtrlO[0]).iGroupNo) {which it bloody well should}
      and LockRecord(GroupF, GrNumberK, ExLocal, TRUE) then begin
        iStatus := Delete_Rec(F[GroupF],GroupF,GrNumberK);
        Report_Berror(GroupF, iStatus);
      end;{if}
//      cbGroupChange(Self);
    end;{with}
  end;{if}
end;

end.

