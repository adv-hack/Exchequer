unit BarclaysInetObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  BacNcObj, CustAbsU;

type
  //No extra functionality at the moment, but maintain a separate class for future.
  TBarclaysInternetExportObject = Class(TBacsNcExportObject);



implementation

uses
  ExpObj;



end.
