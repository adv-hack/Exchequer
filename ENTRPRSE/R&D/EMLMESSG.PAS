unit EmlMessg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal;

type
  TfrmEmailDetails = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Label817: Label8;
    Label818: Label8;
    memMessage: TMemo;
    edtSubject: Text8Pt;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

Uses BTSupU2;

procedure TfrmEmailDetails.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  BTSupU2.GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TfrmEmailDetails.FormKeyPress(Sender: TObject; var Key: Char);
begin
  BTSupU2.GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

end.
