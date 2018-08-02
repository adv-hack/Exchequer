unit EBCustLine;
{
  Retrieves Customer/Supplier Balance Ledger, from Transaction Lines
}
interface

uses
  Classes, Dialogs, Forms, SysUtils, Windows,
  GlobVar,       // Exchequer global const/type/var
  VarConst,      // Exchequer global const/type/var
  BtrvU2,        // Btrieve Interface Routines & Constants
  Recon3U,       // Extended Btrieve Ops classes for reading data
  DrillConst;    // Types and constants used by the drill-down routines.

type
  { IMPORTANT: Turbo Pascal Object, not Object Pascal Class! }
  TExtBtrieveCustLines = object(ExtSNObj)
    constructor Init;
    destructor Done;

    procedure SetCurrencyFilter(
      var Term: FilterRepeatType;
      var Compare: Char;
      const Currency: Byte;
      const CompCode: TExtBtrCompareMode = cmpEqual;
      const LogicEx: TExtBtrLogicExpression = lexAND
    );

    procedure SetPeriodFilter(
      var Term: FilterRepeatType;
      var Compare: Char;
      const Period: Byte;
      const CompCode: TExtBtrCompareMode = cmpEqual;
      const LogicEx: TExtBtrLogicExpression = lexAND
    );

    procedure SetStockCodeFilter(
      var Term: FilterRepeatType;
      var Compare: TStockCodeKey;
      const StockCode: ShortString;
      const CompCode: TExtBtrCompareMode = cmpEqual;
      const LogicEx: TExtBtrLogicExpression = lexAND
    );

    procedure SetYearFilter(
      var Term: FilterRepeatType;
      var Compare: Char;
      const Year: Byte;
      const CompCode: TExtBtrCompareMode = cmpEqual;
      const LogicEx: TExtBtrLogicExpression = lexAND
    );
  end;

implementation

{ TExtBtrieveCustLines }

destructor TExtBtrieveCustLines.Done;
begin
  ExtSNObj.Done;
end;

constructor TExtBtrieveCustLines.Init;
begin
  ExtSNObj.Init;
end;

procedure TExtBtrieveCustLines.SetCurrencyFilter(
  var Term: FilterRepeatType; var Compare: Char; const Currency: Byte;
  const CompCode: TExtBtrCompareMode;
  const LogicEx: TExtBtrLogicExpression);
begin

end;

procedure TExtBtrieveCustLines.SetPeriodFilter(var Term: FilterRepeatType;
  var Compare: Char; const Period: Byte;
  const CompCode: TExtBtrCompareMode;
  const LogicEx: TExtBtrLogicExpression);
begin

end;

procedure TExtBtrieveCustLines.SetStockCodeFilter(
  var Term: FilterRepeatType; var Compare: TStockCodeKey;
  const StockCode: ShortString; const CompCode: TExtBtrCompareMode;
  const LogicEx: TExtBtrLogicExpression);
begin

end;

procedure TExtBtrieveCustLines.SetYearFilter(var Term: FilterRepeatType;
  var Compare: Char; const Year: Byte; const CompCode: TExtBtrCompareMode;
  const LogicEx: TExtBtrLogicExpression);
begin

end;

end.
 