{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVCmHuff;

interface

type
  IOFuncType = function(var Buffer;
                            Amount: word): word;

  procedure Compress(InBits: byte;
                     MaxBits: byte;
                     IFunc: IOFuncType;
                     OFunc: IOFuncType);

  procedure Decompress(InBits: byte;
                       MaxBits: byte;
                       IFunc: IOFuncType;
                       OFunc: IOFuncType);

implementation

uses
  RVUtil;

const
  MaxCodes = 16384;
  HashNil = 65535;
  OutBufSize = 1024;
  InBufSize = 1024;

type
  HashByteArray = array[0..MaxCodes] of byte;
  HashWordArray = array[0..MaxCodes] of word;

var
  HighCode: word;
  MaxCodeBits: word;
  MaxCode: word;
  MaxMaxCode: word;
  CharBits: word;
  CodeBits: word;
  BitsLeft: word;
  OldBits: byte;
  NewBits: word;
  HashVal: ^HashByteArray;
  HashFirst: ^HashWordArray;
  HashNext: ^HashWordArray;
  HashPrefix: ^HashWordArray absolute HashFirst;
  HashLen: ^HashWordArray absolute HashNext;
  CodeStr: ^HashByteArray;
  OutBuf: array[0..OutBufSize - 1] of byte;
  OutPtr: word;
  InBuf: array[0..InBufSize - 1] of byte;
  InPtr: word;
  InMax: word;
  EndOfChar: boolean;
  ClearCode: word;
  EOICode: word;
  CompMode: boolean;
  OutputCC: boolean;
  Bytes: word;
  OutFunc: IOFuncType;
  InFunc: IOFuncType;

  procedure AddBitCode;

  var
    Mask: byte;
    DataBits: byte;
    Adjust: shortint;

  begin { AddBitCode }
    Mask := OldBits;
    DataBits := CodeBits;
    While DataBits > 0 do begin
      Adjust := BitsLeft - DataBits;
      If Adjust < 0 then begin
        DataBits := -Adjust;
        OutBuf[OutPtr] := Lo(NewBits shr DataBits) or Mask;
        Inc(OutPtr);
        BitsLeft := 8;
        Mask := 0;
      end else if Adjust = 0 then begin
        OutBuf[OutPtr] := Lo(NewBits) or Mask;
        Inc(OutPtr);
        BitsLeft := 8;
        OldBits := 0;
        Break;
      end else begin
        OldBits := Lo(NewBits shl Adjust) or Mask;
        BitsLeft := Adjust;
        Break;
      end; { else }
    end; { while }
  end;  { AddBitCode }

  function GetBitCode: word;

  var
    DataBits: byte;
    Adjust: shortint;

  begin { GetBitCode }
    Result := 0;
    DataBits := CodeBits;
    While DataBits > 0 do begin
      Adjust := BitsLeft - DataBits;
      If Adjust < 0 then begin // Get rest of byte
        DataBits := -Adjust;
        Result := Result or (word(OldBits) shl DataBits);
        OldBits := InBuf[InPtr];
        BitsLeft := 8;
        Inc(InPtr);
      end else if Adjust = 0 then begin
        Result := Result or OldBits;
        OldBits := InBuf[InPtr];
        BitsLeft := 8;
        Inc(InPtr);
        Break;
      end else begin
        Result := Result or (word(OldBits) shr Adjust);
        BitsLeft := Adjust;
        Adjust := 8 - Adjust;
        OldBits := ((OldBits shl Adjust) and $FF) shr Adjust;
        Break;
      end; { else }
    end; { while }
  end;  { GetBitCode }

  procedure InitHash;

  var
    I1: word;

  begin { InitHash }
    OutputCC := false;
    BitsLeft := 8;
    OutPtr := 0;
    MaxMaxCode := 1;
    For I1 := 1 to MaxCodeBits do begin
      MaxMaxCode := MaxMaxCode * 2;
    end; { for }
    GetMem(HashVal,MaxMaxCode);
    GetMem(HashFirst,2 * MaxMaxCode);
    GetMem(HashNext,2 * MaxMaxCode);
    InMax := InFunc(InBuf,InBufSize);
    EndOfChar := (InMax = 0);
    If CompMode then begin
      OldBits := 0;
      InPtr := 0;
    end else begin
      OldBits := InBuf[0];
      InPtr := 1;
    end; { else }
  end;  { InitHash }

  procedure InitStringTable;

  var
    I1: word;

  begin { InitStringTable }
    CodeBits := CharBits + 1;
    If CodeBits = 2 then begin
      CodeBits := 3;
    end; { if }
    MaxCode := 1;
    For I1 := 1 to CodeBits do begin
      MaxCode := MaxCode * 2;
    end; { for }
    HighCode := (MaxCode div 2) + 1;
    ClearCode := HighCode - 1;
    EOICode := HighCode;
    For I1 := 0 to HighCode do begin
      If CompMode then begin
        HashFirst^[I1] := HashNil;
        HashVal^[I1] := Lo(I1);
        HashNext^[I1] := HashNil;
      end else begin
        HashPrefix^[I1] := HashNil;
        HashVal^[I1] := Lo(I1);
        HashLen^[I1] := 1;
      end; { else }
    end; { for }
  end;  { InitStringTable }

  function CodeOf(Prefix: word;
                  InVal: byte): word;

  var
    I1: word;

  begin { CodeOf }
    If Prefix = HashNil then begin
      Result := InVal;
      Exit;
    end; { if }
    I1 := HashFirst^[Prefix];
    Result := HashNil;
    While I1 <> HashNil do begin
      If HashVal^[I1] > InVal then begin
        Exit;
      end else if HashVal^[I1] = InVal then begin
        Result := I1;
      end; { else }
      I1 := HashNext^[I1];
    end; { while }
  end;  { CodeOf }

  procedure PutCode(Code: word);

  begin { PutCode }
    NewBits := Code;
    AddBitCode;

    If OutPtr > (OutBufSize - 4) then begin
      Bytes := OutFunc(OutBuf,OutPtr);
      OutPtr := 0;
    end; { if }
  end;  { PutCode }

  procedure AddCode(Prefix: word;
                    Val: byte);

  var
    I1: word;
    I2: word;

  begin { AddCode }
    Inc(HighCode);
    If CompMode then begin
      If ((HighCode = MaxCode - 1) and (CodeBits = MaxCodeBits)) or
       (HighCode = MaxCode) then begin
        If CodeBits = MaxCodeBits then begin
          OutputCC := true;
        end else begin
          Inc(CodeBits);
          MaxCode := MaxCode * 2;
        end; { else }
      end; { if }
      HashFirst^[HighCode] := HashNil;
      HashVal^[HighCode] := Val;
      HashNext^[HighCode] := HashNil;
      I1 := HashFirst^[Prefix];
      If I1 = HashNil then begin
        HashFirst^[Prefix] := HighCode;
      end else begin
        I2 := HashNil;
        While (I1 <> HashNil) and (HashVal^[I1] < Val) do begin
          I2 := I1;
          I1 := HashNext^[I1];
        end; { while }
        If I2 <> HashNil then begin
          HashNext^[I2] := HighCode;
        end else begin
          HashFirst^[Prefix] := HighCode;
        end; { if }
        HashNext^[HighCode] := I1;
      end; { else }
    end else begin
      If HighCode = (MaxCode - 1) then begin
        If CodeBits = MaxCodeBits then begin
          RaveError({Trans-}'Hash Table overflow.');
        end else begin
          Inc(CodeBits);
          MaxCode := MaxCode * 2;
        end; { else }
      end; { if }
      HashFirst^[HighCode] := Prefix;
      HashVal^[HighCode] := Val;
      HashLen^[HighCode] := HashLen^[Prefix] + 1;
    end; { else }
  end;  { AddCode }

  function GetNextVal: byte;

  begin { GetNextVal }
    If (InPtr >= InMax) then begin
      InMax := InFunc(InBuf,InBufSize);
      InPtr := 0;
      EndOfChar := (InMax = 0);
    end; { if }
    Result := InBuf[InPtr];
    Inc(InPtr);
  end;  { GetNextVal }

  procedure Compress(InBits: byte;
                     MaxBits: byte;
                     IFunc: IOFuncType;
                     OFunc: IOFuncType);

  var
    Val : byte;
    Code: word;
    Last: word;

  begin { Compress }
    CharBits := InBits;
    MaxCodeBits := MaxBits;
    InFunc := IFunc;
    OutFunc := OFunc;
    CompMode := true;
    InitHash;
    InitStringTable;
    PutCode(ClearCode);
    Val := GetNextVal;
    Last := HashNil;
    While not EndOfChar do begin
      Code := CodeOf(Last,Val);
      If Code <> HashNil then begin
        Last := Code;
      end else begin
        PutCode(Last);
        AddCode(Last,Val);
        If OutputCC then begin
          OutputCC := false;
          PutCode(ClearCode);
          InitStringTable;
        end; { if }
        Last := Val;
      end; { else }
      Val := GetNextVal;
    end; { while }
    PutCode(Last);
    PutCode(EOICode);
    If BitsLeft < 8 then begin
      CodeBits := BitsLeft;
      PutCode(0);
    end; { if }
    Bytes := OutFunc(OutBuf,OutPtr);
    FreeMem(HashVal,MaxMaxCode);
    FreeMem(HashFirst,2 * MaxMaxCode);
    FreeMem(HashNext,2 * MaxMaxCode);
  end;  { Compress }

  function PutString(Code: word;
                     AddFirst: boolean): byte;

  var
    CodeLen: word;
    I1: word;
    I2: word;

  begin { PutString }
    CodeLen := HashLen^[Code];
    I2 := Code;
    For I1 := CodeLen downto 1 do begin
      CodeStr^[I1] := HashVal^[I2];
      I2 := HashFirst^[I2];
    end; { for }
    If AddFirst then begin
      Inc(CodeLen);
      CodeStr^[CodeLen] := CodeStr^[1];
    end; { if }
    I1 := 1;
    I2 := OutBufSize - OutPtr;
    While (CodeLen > I2) do begin
      If I2 > 0 then begin
        Move(CodeStr^[I1],OutBuf[OutPtr],I2);
      end; { if }
      CodeLen := CodeLen - I2;
      I1 := I1 + I2;
      Bytes := OutFunc(OutBuf,OutBufSize);
      OutPtr := 0;
      I2 := OutBufSize - OutPtr;
    end; { while }
    Move(CodeStr^[I1],OutBuf[OutPtr],CodeLen);
    OutPtr := OutPtr + CodeLen;
    Result := CodeStr^[1];
  end;  { PutString }

  function GetCode: word;

  var
    LeftOver: word;

  begin { GetCode }
    Repeat
      LeftOver := InMax - InPtr;
      If LeftOver < 4 then begin
        Move(InBuf[InPtr],InBuf,LeftOver);
        InMax := InFunc(InBuf[LeftOver],InBufSize - LeftOver) + LeftOver;
        InPtr := 0;
      end; { if }
      Result := GetBitCode;
      If Result = ClearCode then begin
        InitStringTable;
        OutputCC := true;
      end; { if }
    until (Result <> ClearCode) or (InMax = 0);
    EndOfChar := (InMax = 0) or (Result = EOICode);
  end;  { GetCode }

  procedure Decompress(InBits: byte;
                       MaxBits: byte;
                       IFunc: IOFuncType;
                       OFunc: IOFuncType);

  var
    Code: word;
    Last: word;
    FirstVal: byte;

  begin { Decompress }
    CharBits := InBits;
    MaxCodeBits := MaxBits;
    InFunc := IFunc;
    OutFunc := OFunc;
    CompMode := false;
    GetMem(CodeStr,MaxCodes);
    InitHash;
    InitStringTable;
    Code := 0;
    While not EndOfChar do begin
      Repeat
        If OutputCC then begin
          OutputCC := false;
          PutString(Code,false);
        end; { if }
        Last := Code;
        Code := GetCode;
      until not OutputCC;
      If not EndOfChar then begin
        If Code <= HighCode then begin
          FirstVal := PutString(Code,false);
        end else begin
          FirstVal := PutString(Last,true);
        end; { else }
        AddCode(Last,FirstVal);
      end; { if }
    end; { while }
    Bytes := OutFunc(OutBuf,OutPtr);
    FreeMem(HashVal,MaxMaxCode);
    FreeMem(HashFirst,2 * MaxMaxCode);
    FreeMem(HashNext,2 * MaxMaxCode);
    FreeMem(CodeStr,MaxMaxCode);
  end;  { Decompress }

end.
