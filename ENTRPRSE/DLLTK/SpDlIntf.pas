unit spdlintf;
{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }
{$WARN SYMBOL_PLATFORM OFF}
interface
{$DEFINE DLoad}
uses
  Crypto;

  FUNCTION SP_INITDLL : SMALLINT; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

  Function SP_INITDLLPATH(EXPATH    :  PCHAR;
                          MCSYSTEM  :  WORDBOOL) :  SMALLINT; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;


  FUNCTION SP_CLOSEDLL : SMALLINT; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

  FUNCTION SP_VERSION : SHORTSTRING; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;


  function SP_CHECKCONVERSION(P     : Pointer;
                            PSize : longint;
                            Consolidate : Boolean) : SmallInt;
                           {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

  function SP_CONVERTTRANSACTION(P     : Pointer;
                               PSize : longint;
                               Consolidate : Boolean) : SmallInt;
                           {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

  function SP_COPYTRANSACTION(RefNo : PChar) : SmallInt;
                           {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

  function SP_REVERSETRANSACTION(RefNo : PChar) : SmallInt;
                           {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

  function SP_BACKTOBACKORDER(P : Pointer;
                              OutP : Pointer;
                              PSize : LongInt;
                              var OutPSize : LongInt;
                              RefNo : PChar) : SmallInt;
                              STDCALL  EXPORT;

  FUNCTION SP_SetReleaseCode(Code : PChar) : SmallInt;{$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

  function SP_CREATERETURN(P     : Pointer;
                          PSize : longint;
                          P2 : Pointer;
                          P2Size : longint) : SmallInt;
                          STDCALL  EXPORT;

  function SP_ACTIONRETURN(P     : Pointer;
                          PSize : longint;
                          P2 : Pointer;
                          P2Size : longint) : SmallInt;
                          STDCALL  EXPORT;

  function SetSPBackDoor : Integer; STDCALL EXPORT;

  function SP_UPDATERECONCILEFLAG(RecordPos : longint;
                                  NewValue : SmallInt) : SmallInt;
                                  STDCALL  EXPORT;


  

implementation

uses
  Windows, VarCnst3,  SysUtils, FileUtil;

const
  DllName = 'ENTDLLSP.DLL';

{$IFDEF DLoad}  //Load dll dynamically

type

  TInitSPDlFunc = function : smallint; stdcall;
  TVersionFunc = function : ShortString;stdcall;
  TConvertFunc = function(P     : Pointer;
                          PSize : longint;
                          Consolidate : Boolean) : SmallInt; stdcall;
  TCopyFunc = function(RefNo : PChar) : SmallInt; stdcall;
  TB2BFunc = function(P : Pointer;
                      OutP : Pointer;
                      PSize : LongInt;
                  var OutPSize : LongInt;
                      RefNo : PChar) : SmallInt; stdcall;
  TInitPathFunc = function(EXPATH    :  PCHAR;
                          MCSYSTEM  :  WORDBOOL) :  SMALLINT; stdcall;
  TSetReleaseFunc = procedure(Code : PChar); stdcall;
  TCreateReturnFunc = function(P     : Pointer;
                               PSize : longint;
                               P2 : Pointer;
                               P2Size : longint) : SmallInt; stdcall;
  TReconcileFunc = function(RecordPos : longint;
                            NewValue : SmallInt) : SmallInt; stdcall;

var
  _InitDll,
  _CloseDll   : TInitSPDlFunc;

  _InitPath   : TInitPathFunc;

  _Version    : TVersionFunc;

  _CheckConversion,
  _ConvertTransaction : TConvertFunc;

  _CopyTransaction,
  _ReverseTransaction : TCopyFunc;

  _BackToBackOrder : TB2BFunc;

  _SetReleaseCode : TSetReleaseFunc;

  _CreateReturn : TCreateReturnFunc;
  _ActionReturn : TCreateReturnFunc;

  _UpdateReconcile : TReconcileFunc;

  LibHandle : THandle;
  LibraryLoaded : Boolean;

  procedure SetAddressesToNil;
  begin
    LibraryLoaded := False;

    _InitDll := nil;
    _CloseDll := nil;
    _Version := nil;
    _CheckConversion := nil;
    _ConvertTransaction := nil;
    _CopyTransaction := nil;
    _ReverseTransaction := nil;
    _BackToBackOrder := nil;
    _InitPath := nil;
    _SetReleaseCode := nil;
    _CreateReturn := nil;
    _ActionReturn := nil;
    _UpdateReconcile := nil;

  end;


  function LoadSPDll : Boolean;
  var
    sPath : AnsiString;
  begin
    if not LibraryLoaded then
    begin
(*      {$IFDEF COMTK}
      sPath := IncludeTrailingBackSlash(ExSyss.BatchPath) + DllName;
      {$ELSE} *)
      sPath := IncludeTrailingBackSlash(GetEnterpriseDirectory) + DllName;
      {..$ENDIF}
      LibHandle := LoadLibrary(PChar(sPath));

      if (LibHandle > HInstance_Error) then
      begin
        _InitDll := GetProcAddress(LibHandle, 'SP_INITDLL');
        _CloseDll := GetProcAddress(LibHandle, 'SP_CLOSEDLL');
        _Version := GetProcAddress(LibHandle, 'SP_VERSION');
        _CheckConversion := GetProcAddress(LibHandle, 'SP_CHECKCONVERSION');
        _ConvertTransaction := GetProcAddress(LibHandle, 'SP_CONVERTTRANSACTION');
        _CopyTransaction := GetProcAddress(LibHandle, 'SP_COPYTRANSACTION');
        _ReverseTransaction := GetProcAddress(LibHandle, 'SP_REVERSETRANSACTION');
        _BackToBackOrder := GetProcAddress(LibHandle, 'SP_BACKTOBACKORDER');
        _InitPath := GetProcAddress(LibHandle, 'SP_INITDLLPATH');
        _SetReleaseCode := GetProcAddress(LibHandle, 'SP_SETRELEASECODE');
        _CreateReturn := GetProcAddress(LibHandle, 'SP_CREATERETURN');
        _ActionReturn := GetProcAddress(LibHandle, 'SP_ACTIONRETURN');
        _UpdateReconcile := GetProcAddress(LibHandle, 'SP_UPDATERECONCILEFLAG');



        Result := Assigned(_InitDll) and
                  Assigned(_CloseDll) and
                  Assigned(_Version) and
                  Assigned(_CheckConversion) and
                  Assigned(_ConvertTransaction) and
                  Assigned(_CopyTransaction) and
                  Assigned(_ReverseTransaction) and
                  Assigned(_BackToBackOrder) and
                  Assigned(_InitPath) and
                  Assigned(_SetReleaseCode) and
                  Assigned(_CreateReturn) and
                  Assigned(_ActionReturn) and
                  Assigned(_UpdateReconcile);
      end
      else
        Result := False;
    end
    else
      Result := True;
  end;


  FUNCTION SP_INITDLL : SMALLINT;
  begin
    LibraryLoaded := LoadSPDll;

    if LibraryLoaded then
      Result := _InitDll
    else
      Result := -1;
  end;

  FUNCTION SP_CLOSEDLL : SMALLINT;
  begin
    if LibraryLoaded then
      Result := _CloseDll
    else
      Result := -1;
    SetAddressesToNil;
  end;

  FUNCTION SP_VERSION : SHORTSTRING;
  begin
    if LibraryLoaded then
      Result := _Version
    else
      Result := '';
  end;

  function SP_CHECKCONVERSION(P     : Pointer;
                              PSize : longint;
                              Consolidate : Boolean) : SmallInt;
  begin
    if LibraryLoaded then
      Result := _CheckConversion(P, PSize, Consolidate)
    else
      Result := -1;
  end;

  function SP_CONVERTTRANSACTION(P     : Pointer;
                                 PSize : longint;
                                 Consolidate : Boolean) : SmallInt;
  begin
    if LibraryLoaded then
      Result := _ConvertTransaction(P, PSize, Consolidate)
    else
      Result := -1;
  end;

  function SP_COPYTRANSACTION(RefNo : PChar) : SmallInt;
  begin
    if LibraryLoaded then
      Result := _CopyTransaction(RefNo)
    else
      Result := -1;
  end;

  function SP_REVERSETRANSACTION(RefNo : PChar) : SmallInt;
  begin
    if LibraryLoaded then
      Result := _ReverseTransaction(RefNo)
    else
      Result := -1;
  end;

  function SP_BACKTOBACKORDER(P : Pointer;
                              OutP : Pointer;
                              PSize : LongInt;
                              var OutPSize : LongInt;
                              RefNo : PChar) : SmallInt;
  begin
    if LibraryLoaded then
      Result := _BackToBackOrder(P, OutP, PSize, OutPSize, RefNo)
    else
      Result := -1;
  end;

  Function SP_INITDLLPATH(EXPATH    :  PCHAR;
                          MCSYSTEM  :  WORDBOOL) :  SMALLINT;
  begin
    LibraryLoaded := LoadSPDll;

    if LibraryLoaded then
      Result := _InitPath(ExPath, MCSystem)
    else
      Result := -1;
  end;

  function SP_SetReleaseCode(Code    :  PCHAR) : SmallInt;
  begin
    LibraryLoaded := LoadSPDll;
    Result := 0;
    if LibraryLoaded then
      _SetReleaseCode(Code)
    else
      Result := -1;
  end;

  function SP_CREATERETURN(P     : Pointer;
                          PSize : longint;
                          P2 : Pointer;
                          P2Size : longint) : SmallInt;
  begin
    LibraryLoaded := LoadSPDll;
    if LibraryLoaded then
      Result := _CreateReturn(P, PSize, P2, P2Size)
    else
      Result := -1;
  end;

  function SP_ACTIONRETURN(P     : Pointer;
                          PSize : longint;
                          P2 : Pointer;
                          P2Size : longint) : SmallInt;
  begin
    LibraryLoaded := LoadSPDll;
    if LibraryLoaded then
      Result := _ActionReturn(P, PSize, P2, P2Size)
    else
      Result := -1;
  end;


  function SetSPBackDoor : Integer;
  const
    CODE = #61 + #242 + #152 + #185 + #179 + #168 + #169 + #179 + #245 + #48 + #173;
  var
    pCode : array[0..255] of char;
  begin
    ChangeCryptoKey(720605);
    StrPCopy(pCode, Decode(CODE));
    Result := SP_SetReleaseCode(pCode);
  end;

  function SP_UPDATERECONCILEFLAG(RecordPos : longint;
                                  NewValue : SmallInt) : SmallInt;
  begin
    LibraryLoaded := LoadSPDll;
    if LibraryLoaded then
      Result := _UpdateReconcile(RecordPos, NewValue)
    else
      Result := -1;
  end;



{$ELSE}  //Static link to dll for use during development only


  FUNCTION SP_INITDLL : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                        EXTERNAL DLLNAME INDEX 1;

  FUNCTION SP_CLOSEDLL : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                         EXTERNAL DLLNAME INDEX 2;

  FUNCTION SP_VERSION : SHORTSTRING; {$IFDEF WIN32} STDCALL; {$ENDIF}
                        EXTERNAL DLLNAME INDEX 3;

  function SP_CHECKCONVERSION(P     : Pointer;
                              PSize : longint;
                              Consolidate : Boolean) : SmallInt;
                           {$IFDEF WIN32} STDCALL {$ENDIF};
                          EXTERNAL DLLNAME INDEX 4;

  function SP_CONVERTTRANSACTION(P     : Pointer;
                                 PSize : longint;
                                 Consolidate : Boolean) : SmallInt;
                           {$IFDEF WIN32} STDCALL {$ENDIF};
                        EXTERNAL DLLNAME INDEX 5;

  function SP_COPYTRANSACTION(RefNo : PChar) : SmallInt;
                           {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;
                        EXTERNAL DLLNAME INDEX 6;

  function SP_REVERSETRANSACTION(RefNo : PChar) : SmallInt;
                           {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;
                        EXTERNAL DLLNAME INDEX 7;

  function SP_BACKTOBACKORDER(P : Pointer;
                              OutP : Pointer;
                              PSize : LongInt;
                              var OutPSize : LongInt;
                              RefNo : PChar) : SmallInt;
                            STDCALL  EXPORT;
                        EXTERNAL DLLNAME INDEX 8;

  Function SP_INITDLLPATH(EXPATH    :  PCHAR;
                          MCSYSTEM  :  WORDBOOL) :  SMALLINT; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;
                        External DLLName Index 9;

  Function SP_SETRELEASECODE(Code    :  PCHAR) : SmallInt; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;
                        External DLLName Index 10;


  function SP_CREATERETURN(P     : Pointer;
                          PSize : longint;
                          P2 : Pointer;
                          P2Size : longint) : SmallInt;
                          STDCALL  EXPORT;
                         External DLLName Index 11;

  function SP_ACTIONRETURN(P     : Pointer;
                          PSize : longint;
                          P2 : Pointer;
                          P2Size : longint) : SmallInt;
                          STDCALL  EXPORT;
                         External DLLName Index 12;

  function SetSPBackDoor : Integer; STDCALL EXPORT;
                         External DLLName Index 13;
{$ENDIF}


Initialization

{$IFDEF DLoad}
  SetAddressesToNil;
{$ENDIF}

Finalization
{$IFDEF DLoad}
  if LibraryLoaded then
    FreeLibrary(LibHandle);
{$ENDIF}
end.
