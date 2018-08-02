unit SelectDBFieldF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uMultiList, GlobalTypes, uDBMultiList,
  uExDatasets, uBtrieveDataset, TCustom, TEditVal, EnterToTab;

type
  TListData = Class(TObject)
  Private
    FFileDefault : Boolean;
    FFileDesc : ShortString;
    FFieldPrefix : ShortString;
  Public
    Property FileDefault : Boolean Read FFileDefault;
    Property FileDesc : ShortString Read FFileDesc;
    Property FieldPrefix : ShortString Read FFieldPrefix;

    Constructor Create(Const Prefix : ShortString; Const FileNo : Byte; Const AutoSelectField : ShortString);
  End; // TListData

  //------------------------------

  TfrmSelectDBField = class(TForm)
    lstAvailableFiles: TComboBox;
    DBMultiList1: TDBMultiList;
    BtrieveDataset1: TBtrieveDataset;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    edtFindField: TEdit;
    Label81: Label8;
    EnterToTab1: TEnterToTab;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstAvailableFilesClick(Sender: TObject);
    procedure BtrieveDataset1FilterRecord(Sender: TObject; PData: Pointer;
      var Include: Boolean);
    procedure BtrieveDataset1GetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure DBMultiList1RowDblClick(Sender: TObject; RowIndex: Integer);
    procedure edtFindFieldChange(Sender: TObject);
    procedure DBMultiList1RowClick(Sender: TObject; RowIndex: Integer);
  private
    { Private declarations }
    ActiveFile : TListData;
    FAutoSelectField : ShortString;
    FReportFile : Byte;
    FreezeUpdates : Boolean;
    FRememberCode: Boolean;
    // Store the VRW Version's Bit value for filtering on the Data Dictionary AvailVer bit field
    FVRWVersionBitValue : LongInt;
    Function GetAllowMultiSelect : Boolean;
    Procedure SetAllowMultiSelect (Value : Boolean);
    Procedure SetReportFile(Value : Byte);
    procedure UnloadCombo;
    procedure UpdateFindField (NewText : ShortString);
    procedure SetRememberCode(const Value: Boolean);
  public
    { Public declarations }
    Property AllowMultiSelect : Boolean Read GetAllowMultiSelect Write SetAllowMultiSelect;
    property RememberCode: Boolean read FRememberCode write SetRememberCode;
    Property AutoSelectField : ShortString Read FAutoSelectField Write FAutoSelectField;
    Property ReportFile : Byte Read FReportFile Write SetReportFile;

    procedure ClearMultiSelect;
  End; // TfrmSelectDBField


implementation

{$R *.dfm}

Uses GlobVar, VarConst, RWOpenF, BtrvU2, EntLicence, Math, FileUtil;

Type
  ByteSet = Set Of Byte;

Var
  IsLITE : Boolean;

//=========================================================================

Constructor TListData.Create(Const Prefix : ShortString; Const FileNo : Byte; Const AutoSelectField : ShortString);

  Function IsDefault (Const Files : ByteSet) : Boolean;
  Begin // IsDefault
    If (AutoSelectField <> '') Then
    Begin
      Result := (Copy(AutoSelectField, 1, Length(Prefix)) = Prefix);
    End // If (AutoSelectField <> '')
    Else
    Begin
      Result := (FileNo In Files);
    End; // Else
  End; // IsDefault

Begin // Create
  Inherited Create;


  FFieldPrefix := Prefix;

  If (Prefix = 'AC') Then
  Begin
    FFileDesc := 'Customer/Supplier Fields';
    FFileDefault := IsDefault ([1, 2]);
  End // If (Prefix = 'AC')
  Else If (Prefix = 'AN') And (EnterpriseLicence.elModules[modJobCost] <> mrNone) Then
  Begin
    FFileDesc := 'Analysis Code Fields';
    FFileDefault := IsDefault ([17]);
  End // If (Prefix = 'AN') And (EnterpriseLicence.elModules[modJobCost] <> mrNone)
  Else If (Prefix = 'BO') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP]) Then
  Begin
    FFileDesc := 'Bill Of Materials Fields';
    FFileDefault := IsDefault ([10]);
  End // If (Prefix = 'BO') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP])
  Else If (Prefix = 'BR') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP]) and not isLite Then
  Begin
    FFileDesc := 'Multi-Bin Fields';
    FFileDefault := IsDefault ([34]);
  End // If (Prefix = 'BR') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP])
  // C0..C29 - N/A to VRW
  Else If (Prefix = 'CC') Then
  Begin
    FFileDesc := 'Cost Centre/Department Fields';
    FFileDefault := IsDefault ([7, 8]);
  End // If (Prefix = 'CC')
  // CH - N/A to VRW
  // CU - N/A to VRW
  Else If (Prefix = 'DI') Then
  Begin
    FFileDesc := 'Discount Fields';
    FFileDefault := IsDefault ([14]);
  End // If (Prefix = 'DI')
  Else If (Prefix = 'EM') And (EnterpriseLicence.elModules[modJobCost] <> mrNone) Then
  Begin
    FFileDesc := 'Employee Fields';
    FFileDefault := IsDefault ([21]);
  End // If (Prefix = 'EM') And (EnterpriseLicence.elModules[modJobCost] <> mrNone)
  // EML - N/A to VRW
  // FAX - N/A to VRW
  Else If (Prefix = 'FI') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP]) Then
  Begin
    FFileDesc := 'FIFO Fields';
    FFileDefault := IsDefault ([20]);
  End // If (Prefix = 'FI')
  Else If (Prefix = 'JA') And (EnterpriseLicence.elModules[modJobCost] <> mrNone) Then
  Begin
    FFileDesc := 'Job Actual Fields';
    FFileDefault := IsDefault ([23]);
  End // If (Prefix = 'JA') And (EnterpriseLicence.elModules[modJobCost] <> mrNone)
  Else If (Prefix = 'JB') And (EnterpriseLicence.elModules[modJobCost] <> mrNone) Then
  Begin
    FFileDesc := 'Job Budget Fields';
    FFileDefault := IsDefault ([25]);
  End // If (Prefix = 'JB') And (EnterpriseLicence.elModules[modJobCost] <> mrNone)
  // JC - N/A to VRW
  Else If (Prefix = 'JE') And (EnterpriseLicence.elModules[modJobCost] <> mrNone) Then
  Begin
    FFileDesc := 'JOB Retentions Fields';
    FFileDefault := IsDefault ([24]);
  End // If (Prefix = 'JE') And (EnterpriseLicence.elModules[modJobCost] <> mrNone)
  Else If (Prefix = 'JR') And (EnterpriseLicence.elModules[modJobCost] <> mrNone) Then
  Begin
    FFileDesc := 'Job Fields';
    FFileDefault := IsDefault ([22]);
  End // If (Prefix = 'JR') And (EnterpriseLicence.elModules[modJobCost] <> mrNone)
  Else If (Prefix = 'JT') And (EnterpriseLicence.elModules[modJobCost] <> mrNone) Then
  Begin
    FFileDesc := 'Job Type Fields';
    FFileDefault := IsDefault ([18]);
  End // If (Prefix = 'JT') And (EnterpriseLicence.elModules[modJobCost] <> mrNone)
  Else If (Prefix = 'JV') And (EnterpriseLicence.elModules[modCISRCT] <> mrNone) Then
  Begin
    FFileDesc := 'CIS Voucher Fields';
    FFileDefault := IsDefault ([33]);
  End // If (Prefix = 'JV') And (EnterpriseLicence.elModules[modCISRCT] <> mrNone)
  Else If (Prefix = 'ML') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP]) and not isLITE Then
  Begin
    FFileDesc := 'Multi-Location Fields';
    FFileDefault := IsDefault ([12]);
  End // If (Prefix = 'ML') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP])
  Else If (Prefix = 'MP') Then
  Begin
    FFileDesc := 'Matching Fields';
    FFileDefault := IsDefault ([28]);
  End // If (Prefix = 'MP')
  Else If (Prefix = 'NM') Then
  Begin
    FFileDesc := 'General Ledger Tree Fields';
    FFileDefault := IsDefault ([5]);
  End // If (Prefix = 'NM')
  Else If (Prefix = 'NO') Then
  Begin
    FFileDesc := 'Notes Fields';
    FFileDefault := IsDefault ([29..32]);
  End // If (Prefix = 'NO')
  // OC - N/A to VRW
  Else If (Prefix = 'SL') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP]) and not isLITE Then
  Begin
    FFileDesc := 'Stock-Location Fields';
    FFileDefault := IsDefault ([27]);
  End // If (Prefix = 'SL') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP])
  Else If (Prefix = 'SN') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP]) and not isLITE Then
  Begin
    FFileDesc := 'Serial/Batch Number Fields';
    FFileDefault := IsDefault ([16]);
  End // If (Prefix = 'SN') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP])
  Else If (Prefix = 'ST') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP]) Then
  Begin
    FFileDesc := 'Stock Fields';
    FFileDefault := IsDefault ([6]);
  End // If (Prefix = 'ST') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP])
  Else If (Prefix = 'SY') Then
  Begin
    FFileDesc := 'System Setup Fields';
    FFileDefault := IsDefault ([0]);
  End // If (Prefix = 'SY')
  Else If (Prefix = 'TC') And (EnterpriseLicence.elModules[modTrade] <> mrNone) Then
  Begin
    FFileDesc := 'Trade Counter Fields';
  End // If (Prefix = 'TC') And (EnterpriseLicence.elModules[modTrade] <> mrNone)
  Else If (Prefix = 'TH') Then
  Begin
    FFileDesc := 'Transaction Header Fields';
    FFileDefault := IsDefault ([3]);
  End // If (Prefix = 'TH')
  Else If (Prefix = 'TL') Then
  Begin
    FFileDesc := 'Transaction Line Fields';
    FFileDefault := IsDefault ([4]);
  End // If (Prefix = 'TL')
  Else If (Prefix = 'TR') And (EnterpriseLicence.elModules[modJobCost] <> mrNone) Then
  Begin
    FFileDesc := 'Employee Time Rate Fields';
    FFileDefault := IsDefault ([19]);
  End // If (Prefix = 'TR') And (EnterpriseLicence.elModules[modJobCost] <> mrNone)
  //PR: 12/03/2009 Added Alt Stock Code database
  Else If (Prefix = 'AS') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP]) and not isLITE Then
  Begin
    FFileDesc := 'Alternative Stock Code Fields';
    FFileDefault := IsDefault ([35]);
  End // If (Prefix = 'AS') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP])
  //PR: 10/06/2009 Added Multi-Buy Discounts
  Else If (Prefix = 'MD') And (EnterpriseLicence.elModuleVersion In [mvSPOP]) and not isLITE Then
  Begin
    FFileDesc := 'Multi-Buy Discount Fields';
    FFileDefault := IsDefault ([36]);
  End // If (Prefix = 'AS') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP])
  //PR: 13/02/2012 Added Qty Breaks
  Else If (Prefix = 'QB') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP]) and not isLITE Then
  Begin
    FFileDesc := 'Qty Break Fields';
    FFileDefault := IsDefault ([36]);
  End // If (Prefix = 'QB') And (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP])
  //PR: 31/01/2014 Added Account Contact Roles
  Else If (Prefix = 'CO') and not isLITE Then
  Begin
    FFileDesc := 'Account Contact Role Fields';
    FFileDefault := IsDefault ([38]);
  End
  Else If  (Prefix = 'RO') and not isLITE Then
  Begin
    FFileDesc := 'Contact Role Fields';
    FFileDefault := False;
  End
  //PR: 14/10/2014 Order Payments
  Else If  (Prefix = 'OP') and not isLITE Then
  Begin
    FFileDesc := 'Order Payments Fields';
    FFileDefault := IsDefault ([39]);
  End
  Else
    FFileDesc := ''
End; // Create

//=========================================================================

procedure TfrmSelectDBField.FormCreate(Sender: TObject);
begin
  ActiveFile := NIL;
  FAutoSelectField := '';
  FReportFile := 0;
  FVRWVersionBitValue := 0;
  FreezeUpdates := False;
{$IFDEF EX600}
  BtrieveDataSet1.FileName := GetEnterpriseDirectory + 'REPORTS\DICTNARY.DAT';
{$ELSE}
  BtrieveDataSet1.FileName := SetDrive + 'REPORTS\DICTNARY.DAT';
{$ENDIF}
end;

//------------------------------

procedure TfrmSelectDBField.FormDestroy(Sender: TObject);
begin
  ActiveFile := NIL;
  UnloadCombo;
end;

//-------------------------------------------------------------------------

procedure TfrmSelectDBField.UnloadCombo;
Begin // UnloadCombo
  // Unload the detail objects from the list
  While (lstAvailableFiles.Items.Count > 0) Do
  Begin
    lstAvailableFiles.Items.Objects[0].Free;
    lstAvailableFiles.Items.Delete(0);
  End; // While (lstAvailableFiles.Items.Count > 0)
End; // UnloadCombo

//-------------------------------------------------------------------------

Function TfrmSelectDBField.GetAllowMultiSelect : Boolean;
Begin // GetAllowMultiSelect
  Result := DBMultiList1.Options.MultiSelection;
End; // GetAllowMultiSelect
Procedure TfrmSelectDBField.SetAllowMultiSelect (Value : Boolean);
Begin // SetAllowMultiSelect
  DBMultiList1.Options.MultiSelection := Value;
End; // SetAllowMultiSelect

//-------------------------------------------------------------------------

Procedure TfrmSelectDBField.SetReportFile(Value : Byte);
Var
  oListData : TListData;
  VRWVers : Byte;
  KeyS : Str255;
  iStatus : SmallInt;
Begin // SetWizardReport
  If (FReportFile <> Value) Then
  Begin
    FReportFile := Value;

    // Get rid of any previous details
    UnloadCombo;
    lstAvailableFiles.Sorted := False;

    // Calculate the VRW Version Number as used by the Dictnary.Dat file for
    // linking fields to versions
    VRWVers := VRWVersionNo;

    // Store the VRW Version's Bit value for filtering on the Data Dictionary AvailVer bit field
    FVRWVersionBitValue := Trunc(Power(2, VRWVers - 1));

    // Load list of available files
    KeyS := 'DX' + Chr(VRWVers) + Chr(FReportFile);
    iStatus := Find_Rec (B_GetGEq, F[DictF], DictF, RecPtr[DictF]^, 0, KeyS);
    While (iStatus = 0) And (DictRec.RecPfix = 'D') And (DictRec.SubType = 'X') And
          (DictRec.DataXRefRec.VarExVers = VRWVers) And
          (DictRec.DataXRefRec.VarFileNo = FReportFile) Do
    Begin
      oListData := TListData.Create(Copy (DictRec.DataXRefRec.VarName, 1, 2), FReportFile, FAutoSelectField);
      If (oListData.FileDesc <> '') Then
      Begin
        lstAvailableFiles.Items.AddObject (oListData.FileDesc, oListData);

        If oListData.FileDefault Then
        Begin
          lstAvailableFiles.ItemIndex := lstAvailableFiles.Items.Count - 1;
        End; // If oListData.FileDefault
      End // If (oListData.FileDesc <> '')
      Else
      Begin
        // Not interested in this set of fields
        FreeAndNIL(oListData);
      End; // Else

      // Jump to the next lettered grouping of fields for the file
      KeyS := 'DX' + Chr(VRWVers) + Chr(FReportFile) + Copy (DictRec.DataXRefRec.VarName, 1, 2) + 'ZZZZZZ';
      iStatus := Find_Rec (B_GetGEq, F[DictF], DictF, RecPtr[DictF]^, 0, KeyS);
    End; // While ...

    // Sort into ascending order - to avoid the selected item being screwed we need to refind it afterwards
    KeyS := lstAvailableFiles.Text;
    lstAvailableFiles.Sorted := True;
    lstAvailableFiles.ItemIndex := lstAvailableFiles.Items.IndexOf(KeyS);
    If (lstAvailableFiles.ItemIndex = -1) And (lstAvailableFiles.Items.Count > 0) Then
    Begin
      lstAvailableFiles.ItemIndex := 0;
    End; // If (lstAvailableFiles.ItemIndex = -1) And (lstAvailableFiles.Items.Count > 0)

    lstAvailableFilesClick(Self);
  End; // If (FReportFile <> FWizardReport.MainReportFileInfo.siMainDbFile)
End; // SetWizardReport

//-------------------------------------------------------------------------

procedure TfrmSelectDBField.lstAvailableFilesClick(Sender: TObject);
begin
  If (lstAvailableFiles.ItemIndex > -1) Then
  Begin
    // Extract the object from the list containing the key'ing info
    ActiveFile := TListData(lstAvailableFiles.Items.Objects[lstAvailableFiles.ItemIndex]);

    // Load the multilist
    DBMultiList1.Active := False;
    DBMultiList1.MultiSelectClear;
    //BtrieveDataSet1.SearchKey := 'DV' + oListData.FieldPrefix;
    DBMultiList1.Active := True;

    If (FAutoSelectField <> '') Then
    Begin
      DBMultiList1.SearchColumn(0, TRUE, FAutoSelectField);
      UpdateFindField (FAutoSelectField);
    End // If (FAutoSelectField <> '')
    Else
      UpdateFindField (ActiveFile.FieldPrefix);
  End; // If (lstAvailableFiles.ItemIndex > -1)
end;

//-------------------------------------------------------------------------

procedure TfrmSelectDBField.ClearMultiSelect;
Begin // ClearMultiSelect
  DBMultiList1.MultiSelectClear;
End; // ClearMultiSelect

//-------------------------------------------------------------------------

procedure TfrmSelectDBField.BtrieveDataset1FilterRecord(Sender: TObject; PData: Pointer; var Include: Boolean);
Var
  pDataDict  : ^DataDictRec;
begin
  // Filter out any records not part of the active file and those intended only for the Form Designer
  pDataDict := pData;

  If Assigned(ActiveFile) Then
  Begin
    Include := (Copy(pDataDict.DataVarRec.VarName, 1, Length(ActiveFile.FieldPrefix)) = ActiveFile.FieldPrefix);
  End; // If Assigned(ActiveFile)

  If Include Then
  Begin
    // MH 14/02/05: Changed the filtering as I believe it to be completely arse about face - instead of filtering
    // out the Form Designer fields (which doesn't work!) it should check that the field is defined for the version
    // we are running.

    // Filter out any record intended only for the Form Designer (bit 21 = FormDesc SC & 22 = FormDes MC)
    //Include := ((pDataDict.DataVarRec.AvailVer AND 1048576) = 0) And ((pDataDict.DataVarRec.AvailVer AND 2097152) = 0);

    // Check that the Data Dictionary field is defined for the version we are running
    Include := ((pDataDict.DataVarRec.AvailVer AND FVRWVersionBitValue) = FVRWVersionBitValue);

    // MH 21/03/06: Added suppression of fields for LITE
    If Include And IsLITE Then
    Begin
      // 24 = Not LITE
      Include := (pDataDict.DataVarRec.AvailVer And Round(Power(2,23))) = 0;
    End; // If Include And IsLITE

  End; // If Include
end;

//------------------------------

procedure TfrmSelectDBField.BtrieveDataset1GetFieldValue(Sender: TObject; PData: Pointer; FieldName: String; var FieldValue: String);
Var
  pDataDict  : ^DataDictRec;
begin
  pDataDict := pData;

  Case FieldName[1] Of
    '0'  : FieldValue := Trim(pDataDict.DataVarRec.VarName);
    '1'  : FieldValue := Trim(pDataDict.DataVarRec.VarDesc);
  End; // Case FieldName[1]
end;

//------------------------------

procedure TfrmSelectDBField.DBMultiList1RowClick(Sender: TObject; RowIndex: Integer);
begin
  UpdateFindField (DBMultiList1.DesignColumns[0].Items[RowIndex]);
end;

//-------------------------------------------------------------------------

procedure TfrmSelectDBField.DBMultiList1RowDblClick(Sender: TObject; RowIndex: Integer);
begin
  ModalResult := mrOK;
end;

//-------------------------------------------------------------------------

procedure TfrmSelectDBField.UpdateFindField (NewText : ShortString);
Begin // UpdateFindField
  FreezeUpdates := True;
  Try
    edtFindField.Text := NewText;
  Finally
    FreezeUpdates := False;
  End; // Try..Finally
End; // UpdateFindField

//------------------------------

procedure TfrmSelectDBField.edtFindFieldChange(Sender: TObject);
begin
  If (Not FreezeUpdates) Then
  Begin
    DBMultiList1.SearchColumn(0, TRUE, Trim(edtFindField.Text));
  End; // If (Not FreezeUpdates)
end;

//-------------------------------------------------------------------------

procedure TfrmSelectDBField.SetRememberCode(const Value: Boolean);
begin
  FRememberCode := Value;
  if not RememberCode then
  begin
    edtFindField.Text := '';
    ActiveControl := edtFindField;
  end;
end;

initialization

  IsLITE := (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]);

end.
