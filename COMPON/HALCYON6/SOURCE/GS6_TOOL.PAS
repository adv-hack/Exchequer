unit gs6_tool;
{-----------------------------------------------------------------------------
                          Generic Tool Routines

       gsd6tool Copyright (c) 1998 Griffin Solutions, Inc.

       Date
          22 May 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit contains routines for string manipulation, unique
       names, and other generic requirements

   Changes:

------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   SysHalc,
   SysUtils,
   Classes,
   gs6_cnst,
   gs6_glbl;

type

   TgsVariantType = (gsvtUnknown,gsvtText,gsvtFloat,gsvtDate,gsvtBoolean,gsvtBinary);

   TgsCollection = class(TList)
   (*The TgsCollection class extends the TList class to automatically free all
    objects in the list when the list is destroyed*)
      destructor  Destroy; override;
      (*Calls FreeAll to ensure all list items are freed.  Inherited destructor
       is then called*)
      procedure   FreeOne(Item: Pointer);
      (*Deletes Item in the list and frees the item*)
      procedure   FreeAll;
      (*Frees all items in the list and sets Count to 0*)
      procedure   FreeItem(Item: Pointer); virtual;
      (*Calls TObject(Item).Free to free the item*)
   end;

   TgsVariant = class(TObject)
   (*The TgsVariant class provides an object that can store data in several
     formats and allow comparison and conversion of the stored data.  This
     is used instead of the Variant type to ensure portability to other
     compilers and extend the flexibility of usage.*)
   private
      VarBuf   : gsptrByteArray;
      SizeBuf  : integer;
      SizeVar  : integer;
      TypeVar  : TgsVariantType;
   protected
      procedure CheckBuffer(NewSize: integer);
   public
      constructor Create(Size: word);
      (*Called to create the object.  Size contains the initial size to be
        assigned to the buffer.  If zero, the buffer is nil initially.  You
        can assign an initial length that is then used as the buffer length
        until a larger length is required to fit inserted data.  By using an
        initial buffer large enough for the largest possible entry, you avoid
        multiple memory allocation/release calls.*)
      destructor Destroy; override;
      (*Frees any assigned buffer and calls the inherited destructor.*)
      function Assign(Source: TgsVariant): boolean;
      (*Duplicates the contents of the Source TgsVariant into itself.*)
      procedure Clear;
      (*Clears all values.  Frees its buffer and sets it to nil, sets length
        to zero, and type to vtUnknown*)
      function CompareBin(Target: TgsVariant; var EndPos: integer; IfPartial: integer;
                       CollateTable: pointer): integer;
      function Compare(Target: TgsVariant; var EndPos: integer; IfPartial: integer;
                       CollateTable: pointer): integer;
      (*Compares its contents to that of the Target.  Both must be of the same
        type or Binary else an exception will be raised.  On return Result will
        be 0 if the two contents are equal, negative (<0) if Target is greater
        than Self, or positive (>0) if Self is greater than Target.  For Text
        or Binary type compares, EndPos will contain the location in the array
        where the compare failed, or Length+1 if the compare was equal.*)
      function GetBoolean: boolean;
      (*Returns the object contents as a boolean result.  If data type is
        Binary or Boolean, the boolean value is returned fron the buffer.
        if type is Date, false is returned.  If Float, then False is returned
        if the value is 0, otherwise True is returned.  For Text, True is
        returned if the first position of the buffer contains T,t,Y,y,J,or j,
        False otherwise.*)
      function GetBinary(ABuffer: pointer; ALength: integer): pointer;
      (*Copies the contents of the buffer to the address in ABuffer for a
        maximum of ALength bytes.  On reture, if the buffer is empty, then
        Result is nil, otherwise ABuffer is returned as Result*)
      function GetDate: longint;
      (*Returns the date as a longint Julian date value.  If the buffer is
        empty or the type is Boolean, 0 will be returned.  If type is Float,
        the Float value will be truncated to a longint and returned.  If type
        is Text then a string to date conversion is done and an exception
        raised if it is invalid.  If type is Date or Binary then the buffer
        value is returned as a longint.*)
      function GetFloat: FloatNum;
      (*Returns the float value of the buffer.  If the buffer is empty, 0 is
        returned.  If type is Boolean, 0 is returned for false, 1 is returned
        for true.  If type is Date, the Julian Date is returned.  If type is
        Text, a string to float conversion is performed and an exception is
        raised if the conversion is unsuccessful.  If type is Binary or
        Float, the buffer value is returned as a float type.*)
      function GetPChar(APChar: PChar): PChar;
      (*Returns the buffer as a zero-terminated string.  APChar must be large
        enough to hold the string plus the zero termination character.  If
        type is Boolean, 'T' is returned for true, 'F' is returned for false.
        If type is Date, the date is returned as a string based on the
        ShortDateFormat.  If type is Float, the value is returned by a float
        to string conversion.  If type is Binary or Text, the buffer is copied
        to APChar and terminated with a zero.*)
      function GetString: string;
      (*Returns the buffer as a string.  If type is Boolean, 'T' is returned
        for true, 'F' is returned for false.  If type is Date, the date is
        returned as a string based on the ShortDateFormat.  If type is Float,
        the value is returned by a float to string conversion.  If type is
        Binary or Text, the buffer is copied to Result.  Maximum string length
        is 255 for 16-bit compilers, 64K for 32-bit compilers*)
      procedure PutBoolean(ABool: boolean);
      (*Stores the ABool value in the buffer and sets the length to
        SizeOf(boolean).*)
      procedure PutBinary(ABuffer: pointer; ALength: integer);
      (*Places ABuffer in the buffer for ALength bytes.  If the buffer is not
        at least ALength bytes, a new buffer is allocated and the old one
        released.  the length is set to ALength.*)
      procedure PutDate(ADate: longint);
      (*Stores ADate in the buffer and sets the length to SizeOf(longint).*)
      procedure PutFloat(AFloat: FloatNum);
      (*Stores AFloat in the buffer and sets the length to SizeOf(FloatNum).*)
      procedure PutPChar(APChar: PChar);
      (*Stores the APChar array in the buffer and sets the length to
        StrLen(APChar).  A new buffer is allocated and the old one released if
        the new length is greater than the old buffer size.*)
      procedure PutString(const AString: string);
      (*Stores AString in the buffer and sets the length to length(AString).
        A new buffer is allocated and the old one released if the new length
        is greater than the old buffer size.*)
      procedure AppendBinary(ABuffer: pointer; ALength: integer);
      (*Appends the ABuffer array to the current buffer string and sets the
        length to length + ALength.  A new buffer is allocated and the old one
        released if the new length is greater than the old buffer size.  If
        the variant type is not vtText or vtBinary an exception is raised*)
      procedure AppendPChar(APChar: PChar);
      (*Appends the APChar array to the current buffer string and sets the
        length to length + StrLen(APChar).  A new buffer is allocated and
        the old one released if the new length is greater than the old buffer
        size.  If the variant type is not vtText or vtBinary an exception is
        raised*)
      procedure AppendString(const AString: string);
      (*Appends AString to the current buffer string and sets the length to
        length + length(AString).  A new buffer is allocated and the old one
        released if the new length is greater than the old buffer size.  If
        the variant type is not vtText or vtBinary an exception is raised*)
      procedure LowerCase(LowerTable: pointer);
      (*Converts a buffer of type Text to all lowercase characters.  If type
        is not Text, nothing is done.*)
      procedure UpperCase(UpperTable: pointer);
      (*Converts a buffer of type Text to all uppercase characters.  If type
        is not Text, nothing is done.*)
      procedure PadL(len: integer);
      (*Pads leading spaces to fill a buffer of type Text .  The  buffer will
        have a length of 'len' when complete.  If type is not Text, nothing is
        done.*)
      procedure PadR(len: integer);
      (*Pads trailing spaces to fill a buffer of type Text .  The  buffer will
        have a length of 'len' when complete.  If type is not Text, nothing is
        done.*)
      procedure TrimL;
      (*Trims all leading spaces from a buffer of type Text .  If type is not
        Text, nothing is done.*)
      procedure TrimR;
      (*Trims all trailing spaces from a buffer of type Text .  If type is not
        Text, nothing is done.*)
      property Memory: gsptrByteArray read VarBuf;
      (*Contains the address of the buffer (or nil if no buffer assigned) so
        it can be addressed as an array of byte.*)
      property SizeOfBuf: integer read SizeBuf;
      (*Contains the size of the allocated buffer.*)
      property SizeOfVar: integer read SizeVar write SizeVar;
      (*Contains the length of the data stored in the buffer.  This can be
        less than the length of the buffer.*)
      property TypeOfVar: TgsVariantType read TypeVar write TypeVar;
      (*Contains the type of the data in the buffer.*)
   end;

   TgsHugeSet = class(TObject)
   (*This class is designed to be a collection of bits, one for every possible
     item in the item range.  Values start a 0..highest item.  Each item can
     be flagged using this class.  This was designed to maintain the set of
     records in a database that were valid for a filter condition.*)
   private
      FSetList: TList;
      FHighestBit: longint;
   public
      constructor Create;
      destructor  Destroy; override;
      procedure   Clear;
      (*Clears all bits in the HugeSet.*)
      procedure   ChangeBit(Bit: longint; Value: byte);
      (*Changes the Item status at locaton Bit based on the contents of Value.
        If Value is 0, the flag is set false, if 1, the flag is set true, and
        if 2, the flag is toggled.*)
      function    BitValue(Bit: longint): boolean;
      (*Returns the flag condition for the iten at Bit location.*)
      property    Highest: longint read FHighestBit;
      (*Highest item counr that was flagged/cleared in the list.*)
      property    SetList: TList read FSetList; 
   end;

Function SearchBuf(var Pattern, Source; StartPos, PatLen, SrcLen: integer): integer;
Function SearchBufI(var Pattern, Source; StartPos, PatLen, SrcLen: integer): integer;
Function ChangeFileExtEmpty(const FileName, Extension: String): String;
Function ExtractFileNameOnly(const FileName: String): String;
Procedure Byte2Hex(byt: byte; var ch1, ch2: char);
procedure Hex2Byte(var byt: byte; ch1, ch2: char);
function CmprIntegers(V1, V2: longint): integer;
function PadL(const strn : String; lth : integer) : String;
function PadR(const strn : String; lth : integer) : String;
procedure StrPadR(s: PChar; c: char; n: integer);
Function Strip_Flip(const st : String): String;

function Unique_Field : String;     {Used to create a unique 8-byte String}

implementation
uses
   gs6_date;


const
   SetBitArray: array[0..7] of byte = ($01,$02,$04,$08,$10,$20,$40,$80);
   ClearBitArray: array[0..7] of byte = ($FE,$FD,$FB,$F7,$EF,$DF,$BF,$7F);

{------------------------------------------------------------------------------
                                  TgsCollection
------------------------------------------------------------------------------}

destructor TgsCollection.Destroy;
begin
   FreeAll;
   inherited Destroy;
end;

procedure TgsCollection.FreeOne(Item: Pointer);
begin
   Delete(IndexOf(Item));
   FreeItem(Item);
end;

procedure TgsCollection.FreeAll;
var
  I: Integer;
begin
   for I := 0 to Count - 1 do FreeItem(Items[I]);
   Count := 0;
end;

procedure TgsCollection.FreeItem(Item: Pointer);
begin
   if Item <> nil then TObject(Item).Free;
end;

{------------------------------------------------------------------------------
                                  TgsVariant
------------------------------------------------------------------------------}

constructor TgsVariant.Create(Size: word);
begin
   inherited Create;
   VarBuf := nil;
   SizeBuf := Size;
   SizeVar := 0;
   TypeVar := gsvtUnknown;
   if Size > 0 then
      GetMem(VarBuf, SizeBuf);
end;

destructor TgsVariant.Destroy;
begin
   if SizeBuf > 0 then
   begin
      FreeMem(VarBuf,SizeBuf);
      SizeBuf := 0;
   end;   
   inherited Destroy;
end;

function TgsVariant.Assign(Source: TgsVariant): boolean;
begin
   Clear;
   Result := Source <> nil;
   if Result then
   begin
      if Source.SizeBuf > 0 then
      begin
         GetMem(VarBuf,Source.SizeBuf);
         Move(Source.VarBuf^,VarBuf^,Source.SizeBuf);
      end;
      SizeBuf := Source.SizeBuf;
      SizeVar := Source.SizeVar;
      TypeVar := Source.TypeVar;
   end;
end;

procedure TgsVariant.Clear;
begin
   if (VarBuf <> nil) and (SizeBuf > 0) then
      FreeMem(VarBuf,SizeBuf);
   VarBuf := nil;
   SizeBuf := 0;
   SizeVar := 0;
   TypeVar := gsvtUnknown;
end;

procedure TgsVariant.CheckBuffer(NewSize: integer);
var
   buf: gsptrByteArray;
   siz: integer;
begin
   if (NewSize > SizeBuf) then
   begin
      buf := VarBuf;
      siz := SizeBuf;
      VarBuf := nil;
      Clear;
   end
   else
   begin;
      buf := nil;
      siz := 0;
   end;
   SizeVar := NewSize;
   if (VarBuf = nil) then
   begin
      GetMem(VarBuf,SizeVar);
      SizeBuf := SizeVar;
   end;
   if buf <> nil then
   begin
      Move(buf^,VarBuf^,siz);
      FreeMem(buf,siz);
   end;
end;

function TgsVariant.CompareBin(Target: TgsVariant; var EndPos: integer;
                            IfPartial: integer; CollateTable: pointer): integer;
var
  Typ : TgsVariantType;
begin
    Typ := TypeOfVar;
    if Typ = gsvtFloat then
       TypeOfVar := gsvtBinary;
    Result := Compare(Target,EndPos,IfPartial,CollateTable);
    TypeOfVAr := Typ;
end;

function TgsVariant.Compare(Target: TgsVariant; var EndPos: integer;
                            IfPartial: integer; CollateTable: pointer): integer;
var
   df: integer;
   lmt: integer;
   typ: TgsVariantType;
   coltab: gsptrByteArray;
begin
   if TypeVar = gsvtUnknown then
   begin
      if (Target <> nil) and (Target.SizeVar > 0) then
      begin
         Result := -1;
         EndPos := 0;
         exit;
      end
      else
      begin
         Result := 0;
         EndPos := 0;
         exit;
      end;
   end;
   if Target = nil then
   begin
      EndPos := 0;
      Result := 1;
      exit;
   end;
   typ := TypeVar;
   if TypeVar <> Target.TypeVar then
   begin
      if typ = gsvtBinary then                     {allow binary as compare}
         typ := Target.TypeVar
      else
         if Target.TypeVar <> gsvtBinary then
            typ := gsvtUnknown;
   end;
   if typ = gsvtUnknown then
      raise EHalcyonError.Create(gsErrVariantTypes);
   EndPos := 0;
   df := 0;                                                         {difference flag df initialized}
   if (VarBuf = nil) or (SizeVar = 0) then df := -1;                {df = -1 if Self is empty}
   if (Target.VarBuf = nil) or (Target.SizeVar = 0) then inc(df,2); {df = df+2 if target is empty}
   if df <> 0 then                       { df value is                         }
   begin                                 {    0 if neither is empty            }
      if df < 0 then inc(df);            {   +1 if both are empty              }
      Result := df-1;                    {   -1 if Self is empty               }
                                         {   +2 if target is empty             }
(*
      if typ = gsvtText then
      begin
         if df < 0 then Result := ifPartial;
      end;
*)
      exit;
   end;
   case typ of
      gsvtText  : begin
                     if SizeVar > Target.SizeVar then    {find shortest}
                        lmt := Target.SizeVar
                     else
                        lmt := SizeVar;
                     if CollateTable <> nil then
                     begin
                        coltab := CollateTable;
                        repeat
                           df := coltab[VarBuf^[EndPos]];
                           df := df - coltab[Target.VarBuf^[EndPos]];
                           inc(EndPos);
                        until (df <> 0) or (EndPos >= lmt);
                     end
                     else
                     begin
                        repeat
                           df := VarBuf^[EndPos] - Target.VarBuf^[EndPos];
                           inc(EndPos);
                        until (df <> 0) or (EndPos >= lmt);
                     end;
                     if df = 0 then                      {if = for shortest length}
                     begin
                        inc(EndPos);                     {set EndPos to lmt + 1}
                        df := SizeVar - Target.SizeVar;  {- if Self shorter, 0 if =, + if longer}
                     end;
                     if (df < 0) and (EndPos > SizeVar) then
                        if typ = gsvtText then                {%FIX0004}
                           df := IfPartial;
                     Result := df;
                  end;
      gsvtBinary: begin
                     if SizeVar > Target.SizeVar then    {find shortest}
                        lmt := Target.SizeVar
                     else
                        lmt := SizeVar;
                     repeat
                        df := VarBuf^[EndPos] - Target.VarBuf^[EndPos];
                        inc(EndPos);
                     until (df <> 0) or (EndPos >= lmt);
                     if df = 0 then                      {if = for shortest length}
                     begin
                        inc(EndPos);                     {set EndPos to lmt + 1}
                        df := SizeVar - Target.SizeVar;  {- if Self shorter, 0 if =, + if longer}
                     end;
                     if (df < 0) and (EndPos > SizeVar) then
                        if typ = gsvtText then                {%FIX0004}
                           df := IfPartial;
                     Result := df;
                  end;
      gsvtFloat : begin
                     df := 0;
                     if FloatNum(pointer(VarBuf)^) < FloatNum(pointer(Target.VarBuf)^) then
                        df  := -1
                     else
                        if FloatNum(pointer(VarBuf)^) > FloatNum(pointer(Target.VarBuf)^) then
                           df := 1;
                     Result := df;
                  end;
      gsvtDate  : begin
                     df := 0;
                     if longint(pointer(VarBuf)^) < longint(pointer(Target.VarBuf)^) then
                        df  := -1
                     else
                        if longint(pointer(VarBuf)^) > longint(pointer(Target.VarBuf)^) then
                           df := 1;
                     Result := df;
                  end;
      gsvtBoolean : begin
                     if boolean(pointer(VarBuf)^) = boolean(pointer(Target.VarBuf)^) then
                        df := 0
                     else
                        if boolean(pointer(VarBuf)^) then
                           df := 1
                        else
                           df := -1;
                     Result := df;
                  end;
      else Result := 0;
   end;
   if Result < 0 then
      Result := -1
   else
      if Result > 0 then Result := 1;
end;



function TgsVariant.GetBoolean: boolean;
var
   i: integer;
begin
   if (VarBuf = nil) or (SizeVar = 0) then
      Result := false
   else
   begin
      case TypeVar of
         gsvtBinary,
         gsvtBoolean  : Result := boolean(pointer(VarBuf)^);
         gsvtDate     : Result := false;
         gsvtFloat    : Result := trunc(FloatNum(pointer(VarBuf)^)) <> 0;
         gsvtText     : begin
                         result := false;
                         for i := 1 to length(LogicalTrue) do
                            if PChar(VarBuf)[0] = LogicalTrue[i] then
                               Result := true;
                      end;
         else Result := false;
      end;
   end;
end;

function TgsVariant.GetBinary(ABuffer: pointer; ALength: integer): pointer;
begin
   if (VarBuf <> nil) and (SizeVar > 0) then
   begin
      if ALength < SizeVar then
         move(VarBuf^,ABuffer^,ALength)
      else
         move(VarBuf^,ABuffer^,SizeVar);
      Result := ABuffer;
   end
   else
      Result := nil;
end;


function TgsVariant.GetDate: longint;
begin
   if (VarBuf = nil) or (SizeVar = 0) then
      Result := 0
   else
   begin
      case TypeVar of
         gsvtBoolean  : Result := 0;
         gsvtBinary,
         gsvtDate     : Result := longint(pointer(VarBuf)^);
         gsvtFloat    : Result := DBFDate.CTOD(DBFDate.DTOS(trunc(FloatNum(pointer(VarBuf)^))));
         gsvtText     : Result := DBFDate.CTOD(GetString);
         else Result := 0;
      end;
   end;
end;

function TgsVariant.GetFloat: FloatNum;
begin
   if (VarBuf = nil) or (SizeVar = 0) then
      Result := 0
   else
   begin
      case TypeVar of
         gsvtBoolean  : if GetBoolean then
                           Result := 1
                        else
                           Result := 0;
         gsvtDate     : Result := GetDate;
         gsvtBinary,
         gsvtFloat    : Result := FloatNum(pointer(VarBuf)^);
         gsvtText     : Result := StrToFloat(GetString);
         else Result := 0;
      end;
   end;
end;

function TgsVariant.GetPChar(APChar: PChar): PChar;
begin
   if (VarBuf = nil) or (SizeVar = 0) then
      APChar[0] := #0
   else
   begin
      case TypeVar of
         gsvtBoolean  : if GetBoolean then
                           StrPCopy(APChar,LogicalTrue[1])
                        else
                           StrPCopy(APChar,LogicalFalse[1]);
         gsvtDate     : StrPCopy(APChar,DBFDate.DTOC(GetDate));
         gsvtFloat    : StrPCopy(APChar,FloatToStr(GetFloat));
         gsvtBinary,
         gsvtText     : begin
                         move(VarBuf^,APChar[0],SizeVar);
                         APChar[SizeVar] := #0;
                      end;
         else APChar[0] := #0;
      end;
   end;
   Result := APChar;
end;

function TgsVariant.GetString: string;
var
   d: integer;
begin
   if (VarBuf = nil) or (SizeVar = 0) then
      Result := ''
   else
   begin
      case TypeVar of
         gsvtBoolean  : if GetBoolean then
                           Result := LogicalTrue[1]
                        else
                           Result := LogicalFalse[1];
         gsvtDate     : Result := DBFDate.DTOC(GetDate);
         gsvtFloat    : Result := FloatToStr(GetFloat);
         gsvtBinary,
         gsvtText     : begin
                         d := SizeVar;
                         SetLength(Result,d);
                         move(VarBuf^,Result[1],d);
                      end;
         else Result := '';
      end;
   end;
end;

procedure TgsVariant.PutBoolean(ABool: boolean);
begin
   CheckBuffer(SizeOf(boolean));
   if (VarBuf <> nil) and (SizeVar > 0) then
      Move(ABool,VarBuf^,SizeVar);
   TypeVar := gsvtBoolean;
end;

procedure TgsVariant.PutBinary(ABuffer: pointer; ALength: integer);
begin
   CheckBuffer(ALength);
   if (VarBuf <> nil) and (SizeVar > 0) then
      Move(ABuffer^,VarBuf^,SizeVar);
   TypeVar := gsvtBinary;
end;


procedure TgsVariant.PutDate(ADate: longint);
begin
   CheckBuffer(SizeOf(longint));
   if (VarBuf <> nil) and (SizeVar > 0) then
      Move(ADate,VarBuf^,SizeVar);
   TypeVar := gsvtDate;
end;

procedure TgsVariant.PutFloat(AFloat: FloatNum);
begin
   CheckBuffer(SizeOf(FloatNum));
   if (VarBuf <> nil) and (SizeVar > 0) then
      Move(AFloat,VarBuf^,SizeVar);
   TypeVar := gsvtFloat;
end;

procedure TgsVariant.PutPChar(APChar: PChar);
begin
   CheckBuffer(StrLen(APChar));
   if (VarBuf <> nil) and (SizeVar > 0) then
      Move(APChar[0],VarBuf^,SizeVar);
   TypeVar := gsvtText;
end;

procedure TgsVariant.PutString(const AString: string);
begin
   CheckBuffer(length(AString));
   if (VarBuf <> nil) and (SizeVar > 0) then
      Move(AString[1],VarBuf^,SizeVar);
   TypeVar := gsvtText;
end;

procedure TgsVariant.AppendBinary(ABuffer: pointer; ALength: integer);
var
   oldlen: integer;
begin
   if (ABuffer = nil) or (ALength = 0) then exit;
   TypeVar := gsvtBinary;
   if not (TypeVar in [gsvtText, gsvtBinary]) then
      raise EHalcyonError.Create(gsErrVariantAppend);
   oldlen := SizeVar;
   CheckBuffer(SizeVar+ALength);
   if (VarBuf <> nil) and (SizeVar > 0) then
      Move(ABuffer^,VarBuf^[oldlen],ALength);
   TypeVar := gsvtBinary;
end;

procedure TgsVariant.AppendPChar(APChar: PChar);
var
   oldlen: integer;
   addlen: integer;
begin
   if (APChar = nil) or (StrLen(APChar) = 0) then exit;
   if not (TypeVar in [gsvtText, gsvtBinary]) then
      raise EHalcyonError.Create(gsErrVariantAppend);
   oldlen := SizeVar;
   addlen := StrLen(APChar);
   CheckBuffer(SizeVar+addlen);
   if (VarBuf <> nil) and (SizeVar > 0) then
      Move(APChar[0],VarBuf^[oldlen],addlen);
   TypeVar := gsvtText;
end;

procedure TgsVariant.AppendString(const AString: string);
var
   oldlen: integer;
   addlen: integer;
begin
   if Length(AString) = 0 then exit;
   if not (TypeVar in [gsvtText, gsvtBinary]) then
      raise EHalcyonError.Create(gsErrVariantAppend);
   oldlen := SizeVar;
   addlen := length(AString);
   CheckBuffer(SizeVar+addlen);
   if (VarBuf <> nil) and (SizeVar > 0) then
      Move(AString[1],VarBuf^[oldlen],addlen);
   TypeVar := gsvtText;
end;

procedure TgsVariant.LowerCase(LowerTable: pointer);
var
   s: gsUTFString;
begin
   s := GetString;
   s := gsStrLowerCase(s);
   PutString(s);
end;

procedure TgsVariant.UpperCase(UpperTable: pointer);
var
   s: gsUTFString;
begin
   s := GetString;
   s := gsStrUpperCase(s);
   PutString(s);
end;

procedure TgsVariant.PadL(len: integer);
var
   oldsiz: integer;
   deltasiz: integer;
begin
   if TypeVar <> gsvtText then exit;
   oldsiz := SizeVar;
   CheckBuffer(len);
   deltasiz := SizeVar-oldsiz;
   if deltasiz < 0 then
      SizeVar := oldsiz
   else
   begin
      Move(VarBuf^[0],VarBuf^[deltasiz],SizeVar-deltasiz);
      FillChar(VarBuf^[0],deltasiz,#32);
   end;
end;

procedure TgsVariant.PadR(len: integer);
var
   oldsiz: integer;
   deltasiz: integer;
begin
   if TypeVar <> gsvtText then exit;
   oldsiz := SizeVar;
   CheckBuffer(len);
   deltasiz := SizeVar-oldsiz;
   if deltasiz <= 0 then
      SizeVar := oldsiz
   else
      FillChar(VarBuf^[oldsiz],deltasiz,#32);
end;

procedure TgsVariant.TrimL;
var
   i: integer;
begin
   if TypeVar <> gsvtText then exit;
   i := 0;
   while (i < SizeVar) and (not (PChar(VarBuf)[i] = #32)) do inc(i);
   if (i > 0) then
   begin
      SizeVar := SizeVar-i;
      if SizeVar > 0 then
      begin
         move(PChar(VarBuf)[i],PChar(VarBuf)[0],SizeVar);
      end;
   end;
end;

procedure TgsVariant.TrimR;
begin
   if TypeVar <> gsvtText then exit;
   while (SizeVar > 0) and (PChar(VarBuf)[SizeVar-1] = #32) do dec(SizeVar);
end;


{------------------------------------------------------------------------------
                                   TgsHugeSet
------------------------------------------------------------------------------}

constructor TgsHugeSet.Create;
begin
   inherited Create;
   FSetList := TList.Create;
   FHighestBit := -1;
end;

destructor TgsHugeSet.Destroy;
var
   i: integer;
begin
   for i := 0 to FSetList.Count-1 do
      FreeMem(FSetList[i],16384);
   FSetList.Free;
   inherited Destroy;
end;

procedure TgsHugeSet.Clear;
var
   i: integer;
begin
   for i := 0 to FSetList.Count-1 do
      FillChar(FSetList[i]^,16384,#0);
   FHighestBit := -1;
end;

procedure TgsHugeSet.ChangeBit(Bit: longint; Value: byte);
var
   WhichByte: longint;
   WhichPage: longint;
   ByteOnPage: longint;
   BitInByte: longint;
   p: gsptrByteArray;
begin
   WhichByte := Bit shr 3;
   WhichPage := WhichByte shr 14;
   while WhichPage >= FSetList.Count do
   begin
      GetMem(p,16384);
      FillChar(p^,16384,#0);
      FSetList.Add(p);
   end;
   p := FSetList[WhichPage];
   ByteOnPage := WhichByte and $3FFF;
   BitInByte := Bit and $0007;
   case Value of
      0 : p^[ByteOnPage] := p^[ByteOnPage] and ClearBitArray[BitInByte];
      1 : p^[ByteOnPage] := p^[ByteOnPage] or SetBitArray[BitInByte];
      2 : p^[ByteOnPage] := p^[ByteOnPage] xor SetBitArray[BitInByte];
   end;
   if Bit > FHighestBit then FHighestBit := Bit;
end;

function TgsHugeSet.BitValue(Bit: longint): boolean;
var
   WhichByte: longint;
   WhichPage: longint;
   ByteOnPage: longint;
   BitInByte: longint;
   p: gsptrByteArray;
begin
   if Bit <= FHighestBit then
   begin
      WhichByte := Bit shr 3;
      WhichPage := WhichByte shr 14;
      p := FSetList[WhichPage];
      ByteOnPage := WhichByte and $3FFF;
      BitInByte := Bit and $0007;
      Result := p^[ByteOnPage] and SetBitArray[BitInByte] <> 0;
   end
   else
      Result := false;
end;


{------------------------------------------------------------------------------
                           Global procedures/functions
------------------------------------------------------------------------------}

Function SearchBuf(var Pattern, Source; StartPos, PatLen, SrcLen: integer): integer;
var
   pPattern: gsptrByteArray;
   pSource: gsptrByteArray;
   i: integer;
   j: integer;
   k: integer;
   r: integer;
   last: array[0..255] of byte;
begin
   SearchBuf := -1;
   pPattern := pointer(Pattern);
   pSource := pointer(Source);
   if pPattern = nil then exit;
   if pSource = nil then exit;
   if StartPos < 0 then exit;
   if PatLen < 1 then exit;
   if SrcLen < (PatLen + StartPos) then exit;
   FillChar(last,SizeOf(last),#0);
   for i := 0 to pred(PatLen) do
      last[pPattern[i]] := i + 1;
   r := -1;
   i := StartPos;
   while (r = -1) and (i <= SrcLen - PatLen) do
   begin
      j := pred(PatLen);
      while (j >= 0) and (pSource[i+j] = pPattern[j]) do dec(j);
      if j < 0 then
      begin
         r := i;
      end
      else
      begin
         k := succ(j)-last[pSource[i+j]];
         if k > 0 then
            i := i + k
         else
            inc(i);
      end;
   end;
   SearchBuf := r;
end;

Function SearchBufI(var Pattern, Source; StartPos, PatLen, SrcLen: integer): integer;
var
   pPattern: gsptrByteArray;
   pSource: gsptrByteArray;
   i: integer;
   j: integer;
   k: integer;
   r: integer;
   ps: string;
   last: array[0..255] of byte;
   c1: char;
   nm : boolean;
begin
   SearchBufI := -1;
   pPattern := pointer(Pattern);
   pSource := pointer(Source);
   if pPattern = nil then exit;
   if pSource = nil then exit;
   if StartPos < 0 then exit;
   if PatLen < 1 then exit;
   if SrcLen < (PatLen + StartPos) then exit;
   SetLength(ps,PatLen);
   move(pPattern^,ps[1],PatLen);
   ps := UpperCase(ps);
   FillChar(last,SizeOf(last),#0);
   for i := 1 to PatLen do
      last[ord(ps[i])] := i;
   r := -1;
   i := StartPos;
   while (r = -1) and (i <= SrcLen - PatLen) do
   begin
      j := pred(PatLen);

      nm := true;
      while (j >= 0) and nm do
      begin
         c1 := UpCase(chr(pSource[i+j]));
         nm := c1 = ps[j+1];
         if nm then dec(j);
      end;
      if j < 0 then
      begin
         r := i;
      end
      else
      begin
         k := succ(j)-last[ord(UpCase(chr(pSource[i+j])))];
         if k > 0 then
            i := i + k
         else
            inc(i);
      end;
   end;
   SearchBufI := r;
end;

Function ChangeFileExtEmpty(const FileName, Extension: String): String;
begin
   if ExtractFileExt(FileName) = '' then
      ChangeFileExtEmpty := ChangeFileExt(FileName,Extension)
   else
      ChangeFileExtEmpty := FileName;
end;

Function ExtractFileNameOnly(const FileName: String): String;
var
   ixn   : integer;
   ixe   : integer;
   sn    : string;
   se    : string;
begin
   sn := ExtractFileName(FileName);
   se := ExtractFileExt(FileName);
   ixe := length(se);
   if ixe > 0 then
   begin
      ixn := succ(length(sn)- ixe);
      if System.Copy(sn,ixn,ixe) = se then
         System.Delete(sn,ixn,ixe);
   end;
   ExtractFileNameOnly := sn;
end;

Procedure Byte2Hex(byt: byte; var ch1, ch2: char);
var
   b1: byte;
   b2: byte;
begin
   b1 := byt shr 4;
   b2 := byt and $0F;
   if b1 > 9 then
      ch1 := chr(55 + b1)
   else
      ch1 := chr(48 + b1);
   if b2 > 9 then
      ch2 := chr(55 + b2)
   else
      ch2 := chr(48 + b2);
end;

procedure Hex2Byte(var byt: byte; ch1, ch2: char);
var
   b1: byte;
   b2: byte;
begin
   b1 := 0;
   b2 := 0;
   if ch1 in ['0'..'9'] then b1 := ord(ch1) - 48
      else if ch1 in ['A'..'F'] then b1 := ord(ch1) - 55;
   if ch2 in ['0'..'9'] then b2 := ord(ch2) - 48
      else if ch2 in ['A'..'F'] then b2 := ord(ch2) - 55;
   byt := (b1 shl 4) or b2;
end;


function CmprIntegers(V1, V2: longint): integer;
var
   V: longint;
begin
   V := V1-V2;
   if V < 0 then V := -1
      else
         if V > 0 then V := 1;
   CmprIntegers := V;
end;

function PadL( const strn : String; lth : integer) : String;
var
   wks : String[255];
   i   : integer;
begin
   wks := '';
   i := length(strn);                    {Load String255 length}
   if i > 0 then
   begin
      if i >= lth then
      begin
         PadL := System.Copy(strn,succ(i-lth),lth);
         exit;
      end;
      FillChar(wks,succ(lth),#32);
      move(strn[1],wks[succ(lth-i)],i);
      wks[0] := chr(lth);
   end;
   PadL := wks;
end;

function PadR(const strn : String; lth : integer) : String;
var
   wks : String;
   i   : integer;
begin
   wks := '';
   i := length(strn);                    {Load String255 length}
   if i > 0 then
   begin
      if i >= lth then
         wks := System.Copy(strn,1,lth)
      else
      begin
         wks := strn;
         while length(wks) < lth do
            wks := wks + ' ';
      end;
   end;
   PadR := wks;
end;

Function Strip_Flip(const st : String): String;
var
   wst,
   wstl : String;
   i    : integer;
begin
   wst := TrimRight(st);
   wst := wst + ' ';
   i := pos('~', wst);
   if i <> 0 then
   begin
      wstl := copy(wst,1,pred(i));
      system.delete(wst,1,i);
      wst := wst + wstl;
   end;
   Strip_Flip := wst;
end;

procedure StrPadR(s: PChar; c: char; n: integer);
var
   i: integer;
begin
   i := StrLen(s);
   while i < n do
   begin
      s[i] := c;
      inc(i);
   end;
   s[i] := #0;
end;

procedure StrTrimR(s: PChar);
var
   i: integer;
begin
   i := StrLen(s);
   while (i > 0) and (s[pred(i)] = #32) do dec(i);
   s[i] := #0;
end;

function  ComparePChar(st1,st2: PChar): integer;
begin
   Result := AnsiStrComp(st1,st2);
end;

function  CompareIPChar(st1,st2: PChar): integer;
begin
   Result := AnsiStrIComp(st1,st2);
end;

function  CompareChar(st1,st2: Char): integer;
begin
   Result := ord(st1)-ord(st2);
end;


const
   chrsavail : String[36] =  '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
   LastUnique : String[8];


function Unique_Field : String;
var
   y, mo, d       : Word;
   h, mn, s, hund : Word;
   wk, ymd, hms   : longint;
   LS             : String[16];

begin
   repeat
      DecodeTime(Time,h,mn,s,hund);
      DecodeDate(Date,y,mo,d);
      ymd := 10000+(mo*100)+d;
      hms := ((h+10)*1000000)+(longint(mn)*10000)+(s*100)+hund;
      wk := ymd mod 26;
      LS := chrsavail[succ(wk) + 10];
      ymd := ymd div 26;
      repeat
         wk := ymd mod 36;
         LS := LS + chrsavail[succ(wk)];
         ymd := ymd div 36;
      until ymd = 0;
      repeat
         wk := hms mod 36;
         LS := LS + chrsavail[succ(wk)];
         hms := hms div 36;
      until hms= 0;
   until LS <> LastUnique;
   LastUnique := LS;
   Unique_Field := LS;                {Return the unique field}
end;

end.
