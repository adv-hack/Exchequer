unit ILConfig_Advantage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ILConfig, ExtCtrls, ComCtrls, ActnList, Db, AdsData, AdsFunc,
  AdsTable;

type
  TformILConfigAdvantage = class(TILConfig)
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
    ActionList1: TActionList;
    actnOk: TAction;
    Label5: TLabel;
    editPath: TEdit;
    butnBrowseFile: TButton;
    Label2: TLabel;
    Label6: TLabel;
    cmboType: TComboBox;
    GroupBox1: TGroupBox;
    ckbxLocalServer: TCheckBox;
    ckbxRemoteServer: TCheckBox;
    ckbxAISServer: TCheckBox;
    AdsQuery1: TAdsQuery;
    procedure actnOkUpdate(Sender: TObject);
    procedure butnBrowseFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
    class function Edit(var VDatasource, VOptions, VUsername, VPassword: string): boolean; override;
  end;

type
  TAdvDatabaseType = (atCDX, atADT);

const
  AdvDatabaseTypes: array[TAdvDatabaseType] of string = ('DBF','ADT');

implementation

{$R *.DFM}

uses
  FileCtrl;

{ TformILConfigBDE }

class function TformILConfigAdvantage.Edit(var VDatasource, VOptions, VUsername, VPassword: string): boolean;
var
  OptionList: TStringList;
begin
  with TFormILConfigAdvantage.Create(nil) do try
    editPath.Text := VDatasource;

  // Options
    OptionList := TStringList.Create;
    try
      if Length(VOptions) = 0 then begin
        cmboType.ItemIndex := 0;
        ckbxLocalServer.Checked := True;
        ckbxRemoteServer.Checked := True;
        ckbxAISServer.Checked := True;
      end else begin
        OptionList.CommaText := VOptions;

      // Server types
        ckbxLocalServer.Checked := Pos('L',OptionList.Values['ServerTypes']) > 0;
        ckbxRemoteServer.Checked := Pos('R',OptionList.Values['ServerTypes']) > 0;
        ckbxAISServer.Checked := Pos('A',OptionList.Values['ServerTypes']) > 0;
      // Database type
        cmboType.ItemIndex := cmboType.Items.IndexOf(OptionList.Values['DatabaseType']);
      end;
    finally
      OptionList.Free;
    end; { tryf }

    editUsername.Text := VUsername;
    editPassword.Text := VPassword;

    Result := ShowModal = mrOK;
    if Result then begin
      VDatasource := Trim(editPath.Text);

      VOptions := 'ServerTypes=';
      If ckbxLocalServer.Checked then begin
        VOptions := VOptions + 'L';
      end; { if }
      If ckbxRemoteServer.Checked then begin
        VOptions := VOptions + 'R';
      end; { if }
      If ckbxAISServer.Checked then begin
        VOptions := VOptions + 'A';
      end; { if }
      VOptions := VOptions + ',DatabaseType=' + cmboType.Items[cmboType.ItemIndex];

      VUsername := editUsername.Text;
      VPassword := editPassword.Text;
    end;
  finally free; end;
end;

procedure TformILConfigAdvantage.actnOkUpdate(Sender: TObject);
begin
  actnOk.Enabled := Length(Trim(editPath.Text)) > 0;
end;

procedure TformILConfigAdvantage.butnBrowseFileClick(Sender: TObject);
var
  s: string;
begin
  if SelectDirectory('Select Connection Path', '', s) then begin
    editPath.Text := s;
  end;
end;

procedure TformILConfigAdvantage.FormCreate(Sender: TObject);
var
  DBType: TAdvDatabaseType;
begin
  for DBType := Low(DBType) to High(DBType) do begin
    cmboType.Items.Add(AdvDatabaseTypes[DBType]);
  end;
end;

end.
