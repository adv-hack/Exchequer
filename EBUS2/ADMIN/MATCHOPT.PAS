unit matchopt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, dtpick;

type
  TfrmMatchOptions = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    chkAc: TCheckBox;
    edtAcCode1: TEdit;
    edtAcCode2: TEdit;
    chkStock: TCheckBox;
    edtStockCode1: TEdit;
    edtStockCode2: TEdit;
    chkDate: TCheckBox;
    dtpDate1: TExtendedDateTimePicker;
    dtpDate2: TExtendedDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    procedure dtpDate1DropDown(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMatchOptions: TfrmMatchOptions;

implementation

{$R *.dfm}

procedure TfrmMatchOptions.dtpDate1DropDown(Sender: TObject);
var
  Wnd :HWND;
  Style : integer;
//Turn off ShowToday & ShowTodayCircle on the dropdown calendar.
begin
  if Sender is TExtendedDateTimePicker then
    with Sender as TExtendedDateTimePicker do
    begin
      Wnd := CalendarHandle;
      Style := GetWindowLong(Wnd, GWL_STYLE);
      Style := Style or 24;
      SetWindowLong(Wnd, GWL_STYLE, Style);
    end;
end;

end.
