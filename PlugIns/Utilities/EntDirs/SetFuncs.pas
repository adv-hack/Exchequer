unit SetFuncs;

interface

Uses
  {Classes, IniFiles, Registry,} SysUtils{, Windows};

// Returns the current Enterprise directory as configured on
// the workstation.
Function GetEnterpriseDir (Const EnterpriseDir : PChar) : SmallInt; StdCall; Export;

implementation
uses
  Dialogs, {StrUtil, FileUtil,} VAOUtil;

//---------------------------------------------------------------------------

// Returns the current Enterprise directory as configured on
// the workstation.
//
// Return Values:-
//
//   0        OK
//   1001     Unknown Exception, see EnterpriseDir for details
//   1002     Unable to Find Enterprise Directory
//   1003     EnterpriseDir PChar too short
Function GetEnterpriseDir (Const EnterpriseDir : PChar) : SmallInt;
//Var
//  sNetworkPath, TmpStr : String;
//  EntWReplINI : TInifile;
Begin { GetEnterpriseDir }
  // HM 17/08/04: Modified for VAO Support
  Result := 0;
  try
    StrPCopy (EnterpriseDir, VAOInfo.vaoCompanyDir);
  except
    On E : Exception Do MessageDlg('EntSetup.DLL has raised an exception in GetEnterpriseDir'#13#13 + E.Message
    + #13#13'Please check that Exchequer is correctly registered on your system.', mtError, [mbOK], 0);
  end;{try}
End; { GetEnterpriseDir }

end.
