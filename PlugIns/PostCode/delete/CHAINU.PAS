unit ChainU;

{ DLL Chain Unit - Allows a series of DLLs to be chained together to  }
{                  allow standard customisation DLL's to be developed }
{                  independently.                                     }

interface

Uses Classes, Dialogs, Forms, IniFiles, SysUtils, Windows, CustAbsU,
     Menus, EntMenuU, TCustAbs;

Type
  Str8 = String[8];

  TDLLChain = Class(TObject)
  Private
    FModuleName : Str8;
    FNextDLL    : Str8;

    DLLLoaded          : Boolean;
    _MyGSRHandle       : THandle;

    { Customisation Hook functions }
    _InitCustomHandler : Procedure (Var CustomOn       : Boolean;
                                        CustomHandlers : TAbsCustomHandlers);
    _TermCustomHandler : Procedure;
    _ExecCustomHandler : Procedure (Const EventData : TAbsEnterpriseSystem);

    { Menu Customisation functions }
    _CustomMenus       : Procedure (EntInfo : ptrEntCustomInfo);
    _CloseCustomMenus  : Procedure;

    { Label Customisation functions }
    _EntDoCustomText   : Function (Const WindowId : LongInt) : Boolean;
    _EntGetCustomText  : Procedure (CustomText : TAbsCustomText);

    Procedure LoadNextLink;
  Public
    Property ModuleName : Str8 Read FModuleName Write FModuleName;

    Constructor Create;
    Destructor  Destroy; Override;

    Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                    CustomHandlers : TAbsCustomHandlers);
    Procedure TermCustomHandler;
    Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
    Procedure CustomMenus(EntInfo : ptrEntCustomInfo);
    Procedure CloseCustomMenus;

    Function EntDoCustomText (Const WindowId : LongInt) : Boolean;
    Procedure EntGetCustomText (CustomText : TAbsCustomText);
  End;

Var
  DLLChain : TDLLChain;

implementation


Constructor TDLLChain.Create;
Var
  Buffer : array[0..255] of Char;
  Len    : SmallInt;
  IniF   : TIniFile;
Begin
  Inherited Create;

  DLLLoaded := False;

  { Extract dll name }
  Len := GetModuleFileName(HInstance, Buffer, SizeOf(Buffer));
  If (Len > 0) Then Begin
    FModuleName := ExtractFileName(Buffer);

    { Trim Extension off end }
    If (Pos ('.', FModuleName) > 0) Then
      Delete(FModuleName, Pos ('.', FModuleName), Length(FModuleName));
  End { If }
  Else
    FModuleName := '';

  FNextDLL := '';
  If (Trim(FModuleName) <> '') Then Begin
    { Get next chain link }
    IniF := TIniFile.Create (ExtractFilePath(Application.ExeName) + 'ENTCUSTM.INI');
    FNextDLL := IniF.ReadString('HookChain', Trim(FModuleName), '');
    IniF.Free;
  End; { If }

  If (Trim(FNextDLL) <> '') Then
    { Load Next Link }
    LoadNextLink;
End;


Destructor TDLLChain.Destroy;
Begin
  If DLLLoaded Then Begin
    { unload library }
    FreeLibrary(_MyGSRHandle);
    _MyGSRHandle:=0;

    { Reset function handles }
    _InitCustomHandler := Nil;
    _TermCustomHandler := Nil;
    _ExecCustomHandler := Nil;
    _CustomMenus       := Nil;
    _CloseCustomMenus  := Nil;
    _EntDoCustomText   := Nil;
    _EntGetCustomText  := Nil;

    DLLLoaded := False;
  End; { If }
End;


Procedure TDLLChain.LoadNextLink;
Const
  ResNames : Array[1..7] of PChar = ('InitCustomHandler',
                                     'TermCustomHandler',
                                     'ExecCustomHandler',
                                     'CustomMenus',
                                     'CloseCustomMenus',
                                     'EntDoCustomText',
                                     'EntGetCustomText');
Var
  DLLAddr : TFarProc;
  OK      : Boolean;
  FName   : Array [0..255] Of Char;
  I       : Byte;
Begin
  // HM 23/10/01: Added missing 'Begin'. NOTE: Code still worked correctly
  //              without the 'Begin' due to shear co-incidence / luck!
  If (Not DLLLoaded) Then Begin
    OK := True;

    { Check DLL is in current directory }
    If FileExists (ExtractFilePath(Application.ExeName) + FNextDLL + '.DLL') Then Begin
      { IMPORTANT NOTE: ANY CHANGES IN THIS SECTION SHOULD ALSO BE APPLIED TO }
      {                 THE CUSTOMISATION SETUP DLL IN THE SETUP DIRECTORY    }
      _InitCustomHandler := Nil;
      _TermCustomHandler := Nil;
      _ExecCustomHandler := Nil;
      _CustomMenus       := Nil;
      _CloseCustomMenus  := Nil;
      _EntDoCustomText   := Nil;
      _EntGetCustomText  := Nil;

      StrPCopy (FName, FNextDLL);
      _MyGSRHandle:=LoadLibrary(FName);

      try
        If (_MyGSRHandle > HInstance_Error) Then Begin
          { Get handles for procedures }
          For I := 1 To High(ResNames) Do Begin
            DLLAddr := GetProcAddress(_MyGSRHandle, ResNames[I]);
            If Assigned(DLLAddr) Then
              Case I Of
                1 : _InitCustomHandler := DLLAddr;
                2 : _TermCustomHandler := DLLAddr;
                3 : _ExecCustomHandler := DLLAddr;
                4 : _CustomMenus       := DLLAddr;
                5 : _CloseCustomMenus  := DLLAddr;
                6 : _EntDoCustomText   := DLLAddr;
                7 : _EntGetCustomText  := DLLAddr;
              End { Case }
            Else Begin
              OK := False;
              Break;
            End; { Else }
          End; { For }

          If Not OK Then Begin
            { Somethings effed up - unload dll and set everything to Nil }
            FreeLibrary(_MyGSRHandle);
            _MyGSRHandle:=0;
            _InitCustomHandler := Nil;
            _TermCustomHandler := Nil;
            _ExecCustomHandler := Nil;
            _CustomMenus       := Nil;
            _CloseCustomMenus  := Nil;
            _EntDoCustomText   := Nil;
            _EntGetCustomText  := Nil;
          End { If }
          Else
            DLLLoaded := True;
        End { If }
        Else
          _MyGSRHandle:=0;
      Except
        FreeLibrary(_MyGSRHandle);
        _MyGSRHandle:=0;

        _InitCustomHandler := Nil;
        _TermCustomHandler := Nil;
        _ExecCustomHandler := Nil;
        _CustomMenus       := Nil;
        _CloseCustomMenus  := Nil;
        _EntDoCustomText   := Nil;
        _EntGetCustomText  := Nil;
      End; { Try }
    End; { If }
  End; { If (Not DLLLoaded) }
End;


Procedure TDLLChain.InitCustomHandler(Var CustomOn       : Boolean;
                                          CustomHandlers : TAbsCustomHandlers);
Begin
  If DLLLoaded And Assigned (_InitCustomHandler) Then
    _InitCustomHandler(CustomOn, CustomHandlers);
End;


Procedure TDLLChain.TermCustomHandler;
Begin
  If DLLLoaded And Assigned (_TermCustomHandler) Then
    _TermCustomHandler;
End;


Procedure TDLLChain.ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
Begin
  If DLLLoaded And Assigned (_ExecCustomHandler) Then
    _ExecCustomHandler(EventData);
End;


Procedure TDLLChain.CustomMenus(EntInfo : ptrEntCustomInfo);
Begin
  If DLLLoaded And Assigned (_CustomMenus) Then
    _CustomMenus(EntInfo);
End;


Procedure TDLLChain.CloseCustomMenus;
Begin
  If DLLLoaded And Assigned (_CloseCustomMenus) Then
    _CloseCustomMenus;
End;


Function TDLLChain.EntDoCustomText (Const WindowId : LongInt) : Boolean;
Begin
  If DLLLoaded And Assigned (_EntDoCustomText) Then
    Result := _EntDoCustomText(WindowId)
  Else
    { Either an error loading the DLL or no more customisation }
    Result := False;
End;


Procedure TDLLChain.EntGetCustomText (CustomText : TAbsCustomText);
Begin
  If DLLLoaded And Assigned (_EntGetCustomText) Then
    _EntGetCustomText(CustomText);
End;


Initialization
  DLLChain := TDLLChain.Create;
Finalization
  DLLChain.Free;
end.
