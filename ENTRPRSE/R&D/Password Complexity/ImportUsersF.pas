unit ImportUsersF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, oUserList, oUserIntf, StrUtils, PasswordComplexityConst,
  PasswordUtil, oSystemSetup, GenWarnU, GlobVar;

type
  TfrmImportUsers = class(TForm)
    lblCSVFile: TLabel;
    edtImportFilename: TEdit;
    btnBrowseFile: TButton;
    rbCreateUsersWithAccYes: TRadioButton;
    rbCreateUsersWithAccNo: TRadioButton;
    rbCopyUser: TRadioButton;
    cmbUserNameList: TComboBox;
    btnImport: TButton;
    btnCancel: TButton;
    lblCaption: TLabel;
    lblCreateUserDetail: TLabel;
    rbUpdateUser: TRadioButton;
    cbEmailUser: TCheckBox;
    lblAppended: TLabel;
    lblCsvFileFormatInfo: TLabel;
    OpenDialog: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnBrowseFileClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnImportClick(Sender: TObject);
    procedure lblCsvFileFormatInfoClick(Sender: TObject);
  private
    FUserListIntf: IUserDetailList;
    FImportedUserList: TStringList;
    procedure InitCbUserNameList;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

//------------------------------------------------------------------------------

procedure TfrmImportUsers.FormCreate(Sender: TObject);
var
  lAuthMode: String;
begin
  FUserListIntf := UserDetailList(True);
  FImportedUserList := TStringList.Create;
  //Initial directory set to installation directory
  OpenDialog.InitialDir := SetDrive;
  InitCbUserNameList;

  //HV 02/04/2018 2018-R1 ABSEXCH-20362: Import users offers option to email passwords to users when Windows Authentication is selected for company
  lAuthMode := Trim(SystemSetup(True).PasswordAuthentication.AuthenticationMode);
  cbEmailUser.Enabled := lAuthMode = AuthMode_Exchequer;
  if not cbEmailUser.Enabled then
    lblAppended.Font.Color := clGray;
end;

//------------------------------------------------------------------------------
//Populate ComboBox with UserNames
procedure TfrmImportUsers.InitCbUserNameList;
var
  I: Integer;
begin
  for I := 0 to FUserListIntf.Count - 1 do
    cmbUserNameList.Items.Add(FUserListIntf[I].udUserName);
end;

//------------------------------------------------------------------------------

procedure TfrmImportUsers.btnBrowseFileClick(Sender: TObject);
var
  lErrorList,
  lTempList: TStringList;
  lResult: Boolean;
  lFileName: String;

  //-------------------------------------------------------------
  function ValidateCSV(aUserList: TStringList): Boolean;
  begin
    ExtractStrings([','], [#0], PChar(Trim(aUserList[0])), lTempList);
    //Check for invalid format
    Result :=  (lTempList.Count = 4) and
               (Trim(UpperCase(lTempList[0])) = csvColUserName) and
               (Trim(UpperCase(lTempList[1])) = csvColFullName) and
               (Trim(UpperCase(lTempList[2])) = csvColWinUserId) and
               (Trim(UpperCase(lTempList[3])) = csvColEmailAddr);
    if Not Result then
      MessageDlg(csvInvalidFormatMsg, mtError, [mbOk, mbHelp], csvHelpContext);
  end;
  //-------------------------------------------------------------

begin
  lTempList := TStringList.Create;
  lErrorList := TStringList.Create;
  lResult := True;
  try
    if OpenDialog.Execute then
    begin
      lFileName := OpenDialog.FileName;
      edtImportFilename.Text := lFileName;
      try
        FImportedUserList.LoadFromFile(lFileName);
        edtImportFilename.Text := lFileName;
      except
        on E : Exception do
        begin
          lResult := False;
          edtImportFilename.Text := EmptyStr;
          lErrorList.Add(Format(errFileAlreadyOpened,[lFileName]));
        end;
      end;
    end;
    
    //if user did not opened file
    if (lResult) and (lFileName = EmptyStr) then Exit;

    if (lResult) then
      lResult := ValidateCSV(FImportedUserList);
      
    if (lResult) and (FImportedUserList.Count < 2) then
    begin
      lResult := False;
      lErrorList.Add(errNoRecordsFound);
    end;

    btnImport.Enabled := lResult;
    
    //Show every errors
    if (lErrorList.Count > 0) then
      MessageDlg(lErrorList.Text, mtError, [mbOk], 0)
    else if lResult then   //Everything went well so enable Import button
      btnImport.Enabled := True;

  finally
    FreeAndNil(lErrorList);
    FreeAndNil(lTempList);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmImportUsers.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FreeAndNil(FImportedUserList);
  FUserListIntf := nil;
  Action := caFree;
end;

//------------------------------------------------------------------------------

procedure TfrmImportUsers.btnImportClick(Sender: TObject);
var
  i, lRes: Integer;
  lUserDetail,
  lCopyUserDetail: IUserDetails;
  lSkippedCount,
  lUpdateCount,
  lAddCount: Integer;
  lTempList,
  lCountList: TStringList;

  //-------------------------------------------------------------
  function ReplaceSpace(aStringWithSpace: String): String;
  begin
    Result := AnsiReplaceText(aStringWithSpace, ' ', cSpaceReplaceChar);
  end;

  function ReplaceSpecChar(aStringWithSpecChar: String): String;
  begin
    Result := AnsiReplaceText(aStringWithSpecChar, cSpaceReplaceChar, ' ');
  end;
  //-------------------------------------------------------------
  procedure SetValues;
  begin
    if lUserDetail.udMode In [umInsert, umCopy] then
    begin
      lUserDetail.udUserName := ReplaceSpecChar(lTempList[0]);
      //set access settings?
      if not rbCopyUser.Checked then
        lUserDetail.SetAccessSettingsYes(rbCreateUsersWithAccYes.Checked);
    end;
    lUserDetail.udFullName := ReplaceSpecChar(lTempList[1]);
    lUserDetail.udWindowUserId := ReplaceSpecChar(lTempList[2]);
    lUserDetail.udEmailAddr := ReplaceSpecChar(lTempList[3]);
    if lUserDetail.udPwdSalt = EmptyStr then
      lUserDetail.udPwdSalt := GenerateRandomPwdSalt;
  end;
  //-------------------------------------------------------------
begin
  lSkippedCount := 0;
  lUpdateCount := 0;
  lAddCount := 0;

  lTempList := TStringList.Create;
  lCountList := TStringList.Create;

  Screen.Cursor := crHourGlass;
  try
    for i := 1 to FImportedUserList.Count - 1 do
    begin
      //Check for any empty username and skip
      if AnsiStartsText(',', FImportedUserList[i]) then
      begin
        Inc(lSkippedCount);    
        Continue;
      end;
      lTempList.DelimitedText := ReplaceSpace(FImportedUserList[i]);

      {Update User}
      if rbUpdateUser.Checked then
      begin
        lUserDetail := FUserListIntf.FindUserByUserName(ReplaceSpecChar(lTempList[0]));
        if Assigned(lUserDetail) then
          lUserDetail := lUserDetail.EditUser;
      end
      {Add User}
      else if rbCreateUsersWithAccYes.Checked or rbCreateUsersWithAccNo.Checked then
      begin
        lUserDetail := FUserListIntf.AddUser;
      end
      {Copy User}
      else if rbCopyUser.Checked then
      begin
        if (cmbUserNameList.ItemIndex <> -1 ) then
        begin
          lCopyUserDetail := FUserListIntf.FindUserByUserName(Trim(cmbUserNameList.Text));
          if Assigned(lCopyUserDetail) then
          begin
            lCopyUserDetail := lCopyUserDetail.EditUser;
            if Assigned(lCopyUserDetail) then
              lUserDetail := FUserListIntf.CopyUser(lCopyUserDetail);
          end;
        end;
      end;

      if Assigned(lUserDetail) then
      begin
        SetValues;
        lRes := lUserDetail.Validate(Self, [udfUserName, udfWindowUserId, udfEmailAddr]);
        if lRes = 0 then
        begin
          if lUserDetail.Save = 0 then
          begin
            if lUserDetail.udMode = umUpdate then
              Inc(lUpdateCount);    
            if lUserDetail.udMode In [umInsert, umCopy] then
            begin
              Inc(lAddCount);
              if cbEmailUser.Checked then
              begin
                if (SystemSetup(True).PasswordAuthentication.AuthenticationMode = AuthMode_Exchequer) then
                  lUserDetail.ResetPassword(cbEmailUser.Checked, True, MsgTypeSendPwdExchq)
                else 
                  lUserDetail.ResetPassword(cbEmailUser.Checked, True, MsgTypeSendPwdWin);
              end;
            end;
          end;
        end
        else
          Inc(lSkippedCount)
      end
      else
        Inc(lSkippedCount);
      Application.ProcessMessages;
    end;
    SendMessage((Owner as TForm).Handle, WM_REFRESH, 0, 1); // Refresh User Managment List
    lCountList.Add(#13 + Format(strUserAdded, [IntToStr(lAddCount)]) + #13);
    lCountList.Add(Format(strUserUpdated, [IntToStr(lUpdateCount)]) + #13);
    lCountList.Add(Format(strUserSkipped, [IntToStr(lSkippedCount)]) + #13);
    CustomDlg(Application.MainForm, 'Summary Information', '', lCountList.Text, mtInformation, [mbOk]);
  finally
    Screen.Cursor := crDefault;
    FreeAndNil(lCountList);
    FreeAndNil(lTempList);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmImportUsers.lblCsvFileFormatInfoClick(Sender: TObject);
begin
  //SSK 29/03/2018 2018-R1 ABSEXCH-20324: this will bring up same context help as the screen itself
  Application.HelpCommand(HELP_CONTEXT, lblCsvFileFormatInfo.HelpContext);
end;

end.
