unit LWMODDET;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, TEditVal;

type
  TfrmModSettings = class(TForm)
    PageControl1: TPageControl;
    tabshToolkit: TTabSheet;
    tabshWOP: TTabSheet;
    btnOK: TButton;
    btnCancel: TButton;
    ScrollBox1: TScrollBox;
    lblASAHed: Label8;
    Bevel1: TBevel;
    lblCommitHed: Label8;
    panStdWOPNo: TPanel;
    panStdWOPFull: TPanel;
    panStdWOP30: TPanel;
    panProWOPNo: TPanel;
    panProWOPFull: TPanel;
    panProWOP30: TPanel;
    btnToolkitOK: TButton;
    btnToolkitCancel: TButton;
    ScrollBox2: TScrollBox;
    Label81: Label8;
    Bevel2: TBevel;
    Label82: Label8;
    panRunTKNo: TPanel;
    panRunTKFull: TPanel;
    panRunTK30: TPanel;
    panDevTKNo: TPanel;
    panDevTKFull: TPanel;
    panDevTK30: TPanel;
    lstTK30Users: TComboBox;
    lblTK30Users: TLabel;
    Label83: Label8;
    Label84: Label8;
    lblTKFullUsers: TLabel;
    lstTKFullUsers: TComboBox;
    tabshElerts: TTabSheet;
    Label87: Label8;
    lblSentinelCnt: TLabel;
    lstElertSentinels: TComboBox;
    btnElertsOK: TButton;
    btnElertsCancel: TButton;
    ScrollBox3: TScrollBox;
    Label88: Label8;
    panElertsNo: TPanel;
    panElertsFull: TPanel;
    panElerts30: TPanel;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    UpDown3: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure WOPClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnToolkitOKClick(Sender: TObject);
    procedure TKClick(Sender: TObject);
    procedure ElertsClick(Sender: TObject);
    procedure btnElertsOKClick(Sender: TObject);
  private
    { Private declarations }
    FWOPVer   : Byte;
    FWopRel   : Byte;

    FTKVer    : Byte;
    FTKRel    : Byte;

    FElertRel : Byte;

    Procedure SetFont (FntPan : TPanel; Const Select : Boolean);
    procedure SetMode (ParForm : TForm; Const ModuleNo : Byte);
  public
    { Public declarations }
  end;

Function DisplayModDetail (ParForm : TForm; Const ModNo : Byte) : Boolean;

implementation

{$R *.DFM}

Uses LicRec, LicVar;

Function DisplayModDetail (ParForm : TForm; Const ModNo : Byte) : Boolean;
Begin { DisplayModDetail }
  Result := False;

  If (ModNo In [modToolDLL, modStdWOP, modElerts]) Then Begin
    With TfrmModSettings.Create(ParForm) Do
      Try
        SetMode (ParForm, ModNo);

        Result := (ShowModal = mrOk);

      Finally
        Free;
      End;
  End { If (ModNo In [ ... }
  Else
    ShowMessage ('LwModDet.Pas - DisplayModDetail - Invalid Module Number');
End; { DisplayModDetail }

{----------------------------------------------------------------------------}

procedure TfrmModSettings.FormCreate(Sender: TObject);
begin
  FWOPVer := 0;
  FWopRel := 0;

  FTKVer := 0;
  FTKRel := 0;

  FElertRel := 0;
end;

{----------------------------------------------------------------------------}

procedure TfrmModSettings.SetMode (ParForm : TForm; Const ModuleNo : Byte);
begin
  { Hide unnecessary tab sheets }
  tabshToolkit.TabVisible := (ModuleNo = modToolDLL);
  tabshWOP.TabVisible := (ModuleNo = modStdWOP);
  tabshElerts.TabVisible := (ModuleNo = modElerts);

  { Set relevent fields }
  Case ModuleNo Of
    modToolDLL : Begin
                   { Size appropriately for mode }
                   ClientHeight := 215;
                   ClientWidth  := 479;

                   { Centre over parent form }
                   Top := ParForm.Top + ((ParForm.Height - Height) Div 2);
                   Left := ParForm.Left + ((ParForm.Width - Width) Div 2);

                   Caption := 'Developer Toolkits - Detailed Settings';

                   { Setup details }
                   With LicenceInfo Do Begin
                     If (licModules[modToolDLLR] > 0) Then
                       Case licModules[modToolDLLR] Of
                         1 : TKClick(panRunTK30);
                         2 : TKClick(panRunTKFull);
                       End { Case licModules[modToolDLLR] }
                     Else
                       If (licModules[modToolDLL] > 0) Then
                         Case licModules[modToolDLL] Of
                           1 : TKClick(panDevTK30);
                           2 : TKClick(panDevTKFull);
                         End { Case licModules[modToolDLL] }
                       Else
                         TKClick(panRunTKNo);

                     //lstTK30Users.Text := IntToStr(licUserCounts[ucToolkit30]);
                     UpDown2.Position := licUserCounts[ucToolkit30];
                     //lstTKFullUsers.Text := IntToStr(licUserCounts[ucToolkitFull]);
                     UpDown3.Position := licUserCounts[ucToolkitFull];
                   End; { With LicenceInfo }
                 End;

    modStdWOP  : Begin
                   { Size appropriately for mode }
                   ClientHeight := 122;
                   ClientWidth  := 479;

                   { Centre over parent form }
                   Top := ParForm.Top + ((ParForm.Height - Height) Div 2);
                   Left := ParForm.Left + ((ParForm.Width - Width) Div 2);

                   Caption := 'Works Order Processing - Detailed Settings';

                   { Setup details }
                   With LicenceInfo Do
                     If (licModules[modStdWOP] > 0) Then
                       Case licModules[modStdWOP] Of
                         1 : WOPClick(panStdWOP30);
                         2 : WOPClick(panStdWOPFull);
                       End { Case licModules[modStdWOP] }
                     Else
                       If (licModules[modProWOP] > 0) Then
                         Case licModules[modProWOP] Of
                           1 : WOPClick(panProWOP30);
                           2 : WOPClick(panProWOPFull);
                         End { Case licModules[modStdWOP] }
                       Else
                         WOPClick(panStdWOPNo);
                 End;

    modElerts  : Begin
                   { Size appropriately for mode }
                   ClientHeight := 155;
                   ClientWidth  := 479;

                   { Centre over parent form }
                   Top := ParForm.Top + ((ParForm.Height - Height) Div 2);
                   Left := ParForm.Left + ((ParForm.Width - Width) Div 2);

                   Caption := 'Project Elerts - Detailed Settings';

                   { Setup details }
                   With LicenceInfo Do Begin
                     Case licModules[modElerts] Of
                       1 : ElertsClick(panElerts30);
                       2 : ElertsClick(panElertsFull);
                     Else
                       ElertsClick(panElertsNo);
                     End; { Case licModules[modElerts] }

                     UpDown1.Position := licUserCounts[ucElerts];
                   End; { With LicenceInfo }
                 End;
  End; { Case }
end;

{----------------------------------------------------------------------------}

Procedure TfrmModSettings.SetFont (FntPan : TPanel; Const Select : Boolean);
Begin { SetFont }
  With FntPan, Font Do Begin
    If Select Then Begin
      { Selected }
      If ((Tag Mod 10) <> 0) Then Color := clRed;
      Style := [fsBold];
      Size  := 12;
    End { If }
    Else Begin
      { Deselected }
      Color := clBlack;
      Style := [];
      Size  := 8;
    End; { Else }
  End; { With Fnt }
End; { SetFont }

procedure TfrmModSettings.WOPClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    SetFont (panStdWOPNo,   panStdWOPNo = Sender);
    SetFont (panStdWOP30,   panStdWOP30 = Sender);
    SetFont (panStdWOPFull, panStdWOPFull = Sender);
    SetFont (panProWOPNo,   panProWOPNo = Sender);
    SetFont (panProWOP30,   panProWOP30 = Sender);
    SetFont (panProWOPFull, panProWOPFull = Sender);

    FWOPVer := (Sender As TPanel).Tag Div 10;
    FWOPRel := (Sender As TPanel).Tag Mod 10;
  End; { If Sender Is TPanel }
end;

procedure TfrmModSettings.btnOKClick(Sender: TObject);
begin
  With LicenceInfo Do
    If (FWopVer = 1) Then Begin
      licModules[modStdWOP] := 0;
      licModules[modProWOP] := FWOPRel;
    End { If (FWopVer = 1) }
    Else Begin
      licModules[modStdWOP] := FWOPRel;
      licModules[modProWOP] := 0;
    End; { Else }

  ModalResult := mrOk;
  Close;
end;

procedure TfrmModSettings.btnToolkitOKClick(Sender: TObject);
Var
  IntVal  : LongInt;
  ErrCode : Integer;
  OK      : Boolean;
begin
  With LicenceInfo Do Begin
    OK := True;

    If (FTKVer = 1) Then Begin
      licModules[modToolDLLR] := 0;
      licModules[modToolDLL] := FTKRel;
    End { If (FTLVer = 1) }
    Else Begin
      licModules[modToolDLLR] := FTKRel;
      licModules[modToolDLL] := 0;
    End; { Else }

    If (FTKRel > 0) Then Begin
      { Process the user counts }
      Val (lstTK30Users.Text, IntVal, ErrCode);
      OK := (ErrCode = 0) And (IntVal >= 0) And (IntVal <= 999);
      If OK Then
        licUserCounts[ucToolkit30] := IntVal
      Else
        ShowMessage ('The 30-Day User Count is invalid');

      If OK Then Begin
        Val (lstTKFullUsers.Text, IntVal, ErrCode);
        OK := (ErrCode = 0) And (IntVal >= 0) And (IntVal <= 999);
        If OK Then
          licUserCounts[ucToolkitFull] := IntVal
        Else
          ShowMessage ('The Full User Count is invalid');
      End; { If OK }

      If OK Then Begin
        { Check at least one of the user counts is set - either can be 0, but not both }
        OK := (licUserCounts[ucToolkit30] > 0) Or (licUserCounts[ucToolkitFull] > 0);
        If (Not OK) Then
          ShowMessage ('One of the Toolkit User Counts must be set');
      End; { If OK }
    End { If (FTKRel > 0) }
    Else Begin
      licUserCounts[ucToolkit30] := 0;
      licUserCounts[ucToolkitFull] := 0;
    End; { Else }
  End; { With LicenceInfo }

  If OK Then Begin
    ModalResult := mrOk;
    Close;
  End; { if OK }
end;

procedure TfrmModSettings.TKClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    SetFont (panRunTKNo,   panRunTKNo = Sender);
    SetFont (panRunTK30,   panRunTK30 = Sender);
    SetFont (panRunTKFull, panRunTKFull = Sender);
    SetFont (panDevTKNo,   panDevTKNo = Sender);
    SetFont (panDevTK30,   panDevTK30 = Sender);
    SetFont (panDevTKFull, panDevTKFull = Sender);

    FTKVer := (Sender As TPanel).Tag Div 10;
    FTKRel := (Sender As TPanel).Tag Mod 10;

    lblTK30Users.Enabled := (FTKRel > 0);
    lstTK30Users.Enabled := lblTK30Users.Enabled;
    lblTKFullUsers.Enabled := lblTK30Users.Enabled;
    lstTKFullUsers.Enabled := lblTK30Users.Enabled;
  End; { If Sender Is TPanel }
end;

procedure TfrmModSettings.ElertsClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    SetFont (panElertsNo,   panElertsNo = Sender);
    SetFont (panElerts30,   panElerts30 = Sender);
    SetFont (panElertsFull, panElertsFull = Sender);

    FElertRel := (Sender As TPanel).Tag Mod 10;

    // Disable Sentinel Count depending on settings
    lblSentinelCnt.Enabled := (FElertRel > 0);
    lstElertSentinels.Enabled := lblSentinelCnt.Enabled;
  End; { If Sender Is TPanel }
end;

procedure TfrmModSettings.btnElertsOKClick(Sender: TObject);
Var
  IntVal  : LongInt;
  ErrCode : Integer;
  OK      : Boolean;
begin
  With LicenceInfo Do Begin
    OK := True;

    licModules[modElerts] := FElertRel;

    If (licModules[modElerts] > 0) Then Begin
      { Process the Sentinel Count }
      Val (lstElertSentinels.Text, IntVal, ErrCode);
      OK := (ErrCode = 0) And (IntVal > 0) And (IntVal <= 999);
      If OK Then
        licUserCounts[ucElerts] := IntVal
      Else Begin
        ShowMessage ('The Sentinel Count is invalid, the count must be > 0');
        If lstElertSentinels.CanFocus Then lstElertSentinels.SetFocus;
      End; { Else }
    End { If (licModules[modElerts] > 0) }
    Else
      licUserCounts[ucElerts] := 0;
  End; { With LicenceInfo }

  If OK Then ModalResult := mrOk;
end;

end.
