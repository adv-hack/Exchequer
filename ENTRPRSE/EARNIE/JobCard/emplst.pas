unit emplst;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uExDatasets, uComTKDataset, StdCtrls, TCustom, uMultiList,
  uDBMultiList, ExtCtrls, jcVar, uBtrieveDataset, JcObj, Enterprise01_TLB;

type
  TfrmEmpList = class(TForm)
    Panel1: TPanel;
    mlEmp: TDBMultiList;
    Panel2: TPanel;
    SBSButton1: TSBSButton;
    ScrollBox1: TScrollBox;
    btnEdit: TSBSButton;
    btnAdd: TSBSButton;
    SBSButton4: TSBSButton;
    bdEmp: TBtrieveDataset;
    btnImport: TSBSButton;
    procedure bdEmpGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure SBSButton4Click(Sender: TObject);
    procedure mlEmpRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnImportClick(Sender: TObject);
  private
    { Private declarations }
    FCompanyCode : string;
    FEmp : TEmpObject;
    FToolkit : IToolkit;
    function GetCurrentRecord(Lock : Boolean = False) : Integer;
    procedure ImportEmployees;
    function EmployeeKey(const CoCode : string; const EmCode : string) : string;
  public
    { Public declarations }
    constructor CreateWithCompany(AOwner : TComponent; const ACompany : string);
    property EmployeeRec : TEmpObject read FEmp write FEmp;
    property Toolkit : IToolkit read FToolkit write FToolkit;
  end;

var
  frmEmpList: TfrmEmpList;

implementation

{$R *.dfm}
uses
  EmpGroup, JcFuncs, BtrvU2, LogO, JcIni, ApiUtil;

constructor TfrmEmpList.CreateWithCompany(AOwner : TComponent; const ACompany : string);
begin
  inherited Create(AOwner);
  FCompanyCode := ACompany;
  bdEmp.SearchKey := FCompanyCode;
  mlEmp.Active := True;
end;

procedure TfrmEmpList.bdEmpGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
  with EmpRecType(PData^) do
  begin
    Case FieldName[1] of
      'C'  : FieldValue := EmpCode;
      'N'  : FieldValue := EmpName;
      'A'  : FieldValue := AcGroup;
    end;//case
  end;
end;

function TfrmEmpList.GetCurrentRecord(Lock : Boolean = False) : Integer;
var
  Res : Integer;
  Emp : EmpRecType;
  P : Pointer;
begin
  P := bdEmp.GetRecord;
  if Assigned(P) then
  begin
    Emp := EmpRecType(P^);
    FEmp.Index := 0;
    Result := FEmp.FindRec(LJVar(Emp.CoCode, 6) + LJVar(Emp.EmpCode, 6), B_GetEq, Lock);
  end
  else
    Result := -1;
end;

procedure TfrmEmpList.btnAddClick(Sender: TObject);
var
  Res : Integer;
begin
  with TfrmEmpGroup.Create(nil) do
  Try
    CompCode := FCompanyCode;
    FillLists;
    ShowModal;
    if ModalResult = mrOK then
    begin
      if FEmp.FindRec(EmployeeKey(FCompanyCode, edtCode.Text), B_GetEq) = 0 then
        ShowMessage('Employee ' + QuotedStr(edtCode.Text) + ' already exists')
      else
      begin
        FEmp.CoCode := FCompanyCode;
        FEmp.EmpCode := edtCode.Text;
        FEmp.EmpName := edtEmpName.Text;
        FEmp.AccGroup := cbAcGroup.Items[cbAcGroup.ItemIndex];
        Res := FEmp.AddRec;
      end;
    end;
  Finally
    Free;
  End;
  mlEmp.RefreshDB;
end;

procedure TfrmEmpList.btnEditClick(Sender: TObject);
var
  Res, Res1 : Integer;
begin
  Res1 := GetCurrentRecord(True);
  if Res1 = 0 then
  begin
    with TfrmEmpGroup.Create(nil) do
    Try
      CompCode := FCompanyCode;
      FillLists;
      edtCode.Text := FEmp.EmpCode;
      edtCode.ReadOnly := True;
      edtCode.Color := clBtnFace;
      edtEmpName.Text := FEmp.EmpName;
      cbAcGroup.ItemIndex := cbAcGroup.Items.IndexOf(Trim(FEmp.AccGroup));
      ShowModal;
      if ModalResult = mrOK then
      begin
        FEmp.CoCode := FCompanyCode;
        FEmp.EmpCode := edtCode.Text;
        FEmp.EmpName := edtEmpName.Text;
        FEmp.AccGroup := cbAcGroup.Items[cbAcGroup.ItemIndex];
        Res := FEmp.PutRec;
        if Res <> 0 then
          ShowMessage('Unable to store record: Btrieve error ' + IntToStr(Res));
      end
      else
        Res := FEmp.PutRec;
    Finally
      Free;
    End;
    mlEmp.RefreshDB;
  end
  else
  begin
    if Res1 in [84,85] then
      ShowMessage('Record is currently locked by another workstation')
    else
    if Res1 = -1 then
      ShowMessage('Unable to retrieve current record')
    else
      ShowMessage('Error retrieving current record: ' + IntToStr(Res1));
  end;
end;

procedure TfrmEmpList.SBSButton4Click(Sender: TObject);
var
  Res : Integer;
begin
  if GetCurrentRecord = 0 then
  begin
    if MessageDlg('Are you sure you wish to delete employee ' + QuotedStr(FEmp.EmpName) + '?',
             mtConfirmation, mbYesNoCancel, 0) = mrYes then
    begin
      Res := FEmp.DelRec;
      mlEmp.RefreshDB;
    end;
  end
  else
    ShowMessage('Unable to retrieve current record');
end;

procedure TfrmEmpList.mlEmpRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  btnEdit.Click;
end;


procedure TfrmEmpList.ImportEmployees;
var
  Res : Integer;
  KeyS, sGroup : string;
  bErrors : Boolean;
begin
  Screen.Cursor := crHourGlass;
  Res := msgBox('This will import all employees from Exchequer.'#10'Do you wish to continue?',
                mtConfirmation, [mbYes, mbNo], mbYes, 'Job Card Export');
  if Res = mrYes then
  begin
    TheLog := TJCLog.Create;
    TheLog.Filename := TheIni.LogDir + TheIni.LogFileName;
    TheLog.Open(FCompanyCode + '/Import Employees', True);
{    TheLog.Logit('Import Employees from Exchequer');
    TheLog.Logit('===============================');
    TheLog.Logit(' ');}
    bErrors := False;
    with TfrmEmpGroup.Create(nil) do
    Try
      CompCode := FCompanyCode;
      FillLists;
      with FToolkit.JobCosting do
      begin
        Res := Employee.GetFirst;
        while Res = 0 do
        begin
          KeyS := EmployeeKey(FCompanyCode, Employee.emCode);
          if FEmp.FindRec(KeyS, B_GetEq) <> 0 then
          begin
            sGroup := Trim(Employee.emUserField1);
            if (cbAcGroup.Items.IndexOf(sGroup) >= 0) then
            begin
              FEmp.CoCode := LJVar(FCompanyCode, 6);
              FEmp.EmpCode := LJVar(Employee.emCode, 6);
              FEmp.EmpName := Trim(Employee.emName);
              FEmp.AccGroup := sGroup;
              FEmp.AddRec;
            end
            else
            begin
              //Log error
              bErrors := True;
              TheLog.Logit(Format('No valid account group found for %s', [Trim(Employee.emCode)]));
            end;
          end;
          Res := Employee.GetNext;
        end;
      end;
    Finally
      if bErrors then
        ShowMessage('There were errors during the import. Check log file '#10 +
                      TheLog.Filename + ' for details.');
      Free;
      TheLog.Free;
      Screen.Cursor := crDefault;
      mlEmp.RefreshDB;
    End;
  end;
end;

function TfrmEmpList.EmployeeKey(const CoCode, EmCode: string): string;
begin
  Result := LJVar(FCompanyCode, 6) + LJVar(emCode, 6);
end;

procedure TfrmEmpList.btnImportClick(Sender: TObject);
begin
  ImportEmployees;
end;

end.
