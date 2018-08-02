unit DriveSetupU;

interface

uses SysUtils, GlobVar;

implementation

initialization

  SetDrive := ExtractFilePath(ParamStr(0));

finalization

end.
 