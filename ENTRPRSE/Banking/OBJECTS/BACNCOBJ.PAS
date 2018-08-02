unit BacNcObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Bacs00, CustAbsU;

type
  TBacsNcExportObject = Class(TBacs1Obj)
     function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
  end;


implementation

uses
  ExpObj;

function TBacsNcExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                      Mode : word) : Boolean;
begin
  if Mode = wrPayLine then
   Result := Inherited WriteRec(EventData, Mode)
  else
   Result := True;
end;


end.
