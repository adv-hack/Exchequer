unit VwErcF;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, StdCtrls, Mask, TEditVal, ComCtrls, ClipBrd;

{$H-}

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Menu_File: TMenuItem;
    Menu_File_Exit: TMenuItem;
    Menu_Help: TMenuItem;
    Menu_Help_About: TMenuItem;
    OpenDialog1: TOpenDialog;
    Bevel2: TBevel;
    PageControl1: TPageControl;
    tabshCustDetails: TTabSheet;
    tabshModules: TTabSheet;
    tabshReleaseCodes: TTabSheet;
    StatusBar1: TStatusBar;
    GroupBox1: TGroupBox;
    Label24: TLabel;
    lblDealer: TLabel;
    Label4: TLabel;
    lblDealerTown: TLabel;
    GroupBox2: TGroupBox;
    Label25: TLabel;
    lblContact: TLabel;
    Label27: TLabel;
    lblCompany: TLabel;
    Label26: TLabel;
    lblAddress1: TLabel;
    lblAddress2: TLabel;
    lblAddress3: TLabel;
    lblAddress4: TLabel;
    lblAddress5: TLabel;
    Label1: TLabel;
    lblPhone: TLabel;
    Label3: TLabel;
    lblFax: TLabel;
    Label9: TLabel;
    lblEmail: TLabel;
    GroupBox3: TGroupBox;
    Label12: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    edtRelCode: Text8Pt;
    edtESN: Text8Pt;
    edtSecCode: Text8Pt;
    tabshFaxVer: TTabSheet;
    GroupBox5: TGroupBox;
    Label18: TLabel;
    edtFaxVerCode: Text8Pt;
    Bevel1: TBevel;
    Label10: TLabel;
    Label11: TLabel;
    Bevel3: TBevel;
    lblLicVer: TLabel;
    lblEntVer: TLabel;
    Label2545: TLabel;
    Label19: TLabel;
    Label121: TLabel;
    Label29: TLabel;
    lblModMC: TLabel;
    lblModRepWrt: TLabel;
    lblModToolkit: TLabel;
    lblModASA: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    lblModPaper: TLabel;
    lblModOLESave: TLabel;
    lblMod10: TLabel;
    Label40: TLabel;
    lblModJC: TLabel;
    Label88: TLabel;
    lblModTele: TLabel;
    lblModEBus: TLabel;
    Label45: TLabel;
    Label17: TLabel;
    Label20: TLabel;
    lblMod11: TLabel;
    lblMod12: TLabel;
    btnClip: TButton;
    lblSecExpiry: Label8;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label28: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label6: TLabel;
    lblModSec1: TLabel;
    lblModSec3: TLabel;
    lblModSec4: TLabel;
    lblModSec6: TLabel;
    lblModSec2: TLabel;
    lblModSec5: TLabel;
    lblModRel1: TLabel;
    lblModRel2: TLabel;
    lblModRel3: TLabel;
    lblModRel4: TLabel;
    lblModRel5: TLabel;
    lblModRel6: TLabel;
    lblModStatus1: TLabel;
    lblModStatus2: TLabel;
    lblModStatus3: TLabel;
    lblModStatus4: TLabel;
    lblModStatus5: TLabel;
    lblModStatus6: TLabel;
    Label8: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    lblModSec7: TLabel;
    lblModSec9: TLabel;
    lblModSec8: TLabel;
    lblModRel7: TLabel;
    lblModRel8: TLabel;
    lblModRel9: TLabel;
    lblModStatus7: TLabel;
    lblModStatus8: TLabel;
    lblModStatus9: TLabel;
    Menu_File_Open: TMenuItem;
    procedure FormActivate(Sender: TObject);
    procedure Menu_Help_AboutClick(Sender: TObject);
    procedure Menu_File_ExitClick(Sender: TObject);
    procedure Menu_File_OpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtFaxVerCodeKeyPress(Sender: TObject; var Key: Char);
    procedure edtFaxVerCodeChange(Sender: TObject);
    procedure btnClipClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    AppMode   : Byte;
    DefLoad   : ShortString;
    {NoDelFile : Boolean;}

    procedure ClearScr;
    Procedure ClearFaxScr;
    procedure OpenErc(Const ErcPath : ShortString);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses Base34, Erc, SerialU, ETDateU, LicRec, LicFuncU;

Const
  {$I x:\entrprse\r&d\vermodu.pas}

{--------------------------------------------------------------------------}

{ Check for command-line param giving name of .ERC file }
procedure TForm1.FormCreate(Sender: TObject);
Var
  Str   : ShortString;
  I, J  : Byte;
begin
  AppMode := 0;
  DefLoad := '';
  {NoDelFile := False;}

  { Check for .LIC file in command-line params }
  If (ParamCount > 0) Then Begin
    For I := 1 To ParamCount Do Begin
      Str := UpperCase(ParamStr (I));

      {If (Copy (Str, 1, 7) = '/NODEL:') Then
        NoDelFile := True;}

      If (Copy (Str, 1, 7) = '/EMAIL:') Then Begin
        { Email }
        AppMode := 0;

        {Delete (Str, 1, 7);
        If FileExists (Str) Then
          DefLoad := Str;}

        { HM 24/07/00: Extract file path from command line }
        Str := CmdLine;
        J := Pos('/EMAIL:', UpperCase(Str));
        Delete (Str, 1, J + 6);

        J := Pos('.ERC', UpperCase(Str));
        If ((J + 3) < Length(Str)) Then
          Delete (Str, J + 4, Length(Str));
        DefLoad := Str;
      End; { If }

      If (Copy (UpperCase(Str), 1, 5) = '/FAX:') Then Begin
        { Fax }
        AppMode := 1;
      End; { If }
    End; { For }
  End; { If }

  If (AppMode = 0) Then Begin
    { Emails }
    tabshFaxVer.TabVisible := False;
    PageControl1.ActivePage := tabshCustDetails;
  End { If }
  Else Begin
    { Faxes }
    Application.Title := 'Exchequer Enterprise Fax Info Viewer';

    tabshCustDetails.TabVisible := False;
    tabshModules.TabVisible := False;
    PageControl1.Height := 248;
    PageControl1.ActivePage := tabshFaxVer;
    ActiveControl := edtFaxVerCode;

    StatusBar1.Visible := False;

    ClientHeight := 259;
    ClientWidth := 520;
  End; { Else }

  Caption := Application.Title;

  ClearScr;
end;

{--------------------------------------------------------------------------}

{ Open specified file or display open dlg }
procedure TForm1.FormActivate(Sender: TObject);
begin
  If (AppMode = 0) Then Begin
    { Emails }
    If FileExists (DefLoad) Then Begin
      { Load licence }
      OpenErc(DefLoad);
    End { If }
    Else Begin
      { Display open dialog }
      //PostMessage(Self.Handle, WM_Close, 0, 0);
    End; { If }
  End; { If }
end;

{--------------------------------------------------------------------------}

{ File|Open - display File-Open dialog to open existing .ERC file }
procedure TForm1.Menu_File_OpenClick(Sender: TObject);
begin
  OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName);

  If OpenDialog1.Execute Then Begin
    ClearScr;
    OpenErc(OpenDialog1.FileName);
  End; { If }
end;

{--------------------------------------------------------------------------}

{ File|Exit - close }
procedure TForm1.Menu_File_ExitClick(Sender: TObject);
begin
  Close;
end;

{--------------------------------------------------------------------------}

{ Help|About - display version + copyright info dialog }
procedure TForm1.Menu_Help_AboutClick(Sender: TObject);
begin
  MessageDlg (Application.Title + #13 +
              'Version ' + CurrVer_ViewERC + #13#13 +
              'Copyright Exchequer Software Ltd 1986-2003', mtInformation, [mbOk], 0);
end;

{--------------------------------------------------------------------------}

{ Open the specified .ERC file and display the info }
procedure TForm1.OpenErc(Const ErcPath : ShortString);
Var
  ErcFile          : TErcFileO;
  Day, Month, Year : Word;
Begin { OpenErc }
  Try
    If FileExists(ErcPath) Then Begin
      StatusBar1.Panels[0].Text := ErcPath;

      ErcFile := TErcFileO.Create;
      Try
        With ErcFile, ErcRec Do Begin
          If LoadErcFile (ErcPath) Then Begin
            { Customer Tab - Dealer Details }
            lblDealer.Caption := ercDealer;
            lblDealerTown.Caption := ercDealerTown;

            { Customer Tab - Customer Details }
            lblContact.Caption := ercContact;
            lblCompany.Caption := ercCompany;

            lblAddress1.Caption := ercAddr[1];
            lblAddress2.Caption := ercAddr[2];
            lblAddress3.Caption := ercAddr[3];
            lblAddress4.Caption := ercAddr[4];
            lblAddress5.Caption := ercAddr[5];

            lblPhone.Caption := ercPhone;
            lblFax.Caption := ercFax;
            lblEmail.Caption := ercEmail;

            { Modules Tab }
            lblModSec1.Caption := ercModuleSec[1,False];
            lblModSec2.Caption := ercModuleSec[2,False];
            lblModSec3.Caption := ercModuleSec[3,False];
            lblModSec4.Caption := ercModuleSec[4,False];
            lblModSec5.Caption := ercModuleSec[5,False];
            lblModSec6.Caption := ercModuleSec[6,False];
            lblModSec7.Caption := ercModuleSec[7,False];
            lblModSec8.Caption := ercModuleSec[8,False];
            lblModSec9.Caption := ercModuleSec[9,False];

            lblModRel1.Caption := ercModuleSec[1,True];
            lblModRel2.Caption := ercModuleSec[2,True];
            lblModRel3.Caption := ercModuleSec[3,True];
            lblModRel4.Caption := ercModuleSec[4,True];
            lblModRel5.Caption := ercModuleSec[5,True];
            lblModRel6.Caption := ercModuleSec[6,True];
            lblModRel7.Caption := ercModuleSec[7,True];
            lblModRel8.Caption := ercModuleSec[8,True];
            lblModRel9.Caption := ercModuleSec[9,True];

            {lblModStatus1: TLabel;
            lblModStatus2: TLabel;
            lblModStatus3: TLabel;
            lblModStatus4: TLabel;
            lblModStatus5: TLabel;
            lblModStatus6: TLabel;}

    { From ModR }
    //ercModuleSec : Array[1..25,False..True] of String[10];
    //ercRelDates  : Array[1..25] of Real;

            { Release Code Tab }
            edtESN.Text := licESNStr (ESNByteArrayType(ercISN)) + Format('-%3.3d', [ercISN[7]]);
            edtSecCode.Text := ercSecCode;

            julcal(ercRelDate, Day, Month, Year);
            lblSecExpiry.Caption := '(Expires ' + POutDate(StrDate(Year, Month, Day)) + ')';;
          End; { If LoadErcFile... }
        End; { With ErcFile }
      Finally
        ErcFile.Free;
      End;
    End; { If }
  Except
    On Ex:Exception Do
      ShowMessage (Ex.Message);
  End;
End; { OpenErc }

{--------------------------------------------------------------------------}

procedure TForm1.ClearScr;
Begin { ClearScr }
  StatusBar1.Panels[0].Text := '';

  lblDealer.Caption := '';
  lblContact.Caption := '';
  lblCompany.Caption := '';

  lblAddress1.Caption := '';
  lblAddress2.Caption := '';
  lblAddress3.Caption := '';
  lblAddress4.Caption := '';
  lblAddress5.Caption := '';

  lblPhone.Caption := '';
  lblFax.Caption := '';
  lblEmail.Caption := '';

  edtFaxVerCode.Text := '';

  ClearFaxScr;
End; { ClearScr }

Procedure TForm1.ClearFaxScr;
Begin { ClearFaxScr }
  lblLicVer.Caption := '';
  lblEntVer.Caption := '';

  lblModMC.Caption := '';
  lblModJC.Caption := '';
  lblModRepWrt.Caption := '';
  lblModToolkit.Caption := '';
  lblModTele.Caption := '';
  lblModASA.Caption := '';
  lblModEBus.Caption := '';
  lblModPaper.Caption := '';
  lblModOLESave.Caption := '';
  lblMod10.Caption := '';
  lblMod11.Caption := '';
  lblMod12.Caption := '';
End; { ClearFaxScr }


procedure TForm1.edtFaxVerCodeKeyPress(Sender: TObject; var Key: Char);
begin
  Key := UpperCase(Key)[1];

  If Not (Key In ['0'..'9', 'A'..'H', 'J'..'N', 'P'..'Z']) Then
    Key := #0;
end;

procedure TForm1.edtFaxVerCodeChange(Sender: TObject);
Var
  CodeStr, B34Str   : ShortString;
  DecNo             : SmallInt;
  N1, N2, N3        : Byte;

  Procedure GetNums;
  Var
    TmpNo : Smallint;
  Begin { GetNums }
    N1 := 0;
    N2 := 0;
    N3 := 0;

    TmpNo := DecNo;

    N3 := TmpNo Div 100;
    TmpNo := TmpNo Mod 100;

    N2 := TmpNo Div 10;

    N1 := TmpNo Mod 10;
  End; { GetNums }

begin
  ClearFaxScr;

  { Decode information: AA-BB-CC-DDEEFFGG }
  CodeStr := edtFaxVerCode.Text;

  If (Length(CodeStr) >= 2) Then Begin
    //  AA - licLicType + licType + licCountry
    B34Str := Copy (CodeStr, 1, 2);
    If Decode34I (B34Str, DecNo) Then Begin
      GetNums;
      lblLicVer.Caption := licCountryStr (N3, False) + ' ' +
                           licTypeToStr (N2) +
                           '   (' + licLicTypeToStr (N1, False) + ')';
    End; { If Decode34I }
  End; { If (Length(CodeStr) >= 2)  }
  If (Length(CodeStr) >= 5) Then Begin
    //  BB - licentCVer + licEntModVer + licEntClSvr
    B34Str := Copy (CodeStr, 4, 2);
    If Decode34I (B34Str, DecNo) Then Begin
      GetNums;
      lblEntVer.Caption := licCurrVerToStr (N1) + '/' +
                           licEntModsToStr (N2);

      If (N3 = 1) Then
        lblEntVer.Caption := lblEntVer.Caption + '/CS';
    End; { If Decode34I }
  End; { If (Length(CodeStr) >= 4)  }
  If (Length(CodeStr) >= 8) Then Begin
    //  CC - User Count
    B34Str := Copy (CodeStr, 7, 2);
    If Decode34I (B34Str, DecNo) Then Begin
      lblEntVer.Caption := lblEntVer.Caption + '/' + IntToStr(DecNo);
    End; { If Decode34I }
  End; { If (Length(CodeStr) >= 8)  }
  If (Length(CodeStr) >= 11) Then Begin
    //  DD - Module Status - MC + JC + RepWrt
    B34Str := Copy (CodeStr, 10, 2);
    If Decode34I (B34Str, DecNo) Then Begin
      GetNums;

      lblModMC.Caption := licEntModRelToStr (0, N1, 255);
      lblModJC.Caption := licEntModRelToStr (0, N2, 255);
      lblModRepWrt.Caption := licEntModRelToStr (0, N3, 255);
    End; { If Decode34I }
  End; { If (Length(CodeStr) >= 11)  }
  If (Length(CodeStr) >= 13) Then Begin
    //  EE - Module Status - DLL + TeleS + AccStkAnal
    B34Str := Copy (CodeStr, 12, 2);
    If Decode34I (B34Str, DecNo) Then Begin
      GetNums;

      lblModToolkit.Caption := licEntModRelToStr (0, N1, 255);
      lblModTele.Caption := licEntModRelToStr (0, N2, 255);
      lblModASA.Caption := licEntModRelToStr (0, N3, 255);
    End; { If Decode34I }
  End; { If (Length(CodeStr) >= 13)  }
  If (Length(CodeStr) >= 15) Then Begin
    //  FF - Module Status - 7 + 8 + 9
    B34Str := Copy (CodeStr, 14, 2);
    If Decode34I (B34Str, DecNo) Then Begin
      GetNums;

      lblModEBus.Caption := licEntModRelToStr (0, N1, 255);
      lblModPaper.Caption := licEntModRelToStr (0, N2, 255);
      lblModOLESave.Caption := licEntModRelToStr (0, N3, 255);
    End; { If Decode34I }
  End; { If (Length(CodeStr) >= 15)  }
  If (Length(CodeStr) >= 17) Then Begin
    //  GG - Module Status - 10 + 11 + 12
    B34Str := Copy (CodeStr, 16, 2);
    If Decode34I (B34Str, DecNo) Then Begin
      GetNums;

      lblMod10.Caption := licEntModRelToStr (0, N1, 255);
      lblMod11.Caption := licEntModRelToStr (0, N2, 255);
      lblMod12.Caption := licEntModRelToStr (0, N3, 255);
    End; { If Decode34I }
  End; { If (Length(CodeStr) >= 17)  }
end;

procedure TForm1.btnClipClick(Sender: TObject);
begin
  Clipboard.AsText := Copy (edtESN.Text, 1, 23) + #13 + edtSecCode.Text + #13;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  (*
  If (AppMode = 0) And (Not NoDelFile) Then Begin
    { Delete Email File }
    If FileExists (DefLoad) Then
      DeleteFile (DefLoad);
  End; { If (AppMode = 0) }
  *)
end;

end.

