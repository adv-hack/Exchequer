Unit Gstcalcu;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 02/07/97                      }
{                                                              }
{                    External Tax Calculator                   }
{                                                              }
{**************************************************************}


Interface

Uses CustAbsU;

  Procedure CalcTAX(Const EventData : TAbsEnterpriseSystem);

  Procedure Calc500TAX(Const EventData : TAbsEnterpriseSystem);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  SysUtils,Dialogs;


{* v5.50 Work out the tax for the current line, take into account any settlement discount *}

Procedure CalcTAX(Const EventData : TAbsEnterpriseSystem);

  Var
    TAXRateLine,
    TAXRateStd,
    OrigValue,
    VATUAMnt,
    VATUDiff,
    LineDiscount,
    NewNetValue,
    NewTotal,

    SetlDisc    :  Double;

    UseDecs     :  Byte;


  Begin
    NewTotal:=0.0;

    {* Using the data pased by the event object, specifically, transaction header, and current line, and set up information *}
    With EventData,Transaction,thLines,TABSInvLine2(thCurrentLine), SetUp do
    Begin
      {* Get local instances of Standard, and Line Tax Rates *}
      TAXRateLine:=entRound(ssVATRates[entGetTAXNo(tlVATCode)].svRate,10);
      TAXRateStd:=entRound(ssVATRates[CuStandard].svRate,10);

      {* If it is a sales transaction set rounding according to no. of dec places *}

      If (tlDocType In [cuSIN..cuSDG]) then  {* No Dec places determines rounding effect on Purch/Sales *}
        UseDecs:=ssNoNetDec
      else
        UseDecs:=ssNoCosDec;

      SetlDisc:=0.0;  // For Singapore & NZ VAT remains unchanged? thDiscSetl*Ord(thDiscTaken); {* Pick up transaction settlement discount *}

      VATUAmnt:=0.0;  VATUDiff:=0.0;

      Case tlVATCode of
        {* Work out straight VAT from line total *}
        'S','Z','E','1'..'9','A','D','T','X'
            :  Begin
                 VATUAmnt:=tlVATamount;
                 VATUAmnt:=entRound((entInvLTotal(True,SetlDisc)*TaxRateLine),2);;
                 tlVATAmount:=VATUAmnt;
                 tlVATInclValue:=0.0;
               end;


        {* If inclusive then calculate accordingly *}
        {* Adjust Code to M, and back calculate net value *}
        'I','M'
            :  Begin

                 If (tlVATInclValue=0.0) or (tlVATCode='I') then  {* First time round if a % discount is present, we cannot include
                                                               settlement discount. We would reply on a second call to this
                                                               with Vat code set to M *}
                   LineDiscount:=entCalc_PcntPcnt(tlNetValue,tlDiscount,SetlDisc*Ord(tlDiscFlag<>'%'),tlDiscFlag,'%')
                 else
                   LineDiscount:=entCalc_PcntPcnt(tlVATInclValue,tlDiscount,SetlDisc,tlDiscFlag,'%');


                 If (tlVATCode='M') then
                 Begin
                   If (tlVATInclValue=0.0) then
                   Begin
                     If (tlQty<>1.0) then
                       tlNetValue:=((tlNetValue-LineDiscount)*(TaxRateStd+1))+LineDiscount
                     else
                       tlNetValue:=(entRound(tlNetValue,UseDecs)+tlVATAmount);
                   end
                   else
                     tlNetValue:=tlVATInclValue;
                 end
                 else
                 Begin
                   tlVATInclValue:=tlNetValue;
                 end;


                 OrigValue:=entRound(tlNetValue,UseDecs)-
			    entRound(LineDiscount,2);


                 VATUAMnt:=entRound(((OrigValue*TaxRateStd)/
                                 (TaxRateStd+1)),2);

                NewTotal:=(tlNetValue-LineDiscount);

                tlNetValue:=tlNetValue-((NewTotal*TaxRateStd)/(TaxRateStd+1));


                tlVATAmount:=entRound(VATUAmnt*tlQty,2);


                VATUAmnt:=entRound(OrigValue*tlQty,2);

                NewTotal:=(entRound((entRound(tlNetValue,UseDecs)-
			    entRound(LineDiscount,2))*tlQty,2)+tlVATAmount);

                VATUDiff:=entRound(VATUAmnt-NewTotal,2);


                tlVATAmount:=tlVATAmount+VATUDiff;


                 //ShowMessage(Format('VAT Amount is %10.2f : Vat Diff is %10.2f',[VATUAMnt,VATUDiff]));



                 tlVATCode:='M';
               end;

      end; {case..}

    end; {With..}

  end; {Proc..}

  {* v5.00 or below Work out the tax for the current line, take into account any settlement discount *}

  Procedure Calc500TAX(Const EventData : TAbsEnterpriseSystem);


  Var
    TAXRateLine,
    TAXRateStd,
    OrigValue,
    VATUAMnt,
    VATUDiff,
    SetlDisc    :  Double;

    UseDecs     :  Byte;


  Begin
    {* Using the data pased by the event object, specifically, transaction header, and current line, and set up information *}
    With EventData,Transaction,thLines,thCurrentLine, SetUp do
    Begin
      {* Get local instances of Standard, and Line Tax Rates *}
      TAXRateLine:=entRound(ssVATRates[entGetTAXNo(tlVATCode)].svRate,10);
      TAXRateStd:=entRound(ssVATRates[CuStandard].svRate,10);

      {* If it is a sales transaction set rounding according to no. of dec places *}

      If (tlDocType In [cuSIN..cuSDG]) then  {* No Dec places determines rounding effect on Purch/Sales *}
        UseDecs:=ssNoNetDec
      else
        UseDecs:=ssNoCosDec;

      SetlDisc:=0.0;  // For Singapore & NZ VAT remains unchanged? thDiscSetl*Ord(thDiscTaken); {* Pick up transaction settlement discount *}

      VATUAmnt:=0.0;  VATUDiff:=0.0;

      Case tlVATCode of
        {* Work out straight VAT from line total *}
        'S','Z','E','1'..'9','A','D','T','X'
            :  Begin
                 VATUAmnt:=tlVATamount;
                 VATUAmnt:=entRound((entInvLTotal(True,SetlDisc)*TaxRateLine),2);;
                 tlVATAmount:=VATUAmnt;
               end;


        {* If inclusive then calculate accordingly *}
        {* Adjust Code to M, and back calculate net value *}
        'I','M'
            :  Begin

                 If (tlVATCode='M') then
                   tlNetValue:=tlNetValue*(TaxRateStd+1);


	         OrigValue:=entRound(tlNetValue,UseDecs)-
			    entRound(entCalc_PcntPcnt(tlNetValue,tlDiscount,SetlDisc,tlDiscFlag,'%'),2);

                 tlNetValue:=tlNetValue-((tlNetValue*TaxRateStd)/
                                     (TaxRateStd+1));


                 VATUAMnt:=entRound(((OrigValue*TaxRateStd)/
                                 (TaxRateStd+1)),2);

                 tlVATAmount:=entRound(VATUAmnt*tlQty,2);


                 VATUAmnt:=EntRound(OrigValue*tlQty,2);


                 VATUDiff:=EntRound(VATUAmnt-(EntRound(EntRound(tlNetValue,UseDecs)*tlQty,2)+tlVATAmount),2);

                 //ShowMessage(Format('VAT Amount is %10.2f : Vat Diff is %10.2f',[VATUAMnt,VATUDiff]));

                 tlVATAmount:=tlVATAmount+VATUDiff;



                 tlVATCode:='M';
               end;

      end; {case..}

    end; {With..}

  end; {Proc..}






Initialization

end. {Unit..}