unit HandlerU;

{ prutherford440 15:10 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }
{Template for use in BACS export dlls}
interface

Uses CustWinU, CustAbsU, ChainU;


{const
  DefaultPayFileName = {'ExchBacs.imp';}
{  DefaultRecFileName = {'ExchDDeb.imp';}


{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;


implementation

Uses Dialogs, SysUtils, Forms, Classes, ExWrap, MultIni, ExpObj, HandlAbn, BacConst,
     EntLicence;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

  BacsHook = EnterpriseBase + 2050;

var
  NeedToReadIni : Boolean;



{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
var
  i : integer;
  Released : Boolean;
Begin

  { Enable Hooks and Set About Message here }
  with CustomHandlers do
  begin
{    AddAboutString ('Multi-BACS Custom Hook.');
    AddAboutString ('Creates export file in selected format.');

    AddAboutString ('Copyright Exchequer Software Ltd. 1986 - 2000.');
    AddAboutString ('Version: 1.00');}

    if not (EnterpriseLicence.elProductType in [ptLITECust, ptLITEAcct]) then
    begin
      Released := EnterpriseLicence.elModules[modEBanking] <> mrNone;
    end
    else
      Released := True;

    if Released then
    begin
      CustomOn := True;
      MakeBacsAboutText(exMultiBacs);
      for i := 0 to AboutText.Count - 1 do
        AddAboutString(AboutText[i]);


      SetHandlerStatus(BacsHook, 1, EventEnabled);
      SetHandlerStatus(BacsHook, 10, EventEnabled);
      SetHandlerStatus(BacsHook, 20, EventEnabled);
      SetHandlerStatus(BacsHook, 30, EventEnabled);
      SetHandlerStatus(BacsHook, 31, EventEnabled);
      SetHandlerStatus(BacsHook, 50, EventEnabled);
      SetHandlerStatus(BacsHook, 60, EventEnabled);
      SetHandlerStatus(BacsHook, 70, EventEnabled);
      SetHandlerStatus(BacsHook, 80, EventEnabled);
    end;
  end;
  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
var
  DefaultOutFileName : string;
  TempExportObj : TExportObject;
  BankGLCode : longint;
Begin
  { Handle Hook Events here }
  with EventData do
  begin

    if (WinID = BacsHook)
    and (HandlerID in [1,10,20,30,31,50,60,70,80])  //NF: 27/04/2007
    then
    begin
      if NeedToReadIni then
      begin
        UserID := '';
        NeedToReadIni := False; //Only need to read it once
        BankDetFromIni := True;
        BankGLCode := 0;
        TempExportObj := TExportObject.Create;
        Try
          TempExportObj.GetEventData(EventData);
          BankGLCode :=  TempExportObj.ProcControl.BankGL;
        Finally
          TempExportObj.Free;
        End;
        if not ReadIniFile(EventData.Setup.ssDataPath, BankGLCode) then
        begin
          {show error message and disengage}
          //Actually we don't need to do this here, it can all be handled
          //at a lower level where we have access to more information
          //so that the user can be better informed
        end;
      end;

      if BacsType <> exAbnAmro then
        HandleBatchHooks(EventData, HandlerID, BacsType, ftaBoth, IniPayFile,
                         IniDDFile)
      else
      begin
        {Call abn hooks}
        ExecABNHandler(EventData);
      end;

      IF (HandlerID = 80) or not BoResult then
        NeedToReadIni := True; //Finished so need to reread on next run
                               //in case user has changed the file
    end;
  end;


  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;


Initialization
  NeedToReadIni := True;

end.
