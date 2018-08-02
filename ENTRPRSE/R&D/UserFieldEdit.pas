unit UserFieldEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UserFieldConfig, EnterToTab, CheckBoxEx;

type
  TFrm_FieldEdit = class(TForm)
    Label1: TLabel;
    EBox_FCaption: TEdit;
    Btn_Cancel: TButton;
    Btn_OK: TButton;
    EnterToTab1: TEnterToTab;
    ChBox_FEnabled: TCheckBoxEx;
    cbContainsPIIData: TCheckBoxEx;
    procedure Btn_OKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    fUserFieldData : TNodeData;
  private
    formOwner : TFrm_UserFieldConfig;
  public
    procedure PopulateUserFieldData(owner : TFrm_UserFieldConfig; nodeFieldData : Pointer);
    property UserFieldData : TNodeData read fUserFieldData write fUserFieldData;
end;
var
  Frm_FieldEdit: TFrm_FieldEdit;
implementation

Uses ThemeFix;

{$R *.dfm}

procedure TFrm_FieldEdit.FormCreate(Sender: TObject);
begin
  // MH 08/11/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with fox on CheckBox
  ApplyThemeFix (Self);
  //ABSEXCH-20289: When amending screen size to medium, new password security and GDPR screens are distorted (125% Resolution Issue)
  if Screen.PixelsPerInch > 96 then
  begin
    ChBox_FEnabled.Width := ChBox_FEnabled.Width + 3;
    cbContainsPIIData.Width := cbContainsPIIData.Width + 3;
  end;
end;

procedure TFrm_FieldEdit.PopulateUserFieldData(owner : TFrm_UserFieldConfig; nodeFieldData : Pointer);
var
  NodeD : ^rTreeNodeData;
begin
  NodeD := nodeFieldData;
  UserFieldData := NodeD.NodeData;
  formOwner := owner;

  EBox_FCaption.Text := UserFieldData.Caption;
  ChBox_FEnabled.Enabled := UserFieldData.ChBoxEnabled;
  ChBox_FEnabled.Checked := UserFieldData.ChBoxChecked;

  //RB 16/2017 2018-R1 ABSEXCH-19282: GDPR -Extending UDF fields for PII flag
  cbContainsPIIData.Checked := UserFieldData.ContainsPIIData;
  if Not UserFieldData.PIIFieldVisible then
  begin
    cbContainsPIIData.Visible := False;
    Btn_OK.Top := Btn_OK.Top - 20;
    Btn_Cancel.Top := Btn_Cancel.Top - 20;
    Self.Height := Self.Height - 20;
  end;
end;

procedure TFrm_FieldEdit.Btn_OKClick(Sender: TObject);
begin
  UserFieldData.Caption := EBox_FCaption.Text;
  UserFieldData.ChBoxChecked := ChBox_FEnabled.Checked;
  UserFieldData.ContainsPIIData := cbContainsPIIData.Checked;
end;

end.
