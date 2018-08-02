unit ILConfig_ODBC;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ILConfig, StdCtrls, ComCtrls, ExtCtrls, OVCL;

type
  TformILConfigODBC = class(TILConfig)
    Panel1: TPanel;
    butnOk: TButton;
    butnCancel: TButton;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    gboxParams: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    memoParams: TMemo;
    TabSheet1: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    editUsername: TEdit;
    editPassword: TEdit;
    cbDataSource: TDSComboBox;
    procedure FormCreate(Sender: TObject);
  public
    class function Edit(var VDatasource, VOptions, VUsername, VPassword: string): boolean; override;
  end;

var
  formILConfigODBC: TformILConfigODBC;

implementation
{$R *.DFM}
uses
  LinkIL_ODBC;

{ TformILConfigODBC }

class function TformILConfigODBC.Edit(var VDatasource, VOptions, VUsername,
  VPassword: string): boolean;
begin
  with TFormILConfigODBC.Create(nil) do try
    cbDataSource.ItemIndex := cbDataSource.Items.IndexOf(VDataSource);
    memoParams.Text := VOptions;
    editUsername.Text := VUsername;
    editPassword.Text := VPassword;
    result := ShowModal = mrOK;
    if result then begin
      VDatasource := cbDataSource.Text;
      VOptions := memoParams.Text;
      VUsername := editUsername.Text;
      VPassword := editPassword.Text;
    end;
  finally free; end;
end;


procedure TformILConfigODBC.FormCreate(Sender: TObject);
begin
  cbDataSource.Populate;
end;

end.
