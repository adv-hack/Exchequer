unit Main;

{ nfrewer440 10:19 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus, ClntUser, 
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, FaxStat, BTSupU1, FaxClass, APIUtil, UFaxBtrv
  ,IniFiles, FaxUtils, ViewMain, Password, VarConst, Crypto, UserList;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    StatusBar: TStatusBar;
    ActionList1: TActionList;
    FileExit1: TAction;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowArrangeAll1: TWindowArrange;
    WindowMinimizeAll1: TWindowMinimizeAll;
    HelpAbout1: TAction;
    WindowTileVertical1: TWindowTileVertical;
    WindowTileItem2: TMenuItem;
    ImageList1: TImageList;
    Filter1: TMenuItem;
    AllUsers1: TMenuItem;
    N3: TMenuItem;
    ListFiles1: TAction;
    ListFiles2: TMenuItem;
    AdministratorLogin1: TMenuItem;
    EditUserList1: TMenuItem;
    Administrator1: TMenuItem;
    ClientLoginList1: TMenuItem;
    N2: TMenuItem;
    Contents1: TMenuItem;
    HowTo1: TMenuItem;
    SearchforHelpon1: TMenuItem;
    N4: TMenuItem;
    HowtouseHelp1: TMenuItem;
    Troubleshooting1: TMenuItem;
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure MenuUserClick(Sender: TObject);
    procedure ListFiles1Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AdministratorLogin1Click(Sender: TObject);
    procedure EditUserList1Click(Sender: TObject);
    procedure ClientLoginList1Click(Sender: TObject);
    procedure Contents1Click(Sender: TObject);
    procedure SearchforHelpon1Click(Sender: TObject);
    procedure HowtouseHelp1Click(Sender: TObject);
    procedure HowTo1Click(Sender: TObject);
    procedure Troubleshooting1Click(Sender: TObject);
  private
    frmFaxStatus: TfrmFaxStatus;
    procedure ReadUsersFromIniFile;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure WMFormStateMsg(var Message  :  TMessage); Message WM_FormStateMsg;
    procedure WMFormCloseMsg(var Message  :  TMessage); Message WM_FormCloseMsg;
    procedure AppActivate(Sender: TObject);
  public
  end;

var
  frmMain: TfrmMain;
  function Login : boolean;
  function OpenBT : boolean;
  function CheckParams : boolean;

implementation

{$R *.DFM}
{$R ZOOMCUR.RES}  // Magnifying Glass Cursor.

uses About;

procedure TfrmMain.HelpAbout1Execute(Sender: TObject);
var
  FrmAbout : TFrmAbout;
begin
  FrmAbout := TFrmAbout.Create(Self);
  try
    FrmAbout.ShowModal;
  finally
    FrmAbout.Release;
  end;{try}
end;

procedure TfrmMain.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.WMFormStateMsg(var Message : TMessage);
begin
  case Message.WParam of
    SC_RESTORE : Application.Restore;
    SC_MINIMIZE : Application.Minimize;
    SC_MAXIMIZE : WindowState := wsMaximized;
  end;{case}
end;

procedure TfrmMain.WMFormCloseMsg(var Message  : TMessage);
begin
  case Message.WParam of
    1 : begin
      frmFaxStatus := nil;
      ListFiles2.Enabled := TRUE;
    end;
  end;{case}
end;

procedure TfrmMain.ReadUsersFromIniFile;
var
  UserMenuItem : TMenuItem;
  IniFileName : string;
  slUsers : TStringList;
  iPos : integer;
begin

  {delete users from menu}
  iPos := 0;
  while iPos < Filter1.Count do begin
    if (Filter1.Items[iPos].Tag = 0) and (Filter1.Caption <> '-') then begin
      Filter1.Delete(iPos);
      iPos := -1;
    end;{if}
    inc(iPos);
  end;{while}

  {add users from ini file}
  if SetIniFileName(IniFileName) then begin
    with TIniFile.Create(IniFileName) do begin
      try
        slUsers := TStringList.Create;
        ReadSections(slUsers);
        slUsers.Sorted := TRUE;
        for iPos := 0 to slUsers.Count - 1 do begin
          UserMenuItem := TMenuItem.Create(Filter1);
          with UserMenuItem do begin
            Caption := slUsers[iPos];
            OnClick := MenuUserClick;
            RadioItem := TRUE;
          end;{with}
          Filter1.Add(UserMenuItem);
        end;{for}
        slUsers.Free;
  {      StrPCopy(FaxFrom, copy(ReadString(UserName, SENDER_NAME, ''), 1, 80));
        StrPCopy(SenderEmail, copy(ReadString(UserName, SENDER_EMAIL, ''), 1, 100));}
      finally
        Free;
      end;{try}
    end;{with}
  end;{if}

{  Filter1.Items[0].Checked := TRUE;}
  MenuUserClick(Filter1.Items[0]);
end;

procedure TfrmMain.MenuUserClick(Sender: TObject);
begin
  sFilter := TMenuItem(Sender).Caption;
  TMenuItem(Sender).Checked := TRUE;
  if frmFaxStatus <> nil then frmFaxStatus.RefreshListView;
end;

procedure TfrmMain.ListFiles1Execute(Sender: TObject);
begin
  if frmFaxStatus = nil then frmFaxStatus := TfrmFaxStatus.Create(Self);
  ListFiles2.Enabled := FALSE;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  ListFiles1Execute(Self);
  BringWindowToTop(Handle);
end;

procedure TfrmMain.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 300;
    ptMinTrackSize.Y := 200;
  end;{with}
  Message.Result := 0;
  inherited;
end;

function Login : boolean;
var
  Params : PFaxParams;
  iStatus : integer;
  iTries : Byte;
begin
  Result := TRUE;
  frmPassword := TfrmPassword.Create(Application);
  try
    with frmPassword do begin
      lPlease.Caption := 'Please enter the administrator password to gain access to the Fax Administrator';
      lPlease.Height := 49;
      lPlease.Width := 177;
      iTries := 0;
      while (iTries < 3) do begin
        edPassword.Text := '';
        ActiveControl := edPassword;
        if ShowModal = mrOK then
          begin
            try
              new(Params);
              iStatus := ReadFaxParams(Params);
              with Params^ do begin
                if ((iStatus = 0) and (UpperCase(edPassword.Text) = Decode(FaxSystemPass)))
                or ((iStatus = 0) and (UpperCase(edPassword.Text) = Decode(FaxAdminPass)))
                or (iStatus = 4)
                then
                  begin
                    iTries := 3;
                    Result := TRUE;
                  end
                else begin
                  MsgBox('The password you have supplied is incorrect.'
                  ,mtconfirmation,[mbOK],mbOK,'Incorrect Password');
                  Result := FALSE;
                end;{if}
              end;{with}
            finally
              dispose(Params);
            end;{try}
          end
        else begin
          Result := FALSE;
          iTries := 3;
        end;{if}
        inc(iTries);
      end;{while}
    end;{with}
  finally
    frmPassword.Release;
  end;{try}
end;

function OpenBT : boolean;
var
  iStatus : integer;
begin
  Result := OpenFaxFile(true);
  if Result then begin
    new(fCurFaxParams);
    iStatus := ReadFaxParams(fCurFaxParams);
    if iStatus = 4 then
      begin // Parameters record missing
        MsgBox('The fax server parameters are missing and need to be initialised.'
        + CRLF + 'Please contact your administrator.', mtWarning, [mbOK], mbOK, 'Fax Parameters');
        Result := FALSE;
      end
    else begin
      if iStatus <> 0 then ShowBtrieveError('An error occurred in reading the fax server parameters',iStatus);
    end;{if}
  end;{if}
end;

function CheckParams : boolean;
var
  i : integer;
begin
  Result := false;
  AppMode := amUser;
  sFilter := WinGetUserName;

  for i := 1 to ParamCount do begin
    if UpperCase(ParamStr(i)) = '/CREATE' then begin
      Result := true;
      MakeFaxFile;
      Application.Terminate;
    end;{if}

    if UpperCase(ParamStr(i)) = '/ADMIN' then begin
      AppMode := amAdmin;
    end;{if}
  end;{for}
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Administrator1.Enabled := AppMode = amAdmin;
  AdministratorLogin1.Enabled := AppMode = amUser;
  if AppMode = amAdmin then
    begin
      sFilter := 'All Users';
      ReadUsersFromIniFile;
    end
  else SetWindowLong(Handle, GWL_USERDATA, 2323);
  Application.OnActivate := AppActivate;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  CloseFaxFile;
end;

procedure TfrmMain.AdministratorLogin1Click(Sender: TObject);
begin
 if Login then begin
   AppMode := amAdmin;
   FormCreate(Self);
   if frmFaxStatus <> nil then frmFaxStatus.RefreshListView;
{   frmFaxStatus.tvwFaxDirs.Selected := frmFaxStatus.tvwFaxDirs.Items[0];}
 end;{if}
end;

procedure TfrmMain.EditUserList1Click(Sender: TObject);
var
  frmUserList : TfrmUserList;
begin
  try
    frmUserList := TfrmUserList.Create(Self);
    frmUserList.ShowModal;
  finally
    frmUserList.Release;
  end;{finally}
  ReadUsersFromIniFile;
end;

procedure TfrmMain.AppActivate(Sender: TObject);
begin
  if frmFaxStatus <> nil then frmFaxStatus.RefreshListView;
end;

procedure TfrmMain.ClientLoginList1Click(Sender: TObject);
var
  frmClientLoginList : TfrmClientLoginList;
begin
  try
    frmClientLoginList := TfrmClientLoginList.Create(Self);
    frmClientLoginList.ShowModal;
  finally
    frmClientLoginList.Release;
  end;{finally}
end;

procedure TfrmMain.Contents1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_Finder,0);
end;

procedure TfrmMain.SearchforHelpon1Click(Sender: TObject);
const
  EmptyString: PChar = '';
begin
  Application.HelpCommand(HELP_PARTIALKEY, Longint(EmptyString));
end;

procedure TfrmMain.HowtouseHelp1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_HELPONHELP, 0);
end;

procedure TfrmMain.HowTo1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,1000);
end;

procedure TfrmMain.Troubleshooting1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,1001);
end;

initialization

  SetBtrieveLocation;
  if OpenBT then
    begin
      ChangeCryptoKey(19672);
      if CheckParams then Halt;

      if (AppMode = amUser) and IsAppAlreadyRunning('UserFaxAdmin') then Halt;

      if (AppMode = amAdmin) and (not Login) then Halt;
      Screen.Cursors[22] := loadcursor(HInstance, 'zoomcur');
    end
  else Halt;

finalization
  if fCurFaxParams <> nil then dispose(fCurFaxParams);

end.
