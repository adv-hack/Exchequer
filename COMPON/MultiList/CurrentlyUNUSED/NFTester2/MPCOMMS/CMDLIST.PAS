unit cmdlist;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, Menus;

type
  TFrmCommandList = class(TForm)
    lvCommands: TListView;
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    bUpdating : boolean;
    procedure UpdateList;
  end;

var
  FrmCommandList: TFrmCommandList;

implementation
uses
  MPComms;

{$R *.DFM}

procedure TFrmCommandList.FormShow(Sender: TObject);
begin
  UpdateList;
end;

procedure TFrmCommandList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmCommandList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Release;
end;

procedure TFrmCommandList.FormDestroy(Sender: TObject);
begin
  FrmCommandList := nil;
end;

procedure TFrmCommandList.UpdateList;
var
  NewItem : TListItem;
  lCommands : TList;
  iCommand : integer;
begin
  bUpdating := TRUE;
  lvCommands.Items.Clear;
  lCommands := TMPComms(Owner).lCommands;
  For iCommand := 0 to (lCommands.Count - 1) do begin
    NewItem := lvCommands.Items.Add;
    NewItem.Caption := TMPComms(Owner).GetCommandDesc(TCommand(lCommands[iCommand]).CommandType);
    NewItem.SubItems.Add(IntToStr(TCommand(lCommands[iCommand]).TillNo));
{    NewItem.SubItems.Add(IntToStr(TCommand(lCommands[iCommand]).Reference));}
    NewItem.SubItems.Add(IntToStr(TCommand(lCommands[iCommand]).Number));
    NewItem.SubItems.Add(IntToStr(TCommand(lCommands[iCommand]).Tries));
    NewItem.SubItems.Add(IntToStr(TCommand(lCommands[iCommand]).TryNo));
    if TCommand(lCommands[iCommand]).Success then NewItem.SubItems.Add('TRUE')
    else NewItem.SubItems.Add('FALSE');
    if TCommand(lCommands[iCommand]).Done then NewItem.SubItems.Add('TRUE')
    else NewItem.SubItems.Add('FALSE');
    if TCommand(lCommands[iCommand]).Read then NewItem.SubItems.Add('TRUE')
    else NewItem.SubItems.Add('FALSE');
  end;{for}
  bUpdating := FALSE;
end;

end.
