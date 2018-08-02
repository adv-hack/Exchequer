unit uCfGenDg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmCfGenDlg = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    btnCancel: TButton;
    btnOK: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCfGenDlg: TfrmCfGenDlg;

implementation

{$R *.DFM}

procedure TfrmCfGenDlg.btnOKClick(Sender: TObject);
begin
  if Edit1.Text <> '' then
    ModalResult := mrOK;
end;

procedure TfrmCfGenDlg.FormShow(Sender: TObject);
begin
  Edit1.Text := '';
  Edit1.SetFocus;
end;

end.
