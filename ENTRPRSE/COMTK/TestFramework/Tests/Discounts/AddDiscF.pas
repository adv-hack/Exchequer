unit AddDiscF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
     FList, FSplitList : TStringList;
    procedure AddDiscount;
    procedure AddDiscounts;
  public
    { Public declarations }
    procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

//Format of paramaters = AcCode, StockCode, Discount Type, Date From, Date To, Value
const
  I_ACCODE = 0;
  I_STOCK_CODE = 1;
  I_TYPE = 2;
  I_DATE_FROM = 3;
  I_DATE_TO = 4;
  I_VALUE = 5;
  I_BAND = 6;

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.AddDiscount;
var
  oAc : IAccount2;
  oDisc : IAccountDiscount2;
  sAcCode : string;
  sStockCode : string;
  eType : TDiscountType;
  sDateFrom, sDateTo : string;
  dValue : Double;
  sBand : string;

  function GetDiscountType(const s : string) : TDiscountType;
  begin
    Result := DiscQtyBreak; //not valid in this test
    if Length(s) > 0 then
    begin
      Case s[1] of
        'P' : Result := DiscSpecialPrice;
        'B' : Result := DiscBandPrice;
        'M' : Result := DiscMargin;
        'U' : Result := DiscMarkup;
      end;
    end;
  end;

begin
  sAcCode := FSplitList[I_ACCODE];
  sStockCode := FSplitList[I_STOCK_CODE];
  eType := GetDiscountType(FSplitList[I_TYPE]);
  sDateFrom := FSplitList[I_DATE_FROM];
  sDateTo := FSplitList[I_DATE_TO];
  dValue := StrToFloat(FSplitList[I_VALUE]);
  if (eType = DiscBandPrice) then
    sBand := FSplitList[I_BAND];

  if eType = DiscQtyBreak then
  begin
    FResult := -1;
    raise Exception.Create('Invalid Discount Type: ' + QuotedStr(FSplitList[I_TYPE]));
  end;

  with oToolkit.Customer do
  begin
    FResult := GetEqual(BuildCodeIndex(sAcCode));

    if FResult = 0 then
    begin
      oDisc := acDiscounts.Add as IAccountDiscount2;

      oDisc.adStockCode := sStockCode;
      oDisc.adCurrency := 1;
      oDisc.adType := eType;

      Case eType of
        DiscSpecialPrice : oDisc.adPrice := dValue;
        DiscBandPrice    : begin
                             oDisc.adDiscPercent := dValue;
                             oDisc.adPriceBand := sBand;
                           end;
        DiscMargin,
        DiscMarkup       : oDisc.adMarkupMarginPercent := dValue;
      end;

      if (Trim(sDateFrom) <> '') and (Trim(sDateTo) <> '') then
      begin
        oDisc.adUseEffectiveDates := True;
        oDisc.adDateEffectiveFrom := sDateFrom;
        oDisc.adDateEffectiveTo := sDateTo;
      end;

      FResult := oDisc.Save;
    end;
  end;
end;

procedure TfrmTestTemplate1.AddDiscounts;
var
  i : integer;
begin
  for i := 0 to FList.Count - 1 do
  if Trim(FList[0]) <> '' then
  begin
    FSplitList.Clear;
    FSplitList.CommaText := FList[i];
    if not (FSplitList.Count in [6, 7]) then
      FResult := -1
    else
      AddDiscount;

    if FResult <> 0 then
      Break;
  end;
end;

procedure TfrmTestTemplate1.RunTest;
begin
  FList := TStringList.Create;
  FSplitList := TStringList.Create;
  Try
    FList.LoadFromFile(FExtraParam);
    AddDiscounts;
  Finally
    FSplitList.Free;
    FList.Free;
  End;
end;

end.
