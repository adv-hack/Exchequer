unit VerInfo;

interface

Function ANCVer : ANSIString;

implementation

Uses ExchequerRelease;

Function ANCVer : ANSIString;
Begin
  Result := ExchequerModuleVersion (emGenericPlugIn, '213');
End;

end.
