unit uDSR;

interface

uses DB, DBClient, Classes, Windows, SysUtils, Dialogs, RemotingClientLib_TLB;

const GENERIC_FAIL: LongWord = 10000;

type
  TDSR = class
  private
  protected
  public
    class function DSR_Export(const MachineName: WideString; PortNumber: Integer; pCompany: LongWord;
                        pGuid: TGUID; const pSubj: WideString; const pFrom: WideString;
                        const pTo: WideString; const pMsgBody: WideString;
                        const pParam1: WideString; const pParam2: WideString; pPackageId: LongWord): LongWord;
    class function DSR_Import(const MachineName: WideString; PortNumber: Integer; pCompany: LongWord;
                        pGuid: TGUID; pPackageId: LongWord): LongWord;
    class function DSR_GGW_PreparePacket(const MachineName: WideString; PortNumber: Integer;
                                   pCompany: LongWord; pGuid: TGUID; const pSubj: WideString;
                                   const pFrom: WideString; const pTo: WideString;
                                   const pMsgBody: WideString; pOrder: Smallint; pTotal: Smallint;
                                   const pXml: WideString; const pXsl: WideString;
                                   const pIRMark: WideString): LongWord;
    class function DSR_GGW_SendPacket(const MachineName: WideString; PortNumber: Integer;
                                pCompany: LongWord; pGuid: TGUID; const pIRMark: WideString): LongWord;
    class function DSR_DeleteInboxMessage(const MachineName: WideString; PortNumber: Integer;
                                    pCompany: LongWord; pGuid: TGUID): LongWord;
    class function DSR_DeleteOutboxMessage(const MachineName: WideString; PortNumber: Integer;
                                     pCompany: LongWord; pGuid: TGUID): LongWord;
    class function DSR_GetInboxMessages(const MachineName: WideString; PortNumber: Integer;
                                  pCompany: LongWord; pPackageId: LongWord; pStatus: Shortint;
                                  pDate: TDateTime; pMaxRecords: LongWord; out pMessages: OleVariant): LongWord;
    class function DSR_GetOutboxMessages(const MachineName: WideString; PortNumber: Integer;
                                   pCompany: LongWord; pPackageId: LongWord; pStatus: Shortint;
                                   pDate: TDateTime; pMaxRecords: LongWord;
                                   out pMessages: OleVariant): LongWord;
    class function DSR_NewInboxMessage(const MachineName: WideString; PortNumber: Integer;
                                 pMaxRecords: LongWord; out pMessages: OleVariant): LongWord;
    class function DSR_TotalOutboxMessages(const MachineName: WideString; PortNumber: Integer;
                                     pCompany: LongWord; out pMsgCount: LongWord): LongWord;
    class function DSR_TranslateErrorCode(const MachineName: WideString; PortNumber: Integer;
                                    pErrorCode: LongWord): WideString;
    class function DSR_GGW_GetPending(const MachineName: WideString; PortNumber: Integer;
                                pCompany: LongWord; pDate: TDateTime; pMaxRecords: LongWord;
                                out pMessages: OleVariant): LongWord;
    class function DSR_ResendOutboxMessage(const MachineName: WideString; PortNumber: Integer;
                                     pGuid: TGUID): LongWord;
    class function DSR_SetExportPackage(const MachineName: WideString; PortNumber: Integer;
                                  const pDescription: WideString; pGuid: TGUID;
                                  const pXml: WideString; const pXsl: WideString;
                                  const pXsd: WideString; pUserReference: Word): LongWord;
    class function DSR_SetImportPackage(const MachineName: WideString; PortNumber: Integer;
                                  const pDescription: WideString; pGuid: TGUID;
                                  const pXml: WideString; const pXsl: WideString;
                                  const pXsd: WideString; pUserReference: Word): LongWord;
    class function DSR_GetExportPackages(const MachineName: WideString; PortNumber: Integer;
                                   out pPackage: OleVariant): LongWord;
    class function DSR_GetImportPackages(const MachineName: WideString; PortNumber: Integer;
                                   out pPackage: OleVariant): LongWord;
    class function DSR_DeleteExportPackage(const MachineName: WideString; PortNumber: Integer;
                                     pID: LongWord): LongWord;
    class function DSR_DeleteImportPackage(const MachineName: WideString; PortNumber: Integer;
                                     pID: LongWord): LongWord;
  end;

implementation

{ TDSR }

class function TDSR.DSR_Export(const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; pGuid: TGUID; const pSubj, pFrom,
  pTo, pMsgBody, pParam1, pParam2: WideString; pPackageId: LongWord): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_Export(MachineName, PortNumber,pCompany, pGuid, pSubj, pFrom, pTo, pMsgBody, pParam1, pParam2, pPackageId);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_TranslateErrorCode(const MachineName: WideString;
  PortNumber: Integer; pErrorCode: LongWord): WideString;
var
  dsrCaller: IDSRClient;
begin
  Result := '';

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_TranslateErrorCode(MachineName, PortNumber, pErrorCode);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_GetOutboxMessages(const MachineName: WideString;
  PortNumber: Integer; pCompany, pPackageId: LongWord; pStatus: Shortint;
  pDate: TDateTime; pMaxRecords: LongWord; out pMessages: OleVariant): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_GetOutboxMessages(MachineName, PortNumber, pCompany, pPackageId, pStatus, pDate, pMaxRecords, pMessages);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_GGW_SendPacket(const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; pGuid: TGUID;
  const pIRMark: WideString): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_GGW_SendPacket(MachineName, PortNumber, pCompany, pGuid, pIRMark);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_NewInboxMessage(const MachineName: WideString;
  PortNumber: Integer; pMaxRecords: LongWord;
  out pMessages: OleVariant): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_NewInboxMessage(MachineName, PortNumber, pMaxRecords, pMessages);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_GetImportPackages(const MachineName: WideString;
  PortNumber: Integer; out pPackage: OleVariant): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_GetImportPackages(MachineName, PortNumber, pPackage);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_DeleteExportPackage(const MachineName: WideString;
  PortNumber: Integer; pID: LongWord): LongWord;
var
  dsrCaller: IDSRClient;
begin
   Result := GENERIC_FAIL;

 // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_DeleteExportPackage(MachineName, PortNumber, pID);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_GetInboxMessages(const MachineName: WideString;
  PortNumber: Integer; pCompany, pPackageId: LongWord; pStatus: Shortint;
  pDate: TDateTime; pMaxRecords: LongWord; out pMessages: OleVariant): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

 // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_GetInboxMessages(MachineName, PortNumber, pCompany, pPackageId, pStatus, pDate, pMaxRecords, pMessages);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_Import(const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; pGuid: TGUID;
  pPackageId: LongWord): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_Import(MachineName, PortNumber, pCompany, pGuid, pPackageId);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_DeleteOutboxMessage(const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; pGuid: TGUID): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_DeleteOutboxMessage(MachineName, PortNumber, pCompany, pGuid);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_ResendOutboxMessage(const MachineName: WideString;
  PortNumber: Integer; pGuid: TGUID): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_ResendOutboxMessage(MachineName, PortNumber, pGuid);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_DeleteImportPackage(const MachineName: WideString;
  PortNumber: Integer; pID: LongWord): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_DeleteImportPackage(MachineName, PortNumber, pID);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_SetExportPackage(const MachineName: WideString;
  PortNumber: Integer; const pDescription: WideString; pGuid: TGUID; const pXml,
  pXsl, pXsd: WideString; pUserReference: Word): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_SetExportPackage(MachineName, PortNumber, pDescription, pGuid, pXml, pXsl, pXsd, pUserReference);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_DeleteInboxMessage(const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; pGuid: TGUID): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_DeleteInboxMessage(MachineName, PortNumber, pCompany, pGuid);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_GGW_PreparePacket(const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; pGuid: TGUID; const pSubj, pFrom,
  pTo, pMsgBody: WideString; pOrder, pTotal: Smallint; const pXml, pXsl,
  pIRMark: WideString): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_GGW_PreparePacket(MachineName, PortNumber, pCompany, pGuid, pSubj, pFrom, pTo, pMsgBody, pOrder, pTotal, pXml, pXsl, pIRMark);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_GGW_GetPending(const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; pDate: TDateTime;
  pMaxRecords: LongWord; out pMessages: OleVariant): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_GGW_GetPending(MachineName, PortNumber, pCompany, pDate, pMaxRecords, pMessages);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_TotalOutboxMessages(const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; out pMsgCount: LongWord): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_TotalOutboxMessages(MachineName, PortNumber, pCompany, pMsgCount);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_SetImportPackage(const MachineName: WideString;
  PortNumber: Integer; const pDescription: WideString; pGuid: TGUID; const pXml,
  pXsl, pXsd: WideString; pUserReference: Word): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_SetImportPackage(MachineName, PortNumber, pDescription, pGuid, pXml, pXsl, pXsd, pUserReference);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

class function TDSR.DSR_GetExportPackages(const MachineName: WideString;
  PortNumber: Integer; out pPackage: OleVariant): LongWord;
var
  dsrCaller: IDSRClient;
begin
  Result := GENERIC_FAIL;

  // Create an instance of the remoting client object
  dsrCaller := CoDSRClient.Create() as IDSRClient;

  try
    Result := dsrCaller.DSR_GetExportPackages(MachineName, PortNumber, pPackage);
  except on E: Exception do
    ShowMessage('An exception has occurred:'+#13#13+ E.Message);
  end;
end;

end.
