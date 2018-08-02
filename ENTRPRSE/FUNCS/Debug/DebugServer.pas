unit DebugServer;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, SysUtils, Classes, ComObj, Sysmessg_TLB, StdVcl;

type
  TDebugServer = class(TTypedComObject, IDebugServer)
  protected
    function AddUsage: HResult; stdcall;
    function Clear: HResult; stdcall;
    function DecUsage: HResult; stdcall;
    function DisplayMsg(Group: SYSINT; const Msg: WideString): HResult;
      stdcall;
    function Indent(NumChars: SYSINT): HResult; stdcall;
    function IndentStr: string;
  end;

var
  FIndent: Integer;

implementation

uses ComServ, SysDebug;

function TDebugServer.AddUsage: HResult;
begin
  Inc(Form_SysDebug.Usage);
  Result := 0;
end;

function TDebugServer.Clear: HResult;
begin
  Form_SysDebug.List_Messages.Clear;
  Result := 0;
end;

function TDebugServer.DecUsage: HResult;
begin
  if (Form_SysDebug.Usage > 0) then
    Dec(Form_SysDebug.Usage);
  Result := 0;
end;

function TDebugServer.DisplayMsg(Group: SYSINT;
  const Msg: WideString): HResult;
Var
  Want : Boolean;
begin
  if Assigned (Form_SysDebug) Then Begin
    { Check to see if group/all messages are on hold }
    Want := not Form_SysDebug.Menu_Suspend_All.Checked;

    if Want then
      Case Group of
        1 : Want := not Form_SysDebug.Menu_Suspend_1.Checked;
        2 : Want := not Form_SysDebug.Menu_Suspend_2.Checked;
        3 : Want := not Form_SysDebug.Menu_Suspend_3.Checked;
        4 : Want := not Form_SysDebug.Menu_Suspend_4.Checked;
        5 : Want := not Form_SysDebug.Menu_Suspend_5.Checked;
      end; { Case }

    if Want then
    begin
      Form_SysDebug.List_Messages.Items.Add ('(' + TimeToStr(Time) + ')'#9 + IndentStr + Msg);
      Form_SysDebug.List_Messages.ItemIndex := Form_SysDebug.List_Messages.Items.Count - 1;
    end; { If }
  end; { If }
  Result := 0;
end;

function TDebugServer.Indent(NumChars: SYSINT): HResult;
begin
  FIndent := FIndent + NumChars;
  If (FIndent < 0) Then FIndent := 0;
  Result := 0;
end;

function TDebugServer.IndentStr: string;
var
  i: Integer;
Begin
  Result := '';
  if (FIndent > 0) then
    for i := 1 to FIndent do
      Result := Result + ' ';
end;

initialization
  TTypedComObjectFactory.Create(ComServer, TDebugServer, Class_DebugServer,
    ciMultiInstance, tmApartment);
end.
