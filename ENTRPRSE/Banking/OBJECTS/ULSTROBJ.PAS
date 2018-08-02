unit UlstrObj;

interface

uses
  BankIObj, Aib01, CustAbsU;

type
  TUlsterBankExportObject = Class(TBankIrExportObject)
  protected
    function GetIniFileName : string; override;
  public
    constructor Create(const EventData : TAbsEnterpriseSystem);
    procedure SetHeader(const EventData : TAbsEnterpriseSystem); override;
  end;


implementation

constructor TUlsterBankExportObject.Create(const EventData : TAbsEnterpriseSystem);
begin
  inherited Create(EventData);


end;

function TUlsterBankExportObject.GetIniFileName: string;
begin
  EFTIniFile := DefaultUlsterBankIniFile;
end;

procedure TUlsterBankExportObject.SetHeader(
  const EventData: TAbsEnterpriseSystem);
begin
  inherited;

  FileHeader.Filler5[12] := '1';
  FileHeader.Filler5[13] := '2';
  FileHeader.Filler5[14] := '3';
  FileHeader.Filler5[15] := '4';
  FileHeader.Filler5[16] := '5';

  Str2_Char('98', UserHeader.ReceiverID, SizeOf(UserHeader.ReceiverID));

end;

end.
