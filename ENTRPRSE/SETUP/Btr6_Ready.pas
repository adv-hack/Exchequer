unit Btr6_Ready;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, ExtCtrls, StdCtrls, WiseAPI;

type
  TfrmBtr6Ready = class(TSetupTemplate)
    lblInstallTo: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{ 'Ready To Install' dialog for IAO Btrieve v6.15 Pre-Installer }
function btr6ReadyDlg (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.dfm}

Uses Brand;

//=========================================================================

{ 'Ready To Install' dialog for IAO Btrieve v6.15 Pre-Installer }
function btr6ReadyDlg (var DLLParams: ParamRec): LongBool;
Var
  frmBtr6Ready : TfrmBtr6Ready;
  DlgPN, W_MainDir, WiseStr : String;
Begin // btr6ReadyDlg
  Result := False;

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  // Get Installation Source directory for link to help & Lib\
  GetVariable(DLLParams, 'INST', WiseStr);
  Application.HelpFile := IncludeTrailingPathDelimiter(WiseStr) + 'SETUP.HLP';

  frmBtr6Ready := TfrmBtr6Ready.Create(Application);
  Try
    With frmBtr6Ready Do
    Begin
      Caption := Branding.pbProductName + ' Btrieve v6.15 Pre-Installer';

      // Main Directory
      GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
      lblInstallTo.Caption := lblInstallTo.Caption + ' ' + W_MainDir;

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
    End; { frmBtr6Ready }
  Finally
    frmBtr6Ready.Free;
  End;
End; // btr6ReadyDlg

//=========================================================================

end.
