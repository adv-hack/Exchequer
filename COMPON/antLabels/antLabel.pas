{******************************************************************************}
{**                                                                          **}
{**  TantLabel Component - enhanced TLabel control. Active at runtime, with  **}
{**    3d styled view support. And "HighLight" support.                      **}
{**  For Delphi 2-5, C++ Builder 1-4.                                        **}
{**                                                                          **}
{**  Author:    KARPOLAN                                                     **}
{**  E-Mail:    karpolan@yahoo.com , karpolan@utilmind.com                   **}
{**  Home Page: http://karpolan.i.am, http://www.utilmind.com                **}
{**  Copyright © 1996-99 by KARPOLAN.                                        **}
{**                                                                          **}
{******************************************************************************}
{** History:
  21 des 1998 - 1.0 First release....
  11 feb 1999 - 1.1 Fixed wrong color when Color3d = False.
  16 feb 1999 - 1.2 Move "Pressed" property to Public section.
  17 feb 1999 - 2.0 Added "HighLight" support:
    Types      : TantHighLightStyle.
    Properties : HighLight, HighLightColor, HighLightXDepth, HighLightYDepth.
                 HighLightStyle (WARNING! hlsFull style - is most slowest in
                 painting).
    Methods    : DrawHighLightBorder.
  26 feb 1999 - 2.1 Reorganized for old Delphi versions support. Added some
    compiler derectives for correct methods inheriting. Some of "SetXXX" methods
    moved to Protected section.
    Added/Overrided:
     Methods : Paint, AdjustBounds, DrawTextNormal, DrawText3d.
  28 apr 1999 - 2.2 Fixed invalidation on Font changing.
  31 aug 1999 - 2.3 Prepared for public release. Some updates...
*******************************************************************************}
Unit antLabel;

{$Include antLabels.Inc - contains compiler derectives}

Interface

Uses
  Windows, Messages, Classes, Graphics, Controls, Dialogs, StdCtrls,
{*******************************************************************************
    This unit contains Descriptors(Classes) for properties organizations and
  is a part of AntUnits units set.
*******************************************************************************}
  AntDesc;

Type
  TantHighLightStyle = (hlsNormal, hlsDiagonal, hlsFull);

{##############################################################################}
{## TantCustomLabel = Class(TCustomLabel) #####################################}
{##############################################################################}
  TantCustomLabel = Class(TCustomLabel)
  Private
  {** Fields **}
    fRunTimeState    : TantRunTimeState;
    fMouseInControl  : Boolean;
    fPressed         : Boolean;
    fActive          : Boolean;
    fAutoSize        : Boolean;
{$IfNDef Delphi4andHigher}
    fEnabled         : Boolean;
{$EndIf Delphi4andHigher}
    fColor3d         : Boolean;
    fColor3dXDepth   : integer;
    fColor3dYDepth   : integer;
    fColorFront      : TantRunTimeColorDesc;
    fColorBack       : TantRunTimeColorDesc;
    fCursors         : TantRunTimeCursorDesc;
    fHighLight       : TantRunTimeBooleanDesc;
    fHighLightColor  : TantRunTimeColorDesc;
    fHighLightStyle  : TantHighLightStyle;
    fHighLightXDepth : integer;
    fHighLightYDepth : integer;
    fUnderLine       : TantRunTimeBooleanDesc;
  {** Events Fields **}
    fOnMouseEnter  : TNotifyEvent;
    fOnMouseLeave  : TNotifyEvent;
  {** Properties Routine **}
    Procedure SetColor3d        (A : Boolean);
    Procedure SetColor3dXDepth  (A : integer);
    Procedure SetColor3dYDepth  (A : integer);
    Procedure SetHighLightXDepth(A : integer);
    Procedure SetHighLightYDepth(A : integer);
    Procedure SetHighLightStyle (A : TantHighLightStyle);
  {** Messages Routine **}
    Procedure CMTextChanged(Var Message: TMessage); Message CM_TEXTCHANGED;
    Procedure CMFontChanged(Var Message: TMessage); Message CM_FONTCHANGED;
    Procedure WMLButtonDown(Var Message: TMessage); Message WM_LBUTTONDOWN;
    Procedure WMLButtonUp  (Var Message: TMessage); Message WM_LBUTTONUP;
    Procedure CMMouseEnter (Var Message: TMessage); Message CM_MOUSEENTER;
    Procedure CMMouseLeave (Var Message: TMessage); Message CM_MOUSELEAVE;

  Protected
  {** Override This **}
    Procedure Paint;                                                   Override;
    Procedure Notification(AComponent: TComponent;
                           Operation : TOperation);                    Override;
    Procedure Loaded;                                                  Override;
  {** TextOut Routines **}
{$IfDef Delphi4andHigher}
    Procedure AdjustBounds;                                            Override;
    Procedure DoDrawText(Var ARect : TRect;
                         AFlags    : LongInt);                         Override;
{$Else Delphi4andHigher}
    Procedure AdjustBounds;                                             Virtual;
    Procedure DoDrawText(Var ARect : TRect;
                         AFlags    : LongInt);                          Virtual;
{$EndIf Delphi4andHigher}
    Procedure DrawTextNormal(Const AText : String;
                             ATextLen    : LongInt;
                             Var ARect   : TRect;
                             AFlags      : LongInt);                    Virtual;
    Procedure DrawText3d(Const AText : String;
                         ATextLen    : LongInt;
                         Var ARect   : TRect;
                         AFlags      : LongInt);                        Virtual;
    Procedure DrawHighLightBorder(Const AText : String;
                                  ATextLen    : LongInt;
                                  Var ARect   : TRect;
                                  AFlags      : LongInt);               Virtual;
  {** Properties Routines **}
    Procedure SetRuntimeState(A : TantRuntimeState);                    Virtual;
    Procedure SetActive      (A : Boolean);                             Virtual;
    Procedure SetAutoSize    (A : Boolean);                            Override;
{$IfDef Delphi4andHigher}
    Procedure SetEnabled     (A : Boolean);                            Override;
{$Else Delphi4andHigher}
    Procedure SetEnabled     (A : Boolean);                             Virtual;
{$EndIf Delphi4andHigher}
  {** Properties **}
    Property Active            : Boolean
      Read   fActive
      Write  SetActive           Default True;
    Property AutoSize          : Boolean
      Read   fAutoSize
      Write  SetAutoSize         Default True;
{$IfNDef Delphi4andHigher}
    Property Enabled           : Boolean
      Read   fEnabled
      Write  SetEnabled          Default True;
{$EndIf Delphi4andHigher}
    Property Color3d           : Boolean
      Read   fColor3d
      Write  SetColor3d          Default True;
    Property Color3dXDepth     : integer
      Read   fColor3dXDepth
      Write  SetColor3dXDepth    Default 1;
    Property Color3dYDepth     : integer
      Read   fColor3dYDepth
      Write  SetColor3dYDepth    Default 1;
    Property ColorFront        : TantRunTimeColorDesc
      Read   fColorFront
      Write  fColorFront;
    Property ColorBack         : TantRunTimeColorDesc
      Read   fColorBack
      Write  fColorBack;
    Property Cursors           : TantRunTimeCursorDesc
      Read   fCursors
      Write  fCursors;
    Property HighLight         : TantRunTimeBooleanDesc
      Read   fHighLight
      Write  fHighLight;
    Property HighLightColor    : TantRunTimeColorDesc
      Read   fHighLightColor
      Write  fHighLightColor;
    Property HighLightStyle    : TantHighLightStyle
      Read   fHighLightStyle
      Write  SetHighLightStyle   Default hlsNormal;
    Property HighLightXDepth   : integer
      Read   fHighLightXDepth
      Write  SetHighLightXDepth  Default 1;
    Property HighLightYDepth   : integer
      Read   fHighLightYDepth
      Write  SetHighLightYDepth  Default 1;
    Property UnderLine         : TantRunTimeBooleanDesc
      Read   fUnderLine
      Write  fUnderLine;
  {** Events **}
    Property OnMouseEnter      : TNotifyEvent
      Read   fOnMouseEnter
      Write  fOnMouseEnter;
    Property OnMouseLeave      : TNotifyEvent
      Read   fOnMouseLeave
      Write  fOnMouseLeave;
  Public
  {** Init/Done **}
    Constructor Create(AOwner : TComponent);                           Override;
    Destructor  Destroy;                                               Override;
  {** Properties **}
    Property RuntimeState      : TantRuntimeState
      Read   fRuntimeState
      Write  SetRuntimeState;
    Property MouseInControl    : Boolean
      Read   fMouseInControl
      Write  fMouseInControl;
    Property Pressed           : Boolean
      Read   fPressed
      Write  fPressed;
  End;{TantCustomLabel = Class(TCustomLabel)}


{##############################################################################}
{## TantLabel = Class(TantCustomLabel) ########################################}
{##############################################################################}
  TantLabel = Class(TantCustomLabel)
  Published
  {** Properties **}
    Property Active;
    Property Align;
    Property Alignment;
    Property AutoSize;
    Property Caption;
    Property Color3d;
    Property Color3dXDepth;
    Property Color3dYDepth;
    Property ColorFront;
    Property ColorBack;
    Property Cursors;
    Property Enabled;
    Property FocusControl;
    Property Font;
    Property HighLight;
    Property HighLightColor;
    Property HighLightStyle;
    Property HighLightXDepth;
    Property HighLightYDepth;
    Property ParentFont;
    Property ParentShowHint;
    Property PopupMenu;
    Property ShowHint;
    Property Transparent;
    Property UnderLine;
    Property Visible;
    Property WordWrap;
{$IfDef Delphi3andHigher}
    Property Layout;
{$EndIf Delphi3andHigher}
{$IfDef Delphi4andHigher}
    Property Anchors;
    Property BiDiMode;
    Property Constraints;
    Property ParentBiDiMode;
{$EndIf Delphi4andHigher}
  {** Events **}
    Property OnClick;
    Property OnDblClick;
    Property OnDragDrop;
    Property OnDragOver;
    Property OnEndDrag;
    Property OnMouseDown;
    property OnMouseMove;
    Property OnMouseEnter;
    Property OnMouseLeave;
    Property OnMouseUp;
    Property OnStartDrag;
{$IfDef Delphi4andHigher}
    Property OnStartDock;
    Property OnEndDock;
{$EndIf Delphi4andHigher}
  End;{TantLabel = Class(TantCustomLabel)}

{##############################################################################}
{******************************************************************************}
{##############################################################################}
Implementation
{##############################################################################}
{******************************************************************************}
{##############################################################################}
Uses
  SysUtils;

{##############################################################################}
{## TantCustomLabel = Class(TCustomLabel) #####################################}
{##############################################################################}
Const
  Alignments : Array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps  : Array[Boolean   ] of Word = (0, DT_WORDBREAK);
{$IfDef Delphi2andLower}
  crHandPoint = crUpArrow;
{$EndIf Delphi2andLower}

{******************************************************************************}
{** Public ********************************************************************}
{******************************************************************************}
{** Init/Done **}
{***************}
Constructor TantCustomLabel.Create(AOwner : TComponent);
Begin
  Inherited Create(AOwner);
  fRunTimeState    := rtsNormal;
//  fActive          := True;
  fActive          := FALSE;
  fAutoSize        := True;
{$IfNDef Delphi4andHigher}
  fEnabled         := True;
{$EndIf Delphi4andHigher}
  fColor3d         := FALSE;
//  fColor3dXDepth   := 1;
//  fColor3dYDepth   := 1;
  fHighLightStyle  := hlsFull;
  fHighLightXDepth := 1;
  fHighLightYDepth := 1;
{** Create complex properties **}
  fColorFront     := TantRunTimeColorDesc.CreateWithData(Self, Invalidate,
                       clBlack, clBlue, clRed, clBtnShadow);
  fColorBack      := TantRunTimeColorDesc .CreateWithData(Self, Invalidate,
                       clBtnShadow, clNavy, clMaroon, clBtnHighlight);
  fCursors        := TantRunTimeCursorDesc.CreateWithData(Self, nil,
                       crDefault, crHandPoint, crHandPoint, crDefault);
  fHighLight      := TantRunTimeBooleanDesc.CreateWithData(Self, Invalidate,
                       TRUE, FALSE, FALSE, TRUE);
  fHighLightColor := TantRunTimeColorDesc.CreateWithData(Self, Invalidate,
                       clWhite, clWhite, clWhite, clBtnHighlight);
  fUnderLine      := TantRunTimeBooleanDesc.CreateWithData(Self, Invalidate,
                       False, True, True, False);

  Font.Style := [fsBold];

End;{Constructor TantCustomLabel.Create}

Destructor TantCustomLabel.Destroy;
Begin
{** Free complex properties **}
  fUnderLine     .Free;
  fHighLightColor.Free;
  fHighLight     .Free;
  fCursors       .Free;
  fColorBack     .Free;
  fColorFront    .Free;
  Inherited Destroy;
End;{Destructor TantCustomLabel.Destroy}

{******************************************************************************}
{** Protected *****************************************************************}
{******************************************************************************}
{** Override This **}
{*******************}
Procedure TantCustomLabel.Paint;
Var
{$IfDef Delphi3andHigher}
  CalcRect  : TRect;
{$EndIf Delphi3andHigher}
  ARect     : TRect;
  DrawStyle : Integer;
Begin
  with Canvas do
   begin
     ARect := ClientRect;
     if not Transparent then
      begin
        Brush.Color := Self.Color;
        Brush.Style := bsSolid;
        FillRect(ARect);
      end;{if not Transparent then}

     InflateRect(ARect, -HighLightXDepth, -HighLightYDepth);

     Brush.Style := bsClear;
     DrawStyle := DT_EXPANDTABS or WordWraps[WordWrap] or Alignments[Alignment];
{$IfDef Delphi3andHigher}
   {** Calculate vertical layout **}
     if Layout <> tlTop then
      begin
        CalcRect := ARect;
        DoDrawText(CalcRect, DrawStyle or DT_CALCRECT);
        if Layout = tlBottom
         then OffsetRect(ARect, 0, (Height - CalcRect.Bottom))
         else OffsetRect(ARect, 0, (Height - CalcRect.Bottom) div 2);
      end;{if Layout <> tlTop then}
{$EndIf Delphi3andHigher}

     DoDrawText(ARect, DrawStyle);
   end;{with Canvas do}
End;{Procedure TantCustomLabel.Paint}

Procedure TantCustomLabel.Notification(AComponent: TComponent;
                                       Operation : TOperation);
Begin
  Inherited Notification(AComponent, Operation);
End;{Procedure TantCustomLabel.Notification}

Procedure TantCustomLabel.Loaded;
Begin
{$IfNDef Delphi4andHigher}
//  Inherited Loaded;
{$EndIf Delphi4andHigher}
  SetEnabled(Enabled);
  AdjustBounds;
End;{Procedure TantCustomLabel.Loaded}

{**********************}
{** TextOut Routines **}
{**********************}
Procedure TantCustomLabel.AdjustBounds;
Var
  DC    : HDC;
  X     : integer;
  ARect : TRect;
Begin
  if (csReading in ComponentState) or (not AutoSize)
   then Exit;

  ARect := ClientRect;
{** Reserve place for HihgLight border **}
  InflateRect(ARect, -HighLightXDepth, -HighLightYDepth);

  DC := GetDC(0);
  Canvas.Handle := DC;
  DoDrawText(ARect, (DT_EXPANDTABS or DT_CALCRECT) or WordWraps[WordWrap]);
  Canvas.Handle := 0;
  ReleaseDC(0, DC);

{** Restore place for HihgLight border **}
  InflateRect(ARect, HighLightXDepth, HighLightYDepth);

  X := Left;
  if Alignment = taRightJustify then
   begin
   {** Shift if needed **}
     OffsetRect(ARect, -ARect.Left, 0);
     Inc(X, Width - ARect.Right);
   end;{if Alignment = taRightJustify then}

  SetBounds(X, Top, ARect.Right, ARect.Bottom);
End;{Procedure TantCustomLabel.AdjustBounds}

Procedure TantCustomLabel.DoDrawText(Var ARect  : TRect;
                                     AFlags     : LongInt);
Var
  Text    : String;
  TextLen : integer;
Begin
  Text := Caption;
  if ((AFlags and DT_CALCRECT <> 0) and ((Text = ''))
     or (ShowAccelChar and (Text[1] = '&') and (Text[2] = #0)))
   then Text := Text + ' ';
  if not ShowAccelChar
   then AFlags := (AFlags or DT_NOPREFIX);

  TextLen := Length(Text);
  Canvas.Font := Font;
  if fUnderLine.Current
   then Font.Style := Font.Style + [fsUnderline]
   else Font.Style := Font.Style - [fsUnderline];

  if Color3d
   then DrawText3d    (Text, TextLen, ARect, AFlags)
   else DrawTextNormal(Text, TextLen, ARect, AFlags);
End;{Procedure TantCustomLabel.DoDrawText}

Procedure TantCustomLabel.DrawTextNormal(Const AText : String;
                                         ATextLen    : LongInt;
                                         Var ARect   : TRect;
                                         AFlags      : LongInt);
Begin
{** Default (Like TLable) Drawing Style **}
  with Canvas do
   begin
     if not Enabled then
      begin
      {** Draw Shadow **}
        OffsetRect(ARect, 1, 1);
        Font.Color := clBtnHighlight;
        DrawText(Handle, PChar(AText), ATextLen, ARect, AFlags);
        OffsetRect(ARect, -1, -1);
      {** Draw HighLight if needed **}
        if HighLight.Current
         then DrawHighLightBorder(AText, ATextLen, ARect, AFlags);
      {** Draw Front **}
        Font.Color := clBtnShadow;
        DrawText(Handle, PChar(AText), ATextLen, ARect, AFlags);
        Exit;
      end;{if not Enabled then}

   {** Draw HighLight if needed **}
     if HighLight.Current
      then DrawHighLightBorder(AText, ATextLen, ARect, AFlags);

   {** Draw Normal **}
     Font.Color := ColorFront.Current;
     DrawText(Canvas.Handle, PChar(AText), ATextLen, ARect, AFlags);
   end;{with Canvas do}

End;{Procedure TantCustomLabel.DrawTextNormal}

Procedure TantCustomLabel.DrawText3d(Const AText : String;
                                     ATextLen    : LongInt;
                                     Var ARect   : TRect;
                                     AFlags      : LongInt);
Var
  XDepth   , YDepth    : integer;
  rectFront, rectBack  : TRect;
Begin
  XDepth    := Color3dXDepth;
  YDepth    := Color3dYDepth;
  rectFront := ARect;
  rectBack  := rectFront;

{** Fixing Rects by X **}
  case Alignment of
   taLeftJustify  : begin
     if (XDepth > 0)
      then OffsetRect(rectBack ,  XDepth, 0)
      else OffsetRect(rectFront, -XDepth, 0);
   end;
   taCenter       : begin
     Dec(rectFront.Right, Abs(XDepth));
     Dec(rectBack .Right, Abs(XDepth));
     if (XDepth > 0)
      then OffsetRect(rectBack ,  XDepth, 0)
      else OffsetRect(rectFront, -XDepth, 0);
   end;
   taRightJustify : begin
     if (XDepth > 0)
      then OffsetRect(rectFront, -XDepth, 0)
      else OffsetRect(rectBack ,  XDepth, 0);
   end;
  end;{case Alignment of}

{** Fixing Rects by Y **}
  if (YDepth > 0)
   then OffsetRect(rectBack , 0,  YDepth)
   else OffsetRect(rectFront, 0, -YDepth);

{** Draw Back **}
  if (XDepth <> 0) or (YDepth <> 0) then
   begin
     Canvas.Font.Color := ColorBack.Current;
     DrawText(Canvas.Handle, PChar(Text), ATextLen, rectBack, AFlags);
   end;{if (XDepth + YDepth) <> 0 then}

{** Draw HighLight if needed **}
  if HighLight.Current
   then DrawHighLightBorder(AText, ATextLen, rectFront, AFlags);

{** Draw Front **}
  Canvas.Font.Color := ColorFront.Current;
  DrawText(Canvas.Handle, PChar(AText), ATextLen, rectFront, AFlags);

{** External Rect Fixing **}
  UnionRect(ARect, rectFront, rectBack);
End;{Procedure TantCustomLabel.DrawText3d}

Procedure TantCustomLabel.DrawHighLightBorder(Const AText : String;
                                              ATextLen    : LongInt;
                                              Var ARect   : TRect;
                                              AFlags      : LongInt);
Var
  XDepth, YDepth : integer;
  RegRect        : TRect;

  Procedure NormalBorder;
  Begin
    with Canvas do
     begin
       Font.Color  := HighLightColor.Current;
     {** Draw Top Part **}
       OffsetRect(RegRect, 0, -YDepth);
       DrawText(Handle, PChar(AText), ATextLen, RegRect, AFlags);
     {** Draw Bottom Part **}
       OffsetRect(RegRect, 0, 2*YDepth);
       DrawText(Handle, PChar(AText), ATextLen, RegRect, AFlags);
     {** Draw Left Part **}
       OffsetRect(RegRect, -XDepth, -YDepth);
       DrawText(Handle, PChar(AText), ATextLen, RegRect, AFlags);
     {** Draw Right Part **}
       OffsetRect(RegRect, 2*XDepth, 0);
       DrawText(Handle, PChar(AText), ATextLen, RegRect, AFlags);
     end;{with Canvas do}
  End;{INTERNAL Procedure NormalBorder}

  Procedure DiagonalBorder;
  Begin
    with Canvas do
     begin
       Font.Color  := HighLightColor.Current;
     {** Draw Left-Top Part **}
       OffsetRect(RegRect, -XDepth, -YDepth);
       DrawText(Handle, PChar(AText), ATextLen, RegRect, AFlags);
     {** Draw Right-Top Part **}
       OffsetRect(RegRect, 2*XDepth, 0);
       DrawText(Handle, PChar(AText), ATextLen, RegRect, AFlags);
     {** Draw Right-Bottom Part **}
       OffsetRect(RegRect, 0, 2*YDepth);
       DrawText(Handle, PChar(AText), ATextLen, RegRect, AFlags);
     {** Draw Left-Bottom Part **}
       OffsetRect(RegRect, -2*XDepth, 0);
       DrawText(Handle, PChar(AText), ATextLen, RegRect, AFlags);
     end;{with Canvas do}
  End;{INTERNAL Procedure DiagonalBorder}

Begin
  RegRect := ARect;
  XDepth  := HighLightXDepth;
  YDepth  := HighLightYDepth;

  case fHighLightStyle of
   hlsNormal   : NormalBorder;
   hlsDiagonal : DiagonalBorder;
   else begin
     NormalBorder;
     RegRect := ARect;
     DiagonalBorder;
   end;
  end;{case fHighLightStyle of}
End;{Procedure TantCustomLabel.DrawHighLightBorder}


{*************************}
{** Properties Routines **}
{*************************}
Procedure TantCustomLabel.SetRuntimeState (A : TantRuntimeState);
Begin
  if fRuntimeState = A
   then Exit;
  fRuntimeState := A;

{** Apply RunTimeState to all Property Descriptors **}
  fColorFront    .RunTimeState := fRuntimeState;
  fColorBack     .RunTimeState := fRuntimeState;
  fCursors       .RunTimeState := fRuntimeState;
  fHighLight     .RunTimeState := fRuntimeState;
  fHighLightColor.RunTimeState := fRuntimeState;
  fUnderLine     .RunTimeState := fRuntimeState;
{** Set other properties **}
  Cursor     := fCursors   .Current;
  Font.Color := fColorFront.Current;
  if fUnderLine.Current
   then Font.Style := Font.Style + [fsUnderline]
   else Font.Style := Font.Style - [fsUnderline];

  Invalidate;
End;{Procedure TantCustomLabel.SetRuntimeState}

Procedure TantCustomLabel.SetActive(A : Boolean);
Begin
  if fActive = A
   then Exit;
  fActive := A;
  Invalidate;
End;{Procedure TantCustomLabel.SetActive}

Procedure TantCustomLabel.SetAutoSize(A : Boolean);
Begin
  if fAutoSize = A
   then Exit;
  fAutoSize := A;
  AdjustBounds;
  Invalidate;
End;{Procedure TantCustomLabel.SetActive}

Procedure TantCustomLabel.SetEnabled(A : Boolean);
Begin
{$IfNDef Delphi4andHigher}
  fEnabled := A;
  Inherited Enabled := A;
{$Else Delphi4andHigher}
  Inherited SetEnabled(A);
{$EndIf Delphi4andHigher}

  if Enabled
   then RunTimeState := rtsNormal
   else RunTimeState := rtsDisabled;
End;{Procedure TantCustomLabel.SetEnabled}


{******************************************************************************}
{** Private *******************************************************************}
{******************************************************************************}
{** Properties Routine **}
{************************}
Procedure TantCustomLabel.SetColor3d(A : Boolean);
Begin
  if fColor3d = A
   then Exit;
  fColor3d := A;
  AdjustBounds;
  Invalidate;
End;{Procedure TantCustomLabel.SetColor3d}

Procedure TantCustomLabel.SetColor3dXDepth(A : integer);
Begin
  if fColor3dXDepth = A
   then Exit;
  fColor3dXDepth := A;
  AdjustBounds;
  Invalidate;
End;{Procedure TantCustomLabel.SetColor3dXDepth}

Procedure TantCustomLabel.SetColor3dYDepth(A : integer);
Begin
  if fColor3dYDepth = A
   then Exit;
  fColor3dYDepth := A;
  AdjustBounds;
  Invalidate;
End;{Procedure TantCustomLabel.SetColor3dYDepth}

Procedure TantCustomLabel.SetHighLightStyle(A : TantHighLightStyle);
Begin
  if fHighLightStyle = A
   then Exit;
  fHighLightStyle := A;
  AdjustBounds;
  Invalidate;
End;{Procedure TantCustomLabel.SetHighLightStyle}

Procedure TantCustomLabel.SetHighLightXDepth(A : integer);
Begin
  if (A < 0) or (fHighLightXDepth = A)
   then Exit;
  fHighLightXDepth := A;
  AdjustBounds;
  Invalidate;
End;{Procedure TantCustomLabel.SetHighLightXDepth}

Procedure TantCustomLabel.SetHighLightYDepth(A : integer);
Begin
  if (A < 0) or (fHighLightYDepth = A)
   then Exit;
  fHighLightYDepth := A;
  AdjustBounds;
  Invalidate;
End;{Procedure TantCustomLabel.SetHighLightYDepth}


{**********************}
{** Messages Routine **}
{**********************}
Procedure TantCustomLabel.CMTextChanged(Var Message: TMessage);
Begin
  AdjustBounds;
  Invalidate;
End;{Procedure TantCustomLabel.CMTextChanged}

Procedure TantCustomLabel.CMFontChanged(var Message: TMessage);
Begin
  AdjustBounds;
  Invalidate;
End;{Procedure TantCustomLabel.CMFontChanged}

Procedure TantCustomLabel.WMLButtonDown(Var Message: TMessage);
Begin
  fPressed := True;

  if (Enabled and Active)
   then RunTimeState := rtsActive;

  Inherited;
End;{Procedure TantCustomLabel.WMLButtonDown}

Procedure TantCustomLabel.WMLButtonUp(Var Message: TMessage);
Begin
  fPressed := False;

  if (Enabled and Active) then
   begin
     if fMouseInControl
      then RunTimeState := rtsSelected
      else RunTimeState := rtsNormal;
   end;{if (Enabled and Active) then}

  Inherited;
End;{Procedure TantCustomLabel.WMLButtonUp}

Procedure TantCustomLabel.CMMouseEnter(Var Message: TMessage);
Begin
  fMouseInControl := True;

  if (Enabled and Active) then
   begin
     if fPressed
      then RunTimeState := rtsActive
      else RunTimeState := rtsSelected;
   end;{if Enabled then}

  if Assigned(fOnMouseEnter)
   then fOnMouseEnter(Self);

  Inherited;
End;{Procedure TantCustomLabel.CMMouseEnter}

Procedure TantCustomLabel.CMMouseLeave(Var Message: TMessage);
Begin
  fMouseInControl := False;

  if Enabled then
   begin
     if Active and fPressed
      then RunTimeState := rtsSelected
      else RunTimeState := rtsNormal;
   end;{if Enabled then}

  if Assigned(fOnMouseLeave)
   then fOnMouseLeave(Self);

  Inherited;
End;{Procedure TantCustomLabel.CMMouseLeave}


END{Unit antLabel}.
