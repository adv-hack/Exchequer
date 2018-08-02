unit SetTrans;
{
  CJS 2012-05-23: ABSEXCH-12990 - SF131 - Fix for empty transactions.

  This form allows the user to enter a Transaction reference, and if the
  specified Transaction has no lines attached, all the financial values on it
  are set to zero.

  This is a fix for erroneously-created Transaction Headers.
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GENENTU, ExtCtrls, StdCtrls, bkgroup, ComCtrls, Mask, TEditVal;

type
  TClearTransFrm = class(TTestCust)
    Label1: TLabel;
    Label2: TLabel;
    Label81: Label8;
    TransactionTxt: Text8Pt;
    StatusPnl: TPanel;
    procedure OkCP1BtnClick(Sender: TObject);
    procedure TransactionTxtChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TransactionTxtKeyPress(Sender: TObject; var Key: Char);
  private
    { Count of the number of Transactions that were processed }
    FRecordsCleared: Integer;
    { Displays the supplied message in the status panel. If AsError is True,
      the panel is highlighted to alert the user. }
    procedure ShowStatus(Msg: string; AsError: Boolean = False);
    { Clears the status panel }
    procedure ClearStatus;
    { Main handler for clearing the selected Transaction }
    procedure Process;
    { Checks that the Transaction exists, and has no lines }
    function TransactionIsValid: Boolean;
    { Clears the current Transaction (the correct Transaction is assumed to
      have already been selected) }
    procedure ClearTransaction;
  public
    { Public declarations }
    property RecordsCleared: Integer read FRecordsCleared;
  end;

implementation

{$R *.dfm}

uses GlobVar, VarConst, BtrvU2, ReBuld1U, ProgU;

// =============================================================================
// TTClearTransFrm
// =============================================================================

procedure TClearTransFrm.ClearStatus;
begin
  StatusPnl.Caption := '';
end;

// -----------------------------------------------------------------------------

procedure TClearTransFrm.ClearTransaction;
begin
  // Clear the values
  Inv.AllocStat := #0;
  Inv.InvNetVal := 0.0;
  Inv.InvVat := 0.0;
  Inv.TotOrdOS := 0.0;
  Inv.TotalCost := 0.0;
  Inv.TotalReserved := 0.0;
  Inv.TotalInvoiced := 0.0;
  Inv.Settled := 0.0;
  Inv.CurrSettled := 0.0;
  Inv.SettledVAT := 0.0;
  Inv.VATClaimed := 0.0;
  Inv.DiscSetl := 0.0;
  Inv.DiscSetAm := 0.0;
  Inv.DiscAmount := 0.0;
  Inv.PostDiscAm := 0.0;
  Inv.Variance := 0.0;
  Inv.TotalOrdered := 0.0;
  Inv.TotalReserved := 0.0;
  Inv.ReValueAdj := 0.0;
  Inv.OBaseEquiv := 0.0;
  Inv.BDiscount := 0.0;
  Inv.AuthAmnt := 0.0;
  Inv.CISTax := 0.0;
  Inv.CISDeclared := 0.0;
  Inv.TotalCost2 := 0.0;
  Inv.CISGross := 0.0;
  Inv.CISGExclude := 0.0;

  // Save the record
  Status := Put_Rec(F[InvF], InvF, RecPtr[InvF]^, InvOurRefK);
  if (StatusOk) then
  begin
    // Done. Report, and then reset ready for another Transaction
    FRecordsCleared := FRecordsCleared + 1;
    ShowStatus(TransactionTxt.Text + ' cleared');
    Write_FixMsgFmt(TransactionTxt.Text + ' cleared', 3);
    TransactionTxt.Text := '';
  end
  else
  begin
    // Update failed
    ShowStatus('Unable to save ' + TransactionTxt.Text + ', error ' + IntToStr(Status), True);
  end;
  TransactionTxt.SetFocus;
end;

// -----------------------------------------------------------------------------

procedure TClearTransFrm.FormCreate(Sender: TObject);
begin
  inherited;
  OkCP1Btn.Enabled := False;
  FRecordsCleared  := 0;
end;

// -----------------------------------------------------------------------------

procedure TClearTransFrm.OkCP1BtnClick(Sender: TObject);
begin
  Process;
end;

// -----------------------------------------------------------------------------

procedure TClearTransFrm.Process;
begin
  if TransactionIsValid then
    ClearTransaction;
end;

// -----------------------------------------------------------------------------

procedure TClearTransFrm.ShowStatus(Msg: string; AsError: Boolean);
begin
  if AsError then
    StatusPnl.Font.Color := clRed
  else
    StatusPnl.Font.Color := clWindowText;
  StatusPnl.Caption := Msg;
end;

// -----------------------------------------------------------------------------

function TClearTransFrm.TransactionIsValid: Boolean;
const
  InvKeyPath = InvOurRefK;
  IdKeyPath = IdFolioK;
var
  InvKey: Str255;
  IdKey: Str255;
  ErrorMsg: string;
begin
  Result   := True;
  ErrorMsg := '';
  // Search for the Transaction, and report an error if it cannot be found
  InvKey := TransactionTxt.Text;
  Status := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvKeypath, InvKey);
  if StatusOk then
  begin
    // Search for Transaction Lines, and report an error if any are found
    IdKey := FullNomKey(Inv.FolioNum);
    Status := Find_Rec(B_GetGEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdKeyPath, IdKey);
    if (Status = 0) and (Id.FolioRef = Inv.FolioNum) then
    begin
      // At least one Transaction Line was found
      ErrorMsg := InvKey + ' has Transaction Lines';
      TransactionTxt.SetFocus;
      Result := False;
    end;
  end
  else
  begin
    ErrorMsg := InvKey + ' not found';
    TransactionTxt.SetFocus;
    Result := False;
  end;
  if not Result then
  begin
    ShowStatus(ErrorMsg, True);
    TransactionTxt.SetFocus;
  end;
end;

// -----------------------------------------------------------------------------

procedure TClearTransFrm.TransactionTxtChange(Sender: TObject);
begin
  OkCP1Btn.Enabled := Length(Trim(TransactionTxt.Text)) = 9;
end;

// -----------------------------------------------------------------------------

procedure TClearTransFrm.TransactionTxtKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  ClearStatus;
end;

// -----------------------------------------------------------------------------

end.
