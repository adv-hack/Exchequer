unit Range;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TEditVal;

type
  TfrmRange = class(TForm)
    edVarStart: TCurrencyEdit;
    edVarEnd: TCurrencyEdit;
    Label1: TLabel;
    Label2: TLabel;
    rbFile: TRadioButton;
    rbVersion: TRadioButton;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    cmbFile: TComboBox;
    cmbVersion: TComboBox;
    Shape4: TShape;
    cbSetTo: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Shape7: TShape;
    btnOK: TButton;
    btnCancel: TButton;
    Shape6: TShape;
    Shape5: TShape;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ThingsChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRange: TfrmRange;

implementation
uses
  DictionaryProc, MathUtil, BTFiles, Progress, BTUtil, BTConst, StrUtil, APIUtil
  , DictRecord;

{$R *.dfm}

procedure TfrmRange.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmRange.FormCreate(Sender: TObject);
var
  iPos : integer;
begin
  edVarStart.displayformat := '#####0';
  edVarEnd.displayformat := '#####0';

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

procedure TfrmRange.ThingsChange(Sender: TObject);
begin
  cmbFile.Enabled := rbFile.checked;
  cmbVersion.Enabled := rbVersion.checked;

  if cmbFile.Enabled and (cmbFile.ItemIndex >= 0)
  then cbSetTo.Caption := cmbFile.Text;

  if cmbVersion.Enabled and (cmbVersion.ItemIndex >= 0)
  then cbSetTo.Caption := cmbVersion.Text;
end;

procedure TfrmRange.btnOKClick(Sender: TObject);
var
  BTRec : TBTRec;
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

var
  LDictionaryRec : DataDictRec;
  iRecPos : integer;

begin
  if StrToIntDef(edVarStart.Text, 0) <= StrToIntDef(edVarEnd.Text, 0) then
  begin
    if MsgBox('Are you sure you want to change the ' + cbSetTo.Caption + ' Flag to '
    + UpperCase(booleantostr(cbSetTo.Checked)) + ' on fields ' + edVarStart.Text + ' to '
    + edVarEnd.Text + ' ?', mtConfirmation, [mbYes, mbNo], mbNo
    , 'Are you sure ?') = mrYes then
    begin

      screen.cursor := crHourglass;
      frmProgress := TfrmProgress.Create(self);
      frmProgress.Show;
      Application.ProcessMessages;

      // Update Field Records
      BTRec.KeyS := DictRecordPrefix + PadString(psLeft, Trim(edVarStart.Text), '0', 6);
      BTRec.Status := BTFindRecord(BT_GetGreaterorEqual, btFileVar[DictionaryF], LDictionaryRec
      , SizeOf(LDictionaryRec), dtIdxVarNo, BTRec.KeyS);

      while (BTRec.Status = 0) and (LDictionaryRec.RecPfix + LDictionaryRec.SubType = DictRecordPrefix)
      and (LDictionaryRec.DataVarRec.VarNo >= StrToIntDef(edVarStart.Text, 0))
      and (LDictionaryRec.DataVarRec.VarNo <= StrToIntDef(edVarEnd.Text, 0)) do
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

        BTRec.Status := BTFindRecord(BT_GetNext, btFileVar[DictionaryF], LDictionaryRec
        , SizeOf(LDictionaryRec), dtIdxVarNo, BTRec.KeyS);
      end;{while}

      frmProgress.Hide;
      frmProgress.Release;
      screen.cursor := crDefault;

      MsgBox('Finished Updating Flags.', mtInformation, [mbOK], mbOK, 'Flag Update');

      Close;
    end;{if}
  end;{if}
end;

end.
