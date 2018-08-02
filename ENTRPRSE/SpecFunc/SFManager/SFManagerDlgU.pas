unit SFManagerDlgU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TEditVal, ExtCtrls, StdCtrls, Grids, ValEdit, Buttons, ComCtrls,

  SFHeaderU, SFManagerU;

type
  TSFManagerDlg = class(TForm)
    OpenDialog: TOpenDialog;
    MainPnl: TPanel;
    Panel2: TPanel;
    PageTitleLbl: TLabel;
    ButtonPnl: TPanel;
    NavButtonPnl: TPanel;
    btnBack: TButton;
    btnNext: TButton;
    btnCancel: TButton;
    ImagePnl: TPanel;
    Image1: TImage;
    PageControl: TPageControl;
    SelectPage: TTabSheet;
    lblSelectFile: TLabel;
    edtSelectFile: TEdit;
    EditPage: TTabSheet;
    InfoPage: TTabSheet;
    ProcessPage: TTabSheet;
    ReadyToProcessLbl: TLabel;
    FunctionLbl: TLabel;
    btnSelectFile: TSpeedButton;
    FinalPage: TTabSheet;
    lblFileFinal: TLabel;
    lblIntro: TLabel;
    lblFileTitle: TLabel;
    edtFileTitle: TEdit;
    lblFileID: TLabel;
    edtFileID: TEdit;
    lblInstallDate: TLabel;
    edtInstallDate: TEdit;
    EditorButtonPnl: TPanel;
    CompressedChk: TCheckBox;
    Editor: TMemo;
    SaveDialog: TSaveDialog;
    lblFinal: TLabel;
    chkRunOnce: TCheckBox;
    edtExpiryDate: TDateTimePicker;
    chkExpires: TCheckBox;
    chkIsPassworded: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnSelectFileClick(Sender: TObject);
    procedure edtSelectFileChange(Sender: TObject);
    procedure CompressedChkClick(Sender: TObject);
    procedure chkExpiresClick(Sender: TObject);
  private
    { Private declarations }
    Config: TSFConfiguration;
    IDFile: TSFIDFile;
    procedure CloseDialog;
    procedure NextPage;
    procedure PriorPage;
    procedure Process;
    procedure SelectFile;
    procedure ShowInfo;
    procedure UpdateConfig;
    procedure UpdatePage;
  public
    { Public declarations }
  end;

var
  SFManagerDlg: TSFManagerDlg;

implementation

{$R *.dfm}

uses StrUtils, ZLib;

const
  INTRO_MSG =
    'This wizard allows you to create and edit Special Function Script files, and '+
    'to add, view, and edit the parameters for Special Function Plug-in DLLs. ' +
    #13#10#13#10 +
    'Specify the location and file name below. If the file does not exist, a new ' +
    'Script file will be created. If the file already exists, it will be opened for ' +
    'viewing and editing.';

// =============================================================================
// TSFIdentityManagerDlg
// =============================================================================

procedure TSFManagerDlg.btnBackClick(Sender: TObject);
begin
  PriorPage;
  UpdatePage;
end;

// -----------------------------------------------------------------------------

procedure TSFManagerDlg.btnCancelClick(Sender: TObject);
begin
  CloseDialog;
end;

// -----------------------------------------------------------------------------

procedure TSFManagerDlg.btnNextClick(Sender: TObject);
begin
  if PageControl.ActivePage = ProcessPage then
    Process
  else
    NextPage;
  UpdatePage;
end;

// -----------------------------------------------------------------------------

procedure TSFManagerDlg.btnSelectFileClick(Sender: TObject);
begin
  SelectFile;
end;

// -----------------------------------------------------------------------------

procedure TSFManagerDlg.CloseDialog;
begin
  Close;
end;

// -----------------------------------------------------------------------------

procedure TSFManagerDlg.CompressedChkClick(Sender: TObject);
begin
  Config.IsCompressed := CompressedChk.Checked;
end;

// -----------------------------------------------------------------------------

procedure TSFManagerDlg.edtSelectFileChange(Sender: TObject);
begin
  btnNext.Enabled := False;
  if DirectoryExists(ExtractFilePath(edtSelectFile.Text)) then
  begin
    btnNext.Enabled := (ExtractFileName(edtSelectFile.Text) <> '');
  end;
end;

// -----------------------------------------------------------------------------

procedure TSFManagerDlg.FormCreate(Sender: TObject);
begin
  Config := TSFConfiguration.Create;
  IDFile := TSFIDFile.Create;
  PageControl.ActivePage := SelectPage;
  lblIntro.Caption := INTRO_MSG;
  btnNext.Enabled := False;
end;

// -----------------------------------------------------------------------------

procedure TSFManagerDlg.FormDestroy(Sender: TObject);
begin
  IDFile.Free;
  Config.Free;
end;

// -----------------------------------------------------------------------------

procedure TSFManagerDlg.NextPage;
begin
  if (PageControl.ActivePage = SelectPage) then
  begin
    if Config.IsDLL then
      PageControl.ActivePage := InfoPage
    else
    begin
      if FileExists(edtSelectFile.Text) then
        LoadScript(edtSelectFile.Text, Editor.Lines);
      PageControl.ActivePage := EditPage;
    end;
  end
  else if (PageControl.ActivePage = ProcessPage) then
  begin
    PageControl.ActivePage := FinalPage;
  end
  else
    PageControl.ActivePageIndex := PageControl.ActivePageIndex + 1;
end;

// -----------------------------------------------------------------------------

procedure TSFManagerDlg.PriorPage;
begin
  if (PageControl.ActivePage = InfoPage) and (Config.IsDLL) then
    PageControl.ActivePage := SelectPage
  else if (PageControl.ActivePage = InfoPage) then
    PageControl.ActivePage := EditPage
  else
    PageControl.ActivePageIndex := PageControl.ActivePageIndex - 1;
end;

// -----------------------------------------------------------------------------

procedure TSFManagerDlg.Process;
begin
  if not Config.IsDLL then
  begin
    { Must be a script file. Create/update it now. }
    try
      SaveScript(edtSelectFile.Text, Editor.Lines, Config.IsCompressed);
      { We have just saved the script *without* a configuration block. Indicate
        this by clearing the identification block. (This is a clumsy way of
        achieving this -- could do with refactoring). }
      Config.Block.Identifier := #0;
    except
      on E:Exception do
      begin
        ShowMessage('Failed to save ' + edtSelectFile.Text + ': ' + E.Message);
        Exit;
      end;
    end;
  end;
  UpdateConfig;
  NextPage;
end;

// -----------------------------------------------------------------------------

procedure TSFManagerDlg.SelectFile;
begin
  if OpenDialog.Execute then
  begin
    edtSelectFile.Text := OpenDialog.FileName;
    Config.FileName := OpenDialog.FileName;
    if Config.ID = 0 then
      Config.ID := IDFile.Add(Config.Title);
  end;
end;

// -----------------------------------------------------------------------------

procedure TSFManagerDlg.ShowInfo;
begin
  edtFileTitle.Text    := Config.Title;
  edtFileID.Text       := IntToStr(Config.ID);
  if (Trunc(Config.ExpiryDate) <> 0) then
  begin
    edtExpiryDate.Date := Config.ExpiryDate;
    chkExpires.Checked := True;
  end
  else
  begin
    edtExpiryDate.Date := Now + 1;
    chkExpires.Checked := False;
  end;
  chkIsPassworded.Checked := Config.IsPassworded;
  edtInstallDate.Text  := DateToStr(Config.InstallDate);
end;

// -----------------------------------------------------------------------------

procedure TSFManagerDlg.UpdateConfig;
begin
  if (Config.Title <> edtFileTitle.Text) then
    IDFile.ChangeTitle(Config.Title, edtFileTitle.Text);
  Config.Write;
  IDFile.Save;
end;

// -----------------------------------------------------------------------------

procedure TSFManagerDlg.UpdatePage;
begin
  btnNext.Enabled := True;
  btnNext.Caption := '&Next';
  btnBack.Enabled := True;
  if (PageControl.ActivePage = SelectPage) then
  begin
    PageTitleLbl.Caption := 'Select option';
    btnBack.Enabled := False;
  end
  else if (PageControl.ActivePage = EditPage) then
  begin
    PageTitleLbl.Caption := 'Edit SQL query';
    CompressedChk.Checked := Config.IsCompressed;
  end
  else if (PageControl.ActivePage = InfoPage) then
  begin
    PageTitleLbl.Caption := 'File details for ' + edtSelectFile.Text;
    ShowInfo;
  end
  else if (PageControl.ActivePage = ProcessPage) then
  begin
    Config.Title        := edtFileTitle.Text;
    Config.ID           := StrToInt(edtFileID.Text);
    if chkExpires.Checked then
      Config.ExpiryDate := edtExpiryDate.Date
    else
      Config.ExpiryDate := 0;
    Config.IsCompressed := CompressedChk.Checked;
    if chkRunOnce.Checked then
      Config.ExpiryType := etRunOnce
    else if Trunc(Config.ExpiryDate) > 0 then
      Config.ExpiryType := etExpiresOn
    else
      Config.ExpiryType := etStd;
    Config.IsPassworded := chkIsPassworded.Checked;
    PageTitleLbl.Caption := 'Save changes';
    FunctionLbl.Caption := edtSelectFile.Text;
    btnNext.Caption := '&Finish';
  end
  else if (PageControl.ActivePage = FinalPage) then
  begin
    PageTitleLbl.Caption := 'Finished';
    lblFileFinal.Caption := edtSelectFile.Text;
    btnNext.Enabled := False;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSFManagerDlg.chkExpiresClick(Sender: TObject);
begin
  edtExpiryDate.Enabled := chkExpires.Checked;
end;

// -----------------------------------------------------------------------------

end.

