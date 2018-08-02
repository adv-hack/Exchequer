unit comu;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }

{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  EntCustom, Enterprise_TLB, Enterprise04_TLB, EnterpriseEvents, ExtCtrls;

type
  TForm1 = class(TForm)
    EntCustom1: TEntCustom;
    procedure EntCustom1Connect(ComCustomisation: ICOMCustomisation);
    procedure EntCustom1Hook(EventData: ICOMEventData);
    procedure FormCreate(Sender: TObject);
    procedure EntCustom1Close;
  private
    { Private declarations }
    CanStore : Boolean;
    function GetButton(ComCustomisation : ICOMCustomisation; b1, b2 : Byte) : Byte;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  btnPIN, btnPOR, btnPQU, btnSQU, btnPINHist, btnPORHist : Byte;

implementation

{$R *.DFM}
uses
  UseDLLU, comfuncs, ComMsg, AuthObjs, pmsg, ComObj, AuthBase, PIMisc, PISecure;


const
  WiTransaction = 100000 + 2000;
  WiTransactionLines = 100000 + 4000;

function TForm1.GetButton(ComCustomisation : ICOMCustomisation;
                              b1, b2 : byte) : byte;
begin
  with ComCustomisation as ICOMCustomisation3 do
    if not HookPointEnabled(wiTransaction, b1) then
      Result := b1
    else
      Result := b2;
end;

procedure TForm1.EntCustom1Connect(ComCustomisation: ICOMCustomisation);
const
  A = 'Authorise';
begin
  with comcustomisation do
  begin
    EnableHook(wiTransaction, 1);

    btnSQU := GetButton(ComCustomisation, 11, 21);
    EnableHook(wiTransaction, btnSQU);

    btnPIN := GetButton(ComCustomisation, 110, 120);
    EnableHook(wiTransaction, btnPIN);

    btnPQU := GetButton(ComCustomisation, 111, 121);
    EnableHook(wiTransaction, btnPQU);

    btnPINHist := GetButton(ComCustomisation, 113, 123);
    EnableHook(wiTransaction, btnPINHist);

    btnPOR := GetButton(ComCustomisation, 114, 124);
    EnableHook(wiTransaction, btnPOR);

    btnPORHist := GetButton(ComCustomisation, 115, 125);
    EnableHook(wiTransaction, btnPORHist);

    EnableHook(wiTransaction, 82);
    EnableHook(wiTransaction, 83);
    EnableHook(wiTransaction, 84);
    EnableHook(wiTransaction, 85);
    EnableHook(wiTransaction, 86);
    EnableHook(wiTransaction, 87);
    EnableHook(wiTransaction, 88);
    EnableHook(wiTransaction, 98);
    EnableHook(wiTransaction, 99);

    EnableHook(wiTransaction, 151);
    EnableHook(wiTransactionLines, 10);

  end;

  with EntCustom1.Intf as ICOMCustomisation2 do
  begin
    AddLabelCustomisation(WiTransaction, btnSQU, A);
    AddLabelCustomisation(wiTransaction, btnPIN, A);
    AddLabelCustomisation(wiTransaction, btnPQU, A);
    AddLabelCustomisation(wiTransaction, btnPINHist, A);
    AddLabelCustomisation(wiTransaction, btnPOR, A);
    AddLabelCustomisation(wiTransaction, btnPORHist, A);
  end;

  CreateObjects;

end;

procedure TForm1.EntCustom1Hook(EventData: ICOMEventData);
Begin
  { Handle Hook Events here }

  with EventData do
  begin
    BoResult := True;
    if (WindowID = wiTransaction) and
        (Handlerid in [1, btnPIN, btnPOR, btnPQU, btnSQU, btnPINHist, btnPORHist, 82, 83, 84, 85, 86, 87, 88, 98, 99, 151]) and
        (EventData.Transaction.thInvDocHed in [cuSQU, cuPQU, cuPOR, cuPIN]) and
       AuthorizationNeededCOM(EventData, EntCustom1.Intf.SystemSetup.ssDataPath) then
    begin
     Try
       Case HandlerID of
           1   :  begin
                    StoreTransaction(EventData,EntCustom1.Intf.SystemSetup.ssDataPath,
                                      EntCustom1.Intf.UserName);
                    CanStore := BoResult;
                  end;
           82  :  BoResult := CanStore;

           11, 21, 110, 111, 113, 114, 115, 120, 121, 123, 124, 125, 86 :

         AuthorizeTransaction(EventData, EntCustom1.Intf.SystemSetup.ssDataPath,
                                      EntCustom1.Intf.UserName);

         151 : BoResult := AllowPrint(EventData, EntCustom1.Intf.SystemSetup.ssDataPath);

           83, 84 : BoResult := ConvertTransaction(EventData, EntCustom1.Intf.SystemSetup.ssDataPath,
                                      EntCustom1.Intf.UserName);
           85     : UnAuthorizeTransaction(EventData, EntCustom1.Intf.SystemSetup.ssDataPath,
                                      EntCustom1.Intf.UserName);
           87, 88 : BoResult := CopyTransaction(EventData, EntCustom1.Intf.SystemSetup.ssDataPath,
                                      EntCustom1.Intf.UserName);
           98, 99 : if CopyAuthorised then
                        AuthorizeCopiedTransaction(EventData,
                                                   EntCustom1.Intf.SystemSetup.ssDataPath);

       end;
     Except
      on E: Exception do
        ShowComMessage(E.Message);
     End;
    end
    else
    if (WindowID = WiTransactionLines) and (HandlerID = 10) then
       StoreTransactionLines(EventData,EntCustom1.Intf.SystemSetup.ssDataPath,
                         EntCustom1.Intf.UserName);
  end;
End;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if PICheckSecurity('EXCHAUTHWF000002', 'Ykdje*_RuUXIFHEY',
     'Enterprise Authoris-e Plug-In', GetVersion + ' (COM)', stSystemOnly, ptCOM,
     Application.ExeName) then
  begin
    CanStore := False;
    StartToolkit;
  {  with EntCustom1 do
    begin
      AboutText.Add('Purchase Authorisation Module - COM Section: ' + GetVersion);
      AboutText.Add ('Copyright Exchequer Software Ltd. 1986 - 2001.');
      AboutText.Add ('------------------------------------------------------------------------------');
    end;
   }
    EntCustom1.AboutText.Clear;
  //  PIMakeAboutText(sPlugInName, sVersionNo + ' (COM)', EntCustom1.AboutText);
    PIMakeAboutText('Enterprise Authoris-e Plug-In', GetVersion + ' (COM)', EntCustom1.AboutText);

    PMsgForm := TPMsgForm.Create(nil);
    EntCustom1.Connect;
  end
  else
    PostMessage(Handle, WM_CLOSE, 0, 0)

end;

procedure TForm1.EntCustom1Close;
begin
  EndToolkit;
  FreeObjects;
  ComTimedMessage('Please wait... Closing down', 1);
  EntCustom1.Disconnect;
  //PMsgForm.Free;// - this causes the program to crash if email hasn't been sent!
  PostMessage(PMsgForm.Handle, WM_CLOSE, 0, 0); //but this seems to work and should destroy the form
  Application.Terminate;
end;

end.
