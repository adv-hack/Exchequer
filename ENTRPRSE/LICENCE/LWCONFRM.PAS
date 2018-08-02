unit lwConfrm;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, TEditVal, Menus, ClipBrd, BorBtns;

type
  TfrmLicWiz5 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Bevel2: TBevel;
    btnNext: TButton;
    btnPrevious: TButton;
    btnOptions: TButton;
    ScrollBox1: TScrollBox;
    lblLicenceDescr: TLabel;
    lblSno: TLabel;
    Label6: TLabel;
    lblCDSno: TLabel;
    lblESN: TLabel;
    Label11: TLabel;
    lblCompanyName: TLabel;
    Label13: TLabel;
    lblDlrName: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Label7: TLabel;
    lblEngineType: TLabel;
    lblCSVer: TLabel;
    lblEntVer: TLabel;
    Label17: TLabel;
    Shape3: TShape;
    lstOptMods: TListBox;
    Panel1: TPanel;
    Label1: TLabel;
    chkResetModRels: TCheckBox;
    chkResetCountryCode: TCheckBox;
    Label4: TLabel;
    lblCompanyCount: TLabel;
    chkSuppressLog: TCheckBox;
    chkWebRel: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    WizMod : SmallInt;
    procedure ReInit;
  end;

Procedure LicWiz_Confirm (Var   WizForm           : TfrmLicWiz5;
                          Var   WizNo, LastWiz    : Byte;
                          Const WizPrev, WizNext  : Byte;
                          Var   Done, Aborted     : Boolean);

implementation

{$R *.DFM}

Uses LicRec, LicVar, LicFuncU, SerialU, lwOption, lwEntVer, StrUtils, ECBUtil;


Procedure LicWiz_Confirm (Var   WizForm           : TfrmLicWiz5;
                          Var   WizNo, LastWiz    : Byte;
                          Const WizPrev, WizNext  : Byte;
                          Var   Done, Aborted     : Boolean);
Begin { LicWiz_EntMods }
  { Create Form as and when necessary }
  If Not Assigned(WizForm) Then Begin
    WizForm := TfrmLicWiz5.Create(Application.MainForm);
  End; { If Not Assigned(WizForm)  }

  { Re-Initialise forms return value }
  WizForm.ReInit;

  { Display Form }
  WizForm.ShowModal;

  { Process return value }
  Case WizForm.WizMod Of
    Wiz_Abort  : Aborted := True;

    Wiz_Prev   : WizNo := WizPrev;

    Wiz_Next   : Done := True;
  End; { Case }

  LastWiz := Wiz_Confirm;
End; { LicWiz_ClServer }


{----------------------------------------------------------------------------}


procedure TfrmLicWiz5.FormCreate(Sender: TObject);
begin
  licInitWin (Self, Wiz_Confirm);

  { Init local variables }
  ReInit;
End;

procedure TfrmLicWiz5.ReInit;
Var
  TmpStr  : ShortString;
  I       : SmallInt;

  Function ModToStr (lstMods : TListBox; Const ModIdx : SmallInt) : ShortString;
  Var
    TmpS : ShortString;
  Begin { ModToStr }
    With LicenceInfo Do Begin
      { (DL) Only show if being issued to customer }
      If (licModules[ModIdx] > 0) Or (LicType = 1) Then
        lstMods.Items.Add (licModuleDesc (ModIdx) + ':' + #9 +
                           licEntModRelToStr (licType, licModules[ModIdx], ModIdx));
    End; { With LicenceInfo }
  End; { ModToStr }

Begin { ReInit }
  WizMod := Wiz_Abort;

  { Write Licence details to Screen }
  With LicenceInfo Do Begin
    { Install Country + Type }
    lblLicenceDescr.Caption := licCountryStr (licCountry, False) + ' ' + licTypeToStr (licType) + ' (' + licLicTypeToStr(licLicType, False) + ')';

    { CD Serial No }
    If (licType <> 2) Then Begin
      { Install / Upgrade }
      lblSno.Caption := 'CD Serial Number:';
      lblCDSno.Caption := licSerialNo;
    End { If (licType <> 2) }
    Else Begin
      { Auto-Upgrade - Display Issue Number }
      lblSno.Caption := 'Issue Number:';
      lblCDSno.Caption := Format('%3.3d', [licAutoUpgIssue]);
    End; { Else }

    { ESN }
    lblESN.Caption := ISNByteToStr (licESN, licSerialNo) + ' / ' + ESN2ByteToStr (licESN2);

    { Company / Dealer Name }
    lblCompanyName.Caption := Format ('%s  (%s)', [licCompany, CDGenInfo.AccountCode]);
    lblDlrName.Caption := Format ('%s  (%s)', [licDealer, CDGenInfo.DealerCode]);

    { Clear list of optional Modules }
    lstOptMods.Clear;

    { Hide some labels for Auto-Upgrade to unclutter the screen }
    Label17.Visible := (licType <> 2);
             
    { Only display rest of detail if NOT Auto-Upgrade }
    If (licType <> 2) Then Begin
      { Enterprise Version }
      lblEntVer.Caption := licCDEntVersion (LicenceInfo);

      // MH 19/11/2012 v7.0: Added support for Small Business Edition
      lblEntVer.Caption := lblEntVer.Caption + '   [' + licExchequerEditionToStr (licExchequerEdition) + ']';

      If (licUserCounts[ucCompanies] > 0) Then
        lblCompanyCount.Caption := IntToStr (licUserCounts[ucCompanies])
      Else
        lblCompanyCount.Caption := 'Auto';

      // MH 06/03/07: Modified for MS SQL Support
      If (licEntDB = DBBtrieve) Then
      Begin
        Case licEntClSvr Of
          // Non-Client-Server
          0 : Begin
                If (licPSQLWGEVer > 0) Then
                  lblCSVer.Caption := 'P.SQL ' + licPSQLWGEVerToStr (licPSQLWGEVer) + ' Workgroup Engine,  Licence Key: ' + licPSQLLicKey
                Else
                  lblCSVer.Caption := 'No Licence Specified';
              End; // Non-Client-Server
          // Client-Server
          1 : Begin
                If (licClServer > 0) Then
                  lblCSVer.Caption := 'P.SQL for ' + licCSEngStr (licClServer, True) + ' - ' + IntToStr(licCSUserCnt) + ' User,  Licence Key: ' + licPSQLLicKey
                Else
                  lblCSVer.Caption := 'No Licence Specified';
              End; // Client-Server
        Else
          lblCSVer.Caption := '???';
        End; // Case licEntClSvr
      End // If (licEntDB = DBBtrieve)
      Else
      Begin
        lblCSVer.Caption := 'MS SQL Server';
      End; // Else

      { Optional Modules }
      ModToStr (lstOptMods, modAccStk);      { Account Stock Analysis }
      ModToStr (lstOptMods, modCommit);      { Commitment Accounting }
      ModToStr (lstOptMods, modEBanking);    { v5.71 - E-Banking }
      ModToStr (lstOptMods, modEBus);        { eBusiness }
      ModToStr (lstOptMods, modFullStock);   { Full Stock Control }
      // MH 15/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
      ModToStr (lstOptMods, modGDPR);        { 2018-R1 - Full Stock Control }
      ModToStr (lstOptMods, modGoodsRet);    { v5.70 - Goods Returns }
      ModToStr (lstOptMods, modEnhSec);      { Enhanced Security }
      ModToStr (lstOptMods, modImpMod);      { Import Module }
      ModToStr (lstOptMods, modJobCost);     { Job Costing }
      ModToStr (lstOptMods, modAppVal);      { Job Costing Applications & Valuations }
      ModToStr (lstOptMods, modCISRCT);      { Job Costing CIS/RCT }
      ModToStr (lstOptMods, modODBC);        { ODBC }
      ModToStr (lstOptMods, modOLESave);     { OLE Save }
      ModToStr (lstOptMods, modOutlookDD);   { v5.71 - Outlook Dynamic Dashboard }
      ModToStr (lstOptMods, modPaperless);   { Paperless }
      // MH 15/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
      ModToStr (lstOptMods, modPervEncrypt); { 2018-R1 - Pervasive Encryption }
      ModToStr (lstOptMods, modRepWrt);      { Report Writer }

      { Sentimail }
      If (licModules[modElerts] > 0) Then
        lstOptMods.Items.Add (licModuleDesc (modElerts) + ':' + #9 + licElertsDesc (licModules[modElerts], licUserCounts[ucElerts]))
      Else
        If (LicType = 1) Then
          ModToStr (lstOptMods, modElerts);

      ModToStr (lstOptMods, modTeleSale);  { Telesales }

      { Toolkit / SDK }
      If (licModules[modToolDLL] > 0) Or (licModules[modToolDLLR] > 0) Then  { Toolkit }
        lstOptMods.Items.Add ('Toolkits:' + #9 + licToolkitDesc(licModules[modToolDLLR], licModules[modToolDLL], licUserCounts[ucToolkit30], licUserCounts[ucToolkitFull]))
      Else
        If (LicType = 1) Then
          lstOptMods.Items.Add ('Toolkits' + #9 + 'Auto');

      { Trade Counter}
      If (licModules[modTrade] > 0) Then
        lstOptMods.Items.Add (licModuleDesc (modTrade) + ':' + #9 +
                              licEntModRelToStr (licType, licModules[modTrade], ModTrade) + ' - ' +
                              IntToStr(licUserCounts[ucTradeCounter]) + ' User')
      Else
        If (LicType = 1) Then
          ModToStr (lstOptMods, modTrade);

      ModToStr (lstOptMods, modVisualRW);    { v5.61 Visual Report Writer }

      If (licModules[modStdWOP] > 0) Or (licModules[modProWOP] > 0) Then  { Works Order Processing }
        lstOptMods.Items.Add ('WOP:' + #9 + licWOPDesc(licModules[modStdWOP], licModules[modProWOP]))
      Else
        If (LicType = 1) Then
          lstOptMods.Items.Add ('Works Order Processing' + #9 + 'Auto');

      { Special licence Options }
      chkResetModRels.Checked := licResetModRels;
      chkResetCountryCode.Checked := licResetCountry;

      chkWebRel.Checked := (Pos('*', CDGenInfo.AccountCode) = 0) And (Pos('*', CDGenInfo.DealerCode) = 0) And ConfigInfo.AddMode;
    End { If (licType <> 2) }
    Else Begin
      { Auto-Upgrade }
      lblEntVer.Caption := 'Auto';
      lblCompanyCount.Caption := 'Auto';

      lblCSVer.Caption := IfThen(licEntDB = DBBtrieve, 'Pervasive.SQL', 'MS SQL Server');
    End; { Else }
  End; { With }
End; { ReInit }

procedure TfrmLicWiz5.btnPreviousClick(Sender: TObject);
begin
  WizMod := Wiz_Prev;
  Close;
end;

procedure TfrmLicWiz5.btnNextClick(Sender: TObject);
begin
  WizMod := Wiz_Next;
  Close;
end;

procedure TfrmLicWiz5.btnOptionsClick(Sender: TObject);
begin
  LicWiz_SecurityOptions;

  ReInit;
end;

procedure TfrmLicWiz5.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  { Save positions into ini file }
  licSaveCoords (Self);
end;

end.
