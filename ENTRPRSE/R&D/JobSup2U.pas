Unit JobSup2U;


Interface

Uses GlobVar,
     VarRec2U,
     VarConst,
     Classes,
     ExWrap1U;


{$IFNDEF OLE}
{$IFNDEF EXDLL}

Type
  tJAppWizRec  =  Record
                    awIntReverse,
                    awMaster,
                    awConsolidate,
                    awJSTFromBudget,
                    awJSAFromVal,
                    awAggregate,
                    awPrintInv,
                    awPrintCert
                              :  Boolean;
                    awValAct,
                    awCopyBudget
                              :  Byte;
                    awJCTRef  :  Str10;
                    awDate    :  LongDate;
                    awPCurr   :  Byte;
                    awPrice,
                    awValuation
                              :  Double;
                    awJobCode,
                    awACode,
                    awECode   :  Str10;
                    awBasis   :  Byte;

                    awSeries  :  SmallInt;

                    awDT,
                    awCertDT  :  DocTypes;
                    awDoc     :  InvRec;
                    awTagNo,
                    awAddr,
                    awPRun    :  LongInt;
                  end;

  Function JAiMode(InvR  :  InvRec)  :  Byte;

  Function JAbMode(InvR  :  InvRec)  :  Byte;

  Function JAGiStatus(InvR  :  InvRec) :  Str20;


  Function AppsStatusStr(InvR  :  InvRec; FullText,
                                          ShowCert,
                                          ShowType   :  Boolean)  :  Str20;

  Function GetJAParentTotal(InvR     :  InvRec;
                            rMode    :  Byte)  :  Double;

  Procedure Switch_JAPLineTotal(Var IdR      :  IDetail;
                                    InvR     :  InvRec;
                                    SwitchCost
                                             :  Boolean;
                                Var StoreNV  :  Double;
                                    tMode    :  Byte);

  Procedure Update_JAPDeductLine(Var IdR      :  IDetail;
                                     InvR     :  InvRec;
                                     tMode    :  Byte);

  procedure JAPCalc_RetDate(Var ExLocal  :  TdExLocal);

  procedure Calc_AppVAT(Var ExLocal  :  TdExLocal);

{$ENDIF} // EXDLL

  Function Calc_JAPAppTotal(InvR     :  InvRec;
                            UseCert  :  Boolean;
                            tMode    :  Byte)  :  Double;

  Function Calc_JAPDocTotal(InvR     :  InvRec;
                            UseCert  :  Boolean;
                            tMode    :  Byte)  :  Double;

{$IFNDEF EXDLL}

  // CJS 2014-03-18 - ABSEXCH-14289 - incorrect CIS Calculation when CITB Deduction is set to 1.5%
  function CalculateCISAdjustment(InvR: InvRec; LineValue: Double; Mode: Integer): Double;

  Procedure Calc_AddCIS(InvR           :  InvRec;
                    Var IdR            :  IDetail;
                        CLineValue     :  Double;
                        iMode          :  Byte);

  Function CalcJAPRetTotals(Var  InvR     :  InvRec;
                                IdR       :  Idetail;
                            Var ExLocal   :  TdExLocal;
                                rMode,
                                iMode     :  Byte)  :  Double;

  Procedure Update_JTLink(Idr     :  IDetail;
                          AppInv  :  InvRec;
                          Deduct,
                          UpHed   :  Boolean;
                          Fnum,
                          Keypath,
                          KeyResP,
                          Level :  Integer);


  Function Curr_ConvertJAPId(IdR      :  IDetail;
                             NewCurr  :  Byte;
                             NewRates :  CurrTypes;
                             Mode     :  Byte)  : IDetail;

  Procedure CalcJAPVATTotals(Var InvR      :  InvRec;
                             Var ExLocal   :  TdExLocal;
                                 ReCalcVAT :  Boolean;
                                 DedRetMode:  Byte);

  Function Generate_JAFromJT(JMode      :  Byte;
                             JcRec      :  tJAppWizRec;
                         Var ExLocal    :  TdExLocal)  :  Boolean;


  Function Get_JTLink(Idr     :  IDetail;
                      Fnum,
                      Keypath,
                      KeyResP :  Integer)  :  IDetail;

  Function Calc_ValuationValue(JcRec      :  tJAppWizRec;
                           Var ExLocal    :  TdExLocal)  :  Double;


  Function CheckUpdate_CertYTD(Var ExLocal    :  TdExLocal;
                                   Fnum,
                                   Keypath    :  Integer;
                                   Mode       :  Byte)  :  Boolean;
{$ENDIF} // EXDLL
{$ENDIF}



 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$IFNDEF OLE}
{$IFNDEF EXDLL}

 Uses
   Forms,
   SysUtils,
   ETStrU,
   ETMiscU,
   ETDateU,
   VarJCstU,
   BTKeys1U,
   ComnUnit,
   ComnU2,
   BTSupU1,
   InvListU,
   CurrncyU,
   SysU1,
   SysU2,
   JCAnlI3U,
   MiscU,
   Event1U,
   LedgSupU,
   InvLst2U,
   InvCT2SU,
   PassWR2U,


   { CJS - 2013-10-25 - MRD2.6 - Transaction Originator }
   TransactionOriginator,

   BtrvU2;

{$IFDEF ABSEXCH-15506}
// CJS 2014-08-15 - ABSEXCH-15506 - JST discount lines
var
  CurrentJobCode: String;
{$ENDIF}

  { == Function to determine if transaction is gross interim == }

  Function JA_IsGrossInc(InvR  :  InvRec;
                         JAOnly:  Boolean)  :  Boolean;

  Begin
    Result:=BOff;

    With InvR do
    Begin
      Result:=((TransMode>=1) and (InvDocHed In [JCT,JPT,JST]) and (Not JAOnly)) or ((TransNat>=1) and (InvDocHed In [JSA,JPA]));
    end;
  end;

    { == Function to return correct imode depending on document type == }

  Function JAiMode(InvR  :  InvRec)  :  Byte;
  Begin
    With InvR do
    Begin
      If (InvDocHed In [JPA,JSA]) then
        Result:=TransMode
      else
        Result:=TransNat;
    end;
  end;

  Function JAbMode(InvR  :  InvRec)  :  Byte;
  Begin
    With InvR do
    Begin
      If (Not (InvDocHed In [JPA,JSA])) then
        Result:=TransMode
      else
        Result:=TransNat;
    end;
  end;


  { == Function to return Inremental or Gross incremental status == }

  Function JAGiStatus(InvR  :  InvRec) :  Str20;
  Begin
    If JA_IsGrossInc(InvR,BOff) then
    Begin
      With InvR do
      If (JAbMode(InvR)=1) then
        Result:='Gross Incremntl'
      else
        Result:='Gross';
    end
    else
      Result:='Incremental';

  end;


 { == Return details of type, and status == }

  Function AppsStatusStr(InvR  :  InvRec; FullText,
                                          ShowCert,
                                          ShowType   :  Boolean)  :  Str20;

  Const
    StatStr  :  Array[1..3,BOff..BOn] of Str80 = (('C','Certified'),('P','Practical'),('F','Final'));

  Var
    TmpInv  :  InvRec;
    KeyI    :  Str255;

  Begin
    Result:=' ';

    With InvR do
    Begin
      If (ShowType) then
      Begin
        If (FullText) then
          Result:=JAGiStatus(InvR)
        else
          Result:=JAGiStatus(InvR)[1];
      end;

      If (PDiscTaken) and (ShowCert) then
      Begin
        If (Trim(Result)<>'') then
          Result:=Result+', ';

        Result:=StatStr[1,FullText]
      end;

      If (InvDocHed In JAPJAPSplit) then
      Begin
        If (Trim(Result)<>'') and (FullText) then
          Result:=Result+', ';

        Case TransMode of
          2  :  Result:=Result+StatStr[2,FullText];
          3  :  Result:=Result+StatStr[3,FullText];
        end; {Case..}
      end;

    end;
  end;



  { == Function to match Retention lines with application status == }

  Function JA_UseThisRetLine(LineRet,
                             AppStatus,
                             Mode         :  Byte)  :  Boolean;

  Begin
    Result:=BOff;

    Case Mode of
      1  :  ;
      else  Begin {* If document at the same stage, or we are on final and line is practical, or
                     Its stand alone or interim and we are at stand alone stage *}
              Result:=(LineRet=AppStatus) or ((LineRet=2) and (AppStatus>LineRet)) or ((LineRet In [0,1]) and (AppStatus=0)) or
              
                      //SS:29/11/2017:2018-R1:ABSEXCH-19443:Issue with CIS Tax on JPA linked to JCT.
                      //retention line should be calculate for one off retention type.  
                      ((LineRet = 0) and (AppStatus=1));
            end;
    end; {case..}

  end;


  { == Function to force Retention lines practical and above to not ue YTD totals  == }

  Function JA_PractRetLine(InvR  :  InvRec;
                           IdR   :  IDetail)  :  Boolean;

  Begin
    With IdR do
      Result:=((Reconcile=2) and (COSNomCode=2) and (JAiMode(InvR)=2));
  end;


  { == Calculate Line App Net total == }
  { UseCert   = Use certified values as basis for calcualtion }
  { tmode : 0 = Transaction total
            1 = YTD total
  }

  Function Calc_JAPLineTotal(IdR     :  IDetail;
                            UseCert  :  Boolean;
                            tMode    :  Byte)  :  Double;

  Var
    Basis  :  Double;

  Begin
    With IdR do
    Begin
      Case tMode of
        1  :  Begin
                If (UseCert) then
                  Basis:=QtyPWOff
                else
                  Basis:=QtyDel;

                Result:=Basis;
              end;
        else  Begin
                If (UseCert) then
                  Basis:=NetValue
                else
                  Basis:=CostPrice;

                Result:=Basis;
              end;
      end; {Case..}
    end; {With..}
  end; {Func..}


  { == Switch Line App Net total == }
  { SwitchCost   = Use application value as basis for calcualtion if app not certified}
  { StoreNV      = TempStore for NetValue while switch is occurring }
  { tmode : Not Used. 0.
  }

  Procedure Switch_JAPLineTotal(Var IdR      :  IDetail;
                                    InvR     :  InvRec;
                                    SwitchCost
                                             :  Boolean;
                                Var StoreNV  :  Double;
                                    tMode    :  Byte);


  Begin

    With IdR do
    Begin
      If (Not InvR.PDiscTaken) and (Reconcile=0) and (IdDocHed In JAPSplit) then {We are in apps mode so switch to cost price}
      Begin
        Case SwitchCost of
          BOff  :  Begin

                     NetValue:=StoreNV;

                   end;
          BOn  :  Begin
                    StoreNV:=0.0;

                    StoreNV:=NetValue;
                    NetValue:=CostPrice;
                  end;
        end; {Case..}


      end;
    end; {With..}
  end; {Func..}


  { == Update Line Deduction Net total type == }
  { tmode : Not Used. 0.
  }

  Procedure Update_JAPDeductLine(Var IdR      :  IDetail;
                                     InvR     :  InvRec;
                                     tMode    :  Byte);

  Begin

    With IdR do
    Begin
      If (Reconcile<>0) and (IdDocHed In JAPSplit) then {We are in apps mode so switch to cost price}
      Begin
        If (InvR.PDiscTaken) then
          SSDUplift:=NetValue
        else
          CostPrice:=NetValue;

      end;
    end; {With..}
  end; {Func..}


procedure Calc_AppVAT(Var ExLocal  :  TdExLocal);

Var
  LineVAT  :  Integer;
  LineNV   :  Double;

Begin
  With ExLocal do
  With LId do
  Begin
    Switch_JAPLineTotal(LId,LInv,BOn,LineNV,0);

    CalcVATExLocal(ExLocal,BOff,nil);

    Switch_JAPLineTotal(LId,LInv,BOff,LineNV,0);

  end;
end;

procedure JAPCalc_RetDate(Var ExLocal  :  TdExLocal);

Var
  n         :  Byte;

  Ld,Lm,Ly  :  Word;


Begin
  With ExLocal do
  With LInv,LId do
  Begin
    DateStr(TransDate,Ld,Lm,Ly);
    If (Round(SSDSPUnit) In [0]) then
    Begin


      AdjMnth(Lm,Ly,OldSerQty);


    end
    else
    Begin
      For n:=1 to OldSerQty do
        Ly:=AdjYr(Ly,BOn);
    end;


    PDate:=StrDate(Ly,Lm,Ld);
  end; {With..}
end;
{$ENDIF} // EXDLL


  { == Calculate App Net total == }
  { UseCert   = Use certified values as basis for calcualtion }
  { tmode : 0 = Transaction total
            1 = YTD total
  }

  Function Calc_JAPAppTotal(InvR     :  InvRec;
                            UseCert  :  Boolean;
                            tMode    :  Byte)  :  Double;

  Var
    Basis  :  Double;

  Begin
    With InvR do
    Begin
      Case tMode of
        1  :  Begin
                If (UseCert) then
                  Basis:=TotalOrdered
                else
                  Basis:=TotalReserved;

                Result:=Basis;
              end;
        else  Begin
                If (UseCert) then
                  Basis:=InvNetVal
                else
                  Basis:=TotalCost;

                Result:=Basis;
              end;
      end; {Case..}
    end; {With..}
  end; {Func..}



  { == Calculate App total == }
  { UseCert   = Use certified values as basis for calcualtion }
  { tmode : 0 = Transaction total
            1 = YTD total
            2 = Transaction total without VAT
  }

  Function Calc_JAPDocTotal(InvR     :  InvRec;
                            UseCert  :  Boolean;
                            tMode    :  Byte)  :  Double;

  Var
    Basis  :  Double;

  Begin
    With InvR do
    Begin
      Case tMode of
        1  :  Begin
                Basis:=Calc_JAPAppTotal(InvR,UseCert,tMode);

                Result:=Basis-PostDiscAm-TotOrdOS;
              end;
        else  Begin
                Basis:=Calc_JAPAppTotal(InvR,UseCert,tMode);

                Result:=Basis-DiscSetAm-DiscAmount-CISTax-BDiscount+(InvVAT*Ord(tMode<>2));
              end;
      end; {Case..}
    end; {With..}
  end; {Func..}


{$IFNDEF EXDLL}
  { == Function to match deduction line types with application lines == }

  Function Match_Ded2AppLine(ExLocal  :  TdExLocal;
                             DedIdR,
                             AppIdR   :  IDetail)  :  Boolean;

  Const
    SetxLate :  Array[1..4] of Byte = (3,4,3,2);

  Var
    FoundOk   :  Boolean;

    FoundCode :  Str20;

    UseAHed   :  SmallInt;


  Begin
    FoundOk:=BOff;

    {$B-}
    With ExLocal do
    Begin
      With LJobMisc^,JobAnalRec do
      If (DedIdR.KitLink<>0) and (GetJobMisc(Application.MainForm,AppIdR.AnalCode,FoundCode,2,-1)) then
    {$B+}
      Begin
        AssignFromGlobal(JMiscF);
        Case DedIdR.KitLink of
          1..4  :  Begin
                     UseAHed:=AnalHed;

                     If (AppIdR.IdDocHed In JAPSalesSplit) and (UseAHed=1) then {Its a sales revenue type so check based on Revenue type}
                       UseAHed:=RevenueType;

                     FoundOk:=(UseAHed In GetRtRelate(BOff,SetXlate[DedIdR.KitLink],0).PossSet);

                     If (Not FoundOk) and (DedIdR.KitLink=3) then {Additional test on labour}
                       FoundOk:=(UseAHed In GetRtRelate(BOff,4,0).PossSet);
                   end;
          else  FoundOk:=BOn;
        end; {Case..}


      end
      else
        FoundOk:=(DedIdR.KitLink=0);
    end; {With..}

    Result:=FoundOk;
  end;

  { == Function to temporarily override YTD check for incremental only apps, as YTD figures still relevant ==}

  Function ForceGI(InvR    :  InvRec)  :  Boolean;

  Begin
    Result:=(JAbMode(InvR)=0) and (InvR.InvDocHed In JAPJAPSplit);

  end;

  {== As ForceGI, but only apply to practical retention lines at practical or final ==}

  Function ForcePracGI(InvR    :  InvRec;
                       IdR     :  IDetail)  :  Boolean;

  Begin
    Result:=ForceGI(InvR);

    If (Result) then
      Result:=(JAIMode(InvR)>1) and (IdR.COSNomCode=2);

  end;

  { == Test for a direct ratio calculation == }

  Function ISEq_DiscountPcnt(IdR     :  IDetail;
                             InvR    :  InvRec)  :  Boolean;

  Begin
    With InvR, IdR do
    Begin
      Result:=(LiveUplift) or (DiscountChr<>PcntChr) or ((JA_IsGrossInc(InvR,BOn)) and (SOPLink<>0)) and (Reconcile<>0);
    end; {With..}

  end; {Func..}


  { For Gross Incremental and pure value retentions/ deductions return equivalent % }

  Function Eq_DiscountPcnt(IdR     :  IDetail;
                           InvR    :  InvRec;
                       Var ExLocal :  TdExLocal;
                           UseCert,
                           CISCalc,
                           UseLineOnly
                                   :  Boolean)  :  Double;
  Var
    N,
    YTMode    :  Byte;
    DVal,
    YTotal    :  Double;
    PractCalc :  Boolean;

  Begin
    DVal:=0.0; YTotal:=0.0;  YTMode:=0;

    With InvR, IdR do
    Begin
      PractCalc:=BOff;

      If ISEq_DiscountPcnt(IdR,InvR)  or (ForcePracGI(InvR,IdR)) then
      Begin
        {PractCalc:=JA_PractRetLine(InvR,IdR);}

        DVal:=NetValue;

        If (JA_IsGrossInc(InvR,BOn)) and (Not CISCalc) and (SOPLink<>0) and (Not PractCalc) then
          DVal:=DVal+Calc_JAPLineTotal(IdR,Idr.SSDUseLine,1); {Include previous in calculation}

        n:=TransNat;

        If {(CISCalc) or} (SOPLink=0) then {Do not apply cumulative YTD calculations to CIS or non linked lines}
          TransNat:=0;

        If ((CISCalc) and (Not PrxPack) and (UseLineOnly)) or  ((JAbMode(InvR)=0) and (Not CISCalc)) then

          YTMode:=1 + Ord(UseLineOnly) ;

        YTotal:=CalcJAPRetTotals(InvR,IdR,ExLocal,99-(Ord(PrxPack)*Ord(CISCalc))+YTMode,0);

        TransNat:=n;

        {If (Reconcile=2) then
        Begin
          YTotal:=Calc_JAPAppTotal(InvR,UseCert,0);

          If (TransNat=0) then
            YTotal:=YTotal+Calc_JAPAppTotal(InvR,UseCert,1);


        end
        else
        Begin

        end;}

        Result:=DivWChk(DVal,YTotal)*100;
      end
      else
        Result:=Discount;
    end; {With..}
  end;


  { ================= Return immediate parent budget total ================ }

  { rMode = What it is we want to return }
  {     0 = Return immediate parent budget}
  {     1 = Return Top level budget }


  Function GetJAParentTotal(InvR     :  InvRec;
                            rMode    :  Byte)  :  Double;



  Const
    Fnum     =  InvF;
    Keypath  =  InvOurRefK;



  Var

    KeyS,
    KeyChk    :  Str255;



    ExStatus  :  Integer;

    TmpStat,
    TmpKPath   : Integer;
    TmpRecAddr : LongInt;

    CopyInv    : InvRec;


  Begin
    Result:=0.0;

    If (InvR.DeliverRef<>'') then
    Begin
      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      ExStatus:=0;  CopyInv:=Inv;

      KeyS:=FullOurRefKey(InvR.DeliverRef);

      ExStatus:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      If (ExStatus=0) then
      Begin
        If (rMode=1) and (Inv.DeliverRef<>'') then
          Result:=GetJAParentTotal(Inv,rMode)
        else
          Result:=Currency_ConvFT(Inv.TotalCost,Inv.Currency,InvR.Currency,UseCoDayRate);

      end;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);

      Inv:=CopyInv;

    end; {With..}
  end; {Proc..}



  { ================= Calculate Retention Totals ================ }

  { rMode = What it is we want to return }
  {     0 = Return total value of all matching imode retentions as a total percentage}
  {     1 = Return line total value of matching deductions for the line. Pass in Exlocal.LCtrlDbl undiscounted line total for additional CIS}
  {     2 = Return Total net value of all expiry retention lines for the case of a practical incremenal application with only reversing retention in it }
  {     3 = Return total value of all deductions calced b4 retentions as a total percentage}

  { iMode = Match on Interim level
    0     = Interim and standard retentions only
    1     = Practical only   }

  // CJS 2014-04-04 - ABSEXCH-15260 - CIS Gross on JSA with no Labour - added
  //                  ExcludeMaterialsOnly parameter (default of False preserves
  //                  existing behaviour
  Function GetJAPRetTotals(Var  InvR     :  InvRec;
                           Var ExLocal   :  TdExLocal;
                               rMode,
                               iMode     :  Byte;
                               ExcludeMaterialsOnly: Boolean = False)  :  Double;



  Const
    Fnum     =  IDetailF;
    Keypath  =  IDFolioK;



  Var

    CheckThisValue,
    UseThisValue,
    IgnoreRet :  Boolean;

    KeyS,
    KeyChk    :  Str255;


    LineTotal,
    RetDeduct,
    DedTotal,
    CompDisc,
    YTDNetValue,
    TotalThisApp,
    CalcEquivPcnt,
    RDRatio,
    RetPcnt,
    CompTotal
              :  Double;

    ExStatus  :  Integer;

    TmpStat,
    TmpKPath   : Integer;
    TmpRecAddr : LongInt;

    CopyId    :  IDetail;

    Exclude: Boolean;

  Begin
    With ExLocal do
    Begin
      LineTotal:=0;  CompTotal:=0.0;  RetDeduct:=0.0;  DedTotal:=0.0;  CompDisc:=0.0;  IgnoreRet:=BOff;  YTDNetValue:=0.0;

      TmpKPath:=GetPosKey;  RDRatio:=0.0; TotalThisApp:=0.0; RetPcnt:=0.0; CalcEquivPcnt:=0.0;

      CheckThisValue:=BOff;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      ExStatus:=0;  CopyId:=LId;

      With InvR do
      Begin

        Case rMode of
           1  : Begin
                  KeyChk:=FullNomKey(FolioNum);

                  KeyS:=FullIdKey(FolioNum,JALRetLineNo);

                  {* v5.61 Adjust basis of ratio calucaltion for CIS to line or YTD based on basis of calculation *}
                  If (JA_IsGrossInc(InvR,BOn) and (TransMode<2) and (TransNat>0) and (InvDocHed In JAPJAPSplit)) then
                  Begin
                    TotalThisApp:=CalcJAPRetTotals(InvR,LId,ExLocal,101,0);

                    CheckThisValue:=BOn;
                  end;


                  If ((JA_IsGrossInc(InvR,BOn)) or ((JAbMode(InvR)=0) and (InvDocHed In JAPJAPSplit) and (TransMode>1) {and (LCtrlDbl=0.0)})) and (CopyId.SOPLink<>0) then
                  Begin
                    YTDNetValue:=Calc_JAPLineTotal(CopyID,PDiscTaken,1);
                  end;

                  {*EN560. Restrict search to Dedlines if retentions remain as two stage}
                end;
             3  :  Begin
                     KeyChk:=FullIdKey(FolioNum,JALDedLineNo);

                     KeyS:=KeyChk;

                   end;
          else  Begin
                  KeyChk:=FullIdKey(FolioNum,JALRetLineNo);

                  KeyS:=KeyChk;
                end;
        end; {case..}
      end;


      ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);


      While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (LId.Reconcile<>0) do
      With LId do
      Begin
        UseThisValue:=BOff;

        // CJS 2014-04-04 - ABSEXCH-15260 - CIS Gross on JSA with no Labour -
        //                  added check for materials-only retentions
        Exclude := (ExcludeMaterialsOnly and LId.tlMaterialsOnlyRetention);

        {$IFDEF ABSEXCH-15506}
        // CJS 2014-08-15 - ABSEXCH-15506 - JST discount lines
        if not (CurrentJobCode = ExLocal.LId.JobCode) then
          Exclude := True;
        {$ENDIF}

        if not Exclude then
          If ((JA_UseThisRetLine(COSNomCode,iMode,0)) or ((JAbMode(InvR)=0) and (iMode>=2) and (IdDocHed In JAPJAPSplit)) or  ((iMode=2) and (SSDSPUnit=2) and (rMode In [1,2]))) and (Reconcile=2)
             and ((iMode<>3) or (SSDSPUnit<>3) or (rMode In [1,2]))
             and (CheckKey(CopyId.JobCode,JobCode,Length(CopyId.JobCode),BOff)) then
          Begin
            Case rMode of
              0  :  LineTotal:=LineTotal+Eq_DiscountPcnt(LId,InvR,ExLocal,InvR.PDiscTaken,BOff,BOff);
              1  :  Begin
                      If (PrxPAck) then
                        RetDeduct:=RetDeduct+Round_Up((YTDNetValue)*Pcnt(Eq_DiscountPcnt(LId,InvR,ExLocal,InvR.PDiscTaken,BOn,BOff)),2)
                      else
                      Begin
                        RDRatio:=LCtrlDbl+YTDNetValue;

                        If (CheckThisValue) then
                        Begin
                          If (NetValue<>0.0) then {Take off deduction first before working out as long as we have a value there in the first place}
                          Begin
                            RetPcnt:=GetJAPRetTotals(InvR,ExLocal,3,iMode);
                          end
                          else
                            RetPcnt:=0.0;

                          CalcEquivPcnt:=Round_Up(TotalThisApp-Calc_PAmount(TotalThisApp,Pcnt(RetPcnt),PcntChr),2);

                          CalcEquivPcnt:=Round_Up(CalcEquivPcnt*Pcnt(LId.Discount),2);

                          // CJS - 2010-04-28
                          // Because CalcEquivPcnt is calculated by totalling up
                          // the values on the lines, it can occasionally result
                          // in a rounding error, in which case the original
                          // comparison failed, even though the values should have
                          // matched. To compensate, the check has been amended to
                          // only fail if the difference is greater than 1p.

  //                        UseThisValue:=(Round_Up(NetValue-CalcEquivPcnt,2)=0.0);
                          UseThisValue:=(Abs(Round_Up(NetValue-CalcEquivPcnt,2)) < 0.015);

                          If (UseThisValue) then {* Any reversals other than prac need to be YTD based *}
                            RDRatio:=LCtrlDbl;
                        end;

                        RetDeduct:=RetDeduct+Round_Up(RDRatio*Pcnt(Eq_DiscountPcnt(LId,InvR,ExLocal,InvR.PDiscTaken,BOn,UseThisValue)),2);


                      end;
                    end;
              2  :  Begin
                      If (LiveUpLift) then
                        LineTotal:=LineTotal+NetValue;
                    end;
            end;

            {*EN560. rmode check for 1 needs to be taken out if retentions remain as two stage}
          end {With..}
             else
             If (rMode=3) and (Reconcile=1) and (JapDedType=0)  and (ShowCase) then {Work out percentage value of deductions b4 ret}
             Begin
               NetValue:=CalcJAPRetTotals(InvR,LId,ExLocal,Reconcile,JAiMode(InvR)); {* work out deduction line value in advance so that
                                                                                        Get Eq Pcnt has upto date netvalue to work from *}

               SSDUseLine:=InvR.PDiscTaken;

               LineTotal:=LineTotal+Eq_DiscountPcnt(LId,InvR,ExLocal,InvR.PDiscTaken,BOff,BOff);

             end;


        {$B-}
        If (rMode=1) and (Reconcile=1) {and (DiscountChr=PcntChr)} and (Match_Ded2AppLine(ExLocal,LId,CopyId)) and ((CheckKey(CopyId.JobCode,JobCode,Length(CopyId.JobCode),BOff)) or (JAPDedType=1)) then
        {$B+}
        Begin
          If (JAPDedType=0) then
          Begin                              {This condition looked good for ded b4 ret, but tests against Sysadv1 example were terrible}
            If (ISEq_DiscountPcnt(LId,InvR)) {$IFDEF ENXXXX5601} and (Not ShowCase) {$ENDIF} then {* As it is a ratio, it will already include any pre retention calculation *}
            Begin
              RDRatio:=LCtrlDbl+YTDNetValue;

              If (CheckThisValue) then
              Begin
                If (Not ShowCase) and (NetValue<>0.0) then {Take off deduction first before working out as long as we have a value there in the first place}
                Begin
                  RetPcnt:=GetJAPRetTotals(InvR,ExLocal,0,iMode);
                end
                else
                  RetPcnt:=0.0;

                CalcEquivPcnt:=Round_Up(TotalThisApp-Calc_PAmount(TotalThisApp,Pcnt(RetPcnt),PcntChr),2);

                CalcEquivPcnt:=Round_Up(CalcEquivPcnt*Pcnt(LId.Discount),2);

                // CJS - 2010-04-28
                // Because CalcEquivPcnt is calculated by totalling up
                // the values on the lines, it can occasionally result
                // in a rounding error, in which case the original
                // comparison failed, even though the values should have
                // matched. To compensate, the check has been amended to
                // only fail if the difference is greater than 1p.

//                UseThisValue:=(Round_Up(NetValue-CalcEquivPcnt,2)=0.0);
                UseThisValue:=(Abs(Round_Up(NetValue-CalcEquivPcnt,2)) < 0.015);

                If (UseThisValue) then {* Any reversals other than prac need to be YTD based *}
                  RDRatio:=LCtrlDbl;
              end;


              DedTotal:=DedTotal+Round_Up(RDRatio*Pcnt(Eq_DiscountPcnt(LId,InvR,ExLocal,InvR.PDiscTaken,BOn,UseThisValue)),2);
            end

            else                                                                {* Removed as zero value finals on incremental only was not including deductions *}
              DedTotal:=DedTotal+Round_Up((LCtrlDbl-(RetDeduct*Ord((Not ShowCase) {and (LCtrlDbl<>0.0)})))*Pcnt(Eq_DiscountPcnt(LId,InvR,ExLocal,InvR.PDiscTaken,BOff,BOff)),2);
          end
          else
            If (JAPDedType=1) then
            Begin
              If (Not LiveUplift) then
                CompDisc:=CompDisc+Discount;

              If (Not IgnoreRet) then
                IgnoreRet:=(ShowCase);
            end;


        end;


        ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);


      end; {While..}

      Case rMode of
        1     :  Begin
                   If (Not IgnoreRet) then
                     Result:=RetDeduct+DedTotal
                   else
                     Result:=DedTotal;

                   If (CompDisc<>0.0) then
                   Begin
                     CompTotal:=Round_Up((LCtrlDbl-Result)*Pcnt(CompDisc),2);

                     Result:=Result+CompTotal;
                   end;

                 end;
        else     Result:=LineTotal;
      end; {Case..}

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);

      LId:=CopyId;

    end; {With..}
  end; {Proc..}

{ == Calculate CIS additional discount == }
// CJS 2014-03-18 - ABSEXCH-14289 - incorrect CIS Calculation when CITB Deduction is set to 1.5%

// This is a replacement for the Calc_AddCIS() procedure below. Instead of
// required an IDetail record and returning the calculated value in the
// CISAdjust field this simply returns the value.
function CalculateCISAdjustment(InvR: InvRec; LineValue: Double; Mode: Integer): Double;
var
  ExLocal: TdExLocal;
begin
  Result := 0.0;
  // For Job Applications only
  if (InvR.InvDocHed In JAPJAPSplit) then
  begin
    // GetJAPRetTotals() requires a TdExLocal instance
    ExLocal.Create;
    try
      ExLocal.LCtrlDbl := LineValue;
      Result := GetJAPRetTotals(InvR, ExLocal, 1, Mode, True);
    finally
      ExLocal.Destroy;
    end;
  end;
end;

  Procedure Calc_AddCIS(InvR           :  InvRec;
                    Var IdR            :  IDetail;
                        CLineValue     :  Double;
                        iMode          :  Byte);

  Var
    ExLocal    :  TdExLocal;

    Deduct1    :  Double;

  Begin
    Deduct1:=0.0;

    With IdR do
    Begin
      If (IdDocHed In JAPJAPSplit) then
      Begin

        ExLocal.Create;

        try
        With ExLocal do
        Begin
          LId:=IdR;

          LCtrlDbl:=CLineValue;

          Deduct1:=GetJAPRetTotals(InvR,ExLocal,1,iMode);


          CISAdjust:=Deduct1;

        end; {With..}
        finally

          ExLocal.Destroy;

        end; {Try..}
      end;
    end; {With..}
  end;


  { == Calculate the total value of a retention line by scanning all app lines and applying the retention to it == }

  { rMode = What it is we want to return }
  {     2 = Return total value For a given retention line}
  {     1 = Return total value for a given dedcution line
       98 = Return YTD Total for matching analysis type during CIS Calculation
       99 = Return total for matching analysis type.
      100 = Return total for matching analysis type, exclude YTD totals.
      101 = Return This apps total only for CIS calculation}

  { iMode = Match on Interim level
    0     = Interim and standard retentions only
    1     = Practcal only   }


  Function CalcJAPRetTotals(Var  InvR     :  InvRec;
                                IdR       :  Idetail;
                            Var ExLocal   :  TdExLocal;
                                rMode,
                                iMode     :  Byte)  :  Double;



  Const
    Fnum     =  IDetailF;
    Keypath  =  IDFolioK;




  Var
    UseGI,
    FoundOk   :  Boolean;

    FoundCode :  Str20;

    KeyS,
    KeyChk    :  Str255;

    UnitValue,
    LineTotal,
    LineValue,
    RetPcnt
              :  Double;

    ExStatus  :  Integer;

    TmpStat,
    TmpKPath   : Integer;
    TmpRecAddr : LongInt;

    CopyId    :  IDetail;

    // CJS 2014-02-12 - ABSEXCH-14946 - JSA Retention and CIS Tax Calculation
    // CJS 2014-02-18 - ABSEXCH-15084 - corrected check for retention line (it
    //                                  was checking ExLocal.LId instead of
    //                                  IdR).
    // CJS 2014-02-26 - ABSEXCH-15084 - added Revenue Type 5 (Stock Issues)
    //                                  when checking for valid Analysis Codes
    function IncludeRetention: Boolean;
    // Returns True if the current line should be included in the retention
    // calculations. This function should only be called when the transaction
    // line in ExLocal.LId is a normal line (not a retention or deduction line),
    // and when IdR (the line for which the value is being calculated) is a
    // retention line.
    var
      FoundCode: Str20;
    begin
      Result := True;
      // This test is only required if we should only include retentions for
      // analysis codes which are for Materials
      if IdR.tlMaterialsOnlyRetention then
      begin
        // Locate the Analysis Code record
        if (GetJobMisc(Application.MainForm,ExLocal.LId.AnalCode,FoundCode,2,-1)) then
        begin
          // Check that it is for Materials
          Result := (JobMisc^.JobAnalRec.RevenueType = 12) or // Sub Materials
                    (JobMisc^.JobAnalRec.RevenueType = 5);    // Stock Issues
        end
        else
          Result := False;
      end;
    end;

  Begin
    With ExLocal do
    Begin
      LineTotal:=0; UnitValue:=0.0;  FoundCode:=''; FoundOk:=BOff;

      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      ExStatus:=0;  CopyId:=LId;

      With InvR do
      Begin
        KeyChk:=FullNomKey(FolioNum);

        KeyS:=FullIdKey(FolioNum,1);
      end;

      With InvR do
        UseGI:=(((JA_IsGrossInc(InvR,BOn) or (rMode In [98,99])) and (rMode<>101)) or ((rMode=2) and (ForceGI(InvR)) and (IdR.COSNomCode=2))) and (IdR.SOPLink<>0);

      ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

      While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))  do
      Begin

        With LId do
        // Only calculate values based on normal lines (not Retention or Deduction)
        If (Reconcile=0) and (CheckKey(IdR.JobCode,JobCode,Length(IdR.JobCode),BOff))  then
        Begin
          LineValue:=0.0;

          If (rMode<>98) then
            // Get the value for the current application
            UnitValue:=Calc_JAPLineTotal(LId,InvR.PDiscTaken,0)
          else
            UnitValue:=0.0;

          If (UseGI) then
            // Add the cumulative value from previous applications
            UnitValue:=UnitValue+Calc_JAPLineTotal(LId,InvR.PDiscTaken,1);

          Case rMode of

            1  :  If (JAPDedType=0) then {*Normal*}
                  Begin
                    FoundOk:=Match_Ded2AppLine(ExLocal,IdR,LId);

                    If (FoundOk) then
                    Begin
                      // If Deduct Before Retention is not set and we have a
                      // value...
                      If (Not IdR.ShowCase) and (UnitValue<>0.0) then {Take off retention first before working out as long as we have a value there in the first place}
                      Begin
                        // ...get the total Deduction percent from all the
                        // deduction lines
                        RetPcnt:=GetJAPRetTotals(InvR,ExLocal,0,iMode);
                      end
                      else
                        RetPcnt:=0.0;

                      // Remove the deduction from the line value
                      LineValue:=Round_Up(UnitValue-Calc_PAmount(UnitValue,Pcnt(RetPcnt),PcntChr),2);

                      // Add the retention amount, based on the line value after
                      // removing the deduction (Id.Discount is the retention
                      // percentage)
                      // CJS 2014-03-18 - ABSEXCH-14289 - incorrect CIS Calculation when CITB Deduction is set to 1.5%
                      LineTotal:=LineTotal + Round_Up((LineValue * Pcnt(IdR.Discount)), 3);
                    end;
                  end;

            2  :  Begin
                      If (UnitValue<>0.0) then {Take off retention first before working out as long as we have a value there in the first place}
                      Begin
                        // Retrieve the total deduction percentage from all the
                        // deduction lines
                        RetPcnt:=GetJAPRetTotals(InvR,ExLocal,3,iMode);
                      end
                      else
                        RetPcnt:=0.0;

                      // Remove the deduction from the line value
                      LineValue:=Round_Up(UnitValue-Calc_PAmount(UnitValue,Pcnt(RetPcnt),PcntChr),2);

                      // Add the retention amount, based on the line value after
                      // removing the deduction
                      // CJS 2014-02-12 - ABSEXCH-14946 - JSA Retention and CIS
                      //                                  Tax Calculation
                      // CJS 2014-03-18 - ABSEXCH-14289 - incorrect CIS Calculation when CITB Deduction is set to 1.5%
                      if IncludeRetention then
                        LineTotal := LineTotal + Round_Up(LineValue * Pcnt(IdR.Discount), 3);

                  end;

            98,
            99,
            100,
            101
               :  If (JAPDedType=0) then {*Compound*}
                  Begin
                    FoundOk:=Match_Ded2AppLine(ExLocal,IdR,LId);

                    If (FoundOk) then
                    Begin
                      LineTotal:=LineTotal+UnitValue;

                    end;
                  end;
          end;

        end; {With..}

        ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}

      Case rMode of
        1,2  :  Begin
                  LineTotal:=Round_Up(LineTotal-(Calc_JAPLineTotal(IdR,InvR.PDiscTaken,1)*Ord(UseGI)),2);

                  {$B-}
                  If (InvR.InvDocHed In JAPJAPSplit) and (LineTotal=0.0) and (IdR.Discount<>0.0) and (Not Idr.ShowCase) and (JAbMode(InvR)=0) and (CalcJAPRetTotals(InvR,IdR,ExLocal,100,iMode)=0.0) then
                  {$B+}
                  Begin
                    {Base the deduction on the retained value}

                    LineTotal:=LineTotal+Round_Up(GetJAPRetTotals(InvR,ExLocal,2,iMode)*Pcnt(IdR.Discount),2)*DocNotCnst;
                  end;

                end;

      end; {case..}
      Result:=LineTotal;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);

      LId:=CopyId;

    end; {With..}
  end; {Proc..}


 { ======== Procedure to Update header part of YTD Link ======= }


  Procedure Check_JTLink(Fnum,
                         KeyPath  :  Integer;
                         IdR      :  IDetail;
                         DedCnst  :  SmallInt;
                         Update   :  Boolean;
                     Var InvR     :  InvRec);



  Var
    KeyS    :  Str255;
    Locked  :  Boolean;

    LAddr,
    RecAddr :  LongInt;

    TmpInv  :  ^InvRec;



  Begin

    RecAddr:=0;

    New(TmpInv);

    TmpInv^:=Inv;

    Blank(InvR,SizeOf(InvR));

    Locked:=BOff;

    KeyS:=FullNomKey(IdR.SOPLink);

    Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Preserve DocPosn *}

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (StatusOk) then
    With Inv do
    Begin

      If (Update) then
      Begin
        InvR:=Inv;

        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

        If (Ok) and (Locked) then
        With IdR do
        Begin
          Case Reconcile of
            1  :  If (Not (AutoLineType In [2,3])) then
                  Begin
                    PostDiscAm:=PostDiscAm+(IdR.SSDUplift*DedCnst);
                    BatchNow:=BatchNow+(IdR.CostPrice*DedCnst);
                  end;
            2  :  Begin
                    TotOrdOS:=TotOrdOS+(IdR.SSDUplift*DedCnst);
                    BatchThen:=BatchThen+(IdR.CostPrice*DedCnst);
                  end;

            else  Begin
                    TotalReserved:=TotalReserved+(IdR.CostPrice*DedCnst);
                    TotalOrdered:=TotalOrdered+(Round_Up(IdR.NetValue,2)*DedCnst);
                  end;
          end; {Case..}

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

          Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

            If (NomAuto) and (InvDocHed In JAPOrdSplit) and ((InvDocHed<>JST) or EmptyKey(InvR.DeliverRef,DocKeyLen)) then {* Update customer comitted value *}
              UpdateCustAppBal(InvR,Inv);

        end; {If Locked..}

      end; {If Order needs updating..}

      InvR:=Inv;

    end; {If Header found..}


    SetDataRecOfs(Fnum,RecAddr);

    If (RecAddr<>0) then
      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

    Inv:=TmpInv^;

    Dispose(TmpInv);

  end; {Proc..}


  { ======== Procedure to Update the YTD Link ======= }

  Procedure Update_JTLink(Idr     :  IDetail;
                          AppInv  :  InvRec;
                          Deduct,
                          UpHed   :  Boolean;
                          Fnum,
                          Keypath,
                          KeyResP,
                          Level :  Integer);



  Var
    LAddr,
    RecAddr  :  LongInt;

    
    TmpId    :  ^IDetail;
    CopyId,
    JAId,
    CurrIdR  :  IDetail;

    KeyS,
    KeyChk   :  Str255;

    Locked,
    FoundOk  :  Boolean;

    DedCnst  :  Integer;

    InvR     :  InvRec;


  { == Function to maintain switched comitted by tracking only those values with the committed flag set === }

  Function  Link_To_JA  :  Double;

  Const
    Fnum      =  JDetlF;
    Keypath   =  JDLookK;

  Var
    KeyChk  :  Str255;

  Begin
    With Id do                                      {* JA_X Replace with dedicated job code *}
      KeyChk:=PartCCKey(JBRCode,JBECode)+FullJDLookKey(FolioRef,ABSLineNo);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyChk);

    If (StatusOk) then
      Result:=JobDetl^.JobActual.Cost
    else
      Result:=0.0;
  end;


  Begin

    FoundOk:=BOff;
    Locked:=BOff;

    RecAddr:=0;

    If (Deduct) then
      DedCnst:=-1
    else
      DedCnst:=1;

    If (IdR.SOPLink<>0) and ((IdR.IdDocHed In [JSA,JPA]) or (Level>0)) then
    Begin

      New(TmpId);

      TmpId^:=Id;

      Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Preserve DocPosn *}

      KeyChk:=FullIdKey(IdR.SOPLink,IdR.SOPLineNo);

      KeyS:=KeyChk;


      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      If (StatusOk) then
      Begin
        CopyId:=Id;

        CurrIdR:=Curr_ConvertJAPId(IdR,Id.Currency,Id.CXRate,0);

        Begin

          Locked:=BOff;

          Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

          If (Ok) and (Locked) then
          With Id do
          Begin

            Case Reconcile of
              1,2
                 :  If (Not (AutoLineType In [2,3])) then
                    Begin
                      QtyPWOff:=QtyPWOff+(CurrIdR.SSDUplift*DedCnst);
                      QtyDel:=QtyDel+(CurrIdR.CostPrice*DedCnst);
                    end;

              else  Begin
                      QtyDel:=QtyDel+(CurrIdR.CostPrice*DedCnst);
                      QtyPWOff:=QtyPWOff+(CurrIdR.NetValue*DedCnst);
                    end;
            end; {Case..}



            Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

            Report_BError(Fnum,Status);

            If (CostPrice<>0.0) and (Status=0) and (IdDocHed In JAPOrdSplit+[JPT]) then
            Begin
              Check_JTLink(InvF,InvFolioK,CurrIdR,DedCnst,BOff,InvR);

              JAId:=Id;

              If (SyssJob^.JobSetUp.JADelayCert) and (Not (Reconcile In [1,2])) then {* v5.70 Cancel effect of certified temporarily *}
              Begin
                Id.QtyPWOff:=Round_Up(Id.CostPrice-Link_To_JA,2); {*Reset to previous certified*}

                If (AppInv.PDiscTaken) then
                  Id.QtyPWOff:=Id.QtyPWOff+(CurrIdR.NetValue*DedCnst);

              end;

              Update_JobAct(Id,InvR);

              Id:=JAId;
            end;


            Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

          end; {If Locked..}

        end; {If Not update header}

        If (UpHed) then
        Begin

          Check_JTLink(InvF,InvFolioK,CurrIdR,DedCnst,BOn,InvR);

        end;

        If (Id.SOPLink<>0) and (Id.SOPLink<>IdR.SOPLink) and (Level=0) then {Roll up Update to next parent JPT/JST}
        Begin
          IdR.SOPLink:=Id.SOPLink; IdR.SOPLineNo:=Id.SOPLineNo;
          Update_JTLink(IdR,AppInv,Deduct,UpHed,Fnum,KeyPath,KeyPath,Succ(Level));
        end;


      end; {If Line Matched}

      SetDataRecOfs(Fnum,RecAddr);

      If (RecAddr<>0) then
        Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyResP,0);

      Id:=TmpId^;

      Dispose(TmpId);

    end; {If Linked Line}

  end; {Proc..}

  { == Procedure to convert JAP values from one Line's currency to another == }

  Function Curr_ConvertJAPId(IdR      :  IDetail;
                             NewCurr  :  Byte;
                             NewRates :  CurrTypes;
                             Mode     :  Byte)  : IDetail;

  Var
    UOR  :  Byte;
    Dnum :  Double;

  Begin
    UOR:=0;

    Result:=IdR;

    {$IFDEF MC_On}
      If (NewCurr<>IdR.Currency) then
      With Result do
      Begin
        Dnum:=Conv_TCurr(CostPrice,XRate(CXRate,BOff,Currency),Currency,0,BOff);

        CostPrice:=Round_Up(Conv_TCurr(Dnum,XRate(NewRates,BOff,NewCurr),NewCurr,0,BOn),Syss.NoCosDec);

        Dnum:=Conv_TCurr(NetValue,XRate(CXRate,BOff,Currency),Currency,0,BOff);

        NetValue:=Round_Up(Conv_TCurr(Dnum,XRate(NewRates,BOff,NewCurr),NewCurr,0,BOn),Syss.NoNetDec);

        Dnum:=Conv_TCurr(QtyDel,XRate(CXRate,BOff,Currency),Currency,0,BOff);

        QtyDel:=Round_Up(Conv_TCurr(Dnum,XRate(NewRates,BOff,NewCurr),NewCurr,0,BOn),2);

        Dnum:=Conv_TCurr(QtyPWOff,XRate(CXRate,BOff,Currency),Currency,0,BOff);

        QtyPWOff:=Round_Up(Conv_TCurr(Dnum,XRate(NewRates,BOff,NewCurr),NewCurr,0,BOn),2);

        Dnum:=Conv_TCurr(QtyWOff,XRate(CXRate,BOff,Currency),Currency,0,BOff);

        QtyWOff:=Round_Up(Conv_TCurr(Dnum,XRate(NewRates,BOff,NewCurr),NewCurr,0,BOn),2);

        Dnum:=Conv_TCurr(SSDUplift,XRate(CXRate,BOff,Currency),Currency,0,BOff);

        SSDUplift:=Round_Up(Conv_TCurr(Dnum,XRate(NewRates,BOff,NewCurr),NewCurr,0,BOn),2);


      end;
    {$ENDIF}
  end;

  { ================= Calculate Application Totals ================ }
  { DedRetMode Controls if Deduction/ Retention lines are re-calculated as part of process }
  { 0 = No Update
  { 1 = Update Deductions only (Retention changed)
  { 2 = Update Retentions only. Can't see a use for this..
  { 3 = Combine 1&2  i.e. app lines have been altered in some way }

  Procedure CalcJAPVATTotals(Var InvR      :  InvRec;
                             Var ExLocal   :  TdExLocal;
                                 ReCalcVAT :  Boolean;
                                 DedRetMode:  Byte);



  Const
    Fnum     =  IDetailF;
    Keypath  =  IDFolioK;



  Var
    HaveCompDed,
    Ok2Store  :  Boolean;

    KeyS,
    KeyChk    :  Str255;


    LineTotal
              :  Double;

    ExStatus  :  Integer;

    TmpStat,
    TmpKPath  : Integer;
    TmpRecAddr: LongInt;

    CopyId    :  IDetail;


  Procedure Increment_Totals;

  Var
    LCnst  :  Integer;

  Begin
    With ExLocal,LId,InvR do
    Begin
      LCnst:=ComnU2.LineCnst(Payment);

      If (InvR.PDiscTaken) then
        LineTotal:=NetValue
      else
        LineTotal:=CostPrice;

      Case Reconcile of
        1  :  If (Not (AutoLineType In [2,3])) then
              Begin
                If (JAPDedType<>2) then
                Begin
                  DiscAmount:=DiscAmount+Round_Up(NetValue,2);
                  PostDiscAm:=PostDiscAm+Round_Up(QtyPWOff,2);
                  BatchNow:=BatchNow+Round_Up(QtyDel,2);
                end
                else
                Begin
                  BDiscount:=BDiscount+Round_Up(NetValue,2);
                end;
              end;
        2  :  Begin
                If (InvDocHed In [JPA,JSA]) or (JA_UseThisRetLine(COSNomCode,JAiMode(InvR),0)) then
                  DiscSetAm:=DiscSetAm+Round_Up(NetValue,2);

                TotOrdOS:=TotOrdOS+Round_Up(QtyPWOff,2);
                BatchThen:=BatchThen+Round_Up(QtyDel,2);
              end;

        else  Begin
                TotalCost:=TotalCost+Round_Up(CostPrice,2);
                InvNetVal:=InvNetVal+Round_Up(NetValue,2);
                TotalReserved:=TotalReserved+Round_Up(QtyDel,2);
                TotalOrdered:=TotalOrdered+Round_Up(QtyPWOff,2);
              end;
      end; {Case..}

      If (InvR.PDiscTaken<>SSDUseLine) and (ReCalcVAT) and (Reconcile=0) then {* Temporarily work out VAT based on Apps value. If this were
                                                                         to be stored, then SSDUseLine would also need to be updated and
                                                                         a check made on SSDUseLine<>PDiscTaken as a condition of change  *}
      Begin
        SSDUseLine:=InvR.PDiscTaken;
        Calc_AppVAT(ExLocal);

        ExStatus:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath);

        Report_Berror(Fnum,ExStatus);
      end;

      If (InvR.InvDocHed In JAPJAPSplit) then {* Only apply VAT on certified amount *}
      Begin
        If (ReCalcVAT) then
        Begin
          InvR.InvVatAnal[GetVAtNo(VATcode,VATIncFlg)]:=InvR.InvVatAnal[GetVAtNo(VATcode,VATIncFlg)]+(VAT*LCnst);
        end;

        With ExLocal do
        Begin
          LInvNetAnal[GetVAtNo(VATcode,VATIncFlg)]:=LInvNetAnal[GetVAtNo(VATcode,VATIncFlg)]+(LineTotal*LCnst);

          LInvNetTrig[GetVAtNo(VATcode,VATIncFlg)]:=BOn; {* Show Rate is being used, Value independant *}
        end;
      end;

      {$WARNINGS OFF}
      If (DocLTLink<=High(LJAPLineTotal)) and (DocLTLink>=Low(LJAPLineTotal)) then
        LJAPLineTotal[DocLTLink]:=LJAPLineTotal[DocLTLink]+LineTotal;
      {$WARNINGS ON}

    end; {With..}


  end;

  Procedure Calc_Compounds;

  Begin

    KeyChk:=FullIdKey(InvR.FolioNum,JALDedLineNo);

    KeyS:=KeyChk;

    With ExLocal do
    Begin

      ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);


      While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With LId do
      Begin
        If (JAPDedType=1) and (Not LiveUplift) then
        With InvR do
        Begin
          Update_JTLink(LId,InvR,BOn,BOn,Fnum,IdLinkK,Keypath,0);

          LineTotal:=Calc_JAPAppTotal(InvR,InvR.PDiscTaken,0)-DiscAmount-(Ord(Not ShowCase)*DiscSetAm);

          NetValue:=Round_Up(LineTotal*Pcnt(Discount),2);

          PostDiscAm:=PostDiscAm-Round_Up(QtyPWOff,2); {This gets accounted for twice, so deduct here before increment totals picks it up again}

          Update_JAPDeductLine(LId,LInv,0);

          SSDUseLine:=InvR.PDiscTaken;

          CalcVATExLocal(ExLocal,BOff,nil);

          ExStatus:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath);

          Report_Berror(Fnum,ExStatus);

          Increment_Totals;

          Update_JTLink(LId,InvR,BOff,BOn,Fnum,IdLinkK,Keypath,0);

        end;

        ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);


      end; {While..}

    end; {With..}
  end;


  Begin
    With ExLocal do
    Begin
      LineTotal:=0;

      Ok2Store:=BOff;

      ExStatus:=0;

      With InvR do
      Begin
        InvVat:=0;
        InvNetVal:=0.0;
        TotalCost:=0.0;
        DiscAmount:=0.0;
        DiscSetAm:=0.0;
        PostDiscAm:=0.0;
        TotOrdOS:=0.0;
        TotalReserved:=0.0;
        TotalOrdered:=0.0;
        BDiscount:=0.0;
        BatchNow:=0.0;
        BatchThen:=0.0;


        FillChar(LJAPLineTotal,Sizeof(LJAPLineTotal),0);

        If (ReCalcVAT) then
          Blank(InvVatAnal,Sizeof(InvVatAnal));

        With ExLocal do
        Begin
          Blank(LInvNetAnal,Sizeof(LInvNetAnal));

          {* Initialise VAT Flags  added here so that an edit will reset any rates
             which do not exist anymore on the Document *}

          Blank(LInvNetTrig,Sizeof(LInvNetTrig));
        end;

        KeyChk:=FullNomKey(FolioNum);

        KeyS:=FullIdKey(FolioNum,JALRetLineNo);


      end;

      HaveCompDed:=BOff;

      CopyId:=LId;

      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);


      While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With LId do
      Begin
        Ok2Store:=BOff;

        {$IFDEF ABSEXCH-15506}
        // CJS 2014-08-15 - ABSEXCH-15506 - JST discount lines
        CurrentJobCode := LId.JobCode;
        {$ENDIF}

        If (DedRetMode>0) and (LId.Reconcile>0) and (LId.DiscountChr=PcntChr) and (Not LId.LiveUplift) then {We have to update the lines Deduction}
        Begin
          If (((Reconcile=1) and (DedRetMode In [1,3])) or ((Reconcile=2) and (DedRetMode In [2,3]))) then
          Begin
            If (JAPDedType=0) then
              LineTotal:=CalcJAPRetTotals(LInv,LId,ExLocal,Reconcile,JAiMode(LInv)) {*En560. Need to pass in correct imode *}
            else
              LineTotal:=0.0; {* Do not calculate compund discount yet as gets done at the end *}

            Ok2Store:=(Round_Up(LineTotal,2)<>Round_Up(NetValue,2)) or (SSDUseLine<>LInv.PDiscTaken);
            If (Not HaveCompDed) then {* Flag we have some compound deductions which need to be recalculated *}
              HaveCompDed:=((Reconcile=1) and (JAPDedType=1));
          end;


        end
        else
          If (DedRetMode>0) and (LId.Reconcile=2)  and (LId.LiveUplift) and (LInv.TransMode=SSDSPUnit) and (LInv.PDiscTaken<>SSDUseLine) and (LInv.TransMode=2) then {We have to switch auto reversal value}
          Begin
            Ok2Store:=BOn;

            If (LInv.PDiscTaken) then
              LineTotal:=SSDUpLift
            else
              LineTotal:=CostPrice;

          end;

        If (Ok2Store) then
        Begin
          Update_JTLink(LId,InvR,BOn,BOn,Fnum,IdLinkK,Keypath,0);

          NetValue:=Round_Up(LineTotal,2);

          If (SSDUSeLine and (Not LInv.PDiscTaken) and (Not LiveUplift)) and (Reconcile>0) and (IdDocHed In JAPJAPSplit) and (LInv.TransMode<2) then {*  v5.70 ENJACERTFIX If it was certifed but not any more we need to reset so YTD reverse correctly *}
            SSDUplift:=0.0;

          SSDUseLine:=LInv.PDiscTaken;

          Update_JAPDeductLine(LId,LInv,0);

          Calc_AppVAT(ExLocal);

          ExStatus:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath);

          Report_Berror(Fnum,ExStatus);

          Update_JTLink(LId,InvR,BOff,BOn,Fnum,IdLinkK,Keypath,0);

        end;

        Increment_Totals;


        ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);


      end; {While..}

      If (HaveCompDed) then
        Calc_Compounds;

      InvR.InvVat:=CalcTotalVAT(InvR);


      {LInvNetTrig:=ShowManualRates(InvR,ReCalcVAT,LInvNetTrig);}

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);

      LId:=CopyId;

    end; {With..}
  end; {Proc..}

  { == Update valuation Lines from linked JSA lines == }

  Procedure Update_ValuationLine(Var ExLocal    :  TdExLocal);

  Const
    Fnum     =  JCtrlF;
    Keypath  =  JCK;

  Var
    ExStatus    :  Integer;
    LOk,Locked  :  Boolean;
    KeyS        :  Str255;

  Begin
    With ExLocal do
    Begin
      LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

      If (LOk and Locked) then
      With LJobCtrl^,JobBudg do
      Begin
        LGetRecAddr(Fnum);

        If (JABBasis=0) then
          OrigValuation:=OrigValuation+RevValuation
        else
          OrigValuation:=RevValuation;

        RevValuation:=0.0;
        JAPCntApp:=0.0;

        ExStatus:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath);

        Report_Berror(Fnum,ExStatus);

        ExStatus:=UnLockMLock(Fnum,0);
      end;

    end; {With..}
  end;


  Procedure Link_JSAtoVal(Var ExLocal    :  TdExLocal;
                              jbMode     :  Byte);

  Const
    Fnum     =  JCtrlF;
    Keypath  =  JCK;

  Var
    ExStatus    :  Integer;

    KeyS        :  Str255;

    GrossBudget :  Double;

  Begin
    With ExLocal,LId do
    Begin
      If (AnalCode<>'') then
      Begin
        KeyS:=PartCCKey(JBRCode,JBSubAry[6])+FullJBCode(JobCode,0,AnalCode);

        ExStatus:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

        If (ExStatus=0) then
        Begin
          With LJobCtrl^.JobBudg do
            If (JABBasis=1) then
              GrossBudget:=OrigValuation
            else
              GrossBudget:=0.0;


          CostPrice:=Currency_ConvFT(LJobCtrl^.JobBudg.RevValuation-GrossBudget,0,Currency,UseCoDayRate);

          If (jbMode=0) then
            Update_ValuationLine(ExLocal);
        end;

      end;

    end; {With..}
  end;



  { == Create J?T Lines from Job Budget records == }

  Procedure Create_JSTLinesFromJobBudget(Var JcRec      :  tJAppWizRec;
                                         Var ExLocal    :  TdExLocal;
                                             jbMode     :  Byte);

  Const
    Fnum      =  JCtrlF;
    Keypath   =  JCK;

    Fnum2     =  IDetailF;
    Keypath2  =  IdFolioK;

    Fnum3     =  JobF;
    Keypath3  =  JobCatK;



  Var
    ConvCurr,
    SingleJob :  Boolean;
    UOR       :  Byte;
    KeyJ,
    KeyJChk,
    KeyS,
    KeyChk    :  Str255;

    ExStatus  :  Integer;

    TmpStat,
    TmpKPath  :  Integer;

    RecAddr,
    TmpRecAddr: LongInt;

    Profit,
    Sales,
    Purch,
    Bud1,
    Bud2,
    Cleared,

    GrossBudget,
    Dnum,
    Dnum1,
    Dnum2,
    CommitVal :  Double;

    ParentJob :  JobRecType;

    TmpJcRec  :  tJAppWizRec;

  Procedure Add_BudgetLine;

  Var
    KeyA  :  Str20;

  Begin
    With ExLocal,LId do
    Begin
      LResetRec(IdetailF);

      FolioRef:=LInv.FolioNum;

      DocPRef:=LInv.OurRef;

      LineNo:=LInv.ILineCount;

      NomMode:=TSTNomMode; {*EN560 ?? What is this mode, for dd of g/l? *}

      ABSLineNo:=LInv.ILineCount;

      IDDocHed:=LInv.InvDocHed;

      Currency:=LInv.Currency;

      CXRate:=LInv.CXRate;

      CurrTriR:=LInv.CurrTriR;

      PYr:=LInv.ACYr;
      PPr:=LInv.AcPr;

      PDate:=LInv.TransDate;

      If (Dnum2<>0.0) then
        Qty:=Dnum2
      else
        Qty:=Dnum1;

      VATCode:=VATSTDCode;

      DiscountChr:=PcntChr; {*EN560* Default to %, but need to link to anal code *}

      If (Bud2<>0.0) then
        CostPrice:=Bud2
      else
        CostPrice:=Bud1;

      Calc_AppVAT(ExLocal);

      JobCode:=LJobRec^.JobCode;

      KeyA:=LJobCtrl^.JobBudg.AnalCode;

      If (GetJobMisc(Application.MainForm,KeyA,KeyA,2,-1)) then
      Begin
        AssignFromGlobal(JMiscF);
        AnalCode:=LJobCtrl^.JobBudg.AnalCode;

        With LJobMisc^,JobAnalRec do
        Begin
          Desc:=JAnalName;
          DocLTLink:=JLinkLT;
        end;
      end;

      With LCust do
        // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
        // Amended to call new function, passing additional JobRec.CCDep parameter
        LId.CCDep:=GetCustProfileCCDepEx(CustCC,CustDep,LId.CCDep,ExLocal.LJobRec^.CCDep, 0);

      Payment:=DocPayType[PIN];

      ExStatus:=Add_Rec(F[Fnum2],Fnum2,LRecPtr[Fnum2]^,Keypath2);

      Report_Berror(Fnum2,ExStatus);

      If (ExStatus=0) then
      Begin
        Inc(LInv.ILineCount);

        If (CostPrice<>0.0) and (ExStatus=0) and (IdDocHed In JAPOrdSplit) then
          Update_JobAct(LId,LInv);

        If ((CostPrice<>0.0)) and (SOPLink<>0) then
          Update_JTLink(LId,LInv,BOff,BOn,Fnum2,IdLinkK,Keypath2,0);
      end;
    end;
  end;

  Begin {Main Proc..}
    SingleJob:=BOff;
    
    With ExLocal,LInv,JCRec do
    If (awJobCode<>'') then
    Begin
      
      TmpJcRec:=JCRec;

      If (LJobRec^.JobCode<>awJobCode) then
      Begin
        KeyS:=FullJobCode(awJobcode);

        ExStatus:=Find_Rec(B_GetEq,F[Fnum3],Fnum3,LRecPtr[Fnum3]^,JobCodeK,KeyS);

      end
      else
        ExStatus:=0;

      ConvCurr:=BOn;

      If (ExStatus=0) then
      Begin
        ParentJob:=LJobRec^;

        If (ParentJob.JobType=JobGrpCode) then
        Begin
          KeyJChk:=FullJobCode(awJobCode);
          KeyJ:=KeyJChk;

          ExStatus:=Find_Rec(B_GetGEq,F[Fnum3],Fnum3,LRecPtr[Fnum3]^,KeyPath3,KeyJ);

        end
        else
          SingleJob:=BOn;

        While ((ExStatus=0) and (CheckKey(KeyJChk,KeyJ,Length(KeyJChk),BOn))) or (SingleJob) do
        With LJobRec^ do
        Begin
          If (JobType=JobGrpCode) and (JobCode<>ParentJob.JobCode) then {* Recurse down the tree *}
          Begin
            TmpJcRec.awJobCode:=JobCode;

            TmpKPath:=Keypath3;

            TmpStat:=Presrv_BTPos(Fnum3,TmpKPath,F[Fnum3],TmpRecAddr,BOff,BOff);

            Create_JSTLinesFromJobBudget(TmpJcRec,ExLocal,jbMode);

            TmpStat:=Presrv_BTPos(Fnum3,TmpKPath,F[Fnum3],TmpRecAddr,BOn,BOff);

          end
          else
          Begin
            KeyChk:=PartCCKey(JBRCode,JBBCode)+FullJobCode(JobCode);
            KeyS:=KeyChk;

            ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

            While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
            With LJobCtrl^.JobBudg do
            Begin
              If ((BType=1) and (awDT In [JST,JSA])) or (((BType In [4]) or (AnalHed= SysMat2))and (awDT=JPT)) then
              Begin
                If (awDT=JSA) then
                Begin
                  If (JABBasis=1) then
                    GrossBudget:=OrigValuation
                  else
                    GrossBudget:=0.0;

                  Bud1:=RevValuation-Grossbudget;

                  If (jbMode=0) then
                    Update_ValuationLine(ExLocal);
                end
                else
                Begin
                  If (Not SyssJob^.JobSetUp.PeriodBud) then {* Replace period bud with anal bud *}
                  Begin

                    {$IFDEF EX601}
                      Bud1:=JBBCurrency_Txlate(BOValue,JBudgetCurr,0);
                      Bud2:=JBBCurrency_Txlate(BRValue,JBudgetCurr,0);

                    {$ELSE}


                      Bud1:=BOValue;
                      Bud2:=BRValue;
                    {$ENDIF}

                    Dnum1:=BOQty;
                    Dnum2:=BRQty;
                  end
                  else
                  Begin
                    Begin
                      Profit:=Total_Profit_To_Date(JobType,FullJDHistKey(JobCode,HistFolio),Currency,
                                         GetLocalPr(0).CYr,Syss.PrinYr,Purch,Sales,Cleared,Bud1,Bud2,Dnum1,Dnum2,BOn);
                      ConvCurr:=BOff;
                    end;

                    If ((Bud1+Bud2)=0) then
                    Begin
                      Profit:=Total_Profit_To_Date(JobType,FullJDHistKey(JobCode,HistFolio),0,
                                         GetLocalPr(0).CYr,Syss.PrinYr,Purch,Sales,Cleared,Bud1,Bud2,Dnum1,Dnum2,BOn);

                      {*EN560 convert to currency of invoice*}
                    end;


                  end;
                end;

                If (ConvCurr) then
                Begin
                  {$IFDEF MC_On}
                    Bud1:=Currency_ConvFT(Bud1,0,Currency,UseCoDayRate);
                    Bud2:=Currency_ConvFT(Bud2,0,Currency,UseCoDayRate);

                  {$ENDIF}


                end;

                If (Bud1+Bud2<>0) then {Use this as basis of line}
                Begin
                  Case jbMode of
                    1  :  Begin
                            If (Bud2<>0.0) then
                              awValuation:=awValuation+Bud2
                            else
                              awValuation:=awValuation+Bud1;
                          end
                    else
                          Add_BudgetLine;
                  end; {case..}
                end;
              end;

              ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

            end; {While..}
          end;

          If (SingleJob) then
          Begin
            SingleJob:=BOff;
            ExStatus:=4;
          end
          else
          Begin
            ExStatus:=Find_Rec(B_GetNext,F[Fnum3],Fnum3,LRecPtr[Fnum3]^,KeyPath3,KeyJ);
          end;
        end;
      end;

    end;
  end;


  { === Procedure to Generate J?A from J?T === }
  { Mode 0 = New trans based on old trans
         1 = New trans based on wizard details }

  Function Generate_JAFromJT(JMode      :  Byte;
                             JcRec      :  tJAppWizRec;
                         Var ExLocal    :  TdExLocal)  :  Boolean;

  Const
    Fnum      =  InvF;
    Keypath   =  InvOurRefK;

    Fnum2     =  IDetailF;
    Keypath2  =  IdFolioK;


  Var
    UOR       :  Byte;
    IntReverse:  Boolean;

    KeyI,
    KeyS,
    KeyChk    :  Str255;

    ExStatus  :  Integer;

    TmpStat,
    TmpKPath  :  Integer;

    MatchVal  :  Double;

    RecAddr,
    TmpRecAddr: LongInt;

    CopyId    :  IDetail;

    NewInv,
    BlankInv  :  InvRec;


  { == Break YTD link == }

  Function Have_YTDLink :  Boolean;

  Begin
    With ExLocal,LInv,JCRec do
      Result:=(awDoc.InvDocHed In [JPT,JCT,JST]) and (InvDocHed In [JCT,JPA,JSA,JST]);


  end;


  Procedure Gen_Hed;

    Function LinkEmpToSupplier(FoundCode  :  Str20)  :  Boolean;

    Var
      FoundCode2  :  Str20;
      SMode       :  Integer;

    Begin
      SMode:=-1;

      Result:=(GetJobMisc(Application.MainForm,FoundCode,FoundCode,3,SMode));


      If (Result) then
      With ExLocal do
      Begin

        AssignFromGlobal(JMiscF);

        With LJobMisc^.EmplRec do
        Begin

          If (GetCust(Application.MainForm,Supplier,FoundCode2,BOn,-1)) then {*EN560 Get employee *}
          Begin
            AssignFromGlobal(CustF);
          end;
        end;
      end;
    end;


  Begin

    If (JMode=1) then
      ExLocal.LResetRec(InvF)
    else
      ExLocal.LInv:=JCRec.awDoc;

    With ExLocal,LInv,JCRec do
    Begin

      InvDocHed:=awDT;
      SetNextDocNos(LInv,BOn);

      TransMode:=awBasis;
      RunNo:=Set_JAPRunNo(InvDocHed,BOff,BOff);

      TransDate:=awDate; AcPr:=GetLocalPr(0).CPr; AcYr:=GetLocalPr(0).CYr;

      If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
        Date2Pr(TransDate,AcPr,AcYr,nil);


      {$IFDEF MC_On}
        Currency:=awPCurr;

      {$ELSE}
        Currency:=1;

      {$ENDIF}

      If (Not SOPKeepRate) or (awPCurr<>awDoc.Currency) then
      Begin
        CXrate:=SyssCurr.Currencies[Currency].CRates;

        CXRate[BOff]:=0;
      end
      else
        SOPKeepRate:=BOff;


      If (InvDocHed In JAPJAPSplit) then
        CustSupp:='J' {Filter from normal ledger}
      else
        CustSupp:='K';

      OpName:=EntryRec^.Login;

      { CJS - 2013-10-25 - MRD2.6.02 - Transaction Originator }
      TransactionOriginator.SetOriginator(LInv);

      NoLabels:=awSeries;

      TotalInvoiced:=awPrice;

      If (JMode=0) then
      Begin
        If (awBasis<>0) and (awDT In JAPJAPSplit) then
        Begin
          {If (awBasis<2) then}
            TransNat:=awDoc.TransMode {Keep track of what type it is Gross incremental etc}
          {else
            TransNat:=0; {Force incremental on practical onwards}


        end
        else
        Begin
          TransNat:=0;
          TotalReserved:=0.0;
          TotalOrdered:=0.0;
        end;

        If (LCust.CustCode<>CustCode) then
          LGetMainRecPos(CustF,CustCode);

        Blank(DueDate,Sizeof(DueDate));

        If (awDT In JAPJAPSplit) then
          DueDate:=CalcDueDate(TransDate,LCust.PayTerms)
        else
          DueDate:=TransDate;

        DeliverRef:=awJCTRef;

        InvVat:=0;
        InvNetVal:=0.0;
        TotalCost:=0.0;
        DiscAmount:=0.0;
        DiscSetAm:=0.0;
        PostDiscAm:=0.0;
        TotOrdOS:=0.0;
        BDiscount:=0.0;
        CurrSettled:=0.0;

        If (Not Have_YTDLink) then
        Begin
          TotalReserved:=0.0;
          TotalOrdered:=0.0;
        end;

        Blank(InvVatAnal,Sizeof(InvVatAnal));

        CISTax:=0.0;
        CISGross:=0.0;

        If (awDoc.InvDocHed=JPT) then {Take employee code from wizard details}
        Begin
          CISEmpl:=awACode;
          If (LinkEmpToSupplier(CISEmpl)) then
            CustCode:=LCust.CustCode;
        end;

        BatchLink:=FullJAPEmplKey(BOn,CISEmpl,(Not (InvDocHed In [JPA])));


      end
      else
      Begin
        DJobCode:=awJobCode;

        NLineCount:=1;

        ILineCount:=1;


        NomAuto:=BOn;

        Case InvDocHed of
          JST,JSA  :  Begin
                        CustCode:=awACode;
                        LGetMainRecPos(CustF,awACode);
                      end;

          else        Begin
                        CISEmpl:=awACode;

                        If (InvDocHed In [JPA,JCT]) then
                        Begin
                          BatchLink:=FullJAPEmplKey(BOn,CISEmpl,(Not (InvDocHed In [JPA])));

                          If (LinkEmpToSupplier(CISEmpl)) then
                            CustCode:=LCust.CustCode;
                        end;

                      end;
        end; {Case..}

        If (awDT In JAPJAPSplit) then
          DueDate:=CalcDueDate(TransDate,LCust.PayTerms)
        else
          DueDate:=TransDate;

      end;

      If (Not (InvDocHed In [JPT])) and (Not awMaster) then
        TransDesc:=FullJAPJobKey(BOn,DJobCode,(Not (InvDocHed In [JPA,JSA])),(InvDocHed In JAPSalesSplit))
      else
        Blank(TransDesc,Sizeof(TransDesc));

    end;
  end;

  Begin {Main..}
    Result:=BOff;  IntReverse:=BOff;

    Blank(BlankInv,Sizeof(BlankInv)); MatchVal:=0.0; UOR:=0;

    Blank(NewInv,Sizeof(NewInv));

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    Gen_Hed;


    KeyChk:=FullNomKey(JCRec.awDoc.FolioNum);

    KeyS:=FullIdKey(JCRec.awDoc.FolioNum,JALRetLineNo);

    With ExLocal do
    Begin



      If (JMode=0) then
      Begin
        ExStatus:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS);

        While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
        With LId do
        Begin
          IntReverse:=BOff;

          Status:=GetPos(F[Fnum2],Fnum2,RecAddr);  {* Preserve DocPosn *}

          With LInv,JCRec do
            If (Reconcile<>2) or (LInv.TransMode=COSNomCode) or ((awDoc.InvDocHed In [JPT,JST]) and (InvDocHed In [JCT])) or
              ((Reconcile=2) and (LInv.TransMode=SSDSPUnit) and (LInv.TransMode<>COSNomCode)) then
          Begin
            CopyId:=LId;


            {* Convert all the totals *}

            LId:=Curr_ConvertJAPId(CopyId,LInv.Currency,LInv.CXRate,0);

            LId.Currency:=LInv.Currency;
            LId.CXRate:=LInv.CXRate;

            If (Have_YTDLink) then {Link to parent}
            Begin
              SOPLink:=FolioRef;
              SOPLineNo:=ABSLineNo;
            end
            else
            Begin
              SOPLink:=0;
              SOPLineNo:=0;
            end;

            FolioRef:=LInv.FolioNum;
            IdDocHed:=LInv.InvDocHed;
            DocPRef:=LInv.OurRef;
            SSDUpLift:=0.0;

            If (Reconcile<>1) or (DiscountChr=PcntChr) then
              NetValue:=0.0;

            If ((Reconcile=2) and (LInv.TransMode=SSDSPUnit) and (LInv.TransMode<>COSNomCode)) and (InvDocHed In JAPJAPSplit) then {*Expire previous retentions *}
            Begin

              NetValue:=QtyDel;
              CostPrice:=QtyDel*DocNotCnst;
              SSDUpLift:=QtyPWOff*DocNotCnst;

              IntReverse:=BOn;

              PrxPack:=(TransNat In [0..2]);   {* Indicates this is a retention expiry so CIS rules based on YTD totals only *}

              Desc:='Expire '+Desc;
              {SOPLink:=0; {Break link so YTD calculations are not done any more}
              {SOPLineNo:=0;}

              {If (LInv.TransMode=3) then {*Its final app
              Begin
                LineNo:=LInv.ILineCount;
                Inc(LInv.ILineCount);
                Reconcile:=0;
                Qty:=1;
                LiveUplift:=BOff;
              end
              else}
              Begin
                LiveUplift:=BOn;

                NetValue:=NetValue*DocNotCnst;
              end;
            end
            else
              If ((Reconcile=2) and (LInv.TransMode>=2) and (LInv.TransMode=COSNomCode)) then {* break link on practical as we do not want it to be cumulative *}
              Begin
                {If (InvDocHed In JAPJAPSplit) and (JABMode(LInv)=0) then
                Begin
                  LiveUplift:=BOn;
                  IntReverse:=BOn;
                  NetValue:=Round_Up(CalcJAPRetTotals(JCRec.awDoc,LId,ExLocal,Reconcile,JAiMode(LInv)),2); {*En560. Need to pass in correct imode *}
                {end;}
              end;
              

            If (LInv.TransMode=0) or (Not Have_YTDLink) or (IdDocHed=JCT) or ((IntReverse) and (Not (InvDocHed In JAPJAPSplit))) then {* Its stand alone so do not bring in any YTD totals, or link back to parent *}
            Begin
              QtyDel:=0.0;
              QtyPWOff:=0.0;

            end;

            If (Reconcile=2) and (Round(SSDSPUnit) In [0,1]) then
              JAPCalc_RetDate(ExLocal);

            Case awCopyBudget of
              1  :  CostPrice:=CopyId.CostPrice-CopyId.QtyDel;
              2  :  CostPrice:=CopyId.CostPrice-CopyId.QtyPWOff;
              3  :  ;{Leave cost price as is}
              else  CostPrice:=0.0;
            end; {Case..}

            If (Reconcile=0) and ((JCRec.awJSAFromVal) and (JCRec.awDT In [JSA])) then
              Link_JSAtoVal(ExLocal,0);

            If (CostPrice<>0.0) or (NetValue<>0.0) or (awCopyBudget=0) or (awIntReverse) then
            Begin

              If (NetValue<>0.0) or (CostPrice<>0.0) then
              Begin
                Calc_AppVAT(ExLocal);

                If (NetValue<>0.0) then
                  Update_JAPDeductLine(LId,LInv,0);

              end
              else
                VAT:=0.0;

              If (Not awIntReverse) then
                awIntReverse:=IntReverse;

              ExStatus:=Add_Rec(F[Fnum2],Fnum2,LRecPtr[Fnum2]^,Keypath2);

              Report_Berror(Fnum2,ExStatus);

              If (CostPrice<>0.0) and (ExStatus=0) and (IdDocHed In JAPOrdSplit) then
                Update_JobAct(LId,LInv);

              If ((CostPrice<>0.0) or (NetValue<>0.0)) and (SOPLink<>0) then
                Update_JTLink(LId,LInv,BOff,BOn,Fnum2,IdLinkK,Keypath2,0);
            end;

            LSetDataRecOfs(Fnum2,RecAddr);

            If (RecAddr<>0) then
              ExStatus:=GetDirect(F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,0);


          end; {If..}


          ExStatus:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS);

        end; {With..}
      end {If based on a copy..}
      else
        If ((JCRec.awJSTFromBudget) and (JCRec.awDT In [JPT,JST])) or ((JCRec.awJSAFromVal) and (JCRec.awDT In [JSA])) then {*Create using revenue budgets*}
          Create_JSTLinesFromJobBudget(JcRec,ExLocal,0);



      {* Store header *}

      ExStatus:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

      Result:=(ExStatus=0);

      Report_BError(Fnum,ExStatus);

      If (Result) and ((JCRec.awCopyBudget>0) or (JCRec.awIntReverse)  or (JCRec.awJSTFromBudget) or (JCRec.awJSAFromVal)) then {Its starting life with a value}
      Begin
        CalcJAPVATTotals(LInv,ExLocal,BOn,3);

        ExStatus:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

        Result:=(ExStatus=0);

        Report_BError(Fnum,ExStatus);

        With LInv do
          If (NomAuto) and (InvDocHed In JAPOrdSplit)  and ((InvDocHed<>JST) or EmptyKey(LInv.DeliverRef,DocKeyLen)) then {* Update customer comitted value *}
            UpdateCustAppBal(BlankInv,LInv);

      end;

      If (Result) and (JMode=0) then {* Store matching information *}
      Begin
        If (JCRec.awDoc.OurRef<>'') then
        Begin
          With LInv do
          Begin
            RemitNo:=JCRec.awDoc.OurRef;

            Match_Payment(LInv,Round_Up(Conv_TCurr(TotalCost,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2)
                      ,TotalCost,23);
            RemitNo:='';
          end;

          With JCRec.awDoc do
          Begin
            RemitNo:=LInv.OurRef;

            MatchVal:=Round_Up(Conv_TCurr(LInv.TotalCost,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);

            Currency:=LInv.Currency;

            Match_Payment(JCRec.awDoc,MatchVal,LInv.TotalCost,23);

            RemitNo:='';
          end;

          {*  v5.70 ENJACERTFIX *} {Update series counter, and preserve posn}
          NewInv:=LInv;

          KeyI:=JCRec.awDoc.OurRef;

          ExStatus:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyI);

          If (ExStatus=0) then
          Begin
            LInv.NoLabels:=(JCRec.awSeries+1);

            ExStatus:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

            Result:=(ExStatus=0);

            Report_BError(Fnum,ExStatus);

          end;

          LInv:=NewInv;
        end;
      end;


    end; {With..}

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

  end;

{
  Searches for and returns the original Job Terms transaction line that the
  supplied transaction line was generated from. Returns an empty record if
  the original line cannot be found, or if the supplied line has no link.
}
Function Get_JTLink(Idr: IDetail; Fnum, Keypath, KeyResP: Integer): IDetail;
Var
  LAddr,
  RecAddr  :  LongInt;
  TmpId    :  ^IDetail;
  KeyS,
  KeyChk   :  Str255;
  FoundOk  :  Boolean;
Begin
  FoundOk := BOff;
  RecAddr := 0;

  Blank(Result,Sizeof(Result));

  // Application lines are linked to the originating Job Terms via the SOPLink
  // and SOPLineNo fields, where the SOPLink holds the Folio Ref of the Job
  // Terms header
  If (IdR.SOPLink <> 0) then
  Begin
    // Store the current record position
    New(TmpId);
    TmpId^:=Id;
    Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Preserve DocPosn *}

    // Search for the matching Job Terms line
    KeyChk := FullIdKey(IdR.SOPLink, IdR.SOPLineNo);
    KeyS   := KeyChk;
    Status := Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    If (StatusOk) then
    Begin
      // Convert the currency on the Job Terms line to match with the
      // currency of the current application line
      Result := Curr_ConvertJAPId(Id, IdR.Currency, IdR.CXRate, 0);
    end; {If Line Matched}

    // Restore the original record position
    SetDataRecOfs(Fnum,RecAddr);

    If (RecAddr <> 0) then
      Status := GetDirect(F[Fnum], Fnum, RecPtr[Fnum]^, KeyResP, 0);

    Id := TmpId^;
    Dispose(TmpId);

  end; {If Linked Line}

end; {Proc..}


  { == Function to calculate total valuation about to be generated == }

  Function Calc_ValuationValue(JcRec      :  tJAppWizRec;
                           Var ExLocal    :  TdExLocal)  :  Double;

  Const
    Fnum      =  JCtrlF;
    Keypath   =  JCK;

    Fnum2     =  IDetailF;
    Keypath2  =  IdFolioK;

    Fnum3     =  JobF;
    Keypath3  =  JobCatK;

  Var
    KeyS,
    KeyChk    :  Str255;

    ExStatus  :  Integer;

    TmpStat,
    TmpKPath  :  Integer;


  Begin
    Result:=0.0;

    With ExLocal,JCRec do
    Begin
      If (awJobCode<>'') then
      Begin
        If (LJobRec^.JobCode<>awJobCode) then
        Begin
          KeyS:=FullJobCode(awJobcode);

          ExStatus:=Find_Rec(B_GetEq,F[Fnum3],Fnum3,LRecPtr[Fnum3]^,JobCodeK,KeyS);

        end
        else
          ExStatus:=0;

        If (ExStatus=0) then
        Begin
          If (awjctRef='') then {Base it on pure lines}
          Begin
            awValuation:=0.0;

            LInv.Currency:=awPCurr;

            Create_JSTLinesFromJobBudget(JcRec,ExLocal,1);

            Result:=awValuation;
          end
          else
          Begin
            LInv:=awDoc;

            LInv.Currency:=awPCurr;

            KeyChk:=FullNomKey(JCRec.awDoc.FolioNum);

            KeyS:=FullIdKey(JCRec.awDoc.FolioNum,1);

            ExStatus:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS);

            While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
            With LId do
            Begin
              Currency:=awPCurr;

              Link_JSAtoVal(ExLocal,1);

              Result:=Result+Round_Up(CostPrice,2);

              ExStatus:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS);

            end; {While..}

          end;
        end;
      end;{If..}
    end; {with..}
  end; {Func..}


{*  v5.70 ENJACERTFIX *}
{ == Proc to find other lines and accumulate current live certifed status to compare against stored YTD == }
{
  Returns the total value of matching lines from previous certified applications
}
Function Check_AnalLines(Var ExLocal    :  TdExLocal;
                             Fnum2,
                             Keypath2   :  Integer;
                             ParentLine :  IDetail;
                             Mode       :  Byte)  :  Double;
Const
  Fnum      =  PWrdF;
Var
  ExStatus,
  Keypath   :  Integer;
  TmpRecAddr
            :  LongInt;
  TmpKPath,
  TmpStat   :  Integer;
  KeyS,KeyChk,
  GenStr,
  KeyId,
  KeyI      :  Str255;
  ParentInv,
  TmpInv    :  InvRec;
  TmpId     :  IDetail;
Begin
  Result:=0.0; ExStatus:=0;

  Blank(ParentInv,Sizeof(ParentInv));

  // Locate the transaction header for the supplied line
  KeyI := ParentLine.DocPRef;

  TmpInv := ExLocal.LInv;

  ExStatus := Find_Rec(B_GetEq,F[InvF],InvF,ExLocal.LRecPtr[InvF]^,InvOurRefK,KeyI);

  If (ExStatus=0) then
  With ExLocal,ParentInv do
  Begin
    // Save the current line position
    TmpId := LId;

    ParentInv:=LInv;

    TmpKPath:=IdFolioK;

    TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOff,BOff);

    If ((RemitNo<>'') or (OrdMatch)) then
      Keypath:=PWK
    else
      Keypath:=HelpNDXK;

    // Search for the match record (prefix of 'TP')
    KeyChk := FullMatchKey(MatchTCode,MatchSCode,ParentLine.DocPRef);
    KeyS   := KeyChk;

    ExStatus := Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
    With LPassword.MatchPayRec do
    Begin
      Case Keypath of
        PWK       :  Begin
                       KeyI:=PayRef;
                     end;
        HelpNdxK  :  Begin
                       KeyI:=DocCode;
                     end;
      end; {Case..}

      // Assuming that we haven't simply found the current transaction...
      If (KeyI<>ParentLine.DocPRef) then
      Begin
        // ...locate the transaction header
        ExStatus:=Find_Rec(B_GetEq,F[InvF],InvF,LRecPtr[InvF]^,InvOurRefK,KeyI);

        // Only include certified applications
        If (ExStatus=0) and (LInv.PDiscTaken) then
        With LId do
        Begin
          // Find the line that matches the line of the current transaction
          KeyID:=FullIdKey(LInv.FolioNum,ParentLine.ABSLineNo);

          ExStatus:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyId);

          {$B-}
          // Check that this really is the right line and that it is certified
          If (ExStatus=0) and (SOPLink=ParentLine.FolioRef) and (CheckKey(ParentLine.AnalCode,AnalCode,Length(ParentLine.AnalCode),BOff)) and  (SSDUseLine) then
            // Add the retention amount
            Result:=Result+NetValue;
          {$B+}
        end;
      end;

      ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    end;

    // Restore the original line position
    TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOn,BOff);

    LId:=TmpId;

  end; {If Ex OK }

  ExLocal.LInv:=TmpInv;

end;


Function CheckUpdate_CertYTD(Var ExLocal    :  TdExLocal;
                                 Fnum,
                                 Keypath    :  Integer;
                                 Mode       :  Byte)  :  Boolean;
Var
  ExStatus:  Integer;

  CompD,
  DiffD   :  Double;

  KeyS,
  KeyChk  :  Str255;

  CopyId,
  TmpId,
  ParentId:  IDetail;

Begin
  Result:=BOn; ExStatus:=0;  CompD:=0.0;  DiffD:=0.0;

  With ExLocal do {* Only re check actual Standalone or interim applications and those with gross types which need the cumulative values *}
  If (LInv.InvDocHed In JAPJAPSplit) and (LInv.TransNat>0) and (LInv.TransMode<2) then
  Begin
    TmpId:=LId;

    // Locate all the lines on this application, from Retentions lines (line
    // number = -3) onwards
    KeyChk   := FullNomKey(LInv.FolioNum);
    KeyS     := FullIdKey(LInv.FolioNum,JALRetLineNo);
    ExStatus := Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);
    While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Result) {and (LId.LineNo<0)} do
    With LId do
    Begin
      {$B-}
      If {(Reconcile>0) and} (Not LiveUplift) and (AutoLineType=0) and (Not JA_PractRetLine(LInv,LId)) then {* Ignore practical retention lines & CIS manufactured lines *}
      {$B+}
      Begin
        CopyId:=LId;

        // Locate the originating Terms line that this line was generated from
        ParentId:=Get_JTLink(LId,Fnum,IdLinkK,Keypath);

        If (ParentId.FolioRef=SOPLink) and (SOPLink<>0) then
        Begin
          If (Reconcile>0) then
            // Retention or deduction line, read YTD Certified amount from
            // the Terms line
            CompD:=ParentID.QtyPWoFF
          else
            // For normal lines, recalculate the YTD Certified amount from
            // previous applications
            CompD:=Check_AnalLines(ExLocal,Fnum,IdLinkK,ParentId,0);

          Result:=(Round_Up(QtyPWoff,Syss.NoCosDec)=Round_Up(CompD,Syss.NoCosDec));

          Case Mode of
            // Mode 1 - attempt to correct the current values by recalculating
            // them from the previous values
            1  :  If (Not Result) then
                  Begin
                    // Set the cumulative amount, using the amount that has just
                    // been recalculated
                    QtyPWoff:=CompD;

                    // Store the difference between the recorded cumulative
                    // amount and the recalculated amount
                    DiffD:=CopyId.QtyPWOff-QtyPWOff;

                    Case Reconcile of {* Header total adjustment superfluous as CalcJAPVAT recalcualtes them anyway *}
                      0  :  Begin
                              If (LInv.TransNat=2) then {* Recalc incremental from prev gross *}
                               NetValue:=Round_Up(NetValue+DiffD,2);

                              LInv.TotalOrdered:=Round_Up(LInv.TotalOrdered+DiffD,2);
                            end;

                      1  :  LInv.PostDiscAM:=Round_Up(LInv.PostDiscAm+DiffD,2);

                      2  :  LInv.TotOrdOS:=Round_Up(LInv.TotOrdOS+DiffD,2);

                    end; {Case..}

                    ExStatus:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath);

                    Report_Berror(Fnum,ExStatus);

                    Result:=(ExStatus=0);

                    If (Result) and (Reconcile=0) then
                    Begin
                      Update_JTLink(CopyId,LInv,BOn,BOn,Fnum,IdLinkK,Keypath,0);

                      Update_JTLink(LId,LInv,BOff,BOn,Fnum,IdLinkK,Keypath,0);
                    end;

                  end;
          end; {Case..}

        end;
      end;

      If (Result) then
        ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);


    end; {While..}

    LId:=TmpId;
  end; {With..}
end;




{$ENDIF} // EXDLL
{$ENDIF}

Begin

end.