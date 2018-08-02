unit uCfNewDg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmCfNewDlg = class(TForm)
    Label1: TLabel;
    edtVolLbl: TEdit;
    Label2: TLabel;
    lbAllocSize: TListBox;
    btnCancel: TButton;
    btnOK: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCfNewDlg: TfrmCfNewDlg;

implementation

{$R *.DFM}

procedure TfrmCfNewDlg.FormShow(Sender: TObject);
begin
  lbAllocSize.ItemIndex := 2;
  edtVolLbl.SetFocus;  
end;

procedure TfrmCfNewDlg.btnOKClick(Sender: TObject);
begin
  if edtVolLbl.Text = '' then begin
    ShowMessage('Volume label required');
    edtVolLbl.SetFocus;
  end else
    ModalResult := mrOK;
end;

end.
