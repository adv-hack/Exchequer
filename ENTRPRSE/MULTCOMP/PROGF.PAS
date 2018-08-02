unit ProgF;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmProgress = class(TForm)
    Panel1: TPanel;
    lblProgress: TLabel;
  private
    { Private declarations }
    Procedure SetProgressText (Value : ShortString);
  public
    { Public declarations }
    Property ProgressText : ShortString Write SetProgressText;
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.DFM}

procedure TfrmProgress.SetProgressText(Value: ShortString);
begin
  lblProgress.Caption := Value;
  Refresh;
end;

end.
