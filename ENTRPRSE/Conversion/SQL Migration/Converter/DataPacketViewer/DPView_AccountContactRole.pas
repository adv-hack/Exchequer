unit DPView_AccountContactRole;

interface

Uses SysUtils, StdCtrls;

Procedure ProcessAccountContactRole(Const OutputMemo : TMemo; Const DataBlock : Pointer; Const DataBlockLen : Integer);

implementation

Uses VarConst, oAccountContactRoleBtrieveFile, DpViewFuncs;

var
  AccountContactRole : AccountContactRoleRecType;

//=========================================================================

Procedure ProcessAccountContactRole(Const OutputMemo : TMemo; Const DataBlock : Pointer; Const DataBlockLen : Integer);
Begin // ProcessCustSupp
  If (DataBlockLen = SizeOf(AccountContactRoleRecType)) Then
  Begin
    Move (DataBlock^, AccountContactRole, SizeOf(AccountContactRoleRecType));

    OutputMemo.Lines.Add ('AccountContactRole');
    OutputMemo.Lines.Add ('------------------');

    OutputInteger (OutputMemo, 'acrContactId', AccountContactRole.acrContactId);
    OutputInteger (OutputMemo, 'acrRoleId', AccountContactRole.acrRoleId);
  End // If (DataBlockLen = SizeOf(AccountContactRoleRecType))
  Else
    OutputMemo.Lines.Add ('*** Document - AccountContactRole Invalid Size - ' + IntToStr(SizeOf(AccountContactRole)) + ' expected, ' + IntToStr(DataBlockLen) + ' received');
End; // ProcessCustSupp

end.
