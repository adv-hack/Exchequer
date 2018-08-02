unit Dllconfg;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, SetupU;

Function ToolkitConfig (var DLLParams: ParamRec): LongBool; {$IFDEF WIN32} StdCall; {$ENDIF} export;

implementation

Uses GlobVar, VarCnst3, ETMiscU, ETStrU, SetDir16, ConfDlg2, ConfDlg3, ConfDlg4;

Var
  SetUpF : Text;  { Defined in DLL GlobVar.Pas }


{ Include Standard Toolkit DLL funcs for accessing INI file }
{$I DLLINI.INC}


{ Displays the Toolkit DLL Configuration Wizard }
Function ToolkitConfig (var DLLParams: ParamRec) : LongBool;
Const
  DoneCode = 'D';
Var
  ConfigDlg1          : TDirectoryDialog;
  ConfigDlg2          : TConfigDlg2;
  ConfigDlg3          : TConfigDlg3;
  ConfigDlg4          : TConfigDlg4;
  ConfigDir, InstType : String;
  CurrDlg             : Byte;
  ExCode              : Char;
Begin
  Result := False;

  GetVariable(DLLParams, 'INST', ConfigDir);
  If Not (Copy (ConfigDir, Length(ConfigDir), 1)[1] In [':', '\']) Then
    ConfigDir := ConfigDir + '\';
  Application.HelpFile := ConfigDir + 'ENTDLL31.HLP';

  { Get installation Type from WISE }
  GetVariable(DLLParams, 'INSTTYPE', InstType);

  { Check Installation Type }
  If (InstType[1] In ['Y', 'Z', 'z']) Then Begin
    { Get installation directory from WISE }
    GetVariable(DLLParams, 'MAINDIR', ConfigDir);
    If Not (Copy (ConfigDir, Length(ConfigDir), 1)[1] In [':', '\']) Then
      ConfigDir := ConfigDir + '\';

    { Check For Configuration file }
    If FileExists(ConfigDir + 'EXCHDLL.INI') Then Begin
      { For updates check that the .OLD config file is there }
      If (InstType[1] = 'z') Then Begin
        If FileExists(ConfigDir + 'EXCHDLL.INI') Then
          Process_File(ConfigDir + 'EXCHDLL.OLD')
        Else
          Process_File(ConfigDir + 'EXCHDLL.INI');
      End { If }
      Else
        Process_File(ConfigDir + 'EXCHDLL.INI');

      { Display Wizard }
      Try
        Result := True;  { Error }
        CurrDlg := 1;
        ConfigDlg1 := Nil;
        ConfigDlg2 := Nil;
        ConfigDlg3 := Nil;
        ConfigDlg4 := Nil;

        Repeat
          ExCode := ' ';

          Case CurrDlg Of
            1 : Begin { Exchequer/Enterprise Path }
                  If Not Assigned(ConfigDlg1) Then Begin
                    ConfigDlg1 := TDirectoryDialog.Create(Application);

                    With ExSyss, ConfigDlg1 Do Begin
                      HelpContextId := 10004;
                      InstallPath := ExPath;
                      Instructions := 'Please specify the directory containing your ' +
                                      'Exchequer or Exchequer Enterprise data files:';
                      Title := 'Exchequer/Enterprise Path';
                      ValidMode := 'y';

                      { Disable << Back as its 1st dialog in Wizard }
                      BackBtn.Visible := False;
                    End; { With }
                  End; { If }

                  ConfigDlg1.ShowModal;

                  ExCode := ConfigDlg1.ExitCode;

                  If (ExCode = 'N') Then Begin
                    ExSyss.ExPath := Trim(ConfigDlg1.InstallPath);

                    If Not (ExSyss.ExPath[Length(ExSyss.ExPath)] In [':', '\']) Then
                      ExSyss.ExPath := ExSyss.ExPath + '\';
                  End; { If }
                End;
            2 : Begin { Miscellaneous Flags }
                  If Not Assigned(ConfigDlg2) Then Begin
                    ConfigDlg2 := TConfigDlg2.Create(Application);

                    ConfigDlg2.DispRec
                  End; { If }

                  ConfigDlg2.ShowModal;

                  ExCode := ConfigDlg2.ExitCode;
                End;
            3 : Begin
                  If Not Assigned(ConfigDlg3) Then Begin
                    ConfigDlg3 := TConfigDlg3.Create(Application);

                    ConfigDlg3.Install := (InstType = 'Z');
                    ConfigDlg3.DispRec
                  End; { If }

                  ConfigDlg3.ShowModal;

                  ExCode := ConfigDlg3.ExitCode;
                End;
            4 : Begin
                  If Not Assigned(ConfigDlg4) Then Begin
                    ConfigDlg4 := TConfigDlg4.Create(Application);

                    ConfigDlg4.DispRec
                  End; { If }

                  ConfigDlg4.ShowModal;

                  ExCode := ConfigDlg4.ExitCode;

                  If (ExCode = 'N') Then Begin
                    { Exit loop }
                    ExCode := DoneCode;
                  End; { If }
                End;
          Else
            CurrDlg := 1;
          End; { Case }

          Case ExCode Of
            'B' : Dec (CurrDlg);
            'N' : Inc (CurrDlg);
          End; { Case }
        Until (ExCode In [DoneCode, 'X']);

        If (ExCode = DoneCode) Then Begin
          { Save Configuration Details }
          Result := (Store_SetUp(ConfigDir + 'EXCHDLL.INI') <> 0);
        End; { If }
      Finally
        { Free the forms }
        If Assigned(ConfigDlg1) Then ConfigDlg1.Free;
        If Assigned(ConfigDlg2) Then ConfigDlg2.Free;
        If Assigned(ConfigDlg3) Then ConfigDlg3.Free;
        If Assigned(ConfigDlg4) Then ConfigDlg4.Free;
      End;
    End { If }
    Else Begin
      { Invalid Directory }
      MessageDlg ('The Toolkit Configuration file is not in the specified directory.', mtError, [mbOk], 0);
      Result := True;
    End; { Else }
  End { If }
  Else Begin
    { Invalid Installation Type - Shouldn't ever happen - but I'm paranoid - THEY said so }
    MessageDlg ('"' + InstType[1] + '" is an invalid Installation Type', mtError, [mbOk], 0);
    Result := True;
  End; { Else }
End;



end.
