unit oBtrieveFile;

{$ALIGN 1}

interface

Uses Classes, Dialogs, SysUtils;

Const
  v571Owner = 'V431';
  v600Owner = 'V600';

Type
  AltColtSeq  = Record
    SigByte     :  Char;
    Header      :  array[1..8] of Char;
    AltColtChars:  array[0..255] of Char;
  end;

  ClientIdType = Record
    Reserved  :  Array[1..12] of Byte;
    AppId     :  Array[1..2] of Char;
    TaskId    :  SmallInt;
  End;

  FileStatSpec = Record
    RecLen,
    PageSize  :  SmallInt;
    NumIndex  :  Byte;
    FileVer   :  Byte;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
  End; // FileStatSpec

  // Btrieve Key Segment Specification record
  KeySpec = Record
    KeyPos,
    KeyLen,
    KeyFlags         :  SmallInt;
    NotUsed          :  LongInt;
    ExtTypeVal       :  Byte;
    NullValue        :  Byte;
    Reserved         :  Array[1..4] of Char;
  end;

  KeySpecArray = Array[1..119] of KeySpec;
  pKeySpecArray= ^KeySpecArray;

  FileVar = array[1..128] of char;

  Str255 = String[255];

  TFileOpenStatus = (fsClosed=0, fsOpen=1);

  //------------------------------

  TBtrieveIndexSegmentInfo = Class(TObject)
  Private
    FSpec : KeySpec;
    FIndex : SmallInt;
    FIndexSegment : SmallInt;
    FOverlaps : ShortString;

    Function GetAltColSeq : Boolean;
    Function GetDataType : ShortString;
    Function GetIndex : SmallInt;
    Procedure SetIndex (Value : SmallInt);
    Function GetIndexSegment : SmallInt;
    Procedure SetIndexSegment (Value : SmallInt);
    Function GetLength : LongInt;
    Function GetOverlaps : ShortString;
    Procedure SetOverlaps (Value : ShortString);
    Function GetPosition : LongInt;
  Public
    Property isAltColSeq : Boolean Read GetAltColSeq;
    Property isDataType : ShortString Read GetDataType;
    Property isIndex : SmallInt Read GetIndex Write SetIndex;
    Property isIndexSegment : SmallInt Read GetIndexSegment Write SetIndexSegment;
    Property isLength : LongInt Read GetLength;
    Property isOverlaps : ShortString Read GetOverlaps Write SetOverlaps;
    Property isPosition : LongInt Read GetPosition;

    Constructor Create (Const SegSpec: KeySpec);
  End; // TBtrieveIndexSegmentInfo

  //------------------------------

  TBaseBtrieveFile = Class(TObject)
  Private
    FClientId : ^ClientIdType;
    FClientIdAllocated : Boolean;

    //PR: 14/02/2014 ABSEXCH-15038 Added ClientId property to enable transaction
    function GetClientId: Pointer;
  Protected
    FDataRec     : Pointer;
    FDataRecLen  : LongInt;
    FDataFile    : Pointer;
    FDataFileLen : LongInt;
    FFileVar     : FileVar;
    FSearchKey   : ShortString;

    FFilePath      : ShortString;      // Path to directory containing
    FFileStatus    : TFileOpenStatus;  // Open/Closed status
    FIndex         : SmallInt;         // Current Index
    FLockCount     : SmallInt;         // Number of record locks
    FLockPosition  : LongInt;          // Last Lock Position

    FKeySegments   : TList;

    FBypassOpenCompany : Boolean;      // Don't call OpenCompany when OpenFile is called

    Procedure ClearKeySegments;
    Procedure CheckForOverlaps;

    Function GetFilePath : ShortString;
    Procedure SetFilePath (Value : ShortString);
    Function GetStatus : TFileOpenStatus;

    Function GetPositionProperty : LongInt;
    Function GetPosition(Var RecAddr : LongInt) : SmallInt;
    Function RestorePosition (Const RecAddr : LongInt; Const LockCode : SmallInt = 0) : SmallInt;

    // Cancels an update freeing the record lock
    Procedure Cancel;

    // Protected functionality for descendants -------------------------------

    Procedure ChangeIndex(Const NewIndex : Byte);

    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Virtual;

    Function FindRec(BFunc : SmallInt; Var SearchKey : Str255) : SmallInt;

    // Locks the current record in the global file using the client ID
    // Wrapper around Find_RecCID
    function Lock : Integer;
    function LockDetails(Const RecPos : LongInt) : LongInt;

    // Property Get/Set methods
    Function GetKeySegmentCount : Integer;
    Function GetKeySegments (Index:Byte) : TBtrieveIndexSegmentInfo;
  Public
    Property DataRecLen : LongInt Read FDataRecLen Write FDataRecLen;
    Property FilePath : ShortString Read GetFilePath Write SetFilePath;

    Property KeySegments [Index:Byte] : TBtrieveIndexSegmentInfo Read GetKeySegments;
    Property KeySegmentCount : Integer Read GetKeySegmentCount;

    Property Position : LongInt Read GetPositionProperty;

    Property SearchKey : ShortString Read FSearchKey;

    Property BypassOpenCompany : Boolean Read FBypassOpenCompany Write FBypassOpenCompany;

    //PR: 14/02/2014 ABSEXCH-15038 Added ClientId property to enable transaction
    Property ClientID : Pointer read GetClientId;

    Constructor Create (ClientId : Byte = 0);
    Destructor Destroy; Override;

    // Public: Opens the data file returning an status code:-
    //
    //  0        AOK
    //  1-9999   Btrieve Error opening data file
    //  10001    Btrieve Not Available
    Function OpenFile (Const OpenFilePath : ShortString = ''; Const CreateIfMissing : Boolean = False; Const OwnerName : ShortString = ''; Const Mode : SmallInt = 0) : LongInt;

    // Public: Closes the data file, returns 0 if successful
    Function CloseFile : LongInt;

    // Btrieve Methods
    function  GetFirst: Integer;
    function  GetPrevious: Integer;
    function  GetNext: Integer;
    function  GetLast: Integer;

    function  GetLessThan(const SearchKey: WideString): Integer;
    function  GetLessThanOrEqual(const SearchKey: WideString): Integer;
    function  GetEqual(const SearchKey: WideString): Integer;
    function  GetGreaterThan(const SearchKey: WideString): Integer;
    function  GetGreaterThanOrEqual(const SearchKey: WideString): Integer;

    function StepFirst: Integer;
    function StepNext: Integer;

    Function FileVersion : Byte;
    Function GetRecordCount : LongInt;
    Function GetRecordLength : LongInt;
    Procedure GetEngineVersion (Var Version, SubVersion : SmallInt; Var EngineType : Char; Const WantVer : Byte = 2);
    Function LoadKeySegs : Byte;

    Function ClearOwner : LongInt;
    Function SetOwner (Const NewOwner : ShortString; Const AccessMode : Byte) : LongInt;

    Function Delete : LongInt; Virtual;
    Function Insert : LongInt;
  End; // TBaseBtrieveFile

  Function FullNomKey (Const Folio : LongInt) : ShortString;

Var
  // Initialised Alternate Collating Sequence to copy when defining file structures
  UpperAlt : AltColtSeq;

implementation

Const
  TryMax  =  1000;

  B_Open     =  0;
  B_Close    =  1;
  B_Insert   =  2;
  B_Update   =  3;
  B_Delete   =  4;
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

  BT_GetFirst = B_GetFirst;
  BT_GetNext = B_GetNext;
  BT_GetGreater = B_GetGretr;
  BT_GetPrevious = B_GetPrev;
  BT_GetGreaterOrEqual = B_GetGEq;
  BT_GetLessOrEqual = B_GetLessEq;
  BT_GetEqual = B_GetEq;
  BT_GetLast = B_GetLast;

  BT_MaxDoubleKey = #124#59#119#48#209#66#238#127;
  BT_MinDoubleKey = #0#200#78#103#109#193#171#195;


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
//  BBfloat    =  09;
  BUnsigned  =  14;
  BBoolean   =  07;
  BFloat     =  02;  { Equivalent to Turbo Double }
  BTime      =  04;  {     "      "    "   Word   }

  DefPageSize = 1024;
  DefPageSize2= 1536;
  DefPageSize3= 2048;
  DefPageSize4= 2560;
  DefPageSize5= 3072;
  DefPageSize6= 3584;
  DefPageSize7= 4096;

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

  Modfy      = 2;
  Dup        = 1;
  AllowNull  = 8;
  ModSeg     = 18;
  DupSeg     = 17;
  DupMod     = 3;
  DupModSeg  = 19;

  IDX_DUMMY_CHAR = '!';

Type
  Str5 = String[5];
  Str10 = String[10];


Var
  ClientIds           : TBits;
  Checked4SA          : Byte;
  BTForceLocalEngine,
  BTForceCSEngine     : Boolean;

//=========================================================================

Function FullNomKey (Const Folio : LongInt) : ShortString;
Var
  sFolio : String[4];
Begin // FullNomKey
  sFolio := '1234';
  Move (Folio, sFolio[1], SizeOf(Folio));
  Result := sFolio;
End; // FullNomKey

//=========================================================================

FUNCTION BTRCALL(
                 operation : WORD;
             VAR posblk;
             VAR databuf;
             VAR datalen   : WORD;
             VAR keybuf;
                 keylen    : BYTE;
                 keynum    : Integer
                 ) : SmallInt; FAR; StdCall;
                 external 'WBTRV32.DLL' name 'BTRCALL';

FUNCTION BTRCALLID(
                 operation : WORD;
             VAR posblk;
             VAR databuf;
             VAR datalen   : WORD;
             VAR keybuf;
                 keylen    : BYTE;
                 keynum    : Integer;
             Var clientid     ) : SmallInt; FAR; StdCall;
                 external 'WBTRV32.DLL' name 'BTRCALLID';

//-------------------------------------------------------------------------

Procedure SetUpperAlt;
Var
  Loop  :  Integer;
Begin // SetUpperAlt
  With UpperALT do
  Begin
    SigByte:=Chr($AC);
    Header:='UPPERALT';

    For Loop:=0 to 255 do
      AltColtChars[Loop]:=Upcase(Chr(Loop));
  end; {With..}
End; // SetUpperAlt

//-------------------------------------------------------------------------

Function Btrv (   Operation   : Word ;
              var PositionBlock,
                  DataBuffer;
              var DataLen     : Integer;
              var KeyBuffer;
                  KeyNumber   : Integer;
                  ClientId    : Pointer): Integer;
Var
  KeyLen :  Byte;
  DataL  :  Word;
Begin
  FillChar(Result,0,Sizeof(Result));

  KeyLen:= 255;                       {maximum key length}
  DataL:=DataLen;

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
End; {Btrv}

//-------------------------------------------------------------------------

Function GetBtrvStat(   FileB      :  FileVar;
                    Var BVer,BRev  :  Integer;
                    Var BTyp       :  Char;
                        Mode       :  Byte)  :  Integer;
Var
  Stat,DumLen,DumKeyNum  :  Integer;
  DumKey                 :  Str255;

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

//  If (AccelMode) then
//    ShowAcc:='AC'
//  else
//    ShowAcc:='';

  Stat:=Btrv(26,FileB,DumRec,DumLen,DumKey,DumKeyNum,nil);

  GetBtrvStat:=Stat;

//  If (Debug) then
//    With DumRec do
//    Begin
//      {Gotoxy(1,25); Write('*** Ver ',Ver:1,'.',Rev:1,' Type :',Typ,'<',ShowAcc);}
//    end;

  If (Stat = 0) then
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
      End; // Case Mode
    End; // With DumRec
end;


{ ======== Function To Check for Btrieve Presence by Requesting Version No. ======= }
Function GetBtrvVer(    FileB      :  FileVar;
                    Var BVer,BRev  :  Integer;
                    Var BTyp       :  Char;
                        Mode       :  Byte)  :  Boolean;
Var
  Stat : Integer;
Begin // GetBtrvVer
  Stat:=GetBtrvStat(FileB,BVer,BRev,BTyp,Mode);
  GetBtrvVer:=(Stat=0);
end; // GetBtrvVer

//-------------------------------------------------------------------------

{ == Function to check if we can see a server engine, if not ignore open modes == }
Function UseLocalOverride : Boolean;
Var
  Rev, Ver   :  Integer;
  Typ        :  Char;
  TmpBo      :  Boolean;
  DumBlock   :  FileVar;
Begin // UseLocalOverride
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
End; // UseLocalOverride

//-------------------------------------------------------------------------

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

//-------------------------------------------------------------------------

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

//-------------------------------------------------------------------------

Function Open_FileCId(Var   FileB     :  FileVar;
                            FileName  :  Str255;
                            Mode      :  Integer;
                            ClientId  :  Pointer;
                      Const OwnerName : ShortString)  :  Integer;
Var
  OwnerLen  :  Integer;
  OwnerNam  :  String[128];
  OpenMode  :  Integer;
Begin
  FillChar(OwnerNam,Sizeof(OwnerNam),0);

  If (OwnerName<>'') then
    OwnerNam:=OwnerName;

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

//-------------------------------------------------------------------------

Function File_StatCId(Var   FileB    :  FileVar;
                             ClientId :  Pointer;
                       Var   RecCnt   :  LongInt;
                       Var   FileBVer :  Byte;
                       Const KeySegs  : pKeySpecArray = NIL) : SmallInt;
Var
  FBT                       :  Byte;
  Stat,DumRecLen,DumKeyNum  :  Integer;
  NumRec                    :  LongInt;
  KeyBuff                   :  Str255;
  DatBuf                    :  record
                                 FS                      :  FileStatSpec;
                                 Ks                      :  KeySpecArray;
                                 AltColt                 :  AltColtSeq;
                               end;
Begin // File_StatCId
  FillChar(DatBuf, SizeOf(DatBuf), #0);
  DumRecLen:=SizeOf(DatBuf);
  DumKeyNum:=-1;

  Stat:=Btrv(15,FileB,DatBuf,DumRecLen,KeyBuff[1],DumKeyNum,ClientId);

  If (Stat=0) Then
  Begin
    NumRec:=DatBuf.Fs.NotUsed;
    FBT:=DatBuf.Fs.FileVer;

    If Assigned(KeySegs) Then
      Move (DatBuf.KS, KeySegs^, SizeOf(KeySpecArray));
  End // If (Stat=0)
  Else
  Begin
    NumRec:=0;
    FBT:=0;

    If Assigned(KeySegs) Then
      FillChar (KeySegs^, SizeOf(KeySpecArray), #0);
  End; // Else

  RecCnt:=NumRec;
  FileBVer:=FBT;
  Result := Stat;
End; // File_StatCId

//-------------------------------------------------------------------------

Function GetFileSpecCId(Var  FileB    : FileVar;
                        Var  FSpec    : FileStatSpec;
                             ClientId : Pointer) : LongInt;
Var
  DumRecLen,DumKeyNum  : Integer;
  KeyBuff              :  Str255;
  DatBuf               :  record
                            FS                      :  FileStatSpec;
                            Ks                      :  KeySpecArray;
                            AltColt                 :  AltColtSeq;
                          end;
Begin
  { HM 30/04/99: Added as it appears to fix a problem under Win98 reading the filespec }
  {              where the filespec is returning rubbish                               }
  FillChar (DatBuf, SizeOf(DatBuf), #0);
  DumRecLen:=SizeOf(DatBuf);
  DumKeyNum:=-1;


  Result := Btrv(15,FileB,DatBuf,DumRecLen,KeyBuff[1],DumKeyNum,ClientId);

  If (Result = 0) Then
  Begin
    FSpec := DatBuf.Fs;
  End
  Else
    FillChar(FSpec, SizeOf(FSpec), #0);
end;

//-------------------------------------------------------------------------

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

//=========================================================================

Constructor TBaseBtrieveFile.Create (ClientId : Byte = 0);
Begin // Create
  Inherited Create;

  If (ClientId = 0) Then
  Begin
    // Opens file in a new ClientId
    ClientId := 1 + ClientIds.OpenBit;
    ClientIds[ClientId - 1] := True;
    FClientIdAllocated := True;
  End // If (ClientId = 0)
  Else
    FClientIdAllocated := False;

  New(FClientId);
  Prime_ClientIdRec(FClientId^, 'CO', ClientId); // Changed to CO to avoid clash with Exchequer/COMTK (EX)

  FKeySegments := TList.Create;

  FBypassOpenCompany := False;

  // Descendants define the file structure in their own constructors after calling Inherited
End; // Create

//------------------------------

Destructor TBaseBtrieveFile.Destroy;
Begin // Destroy
  If Assigned(FKeySegments) Then ClearKeySegments;
  FreeAndNIL(FKeySegments);

  If (FFileStatus = fsOpen) Then
  Begin
    // Close Open file
    CloseFile;
  End; // If (FFileStatus = fsOpen)

  If FClientIdAllocated Then
  Begin
    ClientIds[FClientId.TaskId - 1] := False;
  End; // If FClientIdAllocated
  Dispose(FClientId);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TBaseBtrieveFile.ClearKeySegments;
Var
  oKeySeg : TBtrieveIndexSegmentInfo;
Begin // ClearKeySegments
  While (FKeySegments.Count > 0) Do
  Begin
    oKeySeg := TBtrieveIndexSegmentInfo(FKeySegments[0]);
    oKeySeg.Free;

    FKeySegments.Delete(0);
  End; // While (FKeySegments.Count > 0)
End; // ClearKeySegments

//-------------------------------------------------------------------------

// Public: Opens the data file returning an status code:-
//
//  0        AOK
//  1-9999   Btrieve Error opening data file
//  10001    Btrieve Not Available
Function TBaseBtrieveFile.OpenFile (Const OpenFilePath : ShortString = ''; Const CreateIfMissing : Boolean = False; Const OwnerName : ShortString = ''; Const Mode : SmallInt = 0) : LongInt;
Begin // OpenFile
  If Check4BtrvOK Then
  Begin
    If (OpenFilePath <> '') Then
      SetFilePath (OpenFilePath);

    If DirectoryExists (ExtractFilePath(FFilePath)) Then
    Begin
      Result := 0;

      If (Not FileExists (FFilePath)) And CreateIfMissing Then
      Begin
        // Create the data file
        Result := Make_FileCId(FFileVar, FFilePath, FDataFile^, FDataFileLen, FClientId);
      End; // If (Not FileExists (FFilePath)) And CreateIfMissing

      If (Result = 0) Then
      Begin
        If FileExists (FFilePath) Then
        Begin
          // Open the file
          Result := Open_FileCId (FFileVar, FFilePath, Mode, FClientId, OwnerName);
          If (Result = 0) Then
          Begin
            FFileStatus := fsOpen;
            FIndex := 0;
          End; // If (Result = 0)
        End // If FileExists (FFilePath)
        Else
          Result := 12; // File Not Found
      End // If (Result = 0)
    End // If DirectoryExists (ExtractFilePath(FFilePath))
    Else
      Result := 35; // Invalid Path
  End // If Check4BtrvOK
  Else
    Result := 10001;  // Btrieve Not Available
End; // OpenFile

//------------------------------

// Public: Closes the data file, returns 0 if successful
Function TBaseBtrieveFile.CloseFile : LongInt;
Var
  DumKeyNum, DumRecLen : Integer;
  DumDataRec           : Array [1..2] Of Char;
  DumKey               : String[1];
Begin // CloseFile
  FillChar(DumDataRec, Sizeof(DumDataRec), 0);
  FillChar(DumKey, Sizeof(DumKey), 0);
  DumKeyNum := 0;
  DumRecLen := 0;
  Result := Btrv(B_Close, FFileVar, DumDataRec, DumRecLen, DumKey[1], DumKeyNum, FClientId);

  FFileStatus := fsClosed;
End; // CloseFile

//-------------------------------------------------------------------------

Function TBaseBtrieveFile.FileVersion : Byte;
Var
  RecCnt   : LongInt;
  FileBVer : Byte;
Begin // FileVersion
  File_StatCId(FFileVar, FClientId, RecCnt, FileBVer);
  Result := FileBVer Div 16;  // Its in hex!  v1=16 v2=32 v3=48 v4=64 v5=80 v6=96 v7=112 v8=128 v9=144
End; // FileVersion

//-------------------------------------------------------------------------

Function TBaseBtrieveFile.GetRecordCount : LongInt;
Var
  RecCnt   : LongInt;
  FileBVer : Byte;
Begin // GetRecordCount
  File_StatCId(FFileVar, FClientId, RecCnt, FileBVer);
  Result := RecCnt;
End; // GetRecordCount

//-------------------------------------------------------------------------

// Returns the length of the record from the File Stat info
Function TBaseBtrieveFile.GetRecordLength : LongInt;
Var
  FileSpec : FileStatSpec;
  lStatus : LongInt;
Begin // GetRecordLength
  lStatus := GetFileSpecCId(FFileVar, FileSpec, FClientId);
  If (lStatus = 0) Then
    Result := FileSpec.RecLen
  Else
    Result := -1;
End; // GetRecordLength

//-------------------------------------------------------------------------

Procedure TBaseBtrieveFile.GetEngineVersion (Var Version, SubVersion : SmallInt; Var EngineType : Char; Const WantVer : Byte = 2);
Var
  lStatus : LongInt;
  BVer, BRev : Integer;
  BTyp : Char;
Begin // GetEngineVersion
  // CJS: 26/11/2007: This call was originally passing a hard-coded 2 instead
  // of using the WantVer parameter.
  lStatus := GetBtrvStat(FFileVar, BVer, BRev, BTyp, WantVer);
  //lStatus := GetBtrvStat(FFileVar, BVer, BRev, BTyp, 2);
  If (lStatus = 0) Then
  Begin
    Version := BVer;
    SubVersion := BRev;
    EngineType := BTyp;
  End // If (lStatus = 0)
  Else
  Begin
    Version := 0;
    SubVersion := 0;
    EngineType := ' ';
  End; // Else
End; // GetEngineVersion

//-------------------------------------------------------------------------

// Protected: Changes the current index to that specified, re-establishing
// position, etc...
Procedure TBaseBtrieveFile.ChangeIndex(Const NewIndex : Byte);
Var
  lCurrPos, lStatus  : LongInt;
Begin // ChangeIndex
  { Check value has changed }
  If (NewIndex <> FIndex) Then
  Begin
    // Get current record position}
    lStatus := GetPosition(lCurrPos);

    // Change Index
    FIndex := NewIndex;

    If (lStatus = 0) Then
    Begin
      // Restore position in file under new index
      RestorePosition(lCurrPos);
    End; // If (lStatus = 0)
  End; // If (NewIndex <> FIndex)
End; // ChangeIndex

//-------------------------------------------------------------------------

// Cancels an update freeing the record lock
Procedure TBaseBtrieveFile.Cancel;
Var
  DataBuffer    : Pointer;
  DataBufferLen : LongInt;
  DumKey        : Str255;
Begin // Cancel
  If (FLockCount > 0) Then
  Begin
    // Setup a new data buffer and put the record position in the 1st 4 bytes
    GetMem (DataBuffer, FDataRecLen);
    Try
      FillChar (DataBuffer^, FDataRecLen, #0);
      Move (FLockPosition, DataBuffer^, SizeOf(FLockPosition));
      DataBufferLen := SizeOf(FLockPosition);

      // Setup a blank key
      FillChar(DumKey,SizeOf(DumKey),0);

      // unlock the record
      {lRes := }Btrv(B_Unlock, FFileVar, DataBuffer^, DataBufferLen, DumKey[1], FIndex, FClientId);
    Finally
      FreeMem(DataBuffer, FDataRecLen);
    End; // Try..Finally

    FLockPosition := 0;
    Dec(FLockCount);
  End; // If (FLockCount > 0)
End; // Cancel

//-------------------------------------------------------------------------

Function TBaseBtrieveFile.Delete : LongInt;
Const
  MaxRecLen  =  4000;
Var
  DataBuffer                : Pointer;
  BufferLen, RecAddr, Tries : LongInt;
  CurIndKey                 : Str255;
Begin // Delete

//Function Delete_RecCId(Var  FileB     :  FileVar;
//                            FileNum   :  Integer;
//                            CurrKeyNum:  Integer;
//                            ClientId  :  Pointer) : Integer;


  Result := GetPosition(RecAddr);
  If (Result = 0) Then
  Begin
    GetMem (DataBuffer, FDataRecLen);
    Try
      FillChar (DataBuffer^, FDataRecLen, #0);
      Move (FDataRec^, RecAddr, SizeOf(RecAddr));
      BufferLen:=FDataRecLen;

      Fillchar(CurIndKey, Sizeof(CurIndKey), 0);

      Tries:=0;
      Repeat
        Result := Btrv(B_Delete, FFileVar, DataBuffer^, BufferLen, CurIndKey[1], FIndex, FClientId);
        Inc(Tries);
      Until (Not (Result In [84, 85])) or (Tries>TryMax);
    Finally
      FreeMem(DataBuffer, FDataRecLen);
    End; // Try..Finally
  End; // If (Result = 0)
End; // Delete

//-------------------------------------------------------------------------

Function TBaseBtrieveFile.Insert : LongInt;
Var
  CurIndKey  : Str255;
  Tries      : SmallInt;
Begin // Insert
  FillChar(CurIndKey,sizeof(CurIndKey),0);

  Tries:=0;
  Repeat
    Result := Btrv(B_Insert, FFileVar, FDataRec^, FDataRecLen, CurIndKey[1], FIndex, FClientId);
    Inc (Tries);
  Until (Not (Result In [84,85])) or (Tries > TryMax);
End; // Save

//-------------------------------------------------------------------------

Function TBaseBtrieveFile.GetPositionProperty : LongInt;
Begin // GetPositionProperty
  GetPosition(Result);
End; // GetPositionProperty

//------------------------------

Function TBaseBtrieveFile.GetPosition(Var RecAddr : LongInt) : SmallInt;
Var
  DumRecLen,DumKeyNum  :  Integer;
  DumKey               :  Str255;
Begin // GetPosition
  DumRecLen := SizeOf(RecAddr);
  DumKeyNum := 0;
  Result := Btrv(22, FFileVar, RecAddr, DumRecLen, DumKey[1], DumKeyNum, FClientId);
End; // GetPosition

//------------------------------

Function TBaseBtrieveFile.RestorePosition (Const RecAddr : LongInt; Const LockCode : SmallInt = 0) : SmallInt;
Var
  DumKey : Str255;
Begin // RestorePosition
  FillChar (FDataRec^, FDataRecLen, #0);
  Move (RecAddr, FDataRec^, SizeOf(RecAddr));

  Result := Btrv(23+LockCode, FFileVar, FDataRec^, FDataRecLen, DumKey[1], FIndex, FClientId);
  //SetThreadKeypath(FileNum,CurrKeyNum,ClientId);
End; // RestorePosition

//-------------------------------------------------------------------------

// Locks the current record in the global file using the client ID
function TBaseBtrieveFile.Lock : Integer;
begin
  // Save Record Position into LockPos so we can later use it for unlocking
  Result := GetPosition (FLockPosition);
  If (Result = 0) Then
  Begin
    // Reread and lock record
    Result := RestorePosition (FLockPosition, B_SingLock + B_SingNWLock);
    If (Result = 0) Then
      // Record Locked
      Inc (FLockCount)
    Else
      // Error
      Inc (Result, 31000);
  End // If (Result = 0)
  Else
    // Error getting current record position
    Inc (Result, 30000);
end;

//------------------------------

function TBaseBtrieveFile.LockDetails(Const RecPos : LongInt) : LongInt;
Begin // LockDetails
  // Get and Lock Current Record
  Result := RestorePosition(RecPos);
  If (Result = 0) Then
  Begin
    Result := Lock;
    If (Result <> 0) Then Inc (Result, 30000);
  End; // If (Result = 0)
End; // LockDetails

//-------------------------------------------------------------------------

Function TBaseBtrieveFile.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String) : Integer;
Begin // GetDataRecord
  FSearchKey := SearchKey;
  Result := FindRec (BtrOp, FSearchKey);
End; // GetDataRecord

//-------------------------------------------------------------------------

Function TBaseBtrieveFile.FindRec(BFunc : SmallInt; Var SearchKey : Str255) : SmallInt;
Var
  C : Integer;
Begin // FindRec
  // Strip Length Byte, & Fill with Blanks
  Fillchar(SearchKey[Length(SearchKey)+1], 255-Length(SearchKey), 0);

  Result := Btrv(BFunc, FFileVar, FDataRec^, FDataRecLen, SearchKey[1], FIndex, FClientId);

  //Move(SearchKey[1],CurIndKey[FileNum][1],255);             { Set CurIndKey[FileNum][1] to Key Returned }

  C:=255;
  While (SearchKey[c]=#0) and (C>0) do
    C:=Pred(C);

  SearchKey[0]:=Chr(C);                                        { Re-Build Turbo type string with length byte at beggining }

//  SetThreadKeypath(FileNum,CurKeyNum,ClientId);
End; // FindRec

//-------------------------------------------------------------------------

Function TBaseBtrieveFile.ClearOwner : LongInt;
Var
  TempBuffer    : Array [1..4096] Of Byte;
  TempBufferLen : Integer;
Begin // ClearOwner
  TempBufferLen := SizeOf(TempBuffer);
  FillChar(TempBuffer, TempBufferLen, 0);

  Result := Btrv(30, FFileVar, TempBuffer[1], TempBufferLen, TempBuffer[1], 0, FClientId);
End; // ClearOwner

//------------------------------

Function TBaseBtrieveFile.SetOwner (Const NewOwner : ShortString; Const AccessMode : Byte) : LongInt;
Var
  OwnerLen : Integer;
  OwnerNam : String[128];
Begin // SetOwner
  FillChar(OwnerNam,Sizeof(OwnerNam),0);
  OwnerNam := NewOwner;
  OwnerLen:=Length(OwnerNam);

  Result := Btrv(29, FFileVar, OwnerNam[1], OwnerLen, OwnerNam[1], AccessMode, FClientId);
End; // SetOwner

//-------------------------------------------------------------------------

function TBaseBtrieveFile.GetFirst: Integer;
Begin // GetFirst
  Result := GetDataRecord (B_GetFirst, FSearchKey);
End; // GetFirst

function TBaseBtrieveFile.GetPrevious: Integer;
Begin // GetPrevious
  Result := GetDataRecord (B_GetPrev, FSearchKey);
End; // GetPrevious

function TBaseBtrieveFile.GetNext: Integer;
Begin // GetNext
  Result := GetDataRecord (B_GetNext, FSearchKey);
End; // GetNext

function TBaseBtrieveFile.GetLast: Integer;
Begin // GetLast
  Result := GetDataRecord (B_GetLast, FSearchKey);
End; // GetLast

//------------------------------

function TBaseBtrieveFile.GetLessThan(const SearchKey: WideString): Integer;
begin
  Result := GetDataRecord (B_GetLess, SearchKey);
end;

function TBaseBtrieveFile.GetLessThanOrEqual(const SearchKey: WideString): Integer;
begin
  Result := GetDataRecord (B_GetLessEq, SearchKey);
end;

function TBaseBtrieveFile.GetEqual(const SearchKey: WideString): Integer;
begin
  Result := GetDataRecord (B_GetEq, SearchKey);
end;

function TBaseBtrieveFile.GetGreaterThan(const SearchKey: WideString): Integer;
begin
  Result := GetDataRecord (B_GetGretr, SearchKey);
end;

function TBaseBtrieveFile.GetGreaterThanOrEqual(const SearchKey: WideString): Integer;
begin
  Result := GetDataRecord (B_GetGEq, SearchKey);
end;

//-------------------------------------------------------------------------

function TBaseBtrieveFile.StepFirst: Integer;
Begin // StepFirst
  Result := GetDataRecord (B_StepFirst, FSearchKey);
End; // StepFirst

//------------------------------

function TBaseBtrieveFile.StepNext: Integer;
Begin // StepNext
  Result := GetDataRecord (B_StepNext, FSearchKey);
End; // StepNext

//-------------------------------------------------------------------------

Function TBaseBtrieveFile.GetFilePath : ShortString;
Begin // GetFilePath
  Result := FFilePath;
End; // GetFilePath
Procedure TBaseBtrieveFile.SetFilePath (Value : ShortString);
Begin // SetFilePath
  FFilePath := Value;
End; // SetFilePath

//------------------------------

Function TBaseBtrieveFile.GetStatus : TFileOpenStatus;
Begin // GetStatus
  Result := FFileStatus;
End; // GetStatus;

//-------------------------------------------------------------------------

Function TBaseBtrieveFile.GetKeySegmentCount : Integer;
Begin // GetKeySegmentCount
  Result := FKeySegments.Count;
End; // GetKeySegmentCount

//------------------------------

Function TBaseBtrieveFile.GetKeySegments (Index : Byte) : TBtrieveIndexSegmentInfo;
Begin // GetKeySegments
  If (Index < FKeySegments.Count) Then
    Result := TBtrieveIndexSegmentInfo(FKeySegments[Index])
  Else
    Raise Exception.Create ('TBaseBtrieveFile.GetKeySegments: Invalid Index (' + IntToStr(Index) + ')');
End; // GetKeySegments

//------------------------------

// Checks the current segment aginst all previous segments in the list for overlaps
Procedure TBaseBtrieveFile.CheckForOverlaps;
Var
  oThisSeg, oPrevSeg : TBtrieveIndexSegmentInfo;
  ThisSegStart, ThisSegEnd, PrevSegStart, PrevSegEnd : SmallInt;
  Overlaps : ShortString;
  ComparingSegment, SettingSegment : Byte;
Begin // CheckForOverlaps
  If (FKeySegments.Count > 0) Then
  Begin
    For SettingSegment := 0 To (FKeySegments.Count - 1) Do
    Begin
      oThisSeg := GetKeySegments (SettingSegment);
      ThisSegStart := oThisSeg.isPosition;
      ThisSegEnd := ThisSegStart + oThisSeg.isLength - 1;

      Overlaps := '';
      For ComparingSegment := 0 To (FKeySegments.Count - 1) Do
      Begin
        // Don't compare to self
        If (ComparingSegment <> SettingSegment) Then
        Begin
          oPrevSeg := GetKeySegments (ComparingSegment);
          PrevSegStart := oPrevSeg.isPosition;
          PrevSegEnd := PrevSegStart + oPrevSeg.isLength - 1;

          If ((ThisSegStart >= PrevSegStart) And (ThisSegStart <= PrevSegEnd)) Or
             ((ThisSegEnd >= PrevSegStart) And (ThisSegEnd <= PrevSegEnd)) Then
          Begin
            // Overlap
            If (oThisSeg.isPosition = oPrevSeg.isPosition) And
               (oThisSeg.isLength = oPrevSeg.isLength) And
               (oThisSeg.isDataType = oPrevSeg.isDataType) And
               (oThisSeg.isAltColSeq = oPrevSeg.isAltColSeq) Then
              Overlaps := Overlaps + '[='
            Else
              Overlaps := Overlaps + '[<>';

            Overlaps := Overlaps + IntToStr(oPrevSeg.isIndex) + '/' + IntToStr(oPrevSeg.isIndexSegment) + '] ';
          End; // If
        End; // If (ComparingSegment <> SettingSegment)
      End; // For I

      oThisSeg.isOverlaps := Overlaps;
    End; // For SettingSegment
  End; // If (FKeySegments.Count > 0)
End; // CheckForOverlaps

//------------------------------

// Loads the index segments into the KeySegments array, returns the number of segments
Function TBaseBtrieveFile.LoadKeySegs : Byte;
Var
  oSegInfo : TBtrieveIndexSegmentInfo;
  I, Index, IndexSegment : Byte;

  DatBuf               : Record
                           FileSpec : FileStatSpec;
                           KeySpecs : KeySpecArray;
                           AltColt  : AltColtSeq;
                         End;  // DatBuf
  KeyBuff              :  Str255;
  DumRecLen, DumKeyNum : Integer;
  iStatus : SmallInt;
Begin // LoadKeySegs
  ClearKeySegments;

  FillChar(DatBuf, SizeOf(DatBuf), #0);
  DumRecLen:=SizeOf(DatBuf);
  DumKeyNum:=-1;

  iStatus := Btrv(15, FFileVar, DatBuf, DumRecLen, KeyBuff[1], DumKeyNum, FClientId);

  If (iStatus = 0) Then
  Begin
    Index := 0;
    IndexSegment := 1;
    For I := Low(DatBuf.KeySpecs) To High(DatBuf.KeySpecs) Do
    Begin
      With DatBuf.KeySpecs[I] Do
      Begin
        oSegInfo := TBtrieveIndexSegmentInfo.Create(DatBuf.KeySpecs[I]);
        oSegInfo.isIndex := Index;
        oSegInfo.isIndexSegment := IndexSegment;

        If ((KeyFlags And 16) = 0) Then
        Begin
          Inc (Index);
          IndexSegment := 1;
        End // If ((KeyFlags And 16) = 16)
        Else
          Inc(IndexSegment);
      End; // With DatBuf.KeySpecs[I]

      If (Index > DatBuf.FileSpec.NumIndex) Then
      Begin
        FreeAndNIL(oSegInfo);
        Break
      End // If (Index > DatBuf.FileSpec.NumIndex)
      Else
        FKeySegments.Add(oSegInfo);
    End; // For I

    CheckForOverlaps;
    Result := FKeySegments.Count;
  End // If (iStatus = 0)
  Else
    Result := 0;
End; // LoadKeySegs

//=========================================================================

Constructor TBtrieveIndexSegmentInfo.Create (Const SegSpec: KeySpec);
Begin // ImportDetails
  Inherited Create;
  FSpec := SegSpec;
End; // ImportDetails

//-------------------------------------------------------------------------

Function TBtrieveIndexSegmentInfo.GetAltColSeq : Boolean;
Begin // GetAltColSeq
  Result := ((FSpec.KeyFlags And 32) = 32);
End; // GetAltColSeq

//------------------------------

Function TBtrieveIndexSegmentInfo.GetDataType : ShortString;
Begin // GetDataType
  If (FSpec.ExtTypeVal = 0) Then
    Result := 'String'
  Else If (FSpec.ExtTypeVal = 1) Then
    Result := 'Integer'
  Else If (FSpec.ExtTypeVal = 7) Then
    Result := 'Boolean'
  Else
    Result := IntToStr(FSpec.ExtTypeVal) + '?';
End; // GetDataType

//------------------------------

Function TBtrieveIndexSegmentInfo.GetIndex : SmallInt;
Begin // GetIndex
  Result := FIndex;
End; // GetIndex
Procedure TBtrieveIndexSegmentInfo.SetIndex (Value : SmallInt);
Begin // SetIndex
  FIndex := Value;
End; // SetIndex

//------------------------------

Function TBtrieveIndexSegmentInfo.GetIndexSegment : SmallInt;
Begin // GetIndexSegment
  Result := FIndexSegment;
End; // GetIndexSegment
Procedure TBtrieveIndexSegmentInfo.SetIndexSegment (Value : SmallInt);
Begin // SetIndexSegment
  FIndexSegment := Value;
End; // SetIndexSegment

//------------------------------

Function TBtrieveIndexSegmentInfo.GetLength : LongInt;
Begin // GetLength
  Result := FSpec.KeyLen;
End; // GetLength

//------------------------------

Function TBtrieveIndexSegmentInfo.GetOverlaps : ShortString;
Begin // GetOverlaps
  Result := FOverlaps;
End; // GetOverlaps
Procedure TBtrieveIndexSegmentInfo.SetOverlaps (Value : ShortString);
Begin // SetOverlaps
  FOverlaps := Value;
End; // SetOverlaps

//------------------------------

Function TBtrieveIndexSegmentInfo.GetPosition : LongInt;
Begin // GetPosition
  Result := FSpec.KeyPos;
End; // GetPosition

//=========================================================================

//PR: 14/02/2014 ABSEXCH-15038 Added ClientId property to enable transaction
function TBaseBtrieveFile.GetClientId: Pointer;
begin
  Result := FClientId;
end;

Initialization
  ClientIds := TBits.Create;
  ClientIds[0] := True;  // Reserved for Conv600.Dat

  SetUpperAlt;
Finalization
  FreeAndNIL(ClientIds);
end.
