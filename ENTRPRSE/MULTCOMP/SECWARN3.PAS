unit SecWarn3;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, ExtCtrls, StdCtrls, Mask, TEditVal, ComCtrls, Inifiles, Buttons,
  CustDets, LicRec, TCustom, RpDevice, RPDefine, RPBase, RPCanvas,
  RPrinter, RPFiler;

type
  TfrmSecWarn2 = class(TSetupTemplate)
    PageControl1: TPageControl;
    tabshPhone: TTabSheet;
    tabshFax: TTabSheet;
    tabshEmail: TTabSheet;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblPhoneContact: TLabel;
    lblPhoneNo: TLabel;
    Label9: TLabel;
    edtRelCode: Text8Pt;
    edtESN: Text8Pt;
    edtSecCode: Text8Pt;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    lstEmailMthd: TComboBox;
    Label12: TLabel;
    Label15: TLabel;
    edtSMTP: Text8Pt;
    Label16: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    lblFaxCompany: TLabel;
    lblFaxNo: TLabel;
    Label17: TLabel;
    btnEmlSend: TSBSButton;
    btnFaxPrint: TSBSButton;
    ReportPrinter1: TReportPrinter;
    ReportFiler1: TReportFiler;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    btnTelAccept: TSBSButton;
    btnEmlClose: TSBSButton;
    btnFaxClose: TSBSButton;
    btnTelClose: TSBSButton;
    Label18: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lstEmailMthdChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnFaxPrintClick(Sender: TObject);
    procedure ReportPrinter1BeforePrint(Sender: TObject);
    procedure ReportPrinter1Print(Sender: TObject);
    procedure btnTelAcceptClick(Sender: TObject);
    procedure btnEmlCloseClick(Sender: TObject);
    procedure btnFaxCloseClick(Sender: TObject);
    procedure edtESNDblClick(Sender: TObject);
    procedure edtSecCodeDblClick(Sender: TObject);
    procedure Label4DblClick(Sender: TObject);
  private
    { Private declarations }
    lBinIniF, lUsrIniF : TIniFile;
    lEntDir            : String;
    lGotMapi           : Boolean;
    lCustDetsO         : TCustDetsDlg;
    lTempLicR          : EntLicenceRecType;
    RepBase            : TBaseReport;
    FailCount          : SmallInt;

    FVDEmailAddr       : ShortString;
  public
    { Public declarations }
    DoneRelCode        : Boolean;

    procedure SaveDefaults(Var UsrIniF : TIniFile);

    Procedure SetupDlg(Const CustDetsO        : TCustDetsDlg;
                       Const EntDir           : String;
                       Const GotMAPI          : Boolean;
                       Const TempLicR         : EntLicenceRecType;
                       Var   BinIniF, UsrIniF : TIniFile);
  end;


implementation

{$R *.DFM}

Uses GlobVar, VarConst, EtDateU, EtStrU, EtMiscU, SerialU, CommsInt, Erc,
     GlobExcH, SysCode, HelpSupU, SecureU, ClipBrd, Phonetic, SecSup2U,
     LicFuncU;



Procedure TfrmSecWarn2.SetupDlg(Const CustDetsO        : TCustDetsDlg;
                                Const EntDir           : String;
                                Const GotMAPI          : Boolean;
                                Const TempLicR         : EntLicenceRecType;
                                Var   BinIniF, UsrIniF : TIniFile);
Var
  IniStr, TmpDir : String;
  I              : LongInt;
Begin { SetupDlg }
  lEntDir  := EntDir;
  lGotMAPI := GotMAPI;
  lBinIniF := BinIniF;
  lUsrIniF := UsrIniF;
  lCustDetsO := CustDetsO;
  lTempLicR := TempLicR;

  { General Settings -------------------------------------------------------- }
  Case UsrIniF.ReadInteger ('SecCodeWizard', 'SecCodeWizard', 1) Of
    1 : PageControl1.ActivePage := tabshEmail;
    2 : PageControl1.ActivePage := tabshFax;
    3 : PageControl1.ActivePage := tabshPhone;
  End; { Case }

  { Email Settings ---------------------------------------------------------- }
  If lGotMapi Then Begin
    { Default To MAPI }
    lstEmailMthd.ItemIndex := 0;

    IniStr := UsrIniF.ReadString ('Entrprse', 'PEmail', 'A');
    If (IniStr = 'B') Then
      lstEmailMthd.ItemIndex := 1
    Else
      lstEmailMthd.ItemIndex := 0;
  End { If GotMapi }
  Else Begin
    lstEmailMthd.ItemIndex := 1;
    lstEmailMthd.Enabled := False;
  End; { Else }
  lstEmailMthdChange(Application);

  { SMTP Server }
  TmpDir := UsrIniF.ReadString ('Entrprse', 'PEmailSMTP', '');
  If (Trim(TmpDir) <> '') Then
    edtSMTP.Text := Trim(TmpDir);

  FVDEmailAddr := BinIniF.ReadString ('VendorDetails', 'vdEmail', 'Support@Exchequer.Com');
  Label11.Caption := Label11.Caption + FVDEmailAddr;

  { Fax Settings ------------------------------------------------------------ }
  lblFaxCompany.Caption := BinIniF.ReadString('VendorDetails', 'vdName', '?');
  lblFaxNo.Caption := BinIniF.ReadString('VendorDetails', 'vdFax', '?');

  { Telephone Settings ------------------------------------------------------ }
  lblPhoneContact.Caption := BinIniF.ReadString('VendorDetails', 'vdContact', '?');
  lblPhoneNo.Caption := BinIniF.ReadString('VendorDetails', 'vdPhone', '?');

  (* HM 21/01/02: Changed to display v5.00 7 segment ESN's
  edtESN.Text := '';
  For I := 1 To 6 Do Begin
    edtESN.Text := edtESN.Text + IntToStr3 (Syss.ExISN[I]);

    If (I < 6) Then
      edtESN.Text := edtESN.Text + '-';
  End; { For I }
  *)
  With TempLicR Do
    edtESN.Text := licESN7Str (licISN, licLicType);

  edtSecCode.Text := Syss.ExSecurity;
  edtSecCode.Hint := StringToPhonetic (edtSecCode.Text);
  edtRelCode.Text := Syss.ExRelease;
End; { SetupDlg }

procedure TfrmSecWarn2.FormCreate(Sender: TObject);
begin
  inherited;

  FailCount := 0;
  ExitMsg := 2;  { Security Code wizard }
  DoneRelCode := False;
end;

procedure TfrmSecWarn2.lstEmailMthdChange(Sender: TObject);
begin
  inherited;

  edtSMTP.Enabled := (lstEmailMthd.ItemIndex = 1);
  Label15.Enabled := edtSMTP.Enabled;
  Label16.Enabled := edtSMTP.Enabled;
end;

procedure TfrmSecWarn2.BitBtn1Click(Sender: TObject);
Var
  EntEmail   : TEntEmail;
  ErcFile    : TErcFileO;
  TmpDir     : String;
  Res        : Smallint;
  RelDateStr : ShortString;
  Rd,Rm,Ry   : Word;
  OK         : Boolean;
begin
  inherited;

  Try
    OK := True;
    If (lstEmailMthd.ItemIndex = 1) Then Begin
      { Validate SMTP Server }
      OK := (Trim(edtSMTP.Text) <> '');

      If (Not OK) Then Begin
        MessageDlg ('The SMTP Server Address must be set correctly when using SMTP Emailing', mtWarning, [mbOk], 0);
        If edtSMTP.CanFocus Then edtSMTP.SetFocus;
      End; { If }
    End; { If }

    If OK Then Begin
      { Read customer details }
      If lCustDetsO.Execute (1) Then Begin
        Try
          Screen.Cursor := crHourglass;

          { Build email file }
          ErcFile := TErcFileO.Create;
          Try
            If ErcFile.BuildErcFile (lEntDir, lTempLicR, lCustDetsO) Then Begin
              { Change to Ent directory so DLL will load under Wise! }
              TmpDir := GetCurrentDir;
              If SetCurrentDir (lEntDir) Then Begin
                { Send email }
                EntEmail := TEntEmail.Create;
                Try
                  { Calculate Expiry Date }
                  JulCal (Syss.RelDate, Rd, Rm, Ry);
                  // HM 26/02/01: Added check for already expired dates
                  If (Syss.RelDate > 0.0) Then
                    RelDateStr := POutDateB (StrDate (Ry, Rm, Rd))
                  Else
                    RelDateStr := 'EXPIRED';

                  With EntEmail Do Begin
                    Attachments.Add (ErcFile.FileName);
                    Message := '';
                    Priority := 2;
                    Recipients.Add (FVDEmailAddr);
                    Sender := lCustDetsO.EmailAddr;
                    SenderName := lCustDetsO.Contact;
                    SMTPServer := Trim(edtSMTP.Text);
                    Subject := '*** Release Code Request - ' + RelDateStr + ' ***';
                    UseMAPI := (lstEmailMthd.ItemIndex = 0);
                  End; { With EntEmail }

                  Res := EntEmail.Send;

                  If (Res = 0) Then
                    MessageDlg ('The email has been sent', mtInformation, [mbOk], 0)
                  Else
                    MessageDlg (EmailErr(Res), mtInformation, [mbOk], 0)
                Finally
                  EntEmail.Free;
                End;

                (*
                If (Res = 0) Then Begin
                  { Close Dialog }
                  ExitCode := 'N';
                  Close;
                End; { If }
                *)
              End; { If }
            End; { If }
          Finally
            ErcFile.Delete;
            ErcFile.Free;
          End;

          { Restore original directory }
          SetCurrentDir (TmpDir);
        Finally
          Screen.Cursor := crDefault;
        End;
      End; { If }
    End; { If }
  Except
    On Ex:Exception Do
      GlobExceptHandler(Ex);
  End;
end;

{ Print page for faxing }
procedure TfrmSecWarn2.btnFaxPrintClick(Sender: TObject);
begin
  Try
    { Read customer details }
    If lCustDetsO.Execute (2) Then Begin
      Try
        Screen.Cursor := crHourglass;

        {$OPTIMIZATION OFF}
        { Bug Fix - sometime get Access Violation - this fixes it! }
        RPDev.DeviceIndex := RPDev.DeviceIndex;
        {$OPTIMIZATION ON}

        { Select Printer }
        If RpDev.PrinterSetupDialog Then Begin
          { Print it }
          //RepBase := ReportFiler1;   { For debugging/development }
          RepBase := ReportPrinter1;   { For runtime }

          RepBase.Execute;
        End; { If }
      Finally
        Screen.Cursor := crDefault;
      End;
    End; { If }
  Except
    On Ex:Exception Do
      GlobExceptHandler(Ex);
  End;
end;

procedure TfrmSecWarn2.ReportPrinter1BeforePrint(Sender: TObject);
begin
  inherited;

  With RepBase Do Begin
    MarginTop := LeftWaste * 2;
    MarginLeft := LeftWaste * 2;
    MarginRight := RightWaste * 2;
    MarginBottom := BottomWaste * 2;
  End; { With }
end;

procedure TfrmSecWarn2.ReportPrinter1Print(Sender: TObject);

  Procedure DoFont (FontNo : Byte);
  Begin { DoFont }
    With RepBase Do Begin
      FontName := 'Arial';
      FontColor := clBlack;
      Bold := False;
      UnderLine := False;

      SetPen (clBlack, psSolid, -1, pmCopy);
      SetBrush (clWhite, bsClear, Nil);

      Case FontNo Of
        { Main Title }
        0  : Begin
               FontSize := 24;
               Bold := True;
             End;

        { Normal - Big as intended for faxing }
        99 : Begin
               FontSize := 12;
               Bold := True;
             End;
      End; { Case }
    End; { With }
  End; { DoFont }

  Procedure SepLine;
  Var
    Y1 : LongInt;
  Begin { SepLine }
    With RepBase Do Begin
      { Draw separator line }
      Y1 := CursorYPos;
      CRLF;
      SetPen   (clBlack, psSolid, -2, pmCopy);
      MoveTo (MarginLeft + 10, YD2U(Round((CursorYPos + Y1) / 2)));
      LineTo (PageWidth - 10 - MarginRight, YD2U(Round((CursorYPos + Y1) / 2)));
      CRLF;
    End; { With RepBase }
  End; { SepLine }

  Function ExpDate : ShortString;
  var
    RelDateStr : LongDate;
    Rd,Rm,Ry   : Word;
  Begin { ExpDate }
    JulCal(Syss.RelDate,Rd,Rm,Ry);

    // HM 26/02/01: Added check for already expired dates
    If (Syss.RelDate > 0.0) Then Begin
      RelDateStr:=StrDate(Ry,Rm,Rd);
      Result := POutDate(RelDateStr);
    End { If (Syss.RelDate > 0.0) }
    Else
      Result := 'EXPIRED';
  End; { ExpDate }

  Function ESNStr : ShortString;
  var
    RelDateStr : LongDate;
    Rd,Rm,Ry   : Word;
  Begin { ESNStr }
    With Syss Do Begin
      Result := IntToStr3(ExISN[1]) + '-' +
                IntToStr3(ExISN[2]) + '-' +
                IntToStr3(ExISN[3]) + '-' +
                IntToStr3(ExISN[4]) + '-' +
                IntToStr3(ExISN[5]) + '-' +
                IntToStr3(ExISN[6]);
    End; { With Syss }
  End; { ESNStr }

begin
  inherited;

  With RepBase Do Begin
    { Print Logo }
//    PrintBitmapRect (PageWidth - RightWaste - 73,
//                     TopWaste,
//                     PageWidth - RightWaste,
//                     TopWaste + 55,
//                     Image2.Picture.Bitmap);

    { Print Title }
    GotoXY (MarginLeft, TopWaste + 70);
    DoFont(0);
    PrintCenter ('Release Code Request', PageWidth / 2);
    CRLF;
    CRLF;

    { Print 'Send To' details }
    DoFont(99);
    ClearTabs;
    SetTab (MarginLeft + 1, pjRight, 50,  4, 0, 0);
    SetTab (NA,             pjLeft,  7,   4, 0, 0);
    SetTab (NA,             pjLeft,  100, 4, 0, 0);

    PrintLn (#9 + 'Fax To:' + #9#9 + lBinIniF.ReadString('VendorDetails', 'vdContact', ''));
    PrintLn (#9 + 'Fax Number:' + #9#9 + lBinIniF.ReadString('VendorDetails', 'vdFax', ''));
    PrintLn (#9 + 'Date:' + #9#9 + FormatDateTime('dddd dd mmmm yyyy', Now));

    { Draw separator line }
    SepLine;

    { Print 'Release Code' Details }
    PrintLn (#9 + 'Version:' + #9#9 + GenSysCode (lTempLicR));
    CRLF;
    PrintLn (#9 + 'ESN:' + #9#9 + licESN7Str (lTempLicR.licISN, lTempLicR.licLicType));
    PrintLn (#9 + 'Security Code:' + #9#9 + Syss.ExSecurity);
    PrintLn (#9 + 'Expiry Date:' + #9#9 + ExpDate);

    { Draw separator line }
    SepLine;

    { Print Company Details }
    PrintLn (#9 + 'Dealer:' + #9#9 + lCustDetsO.Dealer);
    PrintLn (#9 + 'Town:' + #9#9 + lCustDetsO.DealerTown);
    CRLF;
    PrintLn (#9 + 'Contact:' + #9#9 + lCustDetsO.Contact);
    PrintLn (#9 + 'Company:' + #9#9 + lCustDetsO.Name);
    PrintLn (#9 + 'Address:' + #9#9 + lCustDetsO.Address[1]);
    PrintLn (#9#9#9 + lCustDetsO.Address[2]);
    PrintLn (#9#9#9 + lCustDetsO.Address[3]);
    PrintLn (#9#9#9 + lCustDetsO.Address[4]);
    PrintLn (#9#9#9 + lCustDetsO.Address[5]);
    PrintLn (#9 + 'Phone:' + #9#9 + lCustDetsO.Phone);
    PrintLn (#9 + 'Fax:' + #9#9 + lCustDetsO.Fax);
    PrintLn (#9 + 'Email:' + #9#9 + lCustDetsO.EmailAddr);
  End; { With ReportPrinter1 }
end;


procedure TfrmSecWarn2.SaveDefaults(Var UsrIniF : TIniFile);
Begin { SaveDefaults }
  With UsrIniF Do Begin
    If (PageControl1.ActivePage = tabshPhone) Then
      WriteInteger ('SecCodeWizard', 'SecCodeWizard',  3)
    Else
      If (PageControl1.ActivePage = tabshFax) Then
        WriteInteger ('SecCodeWizard', 'SecCodeWizard',  2)
      Else
        WriteInteger ('SecCodeWizard', 'SecCodeWizard',  1);

    WriteInteger ('SecCodeWizard', 'EmailMethod',  lstEmailMthd.ItemIndex);
    WriteString  ('SecCodeWizard', 'EmailSMTP',  edtSMTP.Text);
  End; { With UsrIniF }
End; { SaveDefaults }

{ Telephone Tab - Contine }
procedure TfrmSecWarn2.btnTelAcceptClick(Sender: TObject);
Var
  {FullExSec, NextDSec, CurRel, CurSecy : LongInt;}
  FullExSec, NextDSec, OneYrSec        : String[10];
  OK                                   : Boolean;
begin
  inherited;

  { Validate Release Code }
  OK := (Trim(edtRelCode.Text) <> '');

  If OK Then Begin
    Syss.ExRelease := Trim(edtRelCode.Text);

    // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
    { Calculate valid release codes }
    //CurSecy:=Calc_Security(Syss.ExSecurity, BOff);
    //FullExSec:=CurSecy+SecRelCode;
    //NextDSec:=CurSecy+SecXtra30Code;

    {$IFDEF EN561}
      FullExSec := Generate_ESN_BaseRelease (Syss.ExSecurity, 0, 0, 0, ExNewVer);
      NextDSec  := Generate_ESN_BaseRelease (Syss.ExSecurity, 0, 0, 1, ExNewVer);

      // HM 23/08/04: Extended for 1 Year system release codes
      OneYrSec  := Generate_ESN_BaseRelease (Syss.ExSecurity, 0, 0, 2, ExNewVer);
    {$ELSE}
      FullExSec := Generate_ESN_BaseRelease (Syss.ExSecurity, 0, 0, False, ExNewVer);
      NextDSec  := Generate_ESN_BaseRelease (Syss.ExSecurity, 0, 0, True, ExNewVer);

      OneYrSec  := NextDSec;
    {$ENDIF}

    { Check entered release code }
    //CurRel := Calc_Security(Syss.ExRelease, BOn);
    //OK := (CurRel = FullExSec) Or (CurRel = NextDSec);
    OK := (Syss.ExRelease = FullExSec) Or (Syss.ExRelease = NextDSec) Or (Syss.ExRelease = OneYrSec);
  End; { If }

  If OK Then Begin
    { Check for 30-day code and set expiry date as required }
    Syss.RelDate := 0;

    // HM 23/08/04: Extended for 1 Year system release codes
    If (Syss.ExRelease = NextDSec) Or (Syss.ExRelease = OneYrSec) Then
    Begin
      {$IFDEF EN561}
      If (Syss.ExRelease = OneYrSec) Then
      Begin
        // 1 Year
        Syss.RelDate := CalcNewRelDate(OneYrMaxDaysSecy)
      End // If (Syss.ExRelease = OneYrSec)
      Else
      {$ENDIF}
      Begin
        // 30-day
        Syss.RelDate := CalcNewRelDate(MaxDaysSecy)
      End; // Else
      
      { Set new Security Code and Blank Release Code }
      // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
      //Syss.ExSecurity := Get_ISNSecurity(Syss.EXISN);
      Syss.ExSecurity := Generate_ESN_BaseSecurity (Syss.EXISN, 0, 0, 0);
      Syss.ExRelease := '';
    End; { If }

    DoneRelCode := True;

    ExitCode := 'N';
    Close;
  End { If OK }
  Else Begin
    Inc(FailCount);

    If (FailCount < 10) Then Begin
      MessageDlg ('The Release Code is wrong, carefully check the release code and correct it', mtWarning, [mbOk], 0);
    End { If }
    Else Begin
      FailCount := 0;

      MessageDlg ('The Security Code has been changed because you have failed to correctly enter a release code',
                  mtWarning, [mbOk], 0);

      // Generate new SecCode, Blank RelCode and update screen
      Label4DblClick(Sender);
    End; { Else }

    If edtRelCode.CanFocus Then edtRelCode.SetFocus;
  End; { If }
end;

procedure TfrmSecWarn2.btnEmlCloseClick(Sender: TObject);
begin
  inherited;

  ExitCode := 'N';
  Close;
end;

procedure TfrmSecWarn2.btnFaxCloseClick(Sender: TObject);
begin
  inherited;

  ExitCode := 'N';
  Close;
end;

procedure TfrmSecWarn2.edtESNDblClick(Sender: TObject);
begin
  inherited;

  Clipboard.AsText := edtESN.Text + #13 + edtSecCode.Text;
end;

procedure TfrmSecWarn2.edtSecCodeDblClick(Sender: TObject);
begin
  inherited;

  MessageDlg('The phonetic security code is ' + QuotedStr(StringToPhonetic (edtSecCode.Text)),
             mtInformation, [mbOK], 0);
end;

procedure TfrmSecWarn2.Label4DblClick(Sender: TObject);
begin
  // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
  Syss.ExSecurity := Generate_ESN_BaseSecurity (Syss.EXISN, 0, 0, 0);
  Syss.ExRelease := '';

  edtSecCode.Text := Syss.ExSecurity;
  edtRelCode.Text := Syss.ExRelease;
  edtSecCode.Hint := StringToPhonetic (edtSecCode.Text);
end;

end.
