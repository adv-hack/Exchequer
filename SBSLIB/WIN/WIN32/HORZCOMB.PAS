unit HorzComb;

interface


uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus;

type
  TBarStyle    = (bsLowered,bsRaised);
  TOrientation = (orVertical,orHorizontal);
  TThumbStyle  = (tsBar1,tsBar2,tsBar3,tsBar4,tsCircle1,tsSquare1,
                  tsDiamond1,tsDiamond2,tsDiamond3,tsDiamond4);
  THorzCombo= class(TCustomControl)
  private
    FLabels                  : TStringList;
    FMax,FMin,FPosition      : Integer;
    FOrientation             : TOrientation;

    fBkGdBmp                 : TBitmap;

    procedure SetLabels(A: TStringList);
    procedure SetMax(A: Integer);
    procedure SetMin(A: Integer);
    procedure SetOrientation(A: TOrientation);
    procedure SetPosition(A: Integer);
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMEraseBkGnd(var Message: TMessage); message WM_EraseBkGnd;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  protected
    Dragging                 : Boolean;

    procedure BuildList;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Enabled;
    property Labels: TStringList read FLabels write SetLabels;
    property Max: Integer read FMax write SetMax default 10;
    property Min: Integer read FMin write SetMin default 1;
    property Orientation: TOrientation read FOrientation
                          write SetOrientation default orHorizontal;
    property ParentShowHint;
    property Position: Integer read FPosition write SetPosition default 1;
    property PopupMenu;
    property ShowHint;

    property TabStop default True;
    property TabOrder;
    property Visible;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;

  end;

procedure Register;

implementation



procedure Register;
begin
  RegisterComponents('Standard', [THorzCombo]);
end;

(******************
 THorzCmbo Methods
******************)

constructor THorzCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Height := 15;
  Width := 100;
  fBkgdBmp := TBitmap.Create;
  FLabels := TStringList.Create;
  FMin := 1;
  FMax := 1000;
  FOrientation := orHorizontal;
  FPosition := 1;
  TabStop := True;
  BuildList;
end;

destructor THorzCombo.Destroy;
begin
  FLabels.Free;
  fBkgdBmp.Free;
  inherited Destroy;
end;

procedure THorzCombo.CMEnter(var Message: TCMGotFocus);
begin
  inherited;

  Refresh;
end;

procedure THorzCombo.CMExit(var Message: TCMExit);
begin
  inherited;
  Refresh;
end;


procedure THorzCombo.KeyDown(var Key: Word; Shift: TShiftState);
var
  b : Integer;
begin
  b:=Position;
  case Key of
    VK_Left : if (b > Min) then
                 Dec(b);

    VK_Right
             : if (b < 99999) then
                 Inc(b)
               else
                 MessageBeep(0);

    VK_Prior : if (b > Min+10) then
                 b:=b-10;

    VK_Next  : if (b < 99999) then
                 b:=b+10;

    VK_END   : b:=fBkgdBmp.Width-Width;
    VK_HOME  : b:=Min;
  end;

  Position:=b;
end;

procedure THorzCombo.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;

end;


procedure THorzCombo.WMEraseBkGnd(var Message: TMessage);
begin
  {* Ignore erase background instructions *}

  
  Message.Result := 1;

end;


procedure THorzCombo.SetLabels(A: TStringList);
begin
  FLabels.Assign(A);
end;

procedure THorzCombo.SetMin(A: Integer);
begin
  FMin := A;
  Refresh;
end;

procedure THorzCombo.SetMax(A: Integer);
begin
  FMax := A;
  Refresh;
end;

procedure THorzCombo.SetOrientation(A: TOrientation);
begin

  FOrientation := A;
  Refresh;
end;

procedure THorzCombo.SetPosition(A: Integer);
begin
  if csDesigning in ComponentState then
    begin
      if (A >= Min) and (A <= Max) Then FPosition := A;
      Refresh;
    end
  else
    begin
      if (A >= Min) and (A <= Max) Then FPosition := A;

      Refresh;
      {if Assigned(FOnChange) then FOnChange(Self);}
    end;
end;


procedure THorzCombo.BuildList;

Var
  n      :  Integer;
  HList  :  String;

Begin
  HList:='';



  With Labels do
  Begin

    For n:=1989 to 1999 do
      Add(IntToStr(n));

    For n:=0 to Pred(Count) do
      HList:=HList+Labels[n]+'     ';

  end;

  try
    With fBkgdBmp,Canvas do
    Begin

      Width:=TextWidth(HList);
      Height:=TextHeight(HList);

      Pen.Color:=clBlack;
      Pen.Style:=psSolid;
      Font.Color:=clBlack;
      Brush.Color:=clWhite;
      TextOut(0,0,HList);

    end; {With..}

  except

    fBkgdBmp.Free;

  end; {try..}
end; {Proc.}


procedure THorzCombo.Paint;

Var
  R1,SR  :  TRect;

begin
  With Canvas do
  Begin
    R1:=Rect(0,0,Width,Height);
    SR:=Rect(Position,0,Width+Position,Height);

    Pen.Color:=clBlack;
    Pen.Style:=psSolid;
    Font.Color:=clBlack;
    Brush.Color:=clWhite;

    CopyRect(R1,fBkgdBmp.Canvas,SR);

  end; {With..}
end;

end.