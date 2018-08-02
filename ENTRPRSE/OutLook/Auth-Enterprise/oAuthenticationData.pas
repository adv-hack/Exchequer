unit oAuthenticationData;

interface

Type
  TEnterpriseAuthenticationState = Class(TObject)
  Private
    Function GetState : WideString;
    Procedure SetState (Value : WideString);
  Public
    Property State : WideString Read GetState Write SetState;

    Constructor Create (Const State : WideString = '');
  End; // TEnterpriseAuthenticationState

implementation

//=========================================================================

Constructor TEnterpriseAuthenticationState.Create (Const State : WideString = '');
Begin // Create
  Inherited Create;

  SetState (State);
End; // Create

//-------------------------------------------------------------------------

Function TEnterpriseAuthenticationState.GetState : WideString;
Begin // GetState
  Result := '';
End; // GetState
Procedure TEnterpriseAuthenticationState.SetState (Value : WideString);
Begin // SetState
  If (Value <> '') Then
  Begin

  End; // If (Value <> '')
End; // SetState

//-------------------------------------------------------------------------

end.
