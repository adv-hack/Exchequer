unit debugwin;

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

Type
  TDebugObject = Class(TObject)
  Private
    FOLEDebug : Variant;
    Function GotOLELink : Boolean;
    Function GotWindow  : Boolean;
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

Uses Windows, ComObj, {OLEAuto, }Dialogs, Variants;


Constructor TDebugObject.Create;
Begin
  Inherited Create;

  {$IFDEF DEBUGON}
  If GotWindow Then Begin
    Try
      FOLEDebug := CreateOleObject('SBSDebug.OLE');
      FOLEDebug.Clear;
      FOLEDebug.AddUsage;
    Except
      VarClear(FOLEDebug);
    End;
  End; { If }
  {$ENDIF}
End;

Destructor TDebugObject.Destroy;
Begin
  {$IFDEF DEBUGON}
  If GotOLELink Then Begin
    FOLEDebug.DecUsage;
    VarClear(FOLEDebug);
  End; { If }
  {$ENDIF}

  Inherited Destroy;
End;

Function TDebugObject.GotWindow : Boolean;
Begin
  {$IFDEF DEBUGON}
    Result := (FindWindow('TForm_SysDebug', 'On-Line Messages') <> 0);
  {$ELSE}
    Result := False;
  {$ENDIF}
End;

Function TDebugObject.GotOLELink : Boolean;
Begin
  {$IFDEF DEBUGON}
    Result := GotWindow;
    If Result Then
      Result := (VarType(FOLEDebug) <> varEmpty);
  {$ELSE}
    Result := False;
  {$ENDIF}
End;

Procedure TDebugObject.Clear;
Begin
  {$IFDEF DEBUGON}
    If GotOLELink Then
      FOLEDebug.Clear;
  {$ENDIF}
End;

Procedure TDebugObject.Indent (Const NumChars : Integer);
Begin
  {$IFDEF DEBUGON}
    If GotOLELink Then
      FOLEDebug.Indent(NumChars);
  {$ENDIF}
End;

Procedure TDebugObject.Msg (Const Group : Integer;Const Msg : String);
Begin
  {$IFDEF DEBUGON}
    If GotOLELink Then
      FOLEDebug.DisplayMsg (Group, Msg);
  {$ENDIF}
End;

Procedure TDebugObject.MsgI (Const Group : Integer;Const Msg : String;Const NumChars : Integer);
Begin
  {$IFDEF DEBUGON}
    If GotOLELink Then Begin
      FOLEDebug.DisplayMsg (Group, Msg);
      FOLEDebug.Indent(NumChars);
    End; { If }
  {$ENDIF}
End;

Initialization
  Dbug := TDebugObject.Create;
Finalization
  Dbug.Free;
end.
