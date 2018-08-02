unit ModTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OoMisc, AdPort, StdCtrls, ExtCtrls, AdTapi;

type
  TfrmModemTest = class(TForm)
    lModemName: TLabel;
    Bevel1: TBevel;
    label1: TLabel;
    edNumber: TEdit;
    btnClose: TButton;
    btnTest: TButton;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    ApdTapiDevice : TApdTapiDevice;
    { Public declarations }
  end;

var
  frmModemTest: TfrmModemTest;

implementation

{$R *.DFM}

procedure TfrmModemTest.FormShow(Sender: TObject);
begin
{  lModemName.Caption := ApdTapiDevice.SelectedDevice;
  ApdTapiDevice.ComPort := ApdComPort1;}
end;

procedure TfrmModemTest.btnTestClick(Sender: TObject);
begin
  try
    screen.cursor := crHourglass;
//    ApdTapiDevice.Dial(edNumber.Text);
  finally
    screen.cursor := crDefault;
  end;{try}
end;

procedure TfrmModemTest.btnCancelClick(Sender: TObject);
begin
//  ApdTapiDevice.CancelCall;
end;

procedure TfrmModemTest.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//  ApdTapiDevice.CancelCall;
end;

end.
