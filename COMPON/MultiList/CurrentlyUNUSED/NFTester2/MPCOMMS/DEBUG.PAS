unit debug;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ComCtrls, OoMisc, ADTrmEmu;

type
  TFrmMPCommsDebug = class(TForm)
    Debug: TAdTerminal;
    btnClose: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPCommsDebug: TFrmMPCommsDebug;

implementation
uses
  MPComms;

{$R *.DFM}

procedure TFrmMPCommsDebug.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMPCommsDebug.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Release;
end;

procedure TFrmMPCommsDebug.btnCancelClick(Sender: TObject);
begin
  TMPComms(Owner).CancelAllTransfers;
end;

procedure TFrmMPCommsDebug.FormDestroy(Sender: TObject);
begin
  FrmMPCommsDebug.Debug.Active := FALSE;
  FrmMPCommsDebug.Debug.ComPort := nil;
  FrmMPCommsDebug := nil;
end;

procedure TFrmMPCommsDebug.FormResize(Sender: TObject);
begin
  Debug.Height := Height - 64;
  btnClose.Left := Width - 113;
{  btnCancel.Left := Width - 217;}
  btnClose.Top := height - 56;
{  btnCancel.Top := height - 56;}
  VertScrollBar.Visible := FALSE;
  HorzScrollBar.Visible := FALSE;
end;

end.
