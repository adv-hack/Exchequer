unit NIBObj;

interface

uses
  AibObj, Aib01, CustAbsU;

type

  TNIBExportObject = Class(TAibEftObj)
  protected
    function GetIniFileName : string; override;
  public
    procedure SetHeader(const EventData : TAbsEnterpriseSystem); override;
  end;

implementation

{ TNIBExportObject }

function TNIBExportObject.GetIniFileName: string;
begin
  EFTIniFile := DefaultNIBIniFile;
end;

procedure TNIBExportObject.SetHeader(
  const EventData: TAbsEnterpriseSystem);
var
  TempString, DateString : String;
  TempInt : longint;
begin
  GetEventData(EventData);
  inherited SetHeader(EventData);
  with EventData do
  begin
    with VolHeader do
    begin
      Version := '3'; //Label standard version
    end;

    FillChar(FileHeader.FileID4[1], SizeOf(FileHeader) - 14, ' ');
    with FileHeader do
    begin
      RecFormat := 'F';
      SectionNo := '01';
      Filler5[17] := ' '; {replace '.' with space}
    end;

    with UserHeader do
    begin
      Str2_Char('95', ReceiverID, SizeOf(ReceiverID));
      Filler2[40] := ' '; {replace '.' with space}
    end;

    with UserTrailer do
    begin
      Filler1[36] := ' '; {replace '.' with space}
    end;

  end;
end;


end.
