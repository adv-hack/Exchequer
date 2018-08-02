unit AuditAnonymisation;

//HV 02/02/2018 2017R1 ABSEXCH-19685: Auditing after successfully Anonymising entity

interface

uses Classes, AuditBase, GDPRConst, oSystemSetup, SysUtils, StrUtils,
     oAnonymisationDiaryBtrieveFile, VarConst;

type
  TAuditAnonymisation = Class(TAuditBase)
  private
    FAuditList: TStringList;
  protected
    //AuditBase
    function NeedAuditEntry: Boolean; override;
    procedure WriteAuditData(const ADestination: TAuditLogDestination; AuditStrings: TStrings); override;
  public
    constructor Create(const ADefaultList: TStringList);
  end;  //TAuditAnonymisation

implementation

{TAuditAnonymisation}

//------------------------------------------------------------------------------

constructor TAuditAnonymisation.Create(const ADefaultList: TStringList);
begin
  inherited Create;
  FAuditList := ADefaultList;
end;

//------------------------------------------------------------------------------

function TAuditAnonymisation.NeedAuditEntry: Boolean;
begin
  {We have already validated when we need to write the Audit log entry so it
  will always be true.}
  Result := True;
end;

//------------------------------------------------------------------------------

procedure TAuditAnonymisation.WriteAuditData(const ADestination: TAuditLogDestination; AuditStrings: TStrings);
var
  i: Integer;
  lEntityStr,
  lEntityCode: String;
  lEntityType: TAnonymisationDiaryEntity;
begin
  if (ADestination = adAuditTrail) then
  begin
    //Title
    WriteAuditSubTitle (AuditStrings, 'GDPR Configuration', '');

    WriteChangesHeader(AuditStrings, 'Field', 'Value');

    with SystemSetup(True).GDPR do
    begin
      //Trader Settings
      WriteDataChange (AuditStrings, 'Trad Anon Notes Opt', NotesAnonymisationControlCentreList[GDPRTraderAnonNotesOption]);
      WriteDataChange (AuditStrings, 'Trad Anon Letter Opt', LettersAnonymisationControlCentreList[GDPRTraderAnonLettersOption]);
      WriteDataChange (AuditStrings, 'Trad Anon Links Opt', LinksAnonymisationControlCentreList[GDPRTraderAnonLinksOption]);
      //Employee Settings
      if JBCostOn then
      begin
        WriteDataChange (AuditStrings, 'Emp Anon Notes Opt', NotesAnonymisationControlCentreList[GDPREmployeeAnonNotesOption]);
        WriteDataChange (AuditStrings, 'Emp Anon Letter Opt', LettersAnonymisationControlCentreList[GDPREmployeeAnonLettersOption]);
        WriteDataChange (AuditStrings, 'Emp Anon Link Opt', LinksAnonymisationControlCentreList[GDPREmployeeAnonLinksOption]);
      end;
    end;

    WriteAuditSubTitle (AuditStrings, #13+'Entity Anonymised', '');

    WriteChangesHeader(AuditStrings, 'Entity Type', 'Entity Code');

    for i := 0 to (FAuditList.Count - 1) do
    begin
      lEntityStr := Trim(FAuditList.Strings[i]);
      lEntityCode := LeftStr(lEntityStr, Length(lEntityStr)-2);
      lEntityType := TAnonymisationDiaryEntity(StrToInt(RightStr(lEntityStr, 1)));
      WriteDataChange(AuditStrings, AnonDiaryEntityTypeDesc[lEntityType], lEntityCode);
    end;
  end;
end;

//------------------------------------------------------------------------------

end.
