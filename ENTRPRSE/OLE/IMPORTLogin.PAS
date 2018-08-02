// CA 12/03/2013 v7.0.2 : ABSEXCH-13290 : New Login form created as per requirement

unit ImportLogin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComObj, Enterprise01_TLB, CTKUtil,Variants, ComCtrls,
  antLabel, Mask, TEditVal;

Type
  TfrmExchLogin = class(TForm)
    BackgroundImg: TImage;
    UserLab: TantLabel;
    antLabel2: TantLabel;
    edtUserName: Text8Pt;
    edtPassword: Text8Pt;
    OkI1Btn: TButton;
    CanI1Btn: TButton;
    CompLbl: TantLabel;
    antLabel3: TantLabel;
    procedure OkI1BtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CanI1BtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FToolkit: IToolkit;

    Procedure CMDialogKey(Var Msg:TWMKey); message CM_DIALOGKEY;
    procedure CheckLogin;
    procedure CloseToolkit;
  public
    { Public declarations }
    CompNamePath : AnsiString;
    CompName     : AnsiString;
    AreaCode     : Integer;
    AreaCodeName : AnsiString;
    OK           : Boolean;
    LoginAttemptTimes : Integer;

  end;

   procedure GlobFormKeyDown(Sender : TObject;
                  var Key           : Word;
                      Shift         : TShiftState;
                      ActiveControl : TWinControl;
                      Handle        : THandle);
var
  LoginOK: boolean;

implementation

{$R *.dfm}

Uses Brand;

procedure GlobFormKeyDown(Sender : TObject;
                      var Key    : Word;
                          Shift  : TShiftState;
                          ActiveControl
                                 :  TWinControl;
                          Handle :  THandle);
const
    // Set these up to actually make it more obvious what the difference is between
    // each PostMessage - wm_NextDlgCtl call
    PrevCtl = 0;
    NextCtl = 1;
begin

  // Have only setup the keys that actually mater in this screen
  Case Key of

    VK_UP,
    VK_LEFT  :  Begin
                PostMessage(Handle,wm_NextDlgCtl,NextCtl,0);
                Key:=0;
              end;
    VK_RETURN,
    VK_RIGHT,
    VK_DOWN
           :  Begin
                PostMessage(Handle,wm_NextDlgCtl,PrevCtl,0);
                Key:=0;
              end;
  end;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmExchLogin.CloseToolkit;
Begin
  if FToolkit <> nil then
  begin
    FToolkit.CloseToolkit;
    FToolkit := nil;
  end;
End;

//-----------------------------------------------------------------------------------------

procedure TfrmExchLogin.CheckLogin;
var
  FuncRes  : Integer;
  Res      : Integer;
begin
  LoginOK := false;
  FToolkit := OpenToolkit(CompNamePath, true);

  if not assigned(FToolkit) then
     ShowMessage('Couldn''t open the COM Toolkit')
  else
  Begin
    // Now I check to ensure the username and password are valid
    FuncRes := FToolkit.Functions.entCheckPassword(edtUserName.Text, edtPassword.text);
    LoginOK := FuncRes = 0;

    // If not valid the appropriate error will be displayed the fields will be balnked and
    // focus will be placed back to the username ready for the user to attempt to lo in again.
    // I am also checking how many login attempts the user has tried and if three is reached
    // the user will be returned back to the previous screen.
    if not LoginOK then
    Begin
      OK := False;
      edtUserName.Text := '';
      edtPassword.Text := '';
      ShowMessage('Invalid User Name and/or Password');
      LoginAttemptTimes := LoginAttemptTimes - 1;
      edtUserName.SetFocus;
    end
    else
      Begin
        // Resetting OK back to true as the login has been accepted
        // Resetting the Login Attempts to 3
        OK := True;
        LoginAttemptTimes := 3;



        //Now I check to ensure the user has permision on the Area Code they may be attempting to access
        Res := FToolkit.Functions.entCheckSecurity(edtUserName.Text, AreaCode);

        if Res = 1 Then
        Begin
           ShowMessage('You do not have the required permissions to access the ' + AreaCodeName + ' information through the Excel Add-Ins');
           OK := False;
        End
        else
          if Res = 1000 Then
          Begin
             ShowMessage('Users security information not found');
             OK := False;
          End
          else
            if Res = 1001 Then
            Begin
               ShowMessage('Area code out of range');
               OK := False;
            End;

        { The following are the results that could come back from entCheckSecurity
           0       Access allowed for specified User
           1       Access denied for specified User
           1000    User's security information not found.
           1001    Area code out of range.
        }
      End;
  end;
end;

//-----------------------------------------------------------------------------------------

Procedure TfrmExchLogin.CMDialogKey(Var Msg:TWMKey);
Begin
  If NOT (ActiveControl Is TButton) Then
    If Msg.Charcode = 13 Then
      Msg.Charcode := 9;
  inherited;
End;

//-----------------------------------------------------------------------------------------

procedure TfrmExchLogin.OkI1BtnClick(Sender: TObject);
begin
  CheckLogin;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmExchLogin.FormCreate(Sender: TObject);
begin
  Branding.BrandingFile(ebfOLE).ExtractImageCD(BackgroundImg, 'Login');
  BackgroundImg.Repaint;
  Application.ProcessMessages;

  // Set Defaults
  LoginOK := True;
  LoginAttemptTimes := 3;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmExchLogin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not LoginOK then
  Begin
     // If the user has had three attempts of entering a password and has managed
     // to get it wrong three times then the user is sent back to the main screen.
     if LoginAttemptTimes > 0 Then
        Action := caNone;
  End;

  CloseToolkit;
  LoginOK := True;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmExchLogin.CanI1BtnClick(Sender: TObject);
begin
  OK      := False;
  CloseToolkit
end;

//-----------------------------------------------------------------------------------------

procedure TfrmExchLogin.FormShow(Sender: TObject);
begin
  CompLbl.Caption := CompName;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmExchLogin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

end.
