unit lwSerial;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, FileCtrl, TEditVal, Mask;

type
  TfrmLicWiz6 = class(TForm)
    Label2: TLabel;
    Bevel2: TBevel;
    btnNext: TButton;
    btnPrevious: TButton;
    PageControl1: TPageControl;
    tabshCD: TTabSheet;
    tabshManual: TTabSheet;
    Label44: Label8;
    btnReadSNo: TButton;
    Label3: TLabel;
    lblISN: Label8;
    lblSNo: Label8;
    Label83: Label8;
    Label1: TLabel;
    edtCDSno1: Text8Pt;
    Label81: Label8;
    edtCDSno2: Text8Pt;
    Label82: Label8;
    lblISN2: Label8;
    drvCD: TDriveComboBox;
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnReadSNoClick(Sender: TObject);
    procedure edtCDSno1KeyPress(Sender: TObject; var Key: Char);
    procedure edtCDSno1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    WizMod : SmallInt;
    procedure ReInit;
  end;


Procedure LicWiz_CDSerial (Var   WizForm           : TfrmLicWiz6;
                           Var   WizNo, LastWiz    : Byte;
                           Const WizPrev, WizNext  : Byte;
                           Var   Done, Aborted     : Boolean);


implementation

{$R *.DFM}

Uses LicVar, LicFuncU, DiskUtil, SerialU;


Procedure LicWiz_CDSerial (Var   WizForm           : TfrmLicWiz6;
                           Var   WizNo, LastWiz    : Byte;
                           Const WizPrev, WizNext  : Byte;
                           Var   Done, Aborted     : Boolean);
Begin { LicWiz_CDSerial }
  {$IFNDEF SALEUTIL}
    If (LicenceInfo.licType In [0, 1]) Then Begin
      { Create Form as and when necessary }
      If Not Assigned(WizForm) Then Begin
        WizForm := TfrmLicWiz6.Create(Application.MainForm);
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
  {$ELSE}
    If (LastWiz = WizPrev) Then
      WizNo := WizNext
    Else
      WizNo := WizPrev;
  {$ENDIF}

  LastWiz := Wiz_Serial;
End; { LicWiz_CDSerial }

{----------------------------------------------------------------------------}



procedure TfrmLicWiz6.FormCreate(Sender: TObject);
begin
  licInitWin (Self, Wiz_Serial);

  { Initialise screen values }
  drvCD.Drive := ConfigInfo.CDDrive;
  lblSNo.Caption := LicenceInfo.licSerialNo;

  { Set default Tab - CD for UK, Manual for all other countries }
  If (LicenceInfo.licCountry <= 1) Then Begin
    PageControl1.ActivePage := tabshCD;
    ActiveControl := drvCD;
  End { If }
  Else Begin
    PageControl1.ActivePage := tabshManual;
    ActiveControl := edtCDSno1;
    edtCDSno1.Text := Copy (LicenceInfo.licSerialNo, 1, 4);
    edtCDSno2.Text := Copy (LicenceInfo.licSerialNo, 6, 4);
  End; { Else }
end;


procedure TfrmLicWiz6.ReInit;
begin
  { Init local variables }
  WizMod := Wiz_Abort;
end;

procedure TfrmLicWiz6.btnPreviousClick(Sender: TObject);
begin
  WizMod := Wiz_Prev;
  Close;
end;

procedure TfrmLicWiz6.btnNextClick(Sender: TObject);
Var
  SNo  : SerialNoStrType;
begin
  { Do validation - checck serial number is set }
  With LicenceInfo Do Begin
    If (PageControl1.ActivePage = tabshCD) Then Begin
      { set by Drive }
      SNo := lblSNo.Caption;
    End { If }
    Else Begin
      { Manually entered }
      SNo := edtCDSno1.Text + '-' + edtCDSno2.Text;
    End; { Else }

    If licValidSNo(SNo) Then Begin
      LicenceInfo.licSerialNo := SNo;

      WizMod := Wiz_Next;
      Close;
    End { If }
    Else Begin
      { Serial Number not set }
      MessageDlg ('The Serial Number must be set before a licence can be created', mtError, [mbOk], 0);
    End; { If (Not lOK) }
  End; { With }
end;

procedure TfrmLicWiz6.btnReadSNoClick(Sender: TObject);
Var
  SnoB, LclSNo               : SerialNoType;
  DriveInfo                  : DriveInfoType;
  OK                         : Boolean;
begin
  { Returns loadsa information about the specified drive }
  DriveInfo.drDrive := drvCD.Drive;
  If GetDriveInfo(DriveInfo) Then Begin
    { Got Drive Information }
    Ok := (DriveInfo.drDriveType = dtCDROM); {TDriveType = (dtUnknown, dtNoDrive, dtFloppy, dtFixed, dtNetwork, dtCDROM, dtRAM);}
    If (Not OK) Then Begin
      { Not CD - Get confirmation }
      OK := (MessageDlg ('This drive is not a CD-ROM drive, do you want to continue?',
                         mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    End; { If }
  End { If }
  Else Begin
    MessageDlg ('Unable to read drive information', mtError, [mbOk], 0);
    OK := False;
  End; { Else }

  If OK Then Begin
    SNoB := GetDriveSerialB (drvCD.Drive);

    FillChar(LclSNo, SizeOf(LclSNo), #0);

    lblSNo.Caption := SNoByteToStr (SNoB);
    lblISN.Caption := SNoByteToISN (SNoB, LclSNo);

(*
      OK := ValidISNByte(OK, ccyISN1, LicenceInfo.licISN[1]);
      OK := ValidISNByte(OK, ccyISN2, LicenceInfo.licISN[2]);
      OK := ValidISNByte(OK, ccyISN3, LicenceInfo.licISN[3]);
      OK := ValidISNByte(OK, ccyISN4, LicenceInfo.licISN[4]);
      OK := ValidISNByte(OK, ccyISN5, LicenceInfo.licISN[5]);
      OK := ValidISNByte(OK, ccyISN6, LicenceInfo.licISN[6]);
*)
  End; { If }
end;

procedure TfrmLicWiz6.edtCDSno1KeyPress(Sender: TObject; var Key: Char);
begin
  If Not (Key In [#8, '0'..'9', 'A'..'F']) Then Begin
    { Illegal Serial Number character }
    If (Key In ['a'..'f']) Then
      Key := UpperCase(Key)[1]
    Else Begin
      Caption := IntToStr(Ord(Key));
      Key := #0;
    End; { Else }
  End; { If }
end;

procedure TfrmLicWiz6.edtCDSno1Change(Sender: TObject);
Var
  SNo    : SerialNoStrType;
  LclSNo : SerialNoType;
begin
  SNo := edtCDSno1.Text + '-' + edtCDSno2.Text;

  FillChar(LclSNo, SizeOf(LclSNo), #0);

  lblISN2.Caption := SNoByteToISN (SNoStrToSNoByte (SNo), LclSNo);
end;

procedure TfrmLicWiz6.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Save positions into ini file }
  licSaveCoords (Self);
end;

end.
