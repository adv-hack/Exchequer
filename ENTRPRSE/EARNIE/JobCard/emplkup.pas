unit emplkup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uExDatasets, uComTKDataset, StdCtrls, TCustom, ExtCtrls,
  uMultiList, uDBMultiList, Enterprise01_TLB, EnterpriseBeta_TLB;

type
  TfrmEmpLookup = class(TForm)
    mlEmp: TDBMultiList;
    btnOK: TSBSButton;
    SBSButton2: TSBSButton;
    dsEmp: TComTKDataset;
    procedure FormCreate(Sender: TObject);
    procedure dsEmpGetFieldValue(Sender: TObject; ID: IDispatch;
      FieldName: String; var FieldValue: String);
    procedure btnOKClick(Sender: TObject);
    procedure mlEmpRowDblClick(Sender: TObject; RowIndex: Integer);
  private
    { Private declarations }
    FSelectedCode : string;
  public
    { Public declarations }
    property SelectedCode : string read FSelectedCode;
  end;

  function GetEmployeeCode(const CoCode : string;
                           const StartS : string = '') : string;
  procedure CheckEmpCode(TheEdit : TEdit; const CoCode : string);

var
  frmEmpLookup: TfrmEmpLookup;

implementation

uses
  JcVar;
{$R *.dfm}

procedure TfrmEmpLookup.FormCreate(Sender: TObject);
begin
  dsEmp.ToolkitObject := oToolkit.JobCosting.Employee as IDatabaseFunctions;
end;

procedure TfrmEmpLookup.dsEmpGetFieldValue(Sender: TObject; ID: IDispatch;
  FieldName: String; var FieldValue: String);
begin
  with ID as IEmployee do
    Case FieldName[1] of
      'C'  : FieldValue := emCode;
      'N'  : FieldValue := emName;
    end;
end;

function GetEmployeeCode(const CoCode : string;
                         const StartS : string = '') : string;
begin
  with TfrmEmpLookup.Create(nil) do
  Try
    dsEmp.SearchKey := StartS;
    mlEmp.Active := True;
    ShowModal;
    if ModalResult = mrOK then
      Result := SelectedCode
    else
      Result := '';
  Finally
    Free;
  End;
end;

procedure CheckEmpCode(TheEdit : TEdit; const CoCode : string);
var
  Res : integer;
  s   : string;
begin
  with oToolkit.JobCosting do
  begin
    Res := Employee.GetEqual(Employee.BuildCodeIndex(TheEdit.Text));
    if Res <> 0 then
    begin
      s := TheEdit.Text;
      if s = '/' then
        s := '';
      s := GetEmployeeCode(CoCode, Trim(s));
      if s = '' then
        s := TheEdit.Text;
      TheEdit.Text := s;
      Res := Employee.GetEqual(Employee.BuildCodeIndex(TheEdit.Text));
      if Res <> 0 then
        with TheEdit.Owner as TCustomForm do
         ActiveControl := TheEdit;
    end;
  end;
end;


procedure TfrmEmpLookup.btnOKClick(Sender: TObject);
var
  oEmp : IEmployee;
begin
  oEmp := dsEmp.GetRecord as IEmployee;
  if Assigned(oEmp) then
    FSelectedCode := oEmp.emCode;
end;

procedure TfrmEmpLookup.mlEmpRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnOK.Click;
end;

end.
