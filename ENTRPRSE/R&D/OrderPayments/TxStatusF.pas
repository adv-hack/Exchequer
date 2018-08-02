unit TxStatusF;

{
This form is used to poll the Exchequer Payments Portal for:
1) The current transaction status
   This enables us to display the status so that the user knows when to close this form.
2) The Payments Portal status
   This allows us to see if the portal is running or not, so that we can enable
   the close button appropriately.
3) The Token status when making an Authorisation Only request.

To keep the request load on the Portal down, the poll-rate is once every 3 seconds.
To change this, adjust the constant, PollInterval - not the Interval property of the timer.
}

// PKR. 10/02/2015. ABSEXCH-16014.  Redesigned form to remove debug information
//  and make it more user-friendly.
// This also fixes ABSEXCH-16147.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  oCreditCardGateway, ExchequerPaymentGateway_TLB,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, AdvProgressBar;

const
  TransactionPollInterval = 2000;
  TransactionTimeoutInterval = 2 * 60 * 1000; // minutes * seconds * milliseconds

  // Note. Although these constants have the prefix "TOKEN_STATUS_", they are also used for
  // Transaction Status as these values have now been aligned in the portal.
  TOKEN_STATUS_NOT_SET        = -1;
  TOKEN_STATUS_PENDING        =  0;
  TOKEN_STATUS_SUCCESS        =  1;
  TOKEN_STATUS_NOT_AUTHORISED =  2;
  TOKEN_STATUS_ABORT          =  3;
  TOKEN_STATUS_REJECTED       =  4;
  TOKEN_STATUS_AUTHENTICATED  =  5;
  TOKEN_STATUS_REGISTERED     =  6;
  TOKEN_STATUS_ERROR          =  7;

  HeightNormal  = 152; // was 174
  HeightAlert   = 320;

type
  TccTxStatusForm = class(TForm)
    Label1: TLabel;
    richStatusLog: TRichEdit;
    btnClose: TButton;
    txStatusPollTimer: TTimer;
    lblTransID: TLabel;
    TransactionTimeoutTimer: TTimer;
    Label2: TLabel;
    lblTransactionStatus: TLabel;
    lblOurRef: TLabel;
    AdvProgressBar: TAdvProgressBar;
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure txStatusPollTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TransactionTimeoutTimerTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    fCCGateway              : TPaymentGateway;
    fIsCheckingStatus       : Boolean;
    fTransVendorTx          : Widestring;
    previousServiceResponse : Widestring;
    fResponse               : IPaymentGatewayResponse;

    fTransStatus            : integer;
    fPreviousStatus         : integer;

    fOurRef                 : string;

    wasClosedManually       : boolean;

    procedure AppendMessage(aMessage : string);
  protected
    //PR: 03/03/2015 ABSEXCH-16138
    {$IFDEF COMTK}
    procedure WMDestroy(Var Message  :  TMessage); Message WM_DESTROY;
    {$ENDIF}

  public
    { Public declarations }
    procedure SetPaymentGateway(aGateway : TPaymentGateway);
    procedure SetTransactionID(Value : Widestring);
    procedure SetOurRef(Value : WideString);
    function GetTransactionResponse : PaymentGatewayResponse;
    function GetTransactionStatus : integer;
  published
    property IsCheckingStatus : Boolean read fIsCheckingStatus;
  end;

implementation

uses
  TransCancelF;

{$R *.dfm}

procedure TccTxStatusForm.FormCreate(Sender: TObject);
var
  hSysMenu:HMENU;
begin
  hSysMenu:=GetSystemMenu(Self.Handle,False);
  if hSysMenu <> 0 then
  begin
    EnableMenuItem(hSysMenu, SC_CLOSE, MF_BYCOMMAND or MF_GRAYED);
  end;
  KeyPreview := True;

  wasClosedManually := false;

  Height := HeightNormal;
end;

//------------------------------------------------------------------------------
procedure TccTxStatusForm.FormShow(Sender: TObject);
begin
  previousServiceResponse := '';
  txStatusPollTimer.Interval := TransactionPollInterval;
  txStatusPollTimer.Enabled := (fTransVendorTx <> '');
  fIsCheckingStatus := true;
  fTransStatus := TOKEN_STATUS_NOT_SET;
  fPreviousStatus := TOKEN_STATUS_NOT_SET;

{$IFDEF PHIL_ONLY}
  btnClose.Enabled := true;
{$ENDIF}

  // PKR. ABSEXCH-16077. Add a timeout in case we don't hear back from the EPP.
  // Set the timeout interval
  TransactionTimeoutTimer.Interval := TransactionTimeoutInterval;

  // Start the timer if the polling timer is running.
  TransactionTimeoutTimer.Enabled := TxStatusPollTimer.Enabled;

  AdvProgressBar.Animated := true;
end;

//------------------------------------------------------------------------------
procedure TccTxStatusForm.btnCloseClick(Sender: TObject);
begin
  wasClosedManually := true;
  Close;
end;

//------------------------------------------------------------------------------
procedure TccTxStatusForm.txStatusPollTimerTimer(Sender: TObject);
begin
  if fCCGateway <> nil then
  begin
    fTransStatus := TOKEN_STATUS_NOT_SET;

    // Disable timer while querying portal to prevent re-entry of procedure
    txStatusPollTimer.Enabled := False;

    try
      // PKR. 21/07/2015. ABSEXCH-16683. Tokens are now obsolete.

      //----------------------------------------------------------------------
      // PAYMENT/REFUND REQUEST
      //----------------------------------------------------------------------
      fResponse := fCCGateway.GetTransactionStatus(fTransVendorTx);

      if (fResponse = nil) then
      begin
        lblTransactionStatus.Caption := 'No response from Payments Portal';
      end
      else
      begin
        // Get the current status
        fTransStatus := fResponse.GatewayStatusId;

        // If the error flag is set in the response, we need to make sure that the
        // actual status is error, too.
        if (fResponse.IsError) then
        begin
          fTransStatus := TOKEN_STATUS_ERROR;
        end;

        // Act on the status returned
        case fTransStatus of
          TOKEN_STATUS_PENDING: // 0
            begin
              lblTransactionStatus.Caption := 'Pending';
            end;
          TOKEN_STATUS_SUCCESS: // 1
            begin
              lblTransactionStatus.Caption := 'OK';
            end;
          TOKEN_STATUS_NOT_AUTHORISED: // 2
            begin
              lblTransactionStatus.Caption := 'NOT Authorised';
              {$IFNDEF COMTK}
              ShowMessage('The transaction was NOT Authorised');
              {$ENDIF}
            end;
          TOKEN_STATUS_ABORT: // 3
            begin
              lblTransactionStatus.Caption := 'Cancelled';
            end;
          TOKEN_STATUS_REJECTED: // 4
            begin
              lblTransactionStatus.Caption := 'Rejected';
              {$IFNDEF COMTK}
              ShowMessage('The transaction was Rejected');
              {$ENDIF}
            end;
          TOKEN_STATUS_AUTHENTICATED: // 5
            begin
              lblTransactionStatus.Caption := 'Authenticated';
            end;
          TOKEN_STATUS_REGISTERED: // 6
            begin
              lblTransactionStatus.Caption := 'Registered';
            end;
          TOKEN_STATUS_ERROR: // 7
            begin
              lblTransactionStatus.Caption := 'Error';
              {$IFNDEF COMTK}
              ShowMessage('There was an error processing this transaction');
              {$ENDIF}
            end;
          else
            begin
              lblTransactionStatus.Caption := 'Unexpected status ' + IntToStr(fTransStatus);
            end;
        end; // Case fTransStatus

        // If it's a terminating response, close the form.
        if (fTransStatus <> TOKEN_STATUS_PENDING) then
        begin
          WasClosedManually := false;
          Close;
        end
        else
        begin
          // Pending, so restart the timer
          self.fPreviousStatus := fTransStatus;
          txStatusPollTimer.Enabled := true;
        end;
      end; // fResponse <> nil

    except
      on E : Exception do
        begin
          lblTransactionStatus.Caption := E.Message;
        end;
    end;
  end
  else
  begin
    // Gateway is null, so we can't check the status
    richStatusLog.Lines.Add('The Exchequer Payments Portal is currently unavailable.  Please try again later.');
    richStatusLog.Lines.Add('');
    richStatusLog.Lines.Add('You may now close this window.');
    Height := heightAlert;

    // Stop the timers. Just to make sure we don't get any spurious after-events
    txStatusPollTimer.Enabled := false;
    TransactionTimeoutTimer.Enabled := false;

    fIsCheckingStatus := false;
  end;
end;

//------------------------------------------------------------------------------
procedure TccTxStatusForm.SetPaymentGateway(aGateway : TPaymentGateway);
begin
  fCCGateway := aGateway;
end;

//------------------------------------------------------------------------------
procedure TccTxStatusForm.SetTransactionID(Value : Widestring);
begin
  fTransVendorTx := Value;
end;

procedure TccTxStatusForm.SetOurRef(Value : WideString);
begin
  fOurRef := Value;
  lblOurRef.Caption := Value;
end;

//------------------------------------------------------------------------------
function TccTxStatusForm.GetTransactionResponse : PaymentGatewayResponse;
begin
  Result := fResponse;
end;

//------------------------------------------------------------------------------
function TccTxStatusForm.GetTransactionStatus : integer;
begin
  Result := fTransStatus;
end;

//------------------------------------------------------------------------------
procedure TccTxStatusForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  transCancel : TTransCancelForm;
  dlgRes      : integer;
begin
  // PKR. 17/02/2015. ABSEXCH-16077 & 16170. Much of this procedure was restructured
  //  to handle the use of the Cancel button..

  // We don't want the user to close this using the [X] button if the status is Pending
  if (fTransStatus = TOKEN_STATUS_PENDING) and
     (not wasClosedManually) then
  begin
    // Don't want the user to close this yet
    Action := caNone;
  end
  else
  begin
    txStatusPollTimer.Enabled := false;
    transactionTimeoutTimer.Enabled := false;
    AdvProgressBar.Animated := False;

    // Need to do this only if closed manually.
    if wasClosedManually then
    begin
      // Display a dialog advising what to do next and giving the option to
      // continue waiting
      transCancel := TTransCancelForm.Create(self);
      transCancel.Position := poOwnerFormCenter;
      dlgRes := transCancel.ShowModal;

      if dlgRes = mrOK then
      begin
        // User elected to cancel, so tell Exchequer that we cancelled
        fTransStatus := TOKEN_STATUS_ABORT;
        fIsCheckingStatus := false;

        // Inform the Portal of the cancellation
        fCCGateway.CancelTransaction(fTransVendorTx);

        // Dispose of the cancel option form
        transCancel.Close;
        transCancel.Free;

        // Allow this dialog to close. Use Hide because we need the dialog later for the response value.
        Action := caHide;
      end
      else
      begin
        // User elected to continue waiting
        // Re-start the poll timer
        txStatusPollTimer.Enabled := true;

        // Prevent the dialog from closing
        Action := caNone;
      end
    end
    else
    begin
      // Wasn't closed manually, so close normally
      {$IFNDEF COMTK}
      Action := caHide;
      {$ELSE}
      //PR: 19/02/2015 For the COM Toolkit, don't hide the form but hide the progress bar and
      //               change the caption so that it's clear it's finished.
      Action := caNone;
      AdvProgressBar.Visible := False;
      Label1.Caption := 'Processing Complete';
      {$ENDIF}
      fIsCheckingStatus := false;
    end;
  end;
end;

//------------------------------------------------------------------------------
// PKR. 27/01/2015. ABSEXCH-16077. Add timeout for no terminating response from
//  the EPP.
procedure TccTxStatusForm.TransactionTimeoutTimerTimer(Sender: TObject);
begin
  // We've hit the transaction timeout interval.

  // Stop this timer so we don't repeat the message
  TransactionTimeoutTimer.Enabled := false;

  RichStatusLog.Visible := true;
  Height := HeightAlert;

  AppendMessage('The transaction is taking longer than expected to complete.');
  AppendMessage('This could be because user input is required, or due to an error.');
  AppendMessage('You may continue waiting or cancel this transaction by clicking the Cancel button.');

  // Restart timer
  txStatusPollTimer.Enabled := True;

  // Enable the close button
  self.btnClose.Enabled := true;
  self.btnClose.Visible := true;
end;

//------------------------------------------------------------------------------
procedure TccTxStatusForm.AppendMessage(aMessage : string);
begin
  richStatusLog.Lines.Add(aMessage);

  // Scroll the box to the bottom so we can see the message
//  richStatusLog.SetFocus;
//  richStatusLog.SelStart := richStatusLog.GetTextLen;
//  richStatusLog.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TccTxStatusForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Prevent closure using Alt-F4
  if (Key = VK_F4) and (ssAlt in Shift) then
    Key:=0;
end;
//PR: 03/03/2015 ABSEXCH-16138 Need to stop the progress bar timer when the form is about to be destroyed,
//                             otherwise, the timer continues and raises an Invalid Window error because then
//                             canvas it wants to draw on has already been destroyed.
{$IFDEF COMTK}
procedure TccTxStatusForm.WMDestroy(var Message: TMessage);
begin
  AdvProgressBar.Animated := False;
  Application.ProcessMessages;
  inherited;
end;
{$ENDIF}

end.



