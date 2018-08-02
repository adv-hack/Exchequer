unit RptTreeEdt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RptEngDLL, EnterToTab;

type
  TfrmHeaderEdit = class(TForm)
    memNodeDescription: TLabeledEdit;
    lbledtHeading: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    EnterToTab1: TEnterToTab;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FOnValidateName: TValidateReportNameFn;
    FOriginalName: string;
    function Validate: Boolean;
  public
    { Public declarations }
    property OnValidateName: TValidateReportNameFn
      read FOnValidateName
      write FOnValidateName;
  end;

{var
  frmHeaderEdit: TfrmHeaderEdit;}

implementation

{$R *.dfm}

procedure TfrmHeaderEdit.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmHeaderEdit.btnOKClick(Sender: TObject);
begin
  if Validate then
    ModalResult := mrOk;
end;

procedure TfrmHeaderEdit.FormCreate(Sender: TObject);
begin
  FOriginalName := lbledtHeading.Text;
end;

function TfrmHeaderEdit.Validate: Boolean;
var
  ReportName: string;
  NameHasChanged, IsValid: Boolean;
begin
  IsValid := True;
  ReportName := Trim(lbledtHeading.Text);
  NameHasChanged := not SameText(FOriginalName, ReportName);
  if (ReportName = '') then
  begin
    ShowMessage('The name cannot be blank');
    lbledtHeading.SetFocus;
    IsValid := False;
  end
  else if NameHasChanged and Assigned(FOnValidateName) then
  begin
    OnValidateName(ReportName, IsValid);
    if not IsValid then
    begin
      ShowMessage('A group heading already exists against this name');
      lbledtHeading.SetFocus;
    end;
  end;
  Result := IsValid;
end;

end.
