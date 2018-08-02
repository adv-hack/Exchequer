
  TBankIreFileHeaderRec1 = Record
      LabelID     : Array[1..3] of Char;    {'HDR'} //For the EOF Record 1, this should be 'EOF'
      LabelNo     : Char;                   {'1'}
      FileID1     : Char;                   {'A'}
      FileID2     : Array[1..6] of Char;    {Authorised ID No - as OwnerID in VolHeaderRec}
      FileID3     : Char;                   {'S'}
      FileID4     : Array[1..9] of Char;    {Spaces}

      SetId       : Array[1..6] of Char;  {VolID from Volume Header}
      FileSect    : Array[1..4] of Char;  {0001}
      FileSeq     : Array[1..4] of Char;  {0001}
      Filler3     : Array[1..6] of Char;  {spaces}
      CrDate      : Array[1..6] of Char;  {bYYDDD}
      ExpDate     : Array[1..6] of Char;  {bYYDDD}
      BlockCount  : Array[1..7] of Char;  {Zeros}
      Filler5     : Array[1..20] of Char; {Spaces}
  end;  {80 bytes}

  TBankIreFileHeaderRec2 = Record
      LabelID     : Array[1..3] of Char;    {'HDR'} //For the EOF Record 2, this should be 'EOF'
      LabelNo     : Char;                   {'2'}
      RecFormat   : Char;                   {'F'}
      BlockLen    : Array[1..5] of Char;    {5 numeric chars - make it zeros}
      RecLen      : Array[1..5] of Char;    {00100}

      Reserved    : Array[1..35] of Char;   {Any valid chars  - make it spaces}
      Offset      : Array[1..2] of Char;    {00}
      Reserved2   : Array[1..28] of Char;  {spaces}
  end;  {80 bytes}

  TBankIreUserHeaderRec = Record
      LabelID     : Array[1..3] of Char;  {'UHL'}
      LabelNo     : Char;                 {'1'}
      ProcDate    : Array[1..6] of Char;  {bYYDDD}
      ReceiverID  : Array[1..6] of Char; {'999999'}
      Filler1     : Array[1..4] of Char; {spaces}
      Currency    : Array[1..2] of Char; {'00'}
      ZFiller2    : Array[1..6] of Char; {zeros}
      WorkCode    : Array[1..9] of Char; {'1 DAILY  '}
      FileNumber  : Array[1..3] of Char; {right justified, padded with '0' = rj0}
      Filler2     : Array[1..40] of Char; {spaces}
  end; {80 bytes}



