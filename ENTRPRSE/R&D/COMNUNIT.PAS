Unit ComnUnit;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 01/08/90                      }
{                                                              }
{                    Common Non-Overlaid Unit                  }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}


Interface

Uses GlobVar,
     VarConst;



Function Pr2Mnth(Pr  :  Byte)  :  Byte;

Function Mnth2Pr(Mnth  :  Byte)  :  Byte;


Procedure AdjPr(Var PYr,PPr  :  Byte;
                    ID       :  Boolean);

Procedure SimpleDate2Pr(CDate  :  LongDate;
                    Var PPr,PYr:  Byte);

Function SimplePr2Date(PPr,PYr  :  Byte)  :  LongDate;

Function VAT_CashAcc(SCH  :  Char)  :  Boolean;


Function BeenPurge(Mode   :  SmallInt)  :  Boolean;

Function AfterPurge(PYr,
                    Mode   :  SmallInt)  :  Boolean;

Function AfterLastAudit(PDate  :  LongDate;
                        Mode   :  SmallInt)  :  Boolean;

Function Calc_IdQty(Q,QM  :  Double;
                    UP    :  Boolean)  :  Double;

Function Calc_StkCP(Q,QM  :  Double;
                    UP    :  Boolean)  :  Double;



Function ITotal(IRec  :  InvRec)  :  Real;

Function WORTotal(IRec  :  InvRec)  :  Double;

Procedure ShowDrCr(    Amount  :  Real;
                   Var DrCr    :  DrCrType);

Procedure ShowDrCrD(    Amount  :  Double;
                    Var DrCr    :  DrCrDType);

{$IFDEF SOP}
   Function UseEMlocStk  :  Boolean;
{$ENDIF}

Function Check_MDCCC(CtrlNom  :  LongInt)  :  LongInt;

Function GetReconcileStatus(RStat  :  Byte)  :  Str20;

Function GetPayInStatus(RStat  :  Byte)  :  Str20;

Function Check_AutoPrint (ARec  :  InvRec) :  Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses ETStrU,
     ETDateU,
     ETMiscU,
     BtrvU2;


{ =========== Check if Document is in Auto Print list ============ }

// PS 19/05/2016 2016-R2 ABSEXCH-17476: Function to validate Document is in Auto print list

Function Check_AutoPrint (ARec  :  InvRec) :  Boolean;   {* Auto print *}
Begin
  Result:=(ARec.InvDocHed In AutoPrnSet) or ((ARec.InvDocHed In [SRC]) and (Syss.PrintReciept));
end;

{ =========== Calculate Mnth from Period No. ============ }

Function Pr2Mnth(Pr  :  Byte)  :  Byte;

Var
  TPr  :  Integer;

Begin
  If (Pr>0) then
    Tpr:=Pred(Pr)+Part_Date('M',Syss.MonWk1)
  else
    TPr:=0;

  If (TPr>12) then
    TPr:=(Tpr-12);

  If (TPr>12) then {** Not Monthly Periods! **}
    TPr:=0;

  Pr2Mnth:=TPr;
end;



{ =========== Calculate Period from Month ============== }

Function Mnth2Pr(Mnth  :  Byte)  :  Byte;

Var
  Tpr  :  Integer;

Begin
  Tpr:=Succ((Mnth-Part_Date('M',Syss.MonWk1)));

  If (Tpr<1) then
    Mnth2Pr:=(Tpr+12)
  else
    Mnth2Pr:=Tpr;
end;


{ ========= Procecdure to Inc/Dec Pr  ======== }

Procedure AdjPr(Var PYr,PPr  :  Byte;
                    ID       :  Boolean);

Begin
  If (ID) then
    If (PPr=Syss.PrInYr) then
    Begin
      Pyr:=AdjYr(PYr,BOn);
      PPr:=1;
    end
    else
      Inc(PPr)
  else
    If (PPr=1) then
    Begin
      Pyr:=AdjYr(PYr,BOff);
      PPr:=Syss.PrInYr;
    end
    else
      Dec(PPr);

end;

Procedure SimpleDate2Pr(CDate  :  LongDate;
                    Var PPr,PYr:  Byte);


Var
  Cm,Cyr,Sm  :  word;

  d1,m1,y1,
  d2,m2,y2   :  Word;

  NoFDays    :  Integer;

  n,
  NoPeriods  :  LongInt;


Begin

  n:=0;

  If (Syss.PrInYr=12)  then
  Begin
    Sm:=Part_Date('M',Syss.MonWk1);

    Cm:=Part_Date('M',CDate);

    CYr:=Part_Date('Y',CDate);

    If (CYr<1900) or (CYr>2050) then
      CYr:=Part_Date('Y',Today)-1900
    else
      CYr:=CYr-1900;

    If (Cm-Sm<0) then
      CYr:=AdjYr(CYr,BOff);

    PPR:=Mnth2Pr(Cm);

    PYr:=CYr;
  end
  else
  Begin
    NofDays:=0;

    If (Syss.PrInYr<52) then {* assume still monthly periods *}
    Begin

      NoPeriods:=MonthDiff(Syss.MonWk1,CDate);
    end
    else
    Begin {* assume Weekly periods *}

      NofDays:=Round(DivWChk(365.5,Syss.PrInYr));

      DateStr(Syss.MonWk1,d1,m1,y1);

      DateStr(CDate,d2,m2,y2);

      NoPeriods:=Round(DivwChk((CalJul(d2,m2,y2)-CalJul(d1,m1,y1)),NofDays));

    end;

    PPr:=1;

    PYr:=Part_Date('Y',Syss.MonWk1)-1900;

    For n:=1 to ABS(NoPeriods) do
      AdjPr(PYr,PPr,(NoPeriods>=0));
  end;


end;

{ =========== Function to Calculate the Date from the period ========= }

Function SimplePr2Date(PPr,PYr  :  Byte)  :  LongDate;


Var
  Cm,Cyr,Sm  :  Integer;
  d1,m1,y1,
  d2,m2,y2   :  Word;

  NoFDays    :  Integer;

  n,
  NoPeriods  :  LongInt;


Begin


  n:=0;

  D2:=0;

  If (Syss.PrInYr=12)  then
  Begin
    Sm:=Part_Date('M',Syss.MonWk1);

    Cm:=Pr2Mnth(PPr);

    If (Cm<Sm) then
      PYr:=AdjYr(PYr,BOn);

    Result:=StrDate(PYr+1900,Cm,01);
  end
  else
  Begin

    NofDays:=Round(DivWChk(365.5,Syss.PrInYr));

    Sm:=Part_Date('Y',Syss.MonWk1)-1900;

    NoPeriods:=Pred(PPr)+((PYr-Sm)*Syss.PrInYr);

    DateStr(Syss.MonWk1,d1,m1,y1);

    If (Syss.PrInYr<52) then {* Still treat monthly *}
    Begin

      Y2:=Y1; M2:=M1; D2:=D1;

      For N:=1 to NoPeriods do
      Begin
        Inc(M2);

        //PR: 22/04/2014 ABSEXCH-15090 Change from M2>12 to cope with different numbers of periods in year
        If (M2 > Syss.PrInYr) then
        Begin
          Inc(Y2);
          M2:=1;
        end;
      end;

    end
    else
    Begin

      JulCal(CalJul(d1,m1,y1)+(NoPeriods*NofDays),D2,M2,Y2);

    end;



    Result:=StrDate(Y2,M2,D2);
  end;


end; {Func..}



{ ================== Procedure to Determine VAT Scheme ================== }

Function VAT_CashAcc(SCH  :  Char)  :  Boolean;

Begin

  VAT_CashAcc:=(SCH=VATSchC);

end;



{ ========= Function to check after purge year ====== }

Function AfterPurge(PYr,
                    Mode   :  SmallInt)  :  Boolean;


Begin
  Result:=(PYr>Syss.AuditYr) or (Syss.AuditYr=0);
end;



Function BeenPurge(Mode   :  SmallInt)  :  Boolean;

Begin
  Result:=(Syss.AuditYr>0);

end;



Function AfterLastAudit(PDate  :  LongDate;
                        Mode   :  SmallInt)  :  Boolean;
Begin
  Result:=(Syss.AuditDate<PDate);

end;


{ =========== Function to Return Qty, or Qty Mul ======== }

Function Calc_IdQty(Q,QM  :  Double;
                    UP    :  Boolean)  :  Double;


Begin

  If (UP) then
    Calc_IdQty:=Q*QM
  else
    Calc_IdQty:=Q;

end; {Func..}


{ =========== Function to Return Unit Cost Price ======== }

Function Calc_StkCP(Q,QM  :  Double;
                    UP    :  Boolean)  :  Double;


Begin

  If (Not UP) then
    Calc_StkCP:=DivWChk(Q,QM)
  else
    Calc_StkCP:=Q;

end; {Func..}

{ =============== Return Invoice Total ============== }

Function ITotal(IRec  :  InvRec)  :  Real;

Begin

  With IRec do
    ITotal:=(InvNetVal+InvVat)-DiscAmount-(DiscSetAm*Ord(DiscTaken));
end;


{ =============== Return WOR Total ============== }

Function WORTotal(IRec  :  InvRec)  :  Double;

Begin

  With IRec do
    Result:=(TotalCost-TotalInvoiced);
end;



{ ============= Procedure to Return debit / Credit ============= }

Procedure ShowDrCr(    Amount  :  Real;
                   Var DrCr    :  DrCrType);


Begin


  Blank(DrCr,SizeOf(DrCr));

  DrCr[(Amount<0)]:=ABS(Amount);
end;


{ ============= Procedure to Return debit / Credit ============= }

Procedure ShowDrCrD(    Amount  :  Double;
                    Var DrCr    :  DrCrDType);


Begin


  Blank(DrCr,SizeOf(DrCr));

  DrCr[(Amount<0)]:=ABS(Amount);
end;


{$IFDEF SOP}
   Function UseEMlocStk  :  Boolean;

    Begin
      With Syss do
        UseEMlocStk:=(UseMLoc or UseLocDel);

    end;

{$ENDIF}

{ == Proc to check if MDC Ctrl code is in fact one of the nominated codes == }

Function Check_MDCCC(CtrlNom  :  LongInt)  :  LongInt;

Begin
  If (CtrlNom=Syss.NomCtrlCodes[Debtors]) or (CtrlNom=Syss.NomCtrlCodes[Creditors]) then
    Check_MDCCC:=0
  else
    Check_MDCCC:=CtrlNom;

end;

{ == Functions to return reconciled and payin status == }

Function GetReconcileStatus(RStat  :  Byte)  :  Str20;

Begin
  If (RStat<=High(ReconStatus)) then
    Result:=ReconStatus[RStat]
  else
    Result:='Error';

end;

Function GetPayInStatus(RStat  :  Byte)  :  Str20;

Begin
  If (RStat<=High(PayInRStatus)) then
    Result:=PayInRStatus[RStat]
  else
    Result:='Error';

end;




end.