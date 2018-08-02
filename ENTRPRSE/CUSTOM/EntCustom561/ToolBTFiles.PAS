unit ToolBTFiles;

{$ALIGN 1}

interface

uses
  Graphics, Forms, Controls, Classes, Dialogs, SysUtils, BTUtil
  , FileUtil, StrUtil, APIUtil, BTConst;

  function OpenFiles : boolean;
  procedure CloseFiles;
  function BuildA10Index(sIndex : string) : string;
  function BuildB50Index(sIndex : string) : string;
  function BuildC60Index(sIndex : string) : string;

const
  NoOfFiles = 1;

  ToolF = 1;
    toNoOfKeys = 3;
    toNoOfSegments = 6;
      miIdxByFolio = 0;
      miIdxByComponentName = 1;
      miIdxAddOrder = 2;
      cxIdxByFolioCode = 0;
      uxIdxByFolioName = 1;
      ssIdx = 0;

  aFileNames : array[1..NoOfFiles] of string = ('Tools.dat');

  RT_MenuItem = 'M';
  RT_UserXRef = 'U';
  RT_SystemSetup = 'S';
  RT_CompanyXRef = 'C';

  AV_AllCompanies = 'A';
  AV_SpecificCompany = 'S';

  IT_MenuItem = 'I';
  IT_SubMenu = 'M';
  IT_Report = 'R';
  IT_Separator = 'S';

  TOOLS_MENU_COMPONENT_NAME = 'EntCustm_Menu_Tools';

type
  TMenuItemRec = record
    miFolioNo : LongInt;
    miAvailability : Char;                      // A = All companies, S = Specific Company
    miCompany : string[6];                      // Company that the item is valid for
    miItemType : Char;                          // I = Menu Item, M = Sub-menu, R = Report, S = Separator
    miDescription : string[50];
    miFilename : string[255];
    miStartDir : string[255];
    miParameters : string[255];
    miHelpText : string[150];
    miAllUsers : boolean;
    miAllCompanies : boolean;
    miComponentName : string[50];
    miParentComponentName : string[50];
    miPosition : LongInt;
    miSpare : Array [1..1000] of Char;
  end;{TToolRec}

  TUserXRefRec = record
    uxItemFolio : LongInt;
    uxUserName : string[10];
    uxSpare : Array [1..1000] of Char;
  end;{TUserXRefRec}

  TCompanyXRefRec = record
    cxItemFolio : LongInt;
    cxCompanyCode : string[6];
    cxSpare : Array [1..1000] of Char;
  end;{TUserXRefRec}

  TSysSetupRec = record
    ssUsePassword : boolean;
    ssPassword : String50;
    ssSpare : Array [1..1000] of Char;
  end;{TSysSetupRec}

  TToolRec   =  Record
    RecordType   :  Char;       // M = Menu Item,  U = User X Ref,  C = Company X Ref,  S = System Setup
    IndexA10 : string[10];      // M = miIdxByFolio,  C = cxIdxByFolioCode, S = ssIdx
    IndexB50 : string[50];      // M = miIdxByComponentName,  U = uxIdxByFolioName
    IndexC60 : string[60];      // M = miIdxAddOrder
    Case Byte of
      1 : (MenuItem : TMenuItemRec);
      2 : (UserXRef : TUserXRefRec);
      3 : (SysSetup : TSysSetupRec);
      4 : (CompanyXRef : TCompanyXRefRec);
  end;
var
  BufferSize : array[1..NoOfFiles] of integer;
  FileVar : array[1..NoOfFiles] of TFileVar;
  asAppDir : ANSIString;

  procedure SetMenuItemIndexes(var ToolRec : TToolRec);
  procedure SetCompanyXRefIndexes(var ToolRec : TToolRec);
  procedure SetUserXRefIndexes(var ToolRec : TToolRec);
  procedure SetSystemSetupIndexes(var ToolRec : TToolRec);

implementation

{$IFDEF EXSQL}
uses SQLUtils;
{$ENDIF}

type
  TToolFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : array[1..toNoOfSegments] of TKeySpec;
    AltColt : TAltColtSeq;
  end;

var
  ToolFile : TToolFileDef;
  ToolRec : TToolRec;

var
  FileDefPtr : array[1..NoOfFiles] of Pointer;
  FileDefSize : array[1..NoOfFiles] of integer;
  bFilesOpen : boolean;

function OpenFiles : boolean;
var
  iCurrPos, iFileNo, iOpenStatus : integer;

  function GetNextPos : integer;
  begin
    inc(iCurrPos);
    Result := iCurrPos;
  end;

  Procedure DefineToolFile;
  Begin{DefineToolFile}
    With ToolFile do
    begin
      Fillchar(ToolFile,Sizeof(ToolFile),#0);
      iCurrPos := 0;

      RecLen := Sizeof(TToolRec);
      PageSize := DefPageSize3;                     { 1024 bytes }
      NumIndex := toNoOfKeys;

      Variable:=B_Variable+B_Compress+B_BTrunc;  { Used for max compression }

      // Index 0 : miIdxByFolio / cxIdxByFolioCode
      // RecordType + IndexA10
      KeyBuff[GetNextPos].KeyPos := BtKeyPos(@ToolRec.RecordType, @ToolRec);
      KeyBuff[iCurrPos].KeyLen := 1;
      KeyBuff[iCurrPos].KeyFlags := DupModSeg + AltColSeq;
      KeyBuff[GetNextPos].KeyPos := BtKeyPos(@ToolRec.IndexA10[1], @ToolRec);
      KeyBuff[iCurrPos].KeyLen := SizeOf(ToolRec.IndexA10) - 1;
      KeyBuff[iCurrPos].KeyFlags := DupMod + AltColSeq;

      // Index 1 : miIdxByComponentName / uxIdxByFolioName
      // RecordType + IndexB50
      KeyBuff[GetNextPos].KeyPos := BtKeyPos(@ToolRec.RecordType, @ToolRec);
      KeyBuff[iCurrPos].KeyLen := 1;
      KeyBuff[iCurrPos].KeyFlags := DupModSeg + AltColSeq;
      KeyBuff[GetNextPos].KeyPos := BtKeyPos(@ToolRec.IndexB50[1], @ToolRec);
      KeyBuff[iCurrPos].KeyLen := SizeOf(ToolRec.IndexB50) - 1;
      KeyBuff[iCurrPos].KeyFlags := DupMod + AltColSeq;

      // Index 2 : miIdxAddOrder
      // RecordType + IndexC60
      KeyBuff[GetNextPos].KeyPos := BtKeyPos(@ToolRec.RecordType, @ToolRec);
      KeyBuff[iCurrPos].KeyLen := 1;
      KeyBuff[iCurrPos].KeyFlags := DupModSeg + AltColSeq;
      KeyBuff[GetNextPos].KeyPos := BtKeyPos(@ToolRec.IndexC60[1], @ToolRec);
      KeyBuff[iCurrPos].KeyLen := SizeOf(ToolRec.IndexC60) - 1;
      KeyBuff[iCurrPos].KeyFlags := DupMod + AltColSeq;

      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
    End; { With }

    Fillchar(ToolRec,Sizeof(ToolRec),#0);

  end;{DefineToolFile}

begin{OpenFiles}
  Result := TRUE;

  if not bFilesOpen then
  begin

    // define file structures
    DefineToolFile;

    for iFileNo := 1 to NoOfFiles do begin
      // open file
{$IFDEF EXSQL}
      if SQLUtils.TableExists(asAppDir + aFileNames[iFileNo]) then iOpenStatus := 0
{$ELSE}
      if FileExists(asAppDir + aFileNames[iFileNo]) then iOpenStatus := 0
{$ENDIF}
      else begin
        iOpenStatus := BTMakeFile(FileVar[iFileNo], asAppDir + aFileNames[iFileNo]
        , FileDefPtr[iFileNo]^, FileDefSize[iFileNo]);
        if iOpenStatus <> 0 then Result := FALSE;
        BTShowError(iOpenStatus, 'BTMakeFile', asAppDir + aFileNames[iFileNo]);
      end;{if}

      if iOpenStatus = 0 then begin
        iOpenStatus := BTOpenFile(FileVar[iFileNo], asAppDir + aFileNames[iFileNo], 0);
        if iOpenStatus <> 0 then Result := FALSE;
        BTShowError(iOpenStatus, 'BTOpenFile', asAppDir + aFileNames[iFileNo]);
      end;{if}
    end;{for}
    bFilesOpen := Result;
  end;{if}
end;{OpenFiles}

procedure CloseFiles;
var
  iFileNo : integer;
begin
  for iFileNo := 1 to NoOfFiles do begin
    BTCloseFile(FileVar[iFileNo]);
  end;{for}
  bFilesOpen := FALSE;
end;

procedure InitialiseArrays;
begin
  bFilesOpen := FALSE;
  BufferSize[ToolF] := SizeOf(TToolRec);
  FileDefPtr[ToolF] := @ToolFile;
  FileDefSize[ToolF] := SizeOf(ToolFile);
end;

function BuildA10Index(sIndex : string) : string;
begin
  Result := PadString(psRight,sIndex,' ', 10);
end;

function BuildB50Index(sIndex : string) : string;
begin
  Result := PadString(psRight,sIndex,' ', 50);
end;

function BuildC60Index(sIndex : string) : string;
begin
  Result := PadString(psRight,sIndex,' ', 60);
end;

procedure SetMenuItemIndexes(var ToolRec : TToolRec);
begin
  with ToolRec, MenuItem do
  begin
    IndexA10 := BuildA10Index(BTFullNomKey(miFolioNo) + IDX_DUMMY_CHAR);
    IndexB50 := BuildB50Index(PadString(psRight,Trim(miComponentName), ' ', 50));
    IndexC60 := BuildC60Index(PadString(psRight,Trim(miParentComponentName), ' ', 50) + BTFullNomKey(miPosition) + IDX_DUMMY_CHAR);
  end;{with}
end;

procedure SetCompanyXRefIndexes(var ToolRec : TToolRec);
begin
  with ToolRec do
  begin
    IndexA10 := BuildA10Index(BTFullNomKey(ToolRec.CompanyXRef.cxItemFolio) + ToolRec.CompanyXRef.cxCompanyCode);
    IndexB50 := BuildB50Index('');
    IndexC60 := BuildC60Index('');
  end;{with}
end;

procedure SetUserXRefIndexes(var ToolRec : TToolRec);
begin
  with ToolRec do
  begin
    IndexA10 := BuildA10Index('');
    IndexB50 := BuildB50Index(BTFullNomKey(ToolRec.UserXRef.uxItemFolio) + ToolRec.UserXRef.uxUserName);
    IndexC60 := BuildC60Index('');
  end;{with}
end;

procedure SetSystemSetupIndexes(var ToolRec : TToolRec);
begin
  with ToolRec do
  begin
    IndexA10 := BuildA10Index('');
    IndexB50 := BuildB50Index('');
    IndexC60 := BuildC60Index('');
  end;{with}
end;

Initialization
  InitialiseArrays;
//  showmessage(IntToStr(SizeOf(TToolRec.doTotBonusPerTonV) * 27));
//  showmessage(IntToStr(SizeOf(TToolRec)));


//  showmessage(IntToStr(SizeOf(TKeySpec) * 27));
//  showmessage(IntToStr(SizeOf(TToolFileDef)));

//showmessage('MenuItem : ' + IntToStr(SizeOf(TMenuItemRec)));
//showmessage('UserXRef : ' + IntToStr(SizeOf(TUserXRefRec)));
//showmessage('SysSetup : ' + IntToStr(SizeOf(TSysSetupRec)));
//showmessage('CompanyXRef : ' + IntToStr(SizeOf(TCompanyXRefRec)));


Finalization
  if bFilesOpen then CloseFiles;

end.
