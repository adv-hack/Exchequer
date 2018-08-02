unit ChkParam;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

implementation

Uses Dialogs, SysUtils, Forms;

Procedure CheckParamCode;
Var
  GotOKCode : Boolean;
  I         : SmallInt;
Begin
  GotOKCode := False;

  If (ParamCount > 0) Then
    For I := 1 To ParamCount Do Begin
      {$IFDEF RW}
        If (Not GotOKCode) Then
          GotOKCode := (UpperCase(Trim(ParamStr(I))) = '/3CMHSI');
      {$ENDIF}
    End; { For }

  If (Not GotOKCode) Then Begin
    ShowMessage ('ABEND(204)');
    Application.Terminate;
  End; { If }
End;

Initialization
  CheckParamCode;
end.
