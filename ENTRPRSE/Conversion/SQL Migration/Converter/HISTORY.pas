unit History;

interface

Const
  ConversionVersion = 'Build 11.0.143';
  ExchequerVersionMessage = 'For use with Exchequer 2018 R1 Only';

implementation

(****************************************************************************

Conversion Version History
==========================

Build 11.0.143  26/01/2018
--------------------------------------------------------------------------------
 MH        ABSEXCH-19316: Remove any SQLConfig.Ini inherited from original MSSQL Installation
           to ensure Pending Status for migrated companies


Build 11.0.142  19/12/2017
--------------------------------------------------------------------------------
 MH        ABSEXCH-19475: GDPR Changes, Updated migration objects for

             CustSupp.Dat
             Document.Dat
             JobHead.Dat
             JobMisc.Dat (Employees)
             CustomFields.Dat
             MLocStk.Dat (User Profile)

           Added new migration object for AnonymisationDiary


Build 10.1.141  25/09/2017
--------------------------------------------------------------------------------
 MH        ABSEXCH-19054: Limited Reporting User Password field to 30 characters for consistency


Build 10.1.140  05/09/2017
--------------------------------------------------------------------------------
 MH        ABSEXCH-18855: Updated for new Password Complexity fields in User Profile Record

Build 10.0.139  26/01/2017
--------------------------------------------------------------------------------
 MH        ABSEXCH-18202: Delete default contents of Company SystemSetup tables prior to the
           conversion to avoid duplicate rows being inserted by the migration.

           ABSEXCH-18220: Completed merge of ABSEXCH-15244 into live code

Build 10.0.138  25/01/2017
--------------------------------------------------------------------------------
 MH        ABSEXCH-18200: VAT100 - HMRC Narrative field not being converted to VarBinary correctly

Build 10.0.137  14/10/2016
--------------------------------------------------------------------------------
 MH        ABSEXCH-17754 - Recompiled for 2017 R1 and new branding

Build 9.2.137   13/09/2016
--------------------------------------------------------------------------------
 PR        ABSEXCH-15014 - Updated warning message for R3.

Build 9.2.136   12/09/2016
--------------------------------------------------------------------------------
 PR        ABSEXCH-15014 - Moved creation of HistPrge table into read thread.
                           Amended it to create indexes on the table.

Build 9.1.135   04/05/2016
--------------------------------------------------------------------------------
 CS        ABSEXCH-17353 - GL Budgets - Extend to include 5 budget revisions

Build 9.1.134   27/04/2016
--------------------------------------------------------------------------------
 CS        ABSEXCH-16737 - re-order transactions after SQL migration

Build 9.0.133   27/01/2016
--------------------------------------------------------------------------------
 CS        ABSEXCH-17118 - Added support for new Intrastat fields

Build 8.0.131   24/07/2015
--------------------------------------------------------------------------------
 CS        Added support for VAT100 and corrected merge errors

Build 7.0.14.130   14/05/2015
--------------------------------------------------------------------------------
 CS        T2-139: Added support for additonal Prompt Payment Discount fields
                   and new SystemSetup table


Build 8.0.130      07/04/2015
--------------------------------------------------------------------------------
 MH        Updated for Exchequer 2015 R1 versioning


Build 7.0.14.129   25/03/2015
--------------------------------------------------------------------------------
 MH        ABSEXCH-16284: Added support for Prompt Payment Discount fields

Build OrdPay.129   02/12/2014
--------------------------------------------------------------------------------
 MH        ABSEXCH-15836: Updated for Country Code mods

Build OrdPay.128   24/10/2014
--------------------------------------------------------------------------------
 MH        Updated for Order Payments changes:-

             * New Customer fields
             * New Transaction Header fields
             * New System Setup (SysR) field
             * Copy Order Payment Matching in ExchqChk to OrderPaymentsMatching table
             * Added new OPVATPay file             


Build 7.1.128     09/09/2014
--------------------------------------------------------------------------------
 MH        ABSEXCH-15052: Added support for Stock stIsService field


Build 7.0.11.127  16/07/2014
--------------------------------------------------------------------------------
 CS        ABSEXCH-15525 - Copied code forward from v7.0.9 and switched order
                           of EnableAndRebuildIndexes and EnableForeignKeys in
                           ProgressTreeF.pas

Build 7.0.9.126   19/03/2014
--------------------------------------------------------------------------------
 CS        ABSEXCH-15114: Added missing CIS field


Build 7.0.9.125   19/02/2014
--------------------------------------------------------------------------------
 CS        ABSEXCH-15079 - SQL Migration error on Roles


Build 7.0.9.124   14/02/2014
--------------------------------------------------------------------------------
 MH        ABSEXCH-14946: Added support for new Apps 'n Vals field

Build 7.0.9.123   22/01/2014
--------------------------------------------------------------------------------
CS         MRD2.4.07: Added support for Ledger Multi-Contact tables

Build 7.0.8.122   27/11/2013
---------------------------------------------------------------------------------------------------
 MH        ABSEXCH-14797: Added support for Consumer Ledger - CustSupp & ExchqSS


Build 7.0.7.121   25/10/2013
---------------------------------------------------------------------------------------------------
CS         ABSEXCH14703: Merged EBUSDOC into DOCUMENT, and added check for SQL
                         protocol.

Build 7.0.7.120   16/10/2013
---------------------------------------------------------------------------------------------------
MH         ABSEXCH-14703: Added support for Delivery Postcode and Transaction Originator fields.
           ABSEXCH-14705: Added support for new Transaction Originator fields.


Build 7.0.6.119   18/09/2013
---------------------------------------------------------------------------------------------------
MH         ABSEXCH-14626: Fixed bugs in TCopyFiles.CopyFiles and TCopyFiles.LogFiles where FindClose
           wasn't being called to free the resources meaning that directories weren't being deleted
           until the app was closed.


Build 7.0.6.118   17/09/2013
---------------------------------------------------------------------------------------------------
CS         ABSEXCH-14598 - SEPA/IBAN changes


Build 7.0.6.117   10/09/2013
---------------------------------------------------------------------------------------------------
MH         ABSEXCH-14557: Reindex query timing out when rebuilding indexes at end of data migration
           ABSEXCH-14605: Change Default number of threads to 10 to improved performance


Build 7.0.5.116   08/07/2013
---------------------------------------------------------------------------------------------------
CS         ABSEXCH-14438: Updated to remove 'Iris' from messages

Build 7.0.4.115   23/05/2013
---------------------------------------------------------------------------------------------------
CS         ABSEXCH-11905: Added support for new EBus CompDescLinesFromXMLParam field

Build 7.0.4.114   13/05/2013
---------------------------------------------------------------------------------------------------
MH         ABSEXCH-13793: Added support for new VAT100 XML fields


Build 7.0.2.113   22/03/2013
---------------------------------------------------------------------------------------------------
MH         ABSEXCH-14167: Extended timeout on Index Rebuild to 4 hours and changed error to a warning
           that doesn't abort the process


Build 7.0.2.112   14/02/2013
---------------------------------------------------------------------------------------------------
MH         ABSEXCH-13360: Disable Indexes before copying data dn Re-enable/Rebuild after data
                          copying phase is complete - improves performance of the copying and
                          eliminates a manual step required by the Installation Engineers.


Build 7.0.2.111   11/02/2013
---------------------------------------------------------------------------------------------------
MH         ABSEXCH-13857: Added export flag to Company table, for Analytics


Build 7.0.110    13/12/2012
---------------------------------------------------------------------------------------------------
CS         ABSEXCH-13846  Modified Dictionary data input to use Dictionary.zip
                          from the conversion files data, rather than Demo.zip
                          from the install directory (this file is out-of-date).

Build 7.0.109    11/09/2012
---------------------------------------------------------------------------------------------------
MH         ABSEXCH-13411  Modified creation of companies to eliminate long filenames in the MCM


Build 7.0.108    06/09/2012
---------------------------------------------------------------------------------------------------
MH         ABSEXCH-13390  Fixed length issues in index fields on ExStkChk

           ABSEXCH-13383  Corrected conversion of CHAR fields for CustomerDiscounts table

           Modified versioning to distinguish between v6.10.1 and v7.0 versions.

           Added version warning label onto initial password windo


Build 107  04/09/2012
---------------------------------------------------------------------------------------------------
MH         ABSEXCH-13370  Modified to auto-create the MISC and SWAP folders in company directories

           ABSEXCH-13374  Added support for clearing down and copying the Audit files


Build 106  29/08/2012   ABSEXCH-13346
---------------------------------------------------------------------------------------------------
MH         Limited max memory usage to 1Gb after WJ experienced problems with higher values


Build 105  23/08/2012   ABSEXCH-11822
---------------------------------------------------------------------------------------------------
CS         Modified EXSTKCHK conversion to include the 'TF' variant (used for
           temporary records during Job Staged Invoicing).


Build 104  22/08/2012   ABSEXCH-13334
---------------------------------------------------------------------------------------------------
MH         Modified CustomFields conversion to run in a single thread and to clear down the
           rows automatically inserted by the SQL creation script.


Build 103  22/08/2012   ABSEXCH-13331
---------------------------------------------------------------------------------------------------
MH         Added monitoring of available memory in Write Thread Pool's QueueData method, if
           less than 50Mb is available it will pause the Read Thread, allowing the Write Threads
           to continue processing queued data, and the Progress Tree will display a message
           asking the user to free up memory.


Build 102  20/08/2012
------------------------------
MH         Added dumping of DataPacket for errors in Read Thread to make diagnosis easier.


Build 101  16/08/2012
------------------------------
MH/CS/PR    Completed Data Write Objects


Build 100  31/07/2012
------------------------------
MH    Rewrote the Data Copying phase to avoid SQL Emulator usage due to memory leaks

      - Added Tasks to Company Details in Conversion Options
      - Added phase to scan Pervasive.SQL install to identify required conversion tasks
      - Modified Company Creation to use ZIP files to create tables based on required conversion tasks
      - Added Progress Tree form to display progress
      - Added Read Thread to read the Btrieve files and post them to the Write Thread Pool
      - Added Write Thread Pool and Write Threads to output the data directly to MS SQL via ADO
      - Added Conversion Warnings and Conversion Warnings dialog

=============================


Build 006  06/05/2009
------------------------------
MH    Modified to use v10.1 Emulator ExchSQL* files instead of ICore* files


Build 005  17/02/2009
------------------------------
MH    Added command line parameter, /AllowErrors, to allow the SQL conversion process to continue
      if errors are found


Build 004  19/11/2008
------------------------------
MH    Modified creation of company logins to trim spaces off short company codes

MH    Modified ResetMCMPaths to create missing directories as this was causing blank
      paths to be put into the company records.

MH    Added checks on the validity of the company codes.


Build 003  06/11/2008
------------------------------
MH    Modified check for Pervasive Root Company to be case insensitive


Build 002  13/10/2008
------------------------------
MH    Extended validation of Reporting User Id's to prevent 1 character being a number


Build 001  02/09/08
-------------------
MH    Initial Development


****************************************************************************)

end.

