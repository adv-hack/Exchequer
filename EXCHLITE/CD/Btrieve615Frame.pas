unit Btrieve615Frame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils, WizdMsg, ComCtrls, PreReqs;

type
  TfraBtrieve615 = class(TFrame)
    lblTitle: TLabel;
    lblIntro: TLabel;
    radUsing615: TRadioButton;
    radUsingWGE: TRadioButton;
    lblOKLink: TLabel;
    lblCancelLink: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Label2Click(Sender: TObject);
    procedure lblOKLinkClick(Sender: TObject);
    procedure lblCancelLinkClick(Sender: TObject);
    procedure Label3Click(Sender: TObject);
  private
  protected
    Procedure Loaded; Override;
  public
  end;

implementation

{$R *.dfm}

Uses Brand;

//=========================================================================

procedure TfraBtrieve615.Loaded;
Begin // Loaded
  Inherited;

  // Update Branding
  lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<APPTITLE>', Branding.pbProductName);
End; // Loaded

//-------------------------------------------------------------------------

procedure TfraBtrieve615.Label2Click(Sender: TObject);
begin
  radUsing615.Checked := True;
end;

//------------------------------

procedure TfraBtrieve615.Label3Click(Sender: TObject);
begin
  radUsingWGE.Checked := True;
end;

//-------------------------------------------------------------------------

procedure TfraBtrieve615.lblOKLinkClick(Sender: TObject);
begin
  If radUsing615.Checked Then
    // Run the Btrieve v6.15 Pre-Installer and then carry on with the installation process
    PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amInstallBtr615))
  Else
    // Carry on normally and install the WGE, need to set a flag so we don't come directly back here,
    // this must be done via messaging as this frame is destroyed when changing modes and it all gets
    // a bit Access Violaty if done directly
    PostMessage ((Owner As TForm).Handle, WM_RestartChecks, 0, 1);
end;

//------------------------------

procedure TfraBtrieve615.lblCancelLinkClick(Sender: TObject);
begin
  // Cancel - Close the entire setup program
  Application.Terminate;
end;

//-------------------------------------------------------------------------

end.
