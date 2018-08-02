unit XmlInt;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, XMLFuncs;

Type
  TInitFunc = Function (Var InitInfo : xmlInitInfoType) : SmallInt; StdCall;
  TCloseFunc = Function : SmallInt; StdCall;
  TCreateXMLFunc = Function (Var XMLInfo : xmlXMLInfoType) : SmallInt; StdCall;
  TCreateHTMLFunc = Function (var InitInfo : xmlInitInfoType;Var HTMLInfo : xmlHTMLInfoType) : SmallInt; StdCall;
  TCreateXMLExportFunc = Function (Var XMLExportInfo : xmlXMLExportInfoType) : smallint; stdcall;

  TStr255 = String[255];

  TXMLInterface = Class(TObject)
  Private
    FDLLLoaded        : Boolean;
    FDLLVersion       : integer;

    FDLLHandle        : THandle;
    FxmlInitDLL       : TInitFunc;                    // Version 1
    FxmlCloseDLL      : TCloseFunc;                   // Version 1
    FxmlCreateXMLFile : TCreateXMLFunc;               // Version 1
    FxmlCreateHTMFile : TCreateHTMLFunc;              // Version 1
    FXmlCreateXMLExportFile : TCreateXMLExportFunc;   // Version 2

    fOurRefList       : TStringList;
    FDataPath         : TStr255;
    FCurrVer          : SmallInt;
    FHTMPath          : TStr255;
    FXMLPath          : TStr255;
    FXSLPath          : TStr255;

    // HM 29/09/00: Moved to property of class
    InitInfo : xmlInitInfoType;
  Protected
    Procedure InitHandles;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Function CreateHTMFile : SmallInt;
    Function CreateXMLFile (Const DocRef : ShortString) : SmallInt;
    Function CreateXMLExportFile (Const OurRefList : TStringList) : SmallInt;
    Function LoadXMLDLL : SmallInt;

    Property DataPath : TStr255 Read FDataPath Write FDataPath;
    Property CurrVer : SmallInt Read FCurrVer Write FCurrVer;
    Property HTMPath : TStr255 Read FHTMPath Write FHTMPath;
    Property XMLPath : TStr255 Read FXMLPath Write FXMLPath;
    Property XSLPath : TStr255 Read FXSLPath Write FXSLPath;
  End;

  EXMLExportExcept = class(Exception)
    private
      fErrorCode : integer;
    public
      property ErrorCode : integer read fErrorCode;
      constructor Create(Code: integer; const Msg : string);
    end;

implementation

{----------------------------------------------------------------------}

constructor EXMLExportExcept.Create(Code: integer; const Msg : string);
begin
  inherited CreateFmt('An error occured exporting XML transactions' + #13#10 +
                       '%s' + #13#10 + 'Status : %d', [Msg, Code]);
  fErrorCode := Code;
end;

{======================================================================}

Constructor TXMLInterface.Create;
Begin { Create }
  Inherited Create;

  InitHandles;

  FDLLLoaded := False;
  FDLLVersion := 1;
  FDataPath := '';
  FCurrVer  := 1;  { Multi-Currency/Global }
  FHTMPath  := '';
  FXMLPath  := '';
  FXSLPath  := '';
  FOurRefList := nil;
End; { Create}

{----------------------------------------------------------------------}

Destructor TXMLInterface.Destroy;
Begin { Destroy }
  If FDLLLoaded Then Begin
    { call shutdown function }
    FxmlCloseDLL;

    { Unload DLL }
    FreeLibrary(FDllHandle);
    InitHandles;
    FDLLLoaded := False;
  End; { If }

  Inherited Destroy;
End; { Destroy }

{----------------------------------------------------------------------}

Procedure TXMLInterface.InitHandles;
Begin { InitHandles }
  FDLLHandle        := 0;

  FxmlInitDLL       := Nil;
  FxmlCloseDLL      := Nil;
  FxmlCreateXMLFile := Nil;
  FxmlCreateHTMFile := Nil;
  FxmlCreateXMLExportFile := Nil;
End; { InitHandles }

{----------------------------------------------------------------------}

Function TXMLInterface.LoadXMLDLL : SmallInt;
Const
  ResNames : Array[0..5] of PChar = ('ENTXML',
                                     'xmlInitDLL',
                                     'xmlCloseDLL',
                                     'xmlCreateXMLFile',
                                     'xmlCreateHTMFile',
                                     'xmlCreateExport');
Var
  ErrStr   : ShortString;
Begin { LoadXMLDLL }
  Result := 0;

  Try
    If Not FDLLLoaded Then Begin
      InitHandles;

      { Load ENTXML.DLL dynamically }
      FDLLHandle := LoadLibrary(ResNames[0]);

      Try
        If (FDLLHandle > HInstance_Error) Then Begin
          FxmlInitDLL := GetProcAddress(FDLLHandle, ResNames[1]);

          If Assigned(FxmlInitDLL) Then Begin
            FxmlCloseDLL := GetProcAddress(FDLLHandle, ResNames[2]);
          End; { If }

          If Assigned(FxmlCloseDLL) Then Begin
            FxmlCreateXMLFile := GetProcAddress(FDLLHandle, ResNames[3]);
          End; { If }

          If Assigned(FxmlCreateXMLFile) Then Begin
            FxmlCreateHTMFile := GetProcAddress(FDLLHandle, ResNames[4]);
          End; { If }

          If Assigned(FxmlCreateHTMFile) then Begin
            FxmlCreateXMLExportFile := GetProcAddress(FDLLHandle, ResNames[5]);
            if Assigned(FxmlCreateXMLExportFile) then
              FDLLVersion := 2;
          End;
        End; { If (FDLLHandle > HInstance_Error) }
      Except
        FreeLibrary(FDLLHandle);
      End;

      FDLLLoaded := Assigned(FxmlInitDLL) And Assigned(FxmlCloseDLL) And
                    Assigned(FxmlCreateXMLFile) And Assigned(FxmlCreateHTMFile);

      If FDLLLoaded Then Begin
        { Init DLL }
        FillChar (InitInfo, SizeOf(InitInfo), #0);
        With InitInfo Do Begin
          xiDataPath  := FDataPath;
          xiCcyVer    := FCurrVer;
        End; { With InitInfo }

        Result := FxmlInitDLL(InitInfo);
      End { If }
      Else Begin
        { Reset all handles to Nil }
        Result := 1001;
        InitHandles;
      End; { Else }
    End; { If Not FDLLLoaded }
  Except
    On EX:Exception Do Begin
      ErrStr := Ex.Message;
      Result := 1000;
    End;
  End;

  If (Result <> 0) Then Begin
    Case Result Of
      12    : ErrStr := 'Invalid Exchequer Path';
      13    : ErrStr := 'Not Multi Currency Version';
      15    : ErrStr := 'Attempted to import multi currency data into single currency system';
      16    : ErrStr := 'Attempted to import single-currency data into multi currency system';
      18    : ErrStr := 'Unable to open / find ExchDLL.INI';
      20    : ErrStr := 'Unable to locate Btrieve Library / Invalid Exchequer Path';

      1000  : ; { Message detailed above }
      1001  : ErrStr := 'Cannot load XML Library';

      32762 : ErrStr := 'The Toolkit instance is already in use';
      32767 : ErrStr := 'Invalid DLL Release Code';
    Else
      ErrStr := 'Unknown Error';
    End; { Case }

    MessageDlg ('An error occured loading the XML library' + #13#13 +
                'Error ' + IntToStr(Result) + ': ' + ErrStr, mtError, [mbOk], 0);
  End; { If }
End; { LoadXMLDLL }

{----------------------------------------------------------------------}

Function TXMLInterface.CreateXMLFile (Const DocRef : ShortString) : SmallInt;
Var
  XMLInfo : xmlXMLInfoType;
  ErrStr  : ShortString;
Begin { CreateXMLFile }
  Try
    If FDLLLoaded Then Begin
      With XMLInfo Do Begin
        // MH 16/07/07: Remove the filename returned from any previous runs
        xtSaveDir     := ExtractFilePath(FXMLPath);
        xtXSLLocation := FXSLPath;
        xtOurRef      := DocRef;
      End; { With XMLInfo }

      Result := FxmlCreateXMLFile(XMLInfo);

      FXMLPath := XMLInfo.xtSaveDir;
    End { If }
    Else
      { DLL Not Loaded }
      Result := 1001;
  Except
    On EX:Exception Do Begin
      ErrStr := Ex.Message;
      Result := 1000;
    End;
  End;

  If (Result <> 0) Then Begin
    Case Result Of
      1     : ErrStr := 'Invalid Output directory';
      2     : ErrStr := 'Invalid Transaction Type';
      3     : ErrStr := 'Generic Error/Exception';

      1000  : ; { Message detailed above }
      1001  : ErrStr := 'XML Library has not been loaded';
    Else
      ErrStr := 'Unknown Error';
    End; { Case }

    MessageDlg ('An error occured creating the XML File' + #13#13 +
                'Error ' + IntToStr(Result) + ': ' + ErrStr, mtError, [mbOk], 0);
  End; { If (Result <> 0) }
End; { CreateXMLFile }

{----------------------------------------------------------------------}

Function TXMLInterface.CreateHTMFile : SmallInt;
Var
  HTMInfo : xmlHTMLInfoType;
  ErrStr  : ShortString;
Begin { CreateHTMFile }
  Try
    If FDLLLoaded Then Begin
      With HTMInfo Do Begin
        xtLoadDir     := XMLPath; // Location of XML file to process
        xtSaveDir     := HTMPath; // Location to write HTML document to
        xtXSLLocation := XSLPath;
      End; { With XMLInfo }

      Result := FxmlCreateHTMFile(InitInfo, HTMInfo);

      FHTMPath := HTMInfo.xtSaveDir;
    End { If }
    Else
      { DLL Not Loaded }
      Result := 1001;
  Except
    On EX:Exception Do Begin
      ErrStr := Ex.Message;
      Result := 1000;
    End;
  End;

  If (Result <> 0) Then Begin
    Case Result Of
      1     : ErrStr := 'Invalid Output directory';
      2     : ErrStr := 'Invalid Transaction Type';
      3     : ErrStr := 'Generic Error/Exception';

      1000  : ; { Message detailed above }
      1001  : ErrStr := 'XML Library has not been loaded';
    Else
      ErrStr := 'Unknown Error';
    End; { Case }

    MessageDlg ('An error occured creating the HTML File' + #13#13 +
                'Error ' + IntToStr(Result) + ': ' + ErrStr, mtError, [mbOk], 0);
  End; { If (Result <> 0) }
End; { CreateHTMFile }

{----------------------------------------------------------------------}

function TXMLInterface.CreateXMLExportFile(const OurRefList: TStringList): SmallInt;
var
  ExportInfo : xmlXMLExportInfoType;
{  ErrorCode : integer;}
{  ErrorString : string;}
begin
  if not FDLLLoaded or (FDLLVersion < 2) then
  begin
    Result := 1001;
    raise EXMLExportExcept.Create(1001, 'XML Library has not been loaded');
  end;

  try
    ExportInfo.xeSaveFileName := XMLPath;
    ExportInfo.xeOurRefList := OurRefList;
    Result := FXmlCreateXMLExportFile(ExportInfo);
  except
    on E:Exception do
    begin
      Result := 1000;
      raise EXMLExportExcept.Create(1000, E.Message);
    end;
  end;

  if Result <> 0 then
  begin
    case Result of
      3 : raise EXMLExportExcept.Create(Result, 'DLL Toolkit error');
      4 : raise EXMLExportExcept.Create(Result, 'Output file invalid');
      5 : raise EXMLExportExcept.Create(Result, 'No transactions to export');
    else
      raise EXMLExportExcept.Create(Result, 'Unknown error');
    end;
  end;
end; // xmlXMLExportInfoType


end.
