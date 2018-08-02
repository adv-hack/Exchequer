unit DDLogin;

{ markd6 12:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, TEditVal, Mask, SBSPanel,  IniFiles, GlobVar, Varconst,
  VarRec2U, antLabel;


type
  TELogFrm = class(TForm)
    Image1: TImage;
    UserF: Text8Pt;
    PWordF: Text8Pt;
    CanI1Btn: TButton;
    OkI1Btn: TButton;
    Label3: TLabel;
    CompLbl: TantLabel;
    antLabel1: TantLabel;
    antLabel2: TantLabel;
    antLabel3: TantLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure UserFExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PWordFExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    GotUser,
    GotSBSDoor,
    GotPWord  :  Boolean;

    TodayPW   :  Str20;


  end;


Var
  ShowGraphics : Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  BtrvU2,
  BTKeys1U,
  BTSupU1,
  BTSupU2,
  SecureU,
  Crypto,
  SysU2,
  Brand,
  History,
  //LoginWar,
  VAOUtil,
  EntLicence,
  SecSup2U;
  //entServF;


{$R *.DFM}

//=========================================================================

procedure TELogFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

//------------------------------

procedure TELogFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

//-------------------------------------------------------------------------

procedure TELogFrm.UserFExit(Sender: TObject);
Var
  FoundCode  :  Str20;
  FoundOk,
  AltMod     :  Boolean;

begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=(Modified or EnSecurity);

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanI1Btn) then
    Begin

      StillEdit:=BOn;

      GotSBSDoor:=(FoundCode=SBSDoor);

      {$B-}

        GotUser:=(GotSBSDoor) or GetLoginRec(FoundCode);

      {$B+}

      If (GotSBSDoor) then
      With EntryRec^ do
      Begin
        Login:=SBSDoor;
        PWord:=EncodeKey(23130, SBSPass2);
      end;

      If (Not GotUser) and (CanFocus) then
      Begin
        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;

//-------------------------------------------------------------------------

procedure TELogFrm.PWordFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=UpCaseStr(Strip('B',[#32],Text));

    If (ActiveControl<>CanI1Btn) then
    Begin

      StillEdit:=BOn;

      With EntryRec^ do
        GotPWord:=((Strip('B',[#32],DecodeKey(23130, PWord))=FoundCode)
                    or (((FoundCode=TodayPW) and (Not Syss.IgnoreBDPW))
                    and (GotSBSDoor)));



      If (GotPWord) then
      Begin
        SBSIn:=((FoundCode=SBSPass2) or (FoundCode=TodayPW));

        Self.ModalResult:=mrOk;
      end
      else
        If (CanFocus) then
        Begin
          SetFocus;
        end; {If not found..}
    end;


  end; {with..}
end;

//-------------------------------------------------------------------------

procedure TELogFrm.FormCreate(Sender: TObject);
begin
  ClientHeight := 214;
  ClientWidth := 357;

  Caption := Branding.pbProductName + ' OLE Server Login';
  Label3.Caption := Branding.pbProductName;

  If ShowGraphics Then
    If Branding.BrandingFileExists(ebfOLE) Then
    Begin
      With Branding.BrandingFile(ebfOLE) Do
      Begin
        If EnterpriseLicence.IsSQL Then
          ExtractImageCD (Image1, 'SQL_Login')
        Else
          ExtractImageCD (Image1, 'Login');
      End; // With Branding.BrandingFile(ebfOLE)
    End // If Branding.BrandingFileExists(ebfOLE)
    Else
      ShowGraphics := False;

  If (Not ShowGraphics) Then
    Image1.Visible := False;

  GotUser:=BOff;
  GotSBSDoor:=BOff;
  GotPWord:=BOff;
  TodayPW:=Get_TodaySecurity;
end;

//=========================================================================

Procedure CheckGraphics;
Var
  FName : ShortString;
Begin { CheckGraphics }
  // HM 10/08/04: Auto-Hide if running VAO else check the old .INI file
  ShowGraphics := (VAOInfo.vaoMode <> smVAO);
  If ShowGraphics Then
  Begin
    // Check the OLE Server .INI file to see if graphics should be displayed
    //FName := ExtractFilePath (Application.ExeName) +  'ENTEROLE.INI';
    FName := VAOInfo.vaoCompanyDir +  'ENTEROLE.INI';

    If FileExists (FName) Then
      With TIniFile.Create (FName) Do
        Try
          ShowGraphics := ReadBool('SystemConfig', 'ShowGraphics', True)
        Finally
          Free;
        End;
  End; // If ShowGraphics
End; { CheckGraphics }

Initialization
  CheckGraphics;
end.
