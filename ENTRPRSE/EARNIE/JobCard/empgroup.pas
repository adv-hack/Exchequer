unit empgroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ExtCtrls, Enterprise01_TLB, Mask, TEditVal;

type
  TfrmEmpGroup = class(TForm)
    Panel1: TPanel;
    SBSButton1: TSBSButton;
    btnCancel: TSBSButton;
    cbAcGroup: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SBSButton3: TSBSButton;
    edtCode: TEdit;
    edtEmpName: Text8Pt;
    procedure SBSButton3Click(Sender: TObject);
    procedure edtCodeExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    CompCode : string;
    procedure FillLists;
  end;


implementation

{$R *.dfm}
uses
  JcVar, Groups, Emplkup, JcFuncs;


procedure TfrmEmpGroup.FillLists;
begin
//  FillEmpList;
  cbAcGroup.Items.AddStrings(GroupList);
  cbAcGroup.ItemIndex := 0;
end;

procedure TfrmEmpGroup.SBSButton3Click(Sender: TObject);
var
 OldText : string;

begin
  with TfrmGroupList.Create(nil) do
  Try
    OldText := cbAcGroup.Text;
    lbGroups.Items.AddStrings(GroupList);
    ShowModal;
    if ModalResult = mrOK then
    begin
      GroupList.Clear;
      GroupList.AddStrings(lbGroups.Items);
      cbAcGroup.Items.Clear;
      cbAcGroup.Items.AddStrings(GroupList);
      cbAcGroup.ItemIndex := cbAcGroup.Items.IndexOf(OldText);
    end;
  Finally
    Free;
  End;
end;

procedure TfrmEmpGroup.edtCodeExit(Sender: TObject);
begin
  if (ActiveControl <> btnCancel) then
       CheckEmpCode(Sender as TEdit, CompCode);
  if ActiveControl <> edtCode then
    edtEmpName.Text := oToolkit.JobCosting.Employee.emName;
end;

procedure TfrmEmpGroup.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TfrmEmpGroup.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

end.
