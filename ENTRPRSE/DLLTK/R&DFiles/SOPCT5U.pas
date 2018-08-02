Unit SOPCT5U;

{$I DEFOVR.Inc}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 09/09/96                      }
{                 SOP Process Control Unit II                  }
{                                                              }
{                                                              }
{               Copyright (C) 1996 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses
  Forms,
  GlobVar,
  VarConst;


  Function FullB2BKey(C      :  Char;
                    EMode    :  LongInt;
                    fSuppCode:  Str10)  :  Str20;

  Function Get_LastB2BVal(FileKey  :  Str255;
                          Mode     :  LongInt)  :  B2BInpRec;

  Procedure Put_LastB2BVal(ASubCode :  Char;
                         B2BRec   :  B2BInpRec;
                         EMode    :  LongInt;
                         fSuppCode :  Str10);

  {$IFDEF SOPDLL}
    {$DEFINE SOP}
  {$ENDIF}

  {$IFDEF SOP}
    Function LT2Boolean(LT  :  Integer)  :  Integer;

    Procedure Generate_MB2BPOR(SORInv  :  InvRec;
                               SORAddr :  LongInt;
                           Var B2BCtrl :  B2BInpRec);

    Procedure Test_B2BPOR(SORInv  :  InvRec);
  {$ENDIF}

  {$IFDEF SOPDLL}
    {$UNDEF SOP}
  {$ENDIF}


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   SysUtils,
   VarRec2U,
   Printers,
   Dialogs,
   Controls,
   ETMiscU,
   ETDateU,
   BtrvU2,
   ComnUnit,
   ComnU2,
   CurrncyU,
   ETStrU,
   SCRTCH1U,
   SysU1,
   SysU2,
   BTSupU1,
   BTSupU3,
   BTKeys1U,
   Warn1U,
   ConvDocU,
   StkROCtl,
   InvLSt2U,
   EXWrap1U,

   {$IFDEF SOP}
     InvLSt3U,
     StkROrdr,
     SOPCT4U,

     TTD,
     TTDCalc,

     MBDTeleSales,

   {$ELSE}
     {$IFDEF SOPDLL}
     StkRORdR,
     InvLSt3U,
     SpDllSup,
{     TTD,
     TTDCalc, 

     MBDTeleSales, }
     {$ENDIF}
   {$ENDIF}

   InvCt2Su,
   CuStkA3U,

   NoteSupU,
   ExBtTh1U,
   SCRTCH2U,
   LedgSupU,
   Exthrd2U,
   PassWR2U,
   ObjDrilU;




Const
  StartTempKitLine : LongInt = -2000000;
  EndTempKitLine   : LongInt = -1000000;



{ ======== Routines to manage the storage of default variables ======= }



Function B2BKey(C      :  Char;
                EMode    :  LongInt)  :  Str20;




Begin

  Result:=AllocTCode+C+FullNomKey(Emode);

end; {Func..}



Function FullB2BKey(C      :  Char;
                    EMode    :  LongInt;
                    fSuppCode:  Str10)  :  Str20;




Begin

  Result:=B2BKey(C,EMode)+FullCustCode(fSuppCode);

end; {Func..}



Function Get_LastB2BVal(FileKey  :  Str255;
                        Mode     :  LongInt)  :  B2BInpRec;



Const
  Fnum     =  MiscF;

  KeyPAth  =  MIK;


Var
  FoundOk  :  Boolean;


Begin

  FoundOk:=BOff;

  Blank(Result,Sizeof(Result));

  With Result do
  Begin
    AutoPick:=BOn;
    IncludeLT:=31;

    If (Mode=-3) then
    Begin
      ExcludeBOM:=BOn;
    end
    else
      If (Mode=-2) then
      Begin
        BWOQty:=BOn;
        AutoSetChilds:=2;
        ShowDoc:=BOn;
        UseOnOrder:=BOn;
        AutoPick:=BOn;
        ExcludeBOM:=BOn;
        CopyStkNote:=BOn;
        LessFStk:=BOn;
        QtyMode:=0;
        WCompDate:=Today;
        WStartDate:=Today;
        CopySORUDF:=BOn;
      end;

  end;

  Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,FileKey);


  FoundOk:=StatusOk;

  If (FoundOk) then
    Result:=MiscRecs^.B2BInpDefRec.B2BInpVal;

end; {Func..}


Function  Add_B2BLine(ASubCode :  Char;
                      B2BRec   :  B2BLineRec;
                      EMode    :  LongInt;
                      fSuppCode :  Str10)  :  Boolean;



Const
  Fnum     =  MiscF;

  KeyPAth  =  MIK;


Var
  FOk        :  Boolean;


Begin

  With MiscRecs^ do
  With B2BInpDefRec do
  Begin


    ResetRec(Fnum);

    RecMFix:=AllocTCode;

    SubType:=ASubCode;

    B2BInpCode:=FullNomKey(Emode)+FullCustCode(fSuppCode);

    B2BLine:=B2BRec;
    B2BLine.Loaded:=BOn;

    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    Report_BError(Fnum,Status);

    Result:=StatusOk;

  end; {With..}

end; {Proc..}



Procedure Put_LastB2BVal(ASubCode :  Char;
                         B2BRec   :  B2BInpRec;
                         EMode    :  LongInt;
                         fSuppCode :  Str10);



Const
  Fnum     =  MiscF;

  KeyPAth  =  MIK;


Var
  FOk        :  Boolean;

  GAlloc     :  Real;

  TmpB2BRec  :  B2BInpRec;


Begin

  With MiscRecs^ do
  With B2BInpDefRec,Get_LastB2BVal(FullB2BKey(ASubCode,EMode,fSuppCode),EMode) do
  Begin

    If (Not Loaded) then
    Begin

      ResetRec(Fnum);

      RecMFix:=AllocTCode;

      SubType:=ASubCode;

      B2BInpCode:=FullNomKey(Emode)+FullCustCode(fSuppCode);

      B2BInpVal:=B2BRec;
      B2BInpVal.Loaded:=BOn;

      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    end
    else
    Begin

      B2BInpVal:=B2BRec;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    end;


    Report_BError(Fnum,Status);

  end; {With..}

end; {Proc..}

  {$IFDEF SOPDLL}
    {$DEFINE SOP}
  {$ENDIF}


{$IFDEF SOP}

  { ============= Procedure to Clear Allocation =========== }


  Procedure Reset_B2BLines(ASubCode  :  Char;
                           ECode     :  LongInt;
                           Disp      :  Boolean);


  Const
    Fnum     =  MiscF;

    Keypath  =  MIK;



  Var
    KeyChk,
    KeyS     :  Str255;
    MsgForm  :  TForm;




  Begin

    KeyCHk:=B2BKey(ASubCode,ECode);

    KeyS:=KeyChk;

    If (Disp) then
    Begin
      Set_BackThreadMVisible(BOn);

      MsgForm:=CreateMessageDialog('Please Wait... Preparing Back to Back database...',mtInformation,[]);
      MsgForm.Show;
      MsgForm.Update;

    end;


    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
    Begin

      Application.ProcessMessages;

      Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

      Report_Berror(Fnum,Status);

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {Loop..}

    If (Disp) then
    Begin
      MsgForm.Free;

      Set_BackThreadMVisible(BOff);
    end;

  end; {Proc..}


  { ============= Procedure to Temp Purchase kit lines =========== }


  Procedure Reset_PKitLines(ECode     :  LongInt;
                            Disp      :  Boolean);


  Const
    Fnum     =  IDetailF;

    Keypath  =  IdLinkK;



  Var
    KeyChk,
    KeyS     :  Str255;
    MsgForm  :  TForm;




  Begin

    KeyCHk:=FullNomKey(ECode);

    KeyS:=FullIdKey(ECode,StartTempKitLine);

    If (Disp) then
    Begin
      Set_BackThreadMVisible(BOn);

      MsgForm:=CreateMessageDialog('Please Wait... Preparing Back to Back Kit database...',mtInformation,[]);
      MsgForm.Show;
      MsgForm.Update;

    end;


    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Id.ABSLineNo<=EndTempKitLine) do
    Begin

      Application.ProcessMessages;

      Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

      Report_Berror(Fnum,Status);

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {Loop..}

    If (Disp) then
    Begin
      MsgForm.Free;

      Set_BackThreadMVisible(BOff);
    end;

  end; {Proc..}


  { == Function to convert line type to boolean equivalent == }

  Function LT2Boolean(LT  :  Integer)  :  Integer;

  Begin
    If (LT>=1) then
      Result:=1 shl LT
    else
      Result:=1;

  end; {Func..}


  { == Proc to build the database of lines required, in supplier order == }

  Procedure PreProcessB2B(SORInv  :  InvRec;
                          B2BCtrl :  B2BInpRec;
                          MsgForm :  TForm;
                      Var Ok2Go   :  Boolean);


  Const
    Fnum     =  IdetailF;
    Keypath  =  IdFolioK;
    Keypath2 =  IdLinkK;


  Var
    KeyChk,KeyS  :  Str255;
    B2BLineR     :  B2BLineRec;

    IncLWORLine,
    KeepDel,
    BOMRec,
    NewPOR,
    WasValidLine :  Boolean;
    LastSupp     :  Str10;
    mbRet        :  TModalResult;
    PORHead      :  InvRec;


  { = Common priming routines = }
  Procedure Prime_SupplierLoc;

  Begin

    With Id, B2BCtrl do
    If (KitLink=0) or (LastSupp='') or Is_FullStkCode(StockCode) then {Replace supplier, otherwise go with same as last supplier used}
    Begin
      If (Is_FullStkCode(StockCode)) and (Trim(Stock.Supplier)<>'')  and (MultiMode) then {Take supplier from stock record}
        LastSupp:=Stock.Supplier
      else {Take supplier from default provided}
        LastSupp:=SuppCode;

      If Not (Global_GetMainRec(CustF,LastSupp)) then {If all else fails use system set-up supplier}
        LastSupp:=GetProfileAccount(BOff);

      BomRec:=(Stock.StockType=StkBillCode);

      {$IFDEF SOP}
        If (Not EmptyKey(LOCOR,LocKeyLen)) then
          Stock_LocROSubst(Stock,LOCOR)
        else
          Stock_LocROSubst(Stock,MLocStk);
      {$ENDIF}

    end; {With..}

  end;


  { == Proc to generate hidden kit lines ready for processing == }

  Procedure Generate_PurchKitLines(BOMLine  :  IDetail;
                                   BOMLineR :  B2BLineRec;
                                   BOMSupp  :  Str10);


  Var
   KeepDel2,
   DelLNow

            :  Boolean;

   B_Func,
   TmpKPath,
   TmpStat  :  Integer;

   LastPORLineNo,
   TmpRecAddr
            :  LongInt;
    KeyBOMChk,
    KeyBOMS :  Str255;

    PrimeLine
            :  IDetail;

    KitCtrl :  B2BInpRec;

  Begin
    TmpKPath:=Keypath;

    KitCtrl:=B2BCtrl;
    KitCtrl.PORBOMMode:=BOn;
    KeepDel2:=BOff;

    B_Func:=B_GetPrev;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    If (NewPOR) then
    With PORHead do
    Begin
      PORHead:=SORInv;
      InvDocHed:=POR;
      ILineCount:=StartTempKitLine;
      NewPOR:=BOff;
    end;

    LastPORLineNo:=PORHead.ILineCount;


    PrimeLine:=BOMLine;

    With PrimeLine do
    Begin

    end;

    If (Cust.CustCode<>BOMSupp) then
      Global_GetMainRec(CustF,BOMSupp);

    // Build the kit lines

    SetB2B_Copy(PrimeLine,PORHead,Cust,KitCtrl);

    KeyBOMCHk:=FullNomKey(PORHead.FolioNum);

    KeyBOMS:=FullIdKey(PORHead.FolioNum,EndTempKitLine);

    Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath2,KeyBOMS);

    {** Add BOMSupp to the list of suppliers this bom header has already been assigned **}

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Id.ABSLineNo<=EndTempKitLine) and (Ok2Go) do
    With Id do
    Begin
      DelLNow:=BOn;

      Application.ProcessMessages;

      If (Assigned(MsgForm)) then
      Begin
        mbRet:=MsgForm.ModalResult;

        Loop_CheckKey(Ok2Go,mbRet);

        MsgForm.ModalResult:=mbRet;
      end;

      {$B-}                                          
      If (Is_FullStkCode(StockCode)) or (KitLink<>0) then
      {$B+}
      Begin
        With B2BCtrl do
        {$B-}
        If (Stock.StockCode=StockCode) or (Not Is_FullStkCode(StockCode)) or Global_GetMainRec(StockF,StockCode) then
        {$B+}
        Begin

          Prime_SupplierLoc;

          {$B-}
          If ((Not BomRec) or (Not ExcludeBOM)) and (IncludeLT and LT2Boolean(Stock.StkLinkLT) = LT2Boolean(Stock.StkLinkLT)) and
          (Not (ExcludeLT and LT2Boolean(Stock.StkLinkLT) = LT2Boolean(Stock.StkLinkLT))) then
          {$B+}
          With B2BLineR do
          Begin
            {** If BOM header is not in list of suppliers add in again for this supplier

            BOMLineR.LineSCode:=LastSupp;

            Add_B2BLine(AllocB2BLCode,BOMLineR,BOMLineR.OrderFolio,LastSupp);

            Add last supp to list of suppliers
            }

            FillChar(B2BLineR,Sizeof(B2BLineR),#0);

            OrderFolio:=FolioRef;

            If (ABSLineNo<>0) then
            Begin
              OrderLineNo:=ABSLineNo;
              UseKPath:=IdLinkK;
            end
            else
            Begin
              OrderLineNo:=LineNo;
              UseKPath:=IdFolioK;
            end;

            OrderLinePos:=LineNo;
            OrderAbsLine:=AbsLineNo;

            Status:=GetPos(F[Fnum],Fnum,OrderLineAddr);

            LineSCode:=LastSupp;
            DelLineAfter:=BOn;

            DelLNow:=Not Add_B2BLine(AllocB2BLCode,B2BLineR,FolioRef,LastSupp);
          end;

        end; {If valid line}

      end; {If not a valid line}

      If (DelLNow) then
      Begin
        Status:=Delete_Rec(F[Fnum],Fnum,KeyPath2);

        Report_BError(Fnum,Status);

        B_Func:=B_GetLessEq;
      end
      else
        B_Func:=B_GetPrev;


      Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath2,KeyBOMS);

    end; {Loop..}

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

  end;

  //------------------------------

  // Returns TRUE if the current line (Id) is an Advanced Discounts notification line - these should not be copied when doing B2B
  Function AdvDiscLine : Boolean;
  Begin // AdvDiscLine
    {$IFDEF SOP}
      // Adv Disc notification lines definately have no Stock Code
      Result := Not Is_FullStkCode(Id.StockCode);
      If Result Then
      Begin
        // Check for Advanced Discount Information Line flag
        Result := (Id.Discount3Type = 255);
      End; // If Result
    {$ELSE}
      Result := False;
    {$ENDIF}
  End; // AdvDiscLine

  //------------------------------

  Begin
    {* Remove any previous temporary lines for this transaction *}
    Reset_B2BLines(AllocB2BLCode,SORInv.FolioNum,BOff);

    {* Remove any previous temporary Kit marker lines for this transaction *}
    Reset_PKitLines(SORInv.FolioNum,BOff);


    LastSupp:=''; BOMRec:=BOff;  KeepDel:=BOff;  IncLWORLine:=(SORInv.InvDocHed<>WOR);

    Ok2Go:=BOn;  NewPOR:=BOn;  WasValidLine:=BOff;

    KeyChk:=FullNomKey(SORInv.FolioNum);
    KeyS:=FullIdKey(SORInv.FolioNum,1+Ord(SORInv.InvDocHed=WOR));

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Ok2Go) do
    With Id do
    Begin

      Application.ProcessMessages;

      If (Assigned(MsgForm)) then
      Begin
        mbRet:=MsgForm.ModalResult;

        Loop_CheckKey(Ok2Go,mbRet);

        MsgForm.ModalResult:=mbRet;
      end;

      If (Not AdvDiscLine) And ((Is_FullStkCode(StockCode)) or ((KitLink<>0) and (LastSupp<>'') and (WasValidLine)) or ((Not B2BCtrl.Multimode) and (B2BCtrl.QtyMode=0))) then
      Begin
        WasValidLine:=BOn;

        With B2BCtrl do
        If B2BLine(Id,KeepDel) then {Include Line}
        Begin
          If (KitLink<>0) and (Is_FullStkCode(StockCode)) and (Stock.StockCode<>StockCode) then {If it is a kit line B2BLine will not have got the stock record}
            Global_GetMainRec(StockF,StockCode);


          Prime_SupplierLoc;

          {$B-}
            If (SORInv.InvDocHed=WOR) then
              IncLWORLine:=(IncludeLT and LT2Boolean(Stock.StkLinkLT) = LT2Boolean(Stock.StkLinkLT)) and
                           (Not (ExcludeLT and LT2Boolean(Stock.StkLinkLT) = LT2Boolean(Stock.StkLinkLT)));

          If ((Not BomRec) or (Not ExcludeBOM)) and ((IncludeLT and LT2Boolean(DocLTLink) = LT2Boolean(DocLTLink)) or (SORInv.InvDocHed=WOR)) and
          (Not (ExcludeLT and LT2Boolean(DocLTLink) = LT2Boolean(DocLTLink)))
          and (IncLWORLine)
          and ((QtyMode=0) or ((QtyMode=1) and (Qty_OS(Id)<>0.0))
                           or ((QtyMode=2) and (Stk_SuggROQ(Stock,BOff,BOff)<>0.0))
                           or ((QtyMode=3) and ((Qty_OS(Id)-(QtyPick+QtyPWOff))<>0.0))
                           or ((KitLink<>0) and (Not Is_FullStkCode(StockCode))))  then

          {$B+}
          With B2BLineR do
          Begin
            FillChar(B2BLineR,Sizeof(B2BLineR),#0);

            OrderFolio:=FolioRef;

            If (ABSLineNo<>0) then
            Begin
              OrderLineNo:=ABSLineNo;
              UseKPath:=IdLinkK;
            end
            else
            Begin
              OrderLineNo:=LineNo;
              UseKPath:=IdFolioK;
            end;

            OrderLinePos:=LineNo;
            OrderAbsLine:=AbsLineNo;

            Status:=GetPos(F[Fnum],Fnum,OrderLineAddr);

            LineSCode:=LastSupp;
                                                  {* v5.00. If a kit is both sales & purch, treat as just sales for b2b otherwise auto pick will fail *}
            If ((Stock.StockType=StkBillCode) and (Stock.KitOnPurch) and (Not Stock.ShowAsKit)) and (MultiMode) and (SORInv.InvDocHed<>WOR) then {* Generat the kit components *}
            Begin
              Generate_PurchKitLines(Id,B2BLineR,LastSupp);

              {WasValidLine:=BOff; {v5.00 Ignore any follow up desc only lines as header does not have a line of its own}
            end
            else
              Ok2Go:=Add_B2BLine(AllocB2BLCode,B2BLineR,FolioRef,LastSupp);

          end
          else
            WasValidLine:=BOff;


        end; {If valid line}

      end {If valid line..}
      else
        WasValidLine:=BOff;


      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

  end; {Proc..}


  { =========== Procedure to Generate automatic Purchase Orders ========= }



  Procedure Generate_MB2BPOR(SORInv  :  InvRec;
                             SORAddr :  LongInt;
                         Var B2BCtrl :  B2BInpRec);



  Const
    Fnum      =  IdetailF;


    Fnum2     =  MiscF;

    Keypath2  =  MIK;



  Var
    KeyChk,
    KeyS,
    KeyI,
    KeyIChk    :  Str255;

    LastSupp   :  Str10;

    UOR, n,

    OrderCount,
    LastCurr   :  Byte;

    LFiltSet,
    Ok2Print,
    GotSome,
    Ok2Go,
    LOk,
    Locked,
    RunHook,
    RunCPHook,
    RunStoreHook,
    AddDLines,
    CalledThread,
    HeaderReq,
    Ignore     :  Boolean;

    LAddr,
    DocICnst,
    RecAddr    :  LongInt;

    Keypath,
    B_Func     :  Integer;

    MatchVal   :  Double;

    MsgForm    :  TForm;

    mbRet      :  TModalResult;

    TmpInv     :  InvRec;
    {$IFDEF CU}
      HookId,
    {$ENDIF}

    TmpId      :  IDetail;

    MTExLocal  :  tdPostExLocalPtr;
    ExLocal    :  TdExLocal;


    ThisScrt   :  Scratch2Ptr;

    {$IFDEF SOP}
      CommitPtr
               :  Pointer;
    {$ENDIF}

    {$IFDEF Cu}

      StoreEvent,
      CustomEvent  :  TCustomEvent;

      CPEvent1,
      CPEvent2   :  TCustomEvent;

    {$ENDIF}

    {$IFDEF SOP}
      {$IFNDEF SOPDLL}
      frmTeleSalesMultiBuy : TfrmTeleSalesMultiBuy;
      bApplyMultiBuyDiscounts : Boolean;
      {$ENDIF}
    {$ENDIF}





  { == Function to finalise por ==}

  Procedure Finish_POR;

  Var
    HMode  :  Byte;
    KeyHChk,
    KeyHS  :  Str255;

  Begin
    HMode:=232;

    {$IFDEF CU}
      Try
        If (RunCPHook) then
        Begin
          With CPEvent2 do
          If (GotEvent) then
          Begin
            ExLocal.AssignFromGlobal(InvF);

            ExLocal.LId:=HookId;

            BuildEvent(ExLocal);
          end
          else
            RunCPHook:=BOff;

          If (RunCPHook) then
          Begin
            With CPEvent2 do
            Begin
              TInvoice(EntSysObj.Transaction).ResetTrans(Inv);

              Keypath:=IdFolioK;

              KeyHChk:=FullNomKey(Inv.FolioNum);
              KeyHS:=FullIdKey(Inv.FolioNum,1);

              Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyHS);

              While (StatusOk) and (CheckKey(KeyHChk,KeyHS,Length(KeyHChk),BOn)) do
              With Id do
              Begin
                If TInvoice(EntSysObj.Transaction).ChangeCurrentLine(Id) then
                Begin
                  Execute;

                  If (ValidStatus) and (DataChanged) then
                  Begin
                    Id.NetValue:=EntSysObj.TransAction.thLines.thCurrentLine.tlNetValue;

                    Id.Discount:=EntSysObj.TransAction.thLines.thCurrentLine.tlDiscount;
                    Id.DiscountChr:=EntSysObj.TransAction.thLines.thCurrentLine.tlDiscFlag;


                    Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

                    Report_BError(Fnum,Status);

                  end;
                end;

                Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyHS);

              end; {While..}
            end;
          end;
        end;
      except

      end; {try..}
    {$ENDIF}


    Store_InvHed(0);

    {$IFDEF SOP}
      {$IFNDEF SOPDLL}
      With TTTDTelesaleHelper.Create Do
      Begin
        Try
          TransactionMode := tmAdd;
          ScanTransaction(Inv);
          If Enabled Then
            OfferTTD (Inv);
        Finally
          Free;
        End; // Try..Finally
      End; // With TTTDTelesaleHelper.Create
      {$ENDIF}
    {$ENDIF}

    Status:=GetPos(F[InvF],InvF,RecAddr);

    If (Not (Inv.InvDocHed In QuotesSet+NomSplit+PSOPSet)) and (Not Syss.UpBalOnPost) and (Inv.RunNo=0) then
      UpdateBal(Inv,BaseTotalOS(Inv),
                    (ConvCurrICost(Inv,BOff,BOn)*DocCnst[Inv.InvDocHed]*DocNotCnst),
                    (ConvCurrINet(Inv,BOff,BOn)*DocCnst[Inv.InvDocHed]*DocNotCnst),
                    BOff,2);  {* Up Date Customer Balance, exclude auto item copies! *}


    If (B2BCtrl.MultiMode) then
    Begin
      If (Not Assigned(ThisScrt)) then
        New(ThisScrt,Init(11,MTExLocal,BOff));

      ThisScrt^.Add_Scratch(InvF,InvOurRefK,RecAddr,Inv.OurRef,Inv.OurRef);
    end;

      {* Store matching information *}

     With Inv do
     Begin
       RemitNo:=SORInv.OurRef;

       Match_Payment(Inv,Round_Up(Conv_TCurr(TotOrdOS,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2)
                 ,TotOrdOS,23);
       RemitNo:='';
     end;

     With SORInv do
     Begin
       RemitNo:=Inv.OurRef;

       MatchVal:=Round_Up(Conv_TCurr(Inv.TotOrdOS,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);

       Currency:=Inv.Currency;

       Match_Payment(SORInv,MatchVal,Inv.TotOrdOS,23);

       RemitNo:='';
     end;

     CopyNoteFolio(NoteDCode,NoteDCode,FullNCode(FullNomKey(SORInv.FolioNum)),FullNCode(FullNomKey(Inv.FolioNum)),0);

     Inv.NLineCount:=Inv.NLineCount+SORInv.NLineCount;

    If (OrderCount<255) then
      Inc(OrderCount);

    Add_Notes(NoteDCode,NoteCDCode,FullNomKey(Inv.FolioNum),Today,
              Inv.OurRef+' was created by a back to back from '+SORInv.OurRef+' / '+SORInv.YourRef+' '+SORInv.TransDesc,
                    Inv.NLineCount);

    SetHold(HMode,InvF,InvOurRefK,BOn,Inv);

    GotSome:=BOn;

    {$IFDEF CU} {* Call any post store hooks here *}
      If (RunStoreHook) and (Assigned(StoreEvent)) then
      With StoreEvent do
      Begin
        TInvoice(EntSysObj.Transaction).ResetTrans(Inv);
        Execute;
      end;
    {$ENDIF}

  end;



  Begin

    RunHook:=BOff; RunCPHook:=BOff; RunStoreHook:=BOff;

    {$IFDEF Cu}
      CustomEvent:=TCustomEvent.Create(EnterpriseBase+2000,182);
      StoreEvent:=TCustomEvent.Create(EnterpriseBase+2000,170);

      Blank(HookId,Sizeof(HookId));

      CPEvent1:=TCustomEvent.Create(EnterpriseBase+2000,187);
      CPEvent2:=TCustomEvent.Create(EnterpriseBase+2000,188);


    {$ENDIF}

    Try

     {$IFDEF Cu}
        ExLocal.Create;

        With CustomEvent do
          If (GotEvent) then
          Begin
            BuildEvent(ExLocal);
            RunHook:=BOn;
          end;

        With StoreEvent do
          If (GotEvent) then
          Begin
            BuildEvent(ExLocal);
            RunStoreHook:=BOn;
          end;

        With CPEvent1 do
        If (GotEvent) and (SORInv.InvDocHed=SOR) then
        Begin
          BuildEvent(ExLocal);

          TInvoice(EntSysObj.Transaction).ResetTrans(SORInv);

          Execute;

          RunCPHook:=ValidStatus;
        end;


     {$ENDIF}

      LastSupp:='';

      DocICnst:=1;

      Ignore:=BOff;

      HeaderReq:=BOff;

      LastCurr:=0; UOR:=0;  OrderCount:=0;

      LFiltSet:=Not EmptyKey(B2BCtrl.LocOR,LocKeyLen);

      KeyChk:=B2BKey(AllocB2BLCode,SORInv.FolioNum);
      KeyS:=KeyChk;

      GotSome:=BOff;

      Ok2Go:=BOn;

      ThisScrt:=nil;



      {$IFDEF SOP}
        CommitPtr:=nil;
      {$ENDIF}


      Ok2Print:=BOn;

      CalledThread:=BOff;

      If (Ok2Print) then
      Begin
        New(MTExLocal,Create(27));

        try
          With MTExLocal^ do
            Open_System(CustF,PWrdF);

        except
          Dispose(MTExLocal,Destroy);
          MTExLocal:=nil;

        end; {Except}



        If (Assigned(MTExLocal)) then
        With B2BCtrl do
        Begin
          try
           {$IFDEF SOP}
             {$IFNDEF SOPDLL}
              If (CommitAct) then
               CommitPtr:=Conv_Create_CommitObject(BOff,nil);


               frmTeleSalesMultiBuy := NIL;
               bApplyMultiBuyDiscounts := False;
              {$ENDIF}
             {$ENDIF}


            Set_BackThreadMVisible(BOn);

            MsgForm:=CreateMessageDialog('Please wait... Generating Back to Back Purchase Orders.',mtInformation,[mbAbort]);
            {$IFNDEF SOPDLL}
            MsgForm.Show;
            MsgForm.Update;
            {$ENDIF}
            PreProcessB2B(SORInv,B2BCtrl,MsgForm,Ok2Go);

            Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

            While (StatusOk) and (Ok2Go) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
            With MiscRecs^.B2BInpDefRec.B2BLine,Id do
            Begin

              B_Func:=B_GetNext;

              mbRet:=MsgForm.ModalResult;

              Loop_CheckKey(Ok2Go,mbRet);

              MsgForm.ModalResult:=mbRet;

              Application.ProcessMessages;

              KeyI:=FullIdKey(OrderFolio,OrderLineNo);

              Keypath:=UseKPath;


              Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyI);

              If ((OrderLinePos<>LineNo) or (OrderAbsLine<>ABSLineNo)) and (OrderLineAddr<>0) then {* v5.52 We have a duplicate line situation so revert to the record address *}
              Begin
                SetDataRecOfs(Fnum,OrderLineAddr);

                Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

              end;


              If (StatusOk) and ((FolioRef=OrderFolio) and ((ABSLineNo=OrderLineNo) or (LineNo=OrderLineNo))) then
              Begin
                TmpId:=Id;

                LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked,LAddr);

                If (LOk) and (GlobLocked) then
                Begin
                  If (DelLineAfter) then {* We need to get rid of transaction line as it was only there as a marker}
                  Begin
                    Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

                    Report_BError(Fnum,Status);
                  end;

                  If (Stock.StockCode<>StockCode) and (Is_FullStkCode(StockCode)) then
                    Global_GetMainRec(StockF,StockCode);

                  If (LFiltSet) then
                    Stock_LocROSubst(Stock,LOCOR)
                  else
                    Stock_LocROSubst(Stock,MLocStk);


                  If (LastSupp<>LineSCode) then
                  Begin

                    If (HeaderReq) then
                    Begin
                      Finish_POR;
                    end;

                    LastSupp:=LineSCode;

                    Inv:=SORInv;

                    SetInv_Copy(Inv,DocICnst,3,LineSCode,AutoPick);
                    {$IFDEF SOPDLL}
                    AddToB2BList(Inv.OurRef);
                    {$ENDIF}

                    {$IFDEF SOP}
                      {$IFNDEF SOPDLL}
                      // Destroy any pre-existing details
                      FreeAndNIL(frmTeleSalesMultiBuy);

                      // Check for MBD discounts here for the current supplier
                      frmTeleSalesMultiBuy := TfrmTeleSalesMultiBuy.Create(nil);
                      frmTeleSalesMultiBuy.SearchString := KeyS;
                      frmTeleSalesMultiBuy.CustomerCode := Inv.CustCode;
                      frmTeleSalesMultiBuy.Currency := Inv.Currency;
                      frmTeleSalesMultiBuy.DocType := Inv.InvDocHed;//DocTypes(TeleSHed^.TeleSRec.tcDoctype);
                      frmTeleSalesMultiBuy.TransDate := Inv.TransDate;
                      frmTeleSalesMultiBuy.ExLocal := @ExLocal;

                      If DelLineAfter Then
                        // Eduardo has deleted the friggin' line so we need to insert it manually
                        frmTeleSalesMultiBuy.InsertDeletedB2BLine (Id, Inv, Cust, B2BCtrl);

                      bApplyMultiBuyDiscounts := frmTeleSalesMultiBuy.ExecuteB2B (Inv, Cust, B2BCtrl);
                      {$ENDIF}
                    {$ENDIF}

                    HeaderReq:=BOn;
                  end;

                  If (HeaderReq) then
                  Begin
                    Id:=TmpId;

                    TmpInv:=Inv;
                    {$IFNDEF SOPDLL}
                    // Need to set MBD discount in SetB2B_Copy
                    if Assigned(frmTeleSalesMultiBuy) And bApplyMultiBuyDiscounts then
                    begin
                      SetB2B_Copy(Id,TmpInv,Cust,B2BCtrl, False, frmTeleSalesMultiBuy);

                      frmTeleSalesMultiBuy.AddMultiBuyDiscountLines(TmpInv, Id, Stock);
                    End // if Assigned(frmTeleSalesMultiBuy) And bApplyMultiBuyDiscounts
                    Else
                    {$ENDIF}
                      SetB2B_Copy(Id,TmpInv,Cust,B2BCtrl);  // No Multi-Buy Discounts

                    Inv:=TmpInv;

                    {$IFDEF CU}
                      If (RunCPHook) and (Id.LineNo=1) then
                        HookId:=Id;
                    {$ENDIF}


                    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

                    Report_BError(Fnum,Status);

                    If (StatusOk) then
                    Begin {* Generate Job Actual *}

                      {$IFDEF PF_On}

                        If (JbCostOn) and ((DetLTotal(Id,BOn,BOff,0.0)<>0) or (Id.IdDocHed In [ADJ,TSH])) and (Id.LineNo>0)
                           and ((Id.LineNo<>RecieptCode) or (Not (Id.IdDocHed In PurchSet))) then
                          Update_JobAct(Id,Inv);

                        {$IFDEF STK}
                          Stock_AddCustAnal(Id,BOn,0);

                          {$IFDEF SOP}
                            {$IFNDEF SOPDLL}
                            Conv_Update_LiveCommit(Id,1,CommitPtr);
                            {$ENDIF}
                          {$ENDIF}

                        {$ENDIF}

                      {$ENDIF}

                    end;


                    SetDataRecOfs(Fnum2,LAddr);

                    Status:=GetDirect(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,0);


                    If (StatusOk) then
                    Begin
                      Status:=Delete_Rec(F[Fnum2],Fnum2,KeyPath2);

                      Report_BError(Fnum2,Status);

                      B_Func:=B_GetGEq;

                    end;

                  end
                  else
                    B_Func:=B_GetNext;

                end; {If Locked..}

              end; {If Not Tagged..}

              Status:=Find_Rec(B_Func,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

            end; {While..}

            If (HeaderReq) then
            Begin

              Finish_POR;
            end;

            GenOrder:=OrderCount;

            If (GotSome) and (MultiMode) and (OrderCount>1) then {* Call OBject DD and show list of POR's produced. *}
            Begin
              {$IFNDEF SOPDLL}
              Set_ODDMode(1);

              With TObjDFrm.Create(Application.MainForm) do
              try

                BuildB2BList(SORInv,MTExLocal,ThisScrt);
                CalledThread:=BOn;
              except
                CalledThread:=BOff;
                Free;
              end; {Try..}
              {$ENDIF}
            end
            else
            Begin
              {* Tidy up..}
              If Assigned(ThisScrt) then
              Begin
                Dispose(ThisScrt,Done);
                ThisScrt:=nil;
              End; // If Assigned(ThisScrt)

              Dispose(MTExLocal,Destroy);
              MTExLocal:=Nil;
            End; // Else
          Finally
            If (Not Ok2Go) then {We have aborted, so tidy up temp records}
            Begin
              {* Remove any previous temporary lines for this transaction *}
              Reset_B2BLines(AllocB2BLCode,SORInv.FolioNum,BOff);

              {* Remove any previous temporary Kit marker lines for this transaction *}
              Reset_PKitLines(SORInv.FolioNum,BOff);
            end;


            {$IFDEF SOP}
              {$IFNDEF SOPDLL}
              If (Assigned(CommitPtr)) then {Remove the commit object}
                Conv_Create_CommitObject(BOn,CommitPtr);
              {$ENDIF}

            {$ENDIF}

            If (Assigned(ThisScrt)) and (Not CalledThread) then
            Begin
              Dispose(ThisScrt,Done);
              ThisScrt:=nil;
            End; // If Assigned(ThisScrt) and (Not CalledThread)

            If (Assigned(MTExlocal)) and (Not CalledThread) then
              Dispose(MTExLocal,Destroy);

            MsgForm.Free;

            Set_BackThreadMVisible(BOff);
          End; // Try..Finally

          {$IFDEF SOP}
            {$IFNDEF SOPDLL}
            // Destroy any existing multi-buy details
            bApplyMultiBuyDiscounts := False;
            FreeAndNIL(frmTeleSalesMultiBuy);
            {$ENDIF}
          {$ENDIF}
        end; {If MT ExLocal OK..}
      end; {If Print Abort..}

    {* Explicitly remove multi lock *}

      If (SORAddr<>0) then
      Begin
        {$IFDEF CU}
           If (RunHook) then
           With CustomEvent do
           Begin
             SetDataRecOfs(InvF,SORAddr);

             Status:=GetDirect(F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,0);

             If (StatusOk) then
             Begin
               TInvoice(EntSysObj.Transaction).ResetTrans(Inv);

               Execute;

               If (ValidStatus) and (DataChanged) then
               With Inv do
               Begin
                 For n:=Low(DAddr) to High(DAddr) do
                   DAddr[n]:=EntSysObj.Transaction.thDelAddr[n];

                 DocUser1:=EntSysObj.Transaction.thUser1;
                 DocUser2:=EntSysObj.Transaction.thUser2;
                 DocUser3:=EntSysObj.Transaction.thUser3;
                 DocUser4:=EntSysObj.Transaction.thUser4;
                 //GS 14/10/2011 ABSEXCH-11706: Added code to write to the 6 new user defined fields
                 DocUser5:=EntSysObj.Transaction3.thUser5;
                 DocUser6:=EntSysObj.Transaction3.thUser6;
                 DocUser7:=EntSysObj.Transaction3.thUser7;
                 DocUser8:=EntSysObj.Transaction3.thUser8;
                 DocUser9:=EntSysObj.Transaction3.thUser9;
                 DocUser10:=EntSysObj.Transaction3.thUser10;

                 Status:=Put_Rec(F[InvF],InvF,RecPtr[InvF]^,InvOurRefK);

                 Report_BError(InvF,Status);

               end;
             end;
           end;

        {$ENDIF}

        UnLockMultiSing(F[InvF],InvF,SORAddr);
      end;
    finally
      {$IFDEF CU}
        CustomEvent.Free;
        ExLocal.Destroy;
      {$ENDIF}
    end;

  end; {Proc..}


  { == Proc to test the multi back to back por creation == }

  Procedure Test_B2BPOR(SORInv  :  InvRec);


  Var
    B2BCtrl  :  B2BInpRec;

  Begin
    FillChar(B2BCtrl,Sizeof(B2BCtrl),#0);

    With B2BCtrl do
    Begin
      MultiMode:=BOn;
      IncludeLT:=15;
      AutoPick:=BOn;
    end;

    Generate_MB2BPOR(SORInv,0,B2BCtrl);


  end;

  {$ENDIF}

  {$IFDEF SOPDLL}
    {$UNDEF SOP}
  {$ENDIF}


end. {Unit..}