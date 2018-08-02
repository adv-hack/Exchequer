{-----------------------------------------------------------------------------
 Unit Name: uCommon
 Author:    vmoura

CLSID_DOMDocument40
 

Msxml2.DOMDocument.4.0

CLSID_DSOControl40
 

Msxml2.DSOControl.4.0

CLSID_FreeThreadedDOMDocument40
 

Msxml2.FreeThreadedDOMDocument.4.0

CLSID_MXHTMLWriter40
 

Msxml2.MXHTMLWriter.4.0

CLSID_MXNamespaceManager40

Msxml2. MXNamespaceManager.4.0

CLSID_MXXMLWriter40

Msxml2.MXXMLWriter.4.0

CLSID_SAXAttributes40

Msxml2.SAXAttributes.4.0

CLSID_SAXXMLReader40

Msxml2.SAXXMLReader.4.0

CLSID_ServerXMLHTTP40

Msxml2.ServerXMLHTTP.4.0

CLSID_XMLHTTP40

Msxml2.XMLHTTP.4.0

CLSID_XMLSchemaCache40

Msxml2.XMLSchemaCache.4.0

CLSID_XSLTemplate40

Msxml2.XSLTemplate.4.0

-----------------------------------------------------------------------------}

Unit uCommon;

Interface

Uses
  Windows, Classes, Controls,
  MSXML2_TLB,
  uConsts, uXmlBaseClass, uInterfaces

  {DCPsha1, DCPbase64}
  ;

Const
  PROCESS_TERMINATE = $0001;

Function _GetPeriod(Const pValue: String): String;
Function _GetYear(Const pValue: String): String;
Function _FormatPeriod(pPeriod: integer; pYear: TDateTime): String; overload;
Function _FormatPeriod(pPeriod: integer; pYear: Integer): String; overload;

Function _FileSize(Const FileName: String): LongInt;
function _GetCISFile(const pDir: String): String;
Function _DirExists(Const pDir: String): Boolean;
Function _DelDir(Const dir: String): Boolean;
Procedure _DelDirFiles(Const dir: String);
Function _DelFile(Const pFile: String): Boolean;
Function _MoveDir(Const pFromDir, pToDir: String): Boolean;
Function _CopyDir(Const pFromDir, pToDir: String): Boolean;
Function _fileCopy(Const SourceFile, TargetFile: String): Boolean;
Function _RenameDir(Const pOldDir, pNewDir: String): Boolean;
Procedure _CreateDSRLockFile(Const pDir: String);
Procedure _DeleteDSRLockFile(Const pDir: String);
function _CheckDSRLockFileExists(Const pDir: String): Boolean;
function _CountFiles(const pDir: String): Integer;

Procedure _DeleteFilesByDate(Const pPath, pMask: String; pToDate: TDateTime);
Function _CompareDate(pFrom, pTo, pDate: TDatetime): Boolean;
Function _SelectDirectory: String;
Function _CreateNewFileString(Const pFileName, pExt: String): String;
Function _CreateGuid: TGuid;
Function _CreateGuidStr: String;
Function _ChangeXmlEncodeValue(Const pText: String): String;
Function _GetXmlParseError(pParse: IXMLDOMParseError): String;
Function _RemoveXmlCharacters(Const pText: WideString): String;
Function _ApplyXmlCharacters(Const pText: WideString): String;
Procedure _LogMSG(Const pMessage: String);
Procedure _Delay(msecs: Longint);
Function _ValidExtension(Const pFileName: String): Boolean;
Function _IsMSXMLAvaiable: String;

Procedure _CallDebugLog(Const pMessage: String);
Function _AddSeparatorToStrings(Seperator: Char; List: TStringList): String;
Function _CheckParams(pParams: Array Of Variant): Boolean;
Function _SafeGuidtoString(pGuid: TGuid): String;
Function _SafeStringToGuid(Const pString: String): TGuid;
Function _IsValidGuid(Const pGuid: TGuid): Boolean; overload;
Function _IsValidGuid(Const pGuid: String): Boolean; overload;
Function _GetMailInfoFromStrings(pMsg: TStrings): TMessageInfo;
Function _ChangeChar(Const pText, pOldChar, pNewChar: String): String;
Function _ChangeAmpersand(Const pText: String): String;

Procedure _LockControl(pControl: TWinControl; pLock: Boolean);

Function _IsValidOleVariant(pVar: Olevariant): Boolean;
Function _GetOlevariantArraySize(pVar: Olevariant): Integer;
Function _CreateOutboxMsgInfo(pMsg: Olevariant): TMessageInfo;
Function _CreateInboxMsgInfo(pMsg: Olevariant): TMessageInfo;
function _CreateEmailAccount(pEmail: OleVariant): TEmailAccount;
function _CreateEmailSystem(pSystem: Olevariant): TEmailSystem;
Function _CreateCISMsgInfo(pMsg: Olevariant): TCISMessage;
Function _VerifyDailySchedule(pDay: TDailySchedule): Boolean;
Function _CreateDailySchedule(pSchedule: Olevariant): TDailySchedule;
Function _CreateExportPackage(pVar: Olevariant): TPackageInfo;
Function _CreateCompanyObj(pComp: OleVariant): TCompany;
Function _CompanyHasReqBulk(Const pGuid: String): Boolean;
Procedure _CompanyCreateBulk(Const pGuid: String);
Procedure _CompanyDeleteBulk(Const pGuid: String);

function _IsMAPI(pDesc: String): Boolean;
function _IsPOP3(pDesc: String): Boolean;
function _IsIMAP(pDesc: String): Boolean;
function _Is3rdPRT(pDesc: String): Boolean;


Function _IsValidXml(Const pXml: WideString): Boolean;
Function _AddLeafNode(ToNode: IXMLDomNode; Const AsName: String;
  Const AsValue: OLEVariant; AsCData: Boolean = False): IXmlDomNode;
Function _GetNodeByName(pNode: IXMLDomNode; Const pName: String): IXmlDomNode;
Function _GetChildNodeByName(pNode: IXMLDomNode; Const pName: String): IXMLDOMNode;
Function _SetNodeValueByName(Var pNode: IXMLDomNode; Const pName: String;
  pValue: OleVariant): IXmlDomNode;
Function _GetNodeValueByName(pNode: IXMLDomNode; Const pName: String; Var
  pValue: Variant): IXmlDomNode;
Function _GetNodeValue(pNode: IXMLDOMNode; Const pName: String): Variant;
Function _GetXmlRecordCount(pNode: IXMLDomNode; Const pName: String = 'message'): Integer;
Function _CreateXmlFile(Const pFileName: String; Const pXml: WideString): Boolean;
Function _CreateXmlsPackagesPaths(Var pXml, pXsl, pXSD: String): Boolean;

Procedure _FillXMLHeader(Var pHeader: TXMLHeader; pGuid: TGuid; pNumber, pCount:
  Smallint; Const pSource, pDestination, pPlugin: ShortString; pFlag: Byte);

Function _DSRFormatConnectionString(Const pServer: String): String;

Function _SetXmlHeader(Var pDoc: TXMLDoc; pHeader: TXMLHeader): Boolean;
Function _GetXMLHeader(pDoc: TXMLDoc; Var pHeader: TXMLHeader): Boolean; overload;
Function _GetXMLHeader(pXml: WideString; Var pHeader: TXMLHeader): Boolean; overload;

Function _CompressAndEncrypt(Const pFileIn: String): Boolean;
Function _DecryptAndDecompress(Const pFileIn: String): Boolean;
Function _EncryptFile(Const pFileIn: String; Const pFileout: String = ''): Boolean;
Function _DecryptFile(Const pFileIn: String; Const pFileout: String = ''): Boolean;
Function _CompressFile(Const pFileIn: String; Const pFileout: String = ''): Boolean;
Function _DeCompressFile(Const pFileIn: String; Const pFileout: String = ''): Boolean;
function _EncryptString(Const pStr: String): String;
function  _DecryptString(Const pStr: String): String;

Procedure _CalcFileCRC32(Const FromName: String; Var CRCvalue: DWORD;
  Var TotalBytes: Int64; Var error: Word);
Function _CalcStringCRC32(Const s: String; Out CRC32: DWORD): Boolean;
Procedure _CalcCRC32(p: Pointer; ByteCount: DWORD; Var CRCValue: DWORD);

Function _TranslateErrorCode(pError: CArdinal): String;

Procedure _strTokenToStrings(S: String; Seperator: Char; Var List: TStringList);
Function _strTokenCount(S: String; Seperator: Char): Integer;
Function _strToken(Var S: String; Seperator: Char): String;
Function _CreateFakedString(pSize: integer): String;
Function _GetFileFromNameSpace(pDoc: TXMLDoc): String;
procedure _DeleteTempFiles;

//Function _GGWGenerateIrMark(pXml: WideString): String;

Function _RegisterServer(Const aDllFileName: String; aRegister: Boolean): Boolean;
Procedure _GetGuidsFromDll(Const pDll: String; Var pList: TStringList);
Function _KillTask(Const pExeName: String): Integer;
Function _FindTask(Const pExeName: String): Boolean;
Function _fileExec(Const aCmdLine: String; aHide, aWait: Boolean): Boolean;
Function _LocalServiceRunning(Const sService: String): Boolean;
Function _ServiceStatus(Const sService: String; Const sMachine: String = '';
  Const pStart: Boolean = False; Const pStop: Boolean = False): DWORD;
Function _ServiceExists(Const sService: String; Const sMachine: String = ''): Boolean;
Function _GetComputerName: String;
Function _GetUSerName: String;
Function _GetAllEnvVars(Const Vars: TStrings): Integer;
Function _GetApplicationPath: String;
Function _GetApplicationName: String;
Function _BrowseComputer(DialogTitle: String; Var CompName: String; bNewStyle: Boolean): Boolean;

Function _GetDataTransportDetails(TableID: Integer): TDataTransportDetails;
Function _GetErrorMessage(ErrorNumber: Integer): String;
Function _GetStatusMessage(StatusNumber: Integer): String;
Function _GetProductName(ProductNro: Integer): String;

Function _InvalidCompCode(Const pCode: String): Boolean;
Function _SystrayRunning: Boolean;
Function _GetExplorerUser: String;
Function _IsLogged: Boolean;
Function _IsValidDSRVersion(Const pV1, pV2: String): Boolean;
Function _GetEnterpriseSystemDir: String;
Procedure _SetEnterpriseDir(Const ADir: AnsiString);

Procedure EncodeOpCode(Const OpCode: Byte; Var Long1, Long2, Long3: LongInt);

Function SetDecimalSeparator(NewSeparator: Char): Char;

Function RightJustify(Text: String; WithChar: Char; ToLength: Byte): String;
Function LeftJustify(Text: String; WithChar: Char; ToLength: Byte): String;

Implementation

Uses ComObj, Forms, Variants, Tlhelp32, WinSvc, ShellApi, ShlObj, Activex,
  Dateutils, Registry, 
  strutils, Messages, psapi, SysUtils,
  uCompression, uCrypto, math, uSystemConfig;

{-----------------------------------------------------------------------------
  Procedure: _GetPeriod
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetPeriod(Const pValue: String): String;
//var
//  lAux: String;
Begin
//  lAux:= pValue;
  //Result := _strToken(lAux, '/');
  Result := Copy(pValue, 1, 2);
End;

{-----------------------------------------------------------------------------
  Procedure: _GetYear
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetYear(Const pValue: String): String;
//var
//  lAux: String;
Begin
//  lAux:= pValue;
//  _strToken(lAux, '/');
  If Pos(DateSeparator, pValue) > 0 Then
    Result := Copy(pValue, 4, 4)
  Else
    Result := Copy(pValue, 3, 4);
End;

{-----------------------------------------------------------------------------
  Procedure: _FormatPeriod
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _FormatPeriod(pPeriod: integer; pYear: TDateTime): String;
Begin
  Result := FormatFloat('00', ifthen(pPeriod = 0, 1, pPeriod)) +
    inttostr(YearOf(pYear));
End;

{-----------------------------------------------------------------------------
  Procedure: _FormatPeriod
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _FormatPeriod(pPeriod: integer; pYear: Integer): String;
Begin
  Result := FormatFloat('00', ifthen(pPeriod = 0, 1, pPeriod)) +
    inttostr(pYear);
End;

{-----------------------------------------------------------------------------
  Procedure: _fileSize
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _FileSize(Const FileName: String): LongInt;
Var
  SearchRec: TSearchRec;
Begin { !Win32! -> GetFileSize }
  Result := 0;
  If FindFirst(ExpandUNCFileName(FileName), faAnyFile, SearchRec) = 0 Then
    Result := SearchRec.Size;
  FindClose(SearchRec);
End;

{-----------------------------------------------------------------------------
  Procedure: _GetCISFile
  Author:    vmoura
-----------------------------------------------------------------------------}
function _GetCISFile(const pDir: String): String;
Var
  lSearch: TSearchRec;
  lFile: String;
begin
  // CISMMYY.XML       cis format file
  Result := '';
  lFile := IncludeTrailingPathDelimiter(pDir) + 'cis*.xml';

  if FindFirst(lFile, faAnyFile, lSearch) = 0 then
    Result := IncludeTrailingPathDelimiter(pDir) + ExtractFileName(lSearch.Name);

  Sysutils.FindClose(lSearch);
end; {function _GetCISFile(const pDir: String): String;}


{-----------------------------------------------------------------------------
  Procedure: _DirExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _DirExists(Const pDir: String): Boolean;
Var
  SearchRec: TSearchRec;
Begin
  Result := False;
  If pDir <> '' Then
  Begin
    Result := FindFirst(ExpandUNCFileName(pDir) + '*', faDirectory, SearchRec) = 0;
    FindClose(SearchRec);
    If Not Result Then
      Result := DirectoryExists(ExpandUNCFileName(pDir));

    If Not Result Then
      Result := DirectoryExists(pDir);
  End; {If pDir <> '' Then}
End;

{-----------------------------------------------------------------------------
  Procedure: _DeleteFilesByDate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _DeleteFilesByDate(Const pPath, pMask: String; pToDate: TDateTime);
Var
  SearchRec: TSearchRec;
  lRes: Integer;
  lFile: String;
Begin
  lRes := FindFirst(IncludeTrailingPathDelimiter(pPath) + pMask, faAnyFile,
    SearchRec);

  While lRes = 0 Do
  Begin
    // get the rigth file attribute
    If SearchRec.Attr = (FILE_ATTRIBUTE_ARCHIVE Or FILE_ATTRIBUTE_TEMPORARY)
      Then
    Begin
      lFile := IncludeTrailingPathDelimiter(pPath) + SearchRec.Name;
      Try
        // validate the date of the file
        If FileDateToDateTime(SearchRec.Time) <= pTodate Then
          _DelFile(lFile);
      Except
      End;
    End;

    lRes := FindNext(SearchRec);
  End;

  FindClose(SearchRec);
End;

{-----------------------------------------------------------------------------
  Procedure: _SelectDirectory
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _SelectDirectory: String;
Var
  TitleName: String;
  lpItemID: PItemIDList;
  BrowseInfo: TBrowseInfo;
  DisplayName: Array[0..MAX_PATH] Of char;
  TempPath: Array[0..MAX_PATH] Of char;
Begin
  FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
  BrowseInfo.hwndOwner := forms.Application.Handle;
  BrowseInfo.pszDisplayName := @DisplayName;
  TitleName := 'Please specify a directory';
  BrowseInfo.lpszTitle := PChar(TitleName);
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
  lpItemID := SHBrowseForFolder(BrowseInfo);
  If lpItemId <> Nil Then
  Begin
    SHGetPathFromIDList(lpItemID, TempPath);
    Result := TempPath;
    Try
      GlobalFreePtr(lpItemID);
    Except
    End;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _CompareDate
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CompareDate(pFrom, pTo, pDate: TDatetime): Boolean;
Begin
  Result := (pDate >= pFrom) And (pDate <= pTo);
End;

{-----------------------------------------------------------------------------
  Procedure: _CreateNewFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CreateNewFileString(Const pFileName, pExt: String): String;
Begin
  Result := ChangeFileExt(pFileName, pExt);
End;

{-----------------------------------------------------------------------------
  Procedure: _CreateGuid
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CreateGuid: TGuid;
Begin
  //Result := StringToGUID(CreateClassID);
  CoCreateGuid(Result);
End;

{-----------------------------------------------------------------------------
  Procedure: _CreateGuidStr
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CreateGuidStr: String;
Begin
  Result := GUIDToString(_CreateGuid);
End;

{-----------------------------------------------------------------------------
  Procedure: _ChangeXmlEncodeValue
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _ChangeXmlEncodeValue(Const pText: String): String;
Var
  lPos: integer;
  ltext: String;
Begin
  lText := pText;
  lPos := Pos('"UTF-16"', pText);
  If lPos = 0 Then
    lPos := Pos('"utf-16"', lowercase(pText));

  If lPos > 0 Then
  Begin
    Delete(lText, lPos, 8);
    Insert('"utf-8"', ltext, lPos);
    Result := lText;
  End
  Else
    Result := pText;
End;

{-----------------------------------------------------------------------------
  Procedure: _GetXmlParseError
  Author:    vmoura

  get the parsed error if something happens
-----------------------------------------------------------------------------}
Function _GetXmlParseError(pParse: IXMLDOMParseError): String;
Begin
  If pParse <> Nil Then
    If pParse.reason <> '' Then
      Result := 'Line: ' + inttostr(pParse.Line) + '. Pos: ' +
        inttostr(pParse.linepos) + '.' + 'Reason: ' + Trim(pParse.reason) +
        'Source: ' + Trim(pParse.srcText);
End;

{-----------------------------------------------------------------------------
  Procedure: _RemoveXmlCharacters
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _RemoveXmlCharacters(Const pText: WideString): String;
Begin
  Result := StringReplace(pText, cXMLLessThan, cTextLessThan, [rfReplaceAll]);
  Result := StringReplace(Result, cXMLAmpersand, cTextAmpersand,
    [rfReplaceAll]);
  Result := StringReplace(Result, cXMLGreaterThan, cTextGreaterThan,
    [rfReplaceAll]);
  Result := StringReplace(Result, cXMLQuot, cTextQuot, [rfReplaceAll]);
  Result := StringReplace(Result, cXMLApostrophe, cTextApostrophe,
    [rfReplaceAll]);
End;

{-----------------------------------------------------------------------------
  Procedure: _ApplyXmlCharacters
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _ApplyXmlCharacters(Const pText: WideString): String;
Begin
  Result := StringReplace(pText, cTextLessThan, cXMLLessThan,  [rfReplaceAll]);
  Result := StringReplace(Result, cTextAmpersand, cXMLAmpersand, [rfReplaceAll]);
  Result := StringReplace(Result, cTextGreaterThan, cXMLGreaterThan, [rfReplaceAll]);
  Result := StringReplace(Result, cTextQuot, cXMLQuot, [rfReplaceAll]);
  Result := StringReplace(Result, cTextApostrophe, cXMLApostrophe, [rfReplaceAll]);
End;


{-----------------------------------------------------------------------------
  Procedure: _IsMSXMLAvaiable
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _IsMSXMLAvaiable: String;
Var
  lDoc: DOMDocument40;
Begin
  Result := '';
  Try
    lDoc := CreateOleObject(cMSXML40) As DOMDocument40;
  Except
    On e: exception Do
      Result := e.Message;
  End;
  lDoc := Nil;
End;

{-----------------------------------------------------------------------------
  Procedure: _LogMsg
  Author:    vmoura

  this is a option to log message. Works very well
-----------------------------------------------------------------------------}
Procedure _LogMsg(Const pMessage: String);
Var
  lFile, lDir, lMessage: String;
  lHandle: Thandle;
  lResult: Cardinal;
//  lFlag: Boolean;
//  lStr: TStringList;
//  lCont: Integer;
Begin
  If pMessage <> '' Then
  Begin
    lHandle := 0;
    Try

      Try
        lDir := _GetApplicationPath;
      Except
        lDir := Extractfilepath(Forms.Application.ExeName);
      End;

      lFile := lDir + cLogDir + '\' + _GetApplicationName + '_' +
        FormatDateTime('yyyymmdd', date) + cLogFileExt;

      ForceDirectories(lDir + cLogDir);

//      lFlag := _FileSize(lFile) > 0;

    // dir + filename + extension
      lHandle := windows.CreateFile(pChar(lFile), GENERIC_READ Or GENERIC_WRITE,
        FILE_SHARE_READ Or FILE_SHARE_WRITE, Nil, OPEN_ALWAYS {OPEN_EXISTING},
        FILE_ATTRIBUTE_TEMPORARY Or
      {FILE_FLAG_RANDOM_ACCESS}
        FILE_FLAG_SEQUENTIAL_SCAN, 0);

      If lHandle <> INVALID_HANDLE_VALUE Then
      Begin
        windows.SetFilePointer(lHandle, 0, Nil, FILE_END);

        Try
          If _FileSize(lFile) = 0 Then
            _DeleteFilesByDate(lDir + cLogDir, '*' + cLogFileExt, IncDay(Date,
              -cLOGTIMELIFE));
        Except
        End;

        // new file
(*        If Not lFlag Then
        Begin
          // delete old files in the system
          _DeleteFilesByDate(lDir + cLogDir, '*' + cLogFileExt, IncDay(Date,
            -cLOGTIMELIFE));

          lStr := TStringlist.Create;
          Try
            _GetAllEnvVars(lStr);

            If lStr.Count > 0 Then
              For lCont := 0 To lStr.Count - 1 Do
                If lStr[lCont] <> '' Then
                Begin
                  lMessage := FormatDateTime('hh:mm:ss:zzz', Time) + ' :- ' +
                    lStr[lCont] + CRLF;
                  windows.WriteFile(lHandle, lMessage[1], Length(lMessage),
                    lResult, Nil);
                End;
          Finally
            FreeAndNil(lStr);
          End;
        End;*)

        windows.SetFilePointer(lHandle, 0, Nil, FILE_END);
        lMessage := FormatDateTime('hh:mm:ss:zzz', Time) + ' :- ' + pMessage +
          CRLF;
        windows.WriteFile(lHandle, lMessage[1], Length(lMessage), lResult, Nil);
      End; // if lhandle
    Finally
      If lHandle > 0 Then
        Windows.CloseHandle(lHandle);
    End;
  End; // if pMessage
End;

{-----------------------------------------------------------------------------
  Procedure: _Delay
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _Delay(msecs: Longint);
Var
  targettime: Longint;
  Msg: TMsg;
Begin
  targettime := GetTickCount + msecs;
  While targettime > GetTickCount Do
    If PeekMessage(Msg, 0, 0, 0, PM_REMOVE) Then
    Begin
      If Msg.message = WM_QUIT Then
      Begin
        {transmit the message to the form}
        TranslateMessage(Msg);
        DispatchMessage(Msg);
        Break;
      End; {If Msg.message = cMCMMESSAGE Then}

      TranslateMessage(Msg);
      DispatchMessage(Msg);
    End; {If PeekMessage(Msg, 0, 0, 0, PM_REMOVE) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: _ValidExtension
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _ValidExtension(Const pFileName: String): Boolean;
Var
  lFileExt: String;
Begin
  Result := False;
  lFileExt := Lowercase(ExtractFileExt(Trim(pFileName)));
  If lFileExt <> '' Then
    Result := (lFileExt = cXMLEXT) Or
      (lFileExt = cXSLEXT) Or
      (lFileExt = cXSDEXT) Or
      (lFileExt = cACKEXT) Or
      (lFileExt = cNACKEXT);
End;

{-----------------------------------------------------------------------------
  Procedure: _CallDebugLog
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _CallDebugLog(Const pMessage: String);
Begin
{$IFDEF DEBUG}
  _LogMSG(pMessage);
{$ENDIF}
End;

{-----------------------------------------------------------------------------
  Procedure: _AddSeparatorToStrings
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _AddSeparatorToStrings(Seperator: Char; List: TStringList): String;
Var
  lCont: Integer;
Begin
  Result := '';
  If list <> Nil Then
    For lCont := 0 To List.Count - 1 Do
      If Result <> '' Then
        Result := Result + Seperator + List[lCont]
      Else
        Result := List[lCont];
End;

{-----------------------------------------------------------------------------
  Procedure: _CheckParams
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CheckParams(pParams: Array Of Variant): Boolean;
Var
  lCount: Integer;
Begin
  Result := True;

  // check the values in the array
  For lCount := Low(pParams) To High(pParams) Do
  Try
    If VarIsEmpty(pParams[lCount]) Or VarIsNull(pParams[lCount]) Or
      ((VarIsNumeric(pParams[lCount]) And (VarAsType(pParams[lCount], varDouble)
      = 0))) Then
    Begin
      Result := False;
      Break;
    End;
  Except
    Result := True;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _SafeGuidtoString
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _SafeGuidtoString(pGuid: TGuid): String;
Begin
  Try
    Result := GUIDToString(pGuid);
  Except
    Result := '';
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _SafeStringToGuid
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _SafeStringToGuid(Const pString: String): TGuid;
Begin
  Fillchar(Result, SizeOf(Tguid), 0);
  Try
    If (pString <> '') And (Length(pString) = Length(cGUIDREF)) Then
      Result := StringToGUID(pString)
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _IsValidGuid
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _IsValidGuid(Const pGuid: TGuid): Boolean;
Begin
  Result := False;
  Try
    Result := (_SafeGuidtoString(pGuid) <> '') And Not IsEqualGUID(pGuid, GUID_NULL);
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _IsValidGuid
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _IsValidGuid(Const pGuid: String): Boolean;
Var
  lGuid: TGuid;
Begin
  Result := False;
  If Length(pGuid) = Length(cGUIDREF) Then
  Begin
    try
      lGuid := _SafeStringToGuid(pGuid);
    except
      fillchar(lGuid, SizeOf(TGuid), 0);
    end;

    Result := Not IsEqualGUID(lGuid, GUID_NULL);
  End; {If Length(pGuid) = Length(cGUIDREF) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: _IsValidOleVariant
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _IsValidOleVariant(pVar: Olevariant): Boolean;
Begin
  Result := False;

  // test all valid entries...
  Try
    Case TVarData(pVar).VType Of
      varSmallInt,
        varInteger,
        varSingle,
        varDouble,
        varCurrency,
        varDate,
        varOleStr,
        varBoolean,
        varShortInt,
        varByte,
        varWord,
        varLongWord,
        varInt64,
        varString: Result := True;

        // avoid this because i have to store the value into the database
      varDispatch,
        varError,
        varUnknown,
        varAny,
        varArray,
        varByRef: Result := False;
    Else
      If VarIsNull(pVar) Or VarIsClear(pVar) Then
        Result := True;
    End;
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _GetOlevariantArraySize
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetOlevariantArraySize(pVar: Olevariant): Integer;
Begin
  Result := 0;
  //If Not VarIsNull(pVar) And Not VarIsEmpty(pVar) Then
  If Not VarIsNull(pVar) And Not VarIsEmpty(pVar) And VarIsArray(pVar) Then
    Result := VarArrayHighBound(pVar, VarArrayDimCount(pVar));
End;

{-----------------------------------------------------------------------------
  Procedure: _CreateInboxMsgInfo
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CreateInboxMsgInfo(pMsg: Olevariant): TMessageInfo;
Var
  lMsg: TMessageInfo;
Begin
  Result := Nil;
  If Not VarIsNull(pMsg) Then
  Begin
    lMsg := TMessageInfo.Create;
    With lMsg Do
    Try
      Guid := StringToGUID(VarToStr(pMsg[0]));
      Company_Id := pMsg[1];
      Subject := pMsg[2];
      From := pMsg[3];
      To_ := pMsg[4];
      Pack_Id := pMsg[5];
      Status := pMsg[6];
      TotalItens := pMsg[7];
      Date := pMsg[8];
      Mode := pMsg[9];
      TotalDone := pMsg[10];
      Param1 := '';
      Param2 := '';
    Except
      FreeAndNil(lMsg);
    End;

    Result := lMsg;
  End; {If Not VarIsNull(pMsg) Then}
{
  fieldbyname('guid').asString,       0
  fieldbyname('company_id').Asinteger, 1
  fieldbyname('subject').AsString,     2
  fieldbyname('userfrom').AsString,    3
  fieldbyname('userto').AsString,      4
  FieldByName('package_id').AsInteger, 5
  FieldByName('status').AsInteger,     6
  FieldByName('totalitems').AsInteger, 7
  FieldByName('received').AsDateTime,  8
  FieldByName('mode').Asinteger        9
  FieldByName('totaldone').Asinteger   10
}

End;


{-----------------------------------------------------------------------------
  Procedure: _CreateEmailAccount
  Author:    vmoura
-----------------------------------------------------------------------------}
function _CreateEmailAccount(pEmail: OleVariant): TEmailAccount;
Var
  lEmail: TEmailAccount;
  lSep: String;
Begin
  Result := Nil;
  If Not VarIsNull(pEmail) Then
  Begin
    lEmail:= TEmailAccount.Create;
    With lEmail Do
    Try
      YourEmail   := pEmail[0];
      emailsystem_id:= pEmail[1];
      YourName:= pEmail[2];
      servertype:= pEmail[3];
      IsDefaultOutgoing:= pEmail[4];
      IncomingServer:= pEmail[5];
      OutgoingServer:= pEmail[6];
      UserName:= pEmail[7];
      Password:= pEmail[8];
      IncomingPort:= pEmail[9];
      OutgoingPort:= pEmail[10];
      Authentication:= pEmail[11];
      OutgoingUserName:= pEmail[12];
      OutgoingPassword:= pEmail[13];
      UseSSLIncomingPort:= pEmail[14];
      UseSSLOutgoingPort:= pEmail[15];
      MailBoxName := pEmail[16];
      lSep := VarToStr(pEmail[17]);
      if lSep = '' then
        lSep := '/';
      try
        MailBoxSeparator :=  lSep[1];
      except
      end;  
    Except
      FreeAndNil(lEmail);
    End;

    Result := lEmail;
  End; {If Not VarIsNull(pMsg) Then}
{
  fieldbyname('youremail').asString,              0
    fieldbyname('emailsystem_id').AsString,       1
    fieldbyname('yourname').AsString,             2
    fieldbyname('servertype').AsString,          3
    fieldbyname('isdefault').Asboolean,           4
    fieldbyname('incomingserver').AsString,       5
    fieldbyname('outgoingserver').AsString,       6
    fieldbyname('username').AsString,             7
    fieldbyname('password').AsString,             8
    fieldbyname('incomingport').AsInteger,        9
    fieldbyname('outgoingport').AsInteger,        10
    fieldbyname('authentication').asBoolean,      11
    fieldbyname('outgoingusername').AsString,     12
    fieldbyname('outgoingpassword').AsString,     13
    fieldbyname('usesslincomingport').AsBoolean,  14
    fieldbyname('usessloutgoingport').AsBoolean   15
    fieldbyname('MailBoxName').AsString,     16
    fieldbyname('MailBoxSeparator').AsString,     17
}
end;

{-----------------------------------------------------------------------------
  Procedure: _CreateEmailSystem
  Author:    vmoura
-----------------------------------------------------------------------------}
function _CreateEmailSystem(pSystem: Olevariant): TEmailSystem;
Var
  lSystem: TEmailSystem;
Begin
  Result := Nil;
  If Not VarIsNull(pSystem) Then
  Begin
    lSystem:= TEmailSystem.Create;
    With lSystem Do
    Try
      Id   := pSystem[0];
      ServerType:= pSystem[1];
      Description:= pSystem[2];
      IncomingGuid:= pSystem[3];
      OutgoingGuid:= pSystem[4];
      Active:= pSystem[5];
    Except
      FreeAndNil(lSystem);
    End;

    Result := lSystem;
  End; {If Not VarIsNull(pMsg) Then}
{
    fieldbyname('ID').asinteger,              0
    fieldbyname('ServerType').AsString,       1
    fieldbyname('Description').AsString,             2
    fieldbyname('IncomingGuid').AsString,          3
    fieldbyname('OutgoingGuid').Asboolean,           4
    fieldbyname('IsActive').asboolean                  5
}
end;


function _IsMAPI(pDesc: String): Boolean;
begin
  Result := (Lowercase(Trim(pDesc)) = Lowercase(Trim(cMAPI))) and
    (Length(Trim(pDesc)) = Length(cMAPI))
end;

function _IsPOP3(pDesc: String): Boolean;
begin
  Result := (Lowercase(Trim(pDesc)) = Lowercase(Trim(cPOP3))) and
    (Length(Trim(pDesc)) = Length(cPOP3))
end;

function _IsIMAP(pDesc: String): Boolean;
begin
  Result := (Lowercase(Trim(pDesc)) = Lowercase(Trim(cIMAP))) and
    (Length(Trim(pDesc)) = Length(cIMAP))
end;

function _Is3rdPRT(pDesc: String): Boolean;
begin
  Result := (Lowercase(Trim(pDesc)) = Lowercase(Trim(c3RDPRT))) and
    (Length(Trim(pDesc)) = Length(c3RDPRT))
end;

{-----------------------------------------------------------------------------
  Procedure: _CreateCISMsgInfo
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CreateCISMsgInfo(pMsg: Olevariant): TCISMessage;
Var
  lCisMsg: TCISMessage;
Begin
  If Not VarIsNull(pMsg) Then
  Begin
    lCisMsg := TCISMessage.Create;

    With lCisMsg Do
    Try
      OutboxGuid := VarToStr(pMsg[0]);
      IrMark := VarToStr(pMsg[1]);
      CorrelationID := VarToStr(pMsg[2]);
      CISClassType := VarToStr(pMsg[3]);
      Polling := pMsg[4];
      Redirection := VarToStr(pMsg[5]);
      FileGuid := VarToStr(pMsg[6]);
    Except
      FreeAndNil(lCisMsg);
    End; {try}
  End; {If Not VarIsNull(pMsg) Then}

  Result := lCisMsg;

{
        Fieldbyname('irmark').asString,
          Fieldbyname('correlationid').AsString,
          Fieldbyname('classtype').AsString,
          Fieldbyname('polling').AsInteger,
          Fieldbyname('redirection').AsString,
          Fieldbyname('fileguid').AsString
}
End;

{-----------------------------------------------------------------------------
  Procedure: _CreateOutboxMsgInfo
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CreateOutboxMsgInfo(pMsg: Olevariant): TMessageInfo;
Var
  lMsg: TMessageInfo;
Begin
//  Result := Nil;
  If Not VarIsNull(pMsg) Then
  Begin
    lMsg := TMessageInfo.Create;
    With lMsg Do
    Try
      Guid := StringToGUID(VarToStr(pMsg[0]));
      Company_Id := pMsg[1];
      Subject := pMsg[2];
      From := pMsg[3];
      To_ := pMsg[4];
      Pack_Id := pMsg[5];
      Status := pMsg[6];
      Param1 := pMsg[7];
      Param2 := pMsg[8];
      TotalItens := pMsg[9];
      Date := pMsg[10];
      ScheduleId := pMsg[11];
      Mode := pMsg[12];
      TotalDone := pMsg[13];
    Except
      FreeAndNil(lMsg);
    End; {With lMsg Do}
  End; {If Not VarIsNull(pMsg) Then}
{
  Fieldbyname('guid').asString, 0
    Fieldbyname('company_id').Asinteger, 1
    Fieldbyname('subject').AsString, 2
    Fieldbyname('userfrom').AsString, 3
    Fieldbyname('userto').AsString, 4
    FieldByName('package_id').AsInteger, 5
    FieldByName('status').AsInteger, 6
    FieldByName('param1').AsString, 7
    FieldByName('param2').AsString, 8
    FieldByName('totalitems').AsInteger, 9
    FieldByName('sent').AsDateTime 10
    FieldByName('schedule').asInteger 11
    FieldByName('mode').asInteger 12
    FieldByName('totaldone').asInteger 13
    }

  Result := lMsg;
End;

{-----------------------------------------------------------------------------
  Procedure: _CreateDailySchedule
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CreateDailySchedule(pSchedule: Olevariant): TDailySchedule;
Var
  lDay: TDailySchedule;
Begin
  lDay := TDailySchedule.Create;

  With lDay Do
  Try
    StartDate := pSchedule[0][0];
    EndDate := pSchedule[0][1];
    StartTime := pSchedule[0][2];
    AllDays := pSchedule[0][3];
    WeekDays := pSchedule[0][4];
    EveryYDay := pSchedule[0][5];
  Except
    FreeAndNil(lday);
  End;

  Result := lDay;

(*
    fieldbyname('startdate').asDatetime,
      FieldByName('enddate').asdatetime,
      fieldbyname('starttime').asDatetime,
      fieldbyname('alldays').asboolean,
      fieldbyname('weekdays').asBoolean,
      fieldbyname('everyday').AsInteger

 *)
End;

{-----------------------------------------------------------------------------
  Procedure: _CreateExportPackage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CreateExportPackage(pVar: Olevariant): TPackageInfo;
Var
  lPack: TPackageInfo;
Begin
(* FieldByName('Id').asInteger,
        FieldbyName('company_id').asinteger,
        FieldByName('Description').asString,
        FieldByName('UserReference').asInteger,
        FieldByName('FileGuid').asString,
        FieldByName('pluginlink').asString]); *)

  lPack := TPackageInfo.Create;

  With lPack Do
  Try
    Id := pVar[0];
    Company_Id := pVar[1];
    Description := pVar[2];
    UserReference := pVar[3];

    Try
      Guid := _SafeStringToGuid(varToStr(pVar[4]));
    Except
    End;
    PluginLink := pVar[5]
  Except
    FreeAndNil(lpack);
  End;

  Result := lPack;
End;

{-----------------------------------------------------------------------------
  Procedure: _CreateCompanyObj
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CreateCompanyObj(pComp: OleVariant): TCompany;
Var
  lComp: TCompany;
Begin
  lComp := TCompany.Create;
  With lComp Do
  Try
    Id := pComp[0];
    ExCode := Trim(pComp[1]);
    Desc := Trim(pComp[2]);
    Active := pComp[3];
    Periods := pComp[4];
    Directory := pComp[5];
    Guid := pComp[6];
  Except
    FreeAndNil(lComp);
  End;

  Result := lComp;
End;

{-----------------------------------------------------------------------------
  Procedure: _CompanyCreateBulk
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _CompanyCreateBulk(Const pGuid: String);
Var
  lFile: String;
  lStream: TFileStream;
Begin
  lFile := IncludeTrailingPathDelimiter(_GetApplicationPath + cBULKDIR) + pGuid;
  If Not FileExists(lFile) Then
  Begin
    lStream := TFileStream.Create(lFile, fmcreate);
    FreeAndNil(lStream);
  End; {If Not FileExists(lFile) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: _CompanyDeleteBulk
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _CompanyDeleteBulk(Const pGuid: String);
Var
  lFile: String;
Begin
  lFile := IncludeTrailingPathDelimiter(_GetApplicationPath + cBULKDIR) + pGuid;
  If FileExists(lFile) Then
    _DelFile(lFile);
End;

{-----------------------------------------------------------------------------
  Procedure: _CompanyHasReqBulk
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CompanyHasReqBulk(Const pGuid: String): boolean;
Var
  lFile: String;
Begin
  lFile := IncludeTrailingPathDelimiter(_GetApplicationPath + cBULKDIR) + pGuid;
  Result := FileExists(lFile);
End;


{-----------------------------------------------------------------------------
  Procedure: _VerifyDailySchedule
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _VerifyDailySchedule(pDay: TDailySchedule): Boolean;
Begin
  Result := False;

  If pDay <> Nil Then
  {verify the start point date}
    With pDay Do
      If (Date >= StartDate) And (Date <= EndDate) Then
      Begin
    {verify the start point time}
        If FormatDateTime('hh:nn', time) = FormatDateTime('hh:nn', StartTime) Then
        Begin
      {choice: all days or only weekdays or every x days}
          If AllDays Then
            Result := True
          Else If WeekDays And (DayOfTheWeek(Now) In [1..5]) Then
            Result := True
          Else If (EveryYDay > 0) And ((DaysBetween(Date, StartDate) Mod
            EveryYDay) = 0) Then
            Result := True;
        End; {If FormatDateTime('hh:nn', time) = FormatDateTime('hh:nn', StartTime) Then}
      End; {If Date >= StartDate Then}
End;

{-----------------------------------------------------------------------------
  Procedure: _IsValidXml
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _IsValidXml(Const pXml: WideString): Boolean;
Var
  lXmlDoc: TXMLDoc;
Begin
  lXmlDoc := TXMLDoc.Create;

  Result := False;
  Try
    If FileExists(ExpandUNCFileName(pXml)) And (_FileSize(pXml) > 0) Then
    Try
      Result := lXmlDoc.Load(ExpandUNCFileName(pXml));
    Finally
      {give another try changing the encode params }
    End;
  Finally
    Try
      If Not Result Then
        Result := lXmlDoc.LoadXml(pXml);
    Except
    End;
  End;

  FreeAndNil(lXmlDoc);
End;

// ---------------------------------------------------------------------------
Function _AddLeafNode(ToNode: IXMLDomNode; Const AsName: String;
  Const AsValue: OLEVariant; AsCData: Boolean): IXmlDomNode;
{ Adds (and returns) a new 'leaf' node to the supplied node, assigning AsName
  as the node name, and AsValue as the node value. The node will always be a
  text node. }
Var
  LeafNode: IXMLDOMNode;
Begin
  If AsCData Then
  Begin
    LeafNode := ToNode.appendChild(ToNode.ownerDocument.createElement(AsName));
    LeafNode.appendChild(LeafNode.ownerDocument.createCDATASection(AsValue));
  End
  Else
  Begin
    LeafNode := ToNode.appendChild(ToNode.ownerDocument.createElement(AsName));
    LeafNode.appendChild(ToNode.ownerDocument.createTextNode(AsValue));
  End;
  Result := LeafNode;
End;

{-----------------------------------------------------------------------------
  Procedure: _GetNodeByName
  Author:    vmoura

  NODE_INVALID = $00000000;
  NODE_ELEMENT = $00000001;
  NODE_ATTRIBUTE = $00000002;
  NODE_TEXT = $00000003;
  NODE_CDATA_SECTION = $00000004;
  NODE_ENTITY_REFERENCE = $00000005;
  NODE_ENTITY = $00000006;
  NODE_PROCESSING_INSTRUCTION = $00000007;
  NODE_COMMENT = $00000008;
  NODE_DOCUMENT = $00000009;
  NODE_DOCUMENT_TYPE = $0000000A;
  NODE_DOCUMENT_FRAGMENT = $0000000B;
  NODE_NOTATION = $0000000C;

-----------------------------------------------------------------------------}
Function _GetNodeByName(pNode: IXMLDomNode; Const pName: String): IXmlDomNode;
Var
  lCont: Integer;
Begin
  Result := Nil;

  If pNode <> Nil Then
  Begin

    Try
      Result := pNode.selectSingleNode(pName);
    Except
    End;

    If Result = Nil Then
      If Not (Lowercase(pNode.nodeName) = Lowercase(pName)) Then
      // is the correct node?
      Begin
        If pNode.hasChildNodes And (pNode.childNodes[0] <> Nil) And
          (pNode.childNodes[0].nodeType In [NODE_ELEMENT]) Then
        // if it is a normal node and has child, get next child node avaliable
          Result := _GetNodeByName(pNode.childNodes.nextNode, pName)
        Else If pNode.nextSibling = Nil Then
        Begin
        //If pNode.nodeType In [NODE_DOCUMENT, NODE_CDATA_SECTION, NODE_COMMENT]
          If pNode.nodeType In [NODE_DOCUMENT] Then
          // root document begin. It is only happen when i load all document
          Begin
            lCont := 0; // how deep can i go...
            While (pNode.childNodes[lCont] <> Nil) And Not
              pNode.childNodes[lCont].hasChildNodes And (lCont < 3) Do
              Inc(lCont);

            If pNode.childNodes[lCont] <> Nil Then
              Result := _GetNodeByName(pNode.childNodes[lCont].firstChild, pname)
            Else
              Result := Nil;
          End
          Else If pNode.parentNode.nextSibling <> Nil Then
            Result := _GetNodeByName(pNode.parentNode.nextSibling, pName)
          Else // come back
          Begin
            lCont := 0;
            {came back x nodes. lcont is here to avoid infinite looping}
            While (pNode <> nil) and (pNode.nextSibling = Nil) And (lCont < 20) Do
            Begin
              if pNode.parentNode = nil then
                Break
              else
                pNode := pNode.parentNode;
              Inc(lCont);
            End; {while (pNode.nextSibling = nil) and (lCont < 20) do}

            Result := _GetNodeByName(pNode.nextSibling, pName)
          End; {begin}
        End
      // get the next node...
        Else If pNode.nextSibling <> Nil Then
          Result := _GetNodeByName(pNode.nextSibling, pName)
        Else If pNode.parentNode.nextSibling <> Nil Then
          Result := _GetNodeByName(pNode.parentNode.nextSibling, pName)
//      Else // comeback to root document
//        Result := _GetNodeByName(pNode.ownerDocument, pName)

      End // end nodename = pname
      Else
        Result := pNode;
  End; {If pNode <> Nil Then}
End;

{ ----------------------------------------------------------------------------
  function: _GetChildNodeByName

  Returns the named node, provided one can be found as a direct child of the
  supplied pNode. Returns nil if no child node of that name can be found.
  ---------------------------------------------------------------------------- }
Function _GetChildNodeByName(pNode: IXMLDomNode; Const pName: String):
  IXMLDOMNode;
Begin
  Result := Nil;
  If pNode <> Nil Then
  Begin
    Try
      Result := pNode.selectSingleNode(pName);
    Except

    End;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _SetNodeValueByName
  Author:    vmoura

  i have to save the value boolean values into the text property
  otherwise i dont know how get diference between 0/1/true/false
-----------------------------------------------------------------------------}
Function _SetNodeValueByName(Var pNode: IXMLDomNode; Const pName: String;
  pValue: OleVariant): IXmlDomNode;
Var
  lNode: IXMLDomNode;
  lcData: IXMLDOMCDATASection;
  OldSeparator: Char;
Begin
  lNode := _GetNodeByName(pNode, pName); // find the real node

  If lNode <> Nil Then
  Begin
    If Pos('cdata', lowercase(lNode.xml)) > 0 Then
    Begin
      //lNode.nodeTypedValue := Format(cXMLCDATATAG, [pValue]);
      {
      var demoElement=xmlDoc.createElement("example");
      var demoContent=xmlDoc.createCDATASection("<sample>This is an element</sample>");
      demoElement.appendChild(demoContent);
      }
      lNode.text := ''; // clear original text values and sections
      lcData := lNode.ownerDocument.createCDATASection(Trim(pValue));
        // create a new section
      lNode := lNode.appendChild(lcData);
        // add this section on the node required
    End
    Else If VarIsType(pValue, varBoolean) Then
      //lNode.text := inttostr(ord(Boolean(pValue)))
      //lNode.nodeTypedValue := inttostr(ord(Boolean(pValue)))
      //lNode.nodeTypedValue := VarAsType(pValue, VarBoolean)
//      lNode.nodeTypedValue := pValue
      lNode.text := pValue
    Else
    Begin
      OldSeparator := SetDecimalSeparator('.');
      Try
        lNode.nodeTypedValue := pValue;
      Finally
        SetDecimalSeparator(OldSeparator);
      End;
    End;

    Result := lNode;
  End
  Else
    Raise Exception.Create('_SetNodeValueByName :- Invalid node: ' + pName);
End;

{-----------------------------------------------------------------------------
  Procedure: _GetNodeValueByName
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetNodeValueByName(pNode: IXMLDomNode; Const pName: String; Var
  pValue: Variant): IXmlDomNode;
Var
  lNode: IXMLDomNode;
Begin
  lNode := _GetNodeByName(pNode, pName); // find the real node

  If lNode <> Nil Then
  Begin
//    If VarIsType(lNode.nodeTypedValue, varBoolean) Then
      //pValue := VarAsType(lNode.nodeTypedValue, varBoolean)

//      pValue := VarAsType(lNode.nodeTypedValue, varBoolean)
//    Else
    pValue := lNode.nodeTypedValue;

    Result := lNode;
  End
  Else
    Raise exception.Create('_GetNodeValueByName :- Invalid node "' + pName +
      '"');
End;

// ---------------------------------------------------------------------------

Function _GetNodeValue(pNode: IXMLDOMNode; Const pName: String): Variant;
Var
  OldSeparator: Char;
Begin
  OldSeparator := SetDecimalSeparator('.');
  Try
    _GetNodeValueByName(pNode, pName, Result);
  Finally
    SetDecimalSeparator(OldSeparator);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _GetXmlRecordCount
  Author:    vmoura

  get the records count inside xml
  In general, pName will receive "message" and get the records after that
  and pNode will receive the root document
-----------------------------------------------------------------------------}
Function _GetXmlRecordCount(pNode: IXMLDomNode; Const pName: String =
  'message'): Integer;
Var
  lNode: IXMLDomNode;
Begin
//  Result := 0;
  lNode := _GetNodeByName(pNode, pName);

  If lNode <> Nil Then
  Begin
    If lNode.hasChildNodes Then
      Result := lNode.childNodes.length
    Else
      Raise exception.Create('_GetXmlRecordCount :- No child found.');
  End
  Else
    Raise exception.Create('_GetXmlRecordCount :- Invalid node.');
End;

{-----------------------------------------------------------------------------
  Procedure: _CreateXmlFile
  Author:    vmoura

  create a xml using memorystream
-----------------------------------------------------------------------------}
Function _CreateXmlFile(Const pFileName: String; Const pXml: WideString):
  Boolean;
Var
//  lMemo: TMemoryStream;
  lMemo: TStringList;
  lXml: String;
Begin
  Try
    ForceDirectories(ExtractFilePath(pFileName));
  Except
  End;

  //lMemo := TMemorystream.Create;
  lMemo := TStringList.Create;

  Try
    If pXml <> '' Then
    Begin
      If _FileSize(pFileName) > 0 Then
        _delFile(pFileName);

      If _FileSize(pXml) > 0 Then
      Begin
        {load a file}
        lXml := pXml;
        If Not CopyFile(pChar(lXml), pChar(pFileName), False) Then
        Begin
          lMemo.LoadFromFile(pXml);
          lMemo.SaveToFile(pFilename);
        End
      End
      Else
      Begin
        {load a XML string}
//      SetLength(lXml, Length(pXml));
//      lXml := pXml;
//      lMemo.Write(lXml[1], Length(pXml));
        lMemo.Text := pXml;
        lMemo.SaveToFile(pFilename);
      End;
    End;
  Except
    On e: exception Do
    Begin
      _DelFile(pFilename);
      _LogMSG('_CreateXmlFile ' + _TranslateErrorCode(cSAVINGFILEERROR) +
        ' Error: ' + e.message);
    End; {begin}
  End; {try}

  FreeAndNil(lMemo);
  Result := _FileSize(pFileName) > 0;
End;
{-----------------------------------------------------------------------------
  Procedure: CreateXmlsPackagesPaths
  Author:    vmoura

  When the import/export package are about to insert a new package, i need
  to get this files and copy them to the file system.
  The xml, pxsl, and lxsd will be just a reference file... not the whole path
-----------------------------------------------------------------------------}

Function _CreateXmlsPackagesPaths(Var pXml, pXsl, pXSD: String): Boolean;
Var
  lXmlGuidf, lxslGuidf, lXsdGuidf,
    lXMLFile,
    lXSLFile,
    lXSDFile: String;
Begin
  Result := True;

  lXmlGuidf := GUIDToString(_CreateGuid) + cXmlExt;
  lxslGuidf := GUIDToString(_CreateGuid) + cXSLExt;
  lXsdGuidf := GUIDToString(_CreateGuid) + cXSDExt;

  lXMLFile := IncludeTrailingPathDelimiter(_GetApplicationPath + cXMLDIR) +
    lXmlGuidf;

  lXSLFile := IncludeTrailingPathDelimiter(_GetApplicationPath + cXSLDIR) +
    lxslGuidf;

  lXSDFile := IncludeTrailingPathDelimiter(_GetApplicationPath + cXSDDIR) +
    lXsdGuidf;

    // verify Xml file
  If (pXML <> '') And _IsValidXml(pXML) Then
  Begin
      // test if exists
    If _FileSize(pXml) > 0 Then
    Begin
      If Not CopyFile(pChar(ExpandUNCFileName(pXml)), pChar(lXmlFile), True)
        Then
        Result := False
    End
    Else
      _CreateXmlFile(lXMLFile, pXML);
  End
  Else
    Result := False;

    // verify xsl
  If (pXSL <> '') And _IsValidXml(pXSL) Then
  Begin
      // test if exists
    If _FileSize(pXSL) > 0 Then
    Begin
      If Not CopyFile(pChar(ExpandUNCFileName(pXSL)), pChar(lXslFile), True)
        Then
        Result := False
    End
    Else
      _CreateXmlFile(lXslFile, pXSL);
  End
  Else
    Result := False;

    // verify xsl
  If (pXSD <> '') And _IsValidXml(pXSD) Then
  Begin
      // test if exists
    If _FileSize(pXSD) > 0 Then
    Begin
      If Not CopyFile(pChar(ExpandUNCFileName(pXSD)), pChar(lXsdFile), True)
        Then
        Result := False
    End
    Else
      _CreateXmlFile(lXsdFile, pXSD);
  End
  Else
    Result := False;

  // if those files are ok...
  If Result Then
  Begin
    pXml := lXmlGuidf;
    pXsl := lxslGuidf;
    pXSD := lXsdGuidf;
  End
  Else
  Begin
    _DelFile(lXMLFile);
    _DelFile(lXSLFile);
    _DelFile(lXSDFile);
  End;

End;

{-----------------------------------------------------------------------------
  Procedure: _FillHeader
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _FillXMLHeader(Var pHeader: TXMLHeader; pGuid: TGuid; pNumber, pCount:
  Smallint; Const pSource, pDestination, pPlugin: ShortString; pFlag: Byte);
Begin
  With pHeader Do
  Begin
    Guid := pGuid;
    Number := pNumber;
    Count := pCount;
    Source := pSource;
    Destination := pDestination;
    Flag := pFlag;
    Plugin := pPlugin;
  End;
End;

Function _DSRFormatConnectionString(Const pServer: String): String;
Begin
  Result := Format(cADOCONNECTIONSTR1, [pServer, cICEDBPWD, cICEDBUSER])
End;

{-----------------------------------------------------------------------------
  Procedure: _SetXmlMsgHeader
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _SetXmlHeader(Var pDoc: TXMLDoc; pHeader: TXMLHeader): Boolean;
Var
  lNode: IXMLDOMNode;
Begin
  Result := False;

  If Assigned(pDoc) Then
    With pDoc Do
    Try
      lNode := _GetNodeByName(Doc, 'message');

      If lNode <> Nil Then
        With pHeader Do
        Begin
          lNode.attributes.GetNamedItem('guid').nodeValue :=
            VarToStr(GuidtoString(Guid));
          lNode.attributes.GetNamedItem('number').nodeValue := Number;
          lNode.attributes.GetNamedItem('count').nodeValue := Count;
          lNode.attributes.GetNamedItem('source').nodeValue := VarToStr(Source);
          lNode.attributes.GetNamedItem('destination').nodeValue :=
            VarToStr(Destination);
          lNode.attributes.GetNamedItem('flag').nodeValue := Flag;
          lNode.attributes.GetNamedItem('plugin').nodeValue := Plugin;
          lNode.attributes.GetNamedItem('datatype').nodeValue := datatype;
          lNode.attributes.GetNamedItem('desc').nodeValue := desc;
          lNode.attributes.GetNamedItem('xsl').nodeValue := xsl;
          lNode.attributes.GetNamedItem('xsd').nodeValue := xsd;
{
          Try
            lNode.attributes.GetNamedItem('startdate').nodeValue := StartDate;
          Except
          End;

          Try
            lNode.attributes.GetNamedItem('enddate').nodeValue := enddate;
          Except
          End;
}
        End;
      Result := True;
    Except
    End;
End;

{-----------------------------------------------------------------------------
  Procedure: _GetXMLHeader
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetXMLHeader(pXml: WideString; Var pHeader: TXMLHeader): Boolean;
Var
  lDoc: TXMLDoc;
Begin
  Result := False;
  lDoc := Nil;

  Try
    lDoc := TXMLDoc.Create;
    If lDoc.LoadXml(pXml) Then
      Result := _GetXMLHeader(lDoc, pHeader);
  Finally
    If Assigned(lDoc) Then
      lDoc.Free;
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: _GetXMLHeader
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetXMLHeader(pDoc: TXMLDoc; Var pHeader: TXMLHeader): Boolean;
Var
  lNode: IXMLDOMNode;
Begin
  Result := False;

  If Assigned(pDoc) Then
    With pDoc Do
    Try
      lNode := _GetNodeByName(Doc, 'message');

      If lNode <> Nil Then
        With pHeader Do
        Begin
          Try
            Guid := StringToGUID(ifthen(VarToStr(lNode.attributes[0].NodeValue)
              = '', GUIDToString(GUID_NULL),
              VarToStr(lNode.attributes[0].NodeValue)));
          Except
            Guid := GUID_NULL;
          End;

          Number := lNode.attributes.GetNamedItem('number').nodeValue;
          Count := lNode.attributes.GetNamedItem('count').nodeValue;
          Source := lNode.attributes.GetNamedItem('source').nodeValue;
          Destination := lNode.attributes.GetNamedItem('destination').nodeValue;
          Flag := lNode.attributes.GetNamedItem('flag').nodeValue;
          Plugin := lNode.attributes.GetNamedItem('plugin').nodeValue;
          datatype := lNode.attributes.GetNamedItem('datatype').nodeValue;
          desc := lNode.attributes.GetNamedItem('desc').nodeValue;
          xsl := lNode.attributes.GetNamedItem('xsl').nodeValue;
          xsd := lNode.attributes.GetNamedItem('xsd').nodeValue;
          Try
            StartPeriod :=
              lNode.attributes.GetNamedItem('startperiod').nodeValue;
            StartYear := lNode.attributes.GetNamedItem('startyear').nodeValue;
            EndPeriod := lNode.attributes.GetNamedItem('endperiod').nodeValue;
            EndYear := lNode.attributes.GetNamedItem('endyear').nodeValue;
          Except
          End;
{
          Try
            StartDate := lNode.attributes.GetNamedItem('startdate').nodeValue;
          Except
          End;

          Try
            EndDate := lNode.attributes.GetNamedItem('enddate').nodeValue;
          Except
          End;
}
          Result := True;
        End;
    Except
    End;
End;

{-----------------------------------------------------------------------------
  Procedure: _EcryptAndCompress
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CompressAndEncrypt(Const pFileIn: String): Boolean;
Begin
  Result := False;
  If _CompressFile(pFileIn) Then
    If _EncryptFile(pFileIn) Then
      Result := True
    Else
      _DecompressFile(pFileIn);
End;

{-----------------------------------------------------------------------------
  Procedure: _DecompressAndDecrypt
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _DecryptAndDecompress(Const pFileIn: String): Boolean;
Begin
  Result := False;
  If _DecryptFile(pFileIn) Then
    If _DeCompressFile(pFileIn) Then
      Result := True
    Else
      _EncryptFile(pFileIN);
End;

{-----------------------------------------------------------------------------
  Procedure: _EncryptFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _EncryptFile(Const pFileIn: String; Const pFileout: String = ''):
  Boolean;
Begin
  Result := False;
  //If FileExists(pFileIn) Then
  If _FileSize(pFileIn) > 0 Then
    Result := TCrypto.EncryptFile(pFileIn, pFileout);
End;

{-----------------------------------------------------------------------------
  Procedure: _DecryptFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _DecryptFile(Const pFileIn: String; Const pFileout: String = ''):
  Boolean;
Begin
  Result := False;
  //If FileExists(pFileIn) Then
  If _FileSize(pFileIn) > 0 Then
    Result := TCrypto.DecryptFile(pFileIn, pFileOut);
End;

{-----------------------------------------------------------------------------
  Procedure: _CompressFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CompressFile(Const pFileIn: String; Const pFileout: String = ''):
  Boolean;
Begin
  Result := False;
  If _FileSize(pFileIn) > 0 Then
    Result := TCompression.Compress(pFileIn, pFileOut);
End;

{-----------------------------------------------------------------------------
  Procedure: _DeCompressFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _DeCompressFile(Const pFileIn: String; Const pFileout: String = ''):
  Boolean;
Begin
  Result := False;
  If _FileSize(pFileIn) > 0 Then
    Result := TCompression.DeCompress(pFileIn, pFileOut);
End;

{-----------------------------------------------------------------------------
  Procedure: _EncryptString
  Author:    vmoura
-----------------------------------------------------------------------------}
function _EncryptString(Const pStr: String): String;
begin
  Result := TCrypto.EncryptString(pStr);
end;

{-----------------------------------------------------------------------------
  Procedure: _DecryptString
  Author:    vmoura
-----------------------------------------------------------------------------}
function  _DecryptString(Const pStr: String): String;
begin
  Result := TCrypto.DecryptString(pStr);
end;

{-----------------------------------------------------------------------------
  Procedure: _TranslateErrorCode
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _TranslateErrorCode(pError: Cardinal): String;
Begin
  If pError <> S_OK Then
    Result := _GetErrorMessage(pError);
End;

{-----------------------------------------------------------------------------
  Procedure: _strToken
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _strToken(Var S: String; Seperator: Char): String;
Var
  I: Word;
Begin
  I := Pos(Seperator, S);
  If I <> 0 Then
  Begin
    Result := System.Copy(S, 1, I - 1);
    System.Delete(S, 1, I);
  End
  Else
  Begin
    Result := S;
    S := '';
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _strTokenCount
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _strTokenCount(S: String; Seperator: Char): Integer;
Begin
  Result := 0;
  While S <> '' Do
  Begin
    _StrToken(S, Seperator);
    Inc(Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _CreateFakedString
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CreateFakedString(pSize: integer): String;
Begin
  While Length(Result) < pSize Do
    Result := Result + '*';
End;

{-----------------------------------------------------------------------------
  Procedure: _GetFileFromNameSpace
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetFileFromNameSpace(pDoc: TXMLDoc): String;
Var
  lStr: TStringlist;
Begin
  Result := '';
  If pDoc.Doc.namespaces.length > 0 Then
  Begin
    lStr := TStringlist.Create;

    _strTokenToStrings(pDoc.Doc.namespaces[0], ':', lStr);
    If lStr.Count > 0 Then
    Try
      Result := lStr[2];
    Except
    End;

    FreeAndNil(lStr);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _strTokenToStrings
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _strTokenToStrings(S: String; Seperator: Char; Var List:
  TStringlist);
Var
  Token: String;
Begin
  List.Clear;
  Token := _strToken(S, Seperator);
  While Token <> '' Do
  Begin
    List.Add(Token);
    Token := _strToken(S, Seperator);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: RegisterServer
  Author:    vmoura

  install a dll on the rot table
-----------------------------------------------------------------------------}
Function _RegisterServer(Const aDllFileName: String; aRegister: Boolean):
  Boolean;
Type
  TRegProc = Function: HResult; stdcall;
Const
  cRegFuncNameArr: Array[Boolean] Of PChar = ('DllUnregisterServer',
    'DllRegisterServer');
Var
  vLibHandle: THandle;
  vRegProc: TRegProc;
Begin
  Result := False;
  If (aDllFileName <> '') And (_FileSize(aDllFileName) > 0) Then
  Begin
    Result := False;
    vLibHandle := LoadLibrary(PChar(aDllFileName));
    If vLibHandle = 0 Then
      Exit;
    @vRegProc := GetProcAddress(vLibHandle, cRegFuncNameArr[aRegister]);
    If @vRegProc <> Nil Then
      Result := vRegProc = S_OK;
    FreeLibrary(vLibHandle);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _GetGuidsFromDll
  Author:    vmoura

// dont remove comments
it only works for win32 dlls
-----------------------------------------------------------------------------}
Procedure _GetGuidsFromDll(Const pDll: String; Var pList: TStringList);
Var
  lLib: ITypeLib;
//  libatr: ptlibattr;
  typeinfo: itypeinfo;
  typelibindex: integer;
//  aname: widestring;
//  adocstring: widestring;
//  ahelpcontext: longint;
//  ahelpfile: widestring;
  typeattr: ptypeattr;
Begin
  CoInitialize(Nil);

  Try
    olecheck(LoadTypeLib(pWideChar(WideString(pDll)), lLib));

//    lLib.GetDocumentation(-1, @aname, @adocstring, @ahelpcontext, @ahelpfile);
//    olecheck(llib.GetLibAttr(libatr));
//    llib.ReleaseTLibAttr(libatr);

    For typelibindex := 0 To llib.GetTypeInfoCount - 1 Do
    Begin
      llib.GetTypeInfo(typelibindex, typeinfo);
      olecheck(typeinfo.GetTypeAttr(typeattr));
      Try
        Case typeattr.typekind Of
          TKIND_COCLASS: pList.Add(GUIDToString(typeattr.guid));
        End
      Finally
        typeinfo.releasetypeattr(typeattr);
      End
    End;
  Except
  End;

  CoUninitialize;
End;

{-----------------------------------------------------------------------------
  Procedure: _FindTask
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _FindTask(Const pExeName: String): Boolean;
Var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
Begin
  Result := False;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  While Integer(ContinueLoop) <> 0 Do
  Begin
    If ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(pExeName)) Or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(pExeName))) Then
    Begin
      Result := True;
      Break;
    End;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  End;

  CloseHandle(FSnapshotHandle);
End;

{-----------------------------------------------------------------------------
  Procedure: _fileExec
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _fileExec(Const aCmdLine: String; aHide, aWait: Boolean): Boolean;
Var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
Begin
  {setup the startup information for the application }
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);

  With StartupInfo Do
  Begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW Or STARTF_FORCEONFEEDBACK;
    If aHide Then
      wShowWindow := SW_HIDE
    Else
      wShowWindow := SW_SHOWNORMAL;
  End;

    Result := CreateProcess(Nil, PChar(aCmdLine), Nil, Nil, False,
      NORMAL_PRIORITY_CLASS, Nil, Nil, StartupInfo, ProcessInfo);

  If aWait Then
    If Result Then
    Begin
      WaitForInputIdle(ProcessInfo.hProcess, INFINITE);
      WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    End;
End;

{-----------------------------------------------------------------------------
  Procedure: _KillTask
  Author:    vmoura

  kill an application
-----------------------------------------------------------------------------}
Function _KillTask(Const pExeName: String): Integer;
Var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
Begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  While Integer(ContinueLoop) <> 0 Do
  Begin
    If ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(pExeName)) Or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(pExeName))) Then
    Begin
      Result := Integer(TerminateProcess(
        OpenProcess(PROCESS_TERMINATE,
        BOOL(0),
        FProcessEntry32.th32ProcessID),
        0));
      Break;
    End;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  End;

  CloseHandle(FSnapshotHandle);
End;

{-----------------------------------------------------------------------------
  Procedure: _ServiceStatus
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _ServiceStatus(Const sService: String; Const sMachine: String = '';
  Const pStart: Boolean = False; Const pStop: Boolean = False): DWORD;
Const
  RETRY_TIME = 10000;
Var
  SCManHandle, SvcHandle: SC_Handle;
  SS: TServiceStatus;
  NumberOfArgument: DWORD;
  ServiceArgVectors: PChar;
  lMachine: String;
  lTime: TDateTime;
Begin
  Result := 0;

//  If sMachine = '' Then
//    lMachine := _GetComputerName
//  Else
//    lMachine := sMachine;
//
//  // Open service manager handle.
//  SCManHandle := OpenSCManager(pChar(lMachine), Nil, SC_MANAGER_ALL_ACCESS);


  If sMachine = '' Then
    SCManHandle := OpenSCManager(nil, Nil, SC_MANAGER_ALL_ACCESS)
  Else
    SCManHandle := OpenSCManager(pChar(sMachine), Nil, SC_MANAGER_CONNECT);

//  SCManHandle := OpenSCManager(Nil, Nil, SC_MANAGER_ALL_ACCESS);
  If (SCManHandle > 0) Then
  Begin
    SvcHandle := OpenService(SCManHandle, pChar(sService), SERVICE_ALL_ACCESS);

    // if Service installed
    If (SvcHandle > 0) Then
    Begin
      // SS structure holds the service status (TServiceStatus);
      If (QueryServiceStatus(SvcHandle, SS)) Then
        Result := ss.dwCurrentState;

      // option to start this service
      If pStart And (Result <> SERVICE_RUNNING) Then
      Begin
        _CallDebugLog('_ServiceStatus :- About to start the service ' + sService);
        lTime := Now;

        While MilliSecondsBetween(Now, lTime) < RETRY_TIME Do
        Begin
          Application.ProcessMessages;

          NumberOfArgument := 0;
          ServiceArgVectors := '';
          // SS structure holds the service status (TServiceStatus);
          If (QueryServiceStatus(SvcHandle, SS)) Then
            Result := ss.dwCurrentState;

          If (Result = SERVICE_RUNNING) Then
            Break;

          WinSvc.StartService(SvcHandle, NumberOfArgument, ServiceArgVectors);
          //Sleep(400);
          Sleep(200);
          Application.ProcessMessages;
          Sleep(100);
          //_Delay(100);

          // SS structure holds the service status (TServiceStatus);
(*          If (QueryServiceStatus(SvcHandle, SS)) Then
            Result := ss.dwCurrentState;

          If (Result = SERVICE_RUNNING) Then
            Break;*)

        End; {while Result <> SERVICE_RUNNING do}
      End; {If pStart And (Result <> SERVICE_RUNNING) Then}

      If pStop Then
      Begin
        lTime := Now;
        _CallDebugLog('_ServiceStatus :- About to stop the service ' + sService);
        While MilliSecondsBetween(Now, lTime) < RETRY_TIME Do
        Begin
          Application.ProcessMessages;

//          NumberOfArgument := 0;
          ServiceArgVectors := '';

          If (QueryServiceStatus(SvcHandle, SS)) Then
            Result := ss.dwCurrentState;

          If (Result = SERVICE_STOPPED) Then
            Break;

          ControlService(SvcHandle, SERVICE_CONTROL_STOP, ss);
          Sleep(100);
          // SS structure holds the service status (TServiceStatus);
(*          If (QueryServiceStatus(SvcHandle, SS)) Then
            Result := ss.dwCurrentState;

          If (Result = SERVICE_STOPPED) Then
            Break;*)

        End; {while Result <> SERVICE_RUNNING do}
      End; {If pStop Then}

      CloseServiceHandle(SvcHandle);
    End;

    CloseServiceHandle(SCManHandle);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _ServiceExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _ServiceExists(Const sService: String; Const sMachine: String = ''):
  Boolean;
Var
  SCManHandle, SvcHandle: SC_Handle;
  lMachine: String;
Begin
  Result := False;
(*
  If sMachine = '' Then
    lMachine := _GetComputerName
  Else
    lMachine := sMachine;

  // Open service manager handle.
  //SCManHandle := OpenSCManager(pChar(lMachine), Nil, SC_MANAGER_CONNECT);
  SCManHandle := OpenSCManager(pChar(lMachine), Nil, SC_MANAGER_ALL_ACCESS);
//  SCManHandle := OpenSCManager(Nil, Nil, SC_MANAGER_ALL_ACCESS);
 *)

  If sMachine = '' Then
    SCManHandle := OpenSCManager(nil, Nil, SC_MANAGER_ALL_ACCESS)
  Else
    SCManHandle := OpenSCManager(pChar(sMachine), Nil, SC_MANAGER_CONNECT);

  If (SCManHandle > 0) Then
  Begin
    //SvcHandle := OpenService(SCManHandle, pChar(sService), SERVICE_QUERY_STATUS);
    SvcHandle := OpenService(SCManHandle, pChar(sService), SERVICE_ALL_ACCESS);
    // if Service installed
    Result := SvcHandle > 0;
    CloseServiceHandle(SvcHandle);
    CloseServiceHandle(SCManHandle);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _GetComputerName
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetComputerName: String;
Var
  lSize: Cardinal;
  lMac: pChar;
Begin
  Result := '';
  lSize := MAX_COMPUTERNAME_LENGTH;
  Getmem(lMac, lSize);
  Try
    GetComputerName(lMac, lSize);
    Result := StrPas(lMac);
  Except
    Result := '';
  End;
  FreeMem(lMac);
End;

{-----------------------------------------------------------------------------
  Procedure: _GetUSerName
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetUSerName: String;
Var
  lSize: Cardinal;
  lUser: pChar;
Begin
  Result := '';
  lSize := MAX_COMPUTERNAME_LENGTH;
  Getmem(lUser, lSize);
  Try
    GetUserName(lUser, lSize);
    Result := StrPas(lUser);
  Except
    Result := '';
  End;
  FreeMem(lUser);
End;

{-----------------------------------------------------------------------------
  Procedure: _LocalServiceRunning
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _LocalServiceRunning(Const sService: String): Boolean;
Begin
  Result := SERVICE_RUNNING = _ServiceStatus(sService);
End;

{-----------------------------------------------------------------------------
  Procedure: _DelDir
  Author:    vmoura

  remove a whole directory
-----------------------------------------------------------------------------}
Function _DelDir(Const dir: String): Boolean;
Var
  fos: TSHFileOpStruct;
Begin
  ZeroMemory(@fos, SizeOf(fos));
  With fos Do
  Begin
    wFunc := FO_DELETE;
    fFlags := FOF_SILENT Or FOF_NOCONFIRMATION;
    pFrom := PChar(dir + #0);
  End;
  Result := (0 = ShFileOperation(fos));
End;

{-----------------------------------------------------------------------------
  Procedure: _DelDirFiles
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _DelDirFiles(Const dir: String);
Var
  lRes: Integer;
  SearchRec: TSearchRec;
  lPath: String;
Begin
  lPath := IncludeTrailingPathDelimiter(dir);
  lRes := FindFirst(lPath + '*.*', faAnyFile, SearchRec);

  While lRes = 0 Do
  Begin
    _DelFile(lPath + SearchRec.Name);
    lRes := FindNext(SearchRec);
  End;

  FindClose(SearchRec);
End;

procedure _DeleteTempFiles;
begin
  with TSystemConf.Create do
  try
    _DelDirFiles(TempDir);
  finally  
    Free;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: _DelFile
  Author:    vmoura

  try to delete the file setting the attributes first
-----------------------------------------------------------------------------}
Function _DelFile(Const pFile: String): Boolean;
Begin
  // test is the file is readonly
  If FileIsReadOnly(pFile) Then
  Begin
    // change file attribute
    FileSetReadOnly(pFile, False);
    windows.SetFileAttributes(pChar(pFile), FILE_ATTRIBUTE_NORMAL);
  End;
  // try to delete this file
  Result := Windows.DeleteFile(pChar(pFile));
End;

{-----------------------------------------------------------------------------
  Procedure: _MoveDir
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _MoveDir(Const pFromDir, pToDir: String): Boolean;
Var
  fos: TSHFileOpStruct;
Begin
  ZeroMemory(@fos, SizeOf(fos));
  With fos Do
  Begin
    wFunc := FO_MOVE;
    fFlags := FOF_SILENT Or FOF_NOCONFIRMATION Or FOF_FILESONLY or FOF_NOCONFIRMMKDIR;
    pFrom := PChar(pFromDir + #0);
    pTo := PChar(pToDir);
  End;
  Result := (0 = ShFileOperation(fos));
End;

{-----------------------------------------------------------------------------
  Procedure: _CopyDir
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CopyDir(Const pFromDir, pToDir: String): Boolean;
Var
  fos: TSHFileOpStruct;
Begin
  ZeroMemory(@fos, SizeOf(fos));
  With fos Do
  Begin
    wFunc := FO_COPY;
    fFlags := FOF_SILENT Or FOF_NOCONFIRMATION Or FOF_NOCONFIRMMKDIR
      {or FOF_FILESONLY};
    pFrom := PChar(pFromDir + #0);
    pTo := PChar(pToDir);
  End;
  Result := (0 = ShFileOperation(fos));
End;

{-----------------------------------------------------------------------------
  Procedure: _fileCopy
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _fileCopy(Const SourceFile, TargetFile: String): Boolean;
Const
  BlockSize = 1024 * 16;
Var
  FSource, FTarget: Integer;
//  FFileSize       : Longint;
  BRead, Bwrite: Word;
  Buffer: Pointer;
Begin
  Result := False;
  FSource := FileOpen(SourceFile, fmOpenRead + fmShareDenyNone); { Open Source }
  If FSource >= 0 Then
  Try
    //FFileSize:=FileSeek(FSource, 0, soFromEnd);
    FTarget := FileCreate(TargetFile); { Open Target }
    Try
      getmem(Buffer, BlockSize);
      Try
        FileSeek(FSource, 0, soFromBeginning);
        Repeat
          BRead := FileRead(FSource, Buffer^, BlockSize);
          BWrite := FileWrite(FTarget, Buffer^, Bread);
        Until (Bread = 0) Or (Bread <> BWrite);
        If Bread = Bwrite Then
          Result := True;
      Finally
        freemem(Buffer, BlockSize);
      End;
      FileSetDate(FTarget, FileGetDate(FSource));
    Finally
      FileClose(FTarget);
    End;
  Finally
    FileClose(FSource);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _RenameDir
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _RenameDir(Const pOldDir, pNewDir: String): Boolean;
Var
  fos: TSHFileOpStruct;
Begin
  ZeroMemory(@fos, SizeOf(fos));
  With fos Do
  Begin
    wFunc := FO_RENAME;
    fFlags := FOF_FILESONLY Or FOF_ALLOWUNDO Or FOF_SILENT Or FOF_NOCONFIRMATION;
    pFrom := PChar(pOldDir + #0);
    pTo := PChar(pNewDir);
  End;
  Result := (0 = ShFileOperation(fos));
End;

{-----------------------------------------------------------------------------
  Procedure: _CreateDSRLockFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _CreateDSRLockFile(Const pDir: String);
Begin
  _CreateXmlFile(IncludeTrailingPathDelimiter(pDir) + cDSRLOCKFILE, 'Lock');
End;

{-----------------------------------------------------------------------------
  Procedure: _DeleteDSRLockFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _DeleteDSRLockFile(Const pDir: String);
Begin
  {check the directory and try deleting the lock file}
  If _DirExists(pDir) Then
  Try
    _DelFile(IncludeTrailingPathDelimiter(pDir) + cDSRLOCKFILE);
  Finally
    If FileExists(IncludeTrailingPathDelimiter(pDir) + cDSRLOCKFILE) Then
      DeleteFile(IncludeTrailingPathDelimiter(pDir) + cDSRLOCKFILE);
  End;
end;

{-----------------------------------------------------------------------------
  Procedure: _CheckDSRLockFileExists
  Author:    vmoura
-----------------------------------------------------------------------------}
function _CheckDSRLockFileExists(Const pDir: String): Boolean;
begin
  Result := False;
  if _DirExists(pDir) then
    Result := FileExists(IncludeTrailingPathDelimiter(pDir) + cDSRLOCKFILE)
end;

{-----------------------------------------------------------------------------
  Procedure: _CountFiles
  Author:    vmoura
-----------------------------------------------------------------------------}
function _CountFiles(const pDir: String) : Integer;
var
 lrec : TSearchRec;
begin
  Result := 0;
  if FindFirst(IncludeTrailingPathDelimiter(pDir) + '*.*', faAnyFile, lRec) = 0 then
  begin
    repeat
        // Exclude directories from the list of files.
        if ((lRec.Attr and faDirectory) <> faDirectory) then
                Inc(Result);
    until FindNext(lRec) <> 0;
  end; {if FindFirst('C:\*.*', faAnyFile, Rec) = 0 then}
  FindClose(lRec);
end;

{-----------------------------------------------------------------------------
  Procedure: _GetAllEnvVars
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetAllEnvVars(Const Vars: TStrings): Integer;
  {Copies all the environment variables available to the current process in the
  given string list, with each item in the string list representing one
  environment variable in the form NAME=VALUE. Returns the size of the
  environment block. If Vars=nil then the function simply returns the
  environment block size}
Var
  PEnvVars: PChar; // pointer to start of environment block
  PEnvEntry: PChar; // pointer to an environment string in block
Begin
  // Clear any list
  If Assigned(Vars) Then
    Vars.Clear;
  // Get reference to environment block for this process
  PEnvVars := GetEnvironmentStrings;
  If PEnvVars <> Nil Then
  Begin
    // We have a block: extract strings from it
    // Env strings are #0 separated and list ends with #0#0
    PEnvEntry := PEnvVars;
    Try
      While PEnvEntry^ <> #0 Do
      Begin
        If Assigned(Vars) Then
          Vars.Add(PEnvEntry);
        Inc(PEnvEntry, StrLen(PEnvEntry) + 1);
      End;
      // Calculate length of block
      Result := (PEnvEntry - PEnvVars) + 1;
    Finally
      // Dispose of the memory block
      Windows.FreeEnvironmentStrings(PEnvEntry);
    End;
  End
  Else
    // No block => zero length
    Result := 0;
End;

{-----------------------------------------------------------------------------
  Procedure: _GetApplicationPath
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetApplicationPath: String;
Var
  pBuffer: pChar;
Begin
  GetMem(pBuffer, MAX_PATH);
  Try
    GetModuleFileName(HInstance, pBuffer, MAX_PATH);
    Result := IncludeTrailingPathDelimiter(ExtractFilePath(String(pBuffer)));
  Finally
    FreeMem(pBuffer);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _GetApplicationName
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetApplicationName: String;
Var
  pBuffer: pChar;
Begin
  GetMem(pBuffer, MAX_PATH);
  Try
    GetModuleFileName(HInstance, pBuffer, MAX_PATH);
    Result := ExtractFileName(String(pBuffer));
    Result := Copy(Result, 1, Pos(ExtractFileExt(Result), Result) - 1);
  Finally
    FreeMem(pBuffer);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _BrowseComputer
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _BrowseComputer(DialogTitle: String; Var CompName: String;
  bNewStyle: Boolean): Boolean;
  // bNewStyle: If True, this code will try to use the "new"
  // BrowseForFolders UI on Windows 2000/XP
Const
  BIF_USENEWUI = 28;
Var
  BrowseInfo: TBrowseInfo;
  ItemIDList: PItemIDList;
  ComputerName: Array[0..MAX_PATH] Of Char;
  Title: String;
  WindowList: Pointer;
  ShellMalloc: IMalloc;
Begin
  Result := False;
  If Succeeded(SHGetSpecialFolderLocation(Application.Handle, CSIDL_NETWORK,
    ItemIDList)) Then
  Begin
    Try
      FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
      BrowseInfo.hwndOwner := Application.Handle;
      BrowseInfo.pidlRoot := ItemIDList;
      BrowseInfo.pszDisplayName := ComputerName;
      Title := DialogTitle;
      BrowseInfo.lpszTitle := PChar(Pointer(Title));
      If bNewStyle Then
        BrowseInfo.ulFlags := BIF_BROWSEFORCOMPUTER Or BIF_USENEWUI
      Else
        BrowseInfo.ulFlags := BIF_BROWSEFORCOMPUTER;
      WindowList := DisableTaskWindows(0);
      Try
        Result := SHBrowseForFolder(BrowseInfo) <> Nil;
      Finally
        EnableTaskWindows(WindowList);
      End;
      If Result Then
        CompName := ComputerName;
    Finally
      If Succeeded(SHGetMalloc(ShellMalloc)) Then
        ShellMalloc.Free(ItemIDList);
    End;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _CalcCRC32
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _CalcCRC32(p: Pointer; ByteCount: DWORD; Var CRCValue: DWORD);
Var
  i: DWORD;
  q: ^BYTE;
Begin
  q := p;
  For i := 0 To ByteCount - 1 Do
  Begin
    CRCvalue := (CRCvalue Shr 8) Xor
      TableCRC32[q^ Xor (CRCvalue And $000000FF)];
    Inc(q)
  End
End {CalcCRC32};

{-----------------------------------------------------------------------------
  Procedure: _CalcStringCRC32
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CalcStringCRC32(Const s: String; Out CRC32: DWORD): Boolean;
Var
  CRC32Table: DWORD;
Begin
  // Verify the table used to compute the CRCs has not been modified.
  Result := True;
  CRC32Table := $FFFFFFFF;
  _CalcCRC32(Addr(TableCRC32[0]), SizeOf(TableCRC32), CRC32Table);
  CRC32Table := Not CRC32Table;

  If CRC32Table <> $6FCF9E13 Then
    Result := false
  Else
  Begin
    CRC32 := $FFFFFFFF; // To match PKZIP
    If Length(s) > 0 Then // Avoid access violation in D4
      _CalcCRC32(Addr(s[1]), Length(s), CRC32);
    CRC32 := Not CRC32; // To match PKZIP
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _CalcFileCRC32
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _CalcFileCRC32(Const FromName: String; Var CRCvalue: DWORD;
  Var TotalBytes: TInteger8; Var error: Word);
Var
  Stream: TMemoryStream;
Begin
  error := 0;
  CRCValue := $FFFFFFFF;
  Stream := TMemoryStream.Create;
  Try
    Try
      Stream.LoadFromFile(FromName);
      If Stream.Size > 0 Then
        _CalcCRC32(Stream.Memory, Stream.Size, CRCvalue)
    Except
      On E: EReadError Do
        error := 1
    End;
    CRCvalue := Not CRCvalue
  Finally
    FreeAndNil(Stream)
  End;
End;

{ _GetDataTransportDetails returns a record structure containing the details
  of the importer and exporter for the specified table. TableID should be one
  of the constants defined in uConsts, such as cCUSTTABLE. }
Function _GetDataTransportDetails(TableID: Integer): TDataTransportDetails;
Var
  i: Integer;
Begin
  Result.ID := 0;
  For i := Low(DataTransportList) To High(DataTransportList) Do
  Begin
    If (DataTransportList[i].ID = TableID) Then
    Begin
      Result := DataTransportList[i];
      break;
    End
  End;
End;

{ Returns a descriptive error message for the specified error number. }
Function _GetErrorMessage(ErrorNumber: Integer): String;
Var
  i: Integer;
Begin
  Result := 'Unrecognised error';
  For i := Low(ErrorDetails) To High(ErrorDetails) Do
    If (ErrorDetails[i].ErrNo = ErrorNumber) Then
    Begin
      Result := ErrorDetails[i].Msg;
      break;
    End;
End;

{-----------------------------------------------------------------------------
  Procedure: _GetStatusMessate
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetStatusMessage(StatusNumber: Integer): String;
Var
  i: Integer;
Begin
  Result := '';
  For i := Low(StatusDetails) To High(StatusDetails) Do
    If (StatusDetails[i].StatusNro = StatusNumber) Then
    Begin
      Result := StatusDetails[i].Msg;
      break;
    End; {If (StatusDetails[i].StatusNro = StatusNumber) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: _GetProductName
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetProductName(ProductNro: Integer): String;
Var
  i: Integer;
Begin
  Result := '';
  For i := Low(ProductName) To High(ProductName) Do
    If (ProductName[i].ProductNro = ProductNro) Then
    Begin
      Result := ProductName[i].Name;
      break;
    End; {If (ApplicationName[i].ApplicationNro = AppNro) Then}
End;

{ Check the company code to see if it is a) set and b) excel friendly }
Function _InvalidCompCode(Const pCode: String): Boolean;
Var
  I: SmallInt;
Begin
  Result := (Trim(pCode) = '');

  If (Not Result) Then
  Begin
    { Have some characters - make sure there not all numeric }
    For I := 1 To Length(pCode) Do
    Begin
      If (pCode[I] In ['a'..'z', 'A'..'Z']) Then
      Begin
        Result := False;
        Break;
      End { If }
      Else
        Result := True;
    End; { For }
  End; { If }
End;

{-----------------------------------------------------------------------------
  Procedure: _SystrayRunning
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _SystrayRunning: Boolean;
Begin
  Result := False;
  Try
    If (FindWindow('Shell_TrayWnd', Nil) <> 0) Then
      Result := True;
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _GetExplorerUser
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetExplorerUser: String;
Var
  explorerProcessHandle: THandle;
  tokenhandle: THandle;
  puser: PSidAndAttributes;
  infoLen: DWORD;
  userName, domainName: Array[0..256] Of char;
  userNameLen, domainNameLen: DWORD;
  use: Sid_Name_Use;

  Function OpenProcessHandle(Const process: String): THandle;
  Var
    buffer, pid: PDWORD;
    bufLen, cbNeeded: DWORD;
    hp: THandle;
    fileName: Array[0..256] Of char;
    i: Integer;
  Begin
    result := 0;
    bufLen := 65536;
    GetMem(buffer, bufLen);
    Try
      If EnumProcesses(buffer, bufLen, cbNeeded) Then
      Begin
        pid := buffer;
        For i := 0 To cbNeeded Div sizeof(DWORD) - 1 Do
        Begin
          hp := OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION, False,
            pid^);
          If hp <> 0 Then
          Try
            If (GetModuleBaseName(hp, 0, fileName, sizeof(fileName)) > 0) And
              (CompareText(fileName, process) = 0) Then
            Begin
              result := hp;
              break
            End
          Finally
            If result = 0 Then
              CloseHandle(hp)
          End;

          Inc(pid)
        End
      End
    Finally
      FreeMem(buffer)
    End
  End;

Begin
  result := '';
  explorerProcessHandle := OpenProcessHandle('explorer.exe');
  If explorerProcesshandle <> 0 Then
  Try
    If OpenProcessToken(explorerProcessHandle, TOKEN_QUERY, tokenHandle) Then
    Try
      FillChar(username, SizeOf(uSername), 0);
      GetMem(puser, 65536);
      Try
        If GetTokenInformation(tokenHandle, TokenUser, puser, 65536, infoLen)
          Then
        Begin
          If LookupAccountSID(Nil, puser^.Sid, userName, userNameLen,
            domainName, domainNameLen, use) Then
            result := userName
        End
      Finally
        FreeMem(puser)
      End
    Finally
      CloseHandle(tokenHandle)
    End
  Finally
    CloseHandle(explorerProcessHandle)
  End
End;

{-----------------------------------------------------------------------------
  Procedure: _IsLogged
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _IsLogged: Boolean;
Begin
  Result := _SystrayRunning Or (Trim(_GetExplorerUser) <> '');
End;

{-----------------------------------------------------------------------------
  Procedure: _IsValidDSRVersion
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _IsValidDSRVersion(Const pV1, pV2: String): Boolean;
Begin
  {v5.71}
  Result := Lowercase(Copy(Trim(pV1), 1, 5)) = Lowercase(Copy(Trim(pV2), 1, 5))
End;

{-----------------------------------------------------------------------------
  Procedure: _LockControl
  Author:    vmoura

    avoid flicking every time a user click one node... It is working better than
  lockwindowupdate wich was delaying the node for some msec...

-----------------------------------------------------------------------------}
Procedure _LockControl(pControl: TWinControl; pLock: Boolean);
Begin
  If (pControl = Nil) Or (pControl.Handle = 0) Then
    Exit;

  If pLock Then
    SendMessage(pControl.Handle, WM_SETREDRAW, 0, 0)
  Else
  Begin
    SendMessage(pControl.Handle, WM_SETREDRAW, 1, 0);
    RedrawWindow(pControl.Handle, Nil, 0, RDW_ERASE Or RDW_FRAME Or RDW_INVALIDATE
      Or RDW_ALLCHILDREN);
  End; {else begin}
End; {Procedure _LockControl(pControl: TWinControl; pLock: Boolean);}


{-----------------------------------------------------------------------------
  Procedure: _GetEnterpriseSystemDir
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetEnterpriseSystemDir: String;
Begin
  Result := '';
  With TRegistry.Create Do
  Try
    RootKey := VAOEntDirRootKey;
    OpenKey(VAOEntDirKey, True);

    Try
      Result := ReadString(VAOEntName);
    Except
      On e: exception Do
        _LogMSG('_GetEnterpriseSystemDir :- Error reading from registry. Error: '
          + e.Message);
    End; {try}
  Finally
    Free;
  End; {With TRegistry.Create Do}
End;

{-----------------------------------------------------------------------------
  Procedure: _SetEnterpriseDir
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _SetEnterpriseDir(Const ADir: AnsiString);
Begin
  With TRegistry.Create Do
  Try
    LazyWrite := False;
    RootKey := VAOEntDirRootKey;
    OpenKey(VAOEntDirKey, True);

    Try
      WriteString(VAOEntName, ADir);
    Except
      On e: exception Do
        _LogMSG('_SetEnterpriseDir :- Error writing to registry. Error: ' +
          e.Message);
    End;
  Finally
    Free;
  End;
End; {Procedure _SetEnterpriseDir(Const ADir: AnsiString);}

{-----------------------------------------------------------------------------
  Procedure: _GetMailInfoFromStrings
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetMailInfoFromStrings(pMsg: TStrings): TMessageInfo;
Begin
  Result := Nil;
  If pMsg <> Nil Then
    If pMsg.Count > 0 Then
      If pMsg.Objects[0] <> Nil Then
        If pMsg.Objects[0] Is TMessageInfo Then
          Result := TMessageInfo(pMsg.Objects[0]);
End;

{-----------------------------------------------------------------------------
  Procedure: _ChangeChar
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _ChangeChar(Const pText, pOldChar, pNewChar: String): String;
Begin
  If Pos(pOldChar, pText) > 0 Then
    Result := StringReplace(pText, pOldChar, pNewChar, [rfReplaceAll])
  Else
    Result := pText;
End;

{-----------------------------------------------------------------------------
  Procedure: _ChangeAmpersand
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _ChangeAmpersand(Const pText: String): String;
Begin
  Result := _ChangeChar(pText, '&', '&&');
End;

// -----------------------------------------------------------------------------
// The following is a copy of the routine from \ENTRPRSE\COMTK\SECCODES.PAS,
// amended to work without making used of initialisation, as this appears to
// cause problems with re-opened plug-ins.
// -----------------------------------------------------------------------------
Procedure EncodeOpCode(Const OpCode: Byte; Var Long1, Long2, Long3: LongInt);
// Converts an OpCode into three encoded Long Integers which can be
// internally validated and decoded using the DecodeOpCode in SECCODES.PAS.

  Function CalcDateVal: Byte;
  Var
    DateStr: ShortString;
  Begin
    // Format date into a string
    DateStr := FormatDateTime('DD/MM/YYYY', Now);

    // Sum the numbers within that date string
    Result := StrToInt(DateStr[1]) + // D
      StrToInt(DateStr[2]) + // D
      StrToInt(DateStr[4]) + // M
      StrToInt(DateStr[5]) + // M
      StrToInt(DateStr[7]) + // Y
      StrToInt(DateStr[8]) + // Y
      StrToInt(DateStr[9]) + // Y
      StrToInt(DateStr[10]); // Y
  End;

Type
  RemapType = Packed Array[1..3, 1..4] Of Byte;
Var
  LongArray: Packed Array[1..3] Of LongInt;
  ByteArray: ^RemapType;
  TmpByte: Byte;
Begin { EncodeOpCode }
  If (OpCode <= 220) Then
  Begin
    // Overlay ByteArray on top of LongArray
    ByteArray := @LongArray;

    Randomize;

    // LongArray[1]
    ByteArray^[1, 1] := Random(255); // Rnd1
    ByteArray^[1, 2] := Random(200); // Rnd2
    ByteArray^[1, 3] := Random(255); // Rnd3
    ByteArray^[1, 4] := Random(30) + OpCode; // Rnd4 + OpCode

    // LongArray[2]
    ByteArray^[2, 1] := ByteArray^[1, 2] + CalcDateVal; // Rnd2 + DateVal
    ByteArray^[2, 2] := ByteArray^[1, 1] Or ByteArray^[1, 3]; // Rnd1 OR Rnd3
    ByteArray^[2, 3] := ByteArray^[1, 2] And ByteArray^[1, 4]; // Rnd2 AND OpCode
    ByteArray^[2, 4] := ByteArray^[1, 4] - OpCode; // Rnd4

    // LongArray[3]
    ByteArray^[3, 1] := Not (ByteArray^[1, 3] And ByteArray^[1, 4]);
      // Not (Rnd3 Or (Rnd4 + OpCode))

    // HM 29/08/01: Moved calculation into local byte as compiler as using integer
    //              which was causing a range check error
    TmpByte := ByteArray^[1, 4] - ByteArray^[2, 4];
    ByteArray^[3, 2] := Not TmpByte; // NOT (OpCode)

    ByteArray^[3, 3] := ByteArray^[1, 1] And ByteArray^[1, 3]; // Rnd1 AND Rnd3
    ByteArray^[3, 4] := ByteArray^[3, 1] And ByteArray^[3, 2] And ByteArray^[3,
      3];

    // Return Longs in parameters
    Long1 := LongArray[1];
    Long2 := LongArray[2];
    Long3 := LongArray[3];
  End { If }
  Else
    Raise Exception.Create('Invalid OpCode ' + IntToStr(OpCode));
End; { EncodeOpCode }

//----------------------------------------------------------------------------

Function SetDecimalSeparator(NewSeparator: Char): Char;
{ Sets Delphi's DecimalSeparator global variable, and returns the previous
  value of it. }
Begin
  Result := DecimalSeparator;
  DecimalSeparator := NewSeparator;
End;

// -----------------------------------------------------------------------------

Function RightJustify(Text: String; WithChar: Char; ToLength: Byte): String;
Begin
  Result := StringOfChar(WithChar, ToLength - Length(Text)) + Text;
End;

// -----------------------------------------------------------------------------

Function LeftJustify(Text: String; WithChar: Char; ToLength: Byte): String;
Begin
  Result := Text + StringOfChar(WithChar, ToLength - Length(Text));
End;

// -----------------------------------------------------------------------------

End.

