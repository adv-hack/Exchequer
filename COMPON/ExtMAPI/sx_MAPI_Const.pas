unit sx_MAPI_Const;

interface

const
  MAPI_NO_COINIT = $8;
  IID_IStream : TGUID = '{0000000C-0000-0000-C000-000000000046}';

  szEmptyString = '';
  szErrorMAPIUninitialized = 'MAPI not initialized!';
  szErrorMAPIInitialized = 'MAPI already initialized!';
  szErrorLoggedIn = 'Already in MAPI session!';
  szErrorDoInit = 'Error in MAPI Initialization';
  szErrorMAPILogon = 'Error in MAPI Logon';
  szErrorCreateNewMsg = 'Could not create new message!';
  szErrorCreateAttach = 'Could not create new attachment for message!';
  szErrorOpenAB = 'Could not open address book!';
  szErrorOpenMessage = 'Could not open message!';
  szErrorOpenUser = 'Could not open user!';
  szErrorOpenAttach = 'Could not open attach for message!';
  szErrorOpenAttachStream = 'Could not open stream for attachment!';
  szErrorApplyFilter = 'Could not apply filter!';
  szErrorGetMessageStore = 'Could not get Message Store!';
  szErrorGetRows = 'Could not get rows data!';
  szErrorGetProperties = 'Could not get properties!';
  szErrorGetEntryIDFolder = 'Could not get EntryID for folder!';
  szErrorGetFolder = 'Could not get folder from Message Store or Parent Folder!';
  szErrorGetFolderContent = 'Could not get messages from folder!';
  szErrorGetName = 'Could not get Name property!';
  szErrorGetRecepients = 'Could not get recepient list!';
  szErrorGetAttachs = 'Could not get attachment list!';
  szErrorSetCols = 'Could not set columns!';
  szErrorSetProps = 'Could not set properties!';
  szErrorSaveMessage = 'Could not save message!';
  szErrorSaveAttachment = 'Could not save attachment!';
  szErrorModifyRecepients = 'Could not modify recepients!';
  szErrorResolveName = 'Could not resolve name!';
  szErrorSendMessage = 'Could not send message!';
  szErrorDeleteMessage = 'Could not delete message!';
  szErrorSetReadFlag = 'Could not set Read flag on message';

  szErrorOutOfBounds = 'Index out of bounds!';

implementation

end.
