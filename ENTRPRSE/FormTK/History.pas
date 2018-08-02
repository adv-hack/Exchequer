unit History;

interface

Const
  // Form Toolkit Version Number
  FormTKVer = 'TKFORM~V1101.094';
  //             |     |   |
  //  Module ID -+     |   +- Form Toolkit Build Number
  //                   |
  //      Major Exchequer Version Number
  //
  // NOTE: The build number should be incremented for any new version leaving
  // the department, even if just to QA for testing.

implementation


(****************************************************************************

VERSION HISTORY
===============

TKFORM~V110.094  20/01/2018
-----------------------------------------------------------------------------------------------
  MH     Corrected version number pre-fix for 2018 R1 which is v11.0


TKFORM~V101.093  22/08/2017
-----------------------------------------------------------------------------------------------
  MH     Corrected version number pre-fix for 2017 R2 which is v10.1
  

TKFORM~V100.093  21/08/2017
-----------------------------------------------------------------------------------------------
  MH     Rebuilt to pickup new DD fields for ABSEXCH-18163
  

TKFORM~V100.092  20/04/2017
-----------------------------------------------------------------------------------------------
  MH     Added 'V' into version to keep sorting order with move from '9' to '10'


TKFORM~92.091   06/02/2017 
-----------------------------------------------------------------------------------------------
  MH     ABSEXCH-14925: Added support for extra image types


TKFORM~92.090   16/09/2016
-----------------------------------------------------------------------------------------------
  PS     ABSEXCH-2581: PDF attachment name has missing digit


TKFORM~91.089   02/09/2016
-----------------------------------------------------------------------------------------------
  PR     ABSEXCH-16704: Added debugging


TKFORM~91.088   08/06/2016
-----------------------------------------------------------------------------------------------
  MH     ABSEXCH-17590: Added new TH User Defined Fields


TKFORM~91.087   16/05/2016
-----------------------------------------------------------------------------------------------
  MH     ABSEXCH-17041: Modified TEFPrintJob.Set_pjBinIndex to check that the Bins array has
         entries to workaround a problem where 'Print To OneNote' lies and claims to support
         Bins whilst not having any entries in the Bins list.  Caused a Catestrophic Failure
         when 'Print To OneNote' was the Windows default printer.


TKFORM~90.086   16/02/2016
-----------------------------------------------------------------------------------------------
  MH    ABSEXCH-17241: Copied ABSEXCH-17237 mods to handle a NIL DevMode


TKFORM~90.085   19/10/2015
-----------------------------------------------------------------------------------------------
  PKR   ABSEXCH-17109: Form Designer changes made for Intrastat.  FormTK rebuild. for v2016 R1.



TKFORM~90.084   19/10/2015
-----------------------------------------------------------------------------------------------
  MH    ABSEXCH-16847: Copied ABSEXCH-16828 mods to removed popup error message from v7.0.9

  MH    ABSEXCH-16818: Copied ABSEXCH-16818 mods to fix ATOM leak from v7.0.13

  MH    ABSEXCH-16958: Copied EntForms caching mods in from v7.0.11



TKFORM~80.083   28/07/2015
-----------------------------------------------------------------------------
  MH    Rebuilt after merging v7.0.14 and 2015 R1 code bases.
  

TKFORM~7014.082  19/06/2015
-----------------------------------------------------------------------------
  MH    ABSEXCH-16284: Rebuilt to pickup changes to Transaction PPD Total fields


TKFORM~7014.081  16/06/2015
-----------------------------------------------------------------------------
  MH    ABSEXCH-16490: Rebuilt to pickup changes to UNC Path support


TKFORM~7014.080  08/06/2015
-----------------------------------------------------------------------------
  MH    ABSEXCH-16490: Added UNC Path support to Forms Toolkit


TKFORM~7014.079  24/04/2015
-----------------------------------------------------------------------------
  MH    ABSEXCH-16386: Copied ABSEXCH-16268 'Set the 8087 Control Word to disable
                       Divide by Zero errors in printer drivers' in from v7.0.9


TKFORM~80.082       07/04/2015
-----------------------------------------------------------------------------
  MH    Updated version for Exchequer 2015 R1


TKFORM~7014.078  26/03/2015
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup new PPD fields


TKFORM~71.082       11/02/2015
-----------------------------------------------------------------------------
  MH    ABSEXCH-16142, ABSEXCH-16144, ABSEXCH-16145: Rebuilt to pickup new fields 


TKFORM~71.081       05/02/2015
-----------------------------------------------------------------------------
  PR    ABSEXCH-16022: Rebuilt to pickup fix in SBSForm.Dll


TKFORM~71.080       23/01/2015
-----------------------------------------------------------------------------
  MH    ABSEXCH-16062: Rebuilt to pickup fix in SBSForm.Dll


TKFORM~71.079       14/01/2015
-----------------------------------------------------------------------------
  MH    ABSEXCH-15827: Rebuilt to pickup implementation of new fields


TKFORM~OrdPay.078   26/11/2014
-----------------------------------------------------------------------------
  MH    ABSEXCH-15836: Rebuilt to pickup new Country fields


TKFORM~OrdPay.077   17/09/2014
-----------------------------------------------------------------------------
  MH    Order Payments - Added support for printing SRCs as VAT Returns


TKFORM~7012.077 08/10/2014
-----------------------------------------------------------------------------
  MH    Rebadged from v7.1 to v7.0.12


TKFORM~71.077   09/09/2014
-----------------------------------------------------------------------------
  MH    ABSEXCH-15052: Rebuilt to pickup support for STECSERV


TKFORM~7012.077 08/10/2014
-----------------------------------------------------------------------------
  MH    Rebadged from v7.1 to v7.0.12


TKFORM~71.077   09/09/2014
-----------------------------------------------------------------------------
  MH    ABSEXCH-15052: Rebuilt to pickup support for STECSERV


TKFORM~7010.076  02/06/2014
-----------------------------------------------------------------------------
  MH    ABSEXCH-15404: Added PE Flags to force entire component to be loaded into memory


TKFORM~709.075  17/02/2014
-----------------------------------------------------------------------------
  MH    ABSEXCH-14980: Added MadExcept Error logging into the following routines:-

          - TEFPrintingToolkit - Base Printing Object
            - Initialize            - object creation
            - OpenPrinting          - Non-Public Method called by COMTK - formstk equivalent of OpenToolkit

          - TEFPrintJob - PrintJob object
            - Create                - object and sub-object creation
            - PrintToPrinter
            - PrintToTempFile
            - Set_pjPrinterIndex    - executes when pjPrinterIndex property set by app
            - Set_pjPaperIndex      - executes when pjPaperIndex property set by app
            - Set_pjBinIndex        - executes when pjBinIndex property set by app
            - CheckPaperlessLicence - Internal routine to check licence for Paperless module

          - TEFImportDefaults - Import Defaults object
            - ImportDefaults        - public method
            - AddLabels             - Non-Public Method called by COMTK

          - TEFPrintTempFile - object returned by PrintToTempFile
            - Bang                  - Internal Method
            - DisplayPreviewWindow
            - SendToDestination
            - SaveAsFile


TKFORM~709.074  31/01/2014
-----------------------------------------------------------------------------
  MH    ABSEXCH-14999: Modified ImportDefaults to use ANSIString for the email address
        to avoid long addresses being cut off


TKFORM~709.073  24/01/2014
-----------------------------------------------------------------------------
  MH    Extended TEFImportDefaults.ImportDefaults to support Ledger Multi-Contacts.


TKFORM~708.072  26/11/2013
-----------------------------------------------------------------------------
  MH    Recompiled for SBSForm v7.0.8.184 changes


TKFORM~707.071  28/10/2013
-----------------------------------------------------------------------------
  MH    Recompiled for SBSForm v7.0.7.183 changes


TKFORM~706.070  09/09/2013
-----------------------------------------------------------------------------
  MH    Recompiled for SBSForm v7.0.6.180 changes

TKFORM~70.069   13/09/2012
-----------------------------------------------------------------------------
  MH    Changed version for v7.0 release


TKFORM~610.068 - 16/04/2012 - ABSEXCH-12804
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup fix to PCC Printing


TKFORM~610.067 - 01/03/2012 - ABSEXCH-11937
--------------------------------------------------------------------------------------------
  MH	     Stash forms locally in Windows\Temp folder rather than uploading them to the
             network Exchequer\Swap folder, this should improve performance and lower
             network traffic slightly.


TKFORM~610.066 - 01/03/2012 - ABSEXCH-12596
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup changes for new TLTHRESH field


TKFORM~610.065
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup changes to RAVE components to support 32,000 pages


TKFORM-69.064 - 15/11/2011
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup changes from SbsForm.Dll for Audit Notes


TKFORM-69.063 - 03/11/2011
-----------------------------------------------------------------------------
  MH    Modified OpenPrinting/ClosePrinting to manage the Custom Fields object as it
        was causing internal exceptions which stopped things printing


TKFORM-69.062 - 26/10/2011
-----------------------------------------------------------------------------
  PR    Rebuilt to pickup User Defined Fields changes


TKFORM-67.061 - 09/02/2011
-----------------------------------------------------------------------------
  PR    ABSEXCH-11390   Made rename of edf/pdf file work with print jobs other than transactions.


TKFORM-67.060 - 09/02/2011
-----------------------------------------------------------------------------
  PR    ABSEXCH-11390   Added code to rename edf/pdf file to user friendly filename for emailing.


TKFORM-66.059 - 09/02/2011
-----------------------------------------------------------------------------
  MH    Exch     Recompiled to pick up changes to printer components for ABSEXCH-10547


TKFORM-65.058 - 06/12/2010
-----------------------------------------------------------------------------
  MH    ABSEXCH-10578: Rebuilt to pickup fix for Adobe Acrobat 10


TKFORM-65.057 - 02/12/2010
-----------------------------------------------------------------------------
  MH    ABSEXCH-10578: Rebuilt to pickup fix for Adobe Acrobat 9


TKFORM-65.056 - 13/10/2010
-----------------------------------------------------------------------------
  MH    ABSEXCH-10317: Rebuilt to pickup new TH Override Location field


TKFORM-64.055 - 21/07/2010
-----------------------------------------------------------------------------
  MH    ABSEXCH-10050: Rebuilt to pickup changes to Consolidated Picking Lists


TKFORM-64.054 - 08/06/2010
-----------------------------------------------------------------------------
  MH    ABSEXCH-7916: Rebuilt to pickup changes to Statement sorting


TKFORM-63.053 - 23/03/2010
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup additions to transaction sorting options


TKFORM-63.052 - 10/03/2010
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup Windows 7 Date fix in ETDateU


TKFORM-63.051 - 09/03/2010
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup fix in transaction line sorting (ABSEXCH-9661)


TKFORM-63.050 - 03/03/2010
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup fix in transaction line sorting (ABSEXCH-7937)


TKFORM-63.049 - 01/02/2010
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup new v6.3 fields


TKFORM-62.048 - 04/09/2009
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup fixes to new v6.2 fields :-(


TKFORM-62.047 - 26/08/2009
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup new v6.2 fields


TKFORM-601.046 - 23/03/2009
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup Picking List mods for hidden BoM Lines


TKFORM-600.045 - 13/11/08 (SQL)
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup corrections to sharing permissions when opening form xml files


TKFORM-600.044 - 22/07/08 (SQL)
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup SQLUtils API changes


TKFORM-600.043 - 17/07/08 (SQL)
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup fault-tolerance changes to ReadEntLic for BGA Bespoke


TKFORM-600.042 - 19/06/08
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup fault-tolerance changes to ReadEntLic for BGA Bespoke

TKFORM-600.041 - 28/02/08
-----------------------------------------------------------------------------
  CS    Recompiled after changes to SBSForm.DLL


TKFORM-571.040 - 18/09/07
-----------------------------------------------------------------------------
  MH    Applied generic v6.00 IRIS icon

TKFORM-571.040 - 18/09/07
-----------------------------------------------------------------------------
  MH    Applied generic v6.00 IRIS icon


TKFORM-571.039 - 12/09/07
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup correction to Register.GetFormHeader which was
        crashing/hanging a picking list run using PCC Forms.


TKFORM-571.037/038 - 12/07/07
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup changes to the JVTYPE field


TKFORM-600.036 - 23/05/07
-----------------------------------------------------------------------------
  MH    Fixed bug in printing where orientation was being ignored


TKFORM-600.035 - 01/05/07
-----------------------------------------------------------------------------
  MH    Modified to always pickup Dictnary.dat from the main Exchequer directory


TKFORM-571.034 - 07/03/07
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup new DD fields


TKFORM-571.033 - 29/01/07
-----------------------------------------------------------------------------
  MH    Rebuilt to pickup new DD fields


TKFORM-571.032 - 25/01/07
-----------------------------------------------------------------------------
  MH    REbuilt to pickup new DD fields


TKFORM-571.031 - 10/11/06
-----------------------------------------------------------------------------
  MH    Fixed bug in OpenPrinting where the data files are opened caused by
        the insertion on NomViewF into the middle of the existing files and
        the subsequent renumber of every non-eduardo data file.

  MH    Rebuilt to pickup mods to Picking Lists. 


TKFORM-571.030 - 26/10/06
-----------------------------------------------------------------------------
  HM    Rebuilt to pickup various cheque fixes in SbsForm.Dll


TKFORM-571.029 - 06/10/06
-----------------------------------------------------------------------------
  HM    Rebuilt to pickup various fixes to SbsForm.Dll

                                n
TKFORM-571.028 - 18/04/06
-----------------------------------------------------------------------------
  HM    Rebuilt to pickup various fixes to SbsForm.Dll


TKFORM-570.027 - 02/09/05
-----------------------------------------------------------------------------
  HM    Rebuilt to pickup fix to TLOURREF.


TKFORM-570.026 - 31/08/05
-----------------------------------------------------------------------------
  HM    Rebuilt to pickup new fields


TKFORM-570.025 - 30/08/05
--------------------------------------------
  HM    Rebuilt to pickup new fields


TKFORM-570.024 - 19/08/05
--------------------------------------------
  HM    Rebranded for IRIS Enterprise Software / Excheqer


TKFORM-570.023 - 09/08/05
--------------------------------------------
  HM    Rebuilt to pickup lastest dictionary changes


TKFORM-570.022 - 28/07/05
--------------------------------------------
  HM    Added defTypeSalesReturnNote and defTypePurchaseReturnNote

  MH    Added EN570 and RET compiler directives


TKFORM-561.020
--------------------------------------------
  HM    Rebuilt for v5.61


TKFORM-560.019
--------------------------------------------
  HM    Released for v5.60.001


TKFORM-561.018 - 26/07/04
--------------------------------------------
  HM    Modified FindEnterpriseDir in oMain.Pas to use VAOInfo to link to the
        main company directory.
         

TKFORM-560.018 - 26/07/04
--------------------------------------------
  HM    Reworked the error handling in TEFPrinters.Create as this was where
        Bob was crashing, after re-installing the printers everything worked
        fine but we needed better error handling.


TKFORM-560.017 - 23/07/04
--------------------------------------------
  HM    Debug version for Bob Barker who was getting Catastrophic Failures
        creating the COMTK.


TKFORM-560.016 - 22/04/04
--------------------------------------------
  HM    Added defTypeJobPurchaseApplicationCertified and defTypeJobSalesApplicationCertified
        to allow ImportDefaults to distinguish between certified and uncertified
        applications.


TKFORM-560.015 - 20/04/04
--------------------------------------------
  HM    Rebuilt Forms Toolkit to pickup mods and data dictionary changes to
        Form Designer and Report Writer.


TKFORM-560.014 - 23/02/04
--------------------------------------------
  HM    Extended Forms Toolkit to support Customer/Supplier and Stock form
        printing from the COM Toolkit.


TKFORM-552.013 - 11/11/03
--------------------------------------------
  HM    Changed TEFPrinterDetail.Create (oPrinters.Pas) to detect printers
        with no default Paper/Bin and to setup a default to the first paper/
        bin.


TKFORM-551.012 - 27/06/03
--------------------------------------------

  HM    Rebuilt for v5.51


TKFORM-550.011 - 13/05/03
--------------------------------------------

  HM    Modified the non-modal Print Preview window as it was still set to
        position as poDesigned, changed to centre on screen.


TKFORM-550.010 - 11/04/03
--------------------------------------------

  HM    Modified Import Defaults to initialise the Fax and Email Name/
        Addr/No to those specified in System Setup Paperless settings.


TKFORM-550.009 - 21/03/03
--------------------------------------------

  HM    Set the caption on the internal preview window.

  HM    Coded the Print button in the Internal Preview window which had
        previously displayed a message saying "Print Not Coded"


TKFORM-550.008 - 19/03/03
--------------------------------------------

  HM    Extended to support printing Job Records and Job Backing Sheets


TKFORM-501.007 - 17/01/03
--------------------------------------------

  HM    Set Application.ShowMainForm to True to hide the main form


TKFORM-501.006 - 15/01/03
--------------------------------------------

  HM    Changed TEFImportDefaults.Create in oImpDefs to set the fdMode property
        for any forms it adds into the batch, without this the forms didn't print
        properly.  Wasn't detected during testing as the demo program removed and
        re-added the form which worked-around the problem without realising.

TKFORM-500.005
--------------------------------------------

  HM    Completely rewrote from PrintJob for simpler more flexible interface
        design.

TKFORM-500.004 -
--------------------------------------------
  HM    Coded TEFPrintFormsList.Delete and modified TEFPrintFormsList.Clear to
        use that to clear out the list instead of its own duplicated code.

  HM    Added IndexOf methods to TEFPrinters and TEFStringList to allow easy
        searching for the Printer/Paper/Bin entries.

TKFORM-500.003 - 24/07/02 - Internal Testing
--------------------------------------------
  HM    Modified TEFPrintJobDetails.Initialise to prevent Access Violations.

TKFORM-500.002 - 24/07/02 - Internal Testing
--------------------------------------------
  HM    Extended TEFPrintJobDetails.Initialise to delete any pre-existing Forms
        within the Forms List.

TKFORM-500.001 -          - Initial Creation of Form Toolkit
------------------------------------------------------------

****************************************************************************)

end.
