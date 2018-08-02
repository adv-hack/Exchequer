{*********************************************************}
{* ABBREVIA: USINGAPI.DPR                                *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

{$APPTYPE CONSOLE}

program UsingAPI;

{Build this app using the Define "BuildingStub", to keep it smaller!}

uses
  AbArcTyp, AbZipTyp, AbZipPrc, AbUnzPrc, Classes, SysUtils, AbUtils;

type
  THelper = class
  public
    procedure UnzipProc( Sender : TObject; Item : TAbArchiveItem;
                         const NewName : string );
    procedure ZipProc( Sender : TObject; Item : TAbArchiveItem;
                       OutStream : TStream );
    procedure ArchiveItemProgress( Sender: TObject;
                                   Item: TAbArchiveItem;
                                   Progress: Byte;
                                   var Abort: Boolean);
  end;

procedure THelper.ArchiveItemProgress( Sender: TObject;
  Item: TAbArchiveItem; Progress: Byte; var Abort: Boolean);
type
  TMethodStrings = array [ TAbZipCompressionMethod ] of string;
const
  MethodStrings : TMethodStrings = ('UnStoring', 'UnShrinking', 'UnReducing',
                                    'UnReducing', 'UnReducing', 'UnReducing',
                                    'Exploding', 'DeTokenizing', 'Inflating',
                                    'Enhanced Inflating', 'DCL Exploding',
                                    'Extracting');
var
  ActionString : string;
begin
  case Item.Action of

    aaAdd : ActionString := 'Adding  ';
    aaFreshen : ActionString := 'Freshening  ';
  else
    ActionString := MethodStrings[(Item as TAbZipItem).CompressionMethod] +
                    '  ';
  end;
  WriteLn( ActionString + Item.FileName );
end;

procedure THelper.UnzipProc( Sender : TObject; Item : TAbArchiveItem;
                             const NewName : string );
begin
  AbUnzip( Sender, TAbZipItem(Item), NewName );
end;

procedure THelper.ZipProc( Sender : TObject; Item : TAbArchiveItem;
                           OutStream : TStream );
begin
  AbZip( TAbZipArchive(Sender), TAbZipItem(Item), OutStream );
end;


var
  ZipFileName : string;
  OutDirectory : string;
  InDirectory : string;
  Mask : string;
  Archive : TAbZipArchive;
  Helper : THelper;
begin
  WriteLn;
  {usage: UsingAPI ZipFileName InDirectory Mask OutDirectory}
  if (ParamCount < 4) or
     ((ParamCount > 0) and (Pos('?', ParamStr(1))>0)) then begin
    WriteLn;
    WriteLn( '  Syntax: UsingAPI ZipFileName InDirectory Mask OutDirectory');
    Halt;
  end;

  ZipFileName := ParamStr(1);
  InDirectory := ParamStr(2);
  Mask := ParamStr(3);
  OutDirectory := ParamStr(4);
  {open the file}
  if FileExists( ZipFileName ) then begin
    Archive := TAbZipArchive.Create( ZipFileName,
                                     fmOpenReadWrite or fmShareDenyWrite );
    Archive.Load;
  end
  else
    Archive := TAbZipArchive.Create( ZipFileName,
                                     fmCreate or fmShareDenyNone );
  try
    Helper := THelper.Create;
    try
      {set the event handlers}
      Archive.InsertHelper := Helper.ZipProc;
      Archive.ExtractHelper := Helper.UnzipProc;
      Archive.OnArchiveItemProgress := Helper.ArchiveItemProgress;
      {set the BaseDirectory for input files}
      Archive.BaseDirectory := InDirectory;
      {add all the files in the BaseDirectory to the archive}
      Archive.AddFiles( Mask, 0 );
      {save the files to the zipfile}
      Archive.Save;
      {now, change the base directory to the output}
      Archive.BaseDirectory := OutDirectory;
      Archive.ExtractFiles( Mask );
    finally
      Helper.Free;
    end;
  finally
    Archive.Free;
  end;
end.
