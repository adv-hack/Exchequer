
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TRVOfficeConverter: component providing         }
{       interface for Microsoft(R) Office               }
{       Text Converters                                 }
{       (registered on "RichView" page of               }
{       the Component Palette)                          }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVOfficeCnv;

interface
{$I RV_Defs.inc}

uses Windows, Classes, SysUtils,
     RVClasses, Forms, RichView, RVTypes;

  {
    Error codes for converters. They are assigned to converter.ErrorCode
    after import/export operation.
  }
const
  // errors running converter
  rvceCnvLoadError   = 1;       // error loading converter's DLL
  rvceFuncError      = 2;       // required function is not found in converter's DLL
  rvceInitError      = 3;       // converter initialization failure

  // errors returned by converters; this is NOT an exhaustive list!
  rvceOpenInFileErr  = -1;	// could not open input file
  rvceReadErr	     = -2;	// error during read
  rvceOpenConvErr    = -3;	// error opening conversion file
  rvceWriteErr	     = -4;	// error during write
  rvceInvalidFile    = -5;	// invalid data in conversion file
  rvceOpenExceptErr  = -6;	// error opening exception file
  rvceWriteExceptErr = -7;	// error writing exception file
  rvceNoMemory	     = -8;	// out of memory
  rvceInvalidDoc     = -9;	// invalid document
  rvceDiskFull	     = -10;	// out of space on output
  rvceDocTooLarge    = -11;	// conversion document too large for target
  rvceOpenOutFileErr = -12;	// could not open output file
  rvceUserCancel     = -13;     // conversion cancelled by user
  rvceWrongFileType  = -14;     // wrong file type for this converter

type
  TRVOfficeConverterInfo = class
    public
      ClsName: TRVAnsiString;
      Name, Path, Filter: String;
  end;


  TInitConverter32 = function(hwndWord: HWND; szModule: PRVAnsiChar): Integer; stdcall;
  TUninitConverter = procedure; stdcall;
  TForeignToRtf32Callback = function (cchBuff, nPercent: Integer): Integer; stdcall;
  TRtfToForeign32Callback = function (rgfOptions, nReserved: Integer): Integer; stdcall;
  TForeignToRtf32 = function (ghszFile: HGLOBAL; pstgForeign: Pointer; ghBuff,
    ghszClass, ghszSubset: HGLOBAL; lpfnOut: TForeignToRtf32Callback): SmallInt; stdcall;
  TRtfToForeign32 = function(ghszFile: HGLOBAL; pstgForeign: Pointer;
    ghBuff, ghszClass: HGLOBAL; lpfnIn: TRtfToForeign32Callback): SmallInt; stdcall;
  TRegisterApp = function(lFlags: Integer; lpRegApp: Pointer):HGLOBAL; stdcall;
  TIsFormatCorrect32 = Function(ghszFile, ghszClass: HGLOBAL): SmallInt; stdcall;
  TConvertingEvent = procedure (Sender:TObject; Percent: Integer) of object;

  TRVOfficeConverter = class;

  TRVOfficeCnvList = class (TRVList)
    private
      FOwner: TRVOfficeConverter;
      hBuffer: HGLOBAL;
      FOnConverting: TConvertingEvent;
      FStream: TRVMemoryStream;
      FStep, FStart, FSize: Integer;
      procedure Put(Index: Integer; Value: TRVOfficeConverterInfo);
      function Get(Index: Integer):TRVOfficeConverterInfo;
      procedure LoadList(const RegPath: String; ExcludeHTML: Boolean);
    public
      constructor Create(const RegPath: String; Owner: TRVOfficeConverter;
                         ExcludeHTML: Boolean);
      function GetFilter(IncludeExtensions: Boolean): String;
      procedure ImportRTF(const FileName: String; Index: Integer);
      procedure ExportRTF(const FileName: String; Index: Integer);
      function IsFormatCorrect(const FileName: String; Index: Integer): Boolean; 
      property Items[Index: Integer]: TRVOfficeConverterInfo read Get write Put; default;
  end;

  TRVOfficeConverter = class (TComponent)
    private
      FImportConverters, FExportConverters: TRVOfficeCnvList;
      FOnConverting: TConvertingEvent;
      FStream: TRVMemoryStream;
      FExcludeHTMLImportConverter: Boolean;
      FExcludeHTMLExportConverter: Boolean;
      FPreviewMode: Boolean;
      FErrorCode: Integer;
      FExtensionsInFilter: Boolean;
      function GetExportConverters: TRVOfficeCnvList;
      function GetImportConverters: TRVOfficeCnvList;
      procedure SetExcludeHTMLExportConverter(const Value: Boolean);
      procedure SetExcludeHTMLImportConverter(const Value: Boolean);
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function ImportRTF(const FileName: String; ConverterIndex: Integer): Boolean;
      function ExportRTF(const FileName: String; ConverterIndex: Integer): Boolean;
      function ImportRV(const FileName: String; rv: TCustomRichView;
        ConverterIndex: Integer): Boolean;
      function ExportRV(const FileName: String; rv: TCustomRichView;
        ConverterIndex: Integer): Boolean;
      function GetImportFilter: String;
      function GetExportFilter: String;
      function IsValidImporter(const FileName: String; Index: Integer): Boolean;
      property ImportConverters: TRVOfficeCnvList read GetImportConverters;
      property ExportConverters: TRVOfficeCnvList read GetExportConverters;
      property Stream: TRVMemoryStream read FStream;
      property ErrorCode: Integer read FErrorCode;
    published
      property ExcludeHTMLImportConverter: Boolean read FExcludeHTMLImportConverter
        write SetExcludeHTMLImportConverter default False;
      property ExcludeHTMLExportConverter: Boolean read FExcludeHTMLExportConverter
        write SetExcludeHTMLExportConverter default False;
      property PreviewMode: Boolean read FPreviewMode write FPreviewMode default False;
      property ExtensionsInFilter: Boolean read FExtensionsInFilter write FExtensionsInFilter default False;
      property OnConverting: TConvertingEvent read FOnConverting write FOnConverting;
  end;

implementation

var Converters: TRVOfficeCnvList;
{==============================================================================}
{$IFNDEF RICHVIEWDEF6}
function GetEnvironmentVariable(const Name: string): string;
var
  Len: integer;
begin
  Result := '';
  Len := Windows.GetEnvironmentVariable(PChar(Name), nil, 0);
  if Len > 0 then
  begin
    SetLength(Result, Len - 1);
    Windows.GetEnvironmentVariable(PChar(Name), PChar(Result), Len);
  end;
end;
{$ENDIF}
const CommonProgramFiles='COMMONPROGRAMFILES';
function ExpandConverterPath(const Path: String): String;
var p: Integer;
begin
  Result := Path;
  p := Pos('%'+CommonProgramFiles+'%', AnsiUpperCase(Path));
  if p=0 then
    exit;
  Delete(Result, p, Length(CommonProgramFiles)+2);
  Insert(GetEnvironmentVariable(CommonProgramFiles), Result, p);
end;
{==============================================================================}
function ForeignToRtf32Callback(cchBuff, nPercent: Integer): Integer; stdcall;
var p: Pointer;
begin
  if Assigned(Converters.FOnConverting) then
    Converters.FOnConverting(Converters.FOwner, nPercent);
  if Assigned(Converters.FOnConverting) then
    Converters.FOnConverting(Converters.FOwner, nPercent);
  Result := 0;
  if cchBuff=0 then
    exit;
  p := GlobalLock(Converters.hBuffer);
  Converters.FStream.WriteBuffer(p^,cchBuff);
  GlobalUnlock(Converters.hBuffer);
end;
{------------------------------------------------------------------------------}
function RtfToForeign32Callback(rgfOptions, nReserved: Integer): Integer; stdcall;
var p: Pointer;
begin
  Result := Converters.FStream.Size-Converters.FStream.Position;
  if Result>Converters.FStep then
    Result :=Converters.FStep;
  if Result>0 then begin
    p := GlobalLock(Converters.hBuffer);
    Converters.FStream.ReadBuffer(p^, Result);
    GlobalUnlock(Converters.hBuffer);
  end;
  if Assigned(Converters.FOnConverting) then
    Converters.FOnConverting(Converters.FOwner,  (Converters.FStream.Position-Converters.FStart)*100 div Converters.FSize);
end;
{======================== TRVOfficeCnvList =================================}
procedure TRVOfficeCnvList.Put(Index: Integer; Value: TRVOfficeConverterInfo);
begin
  inherited Put(Index, Value);
end;
{------------------------------------------------------------------------------}
function TRVOfficeCnvList.Get(Index: Integer):TRVOfficeConverterInfo;
begin
  Result := TRVOfficeConverterInfo(inherited Get(Index));
end;
{------------------------------------------------------------------------------}
constructor TRVOfficeCnvList.Create(const RegPath: String; Owner: TRVOfficeConverter; ExcludeHTML: Boolean);
begin
  inherited Create;
  FOwner := Owner;
  try
    LoadList(RegPath, ExcludeHTML);
  except
  ;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVOfficeCnvList.LoadList(const RegPath: String; ExcludeHTML: Boolean);
var key, subkey: HKEY;
    KeyName, KeyBuf: String;
    i: Integer;
    Item: TRVOfficeConverterInfo;
    {........................................}
    function DecodeExt(s: String): String;
    var p: Integer;
        s1: String;
    begin
      Result := '';
      while s<>'' do begin
        p := Pos(' ',s);
        if p=0 then begin
          s1 := s;
          s  := '';
          end
        else begin
          s1 := Copy(s,1,p-1);
          s  := Copy(s,p+1,Length(s));
        end;
        if Result<>'' then
          Result := Result+';';
        Result := Result+'*.'+s1;
      end;
    end;
    {........................................}
    function ReadString(Key: HKEY; const ValueName: String; var Value: String): Boolean;
    var l: Integer;
    begin
      SetLength(Value, MAX_PATH);
      l := MAX_PATH;
      Result := RegQueryValueEx(Key, PChar(ValueName), nil, nil, PByte(Value), @l)=ERROR_SUCCESS;
      if Result then begin
        {$IFDEF RVUNICODESTR}
        l := l div 2;
        {$ENDIF}
        SetLength(Value, l-1);
      end;
    end;
    {........................................}
begin
   Clear;
   SetLength(KeyBuf, MAX_PATH);
   if RegOpenKeyEx(HKEY_LOCAL_MACHINE, PChar(RegPath), 0, KEY_READ, Key)<>ERROR_SUCCESS then
     exit;
   try
     i := 0;
     while RegEnumKey(Key, i, PChar(KeyBuf), MAX_PATH+1)=ERROR_SUCCESS do begin
       KeyName := PChar(KeyBuf);
       if RegOpenKeyEx(HKEY_LOCAL_MACHINE, PChar(RegPath+'\'+KeyName), 0, KEY_READ, SubKey)=ERROR_SUCCESS then
         try
           Item := TRVOfficeConverterInfo.Create;
           Item.ClsName:= {$IFDEF RVUNICODESTR}TRVAnsiString{$ENDIF}(KeyName);
           if ReadString(SubKey, 'Name', Item.Name) and
              ReadString(SubKey, 'Path', Item.Path) and
              ReadString(SubKey, 'Extensions', Item.Filter) and
              (not ExcludeHTML or (AnsiCompareText(ExtractFileName(Item.Path),'HTML32.CNV')<>0))
               then begin
             Item.Path := ExpandConverterPath(Item.Path);
             Item.Filter := DecodeExt(Item.Filter);
             Add(Item)
             end
           else
             Item.Free;
         finally
           RegCloseKey(SubKey);
         end;
       inc(i);
     end;
   finally
     RegCloseKey(Key);   
   end;
end;
{------------------------------------------------------------------------------}
function TRVOfficeCnvList.GetFilter(IncludeExtensions: Boolean): String;
var i: Integer;
begin
  Result := '';
  for i := 0 to Count-1 do begin
    if i>0 then
      Result := Result + '|';
    if IncludeExtensions then
      Result := Result + Items[i].Name+' ('+Items[i].Filter+')|'+Items[i].Filter
    else
      Result := Result + Items[i].Name+'|'+Items[i].Filter;
  end;
end;

{$A-}
type TAppInfo = record
	cbStruct: SmallInt;

	cbSizeVer: Byte;
	opcodeVer: Byte;
	verMajor: SmallInt;
	verMinor: SmallInt;

        cbSizeCharset: Byte;
        opcodeCharset: Byte;
        Charset:       Byte;

     end;
const AppInfo: TAppInfo =
    (
	cbStruct: sizeof(TAppInfo);

	cbSizeVer: 1+1+2+2;
	opcodeVer: $01;
	verMajor: 20;
	verMinor: 0;

        cbSizeCharset: 1+1+1;
        opcodeCharset: $03;
        Charset:       DEFAULT_CHARSET;
    );
{------------------------------------------------------------------------------}
function GetFileNameHandle(const FileName: String): HGLOBAL;
var pc: PRVAnsiChar;
begin
  Result := GlobalAlloc(GHND, Length(FileName)+1);
  pc := GlobalLock(Result);
  CharToOEM(PChar(FileName), pc);
  GlobalUnlock(Result);
end;

function GetStringHandle(const s: TRVAnsiString): HGLOBAL;
var pc: PRVAnsiChar;
begin
  Result := GlobalAlloc(GHND, Length(s)+1);
  pc := GlobalLock(Result);
  Move(PRVAnsiChar(s)^, pc^, Length(s));
  GlobalUnlock(Result);  
end;
{------------------------------------------------------------------------------}
procedure TRVOfficeCnvList.ImportRTF(const FileName: String;
  Index: Integer);
var hLib : HMODULE;
    ExeName: TRVAnsiString;
    InitConverter32:TInitConverter32;
    UninitConverter:TUninitConverter;
    ForeignToRtf32: TForeignToRtf32;
    RegisterApp: TRegisterApp;
    hFileName, {hClassName, }hPref: HGLOBAL;
begin
   FStream.Clear;
   Converters := Self;
   SetLength(ExeName, Length(Application.ExeName));
   CharToOEM(PChar(Application.ExeName), PRVAnsiChar(ExeName));
   hFileName     :=  GetFileNameHandle(FileName);
   //hClassName     :=  GetStringHandle(Items[Index].ClsName);
   hBuffer := GlobalAlloc(GHND, 4096);
   hLib := LoadLibrary(PChar(Items[Index].Path));
   if hLib=0 then begin
     FOwner.FErrorCode := rvceCnvLoadError;
     abort;
   end;
   try
      InitConverter32 := GetProcAddress(hLib, 'InitConverter32');
      if not Assigned(InitConverter32) then begin
        FOwner.FErrorCode := rvceFuncError;
        abort;
      end;
      if InitConverter32(Application.Handle, PRVAnsiChar(ExeName))=0 then begin
        FOwner.FErrorCode := rvceInitError;
        abort;
      end;
      RegisterApp := GetProcAddress(hLib, 'RegisterApp');
      if Assigned(RegisterApp) then begin
        if FOwner.PreviewMode then
          hPref := RegisterApp(4,@AppInfo)
        else
          hPref := RegisterApp(0,@AppInfo);
        if hPref<>0 then
          GlobalFree(hPref);
      end;
      try
        ForeignToRtf32 := GetProcAddress(hLib, 'ForeignToRtf32');
        if not Assigned(ForeignToRtf32) then begin
          FOwner.FErrorCode := rvceFuncError;
          abort;
        end;
        FOwner.FErrorCode := ForeignToRtf32(hFileName,nil,hBuffer, 0 {hClassName},
          0,ForeignToRtf32Callback);
        if FOwner.FErrorCode<>0 then
          abort;
      finally
        UninitConverter := GetProcAddress(hLib, 'UninitConverter');
        if Assigned(UninitConverter) then
          UninitConverter;
      end;
   finally
     FreeLibrary(hLib);
     GlobalFree(hBuffer);
     //GlobalFree(hClassName);
     GlobalFree(hFileName);
   end;
end;
{------------------------------------------------------------------------------}
procedure TRVOfficeCnvList.ExportRTF(const FileName: String;
  Index: Integer);
var hLib : HMODULE;
    ExeName: TRVAnsiString;
    InitConverter32:TInitConverter32;
    UninitConverter:TUninitConverter;
    RtfToForeign32: TRtfToForeign32;
    RegisterApp: TRegisterApp;
    hFileName, hClassName, hPref: HGLOBAL;
begin
   Converters := Self;
   FStart := FStream.Position;
   FSize  := FStream.Size-FStart;
   if FSize=0 then
     exit;
   FStep := 4096;
   if FStep>FSize then
     FStep := FSize;
   if Assigned(Converters.FOnConverting) then
     Converters.FOnConverting(Self, 0);
   SetLength(ExeName, Length(Application.ExeName));
   CharToOEM(PChar(Application.ExeName), PRVAnsiChar(ExeName));
   hFileName     :=  GetFileNameHandle(FileName);
   hClassName := GetStringHandle(Items[Index].ClsName);
   hBuffer := GlobalAlloc(GHND, FStep);
   hLib := LoadLibrary(PChar(Items[Index].Path));
   if hLib=0 then begin
     FOwner.FErrorCode := rvceCnvLoadError;
     abort;
   end;
   try
      InitConverter32 := GetProcAddress(hLib, 'InitConverter32');
      if not Assigned(InitConverter32) then begin
        FOwner.FErrorCode := rvceFuncError;
        abort;
      end;
      if InitConverter32(Application.Handle, PRVAnsiChar(ExeName))=0 then begin
        FOwner.FErrorCode := rvceInitError;
        abort;
      end;
      RegisterApp := GetProcAddress(hLib, 'RegisterApp');
      if Assigned(RegisterApp) then begin
        hPref := RegisterApp(0,@AppInfo);
        if hPref<>0 then
          GlobalFree(hPref);
      end;
      try
        RtfToForeign32 := GetProcAddress(hLib, 'RtfToForeign32');
        if not Assigned(RtfToForeign32) then begin
          FOwner.FErrorCode := rvceFuncError;
          abort;
        end;
        FOwner.FErrorCode := RtfToForeign32(hFileName, nil, hBuffer, hClassName,
          RtfToForeign32Callback);
        if FOwner.FErrorCode<>0 then
          abort;
      finally
        UninitConverter := GetProcAddress(hLib, 'UninitConverter');
        if Assigned(UninitConverter) then
          UninitConverter;
      end;
   finally
     FreeLibrary(hLib);
     GlobalFree(hBuffer);
     GlobalFree(hClassName);
     GlobalFree(hFileName);
   end;
end;
{------------------------------------------------------------------------------}
function TRVOfficeCnvList.IsFormatCorrect(const FileName: String;
  Index: Integer): Boolean;
var hLib : HMODULE;
    ExeName: TRVAnsiString;
    InitConverter32:TInitConverter32;
    UninitConverter:TUninitConverter;
    IsFormatCorrect32: TIsFormatCorrect32;
    RegisterApp: TRegisterApp;
    hFileName, hClassName, hPref: HGLOBAL;
begin
  if not FileExists(Filename) then begin
    fOwner.fErrorCode:=  rvceOpenInFileErr;
    abort;
  end;
  SetLength(ExeName, Length(Application.ExeName));
  CharToOEM(PChar(Application.ExeName), PRVAnsiChar(ExeName));
  hFileName     :=  GetFileNameHandle(FileName);
  hClassName := GetStringHandle(Items[Index].ClsName);
  hLib := LoadLibrary(PChar(Items[Index].Path));
  if hLib=0 then begin
    FOwner.FErrorCode := rvceCnvLoadError;
    abort;
  end;
  try
    Result:= false;
    InitConverter32 := GetProcAddress(hLib, 'InitConverter32');
    if not Assigned(InitConverter32) then begin
      FOwner.FErrorCode := rvceFuncError;
      abort;
    end;
    if InitConverter32(Application.Handle, PRVAnsiChar(ExeName))=0 then begin
      FOwner.FErrorCode := rvceInitError;
      abort;
    end;
    RegisterApp := GetProcAddress(hLib, 'RegisterApp');
    if Assigned(RegisterApp) then begin
      hPref := RegisterApp(0,@AppInfo);
      if hPref<>0 then
        GlobalFree(hPref);
    end;
    try
      IsFormatCorrect32 := GetProcAddress(hLib, 'IsFormatCorrect32');
      if not Assigned(IsFormatCorrect32) then begin
        FOwner.FErrorCode := rvceFuncError;
        abort;
      end;
      FOwner.FErrorCode := IsFormatCorrect32(hFileName, hClassName);
      Result:= (FOwner.FErrorCode=1);
      if FOwner.FErrorCode=1 then
        FOwner.FErrorCode := 0;
    finally
      UninitConverter := GetProcAddress(hLib, 'UninitConverter');
      if Assigned(UninitConverter) then
        UninitConverter;
    end;
  finally
    FreeLibrary(hLib);
    GlobalFree(hClassName);
    GlobalFree(hFileName);
  end;
end;
{============================ TRVOfficeConverter ==============================}
constructor TRVOfficeConverter.Create(AOwner: TComponent);
begin
  inherited;
  FStream := TRVMemoryStream.Create;
end;
{------------------------------------------------------------------------------}
destructor TRVOfficeConverter.Destroy;
begin
  FExportConverters.Free;
  FImportConverters.Free;
  FStream.Free;
  inherited;
end;
{------------------------------------------------------------------------------}
function TRVOfficeConverter.GetExportConverters: TRVOfficeCnvList;
begin
   if FExportConverters=nil then
     FExportConverters := TRVOfficeCnvList.Create('SOFTWARE\Microsoft\Shared Tools\Text Converters\Export', Self,
       ExcludeHTMLExportConverter);
   Result := FExportConverters;
end;
{------------------------------------------------------------------------------}
function TRVOfficeConverter.GetImportConverters: TRVOfficeCnvList;
begin
   if FImportConverters=nil then
     FImportConverters := TRVOfficeCnvList.Create('SOFTWARE\Microsoft\Shared Tools\Text Converters\Import', Self,
       ExcludeHTMLImportConverter);
   Result := FImportConverters;
end;
{------------------------------------------------------------------------------}
function TRVOfficeConverter.GetImportFilter: String;
begin
  Result := ImportConverters.GetFilter(ExtensionsInFilter);
end;
{------------------------------------------------------------------------------}
function TRVOfficeConverter.GetExportFilter: String;
begin
  Result := ExportConverters.GetFilter(ExtensionsInFilter);
end;
{------------------------------------------------------------------------------}
function TRVOfficeConverter.IsValidImporter(const FileName: String; Index: Integer): Boolean;
begin
  Result := ImportConverters.IsFormatCorrect(Filename, Index);
end;
{------------------------------------------------------------------------------}
function TRVOfficeConverter.ImportRTF(const FileName: String;
  ConverterIndex: Integer): Boolean;
begin
  FErrorCode := 0;
  ImportConverters.FStream := Stream;
  FImportConverters.FOnConverting := OnConverting;
  try
    FImportConverters.ImportRTF(FileName, ConverterIndex);
    Result := True;
  except
    Result := False;
  end;
end;
{------------------------------------------------------------------------------}
function TRVOfficeConverter.ExportRTF(const FileName: String;
  ConverterIndex: Integer): Boolean;
begin
  FErrorCode := 0;
  ExportConverters.FStream := Stream;
  FExportConverters.FOnConverting := OnConverting;
  try
    FExportConverters.ExportRTF(FileName, ConverterIndex);
    Result := True;
  except
    Result := False;
  end;
end;
{------------------------------------------------------------------------------}
function TRVOfficeConverter.ExportRV(const FileName: String; rv: TCustomRichView;
  ConverterIndex: Integer): Boolean;
begin
  FErrorCode := 0;
  Stream.Clear;
  Result := rv.SaveRTFToStream(Stream,False);
  if Result then begin
    FStream.Position := 0;
    Result := ExportRTF(FileName, ConverterIndex);
  end;
  Stream.Clear;
end;
{------------------------------------------------------------------------------}
function TRVOfficeConverter.ImportRV(const FileName: String; rv: TCustomRichView;
  ConverterIndex: Integer): Boolean;
begin
  FErrorCode := 0;
  Result := ImportRTF(FileName, ConverterIndex);
  FStream.Position := 0;
  Result := rv.LoadRTFFromStream(Stream) and Result;
  Stream.Clear;
end;
{------------------------------------------------------------------------------}
procedure TRVOfficeConverter.SetExcludeHTMLExportConverter(
  const Value: Boolean);
begin
  if FExcludeHTMLExportConverter<>Value then begin
    FExcludeHTMLExportConverter := Value;
    FExportConverters.Free;
    FExportConverters := nil;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVOfficeConverter.SetExcludeHTMLImportConverter(
  const Value: Boolean);
begin
  if FExcludeHTMLImportConverter<>Value then begin
    FExcludeHTMLImportConverter := Value;
    FImportConverters.Free;
    FImportConverters := nil;
  end;
end;

end.
