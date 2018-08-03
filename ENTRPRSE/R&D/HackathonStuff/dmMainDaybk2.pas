unit dmMainDaybk2;

interface

uses
  SysUtils, Classes, SQLCallerU, DB, ADODB, SQLUtils, GlobVar, Dialogs, Varconst,
  Btrvu2, BtKeys1U;

const
  NonDocTypeForPurch = 22;
  NonDocTypeForSales = 7;
type
  TModuleType = (
                  mtNone = 0,
                  mtSales = 1,
                  mtPurchase = 2
                );

  TMainDataModule = class(TDataModule)
    connMain: TADOConnection;
    qryDaybkFetchData: TADOQuery;
    dsDaybkFetchData: TDataSource;
    qryDetail: TADOQuery;
    dsDaybookDetail: TDataSource;
    qryDaybkFetchDatathRunNo: TIntegerField;
    qryDaybkFetchDataCurrencyCode: TIntegerField;
    qryDaybkFetchDataDescription: TStringField;
    qryDaybkFetchDataPrintSymbol: TStringField;
    qryDaybkFetchDatathAcCode: TStringField;
    qryDaybkFetchDatathNomAuto: TBooleanField;
    qryDaybkFetchDatathOurRef: TStringField;
    qryDaybkFetchDatathFolioNum: TIntegerField;
    qryDaybkFetchDatathCurrency: TIntegerField;
    qryDaybkFetchDatathYear: TIntegerField;
    qryDaybkFetchDatathPeriod: TIntegerField;
    qryDaybkFetchDatathDueDate: TStringField;
    qryDaybkFetchDatathTransDate: TStringField;
    qryDaybkFetchDatathCustSupp: TStringField;
    qryDaybkFetchDatathCompanyRate: TFloatField;
    qryDaybkFetchDatathDailyRate: TFloatField;
    qryDaybkFetchDatathDocType: TIntegerField;
    qryDaybkFetchDatathNetValue: TFloatField;
    qryDaybkFetchDatathTotalVAT: TFloatField;
    qryDaybkFetchDatathTotalLineDiscount: TFloatField;
    qryDaybkFetchDatathOperator: TStringField;
    qryDaybkFetchDatathDeliveryNoteRef: TStringField;
    qryDaybkFetchDatathControlGL: TIntegerField;
    qryDaybkFetchDatathJobCode: TStringField;
    qryDaybkFetchDatathPostedDate: TStringField;
    qryDaybkFetchDatathPORPickSOR: TBooleanField;
    qryDaybkFetchDatathYourRef: TStringField;
    qryDaybkFetchDatathOriginator: TStringField;
    qryDaybkFetchDataPositionId: TAutoIncField;
    qryDaybkFetchDataOurRefPrefix: TStringField;
    procedure DataModuleDestroy(Sender: TObject);
    procedure qryDaybkFetchDataAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
    FModuleType: TModuleType;
  public
    { Public declarations }
    constructor Create(aOwner : TComponent); overload;
    constructor Create(aOwner : TComponent; aModuleType: TModuleType); overload;
  end;

var
  MainDataModule: TMainDataModule;

implementation

{$R *.dfm}

{ TDataModule1 }

constructor TMainDataModule.Create(aOwner : TComponent; aModuleType: TModuleType);
var
  lConnStr: String;
  lRes: Integer;
begin
  inherited Create(aOwner);

  lConnStr := '';
  FModuleType := aModuleType;
  lRes := GetConnectionString(SQLUtils.GetCompanyCode(SetDrive), False, lConnStr);
  if (lRes = 0) then
  begin
    //Initialise main connection
    connMain := TADOConnection.Create(Self);
    connMain.ConnectionString := lConnStr;
    connMain.Connected := True;

    //Initialise query
    qryDaybkFetchData.Connection := connMain;
    qryDaybkFetchData.Prepared := True;
    //qryDaybkFetchData.SQL.Text := 'SELECT * FROM ' + SQLUtils.GetCompanyCode(SetDrive) + '.[DOCUMENT] ' +
                                 // 'WHERE [OurRefPrefix] = :ourrefprefix AND ' +
                                 // '[thRunNo] = 0 AND ' +
                                 // '(thFolioNum > -2147483647) AND ' +
                                 // '(thFolioNum < 2147483647) AND ' +
                                 // 'thDocType <> :thdoctype';

      qryDaybkFetchData.SQL.Text := ' SELECT [thRunNo],CurrencyCode, Curr.Description, Curr.PrintSymbol '+
                                      ',[thAcCode]'+
                                      ',[thNomAuto]  '+
                                      ',[thOurRef]   '+
                                      ',[thFolioNum] '+
                                      ',[thCurrency] '+
                                      ',[thYear]     '+
                                      ',[thPeriod]   '+
                                      ',[thDueDate]  '+
                                      ',[thTransDate]'+
                                      ',[thCustSupp] '+
                                      ',[thCompanyRate] '+
                                      ',[thDailyRate]   '+
                                      ',[thDocType]     '+
                                      ',[thNetValue]    '+
                                      ',[thTotalVAT]    '+
                                      ',[thTotalLineDiscount] '+
                                      ',[thOperator]          '+
                                      ',[thDeliveryNoteRef]   '+
                                      ',[thControlGL]         '+
                                      ',[thJobCode]           '+
                                      ',[thPostedDate]        '+
                                      ',[thPORPickSOR]        '+
                                      ',[thYourRef]           '+
                                      ',[thOriginator]        '+
                                      ',[PositionId]          '+
                                      ',[OurRefPrefix]        '+

     'FROM ' + SQLUtils.GetCompanyCode(SetDrive) + '.[DOCUMENT] Doc ' +
	  'inner join ' + SQLUtils.GetCompanyCode(SetDrive) + '.[CURRENCY] Curr on Doc.thcurrency = Curr.currencycode ' +
    'where [OurRefPrefix] = :ourrefprefix and [thRunNo] = 0 and (Doc.thFolioNum > -2147483647) and (Doc.thFolioNum < 2147483647) and Doc.thDocType <> :thdoctype ' ;

    //Now we initialise query with proper where clause
    case FModuleType of
      mtSales :  {SALES SCREEN}
        begin
          qryDaybkFetchData.Parameters.ParamValues['ourrefprefix'] := 'S';
          qryDaybkFetchData.Parameters.ParamValues['thdoctype'] := NonDocTypeForSales;
        end; {mtSales}

      mtPurchase :
        begin    {PURCHASE SCREEN}
          qryDaybkFetchData.Parameters.ParamValues['ourrefprefix'] := 'P';
          qryDaybkFetchData.Parameters.ParamValues['thdoctype'] := NonDocTypeForPurch;
        end; {mtPurchase}
    end; {case}
    qryDaybkFetchData.Open;
  end
  else
    ShowMessage('Could not retrieve ConnectionStr using GetConnectionString fn, Error code=' + IntToStr(lRes));
    
end;

procedure TMainDataModule.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(connMain) then
    FreeAndNil(connMain);
end;

constructor TMainDataModule.Create(aOwner : TComponent);
begin
  inherited Create(aOwner);
end;

procedure TMainDataModule.qryDaybkFetchDataAfterScroll(DataSet: TDataSet);
var
  lKeyS: Str255;
begin
  lKeyS := FullOurRefKey(qryDaybkFetchDatathOurRef.Value);
  Status := Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^, InvOurRefK, lKeyS);
end;

end.
