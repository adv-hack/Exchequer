unit ValInput;

{ nfrewer440 09:41 03/09/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TFrmValidation = class(TForm)
    edValue: TEdit;
    lLabel: TLabel;
    btnOK: TButton;
    Bevel1: TBevel;
    lTitle: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TFrmValidation.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmValidation.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := Trim(edValue.Text) <> ''; 
end;

procedure TFrmValidation.FormShow(Sender: TObject);
begin
  ActiveControl := edValue;
end;

end.
