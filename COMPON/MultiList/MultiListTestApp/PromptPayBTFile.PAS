unit PromptPayBTFile;

{$ALIGN 1}

interface

uses
  Graphics, Forms, Controls, Classes, Dialogs, SysUtils, BTUtil
  , FileUtil, StrUtil, APIUtil, BTConst;

type
  TPPCustRec = record
    ppcCustCode : string[6];
    ppcDefaultRate : Double;
    ppcInterestVariance : Double;
    ppcCreditDaysOffset : LongInt;
    ppcMinInvoiceValue : Double;
    ppcInterestGLCode : LongInt;
    ppcDebtChargeGLCode : LongInt;
    ppcCostCentre : string[3];
    ppcDepartment : string[3];
    ppcDebitChargeBasis : byte; // 0 = N/A / 1 = per Transaction / 2 = perProcess
    ppcActive : Boolean;
    ppcSyncGLCodes : Boolean;
    ppcDummyChar : char;
    ppcSpare            : Array [1..200] of Char;
  end;{TPPCustRec}

  TPPDebtRec = record
    ppdFolioNo : LongInt;
    ppdCustCode : string[6];
    ppdValueFrom : Double;
    ppdValueTo : Double;
    ppdCharge : Double;
    ppdDummyChar : char;
    ppdSpare            : Array [1..100] of Char;
  end;{TPPDeptRec}

  TPPSetupRec = record
    ppsFolioNo : LongInt;
    ppsDaysField : LongInt;
    ppsHoldFlagField : LongInt;
    ppsDummyChar : char;
    ppsBaseInterestOnDueDate : boolean;
//    ppsSpare : Array [1..1000] of Char;
    ppsSpare : Array [1..999] of Char;
  end;{TPPSetupRec}

  Procedure OpenFiles;
  procedure CloseFiles;

const
  ppNoOfFiles = 3;

  ppCustF = 1;
  ppDebtF = 2;
  ppSetupF = 3;

  ppcCustIdx = 0;
//  ppcInterestGLIdx = 1;

  ppdValueFromIdx = 0;
  ppdFolioNoIdx = 1;

  ppsFolioNoIdx = 0;

  ppFileName : array[1..ppNoOfFiles] of string
  = ('PromPay\PPCust.dat', 'PromPay\PPDebt.dat', 'PromPay\PPSetup.dat');

  PPC_DEFAULT_RECORD = #0#0#0#0#0#0;

  DCB_NA = 0;
  DCB_PER_TRANSACTION = 1;
  DCB_PER_PROCESS = 2;
var
//  PPCustBufferSize : integer;
//  PPCustFileVar : TFileVar;
  ppBufferSize : array[1..ppNoOfFiles] of integer;
  ppFileVar : array[1..ppNoOfFiles] of TFileVar;

implementation
uses
  PPayProc, ExtCtrls, OutLine, Mask, ComCtrls, StdCtrls;

const
  ppcNumOfKeys = 1;
  ppcNumSegments = 1;

type
  TPPCustFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : array[1..ppcNumSegments] of TKeySpec;
    AltColt : TAltColtSeq;
  end;

var
  PPCustFile : TPPCustFileDef;
  PPCustRec : TPPCustRec;

const
  ppsNumOfKeys = 1;
  ppsNumSegments = 2;

type
  TPPSetupFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : array[1..ppsNumSegments] of TKeySpec;
    AltColt : TAltColtSeq;
  end;

var
  PPSetupFile : TPPSetupFileDef;
  PPSetupRec : TPPSetupRec;

const
  ppdNumOfKeys = 2;
  ppdNumSegments = 5;

type
  TPPDebtFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : array[1..ppdNumSegments] of TKeySpec;
    AltColt : TAltColtSeq;
  end;

var
  PPDebtFile : TPPDebtFileDef;
  PPDebtRec : TPPDebtRec;

  ppFileDefPtr : array[1..ppNoOfFiles] of Pointer;
  ppFileDefSize : array[1..ppNoOfFiles] of integer;
  bOpen : boolean;


Procedure OpenFiles;
var
  iFileNo, iOpenStatus : integer;

  Procedure DefinePPCustFile;
  Begin{DefinePPCustFile}
    With PPCustFile do
    begin
      Fillchar(PPCustFile,Sizeof(PPCustFile),#0);

      RecLen := Sizeof(TPPCustRec);
      PageSize := DefPageSize;                     { 1024 bytes }
      NumIndex := ppcNumOfKeys;

      Variable:=B_Variable+B_Compress+B_BTrunc;  { Used for max compression }

      // Index 0 : ppcCustIdx = ppcCustCode
      KeyBuff[1].KeyPos := BtKeyPos(@PPCustRec.ppcCustCode[1], @PPCustRec);
      KeyBuff[1].KeyLen := SizeOf(PPCustRec.ppcCustCode) - 1;
      KeyBuff[1].KeyFlags := Modfy +  AltColSeq;

      // Index 1 : ppcInterestGLIdx = ppcInterestGLCode + ppcDummyChar
{      KeyBuff[2].KeyPos := BtKeyPos(@PPCustRec.ppcInterestGLCode, @PPCustRec);
      KeyBuff[2].KeyLen := SizeOf(PPCustRec.ppcInterestGLCode);
      KeyBuff[2].KeyFlags := DupModSeg +  ExtType;
      KeyBuff[2].ExtTypeVal := BInteger;
      KeyBuff[3].KeyPos := BtKeyPos(@PPCustRec.ppcDummyChar, @PPCustRec);
      KeyBuff[3].KeyLen := 1;
      KeyBuff[3].KeyFlags := DupMod + AltColSeq;}

      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
    End; { With }

    Fillchar(PPCustRec,Sizeof(PPCustRec),#0);

  end;{DefinePPCustFile}

  Procedure DefinePPDebtFile;
  Begin{DefinePPDebtFile}
    With PPDebtFile do
    begin
      Fillchar(PPDebtFile,Sizeof(PPDebtFile),#0);

      RecLen := Sizeof(TPPDebtRec);
      PageSize := DefPageSize;                     { 1024 bytes }
      NumIndex := ppdNumOfKeys;

      Variable:=B_Variable+B_Compress+B_BTrunc;  { Used for max compression }

      // Index 0 : ppdDebtIdx = ppdCustCode + ppdValueFrom + ppdDummyChar
      KeyBuff[1].KeyPos := BtKeyPos(@PPDebtRec.ppdCustCode[1], @PPDebtRec);
      KeyBuff[1].KeyLen := SizeOf(PPDebtRec.ppdCustCode) - 1;
      KeyBuff[1].KeyFlags := Modseg + AltColSeq;
      KeyBuff[2].KeyPos := BtKeyPos(@PPDebtRec.ppdValueFrom, @PPDebtRec);
      KeyBuff[2].KeyLen := SizeOf(PPDebtRec.ppdValueFrom);
      KeyBuff[2].KeyFlags := ModSeg + ExtType;
      KeyBuff[2].ExtTypeVal := BFloat;
      KeyBuff[3].KeyPos := BtKeyPos(@PPDebtRec.ppdDummyChar, @PPDebtRec);
      KeyBuff[3].KeyLen := 1;
      KeyBuff[3].KeyFlags := Modfy + AltColSeq;

      // Index 1 : ppdFolioNoIdx =  ppdFolioNo + ppdDummyChar
      KeyBuff[4].KeyPos := BtKeyPos(@PPDebtRec.ppdFolioNo, @PPDebtRec);
      KeyBuff[4].KeyLen := SizeOf(PPDebtRec.ppdFolioNo);
      KeyBuff[4].KeyFlags := ModSeg + ExtType;
      KeyBuff[4].ExtTypeVal := BInteger;
      KeyBuff[5].KeyPos := BtKeyPos(@PPDebtRec.ppdDummyChar, @PPDebtRec);
      KeyBuff[5].KeyLen := 1;
      KeyBuff[5].KeyFlags := Modfy + AltColSeq;

      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
    End; { With }

    Fillchar(PPDebtRec,Sizeof(PPDebtRec),#0);

  end;{DefinePPDebtFile}

  Procedure DefinePPSetupFile;
  Begin{DefinePPSetupFile}
    With PPSetupFile do
    begin
      Fillchar(PPSetupFile,Sizeof(PPSetupFile),#0);

      RecLen := Sizeof(TPPSetupRec);
      PageSize := DefPageSize;                     { 1024 bytes }
      NumIndex := ppsNumOfKeys;

      Variable:=B_Variable+B_Compress+B_BTrunc;  { Used for max compression }

      // Index 1 : ppsFolioNoIdx =  ppsFolioNo + ppsDummyChar
      KeyBuff[1].KeyPos := BtKeyPos(@PPSetupRec.ppsFolioNo, @PPSetupRec);
      KeyBuff[1].KeyLen := SizeOf(PPSetupRec.ppsFolioNo);
      KeyBuff[1].KeyFlags := ModSeg + ExtType;
      KeyBuff[1].ExtTypeVal := BInteger;
      KeyBuff[2].KeyPos := BtKeyPos(@PPSetupRec.ppsDummyChar, @PPSetupRec);
      KeyBuff[2].KeyLen := 1;
      KeyBuff[2].KeyFlags := Modfy + AltColSeq;

      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
    End; { With }

    Fillchar(PPSetupRec,Sizeof(PPSetupRec),#0);

  end;{DefinePPSetupFile}

begin{OpenFiles}
  // define file structures
  DefinePPCustFile;
  DefinePPDebtFile;
  DefinePPSetupFile;

  for iFileNo := 1 to ppNoOfFiles do begin
    // open file
    if FileExists(CompanyRec.Path + ppFileName[iFileNo]) then iOpenStatus := 0
    else begin
      iOpenStatus := BTMakeFile(ppFileVar[iFileNo], CompanyRec.Path + ppFileName[iFileNo]
      , ppFileDefPtr[iFileNo]^, ppFileDefSize[iFileNo]);

{      iOpenStatus := BTMakeFile(PPCustFileVar, CompanyRec.Path + ppFileName[iFileNo]
      , PPCustFile, SizeOf(PPCustFile));}

      BTShowError(iOpenStatus, 'BTMakeFile', CompanyRec.Path + ppFileName[iFileNo]);
    end;{if}

    if iOpenStatus = 0 then begin
      iOpenStatus := BTOpenFile(ppFileVar[iFileNo], CompanyRec.Path + ppFileName[iFileNo], 0);
      BTShowError(iOpenStatus, 'BTOpenFile', CompanyRec.Path + ppFileName[iFileNo]);
    end;{if}
  end;{for}
  bOpen := TRUE;
end;{OpenFiles}

procedure CloseFiles;
var
  iFileNo : integer;
begin
  for iFileNo := 1 to ppNoOfFiles do begin
    BTCloseFile(ppFileVar[iFileNo]);
  end;{for}
  bOpen := FALSE;
end;

procedure InitialiseArrays;
begin
  bOpen := FALSE;
  ppBufferSize[ppCustF] := SizeOf(TPPCustRec);
  ppBufferSize[ppDebtF] := SizeOf(TPPDebtRec);
  ppBufferSize[ppSetupF] := SizeOf(TPPSetupRec);

  ppFileDefPtr[ppCustF] := @PPCustFile;
  ppFileDefPtr[ppDebtF] := @PPDebtFile;
  ppFileDefPtr[ppSetupF] := @PPSetupFile;

  ppFileDefSize[ppCustF] := SizeOf(PPCustFile);
  ppFileDefSize[ppDebtF] := SizeOf(PPDebtFile);
  ppFileDefSize[ppSetupF] := SizeOf(PPSetupFile);
end;

Initialization
  InitialiseArrays;

Finalization
  if bOpen then CloseFiles;

end.
