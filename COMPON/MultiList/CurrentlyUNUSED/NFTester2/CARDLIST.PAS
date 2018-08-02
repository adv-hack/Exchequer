unit cardlist;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, SBSPanel
  , StdCtrls, SBSComp, VarConst, ExWrap1U, GlobVar, btSupU2, btSupU1, CardDet, ETStrU, ActnList
  , Menus, AdPacket, OoMisc, AdPort, MPComms, StrUtil, BTList, BtrvU2, CardProc, Comms
  , NeilProc, APIUtil, TCustom;
type
  TCustList  =  class(TMULCtrl)
    function SetCheckKey : Str255; override;
    function SetFilter : Str255; override;
    function OutLine(Col : Byte) : Str255; override;
  end;

  TFrmCardList2 = class(TForm)
    sbMain: TScrollBox;
    panCode: TSBSPanel;
    panName: TSBSPanel;
    panTitle: TSBSPanel;
    panCodeTitle: TSBSPanel;
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
    panPhoneTitle: TSBSPanel;
    panPhone: TSBSPanel;
    panMemCode: TSBSPanel;
    panMemCodeTitle: TSBSPanel;
    panCategory: TSBSPanel;
    panCategoryTitle: TSBSPanel;
    pmSortList: TPopupMenu;
    SortbyName1: TMenuItem;
    SortByCardNo1: TMenuItem;
    SortByClubCode1: TMenuItem;
    Action1: TAction;
    SortList1: TMenuItem;
    bycardnumber1: TMenuItem;
    byMemberName1: TMenuItem;
    byclubcode1: TMenuItem;
    pmFindCard: TPopupMenu;
    FindByCardNumber: TMenuItem;
    FindByMemberName: TMenuItem;
    FindByClubCode: TMenuItem;
    btnClose: TSBSButton;
    AddCard1: TMenuItem;
    N3: TMenuItem;
    FindCard1: TMenuItem;
    findbycardnumber2: TMenuItem;
    bymembername2: TMenuItem;
    byclubcode2: TMenuItem;
    N2: TMenuItem;
    btnAdd: TSBSButton;
    btnEdit: TSBSButton;
    btnShowDetails: TSBSButton;
    btnSortList: TSBSButton;
    btnFindCard: TSBSButton;
    panBalance: TSBSPanel;
    panBalanceTitle: TSBSPanel;
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
    procedure btnSortListClick(Sender: TObject);
    procedure SortList(Sender: TObject);
    procedure btnFindCardClick(Sender: TObject);
    procedure FindCardInList(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FormStuff : TFormStuff;
    ExLocal : TdExLocal;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure WMFormCloseMsg(var Message : TMessage); message WM_FormCloseMsg;
    procedure WMCustGetRec(var Message : TMessage); message WM_CustGetRec;
  public
    FrmCardDetails : TFrmCardDetails;
  end;

const
  OpMode = 2;
  DefClientHeight = 345;
  DefClientWidth  = 633;

implementation


uses FindDlg;

{$R *.DFM}


{TCustList}
function TCustList.SetCheckKey : Str255;
begin
  SetCheckKey := Cust.CustCode;
end;

function TCustList.SetFilter  :  Str255;
begin
  Result := '';
end;

function TCustList.OutLine(Col : Byte) : Str255;
{defines which fields go in which columns}
begin
  with Cust do begin
    case Col of
      0  :  OutLine := CustCode;  {Code}
      1  :  OutLine := CardFullName(Cust, True, True);   {Members Name}
      2  :  OutLine := MoneyToStr(CurrBalance);    {Club Member Code}
      3  :  OutLine := ClubNo;    {Club Member Code}
      4  :  OutLine := ClubCat;   {Category}
      5  :  OutLine := Phone;     {Phone No}
    else OutLine := '';
    end;{case}
  end;{with}
end;


{TFrmCardList2}
procedure TFrmCardList2.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FrmCardDetails <> nil then FrmCardDetails.Close;
  Application.ProcessMessages; {so it doesn't crash hideously !}
  with FormStuff do begin
    StoreFormProperties(Self, OpMode, bStoreCoord, bSetDefaults, bLastCoord
    , apanTitle, aMULCtrlO, acPrimeKeys);
  end;{with}
  SendMessage(TForm(Owner).Handle,WM_FormCloseMsg,2,0);
  action := caFree;
end;

procedure TFrmCardList2.FormCreate(Sender: TObject);
begin
  ExLocal.Create;
  FormStuff := TFormStuff.Create(1);

  {set default size}
  ClientHeight := DefClientHeight;
  ClientWidth := DefClientWidth;

  with FormStuff do begin
    {set up an array of columns}
    bFillList := TRUE;
    SetLength(aColumns[0],6);
    aColumns[0,0].ColPanel := panCode;
    aColumns[0,0].HeadPanel := panCodeTitle;
    aColumns[0,1].ColPanel := panName;
    aColumns[0,1].HeadPanel := panNameTitle;
    aColumns[0,2].ColPanel := panBalance;
    aColumns[0,2].HeadPanel := panBalanceTitle;
    aColumns[0,2].DecPlaces := 2;
    aColumns[0,3].ColPanel := panMemCode;
    aColumns[0,3].HeadPanel := panMemCodeTitle;
    aColumns[0,4].ColPanel := panCategory;
    aColumns[0,4].HeadPanel := panCategoryTitle;
    aColumns[0,5].ColPanel := panPhone;
    aColumns[0,5].HeadPanel := panPhoneTitle;

    aFileNos[0] := CustF;
    asbMain[0] := sbMain;
    acPrimeKeys[0] := 'A';
    apanTitle[0] := panTitle;
    asbButtons[0] := nil;
    apanButtons[0] := panButtons;
    aMULCtrlO[0] := TCustList.Create(Self);{creates control object}
    apanScrollBar[0] := panScrollBar;
    aCaseSensSearch[0] := TRUE;
    aiKeys[0] := CustCodeK;
    asStartKeys[0] := '';

    ReadFormProperties(Self, FormStuff);
    aMULCtrlO[0].ReColorBar(panScrollBar.Font,$00800040);
    DoFormResize(Self, FormStuff);
  end;{with}
end;

procedure TFrmCardList2.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 368;
    ptMinTrackSize.Y := 225;
  end;{with}
  Message.Result := 0;
  inherited;
end;

procedure TFrmCardList2.WMFormCloseMsg(var Message : TMessage);
{receive a message that a child window has closed}
var
  bValidLine : boolean;
begin
  with Message do begin
    case WParam of
      {Details Form Close}
      1 : FrmCardDetails := nil;

      {List Click (deferred from WMCustGetRec for mousey reasons)}
      1001 : begin
        bValidLine := FormStuff.aMulCtrlO[0].ValidLine;
        if bValidLine then begin

          {Get local copy of global record}
          ExLocal.AssignFromGlobal(CustF);
          ExLocal.LGetRecAddr(CustF);

          {Update details window}
          if (FrmCardDetails <> nil) then begin
            with FrmCardDetails do begin
              if (not ExLocal.InAddEdit) then UpdateDetails(TRUE);
            end;{with}
          end;{if}
        end;{if}
      end;
    end;{case}
  end;{with}
  inherited;
end;

procedure TFrmCardList2.WMCustGetRec(var Message  :  TMessage);
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

procedure TFrmCardList2.ShowDetailsExecute(Sender: TObject);
var
  fmFormMode : TFormMode;
begin
  fmFormMode := TFormMode(TWinControl(Sender).Tag);
  if (fmFormMode = fmAdd) or FormStuff.aMulCtrlO[0].ValidLine then begin {check for bug in first item of list !}
    if FrmCardDetails = nil then FrmCardDetails := TFrmCardDetails.Create(self);
    with FrmCardDetails do begin
      if not ExLocal.InAddEdit then begin
        if TWinControl(Sender).Name = 'btnLedger' then pcMain.ActivePage := tabLedger
        else if TWinControl(Sender).Name = 'btnNotes' then pcMain.ActivePage := tabNotes
             else if TWinControl(Sender).Name = 'btnLinks' then pcMain.ActivePage := tabLinks
                  else pcMain.ActivePage := tabDetails;

        if fmFormMode <> fmAdd then UpdateDetails(TRUE);

        if SetFormMode(fmFormMode) then Show
        else TillCommsError;
      end;{if}
    end;{with}
  end;{if}
end;

procedure TFrmCardList2.HeadersMouseDownExecute(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {depresses the column header}
  if (Sender is TSBSPanel) and (not TSBSPanel(Sender).ReadytoDrag) and (Button = MBLeft)
  then FormStuff.aMULCtrlO[0].VisiList.PrimeMove(Sender); {begin column drag/drop}
end;

procedure TFrmCardList2.HeadersMouseMoveExecute(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  {visually moves column header to show the change about to be made (drag/drop}
  if (Sender is TSBSPanel) then FormStuff.aMULCtrlO[0].VisiList.MoveLabel(X,Y);
end;

procedure TFrmCardList2.MoveAlignColsExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TSBSPanel) then DoMoveAlignCols(TSBSPanel(Sender), FormStuff, 0);
end;

procedure TFrmCardList2.ListProperties1Click(Sender: TObject);
{Change List Colours}
begin
{  ListProperties(Self, MULCtrlO, bSetDefaults, 'Card List Properties');}
end;

procedure TFrmCardList2.pmMainPopup(Sender: TObject);
var
  bValidLine : boolean;
begin
  {greys in / out the menu items as appropriate}
  bValidLine := FormStuff.aMulCtrlO[0].ValidLine;
  AddCard1.Enabled := bgCommsWorking and (not Syss.Club2000);
  Edit1.Enabled := bValidLine and bgCommsWorking;
  ShowDetails1.Enabled := bValidLine;
  SaveOnExit.Checked := FormStuff.bStoreCoord;
end;

procedure TFrmCardList2.SaveOnExitClick(Sender: TObject);
begin
  FormStuff.bStoreCoord := not FormStuff.bStoreCoord;
end;

procedure TFrmCardList2.FormResize(Sender: TObject);
begin
  DoFormResize(Self, FormStuff);
end;

procedure TFrmCardList2.btnSortListClick(Sender: TObject);
begin
  pmSortList.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TFrmCardList2.SortList(Sender: TObject);
var
  iPos, iKey : integer;
begin
  iKey := TMenuItem(Sender).Tag;

  {sorts the list in the selected order}
  with FormStuff.aMULCtrlO[0] do begin
    if (not InListFind) and (not TMenuItem(Sender).Checked)
    then StartList(ScanFileNum,iKey,KeyRef,'','',Length(KeyRef),FALSE);
  end;{with}

  {puts a tick by the current sort orders in the two menus}
  for iPos := 0 to pmSortList.Items.Count - 1 do pmSortList.Items[iPos].Checked := pmSortList.Items[iPos].Tag = iKey;
  for iPos := 0 to SortList1.Count - 1 do SortList1.Items[iPos].Checked := SortList1.Items[iPos].Tag = iKey;
  Caption := 'Card List - Sorted ' + TMenuItem(Sender).Caption;
end;

procedure TFrmCardList2.btnFindCardClick(Sender: TObject);
begin
  pmFindCard.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TFrmCardList2.FindCardInList(Sender: TObject);
var
  iStatus : smallint;
  sFind : Str255;
begin
  with FrmFindDlg do begin
    try
      {Show Find Form}
      FrmFindDlg := TFrmFindDlg.Create(Self);
      FindMode := TFindMode(TMenuItem(Sender).Tag);
      if ShowModal = mrOK then begin
        {find record}
        sFind := edValue.Text;
        iStatus := Find_Rec(B_GetGEq,F[CustF],CustF,RecPtr[CustF]^,Ord(FindMode),sFind);
        if (iStatus > 0) or
        ((TrimString(psRight,sFind,' ') <> edValue.Text) and (FindMode = fmCardNumber))
        then MsgBox('The find function could not find the specified value.',mtInformation,[mbOK],mbOK,edValue.Text)
        else begin
          Self.Refresh;
          SortList(Sender);
          FormStuff.aMULCtrlO[0].Find_OnList(sFind,Ord(FindMode)); {highlight found record}
        end;{if}
      end;{if}
    finally
      FrmFindDlg.Release;
    end;{try}
  end;{with}
end;

procedure TFrmCardList2.FormDestroy(Sender: TObject);
begin
  FormStuff.Free;
  ExLocal.Destroy;
end;

procedure TFrmCardList2.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmCardList2.FormActivate(Sender: TObject);
begin
  btnAdd.Enabled := bgCommsWorking and (not Syss.Club2000);
  btnEdit.Enabled := bgCommsWorking;
end;

end.


