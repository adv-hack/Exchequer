unit BTFiles;

{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  Controls, Forms, COMObj, Enterprise01_TLB, {GlobVar,} BTUtil, BTConst, SysUtils
  ,Dialogs, ComCtrls, FileUtil;

  procedure OpenFiles;
  procedure CloseFiles;

type

  TWEEEProdRec = Record
    wpStockCode : String[16];    // Exchequer Stock Code
    wpChargeType : Byte;
    wpSetValue : double;
    wpValuePerKilo : double;
    wpNoOfKilos : double;
    wpValue : double;
    wpReportCatFolio : LongInt;
    wpReportSubCatFolio : LongInt;
//    wpExtraChargeStockCode : String[16];
//    wpProducer : String[20];
    wpSpare : Array [1..500] Of Char;
  End; { WEEEProdRecType }

  TWEEEReportCatRec = Record
    wrcFolioNo : longint;
    wrcCode : String[10];
    wrcDescription : String[100];
    wrcDummyChar : char;
    wrcSpare : Array [1..300] Of Char;
  End; { WEEEProdRecType }

  TWEEEReportSubCatRec = Record
    wscFolioNo : longint;
    wscCatFolioNo : longint;
    wscCode : String[10];
    wscDescription : String[100];
    wscDummyChar : char;
    wscSpare : Array [1..300] Of Char;
  End; { WEEEProdRecType }

const
  btNoOfFiles = 3;

  WEEEProdF = 1;
    wpNumOfKeys = 1;
    wpNumSegments = 1;
      wpIdxStockCode = 0;

  WEEEReportCatF = 2;
    wrcNumOfKeys = 3;
    wrcNumSegments = 4;
      wrcIdxFolio = 0;
      wrcIdxCode = 1;
      wrcIdxDesc = 2;

  WEEEReportSubCatF = 3;
    wscNumOfKeys = 3;
    wscNumSegments = 6;
      wscIdxFolio = 0;
      wscIdxCatCode = 1;
      wscIdxCatDesc = 2;

//  IdxFolio = 0;

  CT_SET_VALUE = 0;
  CT_CALC_VALUE = 1;

var
  btBufferSize : array[1..btNoOfFiles] of integer;
  btFileVar : array[1..btNoOfFiles] of TFileVar;

  btFileName : array[1..btNoOfFiles] of string
  = ('WEProd.dat', 'WERepCat.dat', 'WESubCat.dat');


implementation
uses
  WEEEProc;

type
  TWEEEProdFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : Array[1..wpNumSegments] of TKeySpec;
    AltColt : TAltColtSeq;
  end;

var
  WEEEProdRec  : TWEEEProdRec;
  WEEEProdFile : TWEEEProdFileDef;

type
  TWEEEReportCatFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : Array[1..wrcNumSegments] of TKeySpec;
    AltColt : TAltColtSeq;
  end;

var
  WEEEReportCatRec  : TWEEEReportCatRec;
  WEEEReportCatFile : TWEEEReportCatFileDef;

type
  TWEEEReportSubCatFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : Array[1..wscNumSegments] of TKeySpec;
    AltColt : TAltColtSeq;
  end;

var
  WEEEReportSubCatRec  : TWEEEReportSubCatRec;
  WEEEReportSubCatFile : TWEEEReportSubCatFileDef;

var
  btFileDefPtr : array[1..btNoOfFiles] of Pointer;
  btFileDefSize : array[1..btNoOfFiles] of integer;
  bFilesOpen : boolean;

Procedure OpenFiles;
var
  iFileNo, iOpenStatus : integer;

  Procedure DefineWEEEProdFile;
  Begin
    With WEEEProdFile do
    begin
      Fillchar(WEEEProdFile,Sizeof(WEEEProdFile),#0);

      RecLen:=Sizeof(TWEEEProdRec);
      PageSize:=DefPageSize;                     { 1024 bytes }
      NumIndex:=wpNumOfKeys;

      Variable:=B_Variable+B_Compress+B_BTrunc;  { Used for max compression }

      KeyBuff[1].KeyPos:= BtKeyPos(@WEEEProdRec.wpStockCode[1],@WEEEProdRec);
      KeyBuff[1].KeyLen:= SizeOf(WEEEProdRec.wpStockCode) - 1;
      KeyBuff[1].KeyFlags:=Modfy;

      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
    End; { With }

    Fillchar(WEEEProdRec,Sizeof(WEEEProdRec),0);
  End;{DefineWEEEProdFile}

  Procedure DefineWEEEReportCatFile;
  Begin
    With WEEEReportCatFile do
    begin
      Fillchar(WEEEReportCatFile,Sizeof(WEEEReportCatFile),#0);

      RecLen:=Sizeof(TWEEEReportCatRec);
      PageSize:=DefPageSize;                     { 1024 bytes }
      NumIndex:=wrcNumOfKeys;

      Variable:=B_Variable+B_Compress+B_BTrunc;  { Used for max compression }

      // Index 0 : wrcIdxFolio = wrcFolioNo + wrcDummyChar
      KeyBuff[1].KeyPos := BtKeyPos(@WEEEReportCatRec.wrcFolioNo, @WEEEReportCatRec);
      KeyBuff[1].KeyLen := SizeOf(WEEEReportCatRec.wrcFolioNo);
      KeyBuff[1].ExtTypeVal := BInteger;
      KeyBuff[1].KeyFlags := ModSeg + ExtType;
      // next segment
      KeyBuff[2].KeyPos := BtKeyPos(@WEEEReportCatRec.wrcDummyChar, @WEEEReportCatRec);
      KeyBuff[2].KeyLen := 1;
      KeyBuff[2].KeyFlags := Modfy + AltColSeq;

      // Index 1 : wrcIdxCode = wrcCode;
      KeyBuff[3].KeyPos := BtKeyPos(@WEEEReportCatRec.wrcCode[1],@WEEEReportCatRec);
      KeyBuff[3].KeyLen := SizeOf(WEEEReportCatRec.wrcCode) - 1;
      KeyBuff[3].KeyFlags := Modfy + AltColSeq;

      // Index 2 : wrcIdxDesc = wrcDescription;
      KeyBuff[4].KeyPos := BtKeyPos(@WEEEReportCatRec.wrcDescription[1],@WEEEReportCatRec);
      KeyBuff[4].KeyLen := SizeOf(WEEEReportCatRec.wrcDescription) - 1;
      KeyBuff[4].KeyFlags := Modfy + AltColSeq;

      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
    End; { With }

    Fillchar(WEEEReportCatRec,Sizeof(WEEEReportCatRec),0);
  End;{DefineWEEEReportCatFile}

  Procedure DefineWEEEReportSubCatFile;
  Begin
    With WEEEReportSubCatFile do
    begin
      Fillchar(WEEEReportSubCatFile,Sizeof(WEEEReportSubCatFile),#0);

      RecLen:=Sizeof(TWEEEReportSubCatRec);
      PageSize:=DefPageSize;                     { 1024 bytes }
      NumIndex:=wrcNumOfKeys;

      Variable:=B_Variable+B_Compress+B_BTrunc;  { Used for max compression }

      // Index 0 : wrcIdxFolio = wrcFolioNo + wrcDummyChar
      KeyBuff[1].KeyPos := BtKeyPos(@WEEEReportSubCatRec.wscFolioNo, @WEEEReportSubCatRec);
      KeyBuff[1].KeyLen := SizeOf(WEEEReportSubCatRec.wscFolioNo);
      KeyBuff[1].ExtTypeVal := BInteger;
      KeyBuff[1].KeyFlags := ModSeg + ExtType;
      // next segment
      KeyBuff[2].KeyPos := BtKeyPos(@WEEEReportSubCatRec.wscDummyChar, @WEEEReportSubCatRec);
      KeyBuff[2].KeyLen := 1;
      KeyBuff[2].KeyFlags := Modfy + AltColSeq;

      // Index 1 : wrcIdxCode = wrcCode;
      KeyBuff[3].KeyPos := BtKeyPos(@WEEEReportSubCatRec.wscCatFolioNo, @WEEEReportSubCatRec);
      KeyBuff[3].KeyLen := SizeOf(WEEEReportSubCatRec.wscCatFolioNo);
      KeyBuff[3].ExtTypeVal := BInteger;
      KeyBuff[3].KeyFlags := ModSeg + ExtType;
      // next segment
      KeyBuff[4].KeyPos := BtKeyPos(@WEEEReportSubCatRec.wscCode[1],@WEEEReportSubCatRec);
      KeyBuff[4].KeyLen := SizeOf(WEEEReportSubCatRec.wscCode) - 1;
      KeyBuff[4].KeyFlags := Modfy + AltColSeq;

      // Index 2 : wscIdxDesc = wscCatFolioNo + wscDescription;
      KeyBuff[5].KeyPos := BtKeyPos(@WEEEReportSubCatRec.wscCatFolioNo, @WEEEReportSubCatRec);
      KeyBuff[5].KeyLen := SizeOf(WEEEReportSubCatRec.wscCatFolioNo);
      KeyBuff[5].ExtTypeVal := BInteger;
      KeyBuff[5].KeyFlags := ModSeg + ExtType;
      // next segment
      KeyBuff[6].KeyPos := BtKeyPos(@WEEEReportSubCatRec.wscDescription[1],@WEEEReportSubCatRec);
      KeyBuff[6].KeyLen := SizeOf(WEEEReportSubCatRec.wscDescription) - 1;
      KeyBuff[6].KeyFlags := Modfy + AltColSeq;

      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
    End; { With }

    Fillchar(WEEEReportSubCatRec,Sizeof(WEEEReportSubCatRec),0);
  End;{DefineWEEEReportSubCatFile}

begin{OpenFiles}
  // define file structures
  DefineWEEEProdFile;
  DefineWEEEReportCatFile;
  DefineWEEEReportSubCatFile;

  for iFileNo := 1 to btNoOfFiles do begin
    // open file
    if FileExists(CompanyRec.Path + btFileName[iFileNo]) then iOpenStatus := 0
    else begin
      iOpenStatus := BTMakeFile(btFileVar[iFileNo], CompanyRec.Path + btFileName[iFileNo]
      , btFileDefPtr[iFileNo]^, btFileDefSize[iFileNo]);

{      iOpenStatus := BTMakeFile(VContractFileVar, CompanyRec.Path + vcFileName[iFileNo]
      , VContractFile, SizeOf(VContractFile));}

      BTShowError(iOpenStatus, 'BTMakeFile', CompanyRec.Path + btFileName[iFileNo]);
    end;{if}

    if iOpenStatus = 0 then begin
      iOpenStatus := BTOpenFile(btFileVar[iFileNo], CompanyRec.Path + btFileName[iFileNo], 0);
      BTShowError(iOpenStatus, 'BTOpenFile', CompanyRec.Path + btFileName[iFileNo]);
    end;{if}
  end;{for}
  bFilesOpen := TRUE;
end;{OpenFiles}

procedure CloseFiles;
var
  iFileNo : integer;
begin
  if bFilesOpen then
  begin
    for iFileNo := 1 to btNoOfFiles do begin
      BTCloseFile(btFileVar[iFileNo]);
    end;{for}
    bFilesOpen := FALSE;
  end;{if}
end;

procedure InitialiseArrays;
begin
  bFilesOpen := FALSE;

  btBufferSize[WEEEProdF] := SizeOf(TWEEEProdRec);
  btBufferSize[WEEEReportCatF] := SizeOf(TWEEEReportCatRec);
  btBufferSize[WEEEReportSubCatF] := SizeOf(TWEEEReportSubCatRec);

  btFileDefPtr[WEEEProdF] := @WEEEProdFile;
  btFileDefPtr[WEEEReportCatF] := @WEEEReportCatFile;
  btFileDefPtr[WEEEReportSubCatF] := @WEEEReportSubCatFile;

  btFileDefSize[WEEEProdF] := SizeOf(WEEEProdFile);
  btFileDefSize[WEEEReportCatF] := SizeOf(WEEEReportCatFile);
  btFileDefSize[WEEEReportSubCatF] := SizeOf(WEEEReportSubCatFile);

//  btFileName[WEEEProdF] := GetEnterpriseDirectory + 'WEProd.dat';
//  btFileName[WEEEReportCatF] := GetEnterpriseDirectory + 'WERepCat.dat';
end;

Initialization
  InitialiseArrays;

Finalization
  CloseFiles;

end.
