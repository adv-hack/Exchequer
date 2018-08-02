unit EBusBeta;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, TEditVal;

type
  TfrmEbusBeta = class(TSetupTemplate)
    Label1: TLabel;
    Label2: TLabel;
    radRemoveBeta: TRadioButton;
    radLeaveBeta: TRadioButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


{ 'Remove eBusiness Beta' dialog for Single-CD setup }
function SCD_EBusBeta (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.DFM}

Uses CompUtil;

{ 'Remove eBusiness Beta' dialog for Single-CD setup }
Function SCD_EBusBeta (var DLLParams: ParamRec): LongBool; StdCall; export;
Var
  W_eBusBeta, DlgPN        : String;
Begin { SCD_EBusBeta }
  Result := False;

  { Get path of help file }
  GetVariable(DLLParams, 'INST', DlgPN);
  FixPath(DlgPN);
  Application.HelpFile := DlgPN + 'SETUP.HLP';

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  With TfrmEbusBeta.Create(Application) Do
    Try
      { 'Remove eBus Beta' Flag }
      GetVariable(DLLParams, 'W_EBUSBETA', W_eBusBeta);
      If (W_eBusBeta = 'N') Then
        radLeaveBeta.Checked := True
      Else
        radRemoveBeta.Checked := True;

      ShowModal;

      Case ExitCode Of
        'B' : Begin { Back }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3))
              End;
        'N' : Begin { Next }
                If radRemoveBeta.Checked Then
                  SetVariable(DLLParams, 'W_EBUSBETA', 'Y')
                Else
                  SetVariable(DLLParams, 'W_EBUSBETA', 'N');

                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));
              End;
        'X' : Begin { Exit Installation }
                SetVariable(DLLParams,'DIALOG','999')
              End;
      End; { If }
    Finally
      Free;
    End;
End; { SCD_EBusBeta }

end.
