unit EnterTab;

interface

uses
  Windows, Messages, SysUtils, Classes;

type
  TComponent1 = class(TComponent)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SBS', [TComponent1]);
end;

end.
 