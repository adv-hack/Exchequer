unit HexConverter;
{
  Class to encode binary data as a string of hex digits, and to decode hex
  digits back into binary data.

  Includes functions to encode and decode binary data from TImage components.
}
interface

uses SysUtils, Classes, ExtCtrls, oRepEngineManager;

type
  THexConverter = class(TComponent)
  public
    procedure Decode(HexString: string; Stream: TStream); overload;
    procedure Decode(HexString: string; Str: string); overload;
    procedure DecodeImage(HexString: string; Image: TImage);
    function Encode(Stream: TStream): string; overload;
    function Encode(Str: string): string; overload;
    function EncodeImage(const Image: TImage): string;
    procedure SplitToStrings(HexString: string; Strings: TStrings);
  end;

implementation

var
  Count: Integer = 1;

{ THexConverter }

procedure THexConverter.Decode(HexString: string; Stream: TStream);
{ Decodes the hex string, putting the binary results into the supplied
  stream. }
var
  CharPos: Integer;
  Hex: array[0..1] of Char;
  Buffer: array[0..0] of Char;
begin
  CharPos := 1;
  while CharPos <= Length(HexString) do
  begin
    Move(HexString[CharPos], Hex, 2);
    HexToBin(Hex, Buffer, 1);
    Stream.Write(Buffer, 1);
    CharPos := CharPos + 2;
    KeepResponding;
  end;
end;

procedure THexConverter.Decode(HexString, Str: string);
var
  CharPos: Integer;
  Hex: array[0..1] of Char;
  Buffer: array[0..0] of Char;
begin
  Str := '';
  CharPos := 1;
  while CharPos <= Length(HexString) do
  begin
    Move(HexString[CharPos], Hex, 2);
    HexToBin(Hex, Buffer, 1);
    Str := Str + Buffer;
    CharPos := CharPos + 2;
    KeepResponding;
  end;
end;

procedure THexConverter.DecodeImage(HexString: string; Image: TImage);
{ Decodes the hex string, which is assumed to be a bitmap image encoded into
  hex. }
var
  ImgStream: TMemoryStream;
begin
  ImgStream := TMemoryStream.Create;
  try
    Decode(HexString, ImgStream);
    ImgStream.Position := 0;
    Image.Picture.Bitmap.LoadFromStream(ImgStream);
  finally
    ImgStream.Free;
  end;
end;

function THexConverter.Encode(Stream: TStream): string;
{ Encodes the binary data from the stream, returning a string of hex digits. }
var
  ByteToConvert: Byte;
  Count: Byte;
begin
  Stream.Position := 0;
  Result := '';
  repeat
    Count := Stream.Read(ByteToConvert, 1);
    if (Count <> 0) then
    begin
      Result := Result + IntToHex(ByteToConvert, 2);
    end;
    KeepResponding;
  until Count = 0;
end;

function THexConverter.Encode(Str: string): string;
var
  Count: Byte;
begin
  Result := '';
  for Count := 1 to Length(Str) do
  begin
    Result := Result + IntToHex(Ord(Str[Count]), 2);
    KeepResponding;
  end;
end;

function THexConverter.EncodeImage(const Image: TImage): string;
{ Encodes the bitmap data of the image as hex digits, returning the result. }
var
  ImgStream: TMemoryStream;
begin
  ImgStream := TMemoryStream.Create;
  Result := '';
  try
    Image.Picture.Bitmap.SaveToStream(ImgStream);
    ImgStream.Position := 0;
    Result := Encode(ImgStream);
    Count := Count + 1;
  finally
    ImgStream.Free;
  end;
end;

procedure THexConverter.SplitToStrings(HexString: string;
  Strings: TStrings);
var
  CharPos: Integer;
begin
  Strings.Clear;
  CharPos := 1;
  while (CharPos <= Length(HexString)) do
  begin
    Strings.Add(Copy(HexString, CharPos, 64));
    CharPos := CharPos + 64;
    KeepResponding;
  end;
end;

end.
