unit Exprep1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, CustAbsU;

type
  TfrmExportReport1 = class(TForm)
    Button1: TButton;
    ReportMemo: TMemo;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure ShowExportReport(const Cap : string; Messages : TStrings);



implementation

{$R *.DFM}


procedure ShowExportReport(const Cap : string; Messages : TStrings);
var
  frmExportReport : TfrmExportReport1;
begin
  frmExportReport := TfrmExportReport1.Create(Application);
  with frmExportReport do
  begin
   Try
    Caption := cap;
    ReportMemo.Lines.AddStrings(Messages);
    ShowModal;
   Finally
    Free;
   End;
  end;
end;

procedure TfrmExportReport1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If (Shift = []) And (Key = VK_Escape) Then Close;
end;

end.
