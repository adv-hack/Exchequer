unit EntReady;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, TEditVal;

type
  TfrmEntReady = class(TSetupTemplate)
    ScrollBox1: TScrollBox;
    panUpgrade: TPanel;
    panWarnTitle: TPanel;
    panCompany: TPanel;
    panUsers: TPanel;
    panInstall: TPanel;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    lblInstDir: Label8;
    lblInstCompType: Label8;
    lblInstEntVer: Label8;
    Label84: Label8;
    Label86: Label8;
    lblUpgDir: Label8;
    lblUpgEntVer: Label8;
    panTitle: TPanel;
    Label85: Label8;
    Label87: Label8;
    Label88: Label8;
    Label89: Label8;
    lblCompMainDir: Label8;
    lblCompInstDir: Label8;
    lblCompCompType: Label8;
    Label810: Label8;
    panBackup: TPanel;
    chkBackup: TBorCheck;
    Label811: Label8;
    panOverwrite: TPanel;
    chkOverwrite: TBorCheck;
    Label812: Label8;
    chkUsers: TBorCheck;
    Label813: Label8;
    lvlOverWriteDir: Label8;
    Label815: Label8;
    panDowngrade: TPanel;
    Label814: Label8;
    chkDowngrade: TBorCheck;
    panWGEServer: TPanel;
    Label817: Label8;
    chkWGEServer: TBorCheck;
    panSQLDBServer: TPanel;
    Label816: Label8;
    lblSQLDatabaseServer: Label8;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure DoCheckyChecky(Sender: TObject);
    procedure panBackupClick(Sender: TObject);
    procedure panOverwriteClick(Sender: TObject);
    procedure panUsersClick(Sender: TObject);
    procedure panDowngradeClick(Sender: TObject);
  private
    { Private declarations }
    LocPosData  : Array [1..1] Of LongInt;

  public
    { Public declarations }
    Procedure BuildList;
  end;

{ 'Ready To Install' dialog for Single-CD setup }
function SCD_ReadyDlg (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.DFM}

Uses Brand, CompUtil;

Const
  posScrlHOfs   = 1;


{ 'Ready To Install' dialog for Single-CD setup }
function SCD_ReadyDlg (var DLLParams: ParamRec): LongBool; StdCall; export;
var
  frmEntReady                          : TfrmEntReady;
  W_DBType, W_SQLServer, W_SQLDBName,
  W_OverWrite, WiseStr, W_eBusBeta,
  W_MainDir, W_CompDir, W_EntVer,
  W_WGEServer, W_GLTemplateName,
  W_DemoData, W_InstType, DlgPN        : String;
Begin { SCD_ReadyDlg }
  Result := False;

  { Get path of help file }
  GetVariable(DLLParams, 'INST', DlgPN);
  FixPath(DlgPN);
  Application.HelpFile := DlgPN + 'SETUP.HLP';

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  frmEntReady := TfrmEntReady.Create(Application);
  Try
    With frmEntReady Do Begin
      { Resize for the resolution }
      AutoResize (2, 0);

      // Insert product name into window
      ModifyCaptions ('<APPTITLE>', Branding.pbProductName, [chkUsers, Label813]);

      { Read Data from Setup script and setup the Install and Warning Info }

      { Installation Type }
      GetVariable(DLLParams, 'V_INSTTYPE', W_InstType);

      { Main Directory }
      GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);

      { Overwrite Warning Flag }
      GetVariable(DLLParams, 'W_OVERWRITE', W_OverWrite);

      { Remove eBus Beta Flag }
      GetVariable(DLLParams, 'W_EBUSBETA', W_eBusBeta);

      // Changing Workgroup Engine Server flag
      GetVariable(DLLParams, 'W_WGESERVER', W_WGEServer);

      // LITE - GL Template Name
      GetVariable(DLLParams, 'V_GLTEMPLATENAME', W_GLTemplateName);

      GetVariable(DLLParams, 'L_DBTYPE', W_DBType);

      If (W_InstType[1] In ['A', 'B']) Then Begin
        { Install or Upgrade - Get Exchequer Version }
        GetVariable(DLLParams, 'D_ENTVER', W_EntVer);
      End; { If (W_InstType[1] In ['A', 'B']) }

      If (W_InstType[1] In ['A', 'C']) Then Begin
        { Install or Add Company - Get Data Type }
        GetVariable(DLLParams, 'V_DEMODATA', W_DemoData);
      End; { If (W_InstType In ['A', 'C']) }

      If (W_InstType[1] = 'C') Then Begin
        { Add Company - Get New Company Directory }
        GetVariable(DLLParams, 'V_COMPDIR', W_CompDir);
      End; { If (W_InstType = 'C') }

      panInstall.Visible := (W_InstType[1] = 'A');
      If panInstall.Visible Then Begin
        { Update dialog title }
        TitleLbl.Caption := TitleLbl.Caption + 'Install';

        lblInstDir.Caption := W_MainDir;
        If (W_DemoData = 'Y') Then
          lblInstCompType.Caption := 'Demonstration'
        Else
        Begin
          If (W_GLTemplateName <> '') Then
            lblInstCompType.Caption := 'New Company (' + W_GLTemplateName + ')'
          Else
            lblInstCompType.Caption := 'New Company';
        End; // Else
        lblInstEntVer.Caption := W_EntVer;

        HelpContext := 32;
      End; { If panInstall.Visible }

      panSQLDBServer.Visible := (W_InstType[1] = 'A') And (W_DBType = '1');
      If panSQLDBServer.Visible Then
      Begin
        GetVariable(DLLParams, 'SQLSERVER', W_SQLServer);
        GetVariable(DLLParams, 'V_SQLDBNAME', W_SQLDBName);
        lblSQLDatabaseServer.Caption := W_SQLDBName + ' on ' + W_SQLServer;
      End; // If panSQLDBServer.Visible

      panUpgrade.Visible := (W_InstType[1] = 'B');
      If panUpgrade.Visible Then Begin
        { Update dialog title }
        TitleLbl.Caption := TitleLbl.Caption + 'Upgrade';

        { Modify Next button from Install to Upgrade }
        NextBtn.Caption := '&Upgrade';

        lblUpgDir.Caption := W_MainDir;
        lblUpgEntVer.Caption := W_EntVer;

        HelpContext := 73;
      End; { If panUpgrade.Visible }

      panCompany.Visible := (W_InstType[1] = 'C');
      If panCompany.Visible Then Begin
        { Update dialog title }
        TitleLbl.Caption := TitleLbl.Caption + 'Add A Company';

        lblCompMainDir.Caption := W_MainDir;
        lblCompInstDir.Caption := W_CompDir;
        If (W_DemoData = 'Y') Then
          lblCompCompType.Caption := 'Demonstration'
        Else
        Begin
          If (W_GLTemplateName <> '') Then
            lblCompCompType.Caption := 'New Company (' + W_GLTemplateName + ')'
          Else
            lblCompCompType.Caption := 'New Company';
        End; // Else

        HelpContext := 3;
      End; { If panCompany.Visible }

      panBackup.Visible := (W_InstType[1] In ['B', 'C']);

      panOverwrite.Visible := (W_OverWrite = 'Y');
      If panOverwrite.Visible Then Begin
        GetVariable(DLLParams, 'W_OWDIR', WiseStr);
        lvlOverWriteDir.Caption := WiseStr;
      End; { If panOverwrite.Visible }

      panUsers.Visible := (W_InstType[1] In ['B', 'C']);

      If (W_InstType[1] = 'B') Then Begin
        {panDowngrade.Visible And chkDowngrade.Checked));}
        GetVariable(DLLParams, 'W_MODVER', WiseStr);
        panDowngrade.Visible := (WiseStr = 'Y');

        If (Not panDowngrade.Visible) Then Begin
          GetVariable(DLLParams, 'W_NONCS', WiseStr);
          panDowngrade.Visible := (WiseStr = 'Y');
        End; { If (Not panDowngrade.Visible) }

        If (Not panDowngrade.Visible) Then Begin
          GetVariable(DLLParams, 'W_CCYVER', WiseStr);
          panDowngrade.Visible := (WiseStr = 'Y');
        End; { If (Not panDowngrade.Visible) }

        If (Not panDowngrade.Visible) Then Begin
          GetVariable(DLLParams, 'W_UCOUNT', WiseStr);
          panDowngrade.Visible := (WiseStr = 'Y');
        End; { If (Not panDowngrade.Visible) }
      End { If (W_InstType[1] = 'B') }
      Else
        panDowngrade.Visible := False;

      // HM 23/07/04: Added warning for change of WGE Server PC
      panWGEServer.Visible := (W_InstType[1] In ['B']) And (W_WGEServer = 'Y');

      { Show the Wanring Title panel if any of the warnings are visible }
      panWarnTitle.Visible := panBackup.Visible Or panOverwrite.Visible Or panUsers.Visible Or
                              panDowngrade.Visible Or panWGEServer.Visible;

      { Re-arrange panels on form to look nice and pretty }
      BuildList;

      ShowModal;

      Case ExitCode Of
        'B' : Begin { Back }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3))
              End;
        'N' : Begin { Next }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));
              End;
        'X' : Begin { Exit Installation }
                SetVariable(DLLParams,'DIALOG','999')
              End;
      End; { If }
    End; { With frmEntReady }
  Finally
    frmEntReady.Free;
  End;
End; { SCD_ReadyDlg }


{---------------------------------------------------------------------------}


Procedure TfrmEntReady.BuildList;
Var
  NextTopL : LongInt;

  Procedure SetupPanel (Const ThePanel :  TControl; Var NextTop : LongInt);
  Begin { SetupPanel }
    If ThePanel.Visible Then Begin
      With ThePanel Do Begin
        Top := NextTop;
        Inc (NextTop, Height);

        Left := 2;
        Width := 380;
      End; { With }
    End; { If }
  End; { SetupPanel }

Begin { BuildList }
  NextTopL := 1;

  SetupPanel (panTitle, NextTopL);
  SetupPanel (panInstall, NextTopL);
  SetupPanel (panSQLDBServer, NextTopL);
  SetupPanel (panUpgrade, NextTopL);
  SetupPanel (panCompany, NextTopL);
  SetupPanel (panWarnTitle, NextTopL);
  SetupPanel (panBackup, NextTopL);
  SetupPanel (panOverwrite, NextTopL);
  SetupPanel (panUsers, NextTopL);
  SetupPanel (panDowngrade, NextTopL);
  SetupPanel (panWGEServer, NextTopL);

  DoCheckyChecky(Self);
End; { BuildList }

procedure TfrmEntReady.FormCreate(Sender: TObject);
begin
  inherited;

  // Configure Scroll-Box Scroll Bar - doesn't work if you set them at Design-Time!
  With ScrollBox1.VertScrollBar Do Begin
    Position := 0;
    Tracking := True;
  End; { With ScrollBox1.VertScrollBar }

  { Generate postion data for dynamic resizing }
  LocPosData[posScrlHOfs] := Self.Height - ScrollBox1.Height;
end;

procedure TfrmEntReady.FormResize(Sender: TObject);
begin
  inherited;

  { Generate postion data for dynamic resizing }
  ScrollBox1.Height := Self.Height - LocPosData[posScrlHOfs];
end;

procedure TfrmEntReady.NextBtnClick(Sender: TObject);
begin
  If NextBtn.Enabled Then Begin
    inherited;

  End; { If NextBtn.Enabled }
end;

procedure TfrmEntReady.DoCheckyChecky(Sender: TObject);
begin
  inherited;

  NextBtn.Enabled := ((Not panUsers.Visible) Or (panUsers.Visible And chkUsers.Checked)) And
                     ((Not panBackup.Visible) Or (panBackup.Visible And chkBackup.Checked)) And
                     ((Not panOverwrite.Visible) Or (panOverwrite.Visible And chkOverwrite.Checked)) And
                     ((Not panDowngrade.Visible) Or (panDowngrade.Visible And chkDowngrade.Checked)) And
                     ((Not panWGEServer.Visible) Or (panWGEServer.Visible And chkWGEServer.Checked));

end;

procedure TfrmEntReady.panBackupClick(Sender: TObject);
begin
  inherited;

  chkBackup.Checked := Not chkBackup.Checked;
  DoCheckyChecky(Sender);
end;

procedure TfrmEntReady.panOverwriteClick(Sender: TObject);
begin
  inherited;

  chkOverwrite.Checked := Not chkOverwrite.Checked;
  DoCheckyChecky(Sender);
end;

procedure TfrmEntReady.panUsersClick(Sender: TObject);
begin
  inherited;

  chkUsers.Checked := Not chkUsers.Checked;
  DoCheckyChecky(Sender);
end;

procedure TfrmEntReady.panDowngradeClick(Sender: TObject);
begin
  inherited;

  chkDowngrade.Checked := Not chkDowngrade.Checked;
  DoCheckyChecky(Sender);
end;

end.
