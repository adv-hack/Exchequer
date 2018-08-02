unit ViewLicF;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ComCtrls, ClipBrd;

type
  TfrmViewLicence = class(TForm)
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    Menu_File: TMenuItem;
    Menu_File_Open: TMenuItem;
    Menu_File_SepBar1: TMenuItem;
    Menu_File_Exit: TMenuItem;
    Menu_Help: TMenuItem;
    Menu_Help_About: TMenuItem;
    Bevel1: TBevel;
    lblSno: TLabel;
    lblSerialNo: TLabel;
    Label3: TLabel;
    lblEntVer: TLabel;
    Label9: TLabel;
    lblCompany: TLabel;
    lblType: TLabel;
    Label11: TLabel;
    lblESN: TLabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label12: TLabel;
    lblDealer: TLabel;
    lblLicLicType: TLabel;
    lblEngineType: TLabel;
    lblCSvrVer: TLabel;
    lstEntModules: TListBox;
    lblEntCompanies: TLabel;
    Label2: TLabel;
    lblPSQLLicKey: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure Menu_File_OpenClick(Sender: TObject);
    procedure Menu_File_ExitClick(Sender: TObject);
    procedure Menu_Help_AboutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    OrigClHeight  : SmallInt;
    OrigLstHeight : Smallint;
    DefLoad       : ShortString;
    SpecOpts      : ShortString;

    procedure OpenLicence(Const LicPath : ShortString);
  public
    { Public declarations }
  end;

Var
  frmViewLicence : TfrmViewLicence;

implementation

{$R *.DFM}

Uses oLicence, LicRec, LicVar, LicFuncU, SerialU, StrUtil, StrUtils, ETStrU, ExchequerRelease;

Const
  // HM 05/10/04: Moved VerNo into this module so that EL can't accidentally
  // reset it
  { I x:\entrprse\r&d\vermodu.pas}
  CurrVer_ViewLic  =  '328';   { Enterprise Setup - View Licence Utility }

(****************************************************************************

VERSION HISTORY
===============

Build 328    16/11/2017
--------------------------------------------------------------------------------
  MH    Extendded for new GDPR Module Release Codes

          modGDPR           'GDPR'
          modPervEncrypt    'Pervasive File Encryption'


Build 327    20/02/2017
--------------------------------------------------------------------------------
  PR    Rebuilt to pick up fix in blowfish.pas (ABSEXCH-18207)

Build 326    29/07/2015
--------------------------------------------------------------------------------
  MH    Updated Company Name / Version for Exchequer 2015 R1 


v7.0.5.325 - 08/07/2013
--------------------------------------------------------------------------------
  CS    Removed 'Iris' from application title


v7.0.324 - 19/11/2012
------------------------------------------------------------------------------------------------
  HM    Added Small Business Edition support


v7.0.323 - 11/09/2012
------------------------------------------------------------------------------------------------
  HM    Rebuilt for v7.0


v6.00.322 - 21/09/07
------------------------------------------------------------------------------------------------
  HM    Added support for Auto-Upgrade licences having Pervasive/MS variants


v6.00.321 - 24/04/07
------------------------------------------------------------------------------------------------
  HM    Rebuilt to pick up support for 30-day importer licenses


v6.00.320 - 06/03/07
------------------------------------------------------------------------------------------------
  HM    Rebuilt with support for v6.00 Licence


v5.71.311 - 09/01/07
------------------------------------------------------------------------------------------------
  HM    Added Outlook Dynamic Dashboard support


v5.71.310 - 30/10/06
------------------------------------------------------------------------------------------------
  HM    Corrected spelling of eBanking and eBusiness


v5.71.309 - 26/10/06
------------------------------------------------------------------------------------------------
  HM    Added eBanking module release code


v5.70.308 - 21/07/05
------------------------------------------------------------------------------------------------
  HM    Added Goods Returns module release code


v5.61.307 - 28/02/05
------------------------------------------------------------------------------------------------
  HM    Added Visual RW module release code


v5.61.306 - 03/02/05
--------------------------------------------
  HM    Released for v5.61


b561.306 - 05/10/04
--------------------------------------------
  HM    Changed the licence description to use the short country name as the
        'United Kingdom Auto-Upgrade for v5.0x/v5.5x/v5.6x' description is
        wider than the window!

  HM    Localised the versioning into the module so EL can't accidentally
        reset it by copying an older VerModU.Pas from his notebook.

****************************************************************************)


procedure TfrmViewLicence.OpenLicence(Const LicPath : ShortString);
Var
  EntLic : TEntLicence;

  Function ModToStr (lstMods : TListBox; Const ModIdx, ModRel : Byte) : ShortString;
  Begin { ModToStr }
    { Only show enabled modules }
    If (ModRel > 0) Or (EntLic.InstType = 1) Then
      lstMods.Items.Add (licModuleDesc (ModIdx) + #9 + licEntModRelToStr (EntLic.InstType, ModRel, ModIdx));
  End; { ModToStr }

Begin { OpenLicence }
  EntLic := TEntLicence.Create;
  Try
    With EntLic Do Begin
      FileName := LicPath;

      lblType.Caption := '';
      lblSerialNo.Caption := '';
      lblLicLicType.Caption := '';
      lblESN.Caption := '';

      lblCompany.Caption := '';
      lblDealer.Caption := '';

      lblCSvrVer.Caption := '';
      lblEntVer.Caption := '';

      SpecOpts := '';

      lstEntModules.Clear;

      If Valid Then Begin
        { CD Country + Type + Licence Version }
        // HM 05/10/04: Modified to use Short country desc as was overflowing width of form
        lblType.Caption := licCountryStr (Country, True) + ' ' + licTypeToStr (InstType) + ' for Exchequer ' + licEntVer(Version);

        { CD Serial No - Display Issue Number for auto-Upgrades }
        If (InstType <> 2) Then Begin
          { Install / Upgrade }
          lblSno.Caption := 'CD Serial Number:';
          lblSerialNo.Caption := CDSerial
        End { If (InstType <> 2) }
        Else Begin
          { Auto-Upgrade - Display Issue Number }
          lblSno.Caption := 'Issue Number:';
          lblSerialNo.Caption := Format('%3.3d', [IssueNo]);
        End; { Else }

        { Licence Type }
        lblLicLicType.Caption := 'Type:  ' + licLicTypeToStr (LicType, False);

        { ESN - may be set for Auto-Upgrades }
        lblESN.Caption := ISNByteToStrB (EncLic.licESN, EncLic.licSerialNo);
        If (ESN2ByteToStr (EncLic.licESN2) <> '') Then
          lblESN.Caption := lblESN.Caption + ',  ' + ESN2ByteToStr (EncLic.licESN2);
        If (Trim(lblESN.Caption) = '') Then
          lblESN.Caption := 'Any';

        { Dealer and Company }
        lblCompany.Caption := Company;
        lblDealer.Caption := Dealer;
        If (InstType = 2) And ((Trim(Company) + Trim(Dealer)) = '') Then Begin
          lblCompany.Caption := 'Any';
          lblDealer.Caption := 'Any';
        End; { If }

        If (InstType <> 2) Then Begin
          (***
          { Client-Server Engine }
          If (ClSvrEng > 0) Then
          Begin
            lblEngineType.Caption := 'Client-Server Engine';
            lblCSvrVer.Caption := 'Pervasive.SQL for ' + licCSEngStr (ClSvrEng, True) +
                                 '-' + IntToStr(ClSvrUser) + ' User';
            lblPSQLLicKey.Caption := PSQLKey;
          End // If (ClSvrEng > 0)
          Else
            If (ClSvr = 0) And (PSQLWGE > 0) Then
            Begin
              // Non Client-Server + Workgroup Engine Licenced
              lblEngineType.Caption := 'Workgroup Engine';
              lblCSvrVer.Caption := licPSQLWGEVerToStr (PSQLWGE, False);
              lblPSQLLicKey.Caption := PSQLKey;
            End // If (ClSvr = 0) And (PSQLWGE > 0)
            Else Begin
              lblCSvrVer.Caption := 'No';
              lblPSQLLicKey.Caption := 'N/A';
            End; // Else
          ***)

          // MH 06/03/07: Modified for MS SQL Support
          If (EntDBType = DBBtrieve) Then
          Begin
            Case ClSvr Of
              // Non-Client-Server
              0 : Begin
                    If (PSQLWGE > 0) Then
                    Begin
                      lblCSvrVer.Caption := 'Pervasive.SQL ' + licPSQLWGEVerToStr (PSQLWGE) + ' Workgroup Engine';
                      lblPSQLLicKey.Caption := PSQLKey;
                    End // If (PSQLWGE > 0)
                    Else
                    Begin
                      lblCSvrVer.Caption := 'N/A';
                      lblPSQLLicKey.Caption := 'N/A';
                    End; // Else
                  End; // Non-Client-Server
              // Client-Server
              1 : Begin
                    If (ClSvrEng > 0) Then
                    Begin
                      lblCSvrVer.Caption := 'Pervasive.SQL for ' + licCSEngStr (ClSvrEng, True) + ' - ' + IntToStr(ClSvrUser) + ' User';
                      lblPSQLLicKey.Caption := PSQLKey;
                    End // If (ClSvrEng > 0)
                    Else
                    Begin
                      lblCSvrVer.Caption := 'N/A';
                    End; // Else
                  End; // Client-Server
            End; // Case ClSvr
          End // If (EntDBType = DBBtrieve)
          Else
          Begin
            lblCSvrVer.Caption := 'MS SQL Server';
            lblPSQLLicKey.Caption := 'N/A';
          End; // Else

          { Currency version + Core Modules }
          lblEntVer.Caption := licCurrVerToStr (CurrVer) + '/' +
                               licEntModsToStr (BaseModules);

          { Add Client Server flag }
          If (lblEntVer.Caption[Length(lblEntVer.Caption)] <> '/') Then
            lblEntVer.Caption := lblEntVer.Caption + '/';
          If (ClSvr = 1) Then
            lblEntVer.Caption := lblEntVer.Caption + 'CS';

          { Add User Count }
          If (lblEntVer.Caption[Length(lblEntVer.Caption)] <> '/') Then
            lblEntVer.Caption := lblEntVer.Caption + '/';
          lblEntVer.Caption := lblEntVer.Caption + IntToStr(Users);

          // HM 19/11/12: Added SBE Support
          If (ExchequerEdition <> eeStandard) Then
          Begin
            lblEntVer.Caption := lblEntVer.Caption + '  [' + licExchequerEditionToStr (ExchequerEdition, True) + ']';
          End; // If (ExchequerEdition <> eeStandard) Then

          { Enterprise Company Count }
          lblEntCompanies.Caption := 'Companies  ' + IntToStr(UserCounts[ucCompanies]);

          { Optional Enterprise Modules }
          ModToStr (lstEntModules, modAccStk, Modules[modAccStk]);
          ModToStr (lstEntModules, modCommit, Modules[modCommit]);
          ModToStr (lstEntModules, modEBanking, Modules[modEBanking]);
          ModToStr (lstEntModules, modEBus, Modules[modEBus]);
          ModToStr (lstEntModules, modEnhSec, Modules[modEnhSec]);
          ModToStr (lstEntModules, modFullStock, Modules[modFullStock]);
          // MH 16/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
          ModToStr (lstEntModules, modGDPR, Modules[modGDPR]);
          ModToStr (lstEntModules, modGoodsRet, Modules[modGoodsRet]);
          ModToStr (lstEntModules, modImpMod, Modules[modImpMod]);
          ModToStr (lstEntModules, modJobCost, Modules[modJobCost]);
          ModToStr (lstEntModules, modAppVal, Modules[modAppVal]);
          ModToStr (lstEntModules, modCISRCT, Modules[modCISRCT]);
          ModToStr (lstEntModules, modODBC, Modules[modODBC]);
          ModToStr (lstEntModules, modOLESave, Modules[modOLESave]);
          ModToStr (lstEntModules, modOutlookDD, Modules[modOutlookDD]);
          ModToStr (lstEntModules, modPaperless, Modules[modPaperless]);
          // MH 16/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
          ModToStr (lstEntModules, modPervEncrypt, Modules[modPervEncrypt]);
          ModToStr (lstEntModules, modRepWrt, Modules[modRepWrt]);
          If (Modules[modElerts] > 0)  Then  { Sentimail }
            lstEntModules.Items.Add (licModuleDesc (modElerts) + #9 +
                                     licElertsDesc (Modules[modElerts], UserCounts[ucElerts]))
          Else
            If (EntLic.InstType = 1) Then
              ModToStr (lstEntModules, modElerts, Modules[modElerts]);
          ModToStr (lstEntModules, modTeleSale, Modules[modTeleSale]);

          { Toolkit DLL + COM Toolkit }
          If (Modules[modToolDLL] > 0) Or (Modules[modToolDLLR] > 0) Or (EntLic.InstType = 1) Then
            If (Modules[modToolDLL] + Modules[modToolDLLR] > 0) Then
              lstEntModules.Items.Add ('Toolkits' + #9 + licToolkitDesc(Modules[modToolDLLR], Modules[modToolDLL], UserCounts[ucToolkit30], UserCounts[ucToolkitFull]))
            Else
              { Upgrade with no details specified }
              lstEntModules.Items.Add ('Toolkits' + #9 + 'Auto');

          { Trade Counter}
          If (Modules[modTrade] > 0) Then
            lstEntModules.Items.Add (licModuleDesc (modTrade) + #9 +
                                     licEntModRelToStr (InstType, Modules[modTrade], modTrade) + ' - ' +
                                     IntToStr(UserCounts[ucTradeCounter]) + ' User')
          Else
            If (EntLic.InstType = 1) Then
              ModToStr (lstEntModules, modTrade, Modules[modTrade]);

          ModToStr (lstEntModules, modVisualRW, Modules[modVisualRW]);

          { Works Order Processing }
          If (Modules[modStdWOP] > 0) Or (Modules[modProWOP] > 0)  Then
            lstEntModules.Items.Add ('Works Order Processing' + #9 + licWOPDesc(Modules[modStdWOP], Modules[modProWOP]))
          Else
            If (EntLic.InstType = 1) Then
              lstEntModules.Items.Add ('Works Order Processing' + #9 + 'Auto');

          { Special Options string for Help-About }
          If EncLic.licResetModRels Then SpecOpts := SpecOpts + '1';
          If EncLic.licResetCountry Then SpecOpts := SpecOpts + '2';

          { Set height depending on number of entries }
          lstEntModules.Height := lstEntModules.ItemHeight * lstEntModules.Items.Count;
          ClientHeight := (OrigClHeight - OrigLstHeight) + lstEntModules.Height;

          { Check still on screen! }
          If ((Top + Height) > Screen.Height) Then
            Top := Round((Screen.Height - Height) * 0.2);
        End { If (InstType <> 2)  }
        Else
          { Auto Upgrade - hide irrelevent fields }
          // MH 21/09/07: Modified to show the DB Engine field
          //ClientHeight := Bevel3.Top;
          ClientHeight := lblPSQLLicKey{Bevel3}.Top;
          lblCSvrVer.Caption := IfThen (EntDBType = DBBtrieve, 'Pervasive.SQL', 'Microsoft SQL Server');
      End { If }
      Else Begin
        { Invalid Licence }
        MessageDlg (ValidErrStr, mtError, [mbOk], 0);
      End; { Else }
    End; { With }
  Finally
    EntLic.Destroy;
  End;
End; { OpenLicence }

procedure TfrmViewLicence.FormActivate(Sender: TObject);
begin
  If FileExists (DefLoad) Then Begin
    { Load licence }
    OpenLicence(DefLoad);
  End { If }
  Else Begin
    { Display open dialog }
    Menu_File_OpenClick(Sender);
  End; { If }
end;

procedure TfrmViewLicence.Menu_File_OpenClick(Sender: TObject);
begin
  OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName);

  If OpenDialog1.Execute Then Begin
    OpenLicence(OpenDialog1.FileName);
  End; { If }
end;

procedure TfrmViewLicence.Menu_File_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmViewLicence.Menu_Help_AboutClick(Sender: TObject);
begin
  If (Trim (SpecOpts) <> '') Then
    MessageDlg (Application.Title + #13 +
                'Version ' + ExchequerModuleVersion (emCDLicenceViewer, CurrVer_ViewLic) + #13#13 +
                'Options ' + SpecOpts + #13#13 +
                // HM 02/01/03: Changed to use standard function
                //'Copyright 1986, 2002 Exchequer Software Ltd', mtInformation, [mbOk], 0)
                DoubleAmpers (GetCopyrightMessage), mtInformation, [mbOk], 0)
  Else
    MessageDlg (Application.Title + #13 +
                'Version ' + ExchequerModuleVersion (emCDLicenceViewer, CurrVer_ViewLic) + #13#13 +
                // HM 02/01/03: Changed to use standard function
                //'Copyright 1986, 2002 Exchequer Software Ltd', mtInformation, [mbOk], 0);
                DoubleAmpers (GetCopyrightMessage), mtInformation, [mbOk], 0);
end;

procedure TfrmViewLicence.FormCreate(Sender: TObject);
Var
  Str : ShortString;
  I   : Byte;
begin
  Caption := Application.Title;

  { position centrally in window }
  Left := (Screen.Width - Width) Div 2;
  Top := Round((Screen.Height - Height) * 0.2);

  { Save original height - used when changing height for auto-upgrade and normal licences }
  OrigClHeight := ClientHeight;
  OrigLstHeight := lstEntModules.Height;

  DefLoad := ExtractFilePath(Application.ExeName) + LicFile;
  SpecOpts := '';

  // HM 17/07/02: Modified handling of parameters at it no longer appears to work
  //              with long filename directories - not sure if this is a new problem
  //              or just wasn't tested with them.
  If (ParamCount > 0) Then Begin
    // Get full command line including .EXE & all parameters
    Str := UpperCase(Trim(CmdLine));

    // Trim off application name
    I := Pos('.EXE', Str);
    If (I > 0) Then Delete (Str, 1, I + 4);

    // trim off anything after filename
    Str := Trim (Str);
    I := Pos('.LIC', Str);
    If (I > 0) Then Delete (Str, I + 4, Length(Str));

    If FileExists(Str) Then
      DefLoad := Str;
  End; { If (ParamCount > 0) }

  (***
  { Check for .LIC file in command-line params }
  If (ParamCount > 0) Then Begin
    For I := 1 To ParamCount Do Begin
      Str := ParamStr (I);

      If FileExists (Str) Then Begin
        DefLoad := Str;
      End; { If }
    End; { For }
  End; { If }
  ***)
end;

end.
