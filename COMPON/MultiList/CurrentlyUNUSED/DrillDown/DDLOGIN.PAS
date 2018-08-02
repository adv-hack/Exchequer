unit DDLogin;

{ markd6 12:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, TEditVal, Mask, SBSPanel,  IniFiles, GlobVar, Varconst,
  VarRec2U;


type
  TELogFrm = class(TForm)
    Image1: TImage;
    UserF: Text8Pt;
    UserLab: Label8;
    Label82: Label8;
    PWordF: Text8Pt;
    CanI1Btn: TButton;
    VerF: Label8;
    OkI1Btn: TButton;
    Login16: TImage;
    Login256: TImage;
    CompLbl: Label8;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
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
  //LoginWar,
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
{Const
  SplashTit  :  Array[0..2] of Str10 = ('LOGIN16','LOGIN256','LOGIN16M');
Var
  BMPPath  :  PChar;
  PBuff    :  Array[0..255] of Char;}
begin
  ClientHeight := 214;
  ClientWidth := 357;

  If ShowGraphics Then
    Case GetMaxColors(Self.Canvas.Handle) Of
      0 : Image1.Picture := Login16.Picture;
      1 : Image1.Picture := Login256.Picture;
      2 : ; //Image1.Picture := Login16M.Picture;
    Else
          Image1.Picture := Login16.Picture;
    End
  Else
    Image1.Visible := False;


  {BMPPath:=StrPCopy(PBuff,SetDrive+SplashTit[GetMaxColors(Self.Canvas.Handle)]+'.BMP');

  Image1.Picture.Bitmap.LoadFromFile(BMPPath);}

  GotUser:=BOff;
  GotSBSDoor:=BOff;
  GotPWord:=BOff;
  TodayPW:=Get_TodaySecurity;
  VerF.Caption:='Version: '+Ver;

  {With Syss,UserLab do
    Caption:=Caption+Spc(10)+'('+Form_Int(Succ(Syss.EntULogCount),0)+'/'+
                          Form_Int(DeCode_Usrs(ExUsrSec,ExUsrRel),0)+')';}

end;

//=========================================================================

Procedure CheckGraphics;
Var
  FName : ShortString;
Begin { CheckGraphics }
  // Check the OLE Server .INI file to see if graphics should be displayed
  FName := ExtractFilePath (Application.ExeName) +  'ENTEROLE.INI';

  If FileExists (FName) Then
    With TIniFile.Create (FName) Do
      Try
        ShowGraphics := ReadBool('SystemConfig', 'ShowGraphics', True)
      Finally
        Free;
      End;
End; { CheckGraphics }

Initialization
  CheckGraphics;
end.
