unit TestTreeF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, SBSOutl, ExtCtrls, StdCtrls, RWRIntF, RepDetsF;

type
  TForm1 = class(TForm)
    SBSOutlineC1: TSBSOutlineC;
    Label1: TLabel;
    edtDataSetPath: TEdit;
    btnInit: TButton;
    btnDeInit: TButton;
    Bevel1: TBevel;
    btnViewReport: TButton;
    procedure btnInitClick(Sender: TObject);
    procedure btnDeInitClick(Sender: TObject);
    procedure btnViewReportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FRepTree : IReportTree;
    FNodeObjects : TInterfaceList;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

// Opens the Reports.Dat in the specified directory so that the other functions
// can be used.
//
// Return values:-
//
//   1001   Invalid Data Path
//   2000+  Btrieve Error opening Reports.Dat with 2000 offset
Function rwrInit (Const DataPath : ShortString) : LongInt; StdCall; External 'rwreader.dll';

// Closes Reports.Dat and tidies up after everything
Function rwrDeInit : LongInt; StdCall; External 'rwreader.dll';

// Returns an IReportTree object which encapsulates the report tree and the reports
Function rwrGetReportTree : IReportTree; StdCall; External 'rwreader.dll';

// Returns an IReportDetails object for the specified report, returns NIL if
// the code is invalid
Function rwrGetReportDetails (Const ReportCode : ShortString) : IReportDetails; StdCall; External 'rwreader.dll';

//-------------------------------------------------------------------------

procedure TForm1.FormCreate(Sender: TObject);
begin
  FNodeObjects := TInterfaceList.Create;
end;

//------------------------------

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FNodeObjects.Clear;
  FreeAndNIL(FNodeObjects);
end;

//-------------------------------------------------------------------------

procedure TForm1.btnInitClick(Sender: TObject);
Var
  lInitRes    : LongInt;

  Procedure ProcessReportBranch (Const ParentIdx : LongInt; Const TreeBranch : IReportTree);
  Var
    lNodeIdx : Longint;
    iReportItem : SmallInt;
  Begin // ProcessReportBranch
    If (TreeBranch.rpReportCount > 0) Then
    Begin
      For iReportItem := 0 To (TreeBranch.rpReportCount - 1) Do
      Begin
        If (ParentIdx = 0) Then
          lNodeIdx := SBSOutlineC1.Add (ParentIdx, Trim(TreeBranch.rpReports[iReportItem].rpCode) + ' - ' + TreeBranch.rpReports[iReportItem].rpName + ' (' + TreeBranch.rpReports[iReportItem].rpPWord + ')')
        Else
          lNodeIdx := SBSOutlineC1.AddChild (ParentIdx, Trim(TreeBranch.rpReports[iReportItem].rpCode) + ' - ' + TreeBranch.rpReports[iReportItem].rpName + ' (' + TreeBranch.rpReports[iReportItem].rpPWord + ')');
        FNodeObjects.Add (TreeBranch.rpReports[iReportItem]);

        SBSOutlineC1.Items[lNodeIdx].Data := Pointer(TreeBranch.rpReports[iReportItem]);

        If (TreeBranch.rpReports[iReportItem].rpType = rtGroup) Then
        Begin
          ProcessReportBranch (lNodeIdx, TreeBranch.rpReports[iReportItem]);
        End; // If (FRepTree.rpReports[iReportItem].rpType = rtGroup)
      End; // For iReportItem
    End; // If (FRepTree.rpReportCount > 0)
  End; // ProcessReportBranch

begin
  lInitRes := rwrInit (edtDataSetPath.Text);
  If (lInitRes = 0) Then
  Begin
    // Load Tree
    FRepTree := rwrGetReportTree;
    If Assigned(FRepTree) Then
    Begin
      // Load Tree
      ProcessReportBranch (0, FRepTree);
    End // If Assigned(FRepTree)
  End // If (lInitRes = 0)
  Else
    ShowMessage ('rwrInit: ' + IntToStr(lInitRes));
end;

//-------------------------------------------------------------------------

procedure TForm1.btnDeInitClick(Sender: TObject);
Var
  lInitRes : LongInt;
begin
  FRepTree := NIL;

  lInitRes := rwrDeInit;
  If (lInitRes <> 0) Then
  Begin
    // Load Tree
    ShowMessage ('rwrDeInit: ' + IntToStr(lInitRes));
  End; // If (lInitRes <> 0)
end;

//-------------------------------------------------------------------------


procedure TForm1.btnViewReportClick(Sender: TObject);
Var
  RepDets : IReportDetails;
  ifield  : SmallInt;
begin
  If (SBSOutlineC1.SelectedItem >= 1) Then
  Begin
    // Extract report details from list, remember the outline is 1 based and
    // the list is 0 based.
    With FNodeObjects[SBSOutlineC1.SelectedItem - 1] As IReportTreeElement Do
    Begin
      If (rpType = rtReport) Then
      Begin
        // Get the report details from the DLL
        RepDets := rwrGetReportDetails (rpCode);
        If Assigned(RepDets) Then
        Begin
          Try
            // create the memo form to display the details
            With TfrmReportDets.Create(Self) Do
            Begin
              Try
                With Memo1.Lines Do
                Begin
                  Caption := 'Report Details - ' + Trim(RepDets.rdReportHeader.RepName);
                  Add ('Report Code: ' + Trim(RepDets.rdReportHeader.RepName));
                  Add ('Report Name: ' + RepDets.rdReportHeader.RepDesc);
                  Add ('Report Type: ' + RepDets.rdReportHeader.RepType);

                  Add ('');
                  Add ('Input Fields:-');
                  If (RepDets.rdInputLineCount > 0) Then
                  Begin
                    For iField := 0 To (RepDets.rdInputLineCount - 1) Do
                    Begin
                      With RepDets.rdInputLines[iField] Do
                      Begin
                        Add (SysUtils.Format('%s%6.6d - %s', [VarType, RepVarNo, RepLDesc]));
                      End; // With RepDets.rdInputLines[iField]
                    End; // For iField
                  End; // If (RepDets.rdInputLineCount > 0)

                  Add ('');
                  Add ('Heading Fields:-');
                  If (RepDets.rdHeadingLineCount > 0) Then
                  Begin
                    For iField := 0 To (RepDets.rdHeadingLineCount - 1) Do
                    Begin
                      With RepDets.rdHeadingLines[iField] Do
                      Begin
                        If (Not CalcField) Then
                          Add (SysUtils.Format('%s%6.6d - Field: %s - Title: %s', [VarType, RepVarNo, Trim(VarRef), Trim(RepLDesc)]))
                        Else
                          Add (SysUtils.Format('%s%6.6d - Formula: %s', [VarType, RepVarNo, Trim(VarSubSplit)]));
                      End; // With RepDets.rdHeadingLines[iField]
                    End; // For iField
                  End; // If (RepDets.rdHeadingLineCount > 0)

                  Add ('');
                  Add ('Report Fields:-');
                  If (RepDets.rdReportLineCount > 0) Then
                  Begin
                    For iField := 0 To (RepDets.rdReportLineCount - 1) Do
                    Begin
                      With RepDets.rdReportLines[iField] Do
                      Begin
                        If (Not CalcField) Then
                          Add (SysUtils.Format('%s%6.6d - Field: %s - Title: %s', [VarType, RepVarNo, Trim(VarRef), Trim(RepLDesc)]))
                        Else
                          Add (SysUtils.Format('%s%6.6d - Formula: %s', [VarType, RepVarNo, Trim(VarSubSplit)]));
                      End; // With RepDets.rdReportLines[iField]
                    End; // For iField
                  End; // If (RepDets.rdReportLineCount > 0)
                End; // With Memo1.Lines

                ShowModal;
              Finally
                Free;
              End; // Try..Finally
            End; // With TfrmReportDets.Create(Self)
          Finally
            RepDets := NIL;
          End; // Try..Finally
        End // If Assigned(RepDets)
        Else
          ShowMessage ('Report Not Loaded: ' + rpCode);
      End; // If (rpType = rtReport)     
    End; // With FNodeObjects[SBSOutlineC1.SelectedItem - 1] As IReportTreeElement
  End; // If (SBSOutlineC1.SelectedItem >= 1)
end;

end.
