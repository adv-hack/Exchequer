unit Ftpconn;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Mask, ComCtrls;

type
  TFTPConnectDlg = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    OKButton: TButton;
    CancelButton: TButton;
    ServerEdit: TEdit;
    UserNameEdit: TEdit;
    PasswordEdit: TEdit;
    Label4: TLabel;
    TransferTypeComboBox: TComboBox;
    Label5: TLabel;
    LogFileNameEdit: TEdit;
    Bevel2: TBevel;
    Label6: TLabel;
    Label7: TLabel;
    ServerTypeRadioGroup: TRadioGroup;
    ProxyServerEdit: TEdit;
    PassiveModeCheckBox: TCheckBox;
    Label8: TLabel;
    ProxyPortEdit: TEdit;
    ProxyPortUpDown: TUpDown;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FTPConnectDlg: TFTPConnectDlg;

implementation

{$R *.DFM}

end.
