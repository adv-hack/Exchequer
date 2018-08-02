unit ReportProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TfrmReportProgress = class(TForm)
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    lReport: TLabel;
    lProgress: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    bCancel : boolean;
  public
//    procedure OnReportProgress(PercentComplete : SmallInt; var AAbort : Boolean);
    procedure OnReportProgress(Count, Total : integer; Var Abort : Boolean);
    procedure UpdateStatus(sStatus : string);
  end;

var
  frmReportProgress: TfrmReportProgress;

implementation

{$R *.dfm}


//procedure TfrmReportProgress.OnReportProgress(PercentComplete : SmallInt; var AAbort : Boolean);
procedure TfrmReportProgress.OnReportProgress(Count, Total : integer; Var Abort : Boolean);
var
  PercentComplete : integer;
begin
  if not Visible then
  begin
    Cursor := crArrow;
    Screen.Cursor := crDefault;
    UpdateStatus('Printing Report');
    Show;
  end;
  if Total > 0 then
  begin
    PercentComplete := Round((Count / Total) * 100);

    if PercentComplete <> ProgressBar1.Position then
    begin
      ProgressBar1.Position := PercentComplete;
      ProgressBar1.Refresh;

      lProgress.Caption := IntToStr(PercentComplete) + ' %';
      lProgress.Refresh;

      Application.ProcessMessages;
    end;{if}
  end;{if}
  Abort := bCancel;
end;


procedure TfrmReportProgress.Button1Click(Sender: TObject);
begin
  bCancel := TRUE;
end;

procedure TfrmReportProgress.FormCreate(Sender: TObject);
begin
  bCancel := FALSE;
  Cursor := crHourGlass;
end;

procedure TfrmReportProgress.UpdateStatus(sStatus: string);
begin
  lProgress.Caption := sStatus;
  lProgress.Refresh;
  application.ProcessMessages;
end;

end.
