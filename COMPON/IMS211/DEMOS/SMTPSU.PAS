unit Smtpsu;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls;

type
  TSetupDlg = class(TForm)
    Label1: TLabel;
    ServerEdit: TEdit;
    Label2: TLabel;
    UserAddressEdit: TEdit;
    Label3: TLabel;
    UserNameEdit: TEdit;
    Label4: TLabel;
    LogFileNameEdit: TEdit;
    CharSetComboBox: TComboBox;
    Label6: TLabel;
    OKButton: TButton;
    CancelButton: TButton;
    Bevel1: TBevel;
    EncodingComboBox: TComboBox;
    Label5: TLabel;
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
