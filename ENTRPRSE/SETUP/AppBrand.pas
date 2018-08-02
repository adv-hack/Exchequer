unit AppBrand;

interface

Uses WiseAPI;

function GetApplicationBranding (var DLLParams: ParamRec): LongBool; StdCall;

implementation

Uses Brand, Dialogs, SysUtils;

//=========================================================================


function GetApplicationBranding (var DLLParams: ParamRec): LongBool;
Var
  W_MainDir : String;
Begin // GetApplicationBranding
  Result := False;

  // Get V_MainDir to determine where the Branding files will be
  GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
  ShowMessage (W_MainDir);

  InitBranding (IncludeTrailingPathDelimiter(W_MainDir));
  If (Branding.pbProduct = ptExchequer) Then
    SetVariable(DLLParams,'APP_BRAND', 'Exchequer')
  Else
    SetVariable(DLLParams,'APP_BRAND', 'IAO');
End; // GetApplicationBranding

//=========================================================================

end.
