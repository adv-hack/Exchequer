unit dll_conv;

interface

  function EX_INITCONVERSION : SmallInt; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

  function EX_ENDCONVERSION : SmallInt; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

  function EX_CHECKCONVERSION(P     : Pointer;
                            PSize : longint;
                            Consolidate : Boolean) : SmallInt;
                           {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

  function EX_CONVERTTRANSACTION(P     : Pointer;
                               PSize : longint;
                               Consolidate : Boolean) : SmallInt;
                           {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

  function EX_COPYTRANSACTION(RefNo : PChar) : SmallInt;
                           {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

  function EX_REVERSETRANSACTION(RefNo : PChar) : SmallInt;
                           {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

  function EX_BACKTOBACKORDER(P : Pointer;
                              OutP : Pointer;
                              PSize : LongInt;
                              var OutPSize : LongInt;
                              RefNo : PChar) : SmallInt;
                              STDCALL  EXPORT;



implementation

uses
  SpDlIntf;

  function EX_CHECKCONVERSION(P     : Pointer;
                            PSize : longint;
                            Consolidate : Boolean) : SmallInt;
  begin
    Result := SP_INITDLL;
    Try
      if Result = 0 then
       Result := SP_CHECKCONVERSION(P, PSize, Consolidate);
    Finally
      SP_CLOSEDLL;
    End;
  end;


  function EX_CONVERTTRANSACTION(P     : Pointer;
                               PSize : longint;
                               Consolidate : Boolean) : SmallInt;
  begin
    Result := SP_INITDLL;
    Try
      if Result = 0 then
        Result := SP_CONVERTTRANSACTION(P, PSize, Consolidate);
    Finally
      SP_CLOSEDLL;
    End;
  end;

  function EX_COPYTRANSACTION(RefNo : PChar) : SmallInt;
  begin
    Result := SP_INITDLL;
    Try
      if Result = 0 then
        Result := SP_COPYTRANSACTION(RefNo);
    Finally
      SP_CLOSEDLL;
    End;
  end;

  function EX_REVERSETRANSACTION(RefNo : PChar) : SmallInt;
  begin
    Result := SP_INITDLL;
    Try
      if Result = 0 then
        Result := SP_REVERSETRANSACTION(RefNo);
    Finally
      SP_CLOSEDLL;
    End;
  end;

  function EX_INITCONVERSION : SmallInt;
  begin
    Result := SP_INITDLL;
  end;

  function EX_ENDCONVERSION : SmallInt;
  begin
    Result := SP_CLOSEDLL;
  end;

  function EX_BACKTOBACKORDER(P : Pointer;
                              OutP : Pointer;
                              PSize : LongInt;
                              var OutPSize : LongInt;
                              RefNo : PChar) : SmallInt;
  begin
    Result := SP_INITDLL;
    Try
      if Result = 0 then
        Result := SP_BACKTOBACKORDER(P, OutP, PSize, OutPSize, RefNo);
    Finally
      SP_CLOSEDLL;
    End;
  end;



end.
