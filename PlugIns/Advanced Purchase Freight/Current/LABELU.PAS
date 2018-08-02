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
  Result := (WindowId = wiTransaction);

  If (Not Result) Then
  { Not Customised - pass on to next customisation DLL }
  Result := DLLChain.EntDoCustomText(WindowId);
End;


{ Returns the custom text settings }
Procedure EntGetCustomText(CustomText : TAbsCustomText);
Begin { EntGetCustomText }
  With CustomText Do Begin
    If ((WindowId = (wiTransaction)) And (TextId = iPORDaybookBtnId))
    Then Caption := 'Freight';

    If ((WindowId = (wiTransaction)) And (TextId = iPurchaseDaybookBtnId))
    Then Caption := 'Uplift';
  End; { With CustomText }

  { Not customised by this DLL - pass onto next in chain }
  DLLChain.EntGetCustomText (CustomText);
End;  { EntGetCustomText }

end.
