unit DrillConst;
{
  Types and constants used by the drill-down routines
}
interface

uses FuncList;

type
  { Comparison modes -- these map to the codes used by the Extended Btrieve
    routines. }
  TExtBtrCompareMode = (
    cmpEqual              = 1,
    cmpGreaterthan        = 2,
    cmpLessThan           = 3,
    cmpNotEqual           = 4,
    cmpGreaterThanOrEqual = 5,
    cmpLessThanOrEqual    = 6
  );

  { Logical expression codes -- these map to the codes used by the Extended
    Btrieve routines. }
  TExtBtrLogicExpression = (
    lexLastTerm = 0,
    lexAND      = 1,
    lexOR       = 2
  );

  // Data filter modes
  { IMPORTANT: If more options are added to this list, the DetermineFilterMode
               methods in frmStockU.pas and JobActlF.pas will need to be
               amended, as they rely on an assumption about how many
               non-consolidated entries there are. }
  TDataFilterMode = (
    dfInvalid,
    dfThisPeriod,
    dfAllPeriods,
    dfToYear,
    dfToPeriod,
    dfThisYear,
    dfThisPeriodConsolidated,
    dfAllPeriodsConsolidated,
    dfToYearConsolidated,
    dfToPeriodConsolidated,
    dfThisYearConsolidated
  );

  TPostedStatus = (psAll, psPosted, psCommitted);

const
  { Characters to be returned by SetFilter for records which are to be
    excluded or included in the current list. This value has to be assigned to
    Filter[1, 1] for this filtering system to work. }
  EXCLUDE_FROM_DATASET: Char  = #255;
  INCLUDE_IN_DATASET: Char    = #1;

  FuncTitles: array[fcStkQtyOnOrder..fcSuppBalance] of string =
    (
      'Stock Quantity on Order',
      'Stock Quantity Sold',
      'Stock Quantity Allocated',
      'Stock Quantity OSSOR',
      'Stock Quantity in Stock',
      'Stock Quantity Picked',
      'Stock Quantity Used',
      'Works Order Stock Quantity Allocated',
      'Works Order Stock Quantity Issued',
      'Works Order Stock Quantity Picked',
      'Stock Quantity Allocated at Location',
      'Stock Quantity In Stock at Location',
      'Stock Quantity On Order at Location',
      'Stock Quantity OSSOR at Location',
      'Stock Quantity Picked at Location',
      'Stock Quantity Sold at Location',
      'Stock Quantity Used at Location',
      'Works Order Stock Quantity Allocated at Location',
      'Works Order Stock Quantity Issued at Location',
      'Works Order Stock Quantity Picked at Location',
      'Customer Stock Quantity',
      'Customer Stock Sales',
      'Customer Aged Balance',
      'Customer Balance',
      'Customer Committed',
      'Customer Net Sales',
      'Supplier Committed',
      'Supplier Aged Balance',
      'Supplier Balance'
    );

implementation

end.
