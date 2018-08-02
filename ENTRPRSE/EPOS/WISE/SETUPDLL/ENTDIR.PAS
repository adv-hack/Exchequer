unit EntDir;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, CompUtil, {NeilProc,}
  setupbas, StdCtrls, ExtCtrls, SetupU, Mask, TEditVal, BrwseDir, FileCtrl, IniFiles, APIUtil;

type
  TfrmGetEnterpriseDir = class(TSetupTemplate)
    lDir: TLabel;
    edEnterpriseDir: Text8Pt;
    btnBrowse: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnBrowseClick(Sender: TObject);
    procedure edClubNameExit(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure edEnterpriseDirKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    sInstallUpgrade : string;
    { Private declarations }
  public
    sCDDir : string;
    { Public declarations }
  end;


  function GetEnterpriseDir(var DLLParams: ParamRec): LongBool; StdCall; export;

implementation
uses
  ShellAPI;

{$R *.DFM}


function GetEnterpriseDir(var DLLParams: ParamRec): LongBool;
{ Asks for the Installation Directory}
var
  sEnterDir, DlgPN, HlpPath : String;
begin{AskInstallUpdate}
  Application.HelpFile := HlpPath + 'TRADE.HLP';
  With TfrmGetEnterpriseDir.Create(Application) Do Begin
    Try
      GetVariable(DLLParams,'INST',sCDDir);
      sCDDir := IncludeTrailingBackslash(sCDDir);{just to be sure}

      GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);
      GetVariable(DLLParams,'ENTERDIR',sEnterDir);
      GetVariable(DLLParams,'INSTALLUPGRADE',sInstallUpgrade);

{      btnBrowse.Enabled := sInstallUpgrade = 'UPGRADE';}

      if sInstallUpgrade = 'UPGRADE' then begin
        TitleLbl.Caption := 'Upgrade Directory';
        InstrLbl.Caption := 'Please enter the path of the Trade Counter that you wish to upgrade :';
        lDir.Caption := 'Upgrade Directory :';
      end;{if}

      edEnterpriseDir.Text := sEnterDir;

      { Display dialog }
      ShowModal;

      Case ExitCode Of
        { Back }
        'B' : SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3)); { New Method - 3 character Id for each Dialog }

        { Next }
        'N' : begin
          SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));{ New Method - 3 character Id for each Dialog }
          SetVariable(DLLParams,'ENTERDIR',edEnterpriseDir.Text);
        end;

        { Exit Installation }
        'X' : SetVariable(DLLParams,'DIALOG','999'){ New Method - 3 character Id for each Dialog }
      End;{case}
    Finally
      Release;
    End;{try}
  End;{With}
  Result := False;
end;{AskInstallUpdate}

{---------------------------------------------------------------------------}

procedure TfrmGetEnterpriseDir.btnBrowseClick(Sender: TObject);
var
  FrmDirBrowse : TFrmDirBrowse;
begin
  try
    FrmDirBrowse := TFrmDirBrowse.Create(Self);
    with FrmDirBrowse do begin
      Caption := 'Exchequer Directory';
      if DirectoryExists(edEnterpriseDir.Text) then lbDirectory.Directory := edEnterpriseDir.Text;
      if ShowModal = mrOK then edEnterpriseDir.Text := PathToShort(lbDirectory.Directory) + '\';
    end;{with}
  finally
    FrmDirBrowse.Release;
  end;
  edClubNameExit(Self);
end;

procedure TfrmGetEnterpriseDir.edClubNameExit(Sender: TObject);
begin
  NextBtn.Enabled := edEnterpriseDir.Text <> '';
end;

procedure TfrmGetEnterpriseDir.NextBtnClick(Sender: TObject);
var
  sDir : string;
  bContinue : boolean;
  pDir, pParams, pFilename : PChar;
begin
  bContinue := TRUE;
  edEnterpriseDir.Text := IncludeTrailingBackslash(edEnterpriseDir.Text);
  sDir := edEnterpriseDir.Text;

  if not DirectoryExists(sDir) then
    begin
      MsgBox('The directory you have specified to install into does not exist.'
      + CHR(13) + CHR(13) + 'Please specify an existing Exchequer directory.',mtWarning,[mbOK],mbOK,'Directory Invalid');
      bContinue := FALSE;
    end
  else begin
    if not FileExists(sDir + 'Entrprse.exe') then begin
      MsgBox('The directory you have specified is not a valid Exchequer Directory.'
      + CHR(13) + CHR(13) + 'Please specify a valid Exchequer directory.', mtWarning, [mbOK], mbOK, 'Directory Invalid');
      bContinue := FALSE;
    end;{if}
  end;{if}

  if bContinue then inherited;
end;

procedure TfrmGetEnterpriseDir.edEnterpriseDirKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  edClubNameExit(Self);
end;

end.

