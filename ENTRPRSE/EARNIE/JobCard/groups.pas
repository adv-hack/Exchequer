unit groups;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom;

type
  TfrmGroupList = class(TForm)
    lbGroups: TListBox;
    SBSButton1: TSBSButton;
    SBSButton2: TSBSButton;
    SBSButton3: TSBSButton;
    SBSButton4: TSBSButton;
    SBSButton5: TSBSButton;
    procedure SBSButton1Click(Sender: TObject);
    procedure SBSButton2Click(Sender: TObject);
    procedure SBSButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGroupList: TfrmGroupList;

implementation

{$R *.dfm}
uses
   AccGroup, jcVar;

procedure TfrmGroupList.SBSButton1Click(Sender: TObject);
begin
  with TfrmAccGroup.Create(nil) do
  Try
    ShowModal;
    if ModalResult = mrOK then
      lbGroups.Items.Add(edtAccGroup.Text);
  Finally
    Free;
  End;

end;

procedure TfrmGroupList.SBSButton2Click(Sender: TObject);
var
  i  : integer;
begin
  i := lbGroups.ItemIndex;
  if i >= 0 then
  begin
    with TfrmAccGroup.Create(nil) do
    Try
      edtAccGroup.Text := lbGroups.Items[i];
      ShowModal;
      if ModalResult = mrOK then
      begin
        lbGroups.Items[i] := edtAccGroup.Text;
        lbGroups.Sorted := True;
      end;
    Finally
      Free;
    End;
  end;
end;

procedure TfrmGroupList.SBSButton3Click(Sender: TObject);
var
  i : integer;
begin
  i := lbGroups.ItemIndex;
  if i >= 0 then
    lbGroups.Items.Delete(i);
end;

end.
