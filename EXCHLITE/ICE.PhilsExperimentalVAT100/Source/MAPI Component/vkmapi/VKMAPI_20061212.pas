{Copyright:      Vlad Karpov  mailto:KarpovVV@protek.ru
 Author:         Vlad Karpov
 Remarks:        freeware, but this Copyright must be included

 Description:    MAPI components for Delphi

 Version:       V 1.0.1     03.03.2003
             1) add USE_DEFAULT flag in TMAPILogonFlags;
             2) Fix bug:
                     StrToDateTime('01.01.1601') ->
                     EncodeDate(1601, 1, 1)
                makes component independed from locale date format.
             3) Rename the 'MAPIX.pas' to 'VKMAPI.pas'
             4) Makes version for D5, D6, D7 in one packege.

                      Thanks Darryl West for concern.

                V 1.0.2

             1) Fix bug:

        WASTEBOX.IFolder := m_pFolders[ORD(FOLDERS_OUTBOX)];
        WASTEBOX.DisplayName := 'WASTEBOX';

          change to

        WASTEBOX.IFolder := m_pFolders[ORD(FOLDERS_WASTE)];
        WASTEBOX.DisplayName := 'WASTEBOX';

        and change WASTEBOX to SENDBOX when SENDBOX folder opened.

             2) Add functions:

        function TMAPIMessage.GetBody: String;
        function TMAPIMessage.GetRTFBody: String;
        function TMAPIMessage.SetRead(Read: Boolean):Boolean;

        function TMAPIFolder.DeleteMessage(Index: Integer):Boolean;
        function TMAPIFolder.DeleteToWaste(Index: Integer):Boolean;

                      Thanks Roeland Moors for concern.

 * THIS SOFTWARE IS PROVIDED BY THE AUTHORS ''AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}
Unit VKMAPI;

Interface

Uses Windows, Messages, SysUtils, Classes, Dialogs, objidl, ComObj;

Const

  IID_IMAPISession: TGUID = '{00020300-0000-0000-C000-000000000046}';
  IID_IMAPITable: TGUID = '{00020301-0000-0000-C000-000000000046}';
  IID_IMAPIAdviseSink: TGUID = '{00020302-0000-0000-C000-000000000046}';
  IID_IMAPIControl: TGUID = '{0002031B-0000-0000-C000-000000000046}';
  IID_IProfAdmin: TGUID = '{0002031C-0000-0000-C000-000000000046}';
  IID_IMsgServiceAdmin: TGUID = '{0002031D-0000-0000-C000-000000000046}';
  IID_IProviderAdmin: TGUID = '{00020325-0000-0000-C000-000000000046}';
  IID_IMAPIProgress: TGUID = '{0002031F-0000-0000-C000-000000000046}';
  //* MAPIProp or derive from MAPIProp */
  IID_IMAPIProp: TGUID = '{00020303-0000-0000-C000-000000000046}';
  IID_IProfSect: TGUID = '{00020304-0000-0000-C000-000000000046}';
  IID_IMAPIStatus: TGUID = '{00020305-0000-0000-C000-000000000046}';
  IID_IMsgStore: TGUID = '{00020306-0000-0000-C000-000000000046}';
  IID_IMessage: TGUID = '{00020307-0000-0000-C000-000000000046}';
  IID_IAttachment: TGUID = '{00020308-0000-0000-C000-000000000046}';
  IID_IAddrBook: TGUID = '{00020309-0000-0000-C000-000000000046}';
  IID_IMailUser: TGUID = '{0002030A-0000-0000-C000-000000000046}';

  //* MAPIContainer or derive from MAPIContainer */
  IID_IMAPIContainer: TGUID = '{0002030B-0000-0000-C000-000000000046}';
  IID_IMAPIFolder: TGUID = '{0002030C-0000-0000-C000-000000000046}';
  IID_IABContainer: TGUID = '{0002030D-0000-0000-C000-000000000046}';
  IID_IDistList: TGUID = '{0002030E-0000-0000-C000-000000000046}';
  //* MAPI Support Object */
  IID_IMAPISup: TGUID = '{0002030F-0000-0000-C000-000000000046}';
  //* Provider INIT objects */
  IID_IMSProvider: TGUID = '{00020310-0000-0000-C000-000000000046}';
  IID_IABProvider: TGUID = '{00020311-0000-0000-C000-000000000046}';
  IID_IXPProvider: TGUID = '{00020312-0000-0000-C000-000000000046}';
  //* Provider LOGON Objects */
  IID_IMSLogon: TGUID = '{00020313-0000-0000-C000-000000000046}';
  IID_IABLogon: TGUID = '{00020314-0000-0000-C000-000000000046}';
  IID_IXPLogon: TGUID = '{00020315-0000-0000-C000-000000000046}';
  //* IMAPITable-in-memory Table Data Object */
  IID_IMAPITableData: TGUID = '{00020316-0000-0000-C000-000000000046}';
  //* MAPI Spooler Init Object (internal) */
  IID_IMAPISpoolerInit: TGUID = '{00020317-0000-0000-C000-000000000046}';

  //* MAPI Spooler Session Object (internal) */
  IID_IMAPISpoolerSession: TGUID = '{00020318-0000-0000-C000-000000000046}';

  //* MAPI TNEF Object Interface */
  IID_ITNEF: TGUID = '{00020319-0000-0000-C000-000000000046}';
  //* IMAPIProp-in-memory Property Data Object */
  IID_IMAPIPropData: TGUID = '{0002031A-0000-0000-C000-000000000046}';
  //* MAPI Spooler Hook Object */
  IID_ISpoolerHook: TGUID = '{00020320-0000-0000-C000-000000000046}';
  //* MAPI Spooler Service Object */
  IID_IMAPISpoolerService: TGUID = '{0002031E-0000-0000-C000-000000000046}';
  //* MAPI forms, form manager, etc. */
  IID_IMAPIViewContext: TGUID = '{00020321-0000-0000-C000-000000000046}';
  IID_IMAPIFormMgr: TGUID = '{00020322-0000-0000-C000-000000000046}';
  IID_IEnumMAPIFormProp: TGUID = '{00020323-0000-0000-C000-000000000046}';
  IID_IMAPIFormInfo: TGUID = '{00020324-0000-0000-C000-000000000046}';
  IID_IMAPIForm: TGUID = '{00020327-0000-0000-C000-000000000046}';
  //* Well known guids for name<->id mappings */
  //*  The name of MAPI's property set  */
  PS_MAPI: TGUID = '{00020328-0000-0000-C000-000000000046}';
  //*  The name of the set of public strings  */
  PS_PUBLIC_STRINGS: TGUID = '{00020329-0000-0000-C000-000000000046}';
  //* MAPI forms, form manager, (cont) */
  IID_IPersistMessage: TGUID = '{0002032A-0000-0000-C000-000000000046}';
  //* IMAPIViewAdviseSink */
  IID_IMAPIViewAdviseSink: TGUID = '{0002032B-0000-0000-C000-000000000046}';
  //* Message Store OpenProperty */
  IID_IStreamDocfile: TGUID = '{0002032C-0000-0000-C000-000000000046}';
  //* IMAPIFormProp */
  IID_IMAPIFormProp: TGUID = '{0002032D-0000-0000-C000-000000000046}';
  //* IMAPIFormContainer */
  IID_IMAPIFormContainer: TGUID = '{0002032E-0000-0000-C000-000000000046}';
  //* IMAPIFormAdviseSink */
  IID_IMAPIFormAdviseSink: TGUID = '{0002032F-0000-0000-C000-000000000046}';
  //* TNEF OpenProperty */
  IID_IStreamTnef: TGUID = '{00020330-0000-0000-C000-000000000046}';
  //* IMAPIFormFactory */
  IID_IMAPIFormFactory: TGUID = '{00020350-0000-0000-C000-000000000046}';
  //* IMAPIMessageSite */
  IID_IMAPIMessageSite: TGUID = '{00020370-0000-0000-C000-000000000046}';
  //* Well known guids routing property sets.
  //   Usefull when writing applications that route documents
  //   (i.e. Workflow) across gateways.  Gateways that speak MAPI
  //   should convert the properties found in the follow property
  //   sets appropriately. */
  //*  PS_ROUTING_EMAIL_ADDRESSES:  Addresses that need converting at gateways, etc. */
  PS_ROUTING_EMAIL_ADDRESSES: TGUID = '{00020380-0000-0000-C000-000000000046}';
  //*  PS_ROUTING_ADDRTYPE:  Address types that need converting at gateways, etc. */
  PS_ROUTING_ADDRTYPE: TGUID = '{00020381-0000-0000-C000-000000000046}';
  //*  PS_ROUTING_DISPLAY_NAME:  Display Name that corresponds to the other props */
  PS_ROUTING_DISPLAY_NAME: TGUID = '{00020382-0000-0000-C000-000000000046}';
  //*  PS_ROUTING_ENTRYID:  (optional) EntryIDs that need converting at gateways, etc. */
  PS_ROUTING_ENTRYID: TGUID = '{00020383-0000-0000-C000-000000000046}';
  //*  PS_ROUTING_SEARCH_KEY:  (optional) search keys that need converting at gateways, etc. */
  PS_ROUTING_SEARCH_KEY: TGUID = '{00020384-0000-0000-C000-000000000046}';
  ///*  MUID_PROFILE_INSTANCE
  //    Well known section in a profile which contains a property (PR_SEARCH_KEY) which is unique
  //    for any given profile.  Applications and providers can depend on this value as being
  //    different for each unique profile. */
  MUID_PROFILE_INSTANCE: TGUID = '{00020385-0000-0000-C000-000000000046}';

  MAX_SNDR = 20;
  MAX_SUBJ = 40;

  MAPI_DIM = 1;

  MAPI_MODIFY = $00000001;

  MAPI_INIT_VERSION = 0;
  MAPI_MULTITHREAD_NOTIFICATIONS = $00000001;

  MAPI_LOGOFF_SHARED = $00000001; //* Close all shared sessions    */
  MAPI_LOGOFF_UI = $00000002; //* It's OK to present UI        */

  {MAPILogon() flags.}
  MAPI_LOGON_UI = $00000001; //* Display logon UI                 */
  MAPI_NEW_SESSION = $00000002; //* Don't use shared session         */
  MAPI_ALLOW_OTHERS = $00000008; //* Make this a shared session       */
  MAPI_EXPLICIT_PROFILE = $00000010; //* Don't use default profile        */
  MAPI_EXTENDED = $00000020; //* Extended MAPI Logon              */
  MAPI_FORCE_DOWNLOAD = $00001000; //* Get new mail before return       */
  MAPI_SERVICE_UI_ALWAYS = $00002000; //* Do logon UI in all providers     */
  MAPI_NO_MAIL = $00008000; //* Do not activate transports       */
  MAPI_NT_SERVICE = $00010000; //* Allow logon from an NT service   */
  MAPI_PASSWORD_UI = $00020000; //* Display password UI only         */
  MAPI_TIMEOUT_SHORT = $00100000; //* Minimal wait for logon resources */

  MAPI_SIMPLE_DEFAULT = (MAPI_LOGON_UI Or MAPI_FORCE_DOWNLOAD Or MAPI_ALLOW_OTHERS);
  MAPI_SIMPLE_EXPLICIT = (MAPI_NEW_SESSION Or MAPI_FORCE_DOWNLOAD Or
    MAPI_EXPLICIT_PROFILE);

  //*  PR_STORE_SUPPORT_MASK bits */
  STORE_ENTRYID_UNIQUE = $00000001;
  STORE_READONLY = $00000002;
  STORE_SEARCH_OK = $00000004;
  STORE_MODIFY_OK = $00000008;
  STORE_CREATE_OK = $00000010;
  STORE_ATTACH_OK = $00000020;
  STORE_OLE_OK = $00000040;
  STORE_SUBMIT_OK = $00000080;
  STORE_NOTIFY_OK = $00000100;
  STORE_MV_PROPS_OK = $00000200;
  STORE_CATEGORIZE_OK = $00000400;
  STORE_RTF_OK = $00000800;
  STORE_RESTRICTION_OK = $00001000;
  STORE_SORT_OK = $00002000;
  STORE_PUBLIC_FOLDERS = $00004000;
  STORE_UNCOMPRESSED_RTF = $00008000;

  //* PR_STORE_STATE bits, try not to collide with PR_STORE_SUPPORT_MASK */

  STORE_HAS_SEARCHES = $01000000;

  PROP_TYPE_MASK = $0000FFFF; //* Mask for Property type */
  PROP_ID_NULL = 0;
  PROP_ID_INVALID = $FFFF;

  //* OpenEntry() */

  //****** MAPI_MODIFY             ((ULONG) 0x00000001) above */
  //****** MAPI_DEFERRED_ERRORS    ((ULONG) 0x00000008) below */
  //****** MAPI_BEST_ACCESS        ((ULONG) 0x00000010) above */

  //* SetReceiveFolder() */

  //****** MAPI_UNICODE            ((ULONG) 0x80000000) above */

  //* GetReceiveFolder() */

  //****** MAPI_UNICODE            ((ULONG) 0x80000000) above */

  //* GetReceiveFolderTable() */

  //****** MAPI_DEFERRED_ERRORS    ((ULONG) 0x00000008) below */

  //* StoreLogoff() */

  LOGOFF_NO_WAIT = $00000001;
  LOGOFF_ORDERLY = $00000002;
  LOGOFF_PURGE = $00000004;
  LOGOFF_ABORT = $00000008;
  LOGOFF_QUIET = $00000010;

  LOGOFF_COMPLETE = $00010000;
  LOGOFF_INBOUND = $00020000;
  LOGOFF_OUTBOUND = $00040000;
  LOGOFF_OUTBOUND_QUEUE = $00080000;

  //* SetLockState() */

  MSG_LOCKED = $00000001;
  MSG_UNLOCKED = $00000000;

  //* Flag bits for PR_VALID_FOLDER_MASK */

  FOLDER_IPM_SUBTREE_VALID = $00000001;
  FOLDER_IPM_INBOX_VALID = $00000002;
  FOLDER_IPM_OUTBOX_VALID = $00000004;
  FOLDER_IPM_WASTEBASKET_VALID = $00000008;
  FOLDER_IPM_SENTMAIL_VALID = $00000010;
  FOLDER_VIEWS_VALID = $00000020;
  FOLDER_COMMON_VIEWS_VALID = $00000040;
  FOLDER_FINDER_VALID = $00000080;

  //* Flags for OpenAddressBook */

  AB_NO_DIALOG = $00000001;

  {/* Table status */}

  TBLSTAT_COMPLETE = 0;
  TBLSTAT_QCHANGED = 7;
  TBLSTAT_SORTING = 9;
  TBLSTAT_SORT_ERROR = 10;
  TBLSTAT_SETTING_COLS = 11;
  TBLSTAT_SETCOL_ERROR = 13;
  TBLSTAT_RESTRICTING = 14;
  TBLSTAT_RESTRICT_ERROR = 15;

  {/* Table Type */}

  TBLTYPE_SNAPSHOT = 0;
  TBLTYPE_KEYSET = 1;
  TBLTYPE_DYNAMIC = 2;

  {/* Sort order */}

  {/* bit 0: set if descending, clear if ascending */}

  TABLE_SORT_ASCEND = $00000000;
  TABLE_SORT_DESCEND = $00000001;
  TABLE_SORT_COMBINE = $00000002;

  BOOKMARK_BEGINNING = 0; //* Before first row */
  BOOKMARK_CURRENT = 01; //* Before current row */
  BOOKMARK_END = 02; //* After last row */

  {/* Fuzzy Level */}

  FL_FULLSTRING = $00000000;
  FL_SUBSTRING = $00000001;
  FL_PREFIX = $00000002;

  FL_IGNORECASE = $00010000;
  FL_IGNORENONSPACE = $00020000;
  FL_LOOSE = $00040000;

  //* Restriction types */

  RES_AND = $00000000;
  RES_OR = $00000001;
  RES_NOT = $00000002;
  RES_CONTENT = $00000003;
  RES_PROPERTY = $00000004;
  RES_COMPAREPROPS = $00000005;
  RES_BITMASK = $00000006;
  RES_SIZE = $00000007;
  RES_EXIST = $00000008;
  RES_SUBRESTRICTION = $00000009;
  RES_COMMENT = $0000000A;

  //* Relational operators. These apply to all property comparison restrictions. */

  RELOP_LT = 0; //* <  */
  RELOP_LE = 1; //* <= */
  RELOP_GT = 2; //* >  */
  RELOP_GE = 3; //* >= */
  RELOP_EQ = 4; //* == */
  RELOP_NE = 5; //* != */
  RELOP_RE = 6; //* LIKE (Regular expression) */

  //* Bitmask operators, for RES_BITMASK only. */

  BMR_EQZ = 0; //* ==0 */
  BMR_NEZ = 1; //* !=0 */

  //* Subobject identifiers for RES_SUBRESTRICTION only. See MAPITAGS.H. */

  //* #define PR_MESSAGE_RECIPIENTS  PROP_TAG(PT_OBJECT,0x0E12) */
  //* #define PR_MESSAGE_ATTACHMENTS PROP_TAG(PT_OBJECT,0x0E13) */

  //* Property Types */

  MV_FLAG = $1000; //* Multi-value flag */

  PT_UNSPECIFIED = 0;
    //* (Reserved for interface use) type doesn't matter to caller */
  PT_NULL = 1; //* NULL property value */
  PT_I2 = 2; //* Signed 16-bit value */
  PT_LONG = 3; //* Signed 32-bit value */
  PT_R4 = 4; //* 4-byte floating point */
  PT_DOUBLE = 5; //* Floating point double */
  PT_CURRENCY = 6;
    //* Signed 64-bit int (decimal w/    4 digits right of decimal pt) */
  PT_APPTIME = 7; //* Application time */
  PT_ERROR = 10; //* 32-bit error value */
  PT_BOOLEAN = 11; //* 16-bit boolean (non-zero true) */
  PT_OBJECT = 13; //* Embedded object in a property */
  PT_I8 = 20; //* 8-byte signed integer */
  PT_STRING8 = 30; //* Null terminated 8-bit character string */
  PT_UNICODE = 31; //* Null terminated Unicode string */
  PT_SYSTIME = 64;
    //* FILETIME 64-bit int w/ number of 100ns periods since Jan 1,1601 */
  PT_CLSID = 72; //* OLE GUID */
  PT_BINARY = 258; //* Uninterpreted (counted byte array) */
  //* Changes are likely to these numbers, and to their structures. */

  //* Alternate property type names for ease of use */
  PT_SHORT = PT_I2;
  PT_I4 = PT_LONG;
  PT_FLOAT = PT_R4;
  PT_R8 = PT_DOUBLE;
  PT_LONGLONG = PT_I8;

  PT_TSTRING = PT_STRING8;
  PT_MV_TSTRING = (MV_FLAG Or PT_STRING8);

  //* Multi-valued Property Types */

  PT_MV_I2 = (MV_FLAG Or PT_I2);
  PT_MV_LONG = (MV_FLAG Or PT_LONG);
  PT_MV_R4 = (MV_FLAG Or PT_R4);
  PT_MV_DOUBLE = (MV_FLAG Or PT_DOUBLE);
  PT_MV_CURRENCY = (MV_FLAG Or PT_CURRENCY);
  PT_MV_APPTIME = (MV_FLAG Or PT_APPTIME);
  PT_MV_SYSTIME = (MV_FLAG Or PT_SYSTIME);
  PT_MV_STRING8 = (MV_FLAG Or PT_STRING8);
  PT_MV_BINARY = (MV_FLAG Or PT_BINARY);
  PT_MV_UNICODE = (MV_FLAG Or PT_UNICODE);
  PT_MV_CLSID = (MV_FLAG Or PT_CLSID);
  PT_MV_I8 = (MV_FLAG Or PT_I8);

  //* Alternate property type names for ease of use */
  PT_MV_SHORT = PT_MV_I2;
  PT_MV_I4 = PT_MV_LONG;
  PT_MV_FLOAT = PT_MV_R4;
  PT_MV_R8 = PT_MV_DOUBLE;
  PT_MV_LONGLONG = PT_MV_I8;

  //
  // *  Property type reserved bits
  // *
  // *  MV_INSTANCE is used as a flag in table operations to request
  // *  that a multi-valued property be presented as a single-valued
  // *  property appearing in multiple rows.
  // */

  MV_INSTANCE = $2000;
  MVI_FLAG = (MV_FLAG Or MV_INSTANCE);
  //MVI_PROP(tag)   ((tag) | MVI_FLAG)

  fnevCriticalError = $00000001;
  fnevNewMail = $00000002;
  fnevObjectCreated = $00000004;
  fnevObjectDeleted = $00000008;
  fnevObjectModified = $00000010;
  fnevObjectMoved = $00000020;
  fnevObjectCopied = $00000040;
  fnevSearchComplete = $00000080;
  fnevTableModified = $00000100;
  fnevStatusObjectModified = $00000200;
  fnevReservedForMapi = $40000000;
  fnevExtended = $80000000;

  //* TABLE_NOTIFICATION event types passed in ulTableEvent */

  TABLE_CHANGED = 1;
  TABLE_ERROR = 2;
  TABLE_ROW_ADDED = 3;
  TABLE_ROW_DELETED = 4;
  TABLE_ROW_MODIFIED = 5;
  TABLE_SORT_DONE = 6;
  TABLE_RESTRICT_DONE = 7;
  TABLE_SETCOL_DONE = 8;
  TABLE_RELOAD = 9;

  //* IMAPIFolder folder type (enum) */

  FOLDER_ROOT = $00000000;
  FOLDER_GENERIC = $00000001;
  FOLDER_SEARCH = $00000002;

  //* CreateMessage */
  //****** MAPI_DEFERRED_ERRORS    ((ULONG) 0x00000008) below */
  //****** MAPI_ASSOCIATED         ((ULONG) 0x00000040) below */

  //* CopyMessages */

  MESSAGE_MOVE = $00000001;
  MESSAGE_DIALOG = $00000002;
  //****** MAPI_DECLINE_OK         ((ULONG) 0x00000004) above */

  //* CreateFolder */

  OPEN_IF_EXISTS = $00000001;
  //****** MAPI_DEFERRED_ERRORS    ((ULONG) 0x00000008) below */
  //****** MAPI_UNICODE            ((ULONG) 0x80000000) above */

  //* DeleteFolder */

  DEL_MESSAGES = $00000001;
  FOLDER_DIALOG = $00000002;
  DEL_FOLDERS = $00000004;

  //* EmptyFolder */
  DEL_ASSOCIATED = $00000008;

  //* CopyFolder */

  FOLDER_MOVE = $00000001;
  //****** FOLDER_DIALOG           ((ULONG) 0x00000002) above */
  //****** MAPI_DECLINE_OK         ((ULONG) 0x00000004) above */
  COPY_SUBFOLDERS = 00000010;
  //****** MAPI_UNICODE            ((ULONG) 0x80000000) above */

  //* SetReadFlags */

  //****** SUPPRESS_RECEIPT        ((ULONG) 0x00000001) below */
  //****** FOLDER_DIALOG           ((ULONG) 0x00000002) above */
  //****** CLEAR_READ_FLAG         ((ULONG) 0x00000004) below */
  //****** MAPI_DEFERRED_ERRORS    ((ULONG) 0x00000008) below */
  //****** GENERATE_RECEIPT_ONLY   ((ULONG) 0x00000010) below */
  //****** CLEAR_RN_PENDING        ((ULONG) 0x00000020) below */
  //****** CLEAR_NRN_PENDING       ((ULONG) 0x00000040) below */

  //* GetMessageStatus */

  MSGSTATUS_HIGHLIGHTED = $00000001;
  MSGSTATUS_TAGGED = $00000002;
  MSGSTATUS_HIDDEN = $00000004;
  MSGSTATUS_DELMARKED = $00000008;

  //* Bits for remote message status */

  MSGSTATUS_REMOTE_DOWNLOAD = $00001000;
  MSGSTATUS_REMOTE_DELETE = $00002000;

  //* SaveContentsSort */

  RECURSIVE_SORT = $00000002;

  //* PR_STATUS property */

  FLDSTATUS_HIGHLIGHTED = $00000001;
  FLDSTATUS_TAGGED = $00000002;
  FLDSTATUS_HIDDEN = $00000004;
  FLDSTATUS_DELMARKED = $00000008;

  //* SubmitMessage */

  FORCE_SUBMIT = $00000001;

  //* Flags defined in PR_MESSAGE_FLAGS */

  MSGFLAG_READ = $00000001;
  MSGFLAG_UNMODIFIED = $00000002;
  MSGFLAG_SUBMIT = $00000004;
  MSGFLAG_UNSENT = $00000008;
  MSGFLAG_HASATTACH = $00000010;
  MSGFLAG_FROMME = $00000020;
  MSGFLAG_ASSOCIATED = $00000040;
  MSGFLAG_RESEND = $00000080;
  MSGFLAG_RN_PENDING = $00000100;
  MSGFLAG_NRN_PENDING = $00000200;

  //* Flags defined in PR_SUBMIT_FLAGS */

  SUBMITFLAG_LOCKED = $00000001;
  SUBMITFLAG_PREPROCESS = $00000002;

  //* GetAttachmentTable() */
  //****** MAPI_UNICODE            ((ULONG) 0x80000000) above */

  //* GetRecipientTable() */
  //****** MAPI_UNICODE            ((ULONG) 0x80000000) above */

  //* ModifyRecipients */

  //* ((ULONG) 0x00000001 is not a valid flag on ModifyRecipients. */
  MODRECIP_ADD = $00000002;
  MODRECIP_MODIFY = $00000004;
  MODRECIP_REMOVE = $00000008;

  //* SetReadFlag */

  SUPPRESS_RECEIPT = $00000001;
  CLEAR_READ_FLAG = $00000004;
  //****** MAPI_DEFERRED_ERRORS    ((ULONG) 0x00000008) below */
  GENERATE_RECEIPT_ONLY = $00000010;
  CLEAR_RN_PENDING = $00000020;
  CLEAR_NRN_PENDING = $00000040;

  //* DeleteAttach */

  ATTACH_DIALOG = $00000001;

  //* PR_SECURITY values */
  SECURITY_SIGNED = $00000001;
  SECURITY_ENCRYPTED = $00000002;

  //* PR_PRIORITY values */
  PRIO_URGENT = 1;
  PRIO_NORMAL = 0;
  PRIO_NONURGENT = -1;

  //* PR_SENSITIVITY values */
  SENSITIVITY_NONE = $00000000;
  SENSITIVITY_PERSONAL = $00000001;
  SENSITIVITY_PRIVATE = $00000002;
  SENSITIVITY_COMPANY_CONFIDENTIAL = $00000003;

  //* PR_IMPORTANCE values */
  IMPORTANCE_LOW = 0;
  IMPORTANCE_NORMAL = 1;
  IMPORTANCE_HIGH = 2;

  //* GetLastError */
  //****** MAPI_UNICODE            ((ULONG) 0x80000000) above */

  //*
  // *  Version:
  // */
  MAPI_ERROR_VERSION = $00000000;

  //* GetPropList */
  //****** MAPI_UNICODE            ((ULONG) 0x80000000) above */

  //* GetProps */
  //****** MAPI_UNICODE            ((ULONG) 0x80000000) above */

  //* SaveChanges */

  KEEP_OPEN_READONLY = $00000001;
  KEEP_OPEN_READWRITE = $00000002;
  FORCE_SAVE = $00000004;
  //* define MAPI_DEFERRED_ERRORS  ((ULONG) 0x00000008) below */

  //* OpenProperty  - ulFlags */
  //****** MAPI_MODIFY             ((ULONG) 0x00000001) above */
  MAPI_CREATE = $00000002;
  STREAM_APPEND = $00000004;
  //****** MAPI_DEFERRED_ERRORS    ((ULONG) 0x00000008) below */

  //* OpenProperty  - ulInterfaceOptions, IID_IMAPITable */
  //****** MAPI_UNICODE            ((ULONG) 0x80000000) above */

  //* CopyTo, CopyProps */

  MAPI_MOVE = $00000001;
  MAPI_NOREPLACE = $00000002;
  MAPI_DECLINE_OK = $00000004;

  MAPI_DIALOG = $00000008;

  MAPI_USE_DEFAULT = $00000040; //* Use default profile in logon */

  //* Flags used in GetIDsFromNames  */
  //****** MAPI_CREATE             ((ULONG) 0x00000002) above */

  //* Flags used in GetNamesFromIDs  (bit fields) */
  MAPI_NO_STRINGS = $00000001;
  MAPI_NO_IDS = $00000002;

  //*  Union discriminator  */
  MNID_ID = 0;
  MNID_STRING = 1;

  //* --------------------------------- */
  //* Address Book interface definition */

  //* ADRPARM ulFlags - top 4 bits used for versioning */

  //GET_ADRPARM_VERSION(ulFlags)  (((ULONG)ulFlags) & 0xF0000000)
  //SET_ADRPARM_VERSION(ulFlags, ulVersion)  (((ULONG)ulVersion) | (((ULONG)ulFlags) & 0x0FFFFFFF))

  //*  Current versions of ADRPARM  */
  ADRPARM_HELP_CTX = $00000000;

  //*  ulFlags   - bit fields */
  DIALOG_MODAL = $000000001;
  DIALOG_SDI = $000000002;
  DIALOG_OPTIONS = $000000004;
  ADDRESS_ONE = $000000008;
  AB_SELECTONLY = $000000010;
  AB_RESOLVE = $000000020;

  //* --------------------------------- */
  //*  PR_DISPLAY_TYPEs                 */
  //*
  // *  These standard display types are
  // *  by default handled by MAPI.
  // *  They have default icons associated
  // *  with them.
  // */

  //*  For address book contents tables */
  DT_MAILUSER = $000000000;
  DT_DISTLIST = $000000001;
  DT_FORUM = $000000002;
  DT_AGENT = $000000003;
  DT_ORGANIZATION = $000000004;
  DT_PRIVATE_DISTLIST = $000000005;
  DT_REMOTE_MAILUSER = $000000006;

  //*  For address book hierarchy tables */
  DT_MODIFIABLE = $000010000;
  DT_GLOBAL = $000020000;
  DT_LOCAL = $000030000;
  DT_WAN = $000040000;
  DT_NOT_SPECIFIC = $000050000;

  //*  For folder hierarchy tables */
  DT_FOLDER = $001000000;
  DT_FOLDER_LINK = $002000000;
  DT_FOLDER_SPECIAL = $004000000;

  ///* ------------ */
  ///* Random flags */

  //* Flag for deferred error */
  MAPI_DEFERRED_ERRORS = $00000008;

  //* Flag for creating and using Folder Associated Information Messages */
  MAPI_ASSOCIATED = $00000040;

  //* Flags for OpenMessageStore() */

  MDB_NO_DIALOG = $00000001;
  MDB_WRITE = $00000004;
  //****** MAPI_DEFERRED_ERRORS    ((ULONG) 0x00000008) above */
  //****** MAPI_BEST_ACCESS        ((ULONG) 0x00000010) above */
  MDB_TEMPORARY = $00000020;
  MDB_NO_MAIL = $00000080;

  //added by vini
  MDB_ONLINE = $00000100;

  //* Flags for OpenAddressBook */

  //* IMAPIControl Interface -------------------------------------------------- */

  //* Interface used in controls (particularly the button) defined by */
  //* Display Tables. */

  //*  Flags for GetState */

  MAPI_ENABLED = $00000000;
  MAPI_DISABLED = $00000001;

  //* Object type */

  MAPI_STORE = $00000001; //* Message Store */
  MAPI_ADDRBOOK = $00000002; //* Address Book */
  MAPI_FOLDER = $00000003; //* Folder */
  MAPI_ABCONT = $00000004; //* Address Book Container */
  MAPI_MESSAGE = $00000005; //* Message */
  MAPI_MAILUSER = $00000006; //* Individual Recipient */
  MAPI_ATTACH = $00000007; //* Attachment */
  MAPI_DISTLIST = $00000008; //* Distribution List Recipient */
  MAPI_PROFSECT = $00000009; //* Profile Section */
  MAPI_STATUS = $0000000A; //* Status Object */
  MAPI_SESSION = $0000000B; //* Session */
  MAPI_FORMINFO = $0000000C; //* Form Information */

  SUCCESS_SUCCESS = 0;
  MAPI_USER_ABORT = 1;
  MAPI_E_USER_ABORT = MAPI_USER_ABORT;
  MAPI_E_FAILURE = 2;
  MAPI_E_LOGON_FAILURE = 3;
  MAPI_E_LOGIN_FAILURE = MAPI_E_LOGON_FAILURE;
  MAPI_E_DISK_FULL = 4;
  MAPI_E_INSUFFICIENT_MEMORY = 5;
  MAPI_E_ACCESS_DENIED = 6;
  MAPI_E_TOO_MANY_SESSIONS = 8;
  MAPI_E_TOO_MANY_FILES = 9;
  MAPI_E_TOO_MANY_RECIPIENTS = 10;
  MAPI_E_ATTACHMENT_NOT_FOUND = 11;
  MAPI_E_ATTACHMENT_OPEN_FAILURE = 12;
  MAPI_E_ATTACHMENT_WRITE_FAILURE = 13;
  MAPI_E_UNKNOWN_RECIPIENT = 14;
  MAPI_E_BAD_RECIPTYPE = 15;
  MAPI_E_NO_MESSAGES = 16;
  MAPI_E_INVALID_MESSAGE = 17;
  MAPI_E_TEXT_TOO_LARGE = 18;
  MAPI_E_INVALID_SESSION = 19;
  MAPI_E_TYPE_NOT_SUPPORTED = 20;
  MAPI_E_AMBIGUOUS_RECIPIENT = 21;
  MAPI_E_AMBIG_RECIP = MAPI_E_AMBIGUOUS_RECIPIENT;
  MAPI_E_MESSAGE_IN_USE = 22;
  MAPI_E_NETWORK_FAILURE = 23;
  MAPI_E_INVALID_EDITFIELDS = 24;
  MAPI_E_INVALID_RECIPS = 25;
  MAPI_E_NOT_SUPPORTED = 26;

  //* Values for PR_RESOURCE_TYPE, _METHODS, _FLAGS */

  MAPI_STORE_PROVIDER = 33; //* Message Store */
  MAPI_AB = 34; //* Address Book */
  MAPI_AB_PROVIDER = 35; //* Address Book Provider */
  MAPI_TRANSPORT_PROVIDER = 36; //* Transport Provider */
  MAPI_SPOOLER = 37; //* Message Spooler */
  MAPI_PROFILE_PROVIDER = 38; //* Profile Provider */
  MAPI_SUBSYSTEM = 39; //* Overall Subsystem Status */
  MAPI_HOOK_PROVIDER = 40; //* Spooler Hook */

  STATUS_VALIDATE_STATE = $00000001;
  STATUS_SETTINGS_DIALOG = $00000002;
  STATUS_CHANGE_PASSWORD = $00000004;
  STATUS_FLUSH_QUEUES = $00000008;

  STATUS_DEFAULT_OUTBOUND = $00000001;
  STATUS_DEFAULT_STORE = $00000002;
  STATUS_PRIMARY_IDENTITY = $00000004;
  STATUS_SIMPLE_STORE = $00000008;
  STATUS_XP_PREFER_LAST = $00000010;
  STATUS_NO_PRIMARY_IDENTITY = $00000020;
  STATUS_NO_DEFAULT_STORE = $00000040;
  STATUS_TEMP_SECTION = $00000080;
  STATUS_OWN_STORE = $00000100;
  //****** HOOK_INBOUND            ((ULONG) 0x00000200) Defined in MAPIHOOK.H */
  //****** HOOK_OUTBOUND           ((ULONG) 0x00000400) Defined in MAPIHOOK.H */
  STATUS_NEED_IPM_TREE = $00000800;
  STATUS_PRIMARY_STORE = $00001000;
  STATUS_SECONDARY_STORE = $00002000;

  //*
  // * PR_STATUS_CODE bit. Low 16 bits for common values; High 16 bits
  // * for provider type-specific values. (DCR 304)
  // */

  STATUS_AVAILABLE = $00000001;
  STATUS_OFFLINE = $00000002;
  STATUS_FAILURE = $00000004;

  //* Transport values of PR_STATUS_CODE */

  STATUS_INBOUND_ENABLED = $00010000;
  STATUS_INBOUND_ACTIVE = $00020000;
  STATUS_INBOUND_FLUSH = $00040000;
  STATUS_OUTBOUND_ENABLED = $00100000;
  STATUS_OUTBOUND_ACTIVE = $00200000;
  STATUS_OUTBOUND_FLUSH = $00400000;
  STATUS_REMOTE_ACCESS = $00800000;

  //* ValidateState flags */

  SUPPRESS_UI = $00000001;
  REFRESH_XP_HEADER_CACHE = $00010000;
  PROCESS_XP_HEADER_CACHE = $00020000;
  FORCE_XP_CONNECT = $00040000;
  FORCE_XP_DISCONNECT = $00080000;
  CONFIG_CHANGED = $00100000;
  ABORT_XP_HEADER_OPERATION = $00200000;
  SHOW_XP_SESSION_UI = $00400000;

  //* SettingsDialog flags */

  UI_READONLY = $00000001;

  //* FlushQueues flags */

  FLUSH_UPLOAD = $00000002;
  FLUSH_DOWNLOAD = $00000004;
  FLUSH_FORCE = $00000008;
  FLUSH_NO_UI = $00000010;
  FLUSH_ASYNC_OK = $00000020;

  //* Flags for OpenEntry() */

  //****** MAPI_MODIFY             ((ULONG) 0x00000001) above */
  //****** MAPI_DEFERRED_ERRORS    ((ULONG) 0x00000008) below */
  MAPI_BEST_ACCESS = $00000010;
  MAPI_NO_CACHE = $00000200;

  //* GetContentsTable() */
  //****** MAPI_UNICODE            ((ULONG) 0x80000000) above */
  //****** MAPI_DEFERRED_ERRORS    ((ULONG) 0x00000008) below */
  //****** MAPI_ASSOCIATED         ((ULONG) 0x00000040) below */

  //* GetHierarchyTable() */
  //****** MAPI_UNICODE            ((ULONG) 0x80000000) above */
  CONVENIENT_DEPTH = $00000001;
  //****** MAPI_DEFERRED_ERRORS    ((ULONG) 0x00000008) below */

  //* GetSearchCriteria */
  //****** MAPI_UNICODE            ((ULONG) 0x80000000) above */
  SEARCH_RUNNING = $00000001;
  SEARCH_REBUILD = $00000002;
  SEARCH_RECURSIVE = $00000004;
  SEARCH_FOREGROUND = $00000008;

  //* SetSearchCriteria */
  STOP_SEARCH = $00000001;
  RESTART_SEARCH = $00000002;
  RECURSIVE_SEARCH = $00000004;
  SHALLOW_SEARCH = $00000008;
  FOREGROUND_SEARCH = $00000010;
  BACKGROUND_SEARCH = $00000020;

  FLUSH_FLAGS = FLUSH_UPLOAD Or FLUSH_DOWNLOAD Or FLUSH_FORCE;

  //* Values for PR_RESOURCE_FLAGS in message service table */

  SERVICE_DEFAULT_STORE = $00000001;
  SERVICE_SINGLE_COPY = $00000002;
  SERVICE_CREATE_WITH_STORE = $00000004;
  SERVICE_PRIMARY_IDENTITY = $00000008;
  SERVICE_NO_PRIMARY_IDENTITY = $00000020;

  //*  GetMsgServiceTable */
  //****** MAPI_UNICODE            ((ULONG) 0x80000000) */

  //*  GetProviderTable */
  //****** MAPI_UNICODE            ((ULONG) 0x80000000) */

  //* Flags for ConfigureMsgService */

  UI_SERVICE = $00000002;
  SERVICE_UI_ALWAYS = $00000002;
    //* Duplicate UI_SERVICE for consistency and compatibility */
  SERVICE_UI_ALLOWED = $00000010;
  UI_CURRENT_PROVIDER_FIRST = $00000004;
  //* MSG_SERVICE_UI_READ_ONLY         0x00000008 - in MAPISPI.H */

  //* GetProviderTable() */
  //****** MAPI_UNICODE            ((ULONG) 0x80000000) above */

  //* Values for PR_RESOURCE_FLAGS in message service table */

  //* IAttach attachment methods: PR_ATTACH_METHOD values */

  NO_ATTACHMENT = $00000000;
  ATTACH_BY_VALUE = $00000001;
  ATTACH_BY_REFERENCE = $00000002;
  ATTACH_BY_REF_RESOLVE = $00000003;
  ATTACH_BY_REF_ONLY = $00000004;
  ATTACH_EMBEDDED_MSG = $00000005;
  ATTACH_OLE = $00000006;

  //* Recipient types */
  MAPI_ORIG = 0; //* Recipient is message originator          */
  MAPI_TO = 1; //* Recipient is a primary recipient         */
  MAPI_CC = 2; //* Recipient is a copy recipient            */
  MAPI_BCC = 3; //* Recipient is blind copy recipient        */
  MAPI_P1 = $10000000; //* Recipient is a P1 resend recipient       */
  MAPI_SUBMITTED = $80000000; //* Recipient is already processed         */
  //* #define MAPI_AUTHORIZE 4        recipient is a CMC authorizing user      */
  //*#define MAPI_DISCRETE 0x10000000 Recipient is a P1 resend recipient       */

Type

  {forward declarations}

  IMAPIAdviseSink = Interface;
  LPMAPIADVISESINK = ^IMAPIAdviseSink;
  LPPMAPIADVISESINK = ^LPMAPIADVISESINK;
  IMAPITable = Interface;
  LPMAPITABLE = ^IMAPITable;
  LPPMAPITABLE = ^LPMAPITABLE;
  IMsgStore = Interface;
  LPMDB = ^IMsgStore;
  LPPMDB = LPMDB;
  IAddrBook = Interface;
  LPADRBOOK = ^IAddrBook;
  LPPADRBOOK = ^LPADRBOOK;
  IProfSect = Interface;
  LPPROFSECT = ^IProfSect;
  LPPPROFSECT = ^LPPROFSECT;
  IMAPIMessage = Interface;
  LPMESSAGE = ^IMAPIMessage;
  LPPMESSAGE = ^LPMESSAGE;
  IMsgServiceAdmin = Interface;
  LPSERVICEADMIN = ^IMsgServiceAdmin;
  LPPSERVICEADMIN = ^LPSERVICEADMIN;
  IMAPIFolder = Interface;
  LPMAPIFOLDER = ^IMAPIFolder;
  LPPMAPIFOLDER = ^LPMAPIFOLDER;
  IMAPISession = Interface;
  LPMAPISESSION = ^IMAPISession;
  LPPMAPISESSION = ^LPMAPISESSION;
  IMAPIProgress = Interface;
  LPMAPIPROGRESS = ^IMAPIProgress;
  LPPMAPIPROGRESS = ^LPMAPIPROGRESS;
  IAttach = Interface;
  LPATTACH = ^IAttach;
  LPPATTACH = ^LPATTACH;
  IMAPIProp = Interface;
  LPMAPIPROP = ^IMAPIProp;
  LPPMAPIPROP = ^LPMAPIPROP;
  IMAPIStatus = Interface;
  LPMAPISTATUS = ^IMAPIStatus;
  LPPMAPISTATUS = ^LPMAPISTATUS;
  IMAPIContainer = Interface;
  LPMAPICONTAINER = ^IMAPIContainer;
  LPPMAPICONTAINER = ^LPMAPICONTAINER;
  IProviderAdmin = Interface;
  LPPROVIDERADMIN = ^IProviderAdmin;
  LPPPROVIDERADMIN = ^LPPROVIDERADMIN;

  _MSG_PROPS_ = (MSG_SUBJ, MSG_BODY, MSG_FLAG, MSG_SNDR, MSG_ATT, NUM_MSG_PROPS);
  _RECIPS_ = (RECIPS_NAME, RECIPS_EID, RECIPS_ADDR, RECIPS_RECIP, RECIPS_EMAIL,
    RECIPS_SKEY, RECIPS_NUM_RECIP_PROPS);
  _CTX_ID_ = (CTX_INIT, CTX_INBOX, CTX_COMPOSE, CTX_READNOTE, CTX_SAVED, CTX_REPLY,
    CTX_REPLY_ALL, CTX_FORWARD);
  _FOLDERS_ = (FOLDERS_INBOX, FOLDERS_OUTBOX, FOLDERS_WASTE, FOLDERS_SENT,
    FOLDERS_IPM_ROOT, FOLDERS_NUM_FOLDERS);
  _WHO_TO_ = (WHO_TO_SENDER, WHO_TO_ALL);
  _OB_PROPS_ = (OBSUBJ, OBBODY, OBFLAG, OBSENT, NUM_OUTBOUND_PROPS);
  FOLDERS_TYPE = (ftInbox, ftOutbox, ftWastebox, ftSentbox);

  {shared with simple mapi}

  FLAGS = ULONG;

  {Extended MAPI Error Information -----------------------------------------}

  MAPIERROR = {Packed} Record
    ulVersion: ULONG;
    lpszError: pChar;
    lpszComponent: pChar;
    ulLowLevelError: ULONG;
    ulContext: ULONG;
  End;
  LPMAPIERROR = ^MAPIERROR;
  LPPMAPIERROR = ^LPMAPIERROR;

  {/* Data structures */}

  SSortOrder = {Packed} Record
    ulPropTag: ULONG; //* Column to sort on */
    ulOrder: ULONG; //* Ascending, descending, combine to left */
  End;
  LPSSortOrder = ^SSortOrder;

  SSortOrderSet = {Packed} Record
    cSorts: ULONG; //* Number of sort columns in aSort below*/
    cCategories: ULONG; //* 0 for non-categorized, up to cSorts */
    cExpanded: ULONG; //* 0 if no categories start expanded, */
                                    //*      up to cExpanded */
    aSort: Array[0..MAPI_DIM - 1] Of SSortOrder; //* The sort orders */
  End;
  LPSSortOrderSet = ^SSortOrderSet;
  LPPSSortOrderSet = ^LPSSortOrderSet;

  BOOKMARK = ULONG;
  PBOOKMARK = ^BOOKMARK;

  //* ENTRYID */
  ENTRYID = {Packed} Record
    abFlags: Array[0..3] Of BYTE;
    ab: Array[0..MAPI_DIM - 1] Of BYTE;
  End;
  LPENTRYID = ^ENTRYID;
  LPPENTRYID = ^LPENTRYID;

  //* Byte-order-independent version of GUID (world-unique identifier) */
  MAPIUID = {Packed} Record
    ab: Array[0..15] Of BYTE;
  End;
  LPMAPIUID = ^MAPIUID;

  //* Property Tag Array */

  SPropTagArray = {Packed} Record
    cValues: ULONG;
    aulPropTag: Array[0..MAPI_DIM - 1] Of ULONG;
  End;
  LPSPropTagArray = ^SPropTagArray;
  LPPSPropTagArray = ^LPSPropTagArray;

  CY = {Packed} Record
    Case Byte Of
      0: (Lo: ULONG; Hi: LONG; );
      1: (int64: LONGLONG);
  End;
  CURRENCY = CY;
  PCURRENCY = ^CURRENCY;

  SBinary = {Packed} Record
    cb: ULONG;
    lpb: LPBYTE;
  End;
  LPSBinary = ^SBinary;

  SShortArray = {Packed} Record
    cValues: ULONG;
    lpi: LPSMALLINT;
  End;

  SGuidArray = {Packed} Record
    cValues: ULONG;
    lpguid: PGUID;
  End;

  SRealArray = {Packed} Record
    cValues: ULONG;
    lpflt: LPSINGLE;
  End;

  SLongArray = {Packed} Record
    cValues: ULONG;
    lpl: PLONG;
  End;

  LARGE_INTEGER = {Packed} Record
    Case Byte Of
      0: (LowPart: DWORD; HighPart: LONG);
      1: (QuadPart: LONGLONG);
  End;
  PLARGE_INTEGER = ^LARGE_INTEGER;

  SLargeIntegerArray = {Packed} Record
    cValues: ULONG;
    lpli: PLARGE_INTEGER;
  End;

  FILETIME = {Packed} Record
    dwLowDateTime: DWORD;
    dwHighDateTime: DWORD;
  End;
  LPFILETIME = ^FILETIME;

  SDateTimeArray = {Packed} Record
    cValues: ULONG;
    lpft: LPFILETIME;
  End;

  SAppTimeArray = {Packed} Record
    cValues: ULONG;
    lpat: LPDOUBLE;
  End;

  SCurrencyArray = {Packed} Record
    cValues: ULONG;
    lpcur: PCURRENCY;
  End;

  SBinaryArray = {Packed} Record
    cValues: ULONG;
    lpbin: LPSBinary;
  End;
  ENTRYLIST = SBinaryArray;
  LPENTRYLIST = ^ENTRYLIST;
  LPPENTRYLIST = ^LPENTRYLIST;

  SDoubleArray = {Packed} Record
    cValues: ULONG;
    lpdbl: LPDOUBLE;
  End;

  SWStringArray = {Packed} Record
    cValues: ULONG;
    lppszW: PWideChar;
  End;

  SLPSTRArray = {Packed} Record
    cValues: ULONG;
    lppszA: PChar;
  End;

  _PV = {Packed} Record
    Case ULONG Of
      PT_I2: (i: SmallInt; ); //* case PT_I2            */
      PT_LONG: (l: LONG; ); //* case PT_LONG          */
      100000: (ul: ULONG; ); //* case PT_LONG          */
      PT_R4: (flt: Single; ); //* case PT_R4            */
      PT_DOUBLE: (dbl: double; ); //* case PT_DOUBLE        */
      PT_BOOLEAN: (b: word; ); //* case PT_BOOLEAN       */
      PT_CURRENCY: (cur: CURRENCY; ); //* case PT_CURRENCY      */
      PT_APPTIME: (at: double; ); //* case PT_APPTIME       */
      PT_SYSTIME: (ft: FILETIME; ); //* case PT_SYSTIME       */
      PT_STRING8: (lpszA: LPSTR; ); //* case PT_STRING8       */
      PT_BINARY: (bin: SBinary; ); //* case PT_BINARY        */
      PT_UNICODE: (lpszW: pWideChar; ); //* case PT_UNICODE       */
      PT_CLSID: (lpguid: PGUID; ); //* case PT_CLSID         */
      PT_I8: (li: LARGE_INTEGER; ); //* case PT_I8            */
      PT_MV_I2: (MVi: SShortArray; ); //* case PT_MV_I2         */
      PT_MV_LONG: (MVl: SLongArray; ); //* case PT_MV_LONG       */
      PT_MV_R4: (MVflt: SRealArray; ); //* case PT_MV_R4         */
      PT_MV_DOUBLE: (MVdbl: SDoubleArray; ); //* case PT_MV_DOUBLE     */
      PT_MV_CURRENCY: (MVcur: SCurrencyArray; ); //* case PT_MV_CURRENCY   */
      PT_MV_APPTIME: (MVat: SAppTimeArray; ); //* case PT_MV_APPTIME    */
      PT_MV_SYSTIME: (MVft: SDateTimeArray; ); //* case PT_MV_SYSTIME    */
      PT_MV_BINARY: (MVbin: SBinaryArray; ); //* case PT_MV_BINARY     */
      PT_MV_STRING8: (MVszA: SLPSTRArray; ); //* case PT_MV_STRING8    */
      PT_MV_UNICODE: (MVszW: SWStringArray; ); //* case PT_MV_UNICODE    */
      PT_MV_CLSID: (MVguid: SGuidArray; ); //* case PT_MV_CLSID      */
      PT_MV_I8: (MVli: SLargeIntegerArray; ); //* case PT_MV_I8         */
      PT_ERROR: (err: SCODE; ); //* case PT_ERROR         */
      PT_NULL, PT_OBJECT: (x: LONG; );
        //* case PT_NULL, PT_OBJECT (no usable value) */
  End;

  SPropValue = {Packed} Record
    ulPropTag: ULONG;
    dwAlignPad: ULONG;
    Value: _PV;
  End;
  LPSPropValue = ^SPropValue;
  LPPSPropValue = ^LPSPropValue;

//* --------------------------------------------- */
//* Property Problem and Property Problem Arrays */
//* --------------------------------------------- */
  SPropProblem = {Packed} Record
    ulIndex: ULONG;
    ulPropTag: ULONG;
    scode: SCODE;
  End;
  LPSPropProblem = ^SPropProblem;

  SPropProblemArray = {Packed} Record
    cProblem: ULONG;
    aProblem: Array[0..MAPI_DIM - 1] Of SPropProblem;
  End;
  LPSPropProblemArray = ^SPropProblemArray;
  LPPSPropProblemArray = ^LPSPropProblemArray;

  LPSRestriction = Pointer;
  LPPSRestriction = ^LPSRestriction;

  //* ------------------------------ */
  //* SRow, SRowSet */

  SRow = {Packed} Record
    ulAdrEntryPad: ULONG; //* Pad so SRow's can map to ADRENTRY's */
    cValues: ULONG; //* Count of property values */
    lpProps: LPSPropValue; //* Property value array */
  End;
  LPSRow = ^SRow;

  SRowSet = {Packed} Record
    cRows: ULONG; //* Count of rows */
    aRow: Array[0..MAPI_DIM - 1] Of SRow; //* Array of rows */
  End;
  LPSRowSet = ^SRowSet;
  LPPSRowSet = ^LPSRowSet;

  SAndRestriction = {Packed} Record
    cRes: ULONG;
    lpRes: LPSRestriction;
  End;

  SOrRestriction = {Packed} Record
    cRes: ULONG;
    lpRes: LPSRestriction;
  End;

  SNotRestriction = {Packed} Record
    ulReserved: ULONG;
    lpRes: LPSRestriction;
  End;

  SContentRestriction = {Packed} Record
    ulFuzzyLevel: ULONG;
    ulPropTag: ULONG;
    lpProp: LPSPropValue;
  End;

  SBitMaskRestriction = {Packed} Record
    relBMR: ULONG;
    ulPropTag: ULONG;
    ulMask: ULONG;
  End;

  SPropertyRestriction = {Packed} Record
    relop: ULONG;
    ulPropTag: ULONG;
    lpProp: LPSPropValue;
  End;

  SComparePropsRestriction = {Packed} Record
    relop: ULONG;
    ulPropTag1: ULONG;
    ulPropTag2: ULONG;
  End;

  SSizeRestriction = {Packed} Record
    relop: ULONG;
    ulPropTag: ULONG;
    cb: ULONG;
  End;

  SExistRestriction = {Packed} Record
    ulReserved1: ULONG;
    ulPropTag: ULONG;
    ulReserved2: ULONG;
  End;

  SSubRestriction = {Packed} Record
    ulSubObject: ULONG;
    lpRes: LPSRestriction;
  End;

  SCommentRestriction = {Packed} Record
    cValues: ULONG; //* # of properties in lpProp */
    lpRes: LPSRestriction;
    lpProp: LPSPropValue;
  End;

  SRestriction = {Packed} Record
    rt: ULONG; //* Restriction type */
    Case ULONG Of
      0: (resCompareProps: SComparePropsRestriction; );
      1: (resAnd: SAndRestriction; );
      2: (resOr: SOrRestriction; );
      3: (resNot: SNotRestriction; );
      4: (resContent: SContentRestriction; );
      5: (resProperty: SPropertyRestriction; );
      6: (resBitMask: SBitMaskRestriction; );
      7: (resSize: SSizeRestriction; );
      8: (resExist: SExistRestriction; );
      9: (resSub: SSubRestriction; );
      10: (resComment: SCommentRestriction; );
  End;

  //* Event Structures */
  ERROR_NOTIFICATION = {Packed} Record
    cbEntryID: ULONG;
    lpEntryID: LPENTRYID;
    scode: SCODE;
    ulFlags: ULONG; //* 0 or MAPI_UNICODE */
    lpMAPIError: LPMAPIERROR; //* Detailed error information */
  End;

  NEWMAIL_NOTIFICATION = {Packed} Record
    cbEntryID: ULONG;
    lpEntryID: LPENTRYID; //* identifies the new message */
    cbParentID: ULONG;
    lpParentID: LPENTRYID; //* identifies the folder it lives in */
    ulFlags: ULONG; //* 0 or MAPI_UNICODE */
    lpszMessageClass: pChar; //* message class (UNICODE or string8) */
    ulMessageFlags: ULONG; //* copy of PR_MESSAGE_FLAGS */
  End;

  OBJECT_NOTIFICATION = {Packed} Record
    cbEntryID: ULONG;
    lpEntryID: LPENTRYID; //* EntryID of object */
    ulObjType: ULONG; //* Type of object */
    cbParentID: ULONG;
    lpParentID: LPENTRYID; //* EntryID of parent object */
    cbOldID: ULONG;
    lpOldID: LPENTRYID; //* EntryID of old object */
    cbOldParentID: ULONG;
    lpOldParentID: LPENTRYID; //* EntryID of old parent */
    lpPropTagArray: LPSPropTagArray;
  End;

  TABLE_NOTIFICATION = {Packed} Record
    ulTableEvent: ULONG; //* Identifies WHICH table event */
    hResult: HRESULT; //* Value for TABLE_ERROR */
    propIndex: SPropValue; //* This row's "index property" */
    propPrior: SPropValue; //* Preceding row's "index property" */
    row: SRow; //* New data of added/modified row */
    ulPad: ULONG; //* Force to 8-byte boundary */
  End;

  EXTENDED_NOTIFICATION = {Packed} Record
    ulEvent: ULONG; //* extended event code */
    cb: ULONG; //* size of event parameters */
    pbEventParameters: LPBYTE; //* event parameters */
  End;

  STATUS_OBJECT_NOTIFICATION = {Packed} Record
    cbEntryID: ULONG;
    lpEntryID: LPENTRYID;
    cValues: ULONG;
    lpPropVals: LPSPropValue;
  End;

  NOTIFICATION = {Packed} Record
    ulEventType: ULONG; //* notification type, i.e. fnevSomething */
    ulAlignPad: ULONG; //* Force to 8-byte boundary */
    Case byte Of
      0: (err: ERROR_NOTIFICATION; );
      1: (newmail: NEWMAIL_NOTIFICATION; );
      2: (obj: OBJECT_NOTIFICATION; );
      3: (tab: TABLE_NOTIFICATION; );
      4: (ext: EXTENDED_NOTIFICATION; );
      5: (statobj: STATUS_OBJECT_NOTIFICATION; );
  End;
  LPNOTIFICATION = ^NOTIFICATION;

  //* ------------------------------ */
  //* ADRENTRY, ADRLIST */
  ADRENTRY = {Packed} Record
    ulReserved1: ULONG; //* Never used */
    cValues: ULONG;
    rgPropVals: LPSPropValue;
  End;
  LPADRENTRY = ^ADRENTRY;

  ADRLIST = {Packed} Record
    cEntries: ULONG;
    aEntries: Array[0..MAPI_DIM - 1] Of ADRENTRY;
  End;
  LPADRLIST = ^ADRLIST;
  LPPADRLIST = ^LPADRLIST;

  MAPINAMEID = {Packed} Record
    lpguid: PGUID;
    ulKind: ULONG;
    Case byte Of
      0: (lID: LONG; );
      1: (lpwstrName: pWideChar; );
  End;
  LPMAPINAMEID = ^MAPINAMEID;
  LPPMAPINAMEID = ^LPMAPINAMEID;
  LPPPMAPINAMEID = ^LPPMAPINAMEID;

  //*  Accelerator callback for DIALOG_SDI form of AB UI */
  LPFNABSDI = Function(ulUIParam: ULONG; lpvmsg: Pointer): BOOL; stdcall;

  //*  Callback to application telling it that the DIALOG_SDI form of the */
  //*  AB UI has been dismissed.  This is so that the above LPFNABSDI     */
  //*  function doesn't keep being called.                                */
  LPFNDISMISS = Procedure(ulUIParam: ULONG; lpvContext: Pointer); stdcall;

  //*
  // * Prototype for the client function hooked to an optional button on
  // * the address book dialog
  // */
  LPFNBUTTON = Function(ulUIParam: ULONG; lpvContext: Pointer; cbEntryID: ULONG;
    lpSelection: LPENTRYID; ulFlags: ULONG): SCODE; stdcall;

  //* Parameters for the address book dialog */
  ADRPARM = {Packed} Record
    cbABContEntryID: ULONG;
    lpABContEntryID: LPENTRYID;
    ulFlags: ULONG;
    lpReserved: Pointer;
    ulHelpContext: ULONG;
    lpszHelpFileName: pChar;
    lpfnABSDI: LPFNABSDI;
    lpfnDismiss: LPFNDISMISS;
    lpvDismissContext: Pointer;
    lpszCaption: pChar;
    lpszNewEntryTitle: pChar;
    lpszDestWellsTitle: pChar;
    cDestFields: ULONG;
    nDestFieldFocus: ULONG;
    lppszDestTitles: ppChar;
    lpulDestComps: PULONG;
    lpContRestriction: LPSRestriction;
    lpHierRestriction: LPSRestriction;
  End;
  LPADRPARM = ^ADRPARM;

  LPALLOCATEBUFFER = Function(cbSize: ULONG; lppBuffer: Pointer): SCODE; stdcall;
  LPFREEBUFFER = Function(lpBuffer: Pointer): ULONG; stdcall;

  {IMAPIProp Interface -----------------------------------------------------}
  IMAPIProp = Interface
    Function GetLastError(hResult: HRESULT; ulFlags: ULONG; lppMAPIError:
      LPPMAPIERROR): HRESULT; Stdcall;
    Function SaveChanges(ulFlags: ULONG): HRESULT; Stdcall;
    Function GetProps(lpPropTagArray: LPSPropTagArray; ulFlags: ULONG; lpcValues:
      PULONG; lppPropArray: LPPSPropValue): HRESULT; Stdcall;
    Function GetPropList(ulFlags: ULONG; lppPropTagArray: LPPSPropTagArray):
      HRESULT;
      Stdcall;
    Function OpenProperty(ulPropTag: ULONG; lpiid: PGUID; ulInterfaceOptions: ULONG;
      ulFlags: ULONG; lppUnk: LPUNKNOWN): HRESULT; Stdcall;
    Function SetProps(cValues: ULONG; lpPropArray: LPSPropValue; lppProblems:
      LPPSPropProblemArray): HRESULT; Stdcall;
    Function DeleteProps(lpPropTagArray: LPSPropTagArray; lppProblems:
      LPPSPropProblemArray): HRESULT; Stdcall;
    Function CopyTo(ciidExclude: ULONG; rgiidExclude: PGUID; lpExcludeProps:
      LPSPropTagArray; ulUIParam: ULONG; lpProgress: LPMAPIPROGRESS; lpInterface:
      PGUID; lpDestObj: Pointer; ulFlags: ULONG; lppProblems: LPPSPropProblemArray):
      HRESULT; Stdcall;
    Function CopyProps(lpIncludeProps: LPSPropTagArray; ulUIParam: ULONG;
      lpProgress: LPMAPIPROGRESS; lpInterface: PGUID; lpDestObj: Pointer; ulFlags:
      ULONG; lppProblems: LPPSPropProblemArray): HRESULT; Stdcall;
    Function GetNamesFromIDs(lppPropTags: LPPSPropTagArray; lpPropSetGuid: PGUID;
      ulFlags: ULONG; lpcPropNames: PULONG; lpppPropNames: LPPPMAPINAMEID): HRESULT;
      Stdcall;
    Function GetIDsFromNames(cPropNames: ULONG; lppPropNames: LPPMAPINAMEID;
      ulFlags: ULONG; lppPropTags: LPPSPropTagArray): HRESULT; Stdcall;
  End;

  {IMAPIStatus Interface -------------------------------------------------}
  IMAPIStatus = Interface(IMAPIProp)
    Function ValidateState(ulUIParam: ULONG; ulFlags: ULONG): HRESULT; Stdcall;
    Function SettingsDialog(ulUIParam: ULONG; ulFlags: ULONG): HRESULT; Stdcall;
    Function ChangePassword(lpOldPass: pChar; lpNewPass: pChar; ulFlags: ULONG):
      HRESULT; Stdcall;
    Function FlushQueues(ulUIParam: ULONG; cbTargetTransport: ULONG;
      lpTargetTransport: LPENTRYID; ulFlags: ULONG): HRESULT; Stdcall;
  End;

  {IMAPIProgress Interface -------------------------------------------------}
  IMAPIProgress = Interface
    Function Progress(ulValue: ULONG; ulCount: ULONG; ulTotal: ULONG): HRESULT;
      Stdcall;
    Function GetFlags(lpulFlags: PULONG): HRESULT; Stdcall;
    Function GetMax(lpulMax: PULONG): HRESULT; Stdcall;
    Function GetMin(lpulMin: PULONG): HRESULT; Stdcall;
    Function SetLimits(lpulMin: PULONG; lpulMax: PULONG; lpulFlags: PULONG):
      HRESULT;
      Stdcall;
  End;

  {IMAPIAdviseSink Interface -----------------------------------------------}
  IMAPIAdviseSink = Interface
    Function OnNotify(cNotif: ULONG; lpNotifications: LPNOTIFICATION): ULONG;
      Stdcall;
  End;

  {IMAPITable Interface ----------------------------------------------------}
  IMAPITable = Interface
    Function GetLastError(hResult: HRESULT; ulFlags: ULONG; lppMAPIError:
      LPPMAPIERROR): HRESULT; Stdcall;
    Function Advise(ulEventMask: ULONG; lpAdviseSink: LPMAPIADVISESINK;
      lpulConnection: PULONG): HRESULT; Stdcall;
    Function Unadvise(ulConnection: ULONG): HRESULT; Stdcall;
    Function GetStatus(lpulTableStatus: PULONG; lpulTableType: PULONG): HRESULT;
      Stdcall;
    Function SetColumns(lpPropTagArray: LPSPropTagArray; ulFlags: ULONG): HRESULT;
      Stdcall;
    Function QueryColumns(ulFlags: ULONG; lpPropTagArray: LPPSPropTagArray):
      HRESULT;
      Stdcall;
    Function GetRowCount(ulFlags: ULONG; lpulCount: PULONG): HRESULT; Stdcall;
    Function SeekRow(bkOrigin: BOOKMARK; lRowCount: LONG; lplRowsSought: PLONG):
      HRESULT; Stdcall;
    Function SeekRowApprox(ulNumerator: ULONG; ulDenominator: ULONG): HRESULT;
      Stdcall;
    Function QueryPosition(lpulRow: PULONG; lpulNumerator: PULONG; lpulDenominator:
      PULONG): HRESULT; Stdcall;
    Function FindRow(lpRestriction: LPSRestriction; bkOrigin: BOOKMARK; ulFlags:
      ULONG): HRESULT; Stdcall;
    Function Restrict(lpRestriction: LPSRestriction; ulFlags: ULONG): HRESULT;
      Stdcall;
    Function CreateBookmark(lpbkPosition: PBOOKMARK): HRESULT; Stdcall;
    Function FreeBookmark(bkPosition: BOOKMARK): HRESULT; Stdcall;
    Function SortTable(lpSortCriteria: LPSSortOrderSet; ulFlags: ULONG): HRESULT;
      Stdcall;
    Function QuerySortOrder(lppSortCriteria: LPPSSortOrderSet): HRESULT; Stdcall;
    Function QueryRows(lRowCount: LONG; ulFlags: ULONG; lppRows: LPPSRowSet):
      HRESULT; Stdcall;
    Function Abort: HRESULT; Stdcall;
    Function ExpandRow(cbInstanceKey: ULONG; pbInstanceKey: LPBYTE; ulRowCount:
      ULONG; ulFlags: ULONG; lppRows: LPPSRowSet; lpulMoreRows: PULONG): HRESULT;
      Stdcall;
    Function CollapseRow(cbInstanceKey: ULONG; pbInstanceKey: LPBYTE; ulFlags:
      ULONG; lpulRowCount: PULONG): HRESULT; Stdcall;
    Function WaitForCompletion(ulFlags: ULONG; ulTimeout: ULONG; lpulTableStatus:
      PULONG): HRESULT; Stdcall;
    Function GetCollapseState(ulFlags: ULONG; cbInstanceKey: ULONG; lpbInstanceKey:
      LPBYTE; lpcbCollapseState: PULONG; lppbCollapseState: LPPBYTE): HRESULT;
      Stdcall;
    Function SetCollapseState(ulFlags: ULONG; cbCollapseState: ULONG;
      pbCollapseState: LPBYTE; lpbkLocation: PBOOKMARK): HRESULT; Stdcall;
  End;

  {IMsgStore Interface -----------------------------------------------------}
  IMsgStore = Interface(IMAPIProp)
    Function Advise(cbEntryID: ULONG; lpEntryID: LPENTRYID; ulEventMask: ULONG;
      lpAdviseSink: LPMAPIADVISESINK; lpulConnection: PULONG): HRESULT; Stdcall;
    Function Unadvise(ulConnection: ULONG): HRESULT; Stdcall;
    Function CompareEntryIDs(cbEntryID1: ULONG; lpEntryID1: LPENTRYID; cbEntryID2:
      ULONG; lpEntryID2: LPENTRYID; ulFlags: ULONG; lpulResult: PULONG): HRESULT;
      Stdcall;
    Function OpenEntry(cbEntryID: ULONG; lpEntryID: LPENTRYID; lpInterface: PGUID;
      ulFlags: ULONG; lpulObjType: PULONG; lppUnk: LPPUNKNOWN): HRESULT; Stdcall;
    Function SetReceiveFolder(lpszMessageClass: pChar; ulFlags: ULONG; cbEntryID:
      ULONG; lpEntryID: LPENTRYID): HRESULT; Stdcall;
    Function GetReceiveFolder(lpszMessageClass: pChar; ulFlags: ULONG; lpcbEntryID:
      PULONG; lppEntryID: LPPENTRYID; lppszExplicitClass: ppChar): HRESULT; Stdcall;
    Function GetReceiveFolderTable(ulFlags: ULONG; lppTable: LPPMAPITABLE): HRESULT;
      Stdcall;
    Function StoreLogoff(lpulFlags: PULONG): HRESULT; Stdcall;
    Function AbortSubmit(cbEntryID: ULONG; lpEntryID: LPENTRYID; ulFlags: ULONG):
      HRESULT; Stdcall;
    Function GetOutgoingQueue(ulFlags: ULONG; lppTable: LPPMAPITABLE): HRESULT;
      Stdcall;
    Function SetLockState(lpMessage: LPMESSAGE; ulLockState: ULONG): HRESULT;
      Stdcall;
    Function FinishedMsg(ulFlags: ULONG; cbEntryID: ULONG; lpEntryID: LPENTRYID):
      HRESULT; Stdcall;
    Function NotifyNewMail(lpNotification: LPNOTIFICATION): HRESULT; Stdcall;
  End;

  IAddrBook = Interface(IMAPIProp)
    Function OpenEntry(cbEntryID: ULONG; lpEntryID: LPENTRYID; lpInterface: PGUID;
      ulFlags: ULONG; lpulObjType: PLONG; lppUnk: LPPUNKNOWN): HRESULT; Stdcall;
    Function CompareEntryIDs(cbEntryID1: ULONG; lpEntryID1: LPENTRYID; cbEntryID2:
      ULONG; lpEntryID2: LPENTRYID; ulFlags: ULONG; lpulResult: PULONG): HRESULT;
      Stdcall;
    Function Advise(cbEntryID: ULONG; lpEntryID: LPENTRYID; ulEventMask: ULONG;
      lpAdviseSink: LPMAPIADVISESINK; lpulConnection: PULONG): HRESULT; Stdcall;
    Function Unadvise(ulConnection: ULONG): HRESULT; Stdcall;
    Function CreateOneOff(lpszName: pChar; lpszAdrType: pChar; lpszAddress: pChar;
      ulFlags: ULONG; lpcbEntryID: PULONG; lppEntryID: LPPENTRYID): HRESULT;
      Stdcall;
    Function NewEntry(ulUIParam: ULONG; ulFlags: ULONG; cbEIDContainer: ULONG;
      lpEIDContainer: LPENTRYID; cbEIDNewEntryTpl: ULONG; lpEIDNewEntryTpl:
      LPENTRYID;
      lpcbEIDNewEntry: PULONG; lppEIDNewEntry: LPPENTRYID): HRESULT; Stdcall;
    Function ResolveName(ulUIParam: ULONG; ulFlags: ULONG; lpszNewEntryTitle: pChar;
      lpAdrList: LPADRLIST): HRESULT; Stdcall;
    Function Address(lpulUIParam: PULONG; lpAdrParms: LPADRPARM; lppAdrList:
      LPPADRLIST): HRESULT; Stdcall;
    Function Details(lpulUIParam: PULONG; lpfnDismiss: LPFNDISMISS;
      lpvDismissContext: Pointer; cbEntryID: ULONG; lpEntryID: LPENTRYID;
      lpfButtonCallback: LPFNBUTTON; lpvButtonContext: Pointer; lpszButtonText:
      pChar;
      ulFlags: ULONG): HRESULT; Stdcall;
    Function RecipOptions(ulUIParam: ULONG; ulFlags: ULONG; lpRecip: LPADRENTRY):
      HRESULT; Stdcall;
    Function QueryDefaultRecipOpt(lpszAdrType: pChar; ulFlags: ULONG; lpcValues:
      PULONG; lppOptions: LPPSPropValue): HRESULT; Stdcall;
    Function GetPAB(lpcbEntryID: PULONG; lppEntryID: LPPENTRYID): HRESULT; Stdcall;
    Function SetPAB(cbEntryID: ULONG; lpEntryID: LPENTRYID): HRESULT; Stdcall;
    Function GetDefaultDir(lpcbEntryID: PULONG; lppEntryID: LPPENTRYID): HRESULT;
      Stdcall;
    Function SetDefaultDir(cbEntryID: ULONG; lpEntryID: LPENTRYID): HRESULT;
      Stdcall;
    Function GetSearchPath(ulFlags: ULONG; lppSearchPath: LPPSRowSet): HRESULT;
      Stdcall;
    Function SetSearchPath(ulFlags: ULONG; lpSearchPath: LPSRowSet): HRESULT;
      Stdcall;
    Function PrepareRecips(ulFlags: ULONG; lpPropTagArray: LPSPropTagArray;
      lpRecipList: LPADRLIST): HRESULT; Stdcall;
  End;

  IProfSect = Interface(IMAPIProp)
  End;

  IAttach = Interface(IMAPIProp)
  End;

  IMAPIMessage = Interface(IMAPIProp)
    Function GetAttachmentTable(ulFlags: ULONG; lppTable: LPMAPITABLE): HRESULT;
      Stdcall;
    Function OpenAttach(ulAttachmentNum: ULONG; lpInterface: PGUID; ulFlags: ULONG;
      lppAttach: LPATTACH): HRESULT; Stdcall;
    Function CreateAttach(lpInterface: PGUID; ulFlags: ULONG; lpulAttachmentNum:
      PULONG; lppAttach: LPATTACH): HRESULT; Stdcall;
    Function DeleteAttach(ulAttachmentNum: ULONG; ulUIParam: ULONG; lpProgress:
      LPMAPIPROGRESS; ulFlags: ULONG): HRESULT; Stdcall;
    Function GetRecipientTable(ulFlags: ULONG; lppTable: LPMAPITABLE): HRESULT;
      Stdcall;
    Function ModifyRecipients(ulFlags: ULONG; lpMods: LPADRLIST): HRESULT; Stdcall;
    Function SubmitMessage(ulFlags: ULONG): HRESULT; Stdcall;
    Function SetReadFlag(ulFlags: ULONG): HRESULT; Stdcall;
  End;

  IProviderAdmin = Interface
    Function GetLastError(hResult: HRESULT; ulFlags: ULONG; lppMAPIError:
      LPPMAPIERROR): HRESULT; Stdcall;
    Function GetProviderTable(ulFlags: ULONG; lppTable: LPMAPITABLE): HRESULT;
      Stdcall;
    Function CreateProvider(lpszProvider: pChar; cValues: ULONG; lpProps:
      LPSPropValue; ulUIParam: ULONG; ulFlags: ULONG; lpUID: LPMAPIUID): HRESULT;
      Stdcall;
    Function DeleteProvider(lpUID: LPMAPIUID): HRESULT; Stdcall;
    Function OpenProfileSection(lpUID: LPMAPIUID; lpInterface: PGUID; ulFlags:
      ULONG; lppProfSect: LPPROFSECT): HRESULT; Stdcall;
  End;

  IMsgServiceAdmin = Interface
    Function GetLastError(hResult: HRESULT; ulFlags: ULONG; lppMAPIError:
      LPPMAPIERROR): HRESULT; Stdcall;
    Function GetMsgServiceTable(ulFlags: ULONG; lppTable: LPMAPITABLE): HRESULT;
      Stdcall;
    Function CreateMsgService(lpszService: pChar; lpszDisplayName: pChar; ulUIParam:
      ULONG; ulFlags: ULONG): HRESULT; Stdcall;
    Function DeleteMsgService(lpUID: LPMAPIUID): HRESULT; Stdcall;
    Function CopyMsgService(lpUID: LPMAPIUID; lpszDisplayName: pChar;
      lpInterfaceToCopy: PGUID; lpInterfaceDst: PGUID; lpObjectDst: Pointer;
      ulUIParam: ULONG; ulFlags: ULONG): HRESULT; Stdcall;
    Function RenameMsgService(lpUID: LPMAPIUID; ulFlags: ULONG; lpszDisplayName:
      pChar): HRESULT; Stdcall;
    Function ConfigureMsgService(lpUID: LPMAPIUID; ulUIParam: ULONG; ulFlags: ULONG;
      cValues: ULONG; lpProps: LPSPropValue): HRESULT; Stdcall;
    Function OpenProfileSection(lpUID: LPMAPIUID; lpInterface: PGUID; ulFlags:
      ULONG; lppProfSect: LPPROFSECT): HRESULT; Stdcall;
    Function MsgServiceTransportOrder(cUID: ULONG; lpUIDList: LPMAPIUID; ulFlags:
      ULONG): HRESULT; Stdcall;
    Function AdminProviders(lpUID: LPMAPIUID; ulFlags: ULONG; lppProviderAdmin:
      LPPROVIDERADMIN): HRESULT; Stdcall;
    Function SetPrimaryIdentity(lpUID: LPMAPIUID; ulFlags: ULONG): HRESULT; Stdcall;
    Function GetProviderTable(ulFlags: ULONG; lppTable: LPMAPITABLE): HRESULT;
      Stdcall;
  End;

  IMAPIContainer = Interface(IMAPIProp)
    Function GetContentsTable(ulFlags: ULONG; lppTable: LPMAPITABLE): HRESULT;
      Stdcall;
    Function GetHierarchyTable(ulFlags: ULONG; lppTable: LPMAPITABLE): HRESULT;
      Stdcall;
    Function OpenEntry(cbEntryID: ULONG; lpEntryID: LPENTRYID; lpInterface: PGUID;
      ulFlags: ULONG; lpulObjType: PULONG; lppUnk: LPUNKNOWN): HRESULT; Stdcall;
    Function SetSearchCriteria(lpRestriction: LPSRestriction; lpContainerList:
      LPENTRYLIST; ulSearchFlags: ULONG): HRESULT; Stdcall;
    Function GetSearchCriteria(ulFlags: ULONG; lppRestriction: LPPSRestriction;
      lppContainerList: LPPENTRYLIST; lpulSearchState: PULONG): HRESULT; Stdcall;
  End;

  IMAPIFolder = Interface(IMAPIContainer)
    Function CreateMessage(lpInterface: PGUID; ulFlags: ULONG; lppMessage:
      LPPMESSAGE): HRESULT; Stdcall;
    Function CopyMessages(lpMsgList: LPENTRYLIST; lpInterface: PGUID; lpDestFolder:
      Pointer; ulUIParam: ULONG; lpProgress: LPMAPIPROGRESS; ulFlags: ULONG):
      HRESULT;
      Stdcall;
    Function DeleteMessages(lpMsgList: LPENTRYLIST; ulUIParam: ULONG; lpProgress:
      LPMAPIPROGRESS; ulFlags: ULONG): HRESULT; Stdcall;
    Function CreateFolder(ulFolderType: ULONG; lpszFolderName: pChar;
      lpszFolderComment: pChar; lpInterface: PGUID; ulFlags: ULONG; lppFolder:
      LPPMAPIFOLDER): HRESULT; Stdcall;
    Function CopyFolder(cbEntryID: ULONG; lpEntryID: LPENTRYID; lpInterface: PGUID;
      lpDestFolder: Pointer; lpszNewFolderName: pChar; ulUIParam: ULONG; lpProgress:
      LPMAPIPROGRESS; ulFlags: ULONG): HRESULT; Stdcall;
    Function DeleteFolder(cbEntryID: ULONG; lpEntryID: LPENTRYID; ulUIParam: ULONG;
      lpProgress: LPMAPIPROGRESS; ulFlags: ULONG): HRESULT; Stdcall;
    Function SetReadFlags(lpMsgList: LPENTRYLIST; ulUIParam: ULONG; lpProgress:
      LPMAPIPROGRESS; ulFlags: ULONG): HRESULT; Stdcall;
    Function GetMessageStatus(cbEntryID: ULONG; lpEntryID: LPENTRYID; ulFlags:
      ULONG; lpulMessageStatus: PULONG): HRESULT; Stdcall;
    Function SetMessageStatus(cbEntryID: ULONG; lpEntryID: LPENTRYID; ulNewStatus:
      ULONG; ulNewStatusMask: ULONG; lpulOldStatus: PULONG): HRESULT; Stdcall;
    Function SaveContentsSort(lpSortCriteria: LPSSortOrderSet; ulFlags: ULONG):
      HRESULT; Stdcall;
    Function EmptyFolder(ulUIParam: ULONG; lpProgress: LPMAPIPROGRESS; ulFlags:
      ULONG): HRESULT; Stdcall;
  End;

  {IMAPISession Interface --------------------------------------------------}
  IMAPISession = Interface
    Function GetLastError(hResult: HRESULT; ulFlags: ULONG; lppMAPIError:
      LPPMAPIERROR): HRESULT; Stdcall;
    Function GetMsgStoresTable(ulFlags: ULONG; lppTable: LPMAPITABLE): HRESULT;
      Stdcall;
    Function OpenMsgStore(ulUIParam: ULONG; cbEntryID: ULONG; lpEntryID: LPENTRYID;
      lpInterface: PGUID; ulFlags: ULONG; lppMDB: LPMDB): HRESULT; Stdcall;
    Function OpenAddressBook(ulUIParam: ULONG; lpInterface: PGUID; ulFlags: ULONG;
      lppAdrBook: LPADRBOOK): HRESULT; Stdcall;
    Function OpenProfileSection(lpUID: LPMAPIUID; lpInterface: PGUID; ulFlags:
      ULONG; lppProfSect: LPPROFSECT): HRESULT; Stdcall;
    Function GetStatusTable(ulFlags: ULONG; lppTable: LPMAPITABLE): HRESULT;
      Stdcall;
    Function OpenEntry(cbEntryID: ULONG; lpEntryID: LPENTRYID; lpInterface: PGUID;
      ulFlags: ULONG; lpulObjType: PULONG; lppUnk: LPUNKNOWN): HRESULT; Stdcall;
    Function CompareEntryIDs(cbEntryID1: ULONG; lpEntryID1: LPENTRYID; cbEntryID2:
      ULONG; lpEntryID2: LPENTRYID; ulFlags: ULONG; lpulResult: PULONG): HRESULT;
      Stdcall;
    Function Advise(cbEntryID: ULONG; lpEntryID: LPENTRYID; ulEventMask: ULONG;
      lpAdviseSink: LPMAPIADVISESINK; lpulConnection: PULONG): HRESULT; Stdcall;
    Function Unadvise(ulConnection: ULONG): HRESULT; Stdcall;
    Function MessageOptions(ulUIParam: ULONG; ulFlags: ULONG; lpszAdrType: pChar;
      lpMessage: LPMESSAGE): HRESULT; Stdcall;
    Function QueryDefaultMessageOpt(lpszAdrType: pChar; ulFlags: ULONG; lpcValues:
      PULONG; lppOptions: LPPSPropValue): HRESULT; Stdcall;
    Function EnumAdrTypes(ulFlags: ULONG; lpcAdrTypes: PULONG; lpppszAdrTypes:
      PPPCHAR): HRESULT; Stdcall;
    Function QueryIdentity(lpcbEntryID: PULONG; lppEntryID: LPPENTRYID): HRESULT;
      Stdcall;
    Function Logoff(ulUIParam, ulFlags, ulReserved: ULONG): HRESULT; Stdcall;
    Function SetDefaultStore(ulFlags: ULONG; cbEntryID: ULONG; lpEntryID:
      LPENTRYID): HRESULT; Stdcall;
    Function AdminServices(ulFlags: ULONG; lppServiceAdmin: LPSERVICEADMIN):
      HRESULT;
      Stdcall;
    Function ShowForm(ulUIParam: ULONG; lpMsgStore: LPMDB; lpParentFolder:
      LPMAPIFOLDER; lpInterface: PGUID; ulMessageToken: ULONG; lpMessageSent:
      LPMESSAGE; ulFlags: ULONG; ulMessageStatus: ULONG; ulMessageFlags: ULONG;
      ulAccess: ULONG; lpszMessageClass: pChar): HRESULT; Stdcall;
    Function PrepareForm(lpInterface: PGUID; lpMessage: LPMESSAGE; lpulMessageToken:
      PULONG): HRESULT; Stdcall;
  End;

  {Structure passed to MAPIInitialize(), and its ulFlags values}

  MAPIINIT_0 = {Packed} Record
    ulVersion: ULONG;
    ulFlags: ULONG;
  End;
  pMAPIINIT_0 = ^MAPIINIT_0;

  //Forward class declarations
  TMAPISession = Class;

  {TLogonFlags}
  TMAPILogonFlags = Class(TPersistent)
  Private
    FLOGON_UI: boolean;
    FNEW_SESSION: boolean;
    FALLOW_OTHERS: boolean;
    FEXPLICIT_PROFILE: boolean;
    FEXTENDED: boolean;
    FFORCE_DOWNLOAD: boolean;
    FSERVICE_UI_ALWAYS: boolean;
    FNO_MAIL: boolean;
    FNT_SERVICE: boolean;
    FPASSWORD_UI: boolean;
    FTIMEOUT_SHORT: boolean;
    FUSE_DEFAULT: boolean;
    Function GetLogonFlag: ULONG;
  Public
    Constructor Create;
    Property LogonFlag: ULONG Read GetLogonFlag;
  Published
    Property LOGON_UI: boolean Read FLOGON_UI Write FLOGON_UI;
    Property NEW_SESSION: boolean Read FNEW_SESSION Write FNEW_SESSION;
    Property ALLOW_OTHERS: boolean Read FALLOW_OTHERS Write FALLOW_OTHERS;
    Property EXPLICIT_PROFILE: boolean Read FEXPLICIT_PROFILE Write
      FEXPLICIT_PROFILE;
    Property EXTENDED: boolean Read FEXTENDED Write FEXTENDED;
    Property FORCE_DOWNLOAD: boolean Read FFORCE_DOWNLOAD Write FFORCE_DOWNLOAD;
    Property SERVICE_UI_ALWAYS: boolean Read FSERVICE_UI_ALWAYS Write
      FSERVICE_UI_ALWAYS;
    Property NO_MAIL: boolean Read FNO_MAIL Write FNO_MAIL;
    Property NT_SERVICE: boolean Read FNT_SERVICE Write FNT_SERVICE;
    Property PASSWORD_UI: boolean Read FPASSWORD_UI Write FPASSWORD_UI;
    Property TIMEOUT_SHORT: boolean Read FTIMEOUT_SHORT Write FTIMEOUT_SHORT;
    Property USE_DEFAULT: boolean Read FUSE_DEFAULT Write FUSE_DEFAULT;
  End;

  {TLogoffFlags}
  TMAPILogoffFlags = Class(TPersistent)
  Private
    FLOGOFF_SHARED: boolean;
    FLOGOFF_UI: boolean;
    Function GetLogoffFlag: ULONG;
  Public
    Constructor Create;
    Property LogoffFlag: ULONG Read GetLogoffFlag;
  Published
    Property LOGOFF_SHARED: boolean Read FLOGOFF_SHARED Write FLOGOFF_SHARED;
    Property LOGOFF_UI: boolean Read FLOGOFF_UI Write FLOGOFF_UI;
  End;

  {TMessageFlags}
  TMessageFlags = Class(TPersistent)
  Private
    FREAD: boolean;
    FUNMODIFIED: boolean;
    FSUBMIT: boolean;
    FUNSENT: boolean;
    FHASATTACH: boolean;
    FFROMME: boolean;
    FASSOCIATED: boolean;
    FRESEND: boolean;
    FRN_PENDING: boolean;
    FNRN_PENDING: boolean;
    fCAN_DELETE: boolean;
    Function GetMessageFlag: ULONG;
    Procedure SetMessageFlag(Const Value: ULONG);
  Public
    Constructor Create;
  Published
    Property MessageFlag: ULONG Read GetMessageFlag Write SetMessageFlag;
    Property _READ: boolean Read FREAD Write FREAD;
    Property UNMODIFIED: boolean Read FUNMODIFIED Write FUNMODIFIED;
    Property SUBMIT: boolean Read FSUBMIT Write FSUBMIT;
    Property UNSENT: boolean Read FUNSENT Write FUNSENT;
    Property HASATTACH: boolean Read FHASATTACH Write FHASATTACH;
    Property FROMME: boolean Read FFROMME Write FFROMME;
    Property ASSOCIATED: boolean Read FASSOCIATED Write FASSOCIATED;
    Property RESEND: boolean Read FRESEND Write FRESEND;
    Property RN_PENDING: boolean Read FRN_PENDING Write FRN_PENDING;
    Property NRN_PENDING: boolean Read FNRN_PENDING Write FNRN_PENDING;
    // added by vini - property to allow the user delete this message later...
    Property CAN_DELETE: boolean Read fCAN_DELETE Write fCAN_DELETE;
  End;

  TMAPIFolder = Class;
  TMAPIMessage = Class;
  TMAPIAttachment = Class;
  TMAPIRecipient = Class;

  {TMAPIRecipients}
  TMAPIRecipients = Class(TOwnedCollection)
  Private
{$IFDEF VER130}
    Function GetCollectionOwner: TPersistent;
{$ENDIF}
    Function GetItem(Index: Integer): TMAPIRecipient;
    Procedure SetItem(Index: Integer; Const Value: TMAPIRecipient);
  Public
    Procedure AssignValues(Value: TMAPIRecipients);
    Function FindRecipient(Const Value: String): TMAPIRecipient;
    Function IsEqual(Value: TMAPIRecipients): Boolean;
    Function CreateRecipient: TMAPIRecipient;
{$IFDEF VER130}
    Property Owner: TPersistent Read GetCollectionOwner;
{$ENDIF}
    Property Items[Index: Integer]: TMAPIRecipient Read GetItem Write SetItem;
    Default;
  End;

  {TMAPIRecipient}
  TMAPIRecipient = Class(TCollectionItem)
  Private
    FEMail: String;
    FName: String;
  Protected
    Procedure AssignRecipient(Recipient: TMAPIRecipient);
    Function GetDisplayName: String; Override;
  Public
    Constructor Create(Collection: TCollection); Override;
    Destructor Destroy; Override;
    Procedure Assign(Source: TPersistent); Override;
    Function IsEqual(Value: TMAPIRecipient): Boolean;
  Published
    Property Name: String Read FName Write FName;
    Property EMail: String Read FEMail Write FEMail;
  End;

  {TMAPIAttachments}
  TMAPIAttachments = Class(TOwnedCollection)
  Private
{$IFDEF VER130}
    Function GetCollectionOwner: TPersistent;
{$ENDIF}
    Function GetItem(Index: Integer): TMAPIAttachment;
    Procedure SetItem(Index: Integer; Const Value: TMAPIAttachment);
  Public
    Procedure AssignValues(Value: TMAPIAttachments);
    Function FindAttach(Const Value: String): TMAPIAttachment;
    Function IsEqual(Value: TMAPIAttachments): Boolean;
    Function CreateAttach(Const AttName, AttFileName, directory: String; AttNum:
      Integer; AttInterface: IAttach; pMethod: Integer): TMAPIAttachment;
    Function Add: TMAPIAttachment;
{$IFDEF VER130}
    Property Owner: TPersistent Read GetCollectionOwner;
{$ENDIF}
    Property Items[Index: Integer]: TMAPIAttachment Read GetItem Write SetItem;
    Default;
  End;

  {TMAPIAttachment}
  TMAPIAttachment = Class(TCollectionItem)
  Private
    FAttachments: TMAPIAttachments;
    FAttach: IAttach;
    FAttachName: String;
    FFileName: String;
    FStream: TIStream;
    FNumber: Integer;
  Protected
    Procedure AssignAttach(Attach: TMAPIAttachment);
    Function GetDisplayName: String; Override;
  Public
    Constructor Create(Collection: TCollection); Override;
    Destructor Destroy; Override;
    Procedure Assign(Source: TPersistent); Override;
    Function IsEqual(Value: TMAPIAttachment): Boolean;
    Property AttachStream: TIStream Read FStream;
    Property Number: Integer Read FNumber;
    Property Attach: IAttach Read FAttach;
  Published
    Property Name: String Read FAttachName Write FAttachName;
    Property FileName: String Read FFileName Write FFileName;
  End;

  {TMAPIMessages}
  TMAPIMessages = Class(TOwnedCollection)
  Protected
    FMAPISession: TMAPISession;
    FMessagesSubmited: Boolean;
  Private
{$IFDEF VER130}
    Function GetCollectionOwner: TPersistent;
{$ENDIF}
    Function GetItem(Index: Integer): TMAPIMessage;
    Procedure SetItem(Index: Integer; Const Value: TMAPIMessage);
    Procedure SetMessagesSubmited(Const Value: Boolean);
  Public
    Procedure AssignValues(Value: TMAPIMessages);
    Function FindMessage(Const Value: String): TMAPIMessage;
    Function IsEqual(Value: TMAPIMessages): Boolean;
    Function CreateMessage: TMAPIMessage;
    Function SubmitMessages: HRESULT;

    Property MAPISession: TMAPISession Read FMAPISession;
{$IFDEF VER130}
    Property Owner: TPersistent Read GetCollectionOwner;
{$ENDIF}
    Property Items[Index: Integer]: TMAPIMessage Read GetItem Write SetItem;
    Default;
  Published
    Property MessagesSubmited: Boolean Read FMessagesSubmited Write
      SetMessagesSubmited;
  End;

  {TMAPIMessage}
  TMAPIMessage = Class(TCollectionItem)
  Private
    FIMessage: IMAPIMessage;
    FMessageFlags: TMessageFlags;
    FSUBJECT: String;
    FBODY: String;
    FREPRESENTING_NAME: String;
    FMessageID: LPSBinary;
    FMAPISession: TMAPISession;
    FAttachments: TMAPIAttachments;
    FRecipients: TMAPIRecipients;
    FSize: Integer;
    FMessageDeliveryTime: TDateTime;
    FREPRESENTING_EMAIL_FROM: String;

    FREPRESENTING_EMAIL_TO: String;
    FREPRESENTING_MAPI_EMAIL_TO: String;
    FREPRESENTING_NAME_EMAIL_TO: String;
    Procedure SetAttachList(Const Value: TMAPIAttachments);
  Protected
    Function GetDisplayName: String; Override;
  Public
    Constructor Create(Collection: TCollection); Override;
    Destructor Destroy; Override;
    Property IMessage: IMAPIMessage Read FIMessage Write FIMessage;
    Property MessageID: LPSBinary Read FMessageID Write FMessageID;
    Function IsEqual(Value: TMAPIMessage): Boolean;
    Function GetBody: String;
    Function GetRTFBody: String;
    Function SetRead(Read: Boolean): Boolean;
    Property MAPISession: TMAPISession Read FMAPISession;
  Published
    Property Attachments: TMAPIAttachments Read FAttachments Write SetAttachList
      Stored False;
    Property Recipients: TMAPIRecipients Read FRecipients Stored False;
    Property REPRESENTING_NAME: String Read FREPRESENTING_NAME Write
      FREPRESENTING_NAME;

    Property REPRESENTING_EMAIL_FROM: String Read FREPRESENTING_EMAIL_FROM Write
      FREPRESENTING_EMAIL_FROM;

    Property REPRESENTING_EMAIL_TO: String Read FREPRESENTING_EMAIL_TO Write
      FREPRESENTING_EMAIL_TO;

    Property REPRESENTING_NAME_EMAIL_TO: String Read FREPRESENTING_NAME_EMAIL_TO
      Write
      FREPRESENTING_NAME_EMAIL_TO;

    Property REPRESENTING_MAPI_EMAIL_TO: String Read FREPRESENTING_MAPI_EMAIL_TO
      Write
      FREPRESENTING_MAPI_EMAIL_TO;

    Property SUBJECT: String Read FSUBJECT Write FSUBJECT;
    Property BODY: String Read FBODY Write FBODY;
    Property MessageFlags: TMessageFlags Read FMessageFlags;
    Property Size: Integer Read FSize;
    Property MessageDeliveryTime: TDateTime Read FMessageDeliveryTime;
  End;

  {TMAPIFolders}
  TMAPIFolders = Class(TOwnedCollection)
  Protected
    FMAPISession: TMAPISession;
  Private
{$IFDEF VER130}
    Function GetCollectionOwner: TPersistent;
{$ENDIF}
    Function GetItem(Index: Integer): TMAPIFolder;
    Procedure SetItem(Index: Integer; Const Value: TMAPIFolder);
  Public
    Procedure AssignValues(Value: TMAPIFolders);
    Function FindFolder(Const Value: String): TMAPIFolder;
    Function IsEqual(Value: TMAPIFolders): Boolean;
    Function CreateFolder: TMAPIFolder;
    Property MAPISession: TMAPISession Read FMAPISession;
{$IFDEF VER130}
    Property Owner: TPersistent Read GetCollectionOwner;
{$ENDIF}
    Property Items[Index: Integer]: TMAPIFolder Read GetItem Write SetItem; Default;
  End;

  {TMAPIFolder}
  TMAPIFolder = Class(TCollectionItem)
  Private
    FActive: boolean;
    FFolders: TMAPIFolders;
    FMAPISession: TMAPISession;
    FFolderEID: LPSBinary;
    FIFolder: IMAPIFolder;
    FFolderType: FOLDERS_TYPE;
    FMessages: TMAPIMessages;
    FDisplayName: String;
    FSUBJECT: String;
    FCOMMENT: String;
    fLoadAttach: Boolean;
    Function GetMAPIMessage(Index: Integer): TMAPIMessage;
    Function GetMAPIFolder(Index: Integer): TMAPIFolder;
    Function GetFoldersCount: Integer;
    Function GetMessagesCount: Integer;
    Function GetActive: boolean;
    Procedure SetActive(Const Value: boolean);
    Procedure GetMessageList;
    Procedure FreeMessageList;
    Procedure AssignFolder(Fold: TMAPIFolder);
    Procedure SetFolderEID(Const Value: LPSBinary);
    Procedure GetFolderList;
    Procedure FreeFolderList;
  Protected
    Function Open: boolean; Virtual;
    Function Close: boolean; Virtual;
    Function GetDisplayName: String; Override;
  Public
    Constructor Create(Collection: TCollection); Override;
    Destructor Destroy; Override;
    Procedure Assign(Source: TPersistent); Override;
    Function IsEqual(Value: TMAPIFolder): Boolean;
    Function DeleteMessage(Index: Integer): Boolean;
    Function DeleteToWaste(Index: Integer): Boolean;
    Property IFolder: IMAPIFolder Read FIFolder Write FIFolder;
    Property FolderEID: LPSBinary Read FFolderEID Write SetFolderEID;
    Property MAPIMessage[Index: Integer]: TMAPIMessage Read GetMAPIMessage;
    Property MessagesCount: Integer Read GetMessagesCount;
    Property Folder[Index: Integer]: TMAPIFolder Read GetMAPIFolder;
    Property FoldersCount: Integer Read GetFoldersCount;
    Property MAPISession: TMAPISession Read FMAPISession;
  Published
    Property Active: boolean Read GetActive Write SetActive;
    Property Folders: TMAPIFolders Read FFolders Write FFolders;
    Property Messages: TMAPIMessages Read FMessages Write FMessages;
    Property FolderType: FOLDERS_TYPE Read FFolderType Write FFolderType;
    Property DisplayName: String Read FDisplayName Write FDisplayName;
    Property SUBJECT: String Read FSUBJECT Write FSUBJECT;
    Property COMMENT: String Read FCOMMENT Write FCOMMENT;
    Property LoadAttach: Boolean Read fLoadAttach Write fLoadAttach Default False;
  End;

  {TMAPISession}
  TMAPISession = Class(TComponent)
  Private
    FActive: boolean;
    FStreamedActive: boolean;
    FLogonFlags: TMAPILogonFlags;
    FLogoffFlags: TMAPILogoffFlags;
    FProfileName: String;
    FPassword: String;
    m_pMDB: IMsgStore;
    m_pSpoolerStat: IMAPIStatus;
    FWindow: HWnd;
    FMAPIInit: MAPIINIT_0;
    FFolders: TMAPIFolders;
    fLoadWasteBox: Boolean;
    fAttachTempDirectory: String;
    Function GetActive: boolean;
    Procedure SetActive(Const Value: boolean);
    Function OpenDefStore: HRESULT;
    Function OpenIPMSubtree: HRESULT;
    Function GetSpoolerStatus: HRESULT;
    Function GetInBox: TMAPIFolder;
    Function GetOutBox: TMAPIFolder;
    Function GetWastBox: TMAPIFolder;
    Function GetSentBox: TMAPIFolder;
    Procedure SetAttachTempDirectory(Const Value: String);
    function GetAttachTempDirectory: String;
  Protected
    m_psbFolderEID: LPSBinary;
    m_pFolders: Array[0..ORD(FOLDERS_NUM_FOLDERS) - 1] Of IMAPIFolder;
    m_pSess: IMAPISession;
    m_pAddrBook: IAddrBook;
    Procedure Loaded; Override;
    Procedure Notification(AComponent: TComponent; Operation: TOperation); Override;
    Function Open: boolean; Virtual;
    Function Close: boolean; Virtual;
    Procedure ClearInterfaces;
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Function FlushQs: HRESULT;
    Function SimpleSend(DisplayNameRecip, sSUBJ, sBODY: String; Attachments:
      TStrings): HRESULT;
    Property Window: HWnd Read FWindow Write FWindow;
    Property MAPISession: IMAPISession Read m_pSess;
    Property AddrBook: IAddrBook Read m_pAddrBook;
  Published
    Property Active: boolean Read GetActive Write SetActive;
    Property LogonFlags: TMAPILogonFlags Read FLogonFlags;
    Property LogoffFlags: TMAPILogoffFlags Read FLogoffFlags;
    Property ProfileName: String Read FProfileName Write FProfileName;
    Property Password: String Read FPassword Write FPassword;
    Property INBOX: TMAPIFolder Read GetInBox Stored False;
    Property OUTBOX: TMAPIFolder Read GetOutBox Stored False;
    Property WASTEBOX: TMAPIFolder Read GetWastBox Stored False;
    Property SENTBOX: TMAPIFolder Read GetSentBox Stored False;
    Property LoadWasteBox: Boolean Read fLoadWasteBox Write fLoadWasteBox Default
      False;
    Property AttachTempDirectory: String Read GetAttachTempDirectory Write fAttachTempDirectory;
  End;

  {MAPI Macros}
Function PROP_TYPE(ulPropTag: ULONG): ULONG;
Function PROP_ID(ulPropTag: ULONG): ULONG;
Function PROP_TAG(ulPropType, ulPropID: ULONG): ULONG;
Function CHANGE_PROP_TYPE(ulPropTag, ulPropType: ULONG): ULONG;
Function MAKE_MAPI_SCODE(sev, fac, code: ULONG): SCODE;
Function MAKE_MAPI_E(err: ULONG): HRESULT;
Function MAKE_MAPI_S(warn: ULONG): HRESULT;

  //PR_NULL                 PROP_TAG(PT_NULL, PROP_ID_NULL)

Function CopySBinary(psbDest: LPSBinary; Const psbSrc: LPSBinary; pParent: Pointer):
  HRESULT; stdcall;
Function FileTimeToDateTime(ft: FILETIME): TDateTime;
Function LongTimeToDateTime(lt: LONG): TDateTime;

  {MAPI functions}
Function MAPIInitialize(lpMapiInit: pMAPIINIT_0): HRESULT; stdcall;
Procedure MAPIUninitialize; stdcall;
  {Extended MAPI Logon function}
Function MAPILogonEx(ulUIParam: ULONG;
  lpszProfileName: PChar;
  lpszPassword: PChar;
  ulFlags: ULONG; {ulFlags takes all that SimpleMAPI does + MAPI_UNICODE}
  lppSession: LPMAPISESSION): HRESULT; stdcall;
Function MAPIAllocateBuffer(cbSize: ULONG; lppBuffer: Pointer): SCODE; stdcall;
Function MAPIAllocateMore(cbSize: ULONG; lpObject: Pointer; lppBuffer: Pointer):
  SCODE; stdcall;
Function MAPIFreeBuffer(lpBuffer: Pointer): ULONG; stdcall;
Function HrQueryAllRows(lpTable: IMAPITable;
  lpPropTags: LPSPropTagArray;
  lpRestriction: LPSRestriction;
  lpSortOrderSet: LPSSortOrderSet;
  crowsMax: LONG;
  lppRows: LPPSRowSet): HRESULT; stdcall;
Procedure FreeProws(lpRows: LPSRowSet); stdcall;
Procedure FreePadrlist(lpAdrlist: LPADRLIST); stdcall;
Function HrGetOneProp(lpMapiProp: IMAPIProp; ulPropTag: ULONG; lppProp:
  LPPSPropValue): HRESULT; stdcall;
Function HrSetOneProp(lpMapiProp: IMAPIProp; lpProp: LPSPropValue): HRESULT;
stdcall;
Function OpenStreamOnFile(lpAllocateBuffer: LPALLOCATEBUFFER; lpFreeBuffer:
  LPFREEBUFFER; ulFlags: ULONG; lpszFileName: pChar; lpszPrefix: pChar; lppStream:
  LPSTREAM): HRESULT; stdcall;
Function WrapCompressedRTFStream(lpCompressedRTFStream: IStream; ulflags: ULONG; Var
  lpUncompressedRTFStream: IStream): HResult; stdcall;

Procedure Register;

Implementation

//Uses uCommon;

  //******************************************************************************
Procedure Register;
Begin
  RegisterComponents('VK MAPI', [TMAPISession]);
End;

Function MAPIInitialize; Stdcall; External 'MAPI32.DLL' name 'MAPIInitialize'
  {index 21};
Procedure MAPIUninitialize; Stdcall; External 'MAPI32.DLL' name 'MAPIUninitialize'
  {index 23};
Function MAPILogonEx; Stdcall; External 'MAPI32.DLL' {name 'MAPILogonEx'} Index 11;
Function MAPIAllocateBuffer; Stdcall; External 'MAPI32.DLL' name 'MAPIAllocateBuffer'
  {index 13};
Function MAPIAllocateMore; Stdcall; External 'MAPI32.DLL' name 'MAPIAllocateMore'
  {index 15};
Function MAPIFreeBuffer; Stdcall; External 'MAPI32.DLL' name 'MAPIFreeBuffer'
  {index 17};
Function HrQueryAllRows; Stdcall; External 'MAPI32.DLL' {name 'HrQueryAllRows'} Index
75;
Procedure FreeProws; Stdcall; External 'MAPI32.DLL' {name 'FreeProws'} Index 140;
Procedure FreePadrlist; Stdcall; External 'MAPI32.DLL' {name 'FreePadrlist'} Index
139;
Function HrGetOneProp; Stdcall; External 'MAPI32.DLL' {name 'HrGetOneProp'} Index
135;
Function HrSetOneProp; Stdcall; External 'MAPI32.DLL' {name 'HrSetOneProp'} Index
136;
Function OpenStreamOnFile; Stdcall; External 'MAPI32.DLL' {name 'OpenStreamOnFile'}
Index 147;
Function WrapCompressedRTFStream; Stdcall; External 'MAPI32.DLL' name
'WrapCompressedRTFStream';

{MAPI Macros}
Function PROP_TYPE(ulPropTag: ULONG): ULONG;
Begin
  Result := ulPropTag And PROP_TYPE_MASK;
End;
Function PROP_ID(ulPropTag: ULONG): ULONG;
Begin
  Result := ulPropTag Shr 16;
End;
Function PROP_TAG(ulPropType, ulPropID: ULONG): ULONG;
Begin
  Result := (ulPropID Shl 16) Or (ulPropType);
End;
Function CHANGE_PROP_TYPE(ulPropTag, ulPropType: ULONG): ULONG;
Begin
  Result := ($FFFF0000 And ulPropTag) Or ulPropType;
End;
Function MAKE_MAPI_SCODE(sev, fac, code: ULONG): SCODE;
Begin
  Result := (sev Shl 31) Or (fac Shl 16) Or (code);
End;
Function MAKE_MAPI_E(err: ULONG): HRESULT;
Begin
  Result := MAKE_MAPI_SCODE(1, FACILITY_ITF, err);
End;
Function MAKE_MAPI_S(warn: ULONG): HRESULT;
Begin
  Result := MAKE_MAPI_SCODE(0, FACILITY_ITF, warn);
End;

Function sysTempPath: String;
Var
  Buffer: Array[0..MAX_PATH] Of Char;
Begin
  SetString(Result, Buffer, GetTempPath(Sizeof(Buffer) - 1, Buffer));
End;

function fileTemp(const aExt: String): String;
var
  Buffer: array[0..MAX_PATH] of Char;
  aFile : String;
begin
  GetTempPath(Sizeof(Buffer)-1,Buffer);
  GetTempFileName(Buffer,'TMP',0,Buffer);
  SetString(aFile, Buffer, StrLen(Buffer));
  Result:=ChangeFileExt(aFile,aExt);
  RenameFile(aFile,Result);
end;


Function CopySBinary(psbDest: LPSBinary; Const psbSrc: LPSBinary; pParent: Pointer):
  HRESULT; Stdcall;
Var
  hRes: HRESULT;
Begin
  hRes := S_OK;
  psbDest.cb := psbSrc.cb;
  If (psbSrc.cb <> 0) Then
  Begin
    If (pParent <> Nil) Then
      hRes := MAPIAllocateMore(psbSrc.cb, pParent, pPointer(@psbDest.lpb))
    Else
      hRes := MAPIAllocateBuffer(psbSrc.cb, pPointer(@psbDest.lpb));
    Move(psbSrc.lpb^, psbDest.lpb^, psbSrc.cb);
  End;
  Result := hRes;
End;

Function FileTimeToDateTime(ft: FILETIME): TDateTime;
Var
  q, w, e: Int64;
Begin
  Result := EncodeDate(1601, 1, 1);
  q := ft.dwHighDateTime;
  q := q Shl 32;
  q := q + ft.dwLowDateTime;
  w := Trunc(q / 864000000000);
  e := q - (w * 864000000000);
  Result := Result + w + e / 864000000000;
End;

Function LongTimeToDateTime(lt: LONG): TDateTime;
Begin
  Result := lt / 864000000000;
End;

{ TMAPILogonFlags }

Constructor TMAPILogonFlags.Create;
Begin
  Inherited Create;
  FLOGON_UI := true;
  FNEW_SESSION := false;
  FALLOW_OTHERS := true;
  FEXPLICIT_PROFILE := false;
  FEXTENDED := false;
  FFORCE_DOWNLOAD := true;
  FSERVICE_UI_ALWAYS := false;
  FNO_MAIL := false;
  FNT_SERVICE := false;
  FPASSWORD_UI := false;
  FTIMEOUT_SHORT := false;
  FUSE_DEFAULT := true;
End;

Function TMAPILogonFlags.GetLogonFlag: ULONG;
Begin
  Result := 0;
  If FLOGON_UI Then
    Result := Result Or MAPI_LOGON_UI;
  If FNEW_SESSION Then
    Result := Result Or MAPI_NEW_SESSION;
  If FALLOW_OTHERS Then
    Result := Result Or MAPI_ALLOW_OTHERS;
  If FEXPLICIT_PROFILE Then
    Result := Result Or MAPI_EXPLICIT_PROFILE;
  If FEXTENDED Then
    Result := Result Or MAPI_EXTENDED;
  If FFORCE_DOWNLOAD Then
    Result := Result Or MAPI_FORCE_DOWNLOAD;
  If FSERVICE_UI_ALWAYS Then
    Result := Result Or MAPI_SERVICE_UI_ALWAYS;
  If FNO_MAIL Then
    Result := Result Or MAPI_NO_MAIL;
  If FNT_SERVICE Then
    Result := Result Or MAPI_NT_SERVICE;
  If FPASSWORD_UI Then
    Result := Result Or MAPI_PASSWORD_UI;
  If FTIMEOUT_SHORT Then
    Result := Result Or MAPI_TIMEOUT_SHORT;
  If FUSE_DEFAULT Then
    Result := Result Or MAPI_USE_DEFAULT;
End;

{ TMAPISession }

Procedure TMAPISession.ClearInterfaces;
Var
  i: Integer;
Begin
  m_pSpoolerStat := Nil;
  For i := 0 To ORD(FOLDERS_NUM_FOLDERS) - 1 Do
    m_pFolders[i] := Nil;
  m_pAddrBook := Nil;
  m_pMDB := Nil;
  m_pSess := Nil;
End;

Function TMAPISession.Close: boolean;
Var
  hr: HRESULT;
Begin
  Result := FActive;
  If FActive Then
  Begin
    hr := m_pSess.Logoff(FWindow, FLogoffFlags.LogoffFlag, 0);
    If Not FAILED(hr) Then
      Result := false;
  End;
  INBOX.Active := False;
  OUTBOX.Active := False;
  WASTEBOX.Active := False;
  SENTBOX.Active := False;
  If Not Result Then
    ClearInterfaces;
End;

Constructor TMAPISession.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  FMAPIInit.ulVersion := 0;
  FMAPIInit.ulFlags := MAPI_MULTITHREAD_NOTIFICATIONS;
  MAPIInitialize(@FMAPIInit);
  FLogonFlags := TMAPILogonFlags.Create;
  FLogoffFlags := TMAPILogoffFlags.Create;
  FFolders := TMAPIFolders.Create(self, TMAPIFolder);
  FFolders.FMAPISession := self;
  FWindow := 0;
  FProfileName := '';
  FPassword := '';
  FActive := false;
  ClearInterfaces;
  m_psbFolderEID := Nil;
  MAPIAllocateBuffer(ORD(FOLDERS_NUM_FOLDERS) * SizeOf(SBinary), @m_psbFolderEID);
  With FFolders.Add Do
    DisplayName := 'INBOX';
  With FFolders.Add Do
    DisplayName := 'OUTBOX';
  With FFolders.Add Do
    DisplayName := 'WASTEBOX';
  With FFolders.Add Do
    DisplayName := 'SENTBOX';
  //FINBOX := TMAPIFolder.Create(FFolders);
  //FOUTBOX := TMAPIFolder.Create(FFolders);
  //FWASTEBOX := TMAPIFolder.Create(FFolders);
  //FSENTBOX := TMAPIFolder.Create(FFolders);
End;

Destructor TMAPISession.Destroy;
Begin
  If Active Then
    Active := false;
  ClearInterfaces;
  FLogonFlags.Destroy;
  FLogoffFlags.Destroy;
  FFolders.Destroy;
  MAPIFreeBuffer(m_psbFolderEID);
  MAPIUninitialize;
  Inherited Destroy;
End;

Function TMAPISession.FlushQs: HRESULT;
Begin
  Result := m_pSpoolerStat.FlushQueues(FWindow, 0, Nil, FLUSH_FLAGS);
End;

Function TMAPISession.GetActive: boolean;
Begin
  Result := FActive;
End;

function TMAPISession.GetAttachTempDirectory: String;
begin
  If (Trim(fAttachTempDirectory) = '') Or Not DirectoryExists(fAttachTempDirectory)
    Then
    fAttachTempDirectory := sysTempPath;

  Result := fAttachTempDirectory;
end;

Function TMAPISession.GetInBox: TMAPIFolder;
Begin
  Result := TMAPIFolder(FFolders.Items[ORD(FOLDERS_INBOX)]);
End;

Function TMAPISession.GetOutBox: TMAPIFolder;
Begin
  Result := TMAPIFolder(FFolders.Items[ORD(FOLDERS_OUTBOX)]);
End;

Function TMAPISession.GetSentBox: TMAPIFolder;
Begin
  Result := TMAPIFolder(FFolders.Items[ORD(FOLDERS_SENT)]);
End;

Function TMAPISession.GetSpoolerStatus: HRESULT;
Type
  _SPropTagArray_sptCols = {Packed} Record
    cValues: ULONG;
    aulPropTag: Array[0..1] Of ULONG;
  End;
Var
  pTbl: IMAPITable;
  pStat: IMAPIStatus;
  pRow: LPSRowSet;
  hRes: HRESULT;
  sres: SRestriction;
  spv: SPropValue;
  ulObjType: ULONG;
  sptCols: _SPropTagArray_sptCols;
  qq: SPropValue;
Begin
  hRes := S_OK;
  Try
    sptCols.cValues := 2;
    sptCols.aulPropTag[0] := PROP_TAG(PT_LONG, $3E03); //PR_RESOURCE_TYPE
    sptCols.aulPropTag[1] := PROP_TAG(PT_BINARY, $0FFF); //PR_ENTRYID
    hRes := m_pSess.GetStatusTable(0, @pTbl);
    If (Not FAILED(hRes)) Then
    Begin
      sres.rt := RES_PROPERTY;
      sres.resProperty.relop := RELOP_EQ;
      sres.resProperty.ulPropTag := PROP_TAG(PT_LONG, $3E03); //PR_RESOURCE_TYPE
      sres.resProperty.lpProp := @spv;
      spv.ulPropTag := PROP_TAG(PT_LONG, $3E03); //PR_RESOURCE_TYPE
      spv.Value.l := MAPI_SPOOLER;
      hRes := HrQueryAllRows(pTbl,
        LPSPropTagArray(@sptCols),
        @sres,
        Nil,
        0,
        @pRow);
      If (Not FAILED(hRes)) Then
      Begin
        qq := LPSPropValue(pChar(pRow.aRow[0].lpProps) + SizeOf(SPropValue))^;
        If Not ((pRow.cRows <> 0) And (PROP_TAG(PT_BINARY, $0FFF) {PR_ENTRYID} =
          qq.ulPropTag)) Then
        Begin
          hRes := MAKE_MAPI_E($102); //MAPI_E_NOT_FOUND;
          Result := hRes;
          Exit;
        End;
        hRes := m_pSess.OpenEntry(qq.Value.bin.cb,
          LPENTRYID(qq.Value.bin.lpb),
          @IID_IMAPIStatus,
          MAPI_BEST_ACCESS,
          @ulObjType,
          LPUNKNOWN(@pStat));
        If (FAILED(hRes) Or (MAPI_STATUS <> ulObjType)) Then
        Begin
          If Not FAILED(hRes) Then
            hRes := MAKE_MAPI_E($108); //MAPI_E_INVALID_OBJECT
          Result := hRes;
          Exit;
        End;
        m_pSpoolerStat := pStat;
      End;
    End;
  Finally
    FreeProws(pRow);
    If pStat <> Nil Then
      pStat := Nil;
    If pTbl <> Nil Then
      pTbl := Nil;
    Result := hRes;
  End;
End;

Function TMAPISession.GetWastBox: TMAPIFolder;
Begin
  Result := TMAPIFolder(FFolders.Items[ORD(FOLDERS_WASTE)]);
End;

Procedure TMAPISession.Loaded;
Begin
  Inherited Loaded;
  If FStreamedActive Then
    Active := true;
End;

Procedure TMAPISession.Notification(AComponent: TComponent;
  Operation: TOperation);
Begin
  Inherited Notification(AComponent, Operation);
End;

Function TMAPISession.Open: boolean;
Var
  hr: HRESULT;
Begin
  ClearInterfaces;

  hr := MAPILogonEx(FWindow,
    pChar(FProfileName),
    pChar(FPassword),
    FLogonFlags.LogonFlag,
    @m_pSess);

  Result := Not FAILED(hr);
  If Result Then
  Begin
    hr := OpenDefStore;

    Result := Not FAILED(hr);
    If Not Result Then
      Exit;

    hr := m_pSess.OpenAddressBook(FWindow, Nil, 0, @m_pAddrBook);

    Result := Not FAILED(hr);
    If Not Result Then
      Exit;

    hr := OpenIPMSubtree;

    Result := Not FAILED(hr);
    If Not Result Then
      Exit;

    hr := GetSpoolerStatus;

    Result := Not FAILED(hr);
    If Not Result Then
      Exit;
  End;
End;

Function TMAPISession.OpenDefStore: HRESULT;
Type
  _SPropTagArray_sptCols = {Packed} Record
    cValues: ULONG;
    aulPropTag: Array[0..1] Of ULONG;
  End;
Var
  pStoresTbl: IMAPITable;
  pRow: LPSRowSet;
  sbEID: SBinary;
  sres: SRestriction;
  spv: SPropValue;
  hRes: HRESULT;
  sptCols: _SPropTagArray_sptCols;
Begin

  hRes := S_OK;

  Try

    sptCols.cValues := 2;
    sptCols.aulPropTag[0] := PROP_TAG(PT_BINARY, $0FFF); //PR_ENTRYID
    sptCols.aulPropTag[1] := PROP_TAG(PT_BOOLEAN, $3400); //PR_DEFAULT_STORE

    pStoresTbl := Nil;
    hRes := m_pSess.GetMsgStoresTable(FWindow, @pStoresTbl);
    If Not FAILED(hRes) Then
    Begin
      sres.rt := RES_PROPERTY;
      sres.resProperty.relop := RELOP_EQ;
      sres.resProperty.ulPropTag := PROP_TAG(PT_BOOLEAN, $3400); //PR_DEFAULT_STORE
      sres.resProperty.lpProp := @spv;

      spv.ulPropTag := PROP_TAG(PT_BOOLEAN, $3400); //PR_DEFAULT_STORE
      spv.Value.b := 1;

      pRow := Nil;
      hRes := HrQueryAllRows(pStoresTbl,
        LPSPropTagArray(@sptCols),
        @sres,
        Nil,
        0,
        @pRow);
      If Not FAILED(hRes) Then
      Begin
        If ((pRow <> Nil) And
          (pRow.cRows <> 0) And
          (pRow.aRow[0].cValues <> 0) And
          (PROP_TAG(PT_BINARY, $0FFF) = pRow.aRow[0].lpProps.ulPropTag)
          ) Then
          sbEID := pRow.aRow[0].lpProps.Value.bin
        Else
          hRes := MAKE_MAPI_E($102); //MAPI_E_NOT_FOUND;
        If Not FAILED(hRes) Then
        Begin
(*  origina
    m_pSess.OpenMsgStore(FWindow,
            sbEID.cb,
            LPENTRYID(sbEID.lpb),
            Nil,
            MDB_WRITE,
            @m_pMDB);*)

          m_pSess.OpenMsgStore(FWindow,
            sbEID.cb,
            LPENTRYID(sbEID.lpb),
            Nil,
            MDB_NO_DIALOG Or MDB_WRITE {or MDB_ONLINE},
            @m_pMDB);

            // using MDB_ONLINE returns only 250 messages...
        End;
      End;
    End;
  Finally
    FreeProws(pRow);
    If pStoresTbl <> Nil Then
      pStoresTbl := Nil;
    Result := hRes;
  End;
End;

Function TMAPISession.OpenIPMSubtree: HRESULT;
Type
  _SPropTagArray_sptFldrs = {Packed} Record
    cValues: ULONG;
    aulPropTag: Array[0..ORD(FOLDERS_NUM_FOLDERS) - 1] Of ULONG;
  End;
Var
  pProps: LPSPropValue;
  hRes: HRESULT;
  cProps, ulObjType: ULONG;
  sbInboxEID: SBinary;
  qq: LPSBinary;
  pp: LPSPropValue;
  i: Integer;
  sptFldrs: _SPropTagArray_sptFldrs;
Begin
  hRes := S_OK;
  Try
    sptFldrs.cValues := ORD(FOLDERS_NUM_FOLDERS);
    sptFldrs.aulPropTag[0] := PROP_TAG(PT_NULL, PROP_ID_NULL); //PR_NULL
    sptFldrs.aulPropTag[1] := PROP_TAG(PT_BINARY, $35E2); //PR_IPM_OUTBOX_ENTRYID
    sptFldrs.aulPropTag[2] := PROP_TAG(PT_BINARY, $35E3);
      //PR_IPM_WASTEBASKET_ENTRYID
    sptFldrs.aulPropTag[3] := PROP_TAG(PT_BINARY, $35E4); //PR_IPM_SENTMAIL_ENTRYID
    sptFldrs.aulPropTag[4] := PROP_TAG(PT_BINARY, $35E0); //PR_IPM_SUBTREE_ENTRYID
    pProps := Nil;
    cProps := 0;
    hRes := m_pMDB.GetProps(LPSPropTagArray(@sptFldrs),
      0,
      @cProps,
      @pProps);
    If Not FAILED(hRes) Then
    Begin
      sbInboxEID.cb := 0;
      sbInboxEID.lpb := Nil;
      hRes := m_pMDB.GetReceiveFolder(pChar('IPM.Note'),
        0,
        @sbInboxEID.cb,
        LPPENTRYID(@sbInboxEID.lpb),
        Nil);
      If Not FAILED(hRes) Then
      Begin
        For i := ORD(FOLDERS_INBOX) To ORD(FOLDERS_NUM_FOLDERS) - 1 Do
        Begin
          pp := LPSPropValue(pChar(pProps) + SizeOf(SPropValue) * i);
          If (pp.ulPropTag <> sptFldrs.aulPropTag[i]) Then
          Begin
            hRes := MAKE_MAPI_E($102); //MAPI_E_NOT_FOUND;
            Result := hRes;
            exit;
          End;
          // copy the folder's entry ID to class member
          qq := LPSBinary(pChar(m_psbFolderEID) + SizeOf(SBinary) * i);
          If i = ORD(FOLDERS_INBOX) Then
            hRes := CopySBinary(qq, //@m_psbFolderEID[i]
              @sbInboxEID,
              Pointer(m_psbFolderEID))
          Else
            hRes := CopySBinary(qq, //@m_psbFolderEID[i]
              @pp.Value.bin,
              Pointer(m_psbFolderEID));
          If FAILED(hRes) Then
          Begin
            Result := hRes;
            exit;
          End;
        End;
        For i := ORD(FOLDERS_INBOX) To ORD(FOLDERS_SENT) Do
        Begin
          qq := LPSBinary(pChar(m_psbFolderEID) + SizeOf(SBinary) * i);
          hRes := m_pSess.OpenEntry(qq.cb, //m_psbFolderEID[i].cb,
            LPENTRYID(qq.lpb), //LPENTRYID(m_psbFolderEID[i].lpb)
            Nil,
            MAPI_MODIFY,
            @ulObjType,
            LPUNKNOWN(@m_pFolders[i]));
          If (MAPI_FOLDER <> ulObjType) Then
          Begin
            hRes := MAKE_MAPI_E($108); //MAPI_E_INVALID_OBJECT
            Result := hRes;
            exit;
          End;
        End;

        qq := LPSBinary(pChar(m_psbFolderEID) + SizeOf(SBinary) *
          ORD(FOLDERS_INBOX));
        INBOX.FolderEID := qq;
        INBOX.IFolder := m_pFolders[ORD(FOLDERS_INBOX)];
        INBOX.DisplayName := 'INBOX';
        INBOX.FolderType := ftInbox;

        qq := LPSBinary(pChar(m_psbFolderEID) + SizeOf(SBinary) *
          ORD(FOLDERS_OUTBOX));
        OUTBOX.FolderEID := qq;
        OUTBOX.IFolder := m_pFolders[ORD(FOLDERS_OUTBOX)];
        OUTBOX.DisplayName := 'OUTBOX';
        OUTBOX.FolderType := ftOutbox;

        qq := LPSBinary(pChar(m_psbFolderEID) + SizeOf(SBinary) *
          ORD(FOLDERS_WASTE));
        WASTEBOX.FolderEID := qq;
        WASTEBOX.IFolder := m_pFolders[ORD(FOLDERS_WASTE)];
        WASTEBOX.DisplayName := 'WASTEBOX';
        WASTEBOX.FolderType := ftWastebox;

        qq := LPSBinary(pChar(m_psbFolderEID) + SizeOf(SBinary) *
          ORD(FOLDERS_SENT));
        SENTBOX.FolderEID := qq;
        SENTBOX.IFolder := m_pFolders[ORD(FOLDERS_SENT)];
        SENTBOX.DisplayName := 'SENTBOX';
        SENTBOX.FolderType := ftSentbox;

      End;
    End;
  Finally
    MAPIFreeBuffer(pProps);
    MAPIFreeBuffer(sbInboxEID.lpb);
    Result := hRes;
  End;
End;

Procedure TMAPISession.SetActive(Const Value: boolean);
Begin
  If (csReading In ComponentState) Then
    FStreamedActive := Value
  Else
  Begin
    If (Not FActive) And Value Then
    Begin
      FActive := Open;
      If FActive Then
      Begin
        INBOX.Active := true;
        OUTBOX.Active := true;

        If fLoadWasteBox Then
          WASTEBOX.Active := true;

        SENTBOX.Active := true;
      End;
    End;
    If FActive And (Not Value) Then
      FActive := Close;
  End;
End;

procedure TMAPISession.SetAttachTempDirectory(const Value: String);
begin

end;

Function TMAPISession.SimpleSend(DisplayNameRecip, sSUBJ, sBODY: String;
  Attachments: TStrings): HRESULT;
Var
  iMes: IMAPIMessage;
  pspvSaved: Array[0..1] Of SPropValue;
  pAdrList: LPADRLIST;
  eidMsg: ENTRYLIST;
  pspvEID: LPSPropValue;
  qq: LPSPropValue;
  i: Integer;
  pStrmDest, pStrmSrc: IStream;
  ulAttNum: ULONG;
  pAtt: IAttach;
  StatInfo: STATSTG;
  spvAttach: Array[0..2] Of SPropValue;
  hr: HRESULT;
Begin
  Result := m_pFolders[ORD(FOLDERS_OUTBOX)].CreateMessage(Nil, 0, @iMes);
  If Not FAILED(Result) Then
  Begin

    pspvSaved[0].ulPropTag := PROP_TAG(PT_TSTRING, $0037); //PR_SUBJECT;
    pspvSaved[0].Value.lpszA := pChar(sSUBJ);

    pspvSaved[1].ulPropTag := PROP_TAG(PT_TSTRING, $1000); //PR_BODY;
    pspvSaved[1].Value.lpszA := pChar(sBODY);

    //pspvSaved[2].ulPropTag := PROP_TAG(PT_LONG,      $0E07);    //PR_MESSAGE_FLAGS;
    //pspvSaved[2].Value.l := MSGFLAG_UNSENT or MSGFLAG_READ;     //MSGFLAG_SUBMIT | MSGFLAG_READ;

    Result := iMes.SetProps(2, @pspvSaved, Nil);
    If Not FAILED(Result) Then
    Begin
      pAdrList := Nil;
      MAPIAllocateBuffer(SizeOf(ADRLIST), @pAdrList);
      MAPIAllocateBuffer(SizeOf(SPropValue) * 2, @pAdrList.aEntries[0].rgPropVals);
      pAdrList.cEntries := 1;
      pAdrList.aEntries[0].cValues := 2;
      pAdrList.aEntries[0].rgPropVals.ulPropTag := PROP_TAG(PT_TSTRING, $3001);
        //PR_DISPLAY_NAME
      pAdrList.aEntries[0].rgPropVals.Value.lpszA := pChar(DisplayNameRecip);
      qq := LPSPropValue(pChar(pAdrList.aEntries[0].rgPropVals) +
        SizeOf(SPropValue));
      qq.ulPropTag := PROP_TAG(PT_LONG, $0C15); //PR_RECIPIENT_TYPE
      qq.Value.l := MAPI_TO;

      Result := m_pAddrBook.ResolveName(0, 0, Nil, pAdrList);
      //Result := m_pAddrBook.ResolveName(FWindow, MAPI_DIALOG, nil, pAdrList);
      //if Result = MAKE_MAPI_E( $700 ) then
      //  beep;
      //if Result = MAKE_MAPI_E( $10F ) then
      //  beep;
      If Not FAILED(Result) Then
      Begin
        Result := iMes.ModifyRecipients(0, pAdrList);
        If Not FAILED(Result) Then
        Begin
          Result := iMes.SaveChanges(KEEP_OPEN_READWRITE);
          If Not FAILED(Result) Then
          Begin
            If Assigned(Attachments) And Attachments.InheritsFrom(TStrings) Then
            Begin
              For i := 0 To Attachments.Count - 1 Do
              Begin
                //Routine attachment
                pStrmSrc := Nil;
                hr := OpenStreamOnFile(@MAPIAllocateBuffer,
                  @MAPIFreeBuffer,
                  0,
                  pChar(Attachments.Strings[i]),
                  Nil,
                  @pStrmSrc);
                If Not FAILED(hr) Then
                Begin
                  pAtt := Nil;
                  hr := iMes.CreateAttach(Nil, 0, @ulAttNum, @pAtt);
                  If Not FAILED(hr) Then
                  Begin
                    pStrmDest := Nil;
                    hr := pAtt.OpenProperty(PROP_TAG(PT_BINARY, $3701),
                      //PR_ATTACH_DATA_BIN
                      @IID_IStream,
                      0,
                      MAPI_MODIFY Or MAPI_CREATE,
                      LPUNKNOWN(@pStrmDest));
                    If Not FAILED(hr) Then
                    Begin
                      pStrmSrc.Stat(@StatInfo, 1 {STATFLAG_NONAME});
                      hr := pStrmSrc.CopyTo(pStrmDest,
                        StatInfo.cbSize,
                        Nil,
                        Nil);
                      If Not FAILED(hr) Then
                      Begin
                        spvAttach[0].ulPropTag := PROP_TAG(PT_TSTRING, $3704);
                          //PR_ATTACH_FILENAME;
                        spvAttach[0].Value.lpszA := pChar(Attachments.Strings[i]);

                        spvAttach[1].ulPropTag := PROP_TAG(PT_LONG, $3705);
                          //PR_ATTACH_METHOD;
                        spvAttach[1].Value.l := ATTACH_BY_VALUE;

                        spvAttach[2].ulPropTag := PROP_TAG(PT_LONG, $370B);
                          //PR_RENDERING_POSITION;
                        spvAttach[2].Value.l := -1;

                        hr := pAtt.SetProps(3, @spvAttach, Nil);
                        If Not FAILED(hr) Then
                          pAtt.SaveChanges(0);
                      End;
                    End;
                    pStrmDest := Nil;
                  End;
                  pAtt := Nil;
                End;
                pStrmSrc := Nil;
                //
              End;
            End;

            Result := iMes.SubmitMessage(0);
            If Not FAILED(Result) Then
              Result := m_pSpoolerStat.FlushQueues(FWindow, 0, Nil, FLUSH_FLAGS);
          End;
        End;
      End;
      FreePadrlist(pAdrList);
    End;
  End;
  //Delete Submited message
  pspvEID := Nil;
  HrGetOneProp(iMes, PROP_TAG(PT_BINARY, $0FFF), @pspvEID);
  eidMsg.cValues := 1;
  eidMsg.lpbin := @pspvEID.Value.bin;
  iMes := Nil;
  m_pFolders[ORD(FOLDERS_OUTBOX)].DeleteMessages(@eidMsg,
    FWindow,
    Nil,
    MESSAGE_DIALOG);
  //
  //if FAILED(Result) then OleCheck(Result);
End;

{ TMAPILogoffFlags }

Constructor TMAPILogoffFlags.Create;
Begin
  Inherited Create;
  FLOGOFF_SHARED := false;
  FLOGOFF_UI := false;
End;

Function TMAPILogoffFlags.GetLogoffFlag: ULONG;
Begin
  Result := 0;
  If FLOGOFF_SHARED Then
    Result := Result Or MAPI_LOGOFF_SHARED;
  If FLOGOFF_UI Then
    Result := Result Or MAPI_LOGOFF_UI;
End;

{ TMessageFlags }

Constructor TMessageFlags.Create;
Begin
  Inherited Create;
  FREAD := false;
  FUNMODIFIED := false;
  FSUBMIT := false;
  FUNSENT := false;
  FHASATTACH := false;
  FFROMME := false;
  FASSOCIATED := false;
  FRESEND := false;
  FRN_PENDING := false;
  FNRN_PENDING := false;
End;

Function TMessageFlags.GetMessageFlag: ULONG;
Begin
  Result := 0;
  If FREAD Then
    Result := Result Or MSGFLAG_READ;
  If FUNMODIFIED Then
    Result := Result Or MSGFLAG_UNMODIFIED;
  If FSUBMIT Then
    Result := Result Or MSGFLAG_SUBMIT;
  If FUNSENT Then
    Result := Result Or MSGFLAG_UNSENT;
  If FHASATTACH Then
    Result := Result Or MSGFLAG_HASATTACH;
  If FFROMME Then
    Result := Result Or MSGFLAG_FROMME;
  If FASSOCIATED Then
    Result := Result Or MSGFLAG_ASSOCIATED;
  If FRESEND Then
    Result := Result Or MSGFLAG_RESEND;
  If FRN_PENDING Then
    Result := Result Or MSGFLAG_RN_PENDING;
  If FNRN_PENDING Then
    Result := Result Or MSGFLAG_NRN_PENDING;
End;

Procedure TMessageFlags.SetMessageFlag(Const Value: ULONG);
Begin
  FREAD := false;
  FUNMODIFIED := false;
  FSUBMIT := false;
  FUNSENT := false;
  FHASATTACH := false;
  FFROMME := false;
  FASSOCIATED := false;
  FRESEND := false;
  FRN_PENDING := false;
  FNRN_PENDING := false;
  If (Value And MSGFLAG_READ) = MSGFLAG_READ Then
    FREAD := true;
  If (Value And MSGFLAG_UNMODIFIED) = MSGFLAG_UNMODIFIED Then
    FUNMODIFIED := true;
  If (Value And MSGFLAG_SUBMIT) = MSGFLAG_SUBMIT Then
    FSUBMIT := true;
  If (Value And MSGFLAG_UNSENT) = MSGFLAG_UNSENT Then
    FUNSENT := true;
  If (Value And MSGFLAG_HASATTACH) = MSGFLAG_HASATTACH Then
    FHASATTACH := true;
  If (Value And MSGFLAG_FROMME) = MSGFLAG_FROMME Then
    FFROMME := true;
  If (Value And MSGFLAG_ASSOCIATED) = MSGFLAG_ASSOCIATED Then
    FASSOCIATED := true;
  If (Value And MSGFLAG_RESEND) = MSGFLAG_RESEND Then
    FRESEND := true;
  If (Value And MSGFLAG_RN_PENDING) = MSGFLAG_RN_PENDING Then
    FRN_PENDING := true;
  If (Value And MSGFLAG_NRN_PENDING) = MSGFLAG_NRN_PENDING Then
    FNRN_PENDING := true;
End;

{ TMAPIMessage }

Constructor TMAPIMessage.Create(Collection: TCollection);
Begin
  Inherited Create(Collection);
  FIMessage := Nil;
  FMessageFlags := TMessageFlags.Create;
  FAttachments := TMAPIAttachments.Create(self, TMAPIAttachment);
  FRecipients := TMAPIRecipients.Create(self, TMAPIRecipient); ;
  FMessageID := Nil;
  MAPIAllocateBuffer(SizeOf(SBinary), @FMessageID);
End;

Destructor TMAPIMessage.Destroy;
Begin
  FAttachments.Destroy;
  FMessageFlags.Destroy;
  FRecipients.Destroy;
  FIMessage := Nil;
  MAPIFreeBuffer(FMessageID);
  Inherited Destroy;
End;

Function TMAPIMessage.GetBody: String;
Var
  pStream: IStream;
  StatInfo: STATSTG;
  hr: HRESULT;
  pBody: PChar;
  sBody: String;
Begin
  //PR_BODY
  hr := FIMessage.OpenProperty(PROP_TAG(PT_TSTRING, $1000), @IID_IStream,
    0, 0, LPUNKNOWN(@pStream));
  If Not FAILED(hr) Then
  Begin
    pStream.Stat(@StatInfo, 1 {STATFLAG_NONAME});
    //pBody := nil;
    GetMem(pBody, StatInfo.cbSize);
    hr := pStream.Read(pBody, StatInfo.cbSize, Nil);
    pStream := Nil;
    If Not FAILED(hr) Then
      sBody := pBody
    Else
      sBody := '';
    FreeMemory(pBody);
  End;
  Result := sBody;
End;

Function TMAPIMessage.GetDisplayName: String;
Begin
  Result := 'from ' + REPRESENTING_NAME + ' , subj: ' + SUBJECT;
End;

Function TMAPIMessage.GetRTFBody: String;
Var
  pStream: IStream;
  pRTFStream: IStream;
  //StatInfo : STATSTG;
  hr: HRESULT;
  pBody: PChar;
  sBody: String;
  iCBRead: Integer;
Begin
  pStream := Nil;
  hr := FIMessage.OpenProperty(PROP_TAG(PT_BINARY, $1009), @IID_IStream,
    0, 0, LPUNKNOWN(@pStream));
  If Not FAILED(hr) Then
  Begin
    pRTFStream := Nil;
    WrapCompressedRTFStream(pStream, 0, pRTFStream);
    GetMem(pBody, 4100);
    iCBRead := 1;
    sBody := '';
    //stat doesn't work on returned RTF stream
    While iCBRead > 0 Do
    Begin
      ZeroMemory(pBody, 4100);
      pRTFStream.Read(pBody, 4095, @iCBRead);
      sBody := sBody + pBody;
    End;
    FreeMemory(pBody);
    pRTFStream := Nil;
    pStream := Nil;
  End;

  Result := sBody;
End;

Function TMAPIMessage.IsEqual(Value: TMAPIMessage): Boolean;
Begin
  Result := false;
End;

Procedure TMAPIMessage.SetAttachList(Const Value: TMAPIAttachments);
Begin
  FAttachments.Assign(Value);
End;

Function TMAPIMessage.SetRead(Read: Boolean): Boolean;
Var
  Flags: Integer;
  hr: HRESULT;
Begin
  If Not Read Then
    Flags := CLEAR_READ_FLAG
  Else
    Flags := 0;
  hr := FIMessage.SetReadFlag(Flags);
  Result := Not FAILED(hr)
End;

{ TMAPIFolder }

Function TMAPIFolder.Close: boolean;
Begin
  Result := false;
  FreeMessageList;
  FreeFolderList;
End;

Constructor TMAPIFolder.Create(Collection: TCollection);
Begin
  Inherited Create(Collection);
  FFolders := TMAPIFolders.Create(self, TMAPIFolder);
  FMAPISession := TMAPIFolders(Collection).FMAPISession;
  FFolders.FMAPISession := FMAPISession;
  FMessages := TMAPIMessages.Create(self, TMAPIMessage);
  FMessages.FMAPISession := FMAPISession;
  FFolderType := ftInbox;
  FIFolder := Nil;
  FFolderEID := Nil;
  MAPIAllocateBuffer(SizeOf(SBinary), @FFolderEID);
End;

Destructor TMAPIFolder.Destroy;
Begin
  If Active Then
    Active := false;
  FIFolder := Nil;
  MAPIFreeBuffer(FFolderEID);
  FFolders.Destroy;
  FMessages.Destroy;
  Inherited Destroy;
End;

Function TMAPIFolder.GetActive: boolean;
Begin
  Result := FActive;
End;

Function TMAPIFolder.GetFoldersCount: Integer;
Begin
  Result := FFolders.Count;
End;

Function TMAPIFolder.GetMAPIFolder(Index: Integer): TMAPIFolder;
Begin
  Result := TMAPIFolder(FFolders.Items[Index]);
End;

Function TMAPIFolder.GetMAPIMessage(Index: Integer): TMAPIMessage;
Begin
  Result := TMAPIMessage(FMessages.Items[Index]);
End;

Function TMAPIFolder.GetMessagesCount: Integer;
Begin
  Result := FMessages.Count;
End;

Function TMAPIFolder.Open: boolean;
Begin
  Result := true;
  If FMAPISession <> Nil Then
  Begin
    If FMAPISession.Active Then
    Begin
      If FIFolder <> Nil Then
      Begin
        If FFolderEID <> Nil Then
        Begin
          FreeMessageList;
          FreeFolderList;
          GetFolderList;
          GetMessageList;
        End
        Else
          Result := false;
      End
      Else
        Result := false;
    End
    Else
      Result := false;
  End
  Else
    Result := false;
End;

Procedure TMAPIFolder.SetActive(Const Value: boolean);
Begin
  If (Not FActive) And Value Then
    FActive := Open;
  If FActive And (Not Value) Then
    FActive := Close;
End;

Procedure TMAPIFolder.FreeMessageList;
Var
  oMess: TMAPIMessage;
Begin
  If FMessages.Count <> 0 Then
  Begin
    While FMessages.Count <> 0 Do
    Begin
      oMess := TMAPIMessage(FMessages.Items[0]);
      oMess.Destroy;
    End;
    FMessages.Clear;
  End;
End;

Procedure TMAPIFolder.FreeFolderList;
Var
  oFold: TMAPIFolder;
Begin
  If FFolders.Count <> 0 Then
  Begin
    While FFolders.Count > 0 Do
    Begin
      oFold := TMAPIFolder(FFolders.Items[0]);
      oFold.Destroy;
    End;
    FFolders.Clear;
  End;
End;

Procedure TMAPIFolder.GetFolderList;
Type
  _SPropTagArray_sptCols = {Packed} Record
    cValues: ULONG;
    aulPropTag: Array[0..4] Of ULONG;
  End;
Var
  pCTbl: IMAPITable;
  pRows: LPSRowSet;
  sptCols: _SPropTagArray_sptCols;
  i: Integer;
  oFolder: TMAPIFolder;
  qq: LPSPropValue;
  ulObjType: ULONG;
Begin
  pCTbl := Nil;
  pRows := Nil;
  sptCols.cValues := 5;
  sptCols.aulPropTag[0] := PROP_TAG(PT_TSTRING, $3001); //PR_DISPLAY_NAME
  sptCols.aulPropTag[1] := PROP_TAG(PT_TSTRING, $0037); //PR_SUBJECT
  sptCols.aulPropTag[2] := PROP_TAG(PT_BINARY, $0FFF); //PR_ENTRYID
  sptCols.aulPropTag[3] := PROP_TAG(PT_LONG, $3601); //PR_FOLDER_TYPE
  sptCols.aulPropTag[4] := PROP_TAG(PT_TSTRING, $3004); //PR_COMMENT
  Try
    FIFolder.GetHierarchyTable(0, @pCTbl);
    HrQueryAllRows(pCTbl,
      LPSPropTagArray(@sptCols),
      Nil,
      Nil,
      0,
      @pRows);
    For i := 0 To pRows.cRows - 1 Do
    Begin
      qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) * 2);
      If (PROP_TAG(PT_BINARY, $0FFF) = qq.ulPropTag) Then //PR_ENTRYID
      Begin
        oFolder := TMAPIFolder(FFolders.Add);
        CopySBinary(oFolder.FolderEID,
          @qq.Value.bin,
          oFolder.FolderEID);
        MAPISession.MAPISession.OpenEntry(oFolder.FolderEID.cb,
          //m_psbFolderEID[i].cb,
          LPENTRYID(oFolder.FolderEID.lpb), //LPENTRYID(m_psbFolderEID[i].lpb)
          Nil,
          MAPI_MODIFY,
          @ulObjType,
          LPUNKNOWN(@oFolder.FIFolder));
        qq := LPSPropValue(pChar(pRows.aRow[i].lpProps));
        If (PROP_TAG(PT_TSTRING, $3001) = qq.ulPropTag) Then //PR_DISPLAY_NAME
          oFolder.DisplayName := qq.Value.lpszA
        Else
          oFolder.DisplayName := '';
        qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) * 1);
        If (PROP_TAG(PT_TSTRING, $0037) = qq.ulPropTag) Then //PR_SUBJECT
          oFolder.SUBJECT := qq.Value.lpszA
        Else
          oFolder.SUBJECT := '';
        qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) * 4);
        If (PROP_TAG(PT_TSTRING, $3004) = qq.ulPropTag) Then //PR_COMMENT
          oFolder.SUBJECT := qq.Value.lpszA
        Else
          oFolder.SUBJECT := '';

      End;
    End;
  Finally
    FreeProws(pRows);
    pCTbl := Nil;
  End;
End;

(*
Procedure TMAPIFolder.GetMessageList;
Type
  _SPropTagArray_sptCols = {Packed} Record
    cValues: ULONG;
    aulPropTag: Array[0..10] Of ULONG;
  End;
  _SPropTagArray_sptColsAtt = {Packed} Record
    cValues: ULONG;
    aulPropTag: Array[0..4] Of ULONG;
  End;

Var
  pCTbl: IMAPITable;
  pAttRows, pRows: LPSRowSet;
  sptCols: _SPropTagArray_sptCols;
  sptColsAtt: _SPropTagArray_sptColsAtt;
  i, j: Integer;
  k, l: ULONG;
  oMes: TMAPIMessage;
  qq, qq1, qq2: LPSPropValue;
  ulObjType: ULONG;
  AttachTable: IMAPITable;
  IAtt: IAttach;
  hRes: HRESULT;

  pStreamFile, pStreamAtt: IStream;
  hr: HRESULT;
  StatInfo : STATSTG;
  pAdrList: LPADRLIST;
Begin
  pCTbl := Nil;
  pRows := Nil;
  sptCols.cValues := 11;
  sptCols.aulPropTag[0] := PROP_TAG(PT_TSTRING, $0042); //PR_SENT_REPRESENTING_NAME
  sptCols.aulPropTag[1] := PROP_TAG(PT_TSTRING, $0037); //PR_SUBJECT
  sptCols.aulPropTag[2] := PROP_TAG(PT_BINARY, $0FFF); //PR_ENTRYID
  sptCols.aulPropTag[3] := PROP_TAG(PT_LONG, $0E07); //PR_MESSAGE_FLAGS
  sptCols.aulPropTag[4] := PROP_TAG(PT_TSTRING, $1000); //PR_BODY;
  sptCols.aulPropTag[5] := PROP_TAG(PT_LONG, $0E08); //PR_MESSAGE_SIZE
  sptCols.aulPropTag[6] := PROP_TAG(PT_SYSTIME, $0E06); //PR_MESSAGE_DELIVERY_TIME
  sptCols.aulPropTag[7] := PROP_TAG(PT_TSTRING, $0065);  //PR_SENT_REPRESENTING_EMAIL_ADDRESS

  sptCols.aulPropTag[8] := PROP_TAG(PT_TSTRING, $0076); // PR_RECEIVED_BY_EMAIL_ADDRESS
  sptCols.aulPropTag[9] := PROP_TAG(PT_TSTRING, $0E04); // PR_DISPLAY_TO
  sptCols.aulPropTag[10] := PROP_TAG(PT_TSTRING, $0078); // PR_ORIGINAL_SENT_REPRESENTING_EMAIL_ADDRESS

  Try
    FIFolder.GetContentsTable(0, @pCTbl);

    pCTbl.SetColumns(@sptCols, 0);

    HrQueryAllRows(pCTbl,
      LPSPropTagArray(@sptCols),
      Nil,
      Nil,
      0,
      @pRows);
    For i := 0 To pRows.cRows - 1 Do
    Begin
      qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) * 2);
      If (PROP_TAG(PT_BINARY, $0FFF) = qq.ulPropTag) Then //PR_ENTRYID
      Begin

        ////
        ////    Redo
        ////
        //oMes := TMAPIMessage.Create(nil);
        oMes := TMAPIMessage(FMessages.Add);
        ////
        ////

        oMes.FMAPISession := self.MAPISession;

        hRes := -1;
        Try
          hRes := CopySBinary(oMes.MessageID,
            @qq.Value.bin,
            oMes.MessageID);
        Except
        End;

        // added by vini
        If hRes = 0 Then
        Begin
          hRes := -1;
          Try
            hRes := MAPISession.MAPISession.OpenEntry(oMes.MessageID.cb,
              LPENTRYID(oMes.MessageID.lpb),
              Nil,
              MAPI_MODIFY,
              @ulObjType,
              LPUNKNOWN(@oMes.FIMessage));
          Except
            on e:exception do
            begin
              hRes := -1;
              oMes.FIMessage := nil;
            end;
          End;

          // added by vini
          If (hRes = 0) And (oMes.FIMessage <> Nil) Then
          Begin
            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps));
            If (PROP_TAG(PT_TSTRING, $0042) = qq.ulPropTag) Then
              //PR_SENT_REPRESENTING_NAME
              oMes.FREPRESENTING_NAME := String(qq.Value.lpszA)
            Else
              oMes.FREPRESENTING_NAME := '<no sender>';

            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) *
              1);
            If (PROP_TAG(PT_TSTRING, $0037) = qq.ulPropTag) Then //PR_SUBJECT
              oMes.FSUBJECT := String(qq.Value.lpszA)
            Else
              oMes.FSUBJECT := '<no subject>';

            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) *
              4);
            If (PROP_TAG(PT_TSTRING, $1000) = qq.ulPropTag) Then //PR_BODY;
              oMes.FBODY := String(qq.Value.lpszA)
            Else
              oMes.FBODY := '';

            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) *
              3);
            If (PROP_TAG(PT_LONG, $0E07) = qq.ulPropTag) Then //PR_MESSAGE_FLAGS
              oMes.MessageFlags.MessageFlag := qq.Value.l
            Else
              oMes.MessageFlags.MessageFlag := 0;

            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) *
              5);
            If (PROP_TAG(PT_LONG, $0E08) = qq.ulPropTag) Then //PR_MESSAGE_SIZE
              oMes.FSize := qq.Value.l
            Else
              oMes.FSize := 0;

            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) *
              6);
            If (PROP_TAG(PT_SYSTIME, $0E06) = qq.ulPropTag) Then
              //PR_MESSAGE_DELIVERY_TIME
              oMes.FMessageDeliveryTime := FileTimeToDateTime(qq.Value.ft)
            Else
              oMes.FMessageDeliveryTime := 0;

            // added by vini
            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) *
              7);

            If (PROP_TAG(PT_TSTRING, $0065) = qq.ulPropTag) Then
              //PR_SENT_REPRESENTING_EMAIL_ADDRESS
              oMes.FREPRESENTING_EMAIL_FROM := String(qq.Value.lpszA)
            Else
              oMes.FREPRESENTING_EMAIL_FROM := '';

            // original mail sent to //PR_RECEIVED_BY_EMAIL_ADDRESS
            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) *
              8);

            If (PROP_TAG(PT_TSTRING, $0076) = qq.ulPropTag) Then
              oMes.FREPRESENTING_MAPI_EMAIL_TO := String(qq.Value.lpszA)
            Else
              oMes.FREPRESENTING_MAPI_EMAIL_TO := '';

            //PR_DISPLAY_TO
            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) *
              9);
            If (PROP_TAG(PT_TSTRING, $0E04) = qq.ulPropTag) Then
              oMes.REPRESENTING_NAME_EMAIL_TO := String(qq.Value.lpszA)
            Else
              oMes.REPRESENTING_NAME_EMAIL_TO := '';

            If oMes.MessageFlags.HASATTACH Then
            Begin
              //Add attachments to a message
              Try
                AttachTable := Nil;
                hRes := -1;
                Try
                  if oMes.FIMessage <> nil then
                    hRes := oMes.FIMessage.GetAttachmentTable(0, @AttachTable);
                Except
                  on e:exception do
                  begin
                    AttachTable := Nil;
                    hRes := -1;
                  end;
                End; {try}

                If (hRes = 0) And (AttachTable <> Nil) Then
                Begin
                  sptColsAtt.cValues := 5;
                  sptColsAtt.aulPropTag[0] := PROP_TAG(PT_LONG, $0E21);
                    //PR_ATTACH_NUM
                  //sptColsAtt.aulPropTag[1] := PROP_TAG(PT_TSTRING, $3704);
                  sptColsAtt.aulPropTag[1] := PROP_TAG(PT_TSTRING, $3707); //
                    //PR_ATTACH_FILENAME
                    // PR_ATTACH_LONG_FILENAME 3707

                  sptColsAtt.aulPropTag[2] := PROP_TAG(PT_TSTRING, $3703);
                    //PR_ATTACH_EXTENSION
                  sptColsAtt.aulPropTag[3] := PROP_TAG(PT_LONG, $3705);
                    //PR_ATTACH_METHOD
                  sptColsAtt.aulPropTag[4] := PROP_TAG(PT_TSTRING, $3708);
                    //PR_ATTACH_PATHNAME

                  AttachTable.SetColumns(LPSPropTagArray(@sptColsAtt), 0);
                  AttachTable.GetRowCount(0, @k);
                  For j := 0 To k - 1 Do
                  Begin
                    Try
                      pAttRows := Nil;

                      hRes := -1;
                      Try
                        hRes := AttachTable.QueryRows(1, 0, @pAttRows);
                      Except
                        on e:exception do
                        begin
                          hRes := -1;
                          pAttRows := nil;
                        end;
                      End;

                      If (hRes = 0) and (pAttRows <> nil) Then
                      Begin
                        If pAttRows.aRow[0].lpProps.ulPropTag = PROP_TAG(PT_LONG,
                          $0E21) Then //PR_ATTACH_NUM
                        Begin
                          l := pAttRows.aRow[0].lpProps.Value.l;
                          IAtt := Nil;

                          Try
                            //hRes := oMes.FIMessage.OpenAttach(l, Nil, 0, @IAtt);
                            hRes := oMes.FIMessage.OpenAttach(l, Nil, MAPI_BEST_ACCESS, @IAtt);
                          Except
                            on e:exception do
                            begin
                              hRes := -1;
                              IAtt := Nil;
                            end;
                          End;

                          If (hRes = 0) And (IAtt <> Nil) Then
                          Begin
                            qq1 := LPSPropValue(pChar(pAttRows.aRow[0].lpProps) +
                              SizeOf(SPropValue) * 1); ////PR_ATTACH_FILENAME

                            If (Not FAILED(qq1.Value.err)) Then
                            begin
                              qq2 := LPSPropValue(pChar(pAttRows.aRow[0].lpProps) + SizeOf(SPropValue) * 3);

                              {dont try saving ole messages}
                              if not (qq2.ulPropTag in [PROP_TAG(PT_LONG, ATTACH_OLE), PROP_TAG(PT_LONG, ATTACH_EMBEDDED_MSG)]) then
                              begin

                                try
                                  oMes.Attachments.CreateAttach(ExtractFileName(qq1.Value.lpszA), qq1.Value.lpszA, l, IAtt);
                                except
                                  on e:exception do
                                  begin

                                  end;
                                end;
                              end
                            end;
                            //    Fix this later ...
                            //else
                            //  oMes.Attachments.CreateAttach('Untitled', 'Untitled.tmp', l, IAtt);
                          End;
                        End; {If pAttRows.aRow[0].lpProps.ulPropTag = PROP_TAG(PT_LONG, $0E21)}
                      End {If hRes = 0 Then}
                      Else If pAttRows <> nil Then
                        FreeProws(pAttRows);
                    Finally
                      if pAttRows <> nil then
                        FreeProws(pAttRows);

                      IAtt := Nil;
                    End;
                  End;
                End;
              Finally
                AttachTable := Nil;
              End;
            End
          End
          Else {// added by vini} If Assigned(oMes) Then
            oMes.free;
        End
        Else {// added by vini} If assigned(oMes) Then
          oMes.Free;

      End;
    End;
  Finally
    if pRows <> nil then
      FreeProws(pRows);
    pCTbl := Nil;
  End;
End;*)

Procedure TMAPIFolder.GetMessageList;
Type
  _SPropTagArray_sptCols = {Packed} Record
    cValues: ULONG;
    aulPropTag: Array[0..10] Of ULONG;
  End;
  _SPropTagArray_sptColsAtt = {Packed} Record
    cValues: ULONG;
    aulPropTag: Array[0..4] Of ULONG;
  End;

Var
  pCTbl: IMAPITable;
  pAttRows, pRows: LPSRowSet;
  sptCols: _SPropTagArray_sptCols;
  sptColsAtt: _SPropTagArray_sptColsAtt;
  i, j: Integer;
  k, l: ULONG;
  oMes: TMAPIMessage;
  qq, qq1, qq2: LPSPropValue;
  ulObjType: ULONG;
  AttachTable: IMAPITable;
  IAtt: IAttach;
  hRes: HRESULT;
Begin
  pCTbl := Nil;
  pRows := Nil;
  sptCols.cValues := 11;
  sptCols.aulPropTag[0] := PROP_TAG(PT_TSTRING, $0042); //PR_SENT_REPRESENTING_NAME
  sptCols.aulPropTag[1] := PROP_TAG(PT_TSTRING, $0037); //PR_SUBJECT
  sptCols.aulPropTag[2] := PROP_TAG(PT_BINARY, $0FFF); //PR_ENTRYID
  sptCols.aulPropTag[3] := PROP_TAG(PT_LONG, $0E07); //PR_MESSAGE_FLAGS
  sptCols.aulPropTag[4] := PROP_TAG(PT_TSTRING, $1000); //PR_BODY;
  sptCols.aulPropTag[5] := PROP_TAG(PT_LONG, $0E08); //PR_MESSAGE_SIZE
  sptCols.aulPropTag[6] := PROP_TAG(PT_SYSTIME, $0E06); //PR_MESSAGE_DELIVERY_TIME
  sptCols.aulPropTag[7] := PROP_TAG(PT_TSTRING, $0065);
    //PR_SENT_REPRESENTING_EMAIL_ADDRESS

  sptCols.aulPropTag[8] := PROP_TAG(PT_TSTRING, $0076);
    // PR_RECEIVED_BY_EMAIL_ADDRESS
  sptCols.aulPropTag[9] := PROP_TAG(PT_TSTRING, $0E04); // PR_DISPLAY_TO
  sptCols.aulPropTag[10] := PROP_TAG(PT_TSTRING, $0078);
    // PR_ORIGINAL_SENT_REPRESENTING_EMAIL_ADDRESS

  Try
    FIFolder.GetContentsTable(0, @pCTbl);

    HrQueryAllRows(pCTbl,
      LPSPropTagArray(@sptCols),
      Nil,
      Nil,
      0,
      @pRows);

    //_LogMSG('from inside vkmapi nro of rows: ' + inttostr(pRows.cRows));

    For i := 0 To pRows.cRows - 1 Do
    Begin
      qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) * 2);
      If (PROP_TAG(PT_BINARY, $0FFF) = qq.ulPropTag) Then //PR_ENTRYID
      Begin
        ////
        ////    Redo
        ////
        {//oMes := TMAPIMessage.Create(nil);}

        oMes := TMAPIMessage(FMessages.Add);

        ////
        ////

        oMes.FMAPISession := self.MAPISession;

        hRes := -1;
        Try
          hRes := CopySBinary(oMes.MessageID,
            @qq.Value.bin,
            oMes.MessageID);
        Except
        End;

        // added by vini
        If hRes = 0 Then
        Begin
          hRes := -1;
          Try
            hRes := MAPISession.MAPISession.OpenEntry(oMes.MessageID.cb,
              LPENTRYID(oMes.MessageID.lpb),
              Nil,
              MAPI_MODIFY,
              @ulObjType,
              LPUNKNOWN(@oMes.FIMessage));
          Except
            On e: exception Do
            Begin
              hRes := -1;
              oMes.FIMessage := Nil;
            End;
          End;

          // added by vini
          If (hRes = 0) And (oMes.FIMessage <> Nil) Then
          Begin
            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps));
            //PR_SENT_REPRESENTING_NAME
            If (PROP_TAG(PT_TSTRING, $0042) = qq.ulPropTag) Then
              oMes.FREPRESENTING_NAME := String(qq.Value.lpszA)
            Else
              oMes.FREPRESENTING_NAME := '<no sender>';

            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) *
              1);
            If (PROP_TAG(PT_TSTRING, $0037) = qq.ulPropTag) Then //PR_SUBJECT
              oMes.FSUBJECT := String(qq.Value.lpszA)
            Else
              oMes.FSUBJECT := '<no subject>';

            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) *
              4);
            If (PROP_TAG(PT_TSTRING, $1000) = qq.ulPropTag) Then //PR_BODY;
              oMes.FBODY := String(qq.Value.lpszA)
            Else
              oMes.FBODY := '';

            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) *
              3);
            If (PROP_TAG(PT_LONG, $0E07) = qq.ulPropTag) Then //PR_MESSAGE_FLAGS
              oMes.MessageFlags.MessageFlag := qq.Value.l
            Else
              oMes.MessageFlags.MessageFlag := 0;

            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) *
              5);
            If (PROP_TAG(PT_LONG, $0E08) = qq.ulPropTag) Then //PR_MESSAGE_SIZE
              oMes.FSize := qq.Value.l
            Else
              oMes.FSize := 0;

            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) *
              6);

            //PR_MESSAGE_DELIVERY_TIME
            If (PROP_TAG(PT_SYSTIME, $0E06) = qq.ulPropTag) Then
              oMes.FMessageDeliveryTime := FileTimeToDateTime(qq.Value.ft)
            Else
              oMes.FMessageDeliveryTime := 0;

            // added by vini
            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) *
              7);

            //PR_SENT_REPRESENTING_EMAIL_ADDRESS
            If (PROP_TAG(PT_TSTRING, $0065) = qq.ulPropTag) Then
              oMes.FREPRESENTING_EMAIL_FROM := String(qq.Value.lpszA)
            Else
              oMes.FREPRESENTING_EMAIL_FROM := '';

            // original mail sent to //PR_RECEIVED_BY_EMAIL_ADDRESS
            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) *
              8);

            If (PROP_TAG(PT_TSTRING, $0076) = qq.ulPropTag) Then
              oMes.FREPRESENTING_MAPI_EMAIL_TO := String(qq.Value.lpszA)
            Else
              oMes.FREPRESENTING_MAPI_EMAIL_TO := '';

            //PR_DISPLAY_TO
            qq := LPSPropValue(pChar(pRows.aRow[i].lpProps) + SizeOf(SPropValue) *
              9);
            If (PROP_TAG(PT_TSTRING, $0E04) = qq.ulPropTag) Then
              oMes.REPRESENTING_NAME_EMAIL_TO := String(qq.Value.lpszA)
            Else
              oMes.REPRESENTING_NAME_EMAIL_TO := '';

            If oMes.MessageFlags.HASATTACH And fLoadAttach Then
            Begin
              //Add attachments to a message
              Try
                AttachTable := Nil;
                hRes := -1;
                Try
                  If oMes.FIMessage <> Nil Then
                    hRes := oMes.FIMessage.GetAttachmentTable(0, @AttachTable);
                Except
                  On e: exception Do
                  Begin
                    AttachTable := Nil;
                    hRes := -1;
                  End; {On e: exception Do}
                End; {try}

                If (hRes = 0) And (AttachTable <> Nil) Then
                Begin
                  sptColsAtt.cValues := 5;
                  //PR_ATTACH_NUM
                  sptColsAtt.aulPropTag[0] := PROP_TAG(PT_LONG, $0E21);

                  // PR_ATTACH_LONG_FILENAME
                  sptColsAtt.aulPropTag[1] := PROP_TAG(PT_TSTRING, $3707);
                    {PR_ATTACH_FILENAME}

                  //PR_ATTACH_EXTENSION
                  sptColsAtt.aulPropTag[2] := PROP_TAG(PT_TSTRING, $3703);

                    //PR_ATTACH_METHOD
                  sptColsAtt.aulPropTag[3] := PROP_TAG(PT_LONG, $3705);

                    //PR_ATTACH_PATHNAME
                  sptColsAtt.aulPropTag[4] := PROP_TAG(PT_TSTRING, $3708);

                  AttachTable.SetColumns(@sptColsAtt, 0);
                  //AttachTable.GetRowCount(0, @k);

                  oMes.FIMessage.SaveChanges(0);

                  pAttRows := Nil;
                  hRes := -1;
                  Try
                    //hRes := AttachTable.QueryRows(1, 0, @pAttRows);
                    //hRes := AttachTable.QueryRows($7FFFFFFF, 0, @pAttRows);

                    HrQueryAllRows(AttachTable,
                      LPSPropTagArray(@sptColsAtt),
                      Nil,
                      Nil,
                      0,
                      @pAttRows);
                  Except
                    On e: exception Do
                    Begin
                      hRes := -1;
                      pAttRows := Nil;
                      //_LogMSG('query rows');
                    End;
                  End;

                  k := pAttRows.cRows;

                  For j := 0 To k - 1 Do
                  Begin
(*                     pAttRows := nil;
                   hRes := -1;
                    Try
                      //hRes := AttachTable.QueryRows(1, 0, @pAttRows);
                      hRes := AttachTable.QueryRows($7FFFFFFF, 0, @pAttRows);
                    Except
                      On e: exception Do
                      Begin
                        hRes := -1;
                        pAttRows := Nil;
                        _LogMSG('query rows');
                      End;
                    End;*)

                    If {(hRes = 0) And}(pAttRows <> Nil) Then
                    Try

                      If pAttRows.aRow[j].lpProps.ulPropTag = PROP_TAG(PT_LONG,
                        $0E21) Then //PR_ATTACH_NUM
                      Begin
                        l := pAttRows.aRow[j].lpProps.Value.l;
                        IAtt := Nil;

                        Try
                          hRes := oMes.FIMessage.OpenAttach(l, Nil, MAPI_BEST_ACCESS
                            Or MAPI_DEFERRED_ERRORS, @IAtt);
                        Finally
                        End;

                        If {(hRes = 0) And}(IAtt <> Nil) Then
                        Begin
                          qq1 := LPSPropValue(pChar(pAttRows.aRow[j].lpProps) +
                            SizeOf(SPropValue) * 1); //PR_ATTACH_FILENAME

                          qq2 := LPSPropValue(pChar(pAttRows.aRow[j].lpProps) +
                            SizeOf(SPropValue) * 3); //PR_ATTACH_METHOD

                          If (Not FAILED(qq1.Value.err)) Then
                          Begin
                            Try
                              oMes.Attachments.CreateAttach(ExtractFileName(qq1.Value.lpszA),
                              qq1.Value.lpszA,
                              FMAPISession.AttachTempDirectory,
                              l,
                              IAtt,
                              qq2.Value.l);
                            Except
                            End;
                          End;
                              //    Fix this later ...
                              //else
                              //  oMes.Attachments.CreateAttach('Untitled', 'Untitled.tmp', l, IAtt);
                        End;
                      End; {If pAttRows.aRow[0].lpProps.ulPropTag = PROP_TAG(PT_LONG, $0E21)}
                    Finally
//                      If pAttRows <> Nil Then
//                        FreeProws(pAttRows);

                      IAtt := Nil;
                    End;
                  End;
                End;
              Finally
                If AttachTable <> Nil Then
                  AttachTable := Nil;
              End;
            End
          End
          Else {// added by vini} If Assigned(oMes) Then
            oMes.free;
        End
        Else {// added by vini} If assigned(oMes) Then
          oMes.Free;

      End;
    End;
  Finally
    If pRows <> Nil Then
      FreeProws(pRows);
    pCTbl := Nil;
  End;
End;

Procedure TMAPIFolder.AssignFolder(Fold: TMAPIFolder);
Begin
  //
End;

Procedure TMAPIFolder.Assign(Source: TPersistent);
Begin
  If Source Is TMAPIFolder Then
    AssignFolder(TMAPIFolder(Source))
//  else if Source is {} then
  Else
    Inherited Assign(Source);
End;

Function TMAPIFolder.IsEqual(Value: TMAPIFolder): Boolean;
Begin
  Result := false;
End;

Procedure TMAPIFolder.SetFolderEID(Const Value: LPSBinary);
Begin
  If Assigned(FFolderEID) Then
    MAPIFreeBuffer(FFolderEID);
  FFolderEID := Nil;
  MAPIAllocateBuffer(SizeOf(SBinary), @FFolderEID);
  CopySBinary(FFolderEID,
    Value,
    Pointer(FFolderEID));
End;

Function TMAPIFolder.GetDisplayName: String;
Begin
  Result := DisplayName;
End;

Function TMAPIFolder.DeleteMessage(Index: Integer): Boolean;
Var
  Mails: SBinaryArray;
  hr: HRESULT;
Begin
  Mails.cValues := 1;
  Mails.lpbin := TMAPIMessage(FMessages.Items[Index]).MessageID;
  hr := FIFolder.DeleteMessages(LPENTRYLIST(@Mails), 0, Nil, 0);
  Result := Not FAILED(hr);
End;

Function TMAPIFolder.DeleteToWaste(Index: Integer): Boolean;
Var
  Mails: SBinaryArray;
  hr: HRESULT;
Begin
  Mails.cValues := 1;
  Mails.lpbin := TMAPIMessage(FMessages.Items[Index]).MessageID;
  hr := FIFolder.CopyMessages(
    LPENTRYLIST(@Mails), @IID_IMAPIFolder,
    pPointer(FMAPISession.m_pFolders[ORD(FOLDERS_WASTE)]),
    0, Nil, MESSAGE_MOVE);

  //FIFolder.DeleteMessages(LPENTRYLIST(@Mails), 0,nil, 0);
  Result := Not FAILED(hr);
End;

{ TMAPIAttachments }

Procedure TMAPIAttachments.AssignValues(Value: TMAPIAttachments);
Var
  I: Integer;
  P: TMAPIAttachment;
Begin
  For I := 0 To Value.Count - 1 Do
  Begin
    P := FindAttach(Value[I].Name);
    If P <> Nil Then
      P.Assign(Value[I]);
  End;
End;

Function TMAPIAttachments.CreateAttach(Const AttName, AttFileName, directory:
  String; AttNum: Integer; AttInterface: IAttach; pMethod: Integer): TMAPIAttachment;
Var
  pStrmDest: IStream;
  hRes: HRESULT;
  prop: LPSPropValue;
  StatInfo: STATSTG;
  mem: pChar;
  dw: DWord;
  lFile: TMemoryStream;
  lDir,
    lAux: String;
Begin
  Result := Add As TMAPIAttachment;
  Result.FileName := AttFileName;
  Result.Name := AttName;
  Result.FNumber := AttNum;
//  Result.FAttach := AttInterface;
  pStrmDest := Nil;

(*  Try
    OleCheck(Result.FAttach.OpenProperty(PROP_TAG(PT_BINARY, $3701),
      //PR_ATTACH_DATA_BIN
      @IID_IStream,
      0,
      0,
      LPUNKNOWN(@pStrmDest)));
    Result.FStream := TIStream.Create(pStrmDest);
  Finally
    pStrmDest := Nil;
  End;*)

  AttInterface.SaveChanges(0);

(*    case pMethod of
      NO_ATTACHMENT : _LogMSG('res : ' + inttostr(hres) +' attach method no attachment');
      ATTACH_BY_VALUE : _LogMSG('res : ' + inttostr(hres) +' attach method by value');
      ATTACH_BY_REFERENCE : _LogMSG('res : ' + inttostr(hres) +' attach method by reference');
      ATTACH_BY_REF_RESOLVE : _LogMSG('res : ' + inttostr(hres) +' attach method by ref resolve');
      ATTACH_BY_REF_ONLY : _LogMSG('res : ' + inttostr(hres) +' attach method by ref only');
      ATTACH_EMBEDDED_MSG : _LogMSG('res : ' + inttostr(hres) +' attach method embedded_msg');
      ATTACH_OLE : _LogMSG('res : ' + inttostr(hres) +' attach method attache ole');
    else
      _LogMSG('res : ' + inttostr(hres) +' attach method: ' + inttostr( -99));
    end;*)

  hres := AttInterface.OpenProperty(PROP_TAG(PT_BINARY, $3701),
    @IID_IStream,
    0,
    0,
    @pStrmDest);

  If hRes = 0 Then
  Begin
    pStrmDest.Stat(@StatInfo, 1);
    dw := 0;
    GetMem(mem, StatInfo.cbSize);
    Try
      pStrmDest.Read(mem, StatInfo.cbSize, @dw);
      If dw > 0 Then
      Begin
        lAux := IncludeTrailingPathDelimiter(directory) + Result.FileName;
        If FileExists(lAux) Then
        begin
          lAux := fileTemp(ExtractFileExt(Result.FileName));
          if FileExists(lAux) then
          begin
            DeleteFile(lAux);
            Sleep(1);
            lAux :=  IncludeTrailingPathDelimiter(directory) + Inttostr(GetTickCount) +
              ExtractFileExt(Result.FileName);
          end; {if FileExists(lAux) then}
        end; {If FileExists(lAux) Then}

        lFile := TMemoryStream.Create;
        try
          lFile.Write(mem^, dw);
          lFile.SaveToFile(lAux);
//          _LogMSG('saving ' + lAux);
        finally
          lFile.Free;
        end;

        Result.FileName := lAux;

          //Result.MemoryStream.Write(mem^, dw);
      End;
    Finally
      freemem(mem);

//        _LogMSG('attach size ' + inttostr(StatInfo.cbSize) + ' file written ' + inttostr(dw));
    End;
  End;

(*  Try
    hRes := Result.FAttach.OpenProperty(PROP_TAG(PT_BINARY, $3701),
      //PR_ATTACH_DATA_BIN
      @IID_IStream,
      0,
      0,
      @pStrmDest);

    If hRes = 0 Then
    Begin
      Result.FStream := TIStream.Create(pStrmDest);
      Result.MemoryStream.CopyFrom(Result.FStream, 0);
    End
    Else If hRes = MAKE_MAPI_E($102) Then
    Begin
      Prop.ulPropTag := PROP_TAG(PT_LONG, $3705);
      Prop.dwAlignPad := 0;
      Prop.Value.l := 1;
      hRes := Result.FAttach.SetProps(1, @Prop, Nil);
      If hRes = 0 Then
      Begin
        pStrmDest := Nil;
        hres := Result.FAttach.OpenProperty(PROP_TAG(PT_BINARY, $3701),
          @IID_IStream, 0,
          MAPI_MODIFY Or MAPI_CREATE, @pStrmDest);
        If hRes = 0 Then
        Begin
          Result.FStream := TIStream.Create(pStrmDest);
          Result.MemoryStream.CopyFrom(Result.FStream, 0);
        End;
      End
    End
  Finally
    pStrmDest := Nil;
  End;*)
End;

Function TMAPIAttachments.Add: TMAPIAttachment;
Begin
  Result := TMAPIAttachment(Inherited Add);
End;

Function TMAPIAttachments.FindAttach(Const Value: String): TMAPIAttachment;
Var
  I: Integer;
Begin
  For I := 0 To Count - 1 Do
  Begin
    Result := TMAPIAttachment(Inherited Items[I]);
    If AnsiCompareText(Result.Name, Value) = 0 Then
      Exit;
  End;
  Result := Nil;
End;

{$IFDEF VER130}
Function TMAPIAttachments.GetCollectionOwner: TPersistent;
Begin
  Result := GetOwner;
End;
{$ENDIF}

Function TMAPIAttachments.GetItem(Index: Integer): TMAPIAttachment;
Begin
  Result := TMAPIAttachment(Inherited Items[Index]);
End;

Function TMAPIAttachments.IsEqual(Value: TMAPIAttachments): Boolean;
Var
  I: Integer;
Begin
  Result := Count = Value.Count;
  If Result Then
    For I := 0 To Count - 1 Do
    Begin
      Result := TMAPIAttachment(Items[I]).IsEqual(TMAPIAttachment(Value.Items[I]));
      If Not Result Then
        Break;
    End
End;

Procedure TMAPIAttachments.SetItem(Index: Integer;
  Const Value: TMAPIAttachment);
Begin
  Inherited SetItem(Index, TCollectionItem(Value));
End;

{ TMAPIAttachment }

Procedure TMAPIAttachment.Assign(Source: TPersistent);
Begin
  If Source Is TMAPIAttachment Then
    AssignAttach(TMAPIAttachment(Source))
//  else if Source is {} then
  Else
    Inherited Assign(Source);
End;

Procedure TMAPIAttachment.AssignAttach(Attach: TMAPIAttachment);
Begin
  If Attach <> Nil Then
  Begin
    Name := Attach.Name;
    FileName := Attach.FileName;
    FNumber := Attach.FNumber;
    FAttach := Attach.FAttach;
    FStream := TIStream.Create(Attach.FStream.IntStream);
  End;
End;

Constructor TMAPIAttachment.Create(Collection: TCollection);
Begin
  Inherited Create(Collection);
  FAttachments := TMAPIAttachments(Collection);
  FAttachName := '';
  FFileName := '';
  FStream := Nil;
  FNumber := 0;
  FAttach := Nil;
//  fMemoryStream := TMemoryStream.Create;
End;

Destructor TMAPIAttachment.Destroy;
Begin
  If Assigned(FStream) Then
    FStream.Destroy;
  FAttach := Nil;

//  If fMemoryStream <> Nil Then
//    FreeAndNil(fMemoryStream);
  If FileExists(FileName) Then
    DeleteFile(FileName);

  Inherited Destroy;
End;

Function TMAPIAttachment.GetDisplayName: String;
Begin
  If Name <> '' Then
    Result := Name
  Else
    Result := Inherited GetDisplayName;
End;

Function TMAPIAttachment.IsEqual(Value: TMAPIAttachment): Boolean;
Begin
  Result := (Name = Value.Name) And (FileName = Value.FileName);
End;

{ TMAPIFolders }

Procedure TMAPIFolders.AssignValues(Value: TMAPIFolders);
Var
  I: Integer;
  P: TMAPIFolder;
Begin
  For I := 0 To Value.Count - 1 Do
  Begin
    P := FindFolder(Value[I].DisplayName);
    If P <> Nil Then
      P.Assign(Value[I]);
  End;
End;

Function TMAPIFolders.CreateFolder: TMAPIFolder;
Begin
  Result := Add As TMAPIFolder;
End;

Function TMAPIFolders.FindFolder(Const Value: String): TMAPIFolder;
Var
  I: Integer;
Begin
  For I := 0 To Count - 1 Do
  Begin
    Result := TMAPIFolder(Inherited Items[I]);
    If AnsiCompareText(Result.DisplayName, Value) = 0 Then
      Exit;
  End;
  Result := Nil;
End;

{$IFDEF VER130}
Function TMAPIFolders.GetCollectionOwner: TPersistent;
Begin
  Result := GetOwner;
End;
{$ENDIF}

Function TMAPIFolders.GetItem(Index: Integer): TMAPIFolder;
Begin
  Result := TMAPIFolder(Inherited Items[Index]);
End;

Function TMAPIFolders.IsEqual(Value: TMAPIFolders): Boolean;
Var
  I: Integer;
Begin
  Result := Count = Value.Count;
  If Result Then
    For I := 0 To Count - 1 Do
    Begin
      Result := TMAPIFolder(Items[I]).IsEqual(TMAPIFolder(Value.Items[I]));
      If Not Result Then
        Break;
    End
End;

Procedure TMAPIFolders.SetItem(Index: Integer; Const Value: TMAPIFolder);
Begin
  Inherited SetItem(Index, TCollectionItem(Value));
End;

{ TMAPIMessages }

Procedure TMAPIMessages.AssignValues(Value: TMAPIMessages);
Var
  I: Integer;
  P: TMAPIMessage;
Begin
  For I := 0 To Value.Count - 1 Do
  Begin
    P := FindMessage(Value[I].REPRESENTING_NAME);
    If P <> Nil Then
      P.Assign(Value[I]);
  End;
End;

Function TMAPIMessages.CreateMessage: TMAPIMessage;
Begin
  Result := Add As TMAPIMessage;
  //if TMAPIFolder(Owner).Active then
  //begin
  //  TMAPIFolder(Owner).IFolder.CreateMessage(nil, Result.MessageFlags.MessageFlag, @Result.IMessage);
  //  Result.FMessageID := nil;
  //  HrGetOneProp(Result.IMessage, PROP_TAG(PT_BINARY, $0FFF), @Result.FMessageID);
  //end;
End;

Function TMAPIMessages.FindMessage(Const Value: String): TMAPIMessage;
Var
  I: Integer;
Begin
  For I := 0 To Count - 1 Do
  Begin
    Result := TMAPIMessage(Inherited Items[I]);
    If AnsiCompareText(Result.REPRESENTING_NAME, Value) = 0 Then
      Exit;
  End;
  Result := Nil;
End;

{$IFDEF VER130}
Function TMAPIMessages.GetCollectionOwner: TPersistent;
Begin
  Result := GetOwner;
End;
{$ENDIF}

Function TMAPIMessages.GetItem(Index: Integer): TMAPIMessage;
Begin
  Result := TMAPIMessage(Inherited Items[Index]);
End;

Function TMAPIMessages.IsEqual(Value: TMAPIMessages): Boolean;
Var
  I: Integer;
Begin
  Result := Count = Value.Count;
  If Result Then
    For I := 0 To Count - 1 Do
    Begin
      Result := TMAPIMessage(Items[I]).IsEqual(TMAPIMessage(Value.Items[I]));
      If Not Result Then
        Break;
    End
End;

Procedure TMAPIMessages.SetItem(Index: Integer; Const Value: TMAPIMessage);
Begin
  Inherited SetItem(Index, TCollectionItem(Value));
End;

Procedure TMAPIMessages.SetMessagesSubmited(Const Value: Boolean);
Begin
  If Value Then
  Begin
    If Not FAILED(SubmitMessages) Then
      FMessagesSubmited := Value;
  End
  Else
    FMessagesSubmited := Value;
End;

Function TMAPIMessages.SubmitMessages: HRESULT;
Var
  oMess: TMAPIMessage;
  oFolder: TMAPIFolder;
  //iMes: IMAPIMessage;
  pspvSaved: Array[0..1] Of SPropValue;
  pAdrList: LPADRLIST;
  //eidMsg: ENTRYLIST;
  //pspvEID: LPSPropValue;
  qq: LPSPropValue;
  i: Integer;
  j: Integer;
  k: Integer;
  pStrmDest, pStrmSrc: IStream;
  //ulAttNum: ULONG;
  //pAtt: IAttach;
  StatInfo: STATSTG;
  spvAttach: Array[0..2] Of SPropValue;
  hr: HRESULT;
Begin

  Result := S_OK;

  oFolder := TMAPIFolder(Owner);
  If oFolder.Active Then
  Begin

    For j := 0 To Count - 1 Do
    Begin

      oMess := Items[j];

      If oMess.IMessage = Nil Then
      Begin

        Result := oFolder.IFolder.CreateMessage(Nil, oMess.MessageFlags.MessageFlag,
          @oMess.IMessage);
        If Not FAILED(Result) Then
        Begin

          pspvSaved[0].ulPropTag := PROP_TAG(PT_TSTRING, $0037); //PR_SUBJECT;
          pspvSaved[0].Value.lpszA := pChar(oMess.SUBJECT);

          pspvSaved[1].ulPropTag := PROP_TAG(PT_TSTRING, $1000); //PR_BODY;
          pspvSaved[1].Value.lpszA := pChar(oMess.BODY);

          //pspvSaved[2].ulPropTag := PROP_TAG(PT_LONG,      $0E07);    //PR_MESSAGE_FLAGS;
          //pspvSaved[2].Value.l := oMess.MessageFlags.MessageFlag;     //MSGFLAG_UNSENT or MSGFLAG_READ;     //MSGFLAG_SUBMIT | MSGFLAG_READ;

          Result := oMess.IMessage.SetProps(2, @pspvSaved, Nil);

          If Not FAILED(Result) Then
          Begin

            pAdrList := Nil;
            MAPIAllocateBuffer(SizeOf(ADRLIST) + SizeOf(ADRENTRY) *
              (oMess.Recipients.Count - 1), @pAdrList);
            pAdrList.cEntries := oMess.Recipients.Count;
            For k := 0 To oMess.Recipients.Count - 1 Do
            Begin
              MAPIAllocateBuffer(SizeOf(SPropValue) * 2,
                @pAdrList.aEntries[k].rgPropVals);
              pAdrList.aEntries[k].cValues := 2;

              If oMess.Recipients.Items[k].Name <> '' Then
              Begin
                pAdrList.aEntries[k].rgPropVals.ulPropTag := PROP_TAG(PT_TSTRING,
                  $3001); //PR_DISPLAY_NAME
                pAdrList.aEntries[k].rgPropVals.Value.lpszA :=
                  pChar(oMess.Recipients.Items[k].Name);
              End
              Else If oMess.Recipients.Items[k].EMail <> '' Then
              Begin
                //pAdrList.aEntries[k].rgPropVals.ulPropTag := PROP_TAG(PT_TSTRING,   $3003); //PR_EMAIL_ADDRESS
                pAdrList.aEntries[k].rgPropVals.ulPropTag := PROP_TAG(PT_TSTRING,
                  $3001); //PR_DISPLAY_NAME
                pAdrList.aEntries[k].rgPropVals.Value.lpszA :=
                  pChar(oMess.Recipients.Items[k].EMail);
              End
              Else
              Begin
              End;
              qq := LPSPropValue(pChar(pAdrList.aEntries[k].rgPropVals) +
                SizeOf(SPropValue));
              qq.ulPropTag := PROP_TAG(PT_LONG, $0C15); //PR_RECIPIENT_TYPE
              qq.Value.l := MAPI_TO;
            End;

            MAPISession.m_pAddrBook.ResolveName(0, 0, Nil, pAdrList);

            //Result := m_pAddrBook.ResolveName(FWindow, MAPI_DIALOG, nil, pAdrList);
            //if Result = MAKE_MAPI_E( $700 ) then
            //  beep;
            //if Result = MAKE_MAPI_E( $10F ) then
            //  beep;
            //if not FAILED(Result) then
            //begin
            oMess.IMessage.ModifyRecipients(0, pAdrList);
              //if not FAILED(Result) then
              //begin
            Result := oMess.IMessage.SaveChanges(KEEP_OPEN_READWRITE);
            If Not FAILED(Result) Then
            Begin
                  //if Assigned(Attachments) and Attachments.InheritsFrom(TStrings) then
              If oMess.Attachments.Count > 0 Then
              Begin
                For i := 0 To oMess.Attachments.Count - 1 Do
                Begin
                      //Routine attachment
                  pStrmSrc := Nil;
                  hr := OpenStreamOnFile(@MAPIAllocateBuffer,
                    @MAPIFreeBuffer,
                    0,
                    pChar(oMess.Attachments.Items[i].FileName),
                    Nil,
                    @pStrmSrc);
                  If Not FAILED(hr) Then
                  Begin
                    oMess.Attachments.Items[i].FAttach := Nil;
                    hr := oMess.IMessage.CreateAttach(Nil, 0,
                      @oMess.Attachments.Items[i].FNumber,
                      @oMess.Attachments.Items[i].FAttach);
                    If Not FAILED(hr) Then
                    Begin
                      pStrmDest := Nil;
                      hr :=
                        oMess.Attachments.Items[i].FAttach.OpenProperty(PROP_TAG(PT_BINARY, $3701), //PR_ATTACH_DATA_BIN
                        @IID_IStream,
                        0,
                        MAPI_MODIFY Or MAPI_CREATE,
                        LPUNKNOWN(@pStrmDest));
                      If Not FAILED(hr) Then
                      Begin
                        pStrmSrc.Stat(@StatInfo, 1); //STATFLAG_NONAME
                        hr := pStrmSrc.CopyTo(pStrmDest,
                          StatInfo.cbSize,
                          Nil,
                          Nil);
                        If Not FAILED(hr) Then
                        Begin
                          spvAttach[0].ulPropTag := PROP_TAG(PT_TSTRING, $3704);
                            //PR_ATTACH_FILENAME;
                          spvAttach[0].Value.lpszA :=
                            pChar(oMess.Attachments.Items[i].FileName);

                          spvAttach[1].ulPropTag := PROP_TAG(PT_LONG, $3705);
                            //PR_ATTACH_METHOD;
                          spvAttach[1].Value.l := ATTACH_BY_VALUE;

                          spvAttach[2].ulPropTag := PROP_TAG(PT_LONG, $370B);
                            //PR_RENDERING_POSITION;
                          spvAttach[2].Value.l := -1;

                          hr := oMess.Attachments.Items[i].FAttach.SetProps(3,
                            @spvAttach, Nil);
                          If Not FAILED(hr) Then
                            oMess.Attachments.Items[i].FAttach.SaveChanges(0);
                        End;
                      End;
                      pStrmDest := Nil;
                    End;
                        //pAtt := nil;
                  End;
                  pStrmSrc := Nil;
                      //
                End;
              End;
              Result := oMess.IMessage.SubmitMessage(0);
                  //if not FAILED(Result) then
                  //  Result := m_pSpoolerStat.FlushQueues(FWindow, 0, nil, FLUSH_FLAGS);
            End;
              //end;
            //end;
            FreePadrlist(pAdrList);

          End;
        End;

        //Delete Submited message
        //pspvEID := nil;

        oMess.MessageID := Nil;
        HrGetOneProp(oMess.IMessage, PROP_TAG(PT_BINARY, $0FFF), @oMess.MessageID);

        //eidMsg.cValues := 1;
        //eidMsg.lpbin   := @pspvEID.Value.bin;
        //iMes := nil;
        //m_pFolders[ORD(FOLDERS_OUTBOX)].DeleteMessages( @eidMsg,
        //                                                FWindow,
        //                                                nil,
        //                                                MESSAGE_DIALOG);
        //
        //if FAILED(Result) then OleCheck(Result);

      End;

    End;

  End;

End;

{ TMAPIRecipient }

Procedure TMAPIRecipient.Assign(Source: TPersistent);
Begin
  If Source Is TMAPIRecipient Then
    AssignRecipient(TMAPIRecipient(Source))
//  else if Source is {} then
  Else
    Inherited Assign(Source);
End;

Procedure TMAPIRecipient.AssignRecipient(Recipient: TMAPIRecipient);
Begin
  If Recipient <> Nil Then
  Begin
    Name := Recipient.Name;
    EMail := Recipient.EMail;
  End;
End;

Constructor TMAPIRecipient.Create(Collection: TCollection);
Begin
  Inherited Create(Collection);
  FName := '';
  FEMail := '';
End;

Destructor TMAPIRecipient.Destroy;
Begin
  Inherited Destroy;
End;

Function TMAPIRecipient.GetDisplayName: String;
Begin
  Result := Name;
  If EMail <> '' Then
    Result := Result + ' (' + EMail + ')';
End;

Function TMAPIRecipient.IsEqual(Value: TMAPIRecipient): Boolean;
Begin
  Result := (Name = Value.Name) And (EMail = Value.EMail);
End;

{ TMAPIRecipients }

Procedure TMAPIRecipients.AssignValues(Value: TMAPIRecipients);
Var
  I: Integer;
  P: TMAPIRecipient;
Begin
  For I := 0 To Value.Count - 1 Do
  Begin
    P := FindRecipient(Value[I].Name);
    If P <> Nil Then
      P.Assign(Value[I]);
  End;
End;

Function TMAPIRecipients.CreateRecipient: TMAPIRecipient;
Begin
  Result := Add As TMAPIRecipient;
End;

Function TMAPIRecipients.FindRecipient(Const Value: String): TMAPIRecipient;
Var
  I: Integer;
Begin
  For I := 0 To Count - 1 Do
  Begin
    Result := TMAPIRecipient(Inherited Items[I]);
    If AnsiCompareText(Result.Name, Value) = 0 Then
      Exit;
  End;
  Result := Nil;
End;

{$IFDEF VER130}
Function TMAPIRecipients.GetCollectionOwner: TPersistent;
Begin
  Result := GetOwner;
End;
{$ENDIF}

Function TMAPIRecipients.GetItem(Index: Integer): TMAPIRecipient;
Begin
  Result := TMAPIRecipient(Inherited Items[Index]);
End;

Function TMAPIRecipients.IsEqual(Value: TMAPIRecipients): Boolean;
Var
  I: Integer;
Begin
  Result := Count = Value.Count;
  If Result Then
    For I := 0 To Count - 1 Do
    Begin
      Result := TMAPIRecipient(Items[I]).IsEqual(TMAPIRecipient(Value.Items[I]));
      If Not Result Then
        Break;
    End
End;

Procedure TMAPIRecipients.SetItem(Index: Integer;
  Const Value: TMAPIRecipient);
Begin
  Inherited SetItem(Index, TCollectionItem(Value));
End;

End.

