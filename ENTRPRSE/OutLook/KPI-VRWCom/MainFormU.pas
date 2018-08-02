unit MainFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VRWCOM_TLB;

const
  WM_PrintProgress = WM_USER + $101;
  WM_PrintAbort    = WM_USER + $102;
  WM_InPrint       = WM_USER + $103;
  WM_PreviewOpen  =  WM_USER + $104;
  WM_PreviewClosed = WM_USER + $105;

type
  TMainForm = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    AllowClose: Boolean;
    procedure WMPrintProgress(var Msg: TMessage); message WM_PrintProgress;
    procedure WMPreviewOpen(var Msg: TMessage); message WM_PreviewOpen;
    procedure WMPreviewClosed(var Msg: TMessage); message WM_PreviewClosed;
  public
    { Public declarations }
    ReportTree: IReportTree;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

{ TForm1 }

procedure TMainForm.WMPreviewClosed(var Msg: TMessage);
begin
  AllowClose := True;
  ReportTree := nil;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not AllowClose then
    Action := caNone;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  AllowClose := True;
end;

procedure TMainForm.WMPreviewOpen(var Msg: TMessage);
begin
  AllowClose := False;
end;

{ CJS 2012-09-03 - ABSEXCH-10815 - 49 - ODD - Printing via preview hangs }
procedure TMainForm.WMPrintProgress(var Msg: TMessage);
begin
  case Msg.WParam of
    // Return a message to let REPENGINE.DLL know that it is ok to print.
    4 : SendMessage(Msg.LParam, WM_InPrint, Ord(False),0);
  end;
end;

end.
