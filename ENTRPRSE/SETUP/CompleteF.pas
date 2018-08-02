unit CompleteF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, TEditVal;

type
  TfrmSetupComplete = class(TSetupTemplate)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

// 'Setup Complete' dialog for Single-CD setup
function SCD_SetupComplete (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.dfm}

Uses CompUtil;

// 'Setup Complete' dialog for Single-CD setup
function SCD_SetupComplete (var DLLParams: ParamRec): LongBool;
Var
  W_Install : String;
Begin // SCD_SetupComplete
  With TfrmSetupComplete.Create(Application) Do
  Begin
    Try
      GetVariable(DLLParams, 'V_INSTALL', W_Install);
      If (W_Install = 'L') Then
      Begin
        // Exchequer LITE Install/Upgrade
      End // If (W_Install = 'L')
      Else If (W_Install = 'W') Then
      Begin
        // Workstation Setup
        TitleLbl.Caption := 'Workstation Setup Complete';
      End; // If (W_Install = 'W')

      ShowModal;
    Finally
      Free;
    End; // Try..Finally
  End; // With TfrmSetupComplete.Create(Application)

  Result := False;
End; // SCD_SetupComplete

end.
