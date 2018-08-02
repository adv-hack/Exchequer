unit SMSProc;

interface
uses
  sysutils;
  
  function ConvertPhoneNo(sCountryCode, sAreaCode, sNumber : string): string;

implementation

function ConvertPhoneNo(sCountryCode, sAreaCode, sNumber : string): string;
begin
  if (Trim(sCountryCode) <> '') and (length(sAreaCode) > 0)
  and (sAreaCode[1] = '0') then sAreaCode := Copy(sAreaCode,2,length(sAreaCode));
  Result := sCountryCode + sAreaCode + sNumber;
end;

end.
