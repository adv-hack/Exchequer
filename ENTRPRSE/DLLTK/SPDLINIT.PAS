unit spdlinit;

interface

  FUNCTION SP_INITDLL : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  Function SP_INITDLLPATH(EXPATH    :  PCHAR;
                          MCSYSTEM  :  WORDBOOL) :  SMALLINT; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

  FUNCTION SP_CLOSEDLL : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION SP_VERSION : SHORTSTRING; {$IFDEF WIN32} STDCALL; {$ENDIF}

  PROCEDURE SP_SETRELEASECODE(CODE : PCHAR); {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;


implementation

Uses
  InitDllu;

const
  SOP_Dll_Version = 'SPDLL90.026';

  FUNCTION SP_INITDLL : SMALLINT;
  begin
    Result := Ex_InitDll;
  end;

  FUNCTION SP_CLOSEDLL : SMALLINT;
  begin
   Result := Ex_CloseData;
  end;

  FUNCTION SP_VERSION : SHORTSTRING;
  begin
    Result := SOP_Dll_Version;
  end;

  Function SP_INITDLLPATH(EXPATH    :  PCHAR;
                          MCSYSTEM  :  WORDBOOL) :  SMALLINT;
  begin
    Result := Ex_InitDllPath(ExPath, SmallInt(MCSystem));
  end;

  PROCEDURE SP_SETRELEASECODE(CODE : PCHAR);
  begin
    Ex_SetReleaseCode(Code);
  end;

Initialization

end.
