Unit SOPCT3U;

{$I DEFOVR.Inc}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 22/01/96                      }
{                 SOP Process Control Unit III                 }
{                                                              }
{                                                              }
{               Copyright (C) 1996 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses
  GlobVar,
  Forms,
  VarConst

  {$IFDEF CU}
     ,CustIntU;

  {$ELSE}

    ;
  {$ENDIF}





Procedure SOP_SeekDescLines(SOPRunNo  :  LongInt;
                            IdR       :  IDetail;
                            KeyRes    :  Integer);


Function Set_MatchLinkDoc(DocHed  :  DocTypes;
                          Mode    :  Byte)  :  DocTypes;


Function Find_RunHed(KeyChk  :  Str255;
                     Fnum,
                     Keypath :  Integer;
                     TCurr   :  Byte;
                     SRunNo  :  LongInt;
                     SSDFlag :  Char)  :  Boolean;

Procedure Set_DocRunStat(Var InvR  :  InvRec);

Function Get_InvHed(InvR  :  InvRec;
                    ConsA :  Boolean;
                    SRunNo:  LongInt;
                    Fnum,
                    Keypath
                          :  Integer;
                    Mode  :  Byte;
             Var    HedAddr
                          :  LongInt;
                    KeepTagNo
                          :  Boolean)  :  Boolean;

{$IF Defined(WOP) or  Defined(RET)}

  Function Get_AdjHed(ConsA :  Boolean;
                      AdjNo :  Str10;
                      InvR  :  InvRec;
                      SRunNo:  LongInt;
                      Fnum,
                      Keypath
                            :  Integer;
                      Mode  :  Byte;
                 Var  HedAddr
                            :  LongInt)  :  Boolean;


   Procedure SetLink_Cost(Var IdR  :  IDetail;
                              InvR :  InvRec);

{$IFEND}

Function Gen_InvLine(IdR   :  IDetail;
                     InvR  :  InvRec;
                     Fnum,
                     Keypath
                           :  Integer;
                     Mode  :  Byte;
                     ConsA :  Boolean;
                 Var MatchVal
                           :  Real)  :  Boolean;

Procedure Reveal_SOPDoc(Var  InvR  :  InvRec;
                             Mode  :  Byte);

Function SOP_CheckLoc(IdR      :  IDetail;
                      SOPMLoc  :  Str10;
                      Mode     :  Byte)  :  Boolean;

{$IFDEF CU}
  Procedure Apply_CreditHold(Const Update  :  Boolean;
                             Const Fnum,
                                   Keypath :  Integer;
                             CustomEvent
                                           :  TCustomEvent);
{$ENDIF}


Function HowManyInKit(StockR    :  StockRec;
                      CompCode  :  Str20)  :  Double;

Procedure ReApply_KitPick(Const Fnum,
                                Keypath  :  Integer;
                          Const KeyChk   :  Str255;
                                iWaitStk :  Boolean;
                                PickRNo  :  LongInt;
                                InvR     :  InvRec);

Function SOP_CheckPickQty(IdR   :  IDetail;
                          Mode  :  Byte)  :  Boolean;

Function HowManyBOM(StockR  :  StockRec;
                      WithOwn,
                      TopMan  :  Boolean;
                      Lc      :  Str10;
                      WMode   :  Byte)  :  Double;

Function Control_AutoPickWOff(AMode :  Byte;
                              InvR  :  InvRec;
                              LForm :  Tform)  :  Boolean;



 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   SysUtils,
   Dialogs,
   Controls,
   VarRec2U,
   ETMiscU,
   ETDateU,
   BtrvU2,
   ComnUnit,
   ComnU2,
   CurrncyU,
   ETStrU,
   InvListU,
   InvLst2U,
   MiscU,
   InvCTSUU,
   InvFSu2U,
   {$IFDEF SOP}
     InvLst3U,
   {$ENDIF}

   {$IF Defined(SOP) or Defined(RET)}
     SysU3,
   {$IFEnd}

   CuStkA3U,

   SysU1,
   SysU2,
   BTSupU1,
   BTKeys1U,
   ExThrd2U,
   Warn1U,
   FIFOL2U,
   Event1U,

   {$IFDEF CU}
     OCust,OInv,
     CustWinU,
   {$ENDIF}


   StkBinU,

   SOPCT2U,

   { CJS - 2013-10-25 - MRD2.6 - Transaction Originator }
   TransactionOriginator,

   AuditNotes;




{ ======== Proc to Seek additional Desc lines, and include them as picked ===== }


Procedure SOP_SeekDescLines(SOPRunNo  :  LongInt;
                            IdR       :  IDetail;
                            KeyRes    :  Integer);



Const
  Fnum     =  IdetailF;
  Keypath  =  IdFolioK;


Var

  KeyS,
  KeyChk    :   Str255;

  RecAddr   :   LongInt;



Begin

  RecAddr:=0;

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
      With Id do
      Begin
        QtyPick:=Idr.QtyPick;
        QtyPWOff:=0;

        SOPLineNo:=SOPRunNo;


        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

        Report_BError(Fnum,Status);

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
      end; {While..}


      SetDataRecOfs(Fnum,RecAddr);  {* Establish old Path *}

      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyRes,0);

    end; {If POs foundOk..}

  end; {If line with poss desc lines}

end; {Proc..}


{$IFDEF RET}

   { == Function to Return Doc type based on Ret type and action code == }

   Function Set_ActDocType(rwDocHed  :  DocTypes;
                           rwPAction :  Byte)  :  DocTypes;

   Begin
     Result := SIN;
     Case rwDocHed of
       PRN  :  Begin
                 Case rwPAction of
                   0  :    Result:=PCR;
                   1  :    Result:=PIN;
                   {$IFDEF SOP}
                     2  :  Result:=PDN;
                   {$ENDIF}
                 end; {Case..}
               end;
       SRN  :  Begin
                 Case rwPAction of
                   0    :  Result:=SCR;
                   1    :  Result:=SIN;
                   {$IFDEF SOP}
                     2,3  :  Result:=SOR;
                   {$ENDIF}
                   8      :  Result:=SQU;
                 end; {Case..}
               end;
     end; {Case..}
   end; {Func..}

{$ENDIF}


{ ============= SOP Processing Routines, ?OR->?DN & ?DN->?IN ==========

Generation modes:-


  1  :  Orders to Delivery notes
  2  :  Delivery notes to Invoices
  3  :  Orders direct to Invoices
  4  :  ...
  50..59
     :  Return Creation Mode
  60..79
     :  Return Action Mode
  80 :  Works Orders to ADJ - Issue
  81 :  Works Orders to ADJ - Final build
  99 :  Special insertion of desc line on consolidated invoices
 100 :  Booked in Adj from Returns
 101 :  Issued out stock from Returns

}




{ ====== Function to Return Conversion DocType ===== }

Function Set_MatchLinkDoc(DocHed  :  DocTypes;
                          Mode    :  Byte)  :  DocTypes;



Var
  NewDocHed  :  DocTypes;


Begin

  NewDocHed:=DocHed;


  If (DocHed In SalesSplit) then
    Case Mode of
      1  :  NewDocHed:=SDN;
      2,3
         :  NewDocHed:=SIN;
      {$IFDEF RET}
        50..59
           :  NewDocHed:=SRN;
      {$ENDIF}

    end {Case..}
  else
    Case Mode of
      1  :  NewDocHed:=PDN;
      2,3
         :  NewDocHed:=PIN;


      {$IFDEF RET}
        50..59
          :  NewDocHed:=PRN;
        60..79
          :  NewDocHed:=Set_ActDocType(DocHed,Mode-60);
      {$ENDIF}

      80,81, 100,101 
         :  NewDocHed:=ADJ;
    end; {Case..}

  Set_MatchLinkDoc:=NewDocHed;

end; {Func..}




{ ========= Find Existing Header ======= }

Function Find_RunHed(KeyChk  :  Str255;
                     Fnum,
                     Keypath :  Integer;
                     TCurr   :  Byte;
                     SRunNo  :  LongInt;
                     SSDFlag :  Char)  :  Boolean;


Var
  KeyS     :  Str255;
  FoundOk  :  Boolean;




Begin

  FoundOk:=BOff;

  KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not FoundOk) do
  With Inv do
  Begin
    FoundOk:=((Currency=TCurr) and (SRunNo=PickRunNo)) and (SSDProcess=SSDFlag);

    If (Not FoundOk) then
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  Find_RunHed:=FoundOk;

end; {Func..}


{ ======== Set Header Status ======== }

Procedure Set_DocRunStat(Var InvR  :  InvRec);


Begin

  With InvR do
  Begin

    RunNo:=(InvR.RunNo-3); {* Temp storage *}

    DeliverRef:=Inv.OurRef; {* Store Delivery Note Number *}


    {* Altered so that purchases are also set to F6 period 16/06/95 *}

    AcPr:=GetLocalPr(0).CPr;
    AcYr:=GetLocalPr(0).CYr;

    If (InvDocHed In SalesSplit) then {* Only Reset Date on Sales Docs *}
    Begin
      {* Only overwrite Inv date with SDN date if not considered taxpoint date *}
      If (Not Syss.SDNOwnDate) then
        TransDate:=Today;


      If (Syss.AutoPrCalc) then  {* v4.31 Set Pr from input date *}
        Date2Pr(TransDate,AcPr,AcYr,nil);

      {DueDate:=CalcDueDate(TransDate,Cust.PayTerms);}
    end;

    {*v4.31 Moved here so it always recalculates due date, after Fi insited it should. *}

    DueDate:=CalcDueDate(TransDate,Cust.PayTerms)

  end; {With..}

end; {Proc..}

{ ========= Auto generation of Doc Header ======== }

Function Get_InvHed(InvR  :  InvRec;
                    ConsA :  Boolean;
                    SRunNo:  LongInt;
                    Fnum,
                    Keypath
                          :  Integer;
                    Mode  :  Byte;
             Var    HedAddr
                          :  LongInt;
                    KeepTagNo
                          :  Boolean)  :  Boolean;





Var
  KeyChk,
  KeyS     :  Str255;

  Loop, LOK,
  Locked,
  FoundHed :  Boolean;

  n        :  Byte;

  FirstCode,
  FoundCode:  Str20;



  DelAddr  :  AddrTyp;
  // MH 02/01/2015 v7.1 ABSEXCH-15980: Corrected to copy the PostCode and Country
  CustPostCode : string[20];
  CustCountry : String[2];

  RecAddr  :  LongInt;


Begin

  Loop:=BOn; LOK:=BOff; Locked:=BOff;

  FoundHed:=BOff;

  Blank(DelAddr,Sizeof(DelAddr));
  // MH 02/01/2015 v7.1 ABSEXCH-15980: Corrected to copy the PostCode and Country
  FillChar(CustPostCode, SizeOf(CustPostCode), #0);
  FillChar(CustCountry, SizeOf(CustCountry), #0);

  n:=1;

  RecAddr:=0;

  KeyS:=FullCustCode(InvR.CustCode);

  FirstCode:=InvR.CustCode;

  Repeat  {* Recursivley go and get Head Office account No. Windows uses Invoice To Account. *}



    If (GetCust(Application.MainForm,KeyS,FoundCode,BOn,-1)) then
    Begin


      If (n=1) then
      Begin
        DelAddr:=Cust.Addr;
        // MH 02/01/2015 v7.1 ABSEXCH-15980: Corrected to copy the PostCode and Country
        CustPostCode := Cust.PostCode;
        CustCountry := Cust.acCountry;
      End; // If (n=1)

      If (Not EmptyKey(Cust.SOPInvCode,CustKeyLen)) and (Mode In [2,3,60..61,65,66]) and (Cust.SOPInvCode<>FirstCode) then
      Begin

        KeyS:=FullCustCode(Cust.SOPInvCode);

        Loop:=BOff;

      end;
    end;

    inc(n);

    Loop:=Not Loop;

  Until (Not Loop);


  If (ConsA) then {* Do we have a doc already? of the right currency? *}
  Begin

    KeyChk:=FullCustType(Cust.CustCode,CustHistPOCde);

    FoundHed:=Find_RunHed(KeyChk,Fnum,InvCustK,InvR.Currency,SRunNo,InvR.SSDProcess);

  end;


  If (Not FoundHed) then
  With Inv do
  Begin

    Inv:=InvR;

    InvDocHed:=Set_MatchLinkDoc(InvR.InvDocHed,Mode);



    If (InvR.HoldFlg and HoldNotes = HoldNotes) then
      HoldFlg:=HoldNotes
    else
      HoldFlg:=0;

    ILineCount:=1;
    NLineCount:=1;

    Blank(BatchLink,Sizeof(BatchLink));

    BatchLink:=SOP_RunNo(SRunNo,InvDocHed);

    Case Mode of

      //  Alledgedly 1 = Orders to Delivery notes
      //             3 = Orders direct to Invoices
      1,3
         :  Begin

              If (Not Syss.ProtectYRef) then
              Begin

                YourRef:=InvR.OurRef;

                TransDesc:=InvR.YourRef;
              end
              else
              Begin
                If (Trim(YourRef)='') then
                  YourRef:=InvR.OurRef
                else
                  If (Trim(TransDesc)='') then
                    TransDesc:=InvR.OurRef;
              end;

              Blank(RemitNo,Sizeof(RemitNo));

              RemitNo:=InvR.OurRef;



              OrdMatch:=BOn; {* This extra flag is necessary,
                               as when you unallocate a document,
                               the remitNo. is blanked, and match is fooled
                               into searching by the other key *}


              Case Mode of
                1  :  Begin
                        RunNo:=(Set_OrdRunNo(InvDocHed,BOff,BOff)-3);

                        TransDate:=Today;

                        DueDate:=CalcDueDate(TransDate,Cust.PayTerms);
                      end;

                3  :  Begin
                        //PR: 28/08/2012 ABSEXCH-2975 moved the setting of 'TransDate' to before the Set_DocRunStat call instead of after;
                        //this means that the due date of a SOR>SIN invoice will be calculated from the date the invoice is raised
                        //instead of the date the order was raised

                        {v5.70 ?OR->?IN refresh date}
                        TransDate:=Today;

                        Set_DocRunStat(Inv);

                      end;

              end; {Case..}


            end; {With..}

      // Allegedly Delivery Notes to Invoices
      2
         :  Begin

              Set_DocRunStat(Inv);

              If (InvR.InvDocHed In DeliverSet) and (InvR.HoldFlg AND HoldNotes=HoldNotes) then
              Begin

                HoldFlg:=HoldNotes;

                NLineCount:=InvR.NLineCount;

              end;

            end; {With..}

      {$IFDEF RET}
        50..59
          :  Begin
               Blank(BatchLink,Sizeof(BatchLink));

               RunNo:=Set_RetRunNo(InvDocHed,BOff,BOff);

               CustSupp:=Ret_CustSupp(InvDocHed);

               // CJS 2014-06-23 - ABSEXCH-12765
               // - Currency of preferred supplier on back-to-back PRNs
               // - Discounts on back-to-back returns
               if (Inv.InvDocHed = PRN) and (InvR.InvDocHed = SRN) then
               begin
                 Currency := Cust.Currency;
                 CXRate   := SyssCurr.Currencies[Currency].CRates;
                 DiscSetl  := 0.0;
                 DiscSetAm := 0.0;
                 DiscAmount:= 0.0;
                 DiscDays  := 0;
                 DiscTaken := False;

                 // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
                 thPPDPercentage := 0.0;    // Discount Percentage - Note: 0.1 = 10%
                 thPPDDays       := 0;      // Number of days discount offer is valid for
                 thPPDGoodsValue := 0.0;    // Goods Value of Discount (if taken) in Transaction Currency
                 thPPDVATValue   := 0.0;    // VAT Value of Discount (if taken) in Transaction Currency
                 // MH 05/05/2015 v7.0.14 ABSEXCH-16284: PPD Mods
                 thPPDTaken      := ptPPDNotTaken;  // TRUE if the Prompt Payment Discount was given
               end;

               // MH 11/03/2010 v6.3: Modified Returns to copy in Control GL from Cust/Supp where appropriate
               If (Cust.DefCtrlNom <> 0) Then
                 Inv.CtrlNom := Cust.DefCtrlNom;

               OrdMatch:=BOff;
               Blank(RemitNo,Sizeof(RemitNo));
               TransMode:=0;
               TransNat:=0;


             end;
        60..79
          :  Begin
               {$IFDEF SOP}
                 RunNo:=Set_OrdRunNo(InvDocHed,BOff,BOff);

                 TransNat:=SetTransNat(InvDocHed);

                 TransMode:=Cust.SSDModeTr;
                 DelTerms:=Trim(Cust.SSDDelTerms);

                 If (Mode In [60,65]) then
                 Begin
                   Blank(RemitNo,Sizeof(RemitNo));
                   OrdMatch:=BOff;
                 end;

               {$ELSE}
                 RunNo:=0;
               {$ENDIF}

               CustSupp:=TradeCode[(InvDocHed In SalesSplit)];

               // MH 11/03/2010 v6.3: Modified Returns to copy in Control GL from Cust/Supp where appropriate
               If (Cust.DefCtrlNom <> 0) Then
                 Inv.CtrlNom := Cust.DefCtrlNom;

               TransDate:=Today;

               If (InvDocHed In PSOPSet) then {* Set a separator in ledger *}
                 CustSupp:=Chr(Succ(Ord(CustSupp)))
               else
               Begin

                 DueDate:=CalcDueDate(TransDate,Cust.PayTerms);

                 If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
                   Date2Pr(TransDate,ACPr,ACYr,nil)
               end;

             end;
      {$ENDIF}

    end; {Case..}




    PrintedDoc:=BOff;

    If (Not KeepTagNo) then
      Tagged:=0;

    CustCode:=Cust.CustCode;


    OpName:=EntryRec^.LogIn;

    { CJS - 2013-10-25 - MRD2.6.02 - Transaction Originator }
    TransactionOriginator.SetOriginator(Inv);

    If (DAddr[1]='') and (DAddr[2]='') then
    Begin
      DAddr:=DelAddr;
      // MH 02/01/2015 v7.1 ABSEXCH-15980: Corrected to copy the PostCode and Country
      thDeliveryPostCode := CustPostCode;
      thDeliveryCountry := CustCountry;
    End; // If (DAddr[1]='') and (DAddr[2]='')

    SetNextDocNos(Inv,BOn);

    {$IFDEF RET}
      If (Not (Mode In [50..79])) then
    {$ENDIF}
      CustSupp:=CustHistPOCde;

    //Re_setDocTots(Inv,((Not Inv.ManVAT) or (ConsA) or (Mode In [1,3]))); {* Don't auto reset vat automaticly, unless a consolidated inv or Delivery note *}

    // MH 02/11/2010 v6.5 ABSEXCH-2882: Leave Manual VAT intact through Order Processing chain
    Re_setDocTots(Inv, (Not Inv.ManVAT) or ConsA); // Reset VAT if Manual VAT not set or we are consolidating multiple transactions together

    PickRunNo:=SRunNo;



    Blank(VATPostDate,Sizeof(VATPostDate));
    FillChar(PostDate,Sizeof(PostDate),0);
    FillChar(OldORates,Sizeof(OldORates),0);


    If (Not SOPKeepRate) then
    Begin
      CXrate:=SyssCurr.Currencies[Currency].CRates;
      SetTriRec(Currency,UseORate,CurrTriR);
    end;

    CXrate[BOff]:=0;

    VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;

    OrigRates:=SyssCurr^.Currencies[Currency].CRates;

    UseORate:=0;

    SetTriRec(Syss.VATCurr,UseORate,VATTriR);

    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

    //GS 04/11/2011
    if Status = 0 then
    begin
      TAuditNote.WriteAuditNote(anTransaction, anCreate);
    end;

    Report_BError(Fnum,Status);

    If (StatusOk) then
      LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,HedAddr);


    FoundHed:=StatusOk and LOK;


  end; {If FoundHed}

  Get_InvHed:=FoundHed;

end; {Func..}



{$IF Defined(WOP) or  Defined(RET)}

    { ========= Auto generation of Adj Header ======== }

  Function Get_AdjHed(ConsA :  Boolean;
                      AdjNo :  Str10;
                      InvR  :  InvRec;
                      SRunNo:  LongInt;
                      Fnum,
                      Keypath
                            :  Integer;
                      Mode  :  Byte;
                 Var  HedAddr
                            :  LongInt)  :  Boolean;





  Var
    KeyChk,
    KeyS     :  Str255;

    FoundHed,
    Locked,
    LOK      :  Boolean;

    n        :  Byte;

    FirstCode,
    FoundCode:  Str20;



    RecAddr  :  LongInt;


  Begin

    FoundHed:=BOff;  LOK:=BOff;  Locked:=BOff;

    n:=1;

    RecAddr:=0;  HedAddr:=0;


    If (ConsA) then {* Do we have a doc already? *}
    Begin

      KeyChk:=AdjNo;

      FoundHed:=CheckRecExsists(KeyChk,InvF,InvOurRefK);

    end;



    If (Not FoundHed) then
    With Inv do
    Begin

      Inv:=InvR;

      InvDocHed:=Set_MatchLinkDoc(InvR.InvDocHed,Mode);

      If (InvR.HoldFlg and HoldNotes = HoldNotes) then
        HoldFlg:=HoldNotes
      else
        HoldFlg:=0;

      ILineCount:=1;
      NLineCount:=1;

      Blank(DelTerms,Sizeof(DelTerms));

      ExternalDoc:=BOn; {Force ADJ not to be editable}


      Case Mode of

        80,81, 100,101
           :  Begin

                YourRef:=InvR.OurRef;

                If (Mode In [80,81]) then
                Begin
                  If (Mode=80) and (Not Is_StdWOP) then
                    TransDesc:='Works Iss/'+InvR.YourRef
                  else
                    TransDesc:='Works Bld/'+InvR.YourRef;
                end
                else
                  If (Mode In [100,101]) then
                  Begin
                    TransDesc:='Return Adj '+InvR.YourRef;
                  end;

                If (Trim(InvR.YourRef)='') then
                  TransDesc:=Trim(YourRef)+'. '+Copy(TransDesc,1,pred(Length(TransDesc)));

                Blank(RemitNo,Sizeof(RemitNo));

                Blank(CustCode,Sizeof(CustCode));

                RemitNo:=InvR.OurRef;



                OrdMatch:=BOn; {* This extra flag is necessary,
                                 as when you unallocate a document,
                                 the remitNo. is blanked, and match is fooled
                                 into searching by the other key *}


                Case Mode of
                  80,81, 100,101
                     :  Begin
                          Case Mode of
                            80,81  :  RunNo:=(Set_WOrdRunNo(InvDocHed,BOff,BOff)-3);
                            100,101:  RunNo:=(Set_RETRunNo(InvDocHed,BOff,BOff)-5);

                          end; {Case..}

                          TransDate:=Today;
                          DueDate:=Today;

                          AcPr:=GetLocalPr(0).CPr;
                          AcYr:=GetLocalPr(0).CYr;

                          If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
                            Date2Pr(TransDate,AcPr,AcYr,nil);

                          
                        end;


                end; {Case..}


              end; {With..}


      end; {Case..}




      PrintedDoc:=BOff;

      Tagged:=0;

      OpName:=EntryRec^.LogIn;

      { CJS - 2013-10-25 - MRD2.6.02 - Transaction Originator }
      TransactionOriginator.SetOriginator(Inv);

      SetNextDocNos(Inv,BOn);

      Re_setDocTots(Inv,BOn);

      Blank(BatchLink,Sizeof(BatchLink));

      BatchLink:=SOP_RunNo(SRunNo,InvDocHed);

      PickRunNo:=SRunNo;


      Blank(VATPostDate,Sizeof(VATPostDate));
      FillChar(PostDate,Sizeof(PostDate),0);
      FillChar(OldORates,Sizeof(OldORates),0);


      If (Not SOPKeepRate) then
      Begin
        CXrate:=SyssCurr.Currencies[Currency].CRates;
        SetTriRec(Currency,UseORate,CurrTriR);
      end;

      CXrate[BOff]:=0;

      VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;

      UseORate:=0;

      SetTriRec(Syss.VATCurr,UseORate,VATTriR);

      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      If (StatusOk) then
        LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,HedAddr);

      FoundHed:=StatusOk and LOK;


    end; {If FoundHed}

    Get_AdjHed:=FoundHed;

  end; {Func..}


  { == Func to return WIP G/L for issue transfer == }

  Function WOP_LinkWIPNom(IdR     :  IDetail;
                          Keypath2:  Integer;
                          Mode    :  Byte)  :  Longint;

  Const
    Fnum    =  IDetailF;
    Keypath =  IdFolioK;

  Var
    TmpId   :  IDetail;
    TmpStk  :  StockRec;

    TmpKPath,
    LocalStat,
    TmpStat :  Integer;

    TmpRecAddr
            :  LongInt;

    KeyS    :  Str255;


  Begin
    Result:=IdR.NomCode;

    TmpId:=Id;
    TmpStk:=Stock;

    TmpKPath:=Keypath2;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    KeyS:=FullIdKey(IdR.FolioRef,1);

    TmpStat:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    If (TmpStat=0) then
    Begin
      If (Stock.StockCode<>Id.StockCode) then
        If Not (Global_GetMainRec(StockF,Id.StockCode)) then
          ResetRec(StockF);

        With Stock do
        Begin
          {$IFDEF SOP}
            Stock_LocNSubst(Stock,Id.MLocStk);
          {$ENDIF}

          If (Is_StdWOP) then
            Result:=NOMCodeS[5]
          else
            If (WOPWIPGL<>0) then
              Result:=WOPWIPGL
            else
              Result:=NOMCodeS[3];

        end;

    end;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    Id:=TmpId;
    Stock:=TmpStk;
  end;





{$IFEND}

{$IF Defined(WOP) or  Defined(RET)}
   Procedure SetLink_Cost(Var IdR  :  IDetail;
                              InvR :  InvRec);

   Var
     Rnum  :  Double;
     TmpStk:  ^StockRec;

   Begin
     With IdR do {* v5.60.002 If stock is last cost, avg, or std refresh cost *}
     If (FIFO_Mode(SetStkVal(Stock.StkValType,Stock.SerNoWAvg,BOn)) In [1,4,6]) then
     Begin
       New(TmpStk);
       TmpStk^:=Stock;

       {$IFDEF SOP}
         Stock_LocLinkSubst(Stock,MLocStk);
       {$ENDIF}
                                                         {* Changed from BOff? *}
       Rnum:=Currency_ConvFT(Calc_StkCP(Stock.CostPrice,Stock.BuyUnit,(Stock.DPackQty And Stock.CalcPack)),
                             Stock.PCurrency,InvR.Currency,UseCoDayRate);

       {* To be replaced by FIFO Calc *}

       CostPrice:=Round_Up(Rnum,Syss.NoCosDec);

       Stock:=TmpStk^;
       Dispose(TmpStk);
     end;
   end; {Proc..}

{$IFEND}


{ ========= Function to Gen Doc Line ======== }


Function Gen_InvLine(IdR   :  IDetail;
                     InvR  :  InvRec;
                     Fnum,
                     Keypath
                           :  Integer;
                     Mode  :  Byte;
                     ConsA :  Boolean;
                 Var MatchVal
                           :  Real)  :  Boolean;


Var
  TmpOk  :  Boolean;

  OStat  :  Integer;

  dFreeStk
         :  Double;

  TmpRef :  Str10;

  FoundCode
         :  Str20;
  OCust  :  CustRec;

  KeyS   :  Str255;

  WantRecalcStockCost : Boolean;


Begin
  Id:=IdR;

  TmpOk:=BOff;

  TmpRef:='';  OStat:=0;  dFreeStk:=0.0;


  With Id do
  Begin

    If (Mode In [11..13]) then
      ResetRec(Fnum);

    CustCode:=Inv.CustCode;
    CXRate:=Inv.CXRate;
    CurrTriR:=Inv.CurrTriR;

    // CJS 2014-06-23 - ABSEXCH-12765 - currency of preferred supplier on back-to-back PRNs
    if (Inv.InvDocHed = PRN) and (InvR.InvDocHed = SRN) then
    begin
      Id.Currency := Cust.Currency;
      Id.CXrate[UseCoDayRate] := SyssCurr^.Currencies[Currency].CRates[UseCoDayRate];
    end;

    UseORate:=Inv.UseORate;

    {Reset COS exchange rate}

    {* Keep rate at posting used for COS if non Serial Item*}

    If (IdR.SerialQty=0.0) then {v4.32.003}
      COSConvRate:=SyssCurr^.Currencies[Currency].CRates[UseCoDayRate];

    FolioRef:=Inv.FolioNum;

    DocPRef:=Inv.OurRef;

    IdDocHed:=Inv.InvDocHed;

    LineType:=StkLineType[IdDocHed];

    If (Not (Mode In [80,81, 100,101])) then
      Lineno:=Inv.ILineCount
    else
      LineNo:=RecieptCode;

    ABSLineNo:=Inv.ILineCount;

    {* Bring Period in line with Header *}

    Id.PPr:=Inv.AcPr;

    Id.PYr:=Inv.AcYr;

    If (Not (Inv.InvDocHed In [SIN,PIN])) then {* Otherwise preserve orig delivery date *}
      PDate:=Inv.TransDate;

    Case Mode of

      1,3,80,81, 100,101
         :  Begin


              If (KitLink<>0) and (Not Is_FullStkCode(StockCode)) then {* Mod of Desc only *}
                Qty:=0
              else
                Case IdR.IdDocHed of
                  SRN  :  Qty:=IdR.QtyPWOff;
                  else    Qty:=IdR.QtyPick;
                end; {Case..}

              QtyDel:=0;

              QtyWOff:=0;

              If (Mode In [3,80,81, 100,101 ]) then
              Begin
                QtyPick:=0;
                If (Mode In [100,101]) then
                Begin
                  QtyPWoff:=0.0;
                  SSDUplift:=0.0;
                end;
              end;

              If (Mode In [80,81, 100,101]) then
              Begin
                QtyMul:=1.0;

                If (Mode In [80,100]) then
                  Qty:=Qty*DocNotCnst; {*Reverse effect out as we are deducting stock*}
              end;

              SOPLink:=InvR.FolioNum;

              SOPLineNo:=IdR.ABSLineNo;

              { If this is an Adjustment for a Sales Return, convert to base
                currency. }
              if (Mode = 101) and (IdR.IdDocHed In StkRetSalesSplit) then
              begin
                with SyssCurr^.Currencies[Id.Currency] do
                  MatchVal := MatchVal + Conv_TCurr(InvLTotal(Id,BOn,(Inv.DiscSetl*Ord(Inv.DiscTaken))),CRates[UseCoDayRate],Id.Currency,0,BOff);
              end
              else
              MatchVal:=MatchVal+InvLTotal(Id,BOn,(Inv.DiscSetl*Ord(Inv.DiscTaken)));

              If (Mode In [100,101]) then
              Begin
                If (IdR.IdDocHed In StkRetSalesSplit) then {* Its an ADJ so net value not relevant *}
                  NetValue:=0.0;

                If (IdDocHed In StkRetPurchSplit) then
                  CostPrice:=NetValue {We are dealing with the netvalue here}
                else
                  {$B-}
                  If (Is_FullStkCode(StockCode)) and Global_GetMainRec(StockF,IdR.StockCode) then
                  {$B+}
                    NomCode:=Stock.NomCodes[3];

              end;

            end; {mode 1}

      2
         :  Begin

              QtyDel:=0;
              QtyWOff:=0;

              QtyPick:=0;

              {v571.000 If last cost, std or average, restore original conversion rate *}

              {$B-}
                If (Is_FullStkCode(StockCode)) and Global_GetMainRec(StockF,IdR.StockCode) then
              {$B+}
                Begin
                  If (FIFO_Mode(SetStkVal(Stock.StkValType,Stock.SerNoWAvg,BOn)) In [1,4,6]) then
                    COSConvRate:=Idr.COSConvRate;
                end;

            end; {mode 2}

      11..13
         :  Begin

              Currency:=Inv.Currency; {* Set these as otherwise export/import fails *}


              If (Mode In [12,13]) then
              Begin
                TmpRef:=SOP_GetSORNo(IdR.SOPLink);

                If (TmpRef<>'') and (Not CheckKey(TmpRef,Inv.YourRef,Length(TmpRef),BOff)) then
                  Desc:=TmpRef+'/';

              end;

              Desc:=Desc+InvR.OurRef;


              If (ConsA) and (Not EmptyKey(InvR.YourRef,DocYReF1Len))
                 and ((Not CheckKey(TmpRef,InvR.YourRef,Length(TmpRef),BOff))
                 or (Mode=11)) then

                Desc:=Desc+'/'+Strip('B',[#32],InvR.YourRef);


              If (InvR.CustCode<>Inv.CustCode) then
              Begin

                OCust:=Cust;

                KeyS:=InvR.CustCode;

                GetCust(Application.MainForm,KeyS,FoundCode,BOn,-1);

                KeyS:='.'+Cust.CustCode+','+Strip('B',[#32],Cust.Company);

                Desc:=Desc+Copy(KeyS,1,(DocDesLen-Length(Desc)));

                Cust:=OCust;

              end;

            end;

    {$IFDEF RET}
      50..59
         :  Begin
              SOPLink:=InvR.FolioNum;

              SOPLineNo:=IdR.ABSLineNo;

              QtyPick:=IdR.Qty;

              Qty:=0.0;
              QtyDel:=0.0;
              QtyWOff:=0.0;
              QtyPWOff:=0.0;
              SSDUplift:=0.0;
              SSDSPUnit:=0.0;

              // CJS 2014-06-23 - ABSEXCH-12765 - Discounts on back-to-back returns
              if (Id.IdDocHed = PRN) then
              begin
                // When raising a back-to-back PRN, discounts should be removed
                // as they are not applicable
                Discount     := 0.0;
                DiscountChr  := #0;
                Discount2    := 0.0;
                Discount2Chr := #0;
                Discount3    := 0.0;
                Discount3Chr := #0;
              end;

              If (IdR.IdDocHed In WOPSplit) then
              Begin
                QtyMul:=1.0;
                NetValue:=CostPrice;
              end;

              // MH 20/04/2010 v6.4 ABSEXCH-9458: Reset Net Value on PRN's to the Cost Price from
              If (Id.IdDocHed = PRN) And (IdR.IdDocHed = SRN) Then
              Begin
                //HV 05/07/2016 2016-R3 ABSEXCH-16245: Convert NetValue based on currency which is default by supplier.
                CostPrice := Currency_ConvFT(IdR.CostPrice, IdR.Currency, Id.Currency, UseCoDayRate);
                CostPrice := Round_Up(CostPrice, Syss.NoCosDec);
                NetValue := CostPrice;
              end;

              DeductQty:=0.0;
              {SerialQty:=0.0;}
              BinQty:=0.0;
              BinRetQty:=0.0;
              SerialRetQty:=0.0;
              PreviousBal:=0.0;

              Payment:=DocPayType[IdDocHed];


              Case IdDocHed of
                PRN  :  Begin

                          If Global_GetMainRec(StockF,IdR.StockCode) then
                            NomCode:=Stock.PReturnGL;

                        end;
                SRN  :  Begin
                          If Global_GetMainRec(StockF,IdR.StockCode) then
                            NomCode:=Stock.ReturnGL;

                        end;
              end; {Case..}

              If (IdR.JAPDedType=1) then
              Begin
                If (Not (IdDocHed In [PRN])) or (Not (Is_FullStkCode(StockCode))) or (Not CheckNegStk) or (Stock.StockType=StkDescCode) then
                  Qty:=IdR.Qty
                else
                Begin {Check we have enough stock }

                  {$IFDEF SOP}
                    Stock_LocSubst(Stock,MLocStk);
                  {$ENDIF}

                  dFreeStk:=(Stock.QtyInStock-Stock.QtyPicked-Stock.QtyPickWOR);

                  If (dFreeStk<0.0) then
                    dFreeStk:=0.0;

                  If (dFreeStk<Idr.Qty) then
                    Qty:=dFreeStk
                  else
                    Qty:=IdR.Qty;

                end;
              end;

              If (NomCode=0) then
                NomCode:=IdR.NomCode;

              B2BLineNo:=IdR.NomCode;

              If (Is_FullStkCode(StockCode)) then
              Begin

                If (IdR.IdDocHed In SalesSplit) then
                Begin
                  COSNomCode:=Cust.DefCOSNom;

                 If (COSNomCode=0) then {* Use Stock COS *}
                   COSNomCode:=Stock.NomCodes[2];
                end
                else
                  If (Not (IdR.IdDocHed In StkRetSalesSplit)) then
                    CostPrice:=IdR.NetValue+IdR.CostPrice; {Store original cost price + any uplift incase of repair}

                If (Idr.IdDocHed In StkRetSalesSplit) and (Id.IdDocHed In StkRetPurchSplit) then {Its a back to back}
                Begin
                  {$IFDEF SOP}
                    Stock_LocNSubst(Stock,IdR.MLocStk);
                  {$ENDIF}


                  If (Stock.StockType=StkBillCode) then
                    NomCode:=Stock.NomCodes[5]
                  else
                    NomCode:=Stock.NomCodes[4];

                  B2BLineNo:=NomCode;

                end;
              end;
            end;

      60..79
         :  Begin
              Case Idr.IdDocHed of
                PRN  :  Begin
                          If (Mode In [60]) then
                            Blank(StockCode,Sizeof(StockCode));


                        end;

                SRN  :  Begin                    {* Maintain stock code on b2b repair as stock was prev booked in *}
                          If (Mode In [68]) or ((Mode In [62]) and (Not Idr.SSDUseLine)) or ((Mode In [60,65]) and (IdR.JAPDedType<>1)) then
                            Blank(StockCode,Sizeof(StockCode));

                        end;
              end; {Case..}

              Case Mode of
                60,61  :  Qty:=IdR.SSDUplift;

                62,65,
                66,68  :  Qty:=IdR.QtyPWOff;
              end; {Case..}

              QtyPick:=0.0;
              QtyDel:=0.0;
              QtyWOff:=0.0;
              QtyPWOff:=0.0;
              SSDUplift:=0.0;

              DocLTLink:=0;

              If (KitLink<>0) and (NetValue=0.0) and (Not (Is_FullStkCode(StockCode))) then
                Qty:=0.0; {Its a desc only line, so reset qty}

              If (IdDocHed In OrderSet+QuotesSet) then
              Begin
                DeductQty:=0.0;
                SerialQty:=0.0;
                SerialRetQty:=0.0;
                BinRetQty:=0.0;
                BinQty:=0.0;
              end;

              If (IdDocHed In PurchSplit) then
                CostPrice:=0.0;

              If (Mode In [61,66]) and (PreviousBal<>0.0) then
                NetValue:=PreviousBal;

              Payment:=DocPayType[IdDocHed];

              SOPLink:=0;

              SOPLineNo:=0;

              PostedRun:=0; PreviousBal:=0.0;

              NOMIOFlg:=0;

              If (Is_FullStkCode(Idr.StockCode)) then
              Begin
                If (B2BLineNo<>0) then
                  NomCode:=B2BLineNo
                else
                Begin
                  If Global_GetMainRec(StockF,IdR.StockCode) then
                  Begin
                    {$IFDEF SOP}
                      Stock_LocNSubst(Stock,IdR.MLocStk);
                    {$ENDIF}


                    Case IdR.IdDocHed of
                      PRN  :  If (Stock.StockType=StkBillCode) then
                                NomCode:=Stock.NomCodes[5]
                              else
                                NomCode:=Stock.NomCodes[4];

                      SRN  :  NomCode:=Stock.NomCodes[1];
                    end; {Case..}
                  end;

                  If (NomCode=0) then
                    NomCode:=IdR.NomCode;


                end;

                If (Idr.SSDUseLine) and (IdR.IdDocHed In StkRetSalesSplit) then
                Begin
                  If Global_GetMainRec(StockF,IdR.StockCode) then
                  Begin
                    {$IFDEF SOP}
                      Stock_LocNSubst(Stock,IdR.MLocStk);
                    {$ENDIF}

                    COSNOMCode:=Stock.NomCodes[3];
                  end;
                end
                else
                  COSNomCode:=0;
              end;
            end;
    {$ENDIF}


    end; {Case..}

    If (Mode In [1..3,80,81,50..67,69..79, 100,101 ]) and (SerialQty<>0) then {* Assume Serial Nos all accounted for at this stage *}
      SerialQty:=Qty*QtyMul;

    {v5.50 was an attempt to minimise the effect of PDN to PIN conversion which distorts things, but check will
                            only come along and distort }
    {v5.71 For average this was re-introduced so that any changes in xchange rate were reintrodcued to average}

    {PR: 08/01/2010 Added check to avoid recalculating stock cost for PDN-PIN average unless essential.
      Full explanation in DelvRunU.TSOPRunFrm.SOP_ConvertDel}
            {$IFDEF MC_ON}
            WantRecalcStockCost := (Mode = 2) //PDN-PIN
                                   and Is_FullStkCode(Id.StockCode)
                                   and (Id.IdDocHed = PIN)
                                   and (FIFO_Mode(Stock.StkValType)=4) //Average
                                   and (Inv.Currency <> Stock.PCurrency) //Transaction not same as stock cost currency
                                   and UseCoDayRate; {DailyRate}
            {$ELSE}
            WantRecalcStockCost := False;
            {$ENDIF MC_ON}


//      If (Not (Mode In [2,68]))  or ((Idr.IdDocHed<>PDN) {$IFDEF MC_On} or (FIFO_Mode(Stock.StkValType)=4) {$ENDIF} ) then
      If (Not (Mode In [2,68]))  or ((Idr.IdDocHed<>PDN) {$IFDEF MC_On} or (WantRecalcStockCost) {$ENDIF} ) then
      Begin
        Stock_Deduct(Id,Inv,BOn,BOn,0);

        {$IF Defined(WOP) or  Defined(RET)}
          If (Mode In [80,100]) then {* v5.60.002 If stock is last cost, avg, or std refresh cost *}
            SetLink_Cost(Id,Inv);
        {$IFEND}
      end;

    //PR: 28/08/2009 May be temporary - need to check with DR post v6.01 whether ManVAT should be always be replicated
    //onto Delivery Note (which it currently isn't. In the meantime we need it to be on PDN if ECService)
    if ((Inv.InvDocHed in PurchSplit) and (Id.ECService) and (InvR.ManVAT)) then
      Inv.MANVat := True;

    If (IdDocHed<>Adj) and not ((Inv.InvDocHed in PurchSplit) and (Id.ECService) and (Inv.ManVAT)) then
      CalcVat(Id,Inv.DiscSetl);

    If (IdDocHed In PurchSplit) and (Not EmptyKey(AnalCode,AnalKeyLen)) and (Not EmptyKey(JobCode,JobKeyLen))
       and (JBCostOn) then

    Begin
      NomCode:=Job_WIPNom(NomCode,JobCode,AnalCode,StockCode,MLocStk,CustCode);

    end;

    {$IFDEF WOP}
       If (Mode In [80,81]) then
         NomCode:=WOP_LinkWIPNom(IdR,Keypath,Mode);

    {$ENDIF}

    {$IFDEF RET}
       If (Mode In [100,101]) then;
         {NomCode:=  not sure if we need to manipulate this}


    {$ENDIF}

    {v5.51? When converting a PDN to a PIN, there is no effecive stock movement, but as this routine was,
            it deleted the PDN line reversed out the stock effect, and then recreated it all altering
            the FIFO order and the ledger order. As of v5.52? PDN conversions do not affect stock, and they
            upate the original line rather then replace it so their pos in the ledger remains the same so
            that check does not distort it either }

    If (Mode<>2) or (Idr.IdDocHed<>PDN) then
      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath)
    else
      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);


    Report_BError(Fnum,Status);

    TmpOk:=StatusOk;

    {$IFDEF Pf_On}

      If (JbCostOn) and (InvLTotal(Id,BOff,0)<>0) and (KitLink=0) then
        Update_JobAct(Id,Inv);

      If (Mode In [2,3,12,13]) then
      Begin
        OStat:=Status;

        Stock_AddCustAnal(Id,BOn,0);

        Status:=OStat;
      end;


    {$ENDIF}


    Inc(Inv.ILineCount);

  end;


  Gen_InvLine:=TmpOk;

end; {Func..}



{ =========== Proc to Allow doc to be displayed on Daybook ========== }


Procedure Reveal_SOPDoc(Var  InvR  :  InvRec;
                             Mode  :  Byte);


Begin

  With InvR do
  Begin

    Case Mode of
      1  :  Begin
              RunNo:=Set_OrdRunNo(InvDocHed,BOff,BOff);

              CustSupp:=Chr(Succ(Ord(TradeCode[(InvdocHed In SalesSplit)])));
            end;

      2,3
         :  Begin

              RunNo:=0;

              CustSupp:=TradeCode[(InvDocHed In SalesSplit)];

            end;

      80,81
        :  Begin
             RunNo:=Set_WOrdRunNo(InvDocHed,BOff,BOff);

           end;

      100,101
        :  Begin
             RunNo:=0;

           end;

    end; {Case..}


  end; {With..}

end; {Proc..}


{ ======= Function to Determine if QtyPicked needs checking ======= }

Function SOP_CheckLoc(IdR      :  IDetail;
                      SOPMLoc  :  Str10;
                      Mode     :  Byte)  :  Boolean;

Begin

  With IdR do
  Begin

    SOP_CheckLoc:=((Not Syss.UseMLoc) or (CheckKey(SOPMLoc,MLocStk,Length(SOPMLoc),BOff)));
  end;

end;

{ ======= Function to Determine if QtyPicked needs checking ======= }

Function SOP_CheckPickQty(IdR   :  IDetail;
                          Mode  :  Byte)  :  Boolean;

Var
  TmpBo  :  Boolean;

Begin
  {* Note:- Qty Pick is set on delivery notes primarily for desc lines, however
            if the user alters the qty on the delivery note, this is not reflected
            on the qty picked which is hidden, so an additional check is made on qty with
            checks for desc only lines attached to a product. SOPLink check used to
            identify lines added after the order was processed *}

  With IdR do
  Case Mode of

    1,3
       :  TmpBo:=(((IdDocHed In SalesSplit) and (Not Syss.DelPickOnly)) or (Round_Up(QtyPick,Syss.NoQtyDec)<>0));

    2  :  TmpBo:=(((Round_Up(QtyPick,Syss.NoQtyDec)<>0) and ((Qty<>0) or ((KitLink<>0)
                  and (Not Is_FullStkCode(StockCode)))))
                  or (SOPLink=0)
                  or ((Qty<>0) and (SOPLink<>0) and (Is_FullStkCode(StockCode))));
  60,61  :     TmpBo:=(Round_Up(SSDUplift,Syss.NoQtyDec)<>0);
  62,64,
  65,66,
  68     :     TmpBo:=(Round_Up(QtyPWOff,Syss.NoQtyDec)<>0);
  63     :     TmpBo:=(Round_Up(SSDUplift,Syss.NoQtyDec)<>0);

  80,81
       :  TmpBo:=(Round_Up(QtyPick,Syss.NoQtyDec)<>0);

  100  : TmpBo:=(Round_Up(QtyPick,Syss.NoQtyDec)<>0) and Is_FullStkCode(StockCode);

  101  : TmpBo:=(Round_Up(QtyPWOff+(SSDUpLift{*Ord(IdDocHed In StkRetPurchSplit)}),Syss.NoQtyDec)<>0) and Is_FullStkCode(StockCode);

    else  TmpBo:=BOff;


  end; {Case..}

  SOP_CheckPickQty:=TmpBo;

end; {Func..}




  { ==== Follow Chain and calc max poss build qty ==== }

  {======== Replicated in StkWarnU ========== }

  Function HowManyBOM(StockR  :  StockRec;
                      WithOwn,
                      TopMan  :  Boolean;
                      Lc      :  Str10;
                      WMode   :  Byte)  :  Double;

  Const

    Fnum     =  PWrdF;

    Keypath  =  PWK;


    Fnum2    =  StockF;
    Keypath2 =  StkFolioK;



  Var
    TmpOk,
    Ok2Cont  :  Boolean;

    KeyS,
    KeyChk,
    KeyStk   :  Str255;

    RecAddr2,
    RecAddr  :  LongInt;

    QtyAvail,
    fQtyUsed,
    BOMQtyUsed,
    MaxQty,
    LowQty   :  Double;

    OldStk   :  StockRec;


  Begin
    MaxQty:=0; LowQty:=0; Result:=0; QtyAvail:=0;  BOMQtyUsed:=0.0;

    Ok2Cont:=BOn; TmpOk:=BOff;  fQtyUsed:=0.0;


    If (Syss.DeadBOM) or (WMode=1) then
    Begin

      OldStk:=Stock;

      If (TopMan) then
        Status:=GetPos(F[Fnum],Fnum,RecAddr2);

      With StockR do
      Begin

        KeyS:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StockFolio)));

        KeyChk:=KeyS;

        {$IFDEF SOP}

          {Stock_LocSubst(StockR,lc); Not sure yet if componets should be location based? }

        {$ENDIF}

      end;

      Reset_Alloc(AllocBCode,BOff);

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Ok2Cont) do
      With Password.BillMatRec do
      Begin
        Application.ProcessMessages;


        Status:=GetPos(F[Fnum],Fnum,RecAddr);

        BOMQtyUsed:=QtyUsed;

        KeySTk:=Copy(BillLink,1,Sizeof(RecAddr));

        Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyStk);


        If (StatusOk) and (Stock.StockType<>StkDescCode) then
        Begin
          {$IFDEF SOP}

            {Stock_LocSubst(Stock,lc); Not sure yet if componets should be location based? }

          {$ENDIF}

          If (Stock.StockType<>StkBillCode) then
          Begin

            QtyAvail:=Stock.QtyInStock;

            {* This takes into account any allocation during auto pick as well
                              If used for any other purpase, additional switch required *}
            QtyAvail:=(Stock.QtyInStock-Stock.QtyPicked-
                       Get_LastAlloc(FullAllocFile(AllocTCode,AllocBCode,Stock.StockFolio),TmpOk,BOn){-
                       Get_LastAlloc(FullAllocFile(AllocTCode,AllocUCode,Stock.StockFolio),TmpOk,BOn)});

            If (QtyAvail>0) then
            Begin
              If (QtyUsed<>0) then
                fQtyUsed:=QtyUsed
              else
                fQtyUsed:=1;

              MaxQty:=Trunc(DivWChk(QtyAvail,fQtyUsed));
            end
            else
              MaxQty:=0;

            Put_LastAlloc(BOff,QtyUsed*MaxQty,AllocBCode,Stock.StockFolio);


          end
          else
            MaxQty:=Trunc(DivWChk(HowManyBOM(Stock,BOn,BOff,lc,WMode),BOMQtyUsed));


          Ok2Cont:=(MaxQty>0);

          If (MaxQty<LowQty) or (LowQty=0) then
            LowQty:=MaxQty;
        end; {If Stock record found..}


        SetDataRecOfs(Fnum,RecAddr);

        Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

        If (Ok2Cont) then
          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      end; {While..}

      If (TopMan) then
      Begin
        SetDataRecOfs(Fnum,RecAddr2);

        Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);
      end;

      Stock:=OldStk;
    end; {If..}

    Result:=LowQty;

    If (WithOwn) then
      Result:=Result+StockR.QtyInStock;

  end; {Proc..}


{ == Procedure to Reapply/unapply Credit Hold on the fly ==}

{$IFDEF CU}
    Procedure Apply_CreditHold(Const Update  :  Boolean;
                               Const Fnum,
                                     Keypath :  Integer;
                                     CustomEvent
                                             :  TCustomEvent);



    Var
      OldStat  :  Integer;

      OnCHold,
      NeedCHold,
      Locked,
      LOk      :  Boolean;

      PrevHold :  Byte;

      LAddr    :  LongInt;
      CrDr     :  DrCrDType;
      Cleared  :  Double;


      KeyS     :  Str255;
      ICust    :  CustRec;



    Begin
      PrevHold:=0;

      If (Syss.UseCreditChk) then
      Begin
        OldStat:=Status; LOk:=BOff; Locked:=BOff;

        OnCHold:=((Inv.HoldFlg AND HoldC)=HoldC);

        NeedCHold:=BOff;

        If (Cust.CustCode<>Inv.CustCode) then
        Begin
          KeyS:=Inv.CustCode;

          Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyS);
        end
        else
          Status:=0;

        If (StatusOk) then
        With Cust do
        Begin
          ICust:=Cust;

          If (Not EmptyKey(ICust.SOPInvCode,CustKeyLen)) then {* Substitute H/O account *}
          Begin
            KeyS:=FullCustCode(ICust.SOPInvCode);

            Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyS);

            If (Not StatusOk) then
              Cust:=ICust;

          end;

          Cleared:=0;


          With Syss do
            Cust.Balance:=Profit_to_Date(CustHistCde,CustCode,0,Cyr,99,CrDr[BOff],CrDr[BOn],Cleared,BOn);


                                                                                     {* v5.70 was checking 1..2 which included notes *}
          NeedCHold:=((((Cust.Balance+Cleared)>CreditLimit) and (CreditLimit<>0)) or (AccStatus In [2..3]) or (CreditStatus>=Syss.WksODue))
                     and ((Inv.HoldFlg and HoldP)<>HoldP);


          If (OnCHold<>NeedCHold) or (Assigned(CustomEvent)) then
          Begin

            If (Update) then
            Begin
              LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

            end;

            If (LOk and Locked) or (Not Update) then
            With Inv do
            Begin
              If (NeedCHold) then
                HoldFlg:=((HoldFlg And (HoldSuspend+HoldNotes))+HoldC)
              else
                HoldFlg:=(HoldFlg And (HoldSuspend+HoldNotes));

              PrevHold:=HoldFlg;

              {$IFDEF CU}
                 If (Assigned(CustomEvent)) then
                 With CustomEvent do
                 Begin
                   try
                     {* Refresh records we are interested in}
                     If (IsaCust(Cust.CustSupp)) then
                       TCustomer(EntSysObj.Customer).Assign(EnterpriseBase+2000,67,Cust)
                     else
                       TCustomer(EntSysObj.Supplier).Assign(EnterpriseBase+2000,67,Cust);

                     TInvoice(EntSysObj.Transaction).ResetTrans(Inv);

                     Execute;

                     HoldFlg:=EntSysObj.IntResult;

                     NeedCHold:=(HoldFlg<>PrevHold);
                   except;
                     HoldFlg:=PrevHold;
                   end;
                 end;

              {$ENDIF}


              If (Update) then
              Begin
                Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

                Report_BError(Fnum,Status);

                Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
              end;

              {$IFDEF SOP}
                If (NeedCHold) then {* Reset any previously picked lines *}
                  UpDate_OrdDel(Inv,BOff,BOn,Application.MainForm);
              {$ENDIF}

            end;
          end;

        end;

        Status:=OldStat;
      end;
    end;
{$ENDIF}





{== Function to return qty in kit ==}

Function HowManyInKit(StockR    :  StockRec;
                      CompCode  :  Str20)  :  Double;


Const
   Fnum     =  PWrdF;
   Keypath  =  PWK;

   Fnum2    =  StockF;
   Keypath2 =  StkFolioK;


Var
  LStatus      :  Integer;
  KeyChk,KeyS,
  KeyStk       :  Str255;

  FoundOk      :  Boolean;


Begin
  Result:=0.0;

  KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StockR.StockFolio)));

  KeyS:=KeyChk;


  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);
  FoundOk:=BOff;


  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
  With Password.BillMatRec do
  Begin

    KeySTk:=BillLink;

    LStatus:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyStk);

    FoundOk:=(LStatus=0) and (Stock.StockCode=CompCode);

    If (Not FoundOk) then
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS)
    else
      Result:=QtyUsed;
  end;


  HowManyInKit:=Result;

end;

{ == Procedure to reapply kit rules to any kits == *EN423}

Procedure ReApply_KitPick(Const Fnum,
                                Keypath  :  Integer;
                          Const KeyChk   :  Str255;
                                iWaitStk :  Boolean;
                                PickRNo  :  LongInt;
                                InvR     :  InvRec);


Var
  KeyS,
  KeyChk2,KeyS2
             :  Str255;

  LineAddr,
  KitLAddr,
  NextLAddr  :  LongInt;
  LastPQty,
  LowQty,
  AcQty,
  BOMWQty    :  Double;

  PStock     :  StockRec;
  KitLine    :  IDetail;

  FoundStk,
  CancelKit,
  NeedChange,
  SomeSet,
  LastPGood,
  WholeKit   :  Boolean;

  LStatus    :  Integer;


Begin
  KitLAddr:=0; LowQty:=0.0; NextLAddr:=0; BOMWQty:=0.0; LastPGood:=BOff; LastPQty:=0.0;

  KeyS:=KeyChk;  LineAddr:=0;

  LStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (LStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With Id do
  Begin
    Application.ProcessMessages;

    If (Is_FullStkCode(StockCode)) and (KitLink=0) then {* Its a potential candidate *}
    Begin
      KeyS2:=FullStockCode(StockCode);

      FoundStk:=Global_GetMainRec(StockF,KeyS2);

      If (FoundStk) and (Stock.StockType=StkBillCode) and (Stock.ShowasKit) then
      Begin
        PStock:=Stock; {* Set as parent Stock *}

        WholeKit:=(PStock.KitPrice);

        KitLine:=Id;

        LStatus:=GetPos(F[Fnum],Fnum,KitLAddr);  {* Get Preserve IdPosn *}

        CancelKit:=BOff; SomeSet:=BOff; LowQty:=-1.0; NextLAddr:=0; NeedChange:=BOff;


        LStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


        While (KitLink=PStock.StockFolio) and (LStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))
               and (Not CancelKit) do
        Begin
          Application.ProcessMessages;

          If (Is_FullStkCode(StockCode)) and (Qty_OS(Id)<>0) then
          Begin
            If (Not SomeSet) then
              SomeSet:=(QtyPick<>0);

            If (QtyPick<>0) then
            Begin
              If (QtyDel<>0) then
                AcQty:=KitLine.QtyDel
              else
                AcQty:=0.0;

              //PR: 05/01/2009 Trunc was giving bad results for some values - eg (Trunc(480 / 1.2) - 0.0) was giving 399 rather
              //than 400. Changed it to use Round_Up which seems to give the correct results
//              BOMWQty:=Trunc(DivWChk(QtyPick+QtyDel,HowManyInKit(PStock,FullStockCode(StockCode)))-AcQty);
              BOMWQty:=Round_Up(DivWChk(QtyPick+QtyDel,HowManyInKit(PStock,FullStockCode(StockCode)))-AcQty,
                                 Syss.NoQtyDec);

              If (BOMWQty<0.0) then
                BOMWQty:=0.0;
            end
            else
              BOMWQty:=0.0;

            If (BOMWQty>Qty_OS(KitLine)) then {* If there are more components than whole kits, then force it down *}
              BOMWQty:=Qty_OS(KitLine);


            If ((LowQty>BOMWQty) or (LowQty=-1.0)) then
              LowQty:=BOMWQty;

            CancelKit:=((QtyPick=0) or (LowQty=0.0)) and (WholeKit);

            If (Not NeedChange) then
              NeedChange:=(SomeSet and (QtyPick<>LowQty));

          end;

          LStatus:=GetPos(F[Fnum],Fnum,NextLAddr);  {* Get Preserve IdPosn *}

          If (Not CancelKit) then
            LStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS)
          else
            LowQty:=0.0;

        end;


        If (SomeSet) or (CancelKit) then {* We need to reprocess *}
        Begin

          SetDataRecOfs(Fnum,KitLAddr);

          If (KitLAddr<>0) then
            LStatus:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

          If (LStatus=0) then
          Begin
            Stock_Deduct(Id,InvR,BOff,BOn,3); {Reverse out any qty picked already}

            {Bring any bins in line}
            Auto_PickBin(Id,InvR,Id.QtyPick,Id.BinQty,1);

            QtyPick:=LowQty; {* Set Qty pick of parent to min picked this go*}

            Stock_Deduct(Id,InvR,BOn,BOn,3);

            {Bring any bins in line}
            Auto_PickBin(Id,InvR,Id.QtyPick,Id.BinQty,0);

            SOPLineNo:=PickRNo;

            LStatus:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

            Report_BError(Fnum,LStatus);

            LastPGood:=(QtyPick<>0.0);

            If (LastPGood) then
              LastPQty:=QtyPick
            else
              LastPQty:=0.0;

            SetDataRecOfs(Fnum,KitLAddr);

            If (KitLAddr<>0) then
              LStatus:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

            If (WholeKit) and (NeedChange or CancelKit) then {* Adjust all lines to whole amount sent *}
            Begin

              LStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


              While (KitLink=PStock.StockFolio) and (LStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
              Begin

                Application.ProcessMessages;

                If ((Is_FullStkCode(StockCode)) and (Qty_OS(Id)<>0))
                  or ((Not Is_FullStkCode(StockCode)) and (KitLink<>0)) then
                Begin
                  LStatus:=GetPos(F[Fnum],Fnum,LineAddr);  {* Get Preserve IdPosn *}


                  If (Is_FullStkCode(StockCode)) then
                  Begin
                    Stock_Deduct(Id,InvR,BOff,BOn,3); {Reverse out any qty picked already}

                    {Bring any bins in line}
                    Auto_PickBin(Id,InvR,Id.QtyPick,Id.BinQty,1);


                    If (Stock.StockCode=StockCode) and (Stock.StockType In StkProdSet) then
                    Begin
                      {$IFDEF RpXX}
                        {$IFDEF R6}
                          {Put_LastAlloc(BOff,QtyPick*DocNotCnst,AllocPCode,Stock.StockFolio);}
                        {$ENDIF}
                      {$ENDIF}
                    end;

                    {* Set Qty pick of parent to min picked this go*}
                    QtyPick:=LowQty*HowManyInKit(PStock,FullStockCode(StockCode));

                    If (QtyPick>Qty_OS(Id)) then
                      QtyPick:=Qty_OS(Id);

                    Stock_Deduct(Id,InvR,BOn,BOn,3);

                    {Bring any bins in line}
                    Auto_PickBin(Id,InvR,Id.QtyPick,Id.BinQty,0);


                    LastPGood:=(QtyPick<>0.0);

                    If (LastPGood) then
                      LastPQty:=QtyPick
                    else
                      LastPQty:=0.0;
                  end
                  else
                    If (LastPGood) then
                      QtyPick:=LastPQty
                    else
                      QtyPick:=0.0;

                  LStatus:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

                  Report_BError(Fnum,LStatus);

                  If (Stock.StockCode=StockCode) and (Stock.StockType In StkProdSet) then
                  Begin
                    {$IFDEF RpXX}
                      {$IFDEF R6}
                        {Put_LastAlloc(BOff,QtyPick,AllocPCode,Stock.StockFolio);}
                      {$ENDIF}
                    {$ENDIF}
                  end;

                  SetDataRecOfs(Fnum,LineAddr);

                  If (LineAddr<>0) then
                    LStatus:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);


                end;


                LStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

              end;

            end; {Whole kit only update}
          end; {Parent Line Found}
        end; {Any bits picked}

        SetDataRecOfs(Fnum,NextLAddr);

        If (NextLAddr<>0) then
          LStatus:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

      end; {Kit Found}

    end; {If Match..}

    LStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {while..}

end;




Function Auto_PickQty(InvR       :  InvRec)  :  Boolean;


Const
    Fnum2    =  IdetailF;

    Keypath2 =  IdFolioK;



Var
  FoundCode  :  Str20;

  KeySI,
  KeyChkI,
  GenStr  :  Str255;


  GotLines,
  LineOk,
  GotStock,
  TmpOk,
  PORMode,
  LastPGood,
  NoStop,
  ApplyKit
           :  Boolean;

  QtyAvail :  Double;
  FreeAll  :  Real;

  CopyId   :  IDetail;

  MsgForm  :  TForm;

  mbRet    :  TModalResult;




Begin
  Result:=BOff;

  GotLines:=BOff;

  LineOk:=BOff;

  FreeAll:=0; QtyAvail:=0;

  GotStock:=BOff;

  NoStop:=BOn;

  GenStr:=''; CopyId:=Id;

  TmpOk:=BOff; ApplyKit:=BOff;

  Set_BackThreadMVisible(BOn);

  LastPGood:=BOff;

  MsgForm:=CreateMessageDialog('Please Wait... Automatically picking order',mtInformation,[mbAbort]);
  MsgForm.Show;
  MsgForm.Update;



  KeyChkI:=FullNomKey(InvR.FolioNum);

  KeySI:=FullIdKey(InvR.FolioNum,1);

  Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

  While (StatusOk) and (CheckKey(KeyChkI,KeySI,Length(KeyChkI),BOn)) and (NoStop) do
  With Id do
  Begin

    PORMode:=(IdDocHed In PurchSplit);

    mbRet:=MsgForm.ModalResult;

    Loop_CheckKey(NoStop,mbRet);

    MsgForm.ModalResult:=mbRet;

    Application.ProcessMessages;
                                           {* This check ensures auto desc lines get picked if line b4 was picked *}
    If (Qty_OS(Id)<>0) or ((Not Is_FullStkCode(StockCode)) and (KitLink<>0) and (LastPGood)) then
    Begin

      GotStock:=GetStock(Application.MainForm,StockCode,FoundCode,-1);

      {$IFDEF SOP}
        Stock_LocSubst(Stock,MLocStk);

      {$ENDIF}

      If (GotStock) then
      Begin
        If (Stock.StockType=StkBillCode) and (Syss.DeadBOM) then
          QtyAvail:=HowManyBOM(Stock,BOn,BOn,MLocStk,0)
        else  {*v4.30 Qty picked added to take into account already picked *}
          QtyAvail:=StkApplyMul((Stock.QtyInStock-Stock.QtyPicked),QtyMul,(IdDocHed In SalesSplit))+QtyPick;
      end
      else
        QtyAvail:=0.0;

      // CJS 22/03/2011 - ABSEXCH-10124
      QtyAvail := Round_Up(QtyAvail, Syss.NoQtyDec);

      LineOk:=((Not GotStock)
            or (((QtyAvail>0)
            or (Stock.StockType=StkDescCode)
            or (PORMode)
            or (Stock.ShowAsKit)
            {* v4.30c was letting BOM's though and picking them regardless of stock level if Deduct stk off Fixed *}
            {or ((Stock.StockType=StkBillCode) and (Not Syss.DeadBOM))})

            and GotStock));

      If (LineOk) and (Not Is_SerNo(Stock.StkValType)) and ((CanAutoPickBin(Id,Stock,0) or (Not GotStock))) then  {* Do not auto pick for Serial Nos, leave alone *}
      Begin
        ApplyKit:=(ApplyKit or ((Stock.ShowAsKit) and (Qty_OS(Id)<>0)) and (Not PORMode));

        If (Not GotLines) and (Not PORMode) then
        Begin

          GotLines:=BOn;

          {Reset_Alloc(AllocUCode,BOff); * Stopped v4.23}


        end;



        Begin
          CopyId:=Id;

          If (Not Is_SerNo(Stock.StkValType)) and ((CanAutoPickBin(Id,Stock,0) or (Not GotStock))) then  {* Do not auto pick for Serial Nos *}
            QtyPick:=Qty_OS(Id)
          else
            QtyPick:=0;

          If (QtyPick=0) and (Not GotStock) and (Qty=0.0) and (KitLink<>0) then {* Force desc lines thru *}
            QtyPick:=1.0;

          If (GotStock) and (Stock.StockType In StkProdSet) and (Not PORMode) then
          Begin

           If (Stock.StockType=StkBillCode) and (Syss.DeadBOM) then {*v5.71. Force available to be BOM searched qty available *}
             FreeAll:=QtyAvail

          else {*v4.30 Qty picked added to take into account already picked *}
              FreeAll:=StkApplyMul((Stock.QtyInStock-Stock.QtyPicked),QtyMul,(IdDocHed In SalesSplit))+CopyId.QtyPick;

            {FreeAll:=(QtyAvail-
                      Get_LastAlloc(FullAllocFile(AllocTCode,AllocUCode,Stock.StockFolio),TmpOk,BOn));}

            {FreeAll:=Stock.QtyInStock;}

            If (FreeAll<QtyPick) then
            Begin

              If (FreeAll>0) then
                QtyPick:=FreeAll
              else
                QtyPick:=0;

            end;


            {Put_LastAlloc(BOff,QtyPick,AllocUCode,Stock.StockFolio);}

          end;


          If (QtyPick=0) then
          Begin        {* Mod for description part *}
            If ((KitLink<>0) and (Not GotStock)) then
              QtyPick:=1
            else       {* Force BOM Amount thru *}
              If ((Stock.StockType=StkBillCode)) and (Not Is_SerNo(Stock.StkValType)) and (CanAutoPickBin(Id,Stock,0)) then
                QtyPick:=Qty_OS(Id);

          end;

          QtyPWOff:=0;

          Result:=Result or (QtyPick<>CopyID.QtyPick);
          
          If (Is_FullStkCode(StockCode)) and (QtyPick<>0) then {* Update Picked Qty Status *}
          Begin
            

            Stock_Deduct(CopyId,InvR,BOff,BOn,3); {* Deduct previous amount picked }

            {Bring any bins in line}
            Auto_PickBin(CopyId,InvR,CopyId.QtyPick,Id.BinQty,1);

            Stock_Deduct(Id,InvR,BOn,BOn,3);

            {Bring any bins in line}
            Auto_PickBin(Id,InvR,Id.QtyPick,Id.BinQty,0);


            {Re Apply cost price here for non FIFO & Serial nos}
            If (IdDocHed In SalesSplit) and (QtyPick<>0) and
            (Not (FIFO_Mode(Stock.StkValType) In [2,3,5])) and (Stock.StockType<>StkDescCode)
            and ((Stock.StockType<> StkBillCode) or (Not Stock.ShowAsKit)) then
              CostPrice:=FIFO_GetCost(Stock,InvR.Currency,Qty*QtyMul,QtyMul,MLocStk);

          end;


          If (Id.KitLink=0) then
            LastPGood:=(QtyPick<>0.0);
        end;



      end {If LineOk..}
      else
        LastPGood:=BOff;

    end
    else
      LastPGood:=BOff; {If Line Due}

    Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2);

    Report_BError(Fnum2,Status);

    If (StatusOk) then  {* Find any connecting desc lines *}
      SOP_SeekDescLines(0,Id,Keypath2);

    {* If Got a Stock code, check for any desc lines immediately following *}

    Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

  end; {While..}


  If (ApplyKit) then
    ReApply_KitPick(Fnum2,Keypath2,KeyChkI,BOff,0,InvR);

  MsgForm.Free;

  Set_BackThreadMVisible(BOff);

end; {Proc..}



Procedure Auto_WOffQty(InvR       :  InvRec;
                       ResetW     :  Boolean);


Const
    Fnum2    =  IdetailF;

    Keypath2 =  IdLinkK;

    WOffMsg  :  Array[BOff..BOn] of Str20 = ('writing off','resetting');



Var
  KeySI,
  KeyChkI,
  GenStr  :  Str255;


  TmpOk,
  NoStop
           :  Boolean;

  FreeAll  :  Real;

  MsgForm  :  TForm;

  mbRet    :  TModalResult;





Begin


  FreeAll:=0;

  NoStop:=BOn;

  GenStr:='';

  TmpOk:=BOff;


  Set_BackThreadMVisible(BOn);

  MsgForm:=CreateMessageDialog('Please Wait... Automatically '+WOffMsg[ResetW]+' order',mtInformation,[mbAbort]);
  MsgForm.Show;
  MsgForm.Update;

  KeyChkI:=FullNomKey(InvR.FolioNum);

  KeySI:=FullIdKey(InvR.FolioNum,1);

  Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

  While (StatusOk) and (CheckKey(KeyChkI,KeySI,Length(KeyChkI),BOn)) and (NoStop) do
  With Id do
  Begin

    mbRet:=MsgForm.ModalResult;

    Loop_CheckKey(NoStop,mbRet);

    MsgForm.ModalResult:=mbRet;

    Application.ProcessMessages;

    If ((((Qty_OS(Id)-QtyPick)<>0) and (Not ResetW)) or ((QtyPWOff<>0) and (ResetW))) and ((KitLink=0) or (Is_FullStkCode(StockCode)) and (KitLink<>FolioRef)) then
    Begin
      If (ResetW) then
        FreeAll:=0
      else
        FreeAll:=(Qty_OS(Id)-QtyPick);

      QtyPWOff:=FreeAll;

    end; {If Line Due}

    Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2);

    Report_BError(Fnum2,Status);

    If (StatusOk) then  {* Find any connecting desc lines *}
      SOP_SeekDescLines(0,Id,Keypath2);

    {* If Got a Stock code, check for any desc lines immediately following *}

    Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

  end; {While..}


  MsgForm.Free;

  Set_BackThreadMVisible(BOff);

end; {Proc..}


{ ============= Procedure to Control Auto Pick.Write Off =========== }


Function Control_AutoPickWOff(AMode :  Byte;
                              InvR  :  InvRec;
                              LForm :  Tform)  :  Boolean;


Begin
  Result := True;
  Try
    LForm.Enabled:=BOff;

    Case AMode of
      1  :  Result:=Auto_PickQty(InvR);
      2,3:  Auto_WOffQty(InvR,(AMode=3));
    end;
  Finally
    LForm.Enabled:=BOn;

    If LForm.CanFocus then
    Begin
      LForm.BringToFront;
      LForm.SetFocus;
    end;
  end;

  If (AMode<>1) then
    Control_AutoPickWOff:=(AMode<>0);

end;



end.
