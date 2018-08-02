unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , APIUtil, BespokeFuncsInterface, Dialogs, StdCtrls, ExtCtrls, SpecialPassword
  , SQLLogin, MiscUtil, Login, Menus, StrUtil, uMultiList, BespokeXML, ComCtrls
  , AdminPRoc, SQLUtils, uMessages;

const
  sVersionNo = 'v6.20.004';
  iKey = 26;

type
  TSQLDetails = Record
    ROUsername : ANSIString;
    ROPassword : ANSIString;
    ROLoginStatus : integer;
    RWUsername : ANSIString;
    RWPassword : ANSIString;
    RWLoginStatus : integer;
  end;

  TfrmBespokeSQLAdmin = class(TForm)
    btnClose: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Login1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    pcTabs: TPageControl;
    tsExchequer: TTabSheet;
    tsReadOnly: TTabSheet;
    tsDatabases: TTabSheet;
    bvIRISExchequer: TBevel;
    lExchSQLDBNameTit: TLabel;
    lExchSQLDBName: TLabel;
    lExchSQLServerNameTit: TLabel;
    lExchSQLServerName: TLabel;
    lIRISExchequer: TLabel;
    Bevel2: TBevel;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    edROUserName: TEdit;
    edROPassword: TEdit;
    btnSaveROUser: TButton;
    btnSaveROPassword: TButton;
    Bevel3: TBevel;
    Label9: TLabel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    mlDatabases: TMultiList;
    btnGetConnectionString: TButton;
    lROUserDatabases: TLabel;
    Label13: TLabel;
    lROLoginStatus: TLabel;
    btnROCreateAll: TButton;
    btnCreateROLogin: TButton;
    tsReadWrite: TTabSheet;
    Label6: TLabel;
    Label8: TLabel;
    Label15: TLabel;
    lRWUserDatabases: TLabel;
    lRWLoginStatus: TLabel;
    edRWPassword: TEdit;
    edRWUserName: TEdit;
    btnSaveRWUser: TButton;
    btnSaveRWPassword: TButton;
    btnCreateRWLogin: TButton;
    Bevel4: TBevel;
    Label17: TLabel;
    lbROUserDatabases: TListBox;
    lbRWUserDatabases: TListBox;
    btnRWCreateAll: TButton;
    btnTables: TButton;
    ResetXMLFile1: TMenuItem;
    Label1: TLabel;
    lExchDBType: TLabel;
    Bevel1: TBevel;
    btnView: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveROUserClick(Sender: TObject);
    procedure btnSaveRWUserClick(Sender: TObject);
    procedure btnSaveROPasswordClick(Sender: TObject);
    procedure btnSaveRWPasswordClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Login1Click(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mlDatabasesRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnGetConnectionStringClick(Sender: TObject);
    procedure btnTablesClick(Sender: TObject);
    procedure btnCreateROLoginClick(Sender: TObject);
    procedure btnCreateRWLoginClick(Sender: TObject);
    procedure btnROCreateAllClick(Sender: TObject);
    procedure btnRWCreateAllClick(Sender: TObject);
    procedure mlDatabasesCellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure ResetXMLFile1Click(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    bFirstTimeIn : boolean;
    {ROLoginDetails,} AdminLoginDetails : TSQLLoginDetails;
    SQLDetails : TSQLDetails;
    asExchSQLDBName, asExchSQLServerName : ANSIString;
    function GetLoginStatus(asLoginName : ANSIString; frmMessages : TfrmMessages) : integer;
    procedure EnableDisable;
    procedure Add2UserDatabaseList(bReadOnly : boolean; asDatabaseName : ANSIString; frmMessages : TfrmMessages);
    procedure CreateLogin(bReadOnly : WordBool; SQLLoginDetails : TSQLLoginDetails; bReadLogin : boolean; frmMessages : TfrmMessages);
    procedure CreateUsers(bReadOnly : WordBool; SQLLoginDetails : TSQLLoginDetails; frmMessages : TfrmMessages);
    function GetBespokeDatabaseNames(frmMessages : TfrmMessages) : boolean;
  public
    bSQLExch : boolean;
  end;

var
  frmBespokeSQLAdmin: TfrmBespokeSQLAdmin;

implementation

uses DatabaseDetails, Tables;

{$R *.dfm}

procedure TfrmBespokeSQLAdmin.FormCreate(Sender: TObject);
var
  frmMessages : TfrmMessages;
  bHalt : boolean;

  function GetAdminLogin : boolean;
  begin{GetAdminLogin}
    MsgBox('In order to create the necessary SQL Users and Permissions,'#13
    + 'you will need to login to the SQL Server as an Administrator.'
    , mtInformation, [mbOK], mbOK, 'Create Users / Permissions');
    Result := GetSQLLoginDetails(AdminLoginDetails);
  end;{GetAdminLogin}

  function GetExchDatabaseProperties : boolean;
  var
    iResult : integer;
    pDatabaseName, pServerName : pChar;
//    asDatabaseName : ANSIString;
  begin{GetExchDatabaseProperties}
    // initialise
    pDatabaseName := StrAlloc(255);
    pServerName := StrAlloc(255);

    iResult := SQLGetExchequerDatabaseProperties(pDatabaseName, pServerName); // call DLL Function
    if iResult = 0 then
    begin
      asExchSQLDBName := pDatabaseName;
      asExchSQLServerName := pServerName;
    end
    else
    begin
      MsgBox('An error occurred when calling SQLGetExchequerDatabaseProperties :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLGetExchequerDatabaseProperties Error');
      asExchSQLDBName := SQLStatusDescs[SQL_ERROR];
      asExchSQLServerName := SQLStatusDescs[SQL_ERROR];
    end;{if}
    lExchSQLDBName.Caption := asExchSQLDBName;
    lExchSQLServerName.Caption := asExchSQLServerName;
    Result := iResult = 0;

//    asDatabaseName := pDatabaseName;

    // clear up
    StrDispose(pDatabaseName);
    StrDispose(pServerName);
  end;{GetExchDatabaseProperties}

  procedure GetUserNamesAndPasswords;
  var
    pUserName, pSpecialPassword, pUserPassword : PChar;
    iResult : integer;
  begin{GetUserNamesAndPasswords}
    pUserName := StrAlloc(255);
    pUserPassword := StrAlloc(255);
    pSpecialPassword := StrAlloc(255);

    StrPCopy(pSpecialPassword, GetPassword{(iKey)});

    // Get Read Only User Name from XML File
    iResult := SQLGetUsername(pUserName, TRUE, pSpecialPassword); // call DLL Function
    if iResult = 0 then
    begin
      if Assigned(frmMessages) then frmMessages.AddLine('Successfully retrieved Read Only user name from XML');
      edROUserName.Text := pUserName;
      SQLDetails.ROUsername := edROUserName.Text;
    end
    else
    begin
      if iResult = -4 then // Not Defined in XML File.
      begin
        bFirstTimeIn := TRUE;
        if not GetAdminLogin then
        begin
          if Assigned(frmMessages) then
          begin
            frmMessages.Hide;
            frmMessages.Release;
            frmMessages := nil;
          end;{if}
          bHalt := TRUE;
        end
        else
        begin
          // Add Read Only User with Default Values into XML File
          iResult := SQLAddDefaultUser(TRUE, pSpecialPassword); // call DLL Function
          if iResult = 0 then
          begin
            if Assigned(frmMessages) then frmMessages.AddLine('Successfully added default Read Only user to XML');
            // Get Read Only User Name from XML File
            iResult := SQLGetUsername(pUserName, TRUE, pSpecialPassword); // call DLL Function
            if iResult = 0 then
            begin
              if Assigned(frmMessages) then frmMessages.AddLine('Successfully retrieved Read Only user name from XML');
              edROUserName.Text := pUserName;
              SQLDetails.ROUsername := edROUserName.Text;
            end
            else
            begin
              if Assigned(frmMessages) then frmMessages.AddLine('An error occurred when calling SQLGetUsername (Read Only). Error : ' + IntToStr(iResult), mmtError);
              MsgBox('An error occurred when calling SQLGetUsername (Read Only).'#13#13'Error : '
              + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLGetUsername Error #2');
              edROUserName.Text := IntToStr(iResult);
            end;{if}
          end
          else
          begin
            if Assigned(frmMessages) then frmMessages.AddLine('An error occurred when calling SQLAddDefaultUser (Read Only). Error : ' + IntToStr(iResult), mmtError);
            MsgBox('An error occurred when calling SQLAddDefaultUser (Read Only).'#13#13'Error : '
            + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLAddDefaultUser Error');
            edROUserName.Text := IntToStr(iResult);
          end;{if}
        end;{if}
      end
      else
      begin
        if Assigned(frmMessages) then frmMessages.AddLine('An error occurred when calling SQLGetUsername (Read Only). Error : ' + IntToStr(iResult), mmtError);
        MsgBox('An error occurred when calling SQLGetUsername (Read Only).'#13#13'Error : '
        + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLGetUsername Error');
        edROUserName.Text := IntToStr(iResult);
      end;{if}
    end;{if}

    if not bHalt then
    begin
      ColourControlForErrors(edROUserName, iResult <> 0);

      // Get Read Write User Name
      iResult := SQLGetUsername(pUserName, FALSE, pSpecialPassword); // call DLL Function
      if iResult = 0 then
      begin
        if Assigned(frmMessages) then frmMessages.AddLine('Successfully retrieved Read/Write user name from XML');
        edRWUserName.Text := pUserName;
        SQLDetails.RWUsername := edRWUserName.Text;
      end
      else
      begin
        if iResult = -4 then // Not Defined in XML File.
        begin
          // Add Read Write User with Default Values
          iResult := SQLAddDefaultUser(FALSE, pSpecialPassword); // call DLL Function
          if iResult = 0 then
          begin
            if Assigned(frmMessages) then frmMessages.AddLine('Successfully added default Read/Write user to XML');

            // Get Read Write User Name
            iResult := SQLGetUsername(pUserName, FALSE, pSpecialPassword); // call DLL Function
            if iResult = 0 then
            begin
              if Assigned(frmMessages) then frmMessages.AddLine('Successfully retrieved Read/Write user name from XML');
              edRWUserName.Text := pUserName;
              SQLDetails.RWUsername := edRWUserName.Text;
            end
            else
            begin
              if Assigned(frmMessages) then frmMessages.AddLine('An error occurred when calling SQLGetUsername (Read/Write). Error : ' + IntToStr(iResult), mmtError);
              MsgBox('An error occurred when calling SQLGetUsername :'#13#13'Error : '
              + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLGetUsername Error #4');
              edROUserName.Text := IntToStr(iResult);
            end;{if}
          end
          else
          begin
            if Assigned(frmMessages) then frmMessages.AddLine('An error occurred when calling SQLAddDefaultUser (Read/Write). Error : ' + IntToStr(iResult), mmtError);
            MsgBox('An error occurred when calling SQLAddDefaultUser :'#13#13'Error : '
            + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLAddDefaultUser Error #2');
            edROUserName.Text := IntToStr(iResult);
          end;{if}
        end
        else
        begin
          if Assigned(frmMessages) then frmMessages.AddLine('An error occurred when calling SQLGetUsername (Read/Write). Error : ' + IntToStr(iResult), mmtError);
          MsgBox('An error occurred when calling SQLGetUsername :'#13#13'Error : '
          + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLGetUsername Error #3');
          edRWUserName.Text := IntToStr(iResult);
        end;{if}
      end;{if}
      ColourControlForErrors(edRWUserName, iResult <> 0);

      // Get Read Only Password
      iResult := SQLGetUserPassword(pUserPassword, TRUE, pSpecialPassword); // call DLL Function
      if iResult = 0 then
      begin
        if Assigned(frmMessages) then frmMessages.AddLine('Successfully retrieved password for Read Only user from XML.');
        edROPassword.Text := pUserPassword;
        SQLDetails.ROPassword := edROPassword.Text;
      end
      else
      begin
        if Assigned(frmMessages) then frmMessages.AddLine('An error occurred when calling SQLGetUserPassword (Read Only). Error : ' + IntToStr(iResult));
        MsgBox('An error occurred when calling SQLGetUserPassword (Read Only).'#13#13'Error : '
        + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLGetUserPassword Error');
        edROPassword.Text := IntToStr(iResult);
      end;{if}
      ColourControlForErrors(edROPassword, iResult <> 0);

      // Get Read Write Password
      iResult := SQLGetUserPassword(pUserPassword, FALSE, pSpecialPassword); // call DLL Function
      if iResult = 0 then
      begin
        if Assigned(frmMessages) then frmMessages.AddLine('Successfully retrieved password for Read/Write user from XML.');
        edRWPassword.Text := pUserPassword;
        SQLDetails.RWPassword := edRWPassword.Text;
      end
      else
      begin
        if Assigned(frmMessages) then frmMessages.AddLine('An error occurred when calling SQLGetUserPassword (Read/Write). Error : ' + IntToStr(iResult));
        MsgBox('An error occurred when calling SQLGetUserPassword (Read/Write).'#13#13'Error : '
        + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLGetUserPassword Error #2');
        edRWPassword.Text := IntToStr(iResult);
      end;{if}
      ColourControlForErrors(edRWPassword, iResult <> 0);
    end;{if}

//    GetUserPassword(var pUserPassword : PChar; bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt; stdCall; external 'BespokeSQL.Dll';  // call DLL Function

    // clear up
    StrDispose(pUserName);
    StrDispose(pUserPassword);
    StrDispose(pSpecialPassword);
  end;{GetUserNamesAndPasswords}

  procedure GetLogins;
  begin{GetLogins}
    // Auto Create Users & Logins ?
    if bFirstTimeIn then
    begin
      // Create Logins / Users
      CreateLogin(TRUE, AdminLoginDetails, FALSE, frmMessages); // Create Read Only Login
      CreateUsers(TRUE, AdminLoginDetails, frmMessages); // should only create a Read Only user for the Exchequer Database
      CreateLogin(FALSE, AdminLoginDetails, FALSE, frmMessages); // Create Read Write Login
      CreateUsers(FALSE, AdminLoginDetails, frmMessages); // should only create a Read Write user for the Exchequer Database
    end;{if}

    // Read Logins
    SQLDetails.ROLoginStatus := GetLoginStatus(SQLDetails.ROUserName, frmMessages); // Does Read Only Login Exists
    SQLDetails.RWLoginStatus := GetLoginStatus(SQLDetails.RWUserName, frmMessages); // Does Read Write Login Exists
  end;{GetLogins}

begin
  pcTabs.ActivePageIndex := 0;
  bLoggedIn := FALSE;
  AdminLoginDetails.bWindowsAuth := TRUE;
  AdminLoginDetails.bRemember := FALSE;
  bSQLExch := SQLExchVersionSQL;
  frmMessages := nil;
  bHalt := FALSE;

  frmMessages := TfrmMessages.Create(self);
  frmMessages.Show;

  if bSQLExch then
  begin
    // SQL version of Exchequer
    lExchDBType.Caption := 'MS-SQL Version';
    if not GetExchDatabaseProperties then
    begin
      MsgBox('An error occurred when reading the IRIS Exchequer SQL Database Properties.'#13#13
      + 'Please check that your IRIS Exchequer Installation is configured correctly.'
      , mtError, [mbOK], mbOK, 'GetExchDatabaseProperties Error');

      if Assigned(frmMessages) then
      begin
        frmMessages.Hide;
        frmMessages.Release;
        frmMessages := nil;
      end;{if}
      bHalt := TRUE;
//      Halt;
    end;{if}
  end
  else
  begin
    // Pervasive Version
    lExchDBType.Caption := 'Pervasive Version';
    asExchSQLDBName := '';
    asExchSQLServerName := '';
  end;{if}

  if Assigned(frmMessages) then frmMessages.AddLine('Exchequer : ' + lExchDBType.Caption);

  if not bHalt then GetUserNamesAndPasswords;

  if bHalt then
  begin
    // Close Window
    PostMessage(self.Handle,wm_Close,0,0);
  end
  else
  begin
    GetLogins;
    GetBespokeDatabaseNames(frmMessages);

    if Assigned(frmMessages) then
    begin
      frmMessages.AddLine(' ');
      frmMessages.AddLine('Finished Configuration.');
      frmMessages.btnOK.Enabled := TRUE;
      frmMessages.btnSave.Enabled := TRUE;
      frmMessages.ActiveControl := frmMessages.btnOK;
    end;{if}

    // NF: I know this isn't brilliant, but without redesigning the whole thing, it is the only way I could easily implement this "messages window"
    while Assigned(frmMessages) and frmMessages.Open do
    begin
      application.processmessages;
    end;{if}

    if Assigned(frmMessages) then
    begin
      frmMessages.Release;
    end;{if}

    EnableDisable;
  end;{if}
end;

procedure TfrmBespokeSQLAdmin.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmBespokeSQLAdmin.btnSaveROUserClick(Sender: TObject);
var
  pSpecialPassword, pUserName : PChar;
  iResult : integer;
begin
  if SQLDetails.ROUserName <> '' then
  begin
    // Save Read Only User Name

    // Initialise
    pUserName := StrAlloc(255);
    pSpecialPassword := StrAlloc(255);

    StrPCopy(pUserName, SQLDetails.ROUserName);
    StrPCopy(pSpecialPassword, GetPassword{(iKey)});

    iResult := SQLSetUsername(pUserName, TRUE, pSpecialPassword); // call DLL Function
    if iResult = 0 then
    begin
      MsgBox('Successfully Updated', mtInformation, [mbOK], mbOK, 'SetUsername');
      SQLDetails.ROUsername := edROUserName.Text;
    end
    else
    begin
      MsgBox('An error occurred when calling SQLSetUsername :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLSetUsername Error');
    end;{if}

    // clear up
    StrDispose(pUserName);
    StrDispose(pSpecialPassword);
  end;{if}
end;

procedure TfrmBespokeSQLAdmin.btnSaveRWUserClick(Sender: TObject);
var
  pSpecialPassword, pUserName : PChar;
  iResult : integer;
begin
  if SQLDetails.RWUserName <> '' then
  begin
    // Save Read Write User Name

    // Initialise
    pUserName := StrAlloc(255);
    pSpecialPassword := StrAlloc(255);

    StrPCopy(pUserName, SQLDetails.RWUserName);
    StrPCopy(pSpecialPassword, GetPassword{(iKey)});

    iResult := SQLSetUsername(pUserName, FALSE, pSpecialPassword); // call DLL Function
    if iResult = 0 then
    begin
      MsgBox('Successfully Updated', mtInformation, [mbOK], mbOK, 'SetUsername');
      SQLDetails.RWUsername := edRWUserName.Text;
    end
    else
    begin
      MsgBox('An error occurred when calling SQLSetUsername :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLSetUsername Error #2');
    end;{if}

    // clear up
    StrDispose(pUserName);
    StrDispose(pSpecialPassword);
  end;{if}
end;

procedure TfrmBespokeSQLAdmin.btnSaveROPasswordClick(Sender: TObject);
var
  pSpecialPassword, pUserPassword : PChar;
  iResult : integer;
begin
  if SQLDetails.ROPassword <> '' then
  begin
    // Save Read Only User Password

    // Initialise
    pUserPassword := StrAlloc(255);
    pSpecialPassword := StrAlloc(255);

    StrPCopy(pUserPassword, SQLDetails.ROPassword);
    StrPCopy(pSpecialPassword, GetPassword{(iKey)});

    iResult := SQLSetUserPassword(pUserPassword, TRUE, pSpecialPassword); // call DLL Function
    if iResult = 0 then
    begin
      MsgBox('Successfully Updated', mtInformation, [mbOK], mbOK, 'SetPassword');
      SQLDetails.ROPassword := SQLDetails.ROPassword;
    end
    else
    begin
      MsgBox('An error occurred when calling SQLSetPassword :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLSetPassword Error');
    end;{if}

    // clear up
    StrDispose(pUserPassword);
    StrDispose(pSpecialPassword);
  end;{if}
end;

procedure TfrmBespokeSQLAdmin.btnSaveRWPasswordClick(Sender: TObject);
var
  pSpecialPassword, pUserPassword : PChar;
  iResult : integer;
begin
  if SQLDetails.RWPassword <> '' then
  begin
    // Save Read Only User Password

    // Initialise
    pUserPassword := StrAlloc(255);
    pSpecialPassword := StrAlloc(255);

    StrPCopy(pUserPassword, SQLDetails.RWPassword);
    StrPCopy(pSpecialPassword, GetPassword{(iKey)});

    iResult := SQLSetUserPassword(pUserPassword, FALSE, pSpecialPassword); // call DLL Function
    if iResult = 0 then
    begin
      MsgBox('Successfully Updated', mtInformation, [mbOK], mbOK, 'SetPassword');
      SQLDetails.RWPassword := edRWPassword.Text;
    end
    else
    begin
      MsgBox('An error occurred when calling SQLSetPassword :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLSetPassword Error #2');
    end;{if}

    // clear up
    StrDispose(pUserPassword);
    StrDispose(pSpecialPassword);
  end;{if}
end;

procedure TfrmBespokeSQLAdmin.About1Click(Sender: TObject);
begin
  MsgBox('Bespoke SQL Administrator'#13#13 + sVersionNo + #13#13
  + GetCopyrightMessage, mtInformation, [mbOK], mbOK, 'About');
end;

procedure TfrmBespokeSQLAdmin.Login1Click(Sender: TObject);
var
  frmLogin : TfrmLogin;
begin
  frmLogin := TfrmLogin.Create(self);
  bLoggedIn := frmLogin.Showmodal = mrOK;
  frmLogin.Release;
  EnableDisable;
end;

procedure TfrmBespokeSQLAdmin.EnableDisable;
begin
  // Menu
  Login1.Enabled := not bLoggedin;
  ResetXMLFile1.Enabled := bLoggedin;

  // Exchequer
  ColourControlForErrors(lExchSQLDBName, asExchSQLDBName = SQLStatusDescs[SQL_ERROR]);
  ColourControlForErrors(lExchSQLServerName, asExchSQLServerName = SQLStatusDescs[SQL_ERROR]);
//  lIRISExchequer.Enabled := bSQLExch;
  lExchSQLDBNameTit.Enabled := bSQLExch;
  lExchSQLServerNameTit.Enabled := bSQLExch;
//  bvIRISExchequer.Enabled := bSQLExch;

  // Read Only
//  btnSaveROUser.enabled := bLoggedin;
//  btnSaveROPassword.enabled := bLoggedin;
  if bLoggedin then
  begin
    edROPassword.Hint := SQLDetails.ROPassword;
    edROUserName.Hint := SQLDetails.ROUsername;
  end
  else
  begin
    edROUserName.Hint := '';
    edROPassword.Hint := '';
  end;{if}
  lROLoginStatus.Caption := SQLStatusDescs[SQLDetails.ROLoginStatus];
  ColourControlForErrors(lROLoginStatus, SQLDetails.ROLoginStatus <> SQL_CREATED);
  btnCreateROLogin.Enabled := SQLDetails.ROLoginStatus = SQL_NOT_CREATED;
  btnROCreateAll.Enabled := (SQLDetails.ROLoginStatus = SQL_CREATED) and bLoggedin;
  if bSQLExch then ColourControlForErrors(lROUserDatabases, lbROUserDatabases.Items.count <> (mlDatabases.itemscount + 1))
  else ColourControlForErrors(lROUserDatabases, lbROUserDatabases.Items.count <> (mlDatabases.itemscount));

  // Read Write
//  btnSaveRWUser.enabled := bLoggedin;
//  btnSaveRWPassword.enabled := bLoggedin;
  if bLoggedin then
  begin
    edRWPassword.Hint := SQLDetails.RWPassword;
    edRWUserName.Hint := SQLDetails.RWUsername;
  end
  else
  begin
    edRWUserName.Hint := '';
    edRWPassword.Hint := '';
  end;{if}
  lRWLoginStatus.Caption := SQLStatusDescs[SQLDetails.RWLoginStatus];
  ColourControlForErrors(lRWLoginStatus, SQLDetails.RWLoginStatus <> SQL_CREATED);
  btnCreateRWLogin.Enabled := SQLDetails.RWLoginStatus = SQL_NOT_CREATED;
  btnRWCreateAll.Enabled := (SQLDetails.RWLoginStatus = SQL_CREATED) and bLoggedin;
  if bSQLExch then ColourControlForErrors(lRWUserDatabases, lbRWUserDatabases.Items.count <> (mlDatabases.itemscount + 1))
  else ColourControlForErrors(lRWUserDatabases, lbRWUserDatabases.Items.count <> (mlDatabases.itemscount));

  // Databases
  btnAdd.enabled := bLoggedin;
  btnEdit.Enabled := (mlDatabases.Selected >= 0) and (mlDatabases.ItemsCount > 0) and bLoggedin;
  btnView.Enabled := (mlDatabases.Selected >= 0) and (mlDatabases.ItemsCount > 0);
  btnDelete.Enabled := btnEdit.Enabled;
  btnTables.Enabled := (mlDatabases.Selected >= 0) and (mlDatabases.ItemsCount > 0);
  btnGetConnectionString.Enabled := btnView.Enabled;
end;

procedure TfrmBespokeSQLAdmin.btnAddClick(Sender: TObject);
var
  iResult : integer;
  frmDatabaseDetails : TfrmDatabaseDetails;
begin
  frmDatabaseDetails := TfrmDatabaseDetails.Create(self);
  frmDatabaseDetails.FormMode := fmAdd;
  frmDatabaseDetails.DatabaseInfo := TDatabaseInfo.Create;
  if frmDatabaseDetails.ShowModal = mrOK then
  begin
    frmDatabaseDetails.DatabaseInfo.Code := trim(Uppercase(frmDatabaseDetails.edCode.Text));
    frmDatabaseDetails.DatabaseInfo.Description := trim(frmDatabaseDetails.edDesc.Text);
    frmDatabaseDetails.DatabaseInfo.Database := trim(frmDatabaseDetails.edDatabase.Text);
//    frmDatabaseDetails.DatabaseInfo.CreationScript.Assign(frmDatabaseDetails.memCreate.Lines);

{    iResult := AddBespokeDatabase(frmDatabaseDetails.DatabaseInfo.Code
    , frmDatabaseDetails.DatabaseInfo.Description
    , frmDatabaseDetails.DatabaseInfo.Database);}

    iResult := frmDatabaseDetails.DatabaseInfo.Add;

    if iResult = 0 then
    begin
      mlDatabases.DesignColumns[0].Items.AddObject(frmDatabaseDetails.DatabaseInfo.Code, frmDatabaseDetails.DatabaseInfo);
      mlDatabases.DesignColumns[1].Items.Add(frmDatabaseDetails.DatabaseInfo.Description);
      mlDatabases.DesignColumns[2].Items.Add(frmDatabaseDetails.DatabaseInfo.Database);

      mlDatabases.Selected := mlDatabases.ItemsCount-1;
      EnableDisable;
    end
    else
    begin
      MsgBox('An error occurred when calling DatabaseInfo.Add :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'DatabaseInfo.Add Error');
    end;{if}
  end
  else
  begin
    frmDatabaseDetails.DatabaseInfo.Free;
  end;{if}
  frmDatabaseDetails.Release;
end;

procedure TfrmBespokeSQLAdmin.btnEditClick(Sender: TObject);
var
  asOriginalCode : ANSIString;
  iResult : integer;
  frmDatabaseDetails : TfrmDatabaseDetails;
begin
  frmDatabaseDetails := TfrmDatabaseDetails.Create(self);
  frmDatabaseDetails.FormMode := fmEdit;
  frmDatabaseDetails.DatabaseInfo := TDatabaseInfo(mlDatabases.DesignColumns[0].Items.Objects[mlDatabases.Selected]);
  asOriginalCode := frmDatabaseDetails.DatabaseInfo.Code;
  if frmDatabaseDetails.ShowModal = mrOK then
  begin
    frmDatabaseDetails.DatabaseInfo.Code := trim(Uppercase(frmDatabaseDetails.edCode.Text));
    frmDatabaseDetails.DatabaseInfo.Description := trim(frmDatabaseDetails.edDesc.Text);
    frmDatabaseDetails.DatabaseInfo.Database := trim(frmDatabaseDetails.edDatabase.Text);
    iResult := frmDatabaseDetails.DatabaseInfo.Update(asOriginalCode);

    if iResult = 0 then
    begin
      mlDatabases.DesignColumns[0].Items[mlDatabases.Selected] := frmDatabaseDetails.DatabaseInfo.Code;
      mlDatabases.DesignColumns[1].Items[mlDatabases.Selected] := frmDatabaseDetails.DatabaseInfo.Description;
      mlDatabases.DesignColumns[2].Items[mlDatabases.Selected] := frmDatabaseDetails.DatabaseInfo.Database;

      EnableDisable;
    end
    else
    begin
      MsgBox('An error occurred when calling DatabaseInfo.Update :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'DatabaseInfo.Update Error');
    end;{if}
  end
  else
  begin
    //
  end;{if}
  frmDatabaseDetails.Release;
end;

procedure TfrmBespokeSQLAdmin.btnDeleteClick(Sender: TObject);
var
  iResult : integer;
begin
  if MsgBox('Are you sure you want to delete this database from the list ?'#13#13
  + 'Doing so may stop your Exchequer Plug-Ins from operating correctly.'#13#13
  + 'Note : This only deletes the reference to this Database, not the SQL Database itself.'
  , mtWarning, [mbYes, mbNo], mbNo, 'Delete Database') = mrYes then
  begin

//    iResult := DeleteBespokeDatabase(PChar(TDatabaseInfo(mlDatabases.DesignColumns[0].Items.Objects[mlDatabases.Selected]).Code));
    iResult := TDatabaseInfo(mlDatabases.DesignColumns[0].Items.Objects[mlDatabases.Selected]).Delete;

    if iResult = 0 then
    begin
      mlDatabases.DesignColumns[0].Items.Objects[mlDatabases.Selected].Free;
      mlDatabases.DesignColumns[0].Items.Delete(mlDatabases.Selected);
      mlDatabases.DesignColumns[1].Items.Delete(mlDatabases.Selected);
      mlDatabases.DesignColumns[2].Items.Delete(mlDatabases.Selected);

      if mlDatabases.ItemsCount > 0 then mlDatabases.Selected := 0;
      EnableDisable;
    end
    else
    begin
      MsgBox('An error occurred when calling TDatabaseInfo.Delete :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'TDatabaseInfo.Delete Error');
    end;{if}
  end;{if}
end;

procedure TfrmBespokeSQLAdmin.FormDestroy(Sender: TObject);
begin
  mlDatabases.ClearItems;
end;

procedure TfrmBespokeSQLAdmin.mlDatabasesRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
//  if btnEdit.Enabled then btnEdit.Click;
  btnView.Click;
end;

procedure TfrmBespokeSQLAdmin.btnGetConnectionStringClick(Sender: TObject);
var
  asConnectionString : ANSIString;
  pSpecialPassword, pPlugInCode, pConnectionString : PChar;
  iResult : integer;
  DatabaseInfo : TDatabaseInfo;
begin
  // Save Read Only User Password

  // Initialise
  pPlugInCode := StrAlloc(255);
  pConnectionString := StrAlloc(255);
  pSpecialPassword := StrAlloc(255);

  StrPCopy(pSpecialPassword, GetPassword{(iKey)});
  DatabaseInfo := TDatabaseInfo(mlDatabases.DesignColumns[0].Items.Objects[mlDatabases.Selected]);
  StrPCopy(pPlugInCode, DatabaseInfo.Code);

  iResult := SQLBuildBespokeConnectionString(pPlugInCode, TRUE, pConnectionString, pSpecialPassword);
  if iResult = 0 then
  begin
    asConnectionString := pConnectionString;
    InputBox('Example Connection String', 'Connection String', asConnectionString);
//    MsgBox('Example Connection String = ' + QuotedStr(asConnectionString), mtInformation, [mbOK], mbOK, 'Connection String');
  end
  else
  begin
    MsgBox('An error occurred when calling SQLBuildConnectionString :'#13#13'Error : '
    + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLBuildConnectionString Error');
  end;{if}

  // clear up
  StrDispose(pPlugInCode);
  StrDispose(pConnectionString);
  StrDispose(pSpecialPassword);
end;

procedure TfrmBespokeSQLAdmin.btnTablesClick(Sender: TObject);
begin
  frmTables := TfrmTables.Create(self);
  try
    frmTables.DatabaseInfo := TDatabaseInfo(mlDatabases.DesignColumns[0].Items.Objects[mlDatabases.Selected]);
    frmTables.Caption := 'Tables for ' + frmTables.DatabaseInfo.Database;
//    frmTables.FillTableListFrom(frmTables.DatabaseInfo.Tables);
    frmTables.FillTableList;
    frmTables.ShowModal;
  finally
    frmTables.Release;
  end;
end;

function TfrmBespokeSQLAdmin.GetLoginStatus(asLoginName : ANSIString; frmMessages : TfrmMessages) : integer;
var
//  pDatabaseName : PChar;
//  asConnectionString : ANSIString;
  iResult : LongInt;
  bExists : WordBool;
  pLoginName : PChar;
begin{GetLoginStatus}

  // initialise
  pLoginName := StrAlloc(255);
  StrPCopy(pLoginName, asLoginName);

  iResult := SQLLoginExists(pLoginName, bExists); // call dll function
  if iResult = 0 then
  begin
    if bExists then Result := 1
    else Result := 0;
    if Assigned(frmMessages) then
    begin
//      frmMessages.AddLine('Successfully Retrieved Login Status for ' + asLoginName);
      frmMessages.AddLine('Successfully Retrieved Login Status');
    end;{if}
  end
  else
  begin
    Result := -1;
    if Assigned(frmMessages) then
    begin
//      frmMessages.AddLine('An error occurred when calling SQLLoginExists for ' + asLoginName, mmtError)
      frmMessages.AddLine('An error occurred when calling SQLLoginExists.', mmtError)
    end
    else
    begin
//      MsgBox('An error occurred when calling SQLLoginExists for ' + asLoginName
//      + #13#13'Error : ' + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLLoginExists Error');
      MsgBox('An error occurred when calling SQLLoginExists.'
      + #13#13'Error : ' + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLLoginExists Error');
    end;{if}
  end;{if}

  // clear up
  StrDispose(pLoginName);
end;{GetLoginStatus}

procedure TfrmBespokeSQLAdmin.Add2UserDatabaseList(bReadOnly : boolean; asDatabaseName : ANSIString; frmMessages : TfrmMessages);
var
  iResult : integer;
  pUsername, pDatabaseName : PChar;
  bExists : WordBool;
begin
  pDatabaseName := StrAlloc(255);
  pUsername := StrAlloc(255);
  StrPCopy(pDatabaseName, asDatabaseName);

  if bReadOnly then
  begin
    StrPCopy(pUsername, SQLDetails.ROUserName);
    iResult := SQLUserExistsForDatabase(pUsername, pDatabaseName , bExists);
    if (iResult = 0) or (iResult = -2) {not allowed to access} then
    begin
      if bExists then lbROUserDatabases.Items.Add(asDatabaseName);
    end
    else
    begin
      if Assigned(frmMessages) then
      begin
//        frmMessages.AddLine('An error occurred when calling SQLUserExistsForDatabase for '
//        + pUsername + '/' + pDatabaseName, mmtError);
        frmMessages.AddLine('An error occurred when calling SQLUserExistsForDatabase for '
        + pDatabaseName, mmtError);
      end
      else
      begin
//        MsgBox('An error occurred when calling SQLUserExistsForDatabase for '
//        + pUsername + '/' + pDatabaseName + #13#13'Error : ' + IntToStr(iResult)
//        , mtError, [mbOK], mbOK, 'SQLUserExistsForDatabase Error');
        MsgBox('An error occurred when calling SQLUserExistsForDatabase for '
        + pDatabaseName + #13#13'Error : ' + IntToStr(iResult)
        , mtError, [mbOK], mbOK, 'SQLUserExistsForDatabase Error');
      end;{if}
    end;{if}
  end
  else
  begin
    StrPCopy(pUsername, SQLDetails.RWUserName);
    iResult := SQLUserExistsForDatabase(pUserName, pDatabaseName, bExists);
    if (iResult = 0) or (iResult = -2) {not allowed to access} then
    begin
      if bExists then lbRWUserDatabases.Items.Add(asDatabaseName);
    end
    else
    begin
      if Assigned(frmMessages) then
      begin
//        frmMessages.AddLine('An error occurred when calling SQLUserExistsForDatabase for '
//        + pUsername + '/' + pDatabaseName, mmtError);
        frmMessages.AddLine('An error occurred when calling SQLUserExistsForDatabase for '
        + pDatabaseName, mmtError);
      end
      else
      begin
//        MsgBox('An error occurred when calling SQLUserExistsForDatabase for '
//        + pUsername + '/' + pDatabaseName + #13#13'Error : ' + IntToStr(iResult)
//        , mtError, [mbOK], mbOK, 'SQLUserExistsForDatabase Error #2');
        MsgBox('An error occurred when calling SQLUserExistsForDatabase for '
        + pDatabaseName + #13#13'Error : ' + IntToStr(iResult)
        , mtError, [mbOK], mbOK, 'SQLUserExistsForDatabase Error #2');
      end;{if}
    end;{if}
  end;{if}

  StrDispose(pDatabaseName);
  StrDispose(pUsername);
end;{if}


procedure TfrmBespokeSQLAdmin.btnCreateROLoginClick(Sender: TObject);
var
  SQLLoginDetails : TSQLLoginDetails;
begin
  if GetSQLLoginDetails(SQLLoginDetails) then
  begin
    CreateLogin(TRUE, SQLLoginDetails, TRUE, nil);
    GetBespokeDatabaseNames(nil);
    EnableDisable;
  end;{if}
end;

procedure TfrmBespokeSQLAdmin.btnCreateRWLoginClick(Sender: TObject);
var
  SQLLoginDetails : TSQLLoginDetails;
begin
  if GetSQLLoginDetails(SQLLoginDetails) then
  begin
    CreateLogin(FALSE, SQLLoginDetails, TRUE, nil);
    GetBespokeDatabaseNames(nil);
    EnableDisable;
  end;{if}
end;

procedure TfrmBespokeSQLAdmin.CreateLogin(bReadOnly : WordBool; SQLLoginDetails : TSQLLoginDetails; bReadLogin : boolean; frmMessages : TfrmMessages);

  function SQLCreateLogin(asLogin, asLoginPassword : ANSIString; bReadOnly : WordBool; SQLLoginDetails : TSQLLoginDetails) : integer;
  var
    pLoginPassword, pLoginName, pUserName, pPassword, pSpecialPassword : PChar;
//    asConnectionString : ANSIString;
//    bExists : WordBool;
  begin{SQLCreateLogin}
    // initialise
    pLoginName := StrAlloc(255);
    StrPCopy(pLoginName, asLogin);
    pLoginPassword := StrAlloc(255);
    StrPCopy(pLoginPassword, asLoginPassword);
    pSpecialPassword := StrAlloc(255);
    StrPCopy(pSpecialPassword, GetPassword{(iKey)});
    pUserName := StrAlloc(255);
    StrPCopy(pUserName, SQLLoginDetails.asUsername);
    pPassword := StrAlloc(255);
    StrPCopy(pPassword, SQLLoginDetails.asPassword);

    Result := SQLLoginCreate(SQLLoginDetails.bWindowsAuth, pUserName, pPassword
    , pLoginName, pLoginPassword, pSpecialPassword); // call dll function
    if Result <> 0 then
    begin
      if Assigned(frmMessages) then
      begin
//        frmMessages.AddLine('An error occurred when calling SQLLoginCreate (' + pLoginName + '). Error : ' + IntToStr(Result), mmtError);
        frmMessages.AddLine('An error occurred when calling SQLLoginCreate. Error : ' + IntToStr(Result), mmtError);
      end
      else
      begin
//        MsgBox('An error occurred when calling SQLLoginCreate (' + pLoginName + ')'#13#13'Error : '
//        + IntToStr(Result), mtError, [mbOK], mbOK, 'SQLLoginCreate Error');
        MsgBox('An error occurred when calling SQLLoginCreate.'#13#13'Error : '
        + IntToStr(Result), mtError, [mbOK], mbOK, 'SQLLoginCreate Error');
      end;{if}
    end;{if}

    // clear up
    StrDispose(pLoginName);
    StrDispose(pSpecialPassword);
    StrDispose(pPassword);
    StrDispose(pUserName);
    StrDispose(pLoginPassword);
  end;{SQLCreateLogin}

var
  pLogin : PChar;
  iResult : integer;
begin
  if bReadOnly then
  begin
    iResult := SQLCreateLogin(SQLDetails.ROUserName, SQLDetails.ROPassword, bReadOnly, SQLLoginDetails);
  end
  else
  begin
    iResult := SQLCreateLogin(SQLDetails.RWUserName, SQLDetails.RWPassword, bReadOnly, SQLLoginDetails);
  end;{if}

  if (iResult = 0) then
  begin
    // Read Login
    if bReadLogin then
    begin
      pLogin := StrAlloc(255);

      if bReadOnly then
      begin
        StrPCopy(pLogin, SQLDetails.ROUserName);
        SQLDetails.ROLoginStatus := GetLoginStatus(pLogin, frmMessages)
      end
      else
      begin
        StrPCopy(pLogin, SQLDetails.RWUserName);
        SQLDetails.RWLoginStatus := GetLoginStatus(pLogin, frmMessages);
      end;{if}

      StrDispose(pLogin);
    end;{if}

    if bReadOnly then
    begin
      if Assigned(frmMessages) then
      begin
//        frmMessages.AddLine('SQL Login Created Successfully (' + SQLDetails.ROUserName + ')');
        frmMessages.AddLine('SQL Login Created Successfully.');
      end
      else
      begin
//        MsgBox('Login (' + SQLDetails.ROUserName + ') Successfully Created', mtInformation, [mbOK], mbOK, 'SQLCreateLogin')
        MsgBox('Login Successfully Created', mtInformation, [mbOK], mbOK, 'SQLCreateLogin')
      end;{if}
    end
    else
    begin
      if Assigned(frmMessages) then
      begin
//        frmMessages.AddLine('SQL Login Created Successfully (' + SQLDetails.RWUserName + ')');
        frmMessages.AddLine('SQL Login Created Successfully');
      end
      else
      begin
//        MsgBox('Login (' + SQLDetails.RWUserName + ') Successfully Created', mtInformation, [mbOK], mbOK, 'SQLCreateLogin');
        MsgBox('Login Successfully Created', mtInformation, [mbOK], mbOK, 'SQLCreateLogin');
      end;
    end;{if}
  end
  else
  begin
    if bReadOnly then
    begin
      if Assigned(frmMessages) then
      begin
//        frmMessages.AddLine('An error occurred when calling SQLCreateLogin ('
//        + SQLDetails.ROUserName + '). Error : ' + IntToStr(iResult), mmtError);
        frmMessages.AddLine('An error occurred when calling SQLCreateLogin. Error : ' + IntToStr(iResult), mmtError);
      end
      else
      begin
//        MsgBox('An error occurred when calling SQLCreateLogin (' + SQLDetails.ROUserName + ').'#13#13'Error : '
//        + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLCreateLogin Error');
        MsgBox('An error occurred when calling SQLCreateLogin.'#13#13'Error : '
        + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLCreateLogin Error');
      end;{if}
    end
    else
    begin
      if Assigned(frmMessages) then
      begin
//        frmMessages.AddLine('An error occurred when calling SQLCreateLogin ('
//        + SQLDetails.RWUserName + '). Error : ' + IntToStr(iResult), mmtError);
        frmMessages.AddLine('An error occurred when calling SQLCreateLogin. Error : ' + IntToStr(iResult), mmtError);
      end
      else
      begin
//        MsgBox('An error occurred when calling SQLCreateLogin (' + SQLDetails.RWUserName + ').'#13#13'Error : '
//        + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLCreateLogin Error');
        MsgBox('An error occurred when calling SQLCreateLogin.'#13#13'Error : '
        + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLCreateLogin Error');
      end;{if}
    end;{if}
  end;{if}
end;

procedure TfrmBespokeSQLAdmin.btnROCreateAllClick(Sender: TObject);
var
  SQLLoginDetails : TSQLLoginDetails;
begin
  if GetSQLLoginDetails(SQLLoginDetails) then
  begin
    CreateUsers(TRUE, SQLLoginDetails, nil);
    GetBespokeDatabaseNames(nil);
  end;{if}
end;

procedure TfrmBespokeSQLAdmin.btnRWCreateAllClick(Sender: TObject);
var
  SQLLoginDetails : TSQLLoginDetails;
begin
  if GetSQLLoginDetails(SQLLoginDetails) then
  begin
    CreateUsers(FALSE, SQLLoginDetails, nil);
    GetBespokeDatabaseNames(nil);
  end;{if}
end;

procedure TfrmBespokeSQLAdmin.CreateUsers(bReadOnly : WordBool; SQLLoginDetails : TSQLLoginDetails; frmMessages : TfrmMessages);
var
  iCreated, iResult, iPos : integer;
  pSQLUserName, pUsername, pSQLPassword, pSpecialPassword, pDatabaseName : PChar;
  bExists : WordBool;
begin
  // initialise
  pSpecialPassword := StrAlloc(255);
  StrPCopy(pSpecialPassword, GetPassword{(iKey)});
  pSQLUserName := StrAlloc(255);
  StrPCopy(pSQLUserName, SQLLoginDetails.asUsername);
  pSQLPassword := StrAlloc(255);
  StrPCopy(pSQLPassword, SQLLoginDetails.asPassword);
  iCreated := 0;

  pUsername := StrAlloc(255);
  pDatabaseName := StrAlloc(255);

  if bReadOnly then StrPCopy(pUsername, SQLDetails.ROUserName)
  else StrPCopy(pUsername, SQLDetails.RWUserName);

  For iPos := 0 to mlDatabases.ItemsCount do
  begin
    if iPos = mlDatabases.ItemsCount then
    begin
      if bSQLExch then
      begin
        // Add Exchequer Database User
        StrPCopy(pDatabaseName, asExchSQLDBName);
        iResult := SQLUserExistsForDatabase(pUsername, pDatabaseName , bExists);
        if (iResult = 0) or (iResult = -2) {not allowed to access} then
        begin
          if not bExists then
          begin
            iResult := SQLAddDatabaseUser(SQLLoginDetails.bWindowsAuth, pSQLUserName, pSQLPassword, pUsername, pDatabaseName, TRUE, pSpecialPassword);
            if (iResult = 0) then
            begin
              inc(iCreated);
            end
            else
            begin
              if Assigned(frmMessages) then
              begin
                frmMessages.AddLine('An error occurred when calling SQLAddDatabaseUser. Error : ' + IntToStr(iResult), mmtError);
              end
              else
              begin
                MsgBox('An error occurred when calling SQLAddDatabaseUser.'#13#13'Error : '
                + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLAddDatabaseUser Error #1');
              end;{if}
            end;{if}
          end;{if}
        end
        else
        begin
          if Assigned(frmMessages) then
          begin
            frmMessages.AddLine('An error occurred when calling SQLUserExistsForDatabase. Error : '
            + IntToStr(iResult), mmtError);
          end
          else
          begin
            MsgBox('An error occurred when calling SQLUserExistsForDatabase.'#13#13'Error : '
            + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLUserExistsForDatabase Error #1');
          end;{if}
        end;{if}
      end;{if}
    end
    else
    begin
      // Add Bespoke Database User
      StrPCopy(pDatabaseName, TDatabaseInfo(mlDatabases.DesignColumns[0].Items.Objects[iPos]).Database);

      if bReadOnly then
      begin
        iResult := SQLUserExistsForDatabase(pUsername, pDatabaseName , bExists);
        if (iResult = 0) or (iResult = -2) {not allowed to access} then
        begin
          if not bExists then
          begin
            iResult := SQLAddDatabaseUser(SQLLoginDetails.bWindowsAuth, pSQLUserName, pSQLPassword, pUsername, pDatabaseName, bReadOnly, pSpecialPassword);
            if (iResult = 0) then
            begin
              inc(iCreated);
            end
            else
            begin
              if Assigned(frmMessages) then
              begin
                frmMessages.AddLine('An error occurred when calling SQLAddDatabaseUser. Error : '
                + IntToStr(iResult), mmtError);
              end
              else
              begin
                MsgBox('An error occurred when calling SQLAddDatabaseUser.'#13#13'Error : '
                + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLAddDatabaseUser Error #2');
              end;{if}
            end;{if}
          end;{if}
        end
        else
        begin
          if Assigned(frmMessages) then
          begin
            frmMessages.AddLine('An error occurred when calling SQLUserExistsForDatabase. Error : '
            + IntToStr(iResult), mmtError);
          end
          else
          begin
            MsgBox('An error occurred when calling SQLUserExistsForDatabase.'#13#13'Error : '
            + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLUserExistsForDatabase Error #2');
          end;{if}
        end;{if}
      end
      else
      begin
        iResult := SQLUserExistsForDatabase(pUserName, pDatabaseName, bExists);
        if (iResult = 0) or (iResult = -2) {not allowed to access} then
        begin
          if not bExists then
          begin
            iResult := SQLAddDatabaseUser(SQLLoginDetails.bWindowsAuth, pSQLUserName, pSQLPassword, pUsername, pDatabaseName, bReadOnly, pSpecialPassword);
            if (iResult = 0) then
            begin
              inc(iCreated);
            end
            else
            begin
              if Assigned(frmMessages) then
              begin
                frmMessages.AddLine('An error occurred when calling SQLAddDatabaseUser. Error : '
                + IntToStr(iResult), mmtError);
              end
              else
              begin
                MsgBox('An error occurred when calling SQLAddDatabaseUser.'#13#13'Error : '
                + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLAddDatabaseUser Error #3');
              end;{if}
            end;{if}
          end;{if}
        end
        else
        begin
          if Assigned(frmMessages) then
          begin
            frmMessages.AddLine('An error occurred when calling SQLUserExistsForDatabase. Error : '
            + IntToStr(iResult), mmtError);
          end
          else
          begin
            MsgBox('An error occurred when calling SQLUserExistsForDatabase.'#13#13'Error : '
            + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLUserExistsForDatabase Error #3');
          end;{if}
        end;{if}
      end;{if}                                                       
    end;{if}
  end;{for}

  if Assigned(frmMessages) then
  begin
    if iCreated > 0
//    then frmMessages.AddLine('Database Users for ' + pUsername + ' Created Successfully.')
    then frmMessages.AddLine('Database Users Created Successfully.')
    else begin
//      if bSQLExch then frmMessages.AddLine('No Database Users for ' + pUsername + ' were created.', mmtError)
//      else frmMessages.AddLine('No Database Users for ' + pUsername + ' were created.');
      if bSQLExch then frmMessages.AddLine('No Database Users were created.', mmtError)
      else frmMessages.AddLine('No Database Users were created.');
    end;{if}
  end
  else
  begin
    if iCreated > 0
//    then MsgBox('Database Users for ' + pUsername + ' Created Successfully.', mtInformation, [mbOK], mbOK, 'SQLAddDatabaseUser')
//    else MsgBox('No Database Users for ' + pUsername + ' were created.', mtInformation, [mbOK], mbOK, 'SQLAddDatabaseUser');
    then MsgBox('Database Users Created Successfully.', mtInformation, [mbOK], mbOK, 'SQLAddDatabaseUser')
    else MsgBox('No Database Users were created.', mtInformation, [mbOK], mbOK, 'SQLAddDatabaseUser');
  end;

  // clear up
  StrDispose(pUsername);
  StrDispose(pDatabaseName);
  StrDispose(pSpecialPassword);
  StrDispose(pSQLUserName);
  StrDispose(pSQLPassword);
end;

function TfrmBespokeSQLAdmin.GetBespokeDatabaseNames(frmMessages : TfrmMessages) : boolean;
var
  iLine, iTable, {iResult, }iPos : integer;
  DatabaseInfo : TDatabaseInfo;
  TableInfo : TTableInfo;
//  ScriptInfo : TScriptInfo;
//  iScript : Integer;
begin{GetBespokeDatabaseNames}
  Result := FALSE;
  mlDatabases.ClearItems;
  lbRWUserDatabases.Clear;
  lbROUserDatabases.Clear;

  if bSQLExch then
  begin
    Add2UserDatabaseList(FALSE, asExchSQLDBName, frmMessages);
    Add2UserDatabaseList(TRUE, asExchSQLDBName, frmMessages);
  end;{if}

  if GetAllBespokeDatabaseInfo(mlDatabases.DesignColumns[0].Items, 'MASTER') = 0 then // called directly, as only this program should need to call this
  begin

    For iPos := 0 to mlDatabases.DesignColumns[0].Items.Count-1 do
    begin
      DatabaseInfo := TDatabaseInfo(mlDatabases.DesignColumns[0].Items.Objects[iPos]);
      DatabaseInfo.GetStatus(FALSE);
      if DatabaseInfo.Status = 0 then
      begin
        // Database does not exist
        Result := TRUE;

        // Run Database Creation Scripts
        DatabaseInfo.RunScripts(AdminLoginDetails, FALSE);

        // Output messages
        if Assigned(frmMessages) then
        begin
          For iLine := 0 to DatabaseInfo.Scripts.Count-1 do
          begin
            if TScriptInfo(DatabaseInfo.Scripts.Objects[iLine]).RunOK then
            begin
              frmMessages.AddLine(TScriptInfo(DatabaseInfo.Scripts.Objects[iLine]).StatusLine);
            end
            else
            begin
              frmMessages.AddLine(TScriptInfo(DatabaseInfo.Scripts.Objects[iLine]).StatusLine
              , mmtError);
            end;
          end;{for}
        end;{if}
//        if DatabaseInfo.SQLCreate(AdminLoginDetails) = 0 then
//        begin
//          MsgBox('Database Created Successfully.', mtInformation, [mbOK], mbOK, 'SQLDatabaseCreate');

          // Run Tables Creation Scripts
          For iTable := 0 to DatabaseInfo.Tables.Count-1 do
          begin
            // Run Table Creation Scripts
            TableInfo := TTableInfo(DatabaseInfo.Tables[iTable]);
            TableInfo.RunScripts(AdminLoginDetails, FALSE);

            // Output messages
            if Assigned(frmMessages) then
            begin
              For iLine := 0 to TableInfo.Scripts.Count-1 do
              begin
                if TScriptInfo(TableInfo.Scripts.Objects[iLine]).RunOK then
                begin
                  frmMessages.AddLine(TScriptInfo(TableInfo.Scripts.Objects[iLine]).StatusLine);
                end
                else
                begin
                  frmMessages.AddLine(TScriptInfo(TableInfo.Scripts.Objects[iLine]).StatusLine, mmtError);
                end;{if}
              end;{for}
            end;{if}

{
            For iScript := 0 to TableInfo.Scripts.Count-1 do
            begin
              ScriptInfo := TScriptInfo(TableInfo.Scripts.Objects[iScript]);
              iResult := RunSQLScript(ScriptInfo.Script.Text, DatabaseInfo.Database, AdminLoginDetails);
              if (iResult = 0) then
              begin
                MsgBox('Script (' + ScriptInfo.Name + ') Executed Successfully', mtInformation, [mbOK], mbOK, 'SQLExecute');
              end;{if}
//            end;
          end;{for}
//        end;{if}
      end else
      begin
        if (DatabaseInfo.Status = -1) and Assigned(frmMessages) then
        begin
          frmMessages.AddLine('An error occurred when calling SQLDatabaseExists for '
          + DatabaseInfo.Database, mmtError);
        end;{if}
      end;{if}

      DatabaseInfo.GetStatus;
      mlDatabases.DesignColumns[1].Items.Add(DatabaseInfo.Description);
      mlDatabases.DesignColumns[2].Items.Add(DatabaseInfo.Database);

      if Result then
      begin
        CreateUsers(TRUE, AdminLoginDetails, frmMessages); // should create a Read Only user for this Bespoke Database
        CreateUsers(FALSE, AdminLoginDetails, frmMessages); // should only create a Read Write user for this Bespoke Database
      end;{if}

      Sleep(1000); // pause, to allow users to be created.

      Add2UserDatabaseList(TRUE, DatabaseInfo.Database, frmMessages);
      Add2UserDatabaseList(FALSE, DatabaseInfo.Database, frmMessages);

    end;{for}

    if mlDatabases.ItemsCount > 0 then mlDatabases.Selected := 0;
  end;{if}

end;{GetBespokeDatabaseNames}



procedure TfrmBespokeSQLAdmin.mlDatabasesCellPaint(Sender: TObject; ColumnIndex, RowIndex: Integer; var OwnerText: String; var TextFont: TFont; var TextBrush: TBrush; var TextAlign: TAlignment);
var
  DatabaseInfo : TDatabaseInfo;
begin
  if ColumnIndex = 2 then
  begin
    DatabaseInfo := TDatabaseInfo(mlDatabases.DesignColumns[0].Items.Objects[RowIndex]);
    if (DatabaseInfo.Status = SQL_CREATED) then
    begin
      if RowIndex = mlDatabases.Selected then TextFont.Color := clWhite
      else TextFont.Color := clBlack;
    end
    else
    begin
      TextFont.Color := clRed;
    end;{if}
  end;{if}
end;

procedure TfrmBespokeSQLAdmin.ResetXMLFile1Click(Sender: TObject);
var
  pBlank, pSpecialPassword : PChar;
  iResult : integer;
begin
  if MsgBox('Are you sure you want to reset the Users/Passwords in the XML file ?'
  , mtWarning, [mbYEs, mbNo], mbNo, 'Reset XML File') = mrYes then
  begin
    // Initialise
    pBlank := StrAlloc(255);
    pSpecialPassword := StrAlloc(255);

    StrPCopy(pBlank, '');
    StrPCopy(pSpecialPassword, GetPassword{(iKey)});

    // Blank RO User
    iResult := SQLSetUsername(pBlank, TRUE, pSpecialPassword); // call DLL Function
    if iResult = 0 then
    begin
      MsgBox('Successfully Updated', mtInformation, [mbOK], mbOK, 'SetUsername');
      SQLDetails.ROUsername := edROUserName.Text;
    end
    else
    begin
      MsgBox('An error occurred when calling SQLSetUsername :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLSetUsername Error');
    end;{if}

    // Blank RW User
    iResult := SQLSetUsername(pBlank, FALSE, pSpecialPassword); // call DLL Function
    if iResult = 0 then
    begin
      MsgBox('Successfully Updated', mtInformation, [mbOK], mbOK, 'SetUsername');
      SQLDetails.RWUsername := edRWUserName.Text;
    end
    else
    begin
      MsgBox('An error occurred when calling SQLSetUsername :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLSetUsername Error #2');
    end;{if}

    // Blank RO Password
    iResult := SQLSetUserPassword(pBlank, TRUE, pSpecialPassword); // call DLL Function
    if iResult = 0 then
    begin
      MsgBox('Successfully Updated', mtInformation, [mbOK], mbOK, 'SetPassword');
      SQLDetails.ROPassword := SQLDetails.ROPassword;
    end
    else
    begin
      MsgBox('An error occurred when calling SQLSetPassword :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLSetPassword Error');
    end;{if}

    // Blank RW Password
    iResult := SQLSetUserPassword(pBlank, FALSE, pSpecialPassword); // call DLL Function
    if iResult = 0 then
    begin
      MsgBox('Successfully Updated', mtInformation, [mbOK], mbOK, 'SetPassword');
      SQLDetails.ROPassword := SQLDetails.ROPassword;
    end
    else
    begin
      MsgBox('An error occurred when calling SQLSetPassword :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLSetPassword Error #2');
    end;{if}

    // clear up
    StrDispose(pBlank);
    StrDispose(pSpecialPassword);
  end;{if}
end;

procedure TfrmBespokeSQLAdmin.btnViewClick(Sender: TObject);
var
  asOriginalCode : ANSIString;
  iResult : integer;
  frmDatabaseDetails : TfrmDatabaseDetails;
begin
  frmDatabaseDetails := TfrmDatabaseDetails.Create(self);
  frmDatabaseDetails.FormMode := fmEdit;
  frmDatabaseDetails.DatabaseInfo := TDatabaseInfo(mlDatabases.DesignColumns[0].Items.Objects[mlDatabases.Selected]);
  asOriginalCode := frmDatabaseDetails.DatabaseInfo.Code;
  frmDatabaseDetails.ShowModal;
  frmDatabaseDetails.Release;
end;

procedure TfrmBespokeSQLAdmin.Button1Click(Sender: TObject);
begin
  bLoggedIn := TRUE;
  EnableDisable;
end;

end.
