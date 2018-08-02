Unit DuffTill;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ MH 14/07/95: Added for Duff till/card detail report }

Interface

{Type
  CardType = String[10];}

Procedure StartDuffTillList;
Procedure AddToDuffList (Const aTillNo  : Byte;
                         Const aCardNo  : LongInt;
                         Const aCardABS : Longint;
                               aTillBal : Real;
                               aMajBal  : Real);
Function  GotDuffTills : Boolean;
Procedure StopDuffTillList;
Procedure ResetDuffTills;
{rocedure PrintDuffTills;}

Implementation


Uses GlobVar,
     VarConst,
     EtStrU,
     EtDateU,
     SysUtils,
     Dialogs;

{    ETools2,
     PrintU,
     PrnText;}


Var
  BuildingDuffTills, GotDuff : Boolean;               { Are we building the list }
  LogFile                    : Text;
  DLine                      : Byte;

{ Open log file and set flag to start building the list }
Procedure StartDuffTillList;
  Begin { StartDuffTillList }
    { Open log file }
    {$I-}

    GotDuff := False;
    DLine   := 0;

    try
      { Try to open Log file }
      Assign (LogFile, sDuffTillLogFile);
      Reset  (LogFile);

      If (IOResult <> 0) Then Begin
        { Failed to open for some reason }
        ReWrite (LogFile);
      End; { If }

      { Opened or Created ok - close }
      Close (LogFile);

      { Open for addition to end of file }
      Append (LogFile);
    except
      on E:Exception do showmessage('StartDuffTillList : ' + E.ClassName + ' - ' + E.Message);
    end;

    {$I+}

    { set flag to enable duff till processing }
    BuildingDuffTills := True;
  End;  { StartDuffTillList }


Procedure AddToDuffList (Const aTillNo  : Byte;
                         Const aCardNo  : LongInt;
                         Const aCardABS : Longint;
                               aTillBal : Real;
                               aMajBal  : Real);

  { Returns true if need a new page }
  Function NewPage : Boolean;
  Begin { NewPage }
    NewPage := (dLine > 59) Or (dLine = 0);
  End;  { NewPage }

Begin { AddToDuffList }
  { Check we are building the list for EOD }
  If BuildingDuffTills then Begin
    { Set flag to indicate their are items to print }

    try
      If (Not GotDuff) Then Begin
        GotDuff := True;

        { Write new page character }
        Write (LogFile, Chr (12));
      End; { If }

      { Write report header }
      If NewPage Then Begin
        { Print page header }
        Writeln(Logfile);
        Writeln(Logfile);
        Writeln(Logfile, ConstStr(' ', 5), 'Incorrect Till/Card Balance Report: ', LjVar(InvFullDate(Today),20));
        Writeln(Logfile);
        Writeln(Logfile);
        Writeln(Logfile, 'Till No   ABS No   Card No   Majority Balance   Till Balance ');
        Writeln(Logfile, ConstStr('=', 80));

        { Reset line count }
        DLine := 7;
      End; { If }

      { Increase the line count }
      Inc (DLine);

      { Print a line }
      Writeln (Logfile, IntToStr(aTillNo),
                        ConstStr(' ', 3),
                        IntToStr(aCardABS),
                        ConstStr(' ', 3),
                        IntToStr(aCardNo),
                        ConstStr(' ', 12),
                        Format('%10.2f',[aMajBal]),
                        ConstStr(' ', 7),
                        Format('%10.2f',[aTillBal]));
    except
      on E:Exception do showmessage('AddToDuffList : ' + E.ClassName + ' - ' + E.Message);
    end;{try}
  End; { If }
End;  { AddToDuffList }


{ Returns true if their are some duff till/cards waiting in the list }
Function GotDuffTills : Boolean;
Begin { GotDuffTills }
  GotDuffTills := GotDuff;
End;  { GotDuffTills }


{ Stop building duff list and release memory }
Procedure StopDuffTillList;
Begin { StopDuffTillList }
  BuildingDuffTills := False;

  { Finished updating - close file }
  {$I-}
  Close(LogFile);

  { Clear IO Error flag }
  If (IOResult = 0) then;
  {$I+}
End;  { StopDuffTillList }


{**********************************************************************}
{*                                                                    *}
{* Name:    ResetDuffTills                                            *}
{*                                                                    *}
{* Purpose: Clears the duff till/card details in the accumulative     *}
{*          log file.                                                 *}
{*                                                                    *}
{**********************************************************************}
Procedure ResetDuffTills;
{Var
  LogFile : Text;}
Begin { ResetDuffTills }
  { Set IO error trapping on }
  {$I-}

  { Try to create new Log file }
(*  Assign(LogFile, sDuffTillLogFile);
  ReWrite(LogFile);

  If (IOResult = 0) Then Begin
    { Write out a log file reset header }
    Writeln (LogFile, ConstStr ('=', 80));
    Writeln (LogFile);
    Writeln (LogFile, 'Invalid Till/Card List Reset: ', LjVar (InvFullDate (Today), 20));
    Writeln (LogFile);
    Writeln (LogFile, ConstStr ('=', 80));
    Writeln (LogFile, Chr (12));}

    { Created ok - close }
    Close(LogFile);
  End; { If }

  { Clear IO Error flag }
  If (IOResult = 0) then;*)

  { Set IO error trapping off }
  {$I+}
End;  { ResetDuffTills }


{**********************************************************************}
{*                                                                    *}
{* Name:    PrintDuffTills                                            *}
{*                                                                    *}
{* Purpose: Prints the duff till/card details in the accumulative     *}
{*          log file.                                                 *}
{*                                                                    *}
{**********************************************************************
Procedure PrintDuffTills;
Begin { PrintDuffTills }
{  (DuffTillLogFile);
End;  { PrintDuffTills }



Begin { DuffTill }
  BuildingDuffTills := False;
End.