unit ccLook;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uExDatasets, uComTKDataset, ExtCtrls, uMultiList, uDBMultiList,
  StdCtrls, TCustom, Enterprise01_TLB;

type
  TfrmCCLookup = class(TForm)
    gbCCDep: TGroupBox;
    btnOk: TSBSButton;
    SBSButton2: TSBSButton;
    mlCCDep: TMultiList;
    procedure SBSButton2Click(Sender: TObject);
    procedure mlCCDepRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CCDep : string;
  end;

  function GetCCDep(      Code : string;
                    const WantCC : Boolean;
                    const Toolkit : IToolkit) : string;

var
  frmCCLookup: TfrmCCLookup;

implementation

{$R *.dfm}

  function GetCCDep(      Code : string;
                    const WantCC : Boolean;
                    const Toolkit : IToolkit) : string;
  var
    CodeOK : Boolean;

    procedure LoadList(AList : TMultiList; const CCDep : ICCDept);
    var
      Res : longint;
    begin
      Res := CCDep.GetGreaterThanOrEqual(CCDep.BuildCodeIndex(Code));

      while (Res = 0) and (Copy(ccDep.cdCode, 1, Length(Code)) = Code) do
      begin
        AList.DesignColumns[0].Items.Add(CCDep.cdCode);
        AList.DesignColumns[1].Items.Add(CCDep.cdName);

        Res := CCDep.GetNext;
      end;
      AList.Selected := 0;
    end;

  begin
    if Code = '/' then
      Code := '';
    if WantCC then
      CodeOK := Toolkit.CostCentre.GetEqual(Toolkit.CostCentre.BuildCodeIndex(Code)) = 0
    else
      CodeOK := Toolkit.Department.GetEqual(Toolkit.Department.BuildCodeIndex(Code)) = 0;

    if CodeOK then
      Result := Code
    else
    with TfrmCCLookup.Create(nil) do
    Try
      if WantCC then
        LoadList(mlCCDep, Toolkit.CostCentre)
      else
      begin
        LoadList(mlCCDep, Toolkit.Department);
        Caption := 'Select a Department';
        gbCCDep.Caption := 'Departments';
      end;
      CCDep := '';
      if mlCCDep.ItemsCount = 1 then
        CCDep := mlCCDep.DesignColumns[0].Items[0]
      else
        ShowModal;
      if CCDep <> '' then
        Result := CCDep;
    Finally
      Free;
    End;

  end;


procedure TfrmCCLookup.SBSButton2Click(Sender: TObject);
begin
  CCDep := '';
end;

procedure TfrmCCLookup.mlCCDepRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  CCDep := mlCCDep.DesignColumns[0].Items[mlCCDep.Selected];
  Close;
end;

procedure TfrmCCLookup.btnOkClick(Sender: TObject);
begin
  CCDep := mlCCDep.DesignColumns[0].Items[mlCCDep.Selected];
end;

procedure TfrmCCLookup.FormActivate(Sender: TObject);
begin
  btnOK.Enabled := mlCCDep.ItemsCount > 0;
end;

end.
