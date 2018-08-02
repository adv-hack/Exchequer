Unit Club2Exp;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$I DEFOVR.Inc}


{$O+,F+}

Interface

  Procedure ExportClub2000;
  Procedure MarkCards;

Implementation


Uses {Crt, Dos, EWinSBS, ETPrompt, ComnU2, SysU1}
  GlobVar, VarConst, Club2000, ETMiscU, ETStrU, ETDateU, BtrvU2, CardProc, BTSupU1
  , NeilProc, Dialogs, Controls, MainF, ExWrap1U, Forms, Progress, Windows, APIUtil;

Const
  ExportFname = 'TILLTRAN.DAT';


{ Creates the Club2000 Export File }
Procedure ExportClub2000;
Const
  FNum    = CustF;
  KeyPath = CustEditK;
Var
  ExLocal : TdExLocal;
  ExportFile : File Of ClubLinkRecType;
  ExportRec  : ClubLinkRecType;
  KeyS       : Str255;
  B_Func     : Word;
  IO     : Integer;
  TStr       : shortString;    // changed so it wont crash accessing position 0
  Ok : boolean;
  iStatus : smallint;
  FrmProgress : TFrmProgress;

  { Returns True if the Export file exists }
  Function GotExportFile : Boolean;
  Var
    TestF  : Text;
    IO     : Integer;
    bResult : Boolean;
  Begin
    WL ('GotExportFile (' + Syss.MergePath + ExportFname + ')');
    WI (2);

    {$I-}
    Assign (TestF, Syss.MergePath + ExportFname);
    Reset  (TestF);

    IO := IOResult;
    bResult := (IO = 0);

    If bResult Then Close (TestF);
    {$I+}

    GotExportFile := bResult;

    WL ('Result: ' + BoolStr(bResult) + ', ' + Form_Int(IO,3));
    WI (-2);
  End;

  { returns lowest of 2 integers }
  Function Min (Int1, Int2 : Integer) : Integer;
  Begin
    If (Int1 < Int2) Then Min := Int1
    Else Min := Int2;
  End;

  Function NextExportNo : LongInt;
  Begin
    GetMultiSys (TRUE, GlobLocked);
    Inc (Syss.LastEventOut);
    PutMultiSys;
    NextExportNo := Syss.LastEventOut;
  End;

Begin { ExportClub2000 }
  screen.cursor := crHourglass;
  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,0);
  try
    FrmProgress := TFrmProgress.Create(application);
    FrmProgress.Caption := 'Exporting Cards...';
    FrmProgress.ProgressBar1.Max := Used_Recs(F[CustF], CustF);
    FrmProgress.Show;
    FrmProgress.Refresh;
    ExLocal.Create; {create local record instance}
    WL ('ExportClub2000');
    WI (2);

    {$I-}

    { Check it exists, if not create it }
    Assign (ExportFile, Syss.MergePath + ExportFname);
    If (Not GotExportFile) Then
      Begin
        Rewrite (ExportFile);
        IO := IOResult;
        If (IO = 0) Then Close (ExportFile);
        IO := IOResult;
      End { If }
    Else IO := 0;

    If (IO = 0) Then Begin
      { re-open as Read/Write }
      System.FileMode := 2;
      Reset (ExportFile);

      { Move to end of file }
      Seek  (ExportFile, FileSize(ExportFile));
      IO := IOResult;
    End; { If }

    If (IO = 0) Then Begin
      { process all cards }
      FrmProgress.lStatus.Caption := 'Updating Members Accounts';
      FrmProgress.lStatus.Refresh;

      { Get first card }
      KeyS := '';
      iStatus := Find_Rec(B_GetGEq,F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath,KeyS);

      While (iStatus = 0) And (IOResult = 0) Do Begin
        If (ExLocal.LCust.ChangeFlag=3) And (ExLocal.LCust.CSRecNo<>0) Then Begin
          GlobLocked := FALSE;
          Ok := GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyPath,Fnum,TRUE,GlobLocked);
          ExLocal.LGetRecAddr(CustF);

          If Ok And GlobLocked Then Begin
            { Record Locked }
            FrmProgress.lName.Caption := CardFullName(ExLocal.LCust, TRUE ,TRUE);
            FrmProgress.lName.Refresh;

            FillChar (ExportRec, SizeOf (ExportRec), ' ');
            With ExportRec Do Begin
              { Export Event Number }
              TStr := Form_Int(NextExportNo,0);
              Move (TStr[1], EventNo, Length(TStr));

              { Club Record Number }
              TStr := Form_Int(ExLocal.LCust.CSRecNo, 0);
              Move (TStr[1], RecordNo, Length(TStr));

              { Old Card Number }
              TStr := ExLocal.LCust.CustCode;
              Move (TStr[1], OldCardNo, Length(TStr));

              { New Card Number - Not Used }
              TStr := '000000';
              Move (TStr[1], NewCardNo, Length(TStr));

              If (ExLocal.LCust.Hold = 5) Then
                Suspend := 'Y'
              Else
                Suspend := 'N';

              { Name }
              TStr := ExLocal.LCust.Company;
              Move (TStr[1], Name, Min(Length(TStr), SizeOf (Name)));

              { Address }
              with ExLocal.LCust do begin
                TStr := Addr[1];
                Move(TStr[1], Address1, Min(Length(TStr), SizeOf (Address1)));
                TStr := Addr[2];
                Move(TStr[1], Address2, Min(Length(TStr), SizeOf (Address2)));
                TStr := Addr[3];
                Move(TStr[1], Address3, Min(Length(TStr), SizeOf (Address3)));
                TStr := Addr[4];
                Move(TStr[1], Address4, Min(Length(TStr), SizeOf (Address4)));
                TStr := Addr[5];
                Move(TStr[1], PostCode, Min(Length(TStr), SizeOf (PostCode)));
              end;{with}

              { Transaction Code }
              TStr := '12';
              Move (TStr[1], TransCode, Length(TStr));

              { Transaction Date }
              If (Strip('B', [' '], ExLocal.LCust.OrdDate) = '') Then ExLocal.LCust.OrdDate := Today;

              TStr := 'DD/MM/YYYY';
              Move (TStr[1], TransDate, Length(TStr));
              Move (ExLocal.LCust.OrdDate[1], TransDate[7], 4); { YYYY }
              Move (ExLocal.LCust.OrdDate[5], TransDate[4], 2); { MM }
              Move (ExLocal.LCust.OrdDate[7], TransDate[1], 2); { DD }

              { Amount }
              TStr := Form_Real (-1 * (ExLocal.LCust.CurrBalance - ExLocal.LCust.LastClubBal), 8, 2);
              Move (TStr[1], Amount, Length(TStr));

              { Balance }
              TStr := Form_Real(ExLocal.LCust.CurrBalance, 8,2);
              Move (TStr[1], Balance, Length(TStr));

              { Member Code }
              TStr := ExLocal.LCust.ClubNo; Move (TStr[1], MembCode, Min(Length(TStr), SizeOf (MembCode)));
            End; { With }

            Write (ExportFile, ExportRec);

            ExLocal.LCust.ChangeFlag:=0;
            ExLocal.LCust.LastClubBal := ExLocal.LCust.CurrBalance;

            iStatus:=Put_Rec(F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath);
            Report_BError(FNum, iStatus);

            B_Func:=B_GetGEq;
          End { If }
          Else
            B_Func:=B_GetNext;
        End { If }
        Else
          { Don't want to export this record - try next }
          B_Func:=B_GetNext;

        { Get next record }
        iStatus:=Find_Rec(B_Func,F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath,KeyS);

        {Update Progress Bar}
        FrmProgress.ProgressBar1.Position := FrmProgress.ProgressBar1.Position + 1;
      End; { While }


      { Close the export file }
      Close (ExportFile);

      { unmark the export flag }
      GlobLocked := TRUE;
      GetMultiSys(TRUE,GlobLocked);
      Syss.UpWrite := FALSE;
      PutMultiSys;

      { remove the progress window }
    End; { If }

    {$I+}

    WI(-2);
    FrmProgress.Close;
  finally
    FrmProgress.Release;
  end;{try}
  ExLocal.Destroy; {destroy local record instance}
  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,1);
  screen.cursor := crDefault;
End;{ ExportClub2000 }


{ Marks all cards for export }
Procedure MarkCards;
Const
  FNum    = CustF;
  KeyPath = CustCodeK;
Var
  KeyS              : Str255;
  NumRecs, RecNum   : Integer;
  iStatus : smallint;
  Ok : boolean;
  ExLocal : TdExLocal;
  FrmProgress : TFrmProgress;

  Procedure ParseName (TheName : String;Var FName, SName : String);
  Var
    I   : Integer;
  Begin
    FName := '';
    SName := '';
    TheName := Strip ('B', [#0, #32], TheName);

    If (Length(TheName) > 0) Then Begin
      For I := Length(TheName) DownTo 1 Do begin
        If (TheName[I] = ' ') Then Break;
      end;{for}

      { Get rid of any blanks }
      FName := Strip ('B', [#0, #32], Copy (TheName, 1, I));
      SName := Strip ('B', [#0, #32], Copy (TheName, I, Length(TheName)));
    End; { If }
  End;

Begin { MarkCards }
  screen.cursor := crHourglass;
  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,0);
  try
    FrmProgress := TFrmProgress.Create(application);

    FrmProgress.Caption := 'Marking Cards...';
    FrmProgress.lStatus.Caption := 'Marking Cards For Export';
    FrmProgress.Show;
    FrmProgress.Refresh;
    ExLocal.Create; {destroy local record instance}

    RecNum    := 1;
    FrmProgress.ProgressBar1.Position := 1;

    NumRecs   := Used_Recs(F[Fnum], Fnum);
    FrmProgress.ProgressBar1.Max := NumRecs;

    { Get first record }
    Blank(KeyS,SizeOf(KeyS));
    iStatus := Find_Rec (B_GetGEq, F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath,KeyS);
    ExLocal.LGetRecAddr(CustF);

    While iStatus = 0 do begin
      With ExLocal, LCust Do Begin
        { Update Key for this cust }
        KeyS := CustCode;

        { Check its a club record and it hasn't already been done }
        If (CSRecNo <> 0) Then Begin
          { lock record }
          Ok:=GetMultiRec(B_GetDirect,B_SingLock,KeyF,KeyPath,Fn,FALSE,GlobLocked);
          LGetRecAddr(CustF);

          If Ok Then Begin
            { Set customer name into progress }
            FrmProgress.lName.caption := CardFullName(LCust, TRUE, TRUE);
            FrmProgress.lName.Refresh;

            { Mark for Export }
            ChangeFlag:=3;

            iStatus := Put_Rec (F[Fn], Fn, LRecPtr[Fn]^, KeyPath);
            LGetRecAddr(CustF);
            Report_BError(Fn,iStatus);
          End; { If }
        End; { If }

        { Update progress }
        Inc (RecNum);

        { Set Record Number into progress }
        FrmProgress.ProgressBar1.Position := RecNum;

        { Get next record }
        iStatus := Find_Rec (B_GetGretr, F[Fnum], Fnum, LRecPtr[Fnum]^, Keypath, KeyS);
        LGetRecAddr(CustF);
      End; { With }
    end;{while}
    { Mark the export flag }
    GlobLocked:=TRUE;
    GetMultiSys(TRUE,GlobLocked);
    Syss.UpWrite := TRUE;
    PutMultiSys;

    ExLocal.Destroy; {destroy local record instance}
    MsgBox('All Cards Marked for Export.',mtInformation,[mbOK],mbOK,'Mark Cards');
    FrmProgress.Close;
  finally
    FrmProgress.Release;
  end;{try}
  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,1);
  screen.cursor := crDefault;
End;  { MarkCards }

End.
