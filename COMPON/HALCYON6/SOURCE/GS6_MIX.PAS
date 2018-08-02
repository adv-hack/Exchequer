unit gs6_mix;
{-----------------------------------------------------------------------------
                          Basic Index File Routine

       gs6_mix Copyright (c) 1997 Griffin Solutions, Inc.

       Date
          26 July 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit contains the objects to manage in-memory index
       files.

   Changes:

------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   SysUtils,
   SysHalc,
   gs6_cdx,
   gs6_dbf,
   gs6_disk,
   gs6_glbl,
   gs6_indx,
   gs6_sort,
   gs6_tool;

{private}

type

   GSobjMIXFile = class(GSobjIndexFile)
      MemColl     : TgsCollection;
      constructor Create(PDB: GSO_dBaseFld; const FN: gsUTFString);
      destructor  Destroy; override;
      function    AddTag(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean):
                         boolean; override;
      function    GetAvailPage: longint; override;
      function    ResetAvailPage: longint; override;
      function    PageRead(Blok: longint; var Page; Size: integer):
                           boolean; override;
      function    PageWrite(Blok: longint; var Page; Size: integer):
                            boolean; override;
   end;


implementation

type

   GSobjMemBufr = class(TObject)
      BufSize   : integer;
      BufPntr   : pointer;
      constructor Create;
      destructor  Destroy; override;
      function    GetFromBuffer(var Page; Size: integer): boolean;
      function    PutInBuffer(var Page; Size: integer): boolean;
   end;

{-----------------------------------------------------------------------------
                                 GSobjMemBufr
-----------------------------------------------------------------------------}

constructor GSobjMemBufr.Create;
begin
   inherited Create;
   BufSize := 0;
   BufPntr := nil;
end;

destructor GSobjMemBufr.Destroy;
begin
   if BufPntr <> nil then
      FreeMem(BufPntr, BufSize);
   inherited Destroy;
end;

function GSobjMemBufr.GetFromBuffer(var Page; Size: integer): boolean;
begin
   if Size > BufSize then
      GetFromBuffer := false
   else
   begin
      GetFromBuffer := true;
      Move(BufPntr^,Page,Size);
   end;
end;

function GSobjMemBufr.PutInBuffer(var Page; Size: integer): boolean;
begin
   if Size > BufSize then
   begin
      if BufPntr <> nil then
         FreeMem(BufPntr, BufSize);
      GetMem(BufPntr,Size);
      BufSize := Size;
   end;
   Move(Page,BufPntr^,Size);
   PutInBuffer := true;
end;

{-----------------------------------------------------------------------------
                                 GSobjMIXFile
-----------------------------------------------------------------------------}

constructor GSobjMIXFile.Create(PDB: GSO_dBaseFld; const FN: string);
begin
   inherited Create(PDB);
   MemColl := TgsCollection.Create;
   IndexName := gsStrUpperCase(FN);
   KeyWithRec := true;
   NextAvail := 0;
   CreateOK := true;
end;

destructor GSobjMIXFile.Destroy;
begin
   MemColl.Free;
   inherited Destroy;
end;

function GSobjMIXFile.AddTag(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean): boolean;
var
   p: GSobjIndexTag;
begin
   NextAvail := 0;
   p := GSobjCDXTag.Create(Self,ITN,-1);
   TagList.Add(p);
   AddTag := p.IndexTagNew(ITN,KeyExp,ForExp,Ascnd,Uniq);
   p.TagClose;
end;

function GSobjMIXFile.GetAvailPage: longint;
var
   p : GSobjMemBufr;
begin
   if NextAvail = -1 then ResetAvailPage;
   GetAvailPage := NextAvail;
   p := GSobjMemBufr.Create;
   MemColl.Add(p);
   inc(NextAvail,1);
end;

function GSobjMIXFile.ResetAvailPage: longint;
begin
   NextAvail := MemColl.Count;
   ResetAvailPage := NextAvail;
end;

function GSobjMIXFile.PageRead(Blok: longint; var Page; Size: integer):
                               boolean;
begin
   if Blok < MemColl.Count then
      PageRead :=
        GSobjMemBufr(MemColl.Items[Blok]).GetFromBuffer(Page, Size)
   else
      PageRead := false;
end;

function GSobjMIXFile.PageWrite(Blok: longint; var Page; Size: integer):
                                  boolean;
begin
   if Blok < MemColl.Count then
      PageWrite :=
        GSobjMemBufr(MemColl.Items[Blok]).PutInBuffer(Page, Size)
   else
      PageWrite := false;
end;

end.


