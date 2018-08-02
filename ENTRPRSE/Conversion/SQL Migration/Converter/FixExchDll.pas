unit FixExchDll;

interface

Uses Classes, Dialogs, SysUtils;

Procedure FixupExchDllPath;

implementation

Uses oConvertOptions;

//=========================================================================

Procedure FixupExchDllPath;
Var
  StrList : TStringList;
  sFName, sExchPath : ShortString;
  iCompany, iPathIdx : LongInt;
  bFound : Boolean;

  //------------------------------

  Function GetPath (Var ExchDllPath : ShortString; Var PathIdx : LongInt) : Boolean;
  Const
    sExchPath = 'EXCHEQUER_PATH';
  Var
    TheStr : ShortString;
    I, iPos : LongInt;
  Begin // GetPath
    Result := False;
    ExchDllPath := '';
    PathIdx := -1;

    For I := 0 To Pred(StrList.Count) Do
    Begin
      TheStr := UpperCase(Trim(StrList[I]));

      iPos := Pos(sExchPath, TheStr);
      If (iPos > 0) Then
      Begin
        // Exchequer Path - check to see if already set
        ExchDllPath := Trim(Copy(TheStr, iPos + Length(sExchPath), 255));
        PathIdx := I;
        Result := True;
        Break;
      End; // If (Pos('EXCHEQUER_PATH', TheStr) > 0)
    End; { For I }
  End; // GetPath

  //------------------------------

  Procedure UpdatePath (Const NewPath : ShortString; Const PathIdx : LongInt);
  Begin // UpdatePath
    StrList[PathIdx] := 'Exchequer_Path              ' + NewPath;
    StrList.SaveToFile(sFName);
  End; // UpdatePath

  //------------------------------

Begin // FixupExchDllPath
  sFName := ConversionOptions.coSQLDirectory + 'ExchDll.Ini';
  If FileExists(sFName) Then
  Begin
    // Remove any potential hidden/read-only attributes }
    FileSetAttr (sFName, 0);

    { Use stringlist to process file }
    StrList := TStringList.Create;
    Try
      { Read file into stringlist }
      StrList.LoadFromFile(sFName);

      If GetPath(sExchPath, iPathIdx) Then
      Begin
        // Skip if path not set
        If (sExchPath <> '') Then
        Begin
          If DirectoryExists(sExchPath) Then
          Begin
            // Try to match up to one of the old company paths - convert to short filename first
            bFound := False;
            sExchPath := ExtractShortPathName(sExchPath);
            For iCompany := 0 To (ConversionOptions.coCompanyCount - 1) Do
            Begin
              If (Trim(ConversionOptions.coCompanies[iCompany].ccCompanyPath) = sExchPath) Then
              Begin
                UpdatePath(Trim(ConversionOptions.coCompanies[iCompany].ccSQLCompanyPath), iPathIdx);
                bFound := True;
                Break;
              End; // If (Trim(ConversionOptions.coCompanies[iCompany].ccCompanyPath) = sExchPath)
            End; // For iCompany

            If (Not bFound) Then
            Begin
              ConversionOptions.coWarnings[cowExchDll] := True;
              MessageDlg ('ExchDll.Ini contains an invalid Exchequer Path, please correct this ' +
                          'manually once the conversion has completed', mtWarning, [mbOK], 0);
            End; // If (Not bFound)
          End // If DirectoryExists(sExchPath)
          Else
          Begin
            ConversionOptions.coWarnings[cowExchDll] := True;
            MessageDlg ('ExchDll.Ini contains an invalid Exchequer Path, please correct this ' +
                        'manually once the conversion has completed', mtWarning, [mbOK], 0);
          End; // Else
        End; // If (sExchPath <> '')
      End // If GetPath(sExchPath)
      Else
      Begin
        ConversionOptions.coWarnings[cowExchDll] := True;
        MessageDlg ('The Exchequer_Path setting in ExchDll.Ini could not be found, please check ' +
                    'this manually once the conversion has completed', mtWarning, [mbOK], 0);
      End; // Else
    Finally
      StrList.Free;
    End;
  End // If FileExists(sFName)
  Else
    MessageDlg ('ExchDll.Ini appears to be missing, please copy this in after the conversion has ' +
                'complete and manually correct the path', mtWarning, [mbOK], 0);
End; // FixupExchDllPath


//=========================================================================

end.
