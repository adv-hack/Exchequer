unit UpgradeUserPermissions;

//HV 03/07/2017 2017-R2 ABSEXCH-18820: 2.2.1 User Management - Permissions.

interface
   function UpdateUserPermission(var aErrString: String): Integer;

implementation

uses
  GlobVar,
  Dialogs,
  Forms,
  ETStrU,
  ETMiscU,
  VarRec2U,
  BtrvU2,
  CommonU,
  ComCtrls,
  VarConst,
  SysUtils;

function UpdateUserPermission(var aErrString: String): Integer;
var
  lRes: Integer;
  lKeyS: Str255;
begin
  Result := -1;

  Open_System(PWrdF,PWrdF);
  try
    //Find current record if exist

    lKeyS := 'L' + #0 + SetPadNo(Form_Int(69,0),3)+SetPadNo(Form_Int(92,0), 3);

    Status := Find_Rec(B_GetEq, F[PWrdF],PWrdF,RecPtr[PWrdF]^,0,lKeyS);

    if StatusOK then
    begin
      with Password.PassListRec do
      begin
        PassDesc := 'Utilities - Access to User Management';
        lRes := Put_Rec(F[PWrdF], PWrdF, RecPtr[PWrdF]^, 0);
        if lRes <> 0 then
          aErrString := 'Database error ' + IntToStr(lRes) + ' updating Password Record';
        Result := lRes;
      end;
    end;
  finally
    Close_Files(true);
  end;
end;

end.
