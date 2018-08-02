{-----------------------------------------------------------------------------
 Unit Name: uDSRUtil
 Author:    vmoura
 Purpose:

 allow systems to manipualte DSR files

 History:

-----------------------------------------------------------------------------}
Unit uDSRUtil;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, DSRUtility_TLB, StdVcl;

Type
  TDSRUtil = Class(TAutoObject, IDSRUtil)
  Protected
    Function Compress(Const pFileIn, pFileOut: WideString): WordBool; Safecall;
    Function EnCrypt(Const pFileIn, pFileOut: WideString): WordBool; Safecall;
    Function Decompress(Const pFileIn, pFileOut: WideString): WordBool;
      Safecall;
    Function Decrypt(Const pFileIn, pFileOut: WideString): WordBool; Safecall;
    Function GetXml(Const pFileName: WideString): WideString; Safecall;
    Function CreateDSRFiles(Const pHeader: DSRFileHeader; Const pFileName,
      pXML: WideString): WideString; Safecall;
    Function GetDBServer: WideString; Safecall;
    Function IsCISTest: WordBool; Safecall;
  End;

Implementation

Uses ComServ, Sysutils, Classes, IniFiles, uAdoDSR,
  uCommon, uConsts, uDSRSettings, uSystemConfig,
  uDSRFileFunc
  ;

{-----------------------------------------------------------------------------
  Procedure: Compress
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRUtil.Compress(Const pFileIn, pFileOut: WideString): WordBool;
Begin
  Result := _CompressFile(pFileIn, pFileOut);
End;

{-----------------------------------------------------------------------------
  Procedure: Crypt
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRUtil.EnCrypt(Const pFileIn, pFileOut: WideString): WordBool;
Begin
  Result := _EncryptFile(pFileIn, pFileOut);
End;

{-----------------------------------------------------------------------------
  Procedure: Decompress
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRUtil.Decompress(Const pFileIn, pFileOut: WideString): WordBool;
Begin
  Result := _DeCompressFile(pFileIn, pFileOut);
End;

{-----------------------------------------------------------------------------
  Procedure: Decrypt
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRUtil.Decrypt(Const pFileIn, pFileOut: WideString): WordBool;
Begin
  Result := _DecryptFile(pFileIn, pFileOut);
End;

{-----------------------------------------------------------------------------
  Procedure: GetXml
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRUtil.GetXml(Const pFileName: WideString): WideString;
Begin
  Result := '';

  Try
    Result := _GetXmlFromFile(pFileName);
  Except
    On E: exception Do
      _LogMSG('TDSRUtil.GetXml :- An exception has occurred. Error: ' +
        e.message);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: CreateDSRFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRUtil.CreateDSRFiles(Const pHeader: DSRFileHeader;
  Const pFileName, pXML: WideString): WideString;
Var
  lHeader: TDSRFileHeader;
  lFiles: TStringList;
Begin
  lFiles := Nil;
  FillChar(lHeader, SizeOf(TDSRFileHeader), 0);
  Result := '';
  If Assigned(pHeader) Then
  Begin
    With pHeader Do
    Begin
(*      if Trim(StartChar) <> '' then
        lHeader.StartChar := Char(StartChar[1])
      else
        lHeader.StartChar := '|';*)

      lHeader.BatchId := Copy(BatchId, 1, 38);
      lHeader.Version := Version;
      lHeader.ExCode := ExCode;
      lHeader.CompGuid := Copy(CompGuid, 1, 38);
      lHeader.CheckSum := CheckSum;
      lHeader.Order := Order;
      lHeader.Total := Total;
      lHeader.Split := Split;
      lHeader.SplitTotal := SplitTotal;
      lHeader.SplitCheckSum := SplitCheckSum;
      lHeader.Flags := Flags;
      lHeader.Mode := Ord(Mode);
(*      if Trim(EndChar) <> '' then
        lHeader.EndChar := Char(EndChar[1])
      else
        lHeader.EndChar := '|';*)
    End;

    Try
      lFiles := _CreateDSRFile(lHeader, pFileName, pXML);
    Finally
      If Assigned(lFiles) Then
        Result := lFiles.CommaText;
    End;

    If Assigned(lFiles) Then
      lFiles.Free;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: GetDBServer
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRUtil.GetDBServer: WideString;
Begin
  REsult := _DSRGetDBServer;
End;

{-----------------------------------------------------------------------------
  Procedure: IsCISTest
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRUtil.IsCISTest: WordBool;
(*Var
  lDb: TADODSR;*)
Begin
(*  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
  End;

  Result := False;

  If Assigned(lDb) Then
  Begin
    If lDb.Connected Then
      Result := lDb.GetSystemValue(cUSECISTESTPARAM) = '1';
    lDb.Free;
  End;*)
End;

Initialization
  TAutoObjectFactory.Create(ComServer, TDSRUtil, Class_DSRUtil,
    ciMultiInstance, tmApartment);
End.

