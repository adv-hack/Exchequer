{*********************************************************}
{* ABBREVIA: AbZipExt.pas 3.02                           *}
{* Copyright (c) TurboPower Software Co 1997, 2002       *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA: Zip file registration                       *}
{*********************************************************}

{$I AbDefine.inc}

unit AbZipExt;

interface

uses
  SysUtils, Classes;

function AbExistingZipAssociation : Boolean;
function AbGetZipAssociation(var App, ID, FileType : string) : Boolean;
function AbRegisterZipExtension(App, ID, FileType : string; Replace : Boolean) : Boolean;


implementation

uses
{$IFDEF MSWINDOWS}
  Windows,
  Messages,
  Registry,
  ShellAPI,
{$ENDIF}
{$IFDEF LINUX}
  Libc,
{$ENDIF}
{$IFDEF TRIALRUN}
  AbTrial,
{$ENDIF TRIALRUN}
  AbConst;

const
  ZipExt     = '.zip';
  DefZipID      = 'Zip';
  DefZipType    = 'Zip File';
  OpenCommand = 'Shell\Open\Command';
  DefaultIcon = 'DefaultIcon';

var
  Reg  : TRegistry;

{ -------------------------------------------------------------------------- }
function AbExistingZipAssociation : Boolean;
var
  App, ID, FileType : string;
begin
  Result := False;
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CLASSES_ROOT;
  Reg.OpenKey('',False);
  if Reg.OpenKey(ZipExt, False) then begin
    ID := Reg.ReadString('');
    if Reg.OpenKey('\' + ID, False) then begin
      FileType := Reg.ReadString('');
      if Reg.OpenKey(OpenCommand, False) then begin
        App := Reg.ReadString('');
        if (App <> '') then
          Result := True;
      end;
    end;
  end;
  Reg.Free;
end;
{ -------------------------------------------------------------------------- }
function AbGetZipAssociation(var App, ID, FileType : string) : Boolean;
begin
  Result := False;
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CLASSES_ROOT;
  Reg.OpenKey('',False);
  if Reg.OpenKey(ZipExt, False) then begin
    ID := Reg.ReadString('');
    if Reg.OpenKey('\' + ID, False) then begin
      FileType := Reg.ReadString('');
      if Reg.OpenKey(OpenCommand, False) then begin
        App := Reg.ReadString('');
        Result := True;
      end;
    end;
  end;
  Reg.Free;
end;
{ -------------------------------------------------------------------------- }
function AbRegisterZipExtension(App, ID, FileType : string; Replace : Boolean) : Boolean;
begin
  Result := False;
  if AbExistingZipAssociation and not Replace then
    Exit;
  try
    if (ID = '') then
      ID := DefZipID;
    if (FileType = '') then
      FileType := DefZipType;
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CLASSES_ROOT;
    Reg.OpenKey('',False);
    Reg.OpenKey(ZipExt, True);
    Reg.WriteString('', ID);
    Reg.OpenKey('\' + ID, True);
    Reg.WriteString('', FileType);
    Reg.OpenKey(OpenCommand, True);
    Reg.WriteString('', App);
    Reg.OpenKey('\' + DefaultIcon, True);
    Reg.WriteString('', App + ',0');
    Result := True;
  finally
    Reg.Free;
  end;
end;
{ -------------------------------------------------------------------------- }
{$IFDEF TRIALRUN}
initialization
  _TI_;
  {$IFNDEF VER110}
    _TR1_;
  {$ENDIF}
{$ENDIF TRIALRUN}

end.

