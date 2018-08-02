unit LabelU;

interface

Uses Classes, Dialogs, Graphics, SysUtils, Windows, TCustABS;

Function EntDoCustomText(Const WindowId : LongInt) : Boolean; Export;
Procedure EntGetCustomText(CustomText : TAbsCustomText); Export;

implementation

Uses
 CustWinU, ChainU, HandlerU;


{ Returns True if the specified window has customisation strings defined }
Function EntDoCustomText(Const WindowId : LongInt) : Boolean;
Begin
  { Text is customised to set Customer List - Custom Button 1 }
  Result := (WindowId = (EnterpriseBase + 2000)) {and (TextId in [16, 17])};

//  If (Not Result) Then
    { Not Customised - pass on to next customisation DLL }
    Result := DLLChain.EntDoCustomText(WindowId);
End;


{ Returns the custom text settings }
Procedure EntGetCustomText(CustomText : TAbsCustomText);
Begin { EntGetCustomText }
  With CustomText Do Begin
    If (WindowId = (EnterpriseBase + 2000)) And (TextId = iHookID)
    Then Caption := 'Payment';
  End; { With CustomText }

  { Not customised by this DLL - pass onto next in chain }
  DLLChain.EntGetCustomText (CustomText);
End;  { EntGetCustomText }

end.
