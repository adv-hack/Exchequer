unit AdmnForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ADODB, StdCtrls, TCustom, ExtCtrls, uMultiList, ComCtrls, SQLUtils, Dialogs;

type
  TfrmCAAdmin = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    cbCompany: TComboBox;
    Label1: TLabel;
    tvGLs: TTreeView;
    edtGLCode: TEdit;
    edtGLDesc: TEdit;
    edtAllocName: TEdit;
    edtAllocDesc: TEdit;
    btnAddLine: TButton;
    btnEditLine: TButton;
    Button6: TButton;
    gbType: TGroupBox;
    rbCC: TRadioButton;
    rbDep: TRadioButton;
    rbCCDep: TRadioButton;
    mlLines: TMultiList;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Button1: TButton;
    btnEdit: TButton;
    Button3: TButton;
    Button7: TButton;
    SBSButton1: TSBSButton;
    btnCancel: TSBSButton;
    edtUnalloc: TEdit;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure rbCCClick(Sender: TObject);
    procedure btnAddLineClick(Sender: TObject);
    procedure cbCompanyChange(Sender: TObject);
    procedure btnEditLineClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tvGLsClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure SBSButton1Click(Sender: TObject);
    procedure edtGLCodeExit(Sender: TObject);
    procedure edtAllocNameExit(Sender: TObject);
    procedure mlLinesRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure Button6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure tvGLsChange(Sender: TObject; Node: TTreeNode);
  private
    { Private declarations }
    CurrentCompany : string;
    LineCount : integer;
    EditMode : Boolean;
    qRecords : TADOQuery;
    procedure LoadTree;
    procedure LoadLines;
    procedure ClearLines;
    procedure EnableControls(Details : Boolean);
    procedure SaveAfterAdd;
    procedure SaveAfterEdit;
    function AllocExists : Boolean;
    function FindCurrentLine : Boolean;
    procedure SelectCurrentRecInTree;
    function GetGLTreeCode(const s : string) : string;
    procedure SetTree;
    procedure RenumLines(StartLine : integer);
    procedure DeleteAlloc;
    procedure DeleteGL;
    function RecExists(const CC, Dep : string) : Boolean;
  public
    { Public declarations }
  end;

var
  frmCAAdmin: TfrmCAAdmin;

implementation

{$R *.dfm}
uses
  AllocVar, AllcBase, LineForm, Enterprise01_TLB, GLLook, ApiUtil,
  DataModule;

var
  AlType : Byte;


procedure TfrmCAAdmin.FormCreate(Sender: TObject);
begin
  Caption := 'CC/Dept Allocation Administration';

  // Open Data connection
  if bSQL then
  begin
    // MS-SQL

    // Open connection to MS-SQL
    SQLDataModule := TSQLDataModule.Create(nil);
    SQLDataModule.Connect;
  end
  else
  begin
    // Pervasive
    OpenFile;
  end;{if}

  // Open Toolkit
  StartToolkit;

  // Open and set Company List
  LoadCompanyList(cbCompany.Items);
  cbCompany.ItemIndex := 0;
  cbCompanyChange(nil);

  btnEdit.Enabled := False;

  //LoadTree;

  EnableControls(False);
end;

procedure TfrmCAAdmin.Button7Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmCAAdmin.Button1Click(Sender: TObject);
//Add allocation
begin
  EnableControls(True);
  EditMode := False;
  edtAllocName.Text := '';
  edtAllocDesc.Text := '';
  ClearLines;
  edtGLCode.Enabled := True;
  ActiveControl := edtGLCode;
end;

procedure TfrmCAAdmin.btnEditClick(Sender: TObject);
var
  KeyS : ShortString;
  Res : Integer;
begin

  // NF: 14/02/2011 -  I THINK Findex is set to 1 at this point.

  if Assigned(tvGLs.Selected) and (tvGLs.Selected.Level > 0) then
  begin
    if bSQL then
    begin
      // MS-SQL
      qRecords := SQLDataModule.GetAllRecordsFor(CurrentCompany, StrToIntDef(edtGLCode.Text, 0), GetGLTreeCode(tvGLs.Selected.Text));
      if qRecords.RecordCount > 0 then
      begin
        qRecords.First;
        EnableControls(True);
        edtGLCode.Enabled := False;
        EditMode := True;
        ActiveControl := edtAllocName;
      end;{if}
    end
    else
    begin
      // Pervasive
      KeyS := CurrentCompany + FullNomKey(StrToInt(edtGLCode.Text)) + GetGLTreeCode(tvGLs.Selected.Text);
      Res := FindRec(KeyS, B_GetGEq);
      if Res = 0 then
      begin
        EnableControls(True);
        edtGLCode.Enabled := False;
        EditMode := True;
        ActiveControl := edtAllocName;
      end;{if}
    end;{if}
  end;
end;

procedure TfrmCAAdmin.rbCCClick(Sender: TObject);
begin
  if Sender is TRadioButton then
    AlType := TRadioButton(Sender).Tag;
end;

procedure TfrmCAAdmin.LoadTree;
var
  Res, Res1 : Integer;
  CurrentGL : longint;
  CurrentName : string;
  ThisNode : TTreeNode;
  KeyS : ShortString;
  GLDesc : string;
  qRecords : TADOQuery;
begin
  tvGLs.Items.Clear;

  if bSQL then
  begin
    // MS-SQL
    CurrentGL := 0;
    CurrentName := '';

    qRecords := SQLDataModule.GetRecordsForCompany(CurrentCompany);
    qRecords.First;

    While (not qRecords.eof) do
    begin
      if qRecords.FieldByName('GLCode').AsInteger <> CurrentGL then
      begin
        CurrentGL := qRecords.FieldByName('GLCode').AsInteger;
        Res1 := oToolkit.GeneralLedger.GetEqual(oToolkit.GeneralLedger.BuildCodeIndex(CurrentGL));

        if Res = 0 then
        begin
          GLDesc := ', ' + oToolkit.GeneralLedger.glName;
        end
        else
        begin
          GLDesc := '';
        end;{if}

        ThisNode := tvGLs.Items.Add(nil, IntToStr(CurrentGL) + GLDesc);
        CurrentName := '';
      end;{if}

      if qRecords.FieldByName('Name').AsString <> CurrentName then
      begin
        tvGLs.Items.AddChild(ThisNode, Trim(qRecords.FieldByName('Name').AsString) + ', ' + Trim(qRecords.FieldByName('Description').AsString));
        CurrentName := qRecords.FieldByName('Name').AsString;
      end;{if}

      // Next Record
      qRecords.Next;
    end;{while}
  end
  else
  begin
    // Pervasive
    FIndex := 1;
    CurrentGL := 0;
    CurrentName := '';

    KeyS := CurrentCompany;
    Res := FindRec(KeyS, B_GetGEq);

    While (Res = 0) and (CurrentCompany = AllocRec.CoCode) do
    begin
      if AllocRec.GLCode <> CurrentGL then
      begin
        CurrentGL := AllocRec.GLCode;
        with oToolkit.GeneralLedger do
        begin
          Res1 := GetEqual(BuildCodeIndex(CurrentGL));

          if Res = 0 then
            GLDesc := ', ' + glName
          else
            GLDesc := '';
        end;{with}
        ThisNode := tvGLs.Items.Add(nil, IntToStr(CurrentGL) + GLDesc);
        CurrentName := '';
      end;{if}

      if AllocRec.AllocName <> CurrentName then
      begin
        tvGLs.Items.AddChild(ThisNode, Trim(AllocRec.AllocName) + ', ' + Trim(AllocRec.AllocDesc));
        CurrentName := AllocRec.AllocName;
      end;{if}

      // Next Record
      Res := FindRec(KeyS, B_GetNext);
    end;{while}
  end;{if}
end;

procedure TfrmCAAdmin.btnAddLineClick(Sender: TObject);
var
  Res : Integer;
begin
  if Trim(edtAllocName.Text) <> '' then
  begin

    //Used to enable / disable fields in the line dialog
    AllocRec.AllocType := AlType;

    if bSQL then
    begin
      // MS-SQL

      with TfrmLine.Create(nil) do
      begin
        Try
          edtRemaining.Text := Format('%5.2f', [PercRemaining]);
          edtPerc.Text := edtRemaining.Text;
          ShowModal;
          if ModalResult = mrOK then
          begin
            inc(LineCount);
            SQLDataModule.AddRecord(LJVar(CurrentCompany, 6), StrToInt(edtGLCode.Text), LineCount, AlType
            , LJVar(Trim(edtAllocName.Text), 20), Trim(edtAllocDesc.Text), edtCC.Text, edtDept.Text, StrToFloat(edtPerc.Text), 0);
            LoadLines;
          end;
        Finally
          Free;
        End;{try}
      end;{with}
    end
    else
    begin
      // Pervasive
      with TfrmLine.Create(nil) do
      begin
        Try
          edtRemaining.Text := Format('%5.2f', [PercRemaining]);
          edtPerc.Text := edtRemaining.Text;
          ShowModal;
          if ModalResult = mrOK then
          begin
            FillChar(AllocRec, SizeOf(AllocRec), 0);
            AllocRec.CoCode := LJVar(CurrentCompany, 6);
            AllocRec.GLCode := StrToInt(edtGLCode.Text);
            AllocRec.AllocType := AlType;
            AllocRec.AllocName := LJVar(edtAllocName.Text, 20);
            AllocRec.AllocDesc := edtAllocDesc.Text;
            inc(LineCount);
            AllocRec.LinePos := LineCount;
            AllocRec.CC := edtCC.Text;
            AllocRec.Dep := edtDept.Text;
            AllocRec.Percentage := StrToFloat(edtPerc.Text);
            AllocRec.StopKey := '!';
            Res := AddRec;
            if Res <> 0 then
              ShowMessage('Unable to store line. Btrieve Error ' + IntToStr(Res));
            LoadLines;
          end;
        Finally
          Free;
        End;{try}
      end;{with}
    end;{if}
  end;{if}
end;

procedure TfrmCAAdmin.cbCompanyChange(Sender: TObject);
var
  Res : Integer;
begin
  edtGLCode.Text := '';
  edtGLDesc.Text := '';
  edtAllocName.Text := '';
  edtAllocDesc.Text := '';
  LoadLines;
  if oToolkit.Status = tkOpen then
    oToolkit.CloseToolkit;
  CurrentCompany := TCoCodeObj(cbCompany.Items.Objects[cbCompany.ItemIndex]).CoCode;
  oToolkit.Configuration.DataDirectory := TCoCodeObj(cbCompany.Items.Objects[cbCompany.ItemIndex]).CoDir;
  Res := oToolkit.OpenToolkit;
  if Res <> 0 then
    raise Exception.Create('Unable to open COM toolkit: ' + QuotedStr(oToolkit.LastErrorString));
  UseDosKeys := oToolkit.SystemSetup.ssUseDosKeys;
  LoadTree;
end;

procedure TfrmCAAdmin.btnEditLineClick(Sender: TObject);
var
  Res : Integer;
begin
  if Trim(edtAllocName.Text) <> '' then
  begin
    if FindCurrentLine then
    begin

      if bSQL then
      begin
        // MS-SQL
        with TfrmLine.Create(nil) do
        begin
          Try
            edtCC.Text := qRecords.FieldByName('CostCentre').AsString;
            edtDept.Text := qRecords.FieldByName('Department').AsString;
            edtPerc.Text := qRecords.FieldByName('Percentage').AsString;
            edtRemaining.Text := Format('%5.2f', [PercRemaining]);
            PercRemaining := PercRemaining + qRecords.FieldByName('Percentage').AsInteger;
            ShowModal;
            if ModalResult = mrOK then
            begin
              SQLDataModule.UpdateLine(CurrentCompany, StrToInt(edtGLCode.Text)
              , edtAllocName.Text, mlLines.Selected + 1, edtCC.Text
              , edtDept.Text, StrToFloat(edtPerc.Text));
              LoadLines;
            end;{if}
          Finally
            Free;
          End;{try}
        end;{with}
      end
      else
      begin
        // Pervasive
        with TfrmLine.Create(nil) do
        begin
          Try
            edtCC.Text := AllocRec.CC;
            edtDept.Text := AllocRec.Dep;
            edtPerc.Text := Format('%5.2f', [AllocRec.Percentage]);
            edtRemaining.Text := Format('%5.2f', [PercRemaining]);
            PercRemaining := PercRemaining + AllocRec.Percentage;
            ShowModal;
            if ModalResult = mrOK then
            begin
              AllocRec.CC := edtCC.Text;
              AllocRec.Dep := edtDept.Text;
              AllocRec.Percentage := StrToFloat(edtPerc.Text);
              Res := PutRec;
              if Res <> 0 then
                ShowMessage('Unable to store line. Btrieve Error ' + IntToStr(Res));
              LoadLines;
            end;
          Finally
            Free;
          End;
        end;{with}
      end;{if}
    end;{if}
  end;{if}
end;

procedure TfrmCAAdmin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if bSQL then
  begin
    // MS-SQL
    if Assigned(SQLDataModule) then
    begin
      SQLDataModule.Disconnect;
      SQLDataModule := nil;
    end;{if}
  end
  else
  begin
    // Pervasive
    CloseFile;
  end;{if}
end;

procedure TfrmCAAdmin.LoadLines;
var
  Res : Integer;
  KeyS, KeyChk : ShortString;
  CCDept, CCDeptDesc, CostCentreDesc, DepartmentDesc : string;
  i : integer;
  GL : Integer;

  procedure GetCostCentreDesc(CostCentreCode : string);
  var
    Res : Integer;
  begin
    CostCentreDesc := '';
    if Trim(CostCentreCode) <> '' then
    begin
      Res := oToolkit.CostCentre.GetEqual(oToolkit.CostCentre.BuildCodeIndex(CostCentreCode));

      if Res = 0 then
        CostCentreDesc := oToolkit.CostCentre.cdName;
    end;
  end;

  procedure GetDepartmentDesc(DepartmentCode : string);
  var
    Res : Integer;
  begin
    DepartmentDesc := '';
    if Trim(DepartmentCode) <> '' then
    begin
      Res := oToolkit.Department.GetEqual(oToolkit.Department.BuildCodeIndex(DepartmentCode));

      if Res = 0 then
        DepartmentDesc := oToolkit.Department.cdName;
    end;
  end;

var
  qRecords : TADOQuery;

begin
  PercRemaining := 100;

  if bSQL then
  begin
    // MS-SQL
    GL := StrToIntDef(edtGLCode.Text, 0);

    // Get Matching Recodrds
    qRecords := SQLDataModule.GetAllRecordsFor(CurrentCompany, GL, edtAllocName.Text);

    // First Record
    qRecords.First;

    ClearLines;
    Case AlType of
      0 : mlLines.Columns[0].Caption := 'Cost Centre';
      1 : mlLines.Columns[0].Caption := 'Department';
      2 : mlLines.Columns[0].Caption := 'CC/Department';
    end;
    LineCount := 0;

    // Loop through all the matching records
    while (not qRecords.EOF) do
    begin
     if qRecords.FieldByName('RecordType').AsInteger <> 1 then
     begin
      GetCostCentreDesc(qRecords.FieldByName('CostCentre').AsString);
      GetDepartmentDesc(qRecords.FieldByName('Department').AsString);
      Case qRecords.FieldByName('Type').AsInteger of
        0  : begin
               CCDept := qRecords.FieldByName('CostCentre').AsString;
               CCDeptDesc := CostCentreDesc;
             end;
        1  : begin
               CCDept := qRecords.FieldByName('Department').AsString;
               CCDeptDesc := DepartmentDesc;
             end;
        2  : begin
               CCDept := qRecords.FieldByName('CostCentre').AsString + ' / ' + qRecords.FieldByName('Department').AsString;
               CCDeptDesc := CostCentreDesc + ' / ' + DepartmentDesc;
             end;
      end;
      mlLines.DesignColumns[0].Items.Add(CCDept);
      mlLines.DesignColumns[1].Items.Add(CCDeptDesc);
      mlLines.DesignColumns[2].Items.Add(qRecords.FieldByName('Percentage').AsString);
      PercRemaining := PercRemaining - qRecords.FieldByName('Percentage').AsFloat;
      inc(LineCount);
     end;

     // Next Record
     qRecords.Next;
    end;
  end
  else
  begin
    // Pervasive
    FIndex := 1;
    Try
      GL := StrToInt(edtGLCode.Text);
    Except
      GL := 0;
    End;
    KeyS := CurrentCompany + FullNomKey(GL) + edtAllocName.Text;
    KeyChk := KeyS;
    Res := FindRec(KeyS, B_GetGEq);
    ClearLines;
    Case AlType of
      0 : mlLines.Columns[0].Caption := 'Cost Centre';
      1 : mlLines.Columns[0].Caption := 'Department';
      2 : mlLines.Columns[0].Caption := 'CC/Department';
    end;
    LineCount := 0;
    while (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) do
    begin
     if AllocRec.RecType <> 1 then
     begin
      GetCostCentreDesc(AllocRec.CC);
      GetDepartmentDesc(AllocRec.Dep);
      Case AllocRec.AllocType of
        0  : begin
               CCDept := AllocRec.CC;
               CCDeptDesc := CostCentreDesc;
             end;
        1  : begin
               CCDept := AllocRec.Dep;
               CCDeptDesc := DepartmentDesc;
             end;
        2  : begin
               CCDept := AllocRec.CC + ' / ' + AllocRec.Dep;
               CCDeptDesc := CostCentreDesc + ' / ' + DepartmentDesc;
             end;
      end;
      mlLines.DesignColumns[0].Items.Add(CCDept);
      mlLines.DesignColumns[1].Items.Add(CCDeptDesc);
      mlLines.DesignColumns[2].Items.Add(Format('%5.2f', [AllocRec.Percentage]));
      PercRemaining := PercRemaining - AllocRec.Percentage;
      inc(LineCount);
     end;

     // Next Record
     Res := FindRec(KeyS, B_GetNext);
    end;
  end;{if}

  edtUnalloc.Text := Format('%5.2f', [PercRemaining]);
end;

procedure TfrmCAAdmin.tvGLsClick(Sender: TObject);
var
  KeyS : ShortString;
  Res : Integer;
//  qRecords : TADOQuery;
begin
  if Assigned(tvGLs.Selected) then
  begin
    btnEdit.Enabled := tvGLs.Selected.Level > 0;

    if tvGLs.Selected.Level = 0 then
    begin
      edtGLCode.Text := GetGLTreeCode(tvGLs.Selected.Text);
      edtAllocName.Text := '';
      edtAllocDesc.Text := '';
      rbCC.Checked := True;
    end
    else
    begin
      if bSQL then
      begin
        // MS-SQL
        edtGLCode.Text := GetGLTreeCode(tvGLs.Selected.Parent.Text);

        qRecords := SQLDataModule.GetAllRecordsFor(CurrentCompany, StrToIntDef(edtGLCode.Text, 0), GetGLTreeCode(tvGLs.Selected.Text));
        if qRecords.RecordCount > 0 then
        begin
          qRecords.First;
          AlType := qRecords.FieldByName('Type').AsInteger;
          edtAllocName.Text := Trim(qRecords.FieldByName('Name').AsString);
          edtAllocDesc.Text := Trim(qRecords.FieldByName('Description').AsString);
          AlType := qRecords.FieldByName('Type').AsInteger;
          Case AlType of
            0 : rbCC.Checked := True;
            1 : rbDep.Checked := True;
            2 : rbCCDep.Checked := True;
          end;{case}
        end;{if}
      end
      else
      begin
        // Pervasive
        edtGLCode.Text := GetGLTreeCode(tvGLs.Selected.Parent.Text);
        FIndex := 1;
        KeyS := CurrentCompany + FullNomKey(StrToInt(edtGLCode.Text)) + GetGLTreeCode(tvGLs.Selected.Text);
        Res := FindRec(KeyS, B_GetGEq);
        if Res = 0 then
        begin
          AlType := AllocRec.AllocType;
          edtAllocName.Text := Trim(AllocRec.AllocName);
          edtAllocDesc.Text := Trim(AllocRec.AllocDesc);
          AlType := AllocRec.AllocType;
          Case AllocRec.AllocType of
            0 : rbCC.Checked := True;
            1 : rbDep.Checked := True;
            2 : rbCCDep.Checked := True;
          end;
        end;
      end;{if}
    end;

    if tvGLs.Selected.Level > 0 then
      LoadLines
    else
      ClearLines;


    with oToolkit do
    begin
      Res := GeneralLedger.GetEqual(GeneralLedger.BuildCodeIndex(StrToInt(edtGLCode.Text)));

      if Res = 0 then
        edtGLDesc.Text := GeneralLedger.glName;
    end;
  end;
end;

procedure TfrmCAAdmin.EnableControls(Details : Boolean);
var
  i : integer;
begin
  for i := 0 to ComponentCount - 1 do
    if (Components[i] is TButton) or (Components[i] is TComboBox) or (Components[i] is TTreeView) or
       (Components[i] is TRadioButton) then
      with Components[i] as TControl do
        Enabled := (Tag = 100) xor Details
    else
    if (Components[i] is TEdit) and (Components[i] <> edtGLDesc) then
      with Components[i] as TEdit do
        ReadOnly := not Details;
end;

procedure TfrmCAAdmin.btnCancelClick(Sender: TObject);
begin
  EnableControls(False);
  ActiveControl := tvGLs;
  tvGLsClick(Self);
end;

procedure TfrmCAAdmin.SBSButton1Click(Sender: TObject);
begin
  if EditMode then
    SaveAfterEdit
  else
    SaveAfterAdd;
  EnableControls(False);
  {if not EditMode then}
    LoadTree;
  SelectCurrentRecInTree;
  ActiveControl := tvGLs;
  if Assigned(tvGLs.Selected) then
    tvGLs.Selected.MakeVisible;
end;

procedure TfrmCAAdmin.SaveAfterEdit;
var
  Res : Integer;
  KeyS, KeyChk : ShortString;
  KeyChanged : Boolean;
  OldAlloc : TAllocRec;
  GL : longint;
  qNewRecords : TADOQuery;
begin
  GL := StrToInt(edtGLCode.Text);

  if bSQL then
  begin
    // MS-SQL
    SQLDataModule.UpdateAllRecordsFor(qRecords.FieldbyName('CompanyCode').AsString
    , qRecords.FieldbyName('GLCode').AsInteger, qRecords.FieldbyName('Name').AsString
    , LJVar(Trim(edtAllocName.Text), 20), Trim(edtAllocDesc.Text), AlType);
  end
  else
  begin
    // Pervasive
    KeyChanged := (Trim(AllocRec.AllocName) <> Trim(edtAllocName.Text));

    OldAlloc := AllocRec;

    Res := 0;

    while (Res = 0) and (OldAlloc.CoCode = AllocRec.CoCode) and
                        (OldAlloc.GLCode = AllocRec.GLCode) and
                        (OldAlloc.AllocName = AllocRec.AllocName) do
    begin
      AllocRec.AllocName := LJVar(Trim(edtAllocName.Text), 20);
      AllocRec.AllocDesc := Trim(edtAllocDesc.Text);
      AllocRec.AllocType := AlType;

      Res := PutRec;

      KeyS := OldAlloc.CoCode + FullNomKey(OldAlloc.GLCode) + OldAlloc.AllocName;
      if KeyChanged then
        Res := FindRec(KeyS, B_GetGEq)
      else
        Res := FindRec(KeyS, B_GetNext);
    end;
  end;{if}

end;

procedure TfrmCAAdmin.SaveAfterAdd;
begin
  if bSQL then
  begin
    // MS-SQL
    SQLDataModule.AddRecord(LJVar(CurrentCompany, 6), StrToInt(edtGLCode.Text), 0, ALType
    , LJVar(Trim(edtAllocName.Text), 20), Trim(edtAllocDesc.Text), '', '', 0, 1);
  end
  else
  begin
    // Pervasive
    FillChar(AllocRec, SizeOf(AllocRec), 0);
    AllocRec.CoCode := LJVar(CurrentCompany, 6);
    AllocRec.AllocName := LJVar(Trim(edtAllocName.Text), 20);
    AllocRec.AllocDesc := Trim(edtAllocDesc.Text);
    AllocRec.AllocType := AlType;
    AllocRec.GLCode := StrToInt(edtGLCode.Text);
    AllocRec.RecType := 1;
    AddRec;
  end;{if}
end;

procedure TfrmCAAdmin.edtGLCodeExit(Sender: TObject);
var
  i : integer;
begin
  if (ActiveControl <> btnCancel) and not edtGLCode.ReadOnly then
  begin
    Try
      i := StrToInt(edtGLCode.Text);
    Except
      i := 0;
    End;
    edtGLCode.Text := GetGLCode(i, oToolkit);
    if edtGLCode.Text = '' then
      ActiveControl := edtGLCode
    else
    with oToolkit do
    begin
      i := GeneralLedger.GetEqual(GeneralLedger.BuildCodeIndex(StrToInt(edtGLCode.Text)));

      if i = 0 then
        edtGLDesc.Text := GeneralLedger.glName;
    end;

  end;
end;

function TfrmCAAdmin.AllocExists : Boolean;
var
  Res : Integer;
  KeyS : ShortString;
begin
  if bSQL then
  begin
    // MS-SQL
    qRecords := SQLDataModule.GetAllRecordsFor(CurrentCompany, StrToIntDef(edtGLCode.Text, 0), edtAllocName.Text);
    Result := qRecords.RecordCount > 0
  end
  else
  begin
    // Pervasive
    FIndex := 1;
    KeyS := CurrentCompany + FullNomKey(StrToInt(edtGLCode.Text)) + edtAllocName.Text;

    Res := FindRec(KeyS, B_GetGEq);

    Result := (Res = 0) and (AllocRec.CoCode = CurrentCompany) and
              (AllocRec.GLCode = StrToInt(edtGLCode.Text)) and
              (UpperCase(Trim(AllocRec.AllocName)) = UpperCase(Trim(edtAllocName.Text)));
  end;{if}
end;

procedure TfrmCAAdmin.edtAllocNameExit(Sender: TObject);
begin
  if (ActiveControl <> btnCancel) and edtGLCode.Enabled and not (edtAllocName.ReadOnly) and AllocExists then
  begin
    ShowMessage('Allocation ' + QuotedStr(edtAllocName.Text) + ' already exists');
    ActiveControl := edtAllocName;
  end;
end;

function TfrmCAAdmin.FindCurrentLine : Boolean;
var
  Res, KeyLen : Integer;
  KeyS, KeyChk : ShortString;
begin
  if bSQL then
  begin
    // MS-SQL
    qRecords := SQLDataModule.GetLine(CurrentCompany, StrToInt(edtGLCode.Text), edtAllocName.Text, mlLines.Selected + 1);
    Result := qRecords.RecordCount > 0;
  end
  else
  begin
    // Pervasive
    FIndex := 0;
    KeyS := CurrentCompany + FullNomKey(StrToInt(edtGLCode.Text)) + edtAllocName.Text;
    KeyChk := KeyS;
    KeyLen := Length(KeyS);

    Result := False;
    Res := FindRec(KeyS, B_GetGEq);

    while (Res = 0) and (Copy(KeyS, 1, KeyLen) = KeyChk) and not Result do
    begin
      Result := (mlLines.Selected >=0) and (AllocRec.LinePos = mlLines.Selected + 1);

      if not Result then
        Res := FindRec(KeyS, B_GetNext);
    end;
  end;{if}
end;

procedure TfrmCAAdmin.SelectCurrentRecInTree;
var
  i : integer;
  Found : Boolean;
begin
  Found := False;
  with tvGLs.Items do
  begin
     for i := 0 to Count - 1 do
     begin
       if (GetGLTreeCode(Item[i].Text) = edtAllocName.Text) and
           Assigned(Item[i].Parent) and
          (GetGLTreeCode(Item[i].Parent.Text) = edtGLCode.Text) then
       begin
         tvGLs.Select(Item[i], []);
         tvGLsClick(Self);
         Break;
       end;
     end;
  end;
end;

function TfrmCAAdmin.GetGLTreeCode(const s : string) : string;
var
  i : integer;
begin
  i := Pos(',', s);
  if i = 0 then
    Result := s
  else
    Result := Copy(s, 1, i-1);
end;

procedure TfrmCAAdmin.mlLinesRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnEditLineClick(Self);
end;

procedure TfrmCAAdmin.Button6Click(Sender: TObject);
var
  i : integer;
begin
  if Trim(edtAllocName.Text) <> '' then
  begin
    if FindCurrentLine then
    begin
      if MsgBox('Are you sure you want to delete this line?',
              mtConfirmation, mbYesNoCancel, mbYes, 'Delete line') = mrYes then
      begin
        if bSQL then
        begin
          // MS-SQL
          i := qRecords.FieldByName('LinePos').AsInteger;
          SQLDataModule.DeleteLine(CurrentCompany, StrToInt(edtGLCode.Text), edtAllocName.Text, i);
          RenumLines(i);
          LoadLines;
        end
        else
        begin
          // Pervasive
          i := AllocRec.LinePos;
          DeleteRec;
          RenumLines(i);
          LoadLines;
        end;{if}
      end;{if}
    end;{if}
  end;{if}
end;

procedure TfrmCAAdmin.SetTree;
begin
  ActiveControl := tvGLs;
end;

procedure TfrmCAAdmin.RenumLines(StartLine : integer);
var
  Res, Res1, KeyLen : Integer;
  KeyS, KeyChk : ShortString;
begin
  if bSQL then
  begin
    // MS-SQL
    SQLDataModule.RenumberLines(CurrentCompany, StrToInt(edtGLCode.Text), edtAllocName.Text, StartLine)
  end
  else
  begin
    // Pervasive
    FIndex := 0;
    KeyS := CurrentCompany + FullNomKey(StrToInt(edtGLCode.Text)) + edtAllocName.Text;
    KeyChk := KeyS;
    KeyLen := Length(KeyS);

    Res := FindRec(KeyS, B_GetGEq);

    while (Res = 0) and (Copy(KeyS, 1, KeyLen) = KeyChk) do
    begin
      if AllocRec.LinePos > StartLine then
        AllocRec.LinePos := AllocRec.LinePos - 1;

      Res1 := PutRec;

      Res := FindRec(KeyS, B_GetNext);
    end;
  end;{if}
end;

procedure TfrmCAAdmin.DeleteAlloc;
var
  Res, Res1, KeyLen : Integer;
  KeyS, KeyChk : ShortString;
begin
  if MsgBox('Are you sure you want to delete this allocation?',
            mtConfirmation, mbYesNoCancel, mbYes, 'Delete Allocation') = mrYes then
  begin
    if bSQL then
    begin
      // MS-SQL
      SQLDataModule.DeleteRecords(CurrentCompany, StrToInt(edtGLCode.Text), edtAllocName.Text)
    end
    else
    begin
      // Pervasive
      FIndex := 0;
      KeyS := CurrentCompany + FullNomKey(StrToInt(edtGLCode.Text)) + edtAllocName.Text;
      KeyChk := KeyS;
      KeyLen := Length(KeyS);

      Res := FindRec(KeyS, B_GetGEq);

      while (Res = 0) and (Copy(KeyS, 1, KeyLen) = KeyChk) do
      begin
        DeleteRec;

        Res := FindRec(KeyS, B_GetGEq);
      end;
    end;{if}
  end;
end;

procedure TfrmCAAdmin.DeleteGL;
var
  Res, Res1, KeyLen : Integer;
  KeyS, KeyChk : ShortString;
begin
  if MsgBox('Are you sure you want to delete all allocations for this GL code?',
            mtConfirmation, mbYesNoCancel, mbYes, 'Delete Allocations') = mrYes then
  begin
    if bSQL then
    begin
      // MS-SQL
      SQLDataModule.DeleteRecords(CurrentCompany, StrToInt(edtGLCode.Text), '')
    end
    else
    begin
      // Pervasive
      FIndex := 0;
      KeyS := CurrentCompany + FullNomKey(StrToInt(edtGLCode.Text));
      KeyChk := KeyS;
      KeyLen := Length(KeyS);

      Res := FindRec(KeyS, B_GetGEq);

      while (Res = 0) and (Copy(KeyS, 1, KeyLen) = KeyChk) do
      begin
        DeleteRec;

        Res := FindRec(KeyS, B_GetGEq);
      end;
    end;{if}
  end;
end;

procedure TfrmCAAdmin.Button3Click(Sender: TObject);
begin
  if Assigned(tvGLs.Selected) then
  begin
    if tvGLs.Selected.Level = 0 then
      DeleteGL
    else
      DeleteAlloc;
    LoadTree;
    LoadLines;
  end;
end;

procedure TfrmCAAdmin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TfrmCAAdmin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

function TfrmCAAdmin.RecExists(const CC, Dep : string) : Boolean;
var
  Res, Res1, KeyLen : Integer;
  KeyS, KeyChk : ShortString;
begin
  if bSQL then
  begin
    // MS-SQL
    qRecords := SQLDataModule.GetAllRecordsWithCCDept(CurrentCompany, StrToIntDef(edtGLCode.Text, 0), edtAllocName.Text, CC, Dep);
    Result := qRecords.RecordCount > 0
  end
  else
  begin
    // Pervasive
    Result := False;
    FIndex := 0;
    KeyS := CurrentCompany + FullNomKey(StrToInt(edtGLCode.Text)) + edtAllocName.Text;
    KeyChk := KeyS;
    KeyLen := Length(KeyS);

    Res := FindRec(KeyS, B_GetGEq);

    while (Res = 0) and (Copy(KeyS, 1, KeyLen) = KeyChk) and not Result do
    begin
      if  (Trim(AllocRec.CC) = CC) and (Trim(AllocRec.Dep) = Dep) then
        Result := True
      else
        Res := FindRec(KeyS, B_GetNext);
    end;
  end;{if}
end;

procedure TfrmCAAdmin.ClearLines;
var
  i : integer;
begin
  for i := 0 to 2 do
    mlLines.DesignColumns[i].Items.Clear;
end;

procedure TfrmCAAdmin.tvGLsChange(Sender: TObject; Node: TTreeNode);
begin
  tvGLsClick(Self);
end;

end.
