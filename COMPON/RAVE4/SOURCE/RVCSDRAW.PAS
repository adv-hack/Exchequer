{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVCsDraw;

interface

uses
  {$IFDEF Linux}
  QControls, QGraphics, Types,
  {$ELSE}
  Messages, WinProcs, WinTypes, Controls, Graphics,
  {$ENDIF}
  Classes, SysUtils, RVDefine, RVUtil, RVClass, RPDefine, RPBase;

type
  TRaveGraphicBase = class(TRaveControl)
  protected
    PenWidth: TRaveFloat;
    PenWidthType: TLineWidthType;
    GraphicPen: TPen;

    procedure SetForeColor(Value: TColor); override;
    function GetForeColor: TColor; override;
    procedure SetLineWidth(Value: TRaveFloat); override;
    function GetLineWidth: TRaveFloat; override;
    procedure SetLineWidthType(Value: TLineWidthType); override;
    function GetLineWidthType: TLineWidthType; override;
    procedure SetLineStyle(Value: TPenStyle); override;
    function GetLineStyle: TPenStyle; override;
    procedure AssignPen(    Pen: TPen;
                            Report: TBaseReport;
                        var PenAdjust: integer;
                        var PenAdjust2: integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end; { TRaveGraphicBase }

  TRaveLine = class(TRaveGraphicBase)
  protected
    FNESW: boolean;
  public
  {$IFDEF DESIGNER}
    constructor Create(AOwner: TComponent); override;
    function IsSelectPoint(Point: TRavePoint): boolean; override;
    function InSelectRect(Rect: TRaveRect): boolean; override;
    procedure CreatePips; override;
    procedure UpdatePips; override;
    procedure PipSize(RavePip: TRavePip;
                      X: TRaveUnits;
                      Y: TRaveUnits); override;
    procedure Paint(Canvas: TCanvas); override;
  {$ENDIF}
    procedure SetSize(P1: TRavePoint;
                      P2: TRavePoint); override;
    procedure Print(Report: TBaseReport); override;

  published
    property Color: TColor read GetForeColor write SetForeColor default clBlack;
    property Cursor;
    property Height;
    property Left;
    property LineStyle: TPenStyle read GetLineStyle write SetLineStyle default
     psSolid;
    property LineWidth: TRaveFloat read GetLineWidth write SetLineWidth;
    property LineWidthType: TLineWidthType read GetLineWidthType write
     SetLineWidthType default wtPixels;
    property NESW: boolean read FNESW write FNESW;
    property Top;
    property Width;
  end; { TRaveLine }

  TRaveHLine = class(TRaveLine)
  public
  {$IFDEF DESIGNER}
    constructor Create(AOwner: TComponent); override;
    class procedure ModifyRect(var P1: TPoint;
                               var P2: TPoint;
                                   PipIndex: byte); override;
    function IsSelectPoint(Point: TRavePoint): boolean; override;
    procedure PipSize(RavePip: TRavePip;
                      X: TRaveUnits;
                      Y: TRaveUnits); override;
  {$ENDIF}
    {$IFNDEF VER93}class{$ENDIF} procedure ModifyRaveRect(var P1: TRavePoint;
                                                          var P2: TRavePoint); override;
  end; { TRaveHLine }

  TRaveVLine = class(TRaveLine)
  public
  {$IFDEF DESIGNER}
    constructor Create(AOwner: TComponent); override;
    class procedure ModifyRect(var P1: TPoint;
                               var P2: TPoint;
                                   PipIndex: byte); override;
    function IsSelectPoint(Point: TRavePoint): boolean; override;
    procedure PipSize(RavePip: TRavePip;
                      X: TRaveUnits;
                      Y: TRaveUnits); override;
  {$ENDIF}
    {$IFNDEF VER93}class{$ENDIF} procedure ModifyRaveRect(var P1: TRavePoint;
                                                          var P2: TRavePoint); override;
  end; { TRaveVLine }

  TRaveSurface = class(TRaveGraphicBase)
  protected
    FillBrush: TBrush;

    procedure SetBackColor(Value: TColor); override;
    function GetBackColor: TColor; override;
    procedure SetFillStyle(Value: TRaveFillStyle); override;
    function GetFillStyle: TRaveFillStyle; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property BorderColor: TColor read GetForeColor write SetForeColor default clBlack;
    property BorderStyle: TPenStyle read GetLineStyle write SetLineStyle default psSolid;
    property BorderWidth: TRaveFloat read GetLineWidth write SetLineWidth;
    property BorderWidthType: TLineWidthType read GetLineWidthType write
     SetLineWidthType default wtPixels;
    property FillColor: TColor read GetBackColor write SetBackColor default clWhite;
  end; { TRaveSurface }

  TRaveRectangle = class(TRaveSurface)
  protected
    FHRadius: TRaveUnits;
    FVRadius: TRaveUnits;

    procedure SetHRadius(Value: TRaveUnits);
    procedure SetVRadius(Value: TRaveUnits);
  public
  {$IFDEF DESIGNER}
    constructor Create(AOwner: TComponent); override;
    procedure Paint(Canvas: TCanvas); override;
  {$ENDIF}
    procedure Print(Report: TBaseReport); override;
  published
    property BorderColor;
    property BorderStyle;
    property BorderWidth;
    property BorderWidthType;
    property Cursor;
    property FillColor;
    property FillStyle;
    property Height;
    property HRadius: TRaveUnits read FHRadius write SetHRadius;
    property Left;
    property Top;
    property VRadius: TRaveUnits read FVRadius write SetVRadius;
    property Width;
  end; { TRaveRectangle }

  TRaveSquare = class(TRaveRectangle)
  public
  {$IFDEF DESIGNER}
    constructor Create(AOwner: TComponent); override;
    class procedure ModifyRect(var P1: TPoint;
                               var P2: TPoint;
                                   PipIndex: byte); override;
    procedure CreatePips; override;
    procedure UpdatePips; override;
  {$ENDIF}
    {$IFNDEF VER93}class{$ENDIF} procedure ModifyRaveRect(var P1: TRavePoint;
                                                          var P2: TRavePoint); override;
  end; { TRaveSquare }

  TRaveEllipse = class(TRaveSurface)
  public
  {$IFDEF DESIGNER}
    constructor Create(AOwner: TComponent); override;
    procedure Paint(Canvas: TCanvas); override;
  {$ENDIF}
    procedure Print(Report: TBaseReport); override;
  published
    property BorderColor;
    property BorderStyle;
    property BorderWidth;
    property BorderWidthType;
    property Cursor;
    property FillColor;
    property FillStyle;
    property Height;
    property Left;
    property Top;
    property Width;
  end; { TRaveEllipse }

  TRaveCircle = class(TRaveEllipse)
  public
  {$IFDEF DESIGNER}
    constructor Create(AOwner: TComponent); override;
    class procedure ModifyRect(var P1: TPoint;
                               var P2: TPoint;
                                   PipIndex: byte); override;
    procedure CreatePips; override;
    procedure UpdatePips; override;
  {$ENDIF}
    {$IFNDEF VER93}class{$ENDIF} procedure ModifyRaveRect(var P1: TRavePoint;
                                                          var P2: TRavePoint); override;
  end; { TRaveCircle }

  procedure RaveRegister;

implementation

{$IFDEF DESIGNER}
{$R *.RES}
{$ENDIF}

  procedure RaveRegister;

  begin { RaveRegister }
  {TransOff}
    RegisterRaveGroup('Graphics',Trans('Drawing'));
    RegisterRaveComponents('Graphics',[TRaveLine,TRaveHLine,
     TRaveVLine,TRaveRectangle,TRaveSquare,TRaveEllipse,TRaveCircle]);
    RegisterRaveModuleClasses('RVCsDraw',[TRaveLine,TRaveHLine,TRaveVLine,
     TRaveRectangle,TRaveSquare,TRaveEllipse,TRaveCircle]);

  {$IFDEF DESIGNER}
    RegisterRaveProperties(TRaveGraphicBase,
     {Beginner}     '',
     {Intermediate} 'Height;Left;Top;Width',
     {Developer}    'Cursor',
     {Hidden}       '');

    RegisterRaveProperties(TRaveLine,
     {Beginner}     '',
     {Intermediate} 'Color;LineStyle;LineWidth;LineWidthType',
     {Developer}    '',
     {Hidden}       'NESW');

    RegisterRaveProperties(TRaveSurface,
     {Beginner}     '',
     {Intermediate} 'BorderColor;BorderStyle;BorderWidth;BorderWidthType;' +
      'FillColor;FillStyle',
     {Developer}    '',
     {Hidden}       '');

    RegisterRaveProperties(TRaveRectangle,
     {Beginner}     '',
     {Intermediate} 'HRadius;VRadius',
     {Developer}    '',
     {Hidden}       '');

    SetPropDesc(TRaveGraphicBase,'Cursor',Trans('Defines the cursor type that ' +
     'will be used when the mouse passes over the component.'));

    SetPropDesc(TRaveLine,'Color',Trans('Defines the color of the line.  The Color ' +
     'Palette Toolbar can also be used to edit this property.'));
    SetPropDesc(TRaveLine,'LineStyle',Trans('Defines the style (pattern) of the line.  ' +
     'The Line Editor Toolbar can also be used to edit this property.  Only line ' +
     'widths of 1 pixel can have line styles other than solid.'));
    SetPropDesc(TRaveLine,'LineWidth',Trans('Defines the width of the line.  The ' +
     'units of the width are defined by the LineWidthType property.'));
    SetPropDesc(TRaveLine,'LineWidthType',Trans('Defines the units that the LineWidth ' +
     'property are in.  To print the thinnest possible line, use a line width of 1 ' +
     'pixel.  For thicker lines, values in points should be used for consistency ' +
     'across printers with different resolutions.'));

    SetPropDesc(TRaveSurface,'BorderColor',Trans('Defines the border color of the ' +
     'shape.  The Color Palette Toolbar can also be used to edit this property.'));
    SetPropDesc(TRaveSurface,'BorderStyle',Trans('Defines the style (pattern) of the border.  ' +
     'The Line Editor Toolbar can also be used to edit this property.  Only border ' +
     'widths of 1 pixel can have border styles other than solid.'));
    SetPropDesc(TRaveSurface,'BorderWidth',Trans('Defines the width of the border.  The ' +
     'units of the width are defined by the BorderWidthType property.'));
    SetPropDesc(TRaveSurface,'BorderWidthType',Trans('Defines the units that the BorderWidth ' +
     'property are in.  To print the thinnest possible border, use a border width of 1 ' +
     'pixel.  For thicker borders, values in points should be used for consistency ' +
     'across printers with different resolutions.'));
    SetPropDesc(TRaveSurface,'FillColor',Trans('Defines the fill color of the ' +
     'shape.  The Color Palette Toolbar can also be used to edit this property.'));
    SetPropDesc(TRaveSurface,'FillStyle',Trans('Defines the style (pattern) that will ' +
     'be used to draw the interior of the shape.  The fsClear setting can be used ' +
     'to print objects without any fill.'));

    SetPropDesc(TRaveRectangle,'HRadius',Trans('Defines the horizontal radius that ' +
     'can be used to draw rounded corners.  Both HRadius and VRadius must be non-zero ' +
     'for rounded corners.  Use a value of 0 for square corners.'));
    SetPropDesc(TRaveRectangle,'VRadius',Trans('Defines the vertical radius that ' +
     'will be used to draw rounded corners.  Both HRadius and VRadius must be non-zero ' +
     'for rounded corners.  Use a value of 0 for square corners.'));
  {$ENDIF}
  {TransOn}
  end; { RaveRegister }


(*****************************************************************************}
( class TRaveGraphicBase
(*****************************************************************************)

  constructor TRaveGraphicBase.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    GraphicPen := TPen.Create;
    PenWidth := 1;
    PenWidthType := wtPixels;
  end;  { Create }

  destructor TRaveGraphicBase.Destroy;

  begin { Destroy }
    GraphicPen.Free;
    inherited Destroy;
  end;  { Destroy }

  procedure TRaveGraphicBase.SetForeColor(Value: TColor);

  begin { SetForeColor }
    GraphicPen.Color := Value;
    Invalidate;
  end;  { SetForeColor }

  function TRaveGraphicBase.GetForeColor: TColor;

  begin { GetForeColor }
    Result := GraphicPen.Color;
  end;  { GetForeColor }

  procedure TRaveGraphicBase.SetLineWidth(Value: TRaveFloat);

  begin { SetLineWidth }
    PenWidth := Value;
    Invalidate;
  end;  { SetLineWidth }

  function TRaveGraphicBase.GetLineWidth: TRaveFloat;

  begin { GetLineWidth }
    Result := PenWidth;
  end;  { GetLineWidth }

  procedure TRaveGraphicBase.SetLineWidthType(Value: TLineWidthType);

  begin { SetLineWidthType }
    PenWidthType := Value;
    Invalidate;
  end;  { SetLineWidthType }

  function TRaveGraphicBase.GetLineWidthType: TLineWidthType;

  begin { GetLineWidthType }
    Result := PenWidthType;
  end;  { GetLineWidthType }

  procedure TRaveGraphicBase.SetLineStyle(Value: TPenStyle);

  begin { SetPenStyle }
    GraphicPen.Style := Value;
    Invalidate;
  end;  { SetPenStyle }

  function TRaveGraphicBase.GetLineStyle: TPenStyle;

  begin { GetPenStyle }
    Result := GraphicPen.Style;
  end;  { GetPenStyle }

  procedure TRaveGraphicBase.AssignPen(    Pen: TPen;
                                           Report: TBaseReport;
                                       var PenAdjust: integer;
                                       var PenAdjust2: integer);

  {$IFDEF DESIGNER}
  var
    I1: integer;
  {$ENDIF}

  begin { AssignPen }
    If Assigned(Pen) then begin { Output to screen }
    {$IFDEF DESIGNER}
      Pen.Assign(GraphicPen);
      If PenWidth = 0 then begin
        Pen.Style := psClear;
      end else if PenWidthType = wtPixels then begin
        Pen.Width := Round(PenWidth);
      end else begin { PenWidth is in Points }
        I1 := XI2P(PenWidth / 72.0);
        If I1 <= 0 then begin
          I1 := 1;
        end; { if }
        Pen.Width := I1;
      end; { else }

      If Pen.Style = psClear then begin
        PenAdjust := 0;
        PenAdjust2 := 0;
      end else if Pen.Style = psInsideFrame then begin
        PenAdjust := 0;
        PenAdjust2 := 1;
      end else begin
        PenAdjust := Pen.Width div 2;
        PenAdjust2 := Pen.Width - PenAdjust;
      end; { else }
    {$ENDIF}
    end else begin { Output to Report }
      If PenWidth = 0 then begin
        Report.SetPen(clBlack,psClear,0,pmCopy);
      end else if PenWidthType = wtPixels then begin
        Report.SetPen(GraphicPen.Color,GraphicPen.Style,Round(PenWidth),GraphicPen.Mode);
      end else begin { PenWidth is in Points }
        Report.SetPen(GraphicPen.Color,GraphicPen.Style,
         -(Round(10000.0 * PenWidth / 72.0) + 10000),GraphicPen.Mode);
      end; { else }
    end; { else }
  end;  { AssignPen }

(*****************************************************************************}
( class TRaveLine
(*****************************************************************************)

{$IFDEF DESIGNER}
  constructor TRaveLine.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    Width := 1.0;
    Height := 1.0;
  end;  { Create }

  function TRaveLine.IsSelectPoint(Point: TRavePoint): boolean;

  var
    M1,M2,X1,Y1,X2,Y2,X3,Y3,X4,Y4,D: double;
    PageRect: TRaveRect;

  begin { IsSelectPoint }
    PageRect := RaveRect(PageLeft,PageTop,PageRight,PageBottom);
    With PageRect do begin
      X1 := Left;
      X2 := Right;
      If NESW then begin
        Y1 := Bottom;
        Y2 := Top;
      end else begin
        Y1 := Top;
        Y2 := Bottom;
      end; { else }
      X3 := Point.X;
      Y3 := Point.Y;
      M1 := X1 - X2;
      If Abs(M1) < RAVEDELTA then begin { Vertical }
        X4 := X1;
        Y4 := Y3;
      end else begin
        M1 := (Y1 - Y2) / M1;
        If Abs(M1) < RAVEDELTA then begin { Horizontal }
          X4 := X3;
          Y4 := Y1;
        end else begin
          M2 := -1 / M1;
          X4 := ((M2 * X3 - Y3) - (M1 * X1 - Y1)) / (M2 - M1);
          Y4 := M2 * (X4 - X3) + Y3;
        end; { else }
      end; { else }
      D := Sqr(XI2D(X3) - XI2D(X4)) + Sqr(YI2D(Y3) - YI2D(Y4));
      Result := (D < 9) and (X4 >= Left) and (X4 <= Right) and
       (Y4 >= Top) and (Y4 <= Bottom) and Parent.CanSelect(self);
    end; { with }
  end;  { IsSelectPoint }

  function TRaveLine.InSelectRect(Rect: TRaveRect): boolean;

  var
    SharedRect: TRaveRect;
    M,Y1,Y2,X3,X4,Y3,Y4: TRaveUnits;
    PageRect: TRaveRect;

  begin { InSelectRect }
    PageRect := RaveRect(PageLeft,PageTop,PageRight,PageBottom);
    Result := IntersectRaveRect(SharedRect,Rect,PageRect);
    If Result then begin
      With PageRect do begin
        If FEQ(Left,Right) or FEQ(Top,Bottom) then begin
          Exit; { Already checked through IntersectRect }
        end else begin
          If NESW then begin
            Y1 := Bottom;
            Y2 := Top;
          end else begin
            Y1 := Top;
            Y2 := Bottom;
          end; { else }
          M := (Y2 - Y1) / Width;
          X3 := ((Rect.Top - Y1) / M) + Left;
          Y3 := ((Rect.Left - Left) * M) + Y1;
          X4 := ((Rect.Bottom - Y1) / M) + Left;
          Y4 := ((Rect.Right - Left) * M) + Y1;
          Result := ((FGE(X3,Rect.Left) and FLE(X3,Rect.Right)) or
           (FGE(X4,Rect.Left) and FLE(X4,Rect.Right)) or
           (FGE(Y3,Rect.Top) and FLE(Y3,Rect.Bottom)) or
           (FGE(Y4,Rect.Top) and FLE(Y4,Rect.Bottom))) and Parent.CanSelect(self);
        end; { else }
      end; { with }
    end; { if }
  end;  { InSelectRect }

  procedure TRaveLine.CreatePips;

  begin { CreatePips }
    If NESW then begin
      Page.AddPip(0,self,crCross,PageLeft,PageBottom);
      Page.AddPip(1,self,crCross,PageRight,PageTop);
    end else begin
      Page.AddPip(0,self,crCross,PageLeft,PageTop);
      Page.AddPip(1,self,crCross,PageRight,PageBottom);
    end; { else }
  end;  { CreatePips }

  procedure TRaveLine.UpdatePips;

  begin { UpdatePips }
    If NESW then begin
      Page.UpdatePip(0,self,PageLeft,PageBottom);
      Page.UpdatePip(1,self,PageRight,PageTop);
    end else begin
      Page.UpdatePip(0,self,PageLeft,PageTop);
      Page.UpdatePip(1,self,PageRight,PageBottom);
    end; { else }
  end;  { UpdatePips }

  procedure TRaveLine.PipSize(RavePip: TRavePip;
                              X: TRaveUnits;
                              Y: TRaveUnits);

  var
    Temp: TRaveUnits;
    PageRect: TRaveRect;

  begin { PipSize }
    PageRect := BoundsRect;
    If RavePip.Index = 0 then begin
      PageRect.Left := RavePip.OrigRect.Left + X;
      If NESW then begin
        PageRect.Bottom := RavePip.OrigRect.Bottom + Y;
      end else begin
        PageRect.Top := RavePip.OrigRect.Top + Y;
      end; { else }
    end else begin { Index = 1 }
      PageRect.Right := RavePip.OrigRect.Right + X;
      If NESW then begin
        PageRect.Top := RavePip.OrigRect.Top + Y;
      end else begin
        PageRect.Bottom := RavePip.OrigRect.Bottom + Y;
      end; { else }
    end; { else }
    If PageRect.Bottom < PageRect.Top then begin
      NESW := not NESW;
      Temp := PageRect.Bottom;
      PageRect.Bottom := PageRect.Top;
      PageRect.Top := Temp;
      Temp := RavePip.OrigRect.Bottom;
      RavePip.OrigRect.Bottom := RavePip.OrigRect.Top;
      RavePip.OrigRect.Top := Temp;
    end; { if }
    If PageRect.Right < PageRect.Left then begin
      NESW := not NESW;
      Temp := PageRect.Right;
      PageRect.Right := PageRect.Left;
      PageRect.Left := Temp;
      Temp := RavePip.OrigRect.Right;
      RavePip.OrigRect.Right := RavePip.OrigRect.Left;
      RavePip.OrigRect.Left := Temp;
    { Switch pips }
      If RavePip.Index = 1 then begin
        Page.SwitchPips(RavePip,0);
      end else begin
        Page.SwitchPips(RavePip,1);
      end; { else }
    end; { if }
    BoundsRect := PageRect;
    ResizeAll;
  end;  { PipSize }

  procedure TRaveLine.Paint(Canvas: TCanvas);

  var
    PA,PA2: integer;

  begin { Paint }
    With Canvas do begin
      AssignPen(Pen,nil,PA,PA2);
      If NESW then begin
        MoveTo(XI2D(PageLeft),YI2D(PageBottom));
        LineTo(XI2D(PageRight),YI2D(PageTop));
      end else begin
        MoveTo(XI2D(PageLeft),YI2D(PageTop));
        LineTo(XI2D(PageRight),YI2D(PageBottom));
      end; { else }
    end; { with }
  end;  { Paint }
{$ENDIF}

  procedure TRaveLine.Print(Report: TBaseReport);

  var
    PA,PA2: integer;

  begin { Print }
    If not AllowPrint then Exit;
    AssignPen(nil,Report,PA,PA2);
    With Report do begin
      If NESW then begin
        MoveTo(PageLeft,PageBottom);
        LineTo(PageRight,PageTop);
      end else begin
        MoveTo(PageLeft,PageTop);
        LineTo(PageRight,PageBottom);
      end; { else }
    end; { with }
  end;  { Print }

  procedure TRaveLine.SetSize(P1: TRavePoint;
                              P2: TRavePoint);

  var
    P3: TRavePoint;
    PageRect: TRaveRect;

  begin { SetSize }
    ModifyRaveRect(P1,P2);
    If P1.X > P2.X then begin
      P3 := P1;
      P1 := P2;
      P2 := P3;
    end; { if }
    NESW := (P2.Y < P1.Y);
    If P1.Y > P2.Y then begin
      P3.Y := P1.Y;
      P1.Y := P2.Y;
      P2.Y := P3.Y;
    end; { if }
    PageRect.TopLeft := P1;
    PageRect.BottomRight := P2;
    BoundsRect := PageRect;
    ResizeAll;
  end;  { SetSize }

(*****************************************************************************}
( class TRaveHLine
(*****************************************************************************)

{$IFDEF DESIGNER}
  constructor TRaveHLine.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    Width := 1.0;
    Height := 0.0;
  end;  { Create }

  function TRaveHLine.IsSelectPoint(Point: TRavePoint): boolean;

  begin { IsSelectPoint }
    Result := FGE(Point.X,PageLeft) and FLE(Point.X,PageRight) and
     (YI2P(Abs(Point.Y - PageTop)) <= 3) and Parent.CanSelect(self);
  end;  { IsSelectPoint }

  procedure TRaveHLine.PipSize(RavePip: TRavePip;
                               X: TRaveUnits;
                               Y: TRaveUnits);

  var
    Temp: TRaveUnits;
    PageRect: TRaveRect;

  begin { PipSize }
    PageRect := BoundsRect;
    If RavePip.Index = 0 then begin
      PageRect.Left := RavePip.OrigRect.Left + X;
    end else begin { Index = 1 }
      PageRect.Right := RavePip.OrigRect.Right + X;
    end; { else }
    If FLT(PageRect.Right,PageRect.Left) then begin
      Temp := PageRect.Right;
      PageRect.Right := PageRect.Left;
      PageRect.Left := Temp;
      Temp := RavePip.OrigRect.Right;
      RavePip.OrigRect.Right := RavePip.OrigRect.Left;
      RavePip.OrigRect.Left := Temp;
    { Switch pips }
      If RavePip.Index = 1 then begin
        Page.SwitchPips(RavePip,0);
      end else begin
        Page.SwitchPips(RavePip,1);
      end; { else }
    end; { if }
    BoundsRect := PageRect;
    ResizeAll;
  end;  { PipSize }

  class procedure TRaveHLine.ModifyRect(var P1: TPoint;
                                        var P2: TPoint;
                                            PipIndex: byte);

  begin { ModifyRect }
    P2.Y := P1.Y;
  end;  { ModifyRect }
{$ENDIF}

  {$IFNDEF VER93}class{$ENDIF} procedure TRaveHLine.ModifyRaveRect(var P1: TRavePoint;
                                                                   var P2: TRavePoint);

  begin { ModifyRaveRect }
    P2.Y := P1.Y;
  end;  { ModifyRaveRect }

(*****************************************************************************}
( class TRaveVLine
(*****************************************************************************)

{$IFDEF DESIGNER}
  constructor TRaveVLine.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    Width := 0.0;
    Height := 1.0;
  end;  { Create }

  function TRaveVLine.IsSelectPoint(Point: TRavePoint): boolean;

  begin { IsSelectPoint }
    Result := FGE(Point.Y,PageTop) and FLE(Point.Y,PageBottom) and
     (XI2P(Abs(Point.X - PageLeft)) <= 3) and Parent.CanSelect(self);
  end;  { IsSelectPoint }

  procedure TRaveVLine.PipSize(RavePip: TRavePip;
                               X: TRaveUnits;
                               Y: TRaveUnits);

  var
    Temp: TRaveUnits;
    PageRect: TRaveRect;

  begin { PipSize }
    PageRect := BoundsRect;
    If RavePip.Index = 0 then begin
      PageRect.Top := RavePip.OrigRect.Top + Y;
    end else begin { Index = 1 }
      PageRect.Bottom := RavePip.OrigRect.Bottom + Y;
    end; { else }
    If FLT(PageRect.Bottom,PageRect.Top) then begin
      Temp := PageRect.Bottom;
      PageRect.Bottom := PageRect.Top;
      PageRect.Top := Temp;
      Temp := RavePip.OrigRect.Bottom;
      RavePip.OrigRect.Bottom := RavePip.OrigRect.Top;
      RavePip.OrigRect.Top := Temp;
    { Switch pips }
      If RavePip.Index = 1 then begin
        Page.SwitchPips(RavePip,0);
      end else begin
        Page.SwitchPips(RavePip,1);
      end; { else }
    end; { if }
    BoundsRect := PageRect;
    ResizeAll;
  end;  { PipSize }

  class procedure TRaveVLine.ModifyRect(var P1: TPoint;
                                        var P2: TPoint;
                                            PipIndex: byte);

  begin { ModifyRect }
    P2.X := P1.X;
  end;  { ModifyRect }
{$ENDIF}

  {$IFNDEF VER93}class{$ENDIF} procedure TRaveVLine.ModifyRaveRect(var P1: TRavePoint;
                                                                   var P2: TRavePoint);

  begin { ModifyRaveRect }
    P2.X := P1.X;
  end;  { ModifyRaveRect }

(*****************************************************************************}
( class TRaveSurface
(*****************************************************************************)

  constructor TRaveSurface.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    FillBrush := TBrush.Create;
    BorderColor := clBlack;
    FillColor := clWhite;
  end;  { Create }

  destructor TRaveSurface.Destroy;

  begin { Destroy }
    FillBrush.Free;
    inherited Destroy;
  end;  { Destroy }

  procedure TRaveSurface.SetBackColor(Value: TColor);

  begin { SetBackColor }
    FillBrush.Color := Value;
    Invalidate;
  end;  { SetBackColor }

  function TRaveSurface.GetBackColor: TColor;

  begin { GetBackColor }
    Result := FillBrush.Color;
  end;  { GetBackColor }

  procedure TRaveSurface.SetFillStyle(Value: TRaveFillStyle);

  begin { SetFillStyle }
    FillBrush.Style := TBrushStyle(Value);
    Invalidate;
  end;  { SetFillStyle }

  function TRaveSurface.GetFillStyle: TRaveFillStyle;

  begin { GetFillStyle }
    Result := TRaveFillStyle(FillBrush.Style);
  end;  { GetFillStyle }

(*****************************************************************************}
( class TRaveRectangle
(*****************************************************************************)

{$IFDEF DESIGNER}
  constructor TRaveRectangle.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    BoundsRect := RaveRect(0.0,0.0,2.0,1.0);
  end;  { Create }

  procedure TRaveRectangle.Paint(Canvas: TCanvas);

  var
    PA,PA2: integer;

  begin { Paint }
    With Canvas do begin
      AssignPen(Pen,nil,PA,PA2);
      Brush.Assign(FillBrush);
      If (HRadius <> 0) and (VRadius <> 0) then begin
        RoundRect(XI2D(PageLeft) + PA,YI2D(PageTop) + PA,
         XI2D(PageRight) - PA2 + 2,YI2D(PageBottom) - PA2 + 2,
         XI2P(HRadius) * 2,YI2P(VRadius) * 2);
      end else begin
        Rectangle(XI2D(PageLeft) + PA,YI2D(PageTop) + PA,
         XI2D(PageRight) - PA2 + 2,YI2D(PageBottom) - PA2 + 2);
      end; { else }
    end; { with }
  end;  { Paint }
{$ENDIF}

  procedure TRaveRectangle.SetHRadius(Value: TRaveUnits);

  begin { SetHRadius }
    FHRadius := Value;
    Invalidate;
  end;  { SetHRadius }

  procedure TRaveRectangle.SetVRadius(Value: TRaveUnits);

  begin { SetVRadius }
    FVRadius := Value;
    Invalidate;
  end;  { SetVRadius }

  procedure TRaveRectangle.Print(Report: TBaseReport);

  var
    PA,PA2: integer;

  begin { Print }
    If not AllowPrint then Exit;
    AssignPen(nil,Report,PA,PA2);
    With Report do begin
      Canvas.Brush.Assign(FillBrush);
      If (HRadius <> 0) and (VRadius <> 0) then begin
        RoundRect(PageLeft,PageTop,PageRight,PageBottom,HRadius * 2,VRadius * 2);
      end else begin
        Rectangle(PageLeft,PageTop,PageRight,PageBottom);
      end; { else }
    end; { with }
  end;  { Print }

(*****************************************************************************}
( class TRaveSquare
(*****************************************************************************)

{$IFDEF DESIGNER}
  constructor TRaveSquare.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    BoundsRect := RaveRect(0.0,0.0,1.0,1.0);
  end;  { Create }

  class procedure TRaveSquare.ModifyRect(var P1: TPoint;
                                         var P2: TPoint;
                                             PipIndex: byte);

  var
    W,H: integer;

  begin { ModifyRect }
    W := P2.X - P1.X;
    H := P2.Y - P1.Y;
    If W < H then begin
      P2.Y := P1.Y + W;
    end else begin
      P2.X := P1.X + H;
    end; { else }
  end;  { ModifyRect }

  procedure TRaveSquare.CreatePips;

  var
    X1: TRaveUnits;
    Y1: TRaveUnits;
    W: TRaveUnits;
    H: TRaveUnits;

  begin { CreatePips }
    X1 := PageLeft;
    Y1 := PageTop;
    W := Width;
    H := Height;
    Page.AddPip(0,self,crSizeNWSE,X1,Y1);
    Page.AddPip(2,self,crSizeNESW,X1 + W,Y1);
    Page.AddPip(5,self,crSizeNESW,X1,Y1 + H);
    Page.AddPip(7,self,crSizeNWSE,X1 + W,Y1 + H);
  end;  { CreatePips }

  procedure TRaveSquare.UpdatePips;

  var
    X1: TRaveUnits;
    Y1: TRaveUnits;
    W: TRaveUnits;
    H: TRaveUnits;

  begin { UpdatePips }
    X1 := PageLeft;
    Y1 := PageTop;
    W := Width;
    H := Height;
    Page.UpdatePip(0,self,X1,Y1);
    Page.UpdatePip(2,self,X1 + W,Y1);
    Page.UpdatePip(5,self,X1,Y1 + H);
    Page.UpdatePip(7,self,X1 + W,Y1 + H);
  end;  { UpdatePips }
{$ENDIF}

  {$IFNDEF VER93}class{$ENDIF} procedure TRaveSquare.ModifyRaveRect(var P1: TRavePoint;
                                                                    var P2: TRavePoint);

  var
    W,H: TRaveUnits;

  begin { ModifyRaveRect }
    W := P2.X - P1.X;
    H := P2.Y - P1.Y;
    If Abs(W) < Abs(H) then begin
      If Abs(H) <> 0 then begin
        P2.Y := P1.Y + Abs(W) * (H / Abs(H));
      end; { if }
    end else begin
      If Abs(W) <> 0 then begin
        P2.X := P1.X + Abs(H) * (W / Abs(W));
      end; { if }
    end; { else }
  end;  { ModifyRaveRect }

(*****************************************************************************}
( class TRaveEllipse
(*****************************************************************************)

{$IFDEF DESIGNER}
  constructor TRaveEllipse.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    BoundsRect := RaveRect(0.0,0.0,2.0,1.0);
  end;  { Create }

  procedure TRaveEllipse.Paint(Canvas: TCanvas);

  var
    PA,PA2: integer;

  begin { Paint }
    With Canvas do begin
      AssignPen(Pen,nil,PA,PA2);
      Brush.Assign(FillBrush);
      Ellipse(XI2D(PageLeft) + PA,YI2D(PageTop) + PA,XI2D(PageRight) - PA2 + 2,
       YI2D(PageBottom) - PA2 + 2);
    end; { with }
  end;  { Paint }
{$ENDIF}

  procedure TRaveEllipse.Print(Report: TBaseReport);

  var
    PA,PA2: integer;

  begin { Print }
    If not AllowPrint then Exit;
    AssignPen(nil,Report,PA,PA2);
    With Report do begin
      Canvas.Brush.Assign(FillBrush);
      Ellipse(PageLeft,PageTop,PageRight,PageBottom);
    end; { with }
  end;  { Print }

(*****************************************************************************}
( class TRaveCircle
(*****************************************************************************)

{$IFDEF DESIGNER}
  constructor TRaveCircle.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    BoundsRect := RaveRect(0.0,0.0,1.0,1.0);
  end;  { Create }

  class procedure TRaveCircle.ModifyRect(var P1: TPoint;
                                         var P2: TPoint;
                                             PipIndex: byte);

  var
    W,H: integer;

  begin { ModifyRect }
    W := (P2.X - P1.X);
    H := (P2.Y - P1.Y);
    If W < H then begin
      P2.Y := P1.Y + W;
    end else begin
      P2.X := P1.X + H;
    end; { else }
  end;  { ModifyRect }

  procedure TRaveCircle.CreatePips;

  var
    X1: TRaveUnits;
    Y1: TRaveUnits;
    W: TRaveUnits;
    H: TRaveUnits;

  begin { CreatePips }
    X1 := PageLeft;
    Y1 := PageTop;
    W := Width;
    H := Height;
    Page.AddPip(0,self,crSizeNWSE,X1,Y1);
    Page.AddPip(2,self,crSizeNESW,X1 + W,Y1);
    Page.AddPip(5,self,crSizeNESW,X1,Y1 + H);
    Page.AddPip(7,self,crSizeNWSE,X1 + W,Y1 + H);
  end;  { CreatePips }

  procedure TRaveCircle.UpdatePips;

  var
    X1: TRaveUnits;
    Y1: TRaveUnits;
    W: TRaveUnits;
    H: TRaveUnits;

  begin { UpdatePips }
    X1 := PageLeft;
    Y1 := PageTop;
    W := Width;
    H := Height;
    Page.UpdatePip(0,self,X1,Y1);
    Page.UpdatePip(2,self,X1 + W,Y1);
    Page.UpdatePip(5,self,X1,Y1 + H);
    Page.UpdatePip(7,self,X1 + W,Y1 + H);
  end;  { UpdatePips }
{$ENDIF}

  {$IFNDEF VER93}class{$ENDIF} procedure TRaveCircle.ModifyRaveRect(var P1: TRavePoint;
                                                                    var P2: TRavePoint);

  var
    W,H: TRaveUnits;

  begin { ModifyRaveRect }
    W := P2.X - P1.X;
    H := P2.Y - P1.Y;
    If Abs(W) < Abs(H) then begin
      If Abs(H) <> 0 then begin
        P2.Y := P1.Y + Abs(W) * (H / Abs(H));
      end; { if }
    end else begin
      If Abs(W) <> 0 then begin
        P2.X := P1.X + Abs(H) * (W / Abs(W));
      end; { if }
    end; { else }
  end;  { ModifyRaveRect }

initialization
  RegisterProc('RVCL',RaveRegister);
end.
