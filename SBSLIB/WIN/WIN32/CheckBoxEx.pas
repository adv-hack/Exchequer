Unit CheckBoxEx;

Interface

uses
  Windows, Messages, SysUtils, Classes, StdCtrls;

type
  TCheckBoxEx = Class(TCheckBox)
  private
    FModified : Boolean;
    FReadOnly : Boolean;
  protected
    procedure Toggle; Override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    Property Modified : Boolean Read FModified Write FModified;
    Property ReadOnly : Boolean Read FReadOnly Write FReadOnly;
  End; // TCheckBoxEx

Procedure Register;

Implementation

//=========================================================================

Procedure Register;
Begin // Register
  RegisterComponents('SBS', [TCheckBoxEx]);
End; // Register

//=========================================================================

Constructor TCheckBoxEx.Create(AOwner: TComponent);
Begin // Create
  Inherited Create (AOwner);

  FModified := False;
  FReadOnly := False;
End; // Create

//-------------------------------------------------------------------------

procedure TCheckBoxEx.Toggle;
Begin // Toggle
  If Not FReadOnly Then
  Begin
    // Copy of TCustomCheckBox.Toggle in StdCtrls.pas
    case State of
      cbUnchecked : if AllowGrayed then State := cbGrayed else State := cbChecked;
      cbChecked   : State := cbUnchecked;
      cbGrayed    : State := cbChecked;
    end;

    FModified := True;
  End; // If Not FReadOnly
End; // Toggle

//=========================================================================

End.