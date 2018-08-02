unit ChangePwordF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EnterToTab;

type
  TfrmChangeUserPword = class(TForm)
    Label1: TLabel;
    edtUserName: TEdit;
    Label2: TLabel;
    edtCurrentPword: TEdit;
    Label3: TLabel;
    edtNewPword: TEdit;
    Label4: TLabel;
    edtConfirmPword: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    EnterToTab1: TEnterToTab;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FCurrentPassword : ShortString;
    FNewPassword : ShortString;
    FailCount : Byte;

    Function GetUserName : ShortString;
    Procedure SetUserName (Value : ShortString);
    Procedure SetCurrentPassword (Value : ShortString);
  public
    { Public declarations }
    Property UserName : ShortString Read GetUserName Write SetUserName;
    Property CurrentPassword : ShortString Read FCurrentPassword Write SetCurrentPassword;
    Property NewPassword : ShortString Read FNewPassword Write FNewPassword;
  end;

// MH 04/11/2010 v6.5 ABSEXCH-9521: Rewrote Change My Password process as it was shockingly shoddy
Procedure Change_PassWord (Owner  :  TWinControl);

implementation

{$R *.dfm}

//GS 01/06/2011 ABSEXCH-11376:
//added units to allow manipulation of the users password expiry date:
//PassWR2U (getting and setting the users password defaults record)
//VarRec2U (defines the password defaults record structure)
//DateUtils (contains methods for date modification)
Uses GlobVar, VarConst, BtrvU2, BTSupU1, BTKeys1U, SavePos, Crypto, PassWR2U, VarRec2U, DateUtils;


// MH 04/11/2010 v6.5 ABSEXCH-9521: Rewrote Change My Password process as it was shockingly shoddy
Procedure Change_PassWord (Owner  :  TWinControl);
var
  frmChangeUserPword : TfrmChangeUserPword;
  KeyS : Str255;
  bOK, bLocked : Boolean;
  LockPos : LongInt;
  iStatus : SmallInt;
  DefaultsRecord: tPassDefType;
Begin // Change_PassWord
  If (Syss.UsePasswords) Then
  Begin
    With TBtrieveSavePosition.Create Do
    Begin
      Try
        // Save the current position in the file for the current key
        SaveFilePosition (PWrdF, GetPosKey);
        SaveDataBlock (EntryRec, SizeOf(EntryRec^));

        //------------------------------

        // Get and lock the user profile record
        KeyS := FullPWordKey(PassUCode, Chr(0), EntryRec^.Login);
        bOK := GetMultiRec(B_GetEq, B_MultLock, KeyS, PWK, PWrdF, True, bLocked);
        If bOK And bLocked Then
        Begin
          GetPos(F[PWrdF], PWrdF, LockPos);

          //------------------------------

          // Display Change Password dialog
          frmChangeUserPword := TfrmChangeUserPword.Create(Owner);
          Try
            frmChangeUserPword.UserName := Trim(PassWord.PassEntryRec.Login);
            frmChangeUserPword.CurrentPassword := PassWord.PassEntryRec.Pword;

            If (frmChangeUserPword.ShowModal = mrOK) Then
            Begin
              // Update User Profile record
              PassWord.PassEntryRec.Pword := frmChangeUserPword.NewPassword;
              iStatus := Put_Rec(F[PWrdF], PWrdF, RecPtr[PWrdF]^, PWK);
              Report_BError(PWrdF,iStatus);

              //GS 01/06/2011 ABSEXCH-11376: when the user changes their password from the
              //'utilities > system setup > change my password' form there PW expiry date
              //does not increment, added code to refresh the users PW expiry date:

              //get the users 'PasswordDefaults' record for the current user;
              //this contains the users password expiry information
              DefaultsRecord := PassWR2U.Get_PWDefaults(frmChangeUserPword.GetUserName);
              //Increment the users password expiry date by modifying the the record
              PassWR2U.SetPasswordExpDate(DefaultsRecord);
              //Store the modified 'PasswordDefaults' record
              PassWR2U.Store_PWDefaults(frmChangeUserPword.GetUserName, DefaultsRecord);

            End; // If (frmChangeUserPword.ShowModal = mrOK)
          Finally
            frmChangeUserPword.Free;
          End; // Try..Finally

          //------------------------------

          // Unlock User Profile record
          UnlockMultiSing(F[PWrdF], PWrdF, LockPos);
        End // If bOK And bLocked
        Else
          MessageDlg('Someone else is editing this user record, please try again later', mtWarning, [mbOK], 0);

        //------------------------------

        // Restore position in file
        RestoreDataBlock (EntryRec);
        RestoreSavedPosition;
      Finally
        Free;
      End; // Try..Finally
    End; // With TBtrieveSavePosition.Create
  End; // If (Syss.UsePasswords)
End; // Change_PassWord

//=========================================================================

procedure TfrmChangeUserPword.FormCreate(Sender: TObject);
begin
//  ClientHeight := ??
//  ClientWidth := ??

  FailCount := 0;
  FNewPassword := '';
  FCurrentPassword := '';
end;

//-------------------------------------------------------------------------

Function TfrmChangeUserPword.GetUserName : ShortString;
Begin // GetUserName
  Result := edtUserName.Text;
End; // GetUserName
Procedure TfrmChangeUserPword.SetUserName (Value : ShortString);
Begin // SetUserName
  edtUserName.Text := Value;
End; // SetUserName

//------------------------------

Procedure TfrmChangeUserPword.SetCurrentPassword (Value : ShortString);
Begin // SetCurrentPassword
  FCurrentPassword := EncodeKey(23130, Trim(DecodeKey (23130, Value)));
End; // SetCurrentPassword

//-------------------------------------------------------------------------

procedure TfrmChangeUserPword.btnOKClick(Sender: TObject);
Var
  BadCtrl : TWinControl;
begin
  BadCtrl := NIL;

  // NOTE: Eduardo is converting passwords to uppercase during login so we have to duplicate
  // that effect here by setting CharCase to ecUpperCase - even if it does make Exchequer less
  // secure - otherwise users would have to enter passwords in uppercase in order to change them

  // Check existing password matches
  If (EncodeKey (23130, Trim(edtCurrentPword.Text)) = FCurrentPassword) Then
  Begin
    // Old Password OK - Check new password is not the same as old password
    If (Trim(edtCurrentPword.Text) <> Trim(edtNewPword.Text)) Then
    Begin
      // check new password matches confirm password
      If (Trim(edtNewPword.Text) = Trim(edtConfirmPword.Text)) Then
      Begin
        FNewPassword := EncodeKey (23130, Trim(edtNewPword.Text));
        ModalResult := mrOK;
      End // If (Trim(edtNewPword.Text) = Trim(edtConfirmPword.Text))
      Else
      Begin
        MessageDlg ('The Confirmation Password does not match the New Password', mtError, [mbOK], 0);
        edtConfirmPword.Text := '';
        BadCtrl := edtConfirmPword;
      End; // Else
    End // If (Trim(edtCurrentPword.Text) <> Trim(edtNewPword.Text))
    Else
    Begin
      MessageDlg ('The New Password must be different from the Current Password', mtError, [mbOK], 0);
      edtNewPword.Text := '';
      edtConfirmPword.Text := '';
      BadCtrl := edtNewPword;
    End; // Else
  End // If (EncodeKey (23130, edtCurrentPword.Text) = FCurrentPassword)end
  Else
  Begin
    MessageDlg ('The Current Password is not correct', mtError, [mbOK], 0);
    BadCtrl := edtCurrentPword;
    edtCurrentPword.Text := '';
    Inc(FailCount);
  End; // Else

  If (ModalResult <> mrOK) Then
  Begin
    // Automatically close the change password dialog after 3 fails on the old password
    If (FailCount >= 3) Then
      ModalResult := mrCancel
    Else
      If Assigned(BadCtrl) Then
        If BadCtrl.CanFocus Then
          BadCtrl.SetFocus;
  End; // If (ModalResult <> mrOK)
end;

//=========================================================================


end.
