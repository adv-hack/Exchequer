unit NorthObj;

interface

uses
  ExpObj, CustAbsU, NIBObj, Aib01;


Type
  TNorthernObj = Class(TNIBExportObject)
  protected
    function GetIniFileName : string; override;
  end;


implementation

{ TNorthernObj }
uses
  SysUtils, Math, IniFiles;


{ TNorthernObj }

function TNorthernObj.GetIniFileName: string;
begin
  EFTIniFile := DefaultNorthernBankIniFile;
end;

end.
