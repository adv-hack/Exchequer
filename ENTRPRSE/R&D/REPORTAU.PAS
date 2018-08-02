unit ReportAU;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, StrUtils,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU;

const
  EC_VAT_REPORT_MODE   = 2;   // Original report mode
  EC_SALES_REPORT_MODE = 235; // Post-2009 report mode. Trying to avoid anything EL might conceivably have used.
  EC_SALES_EXPORT_MODE = EC_SALES_REPORT_MODE + 1;

type

  TECTotals = record
    Goods: Double;
    TriangulatedGoods: Double;
    TriangulatedServices: Double;
    Services: Double;
  end;

  TECVATReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                     private

                       Procedure Calc_Q4(EDate    :  LongDate;
                                     Var QNo,Qyr  :  LongInt);

                       Procedure CVATHed;

                       Procedure PrintECContDecl;

                       Procedure PrintECDecl;




                       Procedure Count_LinePage;

                       Function GetReportInput  :  Boolean; Virtual;

                      {
                        Returns True if any Service totals are found, and stores
                        the totals in the Services and TriangulatedServices fields of the supplied
                        Totals record.
                      }
                      function CalcServiceTotals(CustCode: Str10; SDate, EDate: LongDate; var Totals: TECTotals): Boolean;

                      {
                        Returns True if any Goods totals are found, and stores the
                        totals in the Goods and TriangulatedGoods fields of the supplied Totals
                        record.
                      }
                      function CalcGoodsTotals(CustCode: Str10; SDate, EDate: LongDate; var Totals: TECTotals): Boolean;

                      procedure InitialiseSQLCache;

                     public

                       CRepParam  :  CVATRepPtr;

                       CustTotals: TECTotals;
                       GrandTotals: TECTotals;

                       IncludeGoods: Boolean;
                       IncludeServices: Boolean;
                       UpdateECServiceTax: Boolean;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Update_ECSales(LastDate  :  LongDate);

                       Function IncludeECInv(InvR  :  InvRec;
                                             SDate,
                                             EDate :  LongDate)  :  Boolean;

                       //PR: 20/02/2014 ABSEXCH-15042 Added ServicesTotal var parameter to return services proportion of transaction
                       Function Scan_4ECSales(CCode  :  Str10;
                                              CSup   :  Char;
                                              SDate,
                                              EDate  :  LongDate;
                                          Var TriVal :  Double;
                                          Var ServicesTotal : Double)  :  Double;



                      {
                        Returns True if any totals are found, and stores the totals
                        in the supplied Totals record.
                      }
                      function Calc_ECSales(CustCode: Str10; SDate, EDate: LongDate; var Totals: TECTotals): Boolean;

                       function IncludeRecord  :  Boolean; Virtual;


                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure RepPrint(Sender  :  TObject); Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddECVATRep2Thread(LMode    :  Byte;
                             IRepParam:  CVATRepPtr;
                             AOwner   :  TObject;
                             IncludeGoods: Boolean = False;
                             IncludeServices: Boolean = False;
                             Title: string = '';
                             UpdateServiceTax: Boolean = False);


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
  ExThrd2U, ExWrap1U, SQLUtils;




{ ========== TECVATReport methods =========== }

Constructor TECVATReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  UpdateECServiceTax := False;
end;


Destructor TECVATReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;




Procedure TECVATReport.Process;

Begin
  Inherited Process;
end;



Procedure TECVATReport.RepSetTabs;
Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        EC_VAT_REPORT_MODE, EC_SALES_REPORT_MODE:
           If (CurrentCountry<>IECCode) then
           Begin
             // UK
             If (RDevRec.fePrintMethod = 5 {XLSX}) Then
             Begin
               // MH 13/01/2016 2016-R1 ABSEXCH-17144: Print To XLSX - need a combined set of tabs that works for both sections
               SetTab (MarginLeft, pjLeft,  10, 4, 0, 0);
               SetTab (NA,         pjLeft,  10, 4, 0, 0);
               SetTab (NA,         pjLeft,  70, 4, 0, 0);
               SetTab (NA,         pjRight, 49, 4, 0, 0);
               SetTab (NA,         pjRight, 40, 4, 0, 0);
               SetTab (NA,         pjRight, 40, 4, 0, 0);
             End // If (RDevRec.fePrintMethod = 5 {XLSX})
             Else
             Begin
               // Print To Printer, etc...
               SetTab (MarginLeft, pjRight, 10, 4, 0, 0);
               SetTab (NA, pjLeft, 10, 4, 0, 0);
               SetTab (NA, pjLeft, 70, 4, 0, 0);
               SetTab (NA, pjRight,49, 4, 0, 0);
               SetTab (NA, pjCenter,40, 4, 0, 0);
             End; // Else
           end
           else
           Begin
             // EIRE
             If (RDevRec.fePrintMethod = 5 {XLSX}) Then
             Begin
               // MH 13/01/2016 2016-R1 ABSEXCH-17144: Print To XLSX - need a combined set of tabs that works for both sections
               SetTab (MarginLeft, pjLeft,   20, 4, 0, 0);
               SetTab (NA,         pjLeft,   80, 4, 0, 0);
               SetTab (NA,         pjRight,  70, 4, 0, 0);
               SetTab (NA,         pjCenter, 40, 4, 0, 0);
             End //
             Else
             Begin
               // Print To Printer, etc...
               SetTab (MarginLeft, pjRight, 20, 4, 0, 0);
               SetTab (NA, pjLeft, 1, 4, 0, 0);
               SetTab (NA, pjLeft, 60, 4, 0, 0);
               SetTab (NA, pjRight,79, 4, 0, 0);  //PR: 19/02/2014 ABSEXCH-15042 Increased size to include 'services'
               SetTab (NA, pjCenter,40, 4, 0, 0);
             End; // Else
           end
    end; {Case..}
  end; {With..}

  SetTabCount;
end;



{ ======== Procedure to Calculate Calender Quarter ======= }


Procedure TECVATReport.Calc_Q4(EDate    :  LongDate;
                           Var QNo,Qyr  :  LongInt);


Var
  Qm  :  Integer;
Begin
  Qm:=Part_Date('M',EDate);

  If (CurrentCountry<>IECCode) then
  Begin
    Case Qm of
      1..3  :  QNo:=1;
      4..6  :  QNo:=2;
      7..9  :  QNo:=3;
      10..12:  QNo:=4;
      else     QNo:=1;
    end; {Case..}
  end
  else
    QNo:=Qm;

  QYr:=TxlatePYr(Part_Date('Y',EDate)-1900,BOn);
end;


{ ======================= Due Header ======================= }



Procedure TECVATReport.CVATHed;
Var
  n      :  Byte;
  GenStr :  Str255;
  ExcelMode : Boolean;
  ExcelMods : String;

  //------------------------------

  Procedure SetIETabs(Mode  :  Boolean);
  Begin
    // MH 13/01/2016 2016-R1 ABSEXCH-17144: Print To XLSX - need a combined set of tabs that works for both sections
    If (Not ExcelMode) Then
      With CRepParam^, RepFiler1 do
      Begin
        ClearTabs;

        If (Mode) then
        Begin
          SetTab (MarginLeft, pjLeft, 100, 4, 0, 0);
          SetTab (NA, pjLeft, 84, 4, 0, 0);
        end
        else
        Begin
          SetTab (MarginLeft, pjLeft, 100, 4, 0, 0);
          SetTab (NA, pjLeft, 34, 4, 0, 0);
          SetTab (NA, pjLeft, 70, 4, 0, 0);
        end;
      end;
  end;

  //------------------------------

Begin
  // MH 13/01/2016 2016-R1 ABSEXCH-17144: Print To XLSX - need a combined set of tabs that works for both sections
  ExcelMode := (RDevRec.fePrintMethod = 5 {XLSX});

  With CRepParam^, RepFiler1 do
  With Syss do
  Begin
    For n:=1 to 3 do
      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;

    DefFont (0,[fsBold,fsUnderLine]);
    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.PrintCenter (Trim(PageTitle), PageWidth / 2);
    Self.CRLF;

    DefFont (0,[fsBold]);

    For n:=1 to 3 do
      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;

    If (CurrentCountry<>IECCode) then
    Begin
      // UK

      // MH 13/01/2016 2016-R1 ABSEXCH-17144: Print To XLSX - need a combined set of tabs that works for both sections
      If (Not ExcelMode) Then
      Begin
        ClearTabs;
        SetTab (MarginLeft, pjLeft, 85, 4, 0, 0);
        SetTab (NA, pjLeft, 40, 4, 0, 0);
        SetTab (NA, pjRight, 70, 4, 0, 0);
      End; // If (Not ExcelMode)

      SendLine(#9 + 'Submitted by:-' + IfThen(ExcelMode, #9#9#9, #9) + 'VAT Reg No:' + IfThen(ExcelMode, #9#9, #9) + 'Branch/subsidiary');
      SendLine(IfThen(ExcelMode, #9#9#9#9#9#9, #9#9#9) + 'Identifier');

      DefFont (0,[]);
      SendLine(#9 + UserName + IfThen(ExcelMode, #9#9#9, #9) + UserVATReg + IfThen(ExcelMode, #9#9 + StringOfChar('_', 15), ''));

      If (Not ExcelMode) Then
        DefLine(-1,TabStart(3)+30,TabEnd(3),0);

      SendLine(#9 + DetailAddr[1]);
      SendLine(#9 + DetailAddr[2]);

      SendText(#9 + DetailAddr[3]);
      DefFont (0,[fsBold]);

      SendLine(IfThen(ExcelMode, #9#9#9#9, #9#9) + 'Date Due:' + IfThen(ExcelMode, #9#9, #9) + 'Calendar Quarter:');
      DefFont (0,[]);
      SendLine(#9 + DetailAddr[4] + IfThen(ExcelMode, #9#9#9#9#9, #9#9) + SetPadNo(Form_Int(QYr,0),2) + '/' + Form_Int(QNo,0));

      SendLine(#9 + DetailAddr[5]);
    end
    else
    Begin
      // EIRE
      DefFont (0,[fsBold]);

      // MH 13/01/2016 2016-R1 ABSEXCH-17144: Print To XLSX - need a combined set of tabs that works for both sections
      If (Not ExcelMode) Then
        ExcelMods := ''
      Else
        ExcelMods := #9;

      SetIETabs(BOn);
      SendLine(#9 + 'TRADERS NAME AND ADDRESS' + #9 + ExcelMods + 'TRADERS VAT REGISTRATION NO.');
      DefFont (0,[]);
      SendLine(#9 + UserName + #9 + ExcelMods + UserVATReg);
      SetIETabs(BOff);
      SendLine(#9 + DetailAddr[1] + #9 + ExcelMods + 'TYPE :' + #9 + VType);
      SendLine(#9 + DetailAddr[2] + #9 + ExcelMods + 'PERIOD' + #9 + SetPadNo(Form_Int(QNo,0),2) + '/' + Form_Int(QYr,0));
      SetIETabs(BOn);
      //PR: 19/02/2014 ABSEXCH-15042 Added 'services'
      SendLine(#9 + DetailAddr[3] + #9 + ExcelMods + 'TOTAL VALUE OF SUPPLIES OF GOODS/SERVICES');
      SetIETabs(BOff);
      GenStr:=SSymb(Syss.VATCurr);
      SendLine(#9 + DetailAddr[4] + #9 + ExcelMods + '(EXPORTS) IN: ' + GenStr + #9 + FormatFloat(GenRealMask,RepTot));
      SendLine(#9 + DetailAddr[5] + #9 + ExcelMods + 'NO. OF ITEMS:' + #9 + Form_Int(TotLines,0));

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;
    end;

    RepSetTabs;
  end;

end;



Procedure TECVATReport.RepPrintPageHeader;

Var
  GenStr  :  Str255;
  n       :  VATType;

Begin

  With RepFiler1,CRepParam^ do
  Begin
    DefFont(0,[fsBold]);

    Case ReportMode of


      EC_VAT_REPORT_MODE, EC_SALES_REPORT_MODE:

            If (CurrentCountry<>IECCode) then
            Begin
              SendLine(ConCat(#9,#9,'CC',#9,'Customer''s',' ','VAT Reg No.',
                              #9,'Total value of supplies',
                              #9,'Indicator'));
            end
            else
            Begin //PR: 19/02/2014 ABSEXCH-15042 Added 'services'
              // MH 13/01/2016 2016-R1 ABSEXCH-17144: Print To XLSX - need a combined set of tabs that works for both sections
              If (RDevRec.fePrintMethod = 5 {XLSX}) Then
                // Excel
                SendLine(#9 + 'ITEM NO.' + #9 + 'CUSTOMER VAT REG NO.' + #9 + 'VALUE OF SUPPLIES OF GOODS/SERVICES' + #9 + 'FLAG')
              Else
                // Print to printer, etc...
                SendLine(ConCat(#9,'ITEM NO.',#9,#9,'CUSTOMER VAT REG NO.',
                                #9,'VALUE OF SUPPLIES OF GOODS/SERVICES',
                                #9,'FLAG'));

            end;


    end; {case..}

    DefLine(-1,MarginLeft,PageWidth-MarginRight-1,0);

    DefFont(0,[]);

    If (CurrentCountry<>IECCode) then
      SendLine('');
  end; {With..}
end; {Proc..}


Procedure TECVATReport.RepPrintHeader(Sender  :  TObject);
Begin

  With RepFiler1 do
  Begin

    If (CurrentPage=1) then
    Begin
      RepSetTabs;

      // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
	  SendTabsToXLSX (False);

      if SQLUtils.UsingSQLAlternateFuncs then
        InitialiseSQLCache;

      Count_LinePage;

    end;

    CVATHed;

    RepPrintPageHeader;

  end; {With..}
end;


Function TECVATReport.IncludeECInv(InvR  :  InvRec;
                                   SDate,
                                   EDate :  LongDate)  :  Boolean;
// CJS 2014-05-02 - ABSEXCH-14964 - Loan items on EC Sales list
var
  IsLoan: Boolean;
Begin

  {* ************ If this is altered, must alter version in ReportBU, and EDI section *}

  With InvR do
  Begin
    // CJS 2014-05-02 - ABSEXCH-14964 - Loan items on EC Sales list - loans are
    // indicated by a Transaction Nature whose first digit is 6
    IsLoan := Copy(IntToStr(InvR.TransNat), 1, 1) = '6';

    Result:=((TransDate>=SDate) and (TransDate<=EDate))
      and ((RunNo>=0) or (RunNo=BatchRunNo)) {Debug mode only }
      and (SSDProcess<>'P')
      and (Not (InvDocHed In QuotesSet+RecieptSet+PSOPSet))
      and (not IsLoan);


    {$IFDEF USEONEDAY}
    Result:= (((TransDate>=SDate) and (TransDate<=EDate))
          or ((PostDate>=SDate) and (PostDate<=EDate) and (TransDate<SDate)))
            and (RunNo>0) and (SSDProcess<>'P')
      and (Not (InvDocHed In QuotesSet+RecieptSet+PSOPSet))
      and ((Not (InvDocHed In CreditSet)) or (CurrentCountry<>IECCode))
      and (not IsLoan);

    {$ENDIF}
  end; {With..}


end;

{ ==== Function to Scan a given customer and check the Sales value between any given dates ==== }


Function TECVATReport.Scan_4ECSales(CCode  :  Str10;
                                    CSup   :  Char;
                                    SDate,
                                    EDate  :  LongDate;
                                Var TriVal :  Double;
                                Var ServicesTotal : Double)  :  Double;



Const
  Fnum     =  InvF;
  Keypath  =  InvCustK;

  Fnum2    =  IdetailF;
  Keypath2 =  IdFolioK;


Var
  KeyCS,
  KeyChk,
  KeyS2,
  KeyChk2
           :  Str255;

  //PR: 20/02/2014 Changed variable names to be more meaningful (rather than rnum, rnum1, etc.)
  GoodsTotal,
  LineTotal,
  ThisTransTotal    :  Real;





Begin

  GoodsTotal:=0;

  LineTotal:=0;

  TriVal:=0.0;
  ServicesTotal := 0.0;

  KeyChk:=FullCustType(CCode,CSup);

  KeyCS:=KeyChk;

  With MTExLocal^ do
  Begin
    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

    While (LStatusOk) and (Checkkey(KeyChk,KeyCS,Length(KeyChk),BOn)) do
    With LInv do
    Begin

      If (IncludeECInv(LInv,SDate,EDate)) then
      Begin
        ThisTransTotal := 0.0;


        KeyChk2:=FullNomKey(FolioNum);

        KeyS2:=FullIdKey(FolioNum,1);

        LStatus:=LFind_Rec(B_GetGEq,Fnum2,KeyPath2,KeyS2);


        While (LStatusOk) and (Checkkey(KeyChk2,KeyS2,Length(KeyChk2),BOn)) do
        With LId do
        Begin

          //PR: 23/12/2009 At MR's request, added check for Vat Code 4.
          If (LineNo>0) and (VATCode in [VATECDCode, '4']) then
//          If (LineNo>0) and (VATCode=VATECDCode) then
          Begin

            LineTotal := DetLTotal(LId,BOn,BOff,0.0)*DocNotCnst;

            //PR: 20/02/2014 ABSEXCH-15042 Need to separate Goods and Service at this point, but only for Ireland
            {** Convert @ original currency (v2.30) **}
            LineTotal := Round_Up(Conv_VATCurr(LineTotal,VATCrate[UseCoDayRate],XRate(OrigRates,BOff,Currency),Currency,UseORate),2);

            if LId.ecService and (CurrentCountry = IECCode) then
              Servicestotal := ServicesTotal + LineTotal
            else
              ThisTransTotal := ThisTransTotal + LineTotal;
          end;


          LStatus:=LFind_Rec(B_GetNext,Fnum2,KeyPath2,KeyS2);


        end; {Loop..}

        With LInv do
        If (SSDProcess='T') then
        Begin
          TriVal:=TriVal + ThisTransTotal;
        end
        else
          GoodsTotal := GoodsTotal + ThisTransTotal;


      end;{If In Range }



      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

    end; {While..}


    Scan_4ECSales := GoodsTotal;
  end; {With..}

end; {Func..}





Procedure TECVATReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    Case ReportMode of
      EC_VAT_REPORT_MODE, EC_SALES_REPORT_MODE:
        SendRepDrillDown(1,TotTabs,1,LCust.CustCode,CustF,CustCodeK,0);


    end; {Case..}
  end; {With..}
end;

Procedure TECVATReport.PrintReportLine;


Var
  CrDr       :  DrCrType;

  Rnum       :  Real;

  TBo        :  Boolean;

  Cntry      :  Str5;

  Reg        :  Str30;

  GenStr,
  GenVATMask :  Str255;

  TriInd     :  Char;
  TriIndText :  Str255;


Begin
  If (CurrentCountry<>IECCode) then
    GenVATMask:=' ###,###,##0.00 ;(###,###,##0.00)'
  else
    GenVATMask:=GenRealMask;


  Cntry:='';

  Reg:='';

  GenStr:='';

  TriInd:=#32;

  With RepFiler1,MTExLocal^,CRepParam^ do
  Begin

    SetReportDrillDown(0);

    Case ReportMode of
      EC_VAT_REPORT_MODE:
         With LCust do
            Begin
              If (PrintTri) then
              begin
                TriInd:='2';
//                GoodsTot:=Round_Up(TriTot,0);
                GoodsTot:=Trunc(TriTot);
              end
              else
//                GoodsTot:=Round_Up(GoodsTot,0);
                GoodsTot:=Trunc(GoodsTot);

              If (CurrentCountry<>IECCode) then
              Begin
                Cntry:=Copy(VATRegNo,1,2);
                Reg:=Copy(VATRegNo,3,Length(VATRegNo)-2);
              end
              else
              Begin
                Cntry:='';
                Reg:=VATRegNo;

                If (PrintTri) then
                  TriInd:='T';
              end;

              // MH 13/01/2016 2016-R1 ABSEXCH-17144: Print To XLSX - need a combined set of tabs that works for both sections
              If (RDevRec.fePrintMethod = 5 {XLSX}) And (CurrentCountry = IECCode) Then
                // Excel / EIRE
                SendLine(#9 + Form_Int(VLineNo,0) + #9 + Reg + #9 + FormatFloat(GenVATMask,GoodsTot) + #9 + TriInd)
              Else
                SendLine(ConCat(#9,Form_Int(VLineNo,0),
                                #9,Cntry,
                                #9,Reg,
                                #9,FormatFloat(GenVATMask,GoodsTot),
                                #9,TriInd));

              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;
            end;

      EC_SALES_REPORT_MODE:
        with LCust do
        begin
          if (PrintTri) then
          begin
            TriInd := '2';
            TriIndText := 'Triangulated Goods (2)';
{
            GoodsTot := Round_Up(CustTotals.TriangulatedGoods +
                                 CustTotals.TriangulatedServices,
                                 0);
}
            GoodsTot := Trunc(CustTotals.TriangulatedGoods +
                              CustTotals.TriangulatedServices);
          end
          else if (PrintServices) then
          begin
            TriInd := '3';
            TriIndText := 'Services (3)';
//            GoodsTot := Round_Up(CustTotals.Services, 0);
            GoodsTot := Trunc(CustTotals.Services);
          end
          else
          begin
            TriInd := ' ';
            TriIndText := 'Goods';
//            GoodsTot := Round_Up(CustTotals.Goods, 0);
            GoodsTot := Trunc(CustTotals.Goods);
          end;

          If (CurrentCountry<>IECCode) then
          Begin
            Cntry := Copy(VATRegNo, 1, 2);
            Reg := Copy(VATRegNo, 3, Length(VATRegNo) - 2);
          end
          else
          Begin
            Cntry := '';
            Reg := VATRegNo;
            If (PrintTri) then
            begin
              TriInd := 'T';
              TriIndText := 'T';
            end
            else
            if PrintServices then
            begin
              TriInd := 'S';
              TriIndText := 'S';
            end;
          end;

          // MH 13/01/2016 2016-R1 ABSEXCH-17144: Print To XLSX - need a combined set of tabs that works for both sections
          If (RDevRec.fePrintMethod = 5 {XLSX}) And (CurrentCountry = IECCode) Then
            // Excel / EIRE
            SendLine(#9 + Form_Int(VLineNo, 0) + #9 + Reg + #9 + FormatFloat(GenVATMask, GoodsTot) + #9 + TriInd)
          Else
            SendLine(ConCat(#9, Form_Int(VLineNo, 0),
                            #9, Cntry,
                            #9, Reg,
                            #9, FormatFloat(GenVATMask, GoodsTot),
                            #9, TriInd));

          // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
          Self.CRLF;
        end;
    end; {Case..}
  end; {With(s)..}
end;


{ ================ Print VAT Declaration ============ }


Procedure TECVATReport.PrintECDecl;



Begin

  With RepFiler1,CRepParam^ do
  Begin


    DefLine(-1,MarginLeft,PageWidth-MarginRight-1,0);

    DefFont(0,[fsBold]);

    If (CurrentCountry<>IECCode) then
    Begin
      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.PrintLeft(ConCat('Number',' ','of',' ','pages',' ','completed:',' ',Form_Int(TotPages,7),
              Spc(5),'Lines',' ','completed',' ','(this',' ','page',' ','only):',' ',Form_Int(VLineNo,2)),MarginLeft);
      Self.CRLF;


      DefFont(0,[]);

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;
      Self.PrintLeft(Concat('Declaration: You, or someone on your behalf, must sign below.'),MarginLeft);
      Self.CRLF;
      Self.CRLF;
      Self.PrintLeft(Concat('I, ',ConstStr('.',130),' declare that the'),MarginLeft);
      Self.CRLF;

      DefFont(-2,[]);
      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.PrintLeft(ConCat(Spc(70),'(Full name of signatory in BLOCK LETTERS)'),MarginLeft);
      Self.CRLF;

      DefFont(0,[]);
      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.PrintLeft(Concat('information given above and on any continuation sheets is true and complete.'),MarginLeft);
      Self.CRLF;
      Self.CRLF;
      Self.PrintLeft(Concat('Signature ',ConstStr('.',100),' ',InvFullDate(Today)),MarginLeft);
      Self.CRLF;

      DefFont(0,[fsBold]);
      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.PrintCenter(Concat('A false declaration can result in prosecution'),PageWidth/2);
      Self.CRLF;
      Self.CRLF;

      DefLine(-2,MarginLeft,PageWidth-MarginRight-1,-1);
      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.PrintLeft(Concat('Could you please supply a'),MarginLeft);
      Self.CRLF;
      Self.CRLF;
      Self.PrintLeft(Concat('Contact Name : ',ConstStr('.',75),' Tel No. : ',ConstStr('.',50)),MarginLeft);
      Self.CRLF;

      DefFont(0,[]);
    end
    else
    Begin
      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.PrintLeft(ConCat('I',' ','declare',' ','that',' ','the',' ','information',' ','given',' ','in',' ','this',
                  ' ','statement',' ','is',' ','true',' ','and',' ','complete'),MarginLeft);
      Self.CRLF;

      ClearTabs;

      SetTab (MarginLeft, pjLeft, 130, 4, 0, 0);
      SetTab (NA, pjLeft, 60, 4, 0, 0);

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;

      DefFont(0,[]);

      SendLine(ConCat(#9,'Signature',#9,'Date'));

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;

      SendLine(ConCat(#9,#9,InvFullDate(Today)));

      DefLine(-1,TabStart(1),TabEnd(1),0);

      ClearTabs;

      SetTab (MarginLeft, pjLeft, 110, 4, 0, 0);
      SetTab (NA, pjLeft, 50, 4, 0, 0);
      SetTab (NA, pjLeft, 50, 4, 0, 0);

      SendLine(ConCat(#9,'Full',' ','Name',' ','of',' ','Signatory',#9,'Telephone',' ','No.',#9,
                         'Fax',' ','No.'));

      DefFont(0,[fsBold]);

      SendLine(ConCat(#9,VSIG,#9,Syss.DetailTel,#9,Syss.DetailFax));

      DefFont(0,[]);

    end;

  end; {With..}

end; {Proc..}




{ ================ Print VAT Declaration Cont ============ }


Procedure TECVATReport.PrintECContDecl;



Begin

  With CRepParam^,RepFiler1 do
  Begin
    DefLine(-2,MarginLeft,PageWidth-MarginRight-1,-1);
    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    DefFont(0,[fsBold]);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.PrintLeft(ConCat(Spc(38),'Lines',' ','completed',' ','(this',' ','page',' ','only):',' ',
                 Form_Int(VLineNo,4)),MarginLeft);
    Self.CRLF;


    DefFont(0,[]);


  end; {With..}

end; {Proc..}



{ ======================= VAT End ======================= }


Procedure TECVATReport.PrintEndPage;

Var
  TmpRepMode  :  Integer;

Begin
  With RepFiler1,CRepParam^ do
  Begin
    If (CurrentPage=1) then
      PrintEcDecl
    else
      PrintEcContDecl;

    VLineNo:=0;
  end; {With..}
end;


{ ======================= VAT Include ======================= }


Function TECVATReport.IncludeRecord :  Boolean;

Var
  TmpInclude :  Boolean;
  Services : Double;

Begin

  {$B-}

  With MTExLocal^,CRepParam^ do
  Begin
    Case ReportMode of
      EC_VAT_REPORT_MODE:
           With LCust do
              Begin

                TmpInclude:=((EECMember) and (IsACust(CustSupp)));

                If (TmpInclude)  then
                Begin

                  GoodsTot:=Scan_4ECSales(CustCode,CustSupp,VATStartD,VATEndD,TriTot, Services);

                  TmpInclude:=(GoodsTot+TriTot + Services<>0);

                end;

              end;
      EC_SALES_REPORT_MODE:
        with LCust do
        begin
          TmpInclude := ((EECMember) and (IsACust(CustSupp)));
          if (TmpInclude)  then
            TmpInclude := Calc_ECSales(CustCode, VATStartD, VATEndD, CustTotals);
        end;
      else  //PR: 23/03/2016 v2016 R2 ABSEXCH-17390
        raise Exception.Create('Invalid ReportMode in TECVATReport.IncludeRecord: ' + IntToStr(ReportMode));

    end; {Case..}
  end; {With..}

    {$B+}

  Result:=TmpInclude;
end; {Func..}



{ ==== Proc to Scan all customers and check ==== }


Procedure TECVATReport.Count_LinePage;



Const
  Fnum     =  CustF;
  Keypath  =  CustCntyK;


Var
  KeyCS,
  KeyChk     :  Str255;
  CustTotal: Double;

Begin

  With MTExLocal^,CRepParam^ do
  Begin

    TotLines:=0;

    TotPages:=0;

    KeyChk:=TradeCode[BOn];

    KeyCS:=KeyChk;

    ShowStatus(2,'Please Wait... Collecting Totals');

    //PR: 06/02/2017 ABSEXCH-18189 / ABSEXCH-18302
    if UseSQLPrefillCache then
      UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

    While (LStatusOk) and (ChkRepAbort) and (Checkkey(KeyChk,KeyCS,Length(KeyChk),BOn)) do
    Begin

      If (IncludeRecord) then
      Begin
        if (ReportMode = EC_SALES_REPORT_MODE) then
        begin
          CustTotal := CustTotals.Goods + CustTotals.TriangulatedGoods +
                       CustTotals.Services + CustTotals.TriangulatedServices;
          RepTot    := RepTot + CustTotal;
          //PR: 19/02/2014 ABSEXCH-15042 Increment Totlines for goods and for services for customer (Ireland only
          //                             so existing report isn't affected.)
          if CurrentCountry<>IECCode then
            TotLines  := TotLines + Ord(CustTotal <> 0.0)
          else
          begin
            if CustTotals.Goods <> 0.0 then
              Inc(TotLines);
            if CustTotals.Services <> 0.0 then
              Inc(TotLines);
          end;
        end
        else
        begin
          TotLines := TotLines + (Ord(GoodsTot <> 0.0)+Ord(TriTot <> 0.0));
          RepTot   := RepTot + (GoodsTot + TriTot);
        end;
      end;

      //PR: 06/02/2017 ABSEXCH-18189 / ABSEXCH-18302
      if UseSQLPrefillCache then
        UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

    end; {While..}

    TotPages:=Trunc(DivWChk(TotLines,Linepp));

    If (TotPages<1) then
      TotPages:=1;

  end; {with..}

end; {Proc..}







{ ====== Update EC Sales List ====== }

Procedure TECVATReport.Update_ECSales(LastDate  :  LongDate);

Var
  Locked  :  Boolean;

Begin

  Locked:=BOn;



  If (GetMultiSys(BOn,Locked,VATR)) and (Locked) then
  Begin

    SyssVAT.VATRates.LastECSalesDate:=LastDate;

    PutMultiSys(VATR,BOn);

  end;

end; {Proc..}




Procedure TECVATReport.RepPrint(Sender  :  TObject);

Var

  m            :  Byte;

  Loop,
  VFirstPage   :  Boolean;
  IncludeLine: Boolean;

  procedure PrintNextLine;
  begin
    with CRepParam^ do
    begin
      if (VLineNo = 0) and (not VFirstPage) then
        ThrowNewPage(-1);

      Inc(VLineNo);

      PrintReportLine;

      If (VLineNo = Linepp) then
      Begin
        PrintEndPage;
        VFirstPage := BOff;
      end;
    end;
  end;

Begin
  VFirstPage:=BOn;

  With MTExLocal^,CRepParam^,RepFiler1 do
  Begin

    RepLen:=Length(RepKey);

    KeyS:=RepKey;


    ShowStatus(2,'Processing Report.');

    If (TotLines>0) then
    Begin

      VLineno:=0;

      //PR: 06/02/2017 ABSEXCH-18189 / ABSEXCH-18302
      if UseSQLPrefillCache then
        UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);

      LStatus:=LFind_Rec(B_GetGEq,RFnum,RKeyPath,KeyS);

      If (Assigned(ThreadRec)) then
        RepAbort:=ThreadRec^.THAbort;

      While (LStatusOk) and (ChkRepAbort) do
      Begin

        Inc(RCount);

        If (Assigned(ThreadRec)) then
          UpDateProgress(RCount);

        If (LStatusOk) and (Checkkey(RepKey,KeyS,RepLen,BOn)) then
        Begin

          Inc(ICount);

          If (IncludeRecord) then
          Begin

            if (ReportMode = EC_SALES_REPORT_MODE) then
            begin
              // Goods line
              PrintTri := False;
              PrintServices := False;
              if (CustTotals.Goods <> 0.0) then
                PrintNextLine;

              // Triangulated line
              PrintTri := True;
              if ((CustTotals.TriangulatedGoods + CustTotals.TriangulatedServices) <> 0.0) then
                PrintNextLine;

              // Services line
              PrintTri := False;
              PrintServices := True;
              if (CustTotals.Services <> 0.0) then
                PrintNextLine;
            end
            else
            begin
              Loop:=BOff;

              Repeat

                If ((Not Loop) and (GoodsTot<>0.0)) or ((Loop) and (TriTot<>0.0)) then
                Begin

                  If (VLineNo=0) and (Not VFirstPage) then
                    ThrowNewPage(-1);

                  Inc(VLineNo);

                  PrintTri:=Loop;

                  PrintReportLine;

                  If (VLineNo=Linepp) then
                  Begin
                    PrintEndPage;
                    VFirstPage:=BOff;
                  end;
                end;

                Loop:=Not Loop;

              Until (Not Loop) or (Not ChkRepAbort);
            end;

          end;
        end
        else
        Begin

          If (VLineNo>0) then
          Begin

            For m:=1 to (Linepp-VLineNo) do
            Begin

              SendLine(ConCat(#9,Form_Int(m+VLineNo,0)));
              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;
            end;

            PrintEndPage;

          end;

          RepAbort:=BOn;

        end;

        //PR: 06/02/2017 ABSEXCH-18189 / ABSEXCH-18302
        if UseSQLPrefillCache then
          UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);

        LStatus:=LFind_Rec(B_GetNext,RFnum,RKeyPath,KeyS);


        If (Assigned(ThreadRec)) then
          RepAbort:=ThreadRec^.THAbort;

      end; {While..}


    end; {No Lines to print..}

  end; {With..}


end;



Function TECVATReport.GetReportInput  :  Boolean;


Begin
  With CRepParam^ do
  Begin

    ThTitle:='EC Sales List';

    RepTitle:='VAT - EC Sales List';

    {RepCtrl^.AbortPrint:=Inp_ECSalesReport(VATStartD,VATEndD,HedTit);}

    // CJS 2014-09-11 - ABSEXCH-15508 - title missing from VIES Statement
    if (ReportMode <> EC_SALES_REPORT_MODE) or (CurrentCountry = IECCode) then
    begin
      If (CurrentCountry<>IECCode) then
        PageTitle:='Value Added Tax EC Sales list, for the period '+PoutDate(VATStartD)+' To '+PoutDate(VATEndD)
      else
        PageTitle:='VIES STATEMENT, for the period '+PoutDate(VATStartD)+' To '+PoutDate(VATEndD);
    end;

    Calc_Q4(VATStartD,QNo,QYr);

    Linepp:=15;

    RFnum:=CustF;

    If (CurrentCountry<>IECCode) then
      RFont.Size:=12
    else
      RFont.Size:=9;

    RKeyPath:=CustCntyK;

    RepKey:=Tradecode[BOn];

  end; {With..}

  Result:=BOn;
end;


{ EC Sales Report functions }

function TECVATReport.Calc_ECSales(CustCode: Str10; SDate, EDate: LongDate;
  var Totals: TECTotals): Boolean;
var
  HasGoods, HasServices: Boolean;
begin
  Totals.Goods := 0.0;
  Totals.TriangulatedGoods := 0.0;
  Totals.TriangulatedServices := 0.0;
  Totals.Services := 0.0;
  HasGoods    := False;
  HasServices := False;
  if IncludeGoods then
    HasGoods := CalcGoodsTotals(CustCode, SDate, EDate, Totals);
  if IncludeServices then
    HasServices := CalcServiceTotals(CustCode, SDate, EDate, Totals);
  Result := (HasGoods or HasServices);
end;

function TECVATReport.CalcGoodsTotals(CustCode: Str10; SDate, EDate: LongDate;
  var Totals: TECTotals): Boolean;
const
  Fnum     =  InvF;
  Keypath  =  InvCustK;
  Fnum2    =  IdetailF;
  Keypath2 =  IdFolioK;
var
  InvKey,
  BaseInvKey,
  IdKey,
  BaseIdKey, KeyString :  Str255;
  Rnum: Real;
  ExclusionFolioNumber: Integer;
begin
  Result := False;
  ExclusionFolioNumber := -1;
  BaseInvKey := FullCustCode(CustCode);
  InvKey  := BaseInvKey;

  with MTExLocal^ do
  begin
    LStatus := LFind_Rec(B_GetGEq, InvF, InvCustK, InvKey);
    while (LStatusOk) and (Checkkey(BaseInvKey, InvKey, Length(BaseInvKey), BOn)) do
    with LInv do
    begin
      If (IncludeECInv(LInv, SDate, EDate)) then
      Begin
        BaseIdKey := FullNomKey(FolioNum);
        IdKey   := FullIdKey(FolioNum, 1);

        LStatus := LFind_Rec(B_GetGEq, IdetailF, IdFolioK, IdKey);

        while (LStatusOk) and (Checkkey(BaseIdKey, IdKey, Length(BaseIdKey), BOn)) do
        with LId do
        begin
          //PR: 23/12/2009 At MR's request, added check for Vat Code 4.
          if (LineNo > 0) and (VATCode in [VATECDCode, '4']) and (not ECService) then
//          if (LineNo > 0) and (VATCode = VATECDCode) and (not ECService) then
          begin

            //GS 20/03/2012 ABSEXCH-10130: check to exclude transaction lines lines from exploded BoM
            if (ExclusionFolioNumber <> LId.KitLink) then
            begin

              Rnum := DetLTotal(LId, BOn, BOff, 0.0) * DocNotCnst;
              if (Rnum = 0) then
              begin
                // Free-of-charge items should be reported at total Cost Price.
                Rnum := (CostPrice * Qty) * LineCnst(Payment) * DocNotCnst;
              end;//end if

              Rnum := Round_Up(Conv_VATCurr(Rnum,
                                            VATCrate[UseCoDayRate],
                                            XRate(OrigRates, BOff, Currency),
                                            Currency,
                                            UseORate),
                                2);

              if (Rnum <> 0) then
              begin

                //GS 20/03/2012 ABSEXCH-10130: we have identified this TX line as having a value;
                //now we want to find out if this line is a BoM that exposes its kit lines (Exploded BoM),
                //to find out, get the stock record for this TX line

                KeyString :=  FullStockCode(LID.StockCode);
                LStatus := MTExLocal^.LFind_Rec(B_GetEq, StockF, StkCodeK, KeyString);

                //examine the stock record, if we managed to retrieve it
                if (LStatus = 0) then
                begin
                  //is this stock item a BoM, that shows its kit lines?
                  if (LStock.ShowAsKit = True) then
                  begin
                    //if so, we need to exclude these kit lines!
                    //to do this, we can match the exploded BOM lines to this BOM by examining their 'KitLink' value,
                    //if it matches the exploded BoM's folio number value, exclude it!
                    ExclusionFolioNumber := LStock.StockFolio;
                  end;//end if
                end;//end if

                Result := True;
                if (SSDProcess = 'T') then
                  Totals.TriangulatedGoods := Totals.TriangulatedGoods + Rnum
                else
                  Totals.Goods := Totals.Goods + Rnum;
              end;
            end;//end if (exclude FoC exploded BoM line check)

          end;
          LStatus := LFind_Rec(B_GetNext, IdetailF, IdFolioK, IdKey);
        end;

      end;
      LStatus := LFind_Rec(B_GetNext, InvF, InvCustK, InvKey);
    end;
  end;
end;

function TECVATReport.CalcServiceTotals(CustCode: Str10; SDate, EDate: LongDate;
  var Totals: TECTotals): Boolean;

  function ServiceProRata(LineTotal: Double): Double;
  {
    If the date range specified by the user includes the completion date, or is
    for the last period of the year and the service continues into the following
    year, then the pro-rata amount for the transaction line details will be
    calculated and returned.

              Service Data Range Scenarios
              ----------------------------
              Year:    2009    ¦ 2010                    ¦ 2011
              Month:   S O N D ¦ J F M A M J J A S O N D ¦ J F M A M
               1.              ¦   |-------|             ¦
               2.          |---¦---------------|         ¦
               3.        |-----¦-------------------------¦-----|
               4.              ¦             |-----------¦-------|
  }
  var
    StartOfYear, EndOfYear: LongDate;
    Include: Boolean;
    ServiceDays, ReportDays: Integer;
    DayRate: Double;
    IsContinuation: Boolean;
//    IsLast: Boolean;
  begin
    Result := 0.0;
    Include := False;
    IsContinuation := False;
//    IsLast := False;
    with MTExLocal^ do
    begin
      ServiceDays := NoDays(LId.ServiceStartDate, LId.ServiceEndDate) + 1;
      ReportDays  := 0;
      StartOfYear := StrDate(Part_Date('Y', SDate), 1, 1);
      EndOfYear := StrDate(Part_Date('Y', SDate), 12, 31);
      IsContinuation := (LId.ServiceStartDate < StartOfYear);
      { Does the Service start before the end of the date range? }
      if (LId.ServiceStartDate <= EDate) then
      begin
        { Does the Service end date fall within the report range and
          within the current year? If so we report the complete Service amount.
          (Scenario 1) }
        if ((LId.ServiceEndDate >= SDate) and (LId.ServiceEndDate <= EDate)) and
           ((LId.ServiceStartDate >= StartOfYear) and (LId.ServiceEndDate <= EndOfYear)) then
        begin
          Include := True;
        end
        { Otherwise, does it end next year, and does the report cover the last
          period of the year? If so, we report the Service amount from either
          the start of the Service, if it began this year (Scenario 4), or from
          the start of the year, if it began in the previous year (Scenario 3). }
        else if (Part_Date('Y', LId.ServiceEndDate) > Part_Date('Y', EndOfYear)) and
                (SDate <= EndOfYear) and (EDate >= EndOfYear) then
        begin
          Include := True;
          if (Part_Date('Y', LId.ServiceStartDate) < Part_Date('Y', StartOfYear)) then
            ReportDays := NoDays(StartOfYear, EndOfYear) + 1
          else
            ReportDays := NoDays(LId.ServiceStartDate, EndOfYear) + 1;
          IsContinuation := True;
        end
        { Otherwise, does the Service end between the start and end of the
          report range? If so, we report the Service amount from the start of
          the year, as it must have begun in the previous year (Scenario 2). }
        else if ((LId.ServiceEndDate >= SDate) and (LId.ServiceEndDate <= EDate)) then
        begin
          Include := True;
//          IsLast := True;
          ReportDays := NoDays(StartOfYear, LId.ServiceEndDate) + 1;
        end;
      end;
      if Include then
      begin
        Result := Round_Up(Conv_VATCurr(LineTotal, LInv.VATCrate[UseCoDayRate],
                                        XRate(LInv.OrigRates, BOff, LId.Currency),
                                        LId.Currency, LInv.UseORate), 2);
        if (ReportDays > 0) then
        begin
          DayRate := Result / ServiceDays;
{
          if (IsContinuation and IsLast) then
          begin
            Result := Result - Trunc((DayRate * (ServiceDays - ReportDays)));
          end
          else
}
            Result := DayRate * ReportDays;
          if IsContinuation and UpdateECServiceTax then
          begin
//            LId.ECSalesTaxReported := Round_Up(Result, 0);
            LId.ECSalesTaxReported := Trunc(Result);
            LPut_Rec(IdetailF, IdServiceK);
          end;
        end;
      end;
    end;
  end;

var
  Key, BaseKey: Str255;
  InvKey: Str255;
  FuncRes: Integer;
  LineTotal: Double;
begin
  Result := False;
  Key := FullCustCode(CustCode);
  BaseKey := Key;
  with MTExLocal^ do
  begin
    LStatus := LFind_Rec(B_GetGEq, IdetailF, IdServiceK, Key);
    while (LStatusOk) and (Checkkey(BaseKey, Key, Length(BaseKey), BOn)) do
    begin
       //PR: 23/12/2009 At MR's request, added check for Vat Code 4.
      if (LId.FolioRef <> 0) and (LId.LineNo > 0) and (LId.VATCode in [VATECDCode, '4']) then
//      if (LId.FolioRef <> 0) and (LId.LineNo > 0) and (LId.VATCode = VATECDCode) then
      begin
        LineTotal := DetLTotal(LId, BOn, BOff, 0.0) * DocNotCnst;
        if (LineTotal = 0) then
          // Free-of-charge items should be reported at total Cost Price.
          LineTotal := (LId.CostPrice * LId.Qty) * LineCnst(LID.Payment) * DocNotCnst;
        if (LineTotal <> 0) then
        begin
          { Locate the Transaction Header (if we are not already on it), because
            we need details from it in order to calculate the Transaction Line
            totals. }
          if (LId.FolioRef <> LInv.FolioNum) then
          begin
            InvKey := FullNomKey(LId.FolioRef);
            LStatus := LFind_Rec(B_GetEq, InvF, InvFolioK, InvKey);
            if not LStatusOK then
              { This should never happen unless data is corrupted. }
              raise Exception.Create('Failed to find Transaction ' + LId.DocPRef);
          end;
          if (not (LInv.InvDocHed In QuotesSet+RecieptSet+PSOPSet)) and
             (LInv.RunNo>=0) then
          begin
            LineTotal := ServiceProRata(LineTotal);
            if (LineTotal <> 0.0) then
            begin
              Result := True;
              if (LInv.SSDProcess = 'T') then
                Totals.TriangulatedServices := Totals.TriangulatedServices + LineTotal
              else
                Totals.Services := Totals.Services + LineTotal;
            end;
          end;
        end;
      end;
      LStatus := LFind_Rec(B_GetNext, IdetailF, IdServiceK, Key);
    end;
  end;
end;

Procedure TECVATReport.Finish;


Begin

  Inherited Finish;

  With CRepParam^ do
//    If (ChkRepAbort) then
//      Update_ECSales(VATEndD); { ***** Switch this on when date range is ok *** }
      Update_ECSales(VATStartD); { ***** Switch this on when date range is ok *** }

end;


{ ======== }




Procedure AddECVATRep2Thread(LMode    :  Byte;
                             IRepParam:  CVATRepPtr;
                             AOwner   :  TObject;
                             IncludeGoods: Boolean;
                             IncludeServices: Boolean;
                             Title: string;
                             UpdateServiceTax: Boolean);


Var
  EntTest  :  ^TECVATReport;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      EntTest^.IncludeGoods := IncludeGoods;
      EntTest^.IncludeServices := IncludeServices;
      EntTest^.PageTitle := Title;
      EntTest^.UpdateECServiceTax := UpdateServiceTax;
      With EntTest^ do
      Begin
        ReportMode:=EC_SALES_REPORT_MODE;

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





//PR: 06/02/2017 ABSEXCH-18189 / ABSEXCH-18302 Use a prefill cache to avoid emulator problem with
// index
procedure TECVATReport.InitialiseSQLCache;
var
  Res : Integer;
begin
  SQLColumns := ''; //Return all columns to avoid mistakes
  SQLWhereClause := 'acCustSupp = ' + QuotedStr('C') + ' AND ' +
                    'acECMember = 1 AND ' +
                    'acVATRegNo <> ''''';

  Res := CreateCustomPrefillCache(SetDrive+FileNames[CustF], SQLWhereClause, SQLColumns, SQLPrefillCacheID, MTExLocal^.ExClientId);
  if Res = 0 then
    UseSQLPrefillCache := True;
end;

Initialization



Finalization

end.