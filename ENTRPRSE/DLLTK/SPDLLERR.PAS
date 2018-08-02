unit SpDllErr;

interface

const
  SP_FINALIZE_CALLED = 20000;

function SP_ERRORMESSAGE(Func : Integer; ErrCode : Integer) : ShortString;

implementation

function SP_ERRORMESSAGE(Func : Integer; ErrCode : Integer) : ShortString;
begin
  Case Func of
    1  : //Convert
        Case ErrCode of
          SP_FINALIZE_CALLED
                 : Result := 'Finalize has been called on this object. It can no longer be used.';
          30001  : Result := 'Error in one or more transactions. Check individual statuses.';
          30002  : Result := 'Invalid conversion';
          30003  : Result := 'No picked lines in transaction.';
          30004  : Result := 'Transaction record not found';
          30005  : Result := 'Unknown error in conversion';
          30006  : Result := 'Transactions to be consolidated must be of the same type';
          //PR: 04/11/2014 Order Payments error codes
          30007  : Result := 'Order Payment transactions with Written-Off lines must be dealt with individually';
          30008  : Result := 'Refund required because of written-off items. Cannot process this conversion.';

          //PR: 06/06/2017 ABSEXCH-18683 v2017 R1 Process locking
          30009  : Result := 'The transaction conversion process was locked by another program. Please try again.';
          32767  : Result := 'Record not initialised correctly.';
          32766  : Result := 'Incorrect record size';
        end;
    2  ://Back to back
        Case ErrCode of
          SP_FINALIZE_CALLED
                 : Result := 'Finalize has been called on this object. It can no longer be used.';
          30001  : Result := 'Unknown error';
          30002  : Result := 'Invalid default supplier';
          30004  : Result := 'Transaction record not found';
          32767  : Result := 'Record not initialised correctly.';
          32766  : Result := 'Incorrect record size';
        end;
  end;//Case;
end;

Initialization

end.
