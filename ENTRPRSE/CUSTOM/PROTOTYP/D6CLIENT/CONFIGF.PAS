unit ConfigF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EnterpriseTrade_TLB;

type
  TfrmPlugInconfiguration = class(TForm)
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    lBaseData    : ITradeConnectionPoint;
    lTradeConfig : ITradeConfiguration;
  end;

implementation

{$R *.dfm}

procedure TfrmPlugInconfiguration.FormActivate(Sender: TObject);
begin
  lBaseData.Functions.entActivateClient(Self.Handle);
end;

end.
