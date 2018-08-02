unit Crypto;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Dialogs, SysUtils;

Function Encode (EncStr : ShortString) : ShortString;
Function EncodeKey (Const CryptKey : Integer; EncStr : ShortString) : ShortString;

Function Decode (EncStr : ShortString) : ShortString;
Function DecodeKey (Const CryptKey : Integer; EncStr : ShortString) : ShortString;

Procedure EncodeData (Const Ptr : Pointer; Const DataLen : SmallInt);
Procedure DecodeData (Const Ptr : Pointer; Const DataLen : SmallInt);

Procedure ChangeCryptoKey (Const NewKey : Integer);

Function ReverseString (Const Str : String) : String;

// HM 21/06/02: Added EncodeDataKey and DecodeDataKey
Procedure EncodeDataKey (Const CryptKey : Integer; Const Ptr : Pointer; Const DataLen : SmallInt);
Procedure DecodeDataKey (Const CryptKey : Integer; Const Ptr : Pointer; Const DataLen : SmallInt);

implementation

(*
Const
  Key = 23130;   {0101101001011010} {bit sequence to mask against}
                                    {change this for different people}
*)

Type
  EncBufferType = Array [1..255] Of Char;


Var
  Key : Integer = 23130;

{---------------------------------------------------------------------------}

Procedure ChangeCryptoKey (Const NewKey : Integer);
Begin { ChangeCryptoKey }
  Key := NewKey;
End; { ChangeCryptoKey }

{---------------------------------------------------------------------------}

{ Reverses all the bytes of a string to make hacking harder }
Function ReverseString (Const Str : String) : String;
Var
  I : SmallInt;
Begin { ReverseString }
  Result := '';

  If (Length(Str) > 0) Then
    For I := Length(Str) DownTo 1 Do
      Result := Result + Str[I];
End; { ReverseString }

{---------------------------------------------------------------------------}

Function EncodeKey (Const CryptKey : Integer; EncStr : ShortString) : ShortString;
var
  EncBuffer     : EncBufferType;
  BufLen        : Byte;
  sh, x, xx     : SmallInt;
  rot           : boolean;
begin
   If (Length(EncStr) > 0) Then Begin
     { Copy into buffer }
     BufLen := Length(EncStr);
     Move (EncStr[1], EncBuffer[1], BufLen);

     { Encode }
     rot := FALSE;
     sh := 1;
     for xx := 1 to BufLen do begin
        if(rot) then
           x := ord(EncBuffer[xx]) xor ((CryptKey shl sh) and $00FF)
         else
           x := ord(EncBuffer[xx]) xor ((CryptKey shr sh) and $00FF);
        sh := sh + 1;
        EncBuffer[xx] := chr(x);
        if(sh=9) then begin
           if(rot) then rot := FALSE else rot := TRUE;
           sh := 1;
        end;
     end;

     { Copy buffer into result }
     Result := EncStr;
     Move (EncBuffer[1], Result[1], BufLen);
   End { If }
   Else
     Result := '';
end;

{---------------------------------------------------------------------------}

Function Encode (EncStr : ShortString) : ShortString;
Begin { Encode }
  Result := EncodeKey (Key, EncStr);
End; { Encode }

{---------------------------------------------------------------------------}

Function DecodeKey (Const CryptKey : Integer; EncStr : ShortString) : ShortString;
var
  EncBuffer     : EncBufferType;
  BufLen        : Byte;
  sh, x, xx     : integer;
  rot           : boolean;
begin
   If (Length(EncStr) > 0) Then Begin
     { Copy into buffer }
     BufLen := Length(EncStr);
     Move (EncStr[1], EncBuffer[1], BufLen);

     { Encode }
     rot := FALSE;
     sh := 1;
     for xx := 1 to BufLen do begin
        if(rot) then
           x := ord(EncBuffer[xx]) xor ((CryptKey shl sh) and $00FF)
         else
           x := ord(EncBuffer[xx]) xor ((CryptKey shr sh) and $00FF);
        sh := sh + 1;
        EncBuffer[xx] := chr(x);
        if(sh=9) then begin
           if(rot) then rot := FALSE else rot := TRUE;
           sh := 1;
        end;
     end;

     { Copy buffer into result }
     Result := EncStr;
     Move (EncBuffer[1], Result[1], BufLen);
   End { If }
   Else
     Result := '';
end;

{---------------------------------------------------------------------------}

Function Decode (EncStr : ShortString) : ShortString;
begin
  Result := DecodeKey(Key, EncStr);
end;

{---------------------------------------------------------------------------}

Procedure EncodeData (Const Ptr : Pointer; Const DataLen : SmallInt);
Type
  DataArrayType = Array [1..10000] Of Char;
var
  EncBuffer      : ^DataArrayType;
  //EncBuffer     : EncBufferType;
  //BufLen        : Byte;
  sh, x, xx     : SmallInt;
  rot           : boolean;
Begin { EncodeData }
  { Check length of data to encode }
  If (DataLen <= SizeOf(DataArrayType)) Then Begin
    { Get pointer to array }
    EncBuffer := Ptr;

    { Encode Array }
    rot := FALSE;
    sh := 1;
    For xx := 1 To DataLen Do Begin
      If rot Then
         x := ord(EncBuffer[xx]) xor ((key shl sh) and $00FF)
       else
         x := ord(EncBuffer[xx]) xor ((key shr sh) and $00FF);

      sh := sh + 1;
      EncBuffer[xx] := chr(x);

      if(sh=9) then begin
         rot := Not rot;
         sh := 1;
      end;
    End; { For xx }
  End; { If }
End; { EncodeData }

{---------------------------------------------------------------------------}

Procedure DecodeData (Const Ptr : Pointer; Const DataLen : SmallInt);
Type
  DataArrayType = Array [1..10000] Of Char;
var
  EncBuffer      : ^DataArrayType;
  //EncBuffer     : EncBufferType;
  //BufLen        : Byte;
  sh, x, xx     : integer;
  rot           : boolean;
Begin { DecodeData }
  { Check length of data to encode }
  If (DataLen <= SizeOf(DataArrayType)) Then Begin
    { Get pointer to array }
    EncBuffer := Ptr;

    { Decode Array }
    rot := FALSE;
    sh := 1;
    For xx := 1 To DataLen Do Begin
       If rot Then
         x := ord(EncBuffer[xx]) xor ((key shl sh) and $00FF)
       Else
         x := ord(EncBuffer[xx]) xor ((key shr sh) and $00FF);

       sh := sh + 1;
       EncBuffer[xx] := chr(x);

       If (sh=9) Then Begin
         rot := Not rot;
         sh := 1;
       End; { If (sh=9) }
    End; { For xx }
  End; { If }
End; { DecodeData }

{---------------------------------------------------------------------------}

// HM 21/06/02: Added EncodeDataKey and DecodeDataKey
Procedure EncodeDataKey (Const CryptKey : Integer; Const Ptr : Pointer; Const DataLen : SmallInt);
Type
  DataArrayType = Array [1..10000] Of Char;
var
  EncBuffer      : ^DataArrayType;
  //EncBuffer     : EncBufferType;
  //BufLen        : Byte;
  sh, x, xx     : SmallInt;
  rot           : boolean;
Begin { EncodeDataKey }
  { Check length of data to encode }
  If (DataLen <= SizeOf(DataArrayType)) Then Begin
    { Get pointer to array }
    EncBuffer := Ptr;

    { Encode Array }
    rot := FALSE;
    sh := 1;
    For xx := 1 To DataLen Do Begin
      If rot Then
         x := ord(EncBuffer[xx]) xor ((CryptKey shl sh) and $00FF)
       else
         x := ord(EncBuffer[xx]) xor ((CryptKey shr sh) and $00FF);

      sh := sh + 1;
      EncBuffer[xx] := chr(x);

      if(sh=9) then begin
         rot := Not rot;
         sh := 1;
      end;
    End; { For xx }
  End; { If }
End; { EncodeDataKey }

{---------------------------------------------------------------------------}

Procedure DecodeDataKey (Const CryptKey : Integer; Const Ptr : Pointer; Const DataLen : SmallInt);
Type
  DataArrayType = Array [1..10000] Of Char;
var
  EncBuffer      : ^DataArrayType;
  //EncBuffer     : EncBufferType;
  //BufLen        : Byte;
  sh, x, xx     : integer;
  rot           : boolean;
Begin { DecodeDataKey }
  { Check length of data to encode }
  If (DataLen <= SizeOf(DataArrayType)) Then Begin
    { Get pointer to array }
    EncBuffer := Ptr;

    { Decode Array }
    rot := FALSE;
    sh := 1;
    For xx := 1 To DataLen Do Begin
       If rot Then
         x := ord(EncBuffer[xx]) xor ((CryptKey shl sh) and $00FF)
       Else
         x := ord(EncBuffer[xx]) xor ((CryptKey shr sh) and $00FF);

       sh := sh + 1;
       EncBuffer[xx] := chr(x);

       If (sh=9) Then Begin
         rot := Not rot;
         sh := 1;
       End; { If (sh=9) }
    End; { For xx }
  End; { If }
End; { DecodeDataKey }

{---------------------------------------------------------------------------}

end.
