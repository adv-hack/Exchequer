unit OSErrorFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils, OSChecks;

type
  TfraOSError = class(TFrame)
    panTSSession: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    panServicePacks: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblExit1: TLabel;
    Label3: TLabel;
    panWindowsVer: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    procedure lblExit(Sender: TObject);
  private
    { Private declarations }
    FOSChecks : TOSChecks;
  protected
    Procedure Loaded; Override;
  public
    { Public declarations }
    Procedure InitOSInfo (OSChecks : TOSChecks);
  end;

implementation

{$R *.dfm}

Uses Brand;

//=========================================================================

procedure TfraOSError.Loaded;
Begin // Loaded
  Inherited;

  // Update Branding
  Label2.Caption := ANSIReplaceStr(Label2.Caption, '<APPTITLE>', Branding.pbProductName);
  Label5.Caption := ANSIReplaceStr(Label5.Caption, '<APPTITLE>', Branding.pbProductName);
  Label11.Caption := ANSIReplaceStr(Label11.Caption, '<APPTITLE>', Branding.pbProductName);

  {$IFDEF SETD}
    // Setup.DLL - Workstation Setup - OS Checks dialog
    lblExit1.Visible := False;
    Label16.Visible := False;
    Label3.Visible := False;
  {$ENDIF}
End; // Loaded

//-------------------------------------------------------------------------

Procedure TfraOSError.InitOSInfo (OSChecks : TOSChecks);
Begin // InitOSInfo
  FOSChecks := OSChecks;

  If FOSChecks.ocTSSession Then
  Begin
    // Terminal Server Sessions not supported
    panTSSession.Visible := True;
  End // If FOSChecks.ocTSSession
  Else If FOSChecks.ocNeedsServicePack Then
  Begin
    // OS supported but needs Service Packs
    panServicePacks.Visible := True;
  End // If FOSChecks.ocNeedsServicePack
  Else
  Begin
    // OS not supported
    panWindowsVer.Visible := True;
  End; // Else
End; // InitOSInfo

//-------------------------------------------------------------------------

procedure TfraOSError.lblExit(Sender: TObject);
begin
  Application.Terminate;
end;

end.
