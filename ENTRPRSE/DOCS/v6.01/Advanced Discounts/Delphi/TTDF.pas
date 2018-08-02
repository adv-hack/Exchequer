unit TTDF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, TEditVal, BorBtns, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    BorRadio1: TBorRadio;
    BorRadio2: TBorRadio;
    BorRadio3: TBorRadio;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    INetTotF: TCurrencyEdit;
    CurrencyEdit1: TCurrencyEdit;
    CurrencyEdit2: TCurrencyEdit;
    Label2: TLabel;
    CurrencyEdit3: TCurrencyEdit;
    CurrencyEdit4: TCurrencyEdit;
    CurrencyEdit5: TCurrencyEdit;
    Label5: TLabel;
    CurrencyEdit6: TCurrencyEdit;
    CurrencyEdit7: TCurrencyEdit;
    Bevel1: TBevel;
    Label6: TLabel;
    Label7: TLabel;
    Bevel2: TBevel;
    Label8: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.        
