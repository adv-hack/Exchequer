unit LogView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom;

type
  TfrmLogView = class(TForm)
    memLog: TMemo;
    SBSButton1: TSBSButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogView: TfrmLogView;

  procedure ShowLog(const LogName : string);

implementation

{$R *.dfm}

procedure ShowLog(const LogName : string);
begin
  with TfrmLogView.Create(nil) do
  Try
    memLog.lines.LoadFromFile(LogName);
    Caption := 'View Log - ' + LogName;
    ShowModal;
  Finally
    Free;
  End;
end;

end.
