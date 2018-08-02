unit AddNote;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, EnterToTab;

type
  TfrmAddNote = class(TForm)
    edText: TEdit;
    edDate: TDateTimePicker;
    Label1: TLabel;
    lDate: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    EnterToTab1: TEnterToTab;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAddNote: TfrmAddNote;

implementation

{$R *.dfm}

end.
