{*********************************************************}
{* ABBREVIA: AbSelfEx.pas 3.02                           *}
{* Copyright (c) TurboPower Software Co 1997, 2002       *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA: Component for building self-extracting zips *}
{*********************************************************}

{$I AbDefine.inc}

unit AbSelfEx;

interface

uses
  SysUtils, Classes,
{$IFDEF LINUX}
  Libc, 
{$ENDIF}
  AbArcTyp, AbBase, AbExcept, AbUtils, AbZipTyp;

type
  TAbGetFileEvent = procedure(Sender : TObject; var aFilename : string;
                              var Abort : Boolean) of object;

type
  TAbMakeSelfExe = class(TAbBaseComponent)
  protected {private}
    FStubExe      : string;
    FZipFile      : string;
    FSelfExe      : string;
    FStubStream   : TFileStream;
    FZipStream    : TFileStream;
    FSelfStream    : TFileStream;
    FOnGetStubExe : TAbGetFileEvent;
    FOnGetZipFile : TAbGetFileEvent;

    procedure DoGetStubExe(var Abort : Boolean);
    procedure DoGetZipFile(var Abort : Boolean);

  public
    function Execute : Boolean;

  published
    property SelfExe : string
      read FSelfExe
      write FSelfExe;
    property StubExe : string
      read FStubExe
      write FStubExe;
    property ZipFile : string
      read FZipFile
      write FZipFile;
    property OnGetStubExe : TAbGetFileEvent
      read FOnGetStubExe
      write FOnGetStubExe;
    property OnGetZipFile : TAbGetFileEvent
      read FOnGetZipFile
      write FOnGetZipFile;
    property Version;
  end;


implementation

uses
  {$IFDEF TrialRun}
  AbTrial,
  {$ENDIF}
  AbConst;

{ -------------------------------------------------------------------------- }
function TAbMakeSelfExe.Execute : Boolean;
var
  Abort : Boolean;
begin
  {$IFDEF TrialRun}
  _TR2_;
  {$ENDIF}
  Abort := False;
  if (FStubExe = '') then
    DoGetStubExe(Abort);
  if Abort then
    raise EAbUserAbort.Create;
  if not FileExists(FStubExe) then
    raise EAbFileNotFound.Create;
  if (FZipFile = '') then
    DoGetZipFile(Abort);
  if Abort then
    raise EAbUserAbort.Create;
  if not FileExists(FZipFile) then
    raise EAbFileNotFound.Create;

  FStubStream := TFileStream.Create(FStubExe, fmOpenRead or fmShareDenyWrite);
  FZipStream := TFileStream.Create(FZipFile, fmOpenRead or fmShareDenyWrite);
  if (FSelfExe = '') then
    FSelfExe := ChangeFileExt(FZipFile, '.exe');
  FSelfStream := TFileStream.Create(FSelfExe, fmCreate or fmShareExclusive);
  try
    MakeSelfExtracting(FStubStream, FZipStream, FSelfStream);
    Result := True;
  finally
    FStubStream.Free;
    FZipStream.Free;
    FSelfStream.Free;
  end;
end;
{ -------------------------------------------------------------------------- }
procedure TAbMakeSelfExe.DoGetStubExe(var Abort: Boolean);
begin
  if Assigned(FOnGetStubExe) then
    FOnGetStubExe(Self, FStubExe, Abort);
end;
{ -------------------------------------------------------------------------- }
procedure TAbMakeSelfExe.DoGetZipFile(var Abort : Boolean);
begin
  if Assigned(FOnGetZipFile) then
    FOnGetZipFile(Self, FZipFile, Abort);
end;
{ -------------------------------------------------------------------------- }

end.
