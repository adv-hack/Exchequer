//
// This module must be loaded before VarConst so that it can initialise SetDrive
// to a valid path, the Initialization section within VarConst will automatically
// open Company.Dat.
//
unit SetPath;

{$ALIGN 1}

interface

Uses Classes, Dialogs, Forms, IniFiles, SysUtils, Windows,
     Enterprise_TLB,   // Drill-Down COM Object Type Library
     GlobVar,          // Exchequer Global Const/Type/Var's
     BtrvU2;           // Btrieve Data Access Functions

implementation

//=========================================================================

Procedure CalcEntPath;
Var
  COMSvrPath : ShortString;
Begin { CalcEntPath }
  // Identify directory containing Drill-Down Server from Registry
  COMSvrPath := Application.ExeName;

  // Check its valid
  If (Trim(COMSvrPath) <> '') And FileExists(COMSvrPath) Then Begin
    // Remove DLL Name from path
    COMSvrPath := ExtractFilePath(COMSvrPath);
    SetDrive := COMSvrPath;

    // Check for Local Program files
    If FileExists (COMSvrPath + 'ENTWREPL.INI') Then
      With TIniFile.Create (ExtractFilePath (COMSvrPath) + 'ENTWREPL.INI') Do
        Try
          COMSvrPath := IncludeTrailingPathDelimiter(ReadString ('UpdateEngine', 'NetworkDir', ''));
          If (Trim(COMSvrPath) <> '') And FileExists (COMSvrPath + 'Company.Dat') Then
            SetDrive := COMSvrPath;
        Finally
          Free;
        End;

    // Check for Company.Dat
    If (Not FileExists (SetDrive + 'Company.Dat')) Then
      // Unable to resolve path
      Raise Exception.Create ('Unable to extract pathing information for Enterprise.DrillDown');
  End { If (Trim(SvrPath) <> '') }
  Else
    // Not Registered ???
    Raise Exception.Create ('Unable to extract pathing information for Enterprise.DrillDown');
End; { CalcEntPath }

//=========================================================================

Initialization
  CalcEntPath;
end.
