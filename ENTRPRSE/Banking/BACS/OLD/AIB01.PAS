unit Aib01;
{Record definitions for Allied Irish Bank & Bank of Ireland EFT (BACS) transactions}

interface

uses
  ExpObj;

const
  Aib = 0;
  BankOfIreland = 1;

  DefaultEFTIniFile = 'Eft.ini'; {should be in enterprise dir or other shared dir}

  DefaultPayFileName = 'ExchEft.dat';
  DefaultRecFileName = 'ExchDDeb.dat';



type

  TAIBVolHeaderRec = Record
      LabelID     : Array[1..3] of Char;   {'VOL'}
      LabelNo     : Char;                  {'1'}
      VolID       : Array[1..6] of Char;   {Alpha/Numeric Unique to this volume}
   Case SmallInt of
    Aib : (
      Access      : Char;                  {Space means unlimited access}
      Reserved1   : Array[1..26] of Char;
      OwnerID01   : Array[1..4] of Char;   {Spaces}
      OwnerID02   : Array[1..6] of Char;   {Authorised ID No}
      OwnerID03   : Array[1..4] of Char;   {Spaces}
      Reserved2   : Array[1..20] of Char;
      NA1         : Char;                  {NA = not applicable}
      Reserved3   : Array[1..3] of Char;
      PhysLength  : Char; {space = 128, 1 = 256, 2 = 512, 3 = 1024}
      NA2         : Array[1..2] of Char;
      Reserved4   : Char;
      Version     : Char);  {'3' or '.'}

    BankOfIreland  : (
      Filler1     : Array[1..31] of Char; {space filled}
      OwnerID     : Array[1..6] of Char;  {Authorised ID No}
      Filler2     : Array[1..33] of Char); {space filled}

  end;  {80 bytes}

  TAIBFileHeaderRec = Record
      LabelID     : Array[1..3] of Char;    {'HDR'}
      LabelNo     : Char;                   {'1'}
      Reserved1   : Char;
      FileID1     : Char;                   {'A'}
      FileID2     : Array[1..6] of Char;    {Authorised ID No - as OwnerID in VolHeaderRec}
      FileID3     : Char;                   {'S'}
      FileID4     : Array[1..9] of Char;    {Spaces}
   Case SmallInt of
    Aib :  (
      NA1         : Array[1..17] of Char;
      RecFormat   : Char;                   {Space or 'F' means fixed-length format}
      NA2         : Array[1..5] of Char;
      SectionNo   : Array[1..2] of Char;    {Can be space filled}
      CreateDate  : Array[1..6] of Char;    {YYDDMM or DDMMYY or bYYDDD}
      NA3         : Array[1..13] of Char;
      ExpDate     : Array[1..6] of Char;    {Spaces or YYDDMM or DDMMYY or bYYDDD}
      VerifyCopy  : Char;                   {Space means that file has not been verified or copied}
      NA4         : Array[1..6] of Char;
      Delimiter   : Char);                   {'.'}

    BankOfIreland : (
      BlockLength : Array[1..5] of Char; {5 zeros}
      Filler1     : Char;                {space}
      BeginExt    : Array[1..5] of Char; {5 zeros}
      Filler2     : Char;                {space}
      EndExt      : Array[1..5] of Char; {5 zeros}
      RecFmt      : Char;                {space}
      Filler3     : Array[1..7] of Char; {spaces}
      CrDate      : Array[1..6] of Char; {YYDDMM or DDMMYY or bYYDDD}
      RecLength   : Array[1..4] of Char; {'0100' . If multiple process dates then '0106'}
      Filler4     : Array[1..5] of Char; {spaces}
      RecAttrib   : Char;                {Must be 'B'}
      Filler5     : Array[1..17] of Char);


  end;  {80 bytes}

  TAIBUserHeaderRec = Record
      LabelID     : Array[1..3] of Char;  {'UHL'}
      LabelNo     : Char;                 {'1'}
      ProcDate    : Array[1..6] of Char;  {bYYDDD}
   Case SmallInt of
    Aib  : (
      RecID       : Array[1..10] of Char; {currently all spaces}
      Currency    : Array[1..2] of Char; {'00' = IR£, '01' = Euro}
      Reserved1   : Array[1..6] of Char;
      WorkCode    : Array[1..9] of Char; {'1 DAILY  '}
      FileNo      : Array[1..3] of Char; {right justified, padded with '0' = rj0}
      Reserved2   : Array[1..14] of Char;
      UserDef     : Array[1..25] of Char;
      Delimiter   : Char);                 {'.'}

    BankOfIreland : (
      ZFiller1    : Array[1..4] of Char; {zeros}
      ReceiverID  : Array[1..2] of Char; {'90'}
      Filler1     : Array[1..4] of Char; {spaces}
      ZFiller2    : Array[1..8] of Char; {zeros}
      WrkCode     : Array[1..9] of Char; {'1 DAILY  '}
      FileNumber  : Array[1..3] of Char; {right justified, padded with '0' = rj0}
      Filler2     : Array[1..40] of Char); {spaces}

  end; {80 bytes}

  TAIBUserTrailerRec = Record
      LabelID     : Array[1..3] of Char; { 'UTL'}
      LabelNo     : Char;                {'1'}
      TotalDr     : Array[1..13] of Char; {Money total of debit items in pence - rj0}
      TotalCr     : Array[1..13] of Char; {Money total of credit items in pence - rj0}
      CountDr     : Array[1..7] of Char; {Number of debit items}
      CountCr     : Array[1..7] of Char; {Number of credit items}
   Case SmallInt of
     Aib  :  (
      Reserved    : Array[1..35] of Char; {spaces}
      Delimiter   : Char);                 {'.'}

     BankOfIreland : (
      Filler1     : Array[1..36] of Char); {spaces}
  end; {80 bytes}

  TAIBDataRec = Record
     DestSort    : Array[1..6] of Char; {branch to be credited}
     DestAcc     : Array[1..8] of Char; {acoount to be credited}
     AccType     :  Char; {must be zero}
     TranCode   : Array[1..2] of Char; {'99' for credits, '01','17','18','19' for debits}
     CompSort    : Array[1..6] of Char; {sort code of user's bank}
     CompAcc     : Array[1..8] of Char; {user's account no}
     Reserved1   : Array[1..4] of Char; {'0000'}
     AmountP     : Array[1..11] of Char; {rj0 + must be > 0}
     CompName    : Array[1..18] of Char; {Name of user's bank a/c}
     CompRef     : Array[1..18] of Char; {user ref}
     DestName    : Array[1..18] of Char; {Name of account to be credited}
  end;  {100 bytes}



implementation

end.
