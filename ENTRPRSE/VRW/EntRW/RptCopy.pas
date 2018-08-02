unit RptCopy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TEditVal, EnterToTab;

type
  TfrmCopyReportMode = (crmCopy, crmImport);
  TfrmCopyReport = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lbledtReportDesc: TLabeledEdit;
    lbledtReportName: TLabeledEdit;
    EnterToTab1: TEnterToTab;
    Label81: Label8;
    procedure lbledtReportNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    FMode: TfrmCopyReportMode;
    procedure SetMode(const Value: TfrmCopyReportMode);
    { Private declarations }
  public
    { Public declarations }
    property Mode: TfrmCopyReportMode
      read FMode write SetMode;
  end;

{var
  frmCopyReport: TfrmCopyReport;}

implementation

{$R *.dfm}

procedure TfrmCopyReport.FormCreate(Sender: TObject);
begin
  Mode := crmCopy;
end;

procedure TfrmCopyReport.lbledtReportNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  If (Not (Key In [#8, #9, #10, #13, '0'..'9', 'A'..'Z', 'a'..'z'])) Then
  Begin
    Key := #0;
  End; // If (Not (Key In [#8, #9, #10, #13, '0'..'9', 'A'..'Z', 'a'..'z']))
end;

procedure TfrmCopyReport.SetMode(const Value: TfrmCopyReportMode);
begin
  FMode := Value;
  if Mode = crmImport then
  begin
    Caption := 'Import Report';
    Label81.Caption := 'Enter the Report Name and Description to be used ' +
                       'for the imported report';
  end
  else
  begin
    Caption := 'Copy Report';
    Label81.Caption := 'Enter the Report Name and Description to be used ' +
                       'for the copy of the report';
  end;
end;

end.
