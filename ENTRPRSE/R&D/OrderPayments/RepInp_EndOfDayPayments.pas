unit RepInp_EndOfDayPayments;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, Repinp1u, StdCtrls, TEditVal,
  SBSPanel, Mask, Animate, bkgroup, ExtCtrls;

Type
  TfrmRepInpEndOfDayPayments = class(TRepInpMsg)
    edtAccountCode: Text8Pt;
    lblAccountRange: Label8;
    lblAccountTo: Label8;
    edtDateFrom: TEditDate;
    Label81: Label8;
    edtDateTo: TEditDate;
    Label82: Label8;
    Label83: Label8;
    cbSortOrder: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure edtAccountCodeExit(Sender: TObject);
  private
  public
    {Public declarations }
    Constructor Create (AOwner : TComponent); Override;
  end;

  //------------------------------

Procedure RunEndOfDayPaymentsReport (Const AOwner : TComponent);


Implementation

Uses
  ETStrU,
  GlobVar,
  InvListU,             // Popup Customer List
  ExThrd2U,             // Thread Controller
  oCreditCardGateway,   // Credit Card Interface
  Rep_EndOfDayPayments;

{$R *.DFM}

//=========================================================================

Procedure RunEndOfDayPaymentsReport (Const AOwner : TComponent);
Begin // RunAccountReport
  TfrmRepInpEndOfDayPayments.Create(AOwner);
End; // RunAccountReport

//=========================================================================

Constructor TfrmRepInpEndOfDayPayments.Create (AOwner : TComponent);
Var
  sFormName : ShortString;
  I : Integer;

  //------------------------------

  Procedure AddIndex (Const Index : EndOfDayPaymentsReportIndexEnum);
  Var
    LI : LongInt;
  Begin // AddIndex
    LI := Ord(Index);
    cbSortOrder.Items.AddObject (EndOfDayPaymentsReportIndexDescriptions[Index], TObject(LI));
  End; // AddIndex

  //------------------------------

Begin // Create
  Inherited Create (AOwner);

  ClientHeight := 130;
  ClientWidth := 328;

  // Load sort options
  cbSortOrder.Clear;
  AddIndex (idxReceiptOurRef);
  AddIndex (idxOrderOurRef);
  AddIndex (idxAccount);
  AddIndex (idxTransDate);
  AddIndex (idxReceiptType);
  If CreditCardPaymentGateway.ccpgCompanyEnabled Then
    AddIndex (idxCreditCardAuthNo);
  cbSortOrder.ItemIndex := 0;

  // Hide frame from ancestor
  SBSPanel4.Visible := False;

  // Load any remembered values from previous instances of this form for this report type
  SetLastValues;
End; // Create

//------------------------------

procedure TfrmRepInpEndOfDayPayments.FormCreate(Sender: TObject);
begin
  inherited;

  // Do not use - this has been replaced by the overridden Constructor
end;

//-------------------------------------------------------------------------

procedure TfrmRepInpEndOfDayPayments.OkCP1BtnClick(Sender: TObject);
Var
  oReport : pEndOfDayPaymentsReport;
  RepMode : Byte;
begin
  // Check it is the OK button - the Cancel button also comes in here - not my idea, talk to Eduardo!
  If (Sender=OkCP1Btn) then
  Begin
    // Force validation of all fields
    If AutoExitValidation Then
    Begin
      OKCP1Btn.Enabled := False;

      // Create the report and populate the parameters
      oReport := CreateEndOfDayPaymentsReport (Owner);

      oReport.AccountCode := edtAccountCode.Text;
      oReport.StartDate := edtDateFrom.DateValue;
      oReport.EndDate := edtDateTo.DateValue;
      oReport.SortOrder := EndOfDayPaymentsReportIndexEnum(cbSortOrder.Items.Objects[cbSortOrder.ItemIndex]);

      // Add report into thread controller
      If Create_BackThread And oReport.Start Then
        BackThread.AddTask(oReport, oReport.ThTitle)
      Else
      Begin
        Set_BackThreadFlip (False);
        Dispose(oReport, Destroy);
      End; // Else

      // Closes form, remembers last values, etc...
      Inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    // Close button - closes form, remembers last values, etc...
    Inherited;
end;

//-------------------------------------------------------------------------

procedure TfrmRepInpEndOfDayPayments.edtAccountCodeExit(Sender: TObject);
Var
  FoundCode  :  Str20;
  FoundOk, AltMod     :  Boolean;
begin
  Inherited;

  If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      FoundCode:=Name;

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If (AltMod) and (ActiveControl<>ClsCP1Btn)  and (FoundCode<>'') then
      Begin
        StillEdit:=BOn;

        FoundOk:=(GetCust(Application.MainForm,FoundCode,FoundCode, True{IsCust}, 0));

        If (FoundOk) then
        Begin
          StillEdit:=BOff;
          Text:=FoundCode;
        end
        else
        Begin
          SetFocus;
        end; {If not found..}
      end;
    end; {with..}
end;

//=========================================================================

end.

