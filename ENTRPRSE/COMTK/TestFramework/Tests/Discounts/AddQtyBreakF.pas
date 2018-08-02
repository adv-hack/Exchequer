unit AddQtyBreakF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
    FList, FSplitList : TStringList;
    procedure AddQtyBreak;
    procedure AddQtyBreaks;
  public
    { Public declarations }
    procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

//Format of paramaters = AcCode, StockCode, Discount Type, Date From, Date To, Value
const
  I_STOCK_CODE = 0;
  I_TYPE = 1;
  I_DATE_FROM = 2;
  I_DATE_TO = 3;
  I_QTYFROM = 4;
  I_QTYTO = 5;
  I_VALUE = 6;
  I_BAND = 7;

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.AddQtyBreak;
var
  sStock : string;
  sDateFrom : string;
  sDateTo : string;

  dQtyFrom : Double;
  dQtyTo   : Double;
  dValue    : Double;

  eType : TDiscountType;
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
  sStock := FSplitList[I_STOCK_CODE];
  eType := GetDiscountType(FSplitList[I_TYPE]);
  sDateFrom := FSplitList[I_DATE_FROM];
  sDateTo := FSplitList[I_DATE_TO];
  dQtyFrom := StrToFloat(FSplitList[I_QTYFROM]);
  dQtyTo := StrToFloat(FSplitList[I_QTYTO]);
  dValue := StrToFloat(FSplitList[I_VALUE]);
  if (eType = DiscBandPrice) then
    sBand := FSplitList[I_BAND];

  with oToolkit.Stock as IStock2 do
  begin
    FResult := GetEqual(BuildCodeIndex(sStock));

    if FResult = 0 then
    begin
      with stQtyBreaks.Add as IQuantityBreak2 do
      begin
        qbQuantityFrom := dQtyFrom;
        qbQuantityTo := dQtyTo;
        qbUseEffectiveDates := True;
        qbDateEffectiveFrom := sDateFrom;
        qbDateEffectiveTo := sDateTo;
        qbType := eType;
        qbCurrency := 1;

        Case eType of
          DiscSpecialPrice : qbPrice := dValue;
          DiscBandPrice    : begin
                               qbDiscPercent := dValue;
                               qbPriceBand := sBand;
                             end;
          DiscMargin,
          DiscMarkup       : qbMarkupMarginPercent := dValue;
        end;

        if (eType = DiscBandPrice) then
          qbPriceBand := sBand;

        FResult := Save;
      end;
    end;
  end;
end;

procedure TfrmTestTemplate1.AddQtyBreaks;
var
  i : integer;
begin
  for i := 0 to FList.Count - 1 do
  if Trim(FList[0]) <> '' then
  begin
    FSplitList.Clear;
    FSplitList.CommaText := FList[i];
    if not (FSplitList.Count in [7, 8]) then
      FResult := -1
    else
      AddQtyBreak;

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
    AddQtyBreaks;
  Finally
    FSplitList.Free;
    FList.Free;
  End;
end;

end.
