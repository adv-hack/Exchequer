unit OutlookAddInsF;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, BorBtns, ExtCtrls, StdCtrls, SetupU, TEditVal;

type
  TfrmOutlookAddIns = class(TSetupTemplate)
    chkInstallAddIns: TBorCheck;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function SCD_OutlookAddIns(var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;

implementation

{$R *.DFM}

Uses OutlookUtil, StrUtils;

{ Displays the Paperless Module dialog in the Workstation Setup }
function SCD_OutlookAddIns(var DLLParams: ParamRec): LongBool;
Var
  DlgPN, sAddIns, PrevDlg : String;
Begin { SCD_OutlookAddIns }
  // Check Outlook is installed on this workstation before offering option
  If OutlookInstalled Then
  Begin
    With TfrmOutlookAddIns.Create(Application) Do
    Begin
      Try
        // Get path of help file
        GetVariable(DLLParams, 'INST', DlgPN);
        Application.HelpFile := IncludeTrailingPathDelimiter(DlgPN) + 'SETUP.HLP';

        // Get existing settings
        GetVariable(DLLParams, 'VP_OUTLOOKADDINS', sAddIns);
        chkInstallAddIns.Checked := (sAddIns = 'Y');

        GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);

        ShowModal;

        Case ExitCode Of
          { Back }
          'B' : SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3));

          { Next }
          'N' : Begin
                  SetVariable(DLLParams,'VP_OUTLOOKADDINS',IfThen(chkInstallAddIns.Checked,'Y','N'));
                  SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));
                End;

          { Exit Installation }
          'X' : SetVariable(DLLParams,'DIALOG','999')
        End; { Case ExitCode }
      Finally
        Free;
      End;
    End; // With TfrmOutlookAddIns.Create(Application)
  End // If OutlookInstalled
  Else
  Begin
    // Not installed so turn off add-ins
    SetVariable(DLLParams,'VP_OUTLOOKADDINS','N');

    // Look at previous dialog to determine which direction we are travelling
    GetVariable(DLLParams,'PREVDIALOG',PrevDlg);
    GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);
    If (Pos(PrevDlg, DlgPN) = 1) Then
      SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3))
    Else
      SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3));
  End; // Else

  Result := False;
End; { SCD_OutlookAddIns }

{----------------------------------------------------------------------------}


end.
