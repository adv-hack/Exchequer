unit TransLineF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, BorBtns, Mask, TEditVal, SBSPanel;

type
  TForm4 = class(TForm)
    PageControl1: TPageControl;
    De2Page: TTabSheet;
    Image1: TImage;
    Id3Panel3: TSBSPanel;
    Label5: TLabel;
    ScrollBox1: TScrollBox;
    Label3: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    EditValue1: TEditValue;
    Label6: TLabel;
    UpDown1: TUpDown;
    Label8: TLabel;
    EditValue2: TEditValue;
    UpDown2: TUpDown;
    Id3UPriceF: TCurrencyEdit;
    CurrencyEdit1: TCurrencyEdit;
    CurrencyEdit2: TCurrencyEdit;
    Label1: TLabel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.FormCreate(Sender: TObject);
begin
  EditValue1.Color := RGB (183, 183, 255);
  EditValue2.Color := EditValue1.Color;
  Id3UPriceF.Color := EditValue1.Color;
  CurrencyEdit1.Color := EditValue1.Color;
  CurrencyEdit2.Color := EditValue1.Color;
end;

procedure TForm4.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
  Id3UPriceF.Value := (3.93 * 3 * StrToIntDef(EditValue1.Text,0));
  CurrencyEdit2.Value := 31.43 - Id3UPriceF.Value - CurrencyEdit1.Value;
end;

procedure TForm4.UpDown2Click(Sender: TObject; Button: TUDBtnType);
begin
  CurrencyEdit1.Value := (3.93 * StrToIntDef(EditValue2.Text,0));
  CurrencyEdit2.Value := 31.43 - Id3UPriceF.Value - CurrencyEdit1.Value;
end;

end.
