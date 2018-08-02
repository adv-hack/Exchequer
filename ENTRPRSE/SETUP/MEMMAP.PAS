unit MemMap;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, Messages, SysUtils, Windows,
     {$IFDEF SETD} { Setup.DLL }
       SetupU,
     {$ENDIF}
     LicGlob;

Type
  pGlobalDLLData = ^TGlobalDLLData;

  TGlobalDLLData = Record
    Defined      : Boolean;

    licSerialNo  : String[9];
    licCompany   : String[45];
    licTypeStr   : String[30];
    licVerStr    : String[60];

    licCountry     : Byte;         { 0=Any, 1=UK, 2=NZ, 3=Sing, 4=Aus, 5=EIRE, 6=RSA }
    licType        : Byte;         { 0-Install, 1-Upgrade, 2-Auto-Upgrade }
    licEntCVer     : Byte;         { 0-Prof, 2-Euro, 3-MC }
    licEntModVer   : Byte;         { 0-Basic, 1-Stock, 2-SPOP }
    licEntClSvr    : Byte;         { 0-Non C/S, 1=C/S, 2=Workgroup }
    licClServer    : Byte;         { 0-None, 1=NT, 2=Netware }
    licCSUserCnt   : SmallInt;     { Client-Server Engine User Count }
    licUserCnt     : SmallInt;     { User Count }
    licModules     : ModRelArrayType; { 0-No, 1-30-Day, 2-Full }

    licSpare       : Array [1..1024] Of Byte;
  End; { TGlobalDLLData }

  {$IFDEF SETD} { Setup.DLL }
    EWin32Error = class(Exception)
    public
      ErrorCode: DWORD;
    end;
  {$ENDIF}

{$IFDEF SETD} { Setup.DLL }
  Procedure MemMap_OpenSharedData;
  procedure MemMap_CloseSharedData;

  { Provides access to the global data }
  Procedure MemMap_GetData(Var AGlobalData: PGlobalDLLData; Const Init : Boolean); Export; StdCall;

  { Provides access to global data from WISE script }
  Function MemMap_GetFlag(var DLLParams: ParamRec): LongBool; StdCall; export;
{$ELSE}
  { Provides access to the global data }
  Procedure MemMap_GetData(Var AGlobalData: PGlobalDLLData; Const Init : Boolean); StdCall; External 'SETUP.DLL';
{$ENDIF}


implementation

{$IFDEF SETD} { Setup.DLL }
  Uses Crypto;
          
  const
    cMMFileName : PChar = 'DIV3MOD2';

  Var
    GlobalData : PGlobalDLLData;
    MapHandle  : THandle;


  Procedure MemMap_OpenSharedData;
  Var
    Size: Integer;

    { Copied from Delphi 4 }
    procedure RaiseLastWin32Error;
    Const
      SWin32Error = 'Win32 Error.  Code: %d.'#10'%s';
      SUnkWin32Error = 'A Win32 API function failed';
    var
      LastError : DWORD;
      Error     : EWin32Error;
    begin
      { Generate an error if not Delphi 2 - if D4 then use the real thing }
      {$IFNDEF VER90}
         { If this doesn't cause an error I don't know what will, I just }
         { hope the compiler doesn't GPF in disgust!!!!                  }
         Manchester United are the best!
      {$ENDIF}

      LastError := GetLastError;
      if LastError <> ERROR_SUCCESS then
        Error := EWin32Error.CreateFmt(SWin32Error, [LastError,
          SysErrorMessage(LastError)])
      else
        Error := EWin32Error.Create(SUnkWin32Error);
      Error.ErrorCode := LastError;
      raise Error;
    end;

  Begin { MemMap_OpenSharedData }
    { Get the size of the data to be mapped. }
    Size := SizeOf(TGlobalDLLData);

    { Now get a memory-mapped file object. Note the first parameter passes
      the value $FFFFFFFF or DWord(-1) so that space is allocated from the system's
      paging file. This requires that a name for the memory-mapped
      object get passed as the last parameter. }

    MapHandle := CreateFileMapping(DWord(-1), nil, PAGE_READWRITE, 0, Size, cMMFileName);

    If (MapHandle <> 0) Then Begin
      { Now map the data to the calling process's address space and get a
        pointer to the beginning of this address }
      GlobalData := MapViewOfFile(MapHandle, FILE_MAP_ALL_ACCESS, 0, 0, Size);

      If Not Assigned(GlobalData) Then Begin
        CloseHandle(MapHandle);
        RaiseLastWin32Error;
      End; { If Not Assigned(GlobalData) }
    End { If (MapHandle <> 0) }
    Else Begin
      { CreateFileMapping generated an error }
      RaiseLastWin32Error;
    End; { Else }
  End; { MemMap_OpenSharedData }


  { This procedure un-maps the memory-mapped file and releases the }
  { memory-mapped file handle                                      }
  Procedure MemMap_CloseSharedData;
  Begin { MemMap_CloseSharedData }
    UnmapViewOfFile(GlobalData);
    CloseHandle(MapHandle);
  End; { MemMap_CloseSharedData }


  { Provides access to the global data }
  Procedure MemMap_GetData(Var AGlobalData: PGlobalDLLData; Const Init : Boolean);
  Begin { MemMap_GetData }
    { Point AGlobalData to the same memory address referred to by GlobalData. }
    AGlobalData := GlobalData;

    If Init Then Begin
      FillChar (AGlobalData^, SizeOf(AGlobalData^), #0);
      With AGlobalData^ Do Begin
        Defined := False;


      End; { With }
    End; { If }
  End; { MemMap_GetData }


  Function MemMap_GetFlag(var DLLParams: ParamRec): LongBool;
  var
    Params                 : ANSIString;
    RetStr                 : String;
    ErrCode, OpLen         : Integer;
    OpCode                 : Byte;
    {DlgPN, HlpPath, CcyVer : String;}
  Begin { MemMap_GetFlag }
    { Check we have a memory pointer }
    If Assigned(GlobalData) Then Begin
      If GlobalData^.Defined Then Begin
        { Check security parameter }
        Params := DLLParams.szParam;  { A9B7C5 NN VAR }
        If (Copy (Params, 1, 7) = 'A9B7C5 ') And (Length(Params) > 10) Then Begin
          { Get required operation }
          Delete (Params, 1, 7);
          OpLen := Pos(' ', Params) - 1;
          If (OpLen > 0) Then Begin
            Val (Copy (Params, 1, OpLen), OpCode, ErrCode);
            If (OpCode In [0..99]) Then Begin
              { Get name of wise variable to store info in }
              Delete (Params, 1, Succ(OpLen));

              { Get Variable from Wise }
              GetVariable (DLLParams, Params, RetStr);

              { Set key for decription }
              ChangeCryptoKey (20456);

              With GlobalData^ Do Begin
                Case OpCode Of
                  { Licence Serial Number }
                  0  : RetStr := Decode(licSerialNo);

                  { Licence Company Name }
                  1  : RetStr := Decode(licCompany);

                  { Enterprise Version Description }
                  2  : RetStr := Decode(licVerStr);

                  { Licence Company Name }
                  3  : RetStr := Decode(licTypeStr);

                  { Licence Type: 0-Install, 1-Upgrade, 2-Auto-Upgrade }
                  4  : RetStr := IntToStr(licType);
                  5  : RetStr := licTypeToStr (licType);

                  { Country: 0=Any, 1=UK, 2=NZ, 3=Sing, 4=Aus, 5=EIRE, 6=RSA }
                  6  : RetStr := IntToStr(licCountry);
                  7  : RetStr := licCountryStr (licCountry, True);   { Short Description }
                  8  : RetStr := licCountryStr (licCountry, False);  { Long Description }

                  { Client-Server Engine Type - 0-None, 1=NT, 2=Netware }
                  20 : RetStr := IntToStr(licClServer);
                  21 : RetStr := licCSEngStr (licClServer, True);  { Short Description }
                  22 : RetStr := licCSEngStr (licClServer, False); { Long Description }
                  { Client-Server User Count }
                  23 : RetStr := IntToStr (licCSUserCnt);
                  { Engine Description }
                  24 : RetStr := 'Pervasive.SQL for ' + licCSEngStr (licClServer, False);

                  { Enterprise Currency Version: 0-Prof, 2-Euro, 3-MC }
                  40 : RetStr := IntToStr(licEntCVer);
                  { Base Modules: 0-Basic, 1-Stock, 2-SPOP }
                  41 : RetStr := IntToStr(licEntModVer);
                  { Client Server: 0-Non C/S, 1=C/S, 2=Workgroup }
                  42 : RetStr := IntToStr(licEntClSvr);
                  { User Count }
                  43 : RetStr := IntToStr(licUserCnt);

                  {  Module Release Codes: 0-No, 1-30-Day, 2-Full }
                  50..79
                     : RetStr := IntToStr(licModules[OpCode - 49]);

                  { Licence Information Set }
                  99 : If Defined Then RetStr := 'Y' Else RetStr := 'N';
                End; { Case }
              End; { With }

              SetVariable (DLLParams, Params, RetStr);
            End; { If (OpCode In [0..5]) }
          End; { If (OpLen > 0) }
        End; { If }
      End; { If GlobalData^.Defined }
    End; { If Assigned(GlobalData) }
    Result := False;
  End; { MemMap_GetFlag }

{$ENDIF}

{$IFDEF SETD} { Setup.DLL }
Initialization
    GlobalData := Nil;
{$ENDIF}
end.
