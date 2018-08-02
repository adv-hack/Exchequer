unit BTFiles;

{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  Controls, Forms, COMObj, {Enterprise01_TLB, {GlobVar,} BTUtil, BTConst, SysUtils
  ,Dialogs, ComCtrls, FileUtil, DictRecord;

  procedure OpenFiles;
  procedure CloseFiles;

{type

  TWEEEProdRec = Record
    wpStockCode : String[16];    // Exchequer Stock Code
    wpChargeType : Byte;
    wpSetValue : double;
    wpValuePerKilo : double;
    wpNoOfKilos : double;
    wpValue : double;
    wpReportCatFolio : LongInt;
    wpExtraChargeStockCode : String[16];
    wpSpare : Array [1..500] Of Char;
  End; { WEEEProdRecType }

const
  btNoOfFiles = 2;

  DictRecordPrefix = 'DV';
  XrefRecordPrefix = 'DX';

  DictionaryF = 1;
  NewDictionaryF = 2;
//    wpNumOfKeys = 1;
//    wpNumSegments = 1;
      dtIdxFieldCode = 0;
      dtIdxVarNo = 1;

      dxIdxVerFileName = 0;
      dxIdxFieldCode = 1;
var
//  btBufferSize : array[1..btNoOfFiles] of integer;
  btFileVar : array[1..btNoOfFiles] of TFileVar;
  btFileName : array[1..btNoOfFiles] of string
  = ('Dictnary.dat', 'DictNew.Dat');
  sDataPath : string;


implementation

{type
  TDictionaryFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : Array[1..wpNumSegments] of TKeySpec;
    AltColt : TAltColtSeq;
  end;}

{var
  WEEEProdRec  : TWEEEProdRec;
  DictionaryFile : TDictionaryFileDef;}

var
//  btFileDefPtr : array[1..btNoOfFiles] of Pointer;
//  btFileDefSize : array[1..btNoOfFiles] of integer;
  bFilesOpen : boolean;

Procedure OpenFiles;
var
  iFileNo, iOpenStatus : integer;

(*  Procedure DefineDictionaryFile;
  Begin
    With DictionaryFile do
    begin
      Fillchar(DictionaryFile,Sizeof(DictionaryFile),#0);

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
  End;{DefineDictionaryFile}*)

begin{OpenFiles}
  // define file structures
//  DefineDictionaryFile;
//  DefineWEEEReportCatFile;

  for iFileNo := 1 to btNoOfFiles do begin
    // open file
    if FileExists(sDataPath + btFileName[iFileNo]) then iOpenStatus := 0
    else begin
//      iOpenStatus := BTMakeFile(btFileVar[iFileNo], CompanyRec.Path + btFileName[iFileNo]
//      , btFileDefPtr[iFileNo]^, btFileDefSize[iFileNo]);

{      iOpenStatus := BTMakeFile(VContractFileVar, CompanyRec.Path + vcFileName[iFileNo]
      , VContractFile, SizeOf(VContractFile));}

//      BTShowError(iOpenStatus, 'BTMakeFile', CompanyRec.Path + btFileName[iFileNo]);
    end;{if}

    if iOpenStatus = 0 then begin
      iOpenStatus := BTOpenFile(btFileVar[iFileNo], sDataPath + btFileName[iFileNo], 0);
      if iFileNo = 1
      then BTShowError(iOpenStatus, 'BTOpenFile', sDataPath + btFileName[iFileNo]);
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

//  btBufferSize[DictionaryF] := SizeOf(DataDictRec);
//  btBufferSize[WEEEReportCatF] := SizeOf(TWEEEReportCatRec);

//  btFileDefPtr[DictionaryF] := @DictionaryFile;
//  btFileDefPtr[WEEEReportCatF] := @WEEEReportCatFile;

//  btFileDefSize[DictionaryF] := SizeOf(DictionaryFile);
//  btFileDefSize[WEEEReportCatF] := SizeOf(WEEEReportCatFile);

//  btFileName[DictionaryF] := GetEnterpriseDirectory + 'WEProd.dat';
//  btFileName[WEEEReportCatF] := GetEnterpriseDirectory + 'WERepCat.dat';
end;

Initialization
  sDataPath := ExtractFilePath(Application.ExeName) + 'Reports\';
  InitialiseArrays;

Finalization
  CloseFiles;

end.
