unit Status;

{ nfrewer440 16:25 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons;

type
  TFrmStatus = class(TForm)
    Animate1: TAnimate;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Constructor Create(aOwner : TComponent;Active : Boolean);
  end;

var
  FrmStatus: TFrmStatus;

implementation

{$R *.DFM}
Constructor TFrmStatus.Create(aOwner : TComponent;Active : Boolean);
begin
  inherited Create(aOwner);
  Animate1.Active := Active = true;
end;

procedure TFrmStatus.FormCreate(Sender: TObject);
begin
  height := 100;
  width := 310;
end;

procedure TFrmStatus.FormDestroy(Sender: TObject);
begin
  Animate1.Active := false;
end;

end.
