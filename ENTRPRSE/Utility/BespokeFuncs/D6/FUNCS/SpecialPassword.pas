unit SpecialPassword;

interface
uses
  Math, DateUtils, SysUtils{, Dialogs};

  function GetPassword : ANSIString;
  function CheckPassword(asPassword : ANSIString) : boolean;

implementation
const
  sSeparator = '!';

function GetPassword : ANSIString;
var
  iD, iB, iA, iE, iC, iDay : longint;
begin
//for iDay := 1 to 31 do
//begin
  iDay := DayOfTheMonth(Date);
  iA := Trunc(Power(iDay+7, 3));
  iB := iA - iDay;
  iC := Trunc(Sqrt(iB));
  iD := Trunc(Power(iC+1, 3));
  iE := Trunc(iD);
  Result := '1' + IntToStr(iE) + '0';
//  ShowMessage(Result);
//end;
end;

function CheckPassword(asPassword : ANSIString) : boolean;
begin
  Result := asPassword = GetPassword;
end;

(*
function GetPassword(iKey : integer) : ANSIString;
var
  a, b, c : longint;
begin
  EncodeOpCode(iKey, a, b, c);
  Result := IntToStr(a) + sSeparator + IntToStr(b) + sSeparator + IntToStr(c);
end;

function CheckPassword(iKey : integer; asPassword : ANSIString) : boolean;
var
  iPos, a, b, c : longint;
  iOpCode : byte;
  sInt : string;
begin
  Result := FALSE;

  // Get First Figure (Before Separator)
  iPos := Pos(sSeparator, asPassword);
  if iPos > 0 then
  begin
    sInt := Copy(asPassword, 1, iPos-1);
    a := StrToIntDef(sInt, 0);
    asPassword := Copy(asPassword, iPos+1, 255); // Trim First Figure off

    // Get Second Figure (Before Separator)
    iPos := Pos(sSeparator, asPassword);
    if iPos > 0 then
    begin
      sInt := Copy(asPassword, 1, iPos-1);
      b := StrToIntDef(sInt, 0);
      asPassword := Copy(asPassword, iPos+1, 255); // Trim Second Figure off

      // Remainder is third figure
      sInt := Copy(asPassword, 1, 255);
      c := StrToIntDef(sInt, 0);

      // Decode
      iOpCode := iKey;
      Result := DecodeOpCode(iOpCode, a, b, c);
    end;{if}
  end;{if}
end;
*)
end.
