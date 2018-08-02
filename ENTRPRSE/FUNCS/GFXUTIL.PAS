unit GfxUtil;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  SysUtils, Messages, Windows, ExtCtrls, Forms, graphics, Classes, JPeg;

type
  TColorMode = (cm64Bit, cm32Bit, cm24Bit, cm16Bit, cm256Colors, cm16Colors, cmMonochrome, cmUnknown);

  procedure DrawFormBackground(TheForm : TForm; bitBackground : TBitmap);
  function ColorMode(TheCanvas : TCanvas) : TColorMode;
  function LoadJPEGFromRes(sJPEGName : ANSIstring; JPEGImage : TJPEGImage) : boolean;
  function DarkenColor(Col: TColor; Percent: Byte): TColor;
  function LightenColor(Col: TColor; Percent: Byte): TColor;
  function ColorToStr(AColor : TColor) : AnsiString;
  procedure DrawVertLine(LineColour: TColor; LineLeft: integer; LineTop: integer; LineBottom: integer; ACanvas : TCanvas);
  procedure DrawHorizLine(LineColour: TColor; LineTop: integer; LineLeft: integer; LineRight: integer; ACanvas : TCanvas = nil);
  procedure DrawFilledRect(FillColour: TColor; iLeft, iTop, iRight, iBottom : integer; ACanvas : TCanvas);

  //PR: 10/09/2012 Adapted Chris's code for copying bitmap to bottom left of screen (EParentU.pas) for use by other forms.
  procedure DrawBitmapAtBottomLeft(ADC : HDC; const AForm : TForm; const ABitmap : TBitmap; TbAndStatBarHeight : Integer);

implementation

Procedure ValidateRGBValue(var RGorB : LongInt);
begin
  if (RGorB < 0) then
  begin
    RGorB := 0;
  end else
  begin
    if (RGorB > 255) then
    begin
      RGorB := 255;
    end;{if}
  end;{if}
end;

procedure DrawFormBackground(TheForm : TForm; bitBackground : TBitmap);
var
  DummyMessage  :  TMessage;
  MyDC       : hDC;
  OldPalette : HPalette;
  bitMain : TBitmap;
  ScrnTileRect, ARect, BRect : TRect;
  iVert, iHoriz : integer;
  BackgroundImage : TImage;
begin

  if Assigned(bitBackground) then begin

    {create temporary bitmap}
    bitMain := TBitmap.Create;

    {copy palette from loaded bitmap}
    DeleteObject(bitMain.Palette);
    bitMain.Palette := CopyPalette(bitBackground.Palette);

    {assigns the correct dimensions to the temporary bitmap (to fit the current screen)}
    bitMain.Width := TheForm.ClientWidth;
    bitMain.Height := TheForm.ClientHeight {- StatusBar.Height - Coolbar1.height};

    {tile / centre bitmap}
    if (bitMain.Width > bitBackground.Width) or (bitMain.Height > bitBackground.Height) then
      begin
        {tiles the whole bitmap from the top left corner}
        ARect := Rect(0, 0, bitBackground.Width, bitBackground.Height);
        For iHoriz := 0 to (bitMain.Width DIV bitBackground.Width) do begin
          For iVert := 0 to (bitMain.Height DIV bitBackground.Height) do begin
            ScrnTileRect := Rect(iHoriz * bitBackground.Width, iVert * bitBackground.Height
            , ((iHoriz + 1) * bitBackground.Width), (iVert + 1) * bitBackground.Height);
            bitMain.Canvas.CopyRect(ScrnTileRect,bitBackground.Canvas, ARect);
          end;{for}
        end;{for}
      end
    else begin
      {copys the correct chunk of the background bitmap into the centre of the temporary bitmap}
      ARect := Rect(0, 0, bitMain.Width, bitMain.Height);
      BRect := Rect((bitBackground.Width - TheForm.ClientWidth) DIV 2, (bitBackground.Height - bitMain.Height) DIV 2
      , bitMain.Width + ((bitBackground.Width - TheForm.ClientWidth) DIV 2)
      , bitMain.Height + ((bitBackground.Height - bitMain.Height) DIV 2));
      bitMain.Canvas.CopyRect(ARect,bitBackground.Canvas, BRect);
    end;{if}

    {assigns the temporary bitmap to the BackgroundImage for displaying}

    BackgroundImage := TImage.create(TheForm);
    with BackgroundImage do begin
      BackgroundImage.parent := TheForm;
      anchors := [];
      autosize := TRUE;
      Width := 100;
      Height := 100;
      BackgroundImage.SendToBack;
      Picture.Bitmap.Assign(bitMain);
    end;{with}

    Application.ProcessMessages;{fixes first draw of bitmap problem}
    bitMain.Free;

    FillChar(DummyMessage,Sizeof(DummyMessage),0);
    MyDC := TWMEraseBkGnd(DummyMessage).DC;

    OldPalette := SelectPalette(MyDC,BackgroundImage.Picture.BitMap.Palette,False);
    try
      RealizePalette(MyDC);
      BitBlt(MyDC, 0, 0, BackgroundImage.Picture.Width, BackgroundImage.Picture.Height ,BackgroundImage.Picture.Bitmap.Canvas.Handle
      , 0, 0, SRCCOPY);
    finally
      SelectPalette(MyDC,OldPalette,true);
    end;{try}

{   if not bFormBitmapExtracted then bFormBitmapExtracted := TRUE;}
  end;{if}
end;

function ColorMode(TheCanvas : TCanvas) : TColorMode;
begin
  if TheCanvas.Handle = 0 then Result := cmUnknown
  else begin
    case GetDeviceCaps(TheCanvas.Handle,BITSPIXEL) of
      64 : Result := cm64Bit;
      32 : Result := cm32Bit;
      24 : Result := cm24Bit;
      16 : Result := cm16Bit;
      8 : Result := cm256Colors;
      4 : Result := cm16Colors;
      1 : Result := cmMonochrome;
      else Result := cmUnknown;
    end;{case}
  end;{if}
end;

function LoadJPEGFromRes(sJPEGName : ANSIstring; JPEGImage : TJPEGImage) : boolean;
var
  ResHandle : THandle;
  MemHandle : THandle;
  MemStream : TMemoryStream;
  ResPtr    : PByte;
  ResSize   : Longint;
begin
  ResHandle := FindResource(hInstance, PChar(sJPEGName), 'JPEG');
  if ResHandle <> 0 then begin
    MemHandle := LoadResource(hInstance, ResHandle);
    ResPtr    := LockResource(MemHandle);
    MemStream := TMemoryStream.Create;
    ResSize := SizeOfResource(hInstance, ResHandle);
    MemStream.SetSize(ResSize);
    MemStream.Write(ResPtr^, ResSize);
    FreeResource(MemHandle);
    MemStream.Seek(0, 0);
    JPEGImage.LoadFromStream(MemStream);
    MemStream.Free;
  end;{if}
  Result := ResHandle <> 0;
end;

function DarkenColor(Col: TColor; Percent: Byte): TColor;
var R, G, B: LongInt;
begin
  Percent := 100 - Percent;
  Col := ColorToRGB(Col);
  R := GetRValue(Col);
  G := GetGValue(Col);
  B := GetBValue(Col);

  R := Round(R*Percent/100);
  ValidateRGBValue(R);
  G := Round(G*Percent/100);
  ValidateRGBValue(G);
  B := Round(B*Percent/100);
  ValidateRGBValue(B);

  Result := RGB(R, G, B);
end;

function LightenColor(Col: TColor; Percent: Byte): TColor;
var R, G, B: LongInt;
begin
  Percent := 100 - Percent;
  Col := ColorToRGB(Col);
  R := GetRValue(Col);
  G := GetGValue(Col);
  B := GetBValue(Col);

  R := Round(R*Percent/100) + Round(255 - Percent/100*255);
  ValidateRGBValue(R);
  G := Round(G*Percent/100) + Round(255 - Percent/100*255);
  ValidateRGBValue(G);
  B := Round(B*Percent/100) + Round(255 - Percent/100*255);
  ValidateRGBValue(B);

  Result := RGB(R, G, B);
end;

function ColorToStr(AColor : TColor) : AnsiString;
{var
  pColorStr, pColor : pChar;}
begin
  Result := Format('%x', [AColor]);

{  GetMem(pColor, 255);
  GetMem(pColorStr, 255);
  pColor := StrPCopy(pColor, IntToStr(AColor));
  BinToHex(pColor, pColorStr, 255);
  Result := pColorStr;
  FreeMem(pColor, 255);
  FreeMem(pColorStr, 255);}
end;

procedure DrawVertLine(LineColour: TColor; LineLeft: integer; LineTop: integer; LineBottom: integer; ACanvas : TCanvas);
begin
  if LineTop >= LineBottom then Exit;

//  if ACanvas = nil then ACanvas := Canvas;

  with ACanvas do
  begin
    Pen.Color:= LineColour;
    MoveTo(LineLeft, LineTop);
    LineTo(LineLeft, LineBottom);
  end;
end;

procedure DrawHorizLine(LineColour: TColor; LineTop: integer; LineLeft: integer; LineRight: integer; ACanvas : TCanvas);
begin
  if LineLeft >= LineRight then Exit;

//  if ACanvas = nil then ACanvas := Canvas;

  with ACanvas do
  begin
    Pen.Color:= LineColour;
    MoveTo(LineLeft, LineTop);
    LineTo(LineRight, LineTop);
  end;
end;

procedure DrawFilledRect(FillColour: TColor; iLeft, iTop, iRight, iBottom : integer; ACanvas : TCanvas);
var
  TheRect : TRect;
begin
  with ACanvas do begin
    Brush.Color := FillColour;
    Brush.Style := bsSolid;
    TheRect := Rect(iLeft, iTop, iRight, iBottom);
    FillRect(TheRect);
  end;{with}
end;

procedure DrawBitmapAtBottomLeft(ADC : HDC; const AForm : TForm; const ABitmap : TBitmap; TbAndStatBarHeight : Integer);
Var
  MyDC       : hDC;
  Ro, Co     : Word;
  OldPalette : HPalette;
  BackgroundRect: TRect;
  X, Y: Integer;
  BlitResult: Boolean;
Begin
  MyDC := ADC;

  OldPalette:=SelectPalette(MyDC, ABitMap.Palette, False);
  try
    RealizePalette(MyDC);

    { CJS 2012-09-07 ABSEXCH-12952 - Rebranding - Background bitmap handling }
    X := 0;
    Y := AForm.ClientHeight - TbAndStatBarHeight - 6 - ABitmap.Height;
    if (Y < 0) then
      Y := 0;

    BackgroundRect := Rect(0, 0, AForm.ClientWidth, Y);
    FillRect(MyDC, BackgroundRect, clWhite);

    BackgroundRect := Rect(ABitmap.Width, Y, AForm.ClientWidth, AForm.ClientHeight - TbAndStatBarHeight - 6);
    FillRect(MyDC, BackgroundRect, clWhite);

    BlitResult := BitBlt(MyDC, 0, Y, ABitmap.Width, ABitmap.Height,
                         ABitmap.Canvas.Handle, 0, 0, SRCCOPY);
    if not BlitResult then
      OutputDebugString('BitBlt failed');

  finally
    SelectPalette(MyDC,OldPalette,true);
  end; {try..}

end;


end.
