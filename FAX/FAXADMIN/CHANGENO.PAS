unit ChangeNo;

{ nfrewer440 10:19 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal;

type
  TfrmChangeNo = class(TForm)
    btnCancel: TButton;
    btnOK: TButton;
    Label1: TLabel;
    edFaxNo: Text8Pt;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{var
  frmChangeNo: TfrmChangeNo;}

implementation

{$R *.DFM}

end.
