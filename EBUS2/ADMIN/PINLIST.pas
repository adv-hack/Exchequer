unit pinlist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uMultiList, ExtCtrls;

const
  paNone          = 0;
  paAccept        = 1;
  paUnidentified  = 2;

type
  TfrmPINList = class(TForm)
    mlPINs: TMultiList;
    Label1: TLabel;
    Panel1: TPanel;
    Button1: TButton;
    Button3: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    fAction : Byte;
    procedure SetPINs(AList : TStringList);
  public
    { Public declarations }
    property PINs : TStringList write SetPINs;
    property Action : Byte read fAction;
  end;

var
  frmPINList: TfrmPINList;

implementation

{$R *.dfm}
uses
  EbusVar;

procedure TfrmPINList.SetPINs(AList : TStringList);
var
  i : integer;
begin
  for i := 0 to AList.Count - 1 do
  begin
    with AList.Objects[i] as TPreserveLineObject do
    begin
      mlPINs.DesignColumns[0].Items.Add(Fields.IdStockCode);
      mlPINs.DesignColumns[1].Items.Add(Fields.IdDescription);
      mlPINs.DesignColumns[2].Items.Add(Format('%11.2f', [Fields.IdQty]));
      mlPINs.DesignColumns[3].Items.Add(Trim(Fields.IdBuyersOrder));
    end;
    mlPINs.DesignColumns[4].Items.Add(AList[i]);
  end;
end;

procedure TfrmPINList.FormCreate(Sender: TObject);
begin
  fAction := 0;
end;

procedure TfrmPINList.Button1Click(Sender: TObject);
begin
  fAction := paAccept;
end;

procedure TfrmPINList.Button3Click(Sender: TObject);
begin
  fAction := paUnidentified;
end;

end.
