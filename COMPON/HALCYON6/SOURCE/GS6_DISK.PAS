Unit gs6_disk;
{------------------------------------------------------------------------------
                               Disk File Handler

       gs6_disk Copyright (c) 1996 Griffin Solutions, Inc.

       Date
          4 Apr 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit handles the objects for all untyped disk file I/O.

------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   SysHalc,
   SysUtils,
   gs6_cnst,
   gs6_glbl,
   gs6_tool,
   gs6_date;

const
   GSwrdAccessMiliSeconds : word = 5000;
   GSwrdAccessMSecDelay: word = 50;

{private}
type

   GSO_DiskFile = Class(TObject)
   private
      dfFileHndl   : integer;
      dfFileExst   : boolean;    {True if file exists}
      dfFileName   : gsUTFString;
      dfFilePosn   : longint;
      dfFileShrd   : boolean;
      dfReadWrite  : boolean;
      dfGoodRec    : longint;
      dfLockRec    : Integer;
      dfLockPos    : Int64;
      dfLockLth    : Int64;
      dfHasWritten : boolean;
      dfClosed     : boolean;
      Function     InternalCloseFile: boolean;
   protected
      Function     gsCloseFile: boolean; virtual;
   public
      Constructor  Create(const Fname: gsUTFString; ReadWrite, Shared: boolean);
      Destructor   Destroy; override;
      function     FileFullyLocked: boolean;
      Function     gsFileSize : longint; virtual;
      Procedure    gsFlush; virtual;
      Function     gsLockFile: Boolean; virtual;
      Function     gsLockRecord(FilePosition,FileLength: gsuint32): Boolean; virtual;
      Function     gsRead(blk: gsuint32; var dat; len: gsuint32): integer; virtual;
      Function     gsRename(const NewName: gsUTFString): boolean; virtual;
      Procedure    gsReset; virtual;
      Procedure    gsReWrite; virtual;
      Procedure    gsStatusUpdate(stat1,stat2,stat3 : longint); virtual;
      Procedure    gsStatusLink(stat1,stat2,stat3 : longint);
      Procedure    gsTruncate(loc: gsuint32); virtual;
      Function     gsUnLock: boolean; virtual;
      Procedure    gsWrite(blk: gsuint32; var dat; len: gsuint32); virtual;
      Procedure    IncLockCount;
      Procedure    DecLockCount;
      Property     FileHandle: integer read dfFileHndl;
      Property     FileFound: boolean read dfFileExst;
      Property     FileShared: boolean read dfFileShrd;
      Property     FileReadWrite: boolean read dfReadWrite;
      Property     FileName: gsUTFString read dfFileName;
      Property     FileExist: boolean read dfFileExst;
      Property     LockCount: integer read dfLockRec;
   end;

{------------------------------------------------------------------------------
                            IMPLEMENTATION SECTION
------------------------------------------------------------------------------}

implementation

type
   GSobjFileColl = class(TgsCollection)
      constructor Create;
      Destructor Destroy; override;
      procedure DeleteItem(Item: pointer);
      procedure FreeItem(Item: Pointer); override;
      function IndexOfItem(Item: Pointer): Integer;
      procedure InsertItem(Item: Pointer);
   end;

var
   FileList       : GSobjFileColl;

{$IFDEF HALCDEMO}
var
   exefh: integer;
   exedt: TDateTime;
   exefd: integer;
   exect: integer;

procedure DemoCheck;
begin
   if exect > 0 then exit;
   inc(exect);
   exefh := FileOpen(ParamStr(0),fmOpenRead+fmShareDenyNone);
   if exefh > 0 then
   begin
      exefd := FileGetDate(exefh);
      FileClose(exefh);
      exedt := FileDateToDateTime(exefd);
      if Date - exedt > 2 then
      begin
            raise EInOutError.Create('Unregistered Version of Halcyon 6.'+#13#10+
                                  'Contact Griffin Solutions at www.grifsolu.com');
      end;
   end;
end;
{$ENDIF}

{------------------------------------------------------------------------------
                              Global Routines
------------------------------------------------------------------------------}

Function GSGetExpandedFile(const FileName: gsUTFString): gsUTFString;
begin
   if (Pos('\\',Filename) <> 0) or (pos(':',FileName) > 2) then
     Result := FileName
   else
     Result := ExpandFileName(FileName);
end;

Procedure GS_CloseAllFiles;
var
   i    : integer;
   optr : GSO_DiskFile;
begin
   if (FileList <> nil) and (FileList.Count > 0) then
   begin
      try
         for i := 0 to FileList.Count-1 do
         begin
            optr :=  FileList.Items[i];
            with optr do
            begin
               if dfLockRec > 0 then
               begin
                  dfLockRec := 1;
                  gsSysUnLockFile(dfFileHndl,dfLockPos,dfLockLth);
               end;
               FileClose(dfFileHndl);
            end;
         end;
      finally
      end;
   end;
end;


{------------------------------------------------------------------------------
                              GSO_DiskFile
------------------------------------------------------------------------------}

Constructor GSO_DiskFile.Create(const Fname: gsUTFString; ReadWrite, Shared: boolean);
var
   FNup : gsUTFString;
begin
   {$IFDEF HALCDEMO}
   DemoCheck;
   {$ENDIF}
   inherited Create;
   FNup := GSGetExpandedFile(Fname);
   dfFileName := FNup;
   dfFileShrd := Shared;
   dfReadWrite := ReadWrite;
   dfFileExst := FileExists(FNup);
   dfFilePosn := 0;
   dfFileHndl := 0;
   dfLockRec := 0;
   dfHasWritten := false;
   dfClosed := true;
end;

destructor GSO_DiskFile.Destroy;
begin
   gsCloseFile;
   inherited Destroy;
end;

function GSO_DiskFile.FileFullyLocked: boolean;
begin
   Result := not dfFileShrd;
   if not Result then
      if (dfLockRec > 0) and (dfLockPos = 0) and (dfLockLth = MaxRecNum) then
         Result := true;
end;

Function GSO_DiskFile.InternalCloseFile: boolean;
begin
   if not dfClosed then
   begin
      if dfLockRec > 0 then
      begin
         dfLockRec := 1;       {set lock count to 1 to force unlock}
         gsUnLock;
      end;
      if (FileList <> nil) and (FileList.IndexOfItem(Self) <> -1) then
         FileList.DeleteItem(Self);
      FileClose(dfFileHndl);
      dfClosed := true;
      dfFilePosn := 0;
      dfFileHndl := 0;
   end;
   Result := true;
end;

Function GSO_DiskFile.gsCloseFile: boolean;
begin
   Result := InternalCloseFile;
end;

Function GSO_DiskFile.gsFileSize : longint;
var
   fs: longint;
begin
   fs := FileSeek(dfFileHndl,0,2);
   if fs = -1 then
      raise EHalcyonError.CreateFmt(gsErrGetFileSize,[dfFileName]);
   gsFileSize := fs;
end;

Procedure GSO_DiskFile.gsFlush;
begin
   if dfClosed then exit;
   if not gsSysFlushFileBuffers(dfFileHndl) then
      raise EHalcyonError.CreateFmt(gsErrFlushFailed,[dfFileName]);
   dfHasWritten := false;
end;

Function GSO_DiskFile.gsLockFile : Boolean;
begin
   if dfFileShrd then
      gsLockFile :=  gsLockRecord(0,MaxRecNum)
   else
      gsLockFile := true;
end;

Function GSO_DiskFile.gsLockRecord(FilePosition,FileLength: gsuint32): boolean;
var
   success: boolean;
begin
   success := true;
   if (not dfFileShrd) then
   begin                        {do dummy File Lock if not shared}
      inc(dfLockRec);
      dfLockPos := FilePosition;
      dfLockLth := FileLength;
   end
   else
   begin
      if dfLockRec > 0 then    {if already locked see if same region}
      begin
         if (FilePosition = dfLockPos) and (FileLength = dfLockLth) then
            inc(dfLockRec)
         else
            success := false;
      end
      else
      begin
         dfLockPos := FilePosition;
         dfLockLth := FileLength;
         if gsSysLockFile(dfFileHndl,dfLockPos,dfLockLth) then
            inc(dfLockRec)
         else
            success := false;
      end;
   end;
   gsLockRecord := success;
end;

Function GSO_DiskFile.gsRead(blk: gsuint32; var dat; len: gsuint32): integer;
var
   fs: longint;
   Count: integer;
begin
   Count := len;
   fs := FileSeek(dfFileHndl, blk, 0);
   IF fs <> -1 THEN               {If seek ok, read the record}
   BEGIN
      dfGoodRec := FileRead(dfFileHndl, dat, Count);
      if dfGoodRec = -1 then
         raise EHalcyonError.CreateFmt(gsErrReadFailed,[dfFileName]);
      dfFilePosn := (blk+len);
   end
   else
      raise EHalcyonError.CreateFmt(gsErrReadFailed,[dfFileName]);
   gsRead := dfGoodRec;
end;

Function GSO_DiskFile.gsRename(const NewName: gsUTFString): boolean;
var
   filenew: gsUTFString;
begin
   Result := InternalCloseFile;
   if Result then
   begin
      filenew := GSGetExpandedFile(NewName);
      Result := RenameFile(dfFileName,filenew);
      if not Result then
         raise EHalcyonError.CreateFmt(gsErrRenameFailed,[dfFileName])
      else
         dfFileName := FileNew;
      gsReset;
   end
   else
      raise EHalcyonError.CreateFmt(gsErrCloseFailed,[dfFileName]);
end;


Procedure GSO_DiskFile.gsReset;
var
   WrkMode : byte;
begin
   if not dfFileExst then
      raise EHalcyonError.CreateFmt(gsErrNoSuchFile,[dfFileName]);
   WrkMode := 0;
   if dfReadWrite then WrkMode := WrkMode + fmOpenReadWrite;
   if dfFileShrd then WrkMode := WrkMode + fmShareDenyNone;
   dfFileHndl := FileOpen(dfFileName,WrkMode);
   if dfFileHndl = -1 then
      raise EHalcyonError.CreateFmt(gsErrResetFailed,[dfFileName]);
   dfFilePosn := 0;
   if FileList = nil then
      FileList := GSobjFileColl.Create;
   FileList.InsertItem(Self);
   dfClosed := false;
end;

Procedure GSO_DiskFile.gsReWrite;
begin
   dfFileHndl := FileCreate(dfFileName);
   if dfFileHndl <> -1 then
   begin
      FileClose(dfFileHndl);
      dfFileExst := true;
      gsReset;
   end
   else
      raise EHalcyonError.CreateFmt(gsErrRewriteFailed,[dfFileName]);
end;

Procedure GSO_DiskFile.gsStatusUpdate(stat1,stat2,stat3 : longint);
begin
end;

Procedure GSO_DiskFile.gsStatusLink(stat1,stat2,stat3 : longint);
begin
   gsStatusUpdate(stat1,stat2,stat3);
end;

Procedure GSO_DiskFile.gsTruncate(loc: gsuint32);
begin
   if (not dfReadWrite) or (not FileFullyLocked) then
      raise EHalcyonError.CreateFmt(gsErrNoFullAccess,['Truncate',dfFileName])
   else
   begin
      if gsSysTruncate(dfFileHndl,loc) <> 0 then
         raise EHalcyonError.CreateFmt(gsErrTruncateFailed,[dfFileName]);
   end;
end;

Function GSO_DiskFile.gsUnLock: boolean;
begin
   if dfLockRec > 0 then
   begin
      if dfFileShrd and (dfLockRec = 1) then
         if not gsSysUnLockFile(dfFileHndl,dfLockPos,dfLockLth) then
            raise EHalcyonError.CreateFmt(gsErrUnlockFailed,[dfFileName]);
      dec(dfLockRec);
   end;
   gsUnLock := true;
end;

Procedure GSO_DiskFile.gsWrite(blk: gsuint32; var dat; len: gsuint32);
var
   fs: longint;
begin
   dfHasWritten := false;
   fs := FileSeek(dfFileHndl, blk, 0);
   IF fs <> -1 then               {If seek ok, write the record}
   begin
      dfGoodRec := FileWrite(dfFileHndl, dat, len);
      if dfGoodRec = -1 then
         raise EHalcyonError.CreateFmt(gsErrWriteFailed,[dfFileName]);
      dfFilePosn := (blk+len);
      dfHasWritten := true;
   end
   else
      raise EHalcyonError.CreateFmt(gsErrWriteFailed,[dfFileName]);
 end;

Procedure GSO_DiskFile.IncLockCount;
begin
   inc(dfLockRec);
end;

Procedure GSO_DiskFile.DecLockCount;
begin
   gsUnlock;
end;


{------------------------------------------------------------------------------
                               GSobjFileColl
------------------------------------------------------------------------------}

constructor GSobjFileColl.Create;
begin
   inherited Create;
end;

destructor GSobjFileColl.Destroy;
begin
   inherited Destroy;
end;

procedure GSobjFileColl.DeleteItem(Item: pointer);
begin
   inherited Delete(IndexOf(Item));
end;

procedure GSobjFileColl.FreeItem(Item: Pointer);
begin
end;

function GSobjFileColl.IndexOfItem(Item: Pointer): Integer;
begin
   Result := IndexOf(Item);
end;

procedure GSobjFileColl.InsertItem(Item: pointer);
begin
   Add(Item);
end;


{------------------------------------------------------------------------------
                           Setup and Exit Routines
------------------------------------------------------------------------------}

initialization
   FileList := GSobjFileColl.Create;
   {$IFDEF HALCNDEMO}
   exect := 0;
   {$ENDIF}
finalization
begin
   GS_CloseAllFiles;
   if FileList <> nil then
      FileList.Free;
end;

end.
