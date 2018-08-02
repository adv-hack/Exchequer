unit MultiBinPrc;

interface
uses
  {NeilProc,} TXRecs, EPOSProc, ComCtrls, Classes, StrUtil, DLLInc, MiscUtil;

type
  TBinInfo = Class
//    bBatch : boolean;
    UsedInBatch : real;
    UsedInThisLine : real;
    UsedElsewhere : real;
    UsedOnOtherLines : real;
    TKBinRec : TBatchBinRec;
    constructor CreateFrom(FromBinRec : TBatchBinRec; rAlreadyUsed : real);
    procedure CopyFrom(FromBinInfo : TBinInfo);
  end;


  Procedure BuildBinAvailableList(iStockFolio : integer; bRefund : boolean; slUsed : TStrings
  ; lvAllLines : TListView; LineMode : TFormMode; slAvailable : TStrings);
  function MoveBinItem(bAdd : boolean; slUsed, slAvailable : TStrings; var iListPos  : integer
  ;rPicked, rRequired : real; rBatchQty : real = -1) : integer;
  Function GetBinPicked(slUsed : TStrings) : real;
  function GetBinDescription(BinInfo : TBinInfo; bUsed : boolean) : string;
  function NoOfBinNumbers(BinNumbers : TStringList; TKStockRec : TBatchSKRec) : real;
  procedure CopyBins(slFrom, slTo : PStringList);
  function AskForBinNumbers(TXLineRec : TTXLineRec) : boolean;

implementation
uses
  Forms, Controls, MultiBins, CalcPric, SysUtils, EPOSCnst, UseDLLU, BtrvU2;

{TBinInfo}

constructor TBinInfo.CreateFrom(FromBinRec : TBatchBinRec; rAlreadyUsed : real);
begin
  inherited;
  TKBinRec := FromBinRec;
  with TKBinRec do begin
//    bBatch := Trim(brBinCode) <> '';

{    if bBatch then
      begin}
//        if iAlreadyUsed = 0 then UsedInBatch := Round(brQtyUsed)
        if rAlreadyUsed = 0 then UsedInBatch := brQtyUsed
        else UsedInBatch := rAlreadyUsed;
{      end
    else UsedInBatch := 0;}

    UsedInThisLine := rAlreadyUsed;
  end;{with}
end;

procedure TBinInfo.CopyFrom(FromBinInfo : TBinInfo);
begin
//  bBatch := FromBinInfo.bBatch;
  UsedInBatch := FromBinInfo.UsedInBatch;
  UsedInThisLine := FromBinInfo.UsedInThisLine;
  UsedElsewhere := FromBinInfo.UsedElsewhere;
  UsedOnOtherLines := FromBinInfo.UsedOnOtherLines;
  TKBinRec := FromBinInfo.TKBinRec;
end;


Procedure BuildBinAvailableList(iStockFolio : integer; bRefund : boolean; slUsed : TStrings
; lvAllLines : TListView; LineMode : TFormMode; slAvailable : TStrings);
var
  NewBinInfo : TBinInfo;
  TKBinRec : TBatchBinRec;
  iStatus : smallint;
  iTXLine, iPos : integer;
  rTotalUsed, rFoundElsewhere, rFoundInUsedList : real;
  UsedList : TStringList;
begin
  {Get First Bin number Record for this Stock item}
  FillChar(TKBinRec,SizeOf(TKBinRec),#0);
  TKBinRec.brStockFolio := iStockFolio;
  iStatus := Ex_GetMultiBin(@TKBinRec, SizeOf(TKBinRec), 1, B_GetGEq, FALSE);

  while (TKBinRec.brStockFolio = iStockFolio) and (iStatus = 0) do begin

    if (TKBinRec.brSold = bRefund)
    and ((SetupRecord.FilterSerialBinByLocation = 0) or (TKBinRec.brInLocation = SetupRecord.DefStockLocation))
//    and (not (TKBinRec.brSold and (not TKBinRec.BatchChild) and (Trim(TKBinRec.BatchNo) <> '')))
    then begin

      {try to find this Bin number in the Used list}
      rFoundInUsedList := -1;
      rFoundElsewhere := -1;

      if Assigned(slUsed) then begin
        for iPos := 0 to slUsed.Count - 1 do begin
          if {(TKBinRec.BatchNo = TBinInfo(slUsed.Objects[iPos]).TKBinRec.BatchNo)
          and} (TKBinRec.brBinCode = TBinInfo(slUsed.Objects[iPos]).TKBinRec.brBinCode)
          and (TKBinRec.brRecPos = TBinInfo(slUsed.Objects[iPos]).TKBinRec.brRecPos)
          then begin
            rFoundInUsedList := TBinInfo(slUsed.Objects[iPos]).UsedInThisLine;
          end;{if}
        end;{for}
      end;{if}

      {try to find this Bin number in all the used items lists of all the TX Lines}
      with lvAllLines do begin
        for iTXLine := 0 to Items.Count - 1 do begin
          if Assigned(TTXLineInfo(Items.item[iTXLine].data).TXLineRec.BinNumbers) then begin
            UsedList := TTXLineInfo(Items.item[iTXLine].data).TXLineRec.BinNumbers;
            for iPos := 0 to UsedList.Count - 1 do begin
              if {(TKBinRec.BatchNo = TBinInfo(UsedList.Objects[iPos]).TKBinRec.BatchNo)
              and} (TKBinRec.brBinCode = TBinInfo(UsedList.Objects[iPos]).TKBinRec.brBinCode)
              and (TKBinRec.brRecPos = TBinInfo(UsedList.Objects[iPos]).TKBinRec.brRecPos)
              then begin
                if rFoundElsewhere = -1 then rFoundElsewhere := TBinInfo(UsedList.Objects[iPos]).UsedInThisLine
                else rFoundElsewhere := rFoundElsewhere + TBinInfo(UsedList.Objects[iPos]).UsedInThisLine;
              end;{if}
            end;{for}
          end;{if}
        end;{for}
      end;{with}

      {add line to available list if not already all in used list}
      if (rFoundElsewhere <> 0) or (rFoundInUsedList <> 0) then begin

        NewBinInfo := TBinInfo.CreateFrom(TKBinRec, 0);

{        if NewBinInfo.bBatch then
          begin}
            rTotalUsed := 0;
            if rFoundElsewhere <> -1 then rTotalUsed := rTotalUsed + rFoundElsewhere;
            if rFoundInUsedList <> -1 then rTotalUsed := rTotalUsed + rFoundInUsedList;
            if (LineMode <> fmAdd) and (rFoundInUsedList <> -1) then rTotalUsed := rTotalUsed - rFoundInUsedList;

//            if ((not TKBinRec.brSold) and (iTotalUsed <> Round(TKBinRec.brQty - TKBinRec.brQtyUsed)))
//            or ((TKBinRec.brSold) and (iTotalUsed <> Round(TKBinRec.brQtyUsed)))
            if ((not TKBinRec.brSold) and (rTotalUsed <> (TKBinRec.brQty - TKBinRec.brQtyUsed)))
            or ((TKBinRec.brSold) and (rTotalUsed <> TKBinRec.brQtyUsed))
            then begin
              if (rFoundElsewhere <> -1) or (rFoundInUsedList <> -1) then begin

                if rFoundElsewhere = -1 then rFoundElsewhere := 0;
                if rFoundInUsedList = -1 then rFoundInUsedList := 0;
                if (LineMode <> fmAdd) then rFoundElsewhere := rFoundElsewhere - rFoundInUsedList;

                if TKBinRec.brSold then
                  begin
//                    NewBinInfo.UsedInBatch := NewBinInfo.UsedInBatch + iFoundElsewhere + iFoundInUsedList;
                    NewBinInfo.UsedInBatch := NewBinInfo.UsedInBatch - rFoundInUsedList;
                    NewBinInfo.UsedInThisLine := NewBinInfo.UsedInBatch;
                    NewBinInfo.UsedElsewhere := rFoundElsewhere;
                  end
                else begin
                  NewBinInfo.UsedInBatch := NewBinInfo.UsedInBatch + rFoundElsewhere + rFoundInUsedList;
                  NewBinInfo.UsedInThisLine := NewBinInfo.UsedInBatch;
                  NewBinInfo.UsedElsewhere := rFoundElsewhere;
                end;{if}

              end;{if}
              slAvailable.AddObject(GetBinDescription(NewBinInfo, FALSE), NewBinInfo);
            end;{if}
{          end
        else begin
          if (rFoundElsewhere = -1) and (rFoundInUsedList = -1)
          then slAvailable.AddObject(GetBinDescription(NewBinInfo, FALSE), NewBinInfo);
        end;{if}
      end;{if}

    end;{if}

    {next record}
    FillChar(TKBinRec,SizeOf(TKBinRec),#0);
    TKBinRec.brStockFolio := iStockFolio;
    iStatus := Ex_GetMultiBin(@TKBinRec, SizeOf(TKBinRec), 1, B_GetNext, FALSE);
  end;{while}
end;{BuildBinAvailableList}

function MoveBinItem(bAdd : boolean; slUsed, slAvailable : TStrings; var iListPos  : integer
;rPicked, rRequired : real; rBatchQty : real = -1) : integer;
var
  iBatchPos, iPos, iPrevIndex : integer;
  slFrom, slTo : TStrings;
  bSplitBatch : boolean;
  TempBinInfo, NewBinInfo : TBinInfo;
begin
  bSplitBatch := FALSE;

  if bAdd then
    begin
      // Add
      slFrom := slAvailable;
      slTo := slUsed;

      TempBinInfo := TBinInfo(slFrom.objects[iListPos]);
      with TempBinInfo do begin
//        if bBatch then begin

          if TKBinRec.brSold then
            begin
              if rBatchQty = -1 then bSplitBatch := (not (rPicked >= rRequired)
              and (UsedInBatch > (rRequired - rPicked)))
              else bSplitBatch := (UsedInBatch > rBatchQty);
//              and (Round(UsedInBatch) > (rRequired - rPicked)))
//              else bSplitBatch := (Round(UsedInBatch) > iBatchQty);

              if bSplitBatch then
                begin
                  {split the amount, between used and available}
//                  if iBatchQty = -1 then UsedInBatch := UsedInBatch - Round(rRequired - rPicked)
                  if rBatchQty = -1 then UsedInBatch := UsedInBatch - rRequired - rPicked
                  else UsedInBatch := UsedInBatch - rBatchQty;

                  UsedInThisLine := UsedInBatch;

                  {change description of remaining batch, to show new amount}
                  slFrom[iListPos] := GetBinDescription(TempBinInfo, FALSE);
                end
              else begin
                {move all numbers in batch to used list}
                UsedInBatch := 0;
                UsedInThisLine := UsedInBatch;
              end;{if}

            end
          else begin
            if rBatchQty = -1 then bSplitBatch := (not (rPicked >= rRequired)
            and ((TKBinRec.brQty - UsedInBatch) > (rRequired - rPicked)))
            else bSplitBatch := ((TKBinRec.brQty - UsedInBatch) > rBatchQty);
//            and (Round(TKBinRec.brQty - UsedInBatch) > (iRequired - iPicked)))
//            else bSplitBatch := (Round(TKBinRec.brQty - UsedInBatch) > iBatchQty);

            if bSplitBatch then
              begin
                {split the amount, between used and available}
//                if iBatchQty = -1 then UsedInBatch := UsedInBatch + Round(iRequired - iPicked)
                if rBatchQty = -1 then UsedInBatch := UsedInBatch + (rRequired - rPicked)
                else UsedInBatch := UsedInBatch + rBatchQty;

                UsedInThisLine := UsedInBatch;

                {change description of remaining batch, to show new amount}
                slFrom[iListPos] := GetBinDescription(TempBinInfo, FALSE);
              end
            else begin
              {move all numbers in batch to used list}
//              UsedInBatch := Round(TKBinRec.brQty);
              UsedInBatch := TKBinRec.brQty;
              UsedInThisLine := UsedInBatch;
            end;{if}

          end;{if}

//        end;{if}
      end;{with}
    end
  else begin
    // Remove
    slFrom := slUsed;
    slTo := slAvailable;
  end;{if}

  with slFrom do begin
    iPrevIndex := iListPos;
    iBatchPos := -1;

    {Is there already an entry in the "To" list for this batch ?}
//    if TBinInfo(objects[iListPos]).bBatch then begin
      For iPos := 0 to slTo.Count - 1 do begin
        if {(TBinInfo(slTo.Objects[iPos]).TKBinRec.BatchNo = TBinInfo(objects[iListPos]).TKBinRec.BatchNo)
        and} (TBinInfo(slTo.Objects[iPos]).TKBinRec.brBinCode = TBinInfo(objects[iListPos]).TKBinRec.brBinCode)
        and (TBinInfo(slTo.Objects[iPos]).TKBinRec.brRecPos = TBinInfo(objects[iListPos]).TKBinRec.brRecPos)
        then begin
          iBatchPos := iPos;
          break;
        end;{if}
      end;{for}
//    end;{if}

    if iBatchPos = -1 then
      begin
        {No entry in the "To" List for this batch (or not a batch), so let's add one}
        NewBinInfo := TBinInfo.CreateFrom(TBinInfo(objects[iListPos]).TKBinRec
        , TBinInfo(objects[iListPos]).UsedInBatch);

        {set used amounts}
        with NewBinInfo, TKBinRec do begin
          UsedElsewhere := TBinInfo(objects[iListPos]).UsedElsewhere;
          if bAdd and (not bSplitBatch)
          then UsedInThisLine := brQty - brQtyUsed - UsedElsewhere;
//          then UsedInThisLine := Round(brQty - brQtyUsed - UsedElsewhere);

          if not bAdd then begin
//            UsedInBatch := Round(brQtyUsed + UsedElsewhere);
//            UsedInThisLine := Round(brQtyUsed + UsedElsewhere);
            UsedInBatch := brQtyUsed + UsedElsewhere;
            UsedInThisLine := brQtyUsed + UsedElsewhere;
          end;{if}

          if brSold and (not bSplitBatch) then begin
            if bAdd then begin
              UsedInBatch := 0;
//              UsedInThisLine := Round(brQtyUsed);
              UsedInThisLine := brQtyUsed;
            end;{if}
          end;{if}

        end;{with}

        {add line}
        slTo.AddObject(slFrom[iListPos], NewBinInfo);
      end
    else begin
      {edit existing line in "To" list}
      with TBinInfo(slTo.objects[iBatchPos]), TKBinRec do begin

        {modify used amounts}
        if bAdd then
          begin
            if brSold then
              begin
                UsedInThisLine := UsedInThisLine + UsedInBatch;
                UsedInBatch := 0;
              end
            else begin
//              UsedInBatch := Round(brQty);
//              UsedInThisLine := Round(UsedInBatch - brQtyUsed - UsedElsewhere);
              UsedInBatch := brQty;
              UsedInThisLine := UsedInBatch - brQtyUsed - UsedElsewhere;
            end;{if}
          end
        else begin
//          UsedInBatch := Round(brQtyUsed + UsedElsewhere);
//          UsedInThisLine := Round(brQtyUsed + UsedElsewhere);
          UsedInBatch := brQtyUsed + UsedElsewhere;
          UsedInThisLine := brQtyUsed + UsedElsewhere;
        end;{if}

        {modify item description}
        slTo[iBatchPos] := GetBinDescription(TBinInfo(slTo.objects[iBatchPos])
        , bAdd);
      end;{with}
    end;{if}

    {remove item from "From" list}
    if (not bSplitBatch) or (iBatchPos <> -1) then begin
      Objects[iListPos].Free;
      Delete(iListPos);
    end;{if}

    {set selected position in From list}
    if iPrevIndex = count then iListPos := count - 1
    else iListPos := iPrevIndex;
  end;{with}

  {set selected position in To list}
  if iBatchPos = -1 then iBatchPos := slTo.count - 1;

  if bSplitBatch then begin
    {set amount of batch picked}
    with TBinInfo(slTo.Objects[iBatchPos]) do begin
//      if TKBinRec.brSold then UsedInThisLine := Round(TKBinRec.brQtyUsed - UsedInBatch)
//      else UsedInThisLine := Round(UsedInBatch - TKBinRec.brQtyUsed - UsedElsewhere);
      if TKBinRec.brSold then UsedInThisLine := TKBinRec.brQtyUsed - UsedInBatch
      else UsedInThisLine := UsedInBatch - TKBinRec.brQtyUsed - UsedElsewhere;
      {recalculate description of picked batch}
      slTo[iBatchPos] := GetBinDescription(TBinInfo(slTo.Objects[iBatchPos]), TRUE);
    end;{with}
  end;{if}

  Result := iBatchPos;

end;

Function GetBinPicked(slUsed : TStrings) : real;
var
  iPos : integer;
begin
  {count how many items have been picked}
  Result := 0;
  if Assigned(slUsed) then begin
    For iPos := 0 to (slUsed.Count - 1) do begin
      with TBinInfo(slUsed.objects[iPos]), TKBinRec do begin
{        if bBatch then
          begin}
            Result := Result + UsedInThisLine
{          end
        else Result := Result + 1;}
      end;{with}
    end;{for}
  end;{if}
end;

function GetBinDescription(BinInfo : TBinInfo; bUsed : boolean) : string;
{calculates new description for item}
var
  rLeft, rTotal : real;
begin
  with BinInfo do begin
//    if bBatch then
//      begin
//        if (Trim(TKBinRec.brBinCode) = '') then Result := 'Batch - ' + Trim(TKBinRec.BatchNo) + ' ('
//        else Result := 'Batch - ' + Trim(TKBinRec.BatchNo) + ' (' + Trim(TKBinRec.brBinCode) + ') (';
        Result := Trim(TKBinRec.brBinCode) + ' (';

        if bUsed then
          begin
//            if TKBinRec.brSold then iLeft := Round(TKBinRec.brQty - (TKBinRec.brQtyUsed - UsedInBatch))
//            else iLeft := Round(UsedInThisLine)
            if TKBinRec.brSold then rLeft := TKBinRec.brQty - (TKBinRec.brQtyUsed - UsedInBatch)
            else rLeft := UsedInThisLine
          end
        else rLeft :=  TKBinRec.brQty - UsedInBatch;
//        else iLeft :=  Round(TKBinRec.brQty - UsedInBatch);

//        iTotal := Round(TKBinRec.brQty);
        rTotal := TKBinRec.brQty;

//        if TKBinRec.brSold then Result := Result + IntToStr(Round(iTotal - iLeft)) + ' of '
//        + IntToStr(Round(iTotal)) + ') ' + TKBinRec.brOutDocRef
//        else Result := Result + IntToStr(iLeft) + ' of ' + IntToStr(Round(iTotal)) + ')';
        if TKBinRec.brSold then Result := Result + MoneyToStr(rTotal - rLeft, TKSysRec.QuantityDP)
        + ' of ' + MoneyToStr(rTotal, TKSysRec.QuantityDP) + ') ' + TKBinRec.brOutDocRef
        else Result := Result + MoneyToStr(rLeft, TKSysRec.QuantityDP) + ' of '
        + MoneyToStr(rTotal, TKSysRec.QuantityDP) + ')';
//      end
//    else Result := Trim(TKBinRec.brBinCode);

    if (Trim(TKBinRec.brInLocation) <> '') and (TKSysRec.MultiLocn > 0)
    and (SetupRecord.FilterSerialBinByLocation = 0)
    then  Result := Result + ' [' + TKBinRec.brInLocation + ']';
  end;{with}
end;

function NoOfBinNumbers(BinNumbers : TStringList; TKStockRec : TBatchSKRec) : real;
var
  iPos : integer;
begin
  if (not assigned(BinNumbers)) then Result := 0
  else begin
    Result := 0;
    For iPos := 0 to BinNumbers.Count - 1 do begin
      with TBinInfo(BinNumbers.Objects[iPos]) do begin
        {if bBatch then }Result := Result + (UsedInThisLine * WhatisOne(TKStockRec))
//        else Result := Result + 1;
      end;{with}
    end;{for}
  end;{if}
end;

procedure CopyBins(slFrom, slTo: PStringList);
var
  iPos : integer;
  BinInfo : TBinInfo;
begin
  if Assigned(slFrom^) then begin

    if Assigned(slTo^) then
      begin
        for iPos := 0 to slTo^.count - 1 do slTo^.Objects[iPos].Free;
        slTo^.Clear;
      end
    else slTo^ := TStringList.Create;

    if (slFrom^.count > 0) then begin
      for iPos := 0 to slFrom^.count - 1 do begin
        BinInfo := TBinInfo.Create;
        BinInfo.CopyFrom(TBinInfo(slFrom^.Objects[iPos]));
        slTo^.AddObject(slFrom^[iPos], BinInfo);
      end;{for}
    end;{if}
  end;{if}
end;

function AskForBinNumbers(TXLineRec : TTXLineRec) : boolean;
begin
  {Show serial numbers screen}
  with TFrmMultiBins.Create(application) do begin
    try
      rRequired := Round(ABS(TXLineRec.TKTLRec.Qty)) / WhatIsOne(TXLineRec.TKStockRec);
      iStockFolio := GetStockFolioFromCode(TXLineRec.TKTLRec.StockCode);
      bRefund := TXLineRec.TKTLRec.Qty < 0;

      CopyBins(@TXLineRec.BinNumbers, @TStringList(lstUsed.Items));

      Result := ShowModal = mrOK;
      if Result then CopyBins(@TStringList(lstUsed.Items), @TXLineRec.BinNumbers);
    finally
      Release;
    end;{try}
  end;{with}
end;



end.
