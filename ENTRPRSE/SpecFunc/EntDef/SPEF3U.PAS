unit SpeF3U;

{**************************************************************}
{                                                              }
{        ====----> E X C H E Q U E R Translate <----===        }
{                                                              }
{                      Created : 19/05/2000                    }
{                                                              }
{                                                              }
{                     Common Overlaid Unit                     }
{                                                              }
{               Copyright (C) 2000 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}

interface

uses
  GlobVar,
  VarConst,
  SFHeaderU,
  ProgU;


function Get_SFMode(Mode  :  Integer)  :  Str80;

procedure Special_Function(  Mode     :  Integer;
                            ProgBar  :  TSFProgressBar);

const
  //PR: 07/03/2012 ABSEXCH-12034 Updated from 127 to 128
  //PR: 08/03/2012 ABSEXCH-11640 Updated from 128 to 129
  //AP: 14/02/2017 2017-R1 ABSEXCH-15554 Updated to 164
  //AP 05/06/2018 2018R2 ABSEXCH-20310 Updated to 167
  TotSFFunc  =  167;
  SFEntInclude  :  set of Byte = [1..8,12,14,16,17,20,22..24,26,39,41..43,44,48..50,
   51,53,54,57,59,62..64,66,67,71,74,76,77..115,116,118,121..136,147,148,149,151,154,157..163,164, 165, 166, 167];

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
implementation
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses
     Windows,
     SysUtils,
     Messages,
     Controls,
     Dialogs,
     Forms,
     ETStrU,
     ETDateU,
     ETMiscU,
     VarRec2U,
     BtrvU2,
     UnTils,
     Rebuld1U,
     ReBuld2U,
     ReBuildU,
     SpeF4U,
     SpeF5U,
     PF2MC1U,
     TriEuroF,
     SetLocF,
     SetAcF,
     SetStkF,
     SetDecF,
     SetDateRangeF,
     SetFolioF;

{ === Routine to Control the execution of Special functions === }
function Get_SFMode(Mode: Integer): Str80;
const
  SFTitle: Array[1..TotSFFunc] of Str80 =
   {01} ('Repair damaged Documents',
   {02}  'Convert all unposted currency 0 documents to currency 1',
   {03}  'Remove all matching information',
   {04}  'Create missing document header records',
   {05}  'Sort transaction lines after rebuild',
   {06}  'Sort transactions after rebuild',
   {07}  'Sort transactions and lines after rebuild',
   {08}  'Set stock reorder price same as cost price',
   {09}  'Set cost price to 0 on all transactions',
   {10}  'Remove unposted run-time lines',
   {11}  'Stock Code and Group clean up',
   {12}  'Return O/S Orders from History',
   {13}  'Set Cust Payterms & Fix Re-Order List (Origin)',
   {14}  'Set all unposted trans daily rate to Co.Rate. MC only!',
   {15}  'Copy "Remit To" code into "Invoice To" code',
   {16}  'Reset lost transaction line Posting Run numbers',
   {17}  'Set all Customer Accounts to Print Statements',
   {18}  'Set Min Reorder level on all Location Stock Records',
   {19}  'Reset Revaluation effect for Unposted Transactions',
   {20}  'Reset currency 1 settled value (MC only)',
   {21}  'Auto Rename Suppliers/notes/transactions',
   {22}  'Reset Historical Orders',
   {23}  'Check for corrupted transactions',
   {24}  'Delete corrupted transactions',
   {25}  'Delete all Account Notes',
   {26}  'Set Alternative Stock Codes from Stock records',
   {27}  'Set all unposted journals to have period matching date',
   {28}  'Set All O/S order next delivery Date',
   {29}  'Swap SOR<150k Your Ref with Long YourRef (Bentley)',
   {30}  'Convert All SQU to negative (Bentley)',
   {31}  'Set SOR/SDN Settlement discount from Trade Terms1 (Bentley)',
   {32}  'Set SRI/SRF Cost from Stock (Bentley)',
   {33}  'Set SQU Nomcodes from Stock (Bentley)',
   {35}  'Set Customer PayTerms to 40 Days (Bentley)',
   {35}  'Set Location reorder price (Bentley)',
   {36}  'Set Customer Invoice to account (Bentley)',
   {37}  'Set unposted Sales Invoice due date from Account',
   {38}  'Set SQU Loc Code to 003. (Bentley)',
   {39}  'Single to multi currency conversion.',
   {40}  'Delete unposted SJI1-SJI14031 (Palladium).',
   {41}  'Set Transaction Settled & Daily Rate. (MC only)',
   {42}  'Pad 2 digit location codes to 3 digits (SPOP only)',
   {43}  'Set A/C default Tax 3&4 codes to A&D. Set Stock 3&4 to S.',
   {44}  'Set Unposted Transaction Ctrl G/L from Account record',
   {45}  'Convert Auto Bank Rec to currency 1',
   {46}  'Re-establish Account link on JC Actuals',
   {47}  'Blank Timesheet Account codes',
   {48}  'Remove all Customer matching information',
   {49}  'Remove all Supplier matching information',
   {50}  'Unallocate all Sales Trans. + matching information',
   {51}  'Unallocate all Purch Trans. + matching information',
   {52}  'Convert Manual Settlement Discount (Bentley)',
   {53}  'Remove Protected Mode Posting Warnings',
   {54}  'Set Pre-triangulation Transactions',
   {55}  'Set Cust Settlement Discount from S-Setup',
   {56}  'Set Supp Settlement Discount from S-Setup',
   {57}  'Set Sales DBk Cost from Stock Records (Zero Cost)',
   {58}  'Reset Triangulation Flag on S No/FIFO Recs',
   {59}  'Clean Corrupted OurRef',
   {60}  'Repair Damaged Account Ledger Filter',
   {61}  'Remove Damaged Serial Number Notes',
   {62}  'Set ALL PIN & PCR Transactions to Authorised.',
   {63}  'Reset Last Debt Chase Letter Level on Transactions.',
   {64}  'Correct unposted trans after Triangulation applied.',
   {65}  'Reset Advance Corrupt SRC006081.',
   {66}  'Clean Corrupted Reconcile Flag',
   {67}  'Set Sales DBk Cost from Stock Records All Stk Lines',
   {68}  'Convert UK STD Telephone Codes for April 2000',
   {69}  'Recalculate all Sales Invoice Cost values',
   {70}  'Zero all Purchase Uplift',
   {71}  'Set ALL Blank Stk Loc Trans Lines',
   {72}  'Delete all unposted blank transactions prior to last purge',
   {73}  'Fix Corrupt Import NOM + ADJ With Job Cost Codes',
   {74}  'Clear hidden BOM lines from historical Orders',
   {75}  'Set ADJ BOM Line Cost from Stock (Ora)',
   {76}  'Set Send Email Reader on all customer records',
   {77}  'Set Send Email Reader on all supplier records',
   {78}  'Reset Employee Certificate Expiry Date',
   {79}  'Recalculate all O/S Sales Order Cost Values.',
   {80}  'Set Unposted Sales BOM Line Cost to zero (Bentley)',
   {81}  'Set Include on Web on all customer records',
   {82}  'Set Include on Web on all supplier records',
   {83}  'Set Include on Web on all stock records',
   {84}  'Repair matching on reversed SPOP Transactions',
   {85}  'Remove corrupted stock lines on SRC/PPY Transactions',
   {86}  'Pad all Transaction YourRef fields to correct duplicate YourRef check',
   {87}  'Reset corrupt Genisys corrupt SIN001402 run number',
   {88}  'Remove JC Actuals if original doc missing.',
   {89}  'v5.00 Exchequer index test to support new allocation routine.',
   {90}  'Destroy purged years history for purged accounts.',
   {91}  'Destroy purged years history for purged stock records.',
   {92}  'Remove all Order matching information for currencies 3 & 8. (For Exchequer use)',
   {93}  'Pad Account, Stock and Transaction Line CC/Dep to 3 digits',
   {94}  'Reset currency 0 settled value (Pro only)',
   {95}  'Reset currency 1 or above settled value (MC only)',
   {96}  'Remove JC Committed lines if original doc missing or effect on JC is nil',
   {97}  'Remove Corrupted Acount & Stock Discount Records',
   {98}  'Remove Corrupted FIFO Records',
   {99}  'Reset sold Batch records still marked as unsold',
  {100}  'Delete Copy/Reverse Audit Note from all transactions',
  {101}  'Reset Allocated Status on all settled Transactions',
  {102}  'Clean Corrupted Line Stock Flag',
  {103}  'Delete ALL Serial/Batch Records',
  {104}  'Repair Corrupted Payment flag on transaction line',
  {105}  'Delete ALL Serial/Batch Records Originated from a POR',
  {106}  'Reset Greencore corrupt SIN61869 Line Date',
  {107}  'Reset Stock Records Note counter to 1',
  {108}  'Reset corrupt Genisys SRC000001',
  {109}  'Delete duplicate Master Location Records',
  {110}  'Delete redundant Bin Child Usage Records',
  {111}  'Delete duplicate Job Category Records',
  {112}  'Delete redundant Bin Master Records',
  {113}  'Reset TeleSales Account Control Records',
  {114}  'Clear corrupt POR lines from historical Purchase Orders',
  {115}  'Return O/S Orders from History, detecting fractional quantities',
  {116}  'Clear corrupt YTD History records from G/L and CC/Dep History',
  {117}  'Reset Variance for Advance corruption',
  {118}  'Delete orphaned xDN lines',
  {119}  'Delete orphaned Transaction Lines (Fission IT Ltd)',
  {120}  'Correct PJI/PJC Run Numbers (Roe Ltd)',
  {121}  'Populate missing Account Codes in Transaction Lines',
  {122}  'Copy Cost of Sales details from Stock records',
  {123}  'Remove zero-valued Stock Location records',
  {124}  'Reset NOMMODE',
  {125}  'Set Folio Number',
  {126}  'Return O/S Works Orders from History',
  {127}  'Move misplaced Sales/Purchase Return transactions',
  {128}  'Delete unposted Works Orders which have no lines',
  {129}  'Delete unposted Works Order Lines which have no header',
  {130}  'Find Transactions with missing lines',
  {131}  'Fix Transactions with missing lines',
  {132}  'Manually fix Transaction Line dates',
  {133}  'Delete orphaned hidden BOM lines (v6.10.1 only)',
  {134}  'Fix corrupted UntilDate fields',
  {135}  'Remove erroneous B2BFolio values',
  {136}  'Copy delivery address line 5 to postcode',
  {137}  '[Not available in this version]',
  {138}  '[Not available in this version]',
  {139}  '[Not available in this version]',
  {140}  '[Not available in this version]',
  {141}  '[Not available in this version]',
  {142}  '[Not available in this version]',
  {143}  '[Not available in this version]',
  {144}  '[Not available in this version]',
  {145}  '[Not available in this version]',
  {146}  '[Not available in this version]',
  {147}  'Remove erroneous Adjustment Lines',
  {148}  'Purge legacy Credit Card details',
  {149}  'Set Country Code',
  {150}  '[Not available in this version]',
  {151}  'Populate country code on account contacts',
  {152}  '[Not available in this version]',
  {153}  '[Not available in this version]',
  {154}  'Remove tabs from transaction line descriptions',
  {155}  '[Not available in this version]',
  {156}  '[Not available in this version]',
  {157}  'Reorder transactions, for Exchequer 2016 R2 (SQL only)',
  {158}  'Update Transaction Delivery Address Country Codes',
  {159}  'Clean System Setup Record',
  {160}  'Clear Intrastat details from Transactions and Traders',
  {161}  'Move VAT Submission to correct company (Forestry Investment)',
  {162}  'Delete redundant control lines (Crane Asia)',
  {163}  'Delete invalid history records for SQUA01',
  {164}  'Update Transaction Line OurRef',
  {165}  'Set posted PIN header run number to match lines',
  {166}  'Fix transactions with doubled up settled amounts',
  {167}  'Reset Zero folio number on transactions'
        );
begin
  if (Mode <= TotSFFunc) then
    Get_SFMode := SFTitle[Mode]
  else
    Get_SFMode := SFTitle[4];
end;

{ ====== Procedure to Scan all detail lines beloning to a doc ====== }
procedure Change_Details(Mode  :  Integer;
                     var RunOk :  Boolean;
                         ProgBar
                               :  TSFProgressBar);
const
  Fnum      =  IdetailF;
  Keypath   =  IdFolioK;
var
  KeyS,
  KeyChk  :  Str255;
begin

  KeyChk:=FullNomKey(Inv.FolioNum);

  KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGeq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
  With Id do
  Begin

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));

    Case Mode of

      2  :  Begin
              Currency:=Inv.Currency;
              CXrate:=Inv.CXRate;
            end;
     14  :  Begin
              CXrate:=Inv.CXRate;
            end;
    end; {Case..}

    Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

    If (Not StatusOk) then
    Begin
      Write_FixLogFmt(FNum,'Unable to write data to temporary file, report error '+Form_Int(Status,0),4);
    end;

    RunOk:=(RunOk and (Status In [0,5]));

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}

end; {Proc..}

{ ========== Procedure to Fix Document Header ========= }
Procedure SF_DocHead(Mode  :  Integer;
                 Var TotalCount,
                     LCount:  LongInt;
                 Var RunOk :  Boolean;
                     ProgBar
                           :  TSFProgressBar);



Const
  Fnum     =  InvF;
  Keypath  =  InvOurRefK;


Var

  KeyS     :  Str255;

  NAByte,
  OldPr,
  OldYr    :  Byte;

  LOk,
  StoreRec,
  ChangeDet,
  SysOk,
  FixAcc,
  FixRunNo,
  FixPr,
  FixDate,
  FixDDate,
  FixNA,
  FixCurr,
  ThinkMC,
  FixCSupp :  Boolean;

  OldDate,
  OldDDate :  Str255;

  ShouldSupp
           :  Char;

  OldNo    :  Str10;



Begin

  SysOk:=BOff;

  NAByte:=1;

  OldYr:=0; OldPr:=0;

  OldDate:='';  OldDDate:='';

  FixRunNo:=BOff; FixCurr:=BOff; ThinkMC:=BOff;

  GetMultiSys(BOff,SysOk,SysR);


  If (Mode=14) then
  Begin
    GetMultiSysCur(BOff,SysOk);

    GetMultiSysGCur(BOff,SysOk);

  end;

  SysOk:=Ok;

  KeyS:='';

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  While (StatusOk) and (RunOk) do
  With Inv do
  Begin

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    ChangeDet:=BOff;

    StoreRec:=BOff;

    FixRunNo:=BOff;
    FixNA:=BOff;
    FixCSupp:=BOff;
    FixAcc:=BOff;
    FixPr:=BOff;
    FixDate:=BOff;
    FixDDate:=BOff;


    Case Mode of

      1  :  Begin
              If (InvDocHed In SalesSplit+PurchSplit+WOPSplit+JAPSplit-NomSplit-StkAdjSplit-[SBT,PBT,TSH]+StkRetSplit) then
              Begin
                ShouldSupp:=TradeCode[(InvDocHed In SalesSplit)];

                If (InvDocHed In PSOPSet) then {* Set a separator in ledger *}
                  ShouldSupp:=Chr(Succ(Ord(ShouldSupp)))
                else
                  If (InvDocHed In WOPSPlit) then {* Set a separator in ledger *}
                    ShouldSupp:='W'
                  else
                    If (InvDocHed In JAPSPlit) then {* Set a separator in ledger *}
                    Begin
                      If (InvDocHed In JAPJAPSplit) then
                        ShouldSupp:='J' {Filter from normal ledger}
                      else
                        ShouldSupp:='K';

                    end
                    else
                      If (InvDocHed In StkRetSPlit) then {* Set a separator in ledger *}
                      Begin
                        If (InvDocHed In StkRetSalesSplit) then
                          ShouldSupp:='R' {Filter from normal ledger}
                        else
                          ShouldSupp:='N';

                      end;


                IF (Not ThinkMC) then
                  ThinkMC:=(Currency>0);

                FixCSupp:=(ShouldSupp<>CustSupp);

                If (FixCSupp) then
                  CustSupp:=ShouldSupp;

                FixNA:=(NomAuto and (Ord(NomAuto)<>1));

                If (FixNA) then
                  Move(NAByte,NomAuto,1);

                If (DueDate='') or (Length(DueDate)<>Length(Today)) and (Not (InvDocHed In RecieptSet+WOPSplit)) then
                Begin
                  FixDDate:=BOn;
                  OldDDate:=DueDate;

                  DueDate:=Today;
                end;

              end;


              Case InvDocHed of

                SIN
                     :  Begin {* Was in the middle of being created, not finished *}

                          FixRunNo:=(RunNo=-43) or (RunNo=-121);

                          If (FixRunNo) then
                            RunNo:=0;

                        end;

                PIN
                     :  Begin

                          FixRunNo:=(RunNo=-53) or (RunNo=-120);

                          If (FixRunNo) then
                            RunNo:=0;

                        end;

                SOR,SDN
                     :  Begin

                          FixRunNo:=((RunNo<>OrdUSRunNo) and (RunNo<>OrdPSRunNo));

                          If (FixRunNo) then
                            RunNo:=OrdUSRunNo;

                        end;

                POR,PDN
                     :  Begin

                          FixRunNo:=((RunNo<>OrdUPRunNo) and (RunNo<>OrdPPRunNo));

                          If (FixRunNo) then
                            RunNo:=OrdUPRunNo;

                        end;

                ADJ  :  Begin

                          FixRunNo:=((RunNo<>0) and (RunNo<>StkAdjRunNo));

                          If (FixRunNo) then
                            RunNo:=0;

                        end;

                TSH  :  Begin

                          FixRunNo:=((RunNo<>0) and (RunNo<>TSTPostRunNo));

                          If (FixRunNo) then
                            RunNo:=0;

                        end;

                WOR  :  Begin

                          FixRunNo:=((RunNo<>WORUPRunNo) and (RunNo<>WORPPRunNo));

                          If (FixRunNo) then
                            RunNo:=WORUPRunNo;
                        end;

                JPT,JST,JPA,JSA,JCT
                    :  Begin
                          Case InvDocHed of
                            JCT  :  FixRunNo:=(RunNo<>JCTUPRunNo);

                            JST  :  FixRunNo:=(RunNo<>JSTUPRunNo);

                            JPT  :  FixRunNo:=(RunNo<>JPTUPRunNo);

                            JSA  :  FixRunNo:=(RunNo<>JSAUPRunNo) and (RunNo<>(JSAUPRunNo-1));

                            JPA  :  FixRunNo:=(RunNo<>JPAUPRunNo) and (RunNo<>(JPAUPRunNo-1));
                          end;

                          If (FixRunNo) then
                          Begin
                            Case InvDocHed of
                              JCT  :  RunNo:=JCTUPRunNo;

                              JST  :  RunNo:=JSTUPRunNo;

                              JPT  :  RunNo:=JPTUPRunNo;

                              JSA  :  RunNo:=JSAUPRunNo;

                              JPA  :  RunNo:=JPAUPRunNo;
                            end; {Case..}
                          end;
                        end;




              end; {Case..}


              {* Check for valid Account *}

              FixAcc:=(InvDocHed In SalesSplit+PurchSplit+JAPSalesSplit-[TSH,SBT,PBT]) or ((InvDocHed=WOR) and (Trim(CustCode)<>''));


              If (FixAcc) then {* Will attempt to get from line first *}
                FixAcc:=Check_Account(OldNo);


              If (Not (AcPr In [1..Syss.PrInYr])) then
              Begin
                OldPr:=AcPr;

                If (Get_GoodLine(Inv,2)) then {* Attempt to get from line *}
                  AcPr:=Id.PPr
                else
                  AcPr:=Syss.CPr;

                FixPr:=BOn;
              end;

              If (Not (AcYr In [1..150])) then
              Begin
                OldYr:=AcYr;

                If (Get_GoodLine(Inv,3)) then {* Attempt to get from line *}
                  AcYr:=Id.PYr
                else
                  AcYr:=Syss.CYr;

                FixPr:=BOn;
              end;

              If (TransDate='') or (Length(TransDate)<>Length(Today)) then
              Begin
                FixDate:=BOn;
                OldDate:=TransDate;

                If (Get_GoodLine(Inv,4)) then {* Attempt to get from line *}
                  TransDate:=Id.PDate
                else
                  TransDate:=Today;
              end;

              If (TransDate='') or (Length(TransDate)<>Length(Today)) then
              Begin
                FixDate:=BOn;
                OldDate:=TransDate;

                If (Get_GoodLine(Inv,4)) then {* Attempt to get from line *}
                  TransDate:=Id.PDate
                else
                  TransDate:=Today;
              end;

              If (Currency>CurrencyType) then
              Begin
                FixCurr:=BOn;

                Currency:=Ord(ThinkMC);

              end;

              StoreRec:=(FixCSupp or FixRunNo or FixAcc or FixNA or FixPr or FixDate or FixDDate or FixCurr);


            end;
      2  :  {* Only affect unposted sales/purch items *}

            If ((InvDocHed In SalesSplit+PurchSplit+JAPSplit-NomSplit-StkAdjSplit) and (RunNo<=0)) or
               ((InvDocHed In PSOPSet) and ((RunNo=OrdUSRunNo) or (RunNo=OrdUPRunNo))) then
            Begin

              StoreRec:=(Currency=0);

              If (StoreRec) then
              Begin

                Currency:=1;

                CXrate[BOn]:=1;

                CXRate[BOff]:=1;

                ChangeDet:=BOn;

              end;

            end;
      14 :  {* Only affect unposted sales/purch items also unallocated *}

            If (InvDocHed In SalesSplit+PurchSplit-NomSplit-StkAdjSplit) and (RunNo<=0) then
            Begin

              StoreRec:=((CXRate[BOn]=0) and (Settled=0) and (RunNo=0));

              If (StoreRec) then
              Begin

                CXrate[BOn]:=SyssCurr.Currencies[Currency].CRates[BOff];

                ChangeDet:=BOn;

              end;

            end;

    end; {Case..}



    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=LCount;


    If (StoreRec) then
    Begin
      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to temporary file, report error '+Form_Int(Status,0),4);

      end
      else
      Begin
        Case Mode of

          1  :  Begin
                  If (FixCSupp) then
                    Write_FixLog(FNum,'Doc '+Inv.OurRef+' CustSupp Flag corrected');

                  If (FixRunNo) then
                    Write_FixLog(FNum,'Doc '+Inv.OurRef+' Run No. corrected. TRN type : '+DocNames[InvDocHed]);

                  If (FixAcc) then
                    Write_FixLog(FNum,'Doc '+Inv.OurRef+' Account Code ['+OldNo+
                                      '] incorrect. Replaced with ['+Inv.CustCode+']');

                  If (FixPr) then
                    Write_FixLog(FNum,'Doc '+Inv.OurRef+' Period '+SetN(OldPr)+'/'+SetN(OldYr)+
                                      ' is incorrect. Replaced with '+SetN(AcPr)+'/'+SetN(AcYr));

                  If (FixDate) then
                    Write_FixLog(FNum,'Doc '+Inv.OurRef+' Date '+OldDate+
                                      ' is incorrect. Replaced with '+TransDate);

                  If (FixDDate) then
                    Write_FixLog(FNum,'Doc '+Inv.OurRef+' Due Date '+OldDDate+
                                      ' is incorrect. Replaced with '+DueDate);

                end;

          2  :  Write_FixLog(FNum,'Doc '+Inv.OurRef+' Currency altered to 1');

          14 :  Write_FixLog(FNum,'Doc '+Inv.OurRef+' Daily rate altered');

        end; {Case..}
      end;
    end;

    RunOk:=(RunOk and (Status In [0,5]));


    If (ChangeDet) and (StatusOk) then
      Change_Details(Mode,RunOk,ProgBar);

    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  end; {While..}

end; {Proc..}

{ ====== Procedure to Scan all detail lines beloning to Orders, and see if O/S  ====== }
Function Check_DetailsOS(DecPlaces  :  Integer;
                     Var RunOk :  Boolean;
                         ProgBar
                               :  TSFProgressBar)  :  Boolean;

Const
  Fnum      =  IdetailF;
  Keypath   =  IdFolioK;
  MODE_INTEGER = 0;
  MODE_FRACTION = 1;

Var
  KeyS,
  KeyChk  :  Str255;

  FoundOk :  Boolean;

  Value: Double;

begin

  KeyChk:=FullNomKey(Inv.FolioNum);

  KeyS:=KeyChk;

  FoundOk:=BOff;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) and (Not FoundOk) do
  With Id do
  Begin

    If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));

    if (DecPlaces = 0) then
      { Original version, rounds to integer }
      FoundOk := (Round(Qty-(QtyDel+QtyWOff))<>0)
    else
      { Revised version, rounds to float }
      FoundOk := (Round_Up(Qty-(QtyDel+QtyWOff), DecPlaces)<>0);

    If (Not FoundOk) then
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  Check_DetailsOS:=FoundOk;

end; {Proc..}

{ ========== Procedure to Fix Document Header ========= }
Procedure UN_HistSPOP(Var TotalCount,
                          LCount:  LongInt;
                          Mode: Integer;
                      Var RunOk :  Boolean;
                          ProgBar
                                :  TSFProgressBar);



Const
  Fnum     =  InvF;
  Keypath  =  InvRNoK;

  LoopKey  :  Array[BOff..BOn,BOff..BOn] of Integer = ((OrdUSRunNo,OrdPSRunNo),
                                                   (OrdUPRunNo,OrdPPRunNo));


Var

  KeyChk,
  KeyS     :  Str255;

  Loop     :  Boolean;

  B_Func   :  Integer;

  SysOk    :  Boolean;

  //PR: 27/02/2017 ABSEXCH-18340 Removed local Status variable

Begin

  Status:=Open_File(F[SysF],SetDrive+FileNames[SysF],0);

  Loop:=BOff;

  SysOk := False;
  GetMultiSys(BOff,SysOk,SysR);

  Repeat

    KeyChk:=FullNomKey(LoopKey[Loop,BOn]);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With Inv do
    Begin

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      Inc(LCount);

      If (LCount<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=LCount;

      If (Check_DetailsOS(Mode,RunOk,ProgBar)) then
      Begin
        RunNo:=LoopKey[Loop,BOff];

        BatchLink:=DocCodes[InvDocHed]+DueDate;

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

        B_Func:=B_GetGEq;

        If (Not StatusOk) then
        Begin

          Write_FixLogFmt(FNum,'Unable to write data to temporary file, report error '+Form_Int(Status,0),4);

        end
        else
        Begin

          Write_FixLog(FNum,'Doc '+Inv.OurRef+' Returned to Daybook ');

        end;

        RunOk:=(RunOk and (Status In [0,5]));

      end
      else
        B_Func:=B_GetNext;




      Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}


    Loop:=Not Loop;

  Until (Not Loop) or (Not RunOk);


end; {Proc..}

{ ======== Procedure to Repair Selective Exchequer Data Files ====== }
Procedure Special_Function(  Mode     :  Integer;
                             ProgBar  :  TSFProgressBar);




Var
  EuroNo,
  n        :  Byte;

  mbRet    :  Word;

  DocRef,
  Count,
  RCount,
  TotalCount,
  FreeSpace,
  KSpaceReq,
  SpaceReq
           :  LongInt;

  HasRun,
  RunOk,
  SysOk,
  Ok2Cont,
  ReSort   :  Boolean;

  DecPlaces:  Integer;

  DocDate  :  String;

  FromDate, ToDate: string;
  ReportCheckedRecordCount: Boolean;

Begin

  ReportCheckedRecordCount := False;

  RunOk:=BOn;


  HasRun:=BOn;

  TotalCount:=0;
  RCount:=0;

  ReSort:=BOff; SysOk:=BOff;

  Addch:=ResetKey;

  If (Mode>0) and (Mode<=TotSFFunc) then
  Begin
    If (Assigned(ProgBar)) then
    Begin
      ProgBar.Caption:='Special Function '+Format('%0d',[Mode]);

      ProgBar.InfoLbl.Caption:=Get_SFMode(Mode);
    end;

    Case Mode of

      1,2,
      14   :  Begin
                FixFile[CustF].Rebuild:=BOn;
                FixFile[InvF].Rebuild:=BOn;
                FixFile[IdetailF].Rebuild:=BOn;
                FixFile[SysF].ReBuild:=BOn;

                Open_RepairFiles(CustF,SysF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

                Rcount:=0;


                TotalCount:=Used_Recs(F[InvF],InvF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                SF_DocHead(Mode,TotalCount,RCount,RunOk,ProgBar);
              end;

      3,48,49,53,92,100
           :  Begin
                FixFile[CustF].Rebuild:=BOn;
                FixFile[InvF].Rebuild:=BOn;

                FixFile[PWrdF].Rebuild:=BOn;

                Open_RepairFiles(CustF,PWrdF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

                Rcount:=0;

                TotalCount:=Used_Recs(F[PWrdF],PWrdF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                Case Mode of
                  53  : Remove_PMPMode(0,RunOk,TotalCount,RCount,ProgBar);

                  61  : ;

                  100 :  Begin
                           TotalCount:=Used_Recs(F[InvF],InvF);

                           Del_DocAuditNotes(TotalCount,RCount,RunOk,ProgBar);
                         end;

                  else  Remove_Match(1+Ord(Mode In [48,49])+Ord(Mode=49)+(3*Ord(Mode=92)),RunOk,TotalCount,RCount,ProgBar);
                end;

              end;


      4    :  Begin
                FixFile[InvF].Rebuild:=BOn;
                FixFile[IdetailF].Rebuild:=BOn;
                FixFile[IncF].Rebuild:=BOn;
                FixFile[SysF].Rebuild:=BOn;

                Open_RepairFiles(InvF,SysF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

                Rcount:=0;

                TotalCount:=Used_Recs(F[IdetailF],IdetailF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                Resurect_Hed(RunOk,TotalCount,RCount,ProgBar);

              end;

      5..7
           :  Begin

                If (Mode In [5,7]) then
                Begin

                  FixFile[IdetailF].Rebuild:=BOn;
                  FixFile[IdetailF].ProcessKey:=IdFolioK;
                end;

                If (Mode In [6,7]) then
                Begin

                  FixFile[InvF].Rebuild:=BOn;

                  mbRet:=MessageDlg('Sort the Transaction headers in date order instead of folio order?',
                      mtConfirmation, [mbYes, mbNo], 0);

                  If (mbRet=mrYes) then
                    FixFile[InvF].ProcessKey:=InvDateK
                  else
                    FixFile[InvF].ProcessKey:=InvFolioK;

                end;

                ReSort:=BOn;

                ReBuild_Files(ReSort,BOff,ProgBar);

              end;

      8,11,26,107,109,110,111,112,113
           :  Begin
                FixFile[StockF].Rebuild:=(Not (Mode In [109,113]));
                FixFile[MLocF].Rebuild:=(Mode<>111);
                FixFile[JCtrlF].Rebuild:=(Mode=111);
                FixFile[SysF].Rebuild:=(Mode In [112]);


                Open_RepairFiles(StockF,SysF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

                Rcount:=0;

                If (Mode<108) then
                  TotalCount:=Used_Recs(F[StockF],StockF)
                else
                  If (Mode<>111) then
                    TotalCount:=Used_Recs(F[MLocF],MLocF)
                  else
                    If (Mode=111) then
                      TotalCount:=Used_Recs(F[JCtrlF],JCtrlF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                Case Mode of
                  8  :  Set_StockCost(RunOk,RCount,TotalCount,ProgBar);
                  11 :  Set_FiltStock(RunOk,RCount,TotalCount,ProgBar);
                  26 :  Set_StockAltCodes(RunOk,RCount,TotalCount,ProgBar);
                  107:  Set_StockNoteC(RunOk,RCount,TotalCount,ProgBar);
                  109:  Del_DupliLocRecs(RunOk,TotalCount,Count,Mode,ProgBar);
                  110:  Del_DeadBinChildRecs(RunOk,TotalCount,Count,Mode,ProgBar);
                  111:  Del_DupliJCtrlRecs(RunOk,TotalCount,Count,Mode,ProgBar);
                  112:  Del_DeadBinMasterRecs(RunOk,TotalCount,Count,Mode,ProgBar);
                  113:  Del_TeleSalesCtrlRecs(RunOk,TotalCount,Count,Mode,ProgBar);
                end;

              end;





      12,22,23,24,74,114,115
           :  Begin
                FixFile[InvF].Rebuild:=BOn;
                FixFile[IdetailF].Rebuild:=BOn;

                Open_RepairFiles(InvF,IDetailF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

                Rcount:=0;

                TotalCount:=Used_Recs(F[InvF],InvF);

                Ok2Cont := True;
                if (Mode = 115) then
                begin
                  GetMultiSys(BOff,SysOk,SysR);
                  Ok2Cont := Get_DecPlaces(DecPlaces);
                end
                else
                  DecPlaces := 0;

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                if Ok2Cont then
                  Case Mode of
                    12  :  Un_HistSPOP(TotalCount,RCount,DecPlaces,RunOk,ProgBar);
                    22  :  Fix_HistSPOP(TotalCount,RCount,RunOk,ProgBar);
                    23,24
                        :  Del_BadDoc(TotalCount,RCount,(Mode-23),RunOk,ProgBar);

                    74,114
                        :  Fix_HistSPOPBOML(TotalCount,RCount,RunOk,(Ord(Mode=114)),ProgBar);
                    115 :  Un_HistSPOP(TotalCount,RCount,DecPlaces,RunOk,ProgBar);
                  end; {Case..}
              end;


      16   :  Begin
                FixFile[InvF].Rebuild:=BOn;

                FixFile[IdetailF].Rebuild:=BOn;

                Open_RepairFiles(InvF,IdetailF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

                Rcount:=0;

                TotalCount:=Used_Recs(F[IdetailF],IdetailF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                Repair_NomLine(RunOk,TotalCount,RCount,ProgBar);
              end;

      17
           :  Begin
                FixFile[CustF].Rebuild:=BOn;

                Open_RepairFiles(CustF,CustF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

                Rcount:=0;

                TotalCount:=Used_Recs(F[CustF],CustF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                Case Mode of
                  17  :  Set_CustStaFlg(RunOk,RCount,TotalCount,ProgBar);
                end;


              end;

        57,59,67,79,80,85,86
           :  Begin
                FixFile[InvF].Rebuild:=BOn;
                FixFile[CustF].Rebuild:=BOn;
                FixFile[IdetailF].Rebuild:=BOn;
                FixFile[StockF].Rebuild:=BOn;
                FixFile[PwrdF].Rebuild:=BOn;
                FixFile[NHistF].Rebuild:=BOn;
                FixFile[JMiscF].Rebuild:=BOn;
                FixFile[MLocF].Rebuild:=BOn;

                FixFile[SysF].Rebuild:=BOn;

                Open_RepairFiles(CustF,SysF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

                Rcount:=0;

                TotalCount:=Used_Recs(F[CustF],CustF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                Case Mode of
                  57,67,79,80,85
                      :  Begin
                           TotalCount:=Used_Recs(F[InvF],InvF);

                           If (Assigned(ProgBar)) then
                             ProgBar.ProgressBar1.Max:=TotalCount;

                           Case Mode of
                              57,67,79
                                  :  SetUnptCost(RunOk,TotalCount,RCount,Mode,ProgBar);

                              80  :  ZeroSaleBOMCost(RunOk,TotalCount,RCount,Mode,ProgBar);

                              85  :  CheckSRCPPY4Stk(RunOk,TotalCount,RCount,Mode,ProgBar);

                           end; {Case..}
                         end;

                  59,86
                      :  Begin
                           TotalCount:=Used_Recs(F[InvF],InvF);

                           If (Assigned(ProgBar)) then
                             ProgBar.ProgressBar1.Max:=TotalCount;

                           Case Mode of
                              59  :  CleanORef(TotalCount,RCount,RunOk,ProgBar);

                              86  :  PadYourRef(TotalCount,RCount,RunOk,ProgBar);
                           end; {Case..}

                         end;


                end;

              end;

        39 :  Begin
                MCConv_Control(ProgBar);

              end;
        42   :
              Begin
                FixFile[CustF].Rebuild:=BOn;
                FixFile[InvF].Rebuild:=BOn;

                FixFile[IdetailF].Rebuild:=BOn;
                FixFile[StockF].Rebuild:=BOn;

                Open_RepairFiles(CustF,SysF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

                Rcount:=0;

                TotalCount:=Used_Recs(F[CustF],CustF)+Used_Recs(F[IdetailF],IdetailF)+Used_Recs(F[StockF],StockF)+Used_Recs(F[InvF],InvF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                Set_MLFPad(RunOk,TotalCount,RCount,0,ProgBar);
              end;

        44  : begin
                FixFile[CustF].Rebuild := BOn;
                FixFile[InvF].Rebuild  := BOn;

                { Open all files and check for a Rebuild header }
                Open_RepairFiles(CustF, SysF, BOn, BOff, ProgBar);

                RCount := 0;

                TotalCount := Used_Recs(F[CustF], CustF) +
                              Used_Recs(F[InvF], InvF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max := TotalCount;

                SetDocGLCtrl(TotalCount, RCount, RunOk, ProgBar);
              end;

        50,51 :
              Begin
                FixFile[CustF].Rebuild:=BOn;
                FixFile[InvF].Rebuild:=BOn;
                FixFile[PWrdF].Rebuild:=BOn;
                FixFile[SysF].ReBuild:=BOn;

                Open_RepairFiles(CustF,SysF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

                Rcount:=0;

                TotalCount:=Used_Recs(F[InvF],InvF)+Used_Recs(F[PWrdF],PWrdF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                Unallocate_Trans(Mode-48,RunOk,TotalCount,RCount,ProgBar);


              end;


        54,64 :
              Begin
                FixFile[IdetailF].Rebuild:=BOn;
                FixFile[InvF].Rebuild:=BOn;
                FixFile[JDetlF].Rebuild:=BOn;
                FixFile[MiscF].ReBuild:=BOn;
                FixFile[SysF].ReBuild:=BOn;

                Open_RepairFiles(InvF,SysF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

                Rcount:=0;

                TotalCount:=Used_Recs(F[InvF],InvF)
                            +Used_Recs(F[IDetailF],IDetailF)
                            +Used_Recs(F[MiscF],MiscF)
                            +Used_Recs(F[JDetlF],JDetlF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;


                //ProgBar.Visible:=BOff;

                Ok2Cont:=Get_Triangulation(DocRef,DocDate,EuroNo);

                //ProgBar.Visible:=BOn;


                If (Ok2Cont) then
                Begin
                  Case Mode of
                    54  :  SetDocUOR(RunOk,TotalCount,RCount,DocRef,DocDate,EuroNo,ProgBar);

                    64  :  If (DocRef<>0) and (EuroNo<>0) then
                             ResetDocUOR(RunOk,TotalCount,RCount,DocRef,DocDate,EuroNo,ProgBar)
                           else
                           Begin
                             HasRun:=BOff;

                             ShowMessage('You must enter a valid NOM reference & Euro currency value.');
                           end;
                  end; {Case..}
                end
                else
                  HasRun:=BOff;

              end;

        55,56,76,77,81,82
           :
              Begin
                FixFile[CustF].Rebuild:=BOn;
                FixFile[SysF].Rebuild:=BOn;

                Open_RepairFiles(CustF,SysF,BOn,BOff,ProgBar);

                Rcount:=0;

                TotalCount:=Used_Recs(F[CustF],CustF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                Set_CustSetlTerm2(RunOk,RCount,TotalCount,(Mode In [55,76,81]),Mode,ProgBar);
             end;

        20,62,63,84,87,89,94,95,101,106,108
           :  Begin
                FixFile[InvF].Rebuild:=BOn;
                FixFile[IDetailF].Rebuild:=(Mode In [106,108]);
                FixFile[SysF].ReBuild:=(Mode In [95]);


                Open_RepairFiles(InvF,SysF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

                Rcount:=0;

                TotalCount:=Used_Recs(F[InvF],InvF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                Case Mode of
                  20,94,95
                      :  Reset_SterSettle(RunOk,TotalCount,RCount,Mode,ProgBar);
                  62  :  Set_PINPCRAuth(RunOk,TotalCount,RCount,ProgBar);
                  63  :  Set_ResetDebtLtr(RunOk,TotalCount,RCount,ProgBar);
                  84  :  RepairOrdMatch(RunOk,TotalCount,RCount,ProgBar);
                  87  :  Reset_GenisisSIN(RunOk,TotalCount,RCount,ProgBar);
                  89  :  Test_V5DocIndex(RunOk,TotalCount,RCount,ProgBar);
                  101 :  Reset_AllocStat(RunOk,TotalCount,RCount,Mode,ProgBar);
                  106  :  Reset_GreencoreSIN(RunOk,TotalCount,RCount,ProgBar);
                  108  :  Reset_GenisisSOR(RunOk,TotalCount,RCount,ProgBar);
                end; {Case..}


              end;


        66,71,90,91,93,102,104
           :  Begin
                FixFile[IdetailF].Rebuild:=BOn; Ok2Cont:=BOn;

                If (Mode=71) then
                  FixFile[MLocF].Rebuild:=BOn
                else
                  If (Mode In [90,91]) then
                  Begin
                    FixFile[SysF].Rebuild:=BOn;
                    FixFile[NHistF].Rebuild:=BOn;

                    If (Mode=90) then
                      FixFile[CustF].Rebuild:=BOn
                    else
                      FixFile[StockF].Rebuild:=BOn;

                    FixFile[IdetailF].Rebuild:=BOff;

                  end
                  else
                  If (Mode In [93]) then
                  Begin
                    FixFile[CustF].Rebuild:=BOn;
                    FixFile[StockF].Rebuild:=BOn;
                  end;

                Open_RepairFiles(CustF,SysF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

                Rcount:=0;

                If (Not (Mode In [90,91])) then
                  TotalCount:=Used_Recs(F[IdetailF],IdetailF)
                else
                Begin
                  TotalCount:=Used_Recs(F[NHistF],NHistF);

                  GetMultiSys(BOff,SysOk,SysR);

                end;

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                //ProgBar.Visible:=BOff;

                Case Mode of
                  71  :  Ok2Cont:=Get_Location(DocDate);
                  90  :  Ok2Cont:=Get_Account(DocDate);
                  91  :  Ok2Cont:=Get_Stock(DocDate);

                end; {Case..}

                //ProgBar.Visible:=BOn;


                If (Ok2Cont) then
                Begin
                  Case Mode of
                    66  :  Clean_ReconFlg(RunOk,TotalCount,RCount,ProgBar);
                    71  :  Set_DetailsLOC(Mode,RunOk,TotalCount,RCount,DocDate,ProgBar);
                    90  :  ResetSet_PurgeACHist(Mode,RunOk,TotalCount,RCount,DocDate,ProgBar);
                    91  :  ResetSet_PurgeStkHist(Mode,RunOk,TotalCount,RCount,DocDate,ProgBar);
                    93  :  Begin
                             TotalCount:=TotalCount+Used_Recs(F[CustF],CustF)+Used_Recs(F[StockF],StockF);
                             Set_CCDPad(RunOk,TotalCount,RCount,ProgBar);
                           end;

                   102  :  Clean_StkTypeFlg(RunOk,TotalCount,RCount,ProgBar);
                   104  :  Clean_PaymentFlg(RunOk,TotalCount,RCount,ProgBar);
                  end;
               end
               else
                 HasRun:=BOff;
             end;

        78 :
              Begin
                FixFile[JMiscF].Rebuild:=BOn;

                Open_RepairFiles(JMiscF,JMiscF,BOn,BOff,ProgBar);

                Rcount:=0;
                Count:=0;

                TotalCount:=Used_Recs(F[JMiscF],JMiscF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                Reset_EmplCertDate(RunOk,TotalCount,Count,RCount,ProgBar);
             end;

        83
           :
              Begin
                FixFile[StockF].Rebuild:=BOn;

                Open_RepairFiles(StockF,StockF,BOn,BOff,ProgBar);

                Rcount:=0;

                TotalCount:=Used_Recs(F[StockF],StockF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                Set_StockWeb(RunOk,RCount,TotalCount,Mode,ProgBar);
             end;


        88,96
           :
              Begin
                FixFile[IdetailF].Rebuild:=BOn;
                FixFile[JDetlF].Rebuild:=BOn;

                If (Mode In [88,96]) then
                  FixFile[InvF].Rebuild:=BOn;

                Open_RepairFiles(InvF,JDetlF,BOn,BOff,ProgBar);

                Rcount:=0;
                Count:=0;

                TotalCount:=Used_Recs(F[JDetlF],JDetlF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                Del_NoPJobAct(RunOk,TotalCount,Count,RCount,ProgBar);
             end;

        97,98,99,103,105
           :
              Begin
                FixFile[CustF].Rebuild:=BOn;
                FixFile[StockF].Rebuild:=BOn;
                FixFile[MiscF].Rebuild:=BOn;
                FixFile[SysF].Rebuild:=(Mode In [99,112]);

                Open_RepairFiles(CustF,SysF,BOn,BOff,ProgBar);

                Rcount:=0;
                Count:=0;

                TotalCount:=Used_Recs(F[MiscF],MiscF);

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                Case Mode of
                  97  :  RepairDiscRecs(RunOk,TotalCount, Count,ProgBar);

                  98  :  Del_FIFORecs(RunOk,TotalCount,Count,Mode,ProgBar);

                  99  :  Reset_BOMSoldRecs(RunOk,TotalCount,Count,Mode,ProgBar);

                 103,
                 105  :  DeleteSerialBatchRecs(RunOk,TotalCount,Count,ProgBar,Ord(Mode=105));

                end; {Case..}
             end;

        116
           :
              Begin
                FixFile[SysF].Rebuild:=BOn;
                FixFile[NHistF].Rebuild:=BOn;
                FixFile[NomF].Rebuild:=BOn;

                Open_RepairFiles(NomF,SysF,BOn,BOff,ProgBar);

                Rcount:=0;
                Count:=0;

                TotalCount:=Used_Recs(F[NHistF],NHistF)*3;

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;

                DeleteDupYTDHist (RunOk,TotalCount,Count,RCount,ProgBar);
             end;

      118  : Begin // 118 - Delete orphaned xDN lines
               FixFile[SysF].Rebuild:=BOn;
               FixFile[InvF].Rebuild:=BOn;
               FixFile[IDetailF].Rebuild:=BOn;

               Open_RepairFiles(InvF,SysF,BOn,BOff,ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[IDetailF],IDetailF);

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max:=TotalCount;

               // Runs through IDetail and deletes any PDN/SDN lines where the header is missing
               DeleteOrphanXDNLines (RunOk, TotalCount, Count, RCount, ProgBar);
             End; // 118 - Delete orphaned xDN lines

      119 :  ; // v6.00.002 - Delete orphaned Transaction Lines (Fission IT Ltd)

      120  : Begin // 120 - Correct PJI/PJC Run Numbers (Roe Ltd)
               FixFile[InvF].Rebuild:=BOn;
               FixFile[IDetailF].Rebuild:=BOn;

               Open_RepairFiles(InvF,IDetailF,BOn,BOff,ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[InvF], InvF);

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max:=TotalCount;

               FixPJXRunNumbers (RunOk, TotalCount, Count, RCount, ProgBar);
             End; // 120 - Correct PJI/PJC Run Numbers (Roe Ltd)


      121  : Begin // 121 - Populate missing Account Codes in Transaction Lines.
               FixFile[InvF].Rebuild:=BOn;
               FixFile[IDetailF].Rebuild:=BOn;

               Open_RepairFiles(InvF,IDetailF,BOn,BOff,ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[InvF], InvF);

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max:=TotalCount;

               PopulateAccountCodes (RunOk, TotalCount, Count, RCount, ProgBar);
             End; // 121 - Populate missing Account Codes in Transaction Lines.

      122  : Begin // 122 - Copy Cost of Sales details from Stock records
               FixFile[InvF].Rebuild:=BOn;
               FixFile[IDetailF].Rebuild:=BOn;
               FixFile[StockF].Rebuild:=BOn;

               Open_RepairFiles(InvF,StockF,BOn,BOff,ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[InvF], InvF);

               If (Assigned(ProgBar)) then
               begin
                 ProgBar.ProgressBar1.Visible := False;
                 ProgBar.ProgressBar1.Max:=TotalCount;
               end;

               if Get_DateRange(FromDate, ToDate) then
               begin
                 CopyCostOfSales(RunOk, TotalCount, Count, RCount, FromDate, ToDate, ProgBar);
                 ReportCheckedRecordCount := True;
               end;
             End; // 121 - Copy Cost of Sales details from Stock records

      123  : begin
               FixFile[MLocF].Rebuild:=BOn;

               Open_RepairFiles(MLocF,MLocF,BOn,BOff,ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[MLocF], MLocF);

               If (Assigned(ProgBar)) then
               begin
                 ProgBar.ProgressBar1.Visible := False;
                 ProgBar.ProgressBar1.Max:=TotalCount;
               end;

               RemoveStockLocationRecords(RunOk, TotalCount, Count, RCount, ProgBar);
             end;

      124  : Begin // 124 - Reset NomMode
               FixFile[IDetailF].Rebuild:=BOn;

               Open_RepairFiles(IDetailF, IDetailF, BOn, BOff, ProgBar);

               RCount:=0;
               Count:=0;

               TotalCount := Used_Recs(F[IdetailF], IdetailF);

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max := TotalCount;

               ResetNomMode(RunOk, TotalCount, Count, RCount, ProgBar);
             End;

      125  : Begin // 125 - CJS 09/02/2011 - Set Folio Number
               FixFile[IncF].Rebuild:=BOn;

               Open_RepairFiles(IncF, IncF, BOn, BOff, ProgBar);

               RCount := 0;
               Count := 0;
               TotalCount := 0;

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max := TotalCount;

               if SetFolioNumber then
               begin
                 RCount := 1;
                 Count := 1;
                 TotalCount := 1;
               end;

             End;

      126  : Begin // 126 - CJS 2011-10-20 - Reinstate outstanding WORs
               FixFile[InvF].Rebuild:=BOn;
               FixFile[IDetailF].Rebuild:=BOn;

               Open_RepairFiles(InvF,IDetailF,BOn,BOff,ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[InvF], InvF);

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max:=TotalCount;

               ReinstateWORs(TotalCount, Count, RCount, RunOk, ProgBar);
             End;

      127  : Begin // 127 - CJS 2011-10-25 - Move misplaced SRNs
               FixFile[InvF].Rebuild:=BOn;
               FixFile[IDetailF].Rebuild:=BOn;

               Open_RepairFiles(InvF,IDetailF,BOn,BOff,ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[InvF], InvF);

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max:=TotalCount;

               MoveSRNs(TotalCount, Count, RCount, RunOk, ProgBar);
             End;

      128  : Begin //PR: 07/03/2012 ABSEXCH-12034 Delete WORs without lines.
               FixFile[InvF].Rebuild:=BOn;
               FixFile[IDetailF].Rebuild:=BOn;

               Open_RepairFiles(InvF,IDetailF,BOn,BOff,ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[InvF], InvF);

               ReportCheckedRecordCount := True;

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max:=TotalCount;

               DeleteWORsWithNoLines(TotalCount, Count, RCount, RunOk, ProgBar);
             End;

      129  : Begin //PR: 07/03/2012 ABSEXCH-11640 Delete WOR lines without header.
               FixFile[InvF].Rebuild:=BOn;
               FixFile[IDetailF].Rebuild:=BOn;

               Open_RepairFiles(InvF,IDetailF,BOn,BOff,ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[IDetailF], IDetailF);

               ReportCheckedRecordCount := True;

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max:=TotalCount;

               DeleteWORLinesWithNoHeader(TotalCount, Count, RCount, RunOk, ProgBar);
             End;

      130  : Begin // 130 - CJS 2012-05-23 - Find transactions with no lines
               FixFile[InvF].Rebuild:=BOn;
               FixFile[IDetailF].Rebuild:=BOn;

               Open_RepairFiles(InvF,IDetailF,BOn,BOff,ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[InvF], InvF);

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max:=TotalCount;

               ReportCheckedRecordCount := False;
               FindEmptyTransactions(TotalCount, Count, RCount, RunOk, ProgBar);

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Position := 0;
             End;

      131  : Begin // 131- CJS 2012-05-23 - Fix transactions with no lines
               FixFile[InvF].Rebuild:=BOn;
               FixFile[IDetailF].Rebuild:=BOn;

               Open_RepairFiles(InvF,IDetailF,BOn,BOff,ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[InvF], InvF);

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max:=TotalCount;

               FixEmptyTransactions(TotalCount, Count, RCount, RunOk, ProgBar);
             End;

      132  : Begin // 132 - CJS 2012-09-05 - Manually fix Transaction Line dates
               FixFile[InvF].Rebuild:=BOn;
               FixFile[IDetailF].Rebuild:=BOn;

               Open_RepairFiles(InvF,IDetailF,BOn,BOff,ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[InvF], InvF);

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max:=TotalCount;

               FixTransactionLineDates(TotalCount, Count, RCount, RunOk, ProgBar);
             End;

      133  : Begin // 133 - v6.10.1 only, not included here
               Write_FixMsg('This function is only available with Exchequer v6.10.1 -- it is not required for other versions.');
             End;

      134  : Begin // 134 - CJS 2013-04-17 - ABSEXCH-14239 - fix corrupted UntilDate fields
               FixFile[InvF].Rebuild:=BOn;

               Open_RepairFiles(InvF, InvF, BOn, BOff, ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[InvF], InvF);

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max:=TotalCount;

               FixTransactionHeader(TotalCount, Count, RCount, RunOk, ProgBar);
             End;

      135:   begin
               FixFile[IdetailF].Rebuild:=BOn;

               Open_RepairFiles(IdetailF, IdetailF, BOn, BOff, ProgBar);

               Rcount:=0;

               TotalCount:=Used_Recs(F[IdetailF], IdetailF);

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max:=TotalCount;

               RemoveErroneousB2BFolios(RunOk, TotalCount, RCount, ProgBar);
             end;

      136  : Begin // 136 - CJS 2013-10-18 - ABSEXCH-14703 - copy delivery address line 5 to postcode
               FixFile[CustF].Rebuild:=BOn;

               Open_RepairFiles(CustF, CustF, BOn, BOff, ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[CustF], CustF);

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max:=TotalCount;

               CopyToPostcode(TotalCount, Count, RCount, RunOk, ProgBar);
             End;

      147  : Begin // 147 - CJS 2014-09-25 - ABSEXCH-15658 - Multiple ADJ lines cause posting run to hang
               FixFile[InvF].Rebuild:=BOn;
               FixFile[IDetailF].Rebuild:=BOn;

               Open_RepairFiles(InvF,IDetailF,BOn,BOff,ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[IdetailF], IdetailF);
               ReportCheckedRecordCount := True;

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max:=TotalCount;

               RemoveErroneousAdjustmentLines(TotalCount, Count, RCount, RunOk, ProgBar);
             End;

       148 :  begin // 148 - CJS 2014-12-01 - Order Payments - T109 - Clear legacy Credit Card Fields in CUSTSUPP
                FixFile[CustF].Rebuild := True;
                Open_RepairFiles(CustF, CustF, True, False, ProgBar);

                RCount := 0;
                Count  := 0;

                TotalCount := Used_Recs(F[CustF], CustF);
                if Assigned(ProgBar) then
                  ProgBar.ProgressBar1.Max := TotalCount;

                PurgeLegacyCreditCardDetails(TotalCount, Count, RCount, RunOk, ProgBar);
              end;

       149 :  begin // 149 - CJS 2014-12-02 - Order Payments - T224 - Set Country Code
                FixFile[CustF].Rebuild := True;
                Open_RepairFiles(CustF, CustF, True, False, ProgBar);

                RCount := 0;
                Count  := 0;

                TotalCount := Used_Recs(F[CustF], CustF);
                if Assigned(ProgBar) then
                  ProgBar.ProgressBar1.Max := TotalCount;

                SetCountryCode(TotalCount, Count, RCount, RunOk, ProgBar);
              end;

       151 :  begin // 151 - CJS 2015-01-16 - ABSEXCH-16010 - Special Function to update country code on roles
                FixFile[CustF].Rebuild := True;
                Open_RepairFiles(CustF, CustF, True, False, ProgBar);

                RCount := 0;
                Count  := 0;

                TotalCount := Used_Recs(F[CustF], CustF);
                if Assigned(ProgBar) then
                  ProgBar.ProgressBar1.Max := TotalCount;

                SetAccountContactCountryCode(TotalCount, Count, RCount, RunOk, ProgBar);
              end;

       154  : Begin // 154 - CJS 2015-03-03 - ABSEXCH-16154 - remove tab characters from transaction line descriptions
               FixFile[IDetailF].Rebuild:=BOn;

               Open_RepairFiles(IDetailF,IDetailF,BOn,BOff,ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[IdetailF], IdetailF);
               ReportCheckedRecordCount := True;

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max:=TotalCount;

               RemoveTabCharacters(TotalCount, Count, RCount, RunOk, ProgBar);
             End;

       157 :  begin
                RCount := 0;
                Count  := 0;
                TotalCount := Used_Recs(F[InvF], InvF);
                ReorderTransactions(TotalCount, Count, RCount, RunOK, ProgBar);
              end;

       158  : Begin // 158 - CJS - 2015-10-06 - ABSEXCH-16838 - transaction delivery address country code
               FixFile[CustF].Rebuild:=BOn;
               FixFile[InvF].Rebuild:=BOn;

               Open_RepairFiles(CustF,InvF,BOn,BOff,ProgBar);

               Rcount:=0;
               Count:=0;

               TotalCount:=Used_Recs(F[InvF], InvF);
               ReportCheckedRecordCount := True;

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max:=TotalCount;

               UpdateTransactionCountryCodes(TotalCount, Count, RCount, RunOk, ProgBar);
             End;

       159 :  begin // PR: 25/11/2015 - ABSEXCH-17001 - Clear random data from Syss.Spare600
                CleanSpare600(TotalCount, Count, RCount, RunOK, ProgBar);
              end;

       160:   begin // CJS 2016-04-20 - ABSEXCH-17432 - SF to clear transaction Intrastat details
               FixFile[CustF].Rebuild := True;
               FixFile[IdetailF].Rebuild  := True;
               FixFile[InvF].Rebuild  := True;

               Open_RepairFiles(CustF, IdetailF, True, False, ProgBar);

               Rcount := 0;
               Count  := 0;

               TotalCount := Used_Recs(F[InvF], InvF) + Used_Recs(F[CustF], CustF);
               ReportCheckedRecordCount := True;

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max := TotalCount;

                ClearIntrastatFields(TotalCount, Count, RCount, RunOK, ProgBar);
              end;

       161:   begin // CJS 2016-06-03 - ABSEXCH-17495 - move VAT Submission response to correct company
                RCount := 0;
                Count  := 0;
                TotalCount := 1;
                ReportCheckedRecordCount := False;
                MoveVATSubmission(RCount, RunOK);
              end;

       162:   begin //PR: 06/09/2016 ABSEXCH-17700 Remove redundant control lines (Crane Asia)
               FixFile[IdetailF].Rebuild  := True;

               Open_RepairFiles(IdetailF, IdetailF, True, False, ProgBar);

               Rcount := 0;
               Count  := 0;

               TotalCount := Used_Recs(F[IDetailF], IDetailF);
               ReportCheckedRecordCount := True;

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max := TotalCount;

                DeleteRedundantControlLines(TotalCount, Count, RCount, RunOK, ProgBar);

              end;

       163:   begin //PR: 14/09/2016 ABSEXCH-17636 Remove History records with year of > 2017
               FixFile[NHistF].Rebuild  := True;

               Open_RepairFiles(NHistF, NHistF, True, False, ProgBar);

               Rcount := 0;
               Count  := 0;

               TotalCount := Used_Recs(F[NHistF], NHistF);
               ReportCheckedRecordCount := True;

               If (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max := TotalCount;

                DeleteFutureHistoryRecords(TotalCount, Count, RCount, RunOK, ProgBar);

              end;
              
       164:   begin //AP : 14/02/2017 2017-R1 ABSEXCH-15554 : VRW not pulling all historical data using index fields following upgrade
               FixFile[InvF].Rebuild := BOn;
               FixFile[IDetailF].Rebuild := BOn;

               Open_RepairFiles(InvF, IDetailF, True, False, ProgBar);

               Rcount := 0;
               Count  := 0;

               TotalCount := Used_Recs(F[IdetailF], IdetailF);
               ReportCheckedRecordCount := True;
               if (Assigned(ProgBar)) then
                 ProgBar.ProgressBar1.Max := TotalCount;

                UpdateTransactionLineOurRef(TotalCount, Count, RCount, RunOK, ProgBar);
              end;
       165:   begin //PR: 27/06/2017 ABSEXCH-18756
                FixFile[InvF].Rebuild  := True;
                FixFile[IdetailF].Rebuild  := True;

                Open_RepairFiles(InvF, IDetailF, True, False, ProgBar);

                RCount := 0;
                Count := 0;
                TotalCount:=Used_Recs(F[InvF], InvF);;
                ReportCheckedRecordCount := True;

                SetPINRunNumbersFromLines(RunOK, RCount, Count, ProgBar);
              end;

       166:   begin //PR: 27/06/2017 ABSEXCH-18756
                FixFile[InvF].Rebuild  := True;
                FixFile[IdetailF].Rebuild  := True;

                Open_RepairFiles(InvF, IDetailF, True, False, ProgBar);

                RCount := 0;
                Count := 0;
                TotalCount:=Used_Recs(F[InvF], InvF);;
                ReportCheckedRecordCount := True;

                FixSettleDoubling(RunOK, RCount, Count, ProgBar);
              end;
              
              {AP 05/06/2018 2018R2 ABSEXCH-20310:Special Function to set folio number on specified transaction when folio number = 0}
       167:   Begin
                FixFile[InvF].Rebuild := BOn;
                FixFile[IdetailF].Rebuild := BOn;
                Open_File(F[IncF], SetDrive+FileNames[IncF], 0);
                Open_RepairFiles(InvF, IDetailF, BOn, BOff, ProgBar); {* Open all files and check for a Rebuild header *}
                Rcount := 0;
                TotalCount := Used_Recs(F[InvF], InvF);
                if Assigned(ProgBar) then
                  ProgBar.ProgressBar1.Max := TotalCount;
                ResetZeroFolioTrans(RunOk, TotalCount, RCount, ProgBar);
              end;
      else   Begin
                ShowMessage('Special Function '+IntToStr(Mode)+' has not been implemented in this version.');
                HasRun:=BOff;
             end;



    end; {Case..}


    If (Not ReSort) then
    Begin
      Close_Files(BOn);


      If (HasRun) then
      Begin

        Write_FixMsgFmt('Data Repair Function '+Form_Int(Mode,0)+' ('+Get_SFMode(Mode)+') completed.',3);
        Write_FixMsg('');
        Write_FixMsgFmt('Grand Total No. records stored: '+#9+Form_Int(TotalCount,0),3);
        if ReportCheckedRecordCount then
          Write_FixMsgFmt('Grand Total No. records checked: '+#9+Form_Int(Count,0),3);
        Write_FixMsgFmt('Grand Total No. records processed: '+#9+Form_Int(RCount,0),3);
        Write_FixMsg('');
        Write_FixMsgFmt(ConstStr('=',80),3);

      end;

    end;

    // PostMessage(ProgBar.Handle,WM_Close,0,0);

  end; {If Abort..}

  FixFile[BuildF].ReBuild:=BOff;

end; {Proc..}

end. {Unit..}