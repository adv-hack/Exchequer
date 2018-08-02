unit SerialPrc;

interface
uses
  {NeilProc,} EPOSProc, ComCtrls, Classes, StrUtil, DLLInc, MiscUtil, TXRecs;

type
  TSerialInfo = Class
    bBatch : boolean;
    UsedInBatch : real;
    UsedInThisLine : real;
    UsedElsewhere : real;
    UsedOnOtherLines : real;
    TKSerialRec : TBatchSerialRec;
    constructor CreateFrom(FromSerialRec : TBatchSerialRec; rAlreadyUsed : real);
    procedure CopyFrom(FromSerialInfo : TSerialInfo);
  end;


  Procedure BuildSerialAvailableList(sStockCode : string20; bRefund : boolean; slUsed : TStrings
  ; lvAllLines : TListView; LineMode : TFormMode; slAvailable : TStrings);
  function MoveSerialItem(bAdd : boolean; slUsed, slAvailable : TStrings; var iListPos  : integer
  ;rPicked, rRequired : real; rBatchQty : real = -1) : integer;
  Function GetSerialPicked(slUsed : TStrings) : real;
  function GetSerialDescription(SerialInfo : TSerialInfo; bUsed : boolean) : string;
  function NoOfSerialNumbers(SerialNumbers : TStringList; TKStockRec : TBatchSKRec) : real;
  procedure CopySerials(slFrom, slTo : PStringList);
  function AskForSerialNumbers(TXLineRec : TTXLineRec) : boolean;

implementation
uses
  Controls, Forms, CalcPric, SysUtils, EPOSCnst, UseDLLU, BtrvU2, Serial;

{TSerialInfo}

constructor TSerialInfo.CreateFrom(FromSerialRec : TBatchSerialRec; rAlreadyUsed : real);
begin
  inherited;
  TKSerialRec := FromSerialRec;
  with TKSerialRec do begin
    bBatch := Trim(BatchNo) <> '';

    if bBatch then
      begin
//        if iAlreadyUsed = 0 then UsedInBatch := Round(QtyUsed)
        if rAlreadyUsed = 0 then UsedInBatch := QtyUsed
        else UsedInBatch := rAlreadyUsed;
      end
    else UsedInBatch := 0;

    UsedInThisLine := rAlreadyUsed;
  end;{with}
end;

procedure TSerialInfo.CopyFrom(FromSerialInfo : TSerialInfo);
begin
  bBatch := FromSerialInfo.bBatch;
  UsedInBatch := FromSerialInfo.UsedInBatch;
  UsedInThisLine := FromSerialInfo.UsedInThisLine;
  UsedElsewhere := FromSerialInfo.UsedElsewhere;
  UsedOnOtherLines := FromSerialInfo.UsedOnOtherLines;
  TKSerialRec := FromSerialInfo.TKSerialRec;
end;


Procedure BuildSerialAvailableList(sStockCode : string20; bRefund : boolean; slUsed : TStrings
; lvAllLines : TListView; LineMode : TFormMode; slAvailable : TStrings);
var
  NewSerialInfo : TSerialInfo;
  TKSerialRec : TBatchSerialRec;
  iStatus : smallint;
  iTXLine, iPos : integer;
  rTotalUsed, rFoundElsewhere, rFoundInUsedList : real;
  UsedList : TStringList;
begin
  {Get First Serial number Record for this Stock item}
  FillChar(TKSerialRec,SizeOf(TKSerialRec),#0);
  TKSerialRec.StockCode := sStockCode;
  TKSerialRec.Sold := bRefund;{.280}  // NF: 26/05/06 New property now used in the TCM Toolkit 

  iStatus := Ex_GetSerialBatch(@TKSerialRec, SizeOf(TKSerialRec), B_GetGEq);

  {.280}
{  while (TKSerialRec.StockCode = sStockCode) and (iStatus = 0) do begin

    if (TKSerialRec.Sold = bRefund)
    and ((SetupRecord.FilterSerialBinByLocation = 0) or (TKSerialRec.InMLoc = SetupRecord.DefStockLocation))
    and (not (TKSerialRec.Sold and (not TKSerialRec.BatchChild) and (Trim(TKSerialRec.BatchNo) <> '')))
    then begin}

  while (TKSerialRec.StockCode = sStockCode) and (iStatus = 0) and (TKSerialRec.Sold = bRefund) do begin

    if {(TKSerialRec.Sold = bRefund)
    and} ((SetupRecord.FilterSerialBinByLocation = 0) or (TKSerialRec.InMLoc = SetupRecord.DefStockLocation))
    and (not (TKSerialRec.Sold and (not TKSerialRec.BatchChild) and (Trim(TKSerialRec.BatchNo) <> '')))
    then begin

      {try to find this serial number in the Used list}
      rFoundInUsedList := -1;
      rFoundElsewhere := -1;

      if Assigned(slUsed) then begin
        for iPos := 0 to slUsed.Count - 1 do begin
          if (TKSerialRec.BatchNo = TSerialInfo(slUsed.Objects[iPos]).TKSerialRec.BatchNo)
          and (TKSerialRec.SerialNo = TSerialInfo(slUsed.Objects[iPos]).TKSerialRec.SerialNo)
          and (TKSerialRec.RecPos = TSerialInfo(slUsed.Objects[iPos]).TKSerialRec.RecPos)
          then begin
            rFoundInUsedList := TSerialInfo(slUsed.Objects[iPos]).UsedInThisLine;
          end;{if}
        end;{for}
      end;{if}

      {try to find this serial number in all the used items lists of all the TX Lines}
      with lvAllLines do begin
        for iTXLine := 0 to Items.Count - 1 do begin
          if Assigned(TTXLineInfo(Items.item[iTXLine].data).TXLineRec.SerialNumbers) then begin
            UsedList := TTXLineInfo(Items.item[iTXLine].data).TXLineRec.SerialNumbers;
            for iPos := 0 to UsedList.Count - 1 do begin
              if (TKSerialRec.BatchNo = TSerialInfo(UsedList.Objects[iPos]).TKSerialRec.BatchNo)
              and (TKSerialRec.SerialNo = TSerialInfo(UsedList.Objects[iPos]).TKSerialRec.SerialNo)
              and (TKSerialRec.RecPos = TSerialInfo(UsedList.Objects[iPos]).TKSerialRec.RecPos)
              then begin
                if rFoundElsewhere = -1 then rFoundElsewhere := TSerialInfo(UsedList.Objects[iPos]).UsedInThisLine
                else rFoundElsewhere := rFoundElsewhere + TSerialInfo(UsedList.Objects[iPos]).UsedInThisLine;
              end;{if}
            end;{for}
          end;{if}
        end;{for}
      end;{with}

      {add line to available list if not already all in used list}
      if (rFoundElsewhere <> 0) or (rFoundInUsedList <> 0) then begin

        NewSerialInfo := TSerialInfo.CreateFrom(TKSerialRec, 0);

        if NewSerialInfo.bBatch then
          begin
            rTotalUsed := 0;
            if rFoundElsewhere <> -1 then rTotalUsed := rTotalUsed + rFoundElsewhere;
            if rFoundInUsedList <> -1 then rTotalUsed := rTotalUsed + rFoundInUsedList;
            if (LineMode <> fmAdd) and (rFoundInUsedList <> -1) then rTotalUsed := rTotalUsed - rFoundInUsedList;

//            if ((not TKSerialRec.Sold) and (iTotalUsed <> Round(TKSerialRec.BuyQty - TKSerialRec.QtyUsed)))
//            or ((TKSerialRec.Sold) and (iTotalUsed <> Round(TKSerialRec.QtyUsed)))
            if ((not TKSerialRec.Sold) and (rTotalUsed <> (TKSerialRec.BuyQty - TKSerialRec.QtyUsed)))
            or ((TKSerialRec.Sold) and (rTotalUsed <> TKSerialRec.QtyUsed))
            then begin
              if (rFoundElsewhere <> -1) or (rFoundInUsedList <> -1) then begin

                if rFoundElsewhere = -1 then rFoundElsewhere := 0;
                if rFoundInUsedList = -1 then rFoundInUsedList := 0;
                if (LineMode <> fmAdd) then rFoundElsewhere := rFoundElsewhere - rFoundInUsedList;

                if TKSerialRec.Sold then
                  begin
//                    NewSerialInfo.UsedInBatch := NewSerialInfo.UsedInBatch + iFoundElsewhere + iFoundInUsedList;
                    NewSerialInfo.UsedInBatch := NewSerialInfo.UsedInBatch - rFoundInUsedList;
                    NewSerialInfo.UsedInThisLine := NewSerialInfo.UsedInBatch;
                    NewSerialInfo.UsedElsewhere := rFoundElsewhere;
                  end
                else begin
                  NewSerialInfo.UsedInBatch := NewSerialInfo.UsedInBatch + rFoundElsewhere + rFoundInUsedList;
                  NewSerialInfo.UsedInThisLine := NewSerialInfo.UsedInBatch;
                  NewSerialInfo.UsedElsewhere := rFoundElsewhere;
                end;{if}

              end;{if}
              slAvailable.AddObject(GetSerialDescription(NewSerialInfo, FALSE), NewSerialInfo);
            end;{if}
          end
        else begin
          if (rFoundElsewhere = -1) and (rFoundInUsedList = -1)
          then slAvailable.AddObject(GetSerialDescription(NewSerialInfo, FALSE), NewSerialInfo);
        end;{if}
      end;{if}

    end;{if}

    {next record}
    FillChar(TKSerialRec,SizeOf(TKSerialRec),#0);
    TKSerialRec.StockCode := sStockCode;
    TKSerialRec.Sold := bRefund;{.280}  // NF: 26/05/06 New property now used in the TCM Toolkit 
    iStatus := Ex_GetSerialBatch(@TKSerialRec, SizeOf(TKSerialRec), B_GetNext);
  end;{while}
end;{BuildSerialAvailableList}

function MoveSerialItem(bAdd : boolean; slUsed, slAvailable : TStrings; var iListPos  : integer
;rPicked, rRequired : real; rBatchQty : real = -1) : integer;
var
  iBatchPos, iPos, iPrevIndex : integer;
  slFrom, slTo : TStrings;
  bSplitBatch : boolean;
  TempSerialInfo, NewSerialInfo : TSerialInfo;
begin
  bSplitBatch := FALSE;

  if bAdd then
    begin
      // Add
      slFrom := slAvailable;
      slTo := slUsed;

      TempSerialInfo := TSerialInfo(slFrom.objects[iListPos]);
      with TempSerialInfo do begin
        if bBatch then begin

          if TKSerialRec.Sold then
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
                  slFrom[iListPos] := GetSerialDescription(TempSerialInfo, FALSE);
                end
              else begin
                {move all numbers in batch to used list}
                UsedInBatch := 0;
                UsedInThisLine := UsedInBatch;
              end;{if}

            end
          else begin
            if rBatchQty = -1 then bSplitBatch := (not (rPicked >= rRequired)
            and ((TKSerialRec.BuyQty - UsedInBatch) > (rRequired - rPicked)))
            else bSplitBatch := ((TKSerialRec.BuyQty - UsedInBatch) > rBatchQty);
//            and (Round(TKSerialRec.BuyQty - UsedInBatch) > (iRequired - iPicked)))
//            else bSplitBatch := (Round(TKSerialRec.BuyQty - UsedInBatch) > iBatchQty);

            if bSplitBatch then
              begin
                {split the amount, between used and available}
//                if iBatchQty = -1 then UsedInBatch := UsedInBatch + Round(iRequired - iPicked)
                if rBatchQty = -1 then UsedInBatch := UsedInBatch + (rRequired - rPicked)
                else UsedInBatch := UsedInBatch + rBatchQty;

                UsedInThisLine := UsedInBatch;

                {change description of remaining batch, to show new amount}
                slFrom[iListPos] := GetSerialDescription(TempSerialInfo, FALSE);
              end
            else begin
              {move all numbers in batch to used list}
//              UsedInBatch := Round(TKSerialRec.BuyQty);
              UsedInBatch := TKSerialRec.BuyQty;
              UsedInThisLine := UsedInBatch;
            end;{if}

          end;{if}

        end;{if}
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
    if TSerialInfo(objects[iListPos]).bBatch then begin
      For iPos := 0 to slTo.Count - 1 do begin
        if (TSerialInfo(slTo.Objects[iPos]).TKSerialRec.BatchNo = TSerialInfo(objects[iListPos]).TKSerialRec.BatchNo)
        and (TSerialInfo(slTo.Objects[iPos]).TKSerialRec.SerialNo = TSerialInfo(objects[iListPos]).TKSerialRec.SerialNo)
        and (TSerialInfo(slTo.Objects[iPos]).TKSerialRec.RecPos = TSerialInfo(objects[iListPos]).TKSerialRec.RecPos)
        then begin
          iBatchPos := iPos;
          break;
        end;{if}
      end;{for}
    end;{if}

    if iBatchPos = -1 then
      begin
        {No entry in the "To" List for this batch (or not a batch), so let's add one}
        NewSerialInfo := TSerialInfo.CreateFrom(TSerialInfo(objects[iListPos]).TKSerialRec
        , TSerialInfo(objects[iListPos]).UsedInBatch);

        {set used amounts}
        with NewSerialInfo, TKSerialRec do begin
          UsedElsewhere := TSerialInfo(objects[iListPos]).UsedElsewhere;
          if bAdd and (not bSplitBatch)
          then UsedInThisLine := BuyQty - QtyUsed - UsedElsewhere;
//          then UsedInThisLine := Round(BuyQty - QtyUsed - UsedElsewhere);

          if not bAdd then begin
//            UsedInBatch := Round(QtyUsed + UsedElsewhere);
//            UsedInThisLine := Round(QtyUsed + UsedElsewhere);
            UsedInBatch := QtyUsed + UsedElsewhere;
            UsedInThisLine := QtyUsed + UsedElsewhere;
          end;{if}

          if Sold and (not bSplitBatch) then begin
            if bAdd then begin
              UsedInBatch := 0;
//              UsedInThisLine := Round(QtyUsed);
              UsedInThisLine := QtyUsed;
            end;{if}
          end;{if}

        end;{with}

        {add line}
        slTo.AddObject(slFrom[iListPos], NewSerialInfo);
      end
    else begin
      {edit existing line in "To" list}
      with TSerialInfo(slTo.objects[iBatchPos]), TKSerialRec do begin

        {modify used amounts}
        if bAdd then
          begin
            if Sold then
              begin
                UsedInThisLine := UsedInThisLine + UsedInBatch;
                UsedInBatch := 0;
              end
            else begin
//              UsedInBatch := Round(BuyQty);
//              UsedInThisLine := Round(UsedInBatch - QtyUsed - UsedElsewhere);
              UsedInBatch := BuyQty;
              UsedInThisLine := UsedInBatch - QtyUsed - UsedElsewhere;
            end;{if}
          end
        else begin
//          UsedInBatch := Round(QtyUsed + UsedElsewhere);
//          UsedInThisLine := Round(QtyUsed + UsedElsewhere);
          UsedInBatch := QtyUsed + UsedElsewhere;
          UsedInThisLine := QtyUsed + UsedElsewhere;
        end;{if}

        {modify item description}
        slTo[iBatchPos] := GetSerialDescription(TSerialInfo(slTo.objects[iBatchPos])
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
    with TSerialInfo(slTo.Objects[iBatchPos]) do begin
//      if TKSerialRec.Sold then UsedInThisLine := Round(TKSerialRec.QtyUsed - UsedInBatch)
//      else UsedInThisLine := Round(UsedInBatch - TKSerialRec.QtyUsed - UsedElsewhere);
      if TKSerialRec.Sold then UsedInThisLine := TKSerialRec.QtyUsed - UsedInBatch
      else UsedInThisLine := UsedInBatch - TKSerialRec.QtyUsed - UsedElsewhere;
      {recalculate description of picked batch}
      slTo[iBatchPos] := GetSerialDescription(TSerialInfo(slTo.Objects[iBatchPos]), TRUE);
    end;{with}
  end;{if}

  Result := iBatchPos;

end;

Function GetSerialPicked(slUsed : TStrings) : real;
var
  iPos : integer;
begin
  {count how many items have been picked}
  Result := 0;
  if Assigned(slUsed) then begin
    For iPos := 0 to (slUsed.Count - 1) do begin
      with TSerialInfo(slUsed.objects[iPos]), TKSerialRec do begin
        if bBatch then
          begin
            Result := Result + UsedInThisLine
          end
        else Result := Result + 1;
      end;{with}
    end;{for}
  end;{if}
end;

function GetSerialDescription(SerialInfo : TSerialInfo; bUsed : boolean) : string;
{calculates new description for item}
var
  rLeft, rTotal : real;
begin
  with SerialInfo do begin
    if bBatch then
      begin
        if (Trim(TKSerialRec.SerialNo) = '') then Result := 'Batch - ' + Trim(TKSerialRec.BatchNo) + ' ('
        else Result := 'Batch - ' + Trim(TKSerialRec.BatchNo) + ' (' + Trim(TKSerialRec.SerialNo) + ') (';

        if bUsed then
          begin
//            if TKSerialRec.Sold then iLeft := Round(TKSerialRec.BuyQty - (TKSerialRec.QtyUsed - UsedInBatch))
//            else iLeft := Round(UsedInThisLine)
            if TKSerialRec.Sold then rLeft := TKSerialRec.BuyQty - (TKSerialRec.QtyUsed - UsedInBatch)
            else rLeft := UsedInThisLine
          end
        else rLeft :=  TKSerialRec.BuyQty - UsedInBatch;
//        else iLeft :=  Round(TKSerialRec.BuyQty - UsedInBatch);

//        iTotal := Round(TKSerialRec.BuyQty);
        rTotal := TKSerialRec.BuyQty;

//        if TKSerialRec.Sold then Result := Result + IntToStr(Round(iTotal - iLeft)) + ' of '
//        + IntToStr(Round(iTotal)) + ') ' + TKSerialRec.OutDoc
//        else Result := Result + IntToStr(iLeft) + ' of ' + IntToStr(Round(iTotal)) + ')';
        if TKSerialRec.Sold then Result := Result + MoneyToStr(rTotal - rLeft, TKSysRec.QuantityDP)
        + ' of ' + MoneyToStr(rTotal, TKSysRec.QuantityDP) + ') ' + TKSerialRec.OutDoc
        else Result := Result + MoneyToStr(rLeft, TKSysRec.QuantityDP) + ' of '
        + MoneyToStr(rTotal, TKSysRec.QuantityDP) + ')';
      end
    else Result := Trim(TKSerialRec.SerialNo);

    if (Trim(TKSerialRec.InMLoc) <> '') and (TKSysRec.MultiLocn > 0)
    and (SetupRecord.FilterSerialBinByLocation = 0)
    then  Result := Result + ' [' + TKSerialRec.InMLoc + ']';
  end;{with}
end;

function NoOfSerialNumbers(SerialNumbers : TStringList; TKStockRec : TBatchSKRec) : real;
var
  iPos : integer;
begin
  if (not assigned(SerialNumbers)) then Result := 0
  else begin
    Result := 0;
    For iPos := 0 to SerialNumbers.Count - 1 do begin
      with TSerialInfo(SerialNumbers.Objects[iPos]) do begin
        if bBatch then Result := Result + (UsedInThisLine * WhatisOne(TKStockRec))
        else Result := Result + 1;
      end;{with}
    end;{for}
  end;{if}
end;

procedure CopySerials(slFrom, slTo : PStringList);
var
  iPos : integer;
  SerialInfo : TSerialInfo;
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
        SerialInfo := TSerialInfo.Create;
        SerialInfo.CopyFrom(TSerialInfo(slFrom^.Objects[iPos]));
        slTo^.AddObject(slFrom^[iPos], SerialInfo);
      end;{for}
    end;{if}
  end;{if}
end;

function AskForSerialNumbers(TXLineRec : TTXLineRec) : boolean;
begin
  {Show serial numbers screen}
  with TFrmSerial.Create(application) do begin
    try
      rRequired := Round(ABS(TXLineRec.TKTLRec.Qty)) / WhatIsOne(TXLineRec.TKStockRec);
      sStockCode := TXLineRec.TKTLRec.StockCode;
      bRefund := TXLineRec.TKTLRec.Qty < 0;

      CopySerials(@TXLineRec.SerialNumbers, @TStringList(lstUsed.Items));

      Result := ShowModal = mrOK;
      if Result then CopySerials(@TStringList(lstUsed.Items), @TXLineRec.SerialNumbers);
    finally
      Release;
    end;{try}
  end;{with}
end;



end.
