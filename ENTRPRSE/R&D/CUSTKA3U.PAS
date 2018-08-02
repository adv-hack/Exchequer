Unit CuStkA3U;


Interface

Uses GlobVar,
     VARRec2U,
     VarConst,
     CuStkA4U;



  Function Get_LastLineNo(cc  :  Str20)  :  LongInt;

  Procedure Stock_AddCustAnal(IdR     :  IDetail;
                              GetSRec :  Boolean;
                              Mode    :  Byte);

  Function Chk_OSLines(CKAnal  :  CKAnalType;
                       CStkRec :  CuStkType)  :  Boolean;



 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   ETStrU,
   ETDateU,
   BtrvU2,
   VarFposU,
   ComnUnit,
   BTKeys1U,
   ComnU2,
   CurrncyU,
   MiscU,
   SysU1,
   SysU2,
   {SysU3,}
   BTSupU1,
   {$IFDEF EXSQL}
    SQLUtils,
    {$IFNDEF EXDLL}
    Excep2U,
    {$ELSE}
    ErrLogs,
    Profile,
    {$ENDIF}
   {$ENDIF}
   InvListU;


   { ================================================}
   {  Replicated in PostingU, TCheckCust }
   { ================================================}

   { ====== Function to Return Last Line No ========= }

   Function Get_LastLineNo(cc  :  Str20)  :  LongInt;

   Const
     Fnum      =  MLocF;
     Keypath   =  MLK;

   Var
     KeyS,
     KeyChk  :  Str255;

   Begin
     Result:=1;

     KeyChk:=PartCCKey(MatchTCode,MatchSCode)+FullCustCode(cc);

     Keys:=KeyChk+Full_CuStkLKey(cc,65535);

     Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

     If (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
       Result:=MLocCtrl^.CuStkRec.csLineNo+1;

     Get_LastLineNo:=Result;

   end;


   { ================================================}
   {  Replicated in PostingU, TCheckCust }
   { ================================================}

   { ============= Procdure to maintain location deductions ============= }

   Procedure Stock_AddCustAnal(IdR     :  IDetail;
                               GetSRec :  Boolean;
                               Mode    :  Byte);


   Const
     Fnum      =  MLocF;
     Keypath   =  MLSecK;
     Fnum2     =  IdetailF;
     Keypath2  =  IdCAnalK;


   Var
     KeyS,
     KeyChk  :  Str255;

     GenStr  :  Str20;
     n       :  Byte;

     OStat,
     OStat2  :  Integer;

     TmpKPath,
     TmpStat
             :  Integer;
     UseNext,
     TmpRecAddr,
     LAddr
             :  LongInt;

     KeepRec,
     NewRec,
     RunOk,
     Locked  :  Boolean;

     OldId   :  Idetail;
     Res : Integer;


   Begin

     Locked:=BOff;

     OldId:=Id;

     OStat:=Status;

     RunOk:=BOn;

     If (Not EmptyKey(IdR.CustCode,CustKeyLen)) and (Is_FullStkCode(IdR.StockCode)) and (AnalCuStk)
        and (Not (IdR.IdDocHed In QuotesSet)) and (IdR.LineNo>0) and (RunOk) then
     Begin
     {$IFDEF EXSQL}
       Res := -1;
(* MH 16/11/2009: Removed Stored Proc call at JW's request as it appears to be slower than Btrieve via the SQL Emulator!
  //PR: 16/07/2010 Removed from Toolkits as well (at JW's request.)
       if SQLUtils.UsingSQLAlternateFuncs then
       begin
         If (GetSRec) and (Stock.StockCode<>IDR.StockCode) then
           Global_GetMainRec(StockF,IDR.StockCode);

         If (Stock.CalcPack) then
           IDR.QtyMul:=1;

         IDR.Qty := 1;

         Res := StockAddCustAnal(SetDrive, LJVar(IDR.CustCode, 6), LJVar(IDR.StockCode, 16), IDR.PDate, IDR.FolioRef,
                                 IDR.AbsLineNo, IDR.Currency, Ord(IDR.IdDocHed), IDR.LineType,
                                 DetLTotal(IdR,BOn,BOff,0.0)*DocNotCnst, Mode);

         if Res < 0 then
         {$IFNDEF EXDLL}
           AddErrorLog('Error calling stored procedure StockAddCustAnal: ' + SQLUtils.LastSQLError +
                       '. Reverting to standard function.', '', 3);
         {$ELSE}
           AddErrorLog('Save Transaction Line', 'Error calling stored procedure StockAddCustAnal: ' + SQLUtils.LastSQLError +
                       '. Reverting to standard function.');
         {$ENDIF}

       end;
*)

       if Res < 0 then
     {$ENDIF}
       begin
         KeepRec:=BOff;

         With IdR do
           KeyChk:=PartCCKey(MatchTCode,MatchSCode)+Full_CuStkKey(CustCode,StockCode);

         Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyChk);

         NewRec:=(Status=4) and (Mode<>1);

         If ((StatusOk) or (NewRec))  then
         With IdR do
         Begin

           If (NewRec) then
           With MLocCtrl^,CuStkRec do
           Begin
             RunOk:=BOn;
             Locked:=BOn;

             UseNext:=Get_LastLineNo(CustCode);

             ResetRec(Fnum);

             RecPFix:=MatchTCode;

             SubType:=MatchSCode;

             csLineNo:=UseNext;

             csCode1:=Full_CuStkLKey(CustCode,csLineNo);
             csCode2:=Full_CuStkKey(CustCode,StockCode);
             csCode3:=Full_CuStkKey2(CustCode,StockCode);

             csCustCode:=CustCode;
             csStockCode:=StockCode;

             If (GetSRec) and (Stock.StockCode<>StockCode) then
             Begin
               Global_GetMainRec(StockF,StockCode);

             end;

             csStkFolio:=Stock.StockFolio;
             //HV 02/12/2015, JIRA-15768, On Telesales Screen defaulting line-type value based on selected Stock Code
             csLineType:=Stock.StkLinkLT;

           end
           else
             RunOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyChk,KeyPath,Fnum,BOn,Locked,LAddr);

           If (RunOk) and (Locked) then
           With MLocCtrl^,CuStkRec do
           Begin

             If (Mode=1) then {* its a deduct check if any other lines have it, else delete it *}
             Begin
               TmpKPath:=GetPosKey;

               TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOff,BOff);

               KeyChk:=LineType+Full_CuStkKey(CustCode,StockCode);

               KeyS:=KeyChk;

               Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

               KeepRec:=(StatusOk) and (CheckKey(KeyS,KeyChk,Length(KeyChk),BOff)) and
                        (FullRunNoKey(IdR.FolioRef,IdR.AbsLineNo)<>FullRunNoKey(Id.FolioRef,Id.AbSLineNo));

               TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOn,BOff);

               Id:=OldId;
             end
             else
               KeepRec:=BOn;


             If (KeepRec) then
             Begin
               If (Mode<>1) and (IdDocHed In SalesSplit-CreditSet) then
               Begin
                 csLastDate:=PDate;
                 csLPCurr:=Currency;

                 If (Stock.CalcPack) then
                   QtyMul:=1;


                 Qty:=1;

                 csLastPrice:=DetLTotal(IdR,BOn,BOff,0.0)*DocNotCnst;

               end;

               If (NewRec) then
                 Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath)
               else
               Begin
                 Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

                 OStat2:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
               end;

             end
             else
             Begin

               Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

             end;

             Report_BError(Fnum,Status);

           end;
         end; {With..}

       end;

     end; {If no cust, or stock code}

     Id:=OldId;

     Status:=OStat;

   end; {Proc..}


   { ==== Function to check if any o/s order lines exisit for this stock/account combo ==}

   Function Chk_OSLines(CKAnal  :  CKAnalType;
                        CStkRec :  CuStkType)  :  Boolean;

   Const
     Fnum     =  IDetailF;
     Keypath  =  IdCAnalK;

   Var
     KeyS,
     KeyChk   :  Str255;

     OldStat  :  Integer;

   Begin
     Result:=BOff;

     OldStat:=Status;

     With CStkRec do
     Begin

       With CKAnal do
         If (IsaC) then
           KeyChk:=StkLineType[SOR]
         else
           KeyChk:=StkLineType[POR];

       KeyChk:=KeyChk+Full_CuStkIKey(CsCustCode,csStockCode);

       KeyS:=KeyChk;


       Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

       Result:=(StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff));

     end;

     Status:=OldStat;

     Chk_OSLines:=Result;
   end;







end.