unit closef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList;

type
  TfrmSchedCloseStatus = class(TForm)
    Panel1: TPanel;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DoTerminate : Boolean;
    procedure SetActiveLabel(WhichLabel : Byte; OK : Boolean);
    procedure IncProgress;
  end;

var
  frmSchedCloseStatus: TfrmSchedCloseStatus;

implementation

{$R *.dfm}
uses
  GlobVar;

procedure TfrmSchedCloseStatus.SetActiveLabel(WhichLabel : Byte; OK : Boolean);
var
  s : string;
  AL : TLabel;
begin
{  Case WhichLabel of
    0  : begin
           AL := lblPoller;
         end;
    1  : begin
           AL := lblQuery;
         end;
    2  : begin
           AL := lblConveyor;
         end;
  end;

  if not OK then
    s := 'Active'
  else
    s := 'Finished';

  if AL.Caption <>  s then
  begin
    AL.Caption := s;
    AL.Repaint;
  end;
  Application.ProcessMessages;}
end;


procedure TfrmSchedCloseStatus.FormCreate(Sender: TObject);
begin
  DoTerminate := False;


end;

procedure TfrmSchedCloseStatus.Button2Click(Sender: TObject);
begin
  DoTerminate := True;
  Caption := 'Please wait...Closing';
end;

procedure TfrmSchedCloseStatus.IncProgress;
begin
end;

end.
