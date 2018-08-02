unit Progress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmProgress = class(TForm)
    Shape1: TShape;
    l1: TLabel;
    l2: TLabel;
  private
    { Private declarations }
  public
    Procedure UpdateLine1(sText : string);
    Procedure UpdateLine2(sText : string);
    { Public declarations }
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.dfm}

{ TfrmProgress }

procedure TfrmProgress.UpdateLine1(sText : string);
begin
  l1.Caption := sText;
  l1.Refresh;
end;

procedure TfrmProgress.UpdateLine2(sText : string);
begin
  l2.Caption := sText;
  l2.Refresh;
end;

end.
