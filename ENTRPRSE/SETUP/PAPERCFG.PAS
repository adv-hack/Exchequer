unit PaperCfg;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, IniFiles, TEditVal, Mask,
  RpDevice;

type
  TfrmPaperConfig = class(TSetupTemplate)
    Notebook1: TNotebook;
    Label1: TLabel;
    Label2: TLabel;
    radEmlEDF: TBorRadio;
    radEmlAdobe: TBorRadio;
    radFaxEnt: TBorRadio;
    Label3: TLabel;
    radFaxMAPI: TBorRadio;
    Label4: TLabel;
    radFaxThird: TBorRadio;
    Label5: TLabel;
    lstThirdParty: TComboBox;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Label84: Label8;
    Label85: Label8;
    radSMTP: TBorRadio;
    radMAPI: TBorRadio;
    Label86: Label8;
    Label87: Label8;
    Label88: Label8;
    Label7: TLabel;
    Label8: TLabel;
    txtEmlName: Text8Pt;
    Label89: Label8;
    txtEmailAddr: Text8Pt;
    Label810: Label8;
    Label811: Label8;
    txtFaxName: Text8Pt;
    Label812: Label8;
    txtFaxNo: Text8Pt;
    txtEmlSMTP: Text8Pt;
    Label9: TLabel;
    Label6: TLabel;
    lstAttachPrn: TComboBox;
    radEmlIntPDF: TBorRadio;
    Label10: TLabel;
    lstAttachPrn2: TComboBox;
    procedure BackBtnClick(Sender: TObject);
    procedure CheckyChecky(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Label10Click(Sender: TObject);
  private
    { Private declarations }
    FLiteMode : Boolean;
  public
    { Public declarations }
    DlgNo : Byte;

    Property LITEMode : Boolean Read FLiteMode Write FLiteMode;

    Procedure SetupDlg (Const xDlgNo : Byte; Const MovingFwd : Boolean);
  end;


function SCD_GotPaperless(var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;
function SCD_PaperlessConfig(var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;

implementation

{$R *.DFM}

Const
  FirstDlg = 1;
  LastDlg  = 4;

{ Checks to see if the Exchequer Paperless Module is installed }
function SCD_GotPaperless(var DLLParams: ParamRec): LongBool;
Var
  ShowDlg, W_MainDir  : String;
  IniF                : TIniFile;
Begin { SCD_GotPaperless }
  { Get path of install/upgrade directory }
  GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
  W_MainDir := IncludeTrailingBackslash(W_MainDir);

  { Default to not showing dialog }
  ShowDlg := 'N';

  // detect previously installed paperless module ?
  If FileExists (W_MainDir + 'WSTATION\SETUP.USR') Then Begin
    { Open .INI file }
    IniF := TIniFile.Create(W_MainDir + 'WSTATION\SETUP.USR');
    Try
      { Show dialog if either entry is missing }
      If (Not IniF.ValueExists('Entrprse', 'PEmail')) Or
         (Not IniF.ValueExists('Entrprse', 'PEmailAttach')) Or
         (Not IniF.ValueExists('Entrprse', 'PFax')) Then
        ShowDlg := 'Y';
    Finally
      IniF.Destroy;
    End;
  End { If }
  Else
    // No Setup.Usr - upgrading from Pre-SCuD - show dialog
    ShowDlg := 'Y';

  // Write result back to Wise
  SetVariable(DLLParams, 'V_CONFIGPAPER', ShowDlg);

  Result := False;
End; { SCD_GotPaperless }


{-----------------------------------------------------------------------------}


{ Gets the Installation Type:- Install, Upgrade, AddComp }
function SCD_PaperlessConfig(var DLLParams: ParamRec): LongBool;
var
  frmPaperConfig   : TfrmPaperConfig;
  DlgPN, HlpPath   : String;
  WiseVar          : String;
begin { SCD_PaperlessConfig }
  { Get path of help file }
  GetVariable(DLLParams, 'INST', DlgPN);
  If Not (Copy (DlgPN, Length(DlgPN), 1)[1] In [':', '\']) Then
    HlpPath := DlgPN + '\'
  Else
    HlpPath := DlgPN;
  Application.HelpFile := HlpPath + 'SETUP.HLP';

  frmPaperConfig := TfrmPaperConfig.Create(Application);
  Try
    With frmPaperConfig Do Begin
      // Get installer type - Exchequer or LITE?
      GetVariable(DLLParams,'V_INSTALL',WiseVar);
      LITEMode := (WiseVar = 'L');

      GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);

      If (StrToInt(DllParams.szParam[0]) = 1) Then
        SetupDlg (FirstDlg, True)
      Else
        SetupDlg (LastDlg, False);

      { Email Methodolgy }
      GetVariable(DLLParams, 'VP_EMLSYS', WiseVar);
      If (WiseVar = 'A') Then radSMTP.Checked := True Else radMAPI.Checked := True;
      GetVariable(DLLParams, 'VP_EMLSMTP', WiseVar);
      txtEmlSMTP.Text := WiseVar;

      { Email Attachment Method }
      GetVariable(DLLParams, 'VP_EMLATTACH', WiseVar);
      If (WiseVar = 'A') Then radEmlEDF.Checked := True Else radEmlAdobe.Checked := True;

      { Email Name & Address }
      GetVariable(DLLParams, 'VP_EMLNAME', WiseVar);
      txtEmlName.Text := WiseVar;
      GetVariable(DLLParams, 'VP_EMLADDR', WiseVar);
      txtEmailAddr.Text := WiseVar;

      { Fax Method }
      GetVariable(DLLParams, 'VP_FAXSYS', WiseVar);
      If (Length(WiseVar) > 0) Then
        Case WiseVar[1] Of
          { Exchequer Fax Server }
          'A'   : radFaxEnt.Checked := True;
          { MAPI - Microsoft Fax }
          'B'   : radFaxMAPI.Checked := True;
          { Other Third Party }
          'C'   : lstThirdParty.ItemIndex := 0;
          { FaxNow3 }
          'D'   : lstThirdParty.ItemIndex := 1;
          { FaxNow5 }
          'E'   : lstThirdParty.ItemIndex := 2;
        End; { Case WiseVar[1] }
      radFaxThird.Checked := (lstThirdParty.ItemIndex >= 0);
      CheckyChecky(frmPaperConfig);

      { Fax Name & Address }
      GetVariable(DLLParams, 'VP_FAXNAME', WiseVar);
      txtFaxName.Text := WiseVar;
      GetVariable(DLLParams, 'VP_FAXNO', WiseVar);
      txtFaxNo.Text := WiseVar;

      { Display dialog }
      ShowModal;

      Case ExitCode Of
        'B',        { Back }
        'N' : Begin { Next }
                If (ExitCode = 'B') Then
                  SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3))
                Else
                  SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

                { Email method }
                If radSMTP.Checked Then WiseVar := 'A' Else WiseVar := 'B';
                SetVariable(DLLParams, 'VP_EMLSYS', WiseVar);
                WiseVar := txtEmlSMTP.Text;
                SetVariable(DLLParams, 'VP_EMLSMTP', WiseVar);

                { Attachment method }
                If radEmlEDF.Checked Then
                  WiseVar := 'A'
                Else
                  If radEmlAdobe.Checked Then
                    // Adobe Accrobat
                    WiseVar := 'B'
                  Else
                    // Internal PDF
                    WiseVar := 'C';
                SetVariable(DLLParams, 'VP_EMLATTACH', WiseVar);

                If radEmlIntPDF.Checked Then
                  // Internal PDF
                  WiseVar := lstAttachPrn2.Text
                Else
                  // EDF / Adobe Acrobat
                  WiseVar := lstAttachPrn.Text;
                SetVariable(DLLParams, 'VP_EMLATTPRN', WiseVar);

                { Email Name & Address }
                WiseVar := txtEmlName.Text;
                SetVariable(DLLParams, 'VP_EMLNAME', WiseVar);
                WiseVar := txtEmailAddr.Text;
                SetVariable(DLLParams, 'VP_EMLADDR', WiseVar);

                { Fax System }
                If radFaxEnt.Checked Then
                  WiseVar := 'A'
                Else Begin
                  If radFaxMAPI.Checked Then
                    WiseVar := 'B'
                  Else
                    If radFaxThird.Checked Then
                      Case lstThirdParty.ItemIndex Of
                        0 : WiseVar := 'C';  { Other/None }
                        1 : WiseVar := 'D';  { FaxNow3 }
                        2 : WiseVar := 'E';  { FaxNow5 }
                      End; { Case lstThirdParty.ItemIndex }
                End; { Else }
                // HM 15/10/02: Corrected variable name as it was preventing FaxNow DLL's being used
                //SetVariable(DLLParams, 'V_PAPFAX', WiseVar);
                SetVariable(DLLParams, 'VP_FAXSYS', WiseVar);

                { Fax Name & Address }
                WiseVar := txtFaxName.Text;
                SetVariable(DLLParams, 'VP_FAXNAME', WiseVar);
                WiseVar := txtFaxNo.Text;
                SetVariable(DLLParams, 'VP_FAXNO', WiseVar);
              End;
        'X' : Begin { Exit Installation }
                { New Method - 3 character Id for each Dialog }
                SetVariable(DLLParams,'DIALOG','999')
              End;
      End; { If }
    End; { With }
  Finally
    frmPaperConfig.Free;
  End;

  Result := False;
end; { SCD_PaperlessConfig }

{---------------------------------------------------------------------------}

procedure TfrmPaperConfig.FormCreate(Sender: TObject);
Var
  I : Byte;
begin
  inherited;

  { Load printers list }
  With RpDev Do
    If (Printers.Count > 0) Then Begin
      For I := 0 To Pred(Printers.Count) Do
        lstAttachPrn.Items.Add (Printers[I]);

      { Default to Default Printer }
      RpDev.DeviceIndex := -1;
      If (RpDev.DeviceIndex <= Pred(lstAttachPrn.Items.Count)) Then
        lstAttachPrn.ItemIndex := RpDev.DeviceIndex
      Else
        lstAttachPrn.ItemIndex := 0;

      // Copy details for Internal PDF Printer combo as well
      lstAttachPrn2.Items.Assign (lstAttachPrn.Items);
      lstAttachPrn2.ItemIndex := lstAttachPrn.ItemIndex;
    End; { If (Printers.Count > 0) }
end;

Procedure TfrmPaperConfig.SetupDlg (Const xDlgNo : Byte; Const MovingFwd : Boolean);
Begin { SetupDlg }
  DlgNo := xDlgNo;


  Case DlgNo Of
    { Email Settings }
    1 : Begin
          ClientHeight := 335;
          HelpContextID := 71;

          //TitleLbl.Caption := 'Paperless Module - Email';
          //InstrLbl.Caption := 'Please specify which Email system you want to use with Exchequer:-';

          NoteBook1.ActivePage := 'nbEmail';
        End; { Email }

    { Email Attachments }
    2 : Begin
          ClientHeight := 429;
          HelpContextID := 74;

          //TitleLbl.Caption := 'Paperless Module - Attachments';
          //InstrLbl.Caption := 'Please specify the format of the Email Attachments you want to use:-';

          NoteBook1.ActivePage := 'nbEmailAttach';
        End; { Email }

    { Fax Settings }
    3 : Begin
          If (NOT FLiteMode) Then
          Begin
            ClientHeight := 335;
            HelpContextID := 75;

            //TitleLbl.Caption := 'Paperless Module - Fax';
            //InstrLbl.Caption := 'Please specify which Fax system you want to use with Exchequer:-';

            NoteBook1.ActivePage := 'nbFaxing';

            CheckyChecky(Self);
          End // If (NOT FLiteMode)
          Else
          Begin
            // LITE Mode - hide faxing details
            If MovingFwd Then
              SetupDlg (DlgNo + 1, MovingFwd)
            Else
              SetupDlg (DlgNo - 1, MovingFwd);
          End; // Else
        End; { Fax }

    { Names, Addresses and Numbers }
    4 : Begin
          ClientHeight := 335;
          HelpContextID := 76;

          //TitleLbl.Caption := 'Paperless Module - Company';
          //InstrLbl.Caption := 'Please specify the Details you want to use with the Exchequer Paperless module:-';

          // Hide Faxing for LITE
          Label810.Visible := Not FLITEMode;
          Label811.Visible := Not FLITEMode;
          Label812.Visible := Not FLITEMode;
          txtFaxName.Visible := Not FLITEMode;
          txtFaxNo.Visible := Not FLITEMode;

          NoteBook1.ActivePage := 'nbNames';
        End; { Fax }
  End; { Case }

  // HM 11/02/02: Reposition screen as height may have changed
  Self.Top := (Screen.Height - Self.Height - GetSystemMetrics(SM_CYCAPTION)) Div 2;
End; { SetupDlg }

procedure TfrmPaperConfig.BackBtnClick(Sender: TObject);
begin
  If (DlgNo = FirstDlg) Then
    { Email Settings - Do Default Action }
    inherited
  Else
    { Fax Settings - Return to Email }
    SetupDlg (DlgNo - 1, False);
end;

procedure TfrmPaperConfig.NextBtnClick(Sender: TObject);
begin
  If (DlgNo < LastDlg) Then
    { Email Settings - Move to Fax Settings }
    SetupDlg (DlgNo + 1, True)
  Else
    { Email Settings - Do Default Action }
    inherited;
end;

procedure TfrmPaperConfig.Label2Click(Sender: TObject);
begin
  inherited;

  radEmlAdobe.Checked := True;
end;

procedure TfrmPaperConfig.Label1Click(Sender: TObject);
begin
  inherited;

  radEmlEDF.Checked := True;
end;

procedure TfrmPaperConfig.Label3Click(Sender: TObject);
begin
  inherited;

  radFaxEnt.Checked := True;

  CheckyChecky(Sender);
end;

procedure TfrmPaperConfig.Label4Click(Sender: TObject);
begin
  inherited;

  radFaxMAPI.Checked := True;

  CheckyChecky(Sender);
end;

procedure TfrmPaperConfig.Label5Click(Sender: TObject);
begin
  inherited;

  radFaxThird.Checked := True;

  CheckyChecky(Sender);
end;

procedure TfrmPaperConfig.CheckyChecky(Sender: TObject);
Begin { CheckyChecky }
  lstThirdParty.Enabled := radFaxThird.Checked;

  { Ensure item always set }
  If (lstThirdParty.ItemIndex < 0) And (lstThirdParty.Items.Count > 0) Then
    lstThirdParty.ItemIndex := 0;
End; { CheckyChecky }

procedure TfrmPaperConfig.Label8Click(Sender: TObject);
begin
  inherited;

  radMAPI.Checked := True;
end;

procedure TfrmPaperConfig.Label7Click(Sender: TObject);
begin
  inherited;

  radSMTP.Checked := True;
end;

procedure TfrmPaperConfig.Label10Click(Sender: TObject);
begin
  inherited;

  radEmlIntPDF.Checked := True;
end;

//-------------------------------------------------------------------------

end.

