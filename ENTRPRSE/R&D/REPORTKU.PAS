unit ReportKU;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU, Report8U, Scrtch2U,
  RevChrgU;


type



  TVATRReport2  =  Object(TVATRReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private

                       RLastIO    :    Char;
                       RLAstVR    :    VATType;

                       Procedure Build_VATReturn (Var FoundOk    :  Boolean);

                     protected

                       // CJS 2014-11: Order Payments - Phase 5 - VAT Return
                       // Flag to suppress the automatic printing of the Input
                       // and Output headers and VAT Rate headers when
                       // RepPrintHeader is called (usually via ThrowNewPage
                       // and RepFiler.NewPage).
                       SuppressSectionHeaders: Boolean;

                       // CJS 2014-11: Order Payments - Phase 5 - VAT Return
                       // Moved these functions into protected (instead of
                       // private) as we need to access them from descendant
                       // classes.
                       Function  DocTypeVATEquiv(VT  :  VATType)  :  Char;
                       Procedure CalcVATTotals2(VatValue  :  Double);
                       Procedure PrintVATTot2(OutOfPeriod: Boolean);
                       Procedure PrintVRateDetail(Const VR     :  VATType;
                                                  Const Cont   :  Boolean);
                       Procedure PrintIODetail(Const Section : Char;
                                               Const Cont    :  Boolean);
                       Function GoodsFromAry(VA      :  VATAry;
                                             GetVAT,
                                             GetAll  :  Boolean;
                                             UseRate :  VATType)  :  Double;

                     public

                       ThisScrt   :  Scratch2Ptr;


                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;

                       Function GetReportInput  :  Boolean; Virtual;

                       // CJS 2014-11: Order Payments - Phase 5 - VAT Return
                       // Called after the VAT Return scratch file has been
                       // built. Only used by descendant classes (the
                       // implementation in this class does nothing).
                       procedure AfterBuild; virtual;

                       // CJS 2014-11: Order Payments - Phase 5 - VAT Return
                       // Called after the main transaction analysis list has
                       // been printed. Only used by descendant classes (the
                       // implementation in this class does nothing).
                       procedure AfterTransactionList; virtual;

                       // CJS 2015-01: Order Payments - Phase 5 - VAT Return
                       // Called when the end of a section (Input/Output/Sales
                       // Receipts) has been reached, before the totals are
                       // cleared down for the next section. Only used by
                       // descendant classes (the implementation in this class
                       // does nothing).
                       procedure OnSectionEnd; virtual;

                   end; {Class..}


Procedure AddVATRRep22Thread(LMode    :  Byte;
                             IRepParam:  VATRepPtr;
                             AOwner   :  TObject);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  Math,
  StrUtils,
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
  MiscU,
  {DocSupU1,}
  SalTxl1U,

  {$IFDEF VAT}
    SetVATU,
  {$ENDIF}

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

  RpDefine,
  Report9U,

  IntMU,
  ExThrd2U,
  VatArch,

  oBtrieveFile,
  ExWrap1U,
  MathUtil;

{ ========== TVATRReport2 methods =========== }

Constructor TVATRReport2.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  IsVr2:=BOn;

  // CJS 2014-11: Order Payments - Phase 5 - VAT Return
  SuppressSectionHeaders := False;
end;


Destructor TVATRReport2.Destroy;

Begin

  Inherited Destroy;
end;

Function  TVATRReport2.DocTypeVATEquiv(VT  :  VATType)  :  Char;
Begin
  With MTExLocal^.LInv do
  Begin
    Result:=OurRef[1];

    If (InvDocHed=NMT) and ((NOMVATIO=IOVATCh[BOff]) or (NOMVATIO=IOVATCh[BOn])) then
    Begin
      If (NOMVATIO=IOVATCh[BOff]) then
        Result:=DocCodes[PIN][1]
      else
        Result:=DocCodes[SIN][1];
    end
    {$IFDEF EX603}
      else
      Begin
        If (InvDocHed In PurchSplit) and (SyssVat^.VATRates.VAT[VT].Code=SyssCIS.CISRates.RCTRCV1)
         and (CurrentCountry=IECCode) and (VT<>Spare8) and (SyssCIS.CISRates.RCTUseRCV) then
        Begin
          Result:=DocCodes[SIN][1];
        end;
      end;
    {$ENDIF}
  end;
end;

Procedure TVATRReport2.Build_VATReturn (Var FoundOk    :  Boolean);


Const
  Fnum        =  InvF;
  Keypath     =  InvVATK;

Var
  ItemCount,
  ItemTotal   :  LongInt;

  TmpInclude  :  Boolean;

  CrDr        :  DrCrType;

  KeyCS,
  KeyChk      :  Str255;

  n           :  VATType;

  CVode, RCFlag :  Char;

  oServicesHelper : TRCServicesHelper;

  // CJS 2014-11-05 - T067 - UK VAT Return -  VAT Calculation Extension for Order Payment SRC's
  function IncludeTransaction: Boolean;
  var
    IsInRange: Boolean;
    IsPosted: Boolean;
    IsReceipt: Boolean;
    IsInProcess: Boolean;
  begin
    IsInRange   := (MTExLocal.LInv.VATPostDate <= CRepParam^.VATEndd) and
                   (MTExLocal.LInv.VATPostDate >= CRepParam^.VATStartd);
    IsPosted    := (MTExLocal.LInv.RunNo > 0) or (ReportMode = 2);
    IsReceipt   := (MTExLocal.LInv.InvDocHed in RecieptSet);
    IsInProcess := (MTExLocal.LInv.SSDProcess in ['P', 'T']);

    Result  := (IsInRange and IsPosted and not IsReceipt and not IsInProcess);
  end;

Begin
  ItemCount:=0;

  FoundOk:=BOff;

  With MTExLocal^ do
  Begin
    // CJS 2016-02-18 - ABSEXCH-16569 - exclude NoTc from Box 8 and 9 on VAT return
    ForVATReturn := True;
    Blank(ExcludedNoTCValues, Sizeof(ExcludedNoTCValues));

    ItemTotal:=Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId);

    InitProgress(ItemTotal);

    ShowStatus(0,RepTitle);
    ShowStatus(1,'Calculating Totals...');

    KeyChk:=CRepParam^.VATEndd;

    KeyCS:=CRepParam^.VATStartd;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

    While (LStatusOk) and (CheckKeyRange(CRepParam^.VATStartd,KeyChk,KeyCS,Length(KeyChk),BOff)) and (ChkRepAbort) do
    With LInv do
    Begin

      ShowStatus(2,'Checking : '+OurRef);

      // CJS 2014-11-05 - T067 - UK VAT Return -  VAT Calculation Extension for Order Payment SRC's
      TmpInclude := IncludeTransaction;

      If (TmpInclude) and (ReportMode=2) then {* Exclude any docs which have just been
                                                         Unallocated then re-allocated again *}
      With CRepParam^ do
      Begin

        Set_VATTotals(LInv,BOff);

        TmpInclude:=((GoodsTot<>0) or (VATTot<>0));
      end;

      If (TmpInclude) then
      Begin
        // create services helper class here for UK VAT Return
        If (ReportMode = 0) And DoReverseCharge(LInv) Then
          oServicesHelper := TRCServicesHelper.Create(LInv)
        Else
          oServicesHelper := NIL;

        Try
          // CJS 2016-02-18 - ABSEXCH-16569 - exclude NoTc from Box 8 and 9 on VAT return
          // Exclude transactions which have no values because of NoTC
          if LDef_InvCalc(MTExLocal, oServicesHelper, True, True) then
          begin

            Set_VATTotals(LInv,BOn);

            CrDr[BOff]:=0;

            CrDr[BOn]:=CRepParam^.VATTot;

            CalcVATTotals(CrDr);

            For n:=VStart to VEnd do
            Begin
              If (LInvNetTrig[n]) and (Assigned(ThisScrt)) then
              Begin
                FoundOk:=BOn;

                LGetRecAddr(Fnum);

                With ThisScrt^ do
                Begin
                  CVode:=SyssVat^.VATRates.VAT[n].Code;


                  If Assigned(oServicesHelper) And oServicesHelper.VATDetails[CVode].rcvServices Then
                  Begin
                    // if vat set in services helper class then add scratch file record for reverse charge element here
                    Add_Scratch(Fnum,Keypath,LastRecAddr[Fnum],'P'+CVode+OurRef+TransDate+'R',CVode);   // Input
                    Add_Scratch(Fnum,Keypath,LastRecAddr[Fnum],'S'+CVode+OurRef+TransDate+'R',CVode);   // Output
                    Add_Scratch(Fnum,Keypath,LastRecAddr[Fnum],'V'+CVode+OurRef+TransDate+'R',CVode);   // Reverse Charge
                  End // If Assigned(oServicesHelper)
                  Else
                  begin
                    // CJS 2014-09-11 - ABSEXCH-15518 - include notional VAT on Irish VAT 3 report
                    // CJS 2014-10-13 - ABSEXCH-15674 - Internal purchases appearing as EC Acquisitions
                    //                  Added check for EC Member
                    if (CurrentCountry = IECCode) and (LCust.EECMember) then
                    begin
                      // For Irish VAT, Postponed Accounting (Notional VAT),
                      // include all Services, and include any Goods that are
                      // Acquisitions or Dispatches
                      if (InvECServiceTotals[ectPurchases][ecvNet] <> 0.0) or
                         ((CRepParam.EECTotals[False, 1] <> 0) and (CVode in ['3', '4'])) then
                        Add_Scratch(Fnum,Keypath,LastRecAddr[Fnum],'V'+CVode+OurRef+TransDate+'R',CVode);
                    end;

                    // MH 02/09/2009: Added 'N' into key to allow reverse charge lines to be distinguished
                    Add_Scratch(Fnum,Keypath,LastRecAddr[Fnum],DocTypeVATEquiv(n)+CVode+OurRef+TransDate+'N',CVode);
                  end;
                end;

              end;
            end;
          end; // if LDef_InvCalc...
        Finally
          If Assigned(oServicesHelper) Then
            FreeAndNIL(oServicesHelper);
        End; // Try..Finally
      end;

      Inc(ItemCount);

      UpdateProgress(ItemCount);

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

    end;

    UpdateProgress(ItemTotal);

    InitProgress(0);

    With CRepParam^ do
    Begin
      Blank(SplitTotals,Sizeof(SplitTotals));
      Blank(OPSplitTotals,Sizeof(OPSplitTotals));
    end;
  end;

end;



Procedure TVATRReport2.Process;

Var
  FoundOk  :  Boolean;

  PluginDate
           :  Str255;


Begin
{$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
    ReOpen_LocalThreadfiles;
{$ENDIF}

  New(ThisScrt,Init(13,MTExLocal,BOff));
  InitStatusMemo(4);

  PlugInDate:='';

  Try
    RFnum:=ReportF;
    RKeyPath:=RpK;
    RepKey:=FullNomKey(ThisScrt^.Process);

    FoundOk:=BOff;

    {v5.51 check if vat period replacement hook is installed, and get end date details}

    With CRepParam^ do
      PlugInDate:=LSetVATPostDate(MTExLocal^,4,SetN(VPr)+FullYear(VYr));

    If (PlugInDate<>'') then
      RepTitle:=RepTitle+'. (Period End Date : '+PoutDate(PlugInDate)+')';


    PageTitle:=RepTitle;


    With CRepParam^ do
    Begin
      LastVRate:=Spare8;
      ThisVRate:=Spare8;
    end;

    Build_VATReturn(FoundOk);

    // CJS 2014-11: Order Payments - Phase 5 - VAT Return
    if ChkRepAbort then
    begin
      AfterBuild;

      {ThreadRec^.THAbort:=Not FoundOk;
      ThreadRec^.THAbortPrint:=;

      If (FoundOk) then}
    end;
    // Even if the report is aborted we still need to call the inherited
    // Process so that the print file is set up correctly in case the user
    // wants to print what had already been generated
    Inherited Process;

  finally

    Dispose(ThisScrt,Done);
    ThisScrt:=nil;
  end; {try..}
end;



Procedure TVATRReport2.RepSetTabs;

Begin
  With RepFiler1 do
  Begin

    Case ReportMode of
        0:
           Begin
             SetTab (MarginLeft,pjLeft,7, 4, 0, 0);
             SetTab (NA, pjLeft, 17, 4, 0, 0);      // Our Ref
             SetTab (NA, pjLeft, 40{20}, 4, 0, 0);  // Your Ref
             SetTab (NA, pjLeft, 17, 4, 0, 0);      // Date
             SetTab (NA, pjLeft, 15, 4, 0, 0);      // Per/Yr
             SetTab (NA, pjLeft, 15, 4, 0, 0);      // Account Code
             SetTab (NA, pjLeft, 7, 4, 0, 0);       // A/D
             SetTab (NA, pjLeft, 10, 4, 0, 0);      // Reverse Charge
             SetTab (NA, pjRight,28, 4, 0, 0);      // Net
             SetTab (NA, pjRight,28, 4, 0, 0);      // VAT
             SetTab (NA, pjRight,28, 4, 0, 0);      // Gross
             SetTab (NA, pjLeft,7, 4, 0, 0);        // Adj
             SetTab (NA, pjRight,28, 4, 0, 0);      // Orig Value
             SetTab (NA, pjRight,20, 4, 0, 0);      // Exch Rate
             SetTab (NA, pjLeft,15, 4, 0, 0);       // Revalued
            end;

        1..2:
           Begin
             SetTab (MarginLeft,pjLeft,7, 4, 0, 0);
             SetTab (NA, pjLeft, 17, 4, 0, 0);
             SetTab (NA, pjLeft, 40{20}, 4, 0, 0);  // MHYR
             SetTab (NA, pjLeft, 17, 4, 0, 0);
             SetTab (NA, pjLeft, 15, 4, 0, 0);
             SetTab (NA, pjLeft, 15, 4, 0, 0);
             SetTab (NA, pjLeft, 7, 4, 0, 0);
             SetTab (NA, pjRight,29, 4, 0, 0);
             SetTab (NA, pjRight,29, 4, 0, 0);
             SetTab (NA, pjRight,29, 4, 0, 0);
             SetTab (NA, pjLeft,7, 4, 0, 0);
             SetTab (NA, pjRight,29, 4, 0, 0);
             SetTab (NA, pjRight,20, 4, 0, 0);
             SetTab (NA, pjLeft,15, 4, 0, 0);

            end;

    end; {Case..}
  end; {With..}

  SetTabCount;
end;


{ ====================== Get Full VAT Detail & Print ====================== }

  Procedure TVATRReport2.PrintVRateDetail(Const VR     :  VATType;
                                          Const Cont   :  Boolean);

  Const
    GoodsTit  :  Array[BOff..BOn] of Str20 = ('Non Goods','Goods');


  Var
    GenStr,
    ContStr  :  Str255;

  Begin
    With MTExLocal^,RepFiler1, SyssVAT^.VATRates.VAT[VR] do
    Begin
      DefFont(0,[fsBold]);

      GenStr:=Desc+'. '+Form_Real(Rate*100,0,2)+'%, '+GoodsTit[Include];

      if (Include and (CurrentCountry = IECCode)) then
        GenStr := GenStr + ' & Services';

      If (Cont) then
        ContStr:=' (continued...)'
      else
        ContStr:='';

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.PrintLeft(ConCat(GenStr,ContStr),MarginLeft);
      Self.CrLF;

      DefLine(-1,1,100,-0.3);

      DefFont(0,[]);

    end; {With..}
  end;


{ ====================== Get Full VAT Detail & Print ====================== }

  Procedure TVATRReport2.PrintIODetail(Const Section : Char;
                                       Const Cont    :  Boolean);

  Var
    GenStr,
    ContStr  :  Str255;

  Begin
    With MTExLocal^,RepFiler1 do
    Begin
      DefFont(2,[fsBold]);

      Case Section Of
        'P' : GenStr := 'Inputs';
        'S' : GenStr := 'Outputs';

        // CJS 2015-01-09 - VAT Return section headers
        'O' : GenStr := 'Order Payments Sales Receipts';

        // CJS 2014-09-10 - ABSEXCH-15518 - include notional VAT on Irish VAT 3 report
        // For the Irish VAT Report the Reverse Charge section is replaced with
        // the Postponed Accounting section (otherwise known as Notional VAT)
        'V' : if (CurrentCountry = IECCode) then
                GenStr := 'Postponed Accounting System'
              else
                GenStr := 'Input/Output Reverse Charge Movements';
      Else
        // MH 21/09/2009: Modified to restore original behaviour (FRv6.2.042)
        //GenStr := '?????';
        GenStr := 'Outputs';
      End; // Case Section

      If (Cont) then
        ContStr:=' (continued...)'
      else
        ContStr:='';

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.PrintLeft(ConCat(GenStr,ContStr),MarginLeft);
      Self.CrLF;

      DefLine(-1,1,100,-0.3);

      DefFont(0,[]);

    end; {With..}
  end;


Procedure TVATRReport2.RepPrintPageHeader;

Var
  GenStr  :  Str255;
  n       :  VATType;

Begin

  With RepFiler1,CRepParam^ do
  Begin
    DefFont(0,[fsBold]);

    Case ReportMode of
//      0    : SendLine(ConCat(#9,'*',#9,'Our Ref',#9,'Your Ref',#9,'Date',#9,'Per Yr',#9,'Ac No.',#9,
//                             'A/D',#9,'R/C',#9,'Net',#9,CCVATName^,#9,'Gross',#9,'Adj',#9,'Original Value',#9,
//                             'Ex. Rate',#9,'Revalued'));
      0    : SendLine(#9'*'#9'Our Ref'#9'Your Ref'#9'Date'#9'Per Yr'#9'Ac No.'#9'A/D'#9'R/C'#9'Net'#9 + CCVATName^ + #9'Gross'#9'Adj'#9'Original Value'#9'Ex. Rate'#9'Revalued');

      2    :
            With SyssVat.VATRates do
            Begin

              Case ReportMode of

                0  :  GenStr:='Date';
                2  :  GenStr:='Date Paid';

              end; {Case..}

                                                                 {* vvv Note use of GenStr *}

              SendLine(ConCat(#9,'*',#9,'Our Ref',#9,'Your Ref',#9,GenStr,#9,'Per Yr',#9,'Ac No.',#9,
                              'A/D',#9,'Net',#9,CCVATName^,#9,'Gross',#9,'Adj',#9,'Original Value',#9,
                              'Ex. Rate',#9,'Revalued'));
            end;


    end; {case..}

    
    DefFont(0,[]);
  end; {With..}
end; {Proc..}

Procedure TVATRReport2.RepPrintHeader(Sender  :  TObject);
Begin

  With RepFiler1 do
  Begin
    Inherited RepPrintHeader(Sender);

    // CJS 2014-11: Order Payments - Phase 5 - VAT Return - Suppress section headers
    If (RepFiler1.CurrentPage>1) and (ReportMode In [0,2]) and not SuppressSectionHeaders then
    Begin
      PrintIODetail(RLastIO,BOn);

      PrintVRateDetail(RLastVR,BOn);
    end;

  end; {With..}
end;

// Extracts a value from the supplied VAT Array.
//
// If GetVAT is True this returns the Input + Output value and ignores the
// other parameters.
//
// If GetAll is True, this returns the total of all the entries in the array.
//
// If GetVAT and GetAll are both False, the value stored against the supplied
// UseRate VAT Type is returned.
Function TVATRReport2.GoodsFromAry(VA      :  VATAry;
                                   GetVAT,
                                   GetAll  :  Boolean;
                                   UseRate :  VATType)  :  Double;
var
  n: VATType;
begin
  Result:=0;

  if (GetVAT) then
    Result := VA[IAdj] + VA[OAdj]
  else
    if (GetAll) then
    begin
      for n := VStart to VEnd do
        Result := Result + VA[n];
    end
    else
      Result := Va[UseRate];

end;

// Prints the VAT Rate totals, the Input and Output totals, and the combined
// totals (selecting on the basis of the current value of ReportMode):
//
//    0 : Combined totals
//   20 : VAT Rate totals
//   40 : Input/Output totals
//
// If OutOfPeriod is False, the In-Period totals are printed. If OutOfPeriod
// is True, the Out-of-Period totals are printed and the totals arrays are
// cleared ready for the next report section (this is because the Out-of-Period
// totals are the last things to the printed in each section).
Procedure TVATRReport2.PrintVATTot2(OutOfPeriod: Boolean);
var
  n          : VATType;
  PVATTOt    : VATAry;
  StrTot     : Str80;
  GrossTotal,
  NetTotal,
  VATTotal   : Double;
begin
  StrTot     := '';
  GrossTotal := 0.0;
  VATTotal   := 0.0;
  NetTotal   := 0.0;

  if (ReportMode in [0, 2, 20, 22, 40, 42]) then
  begin
    with CRepParam^, RepFiler1 do
    begin
      case ReportMode of
        20, 22: // Totals for the VAT rate
                case OutOfPeriod of
                  BOff: begin
                          PVATTot := RateTotals;
                          PrintVRateDetail(LastVRate, BOff);
                        end;

                  BOn : PVATTot := OPRateTotals;
                end; {Case..}

        40, 42: // Totals for Inputs or Outputs (Purchases or Sales)
                case OutOfPeriod of
                  BOff: begin
                          PVATTot := SplitTotals;
                          PrintIODetail(RLastIO, BOff);
                        end;

                  BOn : PVATTot := OPSplitTotals;
                end; {Case..}

        else    // Combined totals
                case OutOfPeriod of
                  BOff: PVATTot := RepTotals;
                  BOn : PVATTot := OPrAnal;
                end; {Case..}
      end; // case ReportMode of ...

      // Prepare the appropriate header caption
      if (OutOfPeriod) then
        StrTot := '*Out of period trans ..:'
      else
        StrTot := 'Total In-period trans .:';

      DefFont(0,[fsBold]);

      // Print the 'Combined' caption if we are about to print the in-period
      // combined totals.
      if (not OutOfPeriod) and (ReportMode < 20) then
      begin
        DefFont(2,[fsBold]);

        // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
        Self.PrintLeft('Combined Totals:-', MarginLeft);
        Self.CRLF;

        DefFont(0,[fsBold]);
      end;

      // For Combined totals and Input/Output totals, get the total of all
      // the values in PVATTot, otherwise simply get the value against the
      // LastVRate entry (this should be the VAT rate that we are currently
      // printing).
      NetTotal := GoodsFromAry(PVATTot, BOff, (not (ReportMode in [20, 22])), LastVRate);

      // Get the Input/Output amount against the LastVRate entry in PVATTot.
      VATTotal := GoodsFromAry(PVATTot, BOn, BOff, LastVRate);

      GrossTotal := NetTotal + VATTotal;

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.PrintLeft(StrTot, MarginLeft);

      SendLine(ConCat(ConstStr(#9, IfThen(ReportMode In[0, 20, 40], 9, 8)),
                      FormatFloat(GenRealMask,NetTotal),
                      #9, FormatFloat(GenRealMask,VATTotal),
                      #9, FormatFloat(GenRealMask,GrossTotal)));

      if ((ReportMode in [0, 2])) then
        CashAccCS := CashAccCS + GoodsFromAry(PVATTot, BOff, BOn, LastVRate) +
                                 GoodsFromAry(PVATTot, BOn, BOff, LastVRate);

      // If we have just printed the Out-of-Period totals, we have
      // reached the end of the section, so clear the total arrays.
      if (OutOfPeriod) then
      begin
        OnSectionEnd;

        Blank(RateTotals,Sizeof(RateTotals));
        Blank(OPRateTotals,Sizeof(OPRateTotals));

        If (ReportMode >= 40) then
        Begin
          Blank(SplitTotals, Sizeof(SplitTotals));
          Blank(OPSplitTotals, Sizeof(OPSplitTotals));
        end;
      end;

      // If we are printing the grand totals (ReportMode = 0 or 2),
      // print the EC Sales totals
      if (OutOfPeriod) and (ReportMode < 20) then
      begin
        if (ReportMode = 2) then
        begin
          // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
          Self.PrintLeft('Cash Accounting - Check.:', MarginLeft);
          SendLine(ConCat(ConstStr(#9, 8), FormatFloat(GenRealMask, CashAccCS)));
        end;

        // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
        Self.CRLF;

        if (CurrentCountry = DefaultCountry) then
        begin
          // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
          Self.PrintLeft('EC Acquisitions  - Goods.:', MarginLeft);
          SendLine(ConCat(ConstStr(#9, IfThen(ReportMode = 0, 9, 8)),
                          FormatFloat(GenRealMask,EECAqui[BOff,1]),
                          #9, 'Input ', CCVATName^,
                          #9, FormatFloat(GenRealMask,EECAqui[BOff,2]),
                          #9,
                          #9, 'Output ', CCVATName^,
                          #9, FormatFloat(GenRealMask,EECAqui[BOn,2])));
        end;
      end;

      DefFont(0,[]);

      If (LinesLeft < 5) then
        ThrowNewPage(5);

    end; // with CRepParam^, RepFiler1 do ...
  end; // if (ReportMode in ...
end;


{ ======================= Calculate Due Totals ==================== }

Procedure TVATRReport2.CalcVATTotals2(VatValue  :  Double);


Var
  n          :  VATType;

  TBo        :  Boolean;

Begin
  With CRepParam^, MTExLocal^ do
    Case ReportMode of
      0..2
         :  With LInv do
            Begin
              TBO:=VATSalesMode(SalesorPurch(InvDocHed),ThisVRate);

              If (Not Out_OfPr(LInv)) then
              Begin

                n:=ThisVRate;

                Begin
                  RateTotals[n]:=RateTotals[n]+IPrGoodsAnal[n];

                  SplitTotals[n]:=SplitTotals[n]+IPrGoodsAnal[n];

                end;

                If (TBo) then
                  n:=OAdj
                else
                  n:=IAdj;

                RateTotals[n]:=RateTotals[n]+Round_Up(VatValue,2);

                SplitTotals[n]:=SplitTotals[n]+Round_Up(VatValue,2);
              end
              else
              Begin

                n:=ThisVRate;

                Begin
                  OPRateTotals[n]:=OPRateTotals[n]+IPrGoodsAnal[n];

                  OPSplitTotals[n]:=OPSplitTotals[n]+IPrGoodsAnal[n];
                end;


                If (TBo) then
                  n:=OAdj
                else
                  n:=IAdj;

                OPRateTotals[n]:=OPRateTotals[n]+Round_Up(VatValue,2);

                OPSplitTotals[n]:=OPSplitTotals[n]+Round_Up(VatValue,2);

              end;


            end;



    end; {Case..With..}
end;





Procedure TVATRReport2.PrintReportLine;

Const
  Fnum    =  InvF;
  KeyPath =  InvFolioK;

Var
  VAT       :  DrCrType;

  LineVATRate,
  Rnum,
  Dnum       :  Double;

  Rnum1,
  Rnum2,
  Rnum3      :  Real;

  n          :  VATType;

  ForSales,
  IsRevalued       :  Boolean;

  lAquiCode,
  AdjCh,
  OPCh,
  RevalueCh  :  Char;

  RevCode,
  GenStr,
  GenXRateMask
             :  Str255;

  oServicesHelper : TRCServicesHelper;

  rNetVal : Double;

Begin
  ForSales := False;

  GenStr:='';

  RevalueCh:=#32; AdjCh:=#32; OPCh:=#32;

  Rnum1:=0; Rnum2:=0; Rnum3:=0; LineVATRate:=0.0;

  // CJS 2014-11: Order Payments - Phase 5 - VAT Return
  // Do not print Order Payment Sales Receipts (these are printed as a
  // separate list after the main Transaction Analysis list).
  if (CRepParam.CurrentSection = 'O') then
    Exit;

  With RepFiler1,MTExLocal^,CRepParam^ do
  Begin

    If (LastDocType<>CurrentSection{DocTypeVATEquiv(ThisVRate)}) or (LastVRate<>ThisVRate) then
    Begin

      If (LastVRate<>Spare8) then
      Begin
        ReportMode:=ReportMode+20;

        DefLine(-1,1,PageWidth-MarginRight-1,0);

        PrintVATTot2(BOff);

        PrintVATTot2(BOn);

        ReportMode:=ReportMode-20;

        // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
        Self.CRLF;
      end;


      LastVRate:=ThisVRate;

      If (LastDocType<>CurrentSection{DocTypeVATEquiv(ThisVRate)}) then
      Begin

        If (LastDocType<>C0) then
        Begin
          ReportMode:=ReportMode+40;

          DefLine(-1,1,PageWidth-MarginRight-1,0);

          PrintVATTot2(BOff);

          PrintVATTot2(BOn);

          ReportMode:=ReportMode-40;

          // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
          Self.CRLF;
        end;

        LastDocType:=CurrentSection{DocTypeVATEquiv(ThisVRate)};

        //RLastIO:=(LastDocType=DocCodes[PIN][1]);
        RLastIO := CurrentSection;

        PrintIODetail(RLastIO,BOff);

      end;

      PrintVRateDetail(ThisVRate,BOff);


      RLastVR:=ThisVRate;

    end;

    // create services helper class here for UK VAT Return
    If (ReportMode = 0) And DoReverseCharge(LInv) Then
      oServicesHelper := TRCServicesHelper.Create(LInv)
    Else
      oServicesHelper := NIL;

    Try
      LDef_InvCalc(MTExLocal, oServicesHelper, True);

      Set_VATTotals(LInv,BOff);

      {$IFDEF VAT}
        Get_EECAquiDetails(LInv,IPrGoodsAnal,IPrVATanal,
                           Rnum1,Rnum2,Rnum3,
                           NOClaimOVAT,AquiCode,MTExLocal);
      {$ENDIF}

      SetReportDrillDown(0);

      Case ReportMode of
        0,2
           :  With LInv do
              Begin
                Blank(VAT,SizeOf(VAT));

                ForSales := VATSalesMode(SalesorPurch(InvDocHed), ThisVRate);

                VAT[ForSales] := IPrVATAnal[ThisVRate];

                IsRevalued := ReValued(LInv);

                Case ReportMode of
                  0  :  GenStr:=PoutDate(Transdate);
                  2  :  GenStr:=PoutDateB(UntilDate);
                end; {Case..}

                If (Out_OfPr(LInv)) then
                  OPCh:='*';

                Dnum:=LInvNetAnal[ThisVRate]*DocCnst[InvDocHed]*DocNotCnst;

                GenXRateMask:=FormatDecStrSD(6,GenRealMask,BOff);

                If (OldORates[BOn]<>0.0) then {* Its been through a conversion *}
                  LineVATRate:=OldORates[BOn]
                else
                  LineVATRate:=OrigRates[BOn];

                  {* Note Use of PPr_Pr/Yr vv *}

                // MH 23/09/2009: Only show the A/D flag in the A/D VAT Code sections
                If (AquiCode <> ' ') And (GetVATNo(AquiCode,#0) = ThisVRate) Then
                  lAquiCode := AquiCode
                Else
                  lAquiCode := ' ';
                //lAquiCode := AquiCode;

                If (ReportMode = 0) Then
                Begin
                  If DoReverseCharge Then
                  Begin
                    RevCode := #9 + IfThen (RevChargeFlag = 'R','RC','');

                    // NOTE: If we have an oServicesHelper instance then we are working on a purchase transaction
                    //       capable of having Reverse Charge - if we are in the Outputs ('S') or Reverse Charge ('V')
                    //       sections then it has to be a transaction with reverse charge
                    If Assigned(oServicesHelper) And (CurrentSection In ['S', 'V']) Then
                    Begin
                      // Reverse Charge Services - modify figures to report service element only - reverse sign for Outputs
                      With oServicesHelper.VATDetails[CurrentVATCode] Do
                      Begin
                        IPrGoodsAnal[ThisVRate] := rcvServicesValue * IfThen(CurrentSection = 'S', -1, 1);   // Net
                        VAT[ForSales] := rcvServicesTax * IfThen(CurrentSection = 'S', -1, 1)                   // VAT
                      End; // With oServicesHelper.VATDetails[CurrentVATCode]
                    End // If Assigned(oServicesHelper) And (CurrentSection In ['S', 'V'])
                  End // If DoReverseCharge
                  // CJS 2014-09-10 - ABSEXCH-15518 - include notional VAT on Irish VAT 3 report
                  // We will only get here if this is an Irish VAT report, in
                  // which case the 'V' entries from the scratch file will be
                  // for EC Acquisitions
                  Else if (CurrentSection = 'V') Then
                  begin
                    RevCode := #9;
                    // Nominal VAT
                    VAT[ForSales] := Rnum2;
                    VAT[ForSales] := LInvVATAnal[ThisVRate];
                  end
                  Else
                    RevCode := #9;  // Skip R/C column
                End // If (ReportMode = 0) And DoReverseCharge
                Else
                  RevCode := '';

                // Calculate Gross
                Rnum:=IPrGoodsAnal[ThisVRate]+VAT[ForSales];

                SendLine(ConCat(#9,OPCh,
                                #9,OurRef,
                                #9,YourRef,
                                #9,GenStr,
                                #9,PPR_OutPr(ACPr,ACYr),
                                #9,CustCode,
                                #9,lAquiCode,
                                RevCode,                                               // Reverse Charge Indicator
                                #9,FormatFloat(GenRealMask, IPrGoodsAnal[ThisVRate]),  // Net
                                #9,FormatFloat(GenRealMask,VAT[ForSales]),  // VAT
                                #9,FormatFloat(GenRealMask,Rnum),                      // Gross
                                #9,YesNoBo(LManVATOR),                                 // Adj (Manual VAT?)
                                #9,FormatCurFloat(GenRealMask,Dnum,BOff,Currency),     // Original Value
                                #9,FormatFloat(GenXRateMask,LineVATRate),              // Exch Rate
                                #9,YesNoBo(IsRevalued)));                              // Revalued


              end;

      end; {Case..}
    Finally
      If Assigned(oServicesHelper) Then
        FreeAndNIL(oServicesHelper);
    End; // Try..Finally

    CalcVATTotals2(VAT[ForSales]);

  end; {With(s)..}
end;



{ ======================= VAT End ======================= }


Procedure TVATRReport2.PrintEndPage;

Var
  TmpRepMode  :  Integer;

Begin
  With RepFiler1,CRepParam^ do
  Begin

    If (ReportMode In [0,2]) then
    Begin
      ReportMode:=ReportMode+20; {* Print Split for Sales.. *}

      DefLine(-1,1,PageWidth-MarginRight-1,-0.5);

      If (LinesLeft<5) then
        ThrowNewPage(5);

      PrintVATTot2(BOff);

      PrintVATTot2(BOn);

      ReportMode:=ReportMode+20;

      if not ((CurrentSection = 'V') and (CurrentCountry = IECCode)) then
      begin
        DefLine(-1,1,PageWidth-MarginRight-1,-0.5);

        If (LinesLeft<5) then
          ThrowNewPage(5);

        PrintVATTot2(BOff);

        PrintVATTot2(BOn);
      end;

      ReportMode:=ReportMode-40;

      DefLine(-1,1,PageWidth-MarginRight-1,-0.5);

      If (LinesLeft<5) then
        ThrowNewPage(5);

      PrintVATTot2(BOff);

      PrintVATTot2(BOn);

      Inherited PrintEndPage;

      // CJS 2015-01-05 - ABSEXCH-15967 - VAT return overwrites Total Rows heading
      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;

      // CJS 2016-02-18 - ABSEXCH-16569 - exclude NoTc from Box 8 and 9 on VAT return
      PrintNoTCNote;

      // CJS 2014-11: Order Payments - Phase 5 - VAT Return
      AfterTransactionList;

      RNoPageLine:=BOn;

      ICount:=1;

      TmpRepMode:=ReportMode;

      ReportMode:=7;

      PageTitle:=RepTitle+'. Reconciliation Report';

      ThrowNewPage(-1);

      PageTitle:=RepTitle;

      ReportMode:=TmpRepMode;

    end;

    VAT_Summary;

    Inherited PrintEndPage;

    // CJS 2016-02-18 - ABSEXCH-16569 - exclude NoTc from Box 8 and 9 on VAT return
    Self.CRLF;
    PrintNoTCNote;

  end; {With..}
end;


{ ======================= VAT Include ======================= }


Function TVATRReport2.IncludeRecord :  Boolean;

Var
  TmpInclude :  Boolean;


Begin
  TmpInclude := False;

  {$B-}

  With MTExLocal^,CRepParam^ do
  Begin
    Case ReportMode of
      0,2  :
              Begin
                ThisScrt^.Get_Scratch(LRepScr^);

		            TmpInclude:=BOn;

                ThisVRate:=GetVATNo(LRepScr^.KeyStr[1],#0);

                // Extract flags from temp file key string - format = Temp Folio (Long) + Section (Char) + Vat Code (Char) + OurRef (Str9) + TransDate (Str8) + Reverse Charge Flag (Char) + '!'
                CurrentSection := LRepScr^.AccessK[5];
                CurrentVATCode := LRepScr^.AccessK[6];
                If (ReportMode = 0) Then
                  RevChargeFlag := LRepScr^.AccessK[24];

              end;

    end; {Case..}
  end; {With..}

    {$B+}

  Result:=TmpInclude;
end; {Func..}




Function TVATRReport2.GetReportInput  :  Boolean;

Begin
  With CRepParam^ do
  Begin

    Result:= Inherited GetReportInput;

    PageTitle:=RepTitle+'. Audit Trail Report';

  end; {With..}

  Result:=BOn;
end;

// CJS 2014-11: Order Payments - Phase 5 - VAT Return
procedure TVATRReport2.AfterBuild;
begin
  { Default does nothing }
end;

// CJS 2014-11: Order Payments - Phase 5 - VAT Return
procedure TVATRReport2.AfterTransactionList;
begin
  { Default does nothing }
end;

// CJS 2015-01: Order Payments - Phase 5 - VAT Return
procedure TVATRReport2.OnSectionEnd;
begin
  { Default does nothing }
end;

{ ======== }




Procedure AddVATRRep22Thread(LMode    :  Byte;
                             IRepParam:  VATRepPtr;
                             AOwner   :  TObject);


Var
  EntTest  :  ^TVATRReport2;

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

        end;

        If (Create_BackThread) and (Start) then
        Begin
          //PR 02/02/07 If we're closing the VAT period then create an archive .pdf file
          if IRepParam.AutoCloseVAT then
            AddVATArchRep2Thread(LMode, IRepParam, AOwner);

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