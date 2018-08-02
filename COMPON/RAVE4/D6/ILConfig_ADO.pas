unit ILConfig_ADO;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ILConfig, ExtCtrls, ComCtrls, ActnList;

type
  TformILConfigADO = class(TILConfig)
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    butnOk: TButton;
    butnCancel: TButton;
    ActionList1: TActionList;
    actnOk: TAction;
    radoDataLinkFile: TRadioButton;
    cmboDataLinkFile: TComboBox;
    radoConnectionString: TRadioButton;
    editConnectionString: TEdit;
    butnBrowseDataLinkFile: TButton;
    butnBuildConnectionString: TButton;
    procedure radoParamsClick(Sender: TObject);
    procedure actnOkUpdate(Sender: TObject);
    procedure butnBrowseDataLinkFileClick(Sender: TObject);
    procedure butnBuildConnectionStringClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  public
    class function Edit(var VDatasource, VOptions, VUsername, VPassword: string): boolean; override;
  end;

implementation
{$R *.DFM}

uses
  ADODB;

{ TformILConfigBDE }

class function TformILConfigADO.Edit(var VDatasource, VOptions, VUsername
 , VPassword: string): boolean;
const
  LFileNameIdent = 'FILE NAME=';
var
  LFileName: string;
begin
  with TFormILConfigADO.Create(nil) do try
    radoDataLinkFile.Checked := True;
    if SameText(Copy(VDataSource, 1, Length(LFileNameIdent)), LFileNameIdent) then begin
      LFileName := Copy(VDatasource, Length(LFileNameIdent) + 1, MaxInt);
      if SameText(ExtractFilePath(LFileName), DataLinkDir + '\') then begin
        cmboDataLinkFile.Text := ExtractFileName(LFileName)
      end else begin
        cmboDataLinkFile.Text := LFileName;
      end;
    end else begin
      editConnectionString.Text :=VDatasource;
      radoConnectionString.Checked := True;
    end;
    result := ShowModal = mrOK;
    if result then begin
      if radoConnectionString.Checked then begin
        VDatasource := Trim(editConnectionString.Text);
      end else if Length(Trim(cmboDataLinkFile.Text)) > 0 then begin
        if Length(ExtractFilePath(Trim((cmboDataLinkFile.Text)))) = 0 then begin
          VDatasource := LFileNameIdent + DataLinkDir + '\' + Trim(cmboDataLinkFile.Text);
        end else begin
          VDatasource := LFileNameIdent + cmboDataLinkFile.Text;
        end;
      end else begin
        VDatasource := '';
      end;
      VOptions := '';
      VUsername := '';
      VPassword := '';
    end;
  finally free; end;
end;

procedure TformILConfigADO.radoParamsClick(Sender: TObject);
begin
  cmboDataLinkFile.Enabled := radoDataLinkFile.Checked;
  butnBrowseDataLinkFile.Enabled := radoDataLinkFile.Checked;
  //
  editConnectionString.Enabled := radoConnectionString.Checked;
  butnBuildConnectionString.Enabled := radoConnectionString.Checked;
end;

procedure TformILConfigADO.actnOkUpdate(Sender: TObject);
begin
  actnOk.Enabled := (radoDataLinkFile.Checked and (Length(Trim(cmboDataLinkFile.Text)) > 0))
   or (radoConnectionString.Checked and (Length(Trim(editConnectionString.Text)) > 0))
end;

procedure TformILConfigADO.butnBrowseDataLinkFileClick(Sender: TObject);
var
  s: string;
begin
  s := PromptDataLinkFile(Handle, cmboDataLinkFile.Text);
  if SameText(ExtractFilePath(s), DataLinkDir + '\') then begin
    cmboDataLinkFile.Text := ExtractFileName(s)
  end else begin
    cmboDataLinkFile.Text := s;
  end;
end;

procedure TformILConfigADO.butnBuildConnectionStringClick(Sender: TObject);
begin
  editConnectionString.Text := PromptDataSource(Handle, editConnectionString.Text);
end;

procedure TformILConfigADO.FormCreate(Sender: TObject);
begin
  GetDataLinkFiles(cmboDataLinkFile.Items);
end;

procedure TformILConfigADO.FormShow(Sender: TObject);
begin
  radoParamsClick(Sender);
end;

end.