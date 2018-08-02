unit Progress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmProgress = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    lStatus: TLabel;
  private
    { Private declarations }
  public
    procedure UpdateStatus(sStatus : string);
    { Public declarations }
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.dfm}

{ TForm1 }

procedure TfrmProgress.UpdateStatus(sStatus: string);
begin
  if sStatus <> lStatus.Caption then
  begin
    lStatus.Caption := sStatus;
    lStatus.Refresh;
    application.ProcessMessages;
  end;{if}
end;

end.
