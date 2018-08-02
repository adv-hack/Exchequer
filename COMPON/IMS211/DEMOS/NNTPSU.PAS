unit nntpsu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask;

type
  TSetupDlg = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ServerEdit: TEdit;
    UserAddressEdit: TEdit;
    UserNameEdit: TEdit;
    LogFileNameEdit: TEdit;
    OKButton: TButton;
    CancelButton: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetupDlg: TSetupDlg;

implementation

{$R *.DFM}

end.
