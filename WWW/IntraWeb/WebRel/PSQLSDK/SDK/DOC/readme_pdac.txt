Pervasive Direct Access Components (PDAC) - April 2002
                  (HotFix Release)
=========================================================


Overview of the Pervasive Direct Access Components (PDAC)
---------------------------------------------------------

The Pervasive Data Access Components (PDAC) is a set of Visual Component
Library (VCL) components that allow direct access to Pervasive Database
Engines from within the Borland Delphi and C++ Builder Environments.
These components offer a complete replacement for the Borland Database
Engine (BDE), while providing the complete functionality of the BDE.  PDAC
dramatically extends the database development options available to Delphi
and C++ Builder developers.

The Pervasive Data Access Components are provided in versions fully
integrated with the Delphi 3, Delphi 4, Delphi 5, Delphi 6, C++ Builder 3,
C++ Builder 4, and C++ Builder 5 development environments.  Compatibility
with later versions of the Delphi and C++ Builder development tools will
be made available soon after those products are released by Borland.
No support is provided or planned for Delphi 1.0 (16-bit) or 2.0, or C++
Builder 1.0.

This update to the PDAC package provides fixes for a number of issues
discovered in the components.


Installation
------------

To install the PDAC components for Delphi 3-6 and C++ Builder 3-5,
download the following program from
http://www.pervasive.com/developerzone/access_methods/pdac.asp

   PDACSetup.exe

Note: If the Microsoft Windows Installer's "Modify, Repair, Remove" dialog
is observed when running this installer (which should occur if an earlier
"PDAC only" installer has been run), please select "Remove," then run the
new installer again after the old components are removed.


Notes on April 2002 release (Build 247)
-------------------------------------------------------------
This release fixes the following bugs, in addition to those addressed in
earlier releases:

34751   TPvSqlSession.GetAliasParams returns fixed-length 512-byte params
34768   TimeStamp default of '00:00:00' fails under Delphi 6
40392   "Invalid argument to time encode" When using a TpvQuery
40393   Memory leak with PvQuery and Blob column
40394   Memory leak with PvTable and Filter
40412   PvQuery not updating columns being set to NULL
40481   "Invalid Pointer Operation" after applying filter
40513   PvQuery Filters on integral types don't work


Notes on February 2002 release (Build 246)
-------------------------------------------------------------
This release fixes the following bugs, in addition to those addressed in
earlier releases:

34981   TPvQuery fails on Blob columns with spaces in ColName
34996   In pseudo- or legacy-null tables, updating second of two longvarchar
          columns deletes contents of the first
35059   PvTable's "Ranges" implemented incorrectly as "Filters"


This release has the following known issues:

21192 PvQuery reads all records on "select *" before returning any (Performance)
26380 Unable to open table with high ascii characters in path
26463 AV with PvTables, Master/Detail, MultiSelect DBGrid
28531 PvTable.CachedUpdates is broken if blob columns present


Notes on November 2001 release (Build 245)
-------------------------------------------------------------
This release fixes the following bugs, in addition to those addressed in
earlier releases:

22813 PvQuery updates fail using a PvUpdateSQL
24506 Performance issue with LOCATE on a unique field already LOCATED
25548 Empty string incorrectly inserted as Null via PDAC
26345 PvCreateTable fails to create tables using ACSs
26364 Performance issue with LOCATE on a unique field already LOCATEd
26366 Locate() not working correctly when no indexes are available
27489 Incorrect handling of LStrings in PDAC
27626 Performance Issue withPvTable Master-Detail on large tables
27770 PvQuery in a DLL causes Access Violation on application exit.
27941 PvSQLSession fails to create DSN on remote server.
27989 PvTable not saving default for Timestamp field if only time specified
27992 Time values with a 00:00:00 Default value incorrectly inserted as NULL
27997 Inserted VarChar values losing trailing blanks in Default values
28001 PvTable puts ' ' in not nullable char and varchar fields; should raise exc.
28063 Note fields misbehave in Borland Memo Control via PvTable
28099 Char and VarChar values with a '' default value treated incorrectly
28100 Treatment of default values is different when using PvTable
28235 PDAC saves wrong values into Num and Dec fields if the value is too large
28349 Status 85 due to client using LFN to a file while another client has it open
28738 Error while using TPvQuery Locate() function with single quote
28746 PvTable.Locate() returns false "true" on partial non-key column
28782 PvTable.PvCreateTable() can't create empty string defaults
28908 Fractional part of TimeStamp is not being converted to millisec
28987 PvQuery exception filtering on Identity column.
29655 Wrong-sized parameter in PdacIsDatabaseSecured().
29657 TPvTable.SetIndex should do nothing if the "new" index is the same
29663 AV on exit with PvTables open in DataModule
30288 TPvQuery.SetQueryParams() ignores SQL_BINARY parameters.
30336 Binary columns (actually Char) data truncated at null byte
30483 Using pvSqlSession to get the Server name property is failing
30667 Problem creating stored procedure that have parameters
30672 High-precision decimal/BCD numbers converted incorrectly
30830 Access Violation calling stored Procedure with UBIGINT parameter
31676 Locate(), satisfied by current record, doesn't re-read the record
31982 Invalid Pointer Operation closing query in a Master Detail relationship
32130 PvQuery with parameters causes Access Violation on application exit
32271 Performance problem using filters with PvTable
32299 DRM fails to initialize m_nUpdateMode, causing design-time no-data problem
32376 PvSqlSession does not recognize OEMToANSI option in DSNs
32678 Error message "No records found" editing '12:00:00' time
32812 PvCreateTable() makes Char columns one byte too long
32897 Add OEM/ANSI Conversion for TPvTable data
32947 TPvAbsSession.IsAlias() should re-Raise exceptions
32954 Make PvTable Master-Detail use Ranges with 'Filter' performance
32989 Selecting IndexName causes filter query not to return data
33652 Disappearing list in DBLookupComboBox
33653 Locate method of PvQuery component doesn't return false
33799 PvTable's "Last" returns no data on Range of only one record
34111 After inserting a new row, cursor is not on inserted row
34467 Problem adding an image to a longvarbinary field using PDAC
34712 Problem mapping unsigned data type correctly through PDAC


PassThrough property added to PvQuery component
-----------------------------------------------
The property was added addressing 30667.  Setting this property true will force
PDAC to pass the SQL Text directly to the engine, without the pre-parsing
that is ordinarily done to bind parameters.  This is necessary when, for
instance, creating Stored Procedures with parameters.  Use the property
as follows:

procedure TForm1.Button1Click(Sender: TObject);
begin
  PvQuery1.SQL.Clear;

  PvQuery1.SQL.Add('CREATE PROCEDURE TestPr(IN :A INTEGER) AS');
  PvQuery1.SQL.Add('BEGIN');
  PvQuery1.SQL.Add('PRINT :A;');
  PvQuery1.SQL.Add('END');

  PvQuery1.PassThrough := True;
  PvQuery1.ExecSQL;
  PvQuery1.PassThrough := False;
end;

The PassThrough Property is available at Design Time in the IDE, as well.


TPvDatabase.OEMConversion Property (New)
----------------------------------------

This property indicates that the database contains characters encoded
according to the OEM (DOS) code page, and that these characters should be
converted to the ANSI (Windows) code page before use.  The database
remains in the OEM code page, but all reads and writes of character data
are translated by PDAC.

This conversion uses the mapping provided by the Windows OemToCharBuff and
CharToOemBuff functions.  It is important to note that not all characters
are round-trip convertible.  Only the characters present in both the OEM
and ANSI code pages will be preserved in an update.  As a rule of thumb,
most of the alphabetic characters are preserved, but other types of
characters, such as the box-drawing characters, may not be.  For
characters that cannot be preserved exactly, the closest look-alike
character is chosen.  For example, the box-drawing characters are replaced
by plus (+), minus (-), and pipe (|).

Currently, only characters stored in user tables are converted.  Metadata
(stored in DDF files) such as table, column, and file names are not.



Notes on 8/24/2000 release (Build 198.016)
-------------------------------------------------------------
This release fixed the following bugs, in addition to those addressed in
earlier releases:

26522  PvTable and PvQuery display Numeric(13,4) values as +.0015
26900  PvParser.VariantCompareCase() doesn't check v2 for NULL.
27056  MoveLast on Detail drops last record if it's last in file.
26948  Exception on second Locate if record is last record in DataSet
27159  Redefine type definitions common to other language interfaces.
27355  In the PvQuery components, FPrepared must be protected or
       PvwwQuery has no access
27387  PvTable.Filter/Locate fails on LString columns
25545  Activating a PvTable, sets the StoreDefs property TRUE.
27595  Legacy NULL behavior incorrect
27598  FinKey() and FindNearest() fail with segmented keys
27706  PvTable treats legacy int(1) columns as signed for
       inserts/updates

Notes on 6/16/2000 release (Build 195.015)
-------------------------------------------------------------
This release fixed the following bugs, in addition to those addressed in
earlier releases:

22835  Using PDAC with MIDAS, UBIGINTs are all returned as 0.
23220  Numeric type zero values displayed as a nine.
23264  Bfloat(8) columns in legacy tables will not store (n>-1 & n<1).
23421  Master/Detail: Detail table returns data on activation even when
       no records meet the join criteria.
23424  When used with MIDAS, PDAC returns duplicate copies of records
       in detail tables.
23822  Permit TpvTable to use server, DBNAME, and table name on open.
23839  Refresh Command Does Not Work Correctly on PvTable.
24095  Performance issue - PDAC controls calling GetPercent between moves.
24100  PvTable in Detail displays 2 records when issued Last command.
24411  PvTable.Filter property fails with AutoInc field type.
24658  Provide value in PvDatabase.Directory property.
24957  Invalid ODBC error from detail PvQuery if using SQL prepared
       statements.
25208  TPvTable gives "Stream Read Error" clearing or setting LongVarChar.
25209  TPvQuery fails to clear (or set to empty string) a LongVarChar.
26051  AV in drm.dll, caused by memcpy() of incorrect length.
26078  PvQuery's resultset ReadOnly, even with an UpdateSQL attached.
26357  Occasional AVs when PvTables are Freed without first being Closed.
26522  PvTable and PvQuery floating point precision errors in certain
       Numeric types.
26592  Btrieve error 85 on Drop table using PvQuery.

This release has the following known issues:

26522, floating point precision loss in some values of BCD columns still
affects PvTable objects in Delphi and C++ Builder version 3. This problem does
not affect later versions, nor does it affect PvQuery objects in v3. The error
affects only certiain column masks: Numeric(9,4), Numeric (11, 4), and the floating
point error is less than +/-0.0005.


Notes on 3/16/2000 FTF release (Build 175):
-------------------------------------------------------------

This Field Test File release fixed the following issues, makes numerous
performance enhancements, and provides full support for C++ Builder 5.0:

22670  LongVarChar Results Chopped to One Character in PvStoredProc
22854  GoToNearest dosn't work on segmented index
22836  TPvSqlSession throws handled "Invalid variant type conversion"
22927  PvQuery doesn't store Memo fields.
23176  Adding C++ Builder 5.0 components
23178  Adding installer cabability for C++ Builder 5.0 IDE
21061  No Transaction Rollbacks with PvSqlDatabase and PvQuery
21471  Filter not honored using GotoNearest() with PvTable.
21652  PvTable.Locate -- poor performance on unfound records
21940  'Type Mismatch in expression' error with PvTable Currency added

Notes on 2/18/2000 FTF release (Build 173):
-------------------------------------------------------------

This Field Test File release fixed the following issues and makes numerous
performance enhancements, particularly in Locate() and Master-Detail
functionality.

21194 EInvalidPtr exception on Free() in PvQuery after another except
21221 Locate() not working correctly when no indexes
21357 FindNearest() returns incorrect record on integer key.
21472 PvTable causes Access Violation in GotoCurrent();
21491 PvQuery - Invalid Field Size error for select sum() on Dec fld
21572 PvTable SetRange ignores case insensitivity
21651 Locate() should ignore Options for numeric fields
21690 Status 43 on Insert to 2nd PvTable after delete in first table.
21942 TPvQuery can't obtain updateable resultset ordered on column no
21956 TPvTable.InsertRecord() causes AV in drm.dll if table is not op
21972 Resources Not Freed With PvQuery and PvSQLDatabase
22271 PvTable.AddIndex does not add index to data file.
22279 Performance on Master-Detail PvTables not acceptable
22312 Poor performance on large tables using wwIncrementalSearch



Notes on 1/19/2000 FTF release (Build 170):
-------------------------------------------------------------

This Field Test File release fixed a number of issues and formally added the
ability to connect via the relational components to a server-located
database without a client-side DSN ("DSN-less connection").

C++ Builder 5 Support
-------------------------------------------------------------

PDAC added full support for Borland C++ Builder 5 in build 170.

To use PDAC with C++ Builder 5, you need only run the PDAC installation
program after installing C++ Builder 5.  The components will be installed
on the system and made available on the Palette of the Integrated Development
Environment.  The PDAC components must be added to the "include" and "libs"
paths of the environment (see instructions).

Note: A default installation of C++ Builder 5 has "Build with Runtime
      Packages" set on; running applications from the IDE without changing
      that setting requires that the PDAC "Redist" subdirectory for BCB5
      (...\SDK\PDAC\BCB4\Redist) be in the user's PATH environment path.
      Pervasive recommends that "Build with Runtime Packages" be left off
      during development.

DSN-less Connections
--------------------

PDAC's relational components are now able to connect from a client machine
without a DSN or Named Database to a remote server database.  The server
must have a DSN for the database.

To use the feature:

Note that a new Property -- 'AliasNameIsConnectionString' -- has been
added to the PvSQLDatabase component. If 'AliasNameIsConnectionString'
is True, then the value in 'AliasName' (or 'DatabaseName,' if 'AliasName'
is empty) is treated as a Connection String.

1.  Drop a PvSQLDatabase on a Delphi form.
2.  Supply a "made-up" DatabaseName -- it can be anything.
3.  Set the new property 'AliasNameIsConnectionString' to True.
4.  Set the 'AliasName' property (or the 'DatabaseName,' leaving
    'AliasName' blank) to the Connection String.

    The Connection String is the complete connection string for ODBC,
    including the DSN on the server and the name of the server.

    Example:

    DRIVER={Pervasive ODBC Client Interface};ServerName=DSLINUX2;ServerDSN=DEMODATA;UID=shenders;PWD=curmudgeon

    NOTE that there are no quote marks anywhere, and no line breaks. If
    your editor has wrapped the above line, make it a single line in the
    property editor.

    If a username and password are required, they may be supplied as
    part of the Connection String; if they are not in the Connection
    String, the standard database login dialog will be displayed if the
    'LoginPrompt' property is True.

5.  Set the database to "Connected" and use as usual.

All these steps may be performed at design time or through code at
runtime.


New Library Filenames
---------------------

The filenames of the libraries have been changed since the initial release
of PDAC, to avoid conflicts where multiple Borland environments or
applications are used.  A compiler code -- "D" or "B" for Delphi or C++
Builder, respectively, and a digit (3, 4, or 5) for the version -- has
been added to each library's name to maintain uniqueness.  For example,
"BtvTables.bpl" for Delphi 4 is now "BtvTablesD4.bpl"

To prevent name conflicts, all PDAC applications developed with he
original libraries should be compiled to use the new versions.  If they
are not re-compiled with the new libraries, applications using the old
libraries should be compiled without the "Build with runtime packages"
option so the libraries are compiled into the application.

NOTE: The old libraries are not removed by the installation program; they
remain on the disk for use by un-updated applications developed with them.
If they are not needed, they should be deleted.



"Redist" Subdirectory
---------------------

There is now a "redist" directory for each Borland compiler.  This
directory contains the .DPL or .BPL libraries that must be distributed
with an application compiled with "Build with runtime packages."

Note that each redist directory also includes .DCP or .BCP files that are
not redistributable except within the licensee's organization to allow
development with derived classes.  These files may not be distributed
outside the licensee's organization; only the .DPL and .BPL packages may
be distributed with applications.


Adding PDAC to C++ Builder's "Include" and "Library" paths
----------------------------------------------------------

Although the Pervasive Direct Access Component libraries are installed
into all Delphi and C++ Builder IDEs found on your system, it is necessary
to set C++ Builder's "Project Options" to reflect the INCLUDE and LIBRARY
paths for PDAC.  These can be added to the default options, so the steps
are unnecessary for every project using the Pervasive components.  To add
Pervasive Direct Access Components to the INCLUDE and LIBRARY paths in C++
Builder:

  a.  Select Project | Options, and choose the "Directories/Conditionals"
      tab.

  b.  Add "<installdir>\sdk\pdac\BCB?\include" to the Include Path,
      where <installdir> represents the directory where you installed the
      SDK (C:\PVSW is the default).  Replace the "?" with either 3 or 4,
      depending on the version of C++ Builder you are using.

  c.  Also add "<installdir>\sdk\pdac\BCB?\lib\" and
      "<installdir>\sdk\pdac\BCB?\lib\dcu" to the "Library Path",
      separated by a semicolon (;).  Replace the "?" with either 3 or 4,
      depending on the version of C++ Builder you are using.

  d.  Check the Default box (if you want these to be the defaults for all
      projects you create), then click OK to save these options.

After the Include and Library paths are set properly, use the Direct
Access components exactly the same way as the corresponding
Borland components.


Information on Additional Programs Included with PDAC
-----------------------------------------------------

PDAC2IDE.exe:

PDAC2IDE.exe, installed in the SDK\PDAC subdirectory, will configure
the Borland Delphi 3/4/5 and C++ Builder 3/4/5 Integrated Development
Environments (IDEs) for the PDAC components.  This utility is run
automatically when the SDK is installed, but can be used at a DOS command
line if new IDEs are installed or if problems occur.

When installing, there is no need to uninstall first -- any old entries
are automatically deleted prior to installation.  Note that no files are
deleted, copied, or installed; the program simply updates the IDEs for
PDAC.

The command is used as follows:

  [To install PDAC to all Borland IDEs found on a system]

    pdac2ide

    This will find all supported Borland environments and make the
    appropriate Registry entries for the components to appear on the
    Palette and be available for use.

  [To uninstall PDAC from all Borland IDEs found on a system]

    pdac2ide -u

  [To install or uninstall to/from specific IDEs]

    pdac2ide [-u] [D3] [D4] [D5] [C3] [C4] [C5]

    One or more IDEs can be listed on the command line.

  The -u parameter runs the uninstall only; if it is not given, PDAC
  will first be uninstalled, then re-installed into each listed IDE.

  PDAC2IDE also accepts a -q parameter, for "quiet" mode, that does
  not write to the console; this is useful for inclusion in batch files.


FixBPR.exe:

This is a utility to "fix" the C++ Builder .bpr (project) files.  It
replaces references to the old (original PDAC release> library names with
the correct filenames for the new libraries.  The original BPR file is
saved as <project>.bpr.old.

FixBPR is installed into the PDAC installation directory (c:\pvsw\sdk\pdac,
by default).  It can be run from a DOS or CMD box as follows:

  FixBPR <project file name>

This utility should be run against all C++ Builder projects developed
using the original release of PDAC, so they will build with the correct
libraries.  It is only useful with projects developed with the earlier
PDAC libraries; nothing is added to the BPR files if the old library names
are not found.  It is not necessary to run this utility on the
"default.bpr" files located in the compilers' "bin" directories, as
PDAC2IDE.exe performs that function during installation of PDAC.


Deploying PDAC applications
---------------------------

See the text file "pdacdepl.txt," located in the ...\SDK\PDAC
subdirectory for complete information on deploying applications developed
with the Pervasive Direct Access Components.


Open Issues
-----------

The first time a C++ Builder application is saved or compiled, the
compiler will open a dialog asking for the location of "PvTables.h".
Select the browse button, browse to the appropriate "include" subdirectory
(beneath the ...\SDK\PDAC\BCB3\, ...\SDK\PDAC\BCB4\, or
...\SDK\PDAC\BCB4\ subdirectory), and select "PvTables.hpp"; repeat
this process for any ".h" files the compiler does not locate.


Useful Links
------------

Discuss all your Pervasive development issues at
Devtalk at http://www.pervasive.com/devtalk

See some creative applications and code snippets and
share your own at Pervasive ComponentZone at
http://www.pervasive.com/componentzone

The focal website for developers is the Pervasive 
Developer Center at http://www.pervasive.com/developerzone

See the Subscription Center for access to Pervasive e-mail news at 
http://www.pervasive.com/support/subscription.asp



Disclaimer
----------

PERVASIVE SOFTWARE INC. LICENSES THE SOFTWARE AND DOCUMENTATION PRODUCT TO
YOU OR YOUR COMPANY SOLELY ON AN "AS IS" BASIS AND SOLELY IN ACCORDANCE
WITH THE TERMS AND CONDITIONS OF THE ACCOMPANYING LICENSE AGREEMENT.
PERVASIVE SOFTWARE INC. MAKES NO OTHER WARRANTIES WHATSOEVER, EITHER
EXPRESS OR IMPLIED, REGARDING THE SOFTWARE OR THE CONTENT OF THE
DOCUMENTATION; PERVASIVE SOFTWARE INC. HEREBY EXPRESSLY STATES AND YOU OR
YOUR COMPANY ACKNOWLEDGES THAT PERVASIVE SOFTWARE INC. DOES NOT MAKE ANY
WARRANTIES, INCLUDING, FOR EXAMPLE, WITH RESPECT TO MERCHANTABILITY,
TITLE, OR FITNESS FOR ANY PARTICULAR PURPOSE OR ARISING FROM COURSE OF
DEALING OR USAGE OF TRADE, AMONG OTHERS.

Copyright 1999-2002 Pervasive Software Inc. All Rights Reserved.
