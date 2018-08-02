unit sbsdrag;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  PageComp, ShellAPI, GlobType, SBSList, TablFunc, Menus;

type
  THandles = (TopLeft, TopCentre, TopRight,
              CentreLeft, CentreRight,
              BottomLeft, BottomCentre, BottomRight,
              GroupRow);

  THandleType = Record
    Enabled : Boolean;
    Rect    : TRect;
  End; { THandleType }

  TDragState = (dsNone, dsSizing, dsMoving, dsRowMove);

  TSBSDragControl = class(TCustomControl)
  private
    { Private declarations }
    FControlId    : String10;
    FOnOptions    : TNotifyEvent;
    FState        : TDragState;
    FGotFocus     : Boolean;
    FXOffset      : LongInt;
    FYOffset      : LongInt;
    FHandles      : Array [TopLeft..BottomRight] Of THandleType;
    FHitTest      : TPoint;
    FController   : TSBSController;
    FRButt        : TPoint;
    FShift        : TShiftState; { Stores the shift state of the last mousedown }
    procedure WMGetDLGCode(var Message: TMessage); message WM_GETDLGCODE;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure SetSuspend (Value : Boolean);
  protected
    { Protected declarations }
    FAllowSizing  : Boolean;
    FSuspendPaint : Boolean;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure ChangeParams(var Params: TCreateParams); virtual;
    Function  WantPaint : Boolean; virtual;
    procedure PaintBackGround; virtual;
    procedure PaintHandles; virtual;
    procedure PaintControl; virtual;
    Procedure DrawBox (Var StartRect, EndRect : TRect);
    procedure CalcHandleRects;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMRButtonDown(var Message: TWMRButtonDown); message WM_RBUTTONDOWN;
    procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;
    procedure WMCaptureChanged (var Message: TMessage); message WM_CaptureChanged;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure ControlMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); Virtual;
    procedure ControlMouseMove(Shift: TShiftState; X, Y: Integer); Virtual;
    procedure ControlMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); Virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    Procedure ReDraw; Virtual;
    Procedure ChangeMade; Virtual;
    Procedure SetOnOptions(Value : TNotifyEvent);
  public
    { Public declarations }
    FPrintIf  : fdIfInfoType;
    FHidden   : Boolean;
    FSizeType : THandles;
    BoxRect, SizeRect, SelMove1, SelMove2 : TRect;
    OptionsOk : Boolean;
    DelTime   : TDateTime;
    IsOpaque  : Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    Procedure PaintForeGround; virtual;
    procedure MoveToFront;
    procedure MoveToBack;
    Function GetName : ShortString; Virtual;
    Function GetStatusInfo : ShortString; Virtual;
    Function GetFieldInfo : ShortString; Virtual;
    Function GetPosStr : ShortString; Virtual;
    Function GetIf : fdIfInfoType; Virtual;
    Function OptionsDialog : Boolean; Virtual;
    Procedure FontDialog; Virtual;
    Function GetDefRec : FormDefRecType; Virtual;
    Procedure InitByDefRec (Const DefRec : FormDefRecType); Virtual;
    Function GetIdPrefix : String10; Virtual;
    Function MMToPixels(CoOrd : LongInt) : LongInt;
    Function MMToPixelsH(CoOrd : LongInt) : LongInt;
    Function MMToPixelsV(CoOrd : LongInt) : LongInt;
    Function PixelsToMM(CoOrd : LongInt) : LongInt;
    Function PixelsToMMH(CoOrd : LongInt) : LongInt;
    Function PixelsToMMV(CoOrd : LongInt) : LongInt;
    Procedure SetInitialSize; Virtual;
    Procedure Click(Sender: TObject);
    Procedure SelectMove (Const XOff, YOff : SmallInt;
                          Const Mode       : Byte);

    Property SuspendPaint : Boolean read FSuspendPaint Write SetSuspend;
  published
    { Published declarations }
    Property OnOptions : TNotifyEvent read FOnOptions write SetOnOptions;
    Property PopupMenu;
    Property Controller : TSBSController read FController write FController;
    Property ControlId : String10 read FControlId write FControlId;
  end;

  TSBSDragText = class(TSBSDragControl)
  private
    { Private declarations }
    FText         : ShortString;
    FFont         : TFont;
    FTextAlign    : TAlignment;
    FIsSymbolFont : Boolean;
  protected
    { Protected declarations }
    procedure PaintControl; override;
    procedure SetText (Value : ShortString);
    procedure SetFont(Value: TFont);
    procedure SetTextAlign(Value: TAlignment);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Function GetName : ShortString; override;
    Function GetFieldInfo : ShortString; override;
    {Function OptionsDialog : Boolean; override;}
    Function GetDefRec : FormDefRecType; override;
    Procedure InitByDefRec (Const DefRec : FormDefRecType); override;
    Function GetIdPrefix : String10; override;
    Procedure SetInitialSize; override;
    Procedure FontDialog; override;
  published
    { Published declarations }
    Property Text : ShortString read FText write SetText;
    property Font: TFont read FFont write SetFont;
    property TextAlign : TAlignment read FTextAlign write SetTextAlign;
    property IsSymbolFont : Boolean Read FIsSymbolFont Write FIsSymbolFont;
  end;

  TSBSDragBitmap = class(TSBSDragControl)
  private
    { Private declarations }
    FPicture : TPicture;
    FBitPath : ShortString;
  protected
    { Protected declarations }
    procedure ChangeParams(var Params: TCreateParams); Override;
    procedure PaintControl; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Function  GetName : ShortString; override;
    Function GetFieldInfo : ShortString; override;
    Function  OptionsDialog : Boolean; override;
    Procedure ShellEditor;
    Function GetDefRec : FormDefRecType; override;
    Procedure InitByDefRec (Const DefRec : FormDefRecType); override;
    Function GetIdPrefix : String10; override;
  published
  end;

  TSBSDragBox = class(TSBSDragControl)
  private
    { Private declarations }
    FPenWidth     : Word;
    FPenColor     : TColor;
    FLeftBorder   : Boolean;
    FTopBorder    : Boolean;
    FRightBorder  : Boolean;
    FBottomBorder : Boolean;
    FFill         : Boolean;
  protected
    { Protected declarations }
    procedure PaintControl; override;
    procedure SetPenWidth (value : Word);
    procedure SetLeftBorder (value : Boolean);
    procedure SetTopBorder (value : Boolean);
    procedure SetRightBorder (value : Boolean);
    procedure SetBottomBorder (value : Boolean);
    procedure SetColor (value : TColor);
    procedure SetFill (value : Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Function  GetName : ShortString; override;
    Function GetFieldInfo : ShortString; override;
    {Function  OptionsDialog : Boolean; override;}
    Function GetDefRec : FormDefRecType; override;
    Procedure InitByDefRec (Const DefRec : FormDefRecType); override;
    Function GetIdPrefix : String10; override;
  published
    Property LeftBorder : Boolean read FLeftBorder write FLeftBorder;
    Property TopBorder : Boolean read FTopBorder write FTopBorder;
    Property RightBorder : Boolean read FRightBorder write FRightBorder;
    Property BottomBorder : Boolean read FBottomBorder write FBottomBorder;
    Property PenWidth : Word read FPenWidth write SetPenWidth;
    property PenColor: TColor read FPenColor write SetColor;
    property Fill : Boolean read FFill write SetFill;
  end;

  TSBSDragLine = class(TSBSDragControl)
  private
    { Private declarations }
    FPenWidth     : Word;
    FPenColor     : TColor;
    FLineType     : TSBSDragLineType;
  protected
    { Protected declarations }
    procedure PaintControl; override;
    procedure SetPenWidth (value : Word);
    procedure SetColor (value : TColor);
    procedure SetLineType (Value : TSBSDragLineType);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Function  GetName : ShortString; override;
    Function GetFieldInfo : ShortString; override;
    {Function  OptionsDialog : Boolean; override;}
    Function GetDefRec : FormDefRecType; override;
    Procedure InitByDefRec (Const DefRec : FormDefRecType); override;
    Function GetIdPrefix : String10; override;
  published
    Property PenWidth : Word read FPenWidth write SetPenWidth;
    property PenColor: TColor read FPenColor write SetColor;
    property LineType : TSBSDragLineType read FLineType write SetLineType;
  end;

TSBSDragPage = class(TSBSDragControl)
  private
    { Private declarations }
    FLeadingText  : ShortString;
    FTrailingText : ShortString;
    FFont         : TFont;
    FAlign        : TAlignment;
  protected
    { Protected declarations }
    procedure PaintControl; override;
    procedure SetFont(Value: TFont);
    procedure SetLeadingText (Value : ShortString);
    procedure SetTrailingText (Value : ShortString);
    procedure SetAlignment (Value : TAlignment);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Function GetName : ShortString; override;
    {Function OptionsDialog : Boolean; override;}
    Function GetDefRec : FormDefRecType; override;
    Function GetFieldInfo : ShortString; override;
    Procedure InitByDefRec (Const DefRec : FormDefRecType); override;
    Function GetIdPrefix : String10; override;
    Procedure SetInitialSize; override;
    Procedure FontDialog; override;
  published
    { Published declarations }
    Property LeadingText : ShortString read FLeadingText write SetLeadingText;
    Property TrailingText : ShortString read FTrailingText write SetTrailingText;
    property Font: TFont read FFont write SetFont;
    property Alignment : TAlignment read FAlign write SetAlignment;
  end;

  TSBSDragDbField = class(TSBSDragControl)
  private
    { Private declarations }
    FShortCode : String10;
    FCharLength : Byte;
    FFont : TFont;
    FTextAlign : TAlignment;
    FDecimals : Byte;
    FBlank : Boolean;
  protected
    { Protected declarations }
    procedure PaintControl; override;
    procedure SetShortCode(Value : String10);
    procedure SetFont(Value: TFont);
    procedure SetCharLength(Value: Byte);
    procedure SetTextAlign(Value: TAlignment);
    procedure SetDecimals(Value: Byte);
    procedure SetBlank(Value: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Function GetName : ShortString; override;
    Function GetFieldInfo : ShortString; override;
    {Function OptionsDialog : Boolean; override;}
    Function GetDefRec : FormDefRecType; override;
    Procedure InitByDefRec (Const DefRec : FormDefRecType); override;
    Function GetIdPrefix : String10; override;
    Procedure SetInitialSize; override;
    Procedure FontDialog; OverRide;
  published
    { Published declarations }
    property Font: TFont read FFont write SetFont;
    Property ShortCode : String10 read FShortCode Write SetShortCode;
    Property CharLength : Byte read FCharLength write SetCharLength;
    Property TextAlign : TAlignment read FTextAlign write SetTextAlign;
    Property Decimals : Byte read FDecimals write SetDecimals;
    Property BlankZero : Boolean read FBlank write SetBlank;
  end;

  TSBSDragDbTable = class(TSBSDragControl)
  private
    { Private declarations }
    FTable : TableObject;
  protected
    { Protected declarations }
    procedure PaintControl; override;
    Function CalcColWidths : LongInt;
    Function FontHeight (Const TheFont : fdFontDefType) : Integer;
    Function GetRowHeight : Integer;
 public
    { Public declarations }
    Columns  : TSBSList;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Function GetName : ShortString; override;
    Function  GetDefRec : FormDefRecType; override;
    Procedure InitByDefRec (Const DefRec : FormDefRecType); override;
    Function  GetColumnDefRec (Const ColIndex : Integer) : TFormDefListObjType;
    Procedure InitColumnByDefRec (Const ColDef : FormDefRecType);
    Procedure ClearColumns;
    Procedure SetDefaultFont (DefFont : TFont);
    Function GetIdPrefix : String10; override;
    Procedure SetInitialSize; override;
  published
    { Published declarations }
  end;

  TSBSDragFormula = class(TSBSDragControl)
  private
    { Private declarations }
    FFormula   : ShortString;
    FFont      : TFont;
    FDecimals  : Byte;
    FTextAlign : TAlignment;
    FBlank     : Boolean;
    FBarCode   : fdBarCodeType;
    FBCFlag1   : LongInt;
    FBCFlag2   : LongInt;
    FBCFlag3   : LongInt;
  protected
    { Protected declarations }
    procedure PaintControl; override;
    procedure SetFont(Value: TFont);
    procedure SetTextAlign(Value: TAlignment);
    procedure SetBlank(Value: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Function GetName : ShortString; override;
    Function GetDefRec : FormDefRecType; override;
    Function GetFieldInfo : ShortString; override;
    Procedure InitByDefRec (Const DefRec : FormDefRecType); override;
    Function GetIdPrefix : String10; override;
    Procedure SetInitialSize; override;
    Procedure FontDialog; Override;
  published
    { Published declarations }
    property Font: TFont read FFont write SetFont;
    Property TextAlign : TAlignment read FTextAlign write SetTextAlign;
    Property Decimals : Byte read FDecimals write FDecimals;
    Property BlankZero : Boolean read FBlank write SetBlank;
  end;

  TSBSDragGroup = class(TSBSDragControl)
  private
    { Private declarations }
    FRows    : Array [1..50] Of Word; { Row Position in pixels, 0 = disabled }
    FRowIdx  : SmallInt;
  protected
    { Protected declarations }
    procedure PaintControl; override;
    procedure PaintHandles; override;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure ControlMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); Override;
    procedure ControlMouseMove(Shift: TShiftState; X, Y: Integer); Override;
    procedure ControlMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); Override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    Function GetName : ShortString; override;
    Function GetDefRec : FormDefRecType; override;
    Procedure InitByDefRec (Const DefRec : FormDefRecType); override;
    Function GetIdPrefix : String10; override;
    Procedure SetInitialSize; override;
    Procedure AddNewRow;
    Procedure DeleteRow;
    Procedure SortRows;
  published
    { Published declarations }
  end;


procedure Register;

implementation

Uses FormUtil,
     // MH 06/02/2017 ABSEXCH-14925 2017-R1: Added support for extra image types
     ImageConversionFuncs;

Var
  EmptyRect   : TRect;
  LastCapture : HWnd;

procedure Register;
begin
  RegisterComponents('SbsForm', [TSBSDragControl,
                                 TSBSDragText,
                                 TSBSDragBitmap,
                                 TSBSDragBox,
                                 TSBSDragLine,
                                 TSBSDragPage,
                                 TSBSDragDbField,
                                 TSBSDragDbTable,
                                 TSBSDragFormula,
                                 TSBSDragGroup]);
end;


Function GetMouseCapture : HWnd;
Begin
  Result := LastCapture;
End;

Procedure SetMouseCapture (DragControl : TSBSDragControl);
Begin
  LastCapture := 0;
  SetCapture (DragControl.Handle);
  LastCapture := GetCapture;
End;

Procedure ReleaseMouseCapture (DragControl : TSBSDragControl);
Begin
  ReleaseCapture;
  LastCapture := 0;
End;


{****************************************************************}
{* TSBSDragControl: Base class for the drag n drop controls for *}
{*                  use on the page control.                    *}
{****************************************************************}
constructor TSBSDragControl.Create(AOwner: TComponent);
Var
  I : THandles;
begin
  Inherited Create (AOwner);

  OptionsOk := False;
  ControlStyle := ControlStyle - [csOpaque];
  IsOpaque  := False;

  { Turn on all drag/size handles }
  For I := TopLeft To BottomRight Do
    With FHandles [I] Do
      Enabled := True;

  FAllowSizing := True;
  FGotFocus := False;
  TabStop := True;
  FState := dsNone;
  FSuspendPaint := False;
  FHidden := False;

  Height := 20;
  Width := 50;

  FController := Nil;
  OnClick := Click;
  DelTime := 0;
end;

procedure TSBSDragControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  ChangeParams(Params);
End;

procedure TSBSDragControl.ChangeParams(var Params: TCreateParams);
begin
  With Params Do
    ExStyle := ExStyle Or WS_EX_TRANSPARENT;
End;

destructor TSBSDragControl.Destroy;
begin
  If (Controller <> Nil) And (Not (csDesigning In ComponentState)) Then
    Controller.DeallocateControl (Self);

  Inherited Destroy;
end;

procedure TSBSDragControl.DoEnter;
begin
  FGotFocus := True;
  {MoveToFront;}     { Do we want to move it to the front }
  {Paint;            { need to repaint entire control including handles }
end;

procedure TSBSDragControl.DoExit;
begin
  FGotFocus := False;
  {Paint;            { need to repaint entire control including handles }
end;

{ Draws a move/resize box on the screen canvas checking for the client area }
Procedure TSBSDragControl.DrawBox (Var StartRect, EndRect : TRect);
Var
  ScreenDC : HDC;
begin
  { Check we need to redraw the rectangle }
  If Not EqualRect (StartRect, EndRect) Then Begin
    { Get handle for screen }
    ScreenDC:=GetDC(0);

    { Erase existing rubber-band rectangle }
    If Not EqualRect (EmptyRect, StartRect) Then Begin
      DrawFocusRect(ScreenDC, StartRect);
    End; { If }

    { draw new rectangle }
    If Assigned(Controller) Then
      If Controller.PageHandleSet Then
        Controller.Page.CheckMoveRect (EndRect);
    DrawFocusRect(ScreenDC, EndRect);

    { free screen handle }
    ReleaseDC(0,ScreenDC);
  End; { If }
end;

Function TSBSDragControl.WantPaint : Boolean;
Var
  aRect : TRect;
begin
  If Assigned (Parent) Then Begin
    Result := (Not FSuspendPaint) And
               Visible And
               IntersectRect (aRect, Parent.ClientRect, BoundsRect);

    If Result And Assigned (Controller) Then
      { Check to see if covered by a bitmap }
      Result := Not Controller.BmpCovered (Self);
  End { If }
  Else
    Result := False;
end;

procedure TSBSDragControl.Paint;
begin
  { Check this controls drawing is turned on and its visible in the client area }
  If WantPaint Then Begin
    FSuspendPaint := True;
    If (Not IsOpaque) Then PaintBackGround;
    FSuspendPaint := False;
    PaintForeGround;

    Controller.PaintTopControls (Self);
  End; { If }
end;

Procedure TSBSDragControl.PaintForeGround;
begin
  If WantPaint Then Begin
    PaintHandles;
    PaintControl;
  End; { If }
end;

Procedure TSBSDragControl.PaintBackGround;
begin
  If WantPaint Then Begin
    With Canvas do Begin
      Brush.Style := bsClear;
      FillRect (ClientRect);
    End; { With }
  End; { If }
end;

procedure TSBSDragControl.PaintControl;
begin
  If WantPaint Then Begin
    With Canvas do Begin
      Pen.Color := clBlack;
      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;
      Brush.Color := clWhite;
      Brush.Style := bsSolid;
      Rectangle (10, 20, 30, 40);
    End; { With }
  End; { If }
end;

procedure TSBSDragControl.MoveToBack;
begin
  { Move this control to the back }
  Controller.ControlToBack;
end;

procedure TSBSDragControl.MoveToFront;
begin
  { Bring the control to the front }
  Controller.ControlToFront;
end;

procedure TSBSDragControl.CalcHandleRects;
Var
  I : THandles;
  cRight, cBottom : LongInt;
begin
  { Calculate central position for top, sides and bottom }
  cRight := Width - 1;
  cBottom := Height - 1;

  If Not FAllowSizing Then Begin
    FHandles [TopCentre].Enabled := False;
    FHandles [CentreLeft].Enabled := False;
    FHandles [CentreRight].Enabled := False;
    FHandles [BottomCentre].Enabled := False;
  End; { If }

  For I := TopLeft To BottomRight Do
    If FHandles [I].Enabled Then
      Case I Of                             { left, top, right, bottom }
        TopLeft      : FHandles [I].Rect := Rect (0, 0, 3, 3);
        TopCentre    : FHandles [I].Rect := Rect (3, 0, (cRight - 3), 3);
        TopRight     : FHandles [I].Rect := Rect ((cRight - 3), 0, cRight, 3);
        CentreLeft   : FHandles [I].Rect := Rect (0, 4, 3, (cBottom - 3));
        CentreRight  : FHandles [I].Rect := Rect ((cRight - 3), 4, cRight, (cBottom - 4));
        BottomLeft   : FHandles [I].Rect := Rect (0, (cBottom - 3), 3, cBottom);
        BottomCentre : FHandles [I].Rect := Rect (3, (cBottom - 3), (cRight - 3), cBottom);
        BottomRight  : FHandles [I].Rect := Rect ((cRight - 3), (cBottom - 4), cRight, cBottom);
      Else
        FHandles [I].Enabled := False;
        FHandles [I].Rect := Rect (0, 0, 0, 0);
      End; { Case }
end;

procedure TSBSDragControl.PaintHandles;
Var
  I : THandles;
begin
  With Canvas do begin
    { Draw handle in top left corner }
    Pen.Width := 1;
    Pen.Style := psSolid;
    If Assigned(FController) And FController.IsSelected(Self) Then
      Pen.Color := clRed
    Else
      Pen.Color := clGray;

    MoveTo (0,         0);
    LineTo (Width - 1, 0);
    LineTo (Width - 1, Height - 1);
    LineTo (0,         Height - 1);
    LineTo (0,         0);

    CalcHandleRects;
  End; { With }
end;

procedure TSBSDragControl.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  inherited;
  FHitTest := SmallPointToPoint(Msg.Pos);
end;

procedure TSBSDragControl.WMSetCursor(var Msg: TWMSetCursor);
var
  Cur: HCURSOR;
  I : THandles;
begin
  If FAllowSizing Then Begin
    Cur := 0;

    FHitTest := ScreenToClient(FHitTest);

    If Assigned (FController) And FController.JustMe(Self) Then
      For I := TopLeft To BottomRight Do
        If FHandles [I].Enabled And (Cur = 0) Then
          With FHandles [I] Do
            If ((FHitTest.X >= Rect.Left) And (FHitTest.X <= Rect.Right)) And
               ((FHitTest.Y >= Rect.Top) And (FHitTest.Y <= Rect.Bottom)) Then Begin
              Case I Of
                TopLeft      : Cur := LoadCursor(0, IDC_SIZENWSE);
                TopCentre    : Cur := LoadCursor(0, IDC_SIZENS);
                TopRight     : Cur := LoadCursor(0, IDC_SIZENESW);
                CentreLeft   : Cur := LoadCursor(0, IDC_SIZEWE);
                CentreRight  : Cur := LoadCursor(0, IDC_SIZEWE);
                BottomLeft   : Cur := LoadCursor(0, IDC_SIZENESW);
                BottomCentre : Cur := LoadCursor(0, IDC_SIZENS);
                BottomRight  : Cur := LoadCursor(0, IDC_SIZENWSE);
              End; { Case }

              If (Cur <> 0) Then
                FSizeType := I;
            End; { If }

    If (Cur <> 0) then begin
      SetCursor(Cur);
      FState := dsSizing;
    End { If }
    Else Begin
      FState := dsNone;
      Inherited;
    End; { Else }
  End { If }
  Else
    Inherited;

  If Assigned (FController) And FController.PageHandleSet Then
    FController.Page.DispMsg (msgidx_ControlInfo, GetStatusInfo);
end;

procedure TSBSDragControl.WMRButtonDown(var Message: TWMRButtonDown);
begin
  If (Controller <> Nil) And
     (GetMouseCapture <> Handle) And
     (Not (csDesigning In ComponentState)) Then Begin
    FRButt.X := Message.Pos.X;
    FRButt.Y := Message.Pos.Y;
    Controller.SetCurrControl (Self);

    Inherited;
  End; { If }
end;

procedure TSBSDragControl.WMRButtonUp(var Message: TWMRButtonUp);
begin
  If (Controller <> Nil) And
     (GetMouseCapture <> Handle) Then Begin
    Inherited;
  End; { If }
end;

procedure TSBSDragControl.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  OptionsDialog;
end;

Procedure TSBSDragControl.WMCaptureChanged (var Message: TMessage);
begin
  {DBug.Msg(1, 'WMCaptureChanged');}
end;

procedure TSBSDragControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ScreenDC : HDC;
begin
  Inherited MouseDown (Button, Shift, X, Y);

  FShift := Shift;

  If Assigned(FController) And (Not (csDesigning In ComponentState)) Then Begin
    FController.SetCurrControl (Self);

    If (Button = mbLeft) Then Begin
      If CanFocus Then SetFocus;

      If (FState = dsNone) Then FState := dsMoving;

      If (FState = dsSizing) Then
        FController.SelectControl (Self, False);

      If (FState In [dsMoving, dsSizing]) Then Begin
        SetMouseCapture(Self);

        FXOffset  := X;
        FYOffset  := Y;

        { Get position & size in screen coords }
        SizeRect := BoundsRect;
        SizeRect.TopLeft := Parent.ClientToScreen(SizeRect.TopLeft);
        SizeRect.BottomRight := Parent.ClientToScreen(SizeRect.BottomRight);

        { Draw move/size box on the screen }
        BoxRect := SizeRect;
        DrawBox (EmptyRect, BoxRect);

        If (FState = dsMoving) And Assigned (FController) And FController.IsSelected(Self) Then Begin
          { pass any movement stuff to controller }
          FController.SelectMove (Self, 0, 0, 1);
        End; { If }
      End
      Else
        { some control might have other things to do }
        ControlMouseDown(Button, Shift, X, Y);
    End; { If }
  End; { If }
End;

procedure TSBSDragControl.ControlMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  { dummy function - cannot use abstract just in case its called }
End;

procedure TSBSDragControl.MouseMove(Shift: TShiftState; X, Y: Integer);
Var
  ScreenDC : HDC;
  Coords, TmpCo   : TPoint;
  TempRect : TRect;
  cHeight, cWidth : Integer;
begin
  If (GetMouseCapture = Handle) And (ssLeft In Shift) Then Begin
    { Take copy of current rectangle coords }
    TempRect := BoxRect;

    Case FState Of
      dsNone   : { No action required };
      dsSizing : Begin
                   { Check mouse is in a valid position }
                   If Controller.PageHandleSet Then Begin
                     Controller.Page.CheckMouseSizePos (Self);

                     { Get mouse position }
                     GetCursorPos (Coords);

                     { Calculate size rectangle }
                     If (FSizeType In [TopLeft, CentreLeft, BottomLeft]) Then
                       SizeRect.Left := Coords.X;
                     If (FSizeType In [TopLeft, TopCentre, TopRight]) Then
                       SizeRect.Top := Coords.Y;
                     If (FSizeType In [TopRight, CentreRight, BottomRight]) Then
                       SizeRect.Right := Coords.X;
                     If (FSizeType In [BottomLeft, BottomCentre, BottomRight]) Then
                       SizeRect.Bottom := Coords.Y;

                     { Position correctly on the grid }
                     Controller.Grid.ScreenSnapToGrid (SizeRect, 2);

                     { Draw the resize box }
                     BoxRect := SizeRect;
                     DrawBox (TempRect, BoxRect);
                   End; { If }
                 End;
      dsMoving : Begin
                   { Check mouse is in a valid position }
                   If (FState = dsMoving) And (Not FController.IsSelected(Self)) Then
                     FController.SelectControl (Self, False);

                   If Controller.PageHandleSet Then Begin
                     Controller.Page.CheckMousePos (Self, FXOffset, FYOffset);

                     { Get mouse position }
                     GetCursorPos (Coords);

                     { Calculate position of box in screen coords }
                     SizeRect.Top    := Coords.Y - FYOffset;
                     SizeRect.Left   := Coords.X - FXOffset;
                     SizeRect.Bottom := SizeRect.Top + Height;
                     SizeRect.Right  := SizeRect.Left + Width;

                     { Make sure the box is positioned ok on the grid }
                     Controller.Grid.ScreenSnapToGrid (SizeRect, 1);

                     { Draw the drag box }
                     BoxRect := SizeRect;
                     DrawBox (TempRect, BoxRect);

                     If Assigned (FController) And FController.IsSelected(Self) Then Begin
                       { pass any movement stuff to controller }
                       TmpCo := Parent.ClientToScreen (BoundsRect.TopLeft);
                       TmpCo.X := TmpCo.X + FXOffset;
                       TmpCo.Y := TmpCo.Y + FYOffset;
                       FController.SelectMove (Self, (Coords.X - TmpCo.X), (Coords.Y - TmpCo.Y), 2);
                     End; { If }
                   End; { If }
                 End;
    Else
      ControlMouseMove(Shift, X, Y);
    End; { Case }
  End; { If }

  If Assigned (FController) Then
    If FController.PageHandleSet Then
      FController.Page.DispCursorPos;

  Inherited MouseMove (Shift, X, Y);
end;

procedure TSBSDragControl.ControlMouseMove(Shift: TShiftState; X, Y: Integer);
Begin
  { dummy function - cannot use abstract just in case its called }
End;

procedure TSBSDragControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ScreenDC :  HDC;
  TempRect : TRect;
begin
  If (GetMouseCapture = Handle) And (Button = mbLeft) And Assigned (FController) Then Begin
    If (FState In [dsSizing, dsMoving]) Then Begin
      { Get screen handle and undraw the focus rectangle }
      ScreenDC:=GetDC(0);
      DrawFocusRect(ScreenDC,BoxRect);
      ReleaseDC(0,ScreenDC);

      { Check that the control has changed position or size }
      TempRect := BoundsRect;
      With TempRect do Begin
        Right  := Left + Canvas.ClipRect.Right;
        Bottom := Top + Canvas.ClipRect.Bottom;

        TopLeft := Parent.ClientToScreen(Point(Left,Top));
        BottomRight := Parent.ClientToScreen(Point(Right,Bottom));
      end;

      If Not EqualRect (SizeRect, TempRect) Then Begin
        { Convert screen rect coords to client }
        Controller.ScreenRectToClient (SizeRect);

        SetBounds (SizeRect.Left, SizeRect.Top, SizeRect.Right - SizeRect.Left, SizeRect.Bottom - SizeRect.Top);

        If (FState = dsMoving) Then Begin
          FController.PaintControlPage (Self.BoundsRect);
          If FController.IsSelected(Self) Then FController.SelectMove (Self, 0, 0, 3);
          {Invalidate;}
          Refresh;
        End; { If }

        ChangeMade;
      End; { If }

      If (ssShift In Shift) Or (ssCtrl In Shift) Then Begin
        If Not FController.IsSelected(Self) Then
          { add to selection group }
          FController.SelectControl (Self, True)
        Else Begin
          { remove from selection group }
          FController.DeSelectControl (Self);
          If (FState = dsMoving) Then FController.SelectMove (Self, 0, 0, 6);
        End; { Else }
      End { If }
      Else
        If Not FController.IsSelected(Self) Then
          { start new selection group based on this control }
          FController.SelectControl (Self, False);

      ReleaseMouseCapture(self);
    End
    Else
      ControlMouseUp(Button, Shift, X, Y);
  End; { If }

  FState := dsNone;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TSBSDragControl.ControlMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  { dummy function - cannot use abstract just in case its called }
End;

procedure TSBSDragControl.KeyDown(var Key: Word; Shift: TShiftState);
Var
  XPix, YPix : LongInt;
begin
  If Assigned (FController) And (GetMouseCapture <> Handle) Then Begin
    If (Key In [VK_DELETE, VK_LEFT, VK_UP, VK_RIGHT, VK_DOWN]) Then Begin
      If (Key In [VK_LEFT, VK_UP, VK_RIGHT, VK_DOWN]) Then
        { Calculated number of pixels to move }
        With Controller, Page Do Begin
          If Grid.grSnapToGrid Then Begin
            XPix := Paper.InPixels (Grid.grXSpacing);
            YPix := Paper.InPixels (Grid.grYSpacing);
          End { If }
          Else Begin
            XPix := Paper.InPixels (1);
            YPix := Paper.InPixels (1);
          End; { Else }

          If (ssCtrl In Shift) Then Begin
            XPix := XPix * 10;
            YPix := YPix * 10;
          End; { If }
        End; { With }

      LockWindowUpdate (TForm(Controller.Page.Parent).Handle);
      If (Not (ssShift In Shift)) And (Not (ssAlt In Shift)) Then
        { Moving }
        Case Key Of
          VK_LEFT   : Begin
                        Left := Left - XPix;
                        If FController.IsSelected(Self) Then
                          FController.SelectMove (Self, -XPix, 0, 4);
                      End;
          VK_UP     : Begin
                        Top := Top - YPix;
                        If FController.IsSelected(Self) Then
                          FController.SelectMove (Self, 0, -YPix, 4);
                      End;
          VK_RIGHT  : Begin
                        Left := Left + XPix;
                        If FController.IsSelected(Self) Then
                          FController.SelectMove (Self, XPix, 0, 4);
                      End;
          VK_DOWN   : Begin
                        Top := Top + YPix;
                        If FController.IsSelected(Self) Then
                          FController.SelectMove (Self, 0, YPix, 4);
                      End;
          VK_DELETE : Begin
                        Controller.DeleteSelected;
                        {If FController.IsSelected(Self) Then
                          FController.SelectMove (Self, 0, 0, 5);}
                      End;
        End { Case }
      Else Begin
        If (ssAlt In Shift) Then
          { Resizing - Making smaller }
          Case Key Of
            VK_LEFT   : Width := Width - XPix;
            VK_UP     : Height := Height - YPix;
            VK_RIGHT  : Begin
                          Left := Left + XPix;
                          Width := Width - XPix;
                        End;
            VK_DOWN   : Begin
                          Top := Top + YPix;
                          Height := Height - YPix;
                        End;
            VK_DELETE : Controller.DeleteSelected;
          End { Case }
        Else
          { Resizing - Making bigger }
          Case Key Of
            VK_LEFT   : Begin
                          Left := Left - XPix;
                          Width := Width + XPix;
                        End;
            VK_UP     : Begin
                          Top := Top - YPix;
                          Height := Height + YPix;
                        End;
            VK_RIGHT  : Width := Width + XPix;
            VK_DOWN   : Height := Height + YPix;
            VK_DELETE : Controller.DeleteSelected;
          End { Case }
      End; { If }

      If (Key In [VK_LEFT, VK_UP, VK_RIGHT, VK_DOWN]) Then Begin
        Controller.Grid.SnapControlToGrid (Self, False, 1);
        Controller.PaintControlPage (Self.BoundsRect);
        ChangeMade;
      End; { If }
      LockWindowUpdate(0);               { enable window painting }
    End; { If }
  End; { If }
  
  Inherited KeyDown (Key, Shift);
end;

procedure TSBSDragControl.WMGetDLGCode(var Message: TMessage);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TSBSDragControl.SetSuspend (Value : Boolean);
begin
  If (Value <> FSuspendPaint) Then Begin
    FSuspendPaint := Value;
    Paint;
  End;
end;

Function TSBSDragControl.GetName : ShortString;
begin
  Result := 'BaseClass';
end;

Function TSBSDragControl.GetStatusInfo : ShortString;
begin
  Result := ControlId + ': ' + GetFieldInfo + ' ' + GetPosStr;
end;

Function TSBSDragControl.GetFieldInfo : ShortString;
begin
  Result := '';
end;

Function TSBSDragControl.GetPosStr : ShortString;
Var
  CoOrds : TPoint;
begin
  If Assigned (FController) Then
    If FController.PaperHandleSet And FController.PageHandleSet Then
      With FController, Paper Do Begin
        { adjust for border area }
        CoOrds := BoundsRect.TopLeft;
        CoOrds.X := CoOrds.X - psBorderWidth - 1 + Page.HorzScrollBar.Position;
        CoOrds.Y := CoOrds.Y - psBorderWidth - 1 + Page.VertScrollBar.Position;

        { convert to mm }
        CoOrds.X := InMM(CoOrds.X);
        CoOrds.Y := InMM(CoOrds.Y);

        { Check > 0 }
        If (CoOrds.X < 0) Then CoOrds.X := 0;
        If (CoOrds.Y < 0) Then CoOrds.Y := 0;

        Result := '(T=' + IntToStr (CoOrds.Y) +
                  ',L=' + IntToStr (CoOrds.X) +
                  ',H=' + IntToStr (InMM(Height)) +
                  ',W=' + IntToStr (InMM(Width))+
                  ')';
      End; { With }
end;

Function TSBSDragControl.GetIdPrefix : String10;
begin
  Result := 'Drag';
end;

procedure TSBSDragControl.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  { This message must be intercepted otherwise    }
  { the background area of the control is cleared }
  { to the background colour                      }
end;

Function TSBSDragControl.OptionsDialog : Boolean;
begin
  Result := False;
  If Assigned (FOnOptions) And Assigned(FController) Then Begin
    FOnOptions (Self);
    Result := OptionsOk;
    If Result Then Begin
      FController.RedrawVisible;
      {FController.PaintControlPage (Self.BoundsRect);}
      {Paint;}
      ChangeMade;
    End; { If }
  End; { If }
end;

Procedure TSBSDragControl.ReDraw;
begin
  Controller.Page.Invalidate;
  Invalidate;
end;

Function TSBSDragControl.GetDefRec : FormDefRecType;
begin
  FillChar (Result, SizeOf (Result), #0);

  With Result do Begin
    { ... }
  End; { With }
end;

Procedure TSBSDragControl.InitByDefRec (Const DefRec : FormDefRecType);
begin
  { Dummy procedure }
end;

{ Converts a mm paper position to a delphi control position }
Function TSBSDragControl.MMToPixels(CoOrd : LongInt) : LongInt;
begin
  Result := FController.Paper.InPixels(CoOrd);

  If (Result <= 0) Or (Result > 32000) Then
    Result := Round(FController.Paper.psScaling * 10);
end;

{ Converts a mm paper position to a delphi control position }
Function TSBSDragControl.MMToPixelsH(CoOrd : LongInt) : LongInt;
begin
  If Assigned (FController) Then
    If FController.PaperHandleSet And FController.PageHandleSet Then
      With FController Do Begin
        { Convert mm to pixels }
        Result := Paper.InPixels(CoOrd);

        { Check it is within the valid page width }
        With Paper Do
          If (Result < 0) Or (Result >= (psPageWidth * psScaling)) Then
            Result := psBorderWidth + 1 + Round(psScaling);

        { Adjust for scrolling position }
        Result := Result - Page.HorzScrollBar.Position;

        { Add on pixels to cover page border }
        Result := Result + Paper.psBorderWidth + 1;
     End; { With }
end;

{ Converts a mm paper position to a delphi control position }
Function TSBSDragControl.MMToPixelsV(CoOrd : LongInt) : LongInt;
begin
  If Assigned (FController) Then
    If FController.PaperHandleSet And FController.PageHandleSet Then
      With FController Do Begin
        { Convert mm to pixels }
        Result := Paper.InPixels(CoOrd);

        { Check it is within the valid page width }
        With Paper Do
          If (Result < 0) Or (Result >= (psPageHeight * psScaling)) Then
            Result := psBorderWidth + 1 + Round(psScaling);

        { Adjust for scrolling position }
        Result := Result - Page.VertScrollBar.Position;

        { Add on pixels to cover page border }
        Result := Result + Paper.psBorderWidth + 1;
     End; { With }
end;

{ Converts a delphi control position to a mm paper position }
Function TSBSDragControl.PixelsToMM(CoOrd : LongInt) : LongInt;
begin
  Result := FController.Paper.InMM(CoOrd);

  If (Result < 0) Or (Result > 32000) Then
    Result := Round(FController.Paper.psScaling * 10);
end;

{ Converts a delphi control position to a mm paper position }
{ Taken horizontally from Left of page }
Function TSBSDragControl.PixelsToMMH(CoOrd : LongInt) : LongInt;
begin
  If Assigned (FController) Then
    If FController.PaperHandleSet And FController.PageHandleSet Then
      With FController Do Begin
        { Adjust for scrolling position }
        Coord := Coord + Page.HorzScrollBar.Position;

        { Add on pixels to cover page border }
        Coord := Coord - Paper.psBorderWidth - 1;

        { Convert pixels to mm }
        Result := Paper.InMM(CoOrd);

        { Check its within a valid range }
        If (Result < 0) Then Result := 0;
        If (Result > 32000) Then Result := 32000;
      End; { With }
end;

{ Converts a delphi control position to a mm paper position }
{ Taken vertically from top of page }
Function TSBSDragControl.PixelsToMMV(CoOrd : LongInt) : LongInt;
begin
  If Assigned (FController) Then
    If FController.PaperHandleSet And FController.PageHandleSet Then
      With FController Do Begin
        { Adjust for scrolling position }
        Coord := Coord + Page.VertScrollBar.Position;

        { Add on pixels to cover page border }
        Coord := Coord - Paper.psBorderWidth - 1;

        { Convert pixels to mm }
        Result := Paper.InMM(CoOrd);

        { Check its within a valid range }
        If (Result < 0) Then Result := 0;
        If (Result > 32000) Then Result := 32000;
     End; { With }
end;

{ called during the create after the initial options are set, this }
{ can be used to default the size of the control, etc              }
Procedure TSBSDragControl.SetInitialSize;
begin
  { Dummy Procedure }
end;

{ Called every time the control is moved, resized, or properties changed etc. }
Procedure TSBSDragControl.ChangeMade;
begin
  If Assigned (FController) Then
    FController.ChangeMade;
end;

Procedure TSBSDragControl.SetOnOptions(Value : TNotifyEvent);
begin
  FOnOptions := Value;
  {OnDblClick := Value;}
end;

procedure TSBSDragControl.Click(Sender: TObject);
begin
  (*****
DBug.Msg (1, ControlId + ': Click');
  If Assigned (FController) Then Begin
    If (ssShift In FShift) Or (ssCtrl In FShift) Then Begin
      If Not FController.IsSelected(Self) Then
        { add to selection group }
        FController.SelectControl (Self, True)
      Else
        { remove from selection group }
        FController.DeSelectControl (Self);
    End { If }
    Else
      If Not FController.IsSelected(Self) Then
        { start new selection group based on this control }
        FController.SelectControl (Self, False);
  End; { If }
  *****)
end;

Procedure TSBSDragControl.SelectMove (Const XOff, YOff : SmallInt;
                                      Const Mode       : Byte);
Var
  Temp : TRect;
Begin
  Case Mode Of
    1 : Begin { MouseDown }
          SelMove1 := EmptyRect;
          SelMove2 := EmptyRect;

          { define the movement rect }
          SelMove2.TopLeft := Parent.ClientToScreen(BoundsRect.TopLeft);
          SelMove2.Top := SelMove2.Top + YOff;
          SelMove2.Left := SelMove2.Left + XOff;
          SelMove2.Right := SelMove2.Left + Width;
          SelMove2.Bottom := SelMove2.Top + Height;

          { draw the movement rect }
          SelMove1 := SelMove2;
          DrawBox (EmptyRect, SelMove1);
        End;
    2 : Begin { MouseMove }
          { update the movement rect }
          SelMove2.TopLeft := Parent.ClientToScreen(BoundsRect.TopLeft);
          SelMove2.Top := SelMove2.Top + YOff;
          SelMove2.Left := SelMove2.Left + XOff;
          SelMove2.Right := SelMove2.Left + Width;
          SelMove2.Bottom := SelMove2.Top + Height;
          Controller.Grid.ScreenSnapToGrid (SelMove2, 1);

          { draw the movement rect }
          Temp := SelMove2;
          DrawBox (SelMove1, Temp);
          SelMove1 := Temp;
        End;
    3 : Begin { MouseUp }
          DrawBox (EmptyRect, SelMove1);       { undraw the movement box }
          SelMove1 := EmptyRect;

          { Drop the control }
          Controller.ScreenRectToClient (SelMove2);
          SetBounds (SelMove2.Left, SelMove2.Top, Width, Height);
        End;
    4 : Begin { KeyPress }
          SetBounds (Left + XOff, Top + YOff, Width, Height);
        End;
    5 : { Deletion - No Action } ;
    6 : Begin { undraw the move box }
          DrawBox (EmptyRect, SelMove1);
          SelMove1 := EmptyRect;
        End;
  End; { Case }
End;

Function TSBSDragControl.GetIf : fdIfInfoType;
Begin
  Result := FPrintIf;
End;

Procedure TSBSDragControl.FontDialog;
Begin
  { Dummy proc to stop errors in controls without fonts }
End;

{**************************************************************}
{* TSBSDragText: Text control for use on the page control.    *}
{**************************************************************}
constructor TSBSDragText.Create(AOwner: TComponent);
begin
  Inherited Create (AOwner);

  FText := '';
  FFont := TFont.Create;
  FTextAlign := taLeftJustify;

  // HM 13/11/00: Added support for Symvbol Fonts
  FIsSymbolFont := False;
end;

destructor TSBSDragText.Destroy;
begin
  FFont.Free;

  Inherited Destroy;
end;

procedure TSBSDragText.PaintControl;
Var
  PaintRect  : TRect;
  PaintFlags : Word;
begin
  With Canvas do Begin
    Pen.Color := clBlack;
    Brush.Style := bsClear;

    { Calc Flags }
    Case FTextAlign Of
      taLeftJustify  : PaintFlags := DT_LEFT;
      taRightJustify : PaintFlags := DT_RIGHT;
      taCenter       : PaintFlags := DT_CENTER;
    Else
      PaintFlags := DT_LEFT;
    End; { Case }
    PaintFlags := PaintFlags Or DT_VCENTER Or DT_EXPANDTABS Or DT_WORDBREAK Or DT_NOPREFIX;
    PaintRect := ClientRect;
    FontToVisFont(FFont, Canvas.Font);
    CanvasDrawText (Canvas, Text, PaintRect, PaintFlags);
  End; { With }
end;

procedure TSBSDragText.SetTextAlign(Value: TAlignment);
begin
  If (Value <> FTextAlign) Then Begin
    FTextAlign := Value;
    Invalidate;
  End;
end;

procedure TSBSDragText.SetText (Value : ShortString);
begin
  If (Value <> FText) Then Begin
    FText := Value;
    Invalidate;
  End;
end;

procedure TSBSDragText.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  Invalidate;
end;

Function TSBSDragText.GetName : ShortString;
begin
  Result := Text;
end;

Function TSBSDragText.GetFieldInfo : ShortString;
begin
  Result := '''' + Text + '''';
end;

Function TSBSDragText.GetIdPrefix : String10;
begin
  Result := 'Text';
end;

Function TSBSDragText.GetDefRec : FormDefRecType;
begin
  FillChar (Result, SizeOf (Result), #0);

  With Result do Begin
    fdFieldClass := fdcText;
    fdControlId  := ControlId;


    With Text Do Begin
      ftXPos    := PixelsToMMH(Left);
      ftYPos    := PixelsToMMV(Top);
      ftWidth   := PixelsToMM(Width);
      ftHeight  := PixelsToMM(Height);
      ftText    := FText;
      ftJustify := FTextAlign;

      FontToRec (Font, ftFont);

      ftIf := FPrintIf;

      // HM 13/11/00: Added support for Symvbol Fonts
      ftSymbolFont := FIsSymbolFont;
    End; { With }
  End; { With }
end;


Procedure TSBSDragText.InitByDefRec (Const DefRec : FormDefRecType);
begin
  Left   := MMToPixelsH(DefRec.Text.ftXPos);
  Top    := MMToPixelsV(DefRec.Text.ftYPos);
  Width  := MMToPixels(DefRec.Text.ftWidth);
  Height := MMToPixels(DefRec.Text.ftHeight);
  FText  := DefRec.Text.ftText;
  FTextAlign := DefRec.Text.ftJustify;
  ControlId := DefRec.fdControlId;

  FontRecToFont (Font, DefRec.Text.ftFont);

  FPrintIf := DefRec.Text.ftIf;

  // HM 13/11/00: Added support for Symbol Fonts
  FIsSymbolFont := DefRec.Text.ftSymbolFont;

  Invalidate;
end;

Procedure TSBSDragText.SetInitialSize;
var
  TheRect    : TRect;
  TmpFont    : fdFontDefType;
  TheText    : ANSIString;
  PaintFlags : Word;
begin
  { Take temporary copy of previous font }
  FontToRec (Canvas.Font, TmpFont);

  { Copy in specified font }
  Canvas.Font.Assign (FFont);
  SetVisFontHeight (Canvas.Font, FFont.Size);

  { Get size of font }
  TheRect := Rect (1, 1, 2, 2);
  TheText := FText;
  PaintFlags := DT_CALCRECT Or DT_SINGLELINE;
  CanvasDrawText (Canvas, TheText, TheRect, PaintFlags);

  { restore temporary copy of previous font }
  FontRecToFont (Canvas.Font, TmpFont);

  { Set control size }
  Width := (TheRect.Right - TheRect.Left) + Round(FController.Paper.psScaling);
  Height := (TheRect.Bottom - TheRect.Top);

  { Check that the field can fit on the page }
  If Assigned (FController) Then
    If (Width > (FController.FormDetails.ftPaperWidth * FController.Paper.psScaling)) Then
      Width := Round(FController.FormDetails.ftPaperWidth * FController.Paper.psScaling) - Round(10 * FController.Paper.psScaling);
End;

Procedure TSBSDragText.FontDialog;
Var
  FontDialog : TFontDialog;
begin
  FontDialog := TFontDialog.Create(Self);
  Try
    FontDialog.Font.Assign(FFont);

    If FontDialog.Execute Then
      FFont.Assign(FontDialog.Font);
  Finally
    FontDialog.Free;
  End;
End;


{******************************************************************}
{* TSBSDragBitmap: Bitmap control for use on the page control.    *}
{******************************************************************}
constructor TSBSDragBitmap.Create(AOwner: TComponent);
begin
  Inherited Create (AOwner);

  FPicture := TPicture.Create;
  IsOpaque := True;
end;

procedure TSBSDragBitmap.ChangeParams(var Params: TCreateParams);
Begin
  { Hopefully takes out the transparency }
End;

destructor TSBSDragBitmap.Destroy;
begin
  FPicture.Free;

  Inherited Destroy;
end;

procedure TSBSDragBitmap.PaintControl;
Var
  Dest: TRect;
begin
  With Canvas do Begin
    Dest := ClientRect;

    StretchDraw(Dest, FPicture.Graphic);

    If Assigned (FController) And FController.IsSelected(Self) Then
      PaintHandles;
  End; { With }
end;

Function TSBSDragBitmap.GetName : ShortString;
begin
  Result := 'Image: ' + FBitPath;
end;

Function TSBSDragBitmap.GetFieldInfo : ShortString;
begin
  Result := FBitPath;
end;

Function TSBSDragBitmap.GetIdPrefix : String10;
begin
  Result := 'Image';
end;

{ displays the options dialog for the bitmap control }
Function TSBSDragBitmap.OptionsDialog : Boolean;
Var
  OpenDialog : TOpenDialog;
  FileInfo   : SplitFNameType;
  FormPath   : String;
  CopyIt     : Boolean;
  CurDirStr  : String;
  FromFile, ToFile : ANSIString;
begin
  Result := False;

  Try
    OpenDialog := TOpenDialog.Create (Self);

    CurDirStr := GetCurrentDir;

    OpenDialog.DefaultExt := 'BMP';
    OpenDialog.FileEditStyle := fsEdit;
    // MH 06/02/2017 ABSEXCH-14925 2017-R1: Added support for extra image types
    OpenDialog.Filter := OpenDialogFilter;
    OpenDialog.FilterIndex := 1;
    OpenDialog.HelpContext := 305;
    OpenDialog.InitialDir := SystemInfo.ExDataPath + FormsPath;
    OpenDialog.Options := [ofHideReadOnly,ofPathMustExist,ofFileMustExist,ofShowHelp];
    OpenDialog.Title := 'Load Image';

    If (FBitPath <> '') Then Begin
      { A bitmap has been selected previously }
      FileInfo := SplitFileName (FBitPath);
      OpenDialog.FileName := FileInfo.FileName;
      If (FileInfo.Path = '') Then Begin
        { no path - default to path of form def }
        OpenDialog.InitialDir := SystemInfo.ExDataPath;
        If Assigned(FController) Then
          { Check its been saved }
          If (Trim(FController.FormDetails.ftFormPath) <> '') Then Begin
            { Get path of form def }
            OpenDialog.InitialDir := SplitFileName(FController.FormDetails.ftFormPath).Path;
          End; { If }
      End { If }
      Else
        { has path on the filename }
        If (FileInfo.Path <> UpperCase(FormsPath)) Then
          OpenDialog.InitialDir := FileInfo.Path;
    End; { If }

    If OpenDialog.Execute Then Begin
      FileInfo := SplitFileName (OpenDialog.FileName);

      { Check it exists (Who said I was paranoid) }
      If FileExists (OpenDialog.FileName) Then Begin
        FBitPath := OpenDialog.FileName;

        Try
          // MH 06/02/2017 ABSEXCH-14925 2017-R1: Added support for extra image types
          LoadImageFromFile (FBitPath, FPicture.Bitmap);

          If Assigned (Controller) Then
            With Controller, FormDetails, Paper Do Begin
              If (FPicture.Width > (GetWorkingWidth * psScaling)) Then
                Width := Round(GetWorkingWidth * psScaling)
              Else
                Width := FPicture.Width;

              If (FPicture.Height > (GetWorkingHeight * psScaling)) Then
                Height := Round(GetWorkingHeight * psScaling)
              Else
                Height := FPicture.Height;
            End { With }
          Else Begin
            Height   := FPicture.Height;
            Width    := FPicture.Width;
          End; { Else }
          Result := True;
        Except
          Result := False;
          MessageDlg ('''' + Trim(OpenDialog.FileName) + ''' is not a valid image',
                      mtError,
                      [mbOk],
                      0);
        End;

        If Result Then Begin
          { Check to see if its in the Forms\ Directory }
          FormPath := SplitFileName(SystemInfo.ExDataPath + FormsPath).Path;
          If (FileInfo.Path <> FormPath) Then Begin
            { Not in the correct directory }
            Case MessageDlg ('Warning: This Image is not in the Exchequer Forms directory ' +
                            'and may not load correctly later. Do you wish to copy ' +
                            'it into the Forms directory.', mtConfirmation, mbYesNoCancel, 0) Of
              mrYes    : Begin
                           { Check it doesn't already exist in forms }
                           If FileExists (FormPath + FileInfo.Filename) Then
                             Case MessageDlg ('A file ''' + FileInfo.Filename + ''' already exists in the Forms directory. ' +
                                              'Do you want to overwrite it', mtConfirmation, [mbYes, mbNo], 0) Of
                               mrYes : CopyIt := True;
                               mrNo  : CopyIt := False;
                             End { Case }
                           Else
                             CopyIt := True;

                           If CopyIt Then
                             { Copy it to forms\ }

                             // MH 16/02/2017 ABSEXCH-14925 2017-R1: Modified copying of images - so it works for non-bitmaps!
                             FromFile := FBitPath;
                             ToFile := FormPath + FileInfo.Filename;
                             If CopyFile (PCHAR(FromFile), PCHAR(ToFile), False) Then      // False = Overwrite existing files 
                               // Update the bitmap path to point to the file in the Forms directory
                               FBitPath := FormsPath + FileInfo.Filename
                             Else
                               MessageDlg ('An error occured saving the image to ''' + Trim(FormPath + FileInfo.Filename) + '''',
                                           mtError,
                                           [mbOk],
                                           0);
                         End;

              mrNo     : { no Action - use original path } ;

              mrCancel : Result := False; { Cancel creation of control }
            End; { Case }
          End; { If }

          If Assigned (Controller) Then
            Controller.RedrawVisible;
        End; { If }
      End { If }
      Else
        { File doesn't exist }
        MessageDlg ('Cannot find ''' + Trim(OpenDialog.FileName) + '''',
                    mtError,
                    [mbOk],
                    0);
    End; { If }

    SetCurrentDir(CurDirStr);
  Finally
    OpenDialog.Free;
  End;
end;

Procedure TSBSDragBitmap.ShellEditor;
Var
  ThePath : PChar;
begin
  ThePath := StrAlloc (Length(FBitPath) + 1);
  StrPCopy (ThePath, FBitPath);
  ShellExecute (Handle, 'open', ThePath, '', '', SW_RESTORE);
  StrDispose (ThePath);
end;

Function TSBSDragBitmap.GetDefRec : FormDefRecType;
begin
  FillChar (Result, SizeOf (Result), #0);

  With Result do Begin
    fdFieldClass := fdcBitmap;
    fdControlId := ControlId;

    With Bitmap Do Begin
      fbXPos       := PixelsToMMH(Left);
      fbYPos       := PixelsToMMV(Top);
      fbWidth      := PixelsToMM(Width);
      fbHeight     := PixelsToMM(Height);
      fbBitmapPath := FBitPath;
      fbIf         := FPrintIf;
    End; { With }
  End; { With }
end;


Procedure TSBSDragBitmap.InitByDefRec (Const DefRec : FormDefRecType);
Var
  Found    : Boolean;
  FName    : String;
  FileInfo : SplitFNameType;
begin
  ControlId := DefRec.fdControlId;
  Left     := MMToPixelsH(DefRec.Bitmap.fbXPos);
  Top      := MMToPixelsV(DefRec.Bitmap.fbYPos);
  Width    := MMToPixels(DefRec.Bitmap.fbWidth);
  Height   := MMToPixels(DefRec.Bitmap.fbHeight);
  FBitPath := DefRec.Bitmap.fbBitmapPath;

  FPrintIf := DefRec.Bitmap.fbIf;

  { Load bitmap }
  Try
    If GetBitmapPath (FBitPath, FController.FormDetails.ftFormPath, FName) Then
      // MH 06/02/2017 ABSEXCH-14925 2017-R1: Added support for extra image types
      LoadImageFromFile (FName, FPicture.Bitmap)
    Else Begin
      MessageDlg ('The bitmap ''' + FBitPath + ''' could not be found.',
                  mtError, [mbOk], 0);

      { Set to white if cannot load bitmap - otherwise it takes whatever is on the screen }
      FPicture.Bitmap.Height := 1;
      FPicture.Bitmap.Width := 1;
      FPicture.Bitmap.Canvas.Pixels[1,1] := clWhite;
    End; { Else }
  Except
    MessageDlg ('An error occured loading the bitmap ''' + FBitPath + '''', mtError, [mbOk], 0);
  End;
end;


{******************************************************************}
{* TSBSDragBox: Box control for use on the page control.          *}
{******************************************************************}
constructor TSBSDragBox.Create(AOwner: TComponent);
begin
  Inherited Create (AOwner);

  FPenWidth := 1;
  FPenColor := clBlack;
  FLeftBorder   := True;
  FTopBorder    := True;
  FRightBorder  := True;
  FBottomBorder := True;
  FFill := False;
end;

destructor TSBSDragBox.Destroy;
begin
  Inherited Destroy;
end;

procedure TSBSDragBox.PaintControl;
Var
  rLeft, rTop, rRight, rBottom : Word;
begin
  With Canvas do Begin
    rLeft   := 2 * DefaultPixPerMM - 1;
    rTop    := 2 * DefaultPixPerMM - 1;
    rRight  := Width - (2 * DefaultPixPerMM) - 1;
    rBottom := Height - (2 * DefaultPixPerMM) - 1;

    If Not FFill Then Begin
      Pen.Width := FPenWidth;
      Pen.Color := FPenColor;
      Pen.Style := psSolid;
      Pen.Mode := pmCopy;
      Brush.Color := FPenColor;
      Brush.Style := bsSolid;

      If FTopBorder Then
        If True{(FPenWidth = 1)} Then Begin
          MoveTo (rLeft,  rTop);
          LineTo (rRight, rTop);
        End { If }
        Else
          {Rectangle (1, 1, Width, FPenWidth);}
          FillRect(Rect(0, 0, Width, FPenWidth));

      If FRightBorder Then
        If True{(FPenWidth = 1)} Then Begin
          MoveTo (rRight, rTop);
          LineTo (rRight, rBottom);
        End { If }
        Else Begin
          {Rectangle ((Width - FPenWidth + 1), 1, Width, Height);}
          FillRect(Rect((Width - FPenWidth), 0, Width, Height));
        End; { Else }

      If FBottomBorder Then
        If True{(FPenWidth = 1)} Then Begin
          MoveTo (rRight, rBottom);
          LineTo (rLeft,  rBottom);
        End { If }
        Else
          {Rectangle (0, (Height - FPenWidth), Width, Height);}
          FillRect(Rect(0, (Height - FPenWidth), Width, Height));

      If FLeftBorder Then
        If True{((FPenWidth = 1)} Then Begin
          MoveTo (rLeft, rBottom);
          LineTo (rLeft, rTop);
        End { If }
        Else
          FillRect(Rect(0, 0, FPenWidth, Height));
    End { If }
    Else Begin
      Pen.Width := FPenWidth;
      Pen.Color := FPenColor;
      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;

      Brush.Color := FPenColor;
      Brush.Style := bsSolid;

      {Rectangle (0, 0, Width, Height);}
      FillRect(Rect(rLeft, rTop, rRight, rBottom));
    End; { Else }
  End; { With }
end;

Function TSBSDragBox.GetName : ShortString;
Var
  ColorStr : ShortString;
begin
  Result := 'Box (';

  If GetColorName (FPenColor, ColorStr) Then Begin
    Result := Result + ColorStr + ', ';
  End; { If }

  If FFill Then
    Result := Result + 'Filled'
  Else Begin
    Result := Result + 'Line(';
    If FLeftBorder Then Result := Result + 'L';
    If FRightBorder Then Result := Result + 'R';
    If FTopBorder Then Result := Result + 'T';
    If FBottomBorder Then Result := Result + 'B';
    Result := Result + '), ';
    Result := Result + IntToStr (FPenWidth);
  End; { Else }
  Result := Result + ')';
end;

Function TSBSDragBox.GetFieldInfo : ShortString;
Var
  ColorStr : ShortString;
begin
  Result := '';

  If FFill Then
    Result := Result + 'Filled ';

  If GetColorName (FPenColor, ColorStr) Then Begin
    Result := Result + ColorStr;
  End; { If }

  If Not FFill Then
    Result := Result + ' Lines';
end;

Function TSBSDragBox.GetIdPrefix : String10;
begin
  Result := 'Box';
end;

procedure TSBSDragBox.SetLeftBorder (value : Boolean);
begin
  If (FLeftBorder <> Value) Then Begin
    FLeftBorder := Value;
    Invalidate;
  End; { If }
end;

procedure TSBSDragBox.SetTopBorder (value : Boolean);
begin
  If (FTopBorder <> Value) Then Begin
    FTopBorder := Value;
    Invalidate;
  End; { If }
end;

procedure TSBSDragBox.SetRightBorder (value : Boolean);
begin
  If (FRightBorder <> Value) Then Begin
    FRightBorder := Value;
    Invalidate;
  End; { If }
end;

procedure TSBSDragBox.SetBottomBorder (value : Boolean);
begin
  If (FBottomBorder <> Value) Then Begin
    FBottomBorder := Value;
    Invalidate;
  End; { If }
end;

procedure TSBSDragBox.SetPenWidth (value : Word);
begin
  If (FPenWidth <> Value) Then Begin
    FPenWidth := Value;
    Invalidate;
  End; { If }
end;

procedure TSBSDragBox.SetColor (value : TColor);
begin
  If (FPenColor <> Value) Then Begin
    FPenColor := Value;
    Invalidate;
  End; { If }
end;

procedure TSBSDragBox.SetFill (value : Boolean);
begin
  If (FFill <> Value) Then Begin
    FFill := Value;
    Invalidate;
  End; { If }
end;

Function TSBSDragBox.GetDefRec : FormDefRecType;
begin
  FillChar (Result, SizeOf (Result), #0);
  With Result do Begin
    fdFieldClass := fdcBox;
    fdControlId := ControlId;

    With Box Do Begin
      fxXPos         := PixelsToMMH(Left);
      fxYPos         := PixelsToMMV(Top);
      fxWidth        := PixelsToMM(Width);
      fxHeight       := PixelsToMM(Height);
      fxPenWidth     := FPenWidth;
      fxPenColor     := FPenColor;
      fxLeftBorder   := FLeftBorder;
      fxTopBorder    := FTopBorder;
      fxRightBorder  := FRightBorder;
      fxBottomBorder := FBottomBorder;
      fxFill         := FFill;
      fxIf           := FPrintIf;
    End; { With }
  End; { With }
end;

Procedure TSBSDragBox.InitByDefRec (Const DefRec : FormDefRecType);
begin
  ControlId := DefRec.fdControlId;
  Left     := MMToPixelsH(DefRec.Box.fxXPos);
  Top      := MMToPixelsV(DefRec.Box.fxYPos);
  Width    := MMToPixels(DefRec.Box.fxWidth);
  Height   := MMToPixels(DefRec.Box.fxHeight);

  FPenWidth     := DefRec.Box.fxPenWidth;
  FPenColor     := DefRec.Box.fxPenColor;
  FLeftBorder   := DefRec.Box.fxLeftBorder;
  FTopBorder    := DefRec.Box.fxTopBorder;
  FRightBorder  := DefRec.Box.fxRightBorder;
  FBottomBorder := DefRec.Box.fxBottomBorder;
  FFill         := DefRec.Box.fxFill;

  FPrintIf      := DefRec.Box.fxIf;
end;


{******************************************************************}
{* TSBSDragLine: Line control for use on the page control.        *}
{******************************************************************}
constructor TSBSDragLine.Create(AOwner: TComponent);
begin
  Inherited Create (AOwner);

  FPenWidth := 1;
  FPenColor := clBlack;
  FLineType := lnHorizontal;
end;

destructor TSBSDragLine.Destroy;
begin
  Inherited Destroy;
end;

procedure TSBSDragLine.PaintControl;
Var
  PenOffs : Byte;
begin
  With Canvas do Begin
    PenOffs := 2 * DefaultPixPerMM;
    Pen.Width := FPenWidth;
    Pen.Color := FPenColor;
    Pen.Mode  := pmCopy;
    Pen.Style := psSolid;

    Case FLineType Of
      lnVertical   : Begin
                       MoveTo (PenOffs, PenOffs);
                       LineTo (PenOffs, (Height - PenOffs));
                       LineTo (PenOffs, PenOffs);
                     End;
      lnHorizontal : Begin
                       MoveTo (PenOffs, PenOffs);
                       LineTo ((Width - PenOffs), PenOffs);
                       LineTo (PenOffs, PenOffs);
                     End;
      lnTLToBR     : Begin
                       MoveTo (PenOffs,  PenOffs);
                       LineTo ((Width - PenOffs), (Height - PenOffs));
                       LineTo (PenOffs,  PenOffs);
                     End;
      lnBLToTR     : Begin
                       MoveTo ((Width - PenOffs),  PenOffs);
                       LineTo (PenOffs, (Height - PenOffs));
                       LineTo ((Width - PenOffs),  PenOffs);
                     End;
    End; { Case }
  End; { With }
end;

Function TSBSDragLine.GetName : ShortString;
Var
  ColorStr : ShortString;
begin
  Result := 'Line (';

  If GetColorName (FPenColor, ColorStr) Then Begin
    Result := Result + ColorStr + ', ';
  End; { If }

  If (FLineType = lnHorizontal) Then Result := Result + 'Horizontal, ';
  If (FLineType = lnVertical) Then Result := Result + 'Vertical, ';
  If (FLineType = lnTLToBR) Then Result := Result + 'TL to BR, ';
  If (FLineType = lnBLToTR) Then Result := Result + 'BL To TR, ';

  Result := Result + IntToStr (FPenWidth) + ')';
end;

Function TSBSDragLine.GetFieldInfo : ShortString;
Var
  ColorStr : ShortString;
begin
  Result := '';

  If GetColorName (FPenColor, ColorStr) Then
    Result := Result + ColorStr + ' Lines ';
end;

Function TSBSDragLine.GetIdPrefix : String10;
begin
  Result := 'Line';
end;

procedure TSBSDragLine.SetPenWidth (value : Word);
begin
  If (FPenWidth <> Value) Then Begin
    FPenWidth := Value;
    Invalidate;
  End; { If }
end;

procedure TSBSDragLine.SetColor (value : TColor);
begin
  If (FPenColor <> Value) Then Begin
    FPenColor := Value;
    Invalidate;
  End; { If }
end;

procedure TSBSDragLine.SetLineType (Value : TSBSDragLineType);
begin
  If (FLineType <> Value) Then Begin
    FLineType := Value;
    ReDraw;
  End; { If }
end;

Function TSBSDragLine.GetDefRec : FormDefRecType;
Var
  TmpRec : FormDefRecType;
begin
  FillChar (Result, SizeOf (Result), #0);

  With TmpRec do Begin
    fdFieldClass := fdcLine;
    fdControlId := ControlId;

    With Line Do Begin
      flXPos1     := PixelsToMMH(Left);
      flYPos1     := PixelsToMMV(Top);
      flXPos2     := flXPos1 + PixelsToMM(Width);
      flYPos2     := flYPos1 + PixelsToMM(Height);
      flPenWidth  := FPenWidth;
      flColor     := FPenColor;
      flType      := FLineType;
      flIf        := FPrintIf;
    End; { With }
  End; { With }

  Result := TmpRec;
end;

Procedure TSBSDragLine.InitByDefRec (Const DefRec : FormDefRecType);
begin
  ControlId := DefRec.fdControlId;
  Left      := MMToPixelsH(DefRec.Line.flXPos1);
  Top       := MMToPixelsV(DefRec.Line.flYPos1);
  Width     := MMToPixels(DefRec.Line.flXPos2 - DefRec.Line.flXPos1);
  Height    := MMToPixels(DefRec.Line.flYPos2 - DefRec.Line.flYPos1);
  FPenWidth := DefRec.Line.flPenWidth;
  FPenColor := DefRec.Line.flColor;
  FLineType := DefRec.Line.flType;

  FPrintIf  := DefRec.Line.flIf;
end;


{**************************************************************}
{* TSBSDragPage: Text control for use on the page control.    *}
{**************************************************************}
constructor TSBSDragPage.Create(AOwner: TComponent);
begin
  Inherited Create (AOwner);

  FLeadingText := 'Page: ';
  FTrailingText := '';
  FFont := TFont.Create;
end;

destructor TSBSDragPage.Destroy;
begin
  FFont.Free;

  Inherited Destroy;
end;

procedure TSBSDragPage.PaintControl;
Var
  PaintRect  : TRect;
  PaintFlags : Word;
  PaintText  : ANSIString;
begin
  With Canvas do Begin
    Pen.Color := clBlack;
    Brush.Style := bsClear;
    Case FAlign Of
      taLeftJustify  : PaintFlags := DT_LEFT;
      taCenter       : PaintFlags := DT_CENTER;
      taRightJustify : PaintFlags := DT_RIGHT;
    Else
      PaintFlags := DT_LEFT;
    End; { Case }
    PaintFlags := PaintFlags Or DT_VCENTER Or DT_EXPANDTABS Or DT_WORDBREAK Or DT_NOPREFIX;
    PaintRect := ClientRect;
    PaintText := LeadingText + ' %P ' + TrailingText;
    FontToVisFont(FFont, Canvas.Font);
    CanvasDrawText (Canvas, PaintText, PaintRect, PaintFlags);
  End; { With }
end;

procedure TSBSDragPage.SetLeadingText (Value : ShortString);
begin
  If (Value <> FLeadingText) Then Begin
    FLeadingText := Value;
    Invalidate;
  End;
end;

procedure TSBSDragPage.SetTrailingText (Value : ShortString);
begin
  If (Value <> FTrailingText) Then Begin
    FTrailingText := Value;
    Invalidate;
  End;
end;

procedure TSBSDragPage.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  Invalidate;
end;

Function TSBSDragPage.GetName : ShortString;
begin
  Result := LeadingText + ' %P ' + TrailingText;
end;

Function TSBSDragPage.GetIdPrefix : String10;
begin
  Result := 'PageNo';
end;

Function TSBSDragPage.GetDefRec : FormDefRecType;
begin
  FillChar (Result, SizeOf (Result), #0);

  With Result do Begin
    fdFieldClass := fdcPage;
    fdControlId := ControlId;

    With PageNo Do Begin
      fpXPos     := PixelsToMMH(Left);
      fpYPos     := PixelsToMMV(Top);
      fpWidth    := PixelsToMM(Width);
      fpHeight   := PixelsToMM(Height);
      fpLeading  := LeadingText;
      fpTrailing := TrailingText;
      fpIf       := FPrintIf;
      fpJustify  := FAlign;

      FontToRec (Font, fpFont);
    End; { With }
  End; { With }
end;


Procedure TSBSDragPage.InitByDefRec (Const DefRec : FormDefRecType);
begin
  ControlId := DefRec.fdControlId;
  Left   := MMToPixelsH(DefRec.PageNo.fpXPos);
  Top    := MMToPixelsV(DefRec.PageNo.fpYPos);
  Width  := MMToPixels(DefRec.PageNo.fpWidth);
  Height := MMToPixels(DefRec.PageNo.fpHeight);
  LeadingText  := DefRec.PageNo.fpLeading;
  TrailingText := DefRec.PageNo.fpTrailing;
  FPrintIf     := DefRec.PageNo.fpIf;
  Alignment    := DefRec.PageNo.fpJustify;

  FontRecToFont (Font, DefRec.PageNo.fpFont);
end;

Procedure TSBSDragPage.SetInitialSize;
var
  TheRect : TRect;
  TmpFont : fdFontDefType;
  TmpStr  : ANSIString;
begin
  { Take temporary copy of previous font }
  FontToRec (Canvas.Font, TmpFont);

  { Copy in specified font }
  Canvas.Font.Assign (FFont);
  SetVisFontHeight (Canvas.Font, FFont.Size);

  { Get size of font }
  TheRect := Rect (1, 1, 2, 2);
  TmpStr := LeadingText + ' %P99 ' + TrailingText;
  CanvasDrawText (Canvas, TmpStr, TheRect, (DT_CALCRECT Or DT_SINGLELINE));

  { restore temporary copy of previous font }
  FontRecToFont (Canvas.Font, TmpFont);

  { Set control size }
  Width := (TheRect.Right - TheRect.Left);
  Height := (TheRect.Bottom - TheRect.Top);
End;

Function TSBSDragPage.GetFieldInfo : ShortString;
Begin
  Result := '''' + LeadingText + ' ## ' + TrailingText + '''';
End;

Procedure TSBSDragPage.FontDialog;
Var
  FontDialog : TFontDialog;
begin
  FontDialog := TFontDialog.Create(Self);
  Try
    FontDialog.Font.Assign(FFont);

    If FontDialog.Execute Then
      FFont.Assign(FontDialog.Font);
  Finally
    FontDialog.Free;
  End;
End;

procedure TSBSDragPage.SetAlignment (Value : TAlignment);
begin
  If (Value <> FAlign) Then Begin
    FAlign := Value;
    Invalidate;
  End;
end;

{************************************************************************}
{* TSBSDragDbField: Database Field control for use on the page control. *}
{************************************************************************}
constructor TSBSDragDbField.Create(AOwner: TComponent);
begin
  Inherited Create (AOwner);

  FFont := TFont.Create;
  FillChar (FShortCode, SizeOf (FShortCode), #0);
end;

destructor TSBSDragDbField.Destroy;
begin
  FFont.Free;

  Inherited Destroy;
end;

procedure TSBSDragDbField.PaintControl;
Var
  PaintRect  : TRect;
  PaintFlags : Word;
begin
  With Canvas do Begin
    Pen.Color := clBlack;
    Brush.Style := bsClear;
    Case FTextAlign Of
      taLeftJustify  : PaintFlags := DT_LEFT;
      taRightJustify : PaintFlags := DT_RIGHT;
      taCenter       : PaintFlags := DT_CENTER;
    Else
      PaintFlags := DT_LEFT;
    End; { Case }
    PaintFlags := PaintFlags Or DT_VCENTER Or DT_EXPANDTABS Or DT_WORDBREAK Or DT_NOPREFIX;
    PaintRect := ClientRect;
    FontToVisFont(FFont, Canvas.Font);
    CanvasDrawText (Canvas, FShortCode, PaintRect, PaintFlags);
  End; { With }
end;

procedure TSBSDragDbField.SetShortCode(Value : String10);
begin
  If (Value <> FShortCode) Then Begin
    FShortCode := Value;
    Invalidate;
  End;
end;

procedure TSBSDragDbField.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  Invalidate;
end;

procedure TSBSDragDbField.SetCharLength(Value: Byte);
begin
  FCharLength := Value;
  Invalidate;
end;

procedure TSBSDragDbField.SetTextAlign(Value: TAlignment);
begin
  FTextAlign := Value;
  Invalidate;
end;

procedure TSBSDragDbField.SetDecimals(Value: Byte);
begin
  FDecimals := Value;
  Invalidate;
end;

procedure TSBSDragDbField.SetBlank(Value: Boolean);
begin
  FBlank := Value;
  Invalidate;
end;

Function TSBSDragDbField.GetName : ShortString;
begin
  Result := FShortCode;
end;

Function TSBSDragDbField.GetFieldInfo : ShortString;
begin
  Result := FShortCode;
end;

Function TSBSDragDbField.GetIdPrefix : String10;
begin
  Result := 'Field';
end;

Function TSBSDragDbField.GetDefRec : FormDefRecType;
Var
  DefRec : FormDefRecType;
begin
  FillChar (DefRec, SizeOf (DefRec), #0);

  With DefRec do Begin
    fdFieldClass := fdcDbField;
    fdControlId  := ControlId;

    With DbField Do Begin
      fdXPos      := PixelsToMMH(Left);
      fdYPos      := PixelsToMMV(Top);
      fdWidth     := PixelsToMM(Width);
      fdHeight    := PixelsToMM(Height);
      fdShortCode := ShortCode;
      fdFieldLen  := CharLength;

      FontToRec (FFont, DefRec.DbField.fdFont);

      fdAlign       := TextAlign;
      fdDecs        := Decimals;
      fdBlankIfZero := FBlank;
      fdIf          := FPrintIf;
    End; { With }
  End; { With }

  Result := DefRec;
end;


Procedure TSBSDragDbField.InitByDefRec (Const DefRec : FormDefRecType);
begin
  ControlId := DefRec.fdControlId;
  Left   := MMToPixelsH(DefRec.DbField.fdXPos);
  Top    := MMToPixelsV(DefRec.DbField.fdYPos);
  Width  := MMToPixels(DefRec.DbField.fdWidth);
  Height := MMToPixels(DefRec.DbField.fdHeight);
  ShortCode := DefRec.DbField.fdShortCode;
  CharLength := DefRec.DbField.fdFieldLen;

  FontRecToFont (FFont, DefRec.DbField.fdFont);

  TextAlign := DefRec.DbField.fdAlign;
  Decimals := DefRec.DbField.fdDecs;

  BlankZero := DefRec.DbField.fdBlankIfZero;
  FPrintIf := DefRec.DbField.fdIf;

  Invalidate;
end;

Procedure TSBSDragDbField.SetInitialSize;
var
  TheRect : TRect;
  TmpFont : fdFontDefType;
  TmpStr  : String;

  Function GetStr : ANSIString;
  Var
    I : Integer;
  begin
    Result := '';

    If (FCharLength > 0) Then
      For I := 1 To FCharLength Do
        Result := Result + 'S';
  end;

begin
  { Take temporary copy of previous font }
  FontToRec (Canvas.Font, TmpFont);

  { Copy in specified font }
  Canvas.Font.Assign (FFont);
  SetVisFontHeight (Canvas.Font, FFont.Size);

  { Get size of font }
  TheRect := Rect (1, 1, 2, 2);
  TmpStr := GetStr;
  CanvasDrawText (Canvas, TmpStr, TheRect, (DT_CALCRECT Or DT_SINGLELINE));

  { restore temporary copy of previous font }
  FontRecToFont (Canvas.Font, TmpFont);

  { Set control size }
  Width := (TheRect.Right - TheRect.Left);
  Height := (TheRect.Bottom - TheRect.Top);
End;

Procedure TSBSDragDbField.FontDialog;
Var
  FontDialog : TFontDialog;
begin
  FontDialog := TFontDialog.Create(Self);
  Try
    FontDialog.Font.Assign(FFont);

    If FontDialog.Execute Then
      FFont.Assign(FontDialog.Font);
  Finally
    FontDialog.Free;
  End;
End;

{************************************************************************}
{* TSBSDragDbTable: Database Table control for use on the page control. *}
{************************************************************************}
constructor TSBSDragDbTable.Create(AOwner: TComponent);
begin
  Inherited Create (AOwner);

  Columns := TSBSList.CreateList ('DbTable');

  FTable := TableObject.Create;
  FTable.InitTable;
end;

destructor TSBSDragDbTable.Destroy;
begin
  FTable.Free;

  ClearColumns;
  Columns.Free;

  Inherited Destroy;
end;

{ returns the right hand border of the table }
Function TSBSDragDbTable.CalcColWidths : LongInt;
Var
  I, DefWidth, TotWidth : Integer;
begin
  TotWidth := Width - 2;

  If (Columns.Count > 0) Then Begin
    {TotWidth := 2; { one pixel at either side }
    TotWidth := FController.Paper.InPixels(2); { one mm at either side }

    { Calculate width of columns }
    For I := 0 To (Columns.Count - 1) Do
      With TFormDefListObjType(Columns.Items[I]).FormDef Do Begin
        Case fdFieldClass Of
          fdcFieldCol   : If (Not FieldCol.fdHidden) Then Begin
                            TotWidth := TotWidth + FController.Paper.InPixels(FieldCol.fdWidth);
                          End;
          fdcFormulaCol : If (Not FormulaCol.ffHidden) Then Begin
                            TotWidth := TotWidth + FController.Paper.InPixels(FormulaCol.ffWidth);
                          End;
        End; { Case }
      End; { With }
  End; { If }

  { Check is greater than minimum }
  If (TotWidth < 8) Then TotWidth := 8;

  Result := TotWidth - 1;
end;


Function TSBSDragDbTable.FontHeight (Const TheFont : fdFontDefType) : Integer;
var
  TheRect   : TRect;
  TmpFont   : fdFontDefType;
  TmpPtSize : Integer;
begin { TSBSDragDbTable.FontHeight }
  { Take temporary copy of previous font }
  FontToRec (Canvas.Font, TmpFont);

  { Copy in specified font }
  FontRecToFont (Canvas.Font, TheFont);
  SetVisFontHeight (Canvas.Font, TheFont.ffSize);

  { Get size of font }
  TheRect := Rect (1, 1, 2, 2);
  DrawText (Canvas.Handle, 'M', 1, TheRect, (DT_CALCRECT Or DT_SINGLELINE));

  { restore temporary copy of previous font }
  FontRecToFont (Canvas.Font, TmpFont);

  Result := (TheRect.Bottom - TheRect.Top);
End; { TSBSDragDbTable.FontHeight }

{ returns height of heighest row }
Function TSBSDragDbTable.GetRowHeight : Integer;
Var
  I, RowHeight, fHeight : Integer;
begin
  RowHeight := 0;

  If (Columns.Count > 0) Then
    For I := 0 To (Columns.Count - 1) Do
      With TFormDefListObjType(Columns.Items[I]).FormDef Do Begin
        { Get height for columns font }
        Case fdFieldClass Of
          fdcFieldCol   : fHeight := FontHeight (FieldCol.fdColFont);
          fdcFormulaCol : fHeight := FontHeight (FormulaCol.ffColFont);
        End; { Case }

        { Keep highest font }
        If (fHeight > RowHeight) Then RowHeight := fHeight;
      End; { With }

  {RowHeight := RowHeight + 5;}

  While (RowHeight < 1) Or ((RowHeight Mod Round(FController.Paper.psScaling)) <> 0) Do
    Inc (RowHeight);

  Result := RowHeight;
end;

procedure TSBSDragDbTable.PaintControl;
Var
  tLeft, tRight, tTop, tBottom, tRowTop,
  HdrFontHeight,
  ColLeft, HdrHeight, I  : Integer;

  { returns the right hand border of the table }
  Function CalcRight : LongInt;
  Var
    I, DefWidth, TotWidth : Integer;
  begin
    TotWidth := CalcColWidths;

    { Check it fits withing the control }
    If (TotWidth > Width) Then
      TotWidth := Width - (2 * DefaultPixPerMM);

    { Check is greater than minimum drawable width }
    If (TotWidth < (10 * DefaultPixPerMM)) Then
      TotWidth := (10 * DefaultPixPerMM);

    Result := TotWidth;
  end;

  Procedure PaintColHeaders;
  Var
    I, ColLeft, ColRight, cWidth    : Integer;
    TextRect                        : TRect;
    LastCol                         : Boolean;
    Flags                           : Word;
    TmpStr                          : ANSIString;
    TmpAlign                        : TAlignment;
    TmpSep, ColHidden               : Boolean;
  begin
    If (Columns.Count > 0) Then Begin
      ColLeft := tLeft;

      For I := 0 To (Columns.Count - 1) Do
        With TFormDefListObjType(Columns.Items[I]).FormDef Do Begin
          Case fdFieldClass Of
            fdcFieldCol   : With FieldCol Do Begin
                              TmpStr := fdTitle;
                              Flags := AlignToFlag (fdAlign) Or DT_VCenter;
                              TmpSep := fdWantSep;
                              cWidth := fdWidth;
                              ColHidden := fdHidden;
                            End;
            fdcFormulaCol : With FormulaCol Do Begin
                              TmpStr := ffTitle;
                              Flags := AlignToFlag (ffAlign) Or DT_VCenter;
                              TmpSep := ffWantSep;
                              cWidth := ffWidth;
                              ColHidden := ffHidden;
                            End;
          End; { Case }

          If (Not ColHidden) Then Begin
            ColRight := ColLeft + FController.Paper.InPixels(cWidth);
            If (ColRight > TRight) Then
              ColRight := TRight;
            LastCol := (I = (Columns.Count - 1));

            FontRecToFont (Canvas.Font, FTable.Font(Hdr));
            SetVisFontHeight (Canvas.Font, FTable.Font(Hdr).ffSize);

            With TextRect Do Begin
              Left   := ColLeft + 3;
              Right  := ColRight - 3;
              Top    := tTop + 3;
              Bottom := tRowTop - 1;
            End; { With }

            { Calc Flags }
            Flags := Flags Or DT_VCENTER Or DT_EXPANDTABS Or DT_WORDBREAK Or DT_NOPREFIX;
            CanvasDrawText (Canvas, TmpStr, TextRect, Flags);

            If TmpSep And (Not LastCol) Then
              { Draw separating line at end of column }
              FTable.DrawLine (Canvas, Hdr_ColSepLine, ColRight, tTop, ColRight, tRowTop);

            ColLeft := ColRight;
            If (ColLeft > TRight) Then Break;
          End; { If }
        End; { With }
    End; { If }
  end;

  Procedure PaintColSeps;
  Var
    I, ColLeft, ColRight, cWidth : Integer;
    LastCol, TmpSep, ColHidden   : Boolean;
  begin
    If (Columns.Count > 0) Then Begin
      ColLeft := tLeft;

      For I := 0 To (Columns.Count - 1) Do
        With TFormDefListObjType(Columns.Items[I]).FormDef Do Begin
          Case fdFieldClass Of
            fdcFieldCol   : With FieldCol Do Begin
                              TmpSep := fdWantSep;
                              cWidth := fdWidth;
                              ColHidden := fdHidden;
                            End;
            fdcFormulaCol : With FormulaCol Do Begin
                              TmpSep := ffWantSep;
                              cWidth := ffWidth;
                              ColHidden := ffHidden;
                            End;
          End; { Case }

          If (Not ColHidden) Then Begin
            ColRight := ColLeft + FController.Paper.InPixels(cWidth);
            LastCol := (I = (Columns.Count - 1));

            If TmpSep And (Not LastCol) Then Begin
              { Draw separating line at end of column }
              FTable.DrawLine (Canvas, Tbl_ColSepLine, ColRight, tRowTop, ColRight, tBottom);
            End; { If }

            ColLeft := ColRight;
          End; { If }
        End; { With }
    End; { If }
  end;

  Procedure PaintRowSeps;
  Var
    RowHeight, RowTop, I : Integer;
  begin
    RowHeight := GetRowHeight;
    RowTop    := tRowTop + RowHeight;

    While ((RowTop + RowHeight) <= tBottom) do Begin
      { draw row sep line if got room for another row }
      FTable.DrawLine (Canvas, Tbl_RowSepLine, tLeft, RowTop, tRight, RowTop);

      RowTop := RowTop + RowHeight;
    End; { While }
  end;

  Procedure PaintRowData;
  Var
    RowCount, RowHeight, RowTop, cWidth, I, Col1 : Integer;
    TextRect                                     : TRect;
    RowCaption                                   : ANSIString;
    Flags                                        : Word;
    ColHidden                                    : Boolean;
  begin { PaintRowData }
    RowCount  := 1;
    RowHeight := GetRowHeight;
    RowTop    := tRowTop;

    { Find First Non Hidden Column }
    Col1 := -1;
    If (Columns.Count > 0) Then
      For I := 0 To (Columns.Count - 1) Do
        With TFormDefListObjType(Columns.Items[I]).FormDef Do Begin
          Case fdFieldClass Of
            fdcFieldCol   : If (Not FieldCol.fdHidden) Then Col1 := I;
            fdcFormulaCol : If (Not FormulaCol.ffHidden) Then Col1 := I;
          End; { Case }

          { Break out of loop if found first column }
          If (Col1 > -1) Then Break;
        End; { With }

    If (Columns.Count > 0) And (Col1 > -1) Then
      While (RowTop < tBottom) do Begin
        { draw row sep line if got room for another row }
        If ((RowTop + RowHeight) <= tBottom) Then Begin
          With TFormDefListObjType(Columns.Items[0]).FormDef Do Begin
            Case fdFieldClass Of
              fdcFieldCol   : With FieldCol Do Begin
                                Flags := AlignToFlag (fdAlign);
                                cWidth := fdWidth;
                                FontRecToFont (Canvas.Font, fdColFont);
                              End;
              fdcFormulaCol : With FormulaCol Do Begin
                                Flags := AlignToFlag (ffAlign);
                                cWidth := ffWidth;
                                FontRecToFont (Canvas.Font, ffColFont);
                              End;
            End; { Case }
            SetVisFontHeight (Canvas.Font, Canvas.Font.Size);

            With TextRect Do Begin
              Left   := tLeft + 3;
              Right  := tLeft + FController.Paper.InPixels(cWidth) - 3;
              Top    := RowTop{ + 3};
              Bottom := RowTop + RowHeight{ - 3};
            End; { With }

            { Calc Flags }
(*If (RowCount In [1..3]) Then Begin
  Case RowCount Of
    1 : Canvas.Brush.Color := clBlue;
    2 : Canvas.Brush.Color := clGray;
    3 : Canvas.Brush.Color := clOlive;
  End; { Case }
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(Rect (TextRect.Left + (3 * (RowCount - 1)), TextRect.Top, TextRect.Right, TextRect.Bottom));
  Canvas.Brush.Style := bsClear;
End; { If }*)
            Flags := Flags Or DT_VCENTER Or DT_EXPANDTABS Or DT_WORDBREAK Or DT_NOPREFIX;
            RowCaption := 'Row: ' + IntToStr(RowCount);
            CanvasDrawText (Canvas, RowCaption, TextRect, Flags);
          End; { With }
        End; { If }

        RowTop := RowTop + RowHeight;
        Inc(RowCount);
      End; { While }
  end;  { PaintRowData }

begin
  With FTable, Canvas do Begin
    tLeft         := DefaultPixPerMM - 1; { Canvas starts at 0, not 1 }
    tRight        := CalcRight;
    tTop          := DefaultPixPerMM - 1; { Canvas starts at 0, not 1 }
    tBottom       := Height - DefaultPixPerMM;
    HdrFontHeight := FontHeight(Canvas, Hdr, True);
    If Enabled[Hdr] Then
      tRowTop := tTop + HdrFontHeight + 3  { start rows after header }
    Else
      tRowTop := tTop;                     { start rows at top }

    { Paint column Separators }
    PaintColSeps;

    { Paint row separators }
    PaintRowSeps;

    { Paint Table borders }
    DrawLine (Canvas, Tbl_LeftLine,   tLeft,  tRowTop, tLeft,  tBottom);
    DrawLine (Canvas, Tbl_RightLine,  tRight, tRowTop, tRight, tBottom);
    DrawLine (Canvas, Tbl_BottomLine, tLeft,  tBottom, tRight, tBottom);

    { Paint header }
    If Enabled[Hdr] Then Begin
      { Paint column headers }
      PaintColHeaders;

      { Paint table header borders }
      DrawLine (Canvas, Hdr_LeftLine,  tLeft,  tTop, tLeft,  tRowTop);
      DrawLine (Canvas, Hdr_RightLine, tRight, tTop, tRight, tRowTop);
      DrawLine (Canvas, Hdr_TopLine,   tLeft,  tTop, tRight, tTop);
    End; { If }

    { Paint table top line - this must overwrite the column headers if nec. }
    DrawLine (Canvas, Tbl_TopLine,    tLeft,  tRowTop, tRight, tRowTop);

    { Paint Row data }
    PaintRowData;
  End; { With }
end;

Function TSBSDragDbTable.GetName : ShortString;
begin
  Result := 'Table';
end;

Function TSBSDragDbTable.GetIdPrefix : String10;
begin
  Result := 'Table';
end;

Function TSBSDragDbTable.GetDefRec : FormDefRecType;
begin
  FillChar (Result, SizeOf (Result), #0);

  With Result do Begin
    fdFieldClass := fdcTable;
    fdControlId := ControlId;
    Table := FTable.GetTableRec;

    With Table Do Begin
      frXPos    := PixelsToMMH(Left);
      frYPos    := PixelsToMMV(Top);
      frWidth   := PixelsToMM(Width);
      frHeight  := PixelsToMM(Height);
      frIf      := FPrintIf;
    End; { With }
  End; { With }
end;


Procedure TSBSDragDbTable.InitByDefRec (Const DefRec : FormDefRecType);
begin
  FTable.SetTableRec (DefRec.Table);

  ControlId := DefRec.fdControlId;
  Left   := MMToPixelsH(DefRec.Table.frXPos);
  Top    := MMToPixelsV(DefRec.Table.frYPos);
  Width  := MMToPixels(DefRec.Table.frWidth);
  Height := MMToPixels(DefRec.Table.frHeight);

  FPrintIf := DefRec.Table.frIf;
end;

Function TSBSDragDbTable.GetColumnDefRec (Const ColIndex : Integer) : TFormDefListObjType;
Var
  ColObj : TFormDefListObjType;
begin
  { Create local copy of the object }
  ColObj := TFormDefListObjType.Create;
  ColObj.FormDef := TFormDefListObjType(Columns.Items[ColIndex]).FormDef;

  { return copy }
  Result := ColObj;
end;

Procedure TSBSDragDbTable.InitColumnByDefRec (Const ColDef : FormDefRecType);
Var
  ColObj : TFormDefListObjType;
begin
  { Create local copy of the object }
  ColObj := TFormDefListObjType.Create;
  ColObj.FormDef := ColDef;
  Columns.Add (ColObj);
end;

Procedure TSBSDragDbTable.ClearColumns;
Var
  ListObj : TFormDefListObjType;
begin
  While (Columns.Count > 0) Do Begin
    { Take copy of object, remove from list, and deallocate }
    ListObj := TFormDefListObjType(Columns.Items[0]);
    Columns.Delete (0);
    ListObj.Free;
  End; { While }
end;

Procedure TSBSDragDbTable.SetDefaultFont (DefFont : TFont);
Var
  TheFont : fdFontDefType;
begin
  FontToRec(DefFont, TheFont);
  FTable.SetFont (Hdr, Thefont);
end;

Procedure TSBSDragDbTable.SetInitialSize;
begin
  { Set size based on columns added and four rows }
  Width := CalcColWidths;
  Height := FTable.FontHeight(Canvas, Hdr, True) + 7 + (4 * GetRowHeight);
end;



{*****************************************************************}
{* TSBSDragFormula: Formula control for use on the page control. *}
{*****************************************************************}
constructor TSBSDragFormula.Create(AOwner: TComponent);
begin
  Inherited Create (AOwner);

  FFont := TFont.Create;
  FFormula := '';
  FDecimals  := 2;
  FTextAlign := taLeftJustify;
  FBlank := False;
end;

destructor TSBSDragFormula.Destroy;
begin
  FFont.Free;

  Inherited Destroy;
end;

procedure TSBSDragFormula.PaintControl;
Var
  PaintRect  : TRect;
  PaintFlags : Word;
begin
  With Canvas do Begin
    If FHidden Then
      Pen.Color := clGray
    Else
      Pen.Color := FFont.Color;

    Brush.Style := bsClear;
    Case FTextAlign Of
      taLeftJustify  : PaintFlags := DT_LEFT;
      taRightJustify : PaintFlags := DT_RIGHT;
      taCenter       : PaintFlags := DT_CENTER;
    Else
      PaintFlags := DT_LEFT;
    End; { Case }
    PaintFlags := PaintFlags Or DT_VCENTER Or DT_EXPANDTABS Or DT_WORDBREAK Or DT_NOPREFIX;
    PaintRect := ClientRect;
    FontToVisFont(FFont, Canvas.Font);
    Font.Color := Pen.Color;
    CanvasDrawText (Canvas, FFormula, PaintRect, PaintFlags);
  End; { With }
end;

procedure TSBSDragFormula.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  Invalidate;
end;

procedure TSBSDragFormula.SetTextAlign(Value: TAlignment);
begin
  FTextAlign := Value;
  Invalidate;
end;

procedure TSBSDragFormula.SetBlank(Value: Boolean);
begin
  FBlank := Value;
  Invalidate;
end;

Function TSBSDragFormula.GetName : ShortString;
begin
  Result := Copy (FFormula, 1, 20);
end;

Function TSBSDragFormula.GetIdPrefix : String10;
begin
  Result := 'Formula';
end;

Function TSBSDragFormula.GetDefRec : FormDefRecType;
begin
  FillChar (Result, SizeOf (Result), #0);

  With Result do Begin
    fdFieldClass := fdcFormula;
    fdControlId := ControlId;

    With Formula Do Begin
      ffXPos    := PixelsToMMH(Left);
      ffYPos    := PixelsToMMV(Top);
      ffWidth   := PixelsToMM(Width);
      ffHeight  := PixelsToMM(Height);

      FontToRec (FFont, ffFont);
      ffFormula := FFormula;

      ffAlign       := TextAlign;
      ffDecs        := Decimals;
      ffBlankIfZero := FBlank;
      ffIf          := FPrintIf;
      ffHidden      := FHidden;

      ffBarCode := FBarCode;
      ffBCFlag1 := FBCFlag1;
      ffBCFlag2 := FBCFlag2;
      ffBCFlag3 := FBCFlag3;
    End; { With }
  End; { With }
end;


Procedure TSBSDragFormula.InitByDefRec (Const DefRec : FormDefRecType);
begin
  ControlId := DefRec.fdControlId;
  Left   := MMToPixelsH(DefRec.Formula.ffXPos);
  Top    := MMToPixelsV(DefRec.Formula.ffYPos);

  Width  := MMToPixels(DefRec.Formula.ffWidth);
  Height := MMToPixels(DefRec.Formula.ffHeight);

  FontRecToFont (FFont, DefRec.Formula.ffFont);
  FFormula := DefRec.Formula.ffFormula;

  TextAlign := DefRec.Formula.ffAlign;
  Decimals := DefRec.Formula.ffDecs;
  BlankZero := DefRec.Formula.ffBlankIfZero;

  FPrintIf := DefRec.Formula.ffIf;
  FHidden  := DefRec.Formula.ffHidden;

  { MH 20/08/97: Added for Barcode support }
  FBarCode := DefRec.Formula.ffBarCode;
  FBCFlag1 := DefRec.Formula.ffBCFlag1;
  FBCFlag2 := DefRec.Formula.ffBCFlag2;
  FBCFlag3 := DefRec.Formula.ffBCFlag3;
end;


Procedure TSBSDragFormula.SetInitialSize;
var
  TheRect : TRect;
  TmpFont : fdFontDefType;
  TheText : ANSIString;
begin
  { Take temporary copy of previous font }
  FontToRec (Canvas.Font, TmpFont);

  { Copy in specified font }
  Canvas.Font.Assign (FFont);
  SetVisFontHeight (Canvas.Font, FFont.Size);

  { Get size of font }
  TheRect := Rect (1, 1, 2, 2);
  TheText := 'MYMYyypp';
  CanvasDrawText (Canvas, TheText, TheRect, (DT_CALCRECT Or DT_SINGLELINE));

  { restore temporary copy of previous font }
  FontRecToFont (Canvas.Font, TmpFont);

  { Set control size }
  {Width := (TheRect.Right - TheRect.Left);} { Don't know how wide it will be }
  Height := (TheRect.Bottom - TheRect.Top);
End;

Function TSBSDragFormula.GetFieldInfo : ShortString;
begin
  Result := '''' + FFormula + '''';
end;


Procedure TSBSDragFormula.FontDialog;
Var
  FontDialog : TFontDialog;
begin
  FontDialog := TFontDialog.Create(Self);
  Try
    FontDialog.Font.Assign(FFont);

    If FontDialog.Execute Then
      FFont.Assign(FontDialog.Font);
  Finally
    FontDialog.Free;
  End;
End;


{********************************************************************}
{* TSBSDragGroup: Row Grouping control for use on the page control. *}
{********************************************************************}
constructor TSBSDragGroup.Create(AOwner: TComponent);
Var
  I : Integer;
begin
  Inherited Create (AOwner);

  FillChar (FRows, SizeOf (FRows), #0);
end;

procedure TSBSDragGroup.WMSetCursor(var Msg: TWMSetCursor);
var
  Cur : HCURSOR;
  I   : THandles;
  J   : SmallInt;
begin
  If FAllowSizing Then Begin
    Cur := 0;

    FState := dsNone;
    FHitTest := ScreenToClient(FHitTest);

    For I := TopLeft To BottomRight Do
      If FHandles [I].Enabled And (Cur = 0) Then
        With FHandles [I] Do
          If ((FHitTest.X >= Rect.Left) And (FHitTest.X <= Rect.Right)) And
             ((FHitTest.Y >= Rect.Top) And (FHitTest.Y <= Rect.Bottom)) Then Begin
            Case I Of
              TopLeft      : Cur := LoadCursor(0, IDC_SIZENWSE);
              TopCentre    : Cur := LoadCursor(0, IDC_SIZENS);
              TopRight     : Cur := LoadCursor(0, IDC_SIZENESW);
              CentreLeft   : Cur := LoadCursor(0, IDC_SIZEWE);
              CentreRight  : Cur := LoadCursor(0, IDC_SIZEWE);
              BottomLeft   : Cur := LoadCursor(0, IDC_SIZENESW);
              BottomCentre : Cur := LoadCursor(0, IDC_SIZENS);
              BottomRight  : Cur := LoadCursor(0, IDC_SIZENWSE);
            End; { Case }

            If (Cur <> 0) Then
              FSizeType := I;
          End; { If }

    If (Cur = 0) then begin
      { Check to see if positioned on a row }
      For J := Low (FRows) To High(FRows) Do
        If (FRows[J] > 0) And (FRows[J] < Height) And
           (FHitTest.Y >= (FRows[J] - 1)) And
           (FHitTest.Y <= (FRows[J] + 1)) Then Begin
          Cur := LoadCursor(0, IDC_SIZENS);
          FSizeType := GroupRow;
          FState := dsRowMove;
          FRowIdx := J;
          Break;
        End; { If }
    End; { If }

    If (Cur <> 0) then begin
      SetCursor(Cur);
      If (FState = dsNone) Then
        FState := dsSizing;
    End { If }
    Else Begin
      FState := dsNone;
      Inherited;
    End; { Else }
  End { If }
  Else
    Inherited;

  If Assigned (FController) Then
    If FController.PageHandleSet Then Begin

      FController.Page.DispMsg (msgidx_ControlInfo, GetStatusInfo);
    End; { If }
End;

procedure TSBSDragGroup.ControlMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ScreenDC : HDC;
  Coords   : TPoint;
begin
  If (FState = dsRowMove) Then Begin
    SetMouseCapture(Self);

    FXOffset  := X;
    FYOffset  := Y;

    { Get position & size in screen coords }
    Coords := Parent.ClientToScreen (BoundsRect.TopLeft);
    SizeRect.Top    := Coords.Y + FRows[FRowIdx] - 1;
    SizeRect.Bottom := Coords.Y + FRows[FRowIdx] + 1;
    SizeRect.Left   := Coords.X + 1;
    SizeRect.Right  := Coords.X + Width - 1;

    { Draw move/size box on the screen }
    BoxRect := SizeRect;
    DrawBox (EmptyRect, BoxRect);
  End;
end;


procedure TSBSDragGroup.ControlMouseMove(Shift: TShiftState; X, Y: Integer);
Var
  Coords, oCoords    : TPoint;
  GridRect, TempRect : TRect;
  GridX, GridY       : Integer;
Begin
  If (FState = dsRowMove) And Controller.PageHandleSet And Controller.GridHandleSet Then Begin
    TempRect := BoxRect;

    Controller.Grid.GetGridSizes (GridRect, GridX, GridY, False);
    GridRect.TopLeft := Parent.ScreenToClient(GridRect.TopLeft);
    GridRect.BottomRight := Parent.ScreenToClient(GridRect.BottomRight);

    { Check mouse is in a valid position }
    GetCursorPos (Coords);
    Coords := Parent.ScreenToClient(Coords);
    oCoords := Coords;

    If (Coords.X < (Left + 1)) Then Coords.X := Left + 1;
    If (Coords.X > (Left + Width - 2)) Then Coords.X := Left + Width - 2;
    If (Coords.Y < (Top + 1)) Then Coords.Y := Top + 1;
    If (Coords.Y > (Top + Height - 2)) Then Coords.Y := Top + Height - 2;
    If (Coords.X < 0) Then Coords.X := 0;
    If (Coords.X > Parent.ClientWidth) Then Coords.X := Parent.ClientWidth;
    If (Coords.Y < 0) Then Coords.Y := 0;
    If (Coords.Y > Parent.ClientHeight) Then Coords.Y := Parent.ClientHeight;

    If (Coords.X <> oCoords.X) Or (Coords.Y <> oCoords.Y) Then Begin
      Coords := Parent.ClientToScreen (Coords);
      SetCursorPos (Coords.X, Coords.Y);
    End; { If }

    { Calculate new line position }
    GetCursorPos (Coords);
    Coords := Parent.ScreenToClient(Coords);

    { make sure the sep bar is on a mm boundary }
    While ((Coords.Y Mod GridY) <> 0) Do
      Dec (Coords.Y);
    If (Coords.Y < (Top - 1)) Or (Coords.Y < 0) Then
      While ((Coords.Y Mod GridY) <> 0) Or (Coords.Y < (Top - 1)) Or (Coords.Y < 0) Do
        Inc (Coords.Y);

    Coords := Parent.ClientToScreen(Coords);

    oCoords := Parent.ClientToScreen (BoundsRect.TopLeft);
    SizeRect.Left := OCoords.X + 1;
    SizeRect.Top := Coords.Y - 2;
    SizeRect.Right := OCoords.X + Width - 1;
    SizeRect.Bottom := Coords.Y;

    { Position correctly on the grid }
    {Controller.Grid.ScreenSnapToGrid (SizeRect, 2);}

    { Draw the resize box }
    BoxRect := SizeRect;
    DrawBox (TempRect, BoxRect);
  End; { If }
End;


procedure TSBSDragGroup.ControlMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ScreenDC : HDC;
Begin
  If (FState = dsRowMove) Then Begin
    { Get screen handle and undraw the focus rectangle }
    ScreenDC:=GetDC(0);
    DrawFocusRect(ScreenDC,BoxRect);
    ReleaseDC(0,ScreenDC);

    { Check that the control has changed position or size }
    FRows[FRowIdx] := ScreenToClient(SizeRect.TopLeft).Y + 1;
    FController.PaintControlPage (Self.BoundsRect);
    ChangeMade;

    ReleaseMouseCapture(Self);
  End; { If }
End;

procedure TSBSDragGroup.PaintHandles;
begin
  CalcHandleRects;
end;

procedure TSBSDragGroup.PaintControl;
Var
  I : SmallInt;
begin
  If WantPaint Then Begin
    With Canvas do Begin
      { Draw dotted border }
      If Assigned (FController) And FController.IsSelected(Self) Then
        Pen.Color := clRed
      Else
        Pen.Color := clBlack;
      Pen.Style := psDot;
      Pen.Mode  := pmCopy;
      Brush.Color := clWhite;
      Brush.Style := bsClear;
      Rectangle (0, 0, Width{ - 1}, Height{ - 1});

      { draw rows }
      For I := Low (FRows) To High(FRows) Do
        If (FRows[I] > 0) And (FRows[I] < Height) Then Begin
          Pen.Color := clRed;
          Pen.Style := psDot;
          Pen.Mode  := pmCopy;
          MoveTo (1, FRows[I]);
          LineTo (Width - 2, FRows[I]);
        End; { For }
    End; { With }
  End; { If }
end;

Function TSBSDragGroup.GetName : ShortString;
begin
  Result := Copy (FControlId, 1, 20);
end;

Function TSBSDragGroup.GetIdPrefix : String10;
begin
  Result := 'Group';
end;

Function TSBSDragGroup.GetDefRec : FormDefRecType;
Var
  I : SmallInt;
begin
  FillChar (Result, SizeOf (Result), #0);

  With Result do Begin
    fdFieldClass := fdcGroup;
    fdControlId := ControlId;

    With Group Do Begin
      fgXPos       := PixelsToMMH(Left);
      fgYPos       := PixelsToMMV(Top);
      fgWidth      := PixelsToMM(Width);
      fgHeight     := PixelsToMM(Height);
      fgIf         := FPrintIf;

      SortRows;
      If Assigned (FController) And FController.PaperHandleSet Then
        With FController.Paper Do
          For I := Low (FRows) To High (FRows) Do
            fgRows[I] := Round (FRows[I] / psScaling);
    End; { With }
  End; { With }
end;


Procedure TSBSDragGroup.InitByDefRec (Const DefRec : FormDefRecType);
Var
  I : SmallInt;
begin
  ControlId := DefRec.fdControlId;

  Left   := MMToPixelsH(DefRec.Group.fgXPos);
  Top    := MMToPixelsV(DefRec.Group.fgYPos);
  Width  := MMToPixels(DefRec.Group.fgWidth);
  Height := MMToPixels(DefRec.Group.fgHeight);

  If Assigned (FController) And FController.PaperHandleSet Then
    With FController.Paper Do
      For I := Low (FRows) To High (FRows) Do
        FRows[I] := Round(DefRec.Group.fgRows[I] * psScaling);

  SortRows;

  FPrintIf := DefRec.Group.fgIf;
end;

Procedure TSBSDragGroup.SetInitialSize;
Var
  Tmp : LongInt;
begin
  { set default size here }
  Tmp := Round(Parent.Parent.ClientWidth * 0.33);
  If (Tmp <= 0) Then Tmp := 30;
  Width := Tmp;

  Tmp := Round(Parent.Parent.ClientHeight * 0.33);
  If (Tmp <= 0) Then Tmp := 30;
  Height := Tmp;
End;

{ add new row at current FRButt position }
Procedure TSBSDragGroup.AddNewRow;
Var
  I, NIdx : SmallInt;
  Tmp     : LongInt;
begin
  SortRows;

  NIdx := 0;
  For I := Low (FRows) To High (FRows) Do
    If (FRows[I] <= 0) Then Begin
      NIdx := I;
      Break;
    End; { If }

  If (NIdx > 0) Then
    With FController, Paper Do Begin
      Tmp := FRButt.Y;

      While ((Tmp Mod Round(psScaling)) <> 0) Do
        Dec (Tmp);
      If (Tmp < 0) Then
        While ((Tmp Mod Round(psScaling)) <> 0) Or (Tmp < 0) Do
          Inc (Tmp);

      FRows[NIdx] := Tmp;

      PaintControlPage (Self.BoundsRect);
    End; { With }
End;

{ Sorts the rows into ascending order, but with 0's at end }
Procedure TSBSDragGroup.SortRows;
Var
  I, J, Tmp : SmallInt;
  NoChange  : Boolean;
Begin
  { Sort all cols into ascending order, but with 0's at end }
  For I := Low(FRows) To High (FRows) Do Begin
    NoChange := True;

    For J := Low(FRows) To (High (FRows) - 1) Do
      If ((FRows[J + 1] > 0) And (FRows[J] > FRows[J + 1])) Or ((FRows[J] = 0) And (FRows[J + 1] > 0)) Then Begin
        Tmp          := FRows[J + 1];
        FRows[J + 1] := FRows[J];
        FRows[J]     := Tmp;
        NoChange     := False
      End; { If }

    If NoChange Then Break;
  End; { For }
End;

{ deletes the row above the FRButt position }
Procedure TSBSDragGroup.DeleteRow;
Var
  I : SmallInt;
Begin
  SortRows;

  For I := High (FRows) DownTo Low(FRows) Do Begin
    If (FRows[I] <> 0) And (FRows[I] < FRButt.Y) Then Begin
      FRows[I] := 0;
      Break;
    End; { If }
  End; { For }

  FController.PaintControlPage (Self.BoundsRect);
End;

Initialization
  EmptyRect := Rect (0, 0, 0, 0);
  LastCapture := 0;
end.
