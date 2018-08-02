unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExScheduler_TLB, ComObj, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    oTask : IScheduledTask;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  oTask := CreateOLEObject('PlugTest.ScheduleTest') as IScheduledTask;

  if Assigned(oTask) then
  begin
    oTask.stDataPath := 'Blah';
    ShowMessage(oTask.stDataPath);
    oTask := nil;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  oTask := nil;
end;

end.
