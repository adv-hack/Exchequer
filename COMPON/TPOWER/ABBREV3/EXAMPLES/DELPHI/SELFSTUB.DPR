{*********************************************************}
{* ABBREVIA: SELFSTUB.DPR                                *}
{* Copyright (c) TurboPower Software Co 1999             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

(* This program creates a ZIP stub called SELFEX.EXE. This
stub can then be used to create self-extracting ZIP files.
For more information on self-extracting ZIPs and ZIP stubs see
page 112 in the Abbrevia manual. *)

program Selfstub;

{$APPTYPE CONSOLE}

uses
  AbArcTyp,
  AbUnzPrc,
  AbUtils,
  AbZipTyp,
  SysUtils;

type
  THelper = class
  public
    procedure UnzipProc(Sender : TObject;
                        Item : TAbArchiveItem;
                        const NewName : string);
  end;

procedure THelper.UnzipProc(Sender : TObject;
                            Item : TAbArchiveItem;
                            const NewName : string);
begin
  AbUnzip(Sender, TAbZipItem(Item), NewName);
end;

{Build this app using the Define "BuildingStub", to keep it smaller!}

var
  ZipArchive : TAbZipArchive;
  Helper : THelper;
begin
  WriteLn( 'Abbrevia Self Extracting Archive' );
  ZipArchive := TAbZipArchive.Create(ParamStr(0),
                                     fmOpenRead or fmShareDenyNone);
  ChDir( ExtractFilePath(ParamStr(0)));
  Helper := THelper.Create;
  try
    ZipArchive.Load;
    ZipArchive.ExtractHelper := Helper.UnzipProc;
    ZipArchive.ExtractFiles('*.*');
  finally
    Helper.Free;
    ZipArchive.Free;
  end;
end.
