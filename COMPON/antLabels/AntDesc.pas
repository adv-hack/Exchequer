{******************************************************************************}
{**                                                                          **}
{**  Descriptors for complex properties and other routines.                  **}
{**                                                                          **}
{**  Author:    KARPOLAN                                                     **}
{**  E-Mail:    karpolan@yahoo.com , karpolan@utilmind.com                   **}
{**  Home Page: http://karpolan.i.am, http://www.utilmind.com                **}
{**  Copyright © 1996-99 by KARPOLAN.                                        **}
{**                                                                          **}
{******************************************************************************}
{**  History:                                                                **}
{**                                                                          **}
{**  31 aug 1999 - Last modified... Prepared for public release.             **}
{******************************************************************************}
Unit AntDesc;

Interface

Uses
  Windows, SysUtils, Classes, Graphics, Controls, StdCtrls;

Type
  TantDescCallBack = Procedure of Object;

{##############################################################################}
{## Version routine ###########################################################}
{##############################################################################}
  TantVersionRecord = Packed Record
    case Integer of
     0 : (Version   : DWord);
     1 : (VersionHi : Word;
          VersionLo : Word);
  End;{TantVersionRecord = Packed Record}

{##############################################################################}
{## RunTime 4 states routines #################################################}
{##############################################################################}
  TantRunTimeState  = (rtsNormal, rtsSelected, rtsActive, rtsDisabled);

  TantRunTimeDesc = Class(TPersistent)
  Protected
    fRunTimeState : TantRunTimeState;
    Procedure SetRunTimeState(A : TantRunTimeState);                    Virtual;
  Public
    CallBack     : TantDescCallBack;
    Owner        : TComponent;
    Constructor Create(AOwner    : TComponent;
                       ACallBack : TantDescCallBack);
    Property RunTimeState : TantRunTimeState
      Read   fRunTimeState
      Write  SetRunTimeState;
  End;{TantRunTimeDesc = Class(TPersistent)}

  TantRunTimeBooleanDesc = Class(TantRunTimeDesc)
  Protected
    fNormal   : Boolean;
    fSelected : Boolean;
    fActive   : Boolean;
    fDisabled : Boolean;
  {** Properties Routines **}
    Function  GetCurrent : Boolean;
    Procedure SetNormal  (A : Boolean);
    Procedure SetSelected(A : Boolean);
    Procedure SetActive  (A : Boolean);
    Procedure SetDisabled(A : Boolean);
  Public
    Constructor CreateWithData(AOwner    : TComponent;
                               ACallBack : TantDescCallBack;
                               ANormal, ASelected, AActive, ADisabled : Boolean);
    Property Current    : Boolean
      Read   GetCurrent;
  Published
    Property Normal     : Boolean
      Read   fNormal
      Write  SetNormal;
    Property Selected   : Boolean
      Read   fSelected
      Write  SetSelected;
    Property Active     : Boolean
      Read   fActive
      Write  SetActive;
    Property Disabled   : Boolean
      Read   fDisabled
      Write  SetDisabled;
  End;{TantRunTimeColorDesc = Class(TantRunTimeDesc)}

  TantRunTimeColorDesc = Class(TantRunTimeDesc)
  Protected
    fNormal   : TColor;
    fSelected : TColor;
    fActive   : TColor;
    fDisabled : TColor;
  {** Properties Routines **}
    Function  GetCurrent : TColor;
    Procedure SetNormal  (A : TColor);
    Procedure SetSelected(A : TColor);
    Procedure SetActive  (A : TColor);
    Procedure SetDisabled(A : TColor);
  Public
    Constructor CreateWithData(AOwner    : TComponent;
                               ACallBack : TantDescCallBack;
                               ANormal, ASelected, AActive, ADisabled : TColor);

    Property Current    : TColor
      Read   GetCurrent;
  Published
    Property Normal     : TColor
      Read   fNormal
      Write  SetNormal;
    Property Selected   : TColor
      Read   fSelected
      Write  SetSelected;
    Property Active     : TColor
      Read   fActive
      Write  SetActive;
    Property Disabled   : TColor
      Read   fDisabled
      Write  SetDisabled;
  End;{TantRunTimeColorDesc = Class(TantRunTimeDesc)}

  TantRunTimeCursorDesc = Class(TantRunTimeDesc)
  Protected
    fNormal   : TCursor;
    fSelected : TCursor;
    fActive   : TCursor;
    fDisabled : TCursor;
  {** Properties Routines **}
    Function GetCurrent : TCursor;
  Public
    Constructor CreateWithData(AOwner    : TComponent;
                               ACallBack : TantDescCallBack;
                               ANormal, ASelected, AActive, ADisabled : TCursor);

    Property Current    : TCursor
      Read   GetCurrent;
  Published
    Property Normal     : TCursor
      Read   fNormal
      Write  fNormal;
    Property Selected   : TCursor
      Read   fSelected
      Write  fSelected;
    Property Active     : TCursor
      Read   fActive
      Write  fActive;
    Property Disabled   : TCursor
      Read   fDisabled
      Write  fDisabled;
  End;{TantRunTimeCursorDesc = Class(TantRunTimeDesc)}

{##############################################################################}
{******************************************************************************}
{##############################################################################}
Implementation
{##############################################################################}
{******************************************************************************}
{##############################################################################}


{##############################################################################}
{## TantRunTimeDesc = Class(TPersitent) #######################################}
{##############################################################################}
{******************************************************************************}
{** Public ********************************************************************}
{******************************************************************************}
{** Init/Done **}
{***************}
Constructor TantRunTimeDesc.Create(AOwner    : TComponent;
                                   ACallBack : TantDescCallBack);
Begin
  Owner    := AOwner;
  CallBack := ACallBack;
  Inherited Create;
End;{Constructor TantRunTimeDesc.Create}

{******************************************************************************}
{** Protected *****************************************************************}
{******************************************************************************}
{** Properties Routines **}
{*************************}
Procedure TantRunTimeDesc.SetRunTimeState(A : TantRunTimeState);
Begin
  if fRunTimeState = A
   then Exit;
  fRunTimeState := A;
End;{Procedure TantRunTimeDesc.SetRunTimeState}


{##############################################################################}
{## TantRunTimeBooleanDesc = Class(TantRunTimeDesc) ###########################}
{##############################################################################}
{******************************************************************************}
{** Public ********************************************************************}
{******************************************************************************}
{** Init/Done **}
{***************}
Constructor TantRunTimeBooleanDesc.CreateWithData(AOwner    : TComponent;
                                                  ACallBack : TantDescCallBack;
                                                  ANormal, ASelected, AActive, ADisabled : Boolean);
Begin
  Create(AOwner, ACallBack);
  fNormal   := ANormal;
  fSelected := ASelected;
  fActive   := AActive;
  fDisabled := ADisabled;
End;{Constructor TantRunTimeBooleanDesc.CreateWithData}

{******************************************************************************}
{** Protected *****************************************************************}
{******************************************************************************}
{** Properties Routines **}
{*************************}
Function  TantRunTimeBooleanDesc.GetCurrent : Boolean;
Begin
  case RunTimeState of
   rtsSelected : Result := fSelected;
   rtsActive   : Result := fActive;
   rtsDisabled : Result := fDisabled;
   else          Result := fNormal;
  end;{case RunTimeState of}
End;{Function  TantRunTimeBooleanDesc.GetCurrent}

Procedure TantRunTimeBooleanDesc.SetNormal(A : Boolean);
Begin
  if fNormal = A
   then Exit;
  fNormal := A;
  if Assigned(CallBack)
   then CallBack;
End;{Procedure TantRunTimeBooleanDesc.SetNormal}

Procedure TantRunTimeBooleanDesc.SetSelected(A : Boolean);
Begin
  if fSelected = A
   then Exit;
  fSelected := A;
  if Assigned(CallBack)
   then CallBack;
End;{Procedure TantRunTimeBooleanDesc.SetSelected}

Procedure TantRunTimeBooleanDesc.SetActive(A : Boolean);
Begin
  if fActive = A
   then Exit;
  fActive := A;
  if Assigned(CallBack)
   then CallBack;
End;{Procedure TantRunTimeBooleanDesc.SetActive}

Procedure TantRunTimeBooleanDesc.SetDisabled(A : Boolean);
Begin
  if fDisabled = A
   then Exit;
  fDisabled := A;
  if Assigned(CallBack)
   then CallBack;
End;{Procedure TantRunTimeBooleanDesc.SetDisabled}


{##############################################################################}
{## TantRunTimeColorDesc = Class(TantRunTimeDesc) #############################}
{##############################################################################}
{******************************************************************************}
{** Public ********************************************************************}
{******************************************************************************}
{** Init/Done **}
{***************}
Constructor TantRunTimeColorDesc.CreateWithData(AOwner    : TComponent;
                                                ACallBack : TantDescCallBack;
                                                ANormal, ASelected, AActive, ADisabled : TColor);
Begin
  Create(AOwner, ACallBack);
  fNormal   := ANormal;
  fSelected := ASelected;
  fActive   := AActive;
  fDisabled := ADisabled;
End;{Constructor TantRunTimeColorDesc.CreateWithData}

{******************************************************************************}
{** Protected *****************************************************************}
{******************************************************************************}
{** Properties Routines **}
{*************************}
Function  TantRunTimeColorDesc.GetCurrent : TColor;
Begin
  case RunTimeState of
   rtsSelected : Result := fSelected;
   rtsActive   : Result := fActive;
   rtsDisabled : Result := fDisabled;
   else          Result := fNormal;
  end;{case RunTimeState of}
End;{Function  TantRunTimeColorDesc.GetCurrent}

Procedure TantRunTimeColorDesc.SetNormal(A : TColor);
Begin
  if fNormal = A
   then Exit;
  fNormal := A;
  if Assigned(CallBack)
   then CallBack;
End;{Procedure TantRunTimeColorDesc.SetNormal}

Procedure TantRunTimeColorDesc.SetSelected(A : TColor);
Begin
  if fSelected = A
   then Exit;
  fSelected := A;
  if Assigned(CallBack)
   then CallBack;
End;{Procedure TantRunTimeColorDesc.SetSelected}

Procedure TantRunTimeColorDesc.SetActive(A : TColor);
Begin
  if fActive = A
   then Exit;
  fActive := A;
  if Assigned(CallBack)
   then CallBack;
End;{Procedure TantRunTimeColorDesc.SetActive}

Procedure TantRunTimeColorDesc.SetDisabled(A : TColor);
Begin
  if fDisabled = A
   then Exit;
  fDisabled := A;
  if Assigned(CallBack)
   then CallBack;
End;{Procedure TantRunTimeColorDesc.SetDisabled}


{##############################################################################}
{## TantRunTimeCursorDesc = Class(TantRunTimeDesc) ############################}
{##############################################################################}
{******************************************************************************}
{** Public ********************************************************************}
{******************************************************************************}
{** Init/Done **}
{***************}
Constructor TantRunTimeCursorDesc.CreateWithData(AOwner    : TComponent;
                                                 ACallBack : TantDescCallBack;
                                                 ANormal, ASelected, AActive, ADisabled : TCursor);
Begin
  Create(AOwner, ACallBack);
  fNormal   := ANormal;
  fSelected := ASelected;
  fActive   := AActive;
  fDisabled := ADisabled;
End;{Constructor TantRunTimeCursorDesc.CreateWithData}

{******************************************************************************}
{** Protected *****************************************************************}
{******************************************************************************}
{** Properties Routines **}
{*************************}
Function  TantRunTimeCursorDesc.GetCurrent : TCursor;
Begin
  case RunTimeState of
   rtsSelected : Result := fSelected;
   rtsActive   : Result := fActive;
   rtsDisabled : Result := fDisabled;
   else          Result := fNormal;
  end;{case RunTimeState of}
End;{Function  TantRunTimeCursorDesc.GetCurrent}


END{Unit AntDesc}.
