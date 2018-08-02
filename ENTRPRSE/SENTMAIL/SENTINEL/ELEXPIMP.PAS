unit ElExpImp;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes, ElObjs, SysUtils, Dialogs;

const
  ieOK        = 0;
  ieCancelled = 1;

  ieErrorNoFileName = 1001;
  ieErrorOpeningFile = 1002;

type
  TNotifyProgressProc = procedure(const Msg : ShortString;
                                  Count, Total : SmallInt);

  TElertImporterExporter = Class
  protected
    FFileName : AnsiString;
    FOnProgress : TNotifyProgressProc;
    FSentList : TStringList;
    FElert, TempElert : TElertObject;
    FOutput : TOutput;
    FAddress : TAddress;
    FSMS : TSMS;
    FUser : ShortString;
    FErrorString : AnsiString;
  public
    constructor Create;
    destructor Destroy; override;
    function GetList : Boolean; virtual; abstract;
    function Process : SmallInt; virtual; abstract;
    function Execute : SmallInt;
    function ErrorMessage(Res : SmallInt) : ShortString;
    function Version : ShortString;
    property FileName : AnsiString read FFileName write FFileName;
    property OnProgress : TNotifyProgressProc read FOnProgress write FOnProgress;
    property User : ShortString read FUser write FUser;
  end;

  TElertImporter = Class(TElertImporterExporter)
  protected
    FTrailerPos : Longint;
  public
    function GetList : Boolean; override;
    function Process : SmallInt; override;
  end;

  TElertExporter = Class(TElertImporterExporter)
  public
    SaveDlg : TSaveDialog;
    function GetList : Boolean; override;
    function Process : SmallInt; override;
  end;


implementation

uses
  SelectF, Controls, ElVar;

constructor TElertImporterExporter.Create;
begin
  inherited Create;
  FSentList := TStringList.Create;
  FFileName := '';
  FOnProgress := nil;
end;

destructor TElertImporterExporter.Destroy;
begin
  if Assigned(FSentList) then
    FSentList.Free;
end;

function TElertImporterExporter.Execute : SmallInt;
begin
  Try
    if GetList then
      Result := Process
    else
      Result := ieCancelled;
  Except
    Result := ieErrorOpeningFile;
  End;
end;

function TElertImporterExporter.ErrorMessage(Res : SmallInt) : ShortString;
begin
  Case Res of
    ieCancelled          : Result := 'The operation was cancelled';
    ieErrorNoFileName    : Result := 'No filename was selected';
    ieErrorOpeningFile   : Result := 'The program was unable to open the file '#10 +
                                     FFilename;
    else
      Result := 'Error ' + IntToStr(Res) + ' occurred';
  end;//case
end;

function TElertImporterExporter.Version : ShortString;
var
  i : integer;
begin
  Result := ElVersion;
  i := 1;
  while i < Length(Result) do
    if not (Result[i] in ['0'..'9']) then
      Delete(Result, i, 1)
    else
      inc(i);
end;

{======================   Importer         ====================================}

function TElertImporter.GetList : Boolean;
var
  FileHeader : TElertExportFileHeader;
  FileTrailer : TElertFileTrailerRec;
  F : File;
  Res : SmallInt;
  SentinelsAllowed : SmallInt;
begin
  with TfrmSelectSent.Create(nil) do
  Try
    Caption := 'Select Sentinels to import';
    lblInclude.Caption := 'Sentinels to import:';
    lblFile.Caption := 'File: ' + FFileName;
    Result := False;
    FillChar(FileHeader, SizeOf(FileHeader), #0);
    FillChar(FileTrailer, SizeOf(FileTrailer), #0);
  {$I-}
    FileMode := 0;
    AssignFile(F, FFileName);
    Reset(F, 1);
    Try
      if IOResult <> 0 then
        raise Exception.Create('Error opening ' + FFileName);

      BlockRead(F, FileHeader, SizeOf(FileHeader));
      Seek(F, FileHeader.TrailerPos);
      FTrailerPos := FileHeader.TrailerPos;
      while not EOF(F) do
      begin
        BlockRead(F, FileTrailer, SizeOf(FileTrailer));
        lbAvailable.Items.AddObject(FileTrailer.ElertName, TObject(FileTrailer.ElertPos));
      end;
      ShowModal;
      Result := ModalResult = mrOK;

      if Result then
      begin
        FSentList.Clear;
        FSentList.AddStrings(lbInclude.Items);
        SentinelsAllowed := NoOfUnusedSentinels;
        if FSentList.Count > SentinelsAllowed then
        begin
           ShowNoSentinelsLeftMessage;
           while (FSentList.Count > 0) and (FSentList.Count > SentinelsAllowed) do
             FSentList.delete(FSentList.Count - 1);
        end;
      end;

    Finally
      CloseFile(F);
    End;
  Finally
    Free;
  End;
{$I+}

end;

function TElertImporter.Process : SmallInt;
var
  F : File;
  BlockHead : TElertExportBlockHeader;
  i : integer;
  CurrentElertName : ShortString;

  function ReadLine(E : TElertBaseObject) : SmallInt;
  begin
    Result := E.ReadFromFile(F);
    if Result = 0 then
    begin
      E.UserID := FUser;
      E.ElertName := FElert.ElertName;
      Result := E.Add;
    end;
  end;

  procedure GetUniqueName;
  var
    q : integer;
    s : ShortString;
    sq : ShortString;
  begin
    q := 1;
    s := FSentList[i];
    TempElert.UserID := FUser;
    TempElert.ElertName := s;
    sq := '';
    while TempElert.GetEqual(TempElert.ElertName) = 0 do
    begin
      inc(q);
      sq :=  '(' + IntToStr(q) + ')';

      TempElert.ElertName := Copy(s, 1, 30 - Length(sq)) + sq;
    end;
    FElert.ElertName := Copy(s, 1, 30 - Length(sq)) + sq;
  end;

begin
{$I-}
  Result := 0;
  AssignFile(F, FFileName);
  Reset(F, 1);
  FElert := TElertObject.Create;
  TempElert := TElertObject.Create;
  FOutput := TOutput.Create;
  FAddress := TAddress.Create;
  FSMS := TSMS.Create;
  Try
    if IOResult <> 0 then
      raise Exception.Create('Error opening ' + FFileName);

    for i := 0 to FSentList.Count - 1 do
    begin
      Seek(F, LongInt(FSentList.Objects[i]));
      BlockRead(F, BlockHead, SizeOf(BlockHead));
      Result := FElert.ReadFromFile(F);
      if Result = 0 then
      begin
        FElert.UserID := FUser;
        GetUniqueName;
        FElert.LastDateRun := 0;
        FElert.NextRunDue := FElert.GetNextRunDue(False);
        FElert.Status := esIdle;
        FElert.Active := False;
        Result := FElert.Add;

        if Result = 0 then
        begin

          BlockRead(F, BlockHead, SizeOf(BlockHead));
          while (FilePos(F) <= FTrailerPos) and (BlockHead.BlockType <> '!') do
          begin
            Case BlockHead.BlockType of
              pxElOutput : Result := Result + ReadLine(FOutput);
              pxElEmail  : Result := Result + ReadLine(FAddress);
              pxElSMS    : Result := Result + ReadLine(FSMS);
            end;

            BlockRead(F, BlockHead, SizeOf(BlockHead));
          end;

          if Result <> 0 then
            Break;
        end;
      end;



    end;
  Finally
    FElert.Free;
    TempElert.Free;
    FOutput.Free;
    FAddress.Free;
    FSMS.Free;

    CloseFile(F);
  End;
{$I+}
end;

{======================   Exporter         ===================================}


function TElertExporter.GetList : Boolean;
var
  Res : Smallint;
begin
  with TfrmSelectSent.Create(nil) do
  Try
    Caption := 'Select Sentinels to export';
    lblInclude.Caption := 'Sentinels to export:';
    lblFile.Caption := 'File: ' + FFileName;
    FElert := TElertObject.Create;
    Try
      with FElert do
      begin
        UserID := FUser;
        Index := 0;
        Res := GetFirst;
        while Res = 0 do
        begin
          lbAvailable.Items.Add(ElertName);

          Res := GetNext;
        end;
      end;
    Finally
      FElert.Free;
    End;
    ShowModal;
    Result := ModalResult = mrOK;

    if Result then
    begin
      FSentList.Clear;
      FSentList.AddStrings(lbInclude.Items);
    end;
  Finally
    Free;
  End;
end;

function TElertExporter.Process : SmallInt;
var
  Res, i : SmallInt;
  FileHeader : TElertExportFileHeader;
  TrailerRec : TElertFileTrailerRec;
  F : File;
  TrailerPos : longint;

  function WriteLines(E : TElertBaseObject) : SmallInt;
  var
    R : SmallInt;
  begin
    Result := 0;
    E.UserID := FElert.UserID;
    E.ElertName := FElert.ElertName;
    R := E.GetFirst;
    while R = 0 do
    begin
      if (E.Prefix <> pxElOutput) or not (TOutput(E).TypeChar in Outputs2Go) then
        Result := Result + E.WriteToFile(F);

      R := E.GetNext;
    end;
  end;

  function GetFileName : Boolean;
  begin
    Result := False;
    if Assigned(SaveDlg) then
     Result := SaveDlg.Execute;
    if Result then
      FFileName := SaveDlg.FileName;
  end;


begin
  if GetFileName then
  begin
  {$I-}
    AssignFile(F, FFileName);
    Rewrite(F, 1);
    Result := IOResult;
    if Result = 0 then
    begin
      FillChar(FileHeader, SizeOf(FileHeader), #0);
      FileHeader.NoOfSentinels := FSentList.Count;
      FileHeader.Version := Version;
      BlockWrite(F, FileHeader, SizeOf(FileHeader));
      FElert := TElertObject.Create;
      FOutput := TOutput.Create;
      FAddress := TAddress.Create;
      FSMS := TSMS.Create;
      Try
        for i := 0 to FSentList.Count - 1 do
        begin
          FSentList.Objects[i] := TObject(FilePos(F));
          FElert.UserID := FUser;
          FElert.ElertName := FSentList[i];
          Res := FElert.GetEqual(FSentList[i]);
          if Res = 0 then
          begin
            Result := FElert.WriteToFile(F);
            Result := Result + WriteLines(FOutput);
            Result := Result + WriteLines(FAddress);
            Result := Result + WriteLines(FSMS);
          end;

          if Assigned(FOnProgress) then
            FOnProgress(FSentList[i], i, FSentList.Count);

          if Result <> 0 then
            Break;

        end;
        if Result = 0 then
        begin
          TrailerPos := FilePos(F);
          FillChar(TrailerRec, SizeOf(TrailerRec), #0);
          for i := 0 to FSentList.Count - 1 do
          begin
            TrailerRec.ElertName := FSentList[i];
            TrailerRec.ElertPos := LongInt(FSentList.Objects[i]);
            BlockWrite(F, TrailerRec, SizeOf(TrailerRec));
            Result := Result + IOResult;
          end;

          if Result = 0 then
          begin
            FileHeader.TrailerPos := TrailerPos;
            Seek(F, 0);
            BlockWrite(F, FileHeader, SizeOf(FileHeader));
            Result := IOResult;
          end;
        end;
      Finally
        FElert.Free;
        FOutput.Free;
        FAddress.Free;
        FSMS.Free;
        CloseFile(F);
      End;
    end;
  {$I+}
  end
  else
    Result := ieCancelled;
end;





end.
