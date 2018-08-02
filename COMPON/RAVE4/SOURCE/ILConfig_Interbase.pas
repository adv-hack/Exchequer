unit ILConfig_Interbase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ILConfig, ExtCtrls, ComCtrls, ActnList;

type
  TformILConfigInterbase = class(TILConfig)
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
    Label1: TLabel;
    lablServer: TLabel;
    Label5: TLabel;
    cmboProtocol: TComboBox;
    editServer: TEdit;
    editFile: TEdit;
    butnBrowseFile: TButton;
    odlgDatabase: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure actnOkUpdate(Sender: TObject);
    procedure cmboProtocolChange(Sender: TObject);
    procedure butnBrowseFileClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  public
    class function Edit(var VDatasource, VOptions, VUsername, VPassword: string): boolean; override;
  end;

implementation
{$R *.DFM}

type
  TIBProtocol = (ipLocal, ipTCPIP, ipNetBios);

{ TformILConfigBDE }

class function TformILConfigInterbase.Edit(var VDatasource, VOptions, VUsername
 , VPassword: string): boolean;
var
  i: Integer;
  s: String;
begin
  with TFormILConfigInterbase.Create(nil) do try
    s := VDatasource;
    i := Pos(':', s);
    if Copy(s, 1, 2) = '\\' then begin
      Delete(s, 1, 2);
      i := Pos('\', s);
      if i > 0 then begin
        editServer.Text := Copy(s, 1, i - 1);
        editFile.Text := Copy(s, i + 1, MaxInt);
        cmboProtocol.ItemIndex := cmboProtocol.Items.IndexOfObject(TObject(ipNetBios));
      end else begin
        editFile.Text := VDatasource;
      end;
    end else if Pos(':', Copy(s, i + 1, MaxInt)) > 0 then begin
      editServer.Text := Copy(s, 1, i - 1);
      editFile.Text := Copy(s, i + 1, MaxInt);
      cmboProtocol.ItemIndex := cmboProtocol.Items.IndexOfObject(TObject(ipTCPIP));
    end else begin
      editFile.Text := VDatasource;
    end;
    editUsername.Text := VUsername;
    editPassword.Text := VPassword;
    result := ShowModal = mrOK;
    if result then begin
      case TIBProtocol(cmboProtocol.Items.Objects[cmboProtocol.ItemIndex]) of
        ipLocal: VDatasource := Trim(editFile.Text);
        ipTCPIP: VDataSource := Trim(editServer.Text) + ':' + Trim(editFile.Text);
        ipNetBios: VDataSource := '\\' + Trim(editServer.Text) + '\' + Trim(editFile.Text);
      end;
      VOptions := '';
      VUsername := editUsername.Text;
      VPassword := editPassword.Text;
    end;
  finally free; end;
end;

procedure TformILConfigInterbase.FormCreate(Sender: TObject);
begin
  with cmboProtocol.Items do begin
    cmboProtocol.ItemIndex := AddObject('Local', TObject(ipLocal));
    AddObject('TCP/IP', TObject(ipTCPIP));
    AddObject('NetBios', TObject(ipNetBios));
  end;
end;

procedure TformILConfigInterbase.actnOkUpdate(Sender: TObject);
begin
  if TIBProtocol(cmboProtocol.Items.Objects[cmboProtocol.ItemIndex]) = ipLocal then begin
    actnOk.Enabled := Length(Trim(editFile.Text)) > 0;
  end else begin
    actnOk.Enabled := (Length(Trim(editFile.Text)) > 0) and (Length(Trim(editServer.Text)) > 0);
  end;
end;

procedure TformILConfigInterbase.cmboProtocolChange(Sender: TObject);
begin
  lablServer.Enabled := TIBProtocol(cmboProtocol.Items.Objects[cmboProtocol.ItemIndex]) <> ipLocal;
  editServer.Enabled := lablServer.Enabled;
  butnBrowseFile.Enabled := not lablServer.Enabled;
end;

procedure TformILConfigInterbase.butnBrowseFileClick(Sender: TObject);
begin
  odlgDatabase.InitialDir := ExtractFilePath(Trim(editFile.Text));
  if odlgDatabase.Execute then begin
    editFile.Text := odlgDatabase.Filename;
  end;
end;

procedure TformILConfigInterbase.FormShow(Sender: TObject);
begin
  cmboProtocolChange(Sender);
end;

end.