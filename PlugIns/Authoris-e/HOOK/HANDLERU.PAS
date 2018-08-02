unit HandlerU;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses CustWinU, CustAbsU;


{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers01); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses Dialogs, SysUtils, ChainU, HookFunc, Forms, Controls, AuthObjs, {CheckSec,}
  PIMisc, PISecure, pmsg, DllFuncs, Classes, LabelU, ComMsg, Crypto;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

  ModuleName = 'ExPaHook';
  ModuleDesc = 'Purchase Authorisation Plug-in';
  HookID = 1101;

var
  CanStore : Boolean;

  //PR: 04/09/2013 ABSEXCH-14573 Extend array to 6
  bUsedByOthers : Array[1..6] of Boolean;


function UsedByOthers(HookPoint : Integer) : Boolean;
begin
  Case HookPoint of
    82  : Result := bUsedByOthers[1];
    87,
    88  : Result := bUsedByOthers[HookPoint - 85];
    151 : Result := bUsedByOthers[4];
    //PR: 04/09/2013 ABSEXCH-14573 Extend array to 6 for SQU/PQU conversion
    83,
    84  : Result := bUsedByOthers[HookPoint - 78]; //5 & 6
    else
      Result := False;
  end
end;


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers01);

var
  T : TStringList;
  i : integer;

  function GetButton(b1, b2 : Byte) : Byte;
  begin
    with CustomHandlers  do
    if not HookPointEnabled(wiTransaction, b1) then
      Result := b1
    else
      Result := b2;
  end;

Begin
  CustomOn := False;

  ChangeCryptoKey(19701115);

  if PICheckSecurity('EXCHAUTHWF000002', 'Ykdje*_RuUXIFHEY',
     'Exchequer Authoris-e Plug-In', GetVersion + ' (DLL)', stSystemOnly, ptDLL,
     ModuleName) then
  with CustomHandlers  do
  begin
    CanStore := False;
    T := TStringList.Create;
    PIMakeAboutText('Exchequer Authoris-e Plug-In', GetVersion + ' (DLL)', T);

    for i := 0 to T.Count - 1 do
      AddAboutString(T[i]);
    T.Free;
    PMsgForm := TPMsgForm.Create(nil);

    //PR: 07/01/2009 Need to check existing state of Allow Print, Allow Copy/Reverse hooks as well as Validate Transaction.
    bUsedByOthers[1]  := HookPointEnabled(wiTransaction, 82);
    bUsedByOthers[2]  := HookPointEnabled(wiTransaction, 87);
    bUsedByOthers[3]  := HookPointEnabled(wiTransaction, 88);
    bUsedByOthers[4] := HookPointEnabled(wiTransaction, 151);

    //PR: 04/09/2013 ABSEXCH-14573 Extend array to 6 for SQU/PQU conversion
    bUsedByOthers[5]  := HookPointEnabled(wiTransaction, 83);
    bUsedByOthers[6]  := HookPointEnabled(wiTransaction, 84);

    SetHandlerStatus(wiTransaction, 1, EventEnabled);

    btnSQU := GetButton(11, 21);
    SetHandlerStatus(wiTransaction, btnSQU, EventEnabled);

    btnPIN := GetButton(110, 120);
    SetHandlerStatus(wiTransaction, btnPIN, EventEnabled);

    btnPQU := GetButton(111, 121);
    SetHandlerStatus(wiTransaction, btnPQU, EventEnabled);

    btnPINHist := GetButton(113, 123);
    SetHandlerStatus(wiTransaction, btnPINHist, EventEnabled);

    btnPOR := GetButton(114, 124);
    SetHandlerStatus(wiTransaction, btnPOR, EventEnabled);

    btnPORHist := GetButton(115, 125);
    SetHandlerStatus(wiTransaction, btnPORHist, EventEnabled);

    SetHandlerStatus(wiTransaction, 82, EventEnabled);
    SetHandlerStatus(wiTransaction, 83, EventEnabled);
    SetHandlerStatus(wiTransaction, 84, EventEnabled);
    SetHandlerStatus(wiTransaction, 85, EventEnabled);
    SetHandlerStatus(wiTransaction, 86, EventEnabled);
    SetHandlerStatus(wiTransaction, 87, EventEnabled);
    SetHandlerStatus(wiTransaction, 88, EventEnabled);
    SetHandlerStatus(wiTransaction, 98, EventEnabled);
    SetHandlerStatus(wiTransaction, 99, EventEnabled);

    SetHandlerStatus(wiTransaction, 151, EventEnabled);
    SetHandlerStatus(wiTransLine, 10, EventEnabled);

    SetHandlerStatus(wiMisc + 2, 8, EventEnabled);
    SetHandlerStatus(wiMisc + 2, 9, EventEnabled);

    StartToolkit;
    CreateObjects;
  end;
  //StartToolkit;
  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
  EndToolkit;
  FreeObjects;
  ComTimedMessage('Please wait... Closing down', 1);
  PMsgForm.Free;
End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
var
  OldCursor : TCursor;
  sStoreTkDataPath : string;
  sSToreTkAutoSetStockCost : Boolean;
Begin
  { Handle Hook Events here }
  with EventData do
  begin
{    sStoreTkDataPath := FToolkit.Configuration.DataDirectory;
    sStoreTkAutoSetStockCost := FToolkit.Configuration.AutoSetStockCost;}
    if (WinId = wiMisc + 2) then
    begin
      if HandlerID = 8 then
        FreeObjects
      else
      if HandlerID = 9 then
        CreateObjects;
    end
    else
    if (WinID = wiTransaction) and
        (Handlerid in [1, btnPIN, btnPOR, btnPQU, btnSQU, btnPINHist, btnPORHist, 82, 83, 84, 85, 86, 87, 88, 98, 99, 151]) and
        (EventData.Transaction.thInvDocHed in [cuSQU, cuPQU, cuPOR, cuPIN]) and
       AuthorizationNeededCOM(EventData, Setup.ssDataPath) then
    begin
     Try
       SetAttachPrinter(EventData);
       Case HandlerID of
           1   :  begin
{                    StoreTransaction(EventData,Setup.ssDataPath,
                                      UserName);}
                   {PR 11/06/03 change from using UserName (8 chars) to
                    UserProfile.upUserID (10 chars)}
                    StoreTransaction(EventData,Setup.ssDataPath,
                                      Trim(UserProfile.upUserId));
                    CanStore := BoResult;
                  end;
           82  :  begin
                    if not UsedByOthers(82) then
                       BoResult := True;
                    if not CanStore then
                    begin
                      BoResult := False;
                      PaHookUserObject.ShowError;
                    end
                    else
                    if BoResult then
                      PaHookUserObject.ShowError;
                  end;

           11, 21, 110, 111, 113, 114, 115, 120, 121, 123, 124, 125, 86 :

         AuthorizeTransaction(EventData, Setup.ssDataPath,
                                      Trim(UserProfile.upUserId));

         151 : begin
                 if not UsedByOthers(151) then
                   BoResult := AllowPrint(EventData, Setup.ssDataPath);
               end;

           83, 84 : BoResult := ConvertTransaction(EventData, Setup.ssDataPath,
                                      Trim(UserProfile.upUserId));
           85     : UnAuthorizeTransaction(EventData, Setup.ssDataPath,
                                      Trim(UserProfile.upUserId));
           87, 88 : if not UsedByOthers(HandlerID) then
                       BoResult := CopyTransaction(EventData, Setup.ssDataPath,
                           Trim(UserProfile.upUserId));
           98, 99 : if CopyAuthorised then
                        AuthorizeCopiedTransaction(EventData,
                                                   Setup.ssDataPath);

       end;
     Except
      on E: Exception do
        ShowComMessage(E.Message);
     End;
    end
    else
    if (WinID = WiTransLine) and (HandlerID = 10) then
       StoreTransactionLines(EventData,Setup.ssDataPath,
                         Trim(UserProfile.upUserId))
    else  //PR: 17/09/2009 Added 86 (Authorisation Hook) into check as PCRs weren't allowed to be authorised
          //PR: 04/09/2013 ABSEXCH-14573 Added 83 & 84 (SQU/PQU conversion)
    if (WinID = wiTransaction) and (HandlerID in [82, 83, 84, 86, 87, 88, 151]) and not UsedByOthers(HandlerID) then
      BoResult := True;
{    FToolkit.Configuration.DataDirectory := sStoreTkDataPath;
    FToolkit.Configuration.AutoSetStockCost := sStoreTkAutoSetStockCost;}
  end;
  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
