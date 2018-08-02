unit EbusLic;

interface



const
  eblLicenced = 0; //Full or 30 day
  eblNotLicenced = 1;
  eblError = 2;

function GetEbusLicence : SmallInt;

procedure ShowEbusNotLicencedMessage;
procedure ShowEbusLicenceErrorMessage;

implementation

uses
  LicRec, EntLic, VarFPosU, sysUtils, Dialogs, FileUtil;



function GetEbusLicence : SmallInt;
var
  LicenceRec : EntLicenceRecType;
begin
  Try
{At the moment this takes the Enterprise dir from the exe path - needs updating to
 deal with local program files}
    ExMainCoPath^ := '';

    FillChar(LicenceRec, SizeOf(LicenceRec), #0);

    if ReadEntLic(GetEnterpriseDirectory + EntLicFName, LicenceRec) then
    begin
      if LicenceRec.licModules[modEBus] in [1, 2] then
        Result := eblLicenced
      else
        Result := eblNotlicenced;
    end
    else
      Result := eblError;
  Except
    Result := eblError;
  End;

end;

procedure ShowEbusNotLicencedMessage;
begin
  ShowMessage('The E-Business module is not licenced.'#10#10 +
              'Please contact your Exchequer dealer for licencing details.');
end;

procedure ShowEbusLicenceErrorMessage;
begin
  MessageDlg('There was an error checking the security for the E-Business module.'#10#10 +
              'Please contact your Exchequer support line.', mtError, [mbOK], 0);
end;

end.
