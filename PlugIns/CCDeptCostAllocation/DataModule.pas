unit DataModule;

interface

uses
  ADOSQLUtil, Controls, Dialogs, SysUtils, APIUtil, Classes, DB, ADODB
  , MiscUtil, StrUtil, SQLUtils, AllocVar;

type
  TSQLDataModule = class(TDataModule)
    ADOConnection_Common: TADOConnection;
    qCommonQuery: TADOQuery;
  private
    { Private declarations }
  public
    function Connect : boolean;
    function TableExists : boolean;
    procedure CreateTable;
    function GetRecordsForCompany(CurrentCompany : string): TADOQuery;
    function GetAllRecordsFor(CurrentCompany : string; GLCode : integer; Name : string): TADOQuery; overload;
    function GetAllRecordsFor(CurrentCompany : string; GLCode : integer): TADOQuery; overload;
    function GetLine(CurrentCompany : string; GLCode : Integer; Name : string; LinePos : integer): TADOQuery;
    function GetAllRecordsWithCCDept(CurrentCompany : string; GLCode : Integer; Name, CC, Dept : string): TADOQuery;
    function GetAllLinesFor(CurrentCompany : string; GLCode : Integer; Name : string): TADOQuery;
    procedure AddRecord(CurrentCompany : string;
                                    GLCode : integer;
                                    LinePos : integer;
                                    AllocType : integer;
                                    Name : string;
                                    Desc : string;
                                    CostCentre : string;
                                    Department : string;
                                    Percentage : Double;
                                    RecordType : integer);
    procedure UpdateAllRecordsFor(CurrCompanyCode : string;
                                              CurrGLCode : Integer;
                                              CurrName : string;
                                              NewName : string;
                                              NewDesc : string;
                                              NewType : Integer);
    procedure RenumberLines(CurrCompanyCode : string;
                                        CurrGLCode : Integer;
                                        CurrName : string;
                                        StartLine : Integer);
    procedure DeleteRecords(CurrCompanyCode : string;
                                        CurrGLCode : Integer;
                                        CurrName : string);
    procedure DeleteLine(CurrCompanyCode : string;
                                        CurrGLCode : Integer;
                                        CurrName : string;
                                        LinePos : integer);
    procedure UpdateLine(CurrCompanyCode : string;
                                        CurrGLCode : Integer;
                                        CurrName : string;
                                        LinePos  : Integer;
                                        NewCC : string;
                                        NewDept : string;
                                        NewPercentage : Double);
    procedure Disconnect;
  end;


var
  bSQL : boolean;
  SQLDataModule : TSQLDataModule;

implementation

{$R *.dfm}

function TSQLDataModule.Connect : boolean;
var
  asConnectionString,lPassword : WideString;
  iStatus : integer;
begin{Connect}
  Result := FALSE;
  //iStatus := GetCommonConnectionString(asConnectionString);
  iStatus := GetCommonConnectionStringWOPass(asConnectionString,lPassword);
  if iStatus = 0 then
  begin
    ADOConnection_Common.ConnectionString := asConnectionString;
    if lPassword <> EmptyStr then
      ADOConnection_Common.Open('',lPassword)  //SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    else
      ADOConnection_Common.Connected := TRUE;

    Result := ADOConnection_Common.Connected;

    if Result then
    begin
      // Create Table if it doesn't exist
      if not SQLDataModule.TableExists then
      begin
        SQLDataModule.CreateTable;
      end;{if}
    end
    else
    begin
      MsgBox('ADOConnection_Common could not connect', mtError, [mbOK], mbOK, 'ADOConnection_Common Error');
    end;{if}
  end
  else
  begin
    MsgBox('TSQLDataModule.Connect GetCommonConnectionString Error : ' + IntToStr(iStatus), mtError, [mbOK]
    , mbOK, 'GetCommonConnectionString Error');
  end;{if}
end;{Connect}

procedure TSQLDataModule.Disconnect;
begin
  ADOConnection_Common.Connected := FALSE;
end;

function TSQLDataModule.TableExists : boolean;
begin
  Result := false;
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('select count(*)');
  qCommonQuery.SQL.Add('from information_schema.tables');
  qCommonQuery.SQL.Add('where table_schema = ''common''');
  qCommonQuery.SQL.Add('and table_name = ''CCDeptCostAllocation''');
  if ExecuteSQL(qCommonQuery, TRUE, TRUE) then
  begin
    if qCommonQuery.RecordCount > 0 then
    begin
      qCommonQuery.First;
      Result := qCommonQuery.Fields[0].AsInteger > 0;
    end;{if}
  end;{if}
end;

procedure TSQLDataModule.CreateTable;
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('CREATE TABLE [common].[CCDeptCostAllocation](');
  qCommonQuery.SQL.Add('[RecordID] [bigint] IDENTITY(1,1) NOT NULL,');
  qCommonQuery.SQL.Add('[CompanyCode] [nvarchar](6) NOT NULL,');
  qCommonQuery.SQL.Add('[GLCode] [bigint] NOT NULL,');
  qCommonQuery.SQL.Add('[LinePos] [bigint] NOT NULL,');
  qCommonQuery.SQL.Add('[Type] [bigint] NOT NULL,');
  qCommonQuery.SQL.Add('[Name] [nvarchar](20) NOT NULL,');
  qCommonQuery.SQL.Add('[Description] [nvarchar](45) NOT NULL,');
  qCommonQuery.SQL.Add('[CostCentre] [nvarchar](3) NOT NULL,');
  qCommonQuery.SQL.Add('[Department] [nvarchar](3) NOT NULL,');
  qCommonQuery.SQL.Add('[Percentage] [decimal](5, 2) NOT NULL,');
  qCommonQuery.SQL.Add('[RecordType] [bigint] NOT NULL,');
  qCommonQuery.SQL.Add('CONSTRAINT [PK_CCDeptCostAllocation] PRIMARY KEY CLUSTERED(');
  qCommonQuery.SQL.Add('[RecordID] ASC');
  qCommonQuery.SQL.Add(')WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]');
  qCommonQuery.SQL.Add(') ON [PRIMARY]');

  ExecuteSQL(qCommonQuery, FALSE, TRUE, FALSE);
end;

function TSQLDataModule.GetRecordsForCompany(CurrentCompany : string): TADOQuery;
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('SELECT *');
  qCommonQuery.SQL.Add(' FROM common.CCDeptCostAllocation');
  qCommonQuery.SQL.Add(' WHERE CompanyCode = ' + QuotedStr(CurrentCompany));
  qCommonQuery.SQL.Add(' ORDER BY GLCode, Name, LinePos');
  ExecuteSQL(qCommonQuery, TRUE, TRUE);
  Result := qCommonQuery;
end;

function TSQLDataModule.GetAllRecordsFor(CurrentCompany : string; GLCode : Integer; Name : string): TADOQuery;
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('SELECT *');
  qCommonQuery.SQL.Add(' FROM common.CCDeptCostAllocation');
  qCommonQuery.SQL.Add(' WHERE CompanyCode = ' + QuotedStr(CurrentCompany));
  qCommonQuery.SQL.Add(' AND GLCode = ' + QuotedStr(IntToStr(GLCode)));
  qCommonQuery.SQL.Add(' AND Name = ' + QuotedStr(Name));
  qCommonQuery.SQL.Add(' ORDER BY LinePos');

  ExecuteSQL(qCommonQuery, TRUE, TRUE);
  Result := qCommonQuery;
end;

function TSQLDataModule.GetAllRecordsFor(CurrentCompany : string; GLCode : Integer): TADOQuery;
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('SELECT *');
  qCommonQuery.SQL.Add(' FROM common.CCDeptCostAllocation');
  qCommonQuery.SQL.Add(' WHERE CompanyCode = ' + QuotedStr(CurrentCompany));
  qCommonQuery.SQL.Add(' AND GLCode = ' + QuotedStr(IntToStr(GLCode)));
  qCommonQuery.SQL.Add(' ORDER BY Name, LinePos');

  ExecuteSQL(qCommonQuery, TRUE, TRUE);
  Result := qCommonQuery;
end;

function TSQLDataModule.GetLine(CurrentCompany : string; GLCode : Integer; Name : string; LinePos : integer): TADOQuery;
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('SELECT *');
  qCommonQuery.SQL.Add(' FROM common.CCDeptCostAllocation');
  qCommonQuery.SQL.Add(' WHERE CompanyCode = ' + QuotedStr(CurrentCompany));
  qCommonQuery.SQL.Add(' AND GLCode = ' + QuotedStr(IntToStr(GLCode)));
  qCommonQuery.SQL.Add(' AND Name = ' + QuotedStr(Name));
  qCommonQuery.SQL.Add(' AND LinePos = ' + QuotedStr(IntToStr(LinePos)));

  ExecuteSQL(qCommonQuery, TRUE, TRUE);
  Result := qCommonQuery;
end;

function TSQLDataModule.GetAllRecordsWithCCDept(CurrentCompany : string; GLCode : Integer; Name, CC, Dept : string): TADOQuery;
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('SELECT *');
  qCommonQuery.SQL.Add(' FROM common.CCDeptCostAllocation');
  qCommonQuery.SQL.Add(' WHERE CompanyCode = ' + QuotedStr(CurrentCompany));
  qCommonQuery.SQL.Add(' AND GLCode = ' + QuotedStr(IntToStr(GLCode)));
  qCommonQuery.SQL.Add(' AND Name = ' + QuotedStr(Name));
  qCommonQuery.SQL.Add(' AND CostCentre = ' + QuotedStr(CC));
  qCommonQuery.SQL.Add(' AND Department = ' + QuotedStr(Dept));
  qCommonQuery.SQL.Add(' ORDER BY LinePos');

  ExecuteSQL(qCommonQuery, TRUE, TRUE);
  Result := qCommonQuery;
end;

function TSQLDataModule.GetAllLinesFor(CurrentCompany : string; GLCode : Integer; Name : string): TADOQuery;
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('SELECT *');
  qCommonQuery.SQL.Add(' FROM common.CCDeptCostAllocation');
  qCommonQuery.SQL.Add(' WHERE CompanyCode = ' + QuotedStr(CurrentCompany));
  qCommonQuery.SQL.Add(' AND GLCode = ' + QuotedStr(IntToStr(GLCode)));
  qCommonQuery.SQL.Add(' AND Name = ' + QuotedStr(Name));
  qCommonQuery.SQL.Add(' AND RecordType = ' + QuotedStr('0'));
  qCommonQuery.SQL.Add(' ORDER BY LinePos');

  ExecuteSQL(qCommonQuery, TRUE, TRUE);
  Result := qCommonQuery;
end;

procedure TSQLDataModule.AddRecord( CurrentCompany : string;
                                    GLCode : integer;
                                    LinePos : integer;
                                    AllocType : integer;
                                    Name : string;
                                    Desc : string;
                                    CostCentre : string;
                                    Department : string;
                                    Percentage : Double;
                                    RecordType : integer);
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add(' INSERT INTO common.CCDeptCostAllocation');
  qCommonQuery.SQL.Add(' ([CompanyCode],[GLCode],[LinePos],[Type],[Name],[Description],[CostCentre],[Department],[Percentage],[RecordType])');
  qCommonQuery.SQL.Add(' VALUES (');
  qCommonQuery.SQL.Add(QuotedStr(CurrentCompany) + ',');
  qCommonQuery.SQL.Add(QuotedStr(IntToStr(GLCode)) + ',');
  qCommonQuery.SQL.Add(QuotedStr(IntToStr(LinePos)) + ',');
  qCommonQuery.SQL.Add(QuotedStr(IntToStr(AllocType)) + ',');
  qCommonQuery.SQL.Add(QuotedStr(Name) + ',');
  qCommonQuery.SQL.Add(QuotedStr(Desc) + ',');
  qCommonQuery.SQL.Add(QuotedStr(CostCentre) + ',');
  qCommonQuery.SQL.Add(QuotedStr(Department) + ',');
  qCommonQuery.SQL.Add(QuotedStr(FloatToStr(Percentage)) + ',');
  qCommonQuery.SQL.Add(QuotedStr(IntToStr(RecordType)));
  qCommonQuery.SQL.Add(')');

  ExecuteSQL(qCommonQuery, FALSE, TRUE);
end;

procedure TSQLDataModule.UpdateAllRecordsFor( CurrCompanyCode : string;
                                              CurrGLCode : Integer;
                                              CurrName : string;
                                              NewName : string;
                                              NewDesc : string;
                                              NewType : Integer);
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('UPDATE common.CCDeptCostAllocation');
  qCommonQuery.SQL.Add(' SET');
  qCommonQuery.SQL.Add(' Name = ' + QuotedStr(NewName) + ',');
  qCommonQuery.SQL.Add(' Description = ' + QuotedStr(NewDesc) + ',');
  qCommonQuery.SQL.Add(' Type = ' + QuotedStr(IntToStr(NewType)));
  qCommonQuery.SQL.Add(' WHERE CompanyCode = ' + QuotedStr(CurrCompanyCode));
  qCommonQuery.SQL.Add(' AND GLCode = ' + QuotedStr(IntToStr(CurrGLCode)));
  qCommonQuery.SQL.Add(' AND Name = ' + QuotedStr(CurrName));

  ExecuteSQL(qCommonQuery, FALSE, TRUE, FALSE);
end;

procedure TSQLDataModule.RenumberLines( CurrCompanyCode : string;
                                        CurrGLCode : Integer;
                                        CurrName : string;
                                        StartLine : Integer);
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('UPDATE common.CCDeptCostAllocation');
  qCommonQuery.SQL.Add(' SET');
  qCommonQuery.SQL.Add(' LinePos = LinePos - 1');
  qCommonQuery.SQL.Add(' WHERE CompanyCode = ' + QuotedStr(CurrCompanyCode));
  qCommonQuery.SQL.Add(' AND GLCode = ' + QuotedStr(IntToStr(CurrGLCode)));
  qCommonQuery.SQL.Add(' AND Name = ' + QuotedStr(CurrName));
  qCommonQuery.SQL.Add(' AND LinePos > ' + QuotedStr(IntToStr(StartLine)));

  ExecuteSQL(qCommonQuery, FALSE, TRUE, FALSE);
end;

procedure TSQLDataModule.UpdateLine(CurrCompanyCode : string;
                                        CurrGLCode : Integer;
                                        CurrName : string;
                                        LinePos  : Integer;
                                        NewCC : string;
                                        NewDept : string;
                                        NewPercentage : Double);
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('UPDATE common.CCDeptCostAllocation');
  qCommonQuery.SQL.Add(' SET ');
  qCommonQuery.SQL.Add(' CostCentre = ' + QuotedStr(NewCC) + ',');
  qCommonQuery.SQL.Add(' Department = ' + QuotedStr(NewDept) + ',');
  qCommonQuery.SQL.Add(' Percentage = ' + FloatToStr(NewPercentage));
  qCommonQuery.SQL.Add(' WHERE CompanyCode = ' + QuotedStr(CurrCompanyCode));
  qCommonQuery.SQL.Add(' AND GLCode = ' + QuotedStr(IntToStr(CurrGLCode)));
  qCommonQuery.SQL.Add(' AND Name = ' + QuotedStr(CurrName));
  qCommonQuery.SQL.Add(' AND LinePos = ' + QuotedStr(IntToStr(LinePos)));

  ExecuteSQL(qCommonQuery, FALSE, TRUE, FALSE);
end;

procedure TSQLDataModule.DeleteRecords( CurrCompanyCode : string;
                                        CurrGLCode : Integer;
                                        CurrName : string);
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('DELETE FROM common.CCDeptCostAllocation');
  qCommonQuery.SQL.Add(' WHERE CompanyCode = ' + QuotedStr(CurrCompanyCode));
  qCommonQuery.SQL.Add(' AND GLCode = ' + QuotedStr(IntToStr(CurrGLCode)));
  qCommonQuery.SQL.Add(' AND Name = ' + QuotedStr(CurrName));

  ExecuteSQL(qCommonQuery, FALSE, TRUE, FALSE);
end;

procedure TSQLDataModule.DeleteLine( CurrCompanyCode : string;
                                        CurrGLCode : Integer;
                                        CurrName : string;
                                        LinePos : integer);
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('DELETE FROM common.CCDeptCostAllocation');
  qCommonQuery.SQL.Add(' WHERE CompanyCode = ' + QuotedStr(CurrCompanyCode));
  qCommonQuery.SQL.Add(' AND GLCode = ' + QuotedStr(IntToStr(CurrGLCode)));
  qCommonQuery.SQL.Add(' AND Name = ' + QuotedStr(CurrName));
  qCommonQuery.SQL.Add(' AND LinePos = ' + QuotedStr(IntToStr(LinePos)));

  ExecuteSQL(qCommonQuery, FALSE, TRUE, FALSE);
end;

initialization
  bSQL := UsingSQL;

end.


