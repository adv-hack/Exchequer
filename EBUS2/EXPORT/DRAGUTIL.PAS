unit dragutil;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

type
  TDragNetExport = (dntStock, dntCustomer, dntEntPriceOverWrite, dntEntPriceUpdate);

  function WriteDragNetIDFile(ExportDir, DNetPublisher, DNetPassword, DNetCompCode,
                                DNetCatCode, AdminEmail : string;
                                DNetExport : TDragNetExport) : boolean;

  function ProbablyPostCode(AddressLine : string) : boolean;
  function DateTimeAsDragNetDateTime(DateTime : TDateTime) : string;

implementation

uses
  sysutils;

function WriteDragNetIDFile(ExportDir, DNetPublisher, DNetPassword, DNetCompCode,
                              DNetCatCode, AdminEmail : string;
                              DNetExport : TDragNetExport) : boolean;
const
  STOCK_ID = 'C';
  SALES_ID = 'S';
  PRICE_ID_OVERWRITE = 'PO';
  PRICE_ID_UPDATE = 'PU';
var
  FHandle : Text;
begin
  Result := true;
  AssignFile(FHandle, IncludeTrailingBackslash(ExportDir) + 'ID.TXT');
  try
    rewrite(FHandle);
    try
      case DNetExport of
        dntStock :
          writeln(FHandle, STOCK_ID);
        dntCustomer :
          writeln(FHandle, SALES_ID);
        dntEntPriceOverwrite :
          writeln(FHandle, PRICE_ID_OVERWRITE);
        dntEntPriceUpdate :
          writeln(FHandle, PRICE_ID_UPDATE);
      end;
      writeln(FHandle, DNetPublisher);
      writeln(FHandle, DNetPassword);
      writeln(FHandle, DNetCompCode);
      writeln(FHandle, DNetCatCode);
      writeln(FHandle, AdminEmail);
    finally
      CloseFile(FHandle);
    end;
  except
    on EInOutError do
      Result := false;
  end;
end;

function ProbablyPostCode(AddressLine : string) : boolean;
// Post : Returns true if an address line matches the format of one of the
//        stored postcode formats
const
  MAX_FORMATS = 5;
  LETTERS : set of char = ['A' .. 'Z']; // Code 'A'
  DIGITS  : set of char = ['0' .. '9']; // Code '1'
  POSTCODE_FORMAT : array[1..MAX_FORMATS] of string[8] =
    ('AA11 1AA','AA1 1AA','A11 1AA','A1 1AA','A1A 1AA');
var
  i, j : integer;
  CurOK,
  FinishChecking : boolean;
begin
  Result := false;
  AddressLine := Trim(AddressLine);
  if UpperCase(AddressLine) <> AddressLine then exit;
  if length(AddressLine) > 8 then exit;

  i := 1;
  FinishChecking := false;
  while (i <= MAX_FORMATS) and not FinishChecking do
  begin
    if length(POSTCODE_FORMAT[i]) <> length(AddressLine) then
      CurOK := false
    else
    begin
      CurOK := true;
      for j := 1 to length(POSTCODE_FORMAT[i]) do
      case POSTCODE_FORMAT[i,j] of
        'A' : CurOK := CurOK and (AddressLine[j] in LETTERS);
        ' ' : CurOK := CurOK and (AddressLine[j] = ' ');
        '1' : CurOK := CurOK and (AddressLine[j] in DIGITS);
      else
        CurOK := false;
      end; // case
    end;
    FinishChecking := CurOK;
    inc(i);
  end; // while
  Result := CurOK;
end; // ProbablyPostCode

function DateTimeAsDragNetDateTime(DateTime : TDateTime) : string;
// Post : Returns DragNet datetime string in format dd/mm/yyyy hh:nn:ss i.e. 19 chars
var
  Year, Month, Day : word;
  Hour, Min, Sec, MSec : word;
begin
  DecodeDate(DateTime, Year, Month, Day);
  DecodeTime(DateTime, Hour, Min, Sec, MSec);
  Result := Format('%s/%s/%s %s:%s:%s',
    [Format('%.2d', [Day]), Format('%.2d', [Month]), Format('%.4d', [Year]),
     Format('%.2d', [Hour]), Format('%.2d', [Min]), Format('%.2d', [Sec])]);
end;



end.
