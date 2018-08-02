unit FuncBook;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, SBSPanel
  , StdCtrls, SBSComp, VarConst, ExWrap1U, GlobVar, btSupU2, btSupU1, CardDet, ETStrU, ActnList
  , Menus, AdPacket, OoMisc, AdPort, MPComms, NeilProc, BTList, BtrvU2, CardProc, Comms
  , FuncDet, ProcFunc, TCustom;

type
  TFuncList  =  class(TMULCtrl)
    public
      ListExLocal : TdExLocalPtr;
      function SetCheckKey : Str255; override;
      function SetFilter : Str255; override;
      function OutLine(Col : Byte) : Str255; override;
  end;

  TFrmFunctionList = class(TForm)
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
    Action1: TAction;
    btnClose: TSBSButton;
    AddCard1: TMenuItem;
    N2: TMenuItem;
    btnAdd: TSBSButton;
    btnEdit: TSBSButton;
    btnShowDetails: TSBSButton;
    panDesc: TSBSPanel;
    panDescTitle: TSBSPanel;
    btnProcess: TSBSButton;
    panCat: TSBSPanel;
    panCatTitle: TSBSPanel;
    btnPrint: TSBSButton;
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
    procedure btnProcessClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FormStuff : TFormStuff;
    ExLocal : TdExLocal;
    FrmFunctionDetails : TFrmFunctionDetails;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure WMFormCloseMsg(var Message : TMessage); message WM_FormCloseMsg;
    procedure WMCustGetRec(var Message : TMessage); message WM_CustGetRec;
  public

  end;

const
  OpMode = 2;
  DefClientHeight = 345;
  DefClientWidth  = 705;

{var
  FrmCardList: TFrmCardList2;}

implementation


uses FindDlg;

{$R *.DFM}


{TFuncList}

function TFuncList.SetCheckKey : Str255;
begin
  SetCheckKey := Inv.CustCode;
end;

function TFuncList.SetFilter  :  Str255;
begin
  Result := FuncKey;
end;

function TFuncList.OutLine(Col : Byte) : Str255;
{defines which fields go in which columns}
begin
  with Inv do begin
    if ListExLocal.LCust.CustCode <> Inv.FBookCust then begin
      ListExLocal.AssignFromGlobal(InvF);
      GetCustFromInv(ListExLocal^, TRUE);
    end;{if}

    case Col of
      0  : OutLine := ListExLocal.LCust.CustCode;  {Cust Code}
      1  : OutLine := CardFullName(ListExLocal.LCust, True, True);{Members Name}
      2  : OutLine := MoneyToStr(ListExLocal.LCust.CurrBalance); {Balance}
      3  : OutLine := MoneyToStr(InvNetVal); {Amount}
      4  : OutLine := MoneyToStr(Discount); {Discount}
      5  : OutLine := TransDesc; {Description}
      6  : OutLine := CHR(65 + FBookCat); {Category}
    else OutLine := '';
    end;{case}
  end;{with}
end;


{TFrmCardList}

procedure TFrmFunctionList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FrmFunctionDetails <> nil then FrmFunctionDetails.Close;

  Application.ProcessMessages; {so it doesn't crash hideously !}
  with FormStuff do begin
    StoreFormProperties(Self, OpMode, bStoreCoord, bSetDefaults, bLastCoord
    , apanTitle, aMULCtrlO, acPrimeKeys);
  end;{with}
  SendMessage(TForm(Owner).Handle,WM_FormCloseMsg,4,0);
  action := caFree;
end;

procedure TFrmFunctionList.FormCreate(Sender: TObject);
begin
  ExLocal.Create;
  FormStuff := TFormStuff.Create(1);

  {set default size}
  ClientHeight := DefClientHeight;
  ClientWidth := DefClientWidth;

  with FormStuff do begin
    {set up an array of columns}
    bFillList := TRUE;
    SetLength(aColumns[0],7);
    aColumns[0,0].ColPanel := panCode;
    aColumns[0,0].HeadPanel := panCodeTitle;
    aColumns[0,1].ColPanel := panName;
    aColumns[0,1].HeadPanel := panNameTitle;
    aColumns[0,2].ColPanel := panMemCode;
    aColumns[0,2].HeadPanel := panMemCodeTitle;
    aColumns[0,2].DecPlaces := 2;
    aColumns[0,3].ColPanel := panCategory;
    aColumns[0,3].HeadPanel := panCategoryTitle;
    aColumns[0,3].DecPlaces := 2;
    aColumns[0,4].ColPanel := panPhone;
    aColumns[0,4].HeadPanel := panPhoneTitle;
    aColumns[0,4].DecPlaces := 2;
    aColumns[0,5].ColPanel := panDesc;
    aColumns[0,5].HeadPanel := panDescTitle;
    aColumns[0,6].ColPanel := panCat;
    aColumns[0,6].HeadPanel := panCatTitle;

    aFileNos[0] := InvF;
    asbMain[0] := sbMain;
    acPrimeKeys[0] := 'A';
    apanTitle[0] := panTitle;
    asbButtons[0] := nil;
    apanButtons[0] := panButtons;
    aMULCtrlO[0] := TFuncList.Create(Self);{creates control object}
    (aMULCtrlO[0] as TFuncList).ListExLocal := @ExLocal;
    apanScrollBar[0] := panScrollBar;
    aCaseSensSearch[0] := TRUE;
    aiKeys[0] := InvCustK;
    asStartKeys[0] := FuncKey;

    ReadFormProperties(Self, FormStuff);
    aMULCtrlO[0].ReColorBar(panScrollBar.Font,$00003973);
    DoFormResize(Self, FormStuff);
  end;{with}
end;

procedure TFrmFunctionList.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 363;
    ptMinTrackSize.Y := 221;
  end;{with}
  Message.Result := 0;
  inherited;
end;

procedure TFrmFunctionList.WMFormCloseMsg(var Message : TMessage);
{receive a message that a child window has closed}
var
  bValidLine : boolean;
begin
  with Message do begin
    case WParam of
      {Details Form Close}
      1 : FrmFunctionDetails := nil;

      {List Click (deferred from WMCustGetRec for mousey reasons)}
      1001 : begin
        bValidLine := FormStuff.aMulCtrlO[0].ValidLine;
        if bValidLine then begin

          {Get local copy of global record}
          ExLocal.AssignFromGlobal(CustF);
          ExLocal.LGetRecAddr(CustF);

          {Update details window}
          if (FrmFunctionDetails <> nil) then begin
            with FrmFunctionDetails do begin
              if (not ExLocal.InAddEdit) then UpdateDetails(TRUE);
            end;{with}
          end;{if}
        end;{if}
      end;
    end;{case}
  end;{with}
  inherited;
end;

procedure TFrmFunctionList.WMCustGetRec(var Message  :  TMessage);
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

      {Re-Read List}
      201 : FormStuff.aMULCtrlO[0].InitPage;
    end;{case}
  end;{with}
  inherited;
end;

procedure TFrmFunctionList.ShowDetailsExecute(Sender: TObject);
var
  fmFormMode : TFormMode;
begin
  fmFormMode := TFormMode(TWinControl(Sender).Tag);
  if (fmFormMode = fmAdd) or FormStuff.aMulCtrlO[0].ValidLine then begin {check for bug in first item of list !}

    if FrmFunctionDetails = nil then FrmFunctionDetails := TFrmFunctionDetails.Create(self);

    with FrmFunctionDetails do begin
      if not ExLocal.InAddEdit then begin
        if fmFormMode <> fmAdd then UpdateDetails(TRUE);
        if SetFormMode(fmFormMode) then Show
        else TillCommsError;
      end;{if}
    end;{with}
  end;{if}
end;

procedure TFrmFunctionList.HeadersMouseDownExecute(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {depresses the column header}
  if (Sender is TSBSPanel) and (not TSBSPanel(Sender).ReadytoDrag) and (Button = MBLeft)
  then FormStuff.aMULCtrlO[0].VisiList.PrimeMove(Sender); {begin column drag/drop}
end;

procedure TFrmFunctionList.HeadersMouseMoveExecute(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  {visually moves column header to show the change about to be made (drag/drop}
  if (Sender is TSBSPanel) then FormStuff.aMULCtrlO[0].VisiList.MoveLabel(X,Y);
end;

procedure TFrmFunctionList.MoveAlignColsExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TSBSPanel) then DoMoveAlignCols(TSBSPanel(Sender), FormStuff, 0);
end;

procedure TFrmFunctionList.ListProperties1Click(Sender: TObject);
{Change List Colours}
begin
{  ListProperties(Self, MULCtrlO, bSetDefaults, 'Card List Properties');}
end;

procedure TFrmFunctionList.pmMainPopup(Sender: TObject);
var
  bValidLine : boolean;
begin
  {greys in / out the menu items as appropriate}
  bValidLine := FormStuff.aMulCtrlO[0].ValidLine;
  SaveOnExit.Checked := FormStuff.bStoreCoord;
  ShowDetails1.Enabled := bValidLine;
  Edit1.Enabled := bValidLine;
end;

procedure TFrmFunctionList.SaveOnExitClick(Sender: TObject);
begin
  FormStuff.bStoreCoord := not FormStuff.bStoreCoord;
end;

procedure TFrmFunctionList.FormResize(Sender: TObject);
begin
  DoFormResize(Self, FormStuff);
end;

procedure TFrmFunctionList.FormDestroy(Sender: TObject);
begin
  FormStuff.Free;
  ExLocal.Destroy;
end;

procedure TFrmFunctionList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmFunctionList.btnProcessClick(Sender: TObject);
var
  FrmProcessFunction : TFrmProcessFunction;
begin
  FrmProcessFunction := TFrmProcessFunction.Create(Self);
  Try
    with FrmProcessFunction do begin
      if TSBSButton(Sender).Name = 'btnPrint' then FuncFormMode := fmPrint
      else begin
        if TSBSButton(Sender).Name = 'btnProcess' then FuncFormMode := fmProcess
      end;{if}
      ShowModal;
    end;{with}
  Finally
    FrmProcessFunction.Release;
  End;
end;

procedure TFrmFunctionList.FormActivate(Sender: TObject);
begin
  btnProcess.Enabled := bgCommsWorking;
end;

end.

