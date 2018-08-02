unit PervWarningFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils;

type
  TfraPervasiveWarning = class(TFrame)
    Label17: TLabel;
    ScrollBox2: TScrollBox;
    panClientServer: TPanel;
    lblServerTitle: TLabel;
    lblServerDesc1: TLabel;
    panRequesters: TPanel;
    lblRequestorTitle: TLabel;
    lblReqDesc: TLabel;
    panWorkgroup: TPanel;
    lblWorkgroupTitle: TLabel;
    lblMDACText: TLabel;
    Label21: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblContinue: TLabel;
    Label20: TLabel;
    lblServerDir: TLabel;
    lblRequesterDir: TLabel;
    lblWGEDir: TLabel;
    lblMoreServerInfo: TLabel;
    lblMoreRequesterInfo: TLabel;
    lblMoreWGEInfo: TLabel;
    panBtrieve: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    lblBtrieveMoreInfo: TLabel;
    procedure lblExit(Sender: TObject);
    procedure lblContinu(Sender: TObject);
    procedure lblMoreServerInfoClick(Sender: TObject);
    procedure lblMoreRequesterInfoClick(Sender: TObject);
    procedure lblMoreWGEInfoClick(Sender: TObject);
    procedure lblBtrieveMoreInfoClick(Sender: TObject);
  private
    { Private declarations }
  protected
  public
    { Public declarations }
    Procedure Init;
  end;

implementation

{$R *.dfm}

Uses Brand, PervInfo, WizdMsg;

//=========================================================================

procedure TfraPervasiveWarning.Init;
Var
  iNextTop : SmallInt;

  Procedure SetupPanel (Const ThePanel : TPanel);
  Begin // SetupPanel
    If ThePanel.Visible Then
    Begin
      ThePanel.Left := panClientServer.Left;
      ThePanel.Top := iNextTop;
      ThePanel.BevelOuter := bvNone;
      ThePanel.Color := Self.Color;
      Inc (iNextTop, ThePanel.Height);
    End; // If ThePanel.Visible
  End; // SetupPanel

Begin // Init
  // Ensure Scroll-Box is at top
  With ScrollBox2.VertScrollBar Do
  Begin
    Position := 0;
    Tracking := True;
  End; // With ScrollBox2.VertScrollBar

  // Work out which panels to show
  panClientServer.Visible := PervasiveInfo.ServerInstalled;
  panRequesters.Visible := PervasiveInfo.ClientInstalled;
  panWorkgroup.Visible := PervasiveInfo.WorkgroupInstalled And (PervasiveInfo.WorkgroupVersion In UpdateWorkgroupVersions);
  panBtrieve.Visible := PervasiveInfo.BtrieveInstalled;

  // close up gaps between panels
  iNextTop := panClientServer.Top;
  SetupPanel (panBtrieve);
  SetupPanel (panClientServer);
  SetupPanel (panRequesters);
  SetupPanel (panWorkgroup);

  // Update embedded tags within labels and show the most important page
  Label6.Caption := ANSIReplaceStr(Label6.Caption, '<APPTITLE>', Branding.pbProductName);
  Label8.Caption := ANSIReplaceStr(Label8.Caption, '<APPTITLE>', Branding.pbProductName);
  If panClientServer.Visible Then
  Begin
    lblServerDir.Caption := ANSIReplaceStr(lblServerDir.Caption, '<SERVERDIR>', PervasiveInfo.ServerInstallDir);
    lblContinue.Visible := False;
  End; // If panClientServer.Visible
  If panRequesters.Visible Then
  Begin
    lblRequesterDir.Caption := ANSIReplaceStr(lblRequesterDir.Caption, '<CLIENTDIR>', PervasiveInfo.ClientInstallDir);
  End; // If panRequesters.Visible
  If panWorkgroup.Visible Then
  Begin
    lblWGEDir.Caption := ANSIReplaceStr(lblWGEDir.Caption, '<WGEDIR>', PervasiveInfo.WorkgroupDirectory);
  End; // If panWorkgroup.Visible
  If panBtrieve.Visible Then
  Begin
    lblContinue.Visible := False;
  End; // If panBtrieve.Visible
End; // Init

//-------------------------------------------------------------------------

procedure TfraPervasiveWarning.lblExit(Sender: TObject);
begin
  Application.Terminate;
end;

//------------------------------

procedure TfraPervasiveWarning.lblContinu(Sender: TObject);
begin
  PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amPreReqs));
end;

//-------------------------------------------------------------------------

procedure TfraPervasiveWarning.lblMoreServerInfoClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,50);
end;

procedure TfraPervasiveWarning.lblMoreRequesterInfoClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,49);
end;

procedure TfraPervasiveWarning.lblMoreWGEInfoClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,60);
end;

procedure TfraPervasiveWarning.lblBtrieveMoreInfoClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,64);
end;

//-------------------------------------------------------------------------


end.
