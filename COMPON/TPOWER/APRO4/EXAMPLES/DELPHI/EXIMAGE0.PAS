{*********************************************************}
{*                    EXIMAGE0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*Takes a .tif or a .pcx and converts to an .apf file for*}
{*        faxing using an ApdFaxConverter.               *}
{*********************************************************}

unit ExImage0;

interface

uses
  WinTypes,
  WinProcs,
  SysUtils,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  Buttons,
  AdFaxCvt,
  OoMisc,
  AdMeter;

const
  AssumedLineLen = 256;
  Increment      = 20;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    LoadBtn: TSpeedButton;
    Label1: TLabel;
    Image: TImage;
    OpenDialog: TOpenDialog;
    FaxCvt: TApdFaxConverter;
    procedure LoadBtnClick(Sender: TObject);
    procedure FaxCvtStatus(F: TObject; Starting, Ending: Boolean;
      PagesConverted, LinesConverted: Integer; BytesConverted,
      BytesToConvert: Longint; var Abort: Boolean);
  private
    { Private declarations }
    Progress: TApdMeter;
  public
    FName      : String;
    Ext        : String;
    LineHandle : THandle;
    LineData   : Pointer;
    BmpWidth   : Integer;
    BmpHeight  : LongInt;
    NumPages   : LongInt;
    EndOfPage  : Boolean;
    MorePages  : Boolean;
    LineLen    : Integer;
    ImgData    : array[0..MaxData - 1] of Byte;

    constructor Create(AComponent : TComponent); override;
    procedure PutLine;
    procedure PackTheBitmap;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

constructor TMainForm.Create(AComponent : TComponent);
begin
	inherited Create(AComponent);
  Progress        := TApdMeter.Create(Self);
  Progress.Parent := Self;
  Progress.Left   := 256;
  Progress.Top    := 8;
  Progress.Width  := 100;
  Progress.Height := 24;
end;

procedure TMainForm.PackTheBitmap;
var
  I         : LongInt;
  W         : Cardinal;
  Src       : PByteArray;
  Dest      : PByteArray;
  NewHandle : THandle;
  Pad       : Boolean;

begin
  W   := BmpWidth;
  Pad := Odd(BmpWidth);
  if Pad then
    Inc(W);

  for I := 1 to Pred(BmpHeight) do begin
    Src  := GetPtr(LineData, I * AssumedLineLen);
    Dest := GetPtr(LineData, I * W);

    {$IFNDEF Win32}
    hmemcpy(Dest, Src, BmpWidth);
    if Pad then
      Byte(GetPtr(LineData, (I * W) + BmpWidth)^) := $00;
    {$ELSE}
    Move(Src^, Dest^, BmpWidth);
    if Pad then
      Dest^[BmpWidth] := $00;
    {$ENDIF}
  end;

  BmpWidth := W;

  {reallocate the bitmap buffer}
  GlobalUnlock(LineHandle);
  NewHandle := GlobalRealloc(LineHandle, LongInt(BmpWidth) * BmpHeight, gmem_ZeroInit);
  if (NewHandle = 0) then
    raise EOutOfMemory.Create('Insufficient memory');
  LineHandle := NewHandle;
  LineData   := GlobalLock(LineHandle);
end;

procedure TMainForm.LoadBtnClick(Sender: TObject);
var
  BmpHandle : HBitmap;
  Bmp       : TBitmap;
  R         : TRect;

begin
  {get a file name from the user}
  if not OpenDialog.Execute then
    Exit;
  FName := LowerCase(OpenDialog.FileName);

  {find the extension of the input file}
  Ext := ExtractFileExt(FName);

  {is this an extension we recognize?}
  if (Ext = '.tif') then
    FaxCvt.InputDocumentType := idTiff
  else if (Ext = '.pcx') then
    FaxCvt.InputDocumentType := idPcx
  else begin
    MessageDlg('Unrecognized file extension "' + Ext +
      '". This example can only deal with TIFF, PCX, and BMP files.', mtError, [mbOK], 0);
    Exit;
  end;
  FaxCvt.DocumentFile := FName;

  {allocate memory for the first few lines of the bitmap}
  LineHandle := GlobalAlloc(gmem_Moveable or gmem_ZeroInit,
    AssumedLineLen * Increment);
  if (LineHandle = 0) then begin
    FaxCvt.CloseFile;
    raise EOutOfMemory.Create('Insufficient memory');
  end;
  LineData  := GlobalLock(LineHandle);
  BmpWidth  := 0;
  BmpHeight := 0;
  NumPages  := 1;

  {open the input file}
  try
    FaxCvt.OpenFile;
  except
    GlobalUnlock(LineHandle);
    GlobalFree(LineHandle);
    raise;
  end;

  {convert the data}
  try
    repeat
      FaxCvt.GetRasterLine(ImgData, LineLen, EndOfPage, MorePages);
      if not EndOfPage then
        PutLine;
    until EndOfPage;
  except
    GlobalUnlock(LineHandle);
    GlobalFree(LineHandle);
    raise;
  end;

  {pack the bitmap into smaller lines}
  try
    PackTheBitmap;

    {create bitmap handle}
    BmpHandle := CreateBitmap(BmpWidth * 8, BmpHeight, 1, 1, LineData);
    if (BmpHandle = 0) then
      raise Exception.Create('CreateBitmap failed');
  finally
    GlobalUnlock(LineHandle);
    GlobalFree(LineHandle);
  end;

  {create bitmap class}
  Bmp := TBitmap.Create;
  Bmp.Handle := BmpHandle;

  {invert the bitmap because windows stores colors backwards}
  R.Left   := 0;
  R.Right  := Pred(Bmp.Width);
  R.Top    := 0;
  R.Bottom := Pred(Bmp.Height);
  InvertRect(Bmp.Canvas.Handle, R);

  {show the bitmap}
  Image.Picture.Bitmap := Bmp;
  Bmp.Free;
end;

{$IFNDEF Win32}
function ActualLineLen(var Data; Len : Cardinal) : Cardinal; assembler;
  {-return actual length, in bytes, of a raster line}
asm
  les   di,Data
  add   di,Len
  dec   di
  xor   ax,ax
  mov   cx,Len
  std
  repe  scasb
  je    @1
  mov   ax,cx
  inc   ax
@1:
  cld
end;
{$ELSE}
function ActualLineLen(var Data; Len : Cardinal) : Cardinal; assembler; register;
  {-return actual length, in bytes, of a raster line}
asm
  push  edi

  mov   edi,eax       {eax = Data}
  add   edi,edx       {edx = Len}
  dec   edi
  xor   eax,eax
  mov   ecx,edx
  std
  repe  scasb
  je    @1
  mov   eax,ecx
  inc   eax
@1:
  cld

  pop   edi
end;
{$ENDIF}

procedure TMainForm.PutLine;
var
  NewHandle : THandle;
  Offset    : LongInt;
  Wid       : Integer;

begin
  if EndOfPage then
    Exit;

  if (BmpHeight <> 0) and ((BmpHeight mod Increment) = 0) then begin
    {reallocate the buffer}
    Inc(NumPages);
    GlobalUnlock(Handle);
    GlobalUnlock(LineHandle);
    NewHandle := GlobalRealloc(LineHandle,
      AssumedLineLen * Increment * NumPages, gmem_ZeroInit);
    if (NewHandle = 0) then
      raise EOutOfMemory.Create('Insufficient memory');

    LineData   := GlobalLock(NewHandle);
    LineHandle := NewHandle;
  end;

  Offset := BmpHeight * AssumedLineLen;

  {$IFNDEF Win32}
  hmemcpy(GetPtr(LineData, Offset), @ImgData, LineLen);
  {$ELSE}
  Move(ImgData, GetPtr(LineData, Offset)^, LineLen);
  {$ENDIF}

  Inc(BmpHeight);
  Wid := ActualLineLen(ImgData, LineLen);
  if (Wid > BmpWidth) then
    BmpWidth := Wid;
end;

procedure TMainForm.FaxCvtStatus(F: TObject; Starting,
  Ending: Boolean; PagesConverted, LinesConverted: Integer; BytesConverted,
  BytesToConvert: Longint; var Abort: Boolean);
begin
  if (BytesToConvert <> 0) then
    Progress.Position := (BytesConverted * 100) div BytesToConvert
  else
    Progress.Position := 0;
end;

end.

