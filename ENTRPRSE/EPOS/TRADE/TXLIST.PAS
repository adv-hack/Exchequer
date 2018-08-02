unit TXList;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, SBSPanel
  , StdCtrls, SBSComp, VarConst, ExWrap1U, GlobVar, btSupU2, btSupU1, ETStrU, Menus, OoMisc
  , StrUtil, BTList, BtrvU2, APIUtil, TCustom, EPOSKey;
type
  TTXList = class(TMULCtrl)
    public
      bTCM : boolean;
      iCheckIndex : integer;
      function SetCheckKey : Str255; override;
      function SetFilter : Str255; override;
      function OutLine(Col : Byte) : Str255; override;
  end;

  TFrmTXList = class(TForm)
    sbMain: TScrollBox;
    panReference: TSBSPanel;
    panCustCode: TSBSPanel;
    panTitle: TSBSPanel;
    panReferenceTit: TSBSPanel;
    panCustCodeTit: TSBSPanel;
    panScrollBar: TSBSPanel;
    panCustName: TSBSPanel;
    panCustNameTit: TSBSPanel;
    panOrderNo: TSBSPanel;
    panOrderNoTit: TSBSPanel;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MoveAlignColsExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HeadersMouseDownExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HeadersMouseMoveExecute(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure WMCustGetRec(var Message : TMessage); message WM_CustGetRec;
  public
    FormStuff : TFormStuff;
    iIndexNo : integer;
    sKey : str255;
  end;

const
  OpMode = 2;
  DefClientHeight = 279;
  DefClientWidth  = 447;

implementation
uses
  EPOSCnst, BackGrnd;


{$R *.DFM}


{TTXList}
function TTXList.SetCheckKey : Str255;
begin
  case iCheckIndex of
    1 : SetCheckKey := Inv.CustCode;
    2 : SetCheckKey := Inv.OurRef;
    6 : SetCheckKey := Inv.YourRef;
    8 : SetCheckKey := Inv.TransDesc;
  end;{case}
end;

function TTXList.SetFilter  :  Str255;
begin
  if bTCM then
    begin
      {Only include SINs, SRIs, SORs, SRFs and SCRs AND Exclude Non-EPOS Transactions}
      if ((Copy(Inv.OurRef,1,3) = 'SIN') or (Copy(Inv.OurRef,1,3) = 'SRI')
      or (Copy(Inv.OurRef,1,3) = 'SOR') or (Copy(Inv.OurRef,1,3) = 'SRF')
      or (Copy(Inv.OurRef,1,3) = 'SCR'))
      and (Copy(Inv.DocUser4, 1, 4) = 'EPOS') then Result := #0
      else Result := #254;
    end
  else begin
    {Only include SINs, SJIs, SJCs, SCRs}
    if ((Copy(Inv.OurRef,1,3) = 'SIN') or (Copy(Inv.OurRef,1,3) = 'SJI')
    or (Copy(Inv.OurRef,1,3) = 'SJC') or (Copy(Inv.OurRef,1,3) = 'SCR')
    //GS 13/02/2012 ABSEXCH-11187: added SQU to the inclusive filter
    or (Copy(Inv.OurRef,1,3) = 'SQU'))
    and (Copy(Inv.OurRef, 9, 1) <> 'A') {.224} then Result := #0
    else Result := #254;
  end;{if}
end;

function TTXList.OutLine(Col : Byte) : Str255;
{defines which fields go in which columns}
begin
  with Inv do begin
    case Col of
      0  :  OutLine := OurRef;  {Code}
      1  :  OutLine := CustCode;   {Members Name}
      2  :  OutLine := YourRef;    {Club Member Code}
      3  :  OutLine := TransDesc;    {Club Member Code}
    else OutLine := '';
    end;{case}
  end;{with}
end;


procedure TFrmTXList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.ProcessMessages; {so it doesn't crash hideously !}
  with FormStuff do begin
    StoreFormProperties(Self, OpMode, bStoreCoord, bSetDefaults, bLastCoord
    , apanTitle, aMULCtrlO, acPrimeKeys);
  end;{with}
  SendMessage(TForm(Owner).Handle,WM_FormCloseMsg,2,0);
end;

procedure TFrmTXList.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 368;
    ptMinTrackSize.Y := 225;
  end;{with}
  Message.Result := 0;
  inherited;
end;

procedure TFrmTXList.WMCustGetRec(var Message  :  TMessage);
{Receive message that a List Action has occured}
begin
  with Message do begin
    case WParam of
      {List Double Click}
      0 : ModalResult := mrOK;

      {List Click}
      1 : PostMessage(Self.Handle,WM_FormCloseMsg,1001,0); {* This was placed here to stop the mouse up event from being corrupted *}

      {List Right Click}
      2 : begin
        {SaveOnExit.Checked := FormStuff.bStoreCoord;}
        {pmMain.Popup(lParamLo,lParamHi);}
      end;

      {Update List Item}
      200 : FormStuff.aMULCtrlO[0].AddNewRow(FormStuff.aMULCtrlO[0].MUListBoxes[0].Row,FALSE);
    end;{case}
  end;{with}
  inherited;
end;

procedure TFrmTXList.HeadersMouseDownExecute(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {depresses the column header}
  if (Sender is TSBSPanel) and (not TSBSPanel(Sender).ReadytoDrag) and (Button = MBLeft)
  then FormStuff.aMULCtrlO[0].VisiList.PrimeMove(Sender); {begin column drag/drop}
end;

procedure TFrmTXList.HeadersMouseMoveExecute(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  {visually moves column header to show the change about to be made (drag/drop}
  if (Sender is TSBSPanel) then FormStuff.aMULCtrlO[0].VisiList.MoveLabel(X,Y);
end;

procedure TFrmTXList.MoveAlignColsExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TSBSPanel) then DoMoveAlignCols(TSBSPanel(Sender), FormStuff, 0);
end;

procedure TFrmTXList.FormResize(Sender: TObject);
begin
  DoFormResize(Self, FormStuff);
end;

procedure TFrmTXList.FormDestroy(Sender: TObject);
begin
  FormStuff.Free;
end;

procedure TFrmTXList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmTXList.FormShow(Sender: TObject);
begin
  with TTXList(FormStuff.aMULCtrlO[0]) do begin
    iCheckIndex := iIndexNo;
    StartList(InvF,iIndexNo,sKey,'','',Length(sKey), FALSE);
    SetListFocus;
  end;{with}
  Screen.Cursor := crDefault;
end;

procedure TFrmTXList.FormCreate(Sender: TObject);
begin
  FormStuff := TFormStuff.Create(1);

  {set default size}
  ClientHeight := DefClientHeight;
  ClientWidth := DefClientWidth;

  with FormStuff do begin
    {set up an array of columns}
    bFillList := FALSE;
    SetLength(aColumns[0],4);
    aColumns[0,0].ColPanel := panReference;
    aColumns[0,0].HeadPanel := panReferenceTit;
    aColumns[0,1].ColPanel := panCustCode;
    aColumns[0,1].HeadPanel := panCustCodeTit;
    aColumns[0,2].ColPanel := panOrderNo;
    aColumns[0,2].HeadPanel := panOrderNoTit;
    aColumns[0,3].ColPanel := panCustName;
    aColumns[0,3].HeadPanel := panCustNameTit;

    aFileNos[0] := InvF;
    asbMain[0] := sbMain;
    acPrimeKeys[0] := 'A';
    apanTitle[0] := panTitle;
    asbButtons[0] := nil;
    apanButtons[0] := nil;
    aMULCtrlO[0] := TTXList.Create(Self);{creates control object}
    apanScrollBar[0] := panScrollBar;
    aiKeys[0] := 0;
    asStartKeys[0] := '';
    aCaseSensSearch[0] := FALSE;

    ReadFormProperties(Self, FormStuff);
    aMULCtrlO[0].ReColorBar(panScrollBar.Font,clRed);
    DoFormResize(Self, FormStuff);
  end;{with}
  btnOK.Top := 248;
  btnOK.Left := 263;
  btnCancel.Top := 248;
  btnCancel.Left := 342;
end;

procedure TFrmTXList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LocalKey : Word;
begin
  LocalKey := Key;
  Key := 0;

  {trap function Keys}
{  If (LocalKey In [VK_F1..VK_F12]) and (Not (ssAlt In Shift)) then
    begin
      case LocalKey of
        VK_F1 : Application.HelpCommand(HELP_Finder,0);
        else Key := LocalKey;
      end;{case}
{    end
  else Key := LocalKey;}
  Key := LocalKey;
end;

end.


