unit cisfuncs;

interface

uses
  GlobVar,VarConst;

Type
  tCISFind  =  Record
                 Found  :  Boolean;
                 ECode  :  Str20;
               end;

  taCISFind =  Array[4..6] of tCISFind;


Function Check_CISEmployee(EmplCode  :  Str20;
                       Var Taxable   :  Boolean)  :  Str20;


Function CheckCISGLCodes(FromForm  :  Byte)  :  Boolean;

Procedure Calc_CISTax(Var BInv    :   InvRec;
                      Var Materials,
                          Taxable,
                          TaxValue:   Double;
                          UpLine  :   Boolean);

Function Calc_CISTaxInv(Var  BInv    :  InvRec;
                             UpDate  :  Boolean;
                             TKResult : Integer)  :  Double;


implementation

uses
  Btrvu2, BTKeys1U, BtSupU1, EtStrU, Varrec2U, EtMiscU, MiscU;

  { =========== Return CIS Rate No. ============ }

  Function GetCISCType(Ccode :  Char)  :  CISTaxType;


  Var
    n         :  CISTaxType;
    FoundYet  :  Boolean;


  Begin
    Result:=CISStart;

    FoundYet:=BOff;

    If (Ccode<>C0) and (Not FoundYet) then
    Begin

      n:=CISStart;

      While (n<=CISEnd) and (Not FoundYet) do
      With SyssCIS.CISRates do
      Begin
        FoundYet:=(Ccode=CISRate[n].Code);

        If (Not FoundYet) then
        Begin
          Inc(n);
          Inc(Result);
        end;
      end;

    end;

  end; {Func..}
  

{ == These rotuines replicated in JobPostU for thread safe operation == }

  Function Find_CISEmployee(EmplCode  :  Str20;
                            ViaSupp   :  Boolean)  :  taCISFind;


  Const
    Fnum     =  JMiscF;
    Keypath  =  JMTrdK;

  Var
    n          : Byte;
    TmpStat,
    TmpKPath   : Integer;
    TmpRecAddr : LongInt;

    KeyChk,
    KeyS       : Str255;

    LOk        : Boolean;

    CISFind    : taCISFind;


  Begin
    FillChar(Result,Sizeof(Result),#0);
    FillChar(CISFind,Sizeof(CISFind),#0);

    KeyS:=''; KeyChk:='';

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    If (ViaSupp) then
    Begin
      KeyChk:=PartCCKey(JARCode,JASubAry[3])+FullCustCode(EmplCode);
      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not Result[4].Found) do
      With JobMisc^,EmplRec do
      Begin

        CISFind:=Find_CISEmployee(EmpCode,BOff);

        For n:=Low(CISFind) to High(CISFind) do
          If (Not Result[n].Found) and (CISFind[n].Found) then
            Result[n]:=CISFind[n];

        If (Not Result[4].Found) then
          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);

      end;

    end
    else
    With JobMisc^,EmplRec do
    Begin
      KeyS:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(EmplCode));

      If (EmplCode<>EmpCode) then
        LOk:=CheckRecExsists(KeyS,Fnum,JMK)
      else
        LOk:=BOn;

      If (LOk) then
      Begin
        Case CISType of

          1,4  :  With Result[4] do
                  Begin
                    Found:=BOn;
                    ECode:=EmpCode;
                  end;

          2,5  :  With Result[5] do
                  Begin
                    Found:=BOn;
                    ECode:=EmpCode;
                  end;

          3    :  With Result[6] do
                  Begin
                    Found:=BOn;
                    ECode:=EmpCode;
                  end;
        end; {Case..}
      end;


    end;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);
  end;


  { == From three poss cases, return code in order of priority == }

  Function Check_CISEmployee(EmplCode  :  Str20;
                         Var Taxable   :  Boolean)  :  Str20;

  Var
    n          : Byte;

    CISFind    : taCISFind;

  Begin
    Result:=''; Taxable:=BOff;

    CISFind:=Find_CISEmployee(EmplCode,BOn);

    For n:=Low(CISFind) to High(CISFind) do
    If (CISFInd[n].Found) then
    Begin
      Result:=CISFind[n].ECode;

      Taxable:=(n=Low(CISFind));

      Break;
    end;
  end;

  { == Procedure to reset all doc's CIS settings == }

  Procedure Reset_DOCCIS(Var BInv   :  InvRec;
                             ResetE :  Boolean);

  Begin
    With BInv do
    Begin
      If (JBCostOn) and (CISOn) then
      Begin
        If (ResetE) then
          FillChar(CISEmpl,Sizeof(CISEmpl),#0);

        CISManualTax:=BOff;
        CISTax:=0.0;
        FillChar(CISDate,Sizeof(CISDate),#0);
      end;

    end;
  end;

  { == Function to check all CIS G/L Codes are present == }

Function CheckCISGLCodes(FromForm  :  Byte)  :  Boolean;

Var
  Loop     :  Boolean;

  n        :  CISTaxType;

  FoundLong:  LongInt;

  FoundCode:  Str20;

  Msg      :  String;

Begin
  Result:=BOff;

  For n:=CISStart to CISEnd do
  With SyssCIS.CISRates.CISRate[n] do
  Begin
    {$B-}
    Result:=(GLCode<>0);

    If (not Result) then
      Msg:='G/L Code '+Form_Int(GLCode,0)+' for '+CCCISName^+' rate code '+Code+', '+Desc+' is not a valid G/L code.'
    else
      If (Syss.UseCCDep) then
      Begin
        For Loop:=BOff to BOn do
        Begin
          Result:=(RCCDep[Loop]<>'');

          If (not Result) then
          Begin
            Msg:=CostCtrRTitle[Loop]+' Code '+RCCDep[Loop]+' for '+CCCISName^+' rate code '+Code+', '+Desc+' is not a valid '+CostCtrRTitle[Loop]+' code.';

            Break;
          end;

        end;

      end;

      If (Not Result) then
        Break;

    end;

  If (Not Result) then
  Begin
    If (FromForm=1) then
      Msg:=Msg+#13+'The '+CCCISName^+' calculation for this transaction has not been completed.';

  //  ShowMessage(Msg);

  end;
end;



  { == Proc to scan Lines to work out materials and taxables == }
    { == Reproduced inside JobPostU.pas, for thread safe operation == }

  Procedure Calc_CISTax(Var BInv    :   InvRec;
                        Var Materials,
                            Taxable,
                            TaxValue:   Double;
                            UpLine  :   Boolean);

  Const
    Fnum     =  IDetailF;
    Keypath  =  IDFolioK;

  Var
    LOk,CalcTax,
    DLineOk,
    ResetCIS
               : Boolean;
    B_Func,
    TmpStat,
    TmpKPath   : Integer;

    AGLCode,
    TmpRecAddr : LongInt;

    VATRate    : VATType;

    CISRateType: CISTaxType;

    LineVAT,
    VATRatio,
    LineTotal  : Double;

    ACCDep     : CCDepType;

    FoundCode  : Str20;

    KeyChk,
    KeyS       : Str255;

    AutoLine,
    TmpId      : IDetail;


  Begin
    Materials:=0.0; Taxable:=0.0; TaxValue:=0.0;  LineTotal:=0.0; LineVAT:=0.0;  VATRatio:=0.0; ResetCIS:=(UpLine and (BInv.CISHolder=0));

    DLineOk:=BOff;

    CISRateType:=Construct;  AGLCode:=0; Blank(ACCDep,Sizeof(ACCDep));

    B_Func:=B_GetNext;

    With BInv do
    If (InvDocHed In CISDocSet) and (CISOn) and (JBCostOn) then
    Begin
      If (CISEmpl='') then
        CISEmpl:=Check_CISEmployee(CustCode,CalcTax)
      else
      Begin
        KeyS:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(CISEmpl));


        LOk:=CheckRecExsists(KeyS,JMiscF,JMK);


        {$B-}
          If (LOk) then
            CalcTax:=(JobMisc^.EmplRec.CISType In [1,4])
          else
          Begin
            CISEmpl:=Check_CISEmployee(CustCode,CalcTax);

            CalcTax:=(JobMisc^.EmplRec.CISType In [1,4])
          end;
        {$B+}

      end;

      If (CISEmpl<>'') or (UpLine) then {* We have a CIS situation *}
      Begin
        If (CheckCISGLCodes(1)) then
        Begin
          TmpId:=Id;
          TmpKPath:=GetPosKey;

          TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

          KeyChk:=FullNomKey(FolioNum);

          KeyS:=FullIdKey(FolioNum,1);


          Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

          While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
          With Id do
          Begin
//            Application.ProcessMessages;

            B_Func:=B_GetNext;


            {$B-}
            If (CISEmpl<>'') and (Not EmptyKey(AnalCode,AnalKeyLen)) and (Not EmptyKey(JobCode,JobKeyLen))
               and (CheckRecExsists(FullJAKey(JARCode, JAACode, AnalCode),JMiscF, 0)) and (AutoLineType<>2) then
            {$B+}
            With JobMisc^,JobAnalRec do
            If (JAType>=2) or ((Not UpLine) and (CISRateCode<>C0)) then {Its overhead, material or labour}
            Begin
              LineTotal:=Round_Up(InvLTotal(Id,BOn,0),2);

              If (UpLine) then
              Begin
                If (CISTaxRate<>C0) then
                Begin
                  If (CalcTax) then
                  Begin
                    CISRateCode:=CISTaxRate;

                    CISRateType:=GetCISCType(CISRateCode);

                    With SyssCIS^.CISRates.CISRate[CISRateType] do
                    Begin
                      CISRate:=Rate;
                      AGLCode:=GLCode;
                      ACCDep:=RCCDep;
                    end;

                    AutoLine:=Id;
                  end
                  else
                  Begin
                    CISRateCode:=C0;
                    CISRate:=0.0;
                  end;

                  Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

                  //Report_BError(Fnum,Status);
                end;
              end;

              If (CISRateCode<>C0) then
                Taxable:=Taxable+LineTotal
              else
                Materials:=Materials+LineTotal;

              If (CurrentCountry=IECCode) then
              Begin
                If (Not ManVAT) then
                  TaxValue:=TaxValue+Round_Up((LineTotal+VAT)*CISRate,2)
                else
                Begin {!!! This would need changing to the LDef_InvCalc version for the thread safe version of this}
                  Def_InvCalc; {Work out goods vat split}

                  VATRate:=GetVAtNo(VATcode,VATIncFlg);

                  VATRatio:=DivWChk(LineTotal,InvNetAnal[VATRate]);

                  LineVAT:=Round_Up((InvVATAnal[VATRate]*VatRatio),2);

                  TaxValue:=TaxValue+Round_Up((LineTotal+LineVAT)*CISRate,2)
                end;
              end
              else
                TaxValue:=TaxValue+Round_Up(LineTotal*CISRate,2);

              ResetCIS:=BOff;

            end;

            If (UpLine) and (AutoLineType=2) then {* Delete any auto manufactured CIS lines *}
            Begin
              {* Check a new line is required before auto deleting *}
              DLineOk:=((Round_Up(CISTax,2)=Round_Up(TaxValue,2)) or (CISManualTax))
                       and (Round_Up(CISTax,2)=Round_Up(NetValue,2))

                       and (JobCode='') and (AnalCode='') and (VATCode=VATZCode) and (LineNo=(ILineCount-2))
                       and (Qty=-1.0)and (QtyMul=1.0);

              If (Not DLineOk) then
              Begin
                AutoLine:=Id;

                Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

                Report_BError(Fnum,Status);

                B_Func:=B_GetGEq;
              end;
            end;

            Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

          end; {While..}

          If (UpLine) then
          Begin
            If (Not CISManualTax) then
            Begin
              CISTax:=TaxValue;
            end;

            If (CISHolder=0) then
              CISGross:=Taxable;  {If we do not proctect here, special transactions like retentions or self billing get reset to zero}

            If (CISTax<>0.0) and (AutoLine.FolioRef=FolioNum) and (Not DLineOk) then {Decrease value of transaction by Tax amount}
            With Id do
            Begin
              ResetRec(Fnum);

              FolioRef:=FolioNum;

              IdDocHed:=InvDocHed;

              AutoLineType:=2;

              LineNo:=ILineCount * 2;
              ABSLineNo:=LineNo;

              ILineCount:=ILineCount+2;

              If (AGLCode<>0) then
                NomCode:=AGLCode
              else
                NomCode:=AutoLine.NomCode;

              NetValue:=CISTax;

              InvNetVal := InvNetVal - NetValue;

              With SyssCIS^.CISRates do
              If (CISVATCode In VATSet) then
                VATCode:=CISVATCode
              else
                VATCode:=VATZCode;

              Qty:=-1.0; QtyMul:=1.0;

              If (ACCDep[BOff]<>'') then
                CCDep:=ACCDep
              else
                CCDep:=AutoLine.CCDep;

              Desc:=CCCISName^+' tax withheld from '+Form_Real(CISGross,0,2)+' liable for deduction.';

              {$IFDEF STK}
                LineType:=StkLineType[IdDocHed];
              {$ENDIF}

              DocPRef:=OurRef;

              Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

              //Report_BError(Fnum,Status);
            end;
          end;

          TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
          Id:=TmpId;
        end; {If..}
      end; {If..GL Codes OK}

      If (ResetCIS) and (Not CISManualTax) then
        Reset_DOCCIS(BInv,BOff);
    end; {If..}
  end; {Proc..}


  { == Procedure to Intercept CIS Tax Calculation == }

  Function Calc_CISTaxInv(Var  BInv    :  InvRec;
                               UpDate  :  Boolean;
                               TKResult : Integer)  :  Double;

  Var
    Materials,
    Taxable,
    TaxValue  :   Double;

  Begin
    Materials:=0.0; Taxable:=0.0; TaxValue:=0.0;

    Calc_CISTax(BInv,Materials,Taxable,TaxValue,UpDate);

    Result:=Materials+Taxable;
  end;


end.
