unit History;

interface

{$IFDEF FDES}
// Checks product type and returns appropriate version number
Function FormDesVer : ShortString;
{$ENDIF} // FDES

{$IFDEF EDLL}
// Checks product type and returns appropriate version number
Function SbsFormVer : ShortString;
{$ENDIF} // EDLL

implementation

Uses EntLicence, ExchequerRelease;

Const
  // Form Designer Version Number - common to FormDes.Exe and SbsForm.Dll
  //ExchSysVer = 'b571';            // BETA Version
  //ExchSysVer = 'Exchequer 2015 R1';         // RELEASE Version

  //LITESysVer = 'b100';          // BETA Version
  LITESysVer = 'v1.00';           // RELEASE Version

  // FormDes.Exe Build Number - common across Exch & IAO
  BuildVer_FD = '071';

  // SbsForm.Dll Build Number - common across Exch & IAO
  BuildVer_SF = '204';

  // NOTE: The build number should be incremented for any new version leaving
  // the department, even if just to QA for testing.

// Checks product type and returns appropriate version number
Function FormDesVer : ShortString;
Begin // FormDesVer
  Result := ExchequerModuleVersion (emFormDesigner, BuildVer_FD);
End; // FormDesVer

// Checks product type and returns appropriate version number
Function SbsFormVer : ShortString;
Begin // SbsFormVer
  Result := ExchequerModuleVersion (emSBSForm, BuildVer_SF);
End; // SbsFormVer

(*********************************************************************************************

VERSION HISTORY
===============

21/08/2017   SBSForm.Dll build 204 for Exchequer 2017 R2
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-18163: Added Head Office PostCode fields

               ACINPOCO - Invoice To - Postcode
               CHCMPOCO - Header - Site Co PostCode (HO)


16/02/2017   FormDes build 071, SbsForm build 203 for Exchequer 2017 R1
--------------------------------------------------------------------------------------------
             ABSEXCH-14925:-

               Added MadExcept Logging in PrintU.PrintFormDef and TForm_PrintTest.PrintBitmap.

               Modified TSBSDragBitmap.OptionsDialog to copy image files using Windows API instead
               of saving the loaded bitmap which was creating .GIF's in Bitmap format.


06/02/2017   FormDes build 070, SbsForm build 202 for Exchequer 2017 R1
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-14925: Added support for extra image types


01/11/2016   SBSForm Build 201 for Exchequer 2017 R1
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-17754: Updated PCC Preview Window toolbar for new branding


14/10/2016   SBSForm Build 200 for Exchequer 2017 R1
             FormDes.Exe Build 069 for Exchequer 2017 R1
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-17754: Updated toolbars for new branding


16/09/2016   SBSForm Build 199 for Exchequer 2016 R3
             FormDes.Exe Build 068 for Exchequer 2016 R3
--------------------------------------------------------------------------------------------
  PS         ABSEXCH-2581 : PDF attachment name has missing digit


22/01/2016   SBSForm Build 197 for Exchequer 2016 R1
--------------------------------------------------------------------------------------------
  PKR        ABSEXCH-17109: Added three new fields for Intrastat, plus two copy fields.
               1121   ACIDEFQR - Intrastat Default to QR
               1122   CUIDEFQR - Intrastat Default to QR - Copy of ACIDEFQR
               2386   THINTOOP - Intrastat Out of Period
               2387   CHINTOOP - Intrastat Out of Period
               3317   TLINNOTC - Intrastat Nature of Transaction Code

10/09/2015   SBSForm Build 196
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-16837: Rewrote the locking mechanism where the printing routine sets
             the printed flag as it was displaying a modal dialog if the transaction was
             locked.  This happened when using Order Payments as the Take Payment window
             displayed when a transaction is stored locks the SOR, this code then displayed
             a MODAL dialog so the user could not finish the payment in order to free the
             lock.

21/07/2015    FormDes Build 067
              SBSForm Build 195
--------------------------------------------------------------------------------------------
  MH         Merged v7.0.14 into 2015-R1

12/05/2015    SBSForm  v7.0.14.191
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-16284: Rebadged the existing PPD Value fields to be Unsigned:-

                2195   THPPDGOU - PPD Goods Value (Unsigned)
                2196   THPPDVAU - PPD VAT Value (Unsigned)
                2197   THPPDTOU - PPD Total Value (Unsigned)

            and added new fields Signed fields to replace them:-

                2206   THPPDGOO - PPD Goods Value (Signed)
                2207   THPPDVAT - PPD VAT Value (Signed)
                2208   THPPDTOT - PPD Total Value (Signed)


12/05/2015    SBSForm  v7.0.14.190
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-16284: Fixed up THPPDTAK and added new fields for Prompt Payment Discounts:-

               1095    ACPPDMO - PPD Mode
               1096    ACPPDMOD - PPD Mode Description

               2199    THPPDTAM - PPD Taken Mode
               2205    THPPDXCR - PPD Credit Note Y/N


26/03/2015   SBSForm v7.0.14.189
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-16284: Added new fields for Prompt Payment Discounts

                2192   THPPDPER - PPD Discount%
                2193   THPPDDAY - PPD Days
                2194   THPPDDAT - PPD Expiry Date
                2195   THPPDGOO - PPD Goods Value
                2196   THPPDVAT - PPD VAT Value
                2197   THPPDTOT - PPD Total Value
                2198   THPPDTAK - PPD Taken Y/N



04/03/2015   FormDes.Exe / SBSForm.Dll
--------------------------------------------------------------------------------------------
  MH         Modified versions for Exchequer 2015 R1


11/02/2015   SbsForm.Dll   v7.1.194
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-16142: Added ISO Country Code fields

               1117 - ACINCTRY - Invoice To - Country Code
               1118 - ACINCTRN - Invoice To - Country Name
               1119 - ACINDCTY - Inv To - Delivery Country Code
               1120 - ACINDCTN - Inv To - Delivery Country Name

               1214 - CUCNTRY - Country Code
               1215 - CUCNTRYN - Country Name

             ABSEXCH-16144: Added ISO Country Code fields

               2190 - CHCMPCTY - Header - Site Co Country (HO)
               2191 - CHCMPCTN - Header - Site Co Cty Name (HO)
               
             ABSEXCH-16145: Added ISO Country Code fields

               3151 - TLORCTRY - Order Country
               3152 - TLORCNTN - Order Country Name


23/01/2015   SbsForm.Dll   v7.1.193
--------------------------------------------------------------------------------------------
  PR         ABSEXCH-16022: VAT Receipts - lines from OPVATPay table included matching lines


23/01/2015   SbsForm.Dll   v7.1.192
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-16062: Customer details not being loaded for VAT Receipts

               2199    THPPDTAM - PPD Taken Mode
               2205    THPPDXCR - PPD Credit Note Y/N

14/01/2015   SbsForm.Dll   v7.1.191
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-15827: Added THOPVATO / THOPVATD


10/12/2014   FormDes.Exe   v7.1.066
             SbsForm.Dll   v7.1.190
--------------------------------------------------------------------------------------------
  MH         Recompiled to pickup updated copyright and merged Order Payments code


26/11/2014
--------------------------------------------------------------------------------------------
  MH         Added new fields added for the ISO 3166 Country Codes:-

               1091 - ACCNTRY - Country Code
               1092 - ACCNTRN - Country Name
               1093 - ACDELCTY - Delivery Country Code
               1094 - ACDELCTN - Delivery Country Name

               2182 - THDELCTY - Delivery Country Code
               2183 - THDELCTN - Delivery Country Name
               2184 - CHDELCTY - Header - Delivery Country Code
               2185 - CHDELCTN - Header - Delivery Country Name
               2186 - CHORDCTY - Hdr - Order Del Country Code
               2187 - CHORDCTN - Hdr - Order Del Country Name

               26013 - COCNTRY - Contact Country Code
               26014 - COCNTRN - Contact Country Name


02/10/2014
--------------------------------------------------------------------------------------------
  MH         Added new fields added for Order Payments

               1089 - ACORDPAY - Allow Order Payments Y/N
               1090 - ACORDPGL - Order Payments GL Code

               ?


19/09/2014   FormDes.Exe   OrdPay.065
             SbsForm.Dll   OrdPay.188
--------------------------------------------------------------------------------------------
  MH         Added Form Definition Set entries for Order Payment Payment/Refunds

             Added new fields for OPVATPay

               27001 - OPSORREF - Order OurRef
               27002 - OPSRCREF - Receipt OurRef
               27003 - OPTRAREF - Transaction OurRef
               27004 - OPLINENO - Line No
               27005 - OPSORLIN - SOR Line No
               27006 - OPTYPE - Row Type
               27007 - OPTYPEDE - Row Type Desc
               27008 - OPCURR - Currency
               27009 - OPDESCR - Description
               27010 - OPVATCOD - VAT Code
               27011 - OPGOODS - Goods Value
               27012 - OPVAT - VAT Value
               27013 - OPUSER - User Name
               27014 - OPDATE - Date Stamp
               27015 - OPTIME - Time Stamp

             Added support for printing VAT Receipts using EFD or PCC formds


08/10/2014   SBSForm v7.0.12.188
--------------------------------------------------------------------------------------------
  MH         Rebadged to v7.0.12


08/09/2014   SBSForm v7.1.188
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-15052: Added new EC Service flag:-

               5095  STECSERV - EC Service Y/N


18/02/2014   SBSForm v7.0.9.186
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-15081: Added missing function into function list


23/01/2014   FormDes v7.0.9.063 / SBSForm v7.0.9.185
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-14974: Added Account Contacts fields for Ledger Multi-Contacts

               26000   COACCODE - Account Code
               26001   CONAME - Contact Name
               26002   COJOBTIT - Contact Job Title
               26003   COPHONE - Contact Phone Number
               26004   COFAX - Contact Fax Number
               26005   COEMAIL - Contact Email Address
               26006   COOWNADD - Contact Has Own Address
               26007   COADDR1 - Contact Address Line 1
               26008   COADDR2 - Contact Address Line 2
               26009   COADDR3 - Contact Address Line 3
               26010   COADDR4 - Contact Address Line 4
               26011   COADDR5 - Contact Address Line 5
               26012   COPOSTCD - Contact Postcode

               26500   RODESCR - Role Description

             Added LOADROLE function into Formula Parser

             Modified Select Field dialog to load Account Contact fields into Account tab


26/11/2013   SBSForm v7.0.8.184
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-14797: Added Consumer fields

                1086 - ACSUBTYP - SubType (C/S/U)
                1087 - ACLONGCO - Long A/C Code
                1088 - CULONGCO - Long A/C Code

28/10/2013   SBSForm v7.0.7.183
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-14705: Added Transaction Originator fields

                2136 - THORUSER - Originating User
                2137 - THCRTIME - Creation Time
                2138 - THCRDATE - Creation Date

                2139 - CHORUSER - Header - Originating User
                2140 - CHCRTIME - Header - Creation Time
                2141 - CHCRDATE - Header - Creation Date

                2142 - CHORDUSR - Header - Order Orig User
                2143 - CHORDCRT - Header - Order Creation Time
                2144 - CHORDCRD - Header - Order Creation Date


18/10/2013   SBSForm v7.0.6.182/FormDes2.exe v7.0.6.062
--------------------------------------------------------------------------------------------
  PR         ABSEXCH-14703: Added Delivery Postcode fields for Accounts and Transaction headers


27/09/2013   SBSForm v7.0.6.181/FormDes2.exe v7.0.6.061
--------------------------------------------------------------------------------------------
  PR         ABSEXCH-14640: Added CC/Dep fields to Job Record


09/09/2013   SBSForm v7.0.6.180
--------------------------------------------------------------------------------------------
  MH         ABSEXCH-14598: Added/Extended fields for SEPA/IBAN support

               ACBNKACC - Bank Account No
               ACBNKSOR - Bank Sort Code
               ACMANDID - Direct Debit Mandate ID          (NEW FIELD)
               ACMANDDA - Direct Debit Mandate Date        (NEW FIELD)

               SYSBANKA - System - Bank Account No
               SYSBANKS - System - Bank Sort Code


12/07/2013   FormDes v7.0.5.060
             SBSForm v7.0.5.179
--------------------------------------------------------------------------------------------
  MH         Rebranded for Advanced


20/11/2012   SBSForm v7.0.178
--------------------------------------------------------------------------------------------
  MH	     Updated main toolbar graphics


12/09/2012   FormDes v7.0.059
--------------------------------------------------------------------------------------------
  MH	     Updated main toolbar graphics


03/08/2012   FormDes v7.0.058
--------------------------------------------------------------------------------------------
  MH	     7.0/ABSEXCH-12952/81.03: Modified colours on main Form Designer Toolbar to give
             a flattened look.


16/04/2012   SbsForm v6.10.177
--------------------------------------------------------------------------------------------
  MH	     ABSEXCH-12804: Turn on Shortcut Boolean Evaluation to stop error in PCC Forms


13/02/2012   RepEngine v6.10.242
--------------------------------------------------------------------------------------------
  PR	Exch	 Added handling to DicLinkU.pas for new THOSACTV field.


12/03/2012   SbsForm v6.10.176
--------------------------------------------------------------------------------------------
  MH	     ABSEXCH-11937: Stash reports locally in Windows\Temp folder rather than uploading
             them to the network Exchequer\Swap folder, this should improve performance and lower
             network traffic slightly.


01/03/2012   SbsForm v6.10.175
--------------------------------------------------------------------------------------------
  MH	     Added TLTHRESH - Threshold Code


28/02/2012   SbsForm v6.10.174
--------------------------------------------------------------------------------------------
  MH	     Modified printing to support 32,000 pages up from 9,999



01/02/2012   SbsForm v6.9.173; FormDes v6.9.057
--------------------------------------------------------------------------------------------
  PR	Exch	 Rebuilt to fix ABSEXCH-12466. (Seems to be a change somewhere in the code has
		 accidentally fixed it.)

15/11/2011   SbsForm v6.9.172
--------------------------------------------------------------------------------------------
  MH    Exch     Modified Account Details, Job Record, Stock Notes and Transaction Notes jobs
                 to suppress the Audit Notes


03/11/2011   SbsForm v6.9.171
--------------------------------------------------------------------------------------------
  MH    Exch     Fixed fault with Line Type DD Fields


25/10/2011   SbsForm v6.9.170
--------------------------------------------------------------------------------------------
  MH    Exch     Modified to use new Custom Fields object


01/04/2011   SbsForm v6.7.168  ABEXCH-10689
--------------------------------------------------------------------------------------------
  MH    Exch     Modified Trader Bank/Card data dicitonary fields to support the new user
                 permissions for viewing them.


09/02/2011   SbsForm v6.6.167
--------------------------------------------------------------------------------------------
  MH    Exch     Recompiled to pick up changes to printer components for ABSEXCH-10547


06/12/2010   SbsForm v6.5.165
--------------------------------------------------------------------------------------------
  MH    Exch     ABSEXCH-10578: Added support for Adobe Acrobat 10


02/12/2010   SbsForm v6.5.164
--------------------------------------------------------------------------------------------
  MH    Exch     ABSEXCH-10578: Added support for Adobe Acrobat 9


13/10/2010  SbsForm v6.5.163
--------------------------------------------------------------------------------------------
  MH    Exch     Added new Data Dictionary Field for Web Extensions project:-

                   2121   THOVRLOC - Override Location


21/07/2010  SbsForm v6.4.162
--------------------------------------------------------------------------------------------
  MH    Exch     ABSEXCH-10050: Modified Sorted Consolidated Picking Lists to consolidate the
                 lines, this had previously been incorrectly believed to be done within Enter1.

                 Also modified the consolidation mechanism to ignore non-stock lines as
                 consolidating them makes no sense.


08/06/2010  SbsForm v6.4.161
--------------------------------------------------------------------------------------------
  MH    Exch     ABSEXCH-7916: Modified statements to use ledger index to define order


06/05/2010  SbsForm v6.3.160
--------------------------------------------------------------------------------------------
  MH    Exch     Fixes 'Sort by Component - Location and Stock Code Order' sorting to check
                 Stock Code on Stock Location record as well as Location Code


23/03/2010  FormDes.Exe v6.3.055  SbsForm v6.3.159
--------------------------------------------------------------------------------------------
  MH    Exch     Added 'Sort by Component - Location and Stock Code Order' into Transaction Sorting options.


10/03/2010  SbsForm v6.3.158
--------------------------------------------------------------------------------------------
  MH    Exch     Recompiled to pickup a Windows 7 date fix in ETDateU


09/03/2010  SbsForm v6.3.157
--------------------------------------------------------------------------------------------
  MH    Exch     Modified TForm_PrintTest.GetFieldText and TForm_PrintTest.FormatDate in EFD
                 printing to repair relational links to location and stock-location records.


03/03/2010  SbsForm v6.3.156
--------------------------------------------------------------------------------------------
  MH    Exch     Modified the Transaction Line sorting routines to bring in Bin Location details
                 from the Stock Location record where relevant. (ABSEXCH-7937)


01/02/2010  SbsForm v6.3.155
--------------------------------------------------------------------------------------------
  MH    Exch     Added new Data Dictionary Fields for Web Extensions project:-

      2119   THWKMNTH - Week/Month
      2120   THWKFLOW - Workflow State

      3232   TLREFRNC - Reference
      3233   TLRCPTNO - Receipt No
      3234   TLFROMPC - From Postcode
      3235   TLTOPC - To Postcode

      11535  EMEMAIL - Employee Email Address


04/09/2009 SbsForm v6.2.154
--------------------------------------------------------------------------------------------
  MH    Exch     A bug in TLECSTAX and TLPRSTAX meant that they always showed as blank


26/08/2009 SbsForm v6.2.153
--------------------------------------------------------------------------------------------
  MH    Exch     Added new data dictionary fields for new v6.2 fields:-

      3227   TLSERVIC - Is EC Service?
      3228   TLSERSTA - EC Service Start Date
      3229   TLSEREND - EC Service End Date
      3230   TLECSTAX - EC Sales Tax Reported
      3230   TLPRSTAX - Purchase Reverse Charge Service Tax

      90048  SYSECSRV - Enable EC Services Support
      90049  SYSTHRSH - EC Sales List Threshold
      

23/06/2009 SbsForm v6.01.151
--------------------------------------------------------------------------------------------
  CS    Exch/IAO  Recompiled to pick up changes to temporary file handling for
                  SQL.


16/06/2009 SbsForm v6.01.151
--------------------------------------------------------------------------------------------
  MH    Exch/IAO  Modified TTD/VBD/MBD data dictionary fields for EPOD:-

           3221 - TLMBDSCS - Multi-Buy Discount (String)
           3223 - TLMBDSC - Multi-Buy Discount (Value)
           3224 - TLMBDSCT - Multi-Buy Discount (Type)

           3222 - TLTTDSCS - TTD/VBD Discount (String)
           3225 - TLTTDSC - TTD/VBD Discount (Value)
           3226 - TLTTDSCT - TTD/VBD Discount (Type)


11/05/2009 SbsForm v6.01.150
--------------------------------------------------------------------------------------------
  MH    Exch/IAO  Removed hints from toolbar buttons in print preview window as they were
                  causing exceptions - no idea why it has only been discovered now.


03/04/2009 SbsForm v6.01.149
--------------------------------------------------------------------------------------------
  MH    Exch/IAO  Modified the TLBOMSTK field to only print if there is a stock code on the
                  line because it was printing for Additional Description Lines which also
                  use KitLink.


02/04/2009 SbsForm v6.01.148
--------------------------------------------------------------------------------------------
  MH    Exch/IAO  Various fixes to Picking Lists mods below (147) where the Sorted Picking List
                  wasn't printing Serial/Batch for the last line, or for any line except the last
                  in a block of lines with the same serial number.  Also found a but where
                  due to a missing Begin..End it was counting all serial/batch found against the
                  line instead of just those allocated to the line.

                  Extended Multi-Bin Picking Lists to pass the KitLink into the temporary file
                  so that the TLBOMSTK field added in 147 worked.

                  Added new data dictionary fields for Advanced Discounts:-

                    3221 - TLMBDISC - Multi-Buy Discount
                    3222 - TLTTDDSC - TTD/VBD Discount

23/03/2009 FormDes v6.01.054
           SbsForm v6.01.147
--------------------------------------------------------------------------------------------
  MH    Exch/IAO  Extended Picking Lists to include support for Hidden Bill of Materials Lines.


20/11/08  SbsForm v6.10.146
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Merged in 3 new fields for the Job Budget Currency that PR added for MD Events


13/11/08  SBSForm v6.00.145
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Correcting sharing permissions when opening form xml files


05/11/08  SBSForm v6.00.144
--------------------------------------------------------------------------------------------
  PR    Exch/IAO   Faxing Fix


28/02/08  SBSForm v6.00.143
--------------------------------------------------------------------------------------------
  CS    Exch/IAO   Corrected saving of PrintIf fields for Boxes and Page Numbers.


04/01/08  FormDes v6.00.053
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Modified Continuation Selection dialog to support EFX instead of EFD


11/12/07  SbsForm v6.00.142
--------------------------------------------------------------------------------------------
  CS    Exch/IAO   PrintIf statements on Table Field Columns were being stored
                   against the wrong XML tag name ('fiIf' instead of 'fdIf')
                   and were consequently being lost when the form was opened.


12/09/07  SbsForm v6.00.141
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Modified Register.GetFormHeader to check that the file exists before trying
                   to open it.  This was because a Picking List Run using PCC forms was calling
                   it at some point and it was trying to open an EFX file that didn't exist.


31/07/07  FormDes v6.00.052
          SbsForm v6.00.140
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Rebuilt to pickup the new Toolbar components and runtime packages


16/07/07  SbsForm v6.00.139
--------------------------------------------------------------------------------------------
  MH    Exch       Modified TXMLInterface.CreateXMLFile in XMLInt.Pas to remove the filename
                   from the output directory which was causing errors when printing ranges of
                   documents to xlm.  BUG 20060912103116.


12/07/07  SbsForm (v5.71/v6.00)
--------------------------------------------------------------------------------------------
  MH    Exch       Modified DicLinkU.CISVTypeName for the JVTYPE field to reflect changes in
                   names.


07/06/07  FormDes v6.00.051
          SbsForm v6.00.138
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Modified to support HTML Help which required FormDes.Exe sharing the
                   Screen instance with SBSForm via the new sbsForm_ShareScreen function.

                   Went through all the forms in the project changing the font where necessary
                   to Arial.


01/06/07
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Modified the following cheque fields for bug 20070207103504 to allow -ve
                   cheque's to be printed as positive:-

                     2319  CHL1AMTX   Header - L1 word Amt exc pence
                     2320  CHL2AMTX   Header - L2 word Amt exc pence
                     2321  CHL1AMTI   Header - L1 word Amt inc pence
                     2322  CHL2AMTI   Header - L2 word Amt inc pence

                     2337  CHCTAMT    Header - Cheque Text Amount

                     2338  CHCTUNIT   Header - Cheque Text Units
                     2339  CHCTTENS   Header - Cheque Text Tens
                     2340  CHCTHUND   Header - Cheque Text Hundreds
                     2341  CHCTTHOU   Header - Cheque Text Thousands
                     2342  CHCT10TH   Header - Cheque Text 10,000's
                     2343  CHCT100T   Header - Cheque Text 100,000's
                     2344  CHCTPENC   Header - Cheque Text Pence
                     2373  CHCTMILL   Header - Cheque Text Millions
                     2374  CHCT10M    Header - Cheque Text 10 Mills
                     2375  CHCT100M   Header - Cheque Text 100 Mills


30/05/07
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Added new fields for bug 20070501235126:-

                     2115  CHUSER1 - User Defined Field 1
                     2116  CHUSER2 - User Defined Field 2
                     2117  CHUSER3 - User Defined Field 3
                     2118  CHUSER4 - User Defined Field 4


24/05/07  SbsForm v6.00.137
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Modified YourRef fields to support 20 chars

                     18008  MPALTREF    Matching - Alternate Reference


23/05/07  SbsForm v6.00.136
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Modified YourRef fields to support 20 chars

                     2012   THREFSHR    Your Ref (Short)
                     2067   THTRYOUR    Your Ref (Truncated)
                     2312   CHREFSHR    Header - Your Ref (Short)
                     2378   CHORDYOU    Header - Order Your Ref

                     3092   TLORYREF    Order Your Ref (Short)


22/05/07  SbsForm v6.00.135
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Modified GetFormCopies, GetFormOrient and GetFormInfo to support EFX forms
                   as Chris had missed them causing everything to print one copy in Portrait
                   to the default printer :-)


11/05/07  SbsForm v6.00.134
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Modified GetTermsLineBudget for TLJxTBUD as the methodology it was using
                   to load the line was only working for JPA's coming from a JPT.


09/05/07  SbsForm v6.00.133
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Modified Remittance Advice's to load matching differently for -ve SRC's
                   as they need to use Idx 0 instead of Idx 1.


01/05/07  SbsForm v6.00.132
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Modified to pickup Dictnary.Dat from main dir only


01/05/07  FormDes v6.00.050
          SbsForm v6.00.131
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Rebuilt with v6.00 structures


07/03/07  SbsForm v5.71.130
--------------------------------------------------------------------------------------------
  MH    Exch       Added EMSUBTYP - CIS340 Subcontractor Type


13/02/07  SbsForm v5.71.129
--------------------------------------------------------------------------------------------
  MH    Exch       Added TLJXTBUD - JxA Terms Budget


30/01/07  Formdes v5.71.049
          SbsForm v5.71.128
--------------------------------------------------------------------------------------------
  MH    Exch       Changed to release version numbers


29/01/07  SbsForm 128
--------------------------------------------------------------------------------------------
  MH    Exch       Added JVOURCTR - Our Constructor Tax Reference


25/01/07  SbsForm 127
--------------------------------------------------------------------------------------------
  MH    Exch       Added JVSCHREF - CIS Scheme Reference No


14/11/06  SbsForm 126
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Corrected 'Exchequer Enterprise Demo' bitmap to be 'Exchequer' and added
                   an IAO bitmap


09/11/06  SbsForm 125
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Modified sorting for Transaction Forms and Picking Lists to sort non-stock
                   items at the top
                   

09/11/06  Formdes 049
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Modified Form Options dialog as the Printers Default Paper wasn't being
                   imported correctly.


08/11/06  Formdes 048 / SbsForm 124
--------------------------------------------------------------------------------------------
  MH    Exch/IAO   Extended Single and Consolidated Picking Lists to support sorting.

                   Added Mouse Wheel support into Print Preview dialog.

                   General re-organisation of Form Options dialog to make space for
                   enhanced comments on options.

                   Reset the ADJ and Sorting options to None on selection of Serial/Batch/Bin
                   checkbox. 

                   Fixed bug in Form Options where certain sizes (119x420) caused the paper
                   and labels images to go off the side of the available area.


03/11/06  SbsForm 123
--------------------------------------------------------------------------------------------
  MH     Exch      Added new data dictionary field for Wish 20060607153710:-

                     ACUSEEB - Use this A/C for e-Business


01/11/06  SbsForm 122
--------------------------------------------------------------------------------------------
  MH     Exch      Modified the wording of the CIS Forms within the System Setup - Form Definition
                   Sets dialog for CIS340 compatibility.

                   Corrected fonting to Arial in System Setup - Form Definition Sets dialog

                   Added new data dictionary fields:-

                     11531  EMUTR - Employee Unique Tax Ref
                     11532  EMVERIFY - Employee HMRC Verification No
                     11533  EMTAG - Employee Tag

                     22026  JVVERIFY - CIS Voucher Verification No
                     22027  JVHIGHTX - CIS Voucher High Tax Indicator
                     22028  JVTAXRAT - CIS Voucher Tax Rate


26/10/06  SbsForm 121
--------------------------------------------------------------------------------------------
  MH   IAO/Exch    Modified the calculation of pounds and pence for the individual checque
                   units fields to comply with the 120 mods.

                   Modified the cheque words and invidual fields to retun 0.00 for -ve amounts


18/10/06  SbsForm 120
--------------------------------------------------------------------------------------------
  MH   IAO/Exch    Modified the calculation of pounds and pence for the cheque words fields
                   to minimise the chance of rounding errors causing the words to be different
                   to the printed value.


04/09/06  FormDes 047
          SbsForm 119
--------------------------------------------------------------------------------------------
  MH   IAO/Exch    Added two new Picking list options into the Form Options dialog:-

                      Include Non-Stock Items in Individual Picking Lists
                      Include new lines in Individual Picking Lists

  MH   IAO/Exch    Modified Single Picking Lists (EFD & PCC) to support the 'Include new lines
                   in Individual Picking Lists' flag - doesn't appear to apply to Consolidated
                   Picking Lists as they are part of the process that sets the run number -
                   doesn't appear to apply to multi-bin picking lists as they weren't checking
                   the run number anyway.  PCC flag  = INCLNEW

  MH   IAO/Exch    Corrected Single Picking Lists (EFD & PCC) so that additional description
                   lines on a description line are suppressed.

  MH   IAO/Exch    Modified Single Picking Lists (EFD & PCC) to support the 'Include Non-Stock
                   Items in Individual Picking Lists' flag.  PCC flag = DESCONLY


10/07/06  SbsForm 118
--------------------------------------------------------------------------------------------
  MH   LITE        Modified the printing routines to reset Hide Line Types to False for LITE


10/07/06  SbsForm 117
--------------------------------------------------------------------------------------------
  MH   LITE        Modified the printing routines to reset Hide Line Types to False for LITE


10/05/06  SbsForm 116
--------------------------------------------------------------------------------------------
  MH   LITE        Hid the Load As XRef checkbox on the Select DB Field dialog at EPODs request

  MH   Exch/LITE   Added new data dictionary fields:-

                     4010  NMCLASS   Nominal Class
                     4011  NMCLASSN  Nominal Class Number


10/05/06  SbsForm 115
--------------------------------------------------------------------------------------------
  MH   LITE        Suppressed Locations, Serial/Batch and Job Costing tabs on the Select DB
                   Field dialog for IAO.


09/05/06  SbsForm 114
--------------------------------------------------------------------------------------------
  MH   Exch/LITE   3 Years and 4 Months to the day after doing a QASUB on the JV fields it was
                   reported they weren't being shown in the Select DB Fields list.

                   I tracked this to the fact that they were only being loaded when CISOn was
                   True and this flag never gets set in SbsForm.Dll!

                   I have now modified FF_Loadsys in FormFile.Pas to set this and the other
                   flags as well.


02/05/06  FormDes 046
--------------------------------------------------------------------------------------------
  MH   Exch/LITE   Fixed a bug with the new "Mark Transactions as printed on Debt Chase Letters"
                   flag on the Form Options dialog (which doesn't appear to be documented below!)



12/04/06  SbsForm 113
--------------------------------------------------------------------------------------------
  MH   Exch/LITE   Fixed the printing of Formula Columns in Tables as they were not running
                   the convertor functions for Barcodes at all.  (Only took 8 years to spot!)
                   BUG 20051215150256

  MH   Exch/LITE   Added CUPOSTCD field for HBP.
                   WISH 20050909125038



21/03/06  SbsForm 112
--------------------------------------------------------------------------------------------
  MH   Exch/LITE   Changed the popup selection list to suppress fields inapplicable to LITE


23/02/06  SbsForm 111
--------------------------------------------------------------------------------------------
  MH   Exch/LITE   Added CHDAYRAT and CHCORATE for Brakely



14/02/06  FormDes 044
------------------------------------------------
  MH   Exch/LITE   Modified the Stock Adjustment and Transaction Line Sorting
                   combo boxes so that for LITE the Location options are automatically
                   filtered out.


09/02/06  FormDes 043 / SbsForm 110
------------------------------------------------
  MH   Exch/LITE   Modified versioning to auto-switch between Exchequer and LITE

  MH   LITE        Modified Caption of main Formdes window to not contain 'Exchequer'

  MH   LITE        Modified Form Options dialog to suppress the Serial/Batch and Bin
                   information om the Options tab.

  MH   LITE        System Setup - Form Definition Sets:-

                     1) Rebadged to 'Default Forms'

                     2) Hid the list of sets and now directly edits the Global Form
                        Definition Set.

                     3) Modified the tree in the edit window to suppress elements
                        not present in LITE.

                     4) Hid set number/name fields in the edit window.

  MH   Exch/LITE   Form Definition Set Detail:-

                     1) Changed file types in browse dialog to be 'Form Designer
                        Forms' & 'PCC Forms' - previously prefixed with 'Exchequer'

                     2) Corrected Tab Order

  MH   Exch/LITE   System Setup - Printer Control Codes:-

                     1) Modified phrasing to eliminate 'Exchequer'

                     2) Added 'Edit Printer Codes' button which provides access to
                        the character codes used by PCC printing.

  MH   LITE        System Setup - Email/Fax Signatures:-

                     1) Removed Fax from title

                     2) Hid Fax Signature and adjusted form to avoid gray hole.


22/09/05  FormDes  v5.70.042
          SBSForm  v5.70.109
------------------------------------------------
  MH  Released for v5.70


02/09/05  SbsForm b570.109
------------------------------------------------
  MH  Changed TLOURREF as it was incorrectly taking the OurRef from Inv
      instead of Id - and Inv isn't necessarily going to be for the same
      transaction as TL fields don't cause the TH to load if the report/
      form is printing off Details.Dat.


31/08/05  SbsForm b570.108
------------------------------------------------
  MH  Added missing discount fields for date based discounts:-

        DISTDATE  20013   Start Date
        DIENDATE  20014   Start Date
        DIUSDATE  20015   Use Dates


30/08/05  SbsForm b570.107
------------------------------------------------
  MH  Added new fields for Goods Returns Repair mods:-

        TLREPPRC  003311   xRN - Replacement Price
        TLREPUCO  003312   xRN - Repair Unit Cost


09/08/05  SbsForm b570.106
------------------------------------------------
  MH  Added STRECHFL - Returns-Recharge Flag


21/07/05  FormDes  b570.042  SbsForm b570.105
------------------------------------------------
  MH  Updated version numbers for v5.70 build

  MH  Added v5.70 data dictionary fields for Goods Returns


06/04/05  SbsForm v5.61.104
-----------------------------
  HM  Modified label printing so that SYSTOT0 contains the current label number
      and SYSTOT1 contains the number of labels being printed.  Therefore using
      the formula "DBF[SYSTOT0] + "_of_" + DBF[SYSTOT1] your can print '1 of 3',
      '2 of 3', ... on your labels.
      NOTE: For Hart Wholsale via Training/KHorlock.


02/02/05  SbsForm v5.61.103
-----------------------------
  HM  Rebuilt for v5.61 CD


31/01/05  SbsForm b560.101
-----------------------------
  HM  Added new dd fields:-

    ACINCONT  001114   Invoice To - Contact           S    25   0
    ACFORMNO  001115   Form Set Number                B     3   0
    TLDEDQTY  003217   Stock Deduct Qty               R    13   6


25/01/05 SbsForm b560.100
-----------------------------
  HM  Modified emailing code to leave EntComms.Dll in memory when running VAO


24/01/05 SbsForm b560.099
-----------------------------
  HM  Changed rounding in Print_SuggestBin as customers (AdCo) had experienced
      infinite loops in a similar loop in Enterprise.


04/11/04 SbsForm v5.60.102
-----------------------------
  HM  Added a 'Disable Printed Status' flag into TSBSPrintSetupInfo to allow
      Authoris-e to NOT set the Printed Status when it prints transactions for
      authorisation.


23/09/04 SbsForm v5.60.101
-----------------------------
  HM  Mods to further Apps & Vals fields which took fields off the transaction
      header, these obviously didn't work when printing a SIN/PIN and the values
      are now cached in the Apps&Vals Totals object:-

        THCERTOT  - JxA Certified Total YTD
        THCERAMT  - JxA Certified Amount
        THCONTOT  - JxA Contras Total
        THCUMTOT  - JxT Cumulative Total
        THBASIS*  - JxT Basis
        THATR*    - JxT ATR Flag
        THDEFVAT* - JxT Defer VAT Flag
        THAPPDED  - JxA Applied Deductions YTD
        THAPPRET  - JxA Applied Retentions YTD
        THSTAGE* - JxT Stage

      The fields marked with * aren't accumulated numbers and return the value
      from the last Application processed.


23/09/04 SbsForm v5.60.100
-----------------------------
  HM  Mods to Apps & Vals fields for Brennan's so that for SIN/PIN it looks
      up the JxA transactions in Matching.


22/09/04 FormDes v5.60.041
         SbsForm v5.60.099
-----------------------------
  HM  Released for v5.60.001


09/08/04 SbsForm b560.098
-----------------------------
  HM  5-Star bug 472562003811091140, Added new data dictionary fields:-

        MLWOPWIP   8124   WOP - WIP GL Code              L     9   0
        SLWOPWIP  17046   WOP - WIP GL Code              L     9   0


03/08/04 SbsForm b560.097
-----------------------------
  HM  Modified TAppValTotals.CalcTotals in oAppVals.Pas as it was failing to
      find any lines for Jxx transactions if there were no Retentions.


27/07/04 SbsForm b560.096
-----------------------------
  HM  Added new dd field for Last Payment/Receipt date which scans the trans
      database and returns the last SRC or PPY date for the account, added for
      Reliable Data, wish list item 200431124150:-

        ACLASTPA  001074   Last Payment/Receipt Date      D     8   0


26/07/04 SbsForm b560.095
-----------------------------
  HM  Added OrigPrnCust in DicLinkU.Pas to store the original customer loaded
      in LinkCust for use on Remittance Advices when factoring (Remit To) is
      being used:-

        OCACC     1300   Account Code                   S     6   0
        OCCOMP    1301   Company Name                   S    45   0
                  

26/07/04 SbsForm b560.094
-----------------------------
  HM  Modified the Printed Status routines in PrnBatch.Inc and PrintPCC.Pas to
      share a common DocSet in PrntForm.Pas as PrintPCC.Pas had fallen behind
      PrnBatch.Inc for the documents for which it set the printed status.  Also
      added PQU/SQU/PPY into the DocSet. (Bug 2004325101734)


05/07/04 SbsForm b560.093
-----------------------------
  HM  Added mechanism using data dictionary fields to allow 5-Star to specify
      that GINVNOT should load the notes for the Invoice on a remittance advice
      line rather than for the payment itself:-

        SYSNOTE0  090046   System - Standard Notes        S     1   0
        SYSNOTE1  090047   System - Notes From Table      S     1   0


14/05/04 FormDes  v5.60.040
         SbsForm  v5.60.092
-----------------------------


20/04/04 SbsForm b560.092
-----------------------------
  HM  Rebuilt to pickup new DD Fields added for the RW


22/03/04 SbsForm b560.091
-----------------------------
  HM  Added Print to HTML support


19/03/04 SbsForm b560.090
-----------------------------
  HM  Added Data Dictionary fields for Apps & Vals:-

        THAPPDED  002700   JxA Applied Deductions YTD     R    13   2
        THAPPRET  002701   JxA Applied Retentions YTD     R    13   2
        THCITBPR  002703   JxA Previous CITB Levy Amount  R    13   2
        THLTNORM  002704   JxA 'Normal' Total             R    13   2

15/03/04 SbsForm b560.089
-----------------------------
  HM  Added Data Dictionary fields for Apps & Vals:-

        THSTAGE - JxT Stage

01/03/04
   ->
09/03/04 SbsForm  b560.087
-----------------------------
  HM  Added Data Dictionary fields for Apps & Vals:-

        THCERTOT  002269   JxA Certified Total YTD        R    13   2
        THCERAMT  002270   JxA Certified Amount           R    13   2
        THCITBLP  002271   JxA CITB Levy Percentage       R     7   2
        THCITBLA  002272   JxA CITB Levy Amount           R    13   2
        THDISCPE  002273   JxA Discount Percentage        R     7   2
        THCISRAT  002274   CIS VAT Rate                   R    13   2
        THRETNPE  002275   JxA Retention Percentage       R     7   2
        THRETTOT  002276   JxA Retention Total            R    13   2
        THAPPTOT  002277   JxA Applied For Total          R    13   2
        THDSCTOT  002278   JxA Discount Total             R    13   2
        THDSCYTD  002279   JxA Discount Total YTD         R    13   2
        THRETRTO  002280   JxA Retention Release Total    R    13   2
        THRETRYT  002281   JxA Retention Release YTD      R    13   2
        THCONTOT  002282   JxA Contras Total              R    13   2
        THAPPYTD  002283   JxA Applied For Total YTD      R    13   2
        THLTMAT1  002284   JxA 'Materials 1' Total        R    13   2
        THLTMAT2  002285   JxA 'Materials 2' Total        R    13   2
        THLTLAB1  002286   JxA 'Labour 1' Total           R    13   2
        THLTLAB2  002287   JxA 'Labour 2' Total           R    13   2
        THLTRET1  002288   JxA 'Retention 1' Total        R    13   2
        THLTRET2  002289   JxA 'Retention 2' Total        R    13   2
        THLTDED1  002290   JxA 'Deduction 1' Total        R    13   2
        THLTDED2  002291   JxA 'Deduction 2' Total        R    13   2
        THLTDED3  002292   JxA 'Deduction 3' Total        R    13   2
        THLTCIS   002293   JxA 'CIS' Total                R    13   2
        THLTMIS1  002294   JxA 'Misc 1' Total             R    13   2
        THLTMIS2  002295   JxA 'Misc 2' Total             R    13   2
        THCUMTOT  002296   JxT Cumulative Total           R    13   2
        THBASIS   002297   JxT Basis                      S    20   0
        THATR     002298   JxT ATR Flag                   Y     3   0
        THDEFVAT  002299   JxT Defer VAT Flag             Y     3   0

        TLCERYTD  003213   JxT Certified Total YTD        R    13   2
        TLLINTYP  003214   Printed Line Type Desc         S    20   0

  HM  Added creation time field for an Irish Trade Counter site who'd thrown
      the teddy out of the pram:-

        TCTIME    2908   Trade Counter - Creation Time  S     8   0

  HM  Extended following field so that it is available in the RW:-

        ACINVDM   1073   Invoice Delivery Mode

16/01/04 SbsForm  b560.086
-----------------------------
  HM  Changed AdjustTable for EFD and PCC form printing to force the table
      index to IdFolioK for Single Picking Lists as Eduardo was using different
      indexes from different places.


14/01/04 FormDes  b560.040
         SbsForm  b560.085
-----------------------------
  HM  Added new tab into Form Options for the flag to show desc lines on
      picking lists.

  HM  Added an @DESC Y flag within the .DEF for showing desc lines on
      Picking Lists.  NOTE: If used in conjunction with @BIN then @DESC
      must preceed @BIN in the list of commands.

  HM  Extended the standard picking list for EFD/PCC to implement the flag.

  HM  Extended the Multi-Bin Picking Lists for EFD/PCC to implement the
      Show Desc Lines flags.

  HM  Changed the label printing routines to automatically load InvF and
      StockF when printing IDetailF labels as the links from ID to
      Alternate Stock Codes were failing.


12/01/04 Sbsform  b552.084
-----------------------------
  HM  Added support for Health Industry Bar Code (HIBC)

  HM  Extended Get_OrigOrdAddr in DicLinkU so that it looks up the
      order number in the matching table if the YourRef does not link
      to a valid transaction.


18/11/03 Formdes  v5.52.039
         Sbsform  v5.52.083
-----------------------------
  HM  Released with v5.52


11/11/03 Sbsform  b552.083
--------------------------
  HM  Modified Picking Lists to support Locations - Oops!


06/11/03 Sbsform  b552.082
--------------------------
  HM  Modified detection of Picking List Run to use specific flag passed
      across by EL rather than the number of items in the print job.


06/11/03 Formdes  b552.039
         Sbsform  b552.081
--------------------------
  HM  Rewrote Picking List support to support Show All Stock, Picked &
      Unpicked and Sorting by Stock Code.


24/09/03 Sbsform  b552.080
--------------------------
  HM  Modified Print_SuggestBin in DocSort.Pas for changed mode meanings
      according to EL's instructions.


17/09/03 SbsForm  b552.079
--------------------------
  HM  Modified Bin Selection routine used by Serial Docs/Picking Lists on
      EL's instruction.


09/09/03 FormDes  b552.038
         SbsForm  b552.078
--------------------------
  HM  Rewrote Options dialog in Form Options to provide extended options for
      Use By Date and Multi-Bins

  HM  Modified Doc with Serial No's mode to kick-in if Bins are turned on in
      the Form Options and checked the scratch file generation to include Bins
      and check the user By date flag.

  HM  Added Mutli-Bin fields (BR) into Data-Dictionary

  HM  Added BR Mutli-Bin fields into the Serial Tab on the select field dialog

  HM  Added new Picking List Modes for Single and Consolidated Picking lists
      which kick-in if the Show Bins flag is ticked on the form.

  HM  Updated PCC printing to handle the modified Serial/Bin and Picking List
      routines.

  HM  Updated Tech Support report to include the Serial Number and sorting info


29/08/03 SbsForm  b552.077
--------------------------
  HM  Modified the Adobe Acrobat 6.0 routines as the registry key being used
      isn't created as standard, but appears to be accidentally created due
      to a bug!


18/08/03 SbsForm  b552.076
--------------------------
  HM  Fixed CHPAYREF and THPAYREF which were incorrectly extracting the Pay Ref
      from posted trasactions.

  HM  Added new DD fields for nominal record:-

        NMINACTV   4053   Inactive Flag
        NMFORCJC   4054   Force Job Code


15/08/03 SbsForm  b552.075
--------------------------
  HM  Modified SendEmailFile2 in PrntForm.Pas to support Adobe Acrobat 6.0
      using the Adobe PDF printer driver because the old PDF Writer printer
      driver is no longer supplied.


12/08/03 FormDes  b552.037
         SbsForm  b552.074
--------------------------
  HM  Extended Localised Form Designer version number and change history
      within this file.


04/08/03 SbsForm b552.073
--------------------------
  HM  Extended Form Designer DLL to support printing Standard Reports to
      Excel format files.


11/07/03 SbsForm b552.072
--------------------------
  HM  Fixed a bug in Statement Runs for 5-Star where continuation forms were
      not picking up the data within the scratch file.


27/06/03 FormDes v5.51.036
         Sbsform v5.51.071
--------------------------
  HM  Released for v5.51


23/06/03 Sbsform b551.070
--------------------------
  HM  Fixed rounding on SLCOST and SLREORPR fields from 2dp to cost decs.

11/06/03 Sbsform b551.069
--------------------------
  HM  Fixed bug in control code printing - forgot to remove the '*' from
      the formula.


05/06/03 SbsForm b551.068
--------------------------
  HM  Extended Formula processing to allow control codes to be sent to the
      printer by setting up a formula like this - *[27][32][145] etc...


30/04/03 SbsForm b550.064
--------------------------
  HM  Reversed out the mods 0n 14/03/03 for factoring as they apparently 
      break the Statement To system.


26/03/03 SbsForm v5.50.063
--------------------------
  HM  Added new dd field:- 

        11527   EMCISTYP   CIS Certificate Type

24/03/02 FormDes v5.50.035  SbsForm v5.50.062
---------------------------------------------
  HM  Released for v5.50 CD


20/03/03 SBSForm b550.062
-------------------------
  HM  Fixed page change bug in report drill-down


18/03/03 SbsForm b550.061
-------------------------
  HM  Added JVMONTH for CIS Voucher forms
  

18/03/03 SBSForm b550.060
-------------------------
  HM  Removed debug message from substring func added in .056 for PCC Forms.


14/03/03 SBSFORM b550.059
-------------------------
  HM  Modified LinkCust in PrnBatch.Inc as it was incorrectly handling the 
      Remit To situation so that the AC and CU fields both containing the
      supplier being Remit To'd whereas the CU fields should contain the
      original supplier.


21/01/03 SBSFORM b550.057
-------------------------
 HM   Added v5.50 data dictionary fields for TH, TL, EM, AN, JE, JA and JB.


 -> SBSFORM b550.056
--------------------
 HM   Added CIS Vouchers into Form Definition Sets

 HM   Added support for CIS Voucher Mode (30) 

 HM   Added substring function into PCC Printing


Released for v5.01 as v5.01.052
-------------------------------

25/10/02 SBSFORM b500.052
-------------------------
 HM   Added new fmSerialLabel mode for printing Serial Number labels.

 HM   Modified the setting of Printed Status to include more transaction
      types.

04/09/02 SBSFORM b500.051
-------------------------
 HM   Modified the Data Selection in TForm_PrintTest.Include for Single 
      Picking Lists to exclude Free Issue Stock on WOR's. 

26/07/02 SBSForm b500.050
-------------------------
 NF   Updated icons on PCC Preview screen for Win XP look and feel 

18/07/02 SBSForm b500.049
--------------------------
 HM   Added support for the RpPro bitmap caching into the Form Designer
      PrintBitmap routine.  This means that only one instance of a bmp
      will be placed into the temprary file reducing file sizes.

09/07/02 SBSForm b500.048
--------------------------
 HM   Fixed TLPAYREF which didn't work on posted transactions.

18/06/02 SBSForm v5.00.047
--------------------------
 HM   Released for Enterprise v5.00.001

06/06/02 Formdes v5.00.033
--------------------------
 HM   Released for Enterprise v5.00.001


30/05/02 FormDes b500.033
-------------------------
  HM  Embedded the XP Manifest within the main form to workaround the XP Bug
      that causes "The parameter is incorrect" error message when using external
      manifest files.


16/05/02 SBSFORM b500.047
-------------------------
 HM   Added two data dict fields to workaround problems with rounding on line
      discounts when > 2dp are being used.

        TLUNNET3  3205  Unit Net Val Inc Line Disc 6dp 
        TLUNNET4  3206  Unit Net Val Inc Stl Disc 6dp  


14/05/02 SBSFORM v5.00.046
--------------------------
 HM   Released for Enterprise v5.00.001


14/05/02 SBSFORM b500.046
-------------------------
 HM   Bug Fix
      -------
      Modified Get_OrigOrdAddr in DicLinkU to re-pad the OurRef correctly, from
      v4.32 Eduardo is padding it differently so that the fields worked normally
      but editing a transaction caused YourRef to be padded and broke the fields.


02/04/02 FORMDES v5.00.032
         SBSFORM v5.00.045
--------------------------
 HM   Released for Enterprise v5.00


26/03/02 SBSFORM-b500.045
-------------------------
 HM   Modified to always pickup DictNary.Dat from the main Enterprise directory


25/03/02 SBSFORM-b500.044
-------------------------
 HM   Added support for following new fields:-

        ACTAGNO   1071  Default Tag Number             

        STWOPWIP  5160  WOP - WIP GL Code              
        STROLEAD  5161  WOP - Re-Order Lead Time       
        STECOQTY  5162  WOP - Min Economic Build Qty   
        STQWORPI  5163  Quantity Picked on WOR         


18/03/02 SBSFORM-b500.043
--------------------------
 HM   Fixed ACCCDESC and ACDPDESC as they weren't being set


01/03/02  SBSFORM-b500.042
--------------------------
 HM   Modified PrntForm.SentEntFax to set the Print Job title which the
      Enterprise Fax client uses to link a fax job against the details
      database.  The title wasn't previously being set on Enterprise 
      Reports so the Fax Client always asked for the Recipient Details.

28/02/02  SBSFORM-b500.041
--------------------------
 HM   Extended THUSER1/THUSER2 to 30 chars and added EMUSER3/EMUSER4

08/02/02  SBSForm-b500.040
--------------------------
 HM   Added Compression to Internal PDF routines

24/01/02  FormDes-b500.030
--------------------------
 NF   Added Bitmaps into Menus


21/01/02  SBSForm-b500.039
--------------------------
 HM   Modified PrintReport in Prntform.Pas to use RAVE commands when
      writing to File (fePrintMethod = 4) as used by Sentimail.

16/01/02  FormDes-b500.029, SBSForm-b500.038
--------------------------------------------
 HM   Numerous mods to Prntform.Pas to allow direct PDF support using
      TMemoBuf instead of the bespoke ExtTextRect.  All text printing
      in forms now going through the ExtTextRect2 proc which maps
      down onto either TMemoBuf or ExtTextRect depending on the
      requirements.

      Added new feEmailAtType values of 2 for RAVE PDF output and 3
      for RAVE HTML output.  NOTE: HTML Output doesn't work correctly
      with multiple pages and will not be used until fixed.



------------------------------------------------------------------------


Ver    Released  Prog  Change

SBSFORM b440           Mods
                       ~~~~
                       Added Works Order forms into SysForms Tree

SBSFORM b432.035  HM   Mods
                       ~~~~
                       Added inclusive VAT Code fields:-

                         ACINCVAT  Inclusive VAT Code
                         STINCVAT  Inclusive VAT Code
                         TLINCVAT  Inclusive VAT Code

SbsForm v4.32.034 HM   Mods
                       ~~~~
                       Added the Trade Counter fields into the popup list for selecting data dict fields.

SbsForm v4.32.033 HM   Mods
                       ~~~~
                       Changed SendEmailFile2 to write to the Adobe Registry Entries for PDF Writer 4/5
                       as __PDF.INI not installed as default for 4, and 5 doesn't appearently support
                       it at all.

SbsForm v4.32.032 HM   Bug
                       ~~~
                       Modified PrntForm.SendEmailFile2 as it was GPF'ing when printing to Adobe 
                       Acrobat and the __PDF.INI file was missing.

FormDes v4.32.028 HM   Release for v4.32 18/04/01
SbsForm v4.32.031 

SbsForm b431.030  HM   Mod
                       ~~~
                       Fixed TLCCDESC and TLDPDESC which hadn't ever workaed as far as I could see

SbsForm b431.029  HM   Mod
                       ~~~ 
                       Modified to implement changes to internal DetLTotal function relating to
                       Settlement Discount 

SbsForm b431.028  HM   Bug
                       ~~~ 
                       XML emails had sender name and address around the wrong way!  Was fixed 
                       for normal emails in June 2000, but I didnt realise the XML emails were
                       done separately.

FormDes + SbsForm
        b431.027  HM   Mods 19/02/01
                       ~~~~~~~~~~~~~
                       Added Transaction sorting options.

FormDes + SbsForm
        b431.026  HM   Mods 15/02/01
                       ~~~~~~~~~~~~~
                       Extended ADJ printing sort options.

FormDes + SbsForm
        b431.025  HM   Mods 07/02/01
                       ~~~~~~~~~~~~~
                       Added options into ADJ printing to allow ADJ's to show the hidden lines
                       representing build BOM's.

SbsForm b431.023  HM   Mods 26/01/01
                       ~~~~~~~~~~~~~
                       Added TCOUTSTA to return Trade counter - Outstanding Amount from transaction
                       notes.

SbsForm b431.021  HM   Mods 10/01/01
                       ~~~~~~~~~~~~~
                       Modified the form printing for Enterprise Faxing under Win2000 to store the 
                       document name in an .INI file in the faxing directory.  This works around the 
                       problem with the Async Pro driver under Windows 2000.

SbsForm b431.020  HM   Bug 04/01/01
                       ~~~~~~~~~~~~
                       Modified the PCC Printing to set the DrivingFile variable differently for labels,
                       this fixes the relational lookups, e.g. SDN->Cust, which previously didn't work.

SbsForm b431.019  HM   Mod 04/01/01
                       ~~~~~~~~~~~~
                       Modified the TLBENTLY field added in .014 as the original spec was wrong.

SbsForm b431.018  HM   Mod 02/01/01
                       ~~~~~~~~~~~~
                       Rewrote the PCC Preview window to support non-MDI Applications (e.g. Trade Counter).

SbsForm v4.31.017 HM   Released

SbsForm b431.016  HM   Bug
                       ~~~
                       Modified the Cheque printing routin, UpdatePPY, as with certain data the record locking
                       was positioning on and locking the first transaction line only, with multi-line PPY's
                       this caused an infinite loop.

FormDes b431.015  HM   
SbsForm b431.015  HM   Mod
                       ~~~
                       Added support to Text Fields for Symbol Fonts.  

SbsForm b431.014  HM   Mod
                       ~~~
                       Added new data dictionary field for Bentley:-

                         TLBENTLY  Invoice Line Counter - Bentley 

SbsForm b431.011  HM   Mod
                       ~~~
                       Added new form into form definition sets:-

                         Self Billing Sub Contractor Invoice (PIN)        47  

FormDes v4.31.008 HM   Released
Sbsform v4.31.010      ~~~~~~~~

b431.010         HM    Mods
       10/08/00        ~~~~
                       Added in DJOBNOT and GJOBNOT to allow access to dated and general job notes from documents.

b431.009         HM    Bug 
       09/08/00        ~~~
                       Modified the Acrobat File creation as Windows 2000 was using the Windows 9x .INI file
                       which meant it didn't work.

b431.008         HM    Mods
       07/08/00        ~~~~
                       Added editing facilities for Fax and Email Signature files.

SbsForm.Dll      HM    Released
v4.31.008  17/07/00    ~~~~~~~~

SbsForm.Dll      HM    Bug
b431.007   06/07/00    ~~~
                       Modified the Add button on the System Setup - Form Definitions Sets as it was incorrectly 
                       coded, preventing the addition of the first set.

SbsForm.Dll      HM    Bug
b431.006   27/06/00    ~~~
                       Modified the Statement Aged By Moth forms NOT to delete the temporary file, as this was causing
                       statement runs not to have any transactions on them.  Enterprise will now assume the burden of
                       deleting the temporary file at the correct point.

SbsForm.Dll      HM    Bug
v4.31.005  26/06/00    ~~~
                       Fixed the PDF creation for Emails - was incorrectly creating PDF's in the Enterprise directory,
                       not the SWAP subdirectory.

                       Added an error message to trap the email attachment being missing, this is normally caused by
                       Attachment Printer being wrong, but manifested itself as an error sending MAPI emails, SMTP
                       emailing didn't report any error!

SbsForm.Dll      HM    Bug
v4.31.004  09/06/00    ~~~
                       Modified PrintBatch_Print in PrintU.Pas as the initial page orientation was not checking the
                       orientation of the cover page.  The orientation was being taken from the first form. 

SbsForm.Dll      HM    Bug
       v4.31.003       ~~~
                       Emails sent by Paperless Module had the Sender Name and Address around the wrong way, so
                       Reply To didn't work. 

FormDes + SBSForm.Dll  Bug
       v4.31.002       ~~~
                       Moved to new version numbering system and fixed bug in Print Preview window 
                       when used by Enterprise. The ESC and Ctrl-C keypresses to close the form were 
                       being lost, either by Delphi 5, or in Enterprise somewhere.    

FormDes + SBSForm.Dll  Bug
       v4.31a          ~~~
                       Fixed Form Options as some forms were getting a Range Check Error going into Form Options, 
                       caused by the stored printer name being unknown on computer being used.                       

FormDes + SBSForm.Dll  Released
       v4.31           ~~~~~~~~                       

SBSForm b430e.511
       23/03/00  HM    Bug
                       ~~~
                       Changed the handling of the system menu on the print preview dialog as the
                       Delphi4/5 WindowState bug was causing the Auto-Min/Max menu options to be
                       enabled/disabled incorrectly. The bug is that WindowState is not set until
                       AFTER the FormResize event.

SBSForm b430e.510
       23/03/00  HM    Mods
                       ~~~~ 
                       Added 2 new form types into System Setup Form Definitions:-

                         45  Sales Receipt Debit Note (SRC)
                         46  Purchase Payment Debit Note (PPY)

SBSForm b430e.507
       21/02/00  HM    Bugz
                       ~~~~
                       Modified standard and PCC forms to set the Printer status on transactions when printing
                       documents with Serial No's.

SBSForm b430e.506
       19/01/00  HM    Bugz
                       ~~~~
                       Modified TForm_PrintTest.Include in PrnBatch.Inc and TForm_PrintPCC.Include in PrintPcc.Pas to
                       only check the Hide Line Type flags for line Types 1-4, this is because EL is now using 0, 5 + 6 
                       for different purposes, which caused lines to be hidden incorrectly.

SBSForm b430e.505
       06/12/99  HM    Bugz
                       ~~~~
                       Modified STBOMQTY to use Qty Decs and STBOMCOS to use Cost Decimals.
SBSForm b430e.504
       29/10/99  HM    Mods
                       ~~~~
                       Added new v4.31 fields:-

                         SYSVATRB  90164  System - VAT Rate - B R 13 2
                         SYSVATRC  90165  System - VAT Rate - C R 13 2
                         SYSVATRF  90166  System - VAT Rate - F R 13 2
                         SYSVATG   90167  System - VAT Rate - G R 13 2
                         SYSVATRR  90168  System - VAT Rate - R R 13 2
                         SYSVATRW  90169  System - VAT Rate - W R 13 2
                         SYSVATRY  90170  System - VAT Rate - Y R 13 2                       
          
SBSForm b430e.503
       19/10/99  HM    Mods
                       ~~~~
                       Added new v4.31 fields:-

                         STQRETUR  5079  Quantity Returned              R    10   0
                         STQWORAL  5080  Quantity Allocated to WOR      R    10   0
                         STQWORIS  5081  Quantity Issued to WOR         R    10   0
                         STONWEB   5082  Publish On Web-Site            Y     3   0
                         STWEBCAT  5083  Web Catalogue Availability     S    20   0
                         STUSER3   5084  User Defined Field 3           S    30   0
                         STUSER4   5085  User Defined Field 4           S    30   0
                         STSIZECO  5086  Size/Colour Container          B     3   0
                         STSSDUPL  5087  Intrastat Uplift Despatch Def% R    13   6
                         STSSDCOU  5088  Intrastat Country Of Origin    S     5   0
                         STSSDARR  5089  Intrastat Uplift Arrivals Def% R    13   6
                         STIMAGE   5090  Image                          S    30   6
                         STSNOAVG  5091  Use Average Cost Serial No's   B     3   0

                         THUSER3   2093  User Defined Field 3           S    30   0
                         THUSER4   2094  User Defined Field 4           S    30   0
                         THPOSTED  2095  Date Posted                    D    10   0
                         THORDRAT  2096  Preserve Order Rate            Y     3   0

                         THGOODSB  2210  Goods Value-VAT=B              R    13   2
                         THGOODSC  2211  Goods Value-VAT=C              R    13   2
                         THGOODSF  2212  Goods Value-VAT=F              R    13   2
                         THGOODSG  2213  Goods Value-VAT=G              R    13   2
                         THGOODSR  2214  Goods Value-VAT=R              R    13   2
                         THGOODSW  2215  Goods Value-VAT=W              R    13   2
                         THGOODSY  2216  Goods Value-VAT=Y              R    13   2

                         THVDESCB  2220  VAT Description (B)            S    10   0
                         THVDESCC  2221  VAT Description (C)            S    10   0
                         THVDESCF  2222  VAT Description (F)            S    10   0
                         THVDESCG  2223  VAT Description (G)            S    10   0
                         THVDESCR  2224  VAT Description (R)            S    10   0
                         THVDESCW  2225  VAT Description (W)            S    10   0
                         THVDESCY  2226  VAT Description (Y)            S    10   0

                         THVAMTB   2230  VAT Amount (B)                 R    13   2
                         THVAMTC   2231  VAT Amount (C)                 R    13   2
                         THVAMTF   2232  VAT Amount (F)                 R    13   2
                         THVAMTG   2233  VAT Amount (G)                 R    13   2
                         THVAMTR   2234  VAT Amount (R)                 R    13   2
                         THVAMTW   2235  VAT Amount (W)                 R    13   2
                         THVAMTY   2236  VAT Amount (Y)                 R    13   2

                         THVAMTGB  2240  VAT Amount + Goods (B)         R    13   2
                         THVAMTGC  2241  VAT Amount + Goods (C)         R    13   2
                         THVAMTGF  2242  VAT Amount + Goods (F)         R    13   2
                         THVAMTGG  2243  VAT Amount + Goods (G)         R    13   2
                         THVAMTGR  2244  VAT Amount + Goods (R)         R    13   2
                         THVAMTGW  2245  VAT Amount + Goods (W)         R    13   2
                         THVAMTGY  2246  VAT Amount + Goods (Y)         R    13   2

                         THVATB    2250  VAT Value-VAT=B                R    13   2
                         THVATC    2251  VAT Value-VAT=C                R    13   2
                         THVATF    2252  VAT Value-VAT=F                R    13   2
                         THVATG    2253  VAT Value-VAT=G                R    13   2
                         THVATR    2254  VAT Value-VAT=R                R    13   2
                         THVATW    2255  VAT Value-VAT=W                R    13   2
                         THVATY    2256  VAT Value-VAT=Y                R    13   2

                         THVVALB   2260  VAT Goods Value (B)            R    13   2
                         THVVALC   2261  VAT Goods Value (C)            R    13   2
                         THVVALF   2262  VAT Goods Value (F)            R    13   2
                         THVVALG   2263  VAT Goods Value (G)            R    13   2
                         THVVALR   2264  VAT Goods Value (R)            R    13   2
                         THVVALW   2265  VAT Goods Value (W)            R    13   2
                         THVVALY   2266  VAT Goods Value (Y)            R    13   2

                         TLUSER1   3190  User Defined Field 1           S    30   0
                         TLUSER2   3191  User Defined Field 2           S    30   0
                         TLUSER3   3192  User Defined Field 3           S    30   0
                         TLUSER4   3193  User Defined Field 4           S    30   0
                         TLSSDUPL  3194  Intrastat State Uplift %       P    10   2
                         TLSSDCOU  3195  Intrastat Country Of Origin    S     3   2
                         TLSSDCOM  3196  Intrastat Commodity Code       S    10   0
                         TLSSDLIN  3197  Use Line Intrastat Fields      Y     3   0
                         TLPRICEX  3198  Price Multiplier               P    13   2
                         TLB2BFOL  3199  Back-To-Back Order Folio       L     8   0
                         TLB2BLIN  3200  Back-To-Back Order Line No     L     8   0
                         TLSSDUNI  3201  SSD Unit into Sales Unit       P    13   2

                         NMALTCOD  4050  Alternative Code               S    20   0
                         NMVALCUR  4051  Validation Currency            U     3   0

                         JRUSER3   12019 Job User Defined 3             S    20   0
                         JRUSER4   12020 Job User Defined 4             S    20   0

                         CHBASETL  2107  Settle Disc Taken (Base+Sign)  P    13   2
                         CHBASET2  2108  Settle Disc Taken (Base)       P    13   2
                         CHSETTLE  2109  Settle Disc Taken (Signed)     P    13   2
                         CHSETTL2  2110  Settle Disc Taken (Unsigned)   P    13   2
                         CHAMTSET  2111  Amt Settled exc SetDisc (Sign) P    13   2
                         CHAMTSE2  2112  Amt Settled exc Settle Disc    P    13   2

SBSForm b430e.502
       13/10/99  HM    Mods
                       ~~~~
                       Added new v4.31 fields:-

                         ACEMAIL   1059  Email Address                  
                         ACPOSTCD  1060  Post Code                      
                         ACALTCOD  1061  Alternate Customer Code        
                         ACUSER3   1062  User Defined Field 3           
                         ACUSER4   1063  User Defined Field 4           
                         ACWEBCAT  1064  Web Catalogues                 
                         ACVATCNT  1065  Country of VAT registration    
                         ACDEFTER  1066  Default SSD Delivery Terms
                         ACDEFTRA  1067  Default SSD Method Transport

SBSForm b430e.501
       28/09/99  HM    v4.31 Mods
                       ~~~~~~~~~~
                       Added support for increased currency table.

                       Added CCYAGE and RTINVRT functions. 

FormDes b430a.500
SBSForm b430e.500
       09/09/99  HM    Mods (Delphi 4)
                       ~~~~~~~~~~~~~~~
                       Rewrite the Page Options dialog as the picture drawing doesn't work under
                       Delphi 4. 

SBSForm b430e.370
       25/08/99  HM    Rebuilt to pick up changes for international amount formats

SBSForm b430e.368
       16/07/99  HM    Modz
                       ~~~~
                       Added code into form printing to check the Syss.ExDemoVer flag and print the
                       'Demo Version' bitmap on the forms.

SBSForm b430e.366
       24/06/99  HM    Bugz
                       ~~~~
                       Changed the GetSerialNote in SerialU so that for BatchChildren it wasn't
                       looking up the parent batch and returning details from that. Details are
                       now returned from the Batch Child itself. This was causing problems where
                       customers were using duplicate batch numbers (Norman Lauder - EIRE).

SBSForm b430e.365
       23/06/99  HM    Bugz
                       ~~~~
                       Modified PrintBatch_Print to stop incorrect no of labels being printed.
                       Because of the way it was being setup by Ent instead of 3 labels it would
                       print 3 pages of 3 labels.

FormDes v4.30a
SBSForm v4.30e
       24/05/99  HM    Released for v4.30b

SBSForm b430.364
       20/05/99  HM    Modz
                       ~~~~
                       Restored JA fields after limiting the ones available in the Form Designer
                       within the data dictionary fields themselves.

SBSForm b430.363
       19/05/99  HM    Modz
                       ~~~~
                       Removed JE and JT fields from list of available fields. 

SBSForm b430.362
       18/05/99  HM    Bugz
                       ~~~~
                       Removed JA and JB fields from list of available fields. 

SBSForm b430.361
       30/04/99  HM    Bugz
                       ~~~~
                       Removed debugging for Win98 Invalid Forms problem where filespec
                       was being corrupted. Fixed by initialising the record in BtrvU2 and
                       by resetting the forms file definition before retrieving the 
                       filespec.

SBSForm b430.360
       27/04/99  HM    Bugz
                       ~~~~
                       Modified calculations involving Stock.BinLoc to check for 'E'
                       in the string as that is takeen as Exponential and causes a 
                       Floating Point Overflow.
 
FormDes + SBSForm b430.359  (Ent v4.30b compatible)
       26/04/99  HM    Mods
                       ~~~~
                       Added !X function into PCC Forms for currency conversion.

FormDes b430.359
       01/04/99  HM    Bugs/Mods
                       ~~~~~~~~~
                       Various changes made to shutdown to eliminate problems with
                       the P.SQL v7 requesters. 
FormDes b430.358
       26/03/99  HM    Rebuilt for new TSBSPrintSetupInfo to stop it crashing!

SBSForm 
       26/03/99  HM    Mods
                       ~~~~ 
                       Added new dd fields for Cheque Printing for Omega:-

                         CHCT100M  002375   Header - Cheque Text 100 Mills
                         CHCT10M   002374   Header - Cheque Text 10 Mills
                         CHCTMILL  002373   Header - Cheque Text Millions

SBSForm b430.358
       24/03/99  HM    Mods
                       ~~~~ 
                      .356 mods completed and released for testing.   

SBSForm 
       18/03/99  HM    Bug
                       ~~~
                       Changed the FormatDate function because it was crashing calculating
                       the last of month for non-leap year years. Eduardo had changed MonthDays 
                       in ETDATEU so it was returning 29 instead of 28! I have now changed it
                       to use the function from SYSUTILS.

SBSForm b430.357
       17/03/99  HM    Mods
                       ~~~~ 
                       Added new function GetFormType into DLL to allow print dialog to
                       check the cover sheets are of the same type as the main form.

FormDes + SBSForm b430.356
       02/03/99  HM    Mods
                       ~~~~
                       Added functionality for sending print jobs by fax and email under
                       DBD compiler definition.

SBSForm v4.30d
       26/02/99  HM    Released

SBSForm b430.355
       25/02/99  HM    Mods
                       ~~~~
                       Added STDEFLOC for Geoff. 

SBSForm b430.354
       24/02/99  HM    Mods
                       ~~~~
                       Applied .353 mods to following fields:-

                         3114 TLUNNET1
                         3115 TLUNNET2
                         3116 TLNETTOT
                         3117 TLNETFOC

SBSForm b430.353
       22/02/99  HM    Bug
                       ~~~
                       Modified handling of rounding on TLGLVAL due to rounding error.
SBSForm b430.352
       02/02/99  HM    Bug
                       ~~~
                       Applied currency conversion changes as advised by EAL.
SBSForm v4.30c
       20/01/99  HM    Bug
                       ~~~
                       Bentley's had a problem with a PCC form that never finished printing, this
                       was traced to the fact they were doing an @IF on a field that was blank. This
                       caused the printing to remain on and the page break to be done which restarted
                       the printing of the page ...
                       I have modified the @IF statement to turn printing off if the field is blank.

SBSForm v4.30b
       19/01/99  HM    Mod
                       ~~~
                       Changed Form Definition Sets so that the select dialog listed both *.def
                       and *.efd files simultaneously as default.

SBSForm v4.30a
       04/01/99  HM    Bug
                       ~~~
                       The call to Def_InvCalc2 was only being made if it hadn't been called 
                       already for the transaction, this caused problems if the user printed the
                       form then edited it and printed it again. The totals remained cached in 
                       memory from the pre-edited form. The caching was removed.
 
FormDes + SBSForm v4.30
       04/01/99  HM    Released
                      
FormDes + SBSForm b430.352
       24/12/98  HM    Bug
                       ~~~
                       Fixed an access violation in Form Designer Print and Print
                       Preview menu options by setting RPDEV.DEVICEINDEX to itself.

FormDes + SBSForm b430.351
       24/12/98  HM    Recompiled for RP3

FormDes + SBSForm b430.350
       22/12/98  HM    Version 4.30 Beta

FormDes + SBSForm b424a.344
       03/12/98  HM    Special RP3 beta compiled up for use with Enterprise Beta given
                       to customers and supplied with RP2 DLL.

FormDes + SBSForm v4.24
       10/11/98  HM    Release Version

FormDes + SBSForm b423g.341
       26/10/98  HM    Bug (Drat and Double-Drat!)
           -           ~~~
       27/10/98        Modified the auto-changing of the paper size, bin & orientation
                       added in b423f.336 because changing the paper size caused an
                       exception when printing direct to printer, although not when
                       printing to preview and then printer!
   
                       Removed a number of Currency Fields from the Single Currency
                       lists of fields.
                       
                       Mods
                       ~~~~
                       Rewrote the Select Data Dictionary Field dialog to utilise tabs
                       to categorise the fields, split up the list to load quicker, etc...                

SBSForm.DLL b423f.339
       22/10/98  HM    Mod
                       ~~~
                       Added new fields to access various new fields:               
            
                         STLINTYP   5076  Default Line Type
                         STLINTDE   5077  Default Line Type Description

                         JRUSER1   12017  Job User Defined 1
                         JRUSER2   12018  Job User Defined 2

                         EMUSER1   11518  Employee - User Field 1
                         EMUSER2   11519  Employee - User Field 2

                         THLNTOT0   2092  Transaction Line Type 0 Total
 
                       Added a Print If button to the Table Options and widened the
                       Print If column so its very wide.

                       Bug
                       ~~~ 
                       Changed the Table Options dialog's window to non-sizable and
                       fixed the list so you can double-click on columns other than
                       the first to view the column details.   

                       Fixed the Group Control so that it works correctly if no rows
                       have been added, it previously just hid everything.

SBSForm.DLL b423f.338
       15/10/98  HM    Mod
                       ~~~
                       Added new field to Form Designer to return name from originating order.

                         THCMPNAM  2091   Header - Site Co Name (HO)

SBSForm.DLL b423f.337
       14/10/98  HM    Mod
                       ~~~
                       Added new fields to Form Designer for Euro-Compatible VAT compliance
                       which show transaction VAT Totals in the VAT Currency using the 
                       transactions own VAT Rates:

                         THTOTALV  2084   Total inc VAT (Vat Curr) (THTOTAL)
                         THTOTUV   2085   Total inc VAT (Unsgnd Vat Cur) (THTOTALU)
                         THTOTGOV  2086   Net Goods (No Disc - VAT Curr) (THTOTGOO)
                         THTOTVAV  2087   Total VAT (VAT Curr) (THTOTVAT)
                         THTOTVUV  2088   Total VAT (Unsigned - VAT Cur) (THTOTVAU)

                       NOTE: Each field is the equivalent of an existing field, shown in 
                       brackets.

                       Also added fields to access the transactions internal VAT Rates.

                         THVATDAY  2089   VAT Daily Exchange Rate
                         THVATCMP  2090   VAT Company Exchange Rate


SBSForm.DLL b423f.336
       12/10/98  HM    Mod
                       ~~~
                       Modified the Form Printing routines to change the paper orientation,
                       printer bin and paper size when it changes forms, either through a 
                       specified continuation form, or through a multi-form batch.

SBSForm.DLL b423f.335
       09/10/98  HM    Bug
                       ~~~
                       IDetail section in Dictionary was not initialising RNum to 0, this
                       caused an intermittant crash when printing Order Quantity fields
                       for several SDN's at Bentley's.

SBSForm.DLL b423f.332
       24/09/98  EL    Bug
                       ~~~
                       Fixed a bug in Debt Chase Letters (modes 0/1) which caused it to
                       show only the oldest invoice if Include Not Due was Off.

SBSForm.DLL b423f.332
       23/09/98  MH    Mod
                       ~~~
                       Added 2 new fields to access the new Use By date field on Serial No's:

                         TLSNUSBY
                         SNUSEBY

                       Nasty Bugz
                       ~~~~~~~~~~
                       Fixed TLSERIAL and TLBATCH which had been commented out when the Form
                       Designer was written and no-one has noticed since. 

SBSForm.DLL b423f.331
       18/09/98  MH    Mod
                       ~~~
                       Added a new date format into the FMTDATE function, 4: YYYYMMDD, this
                       is intended to make date checking easier by giving users easy access
                       to a date format which can be compared correctly.

SBSForm.DLL b423f.330
       07/09/98  MH    Special Version
                       ~~~~~~~~~~~~~~~
                       Recompiled without {$DEFINE DBD} to produce a v4.23 compatible version
                       for Palladium so they can use the Job Costing fields (see b423f.329).

SBSForm.DLL b423f.329
       03/09/98  MH    Modz
                       ~~~~
                       Added 2 new functions into the formulae DSERNOTE and GSERNOTE to access
                       the dated and general notes from the Serial/Batch number for the current
                       transaction line. It will only return the notes for the first Serial/
                       Batch record it hits. For Batches it returns the notes from the Batch
                       Header record, rather than the Batch Children created as Batch Numbers 
                       are used.

                       Setup relational links for the Job Record and Job Analysis for the Invoice
                       Header, this means the AN and JC fields can be used correctly.

SBSForm.DLL b423f.328
       02/09/98  MH    Modz
                       ~~~~
                       Modified the Page Dialog displayed from the preview window so that it
                       can handle page numbers up to 99,999 pages in the range boxes.

SBSForm.DLL b423f.327
       22/07/98  MH    Modz
                       ~~~~
                       Modified the SYSTRIxx, SYSDAYxx and SYSCMPxx to return 1.0 instead
                       of 0.0, and modified the latter 2 fields to check the Rate Inversion 
                       flag and to invert it where applicable.

                       Added the following functions to the Formulae which take either a
                       Currency Number (0-29) or a Currency Data Dictionary field as the
                       parameter:

                         CCYNAME   Returns the name of the specified currency.
                         CCYSYMB   Returns the Printer Symbol of the specified currency.
                         RTCOMP    As SYSCMPxx.
                         RTDAILY   As SYSDAYxx.
                         RTFLOAT   As SYSTRIxx.
                        
FormDes.Exe v4.23g
       21/07/98  MH    Bug (Shock, Horror!!!)
                       ~~~
                       If you selected > 50 controls and copied them into the clipboard 
                       you got a range check error. This was because the memory structure 
                       used to store the controls only has 50 elements. I modified the 
                       Copy function to check the number of items selected and display an
                       error message if over 50 items. 

SBSForm.DLL b423f.326
       21/07/98  MH    Modz
                       ~~~~
                       Modified the Invoice Note functions to intelligently work out which
                       transaction (CH or TH) to print notes for. When printing a document
                       it uses CH (the document), if printing a customer statement it will
                       use TH allowing you to place notes in the table. When printing a 
                       Remittance Advice it will print CH (the document).

SBSForm.DLL b423f.325
       20/07/98  MH    Modz
                       ~~~~
                       Added following data dictionary fields to access new Currency Fiels:
 
                         SYSTRIxx   Currency Triangulation Rate
                         SYSEURxx   Euro Currency Number
                         SYSINVxx   Invert Rate
                         SYSFLOxx   Floating Rate

                       Modified DLL to load the Ghost Currency Syss record during startup
                       and to update it at the start of each print job.

                       Bugz
                       ~~~~
                       Added following missing data dictionary fields:

                         SYSCUR10  90210   System - Currency 10 Symbol
                         SYSCUR20  90220   System - Currency 20 Symbol
  
SBSForm.DLL b423f.324
       20/07/98  MH    Bug
                       ~~~
                       Fixed a WIN98 bug in SplitFileName which was causing a lower case
                       path to be returned. This causes System Setup - Form Definition
                       Sets to report the form as not being in the forms directory.

SBSForm.DLL b423f.323
       17/07/98  MH    Bug
                       ~~~
                       Modified TForm_PrintPCC.GetField so that it didn't calculate
                       the DD field values if the field isn't being printed. This was
                       causing the Cheque Numbers to increment incorrectly on PCC 
                       Remmittance Advices.

       15/07/98  MH    Mods
                       ~~~~
                       Changed Conv_Curr calls to Conv_TCurr for Euro compatibility.


SBSForm.DLL b423f.322
       15/07/98  MH    Mods
                       ~~~~
                       Added two new data dictionary fields to allow Bentley to print the
                       correct User Name on their Debt Chase Letters:

                         SYSCOMPU  90026  System - Computer Name
                         SYSWUSER  90027  System - Windows User Id

SBSForm.DLL b423f.321 
       13/07/98  MH    Mods for Remittance Advice/Cheque Numbers
                       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                       Added two new data dictionary fields to fix problems with cheque
                       numbers being wrong on multi-page PPY's.
      
                         SYSINCCQ  90040  System - Increment Cheque No
                         SYSUPDCQ  90041  System - Update PPY Cheque No

                       SYSINCCQ will increment the 'ACQ - Automatic Cheque Number' number
                       in System Setup Document Numbers.

                       SYSUPDCQ will set the current 'ACQ - Automatic Cheque Number' number   
                       into the currently printing PPY as its cheque number. 

                       Used in conjunction with Print If's and the Page Number and SYSPGBRK
                       fields this will allow the user to use the first/last cheque in the
                       page range and to update the PPY with the correct cheque number.

                       Neither field will actually print anything and both these fields are 
                       only enabled if the ChequeMode field in TSBSPrintSetupInfo is passed
                       in as True from Exchequer Enterprise.

Formdes.Exe & SBSForm.DLL
v4.23f 02/07/98  MH    Bugs
                       ~~~~
                       Recompiled to pickup a fix to the international date format
                       routine in ETDATEU, didn't work properly under Windows NT.
  
Formdes.Exe & SBSForm.DLL
v4.23e 29/06/98  MH    Bugs
b423d.320              ~~~~
                       Recompiled to pick up corrected Day Of Week function.
   
                       Modified Def_BuildSNo to correctly pick up OUT serial
                       numbers from ADJ's.

                       Moved the setting of the document Printed Status flag into
                       the printing routines, as it was being set before the
                       threads had got round to printing the document because it
                       was being set in Ent. after the print job was created in the
                       main thread.

SBSForm.DLL b423d.319
       23/06/98  MH    Mod
                       ~~~
                       Added new data dictionary fields to access the credit card
                       information on the customers/suppliers.

                         ACCCSTRT  1054  Credit Card - Start Date
                         ACCCEND   1055  Credit Card - End Date
                         ACCCNAME  1056  Credit Card - Name
                         ACCCNO    1057  Credit Card - Number
                         ACCCSWTC  1058  Credit Card - Switch Ref. No

SBSForm.DLL b423d.318
       22/06/98  MH    Bug
                       ~~~
                       Fixed a bug in the Def_BuildSNo where it wasn't printing out
                       Serial Numbers on ADJ's. TThis was because they had a -ve 
                       count of serial numbers and the code checked the count as
                       being OK if it had processed >=, it started the count at 0.

Formdes
v4.23d 22/06/98  MH    Bug
                       ~~~
                       Text Options dialog allowed entry of unlimited text, but Form
                       Designer can only store 255 characters.

                       Mods
                       ~~~~
                       Added new fields for Bentley's to data dictionary.

                         TLORYREF  3092  Order Your Ref (Short)
                         TLORYRFL  3093  Order Your Ref (Long)

Formdes + DLL
v4.23c 09/06/98  MH    Mods
                       ~~~~
                       Modified RPRinter to ignore 'Rendering Subsystem on PUB:' printers
                       when it builds the printers list.

                       Bug
                       ~~~
                       Modified the PCC Preview window to delete the temporary file it 
                       creates when printing. Had previously left a !REP?.SWP file behind. 

DLL b317.423b
       05/06/98  MH    Mod
                       ~~~
                       Modified the FMTDATE function in form printing to have an 'F' - first
                       of month and 'L' - last of month function, the offset is a number of
                       months which is applied first.

                       Bug
                       ~~~
                       Modified the month offset of FMTDATE to check the day was within the
                       permissable day range for the new month, if not it reset the day to the
                       last day within the month. Had a problem where adding 1M to 31/05 and
                       getting 31/06 and an exception.  

DLL b316.423b
       04/06/98  MH    Bug
                       ~~~
                       Added an Application.ProcessMessages into PCC Printing routines
                       to stop it locking up the machine.

DLL b315.423b
       03/06/98  MH    Mods
                       ~~~~
                       Rebuilt to pick up EL's date mods to allow US date format to be
                       used as standard by Infospeed.

DLL 423b
       03/06/98  MH    Released with Enterprise v4.23

DLL b314.423a
       12/05/98  MH    Mods for Bentley
                       ~~~~~~~~~~~~~~~~ 
                       Changed the TLORDUS1 and TLORDUST to be rounded to
                       6dp internally in DicLinkU.

                       Added Blank justification to the PCC style forms.

DLL b313.423a
       08/05/98  MH    Mods for Bentley
                       ~~~~~~~~~~~~~~~~ 
                       Added the ability to print notes in the PCC style forms through
                       a new set of commands in the .LST file:

                         #CUD1   R           Customer Dated Line 1 Right justified
                         #CUG04  L           Customer General Line 4 Left justified
                         #SUD1   R           Supplier Dated Line 1 Right justified
                         #SUG07              Supplier General Line 7
                         #STD001 L           Stock Dated Line 1 Left justified
                         #STG032             Stock General Line 32
                         #THD1   R           Transaction Dated Line 1 Right justified
                         #THG001 C           Transaction General Line 1 Centred

DLL b312.432a     { Typo on version number in VerModU.Pas should be .423a!!!, Whoops!! }
       07/05/98  MH    Mods for Bentley
                       ~~~~~~~~~~~~~~~~ 
                       Added fields to details file to allow Bentley to use the PCC
                       forms.

                         TLORDUS1  3065   Line Order Qty * Stock User 1
                         TLORDUST  3066   Ord Qty * Stock User 1 (Total)
                         TLORDWEI  3067   Line Qty Ord * Stock Weight
                         TLORDWET  3068   Qty Ord * Stock Weight (Total)
             
DLL
v4.23a 07/04/98  MH    Modz
                       ~~~~
                       Changed the TL Quantity fields to be 9 long and have NoQtyDec
                       decimal places. A lot were formerly hard coded to 2dp.

DLL    03/04/98  MH    Modz
                       ~~~~
                       Added fields to customer file giving info for the Invoice To
                       account. Returns Cust info if InvoiceTo not set.

                         ACINADD1  Invoice To - Address Line 1
                         ACINADD2  Invoice To - Address Line 2
                         ACINADD3  Invoice To - Address Line 3
                         ACINADD4  Invoice To - Address Line 4
                         ACINADD5  Invoice To - Address Line 5
                         ACINCOMP  Invoice To - Company Name
                         ACINDAD1  Invoice To - Delivry Address 1
                         ACINDAD2  Invoice To - Delivry Address 2
                         ACINDAD3  Invoice To - Delivry Address 3
                         ACINDAD4  Invoice To - Delivry Address 4
                         ACINDAD5  Invoice To - Delivry Address 5
                         ACINFAX   Invoice To - Fax Number
                         ACINPHON  Invoice To - Telephone Number

FormDes + DLL
v4.23  30/03/98  MH    Bug 
                       ~~~
                       Recompiled to pickup change of CustRec from 940
                       back to 939 bytes.   

DLL
v4.21e 22/01/98  MH    Bug
                       ~~~
                       Had accidentally left DEBUGWIN in PRNTFORM when doing 
                       v4.21d. This can cause Access Violations when exiting
                       Enterprise.

v4.21d 20/01/98  MH    Mod (for Message Pad)
                       ~~~
                       Added the FMTDATE command into the Formula Parser.
DLL
v4.21c 02/01/98  MH    Mod (for David Carter)
                       ~~~
                       Added new field to data dictionary for Order Details
                       from the Invoice:

                         CHORDACC 2372 Header - Order Account Code
DLL
v4.21b 08/12/97  MH    Mod
                       ~~~
                       Added new fields to data dictionary for Order Details
                       from the invoice:

                         CHORDTDT 2370 Header - Order Transactn Date
                         CHORDDDT 2371 Header - Order Delivery Date

Form Designer
v4.21a 28/11/97  MH    Bug
                       ~~~
                       Fixed bug in Bitmap Control where if it couldn't
                       load the bitmap it wasn't painting properly, so that
                       it showed whatever was on the screen before it.

                       Fixed bugs in Form Options where it was showing
                       some controls for labels that it shouldn't.

DLL
v4.21a 27/11/97  MH    Bug
                       ~~~
                       Modified Batch Printing routines to remember the
                       batch info specified by Enterprise, some info gets
                       changed as the form is printed and this was causing
                       Serial Number continuations not to print correctly.
                       The Table Key info was wrong so no detail lines were
                       being shown.

Form Designer + DLL
v4.21  19/11/97  MH    Release Candidate

Form Designer
b310   18/11/97  HM    Bug
                       ~~~
                       Modified Main window and Form Options dialogs
                       to disable print buttons if no printers defined.
DLL
b310   17/11/97  HM    Bug
                       ~~~
                       Added Alternate Stock Code fields:

                         (I420) TLAALTCD  Alternative Stock Code (Auto)
                         (I421) TLAALTDE  Alternative Stock Desc (Auto)
                         (I428) TLAALTRC  Alt. Re-Order Currency (Auto)
                         (I429) TLAALTRP  Alt. Re-Order Price (Auto)
                         
                         (I440) TLSALTCD  Alternative Stock Code (Spec)
                         (I441) TLSALTDE  Alternative Stock Desc (Spec)
                         (I448) TLSALTRC  Alt. Re-Order Currency (Spec)
                         (I449) TLSALTRP  Alt. Re-Order Price (Spec)

DLL
b309   12/11/97  HM    Bug
                       ~~~
                       Modified the GetNextLine function in PCC printing
                       to save and restore the record the same as the normal
                       printing routines do. The problem was that the detail
                       line after printing the repeat section on an invoice
                       was for another invoice. 
DLL
b308   10/11/97  HM    Bug
                       ~~~
                       Modified the PCC Printing routines to onlt trim
                       the left sides of fields of Real/Double type. Was
                       removing the padding space where the '-' sign should 
                       have been, meant columsn didn't lign up properly.

FormDes + DLL
b307   07/11/97  HM    Mod
                       ~~~
                       Added System Setup - PCC Defaults to allow the
                       setup of a default printer, bin and form for
                       PCC forms.
DLL
b306   06/11/97  HM    Bug
                       ~~~
                       Bug in PCC Print Routines where the DKeyLen wasn't
                       being set so checkkey always passed, meant you 
                       sometimes got 70 invoices printed!
DLL
b305   05/11/97  HM    Bug
                       ~~~
                       Page Printing dialog off Preview Window wasn't 
                       picking up the values from the Currency Edit
                       controls if you didn't tab off them. Known problem
                       with Currency Edit control, fixed by setting
                       focus to the print button.
DLL
b304   05/11/97  HM    Bug
                       ~~~
                       Changed Application.MainForm to SystemInfo.MainForm
                       in PrintFileTo and PreviewPrintFile In PrntForm.Pas.

DLL
b303   04/11/97  HM    Modified printing routines to reference Systeminfo.
                       mainform instead of Application.MainForm;

FormDes + DLL
b302   03/11/97  HM    Report Printer 2.0n
                       
FormDes + DLL
b301   23/10/97  HM    Mods
          -            ~~~~
                       Modified preview window to send printing messages
                       to SystemInfo.MainForm instead of Application.MainForm.
                       This is so the Toolkit DLL can call the printing 
                       functions, as its Application.Mainform isn't and
                       can't be set. Enterprise and Form Designer have
                       both set the same.

                       Added System Setup - Printer Control Codes to Options
                       menu, and load Printer Control codes on Initialisation
                       in DLL.
                       
                       Modified sbsForm_Initialise to load in the Exchequer 
                       Printer Codes.
                       
                       Modified System Setup - Form Definition Sets to allow 
                       selection of .DEF files.
                       
                       Modified PrintBatch_Print to detect PCC/.DEF forms and
                       to redirect the printing.
                       
                       Added a PCC Preview window.

                       Added new dictionary fields:
                       
                         SYSPAGNO  90024  System - Page Number

                       
DLL
4.20e  16/10/97  HM    Bugs
                       ~~~~
                       Modified DicLinkU to switch around THGOODSZ and
                       THGOODSE which were around the wrong way in the 
                       dictionary.

                       Modified DicLinkU to switch around THVATZ and
                       THVATE which were around the wrong way in the 
                       dictionary.

                       Mod
                       ~~~
                       Added SYSVATRx fields to print VAT Rates.

DLL
       26/09/97  HM    Mod
                       ===
                       Added Debugging Messages to Printing Functions
                       under MHPRT compiler definition. Displays messages
                       going into and coming out of most major routines
                       used by printing.
DLL
4.20d  17/09/97  HM    Bug
                       ===
                       Changed the THVATBAS field to convert currencies
                       using the transactions currency rates.
DLL
4.20c  09/09/97  EL    Bug
                       ===
                       Bug in Serial Number printing reported by QED.
DLL
4.20b  04/09/97  MH    Mod
                       ===
                       Modified Cheque printing fields to add "Only" to 
                       the end of the Text Number Description.
DLL
4.20a  27/08/97  MH    Mod
                       ===
                       Added new field THPREVDE (2029) which is set to
                       Yes if any items on an invoice hab been delivered
                       previously. Added for Rachel/QED.

FormDes
       19/08/97  MH    Mod
                       ===
                       Added BarCode info into Tech Support report.

FormDes & Dll
v4.20  19/08/97  MH    Release Version

                       Mod
                       ===
                       Added BarCode support to Formula Fields and 
                       Columns. 

Dll
b300   05/08/97  MH    Mod
                       ===
                       Recompiled from new field:

                         THORDOS Total Order Outstanding

Dll
b299   29/07/97  MH    Mod
                       ===
                       Modified the Print button in the preview window to
                       allow a range of pages to be set to be printed. 
Dll
b298   22/07/97  MH    Mod
                       ===
                       Added Line Qty in cases fields to dictionary:

                         TLCQTY    Qty (In Cases)
                         TLCQPICK  Qty Picked (In Cases)
                         TLCQWOFF  Qty Written Off (In Cases)
                         TLCPWOFF  Qty W/Off This Time (In Cases)
                         TLCQDEL   Qty Delivered (In Cases)

Dll
b297   14/07/97  MH    Mod
                       ===
                       Added STBOMKPU - BOM Kit On Purchase Flag into Data 
                       Dictionary.
Form + Dll
b296   04/07/97  MH    Mod
                       ===
                       Upgraded to ReportPrinter Pro 2.0i
Dll
b295   20/06/97  MH    Bugs
                       ====
                       Changed GetFieldText and GetFormulaText to check that a string
                       is a valid number before attempting to convert it to a number.
                       Heinz Inv was crashing because it was converting E86042 and ending
                       up with infinity.

                       Changed CompareStr in the Parser so that it doesn't check the
                       wild card characters, this was accidently inherited from the 
                       report writer and was also causing Heinz SIN's to crash.

                       Modified Batch_Print in PRNBATCH.INC to re-initialise the 
                       global records, except for FormDetsF amd SysF.

                       Modified DicLinkU for Heinz :- Def_InvCalc is changing the
                       Discount totals on the invoice because of rounding errors.
                       As the result of the function is put in global arrays we
                       can save and restore the invoice record to get around the
                       problem.

Dll
b293   16/06/97  MH    Bug
                       ===
                       Bug fixed in 287-290 changes was unfixed in b291. PrntForm
                       was changed to pass an intelligent guess of the DrivingFile 
                       into Link_Dict when it was being driven by the RepScr^ file.
                       
Dll
b292   13/06/97  MH    Mods
                       ====
                       Added new fields:- 
                       Added new fields:- 

                         Last Used Date: ACLASTUS, STLASTUS, SLLASTUS
                         Control GL Codes: ACCTRLGL, THCTRLGL
                         New VAT Rates for Rates 6-9 and T, X:
                           THGOODS?,THVAT?,THVDESC?,THVVAL?,THVAMT?,THVAMTG?

Dll
b291   06/06/97  MH    Bug 
                       ===
                       Modifications to fix Print Preview bug with Application
                       Errors.

Dll  b287-290    MH    Internal

Form b281
Dll  b286
       04/06/97  MH    Bug
                       ===
                       Modified Def_BuildSno to look at a global flag to see
                       if it should include Input Doc Serial/Batch numbers.
                       Modified the Form Header record to store a flag, and 
                       added into Page Options.
Dll
b285   03/06/97  MH    Mod
                       ===
                       Changed Def_BuildSno so it also checked 'In Documents'
                       when it is building its list of serial numbers for a
                       document.
Dll
b284   30/05/97  MH    Bug
                       ===
                       MLADDRx fields crashed with a range check error
                       because they had an incorrect calculation.
Dll
b283   27/05/97  MH    Bug
                       ===
                       Modified printing routines to detect Recursion
                       in the formulae and to trap it and display a
                       dialog with details.
Dll
b281   20/05/97  MH    Bug
                       ===
                       CHCMPADDx fields were failing because the call to
                       GetCust hadn't been converted from the DOS system 
                       correctly. Also the CHORDDELx fields hadn't been 
                       added into the Data Dictionary.
                       Mod
                       ===
                       Added the CHCURSYM - Currency Symbol for DB.
Dll
b281   13/05/97  MH    Bug
                       ===
                       Added support for ACTEL2 and ACCOS which were missing
                       from DICLINKU.PAS.
Form + Dll
b280   09/05/97  MH   Mods
                      ====
                      Modified to support the new data dictionary
                      changes from adding Job Costing and Multi
                      Location Stock into the Report Writer.

                      Changed Initialisation so it opens the stock
                      location file.
                      
Dll
4.10d  01/05/97  MH   Bugs
                      ====
                      If you printed multiple copies of a form direct
                      to printer it didn't delete the swap file.
Dll
4.10c  25/04/97  MH   Mods
                      ====
                      Added support for THDEBTNO - last debt chase letter no.
Dll
v4.10b 21/04/97  MH   Mods
                      ====
                      Added CHORDAD1-5 as requested by NW to print the 
                      Delivery Address of the originating order.
Dll
v4.10a 18/04/97  MH   Bug
                      ===
                      CHCMPADD1-5 were crashing with a range check error
                      because 1213 was being subtracted to generate the field number.

Form + Dll
v4.10  25/03/97  MH   Release Version

Dll
b266   21/03/97  MH   Mods
                      ====
                      Modified the field info field at the bottom of the columns list
                      in the Table Options to display the column id.
            
Dll
b265   20/03/97  MH   Mods
                      ====
                      Added System Currency Company and Day Rate fields into DicLinkU.
Dll
b264   17/03/97  MH   Bugs
                      ====
                      Modified CHDADDR1 to 5 so that they return the system address for
                      purchase transactions if the invoice's delivery address is blank.
Dll
b263   11/03/97  MH   Bugs
                      ====
                      Fixed progress indicator for labels, and EL modified the include
                      clause for Picking Lists to exclude credits.
Dll
b262   07/03/97  MH   Mods
                      ====
                      Modified Single Picking list include for multi location stock.
 
Form + Dll
b261
       27/02/97  MH   Mods
                      ====
                      Modified the Print Preview of forms from the form designer so
                      that it loads the first sin and then loads the customer and
                      detail lines for that sin.

                      Modified the Page Number control so that it has an alignment.

                      Modified the Form Options dialog so the printers are in 
                      alphabetical order.

       25/02/97  MH   Mods
                      ====
                      Added a Test Mode into the printing routines which can be used 
                      with batched forms and labels. All db fields and formulae are
                      printed as a black filled rectangle, and tables as an unfilled
                      rectangle (Don't want to use all the toner printing it).

       24/02/97  MH   Mods
                      ====
                      Modified Formula Options so that the Table colums are in a 
                      more useful order - current row, running total, previous
                      row. Have had lots of problems because running total was
                      first and being selected instead of current row.

                      Modified Formula, Formula Column and Print If Options
                      dialogs to use the popup list of database fields, mainly
                      to reduce the delay going into them.

                      Added button for Default Form font to toolbar.

                      Added options to the controls popup menus for Font
                      and Print If.

                      Bug
                      ===
                      Modified the Bitmap Control to redraw itself after its bitmap
                      has been changed.

Form + Dll
b260   18/02/97  MH   Mods
          -           ====
       20/02/97       Support for Labels added into Form Designer and 
                      SBSForm.Dll.

Dll
b258   13/02/97  MH   Bug
                      ===
                      Fixed bug in GetFieldText which caused lower case field names
                      in formulae to fail and print "Error!"
Dll
b257   12/02/97  MH   Bug
                      ===
                      Modified the way the debt chase letters update the last letter
                      flag on the invoices, and the way they and statements add the
                      note line. Was possible to get 2 note lines for the first row
                      on page 2.

                      Modified GetFieldVal in the formula parser to reset the DblResult
                      when it does a substring operation.

Dll
b257   07/02/97  MH   Bug
                      ===
                      Fixed bugs in the functions to add note lines to invoices when
                      printing debt chase letters and statements. Lines had incorrect
                      note type on them so they didn't appear on the list, and it was
                      adding 2 lines per invoice.

Dll
b256   05/02/97  MH   Bug
                      ===
                      Modified Print Preview window so the auto min and auto max
                      system menu options cannot both be selected automatically.
Dll
b255   05/02/97  MH   Bug
                      ===
                      Fix for -ve numbers in GetFormulaText broke some types of formula.

                      Mods
                      ====
                      Modified GetDBFEvent to set DblResult in addition to StrResult.
Form + Dll
b254   05/02/97  MH   Bug
                      ===
                      Modified GetFormulaText in PrntForm.Pas because formulae which
                      gave -ve numbers were having a +ve DblResult set. This was
                      caused by the format of the string returned by the parser.

       04/02/97  EL   Mods
                      ====
                      Changed include for Debt Chase Letters.

       04/02/97  MH   Bugs
                      ====
                      Changed the VAT Goods fields in DicLinkU because the call
                      to calculate the goods value's was missing.

                      Changed PrintFullNonTableBody in PrntForm.Pas because it
                      was printing some fields which shouldn't be printed at that
                      point.

Form + Dll
b253   31/01/97  MH   Mods
                      ====
                      Dll Interface and routines changed for support
                      of TSBSPrintSetupInfo.
Dll
       29/01/97  MH   Mods
                      ====
                      Changed Debt Chase letters to support multiple
                      methods and to add notes.

Dll
       28/01/97  MH   Mods
                      ====
                      Add Multi-Location fields into Data Dictionary.

DLL
       23/01/97  MH   Bugs
                      ====
                      Changed PrintFileTo so that it should delete reports printed
                      directly to the printer.

DLL   
       17/01/97  MH   Bugs
                      ====
                      Modified GetFieldVal in the parser so that it sets the value
                      of a field to 1.0/"1.0" during evaluation. Otherwise you 
                      cannot define a division formula with 2 db fields as it was
                      detecting a divide by zero during the evaluation.

FORM
DLL
       09/01/97  MH   Mods
                      ====
                      Changed Form Designer + Dll to use RPrinter 2.0.
DLL   4.01g
       08/01/97  MH   Bugs
                      ====
                      Took out common printer object as it causes a GPF if any
                      printing is done to printer from within a thread.

FORM  4.01b
DLL   4.01f
       18/12/96  MH   Bugs
                      ====
                      Added AppPrinter to SystemInfo so the Printer object can
                      be shared between the EXE and DLL. This fixes a bug that
                      meant changes to the paper size in the printer setup
                      were ignored.
                      Changed the Batch Printing routines so that if it is printing
                      an invoice with no lines it doesn't do the relational link
                      in DicLnk2U, which loads in dud Inv details.
DLL
4.01e  10/12/96  MH   Bug
                      ===
                      Fixed a bug in the form printing routines which caused the
                      table section of page 3 to be printed on page 2. This was
                      happening with STAT_SBS.EFD. Was caused by the LastControlPrinted
                      value being reset whenever a new page was thrown. It was
                      fixed by saving and restoring the LastControlPrinted value
                      at the start and end of PrintControlList. This bug would
                      cause controls to be printed multiple times or not at all on
                      additional pages.
DLL
4.01d  09/12/96  MH   Bug
                      ===
                      Took out the section which converted currency fields to
                      their respective symbols. Added code to design-time printing
                      routines to set TCust and TInv.
                      
FORM
4.01a  12/11/96  MH   Bugs
                      ====
                      About menu option changed to "About".
DLL
4.01c  12/11/96  MH   Mod
                      ===
                      Table printing routine modified so that blank lines caused
                      by hidden columns and print if's aren't shown.

       11/11/96  MH   Bugs
                      ====
                      Set scaled to false on Form Definition Set forms.
DLL
4.01b  08/11/96  MH   Bugs
                      ====
                      Fixed a bug in form definition sets where an incorrect
                      Blank call was causing an access violation. Caused by
                      SyssForms being moved into memory from stack.
DLL
4.01a  05/11/96  MH   Bugs
                      ====
                      Added a clear button in Form Definitiion Set Detail so that
                      a chosen form can be cleared.
FORM + DLL
4.01   30/10/96  MH   Mods
                      ====
                      Modified Database Field and Formula Options so that they
                      remember the last file they used.

                      Modified Database Field and Formula Columns so that they
                      remember the last file used in the table.

                      Modified the Table options so that new columns pick up the
                      font of the first column.

                      Modified the Field Select Dialog so that it remembers its
                      position in the list - usefull when doing addresses - for
                      new fields.

                      Add new data dictionary fields:

                        1048 ACINVTO  Invoice To - Cust.SOPINVCODE
                        1049 ACAUTOWR Auto Write Off - Cust.SOPAutoWOff
                        1050 ACUSER1  User Defined 1 - Cust.UserDef1
                        1051 ACUSER2  User Defined 2 - Cust.UserDef2

                        2075 THUSER1  User Defined 1 - Inv.DocUser1
                        2076 THUSER2  User Defined 2 - Inv.DocUser2

                        5072 STBARCOD Bar Code - Stock.BarCode
                        5073 STUSER1  User Defined 1 - Stock.StkUser1
                        5074 STUSER2  User Defined 2 - Stock.StkUser2


       29/10/96  MH   Mods
                      ====
                      Added Printer Name into Form Options

                      Added Form Definition Sets

                      Changed the DB Field selection window so that it hangs around
                      in the background instead of being destroyed. This means it
                      will popup a lot quicker if the user is accessing the same
                      file


DLL
4.00h  23/10/96  MH   Bug Fix
                      =======
                      Modified the print table routine so that the column headers
                      were positioned better on the Laserjet 4 & 5.

       22/10/96  MH   Removed a debug message from DicLinkU which was displayed
                      for each currency used during statements. Whoops!

FORM
4.00d  22/10/96  MH   Bug Fix
                      =======
                      Rewrote the Save Form As handler because the Save As control
                      wasn't asking if you wanted to overwrite under every circumstance.
                      Is now done manually with FileExists.
FORM+DLL
       30/09/96  MH   Mod
                      ===
                      Changed the default width calculations to use 'S' instead
                      of 'M' as 'S' is a more average character than 'M'.
DLL
4.00g  26/09/96  MH   Bug Fix
                      =======
                      Fixed a bug with the Aged Currency fields where single currency
                      versions were being updated twice.
FORM
4.00c  26/09/96  MH   Bug Fix
                      =======
                      Changed the components to fix a bug when deleting a set of
                      controls. If you selected a set, then unselected one of
                      them and pressed <DEL> it deleted the unselected control.
DLL
4.00f  09/09/96  MH   Mod
                      ===
                      Changed the printing routines for Aged Statements to
                      create the Scratch Object instead of picking it up from
                      Enterprise. Added routines for Consolidated Picking Lists.

       11/09/96  MH   Changed the printing routines for Delivery Labels and
                      Consolidated Picking Lists (AdjustTable).

       20/09/96  MH   Misc mods to get product via delivery labels to print.

DLL
4.00e  04/09/96  MH   Bug Fixes
                      =========
                      Fixed bug with printing batches where the page number
                      wasn't being reset when the next item in the batch was
                      loaded.
DLL
4.00d  30/08/96  MH   Bug Fixes
                      =========
                      Fixed bug with BTrieve Requester crashing by removing
                      Multi-User check in VARCONST initialisation section.

                      DLL
4.00c  26/08/96  MH   Bug Fixes
                      =========
                      Modified DicLinkU as CHCTUNIT (Cheque Units) was crashing
                      with a range check error. Parameter to call was incorrect.

FORM + DLL
4.00b  20/08/96  MH   Bug Fixes
                      =========
                      Turned Scaling off on all forms, as causes form to
                      resized if Large Fonts are selected.

                      Initialized the Default Font values as was defaulting
                      to Arial 7 point if Large Fonts were selected.

                      Bitmap Control - Changed so that bitmaps loaded in cannot
                      have a width or height greater than the usable area of the
                      page.

                      All Controls - Changed so that they can detect they are
                      completely hidden by a bitmap and do not paint. This reduces
                      the number of repaints done by approx 60% when moving a
                      large bitmap.

                      Bitmap Control - Removed the Transparency so that controls
                      repainting do not overwrite it. Makes it look better.

                      Clipboard Copy - Fixed a bug which caused a 'List Out Of
                      Bounds' if a Table control was being copied and it wasn't
                      the topmost of the controls being copied.

                      Added '/RUNNORM' parameter to run Form Designer in a normalised
                      window for development use.

                      Changed CanvasDrawText in FormUtil to reset the brush style to
                      bsClear as some text is being painted with an opaque background.
                      Appears to be caused by Delphi upgrade.

                      Changed Table control as wasn't detecting column edge correctly
                      when printing the column headers.

                      Bug in table printing caused column separators to be printed
                      beyond right hand border of table.

                      Modified SBSController so that the seperator bars are forced on
                      as it looks untidy when they are off, and you cannot turn them
                      off anymore anyway. SIN_SBS had the Page Header turned off.

                      Change Line and Page Options Dialogs as they were resizable
                      windows and not dialogs.

FORM + DLL
4.00a  16/08/96  MH   Exchequer Enterprise Released


****************************************************************************)

end.


