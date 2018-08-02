unit SetFromXL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TEditVal, ComCtrls;

type
  TraMode = (raVarNo, raFieldCode);

  TfrmSetFieldFromXL = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    pcTabs: TPageControl;
    tsFields: TTabSheet;
    TabSheet2: TTabSheet;
    Shape4: TShape;
    Label2: TLabel;
    Shape2: TShape;
    Shape3: TShape;
    Label3: TLabel;
    Shape7: TShape;
    Shape5: TShape;
    rbFile: TRadioButton;
    rbVersion: TRadioButton;
    cmbFile: TComboBox;
    cmbVersion: TComboBox;
    cbSetTo: TCheckBox;
    lbVarNos: TListBox;
    Button1: TButton;
    dlgOpen: TOpenDialog;
    Button2: TButton;
    lCount: TLabel;
    rbVarNo: TRadioButton;
    rbFieldCode: TRadioButton;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ThingsChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ReadAsClick(Sender: TObject);
  private
    raMode : TraMode;
  public
    { Public declarations }
  end;

var
  frmSetFieldFromXL: TfrmSetFieldFromXL;

implementation
uses
  DictionaryProc, MathUtil, BTFiles, Progress, BTUtil, BTConst, StrUtil, APIUtil
  , DictRecord;

{$R *.dfm}

procedure TfrmSetFieldFromXL.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmSetFieldFromXL.FormCreate(Sender: TObject);
var
  iPos : integer;
begin
  raMode := raVarNo;

  // Fill Available Files List
  cmbFile.Items.Clear;
  For iPos := 1 to NoOfAvailFiles do
  begin
    cmbFile.Items.Add(aAvailFilesDesc[iPos]);
  end;{for}
  cmbFile.ItemIndex := 0;

  // Fill Exchequer Versions List
  cmbVersion.Items.Clear;
  For iPos := 1 to NoOfExchVersions do
  begin
    cmbVersion.Items.Add(aExchVersionsDesc[iPos]);
  end;{for}
  cmbVersion.ItemIndex := 0;

  ThingsChange(nil);
end;

procedure TfrmSetFieldFromXL.ThingsChange(Sender: TObject);
begin
  cmbFile.Enabled := rbFile.checked;
  cmbVersion.Enabled := rbVersion.checked;

  if cmbFile.Enabled and (cmbFile.ItemIndex >= 0)
  then cbSetTo.Caption := cmbFile.Text;

  if cmbVersion.Enabled and (cmbVersion.ItemIndex >= 0)
  then cbSetTo.Caption := cmbVersion.Text;
end;

procedure TfrmSetFieldFromXL.btnOKClick(Sender: TObject);
var
  frmProgress : TfrmProgress;
  NewDictionaryRec : DataDictRec;

  Procedure UpdateVersion;
  var
    iFile, iPos : integer;
  begin{UpdateVersion}
    iPos := cmbVersion.ItemIndex + 1;
    if BitIsSet(NewDictionaryRec.DataVarRec.AvailVer, aExchVersionsBitFlag[iPos]) then
    begin
      if not cbSetTo.Checked then NewDictionaryRec.DataVarRec.AvailVer
      := NewDictionaryRec.DataVarRec.AvailVer - aExchVersionsBitFlag[iPos];

      // Delete Xref records
{      For iFile := 1 to NoOfAvailFiles do
      begin
        if iFile < 32 then
        begin
          if BitIsSet(NewDictionaryRec.DataVarRec.AvailFile, aAvailFilesBitFlag[iFile])
          then DeleteXrefRec(NewDictionaryRec.DataVarRec.VarName, iPos, iFile);
        end else
        begin
          if BitIsSet(NewDictionaryRec.DataVarRec.AvailFile2, aAvailFilesBitFlag[iFile])
          then DeleteXrefRec(NewDictionaryRec.DataVarRec.VarName, iPos, iFile);
        end;{if}
{      end;{for}
    end else
    begin
      if cbSetTo.Checked then NewDictionaryRec.DataVarRec.AvailVer
      := NewDictionaryRec.DataVarRec.AvailVer + aExchVersionsBitFlag[iPos];

      // Add new Xref records
{      For iFile := 1 to NoOfAvailFiles do
      begin
        if iFile < 32 then
        begin
          if BitIsSet(NewDictionaryRec.DataVarRec.AvailFile, aAvailFilesBitFlag[iFile])
          then AddXrefRec(NewDictionaryRec.DataVarRec.VarName, iPos, iFile);
        end else
        begin
          if BitIsSet(NewDictionaryRec.DataVarRec.AvailFile2, aAvailFilesBitFlag[iFile])
          then AddXrefRec(NewDictionaryRec.DataVarRec.VarName, iPos, iFile);
        end;{if}
{      end;{for}
    end;{if}
  end;{UpdateVersion}

  Procedure UpdateFile;
  var
    iVersion, iPos : integer;
    bSet : boolean;
  begin{UpdateFile}
    iPos := cmbFile.ItemIndex + 1;

    if iPos < 32
    then bSet := BitIsSet(NewDictionaryRec.DataVarRec.AvailFile, aAvailFilesBitFlag[iPos])  // 1-31 stored in the first field
    else bSet := BitIsSet(NewDictionaryRec.DataVarRec.AvailFile2, aAvailFilesBitFlag[iPos]); // 32- stored in the second field

    if bSet then
    begin
      if not cbSetTo.Checked then
      begin
        if iPos < 32
        then NewDictionaryRec.DataVarRec.AvailFile := NewDictionaryRec.DataVarRec.AvailFile
        - aAvailFilesBitFlag[iPos] // 1-31 stored in the first field
        else NewDictionaryRec.DataVarRec.AvailFile2 := NewDictionaryRec.DataVarRec.AvailFile2
        - aAvailFilesBitFlag[iPos]; // 32- stored in the second field

        // Delete Xref records
{        For iVersion := 1 to NoOfExchVersions do
        begin
          if BitIsSet(NewDictionaryRec.DataVarRec.AvailVer, aExchVersionsBitFlag[iVersion])
          then DeleteXrefRec(NewDictionaryRec.DataVarRec.VarName, iVersion, iPos);
        end;{for}
      end;{if}
    end else
    begin
      if cbSetTo.Checked then
      begin
        if iPos < 32
        then NewDictionaryRec.DataVarRec.AvailFile := NewDictionaryRec.DataVarRec.AvailFile
        + aAvailFilesBitFlag[iPos] // 1-31 stored in the first field
        else NewDictionaryRec.DataVarRec.AvailFile2 := NewDictionaryRec.DataVarRec.AvailFile2
        + aAvailFilesBitFlag[iPos]; // 32- stored in the second field

        // Add new Xref records
{        For iVersion := 1 to NoOfExchVersions do
        begin
          if BitIsSet(NewDictionaryRec.DataVarRec.AvailVer, aExchVersionsBitFlag[iVersion])
          then AddXrefRec(NewDictionaryRec.DataVarRec.VarName, iVersion, iPos);
        end;{for}
      end;{if}
    end;{if}
  end;{UpdateFile}

  Function GetVarNo(sValue : string) : string;
  var
    BTRec : TBTRec;
    LDictionaryRec : DataDictRec;
  begin{GetVarNo}
    Result := '';
    if raMode = raVarNo then Result := sValue;
    if raMode = raFieldCode then
    begin
//      BTRec.KeyS := DictRecordPrefix + PadString(psRight, Trim(sValue), ' ', 10);
//      BTRec.KeyS := DictRecordPrefix + PadString(psRight, Trim(sValue), ' ', 12);
      sValue := UpperCase(Trim(sValue));
      BTRec.KeyS := DictRecordPrefix + sValue;
      BTRec.Status := BTFindRecord(BT_GetGreaterOrEqual, btFileVar[DictionaryF], LDictionaryRec
      , SizeOf(LDictionaryRec), dtIdxFieldCode, BTRec.KeyS);
      if (BTRec.Status = 0)
      and (Copy(LDictionaryRec.DataVarRec.VarName,1,Length(sValue)) = sValue)
      then Result := LDictionaryRec.DataVarRec.VarPadNo;
    end;
  end;{GetVarNo}

var
  BTRec : TBTRec;
  LDictionaryRec : DataDictRec;
  iLine, iRecPos : integer;

begin
    if MsgBox('Are you sure you want to change the ' + cbSetTo.Caption + ' Flag to '
    + UpperCase(booleantostr(cbSetTo.Checked)) + ' ?', mtConfirmation, [mbYes, mbNo], mbNo
    , 'Are you sure ?') = mrYes then
    begin

      screen.cursor := crHourglass;
      frmProgress := TfrmProgress.Create(self);
      frmProgress.Show;
      Application.ProcessMessages;

      For iLine := 0 to lbVarNos.Items.Count-1 do
      begin
        // Get Record
//        BTRec.KeyS := DictRecordPrefix + PadString(psLeft, Trim(lbVarNos.items[iLine]), '0', 6);
        BTRec.KeyS := DictRecordPrefix + PadString(psLeft, Trim(GetVarNo(lbVarNos.items[iLine])), '0', 6);
        BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[DictionaryF], LDictionaryRec
        , SizeOf(LDictionaryRec), dtIdxVarNo, BTRec.KeyS);

        if (BTRec.Status = 0)
        and (LDictionaryRec.RecPfix + LDictionaryRec.SubType = DictRecordPrefix) then
        begin

          frmProgress.UpdateStatus('Updating Flag on ' + LDictionaryRec.DataVarRec.VarName);

          // update records
          if BTGetPosition(btFileVar[DictionaryF], DictionaryF
          , SizeOf(LDictionaryRec), iRecPos) = 0 then
          begin
            NewDictionaryRec := LDictionaryRec;
            if rbFile.checked then UpdateFile
            else UpdateVersion;

            // Rebuilds all XRef Records
            frmProgress.UpdateStatus('Deleting cross-reference records');
            DeleteAllXrefRecs(NewDictionaryRec.DataVarRec.VarName);
            frmProgress.UpdateStatus('Adding cross-reference records');
            AddAllXrefRecs(NewDictionaryRec.DataVarRec);

            BTRestorePosition(btFileVar[DictionaryF], DictionaryF, LDictionaryRec
            , SizeOf(LDictionaryRec), dtIdxVarNo, 0, iRecPos);
          end;{if}

          BTRec.Status := BTUpdateRecord(btFileVar[DictionaryF], NewDictionaryRec
          , SizeOf(NewDictionaryRec), dtIdxVarNo, BTRec.KeyS);
          BTShowError(BTRec.Status, 'BTUpdateRecord', btFileName[DictionaryF]);
        end;{if}

        Application.ProcessMessages;

      end;{for}

      frmProgress.Hide;
      frmProgress.Release;
      screen.cursor := crDefault;

      MsgBox('Finished Updating Flags.', mtInformation, [mbOK], mbOK, 'Flag Update');

      Close;
    end;{if}
end;

procedure TfrmSetFieldFromXL.Button1Click(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    lbVarNos.Items.LoadFromFile(dlgOpen.FileName);
  end;{if}
  lCount.Caption := IntToStr(lbVarNos.Items.Count);
end;

procedure TfrmSetFieldFromXL.Button2Click(Sender: TObject);
begin
  lbVarNos.Items.Clear;
  lCount.Caption := IntToStr(lbVarNos.Items.Count);
end;

procedure TfrmSetFieldFromXL.ReadAsClick(Sender: TObject);
begin
  if rbVarNo.Checked then
  begin
    tsFields.Caption := 'Var Nos';
    raMode := raVarNo;
  end;{if}

  if rbFieldCode.Checked then
  begin
    tsFields.Caption := 'Field Codes';
    raMode := raFieldCode;
  end;{if}

end;

end.
