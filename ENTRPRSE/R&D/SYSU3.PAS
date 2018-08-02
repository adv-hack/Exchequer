Unit SysU3;



{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 18/07/1999                    }
{                                                              }
{                   System Controller Unit III                 }
{                                                              }
{               Copyright (C) 1999 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,VarRec2U,VarConst ;


Procedure CheckYRef(Var InvR  :  InvRec);

Procedure CheckStockNdx(Var StockR  :  StockRec);

Procedure CheckCustNdx(Var CustR  :  CustRec);

Procedure Check_ValidVATNo(VRNo  :  Str20);

Function ValidDelTerms(VDT  :  Str10)  :  Boolean;

Procedure Check_ValidDelTerms(VDT  :  Str10);

Function ValidModeTran(VMT  :  Byte)  :  Boolean;

Procedure Check_ValidModeTran(VMT  :  Byte);

Function ValidNatTran(NT  :  Integer)  :  Boolean;

Procedure Check_ValidNatTran(NT  :  Integer);

Function SetTransNat(DocHed  :  DocTypes)  :  Byte;

Function BuildVSecKey  :  Str255;

Function CompareVSecure(ResetOnFail,
                        StoreSyss    :  Boolean)  :  Boolean;

Procedure TrackSecUpdates(StoreSyss  :  Boolean);

Function Check_GLCurr(LInv  :  InvRec;
                      LId   :  IDetail;
                      Mode  :  Byte)  :  Boolean;

Function Check_GLJC(LInv  :  InvRec;
                    LId   :  IDetail;
                    Mode  :  Byte)  :  Boolean;


{$IFDEF SOP}

  Procedure Set_StkCommod(Var IdR     :  IDetail;
                              StockR  :  StockRec);

{$ENDIF}

Function CanEditTriEuro(CNo  :  Byte)  :  Boolean;

Function UseV5OsNdx  :  Boolean;

Function CPayType2Index(PT  :  Char)  :  Integer;

  Function UseV501CISNdx  :  Boolean;

{$IFDEF JC}
  Function GetCISCType(Ccode :  Char)  :  CISTaxType;

  Function GetCISCIndex(Ccode :  Char)  :  Integer;
{$ENDIF}

  Function Ret_CustSupp(InvDocHed  :  DocTypes)  :  Char;

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   SysUtils,
   Dialogs,
   BtrvU2,
   ETMiscU,
   ETStrU,
   VarFPosU,
   BTKeys1U,
   BTSUpU1,
   {$IFNDEF EXDLL}  { HM 29/06/00: Moved ifdef to exclude Excep2U as well as HelpSupu/EntLic }
     {$IFNDEF COMP}
     {$IFNDEF OLE}
       {$IFNDEF EBAD}
         Excep2U,
       {$ENDIF}
     {$ENDIF}
   {$ENDIF}

     {$IFNDEF OLE}
       HelpSupU,
       EntLic,
       EntLic2,
     {$ENDIF}
   {$ENDIF}
   IntrastatXML,
   SysU1;



{ = Clean up any string for safe indexing = }

Procedure CleanNDX(Result  :  Pointer;
                   RetSize :  Integer);

Var
  sLen    :  Integer;
  SPtr,
  NPtr    :  ^Str255;

Begin
  New(SPtr);
  FillChar(SPtr^,Sizeof(SPtr^),0);

  NPtr:=Result;

  SLen:=Length(NPtr^);

  If (SLen>0) then
    Move(NPtr^,SPtr^,Succ(SLen));


  Move(SPtr^,NPtr^,RetSize);

  Dispose(SPtr);
end;



 Procedure CheckYRef(Var InvR  :  InvRec);

 Begin
   With InvR do
   Begin
     CleanNDX(@YourRef,SizeOf(YourRef));

     CleanNDX(@TransDesc,SizeOf(TransDesc));

   end;
 end; {Proc..}


 Procedure CheckCustNdx(Var CustR  :  CustRec);

 Begin
   With CustR do
   Begin
     CleanNDX(@RemitCode,SizeOf(RemitCode));

     CleanNDX(@RefNo,SizeOf(RefNo));

     CleanNDX(@CustCode2,SizeOf(CustCode2));

     CleanNDX(@SOPInvCode,SizeOf(SOPInvCode));

     CleanNDX(@PostCode,SizeOf(PostCode));

     CleanNDX(@VATRegNo,SizeOf(VATRegNo));

     CleanNDX(@EmailAddr,SizeOf(EmailAddr));

   end;
 end; {Proc..}


  Procedure CheckStockNdx(Var StockR  :  StockRec);

 Begin
   With StockR do
   Begin
     CleanNDX(@AltCode,SizeOf(AltCode));

     CleanNDX(@SuppTemp,SizeOf(SuppTemp));

     CleanNDX(@Supplier,SizeOf(Supplier));

     CleanNDX(@BarCode,SizeOf(BarCode));


   end;
 end; {Proc..}


Function ValidVATRegNo(VATRegNo  :  Str255) :  Boolean;
  Const
    DivVal  =  97;
    VATLenMin
            =  9;
    VATLenMax
            = 12;
    {CalLen  =  (VATLen-1);}
  Var
    VATAry  :  Array[1..VATLenMax-1] of Byte;
    CalLen,
    CalVal  :  LongInt;
    i,j     :  Byte;
  begin

    FillChar(VATAry,SizeOf(VATAry),#0);
    VATRegNo:=Strip('A',[#32],VATRegNo);
    Result :=(Length(VATRegNo)>=VATLenMin) and (Length(VATRegNo)<=VATLenMax);

    CalLen:=Pred(Length(VATRegNo));

    If (Result) and (IntStr(VATRegNo)>0) then
    begin
      For i:=1 to CalLen do
      begin
        If (i<>CalLen) then
          VATAry[i]:=IntStr(Copy(VATRegNo,i,1))
        else
          VATAry[i]:=IntStr(Copy(VATRegNo,i,2));
      end; {for..}

      j:=CalLen;
      CAlVal:=0;

      For i:=1 to CalLen do
      begin
        CalVal:=CalVal+(VATAry[i]*j);
        Dec(j);
      end; {for..}

      CalVal:=(CalVal div DivVal);

      Result:=(CalVal In [1..3]);
    end; {if..}


  end; {func..}


  Procedure Check_ValidVATNo(VRNo  :  Str20);

  Var
    CleanVRN  :  Str20;
    n         :  Byte;


  Begin
    CleanVRN:='';

    For n:=1 to Length(VRNo) do
      If (VRNo[n] In ['0'..'9']) then
        CleanVRN:=CleanVRN+VRNo[n];

    {$B-}

    If (Copy(VRNo,1,2)='GB') and (Not ValidVATRegNo(CleanVRN))  then
    Begin
    {$B+}
      ShowMessage('That '+CCVATName^+' No. does not appear to be valid.');

    end;

  end;


  //----------------------------------------------------------------------------
  Function ValidDelTerms(VDT  :  Str10)  :  Boolean;
  // PKR. 12/01/2016. ABSEXCH-17098. Intrastat.
  // Now validates against the Intrastat XML file.  If the list of codes changes
  // it will change in there, rather than in here.
//  Const
//    ValidTerms  :  Array[1..16] of String[3] = ('EXW','FOB','CIF','DDU','DDP','XXX', {UK}
//                                               'FCA','FAS','CFR','CPT','CIP','DAF',
//                                               'DES','DEQ', 'DAT', 'DAP');
  Begin
    If (Not JBFieldOn) then
    Begin
      // PKR. 12/01/2016. ABSEXCH-17098. Intrastat.
      // Valid if the value is found in the IntrastatSettings.
      Result := (IntrastatSettings.IndexOf(stDeliveryTerms, ifCode, Trim(VDT)) > -1);
    end
    else
      Result:=BOn;
  end;


  Procedure Check_ValidDelTerms(VDT  :  Str10);
  Begin
    // DeliveryTerms needs only be valid if trader is an EC Member.
    // This field is only available to edit if EC Member is checked.
    {$B-}
    If (VDT<>'') and (Not ValidDelTerms(VDT)) then
    Begin
    {$B+}
      ShowMessage('The Delivery Terms are not valid.');
    end;
  end;


  //----------------------------------------------------------------------------
  Function ValidModeTran(VMT  :  Byte)  :  Boolean;
  Begin
//    ValidModeTran:=(VMT In [1..9]) or (JBFieldOn);

    // PKR. 12/01/2016. ABSEXCH-17098. Intrastat.
    // Valid if the value is found in the IntrastatSettings.
    Result := (IntrastatSettings.IndexOf(stModeOfTransport, ifCode, IntToStr(VMT)) > -1) or (JBFieldOn);
  end;


  Procedure Check_ValidModeTran(VMT  :  Byte);
  Begin
    {$B-}
    If (VMT<>0) and (Not ValidModeTran(VMT)) then
    Begin
    {$B+}
      ShowMessage('The Mode of Transport is not valid.');
    end;
  end;


  //----------------------------------------------------------------------------
  Function ValidNatTran(NT  :  Integer)  :  Boolean;
  Var
   NumSL   :  Str5;
  Begin
    If (Not JBFieldOn) then
    Begin
      Blank(NumSL,Sizeof(NumSL));

      NumSL:=Form_Int(NT,0);

      // PKR. 21/01/2016. ABSEXCH-17184. Validation needs to use new Intrastat system
      ValidNatTran := (IntrastatSettings.IndexOf(stNatureOfTransaction, ifCode, NumSL) > -1);
    end
    else
      Result:=BOn;
  end;


  Procedure Check_ValidNatTran(NT  :  Integer);
  Begin
    {$B-}
    If (Not ValidNatTran(NT)) then
    Begin
    {$B+}
      ShowMessage('The Nature of Transaction is not valid.');
    end;
  end;

  { Returns the default Nature of Transaction Code (NoTC) for the supplied
    transaction type, based on the transaction type (Credit Notes have their
    own NoTC) and country (Ireland uses different NoTC values). }
  Function SetTransNat(DocHed  :  DocTypes)  :  Byte;
  Begin
    // CJS 2014-09-08 - ABSEXCH-15576 - amend default NoTC value for Ireland

    // Credit Note NoTC, based on country
    if (DocHed in CreditSet) then
    begin
      if (CurrentCountry = IECCode) then
        Result := VATIECrdTTyp
      else
        Result := VATCRDTTyp;
    end
    // Default NoTC, based on country
    else if (CurrentCountry = IECCode) then
      Result := VATIEInvTTyp
    else
      Result := VATInvTTyp;

  end;
  //----------------------------------------------------------------------------




  { == Various routines to control the validation of security codes by comparing a duplicate record == }

  Const
    VSecCode  = 'VSDUPLI';

  Function BuildVSecKey  :  Str255;

  Begin
    BuildVSecKey:=FullPWordKey(PostUCode,'V',VSecCode);

  end;


  Function GetVSecure(KeepPass  :  Boolean;
                  Var TStat     :  SmallInt;
                  Var AbortCheck:  Boolean)  :  Boolean;


  Const
    Fnum      =  PWrdF;
    Keypath   =  PWK;


  Var
    KeyS  :  Str255;

    TmpPassWord
          : PassWordRec;


  Begin
    If (KeepPass) then
      TmpPassWord:=PassWord;

    KeyS:=BuildVSecKey;

    Result:=BOff;

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    AbortCheck:=((Status<>0) and (Status<>4) and (Status<>9));

    If (Not StatusOk) then {* Can't find a record so reset it *}
      ResetRec(Fnum);

    Result:=StatusOK;

    If KeepPass then
      PassWord:=TmpPassWord;

    TStat:=Status;

    GetVSecure:=Result;
  end;


  { == Compare found code with all other release codes == }

  Function CompareVSecure(ResetOnFail,
                          StoreSyss    :  Boolean)  :  Boolean;

  Const
    ResMsg  :  Array[0..9] of Str80 =

  {00}   ('',
  {01}    'The duplicate security record could not be found.',
  {02}    'The main system release code has changed.',
  {03}    'The main system release code date has changed.',
  {04}    'The multi user count has changed.',
  {05}    'The multi user count date has changed.',
  {06}    'The last system daily password has changed.',
  {07}    'The ESN does not match.',
  {08}    'The Demo flag setting does not match.',
  {09}    'One of the module release codes has changed.'
         );

  Var
    LOK,
    AbortCheck,
    Locked  :  Boolean;

    ResFail,
    n       :  Byte;

    TmpPassWord
            : PassWordRec;

    GetFail : SmallInt;

    FailStr : Str255;



  { == Copare ISN == }

  Function Compare_ISN(ISN1,ISN2  :  ISNArrayType)  :  Boolean;

  Var
    n       :  Byte;

  Begin
    Result:=BOff;

    For n:=Low(ISN1) to High(ISN1) do
    Begin
      Result:=ISN1[n]=ISN2[n];

      If (Not Result) then
      Break;

    end;

    Compare_ISN:=Result;
  end;


  Begin
    TmpPassWord:=PassWord;  Locked:=BOn;  LOK:=BOff; ResFail:=0;  GetFail:=0;

    AbortCheck:=BOff;

    Result:=(Not Syss.DupliVSec); {* Force thru as OK if not set up *}

    If (Not Result) then
    Begin
      Result:=GetVSecure(BOff,GetFail,AbortCheck);

      If (Result) then {* Compare Contents *}
      With PassWord.VSecureRec do
      Begin
        If (ExRelease<>Syss.ExRelease) then
          resFail:=2
        else
          If (RelDate<>Syss.RelDate) then
            resFail:=3
          else
            If (ExUsrRel<>Syss.ExUsrRel) then
              resFail:=4
            else
              {If (UsrRelDate<>Syss.UsrRelDate) then {* This is not used yet so don't check, just in case
                resFail:=5
              else}
                If (LastDaily<>Syss.LastDaily) then
                  resFail:=6
                else
                  If (Not Compare_ISN(ISN,Syss.EXISN)) then
                    resFail:=7
                  else
                    If (DemoFlg<>Syss.ExDemoVer) then
                      resFail:=8;

        {Result:=(ExRelease=Syss.ExRelease) and (RelDate=Syss.RelDate)
               and (ExUsrRel=Syss.ExUsrRel) and (UsrRelDate=Syss.UsrRelDate)
               and (LastDaily=Syss.LastDaily)
               and Compare_ISN(ISN,Syss.EXISN) and (DemoFlg=Syss.ExDemoVer);}

        Result:=(ResFail=0);


        If (Result) then {* First Test passed *}
          For n:=Low(Modules) to High(Modules) do
          Begin
            Result:=(Modules[n]=SyssMod^.ModuleRel.ModuleSec[n,BOn])
                and (ModRelDate[n]=SyssMod^.ModuleRel.RelDates[n]);

            If (Not Result) then
            Begin
              resFail:=9;
              Break;
            end;
          end;


      end
      else
        ResFail:=1;


      If (Not Result) and (ResetOnFail) and (Not AbortCheck) then {* Scrap the lot so there... *}
      Begin
        With Syss do
        Begin


          If (StoreSyss) then
            LOK:=GetMultiSys(BOn,Locked,SysR)
          else
            LOk:=BOn;

          If (LOk) then
          Begin
            FillChar(ExSecurity,Sizeof(ExSecurity),0);
            FillChar(ExRelease,Sizeof(ExRelease),0);
            RelDate:=0.0;
            {* FillChar(ExUsrSec,Sizeof(ExUsrSec),0); Do nopt restet this as it does not get generated again *}
            FillChar(ExUsrRel,Sizeof(ExUsrRel),0);
            UsrRelDate:=0.0;

            If (StoreSyss) then
            Begin
              PutMultiSys(SysR,BOn);

              FailStr:=resMsg[resFail];

              If (resFail=1) then
                FailStr:=FailStr+#13+'Btrieve Error '+Form_Int(GetFail,0);

              {$IFNDEF EXDLL}
              {$IFNDEF COMP}
              {$IFNDEF OLE}
              {$IFNDEF EBAD}
                  AddErrorLog('Internal Security Check Failed','Warning. Internal Security has failed beacuse '+FailStr,2);
              {$ENDIF}
              {$ENDIF}
              {$ENDIF}
              {$ENDIF}

              ShowMessage('WARNING! - '+'Internal Security Check Failed.'+#13+#13+
                           'The internal system security check has failed because:-'+#13+
                           FailStr+#13+#13+
                           'All security release and user codes have been reset.'+#13+
                           'Contact your supplier to release these areas again.');


            end;
          end;
        end;

        With SyssMod^,ModuleRel do
        Begin
          Locked:=BOn;


          If (GetMultiSys(BOn,Locked,ModRR)) then
          Begin
            FillChar(ModuleSec,Sizeof(ModuleSec),0);
            FillChar(RelDates,Sizeof(RelDates),0);

            PutMultiSys(ModRR,BOn);
          end;

        end;
      end;
    end;

    PassWord:=TmpPassWord;

    CompareVSecure:=Result;
  end;

  {* Update dupliace image when main record changes *}

  {$IFNDEF EXDLL}

    Function UpdateLic  :  Boolean;
    Begin
      If (Assigned(ExMainCoPath)) then
        UpdateLic:=(UpCaseStr(ExMainCoPath^)=UpCaseStr(SetDrive))
      else
        UpDateLic:=BOff;
    end;

  {$ENDIF}


  Procedure TrackSecUpdates(StoreSyss  :  Boolean);

  Const
    Fnum      =  PWrdF;
    Keypath   =  PWK;

  Var
    LOK,
    Locked,
    AbortCheck,
    NewRec  :  Boolean;

    TStatus :  SmallInt;

    n       :  Byte;

    TmpPassWord
            : PassWordRec;


  Begin
    TmpPassWord:=PassWord;  Locked:=BOn; LOK:=BOff; TStatus:=0; AbortCheck:=BOff;

    NewRec:=Not GetVSecure(BOff,TStatus,AbortCheck);

    With PassWord,VSecureRec do
    Begin
      If (NewRec) then
      Begin
        ResetRec(PwrdF);
        RecPFix:=PostUCode;
        SubType:='V';
        SecCode:=LJVar(VSecCode,LogInKeyLen);
      end;

      ExRelease:=Syss.ExRelease;
      RelDate:=Syss.RelDate;
      ExUsrRel:=Syss.ExUsrRel;
      UsrRelDate:=Syss.UsrRelDate;
      ISN:=Syss.EXISN;
      DemoFlg:=Syss.ExDemoVer;
      LastDaily:=Syss.LastDaily;

      For n:=Low(Modules) to High(Modules) do
      Begin
        Modules[n]:=SyssMod^.ModuleRel.ModuleSec[n,BOn];
        ModRelDate[n]:=SyssMod^.ModuleRel.RelDates[n];

      end;

      If (NewRec) then
        Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath)
      else
        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      {* Update the licence file *}

      {$IFNDEF EXDLL}
      {$IFNDEF OLE}
        If (UpDateLic) then
          UpdateEntLic(BOff);
      {$ENDIF}
      {$ENDIF}

      If (Not Syss.DupliVSec) then
      Begin
        If (StoreSyss) then
          LOK:=GetMultiSys(BOn,Locked,SysR)
        else
          LOk:=BOn;

        If (LOK) then
        Begin
          Syss.DupliVSec:=BOn;

          If (StoreSyss) then
            PutMultiSys(SysR,BOn);
        end;

      end;
    end; {With..}

    PassWord:=TmpPassWord;
  end;


{ == Check G/L and currency combination valid == }

Function Check_GLCurr(LInv  :  InvRec;
                      LId   :  IDetail;
                      Mode  :  Byte)  :  Boolean;

Begin
  {$IFDEF MC_On}
    With LId do
    Begin
      Result:=(Nom.NomCode=NomCode) or (NomCode=0);
      If (Not Result) then
      Begin
        Result:=Global_GetMainRec(NomF,FullNomKey(NomCode));

      end;

      If (LInv.InvDocHed=NMT) then
        Result:=Result and ((Currency=Nom.DefCurr) or (Nom.DefCurr=0) or (Currency=0) or (NomCode=0))
      else
        Result:=Result and ((LInv.Currency=Nom.DefCurr) or (Nom.DefCurr=0) or (Currency=0));

    end;
  {$ELSE}
    Result:=BOn;

  {$ENDIF}
end;

{ == Check G/L and currency combination valid == }

Function Check_GLJC(LInv  :  InvRec;
                    LId   :  IDetail;
                    Mode  :  Byte)  :  Boolean;

Begin

  {$IFDEF JC}
    Result:=Not JBCostOn;

    If (Not Result) then
    With LId do
    Begin
      Result:=(Nom.NomCode=NomCode) or (NomCode=0);
      If (Not Result) then
      Begin
        Result:=Global_GetMainRec(NomF,FullNomKey(NomCode));

      end;

      If (Result) and (NomCode<>0) then
      Begin
        If (Nom.ForceJC) then {Check it is a valid JC}
        {$B-}
          Result:=(JobCode<>'') and (Global_GetMainRec(JobF,FullJobCode(JobCode)));
        {$B+}

      end;

    end;
  {$ELSE}
    Result:=BOn;

  {$ENDIF}
end;



{ == Check for a triangulated currency we should not be able to edit ==}

Function CanEditTriEuro(CNo  :  Byte)  :  Boolean;

Var
  n       :  Integer;

Begin
  Result:=BOn;

  {$IFDEF MC_On}
    If (CNo>1) and (CurrentCountry=IECCode) then
    Begin
      For n:=2 to CurrencyType do
      Begin
        Result:=(SyssGCur^.GhostRates.TriEuro[n]<>CNo);

        If (Not Result) then
          Break;

      end;
    end;
  {$ENDIF}

end;




{$IFDEF SOP}

  Procedure Set_StkCommod(Var IdR     :  IDetail;
                              StockR  :  StockRec);

  Begin
    With StockR,IdR do
    Begin
      SSDCommod:=CommodCode;

      // CJS 2016-01-18 - ABSEXCH-17099 - Intrastat - 4.3 Stock Record
      // Intrastat Country on Stock record is no longer used for UK
      if (CurrentCountry <> UKCCode) then
        IdR.SSDCountry := StockR.SSDCountry;

      SSDSPUnit:=SuppSUnit;
      { CJS 2012-06-12: ABSEXCH-13034 - Intrastat State Uplift }
      if (CurrentCountry = IECCode) and (IdR.IdDocHed in PurchSplit) then
        SSDUplift := SSDAUplift
      else
        SSDUpLift:=SSDDUplift
    end;

  end;

{$ENDIF}


{ == Function to check if Inv o/s index has account code present for v5 functionality == }

Function UseV5OsNdx  :  Boolean;

Var
  RecPos :  Integer;

Begin
  {$IFDEF EXSQL}
    Result:=BOn;
  {$ELSE}

    RecPos:=BtKeyPos(@Inv.CustCode,@Inv)+1;

    Result:=GetFullFile_StatCId(F[InvF],InvF,Nil).Ks[21].KeyPos=RecPos;
  {$ENDIF}

end;


{== Function to map from Paytype to ItemIndex == }

Function CPayType2Index(PT  :  Char)  :  Integer;

Begin
  Case PT of
    BACSRCode  :  Result:=1;
    BACS2Code  :  Result:=2;
    BACS3Code  :  Result:=3;
    else          Result:=0;
  end; {Case..}
end;

{ == Function to check if Inv CIS index has  CISDate offset present for v5.01 functionality == }

Function UseV501CISNdx  :  Boolean;

Var
  RecPos :  Integer;

Begin
  {$IFDEF EXSQL}

    Result:=BOn;

  {$ELSE}

    RecPos:=BtKeyPos(@Inv.CISDate,@Inv)+1;

    Result:=GetFullFile_StatCId(F[InvF],InvF,Nil).Ks[22].KeyPos=RecPos;

  {$ENDIF}
end;



{$IFDEF JC}
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

  { =========== Return CIS Rate No. ============ }

  Function GetCISCIndex(Ccode :  Char)  :  Integer;
  Begin
    If (Ccode<>C0) then
      Result:=Succ(Ord(GetCISCType(CCode)))
    else
      Result:=0;
  end; {Func..}
{$ENDIF}


 { == Function to set the cust supp char for a Return == }

 Function Ret_CustSupp(InvDocHed  :  DocTypes)  :  Char;

 Begin
   If (InvDocHed=SRN) then
     Result:='R' {Filter from normal ledger}
   else
     Result:='N';
 end;



Initialization


 {$IFNDEF EXDLL}
   {$IFNDEF COMP}
     {$IFNDEF OLE}
       {$IFNDEF EBAD}
         {$IFDEF DBD}
           If (Sizeof(CustRec)<>2119) then
             ShowMessage('CustRec record size mismatch, should be 2119, found '+IntToStr(Sizeof(CustRec)));

           If (Sizeof(InvRec)<>1964) then
             ShowMessage('InvRec record size mismatch, should be 1964, found '+IntToStr(Sizeof(InvRec)));

           If (Sizeof(Idetail)<>1086) then
             ShowMessage('IDetail record size mismatch, should be 1086, found '+IntToStr(Sizeof(IDetail)));

           If (Sizeof(SysRec)<>1787) then
             ShowMessage('SysRec record size mismatch, should be 1787, found '+IntToStr(Sizeof(SysRec)));

           If (Sizeof(MiscRecs^)<>532) then
             ShowMessage('MiscRecs^ record size mismatch, should be 532, found '+IntToStr(Sizeof(MiscRecs^)));

           If (Sizeof(JobDetlRec)<>838) then
             ShowMessage('JobDetlRec record size mismatch, should be 838, found '+IntToStr(Sizeof(JobDetlRec)));

           If (Sizeof(JobRecType)<>650) then
             ShowMessage('JobRecType record size mismatch, should be 650, found '+IntToStr(Sizeof(JobRecType)));

           If (Sizeof(JobMiscRec)<>902) then
             ShowMessage('JobMiscRec record size mismatch, should be 902, found '+IntToStr(Sizeof(JobMiscRec)));

           If (Sizeof(MLocCtrl^)<>1302) then
             ShowMessage('MLocCtrl^ record size mismatch, should be 1302, found '+IntToStr(Sizeof(MLocCtrl^)));

           If (Sizeof(NominalRec)<>335) then
             ShowMessage('NominalRec record size mismatch, should be 335, found '+IntToStr(Sizeof(NominalRec)));

           If (Sizeof(StockRec)<>1841) then
             ShowMessage('StockRec record size mismatch, should be 1841, found '+IntToStr(Sizeof(StockRec)));
           

           If (Sizeof(HistoryRec)<>159) then
             ShowMessage('HistoryRec record size mismatch, should be 159, found '+IntToStr(Sizeof(HistoryRec)));

           If (Sizeof(IncrementRec)<>29) then
             ShowMessage('IncrementRec record size mismatch, should be 29, found '+IntToStr(Sizeof(IncrementRec)));

           If (Sizeof(PassWordRec)<>283) then
             ShowMessage('PassWordRec record size mismatch, should be 283, found '+IntToStr(Sizeof(PassWordRec)));

           If (Sizeof(JobCtrlRec)<>256) then
             ShowMessage('JobCtrlRec record size mismatch, should be 256, found '+IntToStr(Sizeof(JobCtrlRec)));

           If (Sizeof(NomViewRec)<>768) then
             ShowMessage('NomViewRec record size mismatch, should be 768, found '+IntToStr(Sizeof(NomViewRec)));
         {$ENDIF}
       {$ENDIF}
     {$ENDIF}
   {$ENDIF}
 {$ENDIF}



Finalization


end.