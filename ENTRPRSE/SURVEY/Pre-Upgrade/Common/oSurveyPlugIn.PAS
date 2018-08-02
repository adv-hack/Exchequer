unit oSurveyPlugIn;

interface

Uses SysUtils;

Type
  TSitePlugInInfo = Class(TObject)
  Private
    FPlugInDesc : ShortString;
    FPlugInPath : ShortString;

    Function GetFileName : ShortString;
  Public
    Constructor Create (Const PlugInPath, PlugInDesc : ShortString);

    Property piFilename : ShortString Read GetFileName;
    Property piDescription : ShortString Read FPlugInDesc;
    Property piPath : ShortString Read FPlugInPath;
  End; // TSitePlugInInfo

implementation

//-------------------------------------------------------------------------

Constructor TSitePlugInInfo.Create (Const PlugInPath, PlugInDesc : ShortString);
Begin // Create
  Inherited Create;

  FPlugInDesc := PlugInDesc;
  FPlugInPath := PlugInPath;
End; // Create

//-------------------------------------------------------------------------

Function TSitePlugInInfo.GetFileName : ShortString;
Begin // GetFileName
  Result := ExtractFileName(FPlugInPath);
End; // GetFileName

//------------------------------

end.
