Unit uDemo;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComObj, activex,
  MSXML2_TLB,
  uCrypto,
  uCompression,
  uCommon, uconsts,
  uXmlBaseClass, uCustExport, uCustImport,
  watWinXP,
  DB, ADODB, shellapi,
  comadmin, CommCtrl, dateutils, Grids, DBGrids

  ;

{$I exdllbt.inc}

{$I exchdll.inc}

Const
  NIF_INFO = $10;
  NIF_MESSAGE = 1;
  NIF_ICON = 2;
  NOTIFYICON_VERSION = 3;
  NIF_TIP = 4;
  NIM_SETVERSION = $00000004;
  NIM_SETFOCUS = $00000003;
  NIIF_INFO = $00000001;
  NIIF_WARNING = $00000002;
  NIIF_ERROR = $00000003;

  NIN_BALLOONSHOW = WM_USER + 2;
  NIN_BALLOONHIDE = WM_USER + 3;
  NIN_BALLOONTIMEOUT = WM_USER + 4;
  NIN_BALLOONUSERCLICK = WM_USER + 5;
  NIN_SELECT = WM_USER + 0;
  NINF_KEY = $1;
  NIN_KEYSELECT = NIN_SELECT Or NINF_KEY;

  {define the callback message}
  TRAY_CALLBACK = WM_USER + $7258;

Type
  PNewNotifyIconData = ^TNewNotifyIconData;
  TDUMMYUNIONNAME = Record
    Case Integer Of
      0: (uTimeout: UINT);
      1: (uVersion: UINT);
  End;

  TNewNotifyIconData = Record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
   //Version 5.0 is 128 chars, old ver is 64 chars
    szTip: Array[0..127] Of Char;
    dwState: DWORD; //Version 5.0
    dwStateMask: DWORD; //Version 5.0
    szInfo: Array[0..255] Of Char; //Version 5.0
    DUMMYUNIONNAME: TDUMMYUNIONNAME;
    szInfoTitle: Array[0..63] Of Char; //Version 5.0
    dwInfoFlags: DWORD; //Version 5.0
  End;

  TfrmXmlFunctions = Class(TForm)
    btnCrypto: TButton;
    btnDecrypto: TButton;
    OpenDialog1: TOpenDialog;
    btnCompress: TButton;
    btnDecompress: TButton;
    memXml: TMemo;
    btnGuid: TButton;
    lblGuid: TLabel;
    btnTransform: TButton;
    btnValidate: TButton;
    memXsd: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    memTransform: TMemo;
    Label3: TLabel;
    btnLoadCustomer: TButton;
    btnTransform2: TButton;
    watWinXP1: TwatWinXP;
    ckbFromFile: TCheckBox;
    btnExport: TButton;
    Button2: TButton;
    btnImport: TButton;
    Button1: TButton;
    btnTestAdo: TButton;
    ADOQuery1: TADOQuery;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    btnComExists: TButton;
    btnInstallMsi: TButton;
    btnExportCom: TButton;
    btnChangeComProperty: TButton;
    Button11: TButton;
    ADOCommand1: TADOCommand;
    btnCompany: TButton;
    ADOTable1: TADOTable;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Procedure btnCryptoClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure btnDecryptoClick(Sender: TObject);
    Procedure btnCompressClick(Sender: TObject);
    Procedure btnDecompressClick(Sender: TObject);
    Procedure btnGuidClick(Sender: TObject);
    Procedure btnTransformClick(Sender: TObject);
    Procedure btnValidateClick(Sender: TObject);
    Procedure btnLoadCustomerClick(Sender: TObject);
    Procedure btnTransform2Click(Sender: TObject);
    Procedure btnExportClick(Sender: TObject);
    Procedure Button2Click(Sender: TObject);
    Procedure btnImportClick(Sender: TObject);
    Procedure btnTestAdoClick(Sender: TObject);
    Procedure Button4Click(Sender: TObject);
    Procedure Button5Click(Sender: TObject);
    Procedure Button6Click(Sender: TObject);
    Procedure btnComExistsClick(Sender: TObject);
    Procedure btnInstallMsiClick(Sender: TObject);
    Procedure btnExportComClick(Sender: TObject);
    Procedure Button11Click(Sender: TObject);
    Procedure btnChangeComPropertyClick(Sender: TObject);
    procedure btnCompanyClick(Sender: TObject);
  Private
    fCrypto: TCrypto;
    fCompress: TCompression;

    IconData: TNewNotifyIconData;
    Procedure SysTrayIconMsgHandler(Var Msg: TMessage); Message TRAY_CALLBACK;
    Procedure AddSysTrayIcon;
    Procedure ShowBalloonTips;
    Procedure DeleteSysTrayIcon;

  Public
  End;

Var
  frmXmlFunctions: TfrmXmlFunctions;

Implementation





{$R *.dfm}

Procedure TfrmXmlFunctions.btnCryptoClick(Sender: TObject);
Var
  x: String;
Begin
  If OpenDialog1.Execute Then
  Begin
    x := ExtractFilePath(OpenDialog1.FileName) + 'new' +
      ExtractFilename(OpenDialog1.FileName);

    fCrypto.EncryptFile(OpenDialog1.FileName, x);
  End;
End;

Procedure TfrmXmlFunctions.FormCreate(Sender: TObject);
Begin
  fCrypto := TCrypto.Create;
  fCompress := TCompression.Create;
  AddSysTrayIcon;
End;

Procedure TfrmXmlFunctions.FormDestroy(Sender: TObject);
Begin
  FreeAndNil(fCrypto);
  FreeAndNil(fcompress);
  DeleteSysTrayIcon;

End;

Procedure TfrmXmlFunctions.btnDecryptoClick(Sender: TObject);
Var
  x: String;
Begin
  If OpenDialog1.Execute Then
  Begin
    x := ExtractFilePath(OpenDialog1.FileName) + 'new' +
      ExtractFilename(OpenDialog1.FileName);
    fCrypto.DecryptFile(OpenDialog1.FileName, x);
  End;
End;

Procedure TfrmXmlFunctions.btnCompressClick(Sender: TObject);
Var
  x: String;
Begin
  If OpenDialog1.Execute Then
  Begin
    x := ExtractFilePath(OpenDialog1.FileName) + 'new' +
      ExtractFilename(OpenDialog1.FileName);
    fCompress.Compress(OpenDialog1.FileName, x)
  End;
End;

Procedure TfrmXmlFunctions.btnDecompressClick(Sender: TObject);
Var
  x: String;
Begin
  If OpenDialog1.Execute Then
  Begin
    x := ExtractFilePath(OpenDialog1.FileName) + 'new' +
      ExtractFilename(OpenDialog1.FileName);

    fCompress.DeCompress(OpenDialog1.FileName, x)
  End;
End;

Procedure TfrmXmlFunctions.btnGuidClick(Sender: TObject);
Begin
  lblGuid.Caption := GUIDToString(_CreateGuid);
//  memXml.Lines.Add(lblGuid.Caption);
End;

Procedure TfrmXmlFunctions.btnTransformClick(Sender: TObject);
Var
  XMLDoc: TXMLDoc;
  s: WideString;
Begin
  memTransform.clear;
  XMLDoc := TXMLDoc.Create;
  XMLDoc.Load('C:\Projects\Ice\Bin\XmlModel\cust.xml');
  XMLDoc.RemoveComments;
  s := XMLDoc.Transform('C:\Projects\Ice\Bin\Transform\cust.xsl');

  If s <> '' Then
  Begin
    memTransform.lines.Text := _ChangeXmlEncodeValue(s);
    ShowMessage('Transformation ok');
  End;

  XMLDoc.Free;
End;

Procedure TfrmXmlFunctions.btnValidateClick(Sender: TObject);
Var
  xmldoc: TXMLDoc;
  lResult: Boolean;
Begin
  xmldoc := TXMLDoc.Create;
  xmldoc.Load('C:\Projects\Ice\Bin\XmlModel\vat.xml');
  If ckbFromFile.Checked Then
    lResult := xmldoc.Validate('C:\Projects\Ice\Bin\Schema\vat.xsd')
  Else
    lResult := xmldoc.Validate('', memXsd.Text);

  If lResult Then
    Showmessage('Validation ok')
  else
    Showmessage('Validation not ok');

  xmlDoc.Free;
End;

Procedure TfrmXmlFunctions.btnLoadCustomerClick(Sender: TObject);
Begin
  memXsd.Clear;
  memXsd.Lines.LoadFromFile(extractfilepath(application.exename) + 'cust2.xsd');
  memXml.Clear;
  memXml.Lines.LoadFromFile(extractfilepath(application.exename) + 'cust2.xml');
End;

Procedure TfrmXmlFunctions.btnTransform2Click(Sender: TObject);
Var
  s: WideString;
  XMLDoc: TXMLDoc;
Begin
  memTransform.clear;
  XMLDoc := TXMLDoc.Create;
  XMLDoc.Load(extractfilepath(application.exename) + 'cust2.xml');
  s := XMLDoc.Transform(extractfilepath(application.exename) + 'cust21.xsl');

  If s <> '' Then
  Begin
    memTransform.lines.Text := s;
    showmessage('Transformation OK');
  End;

  XMLDoc.Free;
End;

Procedure TfrmXmlFunctions.btnExportClick(Sender: TObject);
Var
  x: TCustExport;
  i: integer;
Begin
  x := TCustExport.Create;
  x.ExCode := 'ZZZZ01';
  x.Param2 := 0;
  x.LoadFromDB;

//  x.CreateXmlRecords;
  {
  If x.List.Count > 0 Then
    For i := 0 To x.List.Count - 1 Do
      With TXmlCustomer(x.List.Items[i]).Cust Do
        memXml.Lines.Add(CustCode + ' ' + Company);
  }
  freeandnil(x);
End;

Procedure TfrmXmlFunctions.Button2Click(Sender: TObject);
Var
  y: TXMLDoc;
  node: IXMLDomNode;
  i, records: integer;
Begin
  y := TXMLDoc.Create;
  y.Load(extractfilepath(Application.ExeName) + 'abo.xml');
  //Node := uCommon._GetNodeByName(y.Doc, 'message');

//  Node := uCommon._GetNodeByName(y.Doc.DefaultInterface, 'message');
  records := _GetXmlRecordCount(Node);

  For i := 0 To records - 1 Do
    memXml.Lines.Add(node.childNodes[i].attributes[0].nodeValue + ' ' +
      node.childNodes[i].attributes[1].nodeValue);

  freeandnil(y);
End;

Procedure TfrmXmlFunctions.btnImportClick(Sender: TObject);
Var
  Imp: TCustImport;
Begin
  Imp := TCustImport.Create;
//  Imp.DLLPath := 'C:\Develop\exch\' ;

  If imp.XMLDoc.Load('C:\Projects\Ice\Bin\Inbox\{14C0605E-8B4D-4DF1-B5DC-B79A10715CCD}\Copy of 1.xml') Then
    If imp.Extract Then
      imp.SaveListtoDB;

  imp.Free;
End;

Procedure TfrmXmlFunctions.btnTestAdoClick(Sender: TObject);
Var
  lsql: String;
  ldesc: String;
  lTotal,
    lMsgType,
    lStatus: integer;
Begin
  ADOQuery1.SQL.Clear;

  ADOQuery1.Close;

  ldesc := 'Test';
  lTotal := 10;
  lMsgType := 1;
  lStatus := 0;

  lsql :=
    'insert into inbox (guid, description, messagetype, totalitems, status) values ';
  lSql := lSql + ' (' + QuotedStr(GUIDToString(GUID_NULL)) + ', ' +
    QuotedStr(lDesc) + ', ' +
    inttostr(lMsgType) + ', ' + inttostr(lTotal) + ', ' + inttostr(lStatus) +
    ') ';

  ADOQuery1.SQL.Add(lSql);

  ADOQuery1.execsql;

  If ADOQuery1.Active Then
  Begin
  End;

  ADOQuery1.Active := False;
End;

Procedure TfrmXmlFunctions.Button4Click(Sender: TObject);
Var
  x: String;
Begin
  x := _GetUSerName;
End;

Procedure TfrmXmlFunctions.Button5Click(Sender: TObject);
Var
  pBuffer: pchar;
Begin
  GetMem(pBuffer, Max_path);
  GetModuleFileName(HInstance, pBuffer, Max_path);
  showmessage(String(pBuffer));
  FreeMem(pBuffer);
End;

Procedure TfrmXmlFunctions.AddSysTrayIcon;
Begin
  IconData.cbSize := SizeOf(IconData);
  IconData.Wnd := AllocateHWnd(SysTrayIconMsgHandler);
  {SysTrayIconMsgHandler is then callback message' handler}
  IconData.uID := 0;
  IconData.uFlags := NIF_ICON Or NIF_MESSAGE Or NIF_TIP;
  IconData.uCallbackMessage := TRAY_CALLBACK; //user defined callback message
  IconData.hIcon := Application.Icon.Handle; //an Icon's Handle
  IconData.szTip := 'Please send me email.';
  If Not Shell_NotifyIcon(NIM_ADD, @IconData) Then
    _LogMSG('add fail');
End;

Procedure TfrmXmlFunctions.DeleteSysTrayIcon;
Begin
  DeallocateHWnd(IconData.Wnd);
  If Not Shell_NotifyIcon(NIM_DELETE, @IconData) Then
    _LogMSG('delete fail');
End;

Procedure TfrmXmlFunctions.ShowBalloonTips;
Var
  TipInfo, TipTitle: String;
Begin
  IconData.cbSize := SizeOf(IconData);
  IconData.uFlags := NIF_INFO;
  TipInfo := 'Please send me email.';
  strPLCopy(IconData.szInfo, TipInfo, SizeOf(IconData.szInfo) - 1);
  IconData.DUMMYUNIONNAME.uTimeout := 3000;
  TipTitle := 'Happyjoe@21cn.com';
  strPLCopy(IconData.szInfoTitle, TipTitle, SizeOf(IconData.szInfoTitle) - 1);
  IconData.dwInfoFlags := NIIF_INFO; //NIIF_ERROR;  //NIIF_WARNING;
  Shell_NotifyIcon(NIM_MODIFY, @IconData);
  {in my testing, the following code has no use}
  IconData.DUMMYUNIONNAME.uVersion := NOTIFYICON_VERSION;
  If Not Shell_NotifyIcon(NIM_SETVERSION, @IconData) Then
    _LogMSG('setversion fail');
End;

Procedure TfrmXmlFunctions.SysTrayIconMsgHandler(Var Msg: TMessage);
Begin
  Case Msg.lParam Of
    WM_MOUSEMOVE: ;
    WM_LBUTTONDOWN: ;
    WM_LBUTTONUP: ;
    WM_LBUTTONDBLCLK: ;
    WM_RBUTTONDOWN: ;
    WM_RBUTTONUP: ;
    WM_RBUTTONDBLCLK: ;
    //followed by the new messages
    NIN_BALLOONSHOW:
    {Sent when the balloon is shown}
      _LogMSG('NIN_BALLOONSHOW');
    NIN_BALLOONHIDE:
    {Sent when the balloon disappears?Rwhen the icon is deleted,
    for example. This message is not sent if the balloon is dismissed because of
    a timeout or mouse click by the user. }
      _LogMSG('NIN_BALLOONHIDE');
    NIN_BALLOONTIMEOUT:
    {Sent when the balloon is dismissed because of a timeout.}
      _LogMSG('NIN_BALLOONTIMEOUT');
    NIN_BALLOONUSERCLICK:
    {Sent when the balloon is dismissed because the user clicked the mouse.
    Note: in XP there's Close button on he balloon tips, when click the button,
    send NIN_BALLOONTIMEOUT message actually.}
      _LogMSG('NIN_BALLOONUSERCLICK');
  End;
End;

Procedure TfrmXmlFunctions.Button6Click(Sender: TObject);
Begin
  ShowBalloonTips;
End;

Procedure TfrmXmlFunctions.btnComExistsClick(Sender: TObject);
Begin
{  If _ComApplicationExists(cDSRCOMCALLER, '') Then
    Showmessage('Com caller installed')
  Else
    Showmessage('Com caller not installed')
    }
End;

Procedure TfrmXmlFunctions.btnInstallMsiClick(Sender: TObject);
Begin
//  _RegisterServer('C:\Projects\Ice\Bin\ComCaller.dll', True);
  ////_ComApplicationInstallMsi('C:\Projects\Ice\msi\DSRCOMCaller.MSI');
//  _ComApplicationInstallMsi('C:\Projects\Ice\msi\dsrcom.msi');
End;

Procedure TfrmXmlFunctions.btnExportComClick(Sender: TObject);
Begin
//  _ComApplicationExport(cDSRCOMCALLER, 'C:\Projects\Ice\msi\DSRCOMCaller.MSI')
End;

Procedure TfrmXmlFunctions.Button11Click(Sender: TObject);
var
  lCrc: cardinal;
  lSize: int64;
  lError: Word;
Begin
  Inherited;

  _CalcFileCRC32(ExtractFilePath(Application.ExeName) + 'Dashboard.exe', lCrc, lSize, lError);

End;

Procedure TfrmXmlFunctions.btnChangeComPropertyClick(Sender: TObject);
Var
  lCatalog: iCOMAdminCatalog;
  lapps: COMAdminCatalogCollection;
  lapp: COMAdminCatalogObject;
  lCont: Integer;
Begin
(*  Try
    lcatalog := CreateOleObject('COMAdmin.COMAdminCatalog') As iCOMAdminCatalog;
    lCatalog.Connect('');
    lApps := lCatalog.GetCollection('Applications') As
      COMAdminCatalogCollection;
    lApps.Populate();

    For lCont := 0 To lapps.Count - 1 Do
    Begin
      lapp := lApps.Item[lCont] As iCatalogObject;
      If lowercase(cDSRCOMCALLER) = lowercase(lapp.Name) Then
      Begin
        lcatalog.CreateServiceForApplication(cDSRCOMCALLER, cDSRCOMCALLER,
          'SERVICE_DEMAND_START', 'SERVICE_ERROR_NORMAL', '', '.\localsystem',
            '', False);
        Result := True;

        Break;
      End;
    End;
  Finally
    lCatalog := Nil;
    lapps := Nil;
    lapp := Nil;
  End;

app.Value("ApplicationAccessChecksEnabled") = 1  ' Enforce COM authorization
app.Value("Authentication") = 6                  ' RPC_C_AUTHN_LEVEL_PKT_PRIVACY
app.Value("AuthenticationCapability") = 2        ' EOAC_SECURE_REFS
app.Value("ImpersonationLevel") = 2              ' RPC_C_IMP_LEVEL_IDENTIFY
collApps.SaveChanges

Now I call a magic function on the catalog object that converts this app to a Windows Service. The parameters are self-explanatory:

cat.CreateServiceForApplication ApplicationName, ApplicationName , "SERVICE_AUTO_START", "SERVICE_ERROR_NORMAL", "", ".\localsystem", "", 0

Next, I add our DLL to the application:

cat.InstallComponent ApplicationName, ApplicationDLL , "", ""

And finally, I am configuring the COM+ roles for the newly created application. Just to bring you up to speed, a COM+ role is an abstracted identity that can be a set of users/groups. I will define one role containing the list of users that can call into the service (the other users will get E_ACCESSDENIED and won't even get hands on a class instance implemented in your DLL). This is what I would call a truly secure COM server :-)

Set collRoles = collApps.GetCollection("Roles", app.Key)
collRoles.Populate
Set role = collRoles.Add
role.Value("Name") = "Administrators"
role.Value("Description") = "Administrators group"
collRoles.SaveChanges
Set collUsersInRole = collRoles.GetCollection("UsersInRole", role.Key)
collUsersInRole.Populate
Set user = collUsersInRole.Add
user.Value("User") = ".\Administrators"
Set user = collUsersInRole.Add
user.Value("User") = "SYSTEM" collUsersInRole.SaveChanges
*)
End;

procedure TfrmXmlFunctions.btnCompanyClick(Sender: TObject);
begin
  ADOTable1.ConnectionString := Format(cADOCONNECTIONSTR3, [_GetComputerName, cicedbpwd, cicedbuser]);
  ADOTable1.TableName := 'outbox';
  ADOTable1.Open;
end;

End.

