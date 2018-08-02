unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows,
     CustWinU, CustAbsU;

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers01); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

Var
  bPlugInEnabled : Boolean = False;
  bPrintHookAlreadyEnabled : boolean;

implementation

Uses ChainU, IniIntf, SelDeptF, piSecure, piMisc, ExchequerRelease;

Const
  EventDisabled = 0;
  EventEnabled  = 1;


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers01);
Var
  slAboutText : TStringList;
  iPos        :  Byte;
Begin
  CustomOn := True;

  bPlugInEnabled := PICheckSecurity('EXCHPORSEC000009',
                                    'F2"8SF$^aS1!q^hq',
                                    PlugInName,
                                    '',
                                    stSystemOnly,
                                    ptDll,
                                    DLLChain.ModuleName);
  If bPlugInEnabled Then
    With CustomHandlers Do Begin
      { Set About Message }
      slAboutText := TStringList.Create;
      Try
        PIMakeAboutText (PlugInName, ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)', slAboutText);
        For iPos := 0 To Pred(slAboutText.Count) Do
          AddAboutString (slAboutText[IPos]);
      Finally
        FreeAndNIL (slAboutText);
      End;

      // Get current status of Hooks
      bPrintHookAlreadyEnabled := HookPointEnabled(wiTransaction, 151);

      { Enable Hooks }
      SetHandlerStatus (wiTransaction, 1,   eventEnabled);  // Transaction - Before Store Trans
      SetHandlerStatus (wiTransaction, 6,   eventEnabled);  // Transaction - Exit Account Code

      SetHandlerStatus (wiTransaction, 150, eventEnabled);  // Daybook - Edit button
      SetHandlerStatus (wiTransaction, 151, eventEnabled);  // Daybook - Print button
      SetHandlerStatus (wiTransaction, 152, eventEnabled);  // Daybook - Pick/Receive button
      SetHandlerStatus (wiTransaction, 153, eventEnabled);  // Daybook - Match button
      SetHandlerStatus (wiTransaction, 154, eventEnabled);  // Daybook - Tag button
      SetHandlerStatus (wiTransaction, 155, eventEnabled);  // Daybook - View button
      SetHandlerStatus (wiTransaction, 156, eventEnabled);  // Daybook - Scan Mode

      SetHandlerStatus (wiTransLine,   18,  eventEnabled);  // Transaction Line - Validate General Line
    End; { With CustomHandlers }

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
Var
  UserDets : TUserData;
  ErrStr   : ANSIString;
  bContinue : boolean;

  Function WantTransSecurity : Boolean;
  Begin { WantTransSecurity }
    With EventData, Transaction Do
      Result := (thInvDocHed In [cuPOR, cuPDN]);
//      Result := (thInvDocHed In [cuPOR, cuPDN, cuPIN]);
  End; { WantTransSecurity }

Begin
  If bPlugInEnabled Then
    { Handle Hook Events here }
    With EventData Do Begin

      If (WinId = wiTransaction) Then Begin
        // ----------------------------- Exit Account Code
        If (HandlerId = 6) Then
          If WantTransSecurity Then Begin
            // Ensure Settings object talking to correct company
            Settings.CompanyPath := Setup.ssDataPath;

            // check to see if user allowed to edit transaction
            BoResult := Not Settings.ValidUserCode(UserName);

            If (Not BoResult) Then
              Application.MessageBox ('You do not have rights to add transactions, please cancel all dialogs to exit the transaction', 'User Security Error', MB_OK Or MB_ICONSTOP);
          End; { If WantTransSecurity }

        // ----------------------------- Before Store Trans
        If (HandlerId = 1) Then
          If WantTransSecurity Then Begin
            // Ensure Settings object talking to correct company
            Settings.CompanyPath := Setup.ssDataPath;

            // Get User Details
            UserDets := Settings.GetUserDets (UserName);
            If Assigned(UserDets) Then Begin
              If (Not InEditMode) Then Begin
                // Adding Transaction
                If (UserDets.UserType = 0) Then
                  // Global - Display popup for Department Selection
                  Transaction.thUser1 := SelectDept
                Else
                  Transaction.thUser1 := UserDets.DeptCode;
                Transaction.thUser2 := UserName;
              End { If (Not InEditMode) }
              Else Begin
                // Editing Transaction - Set Department Code for non-global
                If (UserDets.UserType > 0) Then
                  Transaction.thUser1 := UserDets.DeptCode;

                If (Trim(Transaction.thUser2) = '') Then Begin
                  // User Code is blank - reset to current user
                  Transaction.thUser2 := UserName;
                  Application.MessageBox ('The User Code on this transaction is blank, and has been reset to the current user',
                                          'Transaction Validation Warning', MB_OK Or MB_ICONSTOP);
                End; { If (Trim(Transaction.thUser2) = '') }
              End; { Else }
            End { If Assigned(UserDets) }
            Else Begin
              ErrStr := 'Cannot find details for ' + QuotedStr(UserName);
              Application.MessageBox (PCHAR(ErrStr), 'User Security Error', MB_OK Or MB_ICONSTOP);
            End; { Else }
          End; { If (HandlerId = 1) }

        // ----------------------------- Transaction Security Hooks
        If ((HandlerId >= 150) And (HandlerId <= 156)) Then
        Begin

          if HandlerId = 151 then
          begin
            // Print button hook
            if bPrintHookAlreadyEnabled then
            begin   //PR 5/10/2007: This section should probably be changed so that we take account of any result from an earlier plugin
                    // ie bContinue := BoResult;
              bContinue := FALSE; // Any other hook before us has priority (i.e. authorise), and they have already set boresult, so don't bother continuing.
            end else
            begin
              boResult := TRUE; // Default "allowed to print" to TRUE, as we are the first in the hook chain
              bContinue := TRUE; // Since we are first in the chain, we can set boresult to what we think.
            end;{if}
          end else
          begin
            // other hooks
            bContinue := TRUE;
          end;{if}

          if bContinue then
          begin
            // Check Transaction Details
            If WantTransSecurity Then Begin
              // Ensure Settings object talking to correct company
              Settings.CompanyPath := Setup.ssDataPath;

              // Check User Code and Department Code
              UserDets := Settings.GetUserDets (UserName);
              If Assigned(UserDets) Then Begin
                // Got User Details
                Case UserDets.UserType Of
                  { Global }
                  0    : BoResult := True;
                  { Departmental Manager - Check Department }
                  1    : BoResult := (Trim(UpperCase(Transaction.thUser1)) = Trim(UpperCase(UserDets.DeptCode)));
                  { Departmental User - Check User Code }
                  2    : BoResult := (Trim(UpperCase(Transaction.thUser2)) = Trim(UpperCase(UserName)));
                Else
                  BoResult := False;
                End; { Case }

              End { If }
              Else
                // Invalid User
                BoResult := False;

              If (Not BoResult) And (HandlerId <> 156) Then
                Application.MessageBox ('You do not have rights to view this transaction.', 'User Security Error', MB_OK Or MB_ICONSTOP);
            End { If }
            Else
              // No security on transaction
              BoResult := True;
          end;{if}
        End; { If ((HandlerId >= 150) And (HandlerId <= 155)) }
      End; { If (WinId = wiTransaction) }

      If (WinId = wiTransLine) Then Begin
        // ----------------------------- Validate General Transaction Line
        If (HandlerId = 18) Then Begin
          If WantTransSecurity Then Begin
            // Ensure Settings object talking to correct company
            Settings.CompanyPath := Setup.ssDataPath;

            // Check user is allowed to edit transaction
            BoResult := Not Settings.ValidUserCode(UserName);

            If (Not BoResult) Then
              Application.MessageBox ('You do not have rights to change this transaction, please cancel all dialogs to exit the transaction', 'User Security Error', MB_OK Or MB_ICONSTOP);
          End { If }
          Else
            // Not interested in this transaction
            BoResult := True;

          ValidStatus := True;
        End; { If (HandlerId = 18) }
      End; { If (WinId = wiTransLine) }
    End; { With EventData }

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
