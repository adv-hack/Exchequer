unit oSerialBatch;

interface

Uses Classes, Dialogs, Forms, SysUtils, GlobVar, VarConst, GlobType;

Type
  //
  TLineSerialBatchDetails = Class(TObject)
  Private
    FSerialMode : LongInt;
    FInv : InvRec;
    FId : IDetail;
    FStock : StockRec;

    FSerialLineStr : ShortString;
    FSerialLines : TStringList;

    Function GetSerialLineCount : LongInt;
    Function GetSerialLines(Index : LongInt) : ShortString;

    Procedure FindSerialBatch;
    Procedure StashSerialNo (Const SerialRec : SerialType);
  Public
    Constructor Create (Const SerialMode : LongInt; Const Transaction : InvRec; Const StockR : StockRec; const LineR : IDetail);
    Destructor Destroy; Override;

    Property SerialLineCount : LongInt Read GetSerialLineCount;
    Property SerialLines [Index : LongInt] : ShortString Read GetSerialLines;
  End; // TLineSerialBatchDetails


implementation

Uses BtrvU2, ETStrU, ETMiscU, ETDateU, BTSupU1, BTKeys1U, SysU2, SerialNo, DicLinkU;

//=========================================================================

Constructor TLineSerialBatchDetails.Create (Const SerialMode : LongInt; Const Transaction : InvRec; Const StockR : StockRec; const LineR : IDetail);
Begin // Create
  Inherited Create;

  FSerialLineStr := '';
  FSerialLines := TStringList.Create;

  FSerialMode := SerialMode;

  FStock := StockR;
  FId := LineR;
  FInv := Transaction;

  FindSerialBatch;
End; // Create

//------------------------------

Destructor TLineSerialBatchDetails.Destroy;
Begin // Destroy
  FreeAndNIL(FSerialLines);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TLineSerialBatchDetails.GetSerialLineCount : LongInt;
Begin // GetSerialLineCount
  Result := FSerialLines.Count;
End; // GetSerialLineCount

//------------------------------

Function TLineSerialBatchDetails.GetSerialLines(Index : LongInt) : ShortString;
Begin // GetSerialLines
  If (Index >= 0) And (Index <= FSerialLines.Count) Then
    Result := FSerialLines[Index]
  Else
    Raise Exception.Create ('TLineSerialBatchDetails.GetSerialLines: Invalid Index ' + IntToStr(Index));
End; // GetSerialLines

//-------------------------------------------------------------------------

Procedure TLineSerialBatchDetails.StashSerialNo (Const SerialRec : SerialType);
Var
  TmpStr : ShortString;
  Write2File : Boolean;
Begin // StashSerialNo
  // Serial/Batch Printing Modes:-
  //
  //   0   None
  //   1   Serial Numbers Only - 1 Per Line
  //   2   Batch Numbers Only - 1 Per Line
  //   3   Serial + Batch Numbers - 1 Per Line
  //   11  Serial Numbers Only - Multiple per Line
  //   12  Batch Numbers Only - Multiple per Line
  //   13  Serial + Batch Numbers - Multiple  Per Line
  TmpStr := '';
  Case FSerialMode Of
    1, 11  : TmpStr := Trim(SerialRec.SerialNo);
    2, 12  : TmpStr := Form_Real(SerialRec.QtyUsed, 0, Syss.NoQtyDec) + ' x ' + Strip('B', [#32], SerialRec.BatchNo);
    3, 13  : Begin
               TmpStr := Trim(SerialRec.SerialNo);

               If (Trim(SerialRec.BatchNo) <> '') Then
               Begin
                 If (TmpStr <> '') then
                   TmpStr := TmpStr + ',';
                 TmpStr := TmpStr + Form_Real(SerialRec.QtyUsed, 0, Syss.NoQtyDec) + ' x ' + Trim(SerialRec.BatchNo);
               End; // If (Trim(SerialRec.BatchNo) <> '')
             end;
  End; // Case FSerialMode

  // Append Bin information if required
  If SNoShowBins And (TmpStr <> '') Then
    TmpStr:=TmpStr + ',' + Trim(StringsRec.fsSVStrs[6]) + Trim(SerialRec.InBinCode);

  // Append Use By Date if required
  If SNoShowUseBy And (TmpStr <> '') Then
    TmpStr:=TmpStr + ','+ Trim(StringsRec.fsSVStrs[7]) + POutDateB(SerialRec.DateUseX);

  If (FSerialMode In [1..3]) Then
    // 1 per line
    FSerialLines.Add (TmpStr)
  Else
  Begin
    // Multiple per line

    // Measure to see if it will fit
    If SNDOSMode Then
      // DOS style PCC form - character width
      Write2File := (Length(StringsRec.fsSVStrs[4] + TmpStr + FSerialLineStr) > SNoFieldWidth)
    Else
      // Exchequer Form Definition MM width
      Write2File := (GetPixWidth (StringsRec.fsSVStrs[4] + TmpStr + FSerialLineStr + 'W') > SNoFieldWidth);

    If Write2File Then
    Begin
      // Too big - write existing string to list and start new string
      FSerialLines.Add (FSerialLineStr);
      FSerialLineStr := StringsRec.fsSVStrs[4] + TmpStr;
    End // If Write2File
    Else
    Begin
      If (FSerialLineStr <> '') And (TmpStr <> '') Then
        FSerialLineStr := FSerialLineStr + ',';
      FSerialLineStr := FSerialLineStr + StringsRec.fsSVStrs[4] + TmpStr;
    End; // Else
  End; // Else
End; // StashSerialNo

//-------------------------------------------------------------------------

Procedure TLineSerialBatchDetails.FindSerialBatch;
Var
  KeyChk, KeyS : Str255;
  LinkDoc  :  Str10;
  GotToStore, FoundOK, FoundAll : Boolean;
  lStatus, LinkLNo : LongInt;
  SerCount : Double;
Begin // FindSerialBatch
  // If generated from Order get the Order details
  If (FId.SOPLink <> 0) then
  Begin
    LinkDoc := SOP_GetSORNo(FId.SOPLink);
    LinkLNo := FId.SOPLineNo;
  End // If (FId.SOPLink <> 0)
  Else
  Begin
    LinkDoc := FInv.OurRef;
    LinkLNo := FId.ABSLineNo;
  End; // Else

  SerCount:=0;
  FoundAll := (SerCount >= Abs(FId.SerialQty));

  // Determine starting searchkey based on whether we want to include purchase serial numbers
  If SNFieldIncInp Or (Not (FId.IdDocHed In SalesSplit)) Then
    KeyChk := FullQDKey (MFIFOCode, MSERNSub, FullNomKey(FStock.StockFolio))
  Else
    KeyChk := FullQDKey (MFIFOCode, MSERNSub, FullNomKey(FStock.StockFolio)+#1);
  KeyS := KeyChk + NdxWeight;

  lStatus := Find_Rec(B_GetLessEq, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);
  While (lStatus = 0) And (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) And (Not FoundAll) Do
  Begin
    With MiscRecs^.SerialRec Do
    Begin
      Application.ProcessMessages;

      {$B+}
      { MH 04/06/97: Modified to include unsold input docs }
      { EL 16/08/1997 Modified to check for order lines, and own ref, in line with SOP changes }
      If SNFieldIncInp Or (Not (FId.IdDocHed In SalesSplit)) Then
        FoundOk := ((CheckKey (LinkDoc, OutDoc, Length(LinkDoc), BOff)) and (SoldLine = LinkLNo)) Or
                   ((CheckKey (FInv.OurRef, OutDoc, Length(FInv.OurRef), BOff)) and (SoldLine = FId.ABSLineNo)) Or
                   ((CheckKey (LinkDoc, OutOrdDoc, Length(LinkDoc), BOff)) and (OutOrdLine = LinkLNo) and (FId.IdDocHed In OrderSet)) Or
                   ((CheckKey (LinkDoc, InDoc, Length(LinkDoc), BOff)) and (BuyLine = LinkLNo) and (Not BatchChild)) or
                   ((CheckKey (FInv.OurRef, InDoc, Length(FInv.OurRef), BOff)) and (BuyLine = FId.ABSLineNo) and (Not BatchChild)) or
                   ((CheckKey (LinkDoc, InOrdDoc, Length(LinkDoc), BOff)) and (InOrdLine = LinkLNo) and (FId.IdDocHed In OrderSet) and (Not BatchChild))
      Else
        FoundOk := ((CheckKey (LinkDoc, OutDoc, Length(LinkDoc), BOff)) and (SoldLine = LinkLNo)) or
                   ((CheckKey (FInv.OurRef, OutDoc, Length(FInv.OurRef), BOff)) and (SoldLine = FId.ABSLineNo)) Or
                   ((CheckKey (LinkDoc, OutOrdDoc, Length(LinkDoc), BOff)) and (OutOrdLine = LinkLNo) and (FId.IdDocHed In OrderSet));
     {$B-}

      If FoundOk Then
      Begin
        // Add Serial/Batch/Bin into internal list
        StashSerialNo (MiscRecs^.SerialRec);

        // Update SerCount so we can drop out of the search as soon as possible
        If (Not BatchChild) Or (FId.IdDocHed In SalesSplit) Then
        Begin
          If BatchRec Then
          Begin
            If (BatchChild) Then
              SerCount:= SerCount + QtyUsed
            Else
              SerCount:= SerCount + BuyQty;
          end
          else
            SerCount := SerCount + 1.0;
        end;
      End; // If FoundOk
    End; // With MiscRecs^.SerialRec

    FoundAll := (SerCount >= Abs(FId.SerialQty));

    If (Not FoundAll) then
      lStatus := Find_Rec(B_GetPrev, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);
  End; // While (lStatus = 0) And (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) And (Not FoundAll)

  // Mop up any Serial/Batch not added to the list yet
  If (Trim(FSerialLineStr) <> '') Then
    FSerialLines.Add (FSerialLineStr);
End; // FindSerialBatch

//-------------------------------------------------------------------------


end.
