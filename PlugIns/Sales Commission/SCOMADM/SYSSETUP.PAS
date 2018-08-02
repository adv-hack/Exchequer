unit SysSetup;

{ nfrewer440 16:57 09/07/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uMultiList, ComCtrls, uDBMultiList, SCTDet, VarConst,
  uExDatasets, uBtrieveDataset, uDBMColumns, APIUtil, StrUtil, GlobVar, BtrvU2,
  FileUtil, ImgList, MiscUtil, Menus, uSettings;

type
  TfrmSystemSetup = class(TForm)
    pcSysSetup: TPageControl;
    tsSalesCodeTypes: TTabSheet;
    btnOK: TButton;
    btnCancel: TButton;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    mlSalesCodeTypes: TDBMultiList;
    ilSmallScroll: TImageList;
    bdsSalesCodeTypes: TBtrieveDataset;
    pmMain: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    N1: TMenuItem;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    procedure btnCancelClick(Sender: TObject);
    procedure AddEditSCT(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bdsSalesCodeTypesGetFieldValue(Sender: TObject;
      PData: Pointer; FieldName: String; var FieldValue: String);
    procedure btnDeleteClick(Sender: TObject);
    procedure mlSalesCodeTypesRowDblClick(Sender: TObject;
      RowIndex: Integer);
    procedure mlSalesCodeTypesAfterLoad(Sender: TObject);
    procedure mlSalesCodeTypesBeforeLoad(Sender: TObject;
      var Allow: Boolean);
    procedure btnOKClick(Sender: TObject);
    procedure bdsSalesCodeTypesSelectRecord(Sender: TObject;
      SelectType: TSelectType; Address: Integer; PData: Pointer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Properties1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
//    procedure mlSalesCodeTypesSortColumn(Sender: TObject;
//      ColIndex: Integer; SortAsc: Boolean);
  private
    bRestore : boolean;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
    Procedure WMGetMinMaxInfo (Var Message : TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
  end;

var
  frmSystemSetup: TfrmSystemSetup;

implementation

{$R *.dfm}

procedure TfrmSystemSetup.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSystemSetup.AddEditSCT(Sender: TObject);
var
  pRecord : Pointer;
begin
  with TFrmSCTDetails.Create(Self) do begin
    fmFormMode := TFormMode(TWinControl(Sender).Tag);

    if fmFormMode = fmEdit
    then begin
      pRecord := bdsSalesCodeTypes.GetRecord;
      if pRecord <> nil
      then iFolioNo := TSalesCodeTypeRec(pRecord^).sctFolioNo;
      edSCT.Text := mlSalesCodeTypes.Columns[0].Items[mlSalesCodeTypes.Selected];
    end;{if}

    if ShowModal = mrOK then begin
      mlSalesCodeTypes.RefreshDB;
//      mlSalesCodeTypes.SortColumn(0, TRUE);
      mlSalesCodeTypes.SearchColumn(0, TRUE, edSCT.Text);
    end;
    Release;
  end;{with}
end;

procedure TfrmSystemSetup.FormShow(Sender: TObject);
begin
  bRestore := FALSE;
end;

procedure TfrmSystemSetup.bdsSalesCodeTypesGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
  with TSalesCodeTypeRec(PData^) do begin
    FieldValue := sctDescription;
  end;
end;

procedure TfrmSystemSetup.btnDeleteClick(Sender: TObject);
var
  SalesCodeTypeRec  : TSalesCodeTypeRec;
  SalesCodeRec : TSalesCodeRec;
  iStatus : integer;
  KeyS : str255;
  bFound : boolean;
begin
  if (mlSalesCodeTypes.Selected >= 0) and (MsgBox('Are you sure you want to delete the following Sales Code Type : '#13#13#9
  + mlSalesCodeTypes.Columns[0].Items[mlSalesCodeTypes.Selected]
  , mtConfirmation,[mbYes,mbNo],mbNo,'Delete Sales Code Type') = mrYes) then begin

    // get the Sales code type record
    KeyS := mlSalesCodeTypes.FullNomKey(TSalesCodeTypeRec(bdsSalesCodeTypes.GetRecord^).sctFolioNo) + IDX_DUMMY_CHAR;
    iStatus := Find_Rec(B_GetEq, F[SalesCodeTypeF], SalesCodeTypeF, SalesCodeTypeRec, sctFolioIdx, KeyS);
    if iStatus = 0 then begin

      // see if any sales codes are using the type we want to delete
      bFound := FALSE;
      iStatus := Find_Rec(B_StepFirst, F[SalesCodeF], SalesCodeF, SalesCodeRec, scFolioIdx, KeyS);
      while (iStatus = 0) and (not bFound) do begin
        iStatus := Find_Rec(B_StepNext, F[SalesCodeF], SalesCodeF, SalesCodeRec, scFolioIdx, KeyS);
        if SalesCodeRec.scSalesCodeType = SalesCodeTypeRec.sctFolioNo then bFound := TRUE;
      end;{while}

      if bFound then
        begin
          MsgBox('The Sales Code Type that you wish to delete is in use, and cannot be deleted.' + #13#13
          + 'If you still wish to delete this record, you must first delete or change all Sales Codes that use this Type'
          ,mtInformation,[mbOK],mbOK,'Sales Code Type in Use');
        end
      else begin
        iStatus := Delete_Rec(F[SalesCodeTypeF],SalesCodeTypeF,sctFolioIdx);
        if iStatus = 0 then mlSalesCodeTypes.RefreshDB;
        ShowBTError(iStatus, 'Delete_Rec', FileNames[SalesCodeTypeF]);
      end;{if}
    end;{if}
  end;{if}
end;

procedure TfrmSystemSetup.mlSalesCodeTypesRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  AddEditSCT(btnEdit);
end;

procedure TfrmSystemSetup.mlSalesCodeTypesAfterLoad(Sender: TObject);
begin
  btnDelete.Enabled := mlSalesCodeTypes.Itemscount > 0;
  btnEdit.Enabled := mlSalesCodeTypes.Itemscount > 0;
end;

procedure TfrmSystemSetup.mlSalesCodeTypesBeforeLoad(Sender: TObject;
  var Allow: Boolean);
begin
{  mlSalesCodeTypes.Columns[0].Field := 'sctSalesCodeType';
  mlSalesCodeTypes.Columns[0].DataType := dtString;
  mlSalesCodeTypes.Columns[0].Sortable := TRUE;
  mlSalesCodeTypes.Columns[0].Searchable := TRUE;}
end;

procedure TfrmSystemSetup.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSystemSetup.bdsSalesCodeTypesSelectRecord(Sender: TObject;
  SelectType: TSelectType; Address: Integer; PData: Pointer);
begin
end;
{
procedure TfrmSystemSetup.mlSalesCodeTypesSortColumn(Sender: TObject;
  ColIndex: Integer; SortAsc: Boolean);
begin
  bdsSalesCodeTypes.SearchIndex := ColIndex + 1;
  bdsSalesCodeTypes.SearchDataType := mlSalesCodeTypes.Columns[ColIndex].DataType;
end;
}
procedure TfrmSystemSetup.FormCreate(Sender: TObject);
begin
  LoadAllSettings;
  bdsSalesCodeTypes.FileName := FileNames[SalesCodeTypeF];
  mlSalesCodeTypes.Active := TRUE;
end;

procedure TfrmSystemSetup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
end;

procedure TfrmSystemSetup.SaveAllSettings;
begin
//  oSettings.SaveParentFromControl(cmbCompany, Self.Name);
  oSettings.SaveList(mlSalesCodeTypes, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;


procedure TfrmSystemSetup.LoadAllSettings;
begin
//  sMiscDirLocation := GetEnterpriseDirectory;
  oSettings.LoadForm(Self);
//  oSettings.LoadParentToControl(Self.Name, Self.Name, cmbCompany);
//  oSettings.ColorFieldsFrom(cmbCompany, Self);
  oSettings.LoadList(mlSalesCodeTypes, Self.Name);
//  oSettings.LoadList(mlCommission, Self.Name);
end;

procedure TfrmSystemSetup.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(mlSalesCodeTypes, Self.Name, nil) of
    mrRestoreDefaults : begin
      oSettings.RestoreListDefaults(mlSalesCodeTypes, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmSystemSetup.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  With Message.MinMaxInfo^ Do Begin
    ptMinTrackSize.X:=193;
    ptMinTrackSize.Y:=242;
  End; { With Message }
end;


procedure TfrmSystemSetup.FormResize(Sender: TObject);
begin
  btnOK.Top := ClientHeight - 27;
  btnCancel.Top := btnOK.Top;

  btnOK.Left := ClientWidth - 177;
  btnCancel.Left := ClientWidth - 89;

  pcSysSetup.Width := ClientWidth - 16;
  pcSysSetup.Height := ClientHeight - 42;
end;

end.
