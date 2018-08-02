unit CompOpt;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mask, TEditVal, StdCtrls, Grids, SBSOutl, ExtCtrls, GlobVar, VarConst,
  GlobType, ExWrap1U, Menus, bkgroup, ComCtrls, BorBtns;

type
  TfrmCompOpt = class(TForm)
    SaveBtn: TButton;
    CancelBtn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Configuration: TTabSheet;
    TabSheet2: TTabSheet;
    SBSBackGroup2: TSBSBackGroup;
    Label82: Label8;
    Label83: Label8;
    Label81: Label8;
    Label810: Label8;
    Label811: Label8;
    Label812: Label8;
    Label813: Label8;
    Label814: Label8;
    Label815: Label8;
    coBackup: Text8Pt;
    coRestore: Text8Pt;
    Label84: Label8;
    Label85: Label8;
    Label86: Label8;
    Label87: Label8;
    Label89: Label8;
    Label88: Label8;
    ChngPWordBtn: TButton;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    SBSBackGroup4: TSBSBackGroup;
    SBSBackGroup5: TSBSBackGroup;
    Label817: Label8;
    chkHidePath: TBorCheck;
    chkHideBackup: TBorCheck;
    TabSheet3: TTabSheet;
    Label818: Label8;
    Label823: Label8;
    edtWin95: Text8Pt;
    Label824: Label8;
    edtwinNT: Text8Pt;
    SBSBackGroup1: TSBSBackGroup;
    chkHideUsers: TBorCheck;
    Label816: Label8;
    SBSBackGroup3: TSBSBackGroup;
    chkShowExch: TBorCheck;
    tabshBureau: TTabSheet;
    SBSBackGroup6: TSBSBackGroup;
    chkBureauMode: TBorCheck;
    Label819: Label8;
    Label820: Label8;
    btnChangeBureauPW: TButton;
    chkShowViewCompany: TBorCheck;
    Label821: Label8;
    Label822: Label8;
    Label825: Label8;
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PropFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ChngPWordBtnClick(Sender: TObject);
    procedure btnChangeBureauPWClick(Sender: TObject);
  private
    { Private declarations }
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord,
    ItemChanged  : Boolean;
    LockPos      : LongInt;
    NewPwd       : ShortString;
    NewBureauPwd : ShortString;
    procedure Find_FormCoord;
    procedure SetFormProperties;
    procedure Store_FormCoord(UpMode  :  Boolean);

    // Displays a Change password wizard.  PWMode: 0=MCM Pw, 1=Bureau Admin PW
    procedure ChangePassword (Const PWMode : Byte);
  public
    { Public declarations }
    DispMode : Byte;
    LoggedPW : ShortString;
    SystemUser : Boolean;
    OK       : Boolean;
    Procedure DisplayRec;
    Procedure ShowLink;
  end;

implementation

{$R *.DFM}

Uses BtrvU2, BtSupU1, CmpCtrlU, ColCtrlU, EtStrU, BtSupU2, CompDlg,
     PWordDlg, SecureU, EntLicence;

//-------------------------------------------------------------------------

procedure TfrmCompOpt.FormCreate(Sender: TObject);
Var
  N : Integer;
begin
  OK := False;
  SystemUser := False;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  { Load in the saved coordinates }
  Find_FormCoord;

  // Flag to indicate whether running in LITE installation
  If (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]) Then
  Begin
    // Hide Exchequer For DOS and Bureau options
    TabSheet3.TabVisible := False;
    tabshBureau.TabVisible := FileExists(ExtractFilePAth(Application.ExeName) + 'IAOBureau.Inf');
  End; // If (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct])

  PageControl1.ActivePage := TabSheet1;
end;

//------------------------------

procedure TfrmCompOpt.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
Var
  N : Integer;
begin
  Status:=UnlockMultiSing(F[SysF],SysF,LockPos);

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  Store_FormCoord(Not SetDefault);
end;

//-------------------------------------------------------------------------

// Outputs the Company Options to the form
Procedure TfrmCompOpt.DisplayRec;
Begin
  With Company^, CompOpt Do Begin
    coBackup.Text := OptBackup;
    coRestore.Text := OptRestore;

    NewPwd := OptPWord;

    { HM 15/10/98: Added Path security options }
    chkHidePath.Checked := OptHidePath;
    chkHideBackup.Checked := OptHideBackup;

    { HM 20/04/99: Added command names }
    edtWin95.Text := Trim(OptWin9xCmd);
    edtWinNT.Text := Trim(OptWinNTCmd);

    { HM 21/07/00: Added security on Check For Users option }
    chkHideUsers.Checked := Not OptShowCheckUsr;

    // HM 04/02/03: Added option to hide Exchequer
    chkShowExch.Checked := OptShowExch;

    // HM 04/02/04: Added Bureau flags
    chkBureauMode.Checked := OptBureauModule;
    NewBureauPwd := OptBureauAdminPWord;

    // MH 11/05/07: Added Show View Company flag for v6.00
    chkShowViewCompany.Checked := OptShowViewCompany;
  End; { With }
End;

//-------------------------------------------------------------------------

// Called from the parent form to get and display the data
Procedure TfrmCompOpt.ShowLink;
Var
  Key2F      : Str255;
  OK, Locked : Boolean;
Begin
  { Lock record }
  Status := 0;
  Locked := BOn;
  Key2F := Company^.RecPFix + Company^.CompOpt.OptCode;
  Ok:=GetMultiRec(B_GetEq,B_MultLock,Key2F,CompCodeK,CompF,True,Locked);
  Report_BError(CompF, Status);

  Status:=GetPos(F[CompF],CompF,LockPos);

  If OK And StatusOk And Locked Then Begin
    { display }
    DisplayRec;
  End; { If }
End;

//-------------------------------------------------------------------------

procedure TfrmCompOpt.SaveBtnClick(Sender: TObject);
Var
  KeyS       : Str255;
  ValidError : Boolean;
begin
  ValidError := False;

  With Company^, CompOpt Do Begin
    { Load details into record }
    RecPFix := cmSetup;

    OptCode := CmSetupCode;
    OptBackup := coBackup.Text;
    OptRestore := coRestore.Text;
    OptPWord := NewPwd;

    { HM 15/10/98: Added Path security options }
    OptHidePath   := chkHidePath.Checked;
    OptHideBackup := chkHideBackup.Checked;

    { HM 20/04/99: Added command names }
    OptWin9xCmd := Trim(edtWin95.Text);
    OptWinNTCmd := Trim(edtWinNT.Text);

    { HM 21/07/00: Added security on Check For Users option }
    OptShowCheckUsr := Not chkHideUsers.Checked;

    // HM 04/02/03: Added option to hide Exchequer
    OptShowExch := chkShowExch.Checked;

    // HM 04/02/04: Added Bureau flags
    OptBureauModule := chkBureauMode.Checked;
    If OptBureauModule Then
    Begin
      // Need a Bureau Admin password to be defined
      OptBureauAdminPWord := NewBureauPwd;

      // Ensure the Bureau password is set
      ValidError := (Trim(OptBureauAdminPWord) = '');
      If ValidError Then
      Begin
        // Display Error and make the change password button the active control
        MessageDlg ('The Bureau Administrator Password must be set', mtError, [mbOk], 0);
        PageControl1.ActivePage := tabshBureau;
        If btnChangeBureauPW.CanFocus Then
        Begin
          btnChangeBureauPW.SetFocus;
        End; // If btnChangeBureauPW.CanFocus
      End; // If ValidError
    End // If OptBureauModule
    Else
    Begin
      // Reset Bureau Password - they need to define it when they turn on the Bureau Module
      OptBureauAdminPWord := '';
    End; // Else

    // MH 11/05/07: Added Show View Company flag for v6.00
    OptShowViewCompany := chkShowViewCompany.Checked;
  End; { With }

  If (Not ValidError) Then
  Begin
    { Edit }
    Status:=Put_Rec(F[CompF],CompF,RecPtr[CompF]^,0);

    If StatusOk Then Begin
      { Change password logged in as }
      LoggedPW := NewPwd;
      Ok := True;
    End; { If }

    { Unlock }
    Status:=UnlockMultiSing(F[CompF],CompF,LockPos);

    Report_BError (CompF, Status);

    Close;
  End; // If (Not ValidError)
end;

procedure TfrmCompOpt.CancelBtnClick(Sender: TObject);
begin
  { Check for changes }
  If coBackup.Modified Or coRestore.Modified Then Begin
    If (MessageDlg ('Abandon Changes?', mtConfirmation, [mbYes, mbNo],0) = mrYes) Then
      Close;
  end
  else
    Close;
end;

procedure TfrmCompOpt.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TfrmCompOpt.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TfrmCompOpt.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;

procedure TfrmCompOpt.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TfrmCompOpt.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord := Not StoreCoord;
end;


procedure TfrmCompOpt.SetFormProperties;
Var
  TmpPanel    :  Array[1..3] of TPanel;
  n           :  Byte;
  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;
Begin
  ResetDefaults:=BOff;

  For n:=1 to 3 do Begin
    TmpPanel[n]:=TPanel.Create(Self);
  end;

  try
    TmpPanel[1].Font:=CoBackup.Font;
    TmpPanel[1].Color:=CoBackup.Color;

    TmpPanel[2].Font:=Label81.Font;
    TmpPanel[2].Color:=Label81.Color;

    {
    TmpPanel[3].Color:=BarColor;
    TmpPanel[3].Font.Assign(TmpPanel[1].Font);
    TmpPanel[3].Font.Color:=BarTextColor;
    }

    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],0,'Options Properties',BeenChange,ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then Begin
          Label81.Font.Assign(TmpPanel[2].Font);
          Label82.Font.Assign(Label81.Font);
          Label83.Font.Assign(Label81.Font);

          CoBackup.Color := TmpPanel[1].Color;
          CoBackup.Font.Assign(TmpPanel[1].Font);
          CoRestore.Color := CoBackup.Color;
          CoRestore.Font.Assign(CoBackup.Font);
        end;
      end;
    finally
      ColourCtrl.Free;
    end;
  Finally
    For n:=1 to 3 do
      TmpPanel[n].Free;
  End;

  If (ResetDefaults) then Begin
    SetDefault:=BOn;
    Close;
  end;
end;

procedure TfrmCompOpt.Find_FormCoord;
Var
  ThisForm:  TForm;
  VisibleRect:  TRect;
  GlobComp:  TGlobCompRec;
  I        : Integer;
Begin
  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do Begin
    GetValues:=BOn;

    PrimeKey:='S';

    If (GetbtControlCsm(ThisForm)) then Begin
      StoreCoord:=(ColOrd=1);
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);
    end;

    If GetbtControlCsm(Label81) then Begin
      Label82.Font.Assign(Label81.Font);
      Label82.Color:=Label81.Color;
      Label83.Font.Assign(Label81.Font);
      Label83.Color:=Label81.Color;
    End; { If }

    If GetbtControlCsm(coBackup) then Begin
      coRestore.Color := coBackup.Color;
      coRestore.Font.Assign(coBackup.Font);
    End; { If }
  End; { With }
end;

procedure TfrmCompOpt.Store_FormCoord(UpMode  :  Boolean);
Var
  GlobComp : TGlobCompRec;
  I        : Integer;
Begin
  New(GlobComp,Create(BOff));

  With GlobComp^ do Begin
    GetValues:=UpMode;

    PrimeKey:='S';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(Label81);
    StorebtControlCsm(coBackup);
  end; {With GlobComp..}

  GlobComp.Destroy;
end;

//-------------------------------------------------------------------------

procedure TfrmCompOpt.ChngPWordBtnClick(Sender: TObject);
Begin
  ChangePassword (0);
End;

//------------------------------

procedure TfrmCompOpt.btnChangeBureauPWClick(Sender: TObject);
begin
  ChangePassword (1);
end;

//------------------------------

// Displays a Change password wizard.  PWMode: 0=MCM Pw, 1=Bureau Admin PW
procedure TfrmCompOpt.ChangePassword (Const PWMode : Byte);
Var
  PasswordDialog     : TPasswordDialog;
  ExistingPW, TmpPwd : ShortString;
  State              : Byte;
  OK                 : Boolean;
begin
  PasswordDialog := TPasswordDialog.Create(Self);
  Try
    //PasswordDialog.Caption := 'Change Password';
    OK := True;
    State := 1;

    Case PWMode Of
      0 : ExistingPw := LoggedPW;        // Force them to enter the password they used to get to this screen
      1 : If SystemUser Then
          Begin
            ExistingPw := '';            // System User - don't ask for current password as they've problably forgotten it
          End // If SystemUser
          Else
          Begin
            ExistingPw := NewBureauPwd;    // Force them to enter the last Bureau PW
          End; // Else
    End; // Case PWMode

    Repeat
      Case State Of
        { Get Existing Password }
        1 : If (ExistingPw <> '') Then
            Begin
              { Get Existing Password - check against ExistingPw }
              PasswordDialog.Title := 'Current Password';
              PasswordDialog.Msg := 'Enter the current password to continue';
              OK := PasswordDialog.Execute;

              If OK Then
              Begin
                // Check got correct password
                If (PasswordDialog.PassWord = ExistingPw) Then
                Begin
                  // Correct Password - move to next stage
                  Inc (State);
                End // If (PasswordDialog.PassWord = ExistingPw)
                Else
                Begin
                  // invalid password - stay on this stage
                  MessageDlg ('The current password was entered incorrectly', mtWarning, [mbOk], 0)
                End; // Else
              End; // If OK
            End // If (ExistingPw <> '')
            Else
              Inc (State);

        { Get new password }
        2 : Begin
              PasswordDialog.Title := 'Enter New Password';
              PasswordDialog.Msg := 'Enter the new password';
              Ok := PasswordDialog.Execute;

              If Ok Then
              Begin
                // Check the new admin pw isn't blank (blank allowed for MCM password)
                If (PasswordDialog.PassWord <> '') Or (PWMode = 0) Then
                Begin
                  TmpPwd := PasswordDialog.PassWord;
                  Inc (State);
                End // If (PasswordDialog.PassWord <> '') Or (mode = 0)
                Else
                Begin
                  MessageDlg ('The Bureau Admin Password cannot be left blank', mtError, [mbOk], 0);
                End;
              End // If Ok
              Else
              Begin
                { Dialog Cancelled }
                MessageDlg ('Password not changed', mtInformation, [mbOk], 0);
              End; // Else
            End;

        { get new password again }
        3 : Begin
              PasswordDialog.Title := 'Confirm Password';
              PasswordDialog.Msg := 'Re-enter the new password';
              Ok := PasswordDialog.Execute;

              If OK Then
              Begin
                 If (PasswordDialog.PassWord = TmpPwd) Then
                 Begin
                   { Password was retyped correctly }

                   { Set new password }
                   Case PWMode Of
                     // MCM Password
                     0 : Begin
                           NewPwd := PasswordDialog.Password;
                           LoggedPW := NewPwd;
                         End;
                     // Bureau Password
                     1 : NewBureauPwd := PasswordDialog.Password;
                   End; // Case PWMode
                   Inc (State);
                 End // If (PasswordDialog.PassWord = TmpPwd)
                 Else
                 Begin
                   { Password was NOT retyped correctly }
                   State := 2;
                   MessageDlg ('The new password was not re-entered correctly', mtWarning, [mbOk], 0);
                 End; // Else
              End; // If OK
            End;
      End; { Case }

    Until (Not OK) Or (State = 4);
  Finally
    FreeAndNIL(PasswordDialog);
  End; { Try }
end;

//-------------------------------------------------------------------------

end.
