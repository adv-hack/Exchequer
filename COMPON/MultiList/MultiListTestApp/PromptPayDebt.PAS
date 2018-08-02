unit PromptPayDebt;

{ nfrewer440 17:10 08/12/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, uExDatasets, uBtrieveDataset, ExtCtrls, uMultiList
  , Math, uDBMultiList, Menus, StrUtil, uSettings, BTUtil, BTConst
  , APIUtil, NumEdit;

type
  TfrmDebt = class(TForm)
    mlDebt: TDBMultiList;
    bdsDebt: TBtrieveDataset;
    btnFind: TButton;
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
    btnFD: TButton;
    Button2: TButton;
    edD: TNumEdit;
    edDF: TNumEdit;
    edI: TNumEdit;
    edIF: TNumEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bdsDebtGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Properties1Click(Sender: TObject);
    procedure mlDebtAfterLoad(Sender: TObject);
    procedure pmMainPopup(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnFDClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    bRestore : boolean;
//    function FullDoubleKey(const Value : Double) : TStr255;
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
  PPayProc, PromptPayBTFile;

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
  bdsDebt.SearchKey := #0#0#0#0#0#0;
  mlDebt.Active := TRUE;
end;

procedure TfrmDebt.bdsDebtGetFieldValue(Sender: TObject; PData: Pointer;
  FieldName: String; var FieldValue: String);
begin
  with TPPDebtRec(PData^) do begin
    case FieldName[1] of
      'F' : FieldValue := MoneyToStr(ppdValueFrom, 2);
//      'T' : FieldValue := MoneyToStr(ppdValueTo, oToolkit.SystemSetup.ssSalesDecimals);
      'T' : FieldValue := GetToValue(sCustCode, ppdValueFrom, FALSE);
      'C' : FieldValue := MoneyToStr(ppdCharge, 2);
      '1' : FieldValue := IntToStr(TPPDebtRec(PData^).ppdFolioNo);
    end;{case}
  end;{with}
end;

procedure TfrmDebt.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  With Message.MinMaxInfo^ Do Begin
    ptMinTrackSize.X:=200;
    ptMinTrackSize.Y:=183;
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
  action := cafree;
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

procedure TfrmDebt.btnCloseClick(Sender: TObject);
begin
  Close;
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

procedure TfrmDebt.btnFDClick(Sender: TObject);
begin
  mlDebt.SearchColumn(0,TRUE,mlDebt.FullDoubleKey(edDF.Value));
end;

procedure TfrmDebt.FormResize(Sender: TObject);
begin
  btnClose.Top := ClientHeight - 29;
  btnClose.Left := ClientWidth - 89;

  btnFind.Left := btnClose.Left;
  btnEdit.Left := btnClose.Left;

  mlDebt.Width := ClientWidth - 104;
  mlDebt.Height := ClientHeight - 31;
end;

procedure TfrmDebt.btnFindClick(Sender: TObject);
begin
  mlDebt.SearchColumn(0,TRUE,edD.Text);
end;

procedure TfrmDebt.btnEditClick(Sender: TObject);
begin
  mlDebt.SearchColumn(3,TRUE,edI.Text);
//  mlDebt.SearchColumn(3,TRUE, mlDebt.FullNomKey(10));
end;

{function TfrmDebt.FullDoubleKey(const Value : Double) : TStr255;
var
  dTemp : Double;
begin
  FillChar(Result, SizeOf(Result), 0);
  dTemp := Value;
  Move(dTemp, Result[1], SizeOf(dTemp));
  Result[0] := Char(SizeOf(dTemp));
end;}


procedure TfrmDebt.Button2Click(Sender: TObject);
begin
  mlDebt.SearchColumn(3,TRUE,mlDebt.FullNomKey(Trunc(edIF.Value)));
end;

initialization
//  showmessage(BTFullDoubleKey(1.7 * 10^308));
//  showmessage(StringToCodes(BTFullDoubleKey(1.7 * IntPower(10,308))));
//  showmessage(StringToCodes(BTFullDoubleKey(5 * IntPower(10,-324))));
//  showmessage(MoneyToStr(1.7 * IntPower(10,308)));
//  showmessage(StringToCodes(BTFullDoubleKey(0)));

end.
