unit PickList;

{ nfrewer440 17:10 08/12/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, ExtCtrls, uMultiList, uComTKDataset, uDBMultiList
  , uBtrieveDataset, uExDatasets, uDBMColumns, Enterprise01_TLB
  , ComCtrls, COMObj, StrUtil, Menus, uSettings, PPayProc;

type

  TplType = (plSupplier, plGLCode, plCC, plDept, plCustomer, plProduct, plProductGroup);

  TfrmPickList = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    ctkDataSet: TComTKDataset;
    Panel1: TPanel;
    mlList: TDBMultiList;
    pmMain: TPopupMenu;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    procedure btnCancelClick(Sender: TObject);
    procedure GetFieldValue(Sender: TObject; ID: IDispatch; FieldName: String; var FieldValue: String);
    procedure SelectRecord(Sender: TObject; SelectType: TSelectType; Address: integer; ID: IDispatch);
//    procedure BuildIndex(Sender: TObject; ID: IDispatch; IndexNo : integer; var KeyStr : String);
    procedure btnOKClick(Sender: TObject);
//    procedure mlListSortColumn(Sender: TObject; ColIndex: Integer; SortAsc: Boolean);
    procedure FormShow(Sender: TObject);
    procedure mlListAfterInit(Sender: TObject);
    procedure mlListRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure mlListAfterLoad(Sender: TObject);
    procedure mlListBeforeLoad(Sender: TObject; var Allow: Boolean);
    procedure mlListScrollButtonKeyPress(Key: Char);
    procedure ctkDataSetFilterRecord(Sender: TObject; ID: IDispatch;
      var Include: Boolean);
    procedure Properties1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    bRestore : boolean;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
    procedure WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    sFind : string;
    plType : TplType;
    iSearchCol : integer;
  end;

var
  frmPickList: TfrmPickList;

implementation

{$R *.dfm}

procedure TfrmPickList.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmPickList.GetFieldValue(Sender: TObject;
  ID: IDispatch; FieldName: String; var FieldValue: String);
begin
  case plType of
    plSupplier, plCustomer : begin
      with (ID as IAccount) do begin
        case FieldName[1] of
          'C' : FieldValue := acCode;
          'D' : FieldValue := acCompany;
        end;{case}
      end;{with}
    end;

    plProduct, plProductGroup : begin
      with (ID as IStock) do begin
        case FieldName[1] of
          'C' : FieldValue := stCode;
          'D' : FieldValue := stDesc[1];
        end;{case}
      end;{with}
    end;

    plGLCode : begin
      with (ID as IGeneralLedger) do begin
        case FieldName[1] of
          'C' : FieldValue := IntToStr(glCode);
          'D' : FieldValue := glName;
        end;{case}
      end;{with}
    end;

    plCC, plDept : begin
      with (ID as ICCDept) do begin
        case FieldName[1] of
          'C' : FieldValue := cdCode;
          'D' : FieldValue := cdName;
        end;{case}
      end;{with}
    end;
  end;{case}
end;
(*
procedure TfrmPickList.BuildIndex(Sender: TObject; ID: IDispatch; IndexNo : integer; var KeyStr: String);

  function StrToIndexInt(sKey : string) : integer;
  begin{StrToIndexInt}
    sKey := Trim(sKey);
    if Pos(StringOfChar(#255,200),sKey) > 0 then Result := 2147483647
    else begin
      sKey := RemoveAllChars(sKey,#255);
      Result := StrToIntDef(sKey,0);
    end;
  end;{StrToIndexInt}

begin{BuildIndex}
  exit;
  case plType of
    plSupplier : begin
      with (ID as IAccount) do begin
        case IndexNo of
          acIdxCode : KeyStr := BuildCodeIndex(KeyStr);
          acIdxName : KeyStr := BuildNameIndex(KeyStr);
    //      acIdxAltCode : KeyStr := BuildCodeIndex(KeyStr);
    //      acIdxVATRegNo : KeyStr := BuildCodeIndex(KeyStr);
    //      acIdxEmail : KeyStr := BuildCodeIndex(KeyStr);
    //      acIdxPhone : KeyStr := BuildCodeIndex(KeyStr);
    //      acIdxPostCode : KeyStr := BuildCodeIndex(KeyStr);
    //      acIdxOurCode : KeyStr := BuildCodeIndex(KeyStr);
    //      acIdxInvTo : KeyStr := BuildCodeIndex(KeyStr);
        end;{case}
      end;{with}
    end;

    plGLCode : begin
      with (ID as IGeneralLedger) do begin
        case IndexNo of
          glIdxCode : KeyStr := BuildCodeIndex(StrToIndexInt(KeyStr));
          glIdxName : KeyStr := BuildNameIndex(KeyStr);
        end;{case}
      end;{with}
    end;
  end;{case}
end;
*)
procedure TfrmPickList.SelectRecord(Sender: TObject; SelectType:
TSelectType; Address: integer; ID: IDispatch);
begin
{  with (ID as IAccount) do begin
    lCode.caption := acCode;
    lDesc.caption := acCompany;
  end;{with}
end;

procedure TfrmPickList.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;
{
procedure TfrmPickList.mlListSortColumn(Sender: TObject;
  ColIndex: Integer; SortAsc: Boolean);
begin
  ctkDataSet.SearchIndex := ColIndex;
  ctkDataSet.SearchDataType := mlList.Columns[ColIndex].DataType;
end;
}
procedure TfrmPickList.FormShow(Sender: TObject);
begin
  bRestore := FALSE;
  case plType of
    plSupplier : begin
      Caption := 'Pick a Supplier';
      ctkDataSet.ToolkitObject := oToolkit.supplier as IBtrieveFunctions2;
    end;

    plCustomer : begin
      Caption := 'Pick a Customer';
      ctkDataSet.ToolkitObject := oToolkit.customer as IBtrieveFunctions2;
    end;

    plGLCode : begin
      Caption := 'Pick a GL Code';
      ctkDataSet.ToolkitObject := oToolkit.GeneralLedger as IBtrieveFunctions2;
    end;

    plCC : begin
      Caption := 'Pick a Cost Centre';
      ctkDataSet.ToolkitObject := oToolkit.CostCentre as IBtrieveFunctions2;
    end;

    plDept : begin
      Caption := 'Pick a Department';
      ctkDataSet.ToolkitObject := oToolkit.Department as IBtrieveFunctions2;
    end;

    plProduct : begin
      Caption := 'Pick a Product';
      ctkDataSet.ToolkitObject := oToolkit.Stock as IBtrieveFunctions2;
    end;

    plProductGroup : begin
      Caption := 'Pick a Product Group';
      ctkDataSet.ToolkitObject := oToolkit.Stock as IBtrieveFunctions2;
    end;
  end;{case}
  mlList.Dataset := ctkDataSet;
end;

procedure TfrmPickList.mlListAfterInit(Sender: TObject);
begin
//  mlList.SortColumn(0, TRUE);
  mlList.SearchColumn(iSearchCol, TRUE, sFind);
end;

procedure TfrmPickList.mlListRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnOKClick(btnOK);
end;

procedure TfrmPickList.mlListAfterLoad(Sender: TObject);
begin
// showmessage('mlListAfterLoad');
end;

procedure TfrmPickList.mlListBeforeLoad(Sender: TObject;
  var Allow: Boolean);
begin
//  showmessage('mlListBeforeLoad');
end;

procedure TfrmPickList.mlListScrollButtonKeyPress(Key: Char);
begin
  Case Ord(Key) of
    27 : ModalResult := mrCancel; //ESC
  end;{case}
end;

procedure TfrmPickList.ctkDataSetFilterRecord(Sender: TObject;
  ID: IDispatch; var Include: Boolean);
begin

// Include := TRUE;

  case plType of
    plCC, plDept, plSupplier, plCustomer : Include := TRUE;

    plGLCode : begin
      with (ID as IGeneralLedger) do begin
        Include := glType in [glTypeProfitLoss, glTypeBalanceSheet];
      end;{with}
    end;

    plProduct : begin
      with (ID as IStock) do begin
        Include := stType in [stTypeProduct, stTypeDescription, stTypeBillOfMaterials];
      end;{with}
    end;

    plProductGroup : begin
      with (ID as IStock) do begin
        Include := stType = stTypeGroup;
      end;{with}
    end;
  end;{case}
end;

procedure TfrmPickList.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  With Message.MinMaxInfo^ Do Begin
    ptMinTrackSize.X:=193;
    ptMinTrackSize.Y:=201;
  End; { With Message }
end;


procedure TfrmPickList.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(mlList, Self.Name, nil) of
    mrRestoreDefaults : begin
      oSettings.RestoreListDefaults(mlList, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmPickList.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadList(mlList, Self.Name);
end;

procedure TfrmPickList.SaveAllSettings;
begin
  oSettings.SaveList(mlList, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;

procedure TfrmPickList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
end;

procedure TfrmPickList.FormCreate(Sender: TObject);
begin
  LoadAllSettings;
end;

end.
