program HHUtil;

uses
  SysUtils,
  Windows;

{$R *.res}
{$Warn Symbol_Platform Off}

// NOTE: HTML Help functionality redeclared to minimise size of .EXE

Const
  HH_HELP_CONTEXT = $000F; {display topic for context number}

Var
  HelpPath : AnsiString;
  HelpContext : LongInt;
  hHelp : THandle;
  iPos : SmallInt;
  sCmdLine, sCopy : ShortString;

function HtmlHelp(hwndCaller: THandle; pszFile: PChar;
    uCommand: cardinal; dwData: longint): THandle; stdcall;
    external 'hhctrl.ocx' name 'HtmlHelpA'; {external API call}

begin
  HelpPath := '';
  HelpContext := -1;

  // Extract details from parameters:-
  //
  //   HHUtil /HelpContext:11 /HelpPath:T:\Long Path\Some Directory\Setup.Chm
  //
  // Note: /HelpPath: must be the last parameter as everything after it will
  // be taken as the help file path in order to support long filenames
  //
  sCmdLine := CmdLine;

  iPos := Pos ('/HelpContext:', sCmdLine);
  If (iPos > 0) Then
  Begin
    sCopy := Copy(sCmdLine, iPos+13, Length(sCmdLine));
    HelpContext := StrToIntDef(Copy(sCopy, 1, Pos(' ', sCopy)-1), -1);
  End; // If (iPos > 0)

  iPos := Pos ('/HelpPath:', sCmdLine);
  If (iPos > 0) Then
    HelpPath := Copy (sCmdLine, iPos+10, Length(sCmdLine));

  If FileExists(HelpPath) And (HelpContext <> -1) Then
  Begin
    // Execute the help file
    hHelp := HtmlHelp(0, PCHAR(HelpPath), HH_HELP_CONTEXT, HelpContext);

    // Wait for the HTML Help window to close as it will be unloaded automatically when
    // this app closes - so we can't close this app until the user has finished with the
    // help
    While IsWindow(hHelp) Do
      Sleep (1000);
  End; // If FileExists(HelpPath)
end.
