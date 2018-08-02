unit BTFile;

{ nfrewer440 16:07 13/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}
  Controls, Forms, COMObj, SysUtils, FileUtil, StrUtil, BTUtil, BTConst
  ,Dialogs, Messages, ComCtrls, APIUtil, Enterprise01_TLB;

type
  TCompanyInfo = Class
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;{with}

  procedure ShowBTError(iStatus : integer; sFunction, sFileName : string);
  function OpenFiles(asPath : ANSIString; bOld, bSQL : boolean) : boolean;
  Procedure CloseFiles; stdcall;
  procedure InitialiseArrays(bOld : boolean);

const
  BT_OWNER_NAME = 'IRIS_CCDeptV_345291';
  IDX_DUMMY_CHAR = '!';
  CCDEPTINI = 'CCDEPT.INI';
  sGL_WILDCARD = '*********';
  iGL_WILDCARD = -1;
  iNO_GL = 0;
  CCDEPT_WILDCARD = '***';
  VAT_WILDCARD = '*';
  CCDEPT_DAT = 'CCDept.dat';
  CCDEPTV_DAT = 'CCDeptV.dat';
  INI_FILENAME = 'CCDPVAT.INI';

var
  oToolkit : IToolkit;
  asCompanyPath : AnsiString;
  bUseGLs, bUseVAT : boolean;
  aFileName : array[1..1] of string;

////////////////////
///  CCDEPT.DAT  ///
////////////////////
const
  CCDeptF = 1;

  cdNoOfKeys = 1;
  cdoNoSegments = 4;
  cdNoSegments = 5;

  idxGetCombinations = 0;

  CD_VALID = 'V';
  CD_INVALID = 'I';

type
  TCCDeptRec = record
    cdType             : char;
    cdGLCode           : LongInt;
    cdCostCentre       : String[3];
    cdDepartment       : String[3];
    cdDummyChar        : char;
    cdVATCode          : char;
    cdSpare            : Array [1..499] of byte;
  end;{TCCDeptRec}

var
  aBufferSize : array[1..1] of integer;
  aFileVar : array[1..1] of TFileVar;

implementation

type
  TOldCCDeptFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : Array[1..cdoNoSegments] of TKeySpec;
    AltColt : TAltColtSeq;
  end;

  TCCDeptFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : Array[1..cdNoSegments] of TKeySpec;
    AltColt : TAltColtSeq;
  end;

var
  CCDeptFile : TCCDeptFileDef;
  OldCCDeptFile : TOldCCDeptFileDef;

var
  aFileDefPtr : array[1..1] of Pointer;
  aFileDefSize : array[1..1] of integer;
  bFilesOpen : boolean;

function OpenFiles(asPath : ANSIString; bOld, bSQL : boolean) : boolean;
// Returns TRUE if it had to create one or more files, when attempting to open them.
var
  iStatus : integer;
  CCDeptRec  : TCCDeptRec;

  procedure DefineOldCCDeptFile;
  begin{DefineOldCCDeptFile}
    with OldCCDeptFile do begin
//      FileSpecLen[CCDeptF]:=Sizeof(CCDeptFile);
      Fillchar(OldCCDeptFile, Sizeof(OldCCDeptFile), 0);

      RecLen:=Sizeof(TCCDeptRec);
      PageSize:=DefPageSize;                     { 1024 bytes }
      NumIndex:=cdNoOfKeys;

      Variable:=B_Variable+B_Compress+B_BTrunc;  { Used for max compression }

      // Index 0 - idxGetCombinations : cdType + cdGLCode + cdCostCentre + cdDepartment
      // first segment - cdType
      KeyBuff[1].KeyPos := BtKeyPos(@CCDeptRec.cdType, @CCDeptRec);
      KeyBuff[1].KeyLen := 1;
      KeyBuff[1].KeyFlags := ModSeg + AltColSeq;
      // next segment - cdGLCode
      KeyBuff[2].KeyPos := BtKeyPos(@CCDeptRec.cdGLCode, @CCDeptRec);
      KeyBuff[2].KeyLen := SizeOf(CCDeptRec.cdGLCode);
      KeyBuff[2].KeyFlags := ModSeg + ExtType;
      KeyBuff[2].ExtTypeVal := BInteger;
      // next segment - cdCostCentre
      KeyBuff[3].KeyPos := BtKeyPos(@CCDeptRec.cdCostCentre[1], @CCDeptRec);
      KeyBuff[3].KeyLen := SizeOf(CCDeptRec.cdCostCentre) - 1;
      KeyBuff[3].KeyFlags := ModSeg + AltColSeq;
      // next segment - cdDepartment
      KeyBuff[4].KeyPos := BtKeyPos(@CCDeptRec.cdDepartment[1], @CCDeptRec);
      KeyBuff[4].KeyLen := SizeOf(CCDeptRec.cdDepartment) - 1;
      KeyBuff[4].KeyFlags := Modfy + AltColSeq;

      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
    end; { With }

    Fillchar(CCDeptRec, Sizeof(CCDeptRec), 0);
//    RecPtr[CCDeptF]:=@CCDeptRec;
//    FileSpecOfs[CCDeptF]:=@CCDeptFile;
    aFileName[CCDeptF]:= asPath + CCDEPT_DAT;
  end;{DefineOldCCDeptFile}

  procedure DefineCCDeptFile;
  begin{DefineCCDeptFile}
    with CCDeptFile do begin
//      FileSpecLen[CCDeptF]:=Sizeof(CCDeptFile);
      Fillchar(CCDeptFile, Sizeof(CCDeptFile), 0);

      RecLen:=Sizeof(TCCDeptRec);
      PageSize:=DefPageSize;                     { 1024 bytes }
      NumIndex:=cdNoOfKeys;

      Variable:=B_Variable+B_Compress+B_BTrunc;  { Used for max compression }

      // Index 0 - idxGetCombinations : cdType + cdGLCode + cdCostCentre + cdDepartment
      // first segment - cdType
      KeyBuff[1].KeyPos := BtKeyPos(@CCDeptRec.cdType, @CCDeptRec);
      KeyBuff[1].KeyLen := 1;
      KeyBuff[1].KeyFlags := ModSeg + AltColSeq;
      // next segment - cdGLCode
      KeyBuff[2].KeyPos := BtKeyPos(@CCDeptRec.cdGLCode, @CCDeptRec);
      KeyBuff[2].KeyLen := SizeOf(CCDeptRec.cdGLCode);
      KeyBuff[2].KeyFlags := ModSeg + ExtType;
      KeyBuff[2].ExtTypeVal := BInteger;
      // next segment - cdCostCentre
      KeyBuff[3].KeyPos := BtKeyPos(@CCDeptRec.cdCostCentre[1], @CCDeptRec);
      KeyBuff[3].KeyLen := SizeOf(CCDeptRec.cdCostCentre) - 1;
      KeyBuff[3].KeyFlags := ModSeg + AltColSeq;
      // next segment - cdDepartment
      KeyBuff[4].KeyPos := BtKeyPos(@CCDeptRec.cdDepartment[1], @CCDeptRec);
      KeyBuff[4].KeyLen := SizeOf(CCDeptRec.cdDepartment) - 1;
      KeyBuff[4].KeyFlags := ModSeg + AltColSeq;
      // next segment - cdVATCode
      KeyBuff[5].KeyPos := BtKeyPos(@CCDeptRec.cdVATCode, @CCDeptRec);
      KeyBuff[5].KeyLen := 1;
      KeyBuff[5].KeyFlags := Modfy + AltColSeq;

      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
    end; { With }

    Fillchar(CCDeptRec, Sizeof(CCDeptRec), 0);
    aFileName[CCDeptF]:= asPath + CCDEPTV_DAT;
  end;{DefineCCDeptFile}

  function CreateFile : integer;
  begin{CreateFile}
    Result := BTMakeFile(aFileVar[CCDeptF],aFileName[CCDeptF], aFileDefPtr[CCDeptF]^,aFileDefSize[CCDeptF]);
    ShowBTError(Result, 'BTMakeFile', aFileName[CCDeptF]);
  end;{CreateFile}

begin
  // open files
  Result := FALSE;

  if bSQL then
  begin
    DefineCCDeptFile;
    if TableExists(aFileName[CCDeptF]) then
    begin
      Result := TRUE;
    end
    else
    begin
      iStatus := CreateFile;
      if iStatus = 0 then Result := TRUE
    end;{if}
  end
  else
  begin

    // initialise filenames array
  //  FillChar(aFileName^, SizeOf(aFileName^),#0);

    // define file structures
    if bOld then DefineOldCCDeptFile
    else DefineCCDeptFile;

    if Trim(aFileName[CCDeptF]) <> '' then
    begin
      {$IFDEF EXSQL}
        {$IFDEF CCDEPTVALADMIN}
          OpenCompany(asPath);
        {$ENDIF}
        if TableExists(aFileName[CCDeptF]) then
      {$ELSE}
        if FileExists(aFileName[CCDeptF]) then
      {$ENDIF}
        begin
          iStatus := 0;
        end
        else
        begin
          // Create File
  //        iStatus := BTMakeFile(aFileVar[CCDeptF],aFileName[CCDeptF]
  //        , aFileDefPtr[CCDeptF]^,aFileDefSize[CCDeptF]);
  //        if iStatus = 0 then Result := TRUE
  //        else ShowBTError(iStatus, 'BTMakeFile', aFileName[CCDeptF]);
          iStatus := CreateFile;
          if iStatus = 0 then Result := TRUE
        end;{if}
      {...}

      if iStatus = 0 then
      begin
        // Open file
        iStatus := BTOpenFile(aFileVar[CCDeptF], aFileName[CCDeptF], 0, nil, BT_OWNER_NAME);

  //      if iStatus = 0 then Result := TRUE
  //      else ShowBTError(iStatus, 'BTOpenFile', aFileName[CCDeptF]);

        if iStatus = 0 then
        begin
          // Always try and Set the Owner Name - You will get a result of 50, if it is already set.
          iStatus := BTSetOwnerName(aFileVar[CCDeptF], BT_OWNER_NAME, 1, nil);
          if iStatus <> 50 then BTShowError(iStatus, 'BTSetOwnerName', aFileName[CCDeptF]);
          Result := iStatus in [0,50];
        end
        else
        begin
          // Open Error
          BTShowError(iStatus, 'BTOpenFile', aFileName[CCDeptF]);
        end;{if}

      end;{if}
    end;{if}
  end;{if}
end;

procedure CloseFiles;
begin
  if Trim(aFileName[CCDeptF]) <> '' then BTCloseFile(aFileVar[CCDeptF]);
end;

procedure ShowBTError(iStatus : integer; sFunction, sFileName : string);
begin
  if iStatus <> 0 then begin
    MsgBox('Btrieve Error ' + IntToStr(iStatus) + ' occurred whilst executing the command '
    + QuotedStr(sFunction) + ' on the file ' + QuotedStr(sFileName)
    , mtError, [mbOK], mbOK, 'Btrieve Error');
  end;
end;

procedure InitialiseArrays(bOld : boolean);
begin
  bFilesOpen := FALSE;
  aBufferSize[CCDeptF] := SizeOf(TCCDeptRec);

  if bOld then
  begin
    aFileDefPtr[CCDeptF] := @OldCCDeptFile;
    aFileDefSize[CCDeptF] := SizeOf(OldCCDeptFile);
  end else
  begin
    aFileDefPtr[CCDeptF] := @CCDeptFile;
    aFileDefSize[CCDeptF] := SizeOf(CCDeptFile);
  end;{if}
end;

Initialization
  InitialiseArrays(FALSE);
//  ShowMessage(IntToStr(SizeOf(TCCDeptRec)));

Finalization
  if bFilesOpen then CloseFiles;

end.
