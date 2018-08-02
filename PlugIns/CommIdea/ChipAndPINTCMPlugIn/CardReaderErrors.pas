unit CardReaderErrors;

interface

function ErrorString(ErrorNumber: ShortInt): string;

implementation

function ErrorString(ErrorNumber: ShortInt): string;
begin
  ErrorNumber := Abs(ErrorNumber);
  case ErrorNumber of
     0: Result := '';
     1: Result := 'Unspecified error';
     2: Result := 'Invalid transaction type';
     3: Result := 'Invalid card';
     4: Result := 'Card scheme not recognised';
     5: Result := 'Card scheme not accepted';
     6: Result := 'Invalid card number';
     7: Result := 'Invalid card number length';
     8: Result := 'Invalid check digit in card number';
     9: Result := 'Expired card';
    10: Result := 'Card not yet valid';
    11: Result := 'Invalid card service code';
    12: Result := 'File missing (contact Commidea)';
    13: Result := 'File permanently locked (contact Commidea)';
    14: Result := 'Out of memory (contact Commidea)';
    15: Result := 'Account number does not exist';
    16: Result := 'Purchase value exceeds card scheme ceiling limit';
    17: Result := 'Cashback value exceeds card scheme ceiling limit';
    18: Result := 'Transaction currency code is invalid';
    19: Result := 'Layaways are not allowed';
    20: Result := 'Layaway already stored on this card';
    21: Result := 'EFT system not configured';
    22: Result := 'Internal error, buffer too small';
    23: Result := 'Unknown comms device type';
    24: Result := 'Configuration file is invalid';
    25: Result := 'No valid accounts';
    26: Result := 'Invalid channel';
    27: Result := 'System error - module not loaded';
    28: Result := 'General transaction error';
    29: Result := 'Transaction store unavailable';
    30: Result := 'Unspecified error';
    31: Result := 'Transaction cancelled';
    32: Result := 'EFT library not available';
    33: Result := 'Field value out of range';
    34: Result := 'Modifier field missing or invalid';
    35: Result := 'Invalid Track 1 on card';
    36: Result := 'Invalid Track 3 on card';
    37: Result := 'Invalid or missing expiry date';
    38: Result := 'Invalid or missing issue number';
    39: Result := 'Invalid or missing start date';
    40: Result := 'Invalid or missing transaction value';
    41: Result := 'Invalid or missing cashback value';
    42: Result := 'Invalid or missing authorisation code';
    43: Result := 'Invalid or missing cheque account number';
    44: Result := 'Invalid or missing cheque sort code';
    45: Result := 'Invalid or missing cheque number';
    46: Result := 'Invalid or missing cheque type';
    47: Result := 'Invalid or missing EFT serial number';
    48: Result := 'Unexpected CPC data';
    49: Result := 'Transaction already confirmed or rejected';
    50: Result := 'Copy protection failure';
    51: Result := 'Post-confirm reversal not allowed';
    52: Result := 'Post-confirm transaction details not consistent with store';
    53: Result := 'Transaction already void';
    54: Result := 'Card on hot list';
    55: Result := 'Attempt to confirm a declined transaction';
    56: Result := 'Invalid CV2';
    57: Result := 'Invalid AVS';
    98: Result := 'POS routing not configured correctly for this POS';
    99: Result := 'Transaction cancelled';
  else
    Result := 'Unknown error';
  end;
end;

end.
