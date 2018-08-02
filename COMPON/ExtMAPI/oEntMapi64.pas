unit oEntMapi64;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Exchequer_TLB, StdVcl, MapiEx;

type
  //Class to implement IEnterpriseMapi64 interface
  TMapi64 = class(TAutoObject, IMapi64)
  protected
    FMapiEx : TMapiExEmail;
    function Get_emVersion: WideString; safecall;
    function Get_emBCC: WideString; safecall;
    function Get_emCC: WideString; safecall;
    function Get_emRecipient: WideString; safecall;
    procedure Set_emBCC(const Value: WideString); safecall;
    procedure Set_emCC(const Value: WideString); safecall;
    procedure Set_emRecipient(const Value: WideString); safecall;
    function Get_emAttachment: WideString; safecall;
    function Get_emMessage: WideString; safecall;
    function Get_emSubject: WideString; safecall;
    procedure Set_emAttachment(const Value: WideString); safecall;
    procedure Set_emMessage(const Value: WideString); safecall;
    procedure Set_emSubject(const Value: WideString); safecall;
    function Logon: Integer; safecall;
    function Logoff: Integer; safecall;
    function GetFirstUnread: Integer; safecall;
    function GetNextUnread: Integer; safecall;
    function SendMail: Integer; safecall;
    procedure DeleteMessage; safecall;
    procedure DeleteReadMessages; safecall;
    procedure SetMessageAsRead; safecall;
    function Get_emDeleteAfterRead: WordBool; safecall;
    function Get_emPassword: WideString; safecall;
    function Get_emProfile: WideString; safecall;
    function Get_emService: WordBool; safecall;
    function Get_emUseDefaultProfile: WordBool; safecall;
    procedure Set_emDeleteAfterRead(Value: WordBool); safecall;
    procedure Set_emPassword(const Value: WideString); safecall;
    procedure Set_emProfile(const Value: WideString); safecall;
    procedure Set_emService(Value: WordBool); safecall;
    procedure Set_emUseDefaultProfile(Value: WordBool); safecall;
    function Get_emHandle: Integer; safecall;
    function Get_emShowDialog: WordBool; safecall;
    procedure Set_emHandle(Value: Integer); safecall;
    procedure Set_emShowDialog(Value: WordBool); safecall;
    function Get_emLeaveUnread: WordBool; safecall;
    function Get_emOriginator: WideString; safecall;
    procedure Set_emLeaveUnread(Value: WordBool); safecall;
    function Get_emOriginatorAddress: WideString; safecall;
  public
    procedure Initialize; override;
    Destructor Destroy; override;
  end;

implementation

uses ComServ, System.SysUtils, oMapi64;

const
  VERSION_NO = '1.0.0.1';


function TMapi64.Get_emVersion: WideString;
begin
  Result := VERSION_NO;
end;

procedure TMapi64.Initialize;
begin
  inherited;
  FMapiEx := TMapiExEmail.Create(OwnerForm);
end;

function TMapi64.Get_emBCC: WideString;
begin
  Result := FMapiEx.BCC.Text;
end;

function TMapi64.Get_emCC: WideString;
begin
  Result := FMapiEx.CC.Text;
end;

function TMapi64.Get_emRecipient: WideString;
begin
  Result := FMapiEx.Recipient.Text;
end;

procedure TMapi64.Set_emBCC(const Value: WideString);
begin
  FMapiEx.BCC.Text := Value;
end;

procedure TMapi64.Set_emCC(const Value: WideString);
begin
  FMapiEx.CC.Text := Value;
end;

procedure TMapi64.Set_emRecipient(const Value: WideString);
begin
  FMapiEx.Recipient.Text := Value;
end;

function TMapi64.Get_emAttachment: WideString;
begin
  Result := FMapiEx.Attachment.Text;
end;

function TMapi64.Get_emMessage: WideString;
begin
  Result := WideString(FMapiEx.GetLongText);
end;

function TMapi64.Get_emSubject: WideString;
begin
  Result := FMapiEx.Subject;
end;

procedure TMapi64.Set_emAttachment(const Value: WideString);
begin
  FMapiEx.Attachment.Text := Value;
end;

procedure TMapi64.Set_emMessage(const Value: WideString);
begin
  FMapiEx.SetLongText(AnsiString(Value));
end;

procedure TMapi64.Set_emSubject(const Value: WideString);
begin
  FMapiEx.Subject := Value;
end;

function TMapi64.Logon: Integer;
begin
  Result := FMapiEx.Logon;
end;

function TMapi64.Logoff: Integer;
begin
  Result := FMapiEx.Logoff;
end;

function TMapi64.GetFirstUnread: Integer;
begin
  Result := FMapiEx.GetFirstUnread;
end;

function TMapi64.GetNextUnread: Integer;
begin
  Result := FMapiEx.GetNextUnread;
end;

function TMapi64.SendMail: Integer;
begin
  Result := FMapiEx.SendMail;
end;

procedure TMapi64.DeleteMessage;
begin
  FMapiEx.DeleteMessage;
end;

procedure TMapi64.DeleteReadMessages;
begin
  FMapiEx.DeleteReadMessages;
end;

destructor TMapi64.Destroy;
begin
  inherited;
end;

procedure TMapi64.SetMessageAsRead;
begin
  FMapiEx.SetMessageAsRead;
end;

function TMapi64.Get_emDeleteAfterRead: WordBool;
begin
  Result := FMapiEx.DeleteAfterRead;
end;

function TMapi64.Get_emPassword: WideString;
begin
  Result := FMapiEx.Password;
end;

function TMapi64.Get_emProfile: WideString;
begin
  Result := FMapiEx.Profile;
end;

function TMapi64.Get_emService: WordBool;
begin
  Result := FMapiEx.InService;
end;

function TMapi64.Get_emUseDefaultProfile: WordBool;
begin
  Result := FMapiEx.UseDefProfile;
end;

procedure TMapi64.Set_emDeleteAfterRead(Value: WordBool);
begin
  FMapiEx.DeleteAfterRead := Value;
end;

procedure TMapi64.Set_emPassword(const Value: WideString);
begin
  FMapiEx.Password := Value;
end;

procedure TMapi64.Set_emProfile(const Value: WideString);
begin
  FMapiEx.Profile := Value;
end;

procedure TMapi64.Set_emService(Value: WordBool);
begin
  FMapiEx.InService := Value;
end;

procedure TMapi64.Set_emUseDefaultProfile(Value: WordBool);
begin
  FMapiEx.UseDefProfile := Value;
end;

function TMapi64.Get_emHandle: Integer;
begin
  Result := Integer(FMapiEx.WindowHandle);
end;

function TMapi64.Get_emShowDialog: WordBool;
begin
  Result := FMapiEx.ShowDialog;
end;

procedure TMapi64.Set_emHandle(Value: Integer);
begin
  FMapiEx.WindowHandle := Value;
end;

procedure TMapi64.Set_emShowDialog(Value: WordBool);
begin
  FMapiEx.ShowDialog := Value;
end;

function TMapi64.Get_emLeaveUnread: WordBool;
begin
  Result := FMapiEx.LeaveUnread;
end;

function TMapi64.Get_emOriginator: WideString;
begin
  Result := FMapiEx.Originator;
end;

procedure TMapi64.Set_emLeaveUnread(Value: WordBool);
begin
  FMapiEx.LeaveUnread := Value;
end;

function TMapi64.Get_emOriginatorAddress: WideString;
begin
  Result := FMapiEx.OrigAddress;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TMapi64, Class_Mapi64,
    ciSingleInstance, tmApartment);
end.
