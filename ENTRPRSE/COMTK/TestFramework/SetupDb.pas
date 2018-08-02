unit SetupDb;

interface

uses
  Enterprise04_TLB, SysUtils, Dialogs, FileUtil, Classes,SQLCallerU;

type
  TProgressProc = procedure(const sMessage : string) of object;

procedure AddExtraStockItems(const oToolkit : IToolkit; const OnProgress : TProgressProc);
procedure SetupIniFile;
procedure CloseJob(const SQLCaller : TSQLCaller; const CoCode : string);
procedure SetBOMKittingOptions(const SQLCaller : TSQLCaller; const CoCode : string);

implementation

uses
  StrUtils;

procedure SetupIniFile;
const
  S_DEDUCT_BOM_STOCK = 'Deduct_BOM_Stock';
  S_CLOSED_JOB = 'No_Trans_To_Closed_Job';
var
  AList : TStringList;
  sIniName : string;
  i : integer;
begin
  AList := TStringList.Create;
  sIniName := GetEnterpriseDirectory + 'ExchDll.ini';
  Try
    AList.LoadFromFile(sIniName);
    for i := 0 to AList.Count - 1 do
    begin
      if Pos(S_DEDUCT_BOM_STOCK, AList[i]) > 0 then
        AList[i] := AnsiReplaceStr(AList[i], 'OFF', 'ON')
      else
      if Pos(S_CLOSED_JOB, AList[i]) > 0 then
        AList[i] := AnsiReplaceStr(AList[i], 'OFF', 'ON');
    end;
    AList.SavetoFile(sIniName);
  Finally
    AList.Free;
  End;
end;

procedure AddExtraStockItems(const oToolkit : IToolkit; const OnProgress : TProgressProc);
var
  Res : integer;

  procedure DoProgress(const s : string);
  begin
    if Assigned(OnProgress) then
      OnProgress(s);
  end;

begin
  DoProgress('Adding Average Stock Item');
  with oToolkit.Stock.Add as IStock4 do
  begin
    stCode := 'AVE1';
    stDesc[1] := 'Average 1';
    stValuationMethod := stValAverage;

    stBalSheetGL := 72020;
    stPAndLGL := 72020;
    stSalesGL := 72020;
    stCOSGL := 72020;
    stWIPGL := 72020;

    stSalesReturnGL := 72020;
    stPurchaseReturnGL := 72020;

    stSalesBands['A'].stCurrency := 1;
    stSalesBands['A'].stPrice := 200;

    Res := Save;

    if Res <> 0 then
      ShowMessage('Unable to store stock item AVE1. Error: '#10 +
                   QuotedStr(oToolkit.LastErrorString))
    else
      DoProgress('Average Stock Item added');
  end;

  DoProgress('Adding LIFO Stock Item');
  with oToolkit.Stock.Add as IStock4 do
  begin
    stCode := 'LIFO1';
    stDesc[1] := 'Lifo 1';
    stValuationMethod := stValLIFO;

    stBalSheetGL := 72020;
    stPAndLGL := 72020;
    stSalesGL := 72020;
    stCOSGL := 72020;
    stWIPGL := 72020;

    stSalesReturnGL := 72020;
    stPurchaseReturnGL := 72020;

    stSalesBands['A'].stCurrency := 1;
    stSalesBands['A'].stPrice := 200;

    Res := Save;

    if Res <> 0 then
      ShowMessage('Unable to store stock item LIFO1. Error: '#10 +
                   QuotedStr(oToolkit.LastErrorString))
    else
      DoProgress('LIFO Stock Item added');
  end;

  DoProgress('Adding Serial/Batch Average Stock Item');
  with oToolkit.Stock.Add as IStock4 do
  begin
    stCode := 'SERIALAVE1';
    stDesc[1] := 'Serial Average 1';
    stValuationMethod := stValSerialAvgCost;

    stBalSheetGL := 72020;
    stPAndLGL := 72020;
    stSalesGL := 72020;
    stCOSGL := 72020;
    stWIPGL := 72020;

    stSalesReturnGL := 72020;
    stPurchaseReturnGL := 72020;

    stSalesBands['A'].stCurrency := 1;
    stSalesBands['A'].stPrice := 200;

    Res := Save;

    if Res <> 0 then
      ShowMessage('Unable to store stock item SERIALAVE1. Error: '#10 +
                   QuotedStr(oToolkit.LastErrorString))
    else
      DoProgress('Serial/Batch Average Stock Item added');
  end;


end;

procedure CloseJob(const SQLCaller : TSQLCaller; const CoCode : string);
var
  sQuery : AnsiString;
begin
  sQuery := 'UPDATE ' + CoCode + '.JobHead SET JobStat = 5 WHERE JobCode = ''TAI-IN1'' ';
  if SQLCaller.ExecSQL(sQuery) = -1 then
    ShowMessage(SQLCaller.ErrorMsg);

end;

procedure SetBOMKittingOptions(const SQLCaller : TSQLCaller; const CoCode : string);
var
  sQuery : AnsiString;
begin
  sQuery := 'UPDATE ' + CoCode + '.Stock SET stShowKitOnSales = 1 WHERE stCode = ''ALARMSYS-DOM-1'' ';
  if SQLCaller.ExecSQL(sQuery) = -1 then
    ShowMessage(SQLCaller.ErrorMsg);
end;

end.
