unit WelcomeF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, ComCtrls;

type
  TfrmWelcome = class(TSetupTemplate)
    Label1: TLabel;
    Notebook1: TNotebook;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    procedure TitleLblDblClick(Sender: TObject);
    procedure Label1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


function DispWelcome (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.dfm}

Uses Brand, CompUtil;

//=========================================================================

function DispWelcome (var DLLParams: ParamRec): LongBool;
var
  frmWelcome     : TfrmWelcome;
  DlgPN, IType, W_Install, WiseStr : String;
Begin // DispWelcome
  Result := False;

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  // Get Installation Source directory for link to help & Lib\
  GetVariable(DLLParams, 'INST', WiseStr);
  Application.HelpFile := IncludeTrailingPathDelimiter(WiseStr) + 'SETUP.HLP';

  frmWelcome := TfrmWelcome.Create(Application);
  Try
    With frmWelcome Do
    Begin
      // Insert product name into window
      ModifyCaptions ('<APPTITLE>', Branding.pbProductName, [Label3, Label5, Label10, Label20]);

      GetVariable(DLLParams, 'V_INSTALL', W_Install);
      If (W_Install = 'L') Then
      Begin
        // Exchequer LITE Install/Upgrade
        GetVariable(DLLParams, 'I_TYPE', IType);
        If (IType = '0') Then
          NoteBook1.ActivePage := 'ExchInstall'
        Else
          NoteBook1.ActivePage := 'ExchUpgrade';
      End // If (W_Install = 'L')
      Else If (W_Install = 'W') Then
      Begin
        // Workstation Setup
        NoteBook1.ActivePage := 'WorkstationSetup';
      End; // If (W_Install = 'W')

      ShowModal;

      Case ExitCode Of
        'N' : Begin { Next }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

                If (W_Install = 'L') And (TitleLbl.Tag = 1) And (Label1.Tag = 1) Then
                Begin
                  // Backdoor: Update ICE Install flag
                  SetVariable(DLLParams,'ICE_INSTALLFILES','Y')
                End; // If (W_Install = 'L')
              End;
        'B',        { Back }
        'X' : Begin { Exit Installation }
                SetVariable(DLLParams,'DIALOG','999')
              End;
      End; { If }
    End; // With frmWelcome
  Finally
    frmWelcome.Free;
  End;
End; // DispWelcome

//=========================================================================

procedure TfrmWelcome.TitleLblDblClick(Sender: TObject);
begin
  inherited;
  TitleLbl.Tag := 1;  // Backdoor flag
end;


procedure TfrmWelcome.Label1DblClick(Sender: TObject);
begin
  inherited;
  Label1.Tag := 1;  // Backdoor flag
end;

end.
