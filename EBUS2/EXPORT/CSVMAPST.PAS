unit csvmapst;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, eBusUtil;

type
  TfrmCSVMapStart = class(TForm)
    rbOpen: TRadioButton;
    rbNew: TRadioButton;
    panType: TPanel;
    rbCustomer: TRadioButton;
    rbStock: TRadioButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    rbStockGroup: TRadioButton;
    rbTransaction: TRadioButton;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure RadioActionClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sMapFileDirectory : string;
  end;

var
  frmCSVMapStart: TfrmCSVMapStart;

implementation
uses
  eBusBtrv;

{$R *.DFM}

procedure TfrmCSVMapStart.FormCreate(Sender: TObject);
begin
  sMapFileDirectory := GetMapFileDir;
  RadioActionClick(nil);
end;

procedure TfrmCSVMapStart.RadioActionClick(Sender: TObject);
var
  iPos : smallint;
begin
  for iPos := 0 to (panType.ControlCount - 1) do panType.Controls[iPos].Enabled := rbNew.Checked;
end;

end.
