unit DBMultiList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uExDatasets, uComTKDataset, ExtCtrls, uMultiList,
  uDBMultiList;

type
  TfrmDBMultiList = class(TForm)
    Button1: TButton;
    DBMultiList1: TDBMultiList;
    ComTKDataset1: TComTKDataset;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDBMultiList: TfrmDBMultiList;

implementation

{$R *.dfm}

procedure TfrmDBMultiList.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmDBMultiList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := cafree;
end;

end.
