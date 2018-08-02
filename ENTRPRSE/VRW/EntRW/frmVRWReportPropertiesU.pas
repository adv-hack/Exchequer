unit frmVRWReportPropertiesU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, TEditVal, EnterToTab,
  TCustom,
  CtrlPrms, DesignerTypes, VRWReportIF, frmVRWRangeFilterDetailsU;

type
  { Holds a copy of the range filter details, so that they can be restored if
    the user cancels the dialog. }
  TRangeFilterDetails = record
    rfName: ShortString;
    rfDescription: ShortString;
    rfType: Integer;
    rfAlwaysAsk: Boolean;
    rfFromValue: ShortString;
    rfToValue: ShortString;
  end;
  TfrmVRWReportProperties = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    gbFileIdx: TGroupBox;
    cbIndex: TComboBox;
    EnterToTab1: TEnterToTab;
    GroupBox1: TGroupBox;
    Label81: Label8;
    edtReportName: Text8Pt;
    Label82: Label8;
    memReportDesc: TMemo;
    Label83: Label8;
    rbPortrait: TRadioButton;
    rbLandscape: TRadioButton;
    Label84: Label8;
    cbMainFile: TComboBox;
    lblIndex: Label8;
    lblRFDesc: Label8;
    edtRFDescr: Text8Pt;
    lblRFFrom: Label8;
    edtRFFrom: Text8Pt;
    lblRFTo: Label8;
    edtRFTo: Text8Pt;
    GroupBox2: TGroupBox;
    cbTestMode: TCheckBox;
    lbledtSampleCount: TLabeledEdit;
    cbRefreshFirst: TCheckBox;
    cbRefreshLast: TCheckBox;
    lblRFIntro: Label8;
    chkRFAsk: TCheckBox;
    Label86: Label8;
    Label87: Label8;
    btnRangeFilter: TSBSButton;
    Label1: TLabel;
    cbPaperSize: TComboBox;
    procedure cbTestModeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbMainFileClick(Sender: TObject);
    procedure cbIndexClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRangeFilterClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FRangeFilter : TRangeFilter;
    FRangeFilterDetails: TRangeFilterDetails;
    FSettingRegionManager: Boolean;
    //FReport: IVRWReport;
    FRegionManager: IRegionManager;
    Function GetFileNo : Byte;
    Procedure SetFileNo (Value : Byte);
    Function GetIndexNo : Byte;
    Procedure SetIndexNo (Value : Byte);
    Procedure SetRegionManager (Value : IRegionManager);
    procedure ReadMainFiles;
  public
    { Public declarations }
    Property FileNo : Byte Read GetFileNo Write SetFileNo;
    Property IndexNo : Byte Read GetIndexNo Write SetIndexNo;
    Property RegionManager : IRegionManager Read FRegionManager Write SetRegionManager;

    procedure EnableRangeFilterFields(Const RFType : Byte);
    //procedure Init(Report: IVRWReport);
  end;

//function DisplayReportProperties(Report: IVRWReport): Boolean;
function DisplayReportProperties(RegionManager: IRegionManager): Boolean;

implementation

{$R *.dfm}

Uses GlobalTypes, VarFPosu, VarConst, RPDefine, VRWPaperSizesIF, EntLicence;

Var
  InputTypes : Array [1..NoDataF, 0..NofFastNDX] Of Byte;
  IsLITE: Boolean;

//=========================================================================

//function DisplayReportProperties(Report: IVRWReport): Boolean;
function DisplayReportProperties(RegionManager: IRegionManager): Boolean;
var
  Dlg: TfrmVRWReportProperties;
begin
  Dlg := TfrmVRWReportProperties.Create(nil);
  try
    Dlg.RegionManager := RegionManager;
    Result := (Dlg.ShowModal = mrOk);
  finally
    Dlg.Free;
  end;
end;

//=========================================================================

procedure TfrmVRWReportProperties.FormCreate(Sender: TObject);
begin
  FSettingRegionManager := False;
  FRegionManager:= NIL;
end;

//------------------------------

procedure TfrmVRWReportProperties.FormDestroy(Sender: TObject);
begin
  FRegionManager:= NIL;
  FreeAndNIL(FRangeFilter);
end;

//-------------------------------------------------------------------------

procedure TfrmVRWReportProperties.SetRegionManager (Value : IRegionManager);
begin
  FSettingRegionManager := True;
  try
    FRegionManager := Value;

    FRangeFilter := TRangeFilter.Create('Index Filter', 255, FRegionManager.rmReport.vrRangeFilter);

    { Store the original range filter details }
    with FRegionManager.rmReport.vrRangeFilter do
    begin
      FRangeFilterDetails.rfName        := rfName;
      FRangeFilterDetails.rfDescription := rfDescription;
      FRangeFilterDetails.rfType        := rfType;
      FRangeFilterDetails.rfAlwaysAsk   := rfAlwaysAsk;
      FRangeFilterDetails.rfFromValue   := rfFromValue;
      FRangeFilterDetails.rfToValue     := rfToValue;
    end;

    edtReportName.Text       := FRegionManager.rmReport.vrName;
    memReportDesc.Lines.Text := FRegionManager.rmReport.vrDescription;
    rbPortrait.Checked       := (TOrientation(FRegionManager.rmReport.vrPaperOrientation) = poPortrait);
    rbLandscape.Checked      := (Not rbPortrait.Checked);
    FRegionManager.rmReport.vrPaperSizes.ReadAll;
    FRegionManager.rmReport.vrPaperSizes.FillCodeList(cbPaperSize.Items);
    cbPaperSize.ItemIndex := FRegionManager.rmReport.vrPaperSizes.IndexOf(cbPaperSize.Items, FRegionManager.rmReport.vrPaperCode);
  //  cbPaperSize.ItemIndex := cbPaperSize.Items.IndexOf(FRegionManager.rmReport.vrPaperCode);
    edtRFDescr.Text          := FRangeFilter.rfDesc;
    edtRFFrom.Text           := FRangeFilter.rfRangeFromString;
    edtRFTo.Text             := FRangeFilter.rfRangeToString;
    chkRFAsk.Checked         := FRangeFilter.rfAsk;
    cbTestMode.Checked       := FRegionManager.rmReport.vrTestModeParams.tmTestMode;
    lbledtSampleCount.Text   := IntToStr(FRegionManager.rmReport.vrTestModeParams.tmSampleCount);
    cbRefreshFirst.Checked   := FRegionManager.rmReport.vrTestModeParams.tmRefreshStart;
    cbRefreshLast.Checked    := FRegionManager.rmReport.vrTestModeParams.tmRefreshEnd;

    ReadMainFiles;

    FileNo  := FRegionManager.rmReport.vrMainFileNum;
    IndexNo := FRegionManager.rmReport.vrIndexID;
  finally
    FSettingRegionManager := False;
  end;
end;

//-------------------------------------------------------------------------

Function TfrmVRWReportProperties.GetFileNo : Byte;
Begin
//  Result := cbMainFile.ItemIndex + 1;
  Result := LongInt(cbMainFile.Items.Objects[cbMainFile.ItemIndex]);
End;

procedure TfrmVRWReportProperties.SetFileNo (Value : Byte);
var
  i: Integer;
begin
(*
  // check it is a valid file number
  If (Value >= 1) And (Value <= cbMainFile.Items.Count) Then
  Begin
    // if changed then select the list and call the OnClick to reload the index info
    If (GetFileNo <> Value) Then
    Begin
      cbMainFile.ItemIndex := Value - 1;
      cbMainFileClick(Self);
    End; // If (GetFileNo <> Value)
  End // If (Value >= 1) And (Value <= cbMainFile.Items.Count)
  Else
    Raise Exception.Create ('TfrmReportProperties.SetFileNo: Invalid File Number');
*)
  if (GetFileNo <> Value) then
  begin
    for i := 0 to Pred (cbMainFile.Items.Count) do
    begin
      if (LongInt(cbMainFile.Items.Objects[i]) = Value) then
      begin
        { Found it }
        cbMainFile.ItemIndex := i;
        cbMainFileClick(Self);
        Break;
      end; { If }
    end;
  end;

end;

//------------------------------

Function TfrmVRWReportProperties.GetIndexNo : Byte;
Begin
  Result := cbIndex.ItemIndex;
End;
Procedure TfrmVRWReportProperties.SetIndexNo (Value : Byte);
Begin
  // check it is a valid file number
  If (Value >= 0) And (Value <= cbIndex.Items.Count) Then
  Begin
    // if changed then select the list and call the OnClick to update the range filter info
    If (cbIndex.ItemIndex <> Value) Then
    Begin
      cbIndex.ItemIndex := Value;
      cbIndexClick(Self);
    End; // If (cbIndex.ItemIndex <> Value)
  End // If (Value >= 1) And (Value <= cbIndex.Items.Count)
  Else
    Raise Exception.Create ('TfrmReportProperties.SetIndexNo: Invalid File Index');
End;

//-------------------------------------------------------------------------

procedure TfrmVRWReportProperties.cbMainFileClick(Sender: TObject);
Var
  I, FileNo : LongInt;
begin
  // Load the index list
  FileNo := LongInt(cbMainFile.Items.Objects[cbMainFile.ItemIndex]);

  // Do any changes to the search list required by selected file }
  cbIndex.Enabled := (FileNo In [3, 4, 23]);
  lblIndex.Enabled := cbIndex.Enabled;

  cbIndex.Items.Clear;
  If cbIndex.Enabled Then
  Begin
    For I := Low (FastNDXHedL^[FileNo]) To High(FastNDXHedL^[FileNo]) Do
    Begin
      If ((FileNo = 3) And (I In [0..15])) Or
         ((FileNo = 4) And (I In [0..20])) Or
         ((FileNo = 23) And (I In [0..18])) Then
      Begin
        cbIndex.Items.Add (FastNDXHedL^[FileNo,I]);
      End; // If ((FileNo = ...
    End; // For I

    If (cbIndex.Items.Count > 0) Then
    Begin
      cbIndex.ItemIndex := 0;
    End; // If (cbIndex.Items.Count > 0)
  End; // If cbIndex.Enabled
end;

//-------------------------------------------------------------------------

procedure TfrmVRWReportProperties.cbIndexClick(Sender: TObject);
Const
  IndexedFiles : Set Of Byte = [3, 4, 23];
Var
  SupportsRF : Byte;
begin
  // Determine whether this index for this file supports the Input fields
  // and setup the fields appropriately
  If (cbIndex.ItemIndex > 0) Then
  Begin
    SupportsRF := InputTypes[GetFileNo,cbIndex.ItemIndex];
  End // If (cbIndex.ItemIndex > 0)
  Else
    SupportsRF := 0;

  EnableRangeFilterFields(SupportsRF);
end;

//-------------------------------------------------------------------------

//
// Range Filter Type:-
//
//  1  - OurRef
//  2  - Account Code
//  3  - Run No
//  4  - Folio Number
//  5  - String
//  6  - Date
//  7  - Period Year
//  8  - AllocStat + AcCode
//  9  - GL Code
//  10 - Stock Code
//
procedure TfrmVRWReportProperties.EnableRangeFilterFields(Const RFType : Byte);
var
  PreviousRFType: Integer;
begin
  LockWindowUpdate(Self.Handle);
  Try
    PreviousRFType := FRangeFilter.rfType;
    // Determine the Data Type of the range filter from the Range filter Type - see RepInpTypesL in RWOpenF.Pas
    Case RFType Of
      1  : FRangeFilter.rfType := 6;  // OurRef
      2  : FRangeFilter.rfType := 7;  // Account Code
      3  : FRangeFilter.rfType := 4;  // Run No
      4  : FRangeFilter.rfType := 4;  // Folio Number
      5  : FRangeFilter.rfType := 4;  // String
      6  : FRangeFilter.rfType := 1;  // Date
      7  : FRangeFilter.rfType := 2;  // Period Year
      8  : FRangeFilter.rfType := 4;  // AllocStat + AcCode
      9  : FRangeFilter.rfType := 9;  // GL Code
      10 : FRangeFilter.rfType := 10;  // Stock Code
    Else
      FRangeFilter.rfType := 4;  // ASCII
    End; // Case RFType

    lblRFIntro.Enabled := (RFType > 0);

    lblRFDesc.Enabled := (RFType > 0);
    edtRFDescr.Enabled := (RFType > 0);

    lblRFFrom.Enabled := (RFType > 0);
    edtRFFrom.Enabled := (RFType > 0);

    lblRFTo.Enabled := (RFType > 0);
    edtRFTo.Enabled := (RFType > 0);

    btnRangeFilter.Enabled := (RFType > 0);

    if ((not FSettingRegionManager) and (PreviousRFType <> FRangeFilter.rfType)) then
    begin
      edtRFFrom.Text   := '';
      edtRFTo.Text     := '';
      chkRFAsk.Checked := False;
      edtRFDescr.Text  := '';
      
      FRangeFilter.rfDesc        := '';
      FRangeFilter.rfRangeFrom   := '';
      FRangeFilter.rfRangeTo     := '';
      FRangeFilter.rfAsk         := False;
    end;

  Finally
    LockWindowUpdate(0);
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

procedure TfrmVRWReportProperties.cbTestModeClick(Sender: TObject);
begin
  lbledtSampleCount.Enabled := cbTestMode.Checked;
end;

//-------------------------------------------------------------------------

procedure TfrmVRWReportProperties.btnRangeFilterClick(Sender: TObject);
begin
  With TfrmVRWRangeFilterDetails.Create(Self) Do
  Begin
    Try
      // Setup a reference to the Range Filter object to allow direct updating from the OK button
      Item := FRangeFilter;

      // If runtime we can only change the From/To range
      DesignTime := True;

      // Add Location into Caption
      Location := 'Index Filter';

      If (ShowModal = mrOK) Then
      Begin
        edtRFDescr.Text  := FRangeFilter.rfDesc;
        edtRFFrom.Text   := FRangeFilter.rfRangeFromString;
        edtRFTo.Text     := FRangeFilter.rfRangeToString;
        chkRFAsk.Checked := FRangeFilter.rfAsk;
      End; // If (ShowModal = mrOK)
    Finally
      Free;
    End; // Try..Finally
  End; // With TfrmRangeFilterDetail.Create(Self)
end;

//-------------------------------------------------------------------------

procedure TfrmVRWReportProperties.btnOKClick(Sender: TObject);
var
  Response: Word;
  PaperSize: IVRWPaperSize;
  OffPage: Boolean;
begin
  if (FRegionManager.rmReport.vrMainFileNum <> FileNo) then
  begin
    Response :=
      MessageDlg('Changing the main file might invalidate fields on the ' +
                 'report. You will need to change or remove fields which ' +
                 'are not included in the ' + cbMainFile.Text + ' file.',
                 mtWarning,
                 mbOkCancel,
                 0);
    if (Response = mrCancel) then
    begin
      FileNo  := FRegionManager.rmReport.vrMainFileNum;
      IndexNo := FRegionManager.rmReport.vrIndexID;
      ModalResult := 0; // mrNone -- conflicts with TelModuleReleaseStatus in EntLicence.pas;
      Exit;
    end;
  end;
  PaperSize := FRegionManager.rmReport.vrPaperSizes[cbPaperSize.Text];
  if rbLandscape.Checked then
    OffPage := FRegionManager.ControlsOffPage(PaperSize.prMMHeight, PaperSize.prMMWidth)
  else
    OffPage := FRegionManager.ControlsOffPage(PaperSize.prMMWidth, PaperSize.prMMHeight);
  if OffPage then
  begin
    Response :=
      MessageDlg('Some of the controls are outside the new paper size, and ' +
                 'will be forced back inside the paper area',
                 mtWarning,
                 mbOkCancel,
                 0);
    if (Response = mrCancel) then
    begin
      ModalResult := 0; // mrNone -- conflicts with TelModuleReleaseStatus in EntLicence.pas;
      Exit;
    end;
  end;
  FRegionManager.rmReport.vrName        := edtReportName.Text;
  FRegionManager.rmReport.vrDescription := memReportDesc.Lines.Text;
  if rbPortrait.Checked then
    FRegionManager.rmPaperOrientation := poPortrait
  else
    FRegionManager.rmPaperOrientation := poLandscape;
  FRegionManager.rmReport.vrTestModeParams.tmTestMode     := cbTestMode.Checked;
  FRegionManager.rmReport.vrTestModeParams.tmSampleCount  := StrToIntDef(lbledtSampleCount.Text, 0);
  FRegionManager.rmReport.vrTestModeParams.tmRefreshStart := cbRefreshFirst.Checked;
  FRegionManager.rmReport.vrTestModeParams.tmRefreshEnd   := cbRefreshLast.Checked;
  FRegionManager.rmReport.vrMainFileNum := FileNo;
  FRegionManager.rmReport.vrMainFile := cbMainFile.Text;
  if cbIndex.ItemIndex > -1 then
    FRegionManager.rmReport.vrIndexID := IndexNo
  else
    FRegionManager.rmReport.vrIndexID := 0;
  FRegionManager.rmPaperCode := cbPaperSize.Text;
{
  FReport.vrRangeFilter.rfDescription := FRangeFilter.rfDesc;
  FReport.vrRangeFilter.rfFromValue   := FRangeFilter.rfRangeFromString;
  FReport.vrRangeFilter.rfToValue     := FRangeFilter.rfRangeToString;
  FReport.vrRangeFilter.rfType        := FRangeFilter.rfType;
  FReport.vrRangeFilter.rfAlwaysAsk   := FRangeFilter.rfAsk;
}
  ModalResult := mrOK;
end;

//-------------------------------------------------------------------------


procedure TfrmVRWReportProperties.ReadMainFiles;
Var
  I: LongInt;
  WantF: Boolean;
  VRWVers: Byte;
begin
  If (cbMainFile.Items.Count = 0) Then
  Begin
    VRWVers := VRWVersionNo;
    // Load Data Files combo
    For I := 1 To High(DataFilesL^) Do
    Begin
      Case I Of
        // Stock File
        6                  : WantF := (VRWVers In [2,4,5,6,8,9,11]);
        // Cost Centre and Departments
        7, 8               : WantF := (VRWVers >= 3);
        // Not Used or Form Designer Only
        9, 11, 12, 13      : WantF := False;
        // Bill Of Materials
        10                 : WantF := (VRWVers In [2,4,5,6,8,9,11]);
        // Discount Matrix
        14                 : WantF := (VRWVers In [2,4,5,6,8,9,11]);
        // Serial Number DB
        16                 : WantF := (VRWVers In [5, 6, 9, 11]) and not IsLITE;
        // Job Costing files - Job Costing versions only
        15, 17..19, 21..25 : WantF := (VRWVers In [6,11]);
        // FIFO
        20                 : WantF := (VRWVers In [2,4,5,6,8,9,11]);
        // Stock location files - SPOP versions only
        26, 27             : WantF := (VRWVers In [5,6,9,11]) and not IsLITE;
        // Matched Payments
        28                 : WantF := True;
        // Stock Notes
        31                 : WantF := (VRWVers In [2,4,5,6,8,9,11]);
        // CIS Vouchers
        33                 : WantF := (VRWVers In [6,11]) and CISOn;
        // Multi-bins
        34                 : WantF := not IsLITE;
      Else
        WantF := True;
      End; { Case }

      If WantF Then
      Begin
        cbMainFile.Items.AddObject(DataFilesL^[I], Pointer(I));
      End; // If WantF
    End; // For I

    If (cbMainFile.Items.Count > 0) Then
    Begin
      // Auto-select the first data file and update the index fields
      cbMainFile.ItemIndex := 0;
      cbMainFileClick(cbMainFile);
      cbIndexClick(cbIndex);
    End; // If (cbMainFile.Items.Count > 0)
  End; // If (cbMainFile.Items.Count = 0)

end;

procedure TfrmVRWReportProperties.btnCancelClick(Sender: TObject);
begin
  { Restore the original range filter details }
  with FRegionManager.rmReport.vrRangeFilter do
  begin
    rfName        := FRangeFilterDetails.rfName;
    rfDescription := FRangeFilterDetails.rfDescription;
    rfType        := FRangeFilterDetails.rfType;
    rfAlwaysAsk   := FRangeFilterDetails.rfAlwaysAsk;
    rfFromValue   := FRangeFilterDetails.rfFromValue;
    rfToValue     := FRangeFilterDetails.rfToValue;
  end;
end;

Initialization
  FillChar (InputTypes, SizeOf(InputTypes), #0);

  IsLITE := (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]);


//  1  - OurRef
//  2  - Account Code
//  3  - Run No
//  4  - Folio Number
//  5  - String
//  6  - Date
//  7  - Period Year
//  8  - AllocStat + AcCode
//  9  - GL Code
//  10 - Stock Code

  // Document Header Indexes
  InputTypes[3,1]  := 1;  // Document No.
  InputTypes[3,2]  := 2;  // Account Code
  InputTypes[3,4]  := 3;  // Posted Docs
  InputTypes[3,9]  := 4;  // Folio Number
  InputTypes[3,10] := 5;  // Your Ref (Short)
  InputTypes[3,11] := 5;  // Your Ref (Long)
  InputTypes[3,12] := 6;  // Document Date
  InputTypes[3,13] := 7;  // Document Period
  InputTypes[3,14] := 8;  // Outstanding

  // Document Lines
  InputTypes[4,1]  := 4;  // Folio Number
  InputTypes[4,3]  := 3;  // Posted Docs
  InputTypes[4,13] := 9;  // Nominal Code Posted
  InputTypes[4,14] := 10; // Stock Code
  InputTypes[4,15] := 2;  // Account Code
  InputTypes[4,16] := 1;  // Document No.
  InputTypes[4,17] := 6;  // Document Date
  InputTypes[4,18] := 7;  // Document Period
  InputTypes[4,19] := 9;  // Unreconciled
  InputTypes[4,20] := 9;  // Reconciled

  { Job Actuals Indices }
  InputTypes[23,1]  := 4;  // Folio Number
  InputTypes[23,3]  := 3;  // Posted Docs
  InputTypes[23,13] := 9;  // Nominal Code Posted
  InputTypes[23,14] := 10; // Stock Code
  InputTypes[23,15] := 2;  // Account Code
  InputTypes[23,16] := 1;  // Document No.
  InputTypes[23,17] := 6;  // Document Date
  InputTypes[23,18] := 7;  // Document Period
end.

