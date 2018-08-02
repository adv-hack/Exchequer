unit DLSQLSup;

interface

{$IFDEF EXSQL}
  uses
    SQLUtils;
{$ENDIF}

  procedure UseVariant(var PosBlock);

implementation

procedure UseVariant(var PosBlock);
begin
  {$IFDEF EXSQL}
  if UsingSQL then
    UseVariantForNextCall(PosBlock);
  {$ENDIF}
end;

end.
