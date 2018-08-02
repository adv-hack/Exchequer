unit RVProc;

interface
uses
  Enterprise01_TLB, StrUtil, PIUtils;

const
  sSystemCode = 'EXCHREVVAT000068';
  sSecurityCode = 'dfs983hdi4idjdkw';
  sGlobalBespokeName = 'Reverse Charge VAT Plug-In';
  sINIFile = 'Reverse.ini';

type
  TProductMode = (pmVAT, pmUDF);
  TCustomerMode = (cmAccType, cmUDF);

  TParameters = Record
    iValue : integer;
    iRCSLUDF : integer;
    sVATReturn : string1;
    sCC : string3;
    sDept : string3;
    sCustomer : string6;
    sSupplier : string6;
//    iSRIGLCode : integer;
    ProductMode : TProductMode;
    sProdVATCode : string1;
    iProdUDF : integer;
    sProdUDFValue : string30;
    CustomerMode : TCustomerMode;
    sAccType : string4;
    iCustUDF : integer;
    sCustUDFValue : string30;
  end;

var
  oToolkit : IToolkit;
  CompanyRec : TCompanyRec;

  function GetParameters(sCompanyPath : string) : TParameters;
  function ProductIsReverseVAT(sStockCode : string16; Parameters : TParameters) : boolean;
  function GetReverseTotal(Transaction : ITransaction; Parameters : TParameters) : real;

implementation
uses
  SysUtils, Inifiles;

function GetParameters(sCompanyPath : string) : TParameters;
var
  sINIFilename : string;
  INIFile : TInifile;
begin{SaveParameters}
  sINIFilename := Trim(sCompanyPath) + sINIFile;
  INIFile := TInifile.Create(sINIFilename);

  with Result do
  begin
    iValue := INIFile.ReadInteger('Settings', 'DeMinimus', 0);
    iRCSLUDF := INIFile.ReadInteger('Settings', 'RCSLUDF', 1);
    sVATReturn :=  INIFile.ReadString('Settings', 'VATReturnVATCode', 'S');
    sCC := INIFile.ReadString('Settings', 'CC', '');
    sDept := INIFile.ReadString('Settings', 'Dept', '');
    sCustomer := INIFile.ReadString('Settings', 'Customer', '');
    sSupplier := INIFile.ReadString('Settings', 'Supplier', '');
//    iSRIGLCode := INIFile.ReadInteger('Settings', 'SRIGLCode', 0);

    if INIFile.ReadString('Settings', 'ProductMode', 'VAT') = 'VAT'
    then ProductMode := pmVAT
    else ProductMode := pmUDF;
    sProdVATCode := INIFile.ReadString('Settings', 'ProdVATCode', 'S');
    iProdUDF := INIFile.ReadInteger('Settings', 'ProdUDF', 1);
    sProdUDFValue := INIFile.ReadString('Settings', 'ProdUDFValue', '');

    if INIFile.ReadString('Settings', 'CustomerMode', 'Type') = 'Type'
    then CustomerMode := cmAccType
    else CustomerMode := cmUDF;
    sAccType := INIFile.ReadString('Settings', 'CustAccType', '');
    iCustUDF := INIFile.ReadInteger('Settings', 'CustUDF', 1);
    sCustUDFValue := INIFile.ReadString('Settings', 'CustUDFValue', '');
  end;{with}

  INIFile.Free;
end;{LoadParameters}

function ProductIsReverseVAT(sStockCode : string16; Parameters : TParameters) : boolean;
var
  iStatus : integer;
begin{ProductIsReverseVAT}
  Result := FALSE;
  if sStockCode <> '' then
  begin
    oToolkit.Stock.Index := stIdxCode;
    iStatus := oToolkit.Stock.GetEqual(oToolkit.Stock.BuildCodeIndex(sStockCode));
    if iStatus = 0 then
    begin
      case Parameters.ProductMode of
        pmVAT : begin
          Result := oToolkit.Stock.stVATCode = Parameters.sProdVATCode;
        end;

        pmUDF : begin
          case Parameters.iProdUDF of
            1 : Result := Trim(UpperCase(oToolkit.Stock.stUserField1)) = Trim(UpperCase(Parameters.sProdUDFValue));
            2 : Result := Trim(UpperCase(oToolkit.Stock.stUserField2)) = Trim(UpperCase(Parameters.sProdUDFValue));
            3 : Result := Trim(UpperCase(oToolkit.Stock.stUserField3)) = Trim(UpperCase(Parameters.sProdUDFValue));
            4 : Result := Trim(UpperCase(oToolkit.Stock.stUserField4)) = Trim(UpperCase(Parameters.sProdUDFValue));
          end;{case}
        end;
      end;{case}
    end;{if}
  end;{if}
end;{ProductIsReverseVAT}

function GetReverseTotal(Transaction : ITransaction; Parameters : TParameters) : real;
var
  iLine : integer;
  rTotal : real;
begin{GetReverseTotal}
  rTotal := 0;
  with Transaction do begin
    for iLine := 1 to thLines.thLineCount do
    begin
      if ProductIsReverseVAT(Trim(thLines.thLine[iLine].tlStockCode), Parameters) then
      begin
        if not Transaction.thLines[iLine].tlPayment then
        begin
          rTotal := rTotal +  oToolkit.Functions.entConvertAmountWithRates(thLines.thLine[iLine].entLineTotal(TRUE
          , Transaction.thSettleDiscPerc), TRUE, thCurrency, transaction.thCompanyRate, transaction.thDailyRate);
        end;{if}
      end;
    end;{for}
  end;{with}
  Result := rTotal;
end;{GetReverseTotal}


end.
