unit Btr6_Welcome;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, ExtCtrls, StdCtrls, WiseAPI;

type
  TfrmBtr6Welcome = class(TSetupTemplate)
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{ 'Welcome' dialog for IAO Btrieve v6.15 Pre-Installer }
function btr6WelcomeDlg (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.dfm}

Uses Brand;

//=========================================================================

{ 'Welcome' dialog for IAO Btrieve v6.15 Pre-Installer }
function btr6WelcomeDlg (var DLLParams: ParamRec): LongBool;
Var
  frmBtr6Welcome : TfrmBtr6Welcome;
  DlgPN, WiseStr : String;
Begin // btr6WelcomeDlg
  Result := False;

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  // Get Installation Source directory for link to help & Lib\
  GetVariable(DLLParams, 'INST', WiseStr);
  Application.HelpFile := IncludeTrailingPathDelimiter(WiseStr) + 'SETUP.HLP';

  frmBtr6Welcome := TfrmBtr6Welcome.Create(Application);
  Try
    With frmBtr6Welcome Do
    Begin
      Caption := Branding.pbProductName + ' Btrieve v6.15 Pre-Installer';

      // Insert product name into window
      ModifyCaptions ('<APPTITLE>', Branding.pbProductName, [InstrLbl, Label1]);

      ShowModal;

      Case ExitCode Of
        'B' : Begin { Back }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3))
              End;
        'N' : Begin { Next }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));
              End;
        'X' : Begin { Exit Installation }
                SetVariable(DLLParams,'DIALOG','999')
              End;
      End; { If }
    End; { With frmBtr6Welcome }
  Finally
    frmBtr6Welcome.Free;
  End;
End; // btr6WelcomeDlg

//=========================================================================





end.
