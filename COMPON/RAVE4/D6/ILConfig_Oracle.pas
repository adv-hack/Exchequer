unit ILConfig_Oracle;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ILConfig, StdCtrls, ExtCtrls, ActnList, ComCtrls;

type
  TformILConfigOracle = class(TILConfig)
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    Label5: TLabel;
    TabSheet1: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    editUsername: TEdit;
    editPassword: TEdit;
    ActionList1: TActionList;
    actnOk: TAction;
    Panel1: TPanel;
    butnOk: TButton;
    butnCancel: TButton;
    cboxDatabase: TComboBox;
    procedure actnOkUpdate(Sender: TObject);
  private
  public
    class function Edit(var VDatasource, VOptions, VUsername, VPassword: string): boolean; override;
  end;

var
  formILConfigOracle: TformILConfigOracle;

implementation

uses
  OracleCI;

{$R *.DFM}

{ TformILConfigOracle }

class function TformILConfigOracle.Edit(var VDatasource, VOptions,
                                            VUsername, VPassword: string): boolean;
begin
  With TformILConfigOracle.Create(nil) do try
    cboxDatabase.Items.Assign(OracleAliasList);
    cboxDatabase.ItemIndex := cboxDatabase.Items.IndexOf(VDatasource);
    editUsername.Text := VUsername;
    editPassword.Text := VPassword;
    Result := ShowModal = mrOK;
    If Result then begin
      VDatasource := Trim(cboxDatabase.Text);
      VOptions := '';
      VUsername := editUsername.Text;
      VPassword := editPassword.Text;
    end; { if }
  finally
    Free;
  end; { with }
end;

procedure TformILConfigOracle.actnOkUpdate(Sender: TObject);
begin
  actnOk.Enabled := Length(Trim(cboxDatabase.Text)) > 0;
end;

end.
