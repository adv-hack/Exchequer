unit Ready;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Setupbas, ExtCtrls, StdCtrls, TEditVal, SetupU;

type
  TFrmReadyToInstall = class(TSetupTemplate)
    lBackup: Label8;
    lUsers: Label8;
    chkDemo: TCheckBox;
    chkUsers: TCheckBox;
    procedure CheckClick(Sender: TObject);
  private
    { Private declarations }
  public
    bInstall : boolean;
    { Public declarations }
  end;

{var
  FrmReadyToInstall: TFrmReadyToInstall;}

function ShowReady(var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.DFM}

procedure TFrmReadyToInstall.CheckClick(Sender: TObject);
begin
  NextBtn.Enabled := chkUsers.Checked;
end;

function ShowReady(var DLLParams: ParamRec): LongBool;
{Shows "Ready to install" screen}
var
  sDemo, sInstall, sBack, sForward, HlpPath : String;
begin
  Application.HelpFile := HlpPath + 'TRADE.HLP';
  With TFrmReadyToInstall.Create(Application) Do Begin
    Try
      { Display dialog }

      GetVariable(DLLParams,'INSTALLUPGRADE',sInstall);
      GetVariable(DLLParams,'DEMOCOPY',sDemo);
{      bInstall := sInstall = 'INSTALL';}
      bInstall := TRUE;

      CheckClick(nil);

{      chkBackup.Visible := not bInstall;
      lBackup.Visible := not bInstall;
      chkUsers.Visible := not bInstall;
      lUsers.Visible := not bInstall;}

      if bInstall then InstrLbl.Caption := 'This installation wizard is now ready to install the '
      + 'Exchequer Trade Counter Module. Click on the ''Install'' button to start copying the files.';

      ShowModal;

      GetVariable(DLLParams,'DLG_BACK',sBack);
      GetVariable(DLLParams,'DLG_FWD',sForward);
      Case ExitCode Of
        { Back }
        'B' : SetVariable(DLLParams,'DIALOG',sBack); { New Method - 3 character Id for each Dialog }

        { Next }
        'N' : begin
          SetVariable(DLLParams,'DIALOG',sForward);{ New Method - 3 character Id for each Dialog }
        end;

        { Exit Installation }
        'X' : SetVariable(DLLParams,'DIALOG','999'){ New Method - 3 character Id for each Dialog }
      End;{case}

      if chkDemo.Checked then SetVariable(DLLParams,'DEMOCOPY','TRUE')
      else SetVariable(DLLParams,'DEMOCOPY','FALSE');
    Finally
      Release;
    End;{try}
  End;{With}
  Result := False;
end;{AskInstallUpdate}


end.
