unit filelock;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TfrmFileLocking = class(TForm)
    lTitle: TLabel;
    rbFilename: TRadioButton;
    rbExtension: TRadioButton;
    edFilename: TEdit;
    edExtension: TEdit;
    btnCancel: TButton;
    btnOK: TButton;
    cmbStockLockType: TComboBox;
    Label47: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    procedure rbFilenameClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFileLocking: TfrmFileLocking;

implementation

{$R *.DFM}

procedure TfrmFileLocking.rbFilenameClick(Sender: TObject);
begin
  edFilename.Enabled := rbFilename.Checked;
  edExtension.Enabled := rbExtension.Checked;
end;

end.
