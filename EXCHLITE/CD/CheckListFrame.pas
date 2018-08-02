unit CheckListFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils, WizdMsg, ComCtrls;

type
  TfraCheckList = class(TFrame)
    lblTitle: TLabel;
    lblIntro: TLabel;
    lblOKLink: TLabel;
    lblCancelLink: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure lblOKLinkClick(Sender: TObject);
    procedure lblCancelLinkClick(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure CheckClick(Sender: TObject);
  private
  protected
    Procedure Loaded; Override;
  public
  end;

implementation

{$R *.dfm}

Uses Brand, Math;

//=========================================================================

procedure TfraCheckList.Loaded;
Begin // Loaded
  Inherited;

  // Update Branding
  //lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<APPTITLE>', Branding.pbProductName);

  CheckClick(Self);
End; // Loaded

//-------------------------------------------------------------------------

procedure TfraCheckList.Label3Click(Sender: TObject);
begin
//PR 8/09/06: Checkboxes removed at request of KH
//  chkClosePrograms.Checked := Not chkClosePrograms.Checked;
end;

//-------------------------------------------------------------------------

procedure TfraCheckList.lblOKLinkClick(Sender: TObject);
begin
  // Restart the startup checks, need to set a flag so we don't come directly back here,
  // this must be done via messaging as this frame is destroyed when changing modes and it all gets
  // a bit Access Violaty if done directly
  PostMessage ((Owner As TForm).Handle, WM_RestartChecks, 1, 0);
end;

//------------------------------

procedure TfraCheckList.lblCancelLinkClick(Sender: TObject);
begin
  // Cancel - Close the entire setup program
  Application.Terminate;
end;

//-------------------------------------------------------------------------

procedure TfraCheckList.CheckClick(Sender: TObject);
begin
//PR 8/09/06: Checkboxes removed at request of KH
{  lblOKLink.Enabled := chkSharedFolder.Checked And chkMappedDrive.Checked And chkClosePrograms.Checked;
  lblOKLink.Font.Color := IfThen (lblOKLink.Enabled, clBlue, clGray);}
end;

end.
