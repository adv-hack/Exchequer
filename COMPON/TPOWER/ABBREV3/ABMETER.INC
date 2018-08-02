{*********************************************************}
{* ABBREVIA: AbMeter.inc 3.02                            *}
{* Copyright (c) TurboPower Software Co 1997, 2002       *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA: Progress meter (Source)                     *}
{*   See AbMeter.pas for the VCL header                  *}
{*   See AbQMeter.pas for the CLX header                 *}
{*********************************************************}

{$I AbDefine.inc}

interface

uses
  Classes,
  {$IFDEF MSWINDOWS}
  Windows, 
  {$ENDIF}
  {$IFDEF LINUX}
  Libc, Types,
  {$ENDIF}

  {$IFDEF UsingCLX }
  QControls, QGraphics, QForms, QExtCtrls,
  {$ELSE}
  Controls, Graphics, Forms, ExtCtrls,
  {$ENDIF}
  SysUtils,
  AbBrowse;

type
  TAbMeterOrientation = (moHorizontal, moVertical);

  TAbCustomMeter = class; // forward declaration

  {$IFDEF UsingCLX }
  TAbCLXMeterLink = class(TAbMeterLink)
  {$ELSE}
  TAbVCLMeterLink = class(TAbMeterLink)
  {$ENDIF}
    private
      FMeter : TAbCustomMeter;
    protected
    public
      procedure DoProgress(Progress : Byte); override;
      procedure Reset; override;
    published
      property Meter : TAbCustomMeter read FMeter write FMeter;
  end;

  TAbCustomMeter = class(TGraphicControl)
  {.Z+}
  protected {private}
    {property variables}
    FBorderStyle   : TBorderStyle;
    FCtl3D         : Boolean;
    FOrientation   : TAbMeterOrientation;
    FPercent       : Integer;
    FUsedColor     : TColor;
    FUnusedColor   : TColor;

    {internal methods}
    function  GetVersion : string;
    procedure Paint;
      override;
    procedure SetBorderStyle(const Value : TBorderStyle);
    procedure SetCtl3D(const Value : Boolean);
    procedure SetOrientation(const O : TAbMeterOrientation);
    procedure SetUnusedColor(const C : TColor);
    procedure SetUsedColor(const C : TColor);
    procedure SetVersion(Value : string);
    property Version : string
      read  GetVersion write SetVersion stored False;

  {.Z-}
  public {methods}
    constructor Create(AOwner : TComponent);
      override;
    procedure DoProgress(Progress : Byte);
    procedure Reset;

  public {properties}
    property BorderStyle : TBorderStyle
      read FBorderStyle write SetBorderStyle default bsSingle;
    property Ctl3D : Boolean
      read FCtl3D write SetCtl3D default True;
    property Orientation : TAbMeterOrientation
      read FOrientation write SetOrientation;
    property UnusedColor : TColor
      read FUnusedColor write SetUnusedColor;
    property UsedColor : TColor
      read FUsedColor write SetUsedColor;
  end;

  TAbMeter = class(TAbCustomMeter)
  published
    {$IFDEF VERSION4}
    property Anchors;
    property Constraints;
    {$ENDIF}
    property Align;
    property BorderStyle;
    property Ctl3D;
    property Font;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property Orientation;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property UnusedColor;
    property UsedColor;
    property Version;
    property Visible;
  end;
  {.Z+}


implementation

uses
  {$IFDEF TrialRun}
  AbTrial,
  {$ENDIF}
  AbConst;

{====================================================================}
{$IFDEF UsingCLX }
procedure TAbCLXMeterLink.DoProgress(Progress : Byte);
{$ELSE}
procedure TAbVCLMeterLink.DoProgress(Progress : Byte);
{$ENDIF}
begin
  if Assigned(FMeter) then
    FMeter.DoProgress(Progress);
end;
{--------}
{$IFDEF UsingCLX }
procedure TAbCLXMeterLink.Reset;
{$ELSE}
procedure TAbVCLMeterLink.Reset;
{$ENDIF}
begin
  if Assigned(FMeter) then
    FMeter.Reset;
end;
{====================================================================}


{ == TAbCustomMeter ======================================================== }
constructor TAbCustomMeter.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF TrialRun}
  _TR2_;
  {$ENDIF}
  {$IFNDEF UsingCLX}
  if NewStyleControls then
    ControlStyle := ControlStyle + [csOpaque]
  else
    ControlStyle := ControlStyle + [csOpaque, csFramed];
  {$ELSE}
    ControlStyle := ControlStyle + [csOpaque, csFramed];
  {$ENDIF}

  FBorderStyle := bsSingle;
  FCtl3D       := True;
  FOrientation := moHorizontal;
  FUnusedColor := clBtnFace;
  FUsedColor   := clNavy;
  Width        := 150;
  Height       := 16;
end;
{ -------------------------------------------------------------------------- }
function TAbCustomMeter.GetVersion : string;
begin
  Result := AbVersion;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomMeter.DoProgress(Progress : Byte);
begin
  if (Progress <> FPercent) then begin
    FPercent := Progress;
    if (FPercent >= 100) then
      FPercent := 0;
    Refresh;
    Application.ProcessMessages;
  end;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomMeter.Paint;
const
  VSpace = 2;
  HSpace = 1;
  LSpace = 1;
  RSpace = 1;
var
  ClRect, R  : TRect;
  ClWidth    : Integer;
  ClHeight   : Integer;
  BlockWidth : Integer;
  BlockCount : Integer;
  i : Integer;
begin
  ClRect := ClientRect;

  ClWidth := ClRect.Right - CLRect.Left + 1;
  ClHeight := ClRect.Bottom - ClRect.Top + 1;

  if (Orientation = moHorizontal) then
    BlockWidth := ((ClWidth - LSpace - RSpace - (9 * VSpace)) div 10) + 1
  else
    BlockWidth := ((ClHeight - LSpace - RSpace - (9 * HSpace)) div 10) + 1;
  BlockCount  := FPercent div 10;

  with Canvas do begin
    Brush.Color := FUnusedColor;
    FillRect(Rect(ClRect.Left, ClRect.Top, ClRect.Left + ClWidth - 1,
      ClRect.Top + ClHeight - 1));
    Brush.Color := FUsedColor;
    if (BlockCount > 0) then begin
      if (Orientation = moHorizontal) then begin
        R.Top := ClRect.Top + HSpace;
        R.Bottom := ClRect.Bottom - HSpace;
        for i := 0 to Pred(BlockCount) do begin
          R.Left := ClRect.Left + LSpace + (i * VSpace) +
            (i * BlockWidth);
          R.Right := R.Left + BlockWidth;
          FillRect(R);
        end;
      end else begin {moVertical}
        R.Left := ClRect.Left + VSpace;
        R.Right := ClRect.Right - VSpace;
        for i := 0 to Pred(BlockCount) do begin
          R.Bottom := ClRect.Bottom - LSpace - (i * HSpace) -
            (i * BlockWidth);
          R.Top := R.Bottom - BlockWidth;
          FillRect(R);
        end;
      end;
    end;
  end;
  if (BorderStyle <> bsNone) then begin
    if Ctl3D then
      Frame3D(Canvas, ClRect, clBtnShadow, clBtnHighlight, 1)
    else
      Frame3D(Canvas, ClRect, clBlack, clBlack, 1);
  end;

end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomMeter.Reset;
begin
  DoProgress(0);
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomMeter.SetBorderStyle(const Value : TBorderStyle);
begin
  if (Value <> FBorderStyle) then begin
    FBorderStyle := Value;
    Invalidate;
  end;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomMeter.SetCtl3D(const Value : Boolean);
begin
  if (Value <> FCtl3D) then begin
    FCtl3D := Value;
    Invalidate;
  end;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomMeter.SetOrientation(const O : TAbMeterOrientation);
var
  Temp : Integer;
begin
  if (O <> FOrientation) then begin
    FOrientation := O;
    if not (csLoading in ComponentState) then begin
      Temp := Width;
      Width := Height;
      Height := Temp;
    end;
    Invalidate;
  end;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomMeter.SetUnusedColor(const C : TColor);
begin
  if (C <> FUnusedColor) then begin
    FUnusedColor := C;
    Invalidate;
  end;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomMeter.SetUsedColor(const C : TColor);
begin
  if (C <> FUsedColor) then begin
    FUsedColor := C;
    Invalidate;
  end;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomMeter.SetVersion(Value : string);
begin
  {NOP}
end;

end.
