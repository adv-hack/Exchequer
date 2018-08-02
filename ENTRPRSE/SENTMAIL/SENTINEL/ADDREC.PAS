unit addrec;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmAddRecs = class(TForm)
    Panel1: TPanel;
    lblProgress: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FCancel : Boolean;
    FRunning : Boolean;
    procedure RecAdded(const s : string; ACount : longint; var Cancel : Boolean);
  public
    { Public declarations }
    UID : String;
    EName : String;
    DPath : string;
    procedure Run;
  end;

var
  frmAddRecs: TfrmAddRecs;

implementation

{$R *.dfm}
uses
  SentU;

procedure TfrmAddRecs.FormCreate(Sender: TObject);
begin
  FCancel := False;
  FRunning := False;
end;

procedure TfrmAddRecs.Button1Click(Sender: TObject);
begin
  FCancel := True;
end;

procedure TfrmAddRecs.RecAdded(const s : string; ACount : longint; var Cancel : Boolean);
begin
  lblProgress.Caption := s;
  Cancel := FCancel;
  lblProgress.Refresh;
  Application.ProcessMessages;
  if FCancel then
    PostMessage(Self.Handle,WM_Close,0,0);;
end;

procedure TfrmAddRecs.Run;
begin
  with TSentinelQuery.Create do
  begin
    Try
      ElertName := EName;
      User := UID;
      DirectMode := True;
      DataPath := DPath;
      EventKeyString := '';
      MarkRecs := RecAdded;
      AddExistingRecs := True;
      Run(True); //test mode
    Finally
      Free;
    End;
  end;
  PostMessage(Self.Handle,WM_Close,0,0);
end;//if res = 0



procedure TfrmAddRecs.FormActivate(Sender: TObject);
begin
  if not FRunning then
  begin
    FRunning := True;
    Run;
    Close;
  end;
end;

end.
