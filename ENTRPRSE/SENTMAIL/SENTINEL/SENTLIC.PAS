unit SentLic;

interface

const
  slLicenced = 0; //Full or 30 day
  slNotLicenced = 1;
  slError = 2;

function GetSentLicence(var SentinelCount : SmallInt) : SmallInt;

procedure ShowSentNotLicencedMessage;
procedure ShowSentLicenceErrorMessage;

implementation

uses
  LicRec, EntLic, VarFPosU, sysUtils, Dialogs, FileUtil;

function GetSentLicence(var SentinelCount : SmallInt) : SmallInt;
var
  LicenceRec : EntLicenceRecType;
begin
  Try
    ExMainCoPath^ := GetEnterpriseDirectory;

    FillChar(LicenceRec, SizeOf(LicenceRec), #0);

    if ReadEntLic(EntLicFName, LicenceRec) then
    begin
      if LicenceRec.licModules[modElerts] in [1, 2] then
        Result := slLicenced
      else
        Result := slNotlicenced;

      SentinelCount := LicenceRec.licUserCounts[ucElerts];
    end
    else
      Result := slError;
  Except
    Result := slError;
  End;

end;

procedure ShowSentNotLicencedMessage;
begin
  ShowMessage('Sentimail is not licenced.'#10#10 +
              'Please contact your Exchequer dealer for licencing details.');
end;

procedure ShowSentLicenceErrorMessage;
begin
  ShowMessage('There was an error checking the security for Sentimail.'#10#10 +
              'Please contact your Exchequer support line.');
end;



end.
