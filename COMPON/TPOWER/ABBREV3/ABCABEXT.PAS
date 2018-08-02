{*********************************************************}
{* ABBREVIA: AbCabExt.pas 3.02                           *}
{* Copyright (c) TurboPower Software Co 1997, 2002       *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA: Cabinet file extractor component            *}
{*********************************************************}

unit AbCabExt;

{$I AbDefine.inc}

interface

uses
  SysUtils, Classes,
  AbCBrows, 
  AbArcTyp, AbUtils, AbCabTyp;

type
  TAbCustomCabExtractor = class(TAbCustomCabBrowser)
  protected {private}
    FExtractOptions : TAbExtractOptions;
    FOnConfirmOverwrite : TAbConfirmOverwriteEvent;

    procedure DoConfirmOverwrite(var Name : string;
                                 var Confirm : Boolean);
    procedure InitArchive;
      override;
    procedure SetExtractOptions( Value : TAbExtractOptions );

  protected {properties}
    property ExtractOptions : TAbExtractOptions
      read  FExtractOptions
      write SetExtractOptions
      default AbDefExtractOptions;
    property OnConfirmOverwrite : TAbConfirmOverwriteEvent
      read  FOnConfirmOverwrite
      write FOnConfirmOverwrite;

  public
    constructor Create( AOwner : TComponent ); override;
    destructor Destroy; override;

    procedure ExtractAt(Index : Integer; const NewName : string);
    procedure ExtractFiles(const FileMask : string);
    procedure ExtractFilesEx(const FileMask, ExclusionMask : string);
    procedure ExtractTaggedItems;
  end;

  TAbCabExtractor = class(TAbCustomCabExtractor)
  published
    property ArchiveProgressMeter;
    property BaseDirectory;
    property CabSize;
    property CurrentCab;
    property ExtractOptions;
    property FolderCount;
    property HasNext;
    property HasPrev;
    property ItemProgressMeter;
    property OnArchiveProgress;
    property OnArchiveItemProgress;
    property OnChange;
    property OnConfirmOverwrite;
    property OnConfirmProcessItem;
    property OnLoad;
    property OnProcessItemFailure;
    property OnRequestImage;
    property SetID;
    property TempDirectory;
    property Version;
    property FileName; {must be after OnLoad}
  end;
  {.Z+}


implementation

uses
  AbExcept;

{ TAbCustomCabExtractor ==================================================== }
constructor TAbCustomCabExtractor.Create(AOwner : TComponent);
begin
  inherited Create( AOwner );
  ExtractOptions := AbDefExtractOptions;
end;
{ -------------------------------------------------------------------------- }
destructor TAbCustomCabExtractor.Destroy;
begin
  inherited Destroy;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabExtractor.DoConfirmOverwrite
                                     (var Name : string;
                                      var Confirm : Boolean);
begin
  if Assigned(FOnConfirmOverwrite) then
    FOnConfirmOverwrite(Name, Confirm);
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabExtractor.ExtractAt(Index : Integer;
                                          const NewName : string);
  {extract a file from the archive that match the index}
begin
  if Assigned( CabArchive ) then
    CabArchive.ExtractAt( Index, NewName )
  else
    raise EAbNoArchive.Create;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabExtractor.ExtractFiles(const FileMask : string);
  {Extract files from the cabinet matching the filemask}
begin
  if Assigned( CabArchive ) then
    CabArchive.ExtractFiles( FileMask )
  else
    raise EAbNoArchive.Create;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabExtractor.ExtractFilesEx(const FileMask, ExclusionMask : string);
  {Extract files from the cabinet matching the FileMask, exluding those
   matching ExclusionMask}
begin
  if Assigned( CabArchive ) then
    CabArchive.ExtractFilesEx( FileMask, ExclusionMask )
  else
    raise EAbNoArchive.Create;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabExtractor.ExtractTaggedItems;
  {Extract items in the archive that have been tagged}
begin
  if Assigned( CabArchive ) then
    CabArchive.ExtractTaggedItems
  else
    raise EAbNoArchive.Create;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabExtractor.InitArchive;
  {Archive now points to the Cab file, update all Archive's properties...}
begin
  inherited InitArchive;
  if Assigned( CabArchive ) then begin
    {poperties}
    CabArchive.ExtractOptions     := FExtractOptions;
    {events}
    CabArchive.OnConfirmOverwrite := DoConfirmOverwrite;
  end;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabExtractor.SetExtractOptions( Value : TAbExtractOptions );
begin
  FExtractOptions := Value;
  if Assigned( FArchive ) then
    FArchive.ExtractOptions := Value;
end;
{ -------------------------------------------------------------------------- }

end.

