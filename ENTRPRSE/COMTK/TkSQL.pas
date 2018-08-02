unit TkSQL;

interface

uses
  BtrvU2, GlobVar, VarConst;

const
  F_TRANSNOTES = 30;
  F_FINANCIAL_MATCHING = 31;
  F_ACCOUNT_DISCOUNT = 32;
  F_LOCATION = 33;
  F_SERIALBATCH = 34;
  F_STOCK_LOCATION = 35;
  F_CUSTOMER_STOCK_ANAL = 36;

  REDIRECT_FILENAMES
      : Array[F_TRANSNOTES..F_CUSTOMER_STOCK_ANAL] of String[30] = ('TransactionNote.Dat',
                                                                    'FinancialMatching.Dat',
                                                                    'CustomerDiscount.Dat',
                                                                    'Location.Dat',
                                                                    'SerialBatch.Dat',
                                                                    'StockLocation.Dat',
                                                                    'CustomerStockAnalysis.Dat');


Type
  TSQLRedirect = Class
  private
    FWhereClaust: string;
  private
    FClientID  : Pointer;
    FFieldList : string;
    FFile      : FileVar;
    FFilename  : string;
    FWhereClause : string;
    FCacheID : Integer;
    FActive : Boolean;
    FFileNo : Integer;
  public
    function GetData(B_Func: Integer; iIndex : Integer; var sKeyString : Str255; pData: Pointer; DataLen : longint) : Integer;
    function Open : Integer;
    function Close : Integer;

    property ClientID : Pointer read FClientID write FClientID;
    property FieldList : string read FFieldList write FFieldList;
    property WhereClause : string read FWhereClaust write FWhereClause;
    property FileNo : Integer read FFileNo write FFileNo;
    property Active : Boolean read FActive;
  end;

function GetFieldsForToolkitObject(ObjectID : Integer) : string;
function TranslateToolkitProperty(ObjectID : Integer; const PropertyName : string; SubType : Char = ' ') : string;
function TranslateToolkitProperties(ObjectID : Integer; const PropertyNames : string; SubType : Char = ' ') : string;
function DefaultWhereClause(ObjectID : Integer; SubType : Char; const ParentKey : string) : string;

implementation

uses
  SQLFields, TKToSQLFields, oBtrieve, SysUtils, Classes, SQLStructuresU, SQLUtils, BtKeys1U;

function GetFieldsForToolkitObject(ObjectID : Integer) : string;
//Returns a comma-separated list of all the relevant fields for the Toolkit object passed in
begin
  Case ObjectID of
    tkoCustomer,
    tkoSupplier  : Result := GetAllCustSuppFields;
    tkoDocument  : Result := GetAllDocumentFields;
    tkoDetail    : Result := GetAllDetailsFields;
    tkoStock     : Result := GetAllStockFields;
    tkoNominal   : Result := GetAllNominalFields;
    tkoJob       : Result := GetAllJobHeadFields;

    tkoNotes     : Result := GetAllNotesTypeNAFields;
    tkoMatching  : Result := GetAllMatchPayTypeTPFields;
    tkoBOM       : Result := GetAllBillMatTypeFields;
    tkoCostCentre,
    tkoDepartment: Result := GetAllCostCtrTypeFields;
    tkoCustDisc,
    tkoSuppDisc  : Result := GetAllCustDiscTypeFields;
    tkoMLoc      : Result := GetAllMLocLocFields;
    tkoQtyBreak  : Result := GetAllQtyDiscTypeFields;
    tkoStockLocation
                 : Result := GetAllMStkLocFields;
    tkoSerialBatch
                 : Result := GetAllSerialTypeFields;
    tkoMultiBin  : Result := GetAllbrBinRecFields;
    tkoJobActual : Result := GetAllJobActualFields;
    tkoSalesRet,
    tkoPurchRet  : Result := GetAllJobRetenFields;
    tkoBankAccount
                 : Result := GetAllBACSDbRecFields;
    tkoBankStatHead
                 : Result := GetAllBnkRHRecFields;
    tkoBankStatLine
                 : Result := GetAllBnkRDRecFields;
    tkoAltStock  : Result := GetAllSdbStkRecFields;
    tkoEmployee  : Result := GetAllEmplRecFields;
    tkoLink      : Result := GetAllBtLetterLinkTypeFields;
    tkoJobAnalysis
                 : Result := GetAllJobAnalRecFields;
    tkoJobType   : Result := GetAllJobTypeRecFields;
    tkoStockSalesAnal,
    tkoCustSalesAnal
                 : Result := GetAllCuStkRecFields;
    //Not yet implemented
{    tkoSummaryJobBudget
                 : Result := GetAllJobBudgetFields;}

  end;
end;

function TranslateToolkitProperty(ObjectID : Integer; const PropertyName : string; SubType : Char = ' ') : string;
//Returns the SQL Column name equivalent to the Toolkit property name passed in
begin
  Case ObjectID of
    tkoCustomer,
    tkoSupplier  : Result := TranslateCustsuppField(PropertyName);
    tkoNominal   : Result := TranslateNominalField(PropertyName);
    tkoDocument  : Result := TranslateDocumentField(PropertyName);
    tkoDetail    : Result := TranslateDetailsField(PropertyName);
    tkoStock     : Result := TranslateStockField(PropertyName);
    tkoJob       : Result := TranslateJobheadField(PropertyName);

    tkoNotes     : if SubType = ' ' then
                      Result := TranslateNotesTypeNAField(PropertyName)
                   else
                     Result := TranslateNotesTypeNAFieldEx(PropertyName);
    tkoMatching  : Result := TranslateMatchPayTypeTPField(PropertyName);
    tkoCustDisc  : REsult := TranslateCustDiscTypeField(PropertyName);
    tkoMLoc      : Result := TranslateMLocLocField(PropertyName);
    tkoSerialBatch
                 : Result := TranslateSerialTypeField(PropertyName);
    tkoStockLocation
                 : Result := TranslateMStkLocField(PropertyName);
    tkoStockSalesAnal,
    tkoCustSalesAnal : Result := TranslateCuStkRecField(PropertyName);
  end;
  if Result = '' then
    raise Exception.Create('Unknown field name ' + QuotedStr(PropertyName));
end;

function TranslateToolkitProperties(ObjectID : Integer; const PropertyNames : string; SubType : Char = ' ') : string;
{Takes one or more toolkit property names separated by commas, and returns a comma-separated list of the equivalent
 SQL column names}
var
  i, j : integer;
  TempS, TempName : AnsiString;
begin
  Result := '';
  TempS := PropertyNames;
  repeat
     j := Pos(',', TempS);
     if j > 0 then
     begin
       Result := Result + TranslateToolkitProperty(ObjectID, Copy(TempS, 1, j - 1), SubType) + ',';
       Delete(TempS, 1, j);
     end
     else
     begin
       j := Length(TempS);
       if j > 0 then
       begin
         Result := Result + TranslateToolkitProperty(ObjectID, TempS, SubType);
         TempS := '';
       end;
     end;
  until TempS = '';
end;

function DefaultWhereClause(ObjectID : Integer; SubType : Char; const ParentKey : string) : string;
{Returns the default selection query for objects using variant files.
 SubType will normally be ' ', except where one object uses more than two variant types - eg Notes. In that
 case, the SetSQLCaching method will be overridden on the object to pass in the correct SubType. For objects which only use
 2 variant types we will _usually_ have a constant for each type - eg CostCentre & Department. For sub-objects we wil
 also use the ParentKey of the object when possible - eg the JobCode of a JobActual; this will normally be set in the
 create method of the object.}

begin
  Case ObjectID of
    tkoCustomer     : Result := 'acCustSupp = ''C''';
    tkoSupplier     : Result := 'acCustSupp = ''S''';
    tkoMLoc         : Result := '';
    tkoCustDisc,
    tkoSuppDisc     : Result := 'CustCode = ' + QuotedStr(ParentKey);
    tkoCostCentre   : Result := 'RecPFix = ''C'' AND SubType = ''C''';
    tkoStockLocation: if SubType = 'L' then
                        Result := 'lsLocCode = ' + QuotedStr(ParentKey)
                      else
                        Result := 'lsStkCode = ' + QuotedStr(ParentKey);

    tkoDepartment
                    : Result := 'RecPFix = ''C'' AND SubType = ''D''';
    tkoNotes        : if SubType <> '2' then
                        Result := 'RecPFix = ''N'' AND SubType = ' + QuotedStr(SubType) +
                                  ' AND NoteFolio = ' + IntToStr(UnfullNomKey(Copy(ParentKey, 3, 4)))
                      else
                        Result := 'NoteFolio = ' + IntToStr(UnfullNomKey(Copy(ParentKey, 3, 4)));
    tkoMatching     : if SubType <> 'P' then
                        Result := 'RecPFix = ''T'' AND SubType = ''' + SubType + '''' + ' AND DocRef = ' + QuotedStr(ParentKey)
                      else
                        Result := 'DocRef = ' + QuotedStr(ParentKey);

    tkoBOM          : Result := 'RecPFix = ''B'' AND SubType = ''M''';
    tkoUserProfile  : Result := 'RecPFix = ''P'' AND SubType = Char(0)'; //????
//    tkoSuppDisc     : Result := 'RecPFix = ''C'' AND SubType = ''S''';
    tkoSerialBatch  : Result :=  'StockFolio = ' + IntToStr(UnfullNomKey(Copy(ParentKey, 1, 4)));
    tkoMultiBin     : Result := 'RecPFix = ''I'' AND SubType = ''R''';
    tkoJobActual    : Result := 'RecPFix = ''J'' AND SubType = ''E'' AND JobCode = ''' + ParentKey + '''';
    tkoSalesRet     : Result := 'RecPFix = ''J'' AND SubType = ''R'' AND JobCode = ''' + ParentKey + ''' AND AccType = ''C''';
    tkoPurchRet     : Result := 'RecPFix = ''J'' AND SubType = ''R'' AND JobCode = ''' + ParentKey + ''' AND AccType = ''S''';
    tkoQtyBreak     : Result := 'RecPFix = ''T'' AND SubType = ''' + SubType + ''''; //TODO: Need to work out how to limit to AcCode or StkCode
    tkoBankAccount  : Result := 'RecPFix = ''K'' AND SubType = ''3''';
    tkoBankStatHead : Result := 'RecPFix = ''K'' AND SubType = ''4''';
    tkoBankStatLine : Result := 'RecPFix = ''K'' AND SubType = ''5''';
    tkoAltStock     : Result := 'RecPFix = ''N'' AND SubType = ''' + SubType + '''';
    tkoEmployee     : Result := 'RecPFix = ''J'' AND SubType = ''E''';
    tkoLink         : Result := 'RecPFix = ''L'' AND SubType = ''' + SubType + '''';
    tkoJobAnalysis  : Result := 'RecPFix = ''J'' AND SubType = ''A''';
    tkoJobType      : Result := 'RecPFix = ''J'' AND SubType = ''T''';
    tkoStockSalesAnal : Result := 'CsStockCode = ' + QuotedStr(ParentKey);
    tkoCustSalesAnal: Result := 'CsCustCode = ' + QuotedStr(ParentKey);
    else
      Result := '';
  end;
end;


{ TSQLRedirect }

function TSQLRedirect.Close: Integer;
begin
  if FActive then
    DropCustomPrefillCache(FCacheID, FClientId);
  Result := Close_FileCID(FFile, FClientID);
end;

function TSQLRedirect.GetData(B_Func: Integer; iIndex : Integer; var sKeyString : Str255; pData: Pointer; DataLen : longint): Integer;
begin
  UseCustomPrefillCache(FCacheID, FClientId);
  Result := Find_VarRec(B_Func, FFile, FFileNo, DataLen, pData^, iIndex , sKeystring, FClientId);
end;

function TSQLRedirect.Open: Integer;
begin
  Result := Open_FileCID(FFile,SetDrive + REDIRECT_FILENAMES[FFileNo], 0, FClientId);
  if Result = 0 then
  begin
    Result := CreateCustomPrefillCache(SetDrive + REDIRECT_FILENAMES[FFileNo], FWhereClause, FFieldList, FCacheID, FClientId);
  end;

  FActive := Result = 0;
end;

end.
