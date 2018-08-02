unit Patches;

{******************************************************************************}
{  ApplyUpdPatches will search for *.upd files in the executable's folder.     }
{  These contain modifications or additions to lines in Importer's main        }
{  settings file.                                                              }
{  Files will be processed in alphabetical order, so it is recommended that    }
{  they be named YYYYMMDD.upd so that multiple patches can be applied in the   }
{  order in which they were released to customers.                             }
{  Applied patch files will be moved to a \UpdArchv sub-folder.                }
{                                                                              }
{  Patch files are in standard INI-file format but must start with a [         }
{  Encrypted and unencrypted patch files can be applied.                       }
{  If the /plainout command-line parameter has not been used, each patch file  }
{  will be [re-]encrypted after it has been read.                              }
{  Patch files are moved to a UpdArchv sub-folder after they have been applied.}
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TfrmPatches = class(TForm)
    Label1: TLabel;
    lblPatchFile: TLabel;
    lblProgress: TLabel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
  private
{* Internal Fields *}
    FUpdFile: TStringList;
{* Property Fields *}
{* Procedural Methods *}
{* Getters and Setters *}
    procedure PatchFile(APatchFile: string);
    procedure ArchiveTheFile(APatchFile: string);
  public
  end;

procedure ApplyUpdPatches;

implementation

uses TIniClass, GlobalConsts, EntLicence;

{$R *.dfm}

procedure ApplyUpdPatches;
// find all the *.upd files in Importer's folder and apply each to the main settings file
var
  Path: string;
  rc: integer;
  sr: TSearchRec;
  UpdFiles: TStringList;
  i: integer;
  frmPatches: TFrmPatches;
begin
  Path := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  UpdFiles := TStringList.create;
  try
    rc := FindFirst(Path + '*.upd', faAnyFile - faDirectory, sr);
    while rc = 0 do begin
      if SameText(ExtractFileExt(sr.name), '.upd') then // Windows api will match *.upd with *.updx
        UpdFiles.Add(LowerCase(sr.name));
      rc := FindNext(sr);
    end;
    FindClose(sr);

    UpdFiles.Sorted := true;
    if UpdFiles.Count > 0 then begin
      frmPatches := TfrmPatches.Create(nil);
      try
        for i := 0 to UpdFiles.Count - 1 do
          frmPatches.PatchFile(Path + UpdFiles[i]);
      finally
        frmPatches.Free;
      end;
      IniFile.Free;           // writes the changes to disk
      IniFile := TIni.create; // recreates the global object
    end;

  finally
    UpdFiles.free;
  end;
end;

{ TfrmPatches }

{* Procedural Methods *}

procedure TfrmPatches.ArchiveTheFile(APatchFile: string);
var
  Path: string;
begin
  Path := IncludeTrailingPathDelimiter(ExtractFilePath(APatchFile));
  Path := Path + 'UpdArchv\';           // and archive it
  if ForceDirectories(Path) then begin
    Path := Path + ExtractFileName(APatchFile);
    MoveFileEx(pchar(APatchFile), pchar(Path),
              MOVEFILE_COPY_ALLOWED        {allows file to be moved to different drive}
              or MOVEFILE_REPLACE_EXISTING {not sure}
              or MOVEFILE_WRITE_THROUGH    {function doesn't return until the file has actually been moved on disk}
              );
  end;
end;

procedure TfrmPatches.PatchFile(APatchFile: string);
// The patch file is in standard ini-file format.
// read through it line by line to find [Sections] or Key=Value pairs.
// Apply them to Importer's settings file via IniFile.
var
  i: integer;
  CurrentLine: string;
  CurrentSection: string;
  IniKey: string;
  IniValue: string;
  PosEquals: integer;
  MS: TMemoryStream;
begin
  SetWindowPos(self.handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
  lblPatchFile.Caption := APatchFile;
  application.ProcessMessages;
  if FileExists(APatchFile) then begin
    FUpdFile := TStringList.create;
    try
      MS := IniFile.DecryptIniFile(APatchFile, true); // decrypt the patch file. TRUE= decrypt to a stream
      FUpdFile.LoadFromStream(MS); MS.Free;           // load the stringlist from the stream
      CurrentSection := '';
      for i := 0 to FUpdFile.Count - 1 do begin
        CurrentLine := trim(FUpdFile[i]);
        if CurrentLine = '' then continue; // ignore blank lines

        if CurrentLine[1] = '[' then begin            // here's a section name
          CurrentSection := copy(CurrentLine, 2, pos(']', CurrentLine) - 2);
          if (CurrentLine[Length(CurrentLine)] = '-') then // if the section name is suffixed by a minus sign, delete the section
            IniFile.EraseSection(CurrentSection);
          continue;
        end;

        if CurrentSection = '' then continue; // find the first section header

        PosEquals := pos('=', CurrentLine);   // split the key=value line in two
        IniKey   := copy(CurrentLine, 1, PosEquals - 1);
        IniValue := copy(CurrentLine, PosEquals + 1, Length(CurrentLine) - PosEquals);
        if IniKey[1] = '-' then begin // if the key name is prefixed by a minus sign, delete the key from the section
          delete(IniKey, 1, 1);
          IniFile.DeleteKey(CurrentSection, IniKey);
        end
        else
          IniFile.WriteString(CurrentSection, IniKey, IniValue); // else write the string to Importer's settings file
        application.ProcessMessages;
      end;
    finally
      FUpdFile.Free;
    end;

    if not PlainOut then
      IniFile.EncryptIniFile(APatchFile) // encrypt the patch file if it wasn't already
    else
      IniFile.DecryptIniFile(APatchFile, false); // we decrypted to a stream earlier

    ArchiveTheFile(APatchFile);
  end;
end;

{* Event Procedures *}

{* Getters and Setters *}

procedure TfrmPatches.FormCreate(Sender: TObject);
begin
  if EnterpriseLicence.IsLITE then
    caption := 'IRIS Accounts Office Importer ' + APPVERSION
  else
    caption := 'Exchequer Importer ' + APPVERSION;
end;
end.
