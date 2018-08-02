unit DLLMultiBuy;
{$ALIGN 1}
Interface

Uses
  Classes,
  GlobVar,
  VarRec2U,
  VarConst,
  VarCnst3,
  MultiBuyVar,
  Dialogs;

function Ex_GetMultiBuy(P            :  POINTER;
                        PSIZE        :  LONGINT;
                        SEARCHPATH   :  SMALLINT;
                        SEARCHMODE   :  SMALLINT;
                        LOCK         :  WORDBOOL) : SMALLINT; STDCALL; EXPORT;

function Ex_StoreMultiBuy(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHPATH   :  SMALLINT;
                          SEARCHMODE   :  SMALLINT) : SMALLINT; STDCALL; EXPORT;


function Ex_DeleteMultiBuy(P            :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHPATH   :  LONGINT) : SmallInt; StdCall; Export;

procedure ExMultiBuyToTkMultiBuy(const ExMB : TMultiBuyDiscount;
                                   var TKMB : TBatchMultiBuyDiscount);




implementation

uses
  BtKeys1U, MultiBuyFuncs, BtrvU2, DllErrU, btSupU1, SysUtils, EtDateU, Bts1,
  //PR: 28/10/2011 v6.9
  AuditNotes, AuditNoteIntf;


var
  StoredStockCode : String;

procedure GetApplicableMultiBuyDiscount(Var ExStkPrRec  :  TBatchStkPriceRec);
begin

end;

procedure ExMultiBuyToTkMultiBuy(const ExMB : TMultiBuyDiscount;
                                   var TKMB : TBatchMultiBuyDiscount);
begin
  TKMB.mbdOwnerType         := EXMB.mbdOwnerType;
  TKMB.mbdDiscountType      := EXMB.mbdDiscountType;
  TKMB.mbdAcCode            := EXMB.mbdAcCode;
  TKMB.mbdStockCode         := EXMB.mbdStockCode;
  TKMB.mbdCurrency          := EXMB.mbdCurrency;
  TKMB.mbdStartDate         := EXMB.mbdStartDate;
  TKMB.mbdEndDate           := EXMB.mbdEndDate;
  TKMB.mbdUseDates          := BoolToWordBool(EXMB.mbdUseDates);
  TKMB.mbdBuyQty            := EXMB.mbdBuyQty;
  TKMB.mbdRewardValue       := EXMB.mbdRewardValue;
end;

procedure TKMultiBuyToExMultiBuy(const TKMB : TBatchMultiBuyDiscount;
                                   var ExMB : TMultiBuyDiscount);
begin
  EXMB.mbdOwnerType    := TKMB.mbdOwnerType;
  EXMB.mbdDiscountType := TKMB.mbdDiscountType;
  EXMB.mbdAcCode       := FullCustCode(TKMB.mbdAcCode);
  EXMB.mbdStockCode    := FullStockCode(TKMB.mbdStockCode);
  EXMB.mbdCurrency     := TKMB.mbdCurrency;
  EXMB.mbdStartDate    := TKMB.mbdStartDate;
  EXMB.mbdEndDate      := TKMB.mbdEndDate;
  EXMB.mbdUseDates     := WordBoolToBool(TKMB.mbdUseDates);
  EXMB.mbdBuyQty       := TKMB.mbdBuyQty;
  EXMB.mbdBuyQtyString := FormatBuyQtyString(EXMB.mbdBuyQty);
  EXMB.mbdRewardValue  := TKMB.mbdRewardValue;
end;

function ValidateMultiBuy(ExMB : TMultiBuyDiscount; IsEdit : Boolean) : Integer;
{Results are:

  30001  : Invalid Discount Type
  30002  : Invalid Currency
  30003  : Invalid Start Date
  30004  : Invalid End Date
  30005  : Buy Qty must be positive
  30006  : Reward Value must be positive
  30007  : Invalid Account Code
  30008  : Invalid Stock Code
  30009  : Invalid Owner Type
  30010  : Date range clash

}
var
  ValidCheck, ValidHed, ValidRec : Boolean;
  Res : Integer;
  MultiBuyFunctions : TMultiBuyFunctions;

begin
  Result := 0;
  //Discount Type
  ValidRec := ExMB.mbdDiscountType in ['0'..'2'];
  GenSetError(ValidRec,30001,Result,ValidHed);

  //Currency //PR: 08/07/2009 Fix to allow Currency = 0 (FR v6.01.130)
  if ExSyss.MCMode then
    ValidRec :=  (ExMB.mbdDiscountType in ['0','2']) or
                (ExMB.mbdCurrency <= Pred(CurrencyType))
  else
  begin
    ValidRec := True;
    ExMB.mbdCurrency := 0;
  end;
  GenSetError(ValidRec,30002,Result,ValidHed);

  //Start and End Date
  if ExMB.mbdUseDates then
  begin
    ValidRec := ValidDate(ExMB.mbdStartDate);
    GenSetError(ValidRec,30003,Result,ValidHed);

    ValidRec := ValidDate(ExMB.mbdEndDate) and (ExMB.mbdEndDate >= ExMB.mbdStartDate);
    GenSetError(ValidRec,30004,Result,ValidHed);
  end
  else
  begin
    FillChar(ExMB.mbdStartDate, SizeOf(ExMB.mbdStartDate), 0);
    FillChar(ExMB.mbdEndDate, SizeOf(ExMB.mbdEndDate), 0);
  end;

  ValidRec := ExMB.mbdBuyQty > 0;
  GenSetError(ValidRec,30005,Result,ValidHed);

  ValidRec := ExMB.mbdRewardValue > 0;
  GenSetError(ValidRec,30006,Result,ValidHed);

  //Account Code
  ValidRec := (Trim(ExMB.mbdAcCode) = '') or CheckRecExsists(ExMB.mbdAcCode, CustF, 0);
  GenSetError(ValidRec,30007,Result,ValidHed);


  //Stock Code
  if ValidRec then
  begin
    ValidRec := CheckRecExsists(ExMB.mbdStockCode, StockF, 0);
    GenSetError(ValidRec,30008,Result,ValidHed);
  end;

  //Owner Type
  if ValidRec then
  begin
    Case ExMB.mbdOwnerType of
      'C',
      'S'   :  ValidRec := (Cust.CustSupp = ExMB.mbdOwnerType);
      'T'   :  ValidRec := Trim(ExMB.mbdAcCode) = '';
      else
        ValidRec := False;
    end;
    GenSetError(ValidRec,30009,Result,ValidHed);
  end;

  //Check for date range clash with existing discounts
  if ValidRec then
  begin
    MultiBuyFunctions := TMultiBuyFunctions.Create;
    Try
      Res := MultiBuyFunctions.ValidateDiscount(ExMB, IsEdit);
      ValidRec := Res = 0;
      if (Res and rcType) = rcType then
        GenSetError(ValidRec,30001,Result,ValidHed)
      else
      if (Res and rcQty) = rcQty then
        GenSetError(ValidRec,30011,Result,ValidHed)
      else
      if (Res and rcDate) = rcDate then
        GenSetError(ValidRec,30010,Result,ValidHed);
    Finally
      MultiBuyFunctions.Free;
    End;
  end;

end;


function Ex_GetMultiBuy(P            :  POINTER;
                        PSIZE        :  LONGINT;
                        SEARCHPATH   :  SMALLINT;
                        SEARCHMODE   :  SMALLINT;
                        LOCK         :  WORDBOOL) : SMALLINT;
var
  Locked : Boolean;
  KeyS, KeyChk : Str255;

  pMBDRec : ^TBatchMultiBuyDiscount;
begin

  Result:=32767;
  Locked:=BOff;
  SearchPath := 0;

  If (P<>Nil) and (PSize=Sizeof(TBatchMultiBuyDiscount)) then
  Begin
    pMBDRec := P;

    Case SearchMode of

      B_GetEq,
      B_GetFirst,
      B_StepFirst   :  SearchMode := B_GetGEq;

      B_GetLast,
      B_StepLast    :  SearchMode := B_GetLessEq;

      B_StepNext    :  SearchMode := B_GetNext;

      B_StepPrev    :  SearchMode := B_GetPrev;
    end; {Case..}


    with pMBDRec^ do
    begin
      if SearchMode = B_GetGEq then
        KeyS := mbdStockCodeKey(mbdAcCode, mbdStockCode)
      else
      if SearchMode = B_GetLessEq then
        KeyS := mbdGetLastKey(mbdAcCode, mbdStockCode);

      KeyS := SetKeyString(SearchMode, MultiBuyF, KeyS);

      //When we have a GetNext/Prev, we need to know whether the operation that established position was
      //looking for Customer/Stock or just Customer (Stock only is not a problem.)
      if not (SearchMode in [B_GetNext, B_GetPrev]) then
         StoredStockCode := mbdStockCode;

      //If customer/stock or stock only
      if Trim(StoredStockCode) <> '' then
        KeyChk := Copy(KeyS, 1, mbdAcStockKeyLen)
      else //Customer only
        KeyChk := FullCustCode(mbdAcCode);


      Result := Find_Rec(SearchMode, F[MultiBuyF], MultiBuyF, RecPtr[MultiBuyF]^, SearchPath, KeyS);

      KeyStrings[MultiBuyF] := KeyS;
      
      //Check that found record belongs to AcCode and StockCode
      if (Result = 0) and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) then
      begin

        If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
        begin
          If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,MultiBuyF,SilentLock,Locked)) then
            Result:=0;
          // If unable to get lock then return code 84
          if (Result = 0) and not Locked then
            Result := 84;
        end;

        if Result = 0 then
        begin
          ExMultiBuyToTkMultiBuy(MultiBuyDiscount, pMBDRec^);
          //Put record position into tk rec
          GetPos(F[MultiBuyF], MultiBuyF, pMBDRec.RecordPosition);
        end;

      end
      else
      if Result = 0 then
        Result := 9;
    end;
  end
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(195,Result);

end;

function Ex_StoreMultiBuy(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHPATH   :  SMALLINT;
                          SEARCHMODE   :  SMALLINT) : SMALLINT;
var
  Res : Integer;
  pMBDRec : ^TBatchMultiBuyDiscount;
  RecAddr : Longint;
begin
  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchMultiBuyDiscount)) then
  Begin

    pMBDRec := P;
    if SearchMode = B_Update then
    begin
      if pMBDRec.RecordPosition <> 0 then
      begin
        Move(pMBDRec.RecordPosition, MultiBuyDiscount, SizeOf(pMBDRec.RecordPosition));
        Result := GetDirect(F[MultiBuyF], MultiBuyF, RecPtr[MultiBuyF]^, 0, 0);
      end
      else
        Result := 4;
    end
    else
      Result := 0;

    if Result = 0 then
    begin
      TKMultiBuyToExMultiBuy(pMBDRec^, MultiBuyDiscount);
      Result := ValidateMultiBuy(MultiBuyDiscount, SearchMode = B_Update);
    end;

    if Result = 0 then
    begin
      Case SearchMode of
        B_Insert,
        ImportMode :  begin
                        Result := Add_Rec(F[MultiBuyF],MultiBuyF,RecPtr[MultiBuyF]^,SearchPath);
                      end;

        B_Update   :  begin
                        Result := Put_Rec(F[MultiBuyF],MultiBuyF,RecPtr[MultiBuyF]^,SearchPath);
                      end;
      end; //Case

      //PR: 28/10/2011 v6.9 Adding or editing a discount is considered an edit of the parent for AuditNote purposes,
      //so add an Audit Note
      //Owner could be Account or Stock - recognise from mbdOwnerType in discount record.
      if MultiBuyDiscount.mbdOwnerType in ['C', 'S'] then
        AuditNote.AddNote(anAccount, Cust.CustCode, anEdit)
      else
        AuditNote.AddNote(anAccount, Stock.StockFolio, anEdit);

    end;

  end
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(196,Result);

end;


function Ex_DeleteMultiBuy(P            :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHPATH   :  LONGINT ) : SmallInt;

var
  Res : Integer;
  pMBDRec : ^TBatchMultiBuyDiscount;
  KeyS : Str255;
begin
  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchMultiBuyDiscount)) then
  Begin

    pMBDRec := P;
    if pMBDRec.RecordPosition <> 0 then
    begin
      Move(pMBDRec.RecordPosition, MultiBuyDiscount, SizeOf(pMBDRec.RecordPosition));
      Result := GetDirect(F[MultiBuyF], MultiBuyF, RecPtr[MultiBuyF]^, 0, 0);

      if Result = 0 then
        Result := Delete_Rec(F[MultiBuyF], MultiBuyF, SearchPath);

      //PR: 28/10/2011 v6.9 Deleting a discount is considered an edit of the parent for AuditNote purposes,
      //so add an Audit Note.
      //Owner could be Account or Stock - recognise from mbdOwnerType in discount record.
      if Result = 0 then
      begin
        if MultiBuyDiscount.mbdOwnerType in ['C', 'S'] then
          AuditNote.AddNote(anAccount, MultiBuyDiscount.mbdAcCode, anEdit)
        else
        begin
          //We only have the stock code and need the folio
          if CheckRecExsists(MultiBuyDiscount.mbdStockCode, StockF, 0) then
            AuditNote.AddNote(anAccount, Stock.StockFolio, anEdit);
        end;  //Stock
      end;
    end
    else
      Result := 4;

  end
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(197,Result);

end;

end.
