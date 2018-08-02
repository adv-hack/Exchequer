unit DelQuote;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses SysUtils;

// Deletes the specified Quote from the system
Function EX_DELETEQUOTE (QuoteOurRef : PChar) : SmallInt; StdCall;


implementation

Uses GlobVar, VarConst, BtrvU2, BtSupU1, BtKeys1U, NoteSupU, InvCtSuU,
     DllErrU;


// Deletes the specified Quote from the system
//
//      0   AOK
//    100+  Btrieve Database Error deleting Quote
//  32765   Error locking Quote for deletion
//  32766   The specified Quote Reference is not a Sales or Purchase Quote
//  32767   Invalid Quote Reference
Function EX_DELETEQUOTE (QuoteOurRef : PChar) : SmallInt;
Var
  QuoteRef : String[10];
  KeyS     : Str255;
  lStatus  : SmallInt;
  Locked   : Boolean;
Begin { DeleteQuote }
  LastErDesc:='';
  Result := 0;

  QuoteRef := FullOurRefKey(UpperCase(Trim(StrPas(QuoteOurRef))));

  // Try to load the transaction
  KeyS := QuoteRef;
  LStatus := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, KeyS);
  If (LStatus = 0) Then Begin
    // Got Transaction - perform basic checks before deleting

    // Check 1: Is it a SQU or PQU
    If Not (Inv.InvDocHed In [SQU, PQU]) Then
      // The Quote Reference is not a Sales or Purchase Quote
      Result := 32766;

    // Other checks ???

    If (Result = 0) Then Begin
      // Lock and Delete Quote
      Locked := BOff;
      If GetMultiRec (B_GetDirect, B_SingLock, KeyS, InvOurRefK, InvF, SilentLock, Locked) And Locked Then Begin
        // Delete Quote Header
        lStatus := Delete_Rec (F[InvF], InvF, InvOurRefK);

        If (lStatus = 0) Then Begin
          // Delete Lines
          Delete_StockLinks(FullIdKey(Inv.FolioNum,StkLineNo),
                            IDetailF,
                            SizeOf(Inv.FolioNum),
                            IdFolioK,
                            BOn,
                            Inv,
                            0);

          // Delete Notes
          Delete_Notes (NoteDCode, FullNomKey (Inv.FolioNum));
        End { If (lStatus = 0) }
        Else
          Result := lStatus + 100;
      End { If GetMultiRec }
      Else
        // Error locking Quote for deletion
        Result := 32765;
    End; { If (Result = 0) }
  End { If (LStatus = 0) }
  Else
    // Transaction no found
    Result := 32767;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(154,Result);
end; { DeleteQuote }

end.
