unit ElEvDefs;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

const
  MaxEvents = 62;
  EBase = 100000;

  AccWindow = Ebase + 1000;
  TransWindow = Ebase + 2000;
  StockWindow = Ebase + 3000;
  JobWindow = Ebase + 5000;

type
  TElEventRec = Record
    evDescription  : String[52];
    evWinId        : LongInt;
    evHandID       : LongInt;
  end;

  procedure SetEvents;

var
  Events  :  Array[1..MaxEvents] of TElEventRec = (
  (evDescription: 'After store account'; evWinID: AccWindow; evHandID: 3),
  (evDescription: 'After account delete'; evWinID: AccWindow; evHandID: 4),
  (evDescription: 'Customer List - Custom Button 1'; evWinID: AccWindow; evHandID: 11),
  (evDescription: 'Customer List - Custom Button 2'; evWinID: AccWindow; evHandID: 12),
  (evDescription: 'Supplier List - Custom Button 1'; evWinID: AccWindow; evHandID: 21),
  (evDescription: 'Supplier List - Custom Button 2'; evWinID: AccWindow; evHandID: 22),
  (evDescription: 'After store transaction'; evWinID: TransWindow; evHandID: 170), //can't use until I know the HandlerID
  (evDescription: 'Purchase Daybook (Main) - Custom Button 1'; evWinID: TransWindow; evHandID: 110),
  (evDescription: 'Purchase Daybook (Main) - Custom Button 2'; evWinID: TransWindow; evHandID: 120),
  (evDescription: 'Purchase Daybook (Quotes) - Custom Button 1'; evWinID: TransWindow; evHandID: 111),
  (evDescription: 'Purchase Daybook (Quotes) - Custom Button 2'; evWinID: TransWindow; evHandID: 121),
  (evDescription: 'Purchase Daybook (Auto) - Custom Button 1'; evWinID: TransWindow; evHandID: 112),
  (evDescription: 'Purchase Daybook (Auto) - Custom Button 2'; evWinID: TransWindow; evHandID: 122),
  (evDescription: 'Purchase Daybook (History) - Custom Button 1'; evWinID: TransWindow; evHandID: 113),
  (evDescription: 'Purchase Daybook (History) - Custom Button 2'; evWinID: TransWindow; evHandID: 123),
  (evDescription: 'Purchase Daybook (Orders) - Custom Button 1'; evWinID: TransWindow; evHandID: 114),
  (evDescription: 'Purchase Daybook (Orders) - Custom Button 2'; evWinID: TransWindow; evHandID: 124),
  (evDescription: 'Purchase Daybook (Orders History) - Custom Button 1'; evWinID: TransWindow; evHandID: 115),
  (evDescription: 'Purchase Daybook (Orders History) - Custom Button 2'; evWinID: TransWindow; evHandID: 125),
  (evDescription: 'Sales Daybook (Main) - Custom Button 1'; evWinID: TransWindow; evHandID: 10),
  (evDescription: 'Sales Daybook (Main) - Custom Button 2'; evWinID: TransWindow; evHandID: 20),
  (evDescription: 'Sales Daybook (Quotes) - Custom Button 1'; evWinID: TransWindow; evHandID: 11),
  (evDescription: 'Sales Daybook (Quotes) - Custom Button 2'; evWinID: TransWindow; evHandID: 21),
  (evDescription: 'Sales Daybook (Auto) - Custom Button 1'; evWinID: TransWindow; evHandID: 12),
  (evDescription: 'Sales Daybook (Auto) - Custom Button 2'; evWinID: TransWindow; evHandID: 22),
  (evDescription: 'Sales Daybook (History) - Custom Button 1'; evWinID: TransWindow; evHandID: 13),
  (evDescription: 'Sales Daybook (History) - Custom Button 2'; evWinID: TransWindow; evHandID: 23),
  (evDescription: 'Sales Daybook (Orders) - Custom Button 1'; evWinID: TransWindow; evHandID: 14),
  (evDescription: 'Sales Daybook (Orders) - Custom Button 2'; evWinID: TransWindow; evHandID: 24),
  (evDescription: 'After Convert Quote'; evWinID: TransWindow; evHandID: 85),
  (evDescription: 'Before Copy Transaction'; evWinID: TransWindow; evHandID: 87),
  (evDescription: 'Before Reverse Transaction'; evWinID: TransWindow; evHandID: 88),
  (evDescription: 'Sales Daybook (Orders History) - Custom Button 1'; evWinID: TransWindow; evHandID: 15),
  (evDescription: 'Sales Daybook (Orders History) - Custom Button 2'; evWinID: TransWindow; evHandID: 25),
  (evDescription: 'After quote conversion'; evWinID: TransWindow; evHandID: 85),
  (evDescription:'Before Store Stock Record';evWinID : StockWindow; evHandID: 2),
  (evDescription:'Stock List (Stock) - Custom Button 1'; evWinID: StockWindow; evHandID: 10),
  (evDescription:'Stock List (Stock) - Custom Button 2'; evWinID: StockWindow; evHandID: 20),
  (evDescription:'Stock List (Reorder) - Custom Button 1'; evWinID: StockWindow; evHandID: 11),
  (evDescription:'Stock List (Reorder) - Custom Button 2'; evWinID: StockWindow; evHandID: 21),
  (evDescription:'Stock List (Stock Take) - Custom Button 1'; evWinID: StockWindow; evHandID: 12),
  (evDescription:'Stock List (Stock Take) - Custom Button 2'; evWinID: StockWindow; evHandID: 22),
  (evDescription:'Stock Record (Main) - Custom Button 1'; evWinID: StockWindow; evHandID: 80),
  (evDescription:'Stock Record (Main) - Custom Button 2'; evWinID: StockWindow; evHandID: 90),
  (evDescription:'Stock Record (Defaults) - Custom Button 1'; evWinID: StockWindow; evHandID: 81),
  (evDescription:'Stock Record (Defaults) - Custom Button 2'; evWinID: StockWindow; evHandID: 91),
  (evDescription:'Stock Record (Quantity Breaks) - Custom Button 1'; evWinID: StockWindow; evHandID: 83),
  (evDescription:'Stock Record (Quantity Breaks) - Custom Button 2'; evWinID: StockWindow; evHandID: 93),
  (evDescription:'Stock Record (Ledger) - Custom Button 1'; evWinID: StockWindow; evHandID: 84),
  (evDescription:'Stock Record (Ledger) - Custom Button 2'; evWinID: StockWindow; evHandID: 94),
  (evDescription:'Stock Record (Value) - Custom Button 1'; evWinID: StockWindow; evHandID: 85),
  (evDescription:'Stock Record (Value) - Custom Button 2'; evWinID: StockWindow; evHandID: 95),
  (evDescription:'Stock Record (Build) - Custom Button 1'; evWinID: StockWindow; evHandID: 86),
  (evDescription:'Stock Record (Build) - Custom Button 2'; evWinID: StockWindow; evHandID: 96),
  (evDescription:'Stock Record (Serial/Batch) - Custom Button 1'; evWinID: StockWindow; evHandID: 87),
  (evDescription:'Stock Record (Serial/Batch) - Custom Button 2'; evWinID: StockWindow; evHandID: 97),
  (evDescription:'Completion of Job costing wizard'; evWinID: JobWindow; evHandID: 70),
  (evDescription:'Job Detail - Custom Button 1'; evWinID: JobWindow; evHandID: 10),
  (evDescription:'Job Detail - Custom Button 2'; evWinID: JobWindow; evHandID: 12),
  (evDescription:'Job Ledger - Custom Button 1'; evWinID: JobWindow; evHandID: 20),
  (evDescription:'Job Ledger - Custom Button 2'; evWinID: JobWindow; evHandID: 22),
  (evDescription:'After Store Job Budget'; evWinID: JobWindow; evHandID: 76)
  );



implementation

procedure SetEvents;
var
  i : integer;
begin
{  with Events[1] do
  begin
    evDescription := 'After store account';
    evWinID := Ebase + 1000;
    evHandID := 3;
  end;

  with Events[2] do
  begin
    evDescription := 'After account delete';
    evWinID := Ebase + 1000;
    evHandID := 4;
  end;

  with Events[3] do
  begin
    evDescription := 'Before transaction save';
    evWinID := Ebase + 2000;
    evHandID := 1;
  end;

  with Events[4] do
  begin
    evDescription := 'Before store stock';
    evWinID := Ebase + 3000;
    evHandID := 2;
  end;
 }

end;

Initialization
 // SetEvents;

end.
