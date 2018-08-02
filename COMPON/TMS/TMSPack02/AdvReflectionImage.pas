{***************************************************************************}
{ TAdvReflectionImage component                                             }
{ for Delphi & C++Builder                                                   }
{ version 1.0                                                               }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2007                                               }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of the author.                                      }
{***************************************************************************}

unit AdvReflectionImage;

{$I TMSDEFS.INC}

interface

uses
  Classes, Windows, Forms, Dialogs, Controls, Graphics, Messages, ExtCtrls,
  SysUtils, GDIPicture, AdvHintInfo, AdvGDIP;

const

  MAJ_VER = 1; // Major version nr.
  MIN_VER = 0; // Minor version nr.
  REL_VER = 0; // Release nr.
  BLD_VER = 1; // Build nr.
  
  // version history
  // v1.0.0.0 : first release
  // v1.0.0.1 : Fixed : issue with OnClick event


type
  TAdvReflectionImage = class(TGraphicControl)
  private
    FMouseInControl: Boolean;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOfficeHint: TAdvHintInfo;
    FIPicture: TGDIPPicture;
    FReflectionPic: TGPBitmap;
    FReflection: Integer;
    FReflectionAxis: Integer;
    procedure OnPictureChanged(Sender: TObject);
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    function GetVersion: string;
    procedure SetVersion(const Value: string);
    procedure SetOfficeHint(const Value: TAdvHintInfo);
    procedure SetIPicture(const Value: TGDIPPicture);
    procedure SetReflection(const Value: Integer);
    procedure SetReflectionAxis(const Value: Integer);
  protected
    procedure DrawImage(ACanvas: TCanvas); virtual;
    procedure Paint; override;
    procedure Loaded; override;
    procedure UpdateReflection;
    property MouseInControl: Boolean read FMouseInControl;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetVersionNr: Integer; virtual;
  published
    property Anchors;
    property BiDiMode;
    property Constraints;
    property Picture: TGDIPPicture read FIPicture write SetIPicture;
    property PopupMenu;
    property ShowHint;
    property OfficeHint: TAdvHintInfo read FOfficeHint write SetOfficeHint;
    property Reflection: Integer read FReflection write SetReflection default 160;
    property ReflectionAxis: Integer read FReflectionAxis write SetReflectionAxis default 1;
    property Version: string read GetVersion write SetVersion;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  end;


implementation

uses
  ActiveX;
//------------------------------------------------------------------------------

{ TAdvReflectionImage }

constructor TAdvReflectionImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIPicture := TGDIPPicture.Create;
  FIPicture.OnChange := OnPictureChanged;

  ControlStyle := [csCaptureMouse, csClickEvents, csDoubleClicks];

  FOfficeHint := TAdvHintInfo.Create;

  ShowHint := False;
  Width := 32;
  Height := 32;
  FReflectionPic := nil;
  FReflection := 160;
  FReflectionAxis := 1;
end;

//------------------------------------------------------------------------------

destructor TAdvReflectionImage.Destroy;
begin
  FIPicture.Free;
  FOfficeHint.Free;
  if Assigned(FReflectionPic) then
    FReflectionPic.Free;
  inherited;
end;

//------------------------------------------------------------------------------

procedure TAdvReflectionImage.CMMouseEnter(var Message: TMessage);
begin
  inherited;

  if (csDesigning in ComponentState) then
    Exit;

  FMouseInControl := true;

  if Assigned(FOnMouseEnter) then
     FOnMouseEnter(Self);
end;

//------------------------------------------------------------------------------

procedure TAdvReflectionImage.CMMouseLeave(var Message: TMessage);
begin
  inherited;

  if (csDesigning in ComponentState) then
    Exit;

  FMouseInControl := false;

  if Assigned(FOnMouseLeave) then
     FOnMouseLeave(Self);
end;

//------------------------------------------------------------------------------

procedure TAdvReflectionImage.Paint;
begin
  inherited;
  DrawImage(Canvas);
end;

//------------------------------------------------------------------------------

procedure TAdvReflectionImage.DrawImage(ACanvas: TCanvas);
var
  Pic: TGDIPPicture;
  x, y: Integer;
  graphics : TGPGraphics;
begin
  Pic := Picture;

  if Assigned(Pic) and not Pic.Empty then
  begin
    Pic.GetImageSizes;
    //x := (Width - Pic.Width) div 2;
    //y := (Height - Pic.Height) div 2;
    if Assigned(FReflectionPic) then
    begin
      x := 0;
      y := Picture.Height;
      graphics := TGPgraphics.Create(Canvas.Handle);
      graphics.DrawImageRect(FReflectionPic, x, y + FReflectionAxis, Pic.Width, Pic.Height);
      graphics.Free;
    end;
    x := 0;
    y := 0;
    ACanvas.Draw(x, y, Pic);
  end
  else
  begin
    ACanvas.Pen.Style := psDot;
    ACanvas.Pen.Color := clBlue;
    ACanvas.Brush.Style := bsClear;
    ACanvas.Rectangle(ClientRect);
  end;
end;

//------------------------------------------------------------------------------

procedure TAdvReflectionImage.UpdateReflection;
var
  gpbmp: TGPBitmap;
  pstm: IStream;
  hGlobal: THandle;
  pcbWrite: Longint;
  ms: TMemoryStream;
  w, h, x, y, op, alph: integer;
  clr, clrTemp: TGPColor;
  a: byte;
begin
  if Picture.Empty or (csLoading in ComponentState) then
    Exit;

  Picture.GetImageSizes;
  w := Picture.Width;
  h := Picture.Height;

  ms := TMemoryStream.Create;
  Picture.SaveToStream(ms);
  hGlobal := GlobalAlloc(GMEM_MOVEABLE, ms.Size);
  if (hGlobal = 0) then
  begin
    ms.Free;
    raise Exception.Create('Could not allocate memory for reflection image');
  end;

  try
    pstm := nil;

    // Create IStream* from global memory
    CreateStreamOnHGlobal(hGlobal, TRUE, pstm);
    pstm.Write(ms.Memory, ms.Size,@pcbWrite);
    gpbmp := TGPBitmap.Create(pstm);
    gpbmp.RotateFlip(RotateNoneFlipY);

    if Assigned(FReflectionPic) then
    begin
      FReflectionPic.Free;
      FReflectionPic := nil;
    end;
    FReflectionPic := TGPBitmap.Create(w, h{, PixelFormat32bppARGB});

    for y := 0 to h do
    begin
      op := Round((255.0 / h) * (h - y)) - FReflection;

      if (op < 0) then
        op := 0;
      if (op > 255) then
        op := 255;

      for x := 0 to w do
      begin
        gpbmp.GetPixel(x, y, clr);
        a := GetAlpha(clr);
        if (a = 0) then
          continue;

        alph := Round((op / 255) * a);
        clrTemp := MakeColor(alph, GetRed(clr), GetGreen(clr), GetBlue(clr));
        FRefLectionPic.SetPixel(x, y, clrTemp);
      end;
    end;
    gpbmp.Free;
    ms.Free;
  finally
    GlobalFree(hGlobal);
  end;  
end;

//------------------------------------------------------------------------------

function TAdvReflectionImage.GetVersionNr: integer;
begin
  Result := MakeLong(MakeWord(BLD_VER,REL_VER),MakeWord(MIN_VER,MAJ_VER));
end;

//------------------------------------------------------------------------------

function TAdvReflectionImage.GetVersion: string;
var
  vn: Integer;
begin
  vn := GetVersionNr;
  Result := IntToStr(Hi(Hiword(vn)))+'.'+IntToStr(Lo(Hiword(vn)))+'.'+IntToStr(Hi(Loword(vn)))+'.'+IntToStr(Lo(Loword(vn)));
end;

//------------------------------------------------------------------------------

procedure TAdvReflectionImage.SetVersion(const Value: string);
begin

end;

//------------------------------------------------------------------------------

procedure TAdvReflectionImage.SetOfficeHint(const Value: TAdvHintInfo);
begin
  FOfficeHint.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TAdvReflectionImage.SetIPicture(const Value: TGDIPPicture);
begin
  FIPicture.Assign(Value);
  Invalidate;
end;

//------------------------------------------------------------------------------

procedure TAdvReflectionImage.OnPictureChanged(Sender: TObject);
begin
  UpdateReflection;
  Invalidate;
end;

//------------------------------------------------------------------------------

procedure TAdvReflectionImage.Loaded;
begin
  inherited;
  UpdateReflection;
end;

//------------------------------------------------------------------------------

procedure TAdvReflectionImage.SetReflection(const Value: Integer);
begin
  if (FReflection <> Value) then
  begin
    FReflection := Value;
    UpdateReflection;
    Invalidate;
  end;
end;

//------------------------------------------------------------------------------

procedure TAdvReflectionImage.SetReflectionAxis(const Value: Integer);
begin
  if (FReflectionAxis <> Value) then
  begin
    FReflectionAxis := Value;
    Invalidate;
  end;
end;

//------------------------------------------------------------------------------

procedure TAdvReflectionImage.WMSize(var Message: TWMSize);
begin
  inherited;
end;

//------------------------------------------------------------------------------

end.
