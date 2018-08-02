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
    l3: TLabel;
  private
    { Private declarations }
  public
    Procedure UpdateLine(iLine : integer; sText : string);
    { Public declarations }
  end;

{var
  frmProgress: TfrmProgress;}

implementation

{$R *.dfm}

{ TfrmProgress }

procedure TfrmProgress.UpdateLine(iLine : integer; sText : string);
begin
  case iLine of
    1 : begin
      l1.Caption := sText;
      l1.Refresh;
    end;

    2 : begin
      l2.Caption := sText;
      l2.Refresh;
    end;

    3 : begin
      l3.Caption := sText;
      l3.Refresh;
    end;
  end;{case}
end;

end.
