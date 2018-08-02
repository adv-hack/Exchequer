unit Progress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmProgress = class(TForm)
    Shape1: TShape;
    Label1: TLabel;
    lStatus: TLabel;
  private
    { Private declarations }
  public
    Procedure UpdateStatus(sStatus : string);
    { Public declarations }
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.dfm}

{ TfrmProgress }

procedure TfrmProgress.UpdateStatus(sStatus: string);
begin
  lStatus.Caption := sStatus;
  lStatus.Refresh;
end;

end.
