unit FieldDetails;

{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DictRecord, MiscUtil, TEditVal, CheckLst, ExtCtrls,
  Menus, EnterToTab;

type
  TfrmFieldDetails = class(TForm)
    edFieldCode: TEdit;
    lFieldNAme: TLabel;
    Label1: TLabel;
    edDescription: TEdit;
    Label2: TLabel;
    cmbDataType: TComboBox;
    Label3: TLabel;
    edLength: TCurrencyEdit;
    Label4: TLabel;
    Label5: TLabel;
    edFixedDPs: TCurrencyEdit;
    btnOK: TButton;
    btnCancel: TButton;
    Label6: TLabel;
    edRepTitle: TEdit;
    cbVariableDPs: TCheckBox;
    cmbVarDecType: TComboBox;
    Label7: TLabel;
    edFormatMask: TEdit;
    cbPeriodSelect: TCheckBox;
    cmbInputType: TComboBox;
    Label8: TLabel;
    lbAvailableFiles: TCheckListBox;
    Label9: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    lbExchVersions: TCheckListBox;
    Label10: TLabel;
    edVarNo: TCurrencyEdit;
    lVarDecPlaceType: TLabel;
    Label12: TLabel;
    pmFiles: TPopupMenu;
    SelectAll1: TMenuItem;
    DeselectAll1: TMenuItem;
    pmVersions: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    N1: TMenuItem;
    SelectAllProfessional1: TMenuItem;
    SelectAllMultiCurrency1: TMenuItem;
    SelectAllStock1: TMenuItem;
    SelectAllSPOP1: TMenuItem;
    SelectAllJC1: TMenuItem;
    EnterToTab1: TEnterToTab;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbVariableDPsClick(Sender: TObject);
    procedure SelectDeselectAll(Sender: TObject);
    procedure SelectAllProfessional1Click(Sender: TObject);
    procedure SelectAllMultiCurrency1Click(Sender: TObject);
    procedure SelectAllStock1Click(Sender: TObject);
    procedure SelectAllSPOP1Click(Sender: TObject);
    procedure SelectAllJC1Click(Sender: TObject);
    procedure cmbDataTypeChange(Sender: TObject);
    procedure edDescriptionExit(Sender: TObject);
    procedure edFieldCodeExit(Sender: TObject);
  private
    iOriginalVarNo : integer;
    sOriginalFieldCode : string;
    Procedure Record2Form;
    Procedure Form2Record;
    procedure EnableDisable;
    function GetNextAvailableVarNo(iNo : integer): integer;
  public
    bCopy : boolean;
    DictionaryRec : DataDictRec;
    FormMode : TFormMode;
  end;

var
  frmFieldDetails: TfrmFieldDetails;

implementation
uses
  DictionaryProc, BTFiles, BTUtil, BTConst, APIUtil, StrUtil, MathUtil,
  Progress;

{$R *.dfm}

procedure TfrmFieldDetails.FormShow(Sender: TObject);

  procedure FillCombos;
  var
    iPos : integer;
  begin{FillCombos}

    // Fill Data Type Combo
    cmbDataType.Items.Clear;
    For iPos := 1 to NoOfDataTypes do
    begin
      cmbDataType.Items.Add(aDataTypeDesc[iPos]);
    end;{for}

    // Fill Variable Decimal Places Combo
    cmbVarDecType.Items.Clear;
    For iPos := 1 to NoOfVarDecTypes do
    begin
      cmbVarDecType.Items.Add(aVarDecTypeDesc[iPos]);
    end;{for}

    // Fill Input Type Combo
    cmbInputType.Items.Clear;
    For iPos := 1 to NoOfInputTypes do
    begin
      cmbInputType.Items.Add(aInputTypeDesc[iPos]);
    end;{for}

    // Fill Available Files List
    lbAvailableFiles.Items.Clear;
    For iPos := 1 to NoOfAvailFiles do
    begin
      lbAvailableFiles.Items.Add(aAvailFilesDesc[iPos]);
    end;{for}

    // Fill Exchequer Versions List
    lbExchVersions.Items.Clear;
    For iPos := 1 to NoOfExchVersions do
    begin
      lbExchVersions.Items.Add(aExchVersionsDesc[iPos]);
    end;{for}

  end;{FillCombos}

begin
  case FormMode of
    fmAdd : begin
      DictionaryRec.DataVarRec.VarNo := GetNextAvailableVarNo(PrevRec.iLastAddedVarNo);

      if not bCopy then
      begin
        DictionaryRec.DataVarRec.AvailFile := PrevRec.iAvailFile;
        DictionaryRec.DataVarRec.AvailFile2 := PrevRec.iAvailFile2;
        DictionaryRec.DataVarRec.AvailVer := PrevRec.iAvailVer;
        DictionaryRec.DataVarRec.VarType := 1;
        DictionaryRec.DataVarRec.VarLen := 13;
      end;{if}

      Caption := 'Add New Field';
    end;

    fmEdit : Caption := 'Edit Field';
  end;{case}


  FillCombos;
  Record2Form;
end;

Procedure TfrmFieldDetails.Record2Form;

  procedure SetVersionList(iBitField : integer);
  var
    iPos : integer;
  begin{SetVersionList}
    For iPos := 1 to NoOfExchVersions do
    begin
      lbExchVersions.Checked[iPos -1] := BitIsSet(iBitField, aExchVersionsBitFlag[iPos]);
    end;{for}
  end;{SetVersionList}

  procedure SetFilesList(iBitField1, iBitField2 : integer);
  var
    iPos : integer;
  begin{SetFilesList}
    For iPos := 1 to NoOfAvailFiles do
    begin
      if iPos < 32
      then lbAvailableFiles.Checked[iPos -1] := BitIsSet(iBitField1
      , aAvailFilesBitFlag[iPos])  // 1-31 stored in the first field
      else lbAvailableFiles.Checked[iPos -1] := BitIsSet(iBitField2
      , aAvailFilesBitFlag[iPos]); // 32- stored in the second field
    end;{for}
  end;{SetFilesList}

begin{Record2Form}
  iOriginalVarNo := DictionaryRec.DataVarRec.VarNo;
  sOriginalFieldCode := DictionaryRec.DataVarRec.VarName;

  edFieldCode.Text := Trim(DictionaryRec.DataVarRec.VarName);
  edVarNo.Value := DictionaryRec.DataVarRec.VarNo;
  edDescription.Text := Trim(DictionaryRec.DataVarRec.VarDesc);
  cmbDataType.ItemIndex := DictionaryRec.DataVarRec.VarType -1;
  edLength.Value := DictionaryRec.DataVarRec.VarLen;
  edFixedDPs.Value := DictionaryRec.DataVarRec.VarNoDec;
  edRepTitle.Text := Trim(DictionaryRec.DataVarRec.RepDesc);
  edFormatMask.Text := Trim(DictionaryRec.DataVarRec.Format);
  cbPeriodSelect.Checked := DictionaryRec.DataVarRec.PrSel;
  cmbVarDecType.ItemIndex := DictionaryRec.DataVarRec.VarDecType -1;
  cbVariableDPs.Checked := DictionaryRec.DataVarRec.VarDec;
  cmbInputType.ItemIndex := DictionaryRec.DataVarRec.InputType;
  SetVersionList(DictionaryRec.DataVarRec.AvailVer);
  SetFilesList(DictionaryRec.DataVarRec.AvailFile, DictionaryRec.DataVarRec.AvailFile2);
  EnableDisable;
end;{Record2Form}

Procedure TfrmFieldDetails.Form2Record;

  function GetVersionList : integer;
  var
    iPos : integer;
  begin{GetVersionList}
    Result := 0;
    For iPos := 0 to lbExchVersions.Items.Count -1 do
    begin
      if lbExchVersions.Checked[iPos]
      then Result := Result + aExchVersionsBitFlag[iPos + 1];
    end;{for}
  end;{GetVersionList}

  procedure GetFilesList(var iBitField1, iBitField2 : integer);
  var
    iPos : integer;
  begin{GetFilesList}
    iBitField1 := 0;
    iBitField2 := 0;
    For iPos := 0 to lbAvailableFiles.Items.Count -1 do
    begin
      if lbAvailableFiles.Checked[iPos]
      then begin
        if iPos < 31
        then iBitField1 := iBitField1 + aAvailFilesBitFlag[iPos + 1] // 1-31 stored in the first field
        else iBitField2 := iBitField2 + aAvailFilesBitFlag[iPos + 1]; // 32- stored in the second field
      end;{if}
    end;{for}
  end;{GetFilesList}

begin{Form2Record}
  DictionaryRec.DataVarRec.VarName := PadString(psRight, Trim(edFieldCode.Text), ' ', 8);
  DictionaryRec.DataVarRec.VarPadNo := PadString(psLeft, Trim(edVarNo.Text), '0', 6);
  DictionaryRec.DataVarRec.VarNo := StrToIntDef(edVarNo.Text, 0);
  DictionaryRec.DataVarRec.VarDesc :=  Trim(edDescription.Text);
  DictionaryRec.DataVarRec.VarType := cmbDataType.ItemIndex + 1;
  DictionaryRec.DataVarRec.VarLen := StrToIntDef(edLength.Text, 0);
  DictionaryRec.DataVarRec.VarNoDec := StrToIntDef(edFixedDPs.Text, 0);
  DictionaryRec.DataVarRec.RepDesc := Trim(edRepTitle.Text);
  DictionaryRec.DataVarRec.Format := Trim(edFormatMask.Text);
  DictionaryRec.DataVarRec.PrSel := cbPeriodSelect.Checked;
  DictionaryRec.DataVarRec.VarDecType := cmbVarDecType.ItemIndex + 1;
  DictionaryRec.DataVarRec.VarDec := cbVariableDPs.Checked;
  DictionaryRec.DataVarRec.InputType := cmbInputType.ItemIndex;
  DictionaryRec.DataVarRec.AvailVer := GetVersionList;
  GetFilesList(DictionaryRec.DataVarRec.AvailFile, DictionaryRec.DataVarRec.AvailFile2);
end;{Form2Record}

procedure TfrmFieldDetails.FormCreate(Sender: TObject);
begin
  bCopy := FALSE;
  edlength.displayformat := '##0';
  edFixedDPs.displayformat := '#0';
  edVarNo.displayformat := '#####0';
end;

procedure TfrmFieldDetails.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmFieldDetails.btnOKClick(Sender: TObject);

  function ValidateRecord : boolean;
  var
    sError : string;
    iNewNo : integer;

    function DuplicateVarNumber(var iNextNo : integer) : boolean;
    var
      BTRec : TBTRec;
      LDictionaryRec : DataDictRec;
    begin{DuplicateVarNumber}
      iNextNo := 0;
      Result := FALSE;
      BTRec.KeyS := DictRecordPrefix + DictionaryRec.DataVarRec.VarPadNo;
      BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[DictionaryF], LDictionaryRec
      , SizeOf(LDictionaryRec), dtIdxVarNo, BTRec.KeyS);

      if (FormMode = fmAdd) and (BTRec.Status = 0) then
      begin
        Result := TRUE;
        iNextNo := GetNextAvailableVarNo(StrToIntDef(DictionaryRec.DataVarRec.VarPadNo, 0));
      end;{if}

      // if (FormMode = fmEdit) and (BTRec.Status = 0) then Result := TRUE;  / cant test for duplicates of edits, as there is no folio number, and the var no may have been changed
      if (FormMode = fmEdit) and (BTRec.Status = 0)
      and (LDictionaryRec.DataVarRec.VarNo <> iOriginalVarNo) then Result := TRUE;
    end;{DuplicateVarNumber}

    function DuplicateFieldCode : boolean;
    var
      BTRec : TBTRec;
      LDictionaryRec : DataDictRec;
    begin{DuplicateFieldCode}
      Result := FALSE;
      BTRec.KeyS := DictRecordPrefix + DictionaryRec.DataVarRec.VarName;
      BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[DictionaryF], LDictionaryRec
      , SizeOf(LDictionaryRec), dtIdxFieldCode, BTRec.KeyS);
      if (FormMode = fmAdd) and (BTRec.Status = 0) then Result := TRUE;
      if (FormMode = fmEdit) and (BTRec.Status = 0)
      and (LDictionaryRec.DataVarRec.VarNo <> iOriginalVarNo) then Result := TRUE;
    end;{DuplicateFieldCode}

  begin{ValidateRecord}
    sError := '';
    if DuplicateVarNumber(iNewNo) then
    begin
      sError := 'Var Number (Duplicate)';
      if MsgBox('The Var Number you have entered is a duplicate number.'#13#13
      + 'The next number in the sequence is ' + IntToStr(iNewNo) + #13#13'Do you wish to use this number ?'
      , mtConfirmation, [mbYes, mbNo], mbYes, 'Duplicate Var No') = mrYes then
      begin
        edVarNo.Value := iNewNo;
        DictionaryRec.DataVarRec.VarPadNo := PadString(psLeft, IntToStr(iNewNo), '0', 6);
        sError := '';
      end else
      begin
        ActiveControl := edVarNo;
      end;{if}
    end;{if}

    if sError = '' then
    begin
      if DuplicateFieldCode then  sError := 'Field Code (Duplicate)'
      else begin
        if cmbInputType.ItemIndex < 0 then sError := 'Input Type'
        else begin
          if cmbDataType.ItemIndex < 0 then sError := 'Data Type'
          else begin
            if cbVariableDPs.Checked and (cmbVarDecType.ItemIndex < 0)
            then sError := 'Variable Decimal Places Type'
            else begin
            end;{if}
          end;{if}
        end;{if}
      end;{if}
    end;{if}

    if sError <> '' then
    begin
      if sError <> 'Var Number (Duplicate)' then
      begin
        MsgBox('There appears to be an incorrect value entered in the field : '#13#13#9
        + sError, mtError, [mbOK], mbOK, 'Validation Error');
      end;{if}
    end;{if}

    Result := sError = ''
  end;{ValidateRecord}

var
  BTRec : TBTRec;
  LDictionaryRec : DataDictRec;
  bContinue : boolean;

begin
  bContinue := TRUE;
  Form2Record;

  if ((DictionaryRec.DataVarRec.AvailFile = 0) and (DictionaryRec.DataVarRec.AvailFile2 = 0))
  or (DictionaryRec.DataVarRec.AvailVer = 0) then
  begin
    bContinue := MsgBox('You have not selected Files and Versions from the lists'#13#13
    + 'Are you sure you want to save this record ?', mtConfirmation, [mbYes, mbNo]
    , mbNo, 'Save Record ?') = mrYes;
  end;{if}

  if bContinue then
  begin
    Screen.Cursor := crHourglass;

    if ValidateRecord then
    begin
      // show progress window
      frmProgress := TfrmProgress.Create(self);
      frmProgress.Show;
      Application.ProcessMessages;

      case FormMode of
        fmAdd : begin
          BTRec.Status := BTAddRecord(btFileVar[DictionaryF], DictionaryRec
          , SizeOf(LDictionaryRec), 0);
          BTShowError(BTRec.Status, 'BTAddRecord', btFileName[DictionaryF]);
          if BTRec.Status = 0
          then begin
            frmProgress.UpdateStatus('Adding cross-reference records');
            AddAllXrefRecs(DictionaryRec.DataVarRec);

            PrevRec.iLastAddedVarNo := DictionaryRec.DataVarRec.VarNo;
            PrevRec.iAvailFile := DictionaryRec.DataVarRec.AvailFile;
            PrevRec.iAvailFile2 := DictionaryRec.DataVarRec.AvailFile2;
            PrevRec.iAvailVer := DictionaryRec.DataVarRec.AvailVer;
          end;{if}
        end;

        fmEdit : begin

          // find record to update
          BTRec.KeyS := DictRecordPrefix + PadString(psLeft, IntToStr(iOriginalVarNo), '0', 6);
          BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[DictionaryF], LDictionaryRec
          , SizeOf(LDictionaryRec), dtIdxVarNo, BTRec.KeyS);
          if BTRec.Status = 0 then
          begin
            // Update Record
            BTRec.Status := BTUpdateRecord(btFileVar[DictionaryF], DictionaryRec
            , {btBufferSize[DictionaryF]} SizeOf(DictionaryRec), dtIdxVarNo, BTRec.KeyS);
            BTShowError(BTRec.Status, 'BTUpdateRecord', btFileName[DictionaryF]);

            if BTRec.Status = 0 then
            begin
              frmProgress.UpdateStatus('Deleting cross-reference records');
              DeleteAllXrefRecs(sOriginalFieldCode);
              frmProgress.UpdateStatus('Adding cross-reference records');
              AddAllXrefRecs(DictionaryRec.DataVarRec);

              PrevRec.iAvailFile := DictionaryRec.DataVarRec.AvailFile;
              PrevRec.iAvailFile2 := DictionaryRec.DataVarRec.AvailFile2;
              PrevRec.iAvailVer := DictionaryRec.DataVarRec.AvailVer;
            end;
          end;{if}
        end;
      end;{case}

      frmProgress.Hide;
      frmProgress.Release;

      if BTRec.Status = 0 then ModalResult := mrOK;
    end;{if}
    Screen.Cursor := crDefault;
  end;{if}
end;

procedure TfrmFieldDetails.cbVariableDPsClick(Sender: TObject);
begin
  EnableDisable;
  cmbDataTypeChange(nil);
end;

procedure TfrmFieldDetails.EnableDisable;
begin
  cmbVarDecType.Enabled := cbVariableDPs.Checked;
  lVarDecPlaceType.Enabled := cmbVarDecType.Enabled;
end;

procedure TfrmFieldDetails.SelectDeselectAll(Sender: TObject);
var
  CheckListBox : TCheckListBox;
  bSetTo : boolean;
  iPos : integer;
begin
  if TMenuItem(Sender).Tag in [0,2]
  then CheckListBox := lbAvailableFiles;
  if TMenuItem(Sender).Tag in [1,3]
  then CheckListBox := lbExchVersions;

  bSetTo := TMenuItem(Sender).Tag > 1;

  For iPos := 0 to CheckListBox.Items.Count -1
  do CheckListBox.Checked[iPos] := bSetTo;
end;

procedure TfrmFieldDetails.SelectAllProfessional1Click(Sender: TObject);
begin
  lbExchVersions.Checked[2] := TRUE;
  lbExchVersions.Checked[3] := TRUE;
  lbExchVersions.Checked[4] := TRUE;
  lbExchVersions.Checked[5] := TRUE;
end;

procedure TfrmFieldDetails.SelectAllMultiCurrency1Click(Sender: TObject);
begin
  lbExchVersions.Checked[6] := TRUE;
  lbExchVersions.Checked[7] := TRUE;
  lbExchVersions.Checked[8] := TRUE;
  lbExchVersions.Checked[9] := TRUE;
  lbExchVersions.Checked[11] := TRUE;
end;

procedure TfrmFieldDetails.SelectAllStock1Click(Sender: TObject);
begin
  lbExchVersions.Checked[1] := TRUE;
  lbExchVersions.Checked[3] := TRUE;
  lbExchVersions.Checked[4] := TRUE;
  lbExchVersions.Checked[5] := TRUE;
  lbExchVersions.Checked[7] := TRUE;
  lbExchVersions.Checked[8] := TRUE;
  lbExchVersions.Checked[9] := TRUE;
end;

procedure TfrmFieldDetails.SelectAllSPOP1Click(Sender: TObject);
begin
  lbExchVersions.Checked[4] := TRUE;
  lbExchVersions.Checked[5] := TRUE;
  lbExchVersions.Checked[8] := TRUE;
  lbExchVersions.Checked[9] := TRUE;
end;

procedure TfrmFieldDetails.SelectAllJC1Click(Sender: TObject);
begin
  lbExchVersions.Checked[5] := TRUE;
  lbExchVersions.Checked[9] := TRUE;
end;

function TfrmFieldDetails.GetNextAvailableVarNo(iNo : integer): integer;
var
  LDictionaryRec : DataDictRec;
  BTRec : TBTRec;
begin
  Repeat
    inc(iNo);
    BTRec.KeyS := DictRecordPrefix + PadString(psLeft, IntToStr(iNo), '0', 6);;
    BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[DictionaryF], LDictionaryRec
    , SizeOf(LDictionaryRec), dtIdxVarNo, BTRec.KeyS);
  until BTRec.Status <> 0;
  Result := iNo;
end;

procedure TfrmFieldDetails.cmbDataTypeChange(Sender: TObject);
begin
  case cmbDataType.ItemIndex of
    1,2,8 : begin
      if cbVariableDPs.Checked then edfixeddps.Value := 6
      else edfixeddps.Value := 2;

      if cmbDataType.ItemIndex = 8 then edLength.Value := 3;
    end;

    3 : begin
      edLength.Value := 8;
      edfixeddps.Value := 0;
    end;

    4 : begin
      edLength.Value := 1;
      edfixeddps.Value := 0;
    end;

    5 : begin
      edLength.Value := 9;
      edfixeddps.Value := 0;
    end;

    10 : begin
      edLength.Value := 3;
      edfixeddps.Value := 0;
    end;

    else edfixeddps.Value := 0;
  end;
end;

procedure TfrmFieldDetails.edDescriptionExit(Sender: TObject);
begin
  if Trim(edRepTitle.Text) = '' then edRepTitle.Text := edDescription.Text
end;

procedure TfrmFieldDetails.edFieldCodeExit(Sender: TObject);
begin
  edFieldCode.Text := UpperCase(edFieldCode.Text);
end;

end.
