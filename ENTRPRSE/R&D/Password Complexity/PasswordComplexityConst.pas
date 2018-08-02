unit PasswordComplexityConst;

interface

uses
  VarRec2U, Messages;

const
  KnownLoginDialogs = 13; // Increase this when adding new Login types

type
  //Copied from GlobType as there were several compilation issues in non core Login dialogs.
  String8  = String[8];
  String10 = String[10];
  String16 = String[16];
  String20 = String[20];
  String30 = String[30];
  String32 = String[32];
  String50 = String[50];
  String64 = String[64];
  String100 = String[100];
  String139 = String[139];
  String200 = String[200];
  String255 = String[255];
  Date    =  String[6];
  LongDate=  String[8];
  
  // Publishes what type of object you have
  TUserObjectMode = (umReadOnly=0, umInsert=1, umUpdate=2, umDelete = 3, umCopy = 4, umLogin = 5);

  TLoginDialog = (ldExchequerCore = 0,
                  ldOLEServer = 1,
                  ldOLEDrillDown = 2,
                  ldOLEDataQuery = 3,
                  ldImporter = 4,
                  ldSentimail = 5,
                  ldMCMBureau = 6,
                  ldeBusiness = 7,
                  ldScheduler = 8,
                  ldTradeCounter = 9,
                  ldOutlookDynamicDashboard = 10,
                  ldExchBackRest = 11,
                  ldGovLink = 12);

  // Enumerations lists the fields of the User Profile entity which can be validated
  TUserFieldsEnum = (udfUserName, udfWindowUserId, udfEmailAddr, udfSecurityAnswer, udfPwdExpiryDate, udfCC, udfDep);
  TUserFieldsSet = Set Of TUserFieldsEnum;

  tPWTreeGrpRec  =  record
                      tCaption: String;
                      IsChild: Byte;
                      PWLink: String;
                      Exclude: Boolean;
                    end;

  //Increased size of array from 913 to 914 for CC/Dept passwords in 6.01
  //Increased size of array, for Sort Views
  tPWTreeGrpAry  =  Array[1..915] of tPWTreeGrpRec;

  const
    SBSPass2 = 'UK585';
    SBSDoor = 'SYSTEM';

    UserStatusDescription : Array[TUserStatus] of String =
    (
      {usActive}                  'Active',
      {usSuspendedAdmin}          'Suspended',
      {usSuspendedLoginFailure}   'Login Failure',
      {usPasswordExpired}         'Pwd Expired'
    );

    SecurityQuestionList : Array[1..6] of String =
    (
      'What was the Make and Model of your first car?',
      'What Town/City were you born in?',
      'What was the name of the first school you attended?',
      'What was the first name of your first boyfriend/girlfriend?',
      'What was the name of your first pet?',
      'What was your mother’s maiden name?'
    );

  LoginDialogCaption : array[0..KnownLoginDialogs - 1] of ShortString = ('Exchequer Login',
                                                                         'Exchequer OLE Server Login',
                                                                         'Exchequer OLE Drill Down Login',
                                                                         'Exchequer OLE Data Query Login',
                                                                         'Exchequer Importer Login',
                                                                         'Sentimail Login',
                                                                         'Bureau Login',
                                                                         'Exchequer eBusiness Module Login',
                                                                         'Exchequer Scheduler Login',
                                                                         'Trade Counter Login',
                                                                         'Outlook Dynamic Dashboard Login',
                                                                         'ExchBackRest Login',
                                                                         'GovLink Login');

  LoginDialogCompanyEnabled : array[0..KnownLoginDialogs - 1] of Boolean = (False,          {ldExchequerCore}
                                                                            False,          {ldOLEServer}
                                                                            False,          {ldOLEDrillDown}
                                                                            False,          {ldOLEDataQuery}
                                                                            True,           {ldImporter}
                                                                            False,          {Sentimail}
                                                                            False,          {ldMCMBureau}
                                                                            False,          {ldeBusiness}
                                                                            False,          {ldScheduler}
                                                                            False,          {ldTradeCounter}
                                                                            True,           {ldOutlookDynamicDashboard}
                                                                            False,          {ldExchBackRest}
                                                                            False);         {ldGovLink}

  LoginDialogForgottenPwdVisible : array[0..KnownLoginDialogs - 1] of Boolean = ( True,     {ldExchequerCore}
                                                                                  True,     {ldOLEServer}
                                                                                  True,     {ldOLEDrillDown}
                                                                                  False,    {ldOLEDataQuery}
                                                                                  True,     {ldImporter}
                                                                                  True,     {Sentimail}
                                                                                  False,    {ldMCMBureau}
                                                                                  True,     {ldeBusiness}
                                                                                  False,    {ldScheduler}
                                                                                  False,    {ldTradeCounter}
                                                                                  True,     {ldOutlookDynamicDashboard}
                                                                                  False,    {ldExchBackRest}
                                                                                  False);   {ldGovLink}

  	AuthMode_Exchequer = 'Exchequer';
    AuthMode_Windows = 'Windows';
    SignDirectoryPath = 'DOCMASTR\';
    CompanyEmailFile = 'COMPANY.TXT';
    CompanyFaxFile = 'COMPANY.TX2';

    cSubject = 'Exchequer Password Reset';

    EmailSubject: Array[1..4] of String = ('Exchequer Password Reset',
                                           'Exchequer Password Reset',
                                           'Exchequer UserID and Password',
                                           'Exchequer UserID and Password');

    EmailMessage: Array[1..4] of String = ( {Reset Password From User List}
                                           'Your Exchequer Password has been reset by the System Administrator, your previous password is no longer valid.'+ #13 +
                                           'Please run Exchequer normally and use the password below on the Login dialog:- '+ #13#13 +
                                           '       New Password : %s' + #13#13 +
                                           'After logging in you will have to choose a new password.'+ #13#13,

                                           {Reset Password From Forgetten Password}
                                           'Your Exchequer Password has been reset by the System Administrator, your previous password is no longer valid.'+ #13 +
                                           'Please run Exchequer normally and use the password below on the Login dialog:- '+ #13#13 +
                                           '       New Password : %s' + #13#13 +
                                           'After logging in you will have to choose a new password.'+ #13#13 +
                                           'If you did not request your password to be reset then' + #13 +
                                           'please contact your system administrator immediately.' + #13#13,

                                           {Send Password From Import with Exchequer Auth}
                                           'Your Exchequer UserID and Password are:-'+ #13#13 +
                                           '       UserID: %s' + #13 +
                                           '       Password: %s' + #13#13 +
                                           'Please run Exchequer normally and use the above credentials.' + #13 +
                                           'After logging in you will have to choose a new password.'+ #13#13,

                                           {Send Password From Import with Windows Auth}
                                           'Your Exchequer UserID is same as your Window UserID'+ #13#13 +
                                           '       UserID: %s' + #13 +
                                           '       Password: Please use your Windows Password to login Exchequer' + #13#13 +
                                           'Please run Exchequer normally and use the above credentials.' + #13#13);

    MsgTypeResetPwd = 1;
    MsgTypeForgettenPwd = 2;
    MsgTypeSendPwdExchq = 3;
    MsgTypeSendPwdWin = 4;

    PWExpModeNeverExp = 0;
    PWExpModeExpDays = 1;
    PWExpModeExpired = 2;

    cSpecialChar = '!"£%$^&*()_-+={}[]@~''#<>,.?/\:;';
    cUpper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    cLower = 'abcdefghijklmnopqrstuvwxyz';
    cNumber = '0123456789';
    cSpaceReplaceChar = 'Þ';
    cSQLNullChar = #10;

    WM_REFRESH = WM_User + 22;
    msgSpecialChar = 'The following characters are considered to be special:-' + #13#13#10 + '! " £ % $ ^ && * ( ) _ - + = { } [ ] @ ~ '' # < > , . ? / \ : ;';
    msgSpecialCharHint = 'The following characters are considered to be special:-' + #13#13#10 + '! " £ % $ ^ & * ( ) _ - + = { } [ ] @ ~ '' # < > , . ? / \ : ;';
    msgEmailSent = 'The Email has been sent to %s';
    msgEmailError = 'It was not possible to send email for the following reason. ';
    msgDeleteUser = '%s Deleted Successfully';
    msgDeleteUserConfirm = 'Please confirm you wish to delete this record';
    msgConfirmQuitUserProfile = 'Save changes to user record %s ?';
    msgConfirmUserAccessSettingYes = 'Would you like to create a user with all the password access settings set to yes ?';
    msgConfirmResetCustom = 'Please confirm you wish to reset all custom settings for this user.';
    msgResetCustom = 'Custom settings deleted for %s.';
    msgResetCustomError = 'Failed to delete custom settings for %s.';
    msgSuspendUser = 'Account has been Suspended due to %s failed login Attempt(s)' + #13#10 + 'Please contact your System Administrator.';
    msgUserInActive = 'User is Suspended or Password has Expired.'+ #13 +'Please contact your System Administrator.';
    msgForgottenPasswordNotAvailable = 'Forgotten Password is not available for this User.' + #13 +'Please contact your System Administrator.';
    msgForgottenPasswordSucess = 'A temporary password has been emailed to you.' + #13 + 'Please check your emails and follow the instructions in the email.';
    msgIncorrectAnswer = 'Incorrect Answer';

    msgInvalidUser = 'User Name or Password is incorrect.';
    msgSuspendedUser = 'Account has been Suspended by Administrator.';
    msgPwdExpired = 'Your Password has expired. ' + #13#10 + 'Please contact your System Administrator.';
    msgSetQuesAns = 'Please set your Security Question and Answer to enable the Forgotten Password option';
    msgPwdExpireWarning = 'Your Password would expire in %s days time, on %s.' + #13#10 +'Please change your Password.';
    msgPwdExpireToday = 'Your Password will expire today. Do you want to change your Password?';
    msgUsernameBlank = 'User Name can not be blank.';
    msgUnknownError = 'Unknown Error ';

    // Import User Const
    csvInvalidFormatMsg = 'Invalid File Format.'+#13#13+'Please refer to the Help File for further details.';
    csvColUserName = 'USERNAME';
    csvColFullName = 'FULLNAME';
    csvColWinUserId = 'WINDOWSUSERID';
    csvColEmailAddr = 'EMAILADDRESS';
    csvHelpContext = 40020;
    csvNotSelectedMsg = 'Please select the CSV file.';
    errFileAlreadyOpened = 'Cannot open file %s as file is already opened.';
    errNoRecordsFound = 'No Records found, please check ''CSV Import Users file''.';
    strUserAdded = 'Number of Users added: %s';
    strUserUpdated = 'Number of Users updated: %s';
    strUserSkipped = 'Number of Users skipped: %s';

    pAccessSentimail = 405;
    errSentimailSecurity = 'User %s is not authorised to access the Sentimail Manager';
    pAccessEBusiness = 319;
    errEbusinessSecurity = 'User %s is not authorised to access the Ebusiness module';

    errUserSecurity = 'User''s security settings not found';
    errAreaCodeRange = 'Area code out of range';

    //RB 25/09/2017 2017-R2 ABSEXCH-18984: 3.1 Exchequer Login Screen - Auditing
    amLoginSuccess = '%s has been successfully logged in.';
    amLoginIncorectUserNamePassword = 'Login Failure for %s due to incorrect User Name or Password.';
    amLoginUserSuspended = 'Login Failure for %s due to User being Suspended.';
    amLoginPasswordExpired = 'Login Failure for %s due to Password expired.';

    amForgottenPwrdSuccess = 'Forgotten Password request has been successfully sent to Email address provided.';
    amForgottenPwrdEmailNotProvided = 'Forgotten Password request has failed due to Email address not provided.';
    amForgottenPwrdSecurityQuesAnsNotSet = 'Forgotten Password request has failed due to security question answer not set.';
    amForgottenPwrdIncorrectAnswer = 'Forgotten Password request has failed due to incorrect answer.';
    amForgottenPwrdIncorredtDefSettings = 'Forgotten Password request has failed due to incorrect default email settings.';

    {$IFDEF IMPV6}
      WM_COMPANYCHANGED = WM_USER + 12460;
    {$ENDIF}
implementation

end.
