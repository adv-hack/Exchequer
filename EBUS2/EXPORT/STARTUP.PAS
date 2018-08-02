unit startup;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

implementation
uses
  eBusBtrv, SysUtils;

procedure ReadParams;
begin
  if UpperCase(ParamStr(1)) = '/CREATE' then TEBusBtrieve.CreateFile('',TRUE);
end;

initialization
  ReadParams;

end.
