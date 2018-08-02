unit LoginWar;

{ markd6 12:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, TEditVal;

type
  TForm_LogonWarn = class(TForm)
    btnYes: TButton;
    btnNo: TButton;
    Image1: TImage;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}


procedure TForm_LogonWarn.FormCreate(Sender: TObject);
begin
  Image1.Picture.Icon.Handle := LoadIcon(0, IDI_EXCLAMATION);
  Icon.Assign(Image1.Picture.Icon);
end;

end.
