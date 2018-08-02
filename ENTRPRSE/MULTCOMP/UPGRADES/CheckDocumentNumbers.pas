Unit CheckDocumentNumbers;

Interface

Uses Dialogs, SysUtils, StrUtils;

Procedure CheckNextDocumentNos (Const CompanyDir : ShortString);

Implementation

Uses GlobVar, VarConst, BtrvU2;

//=========================================================================

Procedure CheckNextDocumentNos (Const CompanyDir : ShortString);
Var
  KeyS : Str255;
  NextNumber, Res : LongInt;
  bDisplayWarning : Boolean;
  sText : ANSIString;

  //------------------------------

  Function IncludeInCheck (Const CountType : String) : Boolean;
  Begin // IncludeInCheck
    Result := (CountType <> DocNosXlate[ACQ]) And    // Automatic Cheque Number
              (CountType <> DocNosXlate[AFL]) And    // -ve Folio Number used by Orders, etc...
              (CountType <> DocNosXlate[FOL]) And    // Folio Number
              (CountType <> DocNosXlate[JBF]) And    // Job Folio
              (CountType <> 'QBF') And               // Qty Break Folio
              (CountType <> DocNosXlate[RUN]) And    // Posting Run Number
              (CountType <> DocNosXlate[SKF]);       // Stock Folio
  End; // IncludeInCheck

  //------------------------------

Begin // CheckNextDocumentNos
  SetDrive := CompanyDir;
  Open_System(IncF, IncF);
  Try
    bDisplayWarning := False;

    KeyS := '';
    Res := Find_Rec(B_GetFirst, F[IncF], IncF, RecPtr[IncF]^, 0, KeyS);
    While (Res = 0) And (Not bDisplayWarning) Do
    Begin
      // Check whether we want to process this one
      If IncludeInCheck (Count.CountTyp) Then
      Begin
        // Extract the number from the string (WTF!)
        Move(Count.NextCount[1], NextNumber, Sizeof(NextNumber));

        // Display warning if any transaction OurRef counter is over 2.5 million - this maps
        // onto xxxR00001 which gives them up to 800,000 ourref's before they hit the max limit
        If (NextNumber >= 2500000) Then
          bDisplayWarning := True;
      End; // If IncludeInCheck (Count.CountTyp)

      Res := Find_Rec(B_GetNext, F[IncF], IncF, RecPtr[IncF]^, 0, KeyS);
    End; // While (Res = 0) And (Not bDisplayWarning)

    If bDisplayWarning Then
    Begin
      sText := 'Exchequer has a limit of 3.3 million transactions per transaction type per company. ' +
               #13#13 +
               'Your system is approaching this limit and will require maintenance. Please contact your support team urgently for information and guidance.' +
               #13#13;
      sText := sText + '(Company Path: ' + CompanyDir + ')';
      MessageDlg (sText, mtWarning, [mbOK], 0);
    End; // If bDisplayWarning
  Finally
    Close_Files(True);
  End;
End; // CheckNextDocumentNos

//=========================================================================

End.
