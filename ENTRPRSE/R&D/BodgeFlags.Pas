Unit BodgeFlags;

Interface

// Calc_StockDeduct/Gen_StockDeduct Bodge Flags
Const
  // Default - no effect
  StkDedNoBodge = 0;

  // Modified calculation of QtyShort in Gen_StockDeduct when recreating the hidden BoM lines
  // during Deliver Picked Orders as it was incorrectly calculating the remainder as DeductQty
  // is already included within QtyDel.
  StkDedRecreateSORHiddenLines = 1;


Implementation

End.