unit ClydeObj2;

interface

uses
  ExpObj, CustAbsU, ClydObj;

type
  TClydeExportObject2 = Class(TClydExportObject)
  private
    FBacsID : string;
    function GetBacsID(const EventData : TAbsEnterpriseSystem) : string;
  protected
     function FormatField(const s : string) : string; override;
  public
    constructor Create(const EventData :TAbsEnterpriseSystem);
    function CreateOutFile(const AFileName : AnsiString;
                            const EventData :
                            TAbsEnterpriseSystem) : integer; override;
  end;

implementation

uses
  MultIni, IniFiles, SysUtils;

const
  S_INI_FILENAME = 'ClydesdaleBacs.ini';

{ TClydeExportObject2 }

constructor TClydeExportObject2.Create(
  const EventData: TAbsEnterpriseSystem);
begin
  inherited Create;
  FBacsID := GetBacsID(EventData);
  if Trim(FBacsID) = '' then
    Failed := flUserId;
end;

function TClydeExportObject2.CreateOutFile(const AFileName: AnsiString;
  const EventData: TAbsEnterpriseSystem): integer;
begin
  Result := inherited CreateOutFile(AFileName, EventData);
  if Result = 0 then
    WriteThisRec(UserBankSort + ',' + UserBankAcc + ',' + FBacsID);
end;

function TClydeExportObject2.FormatField(const s: string): string;
begin
  Result := s;
end;

function TClydeExportObject2.GetBacsID(const EventData : TAbsEnterpriseSystem): string;
begin
  Result := UserID;
  if Trim(Result) = '' then
  with TIniFile.Create(EventData.Setup.ssDataPath + S_INI_FILENAME) do
  Try
    Result := ReadString('Settings','BACSID', '');
  Finally
    Free;
  End;
end;

end.
