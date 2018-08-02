unit Findcard;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, SBSPanel
  , StdCtrls, SBSComp, VarConst, ExWrap1U, GlobVar, btSupU2, btSupU1, CardDet, ETStrU, ActnList
  , Menus, AdPacket, OoMisc, AdPort, MPComms, NeilProc, BTList, BtrvU2, CardProc, Comms;

type
  TListOrder = (loCode, loSurname);

  TCardList  =  class(TMULCtrl)
    public
      ListOrder : TListOrder;
      function SetCheckKey : Str255; override;
      function SetFilter : Str255; override;
      function OutLine(Col : Byte) : Str255; override;
  end;

  TFrmFindCard = class(TForm)
    sbMain: TScrollBox;
    panCode: TSBSPanel;
    panName: TSBSPanel;
    panTitle: TSBSPanel;
    panCodeTitle: TSBSPanel;
    panNameTitle: TSBSPanel;
    panScrollBar: TSBSPanel;
    btnCancel: TButton;
    btnOK: TButton;
    procedure FormCreate(Sender: TObject);
    procedure MoveAlignColsExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HeadersMouseDownExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HeadersMouseMoveExecute(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
    procedure ListProperties1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    FormStuff : TFormStuff;
    ExLocal : TdExLocal;
    sFindString : string;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure WMCustGetRec(var Message : TMessage); message WM_CustGetRec;
  public
    constructor create(owner : TComponent; sFind : string);
  end;

  function DoFindCard(sFind : string) : CustRec;

var
  sCustCode : string;

implementation


uses FindDlg;

{$R *.DFM}


{TCardList}

function TCardList.SetCheckKey : Str255;
begin
  case ListOrder of
    loCode : SetCheckKey := Cust.CustCode;
    loSurname : SetCheckKey := UpperCase(Cust.Company + Cust.FirstName);
  end;{case}
end;

function TCardList.SetFilter  :  Str255;
begin
  Result := '';
end;

function TCardList.OutLine(Col : Byte) : Str255;
{defines which fields go in which columns}
begin
  with Cust do begin
    case Col of
      0  : OutLine := Cust.CustCode;  {Code}
      1  : OutLine := CardFullName(Cust, True, True);{Members Name}
    else OutLine := '';
    end;{case}
  end;{with}
end;


{TFrmCardList}

constructor TFrmFindCard.Create(Owner : TComponent; sFind : string);
begin
 inherited create(Owner);
 sFindString := sFind;
end;


procedure TFrmFindCard.FormCreate(Sender: TObject);
var
  iAscii : integer;
begin
  ExLocal.Create;
  FormStuff := TFormStuff.Create(1);

  with FormStuff do begin
    {set up an array of columns}
    bFillList := TRUE;
    SetLength(aColumns[0],2);
    aColumns[0,0].ColPanel := panCode;
    aColumns[0,0].HeadPanel := panCodeTitle;
    aColumns[0,1].ColPanel := panName;
    aColumns[0,1].HeadPanel := panNameTitle;

    aFileNos[0] := CustF;
    asbMain[0] := sbMain;
    acPrimeKeys[0] := 'A';
    apanTitle[0] := panTitle;
    asbButtons[0] := nil;
    apanButtons[0] := nil;
    aMULCtrlO[0] := TCardList.Create(Self);{creates control object}
    apanScrollBar[0] := panScrollBar;
    aCaseSensSearch[0] := TRUE;

    if sFindString = '' then
      begin
        {list all}
        TCardList(aMULCtrlO[0]).ListOrder := loCode;
        aiKeys[0] := CustCodeK;
        asStartKeys[0] := '';
      end
    else begin
      iAscii := ORD(sFindString[1]);
      if (iAscii >= 48) and (iAscii <= 57) then
        begin
          {find number}
          TCardList(aMULCtrlO[0]).ListOrder := loCode;
          aiKeys[0] := CustCodeK;
          asStartKeys[0] := sFindString;
        end
      else begin
        {find name}
        TCardList(aMULCtrlO[0]).ListOrder := loSurname;
        aiKeys[0] := CustCompK;
        asStartKeys[0] := sFindString;
      end;{if}
    end;{if}

    ReadFormProperties(Self, FormStuff);
    aMULCtrlO[0].ReColorBar(panScrollBar.Font,clMaroon);
    DoFormResize(Self, FormStuff);
  end;{with}
end;

procedure TFrmFindCard.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 363;
    ptMinTrackSize.Y := 200;
  end;{with}
  Message.Result := 0;
  inherited;
end;

procedure TFrmFindCard.WMCustGetRec(var Message  :  TMessage);
{Receive message that a List Action has occured}
begin
  with Message do begin
    case WParam of
      {List Double Click}
      0 : ;

      {List Click}
      1 : PostMessage(Self.Handle,WM_FormCloseMsg,1001,0); {* This was placed here to stop the mouse up event from being corrupted *}

      {List Right Click}
      2 : ;
    end;{case}
  end;{with}
  inherited;
end;

procedure TFrmFindCard.HeadersMouseDownExecute(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {depresses the column header}
  if (Sender is TSBSPanel) and (not TSBSPanel(Sender).ReadytoDrag) and (Button = MBLeft)
  then FormStuff.aMULCtrlO[0].VisiList.PrimeMove(Sender); {begin column drag/drop}
end;

procedure TFrmFindCard.HeadersMouseMoveExecute(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  {visually moves column header to show the change about to be made (drag/drop}
  if (Sender is TSBSPanel) then FormStuff.aMULCtrlO[0].VisiList.MoveLabel(X,Y);
end;

procedure TFrmFindCard.MoveAlignColsExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TSBSPanel) then DoMoveAlignCols(TSBSPanel(Sender), FormStuff, 0);
end;

procedure TFrmFindCard.ListProperties1Click(Sender: TObject);
{Change List Colours}
begin
{  ListProperties(Self, MULCtrlO, bSetDefaults, 'Card List Properties');}
end;

procedure TFrmFindCard.FormResize(Sender: TObject);
begin
  DoFormResize(Self, FormStuff);
end;

procedure TFrmFindCard.FormDestroy(Sender: TObject);
begin
  FormStuff.Free;
  ExLocal.Destroy;
end;

procedure TFrmFindCard.btnCloseClick(Sender: TObject);
begin
  Close;
end;

function DoFindCard(sFind : string) : CustRec;
var
  FrmFindCard : TFrmFindCard;
  CustR : CustRec;
begin
  try
    FrmFindCard := TFrmFindCard.Create(application, sFind);
    if FrmFindCard.ShowModal = mrOK then Result := Cust
    else begin
      FillChar(CustR, Sizeof(CustR),0);
      Result := CustR;
    end;{if}
  finally
    FrmFindCard.Release;
  end;{try}
end;


end.

