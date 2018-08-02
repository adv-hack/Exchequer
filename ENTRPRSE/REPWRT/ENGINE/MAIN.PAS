unit MAIN;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, ExThrd2U, ExTHSu1U, RepThrd1;

type

  TBlahThred = Class(TThread)
    c : integer;
    StatBar : TPanel;
    constructor Create(CreateSuspended : Boolean);
    procedure Execute; override;
    procedure ShowProg;
  end;

  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileCloseItem: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    OpenDialog: TOpenDialog;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    StatusBar: TStatusBar;
    ActionList1: TActionList;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    FileNew1: TAction;
    FileSave1: TAction;
    FileExit1: TAction;
    FileOpen1: TAction;
    FileSaveAs1: TAction;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowArrangeAll1: TWindowArrange;
    WindowMinimizeAll1: TWindowMinimizeAll;
    HelpAbout1: TAction;
    FileClose1: TWindowClose;
    WindowTileVertical1: TWindowTileVertical;
    WindowTileItem2: TMenuItem;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton9: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ImageList1: TImageList;
    Panel1: TPanel;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
  private
    { Private declarations }
    BlahThred : TBlahThred;
    procedure CreateMDIChild(const Name: string);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  RThred : ^TReportThread;

implementation

{$R *.dfm}

uses CHILDWIN, about, ShowRepF;



procedure TMainForm.CreateMDIChild(const Name: string);
var
  Child: TMDIChild;
begin
  { create a new MDI child window }
  Child := TMDIChild.Create(Application);
  Child.Caption := Name;
  if FileExists(Name) then Child.Memo1.Lines.LoadFromFile(Name);
end;

procedure TMainForm.FileNew1Execute(Sender: TObject);
begin
//  CreateMDIChild('NONAME' + IntToStr(MDIChildCount + 1));
  BlahThred := TBlahThred.Create(True);
  BlahThred.StatBar := Panel1;
  BlahThred.Resume;
end;

procedure TMainForm.FileOpen1Execute(Sender: TObject);
begin
 { if OpenDialog.Execute then
    CreateMDIChild(OpenDialog.FileName);}
  Create_BackThread;
  New(RThred, Create(Self));
  with RThred^ do
  begin
    DataPath := 'd:\ent560\';
    UserID := '';
    RepName := 'daybook example';
  end;

  if RThred.Start and Create_BackThread then
    BackThread.AddTask(RThred, RThred.RepName);

end;

procedure TMainForm.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TMainForm.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

{ TBlahThred }

constructor TBlahThred.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  c := 0;
end;

procedure TBlahThred.Execute;
begin
  inherited;
  while not Terminated do
  begin
    inc(c);
    Synchronize(ShowProg);
    SleepEx(10, True);
  end;
end;

procedure TBlahThred.ShowProg;
begin
  StatBar.Caption := IntToStr(c);
end;

end.
