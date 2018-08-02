unit sysdebug;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ExtCtrls;

type
  TForm_SysDebug = class(TForm)
    Panel_List: TPanel;
    List_Messages: TListBox;
    MainMenu1: TMainMenu;
    MenuOpt_Clear: TMenuItem;
    MenuOpt_Exit: TMenuItem;
    MenuOpt_Suspend: TMenuItem;
    Menu_Suspend_1: TMenuItem;
    Menu_Suspend_2: TMenuItem;
    Menu_Suspend_3: TMenuItem;
    Menu_Suspend_4: TMenuItem;
    Menu_Suspend_5: TMenuItem;
    Menu_Suspend_SepBar1: TMenuItem;
    Menu_Suspend_All: TMenuItem;
    Utilities1: TMenuItem;
    Export1: TMenuItem;
    SaveDialog1: TSaveDialog;
    OnTop1: TMenuItem;
    procedure MenuOpt_ClearClick(Sender: TObject);
    procedure MenuOpt_ExitClick(Sender: TObject);
    procedure Menu_Suspend_1Click(Sender: TObject);
    procedure Menu_Suspend_2Click(Sender: TObject);
    procedure Menu_Suspend_3Click(Sender: TObject);
    procedure Menu_Suspend_4Click(Sender: TObject);
    procedure Menu_Suspend_5Click(Sender: TObject);
    procedure Menu_Suspend_AllClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Export1Click(Sender: TObject);
    procedure OnTop1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Usage  : LongInt;
  end;

var
  Form_SysDebug: TForm_SysDebug;

implementation

{$R *.DFM}

Uses DebugServer;

procedure TForm_SysDebug.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  If (Usage <> 0) Then
    { Apps still attached or crashed }
    CanClose := (MessageDlg ('Are you sure you want to close the Message Window', mtInformation, [mbYes, mbNo], 0) = mrYes)
  Else
    CanClose := True;
end;

{ Reset the handle when shutting down }
{ Clear messages in the list }
procedure TForm_SysDebug.MenuOpt_ClearClick(Sender: TObject);
begin
  List_Messages.Clear;
  FIndent := 0;
end;

{ Exit the system }
procedure TForm_SysDebug.MenuOpt_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_SysDebug.Menu_Suspend_1Click(Sender: TObject);
begin
  Menu_Suspend_1.Checked := Not Menu_Suspend_1.Checked;
end;

procedure TForm_SysDebug.Menu_Suspend_2Click(Sender: TObject);
begin
  Menu_Suspend_2.Checked := Not Menu_Suspend_2.Checked;
end;

procedure TForm_SysDebug.Menu_Suspend_3Click(Sender: TObject);
begin
  Menu_Suspend_3.Checked := Not Menu_Suspend_3.Checked;
end;

procedure TForm_SysDebug.Menu_Suspend_4Click(Sender: TObject);
begin
  Menu_Suspend_4.Checked := Not Menu_Suspend_4.Checked;
end;

procedure TForm_SysDebug.Menu_Suspend_5Click(Sender: TObject);
begin
  Menu_Suspend_5.Checked := Not Menu_Suspend_5.Checked;
end;

procedure TForm_SysDebug.Menu_Suspend_AllClick(Sender: TObject);
begin
  Menu_Suspend_All.Checked := Not Menu_Suspend_All.Checked;
end;

procedure TForm_SysDebug.Export1Click(Sender: TObject);
Var
  OutF : TextFile;
  I    : Integer;
begin
  If SaveDialog1.Execute Then Begin
    AssignFile (OutF, SaveDialog1.FileName);
    Rewrite    (OutF);

    If (List_Messages.Items.Count > 0) Then
      For I := 0 To Pred(List_Messages.Items.Count) Do
        Writeln (OutF, List_Messages.Items.Strings[I]);

    CloseFile (OutF);
  End; { If }
end;

procedure TForm_SysDebug.OnTop1Click(Sender: TObject);
begin
  OnTop1.Checked := Not OnTop1.Checked;

  Hide;
  Case OnTop1.Checked Of
    False : FormStyle := fsNormal;
    True  : FormStyle := fsStayOnTop;
  End; { Case }
  Show;
end;

end.
