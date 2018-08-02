unit GetDir;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, CompUtil, {NeilProc,}
  setupbas, StdCtrls, ExtCtrls, SetupU, Mask, TEditVal, BrwseDir, FileCtrl, IniFiles, APIUtil;

type
  TfrmGetInstallDir = class(TSetupTemplate)
    lDir: TLabel;
    edInstallDir: Text8Pt;
    btnBrowse: TButton;
    procedure btnBrowseClick(Sender: TObject);
    procedure edClubNameExit(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure edInstallDirKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    sInstallUpgrade : string;
    { Private declarations }
  public
    sCDDir : string;
    { Public declarations }
  end;


  function GetInstallDir(var DLLParams: ParamRec): LongBool; StdCall; export;

implementation
uses
  ShellAPI;

{$R *.DFM}


function GetInstallDir(var DLLParams: ParamRec): LongBool;
{ Asks for the Installation Directory}
var
  sInstallTo, DlgPN, HlpPath : String;
begin{AskInstallUpdate}
  Application.HelpFile := HlpPath + 'TRADE.HLP';
  With TfrmGetInstallDir.Create(Application) Do Begin
    Try
      GetVariable(DLLParams,'INST',sCDDir);
      sCDDir := IncludeTrailingBackslash(sCDDir);{just to be sure}

      GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);
      GetVariable(DLLParams,'INSTALLTO',sInstallTo);
      GetVariable(DLLParams,'INSTALLUPGRADE',sInstallUpgrade);

{      btnBrowse.Enabled := sInstallUpgrade = 'UPGRADE';}

      if sInstallUpgrade = 'UPGRADE' then begin
        TitleLbl.Caption := 'Upgrade Directory';
        InstrLbl.Caption := 'Please enter the path of the Trade Counter that you wish to upgrade :';
        lDir.Caption := 'Upgrade Directory :';
      end;{if}


      edInstallDir.Text := sInstallTo;

      { Display dialog }
      ShowModal;

      Case ExitCode Of
        { Back }
        'B' : SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3)); { New Method - 3 character Id for each Dialog }

        { Next }
        'N' : begin
          SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));{ New Method - 3 character Id for each Dialog }
          SetVariable(DLLParams,'INSTALLTO',edInstallDir.Text);
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

procedure TfrmGetInstallDir.btnBrowseClick(Sender: TObject);
var
  FrmDirBrowse : TFrmDirBrowse;
begin
  try
    FrmDirBrowse := TFrmDirBrowse.Create(Self);
    with FrmDirBrowse do begin
      Caption := 'Installation Directory';
      if DirectoryExists(edInstallDir.Text) then lbDirectory.Directory := edInstallDir.Text;
      if ShowModal = mrOK then edInstallDir.Text := PathToShort(lbDirectory.Directory) + '\';
    end;{with}
  finally
    FrmDirBrowse.Release;
  end;
  edClubNameExit(Self);
end;

procedure TfrmGetInstallDir.edClubNameExit(Sender: TObject);
begin
  NextBtn.Enabled := edInstallDir.Text <> '';
end;

procedure TfrmGetInstallDir.NextBtnClick(Sender: TObject);
var
  sCurrDir, sDir : string;
  bContinue : boolean;
begin
  bContinue := TRUE;
  if copy(edInstallDir.Text,length(edInstallDir.Text),1) <> '\' then edInstallDir.Text := edInstallDir.Text + '\';
  sDir := edInstallDir.Text;

  if DirectoryExists(sDir) then begin
    sCurrDir := ExtractFilePath(Application.exename);
    if (sDir = sCurrDir) or (sDir = Copy(sCurrDir,1,Length(sCurrDir) - 6)) then
      begin
        MsgBox('The directory you have specified is : ' + sDir + #13 + #13
        + 'You cannot install to this directory.',mtWarning,[mbOK],mbOK,'Directory Exists');
        bContinue := FALSE;
      end
    else begin
      MsgBox('The directory you have specified already exists.'
      + CHR(13) + CHR(13) + 'You may want to check that this is the correct directory.',mtWarning,[mbOK],mbOK,'Directory Exists');
    end;
  end;{if}

  if bContinue then inherited;
end;

procedure TfrmGetInstallDir.edInstallDirKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  edClubNameExit(Self);
end;

end.

