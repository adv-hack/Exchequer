unit OleLogin;

{ markd6 12:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, TEditVal, Mask, SBSPanel,  GlobVar, Varconst,
  VarRec2U, ExBtTh1U, antLabel;


type
  TELogFrm = class(TForm)
    Image1: TImage;
    UserF: Text8Pt;
    PWordF: Text8Pt;
    CanI1Btn: TButton;
    OkI1Btn: TButton;
    antLabel1: TantLabel;
    antLabel2: TantLabel;
    CompLbl: TantLabel;
    lblProdName: TLabel;
    Label4: TLabel;
    antLabel3: TantLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure UserFExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PWordFExit(Sender: TObject);
    procedure CanI1BtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ExBtr  : TdPostExLocalPtr;

    GotUser,
    GotSBSDoor,
    GotPWord  :  Boolean;

    TodayPW   :  Str20;


  end;


Function GetLogInRec(LoginCode : Str20;ExBtr : TdPostExLocalPtr)  :  Boolean;
Function BtrUserTo431User (ExBtr : TdPostExLocalPtr) : EntryRecType;

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
  LoginWar,
  SecSup2U,
  History,
  Brand,
  ETDateU,
  EntLicence,
  entServF;


{$R *.DFM}


Function BtrUserTo431User (ExBtr : TdPostExLocalPtr) : EntryRecType;
Var
  N        : Byte;

  {== Routines to control the getting and storage of additional password records ==}
  Procedure SetEntryRecVar(PgNo    :  Byte;
                           PLogin  :  Str10;
                           LoadRec,
                           OverWER :  Boolean;
                       Var ERec    :  EntryRecType);
  Const
    Fnum      =  PWrdF;
    Keypath   =  PWK;
  Var
    KeyS  :  Str255;
    SetER :  Boolean;
    n     :  Byte;
    Idx   :  Longint;
    TmpPassWord  : PassWordRec;
  Begin
    With ExBtr^ Do Begin
      TmpPassWord := LPassword;

      SetER:=BOn;

      If LoadRec Then Begin
        KeyS:=FullPWordKey(PassUCode,Chr(PgNo),PLogin);

        Status:=LFind_Rec(B_GetEq,FNum,KeyPath,KeyS);

        If (Not StatusOk) Then Begin
          LResetRec(Fnum);
          SetER:=OverWER; {In the case of a copy or system copy, do not overwrite EntryRec if not found *}
        End; { If (Not StatusOk) }
      End; { If LoadRec }

      Idx:=256*PgNo;

      With LPassWord, PassEntryRec Do Begin
        If (SetER) then
          For n:=Low(Access) to High(Access) Do
            ERec.Access[n+Idx]:=Access[n];

        If (PgNo=0) then Begin
          ERec.Login:=Login;
          ERec.LastPNo:=LastPNo;
          ERec.PWord:=PWord;
        End; { If (PgNo=0) }
      End; { With LPassWord, PassEntryRec }

      LPassword := TmpPassWord;
    End; { With ExBtr^ }
  end;

Begin { BtrUserTo431User }
  With ExBtr^.LPassword.PassEntryRec Do
    // HM 02/02/05: Extended passwords to 4 pages (1000 in total)
    For N := 0 To 3 Do
      SetEntryRecVar(N,Login,(N>0),BOn,Result);
End; { BtrUserTo431User }

{---------------------------------------------------------------------------------------------}

{ Function to return User record - copied from SysU2 and modified }
Function GetLogInRec(LoginCode : Str20;ExBtr : TdPostExLocalPtr)  :  Boolean;
Const
  Keypath  =  PWK;
  Fnum     =  PWrdF;
Var
  KeyS     : Str255;
  //lStatus : SmallInt;
Begin
  Result:=BOff;

  KeyS:=FullPWordKey(PassUCode,C0,LoginCode);

  With ExBtr^ Do
  Begin
    lStatus:=LFind_Rec(B_GetEq,FNum,KeyPath,KeyS);

    Result := (lStatus = 0);
    If Result then
    begin
      If (Branding.pbProduct = Brand.ptExchequer) Then
      Begin
        // Get the user profile and check the password expiry  (Doesn't apply to LITE)
        KeyS := FullPWordKey(PassUCode, 'D', lPassword.PassEntryRec.Login);
        Status := LFind_Rec(B_GetEq, MLocF, MLK, KeyS);
        If (Status = 0) Then
        Begin
          Case LMLocCtrl.PassDefRec.PWExpMode Of
            0 : ; // Never Expires
            1 : Begin
                  // Check number of days left before expiry
                  Result := (NoDays(Today, LMLocCtrl.PassDefRec.PWExpDate) > 0);
                End;
            2 : Result := False; // Expired
          End; // Case LMLocCtrl.PassDefRec.PWExpMode
        End; // If (lStatus = 0)
      End; // If (Branding.pbProduct = ptExchequer)
    End; // If Result

    If Result then
    begin
      // Get all the user permissions records and combine into one consolidated record
      EntryRec^ := BtrUserTo431User (ExBtr);
    End; // If Result
  End; // With ExBtr^
end; {Func..}

procedure TELogFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TELogFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TELogFrm.UserFExit(Sender: TObject);
Var
  FoundCode  :  Str20;
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

        GotUser:=(GotSBSDoor) or (GetLoginRec(FoundCode, ExBtr));

      {$B+}

      If (GotSBSDoor) then
      With EntryRec^ do
      Begin
        Login:=SBSDoor;
        PWord:=Encode(SBSPass2);
      end;

      If (Not GotUser) and (CanFocus) then
      Begin
        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;


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
        GotPWord:=((Strip('B',[#32],Decode(PWord))=FoundCode)
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


procedure TELogFrm.FormCreate(Sender: TObject);
Var
  CopyrightColorMode : Integer;
begin
  ClientHeight := 214;
  ClientWidth := 357;

  Caption := Branding.pbProductName + ' OLE Server Login';
  lblProdName.Caption := Branding.pbProductName;

  If ShowGraphics Then
  Begin
    If Branding.BrandingFileExists(ebfOLE) Then
    Begin
      CopyrightColorMode := -1;

      With Branding.BrandingFile(ebfOLE) Do
      Begin
        If EnterpriseLicence.IsSQL Then
        Begin
          ExtractImageCD (Image1, 'SQL_Login');
          CopyrightColorMode := pbfData.GetInteger('SQLVersionColour', -1);
        End // If EnterpriseLicence.IsSQL
        Else
        Begin
          ExtractImageCD (Image1, 'Login');
          CopyrightColorMode := pbfData.GetInteger('PervVersionColour', -1);
        End; // Else
      End; // With Branding.BrandingFile(ebfOLE)
    End // If Branding.BrandingFileExists(ebfOLE)
    Else
      ShowGraphics := False;
  End; // If ShowGraphics

  If (Not ShowGraphics) Then
    Image1.Visible := False;

//  If ShowGraphics Then
//    Case GetMaxColors(Self.Canvas.Handle) Of
//      0 : Image1.Picture := Login16.Picture;
//      1 : Image1.Picture := Login256.Picture;
//      2 : ; //Image1.Picture := Login16M.Picture;
//    Else
//          Image1.Picture := Login16.Picture;
//    End
//  Else
//    Image1.Visible := False;


  {BMPPath:=StrPCopy(PBuff,SetDrive+SplashTit[GetMaxColors(Self.Canvas.Handle)]+'.BMP');

  Image1.Picture.Bitmap.LoadFromFile(BMPPath);}

  GotUser:=BOff;
  GotSBSDoor:=BOff;
  GotPWord:=BOff;
  TodayPW:=Get_TodaySecurity;

  {With Syss,UserLab do
    Caption:=Caption+Spc(10)+'('+Form_Int(Succ(Syss.EntULogCount),0)+'/'+
                          Form_Int(DeCode_Usrs(ExUsrSec,ExUsrRel),0)+')';}

end;



procedure TELogFrm.CanI1BtnClick(Sender: TObject);
Var
  Form_LogonWarn: TForm_LogonWarn;
begin
  Form_LogonWarn := TForm_LogonWarn.Create(Self);
  Try

    Form_LogonWarn.ShowModal;

    If (Form_LogonWarn.ModalResult = mrYes) Then Begin
      { Continue with the cancel }
      ModalResult := mrCancel;
    End; { If }
  Finally
    Form_LogonWarn.Free;
  End;
end;

end.
