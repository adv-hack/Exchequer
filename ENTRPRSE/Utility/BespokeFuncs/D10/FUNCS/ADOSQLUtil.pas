unit ADOSQLUtil;

interface
uses
  Forms, Controls, Dialogs, SysUtils, ADODB, APIUtil;

  function VariantToChar(TheVariant : Variant) : AnsiChar;
  function ExecuteSQL(TheQuery : TADOQuery; bGetDataset : boolean; bShowErrors : boolean; bShowZeroRowErrors : boolean = TRUE) : boolean;
  function GetPropertyFromConnectionString(sProperty, asConnectionString : ANSIString) : string;
  function GetServerFromConnectionString(asConnectionString : ANSIString) : string;
  function GetDatabaseFromConnectionString(asConnectionString : ANSIString) : string;
  function GetBinAsHexString(const Buffer : pByte; BufferSize : longint) : string;

implementation

function VariantToChar(TheVariant : Variant) : AnsiChar;
var
  sStringOne : String[1];
begin{VariantToChar}
  sStringOne := TheVariant;
  if Length(sStringOne) > 0 then Result := sStringOne[1]
  else Result := #0;
end;{VariantToChar}

function ExecuteSQL(TheQuery : TADOQuery; bGetDataset : boolean; bShowErrors : boolean; bShowZeroRowErrors : boolean = TRUE) : boolean;
var
  iQResult : integer;
  SaveCursor : TCursor;
  sQuery : string;
begin
  SaveCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;

  if bGetDataset then
  begin
    try
      TheQuery.Active := TRUE;
      iQResult := 0;
    except
      on E:Exception do
      begin
        if bShowErrors then
        begin
          sQuery := TheQuery.Parameters.Command.CommandText;
          MsgBox('An error occurred when executing the following query : '#13#13
          + sQuery + #13#13 + QuotedStr(E.Message)
          , mtError, [mbOK], mbOK, 'Query Exception');
        end;{if}
        iQResult := -999;
      end;
    end;{try}

    Result := iQResult = 0;
  end else
  begin
    try
      iQResult := TheQuery.ExecSQL;
      if iQResult = -1 then iQResult := 1; // sometimes you get -1 for a sucessfully executed Query
    except
      on E:Exception do
      begin
        if bShowErrors then
        begin
          sQuery := TheQuery.Parameters.Command.CommandText;
          MsgBox('An error occurred when executing the following query  : '#13#13
          + sQuery + #13#13 + QuotedStr(E.Message)
          , mtError, [mbOK], mbOK, 'Query Exception');
        end;{if}
        iQResult := -999;
      end;
    end;{try}

    if iQResult = 0 then
    begin
      if bShowErrors and  bShowZeroRowErrors then
      begin
        MsgBox('This Query affected zero rows : '#13#13
        + TheQuery.SQL.Text, mtError, [mbOK], mbOK, 'Query Error');
      end;{if}
      iQResult := -998;
    end;{if}

    Result := iQResult > 0;
  end;{if}

  Screen.Cursor := SaveCursor;
end;

function GetPropertyFromConnectionString(sProperty, asConnectionString : ANSIString) : string;
// e.g. Provider=SQLOLEDB.1;Data Source=P004433\IRISEXCHEQUER;Initial Catalog=Exchequer620;User Id=REPZZZZ01964;Password=m1H7HmVt;OLE DB Services=-2
var
  iPos : integer;
begin
  iPos := Pos(sProperty, asConnectionString);
  asConnectionString := Copy(asConnectionString, iPos, 1000);
  iPos := Pos(';', asConnectionString);
  Result := Copy(asConnectionString, Length(sProperty)+1, iPos - Length(sProperty) -1);
end;

function GetServerFromConnectionString(asConnectionString : ANSIString) : string;
// e.g. Provider=SQLOLEDB.1;Data Source=P004433\IRISEXCHEQUER;Initial Catalog=Exchequer620;User Id=REPZZZZ01964;Password=m1H7HmVt;OLE DB Services=-2
var
  iPos : integer;
  sKey : string;
begin
  result := GetPropertyFromConnectionString('Data Source=', asConnectionString);
end;

function GetDatabaseFromConnectionString(asConnectionString : ANSIString) : string;
begin
  result := GetPropertyFromConnectionString('Initial Catalog=', asConnectionString);
end;

function GetBinAsHexString(const Buffer : pByte; BufferSize : longint) : string;
var
  i : integer;
begin
  if BufferSize <= 1 then
    Result := '0x00'
  else
  begin
    Result := '0x';
    for i := 0 to BufferSize - 1 do
      Result := Result + Format('%.2x', [pByte(Integer(Buffer) + i)^]);
  end;
end;


end.
