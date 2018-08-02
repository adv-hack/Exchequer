unit DLLIntf;

interface

Uses Classes, Dialogs, SysUtils, Windows, LicRec;

// Checks the specified directory for a valid Exchequer v6.00 Pervasive
// Edition installation.
//
// Return Values:-
//
//   0     AOK
//   1     Not a valid Directory
//   2     Not a valid v6.00 Pervasive Edition
//   3     The Data is in use
//   255   Unknown Exception
//
Function CheckExchequer600PervasiveDir (Const ExchDir : ShortString) : Byte;

// Loads the Conversion Options object with a list of the companies defined in
// the Exchequer Pervasive Edition
Procedure LoadPervasiveCompanyList;

// Reads and returns the specified Exchequer licence file (entrprse.dat)
Function ReadExchequerLicence (Const LicenceFile : ShortString; Var LicenceRec : EntLicenceRecType) : Boolean;

// Updates the specified licence file with the specified ESN
Function ResetESN (Const LicenceFile : ShortString; Const NewESN : ESNByteArrayType) : Boolean;

// Updates the Company Path's imported from Pervasive to the new SQL database
Function FixupMCMPaths : Boolean;

// Redo all the release codes in the SQL Edition installation based on the licence
Function ReApplySQLLicensing (Const ExchequerSQLDir : ShortString) : Boolean;

implementation

Uses oConvertOptions, ProgressF;

Function CheckExch600PervasiveDir (Const ExchDir : ShortString) : Byte; StdCall; External 'ConvertToSQL_PSQL.Dll';

Function LoadCompaniesList (Const ExchDir : ShortString; Const ConversionOptions : IConversionOptions) : LongInt; StdCall; External 'ConvertToSQL_PSQL.Dll';

Function ReadExchLicence (Const SecParam : ShortString; Const LicenceFile : ShortString; Var LicenceRec : EntLicenceRecType) : Boolean; StdCall; External 'ConvertToSQL_PSQL.Dll';

// Updates the specified licence file with the specified ESN
Function ResetExchLicenceESN (Const SecParam : ShortString; Const LicenceFile : ShortString; Const NewESN : ESNByteArrayType) : Boolean; StdCall; External 'ConvertToSQL_PSQL.Dll';


//=========================================================================

// Checks the specified directory for a valid Exchequer v6.00 Pervasive
// Edition installation.
//
// Return Values:-
//
//   0     AOK
//   1     Not a valid Directory
//   2     Not a valid v6.00 Pervasive Edition
//   3     The Data is in use
//   255   Unknown Exception
//
Function CheckExchequer600PervasiveDir (Const ExchDir : ShortString) : Byte;
Begin // CheckExchequer600PervasiveDir
  Try
    Result := CheckExch600PervasiveDir(ExchDir);
  Except
    On E:Exception Do
      Result := 255;
  End; // Try..Except
End; // CheckExchequer600PervasiveDir

//-------------------------------------------------------------------------

// Loads the Conversion Options object with a list of the companies defined in
// the Exchequer Pervasive Edition
Procedure LoadPervasiveCompanyList;
Var
  Res : LongInt;
Begin // LoadPervasiveCompanyList
  Res := LoadCompaniesList (ConversionOptions.coPervasiveDirectory, ConversionOptions);
End; // LoadPervasiveCompanyList

//-------------------------------------------------------------------------

// Reads and returns the specified Exchequer licence file (entrprse.dat)
Function ReadExchequerLicence (Const LicenceFile : ShortString; Var LicenceRec : EntLicenceRecType) : Boolean;
Begin // ReadExchequerLicence
  Result := ReadExchLicence ('S*6Wq21', LicenceFile, LicenceRec);
End; // ReadExchequerLicence

//-------------------------------------------------------------------------

// Updates the specified licence file with the specified ESN
Function ResetESN (Const LicenceFile : ShortString; Const NewESN : ESNByteArrayType) : Boolean;
Begin // ResetESN
  Result := ResetExchLicenceESN ('USG6_WF$', LicenceFile, NewESN);
End; // ResetESN

//-------------------------------------------------------------------------

// Updates the Company Path's imported from Pervasive to the new SQL database
Function FixupMCMPaths : Boolean;
Type
  TResetMCMPathsFunc = Function (Const ConversionOptions : IConversionOptions) : Boolean; StdCall;
Var
  hConv600MSSQL  : THandle;
  hResetMCMPaths : TResetMCMPathsFunc;
Begin // FixupMCMPaths
  Result := False;
  ProgressDialog.StartStage ('Correcting Company Paths');
  Try
    hConv600MSSQL := LoadLibrary('ConvertToSQL_MSSQL.DLL');
    If (hConv600MSSQL > HInstance_Error) Then
    Begin
      Try
        hResetMCMPaths := GetProcAddress(hConv600MSSQL, 'ResetMCMPaths');
        If Assigned(hResetMCMPaths) Then
        Begin
          Result := hResetMCMPaths (ConversionOptions);
        End // If Assigned(hResetMCMPaths)
        Else
          Raise Exception.Create ('FixupMCMPaths - Unable to get handle to ConvertToSQL_MSSQL.ResetMCMPaths');
      Finally
        FreeLibrary (hConv600MSSQL);
      End; // Try..Finally
    End // If (hConv600MSSQL > HInstance_Error)
    Else
      Raise Exception.Create ('FixupMCMPaths - Unable to load ConvertToSQL_MSSQL.Dll');
  Finally
    ProgressDialog.FinishStage;
  End; // Try..Finally
End; // FixupMCMPaths

//-------------------------------------------------------------------------

// Redo all the release codes in the SQL Edition installation based on the licence
Function ReApplySQLLicensing (Const ExchequerSQLDir : ShortString) : Boolean;
Type
  TReApplySQLLicenses = Function (Const ExchSQLPath : ShortString) : Boolean; StdCall;
Var
  hConv600MSSQL  : THandle;
  hReApplySQLLicenses : TReApplySQLLicenses;
Begin // ReApplySQLLicensing
  Result := False;
  hConv600MSSQL := LoadLibrary('ConvertToSQL_MSSQL.DLL');
  If (hConv600MSSQL > HInstance_Error) Then
  Begin
    Try
      hReApplySQLLicenses := GetProcAddress(hConv600MSSQL, 'ReApplySQLLicenses');
      If Assigned(hReApplySQLLicenses) Then
      Begin
        Result := hReApplySQLLicenses (ExchequerSQLDir);
      End // If Assigned(hReApplySQLLicenses)
      Else
        Raise Exception.Create ('FixupMCMPaths - Unable to get handle to ConvertToSQL_MSSQL.ReApplySQLLicenses');
    Finally
      FreeLibrary (hConv600MSSQL);
    End; // Try..Finally
  End // If (hConv600MSSQL > HInstance_Error)
  Else
    Raise Exception.Create ('FixupMCMPaths - Unable to load ConvertToSQL_MSSQL.Dll');
End; // ReApplySQLLicensing

//-------------------------------------------------------------------------

end.
