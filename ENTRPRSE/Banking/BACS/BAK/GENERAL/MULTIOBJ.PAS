unit multiobj;
{Ancestor object for export objects where we are limited to a certain number of records per
file.  Create method of descendant objects needs to set the number of records & files allowed
and the preferred file extension.  In general descendants will create an array of data
records and fill it during the writerec method.  When the max number of records is reached
or when contra is called the object should call the WriteBatch method: this calls three
methods - NewFile to create the file to write to, WriteData (this is abstract and should be
defined by the descendant to write headers, data records and trailers to the file), and
CloseExportFile which closes the file.  The only problem I can foresee is if the records
per file is too large to be efficiently put in an array.  In that case the descendant will
need to deal with it by changing the WriteRec method and overriding WriteBatch}
interface

uses
  ExpObj, Classes, CustAbsU;

type
  TMultiFileExportObject = Class(TExportObject)
    protected
      FileCount    : integer;
      FilePrefix   : shortstring;
      PayCount     : Word;
      FileList     : TStringList;
      RecsPerFile,
      FMaxFiles    : integer;
      Ext          : string[4]; {file extension}
      function WriteBatch(const EventData : TAbsEnterpriseSystem) : Boolean; virtual;
      function NewFile(const EventData : TAbsEnterpriseSystem) : Boolean;
      function CloseExportFile : integer;
      function WriteData(const EventData : TAbsEnterpriseSystem) : Boolean; virtual; abstract;
    public
      constructor Create;
      destructor Destroy; override;
      function CreateOutFile(const AFileName : string;
                             const EventData :
                             TAbsEnterpriseSystem) : integer; override;
      function CloseOutFile : integer; override;
      procedure CompletionMessage(const EventData : TAbsEnterpriseSystem); override;
    end;


implementation

uses
  SysUtils;

constructor TMultiFileExportObject.Create;
{Descendants must add their own constructor to set FMaxFiles,RecsPerFile & Ext}
begin
  inherited Create;
  FileList := TStringList.Create;
  FileCount := 0;
  PayCount := 0;
end;

destructor TMultiFileExportObject.Destroy;
begin
  if Assigned(FileList) then
    FileList.Free;
  inherited Destroy;
end;

function TMultiFileExportObject.WriteBatch(const EventData : TAbsEnterpriseSystem) : Boolean;
var
  RecResult : Boolean;
begin
  Result := NewFile(EventData); {opens new out file}
  if Result then
  begin
    FileList.Add('  ' + OutFileName);
    RecResult := WriteData(EventData);
    Result := RecResult and (CloseExportFile = 0);
  end;
end;

function TMultiFileExportObject.NewFile(const EventData : TAbsEnterpriseSystem) : Boolean;
{create and open files: FilePrefix + FileCount + Ext. Increment file count}
var
  FName : string;
begin
  inc(FileCount);
  if FileCount > FMaxFiles then
  begin
    ShowExportMessage('Error','Maximum number of files reached', 'Run aborted');
    Result := False;
  end
  else
  begin
    FName := FilePrefix + ZeroesAtFront(FileCount, 5);
    Result := (inherited CreateOutFile(FName + Ext, EventData) = 0);
  end;
end;

procedure TMultiFileExportObject.CompletionMessage(const EventData : TAbsEnterpriseSystem);
var
  ReportMemo : TStringList;
  TotalValue : Real;
begin
  if Failed = 0 then
  with EventData do
  begin
     ReportMemo := TStringList.Create;
     Try
       ReportMemo.Add(Setup.ssUserName);
       ReportMemo.Add('Batch processing run no. ' + IntToStr(ProcControl.PayRun));
       ReportMemo.Add('');
       ReportMemo.Add('Total number of transactions: ' + IntToStr(TransactionsWritten));
       TotalValue := TotalPenceWritten / 100;
       ReportMemo.Add('Value: ' + TrimRight(ProcControl.PayCurr) +
            Format('%.2n',[TotalValue]));
       ReportMemo.Add('');

       ReportMemo.Add('Batch process completed successfully');
       ReportMemo.Add('Written to file(s): ');
       ReportMemo.AddStrings(FileList);
       ReportMemo.Add('');
       ReportMemo.Add('Press ''Close'' to continue printing reports');
       ShowExportReport('Batch processing run no. ' + IntToStr(ProcControl.PayRun),
                         ReportMemo);
     Finally
      ReportMemo.Free;
     End;
  end;
end;

function TMultiFileExportObject.CreateOutFile(const AFileName : string;
                                              const EventData :
                                        TAbsEnterpriseSystem) : integer;
begin
  FilePrefix := RequiredPath + Copy(FileNameOnly(AFilename), 1, 3);
  Result := 0; {Files are opened in WriteBatch method}
end;

function TMultiFileExportObject.CloseOutFile : integer;
begin
  Result := 0; {closing files is done in the WriteBatch method}
end;

function TMultiFileExportObject.CloseExportFile : integer;
begin
  Result := inherited CloseOutFile;
end;






end.
