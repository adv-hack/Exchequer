unit Report9U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU;


type



  TCVATReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                     private

                       Procedure PrintVATTot(Gtot      :  Boolean);

                       Procedure Set_VATTotals(InvR      :   InvRec);

                       Function Out_OfPr(InvR      :   InvRec)  :  Boolean;

                       Procedure CalcVATTotals(CrDr      :  DrCrType);

                       Function GetReportInput  :  Boolean; Virtual;

                     public

                       CRepParam  :  CVATRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddCVATRep2Thread(LMode    :  Byte;
                            IRepParam:  CVATRepPtr;
                            AOwner   :  TObject);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  Printers,
  ETDateU,
  ETStrU,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,
  MiscU,
  {DocSupU1,}
  SalTxl1U,

  {$IFDEF VAT}
    SetVatU,
  {$ENDIF}
  RpDefine,
  IntMU,
  ExThrd2U;




{ ========== TCVATReport methods =========== }

Constructor TCVATReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);
end;


Destructor TCVATReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;




Procedure TCVATReport.Process;

Begin
  Inherited Process;
end;



Procedure TCVATReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    Case ReportMode of

        2:
           Begin
              SetTab (MarginLeft, pjLeft, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 15, 4, 0, 0);
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 15, 4, 0, 0);
              SetTab (NA, pjRight,29, 4, 0, 0);
              SetTab (NA, pjRight,29, 4, 0, 0);
              SetTab (NA, pjRight,29, 4, 0, 0);
            end;

    end; {Case..}
  end; {With..}

  SetTabCount;
end;


Procedure TCVATReport.RepPrintPageHeader;

Var
  GenStr  :  Str255;
  n       :  VATType;

Begin

  With RepFiler1,CRepParam^ do
  Begin
    DefFont(0,[fsBold]);

    Case ReportMode of


      2  :

            Begin

              SendLine(ConCat(#9,'Our Ref',#9,'Ac No.',#9,'Date Paid',#9,'Per Yr',#9,'Payment',#9,'Receipt'));
            end;


    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}


{ ======================= Due Sub / Grand Total ================ }

Procedure TCVATReport.PrintVATTot(Gtot      :  Boolean);

Var
  Rnum  :  Double;

Begin


  With CRepParam^ do
    With RepFiler1 do
    Case ReportMode of
      2
         :  Begin
              DefFont(0,[fsBold]);

              Rnum:=RepTotals[BOff]-RepTotals[BOn];

              SendLine(ConCat(ConstStr(#9,4),'Totals: ',
                       #9,FormatBFloat(GenRealMask,RepTotals[BOff],BOn),
                       #9,FormatBFloat(GenRealMask,RepTotals[BOn],BOn),
                       #9,FormatBFloat(GenRealMask,Rnum,BOff)));

              DefFont(0,[]);
            end; {Case..}

    end; {Case..With..}

end;



{ ============= Calculate Line Totals depending on VAT Scheme ============== }

Procedure TCVATReport.Set_VATTotals(InvR      :   InvRec);



Begin
  With MTExLocal^,CRepParam^ do
    With InvR do
    Begin

      {$IFDEF VAT}
        Calc_ThisVATRet(InvR,GoodsTot,VATTot);
      {$ENDIF}

      {* Convert from Base to System VAT Currency *}

      GoodsTot:=Round_Up(Conv_VATCurr(GoodsTot,InvR.VATCRate[UseCoDayRate],1.0,0,InvR.UseORate),2);

      VATTot:=Round_Up(Conv_VATCurr(VATTot,InvR.VATCRate[BOn],1.0,0,InvR.UseORate),2);

    end; {With..}
end; {PRoc..}



{ ============= Check for Out of Period by Scheme ============== }

Function TCVATReport.Out_OfPr(InvR      :   InvRec)  :  Boolean;


Begin

  With CRepParam^ do
    With InvR do
    Begin
      Out_OfPr:=(ABS(Settled)<ABS(SettledVAT));
    end; {Withs..}

end; {Func..}



{ ======================= Calculate Due Totals ==================== }

Procedure TCVATReport.CalcVATTotals(CrDr      :  DrCrType);


Var
  TBo        :  Boolean;

Begin

  With MTExLocal^,CRepParam^ do
    Case ReportMode of
      2
         :  With LInv do
            Begin
              For TBo:=BOff to BOn do
                RepTotals[Tbo]:=RepTotals[TBo]+CrDr[Tbo];

            end;



    end; {Case..With..}
end;

Procedure TCVATReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    Case ReportMode of
      2  :  Begin
              SendRepDrillDown(1,TotTabs,1,LInv.OurRef,InvF,InvOurRefK,0);
              SendRepDrillDown(2,2,2,LInv.CustCode,CustF,CustCodeK,0);
            end;

    end; {Case..}
  end; {With..}
end;


Procedure TCVATReport.PrintReportLine;


Var
  CrDr       :  DrCrType;

  Rnum       :  Real;

  TBo        :  Boolean;

  GenStr     :  Str255;


Begin

  GenStr:='';


  With RepFiler1,MTExLocal^,CRepParam^ do
  Begin


    Set_VATTotals(LInv);

    SetReportDrillDown(0);

    Case ReportMode of
      2
         :  With LInv do
            Begin
              Blank(CrDr,SizeOf(CrDr));

              If (InvDocHed In DirectSet+ NomSplit ) then  {* Give opposite view *}
              Begin

                GoodsTot:=GoodsTot*DocNotCnst;

                VATTot:=VATTot*DocNotCnst;

              end;

              ShowDrCr(GoodsTot+VATTot,CrDr);

              GenStr:=PoutDateB(UntilDate);

              If (Out_OfPr(LInv)) then
                GenStr:=GenStr+'*';


                {* Note Use of PPr_Pr/Yr *}

              SendLine(ConCat(#9,OurRef,
                       #9,CustCode,
                       #9,GenStr,
                       #9,PPR_OutPr(ACPr,ACYr),
                       #9,FormatBFloat(GenRealMask,CrDr[BOff],BOn),
                       #9,FormatBFloat(GenRealMask,CrDr[BOn],BOn)));

            end;

    end; {Case..}

    CalcVATTotals(CrDr);

  end; {With(s)..}
end;




{ ======================= VAT End ======================= }


Procedure TCVATReport.PrintEndPage;

Var
  TmpRepMode  :  Integer;

Begin
  With RepFiler1,CRepParam^ do
  Begin

    If (ReportMode In [2]) then
    Begin
      DefLine(-1,1,PageWidth-MarginRight-1,-0.5);

      PrintVATTot(BOff);
    end;

    Inherited PrintEndPage;

  end; {With..}
end;


{ ======================= VAT Include ======================= }


Function TCVATReport.IncludeRecord :  Boolean;

Var
  TmpInclude :  Boolean;


Begin

  {$B-}

  With MTExLocal^,CRepParam^ do
  Begin
    Case ReportMode of
      2
           :  With LInv do
              Begin

                TmpInclude:=(((VATPostDate<=VATEndd) and (VATPostDate>=VATStartD))
                         and (InvDocHed In RecieptSet+DirectSet+ NomSplit ));

                If (TmpInclude) and (ReportMode=2) then {* Exclude any docs which have just been
                                                           Unallocated then re-allocated again *}
                Begin

                  Set_VATTotals(LInv);

                  TmpInclude:=((GoodsTot<>0) or (VATTot<>0));

                end;

                If (VATPostDate>VATEndd) then

                Begin
                  KeyS:=NdxWeight;

                  B_Next:=B_GetGEq;
                end;
              end;
           else  //PR: 22/03/2016 v2016 R2 ABSEXCH-17390
             raise Exception.Create('Invalid ReportMode in TCVATReport.IncludeRecord: ' + IntToStr(ReportMode));

    end; {Case..}
  end; {With..}

    {$B+}

  Result:=TmpInclude;
end; {Func..}



Function TCVATReport.GetReportInput  :  Boolean;


Begin
  With CRepParam^ do
  Begin

    ThTitle:='Cash '+CCVATName^+' Return';


    
    ROrient:=RPDefine.PoPortrait;

    RFnum:=InvF;

    RKeyPath:=InvVATK;

    If (CurrentCountry<>IECCode) then
    Begin
      RepKey:=VATEndd;
      RepTitle:='Cash Accounting - ('+GetIntMsg(2)+' for '+Form_Int(VPr,2)+'/'+FullYear(VYr)+'), Payment & Receipt Report';
    end
    else
    Begin
      RepKey:=VATStartd;
      {RepTitle:='Cash Accounting - '+GetIntMsg(2)+' for '+Form_Int(VPr,2)+'/'+FullYear(VYr);}

      RepLen:=256;

      RepTitle:='Cash Accounting - ('+GetIntMsg(2)+' for '+Form_Int(VSPr,2)+'/'+FullYear(VSYr)+' - '+
               Form_Int(VPr,2)+'/'+FullYear(VYr)+'), Payment & Receipt Report'

    end;


    PageTitle:=RepTitle;

  end; {With..}

  Result:=BOn;
end;





Procedure TCVATReport.Finish;


Begin

  Inherited Finish;

  With RepFiler1 do
  Begin
    Orientation:=poLandscape;
  end;
  
  RFont.Size:=RFont.Size-1;

  ROrient:=RPDefine.PoLandscape;
end;


{ ======== }




Procedure AddCVATRep2Thread(LMode    :  Byte;
                            IRepParam:  CVATRepPtr;
                            AOwner   :  TObject);


Var
  EntTest  :  ^TCVATReport;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        ReportMode:=LMode;

        If (Assigned(IRepParam)) then
        Begin
          CRepParam^:=IRepParam^;

          NoDeviceP:=BOn;

          If (Assigned(IRepParam)) then
          Begin
            CRepParam^:=IRepParam^;

            If (NoDeviceP) then
            With CRepParam^.PParam do
            Begin
              RDevRec:=PDevRec;
            end;
          end;

        end;

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