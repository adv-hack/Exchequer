unit LabelU;

interface

Uses Classes, Dialogs, Graphics, SysUtils, Windows, TCustABS;

Function EntDoCustomText(Const WindowId : LongInt) : Boolean; Export;
Procedure EntGetCustomText(CustomText : TAbsCustomText); Export;

implementation

Uses ChainU, CustWinU, HandlerU;


{ Returns True if the specified window has customisation strings defined }
Function EntDoCustomText(Const WindowId : LongInt) : Boolean;
Begin
  Result := (WindowId = wiAccount);
  If (Not Result) Then
    Result := DLLChain.EntDoCustomText(WindowId);
End;


{ Returns the custom text settings }
Procedure EntGetCustomText(CustomText : TAbsCustomText);
Begin { EntGetCustomText }
  If (CustomText.WindowId = wiAccount) And (CustomText.TextId = iCustomerLabel) Then
    CustomText.Caption := 'Give PPD'
  Else If (CustomText.WindowId = wiAccount) And (CustomText.TextId = iSupplierLabel) Then
    CustomText.Caption := 'Take PPD'
  Else
    // Not customised by this DLL - pass onto next in chain
    DLLChain.EntGetCustomText (CustomText);
End;  { EntGetCustomText }

end.
