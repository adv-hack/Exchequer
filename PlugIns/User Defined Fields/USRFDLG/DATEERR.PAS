unit DateErr;

{ nfrewer440 09:41 03/09/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TFrmDateError = class(TForm)
    btnOK: TButton;
    Bevel1: TBevel;
    lLabel: TLabel;
    lTitle: TLabel;
    lFormat: TLabel;
    edDate: TDateTimePicker;
    btnCancel: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    sFormat : string;
  end;

  function ValidateDate(sDateFormat, sField : string) : boolean;

var
  FrmDateError: TFrmDateError;

implementation

{$R *.dfm}

function ValidateDate(sDateFormat, sField : string) : boolean;
var
  iMonth, iDay : integer;
  sMonth : string;

  function ValidateSeparator : boolean;
  var
    iPos : integer;
  begin{ValidateSeparator}
    Result := TRUE;
    For iPos := 1 to length(sDateFormat) do begin
      if sDateFormat[iPos] in ['.', '-', '/'] then begin
        if sField[iPos] <> sDateFormat[iPos] then Result := FALSE;
      end;{if}
    end;{for}
  end;{ValidateSeparator}

  function ValidateDay : boolean;
  var
    iPos, iDayStart, iDayEnd : integer;
    sDay : string;
  begin{ValidateDay}
    iDayStart := 255;
    iDayEnd := 0;
    For iPos := 1 to length(sDateFormat) do begin
      if sDateFormat[iPos] = 'd' then begin
        if iPos <= iDayStart then iDayStart := iPos;
        if iPos >= iDayEnd then iDayEnd := iPos;
      end;{if}
    end;{for}

    sDay := Copy(sField,iDayStart,iDayEnd - iDayStart + 1);
    iDay := StrToIntDef(sDay,0);

    Result := (iDay > 0) and (iDay <= 31)
  end;{ValidateDay}

  function ValidateMonth : boolean;
  var
    iPos, iMonthStart, iMonthEnd : integer;
  begin{ValidateMonth}
    iMonthStart := 255;
    iMonthEnd := 0;
    For iPos := 1 to length(sDateFormat) do begin
      if sDateFormat[iPos] = 'm' then begin
        if iPos <= iMonthStart then iMonthStart := iPos;
        if iPos >= iMonthEnd then iMonthEnd := iPos;
      end;{if}
    end;{for}

    sMonth := UpperCase(Copy(sField,iMonthStart,iMonthEnd - iMonthStart + 1));

    case length(sMonth) of
      2 : begin
        iMonth := StrToIntDef(sMonth,0);
        Result := (iMonth > 0) and (iMonth <= 12)
      end;

      3 : begin
        Result := (sMonth = 'JAN') or (sMonth = 'FEB') or (sMonth = 'MAR')
        or (sMonth = 'APR') or (sMonth = 'MAY') or (sMonth = 'JUN')
        or (sMonth = 'JUL') or (sMonth = 'AUG') or (sMonth = 'SEP')
        or (sMonth = 'OCT') or (sMonth = 'NOV') or (sMonth = 'DEC')
      end;
    end;{case}
  end;{ValidateMonth}

  function ValidateYear : boolean;
  var
    iPos, iYear, iYearStart, iYearEnd : integer;
    sYear : string;
  begin{ValidateYear}
    iYearStart := 255;
    iYearEnd := 0;
    For iPos := 1 to length(sDateFormat) do begin
      if sDateFormat[iPos] = 'y' then begin
        if iPos <= iYearStart then iYearStart := iPos;
        if iPos >= iYearEnd then iYearEnd := iPos;
      end;{if}
    end;{for}

    sYear := Copy(sField,iYearStart,iYearEnd - iYearStart + 1);
    iYear := StrToIntDef(sYear,0);

    case length(sYear) of
      2 : Result := (iYear > 0) and (iYear <= 99);
      4 : Result := (iYear >= 1900) and (iYear <= 3000);
    end;{case}

  end;{ValidateYear}

  function ValidateDayOfMonth : boolean;
  begin{ValidateDayOfMonth}
    Result := TRUE;
    case Length(sMonth) of
      2 : begin
        case iMonth of
          2 : Result := iDay <= 29;
          4 : Result := iDay <= 30;
          6 : Result := iDay <= 30;
          9 : Result := iDay <= 30;
          11 : Result := iDay <= 30;
        end;{case}
      end;

      3 : begin
        if (sMonth = 'FEB') then Result := iDay <= 29;
        if (sMonth = 'APR') then Result := iDay <= 30;
        if (sMonth = 'JUN') then Result := iDay <= 30;
        if (sMonth = 'SEP') then Result := iDay <= 30;
        if (sMonth = 'NOV') then Result := iDay <= 30;
      end;
    end;
  end;{ValidateDayOfMonth}

begin{ValidateDate}
  Result := (length(sField) = length(sDateFormat)) and ValidateSeparator
  and ValidateDay and ValidateMonth and ValidateYear and ValidateDayOfMonth;
end;{ValidateDate}

procedure TFrmDateError.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if btnCancel.Enabled or ValidateDate(sFormat, FormatDateTime(edDate.Format,edDate.Date))
  then CanClose := TRUE
  else begin
    ActiveControl := edDate;
    CanClose := FALSE;
  end;{if}
end;

end.
