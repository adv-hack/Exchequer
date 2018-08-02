unit groupopt;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, GlobType, SBSDrag, ComCtrls;

type
  TForm_GroupOptions = class(TForm)
    Button_Save: TButton;
    Button_Cancel: TButton;
    SBSPanel3: TSBSPanel;
    Label_If: Label8;
    Button_If: TButton;
    SBSPanel1: TSBSPanel;
    ListView1: TListView;
    procedure Button_CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button_IfClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Ok       : Boolean;
    DragCont : TSBSDragGroup;
    FOnIf    : TIfLabelEvent;
  end;

var
  Form_GroupOptions: TForm_GroupOptions;

implementation

{$R *.DFM}

Uses FormUtil, DllInt;

procedure TForm_GroupOptions.FormCreate(Sender: TObject);
begin
  Ok := False;
end;

procedure TForm_GroupOptions.Button_SaveClick(Sender: TObject);
begin
  Ok := True;
  Close;
end;

procedure TForm_GroupOptions.Button_CancelClick(Sender: TObject);
begin
  Close;
end;


procedure TForm_GroupOptions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_GroupOptions.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TForm_GroupOptions.Button_IfClick(Sender: TObject);
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);
  If Assigned (FOnIf) Then FOnIf (DragCont, Label_If);
  RestoreCursor (PrevCur);
end;

end.
