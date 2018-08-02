unit TFindFilesClass;

{******************************************************************************}
{ Given a folder name and a file mask, TFindFiles performs a standard          }
{ FindFirst, FindNext, FindClose operation and for each file found calls the   }
{ callback function with file name and file attributes.                        }
{                                                                              }
{ File types can be limited by setting the FileAttr property to, for example,  }
{ "faAnyFile - faDirectory". Alternatively, you can use "if not FileData.Folder" }
{ in the callback function to filter out the folders.                          }
{                                                                              }
{ If you want to use a wildcard file mask, e.g. *.txt and you also want to     }
{ recurse into subfolders you need to set FileMask to *.* and use              }
{ "if MatchesMask(FileName, '*.txt')" in the callback function.                }
{                                                                              }
{ All folder names are returned with the trailing backslash already present.   }
{                                                                              }
{ The callback function passes the full path and file name as the first        }
{ parameter which is equivalent to                                             }
{ FileData.FolderName + FileData.FileName;                                     }
{                                                                              }
{ Due to a "feature" of the Windows API, searching for *.htm (for example) will}
{ also return *.hmtl. You need to double-check that the extension matches the  }
{ one required.                                                                }
{******************************************************************************}

{$WARN SYMBOL_PLATFORM OFF}
interface

uses SysUtils;

type
  TFFFileData = record
    FolderName: string;
    FileName:   string;
    FileExt:    string;
    TimeStamp:  TDateTime;
    ReadOnly:   boolean;
    Hidden:     boolean;
    SysFile:    boolean;
    VolumeID:   boolean;
    Folder:     boolean;
    Archive:    boolean;
  end;

  TFFCallBack = function(FileName: string; FileData: TFFFileData): integer of object;

  TFindFiles = class(TObject)
  private
{* internal fields *}
    FFFCallBack: TFFCallBack;
{* property fields *}
    FRecurseSubFolders: boolean;
    FFileMask: string;
    FFolderName: string;
    FFileAttr: integer;
{* procedural methods *}
    function  ScanFolder(FolderName: string; FileMask: string): integer;
{* getters and setters *}
    procedure SetFileMask(const Value: string);
    procedure SetFolderName(const Value: string);
    procedure SetRecurseSubFolders(const Value: boolean);
    procedure SetFileAttr(const Value: integer);
    function  GetSysMsg: string;
    function  GetSysMsgSet: boolean;
    procedure SetSysMsg(Value: string);
  public
    function  FindFiles(FFCallBack: TFFCallBack): integer;
    property  FileAttr: integer read FFileAttr write SetFileAttr;
    property  FolderName: string read FFolderName write SetFolderName;
    property  FileMask: string read FFileMask write SetFileMask;
    property  RecurseSubFolders: boolean read FRecurseSubFolders write SetRecurseSubFolders;
    property  SysMsg: string read GetSysMsg;
    property  SysMsgSet: boolean read GetSysMsgSet;
  end;

implementation

uses TErrors;

{ TFindFiles }

{* Procedural Methods *}

function TFindFiles.ScanFolder(FolderName, FileMask: string): integer;
// N.B. FindFirst is a Borland Delphi wrapper for the FindFirstFile Win32 API
// call. FindFirst tries to map file attributes back to what they were under
// Delphi 1 & DOS.
// As a result, the faAnyFile attribute (decimal 32) usually works on XP.
// However, after performing a Windows Backup all my files got changed to have
// an attribute of decimal 128 (hex 80) which is the new FILE_ATTRIBUTE_NORMAL.
// Consequently, "(SR.Attr and FFileAttr) <> 0" was failing and Importer
// was reporting that no files matched. Hence the augmented test for attribute
// 128 below.
var
  SR: TSearchRec;
  RC: integer;
  FileData: TFFFileData;
begin
  result := 0;

  RC := FindFirst(FolderName + FileMask, faAnyFile, SR);

   while (RC = 0) and (result = 0) do begin
    if (SR.Name <> '.') and (SR.Name <> '..') then begin
      if ((SR.Attr and faDirectory) <> 0) and RecurseSubFolders then
        ScanFolder(IncludeTrailingPathDelimiter(FolderName + SR.Name), FileMask); // recurse into subfolder sr.name
      if ((SR.Attr and FFileAttr) <> 0) or ((SR.Attr = 128) and ((FFileAttr and faAnyFile) <> 0)) then begin // it matches the type of file the caller requested
        FileData.FolderName := FolderName;
        FileData.FileName   := SR.Name;
        if (SR.Attr and faDirectory) <> 0 then
          FileData.FileName := IncludeTrailingPathDelimiter(FileData.FileName);
        FileData.FileExt    := ExtractFileExt(SR.Name);
        FileData.TimeStamp  := FileDateToDateTime(SR.Time);
        FileData.ReadOnly   := (SR.Attr and faReadOnly)  <> 0; // lets make it easy for them
        FileData.Hidden     := (SR.Attr and faHidden)    <> 0;
        FileData.SysFile    := (SR.Attr and faSysFile)   <> 0;
        FileData.VolumeID   := (SR.Attr and faVolumeID)  <> 0;
        FileData.Folder     := (SR.Attr and faDirectory) <> 0;
        FileData.Archive    := (SR.Attr and faArchive)   <> 0;
        result := FFFCallBack(FolderName + FileData.FileName, FileData); // caller sets their function's result to non-zero to cancel
      end;
    end;
    RC := FindNext(SR);
  end;

  FindClose(SR);
end;

function TFindFiles.FindFiles(FFCallBack: TFFCallBack): integer;
begin
  FFFCallBack := FFCallBack;
  FFolderName := IncludeTrailingPathDelimiter(FFolderName);
  result := ScanFolder(FFolderName, FFileMask);
end;

{* getters and setters *}

procedure TFindFiles.SetFileMask(const Value: string);
begin
  FFileMask := Value;
end;

procedure TFindFiles.SetFolderName(const Value: string);
begin
  FFolderName := Value;
end;

procedure TFindFiles.SetRecurseSubFolders(const Value: boolean);
begin
  FRecurseSubFolders := Value;
end;

procedure TFindFiles.SetFileAttr(const Value: integer);
begin
  FFileAttr := Value;
end;

function TFindFiles.GetSysMsg: string;
begin
  result := TErrors.SysMsg;
end;

function TFindFiles.GetSysMsgSet: boolean;
begin
  result := TErrors.SysMsgSet;
end;

procedure TFindFiles.SetSysMsg(Value: string);
begin
  TErrors.SetSysMsg(Value);
end;

end.
