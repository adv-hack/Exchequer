unit LabelU;

interface

Uses Classes, Dialogs, Graphics, SysUtils, Windows, TCustABS;

Function EntDoCustomText(Const WindowId : LongInt) : Boolean; Export;
Procedure EntGetCustomText(CustomText : TAbsCustomText); Export;

implementation

Uses ChainU;


{ Returns True if the specified window has customisation strings defined }
Function EntDoCustomText(Const WindowId : LongInt) : Boolean;
Begin
  { Not Customised - pass on to next customisation DLL }
  Result := DLLChain.EntDoCustomText(WindowId);
End;


{ Returns the custom text settings }
Procedure EntGetCustomText(CustomText : TAbsCustomText);
Begin { EntGetCustomText }
  { Not customised by this DLL - pass onto next in chain }
  DLLChain.EntGetCustomText (CustomText);
End;  { EntGetCustomText }

end.
