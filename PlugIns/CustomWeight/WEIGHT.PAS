unit Weight;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TEditVal;

type
  TFrmWeight = class(TForm)
    edWeight: TCurrencyEdit;
    btnOK: TButton;
    btnCancel: TButton;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    lQty: TLabel;
    Label4: TLabel;
    lPrice: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    iSalesDecimals : integer; 
  end;

var
  FrmWeight: TFrmWeight;

implementation

{$R *.dfm}

procedure TFrmWeight.btnOKClick(Sender: TObject);
begin
  if StrToFloatDef(edWeight.Text,0) > 0 then ModalResult := mrOK;
end;

procedure TFrmWeight.FormShow(Sender: TObject);
begin
//  edWeight.displayformat := '######0.' + StringOfChar('#', iSalesDecimals);
  edWeight.displayformat := '######0.000';
end;

end.
