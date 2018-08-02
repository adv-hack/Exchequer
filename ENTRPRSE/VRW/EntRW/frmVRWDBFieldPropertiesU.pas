unit frmVRWDBFieldPropertiesU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmVRWDBFieldProperties = class(TForm)
    Label1: TLabel;
    edtTitle: TEdit;
    chkSubtotals: TCheckBox;
    OkBtn: TButton;
    CancelBtn: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmVRWDBFieldProperties: TfrmVRWDBFieldProperties;

implementation

{$R *.dfm}

end.
