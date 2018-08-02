unit ELoginU;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, TEditVal, Mask, SBSPanel,  GlobVar;


type
  TELogFrm = class(TForm)
    UserF: Text8Pt;
    UserLab: Label8;
    Label82: Label8;
    PWrdF: Text8Pt;
    CanI1Btn: TButton;
    VerF: Label8;
    OkI1Btn: TButton;
    Login256: TImage;
    Image1: TImage;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure PWrdFExit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UserFExit(Sender: TObject);
  private
    { Private declarations }
    TKOpen  :  Boolean;
    FPath : string;
    procedure CheckLogin(bShowMessages : boolean);

  public
    { Public declarations }

    GotUser,
    GotSBSDoor,
    GotPWord  :  Boolean;

    TodayPW   :  Str20;
    constructor CreateWithPath(AOwner : TComponent; APath : string);

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  VarConst,
  ETStrU,
  About,
  SysU2,
  BTSupU1,
  BTSupU2,
  UseDLLU,
  TKUtil,
  Brand,
  EntLicence,
  VarFPOSU;


{$R *.DFM}
constructor TELogFrm.CreateWithPath(AOwner : TComponent; APath : string);
begin
  FPath := APath;
  Inherited Create(AOwner);
end;

procedure TELogFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TELogFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TELogFrm.CheckLogin(bShowMessages : boolean);
var
  iStatus : smallint;
  NewActiveControl : Text8Pt;
  sMessage : string;
  asCompPath : ANSIString;
begin
  GotUser:=False; GotPWord:=False;

  screen.cursor := crHourglass;
  {Check that the username and password are valid for enterprise}
  iStatus := EX_CHECKPASSWORD(PChar(UserF.Text), PChar(PWrdF.Text));
  sMessage := '';
  case iStatus of
        0 : Begin
              GotUser:=True; GotPWord:=True;
              EntryRec^.Login := UserF.Text;
              // GetLogInRec(UserF.Text); // Other access rights to be set here. Won't work yet, as pwrd file not open here, need TK function.
            end;
    30001 : begin
      sMessage := 'You have entered an invalid user name';
      NewActiveControl := UserF;
    end;

    30002 : begin
      sMessage := 'You have entered an invalid password for this user';
      NewActiveControl := PwrdF;
    end;

    else begin
           if bShowMessages then ShowTKError('EX_CHECKPASSWORD', 120, iStatus); {other error}
         end;{if}
  end;{case}

  if sMessage <> '' then begin
    {Login error}
    if bShowMessages then
    begin
      MessageDlg(sMessage, mtError,[mbOK],0);
      ActiveControl := NewActiveControl;
      NewActiveControl.SelectAll;
    end;{if}
  end;{if}
  screen.cursor := crDefault;
end;


procedure TELogFrm.PWrdFExit(Sender: TObject);

begin
  if ActiveControl <> CanI1btn then
  Begin
    CheckLogin(True);

    If (GotUser and GotPWord) then
      OKI1Btn.Click;
  end;

end;


procedure TELogFrm.FormCreate(Sender: TObject);
Var
  Res          :  Integer;
  MainCoPath   :  String;
  WinLogin     :  string;
  iStatus      :  SmallInt;
  CopyrightColorMode : Integer;
begin
  //PR: 10/09/2012 ABSEXCH-12952 Changed to use new bitmap rather than branding
  ExMainCoPath^ := '';
  If (NoXLogo) then
  Begin
    Image1.Visible := False;
    Self.Height:=Self.Height-80;
    VerF.Top:=VerF.Top-80;
    VerF.Left:=5;
  end
  else
  begin
    If Branding.BrandingFileExists(ebfOLE) Then
    Begin
      CopyrightColorMode := -1;

      With Branding.BrandingFile(ebfOLE) Do
      Begin
        If EnterpriseLicence.IsSQL Then
        Begin
          ExtractImageCD (Image1, 'SQL_Login');
          CopyrightColorMode := pbfData.GetInteger('SQLVersionColour', -1);
          VerF.Top := VerF.Top + pbfData.GetInteger('SQLVersionVAdjust', 0);
        End // If EnterpriseLicence.IsSQL
        Else
        Begin
          ExtractImageCD (Image1, 'Login');
          CopyrightColorMode := pbfData.GetInteger('PervVersionColour', -1);
          VerF.Top := VerF.Top + pbfData.GetInteger('PervVersionVAdjust', 0);
        End; // Else
      End; // With Branding.BrandingFile(ebfOLE)

      Case CopyrightColorMode Of
        0 : VerF.Font.Color := clWhite;
      Else
        VerF.Font.Color := clBlack;
      End; // Case CopyrightColorMode
    End; // If Branding.BrandingFileExists(ebfOLE)

  end;


  Syss.TxlateCR:=BOn;  //Force CR through.

  GotUser:=BOff;
  GotSBSDoor:=BOff;
  GotPWord:=BOff;
  TodayPW:='';
  {$IFDEF ADMIN}
  VerF.Caption := EbusAdminVersion;
  {$ENDIF}


  ClientHeight:=214;
  ClientWidth:=357;

  if Trim(FPath) = '' then
    MainCoPath:=IncludeTrailingBackSlash(GetMultiCompDir)
  else
    MainCoPath := FPath;

  ExMainCoPath^ := '';

  Res:=SetToolkitPath(MainCoPath);

  ShowTKError('Attempting to open main company '+#13+MainCoPath,84,Res);

  If (Res=0) then
  Begin
    Res:=EX_InitDLL;

    ShowTKError('Attempting to open DLL for '+#13+MainCoPath,1,Res);

  end;

  TKOpen:=(Res=0);

  if TKOpen then
  begin
    WinLogIn:= Copy(UpCaseStr(WinGetUserName), 1, 10);

    If (WinLogIn<>'')  then
    Begin
      iStatus := EX_CHECKPASSWORD(PChar(WinLogIn), PChar(PWrdF.Text));
      if (iStatus = 30002) or (iStatus = 0) then
      begin
        UserF.Text:=WinLogIn;
        UserF.SelectAll;
      end;
    end;

  end;

end;



procedure TELogFrm.FormDestroy(Sender: TObject);
begin
  If (TKOpen) then
  Begin
    TKOpen:=False;
    EX_CloseData;

  end;
end;


procedure TELogFrm.UserFExit(Sender: TObject);
VAR
  iStatus : SmallInt;
  SecRes : SmallInt;
  b, i : byte;
begin
  if ActiveControl <> CanI1Btn then
  begin
    iStatus := EX_CHECKPASSWORD(PChar(UserF.Text), PChar(PWrdF.Text));
    if iStatus = 30001 then
    begin
      ActiveControl := UserF;
      UserF.SelStart := 0;
      UserF.SelLength := Length(UserF.Text);
    end
    else
    begin
      iStatus := Ex_CheckSecurity(PChar(UserF.Text), ebpAccess, SecRes);
      if (iStatus <> 0) or (SecRes = 0) then
      begin
        ShowMessage('This user is not authorised to access the Ebusiness module');
        ActiveControl := UserF;
        UserF.SelStart := 0;
        UserF.SelLength := Length(UserF.Text);
      end
      else
      begin
        //Load user permissions into ThisUser object
        ThisUser.UserName := UserF.Text;
      end;
    end;
  end;
end;

end.
