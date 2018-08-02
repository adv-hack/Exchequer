unit PIEXPIRE;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmPlugInExpired = class(TForm)
    Image1: TImage;
    lMessage: TLabel;
    btnRemove: TButton;
    btnContinue: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    sPluginDesc : string;
    WindowMode : integer;
  end;

var
  frmPlugInExpired: TfrmPlugInExpired;

implementation
uses
  ApiUtil, PISecure;

{$R *.dfm}

procedure TfrmPlugInExpired.FormShow(Sender: TObject);
begin
  lMessage.Caption := 'Your evaluation period for the ' + sPluginDesc + ' has expired.'
  + #13#13'If you wish to reactivate this Plug-In please contact your Exchequer helpline number.';

  if TPluginType(WindowMode) in [ptStandaloneEXE, ptTCM] then
  begin
    btnRemove.visible := FALSE;
    btnContinue.caption := '&OK';
//    Height := 145;
    Height := 150;
  end else
  begin
    lMessage.Caption := lMessage.Caption + #13#13'If you wish to remove this Plug-In please click on the remove button below. '
    + 'Otherwise, click on the Continue button, to continue.';
  end;{if}
end;

procedure TfrmPlugInExpired.btnRemoveClick(Sender: TObject);
begin
  if MsgBox('Are you sure you want to remove the ' + sPlugInDesc + ' ?', mtConfirmation
  ,[mbYes,mbNo],mbNo,'Remove Plug-In') = mrYes then begin
    ModalResult := mrCancel;{Remove Plugin}
  end;{if}
end;

procedure TfrmPlugInExpired.btnContinueClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfrmPlugInExpired.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if TPluginType(WindowMode) in [ptStandaloneEXE, ptTCM] then ModalResult := mrOK;
end;

end.
