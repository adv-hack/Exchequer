unit RegUtil;

{ markd6 14:23 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, FileCtrl, OLEAuto, Sysutils, Windows;

Type
  MsgProcType = Procedure (Const Msg : ShortString; Const Refresh : Boolean) Of Object;

implementation

{ Registers the Exchequer OLE Server }
Procedure RegEnterOle (Var MsgProc : MsgProcType);
Var
  Tmp    : ShortString;
  EntOLE : Variant;
  pExec  : PChar;
Begin { RegEnterOle }
  If Assigned (MsgProc) Then Begin
    MsgProc ('', False);
    MsgProc ('  Registering OLE Server with Windows', True);
  End; { If Assigned(MsgProc) }

  Tmp := ExtractFilePath(Application.EXEName)+'ENTEROLE.EXE';
  If FileExists(Tmp) Then Begin
    Tmp := Tmp + ' /REGSERVER';

    pExec := StrAlloc(255);
    StrPCopy (pExec, Tmp);
    If (WinExec(pExec, SW_SHOW) > 31) Then Begin
      { Ran OK - Test }
      Try
        { Display version }
        If Assigned (MsgProc) Then Begin
          { Load OLE Server }
          EntOLE := CreateOleObject('Enterprise.OLEServer');

          MsgProc ('    ' + EntOLE.Version, True);

          { SetFocus to Self }
          SetForegroundWindow(Application.MainForm.Handle);
          Application.MainForm.Refresh;
        End; { If Assigned(MsgProc) }
      Except
        On Ex:Exception Do Begin
          If Assigned (MsgProc) Then Begin
            MsgProc ('    OLE Server Failed Test', True);
          End; { If Assigned(MsgProc) }
        End;
      End;
    End { If }
    Else Begin
      { Error }
      If Assigned (MsgProc) Then Begin
        MsgProc ('    Cannot Register OLE Server', True);
      End; { If Assigned(MsgProc) }
    End; { Else }

    StrDispose(pExec);
  End; { If }
End; { RegEnterOle }


end.
