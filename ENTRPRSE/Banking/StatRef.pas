unit StatRef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, TEditVal, TCustom, ExtCtrls, EnterToTab;

type
  TfrmGetStatRef = class(TForm)
    SBSButton1: TSBSButton;
    SBSButton2: TSBSButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    edDate: TEditDate;
    Label3: TLabel;
    edtRef: Text8Pt;
    EnterToTab1: TEnterToTab;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGetStatRef: TfrmGetStatRef;

  function GetStatementReference(var DefRef : string; var StatDate : string) : Boolean;

implementation

{$R *.dfm}
uses
  EtDateU, ApiUtil;

  function GetStatementReference(var DefRef : string; var StatDate : string) : Boolean;
  begin
    with TfrmGetStatRef.Create(Application.MainForm) do
    Try
      ActiveControl := edDate;
      ShowModal;
      Result := ModalResult = mrOK;
      if ModalResult = mrOK then
      begin
        if Trim(edtRef.Text) <> '' then
          DefRef := edtRef.Text;
        StatDate := edDate.DateValue;
      end;

    Finally
      Free;
    End;
  end;

procedure TfrmGetStatRef.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult <> mrOK then
    CanClose := msgbox('Are you sure you want to cancel the import?', mtConfirmation,
                       [mbYes, mbNo], mbYes, 'Import Bank Statement') = IDYES;
end;

end.
