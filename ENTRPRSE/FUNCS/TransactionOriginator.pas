unit TransactionOriginator;

{ CJS - 2013-08-14 - Added new unit for MRD2.6, to provide helper functions
  for recording the Transaction Originator }

interface

uses SysUtils, VarConst, ETDateU, TransactionHelperU;

procedure SetOriginator(var InvR: InvRec);
function GetOriginatorHint(InvR: InvRec): string;

implementation

procedure SetOriginator(var InvR: InvRec);
begin
  InvR.thCreationDate := ETDateU.Today;
  InvR.thCreationTime := FormatDateTime('hhmmss', Now);
  InvR.thOriginator   := EntryRec^.Login;
end;

function GetOriginatorHint(InvR: InvRec): string;
begin
  Result := TransactionHelper(@InvR).GetOriginatorHint;
end;

end.