unit ChngComp;

{$I DEFOVR.INC}

interface

Uses Dialogs, Forms, Messages, SysUtils, Windows;

procedure ChangeCurrCompany(var Message: TMessage);

Procedure Local_MDICompMan (NotifyHandle : hWnd);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses GlobVar, VarConst, BtrvU2, BtSupU1, BtSupU2, PathUtil, EParentU,
     GlobType, VarFPosU, HelpSupU, DllInt,

     {$IFDEF MEMMAP}
       MemMap,
     {$ENDIF}

     {$IFDEF SY}
       Excep2U,
       SBSComp2,

       {$IFDEF SEC500}
         oMCMSec,
       {$ENDIF}
     {$ENDIF}

    {$IFDEF CU}
      Event1U,
      CustWinU,
      ExWrap1U,
    {$ENDIF}

    uSettings,

    {$IFDEF SOP}
      // MH 23/09/2014 Order Payments: Extended Customisation
      OrdPayCustomisation,
    {$ENDIF SOP}

    {$IFDEF EXSQL}
    SQLUtils,
    ADOConnect,
    {$ENDIF}

    // MH 02/09/2011 v6.8 - Added Internal Logging Subsystem
    EntLoggerClass,

    ExBtTh1U;

(* HM 01/03/99: Modified to dynamically load DLL as and when required
Procedure InitCompDll (NewApp : TApplication); External 'EntComp.Dll';
Procedure TermCompDll; External 'EntComp.Dll';
Procedure MDICompMan  (NotifyHandle : hWnd); External 'EntComp.Dll';
*)

Var
  _EntCompDLL  : THandle;
  _InitCompDll : Procedure (NewApp : TApplication);
  _TermCompDll : Procedure;
  _MDICompMan  : Procedure (NotifyHandle : hWnd);


Procedure TidyUp;
Begin { TidyUp }
  If (_EntCompDLL <> 0) Then Begin
    { Unload the DLL }
    FreeLibrary(_EntCompDLL);
  End; { If }

  _EntCompDLL  := 0;
  _InitCompDll := Nil;
  _MDICompMan  := Nil;
  _TermCompDll := Nil;
End; { TidyUp }


Procedure Local_MDICompMan (NotifyHandle : hWnd);
Const
  ResNames     : Array[0..3] of PChar = ('EntComp', 'InitCompDll', 'MDICompMan', 'TermCompDll');
Var
  DLLAddr      : TFarProc;
Begin { Local_MDICompMan }
  { Check to see if DLL is already loaded - if not then load it }
  If (_EntCompDLL = 0) Or (Not Assigned(_InitCompDll)) Or (Not Assigned(_MDICompMan)) Or (Not Assigned(_TermCompDll)) Then Begin
    { Initialise vars }
    TidyUp;

    { Load DLL }
    _EntCompDLL := LoadLibrary(ResNames[0]);

    Try
      If (_EntCompDLL > HInstance_Error) Then Begin
        { Get handle of InitCompDll }
        DLLAddr := GetProcAddress(_EntCompDLL, ResNames[1]);
        If Assigned(DLLAddr) Then Begin
          _InitCompDll := DLLAddr;

          { Get handle of MDICompMan }
          DLLAddr := GetProcAddress(_EntCompDLL, ResNames[2]);
          If Assigned(DLLAddr) Then Begin
            _MDICompMan := DLLAddr;

            { Get handle of TermCompDll }
            DLLAddr := GetProcAddress(_EntCompDLL, ResNames[3]);
            If Assigned(DLLAddr) Then Begin
              _TermCompDll := DLLAddr;
            End { If }
            Else Begin
              FreeLibrary(_EntCompDLL);
              _EntCompDLL  := 0;
              _InitCompDll := Nil;
              _MDICompMan  := Nil;
            End; { Else }
          End { If }
          Else Begin
            FreeLibrary(_EntCompDLL);
            _EntCompDLL := 0;
            _InitCompDll := Nil;
          End; { Else }
        End { If }
        Else Begin
          FreeLibrary(_EntCompDLL);
          _EntCompDLL := 0;
        End; { Else }
      End { If }
      Else
        _EntCompDLL := 0;
    Except
      FreeLibrary(_EntCompDLL);
      _EntCompDLL  := 0;
      _InitCompDll := Nil;
      _MDICompMan  := Nil;
      _TermCompDll := Nil;
    End; { Try }
  End; { If }

  { Check we have some handles to the dll }
  If Assigned (_InitCompDll) And Assigned (_TermCompDll) Then Begin
    { Initialise the DLL }
    _InitCompDll(Application);

    { Display the dialog }
    _MDICompMan  (NotifyHandle);

    { Cannot terminate now as dialog is still on display }
  End; { If }
End; { Local_MDICompMan }


{ Processes Change Company message }
procedure ChangeCurrCompany(var Message: TMessage);
Type
  {$H-}
  CompInfoType = Record
    CompPath   : Str100;
  End; { CompInfoType }
  {$H+}
Var
  CompInfo : CompInfoType;
  CPPtr    : ^CompInfoType;

  CurrPath : ShortString;
  CanClose : Boolean;
  I        : Integer;
  DumKey   : Str255;

  {$IFDEF CU}
    ExLocal  :  TdExLocal;

  {$ENDIF}

{$IFDEF SEC500}
  Locked   : Boolean;
  Res      : LongInt;
{$ENDIF}

  Procedure CheckCanClose(    PForm    :  TForm;
                          Var CanClose :  Boolean;
                              CloseWin :  Boolean);
  Var
    n, Compo  : Integer;
    Done      : Boolean;
  Begin
    CanClose := True;
    Done     := False;

    With PForm do
      While (MDIChildCount > 0) And CanClose And (Not Done) Do Begin
        Compo := MDIChildCount;
        For n:=0 to Pred(MDIChildCount) do Begin
          { Call the childs CloseQuery event to see if the window can be closed }
          If (Assigned(MDIChildren[n].OnCloseQuery)) then Begin
            MDIChildren[n].OnCloseQuery(PForm,CanClose);

            { make sure it has time to do whatever it wants to do! }
            Application.ProcessMessages;
          End; { If }

          If CanClose And CloseWin Then Begin
            { Close the window }
            MDIChildren[n].Close;

            { Give the window time to close }
            Application.ProcessMessages;
          End; { If }

          { Start loop again if number of child windows has changed }
          { Break out if a window cannot be closed }
          If (Compo <> MDIChildCount) Or (Not CanClose) Then Break;

          { Exit after processing the last child }
          Done := (n = Pred(MDIChildCount));
        End; { For }
      End; { While }

          (*
          If (Components[n] is TForm) then
            With TForm(Components[n]) do Begin
              If (Assigned(OnCloseQuery)) then
                OnCloseQuery(Sender,CanClose);

              If (Not CanClose) then Begin
                If (UseShow) then
                  Show;

                Break;
              End; { If }
            End; { With }
            *)
  End; { CheckCanClose }

Begin
  With Message Do
  Begin

    CPPtr:=Pointer(LParam);

    CompInfo := CPPtr^;

    { Calculate path of current data }
    If (Trim(SetDrive) = '') Then
      { No SetDrive so data is in EXE Directory }
      CurrPath := PathToShort(ExtractFilePath(Application.ExeName))
    Else
      { Using SetDrive to redirect }
      CurrPath := PathToShort(SetDrive);

    If Not (Copy(CurrPath, Length(CurrPath), 1)[1] In ['\', ':']) Then
      CurrPath := CurrPath + '\';

    { Check they have selected a different company }
    {If (UpperCase(CurrPath) <> UpperCase(CompInfo^.CompPath)) Then}
    Begin
      {* EL : Do not Check to see if the company can be closed down: check printing and threads }
      CheckCanClose(MainForm, CanClose, False);

      If CanClose Then
      Begin
        Application.ProcessMessages;

        { Close all windows }
        CheckCanClose(MainForm, CanClose, True);

        Application.ProcessMessages;

        If CanClose Then
        Begin
          {*EN560 Issue notification event about to change co*}
          {$IFDEF CU}
            ExLocal.Create;

            ExecuteCustBtn(MiscBase+2,08,ExLocal);
          {$ENDIF}

          {$IFDEF SOP}
            // MH 23/09/2014 Order Payments: Extended Customisation
            ResetOrderPaymentsCustomisationTransactionTracker;
          {$ENDIF SOP}

          // MH 02/09/2011 v6.8 - Stop Internal Logging Subsystem
          StopLogging;

          {$IFDEF EXSQL}
          If SQLUtils.UsingSQL Then
            TerminateGlobalADOConnection;
          {$ENDIF}

          { Reduce user count in company }
          {$IFNDEF SEC500}
            If (GotUserLic) then
              GotUserLic:=Update_Users(-1,BOff);
          {$ELSE}
            // v5.00 Security
            With TMCMSecurity.Create (ssEnterprise, SyssMod^.ModuleRel.CompanyID) Do
              Try
                // MH 08/02/06: Added locking mechanism to try and eliminate the (alleged) User
                // Count Corruption, if we can't get a lock before the 30 second timeout then
                // its better to leave the user counts alone than risk causing UCC by going ahead,
                // LockControlRec should write a log reporting the fault
                If LockControlRec Then
                Begin
                  Try
                    // Get and Lock SysR
                    Locked := BOn;
                    If GetMultiSys(BOn, Locked, SysR) And Locked Then Begin
                      Res := RemoveLoginRefEx;
                      If (Res = 0) Then
                        // Only change the User Count if the MCM bit worked - better chance of
                        // keeping the system consistent if either fails
                        If (Syss.EntULogCount > 0) Then Dec (Syss.EntULogCount);

                      // Always do update - as need to unlock record
                      PutMultiSys(SysR, BOn);
                    End { If (Res = 0) }
                    Else
                      Res := 32767;

                    If (Res <> 0) Then Begin
                      // Error - Write a log and inform the user
                      AddErrorLog('Error Updating User Count',
                                  'An error ' + IntToStr(Res) + ' occurred decrementing the Logged-In User Count',
                                  0);         // System generated error
                      MessageDlg ('An error ' + IntToStr(Res) + ' occurred decrementing the Logged-In User Count, ' +
                                  'Please contact your Technical Support', mtError, [mbOk], 0);

                      // Close Enterprise
                      GotPassword := False;
                    End; { Else }
                  Finally
                    UnlockControlRec;
                  End; // Try..Finally
                End; // If LockControlRec
              Finally
                Free;
              End;
          {$ENDIF}

          { Check we have some handles to the dll }
          If Assigned (_TermCompDll) Then
          Begin
            { Shut down company DLL }
            _TermCompDll;
          End; { If }

          { Close data files }
          {For I := 1 To TotFiles Do  Repalced with Close_Files in v4.31 in case new GPF caused by it.
            Close_File(F[I]);}

          Close_Files(BOn);

          // MH 29/10/2010 v6.5 ABSEXCH-1041????: Free the Window Positions object if assigned otherwise it loses
          // track of whether the file is opened and you start getting error 3's
          FreeSettings;

          { Close all global thread controlled files }

          Destroy_ThreadFiles;

          {$IFDEF Frm}
            { Shut down forms dll }
            sbsForm_DeInitialise;
          {$ENDIF}

          {$IFDEF SY}  {* Reset user entry log *}
            {$IFDEF MEMMAP}
              If Assigned(GlobalEntMap) Then GlobalEntMap.UserName := '';
            {$ENDIF}

            Reset_EntLogOn;
          {$ENDIF}

          { Blank all file records }
          For I := 1 To TotFiles Do
            ResetRec(I);
          CId^:=Id;
          CInv^:=Inv;
          CStock^:=Stock;

          { Reset file definitions }
          VarConst_Init;

          { Change SetDrive to point to new data }
          SetDrive := CompInfo.CompPath;

          RemDirOn := BOn;   { Should be on anyway - but just in case }

          {$IFDEF MEMMAP}
            If Assigned(GlobalEntMap) Then GlobalEntMap.CompanyDataPath := SetDrive;
          {$ENDIF}

          {$IFDEF SY}

            {Destroy any previous on screen defaults, and re-create a new object (v4.32)}
            If (Assigned(LastValueObj)) then
            Begin
              Try
                LastValueObj.Free; {Destroy old copy}

                LastValueObj:=TLastValue.Create; {Create fresh copy}

              except
                LastValueObj.Free;
                LastValueObj:=nil;
              end; {Try..}
            end;
          {$ENDIF}

          {Destroy all lookup lists}
          BtSupU2_Destroy;

          {$IFDEF EXSQL}
          SQLUtils.OpenCompany(SetDrive);
          {$ENDIF}

          { open new data files }
          Open_System (1, TotFiles);

          For I := 1 To TotFiles Do
          Begin
            Status := Find_Rec(B_GetFirst,F[I],I,RecPtr[I]^,0,DumKey);

            If (Debug) And (Status <> 9) Then
              Report_BError(I,Status);
          End; { For }

          // MH 09/06/2009: Extended to support SortViews and Advanced Discounts
          //PR: 23/03/2012 Extended to include QtyBreaks table. v6.10
          //PR: 27/06/2012 Extended to include CurrencyHistory (ABSEXCH-12956) and GLBudgetHistory (ABSEXCH-12957). v7.0
          For I := 22 To 28 Do
          Begin
            // MH 27/10/2010: Skip MultiBuy for Non-SOP systems
            If (I <> 24) {$IFNDEF SOP}And (I <> 25){$ENDIF} Then
            Begin
              // 22 SortView, 23 SVUsrDef, 25 MultiBuy
              Open_System (I, I);

              Status := Find_Rec(B_GetFirst,F[I],I,RecPtr[I]^,0,DumKey);

              If (Debug) And (Status <> 9) Then
                Report_BError(I,Status);
            End; // If (I <> 24)
          End; { For }

          // MH 17/10/2014 ABSEXCH-13403: Force the Settings.Dat subsystem to look in the correct directory
          uSettings.sMiscDirLocation := SetDrive;

          {$IFDEF EXSQL}
          If SQLUtils.UsingSQL Then
            InitialiseGlobalADOConnection (SetDrive);
          {$ENDIF}

          { Re-Start company DLL }
          {InitCompDll (Application); HM 01/03/99: Changed to load dll as and when required }

          { reload syss records }
          BtSupU2_Init;

          // MH 02/09/2011 v6.8 - Restart Internal Logging Subsystem
          StartLogging(SetDrive);

          { Reset window caption }
          MainForm.SetCaption;

          {$IFDEF Frm}
            { Reload Forms DLL }
            SystemInfo.ExDataPath := SetDrive;
            sbsForm_Initialise(SystemInfo, Syss.TxLateCR);
          {$ENDIF}

          {$IFDEF SY}
            { force user to login to new company}
            GotPassWord:=BOff;
            GotSecurity:=BOff;
            SBSIn:=BOff;  {Reset system password effect v5.01}

            MainForm.Hide;

            StartLogIn;

            {* Reset module releases *} {v5.01, do not re-load logo, as otherwise you would get a memory leak
                                                since the timer on EParentU no longer checks for CheckedDiary, and so does not unload ENTSMx.dll.
                                                In theory you could alter message 130 in EparentU to enable the timer, and reset checked Diary so it did
                                                it all again. Perhaps once we have confiemd this was the cause of the AV}
            SendMessage(MainForm.Handle,WM_FormCloseMsg,120,(2*Ord(Screen.Width<800))+(5*Ord(Screen.Width>800)));

            //CS: Update DripFeed label for new company
            MainForm.Update_DripFeed;

            MainForm.Show;

            {*EN560 Issue notification event Co changed *}
            {$IFDEF CU}
              ExecuteCustBtn(MiscBase+2,09,ExLocal);
              ExLocal.Destroy;
            {$ENDIF}

            {* Reset all password settings *}

              PostMessage(MainForm.Handle,WM_FormCloseMsg,101,0);

            {* Check Diary *}
            {EN501AV1}

              {PostMessage(MainForm.Handle,WM_FormCloseMsg,130,0);}{Taken out v5.01 as suspected cause of AV}

            {MDI_ForceParentBKGnd(BOn);}
          {$ENDIF}
        End; { If }
      End; { If }
    End; { If }
  End; { With }

  { Unload the DLL }
  TidyUp;
End;


Initialization
  _EntCompDLL := 0; { To ensure it doesn't try to free a DLL that isn't loaded }
  TidyUp;
Finalization
  TidyUp;
end.
