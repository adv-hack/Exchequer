unit SetTransLineDate;
{
  CJS 2012-09-04: ABSEXCH-12839 - Fix for incorrect Stock Ledger line dates.

  This form allows the user to enter a Transaction reference, and to update
  the dates on all the Transaction Lines for that Transaction.
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GENENTU, ExtCtrls, StdCtrls, bkgroup, ComCtrls, Mask, TEditVal,
  VarConst, uMultiList;

type
  TSetTransLineDateFrm = class(TTestCust)
    Label1: TLabel;
    Label2: TLabel;
    Label81: Label8;
    TransactionTxt: Text8Pt;
    StatusPnl: TPanel;
    FindBtn: TButton;
    Label3: TLabel;
    NewDateTxt: TEditDate;
    ApplyBtn: TButton;
    UseTransactionDateChk: TRadioButton;
    UseManualDateChk: TRadioButton;
    LineList: TMultiList;
    procedure OkCP1BtnClick(Sender: TObject);
    procedure TransactionTxtChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TransactionTxtKeyPress(Sender: TObject; var Key: Char);
    procedure FindBtnClick(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure ReloadTransactionDateBtnClick(Sender: TObject);
    procedure NewDateTxtChange(Sender: TObject);
    procedure UseTransactionDateChkClick(Sender: TObject);
    procedure UseManualDateChkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Count of the number of Transaction Lines that were updated }
    FLinesFixed: Integer;

    { Set to True when a valid Transaction has been found }
    FHasTransaction: Boolean;

    { Adds a new entry to the list of line details, read from the supplied
      line record }
    procedure AddLine(IdRec: Idetail);

    { Displays the Transaction Lines for the current Transaction }
    procedure ShowLines;

    { Displays the supplied message in the status panel. If AsError is True,
      the panel is highlighted to alert the user. }
    procedure ShowStatus(Msg: string; AsError: Boolean = False);

    { Clears the status panel }
    procedure ClearStatus;

    { Attempts to locate the Transaction. Returns False if it cannot be found. }
    function FindTransaction: Boolean;

    { Updates the current Transaction (the correct Transaction is assumed to
      have already been selected and the date entered for the lines) }
    procedure UpdateTransactionLines;

    { Checks whether we have enough information to update the Transaction Lines
      yet, and enables or disables the 'Apply' button accordingly }
    procedure CheckCanApply;

    procedure SetHasTransaction(Value: Boolean);
  public
    { Public declarations }
    property LinesFixed: Integer read FLinesFixed;
    property HasTransaction: Boolean read FHasTransaction write SetHasTransaction;
  end;

implementation

{$R *.dfm}

uses GlobVar, BtrvU2, ReBuld1U, ProgU, ETDateU;

// =============================================================================
// TSetTransLineDate
// =============================================================================

procedure TSetTransLineDateFrm.AddLine(IdRec: Idetail);
var
  ListItem: TListItem;

  function FormattedDate(BaseDate: string): string;
  var
    Element: array[0..2] of string;
  begin
    Element[0] := Copy(BaseDate, 1, 4); // year
    Element[1] := Copy(BaseDate, 5, 2); // month
    Element[2] := Copy(BaseDate, 7, 2); // day
    case GlobDateFmt of
      0: Result := Element[1] + DateSeparator + Element[2] + DateSeparator + Element[0];
      2: Result := Element[0] + DateSeparator + Element[1] + DateSeparator + Element[2];
      else  Result := Element[2] + DateSeparator + Element[1] + DateSeparator + Element[0];
    end;
  end;

begin
  LineList.DesignColumns[0].Items.Add(Id.StockCode);
  LineList.DesignColumns[1].Items.Add(Id.Desc);
  LineList.DesignColumns[2].Items.Add(FormattedDate(Id.PDate));
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.CheckCanApply;
begin
  ApplyBtn.Enabled := FHasTransaction;
  NewDateTxt.Enabled := UseManualDateChk.Checked;
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.ClearStatus;
begin
  StatusPnl.Caption := '';
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.FindBtnClick(Sender: TObject);
begin
  FindTransaction;
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.FormCreate(Sender: TObject);
begin
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.OkCP1BtnClick(Sender: TObject);
begin
  UpdateTransactionLines;
  Close;
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.ShowStatus(Msg: string; AsError: Boolean);
begin
  if AsError then
    StatusPnl.Font.Color := clRed
  else
    StatusPnl.Font.Color := clWindowText;
  StatusPnl.Caption := Msg;
end;

// -----------------------------------------------------------------------------

function TSetTransLineDateFrm.FindTransaction: Boolean;
const
  InvKeyPath = InvOurRefK;
var
  InvKey: Str255;
  ErrorMsg: string;
begin
  Result   := True;
  HasTransaction := False;
  ErrorMsg := '';
  NewDateTxt.Clear;
  // Search for the Transaction, and report an error if it cannot be found
  InvKey := TransactionTxt.Text;
  Status := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvKeypath, InvKey);
  if StatusOk then
  begin
    // Found a Transaction
    HasTransaction := True;
    if UseTransactionDateChk.Checked then
      NewDateTxt.DateValue := Inv.TransDate;
    // Display the Transaction Lines
    ShowLines;
    CheckCanApply;
    if NewDateTxt.CanFocus then
      NewDateTxt.SetFocus
    else if ApplyBtn.CanFocus then
      ApplyBtn.SetFocus;
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

procedure TSetTransLineDateFrm.TransactionTxtChange(Sender: TObject);
begin
  HasTransaction := False;
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.TransactionTxtKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  ClearStatus;
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.UpdateTransactionLines;
const
  IdKeyPath = IdFolioK;
var
  IdKey: string[255];
  Status: LongInt;
  LineCount: Integer;
begin
  IdKey := FullNomKey(Inv.FolioNum);
  LineCount := 0;
  Status := Find_Rec(B_GetGEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdKeyPath, IdKey);
  while (Status = 0) and (Id.FolioRef = Inv.FolioNum) do
  begin
    // Update the line and save it
    Id.PDate := NewDateTxt.DateValue;
    Status := Put_Rec(F[IdetailF], IdetailF, Id, IdKeyPath);
    if Status = 0 then
    begin
      FLinesFixed := FLinesFixed + 1;
      LineCount := LineCount + 1;
      // Find the next line
      Status := Find_Rec(B_GetNext, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdKeyPath, IdKey)
    end
    else
      ShowStatus('Failed to store Transaction Line, error ' + IntToStr(Status), True);
  end;
  Write_FixMsgFmt(Inv.OurRef + ': Changed ' + IntToStr(LineCount) + ' line dates to ' + POutDate(NewDateTxt.DateValue), 3);
  ShowLines;
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.ApplyBtnClick(Sender: TObject);
begin
  UpdateTransactionLines;
  TransactionTxt.SetFocus;
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.ShowLines;
const
  IdKeyPath = IdFolioK;
var
  IdKey: Str255;
begin
  LineList.ClearItems;
  // Search for Transaction Lines, and store the relevant details of each one
  IdKey := FullNomKey(Inv.FolioNum) + FullNomKey(-MaxInt - 1);
  Status := Find_Rec(B_GetGEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdKeyPath, IdKey);
  while (Status = 0) and (Id.FolioRef = Inv.FolioNum) do
  begin
    // Store the details
    AddLine(Id);
    // Find the next line
    Status := Find_Rec(B_GetNext, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdKeyPath, IdKey);
  end;
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.ClsCP1BtnClick(Sender: TObject);
begin
  Close;
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.SetHasTransaction(Value: Boolean);
begin
  FHasTransaction := Value;
  CheckCanApply;
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.ReloadTransactionDateBtnClick(
  Sender: TObject);
begin
  if HasTransaction then
    NewDateTxt.DateValue := Inv.TransDate;
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.NewDateTxtChange(Sender: TObject);
begin
  CheckCanApply;
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.UseTransactionDateChkClick(Sender: TObject);
begin
  if HasTransaction then
  begin
    NewDateTxt.DateValue := Inv.TransDate;
    NewDateTxt.Enabled   := False;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.UseManualDateChkClick(Sender: TObject);
begin
  NewDateTxt.Clear;
  NewDateTxt.Enabled := True;
  NewDateTxt.SetFocus;
end;

// -----------------------------------------------------------------------------

procedure TSetTransLineDateFrm.FormActivate(Sender: TObject);
begin
  FLinesFixed := 0;
  NewDateTxt.Clear;
  HasTransaction := False;
end;

end.
