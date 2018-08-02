unit Basedlgu;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, FileCtrl, ExtCtrls;

type
  TBaseDlg = class(TForm)
    Bevel1: TBevel;
    DirectoryListBox1: TDirectoryListBox;
    CancelBtn: TButton;
    OkBtn: TButton;
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    BaseDirectory : string;
  end;

var
  BaseDlg: TBaseDlg;

implementation

{$R *.DFM}


procedure TBaseDlg.DirectoryListBox1Change(Sender: TObject);
begin
  BaseDirectory := DirectoryListBox1.Directory;
end;

procedure TBaseDlg.FormShow(Sender: TObject);
begin
  DirectoryListBox1.Directory := BaseDirectory;
end;

end.
