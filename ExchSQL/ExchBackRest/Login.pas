unit Login;

{******************************************************************************}
{   Initially copied from the main Exchequer project this form provides a      }
{   standard look-and-feel Exchequer logon dialog.                             }
{   This form is displayed after "application.initialize" is called but before }
{   the main window is created in the project file. If login is not successful }
{   the application will close immediately this form closes.                   }
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComObj, Enterprise01_TLB, CTKUtil, Blowfish, IniFiles;

type
  TfrmLogin = class(TForm)
    bgImage: TImage;
    btnCancel: TButton;
    btnOK: TButton;
    edtPassword: TEdit;
    Label2: TLabel;
{* Event Procedures *}
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtPasswordChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
  protected
    constructor create(AOwner: TComponent); override; // lower visibility so it can't be created from another unit
  private
{* Internal Fields *}
{* Property Fields *}
{* Procedural Methods *}
    procedure DoBranding;
    procedure CheckLogin;
    procedure Shutdown;
    procedure Startup;
    function  SystemPassword: string;
{* Getters and Setters *}
  public
    class procedure Show;
    destructor destroy; override;
  end;

var
  LoginOK: boolean;
  LoginPassword: string;

Implementation

uses common, Brand, VAOUtil, EntLicence, TLoggerClass, SecSup2U, VarRec2U;

{$R *.DFM}

var
  frmLogin: TfrmLogin;

{ TELogFrm }

class procedure TfrmLogin.Show;
begin
  if not assigned(frmLogin) then
    frmLogin := TfrmLogin.Create(nil);

  frmLogin.ShowModal;
end;

constructor TfrmLogin.create(AOwner: TComponent);
begin
  inherited;
  Logger.LogFileName := VAOInfo.vaoAppsDir + 'LOGS\ExchBackRest.log'; // override Logger's default path
end;

destructor TfrmLogin.destroy;
begin
  inherited;
end;

{* Procedural Methods *}

procedure TfrmLogin.CheckLogin;
begin
  EncryptionOn;
  LoginOK := edtPassword.Text = SystemPassword; // Decrypt('eiGy9sIgSkriZmzcWefxxk'); // sprockets

  try
    if not LoginOk then
      with TIniFile.Create(IniFileName) do begin
        LoginOK := Encrypt(edtPassword.Text) = ReadString('Security', 'Password', 'notyetset');
        free;
      end;

    if not LoginOK then begin
      MessageBox(self.Handle, 'Invalid Password', 'Exchequer Backup & Restore', MB_ICONEXCLAMATION + MB_OK);
      Logger.LogLine('Invalid password');
      edtPassword.SetFocus;
    end
    else begin
      LoginPassword := Encrypt(edtPassword.Text);
      Logger.LogLine('Logged in');
    end;
  except
    LoginOK := false;
  end;
end;

{ CJS - 2013-07-08 - ABSEXCH-14438 - update branding and copyright - changed
  DoBranding to a method of the form so it has access to the form components.
  Also changed it to read the colour mode from the branding file. }
procedure TfrmLogin.DoBranding;
var
  PBF: IProductBrandingFile;
begin
  if (VAOInfo.vaoHideBitmaps) then
    bgImage.Picture := nil
  else begin // pick up the login background from Branding
    initBranding(VAOInfo.vaoCompanyDir);
    if Branding.BrandingFileExists(ebfOLE) then begin
      PBF := Branding.BrandingFile(ebfOLE);
      With PBF Do
      Begin
        If EnterpriseLicence.IsSQL Then
          ExtractImageCD (bgImage, 'SQL_Login')
        Else
          ExtractImageCD (bgImage, 'Login');
      End; // With Branding.BrandingFile(ebfOLE)
    end
  end;
end;


procedure TfrmLogin.Shutdown;
begin
end;

procedure TfrmLogin.Startup;
begin
  DoBranding;
end;

{* Event Procedures *}

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
//  ClientHeight:=214;
//  ClientWidth:=357;
  Startup;
end;

procedure TfrmLogin.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmLogin.btnOKClick(Sender: TObject);
begin
  CheckLogin;
  if LoginOK then begin
    ModalResult := mrOK;
  end;
end;

procedure TfrmLogin.edtPasswordChange(Sender: TObject);
begin
  btnOK.Enabled := length(trim(edtPassword.Text)) >= 6;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Shutdown;
  action := caFree;
  frmLogin := nil;
end;

procedure TfrmLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  Key := EnterToTab(Key, handle);
  if ActiveControl = btnOK then // mimic Exchequer behaviour which is to logon as soon as they Enter out of the password box
    btnOKClick(nil);
end;

procedure TfrmLogin.FormActivate(Sender: TObject);
begin
  self.BringToFront; // particularly relevant when actioned from tray icon - sometimes doesn't get focus
end;

function TfrmLogin.SystemPassword: string;
var
  ESN: string;
  TodayPW: string;
  ISN: ISNArrayType;
  Segment: integer;
begin
  ESN := EnterpriseLicence.elFullESN;
  Segment := 1;
  while Segment <= 8 do begin
    ISN[Segment] := StrToIntDef(copy(ESN, 1, 3), 0); // returns an empty string for the 8th segment = 0
    Delete(ESN, 1, 4);
    inc(Segment);
  end;
  TodayPW := Generate_ESN_BaseSecurity(ISN, 251, 0, 0);
  result  := LowerCase(TodayPW);
end;

initialization
  LoginOK  := false;

end.
