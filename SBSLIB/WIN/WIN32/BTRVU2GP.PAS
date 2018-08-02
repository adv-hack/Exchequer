Unit Btrvu2gp;


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

  BTDLLPath  =  'WBTRV32.DLL';

  BCSVer     : Byte    = 5;
  BCSType    : Char    = 'S';


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
  B_EOF      =  9;
  B_Create   =  14;
  B_Stop     =  25;
  B_Unlock   =  27;
  B_Reset    =  28;

  B_GetEq    =  5;
  B_GetNext  =  6;
  B_GetNextEx=  36;
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

    MaxFiles  =  18;

  {$ELSE}

    MaxFiles   = 18;

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








  FileVar  =  array[1..128] of char;
  TCurrKeyPath = Array[1..MaxFiles] of Byte;

  TCurrKeyAry  = Array[0..100] of TCurrKeyPath;



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
  RejectCount     :    SmallInt;             {* No. of rejects allowed before aborting *}
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
  TotFiles   :   Integer;
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
  Chk4BCS    :   Boolean;




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

{ =============== ****** Decode Btrv Error ****** =========== }

Function Set_StatMes(StatNo  :  Integer) : Str80;

Procedure Status_Means(StatNo  :  Integer);

{ ======== Function To Check for Btrieve Presence by Requesting Version No. ======= }

Function Check4BtrvOk  :  Boolean;

Function GetBtrvVer(    FileB      :  FileVar;
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

{ ==== Get FileSpec of open file ==== }

Function GetFileSpecCId(Var  FileB   : FileVar;
                             FileNum : Integer;
                        Var  FSpec   : FileSpec;
                             ClientId: Pointer) : LongInt;

Function GetFileSpec(Var  FileB   : FileVar;
                          FileNum : Integer;
                     Var  FSpec   : FileSpec) : LongInt;



{ =========== Stop Btrieve ============= }

{ Remove Btrive From Memory }

{ Usage : Int:=B_Stop; }

Function  Stop_B  :  Integer;

Function  Reset_BCId(ClientId  :  Pointer)  :  Integer;

Function  Reset_B  :  Integer;


Function UnLockMulTiSingCId(FileB   :  FileVar;
                            FileNum :  Integer;
                            RecAddr :  LongInt;
                            ClientId:  Pointer)  :  Integer;

Function UnLockMulTiSing(FileB   :  FileVar;
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



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses Windows,Dialogs,SysUtils;


Var

  _BTRCALL  :  Function(operation : WORD;
               VAR posblk;
               VAR databuf;
               VAR datalen   : WORD;
               VAR keybuf;
                   keylen    : BYTE;
                   keynum    : Integer
                   ) : Integer; {FAR; StdCall;
                   external  BTDLLPath name 'BTRCALL';}

  _BTRCALLID  : Function(
                   operation : WORD;
               VAR posblk;
               VAR databuf;
               VAR datalen   : WORD;
               VAR keybuf;
                   keylen    : BYTE;
                   keynum    : Integer;
               Var clientid     ) : Integer; {FAR; StdCall;
                   external  BTDLLPath name 'BTRCALLID';}


   _WBTRVINIT  :  Function(
               VAR intializationString): Integer; {FAR; stdcall;
                   external BTDLLPath  name 'WBTRVINIT';}

   _WBTRVSTOP: Function  :Integer; {FAR; stdcall;
               external BTDLLPath name 'WBTRVSTOP';}

 _SBSFORM   :  THandle;


 Function sbsForm_Initialise  :  Boolean;

Const
  ResNames  :  Array[0..4] of PChar = ('WBTRV32','BTRCALL','BTRCALLID',
                                       'WBTRVINIT','WBTRVSTOP');

Var
  DLLAddr  :  TFarProc;

Begin
  _BTRCALL:=nil;
  _BTRCALLID:=nil;
  _WBTRVINIT:=nil;
  _WBTRVSTOP:=nil;

  _SBSForm:=LoadLibrary(ResNames[0]);

  try
    If (_SBSForm>HInstance_Error) then
    Begin
      DLLAddr:=GetProcAddress(_SBSForm,ResNames[1]);

      If (DLLAddr<>nil) then
      Begin
        _BTRCALL:=DLLAddr;

        DLLAddr:=GetProcAddress(_SBSForm,ResNames[2]);

        If (DLLAddr<>nil) then
          _BTRCALLID:=DLLAddr;

          DLLAddr:=GetProcAddress(_SBSForm,ResNames[3]);

        If (DLLAddr<>nil) then
          _WBTRVINIT:=DLLAddr;

        DLLAddr:=GetProcAddress(_SBSForm,ResNames[4]);


        If (DLLAddr<>nil) then
          _WBTRVSTOP:=DLLAddr;
      end
      else
      Begin
        _SBSFOrm:=0;
        FreeLibrary(_SBSForm);
      end;
    end
    else
      _SBSForm:=0;

  except

    FreeLibrary(_SBSForm);
    _SBSForm:=0;


  end; {except..}

  Result:=(_SBSForm<>0);
  
end; {Proc..}




  {This function is currently not supported. You initialize brequest.exe
   when you load it before loading windows. Therefore, there is no need
   to initialize the WBTRCALL.DLL requestor from your Windows application}


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
    KeyLen:= 255;                       {maximum key length}
    DataL:=DataLen;

    {Move(Keybuffer,InitStr,KeyLen);}

    {mbRet:=MessageDlg('Filename '+InitStr,mtInformation,[mbOk],0);}

    If (_SBSFOrm<>0) then
    Begin
      If (Clientid=nil) then
        Btrv := _BtrCall(Operation,  PositionBlock,DataBuffer,
                        DataL,    KeyBuffer,      KeyLen,
                        KeyNumber)
      else
        Btrv:=_BtrCallId(Operation,  PositionBlock,DataBuffer,
                        DataL,    KeyBuffer,      KeyLen,
                        KeyNumber,
                        ClientId^);
    end
    else
      Result:=20;

    DataLen:=DataL;

  End; {Btrv}


  {Initializes the local DLL}
  Function BtrvInit (Var InitializationString): Integer;
  Begin
    BtrvInit := _WBtrvInit (InitializationString);
  End; {End BtrvInit}


  {Stops this instance of Btrieve}
  Function BtrvStop: Integer;
  Begin
    BtrvStop:= _WBtrvStop;
  End; {End BtrvStop}


  {Initializes the requestor DLL}
  Function BRqShellInit(Var InitializationString): Integer;
  Begin
    {BRqShellInit:= WBRqShellInit(InitializationString);}
  End; {End BRqShellInit}




{ =============== Simple Check on Status Flg =================== }

Function StatusOK  :  Boolean;

Begin
  StatusOK:=(Status=0);
end;



{ =============== ****** Decode Btrv Error ****** =========== }

Function Set_StatMes(StatNo  :  Integer) : Str80;

Var
  Mess  :  Str80;

Begin

  Mess:='';

  Case StatNo of

    1  :  Mess:='Invalid Operation No >=0<=32 +Lock...';
    2  :  Mess:='I/O Error Could be Corrupted File ..';
    3  :  Mess:='File Not Open..';
    4  :  Mess:='Key Not Found';
    5  :  Mess:='Duplicate Error... Dupli Key Added to Non Dupli Key';
    6  :  Mess:='Invalid Key No.';
    7  :  Mess:='Different Key No. to Prev Operation';
    8  :  Mess:='Invalid Positioning... Update/Delete called before positiong';
    9  :  Mess:='End of File Reached';
    10 :  Mess:='Modify Error... Modify to Non Modify Key';
    11 :  Mess:='Invalid File Name';
    12 :  Mess:='File Not Found';
    13 :  Mess:='Extension Error';
    14 :  Mess:='Pre-Open Error';
    15 :  Mess:='Pre-Image Error';
    16 :  Mess:='Expansion Error';
    17 :  Mess:='Close Error ... ';
    18 :  Mess:='Disk Full!!';
    19 :  Mess:='Unrecoverable Error';
    20 :  Mess:='Record Manager not Active';
    21 :  Mess:='Key Buffer Error';
    22 :  Mess:='Record Buffer.. Length Mismatch';
    23 :  Mess:='Position Block';
    24 :  Mess:='Page Size Multiple Error';
    25 :  Mess:='Create IO Error';
    26 :  Mess:='No of Keys Exceeds Page Size';
    27 :  Mess:='Key Position Error';
    28 :  Mess:='Record Length';
    29 :  Mess:='Key Length Error';
    30 :  Mess:='non Btrieve File name Error';
    31 :  Mess:='Extend already implemented';
    32 :  Mess:='Extend IO Error';
    34 :  Mess:='Extend File Name not valid';
    35 :  Mess:='Invalid Path';
    36 :  Mess:='Transaction not possible as /T switch not active';
    37 :  Mess:='A Begin Tran was called before a previous Tran had finished';
    38 :  Mess:='Transaction Control File Error';
    39 :  Mess:='End/Abort Transaction called before Begin';
    40 :  Mess:='Transaction Max Files';
    41 :  Mess:='Transaction Operation';
    42 :  Mess:='Incomplete Accelerated Access';
    43 :  Mess:='Invalid Data record Address';
    44 :  Mess:='Null Key Path..';
    45 :  Mess:='Inconsistent Key Flag settings';
    46 :  Mess:='Access to File Denied';
    47 :  Mess:='Maximum No. of Open Files';
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
    58 :  Mess:='Compression Buffer too Short';
    59 :  Mess:='File Already Exsists';
    80 :  Mess:='Conflict.. Record Changed By Other Station since Read';
    81 :  Mess:='Lock Error';
    82 :  Mess:='Lost Position';
    83 :  Mess:='Read Outside Transaction';
    84 :  Mess:='Record in Use';
    85 :  Mess:='File in Use (by another Transaction)';
    86 :  Mess:='File Full!!';
    87 :  Mess:='Handle Full';
    88 :  Mess:='Incompatible Mode';
    89 :  Mess:='Name Error';
    90 :  Mess:='Device Full';
    91 :  Mess:='Server Error';
    92 :  Mess:='Trans Full';
    93 :  Mess:='Incompatible Lock Type';
    94 :  Mess:='Permission Error';
    97 :  Mess:='Data Message too Small';
    99 :  Mess:='Demo Error';
    else  Mess:='?! Unknown Error';
  end;
  Set_StatMes:=Mess;
end;



{ =============== ****** Return Std Debug Message =========== }
Procedure Status_Means(StatNo  :  Integer);

Var
  Mess     :   String[80];
  MbRet    :   Word;

Begin
  If (StatNo<>0) then
  Begin
    mbRet:=MessageDlg('Status '+InttoStr(StatNo)+','+Set_StatMes(StatNo),mtInformation,[mbOk],0);

  end;
end;



{ =========== Create a New File ============= }

{ Usage : Int:=Make_File(F[Fn],FileNames[Fn],CustFileRec,Sizeof(CustFileRec)); }


Function  Make_FileCId(Var FileB    :  FileVar;
                           FileName :  Str255;
                       Var FileDef;
                           BufferLen:  Integer;
                           ClientId :  Pointer) : Integer;


Begin
  FillChar(FileName[Length(FileName)+1],255-Length(FileName),0);

  Make_FileCId:=Btrv(B_Create,FileB,FileDef,BufferLen,FileName[1],0,ClientId);
end;



Function  Make_File(Var FileB    :  FileVar;
                        FileName :  Str255;
                    Var FileDef;
                        BufferLen:  Integer) : Integer;


Begin
  Make_File:=Make_FileCId(FileB,FileName,FileDef,BufferLen,nil);
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

  InitStr   :  Array[0..254] of Char;

Begin
  FillChar(OwnerNam,Sizeof(OwnerNam),0);
  OwnerLen:=Length(OwnerNam);
  FillChar(FileName[Length(FileName)+1],255-Length(FileName),0);

  Open_FileCId:=Btrv(B_Open,FileB,OwnerNam[1],OwnerLen,FileName[1],Mode,ClientID);
end;


Function Open_File(Var  FileB    :  FileVar;
                        FileName :  Str255;
                        Mode     :  Integer)  :  Integer;

Begin
  Open_File:=Open_FileCId(FileB,FileName,Mode,nil);
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
  If (ClientId=nil) then
    CurrKeypath^[Fnum]:=CKP
  else
  Begin
    CIdRec:=ClientId;
    CurrKeyAry^[CIdRec^.TaskId,Fnum]:=CKP;
  end;
end;



{ =========== Insert a Record ============= }

{ Usage : Int:=Add_rec(F[Fn],Fn,RecPtr[Fn]^,Indxno[0..]); }



Function Add_RecCId(Var  FileB    :  FileVar;
                         FileNum  :  Integer;
                    Var  DataRec;
                         CurKeyNum:  Integer;
                         ClientId :  Pointer)  :  Integer;

Begin
  FillChar(CurIndKey,sizeof(CurIndKey),0);

  Add_RecCId:=Btrv(B_Insert,FileB,DataRec,FileRecLen[FileNum],CurIndKey[FileNum][1],CurKeyNum,ClientId);

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

    RejectCount:=0;

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
  Trans,EndOnly,
  DumRecLen  :  Integer;
  DumKey :  Str255;
  DumRec :  array[1..MaxRecLen] of Char;

Begin
  Fillchar(CurIndKey,Sizeof(CurIndKey),0);

  DumRecLen:=FileRecLen[FileNum];

  Trans:=Btrv(22,FileB,DumRec,DumRecLen,DumKey[1],CurrKeyNum,ClientId);
  If Trans=0 then

  DumRecLen:=FileRecLen[FileNum];


  Trans:=Btrv(23,FileB,DumRec,DumRecLen,CurIndKey[FileNum][1],CurrKeyNum,ClientId);
  If Trans=0 then

  Trans:=Btrv(4,FileB,DumRec,DumRecLen,CurIndKey[FileNum][1],CurrKeyNum,ClientId);


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
  Trans,EndOnly,
  DumRecLen  :  Integer;
  DumKey :  Str255;
  DumRec :  array[1..MaxRecLen] of Char;

Begin
  Fillchar(CurIndKey,Sizeof(CurIndKey),0);

  DumRecLen:=FileRecLen[FileNum];

  EndOnly:=99;

  {
  Trans:=Btrv(19,FileB,DataRec,DumRecLen,DumKey[1],CurrKeyNum);

  If (Debug) then Status_Means(Trans);
  If Trans=0 then
  }

  Trans:=Btrv(22,FileB,DumRec,DumRecLen,DumKey[1],CurrKeyNum,ClientId);

  If (Debug) then Status_Means(Trans);

  DumRecLen:=FileRecLen[FileNum];


  If Trans=0 then
  Trans:=Btrv(23,FileB,DumRec,DumRecLen,CurIndKey[FileNum][1],CurrKeyNum,ClientId);

  If (Debug) then Status_Means(Trans);

  If Trans=0 then
  Trans:=Btrv(B_Update,FileB,DataRec,DumRecLen,CurIndKey[FileNum][1],CurrKeyNum,ClientId);

  If (Debug) then Status_Means(Trans);

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

Function Used_RecsCId(Var  FileB    :  FileVar;
                           FileNum  :  Integer;
                           ClientId :  Pointer) : LongInt;

Var
  N                         :  Byte;
  Stat,DumRecLen,DumKeyNum  :  Integer;
  NumRec                    :  LongInt;
  KeyBuff                   :  Str255;
  DatBuf                    :  record
    FS                      :  FileSpec;
    Ks                      :  array[1..MaxNoKeys] of KeySpec;
    AltColt                 :  AltColtSeq;
  end;

Begin
  DumRecLen:=FileSpecLen[Filenum];


  Stat:=Btrv(15,FileB,DatBuf,DumRecLen,KeyBuff[1],DumKeyNum,ClientId);

  If (Stat=0) then
  Begin
    NumRec:=DatBuf.Fs.NotUsed;

    For n:=1 to MaxNoKeys do
      NoRecInKey[n]:=DatBuf.Ks[n].NotUsed;
  end
  else
  Begin
    NumRec:=0;

    For n:=1 to MaxNoKeys do
      NoRecInKey[n]:=0;
  end;

  Used_recsCId:=NumRec;
end;

Function Used_Recs(Var  FileB  :  FileVar;
                        FileNum:  Integer) : LongInt;

Begin
  Used_Recs:=Used_RecsCId(FileB,FileNum,nil);
end;



{ ======== Function To Check for Btrieve Presence by Requesting Version No. ======= }

Function GetBtrvVer(    FileB      :  FileVar;
                    Var BVer,BRev  :  Integer;
                    Var BTyp       :  Char;
                        Mode       :  Byte)  :  Boolean;


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

  GetBtrvVer:=(Stat=0);

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
      TmpBo:=((Ver<=BCSVer) or (Typ<>BCSType))
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



{ =========== Unlock a Single Record from a Multi record Lock ======== }


Function UnLockMulTiSingCId(FileB   :  FileVar;
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

Function UnLockMulTiSing(FileB   :  FileVar;
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



Initialization
  GetMem (FileNames, SizeOf (FileNames^));

  Fn:=1;

  SetUpperALT;

  InitBVars;

   {$IFNDEF BCS}

    Chk4BCS:=BOn;

  {$ELSE}

    Chk4BCS:=BOff;

  {$ENDIF}

  SBSForm_Initialise;

Finalization
  FreeMem (FileNames, SizeOf (FileNames^));

  If (_SBSForm<>0) then
    FreeLibrary(_SBSForm);
end.
