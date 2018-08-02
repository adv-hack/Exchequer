unit AIBCONFG;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CONFIGF, StdCtrls, ExtCtrls;

type
  TfrmAibConfig = class(TfrmBacsConfig)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAibConfig: TfrmAibConfig;

implementation

{$R *.dfm}

procedure TfrmAibConfig.FormCreate(Sender: TObject);
begin
  IniFileName := 'AIB_EFT.INI';
  Section := 'EFT';
  Key := 'UserID';
  inherited;
end;

end.
