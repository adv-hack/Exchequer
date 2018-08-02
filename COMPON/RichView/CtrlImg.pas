
{*******************************************************}
{                                                       }
{       RichView                                        }
{       DrawControl - function creating a bitmap and    }
{       drawing the given control into it.              }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}


unit CtrlImg;

interface

{$I RV_Defs.inc}

uses Windows, Messages, Classes, Controls, StdCtrls, Graphics, Forms, SysUtils,
     ExtCtrls;

function DrawButton(ctrl: TButton): TBitmap;
function DrawEdit(ctrl: TEdit): TBitmap;
function DrawMemo(ctrl: TMemo): TBitmap;
function DrawPanel(ctrl: TPanel): TBitmap;
function DrawGraphicControl(ctrl: TGraphicControl): TBitmap;
function DrawControl(ctrl: TControl): TBitmap;

implementation
{------------------------------------------------------------------}
procedure ForceHandle(aControl:TWinControl);
var i : integer;
begin
  TWinControl(aControl).Handle;
  for i := 0 to aControl.ControlCount-1 do
   if aControl.Controls[i] is TWinControl then
     ForceHandle(TWinControl(aControl.Controls[i]));
end;
{------------------------------------------------------------------}
function AllocBmp(ctrl: TControl): TBitmap;
begin
  Result        := TBitmap.Create;
  Result.Width  := ctrl.Width;
  Result.Height := ctrl.Height;
end;
{------------------------------------------------------------------}
procedure DrawButton_(ctrl: TButton; Canvas: TCanvas; X,Y: Integer);
var r: TRect;
begin
  r := Bounds(X,Y,ctrl.Width,ctrl.Height);
  with Canvas do begin
    DrawFrameControl(Handle, r, DFC_BUTTON, DFCS_BUTTONPUSH);
    Font := ctrl.Font;
    Brush.Style := bsClear;
    DrawText(Handle, PChar(ctrl.Caption),-1,
             r, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
  end;
end;
{------------------------------------------------------------------}
function DrawButton(ctrl: TButton): TBitmap;
begin
  Result := AllocBmp(ctrl);
  DrawButton_(ctrl, Result.Canvas, 0,0);
end;
{------------------------------------------------------------------}
procedure DrawEditBack(Canvas: TCanvas; var r: TRect; Color: TColor;
                       Ctl3D, Border: Boolean);
begin
  with Canvas do begin
    Brush.Color := Color;
    FillRect(r);
    if Border then
      if Ctl3D then
        DrawEdge(Handle, r, EDGE_SUNKEN, BF_RECT or BF_ADJUST)
      else
        begin
          with r do Rectangle(Left,Top,Right,Bottom);
          InflateRect(r,-1,-1);
        end;
    InflateRect(r,-1,-1);
  end;
end;
{------------------------------------------------------------------}
procedure DrawEdit_(ctrl: TEdit; Canvas: TCanvas; X,Y: Integer);
var r: TRect;
begin
  r := Bounds(X,Y,ctrl.Width,ctrl.Height);
  with Canvas do begin
    DrawEditBack(Canvas, r, ctrl.Color, ctrl.Ctl3D,
                 ctrl.BorderStyle = bsSingle);
    Font := ctrl.Font;
    DrawText(Handle, PChar(ctrl.Text),-1,
             r, DT_LEFT or DT_SINGLELINE or DT_EDITCONTROL);
  end;
end;
{------------------------------------------------------------------}
type
  TGraphicControlHack=class(TGraphicControl)
  end;

procedure DrawGraphicControl_(ctrl: TGraphicControl; Canvas: TCanvas; X, Y: Integer);
var SaveIndex: Integer;
begin
  SaveIndex := SaveDC(Canvas.Handle);
  ctrl.ControlState := ctrl.ControlState+[csPaintCopy];
  try
    MoveWindowOrg(Canvas.Handle, X, Y);
    IntersectClipRect(Canvas.Handle, 0, 0, ctrl.Width, ctrl.Height);
    ctrl.Perform(WM_PAINT, Canvas.Handle, 0);
  finally
    ctrl.ControlState := ctrl.ControlState-[csPaintCopy];  
    RestoreDC(Canvas.Handle, SaveIndex);
  end;
end;
{------------------------------------------------------------------}
function DrawEdit(ctrl: TEdit): TBitmap;
begin
  Result := AllocBmp(ctrl);
  DrawEdit_(ctrl, Result.Canvas, 0,0);
end;
{------------------------------------------------------------------}
procedure DrawMemo_(ctrl: TMemo; Canvas: TCanvas; X,Y: Integer);
var r: TRect;
    flag: Integer;
begin
  r := Bounds(X,Y,ctrl.Width,ctrl.Height);
  with Canvas do begin
    DrawEditBack(Canvas, r, ctrl.Color, ctrl.Ctl3D,
                 ctrl.BorderStyle = bsSingle);
    Font := ctrl.Font;
    case ctrl.Alignment of
      taRightJustify:
        flag := DT_RIGHT;
      taCenter:
        flag := DT_CENTER;
      else
        flag := DT_LEFT;
    end;
    DrawText(Handle, PChar(ctrl.Text),-1,
             r, flag or DT_EDITCONTROL);
  end;
end;
{------------------------------------------------------------------}
function DrawMemo(ctrl: TMemo): TBitmap;
begin
  Result := AllocBmp(ctrl);
  DrawMemo_(ctrl, Result.Canvas, 0, 0);
end;
{------------------------------------------------------------------}
function DrawGraphicControl(ctrl: TGraphicControl): TBitmap;
begin
  Result := AllocBmp(ctrl);
  DrawGraphicControl_(ctrl, Result.Canvas, 0, 0);
end;
{------------------------------------------------------------------}
procedure DrawPanel_(ctrl: TPanel; Canvas: TCanvas; X,Y: Integer);forward;
procedure DrawControl_(ctrl: TControl; Canvas: TCanvas; X,Y: Integer);
begin
  if ctrl is TButton then
    DrawButton_(TButton(ctrl), Canvas, X, Y)
  else if ctrl is TEdit then
    DrawEdit_(TEdit(ctrl), Canvas, X, Y)
  else if ctrl is TMemo then
    DrawMemo_(TMemo(ctrl), Canvas, X, Y)
  else if ctrl is TPanel then
    DrawPanel_(TPanel(ctrl), Canvas, X, Y)
  else if ctrl is TGraphicControl then
    DrawGraphicControl_(TGraphicControl(ctrl), Canvas, X, Y)
  else if ctrl is TWinControl then begin
    ForceHandle(TWinControl(ctrl));
    Canvas.Lock;
    try
      TWinControl(ctrl).PaintTo(Canvas.Handle, X, Y);
    finally
      Canvas.Unlock;
    end;
  end;
end;
{------------------------------------------------------------------}
procedure DrawPanel_(ctrl: TPanel; Canvas: TCanvas; X,Y: Integer);
var i: Integer;
begin
  ctrl.PaintTo(Canvas.Handle, X,Y);

  for i := 0 to Ctrl.ControlCount-1 do
    if not (Ctrl.Controls[i] is TGraphicControl) then
      DrawControl_(Ctrl.Controls[i], Canvas, X+Ctrl.Controls[i].Left,Y+Ctrl.Controls[i].Top);

end;
{------------------------------------------------------------------}
function DrawPanel(ctrl: TPanel): TBitmap;
begin
  Result := AllocBmp(ctrl);
  DrawPanel_(ctrl, Result.Canvas, 0,0);
end;
{------------------------------------------------------------------}
function DrawControl(ctrl: TControl): TBitmap;
begin
  Result := AllocBmp(ctrl);
  DrawControl_(ctrl, Result.Canvas,0,0);
end;
{------------------------------------------------------------------}

end.
