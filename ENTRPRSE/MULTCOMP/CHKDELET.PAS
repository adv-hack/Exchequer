unit ChkDelet;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_DEPRECATED OFF}

interface

Uses Classes, Dialogs, FileCtrl,
  {$IFDEF EXSQL}
  SQLUtils,
  {$ENDIF}
  SysUtils;

Function CheckDirPath (DirPath : ANSIString) : ANSIString;
Function CheckForDelete (OrigDir, DirPath, IndStr : ANSIString; Const SubDir : Boolean) : Boolean;

implementation


Function CheckDirPath (DirPath : ANSIString) : ANSIString;
Begin { CheckDirPath }
  DirPath := Trim(DirPath);

  If (DirPath <> '') Then Begin
    If (DirPath[Length(DirPath)] <> '\') Then
      DirPath := DirPath + '\';
  End; { If }

  Result := DirPath;
End; { CheckDirPath }


// Checks the directory and all its subdirectories for anything that means
// it shouldn't be deleted.
//
// 1) Look for Company.Dat - Any Company.Dat means that it is the main company
//    directory (and .EXE directory) or the main Company Directory is a sub-
//    directory of the directory being checked.
//
// 2) Look for an EXCHQSS.DAT in any subdirectory - this will indicate that
//    another company is installed in a subdirectory
//
// 3) Look for any .EXE file - this will find any Enterprise or Exchequer
//    directories as well as any other programs.
//
Function CheckForDelete (OrigDir, DirPath, IndStr : ANSIString; Const SubDir : Boolean) : Boolean;
Const
  ResolveStr = 'You will need to resolve this issue before the company can be safely deleted.';
Var
  FileInfo  : TSearchRec;
  FStatus   : SmallInt;
  TypeStr   : ShortString;
  ThisDir, ThisFile : ANSIString;
  CanDelete : Boolean;
Begin { CheckForDelete }
  Result := False;

  Try
    CanDelete := True;

    { Make sure its got a '\' on the end }
    DirPath := CheckDirPath (DirPath);

    { Check current directory for Company.Dat }
    ThisDir := CheckDirPath(DirPath);
    ThisFile := ThisDir + 'COMPANY.DAT';
{$IFDEF EXSQL}
    if SQLUtils.ValidSystem(ThisDir) then begin
{$ELSE}
    If FileExists(ThisFile) Then Begin
{$ENDIF}
      CanDelete := False;
      If SubDir Then Begin
        { The Main Company is in a subdirectory off the directory being deleted }
        MessageDlg ('The company in ''' + OrigDir + ''' cannot be deleted because the ' + #13 +
                    'Main Company was detected in the following subdirectory:' + #13#13 +
                    '''' + ThisDir + '''' + #13#13 +
                    ResolveStr, MtWarning, [mbOk], 0);
      End { If }
      Else Begin
        { It is the main company }
        MessageDlg ('The company in ''' + OrigDir + ''' cannot be deleted because it is the Main Company' + #13 +
                    'or contains a Companies Database', MtWarning, [mbOk], 0);
      End; { Else }
    End; { If }

{ IFNDEF EXSQL}
    // MH 21/09/07: Restored this section for EXSQL and modified it to call ValidSystem/ValidCompany
    If CanDelete And SubDir Then Begin
      { Check for ExchQss.Dat }
      //ThisFile := ThisDir + 'EXCHQSS.DAT';
      //If FileExists(ThisFile) Then Begin
      If ValidCompany(ThisDir) Then
      Begin
        CanDelete := False;
        MessageDlg ('The company in ''' + OrigDir + ''' cannot be deleted because another Company ' + #13 +
                    'was detected in one of its subdirectories:' + #13#13 +
                    '''' + ThisDir + '''' + #13#13 +
                    ResolveStr, MtWarning, [mbOk], 0);
      End; { If }
    End; { If }
{ ENDIF}

    If CanDelete Then Begin
      { Check for .EXE file }
      ThisFile := ThisDir + '*.EXE';
      If FileExists(ThisFile) Then Begin
        CanDelete := False;
        MessageDlg ('The company in ''' + OrigDir + ''' cannot be deleted because program files ' + #13 +
                    'were detected in one of its subdirectories:' + #13#13 +
                    '''' + ThisDir + '''' + #13#13 +
                    ResolveStr, MtWarning, [mbOk], 0);
      End; { If }
    End; { If }

    If CanDelete Then Begin
      { Check any subdirectories by calling this function recursively }
      FStatus := FindFirst(DirPath + '*.*', faDirectory or faHidden or faReadOnly, FileInfo);
      While (FStatus = 0) And CanDelete Do Begin
        If (FileInfo.Name <> '.') And (FileInfo.Name <> '..') Then Begin
          If ((FileInfo.Attr And faDirectory) = faDirectory) Then Begin
            { Check subdirectory }
            CanDelete := CheckForDelete (OrigDir, DirPath + FileInfo.Name + '\', '  ' + IndStr, True);
          End; { If }
        End; { If }

        FStatus := FindNext(FileInfo);
      End; { While }

      FindClose (FileInfo);
    End; { If CanDelete }

    { Checking finished AOK - return result of checing }
    Result := CanDelete;
  Except
    { An error - return false }
    Result := False;
  End;
End; { CheckForDelete }



end.
