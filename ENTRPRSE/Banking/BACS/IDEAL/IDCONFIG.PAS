unit idconfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CONFIGF, StdCtrls, ExtCtrls;

type
  TfrmIdealConfig = class(TfrmBacsConfig)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmIdealConfig: TfrmIdealConfig;

implementation

{$R *.dfm}

procedure TfrmIdealConfig.FormCreate(Sender: TObject);
begin
  IniFileName := 'Ideal.ini';
  Section := 'Ideal';
  Key := 'UserID';
  inherited;
end;

end.
