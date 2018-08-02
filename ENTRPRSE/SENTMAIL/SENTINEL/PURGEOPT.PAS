unit PurgeOpt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmPurgeOpts = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    chkHistory: TCheckBox;
    chkEvents: TCheckBox;
    chkOutput: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function GetPurgeOpts : Byte;


implementation

{$R *.dfm}

function GetPurgeOpts : Byte;
begin
  with TfrmPurgeOpts.Create(nil) do
  Try
    Result := 0;
    chkOutput.Checked := True;
    ShowModal;
    if ModalResult = mrOK then
    begin
      if chkHistory.Checked then
        Result := 1;
      if chkEvents.Checked then
        Result := Result or 2;
      if chkOutput.Checked then
        Result := Result or 4;
    end;
  Finally
    Free;
  End;
end;

end.
