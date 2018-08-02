unit QBConvertF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type

  //Progress form for running the Qty Break converter. ABSEXCH-9795
  TfrmQtyBreakProgress = class(TForm)
    Label1: TLabel;
    lblProgress: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FirstTime : Boolean;
    FErrStr : string;
    FLogFile : TextFile;
    FRes : Integer;
    //Handle message posted on first activate
    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_User+1;
    //Main function
    procedure ConvertQtyBreaks;
    procedure DoProgress(Sender : TObject; const sMessage : string);
  public
    { Public declarations }
    property ErrorString : string read FErrStr write FErrStr;
    property Res : integer read FRes write FRes;
  end;

  function ConvertQuantityBreaks(Var RErrStr   :  String)  :  Integer; STDCALL; Export;


implementation

{$R *.dfm}
uses
  VarConst, QtyBreakConverter;


function ConvertQuantityBreaks(Var RErrStr   :  String)  :  Integer;
begin

  with TfrmQtyBreakProgress.Create(Application) do
  Try
    ShowModal;
    Result := Res;
    RErrStr := ErrorString;
  Finally
    Free;
  End;
end;


{ TfrmIdxProgress }


procedure TfrmQtyBreakProgress.WMCustGetRec(var Message: TMessage);
begin
  ConvertQtyBreaks;
end;

procedure TfrmQtyBreakProgress.FormActivate(Sender: TObject);
begin
  //Post message to
  if FirstTime then
  begin
    FirstTime := False;
    PostMessage(Self.Handle, WM_USER + 1, 0, 0);
  end;
end;

procedure TfrmQtyBreakProgress.FormCreate(Sender: TObject);
begin
  FirstTime := True;
end;


procedure TfrmQtyBreakProgress.ConvertQtyBreaks;
begin
  with TQtyBreakConverter.Create do
  Try
    OnProgress := DoProgress;
    FRes := Execute;
    if FRes = 0 then
    begin
      if HasUnconvertedBreaks then
        ErrorString := 'It was not possible to convert all Qty Breaks. Please check the log file for details.';
    end
    else
      ErrorString := 'There was an error while converting the QtyBreaks: ' + QuotedStr(ExceptionString);
  Finally
    Free;
    PostMessage(Self.Handle, WM_CLOSE, 0, 0);
  End;
end;

procedure TfrmQtyBreakProgress.DoProgress(Sender: TObject;
  const sMessage: string);
begin
  lblProgress.Caption := sMessage;
  lblProgress.Refresh;
  Application.ProcessMessages;
end;

end.
