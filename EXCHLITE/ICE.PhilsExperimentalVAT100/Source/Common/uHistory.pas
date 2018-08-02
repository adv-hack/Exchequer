unit uHistory;

interface

const
  PLUGIN_VER = '6.5.1';
  PLUGIN_BUILD = '14';

function PluginVer: string;

implementation

function PluginVer: string;
begin
  Result := PLUGIN_VER + '.' + PLUGIN_BUILD;
end;

(*******************************************************************************

VERSION HISTORY
===============

25/10/2010 6.5.1.14
--------------------------------------------------------------------------------

  CS  Corrected the handling of mapped-drives. See _GetExCompanies()
      in uExFunc.pas -- Copied from 6.3

06/11/06   v0.0m

-----------------------------------------------------

  CS   The Creditors and Debtors revaluation line and relevant double entry in
       the Revaluation journal are now automatically removed from the Bulk
       Export transactions, in effect giving the same detail as if an
       unpost/repost has taken place with the same lines removed.

       (Revised fix, based on input from EL -- see v0.0k).

  CS   The hold status on transactions was not coming across correctly if more
       than just a hold status existed on the transaction. This has been fixed.

  CS   Settlement discount was showing incorrectly in currency (instead of
       consolidated). This was a Toolkit issue, and has been fixed by PR.

25/10/06   v0.0l

-----------------------------------------------------

  CS   Matching was sometimes not being set correctly during Dripfeed, and as a
       consequence was showing the matching date as DD/MM/YYYY.

       This was happening when a transaction was renumbered on import (because
       there was already a transaction against the reference). The matching
       record was not aware of the change, and still held the original
       reference, so that when the it attempted to find the original transaction
       (in order to display the date), the transaction could not be found, or an
       erroneous transaction was found.

       Note that to fix this properly has required a new database file to be
       introduced (XREF.DAT), which keeps a permanent record of all the
       transactions whose OurRefs were changed on import. This is then used to
       find the correct OurRef for matching records that relate to a transaction
       with an altered OurRef, even if it was imported through a previous
       drip-feed import, or through the original bulk import.


23/10/06   v0.0k

-----------------------------------------------------

  CS   When a re-valued posted transaction from the client system is posted on
       the Practice system, the posted value is based on the re-valued
       transaction value and not the original transaction value which causes the
       Debtor/Creditors consolidated amount to be incorrect.

       To correct this, a NOM journal is created during the client sync bulk
       import stage that reflects the difference between the re-valued rate and
       original exchange rates on transactions that are imported into the
       practice edition.

11/10/06   v0.0j

-----------------------------------------------------

  CS   Stock numbers are no longer imported, and will be left at zero.

  CS   The CC/Dep "Inactive A/C" checkbox is now set correctly on import.

  CS   Purchase Payment transactions which include Currency Variance lines were
       not being exported/imported correctly. This has now been fixed.

  CS   Revalued transactions were being imported with the original value
       instead of the revalued amount.

10/10/06   v0.0i

-----------------------------------------------------

  CS   Purchase Payment transactions which include Currency Variance lines were
       not being exported/imported correctly.

       Also, for Opening Balance records, transactions which have currency
       variance lines were ending up with Base Equivalent values when they
       should have been zero.

       This has now been fixed.

  CS   The dripfeed import was generating an OLE error. This has been fixed.

09/10/06   v0.0h

-----------------------------------------------------

  CS   Switching between a company which is in dripfeed mode, and a company
       which is not (using File | Open Company) now correctly re-enables the
       options which were disabled under dripfeed mode.

06/10/06   v0.0g

-----------------------------------------------------

  CS   Settlement discount lines on PPY now display the correct Base Equiv
       value when imported.

  CS   Where nominal transaction lines are against a currency that differs
       from the currency of the transaction header, the currency rate is now
       imported correctly (instead of defaulting to 1.0).

  CS   As a result of the blank Parent Stock Code (for stock items at the top
       of the stock tree) sometimes being represented by a string of spaces,
       and sometimes by a null string, some groups of stock records were being
       omitted from the export.

       This has now been fixed.

       Note that the underlying error (the conflicting representations of
       empty Parent Stock Codes) has not been fixed, and could cause problems
       in other parts of Exchequer and IRIS Accounts Office.

05/10/06   v0.0f

-----------------------------------------------------

  CS   Export no longer includes AUTO-NOM, PIN-AUTO, and SIN-AUTO transactions.

  CS   Nominal transactions where multiple lines have VAT now export/import
       correctly.

  CS   Purchase quantity for stock no longer doubles up.

  CS   The "Inactive A/C" setting is now exported/imported correctly.

  CS   PPY and SRC transactions with Settlement Discount lines now export/import
       correctly.

11/09/06   v0.0e
-----------------------------------------------------

  CS   Import of Opening Balance Matching Records was reporting over-settled
       amounts. This was in fact a symptom of other problems, including the
       incorrect assignment of OurRef values for Opening Balance records. These
       issues have now been fixed.

*******************************************************************************)

end.

