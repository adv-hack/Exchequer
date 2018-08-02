Unit DisableControlsClass;

Interface

Uses Classes, SysUtils, Forms, Controls, Contnrs;

Type
  TDisableControls = Class(TObject)
  Private
    FDisabledControls : TObjectList;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure DisableActiveControls (Const TargetForm : TForm);
    Procedure ReenableDisabledControls;
  End; // TDisableControls

Implementation

//=========================================================================

Constructor TDisableControls.Create;
Begin // Create
  Inherited Create;

  // Use a TObjectList to store a list of controls this object has disabled -
  // must set OwnsObjects to False to prenet it destroying anything removed
  // from the list
  FDisabledControls := TObjectList.Create;
  FDisabledControls.OwnsObjects := False;
End; // Create

//------------------------------

Destructor TDisableControls.Destroy;
Begin // Destroy
  FreeAndNIL(FDisabledControls);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TDisableControls.DisableActiveControls (Const TargetForm : TForm);
Var
  I : Integer;
Begin // DisableActiveControls
  // Run through the controls on the supplied form and disable any enabled
  // controls to prevent the user messing with the UI whilst some process
  // is being performed
  For I := 0 To (TargetForm.ControlCount - 1) Do
  Begin
    If TargetForm.Controls[I].Enabled Then
    Begin
      // Disable the control and add it into the list for later re-enablement
      TargetForm.Controls[I].Enabled := False;
      FDisabledControls.Add(TargetForm.Controls[I]);
    End; // If TargetForm.Controls[I].Enabled
  End; // For I
End; // DisableActiveControls

//-------------------------------------------------------------------------

Procedure TDisableControls.ReenableDisabledControls;
Begin // ReenableDisabledControls
  // Run through the list of disabled controls and re-enable them
  While (FDisabledControls.Count > 0) Do
  Begin
    TControl(FDisabledControls.Items[0]).Enabled := True;
    FDisabledControls.Delete(0);
  End; // While (FDisabledControls.Count > 0)
End; // ReenableDisabledControls

//=========================================================================

End.

