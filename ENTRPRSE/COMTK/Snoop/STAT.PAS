unit stat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TfrmStatus = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmStatus: TfrmStatus;

implementation

{$R *.dfm}

procedure TfrmStatus.FormCreate(Sender: TObject);
begin
  Top := 0;
  Left := 0;
end;

procedure TfrmStatus.FormHide(Sender: TObject);
begin
  Sleep(100);
end;

end.
