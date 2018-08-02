unit SQLICONS;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, BorBtns, ExtCtrls, StdCtrls, SetupU, TEditVal;

type
  TfrmSQLIcons = class(TSetupTemplate)
    Label1: TLabel;
    chkSQLHelp: TBorCheck;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    Label3: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function SCD_SQLIcons(var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;

implementation

{$R *.DFM}

{ Displays the Paperless Module dialog in the Workstation Setup }
function SCD_SQLIcons(var DLLParams: ParamRec): LongBool;
Var
  DlgPN, HlpPath, IconStr : String;
Begin { SCD_SQLIcons }
  { Get path of help file }
  GetVariable(DLLParams, 'INST', DlgPN);
  If Not (Copy (DlgPN, Length(DlgPN), 1)[1] In [':', '\']) Then
    HlpPath := DlgPN + '\'
  Else
    HlpPath := DlgPN;
  Application.HelpFile := HlpPath + 'SETUP.HLP';

  { Get path of data file }
  GetVariable(DLLParams, 'V_MAINDIR', HlpPath);
  HlpPath := IncludeTrailingBackslash(HlpPath);

  { Exchequer Fax Server }
  With TfrmSQLIcons.Create(Application) Do
    Try
      { Get existing settings }
      GetVariable(DLLParams, 'VP_SQLICONS',IconStr);
      chkSQLHelp.Checked := (Pos ('A', IconStr) > 0);

      { Display dialog }
      ShowModal;

      GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);
      Case ExitCode Of
        { Back }
        'B' : SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3));

        { Next }
        'N' : Begin
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

                IconStr := '';
                If chkSQLHelp.Checked Then IconStr := IconStr + 'A';

                { Save details to Wise Script }
                SetVariable(DLLParams,'VP_SQLICONS',IconStr);
              End;

        { Exit Installation }
        'X' : SetVariable(DLLParams,'DIALOG','999')
      End; { Case ExitCode }
    Finally
      Free;
    End;

  Result := False;
End; { SCD_SQLIcons }

{----------------------------------------------------------------------------}


end.
