unit Progress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmProgress = class(TForm)
    Shape1: TShape;
    lTX: TLabel;
    lLine: TLabel;
  private
    { Private declarations }
  public
    Procedure UpdateLine(sText : string);
    { Public declarations }
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.dfm}

{ TfrmProgress }

procedure TfrmProgress.UpdateLine(sText : string);
begin
  lLine.Caption := sText;
  lLine.Refresh;
end;

end.
