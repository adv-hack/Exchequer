unit gs6_glbl;
{-----------------------------------------------------------------------------
                                 Global Values

       gs6_glbl Copyright (c) 1998 Griffin Solutions, Inc.

       Date
          4 Apr 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit handles the types and constants that are common to
       multiple units.

   Changes:
          Halcyon Version 06.90 (3 July 2001)
            -  Updated for Delphi 6 and Kylix.
            -  Corrected Memory leak in THalcyonDataset when freeing Blob/
               Memo fields.
          Halcyon Version 06.810 (2 May 01)
            -  Modified Locate and Lookup to use conditional indexes if
               the index is assigned as the active index.
            -  Added property LargeIntegerAs to THalcyonDataset to allow
               the programmer to determine how integer fields with data
               field sizes greater than 9 characters would be handled.
               If the actual integers are less than 2147483647 then they
               can be treated as ftInteger.  If greater, they must be
               ftFloat or ftLargeint.  ftLargeint is available in version
               Delphi 4 and later.  However, if working with fields as
               variants (e.g., CurValue, OldValue), ftLargeint will raise
               exceptions since it is not a standard variant type.
            -  Fixed problem closing index for table with all records
               deleted.   
            -  Corrected Sync problem where single-record tables would
               disappear from a grid when attempting to browse.
            -  Corrected RecordCount problem when ExactCount was set true
               in the HalcyonDataset and a DBGrid was in use.  When the
               method RecordCount was called, the table was not properly
               synchronized afterwards, and the initial scroll of the grid
               would start with the wrong record displayed. 
            -  Added code for Kylix compilations in Linux.  The components
               THalcyonDataset and TCreateHalcyonDataset are included
               for installation as components.
            -  Fixed gsFieldPull in gs6_dbf to allow fields with binary
               data to be loaded properly.  The prior code used a PChar
               which truncated at the first hex zero.   
            -  Removed reference to gs_eror.pas.  All errors now raise an
               exception using constants in gs6_cnst.pas.
            -  Fixed bug in gs6_indx KeyUpdate routine so TagUpdating is
               properly reset.
            -  Added capability to handle VFP datetime and currency fields.
            -  Corrected parsing precedence of AND and OR in expression to
               correctly resolve compound complex expressions.
            -  Corrected error in how ".NOT." was handled in expression parsing
               when it was immediately after an ".AND.".
            -  Fixed problem in StrTrans() function in index expressions that
               caused "loop forever".
            -  Added InList() function for DBF expressions.
            -  Set Recmodified flag so that deleted and recalled records were
               properly handled in the index routine if the deleted() function
               was used.
            -  Fixed gsCopyFile to avoid possible infinite loop if the source
               file could not be locked;

          Halcyon Version 06.737  (08 Feb 01)
            -  CopyRecordTo in HalcyonDataset will now position to the copied
               record after the copy.
            -  Added EncryptDBFFile because EncryptFile is reserved in CBuilder.
            -  Fixed Filtered to be implemented when the table is opened.
               Filtered was having to be assigned true after opening. 
            -  FindKey will now find based on the values passed, and any
               trailing field values left as null will be ignored.  This
               allows FindKey to do a partial key match.
            -  Modified Locate and Lookup to first examine the currently
               assigned index when searching for a good index for the search.
            -  Fixed error in sorting a text expression when a collation table
               is assigned.
            -  Fixed index expression handling so that field names that were
               the last part of a reserved word are handled.  For example, a
               field name of 'rue' would fail because the reserved word 'True'
               was being found (partially). 
            -  Corrected sorting routine to correctly handle MDX numeric
               indexes.
            -  Fixed problem with compound index tags in CDX files where
               one tag name removed another tag when created.  This could
               happen in the new tag name was contained at the start of an
               existing tag.  For example, adding tag 'al' would remove an
               existing tag named 'alpha'.
            -  Modified Locate and Lookup to use complex indexes such as:
                    upper(name)+str(100-age,3)
            -  Fixed problem in index expressions where .AND., .NOT., and
               .OR. are not separated by spaces from the other values.
            -  Added page balancing for NTX indexes on Index/Reindex.  Resolved
               a problem when the record count was exactly the number of keys on
               a page plus the number of pages.
            -  Added Descending index for NTX indexes.
            -  Fixed function Empty() to properly detect an empty text field.
            -  Corrected SetRange problem where a numeric range could not be
               reset or changed.
            -  The Filter function now will use an index if there is a SetRange
               applied.
            -  The File/Record locking counter is properly incremented for
               multiple locks on the same location.
            -  Corrected synchronization problem in DBFFlush in THalcyonDataset
            -  Restored memo field search to SearchDBF (was in Halcyon 5)
            -  Changed SetRange so it returns a boolean false if the current
               range is the same as the requested range.  This prevents the
               file being sent to the first record when the SetRange is called
               when a master source goes into edit mode and generates an event
               for range change in a fetail table.
            -  Fixed function Empty() to properly detect an empty date field.
            -  Fixed function Empty() to properly detect an empty memo field.

------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   Sysutils;
const

{$IFDEF HALCDEMO}
   gs6_Version         = 'Halcyon Demo Version 6.94 (14 Dec 2001)';
{$ELSE}
   gs6_Version         = 'Halcyon Version 6.94 (14 Dec 2001)';
{$ENDIF}

   Null_Record =  0;            {file not accessed yet}
   Next_Record = -1;            {Token value passed to read next record}
   Prev_Record = -2;            {Token value passed to read previous record}
   Top_Record  = -3;            {Token value passed to read first record}
   Bttm_Record = -4;            {Token value passed to read final record}
   Same_Record = -5;            {Token value passed to read record again}

   ValueHigh   =  1;            {Token value passed for key comparison high}
   ValueLow    = -1;            {Token value passed for key comparison low}
   ValueEqual  =  0;            {Token value passed for key comparison equal}
   MatchIsExact   = -1;            {Return Exact Match from Compare}
   MatchIsPartial =  0;            {Return Partial Match from Compare}
   MatchIsHigh    =  1;            {Return Partial match as high from Compare}

   MaxRecNum = $7FFFFFFF;
   MinRecNum = 0;
   IgnoreRecNum = -1;

   gsSQLTypeNA     = -1;
   gsSQLTypeVarStd = $10;
   gsSQLTypeVarDBF = gsSQLTypeVarStd + 1;
   MaxSQLSize = 32767;
   MaxSortSize = 240;

   LogicalTrue: string = 'TtYyJj';
   LogicalFalse: string = 'FfNn';
   dBaseMemoSize = 512;     {Block size of dBase memo file data}
   FoxMemoSize   = 64;      {Block size of FoxPro memo file data}
   AreaLimit     = 40;


   {               Globally used constants and types                    }

   DB3File         = $03;       {First byte of dBase III(+) file}
   DB4File         = $03;       {First byte of dBase IV file}
   FxPFile         = $03;       {First byte of FoxPro file}
   DB3WithMemo     = $83;       {First byte of dBase III(+) file with memo}
   DB4WithMemo     = $8B;       {First byte of dBase IV file with memo}
   FXPWithMemo     = $F5;       {First byte of FoxPro file with memo}
   VFP3File        = $30;       {First byte of Visual FoxPro 3.0 file}
   SpecialFile     = $04;

   GS_dBase_UnDltChr = #$20;     {Character for Undeleted Record}
   GS_dBase_DltChr   = #$2A;     {Character for Deleted Record}

   EOFMark    : char = #$1A;     {Character used for EOF in text files}

   GSchrNull = #0;

   GSMSecsInDay = 24 * 60 * 60 * 1000;
   GSTimeStampDiff = 1721425;
   dBaseJul19800101 = 2444240;
   {   Status Reporting Codes  }

   StatusStart     = -1;
   StatusStop      = 0;
   StatusIndexTo   = 1;
   StatusIndexWr   = 2;
   StatusSort      = 5;
   StatusCopy      = 6;
   StatusPack      = 11;
   StatusSearch    = 21;

   {$IFDEF WIN32}
   GSFileSep: char = '\';
   {$ENDIF}
   {$IFDEF LINUX}
   GSFileSep: char = '/';
   {$ENDIF}

type
   gsUTFString = AnsiString;
   gsUTFPChar   = PChar;
   gsUTFChar   = AnsiChar;
   FloatNum = Double;

   {$IFDEF LINUX}
      gsuint32 = Cardinal;
   {$ENDIF}

   {$IFDEF WIN32}
      {$IFDEF VER120}
      gsuint32 = Cardinal;
      {$ELSE}
      gsuint32 = longint;
      Int64 = Comp;
      Int64Rec = packed record
         Lo, Hi: Cardinal;
      end;
      {$ENDIF}
   {$ENDIF}


   GSptrByteArray = ^GSaryByteArray;
   GSaryByteArray = array[0..MaxInt-1] of byte;

   GSptrPointerArray = ^GSaryPointerArray;
   GSaryPointerArray = array[0..16379] of pointer;

   GSptrWordArray = ^GSaryWordArray;
   GSaryWordArray = array[0..32759] of word;

   GSptrLongIntArray = ^GSaryLongIntArray;
   GSaryLongIntArray = array[0..16379] of longint;

   GSptrCharArray = ^GSaryCharArray;
   GSaryCharArray = array[0..65519] of char;

   GSsetSortStatus = (Ascending, Descending, SortUp, SortDown,
                      SortDictUp, SortDictDown, NoSort,
                      AscendingGeneral, DescendingGeneral);

   GSsetLokProtocol = (Default, DB4Lock, ClipLock, FoxLock);

   GSsetIndexUnique = (Unique, Duplicates);

   CaptureStatus = Procedure(stat1,stat2,stat3 : longint);

   EHalcyonError = class(Exception);
   EHalcyonEncryption = class(Exception);


implementation


end.



