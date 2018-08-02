unit Uplift;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses
  Dialogs,
  SysUtils,
  WinProcs,
  GlobVar,
  {$IFDEF WIN32}
  VarRec2U,
  {$ELSE}
    VRec2U,
  {$ENDIF}
  VarConst,
  VarCnst3;

Function EX_UPDATEUPLIFT (Const TransRef  : PChar;
                          Const TransLine : LongInt;
                          Const StockCode : PChar;
                          Const UpliftAmt : Double) : SmallInt;
                          {$IFDEF WIN32} STDCALL {$ENDIF}
                          EXPORT;

Function EX_UPDATEUPLIFT2 (Const LockTrans : Boolean;
                           Const TransRef  : PChar;
                           Const TransLine : LongInt;
                           Const StockCode : PChar;
                           Const UpliftAmt : Double) : SmallInt;
                          {$IFDEF WIN32} STDCALL {$ENDIF}
                          EXPORT;

implementation

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
{$IFDEF WIN32}
  BtrvU2,
  BTSupU1,
  SysU2,
  ComnU2,
  ComnUnit,
  CurrncyU,
  BtKeys1U,
{$ELSE}
  BtrvU16,
  BtSup1,
  BtSup2,
{$ENDIF}
  FIFOLU,
  DLLSrBom,
  DLLErrU,
  BTS1,
  //PR: 28/10/2011 v6.9
  AuditNotes,
  AuditNoteIntf;

Function EX_UPDATEUPLIFT2 (Const LockTrans : Boolean;
                           Const TransRef  : PChar;
                           Const TransLine : LongInt;
                           Const StockCode : PChar;
                           Const UpliftAmt : Double) : SmallInt;
Const
  StkAdjCnst :  Array[BOff..BOn] of Integer    = (-1, 1);
  KPath      :  Array[BOff..BOn] of Integer  = (MiscBtcK,MiscNdxK);
  SrNoLen    =  20;
  BatchLen   =  10;

Var
  Key1, Key2, Key3, Key4, Key5, KeyChk, KeySer           : Str255;
  StkLocked,
  InvLocked, IdLocked, FILocked, BySerial, WantUpd, MLocLocked : Boolean;
  LockResult, WantMLoc : boolean;
  RNum, TmpQty, DiscValue, OldUplift, NewUplift               : Double;

  SerNos                         : ^TBatchSRLinesRec;
  SerialRec                      : ^TBatchSerialRec;
  SKey                           : PChar;
  Res, LNo                       : LongInt;
  I                              : SmallInt;
  TmpId                          : IDetail;
  TempStock                      : StockRec;
  LAddr                          : longint;


  //PR: 07/03/2017 ABSEXCH-17813/ABSEXCH-18283 Function to calculate serial no cost
  //               correctly. Adapted from Invctsuu.UpdateSNos
  function SerialCost(const IdRec : IDetail) : Double;
  begin
    with IdRec do
    begin
      If (ShowCase) then
        Result :=Round_Up(CostPrice,Syss.NoCosDec)
      else
        Result:=Round_Up(Calc_StkCP(CostPrice,QtyMul,UsePack),Syss.NoCosDec);
    end; //with IdRec
  end;

Begin { Ex_UpdateUplift2 }

  LastErDesc:='';
  WantMLoc := False;

  If TestMode Then Begin
    { Display passed parameters }
    ShowMessage ('EX_UPDATEUPLIFT:' + #10#13 +
                 'TransRef: ' + StrPas(TransRef) + #10#13 +
                 'TransLine: ' + IntToStr(TransLine) + #10#13 +
                 'StockCode: ' + StrPas(StockCode) + #10#13 +
                 'UpliftAmt: ' + Format('%10.2f', [UpliftAmt]));
  End; { If }

  Result:=32767;

  { Get specified Transaction }
  Key1 := StrPas(TransRef);
  Result := Find_Rec(B_GetEQ, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, Key1);
  If (Result=0) Then Begin
    { Got Transaction - check type }  //PR: 24/11/2009 Added PCR & PJC
    If (Inv.InvDocHed In [PIN, PJI, POR, PDN, PPI, PCR, PJC]) Then Begin
      { HM 25/01/99: Check its not already posted }
      If (Inv.RunNo <= 0) And (Inv.Settled = 0.00) Then Begin
        { Lock Transaction }
        InvLocked := False;

        If LockTrans Then Begin
          {$IFDEF WIN32}
            LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key1,InvOurRefK,InvF,SilentLock,InvLocked);
            // Second condition when user presses 'Cancel'
            if (Not LockResult) or (LockResult and not InvLocked) then
              Result := 84;
          {$ELSE}
            Result:=(GetMultiRec(B_GetDirect,B_SingLock,Key1,InvOurRefK,InvF,SilentLock,InvLocked));
          {$ENDIF}
        End; { If }

        If (Result=0) And (InvLocked Or (Not LockTrans)) Then Begin
          { Get specified Transaction Line }
          Key2 := FullNomKey(Inv.FolioNum) + FullNomKey(TransLine);
          Result:=Find_Rec(B_GetEQ, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdLinkK, Key2);
          If (Result=0) Then Begin
            { Lock Transaction Line }
            IdLocked := False;
            {$IFDEF WIN32}
              LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key2,IdFolioK,IDetailF,SilentLock,IdLocked);
              // Second condition when user presses 'Cancel'
              if (Not LockResult) or (LockResult and (not IdLocked)) then
                Result := 84;
            {$ELSE}
              Result:=(GetMultiRec(B_GetDirect,B_SingLock,Key2,IdFolioK,IDetailF,SilentLock,IdLocked));
            {$ENDIF}

            If (Result=0) And IdLocked then Begin
              { Take copy of original line }
              TmpId := Id;

              { Check stock code matches one specified as parameter }
              If (Strip('B',[#0,#32],StrPas(StockCode)) = Strip('B',[#0,#32],Id.StockCode)) Then Begin
                { Get Stock Item for line }
                Key3 := FullStockCode(ID.StockCode);
                Result:=Find_Rec(B_GetEQ, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, Key3);
                If (Result=0) Then Begin
                  { Lock Stock Record }
                  StkLocked := False;
                  {$IFDEF WIN32}
                    LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key3,StkCodeK,StockF,SilentLock,StkLocked);
                    if (not LockResult) or (LockResult and (not StkLocked)) then
                      Result := 84;
                  {$ELSE}
                    Result:=(GetMultiRec(B_GetDirect,B_SingLock,Key3,StkCodeK,StockF,SilentLock,StkLocked));
                  {$ENDIF}

                  if (Result = 0) and StkLocked then //get mloc record
                  with ID do
                  begin    //PR: 09/11/2011 v6.9 Don't try to update stock location for description stock item. ABSEXCH-11580
                    WantMLoc := (Trim(MLocStk) <> '') and Syss.UseMLoc and (Stock.StockType <> 'D');
                    if WantMLoc then
                    begin
                      Key5 := MLocFixCode[BOff]+Full_MLocLKey(MLocStk,StockCode);
                      Result:=Find_Rec(B_GetEQ, F[MLocF], MLocF, RecPtr[MLocF]^, MLSecK, Key5);
                      if Result = 0 then
                      begin
                        LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key5,MLSecK,MLocF,SilentLock,MLocLocked);
                        if (not LockResult) or (LockResult and (not StkLocked)) then
                          Result := 284;
                      end
                      else
                        Result := Result + 200;
                    end;
                  end;

                  If (Result=0) And StkLocked and (MLocLocked or not WantMLoc) then Begin
                    { Round cost to lose rounding errors }

                    { Calculate Line Discount }
                    With Id Do
                      DiscValue:=Calc_PAmount(Round_Up(NetValue,Syss.NoNetDec),Discount,DiscountChr);

                    Case Stock.StkValType Of
                      { FIFO/LIFO }
                      'F',  { HM 19/10/99: Don't updated FIFO for POR as done at PDN stage automatically }
                      'L' : If (Inv.InvDocHed <> POR) Then Begin

                              //PR: 01/03/2017 ABSEXCH-17813/ABSEXCH-18283
                              //Use Fifo routine to set correct values for CostPrice in Fifo rec
                              OldUplift := FIFO_SetCPrice(TmpId, 0);
                              Id.CostPrice := UpliftAmt;
                              NewUplift := FIFO_SetCPrice(Id, 0);

                              { Check for FIFO/LIFO items to update }
                              KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,Strip('B',[#0],
                                                MakeFIDocKey(Inv.OurRef,Stock.StockFolio,Id.ABSLineNo)));
                              Key4:=KeyChk;
                              Result:=Find_Rec(B_GetGEq,F[MiscF],MiscF,RecPtr[MiscF]^,MiscNdxK,Key4);
                              If (Result = 0) And CheckKey(KeyChk,Key4,Length(KeyChk),BOn) Then Begin
                                { Lock FIFO record }
                                FILocked := False;
                                {$IFDEF WIN32}
                                  LockResult := GetMultiRec(B_GetDirect,B_SingLock,Key4,MiscNdxK,MiscF,SilentLock,FiLocked);
                                  if not LockResult or (LockResult and not FiLocked) then
                                    Result := 84;
                                {$ELSE}
                                  Result:=(GetMultiRec(B_GetDirect,B_SingLock,Key4,MiscNdxK,MiscF,SilentLock,FiLocked));
                                {$ENDIF}

                                If (Result=0) And FiLocked then Begin
                                  With MiscRecs^.FIFORec Do Begin
                                    { Subtract original unit price from FIFO Cost and add in new unit price }
                                    FIFOCost := FIFOCost - OldUplift + NewUplift;
                                  End; { With }

                                  { Update FIFO }
                                  Result := Put_Rec(F[MiscF],MiscF,RecPtr[MiscF]^,MiscNdxK);

                                  If (Result <> 0) Then Begin
                                    { Error updating FIFO record - adjust error by 300 to indicate FIFO }
                                    Result := Result + 300;
                                  End; { If }
                                End { If }
                                Else Begin
                                  { Error locking FIFO record - adjust error by 300 to indicate FIFO }
                                  Result := Result + 300;
                                End; { Else }
                              End; { If }

                              //PR: 06/03/2017 ABSEXCH-17813/ABSEXCH-18283 Exchequer updates costprice on stock record with FIFO, so do likewise
                              if Result = 0 then
                              begin
                                if Id.UsePack then
                                  Stock.CostPrice := Round_Up(FIFO_GetAVCost(Stock, Id.MLocStk), Syss.NoCosDec)
                                else
                                  Stock.CostPrice := Round_Up(FIFO_GetAVCost(Stock, Id.MLocStk) * Id.QtyMul, Syss.NoCosDec);
                              end;

                            End; { If }

                      { Serial Numbers }
                      //PR: 13/02/07 If Valuation method is SerialBatchAverage then treat it as average.
                      'R' :   if Stock.SerNoWAvg = 0 then
                              Begin
                              New(SerNos);
                              New(SerialRec);
                              SKey := StrAlloc(255);
                              StrPCopy (SKey, Inv.OurRef);
                              { CJS 2012-11-13 - ABSEXCH-13585 - APF UpdateUplift fails on inserted lines }
                              LNo := Id.LineNo;
                              Res := EX_GETLINESERIALNOS(SerNos, SizeOf(SerNos^), SKey, LNo, 0);
                              If (Res = 0) Then Begin
                                //PR: 07/03/2017 ABSEXCH-17813/ABSEXCH-18283 Set CostPrice here as we use it below for serial cost calculation
                                Id.CostPrice := UpliftAmt;
                                For I := Low(SerNos^) To High(SerNos^) Do Begin
                                  With SerNos^[I] Do Begin
                                    If (Strip('B',[#32,#0],SerialNo) <> '') Or (Strip('B',[#32,#0],BatchNo) <> '') Then Begin
                                      { Line Set - update cost for Serial No }
                                      FillChar(SerialRec^, SizeOf (SerialRec^), #0);
                                      SerialRec^.SerialNo := SerialNo;
                                      SerialRec^.BatchNo  := BatchNo;

                                      { Work out whether Serial or Batch }
                                      BySerial := (Not Emptykey(SerialNo,20));

                                      { Build key }
                                      If (BySerial) then
                                        KeySer:=MFIFOCode+MSernSub+LJVar(UpCaseStr(Strip('B',[#32],SerialNo)),SrNoLen)
                                      else
                                        KeySer:=MFIFOCode+MSernSub+LJVar(UpCaseStr(Strip('B',[#32],BatchNo)),BatchLen);
                                      KeyChk := KeySer;

                                      { Get Serial Numbers for line by Stock Key }
                                      Status:=Find_Rec(B_GetGEq,F[MiscF],MiscF,RecPtr[MiscF]^,KPath[BySerial],KeySer);

                                      {PR: 27/10/05 - May be more than one record with same serial/batch number}
                                      While StatusOK And CheckKey(KeyChk,KeySer,Length(KeyChk),BOn) And
                                            (MiscRecs^.SerialRec.StkFolio <> Stock.StockFolio) Do
                                        Status:=Find_Rec(B_GetNext,F[MiscF],MiscF,RecPtr[MiscF]^,KPath[BySerial],KeySer);

                                      While StatusOK And CheckKey(KeyChk,KeySer,Length(KeyChk),BOn) And
                                            (MiscRecs^.SerialRec.StkFolio=Stock.StockFolio) Do Begin
                                        { Serial Numbers - check the input doc is set }
                                        { Batch Numbers - update batch header only }
                                        WantUpd := (((Not BySerial) And (Not MiscRecs^.SerialRec.BatchChild)) Or BySerial) And
                                                   ((CheckKey(Inv.OurRef, MiscRecs^.SerialRec.InDoc,Length(Inv.OurRef),BOff)
                                                         and (MiscRecs^.SerialRec.BuyLine=Id.ABSLineNo)) Or
                                                    (CheckKey(Inv.OurRef,MiscRecs^.SerialRec.InOrdDoc,Length(Inv.OurRef),BOff)
                                                         and (MiscRecs^.SerialRec.InOrdLine=Id.ABSLineNo)));

                                        If WantUpd Then Begin
                                          { Lock Record }
                                          {$IFDEF WIN32}
                                          {PR: 27/10/05 - May be more than one record with same serial/batch number,
                                           so can't use GetEq - we've positioned on the correct record above, so
                                           can use GetDirect for locking.}

                                          {If GetMultiRec(B_GetEq,B_SingLock,KeySer,
                                                         KPath[BySerial],MiscF,SilentLock,GlobLocked) then}
                                          if GetMultiRecAddr(B_GetDirect,B_SingLock,KeySer,KPath[BySerial],
                                                              MiscF,SilentLock,GlobLocked,LAddr) then
                                          begin

                                             SetDataRecOfs(MiscF,LAddr);

                                             If (LAddr<>0) then
                                                Res :=GetDirect(F[MiscF],MiscF,RecPtr[MiscF]^,KPath[BySerial],0);

                                             if (Res = 0) and not GlobLocked then
                                               Res := 84;
                                            {Res := 0;
                                            if not GlobLocked then Res := 84;}

                                          end
                                          Else
                                            Res := 84;
                                          {$ELSE}
                                          Res := GetMultiRec(B_GetEq,B_SingLock,KeySer,
                                                             KPath[BySerial],MiscF,SilentLock,GlobLocked);
                                          {$ENDIF}

                                          If (Res = 0) Then Begin
                                            { Apply uplift }
                                            //PR: 02/03/2017 ABSEXCH-17813/ABSEXCH-18283 Calculate correct cost price for each serial rec,
                                            //                             e.g if QtyMul is 10 and Id.Qty is 10, then we'll have 100 serial nos
                                            MiscRecs^.SerialRec.SerCost :=
                                              (MiscRecs^.SerialRec.SerCost - Round_Up(SerialCost(TmpId), Syss.NoCosDec) +
                                                                               Round_Up(SerialCost(Id), Syss.NoCosDec));



                                            { Update database }
                                            Result:=Put_Rec(F[MiscF],MiscF,RecPtr[MiscF]^,KPath[BySerial]);

                                            If (Not BySerial) Then Begin
                                              { Have updated Batch Header - exit loop immediately }
                                              Break;
                                            End; { If }
                                          End { If }
                                          Else Begin
                                            { Lock error on serial numbers }
                                            Result := 1001;
                                          End; { Else }
                                        End; { If }

                                        { Get next Serial Number record }
                                        Status:=Find_Rec(B_GetNext,F[MiscF],MiscF,RecPtr[MiscF]^,KPath[BySerial],KeySer);
                                      End; { While }
                                    End { If }
                                    Else Begin
                                      { Line not set - exit loop }
                                      Break;
                                    End; { Else }
                                  End; { With SerNos^[I] }
                                End; { For I }
                              End { If }
                              Else Begin
                                { Error getting Serial Numbers }
                                Result := 1001;
                              End; { Else }

                              StrDispose(SKey);
                              Dispose(SerialRec);
                              Dispose(SerNos);

                              //PR: 01/03/2017 ABSEXCH-17813/ABSEXCH-18283 Exchequer updates costprice on stock record with serial/batch, so do likewise
                              if Result = 0 then
                              begin
                                Stock.CostPrice := Round_Up(Stock.CostPrice - TmpId.CostPrice + UpliftAmt, Syss.NoCosDec);
                              end;
                            End;
                    End; { Case }

                    If (Result = 0) Then Begin
                      { Update transaction totals }
                      TmpQty := Round_Up(Id.Qty * Id.QtyMul, Syss.NoQtyDec);

                      Inv.TotalCost := Inv.TotalCost - Round_Up(TmpQty * TmpId.CostPrice, Syss.NoCosDec);
                      Id.CostPrice := UpliftAmt;
                      Inv.TotalCost := Inv.TotalCost + Round_Up(TmpQty * Id.CostPrice, Syss.NoCosDec);

                      { Update Detail Line }
                      Result := Put_Rec(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK);
                    End; { If }

                    { HM 19/10/99: Don't do for POR as done when received as PDN }
                    If (Result = 0) And StkLocked And (Inv.InvDocHed <> POR) and (not WantMLoc or MLocLocked) Then Begin
                      { Update Stock Cost Price }
                      Case Stock.StkValType Of
                        { Average }
                        'A',  //PR 13/02/07 Added SerialBatchAverage handling
                        'R': if (Stock.StkValType = 'A') or (Stock.SerNoWAvg <> 0) then
                             Begin
                                { Reverse out existing price }
                                Rnum:=(TmpId.DeductQty*StkAdjCnst[(TmpId.IdDocHed In StkOpoSet+StkAdjSplit)]);
                                Stock.QtyInStock := Stock.QtyInStock + RNum; { HM 19/10/99: Remove from stock first }
                                FIFO_AvgVal(Stock,TmpId,Rnum);

                                { apply new line }
                                Stock.QtyInStock := Stock.QtyInStock - RNum; { HM 19/10/99: Return into stock }
                                FIFO_AvgVal(Stock,Id,-Rnum);

                                { Reverse out existing price }
                                if WantMLoc and MLocLocked then
                                begin
                                  TempStock := Stock;
                                  Rnum:=(TmpId.DeductQty*StkAdjCnst[(TmpId.IdDocHed In StkOpoSet+StkAdjSplit)]);
                                  MLocCtrl.MStkLoc.lsQtyInStock := MLocCtrl.MStkLoc.lsQtyInStock + RNum; { HM 19/10/99: Remove from stock first }
                                  TempStock.QtyInStock := MLocCtrl.MStkLoc.lsQtyInStock;
                                  TempStock.CostPrice := MLocCtrl.MStkLoc.lsCostPrice;
                                  FIFO_AvgVal(TempStock,TmpId,Rnum);

                                 { apply new line }
                                  MLocCtrl.MStkLoc.lsQtyInStock := MLocCtrl.MStkLoc.lsQtyInStock - RNum; { HM 19/10/99: Return into stock }
                                  TempStock.QtyInStock := MLocCtrl.MStkLoc.lsQtyInStock;
                                  FIFO_AvgVal(TempStock,Id,-Rnum);

                                  MLocCtrl.MStkLoc.lsCostPrice := TempStock.CostPrice;
                                end;

                              End;

                        { Last Cost }
                        'C' : Begin
                                Rnum := Round_Up (Currency_ConvFT (Id.NetValue + Id.CostPrice - DiscValue,
                                                                   Id.Currency,
                                                                   Stock.PCurrency,
                                                                   UseCoDayRate),
                                                                   Syss.NoNetDec);
                                Stock.CostPrice:=Rnum;
                                if WantMLoc then
                                  MLocCtrl.MStkLoc.lsCostPrice := Stock.CostPrice;
                              End;
                      End; { Case }

                      Result := Put_Rec(F[StockF],StockF,RecPtr[StockF]^,StkCodeK);

                      if (Result = 0) and WantMLoc and MLocLocked then
                      begin
                        Result := Put_Rec(F[MLocF],MLocF,RecPtr[MLocF]^,MLSecK);

                        if Result <> 0 then
                          Result := Result + 400;
                      end;
                    End; { If }

                    If (Result = 0) And InvLocked Then Begin
                      { Line updated OK - Update Invoice }
                      Result := Put_Rec(F[InvF],InvF,RecPtr[InvF]^,InvOurRefK);
                    End; { If }
                  End  { If }
                  Else Begin
                    { Lock failed - adjust error by 200 to indicate Stock Item }
                    Result := Result + 200;
                  End; { If }
                End { If }
                Else Begin
                  { Invalid Stock Item - adjust error by 200 to indicate Stock Item }
                  Result := Result + 200;
                End; { Else }
              End { If }
              Else Begin
                { Stock Code does not match that specified }
                Result := 204;
              End; { Else }

              If StkLocked Then Begin
                { Unlock Stock Record }
                Status:=Find_Rec(B_Unlock,F[StockF],StockF,RecPtr[StockF]^,StkCodeK,Key3);
              End; { If }

              If MLocLocked Then Begin
                { Unlock Location Record }
                Status:=Find_Rec(B_Unlock,F[MLocF],MLocF,RecPtr[MLocF]^,MLK,Key5);
              End; { If }

              If IdLocked Then Begin
                { Unlock Transaction line }
                Status:=Find_Rec(B_Unlock,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,Key2);
              End; { If }
            End { If }
            Else Begin
              { Lock failed - adjust error by 100 to indicate Transaction Line }
              Result := Result + 100;
            End; { Else }
          End { If }
          Else Begin
            { Invalid Transaction line - adjust error by 100 to indicate Transaction Line }
            Result := Result + 100;
          End; { Else }

          If InvLocked Then Begin
            { Unlock Transaction header }
            Status:=Find_Rec(B_Unlock,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,Key1);
          End; { If }
        End; { If }
      End { If }
      Else Begin
        { Transaction is posted or allocated }
        Result := 1002;
      End; { Else }
    End { If }
    Else Begin
      { Invalid Transaction Type }
      Result := 1000;
    End; { Else }
  End; { If }

  //PR: 28/10/2011 v6.9
  if Result = 0 then
    AuditNote.AddNote(anTransaction, Inv.FolioNum, anEdit);

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(93,Result); { Use Ex_UpdateUplift Code }

End;  { Ex_UpdateUplift2 }



Function EX_UPDATEUPLIFT (Const TransRef  : PChar;
                          Const TransLine : LongInt;
                          Const StockCode : PChar;
                          Const UpliftAmt : Double) : SmallInt;
Begin { UpdateUplift }
  LastErDesc:='';

  Result := Ex_UpdateUplift2 (True, TransRef, TransLine, StockCode, UpliftAmt);

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(93,Result);

End;  { UpdateUplift }


end.
