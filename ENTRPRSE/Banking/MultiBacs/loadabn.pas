unit loadabn;

{ prutherford440 15:10 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  CustAbsU;

function LoadAbnDll : Boolean;
procedure FreeAbnDll;
Procedure InitCustHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
Procedure TermCustHandler;
Procedure ExecCustHandler(Const EventData : TAbsEnterpriseSystem);



implementation

uses
  Windows;

var
  _InitCustomHandler : procedure  (Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
  _TermCustomHandler : Procedure ;
  _ExecCustomHandler : Procedure (Const EventData : TAbsEnterpriseSystem);

  DllHandle : THandle;

function LoadAbnDll : Boolean;
begin
  DLLHandle := LoadLibrary ('AbnEpf');
  Result := (DLLHandle > HInstance_Error);
  if Result then
  begin
    _InitCustomHandler := GetProcAddress(DLLHandle, 'InitCustomHandler');
    _TermCustomHandler := GetProcAddress(DLLHandle, 'TermCustomHandler');
    _ExecCustomHandler := GetProcAddress(DLLHandle, 'ExecCustomHandler');
    Result := (Assigned(_InitCustomHandler)) and
              (Assigned(_TermCustomHandler)) and
              (Assigned(_ExecCustomHandler));
  end;
end;

procedure FreeAbnDll;
begin
  FreeLibrary (DLLHandle);
end;

Procedure InitCustHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
begin

  if Assigned(_InitCustomHandler) then
    _InitCustomHandler(CustomOn, CustomHandlers);
end;

Procedure TermCustHandler;
begin
  if Assigned(_TermCustomHandler) then
    _TermCustomHandler;
end;

Procedure ExecCustHandler(Const EventData : TAbsEnterpriseSystem);
begin
  if Assigned(_ExecCustomHandler) then
    _ExecCustomHandler(EventData);
end;




Initialization
  DllHandle := nil;

end.
 