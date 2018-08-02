unit PIIProgressF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PIIScannerIntf, StdCtrls, AdvProgressBar, ExtCtrls;

type
  TfrmPIIProgress = class(TForm)
    Label1: TLabel;
    barProgress: TAdvProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPIIProgress: TfrmPIIProgress;

implementation

{$R *.dfm}

procedure TfrmPIIProgress.FormCreate(Sender: TObject);
begin
  ClientWidth := 318;
  ClientHeight := 57;
  barProgress.Animated := True;
end;

procedure TfrmPIIProgress.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  barProgress.Animated := False;
  Action := caFree;
end;

end.
