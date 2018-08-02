{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit NDRVSystem;

interface

Uses
  // No link to forms
  Classes,
  Windows;

{$I RPVER.PAS}
{$I NDDefines.inc}

Type
	TFileInfo = (fiCompanyName, fiFileDescription, fiFileVersion, fiIntName, fiLegalCopyright
   , fiLegalTradmark, fiOrigFilename, fiProductName, fiProductVersion, fiComments);

// Procs
  function CompareDateTime(adDate1, adDate2: TDateTime): Integer;
  function CompareInteger(anInt1, anInt2: Integer): Integer;
	function ElfHash(const s1: string): LongWord;
	procedure FileAppend(const asPathName, asData: string);
  function FileContents(const asPathname: string): string;
  procedure FileCopy(const asSourcePathname, asDestPathname: string;
   const abCanOverwrite: Boolean = false);
	procedure FileCreate(const asPathName, asData: string; const abOverwrite: boolean = true);
  procedure FileDelete(const asPathname: string);
	function FixPath(const asPath: string): string;
	function GetFileInfo(asFileName: string; axItem: TFileInfo): string;
  function GetPropertyList(pClassInfo: Pointer): TList;
	function IsNumeric(const c1: Char): Boolean;
  function MakeTempFilename: string;
	function Minutes(const iMin: Integer): TDateTime;
  procedure NotImp;
	function PosInIntArray(const iLook: Integer; Search: array of Integer): Integer;
	function PosInStrArray(const sLook: string; Search: array of string): Integer;
	procedure RaiseWin32Error(const piErr: Integer; const psMsg: string);
	procedure RaiseLastWin32Err(const psMsg: string);
  function RemoveFileExt(const AFilename: string): string;
	procedure Shell(const asCmd, asFile: string; const abWait: Boolean = false);
	function StrToCard(asValue: string): DWord;
	//Return Temp dir - use gsTempPath instead
	function TempPath: string;
  function iif(const abValue: boolean; const asTrue, asFalse: string): string; overload;
  function iif(const abValue: boolean; const anTrue, anFalse: integer): integer; overload;
{$IFNDEF LEVEL5}
  function SameText(const S1,S2: string): boolean;
  procedure FreeAndNil(var Obj);
{$ENDIF}


const
  BoolStr: array[Boolean] of string = ('False', 'True');
  BoolChar: array[Boolean] of Char = ('F', 'T');
  YesNoStr: array[Boolean] of string = ('No', 'Yes');
  CR = #13;
  LF = #10;
  TAB = #9;
  EOL = CR + LF;
  QT = '''';
  {$IFDEF Linux}
  PATHDELIM = '/';
  {$ELSE}
  PATHDELIM = '\';
  {$ENDIF}

var
  gsVoid: string = '';
  gsTempPath: String = '';
  gsAppPath: String = '';
  gsAppName: String = '';

implementation

uses
  // This is an INC file!
  // Also No link to forms
  SysUtils,
  TypInfo;

function GetPropertyList;
var
  i, iPropCount: integer;
	PropList: PPropList;
begin
  result := TList.Create; try
    iPropCount := GetTypeData(pClassInfo)^.PropCount;
    if iPropCount > 0 then begin
      GetMem(PropList, iPropCount * SizeOf(Pointer)); try
        // GetPropInfos could also be used - but will return unsorted, and cannot be filtered
        iPropCount := GetPropList(pClassInfo, tkProperties, PropList);
        for i := 0 to Pred(iPropCount) do begin
          Result.Add(PropList^[i]);
        end;
      finally FreeMem(PropList); end;
    end;
  except Result.Free; end;
end;

function MakeTempFilename;
begin
  SetLength(result, MAX_PATH + 1);
  if GetTempFileName(PChar(gsTempPath), 'KDZ', 0, PChar(result)) = 0 then begin
    raise exception.create('MakeTempFileName error.');
  end;
  result := PChar(Result);
end;

Function TempPath;
Var
	i: integer;
begin
  SetLength(Result, MAX_PATH);
	i := GetTempPath(Length(Result), PChar(Result));
	SetLength(Result, i);

	if Copy(Result, Length(Result), 1) <> PATHDELIM then begin
    Result := Result + PATHDELIM; {Will ONLY already have if C:\}
  end;
end;

procedure NotImp;
begin
  raise Exception.Create('Not implemented.');
end;

procedure RaiseLastWin32Err(const psMsg: string);
begin
	RaiseWin32Error(GetLastError, psMsg)
end;

procedure RaiseWin32Error(const piErr: Integer; const psMsg: string);
begin
	if piErr <> ERROR_SUCCESS then begin
		raise Exception.CreateFmt('Win32 Error. Code: %d.'#10'%s' + EOL + psMsg, [piErr, SysErrorMessage(piErr)])
	end else begin
		raise Exception.Create('A Win32 API function failed' + EOL + psMsg);
  end;
end;

function FixPath(const asPath: string): string;
begin
	Result := asPath;
	if Length(Result) > 0 then begin
		if Result[Length(Result)] <> PATHDELIM then begin
      result := Result + PATHDELIM;
    end;
  end;
end;

procedure FileAppend;
begin
	with TFileStream.Create(asPathName, fmOpenWrite) do try
		Position := Size;
		WriteBuffer(asData[1], Length(asData));
	finally Free; end;
end;

procedure FileCreate;
begin
	if FileExists(asPathname) and (abOverwrite = false) then begin
  	raise Exception.Create(asPathname + ' already exists.');
  end;
	with TFileStream.Create(asPathName, fmCreate) do try
  	if Length(asData) > 0 then begin
			WriteBuffer(asData[1], Length(asData));
    end;
	finally Free; end;
end;

procedure FileCopy;
begin
	if CopyFile(PChar(asSourcePathname), PChar(asDestPathname), not abCanOverwrite) = False then begin
  	{TODO change this to raisegetlasterror}
		raise Exception.Create('Copy Failed (' + IntToStr(GetLastError) + '): ' + asDestPathname);
  end;
end;

function FileContents;
begin
	Result := '';
	if FileExists(asPathName) then begin
		with TFileStream.Create(asPathName, fmOpenRead + fmShareDenyWrite	) do try
      if Size > 0 then begin
        SetLength(Result, Size);
        ReadBuffer(Result[1], Size);
      end;
		finally Free; end;
	end;
end;

function CompareInteger;
begin
	if anInt1 > anInt2 then begin
  	result := 1;
  end else if anInt2 > anInt1 then begin
  	result := -1;
  end else begin
  	result := 0;
  end;
end;

function CompareDateTime;
begin
	if adDate1 > adDate2 then begin
  	result := 1;
  end else if adDate2 > adDate1 then begin
  	result := -1;
  end else begin
  	result := 0;
  end;
end;

function IsNumeric(const c1: Char): Boolean;
begin
	Result := IsCharAlphaNumeric(c1) and not IsCharAlpha(c1);
end;

function Minutes(const iMin: Integer): TDateTime;
begin
	Result := EncodeTime(iMin div 60, iMin mod 60, 0, 0);
end;

function PosInIntArray;
var
	i1: integer;
begin
	result := -1;
	for i1 := low(Search) to high(Search) do begin
  	if iLook = Search[i1] then begin
    	result := i1;
    	break;
    end;
  end;
end;

function PosInStrArray;
var
	i1: integer;
begin
	result := -1;
	for i1 := low(Search) to high(Search) do begin
  	if sLook = Search[i1] then begin
    	result := i1;
    	break;
    end;
  end;
end;

procedure Shell;
var
	PCmd: PChar;
	StartInfo: TStartupInfo;
	ProcInfo: TProcessInformation;
begin
	// Fill with known state
	FillChar(StartInfo, SizeOf(TStartupInfo), #0);
	FillChar(ProcInfo, SizeOf(TProcessInformation), #0);
	StartInfo.cb := SizeOf(TStartupInfo);

	if length(asCmd) = 0 then begin
    PCmd := nil
  end else begin
    PCmd := PChar(asCmd);
  end;

	if CreateProcess(PCmd, PChar(asFile), nil, nil, False, NORMAL_PRIORITY_CLASS, nil, nil, StartInfo
   , ProcInfo) then begin
			if abWait then begin
        WaitForSingleObject(ProcInfo.hProcess, INFINITE)
      end;
  end else begin
    RaiseLastWin32Err('Shell: ' + asCmd + ' : ' + asFile);
  end;
end;

const
  cCompName = 'CompanyName';
  cFileDesc = 'FileDescription';
  cFileVer  = 'FileVersion';
  cIntName  = 'InternalName';
  cLegCopy  = 'LegalCopyright';
  cLegTrad  = 'LegalTrademarks';
  cOrgFile  = 'OriginalFilename';
  cProdName = 'Productname';
  cProdVer  = 'ProductVersion';
  cComments = 'Comments';

function GetFileInfo;
var
  Buffer: string;
  LangCharset: ^longint;
  Value: pointer;
  Len: DWORD;
  sItem: string;
begin
	case axItem of
		fiCompanyName: sItem := 'CompanyName';
    fiFileDescription: sItem := 'FileDescription';
    fiFileVersion: sItem := 'FileVersion';
    fiIntName: sItem := 'InternalName';
    fiLegalCopyright: sItem := 'LegalCopyright';
    fiLegalTradmark: sItem := 'LegalTrademarks';
    fiOrigFilename: sItem := 'OriginalFilename';
    fiProductName: sItem := 'Productname';
    fiProductVersion: sItem := 'ProductVersion';
    fiComments: sItem := 'Comments';
  end;
  Result := '';
  Len := GetFileVersionInfoSize(PChar(asFileName), Len);
  If Len > 0 then begin
    SetLength(Buffer,Len);
    If GetFileVersionInfo(PChar(asFileName), 0, Len, PChar(Buffer)) then begin
			VerQueryValue(PChar(Buffer), '\VarFileInfo\Translation', pointer(LangCharset), Len);
      If VerQueryValue(PChar(Buffer), PChar('\StringFileInfo\' + IntToHex(LoWord(LangCharset^),4)
       + IntToHex(HiWord(LangCharset^),4) + '\' + sItem), Value, Len) then begin
        Result := PChar(Value);
      end;
    end;
  end;
end;

function iif(const abValue: boolean; const asTrue, asFalse: string): string; overload;
begin
	if abValue then begin
  	result := asTrue;
  end else begin
  	result := asFalse;
  end;
end;

function iif(const abValue: boolean; const anTrue, anFalse: integer): integer; overload;
begin
	if abValue then begin
  	result := anTrue;
  end else begin
  	result := anFalse;
  end;
end;

function StrToCard(asValue: string): DWord;
var
  i: integer;
  nDigit: DWord;
begin
  result := 0;
	for i := 1 to length (asValue) do begin
  	// nDigit is split out to avoid widening of operands warning
  	nDigit := ord(asValue[i]) - ord('0');
  	result := (result * 10) + nDigit;
	end;
end;

function ElfHash(const s1: string): LongWord;
var
	g, h: LongInt;
	i1: Integer;
begin
	h := 0;
	for i1 := 1 to length(s1) do begin
		h := (h shl 4) + Ord(s1[i1]);
		g := h and $F000000;
		if g <> 0 then begin
    	h := h xor (g Shr 24);
    end;
		h := h and not g;
	end;
	Result := h;
end;

procedure FileDelete(const asPathname: string);
begin
  if not SysUtils.DeleteFile(asPathname) then begin
    raise exception.create(asPathname + ' could not be deleted.');
  end;
end;

{$IFNDEF LEVEL5}
function SameText(const S1,S2: string): boolean;

begin { SameText }
  Result := CompareString(LOCALE_USER_DEFAULT,NORM_IGNORECASE,PChar(S1),
   Length(S1),PChar(S2),Length(S2)) = 2;
end;  { SameText }

procedure FreeAndNil(var Obj);
var
  TempObj: TObject;
begin { FreeAndNil }
  TempObj := TObject(Obj);
  TObject(Obj) := nil;
  TempObj.Free;
end;  { FreeAndNil }
{$ENDIF}

function RemoveFileExt(const AFilename: string): string;
begin
  result := ChangeFileExt(AFilename, '.nul');
  SetLength(result, length(result) - 4);
end;

initialization
  gsAppPath := FixPath(ExtractFilePath(ParamStr(0)));
  gsAppName := ChangeFileExt(ExtractFilename(ParamStr(0)), '.nul');
  SetLength(gsAppName, Length(gsAppName) - 4);
  gsTempPath := TempPath;
end.