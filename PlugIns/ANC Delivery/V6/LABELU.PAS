unit LabelU;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Graphics, SysUtils, Windows, TCustABS;

Function EntDoCustomText(Const WindowId : LongInt) : Boolean; Export;
Procedure EntGetCustomText(CustomText : TAbsCustomText); Export;

implementation

Uses ChainU, CustWinU, HandlerU;


{ Returns True if the specified window has customisation strings defined }
Function EntDoCustomText(Const WindowId : LongInt) : Boolean;
Begin
  If bPlugInEnabled And ((WindowID = wiAccount) Or (WindowID = wiTransaction)) then
    Result := True
  else
  { Not Customised - pass on to next customisation DLL }
    Result := DLLChain.EntDoCustomText(WindowId);
End;


{ Returns the custom text settings }
Procedure EntGetCustomText(CustomText : TAbsCustomText);
Begin { EntGetCustomText }
  If bPlugInEnabled Then
    With CustomText Do Begin
      { Handle Hook Events here }
      If (WindowId = wiAccount) and (TextID in [1, 3]) then
        Caption := 'ANC'
      Else
        If (WindowId = wiTransaction) and (TextID = 14) then
          Caption := 'ANC';
    End; { With CustomText }

  { Not customised by this DLL - pass onto next in chain }
  DLLChain.EntGetCustomText (CustomText);
End;  { EntGetCustomText }

end.
