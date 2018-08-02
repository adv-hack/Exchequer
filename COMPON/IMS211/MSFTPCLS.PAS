(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msFtpCls;

interface

uses Classes, SysUtils;

type
  TmsServerType = (stAuto, stUnix, stDos, stHP3000, stAS400);
  TmsFileKind = (fkUnknown, fkFile, fkDirectory, fkLink);
  TmsProxyType = (fpUserNoLogon, fpProxyOpen);
  TmsTransferType = (ttBinary, ttASCII);  // FTP transfer type

  TmsFTPDirEntry=class
    Kind : TmsFileKind;
    FileName : ShortString;
    Size : LongInt;
    Date : TDateTime;
    LinkPtr : ShortString;
  end;

  TmsFTPDirList = class(TPersistent)
  private
    FList : TList;
    FServerType : TmsServerType;
    function Get(Index : Integer) : TmsFTPDirEntry;
    procedure Put(Index : Integer; Value : TmsFTPDirEntry);
    function GetCount : Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Value : TmsFTPDirEntry) : Integer;
    procedure Assign(Source : TPersistent); override;
    function AddString(const s : string) : Integer;
    procedure Clear;
    property Items[Index : Integer] : TmsFTPDirEntry read Get write Put; default;
    property Count : Integer read GetCount;
    property ServerType: TmsServerType read FServerType write FServerType;
  end;

implementation

uses msFTPUt, msUtils;

{ TmsFTPDirList }
constructor TmsFTPDirList.Create;
begin
  inherited Create;
  FList:=TList.Create;
end;

destructor TmsFTPDirList.Destroy;
var
  i: Integer;
begin
  if FList<>nil then
  begin
    for i:=Count-1 DownTo 0 do
      Items[i].Free;
    FList.Free;
  end;
  inherited Destroy;
end;

function TmsFTPDirList.Add(Value: TmsFTPDirEntry): Integer;
begin
  Result:=FList.Add(Value);
end;

function TmsFTPDirList.AddString(const s: string): Integer;
var
  TempS, s1, s2 : string;
  i : Integer;
  FTPEntry : TmsFTPDirEntry;
begin
  TempS:=s;
  FTPEntry:=TmsFTPDirEntry.Create;
  try
    if FServerType=stDos then
    begin
      s1:=PickString(TempS,0,true);
      s2:=PickString(TempS,1,true);
      FTPEntry.Date:=DOSFTPDateTimeToDateTime(s1+' '+s2);
      if Pos('<dir>',LowerCase(TempS))>0 then
        FTPEntry.Kind:=fkDirectory
      else
        FTPEntry.Kind:=fkFile;
      i:=LastPos(' ',TempS);
      if i>0 then
      begin
        FTPEntry.FileName:=Copy(TempS,i+1,Length(TempS));
        System.Delete(TempS,i,Length(TempS));
        TempS:=Trim(TempS);
        i:=LastPos(' ',TempS);
        FTPEntry.Size:=StrToIntDef(Copy(TempS,i+1,Length(TempS)),0);
      end;
    end
    else
    if FServerType=stUnix then
    begin
       case TempS[1] of
         'd': FTPEntry.Kind:=fkDirectory;
         'l': FTPEntry.Kind:=fkLink;
         else FTPEntry.Kind:=fkFile;
       end;
       FTPEntry.FileName:=PickString(TempS,8,false);
       if FTPEntry.FileName='' then
       begin
         Insert(' ',TempS,25);
         FTPEntry.FileName:=PickString(TempS,8,false);
       end;
       if FTPEntry.FileName='' then
       begin
         Insert(' ',TempS,7);
         FTPEntry.FileName:=PickString(TempS,8,false);
       end;
       FTPEntry.Size:=PickNumber(TempS,4);
       s1:=Concat(PickString(TempS,5,true),' ',PickString(TempS,6,true),
              ' ',PickString(TempS,7,true));
       try
         FTPEntry.Date:=UnixFTPDateTimeToDateTime(s1);
       except
         FTPEntry.Date:=now;
       end;
       if FTPEntry.Kind=fkLink then
         FTPEntry.LinkPtr:=PickLinkPtr(TempS);
    end
    else
    if FServerType=stHP3000 then
    begin
      if s='' then
      begin
        FTPEntry.Kind:=fkDirectory;
        FTPEntry.FileName:='..';
      end
      else
      begin
        if s[16]='F' then
          FTPEntry.Kind:=fkFile
        else
          FTPEntry.Kind:=fkDirectory;
        FTPEntry.FileName:=Copy(s,62,Length(s));
      end;
    end
    else
    if FServerType=stAS400 then
    begin
      if (Pos('AS400',s)>0) or (Pos('-----',s)>0) then
      begin
        FTPEntry.Free;
        Result:=Count;
        Exit;
      end;
      if s='' then
      begin
        FTPEntry.Kind:=fkDirectory;
        FTPEntry.FileName:='..';
      end
      else
      begin
        if Copy(s,41,4)='*FLR' then
          FTPEntry.Kind:=fkDirectory
        else
          FTPEntry.Kind:=fkFile;
        FTPEntry.Size:=StrToIntDef(Trim(Copy(s,1,21)),0);
        FTPEntry.FileName:=Copy(s,51,Length(s));
        if FTPEntry.Kind=fkDirectory then
          FTPEntry.FileName:=Copy(FTPEntry.FileName,1,Length(FTPEntry.FileName)-1);
      end;
    end
    else
      raise Exception.Create('');
    Result:=Add(FTPEntry);
  except
    FTPEntry.Kind:=fkUnknown;
    FTPEntry.FileName:=s;
    Result:=Add(FTPEntry);
  end;
end;

procedure TmsFTPDirList.Assign(Source: TPersistent);
var
  i : Integer;
  DirEntry : TmsFTPDirEntry;
  SourceList : TmsFTPDirList;
begin
  if Source is TmsFTPDirList then
  begin
    Clear;
    SourceList:=Source as TmsFTPDirList;
    for i:=0 to SourceList.Count-1 do
    begin
      DirEntry:=TmsFTPDirEntry.Create;
      DirEntry.Kind:=SourceList[i].Kind;
      DirEntry.FileName:=SourceList[i].FileName;
      DirEntry.Size:=SourceList[i].Size;
      DirEntry.Date:=SourceList[i].Date;
      DirEntry.LinkPtr:=SourceList[i].LinkPtr;
      Add(DirEntry);
    end;
  end
  else
    inherited Assign(Source);
end;

procedure TmsFTPDirList.Clear;
var
  i: Integer;
begin
  for i:=Count-1 DownTo 0 do
    Items[i].Free;
  FList.Clear;
end;

function TmsFTPDirList.Get(Index: Integer): TmsFTPDirEntry;
begin
  Result:=FList[Index];
end;

function TmsFTPDirList.GetCount: Integer;
begin
  Result:=FList.Count;
end;

procedure TmsFTPDirList.Put(Index: Integer; Value: TmsFTPDirEntry);
begin
  FList[Index]:=Value;
end;

end.
