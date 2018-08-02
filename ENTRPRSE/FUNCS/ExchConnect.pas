// Open method of TAdoconnection dumps the password so that it is replaced with Texchconnection which internally calls
// overloaded method of Open which takes UserId and Password as parameters to Open the Connection.

unit ExchConnect;

interface

uses
  SysUtils, Dialogs, ADODB, Classes, ComObj, StrUtils;

type
  TExchConnection = class(TADOConnection)
  private
    FExchPassword: WideString;
    FUserId: WideString;
    function GetConnectionString: WideString;
    procedure SetConnectionString(const Value: WideString);
    procedure SetPassword(const Value: WideString);
    procedure SetUserId(const Value: widestring);
    function EnDeCrypt(const Value: WideString; IsEncrypted: Boolean): WideString;
  protected
    { protected declarations }
    FOldConString: WideString;
    procedure InitConnectionStr(const Value: WideString; var aConString, aPassword: WideString);
    property UserId: WideString read FUserId write SetUserId;
  public
    { public declarations }
    procedure Open(); overload;
    property Password: WideString read FExchPassword write SetPassword;
  published
    { published declarations }
    property ConnectionString: WideString read GetConnectionString write SetConnectionString;
  end;

implementation

{ TExchConnection }

function TExchConnection.GetConnectionString: WideString;
begin
  Result := TADOConnection(self).ConnectionString;

end;

function TExchConnection.EnDeCrypt(const Value: WideString; IsEncrypted: Boolean): WideString;
var
  CharIndex: integer;
  lCnt: Integer;
begin
  if IsEncrypted then
    lCnt := 51
  else
    lCnt := 51 * (-1);
  //Result := Value;
  for CharIndex := 1 to Length(Value) do
  begin
    if (Value[CharIndex] <> '=') and (Value[CharIndex] <> ';') then
      //Result := Result+ chr(not (ord(Value[CharIndex])) )
      Result := Result + chr(ord(Value[CharIndex]) + lCnt)
    else
      Result := Result + Value[CharIndex];
  end;
end;

// This procedure separates password from Connection String so that it is not dumped and password is given separately to Open the connection.
procedure TExchConnection.InitConnectionStr(const Value: WideString; var aConString, aPassword: WideString);
var
 // lSlist: TStringList;
  i, j: integer;
  lStr, lName: WideString;
  lEncryptedStr: WideString;
  lcharvar: WideChar;
  identifier, idenvalue: WideString;
  lPasswrdFound, isTag, isValue, lDataSrc: Boolean;
begin
 // lSlist := TStringList.Create();

  isTag := True;
  lPasswrdFound := false;
  lDataSrc := True;
  for i := 1 to Length(Value) do
  begin
    lcharvar := Value[i];

    if lcharvar = '=' then
    begin
      if UpperCase(identifier) = UpperCase('Password') then
        lPasswrdFound := True;

      if not lPasswrdFound then
      begin
        aConString := aConString + identifier + lcharvar;
      end;
      idenvalue := '';
      isValue := True;
      isTag := False;

    end
    else if lcharvar = ';' then
    begin
      if lPasswrdFound then
      begin
        lPasswrdFound := False;
        aPassword := idenvalue
      end
      else
      begin
        aConString := aConString + idenvalue + lcharvar;
      end;

      identifier := '';
      isTag := True;
      isValue := False;
    end
    else if isTag then
    begin
      identifier := identifier + lcharvar;
    end
    else if isValue then
    begin
      idenvalue := idenvalue + lcharvar;
    end
    

 //   aConString := aConString + lcharvar;

  end;
  if (isValue) and (idenvalue <> EmptyStr ) then
  begin
    if lPasswrdFound then
      aPassword := idenvalue
    else
      aConString := aConString + idenvalue;  
  end;


end;

procedure TExchConnection.Open;
begin
  if (Password <> EmptyStr) then
    Open(UserId, Password)
  else
    TADOConnection(Self).Open;
end;

procedure TExchConnection.SetConnectionString(const Value: WideString);
var
  lConString: WideString;
  lPassword: WideString;
begin
  if Value <> TADOConnection(self).ConnectionString then
  begin
   // FOldConString := EnDeCrypt(Value);
    InitConnectionStr(Value, lConString, lPassword);
    Password := lPassword;
    TADOConnection(self).ConnectionString := lConString;
  end;
end;

procedure TExchConnection.SetPassword(const Value: WideString);
begin
  if (Value <> EmptyStr) then
    FExchPassword := Value;
end;

procedure TExchConnection.SetUserId(const Value: WideString);
begin
  FUserId := Value;
end;

end.

