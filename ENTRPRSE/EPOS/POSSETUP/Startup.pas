unit Startup;

{ nfrewer440 16:26 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

implementation
uses
  forms, EposComn, SysUtils, GlobVar, EPOSCnst{, Windows, Login, Messages};

initialization
  Application.Title := 'Possetup';
  SetDrive := ExtractShortPathName(GetCommandLineDir(GetEXEDir));
  iTillNo := GetTillNo;

  // NF: 27/04/2007 Removed as file is not SQL compatible
//  sBtrvFilename := GetTillFilename; //
//  if sBtrvFilename = 'TRADEC-1.DAT' then abort;

{  if not OpenEPOSBtrv then {PostMessage(FrmLogin.Handle,WM_Close,0,0)};

end.
