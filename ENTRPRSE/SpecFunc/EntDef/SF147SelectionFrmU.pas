unit SF147SelectionFrmU;
{
  Form for SF 147, searching for erroneous Adjustment Lines, and displaying
  a check-list of any transactions found, allowing the user to select the
  ones they want to process.
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ComCtrls, ExtCtrls,
  VarConst,
  GlobVar,
  BtrvU2,
  ReBuld1U,
  ProgU;

type
  TSF147SelectionFrm = class(TForm)
    pnlButtons: TPanel;
    pnlMain: TPanel;
    btnScan: TButton;
    btnOk: TButton;
    btnCancel: TButton;
    lstSelection: TCheckListBox;
    txtRecords: TStaticText;
    pnlHeader: TPanel;
    lblAdjustments: TLabel;
    lblInstructions: TLabel;
    Bevel1: TBevel;
    lstWarning: TListBox;
    lblWarning: TLabel;
    procedure btnScanClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FCancelled: Boolean;
    FRecordCount: Integer;
    FScanning: Boolean;
    FAutoStart: Boolean;

    { Scans DETAILS.DAT to find Adjustment Lines with a Run Number of -21
      (indicating a transaction line that was not processed correctly during
      a daybook post on adjustments raised from a stock-take). Adds the
      transaction OurRefs to the SelectionList. }
    procedure Scan;
    procedure BeforeScan;
    procedure PerformScan;
    procedure AfterScan;

    { Adds a line to the list of warning messages }
    procedure AddWarning(Msg: string);

  public
    // Copies the ticked Adjustment entries from the selection list into the
    // supplied string-list.
    procedure CopySelectedTransactions(AdjustmentList: TStrings);

    // Flag to tell the form to start scanning as soon as it is displayed (see
    // FormActivate()). Set this before calling ShowModal().
    property AutoStart: Boolean read FAutoStart write FAutoStart;

    // Returns the count of the number of erroneous Adjustment lines that were
    // actually found.
    property RecordCount: Integer read FRecordCount;
  end;

// Utility function to display the form and to return (in AdjustmentList)
// a list of the Adjustment Transactions that were found and selected by the
// user, and (in RecCount) the total number of erroneous adjustment lines that
// were found. Returns False if the user cancels. Note that the AdjustmentList
// might be empty if the user clicked OK but didn't select any Adjustments.
function GetAdjustmentsForCorrection(AdjustmentList: TStrings; var RecCount: Integer): Boolean;

implementation

{$R *.dfm}

const
  // Note: the first instruction is never actually displayed as the form starts
  // scanning as soon as it is displayed. I've left it here in case it's
  // decided that this isn't acceptable and that the user should start the
  // scan manually.
  Instructions: array[0..5] of string = (
    'Click the Scan button to begin the search for Adjustments with erroneous lines. Once the Adjustments have been found, tick the ones in the list which you want to process, and click OK',
    'Scanning Adjustment lines. No records are being deleted at this point. Click Stop to cancel the scan.',
    'Scan cancelled - No erroneous Adjustment lines were found. You can also use the Scan button to retry the scan.',
    'Scan cancelled - In the list, untick any Adjustments for which you do not want the erroneous lines to be deleted, then click OK. You can also use the Scan button to retry the scan.',
    'Scan complete - No erroneous Adjustment lines were found.',
    'Scan complete - In the list, tick the Adjustments for which you want the erroneous lines to be deleted, then click OK.'
  );

function GetAdjustmentsForCorrection(AdjustmentList: TStrings; var RecCount: Integer): Boolean;
var
  Frm: TSF147SelectionFrm;
begin
  Frm := TSF147SelectionFrm.Create(nil);
  try
    // Flag to tell the form to start scanning as soon as it is displayed. Set
    // this to False to allow the user to start the scan manually instead.
    Frm.AutoStart := True;
    Frm.ShowModal;
    Result := Frm.ModalResult = mrOK;
    if Result then
    begin
      // Copy the selected transactions
      Frm.CopySelectedTransactions(AdjustmentList);
      RecCount := Frm.RecordCount;
    end;
  finally
    Frm.Free;
  end;
end;

// =============================================================================
// TSF147SelectionFrm
// =============================================================================

procedure TSF147SelectionFrm.AddWarning(Msg: string);
begin
  lstWarning.Items.Add(Msg);
end;

// -----------------------------------------------------------------------------

procedure TSF147SelectionFrm.PerformScan;
var
  FuncRes: LongInt;
  Folio: LongInt;
  Key: Str255;
  InvKey: Str255;
  RecCount: Integer;
begin
  // Clear any existing entries.
  lstSelection.Clear;

  // Display the first instructions
  lblInstructions.Caption := Instructions[1];

  // Clear the tracking variables
  Folio := 0;
  RecCount := 0;

  // Search for any lines where Run Number is -21 (this is a temporary run
  // number which should only be set while performing a Daybook-Post on
  // Adjustments after doing a Stock Take -- there is a bug in Exchequer which
  // occasionally results in the creation of multiple duplicated transaction
  // lines, all of which will have this run number).
  Key := FullNomKey(-21);
  FuncRes := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdRunK, Key);
  while (FuncRes = 0) and (Id.PostedRun = -21) and (not FCancelled) do
  begin
    // Only process this record if it is for a different transaction (this
    // assumes that most transaction lines will be grouped together, although
    // this is not always the case -- lines which are not grouped will still
    // be handled correctly, just slightly less efficiently).
    if (Id.FolioRef <> Folio) then
    begin
      // If found, get the transaction header, check that it is an Adjustment,
      // and if so add it to the list of possible transactions.
      InvKey := FullNomKey(Id.FolioRef);
      FuncRes := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, InvKey);
      if FuncRes = 0 then
      begin
        // Only add the transaction if we haven't already recorded it. Because
        // we are searching in PostedRun order it is possible that lines against
        // the same transaction might not be grouped together.
        if (lstSelection.Items.IndexOf(Inv.OurRef) = -1) then
        begin
          lstSelection.Items.Add(Inv.OurRef);
          lstSelection.Checked[lstSelection.Items.Count - 1] := True;
          Application.ProcessMessages;
        end;
      end
      else
      begin
        // Report that we found an orphaned transaction line (should never
        // happen, but checked for just in case).
        AddWarning('No transaction header found for folio ' + IntToStr(Id.FolioRef));
        Write_FixMsgFmt('No transaction header found for folio ' + IntToStr(Id.FolioRef), 4);

        // Allow the search to continue anyway
        FuncRes := 0;
      end;
      Folio := Id.FolioRef;
    end;
    // Update the record count. To improve performance, only update the display
    // of the record count every 100 records.
    RecCount := RecCount + 1;
    if (RecCount mod 100) = 0 then
    begin
      txtRecords.Caption := IntToStr(RecCount) + ' records scanned ';
      // Allow Windows to handle any pending messages. This will allow the
      // caption to be displayed, and will also allow the user to click the
      // 'Stop' button.
      Application.ProcessMessages;
    end;

    FuncRes := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdRunK, Key);
  end;

  // Display the final record count and store it
  txtRecords.Caption := IntToStr(RecCount) + ' records scanned ';
  FRecordCount := RecCount;

  // Update the instructions appropriately
  if lstSelection.Items.Count = 0 then
  begin
    if FCancelled then
      lblInstructions.Caption := Instructions[2]
    else
      lblInstructions.Caption := Instructions[4];
  end
  else
  begin
    if FCancelled then
      lblInstructions.Caption := Instructions[3]
    else
      lblInstructions.Caption := Instructions[5];
  end;
end;

// -----------------------------------------------------------------------------

procedure TSF147SelectionFrm.btnScanClick(Sender: TObject);
begin
  if FScanning then
    // Already scanning -- treat this as a 'stop'
    FCancelled := True
  else
    // Not scanning, so perform the scan now
    Scan;
end;

// -----------------------------------------------------------------------------

procedure TSF147SelectionFrm.AfterScan;
begin
  // Re-enable controls and reset the scanning flags
  lstSelection.Enabled := True;
  btnScan.Caption := '&Scan';
  btnOk.Enabled := True;
  btnCancel.Enabled := True;
  FScanning := False;
  FCancelled := False;
end;

// -----------------------------------------------------------------------------

procedure TSF147SelectionFrm.BeforeScan;
begin
  // Set the scanning flags and disable controls
  FScanning := True;
  FCancelled := False;
  lstSelection.Enabled := False;
  btnOk.Enabled := False;
  btnCancel.Enabled := False;
  lstWarning.Clear;
  // The Scan button is re-captioned and is not disabled, so that the user can
  // interrupt the scan
  btnScan.Caption := '&Stop';
end;

// -----------------------------------------------------------------------------

procedure TSF147SelectionFrm.btnCancelClick(Sender: TObject);
begin
  Close;
end;

// -----------------------------------------------------------------------------

procedure TSF147SelectionFrm.CopySelectedTransactions(
  AdjustmentList: TStrings);
var
  i: Integer;
begin
  // Clear any entries that might already exist
  AdjustmentList.Clear;
  // Add all the ticked Adjustments to the list
  for i := 0 to lstSelection.Items.Count - 1 do
  begin
    if lstSelection.Checked[i] then
      AdjustmentList.Add(lstSelection.Items[i]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TSF147SelectionFrm.FormCreate(Sender: TObject);
begin
  // Display the default instructions (but see the note above the Instructions
  // array declaration).
  lblInstructions.Caption := Instructions[0];
end;

// -----------------------------------------------------------------------------

procedure TSF147SelectionFrm.FormActivate(Sender: TObject);
begin
  if AutoStart then
  begin
    AutoStart := False;
    Scan;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSF147SelectionFrm.Scan;
begin
  BeforeScan;
  PerformScan;
  AfterScan;
end;

// -----------------------------------------------------------------------------

end.
