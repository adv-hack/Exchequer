unit LabelU;

interface

Uses Classes, Dialogs, Graphics, SysUtils, Windows, TCustABS;

Function EntDoCustomText(Const WindowId : LongInt) : Boolean; Export;
Procedure EntGetCustomText(CustomText : TAbsCustomText); Export;

implementation

Uses ChainU, CustWinU;


{ Returns True if the specified window has customisation strings defined }
Function EntDoCustomText(Const WindowId : LongInt) : Boolean;
Begin
  Result := (WindowId = wiTransaction) Or DLLChain.EntDoCustomText(WindowId);
End;


{ Returns the custom text settings }
Procedure EntGetCustomText(CustomText : TAbsCustomText);
Begin { EntGetCustomText }
  If (CustomText.WindowId = wiTransaction) And (CustomText.TextId = 10) Then
    CustomText.Caption := 'ADD NOM !'
  Else
    { Not customised by this DLL - pass onto next in chain }
    DLLChain.EntGetCustomText (CustomText);
End;  { EntGetCustomText }

end.
