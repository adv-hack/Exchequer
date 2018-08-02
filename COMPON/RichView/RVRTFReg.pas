unit RVRTFReg;

interface

procedure Register;

implementation
uses Classes, RVRTF;

procedure Register;
begin
  RegisterComponents(RVPalettePage, ['RichView']);
end;

end.
