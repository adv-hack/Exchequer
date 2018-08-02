{ Include file for SBSCntrl.Pas }

{ Functions to Set and Get the Paper Width }
Function TSBSController.GetPaperWidth : Word;
Begin
  Result := FormHeader.fhPaperWidth;
End;

Procedure TSBSController.SetPaperWidth(Value : Word);
Begin
  If (Value <> FormHeader.fhPaperWidth) Then Begin
    FormHeader.fhPaperWidth := Value;
    FPage.Paper.psPaperWidth := Value;
  End; { If }
End;

{ Functions to Set and Get the Paper Width }
Function TSBSController.GetPaperHeight : Word;
Begin
  Result := FormHeader.fhPaperHeight;
End;

Procedure TSBSController.SetPaperHeight(Value : Word);
Begin
  If (Value <> FormHeader.fhPaperHeight) Then Begin
    FormHeader.fhPaperHeight := Value;
    FPage.Paper.psPaperHeight := Value;
  End; { If }
End;

{ Functions to Set and Get the papers Top margin }
Function TSBSController.GetTopMargin : Word;
Begin
  Result := FormHeader.fhTopWaste;
End;

Procedure TSBSController.SetTopMargin(Value : Word);
Begin
  If (Value <> FormHeader.fhTopWaste) Then Begin
    FormHeader.fhTopWaste := Value;
    FPage.Paper.psTop := Value;
  End; { If }
End;

{ Functions to Set and Get the papers Bottom margin }
Function TSBSController.GetBottomMargin : Word;
Begin
  Result := FormHeader.fhBottomWaste;
End;

Procedure TSBSController.SetBottomMargin(Value : Word);
Begin
  If (Value <> FormHeader.fhBottomWaste) Then Begin
    FormHeader.fhBottomWaste := Value;
    FPage.Paper.psBottom := Value;
  End; { If }
End;

{ Functions to Set and Get the papers Left margin }
Function TSBSController.GetLeftMargin : Word;
Begin
  Result := FormHeader.fhLeftWaste;
End;

Procedure TSBSController.SetLeftMargin(Value : Word);
Begin
  If (Value <> FormHeader.fhLeftWaste) Then Begin
    FormHeader.fhLeftWaste := Value;
    FPage.Paper.psLeft := Value;
  End; { If }
End;

{ Functions to Set and Get the papers Right margin }
Function TSBSController.GetRightMargin : Word;
Begin
  Result := FormHeader.fhRightWaste;
End;

Procedure TSBSController.SetRightMargin(Value : Word);
Begin
  If (Value <> FormHeader.fhRightWaste) Then Begin
    FormHeader.fhRightWaste := Value;
    FPage.Paper.psRight := Value;
  End; { If }
End;

{ Functions to Get and Set the Page Sections }
Function TSBSController.GetSections : TPageStructureSet;
Begin
  Result := FormHeader.fhSections;
End;

Procedure TSBSController.SetSections(Value : TPageStructureSet);
Begin
  If (Value <> FormHeader.fhSections) Then Begin
    FormHeader.fhSections := Value;
    FPage.SetStructure(Value);
  End; { If }
End;

{ Functions to Get and Set the Page Orientation }
Function TSBSController.GetOrient : fdOrientationType;
Begin
  Result := FormHeader.fhOrientation;
End;

Procedure TSBSController.SetOrient(Value : fdOrientationType);
Begin
  If (Value <> FormHeader.fhOrientation) Then Begin
    FormHeader.fhOrientation := Value;
  End; { If }
End;

{ Functions to Get and Set the Form Type }
Function TSBSController.GetFormType : fdFormTypeType;
Begin
  Result := FormHeader.fhFormType;
End;

Procedure TSBSController.SetFormType(Value : fdFormTypeType);
Begin
  If (Value <> FormHeader.fhFormType) Then Begin
    FormHeader.fhFormType := Value;
  End; { If }
End;




