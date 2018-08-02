unit CISSup1U;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, Buttons,
  GlobVar,VARRec2U,VarConst,BtrvU2,BTSupU1,BTSupU3, ExWrap1U;


Function CISPrefix  :  Str5;

Function CISCertKey(CCode  :  Str20)  :  Str50;

Procedure SetCISListKeys(CRep      :  CVATRepParam;
                     Var KeyStart,
                         KeyEnd    :  Str255;
                     Var Keypath   :  Integer);

{ == Return Truncated value if Not set to Irish system == }

Function TruncGross(GVal   :  Double)  :  Double;

Function WholeValue(GVal   :  Double)  :  Double;

Function CalcCISJDMaterial(JDR  :  JobDetlRec)  :  Double;

Function ECISType2Voucher(ECS  :  Byte;
                          TV   :  Double;
                          CE   :  Str10)  :  Byte;

Function ECISType2Key(ECS  :  Byte)  :  Char;


Procedure Prime_CISVoucher(Var LJobDetl  :  JobDetlRec;
                               LCust     :  CustRec;
                               LJMisc    :  JobMiscRec;
                               LInv      :  InvRec);

Procedure Update_CISVoucher(Var LJobDetl  :  JobDetlRec;
                            Var LInv      :  InvRec;
                            Var VWorth,
                                MGross,
                                BWorth    :  Double;
                                AMode     :  Byte);


Procedure Update_CISScreenTotals(Var CRep  :  CVATRepParam;
                                     AddRec,
                                     DedRec:  JobDetlRec);
Function ChkVouchers(SDate,EDate  :  LongDate;
                     ChkMode      :  Byte)  :  Boolean;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BTSupU2,
  BTKeys1U,
  BTSFrmU1,
  ComnUnit,
  ComnU2,
  CurrncyU,
  Event1U,
  JChkUseU,
  JobSup1U,
  SysU1,
  SysU2;






{ ======== Function to Create CIS Generic prefix =======}

Function CISPrefix  :  Str5;

Begin

  Result:=PartCCKey(JATCode,JBSCode);

end; {Func..}


{ ======== Function to Create CIS CertNo Key=======}

Function CISCertKey(CCode  :  Str20)  :  Str50;

Begin

  Result:=CISPrefix+FullStockCode(CCode)+ConstStr(#0,10)+ConstStr(NdxWeight,3);

end; {Func..}


Procedure SetCISListKeys(CRep      :  CVATRepParam;
                     Var KeyStart,
                         KeyEnd    :  Str255;
                     Var Keypath   :  Integer);

Begin
  Blank(KeyStart,Sizeof(KeyStart)); Blank(KeyEnd,Sizeof(KeyEnd));

  Keypath:=0;

  With CRep do
  Begin
    Case CISSMode of
      0,1  :  Begin
                If (VSig='') then
                Begin
                  KeyStart:=CISPrefix+VATStartD;
                  KeyEnd:=CISPrefix+VATEndD;

                  Case CISSMode of
                    0  :  Keypath:=JDAnalK;
                    1  :  Keypath:=JDEmpK;
                  end; {Case..}
                end
                else
                Begin
                  KeyStart:=CISPrefix+VSig+VATStartD;
                  KeyEnd:=CISPrefix+VSig+VATEndD;

                  Case CISSMode of
                    0  :  Keypath:=JDLedgerK;
                    1  :  Keypath:=JDLookK;
                  end; {Case..}
                end;
              end; {Case..}
      2   :   Begin
                KeyStart:=CISPrefix+VSig;
                Keypath:=JDStkK;
              end;
    end; {Case..}
  end; {With..}
end;

{ ==== Return Material content from JobCIS Record  == }

Function CalcCISJDMaterial(JDR  :  JobDetlRec)  :  Double;

Begin
  
  With JDR.JobCISV do
  Begin
    If (CISCType=4) then
    Begin

      Result:=ABS(CISvGrossTotal)-ABS(CISTaxableTotal);

      If (CISVGrossTotal<0.0) then
        Result:=Result*DocNotCnst;
    end
    else
      Result:=0.0;

    If (Result<0.0) and (CISVGrossTotal>=0.0) then {We must have content from a CIS holder}
      Result:=0.0;
  end;

end;

{ == Return Truncated value if Not set to Irish system == }

Function TruncGross(GVal   :  Double)  :  Double;
Begin
  If (CurrentCountry<>IECCode) then
    Result:=Trunc(GVal)
  else
    Result:=GVal;

end;


{ == Return Value to nearest whole pound == }
// CJS 2014-02-20 - ABSEXCH-11760 - CIS Return - Cost Of Materials rounding
//
// This function is now obsolete. It was originally used solely by CISVch2U.pas
// and CISXMLTU.pas to calculate the Cost Of Materials value by rounding to the
// nearest pound. This value is now calculated using TruncGross() to round
// down, as per HMRC rules.
Function WholeValue(GVal   :  Double)  :  Double;
Begin
  If (CurrentCountry<>IECCode) then
  Begin
    If (Round_Up(ABS(GVal),2)-Trunc(ABS(GVal))>0.0) then
      Result:=Trunc(GVal)+1
    else
      Result:=Trunc(GVal)
  end
  else
    Result:=GVal;

end;



{ == translate from Employee CIS type to Voucher type == }

Function ECISType2Voucher(ECS  :  Byte;
                          TV   :  Double;
                          CE   :  Str10)  :  Byte;

Begin
  Case ECS of
    1,4  :  Result:=4;
    2,5  :  Result:=5;
    3    :  Result:=6;
    else    Result:=0;
  end; {Case..}

  {If we have tax, but it is not a 4 type, force it to be a 4 so we can declare the tax.
  Status of employee must have changed between voucher runs}
  If (TV<>0.0) and (Result<>4) then {Force a type 4 if tax present}
    Result:=4
  else {If we have an employee code present, force type 5}
    If (Result=0) and (Trim(CE)<>'') then
      Result:=5;
end;


{ == translate from Employee CIS type to Voucher type == }

Function ECISType2Key(ECS  :  Byte)  :  Char;

Begin
  Case ECS of
    4  :  Result:=Chr(25);
    5  :  Result:=Chr(23);
    6  :  Result:=Chr(24);
    else  Result:=C0;
  end; {Case..}
end;



{ == Prime CIS voucher record, excluding CertNo & FolioNo == }

Procedure Prime_CISVoucher(Var LJobDetl  :  JobDetlRec;
                               LCust     :  CustRec;
                               LJMisc    :  JobMiscRec;
                               LInv      :  InvRec);

Begin
  With LJobDetl,JobCISV do
  Begin
    Blank(LJobDetl,Sizeof(LJobDetl));

    RecPfix:=JATCode;
    Subtype:=JBSCode;

    FillChar(NDXFill1,Sizeof(NdxFill1),NdxWeight);

    With LJMisc,EmplRec do
    Begin
      CISCType:=ECISType2Voucher(CISType,LInv.CISTax,LInv.CISEmpl);

      CISHTax:=CISType;

      If (CIS340) then
        CISVNINo:=UTRCode
      else
        CISVNINo:=ENINo;

      CISVerNo:=VerifyNo;

      CISVCert:=CertNo;

      CISAddr:=Addr;

      CISBehalf:=Trim(EmpName);

      {$B-}
      If (CurrentCountry<>IECCode) then
      {$B+}
      Begin
        Case  CISCType of
          4,5
             :  CISBehalf:=Trim(LCust.Company);
          6  :  Begin
                  CISBehalf:=CISBehalf+' acting for '+Trim(LCust.Company);

                  If (Length(UserDef4)>=13) then
                    CISAddr[5]:=UserDef4;
                end;
        end; {Case..}

      end;

    end;


    CISvNLineCount:=1;

    CISCurr:=Syss.VATCurr;
  end; {If New..}
end;


{ == Procedure to update CIS Voucher and Inv == }

Procedure Update_CISVoucher(Var LJobDetl  :  JobDetlRec;
                            Var LInv      :  InvRec;
                            Var VWorth,
                                MGross,
                                BWorth    :  Double;
                                AMode     :  Byte);

Var
  VRatio,
  VOrig,
  VGross,
  CWorth,
  CTax,
  CGross      :  Double;

  DCnst       :  Integer;

Begin
  VRatio:=0.0; VOrig:=0.0;  CTax:=0.0; CGross:=0.0;  CWorth:=0.0;  VGross:=0.0;

  With LInv, LJobDetl.JobCISV do
  Begin
    If (AMode=0) then
    Begin
      VWorth:=0.0;

      VWorth:=(Round_Up(CurrSettled-CISDeclared,2)*DocCnst[InvDocHed]*DocNotCnst);

      CISCorrect:=(VWorth<0.0);
    end;

    If (CISCorrect) then
      DCnst:=-1
    else
      DCnst:=1;

    VOrig:=ITotal(LInv);

      If (CurrentCountry<>IECCode) then
        VGross:=VOrig-InvVAT+CISTax-CISGExclude
      else
        VGross:=VOrig+CISTax-CISGExclude;

    {Convert to VAT Currency using VAT Rates}
    CGross:=Round_Up(Conv_VATCurr(CISGross,VATCrate[UseCoDayRate],XRate(OrigRates,BOff,Currency),Currency,UseORate),2);

    If (CISHolder<>1) or (CISGross=0.0) then {For CIS holders, assume no materials}

    {As timesheets now allow materials, cannot assume no materials!}
      CWorth:=Round_Up(Conv_VATCurr(VGross,VATCrate[UseCoDayRate],XRate(OrigRates,BOff,Currency),Currency,UseORate),2)
    else
      CWorth:=CGross;

    CTax:=Round_Up(Conv_VATCurr(CISTax,VATCrate[BOn],OrigRates[BOn],Currency,UseORate),2);

    If (SettledFullCurr(LInv)) and (AMode=0) then {Work out residiual}
    Begin

      VRatio:=DivWChk(CISDeclared*DocCnst[InvDocHed]*DocNotCnst,VOrig);

      CISvTaxDue:=CISvTaxDue+((CTax-Round_Up(CTax*VRatio,2))*DocCnst[InvDocHed]);
      CISvAutoTotalTax:=CISvAutoTotalTax+((CTax-Round_Up(CTax*VRatio,2))*DocCnst[InvDocHed]);
      CISvGrossTotal:=CISvGrossTotal+((CWorth-Round_Up(CWorth*VRatio,2))*DocCnst[InvDocHed]);
      CISTaxableTotal:=CISTaxableTotal+((CGross-Round_Up(VRatio*CGross,2))*DocCnst[InvDocHed]);

      MGross:=(VWorth-Round_Up(VWorth*VRatio,2))*DCnst;
      BWorth:=(CWorth-Round_Up(CWorth*VRatio,2));

    end
    else
    Begin
      VRatio:=DivWChk(VWorth,VOrig);

      CISvTaxDue:=CISvTaxDue+Round_Up(CTax*VRatio*DocCnst[InvDocHed],2);

      CISvAutoTotalTax:=CISvAutoTotalTax+Round_Up(CTax*VRatio*DocCnst[InvDocHed],2);

      CISvGrossTotal:=CISvGrossTotal+Round_Up(CWorth*VRatio*DocCnst[InvDocHed],2);
      CISTaxableTotal:=CISTaxableTotal+Round_Up(VRatio*CGross*DocCnst[InvDocHed],2);

      MGross:=Round_Up(VWorth*VRatio,2)*DCnst;
      BWorth:=Round_Up(CWorth*VRatio,2);

    end;

    If (AMode=0) then
      CISDeclared:=CurrSettled
    else
    Begin
      CISDeclared:=CISDeclared-(VWorth*DocCnst[InvDocHed]);
      Set_DocCISDate(LInv,BOn);
    end;
  end; {With..}
end;

{ == Proc to update screen totals == }

Procedure Update_CISScreenTotals(Var CRep  :  CVATRepParam;
                                     AddRec,
                                     DedRec:  JobDetlRec);

Begin
  With CRep do
  Begin
    GrossTot:=GrossTot+(AddRec.JOBCISV.CISvGrossTotal)-(DedRec.JOBCISV.CISvGrossTotal);
    MatTot:=MatTot+CalcCISJDMaterial(AddRec)-CalcCISJDMaterial(DedRec);
    TriTot:=TriTot+(AddRec.JOBCISV.CISvTaxDue)-(DedRec.JOBCISV.CISvTaxDue);
  end;

end;


{ == Check for Existing vouchers . == }

Function ChkVouchers(SDate,EDate  :  LongDate;
                     ChkMode      :  Byte)  :  Boolean;

Const
  Fnum    =  JDetlF;
  Keypath =  JDAnalK;

Var
  FoundOk  : Boolean;
  TmpStat,
  TmpKPath : Integer;
  TmpRecAddr
           : LongInt;

  LJD      :  JobDetlRec;

  KeyChk2,
  KeyChk,
  KeyS     :  Str255;

Begin
  Result:=BOff;

  Begin
    LJD:=JobDetl^;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    KeyChk:=CISPrefix+SDate;
    KeyChk2:=CISPrefix+Edate;
    KeyS:=KeyChk;

    FoundOk:=BOff;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKeyRange(KeyChk,KeyChk2,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
    Begin
      With JobDetl^.JobCISV do
      Begin
        Case ChkMode of
          4  :  FoundOk:=(CISCType In [4,5]);
          else  FoundOk:=(CISCType =ChkMode);
        end; {Case..}

        If (Not FoundOk) then
          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end; {With..}
    end; {While..}

    Result:=FoundOk;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    JobDetl^:=LJD;
  end;

end;




end.