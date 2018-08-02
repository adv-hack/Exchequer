unit ConversionLogsF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseF, EnterToTab, StdCtrls, ExtCtrls, ComCtrls;

type
  TfrmConversionLogs = class(TfrmCommonBase)
    PageControl1: TPageControl;
    tabshLog: TTabSheet;
    tabshExceptions: TTabSheet;
    memLog: TMemo;
    Label1: TLabel;
    btnContinue: TButton;
    btnAbort: TButton;
    memErrors: TMemo;
    edtLogPath: TEdit;
    edtErrorsPath: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FLogPath : ShortString;
    procedure LoadLogs;
  public
    { Public declarations }
    Constructor Create (Const LogPath : ShortString);
  end;

implementation

{$R *.dfm}

//=========================================================================

Constructor TfrmConversionLogs.Create (Const LogPath : ShortString);
Begin // TfrmConversionLogs
  Inherited Create(NIL);
  FLogPath := LogPath;
  LoadLogs;
End; // TfrmConversionLogs

//-------------------------------------------------------------------------

procedure TfrmConversionLogs.FormCreate(Sender: TObject);
Begin // FormCreate
  inherited;
  Caption := Application.Title;

  PageControl1.ActivePage := tabshLog;
End; // FormCreate

//-------------------------------------------------------------------------

procedure TfrmConversionLogs.LoadLogs;
Begin // FormCreate
  memLog.Lines.LoadFromFile(FLogPath + 'SqlConversion.log');
  PostMessage(memLog.Handle, EM_SCROLL, SB_BOTTOM, 0);  // Move to bottom so the success/failed message is on screen
  edtLogPath.Text := FLogPath + 'SqlConversion.log';

  memErrors.Lines.LoadFromFile(FLogPath + 'SqlException.log');
  edtErrorsPath.Text := FLogPath + 'SqlException.log';
end;

procedure TfrmConversionLogs.FormResize(Sender: TObject);
begin
  inherited;

  btnContinue.Left := (ClientWidth Div 2) - 5 - btnContinue.Width;
  btnAbort.Left := btnContinue.Left + btnContinue.Width + 9;
end;

end.
