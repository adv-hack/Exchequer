
{*******************************************************}
{                                                       }
{       RichView                                        }
{       Basic string types and string-related functions }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}


unit RVTypes;

{$I RV_Defs.inc}

interface

uses Windows, SysUtils
  {$IFDEF RICHVIEWDEF4}, SysConst{$ENDIF};

type
{$IFDEF RVUNICODESTR}
  TRVAnsiString = type AnsiString;
  TRVUnicodeString = type UnicodeString;
  TRVAnsiChar = AnsiChar;
  TRVUnicodeChar = WideChar;
  PRVAnsiChar = PAnsiChar;
  PRVUnicodeChar = PWideChar;
  TRVRawByteString = type RawByteString;
{$ELSE}
  TRVAnsiString = type String;
  TRVUnicodeString = type WideString;
  TRVAnsiChar = Char;
  TRVUnicodeChar = WideChar;
  PRVAnsiChar = PChar;
  PRVUnicodeChar = PWideChar;
  TRVRawByteString = type String;
{$ENDIF}

  function RVFloatToStr(Value: Extended): TRVAnsiString;
  function RVStrToFloat(const S: TRVAnsiString): Extended;
  function RVIntToStr(Value: Integer): TRVAnsiString;
  function RVIntToHex(Value: Integer; Digits: Integer): TRVAnsiString;
  function RVStrToInt(Value: TRVAnsiString): Integer;
  function RVStrToIntDef(Value: TRVAnsiString; Default: Integer): Integer;
  function RVPos(const substr, str: TRVAnsiString): Integer;

implementation

function RVFloatToStr(Value: Extended): TRVAnsiString;
var
  Buffer: array[0..63] of TRVAnsiChar;
begin
  SetString(Result, Buffer, FloatToText(Buffer, Value, fvExtended,
    ffGeneral, 15, 0));
end;

{$IFDEF RICHVIEWDEF6}
procedure ConvertErrorFmt(ResString: PResStringRec; const Args: array of const);
begin
  raise EConvertError.CreateResFmt(ResString, Args);
end;
{$ELSE}
procedure ConvertErrorFmt(const Ident: string; const Args: array of const);
begin
  raise EConvertError.CreateFmt(Ident, Args);
end;
{$ENDIF}



function RVStrToFloat(const S: TRVAnsiString): Extended;
begin
  if not TextToFloat(PRVAnsiChar(S), Result, fvExtended) then
    ConvertErrorFmt({$IFDEF RICHVIEWDEF6}@{$ENDIF}SInvalidFloat, [S]);
end;

procedure CvtInt;
{ IN:
    EAX:  The integer value to be converted to text
    ESI:  Ptr to the right-hand side of the output buffer:  LEA ESI, StrBuf[16]
    ECX:  Base for conversion: 0 for signed decimal, 10 or 16 for unsigned
    EDX:  Precision: zero padded minimum field width
  OUT:
    ESI:  Ptr to start of converted text (not start of buffer)
    ECX:  Length of converted text
}
asm
        OR      CL,CL
        JNZ     @CvtLoop
@C1:    OR      EAX,EAX
        JNS     @C2
        NEG     EAX
        CALL    @C2
        MOV     AL,'-'
        INC     ECX
        DEC     ESI
        MOV     [ESI],AL
        RET
@C2:    MOV     ECX,10

@CvtLoop:
        PUSH    EDX
        PUSH    ESI
@D1:    XOR     EDX,EDX
        DIV     ECX
        DEC     ESI
        ADD     DL,'0'
        CMP     DL,'0'+10
        JB      @D2
        ADD     DL,('A'-'0')-10
@D2:    MOV     [ESI],DL
        OR      EAX,EAX
        JNE     @D1
        POP     ECX
        POP     EDX
        SUB     ECX,ESI
        SUB     EDX,ECX
        JBE     @D5
        ADD     ECX,EDX
        MOV     AL,'0'
        SUB     ESI,EDX
        JMP     @z
@zloop: MOV     [ESI+EDX],AL
@z:     DEC     EDX
        JNZ     @zloop
        MOV     [ESI],AL
@D5:
end;

function RVIntToStr(Value: Integer): TRVAnsiString;
//  FmtStr(Result, '%d', [Value]);
asm
        PUSH    ESI
        MOV     ESI, ESP
        SUB     ESP, 16
        XOR     ECX, ECX       // base: 0 for signed decimal
        PUSH    EDX            // result ptr
        XOR     EDX, EDX       // zero filled field width: 0 for no leading zeros
        CALL    CvtInt
        MOV     EDX, ESI
        POP     EAX            // result ptr
        {$IFDEF RVUNICODESTR}
        PUSH    0
        {$ENDIF}
        CALL    System.@LStrFromPCharLen
        ADD     ESP, 16
        POP     ESI
end;

function RVIntToHex(Value: Integer; Digits: Integer): TRVAnsiString;
//  FmtStr(Result, '%.*x', [Digits, Value]);
asm
        CMP     EDX, 32        // Digits < buffer length?
        JBE     @A1
        XOR     EDX, EDX
@A1:    PUSH    ESI
        MOV     ESI, ESP
        SUB     ESP, 32
        PUSH    ECX            // result ptr
        MOV     ECX, 16        // base 16     EDX = Digits = field width
        CALL    CvtInt
        MOV     EDX, ESI
        POP     EAX            // result ptr
        {$IFDEF RVUNICODESTR}
        PUSH    0
        {$ENDIF}
        CALL    System.@LStrFromPCharLen
        ADD     ESP, 32
        POP     ESI
end;

function RVStrToInt(Value: TRVAnsiString): Integer;
begin
  {$IFDEF RVUNICODESTR}
  Result := StrToInt(String(Value));
  {$ELSE}
  Result := StrToInt(Value);
  {$ENDIF}
end;

function RVStrToIntDef(Value: TRVAnsiString; Default: Integer): Integer;
begin
  {$IFDEF RVUNICODESTR}
  Result := StrToIntDef(String(Value), Default);
  {$ELSE}
  Result := StrToIntDef(Value, Default);
  {$ENDIF}
end;

function RVPos(const substr, str: TRVAnsiString): Integer;
var p, pstart: PRVAnsiChar;
begin
  pstart := PRVAnsiChar(str);
  if Length(substr)=1 then
    p := StrScan(pstart, substr[1])
  else
    p := StrPos(pstart, PRVAnsiChar(substr));
  if p=nil then
    Result := 0
  else begin
    Result := p-pstart+1;
    if Result=Length(str)+1 then
      Result := 0;
  end;
end;


end.
