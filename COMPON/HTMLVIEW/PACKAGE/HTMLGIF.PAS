{Version 8.04}
{*********************************************************}
{*                     HTMLGIF.PAS                       *}
{*                  (From GIFIMAGE.PAS)                  *}
{*                 Copyright (c) 1998-9 by               *}
{*                 Theodor Kleynhans and                 *)
{*                   L. David Baldwin                    *}
{*                 All rights reserved.                  *}
{*********************************************************}

{For information on Animated GIF code for another program, contact
 Theodor Kleynhans, theodor@gem.co.za, http://members.gem.co.za/~theodor
}

{$i htmlcons.inc}

unit HTMLGif;

{$ifdef Windows}
Error, untested for 16 bit but probably OK
{$endif}

{$ifndef NoGIF}

interface

uses
{$IFNDEF Win32}
  WinTypes, WinProcs, Menus,
{$ELSE}
  Windows,
{$ENDIF}
{$ifdef ver100_plus}
  DitherUnit,    
{$endif}
  SysUtils, Classes, Graphics, Controls, ExtCtrls, htmlUN2, mmSystem;

const
  MaxFrame = 256;
  DefaultWidth = 105;
  DefaultHeight = 105;

  idExtension = $21;
  idImage = $2C;
  idTrailer = $3B;

  lblPlainText = $01;
  lblGraphicControl = $F9;
  lblComment = $FE;
  lblApplication = $FF;

  sdGlobalColorTable = $80;
  sdColorResolution = $70;
  sdSorted = $08;
  sdColorTableSize = $07;

  idLocalColorTable = $80;
  idInterlaced = $40;
  idSorted = $20;
  idReserved = $0C;
  idColorTableSize = $07;

  geReserved = $E0;
  geDisposalMethod = $1C;
  geUserInput = $02;
  geUseTransparency = $01;

type
  {_________ GIF File Structures __________________________}
  TGIFHeader = packed Record
    ghSignature: array[1..3] of Char;   { Should be 'GIF' }
    ghVersion: array[1..3] of Char;     { '87a' or '89a' }
  end;

  TScreenDescriptor = packed Record
    sdWidth: Word;
    sdHeight: Word;
    sdInfo: Byte;
    sdBackground: Byte;
    sdAspectRatio: Byte;
  end;

  TRGBColor = packed Record
    Red,
    Green,
    Blue: Byte;
  end;
  TColorTable = array[0..255] of TRGBColor;
  PColorTable = ^TColorTable;

  TImageDescriptor = packed Record
    idSeperator: Byte;                     { Always $2C (idImage) }
    idLeft: Word;
    idTop: Word;
    idWidth: Word;
    idHeight: Word;
    idInfo: Byte;
  end;

  TDataSubBlock = packed Record
    dbSize: Byte;                          { Number of bytes in this block (0 - 255) }
    dbData: array[1..255] of Byte;
  end;

  TExtension = packed Record
    exIntroducer: Byte;                    { Always $21 (idExtension) }
    exLabel: Byte;                         { Graphic, Text, App, etc. }
  end;

  TGraphicExtension = packed Record
    geSize: Byte;                          { Always 4 }
    geInfo: Byte;
    geDelay: Word;                         { In 100ths of a second }
    geTransparentColor: Byte;
    geTerminator: Byte;                    { 0 }
  end;

  TDisposalType = (dtUndefined, dtDoNothing, dtToBackground, dtToPrevious);

  TAppExtension = packed Record
    aeSize: Byte;                          { Should be 11, but Adobe uses 10 }
    aeAppName: array[1..8] of Char;        { eg. 'NETSCAPE' }
    aeAppCode: array[1..3] of Char;        { eg. '2.0' }
    aeData: TDataSubBlock;
  end;

  TLoopData = packed Record
    ldReserved: Byte;                      { Always 1 }
    ldIterations: Word;                    { 0 - 65535, 0 = Infinite }
  end;

type
  TGIFImage = class;

  TgfFrame = class
  protected
    { Protected declarations }
    procedure DecodeImage(var GIFData: Pointer;
              const PixelBuffer, MaskBuffer: Pointer; PixelsWidth, MaskWidth: Integer); virtual;
  private
    { private declarations }
    Left: Integer;
    Top: Integer;
    Width: Integer;
    Height: Integer;

    ColorDepth: Integer;
    Delay: Integer;
    DisposalMethod: TDisposalType;
    HasColorTable: Boolean;
    IsInterlaced: Boolean;
    IsTransparent: Boolean;
    TransparentColor: Byte;
    BackgroundColor: TRGBColor;
    TheEnd: boolean;    {end of what gets copied}

    ColorTable: PColorTable;  
    Image: TBitmap;
    ImageMask: TBitmap;
    PreviousImage: TBitmap;
    PreviousImageMask: TBitmap;
    Owner: TGIFImage;
    Comment: String;
    FDitherIt: boolean;    

    constructor Create(AOwner: TGIFImage);
    constructor CreateCopy(Item: TgfFrame; AOwner: TGifImage);
    {$ifdef Win32}{$Hints Off}{$endif}       
    destructor Destroy; override;
    function ReadImage(var GIFData: Pointer; var GlobalColorTable: TColorTable;
                       var GraphicControlBlock: TGraphicExtension): Boolean; virtual;
    {$ifdef Win32}{$Hints On}{$endif}
  end;

  TGIFImage = class(TPersistent)
  private
    { Private declarations }
    FAnimated: Boolean;
    FCurrentFrame: Integer;
    FEmpty: Boolean;
    FImageWidth: Integer;
    FImageHeight: Integer;
    FLoop: Boolean;
    FNumFrames: Integer;
    FNumIterations: Integer;
    FSpeed: Integer;
    FTransparent: Boolean;
    FVisible: Boolean;
    FBitsPerPixel: Integer;
    GlobalColorTable: TColorTable;

    TheEnd: boolean;   {copy to here}

    dcImage: hDC;
    hImage: hBITMAP;
    dcImageMask: hDC;
    hImageMask: hBITMAP;
    dcBackground: hDC;
    hBackground: hBITMAP;
    FBitmap, FMaskedBitmap, FMask: TBitmap;
    FAnimate: Boolean;
    FDitherIt: Boolean;
    aTop, aLeft, aHeight, aWidth: integer;


    Frames: array[1..MaxFrame] of ^TgfFrame;

    CurrentIteration: Integer;
    Fresh: Boolean;
    HaveInfoOnly: Boolean;
    MemStream: TMemoryStream;

    LastTime: LongInt;
    CurrentInterval: integer;

    procedure SetAnimate(AAnimate: Boolean);
    procedure SetCurrentFrame(AFrame: Integer);
    procedure SetVisible(AVisible: Boolean);
    function GetMaskedBitmap: TBitmap;
    function GetMask: TBitmap;
    function GetBitMap: TBitmap;

    procedure Clear;
    procedure ClearAll;
    procedure SetupBitmap;
    procedure RemoveBitmap(AFrame: Integer);

  protected
    { Protected declarations }
    function ReadGIF: Boolean; virtual;
  public
    ShowIt: boolean;
    IsCopy: boolean;   {set if this is a copy of one in Cache}

    { Public declarations }
    constructor Create;
    constructor CreateCopy(Item: TGIFImage);
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; MasterList, Cell: TObject; X, Y, Wid, Ht: integer);
    property MaskedBitmap: TBitmap read GetMaskedBitmap;
    property Mask: TBitmap read GetMask;
    property Bitmap: TBitmap read GetBitmap;
    property BitsPerPixel: Integer read FBitsPerPixel;
    property Empty: Boolean read FEmpty;
    property IsAnimated: Boolean read FAnimated;
    property IsTransparent: Boolean read FTransparent;
    property NumFrames: Integer read FNumFrames;
    property NumIterations: Integer read FNumIterations;

    function LoadFromFile(const GIFFileName: String): Boolean;
    function LoadFromStream(Stream: TStream): Boolean;
    function LoadInfoFromFile(const GIFFileName: String): Boolean;
    function LoadInfoFromStream(Stream: TStream): Boolean;
    function LoadFromResourceName(Instance: THandle; const ResName: String): Boolean;
    function LoadFromResourceID(Instance: THandle; const ResID: Integer): Boolean;
    procedure CheckTime(WinHandle: THandle);

    property Width: integer read FImageWidth;
    property Height: integer read FImageHeight;
    property Animate: Boolean read FAnimate write SetAnimate;
    property CurrentFrame: Integer read FCurrentFrame write SetCurrentFrame;
    property Visible: Boolean read FVisible write SetVisible;
  end;

function CreateAGifFromStream(var NonAnimated: boolean;
              Stream: TMemoryStream): TGifImage;   
function CreateAGif(const Name: string; var NonAnimated: boolean): TGifImage;   

implementation

uses
  htmlsubs;

const
  Pwr: array[0..15] of Word = (1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768);

function CreateAGifFromStream(var NonAnimated: boolean;
              Stream: TMemoryStream): TGifImage;
begin
NonAnimated := True;
Result := TGifImage.Create;
with Result do
  if LoadInfoFromStream(Stream) then
      begin
      Animate := False;
      Visible := False;
      NonAnimated := not IsAnimated;
      {$ifdef ver100_plus}
      if (ColorBits = 8) and (Result.FBitsPerPixel > 1) then   
        Result.FDitherIt := NonAnimated;
      {$endif}
      if not LoadFromStream(Stream) then
        begin
        Result.Free;
        Result := Nil;
        end;
      end
  else
    begin
    Result.Free;
    Result := Nil;
    end;
end;

function CreateAGif(const Name: string; var NonAnimated: boolean): TGifImage;
begin
NonAnimated := True;
Result := TGifImage.Create;
with Result do
  begin
  Animate := False;
  Visible := False;
  if LoadInfoFromFile(Name) then
      begin
      NonAnimated := not IsAnimated;
      {$ifdef ver100_plus}
      if (ColorBits = 8) and (Result.FBitsPerPixel > 1) then   
        Result.FDitherIt := NonAnimated;
      {$endif}
      if not LoadFromFile(Name) then
        begin
        Result.Free;
        Result := Nil;
        end;
      end
  else
    begin
    Result.Free;
    Result := Nil;
    end;
  end;
end;

{----------------PaletteFromBmpInfo}
function PaletteFromBmpInfo(BmpInfo: PBitmapInfo): HPalette;    
var
  PalSize: Integer;
  Palette: PLogPalette;
  Lp     : Integer;
  NumColors: Integer;
begin
  NumColors := BmpInfo^.bmiHeader.biClrUsed;
  PalSize := SizeOf(TLogPalette) + (NumColors * SizeOf(TPaletteEntry));
  Palette := AllocMem(PalSize);

  try
    Result := 0;
    with Palette^ do begin
      palVersion := $300;
      palNumEntries := NumColors;
      for Lp := 0 to Pred(NumColors) do
        with palPalEntry[Lp], BmpInfo^.bmiColors[Lp] do begin
          peRed := rgbRed;
          peGreen := rgbGreen;
          peBlue := rgbBlue;
          peFlags := 0;
        end;
    end;
    Result := CreatePalette(Palette^);
  finally
    FreeMem(Palette, PalSize);
  end;
end;

{----------------CreateDIB}
procedure CreateDIB(Bmp: TBitmap; BmpInfo: PBitmapInfo; Bits: Pointer;
             NumColors: Integer; DitherIt: boolean);
{Sets up a TBitmap to correspond to BmpInfo and Bits}
var
  dc: HDC;
  OldPal: HPalette;
begin
  if Bmp.Handle <> 0 then
    DeleteObject(Bmp.ReleaseHandle);
  if Bmp.Palette <> 0 then
    DeleteObject(Bmp.ReleasePalette);

  dc := GetDC(0);
  if DitherIt then    
    begin
    Bmp.Palette := PaletteFromBmpInfo(BmpInfo);     
    OldPal := SelectPalette(dc, Bmp.Palette, False);
    end
  else
    OldPal := SelectPalette(dc, ThePalette, False);
  RealizePalette(dc);

  Bmp.Handle := CreateDIBitmap(dc, BmpInfo^.bmiHeader, cbm_Init, Bits, BmpInfo^,
                  dib_RGB_Colors);
  SelectPalette(dc, OldPal, True);
  ReleaseDC(0, dc);
end;

{$IFDEF Windows}
procedure __AHSHIFT; far; external 'KERNEL' index 113;

function OffsetPointer(P: Pointer; Ofs: Longint): Pointer; assembler;
asm
        MOV     AX,Ofs.Word[0]
        MOV     DX,Ofs.Word[2]
        ADD     AX,P.Word[0]
        ADC     DX,0
        MOV     CX,OFFSET __AHSHIFT
        SHL     DX,CL
        ADD     DX,P.Word[2]
end;

procedure IncPtr(var P; ACount: LongInt);
begin
Pointer(P) := OffsetPointer(Pointer(P), ACount);
end;
{$else}

procedure IncPtr(var P; ACount: LongInt);
begin
Inc(DWord(P), ACount);
end;
{$endif}

procedure MoveX(var Source, Dest; Count: LongInt);   
begin
{$ifdef Win32}
Move(Source, Dest, Count);
{$else}
hMemCpy(@Dest, @Source, Count);
{$endif}
end;

function DWordBoundary(const AValue: LongInt): LongInt;
begin
  Result := ((AValue + 3) shr 2) shl 2;
end;

function Maximum(const Value1, Value2: LongInt): LongInt;
begin
  if Value1 > Value2 then
    Result := Value1
  else
    Result := Value2;
end;

{----------------TgfFrame.Create}
constructor TgfFrame.Create(AOwner: TGIFImage);
begin
  inherited Create;
  Image := TBitmap.Create;
  Owner := AOwner;
end;

constructor TgfFrame.CreateCopy(Item: TgfFrame; AOwner: TGifImage);
begin
inherited Create;
Owner := AOwner;
{$ifdef Windows}
System.Move(Item.Left, Left, Ofs(TheEnd)-Ofs(Left));
{$else}
System.Move(Item.Left, Left, DWord(@TheEnd)-DWord(@Left));
{$endif}
Image := TBitmap.Create;
Image.Assign(Item.Image);
if Assigned(Item.ImageMask) then
  begin
  ImageMask := TBitmap.Create;
  ImageMask.Assign(Item.ImageMask);
  end;
if Assigned(Item.PreviousImage) then
  begin
  PreviousImage := TBitmap.Create;
  PreviousImage.Assign(Item.PreviousImage);
  end;
if Assigned(Item.PreviousImageMask) then
  begin
  PreviousImageMask := TBitmap.Create;
  PreviousImageMask.Assign(Item.PreviousImageMask);
  end;
end;

{----------------TgfFrame.Destroy}
destructor TgfFrame.Destroy;
begin
  ImageMask.Free;
  PreviousImageMask.Free;
  PreviousImage.Free;
  if HasColorTable and Assigned(ColorTable) then Dispose(ColorTable);
  Image.Free;
  inherited Destroy;
end;

procedure TgfFrame.DecodeImage(var GIFData: Pointer; const PixelBuffer,
             MaskBuffer: Pointer; PixelsWidth, MaskWidth: integer);
type
  PrefixArray = array[0..4095] of Word;
  StackArray = array[0..4095] of Cardinal;
var
  Buffer: array[0..263] of Byte;

  BlockSize: Byte;
  ZeroDataBlock: Boolean;

  CurBit: integer;
  LastBit: LongInt;
  LastByte: LongInt;
  Done: Boolean;

  CodeSize: LongInt;
  SetCodeSize: LongInt;
  MaxCode: LongInt;
  MaxCodeSize: LongInt;
  FirstCode: LongInt;
  OldCode: LongInt;
  ClearCode: LongInt;
  EndCode: LongInt;
  Prefix,
  Suffix: ^PrefixArray;
  Stack: ^StackArray;
  SP: LongInt;

  LpX, LpY, Pass: integer;
  PixelAddr, MaskAddr: PByte;
  Pixel, PixelsOffset, MaskOffset, CurrentBit: integer;

  {---------------------------------------------}
  function GetDataBlock(var Destination): Boolean;
  begin
    BlockSize := Byte(GIFData^);
    IncPtr(GIFData, 1);
    if BlockSize > 0 then begin
      Result := True;
      ZeroDataBlock := False;
      MoveX(GIFData^, Destination, BlockSize);
      IncPtr(GIFData, BlockSize);
    end else begin
      Result := False;
      ZeroDataBlock := True;
    end;
  end;

  {---------------------------------------------}
  function GetCode: LongInt;
  var
    Lp: integer;
    Bit, Power1, Power2: LongInt;
    DataByte: LongInt;
    ByteIndex: LongInt;
  begin
    if (CurBit + CodeSize) >= LastBit then begin
      if Done then begin
        Result := -1;
        Exit;
      end;
      Buffer[0] := Buffer[LastByte - 2];
      Buffer[1] := Buffer[LastByte - 1];
      Done := not GetDataBlock(Buffer[2]);
      LastByte := BlockSize + 2;
      CurBit := (CurBit - LastBit) + 16;
      LastBit := LastByte * 8;
    end;

    Result := 0;
    Bit := CurBit;
    ByteIndex := Bit shr 3;
    DataByte := Buffer[Bit shr 3];
    Bit := Bit and 7;
    Power1 := Pwr[Bit];
    Power2 := 1;
    for Lp := 0 to Pred(CodeSize) do begin
      if (DataByte and Power1) > 0 then Result := Result or Power2;
      Power1 := Power1 shl 1;
      Power2 := Power2 shl 1;
      Inc(Bit);
      if Bit >= 8 then begin
        Bit := 0;
        Power1 := 1;
        Inc(ByteIndex);
        DataByte := Buffer[ByteIndex];
      end;
    end;

    Inc(CurBit, CodeSize);
  end;

  {---------------------------------------------}
  function ReadLZWByte: integer;
  var
    Code: LongInt;
    InCode: LongInt;
    Lp: integer;
  begin
    if SP > 0 then begin
      Dec(SP);
      Result := Stack^[SP];
      Exit;
    end;

    Code := GetCode;
    while Code >= 0 do begin
      if Code = ClearCode then begin
        FillChar(Prefix^, SizeOf(PrefixArray), 0);
        FillChar(Suffix^, SizeOf(PrefixArray), 0);
        for Lp := 0 to Pred(ClearCode) do Prefix^[Lp] := Lp;
        SP := 0;
        CodeSize := Succ(SetCodeSize);
        MaxCodeSize := ClearCode * 2;
        MaxCode := ClearCode + 2;
        FirstCode := GetCode;
        OldCode := FirstCode;
        Result := FirstCode;
        Exit;
      end else if Code = EndCode then begin
        Result := -2;
        if ZeroDataBlock then Exit;
        repeat
          GetDataBlock(Buffer[0]);
        until BlockSize = 0;
        Exit;
      end;

      InCode := Code;
      if Code >= MaxCode then begin
        Stack^[SP] := FirstCode;
        Inc(SP);
        Code := OldCode;
      end;

      while Code >= ClearCode do begin
        if (SP > 4095) then        
          Raise Exception.Create('Corrupt GIF Image');
        Stack^[SP] := Prefix^[Code];
        Inc(SP);
        Code := Suffix^[Code];
      end;

      FirstCode := Prefix^[Code];
      Stack^[SP] := FirstCode;
      Inc(SP);
      Code := MaxCode;
      if Code < 4096 then begin
        Prefix^[Code] := FirstCode;
        Suffix^[Code] := OldCode;
        Inc(MaxCode);
        if (MaxCode >= MaxCodeSize) and (MaxCodeSize < 4096) then begin
          MaxCodeSize := MaxCodeSize * 2;
          Inc(CodeSize);
        end;
      end;

      OldCode := InCode;
      if SP > 0 then begin
        Dec(SP);
        Result := Stack^[SP];
        Exit;
      end;

      Code := GetCode;
    end; {while...}

    Result := Code;
  end;

{-----------------------------------------------}
begin
MoveX(GIFData^, BlockSize, 1);         { LZW Minimum Code Size }
IncPtr(GIFData, 1);

SetCodeSize := BlockSize;
CodeSize := Succ(BlockSize);
ClearCode := Pwr[SetCodeSize];
EndCode := Succ(ClearCode);
MaxCode := Succ(EndCode);
MaxCodeSize := ClearCode * 2;
GetMem(Prefix, SizeOf(PrefixArray));
GetMem(Suffix, SizeOf(PrefixArray));
GetMem(Stack, SizeOf(StackArray));
try
  FillChar(Prefix^, SizeOf(PrefixArray), 0);
  FillChar(Suffix^, SizeOf(PrefixArray), 0);
  for LpX := 0 to Pred(ClearCode) do Prefix^[LpX] := LpX;
  SP := 0;

  CurBit := 0;
  Done := not GetDataBlock(Buffer[0]);
  LastByte := BlockSize;
  LastBit := LastByte * 8;

  LpX := 0;
  LpY := 0;
  Pass := 0;
  CurrentBit := 7;
  PixelAddr := PixelBuffer;
  MaskAddr := MaskBuffer;
  PixelsOffset := PixelsWidth - Width;
  MaskOffset := MaskWidth - (Width div 8);

  repeat
    FirstCode := GetCode;
  until FirstCode <> ClearCode;
  OldCode := FirstCode;
  Pixel := FirstCode;

  while Pixel >= 0 do
    begin
    PixelAddr^ := Byte(Pixel);
    Inc(LpX);
    {$ifdef Win32}
    Inc(PixelAddr);    
    {$else}
    IncPtr(PixelAddr, 1);
    {$endif}

    if IsTransparent then begin
      if Pixel = TransparentColor then MaskAddr^ := MaskAddr^ or Pwr[CurrentBit];
      Dec(CurrentBit);
      if CurrentBit < 0 then begin
        CurrentBit := 7;
        IncPtr(MaskAddr, 1);
      end;
    end;

    if LpX = Width then begin
      LpX := 0;
      CurrentBit := 7;

      if IsInterlaced then begin
        case Pass of
          0,
          1: Inc(LpY, 8);
          2: Inc(LpY, 4);
          3: Inc(LpY, 2);
        end;
        if LpY >= Height then begin
          Inc(Pass);
          case Pass of
            1: LpY := 4;
            2: LpY := 2;
            3: LpY := 1;
          else
            Break;
          end;
        end;
        PixelAddr := PixelBuffer;
        IncPtr(PixelAddr, LpY * LongInt(PixelsWidth));      
        if IsTransparent then begin
          MaskAddr := MaskBuffer;
          IncPtr(MaskAddr, LpY * MaskWidth);
        end;
      end else begin
        Inc(LpY);
        IncPtr(PixelAddr, PixelsOffset);
        if IsTransparent then IncPtr(MaskAddr, MaskOffset);
      end;

      if LpY >= Height then Break;
    end;

    if SP > 0 then begin
      Dec(SP);
      Pixel := Stack^[SP];
    end
    else Pixel := ReadLZWByte; 
    end; {while...}

  repeat until ReadLZWByte < 0;   { Read any junk pixels left over }
finally
  FreeMem(Prefix, SizeOf(PrefixArray));
  FreeMem(Suffix, SizeOf(PrefixArray));
  FreeMem(Stack, SizeOf(StackArray));
  end;
end;

procedure TranslateColors(BitmapInfo: PBitmapInfo; ColorTable: PColorTable; 
           Pixels: Pointer; TableSize: integer; DitherIt: boolean; var NewSize: integer);
var
  Lp, I, J, Index: integer;
  xlate: array[0..255] of byte;
  Color: TColor;
  P: PByte;
  PalEntry: TPaletteEntry;
begin               
if (ThePalette <> 0) and not DitherIt then    
  begin  {change the image to use ThePalette using nearest color match}
  FillChar(xlate, Sizeof(xlate), 0);
  for Lp := 0 to 255 do
    begin
    if Lp < TableSize then    {for all colors in old palette}
      begin  {find the nearest color}
      with ColorTable^[Lp] do
        Color := LongInt(Blue) shl 16 or LongInt(Green) shl 8 or LongInt(Red);
      Index := GetNearestPaletteIndex(ThePalette, Color);
      xlate[Lp] := Index;    {add to translation table}
      end;
    {change the image's palette info to that of ThePalette -- always 255 entries}
    GetPaletteEntries(ThePalette, Lp, 1, PalEntry);
    with BitmapInfo^.bmiColors[Lp], PalEntry do
      begin
      rgbRed := peRed;
      rgbGreen := peGreen;
      rgbBlue := peBlue;
      rgbReserved := peFlags;
      end;
    end;
  {Now translate all the pixels to use the new palette}
  P := Pixels;
  for J := 0 to Abs(BitmapInfo^.bmiHeader.biHeight)-1 do
    begin
    for I := 0 to BitmapInfo^.bmiHeader.biWidth-1 do
      begin
      P^ := xlate[P^];
      IncPtr(P,1);  
      end;
    P := Pixels;
    IncPtr(P, (J+1)*DWordBoundary(BitmapInfo^.bmiHeader.biWidth));  
    end;
  NewSize := 256;
  end
else
  begin  {ThePalette does not exist or we're dithering, use the colortable info} 
  NewSize := TableSize;
  for Lp := 0 to Pred(TableSize) do
    with BitmapInfo^.bmiColors[Lp], ColorTable^[Lp] do begin
    rgbRed := Red;
    rgbGreen := Green;
    rgbBlue := Blue;
    rgbReserved := 0;
    end;
  end;
end;

{...$ifdef Windows}    
procedure InvertRows(BMInfo: PBitmapInfo; Bits: Pointer);
{convert Pixels from bottom up to top down order.  Win 3.1 won't accept
 negative biHeight}
var
  J, RowSize, FullRowSize: integer;
  Tmp, S, E: Pointer;
begin
with BMInfo^.bmiHeader do
  begin
  biHeight := abs(biHeight);  {make it positive}
  RowSize := (biBitCount*biWidth-1) div 8 +1;
  FullRowSize := DWordBoundary(RowSize);  {includes padding}
  Tmp := AllocMem(FullRowSize);
  S := Bits;
  for j := 0 to ((biHeight) div 2)-1 do
    begin
    E := Bits;
    IncPtr(E, (biHeight-1-j)*FullRowSize);
    MoveX(S^, Tmp^, RowSize);
    MoveX(E^, S^, RowSize);
    MoveX(Tmp^, E^, RowSize);
    IncPtr(S, FullRowSize);
    end;
  FreeMem(Tmp, FullRowSize);
  end;
end;
{...$endif}

function TgfFrame.ReadImage(var GIFData: Pointer; var GlobalColorTable: TColorTable;
                        var GraphicControlBlock: TGraphicExtension): Boolean;
var
  ImageDescriptor: TImageDescriptor;
  TableSize: Integer;
  Pixels, Mask: Pointer;
  BitmapInfo: PBitmapInfo;
  Lp, NewSize: Integer;
  DoAllocations: Boolean;
  dc1, dc2: HDC;
  bm1, bm2: HBitmap;
  {$ifdef ver100_plus}
  TmpBitmap: TBitmap;   
  {$endif}
begin
  Result := False;

  DoAllocations := not Owner.HaveInfoOnly;

  MoveX(GIFData^, ImageDescriptor, SizeOf(TImageDescriptor));
  IncPtr(GIFData, SizeOf(TImageDescriptor));
  with ImageDescriptor do begin
    if idSeperator <> idImage then Exit;
    Left := idLeft;
    Top := idTop;
    Width := idWidth;
    Height := idHeight;
    if (idInfo and idLocalColorTable) = idLocalColorTable then begin
      HasColorTable := True;
      ColorDepth := (ImageDescriptor.idInfo and idColorTableSize) + 1;
      TableSize := Pwr[ColorDepth] * SizeOf(TRGBColor);
      if DoAllocations then begin
        New(ColorTable);
        MoveX(GIFData^, ColorTable^, TableSize);
      end;
      IncPtr(GIFData, TableSize);
    end else begin
      HasColorTable := False;
      ColorTable := @GlobalColorTable;
      ColorDepth := 0;
    end;
    IsInterlaced := (ImageDescriptor.idInfo and idInterlaced) = idInterlaced;
  end;

  with GraphicControlBlock do begin
    Lp := (geInfo and geDisposalMethod) shr 2;
    case Lp of
      0: DisposalMethod := dtUndefined;
      1: DisposalMethod := dtDoNothing;
      2: DisposalMethod := dtToBackground;
      3: DisposalMethod := dtToPrevious;
    else
      DisposalMethod := dtToBackground;
    end;
    Delay := geDelay * 10;
    IsTransparent := (geInfo and geUseTransparency) = geUseTransparency;
    TransparentColor := geTransparentColor;
  end;

  if (DisposalMethod = dtToPrevious) and DoAllocations then begin
    PreviousImage := TBitmap.Create;
    PreviousImage.Width := Width;
    PreviousImage.Height := Height;

    PreviousImageMask := TBitmap.Create;
    PreviousImageMask.Monochrome := True;
    PreviousImageMask.Width := Width;
    PreviousImageMask.Height := Height;
  end;

  if DoAllocations then begin
    Pixels := GlobalAllocPtr(HeapAllocFlags, DWordBoundary(Width) * Height); 
    if IsTransparent then begin
      ImageMask := TBitmap.Create;
      Mask := AllocMem(((Width + 31) shr 5) shl 2 * Height);
    end else
      Mask := nil;
    BitmapInfo := AllocMem(SizeOf(TBitmapInfoHeader) + 256 * SizeOf(TRGBQuad));

    try
      DecodeImage(GIFData, Pixels, Mask, DWordBoundary(Width), ((Width + 31) shr 5) shl 2);

      with BitmapInfo^.bmiHeader do begin
        biSize := SizeOf(TBitmapInfoHeader);
        biWidth := Width;
        biHeight := -Height;
        biPlanes := 1;
        biBitCount := 8;
        biCompression := bi_RGB;
        biSizeImage := DWordBoundary(Width) * Height;
        if HasColorTable then
          TableSize := Pwr[ColorDepth]
        else
          TableSize := Pwr[Owner.FBitsPerPixel];
        biClrUsed := TableSize;
  {...$ifdef Windows}
        InvertRows(BitmapInfo, Pixels);
  {...$endif}
      end;

      TranslateColors(BitmapInfo, ColorTable, Pixels, TableSize, FDitherIt, NewSize); 
      BitmapInfo^.bmiHeader.biClrUsed := NewSize;
      CreateDIB(Image, BitmapInfo, Pixels, NewSize, FDitherIt);  

      if IsTransparent then begin
        with BitmapInfo^.bmiHeader do begin
          biSize := SizeOf(TBitmapInfoHeader);
          biWidth := Width;
          biHeight := -Height;
          biPlanes := 1;
          biBitCount := 1;
          biCompression := bi_RGB;
          biSizeImage := (((Width + 31) shr 5) shl 2) * Height;
          biClrUsed := 2;
  {...$ifdef Windows}
        InvertRows(BitmapInfo, Mask);
  {...$endif}
        end;
        for Lp := 0 to 1 do with BitmapInfo^.bmiColors[Lp] do begin
          rgbRed := 255 * Lp;
          rgbGreen := 255 * Lp;
          rgbBlue := 255 * Lp;
          rgbReserved := 0;
        end;
        CreateDIB(ImageMask, BitmapInfo, Mask, 2, False);

        BackgroundColor := ColorTable^[TransparentColor];

        dc1 := CreateCompatibleDC(0);
        bm1 := SelectObject(dc1, Image.Handle);
        dc2 := CreateCompatibleDC(0);
        bm2 := SelectObject(dc2, ImageMask.Handle);
        BitBlt(dc1, 0, 0, Width, Height, dc2, 0, 0, $00220326);
        SelectObject(dc1, bm1);
        SelectObject(dc2, bm2);
        DeleteDC(dc1);
        DeleteDC(dc2);
       end;

{$ifdef ver100_plus}
      if FDitherIt then  
        begin
        Image.HandleType := bmDIB;  
        TmpBitmap := GetBitmap(Image);  
        Image.Free;
        Image := TmpBitmap;   
        end;
{$endif}

      Result := True;
    finally
      FreeMem(BitmapInfo, SizeOf(TBitmapInfoHeader) + 256 * SizeOf(TRGBQuad));
      if IsTransparent then FreeMem(Mask, ((Width + 31) shr 5) shl 2 * Height);
      GlobalFreePtr(Pixels);
    end;

  end else begin  {Skip image data blocks}
    IncPtr(GIFData, 1);  {Skip LZW CodeSize byte}
    while TDataSubBlock(GIFData^).dbSize > 0 do IncPtr(GIFData, TDataSubBlock(GIFData^).dbSize + 1);
    while TDataSubBlock(GIFData^).dbSize = 0 do IncPtr(GIFData, 1);
    Result := True;
  end;
end;

{----------------- TGIFImage - Holds all images found in GIF file}
{----------------TGIFImage.Create}
constructor TGIFImage.Create;
begin
  inherited Create;

  FEmpty := True;
  FSpeed := 100;
  FVisible := True;
  MemStream := TMemoryStream.Create;
  FCurrentFrame := 1;
end;

constructor TGIFImage.CreateCopy(Item: TGIFImage);
var
  I: integer;
  DC: HDC;
begin
inherited Create;
FImageWidth := Item.Width;
FimageHeight := Item.Height;
{$ifdef Windows}
System.Move(Item.FAnimated, FAnimated, Ofs(TheEnd)-Ofs(FAnimated));
{$else}
System.Move(Item.FAnimated, FAnimated, DWord(@TheEnd)-DWord(@FAnimated));
{$endif}
IsCopy := True;

DC := GetDC(0);
dcImage := CreateCompatibleDC(DC);
hImage := SelectObject(dcImage, CreateCompatibleBitmap(DC, FImageWidth, FImageHeight));
PatBlt(dcImage, 0, 0, FImageWidth, FimageHeight, BLACKNESS);

if FTransparent then
  begin
  dcImageMask := CreateCompatibleDC(DC);
  hImageMask := SelectObject(dcImageMask, CreateCompatibleBitmap(DC, FImageWidth, FImageHeight));
  PatBlt(dcImageMask, 0, 0, FImageWidth, FImageHeight, WHITENESS);
  end;
ReleaseDC(0, DC);

for I := 1 to NumFrames do
  begin
  New(Frames[I]);
  Frames[I]^ := TgfFrame.CreateCopy(Item.Frames[I]^, Self);
  end;
FCurrentFrame := 1;
CurrentIteration := 1;
SetupBitmap;        
end;

{----------------TGIFImage.Destroy}
destructor TGIFImage.Destroy;
var
  Lp: Integer;
begin
  if FNumFrames > 0 then for Lp := FNumFrames downto 1 do begin
    Frames[Lp]^.Free;
    Dispose(Frames[Lp]);
  end;
  MemStream.Free;
  FBitmap.Free;
  FMaskedBitmap.Free;
  FMask.Free;
  if dcBackground <> 0 then begin
    DeleteObject(SelectObject(dcBackground, hBackground));
    DeleteDC(dcBackground);
  end;
  if dcImageMask <> 0 then begin
    DeleteObject(SelectObject(dcImageMask, hImageMask));
    DeleteDC(dcImageMask);
  end;
  if dcImage <> 0 then begin
    DeleteObject(SelectObject(dcImage, hImage));
    DeleteDC(dcImage);
  end;
  inherited Destroy;
end;

{----------------TGIFImage.Draw}
procedure TGIFImage.Draw(Canvas: TCanvas; MasterList, Cell: TObject; X, Y, Wid, Ht: integer);
var
  FW, FH: Integer;
  dc: hDC;

  procedure LoadBackground;  
  begin
  if dcBackground = 0 then   
    begin
    dcBackground := CreateCompatibleDC(dc);
    hBackground := SelectObject(dcBackground, CreateCompatibleBitmap(dc, Wid, Ht));
    end;
  BitBlt(dcBackground, 0, 0, Wid, Ht, DC, X, Y, SrcCopy);
  end;

begin
aLeft := X;
aTop := Y;
aWidth := Wid;
aHeight := Ht;
dc := Canvas.Handle;
SetStretchBltMode(dc, ColorOnColor);
if (FVisible) and (not FEmpty) and (not HaveInfoOnly) and (FNumFrames > 0) then
  begin
  FW := FImageWidth;
  FH := FImageHeight;

  if Frames[1]^.IsTransparent then
    begin  { Transparent }
    {Note: FCurrentFrame is correct first time thru but incremented once thereafter}
    if (Frames[FCurrentFrame]^.DisposalMethod in [dtDoNothing, dtUndefined]) then
      begin
      if FCurrentFrame = 1 then
        begin
        LoadBackground;
        end;
      StretchBlt(dcBackground, 0, 0, Wid, Ht, dcImage, 0, 0, FW, FH, SrcInvert);
      StretchBlt(dcBackground, 0, 0, Wid, Ht, dcImageMask, 0, 0, FW, FH, SrcAnd);
      StretchBlt(dcBackground, 0, 0, Wid, Ht, dcImage, 0, 0, FW, FH, SrcPaint);
      BitBlt(dc, X, Y, Wid, Ht, dcBackground, 0, 0, SrcCopy);
      end
    else
      begin   {dtToBackground and transparent}
      StretchBlt(dc, X, Y, Wid, Ht, dcImage, 0, 0, FW, FH, SrcInvert);
      StretchBlt(dc, X, Y, Wid, Ht, dcImageMask, 0, 0, FW, FH, SrcAnd);
      StretchBlt(dc, X, Y, Wid, Ht, dcImage, 0, 0, FW, FH, SrcPaint);
      end;
    end
  else
    begin  { not Transparent }
    StretchBlt(dc, X, Y, Wid, Ht, dcImage, 0, 0, FW, FH, SrcCopy);
    end;
  end;
end;

{----------------TGifImage.CheckTime}
procedure TGifImage.CheckTime(WinHandle: THandle);
var
  ThisTime: LongInt;
  ARect: TRect;
begin
  if not FAnimate or FEmpty
      or HaveInfoOnly then Exit;
  ThisTime := timeGetTime;
  if ThisTime - LastTime < CurrentInterval then
     Exit;

  LastTime := ThisTime;

  if (FLoop = False) and (FNumIterations > 0) and (FCurrentFrame = FNumFrames) then
    begin
    if CurrentIteration >= FNumIterations then
      begin
      SetAnimate(False);
      Exit;
      end;
    Inc(CurrentIteration);
    end;
  if not Fresh then begin
    RemoveBitmap(FCurrentFrame);
    Inc(FCurrentFrame);
    if (FCurrentFrame > FNumFrames) or (FCurrentFrame <= 0) then FCurrentFrame := 1;

    SetupBitmap;
    ARect := Rect(aLeft, aTop, aLeft+aWidth, aTop+aHeight);
    InvalidateRect(WinHandle, @ARect, True);
  end else
    Fresh := False;

  CurrentInterval := Maximum(MulDiv(Frames[FCurrentFrame]^.Delay, 100, FSpeed), 1);
end;

{----------------TGIFImage.SetAnimate}
procedure TGIFImage.SetAnimate(AAnimate: Boolean);
begin
  if AAnimate = FAnimate then Exit;

  FAnimate := AAnimate;
  CurrentIteration := 1;
  if AAnimate and (FNumFrames > 1) then
    begin
    CurrentInterval := Maximum(Frames[FCurrentFrame]^.Delay * 100 div FSpeed, 1);
    LastTime := timeGetTime;
    end;
end;

{----------------TGIFImage.SetCurrentFrame}
procedure TGIFImage.SetCurrentFrame(AFrame: Integer);
begin
  if AFrame = FCurrentFrame then Exit;

  RemoveBitmap(FCurrentFrame);
  if AFrame > FNumFrames then FCurrentFrame := 1
  else if AFrame < 1 then FCurrentFrame := FNumFrames
  else FCurrentFrame := AFrame;
  SetupBitmap;
end;

{----------------TGIFImage.SetVisible}
procedure TGIFImage.SetVisible(AVisible: Boolean);
begin
  if AVisible = FVisible then Exit;
  FVisible := AVisible;
end;

{----------------TGIFImage.GetMaskedBitmap:}
function TGIFImage.GetMaskedBitmap: TBitmap;
{This returns frame 1 with black in transparent area}
begin
  if FEmpty or HaveInfoOnly then begin
    Result := nil;
    Exit;
  end;

  if not Assigned(FMaskedBitmap) then
    begin
    FMaskedBitmap := TBitmap.Create;
    FMaskedBitmap.Assign(Frames[1]^.Image);
    end;
  Result := FMaskedBitmap;
end;

{----------------TGIFImage.GetMask:}
function TGIFImage.GetMask: TBitmap;
{This returns mask for frame 1.  Content is black, background is white}
begin
  if FEmpty or HaveInfoOnly or not IsTransparent then begin
    Result := nil;
    Exit;
  end;

  if not Assigned(FMask) then
    begin
    FMask := TBitmap.Create;
    FMask.Assign(Frames[1]^.ImageMask);
    end;
  Result := FMask;
end;

{----------------TGIFImage.GetBitmap}
function TGIFImage.GetBitmap: TBitmap;
var
  TmpColor: TColor;
begin
  if FEmpty or HaveInfoOnly then begin
    Result := nil;
    Exit;
  end;

  if not Assigned(FBitmap) then FBitmap := TBitmap.Create;
  Result := FBitmap;
  Result.Palette := CopyPalette(ThePalette);
  with Result do begin
    Width := Frames[1]^.Width;
    Height := Frames[1]^.Height;
    with Frames[1]^ do begin
      if IsTransparent then begin
        with BackgroundColor do
          TmpColor := LongInt(Blue) shl 16 or LongInt(Green) shl 8 or LongInt(Red);
        Canvas.Brush.Color := TmpColor;
        PatBlt(Canvas.Handle, 0, 0, Width, Height, PatCopy);
        BitBlt(Canvas.Handle, Left, Top, Width, Height, ImageMask.Canvas.Handle, 0, 0, SrcAnd);
        BitBlt(Canvas.Handle, Left, Top, Width, Height, Image.Canvas.Handle, 0, 0, SrcInvert);
      end else
        BitBlt(Canvas.Handle, Left, Top, Width, Height, Image.Canvas.Handle, 0, 0, SrcCopy);
    end;
  end;
end;

{----------------TGIFImage.Clear}
procedure TGIFImage.Clear;
var
  Lp: Integer;
begin
  FEmpty := True;
  if FNumFrames > 0 then for Lp := FNumFrames downto 1 do begin
    Frames[Lp]^.Free;
    Dispose(Frames[Lp]);
    Frames[Lp] := nil;
  end;
  MemStream.Position := 0;
  FNumFrames := 0;
  FCurrentFrame := 1;
  FNumIterations := 1;
  CurrentIteration := 1;
  Fresh := True;
  FBitsPerPixel := 0;
  FTransparent := False;
end;

procedure TGIFImage.ClearAll;
begin
  Clear;
  FBitmap.Free;
  FMaskedBitmap.Free;
  FMask.Free;
  if dcBackground <> 0 then begin
    DeleteObject(SelectObject(dcBackground, hBackground));
    DeleteDC(dcBackground);
    dcBackground := 0;
  end;
  if dcImageMask <> 0 then begin
    DeleteObject(SelectObject(dcImageMask, hImageMask));
    DeleteDC(dcImageMask);
    dcImageMask := 0;
  end;
  if dcImage <> 0 then begin
    DeleteObject(SelectObject(dcImage, hImage));
    DeleteDC(dcImage);
    dcImage := 0;
  end;
end;

{----------------TGIFImage.SetupBitmap}
procedure TGIFImage.SetupBitmap;
var
  OldChanging, OldMaskChanging: TNotifyEvent;
begin
  if HaveInfoOnly then Exit;

  with Frames[FCurrentFrame]^ do
    begin
    OldChanging := Image.Canvas.OnChanging;
    Image.Canvas.OnChanging := Nil;
    if IsTransparent then
      begin
      OldMaskChanging := ImageMask.Canvas.OnChanging;
      ImageMask.Canvas.OnChanging := Nil;
      end
    else OldMaskChanging := Nil;  {to keep warnings happy}

    if (DisposalMethod = dtToPrevious) then
      begin
      if FTransparent then
        BitBlt(PreviousImageMask.Canvas.Handle, 0, 0, Width, Height, dcImageMask, Left, Top, SrcCopy);
      BitBlt(PreviousImage.Canvas.Handle, 0, 0, Width, Height, dcImage, Left, Top, SrcCopy);
      end;
    if IsTransparent then
      begin
      BitBlt(dcImageMask, Left, Top, Image.Width, Image.Height, ImageMask.Canvas.Handle, 0, 0, SrcAnd);
      BitBlt(dcImage, Left, Top, Image.Width, Image.Height, ImageMask.Canvas.Handle, 0, 0, SrcAnd);
      BitBlt(dcImage, Left, Top, Image.Width, Image.Height, Image.Canvas.Handle, 0, 0, SrcInvert);
      end
    else
      begin
      if FTransparent then
        PatBlt(dcImageMask, Left, Top, Width, Height, BLACKNESS);
      BitBlt(dcImage, Left, Top, Width, Height, Image.Canvas.Handle, 0, 0, SrcCopy);
      end;
    Image.Canvas.OnChanging := OldChanging;
    if IsTransparent then
      ImageMask.Canvas.OnChanging := OldMaskChanging;
    end;
end;

{----------------TGIFImage.RemoveBitmap}
procedure TGIFImage.RemoveBitmap(AFrame: Integer);
begin
  if HaveInfoOnly then Exit;

  case Frames[AFrame]^.DisposalMethod of
    dtUndefined,
    dtDoNothing: {Do Nothing (Duh!)};
    dtToBackground:
      with Frames[AFrame]^ do
        begin
        if FTransparent then PatBlt(dcImageMask, Left, Top, Width, Height, WHITENESS);
        PatBlt(dcImage, Left, Top, Width, Height, BLACKNESS);
        end;
    dtToPrevious:
      with Frames[AFrame]^ do
        begin
        if FTransparent then
          BitBlt(dcImageMask, Left, Top, Width, Height, PreviousImageMask.Canvas.Handle, 0, 0, SrcCopy);
        BitBlt(dcImage, Left, Top, Width, Height, PreviousImage.Canvas.Handle, 0, 0, SrcCopy);
        end;
  end;
end;

{----------------TGIFImage.ReadGIF:}
function TGIFImage.ReadGIF: Boolean;
var
  GIFData, OldData: Pointer;
  TableSize, TmpInt: Integer;
  ScreenDescriptor: TScreenDescriptor;
  LastControlBlock: TGraphicExtension;
  LastComment, TmpStr: String;
  Lp: Integer;
  dcClientArea: HDC;
begin
  Result := False;
  Clear;
  FillChar(LastControlBlock, SizeOf(LastControlBlock), 0);

  GIFData := MemStream.Memory;

  try
    if TGIFHeader(GIFData^).ghSignature <> 'GIF' then Exit;
    IncPtr(GIFData, SizeOf(TGIFHeader));

    MoveX(GIFData^, ScreenDescriptor, SizeOf(ScreenDescriptor));
    IncPtr(GIFData, SizeOf(ScreenDescriptor));
    if (ScreenDescriptor.sdInfo and sdGlobalColorTable) = sdGlobalColorTable then begin
      FBitsPerPixel := (ScreenDescriptor.sdInfo and sdColorTableSize) + 1;
      TableSize := Pwr[FBitsPerPixel] * SizeOf(TRGBColor);
      MoveX(GIFData^, GlobalColorTable, TableSize);
      IncPtr(GIFData, TableSize);
    end else
      FillChar(GlobalColorTable, SizeOf(GlobalColorTable), 0);

    OldData := nil;
    while GIFData <> OldData do begin
      OldData := GIFData;
      case Byte(GIFData^) of

        idExtension {21h}: with TExtension(GIFData^) do begin
          case exLabel of
            lblApplication: begin
              IncPtr(GIFData, 2);
              with TAppExtension(GIFData^) do if (aeAppName = 'NETSCAPE') and (aeAppCode = '2.0') then begin
                IncPtr(GIFData, 13);
                FNumIterations := TLoopData(GIFData^).ldIterations;
                IncPtr(GIFData, 4);
              end else begin {Skip unknown App extensions}
                IncPtr(GIFData, TAppExtension(GIFData^).aeSize + 1);
                while TDataSubBlock(GIFData^).dbSize > 0 do IncPtr(GIFData, TDataSubBlock(GIFData^).dbSize + 1);
                IncPtr(GIFData, 1);
              end;
            end;
            lblGraphicControl: begin
              IncPtr(GIFData, 2);
              MoveX(GIFData^, LastControlBlock, SizeOf(LastControlBlock));
              IncPtr(GIFData, SizeOf(LastControlBlock));
            end;
            lblComment: begin
              IncPtr(GIFData, 2);
              LastComment := '';
              TmpInt := TDataSubBlock(GIFData^).dbSize;
              while TmpInt > 0 do begin
                {$IFNDEF Win32}
                  TmpStr[0] := Char(TmpInt);
                {$ELSE}
                  SetLength(TmpStr, TmpInt);
                {$ENDIF}
                MoveX(TDataSubBlock(GIFData^).dbData[1], TmpStr[1], TmpInt);
                LastComment := LastComment + TmpStr;
                IncPtr(GIFData, TmpInt + 1);
                TmpInt := TDataSubBlock(GIFData^).dbSize;
              end;
              IncPtr(GIFData, 1);
            end;
            lblPlainText: {Skip it} begin
              IncPtr(GIFData, 2);
              IncPtr(GIFData, TAppExtension(GIFData^).aeSize + 1);
              while TDataSubBlock(GIFData^).dbSize > 0 do IncPtr(GIFData, TDataSubBlock(GIFData^).dbSize + 1);
              IncPtr(GIFData, 1);
            end;
          end;
        end;

        idImage {2Ch}: begin
          if FNumFrames = MaxFrame then Break;
          Inc(FNumFrames);
          New(Frames[FNumFrames]);
          Frames[FNumFrames]^ := TgfFrame.Create(Self);
          Frames[FNumFrames]^.FDitherIt := FDitherIt;
          if not Frames[FNumFrames]^.ReadImage(GIFData, GlobalColorTable,
              LastControlBlock) then Break;

          with Frames[FNumFrames]^ do begin
            FBitsPerPixel := Maximum(ColorDepth, FBitsPerPixel);
            FTransparent := FTransparent or IsTransparent;
            Comment := LastComment;
          end;

          LastComment := '';
          FillChar(LastControlBlock, SizeOf(LastControlBlock), 0);
        end;

        idTrailer {3Bh}: begin
          Break;
        end;

      end; {case...}
    end; {while...}

    with ScreenDescriptor do begin
      FImageWidth := sdWidth;
      FImageHeight := sdHeight;
    end;
    for Lp := 1 to FNumFrames do with Frames[Lp]^ do begin
      FImageWidth := Maximum(FImageWidth, Left + Width);
      FImageHeight := Maximum(FImageHeight, Top + Height);
    end;
    if dcImage <> 0 then begin
      DeleteObject(SelectObject(dcImage, hImage));
      DeleteDC(dcImage);
      dcImage := 0;
    end;

    if not HaveInfoOnly then
      begin
      dcClientArea := GetDC(0);
      dcImage := CreateCompatibleDC(dcClientArea);
      hImage := SelectObject(dcImage, CreateCompatibleBitmap(dcClientArea, FImageWidth, FImageHeight));

      PatBlt(dcImage, 0, 0, FImageWidth, FImageHeight, BLACKNESS);
      if dcImageMask <> 0 then begin
        DeleteObject(SelectObject(dcImageMask, hImageMask));
        DeleteDC(dcImageMask);
        dcImageMask := 0;
      end;
      if FTransparent then
         begin
         dcImageMask := CreateCompatibleDC(dcClientArea);
         hImageMask := SelectObject(dcImageMask, CreateCompatibleBitmap(dcClientArea, FImageWidth, FImageHeight));
         PatBlt(dcImageMask, 0, 0, FImageWidth, FImageHeight, WHITENESS);
         end;
      ReleaseDC(0, dcClientArea);
      end;

    FAnimated := FNumFrames > 1;
    FEmpty := False;

    SetupBitmap;

  finally
    MemStream.Clear;
  end;
  Result := True;
end;

{----------------TGIFImage.LoadFromFile}
function TGIFImage.LoadFromFile(const GIFFileName: String): Boolean;
begin
try
  MemStream.LoadFromFile(GIFFileName);
  HaveInfoOnly := False;
  if not ReadGIF then Abort;
  Result := True;
except
  on Exception do begin
    Result := False;
    ClearAll;
  end;
end;
end;

{----------------TGIFImage.LoadFromStream}
function TGIFImage.LoadFromStream(Stream: TStream): Boolean;
begin
try
  MemStream.LoadFromStream(Stream);
  HaveInfoOnly := False;
  if not ReadGIF then Abort;
  Result := True;
except
  on Exception do begin
    Result := False;
    ClearAll;
  end;
end;
end;

{----------------TGIFImage.LoadInfoFromFile}
function TGIFImage.LoadInfoFromFile(const GIFFileName: String): Boolean;
begin
try
  MemStream.LoadFromFile(GIFFileName);
  HaveInfoOnly := True;
  if not ReadGIF then Abort;
  Result := True;
except
  on Exception do begin
    Result := False;
    ClearAll;
  end;
end;
end;

{----------------TGIFImage.LoadInfoFromStream}
function TGIFImage.LoadInfoFromStream(Stream: TStream): Boolean;
begin
  MemStream.LoadFromStream(Stream);
  try
    HaveInfoOnly := True;
    if not ReadGIF then Abort;
    Result := True;
  except
    on Exception do begin
      Result := False;
      ClearAll;
    end;
  end;
end;

{----------------TGIFImage.LoadFromResourceName}
function TGIFImage.LoadFromResourceName(Instance: THandle; const ResName: String): Boolean;
var
  {$IFDEF Win32}
    rcHandle: hRsrc;
    gmHandle: hGlobal;
  {$ELSE}
    rcHandle: THandle;
    gmHandle: THandle;
    Lp: Integer;
    Tmp: array[0..255] of Char;
  {$ENDIF}
  ResSize: LongInt;
  ResPtr: Pointer;
begin
  Result := False;

  {$IFDEF Win32}
    rcHandle := FindResource(Instance, PChar(UpperCase(ResName)), PChar('GIF'));
  {$ELSE}
    for Lp := 0 to Length(ResName) - 1 do Tmp[Lp] := UpCase(ResName[Lp + 1]);
    Tmp[Length(ResName)] := #0;
    rcHandle := FindResource(Instance, Tmp, 'GIF');
  {$ENDIF}
  if rcHandle = 0 then Exit;
  gmHandle := LoadResource(Instance, rcHandle);
  if gmHandle = 0 then Exit;
  ResSize := SizeOfResource(Instance, rcHandle);
  ResPtr := LockResource(gmHandle);

  with MemStream do begin
    SetSize(ResSize);
    MoveX(ResPtr^, Memory^, ResSize);
  end;
  FreeResource(gmHandle);

  try
    HaveInfoOnly := False;
    if not ReadGIF then Abort;
    Result := True;
  except
    on Exception do begin
      Result := False;
      ClearAll;
    end;
  end;
end;

{----------------TGIFImage.LoadFromResourceID}
function TGIFImage.LoadFromResourceID(Instance: THandle; const ResID: Integer): Boolean;
var
  {$IFDEF Win32}
    rcHandle: hRsrc;
    gmHandle: hGlobal;
  {$ELSE}
    rcHandle: THandle;
    gmHandle: THandle;
    Tmp: array[0..255] of Char;
  {$ENDIF}
  ResSize: LongInt;
  ResPtr: Pointer;
  TmpStr: String;
begin
  Result := False;

  TmpStr := '#' + IntToStr(ResID);
  {$IFDEF Win32}
    rcHandle := FindResource(Instance, PChar(TmpStr), PChar('GIF'));
  {$ELSE}
    MoveX(TmpStr[1], Tmp[0], Length(TmpStr));
    Tmp[Length(TmpStr)] := #0;
    rcHandle := FindResource(Instance, Tmp, 'GIF');
  {$ENDIF}
  if rcHandle = 0 then Exit;
  gmHandle := LoadResource(Instance, rcHandle);
  if gmHandle = 0 then Exit;
  ResSize := SizeOfResource(Instance, rcHandle);
  ResPtr := LockResource(gmHandle);

  with MemStream do begin
    SetSize(ResSize);
    MoveX(ResPtr^, Memory^, ResSize);
  end;
  FreeResource(gmHandle);

  try
    HaveInfoOnly := False;
    if not ReadGIF then Abort;
    Result := True;
  except
    on Exception do begin
      Result := False;
      ClearAll;
    end;
  end;
end;

{$else}  {Do nothing substitute when NoGIF defined}

interface

uses
{$IFNDEF Win32}
  WinTypes, WinProcs, 
{$ELSE}
  Windows,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, ExtCtrls;

type
  TGIFImage = class(TPersistent)
  private
    { Private declarations }
    FAnimated: Boolean;
    FCurrentFrame: Integer;
    FImageWidth: Integer;
    FImageHeight: Integer;
    FTransparent: Boolean;
    FVisible: Boolean;
    FNumFrames: integer;

    FAnimate: Boolean;

    procedure SetAnimate(AAnimate: Boolean);
    function GetMaskedBitmap: TBitmap;
    function GetMask: TBitmap;

  protected
    { Protected declarations }
  public
    ShowIt: boolean;
    IsCopy: boolean;   {set if this is a copy of one in Cache}
    Bitmap: TBitmap;

    { Public declarations }
    constructor CreateCopy(Item: TGIFImage);
    procedure Draw(Canvas: TCanvas; MasterList, Cell: TObject; X, Y, Wid, Ht: integer);
    property MaskedBitmap: TBitmap read GetMaskedBitmap;
    property Mask: TBitmap read GetMask;
    property IsAnimated: Boolean read FAnimated;
    property IsTransparent: Boolean read FTransparent;

    function LoadFromFile(const GIFFileName: String): Boolean;
    function LoadFromStream(Stream: TStream): Boolean;
    function LoadInfoFromFile(const GIFFileName: String): Boolean;
    function LoadInfoFromStream(Stream: TStream): Boolean;
    procedure CheckTime(WinHandle: THandle);

    property Width: integer read FImageWidth;
    property Height: integer read FImageHeight;
    property Animate: Boolean read FAnimate write SetAnimate;
    property CurrentFrame: Integer read FCurrentFrame write FCurrentFrame;
    property Visible: Boolean read FVisible write FVisible;
    property NumFrames: Integer read FNumFrames;
  end;

function CreateAGifFromStream(var NonAnimated: boolean;
              Stream: TMemoryStream): TGifImage;   
function CreateAGif(const Name: string; var NonAnimated: boolean): TGifImage;   

implementation

function CreateAGifFromStream(var NonAnimated: boolean;
              Stream: TMemoryStream): TGifImage;   
begin
Result := Nil;
end;

function CreateAGif(const Name: string; var NonAnimated: boolean): TGifImage;   
begin
Result := Nil;
end;

constructor TGIFImage.CreateCopy(Item: TGIFImage);
begin
inherited Create;
end;

{----------------TGIFImage.Draw}
procedure TGIFImage.Draw(Canvas: TCanvas; MasterList, Cell: TObject; X, Y, Wid, Ht: integer);
begin
end;

{----------------TGifImage.CheckTime}
procedure TGifImage.CheckTime(WinHandle: THandle);
begin
end;

{----------------TGIFImage.SetAnimate}
procedure TGIFImage.SetAnimate(AAnimate: Boolean);
begin
end;

{----------------TGIFImage.GetMaskedBitmap:}
function TGIFImage.GetMaskedBitmap: TBitmap;
begin
Result := nil;
end;

{----------------TGIFImage.GetMask:}
function TGIFImage.GetMask: TBitmap;
begin
Result := nil;
end;

{----------------TGIFImage.LoadFromFile}
function TGIFImage.LoadFromFile(const GIFFileName: String): Boolean;
begin
Result := False;
end;

{----------------TGIFImage.LoadFromStream}
function TGIFImage.LoadFromStream(Stream: TStream): Boolean;
begin
Result := False
end;

{----------------TGIFImage.LoadInfoFromFile}
function TGIFImage.LoadInfoFromFile(const GIFFileName: String): Boolean;
begin
Result := False;
end;

{----------------TGIFImage.LoadInfoFromStream}
function TGIFImage.LoadInfoFromStream(Stream: TStream): Boolean;
begin
Result := False;
end;

{$endif}

end.

