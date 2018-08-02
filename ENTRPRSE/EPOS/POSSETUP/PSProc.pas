unit PSProc;

{ nfrewer440 16:26 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  EPOSCnst, GlobVar, Forms, Controls, SysUtils, EPOSProc, TKUtil, UseDLLU, EPOSComn, APIUtil, Dialogs;

var
  sGlobalCompanyPath : string;

  Procedure OpenDLL(asCompPath : AnsiString);

implementation

Procedure OpenDLL(asCompPath : AnsiString);
var
  iStatus : smallint;
begin
{OpenDLL}
  screen.cursor := crHourglass;
  iStatus := SetToolkitPath(PChar(asCompPath));
  if iStatus = 0 then
    begin
      iStatus := Ex_InitDLL;
      if iStatus = 0 then
        begin
          if OverrideTKIniFile then
          begin
            SetDrive := asCompPath;
            iTillNo := GetTillNo;
//            sBtrvFilename := GetTillFilename; // NF: 27/04/2007 Removed as file is not SQL compatible 
          end;
        end
      else begin
        MsgBox('The DLL Toolkit failed to open with the error code : ' + IntToStr(iStatus),mtError
        ,[mbOK],mbOK,'Toolkit Open Error');
      end;{if}
    end
  else begin
    MsgBox('Unable to change the path of the DLL Toolkit (' + asCompPath + ')' + #13#13 + 'Error code : ' + IntToStr(iStatus),mtError
    ,[mbOK],mbOK,'Toolkit Path Error');
  end;{if}
  screen.cursor := crDefault;
end;

end.
