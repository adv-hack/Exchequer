unit RepThrd1;

interface

uses
  ExBtTh1U, RptEngDll, RepEngIF, Classes, Dialogs;

type
  TReportThread = Object(TThreadQueue)
    oEngine : IReport_Interface;
    RepName, UserID, DataPath : ShortString;
    OutputFile : ShortString;
    MemStream : TMemoryStream;
    function Start : Boolean; virtual;
    procedure Process; virtual;
    procedure Finish; virtual;
    procedure Progress(PercentComplete : SmallInt; var AAbort : Boolean);
  end;

implementation

{ TReportThread }

procedure TReportThread.Finish;
begin
  inherited Finish;
end;

procedure TReportThread.Process;
begin
  inherited Process;
  oEngine.PrintReport(MemStream, RepName);
end;

function TReportThread.Start : Boolean;
begin
  oEngine := GetReportEngine;
  oEngine.CompanyDataSetPath := DataPath;
  oEngine.ProgressEvent := Progress;
  Result := oEngine.LoadReport(nil, UserID, RepName) = 0;
  if Result then
    MemStream := TMemoryStream.Create;
end;

procedure TReportThread.Progress(PercentComplete : SmallInt; var AAbort : Boolean);
begin
  if PercentComplete = 1 then
    InitProgress(100);
  ShowStatus(2, 'Processing report ' + RepName);
  UpdateProgress(PercentComplete);
end;

end.
