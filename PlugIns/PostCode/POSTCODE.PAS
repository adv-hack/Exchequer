{Postcode Copyright 2000 AFD Computers, 01624 811711}
{Provides Type Definitions, Constants and Error Report Routine}

unit Postcode;

interface

Uses
SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
Forms, Dialogs, StdCtrls;

{Procedure & Function prototypes}
  procedure AFDReportError ( ErrorCode: longint);
  function Trim(WorkString: String): string;
  function IntConv(WorkArray: pChar): LongInt;
  function CharConv(WorkArray: pChar): String;

 { project globals }

 { Postcode Structure}
  Type PostcodeData = record
    Lookup: Array[0..59] of Char;
    Postcode: Array [0..7] of Char;
    PostcodeType: Array [0..1] of Char;
    Organisation: Array [0..29] of Char;
    Prop: Array [0..29] of Char;
    Street: Array [0..59] of Char;
    Locality: Array [0..59] of Char;
    Town: Array [0..29] of Char;
    County: Array [0..29] of Char;
    CountyOption: char;
    Mailsort: Array [0..4] of Char;
    STDCode: Array [0..7] of Char;
    GridN: Array [0..5] of Char;
    GridE: Array [0..4] of Char;
    Reserved: Array [0..49] of Char;
  end;

 {Return Error Codes}
  Const SUCCESS = 0;
  Const CHANGED_POSTCODE = 1;
  Const CHANGED_STD = -2;
  Const CHANGED_POSTCODE_STD = 3;
  Const OUTCODE_ONLY = 4;
  Const OUTCODE_BREAK = 5;
  Const NOT_FOUND = -2;
  Const ERROR_OPENING_FILES = -4;
  Const END_OF_SEARCH = -6;
  Const DATA_LICENSE_ERROR = -7;
  Const MAX_LIMIT_REACHED = -9;
  Const NO_SEARCH_DATA = -10;
  Const INVALID_LOOKUP_TYPE = -11;

 {GetFirst Flags}
  Const LOOKUP = 0;
  Const SEARCH = 1;
  Const OUTCODE_BREAKS = 2;
  Const OUTCODE_SKIP = 8;

 {County Types}
  Const OMIT = 0;
  Const POSTAL = 1;
  Const ABBR_POSTAL = 2;
  Const POSTAL_OPTIONAL = 3;
  Const ABBR_POSTAL_OPTIONAL = 4;
  Const TRADITIONAL = 5;
  Const ADMINISTRATIVE = 6;

implementation

procedure AFDReportError ( ErrorCode: longint);
Var
  ErMsg: String;

begin
  {Shows simple error messages if DLL call is unsuccessful}

  case ErrorCode of
   -2:        ErMsg := 'Postcode Not Found';
   -4:        ErMsg := 'Error Opening Files';
   -6:        ErMsg := 'End Of Search';
   -7:        ErMsg := 'Error Opening Files';
   -9:        ErMsg := 'Maximum Search Limit Reached';
   -10:       ErMsg := 'No Search Data';
   -11:       ErMsg := 'Specified Lookup Type Is Invalid';
  else
              ErMsg := 'Error No ' + IntToStr(ErrorCode);
  end; {case}

  MessageDlg(ErMsg, mtError,[mbok], 0);

 end;

{Function to Trim off Spaces at either Side of a String}
function Trim(WorkString: String): string;
 begin
    While Copy(WorkString,Length(Workstring),1)=' '
    do Workstring:=Copy(Workstring,1,Length(Workstring)-1);

    While Copy(WorkString, 1, 1)=' '
    do Workstring:=Copy(Workstring,2,Length(Workstring)-1);
    Trim := Workstring;
 end ;

{Function to Convert Char Array to Trimmed Strings}
function CharConv(WorkArray: pChar): string;
 Var
   Temp: String;

 Begin
   Temp := StrPas(WorkArray);
   Temp := Trim(Temp);
   CharConv:=Temp;
 end;

{Function to Convert Char Array to LongInteger}
function IntConv(WorkArray: pChar): LongInt;
 Var
  Temp: String;
  k,stat: Integer;

  Begin
    Temp:=CharConv(WorkArray);
    {Is there a full stop in the string?}
    k:=Pos('.',Temp);
    {If not, is there a space?}
    If k=0 then k:=Pos(' ',Temp);

    {If so ignore it}
    if k>0 then
      val(Copy(Temp, 1 , k-1),result, stat)
    else
      {else send whole lot}
       val(Temp, result, stat);
  end;

 end.
