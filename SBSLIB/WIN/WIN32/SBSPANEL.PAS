unit SBSPanel;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Buttons,

  {$IFDEF PKG_On}
    DesignEditors,
    {DesignIntF,}
  {$ENDIF}

  ExtCtrls;

type
  TCloseUpEvent = procedure(Sender: TObject) of object;

  // MH 18/06/2012 v7.0 ABSEXCH-12952: Added enumeration to control custom painting in TSBSPanel component
  TSBSPanelPurpose = (puDefault=0, puBtrListColumnHeader=1, puBtrListColumnHeaderDragging=2, puBtrListColumn=3, puFrame=4);

  TSBSPanel = class(TPanel)
  private
    { Private declarations }
    FRunTimRS   :  Boolean;
    FIsGroupBox : Boolean;
    FTextId     : LongInt;

    // MH 18/06/2012 v7.0 ABSEXCH-12952: Added Purpose property for UI customisation
    FPurpose : TSBSPanelPurpose;

    // MH 18/06/2012 v7.0 ABSEXCH-12952: Added Purpose property for UI customisation
    Procedure SetPurpose (Value : TSBSPanelPurpose);
  protected
    { Protected declarations }
    FHitTest   : TPoint;

    FWChange   : Boolean;


    Function CheckReSize  :  Boolean;

    procedure CreateParams(var Params: TCreateParams); override;


    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

    Procedure Paint; Override;
    Procedure SetIsGroupBox (Value : Boolean);

  public
    CurrWidth  : LongInt;

    ReadytoDrag
               : Boolean;

    OrigRect   : TRect;


    procedure Assign(Source: TPersistent); override;

    { Public declarations }
    Property Resized  :  Boolean Read CheckReSize Write FWChange;

    constructor Create(AOwner: TComponent); Override;
  published
    { Published declarations }

    Property AllowReSize  :  Boolean  Read FRunTimRS Write FRunTimRS;
    Property IsGroupBox : Boolean read FIsGroupBox write SetIsGroupBox;
    Property TextId : LongInt Read FTextId Write FTextId;

    // MH 18/06/2012 v7.0 ABSEXCH-12952: Added Purpose property for UI customisation
    Property Purpose : TSBSPanelPurpose Read FPurpose Write SetPurpose default puDefault;
  end;

{ ==============================================================================}

  TSBSGroup = class(TSBSPanel)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
  end;

{ ==============================================================================}


  TSBSExtendedForm = class(TScrollBox)
  private
    { Private declarations }
    FOrigHeight,
    FOrigWidth,
    FOrigTop,
    FOrigLeft,
    FNewSTop,
    FNewSLeft,
    FExpandHeight,
    FExpandWidth,
    FArrowX,
    FArrowY,
    FOrigTabOrder
                    :  LongInt;

    FShowHorzSB,
    FShowVertSB,

    FForceFocus,
    FExitDirec,
    HSBWasVisible,
    VSBWasVisible,
    IsWider,
    ClickFirst,
    ViaClick        :  Boolean;

    FArrowPos       :  TAlign;

    FOrigParent,
    FFirstFocus,
    FLastFocus,
    FLastControl,
    FPreTab,
    OverrideFocus,
    FNextTab        :  TWinControl;

    FNewParent      :  TForm;


    CImage          :  TImage;
    FOnCloseUp: TCloseUpEvent;



    function  GetArwAlign: TAlign;
    procedure SetArwAlign(const Value:TAlign);
    Procedure SetArrowX(Value  :  LongInt);
    Procedure SetArrowY(Value  :  LongInt);

    Procedure SetOrigHeight(Value  :  LongInt);
    Procedure SetOrigWidth(Value  :  LongInt);
    Procedure SetOrigLeft(Value  :  LongInt);
    Procedure SetOrigTop(Value  :  LongInt);
    Procedure SetExpandWidth(Value  :  LongInt);
    Procedure SetExpandHeight(Value  :  LongInt);
    Procedure SetOrigTabOrder(Value  :  LongInt);
    Procedure SetShowHorzSB(Value  :  Boolean);
    Procedure SetShowVertSB(Value  :  Boolean);
    Procedure SetForceFocus (Value  :  Boolean);

    Procedure SetOrigParent(Value  :  TWinControl);
    Procedure SetNewParent(Value  :  TForm);
    Procedure SetFocusFirst(Value  :  TWinControl);
    Procedure SetFocusLast(Value  :  TWinControl);
    Procedure SetLastControl(Value  :  TWinControl);
    Procedure SetTabPrev(Value  :  TWinControl);
    Procedure SetTabNext(Value  :  TWinControl);

    Procedure CreateBevel;

    procedure PanelClick(Sender: TObject);

    procedure SetSubParent;

    procedure PosArrow(Wider  :  Boolean);

    procedure BuildArrow(Wider  :  Byte);

    procedure CheckOtherFocus;

    procedure CMExecuteEnter;
    procedure CMExecuteExit;

    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit);   message CM_EXIT;

    procedure CtrlFocus(var Message: TMessage);   message WM_User+1;

    procedure ProcessComboDrop(CBHandle  :  LongInt);


  protected

    procedure Click; override;

    Procedure Loaded; override;
  public
    { Public declarations }
    //InnerPanel      :  TSBSPanel;
    InnerPanel      :  TBevel;
    { Protected declarations }

    DropCBHandle    :  Integer;

    ReadyForCombo,
    NewSetting  :  Boolean;


    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;

    procedure ShowExpanded;

    procedure ShowNormal;

    procedure ForceClose;

    procedure ReAssignFocusLast;


    Property  OrigLeft: LongInt read FOrigLeft write SetOrigLeft default 0;
    Property  OrigTop: LongInt read FOrigTop write SetOrigTop default 0;
    Property  ForceFocus: Boolean read FForceFocus write FForceFocus;
    Property  ExitDirec : Boolean read FExitDirec write FExitDirec;
    Property  LastControl: TWinControl read FLastControl write SetLastControl;


  published
    { Published declarations }

    property ArrowPos : TAlign read GetArwAlign write SetArwAlign default alRight;
    Property  ArrowX: LongInt read FArrowX write SetArrowX default 0;
    Property  ArrowY: LongInt read FArrowY write SetArrowY default 0;

    Property  OrigHeight: LongInt read FOrigHeight write SetOrigHeight default 0;
    Property  OrigWidth: LongInt read FOrigWidth write SetOrigWidth default 0;
    Property  ExpandedWidth: LongInt read FExpandWidth Write SetExpandWidth default 0;
    Property  ExpandedHeight: LongInt read FExpandHeight Write SetExpandHeight default 0;
    Property  OrigTabOrder: LongInt read FOrigTabOrder write SetOrigTabOrder default 0;
    Property  ShowHorzSB  : Boolean read FShowHorzSB write SetShowHorzSB;
    Property  ShowVertSB  : Boolean read FShowVertSB write SetShowVertSB;

    Property  OrigParent: TWinControl read FOrigParent write SetOrigParent;
    Property  NewParent: TForm read FNewParent write SetNewParent;
    Property  FocusFirst: TWinControl read FFirstFocus write SetFocusFirst;
    Property  FocusLast: TWinControl read FLastFocus write SetFocusLast;
    Property  TabPrev: TWinControl read FPreTab write SetTabPrev;
    Property  TabNext: TWinControl read FNextTab write SetTabNext;

    property OnCloseUp: TCloseUpEvent read FOnCloseUp write FOnCloseUp;

  end;


{ ==============================================================================}


{$IFDEF PKG_On}
  TSBSExtFormEditor = Class(TComponentEditor)
    Function  GetVerbCount : Integer; Override;
    Function  GetVerb(Index : Integer) : String; Override;
    Procedure ExecuteVerb(Index : Integer); Override;
  End; { TExtFormEditor }
{$ENDIF}

{ ==============================================================================}


  TSBSCBox = class(TPanel)
  private
    { Private declarations }

    EMask  :  TCustomEdit;
    EBtn   :  TBitBtn;
  protected
    { Protected declarations }
    Procedure Resize; Override;

  public
    constructor Create(AOwner: TComponent); Override;
  published
    { Published declarations }

  end;


{procedure Register;}

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$R SBSRES2.RES}


Uses
  Mask;
  
constructor TSBSPanel.Create(AOwner: TComponent);
begin
  Inherited Create (AOwner);

  FIsGroupBox := False;
  FTextId := 0;

  // MH 18/06/2012 v7.0 ABSEXCH-12952: Added Purpose property for UI customisation
  FPurpose := puDefault;
end;

procedure TSBSPanel.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle and not WS_EX_CONTROLPARENT;
end;



Function TSBSPanel.CheckReSize  :  Boolean;

Begin
  Result:=FWChange;

  FWChange:=False;
end;

procedure TSBSPanel.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  inherited;
  FHitTest := SmallPointToPoint(Msg.Pos);
end;

procedure TSBSPanel.WMSetCursor(var Msg: TWMSetCursor);
var
  Cur: HCURSOR;
  I: Integer;
  X: Integer;
begin
  Cur := 0;

  ReadytoDrag:=False;

  FHitTest := ScreenToClient(FHitTest);

  with Msg do
  Begin
    if (HitTest = HTCLIENT) and (AllowReSize) then
    Begin
      If (FHitTest.X>=(Width-1)) and (FHitTest.X<=Width) and (FHitTest.Y>=0) and (FHitTest.Y<=Height) then
      begin
        Cur := LoadCursor(0, IDC_SIZEWE);
        ReadytoDrag:=TRUE;
      end;
    end;
  end;

  If (Cur<>0) then
    SetCursor(Cur)
  else
    Inherited;
end;


procedure TSBSPanel.Assign(Source: TPersistent);
var
  Panel  : TSBSPanel;
begin
  if Source is TSBSPanel then
  begin
    Panel:= TSBSPanel(Source);

    AllowResize:=Panel.AllowResize;

    Left:=Panel.Left;
    Top:=Panel.Top;
    Width:=Panel.Width;
    Height:=Panel.Height;
    Color:=Panel.Color;
    Font.Assign(Panel.Font);
    BevelInner:=Panel.BevelInner;
    BevelOuter:=Panel.BevelOuter;
    TabOrder:=Panel.TabOrder;

    Align:=Panel.Align;
    Alignment:=Panel.Alignment;
    BevelWidth:=Panel.BevelWidth;
    BorderStyle:=Panel.BorderStyle;
    DragCursor:=Panel.DragCursor;
    DragMode:=Panel.DragMode;
    Ctl3d:=Panel.Ctl3d;
    ParentColor:=Panel.ParentColor;
    ParentFont:=Panel.ParentFont;
    ParentShowHint:=Panel.ParentShowHint;
    PopUpMenu:=Panel.PopUpMenu;
    ShowHint:=Panel.ShowHint;
    TabStop:=Panel.TabStop;
    Enabled:=Panel.Enabled;
    Visible:=Panel.Visible;
    OnClick:=Panel.OnClick;
    OnDblClick:=Panel.OnDblClick;
    OnDragDrop:=Panel.OnDragDrop;
    OnDragOver:=Panel.OnDragOver;
    OnEndDrag:=Panel.OnEndDrag;
    OnEnter:=Panel.OnEnter;
    OnExit:=Panel.OnExit;
    OnMouseDown:=Panel.OnMouseDown;
    OnMouseMove:=Panel.OnMouseMove;
    OnMouseUp:=Panel.OnMouseUp;
    OnResize:=Panel.OnResize;
    OnStartDrag:=Panel.OnStartDrag;

  end;
end; {Proc..}


procedure TSBSPanel.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

Var
  ScreenDC,
  ParentDC    :  HDC;
  AvailRect   :  TRect;
  ClipIdx     :  Integer;

begin
  inherited MouseDown(Button, Shift, X, Y);

  if (Button = mbLeft) and (ReadytoDrag) then
  Begin

    {BringToFront;}
    SetCapture(Handle);
    OrigRect:=BoundsRect;

    AvailRect:=Canvas.ClipRect;

    With OrigRect do {* Adjust to clipped area *}
    Begin
      Right:=Left+AvailRect.Right;
      Bottom:=Top+AvailRect.Bottom;

      TopLeft:=Parent.ClientToScreen(Point(Left,Top));
      BottomRight:=Parent.ClientToScreen(Point(Right,Bottom));
    end;

    ScreenDC:=GetDC(0);

    DrawFocusRect(ScreenDC,OrigRect);
    ReleaseDC(0,ScreenDC);

  end;

  CurrWidth:=Width;
end;


procedure TSBSPanel.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);

Var
  ScreenDC  :  HDC;

begin
  If (Button=mbLeft) then
  Begin
    if (ReadytoDrag) then
    begin
      ScreenDC:=GetDC(0);

      DrawFocusRect(ScreenDC,OrigRect);

      ReleaseDC(0,ScreenDC);

      Width:=OrigRect.Right-OrigRect.Left;

      Refresh;
      ReleaseCapture;
      ReadytoDrag:=FALSE;
    end;

    Resized:=(Width<>CurrWidth);
  end;
  
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSBSPanel.MouseMove(Shift: TShiftState; X, Y: Integer);

Var
  ScreenDC  :  HDC;
  NewX      :  Integer;
  Bounds    :  TPoint;

  ImmParent :  TWinControl;

begin
  inherited MouseMove(Shift, X, Y);

  if (GetCapture = Handle) and (ReadytoDrag) then
  begin
    {Width:=X+3;

    Refresh;}

    ScreenDC:=GetDC(0);

    DrawFocusRect(ScreenDC,OrigRect);


    NewX:=X+OrigRect.Left;

    ImmParent:=Parent.Parent;

    If (ImmParent=nil) then
      ImmParent:=Parent;

    With ImmParent do
      Bounds:=ClienttoScreen(Point(Width-10,Top));

    If (NewX<Bounds.X) then
      OrigRect.Right:=NewX;



    DrawFocusRect(ScreenDC,OrigRect);

    ReleaseDC(0,ScreenDC);

  end;
end;

Procedure TSBSPanel.SetIsGroupBox (Value : Boolean);
begin
  If (FIsGroupBox <> Value) Then Begin
    FIsGroupBox := Value;
    Invalidate;
  End; { If }
end;

Procedure TSBSPanel.Paint;
const
  Alignments : Array[TAlignment] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);

  //------------------------------

  Procedure PaintGroupBox;
  var
    H       : Integer;
    R       : TRect;
    TheText : ANSIString;
  Begin // PaintGroupBox
    With Canvas Do Begin
      { Clear Background }
      Brush.Color := Color;
      FillRect (ClientRect);

      Font := Self.Font;
      H := TextHeight('0');
      R := Rect(0, H div 2 - 1, Width, Height);

      If Ctl3D Then Begin
        Inc(R.Left);
        Inc(R.Top);
        Brush.Color := clBtnHighlight;
        FrameRect(R);
        OffsetRect(R, -1, -1);
        Brush.Color := clBtnShadow;
      End { If }
      Else
        Brush.Color := clWindowFrame;

      FrameRect(R);

      If (Caption <> '') then begin
        R := Rect(8, 0, 0, H);

        TheText := ' ' + Caption + ' ';

        DrawText(Handle, PChar(TheText), Length(TheText), R, DT_LEFT or DT_SINGLELINE or
          DT_CALCRECT);
        Brush.Color := Color;
        DrawText(Handle, PChar(TheText), Length(TheText), R, DT_LEFT or DT_SINGLELINE);
      end;
    end;
  End; // PaintGroupBox

  //------------------------------

  Procedure PaintBtrieveListColumn;
  Var
    R       : TRect;
  Begin // PaintBtrieveListColumn
    R := GetClientRect;

    With Canvas Do
    Begin
      // Paint bump on right hand edge
      Pen.Color := clBtnShadow;
      MoveTo (R.Right - 1, R.Top);
      LineTo (R.Right - 1, R.Bottom);

      Pen.Color := clBtnHighlight;
      MoveTo (R.Right - 2, R.Top);
      LineTo (R.Right - 2, R.Bottom);

      Pen.Color := clBtnFace;
      MoveTo (R.Right - 3, R.Top);
      LineTo (R.Right - 3, R.Bottom);
      R.Right := R.Right - 3;

      // fill with defined Color
      Brush.Color := Color;
      FillRect(R);

      // Note: Btrieve List Columns don't have captions so we don't need to handle painting it
    End; // With Canvas
  End; // PaintBtrieveListColumn

  //------------------------------

  Procedure PaintBtrListColumnHeader;
  Var
    R  : TRect;
    FontHeight, I, Middle: Integer;
    Flags: Longint;
  Begin // PaintBtrListColumnHeader
    // Paint 50/50 vertical split header control
    R := GetClientRect;

    // MH 07/11/2012 v7.0 ABSEXCH-13676: Windows using panel color to paint background automatically
    //                                   when window made wider so we need to ensure it is a safe colour
    Color := clWhite;

    With Canvas Do
    Begin
      // Paint top half in White and bottom half on off-white
      Middle := (R.Bottom-R.Top) Div 2;

      Brush.Color := clWhite;
      FillRect(Rect(R.Left, R.Top, R.Right, Middle));  // LTRB

      Brush.Color := RGB(246,247,249);
      FillRect(Rect(R.Left, Middle, R.Right, R.Bottom));  // LTRB

      // Paint caption
      If (Trim(Caption) <> '') Then
      Begin
        Brush.Style := bsClear;
        Font := Self.Font;
        FontHeight := TextHeight('W');
        with R do
        begin
          Top := ((Bottom + Top) - FontHeight) div 2;
          Bottom := Top + FontHeight;
        end;
        Flags := DT_EXPANDTABS or DT_VCENTER or Alignments[Alignment];
        Flags := DrawTextBiDiModeFlags(Flags);
        DrawText(Handle, PChar(Caption), -1, R, Flags);
      End; // If (Trim(Caption) <> '')
    End; // With Canvas
  End; // PaintBtrListColumnHeader

  //------------------------------

  Procedure PaintFrame;
  Var
    R : TRect;
    FontHeight : Integer;
    Flags : Longint;
  Begin // PaintFrame
    R := GetClientRect;

    With Canvas Do
    Begin
      { Clear Background }
      Brush.Color := Color;
      FillRect (R);

      If Ctl3D Then Begin
        Inc(R.Left);
        Inc(R.Top);
        Brush.Color := clBtnHighlight;
        FrameRect(R);
        OffsetRect(R, -1, -1);
        Brush.Color := clBtnShadow;
      End { If }
      Else
        Brush.Color := clWindowFrame;

      FrameRect(R);

      If (Trim(Caption) <> '') Then
      Begin
        // paint caption
        Brush.Style := bsClear;
        Font := Self.Font;
        FontHeight := TextHeight('W');
        with R do
        begin
          Top := ((Bottom + Top) - FontHeight) div 2;
          Bottom := Top + FontHeight;
        end;
        Flags := DT_EXPANDTABS or DT_VCENTER or Alignments[Alignment];
        Flags := DrawTextBiDiModeFlags(Flags);
        DrawText(Handle, PChar(Caption), -1, R, Flags);
      End; // If (Trim(Caption) <> '')
    End; // With Canvas
  End; // PaintFrame

  //------------------------------

begin
  If (Not IsGroupBox) Then
  Begin
    // MH 18/06/2012 v7.0 ABSEXCH-12952: Added custom painting based on the Purpose property for UI customisation
    Case FPurpose Of
      puDefault                     : Inherited;
      puBtrListColumnHeader         : PaintBtrListColumnHeader;
      puBtrListColumnHeaderDragging : Inherited;
      puBtrListColumn               : PaintBtrieveListColumn;
      puFrame                       : PaintFrame;
    Else
      // Paint standard behaviour if enumeration handler not defined
      Inherited;
    End; // Case FPurpose
  End // If (Not IsGroupBox)
  Else
    PaintGroupBox;
end;

//------------------------------

// MH 18/06/2012 v7.0 ABSEXCH-12952: Added Purpose property for UI customisation
Procedure TSBSPanel.SetPurpose (Value : TSBSPanelPurpose);
Begin // SetPurpose
  // If purpose has changed force a repaint
  If (Value <> FPurpose) Then
  Begin
    FPurpose := Value;

    // MH 07/11/2012 v7.0 ABSEXCH-13676: Windows using panel color to paint background automatically
    //                                   when window made wider so we need to ensure it is a safe colour
    If (FPurpose = puBtrListColumnHeader) Then
      Color := clWhite;

    Paint;
  End; // If (Value <> FPurpose)
End; // SetPurpose

//=========================================================================


constructor TSBSGroup.Create(AOwner: TComponent);
begin
  Inherited Create (AOwner);

  IsGroupBox := True;
end;

{ -------------------------- }

constructor TSBSCBox.Create(AOwner: TComponent);
begin
  Inherited Create (AOwner);

  Height:=21;
  Width:=145;

  BevelInner:=bvNone;
  BevelOuter:=bvNone;
  BorderStyle:=bsSingle;

  EMask:=TCustomEdit.Create(Self);

  try

    With EMask do
    Begin
      Parent:=Self;
      Left:=1;
      Top:=0;
      Width:=122;
      Height:=17;
      Text:=Self.Caption;
    end;

  except
    EMask.Free;

  end; {try..}


  EBtn:=TBitBtn.Create(Self);

  try

    With EBtn do
    Begin
      Parent:=Self;
      Left:=124;
      Top:=0;
      Width:=17;
      Height:=17;
    end;

  except
    EBtn.Free;

  end; {try..}


end;


Procedure TSBSCBox.Resize;

Begin
  Inherited;

  EBtn.Left:=Width-21;
  EBtn.Height:=Height-4;

  EMask.Width:=EBtn.Left;
  EMask.Height:=Height-4;

  If (Assigned(OnResize)) then
    OnReSize(Self);


end;

{procedure Register;
begin
  RegisterComponents('SBS', [TSBSPanel]);
end;}

{ TSBSExtendedForm }


{ TSBSExtendedForm }


function TSBSExtendedForm.GetArwAlign:TAlign;


begin
  Result:=fArrowPos;

end;

procedure TSBSExtendedForm.SetArwAlign(const Value:TAlign);


begin
  if GetArwAlign<> Value then
  Begin
    fArrowPos:=Value;

    PosArrow(IsWider);
  end;
end;


Procedure TSBSExtendedForm.SetArrowX(Value  :  LongInt);

Begin
  If (Value<>ArrowX) then
  Begin
    FArrowX:=Value;
    PosArrow(IsWider);
  end;

end;

Procedure TSBSExtendedForm.SetArrowY(Value  :  LongInt);

Begin
  If (Value<>ArrowY) then
  Begin
    FArrowY:=Value;
    PosArrow(IsWider);
  end;

end;



Procedure TSBSExtendedForm.SetOrigHeight(Value  :  LongInt);

Begin
  If (Value<>OrigHeight) then
    FOrigHeight:=Value;

end;

Procedure TSBSExtendedForm.SetOrigWidth(Value  :  LongInt);

Begin
  If (Value<>OrigWidth) then
    FOrigWidth:=Value;

end;


Procedure TSBSExtendedForm.SetOrigTop(Value  :  LongInt);

Begin
  If (Value<>OrigTop) then
    FOrigTop:=Value;

end;

Procedure TSBSExtendedForm.SetOrigLeft(Value  :  LongInt);

Begin
  If (Value<>OrigLeft) then
    FOrigLeft:=Value;

end;


Procedure TSBSExtendedForm.SetExpandWidth(Value  :  LongInt);

Begin
  If (Value<>ExpandedWidth) then
    FExpandWidth:=Value;

end;


Procedure TSBSExtendedForm.SetExpandHeight(Value  :  LongInt);

Begin
  If (Value<>ExpandedHeight) then
    FExpandHeight:=Value;

end;

Procedure TSBSExtendedForm.SetOrigTabOrder(Value  :  LongInt);

Begin
  If (Value<>OrigTabOrder) then
    FOrigTabOrder:=Value;

end;


Procedure TSBSExtendedForm.SetShowHorzSB(Value  :  Boolean);

Begin
  If (Value<>ShowHorzSB) then
    FShowHorzSB:=Value;

end;


Procedure TSBSExtendedForm.SetForceFocus (Value  :  Boolean);

Begin
  If (Value<>ForceFocus) then
    ForceFocus:=Value;

end;


Procedure TSBSExtendedForm.SetShowVertSB(Value  :  Boolean);

Begin
  If (Value<>ShowVertSB) then
    FShowVertSB:=Value;

end;


Procedure TSBSExtendedForm.SetOrigParent(Value  :  TWinControl);

Begin
  If (Value<>OrigParent) then
    FOrigParent:=Value;

end;


Procedure TSBSExtendedForm.SetNewParent(Value  :  TForm);

Begin
  If (Value<>NewParent) then
    FNewParent:=Value;

end;


Procedure TSBSExtendedForm.SetFocusFirst(Value  :  TWinControl);

Begin
  If (Value<>FocusFirst) then
    FFirstFocus:=Value;

end;

Procedure TSBSExtendedForm.SetFocusLast(Value  :  TWinControl);

Begin
  If (Value<>FocusLast) then
    FLastFocus:=Value;

end;


Procedure TSBSExtendedForm.SetLastControl(Value  :  TWinControl);

Begin
  ViaClick:=False;

  If (Value<>LastControl) then
    FLastControl:=Value;

end;


Procedure TSBSExtendedForm.SetTabPrev(Value  :  TWinControl);

Begin
  If (Value<>TabPrev) then
    FPreTab:=Value;

end;

Procedure TSBSExtendedForm.SetTabNext(Value  :  TWinControl);

Begin
  If (Value<>TabNext) then
    FNextTab:=Value;

end;


Procedure TSBSExtendedForm.CreateBevel;

Begin
  InnerPanel:=TBevel.Create(Self);

  Try
    With InnerPanel do
    Begin
      Parent:=Self;
      Left:=0;
      Top:=0;
      Width:=Self.Width;
      Height:=Self.Height;
      Align:=alClient;

      {BevelOuter:=bvNone;
      BevelInner:=bvNone;
      Caption:='';}
      Style:=bsRaised;
      Shape:=bsBox;
      Visible:=False;
      SendToBack;
      
      {OnCLick:=PanelClick;}
    end;
  Except;
    InnerPanel.Free;
    InnerPanel:=nil;
  end;

end;


constructor TSBSExtendedForm.Create(AOwner: TComponent);


begin
  Inherited Create (AOwner);

  OrigParent:=Parent;
  OrigHeight:=Height;
  OrigWidth:=Width;
  OrigTabOrder:=TabOrder;
  OrigTop:=Top;
  OrigLeft:=Left;
  FNewSTop:=0;
  FNewSLeft:=0;
  ViaClick:=True;
  ClickFirst:=False;
  ForceFocus:=False;
  OverrideFocus:=nil;
  IsWider:=False;
  ReadyForCombo:=False;
  NewSetting:=True;

  DropCBHandle:=-1;

  HorzScrollBar.Visible:=(csDesigning in ComponentState);
  VertScrollBar.Visible:=(csDesigning in ComponentState);

   If (csDesigning in ComponentState) then
     BorderStyle:=bsSingle
   else
   Begin
     {BorderStyle:=bsNone;}

     CreateBevel;

  end;

end;



destructor TSBSExtendedForm.destroy;
begin
  If (Assigned(InnerPanel)) then
  Begin
    InnerPanel.Free;
    InnerPanel:=nil;
  end;

  {If (Assigned(CImage)) then
  Begin
    CImage.Free;
    CImage:=nil;
  end;}

  Inherited;
end;


procedure TSBSExtendedForm.Click;

Begin
  PanelClick(Self);

  inherited Click;
end;

procedure TSBSExtendedForm.SetSubParent;

Var
  WDIFF       :  Integer;

Begin

  WDiff:=Pred(ControlCount);

  While (WDiff>=0) and (Assigned(InnerPanel)) do
  Begin
   If Controls[WDIff] is TLabel then
   Begin
     TLabel(Controls[WDIff]).OnClick:=PanelClick;
     {TLabel(Controls[WDIff]).Parent:=Self;}

   end;

   Dec(WDiff);
  end;



end;

procedure TSBSExtendedForm.PosArrow(Wider  :  Boolean);

Begin
  If (Assigned(CImage)) then
  with CImage.Picture.Bitmap do
  Begin
    try
      If (fArrowPos In [alRight,alNone]) then
      Begin
        CImage.Top:=Self.Height-Height;

        CImage.Left:=(Self.Width-Width)-(10*Ord(Wider));
      end
      else
       If (fArrowPos=alLeft) then
       Begin
         CImage.Top:=Self.Height-Height;

         CImage.Left:=0;
       end
       else
        If (fArrowPos=alBottom) then
        Begin

          CImage.Top:=Self.Height-Height;

          CImage.Left:=Round((Self.Width/2)-(Width/2));
        end
        else
          If (fArrowPos=alTop) then
          Begin

            CImage.Top:=0;

            CImage.Left:=Round((Self.Width/2)-(Width/2));
          end;

       CImage.Top:=CImage.Top+ArrowY;
       CImage.Left:=CImage.Left+ArrowX;
     except
       CImage.Free;
       CImage:=nil
     end; {Try..}

  end;
end;


procedure TSBSExtendedForm.BuildArrow(Wider  :  Byte);

Const
  DARROWS  :  Array[0..3] of PChar = ('3DGDARRW','3DGRARRW','3DGUARRW','3DGUARRW');

Var
  RectD       :  TRect;
  CBitMap     :  TBitMap;

Begin
  If (Not Assigned(CImage)) then
  Begin

    CBitmap := TBitmap.Create;
    try
      with CBitmap do
      begin
        Transparent := True;
        TransparentMode := tmAuto;


        Handle:=LoadBitMap(HInstance,DARROWS[Wider]);

        RectD:=Rect(0,0,Width,Height);

      end;


      CImage:=TImage.Create(Self);

      Try
        with CImage.Picture.Bitmap do
        begin

          CImage.Parent:={InnerPanel}Self;
          Width:=CBitMap.Width; Height:=CBitMap.Height;
          CImage.Width:=CBitMap.Width; CImage.Height:=CBitMap.Height;


          Canvas.Brush.Color:=clBtnFace;
          Canvas.BrushCopy(RectD,CBitMap,RectD,clSilver);

          PosArrow((Wider In [1,3]));

          {Canvas.CopyMode := cmSrcCopy;


          Canvas.CopyRect(RectD,CBitMap.Canvas,RectD);}

          CImage.OnClick:=PanelClick;
        end;
      except
        CImage.Free;
        CImage:=nil;

      end;

    Finally

      CBitmap.Free;
    end;

  end;

end;


procedure TSBSExtendedForm.Loaded;


  {DARROWS  :  Array[False..True] of PChar = ('LSTPGDN','3DRARRW');}

Var
  HDIFF,
  WDIFF       :  Integer;
  Wider       :  Boolean;

Begin
  Inherited Loaded;

  CImage:=Nil;

  HDIFF:=ExpandedHeight-Height;
  WDIFF:=ExpandedWidth-Width;
  {Wider:=(WDIFF>HDIFF);  v4.40}

  Wider:=False;

  IsWider:=Wider;

  BuildArrow(Ord(Wider));

  If (Not (csDesigning in ComponentState)) then
  Begin

    HorzScrollBar.Position:=0;
    VertScrollBar.Position:=0;

    VSBWasVisible:=HorzScrollBar.Visible;
    HSBWasVisible:=VertScrollBar.Visible;


    SetSubParent;


  end;


end;



procedure TSBSExtendedForm.PanelClick(Sender: TObject);



begin


  If (CanFocus) and (NewSetting) then
  Begin
    ViaClick:=True;
    ClickFirst:=True;

    PostMessage(Self.Handle,WM_User+1,3,0);

    {SetFocus;}

  end
  else
    If (Not NewSetting) then
    Begin

      ForceFocus:=True;
      ExitDirec:=True;

      PostMessage(Self.Handle,WM_User+1,4,0);


    end;

  Inherited
end;


procedure TSBSExtendedForm.CheckOtherFocus;

Var
  FoundOk  :  Boolean;
  n        :  Longint;

Begin
  {$B-}

  FoundOk:=False; n:=0;

  OverrideFocus:=nil;

  If (Assigned(NewParent)) and (NewParent is TForm) then
  With TForm(NewParent) do
  Begin
    If (Assigned(ActiveControl)) then
    Begin
      {If (Assigned(FocusFirst)) and (ActiveControl<>FocusFirst) and (Assigned(FocusLast)) and (ActiveControl<>FocusLast) then}
      Begin {Check to see if it is still one of ours, and if so set focus to it}
        For n:=0 to Pred(Self.ControlCount) do
        Begin
          FoundOk:=(Self.Controls[n]=ActiveControl);

          If (FoundOk) then
            Break;
        end;

        If (FoundOk) then
          OverrideFocus:=TWinControl(Self.Controls[n]);
      end;
    end;

  end;

  {$B+}

end;



procedure TSBSExtendedForm.ReAssignFocusLast;

Var
  FoundOk  :  Boolean;
  TestCtrl :  TWinControl;

Begin
  {$B-}
    FoundOK := False;
    If (Assigned(FocusLast)) and  ((Not FocusLast.Visible)  or (Not FocusLast.Enabled)) then
    Begin
      Repeat
        TestCtrl:=FindNextControl(FocusLast,False, True, True);


        If (Assigned(TestCtrl)) then
        Begin
          If (TestCtrl.Visible) and (TestCtrl.Enabled) and (TestCtrl.TabStop) then
          Begin
            FocusLast:=TestCtrl;
            FoundOk:=True;
          end;
        end;

      Until (FoundOk) or (Not Assigned(TestCtrl)) or (TestCtrl=FocusFirst) or (TestCtrl=FocusLast) ;

    {$B+}

  end;
end;


procedure TSBSExtendedForm.CMExecuteEnter;

Var
  P  :  TPoint;

begin

  If (NewSetting) then
  Begin
    If (Assigned(CImage)) then
    Begin
      FreeAndNil(CImage);
      BuildArrow(2+Ord(IsWider));
    end;

    NewSetting:=False;
    ForceFocus:=False;

    OrigParent:=Parent;
    OrigHeight:=Height;
    OrigWidth:=Width;
    OrigLeft:=Left;
    OrigTop:=Top;
    OrigTabOrder:=TabOrder;

    CheckOtherFocus;

    If (Assigned(Self.NewParent)) then
    Begin
      P.X:=Left;
      P.Y:=Top;
      P:=Self.NewParent.ScreenToClient(OrigParent.ClientToScreen(P));

      Left:=P.X;
      Top:=P.Y;
      Self.Parent:=Self.NewParent;

    end;

    Height:=ExpandedHeight;
    Width:=ExpandedWidth;

    HorzScrollBar.Visible:=ShowHorzSB;
    VertScrollBar.Visible:=ShowVertSB;

    {ScrollBox1.BorderStyle:=bsSingle;}

    {If (Assigned(InnerPanel)) then
      InnerPanel.BevelOuter:=bvRaised;}

    If (Assigned(InnerPanel)) then
      InnerPanel.Visible:=True;

    PostMessage(Self.Handle,WM_User+1,0,0);

  end;
end;


procedure TSBSExtendedForm.CMExecuteExit;

Var
  Direc       :  Boolean;


begin

  If (Not NewSetting) then
  Begin
    ReadyForCombo:=False;

    HorzScrollBar.Visible:=False;
    VertScrollBar.Visible:=False;


    {If (Assigned(InnerPanel)) then
      InnerPanel.BevelOuter:=bvNone;}

    If (Assigned(InnerPanel)) then
      InnerPanel.Visible:=False;

    {$B-}
    If (Assigned(NewParent)) and (NewParent is TForm) then
    Begin
      {Direc:=(NewParent.ActiveControl.TabOrder<OrigTabOrder);}
      Direc:=ExitDirec;
    end
    else
      Direc:=False;
    {$B+}

    Parent:=OrigParent;
    Height:=OrigHeight;
    Width:=OrigWidth;
    Top:=OrigTop;
    Left:=OrigLeft;

    TabOrder:=OrigTabOrder;

    If (Assigned(CImage)) then
    Begin
      FreeAndNil(CImage);
      BuildArrow(Ord(IsWider));
    end;


    If (ForceFocus) then
      PostMessage(Self.Handle,WM_User+1,1+Ord(Direc),0);

    NewSetting:=True;

    ClickFirst:=False;

    if Assigned(FOnCloseUp) then
      OnCloseUp(self);

  end;

end;


procedure TSBSExtendedForm.ProcessComboDrop(CBHandle  :  LongInt);

Var
  n  :  LongInt;
  
Begin
  If (DropCBHandle>0) then
  Begin
    Application.ProcessMessages;

    PostMessage(CBHandle, CB_SHOWDROPDOWN, Longint(1), 0);
    DropCBHandle:=-1;

  end;

end;

procedure TSBSExtendedForm.CtrlFocus(var Message: TMessage);
Var
  SFControl  :  TWinControl;
  DMsg       :  TCMEXIT;


Begin
  SFControl:=Nil;

  FillChar(DMsg,Sizeof(DMsg),0);

  With Message do
  Begin
    Case WParam of
      0  :  Begin
              If (Assigned(NewParent)) and (Not NewSetting) then
                Self.Parent:=Self.NewParent;

              {$B-}
              If (Assigned(OverrideFocus)) then
              Begin
                SFControl:=OverrideFocus;
              end
              else
              Begin

                If (Assigned(FocusFirst)) then
                  SFControl:=FocusFirst;

                If (Assigned(LastControl)) and (Not ViaClick) and (Not ClickFirst) then
                Begin
                  If (LastControl=TabNext) then
                    SFControl:=FocusLast;

                end;
              end;

              If (Assigned(SFControl)) and  (SFControl.CanFocus) then
                SFControl.SetFocus;

              ReadyForCombo:=True;

              //If we have a delayed combo popup request then lets process it here

              If (SFControl is TComboBox) and (DropCBHandle<>0) then
                PostMessage(Self.Handle, WM_User+1, 5, SFControl.Handle);


              {$B+}
            end;
      1  :  If (Assigned(TabPrev)) then
               If (TabPrev.CanFocus) then
                 TabPrev.SetFocus;
      2  :  If (Assigned(TabNext)) then
               If (TabNext.CanFocus) then
                 TabNext.SetFocus;

      3  :  Self.SetFocus;

      4  :  Begin
              Self.CMExit(DMSg);
            end;

      5  :  ProcessComboDrop(LParam);


      10  :  CMExecuteEnter;
      11  :  CMExecuteExit;

    end; {Case..}

  end;

  Inherited;

end;

procedure TSBSExtendedForm.CMEnter(var Message: TCMEnter);

begin

  inherited;


  If (NewSetting) then
  Begin

    PostMessage(Self.Handle,WM_User+1,10,0);

  end;
end;


procedure TSBSExtendedForm.CMExit(var Message: TCMExit);


begin
  ForceClose;

  Inherited;

end;



procedure TSBSExtendedForm.ShowExpanded;

Var
  DMsg  :  TCMENTER;

Begin
  If (NewSetting) and (csDesigning In ComponentState) then
  Begin
    FillChar(DMsg,Sizeof(DMsg),0);

    HSBWasVisible:=HorzScrollBar.Visible;
    VSBWasVisible:=VertScrollBar.Visible;



    CreateBevel;

    Self.CMEnter(DMSg);

  end;


end;


procedure TSBSExtendedForm.ShowNormal;

Var
  DMsg  :  TCMEXIT;

Begin
  FillChar(DMsg,Sizeof(DMsg),0);

  If (Not NewSetting) and (csDesigning In ComponentState) then
  Begin
    Self.CMExit(DMSg);

    If (Assigned(InnerPanel)) then
    Begin
      InnerPanel.Free;
      InnerPanel:=nil;
    end;


    VertScrollBar.Visible:=VSBWasVisible;
    HorzScrollBar.Visible:=HSBWasVisible;

  end;
end;

  procedure TSBSExtendedForm.ForceClose;

  Begin
    If (Not NewSetting) then
    Begin

      PostMessage(Self.Handle,WM_User+1,11,0);

    end;


  end;


{ === Extended form editor === }

{$IFDEF PKG_On}

  Function TSBSExtFormEditor.GetVerbCount : Integer;
  Begin
    Result:= 1;
  End;

  Function TSBSExtFormEditor.GetVerb(Index : Integer) : String;
  Begin
    Case Index Of
      0 : If TSBSExtendedForm(Component).NewSetting then
            Result := 'Show Expanded'
          else
            Result := 'Show Normal';
    Else
      Result := '';
    End; { Case }
  End;


  Procedure TSBSExtFormEditor.ExecuteVerb(Index : Integer);
  Begin
    Case Index Of
      0 : Begin
            If TSBSExtendedForm(Component).NewSetting then
              TSBSExtendedForm(Component).ShowExpanded
            else
              TSBSExtendedForm(Component).ShowNormal;
          end;    
    End; { Case }
  End;

{$ENDIF}

end.


