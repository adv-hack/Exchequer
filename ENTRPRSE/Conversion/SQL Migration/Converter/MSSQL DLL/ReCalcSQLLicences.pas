unit ReCalcSQLLicences;

interface

Uses Classes, Dialogs, SysUtils;

// Recalculates the Exchequer User Count, Module Licences and Module User Counts based on the
// Entrprse.Dat in the Exchequer SQL Edition directory.
Function ReApplySQLLicenses (Const ExchSQLPath : ShortString) : Boolean; StdCall; Export;

implementation

Uses GlobVar, VarConst, BtrvU2, LicRec, EntLic, ModRels, SQLUtils, BTSupU1, SysU3, ReplSysF;

//=========================================================================

// Recalculates the Exchequer User Count, Module Licences and Module User Counts based on the
// Entrprse.Dat in the Exchequer SQL Edition directory.
Function ReApplySQLLicenses (Const ExchSQLPath : ShortString) : Boolean;
Var
  LicR : EntLicenceRecType;
  W_ErrDir : ShortString;
  lStatus : LongInt;
  Locked : Boolean;

  //------------------------------

  // Check to see if Btrieve file exists and attempt to open it. Returns True
  // if opened OK, status code is stored in globally to main proc in LStatus
  Function OpenDataFile (Const FileNo : Integer; Const FilePath : ShortString) : Boolean;
  Var
    lStatus : LongInt;
  Begin // OpenDataFile
{$IFDEF EXSQL}
    If SQLUtils.TableExists(FilePath + FileNames[FileNo]) then
{$ELSE}
    If FileExists (FilePath + FileNames[FileNo]) Then
{$ENDIF}
    Begin

      { Open specified file }
      lStatus := Open_File(F[FileNo], FilePath + FileNames[FileNo], 0);
      Result := (LStatus = 0);
    End { If FileExists (FilePath) }
    Else
    Begin
      Result := False;
      MessageDlg ('ConvertToSQL_MSSQL.ReApplySQLLicenses - table ' + FileNames[FileNo] + ' not found', mtError, [mbOK], 0);
    End; // Else
  End; // OpenDataFile

  //------------------------------

  Function OpenEntFiles : Boolean;
  Begin // OpenEntFiles
                   Result := OpenDataFile (SysF, ExchSQLPath);  // Open ExchQss.Dat
    If Result Then Result := OpenDataFile (PwrdF, ExchSQLPath);  // Open ExchqChk.Dat
    If Result Then Result := OpenDataFile (CompF, ExchSQLPath);  // Open Company.Dat
  End; // OpenEntFiles

  //------------------------------

  // Closes ExchQss.Dat
  Procedure CloseEntFiles;
  Begin // CloseEntFiles
    Close_File(F[CompF]);
    Close_File(F[SysF]);
    Close_File(F[PwrdF]);
  End; // CloseEntFiles

  //------------------------------

Begin // ReApplySQLLicenses
  // Read Exchequer Licence
  If ReadEntLic (ExchSQLPath + EntLicFName, LicR) Then
  Begin
    // Open files / read data required by SetUserCount and UpdateModRels
    Result := OpenEntFiles;

    If Result Then
    Begin
      // SysR - main system setup flags
      Locked := False;
      Result := GetMultiSys(False, Locked, SysR);
      If (Not Result) Then MessageDlg ('ConvertToSQL_MSSQL.ReApplySQLLicenses - Error reading System Setup Flags from ExchqSS table in SQL Edition', mtError, [mbOK], 0);

      // ModRR - Module Release Codes
      Locked := False;
      Result := GetMultiSys(False, Locked, ModRR);
      If (Not Result) Then MessageDlg ('ConvertToSQL_MSSQL.ReApplySQLLicenses - Error reading Module Release Codes from ExchqSS table in SQL Edition', mtError, [mbOK], 0);

      If Result Then
      Begin
        // Exchequer User Count
        SetUserCount (LicR.licUserCnt);

        // Module Release Codes
        UpdateModRels (LicR);

        // Module User Counts - done using SQLHelpr

        // Apply changes
        PutMultiSys(SysR, False);
        PutMultiSys(ModRR, False);

        // Replicate changes to duplicate security store
        TrackSecUpdates(BOff);
      End; // If Result

      CloseEntFiles;

      If Result Then
      Begin
        // Replicate changes to sub-companies - Don't reset Country, or ESN. Don't change the paperless settings or check file sizes.
        W_ErrDir := '';
        lStatus := REPLICATEENTLICENCE2 (ExchSQLPath, W_ErrDir, False, False, False, False);
        If (lStatus <> 0) Then
        Begin
          Result := False;
          MessageDlg ('ConvertToSQL_MSSQL.ReApplySQLLicenses - An error ' + IntToStr(lStatus) + ' occurred whilst copying the Exchequer Licence to ' + W_ErrDir, mtError, [mbOK], 0);
        End; // If (lStatus <> 0)
      End; // If Result
    End; // If Result
  End // If ReadEntLic (ExchSQLPath + EntLicFName, LicR)
  Else
  Begin
    Result := False;
    MessageDlg ('ConvertToSQL_MSSQL.ReApplySQLLicenses - Unable to read Exchequer Licence from SQL Edition directory', mtError, [mbOK], 0);
  End; // Else
End; // ReApplySQLLicenses

//=========================================================================

end.
