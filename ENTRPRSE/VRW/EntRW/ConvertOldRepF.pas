unit ConvertOldRepF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, SBSOutl, StdCtrls,
  RWRIntF, VRWReportIF;

type
  TfrmConvertReport = class(TForm)
    olConvertRptTree: TSBSOutlineC;
    pnlHeading: TPanel;
    pnlButtons: TPanel;
    btnClose: TButton;
    btnImport: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure olConvertRptTreeNeedValue(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure olConvertRptTreeDblClick(Sender: TObject);
  private
    { Private declarations }
    FOriginalOutLineWidth,
    FOriginalOutLineHeight : SmallInt;
    FReport: IReportDetails;

    FRepTree : IReportTree;
    FNodeObjects : TInterfaceList;

    FDLLHandle: LongWord;

    function LoadDLL: Boolean;
    function FormLineText(byOffSetDepth : Byte; sStrToFormat : ShortString ) : string;
  public
    { Public declarations }
    property Report: IReportDetails read FReport;
  end;

//var
//  frmConvertReport: TfrmConvertReport;

function ConvertOldReport(OldReport: IReportDetails): IVRWReport;

implementation

{$R *.dfm}

uses
  ETStrU,
  GlobalTypes,
  VRWConverterIF,
  RptEngDLL;

type
  TrwrInitCall = function (const DataPath: ShortSTring): LongInt; stdcall;
  TrwrDeInitCall = function: LongInt; stdcall;
  TrwrGetReportTreeCall = function: IReportTree; stdcall;
  TrwrGetReportDetailsCall = function(const ReportCode: ShortString): IReportDetails; stdcall;

var
  rwrInit: TrwrInitCall;
  rwrDeInit: TrwrDeInitCall;
  rwrGetReportTree: TrwrGetReportTreeCall;
  rwrGetReportDetails: TrwrGetReportDetailsCall;

const
  NOT_FOUND_MSG = 'Could not find %s function in Report Reader DLL.';

// Opens the Reports.Dat in the specified directory so that the other functions
// can be used.
//
// Return values:-
//
//   1001   Invalid Data Path
//   2000+  Btrieve Error opening Reports.Dat with 2000 offset
//function rwrInit (const DataPath : ShortString) : LongInt; stdcall; external 'rwreader.dll';

// Closes Reports.Dat and tidies up after everything
//function rwrDeInit : LongInt; stdcall; external 'rwreader.dll';

// Returns an IReportTree object which encapsulates the report tree and the reports
//function rwrGetReportTree : IReportTree; stdcall; external 'rwreader.dll';

// Returns an IReportDetails object for the specified report, returns NIL if
// the code is invalid
//function rwrGetReportDetails (const ReportCode : ShortString) : IReportDetails; stdcall; external 'rwreader.dll';

{ Performs the conversion, returning a report in the new format. Returns nil
  if the conversion failed or was aborted. }
function ConvertOldReport(OldReport: IReportDetails): IVRWReport;
var
  Converter: IVRWConverter;
begin
  Converter := GetVRWConverter;
  try
    Converter.SourceReport := OldReport;
    Converter.Execute;
    Result := Converter.Report;
  finally
    Converter := nil;
  end;
end;

procedure TfrmConvertReport.FormCreate(Sender: TObject);
var
  lInitRes : LongInt;
  ONomRec : ^OutnomType;

  procedure ProcessReportBranch (const ParentIdx : LongInt; const TreeBranch : IReportTree);
  var
    lNodeIdx : Longint;
    iReportItem : SmallInt;
    ssEntryString : ShortString;
  begin // ProcessReportBranch
    if (TreeBranch.rpReportCount > 0) then
    begin
      for iReportItem := 0 to (TreeBranch.rpReportCount - 1) do
      begin
        ssEntryString := Trim(TreeBranch.rpReports[iReportItem].rpCode) + ' - ' +
                              TreeBranch.rpReports[iReportItem].rpName;

        if (ParentIdx = 0) then
          ssEntryString := FormLineText(0, ssEntryString)
        else
          ssEntryString := FormLineText(1, ssEntryString);

        New(ONomRec);
        FillChar(ONomRec^,Sizeof(ONomRec^),0);

        ONomRec^.OutStkCode := TreeBranch.rpReports[iReportItem].rpCode;
        ONomRec^.GrpDesc := TreeBranch.rpReports[iReportItem].rpName;
        ONomRec^.OutStkCat := TreeBranch.rpReports[iReportItem].rpPWord;
        ONomRec^.OutNomCode := Integer(TreeBranch.rpReports[iReportItem].rpType);

        lNodeIdx := olConvertRptTree.AddChildObject(ParentIdx, ssEntryString, ONomRec);

        FNodeObjects.Add(TreeBranch.rpReports[iReportItem]);

        if (TreeBranch.rpReports[iReportItem].rpType = rtGroup) then
          ProcessReportBranch(lNodeIdx, TreeBranch.rpReports[iReportItem]);

      end; // for iReportItem
    end; // if (FRepTree.rpReportCount > 0)
  end; // ProcessReportBranch

begin
  Self.Height := 342;
  Self.Width := 598;

  FOriginalOutLineWidth := 480;
  FOriginalOutLineHeight := 280;

  FReport := nil;

  FNodeObjects := TInterfaceList.Create;

  LoadDLL;
  if (FDLLHandle <> 0) then
  begin
    lInitRes := rwrInit(GReportPath);
    if (lInitRes = 0) then
    begin // Load Tree
      FRepTree := rwrGetReportTree;
      if assigned(FRepTree) then
        ProcessReportBranch(0, FRepTree);
    end
    else
      ShowMessage ('rwrInit: ' + IntToStr(lInitRes));
  end;
end;

procedure TfrmConvertReport.FormDestroy(Sender: TObject);
begin
  FNodeObjects.Clear;
  FreeAndNIL(FNodeObjects);
  if (FDLLHandle <> 0) then
  begin
    rwrDeInit;

    // CJS: 18/02/2008:

    // We really should free the library here. Unfortunately, Delphi appears
    // not to free up the items stored in the FNodeObjects that we have just
    // released (possibly it is delaying this for some reason). If we free the
    // library, we get a subsequent access violation, presumably at the point
    // where Delphi *does* attempt to the free the objects.

    // Instead, we won't free the library -- it should get freed when the VRW
    // is closed. Not nice, but I can't find another way round it.

//    if not FreeLibrary(FDLLHandle) then
//      ShowMessage('FreeLibrary failed with error #' + IntToStr(GetLastError));

  end;
end;

procedure TfrmConvertReport.FormResize(Sender: TObject);
var
  WidthChange, HeightChange : SmallInt;
begin
  WidthChange := (Self.Width - Self.Constraints.MinWidth);
  HeightChange := (Self.Height - Self.Constraints.MinHeight);

  olConvertRptTree.Width := FOriginalOutLineWidth + WidthChange;
//  olConvertRptTree.Height := FOriginalOutLineHeight + HeightChange;

  olConvertRptTree.Repaint;
end;

procedure TfrmConvertReport.btnCloseClick(Sender: TObject);
begin
  Close;
end;

function TfrmConvertReport.FormLineText(byOffSetDepth : Byte; sStrToFormat : ShortString ) : string;
var
  siCRLFPos : SmallInt;
begin
  siCRLFPos := Pos(#13+#10, sStrToFormat);
  while (siCRLFPos > 0) do
  begin
    Delete(sStrToFormat, siCRLFPos, 2);
    Insert('. ', sStrToFormat, siCRLFPos);
    siCRLFPos := Pos(#13+#10, sStrToFormat);
  end;

  Result := Spc(1 * byOffSetDepth) + Strip('R', [#32], sStrToFormat);
end;

procedure TfrmConvertReport.olConvertRptTreeNeedValue(Sender: TObject);
var
  DrawIdxCode  :  LongInt;
  ONomRec      :  ^OutNomType;
begin
  with Sender as TSBSOutLineC do
  begin
    DrawIdxCode := CalcIdx;

    if (DrawIdxCode > 0) then
    begin
      ONomRec := Items[DrawIdxCode].Data;

      if (ONomRec <> nil) then
      begin
        with ONomRec^ do
          if (GrpDesc <> '') then
            ColValue := trim(GrpDesc);

        ColsX := (pnlHeading.Left + pnlHeading.Width);

      end; // if (ONomRec <> nil) then...
    end; // if (DrawIdxCode > 0) then...

  end; // with Sender as TSBSOutLineC do...
end;

procedure TfrmConvertReport.btnImportClick(Sender: TObject);
var
  ReportDetails : IReportDetails;
  ONomRec      :  ^OutNomType;
begin
  if (olConvertRptTree.SelectedItem > 0) then
  begin
    ONomRec := olConvertRptTree.Items[olConvertRptTree.SelectedItem].Data;

    if (TReportType(ONomRec^.OutNomCode) = rtReport) then
    begin
      ReportDetails := rwrGetReportDetails(ONomRec^.OutStkCode);
      if assigned(ReportDetails) then
      begin
        FReport := ReportDetails;
        ModalResult := mrOk;
      end;
    end;

  end; // if (olConvertRptTree.SelectedItem > 0) then...
end;

procedure TfrmConvertReport.olConvertRptTreeDblClick(Sender: TObject);
begin
  if (olConvertRptTree.SelectedItem > 0) and
     (not olConvertRptTree.Items[olConvertRptTree.SelectedItem].HasItems) then
    btnImportClick(nil);
end;

function TfrmConvertReport.LoadDLL: Boolean;
var
  ErrMsg: string;
begin
  FDLLHandle := LoadLibrary('rwreader.dll');
  if (FDLLHandle <> 0) then
  begin
    @rwrInit             := GetProcAddress(FDLLHandle, 'rwrInit');
    @rwrDeInit           := GetProcAddress(FDLLHandle, 'rwrDeInit');
    @rwrGetReportTree    := GetProcAddress(FDLLHandle, 'rwrGetReportTree');
    @rwrGetReportDetails := GetProcAddress(FDLLHandle, 'rwrGetReportDetails');
    if not Assigned(rwrInit) then
      ErrMsg := 'rwrInit'
    else if not Assigned(rwrDeInit) then
      ErrMsg := 'rwrDeInit'
    else if not Assigned(rwrGetReportTree) then
      ErrMsg := 'rwrGetReportTree'
    else if not Assigned(rwrGetReportDetails) then
      ErrMsg := 'rwrGetReportDetails'
    else
      { If we have reached here, we have successfully loaded the DLL and
        obtained the addresses of all the required functions. }
      Result := True;
    if ErrMsg <> '' then
      ErrMsg := Format(NOT_FOUND_MSG, [ErrMsg])
  end
  else
  begin
    ShowMessage('Unable to load rwreader.dll');
    Result := False;
  end;
end;

end.
