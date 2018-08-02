unit DataDictFieldList;

{ nfrewer440 11:48 26/08/2004: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uMultiList, uDBMultiList, uExDatasets, uBtrieveDataset,
  StdCtrls, MiscUtil, Menus, FileUtil;

type
  TfrmFieldList = class(TForm)
    mlFields: TDBMultiList;
    bdsFields: TBtrieveDataset;
    panButts: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnClose: TButton;
    btnCopy: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Functions1: TMenuItem;
    Exit1: TMenuItem;
    SetFlagsforRangeofFields1: TMenuItem;
    ResetAllXRefFields1: TMenuItem;
    N1: TMenuItem;
    RebuildDictnarydattodictnewdat1: TMenuItem;
    CountRecords1: TMenuItem;
    N2: TMenuItem;
    ExporttoCSV1: TMenuItem;
    N3: TMenuItem;
    dlgSave: TSaveDialog;
    SetoneFlagforaListofFields1: TMenuItem;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure bdsFieldsGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure btnCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bdsFieldsSelectRecord(Sender: TObject;
      SelectType: TSelectType; Address: Integer; PData: Pointer);
    procedure Button2Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure mlFieldsRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure mlFieldsChangeSelection(Sender: TObject);
  private
    Procedure WMGetMinMaxInfo (Var Message : TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
  end;

var
  frmFieldList: TfrmFieldList;

implementation
uses
  Blank, BTConst, BTUtil, APIUtil, DataDictBTFiles, DictRecord, MathUtil;

{$R *.dfm}

procedure TfrmFieldList.FormShow(Sender: TObject);
begin
  bdsFields.FileName := sDataPath + btFileName[DictionaryF];
  mlFields.Active := TRUE;
  OpenFiles;
end;

procedure TfrmFieldList.bdsFieldsGetFieldValue(Sender: TObject; PData: Pointer;
  FieldName: String; var FieldValue: String);
begin
  case FieldName[1] of
    'F' : FieldValue := DataDictRec(PData^).DataVarRec.VarName;
    'V' : FieldValue := DataDictRec(PData^).DataVarRec.VarPadNo;
    'D' : FieldValue := DataDictRec(PData^).DataVarRec.VarDesc;
    'T' : FieldValue := aDataTypeDesc[DataDictRec(PData^).DataVarRec.VarType];
    'L' : FieldValue := IntToStr(DataDictRec(PData^).DataVarRec.VarLen);
    'P' : FieldValue := IntToStr(DataDictRec(PData^).DataVarRec.VarNoDec);
  end;{case}
end;

procedure TfrmFieldList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFieldList.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  With Message.MinMaxInfo^ Do Begin
    ptMinTrackSize.X:=350;
    ptMinTrackSize.Y:=263;
  End; { With Message }
end;

procedure TfrmFieldList.FormResize(Sender: TObject);
begin
  mlFields.Height := ClientHeight - 15;
  mlFields.Width := ClientWidth - 110;

  panButts.Left := ClientWidth - 90;
end;

procedure TfrmFieldList.FormDestroy(Sender: TObject);
begin
  CloseFiles;
end;

procedure TfrmFieldList.bdsFieldsSelectRecord(Sender: TObject;
  SelectType: TSelectType; Address: Integer; PData: Pointer);

var
  LDictionaryRec : DataDictRec;
begin
  LDictionaryRec := DataDictRec(PData^);
//  showmessage(LDictionaryRec.DataVarRec.VarName);
end;

procedure TfrmFieldList.Button2Click(Sender: TObject);
var
  pData: Pointer;
  BTRec : TBTRec;
  LDictionaryRec : DataDictRec;
begin
  pData := bdsFields.GetRecord;
  if pData <> nil then
  begin
    // find record to delete
    BTRec.KeyS := XrefRecordPrefix + #0 + #0 + DataDictRec(PData^).DataVarRec.VarName;
    BTRec.Status := BTFindRecord(BT_GetGreaterOrEqual, btFileVar[DictionaryF], LDictionaryRec
    , SizeOf(LDictionaryRec), dxIdxVerFileName, BTRec.KeyS);
    while BTRec.Status = 0 do
    begin
      ShowMessage(IntToStr(LDictionaryRec.DataXRefRec.VarExVers)
      + ' / ' + IntToStr(LDictionaryRec.DataXRefRec.VarFileNo));
    end;{if}
  end;{if}
end;

procedure TfrmFieldList.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmFieldList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmFieldList.Button1Click(Sender: TObject);
begin
  with TfrmBlank.create(Self) do
  begin
  end;
end;

procedure TfrmFieldList.mlFieldsRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
//  Caption := IntToStr(GetTickCount);
  Caption := 'DC';
  with TfrmBlank.create(Self) do
  begin
  end;
end;

procedure TfrmFieldList.mlFieldsChangeSelection(Sender: TObject);
begin
  Caption := 'CS';
end;

end.
