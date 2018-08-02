unit iaoOSChecksF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, WiseAPI, ExtCtrls, StdCtrls, OSChecks;

type
  TfrmIAOOSChecks = class(TSetupTemplate)
  private
  public
  end; // TfrmIAOOSChecks


// Used by IAO Workstation Setup - Returns TRUE if running on an unsupported OS
function iaoCheckSupportedOS (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.dfm}

Uses OSErrorFrame;

//=========================================================================

// Used by IAO Workstation Setup - Returns TRUE if running on an unsupported OS
function iaoCheckSupportedOS (var DLLParams: ParamRec): LongBool;
var
  frmIAOOSChecks : TfrmIAOOSChecks;
  oOSChecks      : TOSChecks;
Begin // iaoCheckSupportedOS
  oOSChecks := TOSChecks.Create;
  Try
    Result := NOT oOSChecks.ocSupportedOS;

    If Result Then
    Begin
      frmIAOOSChecks := TfrmIAOOSChecks.Create(NIL);
      Try
        // Re-use the OS Error Frame from the IAO CD Auto-Run
        With TfraOSError.Create(frmIAOOSChecks) Do
        Begin
          Parent := frmIAOOSChecks;
          Top := 10;
          Left := 167;
          
          InitOSInfo (oOSChecks);
        End; // With TfraOSError.Create(frmIAOOSChecks)

        frmIAOOSChecks.ShowModal;
      Finally
        frmIAOOSChecks.Free;
      End; // Try..Finally
    End; // If Result
  Finally
    oOSChecks.Free;
  End; // Try..Finally
End; // iaoCheckSupportedOS

//=========================================================================

end.
