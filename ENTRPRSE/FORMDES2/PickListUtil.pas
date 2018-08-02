unit PickListUtil;

interface

Uses GlobType;

// MH 07/11/06: Moved the Picking List filtering out to a separate function to avoid
// duplication now that I'm adding a new sortable version of the single picking list.
// MH 13/03/09: Extended to support Hidden BoM Lines
//
// Returns TRUE if we want the line, FALSE if we don't
//
Function FilterSinglePickingListLine (Const IncludeNewLines, ShowDescOnly, ShowAddDesc, ShowHiddenBoM : Boolean) : Boolean;

implementation

Uses GlobVar, VarConst, Comnu2;

// MH 07/11/06: Moved the Picking List filtering out to a separate function to avoid
// duplication now that I'm adding a new sortable version of the single picking list.
//
// Returns TRUE if we want the line, FALSE if we don't
//
Function FilterSinglePickingListLine (Const IncludeNewLines, ShowDescOnly, ShowAddDesc, ShowHiddenBoM : Boolean) : Boolean;
Begin // FilterSinglePickingListLine
  With Id Do
  Begin
    // Check the line is for the correct Picking List Run or is a new line (if that option is enabled)
    Result := (SOPLineNo=Inv.PickRunNo) Or (IncludeNewLines And (Id.SOPLineNo=0)) Or (ShowHiddenBoM And (Id.LineNo = -1));

    If Result Then
      // Hide Free Issue Stock on Works Orders
      Result := (IdDocHed <> WOR) Or (Not SSDUseLine);

    If Result Then
    Begin
      // Print it if there is a valid stock code
      Result := Is_FullStkCode(StockCode);

      // For non-stock line check whether to include description type stock
      If (Not Result) And ShowDescOnly Then
        Result := (KitLink = 0);

      // Check whether Additional Description Lines should be shown
      If (Not Result) And ShowAddDesc Then
      Begin
        If (Not ShowDescOnly) Then
          Result := (KitLink <> 0) And (KitLink <> Id.FolioRef)
        Else
          Result := (KitLink <> 0);
      End; // If (Not Result) And ShowAddDesc
    End; //  If Result
  End; // With Id
End; // FilterSinglePickingListLine


end.
