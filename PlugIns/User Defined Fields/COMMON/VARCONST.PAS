unit VarConst;

{ nfrewer440 16:07 13/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}
  Controls, Forms, COMObj, GlobVar, BtrvU2, SysUtils, FileUtil, StrUtil
  ,Dialogs, Messages, ComCtrls, APIUtil{, Enterprise01_TLB};

  procedure ShowBTError(iStatus : integer; sFunction, sFileName : string);
  function OpenFiles(asPath : ANSIString) : boolean; stdcall;
  function OpenFiles_V63(sPath, sCompanyCode : ANSIString) : boolean; stdcall;
  Procedure CloseFiles; stdcall;

const
  IDX_DUMMY_CHAR = '!';
//  WM_InPrint = WM_USER + $103;
  INI_FILENAME = 'ENTUSERF.INI';
  MU_BIN_ENTITY_NO = -1;
  ENTITY_MUBIN = 'Multi-Bin';
// MU_BIN_ENTITY = -1;
  MAX_BIN_CODE_LENGTH = 10;
  UDF_HEADER_FIELDS = 12;  //PS 06/06/2016 2016-R2 ABSEXGENERIC-393 : Max Fields for Header Transaction
  UDF_LINE_FIELDS = 10;    //PS 06/06/2016 2016-R2 ABSEXGENERIC-393 : Max Fields for line Transaction
var
//  oToolkit : IToolkit;
  asCompanyPath : AnsiString;

////////////////
///  Entity  ///
////////////////
const
  EntityF = 1;

  etNumOfKeys = 2;
  etNumSegments = 3;

  etFolioIdx = 0;
  etDescriptionIdx = 1;

  ET_CATEGORY = 'C';
  ET_DATE_FORMAT = 'D';

type
  // MH 07/08/2012 v7.0: Moved structures out to standalone UDStructures.Inc file so they can be referenced
  // by the SQL Data Migration.
  {$I UDStructures.Inc}

  TEntityFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : Array[1..etNumSegments] of KeySpec;
    AltColt : AltColtSeq;
  end;

////////////////
///  Fields  ///
////////////////
const
  FieldF = 2;

  fiNumOfKeys = 3;
  fiNumSegments = 6;

  fiFolioIdx = 0;
  fiEntityFolioIdx = 1;
  fiLookupRefIdx = 2;

type
  // MH 07/08/2012 v7.0: Moved structures out to standalone UDStructures.Inc file so they can be referenced
  // by the SQL Data Migration.

  TFieldFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : Array[1..fiNumSegments] of KeySpec;
    AltColt : AltColtSeq;
  end;

//////////////////
///  ListItem  ///
//////////////////
const
  ListItemF = 3;

  liNumOfKeys = 1;
  liNumSegments = 3;

  liFieldLineDescIdx = 0;

type
  // MH 07/08/2012 v7.0: Moved structures out to standalone UDStructures.Inc file so they can be referenced
  // by the SQL Data Migration.

  TListItemFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : Array[1..liNumSegments] of KeySpec;
    AltColt : AltColtSeq;
  end;

var
  FieldFile : TFieldFileDef;
  EntityFile : TEntityFileDef;
  ListItemFile : TListItemFileDef;


implementation

uses
  EtstrU, DataModule;

function OpenFiles(asPath : ANSIString) : boolean;
// Returns TRUE if it had to create one or more files, when attempting to open them.
var
  iFileNo, iOpenStatus : integer;
  FieldRec  : TFieldRec;
  EntityRec  : TEntityRec;
  ListItemRec : TListItemRec;

  procedure DefineEntityFile;
  begin{DefineEntityFile}
    with EntityFile do begin
      FileSpecLen[EntityF]:=Sizeof(EntityFile);
      Fillchar(EntityFile,FileSpecLen[EntityF],0);

      RecLen:=Sizeof(TEntityRec);
      PageSize:=DefPageSize;                     { 1024 bytes }
      NumIndex:=etNumOfKeys;

      Variable:=B_Variable+B_Compress+B_BTrunc;  { Used for max compression }

      // Index 0 - etFolioNo + etDummyChar
      KeyBuff[1].KeyPos := BtKeyPos(@EntityRec.etFolioNo, @EntityRec);
      KeyBuff[1].KeyLen := SizeOf(EntityRec.etFolioNo);
      KeyBuff[1].KeyFlags := ModSeg + ExtType;
      KeyBuff[1].ExtTypeVal := BInteger;
      KeyBuff[2].KeyPos := BtKeyPos(@EntityRec.etDummyChar, @EntityRec);
      KeyBuff[2].KeyLen := 1;
      KeyBuff[2].KeyFlags := Modfy + AltColSeq;

      // Index 1 - etDescription
      KeyBuff[3].KeyPos := BtKeyPos(@EntityRec.etDescription[1], @EntityRec);
      KeyBuff[3].KeyLen := SizeOf(EntityRec.etDescription) - 1;
      KeyBuff[3].KeyFlags := Modfy + AltColSeq;

      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
    end; { With }

    FileRecLen[EntityF]:=Sizeof(EntityRec);
    Fillchar(EntityRec,FileRecLen[EntityF],0);

    RecPtr[EntityF]:=@EntityRec;
    FileSpecOfs[EntityF]:=@EntityFile;

    FileNames[EntityF]:= asPath + 'UDEntity.dat';
  end;{DefineEntityFile}

  Procedure DefineFieldFile;
  Begin{DefineFieldFile}
    With FieldFile do
    begin
      FileSpecLen[FieldF]:=Sizeof(FieldFile);
      Fillchar(FieldFile,FileSpecLen[FieldF],0);

      RecLen:=Sizeof(TFieldRec);
      PageSize:=DefPageSize;                     { 1024 bytes }
      NumIndex:=fiNumOfKeys;

      Variable:=B_Variable+B_Compress+B_BTrunc;  { Used for max compression }

      // Index 0 - fiFolioNo + fiDummyChar
      KeyBuff[1].KeyPos := BtKeyPos(@FieldRec.fiFolioNo, @FieldRec);
      KeyBuff[1].KeyLen := SizeOf(FieldRec.fiFolioNo);
      KeyBuff[1].KeyFlags := ModSeg + ExtType;
      KeyBuff[1].ExtTypeVal := BInteger;
      KeyBuff[2].KeyPos := BtKeyPos(@FieldRec.fiDummyChar, @FieldRec);
      KeyBuff[2].KeyLen := 1;
      KeyBuff[2].KeyFlags := Modfy + AltColSeq;

      // Index 1 - fiEntityFolio + fiLineNo + fiDummyChar
      KeyBuff[3].KeyPos := BtKeyPos(@FieldRec.fiEntityFolio, @FieldRec);
      KeyBuff[3].KeyLen := SizeOf(FieldRec.fiEntityFolio);
      KeyBuff[3].KeyFlags := ModSeg + ExtType;
      KeyBuff[3].ExtTypeVal := BInteger;
      KeyBuff[4].KeyPos := BtKeyPos(@FieldRec.fiLineNo, @FieldRec);
      KeyBuff[4].KeyLen := SizeOf(FieldRec.fiLineNo);
      KeyBuff[4].KeyFlags := ModSeg + ExtType;
      KeyBuff[4].ExtTypeVal := BInteger;
      KeyBuff[5].KeyPos := BtKeyPos(@FieldRec.fiDummyChar, @FieldRec);
      KeyBuff[5].KeyLen := 1;
      KeyBuff[5].KeyFlags := Modfy + AltColSeq;

      // Index 2 - fiLookupRef
      KeyBuff[6].KeyPos := BtKeyPos(@FieldRec.fiLookupRef[1], @FieldRec);
      KeyBuff[6].KeyLen := SizeOf(FieldRec.fiLookupRef) - 1;
      KeyBuff[6].KeyFlags := Modfy + AltColSeq;

      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
    End; { With }

    FileRecLen[FieldF]:=Sizeof(FieldRec);
    Fillchar(FieldRec,FileRecLen[FieldF],0);

    RecPtr[FieldF]:=@FieldRec;
    FileSpecOfs[FieldF]:=@FieldFile;

    FileNames[FieldF]:= asPath + 'UDField.dat';
  end;{DefineFieldFile}

  Procedure DefineListItemFile;
  Begin{DefineListItemFile}
    With ListItemFile do
    begin
      FileSpecLen[ListItemF]:=Sizeof(ListItemFile);
      Fillchar(ListItemFile,FileSpecLen[ListItemF],0);

      RecLen:=Sizeof(TListItemRec);
      PageSize:=DefPageSize;                     { 1024 bytes }
      NumIndex:=liNumOfKeys;

      Variable:=B_Variable+B_Compress+B_BTrunc;  { Used for max compression }

      // Index 0 (liFieldLineDescIdx) - liFieldFolio + liLineNo + liDescription
      KeyBuff[1].KeyPos := BtKeyPos(@ListItemRec.liFieldFolio, @ListItemRec);
      KeyBuff[1].KeyLen := SizeOf(ListItemRec.liFieldFolio);
      KeyBuff[1].KeyFlags := ModSeg + ExtType;
      KeyBuff[1].ExtTypeVal := BInteger;
//      KeyBuff[1].KeyFlags := ModSeg;
      KeyBuff[2].KeyPos := BtKeyPos(@ListItemRec.liLineNo, @ListItemRec);
      KeyBuff[2].KeyLen := SizeOf(ListItemRec.liLineNo);
      KeyBuff[2].KeyFlags := ModSeg + ExtType;
      KeyBuff[2].ExtTypeVal := BInteger;
//      KeyBuff[2].KeyFlags := ModSeg;
      KeyBuff[3].KeyPos := BtKeyPos(@ListItemRec.liDescription[1], @ListItemRec);
      KeyBuff[3].KeyLen := SizeOf(ListItemRec.liDescription) - 1;
      KeyBuff[3].KeyFlags := Modfy + AltColSeq;

      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
    End; { With }

    FileRecLen[ListItemF]:=Sizeof(ListItemRec);
    Fillchar(ListItemRec,FileRecLen[ListItemF],0);

    RecPtr[ListItemF]:=@ListItemRec;
    FileSpecOfs[ListItemF]:=@ListItemFile;

    FileNames[ListItemF]:= asPath + 'UDItem.dat';
  end;{DefineListItemFile}

//var
//  SQLDataModule : TSQLDataModule;

begin{OpenFiles}
  asCompanyPath := asPath;{.046}

  {.046}
  if UsingSQL then
  begin
    // SQL
    {v6.30.051 ABSEXCH-9494}
//    SQLDataModule := TSQLDataModule.Create(nil);
//    SQLDataModule.Connect(asCompanyPath);
    if not Assigned(SQLDataModule) then
    begin
      SQLDataModule := TSQLDataModule.Create(nil);
      SQLDataModule.Connect(asCompanyPath);
    end;{if}


    Result := SQLDataModule.SQLCreateAllTablesForCompany;

    {v6.30.051 ABSEXCH-9494}
//    SQLDataModule.Disconnect;
//    SQLDataModule.Free;
  end
  else
  begin
    // Pervasive
    SQLDataModule := nil;

    // initialise filenames array
    FillChar(FileNames^, SizeOf(FileNames^),#0);

    // define file structures
    DefineEntityFile;
    DefineFieldFile;
    DefineListItemFile;

    {$IFDEF EXSQL}
      {$IFDEF UDFADMIN}
        OpenCompany(asPath);
      {$ENDIF}
    {$ENDIF}

    // open files
    iOpenStatus := 0;
    Result := FALSE;
    for iFileNo := 1 to MaxFiles do begin

  //    AddLineToFile(IntToStr(iFileNo) + ' : ' + FileNames[iFileNo] + ' / '
  //    + StringToCodes(FileNames[iFileNo]), 'c:\SBDebug.txt');

      if Trim(FileNames[iFileNo]) <> '' then begin
        iOpenStatus := 0;

        {$IFDEF EXSQL}
          if not TableExists(FileNames[iFileNo])
        {$ELSE}
          if not FileExists(FileNames[iFileNo])
        {$ENDIF}
          then begin
            iOpenStatus := Make_File(F[iFileNo],FileNames[iFileNo], FileSpecOfs[iFileNo]^,FileSpecLen[iFileNo]);
            if iOpenStatus = 0 then Result := TRUE
            else ShowBTError(iOpenStatus, 'Make_File', FileNames[iFileNo]);
          end;{if}
        {...}

        if iOpenStatus = 0 then begin
          iOpenStatus := Open_File(F[iFileNo], FileNames[iFileNo], 0);
          if iOpenStatus = 0 then Result := TRUE
          else ShowBTError(iOpenStatus, 'Open_File', FileNames[iFileNo]);
        end;{if}
      end;{if}
    end;{for}
  end;{if}
end;{OpenFiles}

function OpenFiles_V63(sPath, sCompanyCode : ANSIString) : boolean;
begin{OpenFiles_V63}
  if Trim(sCompanyCode) <> '' then asCompanyCode := sCompanyCode;
  Result := OpenFiles(sPath);
end;{OpenFiles_V63}


procedure CloseFiles;
var
  iFileNo : integer;
begin
  {.046}
  if not UsingSQL then
  begin
    // Pervasive
    for iFileNo := 1 to MaxFiles do begin
      if Trim(FileNames[iFileNo]) <> '' then Close_File(F[iFileNo]);
    end;{for}
  end;{if}
end;

procedure ShowBTError(iStatus : integer; sFunction, sFileName : string);
begin
  if iStatus <> 0 then begin
    MsgBox('Btrieve Error ' + IntToStr(iStatus) + ' occurred whilst executing the command '
    + QuotedStr(sFunction) + ' on the file ' + QuotedStr(sFileName)
    , mtError, [mbOK], mbOK, 'Btrieve Error');
  end;
end;

initialization
//  ShowMessage(IntToStr(SizeOf(TEntityRec)));
//  ShowMessage(IntToStr(SizeOf(TFieldRec)));
//  ShowMessage(IntToStr(SizeOf(TListItemRec)));

end.
