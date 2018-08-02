unit DebugWin;
(*
  Using DebugWin:

  The Debug Server must be registered on your computer before you can use
  it. Use the following to register it:

    X:\Entrprse\Funcs\SysMessg.Exe /regserver

  To use the Debug Server in an application:

    Add DEBUGON to the project options conditional defines.

    Make sure X:\Entrprse\Funcs is in the project search path.

    Include DebugWin in the 'uses' clause.

    Send messages to the Debug Window:

    {$IFDEF DEBUGON}
    DBug.Msg(1, 'Message to be displayed');
    {$ENDIF}

    The first parameter is a 'group' number. The Debug Window menu has options
    to switch the display of specific groups on or off.

    Other options:
      Clear the debug window:   DBug.Clear;
      Set the indent level:     DBug.Indent(<number of chars indentation>);

  The Debug Window can be run separately (X:\Entrprse\Funcs\SysMessg.Exe), in
  which case it will stay running after the application has closed.
*)

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{$IFNDEF DEBUGON}

  This section was deliberately added to prevent the DebugWin module being
  compiled into applications accidentally. To use the Debug Window interface
  you must define the DEBUGON compiler definition if your Project Options.

  This module should NOT be included in any release versions as it clashes
  with the Graph OCX causing EAccessViolations when exiting Exchequer.

  It also has a tendency to cause the program to hang under NT 4.0 when
  starting up if the Debug Window App is loaded.

{$ENDIF}

uses SysMessg_TLB;

Type
  TDebugObject = Class(TObject)
  Private
    Svr: IDebugServer;
    Function GotServer: Boolean;
  Public
    Constructor Create;
    Destructor  Destroy; OverRide;
    Procedure Clear;
    Procedure Indent (Const NumChars : Integer);
    Procedure Msg (Const Group : Integer;Const Msg : String);
    Procedure MsgI (Const Group : Integer;Const Msg : String;Const NumChars : Integer);
  End; { TDebugObject }

var
  Dbug: TDebugObject;

implementation

uses ActiveX, Windows, ComObj, Dialogs;


Constructor TDebugObject.Create;
Begin
  Inherited Create;

  {$IFDEF DEBUGON}
  try
//    Svr := CoDebugServer.Create;
    Svr := CreateOLEObject('SysMessg.DebugServer') as IDebugServer;
    Svr.Clear;
    Svr.AddUsage;
  except
    Svr := nil;
  end;
  {$ENDIF}

End;

Destructor TDebugObject.Destroy;
Begin
  {$IFDEF DEBUGON}
  If GotServer Then
  Begin
    Svr.DecUsage;
    Svr := nil;
  End; { If }
  {$ENDIF}

  Inherited Destroy;
End;

Function TDebugObject.GotServer: Boolean;
Begin
  {$IFDEF DEBUGON}
  Result := (Svr <> nil);
  {$ELSE}
  Result := False;
  {$ENDIF}
End;

Procedure TDebugObject.Clear;
Begin
  {$IFDEF DEBUGON}
    If GotServer Then
      Svr.Clear;
  {$ENDIF}
End;

Procedure TDebugObject.Indent (Const NumChars : Integer);
Begin
  {$IFDEF DEBUGON}
    If GotServer Then
      Svr.Indent(NumChars);
  {$ENDIF}
End;

Procedure TDebugObject.Msg (Const Group : Integer;Const Msg : String);
Begin
  {$IFDEF DEBUGON}
    If GotServer Then
      Svr.DisplayMsg (Group, Msg);
  {$ENDIF}
End;

Procedure TDebugObject.MsgI (Const Group : Integer;Const Msg : String;Const NumChars : Integer);
Begin
  {$IFDEF DEBUGON}
    If GotServer Then Begin
      Svr.DisplayMsg (Group, Msg);
      Svr.Indent(NumChars);
    End; { If }
  {$ENDIF}
End;

Initialization
  Coinitialize(nil);
  Dbug := TDebugObject.Create;
Finalization
  Dbug.Free;
  CoUninitialize;
end.
