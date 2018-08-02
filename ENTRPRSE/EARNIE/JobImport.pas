unit JobImport;

{ nfrewer440 16:25 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Procedure ExportClockIn;

implementation

Procedure ExportClockIn;
var
  ExportEarnie : TExport;
  ErrorLog     : TExport;
  
begin
  try
    ExportEarnie := TExport.create;
    ErrorLog.
  finally

  end;
end;

end.
