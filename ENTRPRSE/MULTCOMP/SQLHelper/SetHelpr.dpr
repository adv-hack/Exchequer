program SetHelpr;

{$ALIGN 1}

uses
  Forms,
  Dialogs,
  SysUtils,
  SQLH_MemMap in 'SQLH_MemMap.Pas',
  CheckSQLObject in 'CheckSQLObject.pas',
  WiseUtil in 'WiseUtil.Pas',
  CheckDBCLR in 'CheckDBCLR.pas',
  CheckAuthMode in 'CheckAuthMode.pas',
  SQLCallerU in '..\..\..\ENTRPRSE\Funcs\SQLCallerU.pas',
  CheckOLEAuto in 'CheckOLEAuto.Pas',
  ShellAPI,
  Windows;

{$R *.res}
const
   EXPIRE_AUTH_INFO_URL = 'http://www.exchequer.com/customer-support/customer-news/news-articles/support-for-authoris-e-ended.aspx';

begin
  // Check command line security parameter
  If FindCmdLineSwitch('SETUPBODGE', ['-', '/', '\'], True) Then
  Begin
    If GlobalSetupMap.Defined Then
    Begin
      DummyParams.szParam := PCHAR(GlobalSetupMap.Params);

      Case GlobalSetupMap.FunctionId Of
        fnCheckSQLObject    : Begin
                                GlobalSetupMap.Result := Setup_CheckSQLObject(DummyParams);
                              End; // fnCheckSQLObject
        fnCheckSQLDBCLR     : Begin
                                GlobalSetupMap.Result := Setup_CheckDBCLR(DummyParams);
                              End; // fnCheckSQLDBCLR
        fnCheckSQLAuthMode  : Begin
                                GlobalSetupMap.Result := Setup_CheckAuthenticationMode(DummyParams);
                              End; // fnCheckSQLAuthMode
        fnCheckSQLOLEAuto   : Begin
                                GlobalSetupMap.Result := Setup_CheckOLEAuto(DummyParams);
                              End; // fnCheckSQLOLEAuto
        fnExpireAuthWebpage : begin
                                //PR: 14/10/2016 v2017 R1 ABSEXCH-17457
                                ShellExecute(0, 'open', EXPIRE_AUTH_INFO_URL, '', '', SW_SHOWNORMAL);
                              end;
      End; // Case GlobalSetupMap.FunctionId
    End; // If GlobalSetupMap.Defined
  End; // If FindCmdLineSwitch('SQLBODGE', ['-', '/', '\'], True)
end.
