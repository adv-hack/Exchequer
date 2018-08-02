unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmShellTest = class(TForm)
    bnExecute: TButton;
    edFilename: TEdit;
    lblFileName: TLabel;
    procedure bnExecuteClick(Sender: TObject);
  end;

var
  frmShellTest: TfrmShellTest;

implementation

uses ShellAPI;

{$R *.dfm}

procedure TfrmShellTest.bnExecuteClick(Sender: TObject);
begin
  ShellExecute(Handle, '', 'C:\Development\WRListener\WRTransmit.exe', PChar('/silent /f:' + edFilename.Text), '', SW_SHOWNORMAL);
end;

end.
