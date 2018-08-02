Unit Btrvu2;


{**************************************************************}
{                                                              }
{            ====----> Btrieve Interface Unit <----===         }
{                                                              }
{                      Created : 31/11/88                      }
{                                                              }
{                                                              }
{                                                              }
{               Copyright (C) 1988 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops    }                                     
{                                                              }
{**************************************************************}



{$R-}    {Range checking off}
{$B+}    {Boolean complete evaluation on}
{$S-}    {Stack checking on}
{$I-}    {I/O checking on}
{$F+}    {Far Model}
{$H-}    {Old string typing}

Interface

Uses GlobVar;

{ General B_Trieve Constants }


Const
  {* Running Constants *}

  Bt_ExecName =  'BTRIEVE.EXE';

  Bt_StdParam =  '/p:3584/m:48/b:1/u:4';

  // MH 20/04/07: Modified on behalf of Chris for SQL Project
  // CS 21/11/07: Modified to include Btrieve Access DLL for plugins.
  {$IFDEF EXSQL}
    {$IFDEF EXBTRVPLUGIN}
      BTDLLPath  =  'BTRVSQLDual.DLL';
    {$ELSE}
      BTDLLPath  =  'BTRVSQL.DLL';
    {$ENDIF}
  {$ELSE}
  BTDLLPath  =  'WBTRV32.DLL';
  {$ENDIF}

  BCSVer     : Byte    = 5;
  BCSType    : Char    = 'S';
  BNTCSType  : Char    = 'T';


  {* File Attributes *}

  B_Variable =  1;   {* Allow Variable Length Records *}

  B_BTrunc   =  2;   {* Truncate Trailing Blanks in Variable Records *}

  B_PreAlloc =  4;   {* Preallocate disk space to reserve contiguous area *}

  B_Compress =  8;   {* Compress Repeated Data *}

  B_KeyOnlyF =  16;  {* Key Only File *}

  B_Rerv10   =  64;  {* Reserve 10% free space on pages *}

  B_Rerv20   =  128; {* Reserve 20% free space on pages *}

  B_Rerv30   =  192; {* Reserve 30% free space on pages *}

  B_SExComp1 =  32;  {* Add to Comparison code on a filter if Upper Alt trans is to be used *}

  B_SExComp2 =  64;  {* Add to Comparison code on a filter if Match constant is another field *}

  B_SExComp3 =  128; {* Add to Comparison code on a filter if String match is not case sensitive *}



  { Commands }

  B_Open     =  0;
  B_Close    =  1;
  B_Insert   =  2;
  B_Update   =  3;
  B_UpdateEx =  40;
  B_EOF      =  9;
  B_Create   =  14;
  B_Stop     =  25;
  B_Unlock   =  27;
  B_Reset    =  28;

  B_BeginTrans= 1019;
  B_EndTrans =  20;
  B_AbortTrans= 21;
  B_GetEq    =  5;
  B_GetNext  =  6;
  B_GetNextEx=  36;
  B_GetPos    = 22;
  B_GetPrev  =  7;
  B_GetPrevEx=  37;
  B_GetGretr =  8;
  B_GetGEq   =  9;
  B_GetLess  =  10;
  B_GetLessEq=  11;
  B_GetFirst =  12;
  B_GetLast  =  13;
  B_KeyOnly  =  50;
  B_SingWLock = 100;
  B_SingNWLock= 200;
  B_StepFirst = 33;
  B_StepDirect= 24;
  B_GetDirect = 23;
  B_StepLast  = 34;
  B_StepNext  = 24;
  B_StepNextEx= 38;
  B_StepPrevEx= 39;
  B_StepPrev  = 35;
  B_MultWLock = 300;
  B_MultNWLock= 400;
  B_SingLock  = 0;    { Add to Sing Locks }
  B_MultLock  = 200;  {  "  "   "     "   to Make Equivalent MultiLocks }

{ Storage Type }
  AltColSeq  =  32;

  Descending =  64;

  ExtType    =  256;

  ManK       =  512;


{ Key Storage Types }

  BInteger   =  1;
  BString    : Byte =  0;

  BLString   : Byte =  10;

  BZString   =  11;
  BBfloat    =  09;
  BUnsigned  =  14;
  BBoolean   =  07;
  BReal      =  02;  { Equivalent to Turbo Double }
  BTime      =  04;  {     "      "    "   Word   }





  MaxFields  = 25;


  {$IFDEF CTE2_On}

    MaxFiles  =  20;

  {$ELSE}

    { HM 25/07/02: Extended for Trade Counter }
    {$IFDEF TRADE}
      { Enterprise Trade Counter Only }

      MaxFiles   = 28; //PR: 20/02/2012 changed to 26 for QtyBreaks file. ABSEXCH-9795;
                       //PR: 18/06/2012 changed to 27 for CurrencyHistory file ABSEXCH-12956
                       //PR: 18/06/2012 changed to 28 for BudgetHistory file ABSEXCH-12957
    {$ELSE}
      {$IFDEF REP_ENGINE}
        MaxFiles   = 31;  //PR: 10/02/2012 changed to 26 for QtyBreaks file. ABSEXCH-9795
                          //PR: 18/06/2012 changed to 27 for CurrencyHistory file ABSEXCH-12956
                         //PR: 18/06/2012 changed to 28 for BudgetHistory file ABSEXCH-12957
                         //PR: 03/02/2014 changed to 30 for AccountContact & AccountContactRole ABSEXCH-14974
      {$ELSE}            //PR: 14/10/2014 39 for Order Payments (OPVATPay.Dat)
        {$IFDEF SENT}
          MaxFiles   = 31; //PR: 09/12/2014 31 for Order Payments
        {$ELSE}
          { All Other Apps }
          {.$IFDEF SORTVIEW}
          {$IFDEF COMTK}
           //PR: 25/02/2010 Extended for accessing redirected files in ISLFunctions
           //File constants (30 - 36) for the extra files are in COMTK\TKSQL.Pas - these will need to be incremented if
           //new exchequer files are added which take the standard MaxFiles above 29
           MaxFiles = 36;
          {$ELSE}
          MaxFiles   = 28;//PR: 01/04/2009 Incremented for MultiBuy Discount file PR: 06/02/2012 changed to 26 for QtyBreaks file.
                          //PR: 18/06/2012 changed to 27 for CurrencyHistory file ABSEXCH-12956
                          //PR: 18/06/2012 changed to 28 for BudgetHistory file ABSEXCH-12957
        {.$ELSE}
          {$ENDIF}
  //'        MaxFiles   = 22;
          {.$ENDIF}
         {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}



  MaxNoKeys  = 24;

  DefPageSize = 1024;
  DefPageSize2= 1536;
  DefPageSize3= 2048;
  DefPageSize4= 2560;
  DefPageSize5= 3072;
  DefPageSize6= 3584;
  DefPageSize7= 4096;

  Modfy      = 2;
  Dup        = 1;

  AllowNull  = 8;

  // PKR.  20/01/2014. Added Segmented for segmented only key segments
  Segmented  = 16;

  ModSeg     = 18;
  DupSeg     = 17;

  DupMod     = 3;
  DupModSeg  = 19;


  { Constant equivalent of lowest Longint Key Value }

  FirstAddrD = -2147483647;
  FirstAddrH = $80000001;
  LastAddrD  = 2147483647;
  GetPosKey  : Integer = -99;


{ Used to Define Key, Record & Filter, Structures }

Type
  RecCPtr  =  ^Char;


  KeySpec  =  Record
     KeyPos,
     KeyLen,
     KeyFlags                :  SmallInt;
     NotUsed                 :  LongInt;
     ExtTypeVal              :  Byte;
     NullValue               :  Byte;
     Reserved                :  Array[1..4] of Char;
  end;


 FileSpec  =  Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
 end;

 FileStatSpec  =  Record
    RecLen,
    PageSize  :  SmallInt;
    NumIndex  :  Byte;
    FileVer   :  Byte;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
 end;




{ Alt Collating Sequence.. Key Sort Order

Definition...

Pos             Len                    Desc
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1               1                      Hex Value AC

2               8                      Collating Name

10              256                    256 Char ASCII Sort Sequence Order
                                       i.e. !"œ$%&'()*+,-./01234567890:;

}

 AltColtSeq  = Record
                 SigByte     :  Char;
                 Header      :  array[1..8] of Char;
                 AltColtChars:  array[0..255] of Char;
               end;



 FullFileKeySpec  =  record
   FS                      :  FileStatSpec;
   Ks                      :  array[1..MaxNoKeys] of KeySpec;
   AltColt                 :  AltColtSeq;
 end;





  FileVar  =  array[1..128] of char;
  TCurrKeyPath = Array[1..MaxFiles] of Byte;

  {$IFDEF EXSQL}
  TCurrKeyAry  = Array[0..4000] of TCurrKeyPath;
  {$ELSE}
  TCurrKeyAry  = Array[0..100] of TCurrKeyPath;
  {$ENDIF}



{ ================== Filter Std Structures ================= }

FilterRepeatType  =  Record

  FieldType       :    Byte;               {* Type of Field to Compare *}
  FieldLen        :    SmallInt;           {* Length of Comparison Field *}
  FieldOffSet     :    SmallInt;           {* Compare field offset within record 0 relative *}
  CompareCode     :    Byte;               {* Compare type ie. 1=,2>=,3<=,4<>... *}
  LogicExpres     :    Byte;               {* Logic if more that 1 comparison, 1 And, 2 Or, 0 = End *}
end;


ExtendRepeatType =  Record

  NumRecords      :    SmallInt;             {* Number of passed records to return in one go (1) *}
  NumFields       :    SmallInt;             {* Number of fields withi that record to return (1) for whole record *}
  FieldLen        :    SmallInt;             {* Length of returned field (LEngth of entire rec *}
  FieldOffSet     :    SmallInt;             {* Pos of field within record to be returned (0) *}
end;

ExtendGetDescType =  Record

  DescLen         :    SmallInt;             {* Length of Filter Record *}
  ExtConst        :    Array[1..2] of Char;{* Extended op Id "EG" *}
  RejectCount     :    Word;             {* No. of rejects allowed before aborting *}
  NumTerms        :    SmallInt;             {* No. of compares *}
end;

ResultRecType     =  Record

  NumRec          :    SmallInt;             {* No. of records returned. *}
  RecordLen       :    SmallInt;             {* Length of Record returned *}
  RecPos          :    LongInt;              {* File Address of Record    *}
  ExtendRec       :    Array[1..4000] of Char; {* largest assumed record *}

end;

ClientIdType      =  Record
                       Reserved  :  Array[1..12] of Byte;
                       AppId     :  Array[1..2] of Char;
                       TaskId    :  SmallInt;
                     end;


FileNameArrayType = array[1..MaxFiles] of String[255];
FPosBlkType       = array[1..MaxFiles] of FileVar;

var
  FileNames  :   ^FileNameArrayType;
  {TotFiles   :   Integer;}       { MH 09/12/96: Removed as also in GlobVar.Pas }
  TotFields  :   Integer;
  FileSpecOfs:   array[1..MaxFiles] of RecCPtr;
  FileSpecLen:   array[1..MaxFiles] of Integer;

  F          :   FPosBlkType;

  Fn         :   Integer;

  CurrKeyPath:   ^TCurrKeyPath;
  CurrKeyAry :   ^TCurrKeyAry;


  CurIndKey  :   Array[1..MaxFiles] of String[255];
  FileRecLen :   Array[1..MaxFiles] of Integer;
  NoRecInKey :   Array[1..MaxNoKeys] of LongInt;
  RecPtr     :   Array[1..MaxFiles] of RecCPtr;
  VariFile   :   Array[1..MaxFiles] of Boolean;
  UpperAlt   :   AltColtSeq;

  Checked4SA :   Byte;

  BTForceLocalEngine,
  BTForceCSEngine,
  Chk4BCS    :   Boolean;
  OwnerName  :   ^Str10;




function BtrvInit (Var InitializationString): Integer;

function BtrvStop: Integer;


Function StatusOK  :  Boolean;

{ =========== Create a New File ============= }

{ Usage : Int:=Make_File(F[Fn],FileNames[Fn],CustFileRec,Sizeof(CustFileRec)); }


Function  Make_FileCId(Var FileB    :  FileVar;
                           FileName :  Str255;
                       Var FileDef;
                           BufferLen:  Integer;
                           ClientId :  Pointer) : Integer;

Function  Make_File(Var FileB    :  FileVar;
                        FileName :  Str255;
                    Var FileDef;
                        BufferLen:  Integer) : Integer;

{ ========= Proc to assign an owner name ========= }

Procedure AssignBOwner(Const SetOn  :  Str10);



{ ========= Set/Clear Owner ======== }

Function CtrlBOwnerNameCId(Var  FileB    :  FileVar;
                                ClearO   :  Boolean;
                                Mode     :  Integer;
                                ClientId :  Pointer)  :  Integer;

Function CtrlBOwnerName(Var  FileB    :  FileVar;
                             ClearO   :  Boolean;
                             Mode     :  Integer)  :  Integer;


{ =========== Open a File ============= }

{ Usage : Int:=Open_File(F[Fn],FileNames[Fn],Mode[-3..0]); }



Function Open_FileCId(Var  FileB    :  FileVar;
                           FileName :  Str255;
                           Mode     :  Integer;
                           ClientId :  Pointer)  :  Integer;

Function Open_File(Var  FileB    :  FileVar;
                        FileName :  Str255;
                        Mode     :  Integer)  :  Integer;


{ =========== Close a File ============= }

{ Usage : Int:=Open_File(F[Fn]); }


Function  Close_FileCId(Var  FileB    :  FileVar;
                             ClientId :  Pointer) : Integer;

Function  Close_File(Var  FileB  :  FileVar) : Integer;





{ =========== Insert a Record ============= }

{ Usage : Int:=Add_rec(F[Fn],Fn,RecPtr[Fn]^,Indxno[0..]); }


Function Add_RecCId(Var  FileB    :  FileVar;
                         FileNum  :  Integer;
                    Var  DataRec;
                         CurKeyNum:  Integer;
                         ClientId :  Pointer)  :  Integer;

Function Add_Rec(Var  FileB    :  FileVar;
                      FileNum  :  Integer;
                 Var  DataRec;
                      CurKeyNum:  Integer)  :  Integer;




{ =========== Find a Record via Various Search Methods =============

B_GetEq,
B_GetNext,
B_GetPrev,
B_GetGretr,
B_GetGEq,
B_GetLess,
B_GetLessEq,
B_GetFirst,
B_GetLast.

 Usage : Int:=Find_Rec(Search Req,F[Fn],Fn,RecPtr[Fn]^,Indxno[0..],KeyToSearch); }

{ ====================== Function to Find a Record via the Key ================ }


Function Find_VarRec(     SearchType : Integer;
                     Var  FileB      : FileVar;
                          FileNum,
                          C          : Integer;
                     Var  DataRec;
                          CurKeyNum  : Integer;
                     Var  Key        : Str255;
                          ClientId   : Pointer): Integer;


{ ====================== Function to Find a Record via the Key Record Length assumed ================ }

Function Find_RecCId(     SearchType : Integer;
                     Var  FileB      : FileVar;
                          FileNum    : Integer;
                     Var  DataRec;
                          CurKeyNum  : Integer;
                     Var  Key        : Str255;
                          ClientId   : Pointer): Integer;

Function Find_Rec(     SearchType : Integer;
                     Var  FileB      : FileVar;
                          FileNum    : Integer;
                     Var  DataRec;
                          CurKeyNum  : Integer;
                     Var  Key        : Str255): Integer;


Function GetThreadKeypath(Fnum       :  SmallInt;
                          ClientId   :  Pointer)  :  SmallInt;

Procedure Prime_TailFilter(Var  ExtendTail  :  ExtendRepeatType;
                                FileNum     :  Integer);


Procedure Prime_Filter(Var  ExtendHead  :  ExtendGetDescType;
                       Var  ExtendTail  :  ExtendRepeatType;
                            FileNum     :  Integer;
                            FiltSize    :  Integer);


{ ========== Prime ClientId Record ======== }

Procedure Prime_ClientIdRec(Var  CIdRec  :  ClientIdType;
                                 AId     :  Str5;
                                 TId     :  SmallInt);

{ =========== Delete a Record ============= }

{ Usage : Int:=Delete_rec(F[Fn],Fn,Indxno[0..]); }


Function Delete_RecCId(Var  FileB     :  FileVar;
                            FileNum   :  Integer;
                            CurrKeyNum:  Integer;
                            ClientId  :  Pointer) : Integer;

Function Delete_Rec(Var  FileB  :  FileVar;
                         FileNum:  Integer;
                      CurrKeyNum:  Integer) : Integer;





{ =========== Change a Record ============= }

{ Usage : Int:=Put_rec(F[Fn],Fn,RecPtr[Fn]^,Indxno[0..]); }

Function Put_RecCId(Var  FileB  :  FileVar;
                         FileNum:  Integer;
                    Var  DataRec;
                         CurrKeyNum:  Integer;
                         ClientId  :  Pointer) : Integer;

Function Put_Rec(Var  FileB  :  FileVar;
                      FileNum:  Integer;
                 Var  DataRec;
                   CurrKeyNum:  Integer) : Integer;




{ =========== Get No of Records ============= }

{ Usage : LongInt:=Used_Recs(F[Fn],Fn); }

Function Used_RecsCId(Var  FileB    :  FileVar;
                           FileNum  :  Integer;
                           ClientId :  Pointer) : LongInt;

Function Used_Recs(Var  FileB  :  FileVar;
                        FileNum:  Integer) : LongInt;

Function File_VerCId(Var  FileB    :  FileVar;
                          FileNum  :  Integer;
                          ClientId :  Pointer) : Byte;

{ =============== ****** Decode Btrv Error ****** =========== }

Function Set_StatMes(StatNo  :  Integer) : AnsiString;

Procedure Status_Means(StatNo  :  Integer);

{ ======== Function To Check for Btrieve Presence by Requesting Version No. ======= }

Function Check4BtrvOk  :  Boolean;

Function GetBtrvStat(var FileB      :  FileVar;
                    Var BVer,BRev  :  Integer;
                    Var BTyp       :  Char;
                        Mode       :  Byte)  :  Integer;

Function GetBtrvVer(var FileB      :  FileVar;
                    Var BVer,BRev  :  Integer;
                    Var BTyp       :  Char;
                        Mode       :  Byte)  :  Boolean;

Function Check4SABtrv(FileB  :  FileVar)  :  Boolean;


{ =========================== Return Position of Current DataRec ================== }

Function GetPosCId(Var  FileB    :  FileVar;
                        FileNum  :  Integer;
                   Var  Posn     :  LongInt;
                        ClientId :  Pointer) : Integer;

Function GetPos(Var  FileB  :  FileVar;
                     FileNum:  Integer;
                Var  Posn   :  LongInt) : Integer;



{ ======================== Return Record by Position Offset ================ }

Function  GetDirectCId(Var  FileB  :  FileVar;
                            FileNum:  Integer;
                       Var  DataRec;
                            CurrKeyNum,
                            LockCode :  Integer;
                            ClientId :  Pointer) : Integer;

Function  GetDirect(Var  FileB  :  FileVar;
                         FileNum:  Integer;
                    Var  DataRec;
                         CurrKeyNum,LockCode
                                :  Integer) : Integer;

{$IF Defined(COMTK) Or Defined(BUREAUDLL)}
  // HM 29/01/01: Added for COM Toolkit
  Function  CTK_GetDirectCId(Var  FileB    :  FileVar;
                                  FileNum  :  Integer;
                             Var  DataRec;
                                  CurrKeyNum,
                                  LockCode :  Integer;
                             Var  Key      : Str255;
                                  ClientId :  Pointer) : Integer;
{$IfEnd}

{ ==== Get FileSpec of open file ==== }

Function GetFileSpecCId(Var  FileB   : FileVar;
                             FileNum : Integer;
                        Var  FSpec   : FileSpec;
                             ClientId: Pointer) : LongInt;

Function GetFileSpec(Var  FileB   : FileVar;
                          FileNum : Integer;
                     Var  FSpec   : FileSpec) : LongInt;

Function GetFullFile_StatCId(Var  FileB    :  FileVar;
                                  FileNum  :  Integer;
                                  ClientId :  Pointer)  :  FullFileKeySpec;


{ =========== Stop Btrieve ============= }

{ Remove Btrive From Memory }

{ Usage : Int:=B_Stop; }

Function  Stop_B  :  Integer;

Function  Reset_BCId(ClientId  :  Pointer)  :  Integer;

Function  Reset_B  :  Integer;

Function  Ctrl_BTrans(SearchMode  :  Integer) : Integer;
Function  Ctrl_BTransCId(SearchMode  :  Integer;
                         ClientId    :  Pointer) : Integer;


Function UnLockMulTiSingCId(var FileB   :  FileVar;
                            FileNum :  Integer;
                            RecAddr :  LongInt;
                            ClientId:  Pointer)  :  Integer;

Function UnLockMulTiSing(var FileB   :  FileVar;
                         FileNum :  Integer;
                         RecAddr :  LongInt)  :  Integer;

Function Presrv_BTPosCId(Fnum     :  Integer;
                    Var Keypath   :  Integer;
                    Var LFV       :  FileVar;
                    Var RecAddr   :  LongInt;
                        UsePos,
                        RetRec    :  Boolean;
                        ClientId  :  Pointer)  :  Integer;


Function Presrv_BTPos(Fnum      :  Integer;
                  Var Keypath   :  Integer;
                  Var LFV       :  FileVar;
                  Var RecAddr   :  LongInt;
                      UsePos,
                      RetRec    :  Boolean)  :  Integer;


Function BtKeyPos (Const OfsField, OfsRec : Pointer) : Word;

{$IFDEF GUP}
  // MH 16/02/2010: Added for GEUpgrde.Dll to create supplimental indexes for v6.2
  Function Btrv (   Operation   : Word ;
                var PositionBlock,
                    DataBuffer;
                var DataLen     : Integer;
                var KeyBuffer;
                    KeyNumber   : Integer;
                    ClientId    : Pointer): Integer;
{$ENDIF}

//PR: 28/11/2017 ABSEXCH-19503  Function to check encryption status of file
function IsFileEncrypted(var FileB   :  FileVar;
                             ClientId :  Pointer) : Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses Dialogs,

     {$IF Not Defined(BTRVSQL_DLL) Or Not Defined(NOBTRegChk)}
       Windows,
     {$IFEND}

     {$IFNDEF NOBTRegChk}
       Registry,
     {$ENDIF}

     {$IFDEF BTRVSQL_DLL}
       BTRVSQLU,
     {$ENDIF}

     StrUtils,
     SQLUtils,

     SysUtils;

{$IFDEF WIN32}
  // HM 26/09/01: Added local defs to suppress hints and warnings from this module
  {$WARNINGS OFF}
  {$HINTS OFF}
{$ENDIF}


Const
  TryMax  =  1000;


{$IFNDEF BTRVSQL_DLL}
  FUNCTION BTRCALL(
                   operation : WORD;
               VAR posblk;
               VAR databuf;
               VAR datalen   : WORD;
               VAR keybuf;
                   keylen    : BYTE;
                   keynum    : Integer
                   ) : SmallInt; FAR; StdCall;
                   external  BTDLLPath name 'BTRCALL';

  FUNCTION BTRCALLID(
                   operation : WORD;
               VAR posblk;
               VAR databuf;
               VAR datalen   : WORD;
               VAR keybuf;
                   keylen    : BYTE;
                   keynum    : Integer;
               Var clientid     ) : SmallInt; FAR; StdCall;
                   external  BTDLLPath name 'BTRCALLID';


   FUNCTION WBTRVINIT(
               VAR intializationString): Integer; FAR; stdcall;
                   external BTDLLPath  name 'WBTRVINIT';

   FUNCTION WBTRVSTOP: Integer; FAR; stdcall;
               external BTDLLPath name 'WBTRVSTOP';

   // CJS 15/03/2011 - applied EXSQL directive so that these calls are only
   //                  compiled if BtrvSQL is being used.
   {$IFDEF EXSQL}
   procedure EnteringModule(ModuleName: PChar); FAR; stdcall;
             external BTDLLPath name 'EnteringModule';
   procedure LeavingModule(ModuleName: PChar); FAR; stdcall;
             external BTDLLPath name 'LeavingModule';
   {$ENDIF}
{$ENDIF}

  {This function is currently not supported. You initialize brequest.exe
   when you load it before loading windows. Therefore, there is no need
   to initialize the WBTRCALL.DLL requestor from your Windows application}
  Function WBRqShellInit(Var InitializationString): Integer; far;
                       external BTDLLPath  index 5;



  {**********************************************************}
  {Now define the functions which call the DLL               }
  {**********************************************************}

  {Standard Btrieve Operation Call}


  Function Btrv (   Operation   : Word ;
                var PositionBlock,
                    DataBuffer;
                var DataLen     : Integer;
                var KeyBuffer;
                    KeyNumber   : Integer;
                    ClientId    : Pointer): Integer;
  Var
    KeyLen :  Byte;
    mbret,
    DataL  :  Word;


    {InitStr:  Array[0..254] of Char;}

  Begin
{$IFDEF GLCCDEBUG}
  CheckMemCallback ('Starting Btrv - OpCode=' + IntToStr(Operation) + ', ClientId=' + IfThen(ClientId=NIL, 'NIL',IntToStr(DWORD(ClientId))));
{$ENDIF}

    FillChar(Result,0,Sizeof(Result));

    KeyLen:= 255;                       {maximum key length}
    DataL:=DataLen;

    {Move(Keybuffer,InitStr,KeyLen);}

    {mbRet:=MessageDlg('Filename '+InitStr,mtInformation,[mbOk],0);}


    If (Clientid=nil) then
      Btrv := BtrCall(Operation,  PositionBlock,DataBuffer,
                      DataL,    KeyBuffer,      KeyLen,
                      KeyNumber)
    else
      Btrv:=BtrCallId(Operation,  PositionBlock,DataBuffer,
                      DataL,    KeyBuffer,      KeyLen,
                      KeyNumber,
                      ClientId^);

    DataLen:=DataL;

{$IFDEF GLCCDEBUG}
  CheckMemCallback ('Finishing Btrv - OpCode=' + IntToStr(Operation) + ', ClientId=' + IfThen(ClientId=NIL, 'NIL',IntToStr(DWORD(ClientId))));
{$ENDIF}
  End; {Btrv}


  {Initializes the local DLL}
  Function BtrvInit (Var InitializationString): Integer;
  Begin
    FillChar(Result,0,Sizeof(Result));

    BtrvInit := WBtrvInit (InitializationString);
  End; {End BtrvInit}


  {Stops this instance of Btrieve}
  Function BtrvStop: Integer;
  Begin
    FillChar(Result,0,Sizeof(Result));

    BtrvStop:= WBtrvStop;
  End; {End BtrvStop}


  {Initializes the requestor DLL}
  Function BRqShellInit(Var InitializationString): Integer;
  Begin
    FillChar(Result,0,Sizeof(Result));

    BRqShellInit:= WBRqShellInit(InitializationString);
  End; {End BRqShellInit}




{ =============== Simple Check on Status Flg =================== }

Function StatusOK  :  Boolean;

Begin
  StatusOK:=(Status=0);
end;


{ =============== ****** Decode Btrv Error ****** =========== }

Function Set_StatMes(StatNo  :  Integer) : AnsiString;
const
  CRLF = #13#10;

Var
  Mess  :  AnsiString;

Begin

  Mess:='';

  Case StatNo of
    0  :  Mess:='';
    1  :  Mess:='Invalid Operation No >=0<=32 +Lock...';
    2  :  Begin
            Mess:='I/O Error Could be Corrupted File ..'+CRLF+
                'The system has detected a serious error in the above file.'+CRLF+
                'This may be a temporary problem due to a current network fault.'+CRLF+
                'Try closing the system down, rebooting your machine and running'+CRLF;
            Mess:=Mess+'the system again.  If the error persists, contact your supplier'+CRLF+
                'for instructions on data recovery, or ultimately the restoration of'+CRLF+
                'the most recent backup.';
          end;
    3  :  Begin
            Mess:='File Not Open.'+CRLF+
                'The above file is no longer open.  This problem may well have'+CRLF+
                'been caused by a system or network crash. Acknowledge this message'+CRLF+
                'and check the results of whatever process the system was completing.'+CRLF;
            Mess:=Mess+'It may be possible by repeating the process to correct the problem, or'+CRLF+
                'you may have to revert to a backup.';
          end;
    4  :  Mess:='Key Not Found';
    5  :  Mess:='Duplicate Error.'+CRLF+
                'A duplicate key is being added to a record which does not'+CRLF+
                'allow duplicates.  This is normally caused by a network fault.';
    6  :  Mess:='Invalid Key No.';
    7  :  Mess:='Different Key No. to Previous Operation';
    8  :  Mess:='Invalid Positioning... Update/Delete called before position has been established.';
    9  :  Mess:='End of File Reached';
    10 :  Mess:='Modify Error... Modify to Non Modify Key';
    11 :  Begin
            Mess:='Invalid File Name.'+CRLF+
                'The path of the file being opened is not recognised as being valid.'+CRLF+
                'Check your network connection is still working, and check using Explorer'+CRLF+
                'that the file being opened can be found in the directory named above.'+CRLF;
            Mess:=Mess+'If Explorer cannot see them, then the directory or your network connection'+CRLF+
                'needs correcting.';
          end;
    12 :  Begin
            Mess:='File Not Found'+CRLF+
                'The file being opened could not be found in the directory specified,'+CRLF+
                'although the directory itself is valid.'+CRLF+
                'Check your network connection is still working, and check using Explorer'+CRLF;
            Mess:=Mess+'that the file being opened can be found in the directory named above.'+CRLF+
                'If Explorer cannot see them, then the directory or your network connection'+CRLF+
                'needs correcting.';
          end;
    13 :  Mess:='Extension Error';
    14 :  Begin
            Mess:='Pre-Image File Open Error.'+CRLF+
                'The pre-image file (ending in extension .PRE) is damaged.'+CRLF+
                'This error normally occurs after a system or network crash on v5.X'+CRLF+
                'format files.'+CRLF+
                'This may be a temporary problem due to a current network fault.'+CRLF;
            Mess:=Mess+'Try closing the system down, rebooting your machine and running'+CRLF+
                'the system again.  If the error persists, contact your supplier'+CRLF+
                'for instructions on data recovery, or ultimately the restoration of'+CRLF+
                'the most recent backup.'+CRLF+CRLF+
                'It is also advisable to convert the data files to a v6.X format, to'+CRLF+
                'avoid this problem in the future.';
          end;
    15 :  Begin
            Mess:='Pre-Image File Write Error.'+CRLF+
                'It was not possible to update the above pre-image file.'+CRLF+
                'This error normally occurs after a system or network crash on v5.X'+CRLF+
                'format files.'+CRLF+
                'This may be a temporary problem due to a current network fault.'+CRLF;
            Mess:=Mess+'Try closing the system down, rebooting your machine and running'+CRLF+
                'the system again.  If the error persists, contact your supplier'+CRLF+
                'for instructions on data recovery, or ultimately the restoration of'+CRLF+
                'the most recent backup.'+CRLF+CRLF+
                'It is also advisable to convert the data files to a v6.X format, to'+CRLF+
                'avoid this problem in the future.';
          end;
    16 :  Mess:='Expansion Error';
    17 :  Mess:='Close Error ... ';
    18 :  Begin
            Mess:='Disk Full!!'+CRLF+
                'The hard disk you are writing to is full, or there is a network fault'+CRLF+
                'preventing the system from writing any more information.'+CRLF+CRLF+
                'This may be a temporary problem due to a current network fault.'+CRLF;
            Mess:=Mess+'Try closing the system down, rebooting your machine and running'+CRLF+
                'the system again.  If the error persists, use Explorer to detect'+CRLF+
                'the amount of free disk space on your server and free up more space'+CRLF+
                'if necessary.';
          end;
    19 :  Mess:='Unrecoverable Error';
    20 :  Mess:='Database Engine not Active.'+CRLF+
                'It was not possible to connect to the Database Engine.'+CRLF+
                'Try re-applying the workstation setup for this machine.'+CRLF+
                'If the problem persists, contact your supplier.';

    21 :  Mess:='Key Buffer Error';
    22 :  begin
            Mess:='Record Buffer.. Length Mismatch.'+CRLF+
                  'The record being read or written to the above file is the wrong size.'+CRLF+
                  'This problem is normally caused by a mismatch between your data and the version'+CRLF;
            Mess:=Mess+'of Exchequer being used on it. Likely causes are the non or incomplete'+CRLF+
                  'application of a previous conversion.  Contact your supplier for guidance.';
          end;  

    23 :  Mess:='Position Block';
    24 :  Mess:='Page Size Multiple Error';
    25 :  Mess:='Create IO Error.'+CRLF+
                'The system was unable to create a new data file.  Make sure you have'+CRLF+
                'sufficient access rights to create files in the above directory.';
    26 :  Mess:='No of Keys Exceeds Page Size';
    27 :  Mess:='Key Position Error';
    28 :  Mess:='Record Length';
    29 :  Mess:='Key Length Error';
    30 :  Begin
            Mess:='Not a valid Database File!'+CRLF+
                'The system does not recognise this file as being of the correct format.'+CRLF+
                'This may be a temporary problem due to a current network fault.'+CRLF+
                'Try closing the system down, rebooting your machine and running'+CRLF;
            Mess:=Mess+'the system again.  If the error persists, contact your supplier'+CRLF+
                'for instructions on data recovery, or ultimately the restoration of'+CRLF+
                'the most recent backup.';
          end;
    31 :  Mess:='Extend already implemented';
    32 :  Mess:='Extend IO Error';
    34 :  Mess:='Extend File Name not valid';
    35 :  Mess:='Invalid Path';
    36 :  Mess:='Transaction not possible as an insufficient number of Transactions has been set.'+CRLF+
                'Protected mode posting is not possible as the Database Engine has been set up'+CRLF+
                'with too few transactions.  Adjust the Transaction setting in the engine setup.';
    37 :  Mess:='A Begin Tran was called before a previous Tran had finished';
    38 :  Mess:='Transaction Control File Error';
    39 :  Mess:='End/Abort Transaction called before Begin';
    40 :  Mess:='Transaction Max Files';
    41 :  Mess:='Transaction Operation';
    42 :  Mess:='Incomplete Accelerated Access';
    43 :  Mess:='Invalid Data record Address';
    44 :  Mess:='Null Key Path..';
    45 :  Mess:='Inconsistent Key Flag settings';
    46 :  Begin
            Mess:='Access to File Denied.'+CRLF+
                'This can often be caused by a database engine configuration mismatch.'+CRLF+
                'Check all workstations are accessing the system in the same mode.'+CRLF+
                'Either all local, or all C/S.  Make sure you have sufficient access rights.';
            Mess:=Mess+CRLF+CRLF+'If your data files have been copied from a CD-ROM, check the files'+CRLF+
                'are set to read/write access as CD-ROM files are normally read only!';
          end;
    47 :  Mess:='Maximum No. of Open Files.'+CRLF+
                'The maximum number of files required needs to be increased within the Database'+CRLF+
                'Engine setup. Check EntRead for the standard settings.';
    48 :  Mess:='Invalid Alt Col Seq';
    49 :  Mess:='Key Type Error';
    50 :  Mess:='Owner Already Set';
    51 :  Mess:='Invalid Owner';
    52 :  Mess:='Error writing cache';
    53 :  Mess:='Invalid I/F';
    54 :  Mess:='Variable Page Error';
    55 :  Mess:='Autoincrement Error';
    56 :  Mess:='Incomplete Index';
    57 :  Mess:='Expand Memory Error';
    58 :  Mess:='Compression Buffer too Short.'+CRLF+
                'The minimum compressed record size needs to be increased within the Database'+CRLF+
                'Engine setup. Check EntRead for the standard settings.';
    59 :  Mess:='File Already Exists';
    80 :  Mess:='Conflict.. Record Changed By Other Station since Read';
    81 :  Mess:='Lock Error';
    82 :  Mess:='Lost Position';
    83 :  Mess:='Read Outside Transaction';
    84 :  Mess:='Record in Use';
    85 :  Begin
            Mess:='File locked by another Workstation'+CRLF+
                'This can often be caused by a Database Engine configuration mismatch.'+CRLF+
                'Check all workstations are accessing the system in the same mode.'+CRLF+
                'Either all local, or all C/S.';
          end;
    86 :  Mess:='File Full!!';
    87 :  Mess:='Handle Full'+CRLF+
                'The maximum number of handles required needs to be increased within the Database'+CRLF+
                'Engine setup. Check EntRead for the standard settings.';
    88 :  Begin
            Mess:='Incompatible Mode'+CRLF+
                'This can often be caused by a Database Engine configuration mismatch.'+CRLF+
                'Check all workstations are accessing the system in the same mode.'+CRLF+
                'Either all local, or all C/S.';
          end;

    89 :  Mess:='Name Error';
    90 :  Mess:='Device Full';
    91 :  Mess:='Server Error';
    92 :  Mess:='Trans Full';
    93 :  Mess:='Incompatible Lock Type';
    94 :  Begin
            Mess:='Permission Error.'+CRLF+
                'Your server is refusing to grant you read/write access to the system.'+CRLF+
                'Check that your access rights are correct.  If the problem persists you may need'+CRLF;
            Mess:=Mess+'to update your database engine or network client.  Contact your supplier for further'+CRLF+
                'guidance.';
          end;
    95 :  Begin
            Mess:='Connection to server lost.'+CRLF+
                'The network session to your server has been lost. This may be a temporary problem due'+CRLF+
                'to a current network fault.'+CRLF+
                'Try closing the system down, rebooting your machine and running'+CRLF;

            Mess:=Mess+'the system again.  If the error persists, contact your supplier'+CRLF+
                'for instructions on data recovery, or ultimately the restoration of'+CRLF+
                'the most recent backup.';
          end;
    97 :  Mess:='Data Message too Small';
    99 :  Mess:='Demo Error';
    else  Mess:='?! Unknown Error.'+CRLF+
                'The error returned by the Database Engine is not recognised.  Consult your supplier.';
  end;
  Set_StatMes:=Mess;
end;



{ =============== ****** Return Std Debug Message =========== }
Procedure Status_Means(StatNo  :  Integer);

Var
  Mess     :   AnsiString;
  MbRet    :   Word;

Begin
  If (StatNo<>0) then
  Begin
    mbRet:=MessageDlg('Status '+InttoStr(StatNo)+','+Set_StatMes(StatNo),mtInformation,[mbOk],0);

  end;
end;

{ == Function to check if we can see a server engine, if not ignore open modes == }

Function UseLocalOverride  :  Boolean;

Var
  Ver        :  Integer;
  Rev        :  Integer;
  Typ        :  Char;
  TmpBo      :  Boolean;
  DumBlock   :  FileVar;

Begin

  FillChar(DumBlock,Sizeof(DumBlock),0);

  If (Checked4SA=0) then
  Begin
    TmpBo:=GetBtrvVer(DumBlock,Ver,Rev,Typ,1);

    If (TmpBo) then
    Begin
      {Check for forced modes if there is a v7 or greater requestor installed, }
      Checked4SA:=1+Ord((Ver>6));

    end;

  end;

  Result:=(Checked4SA=2);

end;

{ =========== Create a New File ============= }

{ Usage : Int:=Make_File(F[Fn],FileNames[Fn],CustFileRec,Sizeof(CustFileRec)); }


Function  Make_FileCId(Var FileB    :  FileVar;
                           FileName :  Str255;
                       Var FileDef;
                           BufferLen:  Integer;
                           ClientId :  Pointer) : Integer;

Var
  Mode  :  Integer;

Begin
  Mode:=0;

  If (UseLocalOverride) then
  Begin
    If (BTForceCSEngine) then
      Mode:=99
    else
      If (BTForceLocalEngine) then
        Mode:=6;
  end;

  FillChar(FileName[Length(FileName)+1],255-Length(FileName),0);

  Make_FileCId:=Btrv(B_Create,FileB,FileDef,BufferLen,FileName[1],Mode,ClientId);
end;



Function  Make_File(Var FileB    :  FileVar;
                        FileName :  Str255;
                    Var FileDef;
                        BufferLen:  Integer) : Integer;


Begin
  Make_File:=Make_FileCId(FileB,FileName,FileDef,BufferLen,nil);
end;


{ ========= Proc to assign an owner name ========= }

Procedure AssignBOwner(Const SetON  :  Str10);

Begin
  If (Assigned(OwnerName)) and (SetON<>OwnerName^) then
    OwnerName^:=SetON;

end;

{ =========== Open a File ============= }

{ Usage : Int:=Open_File(F[Fn],FileNames[Fn],Mode[-3..0]); }


Function Open_FileCId(Var  FileB    :  FileVar;
                           FileName :  Str255;
                           Mode     :  Integer;
                           ClientId :  Pointer)  :  Integer;

Var
  OwnerLen  :  Integer;
  OwnerNam  :  String[128];
  mbret     :  word;
  OpenMode  :  Integer;
  InitStr   :  Array[0..254] of Char;

Begin
  FillChar(OwnerNam,Sizeof(OwnerNam),0);

  If (Assigned(OWnerName)) then {*Ex431}
  Begin
    If (OwnerName^<>'') then
      OwnerNam:=OwnerName^;

  end;

  OwnerLen:=Length(OwnerNam)+1;

  FillChar(FileName[Length(FileName)+1],255-Length(FileName),0);

  FillChar(OwnerNam[Length(OwnerNam)+1],128-Length(OwnerNam),0);

  OpenMode:=Mode;

  If (UseLocalOverride) then
  Begin
    If (BTForceCSEngine) then
      OpenMode:=99+ABS(Mode)
    else
      If (BTForceLocalEngine) then
        OpenMode:=6+ABS(Mode);
  end;

  Open_FileCId:=Btrv(B_Open,FileB,OwnerNam[1],OwnerLen,FileName[1],OpenMode,ClientID);
end;


Function Open_File(Var  FileB    :  FileVar;
                        FileName :  Str255;
                        Mode     :  Integer)  :  Integer;

Begin
  Open_File:=Open_FileCId(FileB,FileName,Mode,nil);
end;


{ ========= Set/Clear Owner ======== }

Function CtrlBOwnerNameCId(Var  FileB    :  FileVar;
                                ClearO   :  Boolean;
                                Mode     :  Integer;
                                ClientId :  Pointer)  :  Integer;

Var
  B_Func,
  OwnerLen  :  Integer;
  OwnerNam  :  String[128];


Begin

  FillChar(OwnerNam,Sizeof(OwnerNam),0);

  If (Assigned(OWnerName)) then
  Begin
    If (OwnerName^<>'') then
      OwnerNam:=OwnerName^;

  end;

  B_Func:=29+Ord(ClearO);

  OwnerLen:=Length(OwnerNam);

  CtrlBOwnerNameCId:=Btrv(B_Func,FileB,OwnerNam[1],OwnerLen,OwnerNam[1],Mode,ClientId);
end;



{ ========= Set/Clear Owner ======== }

Function CtrlBOwnerName(Var  FileB    :  FileVar;
                             ClearO   :  Boolean;
                             Mode     :  Integer)  :  Integer;


Begin

  CtrlBOwnerName:=CtrlBOwnerNameCid(FileB,ClearO,Mode,Nil);
end;


{ =========== Close a File ============= }

{ Usage : Int:=Open_File(F[Fn]); }



Function  Close_FileCId(Var  FileB    :  FileVar;
                             ClientId :  Pointer) : Integer;

Var
  DumKeyNum,DumRecLen  :  Integer;
  DumDataRec           :  array[1..2] of Char;

  DumKey               :  String[1];

Begin
  FillChar(DumDataRec,Sizeof(DumDataRec),0);
  FillChar(DumKey,Sizeof(DumKey),0);

  Close_FileCId:=Btrv(B_Close,FileB,DumDataRec,DumRecLen,DumKey[1],DumKeyNum,ClientId);
end;



Function  Close_File(Var  FileB  :  FileVar) : Integer;


Begin
  Close_File:=Close_FileCId(FileB,nil);
end;



{ ==== Control storing of Current Keypath ==== }

Function GetThreadKeypath(Fnum       :  SmallInt;
                          ClientId   :  Pointer)  :  SmallInt;

Var
  CIdRec  :  ^ClientIdType;

Begin
  If (ClientId=nil) then
    Result:=CurrKeypath^[Fnum]
  else
  Begin
    CIdRec:=ClientId;
    Result:=CurrKeyAry^[CIdRec^.TaskId,Fnum];
  end;
end;



{ ==== Control storing of Current Keypath ==== }

Procedure SetThreadKeypath(Fnum,CKP       :  SmallInt;
                           ClientId       :  Pointer);

Var
  CIdRec  :  ^ClientIdType;

Begin
  if (CKP <> -1) and (CKP <> 255) then
  begin
    If (ClientId=nil) then
    begin
      // MH 10/11/2008: Modified to check bounds as this was a possible source of the memory overwrite issues in SQL
      //CurrKeypath^[Fnum]:=CKP
      If (fnum >= Low(CurrKeypath^)) And (FNum <= High(CurrKeyPath^)) Then
        CurrKeypath^[Fnum]:=CKP
    end
    else
    Begin
      CIdRec:=ClientId;
      // MH 10/11/2008: Modified to check bounds as this was a possible source of the memory overwrite issues in SQL
      //CurrKeyAry^[CIdRec^.TaskId,Fnum]:=CKP;
      If (fnum >= Low(TCurrKeyPath)) And (FNum <= High(TCurrKeyPath)) And
         (CIdRec^.TaskId >= Low(TCurrKeyAry)) And (CIdRec^.TaskId <= High(TCurrKeyAry)) Then
        CurrKeyAry^[CIdRec^.TaskId,Fnum]:=CKP;
    end;
  end;
end;



{ =========== Insert a Record ============= }

{ Usage : Int:=Add_rec(F[Fn],Fn,RecPtr[Fn]^,Indxno[0..]); }



Function Add_RecCId(Var  FileB    :  FileVar;
                         FileNum  :  Integer;
                    Var  DataRec;
                         CurKeyNum:  Integer;
                         ClientId :  Pointer)  :  Integer;

Var
  Tries  :  SmallInt;

Begin
  FillChar(CurIndKey,sizeof(CurIndKey),0);

  Tries:=0;

  Repeat
    Result:=Btrv(B_Insert,FileB,DataRec,FileRecLen[FileNum],CurIndKey[FileNum][1],CurKeyNum,ClientId);

    Inc(Tries);
  Until (Not (Result In [84,85])) or (Tries>TryMax);

  SetThreadKeypath(FileNum,CurKeyNum,ClientId);
end;



Function Add_Rec(Var  FileB    :  FileVar;
                      FileNum  :  Integer;
                 Var  DataRec;
                      CurKeyNum:  Integer)  :  Integer;

Begin
  Add_Rec:=Add_RecCId(FileB,FileNum,DataRec,CurKeyNum,nil);
end;



{ =========== Find a Record via Various Search Methods =============

B_GetEq,
B_GetNext,
B_GetPrev,
B_GetGretr,
B_GetGEq,
B_GetLess,
B_GetLessEq,
B_GetFirst,
B_GetLast.

 Usage : Int:=Find_Rec(Search Req,F[Fn],Fn,RecPtr[Fn]^,Indxno[0..],KeyToSearch); }


{ ====================== Function to Find a Record via the Key ================ }

Function Find_VarRec(     SearchType : Integer;
                     Var  FileB      : FileVar;
                          FileNum,
                          C          : Integer;
                     Var  DataRec;
                          CurKeyNum  : Integer;
                     Var  Key        : Str255;
                          ClientId   : Pointer): Integer;


Begin
   Fillchar(Key[Length(Key)+1],255-Length(Key),0);    { Strip Length Byte, & Fill with Blanks }

  Find_VarRec:=Btrv(SearchType,FileB,DataRec,C,Key[1],CurKeyNum,ClientId);

  Move(Key[1],CurIndKey[FileNum][1],255);             { Set CurIndKey[FileNum][1] to Key Returned }

  C:=255;

  While (Key[c]=#0) and (C>0) do
    C:=Pred(C);

  Key[0]:=Chr(C);                                        { Re-Build Turbo type string with length byte at beggining }

  SetThreadKeypath(FileNum,CurKeyNum,ClientId);
end;



{ ====================== Function to Find a Record via the Key Record Length assumed ================ }

Function Find_RecCId(     SearchType : Integer;
                     Var  FileB      : FileVar;
                          FileNum    : Integer;
                     Var  DataRec;
                          CurKeyNum  : Integer;
                     Var  Key        : Str255;
                          ClientId   : Pointer): Integer;

Var
  C : Integer;

Begin

  C:=FileRecLen[FileNum];

  Find_RecCId:=Find_VarRec(SearchType,FileB,FileNum,C,DataRec,CurKeyNum,Key,ClientId);

end;


Function Find_Rec(     SearchType : Integer;
                     Var  FileB      : FileVar;
                          FileNum    : Integer;
                     Var  DataRec;
                          CurKeyNum  : Integer;
                     Var  Key        : Str255): Integer;

Var
  C : Integer;

Begin

   C:=FileRecLen[FileNum];

  Find_Rec:=Find_VarRec(SearchType,FileB,FileNum,C,DataRec,CurKeyNum,Key,nil);

end;

{ =========== Procedure to Set default Tail settings ========== }

Procedure Prime_TailFilter(Var  ExtendTail  :  ExtendRepeatType;
                                FileNum     :  Integer);

Begin
  FillChar(ExtendTail,Sizeof(ExtendTail),0);

  With ExtendTail do
  Begin
    NumRecords:=1;

    NumFields:=1;

    FieldLen:=FileRecLen[FileNum];

    FieldOffset:=0;

  end; {With..}
end;


{ =========== Procedure to Set Default Filter Settings ========= }

Procedure Prime_Filter(Var  ExtendHead  :  ExtendGetDescType;
                       Var  ExtendTail  :  ExtendRepeatType;
                            FileNum     :  Integer;
                            FiltSize    :  Integer);



Begin
  FillChar(ExtendHead,Sizeof(ExtendHead),0);

  With ExtendHead do
  Begin
    DescLen:=FiltSize;

    ExtConst[1]:='E';
    ExtConst[2]:='G';

    RejectCount:=65535; {* default = 4095? *}

    NumTerms:=1;

  end;

  Prime_TailFilter(ExtendTail,FileNum);

end;




{ ========== Prime ClientId Record ======== }

Procedure Prime_ClientIdRec(Var  CIdRec  :  ClientIdType;
                                 AId     :  Str5;
                                 TId     :  SmallInt);

Begin
  FillChar(CIDRec,Sizeof(CIdRec),0);

  With CIDRec do
  Begin
    APPId[1]:=AId[1];
    APPId[2]:=AId[2];

    TaskId:=TId;
  end;

end;

{ =========== Delete a Record ============= }

{ Usage : Int:=Delete_rec(F[Fn],Fn,Indxno[0..]); }


Function Delete_RecCId(Var  FileB     :  FileVar;
                            FileNum   :  Integer;
                            CurrKeyNum:  Integer;
                            ClientId  :  Pointer) : Integer;

Const
  MaxRecLen  =  4000;

Var
  Tries,
  Trans,EndOnly,
  DumRecLen  :  Integer;
  DumKey :  Str255;
  DumRec :  array[1..MaxRecLen] of Char;

Begin
  Fillchar(CurIndKey,Sizeof(CurIndKey),0);

  DumRecLen:=FileRecLen[FileNum];

  Tries:=0;

  Repeat
    Trans:=Btrv(22,FileB,DumRec,DumRecLen,DumKey[1],CurrKeyNum,ClientId);
    If Trans=0 then

    DumRecLen:=FileRecLen[FileNum];


    Trans:=Btrv(23,FileB,DumRec,DumRecLen,CurIndKey[FileNum][1],CurrKeyNum,ClientId);
    If Trans=0 then

    Trans:=Btrv(4,FileB,DumRec,DumRecLen,CurIndKey[FileNum][1],CurrKeyNum,ClientId);

    Inc(Tries);
  Until (Not (Trans In [84,85])) or (Tries>TryMax);


  Delete_RecCId:=Trans;

end;



Function Delete_Rec(Var  FileB  :  FileVar;
                         FileNum:  Integer;
                      CurrKeyNum:  Integer) : Integer;


Begin

  Delete_Rec:=Delete_RecCId(FileB,FileNum,CurrKeyNum,nil);

end;


{ =========== Change a Record ============= }

{ Usage : Int:=Put_rec(F[Fn],Fn,RecPtr[Fn]^,Indxno[0..]); }


Function Put_RecCId(Var  FileB  :  FileVar;
                         FileNum:  Integer;
                    Var  DataRec;
                         CurrKeyNum:  Integer;
                         ClientId  :  Pointer) : Integer;

Const
  MaxRecLen  =  4000;

Var
  Tries,
  Trans,EndOnly,
  DumRecLen  :  Integer;
  DumKey :  Str255;
  DumRec :  array[1..MaxRecLen] of Char;

Begin
  Fillchar(CurIndKey,Sizeof(CurIndKey),0);

  DumRecLen:=FileRecLen[FileNum];

  EndOnly:=99;

  Tries:=0;


  {
  Trans:=Btrv(19,FileB,DataRec,DumRecLen,DumKey[1],CurrKeyNum);

  If (Debug) then Status_Means(Trans);
  If Trans=0 then
  }

  Repeat
    Trans:=Btrv(22,FileB,DumRec,DumRecLen,DumKey[1],CurrKeyNum,ClientId);

    If (Debug) and (Not (Trans In [84,85])) then Status_Means(Trans);

    DumRecLen:=FileRecLen[FileNum];


    If Trans=0 then
    Trans:=Btrv(23,FileB,DumRec,DumRecLen,CurIndKey[FileNum][1],CurrKeyNum,ClientId);

    If (Debug) and (Not (Trans In [84,85])) then Status_Means(Trans);

    If Trans=0 then
    Trans:=Btrv(B_Update,FileB,DataRec,DumRecLen,CurIndKey[FileNum][1],CurrKeyNum,ClientId);

    If (Debug) and (Not (Trans In [84,85])) then Status_Means(Trans);

    Inc(Tries);
    
  Until (Not (Trans In [84,85])) or (Tries>TryMax);


  {
  EndOnly:=Btrv(20,FileB,DataRec,FileRecLen[FileNum],DumKey[1],CurrKeyNum);

  If (Debug) then Status_Means(EndOnly);

  If EndOnly<>0 then
  EndOnly:=Btrv(21,FileB,DataRec,FileRecLen[FileNum],DumKey[1],CurrKeyNum);

  If (Debug) then Status_Means(EndOnly);
  }

  SetThreadKeypath(FileNum,CurrKeyNum,ClientId);

  Put_RecCId:=Trans;

end;


Function Put_Rec(Var  FileB  :  FileVar;
                      FileNum:  Integer;
                 Var  DataRec;
                   CurrKeyNum:  Integer) : Integer;


Begin

  Put_Rec:=Put_RecCId(FileB,FileNum,DataRec,CurrKeyNum,nil);

end;



{ =========== Get No of Records ============= }

{ Usage : LongInt:=Used_Recs(F[Fn],Fn); }

Procedure File_StatCId(Var  FileB    :  FileVar;
                            FileNum  :  Integer;
                            ClientId :  Pointer;
                       Var  RecCnt   :  LongInt;
                       Var  FileBVer :  Byte);

Var
  N,FBT                     :  Byte;
  Stat,DumRecLen,DumKeyNum  :  Integer;
  NumRec                    :  LongInt;
  KeyBuff                   :  Str255;
  DatBuf                    :  record
    FS                      :  FileStatSpec;
    Ks                      :  array[1..MaxNoKeys] of KeySpec;
    AltColt                 :  AltColtSeq;
  end;

Begin
  DumRecLen:=FileSpecLen[Filenum];
  DumKeyNum:=-1;

  Stat:=Btrv(15,FileB,DatBuf,DumRecLen,KeyBuff[1],DumKeyNum,ClientId);

  If (Stat=0) then
  Begin
    NumRec:=DatBuf.Fs.NotUsed;
    FBT:=DatBuf.Fs.FileVer;

    For n:=1 to MaxNoKeys do
      NoRecInKey[n]:=DatBuf.Ks[n].NotUsed;
  end
  else
  Begin
    NumRec:=0;
    FBT:=0;

    For n:=1 to MaxNoKeys do
      NoRecInKey[n]:=0;
  end;

  RecCnt:=NumRec;
  FileBVer:=FBT;
end;


{ =========== Get No of Records ============= }

{ Usage : LongInt:=Used_Recs(F[Fn],Fn); }

Function Used_RecsCId(Var  FileB    :  FileVar;
                           FileNum  :  Integer;
                           ClientId :  Pointer) : LongInt;

Var
  N                         :  Byte;
  NumRec                    :  LongInt;

Begin
  File_StatCId(FileB,FileNum,ClientId,NumRec,N);

  Used_recsCId:=NumRec;
end;



Function Used_Recs(Var  FileB  :  FileVar;
                        FileNum:  Integer) : LongInt;

Begin
  Used_Recs:=Used_RecsCId(FileB,FileNum,nil);
end;



Function File_VerCId(Var  FileB    :  FileVar;
                          FileNum  :  Integer;
                          ClientId :  Pointer) : Byte;

Var
  N                         :  Byte;
  NumRec                    :  LongInt;

Begin
  File_StatCId(FileB,FileNum,ClientId,NumRec,N);

  File_VerCId:=N;
end;


{ ======== Function To Check for Btrieve Presence by Requesting Version No. ======= }

Function GetBtrvStat(var FileB      :  FileVar;
                    Var BVer,BRev  :  Integer;
                    Var BTyp       :  Char;
                        Mode       :  Byte)  :  Integer;


Var
  Stat,DumLen,DumKeyNum  :  Integer;
  DumKey                 :  Str255;
  TmpCh                  :  Char;
  ShowAcc                :  String[2];

  DumRec                 :  Record
    LVer                  :  SmallInt;
    LRev                  :  SmallInt;
    LTyp                  :  Char;
    RVer                  :  SmallInt;
    RRev                  :  SmallInt;
    RTyp                  :  Char;
    SVer                  :  SmallInt;
    SRev                  :  SmallInt;
    STyp                  :  Char;
  end;

Begin
  FillChar(DumRec,Sizeof(DumRec),0);
  FillChar(DumKey,Sizeof(DumKey),0);

  DumLen:=15; DumKeyNum:=0;

  If (AccelMode) then
    ShowAcc:='AC'
  else
    ShowAcc:='';

  Stat:=Btrv(26,FileB,DumRec,DumLen,DumKey,DumKeyNum,nil);

  GetBtrvStat:=Stat;

  If (Debug) then
  With DumRec do
  Begin
    {Gotoxy(1,25); Write('*** Ver ',Ver:1,'.',Rev:1,' Type :',Typ,'<',ShowAcc);}
  end;

  If (Stat=0) then
  With DumRec do
  Begin
    Case Mode of
      0,1:  Begin
              BVer:=LVer;
              BRev:=LRev;
              BTyp:=LTyp;
            end;
      2  :  Begin
              BVer:=RVer;
              BRev:=RRev;
              BTyp:=RTyp;
            end;
      3  :  Begin
              BVer:=SVer;
              BRev:=SRev;
              BTyp:=STyp;
            end;
    end; {Case..}
  end;

end;

{ ======== Function To Check for Btrieve Presence by Requesting Version No. ======= }

Function GetBtrvVer(var FileB      :  FileVar;
                    Var BVer,BRev  :  Integer;
                    Var BTyp       :  Char;
                        Mode       :  Byte)  :  Boolean;


Var
  Stat                   :  Integer;

Begin

  Stat:=GetBtrvStat(FileB,BVer,BRev,BTyp,Mode);

  GetBtrvVer:=(Stat=0);


end;





{ ======== Function To Check for Btrieve Presence by Requesting Version No. ======= }

Function Check4BtrvOk  :  Boolean;

Var
  Ver        :  Integer;
  Rev        :  Integer;
  Typ        :  Char;

  DumBlock   :  FileVar;

Begin

  FillChar(DumBlock,Sizeof(DumBlock),0);

  Check4BtrvOK:=GetBtrvVer(DumBlock,Ver,Rev,Typ,1);

end;


{ ======== Function to Check if running stand-alone BT ======== }

Function Check4SABtrv(FileB  :  FileVar)  :  Boolean;

Var
  Ver        :  Integer;
  Rev        :  Integer;
  Typ        :  Char;
  TmpBo      :  Boolean;

Begin

  TmpBo:=GetBtrvVer(FileB,Ver,Rev,Typ,3);

  {$IFNDEF BCS}

    If (TmpBo) then  {* Its C/S if >v5, or BT type = 'S(erver *}
      TmpBo:=((Ver<=BCSVer) or ((Typ<>BCSType) and (Typ<>BNTCSType)))
    else
      Chk4BCS:=BOff; {* Force CS msg off, as Bt not loaded anyway...*}

  {$ENDIF}

  Check4SABtrv:=TmpBo;

end;








{ ================= Procedure to Define The Alternate Collating Sequence UpperAlt ================== }

Procedure SetUpperAlt;

Var
  Loop  :  Integer;

Begin
  With UpperALT do
  Begin
    SigByte:=Chr($AC);
    Header:='UPPERALT';

    For Loop:=0 to 255 do
      AltColtChars[Loop]:=Upcase(Chr(Loop));
  end; {With..}
end;




{ ======= Initialise Various Variables ======== }


Procedure InitBVars;

Var
  n  :  Byte;

Begin
  For n:=1 to MaxFiles do
  Begin
    VariFile[n]:=FALSE;
  end;

  FillChar(F,Sizeof(F),0);

  New(CurrKeypath);

  FillChar(CurrKeyPath^,SizeOf(CurrKeyPath^),0);

  New(CurrKeyAry);

  FillChar(CurrKeyAry^,SizeOf(CurrKeyAry^),0);

  New(OwnerName);

  FillChar(OwnerName^,SizeOf(OwnerName^),0);

end;




{ =========================== Return Position of Current DataRec ================== }

Function GetPosCId(Var  FileB    :  FileVar;
                        FileNum  :  Integer;
                   Var  Posn     :  LongInt;
                        ClientId :  Pointer) : Integer;


Var
  DumRecLen,DumKeyNum  :  Integer;
  DumKey               :  Str255;


Begin
  DumRecLen:=FileRecLen[FileNum];
  DumKeyNum:=0;

  GetPosCId:=Btrv(22,FileB,Posn,DumRecLen,DumKey[1],DumKeyNum,ClientId);
end;


Function GetPos(Var  FileB  :  FileVar;
                     FileNum:  Integer;
                Var  Posn   :  LongInt) : Integer;



Begin
  GetPos:=GetPosCId(FileB,FileNum,Posn,nil);
end;

{ ======================== Return Record by Position Offset ================ }

Function  GetDirectCId(Var  FileB  :  FileVar;
                            FileNum:  Integer;
                       Var  DataRec;
                            CurrKeyNum,
                            LockCode :  Integer;
                            ClientId :  Pointer) : Integer;

Var
  DumKey  :  Str255;

Begin
  GetDirectCId:=Btrv(23+LockCode,FileB,DataRec,FileRecLen[FileNum],DumKey[1],CurrKeyNum,ClientId);

  SetThreadKeypath(FileNum,CurrKeyNum,ClientId);

end;

{$IF Defined(COMTK) Or Defined(BUREAUDLL)}
  // HM 29/01/01: Added for COM Toolkit
  Function  CTK_GetDirectCId(Var  FileB    :  FileVar;
                                  FileNum  :  Integer;
                             Var  DataRec;
                                  CurrKeyNum,
                                  LockCode :  Integer;
                             Var  Key      : Str255;
                                  ClientId :  Pointer) : Integer;

  Var
    C : Integer;

  Begin
    Fillchar(Key[Length(Key)+1],255-Length(Key),0);

    Result := Btrv(23+LockCode,FileB,DataRec,FileRecLen[FileNum],Key[1],CurrKeyNum,ClientId);

    C := 255;
    While (Key[c]=#0) and (C>0) do
      C:=Pred(C);

    Key[0] := Chr(C);

    SetThreadKeypath(FileNum,CurrKeyNum,ClientId);
  end;
{$IfEnd}

Function  GetDirect(Var  FileB  :  FileVar;
                         FileNum:  Integer;
                    Var  DataRec;
                         CurrKeyNum,
                         LockCode :  Integer) : Integer;


Begin
  GetDirect:=GetDirectCId(FileB,FileNum,DataRec,CurrKeyNum,LockCode,nil);

end;




{ =========== Stop Btrieve ============= }

{ Remove Btrive From Memory }

{ Usage : Int:=B_Stop; }


Function  Stop_B  :  Integer;

Var
  DumKeyNum,DumRecLen  :  Integer;
  DumDataRec           :  array[1..2] of Char;
  FileB                :  FileVar;

  DumKey               :  String[1];

Begin
  Stop_B:=Btrv(B_Stop,FileB,DumDataRec,DumRecLen,DumKey[1],DumKeyNum,nil);
end;



{ =========== Reset All Files On Btrieve ============= }

{ Performs a stop without unloading Btrieve }

{ Usage : Int:=B_Reset; }



Function  Reset_BCId(ClientId  :  Pointer)  :  Integer;

Var
  DumKeyNum,DumRecLen  :  Integer;
  DumDataRec           :  array[1..2] of Char;
  FileB                :  FileVar;

  DumKey               :  String[1];

Begin
  Reset_BCid:=Btrv(B_Reset,FileB,DumDataRec,DumRecLen,DumKey[1],DumKeyNum,ClientId);
end;


Function  Reset_B  :  Integer;


Begin
  Reset_B:=Reset_BCid(nil);
end;



Function  Ctrl_BTransCId(SearchMode  :  Integer;
                         ClientId    :  Pointer) : Integer;

Var
  DumKeyNum,DumRecLen  :  Integer;
  DumDataRec           :  array[1..2] of Char;
  FileB                :  FileVar;

  DumKey               :  String[1];

Begin
  FillChar(DumDataRec,Sizeof(DumDataRec),0);
  FillChar(DumKey,Sizeof(DumKey),0);
  FillChar(FileB,Sizeof(FileB),0);
  DumKeyNum:=0;
  DumRecLen:=0;

  Result:=Btrv(SearchMode,FileB,DumDataRec,DumRecLen,DumKey[1],DumKeyNum,ClientId);
end;


Function  Ctrl_BTrans(SearchMode  :  Integer) : Integer;

Begin

  Result:=Ctrl_BTransCId(SearchMode,Nil);

end;


{ =========== Unlock a Single Record from a Multi record Lock ======== }


Function UnLockMulTiSingCId(var FileB   :  FileVar;
                            FileNum :  Integer;
                            RecAddr :  LongInt;
                            ClientId:  Pointer)  :  Integer;


Var
  DumRecLen   :   Integer;
  DumKey      :   Str255;
  DumRec      :   Array[1..4000] of Char;
  DumKeyNum   :   Integer;



Begin
  FillChar(DumKey,SizeOf(DumKey),0);
  FillChar(DumRec,Sizeof(DumRec),0);

  DumKeyNum:=-1;

  DumRecLen:=SizeOf(RecAddr);

  Move(RecAddr,DumRec,DumRecLen);

  UnLockMultiSingCId:=Btrv(B_Unlock,FileB,DumRec,DumRecLen,DumKey[1],DumKeyNum,ClientId);

end;

Function UnLockMulTiSing(var FileB   :  FileVar;
                         FileNum :  Integer;
                         RecAddr :  LongInt)  :  Integer;
Begin
  UnLockMultiSing:=UnLockMultiSingCId(FileB,FileNum,RecAddr,nil);
end;


Function Presrv_BTPosCId(Fnum      :  Integer;
                    Var Keypath   :  Integer;
                    Var LFV       :  FileVar;
                    Var RecAddr   :  LongInt;
                        UsePos,
                        RetRec    :  Boolean;
                        ClientId  :  Pointer)  :  Integer;



Var
  TmpStat    :  Integer;
  DumRecLen  :  Integer;
  DumRec     :  Array[1..4000] of Char;


Begin

  TmpStat:=0;

  If (UsePos) then
  Begin
    If (RecAddr<>0) and (Keypath>=0) then
    Begin

      FillChar(DumRec,Sizeof(DumRec),0);

      Move(RecAddr,DumRec,Sizeof(RecAddr));

      TmpStat:=GetDirectCId(LFV,Fnum,DumRec,Keypath,0,ClientId); {* Re-Establish Position *}

      If (TmpStat=0) and (RetRec) then
        Move(DumRec,RecPtr[Fnum]^,FileRecLen[Fnum]);

    end
    else
      TmpStat:=8;
  end
  else
  Begin

    RecAddr:=0;

    TmpStat:=GetPosCId(LFV,Fnum,RecAddr,ClientId);

    If (Keypath=GetPosKey) then {* Calculate current key from pos blk *}
      If (TmpStat=0) then
        Keypath:=GetThreadKeyPath(Fnum,ClientId)
      else
        KeyPath:=0;

  end;

  Presrv_BTPosCId:=TmpStat;

end; {Func..}


Function Presrv_BTPos(Fnum      :  Integer;
                  Var Keypath   :  Integer;
                  Var LFV       :  FileVar;
                  Var RecAddr   :  LongInt;
                      UsePos,
                      RetRec    :  Boolean)  :  Integer;




Begin

  Presrv_BTPos:=Presrv_BTPosCId(Fnum,Keypath,LFV,RecAddr,UsePos,RetRec,nil);

end; {Func..}



{ ==== Get FileSpec of open file ==== }
{ Usage : LongInt:=GetFileSpec(F[Fn],Fn,FileSpec); }
Function GetFileSpecCId(Var  FileB   : FileVar;
                             FileNum : Integer;
                        Var  FSpec   : FileSpec;
                             ClientId: Pointer) : LongInt;

Type
  DatBufType = Record
    FS       : FileSpec;
    Ks       : array[1..MaxNoKeys] of KeySpec;
    AltColt  : AltColtSeq;
  End; { DatBufType }
Var
  DumRecLen,DumKeyNum  :  Integer;
  KeyBuff              :  Str255;
  DatBuf               :  DatBufType;
Begin
  DumRecLen := SizeOf(DatBufType);
  DumKeyNum := 0;

  { HM 30/04/99: Added as it appears to fix a problem under Win98 reading the filespec }
  {              where the filespec is returning rubbish                               }
  FillChar (DatBuf, SizeOf(DatBuf), #0);

  DumRecLen:=FileSpecLen[Filenum];
  Result:=Btrv(15,FileB,DatBuf,DumRecLen,KeyBuff[1],DumKeyNum,ClientId);
  FSpec := DatBuf.Fs;
end;

Function GetFileSpec(Var  FileB   : FileVar;
                          FileNum : Integer;
                     Var  FSpec   : FileSpec) : LongInt;

Begin
  Result:=GetFileSpecCId(FileB,FileNum,FSpec,nil);
end;


{ =========== Get File Index Spec ============= }


Function GetFullFile_StatCId(Var  FileB    :  FileVar;
                                  FileNum  :  Integer;
                                  ClientId :  Pointer)  :  FullFileKeySpec;

Var
  N                         :  Byte;
  Stat,DumRecLen,DumKeyNum  :  Integer;
  KeyBuff                   :  Str255;
  DatBuf                    :  FullFileKeySpec;

Begin
  FillChar(DatBuf,Sizeof(DatBuf),#0);

  DumRecLen:=FileSpecLen[Filenum];
  DumKeyNum:=-1;

  Stat:=Btrv(15,FileB,DatBuf,DumRecLen,KeyBuff[1],DumKeyNum,ClientId);

  If (Stat=0) then
  Begin
    Result:=DatBuf;

  end
  else
  Begin
    FillChar(Result,Sizeof(Result),#0);

  end;

end;

type

  //PR: 29/11/2017 ABSEXCH-19503 Return record for STAT EXTENDED call,
  //subfunction 4 - File Information
  TStatExtFileInfo = Record
    FileId : Longint;
    NoHandles : Longint;
    TimeStamp : Longint;
    UsageCount : Longint;
    Flags : Longint;
  end;


//PR: 28/11/2017 ABSEXCH-19503  Function to check encryption status of file
function IsFileEncrypted(var FileB    :  FileVar;
                             ClientId :  Pointer) : Boolean;
var
  FileInfo: TStatExtFileInfo;
  DumKey : Str255;
  DumKeyNum : longint;
  DumLen : longint;
  Res : Integer;
begin
  Result := False;
  //PR: 20/02/2018 ABSEXCH-19781 Don't try to check encryption on SQL
  if not SQLUtils.UsingSQL then
  begin
    DumLen := SizeOf(FileInfo);
    FillChar(DumKey, SizeOf(DumKey), 0);
    DumKeyNum := 0;

    FillChar(FileInfo, SizeOf(FileInfo), 0);
    FileInfo.FileId := $74537845; //ExtStat
    FileInfo.NoHandles := 4; //SubFunction

    Res := Btrv(65, FileB, FileInfo, DumLen, DumKey, DumKeyNum, ClientID);
    if Res = 0 then
      Result := (FileInfo.Flags and $100) = $100;
  end; //if not SQLUtils.UsingSQL
end;


{ Function to return position of field within a record }
Function BtKeyPos (Const OfsField, OfsRec : Pointer) : Word;

Var
  OfR, OfF : LongInt;
Begin { BKeyPos }

  {Required for windows}

  OfR := LongInt(OfsRec);
  OfF := LongInt(OfsField);

  {Required for DOS}

  {OfF:=Ofs(OfsField^);
  OfR:=Ofs(OfsRec^);}


  If (OfF > OfR) Then
    BtKeyPos := (OfF - OfR) + 1
  Else
    BtKeyPos := 1;
End;  { BKeyPos }




{$IFNDEF NOBTRegChk}
  Procedure Check_LocalCSEnforcement;

  Var
    Reg     :  TRegistry;
    BTMode,
    CSMode  :  Integer;

  Begin
    BTForceLocalEngine :=BOff;

    BTForceCSEngine:=BOff;

    BTMode:=0; CSMode:=0;

    Reg:=TRegistry.Create(KEY_EXECUTE);

    Try
    With Reg do
    Begin
      Access:=KEY_EXECUTE;
      RootKey:=HKEY_LOCAL_MACHINE;

      Try
        If OpenKey('SOFTWARE\Exchequer\Enterprise',False) then
        Begin
          If ValueExists('BtrieveMode') then
          Begin
            BTMode:=ReadInteger('BtrieveMode');

            Case BTMode of
              0  :  BTForceLocalEngine:=BOn;
              1  :  Begin
                      If ValueExists('ForceCS') then
                      Begin
                        CSMode:=ReadInteger('ForceCS');

                        BTForceCSEngine:=(CSMode=1);
                      end;
                    end;
              { HM 03/10/03: Added mode 2 for Workgroup Engine }
              2  :  Begin
                      { When ON these settings cause major problems opening files }
                      BTForceLocalEngine :=BOff;
                      BTForceCSEngine:=BOff;
                    End;
            end; {Case..}
          end;
        end; {If Main Root exists}
      except
        on  Exception do
            ;

      end;
    end; {With..}
    Finally
      Reg.Free;
    end;

  end;


{$ENDIF}

{$IFNDEF BTRVSQL_DLL}
   // CJS 15/03/2011 - applied EXSQL directive so that these calls are only
   //                  compiled if BtrvSQL is being used.
  {$IFDEF EXSQL}
procedure OnEnterModule;
var
  Buffer : array[0..255] of Char;
  Len    : SmallInt;
  ModuleName: AnsiString;
begin
  { Extract dll name }
  Len := GetModuleFileName(HInstance, Buffer, SizeOf(Buffer));
  if (Len > 0) Then Begin
    ModuleName := ExtractFileName(Buffer);
    { Trim Extension off end }
    if (Pos ('.', ModuleName) > 0) then
      Delete(ModuleName, Pos ('.', ModuleName), Length(ModuleName));
  end
  else
    ModuleName := '';
  EnteringModule(PChar(ModuleName));
end;

procedure OnLeaveModule;
var
  Buffer : array[0..255] of Char;
  Len    : SmallInt;
  ModuleName: AnsiString;
begin
  { Extract dll name }
  Len := GetModuleFileName(HInstance, Buffer, SizeOf(Buffer));
  if (Len > 0) Then Begin
    ModuleName := ExtractFileName(Buffer);
    { Trim Extension off end }
    if (Pos ('.', ModuleName) > 0) then
      Delete(ModuleName, Pos ('.', ModuleName), Length(ModuleName));
  end
  else
    ModuleName := '';
  LeavingModule(PChar(ModuleName));
end;
  {$ENDIF}
{$ENDIF}

Initialization


  GetMem (FileNames, SizeOf (FileNames^));

  Fn:=1;

  SetUpperALT;

  OwnerName:=nil;

  InitBVars;



  {$IFNDEF NOBTRegChk}

    Checked4SA:=0;

    Check_LocalCSEnforcement;
  {$ELSE}
    Checked4SA:=1;

    BTForceLocalEngine :=BOff;

    BTForceCSEngine:=BOff;
  {$ENDIF}


   {$IFNDEF BCS}

    Chk4BCS:=BOn;

  {$ELSE}

    Chk4BCS:=BOff;

  {$ENDIF}

  AssignBOwner(ExBTOWNER);

{$IFNDEF BTRVSQL_DLL}
  {$IFDEF EXSQL}
  OnEnterModule;
  {$ENDIF}
{$ENDIF}

Finalization
  FreeMem (FileNames, SizeOf (FileNames^));

  Dispose(CurrKeypath);

  Dispose(CurrKeyAry);

  If (Assigned(OwnerName)) then
    Dispose(OwnerName);

  OwnerName:=nil;

{$IFNDEF BTRVSQL_DLL}
  {$IFDEF EXSQL}
  OnLeaveModule;
  {$ENDIF}
{$ENDIF}

end.
