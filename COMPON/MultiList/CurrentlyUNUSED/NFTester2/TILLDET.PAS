unit TillDet;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, TEditVal, Mask;

type
  TFrmTillDetails = class(TForm)
    edTillDesc: Text8Pt;
    Label81: Label8;
    edTillName: Text8Pt;
    Label82: Label8;
    btnOK: TButton;
    btnCancel: TButton;
    Bevel1: TBevel;
    lTillNo: Label8;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{var
  FrmTillDetails: TFrmTillDetails;}

implementation

{$R *.DFM}

end.
