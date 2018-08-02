unit WsStart;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns;

type
  TfrmWsStartup = class(TSetupTemplate)
    Label2: TLabel;
    radYes: TRadioButton;
    radNo: TRadioButton;
    Label1: TLabel;
    Label4: TLabel;
    procedure Label1Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function SCD_WSStartRepl (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.DFM}

Uses Brand, CompUtil;

function SCD_WSStartRepl (var DLLParams: ParamRec): LongBool; StdCall; export;
var
  frmWsStartup : TfrmWsStartup;
  DlgPN, DataStr : String;
Begin { SCD_WSStartRepl }
  Result := False;

  { Get path of help file }
  GetVariable(DLLParams, 'INST', DlgPN);
  FixPath(DlgPN);
  Application.HelpFile := DlgPN + 'SETUP.HLP';

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  frmWsStartup := TfrmWsStartup.Create(Application);
  Try
    With frmWsStartup Do Begin
      // Insert product name into window
      ModifyCaptions ('<APPTITLE>', Branding.pbProductName, [InstrLbl]);

      { Read selected Module info from Setup Script and Initialise Form }
      GetVariable(DLLParams, 'V_STARTREPL', DataStr);
      If (DataStr[1] = 'Y') Then
        radYes.Checked := True
      Else
        radNo.Checked := True;

      ShowModal;

      Case ExitCode Of
        'B' : Begin { Back }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3))
              End;
        'N' : Begin { Next }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

                { Save selected Module info to Setup Script }
                If radYes.Checked Then
                  SetVariable(DLLParams,'V_STARTREPL','Y')
                Else
                  SetVariable(DLLParams,'V_STARTREPL','N');
              End;
        'X' : Begin { Exit Installation }
                SetVariable(DLLParams,'DIALOG','999')
              End;
      End; { If }
    End; { With }
  Finally
    frmWsStartup.Free;
  End;
End; { SCD_WSStartRepl }


{---------------------------------------------------------------------------}



procedure TfrmWsStartup.Label1Click(Sender: TObject);
begin
  inherited;

  radYes.Checked := True;
end;

procedure TfrmWsStartup.Label3Click(Sender: TObject);
begin
  inherited;

  radNo.Checked := True;
end;

end.
