{*********************************************************}
{*                   APROREG.PAS 4.03                    *}
{*      Copyright (c) TurboPower Software 1996-2002      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit APROReg;

interface

uses
{$IFDEF Delphi6}
  DesignIntf,
  DesignEditors;
{$ELSE}
  DsgnIntf;
{$ENDIF}

{ Constant declarations for IDE palette tab names }

const
  APROTabName     = 'APRO';
  APROFaxTabName  = 'APRO Fax';
  APROTelephonyTabName = 'APRO Telephony';

procedure Register;

implementation

{$R APROREG.DCR}

uses
  { RTL/VCL Units }
  Classes, SysUtils, Windows,

  { Standard Units }
  AdPort,      {TApdComPort}
  AdProtcl,    {TApdProtocol}
  AdPStat,     {TApdProtocolStatus}
  AdStatLt,    {TApdSLController, TApdStatusLight}
  AdWnPort,    {TApdWinsockPort}
  AdSelCom,    {port selection dialog}
  AdPacket,    {TApdDataPacket}
  AdPropEd,    {design-time property editors}
  AdPager,     {TApdTapPager, TApdSNPPPager, TApdSMSPager}
  AdGSM,       {TApdGSMPhone}  { BCB3 can't create this header }
  AdFtp,       {TApdFTPClient}
  AdScript,    {TApdScript}
  AdTrmEmu,    {TAdVT100Emulator, TAdTTYEmulator}
  AdRas,       {TApdRasDialer}
  AdRStat,     {TApdRasStatus}
  AdStMach,    {TApdStateMachine, TApdState}
  AdMdm,       {TAdModem}

  { Fax Units }
  AdFaxCvt,    {TApdFaxConverter, TApdFaxUnpacker}
  AdFView,     {TApdFaxViewer}
  AdFax,       {TApdSendFax, TApdReceiveFax}
  AdFStat,     {TApdFaxStatus}
  AdFaxPrn,    {TApdFaxPrinter}
  AdFPStat,    {TApdFaxPrinterStatus}
  AdFaxCtl,    {TApdFaxDriverInterface}
  AdFaxSrv,    {TApdFaxServer, TApdFaxServerManager, TApdFaxClient}

  { Telephony Units }
  AdTapi,      {TApdTapiDevice}
  AdTStat,     {TApdTapiStatus}
  AdPEditT,    {select device dialog}
  AdSapiEn,    {TApdSapiEngine}
  AdSapiPh,    {TApdSapiPhone}
  AdVoIP;      {IP Telephony components}


procedure Register;
begin
  { Register standard components }
  RegisterComponents(APROTabName,
                     [TApdComPort,
                      TApdWinsockPort,
                      TApdRasDialer,
                      TApdRasStatus,
                      TApdFtpClient,
                      TApdFtpLog,
                      TApdDataPacket,
                      TApdScript,
                      TApdStateMachine,
                      TApdState,
                      TAdModem,
                      TAdModemStatus,
                      TApdSLController,
                      TApdStatusLight,
                      TApdProtocol,
                      TApdProtocolLog,
                      TApdProtocolStatus,
                      TApdTAPPager,
                      TApdSNPPPager,
                      TApdGSMPhone,  
                      TApdPagerLog,
                      TAdTerminal,
                      TAdTTYEmulator,
                      TAdVT100Emulator]);

  { Register Telephony components }
  RegisterComponents(APROTelephonyTabName,
                     [TApdTapiDevice,
                      TApdTapiStatus,
                      TApdTapiLog,
                      TApdSapiEngine,
                      TApdSapiPhone,
                      TApdVoIP]);

  { Register Fax Components }
  RegisterComponents(APROFaxTabName,
                     [TApdFaxConverter,
                      TApdFaxUnpacker,
                      TApdFaxViewer,
                      TApdReceiveFax,
                      TApdSendFax,
                      TApdFaxStatus,
                      TApdFaxLog,
                      TApdFaxPrinter,
                      TApdFaxPrinterStatus,
                      TApdFaxPrinterLog,
                      TApdFaxDriverInterface,
                      TApdFaxServer,
                      TApdFaxServerManager,
                      TApdFaxClient]);

end;

end.
