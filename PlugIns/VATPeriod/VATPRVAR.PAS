unit vatprvar;

interface

{$ALIGN 1}

uses
  GlobVar, BtrvU2, Graphics;

const
  VatPeriodFileName = 'VATPER\VatPrd.dat';
  VatPeriodOptFileName = 'VATPER\VatOpt.dat';

  NumKeys = 2;
  NumSegments = 3;

  NumOptKeys = 2;
  NumOptSegments = 3;

  VatPeriodF = 1;
  VatPeriodOptF = 2;

type
  //
  // Duplicated in \ENTRPRSE\Conversion\v70 SQL Converter\Converter\DataWriteObjs\oVATPrdDataWrite.Pas for SQL Data Migration
  //
  // Please notify the Exchequer Team of any changes
  //
  TVATPeriodRec = Record
    Year          : String[4];
    Period        : String[2];
    EndDate       : String[8];
    StartDate     : String[8];
    Spare         : Array[1..64] of Char;
  end;

  //
  // Duplicated in \ENTRPRSE\Conversion\v70 SQL Converter\Converter\DataWriteObjs\oVATOptDataWrite.Pas for SQL Data Migration
  //
  // Please notify the Exchequer Team of any changes
  //
  TVatPeriodOptRec = Record
    Year          : String[4];
    Period        : String[2];
    EndDate       : String[8];
    StartDate     : String[8];
    OptNoOfPeriods: Byte;  // - number of periods 1-12
    OptUseAuto    : Boolean; // - use auto fill during posting hook
    BackColor,
    TextColor,
    CurrColor     : TColor;
    Spare         : Array[1..52] of Char;
  end;

  VatPeriodFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..NumSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  VatPeriodOptFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..NumOptSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  procedure DefineVatPeriod;
  procedure DefineVatPeriodOpt;
  procedure BtrvErr(ErrNo : integer; const FuncDesc : string);

var
  VatPeriodRec : TVatPeriodRec;
  VatPeriodFile : VatPeriodFileDef;
  VatPeriodOptRec : TVatPeriodOptRec;
  VatPeriodOptFile : VatPeriodOptFileDef;

implementation

uses
  SysUtils, Dialogs;

procedure DefineVatPeriod;
const
  Idx = VatPeriodF;
begin
  FileSpecLen[Idx] := SizeOf(VatPeriodFile);
  FillChar(VatPeriodFile, FileSpecLen[Idx],0);

  with VatPeriodFile do
  begin
    RecLen := Sizeof(VatPeriodRec);
    PageSize := 1024; //DefPageSize;
    NumIndex := NumKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);


    //Key 1 - Year + Period
    KeyBuff[1].KeyPos := BtKeyPos(@VatPeriodRec.Year[1], @VatPeriodRec);
    KeyBuff[1].KeyLen := SizeOf(VatPeriodRec.Year) - 1;
    KeyBuff[1].KeyFlags := DupModSeg;

    KeyBuff[2].KeyPos := BtKeyPos(@VatPeriodRec.Period[1], @VatPeriodRec);
    KeyBuff[2].KeyLen := SizeOf(VatPeriodRec.Period) - 1;
    KeyBuff[2].KeyFlags := DupMod;

    //Key 2 - EndDate
    KeyBuff[3].KeyPos := BtKeyPos(@VatPeriodRec.EndDate[1], @VatPeriodRec);
    KeyBuff[3].KeyLen := SizeOf(VatPeriodRec.EndDate) - 1;
    KeyBuff[3].KeyFlags := DupMod;

    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(VatPeriodRec);
  FillChar(VatPeriodRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @VatPeriodRec;
  FileSpecOfS[Idx] := @VatPeriodFile;
  FileNames[Idx] := VatPeriodFilename;
end;

procedure DefineVatPeriodOpt;
const
  Idx = VatPeriodOptF;
begin
  FileSpecLen[Idx] := SizeOf(VatPeriodOptFile);
  FillChar(VatPeriodOptFile, FileSpecLen[Idx],0);

  with VatPeriodOptFile do
  begin
    RecLen := Sizeof(VatPeriodOptRec);
    PageSize := 1024; //DefPageSize;
    NumIndex := NumOptKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);


    //Key 1 - Year + Period
    KeyBuff[1].KeyPos := BtKeyPos(@VatPeriodOptRec.Year[1], @VatPeriodOptRec);
    KeyBuff[1].KeyLen := SizeOf(VatPeriodOptRec.Year) - 1;
    KeyBuff[1].KeyFlags := DupModSeg;

    KeyBuff[2].KeyPos := BtKeyPos(@VatPeriodOptRec.Period[1], @VatPeriodOptRec);
    KeyBuff[2].KeyLen := SizeOf(VatPeriodOptRec.Period) - 1;
    KeyBuff[2].KeyFlags := DupMod;

    //Key 2 - EndDate
    KeyBuff[3].KeyPos := BtKeyPos(@VatPeriodOptRec.EndDate[1], @VatPeriodOptRec);
    KeyBuff[3].KeyLen := SizeOf(VatPeriodOptRec.EndDate) - 1;
    KeyBuff[3].KeyFlags := DupMod;

    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(VatPeriodOptRec);
  FillChar(VatPeriodOptRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @VatPeriodOptRec;
  FileSpecOfS[Idx] := @VatPeriodOptFile;
  FileNames[Idx] := VatPeriodOptFilename;
end;


procedure BtrvErr(ErrNo : integer; const FuncDesc : string);
var
  s, s1 : string;
begin
  if ErrNo <> 0 then
  begin
    Case ErrNo of
      3   :  s := 'File not open';
      4   :  s := 'Record not found';
      9   :  s := 'End of File';
      84,
      85  :  s := 'Record locked by another workstation';
      else
        s := '';
    end;

    s1 := 'Btrieve error ' + IntToStr(ErrNo) + ' occurred while ' + FuncDesc;
    if s <> '' then
     s1 := s1 + #13#13 + QuotedStr(s);
    ShowMessage(s1);
  end;
end;

initialization

end.
