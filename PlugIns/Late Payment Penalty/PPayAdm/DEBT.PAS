unit Debt;                      

{ nfrewer440 17:10 08/12/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, uExDatasets, uBtrieveDataset, ExtCtrls, uMultiList
  , Math, uDBMultiList, Menus, StrUtil, uSettings, DebtDet, BTUtil, BTConst
  , APIUtil;

type
  TfrmDebt = class(TForm)
    mlDebt: TDBMultiList;
    bdsDebt: TBtrieveDataset;
    btnAdd: TButton;
    btnDelete: TButton;
    pmMain: TPopupMenu;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    N2: TMenuItem;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    btnClose: TButton;
    Edit1: TMenuItem;
    btnEdit: TButton;
    lCustomer: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bdsDebtGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Properties1Click(Sender: TObject);
    procedure mlDebtAfterLoad(Sender: TObject);
    procedure pmMainPopup(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure mlDebtRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure FormResize(Sender: TObject);
  private
    bRestore : boolean;
    procedure EnableDisable;
    Procedure WMGetMinMaxInfo (Var Message : TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    procedure LoadAllSettings;
    procedure SaveAllSettings;
  public
    sCustCode : string;
  end;

var
  frmDebt: TfrmDebt;

implementation
uses
  SQLUtils, PPayProc, BTFile;

{$R *.dfm}

procedure TfrmDebt.FormCreate(Sender: TObject);
begin
  LoadAllSettings;
  bRestore := FALSE;
  bdsDebt.FileName := CompanyRec.Path + ppFileName[ppDebtF];
  EnableDisable;
end;

procedure TfrmDebt.FormShow(Sender: TObject);
begin
  bdsDebt.SearchKey := sCustCode;

  if UsingSQL then
  begin
    // SQL Only
    mlDebt.DesignColumns[0].IndexNo := 2;
  end
  else
  begin
    // Btrieve Only
    mlDebt.DesignColumns[0].IndexNo := 0;
  end;{if}

  mlDebt.Active := TRUE;
end;

procedure TfrmDebt.bdsDebtGetFieldValue(Sender: TObject; PData: Pointer;
  FieldName: String; var FieldValue: String);
begin
  with TPPDebtRec(PData^) do begin
    case FieldName[1] of
      'F' : FieldValue := MoneyToStr(ppdValueFrom, oToolkit.SystemSetup.ssSalesDecimals);
//      'T' : FieldValue := MoneyToStr(ppdValueTo, oToolkit.SystemSetup.ssSalesDecimals);
      'T' : FieldValue := GetToValue(sCustCode, ppdValueFrom, FALSE);
      'C' : FieldValue := MoneyToStr(ppdCharge, oToolkit.SystemSetup.ssSalesDecimals);
    end;{case}
  end;{with}
end;

procedure TfrmDebt.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  With Message.MinMaxInfo^ Do Begin
    ptMinTrackSize.X:=374;
    ptMinTrackSize.Y:=220;
  End; { With Message }
end;

procedure TfrmDebt.SaveAllSettings;
begin
  oSettings.SaveList(mlDebt, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;


procedure TfrmDebt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
end;

procedure TfrmDebt.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(mlDebt, Self.Name, nil) of
//    mrOK : oSettings.ColorFieldsFrom(cmbCompany, Self);
    mrRestoreDefaults : begin
      oSettings.RestoreFormDefaults(Self.Name);
      oSettings.RestoreListDefaults(mlDebt, Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmDebt.LoadAllSettings;
begin
//  sMiscDirLocation := GetEnterpriseDirectory;
  oSettings.LoadForm(Self);
//  oSettings.LoadParentToControl(Self.Name, Self.Name, cmbCompany);
//  oSettings.ColorFieldsFrom(cmbCompany, Self);
  oSettings.LoadList(mlDebt, Self.Name);
end;


procedure TfrmDebt.EnableDisable;
begin
  btnEdit.Enabled := (mldebt.ItemsCount > 0) and (mldebt.Selected >= 0);
  btnDelete.Enabled := (mldebt.ItemsCount > 0) and (mldebt.Selected >= 0);
end;

procedure TfrmDebt.mlDebtAfterLoad(Sender: TObject);
begin
  EnableDisable;
end;

procedure TfrmDebt.pmMainPopup(Sender: TObject);
begin
  Edit1.Enabled := (mlDebt.ItemsCount > 0) and (mlDebt.Selected >= 0);
  Delete1.Enabled := (mlDebt.ItemsCount > 0) and (mlDebt.Selected >= 0);
end;

procedure TfrmDebt.btnAddClick(Sender: TObject);
begin
  with TfrmDebtDetails.create(application) do begin
    bAdd := TRUE;
    bFirst := mlDebt.ItemsCount = 0;
    LPPDebtRec.ppdCustCode := sCustCode;
    if ShowModal = mrOK then mlDebt.RefreshDB;
    Release;
  end;{with}
  EnableDisable;
end;

procedure TfrmDebt.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmDebt.Add1Click(Sender: TObject);
begin
  btnAddClick(btnAdd);
end;

procedure TfrmDebt.Edit1Click(Sender: TObject);
begin
  btnEditClick(btnEdit);
end;

procedure TfrmDebt.Delete1Click(Sender: TObject);
begin
  btnDeleteClick(btnDelete);
end;

procedure TfrmDebt.btnEditClick(Sender: TObject);
var
  iStatus : integer;
  KeyS : TStr255;
  pRecord : pointer;
  PPDebtRec : TPPDebtRec;
begin
  pRecord := bdsDebt.GetRecord;
  if pRecord <> nil then begin
    with TfrmDebtDetails.create(application) do begin
      bAdd := FALSE;
      bFirst := FALSE;
      LPPDebtRec := TPPDebtRec(pRecord^);
      if ShowModal = mrOK then mlDebt.RefreshDB;
      Release;
    end;{with}
  end;{if}
end;

procedure TfrmDebt.btnDeleteClick(Sender: TObject);
var
  iStatus : integer;
  KeyS : TStr255;
  pRecord : pointer;
  PPDebtRec : TPPDebtRec;
begin
  pRecord := bdsDebt.GetRecord;
  if pRecord <> nil then
  begin
    if MsgBox('Are you sure you want to delete this record ?'
    ,mtConfirmation, [mbYes, mbNo], mbNo, 'Delete Record') = mrYes then
    begin
      // delete record
      FillChar(KeyS,SizeOf(KeyS),#0);
      KeyS := BTFullNomKey(TPPDebtRec(pRecord^).ppdFolioNo) + IDX_DUMMY_CHAR;
      iStatus := BTFindRecord(B_GetEq, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
      , ppdFolioNoIdx, KeyS);
      if iStatus = 0 then begin
        iStatus := BTDeleteRecord(ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
        , ppdFolioNoIdx);
        BTShowError(iStatus, 'BTDeleteRecord', CompanyRec.Path + ppFileName[ppDebtF]);
        mlDebt.RefreshDB;
        EnableDisable;
      end;{if}
    end;{if}
  end;{if}
end;

procedure TfrmDebt.Button1Click(Sender: TObject);
var
  PPDebtRec : TPPDebtRec;
begin
  FillChar(PPDebtRec,SizeOf(PPDebtRec),#0);
  PPDebtRec.ppdCharge := 12.23;
  PPDebtRec.ppdCustCode := sCustCode;
  PPDebtRec.ppdDummyChar := IDX_DUMMY_CHAR;
//  PPDebtRec.ppdValueFrom := 1.7 * IntPower(10,308);
  PPDebtRec.ppdValueFrom := 1.6 * IntPower(10,308);
//  PPDebtRec.ppdValueFrom := -999999999999999999;
  BTShowError(BTAddRecord(ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF], ppdValueFromIdx)
  , 'BTAddRecord', CompanyRec.Path + ppFileName[ppDebtF]);
end;

procedure TfrmDebt.mlDebtRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  btnEditClick(btnEdit);
end;

procedure TfrmDebt.FormResize(Sender: TObject);
begin
  btnClose.Top := ClientHeight - 29;
  btnClose.Left := ClientWidth - 89;

  btnAdd.Left := btnClose.Left;
  btnEdit.Left := btnClose.Left;
  btnDelete.Left := btnClose.Left;

  mlDebt.Width := ClientWidth - 104;
  mlDebt.Height := ClientHeight - 31;
end;

initialization
//  showmessage(BTFullDoubleKey(1.7 * 10^308));
//  showmessage(StringToCodes(BTFullDoubleKey(1.7 * IntPower(10,308))));
//  showmessage(StringToCodes(BTFullDoubleKey(5 * IntPower(10,-324))));
//  showmessage(MoneyToStr(1.7 * IntPower(10,308)));
//  showmessage(StringToCodes(BTFullDoubleKey(0)));

end.
