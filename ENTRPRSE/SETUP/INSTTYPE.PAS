unit InstType;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU;

type
  TfrmInstallType = class(TSetupTemplate)
    NoteBook1: TNotebook;
    radUpgrade2: TRadioButton;
    radInstall: TRadioButton;
    radUpgrade: TRadioButton;
    Label3: TLabel;
    radAddComp: TRadioButton;
    Label2: TLabel;
    radAddComp2: TRadioButton;
    Label1: TLabel;
    procedure Label3Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmInstallType: TfrmInstallType;

function SCD_GetInstallType(var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;

implementation

{$R *.DFM}

Uses Brand;

{ Gets the Installation Type:- Install, Upgrade, AddComp }
function SCD_GetInstallType(var DLLParams: ParamRec): LongBool;
var
  frmInstallType      : TfrmInstallType;
  DlgPN, HlpPath      : String;
  W_InstType, W_Type  : String;
begin { SCD_GetInstallType }
  { Get path of help file }
  GetVariable(DLLParams, 'INST', DlgPN);
  If Not (Copy (DlgPN, Length(DlgPN), 1)[1] In [':', '\']) Then
    HlpPath := DlgPN + '\'
  Else
    HlpPath := DlgPN;
  Application.HelpFile := HlpPath + 'SETUP.HLP';

  frmInstallType := TfrmInstallType.Create(Application);
  Try
    With frmInstallType Do Begin
      GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);

      { Get Licence Type: 0-Install, 1=Upgrade, 2=Auto-Upgrade }
      GetVariable(DLLParams, 'I_TYPE', W_Type);

      { Get selected Installation Type }
      GetVariable(DLLParams, 'V_INSTTYPE', W_InstType);

      If (W_Type = '0') Then Begin
        NoteBook1.ActivePage := 'nbInstall';

        If (W_InstType = 'B') Then
          radUpgrade.Checked := True
        Else
          If (W_InstType = 'C') Then
            radAddComp.Checked := True
          Else
            radInstall.Checked := True;

        HelpContext := 40;
      End { If (W_Type = '0') }
      Else Begin
        NoteBook1.ActivePage := 'nbUpgrade';

        If (W_InstType = 'C') Then
          radAddComp2.Checked := True
        Else
          radUpgrade2.Checked := True;

        HelpContext := 64;
      End; { Else }

      ModifyCaptions ('<APPTITLE>', Branding.pbProductName, [radInstall, Label2, Label1]);

      { Display dialog }
      ShowModal;

      Case ExitCode Of
        'B' : Begin { Back }
                { New Method - 3 character Id for each Dialog }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3));
              End;
        'N' : Begin { Next }
                { New Method - 3 character Id for each Dialog }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

                { Return selected option }
                If (NoteBook1.ActivePage = 'nbInstall') Then Begin
                  If radInstall.Checked Then SetVariable(DLLParams, 'V_INSTTYPE', 'A');
                  If radUpgrade.Checked Then SetVariable(DLLParams, 'V_INSTTYPE', 'B');
                  If radAddComp.Checked Then SetVariable(DLLParams, 'V_INSTTYPE', 'C');
                End { If (NoteBook1.ActivePage = 'nbInstall') }
                Else Begin
                  If radUpgrade2.Checked Then SetVariable(DLLParams, 'V_INSTTYPE', 'B');
                  If radAddComp2.Checked Then SetVariable(DLLParams, 'V_INSTTYPE', 'C');
                End; { Else }
              End;
        'X' : Begin { Exit Installation }
                { New Method - 3 character Id for each Dialog }
                SetVariable(DLLParams,'DIALOG','999')
              End;
      End; { If }
    End; { With }
  Finally
    frmInstallType.Free;
  End;

  Result := False;
end; { SCD_GetInstallType }

{---------------------------------------------------------------------------}

procedure TfrmInstallType.Label3Click(Sender: TObject);
begin
  inherited;

  If radUpgrade.Enabled Then
    radUpgrade.Checked := True;
end;

procedure TfrmInstallType.Label2Click(Sender: TObject);
begin
  inherited;

  If radAddComp.Enabled Then
    radAddComp.Checked := True;
end;

procedure TfrmInstallType.Label1Click(Sender: TObject);
begin
  inherited;

  If radAddComp2.Enabled Then
    radAddComp2.Checked := True;
end;

end.

