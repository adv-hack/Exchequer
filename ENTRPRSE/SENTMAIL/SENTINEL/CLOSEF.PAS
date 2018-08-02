unit closef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList, ANIMATE;

type
  TfrmCloseStatus = class(TForm)
    Panel1: TPanel;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    lblPoller: TLabel;
    lblQuery: TLabel;
    lblConveyor: TLabel;
    Animated1: TAnimated;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
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
  frmCloseStatus: TfrmCloseStatus;

implementation

{$R *.dfm}
uses
  GlobVar;

procedure TfrmCloseStatus.SetActiveLabel(WhichLabel : Byte; OK : Boolean);
var
  s : string;
  AL : TLabel;
begin
  AL := nil;
  Case WhichLabel of
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
  Application.ProcessMessages;
end;


procedure TfrmCloseStatus.FormCreate(Sender: TObject);
begin
  DoTerminate := False;

  With Animated1 do
  Begin
//    SetBounds(Left,Top,64,47);

    Loop:=True;
    Play:=Not NoXLogo;

    Visible:=Play;
  end;

end;

procedure TfrmCloseStatus.Button2Click(Sender: TObject);
begin
  DoTerminate := True;
  Caption := 'Please wait...Closing';
end;

procedure TfrmCloseStatus.IncProgress;
begin
end;

end.
