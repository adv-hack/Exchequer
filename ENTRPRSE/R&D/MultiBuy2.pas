unit MultiBuy2;

interface

uses
  MultiBuyVar;

  function FormatMultiBuyDescription(ARec: TMultiBuyDiscount): String;

implementation

uses
  IIfFuncs, EtStrU, VArConst, BtSupU2, GlobVar, SysUtils;

function FormatMultiBuyDescription(ARec: TMultiBuyDiscount): String;
var
  BQDecs, RVDecs : Integer;
begin
  with ARec do
  begin
    BQDecs := Syss.NoQtyDec;
    RVDecs := IIF(mbdOwnerType = 'C', Integer(Syss.NoNetDec), Integer(Syss.NoCosDec));
    Case mbdDiscountType of
      mbtGetFree       : Result := Format('Buy %s Get %s Free', [Form_Real(mbdBuyQty,0,BQDecs), Form_Real(mbdRewardValue,0,BQDecs)]);
      mbtForAmount     : Result := Format('Buy %s For %s', [Form_Real(mbdBuyQty,0,BQDecs), TxLatePound(Trim(SyssCurr.Currencies[mbdCurrency].SSymb), True) +
                                                                                               Form_Real(mbdRewardValue,0,RVDecs)]);
      // MH 30/07/09: Modified percentage to display to 2dp instead of Qty Decs
      mbtGetPercentOff : Result := Format('Buy %s Get %s Off', [Form_Real(mbdBuyQty,0,BQDecs), Form_Real(100*mbdRewardValue,0,2) + '%' ]);
    end;
  end;
end;


end.
