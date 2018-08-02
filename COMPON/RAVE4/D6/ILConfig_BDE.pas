unit ILConfig_BDE;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ILConfig, ExtCtrls, ComCtrls, ActnList;

type
  TformILConfigBDE = class(TILConfig)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    editUsername: TEdit;
    editPassword: TEdit;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    butnOk: TButton;
    butnCancel: TButton;
    gboxAlias: TGroupBox;
    gboxParams: TGroupBox;
    radoAlias: TRadioButton;
    radoParams: TRadioButton;
    Label1: TLabel;
    cmboAlias: TComboBox;
    Label2: TLabel;
    cmboDriver: TComboBox;
    Label5: TLabel;
    memoParams: TMemo;
    ActionList1: TActionList;
    actnOk: TAction;
    procedure FormCreate(Sender: TObject);
    procedure radoParamsClick(Sender: TObject);
    procedure actnOkUpdate(Sender: TObject);
  private
  public
    class function Edit(var VDatasource, VOptions, VUsername, VPassword: string): boolean; override;
  end;

implementation
{$R *.DFM}

uses
  DBTables;

{ TformILConfigBDE }

class function TformILConfigBDE.Edit(var VDatasource, VOptions, VUsername
 , VPassword: string): boolean;
var
  s: string;
begin
  with TFormILConfigBDE.Create(nil) do try
    with TStringList.Create do try
      CommaText := VDatasource;
      s := Values['Alias'];
      if length(s) > 0 then begin
        Values['Alias'] := '';
        radoAlias.Checked := True;
        cmboAlias.ItemIndex := cmboAlias.Items.IndexOf(s);
      end else begin
        s := Values['Driver'];
        if length(s) > 0 then begin
          Values['Driver'] := '';
          radoParams.Checked := True;
          cmboDriver.ItemIndex := cmboDriver.Items.IndexOf(s);
          memoParams.Text := Text;
        end;
      end;
    finally free; end;
    editUsername.Text := VUsername;
    editPassword.Text := VPassword;
    result := ShowModal = mrOK;
    if result then begin
      if radoAlias.Checked then begin
        VDatasource := 'Alias=' + cmboAlias.Items[cmboAlias.ItemIndex];
      end else begin
        VDatasource := '"Driver=' + cmboDriver.Items[cmboDriver.ItemIndex] + '",'
         + memoParams.Lines.CommaText;
      end;
      VOptions := '';
      VUsername := editUsername.Text;
      VPassword := editPassword.Text;
    end;
  finally free; end;
end;

procedure TformILConfigBDE.FormCreate(Sender: TObject);
begin
  Session.GetAliasNames(cmboAlias.Items);
  Session.GetDriverNames(cmboDriver.Items);
end;

procedure TformILConfigBDE.radoParamsClick(Sender: TObject);

  procedure SetEnabled(AGroupBox: TGroupBox; const AEnabled: boolean);
  var
    i: integer;
  begin
    with AGroupBox do begin
      Enabled := AEnabled;
      for i := 0 to ControlCount - 1 do begin
        Controls[i].Enabled := AEnabled;
      end;
    end;
  end;

begin
  SetEnabled(gboxAlias, radoAlias.Checked);
  SetEnabled(gboxParams, radoParams.Checked);
end;

procedure TformILConfigBDE.actnOkUpdate(Sender: TObject);
begin
  actnOk.Enabled := (radoAlias.Checked and (cmboAlias.ItemIndex > -1))
   or (radoParams.Checked and (cmboDriver.ItemIndex > -1));
end;

end.
