Unit CompanySysAnalysis;

Interface

Uses Classes, SysUtils;

Type
  TExchequerVersion = (
                        verUnknown,
                        verPreV600,
                        ver600,
                        ver601,
                        ver62,
                        ver63,
                        //ver64,  -- No version changes were made to Company.Sys, probably due to no DB changes
                        ver65,
                        //ver66,  -- No version changes were made to Company.Sys, probably due to no DB changes
                        ver67,
                        //ver68,  -- No version changes were made to Company.Sys, probably due to no DB changes
                        ver69,
                        ver610,
                        ver70
                      );

// Examines the Company.Sys file in the specified Exchequer directory to determine the version
Function AnalyseCompanySys (Const ExchequerDir : ShortString) : TExchequerVersion;

// Returns a string description for the Exchequer Version
Function ExchequerVersionDesc (Const ExchequerVersion : TExchequerVersion) : ShortString;

Implementation

//=========================================================================

// Examines the Company.Sys file in the specified Exchequer directory to determine the version
//
// Company.Sys should exist in each Exchequer directory and company sub-directory from v6.00
// onwards, it was added to ease identification of a valid company directory as the SQL Edition
// would not have the .dat files we traditionally check3ed against
//
// In the initial release it contains the text "Exchequer Company Dataset"
// From v6.01 onwards it was modified to include the version, e.g. "Exchequer Company Dataset v6.01"
//
Function AnalyseCompanySys (Const ExchequerDir : ShortString) : TExchequerVersion;
Var
  FPath, S : ShortString;
Begin // AnalyseCompanySys
  Result := verPreV600;

  FPath := IncludeTrailingPathDelimiter(ExchequerDir) + 'Company.Sys';
  If FileExists(FPath) Then
  Begin
    With TStringList.Create Do
    Begin
      Try
        LoadFromFile (FPath);
        If (Count = 1) Then
        Begin
          S := UpperCase(Trim(Strings[0]));
          If (S = 'EXCHEQUER COMPANY DATASET') Then
            Result := ver600
          Else If (S = 'EXCHEQUER COMPANY DATASET V6.01') Then
            Result := ver601
          Else If (S = 'EXCHEQUER COMPANY DATASET V6.2') Then
            Result := ver62
          Else If (S = 'EXCHEQUER COMPANY DATASET V6.3') Then
            Result := ver63
          // Note: No DB changes were made for v6.4
          Else If (S = 'EXCHEQUER COMPANY DATASET V6.5') Then
            Result := ver65
          // Note: No DB changes were made for v6.6
          Else If (S = 'EXCHEQUER COMPANY DATASET V6.7') Then
            Result := ver67
          // Note: No DB changes were made for v6.8
          Else If (S = 'EXCHEQUER COMPANY DATASET V6.9') Then
            Result := ver69
          Else If (S = 'EXCHEQUER COMPANY DATASET V6.10') Then
            Result := ver610
          Else If (S = 'EXCHEQUER COMPANY DATASET V7.0') Then
            Result := ver70;
        End; // If (Count = 1)
      Finally
        Free;
      End; // Try..Finally
    End; // With TStringList.Create
  End; // If FileExists(FPath)
End; // AnalyseCompanySys

//-------------------------------------------------------------------------

// Returns a string description for the Exchequer Version
Function ExchequerVersionDesc (Const ExchequerVersion : TExchequerVersion) : ShortString;
Begin // ExchequerVersionDesc
  Case ExchequerVersion Of
    verUnknown : Result := 'Unknown';
    verPreV600 : Result := 'Pre v6.00';
    ver600     : Result := 'v6.00';
    ver601     : Result := 'v6.01';
    ver62      : Result := 'v6.2';
    ver63      : Result := 'v6.3/v6.4';
    ver65      : Result := 'v6.5/v6.6';
    ver67      : Result := 'v6.7/v6.8';
    ver69      : Result := 'v6.9';
    ver610     : Result := 'v6.10';
    ver70      : Result := 'v7.0';
  Else
    Raise Exception.Create ('ExchequerVersionDesc: Unhandled Version (' + IntToStr(Ord(ExchequerVersion)) + ')');
  End; // Case ExchequerVersion
End; // ExchequerVersionDesc

//=========================================================================



End.
