unit Browse;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, FileCtrl;

type
  TFrmDirBrowse = class(TForm)
    lbDirectory: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    lDir: TLabel;
    procedure lbDirectoryChange(Sender: TObject);
    procedure DriveComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDirBrowse: TFrmDirBrowse;

implementation

{$R *.DFM}

procedure TFrmDirBrowse.lbDirectoryChange(Sender: TObject);
begin
  lDir.Caption := lbDirectory.Directory;
end;

procedure TFrmDirBrowse.DriveComboBox1Change(Sender: TObject);
begin
  lDir.Caption := lbDirectory.Directory;
end;

end.
