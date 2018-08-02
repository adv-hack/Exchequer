unit RecFind;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, TEditVal, StdCtrls, TCustom, ExtCtrls, EnterToTab;

type
  TfrmRecFind = class(TForm)
    Panel1: TPanel;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    Label1: TLabel;
    ceAmount: TCurrencyEdit;
    edtDate: TEditDate;
    Label2: TLabel;
    EnterToTab1: TEnterToTab;
    edtDocNo: Text8Pt;
    cbFindBy: TSBSComboBox;
    procedure cbFindByChange(Sender: TObject);
    procedure edtDocNoExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRecFind: TfrmRecFind;

implementation

{$R *.dfm}
uses
  InvListU, GlobVar, SbsComp2;


procedure TfrmRecFind.cbFindByChange(Sender: TObject);
begin
  edtDocNo.Enabled := False;
  ceAmount.Enabled := False;
  edtDate.Enabled := False;
  Case cbFindBy.ItemIndex of
    0,
    1, 4, 5 : begin
             edtDocNo.Enabled := True;
             edtDocNo.BringToFront;
             if cbFindBy.ItemIndex in [4..5] then //HV 20/04/2016 2016-R2 ABSEXCH-10220: Find by reference only allows search in Upper case. Will not find lower case references
               edtDocNo.CharCase := ecNormal
             else
               edtDocNo.CharCase := ecUpperCase;
           end;
    2    : begin
             ceAmount.Enabled := True;
             ceAmount.BringToFront;
           end;
    3    : begin
             edtDate.Enabled := True;
             edtDate.BringToFront;
           end;  
  end;

end;

procedure TfrmRecFind.edtDocNoExit(Sender: TObject);
var
  AccountFound : Boolean;
  s : Str20;
begin
(*  if (cbFindBy.ItemIndex = 1) and (ActiveControl <> btnCancel) then //Popup cust/supp list
  begin
    s := Trim(edtDocNo.Text);
    AccountFound := GetCust(Self{Application.MainForm}, s, s, True, -1);

    if not AccountFound then
      AccountFound := GetCust(Self{Application.MainForm}, s, s, True, 99);

    if AccountFound then
      edtDocNo.Text := s
    else
      ActiveControl := edtDocNo;
  end;
*)
end;

procedure TfrmRecFind.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LastValueObj.UpdateAllLastValuesFull(Self);
end;

procedure TfrmRecFind.FormCreate(Sender: TObject);
begin
  LastValueObj.GetAllLastValuesFull(Self);
end;

end.
