unit InstMeth;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns;

type
  TfrmEntInstMeth = class(TSetupTemplate)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    radStandard: TRadioButton;
    radCustom: TRadioButton;
    procedure Label1Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function GetEntInstallMethod (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.DFM}

Uses CompUtil;

function GetEntInstallMethod (var DLLParams: ParamRec): LongBool; StdCall; export;
var
  frmEntInstMeth             : TfrmEntInstMeth;
  InstUpg,
  DlgPN, DataStr, W_InstType : String;
Begin { GetEntInstallMethod }
  Result := False;
  { Get path of help file }
  GetVariable(DLLParams, 'INST', DlgPN);
  FixPath(DlgPN);
  Application.HelpFile := DlgPN + 'SETUP.HLP';

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  frmEntInstMeth := TfrmEntInstMeth.Create(Application);
  Try
    With frmEntInstMeth Do Begin
      { Read selected Module info from Setup Script and Initialise Form }
      GetVariable(DLLParams, 'V_MODMETH', DataStr);
      If (DataStr[1] = 'A') Then
        radStandard.Checked := True
      Else
        radCustom.Checked := True;

      { Installation Type }
      GetVariable(DLLParams, 'V_INSTTYPE', W_InstType);
      If (W_InstType = 'B') Then
      Begin
        { Upgrade }
        InstUpg := 'Upgrade';
        HelpContext := 48;
      End // If (W_InstType = 'B')
      Else
      Begin
        { Install }
        InstUpg := 'Install';
        HelpContext := 30;
      End; // Else

      InstrLbl.Caption := ReplaceStrings(InstrLbl.Caption, '%INSTUPG%', InstUpg);
      radStandard.Caption := ReplaceStrings(radStandard.Caption, '%INSTUPG%', InstUpg);
      radCustom.Caption := ReplaceStrings(radCustom.Caption, '%INSTUPG%', InstUpg);

      ShowModal;

      Case ExitCode Of
        'B' : Begin { Back }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3))
              End;
        'N' : Begin { Next }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

                { Save selected Module info to Setup Script }
                If radStandard.Checked Then
                  SetVariable(DLLParams,'V_MODMETH','A')
                Else
                  SetVariable(DLLParams,'V_MODMETH','B');
              End;
        'X' : Begin { Exit Installation }
                SetVariable(DLLParams,'DIALOG','999')
              End;
      End; { If }
    End; { With }
  Finally
    frmEntInstMeth.Free;
  End;
End; { GetEntInstallMethod }


{---------------------------------------------------------------------------}



procedure TfrmEntInstMeth.Label1Click(Sender: TObject);
begin
  inherited;

  radStandard.Checked := True;
end;

procedure TfrmEntInstMeth.Label3Click(Sender: TObject);
begin
  inherited;

  radCustom.Checked := True;
end;

end.                
