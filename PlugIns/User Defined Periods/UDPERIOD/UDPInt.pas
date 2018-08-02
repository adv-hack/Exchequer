unit UDPInt;

interface

{EXTERNAL FUNCTIONS LOCATED IN UDPERIOD.DLL}
function GetUDPeriodYear(sDataPath, sDate : string; var iPeriod : Byte; var iYear : Byte) : boolean;
stdcall; external 'UDPeriod.DLL';

function GetDateFromUDPY(sDataPath : string; var sDate : shortstring; iPeriod, iYear : Byte) : boolean;
stdcall; external 'UDPeriod.DLL';

function GetUDPeriodYear_Ext(pDataPath, pDate : pChar; var iPeriod : smallint; var iYear : smallint) : smallint;
stdcall; external 'UDPeriod.DLL';

function GetDateFromUDPY_Ext(pDataPath : pChar; var pDate : PChar; iPeriod, iYear : smallint) : smallint;
stdcall; external 'UDPeriod.DLL';

function UseUDPeriods(pDataPath : pChar) : smallint;
stdcall; external 'UDPeriod.DLL';

procedure SuppressErrorMessages(iSetTo : smallint);
stdcall; external 'UDPeriod.DLL';




implementation

end.
 