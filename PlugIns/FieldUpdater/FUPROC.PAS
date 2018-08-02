unit FUPROC;

{ nfrewer440 17:10 08/12/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  Classes, Enterprise01_TLB, StrUtil, Forms, MiscUtil;

const
  {$IFDEF EX600}
    // CA 10/07/2013 v7.0.5  ABSEXCH-14439: Rebranding so version number updated
    sVersionNo = '005';
//    sVersionNo = 'v6.100.003';
  {$ELSE}
    sVersionNo = 'v5.71.001';
  {$ENDIF}
  sPlugInName = 'Exchequer Field Updater Utility';
  sPlugInCode = 'EXCHFIELDU000219';
  sSecurityCode = 'cjjjj3E23fasj84S';

type
  TCompanyRec = Record
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;

  TCompanyInfo = Class
    CompanyRec : TCompanyRec;
  end;{with}

  procedure ReportTXSaveError(iError : integer);
  function StartToolkit(sDataPath : String) : boolean;

var
  oToolkit : IToolkit;
  CompanyRec : TCompanyRec;


implementation
uses
  MathUtil, SecCodes, Dialogs, SysUtils, APIUtil, COMObj;

procedure ReportTXSaveError(iError : integer);
begin
  if iError <> 0 then
  begin
    MsgBox('The following error has occurred when trying to save an ITransaction2 Object'
    + #13#13 + 'Error ' + IntToStr(iError) + #13#13 + oToolkit.LastErrorString
    , mtError, [mbOK], mbOK, 'ITransaction2 Save Error');
  end;
end;

function StartToolkit(sDataPath : String) : boolean;

  procedure GetCompanyRecFrom(sPath : string);
  var
    iPos : integer;
  begin{GetCompanyRecFrom}
    // get current company code
    CompanyRec.Code := '';
    For iPos := 1 to oToolkit.Company.cmCount do
    begin
      if uppercase(WinGetShortPathName(IncludeTrailingPathDelimiter(Trim(oToolkit.Company.cmCompany[iPos].coPath))))
//      = uppercase(WinGetShortPathName(IncludeTrailingPathDelimiter(Trim(oToolkit.Configuration.DataDirectory))))
      = uppercase(WinGetShortPathName(IncludeTrailingPathDelimiter(Trim(sPath))))
      then CompanyRec.Code := oToolkit.Company.cmCompany[iPos].coCode;
    end;{for}

    CompanyRec.Path := sPath;
  end;{GetCompanyRecFrom}

var
  a, b, c : LongInt;
  FuncRes : integer;
begin{StartToolkit}
  // Create COM Toolkit object
  Result := FALSE;
  oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

  // Check it created OK
  If Assigned(oToolkit) Then Begin

    GetCompanyRecFrom(sDataPath);
    if CompanyRec.Code <> '' then
    begin
      With oToolkit Do Begin

        EncodeOpCode(97, a, b, c);
        oToolkit.Configuration.SetDebugMode(a, b, c);

        // Open Default Company
        oToolkit.Configuration.DataDirectory := sDataPath;
        oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;

        FuncRes := OpenToolkit;

        // Check it opened OK
        If (FuncRes = 0) then
        begin
          Result := TRUE;
        end
        else
        begin
          // Error opening Toolkit - display error
          ShowMessage ('The following error occurred opening the Toolkit:-'#13#13
          + QuotedStr(oToolkit.LastErrorString));
        end;{if}

      End; { With OToolkit }
    End;{if}

  End { If Assigned(oToolkit) }
  Else
    // Failed to create COM Object
    ShowMessage ('Cannot create COM Toolkit instance');

end;{StartToolkit}

end.
