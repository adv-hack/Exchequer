/////////////////////////////////////////////////////
// Unit containing common string handling routines //
/////////////////////////////////////////////////////
unit StrUtil;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes;

type
  String1 = string[1];
  string2 = string[2];
  string3 = string[3];
  string4 = string[4];
  string5 = string[5];
  string6 = string[6];
  string7 = string[7];
  string8 = string[8];
  string9 = string[9];
  string10 = string[10];
  string11 = string[11];
  string12 = string[12];
  string13 = string[13];
  string14 = string[14];
  string15 = string[15];
  string16 = string[16];
  string20 = String[20];
  string25 = String[25];
  string30 = String[30];
  string32 = string[32];
  string35 = string[35];
  string40 = string[40];
  string45 = string[45];
  string50 = string[50];
  string55 = string[55];
  string60 = string[60];
  string80 = string[80];
  string100 = string[100];
  string254 = string[254];
  string255 = string[255];

  TOpenCharArray = array of char;
  TCharArray255 = array [0..255] of char;
  TCharSet = set of char;
  TSide = (psLeft, psRight);

const
  CRLF = #13#10;
  TAB = #9;

  function BooleanAs01(Value : boolean) : char;
  function PadString(PadSide : TSide; sString : string; cChar : char; iTargetLength : integer): string;
  function TrimString(TrimSide : TSide; sString : string; cChar : char): string;
  function RemoveAllChars(sString : string; cChar : char): string;
  function StrToPence(sValue : string): LongInt;
  function PenceToStr(iPence : LongInt; bBlankzeros : boolean = FALSE): String;
  function ToDateTime(const Date : string8; const Time : string) : TDateTime; overload;
  function ToDateTime(const Date : string8) : TDateTime; overload;
  function DateTimeAsLongDate(Date : TDateTime) : string8;
  Function BooleanToStr(bBool : boolean) : string5;
  Function BooleanToYN(bBool : boolean) : string3;
  function RemoveAllBeforeChar(cChar : Char; sString : string): string;
  function ExtractCharAtPos(FromString: string; Position: Integer = 1; Default: Char = ' '): Char;
  function ExtractLeadingInteger(Value : string) : string;
  function ExtractTrailingInteger(Value : string) : string;
  function ExtractLeadingString(Value : string) : string;
  function HowManyCharInString(cChar : Char; sString : string; bConsecutive : boolean) : integer;
  function JustFileName(FileName : string) : string;
  function CreatePath(DirNames : array of string) : string;
//  function StrToFloatDef(sValue : string; rDefault : real) : real;
  function GetAllAfterChar(cChar : Char; sString : string): string;
  procedure ReplaceStr(var sString : string; sToReplace, sReplaceWith : string);
  Function GetCopyrightMessage : string;
  function Scramble(sInput : string; bNew : boolean = FALSE): string;
  function UnScramble(sInput : string; bNew : boolean = FALSE): string;
//  function Scramble(sInput : string): string;
//  function UnScramble(sInput : string): string;
  function DateToStr8(ADate : TDateTime) : string8;
  function TimeToStr6(TheTime : TDateTime) : string6;
  function Str6ToTime(sTime : String6) : TDateTime;
  function Str8ToDate(sDate : String8) : TDateTime;
  function BlankIfZero(sValue : string) : string;
  function ValidateEmailAddress(const emailAddress : string) : Boolean;
  Function Str8ToScreenDate(sDate : string8): string;
  Function Str6ToScreenTime(sTime : string6): string;
  function GetYNFromBool(bBoolean : boolean) : Char;
  function FindCloseMatch(s : string; TheStrings : TStrings) : integer;
//  Function MoneyToStr(rMoney : double; iDecs : byte = 2; bBlankIfZero : boolean = FALSE) : String;
  Function MoneyToStr(rMoney : extended; iDecs : byte = 2; bBlankIfZero : boolean = FALSE) : String;
  function StringToCodes(sString : string) : string;
  function GetThFromInt(iFraction : integer): string;
  function StringListToString(slStringList : TStringList) : String;
  function RemoveAllCharsExcept(sString, sExcept : string) : string;
  function DateToScreenDate(dDate : TDateTime) : string;
  function TimeToScreenTime(tTime : TDateTime) : string;
  function StrToPChar(sString : string) : PChar;
  //PR: 14/01/2016 Added extra default parameter to allow removing space after comma.
  function ArrayOfStringToString(aStrings : array of string; bIgnoreBlanks : boolean = TRUE; Sep : string = ', ') : String;
  function IntToByteStr(IntValue: Integer): ShortString;
  function WideCharToChar(wcChar : WideChar) : Char;
  function MaskDateToStr8(sMaskDate : string) : string;
  function DateToMaskDate(ADate : TDateTime) : string;
  function MoneyStrToFloatDef(sMoney : string; rDefault : double) : double;
  function MoneyStrToIntDef(sMoney : string; iDefault : integer) : integer;
  function NextToken(const S: string; Separator: char; var StartPos: integer): String;
  procedure Split(const S: String; Separator: Char; Strings: TStrings);
  function RemoveDoubleDoubleQuotes(sString : string) : string;

  // PKR> 03/02/2014.  Added to allow special characters in email addresses, URLs etc.
  // Originally added for ABSEXCH-15004.
  function EscapeCharsForURL(aURL : string) : string;
  function UnescapeCharsForURL(aURL : string) : string;

  //PR: 02/06/2015 ABSEXCH-16451 Functions to return company name & exchequer trademark strings
  function GetCompanyNameString : string;
  function GetExchequerTrademarkString : string;

  // CJS 2015-08-05 - ABSEXCH-15735 - VAT100 Submission
  function EscapeHTML(html: string): string;
  function UnescapeHTML(html: string): string;

  // PR: 05/01/2016 Function to return first string in array which isn't empty 
  function GetFirstPopulatedString(const Values : Array of string) : string;

  //PR: 21/07/2017 ABSEXCH-18591 Function to add a number to a file name - e.g
  //Test.xlsx will become Test (1).xlsx
  function IncrementFilename(const Filename : ShortString; RepNo : Integer) : ShortString;

  //PR: 06/09/2017 v2017 R2 ABSEXCH-18856 Create a random string to salt a password hash
  function CreateSalt(Len : Integer = 16) : string;


implementation
uses
  SysUtils, MathUtil, Math;

var
  Entities: array[0..4] of array[0..1] of string =
  (
    ('"', '&quot;'),
    ('''', '&apos;'),
    ('<', '&lt;'),
    ('>', '&gt;'),
    ('&', '&amp;')
  );

function BooleanAs01(Value : boolean) : char;
// Returns a char of '0' or '1' dependant on boolean variable.
//
// Value : boolean to convert to '0' / '1'
begin
  if Value then
    Result := '1'
  else
    Result := '0';
end;

function PadString(PadSide : TSide; sString : string; cChar : char; iTargetLength : integer): string;
// Pads a string to a target length with a specified character. Can be padded to the left or right
//
// PadSide : which side to add the extra characters to.
// sString : the string to pad.
// cChar : the character to pad with.
// iTargetLength : the length you wish to the string to padded to.
var
  sPadString : string;
  iPos : integer;
begin
  sPadString := '';
  For iPos := 1 to (iTargetLength - length(sString)) do sPadString := sPadString + cChar;
  case PadSide of
    psLeft : Result := sPadString + sString;
    psRight : Result := sString + sPadString;
  end;{case}
end;

function TrimString(TrimSide : TSide; sString : string; cChar : char): string;
// trims all characters of a specified type from one side of a given string
//
// TrimSide : which side to remove the characters from.
// sString : the string to trim.
// cChar : the character to trim off.
var
  iPos : integer;
begin
  if length(sString) > 0 then begin
    case TrimSide of
      psLeft : begin
        iPos := 1;
        while (iPos <= length(sString)) and (sString[iPos] = cChar) do inc(iPos);
        if iPos > length(sString) then sString := ''
        else sString := copy(sString,iPos,255);
      end;

      psRight : begin
        iPos := length(sString);
        while (iPos > 0) and (sString[iPos] = cChar) do dec(iPos);
        if iPos = 0 then sString := ''
        else sString := copy(sString,1,iPos);
      end;
    end;{case}
    Result := sString;
  end;{if}
end;

function RemoveAllChars(sString : string; cChar : char): string;
// Removes all of a specified character from a given string
//, no matter where the character occurs in the string.
//
// sString : string to remove characters from
// cChar : the character to remove from the given string.
var
  iPos : integer;
begin
  repeat
    iPos := Pos(cChar,sString);
    if iPos > 0 then delete(sString,iPos,1);
  until iPos = 0;
  result := sString;
end;

function StrToPence(sValue : string): LongInt;
// Converts a string in the format '9999999.99' into a value of how many pence it represents
//
// sValue : string to convert
var
  iMultiplier, iDPPos : Longint;
  sPounds : string[10];
  sPence : string[2];
begin
  if Copy(sValue,1,1) = '-' then iMultiplier := -1
  else iMultiplier := 1;

  iDPPos := Pos('.',sValue);
  if iDPPos = 0 then
    begin
      sPounds := sValue;
      if sPounds = '' then sPounds := '0';
      sPence := '00';
    end
  else begin
    sPounds := Copy(sValue,1,iDPPos - 1);
    if sPounds = '' then sPounds := '0';
    sPence := Copy(sValue,iDPPos + 1,(Length(sValue) - iDPPos));
    if sPence = '' then sPence := '00';
    if length(sPence) = 1 then sPence := sPence + '0';
  end;{if}
  StrToPence := (StrToInt(sPounds) * 100) + (StrToInt(sPence)) * iMultiplier;
end;

function PenceToStr(iPence : LongInt; bBlankzeros : boolean = FALSE): String;
// Converts an amount of pence, into a string in the format '9999999.99'.
//
// iPence : the value to convert
// bBlankZeros : when this is set : '0.00' is ouput as ''
var
  sPence : string[12];
  bNegative : boolean;
begin
  bNegative := FALSE;
  if iPence < 0 then begin
    bNegative := TRUE;
    iPence := iPence  * -1;
  end;{if}
  sPence := IntToStr(iPence);

  if length(sPence) > 2 then
    begin
      sPence := copy(sPence,1,(length(sPence) - 2)) + '.' + copy(sPence,(length(sPence) - 1),2);
    end
  else begin
    if length(sPence) = 1 then sPence := '0.0' + sPence
    else sPence := '0.' + sPence;
  end;{if}
  if bNegative then sPence := '-' + sPence;
  if bBlankzeros and (sPence = '0.00') then sPence := '';
  PenceToStr := sPence;
end;

function ToDateTime(const Date : string8; const Time : string) : TDateTime; overload;
// Pre  : Date = date in format yyyymmdd
//        Time = time in format hhmmss
// Post : Returns TDateTime equivalent. If Date blank, uses 0
begin
  try
    Result := EncodeDate(StrToInt(copy(Date,1,4)), StrToInt(copy(Date,5,2)),
      StrToInt(copy(Date,7,2)));
  except
    Result := 0;
  end;

  try
    Result := Result + EncodeTime(StrToInt(copy(Time,1,2)), StrToInt(copy(Time,3,2)),
      StrToInt(copy(Time,5,2)), 0);
  except
  end;
end;

//-----------------------------------------------------------------------

function ToDateTime(const Date : string8) : TDateTime; overload;
// Calls the above function
begin
  Result := ToDateTime(Date, '000000');
end;

//-----------------------------------------------------------------------

function DateTimeAsLongDate(Date : TDateTime) : string8;
// Post  : Returns date formatted yyyymmdd
var
  Year, Month, Day : word;
begin
  DecodeDate(Date, Year, Month, Day);
  Result := Format('%.4d%.2d%.2d', [Year, Month, Day]);
end;

//-----------------------------------------------------------------------

Function BooleanToStr(bBool : boolean) : string5;
// Converts a boolean value into the string 'True' or 'False'
//
// bBool : the boolean value to convert.
begin
  if bBool then Result := 'True'
  else Result := 'False';
end;

Function BooleanToYN(bBool : boolean) : string3;
// Converts a boolean value into the string 'Yes' or 'No'
//
// bBool : the boolean value to convert.
begin
  if bBool then Result := 'Yes'
  else Result := 'No';
end;

function RemoveAllBeforeChar(cChar : Char; sString : string): string;
// Removes the front portion of a string before (and including)
// the first instance of a specific character in a string.
//
// cChar : the character to remove (as well as all preceeding characters)
// sString : the string to remove the characters from.
var
  iPos : integer;
begin
  iPos := Pos(cChar,sString);
  Result := Copy(sString,iPos + 1,256);
end;

function ExtractCharAtPos(FromString: string; Position: Integer = 1; Default: Char = ' '): Char;
// Returns the specified character from the string, returning a default if the
// position is not valid. This is used mainly for SQL string fields when they
// hold values that are intended to be chars in Delphi, and which can return an
// empty string rather than a valid char value (which is why the Position
// defaults to 1, as this is what is required in these scenarios).
begin
  if (Position > Length(FromString)) then
    Result := Default
  else
    Result := FromString[Position];
end;

function ExtractLeadingInteger(Value : string) : string;
// Post : Returns a string with just leading numeric characters
var
  i : integer;
begin
  Result := '';
  i := 1;
  while (i <= length(Value)) and (Value[i] in ['0'..'9']) do
  begin
    Result := Result + Value[i];
    inc(i);
  end;
end;

function ExtractTrailingInteger(Value : string) : string;
// Post : Returns a string with just the originals trailing numeric characters
var
  i : integer;
begin
  Result := '';
  i := length(Value);
  while (i > 0) and (Value[i] in ['0'..'9']) do
  begin
    insert(Value[i], Result, 1);
    dec(i);
  end;
end;


function ExtractLeadingString(Value : string) : string;
// Post : Returns a string with just leading non-numeric characters
var
  i : integer;
begin
  Result := '';
  i := 1;
  while (i <= length(Value)) and not (Value[i] in ['0'..'9']) do
  begin
    Result := Result + Value[i];
    inc(i);
  end;
end;

function HowManyCharInString(cChar : Char; sString : string; bConsecutive : boolean) : integer;
// Counts how many of a particular character are in
//
// cChar        : the char that you wish to count
// sString      : the string you wish to count the chars in
// bConsecutive : whether you want to count the number of consecutive characters
//              , or just the number of characters.
var
  iFirstPos : integer;
  bGap : boolean;
  iPos : integer;
begin
  Result := 0;
  bGap := FALSE;
  iFirstPos := Pos(cChar,sString);
  if iFirstPos <> 0 then begin
    for iPos := iFirstPos to length(sString) do begin
      if sString[iPos] = cChar then
        begin
          if (not bConsecutive) or (bConsecutive and (not bGap)) then inc(Result);
        end
      else bGap := TRUE;
    end;{for}
  end;{if}
end;

function JustFileName(FileName : string) : string;
// Post : Returns just a filename without an extension e.g.
//        "c:\windows\system.ini" would become "system"
begin
  FileName := ExtractFileName(FileName);
  Result := copy(FileName, 1, length(FileName) - length(ExtractFileExt(FileName)));
end;

function CreatePath(DirNames : array of string) : string;
// Pre  : DirNames = list of directories in correct order
// Post : Directories are concatenated together with backslashes
var
  i : integer;
begin
  if Length(DirNames) = 0 then
    Result := ''
  else
  begin
    Result := IncludeTrailingPathDelimiter(DirNames[0]);
    if Length(DirNames) > 1 then
      for i := 1 to High(DirNames) do
        Result := Result + IncludeTrailingPathDelimiter(DirNames[i]);
  end;
end;

//function StrToFloatDef(sValue : string; rDefault : real) : real;
// Turns a string into a floating point number, with a default value, if the conversion fails.
//
// sValue   : value to convert into a float
// rDefault : vlue to default to if an error occurs when converting the string}
{begin
  sValue := RemoveAllChars(sValue, ',');
  try
    Result := StrToFloat(sValue);
  except
    Result := rDefault;
  end;{try}
//end;

function GetAllAfterChar(cChar : Char; sString : string): string;
// Returns the right-hand portion of a string, after a specified character
//
// cChar   : character to get remaining string after.
// sString : string to return right-hand portion of
var
  iPos : integer;
begin
  iPos := Pos(cChar, sString);
  Result := Copy(sString,iPos + 1,256);
end;

procedure ReplaceStr(var sString : string; sToReplace, sReplaceWith : string);
// Replaces all occurances of a string, with another string.
//
// sString      : string to modify
// sToReplace   : replace occurances of this string...
// sReplaceWith : ...with this string
var
  iPos : integer;
begin
  Repeat
    iPos := Pos(sToReplace,sString);
    if iPos <> 0 then begin
      Delete(sString, iPos, length(sToReplace));
      Insert(sReplaceWith, sString, iPos);
    end;{if}
  Until iPos = 0;
end;

Function GetCopyrightMessage : string;
// Returns the Exchequer / IRIS copyright message, for use in about boxes etc.
begin
//  Result := 'Copyright © Exchequer Software Ltd 1986-2005';
  //PR: 14/10/2013 Reverted to previous message temporarily
  Result := 'Copyright © Advanced Business Software & Solutions Ltd 2018.';
//  Result := 'Copyright © Advanced Business Software & Solutions Ltd 2013';
end;

function Scramble(sInput : string; bNew : boolean = FALSE): string;
var
  iScrambleKey, iPos : Integer;
  sScrambled : string;
begin
  sInput := UpperCase(sInput);
  if bNew then iScrambleKey := (Length(sInput) mod 10) + 1
  else iScrambleKey := Length(sInput) mod 10;
  sScrambled := '';
  For iPos := 1 to Length(sInput) do begin
    sScrambled := sScrambled + chr(Ord(sInput[iPos]) + iScrambleKey);
  end;{FOR}
  Scramble := sScrambled;
end;

function UnScramble(sInput : string; bNew : boolean = FALSE): string;
var
  iScrambleKey, iPos : Integer;
  sUnScrambled : string;
begin
  if bNew then iScrambleKey := (Length(sInput) mod 10) + 1
  else begin
//    sInput := UpperCase(sInput);
    iScrambleKey := Length(sInput) mod 10;
  end;{if}

  sUnScrambled := '';
  For iPos := 1 to Length(sInput) do begin
    sUnScrambled := sUnScrambled + chr(Ord(sInput[iPos]) - iScrambleKey);
  end;{FOR}
//  UnScramble := sUnScrambled;
  UnScramble := UpperCase(sUnScrambled);
end;

function DateToStr8(ADate : TDateTime) : string8;
begin
  Result := DateTimeAsLongDate(ADate);
end;

function TimeToStr6(TheTime : TDateTime) : string6;
var
  Hour, Min, Sec, MSec : Word;
begin
  DecodeTime(TheTime, Hour, Min, Sec, MSec);
  Result := PadString(psLeft,IntToStr(Hour),'0',2) + PadString(psLeft,IntToStr(Min),'0',2)
  + PadString(psLeft,IntToStr(Sec),'0',2);
end;

function Str6ToTime(sTime : String6) : TDateTime;
var
  Hour, Min, Sec : Word;
begin
  Hour := StrToIntDef(Copy(sTime,1,2),0);
  Min := StrToIntDef(Copy(sTime,3,2),0);
  Sec := StrToIntDef(Copy(sTime,5,2),0);
  Result := EncodeTime(Hour, Min, Sec, 0);
end;

function Str8ToDate(sDate : String8) : TDateTime;
var
  Year, Month, Day : word;
begin
  if (StrToIntDef(sDate, 0) = 0) then sDate := DateToStr8(Date);
  Year := StrToIntDef(Copy(sDate,1,4),0);
  Month := StrToIntDef(Copy(sDate,5,2),0);
  Day := StrToIntDef(Copy(sDate,7,2),0);
  Result := EncodeDate(Year, Month, Day);
end;

function BlankIfZero(sValue : string) : string;
begin
  if StrToFloatDef(sValue,0) = 0 then Result := ''
  else Result := sValue;
end;

{
Function ValidateEmailAddress(Address: string): boolean;
var
CharPos, CharIndex, AtCount: integer;
begin
  Result:= true;
  AtCount:= 0;

  for CharIndex:= 1 to Length(Address) do
  begin
    if Address[CharIndex] = '@' then inc(AtCount);
    if AtCount > 1 then Result:= false;
  end;

  CharPos:= Pos('@', Address);
  if (CharPos <= 1) or (CharPos >= Length(Address) - 2) then Result:= false;

  CharPos:= Pos('.', Address);
  if (CharPos <= 3) or (CharPos >= Length(Address)) then Result:= false;
end;}


{
//PR 1/6/05 New version of ValidateEmailAddress as previous version was didn't work very well
function ValidateEmailAddress(const emailAddress : string) : Boolean;
const
  ValidDomainChar = ['A'..'Z', 'a'..'z', '0'..'9', '-', '.'];
var
  iCount, iPos, j : Integer;
  MailBox, Domain : string;

  procedure CountOccurrence(WhichChar : Char; const AString : String;
                            var CharCount, CharPos : integer);
  var
    i : integer;
  begin
    CharCount := 0;
    for i := 1 to Length(AString) do
      if AString[i] = WhichChar then
      begin
        Inc(CharCount);
        CharPos := i;
      end;
  end;

begin
  //Check that we only have one occurrence of '@'
  CountOccurrence('@', s, iCount, iPos);

  Result := iCount = 1;

  if Result then
  begin
    //Split address into mailbox part (before @) and domain (eg exchequer.com). There are no
    //rules about mailbox part except length must be > 0.
    //domain part must be valid chars and must have at least one '.'. There must be at least two chars
    //before the last . and at least 2 after.
    MailBox := Copy(s, 1, iPos - 1);
    Domain := Copy(s, iPos + 1, Length(s));

    Result := (Length(MailBox) > 0) and (Length(Domain) > 4);

    if Result then
    begin
      //Check that there's no invalid chars
      for j := 1 to Length(Domain) do
        if not (Domain[j] in ValidDomainChar) then
          Result := False;
      //although a domain name may contain '-' it can't begin or end with it
      if (Domain[1] = '-') or (Domain[Pos('@', Domain) - 1] = '-') then
        Result := False;
    end;

    if Result then
    begin
      CountOccurrence('.', Domain, iCount, iPos);
      Result := (iCount > 0) and (iPos > 2) and (iPos <= Length(Domain) - 2);
    end;

  end;
end;
}


// PKR 23/01/2014. Another new version of ValidateEmailAddress as the previous
//  version didn't work very well.
// PKR. 30/01/2014. ABSEXCH-14986. Ledger Multi Contacts - Email address do not accept special characters .
// These rules are too tight compared with what appears in RFC2822, which defines
//  the format of email addresses.  Special characters are allowed in email addresses.
// Therefore, the rules have been relaxed to ensure that the email address
// "Looks like" an email address. ie. mailbox@domain, where domain must contain at
// least one dot, and each dot must have at least 1 characters either side of it.
function ValidateEmailAddress(const emailAddress : string) : Boolean;
const
  ValidChars       = ['A'..'Z', 'a'..'z', '0'..'9', '-', '.', '_', '@'];
  ValidDomainChars = ['A'..'Z', 'a'..'z', '0'..'9', '-', '.'];
var
  exploder  : TStringList;
  atPos     : integer;
  dotPos    : integer;
  mailbox   : string;
  domain    : string;
  workAddr  : string;
  index     : integer;
begin
  Result := true;

  workAddr := Trim(emailAddress);

  // If it's blank, then it's considered valid
  if (workAddr <> '') then
  begin
    // Must have at least 6 chars because domains must have at least 2 chars before the dot - a@bb.c
    // (Could probably enforce a minimum of 2 chars for the tld also)
    if(Length(workAddr) > 6) then
    begin
      // At sign must have at least one character before it, and at least 4 after
      atPos := Pos('@', workAddr);
      if (atPos <= 2) or (atPos > Length(workAddr) - 4) then
      begin
        Result := false;
      end;

      if Result then
      begin
        // Split the string on the @ symbol(s).
        exploder := TStringList.Create;
        exploder.delimiter := '@';
        exploder.DelimitedText := workAddr;

        // There should be at least 2 elements in the result - mailbox and domain.
        // Apparently, mailboxes can contain @ symbols, so we might end up with
        // more than 2 elements.
        if exploder.Count < 2 then
        begin
          Result := false;
        end
        else
        begin
          // Ensure that if the mailbox contains a dot, it is not a double-dot,
          // and that it is not at the beginning or end of the name.

          // Reassemble the mailbox (without the @ signs if there were any)
          // If the email address contains multiple @ signs then all except the
          //  last one belong to the mailbox, so the mailbox consists of all the
          // elements except the last one.
          for index := 0 to exploder.Count - 2 do // 0 to 0 for most situations
          begin
            mailbox := mailbox + exploder[index];
          end;

          // Validate the mailbox
          // Check there are no occurrences of ".."
          dotPos := Pos('..', mailbox);
          if (dotPos > 0) then
          begin
            Result := false;
          end
          else
          begin
            // No double-dots.
            // The mailbox doesn't need to have a dot, but if it does, it can't
            //  be at the beginning or end.
            if (mailbox[1] = '.') or (mailbox[Length(mailbox)] = '.') then
            begin
              Result := false;
            end;
          end;

          //....................................................................
          if Result then
          begin
            // Validate the domain
            domain := exploder[exploder.Count-1];

            // Check there are no occurrences of ".."
            dotPos := Pos('..', domain);
            if (dotPos > 0) then
            begin
              Result := false;
            end
            else
            begin
              // No double-dots.
              // Ensure that the component contains at least one dot and that
              // the first and last characters of the domain are not dots.
              dotPos := Pos('.', domain);
              if (dotPos < 1) then
              begin
                // Dot not found
                Result := false;
              end
              else
              begin
                // Ensure that the first and last characters of the domain are not dots or hyphens.
                if (domain[1] = '.') or (domain[Length(domain)] = '.') or
                   (domain[1] = '-') or (domain[Length(domain)] = '-') then
                begin
                  Result := false;
                end;
              end;
            end;
          end;
        end;
      end;
    end
    else
    begin
      // email address is too short.
      Result := false
    end;
  end;
end;


Function Str8ToScreenDate(sDate : string8): string;
begin
  Result := Copy(sDate,7,2) + '/' + Copy(sDate,5,2) + '/' + Copy(sDate,1,4);
end;

Function Str6ToScreenTime(sTime : string6): string;
begin
  Result := Copy(sTime,1,2) + ':' + Copy(sTime,3,2) + ':' + Copy(sTime,5,2);
end;

function GetYNFromBool(bBoolean : boolean) : Char;
begin
  if bBoolean then Result := 'Y'
  else Result := 'N';
end;

function FindCloseMatch(s : string; TheStrings : TStrings) : integer;
var
  slItems : TStringList;
  iPos : integer;
  bFound : boolean;
begin{FindCloseMatch}

  // find exact match
  Result := TheStrings.IndexOf(s);
  if Result = -1 then begin

    // use find method
    slItems := TStringList.create;
    slItems.Assign(TheStrings);
    slItems.find(s,Result);
    slItems.Free;

    // manually find
    if Result <= 0 then begin
      bFound := FALSE;
      iPos := 0;
      while (iPos < TheStrings.Count) and (not bFound) do begin
        if uppercase(Copy(TheStrings[iPos],1,length(s))) = uppercase(s)
        then begin
          Result := iPos;
          bFound := TRUE;
        end;{if}
        inc(iPos);
      end;{while}
    end;{if}

  end;{if}
end;{FindCloseMatch}

//Function MoneyToStr(rMoney : double; iDecs : byte = 2; bBlankIfZero : boolean = FALSE) : String;
Function MoneyToStr(rMoney : extended; iDecs : byte = 2; bBlankIfZero : boolean = FALSE) : String;

{  Function FormReal(Rnum : double; Dig, Dec : Integer) : string;
  Var
    TmpStr  :  string;
  Begin{FormReal}
{    TmpStr:='';
    Str(Rnum:Dig:Dec,TmpStr);
    Result := TmpStr;
  end;{FormReal}

begin
{  Result := FormReal(rMoney,0,iDecs);
  if Result = '-0.00' then Result := '0.00';}
  if ZeroFloat(rMoney) and bBlankifZero then Result := ''
  else begin
    Result := FloatToStrF(rMoney, ffFixed, 15, iDecs);
  end;{if}
end;

function StringToCodes(sString : string) : string;
var
  iPos : integer;
begin
  Result := '';
  For iPos := 1 to Length(sString) do begin
    Result := Result + '#' + IntToStr(Ord(sString[iPos]));
  end;{for}
end;

function GetThFromInt(iFraction : integer): string;
var
  cLastDigit : char;
begin
  if iFraction = 0 then
    begin
      GetThFromInt := ''
    end
  else begin
    if (iFraction = 11) or (iFraction = 12) or (iFraction = 13) then
      begin
        GetThFromInt := 'th';
      end
    else begin
      cLastDigit := copy(IntToStr(iFraction),length(IntToStr(iFraction)),1)[1];
      case cLastDigit of
        '1' : begin
          GetThFromInt := 'st';
        end;

        '2' : begin
          GetThFromInt := 'nd';
        end;

        '3' : begin
          GetThFromInt := 'rd';
        end;

        '4', '5', '6', '7', '8', '9', '0' : begin
          GetThFromInt := 'th';
        end;
      end;{CASE}
    end;{IF}
  end;{IF}
end;

function StringListToString(slStringList : TStringList) : String;
var
  iPos : integer;
begin
  Result := '';
  For iPos := 0 to slStringList.count-1 do
  begin
    if iPos = slStringList.count-1 then Result := Result + slStringList[iPos]
    else Result := Result + slStringList[iPos] + ', ';
  end;{for}
end;

function RemoveAllCharsExcept(sString, sExcept : string) : string;
var
  iPos : integer;
begin
  Result := '';
  For iPos := 1 to length(sString) do
  begin
    if Pos(sString[iPos], sExcept) > 0 then Result := Result + sString[iPos];
  end;{for}
end;

function DateToScreenDate(dDate : TDateTime) : string;
begin
  Result := Str8ToScreenDate(DateToStr8(dDate));
end;

function TimeToScreenTime(tTime : TDateTime) : string;
begin
  Result := Str6ToScreenTime(TimeToStr6(tTime));
end;

function StrToPChar(sString : string) : PChar;
var
  asString : AnsiString;
begin
  asString := sString;
  Result := PChar(asString);
end;
//PR: 14/01/2016 Added extra default parameter to allow removing space after comma.
function ArrayOfStringToString(aStrings : array of string; bIgnoreBlanks : boolean = TRUE; Sep : string = ', ') : String;
var
  iPos : integer;
begin
  Result := '';
  For iPos := low(aStrings) to high(aStrings) do
  begin
    if iPos = high(aStrings) then Result := Result + aStrings[iPos]
    else begin
      if bIgnoreBlanks and (aStrings[iPos] = '')
      then
      else Result := Result + aStrings[iPos] + Sep;
    end;{if}
  end;{for}
end;

function IntToByteStr(IntValue: Integer): ShortString;
{ Returns a string which contains the supplied IntValue as bytes. This is used
  for constructing Btrieve search keys where the index includes an integer
  value. }
begin
  Result := StringOfChar(' ', SizeOf(IntValue));
  Move(IntValue, Result[1], SizeOf(IntValue));
  Result[0] := Chr(SizeOf(IntValue));
end;

function WideCharToChar(wcChar : WideChar) : Char;
var
  sString : ANSIString;
begin
  sString := wcChar;
  if length(sString) = 1 then Result := sString[1]
  else Result := #0;
end;

function MaskDateToStr8(sMaskDate : string) : string;
begin
  Result := Copy(sMaskDate,5,4) + Copy(sMaskDate,3,2) + Copy(sMaskDate,1,2);
end;

function DateToMaskDate(ADate : TDateTime) : string;
begin
  Result := DateTimeAsLongDate(ADate);
  Result := Copy(Result,7,2) + Copy(Result,5,2) + Copy(Result,1,4);
end;

function MoneyStrToFloatDef(sMoney : string; rDefault : double) : double;
begin{MoneyStrToFloatDef}
//  Result := rDefault;
  sMoney := RemoveAllCharsExcept(sMoney,'01234567890-.');
  if (length(sMoney) > 0) and (sMoney[length(sMoney)] = '-')
  then sMoney := '-' + Copy(sMoney,1,length(sMoney)-1); // Fudge for minus signs being on the end
  Result := StrToFloatDef(sMoney, rDefault);
end;{MoneyStrToFloatDef}

function MoneyStrToIntDef(sMoney : string; iDefault : integer) : integer;
begin{MoneyStrToIntDef}
//  Result := iDefault;
  sMoney := RemoveAllCharsExcept(sMoney,'01234567890-');
  if (length(sMoney) > 0) and (sMoney[length(sMoney)] = '-')
  then sMoney := '-' + Copy(sMoney,1,length(sMoney)-1); // Fudge for minus signs being on the end
  Result := StrToIntDef(sMoney, iDefault);
end;{MoneyStrToIntDef}

function NextToken(const S: string; Separator: char; var StartPos: integer): String;
{ Returns the next token (substring) from string S, starting at index StartPos
  and ending 1 character before the next occurrence of Separator (or at the end
  of S, whichever comes first).

  StartPos returns the starting position for the next token, 1 more than the
  position in S of the end of this token }
var
  Idx: integer;
begin
   Result := '';

  { Step over repeated separators }
  while (S[StartPos] = Separator) and (StartPos <= length(S))do
    StartPos := StartPos + 1;

  if StartPos > length(S) then
    Exit;

  { Set Idx to StartPos }
  Idx := StartPos;

  { Find the next Separator }
  while (Idx <= length(S)) and (S[Idx] <> Separator) do
    Idx := Idx + 1;

  { Copy the token to the Result }
  Result := Copy(S, StartPos, Idx - StartPos);

  { SetStartPos to next Character after the Separator }
  StartPos := Idx + 1;
end;

procedure Split(const S: String; Separator: Char; Strings: TStrings);
{ Splits a string containing designated separators into tokens and adds them to
  the supplied TStrings. }
var
  Start: integer;
begin
  Start := 1;
  while Start <= Length(S) do
    Strings.Add(NextToken(S, Separator, Start)) ;
end;

function RemoveDoubleDoubleQuotes(sString : string) : string;
var
  iPos : integer;
  bPrevCharQuote : boolean;
begin
  bPrevCharQuote := FALSE;
  Result := '';
  For iPos := 1 to length(sString) do
  begin
    if (sString[iPos] = '"') and bPrevCharQuote then
    begin
      bPrevCharQuote := FALSE;
    end else
    begin
      Result := Result + sString[iPos];
      bPrevCharQuote := sString[iPos] = '"';
    end;{if}
  end;{for}
end;

//------------------------------------------------------------------------------
// Converts all special characters in a string into their URL-escaped form (eg. & => %26)
function EscapeCharsForURL(aURL : string) : string;
begin
  Result := aURL;

  // Do '%' first so that it doesn't change characters that we've just converted
  //  to an escaped character.
  Result := StringReplace(Result, '%', '%25', [rfReplaceAll]);

  Result := StringReplace(Result, ' ', '%20', [rfReplaceAll]);
  Result := StringReplace(Result, '!', '%21', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '%22', [rfReplaceAll]);
  Result := StringReplace(Result, '#', '%23', [rfReplaceAll]);
  Result := StringReplace(Result, '$', '%24', [rfReplaceAll]);
  Result := StringReplace(Result, '&', '%26', [rfReplaceAll]);
  Result := StringReplace(Result, '''', '%27', [rfReplaceAll]);
  Result := StringReplace(Result, '(', '%28', [rfReplaceAll]);
  Result := StringReplace(Result, ')', '%29', [rfReplaceAll]);
  Result := StringReplace(Result, '*', '%2A', [rfReplaceAll]);
  Result := StringReplace(Result, '+', '%2B', [rfReplaceAll]);
  Result := StringReplace(Result, ',', '%2C', [rfReplaceAll]);
  Result := StringReplace(Result, '-', '%2D', [rfReplaceAll]);
  Result := StringReplace(Result, '.', '%2E', [rfReplaceAll]);
  Result := StringReplace(Result, '/', '%2F', [rfReplaceAll]);
  Result := StringReplace(Result, ':', '%3A', [rfReplaceAll]);
  Result := StringReplace(Result, ';', '%3B', [rfReplaceAll]);
  Result := StringReplace(Result, '<', '%3C', [rfReplaceAll]);
  Result := StringReplace(Result, '=', '%3D', [rfReplaceAll]);
  Result := StringReplace(Result, '>', '%3E', [rfReplaceAll]);
  Result := StringReplace(Result, '?', '%3F', [rfReplaceAll]);
  Result := StringReplace(Result, '@', '%40', [rfReplaceAll]);
  Result := StringReplace(Result, '[', '%5B', [rfReplaceAll]);
  Result := StringReplace(Result, '\', '%5C', [rfReplaceAll]);
  Result := StringReplace(Result, ']', '%5D', [rfReplaceAll]);
  Result := StringReplace(Result, '^', '%5E', [rfReplaceAll]);
  Result := StringReplace(Result, '_', '%5F', [rfReplaceAll]);
  Result := StringReplace(Result, '`', '%60', [rfReplaceAll]);
  Result := StringReplace(Result, '{', '%7B', [rfReplaceAll]);
  Result := StringReplace(Result, '|', '%7C', [rfReplaceAll]);
  Result := StringReplace(Result, '}', '%7D', [rfReplaceAll]);
  Result := StringReplace(Result, '~', '%7E', [rfReplaceAll]);
end;

//------------------------------------------------------------------------------
// Converts all URL-escaped characters in a string into standard characters. (eg. %26 => &)
function UnescapeCharsForURL(aURL : string) : string;
begin
  Result := aURL;

  Result := StringReplace(Result, '%20', ' ', [rfReplaceAll]);
  Result := StringReplace(Result, '%21', '!', [rfReplaceAll]);
  Result := StringReplace(Result, '%22', '"', [rfReplaceAll]);
  Result := StringReplace(Result, '%23', '#', [rfReplaceAll]);
  Result := StringReplace(Result, '%24', '$', [rfReplaceAll]);
  Result := StringReplace(Result, '%25', '%', [rfReplaceAll]);
  Result := StringReplace(Result, '%26', '&', [rfReplaceAll]);
  Result := StringReplace(Result, '%27', '''', [rfReplaceAll]);
  Result := StringReplace(Result, '%28', '(', [rfReplaceAll]);
  Result := StringReplace(Result, '%29', ')', [rfReplaceAll]);
  Result := StringReplace(Result, '%2A', '*', [rfReplaceAll]);
  Result := StringReplace(Result, '%2B', '+', [rfReplaceAll]);
  Result := StringReplace(Result, '%2C', ',', [rfReplaceAll]);
  Result := StringReplace(Result, '%2D', '-', [rfReplaceAll]);
  Result := StringReplace(Result, '%2E', '.', [rfReplaceAll]);
  Result := StringReplace(Result, '%2F', '/', [rfReplaceAll]);
  Result := StringReplace(Result, '%3A', ':', [rfReplaceAll]);
  Result := StringReplace(Result, '%3B', ';', [rfReplaceAll]);
  Result := StringReplace(Result, '%3C', '<', [rfReplaceAll]);
  Result := StringReplace(Result, '%3D', '=', [rfReplaceAll]);
  Result := StringReplace(Result, '%3E', '>', [rfReplaceAll]);
  Result := StringReplace(Result, '%3F', '?', [rfReplaceAll]);
  Result := StringReplace(Result, '%40', '@', [rfReplaceAll]);
  Result := StringReplace(Result, '%5B', '[', [rfReplaceAll]);
  Result := StringReplace(Result, '%5C', '\', [rfReplaceAll]);
  Result := StringReplace(Result, '%5D', ']', [rfReplaceAll]);
  Result := StringReplace(Result, '%5E', '^', [rfReplaceAll]);
  Result := StringReplace(Result, '%5F', '_', [rfReplaceAll]);
  Result := StringReplace(Result, '%60', '`', [rfReplaceAll]);
  Result := StringReplace(Result, '%7B', '{', [rfReplaceAll]);
  Result := StringReplace(Result, '%7C', '|', [rfReplaceAll]);
  Result := StringReplace(Result, '%7D', '}', [rfReplaceAll]);
  Result := StringReplace(Result, '%7E', '~', [rfReplaceAll]);
end;

//PR: 02/06/2015 ABSEXCH-16451 Functions to return company name & exchequer trademark strings
function GetCompanyNameString : string;
begin
  Result := '© Exchequer is a product of Advanced Business Software & Solutions Limited, an Advanced Computer Software Group Limited company.';
end;

function GetExchequerTrademarkString : string;
begin
  Result := 'EXCHEQUER is a trade mark of Advanced Business Software & Solutions Limited.  All rights reserved. ';
end;

function EscapeHTML(html: string): string;
var
  i: Integer;
begin
  for i := Low(Entities) to High(Entities) do
  begin
    html := StringReplace(html, Entities[i][0], Entities[i][1], [rfReplaceAll]);
  end;
  Result := html;
end;

function UnescapeHTML(html: string): string;
var
  i: Integer;
begin
  for i := Low(Entities) to High(Entities) do
  begin
    html := StringReplace(html, Entities[i][1], Entities[i][0], [rfReplaceAll]);
  end;
  Result := html;
end;

function GetFirstPopulatedString(const Values : Array of string) : string;
var
  i : integer;
begin
  Result := '';
  for i := Low(Values) to High(Values) do
    if Trim(Values[i]) <> '' then
    begin
      Result := Values[i];
      Break;
    end;
end;

//PR: 21/07/2017 ABSEXCH-18591 Function to add a number to a file name - e.g
//Test.xlsx will become Test (1).xlsx
function IncrementFilename(const Filename : ShortString; RepNo : Integer) : ShortString;
var
  DotPos : Integer;
begin
  DotPos := Pos('.', Filename);
  if DotPos > 0 then
     Result := Copy(Filename, 1, DotPos - 1) + ' (' + IntToStr(RepNo) + ')' +
               Copy(FileName, DotPos, Length(Filename))
  else
    Result := Filename + ' (' + IntToStr(RepNo) + ')';
end;

//PR: 06/09/2017 v2017 R2 ABSEXCH-18856 Create a random string to salt a password hash
//Randomize should be called before the first call to this function
function CreateSalt(Len : Integer = 16) : string;
var
  i, iRange, iCode : integer;
begin
  if Len < 1 then
    Len := 16;

  Result := '';

  //Randomly add either Upper or lower case letter, or number, to string
  for i := 1 to Len do
  begin
    iRange := Random(3);
    Case iRange of
      0 : iCode := RandomRange(Ord('A'), Ord('Z'));
      1 : iCode := RandomRange(Ord('a'), Ord('z'));
      2 : iCode := RandomRange(Ord('0'), Ord('9'));
    end; //case

    Result := Result + Char(iCode);
  end;
end;



end.
