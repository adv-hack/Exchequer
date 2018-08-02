unit VwDatF;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, LicRec, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Open1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    OpenDialog1: TOpenDialog;
    RichEdit1: TRichEdit;
    mnuProductType: TMenuItem;
    N2: TMenuItem;
    mnuSaveAsExchequer: TMenuItem;
    mnuSaveAsIAOCustomer: TMenuItem;
    mnuSaveAsIAOAccountant: TMenuItem;
    mnuChange: TMenuItem;
    DatabaseType1: TMenuItem;
    BtrievePervasiveSQL1: TMenuItem;
    MSSQLServer1: TMenuItem;
    Modules1: TMenuItem;
    Core1: TMenuItem;
    Stock1: TMenuItem;
    SPOP1: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuSaveAsIAOAccountantClick(Sender: TObject);
    procedure mnuSaveAsIAOCustomerClick(Sender: TObject);
    procedure mnuSaveAsExchequerClick(Sender: TObject);
    procedure BtrievePervasiveSQL1Click(Sender: TObject);
    procedure MSSQLServer1Click(Sender: TObject);
    procedure Core1Click(Sender: TObject);
    procedure Stock1Click(Sender: TObject);
    procedure SPOP1Click(Sender: TObject);
  private
    { Private declarations }
    LicR : EntLicenceRecType;
    procedure OpenLicence(Const LicPath : ShortString);
    procedure UpdateLicence (Const ProductType : Byte);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

Uses EntLic, SerialU, Registry, DiskUtil, LicFuncU, LicVar;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;

  mnuChange.Visible := FileExists('c:\{1DE6857D-FA42-48F5-B3E9-96EDF132378A}');
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  Application.MessageBox ('ENTRPRSE.DAT Viewer'#13'Version 2.08 for Exchequer v5.xx-6.xx/IAO v1.x ', 'About VwDat.Exe', MB_OK Or MB_ICONINFORMATION);
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  { Display open dialog }
  Open1Click(Sender);
end;

procedure TForm1.Open1Click(Sender: TObject);
Begin
  OpenDialog1.InitialDir := 'c:\exch\';

  If OpenDialog1.Execute Then Begin
    OpenLicence(OpenDialog1.FileName);
  End; { If }
end;

procedure TForm1.OpenLicence(Const LicPath : ShortString);
Begin { OpenLicence }
  If ReadEntLic (LicPath, LicR) Then Begin
    With RichEdit1.Lines, LicR Do Begin
      Clear;

      Add ('licCDKey:'#9#9#9 + FormatCDKey (licCDKey));
      Add ('licProductType:'#9#9 + IntToStr(licProductType) + ' - ' + licProductTypeToStr (licProductType, False));
      Add ('licLicType:' +  #9#9 + IntToStr(licLicType) + ' - ' + licLicTypeToStr (licLicType, False));
      Add ('licType:' +     #9#9#9 + IntToStr(licType) + ' - ' + licTypeToStr (licType));
      Add ('licCountry:' +  #9#9 + IntToStr(licCountry) + ' - ' + licCountryStr (licCountry, False));
      Add ('licSerialNo:' + #9#9 + licSerialNo);
      Add ('');
      Add ('licCompany:' +  #9#9 + licCompany);
      Add ('');
      Add ('ESN:' +         #9#9#9 + ISNByteToStr (LicISN, LicSerialNo));
      Add ('');
      {$IFDEF LIC600}
      Add ('licEntDB:' +  #9#9#9 + IntToStr(licEntDB) + ' - ' + licDBToStr (licEntDB));
      {$ENDIF}
      // MH 16/11/2012 v7.0: Added support for Small Business Edition
      Add ('licExchequerEdition: ' + #9 + IntToStr(Ord(licExchequerEdition)) + ' - ' + licExchequerEditionToStr (licExchequerEdition));
      Add ('licEntCVer:' +  #9#9 + IntToStr(licEntCVer) + ' - ' + licCurrVerToStr (licEntCVer));
      Add ('licEntModVer:' +#9#9 + IntToStr(licEntModVer) + ' - ' + licEntModsToStr (licEntModVer));
      Add ('licEntClSvr:' + #9#9 + IntToStr(licEntClSvr) + ' (' + licEntClSvrToStr (licEntClSvr, False) + ')');
      Add ('licUserCnt:' +  #9#9 + IntToStr(licUserCnt));
      Add ('Companies:' +  #9#9 + IntToStr(licUserCounts[ucCompanies]));
      Add ('');
      Add ('licClServer:' + #9#9 + IntToStr(licClServer) + ' - ' + licCSEngStr (licClServer, False));
      Add ('licCSUserCnt:' +#9#9 + IntToStr(licCSUserCnt));
      Add ('licPSQLWGEVer:' +#9#9 + IntToStr(licPSQLWGEVer) + ' - ' + licPSQLWGEVerToStr (licPSQLWGEVer, False));
      Add ('');
      Add ('Account Stock Analysis:' +   #9 + IntToStr(licModules[modAccStk]) + ' - ' + licEntModRelToStr (1, licModules[modAccStk], modAccStk));
      Add ('Commitment:' +  #9#9 + IntToStr(licModules[modCommit]) + ' - ' + licEntModRelToStr (1, licModules[modCommit], modCommit));
      Add ('E-Banking:' +     #9#9 + IntToStr(licModules[modEBanking]) + ' - ' + licEntModRelToStr (1, licModules[modEBanking], modEBanking));
      Add ('E-Business:' +     #9#9 + IntToStr(licModules[modEBus]) + ' - ' + licEntModRelToStr (1, licModules[modEBus], modEBus));
      Add ('Enh Security:' +     #9#9 + IntToStr(licModules[modEnhSec]) + ' - ' + licEntModRelToStr (1, licModules[modEnhSec], modEnhSec));
      Add ('Full Stock:' +     #9#9 + IntToStr(licModules[modFullStock]) + ' - ' + licEntModRelToStr (1, licModules[modFullStock], modFullStock));
      // MH 16/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
      Add ('GDPR:' +     #9#9#9 + IntToStr(licModules[modGDPR]) + ' - ' + licEntModRelToStr (1, licModules[modGDPR], modGDPR));
      Add ('Goods Returns:' +     #9#9 + IntToStr(licModules[modGoodsRet]) + ' - ' + licEntModRelToStr (1, licModules[modGoodsRet], modGoodsRet));
      Add ('Importer:' +   #9#9#9 + IntToStr(licModules[modImpMod]) + ' - ' + licEntModRelToStr (1, licModules[modImpMod], modImpMod));
      Add ('Job Costing:' +  #9#9 + IntToStr(licModules[modJobCost]) + ' - ' + licEntModRelToStr (1, licModules[modJobCost], modJobCost));
      Add ('ODBC:' +     #9#9#9 + IntToStr(licModules[modODBC]) + ' - ' + licEntModRelToStr (1, licModules[modODBC], modODBC));
      Add ('OLE Save:' +    #9#9 + IntToStr(licModules[modOLESave]) + ' - ' + licEntModRelToStr (1, licModules[modOLESave], modOLESave));
      Add ('Outlook Dynamic Dashboard:' +    #9 + IntToStr(licModules[modOutlookDD]) + ' - ' + licEntModRelToStr (1, licModules[modOutlookDD], modOutlookDD));
      Add ('Paperless:' +   #9#9 + IntToStr(licModules[modPaperless]) + ' - ' + licEntModRelToStr (1, licModules[modPaperless], modPaperless));
      // MH 16/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
      Add ('Pervasive File Encryption:' + #9 + IntToStr(licModules[modPervEncrypt]) + ' - ' + licEntModRelToStr (1, licModules[modPervEncrypt], modPervEncrypt));
      Add ('Report Writer:' +   #9#9 + IntToStr(licModules[modRepWrt]) + ' - ' + licEntModRelToStr (1, licModules[modRepWrt], modRepWrt));

      Add ('Sentimail:' +  #9#9 + licElertsDesc (licModules[modElerts], licUserCounts[ucElerts]));
      //Add ('Elerts:' +  #9#9#9 + IntToStr(licModules[modElerts]) + ' - ' + licEntModRelToStr (1, licModules[modElerts], modElerts));

      Add ('TeleSales:' + #9#9 + IntToStr(licModules[modTeleSale]) + ' - ' + licEntModRelToStr (1, licModules[modTeleSale], modTeleSale));
      Add ('Toolkit (DLL/COM):' +  #9#9 + licToolkitDesc (licModules[modToolDLLR], licModules[modToolDLL], licUserCounts[ucToolkit30], licUserCounts[ucToolkitFull]));
      //Add ('Toolkit Dev:' +  #9#9 + IntToStr(licModules[modToolDLL]) + ' - ' + licEntModRelToStr (1, licModules[modToolDLL], modToolDLL));
      //Add ('Toolkit Run:' + #9#9 + IntToStr(licModules[modToolDLLR]) + ' - ' + licEntModRelToStr (1, licModules[modToolDLLR], modToolDLLR));
      Add ('Trade Counter:' +  #9#9 + IntToStr(licModules[modTrade]) + ' - ' + licEntModRelToStr (1, licModules[modTrade], modTrade) + ' - ' + IntToStR(licUserCounts[ucTradeCounter]) + ' User');
      Add ('Works Order Processing:' +  #9 + licWOPDesc (licModules[modStdWOP], licModules[modProWOP]));
      //Add ('Standard WOP:' +  #9 + IntToStr(licModules[modStdWOP]) + ' - ' + licEntModRelToStr (1, licModules[modStdWOP], modStdWOP));
      //Add ('Professional WOP:' +  #9 + IntToStr(licModules[modProWOP]) + ' - ' + licEntModRelToStr (1, licModules[modProWOP], modProWOP));
      Add ('JC CIS/RCT:' +   #9#9 + IntToStr(licModules[modCISRCT]) + ' - ' + licEntModRelToStr (1, licModules[modCISRCT], modCISRCT));
      Add ('JC App & Val:' +   #9#9 + IntToStr(licModules[modAppVal]) + ' - ' + licEntModRelToStr (1, licModules[modAppVal], modAppVal));
      Add ('Visual Report Writer:' +   #9 + IntToStr(licModules[modVisualRW]) + ' - ' + licEntModRelToStr (1, licModules[modVisualRW], modVisualRW));
    End; { With }
  End; { If ReadEntLic }
End; { OpenLicence }

Procedure ChkOK;
Var
  DriveInfo    : DriveInfoType;
  UName, CName : String;
  OK, DebugOn  : Boolean;
  pSysInfo     : PChar;
  StrLength    : DWord;
  ErrCode      : String[2];
Begin { ChkOK }
  ErrCode := '99';

  DebugOn := FindCmdLineSwitch('DogsB', ['-', '/'], True);

  { Check running from correct directory }
  OK := //(UpperCase(ExtractFilePath(Application.ExeName)) = 'S:\TEMP\MARK\UTILS\') Or
        //(UpperCase(ExtractFilePath(Application.ExeName)) = 'T:\TEMP\MARK\UTILS\') Or
        (UpperCase(ExtractFilePath(Application.ExeName)) = 'H:\ADMIN\LIC2018R1\');

  If OK Then Begin
    // Check for Computer Name and Logged In User

    { Windows Computer Name }
    StrLength := 100;
    pSysInfo := StrAlloc (StrLength);
    GetComputerName (pSysInfo, StrLength);
    CName := UpperCase(pSysInfo);
    StrDispose (pSysInfo);

    { Windows User ID }
    StrLength := 100;
    pSysInfo := StrAlloc (StrLength);
    GetUserName (pSysInfo, StrLength);
    UName := UpperCase(pSysInfo);
    StrDispose (pSysInfo);

    OK := ((UName = 'MARKD6') And (CName = 'L17190')) Or
          ((UName = 'JWAYGOOD') And (CName = 'P007612'));

    If OK Then Begin
      // Check it is a Netware volume
      DriveInfo.drDrive := Application.ExeName[1];
      OK := GetDriveInfo(DriveInfo);
      If OK Then Begin
        // Check its a network drive
        OK := (Uppercase(DriveTypeStr(DriveInfo.drDriveType)) = 'NETWORK');
        If OK Then Begin
          // HM 23/02/09: Modified to allow use of app on the NT network which reports NTFS
          // HM 15/07/02: Modified to allow use of app under the Netware Client which reports
          //   (v2.01)    the file system as NWFS instead of NWCOMPA.
          OK := (Pos ('NTFS', Uppercase(DriveInfo.drFileSystem)) > 0);
          If (Not OK) Then Begin
            ErrCode := '96';
            If DebugOn Then ShowMessage ('FS = ' + DriveInfo.drFileSystem);
          End; { If (Not OK) }
        End { If OK }
        Else Begin
          ErrCode := '95';
          If DebugOn Then ShowMessage ('DT = ' + DriveTypeStr(DriveInfo.drDriveType));
        End; { Else }
      End { If OK }
      Else Begin
        ErrCode := '94';
        If DebugOn Then ShowMessage ('DriveInfo Failed');
      End; { Else }
    End { If OK }
    Else Begin
      // Computer Name & User Name
      ErrCode := '02';

      If DebugOn Then
        ShowMessage ('UName >' + UName + '<' + #13 + 'CName >' + CName + '<');
    End; { Else }

    If OK Then Begin
      // Check for registry setting
      With TRegistry.Create Do
        Try
          Access := KEY_ALL_ACCESS;
          RootKey := HKEY_CURRENT_USER;

          OK := KeyExists('Software\Exchequer\Security');
          If OK Then Begin
            { Key exists - get CLSID }
            OK := OpenKey('Software\Exchequer\Security', False);
            If OK Then Begin
              OK := KeyExists('');
              If OK Then Begin
                If (GetDataType ('') = rdString) Then
                  OK := (ReadString ('') = '8246')
                Else
                  OK := (ReadInteger ('') = 8246);

                If (Not OK) Then ErrCode := '06';
              End { If OK }
              Else
                ErrCode := '05';
            End { If OK }
            Else
              ErrCode := '04';
          End { If OK }
          Else
            ErrCode := '03';
        Finally
          Free;
        End;
    End; { If OK }
  End { If OK }
  Else
    // Directory Check
    ErrCode := '01';

  If (Not OK) Then Begin
    // Not allowed to run it
    If DebugOn Then
      MessageDlg ('Invalid Operation - Opcode ' + ErrCode + 'h', mtError, [mbOk], 0);
    Raise Exception.Create('');
  End; { If (Not OK) }
End; { ChkOK }

//-------------------------------------------------------------------------

procedure TForm1.UpdateLicence (Const ProductType : Byte);
Begin // UpdateLicence
  If (ProductType In [0..2]) Then
    LicR.licProductType := ProductType
  Else If (ProductType In [3..4]) Then
    LicR.licEntDB := ProductType - 3
  Else If (ProductType In [5..7]) Then
    LicR.licEntModVer := ProductType - 5;  // 0-Basic, 1-Stock, 2-SPOP

  WriteEntLic (OpenDialog1.Filename, LicR);
  OpenLicence(OpenDialog1.Filename);
End; // UpdateLicence

//------------------------------

procedure TForm1.mnuSaveAsIAOAccountantClick(Sender: TObject);
begin
  UpdateLicence (2);
end;

//------------------------------

procedure TForm1.mnuSaveAsIAOCustomerClick(Sender: TObject);
begin
  UpdateLicence (1);
end;

//------------------------------

procedure TForm1.mnuSaveAsExchequerClick(Sender: TObject);
begin
  UpdateLicence (0);
end;

//------------------------------

procedure TForm1.BtrievePervasiveSQL1Click(Sender: TObject);
begin
  UpdateLicence (3);
end;

//------------------------------

procedure TForm1.MSSQLServer1Click(Sender: TObject);
begin
  UpdateLicence (4);
end;

//-------------------------------------------------------------------------

procedure TForm1.Core1Click(Sender: TObject);
begin
  UpdateLicence (5);
end;

procedure TForm1.Stock1Click(Sender: TObject);
begin
  UpdateLicence (6);
end;

procedure TForm1.SPOP1Click(Sender: TObject);
begin
  UpdateLicence (7);
end;

//-------------------------------------------------------------------------

Initialization
  ChkOK;

  //ShowMessage ('EntLicRecType: ' + IntToStr(SizeOf(EntLicRecType)));
end.
