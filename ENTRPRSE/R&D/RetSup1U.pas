Unit RetSup1U;


Interface

Uses GlobVar,
     VarRec2U,
     VarConst,
     Classes,
     ExWrap1U;

{$IFDEF SOPDLL}
  {$DEFINE SOP}
  {$UNDEF EXDLL}

{$ENDIF}
{$IFNDEF OLE}
{$IFNDEF EXDLL}

{$I DEFOVR.Inc}

Type
  {rwPAction
             60 = ?CR (WOff)
             61 = ?CR (WOff) + PIN/PDN pr SIN/SDN/SOR/SOR + POR
             62 = ?IN (Repaired) For repair of stock
             63 = Just write off + Repair optionally
             64 = Issue repaired qty back to stock via ADJ on its own.
             65 = SCR on its own, but issuing stock back.
             66 = SCR + Replacement stock + Issue back.

             68 = Generate SQU from Return - scrapped in final version although mode still around

             For PRN 60 & 61 PCR are non stock as stock already taken out by PRN
             For SRN 60 & 61 SCR is optionally non stock depending of rwRepairInv set as if repaired, can use credit to put back into stock
}

  tRetWizRec  =  Record
                    rwRepairInv,
                    rwRSCharge,
                    rwCanMatch,
                    rwMatch,
                    rwIgnoreSer,
                    rwSetEQty,
                    rwRun,
                    rwAppNewPrice,
                    rwWarrantyPrice,
                    rwAppendMode,
                    rwB2BRepair
                              :  Boolean;

                    rwRetReason,
                    rwWizMode :  Byte;

                    rwPAction,
                    rwSAction,
                    rwPBased,   {0 = PIN, 1 = PDN}
                    rwSBased    {0 = SIN, 1 = SOR, 2 = SOR + B2B POR}
                              :  Byte;
                    rwRunNo   :  LongInt;

                    rwLineQty :  Double;
                    rwDate    :  LongDate;
                    rwPr,rwYr :  Byte;

                    rwSuppCode:  Str10;
                    rwRetRef  :  Str10;
                    rwLoc     :  Str10;

                    rwSerialRef,
                    rwYourRef :  Str20;

                    rwDocHed  :  DocTypes;
                    rwDoc     :  InvRec;
                    rwDocLine :  Idetail;
                    rwSerialRec
                              :  MiscRec;

                    rwUseSystemDate: Boolean;
                  end;



  Procedure Set_rwBasedStatus(RetWizRec  :  tRetWizRec;
                              Var  InvR  :  InvRec;
                                   SetComp
                                         :  Boolean);

  Function  Genereate_ActionDocFromRet(RetWizRec  :  tRetWizRec;
                                       ExLocal    :  TdExLocal;
                                   Var InvR       :  InvRec)  :  Boolean;

  Function  Genereate_RetFromDoc(RetWizRec  :  tRetWizRec;
                                 ExLocal    :  TdExLocal;
                             Var InvR       :  InvRec)  :  Boolean;

  Procedure Re_CalcKitRet(KitFolio :  LongInt;
                          IdR      :  IDetail);

  Procedure RetAuto_PickQty(InvR       :  InvRec;
                            Mode       :  Byte;
                        Var Picked,
                            Repaired   :  Boolean;
                            AOwner     :  TObject);


  Function Ret_Check4Pick(Fnum,
                          Keypath  :  Integer;
                          InvR     :  InvRec;
                          SOPLoc   :  Str10;
                          RetWizRec:  tRetWizRec;
                          Mode     :  Byte)  :  Boolean;

  Function CheckExsiting_RET(OInv    :  InvRec;
                             OId     :  IDetail;
                        Var RETRef   :  Str10;
                            ScanLine :  Boolean)  :  Boolean;


  Function Ret_Check4Stk(Fnum,
                         Keypath  :  Integer;
                         InvR     :  InvRec;
                         RetWizRec:  tRetWizRec;
                         Mode     :  Byte)  :  Boolean;

{$ENDIF} // EXDLL


{$IFNDEF EXDLL}



{$ENDIF} // EXDLL
{$ENDIF} // OLE



 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$IFNDEF OLE}
{$IFNDEF EXDLL}

 Uses
   Forms,
   SysUtils,
   Controls,
   Dialogs,
   ETStrU,
   ETMiscU,
   ETDateU,
   BTKeys1U,
   ComnUnit,
   ComnU2,
   BTSupU1,
   InvListU,
   CurrncyU,
   SysU1,
   SysU2,
   MiscU,
   Event1U,
   InvLst2U,
   InvCT2SU,
   PassWR2U,
   SOPCt3U,
   Warn1U,
   InvCTSuU,
   {$IFDEF SOP}
     InvLst3U,
     StkSernU,
   {$ENDIF}

   WOPCT1U,
   DiscU3U,
   {$IFDEF CL_On}
    LedgSupU,
    NoteSupU,
  {$ENDIF}
   ExThrd2U,
   DelVRunU,
   SalTxL2U,
   BtrvU2,
   PromptPaymentDiscountFuncs;




   { == Procedure to Set Status based upon action == }

   Procedure Set_rwBasedStatus(RetWizRec  :  tRetWizRec;
                               Var  InvR  :  InvRec;
                                    SetComp
                                          :  Boolean);

   Var
     Result   :  Byte;

   Begin
     Result:=0;

     With RetWizRec, InvR  do
     Begin
       Case InvDocHed of
         PRN  :  Begin
                   Case rwPAction of
                     60  :  Result:=2;
                     61  :  If (rwPBased=1) then
                              Result:=4
                            else
                              Result:=3;

                     62  :  Result:=5;
                     63  :  Result:=6;
                   end;

                   If (SetComp) then
                     Result:=7;
                 end;

         SRN  :  Begin
                   Case rwPAction of
                     60,65
                         :  Result:=2;
                     61  :  Case rwSBased of
                              1  :  Result:=5;
                              2  :  Result:=3;
                              3  :  Result:=4;
                            end; {Case..}

                     62  :  Result:=6;
                     63  :  Result:=7;
                     64  :  Result:=8;
                     66  :  Result:=5;
                     {68  :  Result:=5;}
                   end;


                   If (SetComp) then
                     Result:=9;
                 end;

       end; {Case..}

     end;

     InvR.TransMode:=Result;
   end;



   {$IFDEF SOP}
  { ===== Proc to Transfer all Serial nos from one document to another ===== }

  Function  Ret_TxFrSNos(RetWizRec  :  tRetWizRec;
                         InvR       :  InvRec;
                         OId,IdR    :  IDetail;
                         InvMode    :  Boolean;
                     Var SerCount   :  Double)  :  Boolean;


  Const
    Fnum      = MiscF;
    Keypath   = MIK;

  Var
    KeyS,KeyChk  :  Str255;

    DiscP,
    ThisSer,
    DocCostP,
    {SerCount,}
    SerGot       :  Double;
    SalesDoc,
    FoundOk,
    FoundAll,
    Ok2Count,
    LOk,
    Locked       :  Boolean;

    B_Func       :  Integer;

    LAddr        :  LongInt;

    OrdR         :  InvRec;

    MRec         :  MiscRec;



  Procedure Update_SerialRec;

  Begin
    With MiscRecs^.SerialRec,InvR,IdR do
    Begin

      If (InvMode) then
      Begin
        If (Sold) and (Not ReturnSNo) then
        Begin
          Ok2Count:=BOn;

          If (MiscRecs^.SerialRec.BatchChild) or (Not MiscRecs^.SerialRec.BatchRec) then
          Begin
            B_Func:=B_GetLessEq; KeyS:=KeyS+NdxWeight;
          end;

          If (MiscRecs^.SerialRec.BatchChild) then
          Begin
            Batch_SetUse(Fnum,Keypath,0,ThisSer,DocCostP,InvR,IdR,26);

          end
          else
            If (Not MiscRecs^.SerialRec.BatchRec) then
              SERN_SetUse(Fnum,Keypath,ThisSer,DocCostP,InvR,IdR,26);
        end;

      end
      else
      Begin
        If (SalesDoc) then
        Begin
          Ok2Count:=BOn;

          ReturnSNo:=BOn;

          RetDoc:=InvR.OurRef;
          RetDocLine:=IdR.ABSLineNo;

          If (RetWizRec.rwWizMode=99) and (Copy(OutDoc,1,3)=DocCodes[PRN]) then
            OutDoc:=RetDoc;
        end
        else
        If (Not Sold) then
        Begin
          Ok2Count:=BOn;
          B_Func:=B_GetLessEq; KeyS:=KeyS+NdxWeight;

          If (MiscRecs^.SerialRec.BatchRec) then
          Begin
            ThisSer:=IdR.SerialQty;

            Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

            Make_BatchSetUse(Fnum,Keypath,InvR,IdR,ThisSer,LAddr,1);
          end
          else
          Begin
            ThisSer:=1.0;

            SERN_SetUse(Fnum,Keypath,ThisSer,DocCostP,InvR,IdR,1);
          end;
        end;
      end; {If returning serial no for sale}

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      Report_BError(Fnum,Status);

      If (LAddr<>0) then
        Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
    end; {With..}
  end;

  Begin
    LOK := False;
    FoundAll:=(IdR.SerialQty=0.0);  SerCount:=0.0;

    SerGot:=IdR.SerialQty; DocCostP:=0.0;

    OrdR:=RetWizRec.rwDoc;  LAddr:=0;
                                                                                                       {* We are back to back repair mode *}
    SalesDoc:=(OrdR.InvDocHed In SalesSplit) or ((InvMode) and (OrdR.InvDocHed In StkRetSalesSplit)) or (RetWizRec.rwWizMode=99);

    If (RetWizRec.rwWizMode<>11) then
    Begin


      If (OrdR.InvDocHed In StkRetPurchSplit) and (SerGot<0) and ((OId.LineNo<>1) or (OrdR.InvDocHed In StkRetPurchSplit)) then
        SerGot:=SerGot*DocNotCnst;


      If (OId.StockCode<>Stock.StockCode) then
      Begin
        Global_GetMainRec(StockF,OId.StockCode);
      end;

      If (Is_SerNo(Stock.StkValType)) and (Not FoundAll) then
      Begin

        If (SalesDoc) then
          KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(Stock.StockFolio)+#1)
        else
          KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(Stock.StockFolio));


        KeyS:=KeyChk+NdxWeight;


        Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundAll) do
        With MiscRecs^.SerialRec do
        Begin
          B_Func:=B_GetPRev;

          Ok2Count:=BOff;

          With OrdR,OId do
            If (SalesDoc) then
              FoundOk:=((CheckKey(OurRef,OutDoc,Length(OurRef),BOff)) and (SoldLine=ABSLineNo)) or ((CheckKey(OurRef,RetDoc,Length(OurRef),BOff)) and (RetDocLine=ABSLineNo))
            else
              FoundOk:=((CheckKey(OurRef,InDoc,Length(OurRef),BOff)) and (BuyLine=ABSLineNo)) or (((CheckKey(OurRef,RetDoc,Length(OurRef),BOff)) and (RetDocLine=ABSLineNo)) and (OId.IdDocHed In StkRetSalesSplit));

          If (FoundOk) then
          With InvR,IdR do
          Begin
            LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

            If (LOk) and (Locked) then
            Begin
              MRec:=MiscRecs^;

              Update_SerialRec;

              {* Don't include a batch child in a purch conversion, as it might have already
                 been sold in which case there would be twice as many entries to change, only
                 change the main one *}

              If ((Not MRec.SerialRec.BatchChild) or (SalesDoc)) and (Ok2Count) then
              Begin
                If (BatchRec) then
                Begin
                  If (SalesDoc) or (BatchChild) then
                    SerCount:=SerCount+QtyUsed
                  else
                    SerCount:=SerCount+BuyQty;
                end
                else
                  SerCount:=SerCount+1.0;
              end;
            end; {If Locked..}
          end;

          FoundAll:=(SerCount>=SerGot);

          If (Not FoundAll) then
            Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        end; {While..}
      end; {If SNo..}
    end {If single serial no.}
    else
    Begin
      Ok2Count:=FoundAll;

      If (Not FoundAll) then {* We have none to find! *}
      Begin
        If (RetWizRec.rwSerialRec.SerialRec.NoteFolio<>0) then
        Begin
          SetDataRecOfs(Fnum,RetWizRec.rwSerialRec.SerialRec.NoteFolio);  {* Establish new Path *}

          Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

          LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);
        end;

        If (Not LOK) then
        Begin
          KeyS:=MFIFOCode+MSERNSub+RetWizRec.rwSerialRec.SerialRec.SerialCode;

          LOk:=GetMultiRecAddr(B_GetEq,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);
        end;

        LOk:=(LOk and (MiscRecs^.SerialRec.SerialCode+MiscRecs^.SerialRec.BatchNo=RetWizRec.rwSerialRec.SerialRec.SerialCode+RetWizRec.rwSerialRec.SerialRec.BatchNo));

        If (LOk) and (Locked) then
        Begin
          Update_SerialRec;

          FoundAll:=Ok2Count;
        end;
      end;
    end;

    Result:=FoundAll;

  end; {Func..}

{$ENDIF}


  { == Procedure back to back a repair == }

  Procedure Process_B2BRepair(RetWizRec  :  tRetWizRec;
                              PInv,InvR  :  InvRec;
                              PId,IdR    :  IDetail;
                              TmpKPath,
                              TmpKPath2  :  Integer);

  Const
    Fnum     =  IDetailF;
    Keypath  =  IdLinkK;
    Fnum2    =  InvF;
    Keypath2 =  InvFolioK;


   Var
     GotSers,
     Locked,
     GotHed  :  Boolean;


     TmpStat :  Integer;

     LAddr,
     LineRecAddr,
     TmpRecAddr,
     TmpRecAddr2,
     HedAddr
             :  LongInt;

     OrigQtyPick,
     GotSerCount
             :  Double;

     KeyS,
     KeyChk  :  Str255;

     TmpId   :  IDetail;

     TmpInv
             :  InvRec;



   Begin
     GotSerCount:=0.0;  GotSers:=BOff;  OrigQtyPick:=0.0;

     If (PId.SOPLink<>0) and (PID.SOPLineNo<>0) and (PID.SSDUseLine) then
     Begin
       TmpId:=Id; TmpInv:=Inv;

       TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

       TmpStat:=Presrv_BTPos(Fnum2,TmpKPath2,F[Fnum2],TmpRecAddr2,BOff,BOff);

       KeyS:=FullIdKey(PID.SOPLink,PId.SOPLineNo);

       Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

       If (StatusOk) and ((RetWizRec.rwSAction in [62]) or (Id.IdDocHed In WOPSplit)) then
       Begin
         Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LineRecAddr);

         If (Ok) and (Locked) then
         Begin
           KeyS:=FullNomKey(Id.FolioRef);

           Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

           If (StatusOk) then
           Begin
             Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked,HedAddr);

             If (Ok) and (Locked) then
             With Id do
             Begin
               If (IdDocHed In WOPSplit) then
               Begin
                 OrigQtyPick:=QtyPick;

                 If (((IdR.Qty*IdR.QtyMul)+QtyPick)<=Qty_OS(Id)) then
                  QtyPick:=(IdR.Qty*IdR.QtyMul)+QtyPick
                 else
                   QtyPick:=Qty_OS(Id);

                 {$IFDEF SOP}

                   If (Is_FullStkCode(Id.StockCode)) and (Is_SerNo(Stock.StkValType)) and (Not (RetWizRec.rwSAction in [61])) then
                   Begin
                     SerialQty:=(QtyPick-OrigQtyPick);

                     RetWizRec.rwWizMode:=99;

                     GotSers:=DelVRunU.TxfrSNos(PInv,Inv,PId,Id,BOn,GotSerCount);

                     {GotSers:=Ret_TxFrSNos(RetWizRec,Inv,PId,Id,BOff,GotSerCount);}

                     If (Not GotSers) then
                       SerialQty:=GotSerCount;
                   end
                   else
                     SerialQty:=0.0;
                 {$ENDIF}

                 If (Is_FullStkCode(Id.StockCode)) and (Stock.MultiBinMode) and (Not (RetWizRec.rwSAction in [61])) then
                 Begin

                   With TSOPRunFrm.Create(Application.MainForm) do
                   Try
                     BinQty:=(QtyPick-OrigQtyPick);

                     GotSers:=B2BBNos(RetWizRec.rwDoc,Inv,TmpId,Id,BinQty,GotSerCount);

                       If (Not GotSers) then
                         BinQty:=GotSerCount;
                   Finally
                     Free;
                   end;
                 end
                 else
                   BinQty:=0.0;


                 If (Is_FullStkCode(Id.StockCode)) and (Not GotSers) or (Stock.MultiBinMode) then {* We may need to manually assign serial nos *}
                 Begin
                   If (Stock.MultiBinMode) then
                     BinQty:=(OrigQtyPick+GotSerCount+QtyDel)*DocNotCnst
                   else
                     SerialQty:=(OrigQtyPick+GotSerCount+QtyDel)*DocNotCnst; {* Restore so we are prompted on repair invoice to shell out *}

                   If (Stock.MultiBinMode) or (Is_SerNo(Stock.StkValType)) then
                   Begin

                     Control_SNos(Id,Inv,Stock,1+(25*Ord(IdDocHed In StkRetSalesSplit)),Application.MainForm);

                   end;
                 end;

                 Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

                 Report_BError(Fnum,Status);

                 If (LineRecAddr<>0) then
                   TmpStat:=UnLockMultiSing(F[Fnum],Fnum,LineRecAddr);

               end
               else
               Begin
                 If (Is_FullStkCode(StockCode)) then {* Reverse out stock effect *}
                   Stock_Deduct(Id,Inv,BOff,BOn,0);


                 QtyDel:=QtyDel-IdR.Qty;

                 If (QtyDel<0.0) then
                   QtyDel:=0.0;

                 {SerialQty:=QtyDel;}


                 If (Is_FullStkCode(StockCode)) then
                 Begin
                   Stock_Deduct(Id,Inv,BOn,BOn,0);
                 end;

                 If (Qty_OS(Id)<>0.0) then  {* Restore Line *}
                  LineType:=StkLineType[IdDocHed];

                 {$IFDEF SOP}

                   If (Is_FullStkCode(Id.StockCode)) and (Is_SerNo(Stock.StkValType)) then
                   Begin
                     SerialQty:=IdR.Qty;

                     RetWizRec.rwWizMode:=99;

                     
                     GotSers:=Ret_TxFrSNos(RetWizRec,Inv,PId,Id,BOff,GotSerCount);

                     If (Not GotSers) then
                       SerialQty:=GotSerCount;
                   end
                   else
                     SerialQty:=0.0;
                 {$ENDIF}


                 If (Is_FullStkCode(Id.StockCode)) and (Not GotSers) or (Stock.MultiBinMode) then {* We may need to manually assign serial nos *}
                 Begin

                   SerialRetQty:=IdR.Qty-GotSerCount; {* Restore so we are prompted on repair invoice to shell out *}

                   If (Stock.MultiBinMode) or (Is_SerNo(Stock.StkValType)) then
                   Begin

                     Control_SNos(Id,Inv,Stock,1+(25*Ord(IdDocHed In StkRetSalesSplit)),Application.MainForm);

                   end;
                 end;

                 SerialRetQty:=QtyDel; {* Restore so we are prompted on repair invoice to shell out *}

                 Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

                 Report_BError(Fnum,Status);

                 If (LineRecAddr<>0) then
                   TmpStat:=UnLockMultiSing(F[Fnum],Fnum,LineRecAddr);

                 If (Inv.RunNo=Set_RetRunNo(Inv.InvDocHed,BOff,BOn)) and (Qty_OS(Id)<>0.0) then
                 With Inv do
                 Begin
                   RunNo:=Set_RetRunNo(InvDocHed,BOff,BOff);

                   TransMode:=0;

                   Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

                   Report_BError(Fnum2,Status);

                 end;
               end;

               If (HedAddr<>0) then
                 TmpStat:=UnLockMultiSing(F[Fnum2],Fnum2,HedAddr);

             end; {If Header locked..}
           end; {If Statusok..}

         end; {If Locked..}
       end; {Found linked line}


       TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

       TmpStat:=Presrv_BTPos(Fnum2,TmpKPath2,F[Fnum2],TmpRecAddr2,BOn,BOff);

       ID:=TmpId;
       Inv:=TmpInv;
     end; {If its not a back to back repair..}
   end; {Proc..}


   { === Function to Return Action mode based on doctype === }

   Function Get_rwBased(RetWizRec  :  tRetWizRec)  :  Byte;

   Begin
     Result := 0;
     With RetWizRec do
     Begin
       If (rwWizMode In [0,10,11]) then
       Begin
         Case rwWizMode of
           0  :  Result:=50;
          10  :  Result:=51;
          11  :  Result:=52;
         end; {Case..}
       end
       else
       Begin
         If (rwPAction In [60,65]) or (rwSAction<>rwPAction) then {* we are in credit side of cycle, so force credit note *}
           Result:=0
         else
           If (rwPAction In [68]) then {* we need to generate a quotation *}
             Result:=8
           else
           Begin
             If (rwDocHed In StkRetPurchSplit) then
               Result:=rwPBased
             else
               Result:=rwSBased;
           end;
         Result:=Result+60;
       end;
     end; {With..}
   end;


   { === Procedure to Generate Action Transactions from ?RN === }


   Function  Genereate_ActionDocFromRet(RetWizRec  :  tRetWizRec;
                                        ExLocal    :  TdExLocal;
                                    Var InvR       :  InvRec)  :  Boolean;


   Type
     tAllocRec  =  Record
                     DocFolio   :  LongInt;
                     BaseAmount,
                     OwnAmount
                                :  Double;
                     OwnCurrency:  Byte;
                   end;

   Const
      Fnum     =  IDetailF;
      Keypath  =  IdFolioK;
      Fnum2    =  InvF;
      Keypath2 =  InvRNoK;

   Var
     Flg,
     Locked,
     SetRepairLine,
     GotHed  :  Boolean;

     UOR     :  Byte;

     TmpStat :  Integer;
     LAddr,
     DocRecAddr,
     LineRecAddr,

     HedAddr,
     LastSOPLink,
     LastRSGL
             :  LongInt;

     MatchVal
             :  Real;

     SerCount,
     SettleCredit,
     BaseSettleCredit

             :  Double;
     GotSerCount,
     ThisReCharge,
     RechargeTot
             :  Double;

     KeyS,
     KeyChk  :  Str255;

     TmpId,
     NewId   :  IDetail;

     CreditInv
             :  InvRec;

     AllocMap:  tList;
     AllocRec:  ^tAllocRec;




   { == Funcs to manipulate allocation memory list == }

   Procedure Get_AllocRec;

   Var
     TmpRecAddr,
     TmpKPath,
     al       :  LongInt;
     FoundOk  :  Boolean;

     ThisSettle,
     BaseSettle
              :  Double;

     SetInv   :  InvRec;

   Begin
     FoundOk:=BOff;

     If (TmpId.SOPLink<>0) then
     Begin
       SetInv:=Inv;

       TmpKPath:=Keypath2;

       TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOff,BOff);

       KeyS:=FullNomKey(TmpId.SOPLink);


       Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,InvFolioK,KeyS);

       FoundOk:=(StatusOk) and (Inv.InvDocHed In DocAllocSet) and (Inv.CustCode=SetInv.CustCode);

       TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOn,BOff);

       Inv:=SetInv;
     end;
     
     If (FoundOk) then
     Begin
       FoundOk:=BOff;

       If (Assigned(AllocMap)) then
       Begin
         With AllocMap do
           For al:=0 to Count-1 do
           Begin
             AllocRec:=List[al];

             {$B-}
             FoundOk:=(Assigned(AllocRec) and (AllocRec^.DocFolio=TmpId.SOPLink));
             {$B+}

             If (FoundOk) then
               Break;
           end;
       end
       else
         AllocMap:=tlist.Create;

       Try
         With AllocMap do
         Begin
           If (Not FoundOk) then
           Begin
             New(AllocRec);

             Blank(AllocRec^,Sizeof(AllocRec^));
           end;

           With Id,AllocRec^ do
           Begin
             DocFolio:=TmpId.SOPLink;

             ThisSettle:=Round_Up(InvLTotal(Id,BOn,(Inv.DiscSetl*Ord(Inv.DiscTaken)))+VAT-ThisReCharge,2);

             OwnAmount:=OwnAmount+ThisSettle;

             UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

             BaseSettle:=Round_Up(Conv_TCurr(ThisSettle,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);

             BaseAmount:=BaseAmount+BaseSettle;


             OwnCurrency:=Currency;

             SettleCredit:=SettleCredit+ThisSettle;

             BaseSettleCredit:=BaseSettleCredit+BaseSettle;

             If (Not FoundOk) then
               Add(AllocRec);
           end;

         end;
       except
         FreeandNil(AllocMap);
       end; {Try..}
     end; {If docs match..}
   end;{Proc..}


   {* Manufacture Repair lines *}
   Function Add_ExtraLines(Mode :  Byte)  :  Boolean;

   Var
     RepId  :  IDetail;

     Procedure Reset_RepId;

     Begin
       With RepId do
       Begin
         Qty:=0.0;
         QtyPWOff:=0.0;
         QtyMul:=0.0;
         NetValue:=0.0;
         NomCode:=0;
         VATCode:=#32;
         Discount:=0.0;
         DiscountChr:=#0;

         // MH 25/03/2009: Added support for 2 new discounts for Advanced Discounts
         Discount2:=0.0;
         Discount2Chr:=#0;
         Discount3:=0.0;
         Discount3Chr:=#0;

         DeductQty:=0.0;
         CostPrice:=0.0;
         Blank(StockCode,Sizeof(StockCode));
       end;

     end;

   Begin

     RepId:=TmpId;  Result:=BOn;


     Case Mode of
       0  :  Begin
               Reset_RepId;

               With RepId do
               Begin
                 Desc:='Repair Invoice.';
                 Ok:=Gen_InvLine(RepId,RetWizRec.rwDoc,Fnum,Keypath,RetWizRec.rwSAction,BOff,MatchVal);

                 Desc:='~~~~~~~~~~~~';
                 Ok:=Gen_InvLine(RepId,RetWizRec.rwDoc,Fnum,Keypath,RetWizRec.rwSAction,BOff,MatchVal);


               end;
             end;

       1  :  Begin
               With RepId do
               Begin
                 QtyPWOff:=QtyPWOff*DocNotCnst;
                 SSDUplift:=SSDUplift*DocNotCnst;


                 NetValue:=CostPrice;
                 CostPrice:=0.0;

                 If Global_GetMainRec(StockF,TmpId.StockCode) then
                 Begin
                   If (B2BLineNo<>0) then
                    NomCode:=B2BLineNo
                  else
                  Begin

                   {$IFDEF SOP}
                      Stock_LocNSubst(Stock,TmpId.MLocStk);
                   {$ENDIF}

                     If (Stock.StockType=StkBillCode) then
                       NomCode:=Stock.NomCodes[5]
                     else
                       NomCode:=Stock.NomCodes[4];

                      If (NomCode=0) then
                        NomCode:=TmpId.NomCode;
                   end;

                   Blank(StockCode,Sizeof(StockCode));

                   If (RetWizRec.rwSAction In [61]) then
                     Desc:=Trim(Desc)+'. (Auto Warrnty.)'+Trim(DocPRef)
                   else
                     Desc:=Trim(Desc)+'. (Auto Rep.)'+Trim(DocPRef);

                   If ((RetWizRec.rwSAction In [61,62]) {or (Is_FIFO(Stock.StkValType)) or (Is_SerNo(Stock.StkValType))}) then
                     Result:=Gen_InvLine(RepId,RetWizRec.rwDoc,Fnum,Keypath,RetWizRec.rwSAction,BOff,MatchVal)
                   else
                     Result:=BOff;


                 end;

               end;
             end;

       2  :  Begin
               With RepId do
               Begin
                 If Global_GetMainRec(StockF,TmpId.StockCode) then
                 Begin

                   {$IFDEF SOP}
                      Stock_LocNSubst(Stock,TmpId.MLocStk);
                   {$ENDIF}

                     If (Stock.StockType=StkBillCode) then
                       NomCode:=Stock.NomCodes[5]
                     else
                       NomCode:=Stock.NomCodes[4];

                      If (NomCode=0) then
                        NomCode:=TmpId.NomCode;

                   NetValue:=CostPrice;
                   CostPrice:=0.0;
                   Discount:=0.0;
                   DiscountChr:=#0;
                   // MH 25/03/2009: Added support for 2 new discounts for Advanced Discounts
                   Discount2:=0.0;
                   Discount2Chr:=#0;
                   Discount3:=0.0;
                   Discount3Chr:=#0;

                   Blank(StockCode,Sizeof(StockCode));

                   Desc:=Trim(Desc)+'. (Auto Stk Movemnt.)'+Trim(DocPRef);

                   Ok:=Gen_InvLine(RepId,RetWizRec.rwDoc,Fnum,Keypath,RetWizRec.rwSAction,BOff,MatchVal);

                   If (Ok) then
                   Begin
                     RepId:=TmpId;

                     NetValue:=CostPrice;
                     CostPrice:=0.0;

                     Discount:=0.0;
                     DiscountChr:=#0;
                     // MH 25/03/2009: Added support for 2 new discounts for Advanced Discounts
                     Discount2:=0.0;
                     Discount2Chr:=#0;
                     Discount3:=0.0;
                     Discount3Chr:=#0;

                     Blank(StockCode,Sizeof(StockCode));

                     Desc:=Trim(Desc)+'. (Auto Stk Movemnt.)'+Trim(DocPRef);

                     QtyPWOff:=QtyPWOff*DocNotCnst;
                     SSDUplift:=SSDUplift*DocNotCnst;
                     NomCode:=Stock.NomCodes[2];
                     Discount:=0.0;
                     DiscountChr:=#0;
                     // MH 25/03/2009: Added support for 2 new discounts for Advanced Discounts
                     Discount2:=0.0;
                     Discount2Chr:=#0;
                     Discount3:=0.0;
                     Discount3Chr:=#0;

                     Result:=Gen_InvLine(RepId,RetWizRec.rwDoc,Fnum,Keypath,RetWizRec.rwSAction,BOff,MatchVal);

                   end
                   else
                     Result:=BOff;


                 end;

               end;
             end;

     end; {Case..}

   end;


   Begin
     AllocMap:=Nil;

     If (Not (RetWizRec.rwSAction In [63])) then
     Begin
       GotHed:=BOff; MatchVal:=0;  TmpStat:=0;  UOr:=0; Flg:=BOff;  GotSerCount:=0.0;

       HedAddr:=0;  Locked:=BOff; RechargeTot:=0.0; LastRSGL:=0;  SettleCredit:=0.0;

       BaseSettleCredit:=0.0;

       SetRepairLine:=(RetWizRec.rwSAction In [62]);

       KeyS:=FullIdkey(RetWizRec.rwDoc.FolioNum,1);  {* Remove any existing lines *}

       KeyChk:=FullNomKey(RetWizRec.rwDoc.FolioNum);

       Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

       While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
       With Id do
       Begin

         TmpId:=Id;  TmpId.JAPDedType:=Ord(RetWizRec.rwRepairInv);

         ThisReCharge:=0.0;

         Application.ProcessMessages;

         If (Not GotHed) and (SOP_CheckPickQty(TmpId,RetWizRec.rwSAction)) and (Not (RetWizRec.rwSAction In [64])) then
         Begin

          GotHed:=Get_InvHed(RetWizRec.rwDoc,BOff,RetWizRec.rwRunNo,Fnum2,Keypath2,Get_rwBased(RetWizRec),HedAddr,BOff);

          // CJS 2015-10-20 - ABSEXCH-16891 - Cancel PPD button showing on SCR/PCR
          if GotHed then
            ClearPPDFields(Inv);

         end;

         If ((GotHed) or (RetWizRec.rwSAction In [64])) and (SOP_CheckPickQty(TmpId,RetWizRec.rwSAction)) then
         Begin
           Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LineRecAddr);

           If (Ok) and (Locked) then
           Begin


             If (Not (RetWizRec.rwSAction In [64])) then
             Begin
                                                    {* We do not require this adjustment as credit note now takes out of stock *}
               If ((RetWizRec.rwSAction In [62]))  {or ((RetWizRec.rwSAction In [61]) and (NomIOFlg=1) and (TmpId.NetValue=0.0))} then {* Repair Inv, Set narrative line, or replace warranty at cost *}
               Begin
                 If (SetRepairLine) then
                 Begin
                   Add_ExtraLines(0);
                   SetRepairLine:=BOff;
                 end;

                 With TmpId do
                 begin
                 If (IdDocHed in StkRetPurchSplit) and (CostPrice<>0.0) and (Is_FullStkCode(TmpId.StockCode)) then {* Reverse out effect of Repair, before replacing it *}
                 Begin
                   // CS 2011-08-31 ABSEXCH-11134: Reverted to previous version,
                   // using Cost Price plus Repair Price
                   If Add_ExtraLines(1) then
//                     TmpId.NetValue:=TmpId.CostPrice;
                     TmpId.NetValue:=TmpId.SSDSPUnit+TmpId.CostPrice;
                 end
                 else
                   If (IdDocHed in StkRetSalesSplit) {and (SSDSPUnit<>0.0)} and (Is_FullStkCode(TmpId.StockCode)) then {* For sales Repair use repar unit cost *}
                     TmpId.NetValue:=TmpId.SSDSPUnit;
                   TmpId.SSDSPUnit := Stock.SuppSUnit;
                 end;
               end
               else   {* Being moved at a different cost from original transaction, so we need to compensate, and adjust the credit note to refelct the movement. *}
                 If (RetWizRec.rwSAction In [60])  and (IdDocHed in StkRetPurchSplit) and (TmpId.CostPrice<>TmpId.NetValue) and (TmpId.CostPrice<>0.0) and (Is_FullStkCode(TmpId.StockCode)) and (RetWizRec.rwCanMatch) then
                 Begin
                   If Add_ExtraLines(2) then {* Force the COS account as the main account *}
                     TmpId.B2BLineNo:=Stock.NomCodes[2];
                 end;


               If ((RetWizRec.rwRSCharge) or (RetWizRec.rwAppNewPrice)) and (Is_FullStkCode(TmpId.StockCode)) then
               Begin
                 If (Stock.StockCode<>TmpId.StockCode) then
                   If (Not Global_GetMainRec(StockF,TmpId.StockCode)) then
                     ResetRec(StockF);
               end;

               If (RetWizRec.rwAppNewPrice) and (RetWizRec.rwSAction In [61,66]) and ((NOMIOFlg<>1) or (TmpId.NetValue<>0.0)) and (Is_FullStkCode(TmpId.StockCode)) then {* Apply new price, if not under zero warranty *}
               With TmpId do
               Begin
                 Flg:=BOn;
                 Calc_StockPrice(Stock,Cust,Inv.Currency,Qty,Inv.TransDate,NetValue ,Discount,DiscountChr,MLocStk,Flg,0);
                 PreviousBal:=NetValue;
               end;

               Ok:=Gen_InvLine(TmpId,RetWizRec.rwDoc,Fnum,Keypath,RetWizRec.rwSAction,BOff,MatchVal);

               If (RetWizRec.rwRSCharge) and (Is_FullStkCode(TmpId.StockCode)) and (RetWizRec.rwDocHed In StkRetSalesSplit) and (RetWizRec.rwSAction In [60,65]) then
               Begin

                 If (Stock.ReStockPcnt<>0.0) then
                 Begin
                   With Stock do
                   Begin

                     ThisReCharge:=Round_Up(Calc_PcntPcnt(InvLTotal(Id,BOn,(Inv.DiscSetl*Ord(Inv.DiscTaken))),ReStockPcnt,0.0,ReStockPChr,PcntChr),2);

                     If (ReStockPChr<>PcntChr) and (Inv.Currency>1) then
                     Begin
                       ThisReCharge:=Currency_ConvFT(ThisReCharge,0,Inv.Currency,USeCoDayRate);
                     end;
                   end;
                   RechargeTot:=RechargeTot+ThisReCharge;
                   NewID:=Id;
                 end;

               end;


             end
             else
             Begin
               Qty:=QtyPWoff;
               Ok:=BOn;

             end;


             If (Is_FullStkCode(Id.StockCode)) and (Id.Qty<>0.0) and (Ok) then
             Begin
               If ((RetWizRec.rwRepairInv) and (RetWizRec.rwSAction In [64,65])) or
                  ((RetWizRec.rwSAction In [61,66]) and (RetWizRec.rwSBased =1)) and
                  (Not RetWizRec.rwRun) then
               {* Its an invoice, so we need to re assign a Bin *}
               Begin
                 If (Stock.StockCode<>Id.StockCode) then
                   If (Not Global_GetMainRec(StockF,Id.StockCode)) then
                     ResetRec(StockF);

                 If (Stock.MultiBinMode) or ((RetWizRec.rwSAction In [61,66]) and (Is_SerNo(Stock.StkValType))) then
                 Begin
                   If (Stock.MultiBinMode) then
                     Id.BinQty:=0.0
                   else
                     Id.SerialQty:=0.0;

                   Control_SNos(Id,Inv,Stock,1,Application.MainForm);

                   If (Not (RetWizRec.rwSAction In [64])) then
                   Begin
                     Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

                     Report_BError(Fnum,Status);
                   end;

                 end;
               end;
             end;

             If (LineRecAddr<>0) then
               TmpStat:=UnLockMultiSing(F[Fnum],Fnum,LineRecAddr);



             {* Move serial nos, but only for repair sin, or repair pin? EN570 *}

             If (Is_FullStkCode(Id.StockCode)) and (Id.Qty<>0.0) {and (Not (RetWizRec.rwSAction In [64]))} then
             Begin

               If (((RetWizRec.rwRepairInv) and (RetWizRec.rwSAction In [60,65])) or (RetWizRec.rwSAction=64)) then
               Begin
                 {$IFDEF SOP}
                   If (RetWizRec.rwRepairInv) and (RetWizRec.rwSAction In [60,65]) or (RetWizRec.rwSAction=64) then
                     Ret_TxFrSNos(RetWizRec,Inv,TmpId,Id,BOn,GotSerCount)
                   else
                     DelVRunU.TxfrSNos(RetWizRec.rwDoc,Inv,TmpId,Id,BOn,SerCount);
                 {$ENDIF}
               end
               else
                 If (RetWizRec.rwSAction In [62]) and (TmpId.SSDUseLine) and (TmpId.IdDocHed In StkRetSalesSplit) and (Stock.MultiBinMode) then
                 Begin
                   Id.BinQty:=Id.Qty;

                   Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

                   Report_BError(Fnum,Status);

                   CreditInv:=RetWizRec.rwDoc;
                   CreditInv.InvDocHed:=SIN;  {* Fool it into thinking it is a sales doc *}

                   DelVRunU.TxfrBNos(CreditInv,Inv,TmpId,Id,BOn);
                 end;

             end;


             If (RetWizRec.rwSAction In [60,65]) and ((TmpId.NomIOFlg<>1) or (TmpId.NetValue<>0.0)) and (TmpId.SOPLink>0) and (RetWizRec.rwMatch) then {* Its a credit so we will need to allocate it *}
             Begin
               Get_AllocRec;
             end;

             If (RetWizRec.rwSAction In [61,62]) and (RetWizRec.rwDoc.InvDocHed In StkRetPurchSplit) and (TmpId.SSDUseLine)
                 and (TmpId.SOPLink<>0) and (TmpId.SOPLineNo<>0) then {* Its a back to back repair *}
             Begin
               Process_B2BRepair(RetWizRec,RetWizRec.rwDoc,Inv,TmpId,Id,Keypath,Keypath2);
             end;

             If (LineRecAddr<>0) then
             Begin
               SetDataRecOfs(Fnum,LineRecAddr);

               Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);
             end;
           end; {Locked..}
         end;

         Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


       end; {While..}

       If (GotHed) then  {* Store new Header *}
       Begin
         If (ReChargeTot<>0.0) and (Syss.NomCtrlCodes[RetSurcharge]<>0) then {Add in restock line}
         With Id do
         Begin
           Id:=NewId;

           Blank(StockCode,Sizeof(StockCode));

           Qty:=-1.0; QtyMul:=1.0;

           LineNo:=Inv.ILineCount;
           AbsLineNo:=LineNo;

           NomCode:=Syss.NomCtrlCodes[RetSurcharge];

           NetValue:=ReChargeTot;

           Discount:=0.0;
           DiscountChr:=#0;
           // MH 25/03/2009: Added support for 2 new discounts for Advanced Discounts
           Discount2:=0.0;
           Discount2Chr:=#0;
           Discount3:=0.0;
           Discount3Chr:=#0;

           Desc:='Re-stocking charge for returned stock';

           CalcVat(Id,Inv.DiscSetl);

           Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

           Report_BError(Fnum,Status);

           Inc(Inv.ILineCount);
         end;

         CalcInvTotals(Inv,ExLocal,(Not Inv.MANVAT),BOn);

         Set_DocAlcStat(Inv);  {* Set Allocation Status *}

         MatchVal:=ITotal(Inv);

         {$IFDEF CL_On}
          Add_Notes(NoteDCode,NoteCDCode,FullNomKey(Inv.FolioNum),Today,
                    Inv.OurRef+' was created from '+RetWizRec.rwDoc.OurRef+' / '+RetWizRec.rwDoc.YourRef+' '+RetWizRec.rwDoc.TransDesc,
                    Inv.NLineCount);

          {*Copy notes from each WOR into each ADJ*}

          CopyNoteFolio(NoteDCode,NoteDCode,FullNCode(FullNomKey(RetWizRec.rwDoc.FolioNum)),FullNCode(FullNomKey(Inv.FolioNum)),Inv.NLineCount);

          Inv.NLineCount:=Inv.NLineCount+RetWizRec.rwDoc.NLineCount;


        {$ENDIF}


         

         With RetWizRec do
         Begin
           If (rwRun) then
           With Inv do
           Begin
             {* Set Batch link? *};

             If (InvDocHed In SalesSplit) then
             Begin
               If (InvDocHed In CreditSet) then
                 BatchLink:=SOP_RunNo(RetWizRec.rwRunNo,InvDocHed)
               else
                 BatchLink:=SOP_RunNo(RetWizRec.rwRunNo,SIN);
             end
             else
             Begin
               If (InvDocHed In CreditSet) then
                 BatchLink:=SOP_RunNo(RetWizRec.rwRunNo,InvDocHed)
               else
                 BatchLink:=SOP_RunNo(RetWizRec.rwRunNo,PIN);
             end;


           end;

           {* Auto allocate the credit side *}
           With Inv do
           Begin
             Settled:=BaseSettleCredit*DocCnst[InvDocHed]*DocNotCnst;
             CurrSettled:=SettleCredit*DocCnst[InvDocHed]*DocNotCnst;
           end;
         end; {With..}

         Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

         Report_BError(Fnum2,Status);

         InvR:=Inv;

         TmpStat:=UnLockMultiSing(F[Fnum2],Fnum2,HedAddr);

         {* Update Accont Balance *}

         If (StatusOk) and (Not (Inv.InvDocHed In QuotesSet)) then
         With Inv do
         Begin
           If (Not Syss.UpBalOnPost) and (Not (Inv.InvDocHed In QuotesSet+PSOPSet)) then
             UpdateBal(Inv,(ConvCurrITotal(Inv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                    (ConvCurrICost(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                    (ConvCurrINet(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                    BOff,2);

           {* Deduct order value *}

             UpdateOrdBal(Inv,ConvCurrOrderTotal(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst,
                          0,0,BOff,0);

             {$IFDEF CL_On}

               With Inv do
               Begin


                 UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                 Inv.RemitNo:=RetWizRec.rwDoc.OurRef;

                 Match_Payment(Inv,Round_Up(Conv_TCurr(MatchVal,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2),MatchVal,23);

                 {* Will need multiple matches and allocation as one ?RN could come from multiple sources as long as they are
                    same account *}
                 If (RetWizRec.rwMatch) and (RetWizRec.rwSAction In [60,65]) and (Assigned(AllocMap)) then {* Need to match to original invoice as appropriate *}
                 Begin
                   {* match from list being built up per line *}

                   CreditInv:=Inv;

                   Try
                     With AllocMap do
                     Begin
                       For HedAddr:=0 to Pred(Count) do
                       Begin
                         AllocRec:=List[HedAddr];

                         If (Assigned(AllocRec)) then
                         With AllocRec^ do
                         Begin
                           KeyS:=FullNomKey(DocFolio);

                           Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,InvFolioK,KeyS);

                           If (StatusOk) and (CreditInv.CustCode=CustCode) and (InvDocHed In DocAllocSet) then
                           Begin
                             Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,InvFolioK,Fnum2,BOn,Locked,LineRecAddr);

                             If (Ok) and (Locked) then
                             Begin
                               SettleCredit:=Round_Up(Currency_Txlate(OwnAmount,OwnCurrency,Inv.Currency),2);

                               Settled:=Settled+(BaseAmount*DocCnst[InvDocHed]*DocNotCnst);
                               CurrSettled:=CurrSettled+(SettleCredit*DocCnst[InvDocHed]*DocNotCnst);

                               RemitNo:=CreditInv.OurRef;

                               Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,InvFolioK);

                               Report_BError(Fnum2,Status);

                               TmpStat:=UnLockMultiSing(F[Fnum2],Fnum2,LineRecAddr);

                               UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                               Match_Payment(Inv,BaseAmount,SettleCredit,3);
                             end;
                           end;
                         end;

                         Dispose(AllocRec);

                         List[HedAddr]:=nil;
                       end; {Loop..}
                     end; {AllocMap..}
                   Finally
                     FreeandNil(AllocMap);
                   end; {Try..}
                 end;
               end;

             {$ENDIF}

         end;


      end {If GotHed}
      else
        GotHed:=(RetWizRec.rwPAction=64);

      If (Assigned(AllocMap)) then {* Destroy memory map *}
      Begin
        Try
          With AllocMap do
          Begin
            For HedAddr:=0 to Pred(Count) do
            Begin
              AllocRec:=List[HedAddr];

              If (Assigned(AllocRec)) then
                Dispose(AllocRec);
            end;
          end; {With..}
        Finally
          FreeandNil(AllocMap);
        end; {Try..}
      end;
    end
    else
      GotHed:=BOn;

    Result:=GotHed;

   end; {Func..}


   { ======== Proc to Seek additional Desc lines, and add them to created return ===== }


  Procedure RET_SeekDescLines(Var  InvR  :  InvRec;
                                   IdR,NewId
                                         :  IDetail;
                                   KeyRes:  Integer;
                                   Mode  :  Byte);



  Const
    Fnum     =  IdetailF;
    Keypath  =  IdFolioK;


  Var

    KeyS,
    KeyChk    :   Str255;

    RecAddr,
    RecAddr2  :   LongInt;

    TmpId     :   Idetail;

  Begin

    RecAddr:=0; RecAddr2:=0;

    If ((Is_FullStkCode(Idr.StockCode)) or ((Not Is_FullStkCode(Idr.StockCode)) and (IdR.KitLink=0))) and (Idr.LineNo>0) then {* Exclude all autodeduct lines, and blank lines *}
    Begin

      Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Preserve DocPosn *}

      If (StatusOk) and (RecAddr<>0) then
      Begin

        SetDataRecOfs(Fnum,RecAddr);  {* Establish new Path *}

        Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

        KeyChk:=FullNomKey(Idr.FolioRef);
        KeyS:=FullIdKey(Idr.FolioRef,Idr.LineNo);

        If (StatusOk) then
          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))
             and (Id.KitLink<>0) and (Not Is_FullStkCode(Id.StockCode)) do
        Begin
          Status:=GetPos(F[Fnum],Fnum,RecAddr2);  {* Preserve DocPosn *}

          TmpId:=NewId;

          With TmpId do
          Begin
            Blank(StockCode,Sizeof(StockCode));

            Desc:=Id.Desc;
            NetValue:=Id.NetValue;

            If (Is_FullStkCode(Id.StockCode)) then
              StockCode:=Id.StockCode;
              
            CostPrice:=Id.CostPrice;
            LineNo:=InvR.ILineCount;
            ABSLineNo:=LineNo;
            DocLTLink:=0;
            KitLink:=FolioRef;
          end;

          Id:=TmpId;

          Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

          Inc(InvR.ILineCount);

          Report_BError(Fnum,Status);

          SetDataRecOfs(Fnum,RecAddr2);  {* Establish new Path *}

          Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
        end; {While..}


        SetDataRecOfs(Fnum,RecAddr);  {* Establish old Path *}

        Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyRes,0);

      end; {If POs foundOk..}

    end; {If line with poss desc lines}

  end; {Proc..}


  {* Return the warranty period expressed in days *}

  Function RETWTime2Days(Days       :  Byte;
                         SetMode    :  Byte)  :  Extended;
  Begin
    Result:=Days;

    Case  SetMode of
      1  :  Begin
              Result:=Trunc(Days*7);

            end;

      2  :  Begin
              Result:=Int(Days*30.57);
            end;

      3  :  Result:=Int(Days*365.25);
    end;{Case..}
  end;





   Function  Genereate_RetFromDoc(RetWizRec  :  tRetWizRec;
                                  ExLocal    :  TdExLocal;
                              Var InvR       :  InvRec)  :  Boolean;


   Const
      Fnum     =  IDetailF;
      Keypath  =  IdFolioK;
      Fnum2    =  InvF;
      Keypath2 =  InvRNoK;

   Var
     Flg,
     Locked,
     GotSers,
     NoWarranty,
     Abort,
     GotHed  :  Boolean;

     WarrantMode,
     UOR     :  Byte;

     TmpStat :  Integer;
     LAddr,
     DocRecAddr,
     LineRecAddr,

     HedAddr,
     LastSOPLink
             :  LongInt;

     WarrantDays
             :  Extended;
     MatchVal
             :  Real;

     OrigQty,
     GotSersCount
             :  Double;

     KeyI,
     KeyS,
     KeyChk  :  Str255;

     TmpId,
     NewId   :  IDetail;

   Begin
     Begin
       GotHed:=BOff; MatchVal:=0;  TmpStat:=0;  UOr:=0; Flg:=BOff;

       HedAddr:=0;  Locked:=BOff;  Abort:=BOff;  NoWarranty:=BOff;

       KeyS:=FullIdkey(RetWizRec.rwDoc.FolioNum,1);  {* Remove any existing lines *}

       KeyChk:=FullNomKey(RetWizRec.rwDoc.FolioNum);

       If (RetWizRec.rwWizMode=0) then
         Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS)
       else
       Begin
         Id:=RetWizRec.rwDocLine;

         Status:=0;
       end;

       While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not Abort) do
       With Id do
       Begin
         OrigQty:=Id.Qty;

         TmpId:=Id;  GotSers:=BOff; GotSersCount:=0.0;

         Application.ProcessMessages;

         If (Not GotHed) then
         Begin


          If (Trim(RetWizRec.rwRetRef)<>'') and (RetWizRec.rwAppendMode) then
          Begin
            KeyI:=RetWizRec.rwRetRef;

            Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,InvOurRefK,KeyI);

             If (StatusOk) then
             Begin
               GotHed:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyI,KeyPath2,Fnum2,BOff,Locked,HedAddr);

               // CJS 2015-10-20 - ABSEXCH-16891 - Cancel PPD button showing on SCR/PCR
               if GotHed then
                 ClearPPDFields(Inv);

             end;

             Abort:=Not GotHed;
          end
          else
          Begin
            If (RetWizRec.rwDoc.InvDocHed In StkRetSalesSplit+WOPSplit) then
            With RetWizRec do
            Begin
              rwDoc.CustCode:=rwSuppCode;
            end;

            GotHed:=Get_InvHed(RetWizRec.rwDoc,BOff,0,Fnum2,Keypath2,Get_rwBased(RetWizRec),HedAddr,BOff);

            With Inv, RetWizRec do
            Begin
              TransDate:=rwDate;
              YourRef:=rwYourRef;
              TransDesc:=rwDoc.OurRef;

              ACPr:=rwPr; ACYr:=rwYr;

              {$IFDEF MC_On}
                If (Currency=0) then
                  Currency:=Cust.Currency;
              {$ENDIF}
            end;
          end;
         end;

         If ((GotHed) and (Is_FullStkCode(StockCode))) then
         Begin
           Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LineRecAddr);

           If (Ok) and (Locked) then
           Begin

             If (RetWizRec.rwWizMode<>0) then
               TmpId.Qty:=RetWizRec.rwLineQty;

             If (Trim(RetWizRec.rwLoc)<>'') then
               TmpId.MLocStk:=RetWizRec.rwLoc;

             TmpId.JAPDedType:=Ord(RetWizRec.rwSetEQty);

             Ok:=Gen_InvLine(TmpId,RetWizRec.rwDoc,Fnum,Keypath,Get_rwBased(RetWizRec),BOff,MatchVal);


             If (Stock.StockCode<>Id.StockCode) then
               If (Not Global_GetMainRec(StockF,Id.StockCode)) then
                 ResetRec(StockF);

             {* If Purch return from sales return then re calc vat code and value *}
             If (RetWizRec.rwDoc.InvDocHed In StkRetSalesSplit+WOPSplit) and (Inv.InvDocHed In StkRetPurchSplit) then
             Begin
               If (Is_FullStkCode(StockCode)) then
                 VATCode:=Correct_PVAT(Stock.VATCode,Cust.VATCode)
               else
                 VATCode:=Correct_PVAT(VATCode,Cust.VATCode);

               CalcVAT(Id,Inv.DiscSetl);
             end;

             {* Move serial nos, but only for repair sin, or repair pin?  *}
             {$IFDEF SOP}

               If (Is_FullStkCode(Id.StockCode)) and ((RetWizRec.rwWizMode In [0,11]) or (OrigQty=Id.Qty)) and (Is_SerNo(Stock.StkValType)) and (Not (TmpId.IdDocHed In WOPSplit)) then
               Begin

                 GotSers:=Ret_TxFrSNos(RetWizRec,Inv,TmpId,Id,BOff,GotSersCount);

                 If (Not GotSers) then
                   SerialQty:=GotSersCount;
               end
               else
                 SerialQty:=0.0;
             {$ENDIF}

             If (Is_FullStkCode(Id.StockCode)) and (Stock.MultiBinMode) and (Not (TmpId.IdDocHed In WOPSplit+SalesSplit)) then
             Begin

               With TSOPRunFrm.Create(Application.MainForm) do
               Try
                 BinQty:=Qty*QtyMul;

                 GotSers:=B2BBNos(RetWizRec.rwDoc,Inv,TmpId,Id,BinQty,GotSersCount);

                   If (Not GotSers) then
                     BinQty:=GotSersCount;
               Finally
                 Free;
               end;
             end
             else
               BinQty:=0.0;


             If (Is_FullStkCode(Id.StockCode)) and (((Not (RetWizRec.rwWizMode In [0])) and ((OrigQty<>Id.Qty) or (Not GotSers))) or (Stock.MultiBinMode)) and (Ok) then {* We may need to manually assign serial nos *}
             Begin


               If (Stock.MultiBinMode) or (Is_SerNo(Stock.StkValType)) then
               Begin

                 Control_SNos(Id,Inv,Stock,1+(24*Ord(IdDocHed In StkRetSalesSplit)),Application.MainForm);

               end;
             end
             else
               If (Not GotSers) then
                 SerialQty:=TmpId.SerialQty;



             With Stock do
             Begin
               If (IdDocHed In StkRetPurchSplit) then
               Begin
                 WarrantMode:=MWarrantyType;
                 NoWarranty:=(MWarranty=0);
               end
               else
               Begin
                 WarrantMode:=SWarrantyType;
                 NoWarranty:=(SWarranty=0);
               end;

               {* Suggestion to base warranty on line date, not header date.  This would involve linking bck to the source doc line. which is not curently
                  available. *}
               WarrantDays:=NoDays(RetWizRec.rwDoc.TransDate,Inv.TransDate);

               {Case WarrantMode of {* Was going to try and make months and years months, but not accurate enough for partial months
                 0,1    :  WarrantDays:=NoDays(RetWizRec.rwDoc.TransDate,Inv.TransDate);
                 2,3    :  WarrantDays:=MonthDiff(RetWizRec.rwDoc.TransDate,Inv.TransDate);
               end;}

               NomIOFlg:=Ord((WarrantDays<=RETWTime2Days(((MWarranty*Ord(IdDocHed In StkRetPurchSplit))+(SWarranty*Ord(IdDocHed In StkRetSalesSplit))),WarrantMode)) and (Not NoWarranty));

               If (NomIOFlg=1) and (RetWizRec.rwWarrantyPrice) then {* Attempt to see if item within warranty and set price to zero if it is *}
                 NetValue:=0.0;
             end;

             MatchVal:=MatchVal+DetLTotal(Id,BOff,BOff,0.0);

             DocLTLink:=RetWizRec.rwRetReason;

             SSDUseLine:=RetWizRec.rwB2BRepair and ((TmpId.QtyDel>0.0) or ((TmpId.IdDocHed In WOPSplit) and (Qty_OS(TmpId)>0.0))); {Its a back to back repair line}

             // CJS:
             { This is a back-to-back repair line -- put the price back to the
               cost price, as we are generating a Purchase Return. }
             if (SSDUseLine) then
               NetValue := CostPrice;

             Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

             Report_BError(Fnum,Status);

             Ok:=StatusOk;

             NewId:=Id;


             If (LineRecAddr<>0) then
             Begin
               SetDataRecOfs(Fnum,LineRecAddr);

               Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);
             end;

             If (RetWizRec.rwB2BRepair) and (RetWizRec.rwDoc.InvDocHed In StkRetSalesSplit)  and (TmpId.QtyDel>0.0) then {* Its a back to back repair so also set SRN line *}
             Begin
               SSDUseLine:=BOn; {Its a back to back repair line}

               Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

               Report_BError(Fnum,Status);
             end;

             If (LineRecAddr<>0) then
               TmpStat:=UnLockMultiSing(F[Fnum],Fnum,LineRecAddr);


             {* Auto track any extended description lines &}
             If (Ok) then  {* Find any connecting desc lines *}
               Ret_SeekDescLines(Inv,TmpId,NewId,Keypath,50);

           end; {Locked..}
         end;


         If (RetWizRec.rwWizMode=0) then
           Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS)
         else
           Status:=9;


       end; {While..}

       If (GotHed) then  {* Store new Header *}
       Begin

         CalcInvTotals(Inv,ExLocal,(Not Inv.MANVAT),BOn);

         Set_DocAlcStat(Inv);  {* Set Allocation Status *}

         {$IFDEF CL_On}

          If (Trim(RetWizRec.rwRetRef)<>'') then
            Add_Notes(NoteDCode,NoteCDCode,FullNomKey(Inv.FolioNum),Today,
                    ' and appended to from '+RetWizRec.rwDoc.OurRef+' / '+RetWizRec.rwDoc.YourRef+' '+RetWizRec.rwDoc.TransDesc,
                    Inv.NLineCount)
          else

            Add_Notes(NoteDCode,NoteCDCode,FullNomKey(Inv.FolioNum),Today,
                      Inv.OurRef+' was created from '+RetWizRec.rwDoc.OurRef+' / '+RetWizRec.rwDoc.YourRef+' '+RetWizRec.rwDoc.TransDesc,
                      Inv.NLineCount);


        {$ENDIF}

         Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

         Report_BError(Fnum2,Status);

         If (HedAddr<>0) then
           TmpStat:=UnLockMultiSing(F[Fnum2],Fnum2,HedAddr);

         InvR:=Inv;


         {* Update Accont Balance *}

         If (StatusOk) and (Not (Inv.InvDocHed In QuotesSet)) then
         With Inv do
         Begin

             {$IFDEF CL_On}

               Begin


                 UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                 Inv.RemitNo:=RetWizRec.rwDoc.OurRef;

                 Match_Payment(Inv,Round_Up(Conv_TCurr(MatchVal,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2)
                               ,MatchVal,23-(3*Ord(RetWizRec.rwDoc.InvDocHed In StkRetSalesSplit)));

                 If ((Not RetWizRec.rwDoc.OrdMatch) or (Trim(RetWizRec.rwDoc.RemitNo)='')) and (Not(RetWizRec.rwDoc.InvDocHed In StkRetSalesSplit)) then
                 Begin
                   KeyI:=RetWizRec.rwDoc.OurRef;

                   Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,InvOurRefK,KeyI);

                   If (StatusOk) then
                   Begin
                     Inv.OrdMatch:=BOn;

                     Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

                     Report_BError(Fnum2,Status);

                     If (HedAddr<>0) then
                     Begin
                       SetDataRecOfs(Fnum,HedAddr);

                       Status:=GetDirect(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,0);
                     end;

                   end;
                 end; {If we need to update source for matching}
               end;

             {$ENDIF}

         end;


      end; {If GotHed}
    end;

    Result:=GotHed;

   end; {Func..}

   { ========= Procedure to Re_calc Kitting Qty ========= }

   Procedure Re_CalcKitRet(KitFolio :  LongInt;
                           IdR      :  IDetail);



   Const
     Fnum     =  IDetailF;
     Keypath  =  IDFolioK;



   Var

     KeyS,
     KeyChk    :  Str255;

     UnitQty   :  Real;

     KitMatch,
     Locked    :  Boolean;

     ExStatus  :  Integer;

     TmpId     :  ^IDetail;

     LAddr,
     RecAddr   :  LongInt;



   Begin


     New(TmpId);

     TmpId^:=IdR;

     KitMatch:=BOn;

     UnitQty:=0;

     Locked:=BOff;

     RecAddr:=0;

     With IdR do
     Begin
       KeyChk:=FullNomKey(FolioRef);

       KeyS:=FullIdKey(FolioRef,Succ(LineNo));
     end;


     ExStatus:=GetPos(F[Fnum],Fnum,RecAddr);


     ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


     While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (KitMatch) do
     With Id do
     Begin
       KitMatch:=((KitLink=KitFolio) or (KitLink<>0)) and (Not Is_FullStkCode(StockCode));

       If (KitMatch) then
       Begin

         Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

         If (Ok) and (Locked) then
         Begin
           If (IdR.Qty>0.0) then
             Qty:=IdR.Qty
           else
             Qty:=0.0;

           If (IdR.QtyPWoff>0.0) then
             QtyPWOff:=IdR.QtyPWOff
           else
             QtyPWOff:=0.0;

           If (IdR.SSDUplift>0.0) then
             SSDUplift:=IdR.SSDUplift
           else
             SSDUplift:=0.0;

           ExStatus:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

           Report_Berror(Fnum,ExStatus);

           Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
         end; {If Ok..}

       end; {If Match..}

       If (KitMatch) then
         ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

     end; {While..}

     If (RecAddr<>0) then {* Preserve Posn *}
     Begin
       SetDataRecOfs(Fnum,RecAddr);

       Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);
     end;


     Id:=TmpId^;

     Dispose(TmpId);
   end; {Proc..}


   {* Modes

   1 Set Returned from Expected, Exc SNos.
   2 Set Returned from Expected, Inc SNos.
   3 Auto pick Repair Exc SBos.
   4 Auto pick Repair Inc SBos.
   5 Auto Set WOff;

   11,12 Reset Qty Returned. 12 Inc SNos
   13,14 Reset Qty Repaired. 14 Inc SNos
   15    Reset Qty WOff

   *}

   Procedure RetAuto_PickQty(InvR       :  InvRec;
                             Mode       :  Byte;
                         Var Picked,
                             Repaired   :  Boolean;
                             AOwner     :  TObject);


   Const
       Fnum2    =  IdetailF;

       Keypath2 =  IdFolioK;



   Var
     FoundCode
             :  Str20;

     SMode   :  Byte;
     KeySI,
     KeyChkI,
     GenStr  :  Str255;


     GotLines,
     LineOk,
     GotStock,
     TmpOk,
     NoStop
              :  Boolean;

     SnoAvail,
     QtyAvail :  Double;

     CopyId   :  IDetail;

     MsgForm  :  TForm;

     mbRet    :  TModalResult;




   Begin

     GotLines:=BOff;

     LineOk:=BOff;

     QtyAvail:=0;

     GotStock:=BOff; SNoAvail:=0.0;

     NoStop:=BOn;

     GenStr:=''; CopyId:=Id;

     TmpOk:=BOff;

     Set_BackThreadMVisible(BOn);

     MsgForm:=CreateMessageDialog('Please Wait... Automatically Setting Quantities',mtInformation,[mbAbort]);
     MsgForm.Show;
     MsgForm.Update;



     KeyChkI:=FullNomKey(InvR.FolioNum);

     KeySI:=FullIdKey(InvR.FolioNum,1);

     Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

     While (StatusOk) and (CheckKey(KeyChkI,KeySI,Length(KeyChkI),BOn)) and (NoStop) do
     With Id do
     Begin
       CopyId:=Id;

       mbRet:=MsgForm.ModalResult; QtyAvail:=0.0;

       Loop_CheckKey(NoStop,mbRet);

       MsgForm.ModalResult:=mbRet;

       Application.ProcessMessages;

       GotLines:=((Qty<>QtyPick) and (Mode In [1,2])) or
                 ((Qty<>0.0) and (Mode In [11,12]) and (QtyPWoff+QtyDel+SSDUplift+QtyWOff=0.0)) or
                 ((QtyPWoff<>Qty) and (Mode In [3,4]) and (Qty>(QtyDel+SSDUplift+QtyWOff))) or
                 ((QtyPWOff<>0.0) and (Mode In [13,14])) or
                 ((SSDUplift<>Qty) and (Mode In [5]) and (Qty>(QtyDel+QtyPWOff+QtyWOff))) or
                 ((SSDUplift<>0.0) and (Mode In [15]));


       If GotLines then
       Begin

         If (IS_FullStkCode(StockCode)) then
         Begin
           GotStock:=GetStock(Application.MainForm,StockCode,FoundCode,-1);

           {$IFDEF SOP}
             Stock_LocSubst(Stock,MLocStk);

           {$ENDIF}
         end
         else
           ResetRec(StockF);

         Case Mode of
           1,2  :  If ((Not Is_SerNo(Stock.StkValType)) and (Not Stock.MultiBinMode)) or (Mode=2) then
                   Begin
                     Qty:=QtyPick;
                     QtyAvail:=Qty;
                   end;
         11,12  :  Begin
                     Qty:=0.0;
                   end;

           3,4  :  If ((Not Is_SerNo(Stock.StkValType)) and (Not Stock.MultiBinMode)) or (Mode=4) then
                   Begin
                     QtyPWoff:=(Qty-(QtyDel+SSDUplift+QtyWOff));
                     QtyAvail:=QtyPWoff;
                     Repaired:=(Repaired or (QtyPWoff>0.0));
                   end;

         13,14  :  Begin
                     QtyPWoff:=0.0;
                   end;

             5  :  Begin
                     SSDUplift:=(Qty-(QtyDel+QtyPWOff+QtyWOff));
                     Picked:=(Picked or (SSDUplift>0.0));
                   end;
            15  :  Begin
                     SSDUplift:=0.0;
                   end;
         end; {Case..}

         If (IS_FullStkCode(StockCode)) then
         Begin


           {$IFDEF SOP}
             If (((QtyAvail<>0.0) and (Mode In [2,4])) or (Mode>10)) and (Is_SerNo(Stock.StkValType) or (Stock.MultiBinMode)) then {* Check there are enough free serial nos before proceeding *}
             Begin
               If (Is_SerNo(Stock.StkValType)) and (Mode<=10) then
               Begin
                 SnoAvail:=Sno4Sale(Stock.StockFolio,QtyAvail-SerialQty,0);

                 If (SnoAvail<QtyAvail) then {Lower amount picked to match qty available}
                 Begin
                   If (Mode=2) then
                     Qty:=SnoAvail
                   else
                     QtyPWoff:=SnoAvail;

                   Repaired:=(Repaired or (QtyPWoff>0.0));
                 end;
               end;

               If (IdDocHed In StkRetSalesSplit) then
                 SMode:=(24*Ord((IdDocHed In StkRetSalesSplit))+  ((1*Ord(Mode In [4,5,14,15]))))
               else
                 SMode:=(25*(1*Ord(Mode In [4,14])));

               If (Not SSDUseLine) or (IdDocHed In StkRetSalesSplit) or (Stock.MultiBinMode and (Copy(RET_GetSORNo(SOPLink),1,3) = DocCodes[WOR]))  then
                 Control_SNos(Id,InvR,Stock,1+SMode,AOWner);

               If (CostPrice<>CopyId.Costprice) then {* Do we need to reflect new price? *}
               Begin
               end;

             end;
           {$ENDIF}

           Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2);

           Report_BError(Fnum2,Status);

           If (StatusOk) then
             Re_CalcKitRet(Stock.StockFolio,Id);
         end;

       end; {If LineOk..}

       Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

     end; {While..}

     If (Repaired and Not Picked) then
       Picked:=BOn;

     MsgForm.Free;

     Set_BackThreadMVisible(BOff);

   end; {Proc..}


   { ======= Function to Check for Picked Lines on Ret ====== }

   Function Ret_Check4Pick(Fnum,
                           Keypath  :  Integer;
                           InvR     :  InvRec;
                           SOPLoc   :  Str10;
                           RetWizRec:  tRetWizRec;
                           Mode     :  Byte)  :  Boolean;


   Var
     KeyS,
     KeyChk  :  Str255;

     HasSerial,
     WasOk,
     FoundOk :  Boolean;



   Begin

     FoundOk:=BOff;  WasOk:=BOff; HasSerial:=BOff;

     KeyChk:=FullNomKey(InvR.FolioNum);

     KeyS:=KeyChk;

     Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

     While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
     With Id do
     Begin
       Application.ProcessMessages;

       FoundOk:=SOP_CheckPickQty(Id,Mode);

       FoundOk:=(FoundOk and CheckKey(SOPLoc,Id.MLocStk,Length(SOPLoc),BOff));

       If (FoundOk and RetWizRec.rwIgnoreSer) then {* Check for serial items *}
       Begin
         If (Stock.StockCode<>Id.StockCode) then
           If (Not Global_GetMainRec(StockF,Id.StockCode)) then
             ResetRec(StockF);


         FoundOk:= (Not Is_SerNo(Stock.StkValType)) and (Not Stock.MultiBinMode);

         HasSerial:=Not FoundOk;

         If (HasSerial) then
           FoundOk:=BOn;
       end;

       WasOk:=(WasOk or FoundOk);

       If (RetWizRec.rwIgnoreSer) and (Not HasSerial) then
         FoundOk:=BOff;

       If (Not FoundOk) then
         Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

     end; {While..}

     If (RetWizRec.rwIgnoreSer) then
       FoundOk:=(WasOk and (Not HasSerial));

     Ret_Check4Pick:=FoundOk;

   end; {Func..}


   Function CheckExsiting_RET(OInv    :  InvRec;
                             OId      :  IDetail;
                         Var RETRef   :  Str10;
                             ScanLine :  Boolean)  :  Boolean;

  Const
    Fnum      =  PWrdF;
    Fnum2     =  IdetailF;
    Keypath2  =  IdFolioK;


  Var
    TmpStat,
    TmpKPath   : Integer;
    TmpRecAddr : LongInt;

    Keypath
              :  Integer;
    KeyS,KeyChk,
    NKey,KeyI,
    KeyChkI
              :  Str255;
    FoundOk   :  Boolean;


  Begin
    RETRef:=''; FoundOk:=BOff;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOff,BOff);

    Begin

      With OInv do
        If ((RemitNo<>'') or (OrdMatch)) then
          Keypath:=PWK
        else
          Keypath:=HelpNDXK;

      KeyChk:=FullMatchKey(MatchTCode,MatchSCode,OInv.OurRef);
      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


      While (StatusOK) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not FoundOk) do
      With Password.MatchPayRec do
      Begin
        Case Keypath of
          PWK       :  Begin
                         NKey:=PayRef;
                       end;
          HelpNdxK  :  Begin
                         NKey:=DocCode;
                       end;
        end; {Case..}

        If (Copy(Nkey,1,3)=DocCodes[SRN]) or (Copy(Nkey,1,3)=DocCodes[PRN]) then
        Begin
          Begin

            KeyI:=NKey;

            Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyI);

            If (StatusOk) then
            With Inv do
            Begin
              KeyChkI:=FullNomKey(FolioNum);

              KeyI:=FullIdKey(FolioNum,1);

              Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyI);


              While (StatusOk) and (CheckKey(KeyChkI,KeyI,Length(KeyChkI),BOn)) and (Not FoundOk) do
              With Id do
              Begin
                RETRef:=OurRef;

                Case ScanLine of
                  BOff :  FoundOk:=(OID.FolioRef=SOPLink);
                  BOn  :  FoundOk:=(CheckKey(OId.StockCode,StockCode,Length(OId.StockCode),BOff) and (OID.FolioRef=SOPLink) and (OId.LineNo=SOPLineNo));
                end; {Case..}

                If (Not FoundOk) then
                  Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyI);
              end;
            end;
          end;
        end;

        If (Not FoundOk) then
          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}

    end; {With..}

    TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOn,BOn);

    Id:=OId; Inv:=OInv;

    Result:=FoundOk;

  end;

   { ======= Function to Check for available stock on written off lines about to be replaced  ====== }

   Function Ret_Check4Stk(Fnum,
                          Keypath  :  Integer;
                          InvR     :  InvRec;
                          RetWizRec:  tRetWizRec;
                          Mode     :  Byte)  :  Boolean;


   Var
     KeyS,
     KeyChk  :  Str255;


     SnoAvail,
     QtyAvail:  Double;

     FoundOk :  Boolean;



   Begin
     Result:=BOn;

     If (Mode=61) and (RetWizRec.rwDocHed=SRN) and (RetWizRec.rwsBased=1) and (CheckNegStk) then
     Begin {* Check if we have enough stock for items to be returned before accepting the action *}
       FoundOk:=BOff;

       KeyChk:=FullNomKey(InvR.FolioNum);

       KeyS:=KeyChk;

       Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

       While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
       With Id do
       Begin
         Application.ProcessMessages;

         FoundOk:=SOP_CheckPickQty(Id,Mode) and (Is_FullStkCode(Id.StockCode));

         FoundOk:=(FoundOk and CheckKey(RetWizRec.rwLoc,Id.MLocStk,Length(RetWizRec.rwLoc),BOff));

         If (FoundOk) then {* Check stock *}
         Begin
           If (Stock.StockCode<>Id.StockCode) then
             If (Not Global_GetMainRec(StockF,Id.StockCode)) then
               ResetRec(StockF);

           {$IFDEF SOP}
             Stock_LocSubst(Stock,MLocStk);

             If (Is_SerNo(Stock.StkValType)) then
               QtyAvail:=Sno4Sale(Stock.StockFolio,0.0,0)
             else
           {$ENDIF}

             QtyAvail:=FreeStock(Stock);

           FoundOk:= (QtyAvail<SSDUplift) and (Stock.StockType<>StkDescCode);

         end;


         If (Not FoundOk) then
           Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

       end; {While..}


       Result:=Not FoundOk;
     end;
   end; {Func..}



{$ENDIF} // EXDLL


{$IFNDEF EXDLL}

{$ENDIF} // EXDLL
{$ENDIF} //OLE
{$IFDEF SOPDLL}
  {$DEFINE EXDLL}
  {$UNDEF SOP}
{$ENDIF}


Initialization


end.