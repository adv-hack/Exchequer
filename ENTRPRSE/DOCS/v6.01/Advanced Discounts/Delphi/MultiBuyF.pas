unit MultiBuyF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, TEditVal, BorBtns, StdCtrls, ComCtrls, ExtCtrls;

type
  TForm3 = class(TForm)
    ScrollBox1: TScrollBox;
    Label6: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    EditValue1: TEditValue;
    EditValue2: TEditValue;
    UpDown2: TUpDown;
    UpDown1: TUpDown;
    Label20: TLabel;
    Label21: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    EditValue3: TEditValue;
    EditValue4: TEditValue;
    UpDown3: TUpDown;
    UpDown4: TUpDown;
    Label25: TLabel;
    Label26: TLabel;
    BorCheckEx1: TBorCheckEx;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
begin
  EditValue1.Color := RGB (183, 183, 255);
  EditValue1.NDecimals := 0;
  EditValue2.Color := EditValue1.Color;
  EditValue3.Color := EditValue1.Color;
  EditValue4.Color := EditValue1.Color;
end;

end.
