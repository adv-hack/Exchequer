unit LogForm;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmSentinelLog = class(TForm)
    memLog: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddLine(const s : ShortString);
  end;

var
  frmSentinelLog: TfrmSentinelLog;

implementation

{$R *.DFM}

procedure TfrmSentinelLog.AddLine(const s : ShortString);
begin
  memLog.Lines.Add(s);
  Update;
end;

end.
