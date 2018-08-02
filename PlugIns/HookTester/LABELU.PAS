unit LabelU;

interface

Uses Classes, Dialogs, Graphics, SysUtils, Windows, TCustABS;

Function EntDoCustomText(Const WindowId : LongInt) : Boolean; Export;
Procedure EntGetCustomText(CustomText : TAbsCustomText); Export;

implementation

Uses
 HookProc, CustWinU, ChainU, HandlerU;


{ Returns True if the specified window has customisation strings defined }
Function EntDoCustomText(Const WindowId : LongInt) : Boolean;
var
  iPos : integer;
Begin
  for iPos := 0 to slCustomText.Count-1 do begin
    Result := WindowId = (GetWindowID(slCustomText[iPos]));
    if Result then Break;
  end;{for}


//  Result := (WindowId = (EnterpriseBase + 2000));
//  and (TextId in [VOLAC_ADD_BUTTON, VOLAC_EDIT_BUTTON])};

//  If (Not Result) Then
  { Not Customised - pass on to next customisation DLL }
  Result := DLLChain.EntDoCustomText(WindowId);
End;


{ Returns the custom text settings }
Procedure EntGetCustomText(CustomText : TAbsCustomText);
var
  iPos : integer;
Begin { EntGetCustomText }
  With CustomText Do Begin
    for iPos := 0 to slCustomText.Count-1 do begin
      if (GetWindowID(slCustomText[iPos]) = WindowID) and (GetHandlerID(slCustomText[iPos]) = TextID)
      then begin
        Caption := TextIniFile.ReadString(slCustomText[iPos],'Text',slCustomText[iPos]);
      end;{if}
    end;{for}
  end;{with}

{  With CustomText Do Begin
    If (WindowId = (EnterpriseBase + 2000)) And (TextId = VOLAC_ADD_BUTTON)
    Then Caption := 'Volac Add';
    If (WindowId = (EnterpriseBase + 2000)) And (TextId = VOLAC_EDIT_BUTTON)
    Then Caption := 'Volac Edit';
  End; { With CustomText }

  { Not customised by this DLL - pass onto next in chain }
  DLLChain.EntGetCustomText (CustomText);
End;  { EntGetCustomText }

end.
