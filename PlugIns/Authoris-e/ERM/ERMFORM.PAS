unit ErmForm;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, AuthObjs;

type
  TfrmERM = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    Monitor : TPaEARMonitor;
  public
    { Public declarations }
  end;

var
  frmERM: TfrmERM;

implementation

{$R *.DFM}

procedure TfrmERM.FormCreate(Sender: TObject);
begin
  Monitor := TPaEARMonitor.Create;
  //Monitor.DeleteExpiredEARs;
end;

procedure TfrmERM.Button1Click(Sender: TObject);
begin
  Monitor.Start;
end;

procedure TfrmERM.Button2Click(Sender: TObject);
begin
  Monitor.Stop;
end;

end.
