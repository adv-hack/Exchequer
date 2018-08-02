unit DIBLLinkMain;

interface

uses
  ILRegister,
  Windows;

// Procs
  procedure Init(AAppHandle: THandle; ARegItem: TILLinkRegistrationItem);

exports
  Init;

implementation

uses
  Forms,
  SysUtils;

procedure Init(AAppHandle: THandle; ARegItem: TILLinkRegistrationItem);
begin
  Application.Handle := AAppHandle;
  if GILLinks.Count = 0 then begin
    Raise Exception.Create('Library contains no links.');
  end else if GILLinks.Count > 1 then begin
    Raise Exception.Create('Library contains more than one link.');
  end else begin
    ARegItem.Assign(GILLinks.Items[0]);
  end;
end;

end.
