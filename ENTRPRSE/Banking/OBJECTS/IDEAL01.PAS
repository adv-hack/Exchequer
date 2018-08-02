unit Ideal01;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

const
  DefaultIdealIniFile = 'Ideal.ini';

type

  TIdealControlRec = Record
    ValDate        : Array[1..6] of Char;  {YYMMDD}
    Filler1        : Array[1..45] of Char; {spaces}
    BankNo         : Array[1..4] of Char;  {'7171'???}
    BranchNo       : Array[1..3] of Char;  {rj0}
    BankAcc        : Array[1..11] of Char; {left justified, trailing spaces}
    Filler2        : Array[1..2] of Char;  {spaces}
    UserName       : Array[1..20] of Char;
    SeqNo          : Array[1..5] of Char; {'00001' to '99999'. unique to valdate}
    UserID         : Array[1..8] of Char; {ID for logging onto IDEAL. Letters should be caps}
    Filler3        : Array[1..9] of Char; {spaces}
    RecType        : Char;                {'0'}
  end;

  TIdealAdviceRec = Record
    RecBankNo      : Array[1..4] of Char;
    RecBranchNo    : Array[1..3] of Char;  {rj0}
    RecAccNo       : Array[1..11] of Char; {left justified, trailing spaces}
    RecAccName     : Array[1..20] of Char;
    TranCode       : Array[1..2] of Char;  {see below for values}
    Amount         : Array[1..11] of Char; {rj0}
    Filler         : Array[1..38] of Char; {spaces}
    Particulars    : Array[1..12] of Char; {see below for notes}
    Reference      : Array[1..12] of Char; { "    "    "    "  }
    RecType        : Char;                 {'1'}
  end;

  TIdealSummaryRec = Record
    CountCr        : Array[1..8] of Char;  {count of Credit transactions. rj0}
    TotalCr        : Array[1..11] of Char; {total      "          "       rj0}
    Filler1        : Array[1..5] of Char;  {spaces}
    CountDr        : Array[1..8] of Char;  {count of Debit transactions. rj0}
    TotalDr        : Array[1..11] of Char; {total      "         "       rj0}
    Filler2        : Array[1..26] of Char; {spaces}
    HashTotal      : Array[1..11] of Char; {eeeek!}
    Filler3        : Array[1..33] of Char; {spaces}
    RecType        : Char;                 {'9'}
  end;

{Notes.

  1.  All records have a CR/LF after them except for the final record in a file.

  2.  Possible values for TIdealAdviceRec.TranCode:

        20 = Sundry Credit
        21 = Standing Instruction Credit
        22 = Salary Credit
        23 = Dividend Credit
        24 = Inward Remittance Credit
        25 = Bill Proceeds Credit

        30 = Direct Debit

  3.  TIdealAdviceRec.Particulars:

        "Where TranCode = 30, a standard 3-character code to represent your organisation
        should be inserted in positions 90 to 92" - i.e. Particulars[1..3]

  4.  Deriving the Hash Total:

       1. HT = 0

       2. For each transaction take the receiving a/c no and the originating a/c no
            (treat trailing spaces as zeros)

       3. Split each a/c no into 6 digits & 5 digits

       4. For each a/c no subtract the 5 digit no from the 6 digit no
             giving you A as the result of the Rec a/c and B as the result
               of the Originating a/c

       5. C = Abs(A-B)

       6. Repeat 2..5 for each transaction and add C to HT.  Right-justify HT with
          leading zeros.

}




implementation

end.
