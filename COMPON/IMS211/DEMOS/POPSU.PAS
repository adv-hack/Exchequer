unit popsu;

interface

uses Windows, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls;

type
  TSetupDlg = class(TForm)
    Label1: TLabel;
    ServerEdit: TEdit;
    Label2: TLabel;
    UserNameEdit: TEdit;
    Label3: TLabel;
    PasswordEdit: TEdit;
    Label4: TLabel;
    LogFileNameEdit: TEdit;
    Bevel1: TBevel;
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
