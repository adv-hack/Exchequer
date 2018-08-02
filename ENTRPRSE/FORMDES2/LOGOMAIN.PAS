unit LogoMain;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses Windows, Classes, Graphics, Forms, Controls, Menus,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TLogoAppForm = class(TForm)
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileSaveItem: TMenuItem;
    FileSendItem: TMenuItem;
    FileExitItem: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Help1: TMenuItem;
    AboutItem: TMenuItem;
    SpeedPanel: TPanel;
    OpenBtn: TSpeedButton;
    SaveBtn: TSpeedButton;
    ExitBtn: TSpeedButton;
    StatusBar: TStatusBar;
    RichEdit1: TRichEdit;
    SendBtn: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FileExit(Sender: TObject);
    procedure FileNew(Sender: TObject);
    procedure FileOpen(Sender: TObject);
    procedure FileSave(Sender: TObject);
    procedure FileSaveAs(Sender: TObject);
    procedure FileSend(Sender: TObject);
    procedure About(Sender: TObject);
    procedure ShowHint(Sender: TObject);
  private
    FFileName: String;
  public
    { Public declarations }
  end;

var
  LogoAppForm: TLogoAppForm;

implementation

uses SysUtils, Mapi, About, LogoStrs;

{$R *.DFM}

procedure TLogoAppForm.FormCreate(Sender: TObject);
begin
  Application.OnHint := ShowHint;
end;

procedure TLogoAppForm.FileNew(Sender: TObject);
begin
  FFileName := LoadStr(sUntitled);
  RichEdit1.Lines.Clear;
  RichEdit1.Modified := False;
end;

procedure TLogoAppForm.FileOpen(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    RichEdit1.Lines.LoadFromFile(OpenDialog.FileName);
    FFileName := OpenDialog.FileName;
    RichEdit1.SetFocus;
    RichEdit1.Modified := False;
    RichEdit1.ReadOnly := ofReadOnly in OpenDialog.Options;
  end;
end;

procedure TLogoAppForm.FileSave(Sender: TObject);
begin
  if FFileName = LoadStr(sUntitled) then
    FileSaveAs(Sender)
  else
  begin
    RichEdit1.Lines.SaveToFile(FFileName);
    RichEdit1.Modified := False;
  end;
end;

procedure TLogoAppForm.FileSaveAs(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    if FileExists(SaveDialog.FileName) then
      if MessageDlg(FmtLoadStr(sOverwrite, [SaveDialog.FileName]),
        mtConfirmation, mbYesNoCancel, 0) <> idYes then Exit;
    RichEdit1.Lines.SaveToFile(SaveDialog.FileName);
    FFileName := SaveDialog.FileName;
    RichEdit1.Modified := False;
  end;
end;

procedure TLogoAppForm.FileSend(Sender: TObject);
var
  MapiMessage: TMapiMessage;
  MError: Cardinal;
begin
  with MapiMessage do
  begin
    ulReserved := 0;
    lpszSubject := nil;
    lpszNoteText := PChar(RichEdit1.Lines.Text);
    lpszMessageType := nil; 
    lpszDateReceived := nil; 
    lpszConversationID := nil; 
    flFlags := 0;
    lpOriginator := nil; 
    nRecipCount := 0;
    lpRecips := nil; 
    nFileCount := 0;
    lpFiles := nil; 
  end;
  
  MError := MapiSendMail(0, 0, MapiMessage, 
    MAPI_DIALOG or MAPI_LOGON_UI or MAPI_NEW_SESSION, 0);
  if MError <> 0 then MessageDlg('Error sending mail', mtError, [mbOK], 0);
end;

procedure TLogoAppForm.FileExit(Sender: TObject);
begin
  Close;
end;

procedure TLogoAppForm.About(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TLogoAppForm.ShowHint(Sender: TObject);
begin
  StatusBar.SimpleText := Application.Hint;
end;

end.
 
