unit UserIntf;

interface

uses
  AuthBase;

  function GetUserLimits(    CompanyCode : PChar;
                             UserCode    : PChar;
                         var FloorLimit  : Double;
                         var AuthLimit   : Double) : Integer; StdCall; Export;

  function GetVersion : ShortString; StdCall; Export;




implementation

uses
  SysUtils;



function GetUserValues(const CompanyCode, UserCode : AnsiString;
                         var FloorLimit : Double;
                         var AuthLimit  : Double) : Integer;
var
  Res : Integer;
  UserObject : TPaUser;
begin
  Result := 4;
  UserObject := TPaUser.Create;
  Try
    UserObject.Company := CompanyCode;
    Result := UserObject.Openfile;
    if Result = 0 then
    begin
      if UserObject.GetEqual(UserCode) = 0 then
      begin
        FloorLimit := UserObject.FloorLimit;
        AuthLimit := UserObject.AuthAmount;
        Result := 0;
      end;
    end;
  Finally
    UserObject.Free;
  End;
end;

function GetUserLimits(    CompanyCode : PChar;
                           UserCode    : PChar;
                       var FloorLimit  : Double;
                       var AuthLimit   : Double) : Integer; StdCall;
begin
  Result := GetUserValues(AnsiString(CompanyCode), AnsiString(UserCode), FloorLimit, AuthLimit);
end;


function GetVersion : ShortString;
begin
  Result := 'v6.00.001';
end;

end.
 