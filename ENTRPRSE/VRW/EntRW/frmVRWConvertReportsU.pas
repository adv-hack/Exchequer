unit frmVRWConvertReportsU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, SBSOutl, StdCtrls,
  RWRIntF;

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
  private
    { Private declarations }
    FOriginalOutLineWidth,
    FOriginalOutLineHeight : SmallInt;
    FReport: IReportDetails;

    FRepTree : IReportTree;
    FNodeObjects : TInterfaceList;

    function FormLineText(byOffSetDepth : Byte; sStrToFormat : ShortString ) : string;
  public
    { Public declarations }
    property Report: IReportDetails read FReport;
  end;

var
  frmConvertReport: TfrmConvertReport;

implementation

{$R *.dfm}

uses
  ETStrU,
  GlobalTypes;

// Opens the Reports.Dat in the specified directory so that the other functions
// can be used.
//
// Return values:-
//
//   1001   Invalid Data Path
//   2000+  Btrieve Error opening Reports.Dat with 2000 offset
function rwrInit (const DataPath : ShortString) : LongInt; stdcall; external 'rwreader.dll';

// Closes Reports.Dat and tidies up after everything
function rwrDeInit : LongInt; stdcall; external 'rwreader.dll';

// Returns an IReportTree object which encapsulates the report tree and the reports
function rwrGetReportTree : IReportTree; stdcall; external 'rwreader.dll';

// Returns an IReportDetails object for the specified report, returns NIL if
// the code is invalid
function rwrGetReportDetails (const ReportCode : ShortString) : IReportDetails; stdcall; external 'rwreader.dll';

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
  pnlHeading.Color := FDefaultInactiveColour;
  pnlButtons.Color := FDefaultInactiveColour;

  olConvertRptTree.BarColor := FDefaultActiveColour;
  olConvertRptTree.BarTextColor := FDefaultInactiveColour;

  Self.Height := 358;
  Self.Width := 598;

  FOriginalOutLineWidth := 480;
  FOriginalOutLineHeight := 280;

  FReport := nil;

  FNodeObjects := TInterfaceList.Create;

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

procedure TfrmConvertReport.FormDestroy(Sender: TObject);
begin
  FNodeObjects.Clear;
  FreeAndNIL(FNodeObjects);
end;

procedure TfrmConvertReport.FormResize(Sender: TObject);
var
  WidthChange, HeightChange : SmallInt;
begin
  WidthChange := (Self.Width - Self.Constraints.MinWidth);
  HeightChange := (Self.Height - Self.Constraints.MinHeight);

  olConvertRptTree.Width := FOriginalOutLineWidth + WidthChange;
  olConvertRptTree.Height := FOriginalOutLineHeight + HeightChange;

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
        FReport := ReportDetails;
    end;

  end; // if (olConvertRptTree.SelectedItem > 0) then...
end;

end.
