unit dtpick;

interface

uses
  Classes, ComCtrls, Windows;

Type
  TExtendedDateTimePicker = Class(TDateTimePicker)
  public
    property CalendarHandle : HWND read GetCalendarHandle;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TExtendedDateTimePicker]);
end;

end.
