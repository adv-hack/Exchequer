unit lwModule;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, TEditVal, Buttons, Menus;

type
  TfrmLicWiz4 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    btnNext: TButton;
    btnPrevious: TButton;
    ScrollBox1: TScrollBox;
    PopupMenu1: TPopupMenu;
    Popup_AllNone: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Popup_All30: TMenuItem;
    Popup_AllFull: TMenuItem;
    lblASAHed: Label8;
    Bevel1: TBevel;
    Label81: Label8;
    Bevel3: TBevel;
    Label83: Label8;
    Bevel4: TBevel;
    Label84: Label8;
    Bevel5: TBevel;
    lblReportWriter: Label8;
    Bevel6: TBevel;
    lblTeleHed: Label8;
    Bevel7: TBevel;
    Label87: Label8;
    lblEBus: Label8;
    Bevel8: TBevel;
    lblOLEHed: Label8;
    Bevel10: TBevel;
    lblPaperHed: Label8;
    Bevel11: TBevel;
    lblCommitHed: Label8;
    Bevel9: TBevel;
    lblTradeHed: Label8;
    Bevel12: TBevel;
    Bevel13: TBevel;
    Label82: Label8;
    Bevel14: TBevel;
    lblWOPHed: Label8;
    panAccStkNo: TPanel;
    panAccStkFull: TPanel;
    panAccStk30: TPanel;
    panImpModNo: TPanel;
    panImpModFull: TPanel;
    panJobCostNo: TPanel;
    panJobCostFull: TPanel;
    panJobCost30: TPanel;
    panODBCNo: TPanel;
    panODBCFull: TPanel;
    panRepWrtNo: TPanel;
    panRepWrtFull: TPanel;
    panRepWrt30: TPanel;
    panTeleSaleFull: TPanel;
    panTeleSale30: TPanel;
    panTeleSaleNo: TPanel;
    panToolDllInfo: TPanel;
    panEBusNo: TPanel;
    panEBusFull: TPanel;
    panEBus30: TPanel;
    panOLENo: TPanel;
    panOLEFull: TPanel;
    panOLE30: TPanel;
    panPaperFull: TPanel;
    panPaper30: TPanel;
    panPaperNo: TPanel;
    panCommitNo: TPanel;
    panCommitFull: TPanel;
    panCommit30: TPanel;
    btnToolkitSettings: TButton;
    panTradeNo: TPanel;
    panTrade30: TPanel;
    panTradeFull: TPanel;
    lstTradeUsers: TComboBox;
    lblTradeUsers: TLabel;
    btnWOPSettings: TButton;
    panWOPInfo: TPanel;
    panElertInfo: TPanel;
    btnElertSettings: TButton;
    lblEnhSec: Label8;
    panEnhSecNo: TPanel;
    panEnhSec30: TPanel;
    panEnhSecFull: TPanel;
    Bevel2: TBevel;
    UpDown1: TUpDown;
    lblAppValHed: Label8;
    panAppValNo: TPanel;
    panAppVal30: TPanel;
    panAppValFull: TPanel;
    lblCISRCTHed: Label8;
    panCISRCTNo: TPanel;
    panCISRCT30: TPanel;
    panCISRCTFull: TPanel;
    lblFullStk: Label8;
    Bevel15: TBevel;
    panFullStkNo: TPanel;
    panFullStk30: TPanel;
    panFullStkFull: TPanel;
    Bevel16: TBevel;
    Label86: Label8;
    panVRWNo: TPanel;
    panVRW30: TPanel;
    panVRWFull: TPanel;
    lblGoodsReturns: Label8;
    Bevel17: TBevel;
    panGoodsReturnsNo: TPanel;
    panGoodsReturns30: TPanel;
    panGoodsReturnsFull: TPanel;
    Bevel18: TBevel;
    panEBankFull: TPanel;
    panEBank30: TPanel;
    panEBankNo: TPanel;
    lblEBank: Label8;
    lblOutlookHed: Label8;
    panOutlookNo: TPanel;
    panOutlook30: TPanel;
    panOutlookFull: TPanel;
    Bevel19: TBevel;
    panImpMod30: TPanel;
    lblGDPRHed: Label8;
    Bevel20: TBevel;
    panGDPRNo: TPanel;
    panGDPR30: TPanel;
    panGDPRFull: TPanel;
    lblPervEncryptionHed: Label8;
    Bevel21: TBevel;
    panPervEncryptFull: TPanel;
    panPervEncrypt30: TPanel;
    panPervEncryptNo: TPanel;
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure AccStkAnalClick(Sender: TObject);
    procedure ImpModClick(Sender: TObject);
    procedure JobCostClick(Sender: TObject);
    procedure ODBCClick(Sender: TObject);
    procedure RepWrtClick(Sender: TObject);
    procedure TelesalesClick(Sender: TObject);
    procedure TooDllClick(Sender: TObject);
    procedure ToolDll2Click(Sender: TObject);
    procedure EBusClick(Sender: TObject);
    procedure Popup_SetAllMods(Sender: TObject);
    procedure OLEClick(Sender: TObject);
    procedure PaperClick(Sender: TObject);
    procedure SelectODBC(Sender: TObject; RelLinks : Boolean);
    procedure panCommitNoClick(Sender: TObject);
    procedure TradeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnWOPSettingsClick(Sender: TObject);
    procedure btnToolkitSettingsClick(Sender: TObject);
    procedure btnElertSettingsClick(Sender: TObject);
    procedure EnhSecClick(Sender: TObject);
    procedure AppValClick(Sender: TObject);
    procedure CISRCTClick(Sender: TObject);
    procedure FullStkClick(Sender: TObject);
    procedure VRWClick(Sender: TObject);
    procedure GoodsReturnsClick(Sender: TObject);
    procedure EBankClick(Sender: TObject);
    procedure OutlookClick(Sender: TObject);
    procedure GDPRClick(Sender: TObject);
    procedure PervEncryptClick(Sender: TObject);
  private
    { Private declarations }
    Procedure SetFont (FntPan : TPanel; Const Select : Boolean);
    Procedure SetStatus (Const Status : Byte; PanNo, Pan30, PanFull : TPanel);

    procedure SetAppValState;
    procedure SetCISRCTState;
    procedure SetElertText;
    procedure SetTKDLLText;
    procedure SetWOPText;

    procedure DoWOPSettings(Sender: TObject; RelLinks : Boolean);
  public
    { Public declarations }
    WizMod : SmallInt;
    procedure ReInit;
  end;


Procedure LicWiz_EntMods (Var   WizForm           : TfrmLicWiz4;
                          Var   WizNo, LastWiz    : Byte;
                          Const WizPrev, WizNext  : Byte;
                          Var   Done, Aborted     : Boolean);


implementation

{$R *.DFM}

Uses LicRec, LicVar, LwModDet;


Procedure LicWiz_EntMods (Var   WizForm           : TfrmLicWiz4;
                          Var   WizNo, LastWiz    : Byte;
                          Const WizPrev, WizNext  : Byte;
                          Var   Done, Aborted     : Boolean);
Begin { LicWiz_EntMods }
  If (LicenceInfo.licType In [0, 1]) Then Begin
    { Create Form as and when necessary }
    If Not Assigned(WizForm) Then Begin
      WizForm := TfrmLicWiz4.Create(Application.MainForm);
    End; { If Not Assigned(WizForm)  }

    { Re-Initialise forms return value }
    WizForm.ReInit;

    { Display Form }
    WizForm.ShowModal;

    { Process return value }
    Case WizForm.WizMod Of
      Wiz_Abort  : Aborted := True;

      Wiz_Prev   : WizNo := WizPrev;

      Wiz_Next   : WizNo := WizNext;
    End; { Case }
  End { If (LicenceInfo.licType In [0, 1]) }
  Else Begin
    If (LastWiz = WizPrev) Then
      WizNo := WizNext
    Else
      WizNo := WizPrev;
  End; { Else }

  LastWiz := Wiz_Modules;
End; { LicWiz_EntMods }

{----------------------------------------------------------------------------}


Procedure TfrmLicWiz4.SetStatus (Const Status : Byte; PanNo, Pan30, PanFull : TPanel);
Begin { SetStatus }
  If Assigned(panNo) Then SetFont (panNo, (Status = 0));
  If Assigned(pan30) Then SetFont (pan30, (Status = 1));
  If Assigned(panFull) Then SetFont (panFull, (Status = 2));
End; { SetStatus }

procedure TfrmLicWiz4.ReInit;

  Function Squidgy : ShortString;
  Begin { Squidgy }
    If (LicenceInfo.licType = 0) Then
      { Install }
      Result := 'NO'
    Else
      { Upgrade / Auto-Upgrade }
      Result := 'AUTO';
  End; { Squidgy }

Begin { ReInit }
  licInitWin (Self, Wiz_Modules);

  { Init local variables }
  WizMod := Wiz_Abort;

  { For Updates 'No' should be 'Auto' on release code items }
  panAccStkNo.Caption := Squidgy;
  panCommitNo.Caption := Squidgy;
  panEBusNo.Caption := Squidgy;
  panEnhSecNo.Caption := Squidgy;
  panFullStkNo.Caption := Squidgy;
  panGoodsReturnsNo.Caption := Squidgy;
  panImpModNo.Caption := Squidgy;
  panJobCostNo.Caption := Squidgy;
  //panODBCNo - Not Release Coded
  panOLENo.Caption := Squidgy;
  panPaperNo.Caption := Squidgy;
  panRepWrtNo.Caption := Squidgy;
  panTeleSaleNo.Caption := Squidgy;
  panTradeNo.Caption := Squidgy;
  panVRWNo.Caption := Squidgy;
  panEBankNo.Caption := Squidgy;
  panOutlookNo.Caption := Squidgy;

  { Set defaults to screen }
  With LicenceInfo Do Begin
    { ASA + Telesales not available in Non-Stock Versions }
    lblASAHed.Enabled := (licEntModVer > 0);
    panAccStkNo.Visible := lblASAHed.Enabled;
    panAccStk30.Visible := lblASAHed.Enabled;
    panAccStkFull.Visible := lblASAHed.Enabled;

    lblTeleHed.Enabled := (licEntModVer > 1);
    panTeleSaleNo.Visible := lblTeleHed.Enabled;
    panTeleSale30.Visible := lblTeleHed.Enabled;
    panTeleSaleFull.Visible := lblTeleHed.Enabled;

    // HM 26/01/01: Trade Counter not available in Non-Stock
    lblTradeHed.Enabled := (licEntModVer > 0);
    panTradeNo.Visible := lblTradeHed.Enabled;
    panTrade30.Visible := lblTradeHed.Enabled;
    panTradeFull.Visible := lblTradeHed.Enabled;
    lblTradeUsers.Visible := lblTradeHed.Enabled;
    lstTradeUsers.Visible := lblTradeHed.Enabled;
    If lblTradeUsers.Visible Then Begin
      lblTradeUsers.Enabled := (LicenceInfo.licModules[modTrade] > 0);
      lstTradeUsers.Enabled := lblTradeUsers.Enabled;
      //lstTradeUsers.Text := IntToStr(licUserCounts[ucTradeCounter]);
      UpDown1.Position := licUserCounts[ucTradeCounter];
    End; { If lblTradeUsers.Visible }

    // HM 25/08/04: Added Full Stock Control - requires Stock or Spop modules
    lblFullStk.Enabled := (licEntModVer > 0);
    panFullStkNo.Visible := lblFullStk.Enabled;
    panFullStk30.Visible := lblFullStk.Enabled;
    panFullStkFull.Visible := lblFullStk.Enabled;

    // MH 21/07/05: Added Goods Returns
    lblGoodsReturns.Enabled := (licEntModVer > 0);
    panGoodsReturnsNo.Visible := lblGoodsReturns.Enabled;
    panGoodsReturns30.Visible := lblGoodsReturns.Enabled;
    panGoodsReturnsFull.Visible := lblGoodsReturns.Enabled;

    { WOP not available in non-stock versions }
    lblWOPHed.Enabled := (licEntModVer > 0);
    btnWOPSettings.Visible := lblWOPHed.Enabled;
    panWOPInfo.Visible := lblWOPHed.Enabled;

    lblReportWriter.Enabled := (licType > 0);
    panRepWrtNo.Visible := lblReportWriter.Enabled;
    panRepWrt30.Visible := lblReportWriter.Enabled;
    panRepWrtFull.Visible := lblReportWriter.Enabled;

    // HM 10/01/02: Added CIS/RCT & Applications/Valuations Support
    SetAppValState;
    SetCISRCTState;

    // MH 15/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
    lblPervEncryptionHed.Enabled := (licEntDB = 0); // Pervasive Only
    panPervEncryptNo.Visible := lblPervEncryptionHed.Enabled;
    panPervEncrypt30.Visible := lblPervEncryptionHed.Enabled;
    panPervEncryptFull.Visible := lblPervEncryptionHed.Enabled;
    If (Not lblPervEncryptionHed.Enabled) Then
      // Disable Pervasive Encryption for non-Pervasive Editions
      licModules[modPervEncrypt] := 0;

    If lblASAHed.Enabled Then
      SetStatus (licModules[modAccStk],   panAccStkNo,    panAccStk30,    panAccStkFull)
    Else
      licModules[modAccStk] := 0;
    SetStatus (licModules[modCommit],    panCommitNo,       panCommit30,       panCommitFull);
    SetStatus (licModules[modeBus],      panEBusNo,         panEBus30,         panEBusFull);
    SetStatus (licModules[modEnhSec],    panEnhSecNo,       panEnhSec30,       panEnhSecFull);
    SetStatus (licModules[modFullStock], panFullStkNo,      panFullStk30,      panFullStkFull);
    SetStatus (licModules[modImpMod],    panImpModNo,       panImpMod30,       panImpModFull);
    SetStatus (licModules[modJobCost],   panJobCostNo,      panJobCost30,      panJobCostFull);
    SetStatus (licModules[modODBC],      panODBCNo,         Nil,               panODBCFull);
    SetStatus (licModules[modOLESave],   panOLENo,          panOLE30,          panOLEFull);
    SetStatus (licModules[modPaperless], panPaperNo,        panPaper30,        panPaperFull);

    SetStatus (licModules[modRepWrt],    panRepWrtNo,    panRepWrt30,    panRepWrtFull);
    SetElertText;
    If lblTeleHed.Enabled Then
      SetStatus (licModules[modTeleSale], panTeleSaleNo,  panTeleSale30,  panTeleSaleFull)
    Else
      licModules[modTeleSale] := 0;
    //SetStatus (licModules[modToolDLL],   panToolDLLNo,   panToolDLL30,   panToolDLLFull);
    //SetStatus (licModules[modToolDLLR],  panToolDLL2No,  panToolDLL230,  panToolDLL2Full);
    SetTKDLLText;

    // HM 26/01/01: Trade Counter not available in Non-Stock
    If lblTradeHed.Enabled Then
      SetStatus (licModules[modTrade], panTradeNo,  panTrade30,  panTradeFull)
    Else
      licModules[modTrade] := 0;

    // HM 04/09/02: Modified to disable the WOP module because of the enterprise version
    If lblWOPHed.Enabled Then
      { Works Order Processing }
      SetWOPText
    Else Begin
      // WOP not available - turn both versions off
      LicenceInfo.licModules[modStdWOP] := 0;
      LicenceInfo.licModules[modProWOP] := 0;
    End; { Else }

    // HM 10/01/02: Added CIS/RCT & Applications/Valuations Support
    SetStatus (licModules[modAppVal], panAppValNo,     panAppVal30,     panAppValFull);
    SetStatus (licModules[modCISRCT], panCISRCTNo,     panCISRCT30,     panCISRCTFull);

    // HM 28/02/05: Added Visual Report Writer support
    SetStatus (licModules[modVisualRW], panVRWNo, panVRW30, panVRWFull);

    // HM 21/07/05: Added Goods Returns support
    SetStatus (licModules[modGoodsRet],  panGoodsReturnsNo, panGoodsReturns30, panGoodsReturnsFull);

    // HM 26/10/06: Added E-Banking support
    SetStatus (licModules[modEBanking],  panEBankNo, panEBank30, panEBankFull);

    // HM 09/01/07: Added Outlook Dashboard support
    SetStatus (licModules[modOutlookDD],  panOutlookNo, panOutlook30, panOutlookFull);

    // MH 15/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
    SetStatus (licModules[modGDPR],         panGDPRNo,        panGDPR30,        panGDPRFull);
    SetStatus (licModules[modPervEncrypt],  panPervEncryptNo, panPervEncrypt30, panPervEncryptFull);
  End; { With }
End; { ReInit }

procedure TfrmLicWiz4.btnPreviousClick(Sender: TObject);
begin
  WizMod := Wiz_Prev;
  Close;
end;

procedure TfrmLicWiz4.btnNextClick(Sender: TObject);
Var
  IntVal  : LongInt;
  ErrCode : Integer;
  OK      : Boolean;
begin
  { Do validation }
  OK := True;

  With LicenceInfo Do Begin
    { Trade Counter User Count }
    If (licModules[modTrade] > 0) Then Begin
      { Trade Counter enabled }
      Val (lstTradeUsers.Text, IntVal, ErrCode);
      OK := (ErrCode = 0) And (IntVal >= 1) And (IntVal <= 999);
      If OK Then
        licUserCounts[ucTradeCounter] := IntVal
      Else Begin
        ShowMessage ('The Trade Counter User Count is invalid');
        If lstTradeUsers.CanFocus Then lstTradeUsers.SetFocus;
      End; { Else }
    End { If (licModules[modTrade] > 0) }
    Else
      licUserCounts[ucTradeCounter] := 0;
  End; { With LicenceInfo }

  If OK Then Begin
    WizMod := Wiz_Next;
    Close;
  End; { If OK }
end;

Procedure TfrmLicWiz4.SetFont (FntPan : TPanel; Const Select : Boolean);
Begin { SetFont }
  With FntPan, Font Do Begin
    If Select Then Begin
      { Selected }
      If (Tag <> 0) Then Color := clRed;
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

procedure TfrmLicWiz4.AccStkAnalClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    If lblASAHed.Enabled Then Begin
      SetFont (panAccStkNo, panAccStkNo = Sender);
      SetFont (panAccStk30, panAccStk30 = Sender);
      SetFont (panAccStkFull, panAccStkFull = Sender);

      LicenceInfo.licModules[modAccStk] := ((Sender As TPanel).Tag Mod 10);

      { HM 28/09/99: Added relational link to Telesales }
      With LicenceInfo Do Begin
        If (licModules[modAccStk] < LicenceInfo.licModules[modTeleSale]) Then Begin
          Case licModules[modAccStk] Of
            { No }
            0    : TelesalesClick(panTeleSaleNo);
            { 30-Day }
            1    : TelesalesClick(panTeleSale30);
            { Full }
            2    : TelesalesClick(panTeleSaleFull);
          End; { Case }
        End; { If }
      End; { With LicenceInfo }
    End { If }
    Else
      LicenceInfo.licModules[modAccStk] := 0;
  End; { If }
end;

procedure TfrmLicWiz4.ImpModClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    SetFont (panImpModNo, panImpModNo = Sender);
    SetFont (panImpMod30, panImpMod30 = Sender);
    SetFont (panImpModFull, panImpModFull = Sender);

    LicenceInfo.licModules[modImpMod] := ((Sender As TPanel).Tag Mod 10);
  End; { If }
end;

procedure TfrmLicWiz4.JobCostClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    SetFont (panJobCostNo, panJobCostNo = Sender);
    SetFont (panJobCost30, panJobCost30 = Sender);
    SetFont (panJobCostFull, panJobCostFull = Sender);

    LicenceInfo.licModules[modJobCost] := ((Sender As TPanel).Tag Mod 10);

    // HM 10/01/03: Added links to Applications & Valuations and CIS/RCT Modules
    With LicenceInfo Do Begin
      // Applications & Valuations
      SetAppValState;
      If (licModules[modJobCost] < LicenceInfo.licModules[modAppVal]) Then
        Case licModules[modJobCost] Of
          { No }
          0    : AppValClick(panAppValNo);
          { 30-Day }
          1    : AppValClick(panAppVal30);
          { Full }
          2    : AppValClick(panAppValFull);
        End; { Case }

      // CIS/RCT
      SetCISRCTState;
      If (licModules[modJobCost] < LicenceInfo.licModules[modCISRCT]) Then
        Case licModules[modJobCost] Of
          { No }
          0    : CISRCTClick(panCISRCTNo);
          { 30-Day }
          1    : CISRCTClick(panCISRCT30);
          { Full }
          2    : CISRCTClick(panCISRCTFull);
        End; { Case }
    End; { With LicenceInfo }
  End; { If }
end;

procedure TfrmLicWiz4.ODBCClick(Sender: TObject);
begin
  SelectODBC(Sender, True);
end;


procedure TfrmLicWiz4.SelectODBC(Sender: TObject; RelLinks : Boolean);
begin
  If Sender Is TPanel Then Begin
    SetFont (panODBCNo, panODBCNo = Sender);
    SetFont (panODBCFull, panODBCFull = Sender);

    LicenceInfo.licModules[modODBC] := ((Sender As TPanel).Tag Mod 10);

    If RelLinks Then Begin
      { Do relational links }
      With LicenceInfo Do Begin
        { Auto select at least same level for Full Stock Control }
        Case licModules[modODBC] Of
          { No }
          0, 10   : OLEClick(panOLENo);
          { 30-Day }
          1, 11   : OLEClick(panOLE30);
          { Full }
          2, 12   : OLEClick(panOLEFull);
        End; { Case }
      End; { With LicenceInfo }
    End; { If RelLinks }
  End; { If }
end;

procedure TfrmLicWiz4.RepWrtClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    SetFont (panRepWrtNo, panRepWrtNo = Sender);
    SetFont (panRepWrt30, panRepWrt30 = Sender);
    SetFont (panRepWrtFull, panRepWrtFull = Sender);

    LicenceInfo.licModules[modRepWrt] := ((Sender As TPanel).Tag Mod 10);
  End; { If }
end;

procedure TfrmLicWiz4.TelesalesClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    If lblTeleHed.Enabled Then Begin
      SetFont (panTeleSaleNo, panTeleSaleNo = Sender);
      SetFont (panTeleSale30, panTeleSale30 = Sender);
      SetFont (panTeleSaleFull, panTeleSaleFull = Sender);

      LicenceInfo.licModules[modTeleSale] := ((Sender As TPanel).Tag Mod 10);

      With LicenceInfo Do Begin
        If (licModules[modAccStk] < LicenceInfo.licModules[modTeleSale]) Then Begin
          { Auto select at least same level for Acc Stock Anal }
          Case licModules[modTeleSale] Of
            { No }
            0      : AccStkAnalClick(panAccStkNo);
            { 30-Day }
            1      : AccStkAnalClick(panAccStk30);
            { Full }
            2      : AccStkAnalClick(panAccStkFull);
          End; { Case }
        End; { If }
      End; { With LicenceInfo }
    End { If }
    Else
      LicenceInfo.licModules[modTeleSale] := 0;
  End; { With Sender As TPanel }
end;

procedure TfrmLicWiz4.TooDllClick(Sender: TObject);
begin
  (*
  If Sender Is TPanel Then Begin
    SetFont (panToolDLLNo, panToolDLLNo = Sender);
    SetFont (panToolDLL30, panToolDLL30 = Sender);
    SetFont (panToolDLLFull, panToolDLLFull = Sender);

    LicenceInfo.licModules[modToolDLL] := 0;

    If (LicenceInfo.licModules[modToolDLLR] > 0) Then Begin
      { Reset Run-Time Licence to No }
      ToolDll2Click(panToolDLL2No);
    End; { If }

    LicenceInfo.licModules[modToolDLL] := ((Sender As TPanel).Tag Mod 10);
  End; { If }
  *)
end;

procedure TfrmLicWiz4.ToolDll2Click(Sender: TObject);
begin
  (*
  If Sender Is TPanel Then Begin
    SetFont (panToolDLL2No,   panToolDLL2No = Sender);
    SetFont (panToolDLL230,   panToolDLL230 = Sender);
    SetFont (panToolDLL2Full, panToolDLL2Full = Sender);

    LicenceInfo.licModules[modToolDLLR] := 0;

    If (LicenceInfo.licModules[modToolDLL] > 0) Then Begin
      { Reset Developer Licence to No }
      TooDllClick(panToolDLLNo);
    End; { If }

    LicenceInfo.licModules[modToolDLLR] := ((Sender As TPanel).Tag Mod 10);
  End; { If }
  *)
end;

procedure TfrmLicWiz4.EBusClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    If lblEBus.Enabled Then Begin
      SetFont (panEBusNo, panEBusNo = Sender);
      SetFont (panEBus30, panEBus30 = Sender);
      SetFont (panEBusFull, panEBusFull = Sender);

      LicenceInfo.licModules[modEBus] := ((Sender As TPanel).Tag Mod 10);
    End { If }
    Else
      LicenceInfo.licModules[modEBus] := 0;
  End; { If }
end;

procedure TfrmLicWiz4.Popup_SetAllMods(Sender: TObject);

  Function CalcSenderFromTag(Const Tag : Byte; PanNone, Pan30, PanFull : TPanel) : TPanel;
  Begin { CalcSenderFromTag }
    Case Tag Mod 10 Of
      { None }
      0 : Result := PanNone;

      { 30-Day }
      1 : Begin
            If Assigned(Pan30) Then
              Result := Pan30
            Else
              Result := PanNone;
          End;

      { Full }
      2 : Result := PanFull;
    End; { Case }
  End; { CalcSenderFromTag }

begin
  With Sender As TMenuItem Do Begin
    AccStkAnalClick (CalcSenderFromTag(Tag,   panAccStkNo,       panAccStk30,       panAccStkFull));
    panCommitNoClick(CalcSenderFromTag(Tag,   panCommitNo,       panCommit30,       panCommitFull));
    EBusClick       (CalcSenderFromTag(Tag,   panEBusNo,         panEBus30,         panEBusFull));
    EnhSecClick     (CalcSenderFromTag(Tag,   panEnhSecNo,       panEnhSec30,       panEnhSecFull));
    ImpModClick     (CalcSenderFromTag(Tag,   panImpModNo,       panImpMod30,       panImpModFull));
    JobCostClick    (CalcSenderFromTag(Tag,   panJobCostNo,      panJobCost30,      panJobCostFull));
    OLEClick        (CalcSenderFromTag(Tag,   panOLENo,          panOLE30,          panOLEFull));
    PaperClick      (CalcSenderFromTag(Tag,   panPaperNo,        panPaper30,        panPaperFull));
    SelectODBC      (CalcSenderFromTag(Tag,   panODBCNo,         Nil,               panODBCFull),False);

    If lblReportWriter.Enabled Then
      RepWrtClick   (CalcSenderFromTag(Tag,   panRepWrtNo,       panRepWrt30,       panRepWrtFull));

    TelesalesClick  (CalcSenderFromTag(Tag,   panTeleSaleNo,     panTeleSale30,     panTeleSaleFull));
    TradeClick      (CalcSenderFromTag(Tag,   panTradeNo,        panTrade30,        panTradeFull));

    AppValClick     (CalcSenderFromTag(Tag,   panAppValNo,       panAppVal30,       panAppValFull));
    CISRCTClick     (CalcSenderFromTag(Tag,   panCISRCTNo,       panCISRCT30,       panCISRCTFull));

    FullStkClick    (CalcSenderFromTag(Tag,   panFullStkNo,      panFullStk30,      panFullStkFull));

    VRWClick        (CalcSenderFromTag(Tag,   panVRWNo,          panVRW30,          panVRWFull));

    GoodsReturnsClick(CalcSenderFromTag(Tag,  panGoodsReturnsNo, panGoodsReturns30, panGoodsReturnsFull));

    EBankClick      (CalcSenderFromTag(Tag,  panEBankNo,         panEBank30,        panEBankFull));

    OutlookClick    (CalcSenderFromTag(Tag,  panOutlookNo,       panOutlook30,      panOutlookFull));

    // MH 15/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
    GDPRClick       (CalcSenderFromTag(Tag,  panGDPRNo,          panGDPR30,         panGDPRFull));
    PervEncryptClick(CalcSenderFromTag(Tag,  panPervEncryptNo,   panPervEncrypt30,  panPervEncryptFull));

    LicenceInfo.licModules[modStdWOP] := Tag Mod 10;
    LicenceInfo.licModules[modProWOP] := 0;
    DoWOPSettings(Self, False);

    LicenceInfo.licModules[modToolDLLR] := Tag Mod 10;
    LicenceInfo.licModules[modToolDLL] := 0;
    btnToolkitSettingsClick(Self);

    LicenceInfo.licModules[modElerts] := Tag Mod 10;
    btnElertSettingsClick(Self);
  End; { With Sender }
end;

procedure TfrmLicWiz4.OLEClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    If lblOLEHed.Enabled Then Begin
      SetFont (panOLENo, panOLENo = Sender);
      SetFont (panOLE30, panOLE30 = Sender);
      SetFont (panOLEFull, panOLEFull = Sender);

      LicenceInfo.licModules[modOLESave] := ((Sender As TPanel).Tag Mod 10);
    End { If }
    Else
      LicenceInfo.licModules[modOLESave] := 0;
  End; { If }
end;

procedure TfrmLicWiz4.PaperClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    If lblPaperHed.Enabled Then Begin
      SetFont (panPaperNo, panPaperNo = Sender);
      SetFont (panPaper30, panPaper30 = Sender);
      SetFont (panPaperFull, panPaperFull = Sender);

      LicenceInfo.licModules[modPaperless] := ((Sender As TPanel).Tag Mod 10);
    End { If }
    Else
      LicenceInfo.licModules[modPaperless] := 0;
  End; { If }
end;

procedure TfrmLicWiz4.panCommitNoClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    If lblCommitHed.Enabled Then Begin
      SetFont (panCommitNo,   panCommitNo = Sender);
      SetFont (panCommit30,   panCommit30 = Sender);
      SetFont (panCommitFull, panCommitFull = Sender);

      LicenceInfo.licModules[modCommit] := ((Sender As TPanel).Tag Mod 10);
    End { If }
    Else
      LicenceInfo.licModules[modCommit] := 0;
  End; { If }
end;

procedure TfrmLicWiz4.TradeClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    If lblTradeHed.Enabled Then Begin
      SetFont (panTradeNo,   panTradeNo = Sender);
      SetFont (panTrade30,   panTrade30 = Sender);
      SetFont (panTradeFull, panTradeFull = Sender);

      LicenceInfo.licModules[modTrade] := ((Sender As TPanel).Tag Mod 10);

      lblTradeUsers.Enabled := (LicenceInfo.licModules[modTrade] > 0);
      lstTradeUsers.Enabled := lblTradeUsers.Enabled;
    End { If }
    Else
      LicenceInfo.licModules[modTrade] := 0;
  End; { If }
end;

procedure TfrmLicWiz4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Save positions into ini file }
  licSaveCoords (Self);
end;

procedure TfrmLicWiz4.SetWOPText;
Begin
  If panWOPInfo.Visible Then
    With LicenceInfo Do Begin
      panWOPInfo.Tag := licModules[modStdWOP] + licModules[modProWOP];

      If (panWOPInfo.Tag > 0) Then
        { Some form of WOP is enabled - format display text }
        panWOPInfo.Caption := licWOPDesc(licModules[modStdWOP], licModules[modProWOP])
      Else
        If (licType = 0) Then
          { Install }
          panWOPInfo.Caption := 'NO'
        Else
          { Upgrade / Auto-Upgrade }
          panWOPInfo.Caption := 'AUTO';

      If (panWOPInfo.Tag > 0) Then
        PanWOPInfo.Font.Color := clRed
      Else
        PanWOPInfo.Font.Color := clBlack;
    End; { With LicenceInfo }
End;

procedure TfrmLicWiz4.btnWOPSettingsClick(Sender: TObject);
begin
  DoWOPSettings(Sender, True);
end;

procedure TfrmLicWiz4.DoWOPSettings(Sender: TObject; RelLinks : Boolean);
begin
  // HM 04/09/02: Modified so that the dialog wasn't shown when the module is not available
  //              because of the enterprise version
  If lblWOPHed.Enabled Then Begin
    // Display popup WOP dialog
    If DisplayModDetail (Self, modStdWOP) Then Begin
      { Update display }

    End; { If DisplayModDetail }

    SetWOPText;

    // HM 25/08/04: Added Full Stock Control links
    If RelLinks Then
    Begin
      { Do relational links }
      With LicenceInfo Do Begin
        { Auto select at least same level for Full Stock Control }
        Case panWOPInfo.Tag Of
          { No }
          0, 10   : ;
          { 30-Day }
          1, 11   : If (licModules[modFullStock] < 1) Then FullStkClick(panFullStk30);
          { Full }
          2, 12   : If (licModules[modFullStock] < 2) Then FullStkClick(panFullStkFull);
        End; { Case }
      End; { With LicenceInfo }
    End; // If RelLinks
  End { If lblWOPHed.Enabled }
  Else Begin
    // WOP not available - turn both versions off
    LicenceInfo.licModules[modStdWOP] := 0;
    LicenceInfo.licModules[modProWOP] := 0;
  End; { Else }
end;

procedure TfrmLicWiz4.SetTKDLLText;
Begin
  If panToolDLLInfo.Visible Then
    With LicenceInfo Do Begin
      panToolDLLInfo.Tag := licModules[modToolDLL] + licModules[modToolDLLR];

      If (panToolDLLInfo.Tag > 0) Then
        { Some form of WOP is enabled - format display text }
        panToolDLLInfo.Caption := licToolkitDesc(licModules[modToolDLLR], licModules[modToolDLL], licUserCounts[ucToolkit30], licUserCounts[ucToolkitFull])
      Else
        If (licType = 0) Then
          { Install }
          panToolDLLInfo.Caption := 'NO'
        Else
          { Upgrade / Auto-Upgrade }
          panToolDLLInfo.Caption := 'AUTO';

      If (panToolDLLInfo.Tag > 0) Then
        panToolDLLInfo.Font.Color := clRed
      Else
        panToolDLLInfo.Font.Color := clBlack;
    End; { With LicenceInfo }
End;

procedure TfrmLicWiz4.btnToolkitSettingsClick(Sender: TObject);
begin
  // Display popup WOP dialog
  If DisplayModDetail (Self, modToolDLL) Then Begin
    { Update display }

  End; { If DisplayModDetail }

  SetTKDLLText;
end;

procedure TfrmLicWiz4.SetElertText;
Begin
  If panElertInfo.Visible Then
    With LicenceInfo Do Begin
      panElertInfo.Tag := licModules[modElerts];

      If (panElertInfo.Tag > 0) Then
        { Some form of WOP is enabled - format display text }
        panElertInfo.Caption := licElertsDesc (licModules[modElerts], licUserCounts[ucElerts])
      Else
        If (licType = 0) Then
          { Install }
          panElertInfo.Caption := 'NO'
        Else
          { Upgrade / Auto-Upgrade }
          panElertInfo.Caption := 'AUTO';

      If (panElertInfo.Tag > 0) Then
        panElertInfo.Font.Color := clRed
      Else
        panElertInfo.Font.Color := clBlack;
    End; { With LicenceInfo }
End;

procedure TfrmLicWiz4.btnElertSettingsClick(Sender: TObject);
begin
  // Display popup WOP dialog
  If DisplayModDetail (Self, modElerts) Then Begin
    { Update display }

  End; { If DisplayModDetail }

  SetElertText;
end;

procedure TfrmLicWiz4.EnhSecClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    If lblEnhSec.Enabled Then Begin
      SetFont (panEnhSecNo, panEnhSecNo = Sender);
      SetFont (panEnhSec30, panEnhSec30 = Sender);
      SetFont (panEnhSecFull, panEnhSecFull = Sender);

      LicenceInfo.licModules[modEnhSec] := ((Sender As TPanel).Tag Mod 10);
    End { If }
    Else
      LicenceInfo.licModules[modEnhSec] := 0;
  End; { If }
end;

procedure TfrmLicWiz4.SetAppValState;
Begin { SetAppValState }
  lblAppValHed.Enabled := (LicenceInfo.licModules[modJobCost] > 0);
  panAppValNo.Visible := lblAppValHed.Enabled;
  panAppVal30.Visible := lblAppValHed.Enabled;
  panAppValFull.Visible := lblAppValHed.Enabled;
End; { SetAppValState }

procedure TfrmLicWiz4.AppValClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    If lblAppValHed.Enabled Then Begin
      SetFont (panAppValNo,   panAppValNo = Sender);
      SetFont (panAppVal30,   panAppVal30 = Sender);
      SetFont (panAppValFull, panAppValFull = Sender);

      LicenceInfo.licModules[modAppVal] := ((Sender As TPanel).Tag Mod 10);
    End { If }
    Else
      LicenceInfo.licModules[modAppVal] := 0;
  End; { If }
end;

procedure TfrmLicWiz4.SetCISRCTState;
Begin { SetCISRCTState }
  lblCISRCTHed.Enabled := (LicenceInfo.licModules[modJobCost] > 0);
  panCISRCTNo.Visible := lblCISRCTHed.Enabled;
  panCISRCT30.Visible := lblCISRCTHed.Enabled;
  panCISRCTFull.Visible := lblCISRCTHed.Enabled;
End; { SetCISRCTState }

procedure TfrmLicWiz4.CISRCTClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    If lblCISRCTHed.Enabled Then Begin
      SetFont (panCISRCTNo,   panCISRCTNo = Sender);
      SetFont (panCISRCT30,   panCISRCT30 = Sender);
      SetFont (panCISRCTFull, panCISRCTFull = Sender);

      LicenceInfo.licModules[modCISRCT] := ((Sender As TPanel).Tag Mod 10);
    End { If }
    Else
      LicenceInfo.licModules[modCISRCT] := 0;
  End; { If }
end;

procedure TfrmLicWiz4.FullStkClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    If lblFullStk.Enabled Then Begin
      SetFont (panFullStkNo,   panFullStkNo = Sender);
      SetFont (panFullStk30,   panFullStk30 = Sender);
      SetFont (panFullStkFull, panFullStkFull = Sender);

      LicenceInfo.licModules[modFullStock] := ((Sender As TPanel).Tag Mod 10);
    End { If }
    Else
      LicenceInfo.licModules[modFullStock] := 0;
  End; { If }
end;

procedure TfrmLicWiz4.VRWClick(Sender: TObject);
begin
  If Sender Is TPanel Then
  Begin
    SetFont (panVRWNo,   panVRWNo = Sender);
    SetFont (panVRW30,   panVRW30 = Sender);
    SetFont (panVRWFull, panVRWFull = Sender);

    LicenceInfo.licModules[modVisualRW] := ((Sender As TPanel).Tag Mod 10);
  End; { If }
end;

procedure TfrmLicWiz4.GoodsReturnsClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    If lblFullStk.Enabled Then Begin
      SetFont (panGoodsReturnsNo,   panGoodsReturnsNo = Sender);
      SetFont (panGoodsReturns30,   panGoodsReturns30 = Sender);
      SetFont (panGoodsReturnsFull, panGoodsReturnsFull = Sender);

      LicenceInfo.licModules[modGoodsRet] := ((Sender As TPanel).Tag Mod 10);
    End { If }
    Else
      LicenceInfo.licModules[modGoodsRet] := 0;
  End; { If }
end;

procedure TfrmLicWiz4.EBankClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    If lblEBank.Enabled Then Begin
      SetFont (panEBankNo,   panEBankNo = Sender);
      SetFont (panEBank30,   panEBank30 = Sender);
      SetFont (panEBankFull, panEBankFull = Sender);

      LicenceInfo.licModules[modEBanking] := ((Sender As TPanel).Tag Mod 10);
    End { If }
    Else
      LicenceInfo.licModules[modEBanking] := 0;
  End; { If }
end;

procedure TfrmLicWiz4.OutlookClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    If lblOutlookHed.Enabled Then Begin
      SetFont (panOutlookNo,   panOutlookNo = Sender);
      SetFont (panOutlook30,   panOutlook30 = Sender);
      SetFont (panOutlookFull, panOutlookFull = Sender);

      LicenceInfo.licModules[modOutlookDD] := ((Sender As TPanel).Tag Mod 10);
    End { If }
    Else
      LicenceInfo.licModules[modOutlookDD] := 0;
  End; { If }
end;

procedure TfrmLicWiz4.GDPRClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    If lblGDPRHed.Enabled Then Begin
      SetFont (panGDPRNo,   panGDPRNo = Sender);
      SetFont (panGDPR30,   panGDPR30 = Sender);
      SetFont (panGDPRFull, panGDPRFull = Sender);

      LicenceInfo.licModules[modGDPR] := ((Sender As TPanel).Tag Mod 10);
    End { If }
    Else
      LicenceInfo.licModules[modGDPR] := 0;
  End; { If }
end;


procedure TfrmLicWiz4.PervEncryptClick(Sender: TObject);
begin
  If Sender Is TPanel Then Begin
    If lblPervEncryptionHed.Enabled Then Begin
      SetFont (panPervEncryptNo,   panPervEncryptNo = Sender);
      SetFont (panPervEncrypt30,   panPervEncrypt30 = Sender);
      SetFont (panPervEncryptFull, panPervEncryptFull = Sender);

      LicenceInfo.licModules[modPervEncrypt] := ((Sender As TPanel).Tag Mod 10);
    End { If }
    Else
      LicenceInfo.licModules[modPervEncrypt] := 0;
  End; { If }
end;

end.
