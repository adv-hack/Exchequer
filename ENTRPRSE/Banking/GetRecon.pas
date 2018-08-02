unit GetRecon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uExDatasets, uBtrieveDataset, uMultiList, uDBMultiList,
  ExtCtrls, StdCtrls, TCustom, VarRec2U, uSettings, Menus, EnterToTab;

type
  TfrmSelectReconcile = class(TForm)
    Panel1: TPanel;
    mlRec: TDBMultiList;
    btdRec: TBtrieveDataset;
    PopupMenu1: TPopupMenu;
    Properties1: TMenuItem;
    N1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    EnterToTab1: TEnterToTab;
    Panel3: TPanel;
    btnDelete: TSBSButton;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    procedure btdRecGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure FormCreate(Sender: TObject);
    procedure mlRecRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btdRecFilterRecord(Sender: TObject; PData: Pointer;
      var Include: Boolean);
    procedure btnDeleteClick(Sender: TObject);
    procedure mlRecAfterLoad(Sender: TObject);
  private
    { Private declarations }
     bRestore : Boolean;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
  public
    { Public declarations }
    ReconcileRef : String;
  end;

  function GetReconciliation(const UserID : String; GLCode : longint;
                             const ReconRef : String; var BankRec : BnkRHRecType) : Boolean;

var
  frmSelectReconcile: TfrmSelectReconcile;

implementation

{$R *.dfm}
uses
  VarConst, BtKeys1U, BtrvU2, EtStru, GlobVar, EtDateU, ReconObj, Enterprise04_TLB;

function GetReconciliation(const UserID : String; GLCode : longint;
                           const ReconRef : String; var BankRec : BnkRHRecType) : Boolean;
var
  P : MLocPtr;
  Res : Integer;
begin
  Result := (Trim(ReconRef) <> '') and (ReconcileObj.FindByRef(ReconRef, GLCode, BankRec) = 0);
  if not Result then
  begin
    frmSelectReconcile := TfrmSelectReconcile.Create(Application.MainForm);
    with frmSelectReconcile do
    Try
//      btdRec.SearchKey := LteBankRCode + '1' + FullNomKey(GLCode) + LJVar(UserID, 10);
      btdRec.SearchKey := LteBankRCode + '1' + FullNomKey(GLCode);
      btdRec.FileName := SetDrive + Filenames[MLocF];
      ReconcileRef := ReconRef;
      mlRec.Active := True;
      mlRec.SortColumn(0, False);
      ShowModal;
      Result := ModalResult = mrOK;

      if Result then
      begin
        P := btdRec.GetRecord;
        BankRec := P^.BnkRHRec;
      end;
    Finally
      Free;
    End;
  end;
end;


procedure TfrmSelectReconcile.btdRecGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
var
  pML : ^MLocRec;
begin
  pML := PData;
  with pML^ do
  begin
    Case FieldName[1] of
      'D'  :  FieldValue := POutDate(BnkRHRec.brReconDate);
      'R'  :  FieldValue := BnkRHRec.brReconRef;
      'U'  :  FieldValue := Trim(BnkRHRec.brUserID);
    end;
  end;
end;

procedure TfrmSelectReconcile.FormCreate(Sender: TObject);
begin
  sMiscDirLocation := SetDrive;
  oSettings.EXEName := ExtractFilename(GetModuleName(HInstance));
  oSettings.UserName := GetUserID;
  bRestore := False;
  LoadAllSettings;
end;

procedure TfrmSelectReconcile.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadList(mlRec, Self.Name);
end;

procedure TfrmSelectReconcile.SaveAllSettings;
begin
  oSettings.SaveList(mlRec, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;

procedure TfrmSelectReconcile.mlRecRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  if RowIndex >= 0 then
    btnOK.Click;
end;

procedure TfrmSelectReconcile.btdRecFilterRecord(Sender: TObject;
  PData: Pointer; var Include: Boolean);
var
  MData : MLocPtr;
begin
  MData := PData;

  Include := (ReconcileRef = '') or (Pos(ReconcileRef, MData.bnkRHRec.brReconRef) > 0);
end;

procedure TfrmSelectReconcile.btnDeleteClick(Sender: TObject);
var
  MData : MLocPtr;
begin
  MData := btdRec.GetRecord;
  if Assigned(MData) then
    if ReconcileObj.FindByFolio(MData.BnkRHRec) = 0 then
    begin
      ReconcileObj.Delete;
      mlRec.RefreshDB;
    end;
end;

procedure TfrmSelectReconcile.mlRecAfterLoad(Sender: TObject);
begin
  btnDelete.Enabled := mlRec.ItemsCount > 0;
  btnOk.Enabled := mlRec.ItemsCount > 0;
  btnCancel.Default := not btnOK.Enabled;
end;

end.
