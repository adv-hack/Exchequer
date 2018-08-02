unit lwEntVer;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TfrmLicWiz2 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    lstEntMods: TListBox;
    Bevel2: TBevel;
    btnNext: TButton;
    btnPrevious: TButton;
    lstClSvr: TListBox;
    lstCurrVer: TListBox;
    Label1: TLabel;
    lstUsers: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    lstCompanies: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    cmbVersion: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure lstCurrVerClick(Sender: TObject);
    procedure lstEntModsClick(Sender: TObject);
    procedure lstClSvrClick(Sender: TObject);
    procedure lstUsersKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    WizMod : SmallInt;
  end;

Procedure LicWiz_EntVer (Var   WizForm           : TfrmLicWiz2;
                         Var   WizNo, LastWiz    : Byte;
                         Const WizPrev, WizNext  : Byte;
                         Var   Done, Aborted     : Boolean);

implementation

{$R *.DFM}

Uses LicRec, LicVar, ECBUtil;


Procedure LicWiz_EntVer (Var   WizForm           : TfrmLicWiz2;
                         Var   WizNo, LastWiz    : Byte;
                         Const WizPrev, WizNext  : Byte;
                         Var   Done, Aborted     : Boolean);
Begin { LicWiz_EntVer }
  If (LicenceInfo.licType In [0, 1]) Then Begin
    { Create Form as and when necessary }
    If Not Assigned(WizForm) Then Begin
      WizForm := TfrmLicWiz2.Create(Application.MainForm);
    End; { If Not Assigned(WizForm)  }

    { Re-Initialise forms return value }
    WizForm.WizMod := Wiz_Abort;

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

  LastWiz := Wiz_EntVer;
End; { LicWiz_EntVer }

{----------------------------------------------------------------------------}


procedure TfrmLicWiz2.FormCreate(Sender: TObject);
var
  I : Byte;
begin
  licInitWin (Self, Wiz_EntVer);

  { Init local variables }
  WizMod := Wiz_Abort;

  { Initialise screen values }
  lstCurrVer.ItemIndex := LicenceInfo.licEntCVer;
  lstEntMods.ItemIndex := LicenceInfo.licEntModVer;

  If (LicenceInfo.licEntDB = DBBtrieve) Then
    // Pervasive Edition
    lstClSvr.ItemIndex := LicenceInfo.licEntClSvr
  Else
    // SQL Edition
    lstClSvr.ItemIndex := 2;

  //lstUsers.Text := IntToStr(LicenceInfo.licUserCnt);
  UpDown1.Position := LicenceInfo.licUserCnt;
  //lstCompanies.Text := IntToStr(LicenceInfo.licUserCounts[ucCompanies]);
  UpDown2.Position := LicenceInfo.licUserCounts[ucCompanies];

  cmbVersion.Items.LoadFromFile (ExtractFilePath(Application.ExeName) + 'Versions.Lst');
  If (cmbVersion.Items.Count > 0) Then
    cmbVersion.ItemIndex := 0;
end;

procedure TfrmLicWiz2.btnPreviousClick(Sender: TObject);
begin
  WizMod := Wiz_Prev;
  Close;
end;

procedure TfrmLicWiz2.btnNextClick(Sender: TObject);
Var
  UCount, ErrCode : Integer;
  OK              : Boolean;
begin
  { Do validation }

  { Currency Version }
  OK := (lstCurrVer.ItemIndex >= 0);
  If (Not OK) Then Begin
    MessageDlg('The Exchequer Currency Version must be set', mtError, [mbOK], 0);
    If lstCurrVer.CanFocus Then lstCurrVer.SetFocus;
  End; { If (Not OK) }

  If OK Then Begin
    { Module Version }
    OK := (lstEntMods.ItemIndex >= 0);
    If (Not OK) Then Begin
      MessageDlg('The Exchequer Module Version must be set', mtError, [mbOK], 0);
      If lstEntMods.CanFocus Then lstEntMods.SetFocus;
    End; { If (Not OK) }
  End; { If OK }

  If OK Then Begin
    { Client-Server Version }
    OK := (lstClSvr.ItemIndex >= 0);
    If (Not OK) Then Begin
      MessageDlg('The Exchequer Client-Server Version must be set', mtError, [mbOK], 0);
      If lstClSvr.CanFocus Then lstClSvr.SetFocus;
    End; { If (Not OK) }
  End; { If OK }

  If OK Then Begin
    { Exchequer User Count }
    OK := (Trim(lstUsers.Text) <> '');
    If OK Then Begin
      Val (lstUsers.Text, UCount, ErrCode);
      OK := (ErrCode = 0) And (UCount >= 1) And (UCount <= 999);
      If OK Then
        LicenceInfo.licUserCnt := UCount;
    End; { If OK }

    If (Not OK) Then Begin
      MessageDlg('The Exchequer User Count is invalid', mtError, [mbOK], 0);
      If lstUsers.CanFocus Then lstUsers.SetFocus;
    End; { If (Not OK) }
  End; { If OK }

  If OK Then Begin
    { Exchequer Company Count }
    OK := (Trim(lstCompanies.Text) <> '');
    If OK Then Begin
      Val (lstCompanies.Text, UCount, ErrCode);
      OK := (ErrCode = 0) And (UCount >= 0) And (UCount <= 9999);
      If OK Then
        LicenceInfo.licUserCounts[ucCompanies] := UCount;
    End; { If OK }

    If (Not OK) Then Begin
      MessageDlg('The Exchequer Company Count is invalid', mtError, [mbOK], 0);
      If lstCompanies.CanFocus Then lstCompanies.SetFocus;
    End; { If (Not OK) }
  End; { If OK }

  If OK Then Begin
    CDGenInfo.VersionStr := cmbVersion.Text;

   // Default Full Stock Control on for Stock/SPOP modules
    // MH 03/12/2014 ABSEXCH-15896: Modified so it only defaults it when creating a new licence
    If ConfigInfo.AddMode And (LicenceInfo.licEntModVer > 0) Then
      LicenceInfo.licModules[modFullStock] := 2;

    WizMod := Wiz_Next;
    Close;
  End; { If OK ... }
end;

procedure TfrmLicWiz2.lstCurrVerClick(Sender: TObject);
begin
  LicenceInfo.licEntCVer := lstCurrVer.ItemIndex;
end;

procedure TfrmLicWiz2.lstEntModsClick(Sender: TObject);
begin
  LicenceInfo.licEntModVer := lstEntMods.ItemIndex;
end;

procedure TfrmLicWiz2.lstClSvrClick(Sender: TObject);
begin
  Case lstClSvr.ItemIndex Of
    // Pervasive - Non Client-Server
    0  : Begin
           LicenceInfo.licEntDB := DBBtrieve;
           LicenceInfo.licEntClSvr := 0;
         End; // Pervasive - Non Client-Server
    // Pervasive - Client-Server
    1  : Begin
           LicenceInfo.licEntDB := DBBtrieve;
           LicenceInfo.licEntClSvr := 1;
         End; // Pervasive - Client-Server
    // Microsoft - SQL Server
    2  : Begin
           LicenceInfo.licEntDB := dbMSSQL;
           LicenceInfo.licEntClSvr := 1;
         End; // Microsoft - SQL Server
  Else
    Raise Exception.Create ('TfrmLicWiz2.lstClSvrClick: Unknown DB Setting - Tell Mark');
  End; // Case lstClSvr.ItemIndex
end;

procedure TfrmLicWiz2.lstUsersKeyPress(Sender: TObject; var Key: Char);
begin
  If Not (Key In [#8, '0'..'9']) Then
    Key := #0;
end;

procedure TfrmLicWiz2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Save positions into ini file }
  licSaveCoords (Self);
end;

end.
