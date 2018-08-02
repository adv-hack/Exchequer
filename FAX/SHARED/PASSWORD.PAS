unit Password;

{ nfrewer440 10:20 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$IFNDEF VER130}
  {$ALIGN 1}  { Variable Alignment Disabled }
{$ENDIF}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, TCustom, ExtCtrls;

type
  TfrmPassword = class(TForm)
    Bevel1: TBevel;
    Label3: TLabel;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    edPassword: Text8Pt;
    lPlease: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPassword: TfrmPassword;

implementation

{$R *.DFM}

end.
