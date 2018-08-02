//////////////////////////////////////////////
// Wrapper Unit for common Btrieve Routines //
//////////////////////////////////////////////
unit BTUTIL;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
//  APIUtil, SysUtils, Dialogs, uBtrv;
{$IFDEF EXSQL}
  SQLUtils,
{$ENDIF}
  StrUtil, APIUtil, SysUtils, Dialogs, BTConst;

const
  IDX_DUMMY_CHAR = '!';

  Function BTFullNomKey(ncode : Longint) : String20;
  Function BTUnFullNomKey(sString : string) : LongInt;
//  Function BTFullDoubleKey(ncode : Double) : String20;
  procedure BTShowError(iStatus : integer; sFunction, sFileName : string);
  Function BTMakeFile(Var FileB : TFileVar; FileName : TStr255; Var FileDef
  ; BufferLen : Word; ClientId : Pointer = nil) : Integer;
  function BTOpenFile(Var FileB : TFileVar; FileName : TStr255; Mode : Integer; ClientId : Pointer = nil; sOwnerName : string = '') : Integer;
  function BTCloseFile(Var FileB : TFileVar; ClientId : Pointer = nil) : Integer;
  function BTFindRecord(SearchType: integer; Var FileB : TFileVar; Var DataRec
  ; iBufferSize, iSearchIndex : word; var SKey: TStr255; ClientId : Pointer = nil): integer;
  Function BTUpdateRecord(Var FileB : TFileVar; Var DataRec; iBufferSize
  , iKeyNum : Word; var sKey : TStr255; ClientId : Pointer = nil) : Integer;
//  Function BTAddRecord(Var FileB : TFileVar; Var DataRec; iBufferSize
//  , iKeyNum : Integer; var sKey : TStr255) : Integer;
  Function BTAddRecord(Var FileB : TFileVar; Var DataRec; iBufferSize
  , iKeyNum : Word; ClientId : Pointer = nil) : Integer;
  Function BTDeleteRecord(Var FileB : TFileVar; Var DataRec; iBufferSize
  , iKeyNum : Word; ClientId : Pointer = nil) : Integer;
  Function BTKeyPos (Const OfsField, OfsRec : Pointer) : Word;
  Function BTGetPos(Var FileB : TFileVar; FileNum : Integer; iBufferSize : Word; Var Posn : LongInt) : Integer;
  Function BTGetDirect(Var FileB : TFileVar; FileNum : Integer; Var DataRec; iBufferSize : word; CurrKeyNum, LockCode : Integer) : Integer;
  Function BTGetPosition(Var FileB : TFileVar; FileNum : Integer; iBufferSize : Word; Var Posn : LongInt) : Integer;
  Function BTRestorePosition(Var FileB : TFileVar; FileNum : Integer; Var DataRec; iBufferSize : word; CurrKeyNum, LockCode : Integer; iRecPos : LongInt) : Integer;
  Function BTPadStrField(sValue : string; iSize : integer) : String;
  Procedure BTPrimeClientIdRec(Var CIdRec : TClientIdRec; AId : String2; TId : SmallInt);
  Function BTSetOwnerName(Var FileB : TFileVar; sOwnerName : string; AccessMode : Integer; ClientId : Pointer = nil) : Integer;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
const
  {$IFDEF EXSQL}
    {$IFDEF EXBTRVPLUGIN}
      BTDLLPath  =  'BTRVSQLDual.DLL';
    {$ELSE}
      BTDLLPath  =  'BTRVSQL.DLL';
    {$ENDIF}
  {$ELSE}
  BTDLLPath  =  'WBTRV32.DLL';
  {$ENDIF}

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

Function Btrv (   Operation   : Word ;
              var PositionBlock,
                  DataBuffer;
//              var DataLen     : Integer;
              var DataLen     : word;
              var KeyBuffer;
                  KeyNumber   : Integer;
                  ClientId    : Pointer): Integer;
Var
  KeyLen :  Byte;
//  mbret,
  DataL  :  Word;
Begin
  FillChar(Result,0,Sizeof(Result));
  KeyLen:= 255;                       {maximum key length}
//showmessage(IntToStr(DataLen));
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

Function BTFullNomKey(ncode : Longint) : String20;
Var
  TmpStr  :  String20;
Begin
  FillChar(TmpStr,Sizeof(TmpStr),0);
  Move(ncode,TmpStr[1],Sizeof(ncode));
  TmpStr[0] := Chr(Sizeof(ncode));
  Result := TmpStr;
end;

Function BTUnFullNomKey(sString : string) : LongInt;
Begin
  Result := 0;
  Move(sString[1],Result,Sizeof(result));
end;
{
Function BTFullDoubleKey(ncode : Double) : String20;
Var
  TmpStr  :  String20;
Begin
  FillChar(TmpStr,Sizeof(TmpStr),0);
  Move(ncode,TmpStr[1],Sizeof(ncode));
  TmpStr[0] := Chr(Sizeof(ncode));
  Result := TmpStr;
end;
}
(*
Function UseLocalOverride : Boolean;

Var
  Ver, Rev   :  Integer;
  Typ        :  Char;
  TmpBo      :  Boolean;
  DumBlock   :  TFileVar;
Begin
  FillChar(DumBlock,Sizeof(DumBlock),0);
  If (Checked4SA=0) then
  Begin
    TmpBo:=GetBtrvVer(DumBlock,Ver,Rev,Typ,1);
    If (TmpBo) then
    Begin
      {Check for forced modes if there is a v7 or greater requestor installed, }
      Checked4SA:=1+Ord((Ver>6));
    end;{if}
  end;{if}
  Result:=(Checked4SA=2);
end;
*)
procedure BTShowError(iStatus : integer; sFunction, sFileName : string);
begin
  if iStatus <> 0 then begin
    {$IFDEF EXSQL}
      MsgBox('Database Error ' + IntToStr(iStatus) + ' occurred whilst executing the command '
      + QuotedStr(sFunction) + ' on the file ' + QuotedStr(sFileName)
      , mtError, [mbOK], mbOK, 'Database Error');
    {$ELSE}
      MsgBox('Btrieve Error ' + IntToStr(iStatus) + ' occurred whilst executing the command '
      + QuotedStr(sFunction) + ' on the file ' + QuotedStr(sFileName)
      , mtError, [mbOK], mbOK, 'Btrieve Error');
    {$ENDIF}
  end;
end;

Function BTMakeFile(Var FileB : TFileVar; FileName : TStr255; var FileDef
; BufferLen : Word; ClientId : Pointer = nil) : Integer;
var
  Mode  :  Integer;
Begin{MakeFile}
  Mode:=0;
{  If (UseLocalOverride) then
  Begin
    If (BTForceCSEngine) then Mode:=99
    else begin
      If (BTForceLocalEngine) then Mode:=6;
    end;{if}
{  end;{if}

  FillChar(FileName[Length(FileName)+1],255-Length(FileName),0);
  Result := Btrv(B_Create,FileB,FileDef,BufferLen,FileName[1],Mode,ClientID);
end;{MakeFile}

(*
Function BTOpenFile(Var FileB : TFileVar; FileName : TStr255; Mode : Integer; ClientId : Pointer = nil) : Integer;
Var
  OpenMode, OwnerLen  :  Word;
  OwnerNam  :  String[128];
//  mbret     :  word;
//  InitStr   :  Array[0..254] of Char;
Begin{BTOpenFile}
  FillChar(OwnerNam,Sizeof(OwnerNam),0);

  {$IFDEF EX600}
    OwnerNam := 'V600';
  {$ENDIF}

{ If (Assigned(OWnerName)) then {*Ex431}
{ Begin
    If (OwnerName^<>'') then OwnerNam:=OwnerName^;
  end;}

  OpenMode:=Mode;

{  If (UseLocalOverride) then
  Begin
    If (BTForceCSEngine) then OpenMode:=99+ABS(Mode)
    else begin
      If (BTForceLocalEngine) then OpenMode:=6+ABS(Mode);
    end;{if}
{  end;{if}

  OwnerLen:=Length(OwnerNam)+1;
  FillChar(FileName[Length(FileName)+1],255-Length(FileName),0);
  FillChar(OwnerNam[Length(OwnerNam)+1],128-Length(OwnerNam),0);
  Result := Btrv(B_Open,FileB,OwnerNam[1],OwnerLen,FileName[1],OpenMode, ClientId);
end;{BTOpenFile}
*)

Function BTOpenFile(Var FileB : TFileVar; FileName : TStr255; Mode : Integer; ClientId : Pointer = nil; sOwnerName : string = '') : Integer;
Var
  OpenMode, OwnerLen  :  Word;
  OwnerNam  :  String[128];
//  mbret     :  word;
//  InitStr   :  Array[0..254] of Char;
Begin{BTOpenFile}
  FillChar(OwnerNam,Sizeof(OwnerNam),0);

  // NF: 29/10/2008
  If (sOwnerName <> '') then OwnerNam := sOwnerName;

  OpenMode:=Mode;

{  If (UseLocalOverride) then
  Begin
    If (BTForceCSEngine) then OpenMode:=99+ABS(Mode)
    else begin
      If (BTForceLocalEngine) then OpenMode:=6+ABS(Mode);
    end;{if}
{  end;{if}

  OwnerLen:=Length(OwnerNam)+1;
  FillChar(FileName[Length(FileName)+1],255-Length(FileName),0);
  FillChar(OwnerNam[Length(OwnerNam)+1],128-Length(OwnerNam),0);
  Result := Btrv(B_Open,FileB,OwnerNam[1],OwnerLen,FileName[1],OpenMode, ClientId);
end;{BTOpenFile}



function BTCloseFile(var FileB : TFileVar; ClientId : Pointer = nil) : integer;
var
  iDumKeyNum, iDumRecLen : Word;
  aDumDataRec : array[1..2] of char;
  sDumKey : string[1];
begin
  FillChar(aDumDataRec,Sizeof(aDumDataRec),#0);
  FillChar(sDumKey,Sizeof(sDumKey),#0);
  iDumKeyNum := 0;
  Result := Btrv(B_Close, FileB, aDumDataRec, iDumRecLen, sDumKey[1], iDumKeyNum, ClientId);
end;

(*
Function BTFindRecord(SearchType : Integer;
                     Var  FileB      : TFileVar;
                          FileNum,
                          C          : Integer;
                     Var  DataRec;
                          CurKeyNum  : Integer;
                     Var  Key        : TStr255;
                          ClientId   : Pointer): Integer;
Begin
  Fillchar(Key[Length(Key)+1],255-Length(Key),0);    { Strip Length Byte, & Fill with Blanks }
  Find_VarRec:=Btrv(SearchType,FileB,DataRec,C,Key[1],CurKeyNum,ClientId);
  Move(Key[1],CurIndKey[FileNum][1],255);             { Set CurIndKey[FileNum][1] to Key Returned }
  C:=255;

  While (Key[c]=#0) and (C>0)
  do C:=Pred(C);

  Key[0]:=Chr(C);                                        { Re-Build Turbo type string with length byte at beggining }
  SetThreadKeypath(FileNum,CurKeyNum,ClientId);
end;
*)

//function BTFindRecord(SearchType: integer; Var FileB : TFileVar; Var DataRec; iBufferSize, iSearchIndex : word; var SKey: TStr255): integer;
function BTFindRecord(SearchType: integer; Var FileB : TFileVar; Var DataRec; iBufferSize
, iSearchIndex : word; var SKey: TStr255; ClientId : Pointer = nil): integer;
var
  C : integer;
begin
  Fillchar(SKey[Length(SKey)+1],255-Length(SKey),0);    { Strip Length Byte, & Fill with Blanks (fixes no ALTCOLSEQ problems}
  Result:= Btrv(SearchType, FileB, DataRec, iBufferSize, SKey[1], iSearchIndex, ClientId);

  C:=255;
  While (SKey[c]=#0) and (C>0) do C:=Pred(C);
  SKey[0]:=Chr(C);                                        { Re-Build Turbo type string with length byte at beggining }
end;

//Function BTUpdateRecord(Var FileB : TFileVar; Var DataRec; iBufferSize, iKeyNum : Word; var sKey : TStr255) : Integer;
Function BTUpdateRecord(Var FileB : TFileVar; Var DataRec; iBufferSize, iKeyNum : Word; var sKey : TStr255; ClientId : Pointer = nil) : Integer;
begin
  Result := Btrv(B_Update, FileB, DataRec, iBufferSize, sKey[1], iKeyNum, ClientId);
end;

Function BTAddRecord(Var FileB : TFileVar; Var DataRec; iBufferSize, iKeyNum : Word; ClientId : Pointer = nil) : Integer;
var
  sKey : TStr255;
begin
  FillChar(sKey,Sizeof(sKey),#0);
  Result := Btrv(B_Insert, FileB, DataRec, iBufferSize, sKey[1], iKeyNum, ClientId);
end;{if}

Function BTDeleteRecord(Var FileB : TFileVar; Var DataRec; iBufferSize, iKeyNum : Word; ClientId : Pointer = nil) : Integer;
var
  sKey : TStr255;
begin
  FillChar(sKey,Sizeof(sKey),#0);
  Result := Btrv(4, FileB, DataRec, iBufferSize, sKey[1], iKeyNum, ClientId);

{  DumRecLen:=FileRecLen[FileNum];

  Tries:=0;

  Repeat
    Trans:=Btrv(22,FileB,DumRec,DumRecLen,DumKey[1],CurrKeyNum,ClientId);
    If Trans=0 then

    DumRecLen:=FileRecLen[FileNum];


    Trans:=Btrv(23,FileB,DumRec,DumRecLen,CurIndKey[FileNum][1],CurrKeyNum,nil);
    If Trans=0 then

    Trans:=Btrv(4,FileB,DumRec,DumRecLen,CurIndKey[FileNum][1],CurrKeyNum,nil);

    Inc(Tries);
  Until (Not (Trans In [84,85])) or (Tries>TryMax);


  Delete_RecCId:=Trans;

  Result := Btrv(4,FileB, DumRec, DumRecLen, CurIndKey[FileNum][1], CurrKeyNum, nil);}
end;

{ Function to return position of field within a record }
Function BTKeyPos (Const OfsField, OfsRec : Pointer) : Word;
Var
  OfR, OfF : LongInt;
Begin { BKeyPos }
  {Required for windows}
  OfR := LongInt(OfsRec);
  OfF := LongInt(OfsField);

  If (OfF > OfR) Then
    BtKeyPos := (OfF - OfR) + 1
  Else
    BtKeyPos := 1;
End;  { BKeyPos }

Function BTGetPos(Var FileB : TFileVar; FileNum : Integer; iBufferSize : Word; Var Posn : LongInt) : Integer;
Var
  DumKeyNum  :  Integer;
  DumKey : TStr255;
Begin
  DumKeyNum:=0;
  Result := Btrv(22,FileB,Posn,iBufferSize,DumKey[1],DumKeyNum,nil);
end;

Function BTGetDirect(Var FileB : TFileVar; FileNum : Integer; Var DataRec; iBufferSize : word; CurrKeyNum, LockCode : Integer) : Integer;
Var
  DumKey  :  TStr255;
Begin
  Result := Btrv(23+LockCode,FileB,DataRec,iBufferSize,DumKey[1],CurrKeyNum,nil);
//  SetThreadKeypath(FileNum,CurrKeyNum,ClientId);
end;

Function BTGetPosition(Var FileB : TFileVar; FileNum : Integer; iBufferSize : Word; Var Posn : LongInt) : Integer;
begin
  Result := BTGetPos(FileB, FileNum, iBufferSize, Posn);
end;

Function BTRestorePosition(Var FileB : TFileVar; FileNum : Integer; Var DataRec; iBufferSize : word; CurrKeyNum, LockCode : Integer; iRecPos : LongInt) : Integer;
begin
  Move(iRecPos, DataRec, sizeof(iRecPos));
  Result := BTGetDirect(FileB, FileNum, DataRec, iBufferSize, CurrKeyNum, LockCode);
end;

Function BTPadStrField(sValue : string; iSize : integer) : String;
begin
  Result := PadString(psRight, Trim(sValue), ' ', iSize-1);
end;

Procedure BTPrimeClientIdRec(Var CIdRec : TClientIdRec; AId : String2; TId : SmallInt);
begin
  FillChar(CIDRec,Sizeof(CIdRec),0);
  with CIDRec do
  begin
    APPId[1]:=AId[1];
    APPId[2]:=AId[2];
    TaskId:=TId;
  end;{with}
end;

Function BTSetOwnerName(Var FileB : TFileVar; sOwnerName : string; AccessMode : Integer; ClientId : Pointer = nil) : Integer;
Var
  OwnerLen : Word;
  OwnerNam : String[128];
//  mbret     :  word;
//  InitStr   :  Array[0..254] of Char;
Begin{BTOpenFile}
  FillChar(OwnerNam,Sizeof(OwnerNam),0);
  OwnerNam := SOwnerName;
  OwnerLen:=Length(OwnerNam);
  Result := Btrv(B_Owner, FileB, OwnerNam[1], OwnerLen, OwnerNam[1], AccessMode, ClientId);
end;{BTSetOwnerName}



end.
