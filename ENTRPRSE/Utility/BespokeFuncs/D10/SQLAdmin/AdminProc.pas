unit AdminProc;

interface
uses
  stdCtrls, controls, Graphics;

  procedure ColourControlForErrors(TheControl : TControl; bError : boolean);

var
  bLoggedIn : boolean;

implementation

procedure ColourControlForErrors(TheControl : TControl; bError : boolean);
var
  NewColor : TColor;
begin
  if bError then NewColor := clRed
  else NewColor := clBlack;

  if TheControl is TLabel then TLabel(TheControl).Font.Color := NewColor;
  if TheControl is TEdit then TEdit(TheControl).Font.Color := NewColor;
end;

end.
