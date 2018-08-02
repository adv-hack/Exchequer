unit spopsu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TSPOPSetupDlg = class(TForm)
    Bevel1: TBevel;
    OKButton: TButton;
    CancelButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ServerEdit: TEdit;
    UserNameEdit: TEdit;
    PasswordEdit: TEdit;
    Label5: TLabel;
    LogFileNameEdit: TEdit;
    AsIsCheckBox: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SPOPSetupDlg: TSPOPSetupDlg;

implementation

{$R *.DFM}

end.
