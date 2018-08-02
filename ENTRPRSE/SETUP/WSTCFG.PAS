unit wstcfg;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU;

type
  TfrmWStationConfig = class(TSetupTemplate)
    radStandard: TRadioButton;
    radLocal: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Label1Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWStationConfig: TfrmWStationConfig;


function SCD_CheckPath(var DLLParams: ParamRec): LongBool; StdCall; export;
function SCD_GetWStationConfig(var DLLParams: ParamRec): LongBool; StdCall; export;


implementation

{$R *.DFM}

Uses CompUtil, DiskUtil;


function SCD_CheckPath(var DLLParams: ParamRec): LongBool;
Begin { SCD_CheckPath }
  Result := Not CheckForUNCPath;

  If Result Then
    SetVariable(DLLParams, 'V_EXECPATH', UpperCase(ExtractFilePath(Application.ExeName)));
End; { SCD_CheckPath }

{---------------------------------------------------------------------------}

{ Get }
function SCD_GetWStationConfig(var DLLParams: ParamRec): LongBool;
var
  frmWStationConfig : TfrmWStationConfig;
  DlgPN, HlpPath    : String;
Begin { SCD_GetWStationConfig }
  { Get path of help file }
  GetVariable(DLLParams, 'INST', DlgPN);
  FixPath(DlgPN);
//ShowMessage ('INST: ' + DlgPN + #13'Application.Exename: ' + Application.Exename);
  Application.HelpFile := DlgPN + 'SETUP.CHM';

  frmWStationConfig := TfrmWStationConfig.Create(Application);
  Try
    With frmWStationConfig Do Begin
      { Setup dialog }
      GetVariable(DLLParams, 'V_LOCPROGS', DlgPN);
      If (DlgPN[1] = 'Y') Then
        radLocal.Checked := True
      Else
        radStandard.Checked := True;

      { Display dialog }
      ShowModal;

      { Get Previous/next dialog ID's }
      If (ExitCode In ['B', 'N']) Then
        GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);

      Case ExitCode Of
        'B' : Begin { Back }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3));
              End;
        'N' : Begin { Next }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

                { Return selected option }
                If radLocal.Checked Then
                  SetVariable(DLLParams,'V_LOCPROGS', 'Y')
                Else
                  SetVariable(DLLParams,'V_LOCPROGS', 'N');
              End;
        'X' : Begin { Exit Installation }
                SetVariable(DLLParams,'DIALOG','999');
              End;
      End; { If }
    End; { With }
  Finally
    frmWStationConfig.Free;
  End;

  Result := False;
End; { SCD_GetWStationConfig }

{---------------------------------------------------------------------------}

procedure TfrmWStationConfig.Label1Click(Sender: TObject);
begin
  inherited;

  radStandard.Checked := True;
end;

procedure TfrmWStationConfig.Label3Click(Sender: TObject);
begin
  inherited;

  radLocal.Checked := True;
end;

end.
