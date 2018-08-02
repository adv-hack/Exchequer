unit XMLFUNCS;

interface

Type
  xmlInitInfoType = Record
    xiDataPath    : String[255]; // Path to enterprise data
    xiCcyVer      : SmallInt;    // Currency Version: 0=Prof,1=Euro,2=Global

    xiSpare       : Array [1..500] Of Char;
  End; { xmlInitInfoType }

  xmlXMLInfoType = Record
    xtSaveDir     : String[255]; // Location to write XML document to
    xtXSLLocation : String[255]; // XSL URL to embed within XML document
    xtOurRef      : String[10];
    xtSpare       : Array [1..500] Of Char;
  End; // xmlXMLInfoType

  xmlHTMLInfoType = Record
    xtLoadDir     : String[255]; // Location of XML file to process
    xtSaveDir     : String[255]; // Location to write HTML document to
    xtXSLLocation : String[255]; // XSL location to read to convert XML to HTML
    xtSpare       : Array [1..500] Of Char;
  End; // xmlHTMInfoType

  {$IFDEF EDLL}

  (* for future use
  TInitFunc = Function (Var InitInfo : xmlInitInfoType) : SmallInt; StdCall;
  TCloseFunc = Function : SmallInt; StdCall;
  TCreateXMLFunc = Function (Var XMLInfo : xmlXMLInfoType) : SmallInt; StdCall;
  TCreateHTMLFunc = Function (Var HTMLInfo : xmlHTMLInfoType) : SmallInt; StdCall;

  TStr255 = String[255];

  TXMLInterface = Class(TObject)
  Private
    FDLLLoaded        : Boolean;

    FxmlInitDLL       : TInitFunc;
    FxmlCloseDLL      : TCloseFunc;
    FxmlCreateXMLFile : TCreateXMLFunc;
    FxmlCreateHTMFile : TCreateHTMLFunc;

    FDataPath         : TStr255;
    FCurrVer          : SmallInt;
  Protected

  Public
    Constructor Create; Override;
    Destructor Destroy;

    Property DataPath : TStr255 Read FDataPath Write FDataPath;
    Property CurrVer : SmallInt Read FCurrVer Write FCurrVer;
  End; { TXMLInterface }
  *)

  {$ENDIF}

{$IFNDEF EDLL}
Function xmlInitDLL (Var InitInfo : xmlInitInfoType) : SmallInt; StdCall;
Function xmlCloseDLL : SmallInt;  StdCall;
Function xmlCreateXMLFile (Var XMLInfo : xmlXMLInfoType) : SmallInt;  StdCall;
Function xmlCreateHTMFile (Var HTMLInfo : xmlHTMLInfoType) : SmallInt;  StdCall;
{$ENDIF}

implementation

{$IFDEF EDLL}
  (*
  Function xmlInitDLL (Var InitInfo : xmlInitInfoType) : SmallInt; StdCall; External 'ENTXML.DLL';
  Function xmlCloseDLL : SmallInt;  StdCall; External 'ENTXML.DLL';
  Function xmlCreateXMLFile (Var XMLInfo : xmlXMLInfoType) : SmallInt;  StdCall; External 'ENTXML.DLL';
  Function xmlCreateHTMFile (Var HTMLInfo : xmlHTMLInfoType) : SmallInt;  StdCall; External 'ENTXML.DLL';
  *)

  (** for future use
  Constructor TXMLInterface.Create;
  Begin { Create }
    Inherited Create;

    FxmlInitDLL       := Nil;
    FxmlCloseDLL      := Nil;
    FxmlCreateXMLFile := Nil;
    FxmlCreateHTMFile := Nil;

    FDLLLoaded := False;
  End; { Create}

  Destructor TXMLInterface.Destroy;
  Begin { Destroy }
    If FDLLLoaded Then Begin
      { Unload DLL }
      xmlCloseDLL;
      FDLLLoaded := False;
    End; { If }

    Inherited Destroy;
  End; { Destroy }

  Function TXMLInterface.LoadDLL : Boolean;
  Var
    InitInfo : xmlInitInfoType;
    Res      : SmallInt;
  Begin { LoadDLL }
    If Not FDLLLoaded Then Begin
      { Load DLL }
      FillChar (InitInfo, SizeOf(InitInfo), 0);
      With InitInfo Do Begin
        xiDataPath := FDataPath;
        xiCcyVer   := FCurrVer;
      End; { With InitInfo }

      Res := xmlInitDLL (InitInfo);

      FDLLLoaded := (Res = 0);
    End; { If Not FDLLLoaded }

    Result := FDLLLoaded;
  End; { LoadDLL }
  **)


{$ELSE}

  Uses Dialogs, SysUtils;


  // Load Toolkit DLL, init vars, etc...
  Function xmlInitDLL (Var InitInfo : xmlInitInfoType) : SmallInt;
  Begin { xmlInitDLL }
With InitInfo Do
  ShowMessage ('xmlInitDLL: ' + #13 +
               '  xiDataPath: ' + xiDataPath + #13 +
               '  xiCcyVer: ' + IntToStr(xiCcyVer));

    Result := 0;
  End; { xmlInitDLL }


  // Unload Toolkit DLL, etc...
  Function xmlCloseDLL : SmallInt;
  Begin { xmlCloseDLL }
ShowMessage ('xmlCloseDLL');
    Result := 0;
  End; { xmlCloseDLL }


  // Create an XML file for a specified transaction
  //
  // 0     OK
  // 1000  Unknown Exception
  Function xmlCreateXMLFile (Var XMLInfo : xmlXMLInfoType) : SmallInt;
  Var
    OutF     : TextFile;
    RepFName : ShortString;
    FVar     : LongInt;
  Begin { xmlCreateXMLFile }
With XMLInfo Do
  ShowMessage ('xmlCreateXMLFile: ' + #13 +
               '  xtSaveDir: ' + xtSaveDir + #13 +
               '  xtXSLLocation: ' + xtXSLLocation + #13 +
               '  xtOurRef: ' + xtOurRef);

    Result := 0;

    Try
      With XMLInfo Do Begin
        If (xtSaveDir[Length(xtSaveDir)] <> '\') Then xtSaveDir := xtSaveDir + '\';

        FVar := 1;
        Repeat
          RepFName := xtSaveDir + IntToStr(FVar) + '.XML';
          Inc (FVar);
        Until (Not FileExists (RepFName)) Or (FVar > 999999);

        xtSaveDir := RepFName;

        AssignFile (OutF, RepFName);
        Rewrite (OutF);
        Writeln (OutF, 'Enterprise XML File (NOT!)');
        Writeln (OutF, '==========================');
        Writeln (OutF, 'xtSaveDir:     ' + xtSaveDir);
        Writeln (OutF, 'xtXSLLocation: ' + xtXSLLocation);
        Writeln (OutF, 'OurRef:        ' + xtOurRef);
        Closefile (OutF);
      End; { With XMLInfo }
    Except
      On Ex:Exception Do
        Result := 1000;
    End;
  End; { xmlCreateXMLFile }


  Function xmlCreateHTMFile (Var HTMLInfo : xmlHTMLInfoType) : SmallInt;
  Var
    OutF     : TextFile;
    RepFName : ShortString;
    FVar     : LongInt;
  Begin { xmlCreateHTMFile }
With HTMLInfo Do
  ShowMessage ('xmlCreateHMLFile: ' + #13 +
               '  xtLoadDir: ' + xtLoadDir + #13 +
               '  xtSaveDir: ' + xtSaveDir + #13 +
               '  xtXSLLocation: ' + xtXSLLocation);

    Result := 0;

    Try
      With HTMLInfo Do Begin
        If (xtSaveDir[Length(xtSaveDir)] <> '\') Then xtSaveDir := xtSaveDir + '\';

        FVar := 1;
        Repeat
          RepFName := xtSaveDir + IntToStr(FVar) + '.HTM';
          Inc (FVar);
        Until (Not FileExists (RepFName)) Or (FVar > 999999);

        AssignFile (OutF, RepFName);
        Rewrite (OutF);
        Writeln (OutF, 'Enterprise HTML File (NOT!)');
        Writeln (OutF, '===========================');
        Writeln (OutF, 'xtLoadDir:     ' + xtLoadDir);
        Writeln (OutF, 'xtSaveDir:     ' + xtSaveDir);
        Writeln (OutF, 'xtXSLLocation: ' + xtXSLLocation);
        Closefile (OutF);

        xtSaveDir := RepFName;
      End; { With XMLInfo }
    Except
      On Ex:Exception Do
        Result := 1000;
    End;
  End; { xmlCreateHTMFile }

{$ENDIF}

end.
