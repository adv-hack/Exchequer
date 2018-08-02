unit TestConst;

interface

uses
  Messages;

const

  WM_TESTPROGRESS = WM_USER + 1;
  WM_RUNTEST = WM_USER  + 2;

  LAST_FIELD = 6;

  F_TEST_NAME = 0;
  F_APP_NAME = 1;
  F_RUN = 2;
  F_COMPARE_RESULT = 3;
  F_EXPECTED_RESULT = 4;
  F_COMPARE_DB = 5;
  F_EXTRA_PARAM = 6;

  //Error codes (fit in wParam of Message
  E_BLANK = 0;
  E_SUCCESS = 200;
  E_RUNNING = 201;
  E_INVALID_PARAMS = 202;
  E_OPEN_TOOLKIT = 203;
  E_FILE_NOT_FOUND = 204;

  S_FRAMEWORK_VERSION = 'v1.01';
  S_LIST_NAME = 'TestFramework.csv';
  S_APP_TITLE = 'COM Toolkit Test Framework';
  S_INI_FILE =  'TestFramework.ini';
  S_UNTITLED =  'Untitled';

  STATUS_COL = 5;


implementation

end.                                            
