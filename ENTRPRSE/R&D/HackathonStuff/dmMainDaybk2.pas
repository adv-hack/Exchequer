unit dmMainDaybk2;

interface

uses
  SysUtils, Classes, SQLCallerU, DB, ADODB, SQLUtils, GlobVar, Dialogs, Varconst,
  Btrvu2, BtKeys1U, BTSupU2, SysU1, ETDateU;

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
    qryDaybkFetchDataPeriod: TStringField;
    qryDaybkFetchDatathDueDate: TStringField;
    qryDaybkFetchDatathCustSupp: TStringField;
    qryDaybkFetchDatathCompanyRate: TFloatField;
    qryDaybkFetchDatathDailyRate: TFloatField;
    qryDaybkFetchDatathDocType: TIntegerField;
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
	qryDaybkFetchDataAmount: TFloatField;
    qryDaybkFetchDatathHoldFlag: TIntegerField;
    qryDaybkFetchDatathTagged: TIntegerField;
    qryDaybkFetchDatathPrinted: TBooleanField;
    qryDaybkFetchDatathIncludeInPickingRun: TBooleanField;
    qryDaybkFetchDatathTransDate_1: TStringField;
    qryDetailtlFolioNum: TIntegerField;
    qryDetailtlStockCodeTrans1: TMemoField;
    qryDetailtlOurRef: TStringField;
    qryDetailtlGLCode: TIntegerField;
    qryDetailtlLineType: TStringField;
    qryDetailtlDepartment: TStringField;
    qryDetailtlCostCentre: TStringField;
    qryDetailtlDocType: TIntegerField;
    qryDetailtlQty: TFloatField;
    qryDetailtlQtyMul: TFloatField;
    qryDetailtlNetValue: TFloatField;
    qryDetailtlDiscount: TFloatField;
    qryDetailtlVATCode: TStringField;
    qryDetailtlVATAmount: TFloatField;
    qryDetailtlPaymentCode: TStringField;
    qryDetailtlCost: TFloatField;
    qryDetailtlAcCode: TStringField;
    qryDetailtlLineDate: TStringField;
    qryDetailtlDescription: TStringField;
    qryDetailtlJobCode: TStringField;
    qryDetailtlAnalysisCode: TStringField;
    qryDetailtlStockDeductQty: TFloatField;
    qryDetailtlLocation: TStringField;
    qryDetailtlQtyPicked: TFloatField;
    qryDetailtlQtyPickedWO: TFloatField;
    qryDetailtlUsePack: TBooleanField;
    qryDetailtlSerialQty: TFloatField;
    qryDetailtlQtyPack: TFloatField;
    qryDetailtlAcCodeTrans: TStringField;
    qryDetailPositionId: TAutoIncField;
    procedure DataModuleDestroy(Sender: TObject);
    procedure qryDaybkFetchDataAfterScroll(DataSet: TDataSet);
    procedure qryDaybkFetchDataPrintSymbolGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure qryDaybkFetchDatathHoldFlagGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure qryDaybkFetchDatathTransDateGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
  private
    { Private declarations }
    FModuleType: TModuleType;
  public
    { Public declarations }
    constructor Create(aOwner : TComponent); overload;
    constructor Create(aOwner : TComponent; aModuleType: TModuleType); overload;

    procedure InitDetailQuery;
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

      qryDaybkFetchData.SQL.Text := ' SELECT [thRunNo] '+
                                      ',[thOurRef]   '+
                                      ',[thAcCode]'+
                                      ',Convert(DATE, [thTransDate], 103) as thTransDate_1' +
                                      ',(lTrim(Str(thperiod)) + ' + QuotedStr('/') + '+ lTrim(Str(thYear+1900))) as Period ' +
                                      ',[thNetValue] + [thTotalVAT] as Amount '+
                                      ',[thHoldFlag] ' + 
                                      ',CurrencyCode ' +
                                      ', Curr.Description ' +
                                      ', Curr.PrintSymbol '+
                                      ',[thNomAuto]  '+
                                      ',[thFolioNum] '+
                                      ',[thCurrency] '+
                                      ',[thDueDate]  '+
                                      ',[thCustSupp] '+
                                      ',[thCompanyRate] '+
                                      ',[thDailyRate]   '+
                                      ',[thDocType]     '+
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
                                      ',[thTagged]           '+
                                      ',[thPrinted]           '+
                                      ',[thIncludeInPickingRun] '+

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

procedure TMainDataModule.InitDetailQuery;
begin
  if qryDetail.Active then
    qryDetail.Close;

  qryDetail.Connection  := connMain;

  qryDetail.SQL.Text := ' SELECT [tlFolioNum],[tlStockCodeTrans1],[tlOurRef]   '+
                                ' ,[tlGLCode] ,[tlLineType] ,[tlDepartment] ,[tlCostCentre] '+
                                ' ,[tlDocType]      ,[tlQty]      ,[tlQtyMul]     ,[tlNetValue]     ,[tlDiscount]    ,[tlVATCode]     ,[tlVATAmount] '+
                                ' ,[tlPaymentCode]  ,[tlCost]    ,[tlAcCode]   ,[tlLineDate]    ,[tlDescription]   ,[tlJobCode]    ,[tlAnalysisCode] '+
                                ' ,[tlStockDeductQty]    ,[tlLocation]    ,[tlQtyPicked]    ,[tlQtyPickedWO]    ,[tlUsePack]    ,[tlSerialQty]       '+
                                ' ,[tlQtyPack]      ,[tlAcCodeTrans]	  ,PositionId '+
                                ' FROM '+  SQLUtils.GetCompanyCode(SetDrive) + '.[DETAILS] '+
                                ' where tlDocType = :DocType1 or tlDocType = :DocType2'  ;


  case FModuleType of
      mtSales :  {SALES SCREEN}
        begin
          qryDetail.Parameters.ParamValues['DocType1'] := 0;
          qryDetail.Parameters.ParamValues['DocType2'] := 1;
        end; {mtSales}

      mtPurchase :
        begin    {PURCHASE SCREEN}
          qryDetail.Parameters.ParamValues['DocType1'] := 0;
          qryDetail.Parameters.ParamValues['DocType2'] := 1;
        end; {mtPurchase}
    end; {case}

    qryDetail.Open;
end;

procedure TMainDataModule.qryDaybkFetchDataPrintSymbolGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := TxLatePound(Sender.Value, True);
end;

procedure TMainDataModule.qryDaybkFetchDatathHoldFlagGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := Disp_HoldPStat(Sender.Value,qryDaybkFetchDatathTagged.Value, qryDaybkFetchDatathPrinted.Value, BOff,(qryDaybkFetchDatathIncludeInPickingRun.Value));
end;

procedure TMainDataModule.qryDaybkFetchDatathTransDateGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  //Text := POutDate(Sender.Value);
end;

end.
