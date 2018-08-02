unit dllbin;
{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{* For Multi-Bin functions *}

{F+}

Interface

Uses
  GlobVar,
  {$IFDEF WIN32}
  VarRec2U,
  {$ELSE}
    VRec2U,
  {$ENDIF}
  VarConst,
  VarCnst3;

FUNCTION EX_GETMULTIBIN(P            :  POINTER;
                        PSIZE        :  LONGINT;
                        SEARCHPATH   :  SMALLINT;
                        SEARCHMODE   :  SMALLINT;
                        LOCK         :  WORDBOOL)  :  SMALLINT;
                       {$IFDEF WIN32} STDCALL; {$ENDIF}
                        EXPORT;


FUNCTION EX_STOREMULTIBIN(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHPATH   :  SMALLINT;
                          SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL; {$ENDIF}
                          EXPORT;


FUNCTION EX_USEMULTIBIN(P            :  POINTER;
                        PSIZE        :  LONGINT)  :  SMALLINT;
                       {$IFDEF WIN32} STDCALL; {$ENDIF}
                        EXPORT;

FUNCTION EX_UNUSEMULTIBIN(P            :  POINTER;
                          PSIZE        :  LONGINT)  :  SMALLINT;
                         {$IFDEF WIN32} STDCALL; {$ENDIF}
                          EXPORT;


{$IFDEF COMTK}
procedure DoCopyEntBinToTkBin(const EntBin : brBinRecType; var TkBin : TBatchBinRec);
{$ENDIF}


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
Implementation
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
{$IFDEF WIN32}
  BtrvU2,
  BTSupU1,
  SysU2,
  ComnU2,
  CurrncyU,
  BtKeys1U,
{$ELSE}
  BtrvU16,
  BTSup1,
  BTSup2,
{$ENDIF}
  BTS1,
  DLLErrU,
  Dialogs,
  SysUtils,
  DLSQLSup;

function CopyTKBinToEntBin(TkBin : TBatchBinRec; Adding : Boolean; ChildRec : Boolean = False) : integer;
begin
  Result := 0;
  with MLocCtrl^ do
  begin
    RecPfix := BRRecCode;
    SubType := MSernSub;
     brBinRec.brBinCode1 := FullBinCode(TkBin.brBinCode);
     brBinRec.brCode3 := FullBinCode3(TkBin.brStockFolio, TkBin.brInLocation, TkBin.brBinCode);

     //PR: 26/01/2012 ABSEXCH-12430 If we're updating the Bin record then we don't want to overwrite the In Document
     if Adding then
     begin
       brBinRec.brInDoc := TkBin.brInDocRef;
       brBinRec.brBuyLine := TkBin.brInDocLine;

       brBinRec.brDateIn := TkBin.brInDate;
       brBinRec.brInMLoc := Full_MLocKey(TkBin.brInLocation);
     end;

     brBinRec.brOutDoc := TkBin.brOutDocRef;

     brBinRec.brSold := WordBoolToBool(TkBin.brSold);

     brBinRec.brBinCost := TkBin.brCostPrice;
     brBinRec.brBinCap := TkBin.brCapacity;
     brBinRec.brStkFolio := TkBin.brStockFolio;
     brBinRec.brDateOut := TkBin.brOutDate;
     brBinRec.brSoldLine := TkBin.brOutDocLine;
     brBinRec.brBuyQty := Round_Up(TkBin.brQty, Syss.NoQtyDec);

     //PR: 30/11/2011 If the in doc and out doc are the same then we have a job code on the line, so set used qty.
     //PR: 23/01/2013 ABSEXCH-13464 Extend check to ensure that if in and out doc are the same it's not because they are blank
     if (TkBin.brOutDocRef = TkBin.brInDocRef) and (Trim(TkBin.brOutDocRef) <> '') then
       brBinRec.brQtyUsed := brBinRec.brBuyQty
     else
       brBinRec.brQtyUsed := Round_Up(TkBin.brQtyUsed, Syss.NoQtyDec);

     brBinRec.brBatchRec := not ChildRec;
     brBinRec.brBatchChild := {WordBoolToBool(TkBin.brUsedRec)}ChildRec;
     brBinRec.brSold := ChildRec or (brBinRec.brBuyQty - brBinRec.brQtyUsed = 0);
     brBinRec.brCode2 := FullBinCode2(TkBin.brStockFolio, brBinRec.brSold, TkBin.brInLocation, TkBin.brPickingPriority,
                                       TKBin.brInDate, TkBin.brBinCode);
     brBinRec.brOutMLoc := Full_MLocKey(TkBin.brOutLocation);
     brBinRec.brOutOrdDoc := TkBin.brOutOrderRef;
     brBinRec.brInOrdDoc := TkBin.brInOrderRef;
     brBinRec.brInOrdLine := TkBin.brInOrderLine;
     brBinRec.brOutOrdLine := TkBin.brOutOrderLine;
     brBinRec.brCurCost := TkBin.brCostPriceCurrency;
     brBinRec.brPriority := TkBin.brPickingPriority;
     brBinRec.brBinSell := TkBin.brSalesPrice;
     brBinRec.brSerCRates[False] := TkBin.brCompanyRate;
     brBinRec.brSerCRates[True] := TkBin.brDailyRate;

     {$IFNDEF COMTK}
     brBinRec.brSUseORate := TkBin.brUseORate;
     {$ELSE}
     if TkBin.brUseORate then
       brBinRec.brSUseORate := 1
     else
       brBinRec.brSUseORate := 0;
    {$ENDIF}

     brBinRec.brSerTriR.TriRates := TkBin.brTriRates;
     brBinRec.brSerTriR.TriEuro := TkBin.brTriEuro;
     brBinRec.brSerTriR.TriInvert := WordBoolToBool(TkBin.brTriInvert);
     brBinRec.brSerTriR.TriFloat := WordBoolToBool(TkBin.brTriFloat);
     brBinRec.brDateUseX := TkBin.brUseByDate;
     brBinRec.brCurSell := TkBin.brSalesPriceCurrency;
     brBinRec.brUOM := TkBin.brUnitOfMeasurement;
     brBinRec.brHoldFlg := TkBin.brAutoPickMode;
     brBinRec.brTagNo := TkBin.brTagNo;

     {$IFDEF COMTK}
      brBinRec.brReturnBin := TkBin.brReturned;
     {$ENDIF}
  end;
end;


procedure DoCopyEntBinToTkBin(const EntBin : brBinRecType; var TkBin : TBatchBinRec);
begin
  TkBin.brBinCode := EntBin.brBinCode1;
  TkBin.brInDocRef := EntBin.brInDoc;
  TkBin.brOutDocRef := EntBin.brOutDoc;
  TkBin.brSold := BoolToWordBool(EntBin.brSold);
  TkBin.brInDate := EntBin.brDateIn;
  TkBin.brCostPrice := EntBin.brBinCost;
  TkBin.brCapacity := EntBin.brBinCap;
  TkBin.brStockFolio := EntBin.brStkFolio;
  TkBin.brOutDate := EntBin.brDateOut;
  TkBin.brOutDocLine := EntBin.brSoldLine;
  TkBin.brInDocLine := EntBin.brBuyLine;
  TkBin.brQty := EntBin.brBuyQty;
  TkBin.brQtyUsed := EntBin.brQtyUsed;
  TkBin.brUsedRec := BooltoWordBool(EntBin.brBatchChild);
  TkBin.brInLocation := EntBin.brInMLoc;
  TkBin.brOutLocation := EntBin.brOutMLoc;
  TkBin.brOutOrderRef := EntBin.brOutOrdDoc;
  TkBin.brInOrderRef := EntBin.brInOrdDoc;
  TkBin.brInOrderLine := EntBin.brInOrdLine;
  TkBin.brOutOrderLine := EntBin.brOutOrdLine;
  TkBin.brCostPriceCurrency := EntBin.brCurCost;
  TkBin.brPickingPriority := EntBin.brPriority;
  TkBin.brSalesPrice := EntBin.brBinSell;
  TkBin.brCompanyRate := EntBin.brSerCRates[False];
  TkBin.brDailyRate := EntBin.brSerCRates[True];

  {$IFNDEF COMTK}
  TkBin.brUseORate := EntBin.brSUseORate;
  {$ELSE}
  TkBin.brUseORate := EntBin.brSUseORate <> 0;
  {$ENDIF}

  TkBin.brTriRates := EntBin.brSerTriR.TriRates;
  TkBin.brTriEuro := EntBin.brSerTriR.TriEuro;
  TkBin.brTriInvert := BoolToWordBool(EntBin.brSerTriR.TriInvert);
  TkBin.brTriFloat := BoolToWordBool(EntBin.brSerTriR.TriFloat);
  TkBin.brUseByDate := EntBin.brDateUseX;
  TkBin.brSalesPriceCurrency := EntBin.brCurSell;
  TkBin.brUnitOfMeasurement := EntBin.brUOM;
  TkBin.brAutoPickMode := EntBin.brHoldFlg;
  TkBin.brTagNo := EntBin.brTagNo;

  {$IFNDEF COMTK}
  If (GetPos(F[MLocF], MLocF, TkBin.brRecPos) <> 0) Then
      TkBin.brRecPos := 0;
  {$ENDIF}

  {$IFDEF COMTK}
  TkBin.brReturned := EntBin.brReturnBin;
  {$ENDIF}

end;

procedure CopyEntBinToTkBin(var TkBin : TBatchBinRec);
begin
  DoCopyEntBinToTkBin(MLocCtrl^.brBinRec, TkBin);
end;


function GetBinRec(TkBin : TBatchBinRec; KeyPath : integer; BFunc : integer; Lock : WordBool) : integer;
var
  KeyS : Str255;
  Locked : Boolean;

begin

  if BFunc in [B_GetFirst, B_StepFirst, B_GetLast, B_StepLast] then
    KeyS := ''
  else
    with TkBin do
      Case KeyPath of
        0  :  KeyS := FullBinCode(brBinCode);
        1  :  KeyS := FullBinCode2(brStockFolio, WordBoolToBool(brSold), brInLocation, brPickingPriority,  brInDate, brBinCode);
        2  :  KeyS := FullBinCode3(brStockFolio, brInLocation, brBinCode);
      end;

  Case BFunc of
    B_GetFirst, B_StepFirst : BFunc := B_GetGEq;
    B_StepNext              : BFunc := B_GetNext;
    B_StepPrev              : BFunc := B_GetPrev;
    B_GetLast, B_StepLast   : BFunc := B_GetLessEq;
  end;


  KeyS := BRRecCode + MSernSub + KeyS;

  KeyS := SetKeyString(BFunc, MLocF, KeyS);

  UseVariant(F[MLocF]);
  Result := Find_Rec(BFunc, F[MLocF], MLocF, RecPtr[MLocF]^, KeyPath, KeyS);

  if Result = 0 then
    if (MLocCtrl^.RecPfix <> BRRecCode) or (MLocCtrl^.SubType <> MSernSub) then
      Result := 9;

  If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
  begin
    Locked := False;
    UseVariant(F[MLocF]);
    If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyPath,MLocF,SilentLock,Locked)) then
      Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
  end;
end;

function UpdateID(const OurRef    : string;
                        LineNo    : longint;
                        AddBinQty : Double) : integer;
//Update the transaction line quantity when using or unusing bin
var
  KeyS : Str255;
  Res : integer;
  WantQty : Double;
begin
  Result := 30026;
  KeyS:=LjVar(OurRef,DocLen);
  if CheckRecExsists(KeyS,InvF,InvOurRefK) then
  begin

    KeyS:=FullIDKey(Inv.FolioNum,LineNo);
    Res := Find_Rec(B_GetEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdLinkK, KeyS);

    if Res = 0 then
    begin
      AddBinQty := Round_Up(AddBinQty, Syss.NoQtyDec);
      Case Inv.InvDocHed of
        SIN, SCR, PIN, PCR, ADJ  : WantQty := Id.Qty;
        SOR, POR, WOR            : WantQty := Id.QtyPick + Id.QtyDel;
        else
          WantQty := Id.Qty;
      end; //case

      if Id.BinQty + AddBinQty <= WantQty then
        Id.BinQty := Id.BinQty + AddBinQty
      else
        Id.BinQty := WantQty;

      Res := Put_Rec(F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdLinkK);

      if Res = 0 then
        Result := 0;
    end;
  end;
end;

function ValidateDate(const D : string; ErrCode : integer) : integer;
var
  Td, Tm, Ty : Word;
  dt : TDateTime;
begin
  Result := 0;
  if d <> '' then
  begin
    DateStr(D,Td,Tm,Ty);
    if not TryEncodeDate(Ty, Tm, Td, dt) then
      Result := ErrCode;
  end;
end;

Type
  TDocTypeSet = set of DocTypes;

function ValidateDoc(const OurRef : string;
                          OkTypes : TDocTypeSet;
                          LineNo  : Longint;
                    var   Curr    : SmallInt;
                    const Loc     : string;
                          ErrDocRef, ErrDocType, ErrLine, ErrCurr, ErrLoc, ErrStock : integer) : integer;
var
  KeyS : Str255;
  ValidCheck : Boolean;
  Res : integer;
begin
  Result := 0;
  if Trim(OurRef) <> '' then
  begin
    KeyS:=Copy(OurRef,1,3);
    if not (DocTypeFCode(KeyS) In OkTypes) then
      Result := ErrDocType;

    if Result = 0 then
    begin
      KeyS:=LjVar(OurRef,DocLen);
      if not CheckRecExsists(KeyS,InvF,InvOurRefK) then
        Result := ErrDocRef;
    end;
  end;

  if (Result = 0) and (((Trim(OurRef) <> '') and Syss.UseMLoc) or (Trim(Loc) <> '')) then
  begin
    if not CheckRecExsists(MLocFixCode[True]+LJVar(Loc,LocKeyLen),MLocF,MLK) then
      Result := ErrLoc;
  end;

  if (Result = 0) and ((Trim(OurRef) <> '') or (LineNo <> 0)) then
  begin
    KeyS:=FullIDKey(Inv.FolioNum,LineNo);
    if not CheckRecExsists(KeyS,IDetailF,IdLinkK) then
      Result := ErrLine
    else
      if Trim(ID.StockCode) <> Trim(Stock.StockCode) then
        Result := ErrStock;
  end;

  if (Result = 0) and (ExSyss.MCMode)then
  begin
    ValidCheck:=((Curr>=1) and (Curr <=CurrencyType));

    If (Not ValidCheck) then
    begin
      Curr:=ExSyss.DefCur;
      ValidCheck:=((Curr>=1) and (Curr<=CurrencyType));
    end;

    if not ValidCheck then
      Result := ErrCurr;
  end;

end;

function StoreBinRec(BFunc, KPath : integer ) : integer;
begin

  if BFunc = B_Insert then
    Result := Add_Rec(F[MLocF], MLocF, RecPtr[MLocF]^, KPath)
  else
    Result := Put_Rec(F[MLocF], MLocF, RecPtr[MLocF]^, KPath);

  if Result <> 0 then
    Result := Result + 30100;
end;


function ValidateBinRec(var TkBin : TBatchBinRec; KeyPath : integer; BFunc : integer) : integer;
var
  KeyS : Str255;
  Found : Boolean;
  Res : integer;
  DummyCurr : SmallInt;
  UseRec, UnUse : Boolean;
  TempRec : MLocRec;

  OutDocSet : Set of DocTypes;
begin
  Result := 0;
  Found := False;

  UseRec := WordBoolToBool(TkBin.brUsedRec);
  UnUse  := TkBin.brQtyUsed < 0;

//Validate autopick mode
  if not UseRec and not (TkBin.brAutoPickMode in [0..3]) then
    Result := 30024;

  if not UseRec then
  begin
    if TkBin.brCompanyRate = 0 then
      Result := 30027
    else
    if TkBin.brDailyRate = 0 then
      Result := 30028;
  end;

//Only allow header recs to be updated
  if (BFunc = B_Update) and UseRec then
    Result := 300023;

//Check bincode not blank
  if Trim(TkBin.brBinCode) = '' then
    Result := 30000;

//Check valid stockfolio
  if Result = 0 then
  begin
    KeyS := FullNomKey(TkBin.brStockFolio);
    while (Length(KeyS) > 1) and (KeyS[Length(KeyS)] = #0) do Delete(KeyS, Length(KeyS), 1);
    if (not CheckRecExsists(KeyS, StockF, StkFolioK)) then
      Result := 30001;
  end;

//BinCode - can have duplicates but not for the same stockfolio & Location
  if (Result = 0) then
  begin
    KeyS := BRRecCode + MSernSub + FullBinCode(TkBin.brBinCode);

    Res := Find_Rec(B_GetGEq, F[MLocF], MLocF, RecPtr[MLocF]^, 0, KeyS);
    Found := False;

    while (Res = 0) and (Trim(Copy(MLocCtrl^.brBinRec.brBinCode1, 1, BinKeyLen)) = UpperCase(Trim(TkBin.brBinCode))) and not Found do
    begin
      Found := (MLocCtrl^.brBinRec.brStkFolio = TkBin.brStockFolio) and
                    (Trim(MLocCtrl^.brBinRec.brInMLoc) = Trim(TkBin.brInLocation));

      //Can only update headers so make sure we have one
      //PR: 23/06/2014 ABSEXCH-14183 Also when inserting, check that it's not a batch child, as
      //                             we only want to stop the insert if we have an existing header.
      {if (BFunc = B_Update) or UseRec then}
        Found := Found and not (MLocCtrl^.brBinRec.brBatchChild);

      if not Found then
        Res := Find_Rec(B_GetNext, F[MLocF], MLocF, RecPtr[MLocF]^, 0, KeyS);

    end;

    if Found and (BFunc = B_Insert) then
    begin
      if UseRec then
        Result := 0
      else
        Result := 5;
    end
    else
    if not Found and (BFunc = B_Update) then
      Result := 4;
  end;

  //Store multibin record, as ValidateDoc function finds location records in the same file
  TempRec := MLocCtrl^;

  if UseRec then
    if Trim(TkBin.brInLocation) = '' then
        TkBin.brInLocation := MLocCtrl^.brBinRec.brInMLoc;

//Docs - must be blank or valid
  if Result = 0 then
    Result := ValidateDoc(TkBin.brInDocRef, PurchSplit+[SCR, SJC, ADJ, WOR], TkBin.brInDocLine, TkBin.brCostPriceCurrency,
                TkBin.brInLocation, 30002, 30003, 30004, 30005, 30006, 30019);

  if (Result = 0) and UseRec and (Trim(TkBin.brOutDocRef) = '') then
    Result := 30007;

  if Result = 0 then //PR: 17/11/2011 Allow PCR, PJC & PRF to use bins ABSEXCH-12139/12152
  begin
    OutDocSet := SalesSplit + StkAdjSplit + [WOR, PCR, PJC, PRF];
    if TkBin.brOutDocRef = TkBin.brInDocRef then
      OutDocSet := OutDocSet + [POR, PIN, PJI];
    Result := ValidateDoc(TkBin.brOutDocRef, OutDocSet, TkBin.brOutDocLine, TkBin.brSalesPriceCurrency,
                TkBin.brOutLocation, 30007, 30008, 30009, 30010, 30011, 30020);
  end;

//Dates - must be blank or valid date
  if Result = 0 then
  begin
    Result := ValidateDate(TkBin.brUseByDate, 30014);
    Result := ValidateDate(TkBin.brOutDate, 30013);
    Result := ValidateDate(TkBin.brInDate, 30012);
  end;

//Order Docs - must be blank or valid
  if Result = 0 then
    Result := ValidateDoc(TkBin.brInOrderRef, [POR], TkBin.brInOrderLine, DummyCurr,
                '', 30015, 30015, 30016, 0, 0, 30021);

  if Result = 0 then
    Result := ValidateDoc(TkBin.brOutOrderRef, [SOR], TkBin.brOutOrderLine, DummyCurr,
                '', 30017, 30017, 30018, 0, 0, 30022);

  //Restore multibin record
  MLocCtrl^ := TempRec;

  if (Result = 0) and UseRec then
  begin
  //PR 18/04/06 - Removed check for quantity, so that there can be -ve quantities in a bin [20060104142853]
 {   if TkBin.brQtyUsed > (MLocCtrl^.brBinRec.brBuyQty - MLocCtrl^.brBinRec.brQtyUsed) then
      Result := 30024
    else}
    begin
      //Set qty field in header then store header
      if Found then
      begin
        //We have a header record for this used rec so update it
        MLocCtrl^.brBinRec.brQtyUsed := MLocCtrl^.brBinRec.brQtyUsed + Round_Up(TkBin.brQtyUsed, Syss.NoQtyDec);
        MLocCtrl^.brBinRec.brSold := MLocCtrl^.brBinRec.brBuyQty - MLocCtrl^.brBinRec.brQtyUsed = 0;
        Result := StoreBinRec(B_Update, 0);

        if Result = 0 then
        begin
          //Set child fields from parent
          TkBin.brInDocRef := MLocCtrl^.brBinRec.brInDoc;
          TkBin.brInDocLine := MLocCtrl^.brBinRec.brBuyLine;
          TkBin.brInOrderRef := MLocCtrl^.brBinRec.brInOrdDoc;
          TkBin.brInOrderLine := MLocCtrl^.brBinRec.brInOrdLine;
        end;
      end
      else
      begin //No header rec so create it
        CopyTkBinToEntBin(TkBin, BFunc = B_Insert);
        MLocCtrl^.brBinRec.brQtyUsed := 0;
        MLocCtrl^.brBinRec.brBuyQty := TkBin.brQtyUsed;
        MLocCtrl^.brBinRec.brSold := False;
        Result := StoreBinRec(B_Insert, 0);
      end;

      if Result <> 0 then
        Result := Result + 200;

    end;
  end;

end;


FUNCTION EX_GETMULTIBIN(P            :  POINTER;
                        PSIZE        :  LONGINT;
                        SEARCHPATH   :  SMALLINT;
                        SEARCHMODE   :  SMALLINT;
                        LOCK         :  WORDBOOL)  :  SMALLINT;
                       {$IFDEF WIN32} STDCALL; {$ENDIF}
Var
  BinRec  :  ^TBatchBinRec;

begin
  LastErDesc:='';
  If TestMode then
  begin
    BinRec:=P;
    ShowMessage('Ex_GetMultiBin : ' + #10#13 +
                'P^.BinCode     : ' + BinRec^.brBinCode + #10#13 +
                'P^.StockFolio  : ' + IntToStr(BinRec^.brStockFolio) + #10#13 +
                'PSize: ' + IntToStr(PSize));
  end; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchBinRec)) then
  Begin

    BinRec:=P;

    Result := GetBinRec(BinRec^, SearchPath, SearchMode, Lock);

    if Result = 0 then
      CopyEntBinToTkBin(BinRec^);

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(172,Result);

end;  {func..}



FUNCTION EX_STOREMULTIBIN(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHPATH   :  SMALLINT;
                          SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL; {$ENDIF}
Var
  BinRec  :  ^TBatchBinRec;
  SMode : integer;
  NewestInDoc : string[10];
  NewestInLine : longint;
begin
  LastErDesc:='';
  If TestMode then
  begin
    BinRec:=P;
    ShowMessage('Ex_GetMultiBin : ' + #10#13 +
                'P^.BinCode     : ' + BinRec^.brBinCode + #10#13 +
                'P^.StockFolio  : ' + IntToStr(BinRec^.brStockFolio) + #10#13 +
                'PSize: ' + IntToStr(PSize));
  end; { If }

  Result:=32767;


  If (P<>Nil) and (PSize=Sizeof(TBatchBinRec)) then
  Begin
    SMode := SearchMode;
    If (Not (SMode In [B_Insert, B_Update])) then
      SMode:=B_Insert;

    BinRec:=P;

    if not WordBoolToBool(BinRec.brUsedRec) then
    begin

      Result := ValidateBinRec(BinRec^, SearchPath, SMode);

      if (Result = 0) and (SearchMode <> CheckMode) then
      begin

        //PR: 11/04/2014 ABSEXCH-14755 Add fields to store latest in doc when Adding to bin
        {$IFDEF COMTK}
        NewestInDoc := BinRec.brLatestInDoc;
        NewestInLine := BinRec.brLatestInLine;
        FillChar(BinRec.brLatestInDoc, SizeOf(BinRec.brLatestInDoc), 0);
        BinRec.brLatestInLine := 0;
        {$ENDIF}

        if SMode = B_Insert then
           FillChar(MLocCtrl^.brBinRec, SizeOf(MLocCtrl^.brBinRec), 0);
        CopyTkBinToEntBin(BinRec^, SMode = B_Insert);
        Result := StoreBinRec(SMode, SearchPath);

          //PR: 11/04/2014 ABSEXCH-14755 If we're adding to bin NewestInDoc will be populated
          if Result = 0 then
          begin  //If we have
          {$IFDEF COMTK}
            if (Trim(NewestInDoc) = '') or (NewestInLine = 0) then
              UpdateId(BinRec.brInDocRef, BinRec.brInDocLine, BinRec.brQty)
            else
              //AP : 15/12/2016 : ABSEXCH-17327 When adding stock items to an existing bin (using AddToBin), the line bin quantity is not being updated
              UpdateId(NewestInDoc, NewestInLine, BinRec.brAddQty)
           {$ELSE}
              UpdateId(BinRec.brInDocRef, BinRec.brInDocLine, BinRec.brQty);
           {$ENDIF}
          end;
      end;
    end
    else
      Case SearchMode of
        B_Insert : Result := 30026;
        B_Update : Result := 30023;
      end;

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(173,Result);

end;  {func..}


FUNCTION EX_USEMULTIBIN(P            :  POINTER;
                        PSIZE        :  LONGINT)  :  SMALLINT;
                        {$IFDEF WIN32} STDCALL; {$ENDIF}
Var
  BinRec  :  ^TBatchBinRec;

begin
  LastErDesc:='';
  If TestMode then
  begin
    BinRec:=P;
    ShowMessage('Ex_UseMultiBin : ' + #10#13 +
                'P^.BinCode     : ' + BinRec^.brBinCode + #10#13 +
                'P^.StockFolio  : ' + IntToStr(BinRec^.brStockFolio) + #10#13 +
                'PSize: ' + IntToStr(PSize));
  end; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchBinRec)) then
  Begin

    BinRec:=P;
    BinRec.brUsedRec := BoolToWordBool(True);

    Result := ValidateBinRec(BinRec^, 0, B_Insert);

    if Result = 0 then
    begin
      FillChar(MLocCtrl^.brBinRec, SizeOf(MLocCtrl^.brBinRec), 0);

      //PR: 14/03/2012 ABSEXCH-12622  Need to add True parameter for child rec.
      CopyTkBinToEntBin(BinRec^, True, True);
      Result := StoreBinRec(B_Insert, 0);
    end;

    if Result = 0 then
      UpdateId(BinRec.brOutDocRef, BinRec.brOutDocLine, BinRec.brQtyUsed);

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(174,Result);

end;  {func..}

FUNCTION EX_UNUSEMULTIBIN(P            :  POINTER;
                          PSIZE        :  LONGINT)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL; {$ENDIF}
Var
  BinRec  :  ^TBatchBinRec;
begin
  LastErDesc:='';
  If TestMode then
  begin
    BinRec:=P;
    ShowMessage('Ex_UnUseMultiBin : ' + #10#13 +
                'P^.BinCode     : ' + BinRec^.brBinCode + #10#13 +
                'P^.StockFolio  : ' + IntToStr(BinRec^.brStockFolio) + #10#13 +
                'PSize: ' + IntToStr(PSize));
  end; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchBinRec)) then
  Begin
    BinRec:=P;
    if BinRec.brRecPos <> 0 then
    begin
      BinRec.brQtyUsed := -BinRec.brQtyUsed;

      Result := ValidateBinRec(BinRec^, 0, B_Insert);


      if Result = 0 then
      begin
        Move(BinRec.brRecPos,MLocCtrl^,SizeOf(BinRec.brRecPos));
        UseVariant(F[MLocF]);
        if GetDirect(F[MLocF],MLocF,RecPtr[MLocF]^,0,0) = 0 then
        begin
          MLocCtrl^.brBinRec.brQtyUsed := MLocCtrl^.brBinRec.brQtyUsed + BinRec.brQtyUsed;
          if MLocCtrl^.brBinRec.brQtyUsed = 0 then
          begin
            Result := Delete_Rec(F[MLocF], MLocF, 0);
            if Result <> 0 then
              Result := 30200 + Result;
          end
          else
            Result := StoreBinRec(B_Update, 0);

            if Result = 0 then
              UpdateId(BinRec.brInDocRef, BinRec.brInDocLine, BinRec.brQtyUsed)


        end
        else
          Result := 30027;
      end;
    end
    else
      Result := 30026;

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(175,Result);

end;  {func..}


end.

