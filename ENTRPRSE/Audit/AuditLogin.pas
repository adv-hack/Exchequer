unit AuditLogin;

interface

uses Classes, AuditBase;

type
  TLoginAudit = Class(TAuditBase)
  private
    FAuditValue: String;
  protected
    //AuditBase
    function NeedAuditEntry: Boolean; override;
    procedure WriteAuditData(const Destination: TAuditLogDestination;
      AuditStrings: TStrings); override;
  public
    constructor Create(const aDefaultValue: String = '');
  end;  //TLoginAudit

implementation

{TLoginAudit}

//------------------------------------------------------------------------------

constructor TLoginAudit.Create(const aDefaultValue: String);
begin
  Inherited Create;
  FAuditValue := aDefaultValue;
end;

//------------------------------------------------------------------------------

function TLoginAudit.NeedAuditEntry: Boolean;
begin
  {We have already validated when we need to write the Audit log entry so it
  will always be true.}
  Result := True;
end;

//------------------------------------------------------------------------------

procedure TLoginAudit.WriteAuditData(
  const Destination: TAuditLogDestination; AuditStrings: TStrings);
begin
  if (Destination = adAuditTrail) then
  begin
    WriteAuditSubTitle (AuditStrings, FAuditValue, '');
  end;
end;

//------------------------------------------------------------------------------

end.
