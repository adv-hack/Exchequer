unit vatUtils;

interface

uses
  SysUtils;

const
  StatusSubmitted = 1;
  StatusPending   = 2;
  StatusError     = 3;
  StatusAccepted  = 4;

function FormatSubmissionStatus(aStatus : smallint) : string;
function FormatVatPeriod(period : string) : string;
function FormatSubmittedDate(date : string) : string;
function FormatVatValue_Double(aValue : double) : string;
function FormatVatValue_Int(aValue : double) : string;

implementation

function FormatSubmissionStatus(aStatus : smallint) : string;
begin
  Result := '';
  case aStatus of
    StatusSubmitted:
      Result := 'Submitted';
    StatusPending:
      Result := 'Pending';
    StatusError:
      Result := 'Error';
    StatusAccepted:
      Result := 'Accepted';
  end;
end;

function FormatVatPeriod(period : string) : string;
begin
  if Length(period) < 6 then
  begin
    Result := period;
  end
  else
  begin
    // CJS 2015-08-28 - ABSEXCH-16807 - Invalid VAT Submission date and period
    Result := Copy(period, 1, 4) + '-' + Copy(period, Length(period) - 1, 2);
  end;
end;

function FormatSubmittedDate(date : string) : string;
begin
  if Length(date) < 15 then
  begin
    Result := date;
  end
  else
  begin
    // CJS 2015-08-28 - ABSEXCH-16807 - Invalid VAT Submission date and period
    // Example of 'date' contents: 28082015 142011
    Result := Format('%s/%s/%s %s:%s:%s', [Copy(date, 1,2), Copy(date, 3,2), Copy(date,5,4), Copy(date, 10,2), Copy(date,12,2), Copy(date,14,2)]);;
  end;
end;

function FormatVatValue_Double(aValue : double) : string;
begin
  Result := '£' + Trim(Format('%10.2n', [aValue]));
end;

function FormatVatValue_Int(aValue : double) : string;
begin
  Result := '£' + Trim(Format('%10.0n', [aValue]));
end;

end.
