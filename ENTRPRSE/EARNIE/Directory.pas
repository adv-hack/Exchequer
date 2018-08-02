unit Directory;

{ nfrewer440 16:25 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, Menus, Buttons, ImgList, FilCtl95;

type
  TFrmDirectory = class(TForm)
    ImageList1: TImageList;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    DirLstBox: TDirectory95ListBox;
    Drive95ComboBox1: TDrive95ComboBox;
    procedure BtnOKClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  private
    { Private declarations }
    fDirectory : String;
  public
    { Public declarations }
    property Directory : String read fDirectory write fDirectory;
  end;

var
  FrmDirectory: TFrmDirectory;

implementation

{$R *.DFM}

procedure TFrmDirectory.BtnOKClick(Sender: TObject);
begin
  directory := DirLstBox.Directory;
  ModalResult := mrOk;
end;

procedure TFrmDirectory.Exit1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmDirectory.BtnCancelClick(Sender: TObject);
begin
  directory := '';
  close;
end;

end.
