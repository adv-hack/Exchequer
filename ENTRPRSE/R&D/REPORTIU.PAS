unit ReportIU;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids, StrUtils,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,Recon3U, ReportU;


type



  TBatchReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       ValMode    :  Byte;
                       BatchCtrl  :  PassWordRec;
                       CustAlObj  :  GetExNObjCid;
                       ExtCustRec :  ExtCusRecPtr;


                       Procedure RepSetValTabs;

                       Procedure RepPrintPageHeader2;

                       Procedure CalcPayTotals(PayVal,
                                               SDisc,
                                               TTot,
                                               // MH 17/08/2015 2015-R1 ABSEXCH-16755: Added PPD Columns
                                               PPDValue  :  Double);


                       Procedure PrintPayTot;

                       Procedure PayEnd;

                       Function LBACSHook(HID     :  LongInt)  :  Boolean;

                       Function PayInclude  :  Boolean;

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Procedure PayLine;

                       Procedure PrintPayDetail;

                       Procedure CalcDueTotals(Var TTot,PTot      :  Totals);

                       Procedure PrintDueTot;

                       Function GetReportInput  :  Boolean; Virtual;

                     public

                       CRepParam  :  BatchPRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}

Procedure AddBatchPRep2Thread(LMode    :  Byte;
                              IRepParam:  BatchPRepPtr;
                              AOwner   :  TObject);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  Printers,
  TEditVal,
  ETDateU,
  ETStrU,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,
  InvListU,
  {RevalU2U,}
  SalTxl1U,
  ExtGetU,

  {$IFDEF POST}
    ReValueU,
  {$ENDIF}

  DocSupU1,
  BPyItemU,
  RpDefine,
  ExThrd2U,

  // MH 17/08/2015 2015-R1 ABSEXCH-16755: Added PPD Columns
  PromptPaymentDiscountFuncs,
  FormatFloatFuncs,

  //PR: 25/07/2013 Added handling for SEPA fields
  EncryptionUtils;


{ ========== TBatchReport methods =========== }

Constructor TBatchReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  ValMode:=0;
end;


Destructor TBatchReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;





Procedure TBatchReport.RepSetValTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ValMode of

        9,10
         :  Begin
              // MH 14/08/2015 2015-R1 ABSEXCH-16755: Changed indentation of Invoice section to
              // allow for extra columns to be added
              SetTab (MarginLeft+17, pjLeft, 21, 4, 0, 0);
              SetTab (NA, pjLeft,  30, 4, 0, 0);
              SetTab (NA, pjLeft,  18, 4, 0, 0);
              SetTab (NA, pjLeft,  18, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              // MH 17/08/2015 2015-R1 ABSEXCH-16755: Added PPD Columns
              SetTab (NA, pjLeft,  19, 4, 0, 0);    // PPD Taken?
              SetTab (NA, pjRight, 20, 4, 0, 0);    // PPD Value
              SetTab (NA, pjLeft,  30, 4, 0, 0);
             end;


    end; {Case..}
  end; {With..}

  SetTabCount;
end;



Procedure TBatchReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        7,8
         :  Begin
              SetTab (MarginLeft, pjLeft, 17, 2, 0, 0);
              SetTab (NA, pjLeft, 48, 4, 0, 0);
              SetTab (NA, pjLeft, 64, 4, 0, 0); // CJS 2014-07-10 - ABSEXCH-15161 - Field lengths on batch payments report
              SetTab (NA, pjLeft, 25, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjLeft, 18, 4, 0, 0);

              // MH 13/01/2016 2016-R1 <JIRA DOWN>: Added additional tabs convering sub-report section for .xlsx compatibility
              If (RDevRec.fePrintMethod = 5 {XLSX}) Then
              Begin
                SetTab (NA, pjRight, 20, 4, 0, 0);    // PPD Value
                SetTab (NA, pjLeft,  30, 4, 0, 0);    // Status
              End; // If (RDevRec.fePrintMethod = 5 {XLSX})
            end;

    end; {Case..}
  end; {With..}

  SetTabCount;
end;



Procedure TBatchReport.RepPrintPageHeader2;


Begin
  RepSetValTabs;

  With RepFiler1,CRepParam^ do
  Begin
    DefFont(0,[fsBold]);

    Case ValMode of

      9,10
          :  Begin
//               SendLine(ConCat(#9'Doc',' ','Ref',#9,'Your',' ','Ref',#9,'Date',#9,'Date',' ','Due',#9,'Orig.Total',#9,
//                       'Write Off',#9,'Total Due',#9,'Status'));

               // MH 17/08/2015 2015-R1 ABSEXCH-16755: Rebadged S.Disc to Write Off for the PPD Era and added PPD Columns
               SendLine(#9'Doc Ref' +
                        #9'Your Ref' +
                        #9'Date' +
                        #9'Date Due' +
                        #9'Orig.Total' +
                        #9'Write Off' +
                        #9'Total Due' +
                        #9'PPD ' + PPDGiveTakeWord(MTExLocal^.LCust.CustSupp) + 'n?' +
                        #9'PPD Value' +
                        #9'Status');

               DefLine(-1,TabStart(1),TabEnd(10),0);
             end;


    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}



Procedure TBatchReport.CalcPayTotals(PayVal,
                                     SDisc,
                                     TTot,
                                     // MH 17/08/2015 2015-R1 ABSEXCH-16755: Added PPD Columns
                                     PPDValue  :  Double);

  Var
    nBo        :  Boolean;
    Rnum       :  Real;

  Begin

    Rnum:=0;

    With CRepParam^ do
    Case ValMode of

      9,10   :  Begin
                  BSTot:=BSTot+PayVal;

                  RepTot:=RepTot+PayVal;

                  SDiscTot:=SDiscTot+SDisc;

                  PayTot:=PayTot+TTot;

                  // MH 17/08/2015 2015-R1 ABSEXCH-16755: Added PPD Columns
                  PPDTot := PPDTot + PPDValue;
                end;

    end; {Case..With..}
  end;






  { ======================= Due Sub / Grand Total ================ }

  Procedure TBatchReport.PrintPayTot;

  Var
    n          :  Byte;


  Begin
    SetReportDrillDown(7);

    With RepFiler1,CRepParam^ do
    Case ValMode of
      9,10
         :  Begin
              RepSetValTabs;

              // MH 17/08/2015 2015-R1 ABSEXCH-16755: Added PPD Columns
              DefLine(-1,TabStart(1),TabEnd(9),0);

              SendLine(ConCat(ConstStr(#9,4),'Total',#9,
                              FormatCurFloat(GenRealMask,BSTot,BOff,RCr),#9,
                              FormatCurFloat(GenRealMask,SDiscTot,BOn,RCr),#9,
                              FormatCurFloat(GenRealMask,PayTot,BOn,RCr),#9,
                              #9, // PPD Taken?
                              FormatCurFloat(GenRealMask,PPDTot,BOn,RCr)));



              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;
            end; {Case..}

    end; {Case..}

  end;




  { ======================= Due End ======================= }


  Procedure TBatchReport.PayEnd;

  Var
    KitEnd     :  Str255;

    n,m        :  Byte;

  Begin

    With RepFiler1, CRepParam^ do
    Begin

      Case ValMode of

        9,10   :  Begin

                    PrintPayTot;

                    RepSetTabs;

                  end;
      end; {Case..}
    end; {With..}
  end;


  Function TBatchReport.LBACSHook(HID     :  LongInt)  :  Boolean;


  Var
    NewObject  :  Boolean;

  Begin
    Result:=BOn;

    {$IFDEF CU}
      If (LHaveHookEvent(2050,HID,NewObject)) then
      Begin
        try
          Result:=LExecuteHookEvent(2050,HId,MTExLocal^);

        except
          Result:=BOn;
        end; {try..}
      end;
    {$ENDIF}
  end;


  { ======================= Due Include ======================= }


  Function TBatchReport.PayInclude  :  Boolean;

  Const
    Fnum    =  InvF;
    KeyPath =  InvOurRefK;


  Var
    TmpInclude :  Boolean;
    DayRepInc  :  Boolean;

    ChkRecon   :  Byte;

    BColNo     :  SmallInt;

    KeyS2      :  Str255;


  Begin
    TmpInclude := False;
    {$B-}

    With MTExLocal^, CRepParam^, RepFiler1 do
    Begin
      Case ValMode of

          9
             :  With LInv do
                Begin

                  TmpInclude:=BOff;

                  If (ExtCusFiltCid(0,ExtCustRec,CustAlObj)) and (Not SettledFull(LInv)) and LBACSHook(174+Ord(BatchCtrl.BACSCRec.SalesMode))  then
                  With BatchCtrl.BACSCRec do
                  Begin

                    BColNo:=Succ(AgedPos(Get_StaChkDate(LInv),TagAsDate,AgeType,AgeInt));

                    TmpInclude:=((Tagged=1) or ((LMiscRecs^.BACSSrec.HasTagged[BColNo]) and (Not UnTagged))) and (FolioNum<=LastInv);
                  end;

                end;

        10   :  With LPassWord.MatchPayRec do
                Begin

                  KeyS:=DocCode;

                  TmpInclude:=LCheckRecExsists(KeyS,Fnum,Keypath);

                end;

        end; {Case..}



      end; {With..}

      {$B+}



      Result:=TmpInclude;
  end; {Func..}



Procedure TBatchReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    Case DDMode of
      7,8   :  Begin
                 SendRepDrillDown(1,TotTabs,1,FullCustCode(LCust.CustCode),CustF,CustCodeK,0);
               end;

      9,10  :  SendRepDrillDown(1,TotTabs,1,LInv.OurRef,InvF,InvOurRefK,0);



    end; {Case..}
  end; {With..}
end;

  { ======================= Due Line ======================= }


  Procedure TBatchReport.PayLine;


  Var
    Rnum,
    Rnum2,
    Rnum3      :  Double;

    TBo        :  Boolean;

    N          :  Byte;


    GenStr     :  Str255;

    EInv       :  InvRec;

    // MH 17/08/2015 2015-R1 ABSEXCH-16755: Added PPD Columns
    PPDTaken   : String[3];
    PPDValue   : Double;
  Begin
    Rnum:=0;

    Rnum2:=0;  Rnum3:=0.0;

    // MH 17/08/2015 2015-R1 ABSEXCH-16755: Added PPD Columns
    PPDTaken := '';
    PPDValue := 0.0;

    With MTExLocal^, RepFiler1, CRepParam^ do
    Begin

      SetReportDrillDown(ValMode);

      Case ValMode of
        9,10   :
           With LInv, LPassWord.MatchPayRec do
           Begin
             EInv:=LInv;

             Case ValMode of
               // Printing an In-Progess Batch/Payments Receipt session
               9  :  Begin
                       // MH 24/08/2015 2015-R1 ABSEXCH-16783: PPD not being converted to Payment/Receipt currency
                       // MH 17/08/2015 2015-R1 ABSEXCH-16755: Added PPD Columns
                       // Check to see if PPD is specified on the transaction
                       If PPDFieldsPopulated(LInv) Then
                       Begin
                         // Check to see if PPD is Given/Taken in Batch Receipts/Payments
                         If (thBatchPayPPDStatus <> 0) Then
                         Begin
                           PPDTaken := 'Yes';
                           PPDValue := {Round_Up(}LInv.thPPDGoodsValue + LInv.thPPDVATValue{, 2)};    // MH Removed rounding as it was causing differences with Batch Payments

                           {$IFDEF MC_On}
                             // MH 24/08/2015 2015-R1 ABSEXCH-16783: Convert to Payment/Receipt currency if it doesn't match the invoice currency
                             If (Currency <> RCr) Then
                             Begin
                               // Convert to Base using Transaction's own rate
                               PPDValue := Conv_TCurr(PPDValue, XRate(CXRate,BOff,Currency), Currency, 0, BOff);
                               // Convert to Payment/Receipt currency using live rates
                               PPDValue := {Round_Up(}Conv_TCurr(PPDValue, SyssCurr^.Currencies[RCr].CRates[UseCoDayRate], RCr, 0, BOn){, 2)};    // MH Removed rounding as it was causing differences with Batch Payments
                             End; // If (Currency <> RCr)
                           {$ENDIF}
                         End // If (thBatchPayPPDStatus <> 0)
                         Else
                           PPDTaken := 'No';
                       End; // If PPDFieldsPopulated(LInv)

                       If (Tagged=1) then
                       Begin
                         // Individual transaction has been tagged

                         {$IFDEF MC_On}

                           If (Currency=RCr) then {* We are paying off the own currency equivalent *}
                           Begin
                             Rnum3:=BatchNow;
                             Rnum2:=BDiscount*DocCnst[InvDocHed]*DocNotCnst;
                           end
                           else
                           Begin
                             Rnum3:=Currency_ConvFT(BatchThen,0,RCr,UseCoDayRate);

                             // MH 24/08/2015 2015-R1 ABSEXCH-16784: Convert Write-Off value to Payment/Receipt Currency
                             //Rnum2:=Round_Up(Conv_TCurr(BDiscount,XRate(CXRate,BOff,Currency),Currency,0,BOff),2) * DocCnst[InvDocHed] * DocNotCnst;

                             // Convert to Base using transaction rates and then Payment/Receipt currency using live rates
                             Rnum2:=Conv_TCurr(BDiscount,XRate(CXRate,BOff,Currency),Currency,0,BOff);
                             Rnum2:=Conv_TCurr(RNum2, SyssCurr^.Currencies[RCr].CRates[UseCoDayRate], RCr, 0, BOn);
                             Rnum2:=Round_Up(RNum2, 2) * DocCnst[InvDocHed] * DocNotCnst;
                           end;

                         {$ELSE}

                           Rnum3:=BatchThen;
                           Rnum2:=BDiscount*DocCnst[InvDocHed]*DocNotCnst;

                         {$ENDIF}

                         Rnum:=Rnum3+Rnum2;
                       end
                       else
                       Begin
                         // Account has been tagged

                         ForceInvSDisc(LInv,EInv,BatchCtrl,1);

                         {$IFDEF MC_On}

                           If (Currency=RCr) then {* We are paying off the own currency equivalent *}
                             Rnum:=CurrencyOS(LInv,BOff,BOff,BOff)
                           else
                             Rnum:=Currency_ConvFT(BaseTotalOS(LInv),0,RCr,UseCoDayRate);

                           If (Currency=RCr) then {* We are paying off the own currency equivalent *}
                             Rnum3:=CurrencyOS(EInv,BOff,BOff,BOff)
                           else
                             Rnum3:=Currency_ConvFT(BaseTotalOS(EInv),0,RCr,UseCoDayRate);


                         {$ELSE}

                           Rnum:=BaseTotalOS(LInv);

                           Rnum3:=BaseTotalOS(EInv);

                         {$ENDIF}

                         // MH 24/08/2015 2015-R1 ABSEXCH-16755: Need to modify transaction totals
                         // for PPD if tagged at the Account level
                         Rnum := {Round_Up(}RNum - (PPDValue * DocCnst[InvDocHed] * DocNotCnst){, 2)};    // MH Removed rounding as it was causing differences with Batch Payments
                         Rnum3 := {Round_Up(}RNum3 - (PPDValue * DocCnst[InvDocHed] * DocNotCnst){, 2)};  // MH Removed rounding as it was causing differences with Batch Payments

                         Rnum2:=Rnum-Rnum3;
                       end;
                     End; // 9

               // Printing an historical Processed Batch/Payments Receipt session
               10 :  Begin
                       If (Currency=RCr) then {* We are paying off the own currency equivalent *}
                         Rnum:=OwnCVal
                       else
                         Rnum:=Currency_ConvFT(SettledVal,0,RCr,UseCoDayRate);

                       // MH 17/08/2015 2015-R1 ABSEXCH-16755: Added PPD Columns
                       // Check to see if PPD is specified on the transaction
                       If PPDFieldsPopulated(LInv) Then
                       Begin
                         // Check to see if PPD has been taken
                         If (LInv.thPPDTaken <> ptPPDNotTaken) Then
                         Begin
                           PPDTaken := 'Yes';
                           PPDValue := Round_Up(LInv.thPPDGoodsValue + LInv.thPPDVATValue, 2);

                           {$IFDEF MC_On}
                             // MH 24/08/2015 2015-R1 ABSEXCH-16783: Convert to Payment/Receipt currency if it doesn't match the invoice currency
                             If (Currency <> RCr) Then
                             Begin
                               // Convert to Base using Transaction's own rate
                               PPDValue := Conv_TCurr(PPDValue, XRate(CXRate,BOff,Currency), Currency, 0, BOff);
                               // Convert to Payment/Receipt currency using live rates
                               PPDValue := Round_Up(Conv_TCurr(PPDValue, SyssCurr^.Currencies[RCr].CRates[UseCoDayRate], RCr, 0, BOn), 2);
                             End; // If (Currency <> RCr)
                           {$ENDIF}
                         End // If (LInv.thPPDTaken <> ptPPDNotTaken)
                         Else
                           PPDTaken := 'No';
                       End; // If PPDFieldsPopulated(LInv)
                     End; // 10

             end; {Case..}

             GenStr:=DisplayHold(HoldFlg);

             {Rnum:=Rnum*DocCnst[InvDocHed]*DocNotCnst;}

             SendLine(ConCat(#9,OurRef,
                             #9,YourRef,
                             #9,POutDate(TransDate),
                             #9,POutDate(DueDate),
                             #9,FormatCurFloat(GenRealMask, RNum, BOff, RCr),
                             #9,FormatCurFloat(GenRealMask, RNum2, BOff, RCr),
                             #9,FormatCurFloat(GenRealMask, RNum3, BOff, RCr),
                             // MH 17/08/2015 2015-R1 ABSEXCH-16755: Added PPD Columns
                             #9,PPDTaken,
                             #9,FormatCurFloat(GenRealMask, PPDValue, BlankIfZero, RCr),
                             #9,GenStr));
           End; // With LInv, LPassWord.MatchPayRec
      End; // Case ValMode

      // MH 17/08/2015 2015-R1 ABSEXCH-16755: Added PPD Columns
      CalcPayTotals(Rnum,Rnum2,Rnum3, PPDValue);

    end; {With(s)..}
  end;




Procedure TBatchReport.PrintPayDetail;




Var
  KeyCS,
  KeyChk     :  Str255;

  BeenSome,
  BNewLine   :  Boolean;

  Fnum,
  Keypath    :  SmallInt;

  Rnum       :  Real;


Begin

  Rnum:=0;
  FNum := 0;
  KeyPath := 0;
  
  BNewLine:=BOn;
  BeenSome:=BOff;



  With MTExLocal^,CRepParam^ do
  Begin
    New(CustAlObj,Init);
    New(ExtCustRec);

    FillChar(ExtCustRec^,Sizeof(ExtCustRec^),0);

    With ExtCustRec^,BatchCtrl.BACSCRec do
      Begin
        FCr:=InvCurr;

        FNomAuto:=BOn;

        FMode:=3;

        FAlCode:=TradeCode[SalesMode];
        FCSCode:=FALCode;

        FCtrlNom:=TagCtrlCode;
        
        FDirec:=BOn;

        FB_Func[BOff]:=B_GetPrev;
        FB_Func[BOn]:=B_GetNext;

        FCusCode:=CustFilt;
      end;


    CustAlObj^.MTExLocal:=MTExLocal;

    Case ValMode of

      9  :  Begin
              Fnum:=InvF;
              Keypath:=InvCustK;
              KeyChk:=FullLedgerKey(CustFilt,ExtCustRec^.FAlCode,BOn);
            end;

     10  :  Begin
              Fnum:=PWrdF;
              Keypath:=HelpNdxK;
              KeyChk:=FullMatchKey(MatchTCode,MatchSCode,CustFilt);
            end;


   end; {Case..}

    BSTot:=0;
    RepTot:=0;
    // MH 17/08/2015 2015-R1 ABSEXCH-16755: Added PPD Columns
    PPDTot := 0.0;

    KeyCS:=KeyChk;

    Case ValMode of
       9  :  LStatus:=GetExtCusALCid(ExtCustRec,CustAlObj,Fnum,Keypath,B_GetGEq,1,KeyCS);
      10  :  LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);
    end;

    While (LStatusOk) and (Checkkey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
    With CRepParam^ do
    Begin

      If (PayInclude) then
      Begin
        If (BNewLine) then
          RepPrintPageHeader2;

        BNewLine:=BOff;
        BeenSome:=BOn;

        PayLine;
      end;

      With RepFiler1 do
        If (LinesLeft<5) then
        Begin
          ThrowNewPage(5);
          BNewLine:=BOn;
        end;

      Case ValMode of
         9  :  LStatus:=GetExtCusALCid(ExtCustRec,CustAlObj,Fnum,Keypath,B_GetNext,1,KeyCS);
        10  :  LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);
      end;

    end; {While..}

    If (BeenSome) then
      PayEnd;

    Dispose(CustAlObj,Done);
    Dispose(ExtCustRec);


  end; {With..}
end; {Proc..}



Procedure TBatchReport.RepPrintPageHeader;


Begin

  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    DefFont(0,[fsBold]);

    Case ReportMode of

      // CJS 2014-07-10 - ABSEXCH-15161 - Field lengths on batch payments report
      7, 8 : SendLine(ConCat(#9, 'Acc No',
                             #9, 'Company',
                             #9, 'Bank A/C & Sort Code',
                             #9, 'Bank  Reference',
                             #9, 'Total Due',
                             // MH 17/08/2015 2015-R1 ABSEXCH-16755: Rebadged S.Disc to Write Off for the PPD Era
                             #9, 'Write Off',
                             #9, 'Total Payment',
                             #9, 'Doc Ref'));

    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}





Procedure TBatchReport.RepPrintHeader(Sender  :  TObject);


Begin
  // CJS 2014-07-15 - ABSEXCH-15161 - Field lengths on batch payments report
  RNoPageLine := True;

  Inherited RepPrintHeader(Sender);

  With RepFiler1 do
    DefLine(-2, TabStart(1), TabEnd(8), 0);

end;




{ ======================= Calculate Due Totals ==================== }

Procedure TBatchReport.CalcDueTotals(Var TTot,PTot      :  Totals);



Var
  nBo        :  Boolean;
  n          :  Byte;
  Rnum       :  Real;

Begin

  Rnum:=0;

  With CRepParam^ do
    Case ReportMode of
      7,8  :  Begin

                For n:=1 to NoTotals do
                Begin

                  CustTot[n]:=CustTot[n]+Ptot[n];

                  RepTotal[n]:=RepTotal[n]+Ttot[n];

                end;

              end;

    end; {Case..With..}
end;






{ ======================= Due Sub / Grand Total ================ }

Procedure TBatchReport.PrintDueTot;

Var
  n          :  Byte;


Begin


  With RepFiler1, CRepParam^ do
  Case ReportMode of
    7,8
       :  Begin
            DefFont(0,[fsBold]);

            DefLine(-1,TabStart(4),TabEnd(8),0);

            // CJS 2014-07-15 - ABSEXCH-15161 - Field lengths on batch payments report
            // Changed number of tabs from 5 to 4
            SendLine(ConCat(ConstStr(#9,4),'Total : ',#9,FormatCurFloat(GenRealMask,RepTotal[1],BOn,RCr)
            ,#9,FormatCurFloat(GenRealMask,RepTotal[2],BOn,RCr)
            ,#9,FormatCurFloat(GenRealMask,RepTotal[3],BOff,RCr)));

            DefLine(-2,TabStart(4),TabEnd(8),0);

            DefFont(0,[]);

          end; {Case..}

  end; {Case..}

end;




{ ======================= Customer Line ======================= }


Procedure TBatchReport.PrintReportLine;

Var
  Rnum,
  Rnum2,
  Rnum3
             :  Double;
  PTot,
  TTot       :  Totals;

  DetLink    :  Str10;

  GenStr     :  Str255;


Begin

  With MTExLocal^, RepFiler1, CRepParam^ do
  Begin
    Rnum:=0; Rnum2:=0.0;  Rnum3:=0.0;

    Blank(PTot,Sizeof(PTot));

    Blank(TTot,Sizeof(TTot));

    GenStr:='';

    SetReportDrillDown(ReportMode);

    With LCust,LMiscRecs.BACSSRec do
    Case ReportMode of
      7,8
        :  Begin

              Case ReportMode of
                7  :  Begin
                        Rnum:=BatchDocSign(SalesCust,Totaltagged[0]);
                        GenStr:='';
                        DetLink:=CustCode;
                      end;
                8  :  With LInv do
                      Begin

                        Rnum:=Itotal(LInv)*DocNotCnst;

                        GenStr:=LInv.OurRef;

                        DetLink:=GenStr;

                        Rnum3:=Round_Up(Conv_TCurr(PostDiscAm,XRate(CXRate,BOff,Currency),Currency,0,BOn),2)*DocNotCnst;
                        Rnum2:=Rnum3+Rnum;


                        Rnum:=Rnum*DocCnst[LInv.InvDocHed]*DocNotCnst;

                        Rnum2:=Rnum2*DocCnst[Inv.InvDocHed]*DocNotCnst;
                        Rnum3:=Rnum3*DocCnst[Inv.InvDocHed]*DocNotCnst;

                      end;

              end; {Case..}



              TTot[1]:=Rnum2;

              TTot[2]:=Rnum3;
              TTot[3]:=Rnum;

              //PR: 09/09/2013 ABSEXCH-14598 Added handling for SEPA fields
              // CJS 2014-07-10 - ABSEXCH-15161 - Field lengths on batch payments report
              // Moved Bank Sort Code to second line
              SendLine(ConCat(#9,CustCode,
                              #9,Company,
                              #9,DecryptBankAccountCode(acBankAccountCode),
                              #9,BankRef,
                              #9,FormatCurFloat(GenRealMask,RNum2,BOff,RCr),
                              #9,FormatCurFloat(GenRealMask,RNum3,BOff,RCr),
                              #9,FormatCurFloat(GenRealMask,RNum,BOff,RCr),
                              #9,GenStr));

              SendLine(ConCat(#9#9,
                              #9,DecryptBankSortCode(acBankSortCode)));

              CustFilt:=DetLink;

              If (Not Summary) then
              Begin
                If (ReportMode=8) then
                Begin
                  SDiscTot:=Rnum3;
                  PayTot:=Rnum;
                end
                else
                Begin
                  SDiscTot:=0.0;
                  PayTot:=0.0;
                end;

                PrintPayDetail;

              end;

            end;


    end; {Case..}


    CalcDueTotals(TTot,PTot);
  end;
end;


{ ======================= Customer End ======================= }


Procedure TBatchReport.PrintEndPage;
Var

  n  :  Byte;


Begin
  With RepFiler1 do
  Begin

    PrintDueTot;

  end;

  Inherited PrintEndPage;
end;





{ ======================= Customer Include ======================= }


Function TBatchReport.IncludeRecord  :  Boolean;


Var
  TmpInclude :  Boolean;

Begin

  TmpInclude:=BOff;

  {$B-}

  With MTExLocal^, CRepParam^ do
  Begin


    Case ReportMode of

          7
             :  With LMiscRecs^.BACSSRec do
                Begin
                  If (TagCustCode<>LCust.CustCode) then
                    LGetMainRec(CustF,TagCustCode);

                  TmpInclude:=(TotalTagged[0]<>0);


                end;

          8  :  With LInv do
                Begin
                  If (CustCode<>LCust.CustCode) then
                    LGetMainRec(CustF,CustCode);

                  TmpInclude:=BOn;
                  RCr:=Currency;


                end;

        end; {Case..}
    end;{With..}

  {$B+}

  Result:=TmpInclude;

end; {Func..}






Function TBatchReport.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;


Begin
  With CRepParam^ do
  Begin
    {RepOrd:='C';}

    BACS_CtrlGet(PWrdF,PWK,BatchCtrl,SPMode,Nil);

    Case ReportMode of

       7    :   Begin
                  ThTitle:='Batch Pay Report';

                  RepTitle:='Batch '+BatchPTit(SPMode)+' Report - Tagged '+BatchPTit(SPMode)+'s';
                  RepTitle2:='Processing Run No. '+Form_Int(NomToo,0);

                  PageTitle:=RepTitle;

                  RFont.Size:=8;
                  ROrient:=RPDefine.PoLandScape;

                  ValMode:=9;

                  If (BatchCtrl.BACSCRec.TagRunNo<>NomToo) then
                  Begin
                    ValMode:=10;
                    ReportMode:=8;
                  end;
                end;

    end; {Case..}


    Case ReportMode of

       7    :   Begin
                  RFnum:=MiscF;

                  RKeyPath:=MIK;

                  RepKey:=PartCCKey(MBACSCode,MBACSSub)+FullNomKey(NomToo);
                end;

       8    :   Begin
                  RFnum:=InvF;

                  RKeyPath:=InvBatchK;

                  RepKey:=Pay_RunNo(BatchDocHed(SPMode),NomToo);

                end;
    end; {Case..}



  end; {With..}

  Result:=BOn;
end;




Procedure TBatchReport.Process;

Begin
  Inherited Process;

end;


Procedure TBatchReport.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddBatchPRep2Thread(LMode    :  Byte;
                              IRepParam:  BatchPRepPtr;
                              AOwner   :  TObject);


Var
  EntTest  :  ^TBatchReport;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        ReportMode:=LMode;

        If (Assigned(IRepParam)) then
          CRepParam^:=IRepParam^;


        If (Create_BackThread) and (Start) then
        Begin
          With BackThread do
            AddTask(EntTest,ThTitle);
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(EntTest,Destroy);
        end;
      end; {with..}

    except
      Dispose(EntTest,Destroy);

    end; {try..}
  end; {If process got ok..}

end;





Initialization



Finalization

end.