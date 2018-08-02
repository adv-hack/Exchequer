unit gs6_memo;
{-----------------------------------------------------------------------------
                    dBase III/IV & FoxPro Memo File Handler

       gsF_Memo Copyright (c) 1996 Griffin Solutions, Inc.

       Date
          4 Apr 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit handles the objects for all dBase III/IV Memo (.DBT)
       and FoxPro (.FPT) file operations.

   Changes:

------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   SysHalc,
   SysUtils,
   gs6_cnst,
   gs6_disk,
   gs6_tool,
   gs6_Glbl;

{private}

const
   moHeaderSize = 32;

type

    GSrecMemoHeader = packed record
      case byte of
         0 : (DBIV       : SmallInt;
              StartLoc   : SmallInt;
              LenMemo    : longint;);
         1 :  (Fox20     : longint;);
         2 :  (NextEmty  : longint;
               BlksEmty  : longint;);
         3 :  (BlkArray  :array[0..31] of char;);
   end;

   GSobjMemo  = class(GSO_DiskFile)
      Owner        : GSO_DiskFile;
      TypeMemo     : Byte;   {83 for dBase III; 8B for dBase IV; F5 for FoxPro}
      MemoLocation : Longint;         {Current Memo record}
      MemoBloksUsed: word;
      BytesPerBlok : longint;
      MemoChanged  : boolean;
      MemoHeader   : GSrecMemoHeader;
      dfLockStyle    : GSsetLokProtocol;
      dfDirtyReadMax : gsuint32;
      dfDirtyReadLmt : gsuint32;
      dfDirtyReadMin : gsuint32;
      dfDirtyReadRng : gsuint32;
      moMemoOffSet   : integer;
      IsEncrypted    : boolean;
      PasswordIn     : string;
      PasswordOut    : string;

      constructor Create(AOwner: GSO_DiskFile; const FName, APassword: String;
                         ReadWrite, Shared: boolean; DBVer: byte);
      destructor  Destroy; override;
      procedure   moHuntAvailBlock(numbytes : longint); virtual;
      procedure   moMemoBlockRelease(rpt : longint); virtual;
      function    moMemoLock : boolean;
      procedure   moMemoPutLast(ps: PChar); virtual;
      procedure   moMemoSetParam(var bl: longint); virtual;
      procedure   moMemoRead(buf: pointer; blk: longint; var cb: longint);
      Procedure   moMemoSpaceUsed(blk: longint; var cb: longint);
      function    moMemoWrite(buf: pointer;var blk: longint;var cb: longint): longint;
      function    moMemoSize(blk: longint): longint;
      Procedure   moSetLockProtocol(LokProtocol: GSsetLokProtocol); virtual;
      function    moRename(const NewName: string): boolean; virtual;
   end;


   GSobjMemo3 = class(GSobjMemo)
   end;

   GSobjMemo4 = class(GSobjMemo)
      constructor Create(AOwner: GSO_DiskFile; const FName, APassword: String;
                         ReadWrite, Shared: boolean; DBVer: byte);
      procedure   moMemoBlockRelease(rpt : longint); override;
      procedure   moHuntAvailBlock(numbytes : longint); override;
      procedure   moMemoPutLast(ps: PChar); override;
      procedure   moMemoSetParam(var bl: longint); override;
   end;

   GSobjFXMemo20 = class(GSobjMemo)
      constructor Create(AOwner: GSO_DiskFile; const FName, APassword: String;
                         ReadWrite, Shared: boolean; DBVer: byte);
      procedure   moHuntAvailBlock(numbytes : longint); override;
      procedure   moMemoPutLast(ps: PChar); override;
      procedure   moMemoSetParam(var bl: longint); override;
      function    moRename(const NewName: string): boolean; override;
   end;

{------------------------------------------------------------------------------
                            IMPLEMENTATION SECTION
------------------------------------------------------------------------------}

implementation
uses gs6_dbf;

const
   WorkBlockSize = 32768;
   MaxEditLength = 255;

{------------------------------------------------------------------------------
                                GSobjMemo
------------------------------------------------------------------------------}


CONSTRUCTOR GSobjMemo.Create(AOwner: GSO_DiskFile; const FName, APassword: String;
                              ReadWrite, Shared: boolean; DBVer: byte);
var
   ext : String[4];
   pth : String;
begin
   case DBVer of
         DB3WithMemo,
         DB4WithMemo : ext := '.dbt';
         VFP3File,
         FXPWithMemo : ext := '.fpt';
      end;
   pth := Trim(FName);
   pth := ChangeFileExt(pth,ext);
   inherited Create(pth,ReadWrite,Shared);
   if not FileFound then
      raise EHalcyonError.CreateFmt(gsErrNoSuchFile,[FileName]);
   gsReset;
   Owner := AOwner;
   TypeMemo := DBVer;
   BytesPerBlok := dBaseMemoSize;
   MemoBloksUsed := 0;
   MemoLocation := 0;
   moMemoOffset := 0;
   IsEncrypted := APassword <> '';
   PasswordIn := APassword;
   PasswordOut := APassword;
end;

destructor GSobjMemo.Destroy;
begin
   inherited Destroy;
end;


procedure GSobjMemo.moHuntAvailBlock(numbytes : longint);
var
   BlksReq : longint;
   procedure NewDB3Block;
   begin
      gsRead(0, MemoHeader, moHeaderSize); {read header block from the .DBT}
      MemoLocation := MemoHeader.NextEmty;
      MemoHeader.NextEmty := MemoHeader.NextEmty + BlksReq;
      gsWrite(0, MemoHeader, moHeaderSize);
   end;

   procedure OldDB3Block;
   begin
      if MemoBloksUsed < BlksReq then NewDB3Block;
   end;

begin
   BlksReq := (numbytes+2+pred(BytesPerBlok)) div BytesPerBlok; {2 = $1A1A}
   if (MemoLocation > 0) then
      OldDB3Block
   else
      NewDB3Block;
   MemoBloksUsed := BlksReq;
   FillChar(MemoHeader, SizeOf(MemoHeader), #0);
end;

Procedure GSobjMemo.moMemoBlockRelease(rpt : longint);
begin                          {dummy to match GSobjMemo4.MemoBlockRelease}
end;



Function GSobjMemo.moMemoLock : boolean;
var
   rsl: boolean;
   tc: integer;
begin
   tc := GSwrdAccessMiliSeconds div GSwrdAccessMSecDelay;
   rsl := false;
   repeat
      case dfLockStyle of
         DB4Lock  : begin
                       rsl := gsLockRecord(dfDirtyReadMax - 1, 2);
                    end;
         ClipLock : begin
                       rsl := gsLockRecord(dfDirtyReadMax, 1);
                    end;
         Default,
         FoxLock  : begin
                       rsl := gsLockRecord(dfDirtyReadMax - 1, 1);
                    end;
      end;
      if not rsl then
      begin
         gsSysSleep(GSwrdAccessMSecDelay);
         dec(tc);
      end;
   until rsl or (tc = 0);
   moMemoLock := rsl;
   if not rsl then
      raise EHalcyonError.CreateFmt(gsErrLockFailed,[FileName]);
end;


Procedure GSobjMemo.moMemoPutLast(ps: PChar);
begin
   StrCopy(ps,#$1A#$1A);
end;

Procedure GSobjMemo.moMemoSetParam(var bl: longint);
begin
   bl := 0;
end;


Procedure GSobjMemo.moMemoRead(buf: pointer; blk: longint; var cb: longint);
var
   pba: GSptrCharArray;
   rsz: longint;
   sof: longint;
BEGIN
   if cb = 0 then exit;
   MemoLocation := blk;               {Save starting block number}
   MemoBloksUsed := 0;                {Initialize blocks read}
   if MemoLocation = 0 then
   begin
      cb := 0;
      pba := buf;
      pba^[0] := #0;
      exit;
   end;
   moMemoSpaceUsed(blk, rsz);
   rsz := rsz - moMemoOffset;
   if cb < rsz then
      rsz := cb
   else
      cb := rsz;
   sof := moMemoOffset;
   if (sof = 0) and (PasswordIn <> '') then sof := 4;
   MemoBloksUsed := (cb+sof+ pred(BytesPerBlok)) div BytesPerBlok;
   gsRead((blk*BytesPerBlok)+sof,buf^,rsz);
   if IsEncrypted then
      DBEncryption(PasswordIn,PByteArray(buf),PByteArray(buf),0,rsz);
END;

Procedure GSobjMemo.moMemoSpaceUsed(blk: longint; var cb: longint);
var
   ml: longint;
   mc: longint;
   fini: boolean;
   tblok: PByteArray;
BEGIN
   cb := moMemoOffset;
   if (blk = 0) then exit;
   gsRead(blk*BytesPerBlok, MemoHeader, moHeaderSize);
   moMemoSetParam(cb);
   if moMemoOffset > 0 then
   begin                 {Test for Fox or DBIV memo}
      exit;
   end;
   fini := false;
   ml := blk;                   {Save starting block number}
   cb := 0;
   GetMem(tblok, BytesPerBlok);
   while (not fini) do             {loop until Done (EOF mark)}
   begin
      gsRead(ml*BytesPerBlok, tblok^, BytesPerBlok);
      if (PasswordIn <> '') then
      begin                  {if encrypted then size is at start}
         Move(tblok^,mc,SizeOf(longint));
         cb := mc;
         exit;
      end;
      inc(ml);
      mc := 0;
      while (mc < BytesPerBlok) and (fini = false) do
      begin
         inc(cb);
         if (tblok^[mc] = $1A) or (cb = 65520) then
         begin
            fini := true;
            dec(cb);
         end;
         inc(mc);                {Step to next input buffer location}
      end;
   end;
   FreeMem(tblok,BytesPerBlok);
END;

function GSobjMemo.moMemoWrite(buf: pointer; var blk: longint;var cb: longint): longint;
type
  PBArray = ^TBArray;
  TBArray = array[0..MaxInt-1] of Byte;

var
   rsl : boolean;
   rsz : longint;
   rwk : longint;
   sof : longint;
   pb: PBArray;
BEGIN
   moMemoWrite := blk;
   if (cb = 0) and (blk = 0) then exit;
   if FileShared then
      rsl := moMemoLock
   else rsl := true;
   if not rsl then
   begin
      moMemoWrite := 0;
      exit;
   end;

   moMemoSpaceUsed(blk, rsz);
   if (moMemoOffset = 0) and (PasswordIn <> '') then rsz := rsz + 4;
   MemoBloksUsed := (rsz + pred(BytesPerBlok)) div BytesPerBlok;

   MemoLocation := blk;
   rsz := cb;      {Get count of bytes in memo field}
   moHuntAvailBlock(rsz);
   sof := moMemoOffset;
   rwk := (rsz div BytesPerBlok) * BytesPerBlok;
   while rwk < (rsz+sof) do rwk := rwk + BytesPerBlok;  {FIX 06241999 for access violation}
   if sof = 0 then
   begin
      if PasswordOut <> '' then
      begin
         sof := 4;
         MemoHeader.NextEmty := rsz;
      end;
      if rwk < (rsz+sof+2) then rwk := rwk + BytesPerBlok;    {is dBase 3 memo}
   end;
   pb := AllocMem(rwk);
   if sof > 0 then
      Move(MemoHeader,pb^,sof);
   DBEncryption(PasswordOut,PByteArray(buf),@pb^[sof],1,rsz);
   moMemoPutLast(@pb^[sof+rsz]);
   gsWrite((MemoLocation*BytesPerBlok), pb^, rwk);
   FreeMem(pb,rwk);
   blk := MemoLocation;
   moMemoWrite := MemoLocation;
   gsUnLock;
end;

function GSobjMemo.moMemoSize(blk: longint): longint;
var
   cb: longint;
begin
   moMemoSpaceUsed(blk, cb);
   cb := cb-moMemoOffset;
   moMemoSize := cb;
end;

Procedure GSobjMemo.moSetLockProtocol(LokProtocol: GSsetLokProtocol);
begin
   dfLockStyle := LokProtocol;
   case LokProtocol of
      DB4Lock  : begin
                    dfDirtyReadMin := $40000000;
                    dfDirtyReadMax := $EFFFFFFF;
                    dfDirtyReadRng := $B0000000;
                 end;
      ClipLock : begin
                    dfDirtyReadMin := 1000000000;
                    dfDirtyReadMax := 1000000000;
                    dfDirtyReadRng := 1000000000;
                 end;
      Default,
      FoxLock  : begin
                    dfDirtyReadMin := $40000000;
                    dfDirtyReadMax := $7FFFFFFE;
                    dfDirtyReadRng := $3FFFFFFF;
                 end;
   end;
end;

function GSobjMemo.moRename(const NewName: string): boolean;
var
   fno: string;
   fex: string;
begin
   fex := ExtractFileExt(FileName);
   fno := ChangeFileExt(NewName,fex);
   Result := gsRename(fno);
   if Result then
   begin
      gsRead(0, MemoHeader, moHeaderSize); {read header block from the .DBT}
      FillChar(MemoHeader.BlkArray[8], 9, #0);
      fno := ExtractFileNameOnly(NewName);
      fno := system.copy(fno,1,8);
      Move(fno[1],MemoHeader.BlkArray[8],length(fno));
      gsWrite(0, MemoHeader, moHeaderSize);
   end;
end;

{------------------------------------------------------------------------------
                                GSobjMemo4
------------------------------------------------------------------------------}

procedure GSobjMemo4.moHuntAvailBlock(numbytes : longint);
var
   BlksReq : integer;
   WBlok1  : longint;
   WBlok2  : longint;
   WBlok3  : longint;

   procedure FitDB4Block;
   var
      match   : boolean;
   begin
      match := false;
      gsRead(0, MemoHeader, moHeaderSize);    {read header block from the .DBT}
      WBlok3 := gsFileSize div BytesPerBlok;
      if WBlok3 = 0 then     {empty file, fill up header block}
      begin
         inc(WBlok3);
         gsWrite(0, MemoHeader, moHeaderSize);
      end;
      with MemoHeader do
      begin
         WBlok1 := NextEmty;
         WBlok2 := 0;
         while not match and (WBlok1 < WBlok3) do
         begin
            gsRead(WBlok1*BytesPerBlok, MemoHeader, moHeaderSize);
            if BlksEmty >= BlksReq then
            begin
               match := true;
               WBlok3 := NextEmty;
               if BlksEmty > BlksReq then      {free any blocks not needed}
               begin
                  WBlok3 := WBlok1+BlksReq;
                  BlksEmty := BlksEmty - BlksReq;
                  gsWrite(WBlok3*BytesPerBlok, MemoHeader, moHeaderSize);
               end;
            end
            else                            {new memo won't fit this chunk}
            begin
               WBlok2 := WBlok1;            {keep previous available chunk}
               WBlok1 := NextEmty;          {get next available chunk}
            end;
         end;
         if not match then
         begin
            WBlok1 := WBlok3;
            WBlok3 := WBlok3 + BlksReq;
         end;
         gsRead(WBlok2*BytesPerBlok, MemoHeader, moHeaderSize);
         NextEmty := WBlok3;
         gsWrite(WBlok2*BytesPerBlok, MemoHeader, moHeaderSize);
      end;
   end;

begin
   BlksReq := ((numbytes+moMemoOffset+(BytesPerBlok-1)) div BytesPerBlok);
   if (MemoLocation > 0) then moMemoBlockRelease(MemoLocation);
   FitDB4Block;
   MemoLocation := WBlok1;
   MemoBloksUsed := BlksReq;
   MemoHeader.DBIV := -1;
   MemoHeader.StartLoc:= moMemoOffset;
   MemoHeader.LenMemo := numbytes+moMemoOffset;
end;

Procedure GSobjMemo4.moMemoBlockRelease(rpt : longint);
var
   blks     : longint;
begin
{   blks := MemoBloksUsed;}
   with MemoHeader do
   begin
      gsRead(rpt*BytesPerBlok, MemoHeader, moMemoOffset);
      blks := (BlksEmty + (BytesPerBlok-1)) div BytesPerBlok;
      gsRead(0, MemoHeader, moMemoOffset);
      BlksEmty := blks;
      gsWrite(rpt*BytesPerBlok, MemoHeader, moMemoOffset);
      NextEmty := rpt;
      BlksEmty := 0;
   end;
   gsWrite(0, MemoHeader, moMemoOffset);
end;

Procedure GSobjMemo4.moMemoPutLast(ps: PChar);
begin
end;

Procedure GSobjMemo4.moMemoSetParam(var bl: longint);
begin
   if MemoHeader.DBIV = -1 then
   begin
      bl := MemoHeader.LenMemo;
   end
   else
   begin
      raise EHalcyonError.CreateFmt(gsErrBadMemoRecord,[FileName]);
      bl := moMemoOffset;
   end;
end;

CONSTRUCTOR GSobjMemo4.Create(AOwner: GSO_DiskFile; const FName, APassword: String;
                               ReadWrite, Shared: boolean; DBVer: byte);
var
   pb: pointer;
begin
   inherited Create(AOwner, FName,APassword,ReadWrite,Shared,DBVer);
   gsRead(0, MemoHeader, moHeaderSize);
   Move(MemoHeader.BlkArray[20],BytesPerBlok,SizeOf(longint));
   if gsFileSize < BytesPerBlok then
   begin
      pb := AllocMem(BytesPerBlok);
      Move(MemoHeader, pb^, gsFileSize);
      gsWrite(0, pb^, BytesPerBlok);
      FreeMem(pb,BytesPerBlok);
   end;
   moMemoOffset := 8;
end;



{------------------------------------------------------------------------------
                                GSobjFXMemo20
------------------------------------------------------------------------------}


procedure MakeLeft2RightInt(r: longint; var x);
var
   a:  array[0..3] of byte absolute x;
   ra: array[0..3] of byte absolute r;
begin
   a[0] := ra[3];
   a[1] := ra[2];
   a[2] := ra[1];
   a[3] := ra[0];
end;

Function MakeLongInt(var x): longint;
var
   a:  array[0..3] of byte absolute x;
   r:  longint;
   ra: array[0..3] of byte absolute r;
begin
   ra[0] := a[3];
   ra[1] := a[2];
   ra[2] := a[1];
   ra[3] := a[0];
   MakeLongInt := r;
end;

CONSTRUCTOR GSobjFXMemo20.Create(AOwner: GSO_DiskFile; const FName, APassword: String;
                                  ReadWrite, Shared: boolean; DBVer: byte);
begin
   inherited Create(AOwner, FName, APassword, ReadWrite, Shared, DBVer);
   gsRead(0, MemoHeader, moHeaderSize);
   BytesPerBlok := MakeLongInt(MemoHeader.BlkArray[4]) and $FFFF;
   moMemoOffset := 8;
end;

procedure GSobjFXMemo20.moHuntAvailBlock(numbytes : longint);
var
   BlksReq : integer;

   procedure NewFoxBlock;
   begin
      with MemoHeader do
      begin
         gsRead(0, MemoHeader, moMemoOffset);  {read header block from the .DBT}
         MemoLocation := MakeLongInt(NextEmty);
         MakeLeft2RightInt(MemoLocation + BlksReq, NextEmty);
         gsWrite(0, MemoHeader, moMemoOffset);
      end;
   end;

   procedure OldFoxBlock;
   begin
      if MemoBloksUsed < BlksReq then NewFoxBlock;
   end;

begin
   BlksReq := ((numbytes+moMemoOffset+(BytesPerBlok-1)) div BytesPerBlok);
   if (MemoLocation > 0) then
      OldFoxBlock
   else
      NewFoxBlock;
   MemoBloksUsed := BlksReq;
   MakeLeft2RightInt(1,MemoHeader.BlkArray[0]);
   MakeLeft2RightInt(numbytes,MemoHeader.BlkArray[4]);
end;

Procedure GSobjFXMemo20.moMemoPutLast(ps: PChar);
begin
end;

Procedure GSobjFXMemo20.moMemoSetParam(var bl: longint);
begin
   if (MemoHeader.Fox20 = $01000000) or (MemoHeader.Fox20 = 0) then
   begin
      bl := MakeLongInt(MemoHeader.LenMemo)+moMemoOffset;
   end
   else
   begin
      raise EHalcyonError.CreateFmt(gsErrBadMemoRecord,[FileName]);
      bl := moMemoOffset;
   end;
end;

function GSobjFXMemo20.moRename(const NewName: string): boolean;
var
   fno: string;
   fex: string;
begin
   fex := ExtractFileExt(FileName);
   fno := ChangeFileExt(NewName,fex);
   Result := gsRename(fno);
end;

end.

