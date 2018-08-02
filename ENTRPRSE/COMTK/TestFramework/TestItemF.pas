unit TestItemF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfrmTestItem = class(TForm)
    Panel1: TPanel;
    edtTestName: TEdit;
    edtApp: TEdit;
    chkRun: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    chkCompareDB: TCheckBox;
    chkCompareRes: TCheckBox;
    edtResult: TEdit;
    edtExtra: TEdit;
    Label3: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure chkCompareResClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTestItem: TfrmTestItem;

implementation

{$R *.dfm}

procedure TfrmTestItem.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    edtApp.Text := OpenDialog1.Filename;
end;

procedure TfrmTestItem.chkCompareResClick(Sender: TObject);
begin
  edtResult.Enabled := chkCompareRes.Checked;
end;

end.
