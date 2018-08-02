unit VatPOpts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, ComCtrls;

type
  TfrmOptions = class(TForm)
    Button1: TButton;
    Button2: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    Label1: TLabel;
    spPeriods: TSpinEdit;
    chkAutoFill: TCheckBox;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    colBack: TColorBox;
    colText: TColorBox;
    colCurr: TColorBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOptions: TfrmOptions;

implementation

{$R *.dfm}

end.
