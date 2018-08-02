// Performs initialization stuff for the customisation
unit CustInit;

interface

Uses Classes, Dialogs, Forms, Sysutils, Windows;

Var
  // Indicates whether Customisation has been disabled by the command-line parameter
  CustomisationEnabled    : Boolean;

  // Indicates whether COM Customisation has been disabled by the command-line parameter
  COMCustomisationEnabled : Boolean;

  // Indicates whether any normal customisation clients have been setup
  CustomClients           : Boolean;

implementation

{$IFDEF CU}
  { Checks the Command Line Parameters for Customisation related switches }
  Procedure CheckParams;
  Var
    sParam : ShortString;
    I : Word;
  Begin
    If (ParamCount > 0) Then
      For I := 1 To ParamCount Do Begin
        sParam := UpperCase(Trim(ParamStr(I)));

        { Check for the Disable Customisation flag }
        If (sParam = '/NOCUSTOM') Then Begin
          { Disable ALL Customisation }
          CustomisationEnabled := False;
          COMCustomisationEnabled := False;
          CustomClients := False;
        End; { /NOCUSTOM }

        {$IFDEF COMCU}
          { Check for the Disable COM Customisation flag }
          If (sParam = '/NOCOMCUSTOM') Then Begin
            COMCustomisationEnabled := False;
          End; { /NOCOMCUSTOM }
        {$ENDIF}
      End; { If }
  End;
{$ENDIF}

Initialization
  {$IFDEF CU}
    // Default to On
    CustomisationEnabled := True;

    {$IFDEF COMCU}
      COMCustomisationEnabled := True;
    {$ELSE}
      COMCustomisationEnabled := False;
    {$ENDIF}

    // Check Command-Line params for alternate instructions
    CheckParams;
  {$ELSE}
    CustomisationEnabled    := False;
    COMCustomisationEnabled := False;
  {$ENDIF}

  CustomClients    := False;

(*
ShowMessage ('CustomisationEnabled: '  + IntToStr(Ord(CustomisationEnabled)) + #13 +
             'COMCustomisationEnabled: '  + IntToStr(Ord(COMCustomisationEnabled)) + #13 +
             'CustomClients: '  + IntToStr(Ord(CustomClients)));
*)
end.
