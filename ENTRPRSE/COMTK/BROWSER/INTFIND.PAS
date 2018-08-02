unit intfind;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmIntFind = class(TForm)
    APanel: TPanel;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    cbOp: TComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmIntFind: TfrmIntFind;

implementation

{$R *.DFM}

end.
