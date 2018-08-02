unit FieldList;

{ nfrewer440 11:48 26/08/2004: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uMultiList, uDBMultiList, uExDatasets, uBtrieveDataset,
  StdCtrls, MiscUtil, Progress, Menus, FileUtil;

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
    procedure FormShow(Sender: TObject);
    procedure bdsFieldsGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure btnCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure AddEditField(Sender: TObject);
    procedure mlFieldsRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure bdsFieldsSelectRecord(Sender: TObject;
      SelectType: TSelectType; Address: Integer; PData: Pointer);
    procedure Button2Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure ResetAllXRefFields1Click(Sender: TObject);
    procedure RebuildDictnarydattodictnewdat1Click(Sender: TObject);
    procedure CountRecords1Click(Sender: TObject);
    procedure SetFlagsforRangeofFields1Click(Sender: TObject);
    procedure ExporttoCSV1Click(Sender: TObject);
    procedure SetoneFlagforaListofFields1Click(Sender: TObject);
  private
    Procedure WMGetMinMaxInfo (Var Message : TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
  end;

var
  frmFieldList: TfrmFieldList;

implementation
uses
  Range, DictionaryProc, BTConst, BTUtil, APIUtil, BTFiles, FieldDetails
  , DictRecord, MathUtil, SetFromXL;

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

procedure TfrmFieldList.AddEditField(Sender: TObject);
var
  pData: Pointer;
begin
  if TButton(Sender).Enabled then
  begin
    with TfrmFieldDetails.Create(self) do
    begin
      FormMode := TFormMode(TButton(Sender).Tag);
      if TButton(Sender).Name = 'btnAdd' then
      begin
        bCopy := FALSE;
        FillChar(DictionaryRec, SizeOf(DictionaryRec), #0);
        DictionaryRec.RecPfix := 'D';
        DictionaryRec.SubType := 'V';
      end else
      begin
        bCopy := TRUE;
        pData := bdsFields.GetRecord;
        if pData <> nil then DictionaryRec := DataDictRec(PData^);
      end;{if}

      if (FormMode = fmAdd) or (pData <> nil) then
      begin
        if ShowModal = mrOK then mlFields.RefreshDB;
      end;{if}

      Release;
    end;{with}
  end;{if}
end;

procedure TfrmFieldList.mlFieldsRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  AddEditField(btnEdit);
end;

procedure TfrmFieldList.FormDestroy(Sender: TObject);
begin
  CloseFiles;
end;

procedure TfrmFieldList.btnDeleteClick(Sender: TObject);
var
  pData: Pointer;
  BTRec : TBTRec;
  LDictionaryRec : DataDictRec;
  frmProgress : TfrmProgress;
begin
  if MsgBox('Are you sure you want to delete this field ?', mtConfirmation
  , [mbYes, mbNo], mbNo, 'Are you sure ?') = mrYes then
  begin
    if MsgBox('Are you sure that you are sure ?', mtConfirmation
    , [mbYes, mbNo], mbNo, 'Are you REALLY sure ?') = mrYes then
    begin
      screen.cursor := crHourglass;
      frmProgress := TfrmProgress.Create(self);
      frmProgress.Show;
      Application.ProcessMessages;
      pData := bdsFields.GetRecord;
      if pData <> nil then
      begin
        // find record to delete
        BTRec.KeyS := DictRecordPrefix + DataDictRec(PData^).DataVarRec.VarPadNo;
        BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[DictionaryF], LDictionaryRec
        , SizeOf(LDictionaryRec), dtIdxVarNo, BTRec.KeyS);
        if BTRec.Status = 0 then
        begin
          // Update Record
          BTRec.Status := BTDeleteRecord(btFileVar[DictionaryF], LDictionaryRec
          , {btBufferSize[DictionaryF]} SizeOf(LDictionaryRec), dtIdxVarNo);
          BTShowError(BTRec.Status, 'BTDeleteRecord', btFileName[DictionaryF]);
          if BTRec.Status = 0 then
          begin
            frmProgress.UpdateStatus('Deleting cross-reference records');
            DeleteAllXrefRecs(LDictionaryRec.DataVarRec.VarName);
            mlFields.RefreshDB;
          end;{if}
        end;{if}
      end;{if}
      frmProgress.Hide;
      frmProgress.Release;
      screen.cursor := crDefault;
    end;
  end;
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

procedure TfrmFieldList.ResetAllXRefFields1Click(Sender: TObject);
var
  BTRec : TBTRec;
  LDictionaryRec : DataDictRec;
  frmProgress : TfrmProgress;
  iRecPos : LongInt;
begin
  if MsgBox('Are you sure you want to Rebuild ALL the Xref records ?'#13#13
  + 'This will take a while.', mtConfirmation, [mbYes, mbNo], mbNo
  , 'Are you sure ?') = mrYes then
  begin
    screen.cursor := crHourglass;
    frmProgress := TfrmProgress.Create(self);
    frmProgress.Show;
    Application.ProcessMessages;

    // Deletes all XRef records
    BTRec.KeyS := XrefRecordPrefix;
    repeat
      BTRec.KeyS := XrefRecordPrefix;
      BTRec.Status := BTFindRecord(BT_GetGreater, btFileVar[DictionaryF], LDictionaryRec
      , SizeOf(LDictionaryRec), dxIdxFieldCode, BTRec.KeyS);
      if (BTRec.Status = 0) and (LDictionaryRec.RecPfix + LDictionaryRec.SubType = XrefRecordPrefix) then
      begin
        frmProgress.UpdateStatus('Deleting cross-reference records for '
        + LDictionaryRec.DataXRefRec.VarName);
        BTRec.Status := BTDeleteRecord(btFileVar[DictionaryF], LDictionaryRec
        , SizeOf(LDictionaryRec), dxIdxFieldCode);
        BTShowError(BTRec.Status, 'BTDeleteRecord', btFileName[DictionaryF]);

        if BTRec.Status = 80 then
        begin
          Showmessage(LDictionaryRec.DataXRefRec.VarName + #13#13
          + 'File No : ' + IntToStr(LDictionaryRec.DataXRefRec.VarFileNo) + #13#13
          + 'Version No : ' +  IntToStr(LDictionaryRec.DataXRefRec.VarExVers));
//          BTRec.Status := 0
        end;
      end;{if}
//      BTRec.KeyS := XrefRecordPrefix +
    until (BTRec.Status <> 0) or (LDictionaryRec.RecPfix + LDictionaryRec.SubType <> XrefRecordPrefix);

    if BTRec.Status in [4,9,0] then
    begin
      // create new xref records
      BTRec.KeyS := DictRecordPrefix;
      BTRec.Status := BTFindRecord(BT_GetGreaterorEqual, btFileVar[DictionaryF], LDictionaryRec
      , SizeOf(LDictionaryRec), dtIdxFieldCode, BTRec.KeyS);
      while (BTRec.Status = 0) and (LDictionaryRec.RecPfix + LDictionaryRec.SubType = DictRecordPrefix) do
      begin
        frmProgress.UpdateStatus('Adding cross-reference records for ' + LDictionaryRec.DataVarRec.VarName);


        if BTGetPosition(btFileVar[DictionaryF], DictionaryF
        , SizeOf(LDictionaryRec), iRecPos) = 0 then
        begin
          AddAllXrefRecs(LDictionaryRec.DataVarRec);
          BTRestorePosition(btFileVar[DictionaryF], DictionaryF, LDictionaryRec
          , SizeOf(LDictionaryRec), dtIdxFieldCode, 0, iRecPos);
        end;{if}

        BTRec.Status := BTFindRecord(BT_GetNext, btFileVar[DictionaryF], LDictionaryRec
        , SizeOf(LDictionaryRec), dtIdxFieldCode, BTRec.KeyS);
      end;{while}
    end;{if}

    frmProgress.Hide;
    frmProgress.Release;
    screen.cursor := crDefault;

    MsgBox('Finished rebuilding cross-reference records',mtInformation, [mbOK], mbOK, 'Xref Rebuild');
  end;{if}
end;

procedure TfrmFieldList.RebuildDictnarydattodictnewdat1Click(Sender: TObject);
var
  BTRec : TBTRec;
  LDictionaryRec : DataDictRec;
  frmProgress : TfrmProgress;
  iNoOfRecordsAdded : integer;
begin
  if FileExists(sDataPath + btFileName[NewDictionaryF]) then
  begin
    if MsgBox('Are you sure you want to Rebuild your Dictionary.Dat file ?'#13#13
    + 'This could take a little while.', mtConfirmation, [mbYes, mbNo], mbNo
    , 'Are you sure ?') = mrYes then
    begin
      screen.cursor := crHourglass;
      frmProgress := TfrmProgress.Create(self);
      frmProgress.Show;
      Application.ProcessMessages;
      iNoOfRecordsAdded := 0;

      BTRec.KeyS := DictRecordPrefix;
      BTRec.Status := BTFindRecord(BT_GetGreaterOrEqual, btFileVar[DictionaryF], LDictionaryRec
      , SizeOf(LDictionaryRec), dtIdxFieldCode, BTRec.KeyS);
      While (LDictionaryRec.RecPfix + LDictionaryRec.SubType = DictRecordPrefix)
      and (BTRec.Status = 0) do
      begin
        frmProgress.UpdateStatus('Copying Field : ' + LDictionaryRec.DataVarRec.VarName);

        BTRec.Status := BTAddRecord(btFileVar[NewDictionaryF], LDictionaryRec
        , SizeOf(LDictionaryRec), 0);
        BTShowError(BTRec.Status, 'BTAddRecord', btFileName[NewDictionaryF]);
        inc(iNoOfRecordsAdded);

        BTRec.Status := BTFindRecord(BT_GetNext, btFileVar[DictionaryF], LDictionaryRec
        , SizeOf(LDictionaryRec), dtIdxFieldCode, BTRec.KeyS);
      end;{while}

      frmProgress.Hide;
      frmProgress.Release;

      screen.cursor := crDefault;
      MsgBox('Finished rebuilding Dictnary.dat'#13#13 + 'Records Added : '
      + IntToStr(iNoOfRecordsAdded), mtInformation, [mbOK], mbOK, 'Dictnary.dat Rebuild');
    end;{if}
  end else
  begin
    MsgBox(sDataPath + btFileName[NewDictionaryF] + ' does not exist.'#13#13
    + 'You must have a blank DictNew.Dat in order to run this option'
    ,mtError,[mbOK], mbOK, 'No DictNew.Dat');
  end;
end;

procedure TfrmFieldList.CountRecords1Click(Sender: TObject);
var
  BTRec : TBTRec;
  LDictionaryRec : DataDictRec;
  frmProgress : TfrmProgress;
  iNoOfTicksRecords, iNoOfUnknownRecords, iNoOfFieldRecords, iNoOfXrefRecords : integer;
  sWarning : string;

  procedure AddTicks;
  var
    iFiles, iVersions, iPos : integer;
  begin{AddTicks}
    For iPos := 1 to NoOfExchVersions do
    begin
      if BitIsSet(LDictionaryRec.DataVarRec.AvailVer, aExchVersionsBitFlag[iPos])
      then inc(iVersions);
    end;{for}

    For iPos := 1 to NoOfAvailFiles do
    begin
      if iPos < 32 then
      begin
        if BitIsSet(LDictionaryRec.DataVarRec.AvailFile , aAvailFilesBitFlag[iPos])  // 1-31 stored in the first field
        then inc(iFiles);
      end else
      begin
        if BitIsSet(LDictionaryRec.DataVarRec.AvailFile2, aAvailFilesBitFlag[iPos]) // 32- stored in the second field
        then inc(iFiles);
      end;{if}
    end;{for}

    iNoOfTicksRecords := iNoOfTicksRecords + (iFiles * iVersions);

  end;{AddTicks}

begin
  if MsgBox('Are you sure you want to Count the records in your Dictionary.Dat file ?'#13#13
  + 'This could take a little while.', mtConfirmation, [mbYes, mbNo], mbNo
  , 'Are you sure ?') = mrYes then
  begin
    screen.cursor := crHourglass;
    frmProgress := TfrmProgress.Create(self);
    frmProgress.Show;
    Application.ProcessMessages;

    iNoOfUnknownRecords := 0;
    iNoOfFieldRecords := 0;
    iNoOfXrefRecords := 0;
    iNoOfTicksRecords := 0;

    BTRec.Status := BTFindRecord(BT_GetFirst, btFileVar[DictionaryF], LDictionaryRec
    , SizeOf(LDictionaryRec), dtIdxFieldCode, BTRec.KeyS);
    While (BTRec.Status = 0) do
    begin
      if LDictionaryRec.RecPfix + LDictionaryRec.SubType = DictRecordPrefix then
      begin
        frmProgress.UpdateStatus('Counting Records : Field');
        AddTicks;
        inc(iNoOfFieldRecords);
      end else
      begin
        if LDictionaryRec.RecPfix + LDictionaryRec.SubType = XrefRecordPrefix then
        begin
          frmProgress.UpdateStatus('Counting Records : Xref');
          inc(iNoOfXrefRecords);
        end else
        begin
          frmProgress.UpdateStatus('Counting Records : Other');
          inc(iNoOfUnknownRecords);
        end;
      end;

      BTRec.Status := BTFindRecord(BT_GetNext, btFileVar[DictionaryF], LDictionaryRec
      , SizeOf(LDictionaryRec), dtIdxFieldCode, BTRec.KeyS);
    end;{while}

    frmProgress.Hide;
    frmProgress.Release;

    screen.cursor := crDefault;

    if iNoOfXrefRecords = iNoOfTicksRecords
    then sWarning := ''
    else sWarning := #13#13'*** WARNING XREF / TICKS MISMATCH ***'#13#13;

    MsgBox('Finished Counting Records'#13#13
    + 'No of Field Records : ' + IntToStr(iNoOfFieldRecords) + #13#13
    + 'No of Xref Records : ' + IntToStr(iNoOfXrefRecords) + #13#13
    + 'No of Other Records : ' + IntToStr(iNoOfUnknownRecords) + #13#13
    + 'No of Ticks : ' + IntToStr(iNoOfTicksRecords) + #13#13
    + sWarning, mtInformation, [mbOK], mbOK, 'Record Count');
  end;{if}
end;

procedure TfrmFieldList.SetFlagsforRangeofFields1Click(Sender: TObject);
begin
  with TfrmRange.Create(self) do
  begin
    Showmodal;
    release;
  end;
end;

procedure TfrmFieldList.ExporttoCSV1Click(Sender: TObject);
var
  BTRec : TBTRec;
  LDictionaryRec : DataDictRec;
  frmProgress : TfrmProgress;
  sLine, sFilename : string;
  iPos, iRecCount : integer;

  function IsFieldForFile(DataVar : DataVarType; iFile : integer) : String;
  begin{IsFieldForFile}
    if iFile < 32 then
    begin
      // 1-31 stored in the first field
      if BitIsSet(DataVar.AvailFile, aAvailFilesBitFlag[iPos])
      then Result := 'Y'
      else Result := 'N';
    end else
    begin
      // 32- stored in the second field
      if BitIsSet(DataVar.AvailFile2, aAvailFilesBitFlag[iPos])
      then Result := 'Y'
      else Result := 'N';
    end;{if}
  end;{IsFieldForFile}

  function IsFieldForVersion(DataVar : DataVarType; iVersion : integer) : String;
  begin{IsFieldForVersion}
    if BitIsSet(DataVar.AvailVer, aExchVersionsBitFlag[iPos])
    then Result := 'Y'
    else Result := 'N';
  end;{IsFieldForVersion}

begin
  dlgSave.InitialDir := ExtractFilePath(Application.ExeName);
  if dlgSave.Execute then
  begin
    sFileName := ChangeFileExt(dlgSave.FileName, '.CSV');

    If FileExists(sFileName)
    then DeleteFile(sFileName);

    screen.cursor := crHourglass;
    frmProgress := TfrmProgress.Create(self);
    frmProgress.Show;
    Application.ProcessMessages;

    iRecCount := 0;

    sLine := '"Field","Var No","Description",Type","Length","Decimal Places"';

    For iPos := 1 to NoOfAvailFiles do
    begin
      sLine := sLine + ',' + ANSIQuotedStr(aAvailFilesDesc[iPos],'"');
    end;{for}

    For iPos := 1 to NoOfExchVersions do
    begin
      sLine := sLine + ',' + ANSIQuotedStr(aExchVersionsDesc[iPos],'"');
    end;{for}

    AddLineToFile(sLine, sFileName, TRUE);

    BTRec.KeyS := DictRecordPrefix;
    BTRec.Status := BTFindRecord(BT_GetGreaterOrEqual, btFileVar[DictionaryF], LDictionaryRec
    , SizeOf(LDictionaryRec), dtIdxFieldCode, BTRec.KeyS);
    While (BTRec.Status = 0) and (LDictionaryRec.RecPfix + LDictionaryRec.SubType = DictRecordPrefix) do
    begin
      with LDictionaryRec do
      begin
        inc(iRecCount);
        frmProgress.UpdateStatus('Exporting Record : ' + LDictionaryRec.DataVarRec.VarName);

        sLine := ANSIQuotedStr(Trim(LDictionaryRec.DataVarRec.VarName),'"') + ','
        + ANSIQuotedStr(Trim(LDictionaryRec.DataVarRec.VarPadNo),'"') + ','
        + ANSIQuotedStr(Trim(LDictionaryRec.DataVarRec.VarDesc),'"') + ','
        + ANSIQuotedStr(aDataTypeDesc[DataVarRec.VarType],'"') + ','
        + IntToStr(DataVarRec.VarLen) + ','
        + IntToStr(DataVarRec.VarNoDec);

        For iPos := 1 to NoOfAvailFiles do
        begin
          sLine := sLine + ',' + IsFieldForFile(LDictionaryRec.DataVarRec, iPos);
        end;{for}

        For iPos := 1 to NoOfExchVersions do
        begin
          sLine := sLine + ',' + IsFieldForVersion(LDictionaryRec.DataVarRec, iPos);
        end;{for}

        AddLineToFile(sLine, sFileName, TRUE);
      end;{with}

      // Next Record
      BTRec.Status := BTFindRecord(BT_GetNext, btFileVar[DictionaryF], LDictionaryRec
      , SizeOf(LDictionaryRec), dtIdxFieldCode, BTRec.KeyS);

      Application.ProcessMessages;
    end;{while}

    frmProgress.Hide;
    frmProgress.Release;

    screen.cursor := crDefault;
    MsgBox('Finished Exporting Records.'#13#13'Records Exported : '
    + IntToStr(iRecCount), mtInformation, [mbOK], mbOK, 'Export to CSV');

  end;{if}
end;

procedure TfrmFieldList.SetoneFlagforaListofFields1Click(Sender: TObject);
begin
  with TfrmSetFieldFromXL.Create(self) do
  begin
    Showmodal;
    release;
  end;
end;

end.
