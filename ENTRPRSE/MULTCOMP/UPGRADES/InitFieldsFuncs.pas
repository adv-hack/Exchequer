unit InitFieldsFuncs;

interface

uses
  InitFieldsClass, InitFieldsIntf;

  //PR: 07/09/2017 v2017 R2 ABSEXCH-18856 Added IncludeSQL param to allow initialisation of both versions if required
  function InitialiseFields(var ErrorString : string; WhichOne : TInitFieldsType; IncludeSQL : Boolean = False) : Integer;


implementation

uses
  SQLUtils;

//PR: 07/09/2017 v2017 R2 ABSEXCH-18856 Added IncludeSQL param to allow initialisation of both versions if required
function InitialiseFields(var ErrorString : string; WhichOne : TInitFieldsType; IncludeSQL : Boolean = False) : Integer;
var
  oInitFields : IInitialiseFields;
begin
  Result := 0;
  if IncludeSQL or not SQLUtils.UsingSQL then
  begin
    oInitFields := GetInitFieldsObject(WhichOne);
    if not oInitFields.Execute then
    begin
      Result := -1;
      ErrorString := oInitFields.ErrorString;
    end;
  end;
end;

end.
