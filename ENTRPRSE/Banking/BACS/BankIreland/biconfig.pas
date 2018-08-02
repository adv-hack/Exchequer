unit biconfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CONFIGF, StdCtrls, ExtCtrls;

type
  TfrmBIConfig = class(TfrmBacsConfig)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBIConfig: TfrmBIConfig;

implementation

{$R *.dfm}

procedure TfrmBIConfig.FormCreate(Sender: TObject);
begin
  IniFileName := 'BI_EFT.INI';
  Section := 'EFT';
  Key := 'UserID';
  inherited;
end;

end.
