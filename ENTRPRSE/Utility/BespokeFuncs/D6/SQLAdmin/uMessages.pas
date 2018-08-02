unit uMessages;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TMessageType = (mmtError, mmtNormal, mmtAmber);

  TfrmMessages = class(TForm)
    btnOK: TButton;
    memMessages: TRichEdit;
    btnSave: TButton;
    SaveDialog1: TSaveDialog;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSaveClick(Sender: TObject);
  private
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
  public
    Open : boolean;
    procedure ClearLines;
    procedure AddLine(sText : string; MessageType: TMessageType = mmtNormal);
  end;

var
  frmMessages: TfrmMessages;

implementation

{$R *.dfm}

{ TfrmMessages }

procedure TfrmMessages.AddLine(sText: string; MessageType: TMessageType = mmtNormal);
begin
  case MessageType of
    mmtError :
    begin
//      SelAttributes.Style
      memMessages.SelAttributes.Color := clRed;
    end;

    mmtNormal :
    begin
      memMessages.SelAttributes.Color := clBlack;
    end;

    mmtAmber :
    begin
      memMessages.SelAttributes.Color := $000080FF;
    end;{if}
  end;{case}
  memMessages.Lines.Add(sText);
  memMessages.Refresh;
  Application.ProcessMessages;
end;

procedure TfrmMessages.ClearLines;
begin
  memMessages.Lines.Clear;
end;

procedure TfrmMessages.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMessages.FormCreate(Sender: TObject);
begin
  Open := TRUE;
end;

procedure TfrmMessages.FormResize(Sender: TObject);
begin
  btnOK.Left := ClientWidth - 90;
  btnOK.Top := ClientHeight - 27;

  btnSave.Left := ClientWidth - 178;
  btnSave.Top := btnOK.Top;

  memMessages.Width := ClientWidth - 17;
  memMessages.Height := ClientHeight - 42;
end;

procedure TfrmMessages.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 300;
    ptMinTrackSize.Y := 300;
  end;{with}
  Message.Result := 0;
  inherited;
end;

procedure TfrmMessages.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Hide;
  Open := FALSE;
end;

procedure TfrmMessages.btnSaveClick(Sender: TObject);
begin
  if SaveDialog1.Execute then memMessages.Lines.SaveToFile(SaveDialog1.FileName);
end;

end.
