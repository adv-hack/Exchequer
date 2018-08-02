Unit DicLinkU;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 06/09/94                      }
{                                                              }
{                 Dictionary to Variable Link up               }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}


Interface

Uses Forms,
     StdCtrls,
     StrUtils,
     GlobVar,
     VarConst,
     VarRec2U,
     GlobType,
     Graphics,
     DicLnk2U,
     RpDevice;


  Function Link_Dict(      DictNo     :  LongInt;
                     Var   DictLink   : DictLinkType;
                     Const StrRec     : fdFormStringsType;
                     Const PixWidth   : LongInt;
                     Const DriveFile  : Integer;
                     Const SourceFile : Integer;
                           InpStr     : Str255)  :  Str255;

  Procedure DicNewForm;

  Procedure DicRunTots (Const FormMode : Integer);

  Function GetPixWidth (TheStr : String) : LongInt;

  Function FileTXlate(    FNum  :  Integer;
                      Var KPth  :  Integer)  :  Integer;

Type
  TradeTotalsType = Record
    LastTrans : String[10];
    Totals    : Array[1..8] Of Double;
  End; { TradeTotalsType }

Var
  TInv          : ^InvRec;
  TCust         : ^CustRec;
  {$If Defined(EDLL)}
    OrigPrnCust : ^CustRec;
  {$IfEnd}
  StringsRec    : fdFormStringsTypePtr;
  DictCanvas    : TLabel;
  CurrAged      : Array[CurStart..CurrencyType] of ^AgedTyp;
  DefTotals     : AgedTyp;
  DefTotals2    : {^}AgedTyp;
  RepInfo       : BatchRepInfoType;
  PBThrown      : Boolean;
  DicPageNo     : ^SmallInt;
  DDosMode      : Boolean;     { Used to specify whether PixWidth is pixels or chars }
  TotTLORDUS1   : Real;
  TotTLORDWEI   : Real;
  InChequeMode  : Boolean;
  PrintJobInfo  : ^TSBSPrintSetupInfo;
  BentLineCount : SmallInt;
  TradeInfo     : ^TradeTotalsType;

  // HM 05/07/04: Added NoteMode to allow GINVNOT mode to be changed
  GetNoteMode   : Byte;        // 0 - Standard, 1 - From Line

  // MH 13/12/05: Added Bespoke Trolley Totals for J&J Whines
  JJTotals      : Array [1..2] Of Double;
  JJTrolleyNo   : SmallInt;
  JJResetTots   : Boolean;


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Classes,
   Dialogs,
   Windows,
   ETStrU,
   ETMiscU,
   ETDateU,
   BtrvU2,
   BtKeys1U,
   BtSupU1,
   BtSupU2,
   InvListU,
   CurrncyU,
   MiscU,
   ComnUnit,
   ComnU2,
   SysU1,
   SysU2,
   SysUtils,
   FormUtil,
   {$IFDEF RW}
     RwOpenF,
     {RpCommon,
     RwFuncs,}
   {$ENDIF}

   JobSup1U,
   SerialNo,
   DocSupU1,
   ExWrap1U,
   //JobSup2U, - Bad Karma, replaced with oAppVals as it brought in 259 other units or 5.5Mb of additional code!
   oAppVals,
   SavePos,
   CIS,
   VarJCstU,
   RpDefine,
   Math,
   {$IFNDEF FORMTK}
     UA_Const,
     PWarnU,
   {$ENDIF}
   {$IFDEF EDLL}
     oFDAccountContacts,
     // MH 16/09/2014 Order Payments: Added support for printing SRC's as VAT Receipts
     oOPVATPayBtrieveFile,
     OPVATPaySingleton,
     oOPPreviousVATTracker,
   {$ENDIF}
   CustomFieldsIntf,
   MultiBuy2,
   MultiBuyVar,

   StrUtil,     // Funcs\StrUtil.pas

   // MH 06/08/2013 MRD1.7 - SEPA/IBAN Changes
   EncryptionUtils,

   //PR: 13/02/2012 ABSEXCH-9795
   QtyBreakVar,

   // MH 26/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
   CountryCodeUtils, CountryCodes

   //PR: 03/02/2014 ABSEXCH-19474
   {$IFDEF RW}
   ,AccountContactVar

   //PR: 14/10/2014 Order Payments for VRW
   ,OrderPaymentsVar
   ,oOPVATPayBtrieveFile
   ,oOPPreviousVATTracker
   {$ENDIF}
   ;


  Function Link_StkLoc(    DictNo    : LongInt;
                       Var DictLink  : DictLinkType) : Str255; forward;

Type
  SystemVerType = (Unknown, FormDes);

Var
  SystemVer    : SystemVerType;


//-------------------------------------------------------------------------

// Returns TRUE if this line is a J&J Whines Trolley Total line
Function JJTrolleyTotalLine : Boolean;
Begin // JJTrolleyTotalLine
  Result := (UpperCase(Trim(Id.LineUser1)) = 'ENDOFTROLLEY');
End; // JJTrolleyTotalLine

//-------------------------------------------------------------------------

{ MH 20/06/97: Bug Fix for Heinz - Def_InvCalc is changing the Discount totals }
{              on the invoice because of rounding errors. As the result of the }
{              function is put in global arrays we can save and restore the    }
{              invoice record to get around the problem.                       }
Procedure Def_InvCalc2;
Var
  TmpInvRec : ^InvRec;
  ExLocal  :  TdExLocal;
Begin
  New(TmpInvRec);
  TmpInvRec^ := Inv;

  If Not (Inv.InvDocHed In JAPSplit) Then
  Begin
    Def_InvCalc;
  End // If (Inv.InvDocHed In JAPSplit)
  Else
  Begin
    With TBtrieveSavePosition.Create Do
    Begin
      Try
        // Save the current position in the file for the current key
        SaveFilePosition (IdetailF, GetPosKey);
        SaveDataBlock (@Id, SizeOf(Id));

        //------------------------------

        ExLocal.Create;
        Try
          //CalcJAPVATTotals (Inv,ExLocal,BOff,BOn);

          // Calculate the totals for the current transaction and update the VAT
          // arrays for the transaction
          AppValTotals.CalcTotals(Inv);
        Finally
          ExLocal.Destroy;
        End;  // Try..Finally

        //------------------------------

        // Restore position in file
        RestoreSavedPosition;
        RestoreDataBlock (@Id);
      Finally
        Free;
      End; // Try..Finally
    End; // With TBtrieveSavePosition.Create
  End; // Else

  Inv := TmpInvRec^;
  Dispose (TmpInvRec);
End;

{ Returns the pixel width of the passed string }
Function GetPixWidth (TheStr : String) : LongInt;
Begin
  If Assigned (DictCanvas) Then Begin
    TheStr := Trim(TheStr);
    Result := DictCanvas.Canvas.TextWidth (TheStr);
  End { If }
  Else
    Result := 0;
End;

Function IsBentleyLine : Boolean;
Var
  oStock           : ^StockRec;
  TmpStat, TmpKey1 : Integer;
  TmpRecAddr       : LongInt;
  KeyS             : Str255;
  Dbl              : Double;
  ErrCode          : Integer;
Begin { IsBentleyLine }
  Result := False;

  If Is_FullStkCode(Id.StockCode) Then
    // Check Line Qty is set
    If (Id.Qty <> 0) Then Begin
      // Save Stock Position
      New (oStock);
      OStock^ := Stock;
      TmpKey1 := GetPosKey;
      TmpStat := Presrv_BTPos(StockF, TmpKey1, F[StockF], TmpRecAddr, BOff, BOff);

      // Get Stock Record
      KeyS := FullStockCode(Id.StockCode);
      Status := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, KeyS);
      If StatusOk Then Begin
        // Check 'No Of Cartons' in Stk.UDef1 is > 0
        Try
          (* HM 15/02/01: Rewrote as the exceptions being raised were pissing me off
          If (Trim(Stock.StkUser1) <> '') Then
            Result := (StrToFloat(Stock.StkUser1) <> 0.0);
          *)

          If (Trim(Stock.StkUser1) <> '') Then Begin
            Val (Stock.StkUser1, Dbl, ErrCode);
            Result := (ErrCode = 0) And (Dbl <> 0.0);
          End; { If (Trim(Stock.StkUser1) <> '') }
        Except
          // Catch any EConvertError exceptions caused by invalid crap in UDef1
          On Ex:Exception Do
            ;
        End;
      End; { If StatusOk }

      // Restore original Stock position
      TmpStat := Presrv_BTPos(StockF, TmpKey1, F[StockF], TmpRecAddr, BOn, BOff);
      Stock := OStock^;
      Dispose (oStock);
    End; { If (Id.Qty <> 0) }
End; { IsBentleyLine }


  { ========= Function to Return Cust Dict Values ======== }

  Function Link_CustDict(DictNo    :  LongInt;
                     Var DictLink  :  DictLinkType)  :  Str255;


  Var
    DictLink2  : DictLinkType;
    TmpField   :  Str255;
    TmpField2  :  Str20;
    INo        : Integer;
    OK         : Boolean;

    { Returns last invoice which will appear in customer statement }
    Function LastStateInv : InvRec;
    Const
      FNum              = InvF;
      KeyPath : LongInt = InvCDueK;
    Var
      TmpStat, TmpKey1 : Integer;
      TmpRecAddr       : LongInt;
      OInv             : InvRec;
      KeyS, KeyR       : Str255;
      TBO              : Boolean;
    Begin
      FillChar (Result, SizeOf(Result), #0);
      Result.TransDate := Today;
      Result.DueDate := Today;

      { Save Position }
      OInv:=Inv;
      TmpKey1:=GetPosKey;
      TmpStat:=Presrv_BTPos(Fnum,TmpKey1,F[Fnum],TmpRecAddr,BOff,BOff);

      { Build key to look for last invoice for customer }
      KeyS := TCust^.CustSupp + FullCustCode(TCust^.CustCode) + #255;
      KeyR := KeyS;

      { Run from latest invoice backwards until we hit one that appears on statement }
      TmpStat:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
      While (TmpStat = 0) And CheckKey(KeyR, KeyS, Length(KeyR) - 1, BOn) Do Begin
        { Check statement filter conditions }
        TBO:=(CurrencyOS(Inv,BOn,BOff,BOff)<>0);
        TBO:=(TBO and (Not(Inv.InvDocHed In QuotesSet+PSOPSet)) and (Inv.NomAuto));
        If Not Syss.IncNotDue then
          TBO:=(TBO and (Get_StaChkDate(Inv)<=Today));

        If TBO Then Begin
          { Want inv - return as result and finish loop }
          Result := Inv;
          Break;
        End; { If }

        TmpStat:=Find_Rec(B_GetPrev,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
      End; { While }

      { Restore Position }
      TmpStat:=Presrv_BTPos(Fnum,TmpKey1,F[Fnum],TmpRecAddr,BOn,BOff);
      Inv:=OInv;
    End;


    { 1=Name,2-6=Address,7-11=Delivery Address,12=Phone,13=Fax,14=Contact }
    Function GetInvToDets (FNo : Byte; AcNo : Str10) : ShortString;
    Const
      Fnum     =  CustF;
      Keypath  =  InvOurRefK;
    Var
      TmpStat, TmpKey        : Integer;
      TmpRecAddr             : LongInt;
      KeyS                   : Str255;
      AcAddr, DelAddr        : AddrTyp;
      CoName                 : String[45];
      OCust                  : CustRec;
      AcPhone, AcFax, AcCont : String[30];
      TmpStr                 : Str20;

      //PR: 18/10/2013 ABSEXCH-14703 Added delivery address postcode
      AcDelPostcode          : Str20;

      // MH 11/02/2015 v7.1 ABSEXCH-16142: Added ISO Country Code fields
      acCntry, acDelCntry    : String[2];

      // MH 21/08/2017 2017-R2 ABSEXCH-18163: Added Head Office PostCode fields
      acPostCode             : Str20;
    Begin { GetInvToDets }
      CoName  := Cust.Company;
      AcAddr  := Cust.Addr;
      // MH 11/02/2015 v7.1 ABSEXCH-16142: Added ISO Country Code fields
      acCntry := Cust.acCountry;
      If (Trim(Cust.DAddr[1]) <> '') Then
      Begin
        DelAddr := Cust.DAddr;
        // MH 11/02/2015 v7.1 ABSEXCH-16142: Added ISO Country Code fields
        acDelCntry := Cust.acDeliveryCountry;
      End // If (Trim(Cust.DAddr[1]) <> '')
      Else
      Begin
        DelAddr := Cust.Addr;
        // MH 11/02/2015 v7.1 ABSEXCH-16142: Added ISO Country Code fields
        acDelCntry := Cust.acCountry;
      End; // Else

      AcPhone := Cust.Phone;
      AcFax   := Cust.Fax;
      AcCont  := Cust.Contact;

      // MH 21/08/2017 2017-R2 ABSEXCH-18163: Added Head Office PostCode fields
      acPostCode := Cust.PostCode;

      TmpKey:=GetPosKey;

      { Check its not already loaded }
      If (AcNo <> Cust.CustCode) Then Begin
        TmpStat:=Presrv_BTPos(Fnum,TmpKey,F[Fnum],TmpRecAddr,BOff,BOff);

        OCust:=Cust;

        If GetCust(Application.MainForm, AcNo, TmpStr, Not (TInv.InvDocHed In PurchSplit), -1) Then Begin
          CoName  := Cust.Company;
          AcAddr  := Cust.Addr;
          // MH 11/02/2015 v7.1 ABSEXCH-16142: Added ISO Country Code fields
          acCntry := Cust.acCountry;
          If (Trim(Cust.DAddr[1]) <> '') Then
          Begin
            DelAddr := Cust.DAddr;
            // MH 11/02/2015 v7.1 ABSEXCH-16142: Added ISO Country Code fields
            acDelCntry := Cust.acDeliveryCountry;
          End // If (Trim(Cust.DAddr[1]) <> '')
          Else
          Begin
            DelAddr := Cust.Addr;
            // MH 11/02/2015 v7.1 ABSEXCH-16142: Added ISO Country Code fields
            acDelCntry := Cust.acCountry;
          End; // Else

          AcPhone := Cust.Phone;
          AcFax   := Cust.Fax;
          AcCont  := Cust.Contact;
          AcDelPostcode := Cust.acDeliveryPostcode; //PR: 18/10/2013 ABSEXCH-14703 Added delivery address postcode

          // MH 21/08/2017 2017-R2 ABSEXCH-18163: Added Head Office PostCode fields
          acPostCode := Cust.PostCode;
        End; { If }

        TmpStat:=Presrv_BTPos(Fnum,TmpKey,F[Fnum],TmpRecAddr,BOn,BOff);

        Cust:=OCust;
      End; { If }

      Case FNo Of
        1      : Result := CoName;
        2..6   : Result := AcAddr[Fno-1];
        7..11  : Result := DelAddr[Fno-6];
        12     : Result := AcPhone;
        13     : Result := AcFax;
        14     : Result := AcCont;
        17     : Result := AcDelPostcode; //PR: 18/10/2013 ABSEXCH-14703 Added delivery address postcode
        // MH 11/02/2015 v7.1 ABSEXCH-16142: Added ISO Country Code fields
        18     : Result := acCntry;
        19     : Result := CountryCodeName (ifCountry2, acCntry);
        20     : Result := acDelCntry;
        21     : Result := CountryCodeName (ifCountry2, acDelCntry);
        // MH 21/08/2017 2017-R2 ABSEXCH-18163: Added Head Office PostCode fields
        22     : Result := acPostCode;
      End; { Case }
    End;  { GetInvToDets }

    //------------------------------

    // Returns the date of the last payment/reciept added for the current customer/supplier
    // Based on TCredThread.LastPaid_Scan in R&D\CredPopU.Pas
    Function LastPaymentDate : ShortString;
    Var
      FoundOk       : Boolean;
      KeyChk, KeyS  : Str255;
      lStatus       : SmallInt;
    Begin // LastPaymentDate
      With TBtrieveSavePosition.Create Do
      Begin
        Try
          // Save the current position in the file for the current key
          SaveFilePosition (InvF, GetPosKey);
          SaveDataBlock (@Inv, SizeOf(Inv));

          //------------------------------

          FoundOk:=BOff;

          KeyChk := Cust.CustSupp + FullCustCode(Cust.CustCode);
          KeyS   := KeyChk + NdxWeight;
          lStatus := Find_Rec(B_GetLessEq, F[InvF], InvF, RecPtr[InvF]^, InvCDueK, KeyS);

          While (lStatus = 0) And CheckKey (KeyChk, KeyS, Length(KeyChk), BOn) And (Not FoundOk) Do
          Begin
            FoundOk := (Inv.InvDocHed In RecieptSet);

            If (Not FoundOk) then
              lStatus := Find_Rec (B_GetPrev, F[InvF], InvF, RecPtr[InvF]^, InvCDueK, KeyS);
          End; // While (lStatus = 0) ...

          If FoundOk then
            Result := Inv.TransDate
          Else
            Result := '';

          //------------------------------

          // Restore position in file
          RestoreSavedPosition;
          RestoreDataBlock (@Inv);
        Finally
          Free;
        End; // Try..Finally
      End; // With TBtrieveSavePosition.Create
    End; // LastPaymentDate

    //------------------------------

    {$IFDEF REP_ENGINE}
    Function GetAcField (Const AcCode : ShortString; Const FieldIdx : Byte) : ShortString;
    Var
      TmpStr : Str20;
    Begin // GetAcField
      Result := '';

      // Blank out the record if the A/C Code is blank
      If (Trim(AcCode) <> '') Then
      Begin
        // Dion't reload if already loaded
        If (Trim(AcCode) <> Trim(TCust^.CustCode)) Then
        Begin
          // Save the existing position and data and restore afterwards
          With TBtrieveSavePosition.Create Do
          Begin
            Try
              // Save the current position in the file for the current key
              SaveFilePosition (CustF, GetPosKey);
              SaveDataBlock (@Cust, SizeOf(Cust));

              //------------------------------

              If GetCust(Application.MainForm, AcCode, TmpStr, (Cust.CustSupp='C'), -1) Then
              Begin
                Case FieldIdx Of
                  1    : Result := Cust.CustCode;
                  2    : Result := Cust.Company;
                  3..7 : Result := Cust.Addr[FieldIdx - 2];
                End; // Case FieldIdx
              End; // If GetCust(...

              //------------------------------

              // Restore position in file
              RestoreSavedPosition;
              RestoreDataBlock (@Cust);
            Finally
              Free;
            End; // Try..Finally
          End; // With TBtrieveSavePosition.Create
        End; // If (Trim(AcCode) <> Trim(TCust^.CustCode)
      End; // If (Trim(AcCode) <> '')
    End; // GetAcField
    {$ENDIF}

    //------------------------------

  Begin

    TmpField  := '';
    TmpField2 := '';

    With Cust do
    Case DictNo of

      1000  :  TmpField:=CustCode;                     {* Account Code *}
      1001  :  TmpField:=Company;                      {* Account Name *}
      1002..1006
            :   TmpField:=Addr[DictNo-1001];           {* Account Addr 1-5 *}
      1007  :   TmpField:=YesNoBo(DespAddr);           {* Has Del Address *}

      1008..1012
            :   TmpField:=DAddr[DictNo-1007];          {* Del Address 1-5 *}

      1013  :   TmpField:=Contact;                     {* Contact *}

      1014  :   TmpField:=Phone;                       {* Phone *}
      1015  :   TmpField:=Fax;                         {* Fax *}
      1016  :   TmpField:=Form_Real(CreditLimit,0,2);  {* Credit Limit *}
      1017  :   TmpField:=RefNo;                       {* Our Ref with them *}
      1018  :   TmpField:=RemitCode;                   {* HO / statement Code *}
      1019  :   TmpField:=YesNoBo(TradTerm);           {* Trading Terms? *}
      1020..1021                                       {* Trading Terms 1/2 *}
            :   TmpField:=Sterms[DictNo-1019];
      1022  :   TmpField:=Form_Int(Currency,0);        {* Currency *}
      1046  :   TmpField:=PSymb (Currency);
      1023  :   TmpField:=VATCode;                     {* Default VATCode *}
      1024  :   TmpField:=YesNoBo(EECMember);          {* EC member *}
      1025  :   TmpField:=VATRegNo;                    {* Vat Reg No *}
      1026  :   TmpField:=Form_Int(PayTerms,0);        {* Payment Terms Days *}
      1027  :   Begin                                  {* Default Line Discount *}

                  TmpField:=Form_Real(Discount,0,5);
                end;
      1028  :   TmpField:=CustCC;                      {* Default CC Code*}
      1029  :   TmpField:=CustDep;                     {* Default CC Code*}
      1030  :   TmpField:=Form_Int(DefNomCode,0);      {* Default CC Code*}
      1031  :   TmpField:=DefMLocStk;                  {* Default Multi Loc Stk *}
      1032  :   TmpField:=YesNoBo(IncStat);            {* Print Statement for *}
      1033  :   TmpField:=Form_Int(CreditStatus,0);    {* Last Credit status (Weeks) *}
      1034  :   TmpField:=Form_Int(AccStatus,0);       {* Account status  *}
      1035  :   TmpField:=AreaCode;                    {* Account Area Code *}
      1036  :   TmpField:=RepCode;                     {* Rep Code *}
      1037  :   TmpField:=PayType;                     {* Default payment type *}

      1038  :   {$IFNDEF FORMTK}
                // MH 31/03/2011 v6.7 ABSEXCH-10689: Added check on View Bank/Card Details permission
                If ((CustSupp = TradeCode[True]) and PChkAllowed_In(uaCustomerViewBankDets)) Or ((CustSupp = TradeCode[False]) and PChkAllowed_In(uaSupplierViewBankDets)) Then
                {$ENDIF}
                  // MH 06/08/2013 MRD1.7.16 - SEPA/IBAN Changes
                  //TmpField:=BankAcc;                     {* Bank Account *}
                  TmpField:=DecryptBankAccountCode(acBankAccountCode);

      1039  :   {$IFNDEF FORMTK}
                // MH 31/03/2011 v6.7 ABSEXCH-10689: Added check on View Bank/Card Details permission
                If ((CustSupp = TradeCode[True]) and PChkAllowed_In(uaCustomerViewBankDets)) Or ((CustSupp = TradeCode[False]) and PChkAllowed_In(uaSupplierViewBankDets)) Then
                {$ENDIF}
                  // MH 06/08/2013 MRD1.7.16 - SEPA/IBAN Changes
                  //TmpField:=BankSort;                    {* Bank Sort *}
                  TmpField:=DecryptBankSortCode(acBankSortCode);

      1040  :   {$IFNDEF FORMTK}
                // MH 31/03/2011 v6.7 ABSEXCH-10689: Added check on View Bank/Card Details permission
                If ((CustSupp = TradeCode[True]) and PChkAllowed_In(uaCustomerViewBankDets)) Or ((CustSupp = TradeCode[False]) and PChkAllowed_In(uaSupplierViewBankDets)) Then
                {$ENDIF}
                  TmpField:=BankRef;                     {* Bank Ref *}

      // MH 06/08/2013 MRD1.7.17 - SEPA/IBAN Changes
      // ACMANDID - Direct Debit Mandate ID
      1082  :   {$IFNDEF FORMTK}
                // Check on View Bank/Card Details permission
                If ((CustSupp = TradeCode[True]) and PChkAllowed_In(uaCustomerViewBankDets)) Or ((CustSupp = TradeCode[False]) and PChkAllowed_In(uaSupplierViewBankDets)) Then
                {$ENDIF}
                  TmpField:= DecryptBankMandateId(acMandateID);

      // MH 06/08/2013 MRD1.7.17 - SEPA/IBAN Changes
      // ACMANDDA - Direct Debit Mandate Date
      1083  :   {$IFNDEF FORMTK}
                // Check on View Bank/Card Details permission
                If ((CustSupp = TradeCode[True]) and PChkAllowed_In(uaCustomerViewBankDets)) Or ((CustSupp = TradeCode[False]) and PChkAllowed_In(uaSupplierViewBankDets)) Then
                {$ENDIF}
                  TmpField:= acMandateDate;

      1041,
      1042  :   Begin                                  {* CC/Dep Desc *}

                  Case DictNo of
                    1041  :  TmpField2:=CustCC;
                    1042  :  TmpField2:=CustDep;
                  end; {Case..}

                  // HM 18/03/02: Modified as OK wasn't being set and it was also using a global OK variable
                  OK := GetCCDep(Application.MainForm,
                                 TmpField2,
                                 TmpField2,
                                 (DictNo=1041),
                                 -1);

                  If (Ok) then
                    TmpField:=PassWord.CostCtrRec.CCDesc
                  else
                    TmpField:='';

                end;

      1043  :   Begin                                  {* Default Line Discount Char *}

                  TmpField:=CDiscCh;
                end;

      1044  : TmpField:=Phone2;                      {* Mobile Phone *}
      1045  : TmpField:=Form_Int(DefCOSNom,0);      {* Default COS Nomianl Code*}

      1048  : TmpField := SOPInvCode;               { Invoice to }
      1049  : TmpField := YesNoBo(SOPAutoWOff);     { Auto Write Off }
      1050  : TmpField := UserDef1;                 { User Defined Field 1 }
      1051  : TmpField := UserDef2;                 { User Defined Field 2 }

      1200..1201
            : If (TCust.TradTerm) then
                TmpField:=LJ(TCust.STerms[DictNo-1199],TradTermLen)                        {* Doc Trading Term Mes *}
              else
                TmpField:=LJ(Syss.TermsofTrade[DictNo-1199],TradTermLen);

      {$IFNDEF REP_ENGINE}
        // SbsForm, Windows RW, etc...
        1203  : TmpField := TCust^.CustCode;                               {* Acc Code *}
        1204  : TmpField := TCust^.Company;                               {* Cust Company Name *}
        1205..1209
              : TmpField := TCust^.Addr[(DictNo-1204)];                       {* Cust Addr 1-4 *}
      {$ELSE}
        // MH 06/02/07: Modified behaviour for VRW
        1203  : TmpField := GetAcField(Cust.RemitCode, 1);  // H/O Code
        1204  : TmpField := GetAcField(Cust.RemitCode, 2);  // H/O Company Name
        1205..1209
              : TmpField := GetAcField(Cust.RemitCode, DictNo-1202);  // H/O Company Address 1-5
      {$ENDIF}

      { Last Invoice - Transaction Date }
      1210  : TmpField := LastStateInv.TransDate;

      { Last Invoice - Date Due }
      1211  : TmpField := LastStateInv.DueDate;

      // MH 12/04/06: Added Postcode for v5.71
      1212  : TmpField := TCust^.PostCode;

      // MH 03/11/06: v5.71 - Wish 20060607153710
      // ACUSEEB - Use this A/C for e-Business
      1213  : TmpField := YesNoBo(AllowWeb <> 0);

      // MH 11/02/2015 v7.1 ABSEXCH-16142: Added ISO Country Code fields
      // CUCNTRY - Country Code
      1214  : TmpField := TCust^.acCountry;
      // CUCNTRYN - Country Name
      1215  : TmpField := CountryCodeName (ifCountry2, TCust^.acCountry);

      1500..1506
            :   With Cust do                           {* Accout period balances. *}
                Begin                                  {  0 = balance, 1 =Sales, 2= cost, 3= Margin, 4 = Debit }
                                                       {  5 = Credit, 6 = Budget }

                  TmpField:=Form_Real(GetCustStats(CustCode,DictNo-1500,(CustSupp=TradeCode[True]),DictLink),0,2);

                end;

    { ============ Statment / Trading History Specifics ============ }

      1600..1607,  { Currency 0 (Base) }                                                {* Statment Aged by currency *}
      1610..1617,  { Currency 1        }
      1620..1627,  { Currency 2        }
      1630..1637,  { Currency 3        }
      1640..1647,  { Currency 4        }
      1650..1657,  { Currency 5        }
      1660..1667,  { Currency 6        }
      1670..1677,  { Currency 7        }
      1680..1687,  { Currency 8        }
      1690..1697,  { Currency 9        }
      1700..1707,  { Currency 10       }
      1710..1717,  { Currency 11       }
      1720..1727,  { Currency 12       }
      1730..1737,  { Currency 13       }
      1740..1747,  { Currency 14       }
      1750..1757,  { Currency 15       }
      1760..1767,  { Currency 16       }
      1770..1777,  { Currency 17       }
      1780..1787,  { Currency 18       }
      1790..1797,  { Currency 19       }
      1800..1807,  { Currency 20       }
      1810..1817,  { Currency 21       }
      1820..1827,  { Currency 22       }
      1830..1837,  { Currency 23       }
      1840..1847,  { Currency 24       }
      1850..1857,  { Currency 25       }
      1860..1867,  { Currency 26       }
      1870..1877,  { Currency 27       }
      1880..1887,  { Currency 28       }
      1890..1897   { Currency 29       }
          : Begin
              Ino:=Round((((Int(DictNo/10)*10)-1600)/10));

              {Def_OverRLen(FCtrl,IMask,ITot2No);}

              {TmpField:=PPR(CurrAged[Ino]^[DictNo-(1600+(INo*10))],IMask);}
              TmpField := Form_Real(CurrAged[Ino]^[DictNo-(1600+(INo*10))],0,2);
            end;


      { Disc inc % symbol }
      1047  : TmpField:=PPR_PAmountStr(Discount, CDiscCh);

      1510..1516
            :   With Cust do                           {* Accout period balances. *}
                Begin                                  {  0 = balance, 1 =Sales, 2= cost, 3= Margin, 4 = Debit }
                                                       {  5 = Credit, 6 = Budget }
                  DictLink2 := DictLink;
                  With DictLink2 Do Begin
                    DCr  := 0;
                    DPr  := YTD;
                    DYr  := Syss.CYr;
                  End; { With }

                  TmpField:=Form_Real(GetCustStats(CustCode,DictNo-1510,(CustSupp=TradeCode[True]),DictLink2),0,2);
                End;

      1052    : TmpField := LastUsed;
      1053    : TmpField := Form_Int(DefCtrlNom,0);

      { HM 23/06/98: Customer Credit Card fields added }
      { Start Date }
      1054    : {$IFNDEF FORMTK}
                // MH 31/03/2011 v6.7 ABSEXCH-10689: Added check on View Bank/Card Details permission
                If ((CustSupp = TradeCode[True]) and PChkAllowed_In(uaCustomerViewBankDets)) Or ((CustSupp = TradeCode[False]) and PChkAllowed_In(uaSupplierViewBankDets)) Then
                {$ENDIF}
                  TmpField := CCDSDate;

      { End Date }
      1055    : {$IFNDEF FORMTK}
                // MH 31/03/2011 v6.7 ABSEXCH-10689: Added check on View Bank/Card Details permission
                If ((CustSupp = TradeCode[True]) and PChkAllowed_In(uaCustomerViewBankDets)) Or ((CustSupp = TradeCode[False]) and PChkAllowed_In(uaSupplierViewBankDets)) Then
                {$ENDIF}
                  TmpField := CCDEDate;

      { Name }
      1056    : {$IFNDEF FORMTK}
                // MH 31/03/2011 v6.7 ABSEXCH-10689: Added check on View Bank/Card Details permission
                If ((CustSupp = TradeCode[True]) and PChkAllowed_In(uaCustomerViewBankDets)) Or ((CustSupp = TradeCode[False]) and PChkAllowed_In(uaSupplierViewBankDets)) Then
                {$ENDIF}
                  TmpField := CCDName;
      { Credit Card No. }
      1057    : {$IFNDEF FORMTK}
                // MH 31/03/2011 v6.7 ABSEXCH-10689: Added check on View Bank/Card Details permission
                If ((CustSupp = TradeCode[True]) and PChkAllowed_In(uaCustomerViewBankDets)) Or ((CustSupp = TradeCode[False]) and PChkAllowed_In(uaSupplierViewBankDets)) Then
                {$ENDIF}
                  TmpField := CCDCardNo;
      { Switch Ref }
      1058    : {$IFNDEF FORMTK}
                // MH 31/03/2011 v6.7 ABSEXCH-10689: Added check on View Bank/Card Details permission
                If ((CustSupp = TradeCode[True]) and PChkAllowed_In(uaCustomerViewBankDets)) Or ((CustSupp = TradeCode[False]) and PChkAllowed_In(uaSupplierViewBankDets)) Then
                {$ENDIF}
                  TmpField := CCDSARef;

      { HM 13/10/99: Fields added for v4.31 }

      { Email Address }
      1059    : TmpField := EmailAddr;
      { Post Code }
      1060    : TmpField := PostCode;
      { Alternative look up code }
      1061    : TmpField := CustCode2;
      { User Defined 3 & 4 }
      1062    : TmpField := UserDef3;
      1063    : TmpField := UserDef4;
      { Web Catalogues }
      1064    : TmpField := WebLiveCat;
      { Country of VAT registration }
      1065    : TmpField := VATRetRegC;
      { Default SSD Delivery Terms }
      1066    : TmpField := SSDDelTerms;
      { Default SSD Method Of Transport }
      1067    : TmpField := Form_Int(SSDModeTr,0);

      { Settlement discount % }
      1068    : TmpField := Form_Real(DefSetDisc,0,2);
      { Settlement Disount Days }
      1069    : TmpField := Form_Int(DefSetDDays,0);

      // HM 13/11/01: Added ACACTYPE - Account Type (C/S) for Sentimail
      1070    : TmpField := CustSupp;

      { Invoice To derived fields }
      1100,         { Company Name }
      1101..1105,   { Address }
      1106..1110,   { Delivery Address }
      1111,         { Phone }
      1112,          { Fax }
      1116          //PR: 18/10/2013 ABSEXCH-14703 Added delivery address postcode ACINDELP
              : TmpField := GetInvToDets (DictNo-1099, SOPInvCode);
      // MH 11/02/2015 v7.1 ABSEXCH-16142: Added ISO Country Code fields
      // ACINCTRY - Invoice To - Country Code
      1117    : TmpField := GetInvToDets (18, SOPInvCode);
      // ACINCTRN - Invoice To - Country Name
      1118    : TmpField := GetInvToDets (19, SOPInvCode);
      // ACINDCTY - Inv To - Delivery Country Code
      1119    : TmpField := GetInvToDets (20, SOPInvCode);
      // ACINDCTN - Inv To - Delivery Country Name
      1120    : TmpField := GetInvToDets (21, SOPInvCode);
      // MH 21/08/2017 2017-R2 ABSEXCH-18163: Added Head Office PostCode fields
      // ACINPOCO - Invoice To - Postcode
      1123   : TmpField := GetInvToDets (22, SOPInvCode);

      // HM 31/01/05: Added
      1114    : TmpField := GetInvToDets (14, SOPInvCode); // Invoice To - Contact
      1115    : TmpField := Form_Int(FDefPageNo,0); // Form Set Number

      // HM 27/06/01: v4.32.001
      1113    : TmpField := CVATIncFlg;

      { HM 25/03/02 - Added missing v5.00 fields }
      1071    : TmpField := Form_Int(DefTagNo,0);

      // HM 30/05/03: Added Paperless send methods
      // Statement / Remittance
      1072    : TmpField := Form_Int(StatDMode,0);
      // Invoice
      1073    : TmpField := Form_Int(InvDMode, 0);

      // HM 27/07/044: Added Last Payment/Receipt date for wish 200431124150
      // ACLASTPA - Last Payment/Receipt Date
      1074    : TmpField := LastPaymentDate;

      // MH 24/10/2011 v6.9 ABSEXCH-11706: Added new Customer/Supplier User Defined Fields
      1075    : TmpField := UserDef5;
      1076    : TmpField := UserDef6;
      1077    : TmpField := UserDef7;
      1078    : TmpField := UserDef8;
      1079    : TmpField := UserDef9;
      1080    : TmpField := UserDef10;


      // MH 01/10/2013 v7.XMRD MRD1.1.38: Added Consumer Support
      // ACSUBTYP - SubType (C/S/U)
      1086    : TmpField := acSubType;
      // ACLONGCO - Long A/C Code
      1087    : TmpField := acLongACCode;
      // CULONGCO - Long A/C Code
      1088    : TmpField := TCust^.acLongACCode;

      // MH 02/10/2014 Order Payments: Added new fields
      // ACORDPAY - Allow Order Payments Y/N
      1089    : TmpField := YesNoBo(acAllowOrderPayments);
      // ACORDPGL - Order Payments GL Code
      1090    : TmpField := Form_Int(acOrderPaymentsGLCode,0);

      // MH 26/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Codes
      // ACCNTRY - Country Code
      1091    : TmpField := acCountry;
      // ACCNTRN - Country Name
      1092    : TmpField := CountryCodeName (ifCountry2, acCountry);
      // ACDELCTY - Delivery Country Code
      1093    : TmpField := acDeliveryCountry;
      // ACDELCTN - Delivery Country Name
      1094    : TmpField := CountryCodeName (ifCountry2, acDeliveryCountry);

     {$If Defined(EDLL)}
      // HM 26/07/04: Added OC (Original Cust) Fields for use on Remittance Advices
      // OCACC - Account Code
      1300    : TmpField := OrigPrnCust^.CustCode;
      // OCCOMP - Company Name
      1301  :  TmpField :=OrigPrnCust^.Company;
     {$IfEnd}

      //PR: 18/10/2013 ABSEXCH-14703 Added delivery address postcode ACDELPC
      1084 : TmpField := acDeliveryPostcode;

      // ACPPDMO - PPD Mode
      1095 : TmpField := Form_Int(Ord(acPPDMode), 0);
      // ACPPDMOD - PPD Mode Description
      1096 : Case acPPDMode Of
               pmPPDDisabled                         : TmpField := 'Disabled';
               pmPPDEnabledWithAutoJournalCreditNote : TmpField := 'Enabled - Auto ' + IfThen (CustSupp = 'C', 'SJC', 'PJC');
               pmPPDEnabledWithAutoCreditNote        : TmpField := 'Enabled - Auto ' + IfThen (CustSupp = 'C', 'SCR', 'PCR');
               pmPPDEnabledWithManualCreditNote      : TmpField := 'Enabled - Manual ' + IfThen (CustSupp = 'C', 'SCR', 'PCR');
             End; // Case acPPDMode

      // PKR. 22/01/2016. ABSEXCH-17109. Added Default to QR field for Intrastat, plus copy field.
      // ACIDEFQR - Intrastat - Default to QR Code
      1121: TmpField := YesNoBo(acDefaultToQR);
      // CUIDEFQR - Intrastat - Default to QR Code
      1122: TmpField := YesNoBo(TCust^.acDefaultToQR);

      // SSK 20/11/2017 2018 R1 ABSEXCH-19383: Added new anonymous fields for CUST/SUPP table
      //ACANONST (AnonymisationStatus)
      1124: TmpField := Form_Int(Ord(acAnonymisationStatus), 0);

      //ACANONDT (AnonymisedDate)
      1125: TmpField := acAnonymisedDate;

      //ACANONTM (Anonymised Time)
      1126: if trim(acAnonymisedTime) <>'' then
              TmpField := Str6ToScreenTime(acAnonymisedTime)
            else
              TmpField := '';


    end; {Case..}

    Link_CustDict:=TmpField;

  end; {Func..}


  { ====== Function to return signed value ====== }

  Function DocSign(Rnum  :  Double;
                   DT    :  DocTypes)  :  Double;

  Begin
    DocSign:=Rnum*DocCnst[DT]*DocNotCnst;
  end;



    { ========= Function to Return Document Dict Values ======== }

  Function Link_DocDict(DictNo, PixWidth : LongInt)  :  Str255;

  Var
    TmpField  : Str255;
    VT        : VATType;

    Rnum      : Double;
    {ExLocal   : TDExLocal;}
    Idx, INo  : Integer;
    CrDr      : DrCrType;
    FirstCC, WhichCC : Boolean;
    LastCCDep :  CCDepType;
    Dummy     : Str20;
    LastIdDate:  LongDate;
    UOR       : Byte;
    LI        : LongInt;
    SList     : TStringList;


    Procedure DocCCDep(IFol    :  LongInt;
                   Var ICCDep  :  CCDepType;
                       GetCC,
                       GetFirst:  Boolean);
    Const
      Fnum     =  IDetailF;
      Keypath  =  IdFolioK;
    Var
      KeyS, KeyChk              :  Str255;
      TmpId                     :  IDetail;
      FoundOk                   :  Boolean;
      B_Func, TmpKPath, TmpStat :  Integer;
      TmpRecAddr                :  LongInt;
    Begin
      FoundOk:=BOff;

      TmpId:=Id;

      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      KeyChk:=FullNomKey(IFol);

      If (GetFirst) then Begin
        B_Func:=B_GetGEq;

        KeyS:=FullIdKey(IFol,1);
      end
      else Begin
        B_Func:=B_GetLessEq;
        KeyS:=FullIdKey(IFol,Pred(RecieptCode));
      end;

      Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
        With Id do Begin
          FoundOk:= Not EmptyKey(CCDep[GetCC],CCKeyLen);

          If (Not FoundOk) then Begin
            If (GetFirst) then
              B_Func:=B_GetNext
            else
              B_Func:=B_GetPrev;

            Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
          end;
        end; { With }

      If (FoundOk) then
        ICCDep:=Id.CCDep;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      Id:=TmpId;
    end; {Proc..}


    Function Short_Oref(FOurRef  :  Str20)  :  Str20;
    Begin
      Result := Copy(FOurRef,1,3)+Strip('L',['0'],Copy(FOurRef,4,Length(FOurRef)-3));
    end; {Func..}

    //------------------------------

    { SPOP Link to Original Site Address }
    Function Get_OrigOrdAddr(      Lno          :  Byte;
                                   SORNo        :  Str20;
                             Const MatchOurRef  : ShortString = '';
                             Const MatchDocType : DocTypes = NMT)  :  ShortString;
    Const
      Fnum     =  InvF;
      Keypath  =  InvOurRefK;
      Fnum2    =  CustF;
    Var
      TmpStat, TmpKey1, TmpKey2 : Integer;
      TmpRecAddr, TmpRecAddr2   : LongInt;
      KeyS, KeyChk              : Str255;
      OrdAddr, DelAddr          : AddrTyp;
      CoName                    : String[45];
      OCust                     : CustRec;
      OInv                      : InvRec;
      TmpStr                    : Str20;
      TmpStr2                   : ShortString;
      TmpDate                   : LongDate;
      OrdAcc                    : String[10];

      // MH 11/02/2015 v7.1 ABSEXCH-16144: Added ISO Country Code fields
      OrdCountry                : String[2];
      // MH 21/08/2017 2017-R2 ABSEXCH-18163: Added Head Office PostCode fields
      OrdPostCode               : Str20;


      //------------------------------

      Procedure CopyTransactionFields;
      Begin // CopyTransactionFields
        With Inv Do
        Begin
          DelAddr:=Inv.DAddr;
          OrdAcc := Inv.CustCode;

          Case LNo Of
            11 : TmpDate := TransDate;
            12 : TmpDate := DueDate;
            14 : TmpStr2 := TransDesc;   // alt Ref
            15 : TmpStr2 := YourRef;
            16 : TmpStr2 := DocUser1;
            17 : TmpStr2 := DocUser2;
            18 : TmpStr2 := DocUser3;
            19 : TmpStr2 := DocUser4;

            //PR: 18/10/2013 ABSEXCH-14703
            20 : TmpStr2 := thDeliveryPostcode;

            // MH 28/10/2013 v7.0.7 ABSEXCH-14705: Added Transaction Originator fields
            21 : TmpStr2 := thOriginator;
            22 : TmpStr2 := thCreationTime;
            23 : TmpStr2 := thCreationDate;

            // MH 26/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Codes
            24 : TmpStr2 := thDeliveryCountry;
          End; { Case }

          OCust:=Cust;
          TmpStat:=Presrv_BTPos(Fnum2,TmpKey2,F[Fnum2],TmpRecAddr2,BOff,BOff);
          Try
            If GetCust(Application.MainForm,
                       CustCode,
                       TmpStr,
                       Not (TInv.InvDocHed In PurchSplit),
                      -1) Then
            Begin
              OrdAddr:=Cust.Addr;
              CoName:=Cust.Company;

              // MH 11/02/2015 v7.1 ABSEXCH-16144: Added ISO Country Code fields
              OrdCountry := Cust.acCountry;

              // MH 21/08/2017 2017-R2 ABSEXCH-18163: Added Head Office PostCode fields
              OrdPostCode := Cust.PostCode;
            End; // If GetCust
          Finally
            TmpStat:=Presrv_BTPos(Fnum2,TmpKey2,F[Fnum2],TmpRecAddr2,BOn,BOff);
            Cust:=OCust;
          End; // Try..Finally
        End; // With Inv
      End; // CopyTransactionFields

      //------------------------------

    Begin // Get_OrigOrdAddr
      OrdAddr:=Cust.Addr;
      // MH 11/02/2015 v7.1 ABSEXCH-16144: Added ISO Country Code fields
      OrdCountry := Cust.acCountry;
      CoName:=Cust.Company;
      DelAddr:=Inv.DAddr;
      // MH 21/08/2017 2017-R2 ABSEXCH-18163: Added Head Office PostCode fields
      OrdPostCode := Cust.PostCode;

      OrdAcc:='';
      TmpStr2 := '';

      TmpKey1:=GetPosKey;
      TmpKey2:=GetPosKey;

      // HM 14/05/02: Modified to ensure that it is always formatted correctly
      SORNO := FullOurRefKey(SORNO);

      If (SORNo<>Inv.OurRef) then
      Begin
        // we need to look for original order - save the current transaction
        OInv:=Inv;
        TmpStat:=Presrv_BTPos(Fnum,TmpKey1,F[Fnum],TmpRecAddr,BOff,BOff);
        Try
          KeyS:=SORNo;
          Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

          If (StatusOk) then
          Begin
            // Got Order - Copy Fields out
            CopyTransactionFields;
          End // If (StatusOk)
          Else
          Begin
            // Your Ref does not contain the Order Number - try looking the order
            // up in the matching database
            If (Trim(MatchOurRef) <> '') And (MatchDocType In [SDN, SIN, PDN, PIN]) Then
            Begin
              KeyS := MatchTCode + MatchSCode + MatchOurRef;
              KeyChk := KeyS;

              TmpStat := Find_Rec(B_GetGEq, F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK, KeyS);
              While (TmpStat = 0) And (CheckKey (KeyChk, KeyS, Length(KeyChk), BOn)) Do
              Begin
                // Check that its Order Processing Matching and that the Transaction Type is
                // correct for the transaction type of the delivery note/invoice
                If (Password.MatchPayRec.MatchType = 'O') And
                   (((MatchDocType In [SDN, SIN]) And (Copy(Password.MatchPayRec.PayRef, 1, 3) = 'SOR')) Or
                    ((MatchDocType In [PDN, PIN]) And (Copy(Password.MatchPayRec.PayRef, 1, 3) = 'POR'))) Then
                Begin
                  // Got Order - Copy Fields out
                  KeyS:=Password.MatchPayRec.PayRef;
                  TmpStat:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyS);
                  If (TmpStat = 0) Then
                  Begin
//ShowMessage ('Matching Lookup: ' + Inv.OurRef);
                    CopyTransactionFields;
                  End; // If (TmpStat = 0)

                  TmpStat := -99;   // Exit Loop
                End // If ...
                Else
                Begin
                  TmpStat := Find_Rec(B_GetNext, F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK, KeyS);
                End; // Else
              End; //
            End; // If (Trim(MatchOurRef) <> '')
          End; // Else
        Finally
          TmpStat:=Presrv_BTPos(Fnum,TmpKey1,F[Fnum],TmpRecAddr,BOn,BOff);
          Inv:=OInv;
        End; // Try..Finally
      end;

      {If (Lno<1) then
        Get_OrigOrdAddr:=CoName
      else
        Get_OrigOrdAddr:=OrdAddr[Lno];}

      Case LNo Of
        0      : Get_OrigOrdAddr:=CoName;
        1..5   : Get_OrigOrdAddr:=OrdAddr[Lno];
        6..10  : Get_OrigOrdAddr:=DelAddr[Lno-5];

        11, 12 : Result := TmpDate;

        13     : Result := OrdAcc;

        //PR: 18/10/2013 ABSEXCH-14703 Add 20 for thDeliveryPostcode
        14..20 : Result := TmpStr2;

        // MH 28/10/2013 v7.0.7 ABSEXCH-14705: Added Transaction Originator fields
        21..23 : Result := TmpStr2;

        // MH 26/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Codes
        24 : Result := TmpStr2;

        // MH 11/02/2015 v7.1 ABSEXCH-16144: Added ISO Country Code fields
        25 : Result := OrdCountry;
        26 : Result := CountryCodeName (ifCountry2, OrdCountry);

        // MH 21/08/2017 2017-R2 ABSEXCH-18163: Added Head Office PostCode fields
        27 : Result := OrdPostCode;
      End; // Case LNo
    End;  // Get_OrigOrdAddr

    //------------------------------

    // Return i as a string of words, ie "one thousand, six hundred and twenty four"
    function Long2Words (i : LongInt) : string;
    var
      WorkStr     : string;
      LessMillion : LongInt;
      ModConst    : LongInt;

     function Digit2Word (i : longint) : string;
     begin
       case i of
          1  :   Digit2Word := 'one ';
          2  :   Digit2Word := 'two ';
          3  :   Digit2Word := 'three ';
          4  :   Digit2Word := 'four ';
          5  :   Digit2Word := 'five ';
          6  :   Digit2Word := 'six ';
          7  :   Digit2Word := 'seven ';
          8  :   Digit2Word := 'eight ';
          9  :   Digit2Word := 'nine ';
         10  :   Digit2Word := 'ten ';
         11  :   Digit2Word := 'eleven ';
         12  :   Digit2Word := 'twelve ';
         13  :   Digit2Word := 'thirteen ';
         14  :   Digit2Word := 'fourteen ';
         15  :   Digit2Word := 'fifteen ';
         16  :   Digit2Word := 'sixteen ';
         17  :   Digit2Word := 'seventeen ';
         18  :   Digit2Word := 'eighteen ';
         19  :   Digit2Word := 'nineteen ';
       else
         Digit2Word := '';
       end; { case }
     end;

     function Ten2Word (i : longint) : string;
     begin
       case i of
          2  :   Ten2Word := 'twenty ';
          3  :   Ten2Word := 'thirty ';
          4  :   Ten2Word := 'forty ';
          5  :   Ten2Word := 'fifty ';
          6  :   Ten2Word := 'sixty ';
          7  :   Ten2Word := 'seventy ';
          8  :   Ten2Word := 'eighty ';
          9  :   Ten2Word := 'ninety ';
       else
         Ten2Word := '';
       end; { case }
     end;

     function HunFn (i : longint) : string;
     { 0..999 }
     var
       TensAndUnitsStr, WorkStr : string;
     begin
       WorkStr := '';

       if (i > 99) then begin
         { 100..999 }
         WorkStr := Digit2Word (i div 100) + 'hundred ';
         i := i mod 100;
       end;

       { 0..99 }
       if (i < 20) then
         { 0..19 }
         TensAndUnitsStr := Digit2Word (i)
       else
         TensAndUnitsStr := Ten2Word (i div 10) + Digit2Word (i mod 10);

       if (length (TensAndUnitsStr) > 0) and (length (WorkStr) > 0) then
         HunFn := WorkStr + 'and ' + TensAndUnitsStr
       else
         HunFn := WorkStr + TensAndUnitsStr;
     end;

     function ThouFn (i : longint) : string;
     { 1..999999 }
     var
       HunStr, WorkStr : string;
     begin
       WorkStr := '';

       if (i > 999) then begin
         { 1000..999999 }
         WorkStr := HunFn (i div 1000) + 'thousand';
         i := i mod 1000;
       end;

       { 0..999 }
       HunStr := HunFn (i);
       if (i > 100) and (length (WorkStr) > 0) then
         ThouFn := WorkStr + ', ' + HunStr
       else begin
         if (length (HunStr) > 0) and (length (WorkStr) > 0) then
           ThouFn := WorkStr + ' and ' + HunStr
         else
           ThouFn := WorkStr + HunStr;
         end;
     end;


     function MillFn (i : longint) : string;
     { 1..999999 }
     var
       HunStr, WorkStr : string;
     begin
       WorkStr := '';

       if (i > 999999) then begin
         { 1000..999999 }
         WorkStr := ThouFn (i div 1000000) + 'million';
         i := i mod 1000000;
       end;

       { 0..999 }
       HunStr := ThouFn (i);
       if (i > 100) and (length (WorkStr) > 0) then
         MillFn := WorkStr + ', ' + HunStr
       else begin
         if (length (HunStr) > 0) and (length (WorkStr) > 0) then
           MillFn := WorkStr + ' and ' + HunStr
         else
           MillFn := WorkStr + HunStr;
         end;
     end;

    begin
       WorkStr := '';

       if (i < 0) then begin
         WorkStr := 'minus ';
         i := abs (i);
       end;

       { 0..max }
       if (i < 1) then
          WorkStr := 'zero';

       { 1..max }
       If (i > MaxLInt) then Begin
         Long2Words :='Two Billion Plus!';

         exit;
       end;

       if (i > longint (999999999)) then begin
         ModConst:=Round(1e9);
         WorkStr := WorkStr + MillFn (i div ModConst) + 'billion';
         LessMillion := i mod ModConst;

         if (LessMillion > 0) and (LessMillion < 100) then
           WorkStr := WorkStr + ' and '
         else
           WorkStr := WorkStr + ', ';
         i := i mod ModConst;
       end;

       if (i > 999999) then Begin
         ModConst:=Round(1e6);
         WorkStr := WorkStr + ThouFn (i div ModConst) + 'million';

         LessMillion := i mod ModConst;

         if (LessMillion > 0) and (LessMillion < 100) then
           WorkStr := WorkStr + ' and '
         else
           WorkStr := WorkStr + ', ';
         i := i mod ModConst;
       end;

       { 1..999999 }
       WorkStr := WorkStr + ThouFn (i);

       { Tidy up tail end, by chopping spare spaces & commas }
       if (WorkStr [length (WorkStr)] = ' ') then
          WorkStr := Copy (WorkStr, 1, (length (WorkStr) - 1));
       if (WorkStr [length (WorkStr)] = ',') then
          WorkStr := Copy (WorkStr, 1, (length (WorkStr) - 1));

       Long2Words := WorkStr;
    end;


    Function CQVerbal(CQVal          :  Real;
                      Lno            :  Byte;
                      InclPS         :  Boolean;
                      PoundT, PenceT :  Str80)  :  Str255;
    Var
      PAmnt, FAmnt  : LongInt;
      PoundStr, Tmp : Str255;
      PoundWord     : Array[1..2] of Str255;
      n, np         : Byte;
      FoundOk       : Boolean;
      sVal          : ShortString;
    Begin
      PoundStr:='';


      Blank(PoundWord,Sizeof(PoundWord));

      FoundOk:=BOff;

      // MH 18/10/06: Modified the way it was calculating pounds (PAmnt) and pence (FAmnt) as
      // due to rounding errors people were getting checks for "... pounds and 100 pence"

      // MH 26/10/06: Modified to handle -ve PPY's

      If (CQVal < 0.00) Then
      Begin
        // MH 01/06/07: Modified to support -ve cheques. but to print them as positive
        // -ve checks meaningless (and crash with range check error!) so return 0 as the amount
        //PAmnt := 0;
        //FAmnt := 0;
        CQVal := ABS(CQVal);
      End; // If (CQVal < 0.00)

      // Round and convert to string
      sVal := Form_Real(Round_Up(CQVal,2), 0, 2);
      // Extract pounds from the start of the string
      PAmnt := StrToIntDef(Copy(sVal, 1, Length(sVal)-3), 0);
      // Extract pence from the end of the string
      FAmnt := StrToIntDef(Copy(sVal, Length(sVal)-1, 2), 0);

      // Eduardo's original code
      //PAmnt:=Trunc(CQVal);
      //FAmnt:=Round((CQVal-PAmnt)*100);

      PoundStr:=Long2Words(PAmnt)+' '+PoundT;

      If (InclPS) and (FAmnt<>0) then Begin
        PoundStr:=PoundStr+' and '+Long2Words(FAmnt)+' '+PenceT;
      end;
      PoundStr:=TrimRight(PoundStr)+' Only';

      PoundStr[1]:=UpCase(PoundStr[1]);

      PoundStr:='**'+PoundStr+'**';

      {** Change this section to use PixWidth **}
      If ((Not DDosMode) And (PixWidth >= GetPixWidth(PoundStr))) Or
         (DDosMode And (PixWidth >= Length(PoundStr))) Then
        { Can fit inside designated space }
        PoundWord[1]:=PoundStr
      Else Begin
        { too long - need to split over lines }
        n:=WordCnt(PoundStr);

        While (n>0) and (Not FoundOk) do Begin
          { Get strt position of word n }
          np:=PosWord(n,PoundStr);

          Tmp := Copy (PoundStr, 1, np);

          If DDosMode Then
            FoundOK := (Length(Tmp) <= PixWidth)
          Else
            FoundOk:=(GetPixWidth(Tmp) <= PixWidth);

          If (FoundOk) then Begin
            PoundWord[1]:=Copy(PoundStr,1,Pred(np));

            PoundWord[2]:=Copy(PoundStr,np,Succ(Length(PoundStr)-np));
          end
          else
            Dec(n);
        End; { While }
      end; { Else }

      CQVerbal:=PoundWord[Lno];
    end; {Func..}


    { ====== Func to return CQ Val ====== }

  Function RecepCQNo(IFol  :  LongInt;
                     GetPI :  Boolean)  :  Str20;
  Const
    Fnum     =  IDetailF;
    Keypath  =  IdFolioK;
  Var
    TmpKPath,
    TmpStat
             :  Integer;
    TmpRecAddr
             :  LongInt;
    KeyS,
    KeyChk   :  Str255;
    TmpId    :  IDetail;
    FoundOk  :  Boolean;
    TmpStr   :  Str20;
  Begin
    TmpStr:='';

    FoundOk:=BOff;

    TmpId:=Id;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    KeyChk:=FullIdKey(IFol,RecieptCode);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
    With Id do
    Begin

      Case GetPI of
        BOff  :  FoundOk:=(Not EmptyKey(Desc,DocDesLen));
        BOn   :  FoundOk:=(Not EmptyKey(StockCode,PIKeyLen));

      end; {Case..}


      If (Not FoundOk) then
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

    If (FoundOk) then
      If (GetPI) then
      Begin
        // HM 18/08/03: Modified as wasn't correctly handling posted Pay-In Refs
        //TmpStr:=Extract_PayRef1(Id.StockCode)

        If (Id.PostedRun > 0) then
          TmpStr:=Extract_PayRef2(Id.StockCode)
        Else
          TmpStr:=Extract_PayRef1(Id.StockCode);
      End // If (GetPI)
      Else
        TmpStr:=Id.Desc;

    RecepCQNo:=TmpStr;

    Id:=TmpId;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
  end; {Func..}

   { ============ CQ Writing Routines =========== }


  { == Function to Return Coma Format == }
  Function CQFormat(CQNum  :  Real;
                    Dp     :  Byte)  :  Str255;
  Var
    NeedCom    : Boolean;
    TStr       : Str255;
    Cpos, CLen : Byte;
  Begin
    {NeedCom:=(Trunc(DivWChk(CQNum,1000))<>0);}

    NeedCom:=BOff;  {* 15/01/95 APAC 3 Std prohibits use of comas *}

    // MH 01/06/07: Modified to always convert amount to positive
    TStr:=Form_Real(ABS(CQNum),0,Dp);

    CPos:=4+Dp;

    CLen:=Length(TStr);

    If (NeedCom) then
      TStr:=Copy(TStr,1,((CLen-CPos)))+','+Copy(TStr,Succ((CLen-CPos)),Cpos);

    If (Dp<>0) then
      TStr[CLen-Dp]:='-'; {* Replace '.' with '-' *}

    CQFormat:='**'+TStr+'**';
  end; {Func..}



  { == Return Unit Split in Words == }
  { Modes:- }
  { 0           =    Units               1 }
  { 1           =    Tens               10 }
  { 2           =    Hndr              100 }
  { 3           =    Thou            1,000 }
  { 4           =    TTho           10,000 }
  { 5           =    HTho          100,000 }
  { 6           =    Mill        1,000,000 }
  { 7           =    10 Mill    10,000,000 }
  { 8           =    100 Mill  100,000,000 }
  Function Unit_Split(USNum  :  Real;
                      UPos   :  Byte)  :  Str10;
  Const
    NofUnits    =     9;
    UConst      :     Array[0..9]  of String[5] = ('NIL','ONE','TWO','THREE','FOUR',
                                                   'FIVE','SIX','SEVEN','EIGHT','NINE');
  Var
    UDesc       : Array[1..NofUnits] of Str10;
    DecR, PwrR  : Real;
    n, Updx     : Byte;
    sVal        : ShortString;
    PAmnt       : LongInt;
  Begin
    // MH 26/10/06: Rewrote to use integers due to problems with rounding errors caused by TRUNC'ing,
    // using rounding not suitable as we are ignoring decimals

    // MH 01/06/07: Modified to use ABS as all cheques have to be printed as positive

    // Round and convert to string
    sVal := Form_Real(Round_Up(ABS(USNum),2), 0, 2);
    // Extract pounds from the start of the string
    PAmnt := StrToIntDef(Copy(sVal, 1, Length(sVal)-3), 0);

    //DecR:=USNum;
    DecR:=PAmnt;

    PwrR:=0;

    Updx:=0;

    For n:=NofUnits downto 1 do Begin
      PwrR:=Power(10,Pred(n));

      Updx:=ABS(Trunc(DivWChk(DecR,PwrR)));

      UDesc[n]:=UConst[Updx];

      DecR:=(DecR-(PwrR*Updx));
    end;

    Unit_Split:=UDesc[UPos];
  end; {Func..}


      { ====== Func to return CQ Val ====== }

    Procedure DocDelDate(IFol    :  LongInt;
                     Var IDDate  :  LongDate;
                         GetFirst:  Boolean);


    Const
      Fnum     =  IDetailF;
      Keypath  =  IdFolioK;


    Var
      KeyS,
      KeyChk   :  Str255;

      TmpId    :  IDetail;

      FoundOk  :  Boolean;

      B_Func,
      TmpKPath,
      TmpStat
               :  Integer;

      TmpRecAddr
               :  LongInt;
    Begin

      FoundOk:=BOff;

      TmpId:=Id;

      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      KeyChk:=FullNomKey(IFol);

      If (GetFirst) then
      Begin

        B_Func:=B_GetGEq;

        KeyS:=FullIdKey(IFol,1);
      end
      else
      Begin

        B_Func:=B_GetLessEq;
        KeyS:=FullIdKey(IFol,Pred(RecieptCode));
      end;

      Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
      With Id do
      Begin

        FoundOk:=(Not EmptyKey(PDate,LDateKeyLen));

        If (Not FoundOk) then
        Begin

          If (GetFirst) then
            B_Func:=B_GetNext
          else
            B_Func:=B_GetPrev;


          Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
        end;

      end; {While..}

      If (FoundOk) then
        IDDate:=Id.PDate;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      Id:=TmpId;
    end; {Proc..}


    Function TH_DatePaid (InvR : InvRec) : LongDate;
    Const
      Fnum = PWrdF;
      KeyPath = PWK;

      FNum2 = InvF;
      KeyPath2 = InvOurRefK;

      DocMatchTyp : Array [BOff..BON] Of Char = ('A', 'O');
    Var
      KeyChk, KeyS      : Str255;
      FoundOk           : Boolean;
      TmpRecAddr        : LongInt;
      TmpKPath, TmpStat : Integer;
    Begin
      With InvR Do Begin
        TmpKPath := GetPosKey;

        TmpStat := Presrv_BtPos (FNum2, TmpKPath, F[Fnum2],TmpRecAddr,Boff,Boff);

        FoundOk := BOff;
        Result := '';

        If ((RemitNo = '') And (Not OrdMatch)) Or (Settled = 0) Then Begin
          FoundOK := BOn;

          If (InvDocHed In RecieptSet + DirectSet + MatchSet) Then
            Result := TransDate;
        End; { If }

        KeyChk := MatchTCode + MatchSCode + OurRef;
        KeyS := KeyChk + NDXWeight;

        TmpStat := Find_Rec(B_GetLessEq, F[FNum],FNum, RecPtr[FNum]^,KeyPath,KeyS);

        While (TmpStat = 0) And (CheckKey (KeyChk, KeyS, Length(KeyChk), BOn)) And (Not FoundOk) Do
          With Password.MatchPayRec Do Begin
            FoundOk := (MatchType = DocMatchTyp[BOff]) Or (InvDocHed In PSOPSet);

            If FoundOk Then Begin
              KeyS := PayRef;

              TmpStat := Find_Rec(B_GetEq, F[FNum2],FNum2, RecPtr[FNum2]^,KeyPath2,KeyS);

              FoundOk := (TmpStat = 0);

              If FoundOk Then
                Result := Inv.TransDate;
            End; { If }

            If (Not FoundOk) Then
              TmpStat := Find_Rec(B_GetPrev, F[FNum],FNum, RecPtr[FNum]^,KeyPath,KeyS);
          End; { With }

        TmpStat := Presrv_BtPos (FNum2, TmpKPath, F[Fnum2],TmpRecAddr,Bon,Bon);
      End; { With }
    End;


    Function TH_DatePaid2 (InvR : InvRec) : LongDate;
    Const
      Fnum = PWrdF;
      {KeyPath = PWK;}

      FNum2 = InvF;
      KeyPath2 = InvOurRefK;

      DocMatchTyp : Array [BOff..BON] Of Char = ('A', 'O');
    Var
      KeyChk, KeyS      : Str255;
      FoundOk           : Boolean;
      TmpRecAddr        : LongInt;
      TmpKPath, TmpStat : Integer;
      KeyPath           : Integer;
    Begin
      With InvR Do Begin
        KeyPath := PWK;
        TmpKPath := GetPosKey;

        TmpStat := Presrv_BtPos (FNum2, TmpKPath, F[Fnum2],TmpRecAddr,Boff,Boff);

        FoundOk := BOff;
        Result := '';

        If ((RemitNo = '') And (Not OrdMatch)) Or (Settled = 0) Then Begin
          KeyPath := HelpNDXK;

          If (InvDocHed In DirectSet) Then Begin
            FoundOK := BOn;
            Result := TransDate;
          End; { If }
        End; { If }

        KeyChk := MatchTCode + MatchSCode + OurRef;
        KeyS := KeyChk + NDXWeight;

        TmpStat := Find_Rec(B_GetLessEq, F[FNum],FNum, RecPtr[FNum]^,KeyPath,KeyS);

        While (TmpStat = 0) And (CheckKey (KeyChk, KeyS, Length(KeyChk), BOn)) And (Not FoundOk) Do
          With Password.MatchPayRec Do Begin
            FoundOk := (MatchType = DocMatchTyp[BOff]) Or (InvDocHed In PSOPSet);

            If FoundOk Then Begin
              KeyS := PayRef;

              TmpStat := Find_Rec(B_GetEq, F[FNum2],FNum2, RecPtr[FNum2]^,KeyPath2,KeyS);

              FoundOk := (TmpStat = 0);

              If FoundOk Then
                Result := Inv.TransDate;
            End; { If }

            If (Not FoundOk) Then
              TmpStat := Find_Rec(B_GetPrev, F[FNum],FNum, RecPtr[FNum]^,KeyPath,KeyS);
          End; { With }

        TmpStat := Presrv_BtPos (FNum2, TmpKPath, F[Fnum2],TmpRecAddr,Bon,Bon);
      End; { With }
    End;


    { Calculates whether an invoice generated from an order is the first invoice }
    { by checking to see if any items have been delivered previously             }
    Function CalcPrevDel : Boolean;
    Const
      Fnum     =  IDetailF;
      Keypath  =  IdFolioK;
    Var
      KeyS, KeyChk         : Str255;
      TmpId                : ^IDetail;
      TmpKPath, TmpStat    : Integer;
      TmpRecAddr           : LongInt;
      TotOrd, TotOS        : Double;
    Begin
      Result := False;

      { Save current detail line and position }
      New(TmpId);
      TmpId^:=Id;
      TmpKPath:=GetPosKey;
      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      KeyChk:=FullNomKey(Inv.FolioNum);
      KeyS:=FullIdKey(Inv.FolioNum,1);

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
      While (StatusOk) And (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) Do Begin
        { Check we have got a Stock Item line }
        If Is_FullStkCode(Id.StockCode) Then Begin

          { Get Total Ordered }
          TotOrd := SOP_QtyLink(Id.SOPLink,Id.SOPLineNo,1);
          TotOS  := SOP_QtyLink(Id.SOPLink,Id.SOPLineNo,2);

          { Has been previously delivered if Order Total is greater than the }
          { number outstanding + the number delivered on this invoice }
          Result := (TotOrd > (TotOS + Id.Qty));

          If Result Then Break;
        End; { If }

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
      End; { While }

      { Restore original det line and position }
      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
      Id:=TmpId^;
      Dispose(TmpId);
    End;

    Procedure GetTradeTotals;
    Var
      NoteText : Str255;
      LineNo   : Byte;

      Function ExtractAmount (AmtStr : ShortString) : Double;
      Var
        I : SmallInt;
      Begin { ExtractAmount }
        Result := 0;

        AmtStr := Trim(AmtStr);
        If (AmtStr <> '') Then Begin
          // trade counter amount in format 'Cash :              £1375.10'
          For I := Length(AmtStr) DownTo 1 Do
            If Not (AmtStr[I] In ['0'..'9', '.']) Then Begin
              // Invalid character
              Delete (AmtStr, 1, I);
              Break;
            End; { If Not (AmtStr[I] In ['0'..'9', '.']) }

          If (AmtStr <> '') Then
            Try
              Result := StrToFloat(AmtStr);
            Except
              On Exception Do
                ;
            End;
        End; { If (AmtStr <> '') }
      End; { ExtractAmount }

    Begin { GetTradeTotals }
      // Check to see if already got the totals loaded
      If (TradeInfo^.LastTrans <> Inv.OurRef) Then Begin
        // reinitialse all totals
        FillChar (TradeInfo^, SizeOf (TradeInfo^), #0);

        With TradeInfo^ Do Begin
          LastTrans := Inv.OurRef;

          For LineNo := 2 To 8 Do Begin
            NoteText := GetNoteNo (3, 2, IntToStr(LineNo));

            If (Trim(NoteText) <> '') Then Begin
              // Got Text - extract amount
              If (Pos ('CASH :', UpperCase(NoteText)) = 1) Then
                Totals[1] := ExtractAmount (NoteText)
              Else
                If (Pos ('CARD :', UpperCase(NoteText)) = 1) Then
                  Totals[2] := ExtractAmount (NoteText)
                Else
                  If (Pos ('CHEQUE :', UpperCase(NoteText)) = 1) Then
                    Totals[3] := ExtractAmount (NoteText)
                  Else
                    If (Pos ('LEFT ON ACCOUNT :', UpperCase(NoteText)) = 1) Then
                      Totals[4] := ExtractAmount (NoteText)
                    Else
                      If (Pos ('WRITTEN-OFF :', UpperCase(NoteText)) = 1) Then
                        Totals[5] := ExtractAmount (NoteText)
                      Else
                        If (Pos ('CHANGE :', UpperCase(NoteText)) = 1) Then
                          Totals[6] := ExtractAmount (NoteText)
                        Else
                          If (Pos ('OUTSTANDING :', UpperCase(NoteText)) = 1) Then
                            Totals[8] := ExtractAmount (NoteText);
            End; { If (Trim(NoteText) <> '') }
          End; { For LineNo }
        End; { With TradeInfo }
      End; { If (TradeInfo^.LastTrans <> Inv.OurRef) }
    End; { GetTradeTotals }



    { Returns TRUE if the NOM has the manual vat flag set on any of its lines }
    Function NOMisManVat : Boolean;
    Const
      Fnum     =  IDetailF;
      Keypath  =  IdFolioK;
    Var
      KeyS, KeyChk         : Str255;
      TmpId                : ^IDetail;
      TmpKPath, TmpStat    : Integer;
      TmpRecAddr           : LongInt;
      TotOrd, TotOS        : Double;
      lStatus              : SmallInt;
    Begin
      Result := False;

      { Save current detail line and position }
      New(TmpId);
      TmpId^:=Id;
      TmpKPath:=GetPosKey;
      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      KeyChk:=FullNomKey(Inv.FolioNum);
      KeyS:=FullIdKey(Inv.FolioNum,1);

      lStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
      While (lStatus = 0) And (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) Do Begin
        Result := (Id.NOMIOFlg = 2);

        If Result Then
          Break
        Else
          lStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
      End; { While }

      { Restore original det line and position }
      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
      Id:=TmpId^;
      Dispose(TmpId);
    End;


  Begin
    Rnum:=0;
    UOR:= 0;

    TmpField:='';

    With Inv do
    Case DictNo of

      2000  :  TmpField:=OurRef;                        {* Doc Ref *}

      2001  :  TmpField:=DocCodes[InvDocHed];           {* Doc Type *}

      2002  :  TmpField:=CustCode;                      {* Doc Account Code *}

      2003  :  TmpField:=TransDate;                     {* Doc Trans Date*}

      2004  :  TmpField:=DueDate;                       {* Doc Due Date *}

      2005  :  TmpField:=Form_Int(AcPr,0);              {* Doc Period *}

      // HM 17/02/00: Modified to return 2 digit year
      2006  :  TmpField:=Format('%2.2d', [(AcYr Mod 100)]);    { 2-digit year:- 1996='96', 2001='01' }

      // HM 17/02/00: Added for improved year support
      2030  :  TmpField:=Form_Int(AcYr + 1900, 4);             { Full 4-digit Year }
      2031  :  TmpField:=Form_Int(AcYr, 3);                    { Accounting Year:- 1996=96, 2001=101 }

      2007  :  TmpField:=YesNoBo(NomAuto);             {* Doc Auto Flag *}

      2008  :  TmpField:=Form_Int(FolioNum,0);          {* Doc Folio Number *}

      2009  :  TmpField:=Form_Int(Currency,0);          {* Doc Currency *}
      2063  :  TmpField := PSymb (Currency);

      2010,
      2011  :  TmpField:=Form_Real(CXRate[(DictNo=2010)],0,10); {* Doc Day & Co. Rate *}

      2012  :  TmpField:=YourRef;                      {* Doc Your Ref *}

      2013  :  TmpField:=TransDesc;                    {* Doc Long Your Ref *}

      2014  :  TmpField:=DelTerms;                     {* Doc SSD DelTerms *}

      2015  :  TmpField:=Form_Int(TransNat,0);         {* Doc SSD Trans Nature *}

      2016  :  TmpField:=Form_Int(TransMode,0);        {* Doc SSD Trans Nature *}

      2017  :  TmpField:=BatchLink;                    {* Doc Batch Link *}

      // HM 07/03/01: Extracted Batch Payment Run number
      2268  :  If (InvDocHed In [PPY, SRC]) And (Length(BatchLink) >= 7) Then Begin
                 Move (BatchLink[4], LI, SizeOf(LI));
                 TmpField:=Form_Int(LI,0);
               End; { If }

      2018  :  TmpField:=AllocStat;                    {* Doc Allocated Status *}

      2019  :  TmpField:=DeliverRef;                   {* Doc Delivery Note XRef *}

      2020  :  TmpField:=YesNoBo(PrintedDoc);          {* Doc Printed Flag *}

      2021  :  TmpField:=YesNoBo(Revalued(Inv));       {* Doc Revalued Status *}

      2022  :  TmpField:=YesNoBo(OnHold(HoldFlg));     {* Doc Revalued Status *}

      2023  :  TmpField:=YesNoBo((HoldP and HoldFlg)=HoldP); {* Doc Authorised Status *}

      2024  :  TmpField:=OpName;                        {* Operator Name *}

      2025  :  TmpField:=Form_Int(RunNo,0);             {* Doc RunNo *}

      2026  :  TmpField:=Form_Int(PickRunNo,0);         {* Doc Delivery / Picking RunNo *}

      2027  :  TmpField:=VATPostDate;                   {* Doc VAT Posted Date *}


      2050,
      2086  :  Begin
                 Rnum:=DocSign(InvNetVal,InvDocHed);

                 { HM 13/10/98: Added VAT Currency equivalent fields }
                 If (DictNo = 2086) Then Begin
                   { Convert to VAT Currency }
                   RNum := Round_Up((Conv_VATCurr(RNum,
                                                  VATCRate[BOn],
                                                  OrigRates[BOn],
                                                  Currency,
                                                  UseORate) * DocCnst[InvDocHed])*DocNotCnst,2);
                 End; { If }

                 TmpField:=Form_Real(Rnum,0,2);                        {* Doc Net Invoice Value *}
               end;
      2100  :  Begin
                 Rnum:=DocSign(InvNetVal,InvDocHed);

                 UOR:=fxUseORate(False,BOn,CXRate,UseORate,Currency,0);
                 Rnum:=Conv_TCurr(Rnum,XRate(CXRate,False,Currency),Currency,UOR,False);

                 TmpField:=Form_Real(Rnum,0,2);                        {* Doc Net Invoice Value *}
               end;



      2051  :  Begin
                 Rnum:=DocSign(InvNetVal-Inv.DiscAmount,InvDocHed);
                 TmpField:=Form_Real(Rnum,0,2);                         {* Doc Net Invoice - Dicsount Value *}
               End;

      2060  :  TmpField:=Form_Real(InvNetVal-Inv.DiscAmount,0,2);       {* Doc Net Invoice - Dicsount Value *}

      2101  :  Begin

                 Rnum:=DocSign(InvNetVal-Inv.DiscAmount,InvDocHed);

                 If (DictNo=2101) then Begin
                   UOR:=fxUseORate(False,BOn,CXRate,UseORate,Currency,0);
                   Rnum:=Conv_TCurr(Rnum,XRate(CXRate,False,Currency),Currency,UOR,False);
                 End; { If }

                 TmpField:=Form_Real(Rnum,0,2);                         {* Doc Net Invoice - Dicsount Value *}
               end;

      2052  :  Begin
                 Rnum:=DocSign(DiscAmount,InvDocHed);
                 TmpField:=Form_Real(Rnum,0,2);                         {* Doc Invoice - Dicsount Value *}
               end;
      2102  :  Begin
                 {Rnum:=DocSign(DiscAmount,InvDocHed);}

                 UOR:=fxUseORate(UseCoDayRate,BOn,CXRate,UseORate,Currency,0);
                 Rnum:=Conv_TCurr(DiscAmount,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,False);

                 TmpField:=Form_Real(Rnum,0,2);                         {* Doc Invoice - Dicsount Value *}
               end;

      2053  :  Begin
                 Rnum:=DocSign(DiscSetAm,InvDocHed);
                 TmpField:=Form_Real(Rnum,0,2);                         {* Doc  Invoice - Settle Dicsount Value *}
               end;
      2103  :  Begin
                 {Rnum:=DocSign(DiscSetAm,InvDocHed);}
                 UOR:=fxUseORate(UseCoDayRate,BOn,CXRate,UseORate,Currency,0);
                 Rnum:=Conv_TCurr(Rnum,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,False);
                 TmpField:=Form_Real(Rnum,0,2);                         {* Doc  Invoice - Settle Dicsount Value *}
               end;

      2054,
      2084  :  Begin
                 RNum := DocSign(ITotal(Inv),InvDocHed);

                 { HM 13/10/98: Added VAT Currency equivalent fields }
                 If (DictNo = 2084) Then Begin
                   { Convert to VAT Currency }
                   RNum := Round_Up((Conv_VATCurr(RNum,
                                                  VATCRate[BOn],
                                                  OrigRates[BOn],
                                                  Currency,
                                                  UseORate) * DocCnst[InvDocHed])*DocNotCnst,2);
                 End; { If }

                 TmpField:=Form_Real(RNum,0,2);     {* Doc  Invoice - Total *}
               End;

      2062,
      2085  :  Begin
                 RNum := ITotal(Inv);     {* Doc  Invoice - Total *}

                 { HM 13/10/98: Added VAT Currency equivalent fields }
                 If (DictNo = 2085) Then Begin
                   { Convert to VAT Currency }
                   RNum := Round_Up((Conv_VATCurr(RNum,
                                                  VATCRate[BOn],
                                                  OrigRates[BOn],
                                                  Currency,
                                                  UseORate) * DocCnst[InvDocHed])*DocNotCnst,2);
                 End; { If }

                 TmpField:=Form_Real(RNum,0,2);     {* Doc  Invoice - Total *}
               End;

      2055  :  TmpField:=Form_Real(Pcnt2Full(DiscSetl),0,2);                {* Doc  DiscSetl Amount *}

      2056  :  TmpField:=Form_Int(DiscDays,0);                              {* Doc  DiscSetl Days *}

      2057  :  TmpField:=Form_Real(DocSign(CurrSettled,InvDocHed),0,2);         {* Doc  Amount Settled *}

      { IFDEF REP_ENGINE}
(*** MH 28/02/2012 v6.9: Reverted back to previous behaviour as inclusion of variance/revaluation appears to be causing problems
      2058  :  begin {* Doc  Amount O/S Own Currency *}
                 //PR: 23/08/2011 Own currency o/s amount was different from
                 //base o/s as base took settlement discount into account. Change for Report Engine only
                 //by converting base total back to currency then subtracting settled in currency.  ABSEXCH-2357
                 If (Not (InvDocHed In QuotesSet)) and (NomAuto) then
                 begin
                   UOR:=fxUseORate(UseCoDayRate,BOn,CXRate,UseORate,Currency,0);
                   Rnum := ConvCurrITotal(Inv,BOff,BOn,BOff)*DocCnst[InvDocHed]*DocNotCnst;
                   Rnum:=Conv_TCurr(Rnum, XRate(CXRate,False,Currency), Currency, UOR, True) - Inv.CurrSettled;
                 end
                 else
                   Rnum := 0.00;

                 TmpField:=Form_Real(RNum,0,2);
               end;
***)
      { ELSE}
      2058  :  TmpField:=Form_Real(CurrencyOS(Inv,True,False,False),0,2);{* Doc  Amount Settled Own Currency *}
      { ENDIF}

      2059,
      2087  :  Begin                                                        {* Doc Vat Content *}
                 Rnum:=DocSign(InvVat,InvDocHed);

                 { HM 13/10/98: Added VAT Currency equivalent fields }
                 If (DictNo = 2087) Then Begin
                   { Convert to VAT Currency }
                   RNum := Round_Up((Conv_VATCurr(RNum,
                                                  VATCRate[BOn],
                                                  CXRate[BOn],
                                                  Currency,
                                                  UseORate) * DocCnst[InvDocHed])*DocNotCnst,2);
                 End; { If }

                 TmpField:=Form_Real(Rnum,0,6);
               end;
      2061,
      2088  :  Begin
                 RNum := InvVat;

                 { HM 13/10/98: Added VAT Currency equivalent fields }
                 If (DictNo = 2088) Then Begin
                   { Convert to VAT Currency }
                   RNum := Round_Up((Conv_VATCurr(RNum,
                                                  VATCRate[BOn],
                                                  CXRate[BOn],
                                                  Currency,
                                                  UseORate) * DocCnst[InvDocHed])*DocNotCnst,2);
                 End; { If }

                 TmpField:=Form_Real(RNum,0,6);
               End;

      { HM 13/10/98: Added VAT Currency equivalent fields }
      2089,
      2090  :  TmpField:=Form_Real(VATCRate[DictNo=2089],0,6);
      2203  :  Begin                                                        {* Doc Vat Content *}
                 {Rnum:=DocSign(InvVat,InvDocHed);}

                 Rnum:=Conv_TCurr(InvVat,CXRate[True],Currency,UseORate,False);

                 TmpField:=Form_Real(Rnum,0,6);
               end;

      2104  :  TmpField:=Form_Real(DocSign(ConvCurrITotal(Inv,False,True,True),InvDocHed),0,2);{* Doc  Total Base Currency *}

      2105  :  TmpField:=Form_Real(DocSign(Settled,InvDocHed),0,2);                 {* Doc  Settled Base Currency *}

      2106  :  TmpField:=Form_Real(BaseTotalOs(Inv),0,2);        {* Doc  Total O/S Base Currency *}

      2150..2156,
      2210..2216,
      2500..2506
            :  Begin
                 { HM 16/10/97: Have to swap fields around because they are in the
                   wrong order in the data dictionary }
                 If (DictNo = 2151) Or (DictNo = 2152) Then Begin
                   If (DictNo = 2151) Then
                     DictNo := 2152
                   Else
                     DictNo := 2151;
                 End; { If }

                 { HM 14/01/99: Removed caching as it was screwing things up }
                 //If (LastNetLink<>OurRef) then {* Refresh Totals *}
                 //Begin
                   Def_InvCalc2;
                   {ExLocal.Create;
                   CalcInvTotals(Inv,ExLocal,False,True);
                   ExLocal.Destroy;}

                   //LastNetLink:=OurRef;
                 //end;

                 If (DictNo >= 2210) And (DictNo <=2216) Then
                   { Rate 12-18 }
                   VT:=GetVATCode((DictNo-2195))
                 Else
                   If (DictNo >= 2500) Then
                     { Rate 5 onwards }
                     VT:=GetVATCode((DictNo-2492))
                   Else
                     VT:=GetVATCode((DictNo-2149));

                 TmpField:=Form_Real(DocSign(InvNetAnal[VT],InvDocHed),0,2);        {* Doc  Total Goods *}
               end;

      2157..2163,
      2250..2256,
      2520..2526
            :  Begin
                 { HM 16/10/97: Have to swap fields around because they are in the
                   wrong order in the data dictionary }
                 If (DictNo = 2158) Or (DictNo = 2159) Then Begin
                   If (DictNo = 2158) Then
                     DictNo := 2159
                   Else
                     DictNo := 2158;
                 End; { If }

                 If (DictNo >= 2250) And (DictNo <=2256) Then
                   { Rate 12-18 }
                   VT:=GetVATCode((DictNo-2235))
                 Else
                   If (DictNo >= 2520) Then
                     { Rate 5 onwards }
                     VT:=GetVATCode((DictNo-2512))
                   Else
                     {VT:=GetVATCode((DictNo-2149));}
                     VT:=GetVATCode((DictNo-2156));

                 TmpField:=Form_Real(DocSign(InvVATAnal[VT],InvDocHed),0,2);        {* Doc  Total Goods VAT *}

               end;

      2200  :  TmpField:=Form_Real(DocSign(TotalCost,InvDocHed),0,2);               {* Doc  Total Cost *}

      2201  :  TmpField:=Form_Int(NoLabels,0);                              {* Doc  No Labels *}

      {$IFDEF PF_ON}
      2202  :  TmpField:=Form_Real(TotalWeight,0,6);                        {* Doc Total Weight *}
      {$ENDIF}

      2204  :  TmpField:=Form_Real(ReValueAdj,0,6);                        {* Doc Valuation base adjustment *}


      2300..2304
            :   TmpField:=DAddr[DictNo-2299];                               {* Document Delivery Addr *}

      2305  :   TmpField:=Form_Int(HoldFlg,0);                             {* Hold Status, expressed as a value *}

      2306  :   TmpField:=DJobCode;                                        {* JobCode *}
      2307  :   TmpField:=DJobAnal;                                        {* Job Anal Code *}

      { Delivery address - customers if blank }
      2360..2364 : Begin
                     {If (Trim(TInv.DAddr[1]) = '') Then
                       TInv.DAddr := TCust.Addr;}

                     If (Trim(TInv.DAddr[1]) = '') And (Trim(TInv.DAddr[2]) = '') Then Begin
                       { Use Customer address for sales transactions and }
                       { users own for purchase transactions             }
                       If (TInv.InvDocHed In PurchSplit) Then
                         TInv.DAddr := Syss.DetailAddr
                       Else
                         TInv.DAddr := TCust.Addr;
                     End; { If }

                     TmpField:=TInv.DAddr[DictNo-2359];
                   End;

      { MH 09Apr96: Added following for Form Designer }
      { Header - Our Ref }
      2346 : TmpField := TInv^.OurRef;
      { Header - Currency }
      {2347 : TmpField := PSymb (TInv^.Currency);}
      2347 : TmpField := Form_Int(TInv^.Currency,0);
      2348 : TmpField := PSymb (TInv^.Currency);
      { Header - Transaction Date }
      2308 : TmpField := TInv^.TransDate;
      { Header - Period }
      2309 : TmpField := Form_Int (TInv^.AcPr, 0);

      { Header - Year }
      // HM 17/02/00: Modified to return 2 digit year
      2310 : TmpField:=Format('%2.2d', [(TInv^.AcYr Mod 100)]);    { 2-digit year:- 1996='96', 2001='01' }
      // HM 17/02/00: Added for improved year support
      2032 : TmpField:=Form_Int(TInv^.AcYr + 1900, 4);        { Full 4-digit Year }
      2033 : TmpField:=Form_Int(TInv^.AcYr, 3);               { Accounting Year:- 1996=96, 2001=101 }

      { Header - Transaction Type }
      2311 : TmpField := DocNames[TInv^.InvDocHed];
      { Header - Your Ref (Short) }
      2312 : TmpField := TInv^.YourRef;
      { Header - Site Co Name (HO) }
      { Header - Site Co Addr (HO) }
      2313,
      2314,
      2315,
      2316,
      2317,
      2318 : Begin
               Tmpfield := Get_OrigOrdAddr (DictNo - 2313, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);
             End;
      2365..2369
           : Begin { 6 - 10 }
               Tmpfield := Get_OrigOrdAddr (DictNo - 2359, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);
             End;

      2370,2371 { Order Trans Date / Order Delivery Date }
           : Begin
               Tmpfield := Get_OrigOrdAddr (DictNo - 2359, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);
             End;
      2372 : Begin { Order Account Code }
               {$IFDEF EDLL}
                 { Form Designer DLL - run from TInv }
                 Tmpfield := Get_OrigOrdAddr (13, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);
               {$ELSE}
                 { Report Writer - run from Inv }
                 Tmpfield := Get_OrigOrdAddr (13, Inv.YourRef, Inv.OurRef, Inv.InvDocHed);
               {$ENDIF}
             End;

      // HM 30/05/03: Added new fields for v5.51
      // CHORDALT - Header - Order Alt Ref
      2377 : Tmpfield := Get_OrigOrdAddr (14, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);
      // CHORDYOU - Header - Order Your Ref
      2378 : Tmpfield := Get_OrigOrdAddr (15, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);
      // CHORDUF1 - Header - Order User Field 1
      2379 : Tmpfield := Get_OrigOrdAddr (16, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);
      // CHORDUF2 - Header - Order User Field 2
      2380 : Tmpfield := Get_OrigOrdAddr (17, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);
      // CHORDUF3 - Header - Order User Field 3
      2381 : Tmpfield := Get_OrigOrdAddr (18, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);
      // CHORDUF4 - Header - Order User Field 4
      2382 : Tmpfield := Get_OrigOrdAddr (19, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);

      //PR: 18/10/2013 ABSEXCH-14703 CHORDELP thDeliveryPostcode
      2385 : Tmpfield := Get_OrigOrdAddr (20, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);

      // MH 21/08/2017 2017-R2 ABSEXCH-18163: Added Head Office PostCode fields
      // CHCMPOCO - Header - Site Co PostCode (HO)
      2388 : Tmpfield := Get_OrigOrdAddr (27, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);

    {$IFDEF Pf_On}
      { Header - L1 word Amt exc pence }
      { Header - L2 word Amt exc pence }
      { Header - L1 word Amt inc pence }
      { Header - L2 word Amt inc pence }
      2319,
      2320,
      2321,
      2322 : Begin
               If (DictNo > 2320) Then
                 Idx := DictNo - 2320
               Else
                 Idx := DictNo - 2318;

               TmpField := CQVerbal (ITotal(TInv^),
                                     Idx,
                                     (DictNo > 2320),
                                     StringsRec^.fsSVStrs[1],
                                     StringsRec^.fsSVStrs[2]);
             End;
    {$ENDIF}

      { Header - Batch/Payment Amount }
      { Header - Amount as Positive }
      2323,
      2330 : Begin
               Rnum := ITotal(TInv^) * DocCnst[TInv^.InvDocHed] * DocNotCnst;

               If (DictNo = 2330) then
                 { Amount as Positive }
                 Rnum:=Rnum*DocNotCnst;

               TmpField := Form_Real(Rnum, 0, 2);
             End;

{ NOTE: Following fields (2324-2329) come off the matching info }
{ so are line based rather than invoice based }
      { Header - Matched Inv Total Amt }
      { Header - Matched Base Settled }
      2324,
      2325 : With Password.MatchPayRec Do Begin
               If (DictNo = 2324) then
                 Rnum := OwnCVal * DocNotCnst
               Else
                 Rnum := SettledVal * DocNotCnst;

               TmpField := Form_Real(Rnum, 0, 2);
             End;
      { Header - Remit Line Curr, Own }
      { Header - Remit Line Curr, Base }
      2326,
      2327 : With Password.MatchPayRec do Begin
               If (DictNo=2326) then
                 INo:=MCurrency
               else
                 Ino:=0;

               TmpField:=PSymb(Ino);
             End;
      { Header - Remit Settle, Debit }
      { Header - Remit Settle, Credit }
      2328,
      2329 : With Password.MatchPayRec Do Begin
               ShowDrCr(OwnCVal*DocNotCnst,CrDr);

               TmpField := Form_Real(CrDr[(DictNo=2329)], 0, 2);
             End;
      { Header - Net Total }
      2331 : With TInv^ Do Begin
               Rnum:=InvNetVal*DocCnst[InvDocHed]*DocNotCnst;

               TmpField := Form_Real(RNum, 0, 2);
             End;
      { Header - VAT Total }
      2332 : With TInv^ Do Begin
               Rnum:=InvVAT*DocCnst[InvDocHed]*DocNotCnst;

               TmpField := Form_Real(RNum, 0, 2);
             End;

      2333 : TmpField:=Form_Real(TInv^.TotalInvoiced,0,2);
    {$IFNDEF OC2_On}
      2334 : With TInv^ Do Begin
              RNum:=Round_Up(ITotal(TInv^)-(TotalInvoiced*DocCnst[InvDocHed]*DocNotCnst),2);
              TmpField:=Form_Real(RNum,0,2);
            End; { With }
    {$ENDIF}
      2335 : TmpField:=Form_Int(TInv^.BatchNom,0);
      2336 : TmpField:=TInv^.RemitNo;

    {$IFDEF PF_On}
      { ====== Cheque Writing Variables ====== }
      2337 : TmpField:=CQFormat(ITotal(TInv^),2);                               {* Coma formated with leading * Pad *}

      2338..2343
           : TmpField:=Unit_Split(ITotal(TInv^),(DictNo-2337));
      2373..2375
           : TmpField:=Unit_Split(ITotal(TInv^),(DictNo-2366));

      2344 : Begin
               // MH 01/06/07: Modified to always convert to +ve before converting to text
               Rnum:=Round_Up(ABS(ITotal(TInv^)),2);
               Rnum:=(Rnum-Trunc(Rnum))*100;
               TmpField:=SetN(Round(Rnum));
             end;
    {$ENDIF}

      2345 : TmpField:=TInv^.TransDesc;                    {* Doc Long Your Ref *}

      2350..2353 : Begin { Transaction Line Type Totals }
                     TmpField := Form_Real(TInv^.DocLSplit[DictNo-2349], 0, 2);
                   End;

      { HM 15/10/97: Added Line Type Totals to Report Writer }
      2080..2083 : Begin { Transaction Line Type Totals }
                     TmpField := Form_Real(Inv.DocLSplit[DictNo-2079], 0, 2);
                   End;

      { HM 22/10/98: Added Line Type 0 total to stop FJ complaining! }
      2092       : Begin
                     RNum := (InvNetVal-Inv.DiscAmount) - Inv.DocLSplit[1] -
                                                          Inv.DocLSplit[2] -
                                                          Inv.DocLSplit[3] -
                                                          Inv.DocLSplit[4];

                     TmpField := Form_Real(RNum, 0, 2);
                   End;

      { ======= VAT Anal ====== }
      2220..2226,
      2400..2406,
      2540..2546
          : With SyssVAT.VATRates do Begin
              If (DictNo >= 2220) And (DictNo <=2226) Then
                { Rate 12-18 }
                VT:=GetVATCode((DictNo-2205))
              Else
                If (DictNo >= 2540) Then
                  { Rate 5 onwards }
                  VT:=GetVATCode((DictNo-2532))
                Else
                  VT:=GetVATCode((DictNo-2399));

              TmpField:=VAT[VT].Desc;
            end;


      2260..2266,
      2420..2426,
      2560..2566
          : Begin
              { HM 14/01/99: Removed caching as it was screwing things up }
              //If (LastNetLink<>OurRef) then {* Refresh Totals *}
              //Begin
                Def_InvCalc2;
                //LastNetLink:=OurRef;
              //end;

              If (DictNo >= 2260) And (DictNo <=2266) Then
                { Rate 12-18 }
                VT:=GetVATCode((DictNo-2245))
              Else
                If (DictNo >= 2560) Then
                  { Rate 5 onwards }
                  VT:=GetVATCode((DictNo-2552))
                Else
                  VT:=GetVATCode((DictNo-2419));
              TmpField := Form_Real(InvNetAnal[VT], 0, 2);
            end;
      2230..2236,
      2430..2436,
      2580..2586
          : Begin
              If (DictNo >= 2230) And (DictNo <=2236) Then
                { Rate 12-18 }
                VT:=GetVATCode((DictNo-2215))
              Else
                If (DictNo >= 2580) Then
                  { Rate 5 onwards }
                  VT:=GetVATCode((DictNo-2572))
                Else
                  VT:=GetVATCode((DictNo-2429));
              TmpField := Form_Real(Inv.InvVATAnal[VT], 0, 2);
            end;
      2240..2246,
      2440..2446,
      2600..2606
          : Begin
              { HM 14/01/99: Removed caching as it was screwing things up }
              //If (LastNetLink<>OurRef) then {* Refresh Totals *}
              //Begin
                Def_InvCalc2;
                //LastNetLink:=OurRef;
              //end;

              If (DictNo >= 2240) And (DictNo <=2246) Then
                { Rate 12-18 }
                VT:=GetVATCode((DictNo-2225))
              Else
                If (DictNo >= 2600) Then
                  { Rate 5 onwards }
                  VT:=GetVATCode((DictNo-2592))
                Else
                  VT:=GetVATCode((DictNo-2439));

              Rnum:=InvNetAnal[VT]+Inv.InvVATAnal[VT];

              TmpField := Form_Real(Rnum, 0, 2);
            end;

      2450..2457
          : Begin                                                               {* Get First / Last CC / Desc *}
              WhichCC:=((DictNo-2400) In [50..53]);

              FirstCC:=((DictNo-2400) In [50,52,54,56]);

              DocCCDep(Inv.FolioNum,LastCCDep,WhichCC,FirstCC);

              If ((DictNo-2400) In [50,51,54,55]) then
                TmpField:=LastCCDep[WhichCC]
              else
                With Password.CostCtrRec do Begin
                  GetCCDep(Application.MainForm,LastCCDep[WhichCC],Dummy,WhichCC,-1);               {* Last / First CC Desc*}

                  TmpField:=CCDesc;
                end;
            end;

      2460,  { Cheque Number }
      2461   { Paying in reference }
          : TmpField:=RecepCQNo(TInv.FolioNum,(DictNo=2461));

      2470,
      2471
          : Begin
              DocDelDate (Inv.FolioNum, LastIdDate, (DictNo=2470));
              TmpField := LastIdDate;
            End;


      2064,  { Cheque Number }
      2065   { Paying in reference }
          : TmpField:=RecepCQNo(Inv.FolioNum,(DictNo=2465));

      2066: Begin { Document Consolidated Net Total }
              RNum := ConvCurrITotal(Inv, BOff, Bon, BOn) - Round_Up(Conv_TCurr(InvVat,CXRate[BOn], Currency,UseORate,BOff),2);
              TmpField := Form_Real(Rnum, 0, 2);
            End;
      2067: Begin
              TmpField := Short_ORef (YourRef);
            End;

      2068,2069
          : Begin
              ShowDrCr(Inv.Settled*DocCnst[Inv.InvDocHed]*DocNotCnst,CrDr);

              Rnum:=CrDr[(DictNo=2069)];

              TmpField := Form_Real(Rnum, 0, 2);
            end;
      2070: TmpField:=DisplayHold(Inv.HoldFlg);                                    {* Doc Status Hold/Suspend *}

      2071,2072
          :   Begin
                ShowDrCr(ConvCurrITotal(Inv,BOff,BOn,BOn)*DocCnst[Inv.InvDocHed]*DocNotCnst,CrDr);

                Rnum:=CrDr[(DictNo=2072)];

                TmpField := Form_Real(Rnum, 0, 2);
              end;

      2074: If (Inv.PrintedDoc) then   {* Show Invoice printed status using udv *}
              TmpField:=StringsRec^.fsSVStrs[5]
            Else
              TmpField:=StringsRec^.fsSVStrs[4];

      2075 : TmpField := DocUser1;                 { User Defined Field 1 }
      2076 : TmpField := DocUser2;                 { User Defined Field 2 }

      2077 : TmpField := YesNoBo(DiscTaken Or PDiscTaken);       { Discount Taken }

      2078 : TmpField:=Form_Int(LastLetter,0); { Debt Chase Letter No }

      2079 : TmpField:=Form_Real(TotOrdOS,0,2); { total Order OutStanding }

      2472 : TmpField := TH_DatePaid (Inv);
      2473 : TmpField := TH_DatePaid2 (Inv);

      2028 : TmpField:=Form_Int(CtrlNom,0); { Control GL Code }

      2029 : TmpField:=YesNoBo(CalcPrevDel); { Previously Delivered }

      { HM 15/10/98: Added Inv equiv of CHCMPNAM to return the company name off }
      {              the originating order.                                     }
      2091 : Tmpfield := Get_OrigOrdAddr (0, Inv.YourRef, Inv.OurRef, Inv.InvDocHed);

      {----------------- HM 19/10/99 Added v4.31 fields ----------------------}
      { User Defined 3 & 4 }
      2093 : Tmpfield := DocUser3;
      2094 : Tmpfield := DocUser4;
      { Date posted, used for EC + SSD }
      2095 : Tmpfield := PostDate;
      { Preserve Order Rate }
      2096 : Tmpfield := YesNoBo(SOPKeepRate);
      {$IFDEF EDLL}
      { 2107  (payment/receipts) Base currency amount of settlement discount taken/given. }
      { 2108  2107 Unsigned }
      2107,
      2108 :   Begin
                 Rnum:=TInv^.PostDiscAm*DocCnst[TInv^.InvDocHed]*DocNotCnst;

                 {Def_OverRLen(FCtrl,IMask,GTotNo);}

                 If (DictNo=2108) then
                   Rnum:=Rnum*DocNotCnst;

                 TmpField:=Form_Real(Rnum,13,6);
               end;
      { 2109  (Payment/receipts  own currency) amount of settlement discount taken/given. }
      { 2110  2109 but unsigned. }
      2109,
      2110 :   With TInv^ do
               Begin
                 Rnum:=BDiscount-ITotal(TInv^);

                 Rnum:=Rnum*DocCnst[TInv^.InvDocHed]*DocNotCnst;

                 {Def_OverRLen(FCtrl,IMask,GTotNo);}

                 If (DictNo=2110) then
                   Rnum:=Rnum*DocNotCnst;

                 TmpField:=Form_Real(Rnum,13,6);
               end;
      { 2111  (Payment/receipts  own currency) Total amount settled excluding any settlement discount. }
      { 2112  2111 but unsigned. }
      2111,
      2112 :   With TInv^ do
               Begin
                 Rnum:=BDiscount;

                 Rnum:=Rnum*DocCnst[TInv^.InvDocHed]*DocNotCnst;

                 {Def_OverRLen(FCtrl,IMask,GTotNo);}

                 If (DictNo=2112) then
                   Rnum:=Rnum*DocNotCnst;

                 TmpField:=Form_Real(Rnum,13,6);
               end;
      {$ENDIF}

      { HM 28/03/00: Added new field for v4.31 }
      2097 : TmpField := YesNoBo(Tagged <> 0);    { Tagged Status }
      2098 : TmpField := Form_Int(UseORate,0);    { Pre-Triangulation }
      2099 : TmpField := Form_Real(Variance,0,2); { Receipt Currency Variance }

      { HM 02/05/00: Added in v4.31a }
      2267 : TmpField := SSDProcess;

      // HM 19/07/00: Added UntilDate in for Bristan who were in it up to their necks!
      2113 : TmpField := UntilDate;

      // HM 20/11/01: v5.00 - Added THTAGNO fold
      2114 : TmpField := Form_Int(Tagged,0);

      // HM 02/01/01: Trade Counter fields
      2900..2905,
      2907       : Begin
                     // Extract Trade Counter totals
                     GetTradeTotals;

                     // return relevent field
                     TmpField := Form_Real(TradeInfo.Totals[DictNo - 2899],12,2);
                   End;
      2906       : Begin
                     If (CurrSettled <> 0.0) And (CurrencyOS(Inv, True, False, False) <> 0.00) Then
                       TmpField := Form_Real(CurrSettled, 12, 2)
                     Else
                       TmpField := '0.00';
                   End;

      // THCISTAX - CIS Tax Due
      2474       : TmpField:=Form_Real(CISTax,13,2);
      // THCISDEC -CIS Tax Declared On Voucher
      2475       : TmpField:=Form_Real(CISDeclared,13,2);
      // THCISMAN - CIS Manual Tax Y/N
      2476       : TmpField := YesNoBo(CISManualTax);
      // THCISDAT - CIS Date
      2477       : TmpField := CISDate;
      // THCOSAPP - Cost Apportionment Total
      2478       : TmpField:=Form_Real(TotalCost2,13,Syss.NoCosDec);
      // THCISEMP - CIS Employee Code
      2479       : TmpField := CISEmpl;
      // THCISGRO - CIS Gross Total
      2480       : TmpField:=Form_Real(CISGross,13,2);
      // THCISSRC - CIS Source (0=N/A,1=Ret,2=SB)
      2481       : TmpField := Form_Int(CISHolder,0);
      // HM 02/06/03: Modified for NOM's
      // THMANVAT - Manual VAT Y/N
      2482       : If (InvDocHed <> NMT) Then
                     TmpField := YesNoBo(ManVat)
                   Else Begin
                     // NOM - Check all TL's for manual vat flag
                     TmpField := YesNoBo(NOMisManVat);
                   End; { Else }

      // HM 30/05/03: Added new fields for v5.51
      // CHOPONAM - Header - Operator Name
      2376       : TmpField := TInv^.OpName;
      // THVATIO -VAT Input/Output Flag for NOMs
      2164       : If (NomVATIO = #0) Then TmpField := ' ' Else TmpField := NomVATIO;


      // HM 03/03/04: Added fields for Apps & Vals
      // HM 23/09/04: Changed some dd fields to remove direct transaction
      // access for Apps & Vals totals
      // THCERTOT  - JxA Certified Total YTD
      //2269       : TmpField:=Form_Real(TotalOrdered,13,2);
      2269       : TmpField := Form_Real(AppValTotals(@Inv).avtJxACertifiedTotalYTD,13,2);
      // THCERAMT - JxA Certified Amount
      //2270       : TmpField:=Form_Real(InvNetVal,13,2);
      2270       : TmpField:=Form_Real(AppValTotals(@Inv).avtJxACertifiedAmount,13,2);
      // THCITBLP - JxA CITB Levy Percentage
      2271       : TmpField := Form_Real(AppValTotals(@Inv).avtCITBPercentage,13,6);
      // THCITBLA - JxA CITB Levy Amount
      2272       : TmpField := Form_Real(AppValTotals(@Inv).avtLineTypeTotal[14],13,2);
      // THDISCPE  JxA Discount Percentage
      2273       : TmpField := Form_Real(AppValTotals(@Inv).avtDiscountPercentage,13,6);
      //2274
      // THRETNPE - JxA Retention Percentage
      2275       : TmpField := Form_Real(AppValTotals(@Inv).avtRetentionPercentage,13,6);
      // THRETTOT - JxA Retention Total
      2276       : TmpField := Form_Real(AppValTotals(@Inv).avtRetentionCertified,13,6);
      // THDSCTOT - JxA Discount Total
      2278       : TmpField := Form_Real(AppValTotals(@Inv).avtDiscountCertified,13,6);
      // THDSCYTD - JxA Discount Total YTD
      2279       : TmpField := Form_Real(AppValTotals(@Inv).avtDiscountCertifiedYTD,13,6);
      // THRETRTO - JxA Retention Release Total
      2280       : TmpField := Form_Real(AppValTotals(@Inv).avtRetentionRelease,13,6);
      // THRETRYT - JxA Retention Release YTD
      2281       : TmpField := Form_Real(AppValTotals(@Inv).avtRetentionReleaseYTD,13,6);
      // THCONTOT - JxA Contras Total
      //2282       : TmpField := Form_Real(BDiscount{AppValTotals(@Inv).avtContras},13,6);
      2282       : TmpField := Form_Real(AppValTotals(@Inv).avtJxAContrasTotal,13,6);
      // THAPPTOT - JxA Applied For Total
      2277       : TmpField := Form_Real(AppValTotals(@Inv).avtApplied,13,6);
      // THAPPYTD - JxA Applied For Total YTD
      2283       : TmpField := Form_Real(AppValTotals(@Inv).avtAppliedYTD,13,6);
      // THLTMAT1 - JxA 'Materials 1' Total
      2284       : TmpField := Form_Real(AppValTotals(@Inv).avtLineTypeTotal[5],13,2);
      // THLTMAT2 - JxA 'Materials 2' Total
      2285       : TmpField := Form_Real(AppValTotals(@Inv).avtLineTypeTotal[6],13,2);
      // THLTLAB1 - JxA 'Labour 1' Total
      2286       : TmpField := Form_Real(AppValTotals(@Inv).avtLineTypeTotal[7],13,2);
      // THLTLAB2 - 2287   JxA 'Labour 2' Total
      2287       : TmpField := Form_Real(AppValTotals(@Inv).avtLineTypeTotal[8],13,2);
      // THLTRET1 - JxA 'Retention 1' Total
      2288       : TmpField := Form_Real(AppValTotals(@Inv).avtLineTypeTotal[9],13,2);
      // THLTRET2 - JxA 'Retention 2' Total
      2289       : TmpField := Form_Real(AppValTotals(@Inv).avtLineTypeTotal[10],13,2);
      // THLTDED1 - JxA 'Deduction 1' Total
      2290       : TmpField := Form_Real(AppValTotals(@Inv).avtLineTypeTotal[11],13,2);
      // THLTDED2 - JxA 'Deduction 2' Total
      2291       : TmpField := Form_Real(AppValTotals(@Inv).avtLineTypeTotal[12],13,2);
      // THLTDED3 - JxA 'Deduction 3' Total
      2292       : TmpField := Form_Real(AppValTotals(@Inv).avtLineTypeTotal[13],13,2);
      // THLTCIS  - JxA 'CIS' Total
      2293       : TmpField := Form_Real(AppValTotals(@Inv).avtLineTypeTotal[15],13,2);
      // THLTMIS1 - JxA 'Misc 1' Total
      2294       : TmpField := Form_Real(AppValTotals(@Inv).avtLineTypeTotal[16],13,2);
      // THLTMIS2 - JxA 'Misc 2' Total
      2295       : TmpField := Form_Real(AppValTotals(@Inv).avtLineTypeTotal[17],13,2);
      // THCUMTOT - JxT Cumulative Total
      //2296       : TmpField := Form_Real(Calc_JAPDocTotal(Inv, (TotalOrdered<>0.0), 1),13,2);
      2296       : TmpField := Form_Real(AppValTotals(@Inv).avtJxTCumulativeTotal,13,2);
      // THBASIS  - JxT Basis
      //2297       : Case TransMode Of
      2297       : Case AppValTotals(@Inv).avtJxTBasis Of
                     0 : TmpField := 'Incremental';
                     1 : TmpField := 'Gross Incremntl';
                     2 : TmpField := 'Gross';
                   End; // Case TransMode
      // THATR - JxT ATR Flag
      //2298       : TmpField:=YesNoBo(OnPickRun);
      2298       : TmpField:=YesNoBo(AppValTotals(@Inv).avtJxTATR);
      // THDEFVAT - JxT Defer VAT Flag
      //2299       : TmpField:=YesNoBo(AutoPost);
      2299       : TmpField:=YesNoBo(AppValTotals(@Inv).avtJxTDeferVAT);
      // THAPPDED - JxA Applied Deductions YTD
      //2700       : TmpField := Form_Real(BatchNow,13,2);
      2700       : TmpField := Form_Real(AppValTotals(@Inv).avtJxAAppliedDeductions,13,2);
      // THAPPRET - JxA Applied Retentions YTD
      //2701       : TmpField := Form_Real(BatchThen,13,2);
      2701       : TmpField := Form_Real(AppValTotals(@Inv).avtJxAAppliedRetentions,13,2);
      // THSTAGE - JxT Stage
      2702       : Begin
                     SList := TStringList.Create;
                     Try
                       Set_DefaultJARet(SList, BOn, BOff);
                       //If (TransNat >= 0) And (TransNat < SList.Count) Then
                       If (AppValTotals(@Inv).avtJxTStage < SList.Count) Then
                       Begin
                         //TmpField := SList[TransNat];
                         TmpField := SList[AppValTotals(@Inv).avtJxTStage];
                       End; // If (AppValTotals(@Inv).avtJxTStage >= 0) And (AppValTotals(@Inv).avtJxTStage < SList.Count)
                     Finally
                       FreeAndNIL(SList);
                     End; // Try..Finally
                   End;
      // THCITBPR - JxA Previous CITB Total
      2703       : TmpField := Form_Real(AppValTotals(@Inv).avtCITBPrevious,13,2);
      // THLTNORM - JxA 'Normal' Total
      2704       : TmpField := Form_Real(AppValTotals(@Inv).avtLineTypeTotal[0],13,2);
      // THTSHEXP - TimeSheet Exported
      2705       : TmpField := YesNoBo(Inv.THExportedFlag);


      // TCTIME - Trade Counter - Creation Time - only works for transactions added through the Toolkit
      2908       : TmpField := Copy (Inv.TimeCreate, 1, 2) + ':' + Copy (Inv.TimeCreate, 3, 2) + ':' +Copy (Inv.TimeCreate, 5, 2);

      // THTOTEXP - xRN - Total Expected
      2165       : TmpField := Form_Real(Inv.DocLSplit[2],13,Syss.NoQtyDec);
      // THTOTRET - xRN - Total Returned
      2166       : TmpField := Form_Real(Inv.DocLSplit[1],13,Syss.NoQtyDec);
      // THTOTREP - xRN - Total Repaired
      2167       : TmpField := Form_Real(Inv.DocLSplit[3],13,Syss.NoQtyDec);
      // THTOTWOF - xRN - Total Written Off
      2168       : TmpField := Form_Real(Inv.DocLSplit[4],13,Syss.NoQtyDec);
      // THAMTREP - xRN - Total Amount Repaired
      2169       : TmpField := Form_Real(Inv.DocLSplit[6],13,2);
      // 2170 - THRETSTS - xRN - Status (Short)
      // 2171 - THRETSTL - xRN - Status (Long)
      2170, 2171 : Begin
                     SList := TStringList.Create;
                     Try
                       Set_DefaultRetStat(SList, (Inv.InvDocHed In StkRetSalesSplit), (DictNo = 2171));
                       If (TransMode < SList.Count) Then TmpField := SList[TransMode];
                     Finally
                       FreeandNIL(SList);
                     End; // Try..Finally
                   End;
      // THRETSTA - xRN - Status (Number)
      2172       : TmpField := Form_Int(TransMode,0);


      // MH 23/02/06: Added CHDAYRAT and CHCORATE for Brakely
      2383,
      2384  :  TmpField:=Form_Real(TInv^.CXRate[(DictNo=2383)],0,10); {* Doc Day & Co. Rate *}

      // MH 30/05/06: v5.71
      // CHUSER1 - User Defined Field 1
      2115  : TmpField := TInv^.DocUser1;
      // CHUSER2 - User Defined Field 2
      2116  : TmpField := TInv^.DocUser2;
      // CHUSER3 - User Defined Field 3
      2117  : TmpField := TInv^.DocUser3;
      // CHUSER4 - User Defined Field 4
      2118  : TmpField := TInv^.DocUser4;

      // MH 01/02/2010 (v6.3): Added new fields for Web Extensions
      // THWKMNTH - Week/Month
      2119  : TmpField := Form_Int(Inv.thWeekMonth,0);
      // THWKFLOW - Workflow State
      2120  : TmpField := Form_Int(Inv.thWorkflowState,0);

      // MH 13/10/2010 (v6.5): Added Override Location
      // THOVRLOC - Override Location
      2121  : TmpField := thOverrideLocation;

      // MH 24/10/2011 v6.9 ABSEXCH-11712: Added new Transaction Header User Defined Fields
      2122  : TmpField := DocUser5;
      2123  : TmpField := DocUser6;
      2124  : TmpField := DocUser7;
      2125  : TmpField := DocUser8;
      2126  : TmpField := DocUser9;
      2127  : TmpField := DocUser10;
      2128  : TmpField := TInv^.DocUser5;
      2129  : TmpField := TInv^.DocUser6;
      2130  : TmpField := TInv^.DocUser7;
      2131  : TmpField := TInv^.DocUser8;
      2132  : TmpField := TInv^.DocUser9;
      2133  : TmpField := TInv^.DocUser10;

      //PR: 09/03/2012 v6.10 ABSEXCH-10199. Added new field for O/S in Currency including Variance
      // THOSACTV - O/S in currency (including variance)
      //PR: 18/10/2013 ABSEXCH-14703 Added thDeliveryPostcode (THDELPC, CHDELPC) (THOSACTV was removed from dictnary.dat in v6.10

      //THDELPC
      2134  : TmpField := thDeliveryPostcode;

      //CHDELPC
      2135  : TmpField := TInv^.thDeliveryPostcode;

      // MH 28/10/2013 v7.0.7 ABSEXCH-14705: Added Transaction Originator fields
      // THORUSER - Originating User
      2136  : TmpField := Trim(thOriginator);
      // THCRTIME - Creation Time
      2137  : TmpField := Str6ToScreenTime(thCreationTime);
      // THCRDATE - Creation Date
      2138  : TmpField := thCreationDate;
      // CHORUSER - Header - Originating User
      2139  : TmpField := Trim(TInv^.thOriginator);
      // CHCRTIME - Header - Creation Time
      2140  : TmpField := Str6ToScreenTime(TInv^.thCreationTime);
      // CHCRDATE - Header - Creation Date
      2141  : TmpField := TInv^.thCreationDate;
      // CHORDUSR - Header - Order Orig User
      2142  : TmpField := Get_OrigOrdAddr (21, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);
      // CHORDCRT - Header - Order Creation Time
      2143  : TmpField := Str6ToScreenTime(Get_OrigOrdAddr (22, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed));
      // CHORDCRD - Header - Order Creation Date
      2144  : TmpField := Get_OrigOrdAddr (23, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);

      // MH 08/06/2016 2016-R2 ABSEXCH-17590: Added new TH User Defined Fields
      // THUSER11 - User Defined Field 11
      2145  : TmpField := thUserField11;
      // THUSER12 - User Defined Field 12
      2146  : TmpField := thUserField12;
      // CHUSER11 - User Defined Field 11
      2147  : TmpField := TInv^.thUserField11;
      // CHUSER12 - User Defined Field 12
      2148  : TmpField := TInv^.thUserField12;

      // MH 02/10/2014 Order Payments: Added new fields
      // THOPSOR - Order Payment SOR OurRef
      2173  : TmpField := thOrderPaymentOrderRef;
      // THOPTYPE - Order Payment Trans Type
      2174  : TmpField := Form_Int(Ord(thOrderPaymentElement), 0);
      // THOPTYPS - Order Payment Trans Type Desc
      2175  : Case thOrderPaymentElement Of
                opeNA              : TmpField := 'N/A';
                opeOrder           : TmpField := 'Order';
                opeDeliveryNote    : TmpField := 'DeliveryNote';
                opeInvoice         : TmpField := 'Invoice';
                opeOrderPayment    : TmpField := 'OrderPayment';
                opeDeliveryPayment : TmpField := 'DeliveryPayment';
                opeInvoicePayment  : TmpField := 'InvoicePayment';
                opeOrderRefund     : TmpField := 'OrderRefund';
                opeInvoiceRefund   : TmpField := 'InvoiceRefund';
              Else
                TmpField := 'Unknown';
              End; // Case thOrderPaymentElement
      // THOPFLAG - Order Payment Flags
      2176  : TmpField := Form_Int(thOrderPaymentFlags, 0);
      // THCCTYPE - Credit Card Type
      2177  : TmpField := thCreditCardType;
      // THCCNO - Credit Card Number (Last 4)
      2178  : TmpField := thCreditCardNumber;
      // THCCEXPD - Credit Card Expiry (MMYY)
      2179  : TmpField := thCreditCardExpiry;
      // THCCAUTH - Credit Card Trans Auth No
      2180  : TmpField := thCreditCardAuthorisationNo;
      // THCCREFN - Credit Card Trans Ref No
      2181  : TmpField := thCreditCardReferenceNo;

      // MH 26/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Codes
      // THDELCTY - Delivery Country Code
      2182  : TmpField := thDeliveryCountry;
      // THDELCTN - Delivery Country Name
      2183    : TmpField := CountryCodeName (ifCountry2, thDeliveryCountry);
      // CHDELCTY - Header - Delivery Country Code
      2184  : TmpField := TInv^.thDeliveryCountry;
      // CHDELCTN - Header - Delivery Country Name
      2185    : TmpField := CountryCodeName (ifCountry2, TInv^.thDeliveryCountry);
      // CHORDCTY - Hdr - Order Del Country Code
      2186 : Tmpfield := Get_OrigOrdAddr (24, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);
      // CHORDCTN - Hdr - Order Del Country Name
      2187 : Tmpfield := CountryCodeName (ifCountry2, Get_OrigOrdAddr (24, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed));

      // MH 05/01/2015 v7.1 ABSEXCH-15827:
      // THOPVATO - Total VAT On Order Payments
      2188 : TmpField := Form_Real(OrderPaymentsPreviousVATTracker(Inv).pvtOrderVAT, 0, 2);
      // THOPVATD - Total VAT On SDN Payments
      2189 : TmpField := Form_Real(OrderPaymentsPreviousVATTracker(Inv).pvtDeliveryNoteVAT, 0, 2);

      // MH 11/02/2015 v7.1 ABSEXCH-16144: Added ISO Country Code fields
      // CHCMPCTY - Header - Site Co Country (HO)
      2190 : Tmpfield := Get_OrigOrdAddr (25, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);
      // CHCMPCTN - Header - Site Co Cty Name (HO)
      2191 : Tmpfield := Get_OrigOrdAddr (26, TInv^.YourRef, TInv^.OurRef, TInv^.InvDocHed);
      // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Added new fields for Prompt Payment Discount
      // THPPDPER - PPD Discount%
      2192 : Tmpfield := Form_Real(Pcnt2Full(thPPDPercentage),0,2);
      // THPPDDAY - PPD Days
      2193 : Tmpfield := Form_Int(thPPDDays, 0);
      // THPPDDAT - PPD Expiry Date
      2194 : If (thPPDDays > 0) Then
               Tmpfield := CalcDueDate(TransDate, thPPDDays)
             Else
               // 0 days implies no expiry date
               Tmpfield := '';
      // THPPDGOU - PPD Goods Value (Unsigned)
      2195 : Tmpfield := Form_Real(thPPDGoodsValue, 0, 2);
      // THPPDVAU - PPD VAT Value (Unsigned)
      2196 : Tmpfield := Form_Real(thPPDVATValue, 0, 2);
      // THPPDTOU - PPD Total Value (Unsigned)
      2197 : Tmpfield := Form_Real(Round_Up(thPPDGoodsValue + thPPDVATValue, 2), 0, 2);
      // THPPDTAK - PPD Taken Y/N
      2198 : Tmpfield := YesNoBo(thPPDTaken <> ptPPDNotTaken);
      // THPPDTAM - PPD Taken Mode
      2199 : Tmpfield := Form_Int(Ord(thPPDTaken), 0);
      // THPPDXCR - PPD Credit Note Y/N
      2205 : Tmpfield := YesNoBo(thPPDCreditNote);

      // THPPDGOO - PPD Goods Value (Signed)
      2206 : Tmpfield := Form_Real(thPPDGoodsValue * DocCnst[InvDocHed] {* DocNotCnst}, 0, 2);    // Show Sales as -ve
      // THPPDVAT - PPD VAT Value (Signed)
      2207 : Tmpfield := Form_Real(thPPDVATValue * DocCnst[InvDocHed] {* DocNotCnst}, 0, 2);      // Show Sales as -ve
      // THPPDTOT - PPD Total Value (Signed)
      2208 : Tmpfield := Form_Real(Round_Up(thPPDGoodsValue + thPPDVATValue, 2) * DocCnst[InvDocHed] {* DocNotCnst}, 0, 2);  // Show Sales as -ve

      // PKR. 22/01/2016. ABSEXCH-17109. Added Out of Period field for Intrastat, plus copy field.
      // THINTOOP - Intrastat Out of Period
      2386 : Tmpfield := YesNoBo(thIntrastatOutOfPeriod);
      // CHINTOOP - Intrastat Out of Period
      2387 : Tmpfield := YesNoBo(TInv^.thIntrastatOutOfPeriod);

      // SSK 20/11/2017 2018 R1 ABSEXCH-19397: Added new anonymous fields for DOCUMENT table
      // THANONST - AnonymisationStatus
      2389 : Tmpfield := YesNoBo(thAnonymised);

      // THANONDT - Anonymised Date
      2390 : Tmpfield := thAnonymisedDate;

      // THANONTM - Anonymised Time
      2391 :  if trim(thAnonymisedTime) <> '' then
                Tmpfield := Str6ToScreenTime(thAnonymisedTime)
              else
                Tmpfield := '';

    end; {Case..}

    Link_DocDict:=TmpField;
  end; {Func..}



  Function CalcTLORDUS1 : Real;
  Var
    BoFlag : Boolean;
    RNum   : Double;
  Begin
    Result := 0.0;

    Try
      { Link to stock record }
      LinkOtherdb(IDetailF, StockF);

      { Convert STUSER1 to number }
      RNum := 0.0;
      StrDouble(Stock.StkUser1, BoFlag, RNum);
      If BoFlag Then
        Result := RNum * Id.Qty;
    Except
      On Ex:Exception Do
        ;
    End;
  End;


  Function CalcTLORDWEI : Real;
  Var
    BoFlag : Boolean;
    RNum   : Double;
  Begin
    Result := 0.0;

    Try
      { Link to stock record }
      LinkOtherdb(IDetailF, StockF);

      Result := Stock.SWeight * Id.Qty;
    Except
      On Ex:Exception Do
        ;
    End;
  End;


  { ========= Function to Return Detail Dict Values ======== }

  Function Link_IDDict(DictNo  :  LongInt)  :  Str255;

  Var
    TmpField    :  Str255;
    TmpField2   :  Str20;
    VT          :  VATType;
    CrDr        : DrCrType;
    RNum, RNum2 : Double;
    TmpId       : IDetail;
    BoFlag, OK  : Boolean;
    UOR         : Byte;
    Decs        : Byte;

        { ====== Func to return CQ Val ====== }

    Function DocLocAddr(IFol    :  LongInt;
                        LocMode :  Byte)   :  Str255;


    Const
      Fnum     =  IDetailF;
      Keypath  =  IdFolioK;


    Var
      KeyS,
      KeyChk   :  Str255;
      SCode    :  Str20;
      FoundCode:  Str10;

      TmpId    :  IDetail;

      FoundOk  :  Boolean;

      B_Func,
      TmpKPath,
      TmpStat
               :  Integer;

      TmpRecAddr
               :  LongInt;


    Begin
      Result:='';

      FoundOk:=BOff;

      TmpId:=Id;

      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      KeyChk:=FullNomKey(IFol);

      B_Func:=B_GetGEq;

      KeyS:=FullIdKey(IFol,1);

      Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
      With Id do
      Begin

        FoundOk:=(Not EmptyKey(MLocStk,MLocKeyLen));

        If (Not FoundOk) then
        Begin

          B_Func:=B_GetNext;

          Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
        end;

      end; {While..}

      If (FoundOk) then
      Begin
        FoundCode := Id.MLocStk;
        GetMLoc(Application.MainForm,FoundCode,FoundCode, SCode,-1);


        With MLocCtrl^.MLocLoc do
        Case LocMode of
          1..5  : Result:=loAddr[LocMode];
             6  : Result:=loName;
             7  : Result:=loContact;
             8  : Result:=loTel;
             9  : Result:=loFax;
        end; {Case..}

      end;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      Id:=TmpId;

      DocLocAddr:=Result;
    end; {Proc..}


  { links to original order for line to get customer info }
  Function SOP_OrderLink(SOPLink,
                         SOPLNo   :  LongInt;
                         Mode     :  Byte)  :  ShortString;
  Var
    TmpId    :  ^Idetail;
    TmpCust  : ^CustRec;
    TmpField : ShortString;
  Begin
    New(TmpId);
    New (TmpCust);

    TmpId^:=Id;
    TmpCust^ := Cust;

    TmpField := '';

    If (SOPLink<>0) then Begin
      { Get original order line }
      If (CheckRecExsists(FullIdKey(SOPLink,SOPLNo),IdetailF,IdLinkK)) then Begin
        { Get original customer }
        If (CheckRecExsists(FullCustCode(Id.CustCode),CustF,CustCodeK)) then Begin
          With Cust Do
            Case Mode Of
              1    : TmpField := Company;         { Cust Name }
              2..6 : TmpField := Addr[Mode - 1];  { Address 1..5 }
              7    : TmpField := Contact;         { Contact }
              8    : TmpField := Phone;
              9    : TmpField := Phone2;
              10   : TmpField := Fax;
              11   : TmpField := CustCode;
              12   : TmpField := acCountry;
              13   : TmpField := CountryCodeName (ifCountry2, acCountry);
            End; { Case }
        End; { If }

        Cust := TmpCust^;
      End; {If..}

      Id:=TmpId^;
    end;

    Dispose(TmpCust);
    Dispose(TmpId);

    Result := TmpField;
  end; {Func..}


  { links to original order for line to get Transaction Details }
  Function SOP_OrderDets(SOPLink : LongInt;
                         Mode    : Byte)  :  ShortString;
  Var
    TmpInv   : ^InvRec;
  Begin { SOP_OrderDets }
    Result := '';

    If (SOPLink<>0) then Begin
      New(TmpInv);
      TmpInv^:=Inv;

      { Get original order line }
      If (CheckRecExsists(FullNomKey(SOPLink),InvF,InvFolioK)) then Begin
        Case Mode Of
          { YourRef Short }
          1  : Result := Inv.YourRef;

          { YourRef Long }
          2  : Result := Inv.TransDesc;
        End; { Case }
      End; {If..}

      Inv := TmpInv^;
      Dispose(TmpInv);
    End; { If }
  End; { SOP_OrderDets }


  {$IFDEF EDLL}
  { ====== Func to return Alt Code items ====== }
  { NOTE: This function is duplicated in Exchequer - keep in sync }
  Function GetAltStkDet(sdMode   :  Byte;
                        SuppFilt :  Str10;
                        LineFolio,
                        StkFolio :  LongInt)  :  Str255;


  Const
    Fnum     =  MLocF;


  Var
    KeyS,
    KeyChk   :  Str255;

    FoundOk  :  Boolean;

    Keypath,
    B_Func,
    TmpKPath,
    TmpStat
             :  Integer;

    TmpRecAddr
             :  LongInt;


  Begin
    { NOTE: This function is duplicated in Exchequer - keep in sync }
    Result:='';

    FoundOk:=BOff;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    Case sdMode of

      1..10
         :  Begin
              KeyChk:=FullNomKey(StkFolio);
              Keypath:=MLSecK;
            end;
      111..120
         : Begin
             KeyChk:=Strip('R',[#0],FullRunNoKey(LineFolio,StkFolio));
             Keypath:=MLSuppK;
           end;
    end;

    KeyChk:=PartCCKey(NoteTCode,NoteCCode)+KeyChk;


    B_Func:=B_GetGEq;

    KeyS:=KeyChk;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
    With MLocCtrl^.sdbStkRec do
    Begin

      Case sdmode of
        1..10  :  FoundOk:=(sdSuppCode=SuppFilt);
        else      FoundOk:=BOn;
      end; {Case..}

      If (Not FoundOk) then
      Begin

        B_Func:=B_GetNext;

        Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
      end;

    end; {While..}

    If (FoundOk) then
    Begin

      With MLocCtrl^.sdbStkRec do
      Case sdMode of
        1,111
              : Result:=sdCode1;
        2,112 : Result:=sdDesc;
        8,118 : Result:=PSymb(sdROCurrency);
        9,119 : Result:=Form_Real(sdROPrice,0,Syss.NoCosDec);
      end; {Case..}

    end;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);

    { NOTE: This function is duplicated in Exchequer - keep in sync }
  end; {Proc..}
  {$ENDIF}

  Function CalcTranDecs (Const DocHed : DocTypes) : Byte;
  Begin { CalcTranDecs }
    If (DocHed In [NMT, TSH]) then Begin
      Result := 2;
    End { If }
    Else Begin
      { Take decimals based on trans type }
      If (DocHed In SalesSplit) then
        Result := Syss.NoNetDec
      else
        Result := Syss.NoCosDec;
    End; { Else }
  End; { CalcTranDecs }

  // Load invoice and get Settlement Discount Percentage
  Function GetSettlePerc (Const DoIt : Boolean; Const InvFolio : LongInt) : Double;
  Var
    TmpInv               : ^InvRec;
    TmpKPath, TmpStat    : Integer;
    TmpRecAddr           : LongInt;
  Begin { GetSettlePerc }
    Result := 0.0;

    If DoIt Then Begin
      // Check transaction not already loaded
      If (Inv.FolioNum = InvFolio) Then
        Result := Inv.DiscSetl
      Else Begin
        // need to load transaction to get Settlement discount Percentage
        New(TmpInv);
        TmpInv^:=Inv;

        TmpKPath:=GetPosKey;
        TmpStat:=Presrv_BTPos(InvF,TmpKPath,F[InvF],TmpRecAddr,BOff,BOff);

        If CheckRecExsists(FullNomKey(InvFolio), InvF, InvFolioK) then
          Result := Inv.DiscSetl;

        { Restore original invoice and position }
        TmpStat:=Presrv_BTPos(InvF,TmpKPath,F[InvF],TmpRecAddr,BOn,BOff);
        Inv := TmpInv^;
        Dispose(TmpInv);
      End; { Else }
    End; { If DoIt }
  End; { GetSettlePerc }

  //-------------------------------------------------------------------------

  Function GetTermsLineBudget : Double;
  Var
    {SaveTH,} SaveTL : TBtrieveSavePosition;
    sKey : Str255;
    iStatus : SmallInt;
  Begin // GetTermsLineBudget
    Result := 0.0;

    // Save the current position in the files for the current key
    //SaveTH := TBtrieveSavePosition.Create;
    SaveTL := TBtrieveSavePosition.Create;
    Try
      //SaveTH.SaveFilePosition (InvF, GetPosKey);
      //SaveTH.SaveDataBlock (@Inv, SizeOf(Inv));
      SaveTL.SaveFilePosition (IdetailF, GetPosKey);
      SaveTL.SaveDataBlock (@Id, SizeOf(Id));

      //------------------------------

      sKey := FullIDKey(ID.SOPLink, ID.SOPLineNo);
      iStatus := Find_Rec(B_GetEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdLinkK, sKey);
      If (iStatus = 0) Then
      Begin
        Result := Id.CostPrice;
      End; // If (iStatus = 0)

      (*** MH 11/05/07: Modified to use SopLinl/SOPLineNo
      // Check TH is loaded so we can get the JxT OurRef
      If (Inv.FolioNum <> Id.FolioRef) Then
      Begin
        sKey := FullNomKey(Id.FolioRef);
        iStatus := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, sKey);
        If (iStatus <> 0) Then
          ResetRec(InvF);
      End; // If (Inv.FolioNum <> Id.FolioRef)

      // load JxT so we can get the Folio Number
      If (Inv.DeliverRef <> '') Then
      Begin
        sKey := Inv.DeliverRef;
        iStatus := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, sKey);
        If (iStatus = 0) Then
        Begin
          // Load the matching line for the JxT
          sKey := FullNomKey(Inv.FolioNum) + FullNomKey(Id.ABSLineNo);
          iStatus := Find_Rec(B_GetEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdLinkK, sKey);
          If (iStatus = 0) Then
          Begin
            Result := Id.CostPrice;
          End; // If (iStatus = 0)
        End; // If (iStatus = 0)
      End; // If (Inv.DeliverRef <> '')
      ***)
    Finally
      // Restore position in file
      //SaveTH.RestoreSavedPosition;
      //SaveTH.RestoreDataBlock (@Inv);
      //SaveTH.Free;

      SaveTL.RestoreSavedPosition;
      SaveTL.RestoreDataBlock (@Id);
      SaveTL.Free;
    End; // Try..Finally
  End; // GetTermsLineBudget

  //-------------------------------------------------------------------------

  Function GetBoMPickedQty(Const LineFolio, LineNo : LongInt; Const ComponentQty : Double) : Double;
  Var
    SaveTL : TBtrieveSavePosition;
    sKey : Str255;
    iStatus : LongInt;
  Begin // GetBoMPickedQty
    Result := 0.0;

    // Save the current position in the files for the current key
    SaveTL := TBtrieveSavePosition.Create;
    Try
      SaveTL.SaveFilePosition (IdetailF, GetPosKey);
      SaveTL.SaveDataBlock (@Id, SizeOf(Id));

      //------------------------------

      sKey := FullIDKey(LineFolio, LineNo);
      iStatus := Find_Rec(B_GetEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdLinkK, sKey);
      If (iStatus = 0) Then
      Begin
        Result := Round_Up((Id.QtyPick / Id.Qty) * ComponentQty, Syss.NoQtyDec);
      End; // If (iStatus = 0)
    Finally
      SaveTL.RestoreSavedPosition;
      SaveTL.RestoreDataBlock (@Id);
      SaveTL.Free;
    End; // Try..Finally
  End; // GetBoMPickedQty

  //-------------------------------------------------------------------------

  Function GetBoMParentStockCode (Const StockFolio : LongInt) : ShortString;
  Var
    SaveST : TBtrieveSavePosition;
    sKey : Str255;
    iStatus : LongInt;
  Begin // GetBoMParentStockCode
    Result := '';

    // Save the current position in the files for the current key
    SaveST := TBtrieveSavePosition.Create;
    Try
      SaveST.SaveFilePosition (StockF, GetPosKey);
      SaveST.SaveDataBlock (@Stock, SizeOf(Stock));

      //------------------------------

      sKey := FullNomKey(StockFolio);
      iStatus := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkFolioK, sKey);
      If (iStatus = 0) Then
      Begin
        Result := Stock.StockCode;
      End; // If (iStatus = 0)
    Finally
      SaveST.RestoreSavedPosition;
      SaveST.RestoreDataBlock (@Stock);
      SaveST.Free;
    End; // Try..Finally
  End; // GetBoMParentStockCode

  //------------------------------

  Begin
    RNum := 0.0;
    RNum2 := 0.0;
    TmpField:='';
    TmpField2:='';
    UOR:=0;

    With Id do
    Case DictNo of
      // MH 02/09/05: Changed to run off the line as the TH isn't necessarily loaded for TL
      //              fields - was totally screwing up VRW report! :-)
      //3000  :  TmpField:=Inv.OurRef;
      3000  :  TmpField:=DocPRef;

      3001  :  TmpField:=Form_Int(Ord(LineType),0);                      {* Line Type *}

      3002  :  TmpField:=DocCodes[IdDocHed];            {* Line Doc Type *}

      3003  :  TmpField:=CustCode;                      {* Line Acc Code *}

      3004,
      3083  :  TmpField:=PDate;                         {* Line Date *}

      3005  :  TmpField:=Form_Int(ABSLineNo,0);         {* Line ABS Line No *}

      3020  :  TmpField:=Item;                          {* Line Item No *}

      3021,
      3053  :  TmpField:=Form_Real(Qty,0,Syss.NoQtyDec);{* Line Qty *}

      3022  :  TmpField:=StockCode;                     {* Stock Code *}

      3023,
      3084  :  TmpField:=Desc;                          {* Description *}

      3024  :  TmpField:=Form_Real(NetValue,0,Syss.NoNetDec); {* Netvalue Sales *}

      3025  :  TmpField:=Form_Real(NetValue,0,Syss.NoCosDec); {* Netvalue PIN *}

      3026  :  TmpField:=Form_Real(Discount,0,5);       {* Line Discount *}

      3027  :  TmpField:=Form_Real(DetLTotal(Id,False,False,0.0),0,2); {* Line Total *}

      3028  :  TmpField:=VATCode;                       {* Line VAT Code *}
                                                        {* Netvalue Sales *}

      3029  :  Begin
                 UOR:=fxUseORate(False,BOn,CXRate,UseORate,Currency,0);
                 TmpField:=Form_Real(Conv_TCurr(DetLTotal(Id,False,False,0.0),XRate(CXRate,False,Currency),Currency,UOR,False),0,6);
               End;

      3030  :  TmpField:=Form_Real(CostPrice,0,6);      {* Cost Price *}

      3031  :  TmpField:=Form_Real(QtyMul,0,Syss.NoQtyDec);         {* Qty Multiplier *}


      // HM 10/11/00: Added Bentley Line Count field for Bentley
      3032  :  If IsBentleyLine Then TmpField := Form_Int(BentLineCount,0);

      3050  :  TmpField:=Form_Real(Qty_OS(Id),0,Syss.NoQtyDec);     {* Line Qty OS *}

      3051,
      3055  :  TmpField:=Form_Real(QtyPick,0,Syss.NoQtyDec);        {* Line Qty Picked *}

      3052  :  TmpField:=Form_Real(QtyWOff,0,Syss.NoQtyDec);        {* Line Qty WOff *}

      3054  :  TmpField:=Form_Real(QtyDel,0,Syss.NoQtyDec);         {* Line Qty Delivered *}

      3056  :  TmpField:=Form_Real(Qty*StkAdjCnst[IdDocHed],0,Syss.NoQtyDec); {* Signed Line Qty *}

      // HM 16/05/02: Added Round_Up
      3057  :  TmpField:=Form_Real(Round_Up(DetLTotal(Id,True{False},False,0.0), 2),0,2); {* Line Total Less Discount *}

      3058,
      3059  :  Begin
                 ShowDrCr(Id.Qty,CrDr);
                 TmpField:=Form_Real (CrDr[(DictNo=3059)], 0, Syss.NoQtyDec);
               end;

      { Line Base Eq Total }
      3060  :  TmpField:=Form_Real(DetLTotal(Id,True, False,0.0) * LineCnst(Id.Payment),0,2);

      { Line Disc in % symbol }
      3061  :  TmpField:=PPR_PAmountStr(Discount, DiscountChr);

      3080  :  If (SOPLink <> 0) Then TmpField:=SOP_GetSORNo(SOPLink);         {* Line Link Ref *}

      3081  :  TmpField:=Form_Real(Qty*QtyMul,0,Syss.NoQtyDec);     {* Total Qty *}

      3082  :  TmpField:=Form_Real(LWeight,0,6);        {* Line Unit Weight *}

      { HM 23/09/98: Noticed this wasn't coded and coded it }
      3085,                                             {* Line Serial/Batch Number *}
      3086  : TmpField:= GetSerialNote ('1', Chr(Ord('1') + (DictNo - 3085)));

      3087  :  TmpField:=Form_Int(NomCode,0);           {* Line Nominal Code *}

      3088,
      3089  :  TmpField:=CCDep[(DictNo=3088)];          {* Line CC/Dep *}

      3090,
      3091  :   Begin                                  {* CC/Dep Desc *}

                  TmpField2:=CCDep[(DictNo=3090)];

                  OK := GetCCDep(Application.MainForm,
                                 TmpField2,
                                 TmpField2,
                                 (DictNo=3090),
                                 -1);

                  If (Ok) then
                    TmpField:=PassWord.CostCtrRec.CCDesc
                  else
                    TmpField:='';

                end;

      3094  : TmpField:= GetSerialNote ('1', '0');

      3095  : TmpField:=Form_Int(LineNo,0);         {* Line Position No *}

      3096,
      3097  :  TmpField:=Form_Real(CXRate[(DictNo=3097)],0,10); {* Doc Day & Co. Rate *}

      3100  :  TmpField:=Form_Int(PostedRun,0);         {* Line Posted Run *}

      3101  :  TmpField:=Form_Int(FolioRef,0);          {* Line Folio Number*}

      3102  :  TmpField:=Payment;                       {* Payment Status *}

      3103  :  TmpField:=Form_Int(KitLink,0);          {* Line Folio Number*}

      3104  :  TmpField:=Form_Int(Reconcile,0);        {* Line Reconciled status *}

      3106  :  TmpField:=JobCode;                      {* Job Code *}
      3107  :  TmpField:=AnalCode;                     {* Job anal Code *}

      3108,
      3109  : Begin
                ShowDrCr(Id.NetValue, CrDr);

                TmpField:=Form_Real (CrDr[(DictNo=3109)], 0, 2);
              end;


      3110  : If ExVerIsMultiCcy Then Begin
                Decs := CalcTranDecs (Id.IdDocHed);
                (*
                If (Id.IdDocHed In [NMT, TSH]) then Begin
                  { HM 22/02/99: Force rounding to 2dp }
                  Decs := 2;
                End { If }
                Else Begin
                  { HM: Take decimals based on trans type }
                  If (Id.IdDocHed In SalesSplit) then
                    Decs := Syss.NoNetDec
                    {TmpField:=Form_Real (RNum, 0,Syss.NoNetDec)}
                  else
                    Decs := Syss.NoCosDec;
                    {TmpField:=Form_Real (RNum, 0,Syss.NoCosDec);}
                End; { Else }
                *)

                Rnum:=Round_Up(Conv_TCurr(Id.NetValue,Id.CXRate[UseCoDayRate],Id.Currency,UOR,BOff), Decs);

                TmpField:=Form_Real (RNum, 0,Decs);
              End;

      3111  : TmpField:=Form_Real (Id.VAT, 0, 2);

      3114,
      3115  : Begin
                TmpId := Id;

                With TmpId Do Begin
                  Qty := 1;
                  {QtyMul := 1; Not sure if set this to 1, as might be priced by pack }

                  { HM 24/03/99: Modified to set decimals correctly for NMT/ADJ transactions }
                  Decs := CalcTranDecs (TmpId.IdDocHed);

                  RNum := Round_Up(DetLTotal(TmpId, BOn, (DictNo = 3115), GetSettlePerc (DictNo = 3115, TmpId.FolioRef)) * LineCnst(Payment), Decs);

                  (*
                  If (TmpId.IdDocHed In SalesSplit) Then
                    TmpField:=Form_Real (RNum, 0, Syss.NoNetDec)
                  Else
                    TmpField:=Form_Real (RNum, 0, Syss.NoCosDec);
                  *)
                  TmpField:=Form_Real (RNum, 0, Decs);
                End; { With }
              End;

      3205,
      3206  : Begin
                TmpId := Id;

                With TmpId Do Begin
                  Qty := 1;
                  {QtyMul := 1; Not sure if set this to 1, as might be priced by pack }

                  Decs := 6;
                  RNum := Round_Up(InvLTotalND(TmpId,
                                               BOn,
                                               GetSettlePerc (DictNo = 3206, TmpId.FolioRef) * Ord (DictNo = 3206),
                                               -1), Decs);

                  (*
                  If (TmpId.IdDocHed In SalesSplit) Then
                    TmpField:=Form_Real (RNum, 0, Syss.NoNetDec)
                  Else
                    TmpField:=Form_Real (RNum, 0, Syss.NoCosDec);
                  *)
                  TmpField:=Form_Real (RNum, 0, Decs);
                End; { With }
              End;

      3116,
      3117  : Begin
                { HM 24/03/99: Modified to set decimals correctly for NMT/ADJ transactions }
                Decs := CalcTranDecs (Id.IdDocHed);

                (* Very weird - rounding it twice!
                If (IdDocHed In SalesSplit) Then
                  TmpField := Form_Real(Round_Up(Round_Up(NetValue, Syss.NoNetDec), 2), 0, Syss.NoNetDec)
                Else
                  TmpField := Form_Real(Round_Up(Round_Up(NetValue, Syss.NoCosDec), 2), 0, Syss.NoCosDec);
                *)
                TmpField := Form_Real(Round_Up(Round_Up(NetValue, Decs), 2), 0, Decs);

                If (DictNo = 3117) And (RNum = 0.0) And (Id.Qty <> 0) Then
                  TmpField := 'FOC';
              End;
      3118  : TmpField := Form_Int(Currency, 0);
      3119  : TmpField := PSymb(Currency);

    {$IFDEF SOP}
      3120,
      3121  : Begin { Line Qty picked }
                With Id do
                  If (KitLink=0) or (Is_FullStkCode(StockCode)) then
                    Rnum:=Id.QtyPick;

                If (DictNo=3121) then Begin
                  Rnum:=DivWChk(Rnum,RealStr(Strip('B',[#32],Stock.BinLoc)));
                  TmpField:=Form_Real(Rnum, 0, 2);
                End { If }
                Else Begin
                  TmpField:=Form_Real(Rnum, 0, Syss.NoQtyDec);
                End; { Else }
              end;

      3122  : Begin                                                                  {* Line Qty WOFF *}
                With Id do
                  If (KitLink=0) or (Is_FullStkCode(StockCode)) then
                    Rnum:=Id.QtyPWOFF;

                TmpField:=Form_Real(Rnum, 0, Syss.NoQtyDec);
              end;


      3123 : Begin
               With Id do
                 If (KitLink=0) or (Is_FullStkCode(StockCode)) then
                   Rnum:=SOP_QtyLink(SOPLink,SOPLineNo,4)-QtyPick;

               TmpField:=Form_Real(Rnum, 0, Syss.NoQtyDec);
             end;

      3124..3127
           : Begin { Order Qty Ordered, Order Qty O/S, Order Qty WOFF, Order Qty Delivered }
                With Id Do Begin
                  If (KitLink=0) or (Is_FullStkCode(StockCode)) then
                    Rnum:=SOP_QtyLink(SOPLink,SOPLineNo,(DictNo-3123));
                End; { If }

                TmpField:=Form_Real(Rnum, 0, Syss.NoQtyDec);
              end;

    {$ENDIF}

    {$IFDEF STK}
      {$IFDEF PF_ON}
        3128 : TmpField:=Form_Real(Calc_IdQty(Qty, QtyMul, UsePack) * LWeight, 0, 2);
      {$ENDIF}
    {$ENDIF}


      3129 : Begin
               Rnum:=Round_Up(Calc_IdQty(Qty,QtyMul,UsePack)*CostPrice,Syss.NoCosDec);
               TmpField:=Form_Real(Rnum,0,2);
             End;

      3062 : TmpField := MLocStk;

      3063 : TmpField := Form_Int(DocLtLink,0); {* Printed Line Type *}

      3064 : Begin
              {$B-}

                 With Id do
                   If ((KitLink=0) or (Is_FullStkCode(StockCode))) and (SOP_QtyLink(SOPLink,SOPLineNo,1)<>0) Then Begin
                      Rnum:=SOP_QtyLink(SOPLink,SOPLineNo,2);

                      { Check Quantity Outstanding }
                      If (Rnum=0) then Begin
                        Rnum2:=SOP_QtyLink(SOPLink,SOPLineNo,3);

                        { Quantity Written Off }
                        If (Rnum2<>0) then
                          TmpField:=StringsRec^.fsSVStrs[3]+' '+Form_Real(Rnum2,0,Syss.NoQtyDec)
                        else
                          TmpField:=StringsRec^.fsSVStrs[1];
                      End { If }
                      Else
                        TmpField:=StringsRec^.fsSVStrs[2];
                    End; { With }

                 {TmpField:=PPR(TmpField,Fpos[FTYONo]);}

               {$B+}
             End;

      { 1st Multi-Location line fields }
      3130..3138
           : TmpField := DocLocAddr(Id.FolioRef, (DictNo - 3129));

      { Cust info from SOP Order }
      3140..3150
           : TmpField := SOP_OrderLink (SOPLink,SOPLineNo,DictNo-3139);
      // MH 11/02/2015 v7.1 ABSEXCH-16145: Added ISO Country Code fields
      // TLORCTRY - Order Country
      3151    : TmpField := SOP_OrderLink (SOPLink,SOPLineNo,12);
      // TLORCNTN - Order Country Name
      3152    : TmpField := SOP_OrderLink (SOPLink,SOPLineNo,13);

      { Line Qty shown in cases }
      3160..3164
           : Begin
               Case DictNo of
                 3160 : RNum := Ea2Case(Id, Stock, Qty);
                 3161 : RNum := Ea2Case(Id, Stock, QtyPick);
                 3162 : RNum := Ea2Case(Id, Stock, QtyWOff);
                 3163 : RNum := Ea2Case(Id, Stock, QtyPWOff);
                 3164 : RNum := Ea2Case(Id, Stock, QtyDel);
               End; { Case }

               TmpField:=Form_Real(Rnum,0,Syss.NoQtyDec);
             End;

      {$IFDEF EDLL}
      { HM 17/11/97: Alternate Stock Code fields added }
      3170..3189
           : If Is_FullStkCode(Id.StockCode) and (Stock.StockCode=Id.StockCode) Then Begin
               { Alt Code look up }

               With Id do
                 TmpField := GetAltStkDet((DictNo-3169)+(100*Ord(DictNo>=3180)),
                                          Inv.CustCode,
                                          sdbFolio,
                                          Stock.StockFolio);
             End;
      {$ENDIF}

      {$IFDEF EDLL}
      { HM: 07/05/98: Fields added to Form Designer for Bentley }
      3065 : Begin { TLQORD * STUSER1 }
               RNum := CalcTLORDUS1;

               TmpField:=Form_Real(RNum, 0, 6);
             End;
      3066 : Begin { Running Total of 3065 }
               TmpField:=Form_Real(TotTLORDUS1, 0, 6);
             End;
      3067 : Begin { TLQORD * STWEIGTS }
               RNum := CalcTLORDWEI;

               TmpField:=Form_Real(RNum, 0, 6);
             End;
      3068 : Begin { Running Total of 3067 }
               TmpField:=Form_Real(TotTLORDWEI, 0, 6);
             End;
      {$ENDIF}

      3092 : TmpField := SOP_OrderDets(SOPLink,1);  { Order Your Ref }
      3093 : TmpField := SOP_OrderDets(SOPLink,2);  { Order Your Ref Long }

      { HM 01/09/99: Added new field for Kevin Horlock }
      3098 : TmpField := Form_Int(SOPLineNo,0);     { Order Line No }

      {----------------- HM 20/10/99 Added v4.31 fields ----------------------}
      { Pay-In Ref }
      // HM 09/07/02: Modified to support posted transactions
      //3099 : TmpField := Extract_PayRef1(Id.StockCode);
      3099 : If (PostedRun > 0) then
               TmpField := Extract_PayRef2(StockCode)
             Else
               TmpField := Extract_PayRef1(StockCode);

      3165 : TmpField := Form_Int(NomMode,0);

      { User Defined 1-4 }
      3190 : Tmpfield := LineUser1;
      3191 : Tmpfield := LineUser2;
      3192 : Tmpfield := LineUser3;
      3193 : Tmpfield := LineUser4;
      { Intrastat uplift % }
      3194 : Tmpfield := Form_Real(SSDUplift,13,6);
      { Intrastat Country of origin }
      3195 : Tmpfield := SSDCountry;
      { SSD Commodity code }
      3196 : Tmpfield := SSDCommod;
      { Use Line Intrastat Fields }
      3197 : Tmpfield := YesNoBo(SSDUseLine);
      { Price Multiplier }
      3198 : Tmpfield := Form_Real(PriceMulx,13,6);
      { Back-To-Back Order Folio }
      3199 : Tmpfield := Form_Int(B2BLink,0);
      { Back-To-Back Order Line No }
      3200 : Tmpfield := Form_Int(B2BLineNo,0);
      { SSD unit into sales unit }
      3201 : Tmpfield := Form_Real(SSDSPUnit,13,6);

      // HM 23/06/00: Added new field
      3202 : Tmpfield := Form_Real(COSConvRate,13,6);

      // HM 27/06/01: v4.32.001
      3203 : TmpField := VATIncFlg;

      // HM 07/11/01: v4.32.002 - Added Reconciliation Date for Longleat
      3204 : TmpField := ReconDate;

      // TLLINSRC - Line Source (0=?,1=CIS,2=Cust)
      3207 : Tmpfield := Form_Int(AutoLineType,0);
      // TLCISRTC - CIS Rate Code
      3208 : Tmpfield := CISRateCode;
      // TLCISRAT - CIS Rate %
      3209 : Tmpfield := Form_Real(CISRate,13,6);
      // TLCOSAPP - Cost Apportionment Total
      3210 : Tmpfield := Form_Real(CostApport,13,Syss.NoCosDec);

      // HM 02/06/03: Added fields for v5.51
      // TLNOMVAT - VAT Flag for NOMs
      3211 : TmpField := Form_Int(NOMIOFlg,0);

      //TLBINQTY - Bin Quantity
      3212 : TmpField := Form_Real(BinQty,10,Syss.NoQtyDec);

      // HM 05/03/04: Added fields for Apps & Vals
      // TLCERYTD - JxT Certified Total YTD
      3213 : TmpField := Form_Real(QtyPWOff,13,6);
      // TLLINTYP - Printed Line Type Desc
      3214 : If (DocLtLink = 0) Then
             Begin
               TmpField := 'Normal'
             End // If (DocLtLink = 0)
             Else
             Begin
               If (DocLtLink < Low (JALTypes^)) Then
               Begin
                 // MH 25/10/2011 v6.9: Added Custom Fields info object
                 //TmpField := SyssVAT^.VATRates.UDFCaption[DocLTLink+6];
                 TmpField := CustomFields[cfLinetypes, DocLtLink].cfCaption;
               End // If (DocLtLink < Low (JALTypes^))
               Else
               Begin
                 TmpField := JALTypes^[DocLtLink];
               End; // Else
             End; // Else

      // TLCISADJ - CIS Adjustment
      3215 : TmpField := Form_Real(CISAdjust, 13, 2);
      //TLJADTYP - JAP Deduction Type
      3216 : TmpField := Form_Int(JAPDedType, 0);

      // HM 31/01/05 - v5.61
      // TLDEDQTY - Stock Deduct Qty
      3217 : TmpField := Form_Real(DeductQty, 13, Syss.NoQtyDec);

      // MH 13/02/07 - v5.71
      // TLJXTBUD - JxA Terms Budget
      3218 : TmpField := Form_Real(GetTermsLineBudget, 13, 2);

      // MH 22/07/05: Added Returns fields for v5.70
      // TLQTYEXP - xRN - Qty Expected
      3301 : TmpField := Form_Real(QtyPick, 13, Syss.NoQtyDec);
      // TLQTYRET - xRN - Qty Returned
      3302 : TmpField := Form_Real(Qty, 13, Syss.NoQtyDec);
      // TLQTYREP - xRN - Qty Repaired
      3303 : TmpField := Form_Real(QtyPWOff, 13, Syss.NoQtyDec);
      // TLTOTREP - xRN - Total Qty Repaired
      3304 : TmpField := Form_Real(QtyDel, 13, Syss.NoQtyDec);
      // TLQTYWOF - xRN - Qty Written Off
      3305 : TmpField := Form_Real(SSDUplift, 13, Syss.NoQtyDec);
      // TLTOTWOF - xRN - Total Qty Written Off
      3306 : TmpField := Form_Real(QtyWOff, 13, Syss.NoQtyDec);
      // TLB2BREP - xRN - Back-To-Back Repair
      3307 : TmpField := YesNoBo(SSDUseLine);
      // TLWARRAN - xRN - Under Warranty
      3308 : TmpField := YesNoBo(NOMIOFlg = 1);
      // TLREASON - xRN - Reason (Number)
      3309 : TmpField := Form_Int(DocLTLink,0);
      // TLREASOD - xRN - Reason Desc
      3310 : TmpField := Get_RetLineStat(DocLTLink);
      // TLREPPRC - xRN - Replacement Price
      3311 : Tmpfield := Form_Real(PreviousBal,13,2);
      // TLREPUCO - xRN - Repair Unit Cost
      3312 : Tmpfield := Form_Real(SSDSPUnit,13,Syss.NoCosDec);

      //PR: 09/01/2014 ABSEXCH-14845 Add line Year & Period fields to match new indexes on Details table
      //TLPERIOD - Period
      3313  :  TmpField:=Form_Int(PPr, 2);                    { Accounting Year:- 1996=96, 2001=101 }

      //TLYEAR - Year (2-digit)
      3314  :  TmpField:=Format('%2.2d', [(PYr Mod 100)]);    { 2-digit year:- 1996='96', 2001='01' }
      //TLYEAR - Year (4-digit)
      3315  :  TmpField:=Form_Int(PYr + 1900, 4);             { Full 4-digit Year }
      //TLYEAR - Year (Accounting)
      3316  :  TmpField:=Form_Int(PYr, 3);                    { Accounting Year:- 1996=96, 2001=101 }


      // MH 13/12/05: Added Bespoke Trolley Totals for J&J Whines
      // TTDESC    Trolley Description
      3901 : If (Not JJTrolleyTotalLine) Then
               TmpField := Desc
             Else
               TmpField := 'Trolley ' + IntToStr(JJTrolleyNo) + ' Total: ';
      // TTQTY     Trolley Qty
      3902 : If (Not JJTrolleyTotalLine) Then
               TmpField := Form_Real (Qty, 0, Syss.NoQtyDec)
             Else
               TmpField := Form_Real (JJTotals[1], 0, Syss.NoQtyDec);
      // TTUSPRIC  Trolley Sales Unit Price
      3903 : If (Not JJTrolleyTotalLine) Then
               TmpField := Form_Real (NetValue, 0, Syss.NoNetDec)
             Else
               TmpField := '0.0';
      // TTBASEQT  Trolley Line Base Eq Total
      3904 : If (Not JJTrolleyTotalLine) Then
               TmpField := Form_Real(DetLTotal(Id,True, False,0.0) * LineCnst(Id.Payment),0,2)
             Else
               TmpField := Form_Real(JJTotals[2], 0, 2);

      // TLBOMPIQ - BoM Component Picked Qty
      3219 : Begin
               // If Picked Qty is set then return Picked Qty else try to calculate
               If (Id.QtyPick <> 0.0) Or (Id.SOPLineNo = 0) Then
                 TmpField := Form_Real (Id.QtyPick, 0, Syss.NoQtyDec)
               Else
                 TmpField := Form_Real (GetBoMPickedQty(Id.FolioRef, Id.SOPLineNo, Id.Qty), 0, Syss.NoQtyDec)
             End; // TLBOMPIQ - BoM Component Picked Qty
      // TLBOMSTK - BoM Component Parent Stk Code
      3220 : Begin
               // If Picked Qty is set then return Picked Qty else try to calculate
               If (Id.KitLink <> 0) And (Trim(Id.StockCode) <> '') Then
                 TmpField := GetBoMParentStockCode (Id.KitLink);
             End; // TLBOMSTK - BoM Component Parent Stk Code

      // TLMBDSCS - Multi-Buy Discount (String)
      3221  :  TmpField:=PPR_PAmountStr(Discount2, Discount2Chr);
      // TLMBDSC - Multi-Buy Discount (Value)
      3223  :  TmpField:=Form_Real (Discount2, 0, IfThen(Discount2Chr = PcntChr, 4, 2));
      // TLMBDSCT - Multi-Buy Discount (Type)
      3224  :  TmpField:=IfThen(Discount2Chr = PcntChr, PcntChr, ' ');

      // TLTTDSCS - TTD/VBD Discount (String)
      3222  :  TmpField:=PPR_PAmountStr(Discount3, Discount3Chr);
      // TLTTDSC - TTD/VBD Discount (Value)
      3225  :  TmpField:=Form_Real (Discount3, 0, IfThen(Discount3Chr = PcntChr, 4, 2));
      // TLTTDSCT - TTD/VBD Discount (Type)
      3226  :  TmpField:=IfThen(Discount3Chr = PcntChr, PcntChr, ' ');


      // MH 26/08/2009: Added new fields for v6.2 EC Sales / VAT Return changes
      // TLSERVIC - Is EC Service?
      3227  :  TmpField := YesNoBo(ECService);
      // TLSERSTA - EC Service Start Date
      3228  :  TmpField := ServiceStartDate;
      // TLSEREND - EC Service End Date
      3229  :  TmpField := ServiceEndDate;
      // TLECSTAX - EC Sales Tax Reported
      3230  :  TmpField := Form_Real (ECSalesTaxReported, 0, 2);
      // TLPRSTAX - Purchase Reverse Charge Service Tax
      3231  :  TmpField := Form_Real (PurchaseServiceTax, 0, 2);

      // MH 01/02/2010 (v6.3): Added new fields for Web Extensions
      // TLREFRNC - Reference
      3232  :  TmpField := tlReference;
      // TLRCPTNO - Receipt No
      3233  :  TmpField := tlReceiptNo;
      // TLFROMPC - From Postcode
      3234  :  TmpField := tlFromPostCode;
      // TLTOPC - To Postcode
      3235  :  TmpField := tlToPostCode;

      // MH 24/10/2011 v6.9 ABSEXCH-11716: Added new Transaction Line User Defined Fields
      3236    : TmpField := LineUser5;
      3237    : TmpField := LineUser6;
      3238    : TmpField := LineUser7;
      3239    : TmpField := LineUser8;
      3240    : TmpField := LineUser9;
      3241    : TmpField := LineUser10;

      // MH 01/03/2012 v6.10 ABSEXCH-12596: Added Threshold Code for LIVE
      // TLTHRESH - Threshold Code
      3242    : TmpField := tlThresholdCode;

      // PKR. 22/01/2016. ABSEXCH-17109. Added Nature of Transaction Code for Intrastat
      // TLINNOTC - Intrastat Nature of Transaction Code
      3317 : TmpField := tlIntrastatNoTC;
    end; {Case..}

    Link_IdDict:=TmpField;
  end; {Func..}



  { ========= Function to Return Nominal Dict Values ======== }

  Function Link_NomDict(    DictNo   : LongInt;
                        Var DictLink : DictLinkType;
                            InpStr   : Str255) : Str255;


  Var
    TmpField  :  Str255;
    {VT        :  VATType;}
    slClasses : TStringList;
  Begin

    TmpField:='';

    With Nom do
    Case DictNo of

      4000  :  TmpField:=Form_Int(NomCode,0);           {* Nominal Code *}

      4001  :  TmpField:=Form_Int(Cat,0);           {* Nominal Code *}

      4002  :  TmpField:=Desc;                          {* Desc *}

      4003  :  TmpField:=NomType;                       {* NomType *}

      4004  :  TmpField:=YesNoBo(NomPage);              {* Page Break }

      4005  :  TmpField:=Form_Int(CarryF,0);            {* Carry Fwrd Line No *}

      4006..4009                                        {* Nominal Balances *}
                                                        {* 1 = Debit *}
                                                        {* 2 = Credit *}
                                                        {* 3 = Balance *}
                                                        {* 4 = Budget *}

            {:  TmpField:=Form_Real(GetNomStats(FullNomKey(NomCode),}
            :  TmpField:=Form_Real(GetNomStats(CalcCCKeyHistP(NomCode,BOn, ''),
                                               DictNo-4005,
                                               NomType,
                                               DictLink),0,2);

      { Nominal CC Balances: 1=Debit,2=Credit,3=Balance,4=Budget }
      4016..4019
            :  TmpField:=Form_Real(GetNomStats(CalcCCKeyHistP(NomCode, BOn, LJVar(Copy(InpStr,1,3),3)),
                                               DictNo-4015,
                                               NomType,
                                               DictLink),0,2);

      { Nominal Dp Balances: 1=Debit,2=Credit,3=Balance,4=Budget }
      4026..4029
            :  TmpField:=Form_Real(GetNomStats(CalcCCKeyHistP(NomCode, BOff, LJVar(Copy(InpStr,1,3),3)),
                                               DictNo-4025,
                                               NomType,
                                               DictLink),0,2);


      {----------------- HM 20/10/99 Added v4.31 fields ----------------------}
      { Alternative look up code }
      4050  : TmpField := AltCode;
      { Validation currency associated with this G/L. 0= All}
      4051  : TmpField := Form_Int(DefCurr, 0);
      { Revalue Field }
      4052  : TmpField := YesNoBo(ReValue);

      // HM 18/08/03: new fields for v5.52
      // NMINACTV - Inactive Flag
      4053  : TmpField := YesNoBo(HideAC<>0);
      // NMFORCJC - Force Job Code
      4054  : TmpField := YesNoBo(ForceJC);


      {--------- HM 28/03/00 Added Commitment Accounting fields --------------}
      { Nominal Committed Balances:- Debit, Credit, Actual }
      4030..4032
            :  TmpField:=Form_Real(GetNomStats(CommitKey + CalcCCKeyHistP(NomCode, BOff, ''),
                                               DictNo-4029,
                                               NomType,
                                               DictLink),0,2);
      { Nominal Cost Centre Committed Balances:- Debit, Credit, Actual }
      4034..4036
            :  TmpField:=Form_Real(GetNomStats(CommitKey + CalcCCKeyHistP(NomCode, BOff, LJVar(Copy(InpStr,1,3),3)),
                                               DictNo-4033,
                                               NomType,
                                               DictLink),0,2);
      { Nominal Department Committed Balances:- Debit, Credit, Actual }
      4038..4040
            :  TmpField:=Form_Real(GetNomStats(CommitKey + CalcCCKeyHistP(NomCode, BOff, LJVar(Copy(InpStr,1,3),3)),
                                               DictNo-4037,
                                               NomType,
                                               DictLink),0,2);

      //PR: 11/03/2009 Added Revised CC/Dept budgets for 6.01
      4055  : TmpField:=Form_Real(GetNomStats(CalcCCKeyHistP(NomCode, BOn, LJVar(Copy(InpStr,1,3),3)),
                                               5,
                                               NomType,
                                               DictLink),0,2);

      4056  : TmpField:=Form_Real(GetNomStats(CalcCCKeyHistP(NomCode, BOff, LJVar(Copy(InpStr,1,3),3)),
                                               5,
                                               NomType,
                                               DictLink),0,2);

      // NMCLASS - Nominal Class
      4010  : Begin
                slClasses := TStringList.Create;
                Try
                  Try
                    Set_DefaultNOMClass(slClasses, BOn); // Load all classes into list

                    // NOTE: Not the most efficient way of doing it, but easiest to maintain if
                    // Eduardo starts adding extra entries, and is certain to return a '?' if
                    // entries are inserted rather than the wrong description.
                    Case NomClass Of
                       0 : TmpField := slClasses[0];
                      10 : TmpField := slClasses[1];
                      20 : TmpField := slClasses[2];
                      30 : TmpField := slClasses[3];
                      40 : TmpField := slClasses[4];
                      50 : TmpField := slClasses[5];
                      60 : TmpField := slClasses[6];
                      70 : TmpField := slClasses[7];
                      80 : TmpField := slClasses[8];
                      90 : TmpField := slClasses[9];
                    Else
                      TmpField := '?';
                    End; // Case NomClass
                  Except
                    TmpField := '?';
                  End; // Try..Except
                Finally
                  slClasses.Free;
                End; // Try..Finally
              End; //
      // NMCLASSN - Nominal Class Number
      4011  : TmpField := Form_Int(NomClass, 0);
    end; {Case..}

    Link_NomDict:=TmpField;

  end; {Func..}




  { ========= Function to Return Stock Dict Values ======== }

  Function Link_StkDict(    DictNo   : LongInt;
                        Var DictLink : DictLinkType;
                            InpStr   : Str255)  :  Str255;


  Var
    TmpField  :  Str255;
    TmpField2 :  Str20;
    VT        :  VATType;
    Dnum      :  Double;
    TmpStock  :  ^StockRec;
    TmpRecAddr:  LongInt;
    KPath, TmpStat : Integer;


    Function GetLocationDets (FieldNo : LongInt;
                              InpStr  : Str255) : Str255;
    Const
      FNum    = MLocF;
      KeyPath = MLK;
    Var
      OrigLoc  : MLocPtr;
      KeyS     : Str255;
      KL       : Integer;
    Begin
      { Save current location info }
      New(OrigLoc);
      OrigLoc^ := MLocCtrl^;

      { Build Key }
      KeyS := PartCCKey(CostCCode, CSubCode[BOff]) +
              FullStockCode(Stock.StockCode) +
              LJVar(Copy(InpStr,1,3),3);

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      Result := '';

      If StatusOk Then Begin
        { Check key matches }
        KL := Length(InpStr);
        If (KL > 3) Then KL := 3;
        If CheckKey(Copy(InpStr, 1, KL), MLocCtrl^.MStkLoc.lsLocCode, KL, BOn) Then Begin
          Result := Link_StkLoc(FieldNo + 11600, DictLink);
        End; { If }
      End; { If }
      GetLocationDets := Result;

      { Restore original location record }
      MLocCtrl^ := OrigLoc^;
      Dispose(OrigLoc);
    End;

    { 0-Parent Desc, 1-Ultimate parent code, 2-Ultimate parent desc }
    Function GroupDesc (Const Mode : Byte) : ShortString;
    Const
      FNum    = StockF;
      KeyPath = StkCodeK;
    Var
      oStock               : ^StockRec;
      KeyS                 : Str255;
      TmpKPath, TmpRecAddr : LongInt;
      lStatus              : SmallInt;
    Begin { GroupDesc }
      Result := '';
      If (Trim(Stock.StockCat) <> '') Then Begin
        { Save current position and record }
        New (oStock);
        oStock^ := Stock;

        TmpKPath := GetPosKey;
        TmpStat := Presrv_BTPos(Fnum, TmpKPath, F[Fnum], TmpRecAddr, BOff, BOff);

        KeyS := FullStockCode(Stock.StockCat);
        lStatus := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
        If (lStatus = 0) Then
          If (Mode = 0) Then
            { Return Group Description }
            Result := Stock.Desc[1]
          Else Begin
            { Return details from Ultimate parent }
            If(Trim(Stock.StockCat) <> '') Then
              Repeat
                KeyS := FullStockCode(Stock.StockCat);
                lStatus := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
              Until (lStatus <> 0) Or (Trim(Stock.StockCat) = '');

            If (lStatus = 0) Then Begin
              If (Mode = 1) Then
                Result := Stock.StockCode
              Else
                Result := Stock.Desc[1];
            End; { If }
          End; { Else }

        { Restore original position and record }
        TmpStat := Presrv_BTPos(Fnum, TmpKPath, F[Fnum], TmpRecAddr, BOn, BOn);
        Stock := oStock^;
        Dispose(oStock);
      End; { If }
    End; { GroupDesc }

  Begin
    TmpField:='';

    With Stock do
    Case DictNo of
      5000  :  TmpField:=StockCode;                     {* Stock Code *}

      5001..5006
            :  TmpField:=Desc[DictNo-5000];             {* Desc 1-6 *}

      5007  :  TmpField := Form_Int(StockFolio,0);

      5019  :  TmpField:=StockCat;                      {* Group *}

      5020  :  TmpField:=StockType;                     {* Type *}

      5021  :  TmpField:=Form_Int(PCurrency,0);         {* Purchase Currency *}

      5022  :  TmpField:=Form_Real(CostPrice,0,7);      {* Purchase Cost/Unit*}

      5025..5032
            :  TmpField:=Form_Int(SaleBands[DictNo-5024].Currency,0); {* Band A-H Currency *}

      5035..5042
            :  TmpField:=Form_Real(SaleBands[DictNo-5034].SalesPrice,0,7); {* Band A-H Price *}

      5045..5052
            :  With SaleBands[DictNo-5044] do
               Begin

                 If (SalesPrice<>0) then
                   Dnum:=Stock_Gp(CostPrice,Currency_ConvFT(SalesPrice,Currency,PCurrency,UseCoDayRate),
                                  BuyUnit,SellUnit,Ord(Syss.ShowStkGP), CalcPack)
                 else
                   Dnum:=0;

                 TmpField:=Form_Real(Dnum,0,2);         {* Band A-H Margin / Markup *}

               end;

      5060  :  TmpField:=Supplier;                      {* Prefered Supplier *}

      5061  :  TmpField:=Form_Real(ROCPrice,0,7);       {* Re order cost Price *}

      5100  :  TmpField:=BinLoc;                        {* Bin Location *}

      5101  :  TmpField:=AltCode;                       {* Alternative Stk Code *}

      5102  :  TmpField:=VATCode;                       {* Default VAT Code *}

      5103  :  TmpField:=CommodCode;                    {* EC Commodity Code *}

      5104  :  TmpField:=UnitSupp;                      {* EC Supplimentry Sales Units Desc *}

      5105  :  TmpField:=Form_Real(PWeight,0,4);        {* EC Purch Unit Weight *}

      5106  :  TmpField:=Form_Real(SWeight,0,4);        {* EC Sales Unit Weight *}

      5107,5108
            :  TmpField:=CCDep[(DictNo=5107)];          {* Cost Centre Dept Code *}

      5109,
      5110  :   Begin                                  {* CC/Dep Desc *}

                  TmpField2:=CCDep[(DictNo=5109)];

                  //PR: 16/05/03 - was checking global ok which was fairly random.
                  if GetCCDep(Application.MainForm,
                           TmpField2,
                           TmpField2,
                           (DictNo=5109),
                           -1) then

{                  If (Ok) then}
                    TmpField:=PassWord.CostCtrRec.CCDesc
                  else
                    TmpField:='';

                end;



      5120..5124

            :  TmpField:=Form_Int(NomCodes[DictNo-5119],0); {* Nominal Codes 1-5 *}


      5130  :  TmpField:=UnitK;                         {* Unit Stock Qty Desc *}

      5131  :  TmpField:=UnitS;                         {* Unit Sales Qty Desc *}

      5132  :  TmpField:=UnitP;                         {* Unit Purchase Qty Desc *}

      5133  :  TmpField:=Form_Real(SellUnit,0,6);       {* Stock Unit in Sales Qty *}

      5134  :  TmpField:=Form_Real(BuyUnit,0,6);        {* Stock Unit in Purchase Qty *}

      5135  :  TmpField:=StkValType;                    {* Stock Valuation method *}

      5136  :  TmpField:=Form_Real(QtyMin,0,6);         {* Min Stk Level *}

      5137  :  TmpField:=Form_Real(QtyMax,0,6);         {* Max Stk Level *}

      5140  :  TmpField:=Form_Int(CovMinPr,0)+CovMinUnit; {* Min Cover Period *}
      5141  :  TmpField:=Form_Int(CovMaxPr,0)+CovMaxUnit; {* Max Cover Period *}
      5142  :  TmpField:=Form_Int(CovPr,0);               {* Scan Back cover period *}

      { Bill Of Materials }
      5143  :  With Password, BillMatRec do
                 TmpField:=FullStkCode;

      5144  :  With Password, BillMatRec do Begin
                 { Save stock position }
                 KPath := StkCodeK;
                 TmpStat:=Presrv_BTPos(StockF, KPath, F[StockF], TmpRecAddr, BOff, BOff);
                 GetMem (TmpStock, SizeOf (TmpStock^));
                 TmpStock^:=Stock;

                 GetStock(Application.MainForm, FullStkCode,FullStkCode,-1);

                 TmpField:=Stock.Desc[1];

                 If (Stock.StockType=StkBillcode) then
                   TmpField:='*'+TmpField;

                 { restore stock position }
                 Stock:=TmpStock^;
                 FreeMem (TmpStock, SizeOf (TmpStock^));
                 TmpStat := Presrv_BTPos(StockF, KPath, F[StockF],TmpRecAddr, BOn, BOff);
               end;

      {$IFDEF PF_On}
      5145  :  With Password, BillMatRec do
                 TmpField:=Form_Real(QtyUsed,0,{2}Syss.NoQtyDec);

      5146  :  With Password, BillMatRec do
                 TmpField:=Form_Real(QtyCost*QtyUsed,0, {2}Syss.NoCosDec);
      {$ENDIF}

      5147  :  TmpField:=YesNoBo(ShowasKit);              {* BOM show as kit *}

      5148  :  TmpField:=Form_Real(QtyInStock,0,6);       {* Live Stock Level*}

      5149  :  TmpField:=Form_Real(QtyFreeze,0,6);        {* Frozen Stock Level*}

      5150  :  TmpField:=Form_Real(QtyAllocated,0,6);     {* Allocated Stock Level*}

      5151  :  TmpField:=Form_Real(QtyOnOrder,0,6);       {* OnOrder Stock Level*}

      5152  :  TmpField:=Form_Real(QtyPicked,0,6);        {* Qty Picked Stock Level*}

      5153  :  TmpField:=Form_Real(ROQty,0,6);            {* Qty Re-Order Level *}

      5154  :  TmpField:=Form_Real(QtyTake,0,6);          {* Qty Counted at Stock Take Level *}

      5155  :  TmpField:=YesNoBo(Id.KitLink=1);

      5156  :  TmpField:=YesNoBo(KitOnPurch);             {* BOM show as kit on Purchase *}

      5157  :  TmpField:=RODate;
      5158  :  TmpField:=Form_Int(ROCurrency,0);

      5300..5304,
      5309, 5311                                        {* Stock Balances *}
                                                        {* 1 = Qty Sales *}
                                                        {* 2 = Net Sales *}
                                                        {* 3 = Costs *}
                                                        {* 4 = Margin *}
                                                        {* 5 = Period Qty FCast *}
                                                        {* 10= Posted Stock Level *}

            {:  TmpField:=Form_Real(GetStkStats(FullNomKey(StockFolio),}
            :  TmpField:=Form_Real(GetStkStats(CalcKeyHist(StockFolio,''),
                                               DictNo-5299,
                                               StockType,
                                               DictLink),0,6);

      5310  :  TmpField:=JAnalCode;                       {* Default Job Anal Code *}


      5062  :  TmpField:=PSymb(PCurrency);         {* Purchase Currency *}

      5063..5070
            :  TmpField:=PSymb(SaleBands[DictNo-5062].Currency); {* Band A-H Currency *}

      5071  : TmpField := Form_Real (SuppSUnit, 0, 2);

      5072 : TmpField := BarCode;                  { Bar Code }
      5073 : TmpField := StkUser1;                 { User Defined Field 1 }
      5074 : TmpField := StkUser2;                 { User Defined Field 2 }

      5320..5324,
      5329                                              {* Stock Balances *}
                                                        {* 1 = Qty Sales *}
                                                        {* 2 = Net Sales *}
                                                        {* 3 = Costs *}
                                                        {* 4 = Margin *}
                                                        {* 5 = Period Qty FCast *}
                                                        {* 10= Posted Stock Level *}

            {:  TmpField:=Form_Real(GetStkStats(FullNomKey(StockFolio),DictNo-5299,StockType,DictLink),0,6);}
            :  Begin
                 TmpField:=Form_Real(GetStkStats(CalcKeyHist(StockFolio, LJVar(Copy(InpStr,1,3),3)),
                           DictNo-5319,StockType,DictLink),0,6);
               End;

      5400..5440, { Stock/Location XRef Fields }
      5442..5499
            : TmpField:=GetLocationDets (DictNo, InpStr);

      // HM 13/07/00: Diverted function as previous implementation was wrong
      5441  : TmpField := Link_StkDict(5329, DictLink, InpStr);

      5075  : TmpField := LastUsed;

      { Default Line Type }
      5076  : TmpField := Form_Int(StkLinkLT,0);
      5077  : Begin
                If (StkLinkLT = 0) Then
                  TmpField := 'Normal'
                Else
                  // MH 25/10/2011 v6.9: Added Custom Fields info object
                  //TmpField := SyssVAT.VATRates.UDFCaption[6 + StkLinkLT];
                  TmpField := CustomFields[cfLinetypes, StkLinkLT].cfCaption;
              End;

      { Default Location Code }
      5078  : TmpField := DefMLoc;

      {---------------=- HM 19/10/99: v4.31 fields added ---------------------}

      { Qty Returned }
      5079  : TmpField := Form_Real(QtyReturn, 0, 6);
      { Qty allocated to WOR }
      5080  : TmpField := Form_Real(QtyAllocWOR, 0, 6);
      { Qty issued to WOR }
      5081  : TmpField := Form_Real(QtyIssueWOR, 0, 6);
      { Include on Web export }
      5082  : TmpField := Form_Int(WebInclude,3);
      { Web current catalogue entry }
      5083  : TmpField := WebLiveCat;
      { User Defined 3 & 4 }
      5084  : TmpField := StkUser3;
      5085  : TmpField := StkUser4;
      { Flag to state if group is size/color container }
      5086  : TmpField := Form_Int(StkSizeCol,0);
      { Intrastat Uplift Dispatch default % }
      5087  : TmpField := Form_Real(SSDDUplift, 0, 6);
      { Intrastat Country of origin }
      5088  : TmpField := SSDCountry;
      { Intrastat Uplift Arrivals default % }
      5089  : TmpField := Form_Real(SSDAUpLift, 0, 6);
      { Associated bitmap image }
      5090  : TmpField := ImageFile;
      { Use Average cost with Serial Numbers }
      5091  : TmpField := Form_Int(SerNoWAvg,0);

      { Stock Group 0 - Ultimate Parent }
      5092  : Tmpfield := GroupDesc (1);
      { Stock Desc 0 - Ultimate Parent Description }
      5093  : Tmpfield := GroupDesc (2);
      { Parent Description }
      5094  : Tmpfield := GroupDesc (0);

      // MH 08/09/2014 v7.1 ABSEXCH-15052: Added new EC Service Flag
      // STECSERV - EC Service Y/N
      5095  : TmpField := YesNoBo(stIsService);

      // HM 27/06/01: v4.32.001
      5159  : TmpField := SVATIncFlg;

      {---------------=- HM 25/03/02: v5.00 fields added ---------------------}

      {WIP GL Code}
      5160  : TmpField := Form_Int(WOPWIPGL,0);
      {Re-order lead time}
      5161  : TmpField := Form_Int(Leadtime, 0);
      {The minimum qty worth building as a BOM}
      5162  : TmpField := Form_Real(MinEccQty, 0, Syss.NoQtyDec);
      { Picked on WOR }
      5163  : TmpField := Form_Real(QtyPickWOR, 0, Syss.NoQtyDec);
      //STUSEBIN - Uses Multibins
      5164  : TmpField := YesNoBo(MultiBinMode);

      // MH 24/10/2011 v6.9 ABSEXCH-11709: Added new Stock User Defined Fields
      5165  : TmpField := StkUser5;
      5166  : TmpField := StkUser6;
      5167  : TmpField := StkUser7;
      5168  : TmpField := StkUser8;
      5169  : TmpField := StkUser9;
      5170  : TmpField := StkUser10;

      // MH 22/07/05: Added Goods Returns fields for v5.70
      // STSAWPER - Returns-Sales Warranty Period
      5200  : TmpField := Form_Int(SWarranty,0);
      // STSAWUNI - Returns-Sales Warranty Units
      5201  : Case SWarrantyType Of
                0 : TmpField := 'Days';
                1 : TmpField := 'Weeks';
                2 : TmpField := 'Months';
                3 : TmpField := 'Years';
              Else
                TmpField := '????';
              End; // Case SWarrantyType
      // STMAWPER - Returns-Manuf. Warranty Period
      5202  : TmpField := Form_Int(MWarranty,0);
      // STMAWUNI - Returns-Manuf. Warranty Units
      5203  : Case MWarrantyType Of
                0 : TmpField := 'Days';
                1 : TmpField := 'Weeks';
                2 : TmpField := 'Months';
                3 : TmpField := 'Years';
              Else
                TmpField := '????';
              End; // Case SWarrantyType
      // STQTSRET - Returns-Sales Return Qty
      5204  : TmpField := Form_Real(QtyReturn, 0, Syss.NoQtyDec);
      // STQTPRET - Returns-Purchase Return Qty
      5205  : TmpField := Form_Real(QtyPReturn, 0, Syss.NoQtyDec);
      // STSRETGL - Returns-Sales Returns GL Code
      5206  : TmpField := Form_Int(ReturnGL,0);
      // STPRETGL - Returns-Purch Returns GL Code
      5207  : TmpField := Form_Int(PReturnGL,0);
      // STRECHRG - Returns-Recharge%
      5208  : TmpField := Form_Real(ReStockPcnt, 0, 2);
      // STRECHFL - Returns-Recharge Flag ' '/'%'
      5209  : TmpField := IfThen (ReStockPChr = '%', '%', ' ');
    end; {Case..}

    Link_StkDict:=TmpField;

  end; {Func..}

    { ========= Function to Return Nominal Dict Values ======== }

  Function Link_CCDepDict(DictNo    :  LongInt;
                      Var DictLink  :  DictLinkType)  :  Str255;


  Var
    TmpField  :  Str255;
    {VT        :  VATType;}
  Begin
    TmpField:='';

    With PassWord.CostCtrRec do
    Case DictNo of

      6000  :  TmpField:=PCostC;                    {* Cost Centre/Dept Code *}

      6001  :  TmpField:=CCDesc;                    {* Cost Centre/Dept Desc *}

      {6002  :  TmpField := LastAccess;}   { Field not set in Exch/Ent }
    end; {Case..}

    Link_CCDepDict:=TmpField;
  end; {Func..}



  { ========= Function to Return Nominal Dict Values ======== }

  Function Link_SerNoDict(DictNo    :  LongInt;
                      Var DictLink  :  DictLinkType)  :  Str255;


  Var
    TmpField  :  Str255;
    {VT        :  VATType;}
    KeyL      :  Str255;


    { Returns last invoice which will appear in customer statement }
    Function Sno_DocInfo(Const SnoDoc : ShortString; Const Mode : Byte) : ShortString;
    Const
      FNum              = InvF;
      KeyPath : LongInt = InvOurRefK;
    Var
      TmpStat, TmpKey1 : Integer;
      TmpRecAddr       : LongInt;
      OInv             : InvRec;
      KeyS             : Str255;
    Begin
      Result := '';

      { Save Position }
      OInv:=Inv;
      TmpKey1:=GetPosKey;
      TmpStat:=Presrv_BTPos(Fnum,TmpKey1,F[Fnum],TmpRecAddr,BOff,BOff);

      { Link to invoice }
      KeyS:=SnoDoc;
      TmpStat := Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      If (TmpStat = 0) Then
        With Inv do Begin
          Case Mode Of
            1  : Result := TransDate;
          End; { Case }
        End; { With }

      { Restore Position }
      TmpStat:=Presrv_BTPos(Fnum,TmpKey1,F[Fnum],TmpRecAddr,BOn,BOff);
      Inv:=OInv;
    End;



  Begin

    TmpField:='';

    With MiscRecs^.SerialRec do
    Case DictNo of

      7000  :  TmpField:=SerialNo;                  {* Serial No. *}

      7001  :  TmpField:=BatchNo;                   {* Batch No *}

      7002  :  TmpField:=InDoc;                     {* Doc No booked in under *}

      7003  :  TmpField:=OutDoc;                    {* Doc No booked out under *}

      7004  :  TmpField:=YesNoBo(Sold);             {* Has SerNo been Sold *}

      7005  :  TmpField:=Sno_DocInfo(InDoc, 1);    {* Date Bought In *}

      7006  :  TmpField:=DateOut;                   {* Date Sold *}

      7007  :  TmpField:=Form_Real(SerCost,0,6);    {* Cost Price *}

      7008  :  TmpField:=Form_Int(CurCost,0);       {* Cost Currency *}

      7009  :  TmpField:=Form_Real(SerSell,0,6);    {* Sell Price *}

      7010  :  TmpField:=Form_Int(CurSell,0);       {* Sell Currency *}

      7011  :  TmpField:=Form_Int(SoldLine,0);      {* Line No of Sales Doc *}

      7012  :  TmpField:=Form_Int(BuyLine,0);       {* Line No of Purch Doc *}

      7013  :  TmpField:=Form_Real(BuyQty,0,Syss.NoQtyDec); {* Batch Qty Bought*}

      7014  :  TmpField:=Form_Real(QtyUsed,0,Syss.NoQtyDec); {* Batch Qty Used *}

      7015  :  TmpField:=YesNoBo(BatchRec);          {* Its a Batch Record *}

      7016  :  TmpField:=YesNoBo(BatchChild);        {* Its a Batch Sales Record  *}

      7017  :  TmpField:=InMLoc;                     {* In Location *}

      7018  :  TmpField:=OutMLoc;                    {* Out Location *}

      7019  :  TmpField := DateUseX;                 {* Use By Date *}

      7020,          { Load In Document }
      7021  :  Begin { Load Out Document }
                 Case DictNo - 7019 Of
                   1 : KeyL := InDoc;
                   2 : KeyL := OutDoc;
                 End; { Case }

                 Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyL);

                 If StatusOk Then Begin
                   { Transaction loaded - load line }
                   Case DictNo - 7019 Of
                     1 : KeyL := FullNomKey(Inv.FolioNum) + FullNomKey(BuyLine);
                     2 : KeyL := FullNomKey(Inv.FolioNum) + FullNomKey(SoldLine);
                   End; { Case }

                   Status:=Find_Rec(B_GetEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdLinkK,KeyL);

                   If (Not StatusOk) Then Begin
                     { Failed to load detail - blank out, but leave invoice loaded }
                     ResetRec(IdetailF);
                   End; { If }
                 End { If }
                 Else Begin
                   { Failed to load invoice }
                   ResetRec(InvF);
                   ResetRec(IdetailF);
                 End; { Else }
               End;

      7022,
      7023  :  TmpField:=Form_Real(SerCRates[(DictNo=7023)],0,10); {* Doc Day & Co. Rate *}

      //Multi-bin code
      7024  :  TmpField := InBinCode;

      // MH 22/07/05: Added Goods Returns fields
      // SNRETURN - Returned Y/N
      7025  :  TmpField := YesNoBo(ReturnSNo);
      // SNSRNREF - SRN OurRef
      7026  :  TmpField := RetDoc;
    end; {Case..}

    Link_SerNoDict:=TmpField;

  end; {Func..}


  { Function to return multi-location stock details }
  Function Link_MLocDict(    DriveFile : Byte;
                             DictNo    :  LongInt;
                         Var DictLink  :  DictLinkType)  :  Str255;
  Var
    TmpField  :  Str255;
    {VT        :  VATType;}
    RecPtr    :  MLocPtr;
  Begin

    TmpField:='';

    If (DriveFile In [4,27]) Then
      RecPtr := TmpMLoc
    Else
      RecPtr := MLocCtrl;

    With RecPtr^, MLocLoc Do
      Case DictNo of

        8100  :  TmpField:=loCode;                    {* Location Code. *}

        8101  :  TmpField:=loName;                    {* Location Name *}

        8102..8106
              :  TmpField:=loAddr[DictNo-8101];       {* Loc Address 1-5 *}

        8107  :  TmpField:=loTel;                     {* loc Telephone *}

        8108  :  TmpField:=loFax;                     {* Location Fax *}

        8109  :  TmpField:=loemail;                   {* location email *}

        8110  : TmpField := loModem;              { Modem }

        8111  :  TmpField:=loContact;                 {* location Contact *}

        8112  : TmpField := Form_Int(loCurrency,0); { Currency }

        8113  : TmpField := YesNoBo(loUsePrice);  { Override Prices }

        8114  : TmpField := YesNoBo(loUseCCDep);  { Override CC/Dep }

        8115,                                    { Cost Centre }
        8116  : TmpField := loCCDep[DictNo=8115];{ Department }

        8117  : TmpField := YesNoBo(loUseSupp);   { Override Supplier }

        8118  : TmpField := YesNoBo(loUseNom);    { Override Nom A/Cs }

        8119..8123
              : TmpField := Form_Int(loNominal[DictNo - 8118],0); { Nominal A/C Codes }

        // HM 09/08/04: Added MLWOPWIP & SLWOPWIP for 5-Star
        8124  : TmpField := Form_Int(loWOPWIPGL,0); // WOP WIP GL Code

        // MLSRETGL - Returns-Sales Return GL
        8125 : TmpField := Form_Int(loReturnGL,0);
        // MLPRETGL - Returns-Purchase Return GL
        8126 : TmpField := Form_Int(loPReturnGL,0);
      end; {Case..}

    Link_MLocDict:=TmpField;
  End;

  { ========= Function to Return System Values ======== }

  Function Link_SysDict(DictNo  :  LongInt)  :  Str255;
  Var
    TmpField  :  Str255;
    VT        : VATType;
    pSysInfo  : PChar;
    StrLength : DWord;
    RNum      : Double;
    StrList   : TStringList;
    I         : LongInt;

    { Update PPY with current cheque number }
    Procedure UpdatePPY;
    Const
      Fnum     =  IDetailF;
      Keypath  =  IdFolioK;
    Var
      TmpKPath, TmpStat   : Integer;
      TmpRecAddr, LAddr   : LongInt;
      KeyS, KeyChk        : Str255;
      TmpId               : IDetail;
      LOk, Locked         : Boolean;
      TmpStr              : Str20;
    Begin { UpdatePPY }
      TmpStr:=Form_BInt(GetNextCount(ACQ,BOff,BOff,0),0);

      { Save current record and position }
      TmpId:=Id;
      TmpKPath:=GetPosKey;
      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      KeyChk:=FullNomKey(TInv.FolioNum);
      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
      While StatusOk And CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) Do Begin
        { Lock record }
        LOk := GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

        If LOk And Locked Then Begin
          Id.Desc := TmpStr;

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);
          Report_BError(Fnum,Status);

          Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
        End; { With }

        { Get next line }
        Status := Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
      End; { While }

      { Restore record and position }
      Id:=TmpId;
      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      { Update currently loaded line as well }
      Id.Desc := TmpStr;
    End;  { UpdatePPY }

  Begin
    TmpField:='';

    Case DictNo of
      0      : TmpField:=Today;
      1      : TmpField:=Form_Int(1,0);  {* Set to one so report adds it up! *}
    {$IFDEF RW}
      2      : TmpField:=Form_Int(RepRunCount,0);  {* On going report count *}
      3      : TmpField:=Form_Int(GroupRepRec^.ReportHed.CurrBreak,0); {* Last break level *}
    {$ENDIF}
      10     : TmpField := Syss.UserName;                    {* Registered User Name *}
      11..15 : TmpField := Syss.DetailAddr[(DictNo-10)];     {* Registered User Address *}
      16     : TmpField := Syss.UserVATReg;                  {* User VAT Reg No *}
      17     : TmpField := Syss.DetailTel;                   {* User Telephone *}
      18     : TmpField := Syss.DetailFax;                   {* User Fax *}

      19,20  : TmpField := Syss.TermsofTrade[DictNo-18];

      21     : TmpField := TimeToStr(Now);

      22     : TmpField := RepInfo.StaAgedDate;

      { Form Designer - Table has thrown page }
      23     : TmpField := YesNoBo(PBThrown);

      { Form Designer - Page Number }
      24     : If Assigned(DicPageNo) Then TmpField := Form_Int(DicPageNo^, 0);

      { Underscores - for use in dos forms }
      25     : TmpField := ConstStr('_', SizeOf(TmpField) - 2);

      26,               { System - Windows Computer Name }
      27     : Begin    { System - Windows User ID }
                 StrLength := 100;
                 pSysInfo := StrAlloc (StrLength);

                 If (DictNo = 26) Then
                   GetComputerName (pSysInfo, StrLength)
                 Else
                   GetUserName (pSysInfo, StrLength);

                 TmpField := pSysInfo;

                 StrDispose (pSysInfo);
               End;
      { Logged In User Id }
      28     : TmpField := EntryRec^.Login;

      {$IFDEF EDLL}
      { System - Increment Next Cheque Number (Non-Printing Field) }
      40     : If InChequeMode Then Begin
                 GetNextCount(ACQ, BOn, BOff, 0);
               End;

      { System - Update PPY Cheque Number (Non-Printing Field) }
      41     : If InChequeMode Then Begin
                 UpdatePPY;
               End;
      {$ENDIF}

      // HM 30/05/03: Added Bank Details for v5.51
      // SYSBANK - System - Bank Name
      42     : TmpField := Syss.UserBank;
      // SYSBANKA - System - Bank Account No

      //PR: 29/08/2013 MRD - sepa/iban fields
      43     : TmpField := DecryptBankAccountCode(Syss.ssBankAccountCode);
      // SYSBANKS - System - Bank Sort Code
      44     : TmpField := DecryptBankSortCode(Syss.ssBankSortCode);
      // SYSBANKR - System - Bank Reference
      45     : TmpField := Syss.UserRef;

      // HM 05/07/04: Added NoteMode to allow GINVNOT mode to be changed
      // SYSNOTE0 - System - Standard Notes
      // SYSNOTE1 - System - Notes From Table
      46, 47 : GetNoteMode := DictNo - 46;   // 0 - Standard, 1 - From Line

      // MH 26/08/2009: Added new fields for v6.2 EC Sales / VAT Return changes
      // SYSECSRV - Enable EC Services Support
      48     : TmpField := YesNoBo (SyssVAT.VATRates.EnableECServices);    // Enable EC Services support on transaction lines
      // SYSTHRSH - EC Sales List Threshold
      49     : TmpField := Form_Real(SyssVAT.VATRates.ECSalesThreshold, 13, 2);    // EC Sales Threshold in VAT Currency


      100..108 : TmpField:=Form_Real(DefTotals[DictNo-100], 0, 2);

      {$IFDEF EDLL} { Form Designer Only }
        { VAT Rates }
        150..170 : Begin
                     VT:=GetVATCode((DictNo-149));
                     TmpField:=Form_Real(SyssVAT.VATRates.VAT[VT].Rate*100, 0, 2);
                 End;
      {$ENDIF}

      200..229 : Begin
                   TmpField := PSymb(DictNo-200);
                 End;

      { Currency Company Rates }
      230..259 : Begin
                   { HM 22/07/98: Check new 1/x flag }
                   If SyssGCur^.GhostRates.TriInvert[DictNo-229] Then
                     RNum := Round_Up(1/SyssCurr^.Currencies[DictNo-229].CRates[BOff],6)
                   Else
                     RNum := SyssCurr^.Currencies[DictNo-229].CRates[BOff];

                   { HM 22/07/98: Return 1.0 instead of 0.0 }
                   If (Rnum = 0.0) Then RNum := 1.0;

                   TmpField:=Form_Real(RNum,12,6);
                 End;
      { Currency Day Rates }
      260..289 : Begin
                   { HM 22/07/98: Check new 1/x flag }
                   If SyssGCur^.GhostRates.TriInvert[DictNo-259] Then
                     RNum := Round_Up(1/SyssCurr^.Currencies[DictNo-259].CRates[BOn],6)
                   Else
                     RNum := SyssCurr^.Currencies[DictNo-259].CRates[BOn];

                   { HM 22/07/98: Return 1.0 instead of 0.0 }
                   If (Rnum = 0.0) Then RNum := 1.0;

                   TmpField:=Form_Real(RNum,12,6);
                 End;
      { Currency Triangulation Rate }
      300..328 : Begin
                   RNum := SyssGCur^.GhostRates.TriRates[DictNo-299];

                   { HM 22/07/98: Return 1.0 instead of 0.0 }
                   If (Rnum = 0.0) Then RNum := 1.0;

                   TmpField:=Form_Real(RNum,12,6);
                 End;
      { Currency Euro Currency Number }
      330..358 : TmpField:=Form_Int(SyssGCur^.GhostRates.TriEuro[DictNo-329],0);
      { Currency Invert Rate flag }
      360..388 : TmpField:=YesNoBo(SyssGCur^.GhostRates.TriInvert[DictNo-359]);
      { Floating Currency Flag }
      390..418 : TmpField:=YesNoBo(SyssGCur^.GhostRates.TriFloat[DictNo-389]);

      600..699 : If Assigned(PrintJobInfo) Then Begin
                   With PrintJobInfo^ Do
                     Case DictNo of
                       { Print Method Number: 0=Printer, 1=Fax, 2=Email }
                       600 : TmpField := Form_Int(fePrintMethod,0);
                       { Fax: From Name }
                       601 : TmpField := Trim(feFaxFrom);
                       { Fax: From Fax Number }
                       602 : TmpField := Trim(feFaxFromNo);
                       { Fax: To Name }
                       603 : TmpField := Trim(feFaxTo);
                       { Fax: To Fax Number }
                       604 : TmpField := Trim(feFaxToNo);
                       { Fax: Message (max 255) }
                       605 : TmpField := Trim(feFaxMsg);
                       { Fax: Total Pages - RP3 Macro }
                       606 : TmpField := #253'$RPCM' + Format('%.2d',[Ord(midTotalPages)]);
                       { Fax: Message - line by line }
                       607..616
                           : Begin
                               StrList := TStringList.Create;
                               Try
                                 StrList.SetText(PCHAR(feFaxMsg));

                                 If (StrList.Count >= (DictNo - 606)) Then
                                   TmpField := StrList[(DictNo - 607)];
                               Finally
                                 StrList.Destroy;
                               End;
                             End;

                       { Email: From Name }
                       620 : TmpField := Trim(feEmailFrom);
                       { Email: From Address }
                       621 : TmpField := Trim(feEmailFromAd);
                       { Email: Name }
                       622 : TmpField := '';
                       { Email: Subject }
                       623 : TmpField := Trim(feEmailSubj);
                       { Email: Message (max 255) }
                       624 : TmpField := Trim(feEmailMsg);
                       { Email: Priority - 0=Low, 1=Normal, 2=High }
                       625 : TmpField := Form_Int(feEmailPriority,0);
                       { Email: Attach Acrobat Reader }
                       626 : TmpField := YesNoBo(feEmailReader);
                       { Email: ZIP Attachment as self-extracting .EXE }
                       627 : TmpField := YesNoBo(feEmailZIP <> 0);
                       { Email: Message - line by line }
                       628..637
                           : Begin
                               StrList := TStringList.Create;
                               Try
                                 StrList.SetText(PCHAR(feEmailMsg));

                                 If (StrList.Count >= (DictNo - 627)) Then
                                   TmpField := StrList[(DictNo - 628)];
                               Finally
                                 StrList.Destroy;
                               End;
                             End;
                     End; { Case }
                 End; { If }
    end; {Case..}

    Link_SysDict:=TmpField;
  end; {Func..}

  Function Link_NotesDict(DictNo  :  LongInt)  :  Str255;
  Var
    TmpField  :  Str255;
  Begin
    TmpField:='';

    With Password.NotesRec Do
      Case DictNo Of
        8000 : If ShowDate Then TmpField := NoteDate;
        8001 : TmpField := NoteLine;
        8002 : TmpField := NoteAlarm;
        8003 : TmpField := NoteUser;
        8004 : TmpField := YesNoBo(ShowDate);
        8005 : TmpField := NoteFor;
        8006 : If (NType = '1') Then
                 TmpField := 'G'
               Else If (NType = '2') Then
                 TmpField := 'D'
               Else If (NType = '3') Then
                 TmpField := 'A'
               Else
                 TmpField := '?'
      end; {Case..}

    Link_NotesDict:=TmpField;
  End;

  Function Link_JobCostDict(DictNo  :  LongInt)  :  Str255;
  Var
    KeyS, TmpField  : Str255;
    Found           : Str20;
    Rnum, Rnum2     : Real;
    Ino,Idx         : Integer;
    UseDecs         : Byte;
    Lnum            : LongInt;
    CrDr            : DrCrType;
    TmpBo           : Boolean;
  Begin

    TmpField:='';

    Ino:=0;

    Idx:=0;

    TmpBo:=BOff;

    Rnum2:=0;

    Rnum:=0;

    UseDecs:=0;

    {$IFDEF PF_On}
      Case DictNo Of
        9001    :  TmpField:=JobMisc^.JobAnalRec.JAnalCode;

        9002    :  Begin
                     GetJobMisc(Application.MainForm, JobDetl^.JobActual.AnalCode,Found,2,-1);
                     TmpField:=JobMisc^.JobAnalRec.JAnalName;
                   end;

        9003,
        9004  :  TmpField:=Form_Int(JobMisc^.JobAnalRec.WIPNom[DictNo=9004],0);

        9030  :  TmpField:=JobMisc^.EmplRec.EmpCode;

        9031  :  TmpField:=JobMisc^.EmplRec.EmpName;

        9032  :  TmpField:=JobMisc^.EmplRec.Supplier;

        9033  :  TmpField:=JobMisc^.EmplRec.Surname;

        9034..9038
              :  TmpField:=JobMisc^.EmplRec.Addr[DictNo-9033];


        9040  :  TmpField:=JobMisc^.EmplRec.Phone;

        9041  :  TmpField:=JobMisc^.EmplRec.Fax;

        9042  :  TmpField:=JobMisc^.EmplRec.Phone2;

        9043  :  TmpField:=JobMisc^.EmplRec.PayNo;

        9044  :  TmpField:=JobMisc^.EmplRec.CertNo;

        9045  :  TmpField:=JobMisc^.EmplRec.CertExpiry;

        9100  :  TmpField:=JobRec^.JobCode;

        9101  :  TmpField:=JobRec^.JobDesc;

        9102  :  TmpField:=Form_Int(JobRec^.JobFolio,0);

        9103  :  TmpField:=JobRec^.CustCode;

        9104  :  TmpField:=JobRec^.JobAltCode;

        9105  :  TmpField:=JobRec^.Contact;

        9106  :  TmpField:=JobRec^.JobMan;

        9107  :  TmpField:=Form_Real(JobRec^.QuotePrice,10,2);

        9108  :  If ExVerIsMultiCcy Then
                   TmpField:=PSymb(JobRec^.CurrPrice);

        9109  :  TmpField:=JobRec^.StartDate;

        9110  :  TmpField:=JobRec^.EndDate;

// HM 20/02/04: This section was never compiled in, and doesn't in fact compile with JC defined
//
//        {$IFDEF JC}
//        9111  :  TmpField:=JobCHTDescL^[JobRec^.ChargeType];
//
//        9200  :  TmpField:=JobCtrl^.EmplPay.PayRDesc;
//
//        9201  :  With JobDetl^.JobActual do Begin                                                                    {* Employee Name *}
//                   KeyS:='';
//
//                   If (Not EmptyKey(EmplCode,Fpos[ECdeNo])) then Begin
//                     GetJobMisc(FullEmpCode(EmplCode),KeyS,3,-1);
//
//                     If (Not Ok) then
//                       ResetRec(JMiscF);
//
//                     KeyS:=JobMisc^.EmplRec.EmpName;
//                   end;
//
//                   TmpField:=KeyS;
//                 end;
//
//        9203  :  With JobDetl^.JobActual do Begin
//                   Rnum:=Charge*DocCnst[JDDT];
//                   TmpField:=Form_Real(Rnum,10,2);
//                 end;
//        {$ENDIF}
      End; { Case }
    {$ENDIF}

    Result:=TmpField;
  End;


  { Function to return Job Analysis }
  Function Link_JobAnal(    DictNo   : LongInt;
                        Var DictLink : DictLinkType) : Str255;


  Var
    TmpField  :  Str255;
    {VT        :  VATType;}
  Begin

    TmpField:='';

    With JobMisc^.JobAnalRec, SyssJob^.JobSetup do
      Case DictNo of

        10000 : TmpField := JAnalCode;               { Analysis Code }

        10001 : TmpField := JAnalName;               { Name }

        10002 : Case JAType Of                       { Type }
                  JobXRev : TmpField := 'Revenue';
                  JobXMat : TmpField := 'Materials';
                  JobXOH  : TmpField := 'Overheads';
                  JobXLab : TmpField := 'Labour';
                End; { Case }

        10003 : TmpField := SummDesc[AnalHed];       { Category }

        10004,                                                { WIP Nom }
        10005 : TmpField := Form_Int(WIPNom[DictNo=10005],0); { P&L Nom }

        // ANCISCOD - CIS Rate Code
        10006 : TmpField := CISTaxRate;
        // ANUPLFT% - Uplift%
        10007 : TmpField:=Form_Real(UpliftP,13,6);
        // ANUPLFGL - Uplift GL Code
        10008 : TmpField := Form_Int(UpliftGL,0);
        // ANREVTYP - Revenue Type
        10009 : TmpField := Form_Int(RevenueType,0);

        //PR 19/04/04 New fields for 5.60 apps & vals
        //ANDEDTYP - Deduction Type
        10010 : TmpField := Form_Int(JADetType, 0);
        //ANCALB4R - Calculate before retention
        10011 : TmpField := YesNoBo(JACalcB4Ret);
        //ANDEDUCT - Deduction Value
        10012 : TmpField := Form_Real(JADeduct, 13, Syss.NoCosDec);
        //ANDEDAPP - Deduction Applies To
        10013 : TmpField := Form_Int(JADedApply, 0);
        //ANRETTYP - Retention Type
        10014 : TmpField := Form_Int(JARetType, 0);
        //ANRETVAL - Retention Value
        10015 : TmpField := Form_Real(JARetValue, 13, 2);
        //ANRETEXP - Retention Expiry Basis
        10016 : TmpField := Form_Int(JARetExp, 0);
        //ANRTXINT - Retention Expiry Interval
        10017 : TmpField := Form_Int(JARetExpInt, 0);
        //ANRTPRSV - Retention Preserve
        10018 : TmpField := YesNoBo(JARetPres);
        //ANDEDCAL - Calculate Deduction As
        10019 : TmpField := Form_Int(JADedComp, 0);
        //ANPAYCOD - Analysis PayCode
        10020 : TmpField := JAPayCode;



      end; {Case..}

    Link_JobAnal:=TmpField;

  end; {Func..}



  { Function to return Job Type fields }
  Function Link_JobType(    DictNo   : LongInt;
                        Var DictLink : DictLinkType) : Str255;


  Var
    TmpField  :  Str255;
    {VT        :  VATType;}
  Begin

    TmpField:='';

    With JobMisc^.JobTypeRec do
      Case DictNo of

        10500 : TmpField := JobType;               { Analysis Code }

        10501 : TmpField := JTypeName;             { Name }

      end; {Case..}

    Link_JobType:=TmpField;

  end; {Func..}

  { Function to return Rates Of Pay }
  Function Link_PayRate(    DriveFile : Byte;
                            DictNo    : LongInt;
                        Var DictLink  : DictLinkType) : Str255;


  Var
    TmpField  : Str255;
    {VT        : VATType;}
    RecPtr    : JobCtrlPtr;
  Begin

    TmpField:='';

    If (DriveFile = 25) Then
      RecPtr := TmpJobCtrl
    Else
      RecPtr := JobCtrl;

    With RecPtr^, EmplPay do
      Case DictNo of

        11000 : TmpField := EStockCode;             { Code }

        11001 : TmpField := PayRDesc;               { Description }

        11002 : TmpField := EAnalCode;              { Analysis }

        11003 : TmpField := Form_Real(Cost,0,2);    { Time Cost }

        11004 : TmpField := Form_Real(ChargeOut,0,2); { Time charge }

        11005 : TmpField := Form_Int (PayRRate,0);    { Payroll Code }

        //PR 28/06/05: Added in extra check to include Job Rates while still excluding global rates
        11006 : If (SubType = JBPCode) or (Copy(EmpCode, 1, 4) <> FullNomKey(-1)) Then
                  TmpField := EmpCode;                { Employee Code }

        11007 : TmpField := Form_Int(CostCurr,0);   { Time Cost Currency }

        11008 : TmpField := Form_Int(ChargeCurr,0);   { Time Currency }

        11009 : TmpField := YesNoBo(SubType = JBPCode);    { Is employee? }

      End; { Case }

    Link_PayRate:=TmpField;

  end; {Func..}


  { Function to return Employee fields }
  Function Link_Employee(    DriveFile : Byte;
                             DictNo    : LongInt;
                         Var DictLink  : DictLinkType) : Str255;


  Var
    TmpField  :  Str255;
    {VT        :  VATType;}
    RecPtr    : JobMiscPtr;
  Begin

    TmpField:='';

    If (DriveFile In [4]) Then
      RecPtr := TmpJobMisc
    Else
      RecPtr := JobMisc;

    With RecPtr^, EmplRec do
      Case DictNo of
        11500 : TmpField := EmpCode;             { Code }
        11501 : Case EType Of   { Type }
                  1 : TmpField := 'Production';
                  2 : TmpField := 'Sub-Contract';
                  3 : TmpField := 'Overhead';
                End; { Case }
        11502 : TmpField := Supplier;            { Supplier }
        11503 : TmpField := EmpName;             { Name }
        11504 : TmpField := Addr[1];             { Address Line 1 }
        11505 : TmpField := Addr[2];             { Address Line 2 }
        11506 : TmpField := Addr[3];             { Address Line 3 }
        11507 : TmpField := Addr[4];             { Address Line 4 }
        11508 : TmpField := Addr[5];             { Address Line 5 }
        11509 : TmpField := Phone;               { Telephone Number }
        11510 : TmpField := Phone2;              { Mobile }
        11511 : TmpField := Fax;                 { Fax Number }
        11512 : TmpField := PayNo;               { Payroll Number }
        11513 : TmpField := CertNo;              { 714 Certificate No }
        11514 : TmpField := CertExpiry;          { 714 Cert Expiry Date }
        11515 : TmpField := CCDep[BOn];           { Default Cost Centre }
        11516 : TmpField := CCDep[BOff];          { Default Department }
        11517 : TmpField := YesNoBo(UseORate = 1);   { Own time Rates Y/N }

        11518 : TmpField := UserDef1;            { User def 1 string }
        11519 : TmpField := UserDef2;            { User def 2 string }
        11520 : TmpField := UserDef3;            { User def 3 string }
        11521 : TmpField := UserDef4;            { User def 4 string }

        // HM 21/01/03: Added CIS Fields
        // EMNINO - Employee NI Number
        11522 : TmpField := EmplRec.ENINo;
        // EMSDATE - Working Period Start Date
        11523 : if (EmplRec.EType = 2) and (Trim(EmplRec.Supplier) <> '') then
                  TmpField := ContEmploymentVar(EmplRec.Supplier, GlobSDate, GlobEDate, 0)
                else
                  TmpField := Form_Int(0, 2);
        // EMEDATE - Working Period End Date
        11524 : if (EmplRec.EType = 2) and (Trim(EmplRec.Supplier) <> '') then
                  TmpField := ContEmploymentVar(EmplRec.Supplier, GlobSDate, GlobEDate, 1)
                else
                  TmpField := Form_Int(0, 2);
        // EMWEEKS - Working Period in Weeks
        11525 : if (EmplRec.EType = 2) and (Trim(EmplRec.Supplier) <> '') then
                  TmpField := ContEmploymentVar(EmplRec.Supplier, GlobSDate, GlobEDate, 2)
                else
                  TmpField := Form_Int(0, 2);
        // EMMONTHS - Working Period in Months
        11526 : if (EmplRec.EType = 2) and (Trim(EmplRec.Supplier) <> '') then
                  TmpField := ContEmploymentVar(EmplRec.Supplier, GlobSDate, GlobEDate, 3)
                else
                  TmpField := Form_Int(0, 2);

        // EMCISTYP - CIS Certificate Type
        11527 : TmpField := Form_Int(CISType, 2);

        // HM 02/06/03: Added new v5.51 fields
        // EMPLONLY - Labour Costs via PL Only
        11528 : TmpField := YesNoBo(LabPLOnly);

        // HM 27/02/04 - Added new v5.60 fields for Apps & Vals
        // EMCISTYS - CIS Certificate Type (String)
        11529 : TmpField := TxLate_CISTypeStr(CISType);

        //PR 19/04/04 - new for v5.6
        //EMRTRULE  - Time Rate Rules
        11530 : TmpField := Form_Int(UseORate, 0);

        // MH 01/11/06: New fields for v5.71 CIS340 support
        // EMUTR - Employee Unique Tax Ref
        11531 : TmpField := UTRCode;
        // EMVERIFY - Employee HMRC Verification No
        11532 : TmpField := VerifyNo;
        // EMTAG - Employee Tag
        11533 : TmpField := Form_Int(Tagged,0);

        // MH 07/03/07: Added new CIS field for v5.71.001
        // EMSUBTYP - CIS340 Subcontractor Type
        11534 : TmpField := Form_Int(CISSubType,0);

        // MH 01/02/2010 (v6.3): Added new field for Web Extensions
        // EMEMAIL - Employee Email Address
        11535 : TmpField := Trim(emEmailAddr);

         // SSK 17/11/2017 2018 R1 ABSEXCH-19392: Added new anonymous field for Employees table
         // EMSTATUS - Employee Status
         11536 : TmpField := Form_Int(Ord(emStatus), 0);

         // EMANONST - Anonymisation Status
         11537 : TmpField := Form_Int(Ord(emAnonymisationStatus), 0);

         // EMANONDT - Anonymised Date
         11538 : TmpField := emAnonymisedDate;

         // EMANONTM - Anonymised Time
         11539 : if trim(emAnonymisedtime) <> '' then
                   TmpField := Str6ToScreenTime(emAnonymisedtime)
                 else
                   TmpField := '';

      End; { Case }

    Link_Employee:=TmpField;

  end; {Func..}


  { Function to return Job Record fields }
  Function Link_JobRec(    DictNo   : LongInt;
                       Var DictLink : DictLinkType) : Str255;


  Var
    TmpField  :  Str255;
    {VT        :  VATType;}

    //PR: 12/03/2009 Copied from Link_StkDct and adapted to find ultimate Job Parent
    //1-Ultimate parent code, 2-Ultimate parent desc
    Function UltimateParent (Const Mode : Byte) : ShortString;
    Const
      FNum    = JobF;
      KeyPath = JobCodeK;
    Var
      oJob              : JobRecPtr;
      KeyS                 : Str255;
      TmpKPath, TmpRecAddr : LongInt;
      lStatus              : SmallInt;
      TmpStat : Integer;
    Begin { GroupDesc }
      Result := '';
      If (Trim(JobRec.JobCat) <> '') Then Begin
        { Save current position and record }
        New (oJob);
        oJob^ := JobRec^;

        TmpKPath := GetPosKey;
        TmpStat := Presrv_BTPos(Fnum, TmpKPath, F[Fnum], TmpRecAddr, BOff, BOff);

        KeyS := FullJobCode(JobRec.JobCat);
        lStatus := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
        If (lStatus = 0) Then
        Begin
          { Return details from Ultimate parent }
          If(Trim(JobRec.JobCat) <> '') Then
            Repeat
              KeyS := FullJobCode(JobRec.JobCat);
              lStatus := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
            Until (lStatus <> 0) Or (Trim(JobRec.JobCat) = '');

          If (lStatus = 0) Then Begin
            If (Mode = 1) Then
              Result := JobRec.JobCode
            Else
              Result := JobRec.JobDesc;
          End; { If }
        End;

        { Restore original position and record }
        TmpStat := Presrv_BTPos(Fnum, TmpKPath, F[Fnum], TmpRecAddr, BOn, BOn);
        JobRec^ := oJob^;
        Dispose(oJob);
      End; { If }
    End; { GroupDesc }

  Begin

    TmpField:='';

    With JobRec^ do
      Case DictNo of
        12000 : TmpField := JobCode;             { Code }
        12001 : Case JobType Of  { Category }
                  JobGrpCode : TmpField := 'Contract';
                  JobJobCode : TmpField := 'Job';
                  JobPhzCode : TmpField := 'Phase';
                End; { Case }
        12002 : TmpField := JobCat;              { Parent Contract }
        12003 : TmpField := JobDesc;             { Name }
        12004 : TmpField := JobAnal;             { Type }
        12005 : TmpField := CustCode;            { Customer }
        12006 : TmpField := Contact;             { Contact }
        12007 : TmpField := JobMan;              { Manager }
        12008 : TmpField := JobAltCode;          { Alternate Code }
        12009 : Case ChargeType Of  { Charge Type }
                  1 : TmpField := 'Time & Materials';
                  2 : TmpField := 'Fixed Price';
                  3 : TmpField := 'Cost Plus %';
                  4 : TmpField := 'Non-Productive Job';
                End; { Case }
        12010 : TmpField := Form_Real(QuotePrice,0,2); { Price Qwoted }
        12011 : TmpField := StartDate;           { Start Date }
        12012 : TmpField := EndDate;             { Completion Date }
        12013 : TmpField := RevEDate;            { Revised Completion Date }
        12014 : TmpField := Form_Int(CurrPrice,0); { Quote Currency }
        12015 : Case JobStat Of     { Job Status }
                  1 : TmpField := 'Quotation';
                  2 : TmpField := 'Active';
                  3 : TmpField := 'Suspended';
                  4 : TmpField := 'Completed';
                  5 : TmpField := 'Closed';
                End; { Case }
        12016 : TmpField := SORRef;              { SOR Ref }

        12017 : TmpField := UserDef1; { Job User Defined 1 }
        12018 : TmpField := UserDef2; { Job User Defined 2 }
        12019 : TmpField := UserDef3; { Job User Defined 3 }
        12020 : TmpField := UserDef4; { Job User Defined 4 }

        { HM 28/03/00: Added JobFolio field as requested }
        12021 : TmpField := Form_Int(JobFolio, 0);

        //PR 19/04/04 v5.60 fields for apps & values
        //JRRETCUR - Default Retention Currency
        12022 : TmpField := Form_Int(DefRetCurr, 0);
        //JRPTREF - Purchase Terms Ref No
        12023 : TmpField := JPTOurRef;
        //JRSTREF - Sales Terms Ref No
        12024 : TmpField := JSTOurRef;
        //JRQSCODE - QS Code
        12025 : TmpField := JQSCode;
        //PR: 12/03/2009 Ultimate Job Parent Code & Description
        12026 : TmpField := UltimateParent(1);
        12027 : TmpField := UltimateParent(2);

        // MH 24/10/2011 v6.9 ABSEXCH-11711: Added new Job User Defined Fields
        12028    : TmpField := UserDef5;
        12029    : TmpField := UserDef6;
        12030    : TmpField := UserDef7;
        12031    : TmpField := UserDef8;
        12032    : TmpField := UserDef9;
        12033    : TmpField := UserDef10;

        //PR: 27/09/2013 v7.0.6 ABSEXCH-14640 Added CostCentre & Department
        12034    : TmpField := CCDep[True];
        12035    : TmpField := CCDep[False];

        // SSK 11/12/2017 2018R1 ABSEXCH-19484: Added new Job Anonymisation fields
        //JRANONST - Anonymisation Status
        12036    : TmpField := YesNoBo(jrAnonymised);
        //JRANONDT -	Anonymisation Date
        12037    : TmpField := jrAnonymisedDate;
        //JRANONTM -	Anonymisation Time
        12038    : if trim(jrAnonymisedTime) <> '' then
                     Tmpfield := Str6ToScreenTime(jrAnonymisedTime)
                   else
                     Tmpfield := '';

      End; { Case }

    Link_JobRec:=TmpField;

  end; {Func..}


  { Function to return Job Actual fields }
  Function Link_JobAct(    DictNo   : LongInt;
                       Var DictLink : DictLinkType) : Str255;


  Var
    TmpField  :  Str255;
    {VT        :  VATType;
    LI1, LI2  : LongInt;}
  Begin

    TmpField:='';

    With JobDetl^, JobActual, SyssJob^.JobSetup do
      Case DictNo of
        13000 : TmpField := JobCode;                { Job Code }
        13001 : TmpField := LineORef;               { Invoice OurRef }
        13002 : TmpField := StockCode;              { Stock Code }
        13003 : TmpField := AnalCode;               { Analysis Code }
        13004 : TmpField := Form_Int(ActCurr,0);    { Line Currency }
        13005 : TmpField := Form_Int(ActYr,0);      { Doc Year }
        13006 : TmpField := Form_Int(ActPr,0);      { Doc Period }
        13007 : TmpField := JDate;                  { Entry Date }
        13008 : TmpField := Form_Real(Qty,0,6);     { Quantity }
        13009 : TmpField := Form_Real(Cost*DocCnst[JDDT],0,Syss.NoCosDec);    { Cost }
        13010 : TmpField := Form_Real(Charge,0,2);  { Charge }
        13011 : TmpField := Form_Int(CurrCharge,0); { Charge Currency }
        13012 : TmpField := EmplCode;               { Employee Code for Timesheets }
        13013 : TmpField := YesNoBo(Posted);        { Posted }
        13014 : TmpField := YesNoBo(Invoiced);      { Invoiced }
        13015 : TmpField := InvRef;                 { Out Invoice Ref }
        13016 : TmpField := SummDesc[JAType];       { Category }
        13017,
        13018 : TmpField := Form_Real(PCRates[DictNo=13018],12,6);
        13019 : TmpField := Form_Int(LineFolio,0);  { Folio Number }

        // HM 05/10/00: Added new fields for Cooper-Parry
        13020 : TmpField := YesNoBo(Reverse);       {  Reverse WIP element }
        13021 : TmpField := YesNoBo(Reversed);      {  Line has been reversed }

        // JAUPLIFT - Total Uplift
        13022 : TmpField := Form_Real(UpliftTotal, 13, 2);
        // JAUPLFGL - Uplift GL Code
        13023 : TmpField := Form_Int(UpliftGL,0);
      End; { Case }

    Link_JobAct:=TmpField;

  end; {Func..}


  { Function to return Job Retention fields }
  Function Link_JobRet(    DictNo   : LongInt;
                       Var DictLink : DictLinkType) : Str255;


  Var
    TmpField  :  Str255;
    VT        :  VATType;
  Begin

    TmpField:='';

    With JobDetl^, JobReten do
      Case DictNo of
        14000 : TmpField := JobCode;                 { Job Code }
        14001 : TmpField := AnalCode;                { Analysis Code }
        14002 : TmpField := Form_Real(RetDisc,0,2);  { Retention % }
        14003 : TmpField := Form_Int(RetCurr,0);     { Currency }
        14004 : TmpField := Form_Real(RetValue,0,2); { Retention Amount }
        14005 : TmpField := RetCrDoc;                { Credit Note OurRef }
        14006 : TmpField := RetDate;                 { Expiry Date }
        14007 : TmpField := RetDoc;                  { Main Invoice }
        14008 : TmpField := RetCustCode;             { Cust A/C }
        14009 : TmpField := OrigDate;                { Entry Date }
        14010,                                       { Cost Centre }
        14011 : TmpField := RetCCDep[DictNo=14010];  { Department }

        // JECISTAX - CIS Tax Retained
        14012 : TmpField := Form_Real(RetCISTax,13,2);
        // JECISGRO - CIS Gross Tax
        14013 : TmpField := Form_Real(RetCISGross,13,2);
        // JEEMPLOY - Employee Code
        14014 : TmpField := RetCISEmpl;
        //PR 19/4/04 v5.60
        //JEAPMODE - Application Mode
        14015 : TmpField := Form_Int(RetAppMode, 0);
      End; { Case }

    Link_JobRet:=TmpField;

  end; {Func..}


  { Function to return Job Budget fields }
  Function Link_JobBudget(    DictNo   : LongInt;
                          Var DictLink : DictLinkType) : Str255;


  Var
    TmpField  :  Str255;
    VT        :  VATType;
  Begin

    TmpField:='';

    { Check we have a budget record, otherwise can cause Maths Overflow errors }
    With JobCtrl^, JobBudg, SyssJob^.JobSetup Do
      If (RecPfix = JBRCode) And (SubType In [JBBCode, JBMCode, JBSCode]) Then
        Case (DictNo - 15000) of
          0  : TmpField := JobCode;                 { Job Code }
          1  : TmpField := AnalCode;                { Analysis Code }
          2  : Case SubType Of                      { Budget Type }
                 JBBCode : TmpField := 'Analysis';
                 JBMCode : TmpField := 'Totals';
                 JBSCode : TmpField := 'Stock/TR';
               Else
                 TmpField := '?';
               End; { Case }
          3  : If (AnalHed <= 10) Then              { Totals Category }
                 TmpField := SummDesc[AnalHed]
               Else
                 TmpField := 'Profit';
          4  : TmpField := Form_Real(BoValue,12,2); { Orig Budget }
          5  : TmpField := Form_Real(BRValue,12,2); { Revised Budget }
          6  : Case AnalHed Of
                 1..6  : TmpField := Form_Int(AnalHed,0);
                 7..10 : TmpField := Form_Int(AnalHed + 1,0);
                 99    : TmpField := Form_Int(7,0);
               End; { Case }
          7  : TmpField := StockCode;               { Stock/Pay Rate Code }
          8  : Case BType Of                        { Anal Type }
                 JobXRev : TmpField := 'Revenue';
                 JobXMat : TmpField := 'Materials';
                 JobXOH  : TmpField := 'Overheads';
                 JobXLab : TmpField := 'Labour';
               End; { Case }
          9  : TmpField := YesNoBo(ReCharge);       { Recharge }
          10 : TmpField := Form_Real(OverCost,0,2); { Over Cost % }
          11 : TmpField := Form_Real(BoQty,0,2);    { Orig Qty }
          12 : TmpField := Form_Real(BrQty,0,2);    { Revised Qty }
          13 : TmpField := YesNoBo(PayRMode);       { Is Pay Rate? }
          14 : TmpField := Form_Real(UnitPrice,0,2);{ Unit Price }
          15 : TmpField := Form_Int(CurrBudg,0);    { Budget Currency }
          16 : TmpField := Form_Int(HistFolio,0);   { Anal folio no }

          { Posted values: 20 = Budget Qty
                           21 = Budget Value
                           22 = Revised Budget Qty
                           23 = Revised Budget Value
                           24 = Actual Qty
                           25 = Actual Value                           }
          20..25
                : Begin
                    If ((DictNo-15000) In [20..23]) And (Not SyssJob^.JobSetup.PeriodBud) Then Begin
                      { Budget on budget record }
                      Case (DictNo-15000) Of
                        20 : TmpField := Form_Real(BoQty,0,2);    { Orig Qty }
                        21 : TmpField := Form_Real(BoValue,12,2); { Orig Budget }
                        22 : TmpField := Form_Real(BrQty,0,2);    { Revised Qty }
                        23 : TmpField := Form_Real(BRValue,12,2); { Revised Budget }
                      End; { Case }
                    End { If }
                    Else Begin { Get figures from Period History }
                      { Get Job Record }
                      LinkOtherdb(JCtrlF,JobF);

                      TmpField:=Form_Real(GetJBudgStats(FullJDHistKey(JobRec^.JobCode,HistFolio),
                                                        DictNo-15020,
                                                        JobRec^.JobType,
                                                        DictLink),0,2);
                    End; { Else }
                  End;

          { Committed values: 30 = Budget Qty
                              31 = Budget Value
                              32 = Revised Budget Qty
                              33 = Revised Budget Value
                              34 = Actual Qty
                              35 = Actual Value                           }
          30..35
                : Begin
                    If ((DictNo-15000) In [30..33]) And (Not SyssJob^.JobSetup.PeriodBud) Then Begin
                      { Budget on budget record }
                      Case (DictNo-15000) Of
                        30 : TmpField := Form_Real(BoQty,0,2);    { Orig Qty }
                        31 : TmpField := Form_Real(BoValue,12,2); { Orig Budget }
                        32 : TmpField := Form_Real(BrQty,0,2);    { Revised Qty }
                        33 : TmpField := Form_Real(BRValue,12,2); { Revised Budget }
                      End; { Case }
                    End { If }
                    Else Begin { Get figures from Period History }
                      { Get Job Record }
                      LinkOtherdb(JCtrlF,JobF);

                      TmpField:=Form_Real(GetJBudgStats(FullJDHistKey(JobRec^.JobCode,HistFolio),
                                                        DictNo-15030,
                                                        CommitHCode,
                                                        DictLink),0,2);
                    End; { Else }
                  End;

           // JBORGVAL - Original Valuation
           36   : TmpField := Form_Real(OrigValuation,13,2);
           // JBREVVAL - Revised Valuation
           37   : TmpField := Form_Real(RevValuation,13,2);
           // JBUPLFT% - Uplift % Override
           38   : TmpField := Form_Real(JBUpliftP,13,6);
           //PR 19/4/04 v5.60
           //JBAPPLY% - % of budget to be applied for
           39   : TmpField := Form_Real(JAPcntApp, 13, 2);
           //JBBASIS - Basis of Valuation
           40   : TmpField := Form_Int(JABBasis, 0);

           //PR 29/01/2008 Added new fields for Currency additions to budgets (MD Events)

           //JBCURR - Job Budget Currency (as opposed to 15 - Budget Currency which maps down to the unused field CurrBudg)
           41   : TmpField := Form_Int(JBudgetCurr, 0);
           //42 JBORIGBC - Original Budget (Consolidated) & 43 JBORIGBC - Revised Budget (Consolidated)
           42  : TmpField := Form_Real(JBBCurrency_Txlate(BoValue, JBudgetCurr, 0),12,2); { Orig Budget }
           43  : TmpField := Form_Real(JBBCurrency_Txlate(BrValue, JBudgetCurr, 0),12,2); { Revised Budget }



         End; { Case }

    Link_JobBudget:=TmpField;

  end; {Func..}


  { Function to return Stock/Location fields }
  Function Link_StkLoc(    DictNo    : LongInt;
                       Var DictLink  : DictLinkType) : Str255;


  Var
    TmpField, KeyL : Str255;
    VT             : VATType;
    lStatus        : SmallInt;
  Begin
    TmpField:='';

    With MLocCtrl^, MStkLoc Do
      Case DictNo of

        17000 : TmpField := lslocCode;                   { Location Code }
        17001 : TmpField := lsStkCode;                   { Stock Code }
        17002 : TmpField := Form_Real(lsCostPrice,12,Syss.NoCosDec); { Cost Price }
        17003 : TmpField := Form_Int(lsPCurrency,0);     { Cost Price Currency }
        17004 : TmpField := Form_Real(lsRoPrice,12,Syss.NoCosDec);   { Re-order Price }
        17005 : TmpField := Form_Int(lsRoCurrency,0);    { Re-order Currency }
        17006..17015                                     { Sales Band Price }
              : TmpField := Form_Real(lsSaleBands[DictNo-17005].SalesPrice,0,7);
        17016..17025                                        { Sales Band Currency }
              : TmpField := Form_Int(lsSaleBands[DictNo-17015].Currency,0);
        17026 : TmpField := lsSupplier;                  { Supplier }
        17027 : TmpField := lsBinLoc;                    { Bin Location }
        17028,                                           { Cost Centre }
        17029 : TmpField := lsCCDep[DictNo = 17028];     { Department }
        17030..17034                                     { GL Control Codes }
              : TmpField := Form_Int(lsDefNom[DictNo-17029],0);
        17035 : TmpField := Form_Real(lsQtyInStock,0,6); { In Stock }
        17036 : TmpField := Form_Real(lsQtyOnOrder,0,6); { On Order }
        17037 : TmpField := Form_Real(lsQtyAlloc,0,6);   { Allocated }
        17038 : TmpField := Form_Real(lsQtyPicked,0,6);  { Picked }
        17039 : TmpField := Form_Real(lsQtyMin,0,6);     { Min Stock }
        17040 : TmpField := Form_Real(lsQtyMax,0,6);     { Max Stock }

        // HM 17/07/00:
        //17041 : TmpField := Form_Real(lsQtyPosted,0,6);  { Qty Posted }
        17041 : With Stock Do Begin
                  // Get Stock Record
                  KeyL := FullStockCode(lsStkCode);
                  lStatus:=Find_Rec(B_GetEq,F[StockF],StockF,RecPtr[StockF]^,StkCodeK,KeyL);

                  // Access History
                  If (lStatus = 0) Then
                    TmpField := Form_Real(GetStkStats(CalcKeyHist(StockFolio, lsLocCode), 10, StockType, DictLink), 0, 6);
                End;

        17042 : TmpField := Form_Real(lsQtyTake,0,6);    { Stock Take Qty }
        17043 : TmpField := lsLastUsed;
        17044 : TmpField := Form_Real(lsQtyFreeze,0,6);    { Stock Freeze Qty }

        // HM 07/02/02: Added Used Quantity
        17045 : With Stock Do Begin
                  // Get Stock Record
                  KeyL := FullStockCode(lsStkCode);
                  lStatus:=Find_Rec(B_GetEq,F[StockF],StockF,RecPtr[StockF]^,StkCodeK,KeyL);

                  // Access History
                  If (lStatus = 0) Then
                    TmpField := Form_Real(GetStkStats(CalcKeyHist(StockFolio, lsLocCode), 12, StockType, DictLink), 0, 6);
                End;

        // HM 09/08/04: Added MLWOPWIP & SLWOPWIP for 5-Star
        17046 : TmpField := Form_Int(lsWOPWIPGL,0); // WOP WIP GL Code

        // MH 22/07/05: Added Goods Returns fields for v5.70
        // SLQTPRET - Returns-Purchase Return Qty
        17047 : TmpField := Form_Real(lsQtyPReturn,13,Syss.NoQtyDec);
        // SLQTSRET - Returns-Sales Return Qty
        17048 : TmpField := Form_Real(lsQtyReturn,13,Syss.NoQtyDec);
        // SLSRETGL - Returns-Sales Returns GL Code
        17049 : TmpField := Form_Int(lsReturnGL,0);
        // SLPRETGL - Returns-Purch Returns GL Code
        17050 : TmpField := Form_Int(lsPReturnGL,0);
      End; { Case }

    Link_StkLoc:=TmpField;

  end; {Func..}


  { Function to return Matched Payment fields }
  Function Link_MatPay(    DictNo    : LongInt;
                       Var DictLink  : DictLinkType) : Str255;
  Var
    TmpField  :  Str255;
    KeyL      :  Str255;
  Begin { Link_MatPay }
    TmpField:='';

    With Password, MatchPayRec Do
      Case DictNo of
        18000 : TmpField := DocCode;

        18001 : TmpField := PayRef;


        18002,           { Link To Transaction }
        18003 : Begin    { Link To Receipt }
                 Case DictNo - 18001 Of
                   1 : KeyL := DocCode;
                   2 : KeyL := PayRef;
                 End; { Case }

                 Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyL);

                 If (Not StatusOk) then
                   ResetRec(InvF);
                End;

        18004 : TmpField := Form_Real(SettledVal,12,2); { Level 0 settled }

        18005 : TmpField := Form_Real(OwnCVal,12,2);    { Own currency settled }

        18006 : TmpField := Form_Int(MCurrency,0);      { Currency }

        18007 : TmpField := MatchType;                  { A for Accounting based, O for ,orders }

        18008 : TmpField := AltRef;                     { Alt YourRef }

        18009 : TmpField := Form_Int(RCurrency,0);      { Currency of Receipt Import mode }

        18010 : TmpField := Form_Real(RecOwnCVal,12,2); { Own Currency Value of Receipt Import mode }
      End; { Case }

    Link_MatPay:=TmpField;
  end; { Link_MatPay }

  {----------------------------------------------------}

  Function Link_BillOMat(DictNo  :  LongInt)  :  Str255;
  Var
    TmpField  :  Str255;
    LI        :  LongInt;

    { 0-Parent Desc, 1-Ultimate parent code, 2-Ultimate parent desc }
    Function GroupDesc (Const Mode : Byte) : String;
    Const
      FNum    = StockF;
      KeyPath = StkCodeK;
    Var
      oStock               : ^StockRec;
      KeyS                 : Str255;
      TmpRecAddr           : LongInt;
      TmpKPath, lStatus    : Integer;
    Begin { GroupDesc }
      Result := '';

      { Save current position and record }
      New (oStock);
      oStock^ := Stock;

      TmpKPath := GetPosKey;
      lStatus := Presrv_BTPos(Fnum, TmpKPath, F[Fnum], TmpRecAddr, BOff, BOff);

      KeyS := '    ';
      Move (Password.BillMatRec.StockLink[1], KeyS[1], 4);
      lStatus := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, StkFolioK, KeyS);
      If (lStatus = 0) Then
        Case Mode Of
          { Parent Code }
          0 : Result := Stock.StockCode;
          { Parent Description }
          1 : Result := Stock.Desc[1];
          { Parent Cost in Currency }
          2 : Result := Form_Real(Stock.CostPrice,0,Syss.NoCosDec);
          { Parent Cust Currency }
          3 : Result := Form_Int(Stock.PCurrency,0);
          { Parent Cost in Base Currency }
          4 : With Stock Do
                Result := Form_Real(Currency_ConvFT(CostPrice,PCurrency,1,UseCoDayRate), 0,Syss.NoCosDec);
        End; { Case }

      { Restore original position and record }
      lStatus := Presrv_BTPos(Fnum, TmpKPath, F[Fnum], TmpRecAddr, BOn, BOn);
      Stock := oStock^;
      Dispose(oStock);

      GroupDesc := Result;
    End; { GroupDesc }


  Begin
    TmpField:='';

    With Password.BillMatRec Do
      Case DictNo Of
        { BOM Stock Code }
        19000 : TmpField := FullStkCode;

        { Parent Stock Folio }
        19001 : Begin
                  Move (StockLink[1], LI, 4);
                  TmpField := Form_Int(LI,0);
                End;
        { Order }
        19002 : Begin
                  TmpField := '    ';
                  Move (StockLink[5], TmpField[1], 4);
                  {Move (StockLink[5], LI, 4);
                  TmpField := Form_Int(LI,0);}
                End;
        { Parent Code }
        19003 : TmpField := GroupDesc(0);
        { Parent Desc 1 }
        19004 : TmpField := GroupDesc(1);
        { Qty }
        19005 : TmpField := Form_Real(QtyUsed,0,Syss.NoQtyDec);
        { Cost Currency Symbol }
        19006 : TmpField := Form_Int(QCurrency,0);
        { Cost Amount }
        19007 : TmpField := Form_Real(QtyCost,0,Syss.NoCosDec);
        { Cost Currency }
        19008 : TmpField := Form_Int(QCurrency,0);
        { Cost Amount in Base Currency }
        19009 : TmpField := Form_Real(Currency_ConvFT(QtyCost,QCurrency,1,UseCoDayRate), 0,Syss.NoCosDec);
        { Parent Cost in Currency }
        19010 : TmpField := GroupDesc(2);
        { Parent Cost Currency }
        19011 : TmpField := GroupDesc(3);
        { Parent Cost Currency Symbol }
        19012 : TmpField := GroupDesc(3);
        { Parent Cost in Base Currency }
        19013 : TmpField := GroupDesc(4);
      end; {Case..}

    Link_BillOMat := TmpField;
  End;

  {----------------------------------------------------}

  Function Link_FIFO(DictNo  :  LongInt)  :  Str255;
  Var
    TmpField  :  Str255;
  Begin { Link_FIFO }
    TmpField:='';

    With MiscRecs^.FIFORec Do
      Case DictNo Of
        { FIFO Document Reference }
        19500 : TmpField := DocRef;
        {  Date of Costing }
        19501 : TmpField := FIFODate;
        {  Amount Left }
        19502 : TmpField := Form_Real(QtyLeft,0,Syss.NoQtyDec);
        { Quantity }
        19503 : TmpField := Form_Real(FIFOQty,0,Syss.NoQtyDec);
        { Doc Currency Cost }
        19504 : TmpField := Form_Real(FIFOCost,0,Syss.NoCosDec);
        { Currency of FIFO }
        19505,                                    { Number }
        19506 : TmpField := Form_Int(FIFOCurr,0); { Symbol }
        { Link to Location }
        19507 : TmpField := FIFOMLoc;
        { Company Rate }
        19508 : TmpField := Form_Real(FIFOCRates[BOff],0,10);
        { Daily Rate }
        19509 : TmpField := Form_Real(FIFOCRates[BOn],0,10)
      end; {Case..}

    Link_FIFO := TmpField;
  End; { Link_FIFO }

  {----------------------------------------------------}

  Function Link_Discounts(DictNo  :  LongInt)  :  Str255;
  Var
    TmpField  :  Str255;
  Begin { Link_Discounts }
    TmpField:='';

    With MiscRecs^Do
      If (RecMFix = CDDiscCode) And (SubType In [TradeCode[BOff], TradeCode[BOn]]) Then Begin
        { Customer/Supplier Discounts }
        With CustDiscRec Do
          Case DictNo Of
            { Type }
            20000 : If (SubType = TradeCode[BOff]) Then
                      TmpField := 'SD'
                    Else
                      If (SubType = TradeCode[BOn]) Then
                        TmpField := 'CD';

            { Stock Code }
            20001 : TmpField := QStkCode;

            { Account Code }
            20002 : TmpField := DCCode;

            {20003 : Qty From }

            {20004 : Qty To }

            { Type }
            20005 : TmpField := QBType;

            { Currency (Number + Symbol) }
            20006,
            20007 : TmpField := Form_Int(QBCurr,0);

            { Special Price }
            20008 : TmpField := Form_Real(QSPrice,0, Syss.NoNetDec);

            { Price Band }
            20009 : TmpField := QBand;

            { Discount% }
            20010 : TmpField := Form_Real(QDiscP,0,2);

            { Discount Amount }
            20011 : TmpField := Form_Real(QDiscA, 0, Syss.NoNetDec);

            { Markup/Margin }
            20012 : TmpField := Form_Real(QMUMG, 0, 2);

            // DISTDATE - Start Date
            20013 : TmpField := CStartD;
            // DIENDATE - Start Date
            20014 : TmpField := CEndD;
            // DIUSDATE - Use Dates
            20015 : TmpField := YesNoBo(CUseDates);

            //PR: 10/02/2012 DIQBFOL
            20016 : TmpField := Form_Int(QtyBreakFolio, 0);
          End; { Case }
      End { If }
      Else
        If (RecMFix = QBDiscCode) And (SubType In [TradeCode[BOff], TradeCode[BOn], QBDiscSub]) Then Begin
          { Customer/Supplier/Stock Quantity Breaks }
          With QtyDiscRec Do
            Case DictNo Of
              { Type }
              20000 : If (SubType = TradeCode[BOff]) Then
                        TmpField := 'SQ'
                      Else Begin
                        If (SubType = TradeCode[BOn]) Then
                          TmpField := 'CQ'
                        Else
                          If (SubType = QBDiscSub) Then
                            TmpField := 'KQ';
                      End; { If }

              { Stock Code }
              20001 : Begin
                        LinkOtherDb(MiscF,StockF);
                        TmpField := Stock.StockCode;
                      End;

              { Account Code }
              20002 : Tmpfield := QCCode;

              { Qty From }
              20003 : TmpField := Form_Real(FQB,0,Syss.NoQtyDec);

              { Qty To }
              20004 : TmpField := Form_Real(TQB,0,Syss.NoQtyDec);

              { Type }
              20005 : TmpField := QBType;

              { Currency (Number + Symbol) }
              20006,
              20007 : TmpField := Form_Int(QBCurr,0);

              { Special Price }
              20008 : TmpField := Form_Real(QSPrice,0, Syss.NoNetDec);

              { Price Band }
              20009 : TmpField := QBand;

              { Discount% }
              20010 : TmpField := Form_Real(QDiscP,0,2);

              { Discount Amount }
              20011 : TmpField := Form_Real(QDiscA, 0, Syss.NoNetDec);

              { Markup/Margin }
              20012 : TmpField := Form_Real(QMUMG, 0, 2);

              // DISTDATE - Start Date
              20013 : TmpField := QStartD;
              // DIENDATE - Start Date
              20014 : TmpField := QEndD;
              // DIUSDATE - Use Dates
              20015 : TmpField := YesNoBo(QUseDates);
            End; { Case }
        End; { If }

    Link_Discounts := TmpField;
  End; { Link_Discounts }

  {----------------------------------------------------}

  ////PR: 13/02/2012 Function for new qty break file ABSEXCH-9795
  function Link_QtyBreak(DictNo  :  LongInt)  :  Str255;
  var
    TmpField  :  Str255;
  begin { Link_QtyBreak }
    TmpField:='';

    with QtyBreakRec do
    case DictNo Of
      { Break Type (QBTYPE)}
      25000 : TmpField := Form_Int(qbFolio, 0);

      { Stock Code }
      25001 : TmpField := Trim(Stock.StockCode);

      { Account Code }
      25002 : TmpField := qbAcCode;

      { Qty From }
      25003 : TmpField := Form_Real(qbQtyFrom, 0, Syss.NoQtyDec);

      { Qty To }
      25004 : TmpField := Form_Real(qbQtyTo, 0, Syss.NoQtyDec);

      { Type }
      25005 : TmpField := DiscountCharFromBreakType(qbBreakType);

      { Currency Number }
      25006 : TmpField := Form_Int(qbCurrency, 0);

      { Currency Symbol) }
      25007 : TmpField := PSymb(qbCurrency);

      { Special Price }
      25008 : TmpField := Form_Real(qbSpecialPrice, 0, Syss.NoNetDec);

      { Price Band }
      25009 : TmpField := qbPriceBand;

      { Discount% }
      25010 : TmpField := Form_Real(qbDiscountPercent, 0, 2);

      { Discount Amount }
      25011 : TmpField := Form_Real(qbDiscountAmount, 0, Syss.NoNetDec);

      { Markup/Margin }
      25012 : TmpField := Form_Real(qbMarginOrMarkup, 0, 2);

      // DISTDATE - Start Date
      25013 : TmpField := qbStartDate;
      // DIENDATE - Start Date
      25014 : TmpField := qbEndDate;
      // DIUSDATE - Use Dates
      25015 : TmpField := YesNoBo(qbUseDates);

    end; { case }

    Result := TmpField;
  end; { Link_QtyBreak )

  {----------------------------------------------------}

  Function Link_UserProf(DictNo  :  LongInt)  :  Str255;
  Var
    TmpField  :  Str255;
  Begin { Link_UserProf }
    TmpField:='';

    With UserProfile^ Do
      Case DictNo Of
        21001     : TmpField := Login;
        21002     : TmpField := Trim(UserName);
        21003     : TmpField := Trim(EmailAddr);
      End; { Case }

    Link_UserProf := TmpField;
  End; { Link_UserProf }

  {----------------------------------------------------}

  Function Link_CISVouchers (DictNo : LongInt) : Str255;
  Var
    TmpField : Str255;
    LI       : LongInt;
    RNum     : Double;

    // HM 09/01/03: Copied from JChkUseU

    { == Return CIS Voucher type == }
    Function CISVTypeName(CVT  :  Byte)  :  Str10;
    Begin
      If (CurrentCountry=IECCode) then
        Case CVT of
          4  :  Result:='RCTDC';
          else  Result:='RCT47';
        end
      else
        Case CVT of
          5  :  Result:='CIS23';
          6  :  Result:='CIS24';
          else  Result:='CIS25';
        end;
    end;

  Function CIS340VTypeName(CVT  :  Byte)  :  Str10;
  Begin
    // ****  HM 12/07/07: Copied from JChkUseU  ****
    If (CurrentCountry=IECCode) then
    Begin
      Result:=CISVTypeName(CVT);
    end
    else
    Begin
      Case CVT of
        0  :  Result:='N/A';
        1  :  Result:='High';
        4  :  Result:='Low';
        2,5
           :  Result:='Zero Rate';
        6  :  Result:='CIS24';
        else  Result:='Low/High';
      end;
    end;
  end;


    // HM 09/01/03: Copied from CISSup1U
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


  Begin { Link_CISVouchers }
    TmpField:='';

    With JobDetl^.JobCISV Do
      Case DictNo Of
        // JVNUMBER - CIS Voucher Number
        22000     : TmpField := CISCertNo;

        // JVDATE - CIS Voucher Date
        22001     : TmpField := Copy (CISVCode2, 1, 8);

        // JVOURREF - CIS Voucher Our Ref
        22002     : TmpField := CISVORef;

        // JVFOLIO - CIS Voucher Folio
        22003     : Begin
                      Move (CISFolio[1], LI, 4);
                      TmpField := Form_Int (LI, 8);
                    End;

        // JVNINO - CIS Voucher NI Number
        22004     : TmpField := CISVNINo;

        // JVCERTNO - CIS Voucher Employee Cert No
        22005     : TmpField := CISVCert;

        // JVGROSS - CIS Voucher Gross Total
        22006     : TmpField := Form_Real(CISvGrossTotal, 13, 2);

        // JVMANTAX - CIS Voucher Manual Tax
        22007     : TmpField := YesNoBo(CISVManualTax);

        // JVAUTTAX - CIS Voucher Auto Tax Total
        22008     : TmpField := Form_Real(CISvAutoTotalTax, 13, 2);

        // JVTAXAMT - CIS Voucher Taxable Amount
        22009     : TmpField := Form_Real(CISTaxableTotal, 13, 2);

        // JVCERTTY - CIS Voucher Certificate Type
        22010     : TmpField := Form_Int(CISCType,0);

        // JVCCY - CIS Voucher Currency
        22011     : TmpField := Form_Int(CISCurr,0);

        // JVCCYSYM - CIS Voucher Currency Symbol
        22012     : TmpField := PSymb (CISCurr);

        // JVEMPLOY - CIS Voucher Employee Code
        22013     : TmpField := Copy (CISvCode1, 1, 6);

        // JVSUPP - CIS Voucher Supplier Code
        22014     : TmpField := Copy (CISVSDate, 1, 6);

        // JVADDR1 - CIS Voucher Address Line 1
        // JVADDR2 - CIS Voucher Address Line 2
        // JVADDR3 - CIS Voucher Address Line 3
        // JVADDR4 - CIS Voucher Address Line 4
        // JVADDR5 - CIS Voucher Address Line 5
        22015..22019
                  : TmpField := CISAddr[DictNo - 22014];

        // JVBEHALF - CIS Voucher On Behalf Of
        22020     : TmpField := CISBehalf;

        // JVCORREC - CIS Voucher Correction
        22021     : TmpField := YesNoBo(CISCorrect);

        // JVTAXDUE - CIS Voucher Tax Due
        22022     : TmpField := Form_Real(CISvTaxDue, 13, 2);

        // JVTYPE - CIS Voucher Type
        22023     : If CIS340 Then
                       TmpField := CIS340VTypeName(CISHTax)
                     Else
                       TmpField := CISVTypeName (CISCType);

        // JVMATTOT - CIS Voucher Material Total
        22024     : TmpField := Form_Real (CalcCISJDMaterial(JobDetl^), 13, 2);

        // JVMONTH - CIS Voucher Month (MMYYYY)
        22025     : Begin
                      // Get Date and reformat as MMYYYY
                      TmpField := Copy (CISVCode2, 5, 2) + Copy (CISVCode2, 1, 4);
                    End;

        // MH 01/11/06: New fields for v5.71 CIS340 support
        // JVVERIFY - CIS Voucher Verification No
        22026    : TmpField := CISVerNo;
        // JVHIGHTX - CIS Voucher High Tax Indicator
        22027    : TmpField := Form_Int(CISHTax, 0);
        // JVTAXRAT - CIS Voucher Tax Rate
        22028    : Begin
                     Case CISHTax Of
                       1 : RNum := SyssCIS^.CISRates.CISRate[Technical].Rate;
                       4 : RNum := SyssCIS^.CISRates.CISRate[Construct].Rate;
                     Else
                       RNum := 0.0;
                     End; // Case CISHTax

                     TmpField := Form_Real (RNum, 5, 2);
                   End; // 22028 - JVTAXRAT - CIS Voucher Tax Rate
        // JVSCHREF - CIS Scheme Reference No
        22029    : TmpField := SyssCIS^.CISRates.CISTaxRef;
        // JVOURCTR - Our Constructor Tax Reference
        22030    : TmpField := SyssCIS^.CISRates.JCertNo;
      End; { Case }

    Result := TmpField;
  End; { Link_CISVouchers }

  {----------------------------------------------------}

  // HM 05/09/03: Added Mutli-Bin support
  Function Link_MutliBins (    DictNo    : LongInt;
                           Var DictLink  : DictLinkType) : Str255;
  Var
    TmpField : Str255;
    KeyL      :  Str255;
  Begin { Link_MutliBins }
    TmpField := '';

    With MLocCtrl^, brBinRec Do
    Begin
      Case DictNo Of
        // BRCODE - Multi-Bin Code
        21500 : TmpField := brBinCode1;

        //BRINDOC & BROOUTDOC
        21501 : TmpField := brInDoc;
        21502 : TmpField := brOutDoc;

        //BRSOLD
        21503 : TmpField := YesNoBo(brSold);

        //BRINDATE
        21504 : TmpField := brDateIn;

        //BRCOST
        21505 : TmpField := Form_Real(brBinCost, 0, Syss.NoCosDec);

        //BRCAPCTY - capacity
        21506 : TmpField := Form_Real(brBinCap, 0, Syss.NoQtyDec);

        //BRSTKFOL - Stock folio
        21507 : TmpField := IntToStr(brStkFolio);

        //BROUTDAT
        21508 : TmpField := brDateOut;

        //BROUTLIN & BRINLINE - Out & In doc line numbers
        21509 : TmpField := IntToStr(brSoldLine);
        21510 : TmpField := IntToStr(brBuyLine);

        //BRQTY & BRQTYUSE
        21511 : TmpField := Form_Real(brBuyQty, 0, Syss.NoQtyDec);
        21512 : TmpField := Form_Real(brQtyUsed, 0, Syss.NoQtyDec);
        // BRQTYAVL - Quantity Available
        21532 : TmpField := Form_Real(brBuyQty - brQtyUsed, 0, Syss.NoQtyDec);

        //BRUSED - brUsedRec
        21513 : TmpField := YesNoBo(brBatchChild);

        //BRINLOC & BROUTLOC
        21514 : TmpField := brInMLoc;
        21515 : TmpField := brOutMLoc;

        //BROUTORD & BRINORD - OutOrdDoc & InOrdDoc
        21516 : TmpField := brOutOrdDoc;
        21517 : TmpField := brInOrdDoc;

        //BRINOLN & BROUTOLN - In & Out Order Line No
        21518 : TmpField := IntToStr(brInOrdLine);
        21519 : TmpField := IntToStr(brOutOrdLine);

        //BRCCURR - Cost Currency
        21520 : TmpField := IntToStr(brCurCost);

        //BRPRIORY - Priority
        21521 : TmpField := brPriority;

        //BRPRICE - sales price
        21522 : TmpField := Form_Real(brBinSell, 0, Syss.NoNetDec);

        //BRDAYRAT & BRCORATE - daily & company rate
        21523,
        21524 : TmpField := Form_Real(brSerCRates[DictNo = 21523], 0, 6);

        //BRUSEBY - Use by date
        21525 : TmpField := brDateUseX;

        //BRSCURR - Sales currency
        21526 : TmpField := IntToStr(brCurSell);

        //BRUOM - Unit of measurement
        21527 : TmpField := brUOM;

        //BRAUTOPK - Auto pick mode
        21528 : TmpField := IntToStr(brHoldFlg);

        //BRTagNo - Tag No
        21529 : TmpField := IntToStr(brTagNo);

        21530,          { Load In Document }
        21531  :  Begin { Load Out Document }
                   Case DictNo - 21529 Of
                     1 : KeyL := brInDoc;
                     2 : KeyL := brOutDoc;
                   End; { Case }

                   Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyL);

                   If StatusOk Then Begin
                     { Transaction loaded - load line }
                     Case DictNo - 21529 Of
                       1 : KeyL := FullNomKey(Inv.FolioNum) + FullNomKey(brBuyLine);
                       2 : KeyL := FullNomKey(Inv.FolioNum) + FullNomKey(brSoldLine);
                     End; { Case }

                     Status:=Find_Rec(B_GetEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdLinkK,KeyL);

                     If (Not StatusOk) Then Begin
                       { Failed to load detail - blank out, but leave invoice loaded }
                       ResetRec(IdetailF);
                     End; { If }
                   End { If }
                   Else Begin
                     { Failed to load invoice }
                     ResetRec(InvF);
                     ResetRec(IdetailF);
                   End; { Else }
                   LinkOtherDb(MLocF, CustF);
                 End;

        // MH 22/07/05: Added Goods Returns fields for v5.70
        // BRRETURN - Returned Y/N
        21533 : TmpField := YesNoBo(brReturnBin);
      End; { Case }
    End; // With MLocCtrl^, brBinRec

    Result := TmpField;
  End; { Link_MutliBins }

  //PR: 11/03/2009 Added function for Alt Stock Codes
  Function Link_AltStock (DictNo : LongInt) : Str255;
  Var
    TmpField : Str255;
    //PR: 17/03/2009 Changed to blank out values that don't apply to Alt Stock Type.
    function IIF(bCondition : Boolean; const sTrue, sFalse : string) : string;
    begin
      if bCondition then
        Result := sTrue
      else
        Result := sFalse;
    end;
  begin
    With MLocCtrl^, SdbStkRec Do
    Begin
      Case DictNo Of
        //Alt Stock Code
        23000           : Result := sdCode1;
        //Alt Stock Description
        23001           : Result := sdDesc;
        //Alt Stock Type - Alt, Equivalent, Opportunity, Superseded
        23002           :   if SubType = NoteCCode then
                               Result := '0'
                            else
                              Result := SubType;
        //Text description of type
        23003           : Case SubType of
                            NoteCCode : Result := 'Alternative';
                            '1'       : Result := 'Equivalent';
                            '2'       : Result := 'Superseded';
                            '3'       : Result := 'Opportunity';
                          end;
        //Stock folio
        23004           : Result := IntToStr(sdStkFolio);
        //Override Re-order price
        23005           : Result := IIF(SubType = NoteCCode, YesNoBo(sdOverRO), '');
        //Re-order price
        23006           : Result := IIF(SubType = NoteCCode, Form_Real(sdRoPrice, 0, 2), '');
        //Re-order currency
        23007           : Result := IIF(SubType = NoteCCode, PSymb(sdROCurrency), '');
        //Override Re-order qty
        23008           : Result := IIF(SubType = NoteCCode, YesNoBo(sdOverMinEcc), '');
        //Re-order Qty
        23009           : Result := IIF(SubType = NoteCCode, Form_Real(sdMinEccQty, 0, 6), '');
        //Override Replacement qty
        23010           : Result := IIF(SubType <> NoteCCode, YesNoBo(sdOverLineQty), '');
        //Replacement qty
        23011           : Result := IIF(SubType <> NoteCCode, Form_Real(sdLineQty, 0, 6), '');
        //Display order
        23012           : Result := IntToStr(sdLineNo);

      end; //Case
    end;
  end;

  //PR: 10/06/2009 Added function for Multi-Buy Discounts
  Function Link_MultiBuy (DictNo : LongInt) : Str255;
  Var
    TmpField : Str255;

    function IIF(bCondition : Boolean; const sTrue, sFalse : string) : string;
    begin
      if bCondition then
        Result := sTrue
      else
        Result := sFalse;
    end;

    function RewardValueDecPlaces : Byte;
    begin
      Result := 0;
      with MultiBuyDiscount do
      Case mbdDiscountType of
         mbtGetFree       : Result := Syss.NoQtyDec;
         mbtForAmount     : if mbdOwnerType in ['C', 'T'] then
                              Result := Syss.NoNetDec
                            else
                              Result := Syss.NoCosDec;
         mbtGetPercentOff : Result := 6;

      end; //Case
    end;

  begin
    With MultiBuyDiscount Do
    Begin
      Case DictNo Of
        //Owner Type
        24000           : Result := mbdOwnerType;
        //Account Code
        24001           : Result := mbdAcCode;
        //Stock Code
        24002           : Result := mbdStockCode;
        //Currency
        24003           : Result := IntToStr(mbdCurrency);
        //Discount Type
        24004           : Result := mbdDiscountType;
        //Start Date
        24005           : Result := IIF(mbdUseDates, mbdStartDate, '');
        //End Date
        24006           : Result := IIF(mbdUseDates, mbdEndDate, '');
        //Use Dates
        24007           : Result := YesNoBo(mbdUseDates);
        //Buy qty
        24008           : Result := Form_Real(mbdBuyQty, 0, Syss.NoQtyDec);
        //Reward Value
        24009           : Result := Form_Real(mbdRewardValue, 0, RewardValueDecPlaces);
        //PR: 15/06/2009 Added Discount Type description + Currency Symbol
        //Discount Type Description
        24010           : Result := FormatMultiBuyDescription(MultiBuyDiscount);
        //Currency Symbol
        24011           : if mbdDiscountType = mbtForAmount then  //PR: 23/06/2009 Was checking the wrong type - d'oh!
                            Result := TxLatePound(Trim(SyssCurr.Currencies[mbdCurrency].SSymb), True)
                          else
                            Result := '';

      end; //Case
    end;
  end;

  //-------------------------------------------------------------------------

  // MH 04/11/2014 v7.x MRD2.4.23: Added support for Account Contact Fields
  Function Link_AccountContact (Const DictNo : LongInt) : Str255;
  Begin // Link_AccountContact
    {$IFDEF EDLL}
      // Form Designer / Forms Toolkit
      With FDAccountContacts.AccountContact Do
      Begin
        Case DictNo Of
          // COACCODE - Account Code
          26000 : Result := acoAccountCode;
          // CONAME - Contact Name
          26001 : Result := acoContactName;
          // COJOBTIT - Contact Job Title
          26002 : Result := acoContactJobTitle;
          // COPHONE - Contact Phone Number
          26003 : Result := acoContactPhoneNumber;
          // COFAX - Contact Fax Number
          26004 : Result := acoContactFaxNumber;
          // COEMAIL - Contact Email Address
          26005 : Result := acoContactEmailAddress;
          // COOWNADD - Contact Has Own Address
          26006 : Result := YesNoBo(acoContactHasOwnAddress);
          // COADDR1 - Contact Address Line 1
          26007 : Result := acoContactAddress[1];
          // COADDR2 - Contact Address Line 2
          26008 : Result := acoContactAddress[2];
          // COADDR3 - Contact Address Line 3
          26009 : Result := acoContactAddress[3];
          // COADDR4 - Contact Address Line 4
          26010 : Result := acoContactAddress[4];
          // COADDR5 - Contact Address Line 5
          26011 : Result := acoContactAddress[5];
          // COPOSTCD - Contact Postcode
          26012 : Result := acoContactPostCode;

          // MH 26/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Codes
          // COCNTRY - Contact Country Code
          26013 : Result := acoContactCountry;
          // COCNTRN - Contact Country Name
          26014 : Result := CountryCodeName (ifCountry2, acoContactCountry);
        End; // Case DictNo
      End; // With FDAccountContacts.AccountContact
    {$ELSE}
      //PR: 03/02/2014 ABSEXCH-14974
      With AccContact Do
      Begin
        Case DictNo Of
          // COACCODE - Account Code
          26000 : Result := acoAccountCode;
          // CONAME - Contact Name
          26001 : Result := acoContactName;
          // COJOBTIT - Contact Job Title
          26002 : Result := acoContactJobTitle;
          // COPHONE - Contact Phone Number
          26003 : Result := acoContactPhoneNumber;
          // COFAX - Contact Fax Number
          26004 : Result := acoContactFaxNumber;
          // COEMAIL - Contact Email Address
          26005 : Result := acoContactEmailAddress;
          // COOWNADD - Contact Has Own Address
          26006 : Result := YesNoBo(acoContactHasOwnAddress);
          // COADDR1 - Contact Address Line 1
          26007 : Result := acoContactAddress[1];
          // COADDR2 - Contact Address Line 2
          26008 : Result := acoContactAddress[2];
          // COADDR3 - Contact Address Line 3
          26009 : Result := acoContactAddress[3];
          // COADDR4 - Contact Address Line 4
          26010 : Result := acoContactAddress[4];
          // COADDR5 - Contact Address Line 5
          26011 : Result := acoContactAddress[5];
          // COPOSTCD - Contact Postcode
          26012 : Result := acoContactPostCode;

          // MH 26/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Codes
          // COCNTRY - Contact Country Code
          26013 : Result := acoContactCountry;
          // COCNTRN - Contact Country Name
          26014 : Result := CountryCodeName (ifCountry2, acoContactCountry);
        End; // Case DictNo
      End; // With FDAccountContacts.AccountContact
    {$ENDIF}
  End; // Link_AccountContact

  //-------------------------------------------------------------------------

  // MH 23/01/2014 v7.0.9 ABSEXCH-14974: Added support for Account Contact Fields
  Function Link_ContactRole (Const DictNo : LongInt) : Str255;
  Begin // Link_ContactRole
    Result := '';

    {$IFDEF EDLL}
      // Form Designer / Forms Toolkit

      // shouldn't ever hit this code - fields not supported in Form Designer
    {$ELSE}
      // VRW Implementation Here
      Case DictNo Of
        // RODESCR - Role Description PR: 03/02/2014 ABSEXCH-14974 Call function in AccountContactVar to get Description
        26500 : Result := ContactRoleDescription(AccContactRole.acrRoleId);
      End; // Case DictNo
    {$ENDIF}
  End; // Link_ContactRole

  //-------------------------------------------------------------------------

  Function Link_OrderPayments (Const DictNo : LongInt) : Str255;
  var
    KeyL : Str255;
  Begin // Link_OrderPayments
    Result := '';

    {$IFDEF EDLL}
    With OPVATPayFile.VATPayDetails Do
    Begin
    {$ELSE}
    // VRW
    With OrderPaymentVatRec do
    begin
    {$ENDIF}
      Case DictNo Of
        // OPSORREF - Order OurRef
        27001 : Result := vpOrderRef;
        // OPSRCREF - Receipt OurRef
        27002 : Result := vpReceiptRef;
        // OPTRAREF - Transaction OurRef
        27003 : Result := vpTransRef;
        // OPLINENO - Line No
        27004 : Result := IntToStr(vpLineOrderNo);
        // OPSORLIN - SOR Line No
        27005 : Result := IntToStr(vpSORABSLineNo);
        // OPTYPE - Row Type
        27006 : Result := IntToStr(Ord(vpType));
        // OPTYPEDE - Row Type Desc
        27007 : Case vpType Of
                  vptSORPayment     : Result := 'SORPayment';      // Payment against an SOR
                  vptSDNPayment     : Result := 'SDNPayment';      // Payment against an SDN
                  vptSINPayment     : Result := 'SINPayment';      // Payment against an SIN
                  vptSORValueRefund : Result := 'SORRefund';       // Refund against an SOR
                  vptSINValueRefund : Result := 'SINRefund';       // Value Refund against an SIN - generates -SRC
                  vptSINStockRefund : Result := 'SINStockRefund';  // Stock Refund against an SIN - SRF generated instead of -SRC
                  vptMatching       : Result := 'Matching';        // Invoice to Payment Matching
                Else
                  Result := 'Unknown';
                End; // Case vpType
        // OPCURR - Currency
        27008 : Result := IntToStr(vpCurrency);
        // OPDESCR - Description
        27009 : Result := vpDescription;
        // OPVATCOD - VAT Code
        27010 : Result := vpVATCode;
        // OPGOODS - Goods Value
        27011 : Result := Form_Real(vpGoodsValue, 0, 2);
        // OPVAT - VAT Value
        27012 : Result := Form_Real(vpVATValue, 0, 2);
        // OPUSER - User Name
        27013 : Result := vpUserName;
        // OPDATE - Date Stamp
        27014 : Result := vpDateCreated;
        // OPTIME - Time Stamp
        27015 : Result := Copy(vpTimeCreated, 1, 2) + ':' + Copy(vpTimeCreated, 3, 2) + '.' + Copy(vpTimeCreated, 5, 2);

        {$IFDEF RW}
        27016..27018  //PR: 14/10/2014 Extra fields to specify which transaction to link to:
                      //OPLNKORD; OPLNKREC; OPLNKTRA
              : begin
                  case DictNo - 27016 of
                  0  :  KeyL  := vpOrderRef;
                  1  :  KeyL  := vpReceiptRef;
                  2  :  //If the TransRef is blank, then use the OrderRef
                        if Trim(vpTransRef) <> '' then
                          KeyL := vpTransRef
                        else
                          KeyL := vpOrderRef;
                  end; //case

                 if Trim(KeyL) <> '' then
                 begin
                   if Trim(KeyL) <> Trim(Inv.OurRef) then
                   begin //Find transaction
                     KeyL := FullOurRefKey(KeyL);
                     Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyL);
                   end
                   else //We already have the correct transaction
                     Status := 0;
                 end
                 else
                   Status := 4;

                 If (Not StatusOk) then
                   ResetRec(InvF)
                 else
                 begin
                   //Found OK - Set Link Ref
                   OPLinkTransaction := Inv.OurRef;

                   //Load appropriate transaction line
                   LinkOtherDb(OrderPaymentsF, IDetailF);
                 end;
               end; //27016..27018
        {$ENDIF}
      End; // Case DictNo
    End; // With
  End; // Link_OrderPayments

  //-------------------------------------------------------------------------

  { ====== Dictionary control link up ======= }

  { Function to Return BT file no. from Rep Drive file ======= }
  Function FileTXlate(    FNum  :  Integer;
                      Var KPth  :  Integer)  :  Integer;
  Var
    Fno  :  Integer;
  Begin
    Fno:=0;
    KPth:=0;
    Case Fnum of
      1,2    :  Fno:=CustF;
      3      :  Begin
                  Fno:=InvF;
                  KPth:=InvOurRefK;
                End;
      4      :  Fno:=IDetailF;
      5      :  Fno:=NomF;
      6      :  Fno:=StockF;

      7,8,10,
      13,15  :  Fno:=PWrdF;

      12,14,
      16,20  :  Fno:=MiscF;

      { MH 03/04/97 - new files added }
      17,18,
      21     :  FNo:=JMiscF;
      19,25  :  FNo:=JCtrlF;
      22     :  FNo:=JobF;
      23,24  :  FNo:=JDetlF;
      26,27  :  FNo:=MLocF;

      { HM 25/01/99: Matched Payments added }
      28   :  FNo:=PwrdF;

      {*431RW HM 03/04/00: Customer, Supplier and Stock Notes }
      {*431RW HM 12/04/00: 32 Transaction Notes }
      29,
      30,
      31,
      32   :  FNo:=PwrdF;

      //PR 20/01/03 CIS Vouchers
      33   :  FNo := JDetlF;
      //PR 08/09/03 Multi-bins
      34   :  FNo := MLocF;
      //PR: 11/03/09 Alt Stock Codes
      35   :  FNo := MLocF;
      //PR: 11/03/09 Multi-Buy Discounts
      36   :  FNo := MultiBuyF;
      //PR: 13/02/2012 Qty Breaks ABSEXCH-9795
      37   :  FNo := QtyBreakF;
      //PR: 03/02/2014 AccountContactRoles ABSEXCH-14974
      {$IFDEF RW}
      38   :  FNo := AccountContactRoleF;

      //PR: 14/10/2014 39 Order Payments (OPVATPay.Dat)
      39   :  FNo := OrderPaymentsF;
      {$ENDIF RW}
    end; {Case..}
    FileTXlate:=Fno;
  end; {Func..}


  Function Link_Dict(      DictNo     : LongInt;
                     Var   DictLink   : DictLinkType;
                     Const StrRec     : fdFormStringsType;
                     Const PixWidth   : LongInt;
                     Const DriveFile  : Integer;
                     Const SourceFile : Integer;
                           InpStr     : Str255)  :  Str255;
  Var
    TmpField  :  Str255;
    TmpK,TmpF :  Integer;
  Begin
    TmpField:='';

    TmpK:=0;

    { Set String record pointer }
    {GetMem (StringsRec, SizeOf (StringsRec));}
    Try
      {Move (StrRec, StringsRec^, SizeOf (StringsRec^));}
      StringsRec  := @StrRec;

      {TmpF:=FileTxLate(DriveFile,TmpK);}
      TmpF := DriveFile;

      {* Link to other db's as required *}
      If (DictNo>=90000) then
        TmpField:=Link_SysDict(DictNo-90000)
      else
        Case DictNo of

          1000..1999  :  Begin

                           LinkOtherDb(TmpF,CustF);

                           TmpField:=Link_CustDict(DictNo,DictLink);    {* Cust Variables *}

                         end;

          2000..2999  :  Begin

                           LinkOtherDb(TmpF,InvF);

                           TmpField:=Link_DocDict(DictNo, PixWidth);              {* Document Variables *}

                         end;

          3000..3999  :  Begin

                           LinkOtherDb(TmpF,IdetailF);

                           TmpField:=Link_IDDict(DictNo);      {* Details Variables *}

                         end;

          4000..4999  :  Begin
                           LinkOtherDb(TmpF,NomF);

                           TmpField:=Link_NomDict(DictNo,DictLink,InpStr);     {* Nom Variables *}

                         end;

          5000..5999  :  Begin

                           LinkOtherDb(TmpF,StockF);

                           {* Stock Variables *}

                           TmpField:=Link_StkDict(DictNo,DictLink,InpStr);     {* Stock Variables *}

                         end;

          6000..6999  :  Begin

                           {* CC/Dep Variables *}

                           TmpField:=Link_CCDepDict(DictNo,DictLink);     {* CC/Dep Variables *}

                         end;

          7000..7999  :  Begin

                           {* Serial No. Variables *}

                           TmpField:=Link_SerNoDict(DictNo,DictLink);     {* CC/Dep Variables *}

                         end;

          8000..8099  : Begin
                          TmpField:=Link_NotesDict(DictNo);
                        End;

          8100..8999  : Begin { Locations }
                          LinkOtherDb(TmpF,MLocF);
                          TmpField:=Link_MLocDict(SourceFile,DictNo,DictLink);
                        End;

          9000..9999  : Begin
                          { HM 03/09/98: Added relational links }
                          LinkOtherDb(TmpF,JobF);
                          LinkOtherDb(TmpF,JMiscF);

                          TmpField:=Link_JobCostDict(DictNo);
                        End;

          10000..10499 : Begin { Job Analysis Codes }
                           LinkOtherDb(TmpF,JMiscF);
                           TmpField:=Link_JobAnal(DictNo,DictLink);
                         End;

          10500..10999 : Begin { Job Types }
                           LinkOtherDb(TmpF,JMiscF);
                           TmpField:=Link_JobType(DictNo,DictLink);
                         End;

          11000..11499 : Begin { Rates Of Pay }
                           LinkOtherDb(TmpF,JCtrlF);
                           TmpField:=Link_PayRate(SourceFile,DictNo,DictLink);
                         End;
          11500..11999 : Begin { Employees }
                           // HM 03/03/04: Added special handling for JSA/JPA transactions
                           If (TmpF = IDetailF) And (Id.IdDocHed In JAPSplit) Then
                           Begin
                             // Printing JPA/JSA
                             LinkToJxAEmployee;
                           End //
                           Else
                           Begin
                             //special handling for Employee continuous employment fields
                             if (DictNo >= 11523) and (DictNo <= 11526) and (Length(InpStr) = 16) then
                             begin
                               GlobSDate := Copy(InpStr, 1, 8);
                               GlobEDate := Copy(InpStr, 9, 8);
                             end;
                             LinkOtherDb(TmpF,JMiscF);
                           End; // Else
                           TmpField:=Link_Employee(SourceFile,DictNo,DictLink);
                         End;
          12000..12999 : Begin { Job Records }
                           LinkOtherDb(TmpF,JobF);
                           TmpField:=Link_JobRec(DictNo,DictLink);
                         End;
          13000..13999 : Begin { Job Actuals }
                           LinkOtherDb(TmpF,JDetlF);
                           TmpField:=Link_JobAct(DictNo,DictLink);
                         End;
          14000..14999 : Begin { Job Retentions }
                           LinkOtherDb(TmpF,JDetlF);
                           TmpField:=Link_JobRet(DictNo,DictLink);
                         End;
          15000..15999 : Begin { Job Budgets }
                           LinkOtherDb(TmpF,JCtrlF);
                           TmpField:=Link_JobBudget(DictNo,DictLink);
                         End;
          17000..17999 : Begin { Stock/Locations }
                           LinkOtherDb(TmpF,MLocF);
                           TmpField:=Link_StkLoc(DictNo,DictLink);
                         End;
          18000..18999 : Begin { Matched Payments }
                           LinkOtherDb(TmpF,PWrdF);
                           TmpField:=Link_MatPay(DictNo,DictLink);
                         End;
          19000..19499 : Begin { Bill Of Materials }
                           LinkOtherDb(TmpF,PWrdF);
                           TmpField:=Link_BillOMat(DictNo);
                         End;

          19500..19999 : Begin { FIFO }
                           LinkOtherDb(TmpF,MiscF);

                           TmpField:=Link_FIFO(DictNo);
                         End;
          20000..20499 : Begin { Discounts }
                           {LinkOtherDb(TmpF,MiscF);}

                           TmpField:=Link_Discounts(DictNo);
                         End;
          21000..21499 : Begin { User Profile }
                           {LinkOtherDb(TmpF,MiscF);}

                           TmpField:=Link_UserProf(DictNo);
                         End;
          21500..21999 : Begin // Multi-Bins
                           // No Relation links - either loaded or not loaded!
                           //LinkOtherDb(TmpF,MLocF);
                           LinkOtherDb(TmpF, StockF);
                           LinkOtherDb(TmpF, CustF);
                           TmpField:=Link_MutliBins(DictNo,DictLink);
                         End;
          22000..22999 : Begin { Job Costing CIS Vouchers }
                           //LinkOtherDb(TmpF,JDetlF);

                           TmpField:=Link_CISVouchers(DictNo);
                         End;
          23000..23499 : Begin { Alternative Stock Code Db }

                           TmpField:=Link_AltStock(DictNo);
                         End;
          //PR: 10/06/2009
          24000..24999 : Begin //Multi-Buy Discounts

                           LinkOtherDb(TmpF,CustF);
                           LinkOtherDb(TmpF,StockF);

                           TmpField:=Link_MultiBuy(DictNo);    {* Cust Variables *}

                         end;
          //PR: 13/02/2012 ABSEXCH-9795
          25000..25999 : Begin //Qty Breaks

                           LinkOtherDb(TmpF,CustF);
                           LinkOtherDb(TmpF,StockF);

                           TmpField:=Link_QtyBreak(DictNo);    {* Cust Variables *}

                         end;
          // MH 04/11/2014 v7.x MRD2.4.23: Added support for Account Contact Fields
          26000..26499 : Begin
                           // VRW RepEngine will need to call LinkOtherDB here to CustF
                           //PR: 03/02/2014 ABSEXCH-14974: Link AccountContact and
                           // Cust/Supp. AccountContact must be first so we
                           // have the AccountCode to link to cust/supp
                           {$IFDEF RW}
                           LinkOtherDb(TmpF,AccountContactF);
                           LinkOtherDb(TmpF,CustF);
                           {$ENDIF RW}
                           TmpField := Link_AccountContact(DictNo);
                         End; // 26000..26999

          // MH 23/01/2014 v7.0.9 ABSEXCH-14974: Added support for Account Contact Fields
          26500..26999 : Begin
                           TmpField := Link_ContactRole(DictNo);
                         End; // 26000..26999

          // MH 16/09/2014 Order Payments: Added support for printing SRC's as VAT Receipts
          27000..27999 : Begin
                           {$IFDEF RW}
                             //PR: 14/10/2014 VRW
                             // Relational links to Doc Header, Line & Cust
                             //First field for this record - initialise Link Transaction ref to Order Ref
                             if OPLinkTransaction = '' then
                               OPLinkTransaction := OrderPaymentVatRec.vpOrderRef;
                             LinkOtherDb(OrderPaymentsF, InvF);
                             LinkOtherDb(OrderPaymentsF, IDetailF);
                             LinkOtherDb(OrderPaymentsF, CustF);

                           {$ENDIF}
                           TmpField := Link_OrderPayments(DictNo);
                         End; // 27000..27999
        end; {Case..}

      While (Pos (#156, TmpField) > 0) Do
        TmpField [Pos (#156, TmpField)] := '£';

      Link_Dict:=Strip('B',[#32,#0],TmpField);
    Finally
      {FreeMem (StringsRec, SizeOf (StringsRec));}
    End;
  end; {Func..}


{ Called whenever a new form is started, to reinitialise the running totals }
Procedure DicNewForm;
Var
  I : Integer;
begin
  For I := Low (CurrAged) To High (CurrAged) Do
    { Initialise to 0 }
    Blank(CurrAged[I]^,Sizeof(CurrAged[I]^));

  Blank(DefTotals,   Sizeof(DefTotals));
  Blank(DefTotals2, Sizeof(DefTotals2));

  { Temporary records used for relational lookup within same file }
  FillChar (TmpJobCtrl^, SizeOf(TmpJobCtrl^), #0);
  FillChar (TmpJobMisc^, SizeOf(TmpJobMisc^), #0);
  FillChar (TmpMLoc^,    SizeOf(TmpMLoc^),    #0);

  { Init misc running totals }
  TotTLORDUS1 := 0.0;
  TotTLORDWEI := 0.0;

  // Bentely Line Count
  BentLineCount := 0;

  FillChar (TradeInfo^, SizeOf(TradeInfo^), #0);

  AppValTotals.ClearCache;

  // HM 05/07/04: Added NoteMode to allow GINVNOT mode to be changed
  GetNoteMode := 0;

  // MH 13/12/05: Added Bespoke Trolley Totals for J&J Whines
  FillChar(JJTotals, SizeOf(JJTotals), #0);
  JJTrolleyNo := 0;
  JJResetTots := False;
End;

Function Compare_Dates(ToDate,DlDate  :  Str8;
                       DrvMode        :  Byte)  :  LongInt;
Var
  Res  :  LongInt;
Begin
  Res:=0;

  Case DrvMode of
    1  :  Res:=NoDays(Todate,DlDate);
    2  :  Res:=Round(DivwChk(NoDays(ToDate,DlDate),7));
  else
    Res:=MonthDiff(ToDate,DlDate);
  end;

  Compare_Dates:=Res;
end; {Func..}


Procedure MasterAged(Var AgedAry  :  AgedTyp;
                         AgedDate,
                         AsAtDate :  LongDate;
                         Amount   :  Real;
                         DrvMode  :  Byte;
                         Interval :  Integer);
Var
  Diff  :  Integer;
  RDiff :  Real;
Begin
  If (Interval=0) then
    Interval:=1;

  RDiff:=DivWChk(Compare_Dates(AgedDate,AsAtDate,DrvMode),Interval);

  If (RDiff<0) then {* modded as otherwise slightly not due items treated as this month *}
    Diff:=-1
  else
    Diff:=Trunc(RDiff);

  Case Diff of

     0..3    :  AgedAry[Diff+1]:=AgedAry[Diff+1]+Amount;

     else       If (Diff>=0) then
                  AgedAry[5]:=AgedAry[5]+Amount
                else
                  AgedAry[0]:=AgedAry[0]+Amount;

  end;

  If (Diff>=0) then
    AgedAry[6]:=AgedAry[6]+Amount;

  AgedAry[7]:=AgedAry[6]+AgedAry[0];
end; {Procedure..}

//-------------------------------------------------------------------------

{ Called whenever a new row is retrieved to update running totals }
Procedure DicRunTots (Const FormMode : Integer);
Var
  Rnum    : Real;
  StaDate : LongDate;
Begin
  Rnum:=0;

  Case FormMode of
    fmAllDocs,
    fmDocSerialNo,
    fmTimeSheet,
    fmTransSort
       :  With Id do Begin
            DefTotals2[0]:=DefTotals2[0]+1;  {Increase per line}

            {$IFDEF STK}
              If (Is_FullStkCode(StockCode)) then Begin
                DefTotals2[1]:=DefTotals2[1]+1;

                { HM 27/04/99: Modified to stop range check errors if E in bin-location }
                If (Pos('E',Stock.BinLoc)=0) then
                  DefTotals[2]:=DefTotals[2]+DivWChk(Qty_OS(Id),RealStr(Strip('B',[#32],Stock.BinLoc)));
            {$ELSE}
              Begin
            {$ENDIF}
                DefTotals[6]:=DefTotals[6]+Qty;
              end;

            // HM 10/11/00: Bentley Line Count - Check Stock Code is set
            If IsBentleyLine Then Inc (BentLineCount);

            // MH 13/12/05: Added Bespoke Trolley Totals for J&J Whines
            If JJResetTots Then
            Begin
              FillChar(JJTotals, SizeOf(JJTotals), #0);
              JJResetTots := False;
            End; // If JJResetTots 
            If (Not JJTrolleyTotalLine) Then
            Begin
              // Update totals when not on a Trolley Total line
              JJTotals[1] := JJTotals[1] + Id.Qty;
              JJTotals[2] := JJTotals[2] + (DetLTotal(Id,True, False,0.0) * LineCnst(Id.Payment));
            End // If (Not JJTrolleyTotalLine)
            Else
            Begin
              // Trolley Total line - increment Trolley No and reset the J&J Trolley Totals
              Inc(JJTrolleyNo);
              JJResetTots := True;
            End; // Else
          End; { With Id }

    fmStatemLay,
    fmDebtChaseL,
    fmTradeHist,
    fmStateAgeMnth
       :  With Inv do Begin
            If (FormMode In [fmDebtChaseL, fmStateAgeMnth]) Then
              StaDate:=RepInfo.StaAgedDate
            else
              StaDate:=Today;

            If ExVerIsMultiCcy Then Begin
              With Syss Do Begin
                MasterAged(CurrAged[Currency]^,Get_StaChkDate(Inv),StaDate,CurrencyOS(Inv,BOff,BOff,BOff),
                           StaAgeMthd,StaAgeInt);
              End; { With }
            End; { If }

            With Syss do
              MasterAged(CurrAged[0]^,Get_StaChkDate(Inv),StaDate,BaseTotalOs(Inv),StaAgeMthd,StaAgeInt);

            {* Add Doc Total Value *}
            Rnum:=ConvCurrItotal(Inv,BOff,BOn,BOn)*DocCnst[Inv.InvDocHed]*DocNotCnst;

            DefTotals[1+(Ord(Rnum<0))]:=DefTotals[1+(Ord(Rnum<0))]+ABS(Rnum);


            {* Give Running Total, Own Currency if Showing one currency *}

            If ExVerIsMultiCcy Then Begin
              If (RepInfo.SepCr) then
                DefTotals[5]:=DefTotals[5]+CurrencyOS(Inv,BOff,BOff,BOff)
              else
                DefTotals[5]:=DefTotals[5]+BaseTotalOS(Inv);
            End { If }
            Else Begin
              DefTotals[5]:=DefTotals[5]+BaseTotalOS(Inv);
            End; { Else }
          end;

    fmRemitAdv
        : With PassWord.MatchPayRec do Begin
            Rnum:=OwnCVal*DocNotCnst;

            DefTotals[5]:=DefTotals[5]+Rnum;
          end;



    {$IFDEF SOP}
      fmPickLstCons
          : Begin
              DefTotals[4]:=DefTotals[4]+DefTotals[1];

              DefTotals[5]:=DefTotals[5]+DefTotals[2];

              DefTotals[6]:=DefTotals[6]+DefTotals[3]; {* Weight *}

              DefTotals[7]:=DefTotals[7]+DefTotals[0]; {* No Cartons *}
            end;

      fmPickLstSngl
          : Begin
              DefTotals[4]:=DefTotals[4]+Qty_OS(Id);

              DefTotals[5]:=DefTotals[5]+Id.QtyPick;

              { HM 27/04/99: Modified to stop range check errors if E in bin-location }
              {* Specials for carton totals *}
              If (Pos('E',Stock.BinLoc)=0) then begin
                DefTotals[2]:=DefTotals[2]+DivWChk(Qty_OS(Id),RealStr(Strip('B',[#32],Stock.BinLoc)));

                DefTotals[6]:=DefTotals[6]+DivWChk(Id.QtyPick,RealStr(Strip('B',[#32],Stock.BinLoc)));;
              End; { If }
            end;

      // HM 03/09/03: Added support for Picking Lists with Bins
      fmPickListBins,
      fmPickListConsBins
          : Begin
              Deftotals[1] := DefTotals[1] + Id.Qty;
              Deftotals[2] := DefTotals[2] + Id.QtyPick;
            End;
    {$ENDIF}

    {$IFDEF PF_On}
      fmJCBackingSh
          : With JobDetl^.JobActual do Begin
              DefTotals[1]:=DefTotals[1]+(Qty*Cost)*DocCnst[JDDT];

              DefTotals[2]:=DefTotals[2]+(Charge)*DocCnst[JDDT];
            end;
    {$ENDIF}
  End; { Case }

  { Update other misc running totals }
  TotTLORDUS1 := TotTLORDUS1 + CalcTLORDUS1;
  TotTLORDWEI := TotTLORDWEI + CalcTLORDWEI;
End;

Procedure AllocateAged (Const Allocate : Boolean);
Var
  I : SmallInt;
begin
  For I := Low (CurrAged) To High (CurrAged) Do
    If Allocate Then Begin
      { Assign memory }
      GetMem (CurrAged[I], SizeOf (CurrAged[I]^));

      { Initialise to 0 }
      Blank(CurrAged[I]^,Sizeof(CurrAged[I]^));
    End { If }
    Else
      If Assigned (CurrAged[I]) Then Begin
        { Deallocate }
        FreeMem (CurrAged[I], SizeOf (CurrAged[I]^));
        CurrAged[I] := Nil;
      End; { If }

end;

(*
Procedure PosCrap;

  Function FldPos (Const RecPtr, FldPtr : Pointer) : ShortString;
  Var
    RecL, FldL : LongInt;
  Begin  { FldPos }
    RecL := LongInt(RecPtr);
    FldL := LongInt(FldPtr);

    Result := IntToStr(FldL - RecL + 1);
  End; { FldPos }

Begin { PosCrap }
  ShowMessage ('COSConvRate: ' + FldPos(@Id, @Id.COSConvRate));
End; { PosCrap }
*)

Initialization
  //PosCrap;

  DDosMode := False;
  DictCanvas := Nil;
  PBThrown := False;
  DicPageNo := Nil;
  GetMem (TInv, SizeOf (TInv^));
  GetMem (TCust, SizeOf (TCust^));
  {$If Defined(EDLL)}
    GetMem (OrigPrnCust, SizeOf (OrigPrnCust^));
  {$IfEnd}
  AllocateAged (True);
  {GetMem (DefTotals2, SizeOf (DefTotals2^));}

  {$IFDEF EDLL}
    SystemVer := FormDes;
  {$ELSE}
    SystemVer := Unknown;
  {$ENDIF}

  {$IFDEF DBGLST}
    DbgList := TStringList.Create;
    DbgList.Add ('SBSFORM.DLL DEBUGGING ' + FormatDateTime ('HH:MM.SS DD/MM/YY', Now));
  {$ENDIF}

  New (PrintJobInfo);
  FillChar (PrintJobInfo^, SizeOf(PrintJobInfo^), #0);

  New(TradeInfo);

  GetNoteMode := 0;
Finalization
  {FreeMem (DefTotals2, SizeOf (DefTotals2^));}
  AllocateAged (False);
  {$If Defined(EDLL)}
    FreeMem (OrigPrnCust, SizeOf (OrigPrnCust^));
  {$IfEnd}
  FreeMem (TCust, SizeOf (TCust^));
  FreeMem (TInv, SizeOf (TInv^));

  {$IFDEF DBGLST}
    DbgList.SaveToFile ('c:\sbsform.txt');
    DbgList.Destroy;
  {$ENDIF}

  Dispose (PrintJobInfo);

  Dispose (TradeInfo);
end. 
