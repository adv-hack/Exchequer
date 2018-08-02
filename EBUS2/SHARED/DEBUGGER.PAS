unit Debugger;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

type
  TDebug = class
    private
      fEnabled : boolean;
      procedure SetEnabled(const Value: boolean);
      procedure CheckCommandLine;
    public
      property Enabled : boolean read fEnabled write SetEnabled;
      procedure Show(const Msg : ansistring);
      constructor Create;
   end;

var
  Debug : TDebug;

implementation

uses
  SysUtils, Dialogs;

//-----------------------------------------------------------------------

procedure TDebug.CheckCommandLine;
begin
  Enabled := FindCmdLineSwitch('DEBUG', ['/'], true);
end;

//-----------------------------------------------------------------------

constructor TDebug.Create;
begin
  inherited Create;
  CheckCommandLine;
end;

//-----------------------------------------------------------------------

procedure TDebug.Show(const Msg : ansistring);
begin
  if Enabled then
    ShowMessage('DEBUG: ' + Msg);
end;

//-----------------------------------------------------------------------

procedure TDebug.SetEnabled(const Value: boolean);
begin
  fEnabled := Value;
end;

//-----------------------------------------------------------------------

initialization
  Debug := TDebug.Create;

finalization
  Debug.Free;

end.
