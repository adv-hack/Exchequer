unit actlabel;

{ markd6 10:35 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  tactivelabel = class(tlabel)
  private
    { Private declarations }

  protected
    { Protected declarations }
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('sbs', [tactivelabel]);
end;

procedure tactivelabel.WMSetCursor(var Msg: TWMSetCursor);
begin
  Color := clRed;
end;

end.
